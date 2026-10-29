Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16E35606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 03:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XETfCPhB
Received: by kanga.kvack.org (Postfix)
	id 38D4D6B05B1; Wed, 28 Oct 2026 23:22:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 365236B05B2; Wed, 28 Oct 2026 23:22:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27AF16B05B3; Wed, 28 Oct 2026 23:22:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBC536B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:22:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 65476140211
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:22:11 +0000 (UTC)
X-FDA: 85374215262.14.CD0F1A1
Received: from mta1.migadu.com (out-64.mta1.migadu.com [95.215.58.64])
	by imf29.hostedemail.com (Postfix) with ESMTP id DB783120006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:22:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XETfCPhB;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.64 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793244129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HNguEgLKPRt0ONBwMq+rfgApg7KOxogrMEorbHbFjtw=;
	b=QD8g3ANjRP99dRBMIHGQnICkhg3dx2DOeoqgD6AJjSVm2+ki+tRoap8t6z5wYGfND5J5LG
	PR//WrBGkaidIKvlxfqHPyfhxl0prG4BGFUY48zIb/vsjyiKXMxUNaWNKatkeRj16Q71RM
	AhB4cBcVKagqkgVTDy+CrMg9zM8Yrg0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793244129;
	b=VACizbmS4bbeNAGAPDJjpGkFt73fDT4KI1i+Rs+7cg2oLlV1V7B0/ZqaD+v6gNnVStKGrN
	3bs9u4sXIIaxPjX2TKvXlBhAWDVBPljCdcYlnt2+qiZ36lEnD9/+WtzJaqVgo4/vGLZ6Kc
	FPU4S48OMP/orMmeuDv0LI6jb4nyonU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XETfCPhB;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.64 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=HNguEgLKPRt0ONBwMq+rfgApg7KOxogrMEorbHbFjtw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793244124; v=1; x=1793848924;
 b=XETfCPhBW8ek8/36n08lOqZQDykW9l4t9+o+5T9ihnlqE0ZQ4Rrja6oLZ09/8IU9ee04qmx+
 tmlrgwbGqh8FuZdVHUXvPsX4BOe4pGMOJIfaBtBu+MHAkZj867cX7r/q/VplfKjyK8lvDXoRWlt
 BMYoSoW/G/dY/GpLPwlztW8Q=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 1231c8beec06274d;
	Thu, 29 Oct 2026 03:22:03 +0000
X-Mizu-Trace-ID: 1231c8beec06274d
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 3/3] mm/hugetlb: fix NR_HUGETLB accounting for unused
 surplus folios
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <auIORHr432BlmbrD@localhost.localdomain>
Date: Thu, 29 Oct 2026 11:21:47 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Mike Kravetz <mike.kravetz@oracle.com>,
 Frank van der Linden <fvdl@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 Chris Down <chris@chrisdown.name>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
Content-Transfer-Encoding: quoted-printable
Message-Id: <87146009-8E2A-467B-AAFF-8F79E9D5E32F@linux.dev>
References: <20261028113319.38544-1-kaitao.cheng@linux.dev>
 <20261028113319.38544-4-kaitao.cheng@linux.dev>
 <auIORHr432BlmbrD@localhost.localdomain>
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>,
 Kaitao Cheng <kaitao.cheng@linux.dev>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DB783120006
X-Stat-Signature: fd8mdqchkabt19ud78jaojg3h471om1f
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793244127-469418
X-HE-Meta: U2FsdGVkX1+Dorl0nKX6WHskZxnOxtNzA+5XDCfDTyK6Xm1VDcKuWnGovONsVzNK8v3qZEOdCmSjgv+rUSgfu/E8lbPm/LdEOWkAvE8K59Fe02qXvKbHfySqO2FFh5DC/MxPksAd5cGh1215CUgbGeSqR+7brzQQwuvXnq8YwRd/WXUNP5IrmRFYP3ffk1jEdMBxyomesbPOnOAl2U2/+Q1wofqq3RtbLOVxHigz8/DpUEacXn/7IJ+FxkOV9v6Eb66uS0DFctXac3Pn8yWzwGZO2WLt2s581XCF/cudkKwuYCkXGPcNEjE/9HU1pAPzBoTv0M6uc8WNgSv+2jAV1mR6bXHmM+asnfs0vNdAV4G1eN+DzacDknn/AubSOvdt7EC5r/jbjmbSNXrcy+61eklTOTZCpWEgT2MNIrUXX7yln7HH+g1E6vYQIrej+BcA9Fv5EpA30fcm3x4qIfHTx+/3VzCfshAs7C5pb6ZaRrC3+ZSd/iYwKIYS8ukvJD2vYk4yOYVwlbb3pFZ1M43/nAIH3XpQKad06MUF9VpyN5hM7qQEkHZ2v9J+G2N9IqF4rQGbYuu6fKUcAuTRXYds/S+6pRrepJzDXrlG9y8pqyO50Ytdk/i7768CxQiZ1zgFn0JCoPSJ0pjv+G+IJId9Vgp8P8pL47xFs2dnuPDiDn51F8F5tSxfk11zkkL7fD8TJJ+ht3tJjyawteY3ZwY7V3hcBCd5wMVCK8idIRiZEVW3LZdmvAq2L3VW3AMHrSTHYoyB9DKCJUmY07EikNT3ZPqVGp0zFfEh3HCLyERn1uASwIuQMUnFvIMK7cf7ZI6Nwt3DjFEbBIitQ4OwXcAUwdwXNtX1s+H1THBDbsMstyO6zHTapdTeM+87ZDdpU7EcWPtwOxxHw1BVjIOq4mnPpZ3mKhaPVQDSBI5soRiOLsw4tGbTZoqypEshPYHLa1Vi2n98c6j7xl8xeyVtAlu
 6MTLgaMZ
 Dl3TpcqajbKwzZAAnyUhgw3Nftok+BYLVxReaIfsaSdf2XL5+zi+KIR4QHAF3wztZRVMXkMmD8AuVqHSclKhESat+2FNQw3eP4NBYL3R2NiNLkpEMhj8JBp72qxebt8RAjFt+86DCmPLdnq+vFnLPbDpFA0GdT2lrESI95HOjE8n+U6OPSE7Q4M7Vaw1xOAmdvsz5ui/zpIg28HJyfES/rg6YXvSGrnWGPh6v9ENfXqCSps9xdYeOk52VB7xaLeuXj7gF0pGckbI0uFsFvnkHS1/H0UJJTDp1V5TXZTBACNwpO6U2/h5ATkNS02tjq0hmjQZZXbSmPnNUISASKJIgkxPergHFyWsNgmDJ0If52DBJGD2nSHfsX5VCPsteXGurolosZHi9/VvNV03UnND9PDP7mB7QUOLLGqxXUwDlCEDqUqMQCBe16Htx4oIk7KXm8xwA8xZUY1BtYAugXNXBndFF5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 28, 2026, at 23:01, Oscar Salvador (SUSE) =
<osalvador@kernel.org> wrote:
>=20
> On Wed, Oct 28, 2026 at 07:33:19PM +0800, Kaitao Cheng wrote:
>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>>=20
>> free_huge_folio() unconditionally decrements NR_HUGETLB, but freshly
>> allocated surplus folios can be freed before the counter has been
>> incremented.
>>=20
>> This happens when alloc_surplus_hugetlb_folio() rejects a fresh folio
>> after its second surplus limit check. It also happens when
>> gather_surplus_pages() frees folios because a reservation cannot be
>> satisfied, or because concurrent pool changes leave excess folios
>> after the reservation succeeds.
>>=20
>> These paths leave unmatched decrements, causing HugeTLB usage to be
>> underreported and potentially underflowing the counter.
>>=20
>> Increment NR_HUGETLB before calling free_huge_folio() in both paths
>> to balance its unconditional decrement.
>>=20
>> Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
>> Closes: =
https://sashiko.dev/#/bug/linux-860a3b8f-0b07-4cd5-a122-aa2288463bee
>> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
>=20
> I feel like the whole hugetlb accounting is a bit of a nightmare.

Can't agree more.

> I wish we could teach free_huge_folio to ignore accounting-wise these =
pages
> but not sure if that would be any prettier/easier.

My thinking is that we should not use lruvec_stat_mod_folio(). Instead, =
we
should use mod_node_page_state() and mod_memcg_lruvec_state()
independently. In that case, when a new hugetlb page is allocated, we =
could
account for it directly via mod_node_page_state(). The reason is that
lruvec_stat_mod_folio() also accounts per-memcg NR_HUGETLB; only by
splitting the two can we minimize the problems introduced by accounting. =
For
callers that need to consider memcg, mod_memcg_lruvec_state() can be =
used.

I expect that after some cleanup, there will be only one place that =
needs to
handle per-node NR_HUGETLB.

Thoughts?

Thanks,
Muchun


> I will have another look later on.
>=20
>=20
>=20
> --=20
> Oscar Salvador
> SUSE Labs


