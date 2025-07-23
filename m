Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79FF2C83F25
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 07:25:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC14E6B008A; Wed, 23 Jul 2025 03:25:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D71F86B0093; Wed, 23 Jul 2025 03:25:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C876F6B0095; Wed, 23 Jul 2025 03:25:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B8D7D6B008A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:25:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 468641A05E7
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:25:02 +0000 (UTC)
X-FDA: 83694692844.12.C62BF79
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf16.hostedemail.com (Postfix) with ESMTP id A2591180004
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:24:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=QdigMd9K;
	spf=pass (imf16.hostedemail.com: domain of liuqiye2025@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=liuqiye2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753255500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=alAlhSGmTebtA+3jJl/XuXa6tRwN7fz4ebxMMcEAbo0=;
	b=dxhhGSc5PgaJwUEKq8aVTv3FA/I1llHU4C+N/Jwlp0vz6ptnDw8JKKMnjpldgpLvQ+TGEV
	cKOKGLnVPVjGVeO6y0Krw0cE6j1t05TXDWGyFuWbz9mE/W+sMLwvxAWt/VPk+8mJ5maP5O
	Lz1v6JntYO0kQ8Ou7A1CC2kdCJb2gZ4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=QdigMd9K;
	spf=pass (imf16.hostedemail.com: domain of liuqiye2025@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=liuqiye2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753255500; a=rsa-sha256;
	cv=none;
	b=y6LxXjWtn+oWodJcJccY2yJmUVEmviPRuE5qACN3KWJwIph7Q45DsM9AqEsKa2TNbWTZpP
	5vLAKVyRv+K4zYl9G6QVvQKLSBWrCqYUNPUSIpMybZdShfI9HDDAToPikEaqioXjD2Jozy
	E3Fs/Wufdbw0OMfMmHeDYDTr98hZdFk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=al
	AlhSGmTebtA+3jJl/XuXa6tRwN7fz4ebxMMcEAbo0=; b=QdigMd9KgZnjRkjc05
	6F5nGWWzm+u8YBMd/RB8iSmjZFZ9/fUzMwqydf9R6yRR7QjE9GQm+HF6i8RI0FTz
	l4bKRD9rPgVPZk7Vn3JWx7SNvRXHmiRxTIcn2Wr1iLDSZ1qVMyrtdscz3c5FUw9K
	r3QpqzLMSswaj+NqcFCLBh4y8=
Received: from ly-pc.. (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDH_5sKjoBoILM2Gw--.26993S4;
	Wed, 23 Jul 2025 15:24:03 +0800 (CST)
From: Xuanye Liu <liuqiye2025@163.com>
To: Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>
Cc: Xuanye Liu <liuqiye2025@163.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: add stack trace when bad rss-counter state is detected
Date: Wed, 23 Jul 2025 15:23:49 +0800
Message-ID: <20250723072350.1742071-1-liuqiye2025@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDH_5sKjoBoILM2Gw--.26993S4
X-Coremail-Antispam: 1Uf129KBjvdXoWruF1UGF4kZFy8GF1fCr47twb_yoWDtFc_Ja
	ykX3WDWr45t3Z8tasIyF13Xry0gwn8XFyFvw4IgFZ3ZF9rAr90krykJF1kAwn3XFZ2va4f
	AF95Xw12kw17AjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRi66wtUUUUU==
X-Originating-IP: [223.70.160.239]
X-CM-SenderInfo: 5olx1xd1hsijqv6rljoofrz/1tbibg6TUGiAiYZxyAAAs9
X-Rspam-User: 
X-Rspamd-Queue-Id: A2591180004
X-Rspamd-Server: rspam06
X-Stat-Signature: zk5h88jmmmf4pkzkuqt16fmr4x8ipwqt
X-HE-Tag: 1753255499-37700
X-HE-Meta: U2FsdGVkX1/uyTXbWS54KxEnoI6C0lbfrZEdvpPfClIlcRYnErHepdEchGPKynOxR0ciubyhahQWVOj3XZsqwqwBSz4vve4uDdnvSu5mLx9ajYBI3rX0eMh56+TZA2DVQiUuZlN3tx1H1Gr/ANRofYJaYTxFeFlZziyr5r6qL4Gk7g2iHP1V1X09dBTHdv2ZiKsBj27u7eWu+nTwB5Y62CNDYeoW9I5AAytEVSe4yToMnrR3yr8vPQtBBx7Vsb33XsAvQ3ZiGp8GpWxxlPM6xFN5jEb1sRp8HFbhl2qpY+5LKNZnjaOzaL+RqPNz84Yg+wYGLyaQvpGr3xtraMzkefB4UfCx128PE3NSew9hVejp5pXrOgg7uGLZuSm+6UieiFyLYmFZ/Eoo/QTjhuXX4ZQ1Jotgnxc1Fj58vTgAKZvYMt2MPssYtLYh8FZDnTcyY5xOD6szBBXzsR6TrabqMNKSBeZtz2csDoQI5s4UHuRP58Zp1+2HGzeHyUZw02N3pxuKlfdkSfuduPosTzxOFJp6MnQF7g0eCSjY/su+zQ8zttBKDJ/VLXjFujHFCadqCbOir6Vdx5sqxTVRuaXT5TafA7gkfeVT7UO79BO72kmga5q+6DKuIHg2t7U0EqiOrFgGgffpGpYeCmFJvkKosR4lZuFMEDZh+by5bpy0cxTLKY/EAjGcUcSCWQzI2q9chJ88Ix6IOyL8hfx/jkPS0FTLDP1/aB9g3gkvw8hNbUlpKHn63VzUSACimSVUtiXBpPinbo+ayNerBTyVZ8La3aCAB7CnLilcZKKTsk+3tw1YhCWjInzeGVGn0KVWDNs5dnjJZU1H1GWCdZhT2F5Zu9U+qpi0sCaI1pWXx8EdIKMorE0Zziv7nNk//06Yu+nupsWDkC82zyci2tqlRZzebV8GzI5xHYQWsxM4J1XWUqKmdeCtiyT51oaNyy8zLact74IpH9QZh3nbsBslltd
 6b+chKBl
 atNXdcEhGIRD3LVOR75QMxo8HhQpOhHfza810pzcjQQV8IL69hSCVtUxWk/bWEzGn/T/4RsOvLw1tSlxIzlUkJArFrukOnjYlxPxdxa+h4HmcBVO/IYeCY4OmZE2EAO7XkAOsx0GlnBpfZnPc5B+0NhXBdya/2XXq/I/fsUU/GuOm3fU9rEPZORwoSR+bl3KbHElvdkFskcPElcA4xfwJWIk3lnBz+uHiGN+8f4VgMAwi4CaJfKaDBkBGiCA27P81Fh7TnGIy6uequt0coopjrbS/PQCahKKf7Qw2rmgTQInV9gYnuKNb6YVxejEtwOHActjFNNp6nxkrngvwFxwXhNsIZaLjd/mJ7UB9G5lHXn9OJwVVtiN0LNFd8Q0M7JYT9+I7AgNbq4Jy/0WDJt0dPHy5EO5bb9p8GT8nXXlyyxpCDHk6b5ryRCOS2FVNMpxTMcfHpGCNy/fzMM4k0/F6Tti/CQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The check_mm() function verifies the correctness of rss counters in
struct mm_struct. Currently, it only prints an alert when a bad
rss-counter state is detected, but lacks sufficient context for
debugging.

This patch adds a dump_stack() call to provide a stack trace when
the rss-counter state is invalid. This helps developers identify
where the corrupted mm_struct is being checked and trace the
underlying cause of the inconsistency.

Signed-off-by: Xuanye Liu <liuqiye2025@163.com>
---
 kernel/fork.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index cfe2f1df5f27..d38f1c5270ea 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -584,9 +584,11 @@ static void check_mm(struct mm_struct *mm)
 	for (i = 0; i < NR_MM_COUNTERS; i++) {
 		long x = percpu_counter_sum(&mm->rss_stat[i]);
 
-		if (unlikely(x))
+		if (unlikely(x)) {
 			pr_alert("BUG: Bad rss-counter state mm:%p type:%s val:%ld\n",
 				 mm, resident_page_types[i], x);
+			dump_stack();
+		}
 	}
 
 	if (mm_pgtables_bytes(mm))
-- 
2.43.0


