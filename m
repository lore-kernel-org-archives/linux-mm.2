Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67FFFC55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 12:52:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AC426B007B; Mon,  3 Aug 2026 08:52:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75C5E6B009F; Mon,  3 Aug 2026 08:52:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64BDD6B00A0; Mon,  3 Aug 2026 08:52:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 372D46B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:52:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 75E47A06AF
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:33:04 +0000 (UTC)
X-FDA: 85059746688.05.6BEB2D4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id BEDF6C0009
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:33:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SttuxkJ/";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785756782;
	b=RIG9E9sXtoS8/9NlVeCuEyccA7GIRf6zMQoflgo/6gBw4DCclftuomTZAl1qAaIShdb84i
	aZzePhjtyTcvRwJT07V2F7ilBYz8n7d4/eFhFe9SUqUBjG9nH/xS1AlYUOiM9jxEE6D9NC
	6CsEhFhXE/Iobyiz2CDgz+CfYu5sPUQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SttuxkJ/";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785756782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZdkYkZfcV13Rm76AHyDXctAB6jChiddr7RTO+n76n64=;
	b=iOtj/qNz/0fGkq9qSw45NmJv+bCkbALvQfY4hnU6q+o4NMcbC5Wk46sE46ukmHOE5eXirq
	qbSzAIxN7qGmTglEHAVpPL+vPGG+FbNHrPHRB1jrIePJWnqCTR/6d2j/8m3Fql3o4DnA1J
	zvgHHCfCf76iWdYmufPsNRKNzuBwmME=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 53D3360A78;
	Mon,  3 Aug 2026 11:33:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560C51F00A3A;
	Mon,  3 Aug 2026 11:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785756782;
	bh=ZdkYkZfcV13Rm76AHyDXctAB6jChiddr7RTO+n76n64=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SttuxkJ/o74K45+6zlwW1rejwGDsKpDF91iLL81a11ij5Ult+WrfH+5LI51Ybr3wK
	 1wqUG75oERvglx5vVielESYfP5TTjDkm6+pY6B4+aYC3rIlhgztLQOMcFKZcsKK661
	 yT0qz6VnJElKTTvYXQ0L6f1AVQC3lc61PakAIFTnzL9xS0jUmFL/GMWR1q9pIIfZ9q
	 3w3M9rEiHWxklbgu1qstWXa41n1GN/pusx5mE8eLqYKfRncMwHRwHMaJhDvLPMSOJT
	 ln3QAdZ9d7yutDSCaNk+Yx9qNMfG/wvLqPW7gfofin7DjO4ti3tn8QfWqBU3rFkZyR
	 hKqzjMSANV0bw==
Message-ID: <5dcf29d5-2fb4-4550-a3e9-a39645d736c8@kernel.org>
Date: Mon, 3 Aug 2026 13:32:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/15] mm/rmap: use anon pgoff to track MAP_PRIVATE
 file-backed anon folios
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-9-e8ecfefea812@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260729-b4-scalable-cow-virt-pgoff-v3-9-e8ecfefea812@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: au4hs1nurmm6jeagn5sos9fkh45pta16
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BEDF6C0009
X-Rspam-User: 
X-HE-Tag: 1785756782-179246
X-HE-Meta: U2FsdGVkX18+Eo6WKrPv2SVBaJnJX97InvXjTXJuCf4L+ra9kVakYw0cROQv2qC79wnRF4dSHCHCj6eCaT1ZAORib7tRx8O9xujYSGuL53Q5CV8Mq/jGvhvZIBj0+9RVPVaDwhuTwa6ZO7sbUaZT8O5xyD9Y94OGk0Zwj8RfLYL5lb/eXKhFY6xUwXXQpxIZ0md5Kaj9WxmykxyWkpmZjYkApOwtbJvoY87FtqFAXOowRRVNjjhXwfyEFbIA1wf+j2z8g2K4eih6nN9gsZsTiVIiE4HSH9XkLP1n5LqRp5g5nweHGdMKyElGfnwI8YyiURCjLkBnVsAu3sIWQA6LApKq7sCh1xZXjFuabrmtHVA/8dtm7/TaIzqMrYhCH+SaQrfRzjBD1iSduejeJFgbeYTnOsGKXMkjSaYJfupKtEqyB+nuDs4GTC72iAkSsYYy2qFYNAPLxIltg8Ya+G3BkzpbI5dLXmLx9QH+RZxrJlrKCHptWXV7aUBKAlaZcOzs4ZZkJI0HXknqeSWUlnc5+s9MQYzuEgP6SO8rsgriKcF1jeSOPUGsdbFZE+fPsErGBWnTPL0xVjik9jqrKcHCJIr+nB//b0G0pKZOVnQIpE9M3tWiamEaB4AM8l1FQRzI2GeGxox+YjK/T0JVszkX7ZwQln7OFxORPP99ma/kP8CelGq6z/DutrW7UrcHokXYy+UTTrxpang6m/crBadOrbRRm+t41dfuneLFxumYdI/6EcPFBf0fbGAdVvWJomgsULddVDrWrj572rvLr6ZJWS4U9ZBTIEAm21lhpX3QiMjgOO9dhvhUfUw/reqvELaPxs4chne/iTUkfybp79AvUKBEoB7OmmflX2pnv8NWFnF90s4l5PWnKg3m0thE8ICcmwMXe0CAJefJXDzyoa+d+JzaejKDdjHnW3L8trK4N6DsNsBhXtr4bjUZBwpBIULQcT4SbzG836B+ZSwI7L8
 MRfpBIsW
 8M7HpaT8POf6IN8doIvyArxTDPsqnGDplrve6UpStyGWOV6eMF+rmHRPQGODKCL3WPWPZaTEmrJAmq4eRF7xrj2nWIZjxRg9zg2VfpQPMM9DMdRp430DKNwsNE8iUKcwq5fxg5068fX49EEHwheZ14Dzm0eH5XY+8FY4dA02rtlttQTW0KsCsRfizX0z328bftHdHVyR44sZkYmdpiATJuC96EMIT7PAm9m86dQcA2xYY0VjoBC7DfxmYc9uc8M3DqPAlZ4yYCHi6IlS/KgkpXAW18otziy4R0E4UzER7VJMSrMaNUDjdko/AM0yfn0WgaMJIh44uh0JSZ9wx3CxTXGKmNjKb/4Xcd2s2sz088uGh83XsUx4lZU2oCqzfKGh1//Lh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 18:48, Lorenzo Stoakes (ARM) wrote:
> Currently anonymous folios belonging to CoW'd MAP_PRIVATE file-backed
> mappings are indexed by their page offset within the file in which they
> were originally mapped.
> 
> This differs from anonymous folios belonging to pure anon mappings which
> are indexed by their anonymous page offset (the address at which they'd
> belong in the VMA when first faulted).
> 
> This change fixes this inconsistency, always indexing anonymous folios by
> their anonymous page offset regardless of the VMA to which they belong.
> 

Yes, this is great.

> The foundations have been laid such that we need only switch this
> functionality on such by:
> 
> * Using linear_anon_page_index() in __folio_set_anon() to assign the
>   folio's index to the anonymous linear index rather than the file-backed
>   one.
> 
> * Otherwise using linear_anon_page_index() in all instances where
>   anonymous folios are being referenced or manipulated.
> 
> * Replacing vma_address() with vma_filebacked_address() or
>   vma_anon_address() as appropriate.
> 
> * Updating the merging logic to check that anonymous page offsets are
>   aligned as well as filebacked ones for MAP_PRIVATE file-backed VMAs,
>   introducing needs_adjacent_anon_pgoff() to figure out when this is
>   required.
> 
> * Updating linear_folio_page_index() to invoke linear_anon_page_index()
>   if the folio is anonymous.
> 
> * Updating vma_address_end() to use the VMA's anonymous page offset when
>   pvmw->pgoff is anonymous.
> 
> * Correcting folio_within_range() to use anonymous page offset for
>   anonymous folios.
> 
> This will have no impact on merging of anonymous VMAs, whose page offset
> and anonymous page offset are identical, nor will it impact shared
> file-backed VMAs, which will continue to be merged based on the file-backed
> page offset.
> 
> However, MAP_PRIVATE file-backed mappings must now be aligned on anonymous
> page offset as well.
> 
> In most instances this should have no impact on merging of file-backed
> mappings, which are usually not merged all that often, let alone
> MAP_PRIVATE mapped ones, and rarely remapped and faulted before being moved
> back in place (the case in which a merge may now fail).

Agreed.

[...]

>  
>  /**
> - * vma_address - Find the virtual address a page range is mapped at.
> - * @vma: The vma which maps this object.
> - * @pgoff: The page offset within its object.
> - * @nr_pages: The number of pages to consider.
> - *
> - * If any page in this range is mapped by this VMA, return the first address
> - * where any of these pages appear.  Otherwise, return -EFAULT.
> - */
> -static inline unsigned long vma_address(const struct vm_area_struct *vma,
> -		pgoff_t pgoff, unsigned long nr_pages)
> -{
> -	return __vma_address(vma, pgoff, vma_start_pgoff(vma), nr_pages);
> -}

Good to see this go.
[...]

>  	rmap_item->anon_vma = vma->anon_vma;
> -	rmap_item->linear_page_index = linear_page_index(vma, rmap_item->address);
> +	/* The VMA is always anon/MAP_PRIVATE-file backed so use anon index. */
> +	rmap_item->linear_page_index = linear_anon_page_index(vma, rmap_item->address);

You can drop this comment: It's an anon_vma + linear_page_index pair, so the
anon_page_index is implied.

[...]

>  	WRITE_ONCE(folio->mapping, (struct address_space *) anon_vma);
> -	folio->index = linear_page_index(vma, address);
> +	folio->index = linear_anon_page_index(vma, address);


Apart from the LGTM.

-- 
Cheers,

David

