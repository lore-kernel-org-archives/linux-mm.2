Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 428571061B2B
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 01:21:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4925B6B008C; Mon, 30 Mar 2026 21:21:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 442E86B0095; Mon, 30 Mar 2026 21:21:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 358E86B0096; Mon, 30 Mar 2026 21:21:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 26D3F6B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 21:21:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 90F6A5B1C8
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 01:21:03 +0000 (UTC)
X-FDA: 84604604406.10.9E921D4
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf17.hostedemail.com (Postfix) with ESMTP id BD63840006
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 01:21:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BqiL3kNv;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of rientjes@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774920061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=crrmzM1Q7Xv/TEJHsW3iggtMROK5wI2Xln2hlSGHOm4=;
	b=1kKEuZryyIiMFbHzbIrre7M4s5ZaIJADN8www9pXNuIuke2ZrF6Qbfvbol+w88JUOdUKxh
	3So1NGqf7HMWGueV+Nz9Q79Zdk2zka5oEi0Dss8ov/UeIlB1nEmMTLnDoqvzSoPUgc6wZA
	nOveH+CdJexN8wQdtKRTrdAC7K92e+Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774920061; a=rsa-sha256;
	cv=none;
	b=snhnc7Buh+/LBxBTcsP/jeUxcE4lZuADIJ07h9mIvdlHoIsPrYsVKgUcTG8HE6bj3pTIkq
	xhMwt4MgPzIjTN/9BMahTCMO8D7HVDc9rJRggX0A71OQwMA21NVesUHWy5F2GOPFsltsPo
	dawgAanw1jXi3qbEQrxsjwdnOuwn2Eg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BqiL3kNv;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of rientjes@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=rientjes@google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2b243198058so25155ad.1
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774920060; x=1775524860; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=crrmzM1Q7Xv/TEJHsW3iggtMROK5wI2Xln2hlSGHOm4=;
        b=BqiL3kNv/r/j28qFHc4XMwHk64tupGDPL4nU5L3Fr6HQlK2HIYFI0AgNbq14kOSNwr
         FANu+8XOmew/ZZYpjo90ZiYAZUlFjFOx70Pi+XjWY8OjE2S4FdZ4jgKkNZYSv3fvH7YK
         Z/6kGBnyoq/msiu49CFMQfhCBUmxkWzy3BrdyipPIPTvSDk11mXjOBylDL6lDUdiz8sR
         CIc77FxZnrMM33Qmr4wi2GNYFImIg49YTeT0rbwszb99Xn/CI8LwD78+1s5SGc3uc72A
         H3wZvWn0H8zCgxm1c6DdqidJtLljAZJY3r+9iQFz52l97oKddO+usfsiCoygk/192SaN
         C//A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774920060; x=1775524860;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=crrmzM1Q7Xv/TEJHsW3iggtMROK5wI2Xln2hlSGHOm4=;
        b=JV4SdhPHMsR/7oZEiOgL8aeGAjnQ/VgZWGc835LDTL69Ln5W76WxgjuBLjjP212Xle
         oH2W4JnkbH1EjFCaMa5cR4gS2qNIAyeAPkb11XAcTRtaP+mTl10LhU0h+tOzXYzB53Wm
         7nhhRVSbSbil8Yvs51+3gD/kuwu01NUXnjEHU3VmDTZO8EGzypeBCmp4cUabdEJy33UK
         5x+T+dH1ybECqfZ3tMnRfhVbtjR7DR/9UrxvZTtV6/Rwrx1FoNBARnh03gebwvKmde2Q
         ttQdXdMKzG49X7dukJKq0YOFYjLsGed0NRbliUWURAZWlcCtgcVcShO9+dgGeKUw7yEz
         NiWA==
X-Forwarded-Encrypted: i=1; AJvYcCU2J+CHIQ5TMfas4BNZ72BdHJuCBAZ1oXAlvybSJKV0S2InXiO/Im/EkT/lhRbRkC68/DOIrwqxwA==@kvack.org
X-Gm-Message-State: AOJu0Yz4wcxRTGp1gw11U/MeaHnvi8bsFoMiHfaLwUyvtODrYh3ddlZW
	uRmjH5lBIvEv+L8kpVV3yqsCLckN67n8hs98pqtJVYVAEoz+AnMvYiVPXV+tcp3YHQ==
X-Gm-Gg: ATEYQzwTu9KUEiwul98M4mq8spa/X6WU8KR130hvOdqZcLDruNMCHUuk3GCblDHxt8j
	8LIoJ3iRig+WOzoeRp+b96mWhkh30hkqAyFuRBW2V7qcT+Hw3NM7ESGYHJPBScm8GWXewbuJdz9
	UG+WaqpWpY46X7elR4gv/n33GMQv/rLPUGuVqjnfsjsA8Awhh+zh6Mog8pDSp/c/lRNNldRhEQ3
	MDbNmNwoBFEGTd6hQr5uilp4lsP6KxuZ14kWgGjDiTSJCRD0yNbfi2keXgCObUO3ahCDjeK0+3w
	oNoVSrdzbhigWNuzFb9ovLJFI0tBxKTX44s8MknUUfcHkGaa6svuhbBR3ghgyS47Xx2XsUR8e2J
	kKd4eoEq6AKeJa/zS4cVRdFCUWbI7h+oX/CYNe6hZKUMf3cUMQmZIxufEYOTZ/fnsk+JFkUbjDn
	TYGY31yT0TEqif7uDAm9p5EBZ1ZQ6uWijOJMBe9/IxYNTrBNFfGCYxV4or+1cZ4T2XJOSAha5Ev
	iBfrYVycqrxprnw7W8Lb8kjwaXAr/RPKZLA7SOIM3Qpk1C/s7Cv6Yifa+28prkv
X-Received: by 2002:a17:902:db06:b0:2ae:4808:bd99 with SMTP id d9443c01a7336-2b25f72b1dbmr2168405ad.2.1774920059710;
        Mon, 30 Mar 2026 18:20:59 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:bec3:8e5e:fca2:7852] ([2a00:79e0:2eb0:8:bec3:8e5e:fca2:7852])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b24277fb3asm99685595ad.57.2026.03.30.18.20.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 18:20:58 -0700 (PDT)
Date: Mon, 30 Mar 2026 18:20:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
    Vlastimil Babka <vbabka@kernel.org>
cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
    Brendan Jackman <jackmanb@google.com>, 
    Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
    Petr Mladek <pmladek@suse.com>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: [patch v3] mm, page_alloc: reintroduce page allocation stall
 warning
In-Reply-To: <58a10940-e44c-a120-dd6e-ee9f480c4946@google.com>
Message-ID: <371c86c8-1d47-bd70-b74c-769842718b1f@google.com>
References: <30945cc3-9c4d-94bb-e7e7-dde71483800c@google.com> <231154f8-a3c3-229a-31a7-f91ab8ec1773@google.com> <58a10940-e44c-a120-dd6e-ee9f480c4946@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: BD63840006
X-Stat-Signature: 6p8wzbtd7ozey3pwewjx9se4ipsj9ea5
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774920061-671008
X-HE-Meta: U2FsdGVkX1/iX18+mlWQ9+FiJ4gx4LDSDULdtwwhxAcb44po1NQcftCQY2P0rk7mIdN2at++tn+RCKp9RwV2Wqeh1enBMtSg2HR8Se+f336BLu5SbylFTdirvV+7rg66fw5rS3733k0KIeKX0NA5Hn8Fxou9IVWQdWEyGJjfbI2jlXrPTDBUaEN1X00LOOdabGebHD0CN1+6Ez5tLXEaYQp1jkGLsAkxw0jEoMZPdu3FKl1wgFZQKc8q/X3LvAEFKzklLD6jvDbnAAaUbvjlNkWX+KVNsjWbRqnKXFC1Kxqx6K1YB+SsaLfpl+1Wa0LmNOn/rqffjB7/NA0eP0pi1dKEmFsiQtHKL7VSGuYEhUn6JD6jhLzkT/fCc7j+KrADL2sT8nleY1HUEo2+tx/Ts5nU0fWfIPnyojnSmGw8GelW2zOzx1CGw973Wtgw6HJBLJ5yC4PM5McpxMdAmo/iLU+uy0wQy7yuhEjtRzIo1ch69LCcTQ2Rke3oBEKqeQhmxxgZHbXyRdSh1Cwz1Xq6AGbQJLN6fQ/nObVrOjiPWKizhzqQv6jNT9umlUIlsiHb1MqfI+KGyvSzNdgecQU1FTmB7zuJKxmWYwHowGU7NaJOKy5YPktHzpGOody1kIYdMuglQNmSbTg5B89Bw4X/dvlaM1WkwlVqxkn4z/jr3NPjkFv+CSbXvVQcdK+RPhkmu8DsORMqcUMsdu8eocmshTtfIgBipRr6Juap06YwZ07FbpyaiELS1pXzrrWiKJmPko7N6FjpXR3IAI1JTr0k8m2jJPoE4G41Q0q7LZdzEs6gRxa33Ut/RgZaDesSL2szBh/o9dMAMbXrazyMhWZHcYwDt9H3eiqss0jvul5I8/cc66H5suncMdrpN7E7F2Az7XfyDOdQFIDYsB80AYlT1u1HTL+9n3XAued+5MJd8Ap7NaOJCvdSyrc5Pl6UHJ6oS0Ds4WTyvvFM0v4wtyn
 w0eiXzNt
 SYeVhmVICGVffYVHv3yVBiNTHSUWV/6y7mzdebcSgNdkTD/jvm+XHd9p1JDmLbRb2r31R0mlvZnxE8iLBAUMT+/LgMd5W4K0dP4FPIguaw2WncpGCJcwxEvaUuOl7R8VSNq43WErmFPohbHtlXm/i0cXGNXOztvRCahkOZctEDd9eyqLbbNB2VtchA/zeExCOL9CqPecNelFRRHCO8q1J10qv2vwiUELcIoRQJaaAQDmfBKjbSJQ9BJEyJ6wDr6O3fde2qOaXsAoMWKMzlm3+f5H3CH1YsCdGKfKDCWWe6APrQcm7hnGETkFbvBCl2hXSYrXvxVaUXN6Q1YqSopcSh2FDOQOatPcfgE/JaiOc+b5YN9REGOe9cN68NyJtDXpVIeuAJwhHc/b3cSA/OllfKRN5dHJh/uwlAbM3f3dXbpWdAPk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Previously, we had warnings when a single page allocation took longer
than reasonably expected.  This was introduced in commit 63f53dea0c98
("mm: warn about allocations which stall for too long").

The warning was subsequently reverted in commit 400e22499dd9 ("mm: don't
warn about allocations which stall for too long") because it was possible
to generate memory pressure that would effectively stall further progress
through printk execution.

Page allocation stalls in excess of 10 seconds are always useful to debug
because they can result in severe userspace unresponsiveness.  Adding
this artifact can be used to correlate with userspace going out to lunch
and to understand the state of memory at the time.

There should be a reasonable expectation that this warning will never
trigger given it is very passive, it will only be emitted when a page
allocation takes longer than 10 seconds.  If it does trigger, this
reveals an issue that should be fixed: a single page allocation should
never loop for more than 10 seconds without oom killing to make memory
available.

Unlike the original implementation, this implementation only reports
stalls once for the system every 10 seconds.  Otherwise, many concurrent
reclaimers could spam the kernel log unnecessarily.  Stalls are only
reported when calling into direct reclaim.

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 v3:
  - initialize to INITIAL_JIFFIES per AI review so warnings are not
    suppressed in the first five minutes after boot
  - time_before(jiffies, a) -> time_is_after_jiffies(a)
 v2:
  - commit message update per Michal
  - check_alloc_stall_warn() cleanup per Vlastimil

 mm/page_alloc.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -316,6 +316,14 @@ EXPORT_SYMBOL(nr_node_ids);
 EXPORT_SYMBOL(nr_online_nodes);
 #endif
 
+/*
+ * When page allocations stall for longer than a threshold,
+ * ALLOC_STALL_WARN_MSECS, leave a warning in the kernel log.  Only one warning
+ * will be printed during this duration for the entire system.
+ */
+#define ALLOC_STALL_WARN_MSECS (10 * 1000UL)
+static unsigned long alloc_stall_warn_jiffies = INITIAL_JIFFIES;
+
 static bool page_contains_unaccepted(struct page *page, unsigned int order);
 static bool cond_accept_memory(struct zone *zone, unsigned int order,
 			       int alloc_flags);
@@ -4706,6 +4714,40 @@ check_retry_cpuset(int cpuset_mems_cookie, struct alloc_context *ac)
 	return false;
 }
 
+static void check_alloc_stall_warn(gfp_t gfp_mask, nodemask_t *nodemask,
+				unsigned int order, unsigned long alloc_start_time)
+{
+	static DEFINE_SPINLOCK(alloc_stall_lock);
+	unsigned long stall_msecs = jiffies_to_msecs(jiffies - alloc_start_time);
+
+	if (likely(stall_msecs < ALLOC_STALL_WARN_MSECS))
+		return;
+	if (time_is_after_jiffies(READ_ONCE(alloc_stall_warn_jiffies)))
+		return;
+	if (gfp_mask & __GFP_NOWARN)
+		return;
+
+	if (!spin_trylock(&alloc_stall_lock))
+		return;
+
+	/* Check again, this time under the lock */
+	if (time_is_after_jiffies(alloc_stall_warn_jiffies)) {
+		spin_unlock(&alloc_stall_lock);
+		return;
+	}
+
+	WRITE_ONCE(alloc_stall_warn_jiffies, jiffies + msecs_to_jiffies(ALLOC_STALL_WARN_MSECS));
+	spin_unlock(&alloc_stall_lock);
+
+	pr_warn("%s: page allocation stall for %lu secs: order:%d, mode:%#x(%pGg) nodemask=%*pbl",
+		current->comm, stall_msecs / MSEC_PER_SEC, order, gfp_mask, &gfp_mask,
+		nodemask_pr_args(nodemask));
+	cpuset_print_current_mems_allowed();
+	pr_cont("\n");
+	dump_stack();
+	warn_alloc_show_mem(gfp_mask, nodemask);
+}
+
 static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 						struct alloc_context *ac)
@@ -4726,6 +4768,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	int reserve_flags;
 	bool compact_first = false;
 	bool can_retry_reserves = true;
+	unsigned long alloc_start_time = jiffies;
 
 	if (unlikely(nofail)) {
 		/*
@@ -4841,6 +4884,9 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	if (current->flags & PF_MEMALLOC)
 		goto nopage;
 
+	/* If allocation has taken excessively long, warn about it */
+	check_alloc_stall_warn(gfp_mask, ac->nodemask, order, alloc_start_time);
+
 	/* Try direct reclaim and then allocating */
 	if (!compact_first) {
 		page = __alloc_pages_direct_reclaim(gfp_mask, order, alloc_flags,

