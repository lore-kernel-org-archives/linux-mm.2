Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7585BCA0EED
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 11:49:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10C6A8E0041; Tue, 19 Aug 2025 07:49:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BD348E002D; Tue, 19 Aug 2025 07:49:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3BB08E0041; Tue, 19 Aug 2025 07:49:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E437C8E002D
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:49:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AD6B81A06EC
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:49:52 +0000 (UTC)
X-FDA: 83793337824.09.83E75FC
Received: from lankhorst.se (lankhorst.se [141.105.120.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0977E40003
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:49:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of mlankhorst@lankhorst.se designates 141.105.120.124 as permitted sender) smtp.mailfrom=mlankhorst@lankhorst.se;
	dmarc=pass (policy=none) header.from=lankhorst.se
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755604191; a=rsa-sha256;
	cv=none;
	b=COlotokW2C0eajhGtubD21PG6SeTxCXvtVkhBkM8kIYxtQV3jQMSqpwyjx5yC+Iw0QD2My
	smgYXG8/pVmRXyYMU6ogb3IDlnH0QtOWlCyE5plTeVPaqyrvDgMy3cgPMAWmsnoztdHNiF
	A53DEijgVZqGd8dUPRauQmb4Voh3+xM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of mlankhorst@lankhorst.se designates 141.105.120.124 as permitted sender) smtp.mailfrom=mlankhorst@lankhorst.se;
	dmarc=pass (policy=none) header.from=lankhorst.se
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755604191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JY/HvuaJdUspUl7ct0ZcoVl8DlrvUdAVYH2hpYANZ74=;
	b=mZoJPH6WROYVecpWZOUTmxZhsny5H3Z7tLxX+Q2lvMaGkiLJtvFZ/1DX8Aa00YVcvN0P4e
	JtjMs/1gxdF/8Aj3rjY6sUHg7IphWOndUo0zi/ANUoNNNYNDnbSMloCD3ninwCGhLWJmAd
	wMsBBlGJo/HQR4gezgfS9dmNxkB09gY=
From: Maarten Lankhorst <dev@lankhorst.se>
To: Lucas De Marchi <lucas.demarchi@intel.com>,
	=?UTF-8?q?=27Thomas=20Hellstr=C3=B6m=27?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <natalie.vock@gmx.de>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?=27Michal=20Koutn=C3=BD=27?= <mkoutny@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"'Liam R . Howlett'" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Zimmermann <tzimmermann@suse.de>
Cc: Michal Hocko <mhocko@suse.com>,
	intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC 1/3] page_counter: Allow for pinning some amount of memory
Date: Tue, 19 Aug 2025 13:49:34 +0200
Message-ID: <20250819114932.597600-6-dev@lankhorst.se>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250819114932.597600-5-dev@lankhorst.se>
References: <20250819114932.597600-5-dev@lankhorst.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0977E40003
X-Stat-Signature: i5qrwgbdhgkdkmthyzodjjke4zrcxk8k
X-Rspam-User: 
X-HE-Tag: 1755604190-261146
X-HE-Meta: U2FsdGVkX1+YgCk+oLwsfwRuBvoJRSK1LIJJLOmFv09rXaXex6QEKejVwtyrfS+/5EUsPrnJym9Sg6B4Wz3/226Rn7y7MUk5QKNwnKvtXGMQQrkfBqjjElXHoecXxlT2Op0H129hQyQhw2yP+r6fRKpOHMBMMD8E6uhrwoT98XUldEjzr6NfUpid7dNqvddUwiydAdyWrH8YrmMZp8PwWNURcPCNKHqO+Vtf5ihqD8XM1uivZ0VdH9YlO5xgOzw6RPvOgbvRXyIxk98rLFcYWiftAjUw0gfmGZIgUFugeyw+qeI0nqklf2GudeEMQrweJQQk0+pldjwHE61eJ6SwvCe9xRyEaqWrMQ0NhLXOnaoJGbwvMVV0GP7S+jIymuwK9bxN1W8AVAqwkOlYDI9f6EAHkMOcTicxFqCMCltBxyZhXUVPolKhCXUniuDENDOP3qd2N1fISqNjMdfNIpkBaETrWIek6MkSyRzLqeyw1sAwRhyN+4dB4GCGbLMIkvAYacqm3sN/0uhPzBQ9w2t23MrAzfkgt3yEWMTM6VdvPwxUFz2Fo6qoBhJ3lJ/OTSYeliC2+VCe2z3XIR0PgJU8NRmKusdKSMiAGWdoFwOmPBUhisg9sY6pILIVi2xxQD9dteVKll0QsgyLIyEF/hS3j4PaH7Vu2ctV+QoTh2RTh6K5B8PwXIaavn8bmna+6dfijeiTq9PkY5xV1IF//gLaHL8RiWP2o2C+xLqYdx5Fvg0bvA3I3vGGvs5sNWfTofU/dvLX6NKH/1p4a8J4+IUdYrJG1xv5vUm9nBy8CIrz9vxONiFYZ8azhSC3sC0vedGFLf98BWQ4RrAxCHX0Ag8cDpWz3D2WMaM4CrZJh4sSvXUwZHEGQ2hZokob+COa4MtxMCfGDyM3VvdepuX9SNr7PwPDXFZ7HvryufyJYX/b2IElIIrG2afOL7xXCeJAnBYuBWXPs+kjuosqLzOODLf
 DkKqP/ma
 wehEoNk+UDsSHL9ZKyBO5OaQ9qVSoVJyjz3e7+vcxevFygC1MYmlo8e/Bb7n8lZ0H18iTjibVfsymdgSmanPof2eZ0jZ4Rrxx7wmbNn8VTtfZj+6UOkLqdo5HzfBs9KOK/xZS0QaSkTpPIqmOiiIPURwm7KQYUpQdzQsAqSNS2a/qB/DtxHyUzPmoS2T6MvxkDz2AYcnd5+ixjNM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a pinned member, and use it for implementing pinning accounting.
Memory to be pinned has to already be accounted for as normally used,
and only memory up to the 'min' limit is allowed to be pinned.

This limit is chosen because cgroups already guarantees that memory
up to that limit will not evicted.

Pinned memory affects min and low calculations, so alter those slightly.

Signed-off-by: Maarten Lankhorst <dev@lankhorst.se>
---
 include/linux/page_counter.h |  8 +++
 mm/page_counter.c            | 98 +++++++++++++++++++++++++++++++++---
 2 files changed, 99 insertions(+), 7 deletions(-)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index d649b6bbbc871..5836c6dfb3c76 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -13,6 +13,7 @@ struct page_counter {
 	 * v2. The memcg->memory.usage is a hot member of struct mem_cgroup.
 	 */
 	atomic_long_t usage;
+	atomic_long_t pinned;
 	unsigned long failcnt; /* v1-only field */
 
 	CACHELINE_PADDING(_pad1_);
@@ -68,11 +69,18 @@ static inline unsigned long page_counter_read(struct page_counter *counter)
 	return atomic_long_read(&counter->usage);
 }
 
+static inline unsigned long page_counter_pinned(struct page_counter *counter)
+{
+	return atomic_long_read(&counter->pinned);
+}
+
 void page_counter_cancel(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
 bool page_counter_try_charge(struct page_counter *counter,
 			     unsigned long nr_pages,
 			     struct page_counter **fail);
+bool page_counter_try_pin(struct page_counter *counter, unsigned long nr_pages);
+void page_counter_unpin(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_uncharge(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_set_min(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_set_low(struct page_counter *counter, unsigned long nr_pages);
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 661e0f2a5127a..d29d0ed01ec18 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -184,6 +184,82 @@ void page_counter_uncharge(struct page_counter *counter, unsigned long nr_pages)
 		page_counter_cancel(c, nr_pages);
 }
 
+static void page_counter_unpin_one(struct page_counter *counter, unsigned long nr_pages)
+{
+	long new;
+
+	new = atomic_long_sub_return(nr_pages, &counter->pinned);
+	/* More uncharges than charges? */
+	if (WARN_ONCE(new < 0, "page_counter pinned underflow: %ld nr_pages=%lu\n",
+		      new, nr_pages))
+		atomic_long_set(&counter->pinned, 0);
+}
+
+/**
+ * page_counter_try_pin - try to hierarchically pin pages
+ * @counter: counter
+ * @nr_pages: number of pages to charge
+ *
+ * Returns %true on success, or %false if any counter goes above,
+ * the 'min' limit. Failing cgroup is not returned, as pinned memory
+ * cannot be evicted.
+ */
+bool page_counter_try_pin(struct page_counter *counter,
+			     unsigned long nr_pages)
+{
+	struct page_counter *c, *fail;
+	bool track_failcnt = counter->track_failcnt;
+
+	for (c = counter; c; c = c->parent) {
+		long new;
+		/*
+		 * Pin speculatively to avoid an expensive CAS.  If
+		 * a bigger charge fails, it might falsely lock out a
+		 * racing smaller charge and send it into reclaim
+		 * early, but the error is limited to the difference
+		 * between the two sizes, which is less than 2M/4M in
+		 * case of a THP locking out a regular page charge.
+		 *
+		 * The atomic_long_add_return() implies a full memory
+		 * barrier between incrementing the count and reading
+		 * the limit.  When racing with page_counter_set_max(),
+		 * we either see the new limit or the setter sees the
+		 * counter has changed and retries.
+		 */
+		new = atomic_long_add_return(nr_pages, &c->pinned);
+		if (new > READ_ONCE(c->min)) {
+			atomic_long_sub(nr_pages, &c->pinned);
+			/*
+			 * This is racy, but we can live with some
+			 * inaccuracy in the failcnt which is only used
+			 * to report stats.
+			 */
+			if (track_failcnt)
+				data_race(c->failcnt++);
+			fail = c;
+			goto failed;
+		}
+	}
+	return true;
+
+failed:
+	for (c = counter; c != fail; c = c->parent)
+		page_counter_unpin_one(c, nr_pages);
+
+	return false;
+}
+
+/**
+ * page_counter_unpin - hierarchically unpin pages
+ * @counter: counter
+ * @nr_pages: number of pages to uncharge
+ */
+void page_counter_unpin(struct page_counter *counter, unsigned long nr_pages)
+{
+	for (struct page_counter *c = counter; c; c = c->parent)
+		page_counter_unpin_one(c, nr_pages);
+}
+
 /**
  * page_counter_set_max - set the maximum number of pages allowed
  * @counter: counter
@@ -425,7 +501,7 @@ void page_counter_calculate_protection(struct page_counter *root,
 				       struct page_counter *counter,
 				       bool recursive_protection)
 {
-	unsigned long usage, parent_usage;
+	unsigned long usage, parent_usage, pinned, min, low;
 	struct page_counter *parent = counter->parent;
 
 	/*
@@ -442,23 +518,31 @@ void page_counter_calculate_protection(struct page_counter *root,
 	if (!usage)
 		return;
 
+	pinned = page_counter_pinned(counter);
+
+	/* For calculation purposes, pinned memory is subtracted from min/low */
+	min = READ_ONCE(counter->min);
+	if (pinned > min)
+		min = 0;
+	low = READ_ONCE(counter->low);
+	if (pinned > low)
+		low = 0;
+
 	if (parent == root) {
-		counter->emin = READ_ONCE(counter->min);
-		counter->elow = READ_ONCE(counter->low);
+		counter->emin = min;
+		counter->elow = low;
 		return;
 	}
 
 	parent_usage = page_counter_read(parent);
 
 	WRITE_ONCE(counter->emin, effective_protection(usage, parent_usage,
-			READ_ONCE(counter->min),
-			READ_ONCE(parent->emin),
+			min, READ_ONCE(parent->emin),
 			atomic_long_read(&parent->children_min_usage),
 			recursive_protection));
 
 	WRITE_ONCE(counter->elow, effective_protection(usage, parent_usage,
-			READ_ONCE(counter->low),
-			READ_ONCE(parent->elow),
+			low, READ_ONCE(parent->elow),
 			atomic_long_read(&parent->children_low_usage),
 			recursive_protection));
 }
-- 
2.50.0


