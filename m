Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0741ECAC598
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 19:52:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7308C8E0017; Mon, 15 Sep 2025 15:52:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E1158E0010; Mon, 15 Sep 2025 15:52:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D09A8E0017; Mon, 15 Sep 2025 15:52:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B1CC8E0010
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:52:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 120451604FD
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:52:32 +0000 (UTC)
X-FDA: 83892531744.15.B9500C5
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf29.hostedemail.com (Postfix) with ESMTP id 44844120003
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:52:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sVTnv7QL;
	spf=pass (imf29.hostedemail.com: domain of 3fW7IaAQKCMgt9rzu22uzs.q20zw18B-00y9oqy.25u@flex--fvdl.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3fW7IaAQKCMgt9rzu22uzs.q20zw18B-00y9oqy.25u@flex--fvdl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757965950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0svEd+gVOCVsfCPBdmnwBog7VppNcoJfmCv6ADiIbr8=;
	b=0mmDzwqxxHTea2K27fSVQ5RY6GfURQPIstftJjq+QCsiyLQblIKBqEfk5Jxp67OqCkg/Q7
	l46u0unX7PQZGL0J4spokpBmH5q6Xsdo6/qAYFd8Zg0NaI/tCZorXvwwthpRHmPDa9z6BV
	6wWOhXAYBqjv+BA9X0RJALueHPlxkXo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sVTnv7QL;
	spf=pass (imf29.hostedemail.com: domain of 3fW7IaAQKCMgt9rzu22uzs.q20zw18B-00y9oqy.25u@flex--fvdl.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3fW7IaAQKCMgt9rzu22uzs.q20zw18B-00y9oqy.25u@flex--fvdl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757965950; a=rsa-sha256;
	cv=none;
	b=U+gVvyQXyzaICpJjyBlaQZhZwh4bWXOEhtbjufIl7c8tyRgmiHE/6vRxUnsgi1MheO5Bp8
	S8RCXQ7e6HyvuR/95xt09Tx7Us6XoAP288n9trE3lLXlYC2V2LstwoT5dBMH0p7huSaNMy
	Y1ni3OIheyvUgZCaDTAzhf+VnoHEiYA=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-77429fb6ce4so4278858b3a.2
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757965949; x=1758570749; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0svEd+gVOCVsfCPBdmnwBog7VppNcoJfmCv6ADiIbr8=;
        b=sVTnv7QLzmNuXW5WMUlExmZHnAhaCRSE5WR8F9OaUUB0cJC6g73s4SL1ClcugYXLSo
         QLX1xqEyRfpEYXftl+2lmFwnIqVHF12GdMIortVp3bIuvmEVq4J7XzgN0DarVccW/I7E
         OrrBdPZ2t7FIDcAYIBwu3CMFCbyirn/ZkvZQTG6Ke7ybWGpdbLPKGiaLwnTgpG+2ux//
         OScQ2fo8Zt521MMEE2PGIPSwrW9feM73/z1X82RfHQc7ZUP8F7acKeYc2Pj5JMVbX246
         eI7R29dNFZ+faYYolrMdc9UMcYwp5TtE4m8VVBn6lXmtJRN6tvMz2gAcc43p6H6+xrFJ
         lMBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757965949; x=1758570749;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0svEd+gVOCVsfCPBdmnwBog7VppNcoJfmCv6ADiIbr8=;
        b=VeRMOJAcm5ueHulEJ4Zx7ZcZ3eMxKcJSnXJSkuCsSvD/hkzNcpzJv6/izEwo/cgXbu
         dIFtkCjGHqh0pDFK9IHdMo1pn7HxdkIjCBmpeaSaU01QPrajZhBjJRvS7K8Hryy70Ey0
         mXQqJklK6FxRXAbt+G0IKbCx37yBV57hzRWuYdf81imvMlT53j512wYLKbldBhqXRy2y
         fnIiJ1X5UCn8zeemX4NFCh/v7PGLLq8yJirBhYP3CWGs5IVRyAiiPQxYojsywY/WmCPc
         +BsP+urCLqllGI+A8GuCETuQURS3KSM5zFIW2mNc2TDpPdWqbGynbyDOIKEJdF/Sb5cw
         anCg==
X-Forwarded-Encrypted: i=1; AJvYcCXVs/0D6WEvhZAP48oOmQwMpeyjGBaBC3ea3jMbgCYAsi+R1ujvXrB0azx/s9TurJoVG4CMpZCIEw==@kvack.org
X-Gm-Message-State: AOJu0YxcPVRftRuGW+AfR1MPsGiEspxye3rupm1K5bqmmopTX+vlZvHE
	d/jzZPC2Ka4zGzQF3gYJGyTyKruL3d04Z49fMuWFSdPley59EDl9QMKfpjnkJ2pyLi1Isvtfew=
	=
X-Google-Smtp-Source: AGHT+IGSSnGP60FTHWub2ijESGSasTj/5U4SKgrsznRVHg7jm6k4jw2NVaDNXlZHD1qi1VzPFvCEZCsL
X-Received: from pjbhl16.prod.google.com ([2002:a17:90b:1350:b0:32d:a0b1:2b03])
 (user=fvdl job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6705:b0:24c:cb06:f0db
 with SMTP id adf61e73a8af0-2602bb594afmr12621549637.35.1757965949116; Mon, 15
 Sep 2025 12:52:29 -0700 (PDT)
Date: Mon, 15 Sep 2025 19:51:48 +0000
In-Reply-To: <20250915195153.462039-1-fvdl@google.com>
Mime-Version: 1.0
References: <20250915195153.462039-1-fvdl@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250915195153.462039-8-fvdl@google.com>
Subject: [RFC PATCH 07/12] mm/compaction: optionally use a different isolate function
From: Frank van der Linden <fvdl@google.com>
To: akpm@linux-foundation.org, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: hannes@cmpxchg.org, david@redhat.com, roman.gushchin@linux.dev, 
	Frank van der Linden <fvdl@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 44844120003
X-Rspamd-Server: rspam05
X-Stat-Signature: exuw76bc6qtgeyg7wfgfwttgppntic7y
X-Rspam-User: 
X-HE-Tag: 1757965950-393865
X-HE-Meta: U2FsdGVkX18eMY365YTKQ7iMiucvAJQT2qA9U3OQXYsOY3K7Tegt4+3S1bcAf1bgsN9kCuml7pL3rKv4oh8/1mWjzyGILe6Cs4ksPQ+yAHdDSOuQv54svg/8DR+oqq1d9ps24ccQIDFziZvXc94CKWxe3kO+Zlt9gcIIer15LfQ5/OoZgS4qEM5HRa1IFij47OxaTsTL2kCCRp3ZIYyAck3j8IyAgMxi0d4UeaOYQ85OKlpslzioo/FnA6HrIecXrkWCAUpDag42uzIe0lpRz9bE4Wvlr6LE9zSfTImR+liwqnnkG9AhYTyHzQy+dVKBG+cJ+X816F4NOmCgqqLxPc7k38oAx1Khl99Ahx/z26lBAV875uuVqb6B8LNAMrNx1UukuwajOq8CdmuMRil5ObXWKl2bfWh4LELt7Cfe4OxiU8NglKG8PyrW/vtmPP4O5tYEPParYAwomRkQZPXmsJx72BDmOb25Hppr1LqLZnfwRRkJUlCLu4MmiAtRbOVKyKK37nov72+E0c/IBiJ9/QO6Ad/uli3Xb2z9ZiSoF3HvZZAhUYv50X1hB/sBOdp/O8Wa8Xd3BdzF2yVx5iqUeaKzhitvQ4lJlnoaGHNC7sCvgA9wXquqJVYcGRQzgYw8mODsXTFcAzuVVk/j++82TD7CtHHkLlKl5kinJp9EVg5ULk/3AuU8RLgrZ6Yd+xuUCori/dX+0VQhPOBteILg1ABJg2noJpcxdIqmfiT9D5cBQzf6+1SqiO7Dbu2rlJq3J0yUNBGXJ67DJbEf/eg4w6Eyc04qmgEDjifYPJyMn/Cx98M6Ym8n7IVzY7X/HGd/O4UJ3ycKXjSeDtZf7OLPNEYfhrmDgAnaeJL4mmqWC4r8e1t1M/DBDV5ar82ykSaDMfu3XgH7WvjS5+/s2n6FD4Y7kRjURZVSprctRm1hY60Yx+mxGcdoW/l6FmjsyUatICHSiSv6tf9GwDYTmHk
 HAHZmwsc
 pLdQlmbE4AaWmMz4j5e89RetXD9M86Y/6Hi2uuhLLfAMQrUbAQokHNSv0DfyAFzBfRIE+bizFMKk1OJ4B3dUC0uWjrwIc+r12m1B+XYazuIOyhs3vofq00MzOCLAaCZipoQYuCppUVLJhBhthv32gOZHdMuG5dZGjBInqo1tRyEfuFXwDkmKzgsjyLcSknvAjsEMOQJUnDPooOuiO/S0nyPxjFp6gW3DAWETnNFkT2QCh4q+Ck5V5BpHMxmbIzdD6vR58NDMSiHiFp1+YlyfSSjQ4WHmHM1fmuvp/bmU7SAI7whuTEriB53g97l1yHATuajRWjs2LpMvYB6VfIjmUFOXeVV15WLWGDuUXO5GkGQQ2sdeNbgUGIzreFHeSo8W4UFt+8cH8SGZxt2AB8pKMv3wvmQO/ay9GDYVC062YvnzuqeFiqbzi6Vigj+SIeGNzbM+3zcew2x49qppxN0pUI7JQ5+yAoGz/aZPEkhD5KCjsQ0ZD9MH7pBtfVm4ABJh3a+wCwOx4rfY46x4YYsJePZ2zvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For CMA balancing, the compaction migration hooks can largely
be reused, except a different function to isolate free pages
is needed.

So, add a pointer to the isolation function in the compact_control
structure. If it's not NULL, use it, else use isolate_freepages as
usual.

No functional change.

Signed-off-by: Frank van der Linden <fvdl@google.com>
---
 mm/compaction.c | 5 ++++-
 mm/internal.h   | 5 +++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index bf021b31c7ec..6a2c06e356c5 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1813,7 +1813,10 @@ static struct folio *compaction_alloc_noprof(struct folio *src, unsigned long da
 	if (start_order == NR_PAGE_ORDERS) {
 		if (has_isolated_pages)
 			return NULL;
-		isolate_freepages(cc);
+		if (cc->isolate_freepages)
+			cc->isolate_freepages(cc);
+		else
+			isolate_freepages(cc);
 		has_isolated_pages = true;
 		goto again;
 	}
diff --git a/mm/internal.h b/mm/internal.h
index 45b725c3dc03..7916d8be8922 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -873,6 +873,11 @@ struct compact_control {
 	unsigned int nr_freepages;	/* Number of isolated free pages */
 	unsigned int nr_migratepages;	/* Number of pages to migrate */
 	unsigned long free_pfn;		/* isolate_freepages search base */
+	/*
+	 * Function to use to isolate free pages, if applicable. If NULL,
+	 * default to isolate_freepages().
+	 */
+	void (*isolate_freepages)(struct compact_control *cc);
 	/*
 	 * Acts as an in/out parameter to page isolation for migration.
 	 * isolate_migratepages uses it as a search base.
-- 
2.51.0.384.g4c02a37b29-goog


