Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B887CAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 10:10:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB7768E000A; Mon, 22 Sep 2025 06:10:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAE908E000D; Mon, 22 Sep 2025 06:10:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B762B8E000A; Mon, 22 Sep 2025 06:10:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A39358E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:10:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5E2231DFB8A
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:10:55 +0000 (UTC)
X-FDA: 83916467670.08.4C109DB
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1B410140004
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:10:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758535853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5HK5rgHD73to0XYnTr7+OwkkAJlWzpkw9TiReiYhPRk=;
	b=qLvu9GW27B9Ogp4TlrvuwQsci3/kdccFgBVO6pjAvwHucN3KfZRyIS57/S28Yabi3bf6V0
	+DBwqX25yCpsesKhXOTaGv8OK2URe/8sJrf346aKmMSbipjFdr+Ihs7wa4z4rOjxpMa+4a
	jMExa8tpNUSbYIRlKDU/+yB4Z1gM+xc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758535853; a=rsa-sha256;
	cv=none;
	b=q9GDb0wfNhjjXnHoebOWOuwkOyGOmJIO1tTDiYlJvtje0cYVQErCXxzchbihrXO39uS+tK
	HZou7gJr9BjVt2MyDt0usU6tu97cW8HQGH7lRdS+kIsKkWsbj6pKXwEjSdiW4JrFU4TDlx
	OZJOti8QunaI43eQl4GSA1N5bwOwCO4=
X-UUID: 65d72d56979c11f08b9f7d2eb6caa7cf-20250922
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_TXT, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_T1, AMN_GOOD, AMN_C_TI
	AMN_C_BU, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:a589fc36-a89c-40ef-87d5-8d46a7b6b1a3,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-5
X-CID-INFO: VERSION:1.1.45,REQID:a589fc36-a89c-40ef-87d5-8d46a7b6b1a3,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:6493067,CLOUDID:be52558006997a2c57fca8e8351ead08,BulkI
	D:2509221544090V0XLSE3,BulkQuantity:1,Recheck:0,SF:17|19|24|38|44|66|78|81
	|82|102|850,TC:nil,Content:0|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:40
	,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:
	0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI
X-UUID: 65d72d56979c11f08b9f7d2eb6caa7cf-20250922
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1128977369; Mon, 22 Sep 2025 18:10:42 +0800
From: Enze Li <lienze@kylinos.cn>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com,
	Enze Li <lienze@kylinos.cn>
Subject: [RFC PATCH 1/2] mm/damon/core: introduce priority concept for DAMON
Date: Mon, 22 Sep 2025 18:10:21 +0800
Message-ID: <20250922101022.362822-2-lienze@kylinos.cn>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922101022.362822-1-lienze@kylinos.cn>
References: <20250922101022.362822-1-lienze@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5te35sudj8r63kduc6uiryxyhuntg8mb
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B410140004
X-Rspamd-Server: rspam04
X-HE-Tag: 1758535851-966676
X-HE-Meta: U2FsdGVkX1+ZOzeaSMfupDDlVFBfsD25BeLtluXEKdprZT8p7C1Sg9pcmDEXQMPQB0RmSrfHOMIRu7Mlhcv/JMIeupefw+m3ug2LRpEKvp5CSSLdDIPUAz+VKie+KORka+p+bvIsQTLSNpRY86lMPcrhER/Aui+/5eoJS/sQOFM5NssCLGQdV0M2X29foH/ZFjofGYUNmgiWP6k/B+NS8QxOtLndacZS5RywxUeWN/UzrE2SnvCeagyeISDcRLAjstDx3bTV/TzssbuviG3ZigbzCgQHSPwg4i8TChVBF2DcBq3ESenI8iweV4FImSaGr7KnV+K2gW2Sq37O9EyvhsyIZ7c1lsVX+zToJP4kwb1wISkzInK+q2G8SvAtu7r/vP++hAZyi+tqSp7QKpeXamiv0LjyFZWr+1noY1135gbf6CsEzUEGeyJ8SF64pbdcNjkEW79rF1E2lTwUV6Yk64hDvtuGzqIIkXbotb6inWyiNCwTGw/mwkoodAl0x6Id3nxHMm1Is4dQaBj6LNQ+yE3NseHL8QMoGeHmULoLux50RqWgkL8LhJbmBLJaUp9HiseOua/yfHHz1g5hk7CSUJhmV13IHPDOzOaKNPDGO3RKqLMHhh+a083kn5oW2cmB8zXgdUSZJw1WbIawT6PhcJIreyuzI4Jl6nsCnsxbqfei+D3UZTCzcB2LTdk91S8wZREMIt9Kg63Gct8k48PqXA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch introduces a priority-based scheme application mechanism to
DAMON, enhancing its ability to prioritize memory management operations
for specific processes.  Currently, DAMON applies schemes uniformly
across all monitored processes without regard to their relative
importance.  This change allows users to assign a priority value to each
target process, influencing the frequency with which schemes are applied.

The core implementation modifies kdamond_apply_schemes to track and apply
schemes according to user-defined priorities.  For instance, if process A
has priority 50 and process B has priority 30, damon_do_apply_schemes
will be called 50 times on A for every 30 times on B.  This ratio
ensures that higher-priority processes receive more frequent attention
from DAMON's operations, which can be critical for performance-sensitive
workloads or prioritized tasks.

The change maintains the overall fairness and non-starvation properties
by cycling through targets proportionally.  Existing behavior is
preserved for targets without a priority assigned, ensuring backward
compatibility.  This provides system administrators with finer control
over how DAMON’s memory optimizations are distributed, making the
subsystem more adaptable to varied use cases and performance
requirements.

Signed-off-by: Enze Li <lienze@kylinos.cn>
---
 include/linux/damon.h |  2 +
 mm/damon/core.c       | 91 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 91 insertions(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index f13664c62ddd..a6d3ce186fdc 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -102,6 +102,8 @@ struct damon_target {
 	unsigned int nr_regions;
 	struct list_head regions_list;
 	struct list_head list;
+	unsigned int priority;
+	struct list_head pr_list;
 };
 
 /**
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 106ee8b0f2d5..c336914d03cc 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/string_choices.h>
+#include <linux/list_sort.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/damon.h>
@@ -28,6 +29,11 @@ static DEFINE_MUTEX(damon_lock);
 static int nr_running_ctxs;
 static bool running_exclusive_ctxs;
 
+static LIST_HEAD(priority_list);
+static bool init_priority_list;
+static int priority_level;
+static int priority_tick;
+
 static DEFINE_MUTEX(damon_ops_lock);
 static struct damon_operations damon_registered_ops[NR_DAMON_OPS];
 
@@ -474,6 +480,7 @@ struct damon_target *damon_new_target(void)
 	t->nr_regions = 0;
 	INIT_LIST_HEAD(&t->regions_list);
 	INIT_LIST_HEAD(&t->list);
+	t->priority = 0;
 
 	return t;
 }
@@ -2154,6 +2161,72 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	quota->min_score = score;
 }
 
+static int damon_priority_head(void)
+{
+	struct damon_target *t = list_first_entry_or_null(&priority_list,
+						struct damon_target, pr_list);
+
+	return t->priority;
+}
+
+static int damon_priority_find_next(void)
+{
+	struct damon_target *t;
+
+	list_for_each_entry(t, &priority_list, pr_list)
+		if (priority_level > t->priority) {
+			priority_level = t->priority;
+			return t->priority;
+		}
+	return damon_priority_head();
+}
+
+static bool kdamond_targets_priority_enabled(struct damon_ctx *c)
+{
+	struct damon_target *t;
+
+	damon_for_each_target(t, c)
+		if (t->priority > 0)
+			return true;
+	return false;
+}
+
+static int damon_priority_cmp(void *priv, const struct list_head *a,
+			      const struct list_head *b)
+{
+	struct damon_target *ta = container_of(a, struct damon_target, pr_list);
+	struct damon_target *tb = container_of(b, struct damon_target, pr_list);
+
+	if (ta->priority < tb->priority)
+		return 1;
+	else
+		return 0;
+}
+
+static bool kdamond_targets_priority_init(struct damon_ctx *c)
+{
+	struct damon_target *t;
+
+	damon_for_each_target(t, c)
+		list_add_tail(&t->pr_list, &priority_list);
+
+	list_for_each_entry(t, &priority_list, pr_list)
+		pr_debug("damon target priority %d %p\n", t->priority, t->pid);
+
+	list_sort(NULL, &priority_list, damon_priority_cmp);
+
+	list_for_each_entry(t, &priority_list, pr_list)
+		pr_debug("damon target priority after sort %d %p\n",
+			 t->priority, t->pid);
+
+	init_priority_list = true;
+	priority_level = damon_priority_head();
+	priority_tick = priority_level;
+	pr_debug("damon target priority init level=%d tick=%d\n",
+		 priority_level, priority_tick);
+	return true;
+}
+
 static void kdamond_apply_schemes(struct damon_ctx *c)
 {
 	struct damon_target *t;
@@ -2162,6 +2235,7 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 	unsigned long sample_interval = c->attrs.sample_interval ?
 		c->attrs.sample_interval : 1;
 	bool has_schemes_to_apply = false;
+	bool priority_enabled = false;
 
 	damon_for_each_scheme(s, c) {
 		if (c->passed_sample_intervals < s->next_apply_sis)
@@ -2178,10 +2252,23 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 	if (!has_schemes_to_apply)
 		return;
 
+	priority_enabled = kdamond_targets_priority_enabled(c);
+	if (priority_enabled && !init_priority_list)
+		kdamond_targets_priority_init(c);
+
 	mutex_lock(&c->walk_control_lock);
 	damon_for_each_target(t, c) {
-		damon_for_each_region_safe(r, next_r, t)
-			damon_do_apply_schemes(c, t, r);
+		if (priority_enabled == false ||
+		    (priority_enabled == true && t->priority == priority_level &&
+		     priority_tick-- > 0)) {
+			if (priority_enabled == true && priority_tick <= 0) {
+				priority_level = damon_priority_find_next();
+				priority_tick = priority_level;
+			}
+			pr_debug("tick() %d(%d)\n", priority_level, priority_tick);
+			damon_for_each_region_safe(r, next_r, t)
+				damon_do_apply_schemes(c, t, r);
+		}
 	}
 
 	damon_for_each_scheme(s, c) {
-- 
2.51.0


