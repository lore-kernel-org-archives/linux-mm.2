Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBE36C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:27:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 499C96B00AA; Mon,  7 Sep 2026 04:26:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 424CF6B00AD; Mon,  7 Sep 2026 04:26:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3130F6B00B2; Mon,  7 Sep 2026 04:26:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F1AE86B00AA
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:26:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8185DA06B7
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:26:52 +0000 (UTC)
X-FDA: 85186285464.13.B5B23CD
Received: from mail-m82138.xmail.ntesmail.com (mail-m82138.xmail.ntesmail.com [156.224.82.138])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0556240006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:26:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf12.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.138 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788769610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7X1IqaV+gh5TMrRqxrYPUeAqOnn8HpgDtNPlrU2jyjo=;
	b=FLxQhJdCvOcNoT9zSl8uoQFyIfFyE5Q5CzGvoxzewUEYwQyWrWYX2KLVqf96PiKBJWBLHF
	QmvYD58KUVnXo6Ps5lW3LcEVDaPXhtS3LavPHLZVE4vTT4vUVEt2TOa+EDZWficzbKJH0H
	rnugjp6VgB6Qsv6xUCXwCKNpIKWOeIQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788769610;
	b=PcZgBXgVuwxZrXniaSi8Xt36OV5b1+vI19Hp92meYuraLc3jI1oM3YMh1RmUIt+mjl6b2i
	zveExaNM1HcHq3i6jmfmhiBJ1oH5gu8OSx98+fvRhcHqKz41378lji1ui6o2RpCGo3OZBK
	svSdzOiMzzNYDFQ78m98LJ5hSVSr41Y=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf12.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.138 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1ec6fa097;
	Mon, 7 Sep 2026 16:26:45 +0800 (GMT+08:00)
From: Zhen Ni <zhen.ni@easystack.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhen Ni <zhen.ni@easystack.cn>
Subject: [PATCH v3 4/8] mm/page_owner: Refactor memcg handling for cgroup filter support
Date: Mon,  7 Sep 2026 16:26:16 +0800
Message-Id: <20260907082620.2083838-5-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260907082620.2083838-1-zhen.ni@easystack.cn>
References: <20260907082620.2083838-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa07afa16e30229kunm225d16da162d06
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCThhJVkxDQh0fHhlJSU8YGVYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Stat-Signature: 1wz86bq94dda7g3qpr9imbdkqpo6ptgj
X-Rspamd-Queue-Id: 0556240006
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788769609-845446
X-HE-Meta: U2FsdGVkX18yzZxZAHSy8WTD4KunYyLxT9yJ/0pT09a0ELUEb0ed1eraEu8+wUZwuG7HLfXcvJtF60xjt/Upsyw1dwiMPnukq4g+bDM3/pDmsr+8su2BUxEUq7qXA5YKdGWmqmWXmStdcIE76EIrj3f7MTY7fGfXCObzlViLsrfCr7D8T7KuSW9utQrMXxAyJqCnQ2TFXesPuf7MUGb303F/xSmN2BNv5oqv4lSTg7zxo9TaX5Rapo55H+5tXQcmNnPenGzFnpZtIWTbw8XAktYI2UvZNU6Vx+pvJkuSsyQ5w4W9OFwyex5aDRAiqYzjmaiNrnZW+mL0SufJD/qpR48LITjgzS9KNVRhxGClOhQB4Q2qkEIpf9Zcpv/MikpyYElBY49c3Sf6AW3AAq5SmgHA2GWQuKAfcxD4Dc6Oks5WvrbzMX1m9hzTZfgcHcLwTAcQFshA4frYo2nwJP/QjMOvQeLHxWyINtx8n9JqVCxh/XPsqT7SjI9YTY9JLn/MScZ38xFUP4RlDU17Rh2dKL2yP05DvhBx60h67sZxe1/UkMlljjs8BFe6OT/KY2O1a184bVKMKO2njKuQIPn2rZ1gl/jgHeCD8SqNy5+oyTFfP3DSWkW466VPyKRA4bBgW+mvM9IYfj3pngPQqs3H6xqaYB4RDQMcpA72b+6qF3Kry6KgWafemiuQv3Seg2cXqKG0pcSnW0hGukl0/u7iayAcpgdjvqf0koSdx7Cn6FlkRKVmonvs7/XeOZ2e/2MlYE9tjuyimBnht6JvTOtitx8LNGsJVarTSyO5/WipKam2rEjS1GcXHTwNyPEguNFcM/68k43aHbEiyubE52QYq+Sa4BhbRcHXFiIawxURu+0DQLKzPKPMY+iFW9vt26FFVW8VCrBCeqBsUoJqopSVUJ6ju/dCxW8xx2+Wn9YTtzIPMULVKUX60Y4kkbbrC13ZHMJ+1b23S/3ph4sTyNz
 VjpkITv3
 m+lxONcN9mp+ymvy0A4J4d+FuvRDRITkm1gKC9qN1p0ImWSRd6DLzLhyRGVwgZp2IDbdSZWut0KsXOvmlOBOzuPBRv2SKQpr3AQG+XPZyr923OscLYB0cmm+t5cff0704D7XMsmPgbytl1roiI5fwUT1GVT8CN33tK08XjuEhPNuY/AI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract memcg information retrieval from printing logic to prepare for
cgroup filtering support. Introduce struct memcg_info to hold cgroup
data that can be reused for both display output and filtering
decisions.

No functional change - output behavior unchanged.

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
Changes in v3:
- No change.

Changes in v2:
- No change.

v1: https://lore.kernel.org/linux-mm/20260828031339.1270699-5-zhen.ni@easystack.cn/
v2: https://lore.kernel.org/linux-mm/20260903041819.1776630-5-zhen.ni@easystack.cn/
---
 mm/page_owner.c | 62 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 44 insertions(+), 18 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 792eefdd419d..3bdf4faa8f6b 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -69,6 +69,13 @@ static const char * const page_owner_print_mode_strings[] = {
 	[PAGE_OWNER_PRINT_STACK_HANDLE]	= "stack_handle",
 };
 
+struct memcg_info {
+	char name[80];
+	bool is_slab;
+	bool is_objcg;
+	bool is_online;
+};
+
 /* PID_MAX_LIMIT = 4,194,304 (7 decimal digits) */
 #define PID_MAX_DIGITS  	7
 #define MAX_FILTER_PIDS 	16
@@ -573,16 +580,13 @@ void pagetypeinfo_showmixedcount_print(struct seq_file *m,
 
 #ifdef CONFIG_MEMCG
 /*
- * Looking for memcg information and print it out
+ * Get memcg information from page
  */
-static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
-					 struct page *page)
+static void get_page_memcg_info(struct page *page, struct memcg_info *info)
 {
 	unsigned long memcg_data;
 	struct obj_cgroup *objcg;
 	struct mem_cgroup *memcg;
-	bool online;
-	char name[80];
 
 	rcu_read_lock();
 	memcg_data = READ_ONCE(page->memcg_data);
@@ -590,8 +594,7 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 		goto out_unlock;
 
 	if (memcg_data & MEMCG_DATA_OBJEXTS) {
-		ret += scnprintf(kbuf + ret, count - ret,
-				"Slab cache page\n");
+		info->is_slab = true;
 		goto out_unlock;
 	}
 
@@ -600,21 +603,38 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 	if (!memcg)
 		goto out_unlock;
 
-	online = css_is_online(&memcg->css);
-	cgroup_name(memcg->css.cgroup, name, sizeof(name));
-	ret += scnprintf(kbuf + ret, count - ret,
-			"Charged %sto %smemcg %s\n",
-			(memcg_data & MEMCG_DATA_KMEM) ? "(via objcg) " : "",
-			online ? "" : "offline ",
-			name);
+	info->is_objcg = (memcg_data & MEMCG_DATA_KMEM) != 0;
+	info->is_online = css_is_online(&memcg->css);
+	cgroup_name(memcg->css.cgroup, info->name, sizeof(info->name));
 out_unlock:
 	rcu_read_unlock();
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
+				info->is_objcg ? "(via objcg) " : "",
+				info->is_online ? "" : "offline ",
+				info->name);
 
 	return ret;
 }
 #else
 static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
-					 struct page *page)
+					 const struct memcg_info *info)
 {
 	return ret;
 }
@@ -624,7 +644,8 @@ static ssize_t
 print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 		struct page *page, struct page_owner *page_owner,
 		depot_stack_handle_t handle,
-		struct page_owner_filter_state *state)
+		struct page_owner_filter_state *state,
+		const struct memcg_info *memcg_info)
 {
 	int ret, pageblock_mt, page_mt;
 	char *kbuf;
@@ -674,7 +695,7 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 			migrate_reason_names[page_owner->last_migrate_reason]);
 	}
 
-	ret = print_page_owner_memcg(kbuf, count, ret, page);
+	ret = print_page_owner_memcg(kbuf, count, ret, memcg_info);
 
 	ret += snprintf(kbuf + ret, count - ret, "\n");
 	if (ret >= count)
@@ -777,6 +798,7 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		 * user through copy_to_user() or GFP_KERNEL allocations.
 		 */
 		struct page_owner page_owner_tmp;
+		struct memcg_info memcg_info = {};
 
 		/*
 		 * If the new page is in a new MAX_ORDER_NR_PAGES area,
@@ -876,13 +898,17 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 				goto ext_put_continue;
 		}
 
+#ifdef CONFIG_MEMCG
+		get_page_memcg_info(page, &memcg_info);
+#endif
+
 		/* Record the next PFN to read in the file offset */
 		*ppos = pfn + 1;
 
 		page_owner_tmp = *page_owner;
 		page_ext_put(page_ext);
 		return print_page_owner(buf, count, pfn, page,
-				&page_owner_tmp, handle, state);
+				&page_owner_tmp, handle, state, &memcg_info);
 ext_put_continue:
 		page_ext_put(page_ext);
 		cond_resched();
-- 
2.20.1


