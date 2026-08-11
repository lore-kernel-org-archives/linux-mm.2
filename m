Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26554C5AD7B
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 03:09:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E875A6B009B; Mon, 10 Aug 2026 23:08:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5F916B009D; Mon, 10 Aug 2026 23:08:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D755C6B009E; Mon, 10 Aug 2026 23:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B717E6B009B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:08:58 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4F73A1A0326
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:08:58 +0000 (UTC)
X-FDA: 85087506756.05.0F2FA3C
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id 37DCDC0007
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:08:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z7i1XOOk;
	spf=pass (imf28.hostedemail.com: domain of guopeng.zhang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786417736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6RU1QcglTKSplI+6h+9d2ONdsvNoRJa+0z35rhprdP8=;
	b=QRlsJNTSLtxMDdCBGDuiorUeNCAUvmP/VLhnzfqlHOJCezfKojcXNwdWFeFQSPw4mWjZAe
	tfdJKOTzbYMEo3Y48At2r3PqyYvPdl6J/mNplQ89VvUNxjefunjam18c5oWJtWfTMBs6/E
	M34WZUyz1j7raFqU5AJeuCPkVCB5qTY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786417736;
	b=LHl6imhk0kNCE1zTg1TlIiRIdA5WcbOgwIlCsEYcYmnevHHe4OSrn1Ozlee8/BG4T157Yv
	lkWgSaIN2+FcQj3Qz936+tONMgnVbxXp7dIOSUL90ynpcIF53SyypNQ/UxdDFGmeSNsCQl
	qOn9fygPWs4208678GU2/8zkM/IxDy4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z7i1XOOk;
	spf=pass (imf28.hostedemail.com: domain of guopeng.zhang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786417732;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6RU1QcglTKSplI+6h+9d2ONdsvNoRJa+0z35rhprdP8=;
	b=Z7i1XOOkFFAUellA3NV7lMdxMXnkv4B5/1E1WrWvNwTIf7s+0fgOl20XIMzJpjCbsdMr19
	l8PvtayKaT6f4jbWCJF+wqLEy/9tsDYpRDTLSmfok/0Rbebn1m/09lu+Y5cfjazRWYWzx/
	++iU1n3QmmKsS9NtWMjZiSZq/3ULpkk=
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	akpm@linux-foundation.org
Cc: roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v2] mm: memcg-v1: fix memsw and TCP failcnt accounting
Date: Tue, 11 Aug 2026 11:08:43 +0800
Message-ID: <20260811030843.109104-1-guopeng.zhang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: xbhrq6s1u4an9s9qm5ujyyazzukzt69w
X-Rspamd-Queue-Id: 37DCDC0007
X-HE-Tag: 1786417736-478533
X-HE-Meta: U2FsdGVkX1+yfy8HmnTJmm3G/HQaWAbUP6HsMOyulgF2eMRLzdeGzwelQ1Y2wSQF5nrlKhTqI4RQpJxLNOwB8W2QuR6SwmK2f7RFEnIAV80B1yfU2iy8C64T53bxQ6gxe4W+HbDXVgZn6PkjW97FRHDYYI8nvGaPKDAkoDiqZxLDf7YFfrSENDt/xxGbd472mabPSj03M32fObGSgcikVzxCHb9iFrkdvysqqlM5Z3duQLwcF8X2k57SUbhm4bemK/W8z66iPd4l4cpDOz9unUs8j5R9++N2H4J/XZDWCiS4Alv+1kJMUGFKDdo+zFmxVANd6Z8P4kyMFG+4TNdC7NDc5jsbuZfPCzDhTPjpm6PYzgZf8a/M4xJy7TLPf6mvuhC4Q1Xlmhcm5E1SvKQesdFv+qrLB3GLVEE53gAzh5GAx/xhsQoD5uyRCrzRoFlcu+zCzuMFG1PBlPCJd2Eer2z+1Vx8zhOO0XglwgQF1pEQqgwH+YRyR8B/CAP3TnoKyKP/dY+uE4hWrkFmAgFzx93WIUhkz6aNpEvyZhL7lKlQnjuvgdbDPTEwjLD8gyEjM5SaucBzg8v6Sg6Ok50P4R0cwPvUifuOi1YbmqX9+jLnsQB3BqzMO0DQE4qyFmqQ/gUdmcv/LdAaGoM6sUjdERD1SS/vikMHirBgv3Xi6AEOOPUJYClP5jiooITMop/58Qud6IgCkCBrmxWLfBNoiqKFwtHX9hrSF78BnlBYZ0H9LrOJ9foRUPFp0L5vx8Te8p4oqX8Mz8mzvD/Zicbnu3JoQkTzvPlF8D69Mo7/L3xLLb+LfmH93VHVhTJ7AT/f2/2GqjzIu4Hv3yZGW6Vx9uVrjJDfGrUGRW+0fpnI/9pPKFdYDkUHE82X/OfoLm9Y8vpbzGdi4Y205pwt0g4WcisIankNZ2/5WuRDiTSt0GkBCujWraBBarbRzPk9K4UllktHvwDM4/u6o9zjXGC
 4+XyvibQ
 AKOyb4aRNu2Ibq0MZz47PP1DzoftnJ+zCWLHWtoAJdFpoXWanIpC63w5RYoCDk60lg31w2kZ673sDMH0KpU3vYCloHscLQ6/ZHBbFCiewjmDpswHkRDZAPywVQlVVBq5732WozekMlrTO3IYB+8CLi7vBtgahWerQUfKuEJ1F8NtR5jzm4fxOFkGnsIVf0GSpdnb+LtujQwIwM9hV1XWxFxY5Q3CK1anLDmmrWWcxNgTxQXOaznX5TYaUL17UqilxNPb6j2vBlvWbL0pDWZcInogDm+HoNNl4NG6zRwEc68s7GaM34WLtL7Ly10Jn/Y/Tb1meaB32/XaeKYJGR/ZbiVJoxvszg9imn4C+yKUGJK8iEKSMPnTzQyOHHEZbI4+Uk9FxuGoM2rgpH3fOPHKGtBo5UQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

Commit 0e2759afcaf9 ("page_counter: track failcnt only for legacy
cgroups") made failcnt accounting conditional on track_failcnt. It
enabled the flag for memcg->memory, but not for memcg->memsw or
memcg->tcpmem.

Consequently, memory.memsw.failcnt remains zero when the memory+swap
limit is hit. memory.kmem.tcp.limit_in_bytes still sets
memcg->tcpmem.max, but TCP charge failures are not reflected in
memory.kmem.tcp.failcnt.

Enable failcnt accounting for both v1 counters.

To reproduce memory.memsw.failcnt:

    CG=/sys/fs/cgroup/memory/memsw-test
    LIMIT=33554432
    mkdir "$CG"
    echo "$LIMIT" > "$CG/memory.limit_in_bytes"
    echo "$LIMIT" > "$CG/memory.memsw.limit_in_bytes"

Start a child process in the cgroup and make it allocate and touch 96 MiB
of memory, causing a memcg OOM.

    cat "$CG/memory.memsw.failcnt"

Without the patch, memory.memsw.failcnt is 0. With the patch,
memory.memsw.failcnt is greater than 0.

To reproduce memory.kmem.tcp.failcnt:

    CG=/sys/fs/cgroup/memory/tcpmem-test
    LIMIT=65536
    mkdir "$CG"
    echo "$LIMIT" > "$CG/memory.kmem.tcp.limit_in_bytes"

Start a child process in the cgroup, create a TCP socket, and reserve
1 MiB of socket memory with SO_RESERVE_MEM. The reservation fails with
ENOMEM.

    cat "$CG/memory.kmem.tcp.failcnt"

Without the patch, memory.kmem.tcp.failcnt is 0. With the patch,
memory.kmem.tcp.failcnt is greater than 0.

Closes: https://sashiko.dev/#/patchset/20260810074247.52747-1-guopeng.zhang@linux.dev?part=1
Fixes: 0e2759afcaf9 ("page_counter: track failcnt only for legacy cgroups")
Cc: stable@vger.kernel.org
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
Changes in v2:
- Enable failcnt tracking for tcpmem as suggested by Johannes Weiner.
- Add the memory.kmem.tcp.failcnt reproducer and test result.
- Update the subject and changelog to cover both counters.
- Add Cc: stable@vger.kernel.org and the received Acked-by tags.

Link to v1: https://lore.kernel.org/r/20260810074247.52747-1-guopeng.zhang@linux.dev

 mm/memcontrol.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 70806373d5a9..17da1f43b7d3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4235,9 +4235,11 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 #ifdef CONFIG_MEMCG_V1
 		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
 		memcg->memory.track_failcnt = !memcg_on_dfl;
+		memcg->memsw.track_failcnt = !memcg_on_dfl;
 		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
 		page_counter_init(&memcg->kmem, &parent->kmem, false);
 		page_counter_init(&memcg->tcpmem, &parent->tcpmem, false);
+		memcg->tcpmem.track_failcnt = !memcg_on_dfl;
 #endif
 	} else {
 		init_memcg_stats();
-- 
2.43.0

