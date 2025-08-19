Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71585CA0EFD
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 11:49:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6CC38E0043; Tue, 19 Aug 2025 07:49:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B44418E0042; Tue, 19 Aug 2025 07:49:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5B6B8E0043; Tue, 19 Aug 2025 07:49:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 946168E0042
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:49:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 41E555B391
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:49:54 +0000 (UTC)
X-FDA: 83793337908.11.B0E278C
Received: from lankhorst.se (lankhorst.se [141.105.120.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9EAB38000F
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:49:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lankhorst.se;
	spf=pass (imf30.hostedemail.com: domain of mlankhorst@lankhorst.se designates 141.105.120.124 as permitted sender) smtp.mailfrom=mlankhorst@lankhorst.se
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755604192; a=rsa-sha256;
	cv=none;
	b=sP4tB4v3c8MNM3WbZJrgR//JrdR24Pl2/rOCO43vCdmJcWXZ7I7i0+2thVjQ+rFL1R7dWo
	vhjnBHqLatxsgdQVkggowaj7gbDtIrahqyjsvplYgEwMkZDFdY6jMQgTeUNzOh2ueMfeqm
	PiUBtcblVL4jf/s+/yNvQCgo7/Ibdfc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lankhorst.se;
	spf=pass (imf30.hostedemail.com: domain of mlankhorst@lankhorst.se designates 141.105.120.124 as permitted sender) smtp.mailfrom=mlankhorst@lankhorst.se
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755604192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y1jMOrPs1cdmPr1PbLnh3wNvFSV5t1ELpi7yFpKhA3U=;
	b=GQsKnPsKGUbaKu5m/l/k51ZR0bWMqf6qRGThexRvmAcWRmV7Zv27W+i2aIt6kBytWvSX0Q
	4vXV2KLbO2eyG/eX8bX1BDYFZjI4emUGE61VIW64hGqDGY0pqjieyBhVQR8lJGYWuHabQQ
	JoojOCHdepbH+dkQ+YFEUN1Lp5Ibxyk=
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
Subject: [RFC 2/3] cgroup/dmem: Implement pinning device memory
Date: Tue, 19 Aug 2025 13:49:35 +0200
Message-ID: <20250819114932.597600-7-dev@lankhorst.se>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250819114932.597600-5-dev@lankhorst.se>
References: <20250819114932.597600-5-dev@lankhorst.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 9EAB38000F
X-Stat-Signature: a4xek8ruf6c5emsh53zi7k3cukbozy3i
X-HE-Tag: 1755604192-546765
X-HE-Meta: U2FsdGVkX19oapFbR6xRYcWORW4r3VLGbdvlg5FY6iHWXU8WzGeX+X3/0U8RUgqY3DfP2CVR3Ah6TdlI/Z8Ez7Fl8D87ykSIBDGDnAiMllrfTcC78+8zx3lYk/5o6Ft+CvL3I/q7xN9Y1mDQuoZ/CQJz6nJZR2oxn8lLavqX7D0lvlcLp42JQBkse2hUkhK+ExWEs4oR0kWkQ9Coo2ohmsEhEJ0NvTqWAb2GttJq6wYeRCZsAGIkH0Xkmaf3YgAlqNqtELdjcUiKbv9NimgH0cUjsj/D9voRTv7dGlX8wv8QKtcXkJq/erSa43rTzFBhnAjvYvjRLyb87Lxq4vA3eKzNM+SxmI5Ls4K77V3Z/cL8C1Z5eq7Jxe36IVS980CATcpLfXv9MCsHa//pu67o2k5ursMMUEBJzuRFstIvqTHq9GZuCelhzzQY7TSSp0gmpFjt6sHUof0iqqsqTsDUimWi9veyCzEw6B6yFeo8riVs6zQc4imraMGrII+B2ed6U6NYgsZgnCnfpKTNwu72rQV9AGbFtzOy7wKwduqPYIpV7+SeeKfeQU0V88jhVx+3Znd85UxXMUr5cScRq7MG14dXal1lK81JI2hGELy1G2Nf4FzWpfdllsWvTwyrFOPN/S9Alf/6OvjcPFA5lDThC8ptnCSp//6PeHQVHTtmY1xboTKoY1ne9PSYZfaC4VcRTS5CZiRzDvDOnM4kVWev+0WWrJyN0zsTOsp0DqrqzgCkNTkorNHc74LMxrQpJmn7Z/5PTZRY/Qlysx1QcNDVcgA9CmmJxk8LcDIgzUyrdl/msuO5z0mLgU3+2Kz4fjNy08P93N5T4ph0DDKLI2TvX5yWbQ+KrZGG5hQ3ZVQHxst105sQLLsy0zdFAYxHxNJjpfprQWdkqLcyp8OUeLaDNuBlxH8zvaZ/pk6nFqgLlIh7fU0VAgw0Qbu0NHH/6gKbamrDWnqN/FzSwgdFfXJ
 r2WiurtR
 cekya9pEPP8pdcl4LbGe565IGsX9FPvU6Kq8N8pbA3LNtp05Btu1PKZb9QFtaF45Wqk+SAVwlvFp0lIsmEhhPz5IT5i5u/oeyI65Bn13gEdbzyGA4lQ6RtXlCU8V7eguC3w0eaEAR64Kb1NuSpOrsIvYu5qBH9dnJpGe8AAlnUS0IZQCBDSS3kRYgqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a function to pin, and to unipn memory and adjust the calculations
in dmem_cgroup_state_evict_valuable().

Signed-off-by: Maarten Lankhorst <dev@lankhorst.se>
---
 include/linux/cgroup_dmem.h |  2 ++
 kernel/cgroup/dmem.c        | 57 +++++++++++++++++++++++++++++++++++--
 2 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/include/linux/cgroup_dmem.h b/include/linux/cgroup_dmem.h
index dd4869f1d736e..a981bb692ba22 100644
--- a/include/linux/cgroup_dmem.h
+++ b/include/linux/cgroup_dmem.h
@@ -21,6 +21,8 @@ int dmem_cgroup_try_charge(struct dmem_cgroup_region *region, u64 size,
 			   struct dmem_cgroup_pool_state **ret_pool,
 			   struct dmem_cgroup_pool_state **ret_limit_pool);
 void dmem_cgroup_uncharge(struct dmem_cgroup_pool_state *pool, u64 size);
+int dmem_cgroup_try_pin(struct dmem_cgroup_pool_state *pool, u64 size);
+void dmem_cgroup_unpin(struct dmem_cgroup_pool_state *pool, u64 size);
 bool dmem_cgroup_state_evict_valuable(struct dmem_cgroup_pool_state *limit_pool,
 				      struct dmem_cgroup_pool_state *test_pool,
 				      bool ignore_low, bool *ret_hit_low);
diff --git a/kernel/cgroup/dmem.c b/kernel/cgroup/dmem.c
index 10b63433f0573..ec8b1ffec78de 100644
--- a/kernel/cgroup/dmem.c
+++ b/kernel/cgroup/dmem.c
@@ -147,6 +147,11 @@ static u64 get_resource_current(struct dmem_cgroup_pool_state *pool)
 	return pool ? page_counter_read(&pool->cnt) : 0;
 }
 
+static u64 get_resource_pinned(struct dmem_cgroup_pool_state *pool)
+{
+	return pool ? page_counter_pinned(&pool->cnt) : 0;
+}
+
 static void reset_all_resource_limits(struct dmem_cgroup_pool_state *rpool)
 {
 	set_resource_min(rpool, 0);
@@ -270,7 +275,7 @@ bool dmem_cgroup_state_evict_valuable(struct dmem_cgroup_pool_state *limit_pool,
 {
 	struct dmem_cgroup_pool_state *pool = test_pool;
 	struct page_counter *ctest;
-	u64 used, min, low;
+	u64 used, min, low, pinned;
 
 	/* Can always evict from current pool, despite limits */
 	if (limit_pool == test_pool)
@@ -296,16 +301,18 @@ bool dmem_cgroup_state_evict_valuable(struct dmem_cgroup_pool_state *limit_pool,
 
 	ctest = &test_pool->cnt;
 
+	/* Protection is calculated without pinned memory */
 	dmem_cgroup_calculate_protection(limit_pool, test_pool);
 
 	used = page_counter_read(ctest);
-	min = READ_ONCE(ctest->emin);
+	pinned = page_counter_pinned(ctest);
+	min = READ_ONCE(ctest->emin) + pinned;
 
 	if (used <= min)
 		return false;
 
 	if (!ignore_low) {
-		low = READ_ONCE(ctest->elow);
+		low = READ_ONCE(ctest->elow) + pinned;
 		if (used > low)
 			return true;
 
@@ -641,6 +648,41 @@ int dmem_cgroup_try_charge(struct dmem_cgroup_region *region, u64 size,
 }
 EXPORT_SYMBOL_GPL(dmem_cgroup_try_charge);
 
+/**
+ * dmem_cgroup_unpin() - Unpin from a pool.
+ * @pool: Pool to unpin.
+ * @size: Size to unpin.
+ *
+ * Undoes the effects of dmem_cgroup_try_pin.
+ * Must be called with the returned pool as argument,
+ * and same @index and @size.
+ */
+void dmem_cgroup_unpin(struct dmem_cgroup_pool_state *pool, u64 size)
+{
+	if (pool)
+		page_counter_unpin(&pool->cnt, size);
+}
+EXPORT_SYMBOL_GPL(dmem_cgroup_unpin);
+
+/**
+ * dmem_cgroup_try_pin() - Try pinning an existing allocation to a region.
+ * @pool: dmem region to pin
+ * @size: Size (in bytes) to pin.
+ *
+ * This function pins in @pool for a size of @size bytes.
+ *
+ * If the function succeeds, the memory is succesfully accounted as being pinned.
+ * The memory may not be uncharged before unpin is called.
+ *
+ * Return: 0 on success, -EAGAIN on hitting a limit, or a negative errno on failure.
+ */
+int dmem_cgroup_try_pin(struct dmem_cgroup_pool_state *pool, u64 size)
+{
+	return page_counter_try_pin(&pool->cnt, size) ? 0 : -EAGAIN;
+
+}
+EXPORT_SYMBOL_GPL(dmem_cgroup_try_pin);
+
 static int dmem_cgroup_region_capacity_show(struct seq_file *sf, void *v)
 {
 	struct dmem_cgroup_region *region;
@@ -756,6 +798,11 @@ static int dmem_cgroup_region_current_show(struct seq_file *sf, void *v)
 	return dmemcg_limit_show(sf, v, get_resource_current);
 }
 
+static int dmem_cgroup_region_pinned_show(struct seq_file *sf, void *v)
+{
+	return dmemcg_limit_show(sf, v, get_resource_pinned);
+}
+
 static int dmem_cgroup_region_min_show(struct seq_file *sf, void *v)
 {
 	return dmemcg_limit_show(sf, v, get_resource_min);
@@ -799,6 +846,10 @@ static struct cftype files[] = {
 		.name = "current",
 		.seq_show = dmem_cgroup_region_current_show,
 	},
+	{
+		.name = "pinned",
+		.seq_show = dmem_cgroup_region_pinned_show,
+	},
 	{
 		.name = "min",
 		.write = dmem_cgroup_region_min_write,
-- 
2.50.0


