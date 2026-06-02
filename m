Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5B6CCD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 06:32:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2180C6B0406; Tue,  2 Jun 2026 02:32:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C9A96B0408; Tue,  2 Jun 2026 02:32:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DEA16B040A; Tue,  2 Jun 2026 02:32:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F115E6B0406
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 02:32:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 727BE1C2159
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:32:29 +0000 (UTC)
X-FDA: 84834003618.13.A4557F7
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf05.hostedemail.com (Postfix) with ESMTP id 72724100012
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:32:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n+NdQY2K;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780381947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C/Wy1IaJuFs/X0HLx0N3cZ8cEkjx/rrhoBDMvbNGsvI=;
	b=jA1r5PV6iT9OQtQFjuciT1GH6GeYawK/meHHsm4rJg6MyMGtuKSaPGA9ZuHmwfw45jsbHv
	Hyvmcr9fhUAxuQc5q1JdjkOEP6IJdRwhH5w4pXAi8gRcBYFSLTze0YXxui/F0RR0y7ViBO
	vWnPtv29zwimRdi9jX0fAnR/mDVGbfw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n+NdQY2K;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780381947;
	b=zh6H4VjKDISko3vpKruPgE1vR/oFg5mlpE6gSnOkOx8D8tU/w5zIXRNnOx4cgSc3qLfNTf
	T1hEuns5tzgABuTxIDtaTdGiCyArGtvXxKPmc3T6Oyj3Bljv9CXsG3t8wxbQZCsNx3FrLG
	TyALLpcQ4cHVNycmYjozfW8wMiyQOaI=
Message-ID: <cf069cf0-1bfd-43e6-b7d7-8ff3278c79ac@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780381945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C/Wy1IaJuFs/X0HLx0N3cZ8cEkjx/rrhoBDMvbNGsvI=;
	b=n+NdQY2KQ2wCk4EXY3Jjd3A9TjbnlM8MS4gVU6aQxCfZ+0CKTK+/y2/6+wl8ayOUd/gQcK
	ayf9t5X+d3I4u+SQtW6B6jm9ggSaBvBDGwgNLLz0+RWoYhGH0OY/uakHguv3SnzxK24Tk8
	Bqzuk7SiuR8Mlz2r/uF1M/MaPHOaGG0=
Date: Tue, 2 Jun 2026 14:32:15 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-hotfixes] mm/huge_memory: use correct flags for device
 private PMD entry
Content-Language: en-US
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, SeongJae Park <sj@kernel.org>,
 Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260601083044.57132-1-ljs@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260601083044.57132-1-ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 72724100012
X-Stat-Signature: 7dif5uwr4mdcfkp6bjc6pr737imkk46y
X-Rspam-User: 
X-HE-Tag: 1780381947-888747
X-HE-Meta: U2FsdGVkX18th3pSYILxVGVf//tPJxgZhwo+TcvOvVrsLvqV3UtEBeHhRHJfV0xsd60rNEzkvuWvZI1+X5jh1LXvBWjLRZrC8M9OnftuW5575lWEoAMKfM4QH9QZvk406WQStf6Rj9eAVqvKzfwdbCejUStr7qBoZzfW8PiZ8g7+1E06bk1hL63ZJ3LidJDNeZmBuGlXzFfCIJtov44Qs2t2Ic9fNLO7+xZ8pzf8Omher6SERwKEncZ6MwSD6hCp1mgqBAZR4CxVdLDes6+P45xsL2H1yIqxOnBCKKVVckRnZziaBGfiQFdTvkYeGiX+jFzVGDo79KKUrojKwLtULgf+GrKv77dKTJXhi3YLzcIw0AYNgqn6/jUxN26ghN3NbC9eT9hqLJIu6eaiUpWu1gisiLI7DAs0qkfbvCe53uKIGhY7t4Q9M49uBwB59kqRnQX1wzVvMydp2Z5vrkxFe70blhSclFlAngZoB+afkuE+CRjCBPxqu5flenRZVHiiDZ0mtP95iEeg91HcZoza1y2VEe2l9RoXnXZs8N9DJkTMuk/g7HrQ9yic3d6/GWM185Jy7IygT9kG8gV7zogIgQHAw5ugmYHNdNZ2X9dCjaiBn4Pxyzx9JalFV5FHcWLXolFn+vRGUf3Mao7pm/IMKEOtCeOMJAZRa/u2UajlPEbvXJz4F4YETBisaktOhdi615yOcosVhMkq7ngBU4JhKcJr3pV0q4sXo18BYR1S5gbbbKfuRHexU1UbPLIeVA5JzO6Hd42FIJZfGnSlt82hsLwgxlhT/WEOW7O0hdlsXrvVhdnWD2S3pzl+0zBRO9uJ+aEwU/JKC9qn++kYODmiV6N9M+J5DgYAVEvKurXZOIBlNF4AtibGlvKdJry2OE8uCjTb7yBOH6NipDX0s597O8VjF4ADz/UfgzEcfTmH0p4kOnR/GVEg9E/R8sRqiO+iQAGNKDdUB+vrkW1a5aG
 +kQAN8tL
 aoIylmFMLBiC2dhCosoyjsqDwA9+b5txyUU0bsqlJjlihA16d1tHuQLAw27a1gpWryrbEAPp/AnE2JrNhy7H1AI9Rax7eLe4crJ4pTeqlD+emcP4yDIwcbz1HnBxJ7PAbejfYy72Pon280bh29buFYfHyRBuhsn+UXRUyHOC9rJA2CO2VJLYJugixIGBKH//0isaN7V5ub2MaV375VYSvkKCkySfFRuZi9NJPiebfiJQmmZpnBK26sW2m2H5AeWN1M/6ZRCZMr1K68v5wS0y+Ar3W4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/1 16:30, Lorenzo Stoakes wrote:
> Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
> device-private entries") updated set_pmd_migration_entry() to use
> pmdp_huge_get_and_clear() in the softleaf case, but made no further
> adjustments to the function itself.
> 
> Therefore this function continues to incorrectly use pmd_write(),
> pmd_soft_dirty() and pmd_uffd_wp() to determine whether the installed
> migration entry should be marked writable, softdirty or uffd-wp
> respectively.
> 
> Whilst all are incorrect, the most problematic of these is pmd_write(), as
> this can lead to corrupted rmap state.
> 
> On x86-64 _PAGE_SWP_SOFT_DIRTY is aliased to _PAGE_RW. So calling
> pmd_write() on a softleaf will return the softdirty state encoded in the
> entry, assuming CONFIG_MEM_SOFT_DIRTY was enabled.
> 
> This was observed when running the hmm.hmm_device_private.anon_write_child
> selftest:
> 
> 1. The test faults in a range then migrates it such that a device-private
>     THP range is established.
> 
> 2. The parent then migrates it to a device-private writable PMD entry whose
>     folio is entirely AnonExclusive with entire_mapcount=1, softdirty set
>     (accidentally correct write state).
> 
> 3. The parent forks and the PMD entries are set to device-private read only
>     entries, entire_mapcount=2, softdirty still set.
> 
> 4. [BUG] The child writes to the range then migrates to RAM - intending to
>     install non-writable migration entries - but replacing parent and child
>     PMD mappings with WRITABLE entries due to misinterpreting the softdirty
>     bit.
> 
> 5. In remove_migration_pmd(), if !softleaf_is_migration_read(entry) we
>     set the RMAP_EXCLUSIVE flag when calling folio_add_anon_rmap_pmd() for
>     both parent and child, which are therefore AnonExclusive.
> 
> 6. [SPLAT] Child sets migrated folio entire_mapcount=1, parent sets
>     entire_mapcount=2 and we end up with an AnonExclusive folio with
>     entire_mapcount=2! Assert fires in __folio_add_anon_rmap():
> 
> 		VM_WARN_ON_FOLIO(folio_test_large(folio) &&
> 				 folio_entire_mapcount(folio) > 1 &&
> 				 PageAnonExclusive(cur_page), folio)
> 
> This patch fixes the issue by correctly referencing the softleaf entry
> fields for writable, softdirty and uffd-wp in set_pmd_migration_entry().
> 
> It also only updates A/D flags if the entry is present as these are
> otherwise not meaningful for a softleaf entry.
> 
> This patch also flips the if (!present) { ... } else { ... } logic in
> set_pmd_migration_entry() so it is easier to understand, and adds some
> comments to make things clearer.
> 
> I was able to bisect this to commit 775465fd26a3 ("lib/test_hmm: add zone
> device private THP test infrastructure") which first exposes this bug as it
> was the commit that permitted test_hmm to generate the test.
> 
> However commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
> device-private entries") is the commit that actually enabled this
> behaviour.
> 
> Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---

Cool, lesson learned! Feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

