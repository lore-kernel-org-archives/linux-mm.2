Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5F59C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 07:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D34A56B009D; Mon,  7 Sep 2026 03:54:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE5476B009E; Mon,  7 Sep 2026 03:54:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAD476B009F; Mon,  7 Sep 2026 03:54:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 987276B009D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:54:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 15AA9C0677
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:54:29 +0000 (UTC)
X-FDA: 85186203858.09.CCDECF8
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf19.hostedemail.com (Postfix) with ESMTP id E70E51A0007
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:54:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="i/De0b7z";
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788767667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r3clthTDzgWN3aslLZg1SpQ+K40AFK+hZOg9wxrfKeA=;
	b=OZQTxGFluc0sEEfOxxTnOx4BoWqr0oHybRQDcoabqKbxYjTArbnKldv/neFgvlOGFLIiYf
	F24+jjBKIm4QRPprdrsxWIqoiKnr0aYf7NIPf1yAhcm3N9DQ4LkCjARgtn4wKGCua6gSUu
	4cMB5FW4lhsCEBuD5+NfTJCvs5qqPOs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788767667;
	b=Cb7NCBSPqhmEiVN1AORpxr+7kBMrGQCOoC1C1keSr8R+rxJrx4yoBmaaHaDoF+7LGPU8le
	ZZrg0wcrkO30T5hJj5QQLrhOz6qnneMS3nz58EbXRq3LhBf5wUNlBennz3HxgE5O09ABC6
	boWKrn29L9un3CNc3rWo3PQ5SU+t7sI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="i/De0b7z";
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788767662; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=r3clthTDzgWN3aslLZg1SpQ+K40AFK+hZOg9wxrfKeA=;
	b=i/De0b7zN2nNs9k+hx53UPFX5/cq1wI4O856oKzloYIDQiXpk/3cxY1ULsQYXDPDBnv38PrMc3hAkbGCAkrD3VLvEo2TNVe7bcqN+JTKHMiwZfYatD7xDJfI2RWC48S72TBhdbMUSE/+K2GRzCNsKUu2JZdWrLbXMygau2T7Itk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R691e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0XARWU-u_1788767659;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XARWU-u_1788767659 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 07 Sep 2026 15:54:20 +0800
Message-ID: <273e167f-32b7-49f0-8589-5883a4ec2d99@linux.alibaba.com>
Date: Mon, 7 Sep 2026 15:54:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/12] mm/khugepaged: rename mthp_present_ptes bitmap to
 eligible_ptes
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 Zi Yan <ziy@nvidia.com>, "Liam R . Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
References: <cover.1788533997.git.kas@kernel.org>
 <aeed00c71bab856afb18c12c8e9b904f82185942.1788533997.git.kas@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <aeed00c71bab856afb18c12c8e9b904f82185942.1788533997.git.kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: t389mwjzo8cboawiwpdrjfybei9neig6
X-Rspamd-Queue-Id: E70E51A0007
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788767665-150683
X-HE-Meta: U2FsdGVkX1+FiU/GCaUw5qYyJiKcUoUszQwo4cy50B+VcUBOF0PYpkf9CJP8DQSCUaoM+tVMDC4lytF8q4PMmMA3jDCZQAS1f+DIbwbe3kvJa7Z4I/QTYHP5iAFMODyofmGGnmoixXhd37V5hx9F+EcCHcwrWI2Itt7csERzVVXz2kvxl+ANbmMyWxymjoMR9FAVhS/gs300pRGUVrcEHGHeIVzS580hURKmyUMLhw+zckr/UyX/aKSLmldhn2Duz8QAJ5+7jt+v1OPRHiqrFYHJ+ova3gxzjrdHacmcNhYbA80TZFNHqhc9tEgnWt8BeJ/Pn7XVGluD82rtQdyMDOa1Kz5gCphcVDG6SmzNiNfwz6YQ74kdOwcipKUWbN+ODI9wiuj6ZyErwBunZnzeclul09fd/6fDSlTfwKDoY7pIqCjZfAVYYsCYA/A4G6GU0Rb+2cZGgODzv9wtoW+9sc5pGfbokWt1ZNF5W3hSpY2kD1TAkIhkfsbphWGM96xNghYrYp7cjSlP7Z7b7PpBTl3XGtysvxOoWRq9J9wdMwm+RmxjCq+BPny8KrwP968JMRxvXtZ89VPLU9Fg7puOCU0ntFNL6FkIrWrsZzHQ71gXYQ5PjjGwLZ9kDr49n4/NGJhlBiTa8yIgsAAN0WUkykJ9Z72ai7ElrHmj/9x15apqJsBXLu4thRyQ59gEaGEHhRwP2eL7MWA8R0tye/jo9n7txy32RUZofVWOAHFuXUxEUDh77FEFuYU+1iueFGAVQta5g89JgZ37L7Itn3LHVv66SCrc+DeLsFbDW7fC4L5uwQ93NRNdVVKSirHqNDEKcuLK3XAXH4UPU6vNGvmDWiTOwir1Zqkc1BKXrB6xlhLf6SWvUDwRoVL1qNvT2FMKeAwzhsSyAqSPFw4TEV4RrhcWrWerMaD8v0SsBGy1JvUOSIViYlBwSCERbVRZktoPux6eqF0IyLLSvyZG7XF
 B2M9ydDC
 tc5EVmT1D5ciH+TgLr5G//zkBPdLupJYAG+GjHnLzPU7RNR8/RwKgNvrLvnRK1ZV1kxfMcv++EIh/VfwipEr/Ko2kLsmSQkA/p2vX0DMJJMwnaZKL4KXCvAbrI5IXFa0WzaUtJ2W8UAF3/esj0iViehKgdKleF2nkhNYjaTu3Ci0b4Lhyg6+pr6aqh0cxXwuWFNBRxcLRPgivbpuvyUtPGRpcuTWX0oEsBNy48F2GJbQEVFxhIu+ciJjKknVnMnFEl/OwTlulbzDSObWg7KadnvHcFl4dS7byJZg9STXzAmTwHn6h4I+fa+9iACkh49B2QQ8oXxO0eQU86TCru80b5Dll6Lauk/EL47hEpig1FgVnpiz+uBNu1nxV8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/4/26 11:10 PM, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> The name says less than the bit means.  A set bit means not only that the
> PTE is present, but also that it passed the other checks: uffd,
> lazyfree, anonymity, sharing.  The PTE can be considered a collapse
> source.
> 
> mthp_collapse() then reads the bitmap starting at the PMD order, so the
> bitmap is not specific to mTHP either.
> 
> Name it for what a set bit means, and update the comments that named it.
> 
> No functional change.
> 
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>   mm/khugepaged.c | 18 +++++++++---------
>   1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index a6dfd8cddc50..6a437d6fe016 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -115,8 +115,8 @@ struct collapse_control {
>   	/* nodemask for allocation fallback */
>   	nodemask_t alloc_nmask;
>   
> -	/* Each bit represents a single occupied (!none/zero) page. */
> -	DECLARE_BITMAP(mthp_present_ptes, MAX_PTRS_PER_PTE);
> +	/* Each bit marks a PTE the scan accepted as a collapse source */
> +	DECLARE_BITMAP(eligible_ptes, MAX_PTRS_PER_PTE);
>   };
>   
>   /**
> @@ -627,7 +627,7 @@ static void collapse_control_init_scan(struct collapse_control *cc)
>   {
>   	memset(cc->node_load, 0, sizeof(cc->node_load));
>   	nodes_clear(cc->alloc_nmask);
> -	bitmap_zero(cc->mthp_present_ptes, MAX_PTRS_PER_PTE);
> +	bitmap_zero(cc->eligible_ptes, MAX_PTRS_PER_PTE);
>   }
>   
>   static void release_pte_folio(struct folio *folio)
> @@ -1482,8 +1482,8 @@ static unsigned int max_order_from_offset(unsigned int offset)
>    * mthp_collapse() consumes the bitmap that is generated during
>    * collapse_scan_pmd() to determine what regions and mTHP orders fit best.
>    *
> - * Each bit in cc->mthp_present_ptes represents a single occupied (!none/zero)
> - * page. We start at the PMD order and check if it is eligible for collapse;
> + * Each bit in cc->eligible_ptes marks a PTE the scan accepted as a collapse
> + * source. We start at the PMD order and check if it is eligible for collapse;
>    * if not, we check the left and right halves of the PTE page table we are
>    * examining at a lower order.
>    *

Should also update the following comments: s/occupied/accepted as a 
collapse source ?

"
  * For each of these, we determine how many PTE entries are occupied in the
  * range of PTE entries we propose to collapse, then we compare this to a
  * threshold number of PTE entries which would need to be occupied for a
  * collapse to be permitted at that order (accounting for max_ptes_none).
"

With that and Zi's comments addressed,
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

