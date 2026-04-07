Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE505FEEF20
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 11:17:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4C416B0088; Tue,  7 Apr 2026 07:17:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFD836B0089; Tue,  7 Apr 2026 07:17:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEC746B008A; Tue,  7 Apr 2026 07:17:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AA1986B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 07:17:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 38D805A230
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 11:17:54 +0000 (UTC)
X-FDA: 84631510068.26.65F449D
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf18.hostedemail.com (Postfix) with ESMTP id 30DE01C0005
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 11:17:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pbYczGNZ;
	spf=pass (imf18.hostedemail.com: domain of elver@google.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775560672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Ot/6cmUyAYlu4w3F36LFgW3QWHoYVPnUsR/JCweN/I=;
	b=WNpTlh230HFKWcL+GMr3T173vFT40mv5xf1xPODvoQ9yz3j/e9tJfwVTH7BN1w9hWCg6FK
	BTJ1YQwoHzqKFE/VJlal3SxmtFKf+nA7qgXkaU1UQK76s1xJEf6ATw5wbfTXP7PsS8ZoPm
	HJPhw8eZykPflma8HRLPcKlo/pyvY24=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pbYczGNZ;
	spf=pass (imf18.hostedemail.com: domain of elver@google.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775560672; a=rsa-sha256;
	cv=pass;
	b=2GQXPZuWnT3fiR3HG9TDooOAKI3em3LR5I9jASzukgHg++RU/02BHUg89dkM+7ngIsilD2
	LkccT6LW3fOVFKMeHd/W/oySOWXrKwZeHg1svnPAEC/IDct4jKDsIzDiQ8bd3iq2D/pcTG
	ZNhd+JsnNL9EQg0UbDUTiPFut38Vdeg=
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-12776bebe9fso193532c88.1
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 04:17:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775560671; cv=none;
        d=google.com; s=arc-20240605;
        b=Ak3zH9HKh9UjgsaSW7Q+Sozy3h6EqG0ii4u9GP2NEmtk02QQ9RiHOnVYXvYUFGGmOj
         0zocC+Tx/Sp5B4t21FNvJKDVI3a/6OGcoRP7Rmgr4nQdAj29k/cVPsIdwmqiOYQUo8A7
         D9b3VDdYnLE78HhkQSuqG5RneKpP5d2OBtGnW2N0xiMDDborVThO5Em5S5UxBbh5EV1J
         SbbHLdQ4gEltKZCuGd7LxQB/GPT4QUFhvR60gmB2ReJ4yhOiHz5u3d3OHTwgO8JyOayv
         eIvxaW+Y+ROvtZT4BC1kwTdL/0/so4f4J1OspwrwBAJI2a3H71TViIdn3ivNbRKz8wMv
         jjmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=7Ot/6cmUyAYlu4w3F36LFgW3QWHoYVPnUsR/JCweN/I=;
        fh=ClIqrTTXr1P27H+G0QraeqgB+0GMeImgjfq2tORH7KQ=;
        b=hpkI0aHk3W+eM+alk6BiI4aKg4GQpoOY3Rf+0WmLe1T3KF47hIQVHh6SgMNiOcrVM7
         FCLWdgdBBYMenblnNFsjykvHQg2noFMKlEJwtbbgDnPcVMpp1O0Msp+rQA1KREpKLk2/
         ESb8tKI5Tv119DlELzCbZxd7/jXbiFxz0PwPUU5OtwwNa9yqMbPfhhxXOygakvaP6kE2
         Lfbrs8Vea69C36idLHkDwQsRusXXCTLmBIMn36A+e2sI+S8nmLa+ya9oXKPp9uwU7oNp
         W3k/BXp9etfyL6has89k7HP+bH1J1rUl1IkT46WKZK8aNxqPrlH4lcaFf3Zn0cOVMby8
         8r9A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775560671; x=1776165471; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7Ot/6cmUyAYlu4w3F36LFgW3QWHoYVPnUsR/JCweN/I=;
        b=pbYczGNZ+Iu1VDSzZHdZg7qgBaWLTWm4p3ctzemiLOuZKQVcfIM/yQn7heuKBOBJep
         ypZEMvvNKgep30RqqCKR+oKXOW3qSM2sqwubaH1C3lRUjfWOOFQTlZbH7Nd+JOtvqCGq
         JSiPpOhQpkEKXcHYY8NaKq6C/J9yy067xTU0hX73mmyZGiJiLTppdorUJfkbMVRJOV13
         wS3D4RBCdzmskWBh9OZa2Lva/wmbteHTzVitkMb97PXU8bYtlYSAjtbnsWZjQTlVrJ8u
         X02Qri4dfKmhH/4fgHi11Id1UfZd+EwQ7oSZnZgsQENvPTIc8auHWOBPms0M7/j//uwH
         Q8Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775560671; x=1776165471;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Ot/6cmUyAYlu4w3F36LFgW3QWHoYVPnUsR/JCweN/I=;
        b=Kh3Mz2iOs9zr1rR1JL4W1HdsBbtUsO6TAARkGgJ1/v/Qyr/2rfnoxWHlrEXQCeD88c
         Gi4IDKDsPwZdKJI3PDpBl7+IrBkaw30Ry37wMNuCrxeIwzI//c1un4L509YAWx/tY/ON
         THqWpvd6gIoEq9c8SnpnBR90ai/O/khAykStRHYGz6YCYLHLH2CdKQ7opHYxzVoFW34M
         d10SmJYelFf3pcdO+Nt1enlIpd/HEeW+Fb1MBO9kiZT9QU4cfK5r8v3B3P9IGvkTkzQY
         lEH9TYJNt2YM79ZDbVxNkCU1W+wnueK7siWT7LhivDp89qty/wxafKNDpOCnxwMhis+2
         lcKw==
X-Forwarded-Encrypted: i=1; AJvYcCURoTO/KtohG4E1h5n8Ew1gzGz0EPYoKjDG2QhnC8Aqx234NqdUi7zCij2oc7JcRVM3csqyragNSQ==@kvack.org
X-Gm-Message-State: AOJu0Ywg3GflrHXP8qtgu1bIKFmnUNGHTIRFsyeiBhQ0sIyaLXrWNfyC
	2leXOTv/ULeVEj9lwIYdx3L9V9SVKoN0yk/26oRmxlIjC8w8RW+cFH1yOmYEmWO3Zq5UkmfebY5
	SP4THqAENn6T+pn1t6VQ/i5cJ0C9ETiiZGQesdvXK
X-Gm-Gg: AeBDievxVSH70m+UImuDqJcnUF7PGqTOo18E4inYWA3PH2eW96qoH0JAUpTPmH0b0in
	MIiWJrXfQu4L5L2FkD3bOOeZseXB5AR9mR6ZyekcCc+8/Fzk7zYKbz2yDAJV0fLhNQiaxk7pfvj
	/+5dF+L/6HOUdlXFGr4W5x/hTDDKQHIn4xIuXs1kx2r0tZRCIM2XEAnhnLsMTKS+c8qIeJzZyai
	xBntmG94SsYjCZJeOPydmtvvZtn4/xBFSOfQFFJbzCtZPJtLELalTWxY/qo1zyW73nDh2h7cDul
	8lFWpJxP2eyw9aQO4Q9XHvR17jldzxFuIoOluOQ=
X-Received: by 2002:a05:701b:270e:b0:12b:fc21:874d with SMTP id
 a92af1059eb24-12bfc218ac5mr4490405c88.19.1775560670230; Tue, 07 Apr 2026
 04:17:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260331111240.153913-1-elver@google.com> <ac9d5O5XehnXRc5A@hyeyoo>
 <d0fe363c-2e8f-44a4-9b64-3fa3ba9a5773@kernel.org> <adM2XVZf1DekahlY@hyeyoo>
In-Reply-To: <adM2XVZf1DekahlY@hyeyoo>
From: Marco Elver <elver@google.com>
Date: Tue, 7 Apr 2026 13:17:14 +0200
X-Gm-Features: AQROBzAgGN0NN5VZKje-TIGicheiDUli6J3RmxbH29tvqb2R9oxdlLQMmt6dDl8
Message-ID: <CANpmjNMeaWWuDMAj_n38U9XRqgZQz30ca82Vy10Bg=NoDfZ5ng@mail.gmail.com>
Subject: Re: [PATCH v1] slab: support for compiler-assisted type-based slab
 cache partitioning
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, Hao Li <hao.li@linux.dev>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, kasan-dev@googlegroups.com, 
	llvm@lists.linux.dev, Andrey Konovalov <andreyknvl@gmail.com>, 
	Florent Revest <revest@google.com>, GONG Ruiqi <gongruiqi@huaweicloud.com>, 
	Jann Horn <jannh@google.com>, KP Singh <kpsingh@kernel.org>, 
	Matteo Rizzo <matteorizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 30DE01C0005
X-Stat-Signature: xtuaeasspiwqsdtzm3guze9hf4diid31
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775560672-592674
X-HE-Meta: U2FsdGVkX18cyVVZ6cfPtz2w5TyJEoV2rY/EWnsdg2PuUxTknfiCkx2UbUpZAhvlF/oVHEoP1e5Q6nrLNKfcdyhkmXwRav21ROtY7gDGnCgvGADtCD8ToESS/Y3QG96lHYK1V+98xHSpxxebRblSSBPvL3m3CxZ7MhRX1BL6iOQGxPMaW0n0rQQG3D1+M80C+TI41oJ/E3jtImptfZrFVMWuDq0gcbxM+9QBGa6YgmvCduaSPrp91+SxCsQ9npnkMFOiuEyjKotLDpk17ELS9GR3opO9AjWQN2InRlpe7WXPNobJm1LcrFLnAm4q9TNJJLl7sjFxs34sih+1/P9VeiGg+Y1pPu3/Y/IlB39cNPiUV9nKuMyioDtbwepdA0mJO+hFpUvFuMe1AXgt6tGmW7dhqrJJMzaW14x7P9cuqssmEk5TnzX0bnVBhboVpKyvnm8rtG0PYNv/XLeiOIKJY50XaQz2B9DsmKhuOZP/DkCsYQ68iRc65W0NepfFXjKxpvf2ZmJjlUT8DBp49yx8naKEhW7TGyHhxDdwKf4vjuFxtJ28krGq/NusD8hFMUpsibn57wChwG5Oc3lSibwyHAdrHU3c1U5EdYhT8mPaLdmdzhqZoTginwceH2zabNAAYo6089bx1RnTS1Ch0wMi5UEs4Gjo5r1bKuHyVDiIKPds+td+mU1Xi3b1e15exm/c5q+iaBp2K7meR0nj34DqlTbkaAsWflacOBBzzFTjaDXG64tB9LILg0bJ/JLe8/+KAnWt8mAHjAWo5t/xWjhejK0GTjlSoGwkbz5ja2ShFheBVSTBFHC43YWhyqLvyeE1p+66yxNrOcbIuCk2M4s4BtkXwpRiWm0wJANe159JPdnx5aMVvuKG4jBftQCoVPrQG+fuLmzZPoaN/zAHNDCTsxR7NlB1zqWxa6nct52EpfrKnqSQhjdN5aWU7k7YLMakR1KVD2oqeCisuqmDb0y
 4SK8Jfvv
 WvjF8j2rZUdspXD1J4HNze9d7Ny9oJwp7QpPa0q8hW6wzolY9le1rWOdvDWKBaYwuaE6/VxStSJnnBrMVYyz5OzYqk6hcT7Ay84neHUxRbPb3cCYy1Bv8Gr751i79JSvtfhgOKFfuv0ZWklc/noEtyYSNvBkWbklqQz10aa2YeUlBlpCrNrDMq5mf8E3PogpK3oCCW+Ee6JL9HXkS943pNcoDrkhUFLERWK8rLdKklQo75kZpOA6zlmno1MfMbDUZDKVKUcJIY9by9q8CSUn7N9j08GSdHv143hqNLc83ODrvrAgl2OtMeOiBVbWqfDAdDpm8meKeNUG1RjWZZTEPIRQVW+EMuO4JjkomPeguycgdv4XMqgL7zUcfZhyIKjM9WadHj1TYxQ3o8dMe3g8+lvmFav1W2q7+J4njrguqM5akpVBg9hoxEEBd36s+Ijqjrd9ZmcBbhvEjm8Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 6 Apr 2026 at 06:28, 'Harry Yoo (Oracle)' via kasan-dev
<kasan-dev@googlegroups.com> wrote:
> On Fri, Apr 03, 2026 at 08:29:22PM +0200, Vlastimil Babka (SUSE) wrote:
> > On 4/3/26 08:27, Harry Yoo (Oracle) wrote:
> > >> diff --git a/include/linux/slab.h b/include/linux/slab.h
> > >> index 15a60b501b95..c0bf00ee6025 100644
> > >> --- a/include/linux/slab.h
> > >> +++ b/include/linux/slab.h
> > >> @@ -864,10 +877,10 @@ unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf);
> > >>   * with the exception of kunit tests
> > >>   */
> > >>
> > >> -void *__kmalloc_noprof(size_t size, gfp_t flags)
> > >> +void *__kmalloc_noprof(size_t size, gfp_t flags, kmalloc_token_t token)
> > >>                            __assume_kmalloc_alignment __alloc_size(1);
> > >>
> > >> -void *__kmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node)
> > >> +void *__kmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node, kmalloc_token_t token)
> > >>                            __assume_kmalloc_alignment __alloc_size(1);
> > >
> > > So the @token parameter is unused when CONFIG_PARTITION_KMALLOC_CACHES is
> > > disabled but still increases the kernel size by a few kilobytes...
> > > but yeah I'm not sure if we can get avoid it without hurting readability.
> > >
> > > Just saying. (does anybody care?)
> >
> > Well we did care enough with CONFIG_SLAB_BUCKETS to hide the unused param
> > using DECL_BUCKET_PARAMS(),
>
> Hmm yeah.
>
> I wasn't sure if we could do this without hurting readability,
> but perhaps we could...
>
> > so maybe extend that idea?
> > I think it's not just kernel size, but increased register pressure etc.

I'll take a closer look at generated code. In some cases the compiler
ought to omit zero-sized arguments, so I want to be sure we're not
prematurely optimizing and the size increase is not some other effect.

> Something like this should work? (diff on top of this patch)

Thanks, I'll consider it.

Re your other comments:

> Assuming not all people building the kernel are security experts...
> (including myself) could you please add some insights/guidance on how to
> decide between RANDOM_KMALLOC_CACHES and TYPED_KMALLOC_CACHES?

You can find different arguments for either, and in the original RFC
that was part of the discussion. However, my biased view is that
type-based partitioning in general is the stronger security boundary.
Because it creates a deterministic separation; specifically isolating
pointer-containing objects from pointerless ones: it effectively kills
certain classes of exploit techniques that probabilistic defenses
(like randomization) only delay, especially in environments where
attackers can retry or use side-channels.

The current pointer/non-pointer scheme is relatively intuitive with
well-understood properties, and a good start. However, an open
research question is if better alloc-token ID schemes exist: one that
is tailored to kernel data structures that would meaningfully increase
exploitation difficulty further without increasing the number of
partitions. Since an improved scheme could simply be activated with a
compiler flag, having the baseline infrastructure available and
maintained is the first step.

> Now somewhat out-of-scope (or at least pre-existing) review comments
> from Sashiko that I think are still worth mentioning...

Indeed, these are pre-existing issues with RANDOM_KMALLOC_CACHES.
Worth follow-up patches, but this patch here wants to just get the
TYPED_KMALLOC_CACHES infrastructure in place so we can build on top of
it.

Thanks,
-- Marco

