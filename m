Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DAC9E674BD
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 15:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 110CE6B0089; Mon, 22 Dec 2025 10:00:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BF306B008A; Mon, 22 Dec 2025 10:00:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE3046B008C; Mon, 22 Dec 2025 10:00:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DCC9D6B0089
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 10:00:41 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7DA631601F9
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:00:41 +0000 (UTC)
X-FDA: 84247418682.17.D0C9322
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3F5BFC0029
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:00:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VNBNlB7a;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766415639; a=rsa-sha256;
	cv=none;
	b=CsgUwGhxZ/TQrPjZuFgWQCws73GBhqqaTVHkwR9qRu2bqLdvz/U7HBYTYiZadpYFnjktUO
	wsVr517O2I63U3IZukRhFuAoPYDq2LMXgQdfp0KqnWYyktfIkoX8nqFb6i/cGz5QYO3OFi
	S3jtXVS3c1lCKHpN1YSppedu9kjhs5c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VNBNlB7a;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766415639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kZcWdXINOjNsDOZ2OYH7+hKShhOm/Yw65IE6ItXffRg=;
	b=Y8iHK6E8qKj02W6NFHyXgky89nuy3GyVn2zd8k1sVIAF02heJYzpcjgezVDkcp5FrlBfEb
	pZkLHQcyHxiXVSAK9GlFWxGpd9dLUGsh8m5UudRDrB8EAnmhKc2EYdWzDegUG1U2ZE8M1Z
	gZMsYSFdfHQzVPYvsUyACA3lfA/I4xc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 45AAE43D2B;
	Mon, 22 Dec 2025 15:00:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52DB4C4AF09;
	Mon, 22 Dec 2025 15:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766415638;
	bh=WUMdA9cBDJeEYz75563jYOGEbAxLXO3ZdR61VPPSp+8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VNBNlB7aKaoP8mavO9bsSx9dI2aqOjjnU3ODSYe3c0nw1U5cQP8bgtLXpXRBruvvu
	 3lrsd6zSkq3Lqjb863nIpsDL19lheSyi0jQHrryfVPPwqyAZP3bHUNA4Cs3YXmYqiW
	 s+YjcaSyAyUwUzHb/REbHOLQkWoLK7LCVg5fp6QYdBH5GzKS8bjtYb6tpe3XcyqwsY
	 jKW138z5XkTmbX0XkAHNzSr61IuBx1N9m7dA2DkYIsnh6oOR0olKKtWYyr1+VjaXB1
	 uEP4r+lmza1lFFUxxbrw9jI9cHKzwqDW3A4ob7lt8CQJC0BYUBkRll0ESx5/gekcDc
	 1cCSWnpZk2dvQ==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 8B85CF40069;
	Mon, 22 Dec 2025 10:00:36 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Mon, 22 Dec 2025 10:00:36 -0500
X-ME-Sender: <xms:FF1JaWdHwvLQc3cMLO05AKxZM06EdkIamM-EiEZHi9yQ5PI-W2RSJg>
    <xme:FF1JaST3gzow0Y2jc2o2_f-JQ20cgh4BWuvy1zMhJXrwVOI_oZ31XwWv3ltxmaXw7
    C0UqI5h8908NowW3906gCJPTiG9GHvX4EFmRBbtGTBdihOx6iBkePw>
X-ME-Received: <xmr:FF1JaRna1frLxtjgN-gIvnWCaYnaMB1huwCMGMkUWYiQp9SfYAo7bnvAYWiEhQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdehjedvgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtugfgjgestheksfdttddtjeenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepvddufeetkedvheektdefhfefjeeujeejtdejuedufefhveekkeeffeetvedvffek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfeekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghpthhtohepohhsrg
    hlvhgrughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdho
    rhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgiipdhrtghpthhtoheplhhorh
    gvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepiihihies
    nhhvihguihgrrdgtohhmpdhrtghpthhtohepsghhvgesrhgvughhrghtrdgtohhmpdhrtg
    hpthhtohepmhhhohgtkhhosehsuhhsvgdrtghomhdprhgtphhtthhopehhrghnnhgvshes
    tghmphigtghhghdrohhrgh
X-ME-Proxy: <xmx:FF1Jaeo9tbEIum7ctFZOIKAo7eF8eAm48gFKQ2kY6HBMXsJ_BtvUNA>
    <xmx:FF1JaZbC6B0EFxJyiTHc-3fk7ZIdXHj9xcxiZVHdvaTVuduO9sLEMQ>
    <xmx:FF1JaSxoVxnkS8f3P9YDhCNm66Y5kMSsSJdXkPf4UwG-E-ANuBT3PQ>
    <xmx:FF1JaWg9w1V9n-broT1lxw2RJeD2j6ietebw746XpOtYG8STCeqV7A>
    <xmx:FF1JaSL4lkAMG4WteoC4HNhyMPJwkE0Oav1hlS2FjlnkrJDayGEebhr_>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 22 Dec 2025 10:00:35 -0500 (EST)
Date: Mon, 22 Dec 2025 15:00:35 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>, 
	Frank van der Linden <fvdl@google.com>
Subject: Re: [PATCHv2 08/14] mm/hugetlb: Refactor code around vmemmap_walk
Message-ID: <cogzomaems6f4v2ihijwd3qoq5mb6g7lr37xrrwynbdmjjgy7y@5dytmftheuhz>
References: <20251218150949.721480-1-kas@kernel.org>
 <20251218150949.721480-9-kas@kernel.org>
 <027c07cd-e2cf-4b00-be21-54faa5cbaead@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <027c07cd-e2cf-4b00-be21-54faa5cbaead@linux.dev>
X-Rspamd-Queue-Id: 3F5BFC0029
X-Stat-Signature: oin39hkjcoj1kd59qft3fabstmsfu1mj
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766415639-75216
X-HE-Meta: U2FsdGVkX18UrVyhyEmGUy52ofdmLoZLXjU0sZl4KjTuoZ8QbFOGYycCduNF3X9Dvh85s0nXq7aSvCfpbPfoaIzgVFFO8NuuV8kt2ljHO6q9ycOjcKCz1CPFbRBaSHAW6jWNW/AGG/pEe6ct7fZVnWZM8M1IAEWlehNAM1GbRg0QjEVYqZf4h8Crc4X8UYM4NhdC8RNnxvexe2D34HsJDFZ8y8H/krwP5z3HIZMg084xs5XDez0BKOUoVDW8rqfTelynUotad2N112jiJLZDgVjufd50xcOSZ/6hDj2MExWiDnKHxx6nP76nhj/wR563inTrHSqscrofG3se3kzNtyEgc2937ENgpfceW+uFpIchKzmQSHoJ6uNxoh+QUYlWmm7PIyBGad6rS4d9Y40CYHQ9TmHM/n7nEKa/Y1EnK5hP9Ea/VicoTfuUV7+tkAVPgF2u9v3ED9/wWKVFnUmnTGXjbLO9yH/UReTEhhA5bi16uDIXs/uGGBjv5yqdDA8swM/KbSkDUTU54mUAdq+qVsKV0rQF91J95wvSqnkKd1f02m0gG+Bm3VxyxOadhEGJ1b/Zfiebo6qMuVZ0rEjhqW9Z1bpqGMJk5N3a0fmccWBQeL7Ka4/3ipA3wwm1aSU9S52Ikvv5fBjlxiAqLKDlaAWQNNk30v+p0KfTgeqNofMVCw8AxppD8AsbT0sY0K2ha32CEu3rwX04B2QxHPCzx9/2keb1r2f0sBWk8qmcpQmwAjz9Tnq0Jc1nvRtQ+Tmq3SqZj5v4TkQaXd5ICzIM5BWhX9AjXql8veesNkurR/22Lwrm39kkVS3dcLlKBC6X6ipus7WxDhXUf3yQ+6TRoJNmymrJZmoKgUtIOePUp3DV/6rsaIvXDkuQnWMVvbsEoHtJ5QPDlIfYQvrdJJmbwdTJXCHzHyYfR87bPc07NgdV5Uf8Gc+AMhgETVmf6W/XJrTXvgCJcyhXPPimmN5
 yBVggOI2
 3h3qx1YYUwEN51fCZjLLXeLpmGiXkkzoQCvhzvsVWv4KYWyDvn4qOtzGZoMCYTq/W3DeWXVXfbgdKRfhuKwUcf1Sum6xcTFjUxYr+UcDVYRvi79vnz52N5apHEC3auDRWjLjM1+UNNwwqtcm25ww/Knc/uORk24yF7jUyaANxiF9mK2VNsJlQc+Gn7+7as6jBJ/EL+gE+OCk4QVK6nwYfEZa4myt+kU5vMqJ/o6a39oHL7gf9381Hp01gvv3dn6LdJPJj72DM5FsQOuz/rS7tDqnQqNptS14RVQEnBx6JAMzsjSlVA7+6CCi3VO4LTiX+RjnuT+upLut4OZoNSNALFYfHgQ5/HuTB0ZC79GuWR/xejB7RXPikhOBh9YTXUSr2tMjLgNvvNEEyoftfR+J5KQztQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 22, 2025 at 01:54:47PM +0800, Muchun Song wrote:
> 
> 
> On 2025/12/18 23:09, Kiryl Shutsemau wrote:
> > To prepare for removing fake head pages, the vmemmap_walk code is being reworked.
> > 
> > The reuse_page and reuse_addr variables are being eliminated. There will
> > no longer be an expectation regarding the reuse address in relation to
> > the operated range. Instead, the caller will provide head and tail
> > vmemmap pages, along with the vmemmap_start address where the head page
> > is located.
> > 
> > Currently, vmemmap_head and vmemmap_tail are set to the same page, but
> > this will change in the future.
> > 
> > The only functional change is that __hugetlb_vmemmap_optimize_folio()
> > will abandon optimization if memory allocation fails.
> > 
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > ---
> >   mm/hugetlb_vmemmap.c | 198 ++++++++++++++++++-------------------------
> >   1 file changed, 83 insertions(+), 115 deletions(-)
> > 
> > diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> > index ba0fb1b6a5a8..d18e7475cf95 100644
> > --- a/mm/hugetlb_vmemmap.c
> > +++ b/mm/hugetlb_vmemmap.c
> > @@ -24,8 +24,9 @@
> >    *
> >    * @remap_pte:		called for each lowest-level entry (PTE).
> >    * @nr_walked:		the number of walked pte.
> > - * @reuse_page:		the page which is reused for the tail vmemmap pages.
> > - * @reuse_addr:		the virtual address of the @reuse_page page.
> > + * @vmemmap_start:	the start of vmemmap range, where head page is located
> > + * @vmemmap_head:	the page to be installed as first in the vmemmap range
> > + * @vmemmap_tail:	the page to be installed as non-first in the vmemmap range
> >    * @vmemmap_pages:	the list head of the vmemmap pages that can be freed
> >    *			or is mapped from.
> >    * @flags:		used to modify behavior in vmemmap page table walking
> > @@ -34,11 +35,14 @@
> >   struct vmemmap_remap_walk {
> >   	void			(*remap_pte)(pte_t *pte, unsigned long addr,
> >   					     struct vmemmap_remap_walk *walk);
> > +
> >   	unsigned long		nr_walked;
> > -	struct page		*reuse_page;
> > -	unsigned long		reuse_addr;
> > +	unsigned long		vmemmap_start;
> > +	struct page		*vmemmap_head;
> > +	struct page		*vmemmap_tail;
> >   	struct list_head	*vmemmap_pages;
> > +
> >   /* Skip the TLB flush when we split the PMD */
> >   #define VMEMMAP_SPLIT_NO_TLB_FLUSH	BIT(0)
> >   /* Skip the TLB flush when we remap the PTE */
> > @@ -140,14 +144,7 @@ static int vmemmap_pte_entry(pte_t *pte, unsigned long addr,
> >   {
> >   	struct vmemmap_remap_walk *vmemmap_walk = walk->private;
> > -	/*
> > -	 * The reuse_page is found 'first' in page table walking before
> > -	 * starting remapping.
> > -	 */
> > -	if (!vmemmap_walk->reuse_page)
> > -		vmemmap_walk->reuse_page = pte_page(ptep_get(pte));
> > -	else
> > -		vmemmap_walk->remap_pte(pte, addr, vmemmap_walk);
> > +	vmemmap_walk->remap_pte(pte, addr, vmemmap_walk);
> >   	vmemmap_walk->nr_walked++;
> >   	return 0;
> > @@ -207,18 +204,12 @@ static void free_vmemmap_page_list(struct list_head *list)
> >   static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
> >   			      struct vmemmap_remap_walk *walk)
> >   {
> > -	/*
> > -	 * Remap the tail pages as read-only to catch illegal write operation
> > -	 * to the tail pages.
> > -	 */
> > -	pgprot_t pgprot = PAGE_KERNEL_RO;
> >   	struct page *page = pte_page(ptep_get(pte));
> >   	pte_t entry;
> >   	/* Remapping the head page requires r/w */
> > -	if (unlikely(addr == walk->reuse_addr)) {
> > -		pgprot = PAGE_KERNEL;
> > -		list_del(&walk->reuse_page->lru);
> > +	if (unlikely(addr == walk->vmemmap_start)) {
> > +		list_del(&walk->vmemmap_head->lru);
> >   		/*
> >   		 * Makes sure that preceding stores to the page contents from
> > @@ -226,9 +217,16 @@ static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
> >   		 * write.
> >   		 */
> >   		smp_wmb();
> > +
> > +		entry = mk_pte(walk->vmemmap_head, PAGE_KERNEL);
> > +	} else {
> > +		/*
> > +		 * Remap the tail pages as read-only to catch illegal write
> > +		 * operation to the tail pages.
> > +		 */
> > +		entry = mk_pte(walk->vmemmap_tail, PAGE_KERNEL_RO);
> >   	}
> > -	entry = mk_pte(walk->reuse_page, pgprot);
> >   	list_add(&page->lru, walk->vmemmap_pages);
> >   	set_pte_at(&init_mm, addr, pte, entry);
> >   }
> > @@ -255,16 +253,13 @@ static inline void reset_struct_pages(struct page *start)
> >   static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
> >   				struct vmemmap_remap_walk *walk)
> >   {
> > -	pgprot_t pgprot = PAGE_KERNEL;
> >   	struct page *page;
> >   	void *to;
> > -	BUG_ON(pte_page(ptep_get(pte)) != walk->reuse_page);
> > -
> >   	page = list_first_entry(walk->vmemmap_pages, struct page, lru);
> >   	list_del(&page->lru);
> >   	to = page_to_virt(page);
> > -	copy_page(to, (void *)walk->reuse_addr);
> > +	copy_page(to, (void *)walk->vmemmap_start);
> >   	reset_struct_pages(to);
> >   	/*
> > @@ -272,7 +267,7 @@ static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
> >   	 * before the set_pte_at() write.
> >   	 */
> >   	smp_wmb();
> > -	set_pte_at(&init_mm, addr, pte, mk_pte(page, pgprot));
> > +	set_pte_at(&init_mm, addr, pte, mk_pte(page, PAGE_KERNEL));
> >   }
> >   /**
> > @@ -282,33 +277,29 @@ static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
> >    *             to remap.
> >    * @end:       end address of the vmemmap virtual address range that we want to
> >    *             remap.
> > - * @reuse:     reuse address.
> > - *
> >    * Return: %0 on success, negative error code otherwise.
> >    */
> > -static int vmemmap_remap_split(unsigned long start, unsigned long end,
> > -			       unsigned long reuse)
> > +static int vmemmap_remap_split(unsigned long start, unsigned long end)
> >   {
> >   	struct vmemmap_remap_walk walk = {
> >   		.remap_pte	= NULL,
> > +		.vmemmap_start	= start,
> >   		.flags		= VMEMMAP_SPLIT_NO_TLB_FLUSH,
> >   	};
> > -	/* See the comment in the vmemmap_remap_free(). */
> > -	BUG_ON(start - reuse != PAGE_SIZE);
> > -
> > -	return vmemmap_remap_range(reuse, end, &walk);
> > +	return vmemmap_remap_range(start, end, &walk);
> >   }
> >   /**
> >    * vmemmap_remap_free - remap the vmemmap virtual address range [@start, @end)
> > - *			to the page which @reuse is mapped to, then free vmemmap
> > - *			which the range are mapped to.
> > + *			to use @vmemmap_head/tail, then free vmemmap which
> > + *			the range are mapped to.
> >    * @start:	start address of the vmemmap virtual address range that we want
> >    *		to remap.
> >    * @end:	end address of the vmemmap virtual address range that we want to
> >    *		remap.
> > - * @reuse:	reuse address.
> > + * @vmemmap_head: the page to be installed as first in the vmemmap range
> > + * @vmemmap_tail: the page to be installed as non-first in the vmemmap range
> >    * @vmemmap_pages: list to deposit vmemmap pages to be freed.  It is callers
> >    *		responsibility to free pages.
> >    * @flags:	modifications to vmemmap_remap_walk flags
> > @@ -316,69 +307,40 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end,
> >    * Return: %0 on success, negative error code otherwise.
> >    */
> >   static int vmemmap_remap_free(unsigned long start, unsigned long end,
> > -			      unsigned long reuse,
> > +			      struct page *vmemmap_head,
> > +			      struct page *vmemmap_tail,
> >   			      struct list_head *vmemmap_pages,
> >   			      unsigned long flags)
> >   {
> >   	int ret;
> >   	struct vmemmap_remap_walk walk = {
> >   		.remap_pte	= vmemmap_remap_pte,
> > -		.reuse_addr	= reuse,
> > +		.vmemmap_start	= start,
> > +		.vmemmap_head	= vmemmap_head,
> > +		.vmemmap_tail	= vmemmap_tail,
> >   		.vmemmap_pages	= vmemmap_pages,
> >   		.flags		= flags,
> >   	};
> > -	int nid = page_to_nid((struct page *)reuse);
> > -	gfp_t gfp_mask = GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN;
> > +
> > +	ret = vmemmap_remap_range(start, end, &walk);
> > +	if (!ret || !walk.nr_walked)
> > +		return ret;
> > +
> > +	end = start + walk.nr_walked * PAGE_SIZE;
> >   	/*
> > -	 * Allocate a new head vmemmap page to avoid breaking a contiguous
> > -	 * block of struct page memory when freeing it back to page allocator
> > -	 * in free_vmemmap_page_list(). This will allow the likely contiguous
> > -	 * struct page backing memory to be kept contiguous and allowing for
> > -	 * more allocations of hugepages. Fallback to the currently
> > -	 * mapped head page in case should it fail to allocate.
> > +	 * vmemmap_pages contains pages from the previous vmemmap_remap_range()
> > +	 * call which failed.  These are pages which were removed from
> > +	 * the vmemmap. They will be restored in the following call.
> >   	 */
> > -	walk.reuse_page = alloc_pages_node(nid, gfp_mask, 0);
> > -	if (walk.reuse_page) {
> > -		copy_page(page_to_virt(walk.reuse_page),
> > -			  (void *)walk.reuse_addr);
> > -		list_add(&walk.reuse_page->lru, vmemmap_pages);
> > -		memmap_pages_add(1);
> > -	}
> > +	walk = (struct vmemmap_remap_walk) {
> > +		.remap_pte	= vmemmap_restore_pte,
> > +		.vmemmap_start	= start,
> > +		.vmemmap_pages	= vmemmap_pages,
> > +		.flags		= 0,
> > +	};
> > -	/*
> > -	 * In order to make remapping routine most efficient for the huge pages,
> > -	 * the routine of vmemmap page table walking has the following rules
> > -	 * (see more details from the vmemmap_pte_range()):
> > -	 *
> > -	 * - The range [@start, @end) and the range [@reuse, @reuse + PAGE_SIZE)
> > -	 *   should be continuous.
> > -	 * - The @reuse address is part of the range [@reuse, @end) that we are
> > -	 *   walking which is passed to vmemmap_remap_range().
> > -	 * - The @reuse address is the first in the complete range.
> > -	 *
> > -	 * So we need to make sure that @start and @reuse meet the above rules.
> > -	 */
> > -	BUG_ON(start - reuse != PAGE_SIZE);
> > -
> > -	ret = vmemmap_remap_range(reuse, end, &walk);
> > -	if (ret && walk.nr_walked) {
> > -		end = reuse + walk.nr_walked * PAGE_SIZE;
> > -		/*
> > -		 * vmemmap_pages contains pages from the previous
> > -		 * vmemmap_remap_range call which failed.  These
> > -		 * are pages which were removed from the vmemmap.
> > -		 * They will be restored in the following call.
> > -		 */
> > -		walk = (struct vmemmap_remap_walk) {
> > -			.remap_pte	= vmemmap_restore_pte,
> > -			.reuse_addr	= reuse,
> > -			.vmemmap_pages	= vmemmap_pages,
> > -			.flags		= 0,
> > -		};
> > -
> > -		vmemmap_remap_range(reuse, end, &walk);
> > -	}
> > +	vmemmap_remap_range(start + PAGE_SIZE, end, &walk);
> 
> The reason we previously passed the "start" address
> was to perform a TLB flush within that address range.
> So he startaddress is still necessary.

Good catch.

> >   	return ret;
> >   }
> > @@ -415,29 +377,27 @@ static int alloc_vmemmap_page_list(unsigned long start, unsigned long end,
> >    *		to remap.
> >    * @end:	end address of the vmemmap virtual address range that we want to
> >    *		remap.
> > - * @reuse:	reuse address.
> >    * @flags:	modifications to vmemmap_remap_walk flags
> >    *
> >    * Return: %0 on success, negative error code otherwise.
> >    */
> >   static int vmemmap_remap_alloc(unsigned long start, unsigned long end,
> > -			       unsigned long reuse, unsigned long flags)
> > +			       unsigned long flags)
> >   {
> >   	LIST_HEAD(vmemmap_pages);
> >   	struct vmemmap_remap_walk walk = {
> >   		.remap_pte	= vmemmap_restore_pte,
> > -		.reuse_addr	= reuse,
> > +		.vmemmap_start	= start,
> >   		.vmemmap_pages	= &vmemmap_pages,
> >   		.flags		= flags,
> >   	};
> > -	/* See the comment in the vmemmap_remap_free(). */
> > -	BUG_ON(start - reuse != PAGE_SIZE);
> > +	start += HUGETLB_VMEMMAP_RESERVE_SIZE;
> >   	if (alloc_vmemmap_page_list(start, end, &vmemmap_pages))
> >   		return -ENOMEM;
> > -	return vmemmap_remap_range(reuse, end, &walk);
> > +	return vmemmap_remap_range(start, end, &walk);
> >   }
> >   DEFINE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
> > @@ -454,8 +414,7 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
> >   					   struct folio *folio, unsigned long flags)
> >   {
> >   	int ret;
> > -	unsigned long vmemmap_start = (unsigned long)&folio->page, vmemmap_end;
> > -	unsigned long vmemmap_reuse;
> > +	unsigned long vmemmap_start, vmemmap_end;
> >   	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
> >   	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
> > @@ -466,18 +425,16 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
> >   	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
> >   		synchronize_rcu();
> > +	vmemmap_start	= (unsigned long)folio;
> >   	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
> > -	vmemmap_reuse	= vmemmap_start;
> > -	vmemmap_start	+= HUGETLB_VMEMMAP_RESERVE_SIZE;
> >   	/*
> >   	 * The pages which the vmemmap virtual address range [@vmemmap_start,
> > -	 * @vmemmap_end) are mapped to are freed to the buddy allocator, and
> > -	 * the range is mapped to the page which @vmemmap_reuse is mapped to.
> > +	 * @vmemmap_end) are mapped to are freed to the buddy allocator.
> >   	 * When a HugeTLB page is freed to the buddy allocator, previously
> >   	 * discarded vmemmap pages must be allocated and remapping.
> >   	 */
> > -	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, vmemmap_reuse, flags);
> > +	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, flags);
> >   	if (!ret) {
> >   		folio_clear_hugetlb_vmemmap_optimized(folio);
> >   		static_branch_dec(&hugetlb_optimize_vmemmap_key);
> > @@ -565,9 +522,9 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
> >   					    struct list_head *vmemmap_pages,
> >   					    unsigned long flags)
> >   {
> > -	int ret = 0;
> > -	unsigned long vmemmap_start = (unsigned long)&folio->page, vmemmap_end;
> > -	unsigned long vmemmap_reuse;
> > +	unsigned long vmemmap_start, vmemmap_end;
> > +	struct page *vmemmap_head, *vmemmap_tail;
> > +	int nid, ret = 0;
> >   	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
> >   	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
> > @@ -592,18 +549,31 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
> >   	 */
> >   	folio_set_hugetlb_vmemmap_optimized(folio);
> > +	nid = folio_nid(folio);
> > +	vmemmap_head = alloc_pages_node(nid, GFP_KERNEL, 0);
> 
> Why did you choose to change the gfpmask (previous is
> GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN)?

Because I removed the fallback for allocation failure. Trying harder and
warn if the allocation failed is justified without the fallback path.

> > +
> > +	if (!vmemmap_head) {
> > +		ret = -ENOMEM;
> 
> Why did you choose to change the allocation-failure
> behavior? Replacing the head page isn’t mandatory;
> it’s only nice-to-have.

I would require to extract the vmemmap_head page from page tables which
I found to be useless complication that never will get executed and
therefore tested.

If we failed to allocate a single page here, we are in OOM territory. It
is not time to play with huge page allocation.

> > +		goto out;
> > +	}
> > +
> > +	copy_page(page_to_virt(vmemmap_head), folio);
> > +	list_add(&vmemmap_head->lru, vmemmap_pages);
> > +	memmap_pages_add(1);
> > +
> > +	vmemmap_tail	= vmemmap_head;
> > +	vmemmap_start	= (unsigned long)folio;
> >   	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
> > -	vmemmap_reuse	= vmemmap_start;
> > -	vmemmap_start	+= HUGETLB_VMEMMAP_RESERVE_SIZE;
> >   	/*
> > -	 * Remap the vmemmap virtual address range [@vmemmap_start, @vmemmap_end)
> > -	 * to the page which @vmemmap_reuse is mapped to.  Add pages previously
> > -	 * mapping the range to vmemmap_pages list so that they can be freed by
> > -	 * the caller.
> > +	 * Remap the vmemmap virtual address range [@vmemmap_start, @vmemmap_end).
> > +	 * Add pages previously mapping the range to vmemmap_pages list so that
> > +	 * they can be freed by the caller.
> >   	 */
> > -	ret = vmemmap_remap_free(vmemmap_start, vmemmap_end, vmemmap_reuse,
> > +	ret = vmemmap_remap_free(vmemmap_start, vmemmap_end,
> > +				 vmemmap_head, vmemmap_tail,
> >   				 vmemmap_pages, flags);
> > +out:
> >   	if (ret) {
> >   		static_branch_dec(&hugetlb_optimize_vmemmap_key);
> >   		folio_clear_hugetlb_vmemmap_optimized(folio);
> > @@ -632,21 +602,19 @@ void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio)
> >   static int hugetlb_vmemmap_split_folio(const struct hstate *h, struct folio *folio)
> >   {
> > -	unsigned long vmemmap_start = (unsigned long)&folio->page, vmemmap_end;
> > -	unsigned long vmemmap_reuse;
> > +	unsigned long vmemmap_start, vmemmap_end;
> >   	if (!vmemmap_should_optimize_folio(h, folio))
> >   		return 0;
> > +	vmemmap_start	= (unsigned long)folio;
> >   	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
> > -	vmemmap_reuse	= vmemmap_start;
> > -	vmemmap_start	+= HUGETLB_VMEMMAP_RESERVE_SIZE;
> >   	/*
> >   	 * Split PMDs on the vmemmap virtual address range [@vmemmap_start,
> >   	 * @vmemmap_end]
> >   	 */
> > -	return vmemmap_remap_split(vmemmap_start, vmemmap_end, vmemmap_reuse);
> > +	return vmemmap_remap_split(vmemmap_start, vmemmap_end);
> >   }
> >   static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
> 

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

