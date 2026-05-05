Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26355FF885A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 12:18:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59BD76B00A1; Tue,  5 May 2026 08:18:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D7106B00A2; Tue,  5 May 2026 08:18:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 303A26B00A3; Tue,  5 May 2026 08:18:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A3C86B00A1
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:18:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CB46C1A04B4
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:18:17 +0000 (UTC)
X-FDA: 84733268634.10.65143CE
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4A51140007
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:18:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=XYpw+7Ah;
	spf=pass (imf27.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777983495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BsJFflFxi0TyekZiMZ22S7kAUExaFPaOXKgOlpUzzOo=;
	b=jBPKstSYbf2Gy13VDF4B4/m5bN1xw0DaPgFX0mp4skeQqCj9U/1jrVNSrC/zwSBOr3Cx60
	rKmptb6OCBA2J/BcEUCshK2MT58+jZC/+3P3R1nzyDTCVS6Ti3j+xCHlMKOKCYWVhf/fpS
	T/mO2jSKZ0hmLwoTX3RP2vnl8PbUaKs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=XYpw+7Ah;
	spf=pass (imf27.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777983495; a=rsa-sha256;
	cv=none;
	b=kOaPJSrp0q4Fcr+3E/TP5rkgH/7apJpjptA+I/ecZNKRPbdWmdcEtLegdQysg+w4Lp5DcC
	8oRkxxgqI0l/7vdR4hsnSYqW1PBMZx76HjqDgFOUJ6BLIwHQCpYE7xT+rlHT4l+zRf1tA4
	PhMIRreL7hXsacmfmSaBj3F1dzpPfbo=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 644Nx5wk1446669;
	Tue, 5 May 2026 12:17:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=BsJFflFxi0TyekZiM
	Z22S7kAUExaFPaOXKgOlpUzzOo=; b=XYpw+7AhXLgr4Rr7B6pyHK6/CB4mzWjzV
	TnadZL2o0mfdNYk2AQT0QQhiKf96Rmz5d+hNzPLJQ7cd8JANdwrAGh1Vkz9oSGcp
	Mr/xhH8r7vdp01/JrzPw5jaRVxAAJC7v5ElmZYayR1Kv4Qq9urwyyhThryV4hW/S
	n2fcXDS9bJFBD9DPvIVgEwvhM6fdhtdJ25IPflssKQZKqsrfjtHcBJpOWN3mNI9U
	pDslnhLw4/MVVi7ULDeZfWc7kyjdOxt4qYZwMB0cD2uCYZ7dx/0JQ/qrO41TFAuh
	oy/P1fq95PIJTARtIXD1FIjB44EqkmA2FFsAG8CUPG3ttjjgyg7bQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9v7bja1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:33 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 645C9fVW030232;
	Tue, 5 May 2026 12:17:32 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dwukq9nmv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:32 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 645CHS0610027286
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 May 2026 12:17:28 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 95C382004B;
	Tue,  5 May 2026 12:17:28 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 313FA2004D;
	Tue,  5 May 2026 12:17:28 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 May 2026 12:17:28 +0000 (GMT)
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
Subject: [PATCH v14 17/19] unwind_user/sframe: Separate reading of FRE from reading of FRE data words
Date: Tue,  5 May 2026 14:17:16 +0200
Message-ID: <20260505121718.3572346-18-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260505121718.3572346-1-jremus@linux.ibm.com>
References: <20260505121718.3572346-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDExNCBTYWx0ZWRfXzk8oGrimpxjw
 LBbsRfMUas3OGl13Gyy6y51GgI8gtf+Fke5e9wGSjaVWpBYGQDzSaQuD84p6+sk8c4a1XfMntep
 WdiWlgyzFrrODDWHPyJbVUDz6M7q+BZ74ovGGPV+KS8iuwvhZCdrhEiNRu4eX3/ckJurh92iOVx
 qIM0ooh1FOwqZewoVqGJQkAw0csJTyFZfweBMSrYA6Ns53UY9bWhnXNSzpcS0tYAqodT635N4Th
 z3s2rwRtebuAIbyt8+eor47oUcgot1f0yKCIAK5XArKsQm9cD3qIZk6LAeepazLcXRBljbm9BmP
 /MLHA1tevVdRNXQyhQvbBdHWIu3puSwbAJbIn8HEu3bDTE0M/5dj8H0W8unC9d3RYaVIwqyS7fl
 0X/9KdZljzmW4Kfs4rbJJfHPNmUxBvmKHJL3VPRmnzBNpHvBu3HbJxZECs5DpCNitcNdVEaFsTD
 b6DvdamqFHD04kSti9w==
X-Proofpoint-GUID: TQbmsIJlRq3L3ufjnmpXUJYzstWtmNml
X-Proofpoint-ORIG-GUID: 5CxLYMeQdm8PctbsYmOZMYbX2qSPMeyW
X-Authority-Analysis: v=2.4 cv=eu/vCIpX c=1 sm=1 tr=0 ts=69f9dfde cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=RXKZOtKmAAAA:8
 a=S_iktsTmVn5NcIvqSDAA:9 a=UFF3uGjEBZWolfm0k6KQ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605050114
X-Stat-Signature: b91kint4dtr63j7nbjzkumrn81yeyry5
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4A51140007
X-Rspam-User: 
X-HE-Tag: 1777983495-315697
X-HE-Meta: U2FsdGVkX19yHeG4GgOxRM4ZnyaXhsQgD021m1F7VtpIC+K37durpwZ8YwVj0EsbT5ZTMif8mm5+C3o2Bw1wYDEZm9QPs3xlt2yE4R4OjX5LxT2WtIZcj7ytkGUMCC2zTrz8IF+cNU6By06aRDVkwCvbi0MEy6+3Qgz9ppS2tkD4Ql+OMEOPya+XTbUGUFriCwz7MbtKK/CDXsbx+nyYdvVKStl06dsLhk3x2EyJ7kLHsy2LbSp1Z9hofBiEohjxmFtZtvGZtOBVDihHea/sG++3z+k4rxgORIQCK83uC79bHFU2+TYFy1x10In61DIZ9Sal8UKjB3vERz9zifsjx3cOWrOWuQ/tyYJfL5LsiJDXo+M0Hlc6OUXOqSscI58Xw+67VjHLhxJ+FQnrink5xMeTvo2FMRO3ZJuhEI3J9LbHcqcr/GUvWX9tC3O7A7KqlKUtYrSC2IGEYrw8q8vv/zBWRVj9jPPUYEHPdCzCYm1znpIswH7dPG+tFILMgbXIZRZcVJpVgC7xGwCf0aMaNcMkQO1jHC8+FbfhRxHzC+wMdPrV0wMEMuoSNTu/Yphjkf/hCNrzUVBlhJVY0JECyigx7b+BC2qlUAdLBXUBeCcHlmJSxD9V5jZ6UIXixDRKuQ8ruyfSyHgfrIM/1ga9R6AKSdeuOpVv10mY+l30z98mOxvMge7z9/3CJf8TmKk53YUwNKngEYV0qqpRsi3+wMR6lJNW+IKIAUX5qUadSMqO8z4eENqUdmu0l5C3p/AvQiEQdJ4WhH3twbkd2/lRcpWG9MOkNCQAZwCoFp46ui3aa7o3bhXYm1tsqCsI3FHrvA+bPR6Zol1YZRSMEGUxAOlC5OrkwDeO0/n+ONUlMgQ3dDPzJJ+908k46ciwGStvP0Awlkhx6YYmEAM78WYYQ62cOI+GN0/Hz8yeD+QRYC9SeaOFXSlc6I06bPkkX96AOjdhygGVFH38Owhudhi
 oOBuYn0W
 mSnoYhZxC6F1sT+yv7ux0ISxPqDGOce55yGU7zDKDXr8DfT8nn1cgMRqmqvrxDaqg8fzSkc3NNUi+ONkILqNyQzUETqbdY3VzJJkl4iJheWEuk6pwdBF3szpjurlDnMOTh/SjlJzYDsaWGFSGmZQrgqHG5rT8T/aG6JmSUVrUC76fUSfodSWSQKoBbIz7sw1WG44WUrDb27vQPDfMN0S2xTZ03liiQjlZtkUDGLblSAUqeHE+PTvpk1n+/nYhOOw8ot8ZdLPcnzMv7y+Z3K8ac4Bzfo/vB/cGZaGHMcO/sKBLZvWToZpLd8N5/gCaM0kihLj6JPsMFGtfNqxgCzqAbtqrqBVx4nmay9Yrp/HGftrLLo8Zmu1NtuDuCl4Jk/EHsRRXPItwGMmLDvRF6ADZQixQcenorViBwrMLEtjEdX31FqE=
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
    Changes in v14:
    - Adjust to rename of SFRAME_FDE_TYPE_* and
      __read_default_fre_datawords().
    - Update function name in debug message.

 kernel/unwind/sframe.c | 91 +++++++++++++++++++++++++++---------------
 1 file changed, 58 insertions(+), 33 deletions(-)

diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index 2ba2c8b385f9..98346412078b 100644
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
@@ -196,11 +199,11 @@ static __always_inline int __find_fde(struct sframe_section *sec,
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
 
@@ -242,11 +245,11 @@ __read_default_fre_datawords(struct sframe_section *sec,
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
 
@@ -303,24 +306,28 @@ __read_flex_fde_fre_datawords(struct sframe_section *sec,
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
+		/* A FRE without data words indicates an outermost frame. */
+		fre->cfa_ctl	= 0;
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
 		return -EFAULT;
 	}
@@ -362,23 +369,11 @@ static __always_inline int __read_fre(struct sframe_section *sec,
 	fre->size	= addr_size + 1 + (dataword_count * dataword_size);
 	fre->ip_off	= ip_off;
 	fre->info	= info;
+	fre->dw_addr	= cur;
+	fre->dw_count	= dataword_count;
+	fre->dw_size	= dataword_size;
 
-	if (!dataword_count) {
-		/*
-		 * A FRE without data words indicates RA undefined /
-		 * outermost frame.
-		 */
-		fre->cfa_ctl	= 0;
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
@@ -455,6 +450,7 @@ static __always_inline int __find_fre(struct sframe_section *sec,
 	bool which = false;
 	unsigned int i;
 	u32 ip_off;
+	int ret;
 
 	ip_off = ip - fde->func_addr;
 
@@ -492,6 +488,10 @@ static __always_inline int __find_fre(struct sframe_section *sec,
 		return -EINVAL;
 	fre = prev_fre;
 
+	ret = __read_fre_datawords(sec, fde, fre);
+	if (ret)
+		return ret;
+
 	if (sframe_init_cfa_rule_data(&frame->cfa, fre->cfa_ctl, fre->cfa_off))
 		return -EINVAL;
 	sframe_init_rule_data(&frame->ra, fre->ra_ctl, fre->ra_off);
@@ -567,6 +567,20 @@ static int safe_read_fre(struct sframe_section *sec,
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
@@ -612,6 +626,17 @@ static int sframe_validate_section(struct sframe_section *sec)
 					fde.rep_size);
 				return ret;
 			}
+			ret = safe_read_fre_datawords(sec, &fde, fre);
+			if (ret) {
+				dbg_sec("FDE %u: safe_read_fre_datawords(%u) failed\n", i, j);
+				dbg_sec("FDE: func_addr:%#lx func_size:%#x fda_off:%#x fres_off:%#x fres_num:%d info:%u info2:%u rep_size:%u\n",
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


