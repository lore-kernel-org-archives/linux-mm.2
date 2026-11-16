Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8630606A880
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 20:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fK50WbwQ
Received: by kanga.kvack.org (Postfix)
	id A692B6B00EF; Mon, 16 Nov 2026 15:18:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A19AE6B05B5; Mon, 16 Nov 2026 15:18:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E2266B05B6; Mon, 16 Nov 2026 15:18:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B76F6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:18:42 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E20D88022A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:18:41 +0000 (UTC)
X-FDA: 85442095242.15.672E3EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 04A301A0005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:18:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fK50WbwQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794860320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e+F00mSOHoN5Y69YJ4eI5U2asF3iwsD+sP6+Uxjzv+w=;
	b=BmvgcYqzxskxVtEnl/LbvrtaDHiOuRCQTZQoFACgMjttGt6Kv1p+EGMQvSLcBsXkYGBupR
	QV9IXrG0/ciH4K7jAKU5wnXXwd2noNkf34WbdnD2HqEq6s0CFrOe+0fTF7oQWFU3eFS7Lj
	xiLt3xBkLzcxK/GpVI3MfIibbXV7APQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fK50WbwQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794860320;
	b=gvYFpGTr9G9Dv3hRP7z6SiM9GlhEqS4ubzLew+ofYZ7HjWcL2w5O5FHT2aaF74LXRagT1K
	FfSuDDYWBsXsLRb/+Y0ngWUtgDpm044W4zBLAGxEAhwYZLBPWV6IX3q3p8dJH1k1BQRpYU
	APwPmOXRrp9KunkUVaQ6r7NahRSxl6Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3166840910;
	Mon, 16 Nov 2026 20:18:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E151F000C8;
	Mon, 16 Nov 2026 20:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794860319;
	bh=e+F00mSOHoN5Y69YJ4eI5U2asF3iwsD+sP6+Uxjzv+w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fK50WbwQZf1UckiVFuoJyhG3L6gG5PUkQqa+LYTxJcv21cV+DLK8s0i3FYnoxx+6C
	 ToQuoG4KYN61wvCzqaocY4176QIWc8krihZm/MWCpg8jG0DUrC0R3xQMRTsouqW/Yx
	 CBqdMq3l4HbNuXCPuvlbsQy+vnIF/lZS/DSqnJyVoounP0T0WIgOhxqnpZz8e/aOBv
	 eQEYYDVHpspI3aC1UIdxtIuNOqZcNAbSDBWxjeCE8b4Vx0JFJO1I+P4oyDfDiDQcDH
	 u5yGgLcnJZLhmS7hJwSwaHwHkU5pMR/Oea6MfeipvbNWAnHySLKN7VoGFW/igkRF1h
	 dzD2/+i/WgkAQ==
Message-ID: <17b98593-5f56-45a3-922f-99dee2b917c1@kernel.org>
Date: Mon, 16 Nov 2026 21:18:26 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/9] userfaultfd: refuse UFFDIO_MOVE into a non-present
 huge destination PMD
To: Tal Zussman <tz2294@columbia.edu>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Peter Xu <peterx@redhat.com>, James Houghton <jthoughton@google.com>,
 Andrea Arcangeli <aarcange@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Michal Hocko <mhocko@suse.com>,
 =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
 Andrei Vagin <avagin@gmail.com>, Muhammad Usama Anjum <usama.anjum@arm.com>,
 Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 =?UTF-8?Q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
References: <20261116-uffd-state-fixes-v2-0-4397a0196479@columbia.edu>
 <20261116-uffd-state-fixes-v2-2-4397a0196479@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261116-uffd-state-fixes-v2-2-4397a0196479@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nxez8jtmr866jj4kb75c1xtu33fkzsda
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 04A301A0005
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794860319-904898
X-HE-Meta: U2FsdGVkX1/JeUb2PsWktmlhjpMuaO/PxcXzHO4uo5QMdetiuJnBD0yRVhpwaV4HX0nOs3GbBa/yBDUTkDeBjjomokm644TP7EHGyduhBe43geGtsQthJ0bQEKnKzvTswrVSFKgGddMMlUVVOgvrDuNb54MxkISlCkNTj6LkfDNNY+EKr1cPCgVjYlKUXljuID9RYy+Q9UQhYUtVEC2XXzp1O9IJEcnUQlfPyrKL3YFdFTFRmUOHRcj1ZMhnLZaCUzT2gLAnAefK5Q4dHfADZJsbk/FaOKPMsVhjFpZC7s/3y6Dy5u4KEoOELw/MaEXxMuJxldW31Jq1HecWdmj9hmOWT2f5Owo+TzXMlcMjc7L0X4TErT+97PtymtYU7rQgpJ5nJXqi1vu1JR0wvbwDlAMYgMX4zVaC4jktaoaqgb4oU7jbTsJgEX7V7XussWX4b6xvuppzBwZ8I2G6Y3DVSmggutVcA7CeZcuyaLuMRJNNyMjtMk1RFGYM9BOxe51SqUMqZcTZ8C7LjRJF/m3foCvcpjvYKqrA1QWBR/3l7hSp9M3qQrnjQvqga32HzXOxi3tCX6CXojyICpHnMoNdEheyzIVUuNjY820WB8NbkhwznTXgP/+jE4Av63z6lF/ICWJPjq2AUFILUen7Z9g0IjsoDcOMTEDFY+6oa6i3ohzp6bI8Vh8vDppnoBmSat9OviSpP6ql6pzqCnQLHtQHo4j1x9De+zJmHgHQ3l8C7tWU35IvdSXr6MaUqgLvnaoenbCT0k3Sn+YJk5JkDhOlHjf5sjX/TtlWeoQxg3AXxjyr/D0Ui9TEjcA0wFojIzVfiKGdFe2BqFz3QOUujs8C6PFiiRq06qoMZMUzqxSt+8cQr/QtNxPYV+inL/IPheXPRmlBQbf5qXWGLDePQMlIJPle+LxD9bwmFVzubBImUwtDH6j1oP/XxKfZDSSG/o79n89TyXMgy17IROfi3px
 RBxS5jgn
 oRRJ+qLvZDz0AO2ymr5FZ3/j5rYZHbDxIN6ItBQKdmKykvHkmrm0IJg8U7QPYKpb8TF6OHhSZKMjICGdJv0nytfgQq5vXCinDq5Kdlf2OxmUAxnONVq6EDxQ8bv1SOQp1di+b8bLfpeeU9kXVytfVChTgCG4FzIyX6awx1qZS9GcCFFo0iNnLLGbwEdB6INhCOrHliw3CAuLtTowENTH1CdSMFN6bSHckVEoXBEG5aBKDEBhuZIDOrs6LH4rpdiZBlEui7JnnYHp/yFWUhjjJcsuM7asY45/H8LC5RczexN+vWponVQANAmtzTQ/LvSieWCd2n4nDC//h2HOhCE99GThZiJCx3oEeOm8qlh+PlVW5P+gKRfDpjn0RteApj9E6ppo7erv9X6m25A8vygRgLlWMlGGShVsA1Y8BPwyss0+Vp0yT+KPqQzpBuqb6edYh1PsfWBjHuQaSKTPAAIfsVowqfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 21:02, Tal Zussman wrote:
> move_pages() refuses to move into a destination PMD that already maps a
> THP, but checks for that with pmd_trans_huge(), which is only true for a
> present THP. A device-private THP or a THP under migration is a PMD
> softleaf entry and is not refused.
> 
> The destination PMD is then treated as if it pointed to a PTE table. It
> is not empty, so pte_alloc() leaves it alone, and move_pages_ptes()
> fails to map a PTE table from it and returns -EAGAIN. move_pages()
> retries on -EAGAIN, with both VMA read locks held. If the source is a
> THP, it is split first for nothing.
> 
> For a THP under migration, the loop ends once the migration finishes.
> A device-private THP can remain in device memory indefinitely, so the
> caller of UFFDIO_MOVE hangs until it receives a fatal signal, and
> anything in the mm that needs to write-lock one of the VMAs blocks along
> with it. This requires a driver that migrates THPs to device memory.
> 
> To fix it, check the destination with pmd_is_huge(), which is true for
> a present THP and for a PMD softleaf entry. UFFDIO_MOVE now fails with
> -EEXIST in these cases, as it already does for a present THP.
> 
> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
> Cc: stable@vger.kernel.org
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  mm/userfaultfd.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 61a712e1f9f5..ad9d243dc64b 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -2021,12 +2021,13 @@ static ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
>  
>  		dst_pmdval = pmdp_get_lockless(dst_pmd);
>  		/*
> -		 * If the dst_pmd is mapped as THP don't override it and just
> -		 * be strict. If dst_pmd changes into TPH after this check, the
> -		 * move_pages_huge_pmd() will detect the change and retry
> -		 * while move_pages_pte() will detect the change and fail.
> +		 * If the dst_pmd is a huge leaf, present or not, don't
> +		 * override it and just be strict. If dst_pmd changes into a
> +		 * leaf after this check, move_pages_huge_pmd() will detect the
> +		 * change and retry while move_pages_ptes() will fail to map
> +		 * the PTE table and the next iteration will see the leaf.
>  		 */
> -		if (unlikely(pmd_trans_huge(dst_pmdval))) {
> +		if (unlikely(pmd_is_huge(dst_pmdval))) {

Insert the usual ranting about stupid thp helpers

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

