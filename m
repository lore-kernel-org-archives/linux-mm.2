Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 474DDCA5FF0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 10:17:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE94F6B0088; Tue,  6 Oct 2026 06:17:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E99C16B008C; Tue,  6 Oct 2026 06:17:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAFAC6B0092; Tue,  6 Oct 2026 06:17:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B34566B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:17:17 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4A9E9C0427
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 10:17:17 +0000 (UTC)
X-FDA: 85291798914.28.91E46F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5E51E120005
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 10:17:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fjqGp+H/";
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791281835;
	b=LAeJ7Bzg2UALQ0uioX1hP+i8gBKBnOtGNRYQ1xNAWOdcHr68RaKz+KiMPRlNzkUxRYEhlN
	dxk1kIn/KXvWhs0Bc0iW6Gx96ZPrawnkpMPwD8NrhQgdWsGB+69Ux/Xbwo9+bdebqDbRWu
	o5m+NiqTrwuujczvOrDdVkQcBIOuoqI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fjqGp+H/";
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791281835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YmX2e33OtnyC8Zxmc6TiwfeqHnZc+9E9szDbs6SS/Jc=;
	b=5E06hKJSuvCZctJnt5P/9TDrvDshUsAevWYVON75xXvQNItgPHJJUOaFZr4nfCedKoRFdQ
	wKPOfVnmo5gOVF+4BCyYkmka3TmOJoa+XwOS9fKzOSGm3NWDENRjwyb5THKkw1VRvNX+0o
	nQ8kSZCF2PStEcPdIl0M+JwF3rDHwBo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D6FA43F48
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 10:17:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626361F000FF
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 10:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791281834;
	bh=YmX2e33OtnyC8Zxmc6TiwfeqHnZc+9E9szDbs6SS/Jc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=fjqGp+H/NMcqXRHqNX9hJ3U35OYZBK3lYTsNnTk6HmQRjMFfWv3vREk7IE+ji51tF
	 7ju8O2LAm3gLX4Chsgtp5ysz7IXw0HHhb1cbLG3Bb8+WuObBfvZjKeQ1mQLe6zzR2f
	 ge/bW5cX6muyHXBfKAYhnc8ld1nchS5ZdbZPvCngcoTevDThcJbMP8EODgFPWxCs6L
	 bGoC+nYKYERj79Fnh/mv9F+HujyGExO/Ln4I2EyUmomS7GMUT38QAytv4HKuFv71B6
	 R2Y8HGxk5ve22a6MhgmohQJUAIoKRHuEN2wXir6uP46pKYbYlUTYECu0Qo7OtwaR6y
	 dSAU4kzLpVLwQ==
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-93c5b7f5bfaso177564385a.1
        for <linux-mm@kvack.org>; Tue, 06 Oct 2026 03:17:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwxMkhVdYq2d2TWpfxIMv6fKAwr7sxmmzvh44bvtpsqW70bivI5SCArEWvs3RBzMS7IEHhaG4a4rA==@kvack.org
X-Gm-Message-State: AFuF++mBy7xxCGyVEaaxWCL23rTQdJGE8TDucWj1b1UTChF59dH87yQK
	YcxKtOEDY0S8NDjwgmJSmDstwXgfYghG12YBbpEeCh8Oq9EwASXI66/PCfREtv6rIirTWHoP+PM
	AoyJi21ZIv65V2uK03ff+M/7IhgTlKdA=
X-Received: by 2002:a05:620a:298c:b0:93e:60b7:eb1c with SMTP id
 af79cd13be357-93e8f30e9bemr133098185a.8.1791281833664; Tue, 06 Oct 2026
 03:17:13 -0700 (PDT)
MIME-Version: 1.0
References: <20261005062236.564210-1-vernon2gm@gmail.com> <CAGsJ_4yKSoCwcEDhtd=biKoUjUX9eTJJhFJGFAZWc=WsAyXycg@mail.gmail.com>
 <4cdb95f5-4140-4116-8247-c04f4b2a5c4c@gmail.com>
In-Reply-To: <4cdb95f5-4140-4116-8247-c04f4b2a5c4c@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 6 Oct 2026 18:17:02 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x3n1g1tqxFnnLj8mS46fyYNWQq6goqop+_2QoKO09eeA@mail.gmail.com>
X-Gm-Features: AclHuK8lN8z7X7d6APZTpemSkGo0Ao6gHmfTzep6EKwyapPzIeCYDccx1RXySzg
Message-ID: <CAGsJ_4x3n1g1tqxFnnLj8mS46fyYNWQq6goqop+_2QoKO09eeA@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscan: don't count per-node proactive reclaim as
 memory pressure
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, 
	hannes@cmpxchg.org, mhocko@kernel.org, ljs@kernel.org, 
	roman.gushchin@linux.dev, dave@stgolabs.net, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: s3khw6qg4m37546c3a44nm5say9i3yuc
X-Rspamd-Queue-Id: 5E51E120005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791281835-191630
X-HE-Meta: U2FsdGVkX19H5DIsksMsD+veIDiV7cOOpJXPt1PYtekbQy+PHghfFzOcYwk9L3zpJoqTxMcdVNBhzx3VHVRPvEBI5/rViLbvdRYXFpvwfy+wFgKG8ZLrOLvIIFThZLhrgt0Z6/QjoLQk9RSJP0RuSquTFO9NY4P3qVDstItYMiOL9h062o3kwtJyoUoQDosD3Hbdx4ddvubyWZGtHnfWRijz1yZjEWg/ngmhXnhL5k+RcsKDipYXRp3elDHjTUqzSqD0axU/6mi9SEQSxN4Ff+AcNvkMFxny3I24w3TYSvN0971n08d0hE4AtCTITflb7tCfbkAex3FOCp+KOeX0vgoCtZek630zOwBjBuH0h2W8alldiEDmP8XpOig7RpHdtyka+6x18mUi4CrmmDoqjzq2eRrydZRweQn76qMLmu6mShKJT24/VU/ggVEEYonnEh9zPj33QgorHEP8gWTem3B0qVAgZupirrf6KHnZi7BNZ1YtflfVBftg4VK8tAdA3m+spNJ39hgTDj6yeWDfqoGI3FHSY4t/SVxvXnhu+i4B+ORAJzVC+Az2HJheo9zjbJlLW4w+aXCL9wbAxskasERLlM5/AklzXcuomZ9flCLIZokSA+QZ3jKxS/Ky53/UB0fCWMz4VVJi4wZrzp72XGFLrnjRPhBmKAAhj5PjT+KSomjPj4zhD/x6Xa83kJzGauCOVU31pPDRz2GNdVAk/9cTMa+CTGK/r7jrlV2LWtgd9IcDF9NdGVW642IRNRNGBOd6GmtwpsUQvMX0ckXXxy7dOWX9EKUFn+H3G+Lp1mTxj/wsdd71o+s3l9dJV175C+ONL+nWiBMzzjufc/b1rPxVuTn2nIUmuEaGeo/v4zmnmbE0XI+VF4FjUAT1qoO1cORk2nDNVLaKPWbvek2/viVZw7dcTiQO8LSfbdc64fk0+qYvz2Ozcu+UyP50DAHD7NxKJlP5TmZvdl2L4Q7
 U6Rrc3p7
 aQ4fNOa0bUVNFIjeygigl4ir4cxNJiYCLFGLN+IzwGzgJoMk2BvPbjYoBHAorxmn6kgLmK1IAhcZHVawC9K14XwObWz5bZc9vYjwcbqPMHKOcJHKttIjMMzvjrSE2F0QdpRgHOgdSi6WXdqY+veOF9KEabUjfxE+12PMX/pLn/NMQTCZpCdS7CZeHppZvaWtEkQ4D+RuU+ae2EI5PC6W+wvAVEU3wMcpCxp0l2nymg6TCG0wbpOfkePb9kRJGbUy12ED7V5g0+9FBfl9uaPI3iBzWD7uTS48h9zNd7R+mgVj6M5z6fXuy7l8BwNhb/Vh1hnOamgNl6vleheQj+zLmcNcR2hnc8aRZEwoDVTlY8yTXf6Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 5, 2026 at 6:21=E2=80=AFPM Vernon Yang <vernon2gm@gmail.com> wr=
ote:
>
> On Mon, Oct 05, 2026 at 02:30:36PM +0800, Barry Song wrote:
> > On Mon, Oct 5, 2026 at 2:23=E2=80=AFPM Vernon Yang <vernon2gm@gmail.com=
> wrote:
> > >
> > > From: Vernon Yang <yanglincheng@kylinos.cn>
> > >
> > > When the cgroup has no memory pressure at all, writing to
> > > /sys/devices/system/nodeX/reclaim triggers proactive reclaim on
> > > NUMA node, causing increase in the writer cgroup's memory PSI.
> > >
> > > Due to this reclaim is performed in the context of the write(),
> > > accounted as memory pressure on the writer, like
> > > commit e22c6ed90aa9 ("mm: memcontrol: don't count limit-setting recla=
im
> > > as memory pressure"). This is unexpected, the phenomenon resembling
> > > senpai will appear again.
> > >
> > > The Documentation/ABI/stable/sysfs-devices-node documentation also
> > > notes that "This interface is equivalent to the memcg variant."
> > >
> > > This patch unifies the semantics of the memcg and node interfaces:
> > > per-node proactive reclaim is no longer counted as memory pressure,
> > > and the per-node proactive reclaim interface no longer produces
> > > phantom pressure.
> > >
> > > I ran demo[1] that performs per-node proactive reclaim 10000 times
> > > in qemu, writer cgroup memory.pressure as follows:
> > >
> > > without patch:
> > >
> > > some avg10=3D31.53 avg60=3D13.42 avg300=3D3.31 total=3D10602985
> > > full avg10=3D31.53 avg60=3D13.42 avg300=3D3.31 total=3D10602985
> > >
> > > with patch:
> > >
> > > some avg10=3D9.59 avg60=3D3.41 avg300=3D0.81 total=3D2686221
> > > full avg10=3D9.59 avg60=3D3.41 avg300=3D0.81 total=3D2686221
> > >
> > > [1] https://github.com/vernon2gh/app_and_module/tree/main/reclaim_nod=
e_psi
> > >
> > > Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interf=
ace")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > > ---
> >
> > This seems to be a valid concern. Personally, I don't like
> > having the code depend on whether `__node_reclaim()` and
> > `node_reclaim()` are called from proactive reclaim or page
> > allocation.
> >
> > Can't we check whether `sc->proactive` is true? Am I missing
> > something?
>
> It is also fine to directly check `sc->proactive` in __node_reclaim().
>
> I chose the current coding because a previous similar fix commit
> e22c6ed90aa9 was written this way, and it is also very clear.
>
> Of course, it depends on everyone's preference. If everyone prefers to
> directly check `sc->proactive`, please let me know clearly. Thanks!

I personally think the following is much more explicit than the
current implicit code based on path dependency. no?

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6a931b576b7d..048ba11852fe 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7997,7 +7997,8 @@ static unsigned long __node_reclaim(struct
pglist_data *pgdat,
                                           sc->gfp_mask);

        cond_resched();
-       psi_memstall_enter(&pflags);
+       if (!sc->proactive)
+               psi_memstall_enter(&pflags);
        delayacct_freepages_start();
        fs_reclaim_acquire(sc->gfp_mask);
        /*
@@ -8014,7 +8015,8 @@ static unsigned long __node_reclaim(struct
pglist_data *pgdat,
        memalloc_noreclaim_restore(noreclaim_flag);
        fs_reclaim_release(sc->gfp_mask);
        delayacct_freepages_end();
-       psi_memstall_leave(&pflags);
+       if (!sc->proactive)
+               psi_memstall_leave(&pflags);

        trace_mm_vmscan_node_reclaim_end(sc->nr_reclaimed, NULL);

>
> --
> Cheers,
> Vernon

