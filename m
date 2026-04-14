Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ED10ED7B98
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 10:30:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8E6E6B008A; Tue, 14 Apr 2026 06:30:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3FAF6B0092; Tue, 14 Apr 2026 06:30:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D55EF6B0093; Tue, 14 Apr 2026 06:30:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C3DBB6B008A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 06:30:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8600F590AC
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:30:02 +0000 (UTC)
X-FDA: 84656791044.16.B041BCB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 132BE40008
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:29:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KHS0O4GE;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776162600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zCYL+ZoJzKHMQDin2IVxvP3VkJWBlHF10mQGVNRGJ/I=;
	b=Z4xia48ugKiY4+0ljaePRKxSJwOvCmKZ6zz3/Dnpzwv6HyjJpdXqKVZH1PnyqjPY/Q2zwL
	vvmu7mSa1vcx3r5J3xvZ90xt2zDpku5cP51+TFcG2JLW8EQIl/5VenuG/NeRnzFuAh6YrV
	SawV7W9Y6R4uqPyXjU/6kA4oOnbDkY4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776162600; a=rsa-sha256;
	cv=none;
	b=FTOX+DvNahQFwzRNcRk5bSEb5mMH7l7vSWXhJwf4WuA2km/dOeXKZq1hb4vOrVTBa4S8nJ
	IOY2IF/zt0ETO5H6ND+pMu7dgseIVFtvGS55xyKMOschhYgee0gPJZMeaelnHe5M5/uJEU
	6PODBtmHbO/fSbzeZlFNW+sjT/Ob66s=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KHS0O4GE;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776162599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zCYL+ZoJzKHMQDin2IVxvP3VkJWBlHF10mQGVNRGJ/I=;
	b=KHS0O4GENBFEl+SPOxgvL5nz5tPmIujy+gWVKE00SOrLAQX6qNWKvYhx7LGDNDlxo19Nld
	adZ+GyqGaBIWA16buPk/gqZgETe7fu3VFS6Vt6vr87YOTB6u9gWxaTgfUIJjEKDAqBGIo5
	C5Wn7IhXAWixl/1zEylCOAeNsRTHwvE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-269-Hbwtxbj5OCqAtPLMfs30RQ-1; Tue, 14 Apr 2026 06:29:58 -0400
X-MC-Unique: Hbwtxbj5OCqAtPLMfs30RQ-1
X-Mimecast-MFC-AGG-ID: Hbwtxbj5OCqAtPLMfs30RQ_1776162597
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43d1ceb2ddfso5119123f8f.2
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:29:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776162597; x=1776767397;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zCYL+ZoJzKHMQDin2IVxvP3VkJWBlHF10mQGVNRGJ/I=;
        b=Ik7ryfv7nCIiCqt9A0bJKUJSKfUDdszy8YkWcLa/LcRvObBR8ds1ZY7MVLXDLUhbv8
         jZ7mnD9EZned/6wb4WkRnPgUBHIDUl0Jpt+wi037PE1Sn8UGyeksNXSMstuUPBEc8xxp
         CSJK+rVxao03lixAyrUlVkLYJ4s39uODv7sFJQ9/3UTrFDyBElEcyQGDaTM4Qn50CyRB
         Vfcr/5w9PIGV+ePQuTSZZ9+dtUdO/u4FoirCSSZ9G6rxXoeIM0p40NjEMsEVXaQUApv8
         tY8Rq4Op+edu3bBB+DW9bVz5Ugd8WQlsf53UVa7y8mLE5cAAA5ZTD8zVfesfdCfXWz6G
         hcvw==
X-Forwarded-Encrypted: i=1; AFNElJ/SQ2FxdTxmUqMknrdHFZ68YdPdw4UDOK3WkPmMbndWKnoLuods/JtNp2ycPyoPpDxxCAN8gqf6DQ==@kvack.org
X-Gm-Message-State: AOJu0YziL/yM3JiMe7yK4s7j9USR6JkPaA2xcPP5bQ+75E58X3NexXlZ
	ejIl0frnlubStml4qGvvn4XhPcrrdiON0XGvxZQ9PIi6FVax9PGEo4Ngtj5HQxLOjW6Zzc6ew6F
	oStOyTHOtXpDjTH2tNZSsP81X3e9G5p0hvKWK0E9/nuliNvp7XpZH
X-Gm-Gg: AeBDievYAyHxXo2Zmwj8+S9S0M8kFl6vb3Wl+/rRUamJFgw79H3VMLSv/SPQvM5iUGG
	DWdSuFMwRcb/c5o8bu5vF3Ro6YJsjrmr/fbOYlht1xc7NLnK3o5VY5gKFBbemBJIaqQeFTNcp+/
	CohZJCSxEreRaQPy52BzHY0zx5IHqNL+kU3Ou8HRX67mLurWkqoEFdNL5xTcnUqrsrhj4BHEWpi
	A41elkZI0rSoymUhReajRQoCS/2yZ9KLYafZKCj7B5myahMxylOH1CKWTVGSEqvCb4PVX9h/a9P
	73K20XAKDpSWhKebk1jAMIRUNPKzk59vH8D1eDIThIA8EDyomf1zG0gzlZH792X34t/rIXO+VoG
	mB4qsUbJGZ6lF2c9YSiXbJ+bZiZInhNHBveMKdgkWecc=
X-Received: by 2002:a05:600c:34cc:b0:485:557d:9fe with SMTP id 5b1f17b1804b1-488d67e65e7mr221616815e9.12.1776162596764;
        Tue, 14 Apr 2026 03:29:56 -0700 (PDT)
X-Received: by 2002:a05:600c:34cc:b0:485:557d:9fe with SMTP id 5b1f17b1804b1-488d67e65e7mr221616355e9.12.1776162596244;
        Tue, 14 Apr 2026 03:29:56 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d5dcf845sm118552305e9.11.2026.04.14.03.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 03:29:55 -0700 (PDT)
Date: Tue, 14 Apr 2026 06:29:52 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH RFC 3/9] mm: add __GFP_PREZEROED flag and
 folio_test_clear_prezeroed()
Message-ID: <20260414062524-mutt-send-email-mst@kernel.org>
References: <cover.1776033471.git.mst@redhat.com>
 <b21b0ba353330f24b9e10ee5bf01b60f32043327.1776033771.git.mst@redhat.com>
 <b258160c-5287-43dd-b56e-268c403b85ea@kernel.org>
 <20260413163644-mutt-send-email-mst@kernel.org>
 <da935245-9c75-4cf4-8a42-2c6328bd93f9@kernel.org>
MIME-Version: 1.0
In-Reply-To: <da935245-9c75-4cf4-8a42-2c6328bd93f9@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WPWXOzb7f7nvCMMFOwHNBTYWqaBec146fsISt2b00iI_1776162597
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 132BE40008
X-Stat-Signature: gkagjfjas6hr18gi69qnhfxdjdy3pqo3
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776162599-914741
X-HE-Meta: U2FsdGVkX1/W4TAn3bLwMWHtJtPyF4Z4zuAUvclzJPNIxOBNyrP1Lhtyfbx+dBImomhpDzrNABETt/441b2ccR0vBTAU/MLKI9LksODuDwAvR1zQl1wtTNkwWNbeVShaC9vTOz3CPHS3WROci4StwPzH6vOHMgqhBzPO0OLVOFy58UkO2J2cu7t172aINH+fKhf3Y6+vl7NAWP7EoJa6XAhcSs/LozKv/XwgL5HYB3aYPlXB73onPddHVkvg9F5xv+FunU5UsJMM6Y09Vxo8kKfASLf6d74jTOq0GPRiQiNlCDrSvxjVHwRQVYEEHPsHOB8jKIqmViLMPGYDNk8S7dXa96DfxaPxXuVdNtRlRufO5odm3C8O7TUT9bUrmucowBwWNlUrhnMPlvNSR/b8vvs1b5F9EOzIjEgJs7Ki/aysS6RMr2rkN8bVE7qyQbY8gWTUbTB6D8/E2l0l5MttGgB8DP1N5AXo4FQyRYtJ0B9lMLc5NodPkcZxxTEtcF37Xo/V0B/URMikP/M9exGJWrXNCuvGXwdt95qoue4eJjRt4RIgsUoub4MKX8pCGWeiNVxYVj7QiJMlHlVXWWHQOZZI8lgGU5hHI6bhqmp3L3wO9Q3neTeLfGLOlXnefUz8z4ImKcvBV3Mk435K/eZD/KXZezxVmWZHTdmGDeAiX1alBZkBeymqgUsDANa/ODo0mS6vjgJ4l89Ap9567F7NpCUiR50lTQBIRCE1DXIyUscwHxkcFc1slAAkla7rw/lRchftnnRv37GA9uDghUMyKSg0mgOSjsgBb0Xd21XU2tNYximZTZjp6CcXPy6ixB/AHZ52EMGpQf01vz0qo6AKI05+ar9dI0rFQfg9MJWInEA0vY5dGu80Hv0X0Htqpj31Qmsll27a0Y1h+ROKWw/scI/ZvpunCzdMXnhylbcMW1JJiHVvf8OIym4RkvJaX+zUS59OWdTDZT/XWMa+WSU
 yCxn/5bc
 Jv76sDX/6T/6JVbzVHyp9j4gfuUq0moIikJoR1L0gHgFpFl1AQ4rmpu+r4tzeJquZrocebX2/py+hFMzDZtTRy03Vk0BQSSz8qvdwrkbMFZBWCgTxMGl8JQoiu8yY6h4pzg1u5i/p3hNTVp8rjJ8nusWK0rLcN9wMfg0QfvRVmdwkOgbRkaiwwauJ0SKnlUpdo/S9nhE21wxD33Xa3PRCncKIYHvfs3tCHDHd6a0/ExH5pe/nUxiT47pIw+pTMSmxZn/t38dLxRqRKkHoaxr4g3ziYYTtIQT49+c9PSini5AWOY347djtNmux6cExDRLxjSfPKFQ0o+TyboUbSvIsUUaT/xip0+ShM3yzlED+HIoJJDa/axvDIlWVlnq/bSoOZlew
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 11:04:04AM +0200, David Hildenbrand (Arm) wrote:
> On 4/13/26 22:37, Michael S. Tsirkin wrote:
> > On Mon, Apr 13, 2026 at 11:05:40AM +0200, David Hildenbrand (Arm) wrote:
> >> On 4/13/26 00:50, Michael S. Tsirkin wrote:
> >>> The previous patch skips zeroing in post_alloc_hook() when
> >>> __GFP_ZERO is used.  However, several page allocation paths
> >>> zero pages via folio_zero_user() or clear_user_highpage() after
> >>> allocation, not via __GFP_ZERO.
> >>>
> >>> Add __GFP_PREZEROED gfp flag that tells post_alloc_hook() to
> >>> preserve the MAGIC_PAGE_ZEROED sentinel in page->private so the
> >>> caller can detect pre-zeroed pages and skip its own zeroing.
> >>> Add folio_test_clear_prezeroed() helper to check and clear
> >>> the sentinel.
> >>
> >> I really don't like __GFP_PREZEROED, and wonder how we can avoid it.
> >>
> >>
> >> What you want is, allocate a folio (well, actually a page that becomes
> >> a folio) and know whether zeroing for that folio (once we establish it
> >> from a page) is still required.
> >>
> >> Or you just allocate a folio, specify GFP_ZERO, and let the folio
> >> allocation code deal with that.
> >>
> >>
> >> I think we have two options:
> >>
> >> (1) Use an indication that can be sticky for callers that do not care.
> >>
> >> Assuming we would use a page flag that is only ever used on folios, all
> >> we'd have to do is make sure that we clear the flag once we convert
> >> the to a folio.
> >>
> >> For example, PG_dropbehind is only ever set on folios in the pagecache. 
> >>
> >> Paths that allocate folios would have to clear the flag. For non-hugetlb
> >> folios that happens through page_rmappable_folio().
> >>
> >> I'm not super-happy about that, but it would be doable.
> >>
> >>
> >> (2) Use a dedicated allocation interface for user pages in the buddy.
> >>
> >> I hate the whole user_alloc_needs_zeroing()+folio_zero_user() handling.
> >>
> >> It shouldn't exist. We should just be passing GFP_ZERO and let the buddy handle
> >> all that.
> >>
> >>
> >> For example, vma_alloc_folio() already gets passed the address in.
> >>
> >> Pass the address from vma_alloc_folio_noprof()->folio_alloc_noprof(), and let
> >> folio_alloc_noprof() use a buddy interface that can handle it.
> >>
> >> Imagine if we had a alloc_user_pages_noprof() that consumes an address. It could just
> >> do what folio_zero_user() does, and only if really required.
> >>
> >> The whole user_alloc_needs_zeroing() could go away and you could just handle the
> >> pre-zeroed optimization internally.
> >>
> >> -- 
> >> Cheers,
> >>
> >> David
> > 
> > I admit I only vaguely understand the core mm refactoring you are suggesting.
> > 
> 
> Oh, I was hoping claude would figure that out for you.

We figured it out together)


> 
> Essentially, we move the zeroing of folios back into the buddy, by using
> GFP_ZERO.
> 
> user_alloc_needs_zeroing() logic would reside in the buddy and is no longer
> required in callers.
> 
> E.g.,
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 631205a384e1..44576ba3def5 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5259,7 +5259,7 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
>         gfp = vma_thp_gfp_mask(vma);
>         while (orders) {
>                 addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
> -               folio = vma_alloc_folio(gfp, order, vma, addr);
> +               folio = vma_alloc_folio(gfp | GFP_ZERO, order, vma, addr);
>                 if (!folio)
>                         goto next;
>                 if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
> @@ -5272,15 +5272,6 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
>                         goto fallback;
>                 }
>                 folio_throttle_swaprate(folio, gfp);
> -               /*
> -                * When a folio is not zeroed during allocation
> -                * (__GFP_ZERO not used) or user folios require special
> -                * handling, folio_zero_user() is used to make sure
> -                * that the page corresponding to the faulting address
> -                * will be hot in the cache after zeroing.
> -                */
> -               if (user_alloc_needs_zeroing())
> -                       folio_zero_user(folio, vmf->address);
>                 return folio;
>  next:
>                 count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);
> 
> 
> folio_zero_user(), from where we would extract a function that operates on a
> page+order chunk, requires the address hint.
> 
> So we would have to pass that address. For example for the !CONFIG_NUMA case,
> something like the following could be done.
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 51ef13ed756e..29771c3240be 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -234,6 +234,10 @@ struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_
>                 nodemask_t *nodemask);
>  #define __folio_alloc(...)                     alloc_hooks(__folio_alloc_noprof(__VA_ARGS__))
>  
> +struct folio *__folio_alloc_user_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
> +               nodemask_t *nodemask, unsigned long addr);
> +#define __folio_alloc_user(...)                        alloc_hooks(__folio_alloc_user_noprof(__VA_ARGS__))
> +
>  unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>                                 nodemask_t *nodemask, int nr_pages,
>                                 struct page **page_array);
> @@ -291,6 +295,18 @@ __alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order)
>  
>  #define  __alloc_pages_node(...)               alloc_hooks(__alloc_pages_node_noprof(__VA_ARGS__))
>  
> +static inline
> +struct folio *__folio_alloc_user_node_noprof(gfp_t gfp, unsigned int order,
> +               int nid, unsigned long addr)
> +{
> +       VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
> +       warn_if_node_offline(nid, gfp);
> +
> +       return __folio_alloc_user_noprof(gfp, order, nid, NULL, addr);
> +}
> +
> +#define  __folio_alloc_user_node(...)          alloc_hooks(__folio_alloc_user_node_noprof(__VA_ARGS__))
> +
>  static inline
>  struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
>  {
> @@ -342,7 +358,7 @@ static inline struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int orde
>  static inline struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
>                 struct vm_area_struct *vma, unsigned long addr)
>  {
> -       return folio_alloc_noprof(gfp, order);
> +       return __folio_alloc_user_node_noprof(gfp, order, numa_node_id(), addr);
>  }
>  #endif

> index ee81f5c67c18..28f448f40b75 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5260,6 +5260,13 @@ struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_
>  }
>  EXPORT_SYMBOL(__folio_alloc_noprof);
>  
> +struct folio *__folio_alloc_user_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
> +               nodemask_t *nodemask, unsigned long addr)
> +{
> +       /* TODO */
> +}
> +EXPORT_SYMBOL(__folio_alloc_noprof);
> +
>  /*
>   * Common helper functions. Never use with __GFP_HIGHMEM because the returned
>   * address cannot represent highmem pages. Use alloc_pages and then kmap if
> 
> 
> As alloc_user_pages() resides in the buddy, it can just honor any
> buddy-internal "pre-zeroed" flag.
> 
> 
> Once you are in page_alloc.c you can access internal allocation functions and
> take care of that without GFP flags.
> 
> -- 
> Cheers,
> 
> David


Pretty much what I did, except I felt it is better to change the
existing APIs. A bit more churn, but in return there's less of a chance
we forget to pass the user address.

Because, if we do, the result works fine on x86 but corrupts memory
on other arches.


-- 
MST


