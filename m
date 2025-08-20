Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB424CA0EEB
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 00:59:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 603328E000B; Tue, 19 Aug 2025 20:59:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B3CF8E0001; Tue, 19 Aug 2025 20:59:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A2538E000B; Tue, 19 Aug 2025 20:59:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 38A6C8E0001
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 20:59:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A9EBE137C3F
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 00:59:43 +0000 (UTC)
X-FDA: 83795328246.05.5DBE332
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3CF202000B
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 00:59:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=c5FdaI3t;
	spf=pass (imf03.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755651581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=tgqDeb/Wu59YCnXn+qrsSc3XFwle/PbP09h/hojDfwc=;
	b=G17MjwLW/JMhrdJaxdemlBY3AvZ1nipGrFNz/NjK9Nv+uRG9F9v0yHNloDfqLaUycNWhHo
	rBpIMkj46Y4Zfh/LJo+zfkw1S7IG+yGSp62soDavnHuxQLjKUOXz8vxsbIqcww42aF8x/z
	wbifjXVsWjlEM5o5melxbR6DIDRxoMk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755651581; a=rsa-sha256;
	cv=none;
	b=5d4xAlFTMlHfwaAzr95QkAkkTpCLVAFq6pMJxB+V8/enlMhbiDKHl2WECATd3Nde03aq0s
	koTQFPgdX3xlkTdWoKBvSS+S2Q4hNY/Gv7OktPrf/uroh1uUnx+O+n3SeRxMuZS+tzyPuE
	OQtonbJLZRIC9aPD3ci2dPWNTM3FQXY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=c5FdaI3t;
	spf=pass (imf03.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JL0jx5026216
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 00:59:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=tgqDeb/Wu59YCnXn+qrsSc
	3XFwle/PbP09h/hojDfwc=; b=c5FdaI3tig5aZpOsKzPIRXdUSoffMADGS0I6Jy
	gS52HXa8CuYbg6u1u5WAk4wA1KL6gvVucbLhPy+0uh/bUtM598ZjVIE0s7oLMqA9
	OcYwIcRPVpjSqNaMi4x4X1haOqq+grMRj9Fk0ikqWe3f1jCFaTwhvWv24/PAoq/0
	/Ul5SUBN7wjVUF+bmuxaQ1UWc5hUMCQKND4RuayrtLE9gyw9EUcIQALEzxjXMJSX
	TkpVfXY0/eQfgVTvL9GEl2kV1feLesfcIpoL0U/bmmkJ1FaVlEap4vRj3C0xeSzC
	qXJGQnQwHbFXUYfslhLabm8lPuRjAGFDINCJwrM3B1JgtuoQ==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48n0te8em5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 00:59:39 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-76e2eab5baaso4981636b3a.2
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:59:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755651579; x=1756256379;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tgqDeb/Wu59YCnXn+qrsSc3XFwle/PbP09h/hojDfwc=;
        b=XHzlDmakHR90BhGi0k543rZhnU6fgoPJxTVxBz2vsXS+uwjytzTNSg9mM5Cu5Ta6lp
         C7zqltLc+JfbKyF/MKGAcoN2ekdIQorZv0V/3MuxLfquNUsk97e44wP9w56bdfvKXxnp
         GHMJyQPtSxx+XMvtx5wk4PVhijxmauxox4gK28Xe8LUpYoPkCxPGQEUfbsnJFzFcJMfj
         kl0AulgMkzouVIvFKYEShWZ2F5b15kgye7CJYMtOSP1oZuPffLdiwII1zOGzy2wG4BWW
         HFT2LEcoFslI2gjLOYxHrFK3gYIPrQndLBnYYoOytGHc+IJRD1hDMbY2k55Pyr6nC38z
         Tppg==
X-Gm-Message-State: AOJu0YyLdKd6tUKuk/fxM/gjqtd/Blq7vY/mS/UJPwFCQDFXnqd0fbL8
	8kZCHT0eKWcMrxbTAouHYTkZ2ULS28bfO0b0hB6fIH2ySIRe+tG00C1i+AZ0r0KCEZUt31je7Ko
	DTyps4NvQeGA98oIqsrQdcvj/7ly16sjnqy3vZSAZyzhJw3rjUkEMNQ==
X-Gm-Gg: ASbGncsT3nK8tve0Lnu6eYLESbjmNp4TP7LQMVEEI5x8MLVomIXUiR6IpgaoHAwHsUL
	+Rfm2/dg0+cP1KMN06ULMH4zIt0SVdOQeIqd2CM1ymzgtfeR73C0wTSGC8xWo4iz2+Msyd7VOSc
	zw1EkwHmQyXEVuJcJZMJR4pxNSKKi6SYvE8vxmH4STFk/oWehkxrzICZdfe3f9UGL9VtfTb+i+D
	WYFW1bSRaM8VoitOBns6f3Ul1T7Sjgvb96xMO35tiV0fYwZpCdQXiLpc4TWwdpunf8OT96hRZWN
	t07DB/HZ9k/PbMn3qCpalpWpmBgRKNBiCrvnAdjA2Ac=
X-Received: by 2002:a05:6a00:2189:b0:746:27fc:fea9 with SMTP id d2e1a72fcca58-76e8dc8e43dmr1156671b3a.11.1755651578774;
        Tue, 19 Aug 2025 17:59:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFwzabe7LAJIehOSscjgzyy6m4bK1mT4ViKPJGUPmEHGsbnZsBoCP7RnGxjujuJSMr6FkASjw==
X-Received: by 2002:a05:6a00:2189:b0:746:27fc:fea9 with SMTP id d2e1a72fcca58-76e8dc8e43dmr1156653b3a.11.1755651578242;
        Tue, 19 Aug 2025 17:59:38 -0700 (PDT)
Received: from hu-pbrahma-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76e7d13ebdcsm3672630b3a.47.2025.08.19.17.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 17:59:37 -0700 (PDT)
From: pratyush.brahma@oss.qualcomm.com
X-Google-Original-From: Pratyush
Date: Wed, 20 Aug 2025 06:29:34 +0530
Subject: [PATCH v2] mm/numa: Use SZ_1M macro to denote bytes to MB
 conversion
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250820-numa-memblks-refac-v2-1-43bf1af02acd@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAPUdpWgC/32NQQ6CMBREr0L+2k9aoEJZeQ/Doi1FGinVfiEaw
 t2tHMDNJG+SebMB2egsQZttEO3qyIU5QXHKwIxqvll0fWIoWCFYwyXOi1fordfTnTDaQRmsdaU
 F47UWsoE0fKTavQ/ptUs8OnqF+Dk+Vv5r/+pWjhxledbV0JeCMXYJRPlzUZMJ3ucpoNv3/QswN
 VIFuwAAAA==
X-Change-ID: 20250819-numa-memblks-refac-7b4b5017b598
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1755651575; l=3166;
 i=pratyush.brahma@oss.qualcomm.com; s=20250808; h=from:subject:message-id;
 bh=uwvqx/6wxYcvRMmIDLsR1doIm7asXVLwPd2C3ZczI0c=;
 b=PHXOrHcYNJJO1gn2TEWd5zvXmQtC4s5LF+0wXgcRYMqipgGP/S5XHb9W8hBQxrK5qgw1ZmAsJ
 xuz2jfc62OdCv9yYSX6sG6gv7u49KUzTbNd4VrJJve/HoOW9iiM8ANL
X-Developer-Key: i=pratyush.brahma@oss.qualcomm.com; a=ed25519;
 pk=ZeXF1N8hxU6j3G/ajMI+du/TVXMZQaXDwnJyznB69ms=
X-Proofpoint-ORIG-GUID: KnctMLq5PaYMwDeJ2tuPwwdKB8F7nE51
X-Authority-Analysis: v=2.4 cv=Kr8UGWWN c=1 sm=1 tr=0 ts=68a51dfb cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=zDO9BBgFI2vZD2P_t4cA:9 a=QEXdDO2ut3YA:10 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-GUID: KnctMLq5PaYMwDeJ2tuPwwdKB8F7nE51
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NiBTYWx0ZWRfXzdEXkR1CnxRH
 KgtOYC+/fB/cyQUGlugtt5wiKmMe0tL0282vwU5isyk4zqQElJHqQHwABWbgRUwa3gr6xCV3iot
 eI8CEsl+wYT2vLMI1f/SgZ0MZNQLgcJqL/5caeLB0OHeQWubuWTnN5SuWY9b4aASUvOL5U9eNJt
 IoXjVwDRJvyU3hTzmQHJlQ0NK1BFMnPuVsgdE9ci7Ckyd5Zn546E3slRUiPSmsGCVUpW0UpU8dg
 hJBzLtcUd+oeB1pJ15rELdgIZVGzKIiZ5JiXE7I6SEzLTQxUDDbzi2TWWcyyx7E9YsDNeOstOrh
 q/o1UuYtqyrbu00bdHWKSn7ld+1gLGft/nSzzKdJKVFlzpGrRvdsb0yxS+jsa+HSYltqZAn1LVC
 8PYqYorDMbI8o82pQcsVY59X+DX1iw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_04,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 suspectscore=0 phishscore=0 impostorscore=0 adultscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 spamscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2508110000
 definitions=main-2508190196
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3CF202000B
X-Stat-Signature: etmk5yx4kmxno1w7nyomzts3z4zi5gxj
X-Rspam-User: 
X-HE-Tag: 1755651581-839287
X-HE-Meta: U2FsdGVkX1+yxMYLicDyA+hEGdHPWrFrJZdy+HMSL8ouQpqkrgVfEnQuIMr5VDqJCqxjcSy2g6qBIA8BngBxHvn4hCfgHKIhFaQsCR0dkNmuNiwqLRN2uhHnDFcNht5S2cEb6xpp+0tYN0e9Stypk3X2eyDePa2B1fb3Vv7A2g9vzNm82QQdFFv0d5a1zMpKSA3CexhFeuZZR+xQnKJXcXYijxboJFnSHeGJe1n6JrtWJiNkt8yolbvvhE7MTptb3HbHMwMcR1VeuqRJgaas3SwBW03ZEduO3nH1xHFDru4ax2iV2u80Refex7/Dx4vvxIex1H0su6Kx/bfKkz62ZDTFr+SglrFDsPcxHkSwFjouy+hBgANji7D9sd1o0WLMhdf8gnwxk8+BtpWC1mNSaDgDjheqkbL2HgterY63fsGfZTYatKy+XI8WmMsQvef4N/tRmYxCBqYZ9aYYjFPBHcLAE4q7eWRUxXRk9GNITBuyEWy1NVxY47G8cbavrb51uQ2m1NVJ/7T7/oIaY37rPCeLvIJ3sw3flACx90osYiOQkH0sxyZ79OD0yf11amjntq2PRUscnrMDtzYpyYS1olRsF1SG4yUF6qC1SN0mxqWhwdAnM/WUxMHOKzi/KVQFwOlnc/u4RmC/XSFg+wTW62xDAxbUQ9fo3aftLxj7ZL8c5buMftzZIwdG1kSntoSHQ9LklXRqmsQyTCqNJDQr7axR6gnRXjCUpykOFIMWaS9Qfa5YlEv0gE3/UcopwUz9D8AQ6kw73VNxCag9RcMfsYzApxdwcIqqrCkNFihlkkt7jBIDrcXg7uOM8xigMH7MnC2XhLC0Ym0W10inzU+ttujJW+NaI8qw6QQbbKjm/+pIBuOtEWA909WogWw6PAjd4qqTug4nSjxSyNgI9W6YrJq4gXEqapOnL7fNPksFIrwY6gj/s7mVz039XDaWKhMme/ZlRL1RRv9cyLfO7QE
 RD/9jaqT
 8i0rM4J+H0k1EsFTuu8IZAQwp0VEGmnF9SNnoxVSL28XTqulBogvSl1PmLLjhMotuUH/fPBzYrojEsOH1uQFO39hXX5hT6lknftThQuHxaskDQlDTPApXODIAxcRkNLrqu7bO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>

Replace the manual bitwise conversion of bytes to MB with
SZ_1M macro, a standard macro used within the mm subsystem,
to improve readability.

Signed-off-by: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
---
Changes in v2:
- Replaced the implementations in numa_emulation.c and memblock.c as
  well as per Mike's recommendation.
- Link to v1: https://lore.kernel.org/r/20250819-numa-memblks-refac-v1-1-936b4fd35000@oss.qualcomm.com
---
 mm/memblock.c       | 4 ++--
 mm/numa_emulation.c | 4 ++--
 mm/numa_memblks.c   | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 154f1d73b61f2234efe61c5cce5105be160d0041..8a0ed3074af4b4dacb87e45f3fecaeb6b3222fcf 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -780,9 +780,9 @@ bool __init_memblock memblock_validate_numa_coverage(unsigned long threshold_byt
 	}
 
 	if ((nr_pages << PAGE_SHIFT) > threshold_bytes) {
-		mem_size_mb = memblock_phys_mem_size() >> 20;
+		mem_size_mb = memblock_phys_mem_size() / SZ_1M;
 		pr_err("NUMA: no nodes coverage for %luMB of %luMB RAM\n",
-		       (nr_pages << PAGE_SHIFT) >> 20, mem_size_mb);
+		       (nr_pages << PAGE_SHIFT) / SZ_1M, mem_size_mb);
 		return false;
 	}
 
diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c
index 9d55679d99ceea9807d41840cf097eb449afaf8e..703c8fa05048019317bc2a011d7b928884ddc934 100644
--- a/mm/numa_emulation.c
+++ b/mm/numa_emulation.c
@@ -73,7 +73,7 @@ static int __init emu_setup_memblk(struct numa_meminfo *ei,
 	}
 
 	printk(KERN_INFO "Faking node %d at [mem %#018Lx-%#018Lx] (%LuMB)\n",
-	       nid, eb->start, eb->end - 1, (eb->end - eb->start) >> 20);
+	       nid, eb->start, eb->end - 1, (eb->end - eb->start) / SZ_1M);
 	return 0;
 }
 
@@ -264,7 +264,7 @@ static int __init split_nodes_size_interleave_uniform(struct numa_meminfo *ei,
 	min_size = ALIGN(max(min_size, FAKE_NODE_MIN_SIZE), FAKE_NODE_MIN_SIZE);
 	if (size < min_size) {
 		pr_err("Fake node size %LuMB too small, increasing to %LuMB\n",
-			size >> 20, min_size >> 20);
+			size / SZ_1M, min_size / SZ_1M);
 		size = min_size;
 	}
 	size = ALIGN_DOWN(size, FAKE_NODE_MIN_SIZE);
diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
index 541a99c4071a67e5b0ef66f4136dee268a880003..a47aa262a33366337c38ccc7c7064da818523dd2 100644
--- a/mm/numa_memblks.c
+++ b/mm/numa_memblks.c
@@ -427,9 +427,9 @@ static int __init numa_register_meminfo(struct numa_meminfo *mi)
 		unsigned long pfn_align = node_map_pfn_alignment();
 
 		if (pfn_align && pfn_align < PAGES_PER_SECTION) {
-			unsigned long node_align_mb = PFN_PHYS(pfn_align) >> 20;
+			unsigned long node_align_mb = PFN_PHYS(pfn_align) / SZ_1M;
 
-			unsigned long sect_align_mb = PFN_PHYS(PAGES_PER_SECTION) >> 20;
+			unsigned long sect_align_mb = PFN_PHYS(PAGES_PER_SECTION) / SZ_1M;
 
 			pr_warn("Node alignment %luMB < min %luMB, rejecting NUMA config\n",
 				node_align_mb, sect_align_mb);

---
base-commit: c17b750b3ad9f45f2b6f7e6f7f4679844244f0b9
change-id: 20250819-numa-memblks-refac-7b4b5017b598

Best regards,
-- 
Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>


