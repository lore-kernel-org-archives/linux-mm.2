Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6432EB362E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 18:51:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4F796B0005; Mon,  2 Mar 2026 13:51:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD3846B0088; Mon,  2 Mar 2026 13:51:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADFDD6B0089; Mon,  2 Mar 2026 13:51:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9EC436B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 13:51:31 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3B3305820E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 18:51:31 +0000 (UTC)
X-FDA: 84502016382.27.B5AF7CF
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf14.hostedemail.com (Postfix) with ESMTP id F2DB0100006
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 18:51:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=FU6TgQyQ;
	spf=pass (imf14.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772477489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5JQ76xqporR72La0Gtzvw92CKKW0Qc86jR/6DhxsEDo=;
	b=1Qxe3v+geleVjl12E4qo4GMeq5TbF7xnXK6K33LCcjqMzwfEELXXE2CcGn1E1gFVzHWJbH
	0gYS0YkMEYWP1lmcfUHtxWjJvdNd+tQ23cnFYYdeY1Sbgbt+vI4Lyns3OVkp/IaVEGcir9
	2DT6xKMAN3Hj4fdN4eJrdQ2ASh+OdF8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=FU6TgQyQ;
	spf=pass (imf14.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772477489; a=rsa-sha256;
	cv=none;
	b=gvZhj7LNN+k2x+QXmiaU86iGGK+DERcQX3bofkxvr4BHAAwQ+KYxCO6GNB/35vO8Kcpm7d
	EvUCCmD+uas4y96cQAc167CE+QDofh6hR8Ryf1ImixrQNsbjryhKCpMRPyVT0PkXIHhCTT
	BJ6OSc87cWWLxt1/ILamLHCffD7kMEQ=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4836f4cbe0bso41231615e9.3
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 10:51:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772477487; x=1773082287; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5JQ76xqporR72La0Gtzvw92CKKW0Qc86jR/6DhxsEDo=;
        b=FU6TgQyQ6+Fx9wDQaKo7NiBtwHuqNCDJzo+WOiarMH99WIsG/Dzyw+UFDMe+JgM7d9
         3TNIJT7GyNF4d9IvvY1Fq6uU4LirweVDwFVH/d0SoCLWfCjqCFzvGzr1c1fbSGpKyyvZ
         xCvP3qKvZPSL2Ohaf17s3Dpai4hC/RFRNCloxhVItTV/qYbH3gTDCD6Y89tXz/c51Zzo
         m9daDxwCX0VTFnzat9yK7RXWZC6aqNQn7WLRB7ocSws7VxbcC126Hy/VGUaQeiDEKWUm
         UCIL7sAgs9/+c89TGrITqO9U3y4O4hkLisW/ob58dkj76sNmKcFSvdO2YjAEGb5piMFM
         /S6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772477487; x=1773082287;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5JQ76xqporR72La0Gtzvw92CKKW0Qc86jR/6DhxsEDo=;
        b=I0bridhx3Ex+K27cBTjNMwfsnuHhriRhL7VUlwYmHCkWBQQyvG8NSIpLnTd+I+Bs+d
         wudJt8avBAYqR1dTAmzumITFT7ai9p4f1ZrxwuOtWG+5vUtocCVWFDQPP3ZRQl2kiQDt
         e9fng48HnjbTA2zNZVLLeep6BVB8iFIBO3GXss20Hy3HEdthe3l2tnVBBx8dbNyKkGBo
         uAw20shULzG088hHONbomayrTdeghx+j566hV1+Z6/vVE40Zo5ndy7JzxRJ37Cm0N1Jc
         hk7pTyb7IqAEdfrPdC2FKlKiw2XPUur0npr6CP0QAAE1uMkZj3TGeaCtXzBiXZw53Qbv
         1SSw==
X-Forwarded-Encrypted: i=1; AJvYcCWz+bd/5MaKZgqGiZSi9OIXU+gsF52PL9Cwbn2xEcGDaL8AWN49S5GcW/KbumsY+0nygiSSKVvu+w==@kvack.org
X-Gm-Message-State: AOJu0Yx1zOV2kMWliXsaQtrAqGygXhh8m7EKiH1eUTZmNC5syQbm0NW6
	N8XLpAt6wy9K/G9+TXE89k0+eStcSNOZskPmIq+pWALM4HMyNRPkQjJ4E4kXedMRCX4=
X-Gm-Gg: ATEYQzyJpr6TyKfKtAGC9GNLov+8mwNxtpZv48PG0VMb5zx5hDnNCObiXNINMUN7QWz
	ZQ5gUeqr6mGE5CsOwtsnalPEI4zgIOBxYuiXQd3+xAAV3ZDP25OD+rR5xy0SFqsuR6O9x9TPUXE
	iDq03qMshv9nBtyrsL1Qm5IUkHrAXPxN/QPn6xx1SVx/SqpDEt9EbWiIX+7r58h5zwzSdaLZEFh
	oHRJWpVUHDlRqNPnYT65bn0f7sZELzCMLkvuiQt6FZsA2rZa/iUULLWff2HhU+xp7RPvhIWRH89
	6B9ha6upDvq5nbA32ESLR2mw9NbCSxJsPtlBlXYlwhgscpelNAEXFJYF1ZXjSN+q1CE6GiH7SDv
	zQRUK2gL0D5n5SEg7O+aAkgqn4P9t5zcsUKkTwHYBS01y7f2wXinRCgEBxQcDYMTSL+55PEcHgV
	o36N1B9os33K/nn7L8ol5ftcafWbYTGKZDwgx46fZIee9HyJE=
X-Received: by 2002:a05:600c:4e05:b0:483:b505:9db7 with SMTP id 5b1f17b1804b1-483c9c0b940mr203343295e9.32.1772477487242;
        Mon, 02 Mar 2026 10:51:27 -0800 (PST)
Received: from localhost (109-81-20-148.rct.o2.cz. [109.81.20.148])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bfb87030sm136547875e9.10.2026.03.02.10.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 10:51:26 -0800 (PST)
Date: Mon, 2 Mar 2026 19:51:25 +0100
From: Michal Hocko <mhocko@suse.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vishal Moola <vishal.moola@gmail.com>, Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vmalloc: support __GFP_RETRY_MAYFAIL and __GFP_NORETRY
Message-ID: <aaXcLRdhq0IyoNIG@tiehlicka>
References: <20260302114740.2668450-1-urezki@gmail.com>
 <20260302114740.2668450-2-urezki@gmail.com>
 <a8010888-ce49-9232-f132-338de8e18cee@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8010888-ce49-9232-f132-338de8e18cee@redhat.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F2DB0100006
X-Stat-Signature: 33tc3r9kdenryx4ccer36ae4yzmkcmfp
X-Rspam-User: 
X-HE-Tag: 1772477488-936846
X-HE-Meta: U2FsdGVkX19YHrxh3t+UQA2fQoiE2VvkFqUYUviZrqnxKYalsRV1JIJCMDdsTrSV+Lkzxxb7dCFLY7IkDrjisl/l+81pSAvnQ79Gbo0tES4imb2fepfRpKv3FKPacWOrn6Vt3RKB4CYNXXvcHGuW5aGzivacl4CWQjW53+Cy01LnoIAAqBP1qFZEp9R636gTzhWNGD+EhNd4HYm2brd80gVygonLpX9bBOU9dqAOUmdUDx6BF6//Ok8WoCQp9aRK5PuloyRR0szjgYf2zDJGgtzu1Bj8MgdRgFcTpLKE558VQkiIogSlvfE+Ev+YFXG4t/9le7YYUJXF6UvO7kwo0TrQjsY6aMYaPTrA6KEBYdSvU+WXxhio+gCN8UEoZmwapcS0g7vAhf1uWHIdG65wl+XiGOsqYHmB5/WM9/loVTLaZtiwxskE1hJzzt8eN41BipX0H8RQaSHnIEM5Hadp4IHf5ELw6UUoDfAxctT87tRtkP6prbU+pL8xysqKTSlvu4o5EdVfoppRkBPu4LMQpW4UDzGRoJ99l4BqpvnPN71j0mm4alukk1OIKdALxtqC0x0acaPqpfV9sRZeO+2xXWKuTw9n/j0Ns/Q3umQi7zqXhaABCjmzdwzDFoaIM2HrTkloNoSuZeo650v7zLHrhR7t8pKhbIq7lq73on4rbBz+mv3vO1ePXj6+Lrh+nFsYSnv84g4uaQ64LeqZELrvcCPXezRnrlEP5rvdrPCVCCgSd2rHHQe8Vq6GeD3Loa2fubaObG1w8igfmE/yacavXJi2PWwV1BNs40BQBT1h/Qe5jN84l8vEEyjYWfcE7XgEBTsGYLeScKKJ/EXgAcGqqmC6FfM+ExAmtXIVocKfo4y1hzHOUF0n4Qugj+jCy8ujlThTccsWt+Kusfj6933ZPPAsJmnlf7W3BCNfD9GQu9/HRKi0YLTGvMDQqUKEwcWEmj76Mf+2xf8Aj+pxnft
 GrybXloH
 BKYZGHLERSOu/5oVXHHJ+UErBhcKoObNPHWdD3n1ZWCMmcVcUVU/IykkmGE0IlMQld0Uvw/axvgrQONWFCLHXWaIwn7jLF/xVHZWlG6Cpr8mbqI3cnPFmm/LQswLEhGyj1LKX4MOoThvStn8HNrWPOv1O9UVgR+CmO5KwVAMV3yKH4wYimboM8D7NSy2UcOS00HMzlT7Ud3DsbqFCAFxGIeUQil9alEzPijNfdTMG0/fGdmDBMw0Zv+aDVyr3rgtel1u1Sccu9rnFV7XBkxmdA/6FOjN7TmwVOVapOTAEHRWlHRy6CoqRGYEpWE1/JI4ine6CC1b1gTOGbERfa8kL/kQoLr7V02X6QNw5JcazAxMJipXxR47fcPG/tYt6QGZUhKwbh17WmalsRKXOaUah/HiRjcsNHRSAdNml2XLFf/9gx71UdCHoW3DtE+0IjwlkJhFKph10N79f+c/tAiKGfWkuZDBzwB9+wFPG9xvVo6CyDPgS2ENeb7MAZXN7zEpa72/1XzbIyMuEEgFRrlCtsDV8A2I8U3WXrTFQ1iKoZtvXYyg+nudC6ShmGcuMxWjdEpBkTWENhh+B3pBpvXYg0TiEQH74IYMltXK/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 02-03-26 18:38:53, Mikulas Patocka wrote:
> 
> 
> On Mon, 2 Mar 2026, Uladzislau Rezki (Sony) wrote:
> 
> > From: Michal Hocko <mhocko@suse.com>
> > 
> > __GFP_RETRY_MAYFAIL and __GFP_NORETRY haven't been supported so far
> > because their semantic (i.e. to not trigger OOM killer) is not possible
> > with the existing vmalloc page table allocation which is allowing for
> > the OOM killer.
> > 
> > Example: __vmalloc(size, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
> > 
> > <snip>
> >  vmalloc_test/55 invoked oom-killer:
> >  gfp_mask=0x40dc0(
> >  GFP_KERNEL|__GFP_ZERO|__GFP_COMP), order=0, oom_score_adj=0
> >  active_anon:0 inactive_anon:0 isolated_anon:0
> >   active_file:0 inactive_file:0 isolated_file:0
> >   unevictable:0 dirty:0 writeback:0
> >   slab_reclaimable:700 slab_unreclaimable:33708
> >   mapped:0 shmem:0 pagetables:5174
> >   sec_pagetables:0 bounce:0
> >   kernel_misc_reclaimable:0
> >   free:850 free_pcp:319 free_cma:0
> >  CPU: 4 UID: 0 PID: 639 Comm: vmalloc_test/55 ...
> >  Hardware name: QEMU Standard PC (i440FX + PIIX, ...
> >  Call Trace:
> >   <TASK>
> >   dump_stack_lvl+0x5d/0x80
> >   dump_header+0x43/0x1b3
> >   out_of_memory.cold+0x8/0x78
> >   __alloc_pages_slowpath.constprop.0+0xef5/0x1130
> >   __alloc_frozen_pages_noprof+0x312/0x330
> >   alloc_pages_mpol+0x7d/0x160
> >   alloc_pages_noprof+0x50/0xa0
> >   __pte_alloc_kernel+0x1e/0x1f0
> >   ...
> > <snip>
> > 
> > There are usecases for these modifiers when a large allocation request
> > should rather fail than trigger OOM killer which wouldn't be able to
> > handle the situation anyway [1].
> > 
> > While we cannot change existing page table allocation code easily we can
> > piggy back on scoped NOWAIT allocation for them that we already have in
> > place. The rationale is that the bulk of the consumed memory is sitting
> > in pages backing the vmalloc allocation. Page tables are only
> > participating a tiny fraction. Moreover page tables for virtually allocated
> > areas are never reclaimed so the longer the system runs to less likely
> > they are. It makes sense to allow an approximation of __GFP_RETRY_MAYFAIL
> > and __GFP_NORETRY even if the page table allocation part is much weaker.
> > This doesn't break the failure mode while it allows for the no OOM
> > semantic.
> > 
> > [1] https://lore.kernel.org/all/32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com/T/#u
> > 
> > Tested-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> > Signed-off-by: Michal Hocko <mhocko@suse.com>
> > Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> > ---
> >  mm/vmalloc.c | 17 ++++++++++++-----
> >  1 file changed, 12 insertions(+), 5 deletions(-)
> > 
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index a06f4b3ea367..975592b0ec89 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -3798,6 +3798,8 @@ static void defer_vm_area_cleanup(struct vm_struct *area)
> >   * non-blocking (no __GFP_DIRECT_RECLAIM) - memalloc_noreclaim_save()
> >   * GFP_NOFS - memalloc_nofs_save()
> >   * GFP_NOIO - memalloc_noio_save()
> > + * __GFP_RETRY_MAYFAIL, __GFP_NORETRY - memalloc_noreclaim_save()
> > + * to prevent OOMs
> >   *
> >   * Returns a flag cookie to pair with restore.
> >   */
> > @@ -3806,7 +3808,8 @@ memalloc_apply_gfp_scope(gfp_t gfp_mask)
> >  {
> >  	unsigned int flags = 0;
> >  
> > -	if (!gfpflags_allow_blocking(gfp_mask))
> > +	if (!gfpflags_allow_blocking(gfp_mask) ||
> > +			(gfp_mask & (__GFP_RETRY_MAYFAIL | __GFP_NORETRY)))
> >  		flags = memalloc_noreclaim_save();
> 
> I wouldn't do this because:
> 
> 1. it makes the __GFP_RETRY_MAYFAIL allocations unreliable.

__GFP_RETRY_MAYFAIL doesn't provide any reliability. It just promisses
to not OOM while trying hard. I believe this implementation doesn't
break that promise.

> 2. The comment at memalloc_noreclaim_save says that it may deplete memory 
> reserves: "This should only be used when the caller guarantees the 
> allocation will allow more memory to be freed very shortly, i.e. it needs 
> to allocate some memory in the process of freeing memory, and cannot 
> reclaim due to potential recursion."

yes, this allocation clearly doesn't guaratee to free more memory. That
comment is rather dated. Anyway, the crux is to make sure that the
allocation is not unbound. The idea behind this decision is that the
page tables are only a tiny fraction of the resulting memory allocated.
Moreover this virtually allocated space is recycled so over time there
should be less and less of page tables allocated as well.
 
> I think that the cleanest solution to this problem would be to get rid of 
> PF_MEMALLOC_NOFS and PF_MEMALLOC_NOIO and instead introduce two per-thread 
> variables "gfp_t set_flags" and "gfp_t clear_flags" and set and clear gfp 
> flags according to them in the allocator: "gfp = (gfp | 
> current->set_flags) & ~current->clear_flags";

We've been through discussions like this one way too many times and the
conclusion is that, no this will not work. The gfp space we have and
need to support without rewriting a large part of the kernel is simply
incompatible with a more sane interface. Yeah, I hate that as well but
here we are. We need to be creative to keep sensible and not introduce
even more weirdness to the interface.
-- 
Michal Hocko
SUSE Labs

