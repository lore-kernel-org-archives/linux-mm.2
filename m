Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF7A5CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 15:04:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B68126B00D2; Thu, 21 May 2026 11:04:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A57746B00D4; Thu, 21 May 2026 11:04:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 946AE6B00D5; Thu, 21 May 2026 11:04:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7BE146B00D2
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:04:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3F5851612EF
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:04:00 +0000 (UTC)
X-FDA: 84791747040.20.535DE47
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf30.hostedemail.com (Postfix) with ESMTP id BC3F280016
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:03:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=I7StSIzD;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf30.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779375837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fj34Hxw8OmO1XreQPmifGNH4anzSb1oTetriPvSQoAo=;
	b=NZMO6SEZm+KCQB9jDojBd0y6lnnPIJsUzGv3FeaTAU/YnrKPASiEZIbzkI/eoZb2aNvz7K
	E6w+79lB8YcqyGY2rHa+gQHCgVDH/zSRdUMMo0QA9qJTHcNUuLF9138TW4R67OxR2osYS0
	0Pmv46stgLZ24oa3Map6ACR4p0Y07gs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779375837; a=rsa-sha256;
	cv=none;
	b=QMK1ZYa1UK23T9YWfh2K1VZHBYaXe3CMnqwGk9TuT/Ze/rH7kTaBfeY/Q+FvPvi2dx+Inr
	zSnp1/hGAIb+FGJ6Nc/d+uZse4ZzUriryPsT7mNLu+SZUWKzNiL0rjRkFEHEDkYmurMGD2
	6GP1MIqgJBGuweV25e7Gz1BF/Osp0U8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=I7StSIzD;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf30.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64L6aa7S3901160;
	Thu, 21 May 2026 14:26:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=fj34Hxw8OmO1XreQP
	mifGNH4anzSb1oTetriPvSQoAo=; b=I7StSIzDXXChcV6vu9/VqUSslAmy2Etu2
	47Bsrzj3ldoMqTdFuQfCVSU1reotUyLVBP6ecaKOIzFUcYlQEuAotnXDZJtK9R3L
	jpo+65pQiyP2DPO/6gIRJrlFB3YTTpixsJd35o2kImrOJlaeIzUXFF9M2AIcADcY
	ZR68Dukz5rrpmE5aNrj+h2nno0pgA2mRB/BcXhLD2lnQUpLdqDI494nZfWUUaqye
	aVe/eetcf1d841RtypdjbI4O15HAa+bGJKxmm4vy+Lol9luBY7gxr4FZz40aVZr9
	MozKGRH3Mc2DCdzaFlpglbrVjXTgHLhhjvIfiqGocvnYWF0gXIhMw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h8myda7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:26:00 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64LEO5mf002155;
	Thu, 21 May 2026 14:25:59 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e754gmbhw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:58 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64LEPt5641746882
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 14:25:55 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8083720040;
	Thu, 21 May 2026 14:25:55 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 18D7120049;
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
Subject: [PATCH v16 16/20] unwind_user/sframe: Add support for SFrame V3 flexible FDEs
Date: Thu, 21 May 2026 16:25:42 +0200
Message-ID: <20260521142546.3908498-17-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260521142546.3908498-1-jremus@linux.ibm.com>
References: <20260521142546.3908498-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: MGhftGt0CGJtqdbQA7LpVm3I6HBV813l
X-Authority-Analysis: v=2.4 cv=GYMnWwXL c=1 sm=1 tr=0 ts=6a0f15f8 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=meVymXHHAAAA:8 a=8hFt8YRx_kKiWWpTwHgA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-ORIG-GUID: Ex4YXw1v8QCNNWO1yMPNipa4QQnzOUeO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDE0MiBTYWx0ZWRfX6gS7F3SzEskC
 heV9GEFGrnoMW4gAnRZf4DDnnOxuiuhviKeMMdt0X9KjhOzOqNHfRHcPt4X5T/y8KVXAyNzc16D
 /dVBiIk8Jr5GOb0l/1SQ3Q9WvJykbxz/7SQowLY0XKEul/ITMa+FKdPnBs7V0gYtu0S+/0dtLaX
 aFfScjNUn6dILwcarnswKMt2zV48dQjVopl3k8L0AQDQ7lZrsf4GW73m3QhrpWwiLNPqr6DrZqz
 HRu+hIIRJUR6M3T+IcEp/zaF2vJi12FN8D0I/u5/SlmwkdCwVEJxFR/mIwkpiJW5jF7D/GYbjXV
 bra67gM22iI+ib2QdslRTC0kNu2uqrNZNwkPlab89gfRRdOAF7jRzmD87P1eofJ0k8TvWqS+OZ+
 6jrBoRI0tJYIKNP+Otb7lUUZMkbab4pDjWSD+B+x7cV1ihj/JdVQ+YvRWlkgb4olycVTut7Lz2q
 971HaLDAinhjFAeBYrA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210142
X-Rspam-User: 
X-Rspamd-Queue-Id: BC3F280016
X-Rspamd-Server: rspam04
X-Stat-Signature: 57ftfwued9f6wy69wcjci7cqtcay6km6
X-HE-Tag: 1779375837-200395
X-HE-Meta: U2FsdGVkX19VwMAR7qnc+mCYR85KDIYM7LK8ImD9+mnRzACdYQXeWDKCC79G0GtPEBcqvfI6mKd84XeG3JbaZvj58+KpI0kwiARbFTNCjTh4Y4EpNVCxOmqfYjg+uHCG90toRUgT0DD6gfLaTCAXx3dkly8nDzQgoUWYzIsWJhOOpL5IVgmy7z1Mv4b6TSAgiPuopkv933fD4PljyGxAFjK5ISruX+DatZIXTp1QiNPa1BIZ/QyjtbmkKX3nn6wMxl5pVbeECVDi2d56aUsH+jDhWvIgm69JN8hpEXH/bxxNNrW5cga7K1dIrxWmrejI4ggW9BWNKwnsUYvNfb2LFb8ebmfvxLS+np2aKgpvW6yNQAbz2PjrnRixtpo0okC275p2NA0YjxrjWfldkYMpP/YN4GN6xapYNMPF2JslE0mL133wYYvMPn7sRhxEzAe5Svxz+Wlnv+gMX9K93kZbRwy1i0PNi3YHHf3CqcJia+M0pm4luKHDfYHrS+n5mIVr1MhdLCCtdFRdn0FqEdtzYpvFvhK1pU5leMCmANKig5Blw5W+7xRHrsKYvsCFj+TH8HHXRVgGPX47M8A0yiUc2iRskxSxTCTKA1p+1Bj36kVk8EbGO1tO7HeooYcw01bJNCzYUeXDdHoGpNcezy/9uSukKRV7OAmwUsHP6nq6Cm+Vl30MX/AHLpXn11x192jqZC2g23o0wNc9jikr5g7HBNzGJlB44W5NSDm1ppDrGznuaDQS5w3a/jNhx5XPOzBcN7LPzezybWOnWkaoBjljOCn08iGiRCcIopf3e/lof8gYtPXCm5CT/uj/VDOHqq5+LT2Y4egCPOJ7ukDotnDYP+Qf5XkuPEY7towVM0zWYeOfNzqUjT39bo5CKvaSGSk5k/Qzzw3ABNXq30iMGf8spX0jJx0vGXB5UBBma2+GgATsYqgfF5P13giMvMdabZaTTc6yp/SIrrcwdMMrhmk
 sMbM/yKi
 5dkqJqEMdO9cj+CXRGBw60RpzwHlsDL5R2xn5QBGXj13NWXXSm85p3Q4d0YuSeGNxiTOP8+q8QzIT5K6FabChqj7ez+Bwq37coVv74SPANxS/QatmH3+IIONLbAiLzHVO2KQxuCbvYBSdsEZ1cWBQ1g+v3ukgcWGv1p+sOJ51dZbG76yWQYV6f92bPdCxul1ONVdJKMcBORXOMKW78VR/0vhZXe5kxnjmtUbjg+0/gQo7SXFen2JMvWaI2VSagCw+xT8VTZhY/dpJ4mHklK3+VLACkRQksmGaZnZUkZ3x2D02uBhg/xAzGjWxSp2l50kFmxyqzU7E44ny+JDWRinZjRBp4/KhfaePNSs03vwV8DulbwyfFWPrGspRUqEzzI9XQg0a5RwzRjNiX30ElMlGKzbQ4ov/ELBiJ2tetMZy1YO+QRkMVWIdaHElXyywEIYHC2dg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SFrame V3 introduces flexible FDEs in addition to the regular FDEs.
The key difference is that flexible FDEs encode the CFA, RA, and FP
tracking information using two FRE data words, a control word and an
offset, or a single padding data word of zero (e.g. to represent FP
without RA tracking information).

The control word contains the following information:
- reg_p: Whether to use the register contents (reg_p=1) specified
  by regnum or the CFA (reg_p=0) as base.
- deref_p: Whether to dereference.
- regnum: A DWARF register number.

The offset is added to the base (i.e. CFA or register contents).  Then
the resulting address may optionally be dereferenced.

This enables the following flexible CFA and FP/RA recovery rules:
- CFA = register + offset	// reg_p=1, deref_p=0
- CFA = *(register + offset)	// reg_p=1, deref_p=1
- FP/RA = *(CFA + offset)	// reg_p=0, deref_p=0
- FP/RA = register + offset	// reg_p=1, deref_p=0
- FP/RA = *(register + offset)	// reg_p=1, deref_p=1

Note that for the CFA a rule with reg_p=0 is invalid, as the value of
the CFA cannot be described using itself as base.  For FP/RA a rule with
reg_p=0 and deref_p=0 and regnum=0 is invalid, as it that is equal to
the padding data word of zero.

Reviewed-by: Indu Bhagat <ibhagatgnu@gmail.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    Changes in v16:
    - __find_fre(): Move declaration of ret to function scope to resolve
      compile error. (Sashiko AI)
    
    Changes in v15:
    - __read_flex_fde_fre_datawords(): Add comment on FRE dataword RA/FP
      location info decoding logic. (Sashiko AI)
    - Fix outermost frame (FRE without datawords) handling to not cause
      sframe_init_cfa_rule_data() and ultimately sframe_find() to fail
      with -EINVAL. (Sashiko AI)
    - sframe_init_[cfa_]rule_data(): Reject FRE control word with
      reserved_p=1. (Sashiko AI)
    - __find_fre(): Return RC of sframe_init_[cfa_]rule_data() if bad RC.
    - Normalize error code usage (.sframe is removed for all but ENOENT):
      ENOENT: No sframe or no FDE for IP found
              (FDE found but no FRE is EINVAL)
      EFAULT: Bad address
      EINVAL: Invalid input or sframe
    
    Changes in v14:
    - Rename __read_regular_fre_datawords() to
      __read_default_fre_datawords() to align to SFrame V3 specification
      (default FRE).
    - Rename SFRAME_FDE_TYPE_FLEXIBLE to SFRAME_FDE_TYPE_FLEX to match
      SFrame V3 specification and adjust to rename of SFRAME_FDE_TYPE_*.
    - Rename SFRAME_V3_FLEX_FDE_CTLWORD_*() to
      SFRAME_V3_FLEX_FDE_CTRLWORD_*() to match SFrame V3 reference
      implementation.
    - Add arch/*/include/asm/unwind_user_sframe.h to MAINTAINERS.

 MAINTAINERS            |   1 +
 kernel/unwind/sframe.c | 287 +++++++++++++++++++++++++++++++++--------
 kernel/unwind/sframe.h |   6 +
 3 files changed, 238 insertions(+), 56 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a9b42b67a88d..25f0b933511c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27875,6 +27875,7 @@ M:	Josh Poimboeuf <jpoimboe@kernel.org>
 M:	Steven Rostedt <rostedt@goodmis.org>
 S:	Maintained
 F:	arch/*/include/asm/unwind_user.h
+F:	arch/*/include/asm/unwind_user_sframe.h
 F:	include/asm-generic/unwind_user.h
 F:	include/linux/sframe.h
 F:	include/linux/unwind*.h
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index daa97d8b0231..b623dca072da 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -12,6 +12,7 @@
 #include <linux/mm.h>
 #include <linux/string_helpers.h>
 #include <linux/sframe.h>
+#include <asm/unwind_user_sframe.h>
 #include <linux/unwind_user_types.h>
 
 #include "sframe.h"
@@ -31,8 +32,11 @@ struct sframe_fde_internal {
 struct sframe_fre_internal {
 	unsigned int	size;
 	u32		ip_off;
+	u32		cfa_ctl;
 	s32		cfa_off;
+	u32		ra_ctl;
 	s32		ra_off;
+	u32		fp_ctl;
 	s32		fp_off;
 	u8		info;
 };
@@ -200,19 +204,160 @@ static __always_inline int __find_fde(struct sframe_section *sec,
 		 s32 :	UNSAFE_GET_USER_SIGNED_INC(to, from, size, label),	\
 		 s64 :	UNSAFE_GET_USER_SIGNED_INC(to, from, size, label))
 
+static __always_inline int
+__read_default_fre_datawords(struct sframe_section *sec,
+			     struct sframe_fde_internal *fde,
+			     unsigned long cur,
+			     unsigned char dataword_count,
+			     unsigned char dataword_size,
+			     struct sframe_fre_internal *fre)
+{
+	s32 cfa_off, ra_off, fp_off;
+	unsigned int cfa_regnum;
+
+	UNSAFE_GET_USER_INC(cfa_off, cur, dataword_size, Efault);
+	dataword_count--;
+
+	ra_off = sec->ra_off;
+	if (!ra_off && dataword_count) {
+		dataword_count--;
+		UNSAFE_GET_USER_INC(ra_off, cur, dataword_size, Efault);
+	}
+
+	fp_off = sec->fp_off;
+	if (!fp_off && dataword_count) {
+		dataword_count--;
+		UNSAFE_GET_USER_INC(fp_off, cur, dataword_size, Efault);
+	}
+
+	if (dataword_count)
+		return -EINVAL;
+
+	cfa_regnum =
+		(SFRAME_V3_FRE_CFA_BASE_REG_ID(fre->info) == SFRAME_BASE_REG_FP) ?
+			SFRAME_REG_FP : SFRAME_REG_SP;
+
+	fre->cfa_ctl	= (cfa_regnum << 3) | 1; /* regnum, deref_p=0, reg_p=1 */
+	fre->cfa_off	= cfa_off;
+	fre->ra_ctl	= ra_off ? 2 : 0; /* regnum=0, deref_p=(ra_off != 0), reg_p=0 */
+	fre->ra_off	= ra_off;
+	fre->fp_ctl	= fp_off ? 2 : 0; /* regnum=0, deref_p=(fp_off != 0), reg_p=0 */
+	fre->fp_off	= fp_off;
+
+	return 0;
+
+Efault:
+	return -EFAULT;
+}
+
+static __always_inline int
+__read_flex_fde_fre_datawords(struct sframe_section *sec,
+			      struct sframe_fde_internal *fde,
+			      unsigned long cur,
+			      unsigned char dataword_count,
+			      unsigned char dataword_size,
+			      struct sframe_fre_internal *fre)
+{
+	u32 cfa_ctl, ra_ctl, fp_ctl;
+	s32 cfa_off, ra_off, fp_off;
+
+	if (dataword_count < 2)
+		return -EINVAL;
+	UNSAFE_GET_USER_INC(cfa_ctl, cur, dataword_size, Efault);
+	UNSAFE_GET_USER_INC(cfa_off, cur, dataword_size, Efault);
+	dataword_count -= 2;
+
+	/*
+	 * Each RA/FP location info consumes either two datawords
+	 * (control word + offset) or one padding word substituting
+	 * for that pair.  Padding is only valid as substitution if
+	 * followed by further non-padding location info.  Therefore
+	 * decoding only proceeds with at least two datawords.  Any
+	 * leftover trailing datawords are invalid and rejected by
+	 * the final check.
+	 */
+
+	ra_off = sec->ra_off;
+	ra_ctl = ra_off ? 2 : 0; /* regnum=0, deref_p=(ra_off != 0), reg_p=0 */
+	if (dataword_count >= 2) {
+		UNSAFE_GET_USER_INC(ra_ctl, cur, dataword_size, Efault);
+		dataword_count--;
+		if (ra_ctl) {
+			UNSAFE_GET_USER_INC(ra_off, cur, dataword_size, Efault);
+			dataword_count--;
+		} else {
+			/* Padding RA location info */
+			ra_ctl = ra_off ? 2 : 0; /* re-deduce (see above) */
+		}
+	}
+
+	fp_off = sec->fp_off;
+	fp_ctl = fp_off ? 2 : 0; /* regnum=0, deref_p=(fp_off != 0), reg_p=0 */
+	if (dataword_count >= 2) {
+		UNSAFE_GET_USER_INC(fp_ctl, cur, dataword_size, Efault);
+		dataword_count--;
+		if (fp_ctl) {
+			UNSAFE_GET_USER_INC(fp_off, cur, dataword_size, Efault);
+			dataword_count--;
+		} else {
+			/* Padding FP location info */
+			fp_ctl = fp_off ? 2 : 0; /* re-deduce (see above) */
+		}
+	}
+
+	/* Reject trailing padding or unknown extra datawords */
+	if (dataword_count)
+		return -EINVAL;
+
+	fre->cfa_ctl	= cfa_ctl;
+	fre->cfa_off	= cfa_off;
+	fre->ra_ctl	= ra_ctl;
+	fre->ra_off	= ra_off;
+	fre->fp_ctl	= fp_ctl;
+	fre->fp_off	= fp_off;
+
+	return 0;
+
+Efault:
+	return -EFAULT;
+}
+
+static __always_inline int
+__read_fre_datawords(struct sframe_section *sec,
+		     struct sframe_fde_internal *fde,
+		     unsigned long cur,
+		     unsigned char dataword_count,
+		     unsigned char dataword_size,
+		     struct sframe_fre_internal *fre)
+{
+	unsigned char fde_type = SFRAME_V3_FDE_TYPE(fde->info2);
+
+	switch (fde_type) {
+	case SFRAME_FDE_TYPE_DEFAULT:
+		return __read_default_fre_datawords(sec, fde, cur,
+						    dataword_count,
+						    dataword_size,
+						    fre);
+	case SFRAME_FDE_TYPE_FLEX:
+		return __read_flex_fde_fre_datawords(sec, fde, cur,
+						     dataword_count,
+						     dataword_size,
+						     fre);
+	default:
+		return -EINVAL;
+	}
+}
+
 static __always_inline int __read_fre(struct sframe_section *sec,
 				      struct sframe_fde_internal *fde,
 				      unsigned long fre_addr,
 				      struct sframe_fre_internal *fre)
 {
-	unsigned char fde_type = SFRAME_V3_FDE_TYPE(fde->info2);
 	unsigned char fde_pctype = SFRAME_V3_FDE_PCTYPE(fde->info);
 	unsigned char fre_type = SFRAME_V3_FDE_FRE_TYPE(fde->info);
 	unsigned char dataword_count, dataword_size;
-	s32 cfa_off, ra_off, fp_off;
 	unsigned long cur = fre_addr;
 	unsigned char addr_size;
-	unsigned int fre_size;
 	u32 ip_off;
 	u8 info;
 
@@ -233,80 +378,105 @@ static __always_inline int __read_fre(struct sframe_section *sec,
 	dataword_size  = dataword_size_enum_to_size(SFRAME_V3_FRE_DATAWORD_SIZE(info));
 	if (!dataword_size)
 		return -EINVAL;
-	fre_size = addr_size + 1 + (dataword_count * dataword_size);
 
 	if (cur + (dataword_count * dataword_size) > sec->fres_end)
 		return -EFAULT;
 
-	/* TODO: Support for flexible FDEs not implemented yet. */
-	if (fde_type != SFRAME_FDE_TYPE_DEFAULT)
-		return -EINVAL;
+	fre->size	= addr_size + 1 + (dataword_count * dataword_size);
+	fre->ip_off	= ip_off;
+	fre->info	= info;
 
 	if (!dataword_count) {
 		/*
-		 * A FRE without data words indicates RA undefined /
-		 * outermost frame.
+		 * A FRE without datawords indicates an outermost
+		 * frame.  Zero-initialize CFA, RA, and FP location
+		 * info, except for the CFA control word, so that
+		 * neither sframe_init_cfa_rule_data() nor
+		 * sframe_init_rule_data() fail.
 		 */
-		cfa_off	= 0;
-		ra_off	= 0;
-		fp_off	= 0;
-		goto done;
-	}
-
-	UNSAFE_GET_USER_INC(cfa_off, cur, dataword_size, Efault);
-	dataword_count--;
-
-	ra_off = sec->ra_off;
-	if (!ra_off && dataword_count) {
-		dataword_count--;
-		UNSAFE_GET_USER_INC(ra_off, cur, dataword_size, Efault);
-	}
+		fre->cfa_ctl	= (SFRAME_REG_SP << 3) | 1; /* regnum=SP, deref_p=0, reg_p=1 */
+		fre->cfa_off	= 0;
+		fre->ra_ctl	= 0;
+		fre->ra_off	= 0;
+		fre->fp_ctl	= 0;
+		fre->fp_off	= 0;
 
-	fp_off = sec->fp_off;
-	if (!fp_off && dataword_count) {
-		dataword_count--;
-		UNSAFE_GET_USER_INC(fp_off, cur, dataword_size, Efault);
+		return 0;
 	}
 
-	if (dataword_count)
-		return -EINVAL;
-
-done:
-	fre->size	= fre_size;
-	fre->ip_off	= ip_off;
-	fre->cfa_off	= cfa_off;
-	fre->ra_off	= ra_off;
-	fre->fp_off	= fp_off;
-	fre->info	= info;
-
-	return 0;
+	return __read_fre_datawords(sec, fde, cur, dataword_count, dataword_size, fre);
 
 Efault:
 	return -EFAULT;
 }
 
-static __always_inline void
+static __always_inline int
 sframe_init_cfa_rule_data(struct unwind_user_cfa_rule_data *cfa_rule_data,
-			  unsigned char fre_info,
-			  s32 offset)
+			  u32 ctlword, s32 offset)
 {
-	if (SFRAME_V3_FRE_CFA_BASE_REG_ID(fre_info) == SFRAME_BASE_REG_FP)
-		cfa_rule_data->rule = UNWIND_USER_CFA_RULE_FP_OFFSET;
-	else
+	bool deref_p = SFRAME_V3_FLEX_FDE_CTRLWORD_DEREF_P(ctlword);
+	bool reg_p = SFRAME_V3_FLEX_FDE_CTRLWORD_REG_P(ctlword);
+	bool reserved_p = SFRAME_V3_FLEX_FDE_CTRLWORD_RESERVED_P(ctlword);
+	unsigned int regnum = SFRAME_V3_FLEX_FDE_CTRLWORD_REGNUM(ctlword);
+
+	if (reserved_p)
+		return -EINVAL;
+
+	/* CFA recovery rule must be register-based */
+	if (!reg_p)
+		return -EINVAL;
+
+	switch (regnum) {
+	case SFRAME_REG_SP:
 		cfa_rule_data->rule = UNWIND_USER_CFA_RULE_SP_OFFSET;
+		break;
+	case SFRAME_REG_FP:
+		cfa_rule_data->rule = UNWIND_USER_CFA_RULE_FP_OFFSET;
+		break;
+	default:
+		cfa_rule_data->rule = UNWIND_USER_CFA_RULE_REG_OFFSET;
+		cfa_rule_data->regnum = regnum;
+	}
+
+	if (deref_p)
+		cfa_rule_data->rule |= UNWIND_USER_RULE_DEREF;
+
 	cfa_rule_data->offset = offset;
+
+	return 0;
 }
 
-static __always_inline void
+static __always_inline int
 sframe_init_rule_data(struct unwind_user_rule_data *rule_data,
-		      s32 offset)
+		      u32 ctlword, s32 offset)
 {
-	if (offset) {
-		rule_data->rule = UNWIND_USER_RULE_CFA_OFFSET_DEREF;
-		rule_data->offset = offset;
-	} else {
+	bool deref_p = SFRAME_V3_FLEX_FDE_CTRLWORD_DEREF_P(ctlword);
+	bool reg_p = SFRAME_V3_FLEX_FDE_CTRLWORD_REG_P(ctlword);
+	bool reserved_p = SFRAME_V3_FLEX_FDE_CTRLWORD_RESERVED_P(ctlword);
+
+	if (!ctlword && !offset) {
 		rule_data->rule = UNWIND_USER_RULE_RETAIN;
+		return 0;
+	}
+
+	if (reserved_p)
+		return -EINVAL;
+
+	if (reg_p) {
+		unsigned int regnum = SFRAME_V3_FLEX_FDE_CTRLWORD_REGNUM(ctlword);
+
+		rule_data->rule = UNWIND_USER_RULE_REG_OFFSET;
+		rule_data->regnum = regnum;
+	} else {
+		rule_data->rule = UNWIND_USER_RULE_CFA_OFFSET;
 	}
+
+	if (deref_p)
+		rule_data->rule |= UNWIND_USER_RULE_DEREF;
+
+	rule_data->offset = offset;
+
+	return 0;
 }
 
 static __always_inline int __find_fre(struct sframe_section *sec,
@@ -321,6 +491,7 @@ static __always_inline int __find_fre(struct sframe_section *sec,
 	bool which = false;
 	unsigned int i;
 	u32 ip_off;
+	int ret;
 
 	ip_off = ip - fde->func_addr;
 
@@ -330,8 +501,6 @@ static __always_inline int __find_fre(struct sframe_section *sec,
 	fre_addr = sec->fres_start + fde->fres_off;
 
 	for (i = 0; i < fde->fres_num; i++) {
-		int ret;
-
 		/*
 		 * Alternate between the two fre_addr[] entries for 'fre' and
 		 * 'prev_fre'.
@@ -358,9 +527,15 @@ static __always_inline int __find_fre(struct sframe_section *sec,
 		return -EINVAL;
 	fre = prev_fre;
 
-	sframe_init_cfa_rule_data(&frame->cfa, fre->info, fre->cfa_off);
-	sframe_init_rule_data(&frame->ra, fre->ra_off);
-	sframe_init_rule_data(&frame->fp, fre->fp_off);
+	ret = sframe_init_cfa_rule_data(&frame->cfa, fre->cfa_ctl, fre->cfa_off);
+	if (ret)
+		return ret;
+	ret = sframe_init_rule_data(&frame->ra, fre->ra_ctl, fre->ra_off);
+	if (ret)
+		return ret;
+	ret = sframe_init_rule_data(&frame->fp, fre->fp_ctl, fre->fp_off);
+	if (ret)
+		return ret;
 	frame->outermost = SFRAME_V3_FRE_RA_UNDEFINED_P(fre->info);
 
 	return 0;
diff --git a/kernel/unwind/sframe.h b/kernel/unwind/sframe.h
index ed111fd0d702..1a2528e4b149 100644
--- a/kernel/unwind/sframe.h
+++ b/kernel/unwind/sframe.h
@@ -66,6 +66,7 @@ struct sframe_fda_v3 {
 #define SFRAME_V3_AARCH64_FDE_PAUTH_KEY(info)	(((info) >> 5) & 0x1)
 
 #define SFRAME_FDE_TYPE_DEFAULT			0
+#define SFRAME_FDE_TYPE_FLEX			1
 
 #define SFRAME_V3_FDE_TYPE_MASK			0x1f
 #define SFRAME_V3_FDE_TYPE(info2)		((info2) & SFRAME_V3_FDE_TYPE_MASK)
@@ -79,4 +80,9 @@ struct sframe_fda_v3 {
 #define SFRAME_V3_AARCH64_FRE_MANGLED_RA_P(info)	(((info) >> 7) & 0x1)
 #define SFRAME_V3_FRE_RA_UNDEFINED_P(info)		(SFRAME_V3_FRE_DATAWORD_COUNT(info) == 0)
 
+#define SFRAME_V3_FLEX_FDE_CTRLWORD_REGNUM(data)	(((data) >> 3) & 0x1f)
+#define SFRAME_V3_FLEX_FDE_CTRLWORD_RESERVED_P(data)	(((data) >> 2) & 0x1)
+#define SFRAME_V3_FLEX_FDE_CTRLWORD_DEREF_P(data)	(((data) >> 1) & 0x1)
+#define SFRAME_V3_FLEX_FDE_CTRLWORD_REG_P(data)		((data) & 0x1)
+
 #endif /* _SFRAME_H */
-- 
2.51.0


