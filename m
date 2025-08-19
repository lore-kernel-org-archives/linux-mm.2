Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80329CA0EF5
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 08:51:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1ECE16B00C7; Tue, 19 Aug 2025 04:51:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C4F06B00C8; Tue, 19 Aug 2025 04:51:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DB086B00CB; Tue, 19 Aug 2025 04:51:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EAB9B6B00C7
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 04:51:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9016683C10
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:51:54 +0000 (UTC)
X-FDA: 83792889348.22.33E3553
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id E6BF2140002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:51:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="XwXKZ2P/";
	spf=pass (imf23.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755593512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=UtaQEPA70JUUBbPFESCLHuD85Yw6S51mJSYTTPArkpI=;
	b=rqYFIzWH9Je0EaP1oubzV6T/HdlikBCBiBAey/cL6RFFk+11e8If1ZrBCAec4uWOlk/efi
	5rtkk1JPm0odElNCxpVNjmleSX9UtgxAmQ++d5mtFtPLZ04Q/QIAkyyUJt+ITzUdL12QGR
	AZx2++YXEINSuLp913+Iu1bEAQw3Hn0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="XwXKZ2P/";
	spf=pass (imf23.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755593512; a=rsa-sha256;
	cv=none;
	b=p5fNutx9Dn1Y7H9ZNy+i3NzcMm/SROaKfUQI/XAO/r68GU45X6OwpO2qcI6bmhFltd0oTU
	Gyo09E8fI7PjBFUk6fEDKBZgpPgYiUC7xdHgvlmPwZzlHGeVhH90qItFyxLCLN8qyo+tha
	WR6Y3K86iKQx5Lng5y/P/kiM26sLmNA=
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57J8pHMW007354
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:51:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=UtaQEPA70JUUBbPFESCLHu
	D85Yw6S51mJSYTTPArkpI=; b=XwXKZ2P/CQ8X/woT44z55uo7ncMfCqf2oMNicb
	EIlmgCa5BazWIOtuRQjBP2ybBV6VjXZ2bm4hQj/PliTrp9Eya9SlDUeXvXVViSGa
	4xrJ5b+ATMif8ea6AzUP/p4acmCXpY4hXDZlTKSyjcnZJ+/BKlVE6OBqxGczSx5g
	Th1nvl1EFT5u2eraU8PwDcL5m/d1Ubgq5AQLOw5ZpmRpDYunhqvlCGyULIFcnsfU
	YpdtP3he/SLz2IQPxYhS/PagCtMmZqDLOoxSE8BYvKkZeLJoWc7qZPcSifWEue9a
	fsO3+DYxjnZD1E18GfXO5ZdTWqOOlplU02NHsv9OlAxuBdTg==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48jhjyfv4a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:51:50 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2445806dc88so128411995ad.1
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 01:51:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755593509; x=1756198309;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UtaQEPA70JUUBbPFESCLHuD85Yw6S51mJSYTTPArkpI=;
        b=dH4Gk10MrUpe/17FfvfVveC0NMs4LjWWKcZMWkhfLx2P1JJXdq0Gno0LSupYwBivGj
         X+Ld1Bm4ghE9sKIpEzJZDn0lYZ1RKkeB1linM/pzEa211d5E4vpv0iBeH342LIQEljzo
         DrumkAPInFxunB3JCUFHggc/6p6c2TOypyjXKUxuNu2FQESYxfCaui755UymRN2Cmmy2
         YjbiVVFPnqq5Tlz0l5zz8QIduEAG9ErKk1k4AWpfCbtO393s7d1RYMlEyeppuc9k5Ogl
         YwWuSsWgCslWBuVZKClGDAvdF/7AJXX3ZX+t9iRtYudvoS6oa5pvI/5cP7RV4dwSCkvI
         QBIQ==
X-Gm-Message-State: AOJu0YzDy7L3jrP93B3TKBBoJzWW2i7MOnik9GM1WqUW6UYY4WtD0cES
	wU/c3X1X3PcK6KZJ7LoBDcx7AefBf14XWR9wGa+bFEuXZ+EXkmp5NZ9NzJJ8Be2DpZ60u+z+QEw
	bL9p1avt1B1Cv7JXGhsdrl2y6i/uvATQ1CownllQlPuyKGjiahGwyJg==
X-Gm-Gg: ASbGncsh4IKn9/zV2+XdR/P7oYXoGU0KFwKo58R+GcdxilYxRqzHSUguUgselhovKIA
	6uHjSfOpX+UoKFVXkp/tKG40LyBzR8JxqzDnGvcB2hl1oqXvfG3EwC7+/H0rDrSRE+PLAnIUi9C
	IOKHCtvRSHU6EHcd1YI0dp+i417MwcMRrGQjMHDnTKfRx9iy689JaLqpFRffALqQuydY/s2PTt8
	8fQIH5ffe+H0Ai4PzfcYGgQTqSmAWOouBckybe/qE9hs66PVikFjxJL4CikoVP5doPLqG6tdTio
	Fk5geTnQgbAAtPjpBNTdRjJ539le0hO3U63Q91cMIYk=
X-Received: by 2002:a17:903:2f8e:b0:240:469d:beb0 with SMTP id d9443c01a7336-245e0494544mr22476145ad.31.1755593509517;
        Tue, 19 Aug 2025 01:51:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFX8G+XdS44NqcCcHy4azwS1a/5x7lnx2W3dbU327cwfzsZzMnxPMyAw6Lxry5dSu3VZ2nS8Q==
X-Received: by 2002:a17:903:2f8e:b0:240:469d:beb0 with SMTP id d9443c01a7336-245e0494544mr22475855ad.31.1755593509062;
        Tue, 19 Aug 2025 01:51:49 -0700 (PDT)
Received: from hu-pbrahma-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446d56b44fsm102344815ad.146.2025.08.19.01.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 01:51:48 -0700 (PDT)
From: pratyush.brahma@oss.qualcomm.com
X-Google-Original-From: Pratyush
Date: Tue, 19 Aug 2025 14:21:44 +0530
Subject: [PATCH] mm/numa_memblks: Use SZ_1M macro to denote bytes to MB
 conversion
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250819-numa-memblks-refac-v1-1-936b4fd35000@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAB87pGgC/x2MQQqAIBAAvxJ7bkEjyfpKdNDaaiktlCKQ/p50n
 IGZBJECU4SuSBDo5siHzyDLAsbV+IWQp8xQiUoJLVv0lzPoyNl9ixhoNiM2trZKyMaqVkMOz6z
 5+af98L4fumtcnmQAAAA=
X-Change-ID: 20250819-numa-memblks-refac-7b4b5017b598
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1755593506; l=1272;
 i=pratyush.brahma@oss.qualcomm.com; s=20250808; h=from:subject:message-id;
 bh=1n/B6T+EBi4imcFDM5sARQMMhhJ8zd0wI5Z3/7GqQeU=;
 b=tqgIYcTpIp0/mL5rik9Uq5MvBl0gulCrHw9T2BhpCZe7GI73Yn8M1gHSiPq5LAVA8DveZexKu
 3QktpIJNyjLB+jX2lpO05uH+A8sb2fDqDSJPSwAMSuY6rWjTVpgr35v
X-Developer-Key: i=pratyush.brahma@oss.qualcomm.com; a=ed25519;
 pk=ZeXF1N8hxU6j3G/ajMI+du/TVXMZQaXDwnJyznB69ms=
X-Proofpoint-ORIG-GUID: C6RFJKFZI8Lkbfwa7tGJ0s12p9yVW-zm
X-Authority-Analysis: v=2.4 cv=ZJHXmW7b c=1 sm=1 tr=0 ts=68a43b26 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=EUspDBNiAAAA:8 a=dRzHXBjQmnXEPONtsPAA:9
 a=QEXdDO2ut3YA:10 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-GUID: C6RFJKFZI8Lkbfwa7tGJ0s12p9yVW-zm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE2MDAyOCBTYWx0ZWRfXw+1OXFX/2NQU
 JOjHaeHXcOn/ullXSEWRYXYmDasAN7QDtgMUn48iMqVnt03YvaiIh/WQnsABCxZZbkZ/u7LcWq/
 fzmmE0EBbOmxFLqTL2rEBjX7K1zdWA8R/5Yfv2rxnRKrb7GlpEt6AGhxQC6Hj+KCeZY7cg04E1S
 7uPvvx8bGSw70Et1jRSGoj6SDSzVSu0Nfn7t9qRDKfSKt95auqKIIgJfDRR+gN6cyaFgst8pWu0
 28AjQUy5TBPlFMzNHBCWRq895Z+w9FwZlDCOfF6SHmOyOna2YS5RN8Ld7owHXLvz7AQyIlm6GLg
 Muuysilw2iMwFG5ZnhY6ob1ftkKS3Xcq9iAQt4iIsSz5DIP6Yg6qjsh3FkjKtkLTwZz/B05CZ/9
 VoRyfbv5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0 clxscore=1015
 bulkscore=0 spamscore=0 impostorscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508160028
X-Rspamd-Queue-Id: E6BF2140002
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: t4o5s7t56xu88yfdsf3ypzx6kgsznf3m
X-HE-Tag: 1755593511-669860
X-HE-Meta: U2FsdGVkX18Xsaf5YVPviIMYZqaZPs/pnHIbc57qsgyJcQCmKIFW/mX26jk7bBKX9TkDddZs9wTVVfNtrYc/KUAU8/ZmVzpLg/cGhU92Aq9AO53bVoytDbgg5/A2zolqDdgCLUC5Hn8YO/kjbilY5MV3B/8VHYqhA7cbwLHnvsjMkOnHRi2ncWHH7eG0k0M6Qck40C8QNeytLhPhOVCY6/j5drkunouEZq9R4u3KHftmnq78BeXV7ucL+IqoXsLnIm0HI5xjXFHhmZQEh7rA5GEqwpryIDuY5F8pkOxfbsGbUOK3Y52H82TlcgGzzoyGIqLAJgd68Zmqau6lmbHzHAiebDHTKH2oW9NTlRQ/XUNpwqBD2h68BMCehqUXsvnoZxnNeo0fDXoSp3UYXHpOPnx3e3qoFwkW4Cjf+dTt9YXoMdqgNn1ixmS+sLy3e3qPBRCvRGE3eNZAlHWzPbvoIM86vSW4U+hbLjHjs0JIk5HZpjMnP47VVLxaScxYIBlEIkTydQ9hDzKj6D38H6IIRKB9ie55BaHzSzVASQm32ZHrF0vYERLyZHYesN9W07MD0zjMnVOIcXg+p0f+NS7311iOhTTE9yjKWMTEjkblvPDHH1vIosjGqWvncJpS6xvMi54sehnQ2ihqluXVzjhBjGs8lgPNnGhey1TxuDDC2YRgvJKzel3Y1L+R46RUDc7c5eg5fnY1+kwgPIRtfcLKTwj2ZM0KcUkFkoiYV9pMmhvIL9VuE+hmKZcGyeZDpl1pLUHGLBW5LM3f8+zO5pYbmQNTZvg6BRAcex3pRmuhm/4bvdx04xQQCnfnkHtDFqc2D+l2lJfiblpG22nKlDXu8XlV/UCuvbZoX9NO5KOmuwFXg1pXPSl9X51IV1GHZpey/5jAVkkfoRBOzlaXdtvs3EHriJDzeHBxSBfDJkzUoZWPMI9L0wKy53xftnu7Ae8bUbHVo8y6AqwlgmPiO+U
 Yx/LWggO
 M4fLa/PsevftOlfKtVKtBhskWIi1UjeyVcx1fkO66hY/cxTt65vK7M6DMepkI8DRpcsFN2R13NQVPNS6G14dlfwXPAyz0z4d8IF+RgOJJoh75jAoLMDahKskDhEaiCtjdvwf1ex3iJ6gVZkUh5vc7qSp9ewU1kOvZmeDDYFzuaFQ987ZhDrenKNgInIJ/6BO2Vn5/UuQBX0hmVjtBNs2575KJtJzKhDnm/vpOayUyrjugJIzNrCHtI7uI9AjCATi+YJi9okWGclk8aKdRxwZcZ+MCHEyyrXY+fGp3QExqpTTm555QIyQOBbt07TAxEWxWQd8XzwgYFnolR49PHM+DdztfKyqjIdrUPriQd74YNPmNcmCbOsOcchHcHkSpXJOD5U4dsRX6QQwevfQ=
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
 mm/numa_memblks.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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


