Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C9E4EBFD03
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 06:49:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A00C06B0089; Mon, 13 Apr 2026 02:49:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B1856B008A; Mon, 13 Apr 2026 02:49:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C78A6B0092; Mon, 13 Apr 2026 02:49:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7A3B76B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 02:49:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0BAC7E31CD
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 06:49:19 +0000 (UTC)
X-FDA: 84652606038.27.18AF015
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf17.hostedemail.com (Postfix) with ESMTP id 391AB40006
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 06:49:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=GGVCDxLE;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf17.hostedemail.com: domain of create0818@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=create0818@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776062957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zfduVNm09jkIhQ0je1BjJHQXUBdHMcI7s4tD6ILgtWg=;
	b=3YCbHs4qUWHZAOlmXh78nYjEVCBbuatztlNCo30X07U5JPBf4z2msETIPdWFYGbRiHNz/T
	PLFRQsYeeLeLGSwlqBo349yOerU9/RvXANqDdBxU3rfzJ4O3MOK/iURAXhiMz/H/j9Dbw5
	/p9wZtj5swZ4kbEluNuUxLvotTx+Jzs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776062957; a=rsa-sha256;
	cv=none;
	b=cJRSKD9Q7uFiImdyhxhHXotGLz7kUtn9yeRP7d6KOd/xUfZTc4W9A8xd8f6dtSJO9hwaey
	T9n/m82NfqQBIAJ4evC0rrDfFHuZYo91DwiRZEny57ZDK5QHqksJV7ZTbpgZDA802M1R9F
	40kECq3yEtBtsrLJBM7mEBRD5VkKzH4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=GGVCDxLE;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf17.hostedemail.com: domain of create0818@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=create0818@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=zf
	duVNm09jkIhQ0je1BjJHQXUBdHMcI7s4tD6ILgtWg=; b=GGVCDxLE1P+Yqxfwm0
	FIWfflqakXtJXGvBj5M29AMd6A4wyG0laUlAIqT1BMsEbBAMSb/fftCbrEHJfjc6
	Ydr1Ma6Y7jXFibeb6nMLZKmx4V1sZMWotyiGtzDVINCgr83aITaNHvvalup6G6lk
	LJwZV+XFVS3hssr2Dtm3TABk4=
Received: from localhost.localdomain (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgC3oOrOkdxp7MvIUw--.32984S2;
	Mon, 13 Apr 2026 14:48:52 +0800 (CST)
From: Cao Ruichuang <create0818@163.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Cao Ruichuang <create0818@163.com>,
	syzbot+1a3353a77896e73a8f53@syzkaller.appspotmail.com
Subject: [PATCH] mm/memcontrol: restore irq wrapper for lruvec_stat_mod_folio()
Date: Mon, 13 Apr 2026 14:48:33 +0800
Message-Id: <20260413064833.964-1-create0818@163.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgC3oOrOkdxp7MvIUw--.32984S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxXF45XF4UCw13ur4fKw1UGFg_yoWrAFWkpF
	4DKrs5C397JFyagF17Xw4qy345Z34IqrW5ZFWxWr4fZF9Iq343Kw1DKay7WFyUuFy8ZF4f
	X34jyrn3Xa1jvFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zio5dtUUUUU=
X-Originating-IP: [39.156.194.234]
X-CM-SenderInfo: pfuht3jhqyimi6rwjhhfrp/xtbC5xQrZGnckdRsXgAA3+
X-Rspamd-Queue-Id: 391AB40006
X-Stat-Signature: jtznmakreumfhmaf9s3abxd9nmszguu3
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776062955-152016
X-HE-Meta: U2FsdGVkX18ZNJfYbW6uQLoOeGhQJDkcoDgi2SzmzeLZGw6NxZBkE6u+gDqlTb/Tb6NeMzH+KMHDie2XE8QTFEhe30l0pTHH2S/20P+tpi/FkOj7QjuBTVg3qpr/B+emA57AQggxSXa255SOd1blDRDsC0XmWysgcO1pSJDWnjM10b/mvh/23PTtLH1PL0xnOioBLl635QRinTSwxTKDBJMRbPL2DTZ3YwrjR332Odvslh7RZ1tnvvld+kUqTMpxDrpuDhqf0x0UpmvLD+EfF761hbQRr/RMPKRHya2wfogzoBEQ43iNWcTTKMl5H4KzkhlsURuxsX9jStTyiOcfTZD4k0O8Qlep9Zqpqg1h0gpxJa80kmxyaKlM3xq8d/R0QeG1A3kLMQfW+sOEBS9E2WFwVxy0PVKthhFFaiCiWyEeqaYKKyOUPRAEF9/Ch+i6BuVYykM7H0GIEnU2V/9d8ODFB9tCcaXGxBbFripxSoMmw6hsI45jNks3ApiT/j+fJ73sAG0Fjo3zVh6ABM9EgpHCHNANlvoMkdf6TDB1TXMCYLFVy/Lz8pkQ/Qxdd9Sb8fjJs/w7Oj+JFnjQkXtJNFhjpwuzOcq+aBOwOwU16P4mOu0tiS4waPU7+00lAdbiHdcHWHz0PjfkgXa8+S1efjdPdiODRTHow8F1UDZoDIZ+Kyem7mrChfpn04eix+/yOgIjIddm8qfX/qpsyYdWyjcgG4QtscvOa+St30KEopaRJb/SU1U8yl1D5qwXmx4fi6WSXEx5o2eUBZNwib9Ebc4EeggbVLhmCJSZBQs8JMBvyOsz8xd5zV3uX2B1CmK5B87RG8iPDo/wbr7pWQLaBruPK+GPTArrhcJi3WZd2Y88+vti6z7WUTwWixs4newT5ynbldge6EGKmMng4ACItlG4byoKmcC1vQ8ysPgM09xmzF0TQGM7cXFSnk1M/K7cErmygkEANKV3aIEmYIa
 W0YQm6w7
 F+Gwf6SmZzXxs0S8SCzLPZ002l3hxRv0qqCUDIr3yt2eb6eDFWkR4gp4SFAs1FGBM20eHt9KosNTGHLkRZdrmejiYRYiZZQZkR0IKNTPiT0u1oV4J6X1F4hc40ZrPwZJmofS4OahPu9VFf/RuqgvRkSD5dF/JeuOyu+vs7ML2udhI2A+QOQRCN5j0ZMk5Wi54QHeHkB3wuRKRwfHCEAkKFAvPQNqqrFTn4sozcDAUBj7kR5UXQwhTxpIiaqxvBZoyjohla2t03a/hIK8Yn7gM5L9cQexGxh1iQoV+kKBEa240cHcIDgWlPodHVP2B+mCGOiAxTR5D0GYGEuHXHjAONR5bfnR5txNMg7mhs8z1ix3RPxRmWQm498Ha4YF0Ve23a5941jq4hSNuJSwRQfaAz1fxcBujbiRcdeoJMftLEB+lB6N3umZaKRa6aMTkqFCgGIMx1gQ32cGitTaiJPbz0Sckih2gWBtv0E5j4B0RGSQ7+d+pn0/iCh/t5DyJHZkMEAPBrNTg72Z1TrbSUmMGvBShT+7fDicFlLBNHzWyT3IVDnYfjo4VTsJRLLigs79gCELyfqrOgfqz+iiiR+eRYCMoTprptwKj9aRQ3nO5omIMbj7DDFJQKv4LvIkFXWpnH3mq/esij6FTzhonOV13epAzKIfCIF9cETaG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit c1bd09994c4d ("memcg: remove __lruvec_stat_mod_folio") removed
the local_irq_save/restore wrapper around lruvec_stat_mod_folio(), based
on the assumption that the underlying stat update path was already
IRQ-safe.

That assumption is too broad for lruvec_stat_mod_folio() callers.
This helper is not just a thin stat primitive.  It also resolves
folio -> memcg -> lruvec under a helper-managed RCU read-side section.

syzbot now reports a PREEMPT_RT warning from:

  __filemap_add_folio()
    -> lruvec_stat_mod_folio()
       -> __rcu_read_unlock()

ending in bad unlock balance / negative RCU nesting.

The PREEMPT_RT detail matters here.  The affected filemap path calls
lruvec_stat_mod_folio() under xas_lock_irq(), but on PREEMPT_RT
xas_lock_irq() maps to spin_lock_irq(), and spin_lock_irq() does not
disable hard IRQs.  Before c1bd09994c4d, lruvec_stat_mod_folio() still
provided explicit hard-IRQ masking around the folio-based memcg/lruvec
lookup path.  After that commit, those callers no longer get real
hard-IRQ masking from either the xarray lock or the helper itself.

Direct mod_lruvec_state() callers do not have the same problem surface:
they already operate on a stable lruvec under caller-provided locking or
caller-provided RCU coverage.  The narrower regression boundary is the
folio-based helper that combines ownership lookup with helper-managed
RCU.  Restore only that helper's irq wrapper instead of reverting the
lower-level lruvec state update cleanups.

This restores the previous calling contract for lruvec_stat_mod_folio()
without changing the lower-level lruvec state interfaces.

Fixes: c1bd09994c4d ("memcg: remove __lruvec_stat_mod_folio")
Link: https://syzkaller.appspot.com/bug?extid=1a3353a77896e73a8f53
Reported-by: syzbot+1a3353a77896e73a8f53@syzkaller.appspotmail.com
Signed-off-by: Cao Ruichuang <create0818@163.com>
---
 include/linux/vmstat.h | 18 +++++++++++++++++-
 mm/memcontrol.c        |  4 ++--
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 3c9c266cf78..59cf2676649 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -519,9 +519,19 @@ static inline const char *vm_event_name(enum vm_event_item item)
 void mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			int val);
 
-void lruvec_stat_mod_folio(struct folio *folio,
+void __lruvec_stat_mod_folio(struct folio *folio,
 			     enum node_stat_item idx, int val);
 
+static inline void lruvec_stat_mod_folio(struct folio *folio,
+					 enum node_stat_item idx, int val)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__lruvec_stat_mod_folio(folio, idx, val);
+	local_irq_restore(flags);
+}
+
 static inline void mod_lruvec_page_state(struct page *page,
 					 enum node_stat_item idx, int val)
 {
@@ -536,6 +546,12 @@ static inline void mod_lruvec_state(struct lruvec *lruvec,
 	mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
 }
 
+static inline void __lruvec_stat_mod_folio(struct folio *folio,
+					 enum node_stat_item idx, int val)
+{
+	mod_node_page_state(folio_pgdat(folio), idx, val);
+}
+
 static inline void lruvec_stat_mod_folio(struct folio *folio,
 					 enum node_stat_item idx, int val)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 772bac21d15..ffe6ae885f5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -787,7 +787,7 @@ void mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 		mod_memcg_lruvec_state(lruvec, idx, val);
 }
 
-void lruvec_stat_mod_folio(struct folio *folio, enum node_stat_item idx,
+void __lruvec_stat_mod_folio(struct folio *folio, enum node_stat_item idx,
 			     int val)
 {
 	struct mem_cgroup *memcg;
@@ -807,7 +807,7 @@ void lruvec_stat_mod_folio(struct folio *folio, enum node_stat_item idx,
 	mod_lruvec_state(lruvec, idx, val);
 	rcu_read_unlock();
 }
-EXPORT_SYMBOL(lruvec_stat_mod_folio);
+EXPORT_SYMBOL(__lruvec_stat_mod_folio);
 
 void mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
 {
-- 
2.39.5 (Apple Git-154)


