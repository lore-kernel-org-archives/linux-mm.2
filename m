Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6833B606A33D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kPczQ7Sw
Received: by kanga.kvack.org (Postfix)
	id 62CBE6B05D3; Mon, 23 Nov 2026 09:19:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 605A56B05D4; Mon, 23 Nov 2026 09:19:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F3F46B05D5; Mon, 23 Nov 2026 09:19:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1E7C66B05D3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:19:38 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 99285C08E7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:19:37 +0000 (UTC)
X-FDA: 85466591994.26.925F4A6
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	by imf17.hostedemail.com (Postfix) with ESMTP id C723B40005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:19:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=kPczQ7Sw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795443575;
	b=FodZal/v2P3I9nPlYW8OXLVsFoBlmDiN30u8v654KH4LCzI0J+kgdIravKnrQEmDUIhr/E
	Vnxv+DujVs79Ba3xO9rptK9OVo93hTqdlFZPttDlgyhAkaxaNUL0xgoeSuAdceX6KQ9yqb
	Z+JFfHq0k1htNbX4kmWjwyic6Cx3h68=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795443575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ftZ9KCAoOVfHj2aG9QGbjRXPabmKfwf/abxcx+jklUw=;
	b=NTTZ7E06Ws7E1iAp/rUvXk5r+skpJKit5TZXwN/hoV8yDD8fsZXGyvBu/mfyjGY01ns5zb
	row26FUF7M96tHq+unigTmiMyAiCfUgFbs6RvV9CSOUOEi8DmoG+/5Wy5agDBcIcb6TdPi
	eMtjICJSecHMUWDptz2L7w0p0gmwfeU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=kPczQ7Sw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-386b8f2f671so404780eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:19:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795443575; x=1796048375; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ftZ9KCAoOVfHj2aG9QGbjRXPabmKfwf/abxcx+jklUw=;
        b=kPczQ7Swopd25u/4MO5y/WO5DvIYSvLkqrlUISc/QjkMfcYETYjqQ2b3BuPwcZh2ta
         QJD4wAQyHyMPgOzMAuwDJOKLmcrHnNG5D9PnFUE/q9do0c+X0V7ivplOfCXnF/W7dUiy
         tBjmaYVmfAmbGoJtGEez0bVtVHsMV9pOYS927pfCDx97g/j3k9SKMZazXji4yxn8m3kR
         e+5v+T7eStx4aHYnVloKJ0H5X+4jJw6h1jo8mRrPkhdIR/V5kq/RGxWacYlTkwyT4giC
         uWnvA6u7yOZc8uQEfI4ZXFlIdjBuLYCTQ6I7ajV8LceOuZmJZAb9FKsF9zWByzKaORA2
         wqgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795443575; x=1796048375;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ftZ9KCAoOVfHj2aG9QGbjRXPabmKfwf/abxcx+jklUw=;
        b=o2mIn03HEzeF3jLvbFnV4dYsJi0qgUPrs+ye2iqOGsjRIKIKrQD/jrSShGaSdo9RSi
         IyyfnCdgbm8vKGY/3hzVw4q3fljSSu3wzUHdahDm5PFmljIdtEKHLQDZQO7a5485vm/V
         cIbY2grFVaft30LSgNq1aGLqnA1qLjWBUgep9AvjzfpNh46mvb6w3LWrQ79Wxe9E1TEP
         FwNV30IxxaiPCx2R95Hl4LNi762oLEZtQMXo2p5O0DUKiL+m6/00Mu1KzJ+1zD0Kb4nA
         hPb8rEHqj6m8khcdQsFf1COWOuhGo+WK6QJkoFT+IN4T31dwND/G7zgPEz8vBOMZ+c6b
         1P0A==
X-Gm-Message-State: APuU4Z++Rqfmlj/o80v5al9Hpo71HPJ6YhrVwQ/HBPbhG0P70njvxsAc
	mH19ooYWlA6I2xVdOsznGLwOKo7sJGKB+3bM20vJk5mIFYYGRFVM4Jc3eqj618Vt
X-Gm-Gg: AZFdTZfdTiwg5Ctdfn8VaxQg2bi04r0eTOcdyotSgA4ZfR5mEIy3CaaAl/JtTa2ueBn
	vV3jv6xJ7nsgzQpPVYm+8aLpx0I7ZPFG8TJrU3VmxuhkznEsAr75WYjDLOEMdn/UH5TODoSgTy6
	XM0zWA1S+Oik5Z6MCiUN/2+cCT2gn8ScBiO6YUzUtyCfiEV2KF6aERHlIjvSejQV59dPT4jmEfB
	1NwbOIyTI1KEnWZRvFZstENXmIcdL2pxzjWH5OiKI3TlKYXptLJiDVmfQt80vbikehDRpMSEEHm
	PP2C8qsaS9mPYphP8CTwqdG0DHJYd96U5Popa4A0m/zUQdFl8XX/lI1/Aa98sgo+cOs/Vx1xajo
	UNyrTgQxnBmuNNJDOoVZHa2ynhLc+TKO2RxDgbAFBkVPCiyraGj7Ow6ErihXkv/tjDdIOSzJbLN
	94sKECHgK1TP2dKTCOQwWlWlHC00GyrIQewAYzCIflTMmMa8UoGRF4hAQATmu2IBORIdJv5oIJ4
	f4vv8+gG4dCV1F+Zmk4xB4HQ2GMzLL4+pwexcbP5u/Hm19yUvJSXEr+gMeVD1GymkjHWCHxN5pW
	u0RVMNeDytvjkdMZLviMoFQ2pC0xh5V/tpG+1qIyjsYhZoh5ZGGY8gZD427CSDzZ5uja
X-Received: by 2002:a05:7300:2202:b0:36a:1e9e:ae61 with SMTP id 5a478bee46e88-3857170afa1mr17567764eec.38.1795443574544;
        Mon, 23 Nov 2026 06:19:34 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567abb870sm30652112eec.25.2026.11.23.06.19.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 06:19:34 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH v5 15/19] lib/plist.c: remove requeue function
Date: Mon, 23 Nov 2026 22:19:23 +0800
Message-ID: <939710bc5e908b4e30d86aecacfca0524ef11d6e.1795439990.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1795439990.git.lianux.mm@gmail.com>
References: <cover.1795439990.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C723B40005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: soyd4cwwxj97ob8f6bz48e5kj988f4px
X-HE-Tag: 1795443575-112143
X-HE-Meta: U2FsdGVkX19IDkB7AuAf9F6FxOZiF1OyTVHxXh3AhY709VuEuhLbRtmhjdqILfYFM5Evtd5DFv2uVjugdgeJkL/2eT1DFieplm4BX9bxh1ZYWer++fs4JDvRCUTk7lBDwHDif9T8kIQUXT6ISgkKmWC6myk5j5p6igOITySQnwiGb0mPRf2f8+SRfeMywdTswXgY74rKEKpCbkQzMCG//atP8LJiumomJvu7FnvGph6to9/8Bq4NUmszVLezEmNT4gxq+UWDsXUt1Nt4ST7lIwuBnV8XMed9M2UEMPUsorvvZK4hiqER+vbSOHcCcND0Nta3YwgMWZ4njylWajG1SMQugzvcoeVK2AcZkg1/xuNCpC3sPMHarpp+b4SrID+6zf3OS9vL+F/dsYNLbSINYB2zDKkjktAU7mDdzTxw4646V4Kp7o1zDRHqT3tdbE3u6ZtXSM2bVSiJU2wpUe55Tr1w/BWnT6ltJYyW41pCVCcj7mfI94YI5CyxhZY73uXxtZy9ztEwkVILrXKAiEncGxH9C10rPUCe2jN8Z5ptSGILOMlWbc62RjFMBYJbioR/UPZSEUHgP1FiIWnqZ7qnGk6NuB4KrD1Ee97u2l9ONCrfdk0JUy3VIBML7cjw/rMTwJ3yCcfNA6TniNcYRVMJNU77seBJQ3bx3L1nTKEiKmIlrQh7nvApyH7OclrMk4gmXBGbUrbUu/v5JN1kbRJFdTdG/X+HKUfiOL/VM1SWUV0oiAvVTXzk8aMZBl1GpBq452L46AjCBbxj6uNjgvuTMccSOywbHfpLWKYKEwpRaIYzdfNUFP3WKuyGQQleEWGjbidiAOz23wCXzX7Rz9eo1J0dZoi3R0YB39aPrMyypaLT2xR6Rh7yc/RhZIBbMoLS+PO+Jpvbq67D2ub8mjqfaU9rNEiUg3jWDOiA7E4oxyM2V8NIeiLnjiBDobCutL49SI8z7eAZExd0TNH+X4X
 Iz1dCG3R
 5C0Xwg8T1j45Hs55VymK9hR2lLBQdRIOar90gE9SKUVMuimHdypAOfXU6MTrypy0jLd50kh5HOCkQ6N1z5f9nfwSVuxzHsP41T0rdcCAHPAy77aJyZuW4miOsz5qayEv+iQSaq9LnfLYzlwZOrQfpcCSTilo7net2TwmOHRmG2c+FApjaIre7hjqSRHe/3Kf17QC4Yt0jtZLtke2H9v2L3R2C5/nAnSqHKYP+ZUAvd05bMuWHh7azawjMLHg8/kEN55PdGlqgn23OEBxvvMWuYq7eMBCdlwiVaJyxHwau5k9xecIH/A5OZABfSpc0b/OxblEJSzR1pg9K6QXjl6QzoQNbzYqYCvSLqKzwKtBQg26gXT9yWNHIt4xJTIh1fF5+Ge/eWz0qgPn+pzUV8mp2l1V4DZDQ7tIHkzYpojAJiUL5HxrRYKcpwMYUKeeXpfuJpExAqmghTsZd5WYFuEoY+E5Up4R4roenkAg8pDvXYwbnvZvP9FVcFpOikDkMT+egRl/Cu45PC7DvLWNTr7VEVbZXR8u8Xe4kRZ3/WB1LyyAfUYk1IhryNtGAMXioPJDdCCIqWKLMLgd99IAdZhjNCY3MuTn7dqLb0UoWru765e5jBecVwMmLQmGF2KMAYVGxisqVL6lzx2WGffZ9ULOYOAfP9OK6POGC8gG5E9W6wq3hobTa2qiPelbJ1kRu+haPRFd/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

Now the last user of plist requeue is gone, this function can be
removed.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 include/linux/plist.h |  2 --
 lib/plist.c           | 71 -------------------------------------------
 2 files changed, 73 deletions(-)

diff --git a/include/linux/plist.h b/include/linux/plist.h
index 16cf4355b5c1..73d359c1a053 100644
--- a/include/linux/plist.h
+++ b/include/linux/plist.h
@@ -132,8 +132,6 @@ static inline void plist_node_init(struct plist_node *node, int prio)
 extern void plist_add(struct plist_node *node, struct plist_head *head);
 extern void plist_del(struct plist_node *node, struct plist_head *head);
 
-extern void plist_requeue(struct plist_node *node, struct plist_head *head);
-
 /**
  * plist_for_each - iterate over the plist
  * @pos:	the type * to use as a loop counter
diff --git a/lib/plist.c b/lib/plist.c
index b0273533c04d..b05ae7ffea87 100644
--- a/lib/plist.c
+++ b/lib/plist.c
@@ -142,65 +142,6 @@ void plist_del(struct plist_node *node, struct plist_head *head)
 	plist_check_head(head);
 }
 
-/**
- * plist_requeue - Requeue @node at end of same-prio entries.
- *
- * This is essentially an optimized plist_del() followed by
- * plist_add().  It moves an entry already in the plist to
- * after any other same-priority entries.
- *
- * @node:	&struct plist_node pointer - entry to be moved
- * @head:	&struct plist_head pointer - list head
- */
-void plist_requeue(struct plist_node *node, struct plist_head *head)
-{
-	struct plist_node *iter;
-	struct list_head *node_next = &head->node_list;
-
-	plist_check_head(head);
-	BUG_ON(plist_head_empty(head));
-	BUG_ON(plist_node_empty(node));
-
-	if (node == plist_last(head))
-		return;
-
-	iter = plist_next(node);
-
-	if (node->prio != iter->prio)
-		return;
-
-	plist_del(node, head);
-
-	/*
-	 * After plist_del(), iter is the replacement of the node.  If the node
-	 * was on prio_list, take shortcut to find node_next instead of looping.
-	 *
-	 * prio_list is a headless ring, so from the LAST bucket ->next wraps
-	 * round to the first one; in that case node_next is the list head.
-	 */
-	if (!list_empty(&iter->prio_list)) {
-		struct plist_node *first = plist_first(head);
-
-		if (iter->prio_list.next == &first->prio_list)
-			goto queue;
-		iter = list_entry(iter->prio_list.next, struct plist_node,
-				  prio_list);
-		node_next = &iter->node_list;
-		goto queue;
-	}
-
-	plist_for_each_continue(iter, head) {
-		if (node->prio != iter->prio) {
-			node_next = &iter->node_list;
-			break;
-		}
-	}
-queue:
-	list_add_tail(&node->node_list, node_next);
-
-	plist_check_head(head);
-}
-
 #ifdef CONFIG_DEBUG_PLIST
 #include <linux/sched.h>
 #include <linux/sched/clock.h>
@@ -238,14 +179,6 @@ static void __init plist_test_check(int nr_expect)
 	BUG_ON(prio_pos->prio_list.next != &first->prio_list);
 }
 
-static void __init plist_test_requeue(struct plist_node *node)
-{
-	plist_requeue(node, &test_head);
-
-	if (node != plist_last(&test_head))
-		BUG_ON(node->prio == plist_next(node)->prio);
-}
-
 static int  __init plist_test(void)
 {
 	int nr_expect = 0, i, loop;
@@ -269,10 +202,6 @@ static int  __init plist_test(void)
 			nr_expect--;
 		}
 		plist_test_check(nr_expect);
-		if (!plist_node_empty(test_node + i)) {
-			plist_test_requeue(test_node + i);
-			plist_test_check(nr_expect);
-		}
 	}
 
 	for (i = 0; i < ARRAY_SIZE(test_node); i++) {

