Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12353606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 11:25:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A77856B06CA; Wed, 21 Oct 2026 07:25:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4EC96B06CB; Wed, 21 Oct 2026 07:25:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 916256B06CC; Wed, 21 Oct 2026 07:25:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 649AD6B06CA
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:25:04 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DDDC712010B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:25:03 +0000 (UTC)
X-FDA: 85346401686.22.30F5C5A
Received: from mail-m608.netease.com (mail-m608.netease.com [210.79.60.8])
	by imf09.hostedemail.com (Postfix) with ESMTP id 469AE140006
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:25:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf09.hostedemail.com: domain of zhen.ni@easystack.cn designates 210.79.60.8 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792581901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RAG/2ax1ucQUbAiCg/s1Qqe5BmQBfpQgRvDtOVmHwa4=;
	b=xpMudxXPQHFNKUf/ayd9RvseLGg3Orny8l5BbuJ2iP8nrnnBNXuCcC1nhUchVjGmiAWWWM
	VPrJ6wWuguFQgp01QdbhNfMizAhtyXyUtPejgh1km3nyzL5QfXsOigBpyLqrIo0Fifmhw8
	KlmGjVzaX/B8y+dGrxPRrlPk/eATO3o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf09.hostedemail.com: domain of zhen.ni@easystack.cn designates 210.79.60.8 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792581901;
	b=SBKc4SWHYTOrE+CYZskS4wB7NtlvtJvKKm7ZKWGI8PJPLzqAx9MM2eZFnfZc0qnParLlN2
	V/HTeeQQONM6llHxAptgV6LOyeKrBYvOssAUr5FiqQ0MNjRDds0hXH7WTTY0H249KsCeSa
	s6z0PFlqa4A48YoGcSnNVruvfyO0uFI=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 204f151ae;
	Wed, 21 Oct 2026 19:24:56 +0800 (GMT+08:00)
From: Zhen Ni <zhen.ni@easystack.cn>
To: ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	martin.lau@linux.dev,
	song@kernel.org,
	yonghong.song@linux.dev,
	jolsa@kernel.org,
	emil@etsalapatis.com,
	ihor.solodrai@linux.dev,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	shuah@kernel.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhen Ni <zhen.ni@easystack.cn>
Subject: [PATCH v3 6/7] mm/page_owner: add bpf_page_owner_get_memcg_info() kfunc
Date: Wed, 21 Oct 2026 19:24:36 +0800
Message-Id: <20261021112437.1799213-7-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20261021112437.1799213-1-zhen.ni@easystack.cn>
References: <20261021112437.1799213-1-zhen.ni@easystack.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa15e350a610229kunme08c1fd526acf1
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaSUxJVhpLTBlLHxlJThhMT1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 469AE140006
X-Stat-Signature: m1sxdwb6n8jsfoauns8gx3h47nfs38n8
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792581900-492878
X-HE-Meta: U2FsdGVkX18zb9pzV1pYdr2fgsqcpxhaRVBQO33+7aG3fXGp/8TPTGJsksvxTIZoyFlRwXNlt57HqZwjNmjnaNzaXL1bKEt2WXoysGvYNRXnkKlSB9pL2Q7jQbEfDKyxJBm0nEngYkaNfMuB4DQ5Ogy9xCQJYjDt9B/h7kLBcKhjJTYDibz3ygCiMSI24GnNh5ECyPLXJN14iBjnrJNyvfCAVpPSQrY40SeSn0YPu+MnYdYnZEeemI09Zkyy0/2dlS39WI4s/LJ8+k8NaZKj+cwIX4UOoF//Q0zG5yzAxi9fjwsxHSbmgto3/Aq6elAYbkONtgGaOAOdCAt8Zt9/QWuDyos8RFrezvBy4tX/NkfPfH8I+7gottGHm5EpfETFzOKTGRaJjst3/8TsHRma6xf2IJ7u7ymXlgR/SaPc8NNOe40U86imWzw38B2qiOyvDztoOhWymV4E8I01v+xTQbJxwSfi/QwaOrCr0JmivJnndsmymILv74gG+KWyvGDxHLZY7P6mPKfrHy6jyp7JPw03yDZ8pVdZm3LPB73ml3bCjfvCp/9QK+30Nvtw5Gz1ZQSxZNv4aF/zHt1BcxelXmC0QlG0bNVFKnEJNLikdsYfrPCFeXz2D3XWc0ct8M96EXE/G9F+aETRZ7W5l3SX5AXVW9OgmprUphzBmAC94cjB0oHrQT2ugQiVPmbbZ+usOXLbjNjtGKle82O5GPbjArSJDfkLEiSoM6ue15r2cAejhADvhn13uvL/RuJPLEAXaDb+2Gl8xzZ7ZrF5RxaSw1liUYjGiMsSfjTKjBETaz/FEtB5khPMo8Ox2PWEizu1nmgj5vh2QWvFwIaZ5xGLAL/LCjbWKTwNG/UIaCiRKVX0NuvqJrSFWe9iX0zLObyUc6m4jovWUgHKZnB6sKVk2kB0q2nR3fk+LmTjCc7SCINyysSsoY13bqNZVdCxU+4gBUVvLtsNKFMFcPSyZ+u
 kBjcE3Ej
 ZMmbd5GXWLxGn04pSBhwQoguil3EtPBn8+uecSZq2KH7Or/afzvgzSVYfjEKidqQvi/3XTyZ7yFbC1wP19gXaAylrlsWLuAIumnAbg7CgGEPzmcNJCs7wqWQgI5OsXUZoEJS1e5JMcFvKCzyV7L/1aYoNOLU7+Dyw0r6lu4Ofln8CB4F363Fg3ZBpFskUiwh5PZPnzdYD5QIJQpGsJx9zoWxWg9pP+jyCvgW09I1FD2bn/WISOL+bRJxJKWahWA88w6iP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Expose per-page memcg information to BPF programs, so that a bpf_iter
over page_owner can aggregate and filter allocations by memcg.
Attributing an allocation to a specific cgroup needs its full cgroup
path, not just the memcg name.

Split memcg info collection out of print_page_owner_memcg() into
get_page_memcg_info(), which fills struct memcg_info and, when given a
caller-provided buffer, writes the full cgroup path via cgroup_path().
print_page_owner_memcg() now consumes the struct; this introduces no
functional change to the debugfs output.

The helper takes a single READ_ONCE snapshot within one RCU read-side
critical section, so the flags and cgroup path reflect a consistent
view of the page. cgroup_path() returns the path relative to the cgroup
hierarchy root, so memcg attribution works on both cgroup v1 and v2.

Because scan->pfn is selected by a lockless scan, the kfunc re-resolves
it with pfn_to_online_page() under get_online_mems() to avoid accessing
a hot-removed section. If the PFN is offline or removed, the kfunc
returns -ENODATA instead of dereferencing memcg_data.

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
Changes in v3:
- Check the page_owner_inited static key.
- Resolve the page with pfn_to_online_page() under get_online_mems().

Changes in v2:
- bpf_page_owner_get_memcg_info() now resolves the page with
  pfn_to_online_page() for an offline or removed pfn.
- Buffer/info args renamed to info__uninit/buf__uninit/buf__sz.

v2: https://lore.kernel.org/linux-mm/20261013122125.843451-6-zhen.ni@easystack.cn/
v1: https://lore.kernel.org/linux-mm/20261009112308.240769-6-zhen.ni@easystack.cn/
---
 kernel/bpf/helpers.c |  1 +
 mm/page_owner.c      | 85 ++++++++++++++++++++++++++++++++++----------
 mm/page_owner.h      |  9 +++++
 mm/page_owner_iter.c | 48 +++++++++++++++++++++++++
 4 files changed, 124 insertions(+), 19 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 0ba836f77957..bba9eeb076c3 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -4954,6 +4954,7 @@ BTF_ID_FLAGS(func, bpf_iter_page_owner_next,
 BTF_ID_FLAGS(func, bpf_iter_page_owner_destroy,
 	     KF_ITER_DESTROY | KF_SLEEPABLE | KF_PERFMON)
 BTF_ID_FLAGS(func, bpf_page_owner_stack_snprint, KF_SLEEPABLE | KF_PERFMON)
+BTF_ID_FLAGS(func, bpf_page_owner_get_memcg_info, KF_SLEEPABLE | KF_PERFMON)
 #endif
 BTF_ID_FLAGS(func, __bpf_trap)
 BTF_ID_FLAGS(func, bpf_strcmp, KF_PERFMON);
diff --git a/mm/page_owner.c b/mm/page_owner.c
index 8bc15bcdc24e..7470b5d002be 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -538,16 +538,22 @@ void pagetypeinfo_showmixedcount_print(struct seq_file *m,
 
 #ifdef CONFIG_MEMCG
 /*
- * Looking for memcg information and print it out
+ * Collect memcg information of @page into @info; when @buf and a
+ * nonzero @size are given, also copy the full cgroup path of the
+ * charged memcg into @buf.
+ *
+ * Return: 0 if @page is charged to an attributable memcg; -ENODATA
+ * otherwise.
  */
-static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
-					 struct page *page)
+int get_page_memcg_info(struct page *page, struct memcg_info *info,
+			char *buf, int size)
 {
 	unsigned long memcg_data;
 	struct obj_cgroup *objcg;
 	struct mem_cgroup *memcg;
-	bool online;
-	char name[80];
+	int ret = -ENODATA;
+
+	*info = (struct memcg_info){};
 
 	rcu_read_lock();
 	memcg_data = READ_ONCE(page->memcg_data);
@@ -555,31 +561,68 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 		goto out_unlock;
 
 	if (memcg_data & MEMCG_DATA_OBJEXTS) {
-		ret += scnprintf(kbuf + ret, count - ret,
-				"Slab cache page\n");
+		info->is_slab = true;
 		goto out_unlock;
 	}
 
 	objcg = (void *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
-	memcg = objcg ? obj_cgroup_memcg(objcg) : NULL;
+	if (!objcg)
+		goto out_unlock;
+
+	memcg = obj_cgroup_memcg(objcg);
 	if (!memcg)
 		goto out_unlock;
 
-	online = css_is_online(&memcg->css);
-	cgroup_name(memcg->css.cgroup, name, sizeof(name));
-	ret += scnprintf(kbuf + ret, count - ret,
-			"Charged %sto %smemcg %s\n",
-			(memcg_data & MEMCG_DATA_KMEM) ? "(via objcg) " : "",
-			online ? "" : "offline ",
-			name);
+	info->is_kmem = (memcg_data & MEMCG_DATA_KMEM) != 0;
+	info->is_online = css_is_online(&memcg->css);
+	cgroup_name(memcg->css.cgroup, info->name, sizeof(info->name));
+
+	if (buf && size)
+		cgroup_path(memcg->css.cgroup, buf, size);
+	ret = 0;
 out_unlock:
 	rcu_read_unlock();
 
+	if (ret < 0 && buf && size)
+		buf[0] = '\0';
+
+	return ret;
+}
+
+/*
+ * Print memcg information from memcg_info
+ */
+static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
+					 const struct memcg_info *info)
+{
+	if (!info)
+		return ret;
+
+	if (info->is_slab)
+		ret += scnprintf(kbuf + ret, count - ret,
+				"Slab cache page\n");
+
+	if (info->name[0])
+		ret += scnprintf(kbuf + ret, count - ret,
+				"Charged %sto %smemcg %s\n",
+				info->is_kmem ? "(via objcg) " : "",
+				info->is_online ? "" : "offline ",
+				info->name);
+
 	return ret;
 }
 #else
+int get_page_memcg_info(struct page *page, struct memcg_info *info,
+			char *buf, int size)
+{
+	*info = (struct memcg_info){};
+	if (buf && size)
+		buf[0] = '\0';
+	return -EOPNOTSUPP;
+}
+
 static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
-					 struct page *page)
+					 const struct memcg_info *info)
 {
 	return ret;
 }
@@ -589,7 +632,8 @@ static ssize_t
 print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 		struct page *page, struct page_owner *page_owner,
 		depot_stack_handle_t handle,
-		struct page_owner_filter_state *state)
+		struct page_owner_filter_state *state,
+		const struct memcg_info *memcg_info)
 {
 	int ret, pageblock_mt, page_mt;
 	char *kbuf;
@@ -639,7 +683,7 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 			migrate_reason_names[page_owner->last_migrate_reason]);
 	}
 
-	ret = print_page_owner_memcg(kbuf, count, ret, page);
+	ret = print_page_owner_memcg(kbuf, count, ret, memcg_info);
 
 	ret += snprintf(kbuf + ret, count - ret, "\n");
 	if (ret >= count)
@@ -822,6 +866,7 @@ static ssize_t
 read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 {
 	struct page_owner_scan scan;
+	struct memcg_info memcg_info;
 	struct page_owner_filter_state *state = file->private_data;
 
 	if (!static_branch_unlikely(&page_owner_inited))
@@ -855,8 +900,10 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		/* Record the next PFN to read in the file offset */
 		*ppos = scan.pfn + 1;
 
+		get_page_memcg_info(page, &memcg_info, NULL, 0);
 		ret = print_page_owner(buf, count, scan.pfn, page,
-				&scan.po_snap, scan.po_snap.handle, state);
+				&scan.po_snap, scan.po_snap.handle, state,
+				&memcg_info);
 		put_online_mems();
 		return ret;
 
diff --git a/mm/page_owner.h b/mm/page_owner.h
index 934bc9f84d6f..65598415af73 100644
--- a/mm/page_owner.h
+++ b/mm/page_owner.h
@@ -41,7 +41,16 @@ struct page_owner_scan {
 	int nid;
 };
 
+struct memcg_info {
+	char name[80];
+	bool is_slab;
+	bool is_kmem;
+	bool is_online;
+};
+
 bool page_owner_next_eligible(struct page_owner_scan *scan);
+int get_page_memcg_info(struct page *page, struct memcg_info *info,
+			char *buf, int size);
 
 /*
  * mm/page_owner_iter.c
diff --git a/mm/page_owner_iter.c b/mm/page_owner_iter.c
index b7e0ce1dfa80..a649e1207e24 100644
--- a/mm/page_owner_iter.c
+++ b/mm/page_owner_iter.c
@@ -181,4 +181,52 @@ __bpf_kfunc int bpf_page_owner_stack_snprint(struct page_owner_scan *scan,
 	return len;
 }
 
+/**
+ * bpf_page_owner_get_memcg_info - Report the memcg charged for the current page
+ * @scan: page_owner scan handle.
+ * @info__uninit: output buffer for the memcg_info.
+ * @buf__uninit: optional output buffer for the full cgroup path.
+ * @buf__sz: size of @buf__uninit.
+ *
+ * Fills @info__uninit with the memcg charged for the page backing
+ * @scan->pfn.  If @buf__uninit and @buf__sz are provided, the full
+ * cgroup path is also copied out, so a BPF program can attribute a
+ * page_owner allocation to a specific cgroup.
+ *
+ * @scan->pfn is resolved to a struct page under get_online_mems(),
+ * so the page cannot be accessed after its memory section is offlined
+ * or removed.
+ *
+ * Returns:
+ * * 0 on success
+ * * -ENODATA if the page is not online or not charged to a memcg
+ * * -EOPNOTSUPP if built without CONFIG_MEMCG
+ */
+__bpf_kfunc int bpf_page_owner_get_memcg_info(struct page_owner_scan *scan,
+					      struct memcg_info *info__uninit,
+					      char *buf__uninit, u32 buf__sz)
+{
+	struct page *page;
+	int ret = -ENODATA;
+
+	if (!static_branch_unlikely(&page_owner_inited))
+		goto nodata;
+
+	get_online_mems();
+	page = pfn_to_online_page(scan->pfn);
+	if (!page) {
+		put_online_mems();
+		goto nodata;
+	}
+	ret = get_page_memcg_info(page, info__uninit, buf__uninit, buf__sz);
+	put_online_mems();
+	return ret;
+
+nodata:
+	*info__uninit = (struct memcg_info){};
+	if (buf__uninit && buf__sz)
+		buf__uninit[0] = '\0';
+	return ret;
+}
+
 __bpf_kfunc_end_defs();
-- 
2.20.1


