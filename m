Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF3C4C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 11:24:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBE806B008C; Wed,  2 Sep 2026 07:24:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6F3A6B0092; Wed,  2 Sep 2026 07:24:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5DFC6B0095; Wed,  2 Sep 2026 07:24:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7E77F6B008C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:24:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 109CBA01BC
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:24:35 +0000 (UTC)
X-FDA: 85168589310.27.729346F
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3E49180002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:24:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=i9Qv1t8P;
	spf=pass (imf30.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=imv4bel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788348273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EoF4ak3efS2qg2JAezlyYbqCdyBis11tVKnPB5qs/Aw=;
	b=j/TiJ17Ttt2H3OZsvnSPVD/41wFQrnJBWZYxyW668lpnti2sZW1nCRlX1N4LqwwfQ5tRvY
	mDhu25cZOBHDACyK6FqQX9V+sQzcNyW99tPI+JkLZldyfGz2WjkgJgyif4Ncps4+T8pkMf
	KBspsefgx2D7kf4UD4dok57wa6p6VeU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788348273;
	b=Kt9V6BkgKwiSb1cZJCqZHNaExZp6I4JPLPnsdt/ihMtJ5owFEB2jSWbZpiblyt/2IkkR6f
	ZGddvFTGO5drv1L0uti95uVsZwrHWdgn0RdIwGZfneIQXwyFRGESgIJ4BxYFnENk3QfI2S
	xpLQMiXA8409Yx2s0cXk/zbypfyUJDI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=i9Qv1t8P;
	spf=pass (imf30.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=imv4bel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8518b3ff3e9so840623b3a.2
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 04:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788348272; x=1788953072; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EoF4ak3efS2qg2JAezlyYbqCdyBis11tVKnPB5qs/Aw=;
        b=i9Qv1t8PFTRBXkFlwJtIo/cEjex4GTvuI7VdFY1VxjaiwynvQbM+Ozfa9Ry1qoBBam
         N6Bt6N2+FHZ2A4zDiljDYrQavm1AetdcJyBe25ahRkWlQUaKvXlhak6WbGSSuZ3PB/Cy
         LPcB02+ZXFpROTLpW/IUWzSlpZ6c4GVPkueaNZTKTtnpwXQd6Xh2uToA+o8weODNe1EX
         cur1LdFVAkAxP8xHyQQGOuQ3MVoDCip9R/zQOnqnfXLsxcCyMeGrVtIhMNecoMJLa71+
         A7MpdXu+vUtLtHbkeKj86JS9h1Oql1rC3U3XDrV5PrkEoWmgHS6BZiRIq0IgTuGfo8Rd
         ZauA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788348272; x=1788953072;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EoF4ak3efS2qg2JAezlyYbqCdyBis11tVKnPB5qs/Aw=;
        b=T492uOzEUUZnIaER3of3ghiXe82vhQWGL9JWmnv1/KMaLx7OB+elgGAh+KtKgF5Nzu
         6hsqh8gjB3Pfw8HPDz6tfmS5HyqXAcowKIKR44Q8KDaVqGGhV4jwpqezlhAl+Kpxv1hO
         dI9CO62XBHtKD36tAMeVLUNN1b+JoJt1kWVDLd+aYY7noSxB6qYwz3KjOS2gImaAhQbu
         tbiCbad++Dw2iO3aHSgQYuHF+4JVW7MIAxOhuwuZWkLJ/UQq6g7VokDhNAzfjWqUTko3
         ljbjxXFMmpGD0rTQWsMmLceW3erWBRlkzbE9MgmeBeh0pwe70lw/WCN+BrQ1N9kaa3VN
         1eNA==
X-Forwarded-Encrypted: i=1; AKwUvBxmvkOx9xe3DH2z09KsPWEoo0NuPrl/t+/dkgV6V4fgskgpwJrYvpzo0MdnEBQAS+CIX2YFMJjo5g==@kvack.org
X-Gm-Message-State: AFuF++l/o94sKY+uKJuZ2cZM/tG2eYqoJfascMEs7hBZthHoCwlzgw0D
	AATySBOYtRqNJqv8Jb3dddCdwNT9BHxrhQ52Vmpnl0HKe9MW8CvOBBhoYmzrNw==
X-Gm-Gg: AYBFou0j/ltJj9rP18Fd+9yJ6jVBnzYFfRgVl5bJLn3W4F3N+Z8K03YLRYtop+I2l+F
	zQKNVosC6YS60TeRs6q5cblaJoMq92Hzjd5R7uIoWzJoRpv1BgoNsOvvaxRWns51B5b3aasQH1z
	vCoJfhqRo7Vt2Uy0/qc11uunuQaaHT9lgOUfl1Do6V4vEyYoNDwjfDNYmuoRWK5r8wAikrruFOd
	THV32HtsHrshzRPTQRXsHZrIqMkCYV/hRC+dbhETZL/g7PzWMKpd3t/9amFtxzZNoimFupwXWo/
	RVZn2ZRknRrduCyH4pjrRzpQ8DrIiS7+EoTOVBReN26YPHSEzxmzVmH5a6NOas2Oa7d3l464pQ3
	USrT5wcY7iMZiiBzX8pr/VN6wEsdNbJactF8WWMVuGomBHZGkNusaYwwuggkSW1a4L3Nl3geBhq
	EqYsW8h/TUo2vfjU/7qXxk4Zvx/FilVsaL8AdkZK5Pptjsgd3O7KBcclMUyh4i+2Skhqrl7kJ95
	wWtCZW6
X-Received: by 2002:a05:6a00:1f11:b0:857:72ba:ff11 with SMTP id d2e1a72fcca58-85ed4c1b6ddmr7146177b3a.25.1788348271985;
        Wed, 02 Sep 2026 04:24:31 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85dc003a7d6sm1186334b3a.34.2026.09.02.04.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 04:24:31 -0700 (PDT)
Date: Wed, 2 Sep 2026 20:24:27 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: Harry Yoo <harry@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, imv4bel@gmail.com
Subject: Re: [PATCH] mm/slab: take n->list_lock for the list_add() in
 __refill_objects_node()
Message-ID: <apgHa1tISzqsnc_C@v4bel>
References: <apPa-cGLcyt90l-E@v4bel>
 <apQU8wjMlvbKBQgh@dev>
 <apQ7osHcRj3vdJPn@fedora>
 <ae25c193-b95f-40c1-83b6-1c2546467e41@kernel.org>
 <apgE4TWLFGoqoOos@nixos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apgE4TWLFGoqoOos@nixos>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3E49180002
X-Stat-Signature: ex6krjw37njnqcigjbsyjowfyhdf55f8
X-HE-Tag: 1788348273-402981
X-HE-Meta: U2FsdGVkX1+r8vuAOkWdLUcJMGyNgDFioI4PVfKAObVzT24t+K8/lbMfMSBPWsJvy2/pls168MDTdhR/inS+1eFP8oOPYnaQbht6ea/VTji7HrfcJhqYbarFJxmEHH34sDc30WB30i2DQ+iR4ne4XiYyePkAVoOADAHgC6Pskl5Sa0MP8eo62OdWYl83jH0oLrts1jpA7L1ai527uK/b7yJt8L9EUzGq/O/q6/G1zsMp78WgYB5cbE8A2eSaiHL2uvdKVksmbYFf0IJB2Uu0uAvj8YbFOmYeTnfUodNLcW9TtLiV8czOLQoE4k/+7pkawRE1sg2FXnGaPKkvoAWWLbG6QD3U6waLzub6kdjJUHauiy8Q9KjsjuSBYPOELPA7w0Qj9/D5nzTK/l96zIrjKOLho8uSV6TMs37YMvRwmLkXkPcZtA6CJ45bs8NTsjYu6s7j2gv5jtXWT3Vp43ODzrL83hUAG3uajsJYoW4D21QWbGdedAB5jfNi83cU808Mp6KrJgQpkCL6FdPoibC2sfq6Bs/b0hoHP6BtmPFeFZDh3ohQnbsiOC+yhgrYqXrIInuzGk3+tP0RTgwlbb+K3GeoHJ4JYTVuPELUkdgxqxQ5fxdV37ABUd+pHzP6izfqSB8u2D30DBiDWNmARqq8sAU1d6EvgO53BkMBE/vWrIyK/7qwtNxrHfs3g76OHHshKfX9+tWKygUq96/clacZGTvsaqTNabTdcNq2R5LWcfqlNcd8oS4XIOO3QUsnaFk14HcGPFgJcL5PUAHHpv1PwfaPxBB7Fc5BgEZ6X6BXW+sR9aOXYT3tKDYXNfq0niLv3bmeJRiFODws7bh2okKIZZCzdQG5pRUt76xCGcOf8GHPiYvA3xbKpJhTG6s1QsyaCU+1Dq1ZfNs+fdiFjydyQhgiE7DWJS7Rlgc4SP8Peb4C4VOABJvwrgNpSc84qv7JrmxrDHdTVhhrpena3Dr
 llYrUkO4
 /X8ft5bDm64EXqbRyoC0B5zDGxPqi0nF6RgSL+9gDT3BzNcvy4KMA63HMyMYzNai0mEfaZ3P+SEMowyRPOFstTLFzJ7PgV4U+NVHXwWR/t3aJYygHYPDMALA4FNGjMM6VK7Acp9aCtgKg1HLcvSlOQfay/UyLBfeBFaa4owzA0uAkikucFRy7DzmEd2CmytzCGSc5f87F2W4xbFrM1XdTMKe3f2ZHXUf1ov/UKbTiwbao+MQaSM12z+6ETHjkiK9Cor05Bflijuo/ZisQEFuBBJfBiNitQP7i7MFxVUSQONBThmM2b8+bdoWsokkgiwS8Bu2r6+FXibVFbmBaVlFL0QMwe4tFdP8kiYfmR2BN+rlo5pb7qs2ensPHhYA1kS5Nrv7aPZOGd9UTmNqBwP4LIOIQDRV+j+IKYTmyZ306EN2e27OB3UDPON5yLnb2ZdC+vlEoY8S8OlxVdueoYdjWKMJiAYkiC3gp+brpx6BWkKgVGdh1flxsBPWgfaNzFau6uOTN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 12:20:34PM +0100, Harry Yoo wrote:
> On Mon, Aug 31, 2026 at 02:55:06PM +0200, Vlastimil Babka (SUSE) wrote:
> > On 8/30/26 16:35, Hao Li wrote:
> > > On Sun, Aug 30, 2026 at 12:45:17PM +0000, Harry Yoo wrote:
> > >> On Sun, Aug 30, 2026 at 04:25:45PM +0900, Hyunwoo Kim wrote:
> > > Since introducing a new variable seems unavoidable, what if we temporarily
> > > stash this slab in a pointer like below, and then add it to pc.slabs once we
> > > acquire the lock.
> > > 
> > > struct slab *leftover_slab = NULL;
> > > 
> > > ...
> > > ...
> > > 	if (__slab_try_return_freelist(s, slab, head, count)) {
> > > 		leftover_slab = slab;
> > > 		break;
> > > 	}
> > > 
> > > ...
> > > ...
> > > if (!list_empty(&pc.slabs)) {
> > > 	spin_lock_irqsave(&n->list_lock, flags);
> > > 
> > > 	if (leftover_slab)
> > > 		list_add(&leftover_slab->slab_list, &pc.slabs);
> > > 	...
> > > 	...
> > > }
> > > 
> > > PS: If I recall correctly, Vlastimil's initial patch was actually fine. It was
> > > my suggestion to save an extra lock/unlock pair that accidentally led to this
> > > trap...
> > 
> > Ah, thanks for the reminder. This [1] was the original attempt.
> > 
> > [1]
> > https://lore.kernel.org/all/20260421-b4-refill-optimistic-return-v1-1-24f0bfc1acff@kernel.org/
> > 
> > I wonder if the fix should be to return to that approach and just have
> > __slab_try_return_freelist() handle the list_lock. The code would be simpler
> > with not "bool locked".
> > 
> > It should be really very rare that we would end up returning a partial list
> > and also have additional slabs to return on pc.slabs? So I think there would
> > be no noticeable performance downside to the simpler code potentially ending
> > up taking the list_lock twice instead of once.
> 
> Agreed that it should be rare and not worth the complexity unless
> we have data to support that.
> 
> Hyunwoo, would you please adjust the feedback and post v2?

If you don't mind, could the maintainers handle this patch on your side? 
I'd then move to Reported-by:.


Best regards,
Hyunwoo Kim

