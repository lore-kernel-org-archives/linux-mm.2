Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2157BC4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 06:06:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E03AF6B007B; Tue, 21 Jul 2026 02:06:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDB3D6B0092; Tue, 21 Jul 2026 02:06:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D18266B0093; Tue, 21 Jul 2026 02:06:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FC006B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:06:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 19C03803C1
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:06:12 +0000 (UTC)
X-FDA: 85011748584.27.47E7695
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0858740003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:06:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of yanlonglong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=yanlonglong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784613970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q6xQU5BxGygabT0BM0VoCM1XXzpGok3fflZlBCMSgR0=;
	b=iBNlq3kpV9iil2z5EM95qx33ll69KSTEUqjTLwcpwMifGry4CdVHu+TlW4Xk6G67ntn+Lz
	Sc4lRAlHuSpruHvdD/lgONCm13lskjWx3Kr8VhnQ4hsfVdQxob2LEe93f6ZLxsxyxlpntr
	p/6yR0LEFrQ75dkkaCz4JFWjFjfp2rU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of yanlonglong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=yanlonglong@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784613970;
	b=PnyKTg50jcpOKlYqxdcdJEbtd2+srAzIbb3Fhs5DZ3OhQ2xqPuuuo5bIXRcEysCvfsZ6Ja
	rWvv+nsJF+z4SvkMZWbvzP/Nkrg7apb+oD0EVvqVRhgPuoie+MwXGZM8kw0Aa9zCU1iRTt
	ZxmEtj9MGX/58C9Q1Lt0638BoV2lPs4=
X-UUID: 3ed3817a84ca11f1aa26b74ffac11d73-20260721
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:aa6d5e60-2d57-4bdd-bca3-2e51833d5e31,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:6d452cceb2101199b58a732b8bb20160,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|850|865|898,TC:nil,Content:0|1
	5|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI
	:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3ed3817a84ca11f1aa26b74ffac11d73-20260721
X-User: yanlonglong@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <yanlonglong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1980014824; Tue, 21 Jul 2026 14:05:59 +0800
From: longlong yan <yanlonglong@kylinos.cn>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	shuah@kernel.org,
	yanlonglong@kylinos.cn
Subject: [PATCH v2] selftests/damon: Add missing NULL checks after malloc()
Date: Tue, 21 Jul 2026 14:05:42 +0800
Message-ID: <20260721060542.326-1-yanlonglong@kylinos.cn>
X-Mailer: git-send-email 2.47.1.windows.2
In-Reply-To: <20260721043139.151887-1-sj@kernel.org>
References: <20260721043139.151887-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0858740003
X-Rspamd-Server: rspam01
X-Stat-Signature: irnp54gdwdpttd1iykm48gw455ei7nyd
X-HE-Tag: 1784613968-453619
X-HE-Meta: U2FsdGVkX1/b6mmDDl4y5TDX1Z+J0WA1rspWpZPO7weeGDeTBZLgOwvyfeLhhE4AOrPxOI6HgLTfwnCC2bzdI+NWojW0biZ4yfvREks09adwNh5teiNmBtQXQjUnXlJxgGgNJEyKSD2uvK4AYjZ5CvgS1Wk7bEHzzh4DBWzorh92XaMBUTedEFJip4X9tgNLyrjIhLDAjKIAC+mAgH/w0mNkwy4X7hUbHEPz9ivF8UsR5w0XlUhiRQaQa+Rplomke6fIgJAnkxoobZey/kDQ1m+D7VNEORTUgdVTBd33KAkMzGsjpFiT+sR2MLWVYJvx1bBOt/vCl6jgGsCWCTxKdJ4bVQGs/P7Kei/FytJNrMieMAoV9wBPx4VbAabYH/xSy612V0pXtaCIVhSBL7o+XvjRRylEewaoquMSbJL6y/Pdcb+fwjqgfLaPHw/Q5JLuIscxdFpiVxvzvDEHfHw3EO+KDg15SxDb0s1g3aK+/pa3//MQ4E8FX0mYyT/KxkzZ6/i4ZfhQrGMK9tawP+BN50j7SDJ/9K/83KZpylFd8dMq3iC+u8ho9zqdXCrzIt7xl8HUj4OT0BowgqfzXJ+/MduhspvrX/oXCTWDgl3Q528abUIx8UTPKI9/ng8Okbb/RUHdi7mfcJfpfUWuv5Ija+JNiLtBJ0lvAwNb+rQqNpFdXpMpbZ/3QAWKO2lhGW0B5DCzmXhWV3/ZNsmQUu2gp6X2lI2AjULFa2/ipu9EU4wV/4U4iSYigSU0NP1f4/Phug5kHbYs202SOc9nV16K+1685vgUU6a58Ox01ugw/eXuPP1JihJlmp+ytRIek7HdlIRSNGklwtTLQ0igPE9j5yvhFrOQb9ssWo9FKYzDS+y4DVzc2rOaPa6mtiXSby26+G7md9jXsStF6goQtA0JXiPqqcp1UtLeVa+EZf0DTo1mcS5gA/C5JGMYVch6VMkZZgYxKVBIrp5STqYmzRl
 U9CTZDb0
 Wt6gp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In low-memory scenarios, malloc() can fail. Without checking,
the test will dereference NULL and crash, causing the test harness
to report a failure that is unrelated to DAMON functionality.
This is a false negative: the test should skip or report a resource error,
not crash and mask the actual test result.

Add NULL checks after each malloc() call, printing an error message
to stderr and returning -1 on failure.

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


