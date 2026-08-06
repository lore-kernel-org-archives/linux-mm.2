Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CD82C5AC7A
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 23:32:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23DCA6B0093; Thu,  6 Aug 2026 19:32:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C72B6B0095; Thu,  6 Aug 2026 19:32:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 091B16B0096; Thu,  6 Aug 2026 19:32:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B7F7E6B0093
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:32:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 03248160686
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 23:32:41 +0000 (UTC)
X-FDA: 85072446564.16.AAC8895
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 85FB480006
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 23:32:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OXmDDFQ9;
	spf=pass (imf02.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786059159;
	b=RzQ1OnInDC6rWPiGikXBa0GACqFjINRvM6PtGOVCfm4NnnlqsOd0iLjjNEZy7Ur5MPr8ct
	btQsJUMO8OR3C+8wlR+xxsvCKlUI9Fds+Gue8WjXYvaNZDwhS30O0AB20fDYh49P1TkkdY
	qnYjpm1hhpENKOFpxQ3zhMRAhDE6y7I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OXmDDFQ9;
	spf=pass (imf02.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786059159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x1PY9KJIb1qTfXyzcPT+pdmLvTO8tSJ3NAtvLbML8yo=;
	b=i50hwSxSBGIOixl4JsNKtEFpFVxt8jpWHJNVSFhiY4QWesCOUcZEumvvxI5o/fG5RPxOUF
	SEhKbQBINPeoJOM96wCS+hwoOqbS4zmnjIB+uKofVcwiA75YM4jifMoHgrXq2XwLKayozm
	TmbYa4x43/Ue2d/NSgdJO4iqKZY3QsU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786059158;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x1PY9KJIb1qTfXyzcPT+pdmLvTO8tSJ3NAtvLbML8yo=;
	b=OXmDDFQ9i6v4rbB2EMDF9Br7lZJv7zBUXGlTPwtIYMWBItwS7EgYVmJDTmAlImn4KIDUO6
	Grn1nWkQPnd5jnLiZxwJDUvWCaejoM8PqZns2byj3Nsnwim01dN+HQoe5Y1aEFEyfI1cYR
	oL5VgkHz8RN6+jIC1Ms6hN9J5Lvx3E8=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-676-VTZIsCVEOC2tkdl0k0D3-w-1; Thu, 06 Aug 2026 19:32:37 -0400
X-MC-Unique: VTZIsCVEOC2tkdl0k0D3-w-1
X-Mimecast-MFC-AGG-ID: VTZIsCVEOC2tkdl0k0D3-w_1786059157
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-5283fa0656dso18841181cf.1
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 16:32:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786059157; x=1786663957;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x1PY9KJIb1qTfXyzcPT+pdmLvTO8tSJ3NAtvLbML8yo=;
        b=hpa+Fnl+BAwosf6iVdo1wXTrnJ16LiSl7fKDiNJfu8gHWGi8TDkhN/DULeFerqUw0A
         StVPvm1fTgqQxhQfublPZlmstLsXYW1U+wGpAof35H3uunoWayB3JhnFCkeP+ubmSap/
         eY4HNw/lVdVbHfDrgKCDV8ifzoDT7wWgTAiN/cW9pzoPhkPlhewaDUWR7IgpifSG8Sgb
         WIOEh6bJ29YDRPCfcoNz1o3exOwNkRL86paHr+IMrfrOmEulDmf+hIuts33SGbTPHVGR
         mgNEiPh5Jfs7QEMULHVKlAOTrYO6JaVEffo3I9ZYhotzqtJRjfRMqO0Bhzgai9ZxzT6L
         1Umg==
X-Forwarded-Encrypted: i=1; AHgh+RoGu7XB+8dlgGFaHmGeckmP1p2vruAD+32x0qDCErZTEZxfYTKcfboJXtaBFXkdwUerKey9VHn8Tg==@kvack.org
X-Gm-Message-State: AOJu0Yyi0g/fmBY8nwL2C0xSZmFsJKukNKeCt/QBp3f/UcVnoIufmQUu
	bNsxtGQLnDRnMIbgl0vboYrUGnUkNWq34TxNFvUIFzAMlKdrdqMr4yfzoAwNiiw4imlPu3qQnlh
	gkRD/AhVMoxGGXJgHqi7jllDdRWIOmyjcAcNjrIg2RsTuJ2u689Zd
X-Gm-Gg: AR+sD1373Z099ha34JPWmlNRRxWYlmD0iRtrjybIxKhWbsRrysCwUio9faN2BC87CcR
	7N9HfB+baPLHHzQLkN4RNdJqjDe/2mwq3rXnphhxaFOV8Si52PLoWCWrOS5xl86eSTEo1bk+bBb
	3iHVA4qw0euWDgBpw3AIl3P3mvE4jiduAYwjxkBEfEJD5bx0R3pqeIy5+zbu4jcz6c9riPefJgl
	QjfFPp1N5Ow6Ninn5L54jSgrGoonD/HHDXq8rDBrMRV2BYVM5k5L7ZypXG665WMQRz5EyDfATgB
	Bdty197VvG22psPEmjTKS+Q6suN1iCzfnh0TWSf6wLa+l06VcNImU4sxEA64A4TK9cwZ
X-Received: by 2002:ac8:6f19:0:b0:50e:635b:5562 with SMTP id d75a77b69052e-52d00498b36mr95353291cf.22.1786059156651;
        Thu, 06 Aug 2026 16:32:36 -0700 (PDT)
X-Received: by 2002:ac8:6f19:0:b0:50e:635b:5562 with SMTP id d75a77b69052e-52d00498b36mr95352631cf.22.1786059156155;
        Thu, 06 Aug 2026 16:32:36 -0700 (PDT)
Received: from x1.local ([174.91.117.74])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52d16335bb4sm273151cf.2.2026.08.06.16.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 16:32:35 -0700 (PDT)
Date: Thu, 6 Aug 2026 19:32:22 -0400
From: Peter Xu <peterx@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Alex Williamson <alex@shazbot.org>,
	bcm-kernel-feedback-list@broadcom.com,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Christian Koenig <christian.koenig@amd.com>,
	David Hildenbrand <david@kernel.org>,
	dri-devel@lists.freedesktop.org, Fei Li <fei1.li@intel.com>,
	Huang Rui <ray.huang@amd.com>, linux-mm@kvack.org,
	linux-s390@vger.kernel.org, Michal Hocko <mhocko@suse.com>,
	Sergio Lopez <slp@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Zimmermann <tzimmermann@suse.de>, stable@vger.kernel.org
Subject: Re: [PATCH v2 3/6] drm/ttm, drm/vmwgfx: directly create writable
 PTEs when mkwrite is in use
Message-ID: <anUZhiwas8pN_No8@x1.local>
References: <20260804120529.1730187-1-pbonzini@redhat.com>
 <20260804120529.1730187-4-pbonzini@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20260804120529.1730187-4-pbonzini@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sfx9ZrwJRzobzQyvoJOZUK0bVn9J7fkleD6nDv2iNmk_1786059157
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 85FB480006
X-Stat-Signature: j4to18n8anoyrwpi67o8areegfgy5izp
X-Rspam-User: 
X-HE-Tag: 1786059159-281383
X-HE-Meta: U2FsdGVkX19Mf1uN/1u1iFii2ityvBssuWNrGz77/WJWXwr8V98MGn9E5Vdo1bPsgvnMGhc5gY6AOXgEtaDpfofjZ3VGKnVtkZaiaUUVP1oqNM2LH71GFhUdZ1SQIJLo5sLTmtjXOYxVeeemURxPgDj32TfuHPgG+fNyS1Qo1t5wrgU+O60xak+M6IoaeTppDeDvI0NtxbA8WqKrjiw/y69TOzqo4saI96gIh58vWDqwCVkmkC4afUpf5W1qS56X9cxXyYSYMyuaaaxk+XYH/ix9pZOBZnWITHPmN2s+hVo6S457l0vTxor38o/gNt4vcZ4W2eUbwST1Rd9OCXGu9h9+eX89pv3HrDHlCalGOqe2aeZf/5purPfoCWO5BfK0eNJvTzKUZJ/f9kZZNqE+a1F5NBzWYYmS5Q4950DmsueNwIvPUZMaoJGDXORRpmMQqRh2t4/CnC+kEk7zcToyD6KYAh71LAxpY+hyx/Fj9ZgmMwQBkUXuzB7/bxpFIhoFCynkE5/sS70OO1PAasJ4jPuvbFcGm9/kdH03H/My8HPF+VMbMCbBeBqdxEwq2JznVwKmS2c7NxgbDz8I+/yiYZrS1b0JpADZLJf5tjj1rFN1nCaHdBBzeQf3EXr7kJfLCGomSzOPk7CtKs5CcufLRF+arStiKXuUi49PfuhQeyQyI9VKB/PmHv2MnQXklv9ZrXUucpmlXXahkQuLyUv+A4YZU1z91WC/xoQZwB6M6ceBVwfLZ3Ona4IPMtEEJUvWR6QiKd3XBMJd1UDH9bbDojtsFAqqAP6EF/VIHPPaL4Jgp8LEcJJodTXTMzB2excJFFP0qPn3z46pEPVaCA6PPz9u6Bh5YEE1ZYLuhx+3IdRMkVtbQbA5l6te/uWdqvFk0AksOF3ofHMPTrQ8S+G+MiuOqyZYrg1QKhV8GFG1ia8bfoXVNqaogmc2GxjRtILb19BGNG2qR2ipFhgrMsR
 QX26kFaR
 YQbwZHEbHwsY/Y0+bfleMiHw8KCUcYBpw61jClmnmw5pogEwY4BP7micN7fs2DZ0i59HqHS/ZejiZjPm9Pa7t4u3n4vDrgY9JLp+0sjjynB3iWrSSSWlRMN+oloq0cEs1QLXoCxcy0ftzvGmED248K/NOWfSJ58WiawL1oeMD30r2Fy+DzvQpxUr8lgA3t10502rZGI2zqEZYay6R6491aBaR8E/ghzjAL5TF3UgaV1F1GQewkJ8rOl9zYOZX07lXBL2EEzQUNx2roRmS2HpXu2c0QdvpCA22QXlkQwTr61jjtdmmpmFXtcusbdHvFrZW6bNTQQPgcP4NM3vN88U7Bqb1gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 02:05:25PM +0200, Paolo Bonzini wrote:
> This ensures that fixup_user_fault() users see a writable PTE when
> they request one.  The flip side is that vmw_bo_vm_fault() now has
> to record by hand the write fault, because .pfn_mkwrite() is
> not invoked.
> 
> Prefaulting works as before because only the first entry comes
> out writable, while the following ones still end up executing
> the .pfn_mkwrite() callback.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Only some quick thoughts while reading through this, as below.. even if
some of it may make sense, I think that may be more suitable as follow up.

This looks like a good fix for a regression already to me.

> ---
>  drivers/gpu/drm/ttm/ttm_bo_vm.c            |  7 ++--
>  drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c | 42 ++++++++++++----------
>  2 files changed, 29 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/gpu/drm/ttm/ttm_bo_vm.c b/drivers/gpu/drm/ttm/ttm_bo_vm.c
> index a80510489c45..3ebde936ce60 100644
> --- a/drivers/gpu/drm/ttm/ttm_bo_vm.c
> +++ b/drivers/gpu/drm/ttm/ttm_bo_vm.c
> @@ -191,6 +191,7 @@ vm_fault_t ttm_bo_vm_fault_reserved(struct vm_fault *vmf,
>  	unsigned long pfn;
>  	struct ttm_tt *ttm = NULL;
>  	struct page *page;
> +	bool mkwrite;
>  	int err;
>  	pgoff_t i;
>  	vm_fault_t ret = VM_FAULT_NOPAGE;
> @@ -242,6 +243,7 @@ vm_fault_t ttm_bo_vm_fault_reserved(struct vm_fault *vmf,
>  	 * Speculatively prefault a number of pages. Only error on
>  	 * first page.
>  	 */
> +	mkwrite = !!(vmf->flags & FAULT_FLAG_WRITE);
>  	for (i = 0; i < num_prefault; ++i) {
>  		if (bo->resource->bus.is_iomem) {
>  			pfn = ttm_bo_io_mem_pfn(bo, page_offset);
> @@ -263,9 +265,10 @@ vm_fault_t ttm_bo_vm_fault_reserved(struct vm_fault *vmf,
>  		 * at arbitrary times while the data is mmap'ed.
>  		 * See vmf_insert_pfn_prot() for a discussion.
>  		 */
> -		ret = vmf_insert_pfn_prot(vma, address, pfn, prot);
> +		ret = vmf_insert_pfn_prot_mkwrite(vma, address, pfn, prot, mkwrite);
>  
> -		/* Never error on prefaulted PTEs */
> +		/* Never error on prefaulted PTEs and never map them writable */

I got confused when reading 1st time, but I got it then noticing the mark
dirty was done by the caller.

Two small things I thought about here:

- Comparing to the time before introducing pfn_mkwrite(), this will cause
  previously one fault (with prefaults marking all follow up ptes writable)
  to be 1 writable plus N-1 read-only. May not be the most ideal if we
  consider the 2nd WP faults on the rest N-1 later as slight overheads,

- Split the "mark WRITABLE" and "mark DIRTY" in code might be slightly
  error prone, especially if this is a common function used by multiple
  drivers, while there's only one driver that does the "mark DIRTY".

IIUC the other idea can be, do not reset @mkwrite here but instead move the
set dirty here, invoking whatever the vma's .pfn_mkwrite() is. So that we
stick two things together; maybe slightly less error prone and less dup
code when other drivers opt-in for pfn_mkwrite().

Not sure if it's a good idea, but just to raise it in case useful.  Again,
I still think this is a solid fix to the problem already.

Other than that, FWIW the whole approach looks reasonable at least to me.
I agree in the fault processing we should best resolve the fault in one
shot if possible.  In this context, FAULT_FLAG_WRITE is the flag showing
that a 2nd fault is required, then IMHO it's indeed better to resolve the
fault in one go, as proposed in this series.

Another thing I came to mind that may not really be relevant to this
regression alone, but maybe matters for the future to at least keep in
mnind: I wonder if there can be races happen while fixup_user_fault() is
resolving faults, causing the 2nd pfnmap follow code to fail once more,
say, some other thread modified the pgtable again (e.g. wr-protect with
write bit removed right after set).

So maybe pfnmap lookup and fixup_user_fault() should be done in a loop
until any of them hit real errors.. if any of such race may become a real
problem some day.

Looks like low possibility that threads will mess up with PFN maps.. but
just to raise this idea.

I believe currently our mm fault handler should be working like that with
handle_mm_fault(), hence neutral with such races (it'll loop a few more
rounds until race disappear).  I recall there used to have thoughts adding
some n_retry_max counts to the fault handler, but we didn't really do that,
and it runs all fine over the years.

Thanks,

-- 
Peter Xu


