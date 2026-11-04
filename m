Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0635E606A337
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UjdubPzx
Received: by kanga.kvack.org (Postfix)
	id 1F45F6B05BD; Wed,  4 Nov 2026 08:02:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AAC36B05BE; Wed,  4 Nov 2026 08:02:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 094A36B05BE; Wed,  4 Nov 2026 08:02:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CE33B6B05BC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:02:16 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4E1081206C7
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:02:16 +0000 (UTC)
X-FDA: 85397449872.16.129A1F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2398D20002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:02:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UjdubPzx;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793797334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wtaEY9fzrvK18OFaBVNKZjtlPWkQZVD0YtOAcEkaXqU=;
	b=SSAqvQTBjIo4DsQ+ZQ7tDQABFKcdFjuXaiPwbqYaAMWE63NnPRaIKObU2GT0GB9fX4DFq4
	bfU23ru82Y9aj9PkBAYtEOTLxukDC+l+ZO2129siaimKgWPZaak3UP9RIwXMO43jvziLv5
	aiUL1ohLbxil38SB8UUdk5cEFnvih5o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793797334;
	b=bYv/1WCypZGzToKNXkx6qtEPA4hM1bHIwpbiOxXEf5jSsYzPzfa0wUX/5OBLLiYfEN9bUd
	j9NOEgpw145c6LY6M5z2xVIKLBk4jRTQrl+g+PL73kyxj545nr1jRLUa/6DPuG/L3Pk2K4
	qBQZiogEoqwd8waoo0C79v1BPgxttBU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UjdubPzx;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 76729408EE;
	Wed,  4 Nov 2026 13:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468AD1F00A1B;
	Wed,  4 Nov 2026 13:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793797333;
	bh=wtaEY9fzrvK18OFaBVNKZjtlPWkQZVD0YtOAcEkaXqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UjdubPzxWUENBUWnpdGCjAz3BrV8kE2psrWVzL2IQ4QKhJmFJRJwU5WZffzD6NnWv
	 9eCl7wHhW4WtfpHoMISs0/Cc5piO5Hngfol+Kk36ddl7STal6r0otZsHLyU2DLbLNZ
	 a0Gxsw0R/qLSWv7lACV+1SypgZ1J9BzqZjY2w8oWLI0+E5OSKcNhqkxd2oIe4NS7ZX
	 1CnjNQdo6HfXv8SV1iILAtfwt1amZPh4P45D1cXm3KBObe9YIGUYtvvcK9U4Gd2ni9
	 eSXB0jV8S/uW0UAkcUGZ2gMWU0jmiq8mmmI6tLpx/V7TezoGkcwgTIKaqAiItwByLD
	 kTnKC6VH1ubKw==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id 223F91980054;
	Wed,  4 Nov 2026 08:02:05 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Wed, 04 Nov 2026 08:02:08 -0500
X-ME-Sender: <xms:zCzraoUzuUuUvLSrLoLQGjthj3YhcIDRLIsJ6a-8TW8Xj0kgpSiLdA>
    <xme:zCzrah2BnS0w3ZwXk2G3H2Oqrn1XSrsp3xvYPdLCcaBVgqfN5ZINgFMEOnDUSohxH
    91vZFj7nrSkI29PWXSkrGVfogy3dvAYm1K-rYVsP-ZueuAa60sDIA>
X-ME-Received: <xmr:zCzravBWGD-LvUCp8Ls_bpS2FprfcTAnVaJblNXsvZFzI8VormaGwKnalS8>
X-ME-Proxy-Cause: dmFkZTGcnWxWNdwzviArTqwO8SleswujEAoF3G5cAnzgWuj9VIXYzVn8L/YtSSoCVpDQCx
    AFAjkaMBKJDECegKseyQPi3BoJ2ULdzgEWHQh0kOOdV3qcZ96T5qYw8zvnYBduU6y+7gOl
    ju1hRqdfaUd029Zpq0M1QKVfvNYpVJXA03mIXM/FVYF2n1TVZdGxcwDBil6kVRafbiJtv0
    QuPNDwYksKVrYzT4QGS7HIxmz8ayVgiPQk5G9zoQji1nSBMTr/zV+0QH6w0a9BT4L54N+d
    cRhB7KhKgiZgmWNJc1G8l9d+gvjQ75B75nEIsy2loqzEXGvtqjUcmfJ5UhZu2fDzNX4RUy
    yqjtDl07aOkno7b+BsV25YMs8FGfUFhvSdF5CmrEF+BRAEDNYtPtZEBdr9GzYYz5Ir4xet
    VPeV7zR4ju5b/gbBIrfTW7xlWNbV3ueMqogm/EC+7NxKoY7/sFULyIgJg3hyPDqDWChsuS
    q+CBo44bPpiYd7kiotB279FFCnODiwC/N6vBH59I2o1Kz7jpjpFhNxyQqNyO45Cso9f1hC
    yKmqmPr3GJGD3iUbhSJZeXvBgzfElr2HPXLruTw07ZlkIKHpBQg0gx//7jenADPMGHPZS6
    HsT39bw2z0v2GjfOZgdRWiyEjGKJzyZbL0FFAyn46xMPSueILkJ0xJ07WOGA
X-ME-Proxy: <xmx:zCzranDAf8JKcZdHGDXZaSKMq27-My5VExBF_835DWWDKBDUhzQ5tw>
    <xmx:zCzrajMeotNceECQJ708Qj-5xU_U681zY7khqT0Ka9PNTZx20t64zg>
    <xmx:zCzrajzAhRmTgneRpMBdbLtX_UKFAcz7ad0K4O9-UmbSz11o38OWAA>
    <xmx:zCzrann7eI_g9sy_CgHj7HLy8kB1eTh6BEGSmC_PNCHYOinq22_nSg>
    <xmx:zCzraiAO2UyLzrsnocZPShhVaIhKZsLXM57tzqQC-MOeFhbhjfnyOUul>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Nov 2026 08:02:03 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Harry Yoo <harry@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Ilya Gladyshev <ilya.gladyshev@linux.dev>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kernel-team@meta.com
Subject: [RFC PATCH v2 07/18] mm: free the pages waiting for a grace period before isolation fails
Date: Wed,  4 Nov 2026 13:01:03 +0000
Message-ID: <20261104130118.2507513-8-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104130118.2507513-1-kas@kernel.org>
References: <20261104130118.2507513-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: aq38siko4eb99jr5oyei49waa5oz91c6
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2398D20002
X-Rspam-User: 
X-HE-Tag: 1793797333-680266
X-HE-Meta: U2FsdGVkX18mGuk6zDRkke0gSnLA0VyT7HD90/bPkOFS5uLS0l4T4r+wnGgM0crPpim+6KnztXEpTdAW6uGZ0i2nlAkhf1AYb1J7rbbmFgXuCjHwbRM02bEcSukTvKMRmEwx/6nxiamzOH756JleGYTYwI748XNjZryf/wVqI0fc0jre3/ZEm8ZuM0TtMLfzrVyKc1qLsE0NhvL6WtD44I7yXBTeiKrEIV9EhKqEWoi0Nz6w+YxhO50m9zh6B5u4NB076XlXI/PpwHIMc1GKdvGFF3T3gyZj/+or83dH3TzxeJIUSybTlw7N3IhDtNTe07T2Uoj5/+L4CHZqEtMFcT9qa3UV7agtb5ljy3yuGi/irDvG9qdI5hAK2gbowgYSh2vmEJdVSFjs2KAK4RJfw2ZBSlNYMCWhi32m/nL7Zc9CyZV42Ry+TvyuTtNwXimohGOfBl7D2ERtlkVDLmy2g15X9NHMUn9/1IHDsawBSmK/Y/fBQfHaCX/qx6CV9RVncj6xxgPedS4OppBf8xJ6WD4kxv1EznBI0c9H4BViL1isib7V3Q0Ecy6cv/cGd2L9gQRz+g3HnTuZFnBZF0rJSLzJ583//K2A0T4pKRQNPu1JGLci0a/Jv4Aquq7S5hbpOYTRqzFvTQ0pSp3XiEv/y0f1hAp+Ibhe8o3DY7eZJlo0Wzg7PZ318n8LU9JslDQ7qIti4Ck+iyissC9Zv2QUpFAoRHuZgkclbh54dY2lKNH2Gg74mdxRCvOddHYdBgJEy7PlzyKOX21b0+46aVrmDUBG9MsCRmh7ke4xd1amxD5iPJ8CGq3mNX8eYAAmAUhHZg6feqRQ03L3ZsOZy3a7njJC0+37NCu5+lbaCAxoZDkwHDAMiYArs1G0EWA67MGKHAJ0YfIST2bGymQzqMTZ0KJooL+tjJl07WYbXALCAij8KX+d5M0ywOnd8E+kMAjCjvJlwp+AOfr43pQrEqz
 YmKdQOTh
 BbeSvnwxvPcMWho0rh4KG3aTqXf8CrcNXUr9CAZnT5m8qJgmepnjWDY41eQjGUel9Sf2bVw/I/hH/988ZhGvJ21PFozg06KhOlfqhQCfPvh3fVK7WjecDvBKoP/UK/TPbcIjHDVRfaEHmyAXfRZdYCepYohb7r3pNOtH9j4Ot4UXXcMxWLYeBEqLnyfCry1lc8km2IVgkw560+r8xZlOitrYtNusipGWIRNQ5/u+TvkoBUvEaUVStwlQmflY8I+ayqgM4km4+jykzuy/c8I50h2+xSkILOprt4tLI3y29IBtA655iWZSXjhgmLC2PkWRrw9uSvBorMMkCuwUAkv+ully1Ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

alloc_contig_range() and offline_pages() migrate the folios out of a
range and then check with test_pages_isolated() that every page is free.
A migrated folio that had PG_rcu_free waits for a grace period after its
free, so the check fails.  alloc_contig_range() returns -EBUSY, and a
CMA or gigantic page allocation can fail; offline_pages() retries until
the grace period ends.

When the check fails and the zone has pages waiting, free them first.
alloc_contig_range() then finds the start of the free range again, as
the freed folio can merge with a free buddy below it.
offline_pages() does so only after a pass that migrated folios: an
offline stuck on a busy page would otherwise start an expedited grace
period on every retry.

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/memory_hotplug.c |  6 ++++++
 mm/page_alloc.c     | 24 +++++++++++++++++++++++-
 mm/page_alloc.h     |  8 ++++++++
 3 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 226ab9cb078a..c23fab652957 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1967,6 +1967,7 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 		.nid = NUMA_NO_NODE,
 	};
 	unsigned long flags;
+	bool migrated;
 	char *reason;
 	int ret;
 	unsigned long normal_pages = 0;
@@ -2050,6 +2051,7 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 
 	do {
 		pfn = start_pfn;
+		migrated = false;
 		do {
 			/*
 			 * Historically we always checked for any signal and
@@ -2071,6 +2073,7 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 				 * out
 				 */
 				do_migrate_range(pfn, end_pfn);
+				migrated = true;
 			}
 		} while (!ret);
 
@@ -2092,6 +2095,9 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 
 		ret = test_pages_isolated(start_pfn, end_pfn,
 					  PB_ISOLATE_MODE_MEM_OFFLINE);
+		/* What this pass migrated can wait for a grace period */
+		if (ret && migrated && zone_rcu_free_waiting(zone))
+			rcu_free_sync();
 
 	} while (ret);
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9caaa57bf51d..eea287ab2a01 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1479,6 +1479,19 @@ static void rcu_free_drain(void)
 	mutex_unlock(&lock);
 }
 
+/* Free every waiting folio, including those a work took off the lists */
+void rcu_free_sync(void)
+{
+	int cpu;
+
+	if (!IS_ENABLED(CONFIG_PAGE_RCU_FREE))
+		return;
+
+	rcu_free_drain();
+	for_each_possible_cpu(cpu)
+		flush_work(&per_cpu_ptr(&rcu_free_pcpu, cpu)->rwork.work);
+}
+
 static void __init rcu_free_init(void)
 {
 	int cpu;
@@ -7649,7 +7662,16 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 	outer_start = find_large_buddy(start);
 
 	/* Make sure the range is really isolated. */
-	if (test_pages_isolated(outer_start, end, mode)) {
+	ret = test_pages_isolated(outer_start, end, mode);
+	if (ret && zone_rcu_free_waiting(cc.zone)) {
+		rcu_free_sync();
+
+		/* A freed folio can merge with a free buddy below start */
+		outer_start = find_large_buddy(start);
+		ret = test_pages_isolated(outer_start, end, mode);
+	}
+
+	if (ret) {
 		ret = -EBUSY;
 		goto done;
 	}
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index b9259deddb59..764e3f43b3b9 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -235,6 +235,14 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order, int nid,
 	alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
 void free_frozen_pages(struct page *page, unsigned int order);
 void free_unref_folios(struct folio_batch *fbatch);
+void rcu_free_sync(void);
+
+/* Whether @zone has pages waiting for a grace period */
+static inline bool zone_rcu_free_waiting(struct zone *zone)
+{
+	return IS_ENABLED(CONFIG_PAGE_RCU_FREE) &&
+	       zone_page_state_snapshot(zone, NR_FREE_RCU_PAGES);
+}
 
 #ifdef CONFIG_NUMA
 struct page *alloc_frozen_pages_noprof(gfp_t, unsigned int order);
-- 
2.54.0


