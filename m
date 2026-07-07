Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EAF6C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 20:46:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BEBE6B00A6; Tue,  7 Jul 2026 16:46:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2949E6B00AC; Tue,  7 Jul 2026 16:46:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 135A66B00A6; Tue,  7 Jul 2026 16:46:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFAF96B00A6
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:46:20 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 550241C3AB3
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:46:20 +0000 (UTC)
X-FDA: 84963163320.07.A4A6323
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1CC081C000D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:46:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ANUe/9/A";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783457178;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ctc0pLVZvfWhiWWgi07XJE7ckvbANmGe80WIpfVbXoM=;
	b=HUobHabOAJi39qTYmODs9TlSLOP3rO6wA3tfnTNJRTMgdr1Ne01FUKEyahhx2AsDHnGLKp
	2MWkj8yBhpff8w4NaqLJtkfgxTVlTWxAcbnaZ/Aet+dQYH+SCVlzjLGr/bQlU1GRnVJ59a
	GaZtDdmsVCSr5AO94yDoiJbhSgYPFyE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ANUe/9/A";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783457178;
	b=qpLWUNHao4DErQmaQvx9P+EQ4fqhd8MGc0IjfG/nrUwy96Cj0mWF7IJvFBxxdPe3IFSPQC
	tEsSr98Fcka3ZSgk8ndBObrviaElEUFjIdzFNLnw0CMlRjNch7UdlGIa8W5VCcwmwsHPgn
	VRpw+NjM+HThSvAgc+N+qTrunwfSs9I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3FF6441708;
	Tue,  7 Jul 2026 20:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1AE73C2BCB8;
	Tue,  7 Jul 2026 20:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783457177;
	bh=3IWJjK6s97lq4LpNV8m481N4JvphBBCt49nzyXyP0oM=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=ANUe/9/ACRyTK6jcAp2ntPxCJ3/fEDNg6y/ZZ91SPthLZTdoLzlr59hfyowBnW7MV
	 C+jPFd00CNZBs1waeXT/z/JPyqhJ1688zPQM4aRJH1DgY6n9OY+Xy9YV+CX/oYR5MM
	 Udiuw+GPmEkbZavXUaRJo1yChOrQ7yIq5MOjfFCe3o5VoF1TlVnq4FEQ75Gql0SSq/
	 2SUd5rJ8ZT3j5xhDAftAVmKsHv9/MYs4AxEJaMjl7P3QMi2SHH3jdoS8WhLZCrZZvp
	 S0a+xkLVqIcHUm4TwSC46SHtb4s0wxjCm14iJedafCyef8O+nlcZICOOiBBhPBrR+7
	 qDhaqXosBWLSg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED7A2C43458;
	Tue,  7 Jul 2026 20:46:16 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Subject: [PATCH 0/4] Fix bugs on HugeTLB folio allocation failure paths
Date: Tue, 07 Jul 2026 13:46:07 -0700
Message-Id: <20260707-hugetlb-alloc-failure-fixes-v1-0-5bbd3a4b836d@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJBlTWoC/x3M0QpAMBSH8VfRuXZqVixeRS5m/uPUQhtS8u6Wy
 19ffQ8lREGirngo4pIk25pRlQW5xa4zWKZs0ko3yqiGl3PGEUa2IWyOvZVwRrCXG4md8cbUcFa
 3nvJhj/hDHvTD+35EVLoYbQAAAA==
X-Change-ID: 20260706-hugetlb-alloc-failure-fixes-c7f775eca29f
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783457176; l=3948;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=3IWJjK6s97lq4LpNV8m481N4JvphBBCt49nzyXyP0oM=;
 b=lch27w8B/JNod6WTxLtbttJlGGBNwOHfR39Xka7cI9ItveylihcL8ihpENvPZdjg53+GflQqu
 5GAIHNHwj6cCs8lJZHLGxqOZsb39+g9S7bQNeh5o/Wo1lI9OpaRRu38
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1CC081C000D
X-Stat-Signature: y8qx7rou6n6phzx7nhdwk1omt1qhcwrn
X-Rspam-User: 
X-HE-Tag: 1783457177-333622
X-HE-Meta: U2FsdGVkX1/rIhcE8Nx5xpY7KgZUcoyHvH1ot44B9mPeoPkXORa6mLASHfQbo7oCzyZpWXfn55sXVesh5fQ50qT3sl0dxyOSAxc+qfS7hyy7zeLnnmAcuTL7rndcAgeSHl5iEfhzUrY7FQLakt8FtkO+yiV5B3fNq35krHgDJViHOly5xQ0Wb6NiE3Mgiv68ZgH49CrsjLTmAp/31jK3nzS2Nj+80895OuzmObffye4p0UvhKLk7Hv2vzzWwBW7LK6+LoStmr2Rm1vnxwAgB6AVA8cPFcTBh6ae7qGznNtfN3sIC1bBgr6ilz/T+8cU6B3aC5T47IaJ0KSU9XNhGbcpi78ML2g9nGcYb5RiL5rn08U8xctDyhoVk00MSlP/t+WSuszjtFWDgCWnFj1py6VqLQE8QCfjOmtG+SJqRBedb67Pvaa9/YOOA+xykiaB/oPvKsqxOp3IDwA46HzRn3bmXvPXbfOFMS5N7MJf+6QeEuzOuUr6kW+ljh+c8xhp8HTDf2/hZewO4d9odd5ODcE3th69zlkMCh06FDRYy2EGhie1qwlhxYrpDFOOdhghTPUpzTt4XGcx4vzcv/9+Rzq9HnMJ+w+zTcF2IaSavdgAu2wZOInVdcdWHrO5XaeCDAt9T0tPPKUZm3az6IFit85kTfXIaPUbCMlqKk5/ot6WW8u4ruiem5KBSUpWryuuWzl3K9BLkA2j1QnVUyATE0fHanfcT9rRaxyImDaM+TQFfkMYSn0OCIAt/mX1bq+hxnQa13/WQAN44V5UU+/KwnCbXw7CpWM2OTTfYRBdETap72rIieBqzLhRBSU99UWUo2sl6n3rtYi6RKzRgf54IJoBhTw6uqlFe7jnFyiZrn2ptR+1M5IL3/ju09zpV62P6ErtsKylnhZ9RytsPFuOzYtlfvQi0G/AY2JyMBDR9oWcfsdNM9nbGJ8OSvJ9mZ6m+LJYktEEugiGES1f2gan
 zA6gewWh
 xTMXrTFEkAldc2ijBBaINWtiHPxUI9yLC1t7ncN9nrxh++G6PB10pYfWRiPLKRboevsIGuszJCfPp8GdxV/Ps3O9OKBb36B0Y4PONobZLBobBGbPKjC11l+aX/maDu6Ww9vre7GKrImDDGbmNVm9EMBj1sT22PlkTrwlqpDkLZJQMRqWJ9yox+TUqaKF1//B15FdP8pBVaY4fP7F9usoLjYz51MfP7aCfa4Scnvu0PaCwsKRrR1zCr/fpWioMc6BguUgf5zNNI6r8T1iRs74hC+VS77I0zLrACkPHXmrybUj6tiXVozPH1Q/vChXCtKejp/vYyN2AkDkyUMZK/vxJgV0LZGElaeNk6x8m4H5eAc3gKDIVL/x7QZiaBvWnKeWd/4w/L2adNZGCiySOBevgvjs9DUPQbV8jBwaOjp6yg0TvIqo4K3xDEDo+9e3KOeSndUZg+MEzgCEYSLpR8faWBP5xjPgsN7dudf9aUoBvx7lAQMhhDQ+p/XZCPy+5F0ZVXc2kUySbF1oPA7YvRWLOGBQmI9m8dMLEaHse
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When mem_cgroup_charge_hugetlb() fails (e.g. when hitting memcg limits),
the HugeTLB allocation path currently handles the errors incorrectly.

This series fixes 4 issues related to HugeTLB allocation failure paths.

Some of these issues were pointed out by Sashiko while I was working on
[1].

1. Fix subpool usage leak on allocation failure: (Sashiko pointed this out
   in [2])

   When alloc_hugetlb_folio() fails early (e.g. buddy allocation failure or
   hugetlb cgroup charging failure) and gbl_chg == 1, the error path skips
   restoring the page to the subpool, leaking the subpool's used_hpages
   counter. Fix this by calling hugepage_subpool_put_pages()
   unconditionally if map_chg is true.

(1.) above could technically be a separate patch series, but I'm relying on that
for fix (4.) below.

2. Fix folio refcount mismatch on memcg charge failure: (Sashiko pointed this
   out in [3])

   The error path in alloc_hugetlb_folio() calls free_huge_folio() directly
   on a folio with a refcount of 1 (set via folio_ref_unfreeze() earlier).
   This triggers VM_BUG_ON_FOLIO(folio_ref_count(folio), folio) if
   CONFIG_DEBUG_VM is enabled, and can corrupt allocator state otherwise.
   Fix this by using folio_put() instead of free_huge_folio() to correctly
   drop the refcount before freeing.

While fixing the above, the reproducer (I'll send these separately) was causing
an infinite loop during allocation, unveiling issue (3.).

3. Return -ENOSPC on memcg charge failure to prevent infinite loop:

   alloc_hugetlb_folio() propagates -ENOMEM on charge failure, which maps
   to VM_FAULT_OOM. Because HugeTLB physical allocations are high-order and
   use __GFP_RETRY_MAYFAIL, the OOM killer is bypassed. Returning
   VM_FAULT_OOM leaks to the #PF handler, which cannot make progress and
   retries the faulting instruction indefinitely. Fix this by returning
   -ENOSPC instead of -ENOMEM on charge failure, which maps to
   VM_FAULT_SIGBUS, terminating the process cleanly.

And while running the reproducer, I checked this routinely

    head /sys/kernel/mm/hugepages/hugepages-2048kB/*

and found that there was a resv_hugepages leakm, 1 per execution of the
reproducer, unveiling (4.) below.

4. Move memcg charge earlier to prevent reservation leak:

   When mem_cgroup_charge_hugetlb() fails, the error path historically
   bypassed vma_end_reservation(). Since the reservation had already been
   committed via vma_commit_reservation(), this left the reservation map in
   an inconsistent state, leaking resv_huge_pages when the process
   exited. Fix this by moving mem_cgroup_charge_hugetlb() earlier in
   alloc_hugetlb_folio(), before vma_commit_reservation() is called.

Testing:

+ libhugetlbfs tests pass
+ ./tools/testing/selftests/mm/ksft_hugetlb.sh passes

The series [1] has some changes that are dependent on these fixes, so I'll wait
for your reviews before continuing on [1].

Thank you!

[1] https://lore.kernel.org/all/20260702-hugetlb-open-up-v4-0-d53cefcccf34@google.com/T/
[2] https://sashiko.dev/#/patchset/20260518-hugetlb-open-up-v3-0-e14b302477f8%40google.com?part=5
[3] https://sashiko.dev/#/patchset/20260702-hugetlb-open-up-v4-0-d53cefcccf34%40google.com?part=6

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
Ackerley Tng (4):
      mm: hugetlb: Fix subpool usage leak on allocation failure
      mm: hugetlb: Fix folio refcount mismatch on memcg charge failure
      mm: hugetlb: Return -ENOSPC on memcg charge failure
      mm: hugetlb: Move memcg charge earlier to prevent reservation leak

 mm/hugetlb.c | 57 ++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 21 deletions(-)
---
base-commit: 0e35b9b6ec0ffcc5e23cbdec09f5c622ad532b53
change-id: 20260706-hugetlb-alloc-failure-fixes-c7f775eca29f

Best regards,
--
Ackerley Tng <ackerleytng@google.com>



