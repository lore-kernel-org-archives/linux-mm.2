Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4E6DCAC5B9
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 10:35:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1365E8E0007; Fri, 26 Sep 2025 06:35:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10DD98E0001; Fri, 26 Sep 2025 06:35:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 024178E0007; Fri, 26 Sep 2025 06:35:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E2F9D8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 06:35:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8DD0E13B92A
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 10:35:05 +0000 (UTC)
X-FDA: 83931043770.28.D338F1D
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id ECA6E1C0006
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 10:35:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=jvVZBWId;
	spf=pass (imf21.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758882903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LTK3sm/WCTByH8AIKLDPZJb7elq6pcZttvHY7NDS8Ok=;
	b=zp/F/X1tusZrj92T53L4LNr8kF5iks0j9AhGgQrfimYgI3WsN60pqmU5o36ZKJkj5VsLZZ
	6Vk0qgy+T2LWudMOQYQdFtQ/RTVSXyM+idYCgqnKGG07Br3Rss18t4rCrxHTIldFbklnTS
	SpSbx4c/h1APAkohxpP1KhCpSy7o/FI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=jvVZBWId;
	spf=pass (imf21.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758882903; a=rsa-sha256;
	cv=none;
	b=8geY4g+5dsj7KSAKu+WKrBtCsCtE88BkfeElJ3Fzzz4hoJUzhv0UsEp+EN93ho4nThm/lI
	CDzx6vcJmK8p1HD7WRkTprMGGyDJX6M57MmWfu19EbZieyWNRzRHsPilL6g3Dx0+T6A1fz
	WdxPiSck+Sx4LJTYijfxgBlt6x0ZL30=
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58Q8vbVK028798
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 10:35:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	LTK3sm/WCTByH8AIKLDPZJb7elq6pcZttvHY7NDS8Ok=; b=jvVZBWIdi2uklA/2
	Nui3m46bmsA/VRCWndUve2+xIggfzREWuuuBMYuui524mRt2xvUKjvACwh4DEji0
	vqIDfVabvyCR++3OBh1o2xWtwkgHxWOG/tyktmFEGMCPK4mMHiFH6SEQreJUuvG1
	7x1zzPiwDynIy9rNrccvhXsbPbhYwax+2vBM87PP7WHrnbSlyukb1rK8ucQFHgB9
	tg/xq4LT6LHaGEmaZPkBe51pEDSKCzXzrxSwu1l1h0SJ9Otvafnaeoqz+im9L7rB
	pSYpNjkO7oR+fTLUIzVDUqEMSWrpKpW8GkSFJxwKLE2oVTmaDvNY1eSVlu3qhiIX
	kA6e0g==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49db322gfx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 10:35:01 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-269939bfccbso25011245ad.1
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:35:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758882900; x=1759487700;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LTK3sm/WCTByH8AIKLDPZJb7elq6pcZttvHY7NDS8Ok=;
        b=qRgwyqukAigifWQwFWFA1hJ8XBjKlv2/1z6BCIMq/BY1CAe5xZE6krY3C9ZqAw4Tr/
         LOgQfObFET0bvbIgCq6aUMDmIXBdo1RVigwc0srV53ebXGxv++dLLa3SkVb+cerAKHMP
         n3yex5SW4R3KkU3aBPQkpMDoXfcwdv3ehLUzTKcXhDqNt5jtB99UOoRXN4kG3JJgfROn
         E7qMmM4scpfXLtag4kM+NZr+MeHSZfUi2n+oObBpMtPkNb808Sr5PAct9g48xqhwvVfy
         kb2m7Ye8Ms9alZVaPOoMkqz48kSEQu8ihifJz2sd/YbiFAV+SYN4fvnGUz3qUinIQneQ
         lteg==
X-Gm-Message-State: AOJu0Yy46qXE3Zlo82bwa3+olirD4NVOrVCn5GRS4HIX4T5KWmAO7G0L
	rKYRQn4fPi+fAq7OaZrnB4uD+vV7rLfMoOh5p+pBxcY0ySOlCgDA/o92jwZbowo26lzRjGLA8BP
	6QqLzxCAM01iKA3eiButAhjcjYJ2mCBR01IfMerxZ03vn/+dIYlPRP4DYYG1otA==
X-Gm-Gg: ASbGncvs+QR+AXYWXmhjJAOgN95EJRnYO7Gkaee0Ge+JHUfWK2cygKorhXwxyz/dvdf
	S55yIFUp7CihOnvt0Izpv018KwQhRck/JztC1C3F6Xbb7My6isr32eTLav0YKO0rylzVIajP6d4
	BI2wIjL18VSYLnC/fxdRDRqX/fgevwQMdFABBXW5pMRhkjBzrv2VaVpoJmPKNSAIJWi+4tDv3Jf
	4EouxyUqlSVGB+wWGbmtphV2SXWEvrG4yB9xpTPhkn4yYuYZpgIjYrvw2xhgwZeBKlup1V8cQBs
	RCIb4pdk7pJXj7WQtpFrfmyIJp80S71OAgYNJWDRBzM=
X-Received: by 2002:a17:903:32d2:b0:265:89c:251b with SMTP id d9443c01a7336-27ed4a5a83amr75493285ad.29.1758882900058;
        Fri, 26 Sep 2025 03:35:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGYtkjQ1vZXVrGcSLYgiOCZ+w7RpHML+kVAOdjCbUW2JzzLjV26JdqDt2s1DJCxrP6JlAynBw==
X-Received: by 2002:a17:903:32d2:b0:265:89c:251b with SMTP id d9443c01a7336-27ed4a5a83amr75493035ad.29.1758882899481;
        Fri, 26 Sep 2025 03:34:59 -0700 (PDT)
Received: from hu-pbrahma-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed6aca043sm48950175ad.138.2025.09.26.03.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 03:34:58 -0700 (PDT)
From: pratyush.brahma@oss.qualcomm.com
X-Google-Original-From: Pratyush
Date: Fri, 26 Sep 2025 16:04:50 +0530
Subject: [PATCH 2/2] mm/numa_emulation: Move the size calculation in
 split_nodes_interleave() to a separate function
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250926-numa-emu-v1-2-714f2691bf8b@oss.qualcomm.com>
References: <20250926-numa-emu-v1-0-714f2691bf8b@oss.qualcomm.com>
In-Reply-To: <20250926-numa-emu-v1-0-714f2691bf8b@oss.qualcomm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
X-Mailer: b4 0.15-dev-56183
X-Developer-Signature: v=1; a=ed25519-sha256; t=1758882892; l=2432;
 i=pratyush.brahma@oss.qualcomm.com; s=20250808; h=from:subject:message-id;
 bh=6Z5kcb9JsfpjcjQdv/MoBuJ6XffluCG6avEx/oaN/HQ=;
 b=WDB4CbmPf9+t07NRSzRna0kA3IFvZQpm86eRe7YQaFBfpUjLYjKGiVQzUNpLCeLKwgiNf6ra9
 wszmIyDEQngAyEYZMmJ40RRkI+UHA/KPUb4i/W+2ruGB4MtlUQjVlIT
X-Developer-Key: i=pratyush.brahma@oss.qualcomm.com; a=ed25519;
 pk=ZeXF1N8hxU6j3G/ajMI+du/TVXMZQaXDwnJyznB69ms=
X-Authority-Analysis: v=2.4 cv=ao6/yCZV c=1 sm=1 tr=0 ts=68d66c55 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=EUspDBNiAAAA:8 a=0kcytrBVAGx62Z4XyuQA:9
 a=QEXdDO2ut3YA:10 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-ORIG-GUID: zikKFGINhiJ00p93e39AP7nhyI85cd_F
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI1MDE3MiBTYWx0ZWRfX/uVezPVOqXla
 HMM7i9Qpjp1mi4KA95Gb6eZksfiXErlcchTwVykCAL1+TxzA0zdA8hVQvkdbe2bu+DHAZV8D8XT
 dCOfbAbPUk0WREJgI++zwSDipm8zF5gFdGAo4zVTsz4fTQBZcXmFMIUkKw3lAVPKYvAxTVjOa+x
 y3X5qURSsBlT9PSt3Y0+ZMSq2sCuT2cX1vx42dxfcadPQ4GJ8Uqg6POPv/hZuwxQD0MSVCpUmsb
 JS5wsX7avT71MFdGgHRah+f+tAUeIbRUDB4Asmqdqc4DlIYzrFvNBRMv9nWY5lmlCbBBqSaTw68
 zTTt3r+Kz8edq5zEtVa2Hga3uVGrByCZCEPkLzC2mtj4Ba7Hy12I+YFRC0DD+bFmtDCNJ79bxHr
 IzCWmQC/7Hf4vYTnKAQCCjeab70N9Q==
X-Proofpoint-GUID: zikKFGINhiJ00p93e39AP7nhyI85cd_F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-26_03,2025-09-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 priorityscore=1501 suspectscore=0 phishscore=0
 adultscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509250172
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: ECA6E1C0006
X-Stat-Signature: 5wnkkeo7nambq4mf7n5rbbydfuwyc99n
X-HE-Tag: 1758882902-92316
X-HE-Meta: U2FsdGVkX1+qPAG/sSw09CR4mhkvBHWlQu33Dgn8Np39cKYfYCw9JavyAMS+dNWWQRuT+qaqcrGhisCzvSFu4oSyL0mE+Npsltv16RoVOIeTulI3Gh9Sdmz5W6tTfim+QZMuZleOnPydE3AjsRliU0ojW1ZOK8OBcZ2BF/wiSHZeVJaCu0ZJuyM0qf3igTYfxGcA+Zl9pHUXFR19h9Jv7IqImQc3Q+cR6T9A/8GG5+St5wzbwYW3x3SwdG6KOUo89eOtVhutQmRqbUi6RIf3Ywxt+a0H/4nMPTc0U18oI/4XdMZiOlcuc1LLoGOjB5WdaairGEps8s8dAltTtm5Ohcl2Wai6g8lr3AZA1l2eJ+5T1CexcacMPCNBIs2F0Gui/InmvXFeZXvK27iuWAQP2FhwxldcpKExU6yYIvz0LjuEFnrFVQQ1l0H1N/8Q3jDN/4DqEDb9xJwYJZp4N8t/877zBuFYNCvlqAz5+rnbnAzWgDYXGofXuKZarxBym2o/v7kiO1QL/WQOxsZ1OrXWWPbYWTObMCTwik0GgaSVbKNdc+v2BkBeQMqmQeKH6f/WEU4sDGUHfuhHb2vzNx75iG/Dw/m9bS24EFPK7Tau7PEDiFAdTvdMbkzdj0QoldD334blaikmX9gPPsX4gIuDwt06clr1q/gE0DlGGrIpPETs9UzevuDST2LsAfoTbbnOxTSdAx0JpRV+QuQCnndrfJCGux2JspDcDj2FFNgeOuyh9dDalbNAQt7lvXxre5Rr3Oqjv0rysLT9sFJbFesXOtPUExINvt/2abG1LBILnF+SZZs4Ovb/9Sbf4NbPfj5+X0pYCrq0i0oXWMaHIdGIBGjZDUlNGuXcegR9IJuk/lLvlf/RbVY8Fp+yQdWOkP0MiT+4sfDg3K17PHdEhUE/C/hNxf7QtemTiu+e94wN5oCiWoa6S5Yp1UYYOzLwx1WGWFCkgQpZX3gB2Ifwkjq
 wA+Bbfbv
 EoEkQfcsg7NTzWWlSCOqE5c+aGGt+5K3o8TRK7z/uozqRkvA61DTkd7jcNiNSyLFipRkmdhQop/BJGO/OHkNRrkaqFgEG+KrtvOKQSsnHKOABkO8pbgGbuRlf0S7YZLE80D/1pcQxKmF52SACf7DxMi8OSfkInE8mMF/Z6ZgDzQJWQn6dcO7T6ibjCp8CwKcApCIVCRLF7L8Ir6ljq5A9VGRKkS8q/AA7vS3rl+q2Sf6q8f3sEmUU2qTaRd0pWIU9ETtT48/a0Wm5WiFmhjAiKREcr5kYfJ3NTwNVaOC8utkBYpw6GiZp0+g7stEgxTS6NHPe/uME103O8Qw/42h/HtKfiQB0WBRxP28+vWjIOB0vQz5z4LybaM4dvPDBjtiqqSou6VrpWXaTySs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>

The size calculation in split_nodes_interleave() has several nuances.
Move it to a separate function to improve code modularity and
simplify the readability of split_nodes_interleave().

Signed-off-by: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
---
 mm/numa_emulation.c | 44 +++++++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 15 deletions(-)

diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c
index 2a335b3dd46a..882c349c2a0f 100644
--- a/mm/numa_emulation.c
+++ b/mm/numa_emulation.c
@@ -76,6 +76,34 @@ static int __init emu_setup_memblk(struct numa_meminfo *ei,
 	return 0;
 }
 
+static void __init __calc_split_params(u64 addr, u64 max_addr,
+		int nr_nodes, u64 *psize, int *pbig)
+{
+	u64 size, usable_size;
+	int big;
+
+	/* total usable memory (skip holes) */
+	usable_size  = max_addr - addr - mem_hole_size(addr, max_addr);
+
+	/*
+	 * Calculate target node size.  x86_32 freaks on __udivdi3() so do
+	 * the division in ulong number of pages and convert back.
+	 */
+	size = PFN_PHYS((unsigned long)(usable_size >> PAGE_SHIFT) / nr_nodes);
+
+	/*
+	 * Calculate the number of big nodes that can be allocated as a result
+	 * of consolidating the remainder.
+	 */
+	big = ((size & (FAKE_NODE_MIN_SIZE - 1UL)) * nr_nodes) / FAKE_NODE_MIN_SIZE;
+
+	/* Align the base size down to the minimum granularity */
+	size = ALIGN_DOWN(size, FAKE_NODE_MIN_SIZE);
+
+	*psize = size;
+	*pbig  = big;
+}
+
 /*
  * Sets up nr_nodes fake nodes interleaved over physical nodes ranging from addr
  * to max_addr.
@@ -100,21 +128,7 @@ static int __init split_nodes_interleave(struct numa_meminfo *ei,
 		nr_nodes = MAX_NUMNODES;
 	}
 
-	/*
-	 * Calculate target node size.  x86_32 freaks on __udivdi3() so do
-	 * the division in ulong number of pages and convert back.
-	 */
-	size = max_addr - addr - mem_hole_size(addr, max_addr);
-	size = PFN_PHYS((unsigned long)(size >> PAGE_SHIFT) / nr_nodes);
-
-	/*
-	 * Calculate the number of big nodes that can be allocated as a result
-	 * of consolidating the remainder.
-	 */
-	big = ((size & (FAKE_NODE_MIN_SIZE - 1UL)) * nr_nodes) /
-		FAKE_NODE_MIN_SIZE;
-
-	size = ALIGN_DOWN(size, FAKE_NODE_MIN_SIZE);
+	__calc_split_params(addr, max_addr, nr_nodes, &size, &big);
 	if (!size) {
 		pr_err("Not enough memory for each node.  "
 			"NUMA emulation disabled.\n");

-- 
2.34.1


