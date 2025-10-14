Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91F20CCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 09:26:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDEDE8E00D5; Tue, 14 Oct 2025 05:26:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB6AB8E00AB; Tue, 14 Oct 2025 05:26:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7E228E00D5; Tue, 14 Oct 2025 05:26:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C162C8E00AB
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 05:26:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4F2D5C07D6
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:26:14 +0000 (UTC)
X-FDA: 83996188668.07.5255BBC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0A01DC000F
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:26:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BuliMOGb;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760433972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=epY9cTOAfMdmGHzXRCTULCEHrX9oPkawi6gd7QKfPGE=;
	b=ghR1jLvSpmMziy80VP5SsUIncV3E5FmWFbrXBC8LSYYagCoANmPQSQ57tFegQWlIpbHAPI
	I1ElM0ibVV9SWWz7D+XWAxwR3+hhimX7kbkQ+U70NQgjqcJ155pRILf//JSTQeloOvMoKn
	dJ46hRuMwjgRt+bhKsP5GuWt+c5JXx4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760433972; a=rsa-sha256;
	cv=none;
	b=W/9m9WjVxO2QlafHoaXgsGHTC8KL6NX7yfmVLM5T9ifAL+QNhn2Ltf7hIgM3vxDYW/RCFW
	o1IHOvMUdNVG8AQs0qwWRwDKtv8GN6CYT9r7Rz5SyT/6PZdVSs3mA/2FRIUAPTtUsl8LIo
	MKVWBLoDeyuL4PuZhwa9BYuMHH3/zGc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BuliMOGb;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760433971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=epY9cTOAfMdmGHzXRCTULCEHrX9oPkawi6gd7QKfPGE=;
	b=BuliMOGb0RF0XpN0SKdLyNhIi/kdkaS1jOfOfH8Y4BjdRPy5dOcAG0E58NMR1g2krAJ0gD
	rRGwSqyQ/3rwOAAVzWZlp77iWLDheI2bNMjLtq9N8FWfMVdK/cqOD+Q5/xWh/B47NKZ542
	5dcuyNcUJ2ru8YF9t6C6HnZzin5EsQM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-k6yVjSj5Os-VlpIv0wZQ3A-1; Tue, 14 Oct 2025 05:26:10 -0400
X-MC-Unique: k6yVjSj5Os-VlpIv0wZQ3A-1
X-Mimecast-MFC-AGG-ID: k6yVjSj5Os-VlpIv0wZQ3A_1760433969
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e35baddc1so52670105e9.2
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 02:26:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760433969; x=1761038769;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=epY9cTOAfMdmGHzXRCTULCEHrX9oPkawi6gd7QKfPGE=;
        b=Wmju0CSgawtfccxat949hibzydd0pJTupDFbyflJ2RcaAM05EIbeZX7JIhkWF3Rk0w
         UCvMSm3ZKNbrL+AoIogoOnYx0ft+cFl+w1aZ86ic1k8hqGwboHVUDCqgIPe5T34/nNcI
         Z/apV5qUsMx4JylwCE50C4qoxLeOtPwTA0hPShAaOVEdXTDcGPmC1mlejeAsiXpcSO02
         YFP1MU8NENj2mCFUuX2paWKYIxtTHGg3k5gEpQTmho2B9Hamn+a+3DbndAervivRs+3f
         lKDjWgBkBJmL65t+ZHUCC6sxBus9zmZ6RiGaPnQofH2Hv8gn3twEtN3GGcw3aviw+UfQ
         NtdA==
X-Forwarded-Encrypted: i=1; AJvYcCWlCOxLKdxvQOdg6w3oC2yZHB09+QBeNs2t8mefZJjwd87SKFQiVcztUuNix4obWOf9M7/9P5iGVg==@kvack.org
X-Gm-Message-State: AOJu0Yz9gcILe9ZvVE//mYtYLFDztDTLdnQEQnr9etXL2DTzpe2AGViR
	drLAKwPtAq2VCj44BrbB5+Ds0SHn5fE9dgeP0Mf/lgpdqwlJztPhsnJ72iHFVS4h9wgyUGyQ157
	ppE2iHQhoUmGqxY+wx7p0Nt1ZirN2OrlFyssw2IghiWePocnW21P4
X-Gm-Gg: ASbGncvpqegU6jr6oZpJkeTF+4wEfTDoJCM7pmwVOOdOw89a7dezts6nFaEUKXnZDrs
	+ulSwBbNvBROCwpr7N+0PQabC5Dlx2N/qZrZsan7W1AfAVB1xOBYBIS9CFcIFAg4WD8TyG0vlHU
	wtuN6+z3VsLnzEINJ0gVFrHY3ldYGmNusjpjOKHhVGQGENe5R8jjRcL4Dp30ABwOR/esgdl1vmN
	Nqvs1xpxVsSgWeX1MmFHS8cf7w/VoRowl+VonHUCQQOpMhgmnJ/WDg1FOsgM4I0zLGRMd++hqsD
	zH1+dZKbLtehqPEa+t1918yctLW239Q/HauEC2kmi2rfjHMudu5T+wH8Rx54HBPJauSXVa5Tmg=
	=
X-Received: by 2002:a05:600c:34c2:b0:46e:21c8:ad37 with SMTP id 5b1f17b1804b1-46fa9b06d3dmr160572915e9.25.1760433968674;
        Tue, 14 Oct 2025 02:26:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFz24vdSkuu30OwayZZ9SUOJh17Co9zGWb3j3wgTocTGDAZP13z/cUBLRlA4kl+O/4g18va9g==
X-Received: by 2002:a05:600c:34c2:b0:46e:21c8:ad37 with SMTP id 5b1f17b1804b1-46fa9b06d3dmr160572695e9.25.1760433968175;
        Tue, 14 Oct 2025 02:26:08 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb497aea6sm231420515e9.4.2025.10.14.02.26.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 02:26:07 -0700 (PDT)
Message-ID: <90ed950a-c3bb-46d5-91f9-338f5ca15af6@redhat.com>
Date: Tue, 14 Oct 2025 11:26:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ksm: use range-walk function to jump over holes in
 scan_get_next_rmap_item
To: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, craftfever@murena.io
Cc: Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251014055828.124522-1-pedrodemargomes@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251014055828.124522-1-pedrodemargomes@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: O1yP3ZU3oxfosxr3KtO1K2Lp-OIhbo4qpvPQN7o01AQ_1760433969
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: d6q5iajtxncwzkpdw88sge6rn7onp13k
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A01DC000F
X-HE-Tag: 1760433971-169917
X-HE-Meta: U2FsdGVkX1/03w3iESXqavJSJ7bU+sQOzuD+U3rxkLEaDvLbCo7/DECFWiJk7jm+pQBQPJP7yZry37pS18Glj/C+WGTtZr0YTLNVBE0WZMt2kyefqU0ltWP6n0jyFkByN6+/6n9Mdh+yGqktESyBhTR+TU6gQPY4Zq6eRaaNKxuxcaccT8w1wZEt7juVdFvYACEfcEz5zuE03aq+o0kmYCdqTwacTzfza16LNHIDsBC1WloGD+tSolW7WkzUWpVCFMGpDC/whukYDwdgfxQYTmDnKFJi4BKDIb49tS/96GcwucQHMNRV3dw0C/diq3KFeisFEoovUU0k94laao15J7cuPnbn9qjiP/Rg1XxyLcfU3kjMYiFKHZU2CgI/R0pY7LpmhnLE3FimsJ5JCDWamy34DYh35ycuEyfddaZ9lW5KidnmVtlblyQXabx+LtFhXROu+0Fd+LVqstOlcVgCMffqEYfBozuUjgLA7ZnngrOzRB/fxswxZnIQ5+Ijw4kO2pQWLtsIpu/QRws7gsEsphdtuesUprmQRJmxxPKtfP3evcS+4JD7YIalF65dyyj0k0E1n12SJW9xFuH2QfX6wIyqnqupy4YYqTmklFb6+LVCL1YOuqBx352g6BRC/hcX5yiQDzMcf6NzR0wIA0A5IzMO1aJqLakXRccHbSEyM6hbUkpf5ikFvI1uHWG1JnxjMVAvmRN2oUXUaJpM13Sj18BgazOTS2TUUnfGameWDEU5scXpfOgsPJCDZG7Ydhb0YMNwRvOcSpN6uVtK/euDUpFYN7yU1mwze/PQb2K5cbQn7VvEofLJrXzk+pXQCiffsjwHhi3hDaWrV4U6EHaeQpHuduoUBDXSZp8WYqcqRmtCa6op4OWuf/g8VeOd/aKfkOy2uzVMt2ttmheVa/SWIesmcU9c3iDRYLHf4u6DmB4ex2QJTENquV+xvLMz8r7BZYUieC/CTizYWywI40m
 OwwjDCuo
 6bQyKOEVelAmfFFl7gZtaG8Y4er+kdAjnXCB/GEOppV8G6pDMWGvDFGRNG5+SY/UDOQs0MAiM1471qwogvispy/ZnKqGC+zNGj9POhPxps+p4cXIBu6KNNl8sdjwa7bpIiA4FJaLHknG2DuWOOXIYsSboPjd0mqIk+qvgbO59XI37MX7c0RqVoKdVZjlvE0aDynrgb9tYnlQKwOatjq/zA25fnVL4zfH5F+OoMJ4lPP+ottW9okYBUvll08Tzz/Cas4jb0BWhcDPFOxsKBPMhwFrS9Ir5V9XHdllRpzjXNOJpXuMdIth6/BFqvGhZMEB5MGHaycIhsMjTuGJLv06iRNP0mbworCffZHGdnN2Vbdo/A9199N30wAaNCiluN+CLdHQEKF3Bbo1r3E7dn5CChVT7HXRV/zNjcPjjlntD6x5K5JfHrm1eiKCIHW1tSCjFL+Mz8XVeAy4/M7xWdurd35v7CndL/sfWnIn624hkccvoAfMsuxMjC9hWMQ5egFEwsbcl6uZvaKfd5EbobbZwqyr4Y9lhpO1ioF1cxakNkIfO4347UGUt+UDg0YESzqo+N9oITtztou8q9duVNStghbO0gA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.10.25 07:58, Pedro Demarchi Gomes wrote:
> Currently, scan_get_next_rmap_item() walks every page address in a VMA
> to locate mergeable pages. This becomes highly inefficient when scanning
> large virtual memory areas that contain mostly unmapped regions.
> 
> This patch replaces the per-address lookup with a range walk using
> walk_page_range(). The range walker allows KSM to skip over entire
> unmapped holes in a VMA, avoiding unnecessary lookups.
> 
> To evaluate this change, I created a test that maps a 1 TB virtual area
> where only the first and last 10 MB are populated with identical data.
> With this patch applied, KSM scanned and merged the region approximately
> seven times faster.
> 
> This problem was previously discussed in [1].
> 
> [1] https://lore.kernel.org/linux-mm/423de7a3-1c62-4e72-8e79-19a6413e420c@redhat.com/
> 
> Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
> ---
>   mm/ksm.c | 136 ++++++++++++++++++++++++++++++++-----------------------
>   1 file changed, 79 insertions(+), 57 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 3aed0478fdce..584fd987e8ae 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -2455,15 +2455,80 @@ static bool should_skip_rmap_item(struct folio *folio,
>   	return true;
>   }
>   
> +struct ksm_walk_private {
> +	struct page *page;
> +	struct ksm_rmap_item *rmap_item;
> +	struct ksm_mm_slot *mm_slot;
> +};
> +
> +static int ksm_walk_test(unsigned long addr, unsigned long next, struct mm_walk *walk)
> +{
> +	struct vm_area_struct *vma = walk->vma;
> +
> +	if (!vma || !(vma->vm_flags & VM_MERGEABLE))

The anon_vma check should go in here as well.

How can we possibly get !vma?

> +		return 1;
> +	return 0;
> +}
> +
> +static int ksm_pte_entry(pte_t *pte, unsigned long addr,
> +			    unsigned long end, struct mm_walk *walk)
> +{
> +	struct mm_struct *mm = walk->mm;
> +	struct vm_area_struct *vma = walk->vma;
> +	struct ksm_walk_private *private = (struct ksm_walk_private *) walk->private;
> +	struct ksm_mm_slot *mm_slot = private->mm_slot;
> +	pte_t ptent = ptep_get(pte);
> +	struct page *page = pfn_to_online_page(pte_pfn(ptent));

Oh no.

vm_normal_page()

> +	struct ksm_rmap_item *rmap_item;
> +	struct folio *folio;
> +
> +	ksm_scan.address = addr;
> +
> +	if (ksm_test_exit(mm))
> +		return 1;
> +
> +	if (!page)
> +		return 0;
> +
> +	folio = page_folio(page);
> +	if (folio_is_zone_device(folio) || !folio_test_anon(folio))
> +		return 0;
> +
> +	folio_get(folio);
> +
> +	flush_anon_page(vma, page, ksm_scan.address);
> +	flush_dcache_page(page);
> +	rmap_item = get_next_rmap_item(mm_slot,
> +		ksm_scan.rmap_list, ksm_scan.address);
> +	if (rmap_item) {
> +		ksm_scan.rmap_list =
> +				&rmap_item->rmap_list;
> +
> +		if (should_skip_rmap_item(folio, rmap_item)) {
> +			folio_put(folio);
> +			return 0;
> +		}
> +		ksm_scan.address = end;
> +		private->page = page;
> +	} else
> +		folio_put(folio);
> +

You're under PTL, get_next_rmap_item() will perform an allocation, so 
that won't work.

Observe how the original code worked around that by performing all magic 
outside of the PTL (folio_walk_end()).

When you switch to .pmd_entry() (see below) you will be able to handle it.

What you could also try doing is returing page+folio and letting the 
caller deal with everything starting at the flush_anon_page().

> +	private->rmap_item = rmap_item;
> +	return 1;
> +}
> +
> +struct mm_walk_ops walk_ops = {
> +	.pte_entry = ksm_pte_entry,
> +	.test_walk = ksm_walk_test,
> +	.walk_lock = PGWALK_RDLOCK,
> +};

It's more complicated: you'd be remapping each PMD to be mapped by PTEs 
first, which is not what we want. You'll have to handle pmd_entry 
instead of pte_entry.

> +
>   static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
>   {
>   	struct mm_struct *mm;
>   	struct ksm_mm_slot *mm_slot;
>   	struct mm_slot *slot;
> -	struct vm_area_struct *vma;
> -	struct ksm_rmap_item *rmap_item;
> -	struct vma_iterator vmi;
> -	int nid;
> +	int nid, ret;
>   
>   	if (list_empty(&ksm_mm_head.slot.mm_node))
>   		return NULL;
> @@ -2527,64 +2592,21 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
>   
>   	slot = &mm_slot->slot;
>   	mm = slot->mm;
> -	vma_iter_init(&vmi, mm, ksm_scan.address);
>   
>   	mmap_read_lock(mm);
>   	if (ksm_test_exit(mm))
>   		goto no_vmas;
>   
> -	for_each_vma(vmi, vma) {
> -		if (!(vma->vm_flags & VM_MERGEABLE))
> -			continue;
> -		if (ksm_scan.address < vma->vm_start)
> -			ksm_scan.address = vma->vm_start;
> -		if (!vma->anon_vma)
> -			ksm_scan.address = vma->vm_end;
> -
> -		while (ksm_scan.address < vma->vm_end) {
> -			struct page *tmp_page = NULL;
> -			struct folio_walk fw;
> -			struct folio *folio;
> -
> -			if (ksm_test_exit(mm))
> -				break;
> -
> -			folio = folio_walk_start(&fw, vma, ksm_scan.address, 0);
> -			if (folio) {
> -				if (!folio_is_zone_device(folio) &&
> -				     folio_test_anon(folio)) {
> -					folio_get(folio);
> -					tmp_page = fw.page;
> -				}
> -				folio_walk_end(&fw, vma);
> -			}
> -
> -			if (tmp_page) {
> -				flush_anon_page(vma, tmp_page, ksm_scan.address);
> -				flush_dcache_page(tmp_page);
> -				rmap_item = get_next_rmap_item(mm_slot,
> -					ksm_scan.rmap_list, ksm_scan.address);
> -				if (rmap_item) {
> -					ksm_scan.rmap_list =
> -							&rmap_item->rmap_list;
> -
> -					if (should_skip_rmap_item(folio, rmap_item)) {
> -						folio_put(folio);
> -						goto next_page;
> -					}
> -
> -					ksm_scan.address += PAGE_SIZE;
> -					*page = tmp_page;
> -				} else {
> -					folio_put(folio);
> -				}
> -				mmap_read_unlock(mm);
> -				return rmap_item;
> -			}
> -next_page:
> -			ksm_scan.address += PAGE_SIZE;
> -			cond_resched();

You're dropping all cond_resched(), which will be a problem.

> -		}
> +	struct ksm_walk_private walk_private = {
> +		.page = NULL,
> +		.rmap_item = NULL,
> +		.mm_slot = ksm_scan.mm_slot
> +	};

empty line missing

> +	ret = walk_page_range(mm, ksm_scan.address, -1, &walk_ops, (void *) &walk_private);
> +	*page = walk_private.page;
> +	if (ret) {
> +		mmap_read_unlock(mm);
> +		return walk_private.rmap_item;
>   	}
>   
>   	if (ksm_test_exit(mm)) {


-- 
Cheers

David / dhildenb


