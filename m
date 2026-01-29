Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E23CD73E87
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:58:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D567F6B00B3; Thu, 29 Jan 2026 16:58:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4D156B00B5; Thu, 29 Jan 2026 16:58:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B43026B00B6; Thu, 29 Jan 2026 16:58:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9A6F66B00B3
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:58:25 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5679C13B0A8
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:58:25 +0000 (UTC)
X-FDA: 84386365770.12.8BEE843
Received: from mail-dy1-f195.google.com (mail-dy1-f195.google.com [74.125.82.195])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6D021C0002
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:58:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k2qq7NJv;
	spf=pass (imf10.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.195 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769723903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0za+mTabqTtCcABlRwV4DBkxWsk326LNSJGiU0z1JGs=;
	b=35FdaCFd6FVsp1gitqXLjcPMSCOemYXhaJyoNmbJxlBS+bJmuZo8koeAGzQKRd9Px3+zlO
	Dy5fYflAj4Tq6PGC1lxcU3G1digsJA7SiGlNhIPXQsui9fSWxern+EfOCkkqUOjOI01lRo
	uvZxjlVeAnzw2mK7CKnUHoRx1w/ADSY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k2qq7NJv;
	spf=pass (imf10.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.195 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769723903; a=rsa-sha256;
	cv=none;
	b=FinXcmPsh7uPZW//DzHG9IuAI5OTeqGhFd/2N6qx9Z5uhprV7pWrCVyRUVXU+ptfBv6/WK
	XYcYMp4YvRK4LrnvbcY5Twp7RMKxI8SYUKbsDnls90FiGrnjnhRo5WZSvmR4i55a2ylWZJ
	bu9BMLEUUEEfRRX/qx78CgO8HCYB/KI=
Received: by mail-dy1-f195.google.com with SMTP id 5a478bee46e88-2b720bb90d0so1565103eec.0
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769723902; x=1770328702; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0za+mTabqTtCcABlRwV4DBkxWsk326LNSJGiU0z1JGs=;
        b=k2qq7NJvvMtnH97T8VFuFgRPWHDTj9TWvJ2Pl+qldtjrH/KLMqcMgoP0rD5d9PbDGX
         LLkJYV3tpeeCMrS5SBnNuDuNFVEmB59DDvCwKEbBLWKK8tp4b7u8/TxYMf+qjDkTQNhE
         kre5Cg2BjiTmhJ5AP6QBAIUtQO/qdQJOP7+s5K5AiO78LxWt2ZEHBzErPkXZjOoIKbIt
         h3T7yVoBpLtafywtHMeGu/hFZDYIAmEXkgOheBt4E4kSG91LPRhubEhBd7Iz7WDo5feb
         6ZCzCxLBKYIaE0Wr3N/QRNiQB0CBhP705+eLyGLpZD6b+kYdTktStvSZ32QDk8bPvKDk
         aLOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769723902; x=1770328702;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0za+mTabqTtCcABlRwV4DBkxWsk326LNSJGiU0z1JGs=;
        b=JbVstzZUodotJq/is+VL7EEStOyrlt8fyY6mJjIGbFB5uSL5l40kb4HXftg3S+C4ve
         pPCXkUrGP2tgx+N5zeJSCR+RTsCzMEK8DvC+NeDfd881UW66jqqHYwIv3thqX+uHP1Ts
         fNXe69yt+6WEs2lAW1CwRmVdKrqbIpwz1vnAcfhiGqhOAXWLA/whHCAVKMeiZtJz6oRW
         fw/atAMLySInvStrRhu251m/+wJ6JbbtYHyFgGoMJNGqx6h6raUcFcygfb6Dqf8iJb1x
         lvAzWVHaXWVd+xorEUJokCXAogN3KHfg955O2GWtz4UOU5ZU0Ot59gf+p8RyeZy50Cfe
         Dmcg==
X-Forwarded-Encrypted: i=1; AJvYcCX1ZXE/ntMvg0XrzDMNFIDY5XQLNFft3e0Lp7gY+pZQDkcXljkxHt+HQoy61NhNqijHAFTqiM9RgA==@kvack.org
X-Gm-Message-State: AOJu0YyeFjS0y8pTeoRCVZsmhfR5r4Yu44A5KWcm4qNY384Vhs+CwELF
	+2BedmTCH39QECxhta6Mq399D9DEzDUqEprGkDhhOP5gf7/FUJ6xijg=
X-Gm-Gg: AZuq6aKvuptmHw2gHwWr3D0kHfwHjYEZ00KB8VL6FJqlh+hv/ly6Gk8kPebFx9Cw6Jo
	XBvap1tpFi4B5vvAMGrDvxgB9y2n/FoMv+bDVIm7kEHVQA5sBe/GkurEbkAtEa/WFNWa+BBw2gC
	7IYSST8hYs58DAUm52EqCHip+JGtb4PL8DK+wOwUR919a38xDnJgZ5/vTDE+WDlVri1CGLyp3OJ
	RbawL/l7uXoXpeufyw7pNHGPQIBT0iw1W0PyNeASYAqvalnR0UQkvjTAc7SL2xa57BrwMThRPmP
	0bpHzsnZDqnQiAOoHLndxR5sTOHCIPWXipq62k4VI/DTUfCcA16d4pPkF1PNZOfYkCD3S6Gcuru
	4lf2oyH7SUYQ54Yg9pIw7awh84KoNWJp6ltiNyf2X0c52uwWrGrmNbyn6kopxMagfZNCqCKXp0b
	sSwS0CKw559A==
X-Received: by 2002:a05:7300:bc05:b0:2ae:4f61:892e with SMTP id 5a478bee46e88-2b7c8903199mr438341eec.36.1769723902104;
        Thu, 29 Jan 2026 13:58:22 -0800 (PST)
Received: from localhost ([137.201.204.52])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b7a16ec51csm8713746eec.10.2026.01.29.13.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 13:58:21 -0800 (PST)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Subject: [PATCH 2/3] mm/damon/core: implement NODE_TARGET_MEM_BP metric calculation
Date: Thu, 29 Jan 2026 13:58:13 -0800
Message-ID: <20260129215814.1618-3-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260129215814.1618-1-ravis.opensrc@gmail.com>
References: <20260129215814.1618-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ocxhmkaa7jwimf1xk63hc9cagtxzfn4m
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6D021C0002
X-HE-Tag: 1769723903-226326
X-HE-Meta: U2FsdGVkX1/0dbohr4zVUSAgtzo6cSejCT40jFqt/OC/SYMAQEa3rvg52GlTTazhKQzAngKLnMubb8YDLqQSpy/bevLbfSxvuGLDMyOTvfoV0XbwplszVYwGGKQNPINaMEgZzeEu/f8orpKEZjFzpFQ88Uq69RLaLJX4Wv9wh4xX5KD2ifaO0o4iwwAfn9/eYEBOkplxzkJvGqE//Tr3ddTvRjdO8HFtxpz36rw6kZeRpo4naYMQnNfF9YCXNQ9ccQrR35MF9dTYv6TxV6KNEXDPupsQrueDsra/U+u81zaSi9DTZMdmR1fSvJ6JgfO8VeM5yFla7Dpw9MS7731ZsNZbSVW3pILtBQA1OxOwyg3h7MPGWISeXLIs0J3PFRIga6Dcwvi0WMWhgQiz11qMKMq64p7L6tGRKzTEd5VMkKLydPY3C3yeErDCgXGe/Hvto6o26bKEUyxMYAZw5BoIYKHr8/WbV3/nXyInCPockYIG+FODlbmAz8cVAXSvf5kDEdZZthBGpT/Vgmp7HI222SxhVA7RAnpI+siT0MgTzrt81rsfDeAWh2f7aeP+QgC2xHSIxRznKDPRv6ni/zboffawf+/Yw0RlO3tRUT61B8kFZ0aZp5044EIGGbaUqfpZR6dJ4vJInD998Qrusaa0M/YbHCaId+F0fux+9JLhitt8Rbr/eh3u+yXHjgy+Ia/UtZ3G9+tL1mGlmVVZAbAQ97yObNtO0i3qZ2+SNxdBdzJB9+UeOMOAWtjc+X4B23diDCSd1Jqhg85WFqm9hjM5c9krRES0qQL6pJK2cRNxO3N6Fg+7M+eT+lxpjA0aFN7hve6yuXAXlF1i5GDQ6suk9FqoQpY5ajS3hg/jMh2mZPdCEcnYYU01LKvqYYXXoP6AMgAPvlu06gE5F7IE/5dXFuCtOM/Ule0byb6+ETqJWdt07hSuuPcX9eNPDMaEC6268Znzebm2avfs6bPkkCv
 O+RDvTXF
 pr8v9u2Vj/DLIvV8QWrnyaT16C6GocQzysqV4ysjNzWWtATZ+BsAYAqX2bbib1qcmBNZZeZ28z8lX47CrdyunPkjHfnqs7rkc71SPmt0PJl8BrpkQN07czkJlZ1T8Yr2WNticbUpEGQa+GndA9gNzq4JLpX2Zv0zwPIpWKni0ymkj+Qql0/Ofm5IOT5IUpZU9C3Zt+nfuotQZlBpRzSsMPQvFB5TegBzhDKliE3IQuNZToBkvrYz3Y6gg7wDg39I2ETMhHkBMmBsG5BrSAT45W3btryMlScCpxemirB07FxRVVZgnZOd17cf4aWdGks4N28vPbXz8HJEd+GyCeSZM8qGya5c8lmqQshrfrFC8XFRKzzCjdc9LOpuIDK37JMlvIH2KoMuYo9XpALGugwZ26PML7TXCyMM0zXxZOYJf3jtYxI66h3h+Legk5xOg1KNpTE8XdzUzKTyaCZ/eAwjvTmKkWwdX72LV+UdIV6uU9EpjHwMGTEiCiHawfKcvgud31EVIWN9IJTS4de0DNN2TKHBHktOa+YONoP7QR0O/TfpcMRXovarHZYJKnSAhyvPph4bRZ5TebZcIk6YCdO1itD9RKS9tPQ+wZHS890+ljH24HcbiTIwHDwMA1p3mEzKNH9bX9DQGrB/8jq3lgTRH/KiNj6DUSAUSfHLQpdQOXCMX86tbnHgArYH1sF2Lnz6jDxMX+RPcx0jdCFlsoqEV5In66A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add damos_get_node_target_mem_bp() function that calculates the ratio of
scheme-eligible memory on a specific NUMA node to the total node capacity,
expressed in basis points (bp, 1/10000).

The function iterates through all regions that match the scheme's access
pattern criteria (checked via __damos_valid_target) and counts how many
pages from those regions reside on the specified node. This enables
quota auto-tuning based on the actual distribution of hot/cold pages
across NUMA nodes.

To support this new metric which requires access to both the DAMON
context and scheme:
- Update damos_set_quota_goal_current_value() signature
- Update damos_quota_score() to pass ctx and scheme through
- Update damos_set_effective_quota() and its callers

This metric is particularly useful for heterogeneous memory systems
(e.g., DRAM + CXL) where controlling the distribution of hot pages
across nodes can optimize memory bandwidth utilization.

Suggested-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 mm/damon/core.c | 66 +++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 59 insertions(+), 7 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 84f80a20f233..1482c97828e8 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -12,6 +12,7 @@
 #include <linux/kthread.h>
 #include <linux/memcontrol.h>
 #include <linux/mm.h>
+#include <linux/mmzone.h>
 #include <linux/psi.h>
 #include <linux/slab.h>
 #include <linux/string.h>
@@ -2119,8 +2120,52 @@ static unsigned long damos_get_node_memcg_used_bp(
 }
 #endif
 
+static unsigned long damos_get_node_target_mem_bp(
+		struct damon_ctx *ctx, struct damos *scheme,
+		struct damos_quota_goal *goal)
+{
+	int nid = goal->nid;
+	unsigned long node_capacity, scheme_node_bytes = 0;
+	unsigned long addr_unit = ctx->addr_unit;
+	struct damon_target *t;
+	struct damon_region *r;
+	unsigned long start_pfn, end_pfn, pfn;
+
+	/* Only supported for physical address space monitoring */
+	if (ctx->ops.id != DAMON_OPS_PADDR)
+		return 0;
+
+	if (nid < 0 || nid >= MAX_NUMNODES || !node_online(nid))
+		return 0;
+
+	node_capacity = NODE_DATA(nid)->node_spanned_pages << PAGE_SHIFT;
+	if (!node_capacity)
+		return 0;
+
+	damon_for_each_target(t, ctx) {
+		damon_for_each_region(r, t) {
+			if (!__damos_valid_target(r, scheme))
+				continue;
+
+			start_pfn = (phys_addr_t)r->ar.start *
+					addr_unit >> PAGE_SHIFT;
+			end_pfn = (phys_addr_t)r->ar.end *
+					addr_unit >> PAGE_SHIFT;
+
+			for (pfn = start_pfn; pfn < end_pfn; pfn++) {
+				if (pfn_valid(pfn) &&
+				    page_to_nid(pfn_to_page(pfn)) == nid)
+					scheme_node_bytes += PAGE_SIZE;
+			}
+		}
+	}
+
+	return mult_frac(scheme_node_bytes, 10000, node_capacity);
+}
 
-static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
+static void damos_set_quota_goal_current_value(
+		struct damon_ctx *ctx, struct damos *scheme,
+		struct damos_quota_goal *goal)
 {
 	u64 now_psi_total;
 
@@ -2141,19 +2186,25 @@ static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
 	case DAMOS_QUOTA_NODE_MEMCG_FREE_BP:
 		goal->current_value = damos_get_node_memcg_used_bp(goal);
 		break;
+	case DAMOS_QUOTA_NODE_TARGET_MEM_BP:
+		goal->current_value = damos_get_node_target_mem_bp(
+				ctx, scheme, goal);
+		break;
 	default:
 		break;
 	}
 }
 
 /* Return the highest score since it makes schemes least aggressive */
-static unsigned long damos_quota_score(struct damos_quota *quota)
+static unsigned long damos_quota_score(
+		struct damon_ctx *ctx, struct damos *scheme,
+		struct damos_quota *quota)
 {
 	struct damos_quota_goal *goal;
 	unsigned long highest_score = 0;
 
 	damos_for_each_quota_goal(goal, quota) {
-		damos_set_quota_goal_current_value(goal);
+		damos_set_quota_goal_current_value(ctx, scheme, goal);
 		highest_score = max(highest_score,
 				goal->current_value * 10000 /
 				goal->target_value);
@@ -2165,7 +2216,8 @@ static unsigned long damos_quota_score(struct damos_quota *quota)
 /*
  * Called only if quota->ms, or quota->sz are set, or quota->goals is not empty
  */
-static void damos_set_effective_quota(struct damos_quota *quota)
+static void damos_set_effective_quota(struct damon_ctx *ctx,
+		struct damos *scheme, struct damos_quota *quota)
 {
 	unsigned long throughput;
 	unsigned long esz = ULONG_MAX;
@@ -2176,7 +2228,7 @@ static void damos_set_effective_quota(struct damos_quota *quota)
 	}
 
 	if (!list_empty(&quota->goals)) {
-		unsigned long score = damos_quota_score(quota);
+		unsigned long score = damos_quota_score(ctx, scheme, quota);
 
 		quota->esz_bp = damon_feed_loop_next_input(
 				max(quota->esz_bp, 10000UL),
@@ -2227,7 +2279,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	/* First charge window */
 	if (!quota->total_charged_sz && !quota->charged_from) {
 		quota->charged_from = jiffies;
-		damos_set_effective_quota(quota);
+		damos_set_effective_quota(c, s, quota);
 	}
 
 	/* New charge window starts */
@@ -2240,7 +2292,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 		quota->charged_sz = 0;
 		if (trace_damos_esz_enabled())
 			cached_esz = quota->esz;
-		damos_set_effective_quota(quota);
+		damos_set_effective_quota(c, s, quota);
 		if (trace_damos_esz_enabled() && quota->esz != cached_esz)
 			damos_trace_esz(c, s, quota);
 	}
-- 
2.43.0


