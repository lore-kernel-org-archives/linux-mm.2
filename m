Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02BAED68BD5
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 08:58:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2C006B0099; Sun, 21 Dec 2025 03:58:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D54996B009E; Sun, 21 Dec 2025 03:58:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C49DA6B009B; Sun, 21 Dec 2025 03:58:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A57446B0096
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 03:58:32 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3B8998B79A
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 08:58:32 +0000 (UTC)
X-FDA: 84242877264.04.2004FFC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7308380006
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 08:58:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XuOu1s94;
	spf=pass (imf02.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766307510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tSork19nHW6YKdr7H91m897S5X3FouxxKb6TE2rVX6g=;
	b=NK2slX8r0GzNTZlYgYNnc4AliPTUkxEmzpZt01wchtuMI5Ry5Vm/a316hBdy2YTWXQV8ZL
	CYkXE4yvNTpvKnhrcwasjTcst8Bs0Zxp+Ff4rBEWW4bDe310R2uESuR5QO53+D5r1wlGKh
	K5YnYoQZZGIqycZEwdETu2OTr2ZwKpE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766307510; a=rsa-sha256;
	cv=none;
	b=lga40M5JuHYUWZ/Wxdny++F0n+S+mO8ogAZrbbb9k7hjETkYtkQTbgDFdDJHyNAthVxjnd
	cM8bBM3KGXjhAm92z0YET5FTleOhG+u1uZfgRLMNMsZiAhEyPv5cVNPOe5izOCLuw8N8Ue
	4eEcD9QYxDVmHyKSulJN1lScgONcDP0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XuOu1s94;
	spf=pass (imf02.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766307509;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tSork19nHW6YKdr7H91m897S5X3FouxxKb6TE2rVX6g=;
	b=XuOu1s9458XM8UP5mD0QgAX3AYP38Nqjt8VqZgSu5SVXoz5WrTSh20HFlLUzPOmeAVyknu
	dPld/Hn12KNMl9hApZLV44ptJ4XhdZpp6L1yShJZPxz3aY1cGd2zoQLjP8wjzLxYlp0zqo
	0RjBELVVreDUQPsdunHTJMDVTBzhSwo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-253-85XfBGhFNiSN_qbv9wHraw-1; Sun,
 21 Dec 2025 03:58:24 -0500
X-MC-Unique: 85XfBGhFNiSN_qbv9wHraw-1
X-Mimecast-MFC-AGG-ID: 85XfBGhFNiSN_qbv9wHraw_1766307502
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C2B6195608A;
	Sun, 21 Dec 2025 08:58:22 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A1DA430001A2;
	Sun, 21 Dec 2025 08:58:18 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH v2 1/3] selftests/mm/write_to_hugetlbfs: parse -s as size_t
Date: Sun, 21 Dec 2025 16:58:08 +0800
Message-ID: <20251221085810.3163919-2-liwang@redhat.com>
In-Reply-To: <20251221085810.3163919-1-liwang@redhat.com>
References: <20251221085810.3163919-1-liwang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Stat-Signature: n7xnpn51b9ry78q8hhwjiftsixzx9wyn
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7308380006
X-Rspam-User: 
X-HE-Tag: 1766307510-247934
X-HE-Meta: U2FsdGVkX19+B8y25PKgeXAtIqRo4ghaj78uQZwM2x8f5V9RCQn1gSS8MEutvJW2DkXpub+kZGEWiqyPIi9iYuiR3/evAYY4p3gY/9aMMmj+Ql8o/Zi1KTAwKM1CMBTzRlbdyGAXObiUC20vTFMcv6bFThbzaNbtsH2G2shCmfC3wwXzWBqLQaQQ8nPhPwi52piQt73Tr+upRPAAZjdprdn4SXTA7GGHqakasD8omKaV94GNEF0Ox87xYArcJxL7WCD9m5K6byGykoldOuHeW18cqjQz0EEjopz9VDpv+g3K4dHYIS4ct4uOerJBQY41SYltO1sp6ytZcztg+eYs+8TwjyNCYle40kGZ6pCKwiUw0OkRG3I2nTkYz16ym91dMmIpXnixGPHkjNqqz2fMWay/TOA9Ndnhorj+nsUOqjCi0JEC+FWT01z3EqnAGmr/OITDzI31cnd3kiV4N0To3D9PnT7eVv4YvKqBv7EztPZoo2USwoIx9sp3uRpmlUg124ZIGrRec/2J+c/Hr5oxpKOooZjZkYS0evCG5OrzYpCEHDpNUsN9jfKQcJcFf0duTqgAXdhaT1Kszz3mF6ohSMHWBUIRi5PMJy2EluO/0g60PkR6awuhYoeHjJGf4AuWtugzXoGdTTfQKjnZI06a4lDU/D2pnL5gsKzNuSV5b7vZCX9ZdZmRmUQl6SbMt+VXpeSNJ3F565UHCxblXZdynlTvzJ0HyFslNAXkOEcnhd32mZjh0MQz6XoE9U3R6VyzsJ3T2NhVF5W+7l7tZpb7pFwufoRsLGt6bK6JPCSTNAcjFhAf43ierbBpMB/YzIJ8jSgeymIhEgzHDfzjakpLaiukv+Gs5435RuVT0AJ16LLhL0K89IMcDU4/J9saO4l/yYytNWAjoG9FBXLeUHuwZb295+cEP4ys5fVib9bl8jGg414NwiFEDrgCgN/fj55HAqrjw35vydDzyAYZDmp
 5gPHU0yp
 lz9w0qhsDWmmvVEONIzafwFoOCz4T46fq0MF9Eh1XRsCgeYF1cWwtwSufgSgHX25vgpqN8//Hzcc8/hP+9XeBmGQPVGIMNG7lyozH/jTrksPMXCnmN7PhL25xpqT6BKlxTWOCRFjuH4nT6ezYwE6iqTsEKfUXAOAGU3IBmEcTGyh59yVytzIelUI5jIOH6u/74+BWTleJyxNn/PM9WwcJ1LkYmd0zhWDctcSRimkjyjaZLJ2QtpCSdoQ8jjJ9I7GncpJQoCheug7couLDOyoZhGqiNfwqeZbKc2zkqfn/K75+qYiPIteRUQHQmN64JucfjHstRln5eIUjXHURukPCvKXC3O1Z8iAJpQ0erZ9FNwRyUYfbuqchi4JmRBpnT9eyZp747n9JawR1CP5YCmfqvS8IJg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

write_to_hugetlbfs currently parses the -s size argument with atoi()
into an int. This silently accepts malformed input, cannot report overflow,
and can truncate large sizes.

--- Error log ---
 # uname -r
 6.12.0-xxx.el10.aarch64+64k

 # ls /sys/kernel/mm/hugepages/hugepages-*
 hugepages-16777216kB/  hugepages-2048kB/  hugepages-524288kB/

 #./charge_reserved_hugetlb.sh -cgroup-v2
 # -----------------------------------------
 ...
 # nr hugepages = 10
 # writing cgroup limit: 5368709120
 # writing reseravation limit: 5368709120
 ...
 # Writing to this path: /mnt/huge/test
 # Writing this size: -1610612736        <--------

Switch the size variable to size_t and parse -s with sscanf("%zu", ...).
Also print the size using %zu.

This avoids incorrect behavior with large -s values and makes the utility
more robust.

Signed-off-by: Li Wang <liwang@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Waiman Long <longman@redhat.com>
---
 tools/testing/selftests/mm/write_to_hugetlbfs.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/write_to_hugetlbfs.c b/tools/testing/selftests/mm/write_to_hugetlbfs.c
index 34c91f7e6128..ecb5f7619960 100644
--- a/tools/testing/selftests/mm/write_to_hugetlbfs.c
+++ b/tools/testing/selftests/mm/write_to_hugetlbfs.c
@@ -68,7 +68,7 @@ int main(int argc, char **argv)
 	int key = 0;
 	int *ptr = NULL;
 	int c = 0;
-	int size = 0;
+	size_t size = 0;
 	char path[256] = "";
 	enum method method = MAX_METHOD;
 	int want_sleep = 0, private = 0;
@@ -86,7 +86,10 @@ int main(int argc, char **argv)
 	while ((c = getopt(argc, argv, "s:p:m:owlrn")) != -1) {
 		switch (c) {
 		case 's':
-			size = atoi(optarg);
+			if (sscanf(optarg, "%zu", &size) != 1) {
+				perror("Invalid -s.");
+				exit_usage();
+			}
 			break;
 		case 'p':
 			strncpy(path, optarg, sizeof(path) - 1);
@@ -131,7 +134,7 @@ int main(int argc, char **argv)
 	}
 
 	if (size != 0) {
-		printf("Writing this size: %d\n", size);
+		printf("Writing this size: %zu\n", size);
 	} else {
 		errno = EINVAL;
 		perror("size not found");
-- 
2.49.0


