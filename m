Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16B32CAC5B9
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 11:12:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 675B38E000B; Fri, 26 Sep 2025 07:12:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64B768E0001; Fri, 26 Sep 2025 07:12:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 539A38E000B; Fri, 26 Sep 2025 07:12:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3DAF78E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 07:12:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE0CC59FB9
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 11:12:44 +0000 (UTC)
X-FDA: 83931138648.03.0D7DDF6
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 42B2240006
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 11:12:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=kwgxakVY;
	spf=pass (imf27.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758885162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tQTRPI00t3Iwcmj4XDoWtrkyxihGEGFGUxvVEBrBIuE=;
	b=78BtvQinEVOQ/qtrMNw3bzfxSZelRtAaUHw5SrHfz1kZP2bhn80kTy9/h31ZOcxgbz5FHo
	AthNIGnSoEBT9LSxYkKSXQaISV7tQD5bPiV4cvB95E6llORuVgmO5oODPJovrtMpsfuhjB
	OJK3lR77PCGxY0bO5nJxhecALr9fcpE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=kwgxakVY;
	spf=pass (imf27.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758885162; a=rsa-sha256;
	cv=none;
	b=Yb0osn2pXNA8eQsQawfNt4wZdZj6bVDrz/jk0WY30coNZvMvTEyvQdy038Lh/jdwMjZNUS
	FqlzoAVvUA8oaJY3C0SIcK1Qs0HybluOufj1zzmH5egvGFg/EDUEcjrw1Mw6sNlZ/rTm1W
	mymhb4tx+EzMtY8ADfw4OwmWcZjjql4=
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58Q8wtYK031663
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 10:34:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	tQTRPI00t3Iwcmj4XDoWtrkyxihGEGFGUxvVEBrBIuE=; b=kwgxakVY8KcJifUZ
	YeKnMRVPZGZYGdy/mZ0NunAsg78nX9sR8/OeYqsD/HaAwjgvS8Gnsmfah3Jg37hk
	tDG2kTHR70cYCa3T8DBu53eIGRTZdoYBAJzw5A24pkE3130H1WBj5d/4ZB2geH4z
	Co2jg30fey9ptb46WMMgkwnBQFo54RRje+FsBa/EcOeD9rk1gTOJkcxn4NrCJjsr
	V0PYx57j5jtuIcrJGcxNdOC4fd/xhR/SH0MGQf+dDI1deoaN+EAdGZYr130Ml24y
	IAFLOb48W5s3wFgEf2SaXNKr52sHWc6p1cIvMUqJW70JWAmM41A7ShLjJYRReZEi
	8htJPA==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49db322gft-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 10:34:58 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-277f0ea6fbaso24243645ad.0
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:34:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758882897; x=1759487697;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tQTRPI00t3Iwcmj4XDoWtrkyxihGEGFGUxvVEBrBIuE=;
        b=sMgkPfk2p+QttykpssRBtTLiovaPs4EKULSZwsNsL2R4xiK6ubkJmCE3KEqOcwA0l+
         FgxkWRxH2PmpWuJT4Y8Wpo3Pkbs32SAIVt42CRT9jowT6vDlqCiRDT+L0Q4bq2Zo0HS+
         B6PG7i3VWH0cnsxWU+VU8JaVQCKFmO/jG1NGGzmyQU0bUqNZSRcHRzYxDp5QJ9ulpzKx
         HNTx1iuERKKfcwI0rUzL/dD8vBpY9X5f8L+zt0wLZ+KBSBXx5pE9yFENgvCKwc+EpxAt
         TLOzik1H8CGDBeOaCMdq5p6rG9YYutOaowhPCtatDVdwzDu6T23PM8gxsSNZVzGJybb/
         ZHEQ==
X-Gm-Message-State: AOJu0YwKLQsMEwUnOc+5/Z+/hXE0mE8ixtNAt/fxjGIfnjPJqNltYfHt
	Q/19dy9XxblxRnmMHamdhq9XqQei39BGBZNz5Zvi0Jw7QW84BKXWXe6TF9XgQ2voxBMAYG3YpYp
	QJHamk+bvfS5r383lV70HSZpEuxpFLmraFT/j4pWroGLlGCayCzkmsw==
X-Gm-Gg: ASbGncsVkbcD+AeKWG9A0dkLZevB+kf7Tk2EhQHG7sq1J2X6jQXXoo+DozhWZRd1+l4
	FTj2DLA0+tUSRouz3nM9LpMf3VRV4it1zF/2cQ5sNvZ8Vrb2YUFWDJHuvkwHCrWZWQLGzRbC1vX
	jrIarW1faJwPjHiO8erXp5MBtpCCLJ53xwJdDrvoCugEX1qBwVjPVjGMz1IPLi7poB63TvnyW6A
	9r1wDpSVWsZiJS71j9bfusCKF0jV9GJFJ//mOI8qdAzibfhcMjaMIyoruldGCJ5HICOoJVlzBUl
	gkX3JOZGC4OqHrSA/lT1itF1nF3kU/75Tom8srobom8=
X-Received: by 2002:a17:902:dac5:b0:27a:6c30:49c with SMTP id d9443c01a7336-27ed4a56ba4mr63933435ad.27.1758882897485;
        Fri, 26 Sep 2025 03:34:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQZLoB0i5e5XB1V+W3mUt+1umIZGLDWuoQ0hIt8CzKfmnNTqqtoyFHRmb5QyB9qvjJ+QBhzg==
X-Received: by 2002:a17:902:dac5:b0:27a:6c30:49c with SMTP id d9443c01a7336-27ed4a56ba4mr63933185ad.27.1758882897053;
        Fri, 26 Sep 2025 03:34:57 -0700 (PDT)
Received: from hu-pbrahma-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed6aca043sm48950175ad.138.2025.09.26.03.34.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 03:34:56 -0700 (PDT)
From: pratyush.brahma@oss.qualcomm.com
X-Google-Original-From: Pratyush
Date: Fri, 26 Sep 2025 16:04:49 +0530
Subject: [PATCH 1/2] mm/numa_emulation: Refactor NUMA emulation size
 handling to use kernel macros
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250926-numa-emu-v1-1-714f2691bf8b@oss.qualcomm.com>
References: <20250926-numa-emu-v1-0-714f2691bf8b@oss.qualcomm.com>
In-Reply-To: <20250926-numa-emu-v1-0-714f2691bf8b@oss.qualcomm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
X-Mailer: b4 0.15-dev-56183
X-Developer-Signature: v=1; a=ed25519-sha256; t=1758882891; l=1355;
 i=pratyush.brahma@oss.qualcomm.com; s=20250808; h=from:subject:message-id;
 bh=ue/wwaSB7KvvFXy+GEu4nRnNm29RUiSGecg7GdoqSrw=;
 b=rjyExsBXaBOIECk/ZHMmY/egev5pzKf9AjufBaupNC0pYEf6wHCnJRoekDqNNspeRaYzk5wor
 /ozwiImd7n8Ab8OEnIwEVnA3SS9QKuVy7/F5CGHPTiIbSS+NqZ+1cZw
X-Developer-Key: i=pratyush.brahma@oss.qualcomm.com; a=ed25519;
 pk=ZeXF1N8hxU6j3G/ajMI+du/TVXMZQaXDwnJyznB69ms=
X-Authority-Analysis: v=2.4 cv=ao6/yCZV c=1 sm=1 tr=0 ts=68d66c52 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=EUspDBNiAAAA:8 a=Mi5Fj5UnNtvaIr5cJzMA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-ORIG-GUID: FW7ajgDq421ppFCrH_tCugKGS0NQpEsn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI1MDE3MiBTYWx0ZWRfX4fVo1bBe1tz1
 SKrdrz8+0LgStXRJE7oSpjOaMJwaUrz8JwQzJXZgR0qq2AHmEYsOxReYRfkeXeDKlPT1GVxq6s+
 wUU2T0VJ6lzX242Ki4JQa+XmLw1fgl3Rr018aGjew1rxAJ2sk5UeAI0pedqPqDuXvLpC3ft4dXs
 1ogbywGOP6nLs/u7bGLPqrsxtoBxgkReWlub56cS4V5rq0brgwjFOtX7h5k3bXgavqS5ZOeVToj
 YYTLHQ5vXNDkFFqarf9NOMFBJq/e7aB4aqV+qiGp0ZzIxPFtklLx1bzjgsCxKC+MLrX3NYsQwun
 emRH4WqSGth6F4k2v0PJJovjfYon8wKgkbhe45a0nsBPhI+HB+ng9LVSUkoXl21C/V6frExshEF
 Bjec/3mGeZEl2e0Ip/MK0/x8OOZ3vA==
X-Proofpoint-GUID: FW7ajgDq421ppFCrH_tCugKGS0NQpEsn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-26_03,2025-09-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 priorityscore=1501 suspectscore=0 phishscore=0
 adultscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509250172
X-Rspamd-Queue-Id: 42B2240006
X-Stat-Signature: iz1uumru8xmiam85p1gtuny9bmownnzq
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758885162-147663
X-HE-Meta: U2FsdGVkX1/V+LlFM9M2/sN3DY8rNJNLJPoi7eaeud1+MbPO7VfC5tv1sYO+yxwKffsf+1w5Bj+/K4ZOiT+Ng+3BWRO5bDleM3Nu/R7I0iXV9uGu7XWqYeKy6UqWOPlyvPsRlymOUnfvtMJiLj4zjzWtCpWv0iNopffljE1OCJjlIho7m0fCkPpAM3me4EC7vNlwve5MHnrM3jCyoyxj3YIw6VCv8kXCzxMs5xQ9sdNhf8KT3Zou3at7PhXraOo/AfC/pwbDpDjxdf7KiDMbrslKMCWfG+pf6DF/nE0/rwKda/EYcS5Z4hx4/ZnfuBxnBudepWYB0Wmljpyr6V6tH9uhHD9Zp4QvzKKaMxetHlL3qHE5sjV1OiCkYlp3+zJ393v3NOENN/uLWQcEBnRKxpLPFE0kT6E4z5rKDz9B72d+9/m9Dg4RXiViWcymuabSwPho/zsc7wnCB93tU4L8VuZrEe/jLxu9ILKAj4WZSgZrRLwm34YyVHTKaNe+fNftqYWt9mSti0xF1yayl3OI7W5NHoqeMXlxGMxUkqa+7qXhi4J0djWE+SxHxSeaAkiecmE4jKNSl1ewjDfqzUlYNc2lNYR2u7nIByvcrCL0OCmt2vO6WpAWGqWEja46wwEqQ7OLhs6p2ETPUSGtKqfdHWfxtvdyfIxVmySPCuJKl843RWK+HYMnVxHKM4Y+/bhNLeTGfvjH335V7ZTKlKiGq7ILheQPnjMu/zziTeAfOZjrUYzuVSoiqu673zF45BLQ4PIzTH5X5cg8092E5IuNcJG5eekTL6esLiBNRq9n3lNpNN2mMXIRzinnP2Ba9TPBlRqpfICz3MM78sVDjEsVdlLdv8+073IVLIPp357fcRxVuxSQ/NrlfRT94m/dvqR1GYC39ReHpRRZ/vOGrcmFtDU5a39fQbVaTp8VxYikipVj626Soj8x+6tX/7/2pOIz2JHAaVTrgTKLx2hjPdt
 sCRp3eg3
 MkBStL6JRZ56+67zrRH3wox1jdWI1XPpz7lfKEP0EomLKbhgL0cWtHiDVS6ZR0QsVXeG9xxLaR99a1/120UmhxsRBRKIXYFP0bjElT0728cXV4gBaYGyulmThTT7Anf22EMvXAJc5vbUiuJ3qcdV3tK7eg/PzrMG3RyRK+oKsLIPAhO21KiROHy7XTmJPuReMEo0xw5hAd8u5b6Ab8f1MVRLe3Z59ceCYJPO8RB8QcwtJrIjAwzsvXPTpa41EGHy/0yWWjeCT4G9Hj2L3XayLABiYJ2YmDqSqszx2pJXr0sdnzwbZoBOOpzveXPmlNWiDhI/S0zOJXEg2z5ZGMAhFY/fVtzH7a17SNYsSAYGdLFVB8pst4TGq3GMsPrOETievAAh8h3qyqsMbU4Bfo+iFndMwOIAQzXdDpFNwnh/1zYmVaFI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>

Replace hard‑coded 32 MB constant with SZ_32M and apply ALIGN_DOWN for
clearer calculations and maintainability.  Update the related hash mask
usage accordingly to improve readability.

Signed-off-by: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
---
 mm/numa_emulation.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c
index 703c8fa05048..2a335b3dd46a 100644
--- a/mm/numa_emulation.c
+++ b/mm/numa_emulation.c
@@ -10,8 +10,7 @@
 #include <asm/numa.h>
 #include <acpi/acpi_numa.h>
 
-#define FAKE_NODE_MIN_SIZE	((u64)32 << 20)
-#define FAKE_NODE_MIN_HASH_MASK	(~(FAKE_NODE_MIN_SIZE - 1UL))
+#define FAKE_NODE_MIN_SIZE	SZ_32M
 
 int emu_nid_to_phys[MAX_NUMNODES];
 static char *emu_cmdline __initdata;
@@ -112,10 +111,10 @@ static int __init split_nodes_interleave(struct numa_meminfo *ei,
 	 * Calculate the number of big nodes that can be allocated as a result
 	 * of consolidating the remainder.
 	 */
-	big = ((size & ~FAKE_NODE_MIN_HASH_MASK) * nr_nodes) /
+	big = ((size & (FAKE_NODE_MIN_SIZE - 1UL)) * nr_nodes) /
 		FAKE_NODE_MIN_SIZE;
 
-	size &= FAKE_NODE_MIN_HASH_MASK;
+	size = ALIGN_DOWN(size, FAKE_NODE_MIN_SIZE);
 	if (!size) {
 		pr_err("Not enough memory for each node.  "
 			"NUMA emulation disabled.\n");

-- 
2.34.1


