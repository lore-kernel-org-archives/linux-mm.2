Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86034C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 12:53:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 939366B00CF; Mon, 17 Aug 2026 08:53:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9115D6B00D1; Mon, 17 Aug 2026 08:53:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84DA76B00D2; Mon, 17 Aug 2026 08:53:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BCD36B00CF
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:53:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E1C63140791
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:53:52 +0000 (UTC)
X-FDA: 85110753504.01.A9E935A
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf13.hostedemail.com (Postfix) with ESMTP id E20FC20008
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:53:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786971231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=s9kMlK+9Ednt+8x+J5DZ2/8j8ewjoCzUCoaumSzXCZE=;
	b=IcsUTrIdvcuStyFr+PFHOYOSO6ECDCLzfcqstcicGCU80Xjv1LakC2vgvak7Symvq4U/HE
	+qZlESWV2vPPBxToHVSO0jYlv0Ry1jh0EA07paAbFlv7oIIYX1zLAkJPTwMrlwWASNDrXs
	H5Y6aQjVBoCHG1ERBjOG/9IT2zcdzU0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786971231;
	b=ndrEwU52JRixMij+c7EDbk3Z4QdAWtP13J5seYZid0+wwW9kEhSK3iszWybPbSmGppvCL1
	8v85DgNDURG7AOB9NGe+scgV0LDKud18MMGK8vdi0jPOiGxoc5JcUCMMmP0TKGocjhPKLX
	lamFIFFSP+1+53n7RAzCX96qi1FzHMg=
X-UUID: a87ee1169a3a11f19a56ed5b684f684d-20260817
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_UNTRUSTED, SRC_UNTRUSTED, IP_LOWREP, SRC_LOWREP, DN_TRUSTED
	SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:9d81e917-8b7e-4b49-bcdd-4cb416522e83,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.19,REQID:9d81e917-8b7e-4b49-bcdd-4cb416522e83,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:7db8b62,CLOUDID:725b431d360468d5390744ffeb8ec87f,BulkI
	D:2608172052115L9JT3TD,BulkQuantity:1,SF:17|19|38|66|78|102|127|865|898,TC
	:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:40,QS:nil,BEC:
	nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a87ee1169a3a11f19a56ed5b684f684d-20260817
X-User: lienze@kylinos.cn
Received: from ubuntu.. [(61.48.210.10)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1187589918; Mon, 17 Aug 2026 20:53:35 +0800
From: Enze Li <lienze@kylinos.cn>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	enze.li@gmx.com,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH] mm/damon/core: introduce damon_set_target_pid()
Date: Mon, 17 Aug 2026 20:53:19 +0800
Message-ID: <20260817125319.888994-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E20FC20008
X-Stat-Signature: zdso3wirem1s3iq3e8749u9uupwdwhpj
X-Rspam-User: 
X-HE-Tag: 1786971229-373962
X-HE-Meta: U2FsdGVkX18D4QX5iVyRM2iJIJT76FjRrpbG1B3/Vxih6dXwhr/j4d04VGt8vfgyHc9N7MnVlEG+T885Dgx25IDYH/DltCMiHgTCeuNJeU0SX7YIg4B9Diz9yrDPpCCwWZ3Zcb3Ah0vgyFiIaU24KpIrRYJVarUTgUi+cHa+4QU2GOj2OQtKeDpbtLyk2JhJsIqb7HP+oukpV1PVU/ydNkeDCoLqjs6kBgTbEKQbbbHM4fxHZ7U7b4npEqvCY/2FPoDbQwhMSMxnwPQZEua4NGpp2RGExjfIDSge9jf7P7N/4it+yY0USFGClaR40t6fMirR+5lP2RDA38Ldl5W13+7t7JVah7y5Mfh9M3Q515WclK9qeifBFKnJX/JkAxJtPHQT8UfUYHaErksN9w++chaUyK380FYimfqZjR4h941rQUrjFENDalMJawcpQ4E+ml5nH6ueaYBd5wDKl6B4yk9JWz17JDg3J2Et6NvgdRmqYh6NGVvoq1F50JlDX4iHhI2jbw7lvE6TBIHmaKQxstChSuFYC7pqFW/nijJT1lmyb0ftw3n/y0j6O2JSJ0NoXMLGQ+ZFYFYMgpsSMaIyL/gIfHEa5uxehRHxl/he+Vy3CPNFA6u12cyvQ9rLMsIkpJDgcOj4i/GOrvF46o0WEwEH/nIdmfu7eYEL3sG0GzlA1AU5RQSYfnUl5b8xtj4r9+AJXgVJ1nVPCuDj2uscM0NP+kvVqLSaFlMEJlvNM7+iq1birLFa+/JZqJQQPczeb4EpItaRPZoVf06YAIPh2tGyNqyCboIC2AU4NLIYupEP63/DrK1WCVvA+NoiXLEtQ6ejBs6JYnMpRAmPay3R8EAKhe25cVW3lRh/ZdBWEUrmy07OZ/ZHSUCliEYb6RBq5eRR2AefEBiKHEZDzM9ZbjZctSv8ERNGJrYDC94boReA792Fx8ZaxsbHLwjb0OT0FpUgC5y8ccsD2c5Y55J
 TyYEfiw0
 piNs5Fc2idt2GQZk5dxmw5FVciM0Zr3X++E38/gj7Asut3dk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The logic that finds the struct pid for a given pid number and assigns
it to a damon_target is duplicated in multiple places.  Including
damon_sysfs_add_target() of mm/damon/sysfs.c and the start functions
of the two sample modules, samples/damon/wsse.c and
samples/damon/prcl.c.  Add a function that does the work, and replace
the duplicated code in the places with calls to the function.

Signed-off-by: Enze Li <lienze@kylinos.cn>
---
 include/linux/damon.h |  1 +
 mm/damon/core.c       | 12 ++++++++++++
 mm/damon/sysfs.c      |  6 ++----
 samples/damon/prcl.c  |  5 +----
 samples/damon/wsse.c  |  5 +----
 5 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 0c8b7ddef9ab..a937aa55170b 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1054,6 +1054,7 @@ int damos_commit_quota_goals(struct damos_quota *dst, struct damos_quota *src);
 
 struct damon_target *damon_new_target(void);
 void damon_add_target(struct damon_ctx *ctx, struct damon_target *t);
+int damon_set_target_pid(struct damon_target *t, int pid);
 bool damon_targets_empty(struct damon_ctx *ctx);
 void damon_free_target(struct damon_target *t);
 void damon_destroy_target(struct damon_target *t, struct damon_ctx *ctx);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 644daf5a1656..82b196407ae8 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -10,6 +10,7 @@
 #include <linux/kthread.h>
 #include <linux/memcontrol.h>
 #include <linux/mm.h>
+#include <linux/pid.h>
 #include <linux/psi.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -795,6 +796,17 @@ void damon_add_target(struct damon_ctx *ctx, struct damon_target *t)
 	list_add_tail(&t->list, &ctx->adaptive_targets);
 }
 
+/*
+ * Assign the struct pid of the given pid number to the given target.
+ */
+int damon_set_target_pid(struct damon_target *t, int pid)
+{
+	t->pid = find_get_pid(pid);
+	if (!t->pid)
+		return -EINVAL;
+	return 0;
+}
+
 bool damon_targets_empty(struct damon_ctx *ctx)
 {
 	return list_empty(&ctx->adaptive_targets);
diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index e3858ffab4b2..3c81b4c91ac0 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -3,7 +3,6 @@
  * DAMON sysfs Interface
  */
 
-#include <linux/pid.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 
@@ -2035,9 +2034,8 @@ static int damon_sysfs_add_target(struct damon_sysfs_target *sys_target,
 		return -ENOMEM;
 	damon_add_target(ctx, t);
 	if (damon_target_has_pid(ctx)) {
-		t->pid = find_get_pid(sys_target->pid);
-		if (!t->pid)
-			/* caller will destroy targets */
+		/* caller will destroy targets */
+		if (damon_set_target_pid(t, sys_target->pid))
 			return -EINVAL;
 	}
 	t->obsolete = sys_target->obsolete;
diff --git a/samples/damon/prcl.c b/samples/damon/prcl.c
index 842099bd6228..83ddf12811d5 100644
--- a/samples/damon/prcl.c
+++ b/samples/damon/prcl.c
@@ -32,7 +32,6 @@ module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
 MODULE_PARM_DESC(enabled, "Enable or disable DAMON_SAMPLE_PRCL");
 
 static struct damon_ctx *ctx;
-static struct pid *target_pidp;
 
 static int damon_sample_prcl_repeat_call_fn(void *data)
 {
@@ -79,12 +78,10 @@ static int damon_sample_prcl_start(void)
 		return -ENOMEM;
 	}
 	damon_add_target(ctx, target);
-	target_pidp = find_get_pid(target_pid);
-	if (!target_pidp) {
+	if (damon_set_target_pid(target, target_pid)) {
 		damon_destroy_ctx(ctx);
 		return -EINVAL;
 	}
-	target->pid = target_pidp;
 
 	scheme = damon_new_scheme(
 			&(struct damos_access_pattern) {
diff --git a/samples/damon/wsse.c b/samples/damon/wsse.c
index 37fd5da20158..53944aea8428 100644
--- a/samples/damon/wsse.c
+++ b/samples/damon/wsse.c
@@ -33,7 +33,6 @@ module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
 MODULE_PARM_DESC(enabled, "Enable or disable DAMON_SAMPLE_WSSE");
 
 static struct damon_ctx *ctx;
-static struct pid *target_pidp;
 
 static int damon_sample_wsse_repeat_call_fn(void *data)
 {
@@ -79,12 +78,10 @@ static int damon_sample_wsse_start(void)
 		return -ENOMEM;
 	}
 	damon_add_target(ctx, target);
-	target_pidp = find_get_pid(target_pid);
-	if (!target_pidp) {
+	if (damon_set_target_pid(target, target_pid)) {
 		damon_destroy_ctx(ctx);
 		return -EINVAL;
 	}
-	target->pid = target_pidp;
 
 	err = damon_start(&ctx, 1, true);
 	if (err) {
-- 
2.43.0


