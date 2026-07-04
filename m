Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABB79C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 02:43:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55AA06B00B5; Fri,  3 Jul 2026 22:43:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50BFB6B00B6; Fri,  3 Jul 2026 22:43:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FA4C6B00B7; Fri,  3 Jul 2026 22:43:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 144D96B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 22:43:34 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8043A1A03A5
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 02:43:33 +0000 (UTC)
X-FDA: 84949548306.06.B22D3AB
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5271540002
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 02:43:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z6AXqHVA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783133011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y/w2//o9tLFu8D1YyHGm3x2nl7TT2wWydLVFSqS1msQ=;
	b=Q+KFIFVKtn2I5JdvgcZc466LGxS2LXqhCKGtAt8XzVxxKxw6BDGoUR5uziyui2CkxWxoq/
	KWqNfyOvzdOodqbI6WF3yfTFJhFoKOK6IAJaRSbgxUcgnlzChkt4xcYJNAJz/sa6vrEsJ+
	Kb6bDX/bZAmgdBKk3FVHjcVAib7fg38=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z6AXqHVA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783133011;
	b=i9fpV1rUxJf1wlUX40IP1gZEedFn01SKnrTZ96H+bXjx8lk4Bq6WmSYCJhkc2XVAqdR+KP
	MeEyhtbQwbrhyg1Y25oPIGUC1KJA+1kFpGA39hQ+HvAsikW2MUTZ5zGu87XjHFWal9rJ90
	SSyucJ4St/zSw0esgKAM8BVmS1iSATg=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783133008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y/w2//o9tLFu8D1YyHGm3x2nl7TT2wWydLVFSqS1msQ=;
	b=Z6AXqHVA+9nAVYfSa3QbdfPfvb43qNaCDbGVGpDJitxEZRu/+WHXiZt1uJm2m9gWRYnLBn
	rrMBGuwNRW8WoE+9qA6G/xghPUPVLiysithLQ4EAtBTx6p4nsscEq1kQqKczHWOE40wXsn
	Q29B2m+VxuTz6Z/bm0e5ix4C/1bn3MQ=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v3 1/6] arm64: make huge_ptep_get handled unaligned
 addresses
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260703114202.365553-2-dev.jain@arm.com>
Date: Sat, 4 Jul 2026 10:42:45 +0800
Cc: osalvador@suse.de,
 akpm@linux-foundation.org,
 ljs@kernel.org,
 david@kernel.org,
 liam@infradead.org,
 riel@surriel.com,
 vbabka@kernel.org,
 harry@kernel.org,
 jannh@google.com,
 lance.yang@linux.dev,
 kas@kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 apopple@nvidia.com,
 rcampbell@nvidia.com,
 ziy@nvidia.com,
 matthew.brost@intel.com,
 joshua.hahnjy@gmail.com,
 rakie.kim@sk.com,
 byungchul@sk.com,
 gourry@gourry.net,
 ying.huang@linux.alibaba.com,
 ak@linux.intel.com,
 nao.horiguchi@gmail.com,
 mel@csn.ul.ie,
 j-nomura@ce.jp.nec.com,
 pfalcato@suse.de,
 tglx@kernel.org,
 dave.hansen@intel.com,
 jpoimboe@kernel.org,
 catalin.marinas@arm.com,
 will@kernel.org,
 linux-arm-kernel@lists.infradead.org,
 ryan.roberts@arm.com,
 anshuman.khandual@arm.com,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <58500686-A4A0-45FD-872D-AB0EE2AD2ACC@linux.dev>
References: <20260703114202.365553-1-dev.jain@arm.com>
 <20260703114202.365553-2-dev.jain@arm.com>
To: Dev Jain <dev.jain@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5271540002
X-Stat-Signature: z94egau56mbibjp3i4ude56ipxjohxc7
X-Rspam-User: 
X-HE-Tag: 1783133011-881465
X-HE-Meta: U2FsdGVkX182aI+bM17CNFIr/XM8I0X8KQ2SICttAGZmovWAmwWbdIjzMndHB35/+3CcONJJDf5131BI50088LGdpBCWGYaf8phK4AcJ9lTnI1mKmIA6f50q7lpdZAJIrsBBQXI8GV/+CkzzH2kykYVoQ3fn5FG7gOtZE160Q2B3rv2gU18G1JpCzGP0n5z22/l3G/DG4C/Mee2DFCx9jhT33ltXjwIyguAdH3Iphui30AM53yNmgowlf4+YI1tSptPGQFJPQc+JTlhOAAhb0ref/jb1LxbEUrOY/Q9xjyBU7AXu5umr6wrWg/JCLlxdg83Nt2TXIKuM646QpRThQDX+KgxTileM6n8fCZ6yXFeZbwZGAlnz3fKSbghrzh4/CCIJQT4IkBN3x1BVgTlrXXmOWYFma+kHFfuSALKJiENKUjGIAWDRbnFSep6lM7M1QgJYf3LHsULL5THcYCFeYzXjfXx/eiprcrgw5e0t8cM9YogX89Ldemp/1Rh53ogkk3mOgVHfXylpaQg+Ulhzb84H9O51sOSLRAr+4qErWcWQlxQcRqO9BGRpjkrM9qJuoPA67YLfhJcyan5bVymfr3W4GwIzg5aZXGMHXfL7VzHpHJK7xrOFeVsWqtXxdpXnIqtRBW6/GKo53i1lnkBoVzheBOUDwUQOlgV9E7T5RpHe+2xoICJARxqS5O5m4WO8Wrnpafi9zdA7Ufaa5OA9K2ECRcAnC8iGaEg2uMlgH2YDqX0HaTOPF3+9dFn7S4vrWoGE82gjvlMtJpYGLd7VUqWt+nuQLy8bMQhdwgP6+68UmjLXohcTuZjNOkWBq4il2U8f5D49cDkINcbU4E/vY/KWabQjrdM/U3VT3ICtTwWdmCB37GHFffpA9Zdxjo29pXuUBohG+UGOTkA5/Ug3IrP6bVNHWG6D9Pcbf85gtME56/LmZKluzTXGq9++9f8skJgp/4bz1cL0hEWCCSy
 uaFKDwT5
 3Hi8TSox8MGpRPZBgmbN4clawngZdp4e7Jk+XjBBaYjlRVcIh91v4LGRNhiahb0asieA6iys6535yFsMrhGb1POvOhSCPEQ3ASpfcNIRA8IjHUh7Ge0q6ADwyib8x+yD0s02qDYIfKPdtBVR9FYUvyYO8p4IFRukgFUXUaEyPukn9/2c4y6cVEI+XSLvPYJ9lIYkTNcQlYGiGLFq+HAKD8olYhVAjgoXyCsARxbv62FCwafvI10fSpd1o74VaEz9YaRyS1ijMjG7nUCbAD8uYdF/ZJ30rQNu6nt+c6iQ7JJbelSH4cDAJl0bJUEtgPJHtkcvM2XMb4/R4+F/bhtwR21GApMjUIKkIiPnlk2Tkty8MCGBce/2tVHpx9vM3S8ZlMRXU3lshX9DIYy4j/Jv5XJR/gAo0E2KhxB39AIPJCpS00CQVeEie0rGsBh7PyhGilTfq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 3, 2026, at 19:41, Dev Jain <dev.jain@arm.com> wrote:
>=20
> huge_ptep_get() can be handed a virtual address pointing to the middle =
of
> a contpmd/contpte mapped hugetlb folio (examples of callers are
> pagemap_hugetlb_range, page_mapped_in_vma).
>=20
> The arm64 helper rewalks the pgtables in find_num_contig to answer =
whether
> the huge pte we have maps a contpmd or a contpte hugetlb folio, and
> returns CONT_PMDS or CONT_PTES, so that it can collect a/d bits over =
the
> contiguous ptes. We can falsely return CONT_PTES instead of CONT_PMDS
> if the addr is not aligned.
>=20
> Fix this by aligning the pmdp pointer down to a contpmd base before
> checking equality with the passed huge pte pointer, to correctly =
answer
> whether the huge pte is the base of a contpmd block.
>=20
> Fixes: 29cb80519689 ("arm64: hugetlb: Cleanup huge_pte size discovery =
mechanisms")
> Cc: stable@vger.kernel.org
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


