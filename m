Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60685CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:41:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECBF16B00EC; Wed, 20 May 2026 11:40:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA2316B00ED; Wed, 20 May 2026 11:40:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D450F6B00EF; Wed, 20 May 2026 11:40:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C5F686B00EC
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:40:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 81E4D8C6DA
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:40:51 +0000 (UTC)
X-FDA: 84788211102.19.04E5092
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3568F20006
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:40:49 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="RD/g3fY6";
	spf=pass (imf31.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779291649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZeB+AJY8s5POZxP6bM/RVogEAvg1ms4HdMyeqTBjyvM=;
	b=6NbXi4FOPq+3qyIyMBNASqnJz4eIBgC6sqPLQ690uPwyg2oKS688RG0CxVIuUY3a3mgS97
	pLdkv3TXqnzPjsiCYn16GprzRnNQh6P/nQEV3EE9Eb1VAVfmHfISeH5pos5NYiKnxu100H
	fWcstNJgx8g66J4+cndIzBVtjuiRVVc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="RD/g3fY6";
	spf=pass (imf31.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779291649; a=rsa-sha256;
	cv=none;
	b=J6Wd8KxxVErOJ5dmcYdpcSISYGquArEewtO+0qs3MGZpNjLukXU4oyXitdkp5XkJfI36KR
	X8jyJkR5/WBSKrkBU6p/huj5uCoWA85MgGe+NatAsICabOPtKfKturrLprdwBvmrSbiE7L
	JzSrbg658Uj/Gx+H2fZkeAE7Eqkm98U=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64K8u58O1853987;
	Wed, 20 May 2026 15:40:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=ZeB+AJY8s5POZxP6b
	M/RVogEAvg1ms4HdMyeqTBjyvM=; b=RD/g3fY6EWfDNp/w0UBgEicMypatyenKy
	3RaR6ERIwaRcMUXiFrIx6r/03GAazGh82we7wWWWqzBM+XR1yQGzALnCKoT3n6eV
	Cs92fLX5MxM83uUwDzlRx9Un3ag4rSP2U/Khbk5VLLa1hCeklN04lMuJ6cF/aOYy
	0FDx9uPD3e5mDaUYVwnbL/YWEJvfy84r+MKC7fIk+4JGUNPOYfDdvUIY4SJ32gA+
	Y/BLEHuJagYpn/517TNMafhT6dSWxqklpGL8r7ZU7F+0Nr+wZi9iTbJWIffLA1/3
	a7pF8Mvc8mtUkCnXBeLwa4TCJAz9O6XRHbkKxl+2zzUhOgWklWH3w==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6hb8hsp7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 15:40:22 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64KFd6ER008370;
	Wed, 20 May 2026 15:40:21 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e739w03bn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 15:40:21 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64KFeHI154395282
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 May 2026 15:40:17 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 389E820040;
	Wed, 20 May 2026 15:40:17 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A7C192004D;
	Wed, 20 May 2026 15:40:16 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 20 May 2026 15:40:16 +0000 (GMT)
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
Subject: [PATCH v15 17/20] unwind_user/sframe: Separate reading of FRE from reading of FRE data words
Date: Wed, 20 May 2026 17:40:01 +0200
Message-ID: <20260520154004.3845823-18-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260520154004.3845823-1-jremus@linux.ibm.com>
References: <20260520154004.3845823-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDE1MSBTYWx0ZWRfX0Trjn55NgIGF
 nFmj/AwOweeBjV4fx2+U7L9IXxopDOpSf3IMh+f+iQuKqg2g/UFGCEWRJLxq1evIeIipnxL1wD4
 WO5Ugye7TwkFmDmUsmSDTv2Px4OEmXuRE9rpQf+8iJuKl0mup4uxrAbeSA5+sTPkIcBUp1EZ5a9
 31OyFIv+q+f+IBHE+E7hjXnt41amhLbONtF/nZVwNviCKmT0cNZOR2be22oYgcNXMknU37TSenK
 oDpmuIEMqKxIBQQDqnAMtSa2HZVcioTqs1mit4BSIlUv7NuGvpEfEean+BqxtdPiNQY3iSMqc9K
 J8YjX1wmXYo0gFU3qYhnukPCGT+v+MRBuCWAro9c9G2MV5OPUiSdoU2EMUfT49QbFr0/yFw+pQR
 QE6SvzIzOtrNFpIiyh8o6vmJprL+biT1rHv9eMBwye72Lbeigoh+s/xsiBNoA9SbnGD5eWf4YCZ
 fux8iZg6Sw96LsdfbUA==
X-Proofpoint-GUID: daHlmjUCKwnUU2QR6CcS6CYQF7OeHemo
X-Proofpoint-ORIG-GUID: EJZsbENNxJMgg-1nssR3pfk7dgGh3IgB
X-Authority-Analysis: v=2.4 cv=aYBRWxot c=1 sm=1 tr=0 ts=6a0dd5e6 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=RXKZOtKmAAAA:8
 a=p_lxmaMNnb8s4VerTYQA:9 a=UFF3uGjEBZWolfm0k6KQ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605200151
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3568F20006
X-Stat-Signature: uxk4g7oefmfz5eg9n6j3t17416i5a57m
X-HE-Tag: 1779291649-464797
X-HE-Meta: U2FsdGVkX1/pmRJA5kfPp/jWqRFEv9uOWXN6a+fKAbSFxeWplwGxU58OJRF7lZUYJfy+n0vAH1lBC1zWN+XlgtVMQvl++enh71zYLE+d9JLlW4BfsN8sE/sy/W1RpOfq5DJSMKKHbZ2N6a3+FVRlPDdOoW88ftYJIUFShrZOclioJwpb4kH9++OnGuUHNrFS6p3b6x8wdVK+UYkF/ivPoGx+wMtJHpIx/a3IiUoRYGdjUa3dI7n94vq63P8n+CfgBaQqkGTL/KhVMWwUryapN3QFaTQxqJSUmA9EW+bAvuYQ36danCmKFgp14QWVdX+dvoYyVtdEiNjOROywkl/GAWWixBYZUE4AmmE/a4RYzPJhdKZr4fPGa/ioexhvj0ChYLqC/HqJtHGExoxCRyP8uKnXVxrlk8uB70JOFHdbc+bmsPBpWj91CVkPAYPmTXAUkcqP0CZAh+wWFIZr5qWv8kkj8ZQGogcLSe1K0SbWdDUZn6lHHPY/FtoTuLWD5PeqNY4Y3iFbRP4Ng0iHP7FFhceva+gcQGbcwJffEc87FClkTLzPRJiW/JbjwpcZrC2kfvbBh7P3yiucZP6BkTll9Hm/2bvO+80EcBhLe3paDgjKdpQrB1tHJ+Zzs+MQyflggPOsZW6/E0/KeBPorhYewekLugqaY7Kf/lgZaizg2Dr1ETsYGyz0+QUAnopCXT2w+aYxQRwTjvj1A9QnSC+htHsKgryamsKPZ+uXr+PNMnbtzGPAUKoIRxiMSE0BUtbuOKtj+1BoC8NplaUp72/R3hnxcKtXwxrjXQ5tnV+Rb8H4Ilhsv/ihoAsqA959eRsAP7KWGV3Gdf68sePnY5vn7Dp8bbgbf3pNWaPQFdx6Brx2IqszApRoKT4bXN+MWto/yMqNpWmGfk2+sXvb/Af48H72hTs24ombchacOkznu8vO15eK76HlRnxL4eZFfruwrpb6LKXNMVKZxXsYfWG
 /tvE5HBt
 Qd0nPBMdl7LGaJGujmOs2gbRl+oH8izL+k/oFIAofiAdrfekBuxSMcuWn9w7QMf4Si3lRwLAJvwYuggKpwd7bMUOgC5GCGeRFB3pTrNnDa6v+iUKLHlLiEB2mzp8P1WMTSH0xd0ZScSrTUdFXS2lNDhpTChk1F7HBxdCgKoHBjjALBbROIxLZPimlz20Z5y26f+At1Wj7l4CWDXnYJwd/+sLM0lySBa3BDLRipaX0UkHmm2a7QzZXdGPymvZ9DL1m+RBA6nJ1T1tqmSuPIKaLJUmfLvCE/nZJ2U1agmVHBqnNW7khe1+gS0uhl0ln8biMmrREA+ydMpvgiw/l6sxD8WMNJA==
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

 kernel/unwind/sframe.c | 100 ++++++++++++++++++++++++++---------------
 1 file changed, 64 insertions(+), 36 deletions(-)

diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index 48709f0bafc7..ec8318977a2e 100644
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
@@ -491,6 +489,7 @@ static __always_inline int __find_fre(struct sframe_section *sec,
 	bool which = false;
 	unsigned int i;
 	u32 ip_off;
+	int ret;
 
 	ip_off = ip - fde->func_addr;
 
@@ -528,6 +527,10 @@ static __always_inline int __find_fre(struct sframe_section *sec,
 		return -EINVAL;
 	fre = prev_fre;
 
+	ret = __read_fre_datawords(sec, fde, fre);
+	if (ret)
+		return ret;
+
 	ret = sframe_init_cfa_rule_data(&frame->cfa, fre->cfa_ctl, fre->cfa_off);
 	if (ret)
 		return ret;
@@ -611,6 +614,20 @@ static int safe_read_fre(struct sframe_section *sec,
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
 	unsigned long prev_ip = 0;
@@ -656,6 +673,17 @@ static int sframe_validate_section(struct sframe_section *sec)
 					fde.rep_size);
 				return ret;
 			}
+			ret = safe_read_fre_datawords(sec, &fde, fre);
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
 
 			fre_addr += fre->size;
 
-- 
2.51.0


