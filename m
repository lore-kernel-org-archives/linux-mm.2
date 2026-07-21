Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24FB1C44524
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 02:58:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 181036B008C; Mon, 20 Jul 2026 22:58:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 132AD6B00AF; Mon, 20 Jul 2026 22:58:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0479C6B00B0; Mon, 20 Jul 2026 22:58:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB9176B008C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:58:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 417C4140343
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:58:27 +0000 (UTC)
X-FDA: 85011275454.13.A799CA6
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf04.hostedemail.com (Postfix) with ESMTP id F377D40002
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:58:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of yanlonglong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=yanlonglong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784602705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=GKGUqnl1bVlEFCU7YoIasff9Gs9/wLf+30lgXEpIGZ8=;
	b=idlWikkjJlyKoVchnM/+b23XKC1SzP5ooldidQDtVxLP1gPjat4WtLPGiV4irvaC12bZrl
	KzFwE9H1joRZG9NfJ5NXNPgvrdSWxIhhz4urmXdztu4zEr7uw9qiqoy4zAwjnhOPR0ueEg
	2FChGq0LKrua04qEKf9idwYlMUWtHxw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of yanlonglong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=yanlonglong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784602705;
	b=SrWbUnv35TnWCj9SmtzWu+voGSvhe7Wzsht5DDR2P7g8h1JLliQbAW+7BxF56b/gSvQrfP
	+ztNBhKLahNvdB6bN/gZlDCn0llFpD1sHQ6nvMDE1M/LXn7J7qpBJUzgTZsMoJCh1M8X57
	ofRl6+n+Dd2oW2tlBoJSslF+7vaIAH4=
X-UUID: 06611a6a84b011f1aa26b74ffac11d73-20260721
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:8cd05412-5523-4a0f-9612-8498efa31da6,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:b55ad6e664a8891904fc79622e403fb5,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 06611a6a84b011f1aa26b74ffac11d73-20260721
X-User: yanlonglong@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <yanlonglong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 912696944; Tue, 21 Jul 2026 10:58:18 +0800
From: longlong yan <yanlonglong@kylinos.cn>
To: sj@kernel.org,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: longlong yan <yanlonglong@kylinos.cn>
Subject: [PATCH] selftests/damon: Add missing NULL checks after malloc()
Date: Tue, 21 Jul 2026 10:58:02 +0800
Message-ID: <20260721025802.298-1-yanlonglong@kylinos.cn>
X-Mailer: git-send-email 2.47.1.windows.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F377D40002
X-Stat-Signature: 5j7ocgoxf3tb8i3m7e1whcc1fqnqz5ou
X-HE-Tag: 1784602703-807205
X-HE-Meta: U2FsdGVkX1/xj685h9b2WMdzmZa02o3iedph2/j5ZUppLPrn28jOpNiaFhsBqJUMFajX2/tRL0YeOue5OGNAZHuQlmD/CkqANbdkwJpc+e8QBGgqcchZnGhprCHgTpwxGdZRavjhFtLHJE5TYZ1iOdHavhEJbKxKYnO+ifBF9hWaTPJ6u/6Ipas7XcrE3FK9Y3fQWVa6Tq9rfMSCZsN3j69gv75yWv/ApxP8JHLQ/KUeNV3rzNvs0yRQhqevYLYH3r9vkVIxHWQS0JZF4610SD/simOk/NoAUgiVcdjhdoyAse0jPIDg9X5NTjxW9NwEd53Vgdmr5yYUuObUBUqWRRQB2GNU+01O1KVa41oYDfTlt6bhu/io7rmprN4JKTNwAGfOidf0bTsvsTE99Y97zCwI8l5J9GwPg3Wo3wRcyLrT5KIw/HTub9SJwc+mTGwvOyvuZ6SK/Z3n5q6G4XnwMd3nuKHvjF033Qq6t8abmQcLITVFT8P5eBNzOvrJBP6dGEe9/o7uV4Enb7Lw8y2vuINzxzJT3XxFQNA9CKH1+jUiYoMDI+Xl2kofcoYlmIbZG3suRUnhDqCMEJgu6TABx1XzWjudTk1dqSr3G6tsJWUN69uClb31mMDTXYryfPPamhyoreH9Iyoocrt7WjdCY57hlZkcfrZX9il3BjvyljEGksSsSe61l7RLl0R/yDvTBgd+XiNadUH2w7oQ0zTuo458cdlPq91BjrbbhRfYAqJGszfPqmFbapn2gdo8xmDxGw4aDsUIPg8GV4Va0OUYQm27yuqzEJZMZO53PcpfCTWjAjaJJOJb4kFT4HAFwQItU+U5nb4z7yWnmqCZHWkA7Yy7Ogmc65/anChItQbIUoJ/GJmTXw6PLmjspnR6GtTixHXZ/dxnaXL69lCKKAMfCa6yj0Go/z3MPmMagHd/EM2DdCdBSFUkxkRriarvOMz79jUoSCjpjhtO2Bm1gan
 RJPh1KQU
 64cZJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add NULL checks after each malloc() call, printing an error message
to stderr and returning -1 on failure.

Fixes: b5906f5f7359 ("selftests/damon: add a test for update_schemes_tried_regions sysfs command")
Fixes: c94df805c774 ("selftests/damon: implement a program for even-numbered memory regions access")
Signed-off-by: longlong yan <yanlonglong@kylinos.cn>
---
 tools/testing/selftests/damon/access_memory.c      | 11 ++++++++++-
 tools/testing/selftests/damon/access_memory_even.c | 11 ++++++++++-
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/damon/access_memory.c b/tools/testing/selftests/damon/access_memory.c
index 567793b11107..e1a8e050dcd4 100644
--- a/tools/testing/selftests/damon/access_memory.c
+++ b/tools/testing/selftests/damon/access_memory.c
@@ -38,8 +38,17 @@ int main(int argc, char *argv[])
 		mode = ACCESS_MODE_REPEAT;
 
 	regions = malloc(sizeof(*regions) * nr_regions);
-	for (i = 0; i < nr_regions; i++)
+	if (!regions) {
+		fprintf(stderr, "Failed to allocate regions array\n");
+		return -1;
+	}
+	for (i = 0; i < nr_regions; i++) {
 		regions[i] = malloc(sz_region);
+		if (!regions[i]) {
+			fprintf(stderr, "Failed to allocate region %d\n", i);
+			return -1;
+		}
+	}
 
 	do {
 		for (i = 0; i < nr_regions; i++) {
diff --git a/tools/testing/selftests/damon/access_memory_even.c b/tools/testing/selftests/damon/access_memory_even.c
index 93f3a71bcfd4..a443835c119c 100644
--- a/tools/testing/selftests/damon/access_memory_even.c
+++ b/tools/testing/selftests/damon/access_memory_even.c
@@ -26,8 +26,17 @@ int main(int argc, char *argv[])
 	sz_region = atoi(argv[2]);
 
 	regions = malloc(sizeof(*regions) * nr_regions);
-	for (i = 0; i < nr_regions; i++)
+	if (!regions) {
+		fprintf(stderr, "Failed to allocate regions array\n");
+		return -1;
+	}
+	for (i = 0; i < nr_regions; i++) {
 		regions[i] = malloc(sz_region);
+		if (!regions[i]) {
+			fprintf(stderr, "Failed to allocate region %d\n", i);
+			return -1;
+		}
+	}
 
 	while (1) {
 		for (i = 0; i < nr_regions; i++) {
-- 
2.43.0


