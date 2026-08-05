Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 607DCC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 11:18:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A7216B0095; Wed,  5 Aug 2026 07:18:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87EDC6B0096; Wed,  5 Aug 2026 07:18:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 794786B0098; Wed,  5 Aug 2026 07:18:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4ED996B0095
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:18:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DEC9214044E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:18:36 +0000 (UTC)
X-FDA: 85066967832.03.6A00BFA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id CB7DC80006
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:18:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YpsQvHVg;
	spf=pass (imf02.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785928715;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3wBE0FWT86dCvAAdK40bRb2ScmX9rEoQPZu3QMTLjYk=;
	b=3opojdpyWw01FCq4XnnrRMOXpOAIq9Bqv8wAe4eMaEdoAlILpAjz9JYRwL/S7IeppekvYK
	vRS1YpsOfJaHNA5Yrp+Scjr9Zmk4RYX32xIsgm6tHYiylrveHlwPNGMcyAlZI9lb+e9yP5
	xirr43nJ39cdRZfTG9ldINl+ePnmhTY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785928715;
	b=JrKcI4z+B+gzVyB7s1sHvMWO65PxS7rVPrF4HpJObCqPN0Oij0vy1xZgMmPSmFIqwz9FPR
	TunYe1JW44ZePXEl3uy5UCYKs+iWl/VBCRou0gIy6sIF27NWiBeWpZxBqF/b26X96I7Mnk
	VJiIUoGV7Nr+rmqTCqNPxFRWxg7GJNo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YpsQvHVg;
	spf=pass (imf02.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 56E4940B15;
	Wed,  5 Aug 2026 11:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88CD6C19425;
	Wed,  5 Aug 2026 11:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785928708;
	bh=MU5empUMl3yldn/ojRHKh06PTEKGbPUZ4kS1eWRJoVY=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=YpsQvHVgzgU/4xG+7gT7zXvCPuqVsdtYwQicGeAvGwQQR2nYq6EdBX3cCuYyMInHo
	 SYppcgKGgfgAa5myeGJQ/N/Etpg0nsxMz6nQUq3kPmSnOu3mQd3a9x2wpi2/TpMhFS
	 vnoqT1Fcl9WCuEizfz66ntBdVPAVmqs2d7PW5BI2gAuWAq05ROdZu75Tb/U3AlDJ1x
	 LTH/MG0AkTmOiA30ora27eOIMHS+Vb7L85KdfNJW6INatUxxrDppH40kBGMGQC7W9A
	 Hvo/s8mSGLrdwofbB/gG2dTHmoZEakQIijzuVQtTzoLwDTynPQ5cW/Afe2DRHiwDRo
	 K3+rHaBAGQSGg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CE44C55174;
	Wed,  5 Aug 2026 11:18:28 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Subject: [PATCH 0/3] mm: support splitting mappingless swapcache folios
Date: Wed, 05 Aug 2026 16:48:23 +0530
Message-Id: <20260805-b4-mappingless-swapcache-v1-0-b1d78ba257ca@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAP8bc2oC/yXMTQ6CQAxA4auQrm3CFOLfVYyLzlCgRsfJVNCEc
 HdGXX6L9xYwySoG52qBLLOaPmOB21UQRo6DoHbFQDXt6wMR+hYfnJLG4S5maG9OgcMoePLc9Y4
 a1xwZSp6y9Pr5rS/Xv23yNwmv7w/WdQOr4E30fAAAAA==
X-Change-ID: 20260722-b4-mappingless-swapcache-9badf123138a
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Nico Pache <nico.pache@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785928706; l=2322;
 i=shivamkalra98@zohomail.in; s=20260402; h=from:subject:message-id;
 bh=MU5empUMl3yldn/ojRHKh06PTEKGbPUZ4kS1eWRJoVY=;
 b=h7y3Pjsg4r+NdPMicPmvEWMC2Ho6ZdL0IIy0BTtTOeVECkZ/mZLDLYhfb2ahKy3FOQMnebkaH
 flAUIWn8AC6DVQVxGuodSOCJ5ZwParkiGLGybn9or1t3EVrTEdorstP
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=U8kQSxcte8P8iZ6zB7phIj+Yl+i/5ntifBGuclgypx8=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260402
 with auth_id=716
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Queue-Id: CB7DC80006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: i5z7fkb6anyws8u64z5qr7c8mdjjhg4g
X-HE-Tag: 1785928714-81204
X-HE-Meta: U2FsdGVkX18py23K+CuqVzbSDlIsSAHQLGfB5Hgdzu4qLBB+Cdhfjyo1fHisop/mlbxNp8Bu8t7faJTOryyBKa1NLda3KYZ+YeYkq4bYJIAZQkM0AXnI+FgqCbYkgP4HOvdFHUWwstvEXbmJNvEPNi8Z4cEGNV5FabqRrWdYp4b+8xOMleaBQnL9GS78RFq7QYiN/YywhF/WXT8dzAlt20j+orFavIBDvkZgUPgrXjJ4Uy2LYUE8OMyw24ijdYDjzDR4AHtNJet9rEqmwMnbXBDiy/I+7bhAKbmF8EMR4l+KOOuYKyPVsIFD5zdxnsxXl46QT/TfdLQf48zxAuvwZlfalqVZqk1nfHDmZ5/fNXhyUMg+sujX568bNs11xnK5roOSBa0yNEZb1297tTfd3A+BD449L70sHxIY7I/IzWbDPhB1Ugr2YxrUQmC2QOH0BNbWTjTb+92n6yDVHBSJL1OTFIF7/o4hN3JsXq8Bc3n55ku0ckxObPJcD5tvDsW4bZRGthLUWNmeAEF5MwF6HyuH6W6O/Ym5FsMIQkVKewX4H0FL9sVbXZzp93I8jvz2b4Vu+ZbqnM62My0p/3Vjbmmb8hYXyUHx4QO9bVq7wmxM4spBQ90C4NXf921Vv52+s56XjBLjVVbU/2dBf9IyofR7P/chCJGcnY9VZubW8LFj+4PiFoyOC0R2/9ByNVZnzB4RGDlyQqpL5b0cgY6Uxj2ABwLnADFVY3d9IFSPoTwtO8976Tk1uTolEiIRXr1u+n6MmCuRPqH69HzIHSb13Pn+4QymT78nW7eVML1iaFFxg7MKw/HXzQ2cHY6e3RBpsLO5nFIzzVB8FRRzDU3qEDpXqNx6VhRDEi93mD/+P1/Avu4B/zdX8AlA0J5T8sm3cshqjIrsJzR1MgJUj6VRCNI4imgCEjbFobbzq9Azu5pTU1fJG2kJFbppqgdoHn2IMJaHpcSbQzbzRrErKEq
 k8LHaGWp
 qJ8FdJj8InGm0blSP30o4NdTMPWKZpu8nTiS1H1jfm+oC/DN/qhT+/oeq4iSy2b2LOXXhUhCHZ+BdXEhOajLS8UpRvatRN0NbBJgLSD3OYyw+Yefq8XQbTUyPkXo0kjFJKin/nAG80ip+j/9gMxtt2iq1nyy1GATwqbJIpbNwJApER4WO/FSvb27QQKPYNCHCG7COkqEPueoFoymMs7gmJ4bnuOwvSB1r6dJdfoePWJxnHvk3Iq6vDy/nRvsJBN8HFzvwbDULUA99v4sfBYEeWmPscjEDN+ryUevj2qqh1yfp52IyU8P5eQTmRhHP2qLvLXag565A+dGknnAnd6F/N0Elx9dR8F5pZUYioG1j+wRc80HepTBQ4f1N1YmWGFCqc3UvL1BRM+FVRPdEsnYaZevTkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Large shmem folios lose their address-space mapping when they are written
to swap, but remain valid members of the swap cache. Folios read from swap
but not yet associated with an anon_vma can have the same mappingless
swapcache state. folio_check_splittable() currently mistakes both cases for
truncation and rejects the split with -EBUSY.

Implement the longstanding TODO for this state. Allow mappingless
swapcache folios to use the existing uniform order-0 swapcache split path,
while continuing to reject truly truncated folios and unsupported
higher-order or non-uniform swapcache splits.

memory_failure() is one caller affected by the restriction: it cannot
isolate a poisoned base page within a mappingless swapcache THP. The
end-to-end test uses this case to exercise the complete shmem pageout,
swapcache split, and swapin path.

The first patch contains the MM implementation. The second adds focused
KUnit coverage for the split eligibility checks. The third adds the
end-to-end hwpoison selftest, which pages out a shmem THP, poisons a tail
page, and verifies both isolation and the data read back from swap.

Tests:
  - The split_hwpoison_swapcache kselftest passes under x86_64 QEMU
      using virtme-ng 1.41 (2 GiB RAM, 4 KiB pages). 

Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
Shivam Kalra (3):
      mm/huge_memory: allow splitting mappingless swapcache folios
      mm: add KUnit coverage for mappingless swapcache folios
      selftests/mm: test hwpoison recovery of mappingless swapcache THPs

 mm/Kconfig                                         |  14 ++
 mm/Makefile                                        |   1 +
 mm/huge_memory.c                                   |  18 +-
 mm/tests/folio_split_kunit.c                       |  52 ++++
 tools/testing/selftests/mm/Makefile                |   2 +
 tools/testing/selftests/mm/run_vmtests.sh          |   1 +
 .../selftests/mm/split_hwpoison_swapcache.sh       |  57 +++++
 .../selftests/mm/split_hwpoison_swapcache_test.c   | 261 +++++++++++++++++++++
 8 files changed, 395 insertions(+), 11 deletions(-)
---
base-commit: 0b53bff4fa05ff0d3ffbd3d3bb10fae69dfab498
change-id: 20260722-b4-mappingless-swapcache-9badf123138a

Best regards,
--  
Shivam Kalra <shivamkalra98@zohomail.in>



