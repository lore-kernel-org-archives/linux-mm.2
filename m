Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C46260A3814
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T2DbxFm8
Received: by kanga.kvack.org (Postfix)
	id 73EE36B05E4; Wed, 11 Nov 2026 18:26:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F0236B05E5; Wed, 11 Nov 2026 18:26:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DF646B05E6; Wed, 11 Nov 2026 18:26:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2517E6B05E4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:26:56 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AB209140410
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:26:55 +0000 (UTC)
X-FDA: 85424425590.03.D44DF20
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1BC201A0005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:26:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T2DbxFm8;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794439614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yga9lSt0N2iYoO/IWogbhsbus+a8FaK6RxnbOTa6a14=;
	b=jJblMwU4H56xU4uwIoJmhSBKATi1+QNapjlq0ZXMXtULcWj55NKtaRCfUIS+ZBhC0C538B
	H45no0Yd/9qEg6cfQ/Ewg5k+C5/nM60gYo3HdrM7GZ72/BZjFZ8KWZSEcOuXh8kwu5hncw
	a8UI8RIu/oj/auQiA8eg6veZn20fokM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794439614;
	b=u/OEaxTbCCDd7Mi8Wb9cuJ5Lp5/Oc7EQZg+MJ1qG1wF4rm6nRCuzn0WGYc2U8TCrJhRmq+
	NRvTyHa5XZu97n2RtzxEvn7bR6spVqlSke98iQulse9QLeMtmyuPfNjfYJbgkxQAXmum23
	6u3ZoRLmwfCtYmgThLBPEC+tBduXeqc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T2DbxFm8;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6CA434725C;
	Wed, 11 Nov 2026 23:26:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CBE71F00A09;
	Wed, 11 Nov 2026 23:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794439613;
	bh=Yga9lSt0N2iYoO/IWogbhsbus+a8FaK6RxnbOTa6a14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T2DbxFm8B/38ftFE4KHgA1cFkAKwzxgym8BqNSIQ2M4ZXR7b764u55gABF8o8ZkiW
	 T1gRnA4sFmp447XAzRTPW+vPJq6JGgkA32DHVRKzftK4n1ZjK8YoWvEFVMbCUF6pcn
	 GU3BUMJ/izTQ/O6d/JJtt30qeSlbvjaw91U1DoszdK3VGrkeB5T3MRKPF47wMmxVsk
	 aSH3bpesiEjjqTaLCwqTLsv5db0SRLgnlXrA1Ytd9zbWAJV/DjlE83YVotthQqmdGQ
	 B+FA1O2T2u6D85nzMCzVtehdkBt3EcaTkRBB7CaBZAfBpKkpIQNLg7ANrK0Zo2Dupz
	 5d+5fN/M0l0Og==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	hannes@cmpxchg.org,
	hui.zhu@linux.dev,
	kasong@tencent.com,
	kunwu.chan@gmail.com,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	liuxiang.277@bytedance.com,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	ridong.chen@linux.dev,
	rppt@kernel.org,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	surenb@google.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	zhuhui@kylinos.cn,
	sidchintamaneni@gmail.com,
	Barry Song <baohua@kernel.org>
Subject: [PATCH v7 08/16] mm/mglru: lift youngest gen protection for higher priority
Date: Thu, 12 Nov 2026 07:25:55 +0800
Message-Id: <20261111232603.9934-9-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261111232603.9934-1-baohua@kernel.org>
References: <20261111232603.9934-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1BC201A0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 1q3wbsicmzizosjzk5ywob8djxbhurff
X-Rspam-User: 
X-HE-Tag: 1794439613-633478
X-HE-Meta: U2FsdGVkX1+My8hfxvfNhkbAEo+LpiKH9xcNUHHOB22mVgGM0pQpzK5/KbX3S5jgm1mBErBQVkl8LwtVhhwWEjJssOakV75XPr8eZ04sLXGKSc3YKWazTawJC2lJt8nJsDGm9IFKoLLGIpwlMrbsWoesMzpA+PPqgxD9lGUKaxoe83R8F0X2cpa/OHralL48Hp/et/BatZLSqdtmiF7TRru6yEUaz3hV5tr88BLCjzuFecrTN2tKeAtBtxBwnkBe7z83HiaxrxDS3SZ8aUELBvZ4NyQ6c9pW1aY48Q5incox1DLEzWPTxhEKyM7j2pp4TbvJQucdlEVUmx5n5TBujPG1OZHMTmtCnv/sY2q0qfu69GvVLA+LN8M3NTLBlD6cDhN/w+EIAu1z0AvUON/XLdrgQ49sRPc6tE+gvqXEHE5unisgRiHwTTTJbZqa/FuRD0x9MrmMPq590HVuz8ux1IvniCvE+taH6OO0YvE16SlPK9bpdHZbjc5KXwlb6GMO4oqfHyhBV4nQvICFJ82WsyG+geo35LDgZ6AK50MbTJCIYPddrFvpq4Ua6qSJF4cqn3UP7URYcgzBFgPUfxqxgvxzPbnVAYF0Tpq+Z63YRu59D1zU8AoQpD/EoJeu7KmGHoBNmZqUt9nxm66B1YsgToe5GhFABCa02y9IRMFXnAoppoPrzxau3It5odFsbvqbie24bH3pi17WupzXq5Gs7mpOYQ5rBydk+6GhSTHwDv9EzR6fDvjHjjb61hEGQoHEeu4jOX37KXeMQ7sJHqboaKSl9tUsEi6HOI4/fkWNyBIXYM6A1bvDsWjrVZrN04tBziG/UCMfyiLYXskMtiePBfX9/SQ5YUg4VYfY9hLo2odr0FvY0ngiE4bFJfRynbudpCDSNOjHaa/rRr6TUZSyLGJQR11oIbLo7aT5FysrEDNBn82v9oLPSBw0PIvSCnb2ejo2n4+hEl/k3DePppD
 8NGi1pvf
 Baaw9qPG2EBgXT0RA5xtUtEjJi5DxAzpU5VlDGkv3oNh8gn6IlZzmZPH0pfNk1vxw5mADX3JkhE/Uu6mTK/2TkUxw+78kAlgdgZTMZnL8OqB9bKUVqxzoZ7nhNRg5I1FgV4eB8g6/oSUU9xfByflmwWzxGa/OuvnIvrliwyXmdZhAGHZEEQrXGA+6LxAzR+gX0u9LKpYzEwIF3B8qsNXr018ige0bvddv8ybyI9nd+rgohQZrcRUfzb7gk89oOEu1iLejVrM4s6Xrm/A+Tu2bHqizTRFxpg3rOLHRqlYeO/FI4IDvFiEm42JCR8opSAOGxgpQz3KssKumZoPSQPZ86c7jXlYwL7GjkPGJNtDxiMnx+KE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

The forced protection of younger generations contradicts the
goal of minimizing the I/O cost of reclaim. Under high memory
pressure, MGLRU can repeatedly trigger premature OOMs, while
the classic LRU does not.

The problem is that aging may fail to keep up with reclaim.
When this happens, reclaimers may all abort prematurely
because they see only empty generations or just two
generations remaining.

Proactive aging does not solve this problem either. The
number of threads performing proactive aging is limited,
while the number of concurrent reclaimers can be much
larger. This is a fundamental limitation of MGLRU. One
possible solution is to use an aging lock. However, the
aging lock introduces significant jitter under heavy memory
pressure and has been reported to cause noticeable lags
on Android.

Furthermore, the generation-based reclaim model can
conflict with the goal of swappiness, which is to minimize
I/O cost rather than blindly follow folio hotness.

The previous commit allowed reclaimers running at
non-default priorities to reclaim up to `lrugen->max_seq`,
while reclaimers at the default priority could reclaim only
up to `lrugen->min_seq`.

This patch further refines generation protection based on
reclaim priority. At the default priority, reclaimers can
reclaim generations down to `lrugen->min_seq - MIN_NR_GENS`.
As reclaim priority increases, reclaimers are progressively
allowed to reclaim younger generations.

With this graduated protection, premature OOMs are no
longer observed, while swappiness is also respected.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
---
 mm/vmscan.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 88567002b7ef..fff7ee17eb0d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4767,12 +4767,14 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	VM_WARN_ON_ONCE(!list_empty(list));
 
 	/*
-	 * Respect the gen hotness distribution at low priority to avoid
-	 * aging and scan cost, but prefer to satisfy the reclaimers request
-	 * when under pressure to respect swappiness more and reduce IO cost.
+	 * Respect hotness at default priority, and only reach into the
+	 * newest generation when under severe pressure, so hot folios are
+	 * not evicted as soon as priority is raised.
 	 */
 	if (sc->priority == DEF_PRIORITY)
-		seq = lrugen->min_seq[type];
+		seq = lrugen->max_seq - MIN_NR_GENS;
+	else if (sc->priority > DEF_PRIORITY / 2)
+		seq = lrugen->max_seq - 1;
 	else
 		seq = lrugen->max_seq;
 
-- 
2.34.1


