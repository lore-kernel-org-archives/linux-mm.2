Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95688C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 13:57:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C9FA6B02DE; Thu, 24 Jul 2025 09:56:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 979A16B02E0; Thu, 24 Jul 2025 09:56:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CC826B02E1; Thu, 24 Jul 2025 09:56:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 67AA96B02DE
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:56:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2DD84B95D8
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:39 +0000 (UTC)
X-FDA: 83699308518.11.F05C67A
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id 45F4014000C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=IZouUe2i;
	spf=pass (imf26.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.47 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753365397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qf/VqrIHQh0utzrTdiqqaO7yt4rF9Ojfq/Zu+7lemII=;
	b=PHVj6hftfEuyNbCFXzgBI1a+y2Zy7DkYpduem4AK4Y/psGJmk5vuhZK0NdB/4XLC3I4DGq
	usFtlhsocwb1SOroR6B/IkY8U1PhP64dFTMPHrSEfL6T7+HnHkXc1GUMYAKUuS8YQzO38Q
	2/eNotqaLi14tLaHGGV54LNVKmXTm1Q=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=IZouUe2i;
	spf=pass (imf26.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.47 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753365397; a=rsa-sha256;
	cv=none;
	b=x+sOA0t6r1kPosBFArsCtqM1xWMmPe28cutFbvnfcJNxW+tlw6z3odtn9tG8pQTw23E0Lb
	dEbYlYDsv+mQcUTIaGZzZqjBAurNsC43jSEuFE0aghep20APCyIiEsl2+oVRXsVkkBNx5/
	PqoGqf3ImCM827Q9f+BJhgX6P0B+IrA=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4561607166aso7022765e9.2
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753365396; x=1753970196; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qf/VqrIHQh0utzrTdiqqaO7yt4rF9Ojfq/Zu+7lemII=;
        b=IZouUe2i8JF5H2JYwXerEfFgYvGC2ID8f5Xoe2maNGK/llP27SZXAoZ5MbYNzTyD2E
         44g+Jl0FyY0c40qr/KkVy/URGZVZNFILjcw6fkELTKV1Naj9tw8WYQKcYcsHvl4AsbXY
         XUlj9F7yw3KroXeE32zwEV3hFSb2TfgR4kF4jd/tMvHN5CaWsEXg2hp1W3sNlwuefWSY
         AVo95o9NHcENDg0zrrLysE7jQqPTujajTb5sueEocLzrTD5nxZbpAh/1H9DWr6HfrGL4
         O7tBl6W1nhF3rx1yo8QeAobTXk1J88W+mUtp7ivO61si8MZ5uGbtovGfD9j7noLJv8nL
         k1kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753365396; x=1753970196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qf/VqrIHQh0utzrTdiqqaO7yt4rF9Ojfq/Zu+7lemII=;
        b=vrY22ac1H2KYex6grFyyofjPUVCJa2ewKuCKH/g0CgUBLKmTtT4fZRHFwylp0RtvY+
         ur+YI5z+SBkNjacwifcN4yxVjsBm9dH2P/CscgEWb/4ZPEEEOnOOWDTRZudzBFf5Ld5J
         psLYutgUqs5roTJ7ECeWade8GeZZ3M6gfFBsmuVcS1wOG9D2Pcau7oIx3MogUUPKf5xq
         mC15tqg6zrHEbe3o+1hcIEGd6csmKNKD5Oes0IkxeUkY8aYFZjE5pGLIXWik4JrMpLiT
         PkkFZbGaO8w6ZIeBr2ae2JufiKmDez9wiP1zL2pEtCWLfzkMUGMKc6M10i/YsxWiC2bC
         UpRA==
X-Forwarded-Encrypted: i=1; AJvYcCU7IJg0xhYS24H6SHXq6XOwrSniFDr/LqxvBvVMOgdEJ4o+hjqW4adcX67fXk/TI6nHJHnlNFVJ/Q==@kvack.org
X-Gm-Message-State: AOJu0YzQKVbqRBF6wTR+oFqHXdL39dZQcLGkrMXAXPYjbF1kDXyfE/w6
	4vii/Q+oqPZpMjftrEL5yn01Wpm5BCHQH4x9kCCAgvBt3lxx5YqtmwDFO4ULtJPRITg=
X-Gm-Gg: ASbGncsxY0pWh5KJlQJ1yt7+5Gwvm21jOIa4iuxcHYDoagy6oE9Iam+TnZgdkrRuxOt
	hvrz4QjEFuPG2LkFIUuuFYgYCJPb7K9MRr1s3FaIPdjPZAlWeXcWMSa+yHzFJu92Oe/CTJy0uWN
	NFx5PgKdufp2/TuHa5E3Tnn5VcSa3OykJiBPnr/HSMEOvp4BijRzN83tkd/UfZcA+hU2HDxfvZy
	gt1Pjx2RN5wcn5TmjBIzplrVwSDbW8bVQiec79KPNsfX/GBOyg1j1mcUfUnxTeFS62sJBBqpYf4
	NiwwkpRUWbBt4wK5/wqXj1W2hLLD8YoWU3QFmYr6GNJXzpAbHGHHHpDKs/YijZd8kQuMBGuM1Wy
	FPHFBNI4csqedjcmxZKREZd1e06pRpqrFTnCCNHpos8c3oFp5N3oic7jI05TOgeNEv3cADYCKJd
	NYn2JUWNiL2aft
X-Google-Smtp-Source: AGHT+IFzdwFCiaRsVqkw+Vzf0TWhLQA78AFXGtgtYDTFYK39RF9ZemaLlLUrmcl7qJaLyA5hKTyeLQ==
X-Received: by 2002:a05:600c:3b28:b0:456:24aa:958e with SMTP id 5b1f17b1804b1-4586a8cc2famr61338095e9.0.1753365395873;
        Thu, 24 Jul 2025 06:56:35 -0700 (PDT)
Received: from eugen-station.. (cpc148880-bexl9-2-0-cust354.2-3.cable.virginm.net. [82.11.253.99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054e37dsm20889375e9.14.2025.07.24.06.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 06:56:35 -0700 (PDT)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	eugen.hristev@linaro.org,
	corbet@lwn.net,
	mojha@qti.qualcomm.com,
	rostedt@goodmis.org,
	jonechou@google.com,
	tudor.ambarus@linaro.org
Subject: [RFC][PATCH v2 15/29] mm/init-mm: Annotate static information into Kmemdump
Date: Thu, 24 Jul 2025 16:54:58 +0300
Message-ID: <20250724135512.518487-16-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250724135512.518487-1-eugen.hristev@linaro.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 45F4014000C
X-Rspamd-Server: rspam06
X-Stat-Signature: 9ctbm57q8so9ebbhbptprtq99kpgdptp
X-HE-Tag: 1753365397-347083
X-HE-Meta: U2FsdGVkX1+v342JMmaXOsxda5jvGGwOPI6Osn3L07F5IyD1UZa/w98siJrQHsC1rbLMjkO5FNDGhCJiH87DJoxwa5BUuFJHKy3X0VDBG4lSV5vjOSa+oGLMj4EEv+TQ//FSAawJ3q0229svA2o7/zg7Q5udo4HnroUCw5/y2l92/OGQOAqaHfMREb/eCvIKBArjiWs/DkecsdCGdJ3lKx6Yqm1ZOgtv5BXWHvfIP41KxHMZ+QaEvqkWBMsokhAr7K4lRkgZi3UP3X61ndZiVz5XktYXhn8vu8ThqXx8g5wuNEHOsQ1UlpwFGzeC2aN3vYcbB2my0aeM/vmZogM94AVAVOXFn9C4q7Huh3BiLbyxzYQIqW9I4iYbL5CsKGbbGPa+/huMbz28QJxXkbtE1hstfK4yEwVacCBKk78YjKne8NmyBcudancQueU4W7MBnNxaZU0m3uBLHLmHDR+P/H69joxJzgfWJkMHOXo0M44Sxg98d5ELy4gaJWOLRjsgLNQz/CM4wic8W0qQWULQBZt/s2LkDd61cPIQ+OjSXtAh/QZpK9ZjNMkYg8JZKb04c9viVWLuz7zJPvg3pj7tjWtUX7w8H8YT3+vAGTtrzL87bwgwzt7mdENE5qJI63ZbD9kgV+mLI8KlskeFzOECZjdnUTdArvhLvdBZPE+mmYceltvP5bFqqR2cw7mCaJjMCpK3Z7wTudxv/Jv0GY3LFQ05JJRPUM2TSyG/wPkzJjEXiqKSueqze3Dv5zupvgkw6hTLobHE9v+S9Wvy4YTA/sLWiCeca/e75rLRK8sLFXapF2UuIOBpWo/7UINcCL1J2LovbSMC6ZZUavHahzZbr0hkuxPT9ufSr6OR111NIK3hCAa6cWC1LcGv221cyTjwSgb/3B3OX84Iptx01H5vhRqRPoU1GPZqkXi//vMlcCetvH2XzXOYNdSRNSFVHDRo5ZoJWqc3MIWGFBqBVa+
 S+EtTq5u
 NFjDK3dZM7PNw1flk2kkr1tbWYCBp08e0G/sZX1H1FQkb923UaXcA0iXmNF41BwCeH8KrEknG6xz40heO/O3Yk/o39iEW5KV8q7DFHWBI1fCNdx1srktJkYffQpRXoEMPV0chwYz9SqoErEMPeiEvYtVfQE0YTNVQlpRNAEZNHHxgmyQGHNrnzviqBzvBeVrTTT+av4vScRg1ENe0R1+HoWnMQP5MObneU6wqbMgjWcdzx2pdpe48PouBXQ7N7S1PXq0dmasBlHGqLy6P09DvycPTmmtdu6sfLRiPS0Q73EnFaUndq41GRauVkq34/YqlEZfjkFiV5LolKN/jqe8GNMVlPZu38a8m03sMaPmySHjTIDSu+mEmbeLjOBlIRbTejL1aMCDhZryXEBww9PmpnEwGTw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static information into kmemdump:
 - init_mm
 - init_mm.pgd

Information on these variables is stored into dedicated kmemdump section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 mm/init-mm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/init-mm.c b/mm/init-mm.c
index 4600e7605cab..2dbbaf640cf4 100644
--- a/mm/init-mm.c
+++ b/mm/init-mm.c
@@ -7,6 +7,7 @@
 #include <linux/cpumask.h>
 #include <linux/mman.h>
 #include <linux/pgtable.h>
+#include <linux/kmemdump.h>
 
 #include <linux/atomic.h>
 #include <linux/user_namespace.h>
@@ -48,6 +49,9 @@ struct mm_struct init_mm = {
 	INIT_MM_CONTEXT(init_mm)
 };
 
+KMEMDUMP_VAR_CORE(init_mm, sizeof(init_mm));
+KMEMDUMP_VAR_CORE_NAMED(init_mm_pgd, init_mm.pgd, sizeof(*init_mm.pgd));
+
 void setup_initial_init_mm(void *start_code, void *end_code,
 			   void *end_data, void *brk)
 {
-- 
2.43.0


