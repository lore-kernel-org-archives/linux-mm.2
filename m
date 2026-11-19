Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFE5E60A2601
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 19:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ton06EtT
Received: by kanga.kvack.org (Postfix)
	id 84E2C6B06D3; Thu, 19 Nov 2026 14:37:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 823716B06E4; Thu, 19 Nov 2026 14:37:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C6906B06E5; Thu, 19 Nov 2026 14:37:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4731C6B06D3
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 14:37:17 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C9C458038C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:37:16 +0000 (UTC)
X-FDA: 85452877272.06.FD113EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id A8582C0008
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:36:59 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795117019;
	b=7m8aIG96Z2OcxORxsYQEr3Bw+YKe5fZgByaho08v3oDxhDM8Tpxh93ITMIAkz/0cxRMTKO
	rhfwui2mE7iEYZPLO5iSNFDiYgRjB/LjuM2zx3+GPh04OtQU4KfI07nnna4zsX9cFK9WVO
	w40T2mXcdiTkeB/92jFzy1KxvxtlB6c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795117019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=O/ZXkIjF5XTu7eQiBKvbnoC4LxM4S1aXcMO1zwi7ppQ=;
	b=GkAnsG7xQCT1tL+neLIfSOBgor9Ju0BNGsXDO4d9wYQqUShgfp9sSAO73Ew+TJ8+IwXeq1
	E/f4AhwK77vwdB+LBm5mbxLhTqEu4Uw7qUrrKk1bw7PeHq++f1get3XpqWNO8JHH4ZjTBa
	nmINejQ8umI7n/BCy7tnM/xl6tATnyw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ton06EtT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of mason@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mason@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 01F914477D;
	Thu, 19 Nov 2026 19:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE8B1F000C5;
	Thu, 19 Nov 2026 19:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795117018;
	bh=O/ZXkIjF5XTu7eQiBKvbnoC4LxM4S1aXcMO1zwi7ppQ=;
	h=From:To:Subject:Date;
	b=Ton06EtT8gHbK6c/0HqHkaZiOGQATLUK+NZgUH5+xIzr8uD7Kli8XpT71wEPCcjn6
	 Jn3q7wQvDL3aRFOfKrcN7IgXzBoHoeohqHPJNRfj6cVrHDgGnqOp8STwi6IyLWfOR0
	 p5v6FyfcicDyJ9jXxtfYiTM9LZNE7GHfYW6A6q9+frbAcsGvQsDDo2C3sqVERPIvnP
	 7LNANE2iD79QpOyFPSQmg3NokwoPFYdKSSnoZvmEcLqE6O0dGWxPUr57LVrN0v0gVd
	 11ji14tavjIuovTYcG3CVtGayidMECvSLMpOhGiZBZsUlR8Zo8PyQk4ogkq6T10c5s
	 Cs1wRyQQtsvkw==
From: Chris Mason <mason@kernel.org>
To: hughd@google.com,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org,
	qi.zheng@linux.dev,
	qinyuntan@linux.alibaba.com,
	shakeel.butt@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] mm/shmem: don't use the memcg of an uncharged folio
Date: Thu, 19 Nov 2026 14:36:56 -0500
Message-ID: <20261119193656.88678-1-mason@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HE-Tag: 1795117019-931217
X-HE-Meta: U2FsdGVkX1/9Bl1ZHUmrDrFrH9r6oyFMT9msay6VZ1AGmeIXEhms20wGRiN8xYSHFzp9YYoTeGsEy9ymWjD9Yq7Xose/txpIBV8MHb0/OCu+ZMY2DWtK1FNA51Kij1aGO2FVy3/GU064DO/I2VhB9U5uCfSXAROnQ3SFKf/PB8mDEF82DeDZYM+drmH6EeIl1WC2zrfiNlTJBvaO6YPgc7/cAeiUcQbnYQOzwi6l1mAhjD5VWVInAq3/kcLB7sNmeZHexmthqgCwJgZQ0PBpFOlpPwSeABG3P0UJQSjvat1Kcl7BBtTYRCBJff0Bf69fRSeAn7ixNT0/ST4jUi+xtWlMc9wi3LJxh837rvczBl4FOp5pJU4u5mvvnk+VQAm4FlWOVuTriZ4NGBRCn3kYUxmIsZFbb7gp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi everyone,

This is relatively niche, but actually new with 7.4-rc1, and I would expect it
to trigger under heavy load with huge=always on tmpfs. We'd need to run out of
room in the tmpfs or reclaim memory while huge folios are migrated.

Qinyun Tan's pending series fixes the oops:

  [PATCH v4 RESEND 2/5] mm: memcontrol: drop kmemcg_id and use
  mem_cgroup_id() for list_lru indexing
  https://lore.kernel.org/all/20261105092233.3558950-3-qinyuntan@linux.alibaba.com/

It makes memcg_list_lru_allocated() accept a NULL memcg, but I think we
can still race and corrupt lists instead:

    shmem_unused_huge_requeue()         __migrate_folio()
    ===========================         =================
    folio_memcg_list_lru_alloc()
      folio_memcg() is NULL
      no lists are allocated
                                        mem_cgroup_migrate()
                                          commit_charge(newfolio)
    get_obj_cgroup_from_folio()
      returns the objcg of memcg M
    list_lru_add(M)
      if M has no lists, the inode
      goes on the parent's list

    [ later, M gets lists of its own ]

    list_lru_del(M)
      locks M's list
      unlinks from the parent's list

I haven't tried to reproduce on top of the kmemcg_id series, so that's
all just guessing from the code.

This is on top of v7.4-rc3.

Chris Mason (1):
  mm/shmem: don't use the memcg of an uncharged folio

 mm/shmem.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

--
2.55.0


