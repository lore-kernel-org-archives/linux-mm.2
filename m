Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18578CD343B
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 15:54:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F11E6B0005; Wed,  6 May 2026 11:54:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C9436B0092; Wed,  6 May 2026 11:54:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11B9B6B0005; Wed,  6 May 2026 11:54:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E9C526B008C
	for <linux-mm@kvack.org>; Wed,  6 May 2026 11:54:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AADA18B31F
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:54:50 +0000 (UTC)
X-FDA: 84737443140.30.BC03B7E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 977E980012
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:54:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vHzxZa8q;
	spf=pass (imf30.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778082888;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jWNyX2VDd2zzWcjFs7R/kuuxATwQtQ1vBqqup6jJhHo=;
	b=Y0z3g/vxfuEqmfXkzZM3xGM/yRmmrei3GC2Fpy6AzUfDtOGlJ5fUbiShtlSjSR8NuGfrhI
	ewOTihlZviYAmu0kZiJLeAPX38xXp3coRnxaxTwX+v6kUGGXyU+hR6kC8BtgXWEDdKUsIy
	hrTDw8zdCXR+CyGfiMOL421iZiC0WrE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vHzxZa8q;
	spf=pass (imf30.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778082888; a=rsa-sha256;
	cv=none;
	b=mQlU1SGHnPxjxhZsbkAWSYdPs0N+4i3Ami+gw4Xz+ZttLCGF38C/A2S1C9E7znkwp3P0iE
	Ez2PK8SPbzo88XtJkiQd1ubjf19UIdtaS6PexLiP0uIom2un/wL2WO/NrGTmcN8leha1GJ
	qbCx40u5h+3AKjS2NNwCJlTOAOegeVM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D52F40D65;
	Wed,  6 May 2026 15:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3FDA7C2BCC7;
	Wed,  6 May 2026 15:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778082887;
	bh=tVd9R9UGaExwjc88058u0c2WJO0rxP5vN7hvHA7LEZY=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=vHzxZa8qPmV4C96wKWp7qDBD4MYGwmSqkLh0iv0TsOeNHs1Jr6cM1E0UzmD3UF/pX
	 DYPtZnrZKs9ezP8+UjTycU7aEfICuQOYrJd1Qj0rebPnPMP7hd2XyZbR23pW0RRoXr
	 w4FoyyTkyqjtAOeFNjVZ25gtEwTY2ZiADYT2ETtWekZLYFOEyKsPuerGRlcqtBwPmQ
	 tZc/9MPl+LAxiVp7RhbERqEOATk911nyEQ28kRqxY0jEl1lEoikzDOu7xjOi7fmmeq
	 kXzznZvYfftJl04Qyzpa3X4L5bhnoy+lRD85zIYzB1THhdNoPPUTUrgW4m4XXC3K8h
	 Unq4EQoFuvBKw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C5EFCD3443;
	Wed,  6 May 2026 15:54:47 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Subject: [PATCH v2 0/6] Open HugeTLB allocation routine for more generic
 use
Date: Wed, 06 May 2026 08:54:36 -0700
Message-Id: <20260506-hugetlb-open-up-v2-0-826a0c5f28fc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADxk+2kC/x3MQQ6DIBBA0auYWReCRNR25T2aLpCOSKqMGdG0M
 d69xOVb/H/AihxwhUdxAOMe1kAxQ98KcKONHkV4Z4NWulZGVWLcPKapF7RgFNsi0Pa2VaYpe3W
 HXC2MQ/hex+cre2CaRRoZ7fVxtCPLsmlUa6q61tKHJK37IE/4S9F3nshPKB3NcJ5/DiQmdp8AA
 AA=
X-Change-ID: 20260504-hugetlb-open-up-eaba80571b09
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, fvdl@google.com, 
 jiaqiyan@google.com, joshua.hahnjy@gmail.com, jthoughton@google.com, 
 mhocko@kernel.org, michael.roth@amd.com, pasha.tatashin@soleen.com, 
 pbonzini@redhat.com, peterx@redhat.com, pratyush@kernel.org, 
 rick.p.edgecombe@intel.com, rientjes@google.com, roman.gushchin@linux.dev, 
 seanjc@google.com, shakeel.butt@linux.dev, shivankg@amd.com, 
 vannapurve@google.com, yan.y.zhao@intel.com, Dan Williams <djbw@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778082886; l=3086;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=tVd9R9UGaExwjc88058u0c2WJO0rxP5vN7hvHA7LEZY=;
 b=UT9hQwclJuvOCfr+MjB/cjc67EeWP/7MENcnlpbEQyxJp3v0qDjaR+YwsCdZjQac/YJ+l+dAQ
 44V3SnWKGdVC1wsVg3GJBjui8ZpTuFTfgpQqwUhn6QbVoQqZGRFAOqW
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 977E980012
X-Rspam-User: 
X-Stat-Signature: a3t1wrkumdaomx533cszauwurm7i7s7d
X-HE-Tag: 1778082888-793993
X-HE-Meta: U2FsdGVkX1+ykNVxFgnE07sJI2tdr9YwaJ+kBpOMkbuamPDOilAvlsUs+KapUqZSmskiiwMQnuypIZVditEfzv3kvqKrQ903kItF7jFVZwycSs4osc3AjpdiR65WeI+8VJTvRej+0Ynyhjhm/EzkiELkpAVZiW1I7h5y/Zj8H7NDwp1WoSYuzw/+MvMhcnHsW08R9YaopBTOXCi+TIftQ8VnujiIkL9im4gEHMzMkwog5KaAorT33Xh5fFa5QpdjEtyViNJ2UL/nTM4h3GuV7UXhLgeZ4RBUSRoIxSezyQ5R8cUqlAZju6mjDpv7ZQvby9cvf0Uso/bAiYBfA2EZeg3HWmJ7DWFDi9Ynt8e4TeRrCzk7sxxONlJ4Ws0JykyMeDHdf+P+Fxo6xp1wh1dIWtW0GyMPaI1FhuCLo2m5KL9VrCefiT7q4CZk+v72mo1AIgTL5Onszg9czXRM8ojMz8mLrAWzkP45TtYo9R93M+BUNttsxstBt+beu8dOdMLxsdDuR23OAgsF0Ryfl8piUqoftQ8NnsFu1OiBM1ULy5jNgCd2a71jAgPBxn3wssQhLeBey62ItDQzBY1gO6pdhGxnYTHw0e66pWHgOmqkpyc8M7ligri5C8/zC6K/aZLl+IiFgcJuY4bIIYlfq3rZSyClcMT70KTDHT7PgWqKT7WY0sQFrS7AwoYHjK14C/5Dg9KA4ltTBfmwhuX43ec+4E+z8VMl3JsRAG2tkx99QKDOGrgX3cKZqpZ+PFaCSYD34FjZ3bZUy+zujWz9AnPY97K3v5r6ZeboX0yBvOJ6ZHKu6IaaIj6hs7yWqZeKz9ufyvP8edevciDcZmXKIDlddaW2lBGtaJ3bRg8Xyn9hLLwissYpVWZ0ScpyR10o4yrj92J3DWn4kZUN/9AknUqlpMNLrqgGKX2mk0IA+850bUOE3myNUUatAAbYcyGDvNpY3ArJDIpRiSnlWi6+Piv
 5DNHogmx
 Ch2ITTDscrQSwo4emympwViwAJOzwCU3ZXXDkE/TjKWvG0MAgtrkBM/DJaBYSsIKorrRBtwvEtmg9tlcWLHkN18emSB22y2BtUszC6P48UfvA5vHBoSedVj03otac/EpGhd9Ei2O+OAY0XwNwScEdjNTrQXhOi9pdpp9yj8YnHHNEsEb4LJVFOOr87ugj9mzBy7dhNZEBwUMply4EkcNHXanVQ+anDMfXOYuW3kepopRqdowLoyGjXTy21n+sGYwjAyre2TOHa2cDJGQsOnjDCPf0YGqPyIJgVElM2ghN76Vp+81+p/vzV07JK8oG8ZV2wJT564jHYLLri28vr9kYcvKIjxFumxl7vMZcRizet6npHns91DE+O5EO1qiP0cL9iCvSkT5RpIcuCJkiyFJmwDFbh/S7aU4ifoDZNj9nCY4RJUdd+48MYxEqHC08f0accCXi/jg1LtZ/j2xWKpQlyOTbjv89KmHCmHljMBnK7XiRtkj2eIGGFd94Ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

The motivation for this patch series is guest_memfd, which would like
to use HugeTLB as a generic source of huge pages but not adopt
HugeTLB's reservation at mmap() time.

By refactoring alloc_hugetlb_folio() and some dependent functions,
there is now an option to allocate HugeTLB folios without providing a
VMA. Specifically, HugeTLB allocation used to be dependent on the VMA
to

1. Look up reservations in the resv_map
2. Get mpol, stored at vma->vm_policy

This refactoring provides hugetlb_alloc_folio(), which focuses on just
the allocation itself, and associated memory and HugeTLB charging
(cgroups). alloc_hugetlb_folio() still handles reservations in the
resv_map and subpools.

Regarding naming, I'm definitely open to alternative names :) I chose
hugetlb_alloc_folio() because I'm seeing this function as a general
allocation function that is provided by the HugeTLB subsystem (hence
the hugetlb_ prefix). I'm intending for alloc_hugetlb_folio() to be
later refactored as a static function for use just by HugeTLB, and
HugeTLBfs should probably use hugetlb_alloc_folio() directly.

To see how hugetlb_alloc_folio() is used by guest_memfd, the most
recent patch series that uses this more generic HugeTLB allocation
routine is at [1], and a newer revision of that patch series is at
[2].

Independently of guest_memfd, I believe this change is useful in
simplifying alloc_hugetlb_folio(). alloc_hugetlb_folio() was so
coupled to a VMA that even HugeTLBfs allocates HugeTLB folios using a
pseudo-VMA.

Testing:

+ libhugetlbfs tests pass
+ ./tools/testing/selftests/mm/ksft_hugetlb.sh passes

Changes in this revision:

+ No longer reintroduces try-commit-cancel protocol for hugetlb's memcg charging.
    + "mm: memcontrol: eliminate the problem of dying memory cgroup
      for LRU folios" was merged, and memcg seems to be moving away
      from the try-commit-cancel protcol, with try_charge() no longer
      having any users [3].

[1] https://lore.kernel.org/all/cover.1747264138.git.ackerleytng@google.com/T/
[2] https://github.com/googleprodkernel/linux-cc/tree/wip-gmem-conversions-hugetlb-restructuring-12-08-25
[3] https://lore.kernel.org/all/bb35a69a-5be9-45f5-a557-1902487a1bc2@linux.dev/

---
Ackerley Tng (6):
      mm: hugetlb: Consolidate interpretation of gbl_chg within alloc_hugetlb_folio()
      mm: hugetlb: Move mpol interpretation out of alloc_buddy_hugetlb_folio_with_mpol()
      mm: hugetlb: Move mpol interpretation out of dequeue_hugetlb_folio_vma()
      mm: hugetlb: Use error variable in alloc_hugetlb_folio
      mm: hugetlb: Move mem_cgroup_charge_hugetlb() earlier in allocation
      mm: hugetlb: Refactor out hugetlb_alloc_folio()

 include/linux/hugetlb.h |   3 +
 mm/hugetlb.c            | 209 ++++++++++++++++++++++++++----------------------
 2 files changed, 117 insertions(+), 95 deletions(-)
---
base-commit: adc1e5c6203cf13fe05a1ead08edcb3d3a3baae8
change-id: 20260504-hugetlb-open-up-eaba80571b09

Best regards,
--
Ackerley Tng <ackerleytng@google.com>



