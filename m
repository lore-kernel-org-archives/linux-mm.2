Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 143E4606A32C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 22:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d9Tzs20P
Received: by kanga.kvack.org (Postfix)
	id 16CC26B05B7; Sat,  7 Nov 2026 17:05:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11DA86B05B8; Sat,  7 Nov 2026 17:05:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00C846B05B9; Sat,  7 Nov 2026 17:05:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D37CD6B05B7
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:05:30 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 63BE5803DB
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:05:30 +0000 (UTC)
X-FDA: 85409705220.08.8DCD9A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id BC01B40007
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:05:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d9Tzs20P;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794089128;
	b=rbs51CXsFhz8yDsPPaTS04QQXEcge8nEzMSoxcTpLYun41kK2vSQuzDlVsKK6rpGp0fa1I
	vPUsNDaMCeoJvEhw7CEYckMKUsFxH7ZWfFbbpc+WAnWdXzH7ltHbNU/eaqzzCH/qFyrWWI
	FfFC/uycky9qiI6QHLPAFtrVzziiyHc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d9Tzs20P;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794089128;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=79WQEEn6AWKNweLPHt7pfRzzFqASrZiDIQEsGojE0yc=;
	b=mx6yhbdRypLCnd8L6iC4+URaCmu9iMfvz9/hMH3IHD+MaMs6rPXVSEeRJHXD3Cm6YUtsfo
	xDkWIvduWAFavG+dDwxFQs2HkI88CxSHPw+n1FB6lcgniJlA+VJHHnutigeHx4RQh5agII
	w0MoQ3KuHOxjXxMH8oRhcdGt9l9Derw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 562D761202;
	Sat,  7 Nov 2026 22:05:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872DB1F0089F;
	Sat,  7 Nov 2026 22:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794089128;
	bh=79WQEEn6AWKNweLPHt7pfRzzFqASrZiDIQEsGojE0yc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d9Tzs20PYQhmWqWsXYL5tSfSwVCGlQxRj9h2WvYYIjypkGZhDTIKu4RrEyintnUkn
	 AUgW+azBKzbwdk4zB1zlHfGQGV2gWLvDHrFhkxI8VKAR6trW/3FTjxopVjNjzpO6Jq
	 gEqHrr/6uej/lZWj66Z9KcAMikuvQPyTXXGwNiFP9StHazK57ghy2cDlSsjCveUpfY
	 rz6i7601QKQ3MacrfRe5YzodOaMQDwT2FEFTO3FTEVczI/4mFZ6ILpH3m10DDfmgjR
	 wbLsyqivXs//oqmbxysvOySrTt56YVDtYuH9/JN0UJSILnwjV2A/9ntnwgUQpOglcx
	 +C/9fNz5tbsyg==
Message-ID: <sashiko-outbox-203352@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 5.15 1/2] mm: replace free hugepage folios after
 migration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Bundschuh" <mkbund@amazon.com>
Cc: sashal@kernel.org, linux-mm@kvack.org, david@kernel.org, yangge <yangge1116@126.com>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Barry Song" <21cnbao@gmail.com>, "David
 Hildenbrand" <david@redhat.com>, "SeongJae Park" <sj@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>
In-Reply-To: <20261106220445.2859944-2-mkbund@amazon.com>
References: <20261105070206.3094675-1-mkbund@amazon.com>
 <20261106220445.2859944-1-mkbund@amazon.com>
 <20261106220445.2859944-2-mkbund@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 22:05:27 +0000
X-Stat-Signature: 6giqrbqukncidycqfghu9ai1hce3uexu
X-Rspamd-Queue-Id: BC01B40007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794089128-80845
X-HE-Meta: U2FsdGVkX1+r4GZOcHDVHOpcI8d7HeARYahpsamTZd38zy7WUSltzU1c5aMPUTXJHPd3EgvnFiqeEysdB7rDs+rUuHd9vK0FAYGEot+AvvL56k7hrdw4Nro4zosEcaeqxuo/WZ12LK4+3v84RM0KoPt87KxfoCfUXAy0eSGMzjc7AiXccq28KiQ9Vk5GWulY+bFEwR6YZpcjOypkeqC7a+GX57mdrUr6JCUv1LBspx4IfEQhxW839hviFE9/6mcp62wiA1qtbS91HwYV33oKngH1qo8I/zsCnrrwd8uto3jo9zvU3UjNYZQfyyHmdX9H+vOsQe1zFDTxDhJRr/BOQRB5MaBvNMfzN6yCwCQUjQhd/jDmmW8pzctn26cTFXTXGkJC3HqHwhkT6rZ4Cq6xFD6o+NLCzxFiei7DPRP1+tB+OqoAVzkvhKIX30Td0t03nlBi8XH7n4k1wodd3BwcZkUCREkhVHRnVf/II0ih0kbL5evijFPCxXGwr224NaxKuubTpMm3LybzhE0qekmPEbc0+rjTS86fCj4q+7XvEu/Tbc3qzVBq5U1bFF4fGoVTGXMBs7smv+hOMASyIbPl6vSRpqPwEpYcgU7S8RbxspK5o+nkmbYdwweqe5tvjtRXuqerx/S3BMronijq5ZIEIG0C5bRVP253zSwNjpvpbagTjAO6arKO2TfGujTr0N/1wlAz+UT7i2+9pjFIvNSxx/RVoizmYtNvFNjQCYWLwqmD5IPj7Ugz5o3QcxgOonYaSu5Cc+w9IfYtZBk7fcOu0fABxe1Hrs5OfTLA0lSC8pUQ4is9fkxuSzjxt1FCRgI2j15RnykzJV+YZiHeYEAeYVWSnYjhSiONtOBO/hGd74ArAB+PhQUYQeuZn3d1xEdAGaEAZc3L1u9wKi4RI51J4eUaZ6RBbcEQ5bmfsTxVQh1ZIaUI0E5KFtLOOi7RaStFpMieUwEx13lnS5b1Kqp
 2wDQqK+H
 SkUXpL+VEGlxYqmVyeyUsIIXc4pNaxpAJqjTA6roC+FqTy8YZ67JwoOQ3xT/EE7Ri38RvskiqQTCuhnA+WV0grdt51s9vR9/QE3j5LcNZhkF+LP2naT9l5wwixVwPZSMHMHuHE9Gt9LG+AhuDn6oEqafTScCF63c1qsqpg1litZGT+y9dhQL+HelkJNF3LTQdEkt4xAoaLmZth+k5JiuOUWguhmqX58IsFKgVGXbu1XcR1zzVSFvp4SuRvum+ufSRxYykkrcacj27V4WngVkrv1RdOvhxeE5dPIfCUHo1NjhVKmCcdrKJ3XZQUaqotf5L4L3bGY8iFeUDlVUGu44DRBwmqBnzdSDzJJotRO1Q15L8iWmpNfXwJKqGDU87ajATp7FG/kf+gQPJ9y2qhWmcuzXKcwGX3r7y8emYBopdtkD/mYyM11l53tJ3GfkcbvEE6zxrpE6O+9M4FJo6iTg48Fh29yDKiLoEOaF68Rd7KNZ5p8CGuaBKfo6napIaeMIp1ixWue7V1C5nEXqRjO1+SQ7TvWxQ1Old4i6aa6eU5nLBqdFO8jPW0VYM0ypvaov51gZQmYdkb6ydJwgUP/zIumEQPIIMUvQhXcEr0eMoeD1oAxzkfuYA/NJBJO1sNC4zquUmJiqvLW6F7FL3waQyKjx/apyxVBPVavll
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] mm/hugetlb: isolated free pages in free_huge_pages break
  reservations and offline
- [Low] mm: missing Fixes trailer on commit fixing hugetlb migration in
  alloc_contig_range()
--

commit d4646288ad2f50427e782b8be06fdbc2d46b6d5b
Author: yangge <yangge1116@126.com>

mm: replace free hugepage folios after migration

This commit adds replace_free_hugepage_folios() after migrating in-use
hugetlb pages in alloc_contig_range() and skips MIGRATE_ISOLATE pages in
dequeue_huge_page_node_exact() so freed hugepages in the isolated range are
returned to the buddy allocator instead of being reused from the hugetlb
pool.

Link: https://lkml.kernel.org/r/1734503588-16254-1-git-send-email-yangge111=
6@126.com
Link: https://lkml.kernel.org/r/1736582300-11364-1-git-send-email-yangge111=
6@126.com

[Severity: Low]
In the commit message, this is a bug fix for migrating in-use hugetlb pages
in alloc_contig_range(). Should it include:

  Fixes: ae37c7ff79f1 ("mm: make alloc_contig_range handle in-use hugetlb p=
ages")

[Severity: High]
In mm/hugetlb.c at line 1099, does skipping MIGRATE_ISOLATE pages in
dequeue_huge_page_node_exact() while still counting them in
h->free_huge_pages allow migration to consume non-isolated free pages
backing h->resv_huge_pages?

When an in-use hugepage inside an isolated range (from offline_pages() or
alloc_contig_range()) is migrated and freed back to h->hugepage_freelists,
it remains counted in h->free_huge_pages. On the next hugepage migration,
alloc_huge_page_nodemask() (mm/hugetlb.c, line 2184) sees
h->free_huge_pages - h->resv_huge_pages > 0, and
dequeue_huge_page_node_exact() skips the isolated free page and dequeues a
non-isolated free page that was needed to back h->resv_huge_pages.

Once the free pages backing h->resv_huge_pages have been swapped into the
MIGRATE_ISOLATE range (or accounted as available by gather_surplus_pages()
at mm/hugetlb.c, line 2231), dissolve_free_huge_page() (mm/hugetlb.c, line
1971) hits h->free_huge_pages - h->resv_huge_pages =3D=3D 0 and fails
offline_pages() with -EBUSY after already shrinking h->max_huge_pages. In
addition, page faults on reserved hugetlb mappings fail in
alloc_huge_page() (mm/hugetlb.c, line 2836) with -ENOSPC (delivering SIGBUS)
when dequeue_huge_page_vma() skips the isolated pages and surplus allocation
is disallowed (such as when nr_overcommit_huge_pages is 0).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106220445.2859=
944-1-mkbund@amazon.com?part=3D1

