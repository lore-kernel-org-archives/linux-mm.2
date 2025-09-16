Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08F6DCAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 12:43:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B5508E0002; Tue, 16 Sep 2025 08:43:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38BE98E0001; Tue, 16 Sep 2025 08:43:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C93B8E0002; Tue, 16 Sep 2025 08:43:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1BBC08E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 08:43:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BB24E83F50
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:43:55 +0000 (UTC)
X-FDA: 83895080430.24.0082EC0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 293DA40006
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:43:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UW0ANfTm;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758026634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kpK1kwP10bSXerczcPGeSy6KN0/MNzxVxoI2ZYN7Uf4=;
	b=jD6mPFuop0VBS9josnReVx9pCLo3GoDdUlIBfFKG7AIZWfXXYUSwASEP7EF8fURn9meGEg
	aEfZKS5qEu3YVphMS5GHzEVM4M2nNE0EK5wLwr5shAV78GlLg5Yb+wdrHVNOHOvy64G1Sx
	/8SLm4mbJUBAlc1DjmWaV7bNfSwtgMw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758026634; a=rsa-sha256;
	cv=none;
	b=gYHvUJUR3tQlbvVBN2L+8aN8WzpRImxFSihOKXZyMuuUrI+c1UI8wXJlnJ4zgr1X6RSkRx
	1WIyaOQwREEGyqqIgvOCWUu3jCxYz2FszUc9jGw8mpib5uKPW8CR9e64+ShQlkw1dRKbKn
	g/Z0O8/FiEbHcYYRynrhDS/kUB8QUYk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UW0ANfTm;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 55C56601DF;
	Tue, 16 Sep 2025 12:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC0DC4CEFA;
	Tue, 16 Sep 2025 12:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758026633;
	bh=SYVYoZGy/SIg0iMBfH8qcSuCZt73k2SHPgy9MLZisf4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=UW0ANfTmlociasU/WK/Ojn9FP1HnWWAjR/CfLsC/kvxHRUMNCO43Ke32DMFB21hMz
	 eTHzectn83NFGBF3QHZTNqQeLHSaDmbKXSoFBZchwP8xBd7jlCCTlEwg+gXapRRdFf
	 xEUfvEJo8ztsSitWodD3jtF5+SASGsRwYV2Kym5J4mXcAGW+mVXZ/vP7nLv7Il4u5t
	 d67gpOV+hARxOIW7N3mAcFvMLZaPdCpAtAzTg3DuhxPCpEHsAIzaw4FWSkYpLojRzd
	 S/K8E4rBYK7TtOppAtNFJD1GBpwLxv0zivZ/Hs68cHaYR/VupobUOZn8qp+c4m22vV
	 zY8iHvPSAeBdA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Alexander Graf <graf@amazon.com>,  Baoquan
 He <bhe@redhat.com>,  Changyuan Lyu <changyuanl@google.com>,  Chris Li
 <chrisl@kernel.org>,  Jason Gunthorpe <jgg@nvidia.com>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] kho: add support for preserving vmalloc allocations
In-Reply-To: <aMgdwE83dKdT1K7L@kernel.org>
References: <20250908103528.2179934-1-rppt@kernel.org>
	<20250908103528.2179934-2-rppt@kernel.org> <mafs0ldmon784.fsf@kernel.org>
	<aMgdwE83dKdT1K7L@kernel.org>
Date: Tue, 16 Sep 2025 14:43:50 +0200
Message-ID: <mafs0frcmin3t.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: mkhetb9r8aadca8q9ji8ed6s1jjjoj9n
X-Rspamd-Queue-Id: 293DA40006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758026634-287776
X-HE-Meta: U2FsdGVkX18iwVRiQyc33uFXHRJD0QJfldH3LlnXQB2Mh1tsPCCH372LZpLgF3X7vwqaUT702y9JLNJ8HRjNSIITky4yV9R8vWzA/on/h46HAaI6n0nSAjoUXP6laJnxVYMsj/JNsOFnX9qgkm1j9IoTtPBhb7HAM/RcOiNHWwiJQFD37PHLXzheL7RejakC3fJaxJ/B2i4EIZiZbL1nzWU6GhDVn3GS47Zwk6QP8b7ZVxU2FZIXJ603xhYznoK0LlKnmw14e+Mfhw2cFEw7AbcmDYE3EZmIVj4xdQmBDCapO/qLfpgHUV/p1HJTq/H58YvJ7n1XtZ6C9nfQMmHrzeWAYtBYUSoHyLwWBSRPOQNtJJGR2VIrBUIx0UUKLStolB+qPBe7B8TSD7c2xtXQnIP2mopg/iiwv53+V2YLyJTOJCbDNo0lYpzfE8dAZh7vIxzxBMiajBmrxPt2ObYPK1790wcnd/gv4lfW3iSOzKFxPuhPWJMOrl8aYq3BLmxjUaGYbiCZ3NoN/1+0moDJA0+ncDbWptIfgwXncF/W1f2m3kMEWmd0RYc7ZfF35w+cWrg0VWdaUTvuaUEUFEJEV6/Qsz6jVfOu4+FmfEwTRwFcoZ03oL6IeDlKN0r5TfIpIRmkspSKN1emTYfcB9dNqDB3CJtjEa4COiJl77thy/TK3WOmbzmwptqM7zgi70jYgsGR5GjkZRrfPZ/EPWHI8YLE2HqEfCB39+0zPAGBYmMbQkOgyjQ5vUCr2/xMzQZ00sOqF160BqjcQ2s+MOachWCy4O8L7gZwBMHomY2BydZ5K68xo9tz4M+sRiIM53+RBs/XA+pmyeXKXFsc3PRb+iMgHLa0PZdYZ0GesasLWNCBSwD6xig1xD0fmgA4bLM2jLK8YquoQn79VXBlt2zcf8Q+y21Pze517NLcwHDqkGwU0GIYpkDpMMVbDo64ADVbyOvNCiugy63a0kOUoxx
 OmwxiknW
 I/pPUZrO4/V+AqK2QPButH+EdraH7gKFDAPspApUeXgtTeksnPrexG+hypnMvncaBQyXNqxegCZXuQm9SZttlOR2HiDytfLSdyUZVDKn0drapLZnlt+ZSB3ClK9n8VIbfWvPahLfCFXhZZ2R37P+biqRhcyV7cLu6DRZV2IWucrZruBKs0SrxD+0q8PLS4jNIGnSB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

On Mon, Sep 15 2025, Mike Rapoport wrote:

> On Mon, Sep 08, 2025 at 08:12:59PM +0200, Pratyush Yadav wrote:
>> On Mon, Sep 08 2025, Mike Rapoport wrote:
>> 
>> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>> >
>> > A vmalloc allocation is preserved using binary structure similar to
>> > global KHO memory tracker. It's a linked list of pages where each page
>> > is an array of physical address of pages in vmalloc area.
>> >
>> > kho_preserve_vmalloc() hands out the physical address of the head page
>> > to the caller. This address is used as the argument to
>> > kho_vmalloc_restore() to restore the mapping in the vmalloc address
>> > space and populate it with the preserved pages.
>> >
>> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
[...]
>> > +	while (chunk) {
>> > +		struct page *page;
>> > +
>> > +		for (int i = 0; i < chunk->hdr.num_elms; i++) {
>> > +			phys_addr_t phys = chunk->phys[i];
>> > +
>> > +			for (int j = 0; j < (1 << order); j++) {
>> > +				page = phys_to_page(phys);
>> > +				kho_restore_page(page, 0);
>> > +				pages[idx++] = page;
>> 
>> This can buffer-overflow if the previous kernel was buggy and added too
>> many pages. Perhaps keep check for this?
>
> You mean it added more than total_pages?
> But the preserve part adds exactly vm->nr_pages, so once we get it right
> what bugs do you expect here? 

The main reason is defensive programming. My mental model is to treat
the data from the previous kernel as external input, and so we should
always validate it. The kernel that did the preserve and the kernel that
does the restore are very different, and between them either may have a
bug or some incompatibility/disagreement on the data format. Catching
these inconsistencies and failing gracefully is a lot better than
silently corrupting memory and having hard to catch bugs. No one plans
to add bugs, but they always show up somehow :-)

And we do a lot of that KHO already. See the FDT parsing in memblock
preservation for example.

	p_start = fdt_getprop(fdt, offset, "start", &len_start);
	p_size = fdt_getprop(fdt, offset, "size", &len_size);
	if (!p_start || len_start != sizeof(*p_start) || !p_size ||
	    len_size != sizeof(*p_size)) {
		return false;
	}
	[...]

It checks that FDT contains sane data or errors out otherwise. Similar
checks exist in other places too.

>  
>> > +				phys += PAGE_SIZE;
>> > +			}
>> > +		}
>> > +
>> > +		page = virt_to_page(chunk);
>> > +		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
>> > +		kho_restore_page(page, 0);
>> > +		__free_page(page);
>> > +	}
>> > +
>> > +	area = __get_vm_area_node(nr * PAGE_SIZE, align, shift, flags,
>> > +				  VMALLOC_START, VMALLOC_END, NUMA_NO_NODE,
>> > +				  GFP_KERNEL, __builtin_return_address(0));
>> > +	if (!area)
>> > +		goto err_free_pages_array;
>> > +
>> > +	addr = (unsigned long)area->addr;
>> > +	size = get_vm_area_size(area);
>> > +	err = vmap_pages_range(addr, addr + size, PAGE_KERNEL, pages, shift);
>> > +	if (err)
>> > +		goto err_free_vm_area;
>> > +
>> > +	return area->addr;
>> 
>> You should free the pages array before returning here.
>
> Why? They get into vm->pages.

Do they? I don't see any path in vmap_pages_range() taking a reference
to the pages array. They use the array, but never take a reference to
it.

The core of vmap_pages_range() is in __vmap_pages_range_noflush(). That
function has two paths:

	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
			page_shift == PAGE_SHIFT)
		return vmap_small_pages_range_noflush(addr, end, prot, pages);

	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
		int err;

		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
					page_to_phys(pages[i]), prot,
					page_shift);
		if (err)
			return err;

		addr += 1UL << page_shift;
	}

	return 0;

The latter path (the for loop) _uses_ pages but never takes a reference
to it. The former, vmap_small_pages_range_noflush(), goes through a the
sequence of functions vmap_pages_{p4d,pud,pmd}_range(), eventually
landing in vmap_pages_pte_range(). That function's only use of the pages
array is the below:

	do {
		struct page *page = pages[*nr];
		[...]
	} while (pte++, addr += PAGE_SIZE, addr != end);

So I don't see anything setting area->pages here.

Note that vmap() does set area->pages if given the VM_MAP_PUT_PAGES
flag. It also calls vmap_pages_range() first and then sets area->pages
and area->nr_pages. So if you want to mimic that behaviour, I think you
have to explicitly make these assignments in kho_restore_vmalloc().

Similarly for __vmalloc_area_node(), it does area->pages =
__vmalloc_node_noprof() and then does vmap_pages_range() (also sets
area->nr_pages).

Side note: would it be a better idea to teach vmap() to take higher
order pages instead, to make this path simpler? I don't know the subtle
differences between these mapping primitives to know if that makes
sense. I seems to do pretty much what this function is doing with the
exception of only dealing with 0-order pages.

-- 
Regards,
Pratyush Yadav

