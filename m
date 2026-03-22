Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CA871094481
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 03:03:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 873CF6B00BE; Sat, 21 Mar 2026 23:03:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 849BD6B00C0; Sat, 21 Mar 2026 23:03:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 786666B00C1; Sat, 21 Mar 2026 23:03:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 67F9D6B00BE
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 23:03:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E86E71B7060
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 03:03:21 +0000 (UTC)
X-FDA: 84572203002.05.8F91ADA
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3D3BC40005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 03:03:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Pi+LITmw;
	spf=pass (imf01.hostedemail.com: domain of rientjes@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774148600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fVSYBz8Z8p4RnssOWosJ/Ow1yuYWBSen1k8jPwBg8ro=;
	b=MsTRpz3APmVVcgcjX5nIG/K9EP60AwkA0hNaddbm+hqBlqPI3814ljKkdEtEXYT/bukUij
	JXZtdhnDJw2VYScc3mnxs34BEsH2bPjYVSirFecusNSHrpW+FP8d9CK9dhePXN08IPpYmq
	xVQgmDwuDrcVQ2gjbDYwhTMc54H/Tic=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774148600; a=rsa-sha256;
	cv=none;
	b=Tx2Tx1beTyiXzjyBbPhrdJ6KJk0+2dNP23EXgKK/tjAfWeh3QOrM90NGfXCW4IhJ+EXyWQ
	VFoQhWl3ptw0UxzxdQhvOI9KycWELT0lTz9+O6AXpi+WhCHTCBOO64JskmrmwykzKjooCA
	i2beB7slkn8pjM7NsxvADHYBmdqNkZ0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Pi+LITmw;
	spf=pass (imf01.hostedemail.com: domain of rientjes@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2b052562254so106385ad.0
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 20:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774148599; x=1774753399; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fVSYBz8Z8p4RnssOWosJ/Ow1yuYWBSen1k8jPwBg8ro=;
        b=Pi+LITmwHX7EyMa9Jf6cY6gLaizAI9EVoyt3f5V+ZvdjKayLeuS8zubMugBKdN7HiK
         Gq6R0wcHIONSdnZhfxl2a36Isvq0+ifvgX6HmAr+XcYTIGUDSTqitsORJ+q3/6+zH+yi
         xfMVOD1En4vAOg4I+pBn+DkqIZn9bTZDppW/5LP4M2+4UzUJYpb0KDABi+KCShT8QAnn
         e7V3s3xMsiDevwakpmj8FrZid1ZsNACXNbOWyd2jRs1cSPYOgIQTTr/NAc2U0UB8JfJf
         pzStTZfYbjQGSEa6z0iwol5z1ErUz6lcluOYbe2kHIHqH+obaSIo8TZfEAkele+xR2pZ
         CcPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774148599; x=1774753399;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fVSYBz8Z8p4RnssOWosJ/Ow1yuYWBSen1k8jPwBg8ro=;
        b=GZykrGY2qxKXYyQ/2n8+nTmgP8xXM/vm93XezW4oyHgl7QXJ+B+rHzcgBjXECM44K2
         UZ3V+GLdNAD2yAuQp0ZCTHEAnDpycf8WcUrM4/YYoio+fpUqF8MH22iItW1t8I+fE3Qw
         OLB+QMRXu3brBa9tZfrmY5DFOMhAFWs6eTqig25sJd/GENfzQM7xnSQVB51XLwGY7qIs
         jJ2xzWa3GD4BdxIpSV3iDQPugH/ztnDYOuaxZm7Jdf+G6UtRoR0dblu2G0uTaCsBLrMk
         t61w9b3+vsUc8CZMUIihqxcNkxA8MQE1mrgmJrh7gRbhuB817SUql2XqJpUDh9UoXe1r
         tnrg==
X-Forwarded-Encrypted: i=1; AJvYcCW+qNxwsHVy0Igek8iZT7FBQI7HSl5/7Y8YJtwGDSVq5R/8QT5pLQ6hKuKExn3l2YzufZ62V9cv/Q==@kvack.org
X-Gm-Message-State: AOJu0Yx6TeCBJMhQ+OLPtatscjcPBy+vSqQJiTYQjP8WbV5Se3bHvSr6
	Qn/ep57nUtk1anVwwyKQv/6Us+uFxlgN2o6/SlOtMuA7xuasWMvMrfeU3vA51CWByA==
X-Gm-Gg: ATEYQzxdnpXMPMTOEgCZTX+Mc8VPG3i/x+g+zA/JQUAgKt79gzfE0NttVqb8mrY3iFB
	2xBcXsHzXWNW9kozkCwPWbKtcngyuZDpF2/vUokjwI64Dc8wEMEb8zRnSNTWnmemGdsjHkPoeDr
	h/vJ9gFTvQC9xoPPeobx+dZbCr4ft2G4CP8ydvkpBiog0rquRom6BoVkZhZKZ8e7Yqh2h5yO6wE
	B7g8ojjpmSWr+Ya1CzE9Yi15RLQi46voIzh+rCuDvqHSwQ9LgfjSSINTkFaUGihu110fblu9xT4
	hKh/ajctl/pmcI28dKDhg00EQCACYEVRCj9l4yoyeN41ctBTZb5wrp+tFFt8Gjf2wTBHLffBHcM
	hePj/fJJdXffwqI4riDDXNpz2S2xSJcO1ylTxU4IqOWZ5effZKBk2aQR8J94fUl6LNeTPQOJJss
	XOI0m4AULEK3ikR5POTl0Hq3NZXDYSjraJ/HOcNA9pBiuFfyy914thprKfLPRWUE0jitwPadlSb
	6R7u9OafnF7pjsdRO2Tooq1Bp49yDURqLy8dWjmkAOKAqzhhGiJety33+kOxw==
X-Received: by 2002:a17:903:234b:b0:2ae:c566:bd99 with SMTP id d9443c01a7336-2b08b4fd93dmr2418915ad.22.1774148598281;
        Sat, 21 Mar 2026 20:03:18 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:95a:51de:9167:5c82] ([2a00:79e0:2eb0:8:95a:51de:9167:5c82])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b03be3396sm6104262b3a.27.2026.03.21.20.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 20:03:17 -0700 (PDT)
Date: Sat, 21 Mar 2026 20:03:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
    Vlastimil Babka <vbabka@kernel.org>
cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
    Brendan Jackman <jackmanb@google.com>, 
    Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [RFC] mm, page_alloc: reintroduce page allocation stall warning
Message-ID: <30945cc3-9c4d-94bb-e7e7-dde71483800c@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3D3BC40005
X-Stat-Signature: 3jktrh4dh5gfw4d5hh8hx593swjw8xyb
X-Rspam-User: 
X-HE-Tag: 1774148600-438169
X-HE-Meta: U2FsdGVkX19x7LD/NuWdzokreU9F5W8FuiUsO+Anz+nHEUOnZKTrr1Fvt5aX0l1hCcmDI5WFESb65xcP6i9j/llLl28w35yuIu6qGntrIbDMMi6lWp3abdIe3yxaxb5xPTC8psp7a8hm9uQtR93s6c69Ai2Cbmv3dAaszIbCXl46kCcLfifTaKVkMt/LUPdKzBawsLVNQfv43TOV773fiTopuw2dSY3mXU6+fk9+EyZs2xYS2LKb/FDz/8ZyM8qydb6Q6XoYbG69d6LJ6BJUCPxW9uu82NVFdy+DTXMm9WsqGdGvb2LFUf8DXGQztR4DWZ1OJp2ZJMnnB0eV9T6QRCa4ZSHCspKzsbQGO93K7J/srtsk3794+yLqftfDkYhNUdUqnqf9n0ZkgZALJaGv56zQ3SaBq+OHSqgIwItv0lPWrDPPkjMp/6RxeXPgIGNZ+c+W68VExkYoGohlm+EWgqSMML6z9W2qKztjtwA98A/iuxzF7wjP60Dy2ODc08x35UrRvP1B/LAeKRyMwG2ZMK1OpySB2kMWp1bukGBG3mj+/HY7E2qzEJEd1tmm6fwYXIb11Kilc/cp1MswgmXsHV35Q0TCEWQ0KZtqArnqfHXmOwA57x0DoYi63DvQLG6EJu9Umpvjv8L8GFulcW+tpChHKuVUUV/+8wOnjL4CzTxBdDXQHmekHDJhXvCwwoRebdbwMZdVjecrJA/P2r9boPDiH233Yybg5KV/3P8fubBZraaXEco0yyllBAl8sLt7uvQXc/86Ky49Jbn/lB7AKJhdfYMx40HSFdoifmIPpANn9tH3sPRqiYocieJnTQA2FggvrOk1c2sl3fZgSy35m8tRgX78qHnBmHfDh8XGIB93oxUKo6asap0587cbBrFJMFlAvJ/LuyW2kxV9LY+9fZgZGHzjZNMJBN5OrOCNHg2nHsTxGNlY/MuQqsff+vP2PzqHPRa3/mWQnQbFX/D
 BPDmZjUq
 rEmsdkMMaGibK54dCiSkTwcQjbhvjubk0MMmZX0OMjiUBW8w1lWy9x6/MDJReOUlHPUgpOe61odJityAb2mvPtLetxVa7Y1kqKTG1D7xmWkJI/4LxFhGZZNP5I20T5gzyN7GrK7bd2DGJ28KYPq7dXnlOzrqRY1ftOUY75H5s0iqTi5z3oSXyZkaKU+ASfm9XZddSxox/5siSeYuIeWHS/Q4S8c0ThKX0CnAFGqKucwzPij4y4Gkz6C6cqll6tXxzlNF1KgHASTSEVXnHNVCvJCNrXkFhIKkhCo2oGECc/VQ5R2WrCTykhumRycXayhdEzb/WthC25DXCQn0FLcTS0NBCuHc+94CTA2I20HJ4/tQumtWM/F7oL/dLsJlniuoT1qCsXvi+PgyfqEN1wP5BrEGFoYgSxz6IVz0vucszKuBHGx4Jk7s/ItGR2g==
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
warn about allocations which stall for too long") but for reasons
unrelated to the warning itself.

Page allocation stalls in excess of 10 seconds are always useful to debug
because they can result in severe userspace unresponsiveness.  Adding
this artifact can be used to correlate with userspace going out to lunch
and to understand the state of memory at the time.

There should be a reasonable expectation that this warning will never
trigger given it is very passive, it starts with a 10 second floor to
begin with.  If it does trigger, this reveals an issue that should be
fixed: a single page allocation should never loop for more than 10
seconds without oom killing to make memory available.

Unlike the original implementation, this implementation only reports
stalls that are at least a second longer than the longest stall reported
thus far.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/page_alloc.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4706,6 +4706,36 @@ check_retry_cpuset(int cpuset_mems_cookie, struct alloc_context *ac)
 	return false;
 }
 
+static unsigned long max_alloc_stall_warn_msecs = 10 * 1000L;
+
+static void check_alloc_stall_warn(gfp_t gfp_mask, nodemask_t *nodemask,
+				   unsigned int order, unsigned long alloc_start_time)
+{
+	static DEFINE_SPINLOCK(max_alloc_stall_lock);
+	unsigned long stall_msecs = jiffies_to_msecs(jiffies - alloc_start_time);
+	unsigned long flags;
+
+	if (likely(stall_msecs <= READ_ONCE(max_alloc_stall_warn_msecs)))
+		return;
+	if (gfp_mask & __GFP_NOWARN)
+		return;
+
+	spin_lock_irqsave(&max_alloc_stall_lock, flags);
+	if (stall_msecs > max_alloc_stall_warn_msecs) {
+		pr_warn("%s: page allocation stall for %lu secs: order:%d, mode:%#x(%pGg) nodemask=%*pbl",
+			current->comm, stall_msecs / MSEC_PER_SEC, order, gfp_mask, &gfp_mask,
+			nodemask_pr_args(nodemask));
+		cpuset_print_current_mems_allowed();
+		pr_cont("\n");
+		dump_stack();
+		warn_alloc_show_mem(gfp_mask, nodemask);
+
+		/* Only print future stalls that are more than a second longer */
+		WRITE_ONCE(max_alloc_stall_warn_msecs, stall_msecs + MSEC_PER_SEC);
+	}
+	spin_unlock_irqrestore(&max_alloc_stall_lock, flags);
+}
+
 static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 						struct alloc_context *ac)
@@ -4726,6 +4756,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	int reserve_flags;
 	bool compact_first = false;
 	bool can_retry_reserves = true;
+	unsigned long alloc_start_time = jiffies;
 
 	if (unlikely(nofail)) {
 		/*
@@ -4990,6 +5021,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	warn_alloc(gfp_mask, ac->nodemask,
 			"page allocation failure: order:%u", order);
 got_pg:
+	check_alloc_stall_warn(gfp_mask, ac->nodemask, order, alloc_start_time);
 	return page;
 }
 

