Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71A4CCD98F0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 22:17:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD7566B0088; Thu, 18 Jun 2026 18:17:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D882C6B008A; Thu, 18 Jun 2026 18:17:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9DB26B008C; Thu, 18 Jun 2026 18:17:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A35B26B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 18:17:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 25C478CEAF
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 22:17:30 +0000 (UTC)
X-FDA: 84894445860.10.D8E6C69
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 88EB314000A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 22:17:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VTWcS6/0";
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781821048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=AgP8C8n7AzeVj9tEQoLceMS8hiFVWTMxZ605a6ktMpo=;
	b=cucWJTPPoIkiydOhX+J0fjZkZ8ycwl0Kf+XhJn6HhQ9Ia1BLha1fuiaO2uBLsFUxf08P7S
	amTuaJcIEJH5iU/HWvfWdrfCNtmd+9oXpyDpvgzlNSHmQdK77NKam7pjgBuMq+D3NL1p46
	SFPE4to8ktQLE1BGbSu1H42Ba1Dpf58=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781821048;
	b=lAoNhy6WC+Kgf2oSceRiqicQxTegQE4zOt1GsM0NU9KeunnKY1bnlDkk6GRS9YTFN03y2s
	YYY1XuQ8TJrCJgRd6gVIRO8YXbpGDOEeG2ESkAzOX7j1GK2vSw8MnavlggFRL/H4I38dtw
	xNS0iL9Lamy3Bvw+ErlSX9i+xNMqheo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VTWcS6/0";
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7503842B7F;
	Thu, 18 Jun 2026 22:17:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008B11F000E9;
	Thu, 18 Jun 2026 22:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781821047;
	bh=AgP8C8n7AzeVj9tEQoLceMS8hiFVWTMxZ605a6ktMpo=;
	h=From:To:Cc:Subject:Date;
	b=VTWcS6/0u0fy+q51rOfIGax1ATe4ygJ57UTUd6PSyTMWbQXGk8rY0qko1kWIXdpHz
	 TIc7iBdWexOB2m8XhOcfP4e6l/pxd7nPTUioJ9sTwEXWGEGU0+6j0I70hR/F2jiuZK
	 H7JhZFpARdupH1w+p3UqZsfUfqoXlHoWmlr0t2nMi5i8pjYzznlACT3wGxAi83k3Bn
	 uVmyPB67Du3FmAGhx8aH7Rt5JFm7lJUyjqJcwpLSJrtsGMxGnsEhz7S6jymSOtHdNV
	 EW4CykmPtNAvkeP34eO3aYOL2i3s4A0AqhG/ZV6UASfxSP6qQwU5zwbSRtoCTd090A
	 PsXnbeN8lxLBQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	"Barry Song (Xiaomi)" <baohua@kernel.org>,
	Nanzhe Zhao <zhaonanzhe@xiaomi.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>
Subject: [RFC PATCH] mm: Avoiding split large folios if swap has no space
Date: Fri, 19 Jun 2026 06:17:20 +0800
Message-Id: <20260618221720.71768-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 88EB314000A
X-Stat-Signature: 9yjy4s3bwr83f1uymtwcsig84xc8ckdb
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781821048-401127
X-HE-Meta: U2FsdGVkX18ZIhkmO63D9nXb2KhLQ0yDVBj9xeRiLk2sjgKX2dNBt/VuNET+p4dbbkwcHg4zYciv8sF8l1zBX/hV7ftsvmpUir1oa93o4FyHxeArNOJvXZ/Mu+9GlLmcJC/lV3YJeC1zym2sqDhu/SwC2O8sf4bFixhMalIFrWAIg/OAZ6mnY8iSx0DXbKv6NdR9QfctvWQLyNpweaTUg3qdfzmq+h2oct1UbUpw+zOWGwwfGfn+zF3YCyndsJTtYO6EdehzaB0GYAIhRgaJ1LbTwfA9VlM7O+dINwd01cd9CeYR3r7GKSq8kD+p8G8Z0Y/z6CSS2IgxlkZBe8bLok+KzmdjVmOkg1xHSzYczyZVEaUNa6WuuxCGIY8ENqJldI2hJgU9MvHu3O1ghebP9PTcbnjad1m9BJ3BBn79NBUpKSHKeCcTczj6ZR145TxsTlTr8IIth/wA7hwhXCiu9tGdKlF9koDVx5fgvSYrwv7gcaQY+I31h3NSF5f0jt72/5KP7mVZTOQIi8nofSgUeZKJrR0XUlhCaMc4+uDKRQ4QMg+4iHR1L0EMExI64IZt2/ZhQvZf4w8XZFQmuFRnpyMQgmMni0tMQHYGZ+whvMakZMT4Ywsv+Ml8GpzKam3Wm1jQKN5UXXMx2ui7oXHbPxqhrqdhPeNmcB/saF5QTeazDy/W8kNKbXM7xxJPz25zuc40SfWm6SD/8refuvG/BWnCyQoVGEgOo8TC0GY5f1CLhZ1UfYumeUWZ3cxr2JmbW0Nv8GLyrTaeI461QqtR+xPH3qBxtGAGBYGAa8FEER0JDhjsjCfj1QkxdwMTlXMOmmyjojHXjMKdToohY7Cpc0yOT3oeFDI3EzK5XSb0N6ItlQ6v8ENOrs6EnWA4BX7uovq468nyT28ZJ43hR66vRrz4qsBFcnNx0HHw3NGWufEXvRDTiUii3VWROeEjz4XTWkkuW93/fxpaXIdcra5
 tIIXTAO3
 jKqH/u8Yp1dHQj/gpxWzjbaMHss5svIEaMOrWazzU0axFbTMJ8tQyLoE8bW/k0vZDixias/HjSeVib1GT590IkNOOUVBnHzGajOzVpaJilKiwEgDWpyRNtFhITSXXrOCM7yvUnw9uPgWWHMaNdcWWpvLkpdZXyFEPLPjRUf2xFURDeChABu9ihkTrOTI8a5dZxgu0Z2tQOdKv5qNoX2bPZd6eoPXZNYG3iFL1qUMulO0bpXmTmbTe9n549fcVKIXB1x/FgpERYU52W+XMxSVIu1pO5UZL5S0zcCG++O2ybdSkSCNYlQTSsjC67OBMTxiAoYpDhMXOihq63zptgxb81qbqRdj8KsI0CWjbnEGxBDw5dop+JDstb3eTPrVWs1pXKZ/s2IcxNZ2IkUxxaKudS8tZLGZdGI8pEbfcE0zJ0pQ11pblRijOAbkc3ZWbnsjD0DsLaWNAGQRBCg6YOZJfYoVtTOavu0nXZvL+chIRk8WMFnI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When swap is disabled or exhausted, swap slot allocation
may fail during swapout, causing large folios to be split
into small folios. The splitting is reasonable when we
truly fail to obtain contiguous swap slots, but it is
pointless in the no-space case.

A simple way to reproduce this is to invoke MADV_PAGEOUT on
a system with mTHP enabled but without swap configured.

 #define SIZE (16 * 1024 * 1024)
 int main(void)
 {
         char *buf = mmap(NULL, SIZE, PROT_READ | PROT_WRITE,
                    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
         memset(buf, 1, SIZE);
         madvise(buf, SIZE, MADV_PAGEOUT);
         munmap(buf, SIZE);
         return 0;
 }

With 16KB mTHP enabled, we observe:
~ # cat /sys/kernel/mm/transparent_hugepage/hugepages-16kB/stats/split
1024

This patch checks swap space before splitting. If there is
no available space, it skips splitting. After the patch, we
observe:
~ # cat /sys/kernel/mm/transparent_hugepage/hugepages-16kB/stats/split
0

Reported-by: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 299b5d9e8836..33f84a5fe7ee 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -339,8 +339,7 @@ static bool can_demote(int nid, struct scan_control *sc,
 	return !nodes_empty(allowed_mask);
 }
 
-static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
-					  int nid,
+static inline bool __can_reclaim_anon_pages(struct mem_cgroup *memcg,
 					  struct scan_control *sc)
 {
 	if (memcg == NULL) {
@@ -356,6 +355,16 @@ static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
 			return true;
 	}
 
+	return false;
+}
+
+static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
+					  int nid,
+					  struct scan_control *sc)
+{
+	if (__can_reclaim_anon_pages(memcg, sc))
+		return true;
+
 	/*
 	 * The page can not be swapped.
 	 *
@@ -1280,6 +1289,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 
 				if (!folio_test_large(folio))
 					goto activate_locked_split;
+				if (!__can_reclaim_anon_pages(memcg, sc))
+					goto activate_locked_split;
 				/* Fallback to swap normal pages */
 				if (split_folio_to_list(folio, folio_list))
 					goto activate_locked;
-- 
2.39.3 (Apple Git-146)


