Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 631A5EB3622
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 17:39:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D047B6B0005; Mon,  2 Mar 2026 12:39:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9B656B0089; Mon,  2 Mar 2026 12:39:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B94156B008A; Mon,  2 Mar 2026 12:39:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8FD86B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:39:05 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 71AC08AAC9
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:39:05 +0000 (UTC)
X-FDA: 84501833850.06.1D6CEDF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 67F6C180009
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:39:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WtaaRsAO;
	spf=pass (imf24.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772473143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dKQFeYilQCYD5V+HWcLb2j7WG4VTlY1a/c+d6LeyDK8=;
	b=Tg56YzpMcyJxb/MbMpnWkQv+6raXFxsuYLeBcapg/TDoAJ/uZ8LL6jzJm4r1jO1lYFQMtk
	y2FVl0cKTEO6w5CryXA0ciN4tBDmM+LXJiUTtfWRiObT8mYAwzSIu/UfWK7C9LBVWsiYJ1
	7x/m6RDzqAxN4slzBuzxP7ejqs06pk0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WtaaRsAO;
	spf=pass (imf24.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772473143; a=rsa-sha256;
	cv=none;
	b=YdaTgDuEDF6mWA0dHiJEp+aL7Ns63E3vOIDMHRE3HwAkb+A85xiKrc9XWFDf3DtpYRjIg6
	C6utMxVAoDt1ivbDG1RNNfT0Lt4h6rqbN27EoZzg9at7ERKorhwJRLrEIbLVYH6Ud1S0If
	j1Lq9q0as2ezSglbovo86lzcAdEjEns=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772473142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dKQFeYilQCYD5V+HWcLb2j7WG4VTlY1a/c+d6LeyDK8=;
	b=WtaaRsAO0OOkj2HhsWvH4ZBHKJ+gI/YvpEIvNJJSOhvWaTVVGVaVWy7mgJa3dwebqQrBFc
	Z1B+Sg7JHmQtvZiX7OFqIYTdCRQmfVQEHZ5ipYLux/zZXMDucVOe3/ErH6Etx3Yhz3x5EU
	HbfcgbUuCcwYPeg7FC8ljcyg8hoQAk4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-16-_nfFaGn4NbC25tEozXyXIg-1; Mon,
 02 Mar 2026 12:38:59 -0500
X-MC-Unique: _nfFaGn4NbC25tEozXyXIg-1
X-Mimecast-MFC-AGG-ID: _nfFaGn4NbC25tEozXyXIg_1772473138
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 53AD3195605A;
	Mon,  2 Mar 2026 17:38:58 +0000 (UTC)
Received: from [10.45.224.173] (unknown [10.45.224.173])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1C6761956053;
	Mon,  2 Mar 2026 17:38:55 +0000 (UTC)
Date: Mon, 2 Mar 2026 18:38:53 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
    Michal Hocko <mhocko@suse.com>, Vishal Moola <vishal.moola@gmail.com>, 
    Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vmalloc: support __GFP_RETRY_MAYFAIL and __GFP_NORETRY
In-Reply-To: <20260302114740.2668450-2-urezki@gmail.com>
Message-ID: <a8010888-ce49-9232-f132-338de8e18cee@redhat.com>
References: <20260302114740.2668450-1-urezki@gmail.com> <20260302114740.2668450-2-urezki@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: 4OWBV4Zwtg0X56NUMQbmDvO58sEMjJXSDd0GIjF0njg_1772473138
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 67F6C180009
X-Stat-Signature: j5rdp1ht1zsjsham8w9ckay385d8o5j8
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772473143-738537
X-HE-Meta: U2FsdGVkX1/KhuMDvJld6R8U41/Z9/JF1v/046zlr3MSdMnAiBt1iY+BA4sqgPsR43r/lpfn/K4x9omT7sJ8XvavX0GfWlJyf7TBsCdPRFNfjlFs9IEb/32TMrffwxnUhM61XJaL9peePct86CcneMsnjltCKQjCPdic3PenG0dHE97ASjRLHM7pXgULN257QvY2MlJPPTe4ewD5kIieqtttubrPPoHe4y3aWLJIKUN7CzAb1R/sSZNYXQj3WMHyeqJ+2trkmOdqNKwqoJsIf7AUsm3j2oVaLZpJI3jq+uDhqHw34FPb5sNT8ouXIA1Mpj6JGktxDp+/FlNlZx9cpbUp+IIXgnBvMwMP2Zk+oQhoP23Skdn0J0+d+6NW5QntmIgOnYO9255WQo2GiQK/bGzi/TscfVeehkhWCX0nMBv/pgNYeWkew2pIflBmalKcHP4U4dYDPLL9YAOLkrZZiVrXnWMJHagv/1rIltfvYmHEX79BLehM6tzS/MjqO/0AS1bY8tm0puZ5rffhdRL1DTl2V7uq+mTGUly5WUjTkiFI63lniRhSdh/FJyUVd7YQTGtIEjboKQSocka0WbUNz4nAcuXBHB9qwpBkj6/sJxKWzc3x5BGnpTCu8VZzPGyC93jvaNSZAZowoloxUaSr8IPqx/FcAgpUzJ6DvAnJcnOvv5WSpp+bRBJvVHOJky5/qt5Y8t4Wsgknu2tl0zOJBU5BcpR2uM2iIf6rNEa9IRQ/VfFPAMuBJbz2oVCi4v421vZnoaPLMNMUx8AbC5+/KBTRS9XzRuUB3P2/3Yd8mq3TJgdm8hqe0eQE1XPzj4fcRP6XPdblPsLzFXtTQQ2g4pmiafSs5KPBwKMljWJSGUIE7eK6u9gXBh+QfI/UlOzo6MiibDIh45mHhY37wTdtZw0RYUDRSkVoGy54kBvVgHjPUg905mCEDvrruKRX5PONCs0I08LBdmafS7pGKip
 1E+noZa9
 1KmleH1V9W7NiNbJ9Ij/mVFv06Cp08IQu90kc2JcpktComyLtxZXJ9+Pllvps+FhaPkA0wbjlRtjrQiNYWXrjev9KiEOIBhLjd7gLGYcyWCg5wFJgsScOqwmIgK9pNjWC4Bqu1Q9U2cs2RSoyjYR51rReWet1XnWAm9L6/FJqwwMMfJl9dabUsS+vwNK1jK6hkpv9zC/tSaeSnFQ423iCqccH/rs/8+Q6HZFqOLTp6UTyZyKI32U+dhVPYqV1gEB1+5GDOoSShs3SqsGb87FqeLi+Wq9ivSGmD3HmwbOKFejz/FHtj7kgkeq8lPFwGjcln+QWjz7RbZz8+WQB1zxq6emZROgR71RXsUkCc0HjKHqyEevjusogpqX+U+MCShstvTjiKYZKtmkhYMOcePlQ+Bu9K1H1RizotXdpUT7bu4RJ6iU4FZiZDmVKsFQsu2PndTwxBqM7aefIzTaiWF127sJ1pspVl7HDCg9HSlIv5W/lc4gwsdC+o+KgY6+wxWgTJ2TWx2TDLGzlc8DZShmL3yr36i2BvwgFyCTpEUeoyAnwbsJFfoeS3Aa0wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Mon, 2 Mar 2026, Uladzislau Rezki (Sony) wrote:

> From: Michal Hocko <mhocko@suse.com>
> 
> __GFP_RETRY_MAYFAIL and __GFP_NORETRY haven't been supported so far
> because their semantic (i.e. to not trigger OOM killer) is not possible
> with the existing vmalloc page table allocation which is allowing for
> the OOM killer.
> 
> Example: __vmalloc(size, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
> 
> <snip>
>  vmalloc_test/55 invoked oom-killer:
>  gfp_mask=0x40dc0(
>  GFP_KERNEL|__GFP_ZERO|__GFP_COMP), order=0, oom_score_adj=0
>  active_anon:0 inactive_anon:0 isolated_anon:0
>   active_file:0 inactive_file:0 isolated_file:0
>   unevictable:0 dirty:0 writeback:0
>   slab_reclaimable:700 slab_unreclaimable:33708
>   mapped:0 shmem:0 pagetables:5174
>   sec_pagetables:0 bounce:0
>   kernel_misc_reclaimable:0
>   free:850 free_pcp:319 free_cma:0
>  CPU: 4 UID: 0 PID: 639 Comm: vmalloc_test/55 ...
>  Hardware name: QEMU Standard PC (i440FX + PIIX, ...
>  Call Trace:
>   <TASK>
>   dump_stack_lvl+0x5d/0x80
>   dump_header+0x43/0x1b3
>   out_of_memory.cold+0x8/0x78
>   __alloc_pages_slowpath.constprop.0+0xef5/0x1130
>   __alloc_frozen_pages_noprof+0x312/0x330
>   alloc_pages_mpol+0x7d/0x160
>   alloc_pages_noprof+0x50/0xa0
>   __pte_alloc_kernel+0x1e/0x1f0
>   ...
> <snip>
> 
> There are usecases for these modifiers when a large allocation request
> should rather fail than trigger OOM killer which wouldn't be able to
> handle the situation anyway [1].
> 
> While we cannot change existing page table allocation code easily we can
> piggy back on scoped NOWAIT allocation for them that we already have in
> place. The rationale is that the bulk of the consumed memory is sitting
> in pages backing the vmalloc allocation. Page tables are only
> participating a tiny fraction. Moreover page tables for virtually allocated
> areas are never reclaimed so the longer the system runs to less likely
> they are. It makes sense to allow an approximation of __GFP_RETRY_MAYFAIL
> and __GFP_NORETRY even if the page table allocation part is much weaker.
> This doesn't break the failure mode while it allows for the no OOM
> semantic.
> 
> [1] https://lore.kernel.org/all/32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com/T/#u
> 
> Tested-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> Signed-off-by: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---
>  mm/vmalloc.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index a06f4b3ea367..975592b0ec89 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3798,6 +3798,8 @@ static void defer_vm_area_cleanup(struct vm_struct *area)
>   * non-blocking (no __GFP_DIRECT_RECLAIM) - memalloc_noreclaim_save()
>   * GFP_NOFS - memalloc_nofs_save()
>   * GFP_NOIO - memalloc_noio_save()
> + * __GFP_RETRY_MAYFAIL, __GFP_NORETRY - memalloc_noreclaim_save()
> + * to prevent OOMs
>   *
>   * Returns a flag cookie to pair with restore.
>   */
> @@ -3806,7 +3808,8 @@ memalloc_apply_gfp_scope(gfp_t gfp_mask)
>  {
>  	unsigned int flags = 0;
>  
> -	if (!gfpflags_allow_blocking(gfp_mask))
> +	if (!gfpflags_allow_blocking(gfp_mask) ||
> +			(gfp_mask & (__GFP_RETRY_MAYFAIL | __GFP_NORETRY)))
>  		flags = memalloc_noreclaim_save();

I wouldn't do this because:

1. it makes the __GFP_RETRY_MAYFAIL allocations unreliable.

2. The comment at memalloc_noreclaim_save says that it may deplete memory 
reserves: "This should only be used when the caller guarantees the 
allocation will allow more memory to be freed very shortly, i.e. it needs 
to allocate some memory in the process of freeing memory, and cannot 
reclaim due to potential recursion."


I think that the cleanest solution to this problem would be to get rid of 
PF_MEMALLOC_NOFS and PF_MEMALLOC_NOIO and instead introduce two per-thread 
variables "gfp_t set_flags" and "gfp_t clear_flags" and set and clear gfp 
flags according to them in the allocator: "gfp = (gfp | 
current->set_flags) & ~current->clear_flags";

Mikulas


