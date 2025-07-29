Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D128C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 05:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFFD36B0093; Tue, 29 Jul 2025 01:34:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B60DC6B0095; Tue, 29 Jul 2025 01:34:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A510D6B0096; Tue, 29 Jul 2025 01:34:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 951636B0093
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 01:34:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 363FA804E7
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 05:34:37 +0000 (UTC)
X-FDA: 83716187394.06.695D65B
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf27.hostedemail.com (Postfix) with ESMTP id C625F40005
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 05:34:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=cajxoetV;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf27.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753767275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G8oS+v+giLcHjDbSrlGsstMtFDLI0TyfcjEk/ae6+cY=;
	b=kA/i9uksAf4GJQzNVLIl5SSD6hcLS3mZuPHRIHnyH8jXFYPU5IQ8V1tpkFCPQfrWiH6nN5
	LZFR/0xyRXyOC+uWGw8V1CHpeLMD1VKEfoywjqNgFslEyEV2U+R+V7mzTR9UxQanQMR43o
	B7u8Sh1kjLh2wGLdvsIanS2jdb+C6Nw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753767275; a=rsa-sha256;
	cv=none;
	b=dod5/+djgoM69EaJ0yDxR9MCiU++HRAc7bdkUbgcWBjvzkuQMs9lawvYLTY6A1IaK3bzhQ
	ebz/EfSUSjHoHALhk3k2vzlnyKryTAfQsloJacYd5mSSa0b5sYE1+H/3dyiNeYSuimj+lN
	Fxx/ANZzUWfJtgoXbmK6fsxxVLbZF/s=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=cajxoetV;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf27.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56T4YuHm001913;
	Tue, 29 Jul 2025 05:34:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=G8oS+v+giLcHjDbSr
	lGsstMtFDLI0TyfcjEk/ae6+cY=; b=cajxoetVp+siWZ/uyFUbb4sHT6F+8AXYW
	u4UqNMEtAxpgooqkaLNSXft3rTVykH8dv3nuFnNiKV6cKQ0bDYz7r5M5nvRzkvWT
	nwx0jsiUEOQW5bwIpGiTVe4fvofvCj8usN9fL59yepFRWlCTvGfyA5yOdo9ITEK2
	UL3Gza99Y/OnimU2O/ab7DYzD5TJCEHTwyDhV/G1ET5GukEcZW4ap1sApJ4+cAep
	AWR45cXAgAfnRJQHJPMDGU0NcGuMuKfJ4KuROCR1uMo6VAFSawrDM1P7N3cwLv5x
	E7peYN4PVqhDBmG1pD0AQbIXaUtoMdKlX9ThZJd8QZWZyF6COmiBw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 486c6hjte0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 29 Jul 2025 05:34:28 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 56T5YSi4021026;
	Tue, 29 Jul 2025 05:34:28 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 486c6hjtdn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 29 Jul 2025 05:34:28 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56T4VHL1018275;
	Tue, 29 Jul 2025 05:34:27 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 485abp113r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 29 Jul 2025 05:34:26 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56T5YMwh20840932
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 05:34:23 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D97192004D;
	Tue, 29 Jul 2025 05:34:22 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5733C20040;
	Tue, 29 Jul 2025 05:34:17 +0000 (GMT)
Received: from aboo.ibm.com.com (unknown [9.150.11.63])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 29 Jul 2025 05:34:17 +0000 (GMT)
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: akpm@linux-foundation.org, Liam.Howlett@oracle.com,
        lorenzo.stoakes@oracle.com, shuah@kernel.org, pfalcato@suse.de,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, donettom@linux.ibm.com,
        ritesh.list@gmail.com, aboorvad@linux.ibm.com
Subject: [PATCH v3 2/7] selftests/mm: Add support to test 4PB VA on PPC64
Date: Tue, 29 Jul 2025 11:03:58 +0530
Message-ID: <20250729053403.1071807-3-aboorvad@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250729053403.1071807-1-aboorvad@linux.ibm.com>
References: <20250729053403.1071807-1-aboorvad@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oaw_REjoX37XzBgjW1cvFZzgafNzvIa5
X-Authority-Analysis: v=2.4 cv=Mbtsu4/f c=1 sm=1 tr=0 ts=68885d64 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=Wb1JkmetP80A:10 a=VnNF1IyMAAAA:8 a=7CQSdrXTAAAA:8 a=20KFwNOVAAAA:8
 a=Ikd4Dj_1AAAA:8 a=Bqi_dthY5MMbQG-DhooA:9 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-ORIG-GUID: GzwiVAJad7mSRRBHQELlV_wh9Yabou-n
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI5MDAzOCBTYWx0ZWRfXyUBMSh0aQ5NV
 I45ZiF3m9DMeKyZGo/XrJ/fmIBc67U7IS32oedfmYwFXUTy26JXM+vb40XC51Zvcs7H16gBEfsd
 u9I6tiPTKuqyCXj9vtx+NV0+XomlrBg+Em5mNuBSvr3LgyVFYAD0B0lpAyPRzjPHSZxo7AP+d78
 AFC7vOoHQgoFN+UYPIxvod1lAM5uewvP6Qlo7CGFnnBEENcGw/8fq5yDKkbedt/T6j4Uxz4Sw5e
 5qz2lmBYvN3a/WJvfQjYAj95DIoCLjMAt3sIRY+NBemOV2j/6kzUHhlfeuIut0+UqN4thJLgbAu
 YiZU4XKKjNl4PxrjAgKIQRrm95/UkcpmTGGc6t0hNTdp/K/sPnDCdPEwipuuj8gViDDTV822HB6
 HI0uj50ZI6XTqzIZPZYRGxIThqANT+PxIDlgj1bU2Lt51ZGbdtmWTGG4qkz3cpIDT+QkXFR0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-29_01,2025-07-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 spamscore=0 mlxscore=0 impostorscore=0 phishscore=0 mlxlogscore=959
 lowpriorityscore=0 malwarescore=0 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2507290038
X-Rspamd-Queue-Id: C625F40005
X-Stat-Signature: gkbk19hwm19kh1bupifnrzcj16wbjgfi
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753767274-657658
X-HE-Meta: U2FsdGVkX1+/ip6kYdUuU8vT7indupz9THTohxUX/vLI7memVsjEDmbuRHqOQsrhHidaFR5nhkHEIRtY/cZf/CwtWi5fcDGSZyAalI3mhg5XQJW6YSWziWombSWoTms8RIUpB0DnYdQCmItXrElN9hhZeJ2ESW4orzLQUvKqz/lfrZHvzaDCLZEnLrujW8OQBY6+PaIJbsXfwBFXsxmh3uBLJLgWjmvz0vMdB94TpeYj30gDLZws1C1Bf6gaAjV0kebFwMhgcYoMbexR5jVpMBEPfGFUdVZunMHGfcC1dC9Du3UfOJVPm1D1ViDvfjz2ibMz/n7k8FpRLKY/phPz3uSoSJWOMOwQPuKJqg6Gojc+iI1scUc/9DoFd5Rrkb+GIiwBiwass8xOBkwloMfrG6lZAgrK+45xgU0g61n1dQB5gUC983IHYhERtgnDeolg+RUHLDVxxwiLbYUZBhpkn/cwyRvXmtpQIslF741Xd2fPDTwnJ4vzi1wEklUIPASK7c8Qn1QtGJONpuyIRZoNcvPec0saReuou+mw8KSCnuJ/IrDr3MjVIeekQl45BOZ3PRA4xWKwIAlVeLq2k6GY6Tc3BdOPi7NowBjzFYKdTbzqsINA71kLTXHvmM1PXGZiGjZDHXZOTAV/LXxpkhgXlDwbVrOf260Nx1okBzJU411kUatSDOaU03AI/dTcZisC7VIQjUlvsVUL+RiG8lsE43CBDrTwmJD2Bwc50b41JCjmd7YNno5kO2fKaOvzLe5IIaFPPPxncqoBWvbd5xydOTsQs7Mr5vVXfWLF0jx2B5X6UOZlh79Eskw5ijVJF8jIE3beBuBz5SwTbvwav8N7mYFd+f1rQAxilzJDwYPOt0VKesD4+WC+EqaN7Jf6uegZZ/5lmNANi8wCfSRgNjDOSY6BdHJGptaYTgj4dcJ6KzumD6FMk06vtICTvV4ceZsYcZgfuUZIXDTTpySiMy1
 EJaOKhYO
 yoVE4cnOn46KEpCjbOThf8mc9A7C7eHq+ZlM4PwYIrBzaXjeZwIC6rF27n4T2kpi8VfriS3zCn8Zq+5YQlDErt0zMp4semlZUKjvffwyerzZ/fAFolZV4rJuofYYogcif56Y5+Z24ijvaHgiCY0R4YN6ckUW5qoiJlo9inT4HxadgVLdZTAjCNnm3kw/f8cXpJ7U3knhKe3tIyEnYna/am07zI1WCS/64G5R5Nt9B0tY/2s4VgZYDa+AO4WWt6h65Sl9xSPrIULMflovRLYSQ4UB7Tp3lbm7mX+F2CJFc5bwgCOcq9KvuJyugcJBpFyQXqFPAzj10rPrulinzIBEmCLM7RB9Gbn+DZ9F1GeCJThTLkvpzsqMV33ljqrMlv/+4DXGI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Donet Tom <donettom@linux.ibm.com>

PowerPC64 supports a 4PB virtual address space, but this test was
previously limited to 512TB. This patch extends the coverage up to
the full 4PB VA range on PowerPC64.

Memory from 0 to 128TB is allocated without an address hint, while
allocations from 128TB to 4PB use a hint address.

Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Co-developed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
---
 tools/testing/selftests/mm/virtual_address_range.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/mm/virtual_address_range.c b/tools/testing/selftests/mm/virtual_address_range.c
index e24c36a39f22..81b33d8f78f4 100644
--- a/tools/testing/selftests/mm/virtual_address_range.c
+++ b/tools/testing/selftests/mm/virtual_address_range.c
@@ -44,12 +44,18 @@
  * On Arm64 the address space is 256TB and support for
  * high mappings up to 4PB virtual address space has
  * been added.
+ *
+ * On PowerPC64, the address space up to 128TB can be
+ * mapped without a hint. Addresses beyond 128TB, up to
+ * 4PB, can be mapped with a hint.
+ *
  */
 
 #define NR_CHUNKS_128TB   ((128 * SZ_1TB) / MAP_CHUNK_SIZE) /* Number of chunks for 128TB */
 #define NR_CHUNKS_256TB   (NR_CHUNKS_128TB * 2UL)
 #define NR_CHUNKS_384TB   (NR_CHUNKS_128TB * 3UL)
 #define NR_CHUNKS_3840TB  (NR_CHUNKS_128TB * 30UL)
+#define NR_CHUNKS_3968TB  (NR_CHUNKS_128TB * 31UL)
 
 #define ADDR_MARK_128TB  (1UL << 47) /* First address beyond 128TB */
 #define ADDR_MARK_256TB  (1UL << 48) /* First address beyond 256TB */
@@ -59,6 +65,11 @@
 #define HIGH_ADDR_SHIFT 49
 #define NR_CHUNKS_LOW   NR_CHUNKS_256TB
 #define NR_CHUNKS_HIGH  NR_CHUNKS_3840TB
+#elif defined(__PPC64__)
+#define HIGH_ADDR_MARK  ADDR_MARK_128TB
+#define HIGH_ADDR_SHIFT 48
+#define NR_CHUNKS_LOW   NR_CHUNKS_128TB
+#define NR_CHUNKS_HIGH  NR_CHUNKS_3968TB
 #else
 #define HIGH_ADDR_MARK  ADDR_MARK_128TB
 #define HIGH_ADDR_SHIFT 48
-- 
2.47.1


