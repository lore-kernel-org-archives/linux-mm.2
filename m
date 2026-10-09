Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0A20CA6018
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 11:23:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B079B6B0095; Fri,  9 Oct 2026 07:23:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8FEE6B0096; Fri,  9 Oct 2026 07:23:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 909906B0099; Fri,  9 Oct 2026 07:23:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4978D6B0095
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:23:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BC5A2A7C90
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:23:38 +0000 (UTC)
X-FDA: 85302852516.11.4025609
Received: from mail-m1602365230.xmail.ntesmail.com (mail-m1602365230.xmail.ntesmail.com [160.236.52.30])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1E101140003
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:23:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of zhen.ni@easystack.cn designates 160.236.52.30 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791545016;
	b=6MTL6C2BXLozw+sqtrCGGVcsCKKyIie0MBFRy5suThj2AFq+UYrCYh0o+InShvO7trEEf4
	OwFaFwaTyCI2BsjvbzNOUFe8104Pfhn1vC/LSK8T9loZCMN4F3301RnaPVf+KN8WGvOyd+
	y65huNmGCFSTdVtREsTzdUGjJLlhqBY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of zhen.ni@easystack.cn designates 160.236.52.30 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791545016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wNJEnuFlOmSJiR8Uv8mSBLfPf8DLIR+q09fIC/ErFKw=;
	b=Rw9OYLSif1nHMzRHYsAGV87cK0GW+pADdiwvzc9+N6h062cBhjK5tTXz5+aRyNznjL3/nz
	UULVrFXNolWABi+BE7p2QEyjUvZz7GpFSwnYHmL6aQbcvWPWSrOws1wqKsnJIZ2UPfHRDW
	oCGSjPbLOHX4wuECftkFLR1XbkKxLqc=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1fe2901a6;
	Fri, 9 Oct 2026 19:23:31 +0800 (GMT+08:00)
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
Subject: [PATCH 5/6] mm/page_owner: add bpf_page_owner_get_memcg_info() kfunc
Date: Fri,  9 Oct 2026 19:23:07 +0800
Message-Id: <20261009112308.240769-6-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20261009112308.240769-1-zhen.ni@easystack.cn>
References: <20261009112308.240769-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa120676b9a0229kunmd33b3e054cb28e
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCShlKVklJTE8aHhpJT0JIQlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1E101140003
X-Stat-Signature: g4yhoo9i9efk5ry5bwdaqtkqyotrcfsk
X-HE-Tag: 1791545015-293758
X-HE-Meta: U2FsdGVkX1/TpV+SmLot+/ROTsMQWrYa5Ae1/Pb3Uo84GaFxXY2ImkCWvpT1eoZmpmKLJE3MihMuMVyrW39oMuVgLneyuhdIa6eWQqzae8oFov5Efr8NPbNxOBm7TPKueIZ45ZAvvGaJjOHYJEd1/yCqgKYrF2X8zfP/00SWWy/EkkCh9UOsO7IBUsSYvh1tA8TrY7ujN1xyb0XKtibf4w6BR5uIcbqnDPleT18DSCLZwneNV2IDHWUsmuZOrwppGVbaBp+9FkwDWSX2wPDDrD9eIX9wZcbj6Gc8bX3Wswk3Spf9MXXsQg3J0/ef2rzR3HwdV8vSHZZtNXmkFl/b9smfUQV1I/gxrXI5amX1kaBNSEbKQUYCeGxaWJrpFCNad6ZXD7L1MDO4EE0Axn6i1WxL5kKrPjQwYsS8YZydH77DVIlgFlLkBQiafSXpB0QTlejO47pslwEqf5uGiIbfa1EDj9TDWTgdSyjsSIKb6r+QZhDX7xt0nTQgccVq3i6n+vxTVk8XgAitRc4owC5q7H/1lRqzZucwamF+mlSydPgp5ykZH1Lt9PoSpraE5lO2PvPXp2LOE6g1LdwRybLIgSr76F1yDkx0lbNkBLV8l9Z7TBXVYT/9uZu5/88hcUKj0mSrrLn8nsvPQafYsGLSkfpaN3546q8FRLxf4Nc/uVenOj1vzjImeWgvOn/PDbC2XeE28VSbivGWlWgLuDRG+vT+soECDjbgEMkeexd7RojR5OfVhwHLwGiT/55KCs+TpyUb01u8l9AQA6ny+5Xx2VMiosgS9lKJecdplHPwP/998vOlZDcv52kQjIKycmpkJEsbIznvlBuopPs/bGI3JNyE6vmWBwHQJUDN2sU1ktbw6QUHcQ4GkepdyxMlHtG2unzUQVs7TjRzZYzVV80LUfETqjawKJ0hFz2JCeJD8Lgzuk6A/BA77kZ7fvK12mx7TZFBM45BAB+gtqwVjm7
 1+uwGm7M
 VPB+btDzQyl4dcyHkTnkCrYWmd2Sr2lmW7z4myQU2lnz4I/3hNXN/z6ADGTsFxpcFwrq/jWcrw+jDaOLNuBRDdYEBPTeJcBFn10WrS3hLb5pqq1s=
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

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
 kernel/bpf/helpers.c |  1 +
 mm/page_owner.c      | 85 ++++++++++++++++++++++++++++++++++----------
 mm/page_owner.h      |  9 +++++
 mm/page_owner_iter.c |  7 ++++
 4 files changed, 83 insertions(+), 19 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 3e8afd19a1f4..b07a4dc46b58 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -4952,6 +4952,7 @@ BTF_ID_FLAGS(func, bpf_iter_page_owner_next, KF_ITER_NEXT | KF_RET_NULL | KF_SLE
 BTF_ID_FLAGS(func, bpf_iter_page_owner_destroy, KF_ITER_DESTROY | KF_SLEEPABLE)
 BTF_ID_FLAGS(func, bpf_page_owner_stack_snprint, KF_SLEEPABLE)
 BTF_ID_FLAGS(func, bpf_page_owner_get_nid, KF_SLEEPABLE)
+BTF_ID_FLAGS(func, bpf_page_owner_get_memcg_info, KF_SLEEPABLE)
 #endif
 BTF_ID_FLAGS(func, __bpf_trap)
 BTF_ID_FLAGS(func, bpf_strcmp, KF_PERFMON);
diff --git a/mm/page_owner.c b/mm/page_owner.c
index 43a722678acc..ad503422b0c4 100644
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
@@ -810,6 +854,7 @@ static ssize_t
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
index c57859d18dc3..e74fc664d9b1 100644
--- a/mm/page_owner.h
+++ b/mm/page_owner.h
@@ -38,8 +38,17 @@ struct page_owner_scan {
 	struct page_owner po_snap;
 };
 
+struct memcg_info {
+	char name[80];
+	bool is_slab;
+	bool is_kmem;
+	bool is_online;
+};
+
 bool page_owner_next_eligible(struct page_owner_scan *scan);
 int page_owner_get_nid(struct page *page);
+int get_page_memcg_info(struct page *page, struct memcg_info *info,
+			char *buf, int size);
 
 /*
  * mm/page_owner_iter.c
diff --git a/mm/page_owner_iter.c b/mm/page_owner_iter.c
index 907517a29144..e7a8ca1e90e8 100644
--- a/mm/page_owner_iter.c
+++ b/mm/page_owner_iter.c
@@ -170,4 +170,11 @@ __bpf_kfunc int bpf_page_owner_get_nid(struct page_owner_scan *scan)
 	return page_owner_get_nid(scan->page);
 }
 
+__bpf_kfunc int bpf_page_owner_get_memcg_info(struct page_owner_scan *scan,
+					      struct memcg_info *info,
+					      char *buf, u32 size)
+{
+	return get_page_memcg_info(scan->page, info, buf, size);
+}
+
 __bpf_kfunc_end_defs();
-- 
2.20.1


