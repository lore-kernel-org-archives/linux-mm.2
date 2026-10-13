Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA02FCC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 12:22:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD8A06B009B; Tue, 13 Oct 2026 08:21:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAE8A6B009D; Tue, 13 Oct 2026 08:21:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2A456B009F; Tue, 13 Oct 2026 08:21:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 78EE76B009B
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 08:21:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6642CC0B58
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:21:57 +0000 (UTC)
X-FDA: 85317514674.28.EDD9179
Received: from mail-m16023653229.xmail.ntesmail.com (mail-m16023653229.xmail.ntesmail.com [160.236.53.229])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9E25D140003
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:21:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of zhen.ni@easystack.cn designates 160.236.53.229 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791894115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jwx4TITewLfFEf00lpDPIcX9LtuV4YH3lx/OZTTqil4=;
	b=4U+5X2KKrbehZ9xQdj1DGiG1vfswkjIZDdm9Ixp6T6P1zv8ggSHPnuj6NoK8W5UOBmOreZ
	G9fKbyxz36FR884YGoifQxKHp/94d9TkC+LevzPuX0XVm2dqT8+W6Ygi6xCH8dwh7rCD58
	yLYUr2Ho1EKDiuuHc3S4C/EyZfxZHOo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791894115;
	b=55NAcocvHeBytwbTB5GcV01lBWKgxBJwbxNJEYB491HhGYCayRCKOsxpRJQ/b0A1jv+Hu3
	AnvzhLcUiDz6lTROhS2sqJGbguc3Opvj9SLkGcWfyGXrQNNBGCOiEacap3U1AY9FhQfqaO
	79IxO8SKBQr+1Wp2rizXa+QQJIg0oWg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of zhen.ni@easystack.cn designates 160.236.53.229 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 200407ef2;
	Tue, 13 Oct 2026 20:21:49 +0800 (GMT+08:00)
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
Subject: [PATCH v2 5/6] mm/page_owner: add bpf_page_owner_get_memcg_info() kfunc
Date: Tue, 13 Oct 2026 20:21:24 +0800
Message-Id: <20261013122125.843451-6-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20261013122125.843451-1-zhen.ni@easystack.cn>
References: <20261013122125.843451-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa135363c650229kunm0bc94a6a5264
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDHxoaVkxMTR1DSR4aHktCSFYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Queue-Id: 9E25D140003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: qxgojmgn19zptcidnrg8g8i7ad9o97iu
X-HE-Tag: 1791894114-767111
X-HE-Meta: U2FsdGVkX18Wy6fbkjov4ywiH5rwDSNho7yuF9t+93oh6F9MPMqlAZMEEpFnnrdyI+Y9HTXZpi+5bXJka+sYMxhe+yCLMPeXONpw5RqqJP18vPBUR1BcyVx1If2sUNXSigOmkhDO65VW0bna6EvouXi4F5CLZFTuLy1nO6KpwUbKEnx4+WG7xz1HJWllZGbQvCBm+NiKRZ/IYcPjvvRyr+D5Cks7KRL4sazM34Wsyhf2iplFMNkeG8Yvz7MDgbibNM5x3EihnytLwrH74jGczEXveJLnzdqGLI0g6FTrb3Oj6NrVWsWbO3b5tWYhJqiAoEVofm5wSMCGDLfE5ZK05KWtgWaXZSgJpxFgRmdEHzGRizEZO1LJoAQTEBrY8M4gjmC8UC0taZZW3R+RxozWl5euAQWFgdJkKcPdiRnbxboY/aAlWD/E+HxgHMsc0IC+M6d+yVq9cw3iHYKdjZpZ2n5wV7nKsYZSHorSCmFGgp06P41qCFCfry0ZJXewCnvPdUt3shEIvJ7mFogAqb+BbbCOg2Fv0cmujHLYfef5n4L2aEgZGzHAXnT0ojCClMopZ/jx/oSSLhz/6v9KohhY2ca4Zk5ud0JnSCwqGmbtMn4GGG+YR/XArHxNU8cpQlLXhqURpU9GsUANAek7peXRagZtIy0NPNGSBgFPFz3OFixwam2y4EAjgl+AvQh1CscL7IwI4yRcN+yny9+lhCZk1R5zT/I1fagc7/YBKWmdxXXdXGczTjoDOgR8aFE1HlmxyCo9wS4OmVJU/76oBuPXidbIQ85u+RTCnnyYsjcQPsA8MW4hNo9kpK76fg+RRj0jSeHfGw/jY5yvlXX+Nchcfq31Yv9IhccV2p9YHIP0oQnaldBccltu6SJbiU0Wcdf/od+CT9h4kx600j10M03AmBHuFOtuFcYBnyrSUiCE/RB1ltNdDowAYYViIKgWWx3Ia2tj88WtNfudaP1pM8v
 W++Xmarh
 srwajwSGF5uog/8UdzKWIxdXUKlT9THp1ugeyNb8B2qToEY0Em3+7SmLyuTwgH/TCRnWI25EnylBqczI+12eYZCM+fIUN6W3QpjbAu2LZ5cAcajyAap1gU9qg35DWp495E3nq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Expose per-page memcg information to BPF programs, so that a bpf_iter
over page_owner can aggregate and filter allocations by memcg.
Attributing an allocation to a specific cgroup needs its full cgroup
path, not just the memcg name.

Split memcg info collection out of print_page_owner_memcg() into
get_page_memcg_info(), which fills struct memcg_info and, when given
a caller-provided buffer, writes the full cgroup path via
cgroup_path(). print_page_owner_memcg() now consumes the struct;
this introduces no functional change to the debugfs output.

The helper takes a single READ_ONCE snapshot within one RCU read-side
critical section, so the flags and cgroup path reflect a consistent
view of the page. cgroup_path() returns the path relative to the
cgroup hierarchy root, so memcg attribution works on both cgroup v1
and v2.

The kfunc gets the page via pfn_to_online_page(), so an offline or
removed pfn yields -ENODATA instead of a stale deref.

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
Changes in v2:
- bpf_page_owner_get_memcg_info() now resolves the page with
  pfn_to_online_page() for an offline or removed pfn.
- Buffer/info args renamed to info__uninit/buf__uninit/buf__sz.

v1: https://lore.kernel.org/linux-mm/20261009112308.240769-6-zhen.ni@easystack.cn/
---
 kernel/bpf/helpers.c |  1 +
 mm/page_owner.c      | 85 ++++++++++++++++++++++++++++++++++----------
 mm/page_owner.h      |  9 +++++
 mm/page_owner_iter.c | 17 +++++++++
 4 files changed, 93 insertions(+), 19 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 23a2d2d71f4d..b46822eac894 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -4951,6 +4951,7 @@ BTF_ID_FLAGS(func, bpf_iter_page_owner_new, KF_ITER_NEW | KF_SLEEPABLE)
 BTF_ID_FLAGS(func, bpf_iter_page_owner_next, KF_ITER_NEXT | KF_RET_NULL | KF_SLEEPABLE)
 BTF_ID_FLAGS(func, bpf_iter_page_owner_destroy, KF_ITER_DESTROY | KF_SLEEPABLE)
 BTF_ID_FLAGS(func, bpf_page_owner_stack_snprint, KF_SLEEPABLE)
+BTF_ID_FLAGS(func, bpf_page_owner_get_memcg_info, KF_SLEEPABLE)
 #endif
 BTF_ID_FLAGS(func, __bpf_trap)
 BTF_ID_FLAGS(func, bpf_strcmp, KF_PERFMON);
diff --git a/mm/page_owner.c b/mm/page_owner.c
index 113e4e7e0b3a..664121be6686 100644
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
@@ -811,6 +855,7 @@ static ssize_t
 read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 {
 	struct page_owner_scan scan;
+	struct memcg_info memcg_info;
 	struct page_owner_filter_state *state = file->private_data;
 
 	if (!static_branch_unlikely(&page_owner_inited))
@@ -832,8 +877,10 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		/* Record the next PFN to read in the file offset */
 		*ppos = scan.pfn + 1;
 
+		get_page_memcg_info(scan.page, &memcg_info, NULL, 0);
 		return print_page_owner(buf, count, scan.pfn, scan.page,
-				&scan.po_snap, scan.po_snap.handle, state);
+				&scan.po_snap, scan.po_snap.handle, state,
+				&memcg_info);
 skip_continue:
 		scan.pfn++;
 		cond_resched();
diff --git a/mm/page_owner.h b/mm/page_owner.h
index e8e52d22abed..febf1c2807de 100644
--- a/mm/page_owner.h
+++ b/mm/page_owner.h
@@ -39,7 +39,16 @@ struct page_owner_scan {
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
index a2b90c874852..86e0b4b52bfc 100644
--- a/mm/page_owner_iter.c
+++ b/mm/page_owner_iter.c
@@ -177,4 +177,21 @@ __bpf_kfunc int bpf_page_owner_stack_snprint(struct page_owner_scan *scan,
 				   0);
 }
 
+__bpf_kfunc int bpf_page_owner_get_memcg_info(struct page_owner_scan *scan,
+					      struct memcg_info *info__uninit,
+					      char *buf__uninit, u32 buf__sz)
+{
+	/* Guard against the section being offlined after scan. */
+	struct page *page = pfn_to_online_page(scan->pfn);
+
+	if (!page) {
+		*info__uninit = (struct memcg_info){};
+		if (buf__uninit && buf__sz)
+			buf__uninit[0] = '\0';
+		return -ENODATA;
+	}
+
+	return get_page_memcg_info(page, info__uninit, buf__uninit, buf__sz);
+}
+
 __bpf_kfunc_end_defs();
-- 
2.20.1


