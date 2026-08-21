Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A02CAC5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 11:45:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71F786B0095; Fri, 21 Aug 2026 07:45:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D0226B009B; Fri, 21 Aug 2026 07:45:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 597726B009D; Fri, 21 Aug 2026 07:45:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 29F2D6B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 07:45:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0B722A30D7
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:45:28 +0000 (UTC)
X-FDA: 85125096336.05.AA3AD0C
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3EA2A40010
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:45:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=K+1B+X5f;
	spf=pass (imf27.hostedemail.com: domain of anshumantewari123@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=anshumantewari123@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787312726;
	b=Kw7yfUcG+E7H7UIr7sHcV92RjIWiv4lvz/+ck2//EmREeIDVysmzgwmKEP7aO83qkE5tcS
	7+g2SucevX1Qmg1hGyifMPUfZ8TUtD9Z0OIpX1e5k28cVdko1rcLCED1fh0mHaFlSvTt+L
	AnYwcLIC+Kn+PsoHbZOvU9RXEz3otN4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=K+1B+X5f;
	spf=pass (imf27.hostedemail.com: domain of anshumantewari123@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=anshumantewari123@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787312726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JSy4cnyR4S+sHUGi7h02BTfopN89+3p/alRrTWBOPrA=;
	b=E8g5TUqpUf8EmOiZwyTucabgsX0d6MPXzk+63c65+VEy0+5aNaT6PbtSY1M8EZlS38Zklg
	r3hvZUORKUpNeyZfaOOp+oF4gRZVp1doK4hrCvrkWclRi9XEH1MsO+sK/Qrf44Xvpw7b0D
	lzpCYSilIvSGVm2SOIloZRVoHrWKfL0=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2cab973140bso11572665ad.3
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 04:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787312725; x=1787917525; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JSy4cnyR4S+sHUGi7h02BTfopN89+3p/alRrTWBOPrA=;
        b=K+1B+X5f3P5UPp4t739asUPLHNb9fe29eYSJlueP43AkL3J+HI6OOwbRE3HZ8L/UYv
         QQ4vwdv7/le3HZuJ9PHG/8j8y73t7ynf1/I3049zYL0K29xvo7VL7BxqAQCRlEjP62M0
         C7ebulfLZzcjXmqmFIlRafeqdSHuNQW8ZAcYj1BUG9omigTz07suqram1LeEeFh5xCdO
         vdaRKsMmVw0nNILO+6yZu0QVFL2ZpPmhCeK36z7+bQ8RoxCvMa1n9jzbYycepg+0uWYW
         3ZNgROf2NRywRiM0sdxR7Nhv7UOB6W9MOFsj74oBzyYSwpQS4lEuex/OPNy4jirSKHsX
         iwKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787312725; x=1787917525;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JSy4cnyR4S+sHUGi7h02BTfopN89+3p/alRrTWBOPrA=;
        b=mR5nhTKvqtImGcl4cQTZb/rxihnLWPy4eRM9gQ3yf3Dn95kbgCvhGmcqXVEkR04wz2
         dYoK4HD/Jkhc5PGQfhe3I5GdEU/rZAx5MlKJ8/p10qRcC9X7u1wNGm44K+q3zOXTX1Ei
         eBqFmyW5CooSUQkLm0i9ZBv43UJ2WlRb5ych7v9PYA3DA0eNwz4ElqZQdChhRYBnwnDC
         w/r9hq7PAUgaqoYAm/QyUN0zFpGL9bwOwb9MyHYysC5wlLXixGOghXNfSAGrGTrb+taL
         zKvioz/Oet8JlZoT/gIugVuudonozAWd2bzD/GyE2eGrnggb1zx2NxSls6Mt3WJmuBd0
         +67g==
X-Forwarded-Encrypted: i=1; AHgh+Rr1BzbeVJJOwP7CvZ7px1Wv8O1Kr8hyDggtVrNdMsv9BmpX+tLhW4nXINBPOZyPNLC/NckAb0pudA==@kvack.org
X-Gm-Message-State: AFuF++mkW4D5qzGIKM1lnytzZcdNyOYfyfLCpIm/WYwUDwlWKu41P1lJ
	ExqY897K+ArsohGh4nAwCvdwEgCxvf/g27xps4vwM4jtS3qh8Db0HAIV
X-Gm-Gg: AR+sD12ZGOXLhoOHfTUj5RQLKhaYcUJUXNGBF9xRNCRmxoUQfUVZd/dRVI3/JOebH9K
	u/GvMacs9wbzevZLy3hI4jOZ5+oOigxtJcF1jdlV9SC4FjV/Nszsd18dQybM7vtxrllbVaBkUJN
	LwZx34BcJgV2D7mHXNla8wyvWKNnAO33z5uTDoQZQkM3zm9FzkZMoB70YLNJ5OuYegfQZUbYM+T
	rC5WSMW9vXd0jSEAywIWDRJ6FaEOxMcKxHjBXtrjT0sA/ywgyZqWPqeUYrZqq2RAQU3OU5XBfB0
	QiR4Ex6OrbH+xFXTSPNICILCnRRVCsCKNlTqgUKdjEhwhASrsXOFuRxL43MkCwbkvbeNCH29YPI
	mwxzK2hbsuP1yblntB2YZmYG2c5rftKWO5HtVqJ6+BOawVC65eyYABS0vOIEPq2n9tYVROaFIRt
	2kXexj5NCZnmAeSKflVUgS3fn1L1X4ZZzHr04cJ3uX9ak35s3aObiC7qcE5tr4pRgo37vPNSEZO
	1UCJ4CzrvdgAm+/2uKwkNrZ8ts=
X-Received: by 2002:a17:902:fdb0:b0:2cc:6018:f030 with SMTP id d9443c01a7336-2d64b0b5652mr124872615ad.14.1787312724901;
        Fri, 21 Aug 2026 04:45:24 -0700 (PDT)
Received: from Anshuman ([103.161.223.14])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327c946293dsm20771743eec.22.2026.08.21.04.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 04:45:24 -0700 (PDT)
From: Anshuman <anshumantewari123@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Anshuman <anshumantewari123@gmail.com>
Subject: [PATCH] selftests/mm: check strdup() and fix buf leak in parse_test_type()
Date: Fri, 21 Aug 2026 17:14:16 +0530
Message-ID: <20260821114416.12255-1-anshumantewari123@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3EA2A40010
X-Rspam-User: 
X-Stat-Signature: mcupmyzz57stkm7mgtz5ewbw3mkjq61m
X-Rspamd-Server: rspam06
X-HE-Tag: 1787312726-2970
X-HE-Meta: U2FsdGVkX18TMqk0Io+VTp9wOQMcvASOuI2NfwTpdwdHp+HIhuiLOdtBolnih+D7/Vjy6crC9DNWeRN3lDaqnZ4zyxa7Iz0t9SqMiqMYF4kfPZFiyxvK8oRPCSQYMviymggxJdjE79CJ5Z8ZBr1LMQQdxK2fQ9gr6DUfSE7pI5yk+AYrbQql5pA3rfGVnRpamNg2gIzAzug1S3eXLDF5Wi+Hcq9noQUn1dH0Im0NlP/p1kJGV796zgTL2qS4zk3ouR/rx2s+yNlkjtpXXIGMipG5hH8XULCHQ7XTOw0hdg2Z2AxpXncZr3yas7zFUd1X0ohm/E9XlxARnPucGF8ponT7x8pVJ6+/cLA9TVKlabKvQ8Szvh3YYoqdMdrmH2ay8cegzGn/fnyY2nIC6JCJCXklXQ0XSiJsRGwkmb5Ppg2pseRz9qxKxRHBW+kb6gleHtZl6yn80+4TxC0W9b42zOgpZBPkteOqKVv0Z7/E/SEqowMDqp1HbFLrg/w1qfd6rWy7yM6s15XlbUNqgfh2IN+n7/GqCBs1YJIUrSvAECsqW/C16qp6PuVMTr4F/2hn+q3Sl803+ynHNpXuZkkWNjr8vQLQ1fDwrlte0MXFKPlYGcXxEHQTrRovsLKMenBzapqOC+0v14s3nfaD6DCSocZVcf7Uo3V2VlOHu28jKQYzv7F345VMZj8yV98knVGYJlhj0F8gX+B8s3PdGjlgQTHdnLgG3+Yb3cOCiNDY5F4Gt4Aqdl5m+4q4JFyKuU464h1Jf8o4SRqihBMf1bcQPczlSakHXtLCo1bFgABeuh1WHdu5HUt57qezLwAoEomdlPRxpK9OFPC1SIwM8ChxF80zzJCtfp9jc0Fta5l8t5asqBev2UYBkwfqI0flk553YynMLYt1ogHpoBugLaM637O47inGdxu/l5+Gb/xsNFS1u347LqD88bIOmv1/lxcu+Z1czeLJU5M2w3uOTgK
 vqy9CqxQ
 y9FJFmX/JypSeUNaGjOi/4VzibAT2mpqrCHSPMDUJZl0wJ/smSR7vSD1qk5xiy0taEOfg/QwOpldbhFC0ANvq4dmJcJy9XN9/lmzJaWjcM7828LROrU2H4N3gKNYAHfeswYEWYBU1FrlBp1mB0v6XQH91Y4KisW+tkMeGcwPrhvnl9Vap4z9dnwkCksg2ipxKjP6i/zzy6liQIuUiHE4EyvXm02HDgEaVGNlcRCilncs8e8aZNAeYVMMAELmwSyAtlA+1hBxOl9Zs03ZkmI9P++uUMMe3sjyaaHYNXWcEB0aO6qTQ+LxQwm9PdPa6la0gZP5NnyrpIqwJNogNcRefpUW2JSCPcij/P3K9WntgbeD/9uSZ9q0y0aDgf/b1rgPAoE9bOuxzkg0iawaocj6mY1xj/kUQ/aYK7t7PwK+IaDK2Qcedb256fSsRpRfsoiMG0EgCKBOPbhXObnFtWkC3JpxdjxO5YeVD8BiiZqanycqhsP8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The return value of strdup() is never checked before being passed to
strsep() and strcmp(). If strdup() fails and returns NULL, strsep()
returns NULL as well, and the subsequent strcmp(NULL, "all") is
undefined behavior, likely causing a crash.

Additionally, buf is never freed. strsep() advances the buf pointer
past the first token, so by the time buf would normally be freed,
the original pointer returned by strdup() has already been
overwritten and is no longer available.

Check strdup()'s return value and fail cleanly on allocation failure.
Keep a separate pointer to the original allocation so it can be
freed once buf is done being used, after all parsing has completed
successfully.

Signed-off-by: Anshuman <anshumantewari123@gmail.com>
---
 tools/testing/selftests/mm/khugepaged.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 10e8dedcb..a84fb87bd 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1110,6 +1110,7 @@ static void parse_test_type(int argc, char **argv)
 {
 	int opt;
 	char *buf;
+	char *c;
 	const char *token;
 
 	while ((opt = getopt(argc, argv, "s:h")) != -1) {
@@ -1135,7 +1136,10 @@ static void parse_test_type(int argc, char **argv)
 	}
 
 	buf = strdup(argv[0]);
-	token = strsep(&buf, ":");
+	if (!buf)
+		ksft_exit_fail_msg("Insufficient memory\n");
+	c = buf;
+	token = strsep(&c, ":");
 
 	if (!strcmp(token, "all")) {
 		khugepaged_context =  &__khugepaged_context;
@@ -1148,26 +1152,27 @@ static void parse_test_type(int argc, char **argv)
 		usage();
 	}
 
-	if (!buf)
+	if (!c)
 		usage();
 
-	if (!strcmp(buf, "all")) {
+	if (!strcmp(c, "all")) {
 		read_only_file_ops =  &__read_only_file_ops;
 		read_write_file_read_ops =  &__read_write_file_read_ops;
 		read_write_file_write_ops =  &__read_write_file_write_ops;
 		anon_ops = &__anon_ops;
 		shmem_ops = &__shmem_ops;
-	} else if (!strcmp(buf, "anon")) {
+	} else if (!strcmp(c, "anon")) {
 		anon_ops = &__anon_ops;
-	} else if (!strcmp(buf, "file")) {
+	} else if (!strcmp(c, "file")) {
 		read_only_file_ops =  &__read_only_file_ops;
 		read_write_file_read_ops =  &__read_write_file_read_ops;
 		read_write_file_write_ops =  &__read_write_file_write_ops;
-	} else if (!strcmp(buf, "shmem")) {
+	} else if (!strcmp(c, "shmem")) {
 		shmem_ops = &__shmem_ops;
 	} else {
 		usage();
 	}
+	free(buf);
 
 	if (!read_only_file_ops && !read_write_file_read_ops &&
 	    !read_write_file_write_ops)
-- 
2.55.0


