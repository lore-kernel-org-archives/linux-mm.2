Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 406A8C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 07:48:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCC4C6B02EC; Fri, 14 Aug 2026 03:48:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAD926B02F1; Fri, 14 Aug 2026 03:48:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE0C66B02F2; Fri, 14 Aug 2026 03:48:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8871A6B02EC
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 03:48:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 751B41403D1
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:48:12 +0000 (UTC)
X-FDA: 85099096824.17.C2895A0
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf13.hostedemail.com (Postfix) with ESMTP id 73DA020002
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:48:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=YRZOO0yd;
	spf=pass (imf13.hostedemail.com: domain of mambaxin@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=mambaxin@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786693690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FIECsLjOcFQ4t6j1nI62wLXm7hufJJ5ekbHLc3/zpck=;
	b=b26SSYQDH1IEageyLScmqHDV40HdFeixAqBdGeNPoXU4oB+upQVbbx5WL+6bbK3bs3qdo4
	iA6rOsh3p7B0bA0TShODRXQzBvVFd5+V0BI6AWGxpzMcHE5TTG+3Ji6eHUaPsxYa1niUhW
	x4BxTGznAhVmTUjW6CbyXVpZwfv7D9w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786693690;
	b=CQbvS2I3uWecNmPXo/42Hm29qHp3o4513RUBZUiLUcUFtbOTYPayeuNZkG6Vs8opvhfVYI
	ci/kR1KdGWXm4ZdCwHSI9iEXqJplX/3/q/M9egufhYzlHQ5jmyd89ZHErWU23QcoPzezSn
	bQDTioj+KDKDF/4V4P5u6MzgxgNwTRs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=YRZOO0yd;
	spf=pass (imf13.hostedemail.com: domain of mambaxin@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=mambaxin@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=FI
	ECsLjOcFQ4t6j1nI62wLXm7hufJJ5ekbHLc3/zpck=; b=YRZOO0ydDBW69njRGY
	i72odduzj/kBXY3UjVmE12Y/HVkUzkv6i0HbItjmIN9nNpy8Zq88417ZmcgzFySx
	k32Oys9K8tYfL0uLw4tgWee5YWaOgtLi75uR3eVWoT0CKSNKZ5P1KE2biH46dA7a
	E1YDqEUmmfRCbnl1AkArUP8+I=
Received: from localhost (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wDX5yYOyH5qLnA+Ng--.54207S3;
	Fri, 14 Aug 2026 15:47:29 +0800 (CST)
From: mambaxin@163.com
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeelb@google.com,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	david@redhat.com,
	v-songbaohua@oppo.com,
	hughd@google.com,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	jose.fernandez@linux.dev,
	stable@vger.kernel.org,
	syzbot+e12bd9ca48157add237a@syzkaller.appspotmail.com,
	Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Kairui Song <ryncsn@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Sasha Levin <sashal@kernel.org>,
	chenxin <chenxinxin@xiaomi.com>
Subject: [PATCH] mm: swap_cgroup: fix NULL deref in lookup_swap_cgroup_id on swapless host
Date: Fri, 14 Aug 2026 15:47:06 +0800
Message-ID: <20260814074705.939721-2-mambaxin@163.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDX5yYOyH5qLnA+Ng--.54207S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxZFy3JF4rGr17Cw1fAr17trb_yoW5ur45pF
	95WFnIgryUGr97Kw40ya40ga48ua1rWr47JrWvk3WY9a13Jr15WryI9F1UWryqvanI9Fyj
	qFnIyw1xKw1jvFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jShFxUUUUU=
X-Originating-IP: [153.3.251.220]
X-CM-SenderInfo: xpdputx0lqqiywtou0bp/xtbCwhFwemp+yBGO2AAA3C
X-Rspam-User: 
X-Stat-Signature: e8rmuoaxtbu51sfke6ufihneq7rhqcyj
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 73DA020002
X-HE-Tag: 1786693688-897429
X-HE-Meta: U2FsdGVkX1+yG37Ti7aqpYc4LLCY9IheXKElLLhU5p6+Zp9HTh6xFdOqDv8gYCCzcLyNqd44seESdSaSK5jmty+3l5q0Hh5Z/qphkG4o5rts7o+yLnWrkWQbZuVUmbmjNtjavdD4JOpj28pBmNEhlUk3bBeHJtE2PI2/8TjcTGMa3+ZsgUBFAW8XoH8E8l3tCK2fYzqa/X97q5KAN9GIMLnBxqprKnwYX5ZCaX5Yn8K8qtvUiZFnt3eE2p+/37Nv9Vf3NW2Lw8d3IdcRfu3aXoBRj3EeWt152yNi2gfiqfLTIGTsjZ36l1SS1XgEmpQb0ZLoGzTMrYOukglADB3biR7MofD7cdwQtTyGUmweOjqFhRK752O3K4r+H48eUrcsC4aG5Xi3CGd9zRs2Lm8n6gKvpaK7wwYRLIVZ1aJZ15u/mul4eCL2ELlapa2STaj+YroH1pQXN5ointdX7sM0BDWr0I6NeG1FLpVL+LfKC0wdHwd+zk/BO+16+aMEpjR+K++XQvNzYfOZ2kfE2bjqIRSuCsmJr4cyMz4+OzOL1aVqTiKKn8x8plpJ6ia7yFQGRJqlbpnLRxnQzBcPsPKyuD1ITj/wp3i+8y821GBJg310o4v96Q9wCTRNGCvwO1DEcGUhHP53nf5QLL/VoQ6Dpgt21p2WaTc+voYp0hmpBKSgshOl/S/WCGzujxdoysBGtMk9Zg133bsF/0MNcFxnX/8yDVTmiAmC1zxeW4bgCE5mAgUZV67i2QSPAeooaLtNg0cB/ft+7fwHGJaGt0vY1gv3ZpG4h5Z5zHFngmsXY3RdS4nQKFheVhoj5lHTCIJ/Ypxjhn+hIR9ygV3BWHTSjMIbgHjGQBFcNlO0lVOjjNEucEQskjDEENIVSLCNx1r6ZgKETJM0VodfcS3aFZVpp1ImJhWa2jSTxD6UD6gFiD744sQJfbFHW+RwLCJbSr5qB6usgaGSoH+lVM8cR+x
 MiOb9F/m
 zs9dOr8u6g+vtbFuNrD2g6w3VovWvQA4bz4YYFsLGBGV+3XjFsdx0cIabi/4Sofoj/cZgt8FnMWyJzyvQQv1sMJJ/OPA17c9SKyHzj48v3785PvzweIwWZgq6jgCdX3NUBK9u7HOloID5w05C+EB0iDJHgU+hmkFVOldTK3CX/DUqL/StUHp7GiHV3xPDYaOfQmWCzLDG0wPkxhPFt1MwtCMC3H1MTb+hob+v51exAOaRKNvagBGPAUK1jyQcpLYUuOvLmTDk+7e47u7YhU/jXvsBa1CawsSpiWRtNWryIQBTXaNpk9baWrgJ/BrusDAik3KfMLLxgy+WHHrg9ARerI0y/zjPPDohV7SP+DKGTplDbEjWMkay8sizZ0KCKTGC8+00FgXASAQJ/JA/qcpqJ2KErOUW1ffj+MYwDbu32ZgegVgkmPQ28AbbLWJp1poEAkV6rNtyMtduEKP8pczCDvFqe+dEhr404PikWllZ/pFL4RtMcKBkREzb7GEvcHVZ3enCspnmRGIu8C4kl305rIqS8Tni8LnTFmCGBmiutRU4Cnfwp1FDwnB212OSqlGjmktK/mFgi1v7xPsf10naYZOx8LezdqlqgKHm4jFeakC7b99TU868SDFFhPWi6hvuJEDoquPCusmFpf83C2JMKkxsLA97FbgDd+GA3ZWauszk+K19bm85PQG1U/zJ7yZMupvBs+YYAowW7rzI5jajQ/U9Hq5W5nNOwg0sTwSiyJWwAK7anyw5s7sMVBNrrGbN0CjIGqESZwtO55SvttnogJM98FuBoYSjwpnZ3g5SaSoGaWJ/SEOmElm0v8ttEYOLAPg6L6mGtWyKX2E4OQUNoRvKoa0LRKKhU0tUdtjOOIUyWxrtkLvMaPRCrP6NWNEsPzpDGcA51NV5+3E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>

[ Upstream commit 63b02a9409cb5180398491b093e48bcb5315f5fb ]

lookup_swap_cgroup_id() passes swap_cgroup_ctrl[type].map to
__swap_cgroup_id_lookup() without checking that the type was ever
registered via swap_cgroup_swapon().  On a swapless host every ctrl->map
is NULL, so __swap_cgroup_id_lookup() dereferences NULL + a scaled
swp_offset().

Since commit bea67dcc5eea ("mm: attempt to batch free swap entries for
zap_pte_range()"), zap_pte_range() -> swap_pte_batch() calls
lookup_swap_cgroup_id() on any non-present, non-none PTE that decodes as a
real swap entry, without first validating it against swap_info[].  A
single PTE corrupted into a type-0 swap entry takes the host down at
process exit.

We hit this in production on a swapless 6.12.58 host: ~1s of
"get_swap_device: Bad swap file entry 3f800204222bb" (do_swap_page() being
correctly defensive about the same entry) followed by

  BUG: unable to handle page fault for address: 000003f800204220
  RIP: 0010:lookup_swap_cgroup_id+0x2b/0x60
  Call Trace:
   swap_pte_batch+0xbf/0x230
   zap_pte_range+0x4c8/0x780
   unmap_page_range+0x190/0x3e0
   exit_mmap+0xd9/0x3c0
   do_exit+0x20c/0x4b0

syzbot has reported the identical stack.

The source of the PTE corruption is a separate bug; this change makes the
teardown path as robust as the fault path already is.  Every other caller
of lookup_swap_cgroup_id() is downstream of a get_swap_device() that has
already validated the entry, so the new branch is cold.

Link: https://lore.kernel.org/20260504-swap-cgroup-fix-7-0-v1-1-f53ff41ee553@linux.dev
Fixes: bea67dcc5eea ("mm: attempt to batch free swap entries for zap_pte_range()")
Signed-off-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
Reported-by: syzbot+e12bd9ca48157add237a@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/69859728.050a0220.3b3015.0033.GAE@google.com
Assisted-by: Claude:unspecified
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: chenxin <chenxinxin@xiaomi.com>
---
 mm/swap_cgroup.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/swap_cgroup.c b/mm/swap_cgroup.c
index db6c4a26cf59..2d0425f4a6b9 100644
--- a/mm/swap_cgroup.c
+++ b/mm/swap_cgroup.c
@@ -161,6 +161,11 @@ unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id,
  */
 unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
 {
+	struct swap_cgroup_ctrl *ctrl;
+
+	ctrl = &swap_cgroup_ctrl[swp_type(ent)];
+	if (unlikely(!ctrl->map))
+		return 0;
 	return lookup_swap_cgroup(ent, NULL)->id;
 }
 
-- 
2.50.1


