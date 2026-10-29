Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C488A606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 10:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N0zWNQbb
Received: by kanga.kvack.org (Postfix)
	id 707796B05CD; Thu, 29 Oct 2026 06:54:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DF246B05D1; Thu, 29 Oct 2026 06:54:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61C406B05D3; Thu, 29 Oct 2026 06:54:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 457BB6B05CD
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:54:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DB887C033B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:54:09 +0000 (UTC)
X-FDA: 85375354218.18.FD5877A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 34D6AC0005
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:54:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N0zWNQbb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793271248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yRQohK+CSt2OKE4WJtHLQd1a3qhKEoEvkjG3iYzfLuI=;
	b=m8k8LCFqER87PJktIfYherz4liXhPwngR9R3Gu3OMtyynu2ls5upcBTkZSqwukexNqyEpJ
	d6ogAYLnIOjj9sMkgA/RpIzHmQVPK/RN0nvYM09hqoC4rnSd2iJ+996c1pDdslLKvyScbr
	yyZpzpW5bazioUwLvr8VmLRgPnyTc+g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N0zWNQbb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793271248;
	b=Ang3yJo1LpWKOyRHY78ymR2FaikpasM0HvygZLehDLH2HMmmZ/c1tg2l2fgnmzL/lVsLQI
	uk2y783tbMbSNH5T37/Mbsm8Yn2jGzqhBFnM3ray7O5Djg3zSX46Wghf6xE4IQD+BRBrik
	gzmuTtnRF5+6+6iPJqLjFUgfd4Ss5TA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AC33D60207;
	Thu, 29 Oct 2026 10:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB29A1F01829;
	Thu, 29 Oct 2026 10:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793271247;
	bh=yRQohK+CSt2OKE4WJtHLQd1a3qhKEoEvkjG3iYzfLuI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=N0zWNQbbnqBYz5SjJ7FymjJkYGEKptrE0TDLsZJx4o4qG4WBngSOzXO06L54iDVYo
	 5c66LIlnuajAKwRqmp8TSe6/sf6rsGNOVtyXtkbgOGeb+IVmi/Ad6785EauUqkvV9I
	 6jwsZJBIR+U1ZzYyNLvmAFomsFtds6sAvYNYFC4BT/oIy/3cSIfXeC2bf/fRiTZj/b
	 uvO5K9JnpHfhTMlyuorebMDeQG5dPl9Va+Jzwtdxs29naBrp3OYND8YS3ozUwUPEz6
	 RPNUivzrLa1PDKRzDwJLu6FKOync5cOh9c41m6+qWsEP2fmSXV+5oi1vd27KhuBcJj
	 st9g5SU1pI8rQ==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Lukas Czerner <lczerner@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Stevens <stevensd@chromium.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
 Pedro Falcato <pfalcato@suse.de>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 Balbir Singh <balbirs@nvidia.com>, Josef Bacik <josef@toxicpanda.com>, 
 "Pratyush Yadav (Google)" <pratyush@kernel.org>, 
 Eva Kurchatova <eva.kurchatova@virtuozzo.com>
In-Reply-To: <20261029-fixes_shmem-v4-0-392fc715d8f6@kernel.org>
References: <20261029-fixes_shmem-v4-0-392fc715d8f6@kernel.org>
Subject: Re: [PATCH v4 00/15] mm/shmem: various (urgent?) fixes
Message-Id: <179327123632.4954.5925006193124962193.b4-ty@b4>
Date: Thu, 29 Oct 2026 11:53:56 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 34D6AC0005
X-Stat-Signature: ogkuju8k71gj54gdqq5ef1bsh7p5wqoo
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793271248-795048
X-HE-Meta: U2FsdGVkX1+NGpH6QZltHu2EwrjgzqkF5imwHE6IV5DU+be5/VcNx6s8blhT59RBqIlV3BcgaCT6BMEAzB1bMOYs9CMmvq+cpwL/k/HaYEB+8RptzBJT4gFT9i0w5wA15yNYMJ6u3Uw3/gJn0IQRg0YUp3201pcHxFZtN1/o7fy6vDC48uULvjUAJ0S/SU/6hg2qXuI8FZ0hW2JaAq5w+2lQjILucZd2RjHPJep295hNc9rdQ8L0eUYegK9vUsxmhKT0Ej5TziafnkUJnKwy+sgkr9nY8XTWGlOQ+wWdFtRkv8ms4+2kgG0tiqNtLh2mQ2MhoNBa3tyZzcGRvobPaDSMvVyLMCWuFLQEiQ2JZJ9O5T2V1HTV28LoXFlT9KymGD9LD+wb4r/AsRoki42EgiTneB3dUS4G0a4VK2WMlyigaOcPRDnPgUyZzbviiqYnC5tUzeYNQKotg4q5q5zi49IbrOCCfyYnnKfCWjRhjxO0QystA9qmPqroKgMQGzvkNWopyie/squu91J8TPUyrM3b+qQVOpOcR2WbAL8TwJMMF8NnNMR3v/YEAmP2ZxaIp2wy1+5qrM+7UxQ9yDkQbqII6qerN153OKoztC84S7V71X61Rb1la53JCA2TARW74o4cCFrr59WH2EADkN5Kt+upaTMJLBcw8sIUIpGyEAa6+zue3ZSR0ZBmesEIgx9a3th6tSUoATd0ZZ/AcRDgoMM2vwtYMRxCV8nhL6l7+THdGI5/OKRcXr5J/sGegeNDUFT2QWQKTFblKXq3of98K1yjIFp1FHuwsN5+owIdGRHaB4hICM6ZKBJkDK+29SOrNZK4decuo7tCB1LWbgkv1Fk4D1BO3cqM2kbRyM0pCppdDEVRHdYECQFWovrQmESa6XJYCvdG+fRIYdna1DWaj0y0WvEF0EjToGWQARGvGAmeNkgbr803WqLkgjX/WGD+YJmKEjIroGPbaHI9dGC
 LH20Bar5
 Itckk/O3M0fhS32gLy1EFGRNaJCD3m5kjAvPK1nLu8p/Nzqi8HmNV3eEFfA0eJLPGBoxShG3qgMo0UyAn6QnK94JNh8eBGR2BZwc0uQlxyc+7MAtKZeW24oV1H5qA3R8dG2r95um/ms6eST8OrocROnw91q6PqEXhQXwj6vhXKHnOflv76HLu8HF8oLqe6M1BWc6DNMFxTcy5bGQS8WBCxQXiX7pZE4cYochN4KmXAWhg87IgnBgpq7hJHOVHBcEDqqXODxb0A6sG8sNQA+lTzho+sfuahzqWgFs/4vfB3ugHqZB95bdVt88AbR60YzyTZoQri/3qGvjKmVaWl31zby5NJA9KL/zCDMhfpgLg8VyFcy8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 29 Oct 2026 11:43:21 +0100, David Hildenbrand (Arm) wrote:
> Thanks everyone for the fast review and tests!
> 
> I'm planning on picking these myself and routing them through mm-core.
> 
> This is a handful of fixes for shmem/tmpfs. I sneaked in a related
> hugetlb fix that stalled upstream.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: for-next-fixes

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[01/15] mm/mempolicy: charge shared policy nodes
        https://git.kernel.org/mm/core/c/9e3b76ba
[02/15] tmpfs: keep the quota soft limits of an unused id
        https://git.kernel.org/mm/core/c/85a7d29e
[03/15] tmpfs: preserve explicitly disabled quota limits
        https://git.kernel.org/mm/core/c/3283c3cd
[04/15] mm/shmem: honour F_SEAL_EXEC when an ACL is set
        https://git.kernel.org/mm/core/c/460346e9
[05/15] hugetlbfs: enforce F_SEAL_EXEC in setattr
        https://git.kernel.org/mm/core/c/73fe78f9
[06/15] mm/shmem: hold off eviction in shmem_writeout()
        https://git.kernel.org/mm/core/c/69634c49
[07/15] mm/shmem: stop retrying folios that cannot be split
        https://git.kernel.org/mm/core/c/52f47e06
[08/15] mm/shmem: preserve data in clean folios when splitting fails
        https://git.kernel.org/mm/core/c/06162197
[09/15] mm/shmem: discard whole new large folios on fallocate rollback
        https://git.kernel.org/mm/core/c/beba3c5a
[10/15] mm/shmem: rescan after nonuniform folio splitting
        https://git.kernel.org/mm/core/c/920600c0
[11/15] mm/shmem: fix truncate hang in large swap entry
        https://git.kernel.org/mm/core/c/29c3fae7
[12/15] mm/shmem: preserve allocation errors when swapping in large entries
        https://git.kernel.org/mm/core/c/f8bb4422
[13/15] mm/shmem: fix truncate loop after boundary swapin failure
        https://git.kernel.org/mm/core/c/9df76e1e
[14/15] mm/shmem: fix accounting of swapin-error markers
        https://git.kernel.org/mm/core/c/5dca4cd7
[15/15] mm/shmem: fix truncation of files containing only swapin-error markers
        https://git.kernel.org/mm/core/c/52c5619a

-- 
Cheers,

David


