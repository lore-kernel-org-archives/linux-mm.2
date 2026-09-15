Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00DB2C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:13:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EB066B009F; Tue, 15 Sep 2026 11:13:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C8B06B00A1; Tue, 15 Sep 2026 11:13:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D8AC6B00A1; Tue, 15 Sep 2026 11:13:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E40736B009F
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:13:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0077BA56B7
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:13:36 +0000 (UTC)
X-FDA: 85216340832.01.25C3263
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf25.hostedemail.com (Postfix) with ESMTP id 45F35A000D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:13:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=QVMt8CU8;
	spf=pass (imf25.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789485214;
	b=235ZueS+fcIRLX7UDiHvbMC9uQ4sOIr0hHVb5/6CrK6HGYFNw9eaClse9sGWv4aII0yTcB
	DWor4NykYlvujJ2Pv1XsTJNQRiK/+p9pL1nL6od08XXQatA21YYER/VrAqHwSXuzN2HGUm
	2f8xsShZd/Vy9Oh9t3GXpnNxhnQ0EEg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=QVMt8CU8;
	spf=pass (imf25.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789485214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oSGOZuIlLi/kWLWERFDika52b/inT5K3imQnR+07eJM=;
	b=yXwJgrwkh4fp+xpXzMbTkltyQN9LYuFLoFJIu842xP5dC3MEN51rIqha/D8k8QpqhG36I3
	U/tns1HSl2QJimosMzmWCobJ8gHP8tdAlINwzmepXvZKiENv9LrkQcA/zpBuShspB3sJXr
	QhyIbxJgFMdXckIF1oY1QCnxasoVdmE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=oS
	GOZuIlLi/kWLWERFDika52b/inT5K3imQnR+07eJM=; b=QVMt8CU8GnRT6gyCY+
	QsEg19St/c65BK6C3qXQfV+DpxrA/Y9FUZL2zqUlrm3nZeUlfzSzCV9xOrvpxp4j
	5lP08J7yf5j8kRF1u1GIL/b1Izvh6zRmZwBk+UZXcc9GbVUHLt1nFZsRNZXeFT8D
	ywt8VrlQ5l03aJQn3TyklBOlw=
Received: from VM-0-3-ubuntu.. (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wAn2xWOYKlqc0VUAw--.40469S4;
	Tue, 15 Sep 2026 23:13:20 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Longlong Xia <xialonglong@kylinos.cn>,
	David Hildenbrand <david@kernel.org>,
	Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 02/14] mm/ksm: rename advisor_ctx to ksm_advisor_ctx
Date: Tue, 15 Sep 2026 23:12:16 +0800
Message-ID: <20260915151236.5200-3-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260915151236.5200-1-xialonglong2025@163.com>
References: <20260915151236.5200-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAn2xWOYKlqc0VUAw--.40469S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxZFy5Kw15JFykXF13tw1DKFg_yoW5Zr48pr
	W5ursFkrW8ZFWYqa4UZrn5Xw17KrZ8Gw40gF1jkw45Crsa9ryUtrWxK3W0yF1UAa4vvry8
	XryFgFyUtF4UtFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jzUDJUUUUU=
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC+BBBOmqpYJBV3QAA3o
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 45F35A000D
X-Stat-Signature: 3xzd1si8seczmii5dyhtjb4etiqp6qco
X-Rspam-User: 
X-HE-Tag: 1789485212-476449
X-HE-Meta: U2FsdGVkX18hfGrW1u6oQhNguQ4CVy66RqmQ7I5ywugwNp13wOiCp6xcK8dNszcPLXLEzDv27PipnQTZi5CcktOmi4E6NxFzWkNGxWbdvSBffCjbKt6kQlm7ahqe9tsNpLNza1XYv62nUoCPn5y1twIB9fbltRNLjss9coYuvZqTZxqshMtK7xD//bs541CBwucxWjpOLa4BoOZdNwooijCjgo0fm0y7ZcnjWLtSONYZaLOQfrL60qHeZBvSLjVlzpCFDgREDvrlBVXI0Lo8jdVoTyI/jpZtMjNIeZgRSUnJOuTzNq62WMOP3AvsBn0ooJp4VWPKRTqxfZ0myYf9Qf//qRVFVwhiOMYkaeNX7Gcukhz40BTJOEHgq90a1hOIJS0mEt9/lCBBmxC0mYnEByFF+ZoH89kuI5RXvit1J4PpJBXNtEdYk/E7/sEiNxzrA3mh2NZ95rf6XFW9X65/dyVYM97FeUlz770tPKQMYyBagcyNd9zMeltzNOW6vcquToaefZ+QrT/cuEw+wDm4Jb88IqEv212UMSUWcrTpDCIj8yTfaM8/E9E2k35ki1Mv37gMs3OgqlTjWEiCfMzOAMZnd2RqdZXHyWwcr2AESfbowEnnPfGzDTtLosBE/v9mw513+9pHJU15KuBw7swfkq0uiIRVhwnKYyNyIDbIcLcVFIKQxoOylKafBA1oOnqAM3g9Gc0+43h/5KbhK3ukpw/G3ISW3IrrzdjPe0N4Rz0Dlbvg2Qwkmf9mHqRpdkJR7PLGRJSods1K9ww1Bnv5VPdLMEfXY4Di3Z2dnCxRbccWyGqwc6uwvcWYLKJDs14gLXxT4sIyah03/dgatnZwzbW2FsuKN6ydx/ehchpZdQC4ZKRvCsnzxIHpcmnf49bGZGpGJNzxxvzYvH6pe8CRjFVGK6MuPxQBrJ3soPz/1nGhXEwFU34gJIXO1PhhCqsENk/oUOn0jP2Z+beDL45
 z0gGy8ll
 qAfLcB7iedE4mLYhdlUJzZhkOEHTf7ENczIyrVhp+OCc2RQIP+yuBzx6qNsgw03T9+ynXVY3aDUpb+xQbv1cqbGho1dKE2/V7Kv0POAvAnZYrR6drA/eS/jogYdD/g5oM390yUW/0j7N4ly9P5Bw0IyCigKza/1CkWC1CwbcS0DhrDglKHl02Wi1IffO4PaTwdKxKk8MN3hZ+E0vTLWjm8OznA6UWzC/+P9KHWHxLQWCdeLwnNLNBKEjWEDJd+pXdlN4DJowxKFl1PVn/3M6g9lPVxEGnrPOXZno8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

Rename the advisor context to match the ksm_advisor_ prefix used by
its tunables.

No functional change intended.

Assisted-by: Zcode:GLM-5.3
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>

---
 mm/ksm.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index f637f3baea69..1e4d77852fc8 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -334,7 +334,7 @@ struct advisor_ctx {
 	unsigned long change;
 	unsigned long long cpu_time;
 };
-static struct advisor_ctx advisor_ctx;
+static struct advisor_ctx ksm_advisor_ctx;
 
 /* Define different advisor's */
 enum ksm_advisor_type {
@@ -356,7 +356,7 @@ static void set_advisor_defaults(void)
 	if (ksm_advisor == KSM_ADVISOR_NONE) {
 		ksm_thread_pages_to_scan = DEFAULT_PAGES_TO_SCAN;
 	} else if (ksm_advisor == KSM_ADVISOR_SCAN_TIME) {
-		advisor_ctx = (const struct advisor_ctx){ 0 };
+		ksm_advisor_ctx = (const struct advisor_ctx){ 0 };
 		ksm_thread_pages_to_scan = ksm_advisor_min_pages_to_scan;
 	}
 }
@@ -365,7 +365,7 @@ static void set_advisor_defaults(void)
 static inline void advisor_start_scan(void)
 {
 	if (ksm_advisor == KSM_ADVISOR_SCAN_TIME)
-		advisor_ctx.start_scan = ktime_get();
+		ksm_advisor_ctx.start_scan = ktime_get();
 }
 
 /*
@@ -419,18 +419,18 @@ static void scan_time_advisor(void)
 	unsigned long scan_time;
 
 	/* Convert scan time to seconds */
-	scan_time = div_s64(ktime_ms_delta(ktime_get(), advisor_ctx.start_scan),
+	scan_time = div_s64(ktime_ms_delta(ktime_get(), ksm_advisor_ctx.start_scan),
 			    MSEC_PER_SEC);
 	scan_time = scan_time ? scan_time : 1;
 
 	/* Calculate CPU consumption of ksmd background thread */
 	cpu_time = task_sched_runtime(current);
-	cpu_time_diff = cpu_time - advisor_ctx.cpu_time;
+	cpu_time_diff = cpu_time - ksm_advisor_ctx.cpu_time;
 	cpu_time_diff_ms = cpu_time_diff / 1000 / 1000;
 
 	cpu_percent = (cpu_time_diff_ms * 100) / (scan_time * 1000);
 	cpu_percent = cpu_percent ? cpu_percent : 1;
-	last_scan_time = prev_scan_time(&advisor_ctx, scan_time);
+	last_scan_time = prev_scan_time(&ksm_advisor_ctx, scan_time);
 
 	/* Calculate scan time as percentage of target scan time */
 	factor = ksm_advisor_target_scan_time * 100 / scan_time;
@@ -442,7 +442,7 @@ static void scan_time_advisor(void)
 	 */
 	change = scan_time * 100 / last_scan_time;
 	change = change ? change : 1;
-	change = ewma(advisor_ctx.change, change);
+	change = ewma(ksm_advisor_ctx.change, change);
 
 	/* Calculate new scan rate based on target scan rate. */
 	pages = ksm_thread_pages_to_scan * 100 / factor;
@@ -458,9 +458,9 @@ static void scan_time_advisor(void)
 	pages = min(pages, ksm_advisor_max_pages_to_scan);
 
 	/* Update advisor context */
-	advisor_ctx.change = change;
-	advisor_ctx.scan_time = scan_time;
-	advisor_ctx.cpu_time = cpu_time;
+	ksm_advisor_ctx.change = change;
+	ksm_advisor_ctx.scan_time = scan_time;
+	ksm_advisor_ctx.cpu_time = cpu_time;
 
 	ksm_thread_pages_to_scan = pages;
 	trace_ksm_advisor(scan_time, pages, cpu_percent);
-- 
2.43.0


