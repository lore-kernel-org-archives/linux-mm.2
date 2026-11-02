Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42F5F60A2616
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=am21LAGB
Received: by kanga.kvack.org (Postfix)
	id 23AD66B05B2; Mon,  2 Nov 2026 05:18:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C4DA6B05B4; Mon,  2 Nov 2026 05:18:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 017246B05B5; Mon,  2 Nov 2026 05:18:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D012E6B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:18:43 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6A07DA0BFD
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:18:43 +0000 (UTC)
X-FDA: 85389780126.25.E37A63F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id C99744000B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:18:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=am21LAGB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793614721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AhUm2tRgdmS7ZkPk5TUVWoc0pWoU9lL6iWD8QKMf5pM=;
	b=LNQd/QjDKyEX6WlrUIIbD7zm/3YAzpw9FPLYuXUZN5aS9aU9Dw6ECKUc9UIxBoPrailywA
	rgMKJFBttJQPRMUuov+gkE016ndQJHAf8XDwpgYG76boaldG+lpFdh2s5iisw6GlRUpChY
	vmgg7ZTssAKZufHNHRLieai2ZlGlo8I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=am21LAGB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793614721;
	b=egBi2qaB1K+nm7m2yQaVIUd/ta5kr1jR+mpCWsB5jAlRtn1ExGS/Jmf4W81jDsNlSEKVVF
	r8mY7G/wA+yn5EjY6dP7ffo5EmYjrFD+eLOXCSMILhhyHkqfJPQjpsVUa1Rxq/jHhQWA9p
	hGjR78TJ/Ow6Gc7M0I5TjL/13fneeVY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 69B1F60F43;
	Mon,  2 Nov 2026 10:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D58A1F0093A;
	Mon,  2 Nov 2026 10:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793614721;
	bh=AhUm2tRgdmS7ZkPk5TUVWoc0pWoU9lL6iWD8QKMf5pM=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=am21LAGB5HRWVCWqnzuh7hVK0cQAmPz5dPPwvgfhJ+LNbm+kmxRyM1nrj/cayH9pa
	 +vBfMVhno74jeDQKsFDXNcDIX/mWNPW0ULJhZ3UT/nV9eRGvwiLU6N8TCrnduf2PzC
	 GHln9Gza4A/xSHIsThHNfW6ipW6QFJfmNmKkSGXackF3ObYvHk6/jF4o6kMNOwyMbA
	 WTFCeY47F81AXa6ao0VEHuHrXSjPDofVuTVlW1pP4MXLZ1bB4T2cxxszl6o5ac2WRJ
	 /vZPTNvDdZt+lm62aBQ5j60rt8gFmGvc5yTCeVGK9FwKeJgtcH+fxQIyGmNHfDh8wE
	 D/3oLIPaZNWCA==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 02/12] mm: hugetlb_vmemmap: unify
 VMEMMAP_{SPLIT,REMAP}_NO_TLB_FLUSH
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Lance Yang <lance.yang@linux.dev>, 
 James Houghton <jthoughton@google.com>, 
 David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261102032525.3597743-3-songmuchun@bytedance.com>
References: <20261102032525.3597743-1-songmuchun@bytedance.com>
 <20261102032525.3597743-3-songmuchun@bytedance.com>
Date: Mon, 02 Nov 2026 12:18:31 +0200
Message-Id: <179361471103.1337633.14353990207430443405.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C99744000B
X-Stat-Signature: fpwdte5yzhc8k7odxyz91wnxqbx7m9i1
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793614721-73164
X-HE-Meta: U2FsdGVkX19HN+HyQWCPuTuqDmI9tNU/Yt34WB54HPkBbC+xURTgGur6OVAy/6ZXjsv4TWil1Lo/U6bPrCR6DUqx2iXmL9h5nCIVIEWViifoYgVlvTY+5hEkNB6olmxhDuTmpQsCZPHXkqN6bl5jOLgpCLO3e+Fx5T2ROp6YYaV7EDfXMeV9K9/yu1IaKgVmUNh6vCsxLZ+LeNiDbBkMBmskwLgT7zIZjCVLkTFEkCZX8qp/QldNuVjzeRPXvyCV5iMyhjQFYqHRWyOsnoecfEt7DR+igrvtyiCpzqMFNbIdXpN9KPwt5fFKXjuvmxIAyq8iyvBncwcz/xn5APwDUVVrikrQFj+AkBHsMuL9RhHgjPvuVpMWEq04qXsc4aPo2d54VHhRHaInrQgUbNBaV92Zq7xJbfBT0d21Zp7PJYB9FPP1xXpBESKOY2hGk/Ti8cT5qhhHO/7l/E6nia4+l/2dhdr27ulXHLMKOFGBwRtgZNhBYmcppj8Qq9rv3nvuOD/h+ykxEKMLPC54ZokgOhWlWJb+4/TyN8VF7MG/XeNlX2yP2rUaDObCy2P03MNn4V9evI8uCq6QfBua9SZym+fSXGWRSzimY8PmkL+MQMvaQafNCTov5BvY6pbbVsAEkyenEM3ubCXPaLmL1Zm/AW60IxL1dWEcvXvIh1ATlIbt2mGD+62bE79+O7cKaB0rq/GTlREuRilWZckIEcYMJ4TYakyJEpcHDYGkgaVr7SetiFlZTjt8628iM30mkWWLvZCg5V+7q8r8vsVcqmMY9UpSfBzrTGdMecsaZGi81nIySNwjgD8Bn5OOJ29d1u9dQa7yGJiUPp3iuwc6UocnGXonWl/IeU+/0SMr4BPDD/kp57vLnc62YW9f0p5uE+9ylOP/7WyIyWS8w/FsLfWyxdScb79jff2lPH0C4V1Uwhk6wjVI8AddMv5b47kiwJI0o9M66s/Rtb076EJIwlt
 KSzBgXSB
 K4BnGBWGqZaY3kPwszqyVYE9OLUhYDIghoy4kNwoE3OaiocRkSEkFlhVFicfaTNJg1h2yGsBrAMdbc6vnuxodZER1hpCrt/NI3vEO21yXhlMritcNV4astR9ES90nddiI6YsopjuF8SN06lBI3EL1/z1P3KT3kun/pIH1ALGAKnHecDmeedw48ukFKrBUs2nZ6/Nvqw0qQ06a/tWY1pEMoNoMfdjYWeNCxlu+vwgvg4aYomZ8U5CQ1VgYBw4m6Kmu29xrh4LqoziMiW/PFxs6e614vxfidbEMKhz7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Muchun,

> VMEMMAP_SPLIT_NO_TLB_FLUSH and VMEMMAP_REMAP_NO_TLB_FLUSH do not
> describe fully independent choices. A split-only walk can defer the
> PMD-split flush to a later global flush, and a remap-only walk can
> defer the final remap flush. However, when a PMD split is followed
> by PTE remapping, the split flush must happen before the PTEs are
> changed, because stale large-page translations must not overlap with
> new small-page translations that map different physical pages.
> 
> Replace the two flags with a single VMEMMAP_DEFER_TLB_FLUSH flag. The
> new name reflects that only safely batchable flushes are deferred. Keep
> split-only walks able to defer the flush, but force the split flush
> whenever a remap_pte callback is present. Callers that batch HVO work
> can still defer the final remap flush and issue their own global flush.
> 
> Current callers keep the same flushing behavior.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
> ---
> v2:
> - Rename the unified flag to VMEMMAP_DEFER_TLB_FLUSH and update its
>   comment (suggested by Qi Zheng)
> - Update the commit message for the new flag name
> - Collect Reviewed-by from Lance Yang and Qi Zheng
> ---
>  mm/hugetlb_vmemmap.c | 23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
>
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index 4b73d6ec8dcea..63e899cfaac3a 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -42,10 +42,8 @@ struct vmemmap_remap_walk {
>  	struct list_head	*vmemmap_pages;
>  
>  
> -/* Skip the TLB flush when we split the PMD */
> -#define VMEMMAP_SPLIT_NO_TLB_FLUSH	BIT(0)
> -/* Skip the TLB flush when we remap the PTE */
> -#define VMEMMAP_REMAP_NO_TLB_FLUSH	BIT(1)
> +/* Defer safely batchable TLB flushes to the caller. */
> +#define VMEMMAP_DEFER_TLB_FLUSH	BIT(0)
>  	unsigned long		flags;
>  };
>  
> @@ -85,7 +83,12 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
>  		/* Make pte visible before pmd. See comment in pmd_install(). */
>  		smp_wmb();
>  		pmd_populate_kernel(&init_mm, pmd, pgtable);
> -		if (!(walk->flags & VMEMMAP_SPLIT_NO_TLB_FLUSH))
> +		/*
> +		 * Modern MMUs allow overlapping TLB entries with different mapping
> +		 * granularities only if they map the same physical address. So
> +		 * remapping must not proceed without first flushing the TLB.

Are we certain that *all* modern MMUs for *all* architecures that 
support hugetlb are fine with skipping TLB flush after a split?

AFAIU, x86::set_memory always flushes TLBs after a large leaf is split.

-- 
Sincerely yours,
Mike.


