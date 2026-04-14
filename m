Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4F36F531ED
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 11:06:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32B726B0088; Tue, 14 Apr 2026 07:06:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DC5A6B008A; Tue, 14 Apr 2026 07:06:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A3B56B0093; Tue, 14 Apr 2026 07:06:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 065926B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:06:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CCA3F1A056E
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:06:00 +0000 (UTC)
X-FDA: 84656881680.12.C0779FB
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf28.hostedemail.com (Postfix) with ESMTP id 59486C0007
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:05:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=iNH3A08B;
	spf=pass (imf28.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776164759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=I92jEmAumgZ6rFCY267aGWR2wa0hUFuBr3FV+HxJgc8=;
	b=hYFq/lYvhLT25OOCNOuRbHoOUykPauyGI4OVcikdBe7tbeVXATIx1yBoC5fIixMBKeeNMC
	3+onJ8agGDmiBrIGL1n1IgilMLUEvcmixoURf3s5J0HPDkbKTWOYFYc5uqHUSZgCAlz+/9
	Y1GQeNfD60s2YJvE5kRBk7B+yGBYczg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=iNH3A08B;
	spf=pass (imf28.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776164759; a=rsa-sha256;
	cv=none;
	b=A1Bqex8SU1sOwZZez1KUyVL8tDmwUuDsFziyYBUyJl1cnSFnNl/QrV5eG/2V5AHhxB8vtx
	vbR9VcCbo30vZXeQsy+/uCud6oKxzDbRXykcP+1nc+o68/825PenqypKI7CY/fOJiMZ4Kn
	tQ1IPzI7KDnVSlvJAGfrnHS3Z7nMyR4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=I9
	2jEmAumgZ6rFCY267aGWR2wa0hUFuBr3FV+HxJgc8=; b=iNH3A08BSSQ5of74kH
	JO0tw6AZiH+i7rBX39iLvoVEap6FpzIQI/8+tMXa21QVs1pAilZ84h5J3RbEjZqM
	f3wdQdq6KzNuSPoKg6SK8/VvgGRgERNc210pktlgiIn9xdYXiPoPsI7s8ZdKXJvb
	Zdrn55msPR5wL8AfgDP06bqsc=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wBnrLh2H95pqLbvEg--.46126S2;
	Tue, 14 Apr 2026 19:05:28 +0800 (CST)
From: ranxiaokai627@163.com
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	kuba@kernel.org,
	hughd@google.com,
	akpm@linux-foundation.org
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: [PATCH 0/2] kselftests: cgroup: fix test_kmem false failures
Date: Tue, 14 Apr 2026 11:05:22 +0000
Message-ID: <20260414110524.2414-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBnrLh2H95pqLbvEg--.46126S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtw47WF4ftFW7AFW3CrW3Wrg_yoWDuwcEva
	y2yrZ7t395AayqkFZrtrn8XrWS93y7JF4aqF1qqF17JFyUJr4UJFn7Xr1UZ3WxWa13GFya
	vF9YvFyftr1IyjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRAa9aDUUUUU==
X-Originating-IP: [2409:8a62:14:edb0:5054:ff:fe85:ffcf]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbC7Rj3RGneH3iPtwAA3u
X-Rspamd-Queue-Id: 59486C0007
X-Stat-Signature: 9xajhzupisr8hfuoqgynj3im9bm5qd7k
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776164757-221296
X-HE-Meta: U2FsdGVkX1/KVT3c/Vo92Xze1DkIAW4HXOBUdIFBlgy8lo19LfsGoWIdfN/i/v+bLIHnZydvkzlOyM+rkQqGzswDzU2eqAKGr2UNYc0qhooEJdM/UAyMul5zE6yEgMyiWqcZCXN8JlV3nI2c92NUerDPFyGHB7/i6P/Gc051v7Jpk8bLBfyFShEGq5DGETQWVYr80MuYIixVWBqwsYZLLUfQDzBOSOOy8rjzhjLuJwnOGF5kLltjzJjzBXMPmG/qf4bQDD2ONu0dJdpXtKJUEuPPEk7Nx/jWPf8JNORyUa3kaxwoUBcIFLWv8mxudC57f5QXdBDGSfwKQM/nI4l5P+5mjbn7qKV1s1npnuJh5XvvcNv8Uj++fSJmr4cuGiWg3aGZRoFLD2r2GtEVwi9RYImIxwzntEuJnCeqI8TYnQcshOUHys/x2achNkxsG3OHLo3oGawr0nEwr1NiNemM0F7zdI3JzntKpKmRH1/LuY6yG9b18/TRFFOormWKR4mE3qcbgv9tHNvI+7/Ph42hf1YTLr6DtOY5RDKR5eXJUeLLvdDTbC53ULxj5XtpJ8Q7F2NXlYRt0QaLx4/o+xSltxIeNGMoPKuh8U8lxN9aWzX4nZUKROVzXdLmbGnG2PD1vv0615k7LJo/R3mbysdpkJlG3U82a5iOwMcgyT6vivlle/JkYSW2BXi0Y6kTnS5Wu0KXMgXY1OBsAie568Rwe0yX5aENA9y1au8M8zBFcugArazCeUN8mxd9xJGk8RsOP5X/hcq3od022usxkI4anEKpGGkLUkfqREasy9uG8UvWVJqsuvZOyFsYH1KNP/QxaTDZEdSLjIt3EfKsrDd+NG+4Nbi2On0ZaLfRFIeG4a34Q+9o/+9uxfyRH1wjsufQF/qpsbanmdMneJxjh/+3jvkqHsBir4N/7uiRbHGnVcLqfqyMpNFwESilNL2lSOhJHSrXOI7sl2aP+em4RQB
 Wx3R5H8L
 Tud5O1OGxeDbGN9yvSgRykOSrIBEAthWGmk1QyoBD8meBFbdFVrJvzNxw/aMz6EFLmGEDxWiDt2t7peDV35wOTOU8ekQYvjGXwg5n1GCsUdPaLZnz/HjsxPqCGd5FfuvVLfdqCF5Sxf259FvrnBZTI8A2S4sixcdoSFAzy0O1LXALuHUe/3y9axnBnyK/SSkiosCyyBdJ9ty4V7RaZLAOn//nWVmne2FbgT6OQlYO4PbGBh5TDD3n1DBcOLkqziqURa2pHWgdodajMgk2OP5nNeuo+KC0YtNRepYSCJLk4Yy1XVfhxF0v7jQNJW9aRUYrcbOX3G2LeNmohZt5GNowCwMReOra7lWV0/IjidQP5qJjateH80mIpJ0vOmDwsfRsw0YEqvIOqj9ccCGh+RuT2nW0rNpL4m64F+k4MJweZxQVSgk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

This patchset fixes two issues in testing/selftests/cgroup/test_kmem.c
that cause false test failures under certain system configurations.

Patch 1/2 updates the MAX_VMSTAT_ERROR tolerance to account for the
multi-memcg percpu charge cache introduced by commit f735eebe55f8
("memcg: multi-memcg percpu charge cache") with NR_MEMCG_STOCK
(currently 7) slots per CPU, the worst-case discrepancy between
memory.current and memory.stat.percpu has increased.

Patch 2/2 fixes the test_percpu_basic test to account for slab memory
overhead. On systems with few CPUs (<= 4), slab consumption exceeds
percpu usage, causing the test to fail even when the percpu accounting
is working correctly.

Ran Xiaokai (2):
  kselftests: cgroup: update kmem test tolerance for multi-memcg stock
  kselftests: cgroup: account for slab memory in test_percpu_basic

 tools/testing/selftests/cgroup/test_kmem.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

-- 
2.25.1



