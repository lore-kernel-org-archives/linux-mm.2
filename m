Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEE3DFF885A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 12:26:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46E356B0092; Tue,  5 May 2026 08:26:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4467F6B0093; Tue,  5 May 2026 08:26:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3353C6B00A2; Tue,  5 May 2026 08:26:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 219396B0092
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:26:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5D46F1A049B
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:26:13 +0000 (UTC)
X-FDA: 84733288626.24.42F1215
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf27.hostedemail.com (Postfix) with ESMTP id F17B740014
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:26:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=nWBecXxG;
	spf=pass (imf27.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777983971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VkinFh3ULMyOyQWo1OXTyMS3O4RxPLnkiDcpQ3dnu0Y=;
	b=kyMkK+SPsuILon5jLHiTUTBvPXonfbgm/mrMW8cTPiGm4o2h3Ie/hD75XynmVGMNdLEhSO
	7BQ8Sy31cFSt35WiQFX3O3/2I6iiusAM/ShaPlSIeHzzE4JnN5k1kuwZSoJrosWeorA/7R
	LCdtatw+XYapnKBkKNeLNDm7Nj6tVoU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777983971; a=rsa-sha256;
	cv=none;
	b=W+DWal5bRXeIqMhkdhpIrtD06+QRIYly7HpI2ZkUx+JkC8H/X5hdh5RkJwNBJouOy/rkiO
	aTdwyLhLSaokIONNXBYU3YsI3vbIk/CDywzRWWe1DFav1VRQ6G3aWfgBfVZA995OHGb8AS
	kZyzGbnZ2wO3mRCf9vyfw8zwGlh45dc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=nWBecXxG;
	spf=pass (imf27.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64574GDf2528070;
	Tue, 5 May 2026 12:17:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=VkinFh3ULMyOyQWo1
	OXTyMS3O4RxPLnkiDcpQ3dnu0Y=; b=nWBecXxGAZ93Xe86FMeSp+miHcB03YbjM
	pAY4ZUCvKRqh/qobTMmS9qLlb446aclNCarNHHaj8TSxixqcHpMvdow5TiAJCJcT
	fifjBIBmULq4KpCj/XKbKg3YQ3Qo8X7bMFHRuVhshMO96cB2p85MvukVjTOiTk40
	hQ76MUCvLhU4fVADC2Kf2F5zLxEwYUx11Zt00yHgaxSjYZvWObpMVo/9mfyIYXiS
	5SyjCoX5zzSp5rFmCGi2MLyokgz9DHEvavGIsFbK6FVZ/SxZ9Tq5OjfLMl5hwIot
	34yfQM8yoyb30DBd2LxgO8QvITJ9afT6c8+fOSmHpSeIdAiePq4fA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9x4kg6e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:32 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 645C9bkE015131;
	Tue, 5 May 2026 12:17:31 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dwx9y98g7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:31 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 645CHSKK10027278
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 May 2026 12:17:28 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2BCB52004B;
	Tue,  5 May 2026 12:17:28 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BA3272004F;
	Tue,  5 May 2026 12:17:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 May 2026 12:17:27 +0000 (GMT)
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
Subject: [PATCH v14 16/19] unwind_user/sframe: Add support for SFrame V3 flexible FDEs
Date: Tue,  5 May 2026 14:17:15 +0200
Message-ID: <20260505121718.3572346-17-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260505121718.3572346-1-jremus@linux.ibm.com>
References: <20260505121718.3572346-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDExNCBTYWx0ZWRfXw1JUsrtXLcEO
 5bcM1Q7udRjDWwGepeK0RB3c0qjwS8qnaTKVR9OikaA7nc4fRVnhBinLOx9pZ6vPt/JmSi/cU6V
 6EY+WmT2SKJWdJCbWD2Ycob56TM2lsvAtCiOcPTsGw5LOruS7dOQpCJAfvyOJndOP8wCnZ9Er1a
 b1jCCSBCF6faGFdFWK6ZJjiGfJCPrivJI/Ii080VezpuNQQncdHMqH2sKlgHzVTjr5M/PEYqiv0
 LAyyYyZbzTtZmdVNlRLsDWr9/2kWucVfUbGcYLkBLc3sCGt+DwlC4J27kiKAD220Iw/iChX6rfi
 jse/xD3Bh5bttPnAZtRNAtKrlNZYnUadY1KFSeuJs+GSiEHuDnKx9dT+jqCcYdP6XqPbVlf2lwa
 cz/YdM9TCrzWwqTebPzG5d3DPiQkF4TLFRurdqP97g9SACIrMX9F0aRGW+fQBHZOIndD1Lb9qx5
 3G4cuEVKT7UafGmrRYA==
X-Proofpoint-ORIG-GUID: y9NN_JPVPXZ7jhSJxQB-Eap1PJ7jnP8-
X-Proofpoint-GUID: dnK4MdIAv32awsP0hR-w9A4NtvC2OvG1
X-Authority-Analysis: v=2.4 cv=W7UIkxWk c=1 sm=1 tr=0 ts=69f9dfdd cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=meVymXHHAAAA:8 a=2wkDFiw1nnRQRUo0YT0A:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 spamscore=0 clxscore=1011 phishscore=0 bulkscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2605050114
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F17B740014
X-Rspam-User: 
X-Stat-Signature: 5icpbt77nfu6w4qd9wtfi6c7ahkbr5ua
X-HE-Tag: 1777983970-524493
X-HE-Meta: U2FsdGVkX190W7b+hpg3lEDK/3oWJ9GV8Rp1C94jkwLYqW2yHwvcywdWUsGyeBLF2EmJjdclFEh5AsLmtHOjbWbzjj48NjcbKlO8ZOw4pCb+uTFaWkHb+8Dwi28KI5LY3Fu8RMSqisxmkhItm/uqD8AvdyAx1FxDzIiey1Jl5IxsCTyCTgre6ODKV3X3o++egXmdoAUJgl8Ldnie39t2gzfm9/6C14zmd0vAD4dvgI8RjIe4hsHXvs4GF+ZTkhDwbU8cUJ9SYr1vn1kE/B7Qul3Ol6sIM9FRw8nWH6snH2VZTCu/trGL8n6Wo1F5Ol6lffDbZduHCTIjQoHgrSmq7dYeVxwfO/MKwnxAXRqdVNiilqLEQBC9NH7Jq5zxso8BE1PaC0hKFMHWRCPe+ZPieGw7u7yKTSSAhsN3kTW0sSnBwAIQJezcZor1ecdFZfAwGxSz72m3DGtCEALm/sbTmYd4pU9JhW1C4ZRgKnK8QB7AjsfVv0zi5SdEbFVpKEzwNOWDcnnDoibb0iPPGzCmGJKFkK5y8ln5Oqvxul0dWjXE9nHM6deb16Bt+JHM+iVuI8Ti3yZeTCmJHPz241/XDCfBQIRcZ50Ila9GGlrBGMK5g3bD5hMu09/gjliyo1JYYY+xa7qLYYy3n/3MMKrRpjmazBDn/waFTrpv4Dzz21T8o3NT/fXtAC9Pq1+I9g3Q8v4048mzSBlIqRUy7m+TvgPrRiwxIdZpccFn/lcVWfaPlqOY71wB6PI/ZEkeEb6uSZ59wHStgtLc0ZMI1sYWj3drjdsgi8xYG2PcnKPDtjpKbmfpt+HHLv++cC7p8gTUl66nhkzNncJMbm+K3xa8jbi7+4Zu5PkB0aFeEwB6vbD4004v9rAuo2NPjU1eOndiGGBA7+Rj2Yz4CE5qnjn2csxAcHA0l+L3Y9dUoALtffqFUnwL0/klLov2zhwcWAPDJyT2DGIn8RMJiQ4HYZ/
 7bQC2QO6
 WzFSsi31DBMon1vW40+WiJSrkLISk1vmLJad6E+Iy+EsuumgCX1qigTrNoEdaAFyoeXX6heIPiq0UIeJ7ARdpR4MhkwoHfkHdpDKvXnFCo6KDIRwMgoixwxsk59W/oepRN6rvxbI96li/1RgrOYDIxnB1GYm36VB0JVZS3j7FTLJ/+dDNa+LsIgrpO+x19CPVMZ8u575Bt3EuNg31DYs+FCZX6hTNLVNR72Jdf2IYtqTKGONNUtc2v3k+xjGHAK5tLV+0i1rw4KJbWOICxGLiEBhFEA5XSvBdhW7GM3a5iyV3diIPDgDJi+hQiJAh2yvxjPZ288yIPsdu4/OVuOlctceCxFJj3HK7Swx+zkZBvBHEo9csoxF6ykPnbn+UBx933ZXUXgNQGMPIDCiVwOa1l1GM1du7nCqHH7C05Xl+YsQR8/I6wbjlfNXZ63bPFyrFnMkb
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
 kernel/unwind/sframe.c | 249 ++++++++++++++++++++++++++++++++---------
 kernel/unwind/sframe.h |   5 +
 3 files changed, 205 insertions(+), 50 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 24d1fe93ff4a..6812f581d44b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27863,6 +27863,7 @@ M:	Josh Poimboeuf <jpoimboe@kernel.org>
 M:	Steven Rostedt <rostedt@goodmis.org>
 S:	Maintained
 F:	arch/*/include/asm/unwind_user.h
+F:	arch/*/include/asm/unwind_user_sframe.h
 F:	include/asm-generic/unwind_user.h
 F:	include/linux/sframe.h
 F:	include/linux/unwind*.h
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index 2721f4af53fd..2ba2c8b385f9 100644
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
@@ -189,16 +193,147 @@ static __always_inline int __find_fde(struct sframe_section *sec,
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
+		return -EFAULT;
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
+		return -EFAULT;
+	UNSAFE_GET_USER_INC(cfa_ctl, cur, dataword_size, Efault);
+	UNSAFE_GET_USER_INC(cfa_off, cur, dataword_size, Efault);
+	dataword_count -= 2;
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
+	if (dataword_count)
+		return -EFAULT;
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
+		return -EFAULT;
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
 	u32 ip_off;
@@ -224,75 +359,88 @@ static __always_inline int __read_fre(struct sframe_section *sec,
 	if (cur + (dataword_count * dataword_size) > sec->fres_end)
 		return -EFAULT;
 
-	/* TODO: Support for flexible FDEs not implemented yet. */
-	if (fde_type != SFRAME_FDE_TYPE_DEFAULT)
-		return -EFAULT;
+	fre->size	= addr_size + 1 + (dataword_count * dataword_size);
+	fre->ip_off	= ip_off;
+	fre->info	= info;
 
 	if (!dataword_count) {
 		/*
 		 * A FRE without data words indicates RA undefined /
 		 * outermost frame.
 		 */
-		cfa_off	= 0;
-		ra_off	= 0;
-		fp_off	= 0;
-		goto done;
-	}
+		fre->cfa_ctl	= 0;
+		fre->cfa_off	= 0;
+		fre->ra_ctl	= 0;
+		fre->ra_off	= 0;
+		fre->fp_ctl	= 0;
+		fre->fp_off	= 0;
 
-	UNSAFE_GET_USER_INC(cfa_off, cur, dataword_size, Efault);
-	dataword_count--;
-
-	ra_off = sec->ra_off;
-	if (!ra_off && dataword_count) {
-		dataword_count--;
-		UNSAFE_GET_USER_INC(ra_off, cur, dataword_size, Efault);
-	}
-
-	fp_off = sec->fp_off;
-	if (!fp_off && dataword_count) {
-		dataword_count--;
-		UNSAFE_GET_USER_INC(fp_off, cur, dataword_size, Efault);
+		return 0;
 	}
 
-	if (dataword_count)
-		return -EFAULT;
-
-done:
-	fre->size	= addr_size + 1 + (dataword_count * dataword_size);
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
-		cfa_rule_data->rule = UNWIND_USER_CFA_RULE_SP_OFFSET;
+	bool deref_p = SFRAME_V3_FLEX_FDE_CTRLWORD_DEREF_P(ctlword);
+	bool reg_p = SFRAME_V3_FLEX_FDE_CTRLWORD_REG_P(ctlword);
+
+	if (reg_p) {
+		unsigned int regnum = SFRAME_V3_FLEX_FDE_CTRLWORD_REGNUM(ctlword);
+
+		switch (regnum) {
+		case SFRAME_REG_SP:
+			cfa_rule_data->rule = UNWIND_USER_CFA_RULE_SP_OFFSET;
+			break;
+		case SFRAME_REG_FP:
+			cfa_rule_data->rule = UNWIND_USER_CFA_RULE_FP_OFFSET;
+			break;
+		default:
+			cfa_rule_data->rule = UNWIND_USER_CFA_RULE_REG_OFFSET;
+			cfa_rule_data->regnum = regnum;
+		}
+	} else {
+		return -EINVAL;
+	}
+
+	if (deref_p)
+		cfa_rule_data->rule |= UNWIND_USER_RULE_DEREF;
+
 	cfa_rule_data->offset = offset;
+
+	return 0;
 }
 
 static __always_inline void
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
+
+	if (!ctlword && !offset) {
 		rule_data->rule = UNWIND_USER_RULE_RETAIN;
+		return;
+	}
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
 }
 
 static __always_inline int __find_fre(struct sframe_section *sec,
@@ -344,9 +492,10 @@ static __always_inline int __find_fre(struct sframe_section *sec,
 		return -EINVAL;
 	fre = prev_fre;
 
-	sframe_init_cfa_rule_data(&frame->cfa, fre->info, fre->cfa_off);
-	sframe_init_rule_data(&frame->ra, fre->ra_off);
-	sframe_init_rule_data(&frame->fp, fre->fp_off);
+	if (sframe_init_cfa_rule_data(&frame->cfa, fre->cfa_ctl, fre->cfa_off))
+		return -EINVAL;
+	sframe_init_rule_data(&frame->ra, fre->ra_ctl, fre->ra_off);
+	sframe_init_rule_data(&frame->fp, fre->fp_ctl, fre->fp_off);
 	frame->outermost = SFRAME_V3_FRE_RA_UNDEFINED_P(fre->info);
 
 	return 0;
diff --git a/kernel/unwind/sframe.h b/kernel/unwind/sframe.h
index ed111fd0d702..add62ba2c0a6 100644
--- a/kernel/unwind/sframe.h
+++ b/kernel/unwind/sframe.h
@@ -66,6 +66,7 @@ struct sframe_fda_v3 {
 #define SFRAME_V3_AARCH64_FDE_PAUTH_KEY(info)	(((info) >> 5) & 0x1)
 
 #define SFRAME_FDE_TYPE_DEFAULT			0
+#define SFRAME_FDE_TYPE_FLEX			1
 
 #define SFRAME_V3_FDE_TYPE_MASK			0x1f
 #define SFRAME_V3_FDE_TYPE(info2)		((info2) & SFRAME_V3_FDE_TYPE_MASK)
@@ -79,4 +80,8 @@ struct sframe_fda_v3 {
 #define SFRAME_V3_AARCH64_FRE_MANGLED_RA_P(info)	(((info) >> 7) & 0x1)
 #define SFRAME_V3_FRE_RA_UNDEFINED_P(info)		(SFRAME_V3_FRE_DATAWORD_COUNT(info) == 0)
 
+#define SFRAME_V3_FLEX_FDE_CTRLWORD_REGNUM(data)	(((data) >> 3) & 0x1f)
+#define SFRAME_V3_FLEX_FDE_CTRLWORD_DEREF_P(data)	(((data) >> 1) & 0x1)
+#define SFRAME_V3_FLEX_FDE_CTRLWORD_REG_P(data)		((data) & 0x1)
+
 #endif /* _SFRAME_H */
-- 
2.51.0


