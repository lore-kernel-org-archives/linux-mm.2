Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD059606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 20:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ItU7TeQa
Received: by kanga.kvack.org (Postfix)
	id 9EFA36B05B3; Mon, 16 Nov 2026 15:17:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A1396B05B6; Mon, 16 Nov 2026 15:17:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 868BE6B05B7; Mon, 16 Nov 2026 15:17:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5A8F86B05B3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:17:06 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D5BEBC0204
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:17:05 +0000 (UTC)
X-FDA: 85442091210.25.3EF64F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id F3BE14000D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:17:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ItU7TeQa;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794860224;
	b=FTTetXgQ2d6Pc5rMqlY1Co7tkv2NUAKle5zk8jBaJrKGYmCH7BUDnk3Vyz3u3qBE/y8Js+
	LZNUlH2pm0f1oz6kLI1szZTcldtSx5JqA5KzHRDDAJ08LiQE7cG5bh5I7mku+m+DN7icGc
	NQlh7D+Q5vAhL19FKjCf6E6MECUbmZY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ItU7TeQa;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794860224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bKzzzSpBOaonU826sARfDAiFw4R3omUJQM2ebnYyTcA=;
	b=Xc6fPTeeQR2EEIc/dC6jDl3r0X3Oa2ErXMbNePaSbGTU7UvgsZHrHBIGCZh1fKboJrFkfz
	FQgPzVt1NfMRMPBD6v3NoPsN30tuOjJpet+FfqUjGNOTmXj5zEj+9sW1yN9RcKBSHoup/T
	51tidmnOEjemF3s6ys0Ewy6TUpvOKoA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F01442482;
	Mon, 16 Nov 2026 20:17:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F631F000C5;
	Mon, 16 Nov 2026 20:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794860223;
	bh=bKzzzSpBOaonU826sARfDAiFw4R3omUJQM2ebnYyTcA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ItU7TeQai/+BclW1EU5PAUfzqEk6kWfCZ7ASDuNsu2JYjtmngJxaHrhyvN8sM7Et+
	 j5moSLArwbw6kg8SHUQd2XgGhkfhaugo+URtLWL4KRZs1ekwG4oSZgnaO+lQXKcrXz
	 cBui06n56DU1FOwISRi0be2gp8TQiBxJCNALY3VmaNhxOmIg5C7ZJlmCNj/T2fX0JP
	 GqbLTDxJP5qoqUlbrDewG3W4XgLWIc8posALz4Qwrni4AXv+rFL/LvijdI7xVFBVjZ
	 SBFR4Srme2YbACrF1idrOzrbm8NhExSVlzMUG8lyRZoYUFLntPc6cwBaVXX3CXB29n
	 1tdHE12H9/lEA==
Message-ID: <cc865bc8-b96f-4385-97b1-976de4465ca1@kernel.org>
Date: Mon, 16 Nov 2026 21:16:50 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/9] userfaultfd: use anonymous memory for
 UFFDIO_ZEROPAGE on private file mappings
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
 <20261116-uffd-state-fixes-v2-1-4397a0196479@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261116-uffd-state-fixes-v2-1-4397a0196479@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F3BE14000D
X-Stat-Signature: jpwnrmz737h4kzp6imz4uzezj1kc1d59
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794860223-335684
X-HE-Meta: U2FsdGVkX18ylEoO6I/jFzCTc7k5A0f6PPK5R456+wcolVq7j81oiNxjZj/Fk3/9yAxSYzbfMO1eequKuNRRYRntpKUDjS6PQYFiYFH5qdOfOlblMUdBqIZU+qHd/nxkGqkyfE+jwX8ZHpkfnZuzpshgBXjF6IeGoWHBmWEOs8MA6MlDTlB75ppyIzn6wdHrtOPHjvIhm6Z7RSRX1/PmQXTDCUmNp0whrbfmzsIpRFA6oPcp6bRPRq8wmPdm9Rlre8LHv268o6tiGjOeJQJUnrDG04DqWyA/Auqid/kgQf5v3uDAJXaEM9JP7Bwuk6M8Uyfs56pJN0uWIzA/vMtk0MrotJKg+cdpib7R1BeHQo/ZISKvbBoR4jwfK405636W0VjgSDLIPqDFTkc5/vVU/A0eS/40lLPDnJ3C6iGJJ+Ft+mLQm9Vaub8FH3iE8bhtYS6rLAGLKHnlWeZc+sXwPKDVNOn/hp/a5AYwMj8LqN6kWZDh6LNA5eY7PX/PCwmuPzTYfFjW9Fzof7ibMfkfzHXhezzPjwT8Wa0Ne96BCrV9fHG2hywY1Yw+7mFZg+0ckoNm3IVuVBBxqbh+tLkYvPCtLqe6x85F+uHwpJpFXpcs6v2PcE2DZSVCfmc7lJdqFO0NiKoKJAWXgKt3mD37nFhHG0zeqNRYypBDyf+qDs3CSyZPZV8BJd6ISjiASYg6zsvFcC4xlAuKMzmb2ppfPDEe8bQeZXQemwa/j+OKxn6b+DuEdsb7SnI1Oo64059yHs75/SdbyBd2Q8n+6eMa6rcdknyz724tbwJFi/xVmVpJ7S8VsyO9FmtSjamNziLELPtuYyJF3szekwh2/uXW8LaRZM99lERos+oc61zjPnOKpYMwA+luyetwfBaylClteybPhVOBJjNHvX1LnrVpBwdsYhZveBOsImib3n+m6ebatuyT3y/NBh4UOYQXpc873ylhwJWMkze7KgrDlV0
 imgGDIet
 qwmls8OTpRrwbA+3Iqz0+hUJXUgURljvffRq5PV8vT26DwojJqAZJM9yQ++28j6k4YpIv5Cf7vsiUW3r0cgKYAaP9FitkrX/KyeLcnjTV0lJsk4WD+iQADrHITleFcCppUPXOzE4fb006hh1wqGacNkipQKN/ofXZ07FxuBcJDavme2h/e9UdOXoRSAEbnjb+pU/T2aDFjGQbut3rmH+0sjlSY78uWgf5kHand039wCsIIzBOLQjkUlP5c3/XEDf4R7o3z3xjE7BpyRa/LTlBds0XH0pLt03LAIMBKWIX9rhAPSrsIbRBkiPY1V+fCuOubnyZp6muTxgBndJhxB4TCHjM2lLNbXIdWqokoWIjBZy1zEOtSsUu3ThB5a2EFFQDpjAHaM3ZRcQS6yX4j3R1hWhBmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 21:02, Tal Zussman wrote:
> If the mm cannot map the shared zero page, UFFDIO_ZEROPAGE falls back to
> mfill_atomic_pte_zeroed_folio(), which allocates a zeroed folio and
> installs it through vma_uffd_ops(), no matter what kind of mapping it
> is. An s390 KVM guest with storage keys or protected virtualization is
> such an mm.
> 
> For a MAP_PRIVATE shmem mapping, that adds the zeroed folio to the page
> cache of the file. That is wrong: a private mapping must never modify
> the file it maps, and the file might even be mapped from a read-only fd.
> 
> The ioctl can also fail where it should succeed. A missing fault is only
> delivered for a hole in the file, but UFFDIO_ZEROPAGE can be called on
> an address that did not fault, or can race with a write to the file. If
> the file has a page at that offset by then, inserting the zeroed folio
> fails and the ioctl returns -EEXIST although nothing is mapped at the
> destination address.
> 
> What we want is what UFFDIO_ZEROPAGE does on a private mapping when the
> shared zero page can be used, and what UFFDIO_COPY does: only check that
> nothing is mapped at the destination address, map zeroed memory there,
> and leave the page cache alone. The zeroed folio path did that before it
> was moved to vm_uffd_ops.
> 
> To fix it, pick the ops in the common folio path, as
> mfill_atomic_pte_copy() did for UFFDIO_COPY: anon_uffd_ops for a private
> mapping, the ops of the VMA otherwise. That makes
> mfill_atomic_pte_copy() and mfill_atomic_pte_zeroed_folio() redundant,
> so remove them and rename __mfill_atomic_pte() to
> mfill_atomic_pte_folio().
> 
> UFFDIO_ZEROPAGE no longer modifies the file, and only fails with -EEXIST
> if something is already mapped at the destination address.
> 
> Fixes: f74991b4e383 ("shmem, userfaultfd: implement shmem uffd operations using vm_uffd_ops")
> Cc: stable@vger.kernel.org
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  mm/userfaultfd.c | 46 ++++++++++++++++------------------------------
>  1 file changed, 16 insertions(+), 30 deletions(-)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index d65184d9a480..61a712e1f9f5 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -531,15 +531,27 @@ static int mfill_copy_folio_retry(struct mfill_state *mfill_state,
>  	return 0;
>  }
>  
> -static int __mfill_atomic_pte(struct mfill_state *state,
> -			      const struct vm_uffd_ops *ops)
> +static int mfill_atomic_pte_folio(struct mfill_state *state)
>  {
> +	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
>  	unsigned long dst_addr = state->dst_addr;
>  	unsigned long src_addr = state->src_addr;
>  	uffd_flags_t flags = state->flags;
>  	struct folio *folio;
>  	int ret;
>  
> +	/*
> +	 * The normal page fault path for a MAP_PRIVATE mapping in a
> +	 * file-backed VMA will invoke the fault, fill the hole in the file and
> +	 * COW it right away. The result generates plain anonymous memory.
> +	 * So when we are asked to fill a hole in a MAP_PRIVATE mapping, we'll
> +	 * generate anonymous memory directly without actually filling the
> +	 * hole. For the MAP_PRIVATE case the robustness check only happens in
> +	 * the pagetable (to verify it's still none) and not in the page cache.
> +	 */
> +	if (!(state->vma->vm_flags & VM_SHARED))
> +		ops = &anon_uffd_ops;

Oh, but one comment: why not check for actual cow mappings?

	vma_is_cow_mapping()

is your friend :)

-- 
Cheers,

David

