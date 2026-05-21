Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8929CD5BB1
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:27:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C449B6B00AA; Thu, 21 May 2026 10:26:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF6676B00AB; Thu, 21 May 2026 10:26:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE4E26B00AC; Thu, 21 May 2026 10:26:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 958746B00AA
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:26:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5DA90A046B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:45 +0000 (UTC)
X-FDA: 84791653170.30.5AB030D
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf18.hostedemail.com (Postfix) with ESMTP id F09EF1C0008
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=hrRvAv6k;
	spf=pass (imf18.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779373603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bAXX+tXFoepmleJYQyZsSgeoqwCmF0jZLGknM1dht9E=;
	b=Lk8UMDTaLfnMw9331p19uPlcONFnBkvSRaafAkwjIrKFvctFSIhLtToH0Q5z024nUTHyih
	C+9m1wy1G2gIQYUgSnyjgvcwdj6UOxH0IAMDsePyUMruETZmnIRYuA/FHf6B6BfGxFQOOX
	Zb+pWUtsrMvPpYnCuKAUubex03T9OTQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=hrRvAv6k;
	spf=pass (imf18.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779373603; a=rsa-sha256;
	cv=none;
	b=RqATScHfhctQ1L9Vt8oZjr5uuvbOSA9Ly7N8qUQ/asbY3eo3VyBfGp8dJvjtbjd4yLSQgB
	Ty2g7P2S3Lqd53QjpsBHI0X4AceiuA4QRLoZYAAyH9Gvsk+LLnNRJW0xM9cjkq96ebwe/L
	Tyg/YoyD5hCpV9yXuL4pGqsmx++OkTk=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64L2ZhCr552016;
	Thu, 21 May 2026 14:26:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=bAXX+tXFoepmleJYQ
	yZsSgeoqwCmF0jZLGknM1dht9E=; b=hrRvAv6kA5mKwUHaBd+W2FpOQs4Wpt2kz
	XFOhw5B0iiT2+R+3qmYTdnzAH2vtd0NvgojT8MmNcWMXn6P/mjyxvFshA5+g/gvD
	1lJ7MYO/djbekqr/iUD7Mfdll0KzmNW/kghq6BRG3zbK9u+0dm04nbcCZXpHJSnm
	aNHGp7D/oLqDhbYT9aavrsRiKMxzo4yLSta2ED/yWhSYtVQFDzSEtuSpJp7s1+PH
	ASt/jlhDu81HR7nu21IdOom9knoesooKRBjUGxLlBC5cPA+rj+1ZQR9Xi2IpxdAo
	c15CIOG5VlwFOAFZCO6bwPpjEa2vKJqsi4I5w2DRIUQM55l+gg8RA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h9y7grw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:26:00 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64LEO59A006181;
	Thu, 21 May 2026 14:25:59 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e75kyc9tv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:59 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64LEPuTI60817690
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 14:25:56 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E45DA20040;
	Thu, 21 May 2026 14:25:55 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 85B682004B;
	Thu, 21 May 2026 14:25:55 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 14:25:55 +0000 (GMT)
From: Jens Remus <jremus@linux.ibm.com>
To: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        x86@kernel.org, Steven Rostedt <rostedt@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Indu Bhagat <ibhagatgnu@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dylan Hatch <dylanbhatch@google.com>,
        Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Kees Cook <kees@kernel.org>, Sam James <sam@gentoo.org>
Cc: Jens Remus <jremus@linux.ibm.com>, bpf@vger.kernel.org, linux-mm@kvack.org,
        Namhyung Kim <namhyung@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Jose E. Marchesi" <jemarch@gnu.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Florian Weimer <fweimer@redhat.com>,
        "Carlos O'Donell" <codonell@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v16 17/20] unwind_user/sframe: Separate reading of FRE from reading of FRE data words
Date: Thu, 21 May 2026 16:25:43 +0200
Message-ID: <20260521142546.3908498-18-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260521142546.3908498-1-jremus@linux.ibm.com>
References: <20260521142546.3908498-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDE0MiBTYWx0ZWRfX2bXFpxhRPDPH
 Zc7lbHxbLe/UJzeKtrvgFot5w+OnF6zmRVB3nwQqn16XdbVgYAN0fJW8Hak9lC1WDAMBP1Qr02s
 KC8SSZI1zh4AMnxafzBpituNpru1V912j6klurs0YGIXZv8x4BtkfpSXdb8rHKXWI0TlaA3Bu9y
 mkUPKMjoiZCu8vMBjSDRU5V+JRHgiDcmCZOSfbVLNirOjr8y1zRiufqpJkWqZlQI5KgS20DICEb
 jSSEskavsbCM6q7QwkD1KDbZJIH1KVAfbJFLS3RhUHIRI1BJwiEdDTLfEPWMk64Yfrx/ScAE7qO
 GgrCi4p1i9UV0uIGElHG74pDXawE36BlPiWLDHz5vmXgGWPjy8hTVzP8efVQkJfer9ErPjYtWP1
 NeABBvnGu1l5rZwi9VCK8pJ1s6zTB5sW3oVrlNvNjEKlEGANUC6v5eVBEVPQGYwE2Xofi0NeYZD
 WQhygoIjVUsnBdILN5g==
X-Authority-Analysis: v=2.4 cv=BNuDalQG c=1 sm=1 tr=0 ts=6a0f15f9 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=RXKZOtKmAAAA:8
 a=p_lxmaMNnb8s4VerTYQA:9 a=UFF3uGjEBZWolfm0k6KQ:22
X-Proofpoint-ORIG-GUID: drJApyXJj2y9hpl5tbDEjhRo_6IKVXYK
X-Proofpoint-GUID: wGVBeE2STrhp9aFps6BixI2H6PEIK6K6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210142
X-Stat-Signature: i1ib68cu6m198un37ypxr7o97toreapo
X-Rspamd-Queue-Id: F09EF1C0008
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779373602-192702
X-HE-Meta: U2FsdGVkX18uvxzJk2MaQ7Cju2dolmJFZy3rvCw9qUOJpzlIGSxi80TWBxB3iNf+//kM0VD/+ItEiyeSuibTuLuyuoy014oWg2uwULn0gEmL7XzuKHtvQ+enkoe9SwrdaqgZu+Wwcvh1t+eta5ZY7PM/O2MzzMb0O08AGu81d95oaYb3hnRSoPh2LbuU+CLDFPh+zhEt/oUG2kj30rColjfhq/Ur0dNPobbAhWJqM3ryOPghbQcZJ6TBhBXGESdF1+pReriWGpT7TMwZ5jPgKoShlbbWer+OtO5zjyD7H4LKhO6+KEXaJ+4uO0eYEo3eW1cqzPVWpXtj2cnWnI9G/w7N/fJjLnZAOH9H93ZBPUVix2ypospGxGRx8WoAfh8q3YUpHiTXH1vDXfzhLWM0xXWnXCzkmp2pCgbFk4aNtceKF/PE/qOybTC9mObKk6AUjy0f2R4eZyV54xz/BjMIdqychV3byE2zr8jtv83MG/3Xpwmr+THxrLzgOE6/t9O8EDOTVQhc2t7MzD5LmldXtmeXfFyl6hWRqntjXh9RIUlUtR6LVd4FOm38V6JSu/fbLrkmSGKjP6n2HVvD/5dilF7lOiezgaZwcfvxVjnXp9iS1ZsOhL8xJZMdjlNAzNeZNupgqx4/4RcPgPVXstSQ3UcE7rDNahQFRGT+UbB50/13ubGxuLFoXwH7gubv7Qe6c9sMSbLVY7Uk0pQXfT+KNOZIhFm0cBOmMWZ3ryU3mqueiMOiocTOwswLbdaz0lSm0aalSiV3nOMhWeWmgYbKIBRGWNzkGt7fAHR9/UTCyx6B6FY2bSdj8KdEEtbyy9bLZajCtng5x9drnBmtdDDzcbChjk9P9CREOsHcfYARe7PGcTwr0fixysCc3hE9QiTG1dPw1wC2WQP1EM+lqguLJwAu7x9pTG7tHrnTlxfg/KE7Utf1wHICOuzNIbNrolgjJNzMazt305OBAQHFnYz
 tydFMmnT
 TyiHrRAXt3CMVOnrWkmn1wBfqxRF0vkjBEj1ee/msV9J6NMrAKI40bP+hm9Qzr0p5j83+WyadxeMY8w+OMuoJKEGDWTzHt5yg/4riyDpIrk0+iovCpZSPMn0VtqTqVNigDGletosLfQLt+dZ5W9T0dzounrAOJEIBvk0V1kXitxGsY7mwsAoKilXHAkdd1qQ962DI1CjmEQp2AtP/2E7Y3QzMUzmsXrprXJNOmfLulFipRqSu2uZNx/1VMAYK31YoQB/aaEbUD0+6hdRdVDbO1bTOhbRBmrffo4GiGP0JnnGOKq71jMdRKYteo0CPS/jorH6b2O5nGskeDkZoOyCtHaNlNW55bfmIiF54ivWiVAYnppveSJxblLlEOWhK6cmJqg8qGosSzsMf0SSMemDyr9/fr8B4ctTjp5YdZOUztoSzrcY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__find_fre() performs linear search for a matching SFrame FRE for a
given IP.  For that purpose it uses __read_fre(), which reads the whole
FRE.  That is the variable-size FRE structure as well as the trailing
variable-length array of variable-size data words.  For the search logic
to skip over the FRE it would be sufficient to read the variable-size
FRE structure only, which includes the count and size of data words.

Add fields to struct sframe_fre_internal to store the FRE data word's
address, count, and size.  Change __read_fre() to read the variable-
size FRE structure only and populate those new fields.  Change
__read_fre_datawords() to use those new fields.  Change __find_fre()
to use __read_fre_datawords() to read the FRE data words only after a
matching FRE has been found.  Introduce safe_read_fre_datawords() and
use it in sframe_validate_section() to validate that the FRE data words.

Reviewed-by: Indu Bhagat <ibhagatgnu@gmail.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    Changes in v15:
    - sframe_validate_section(): Fix format specifier for number of FREs
      in debug message. (Sashiko AI)
    
    Changes in v14:
    - Adjust to rename of SFRAME_FDE_TYPE_* and
      __read_default_fre_datawords().
    - Update function name in debug message.

 kernel/unwind/sframe.c | 99 +++++++++++++++++++++++++++---------------
 1 file changed, 63 insertions(+), 36 deletions(-)

diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index b623dca072da..7f439600b0f0 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -39,6 +39,9 @@ struct sframe_fre_internal {
 	u32		fp_ctl;
 	s32		fp_off;
 	u8		info;
+	unsigned long	dw_addr;
+	unsigned char	dw_count;
+	unsigned char	dw_size;
 };
 
 DEFINE_STATIC_SRCU(sframe_srcu);
@@ -207,11 +210,11 @@ static __always_inline int __find_fde(struct sframe_section *sec,
 static __always_inline int
 __read_default_fre_datawords(struct sframe_section *sec,
 			     struct sframe_fde_internal *fde,
-			     unsigned long cur,
-			     unsigned char dataword_count,
-			     unsigned char dataword_size,
 			     struct sframe_fre_internal *fre)
 {
+	unsigned char dataword_count = fre->dw_count;
+	unsigned char dataword_size = fre->dw_size;
+	unsigned long cur = fre->dw_addr;
 	s32 cfa_off, ra_off, fp_off;
 	unsigned int cfa_regnum;
 
@@ -253,11 +256,11 @@ __read_default_fre_datawords(struct sframe_section *sec,
 static __always_inline int
 __read_flex_fde_fre_datawords(struct sframe_section *sec,
 			      struct sframe_fde_internal *fde,
-			      unsigned long cur,
-			      unsigned char dataword_count,
-			      unsigned char dataword_size,
 			      struct sframe_fre_internal *fre)
 {
+	unsigned char dataword_count = fre->dw_count;
+	unsigned char dataword_size = fre->dw_size;
+	unsigned long cur = fre->dw_addr;
 	u32 cfa_ctl, ra_ctl, fp_ctl;
 	s32 cfa_off, ra_off, fp_off;
 
@@ -325,24 +328,34 @@ __read_flex_fde_fre_datawords(struct sframe_section *sec,
 static __always_inline int
 __read_fre_datawords(struct sframe_section *sec,
 		     struct sframe_fde_internal *fde,
-		     unsigned long cur,
-		     unsigned char dataword_count,
-		     unsigned char dataword_size,
 		     struct sframe_fre_internal *fre)
 {
 	unsigned char fde_type = SFRAME_V3_FDE_TYPE(fde->info2);
+	unsigned char dataword_count = fre->dw_count;
+
+	if (!dataword_count) {
+		/*
+		 * A FRE without datawords indicates an outermost
+		 * frame.  Zero-initialize CFA, RA, and FP location
+		 * info, except for the CFA control word, so that
+		 * neither sframe_init_cfa_rule_data() nor
+		 * sframe_init_rule_data() fail.
+		 */
+		fre->cfa_ctl	= (SFRAME_REG_SP << 3) | 1; /* regnum=SP, deref_p=0, reg_p=1 */
+		fre->cfa_off	= 0;
+		fre->ra_ctl	= 0;
+		fre->ra_off	= 0;
+		fre->fp_ctl	= 0;
+		fre->fp_off	= 0;
+
+		return 0;
+	}
 
 	switch (fde_type) {
 	case SFRAME_FDE_TYPE_DEFAULT:
-		return __read_default_fre_datawords(sec, fde, cur,
-						    dataword_count,
-						    dataword_size,
-						    fre);
+		return __read_default_fre_datawords(sec, fde, fre);
 	case SFRAME_FDE_TYPE_FLEX:
-		return __read_flex_fde_fre_datawords(sec, fde, cur,
-						     dataword_count,
-						     dataword_size,
-						     fre);
+		return __read_flex_fde_fre_datawords(sec, fde, fre);
 	default:
 		return -EINVAL;
 	}
@@ -385,26 +398,11 @@ static __always_inline int __read_fre(struct sframe_section *sec,
 	fre->size	= addr_size + 1 + (dataword_count * dataword_size);
 	fre->ip_off	= ip_off;
 	fre->info	= info;
+	fre->dw_addr	= cur;
+	fre->dw_count	= dataword_count;
+	fre->dw_size	= dataword_size;
 
-	if (!dataword_count) {
-		/*
-		 * A FRE without datawords indicates an outermost
-		 * frame.  Zero-initialize CFA, RA, and FP location
-		 * info, except for the CFA control word, so that
-		 * neither sframe_init_cfa_rule_data() nor
-		 * sframe_init_rule_data() fail.
-		 */
-		fre->cfa_ctl	= (SFRAME_REG_SP << 3) | 1; /* regnum=SP, deref_p=0, reg_p=1 */
-		fre->cfa_off	= 0;
-		fre->ra_ctl	= 0;
-		fre->ra_off	= 0;
-		fre->fp_ctl	= 0;
-		fre->fp_off	= 0;
-
-		return 0;
-	}
-
-	return __read_fre_datawords(sec, fde, cur, dataword_count, dataword_size, fre);
+	return 0;
 
 Efault:
 	return -EFAULT;
@@ -527,6 +525,10 @@ static __always_inline int __find_fre(struct sframe_section *sec,
 		return -EINVAL;
 	fre = prev_fre;
 
+	ret = __read_fre_datawords(sec, fde, fre);
+	if (ret)
+		return ret;
+
 	ret = sframe_init_cfa_rule_data(&frame->cfa, fre->cfa_ctl, fre->cfa_off);
 	if (ret)
 		return ret;
@@ -610,6 +612,20 @@ static int safe_read_fre(struct sframe_section *sec,
 	return ret;
 }
 
+static int safe_read_fre_datawords(struct sframe_section *sec,
+				   struct sframe_fde_internal *fde,
+				   struct sframe_fre_internal *fre)
+{
+	int ret;
+
+	if (!user_read_access_begin((void __user *)sec->sframe_start,
+				    sec->sframe_end - sec->sframe_start))
+		return -EFAULT;
+	ret = __read_fre_datawords(sec, fde, fre);
+	user_read_access_end();
+	return ret;
+}
+
 static int sframe_validate_section(struct sframe_section *sec)
 {
 	struct sframe_fde_internal fde;
@@ -648,6 +664,17 @@ static int sframe_validate_section(struct sframe_section *sec)
 					fde.rep_size);
 				return ret;
 			}
+			ret = safe_read_fre_datawords(sec, &fde, &fre);
+			if (ret) {
+				dbg_sec("FDE %u: safe_read_fre_datawords(%u) failed\n", i, j);
+				dbg_sec("FDE: func_addr:%#lx func_size:%#x fda_off:%#x fres_off:%#x fres_num:%u info:%u info2:%u rep_size:%u\n",
+					fde.func_addr, fde.func_size,
+					fde.fda_off,
+					fde.fres_off, fde.fres_num,
+					fde.info, fde.info2,
+					fde.rep_size);
+				return ret;
+			}
 
 			if (j && fre.ip_off <= prev_ip_off) {
 				dbg_sec("FDE %u: FRE %u not sorted\n", i, j);
-- 
2.51.0


