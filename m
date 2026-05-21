Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CA93CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:26:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89C656B00A5; Thu, 21 May 2026 10:26:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 872BF6B00A6; Thu, 21 May 2026 10:26:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69DE26B00A7; Thu, 21 May 2026 10:26:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 56EE36B00A5
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:26:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 252F91612AD
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:34 +0000 (UTC)
X-FDA: 84791652708.14.726E720
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf29.hostedemail.com (Postfix) with ESMTP id DAB0B12000B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=SVNyYgbV;
	spf=pass (imf29.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779373591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SclQrTXePMXj7pOgMrGu5ZG8CuomE2zXQeZd0Yj1oYM=;
	b=gNZ1e1JwccOwZrt89jXr7R6NTJYyM60/OWuOIoU10Uzr11yUAvKrYKE5YReZiPN4VHSGRt
	7ubmDYBJYiKaaNEFIgXOysG+p5NQI2rWS4nlP/uaI3V8fqcUVCTGgGB1ZRSt9ckNz08twj
	uOGVr1C/f2yfvgRoJIb8CotuHATT9xo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=SVNyYgbV;
	spf=pass (imf29.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779373591; a=rsa-sha256;
	cv=none;
	b=MZtIb3tPMwu/9H9QrwNH7d/lygKrV1jMvIt6iZvzlZaHhzoHDKJtBiWTGjWUn883AdwcmG
	53CdLlDTJmZXdjeQGHDEUmWFQNYwlIkloS5yCl0tsLXDnGKDk7OtTH7jmsqSViOr31mnP4
	BOHOKei7Gv2TPKQ3ykhWVCzvZkE2BAo=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64L5oY1Q3690499;
	Thu, 21 May 2026 14:26:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=SclQrTXePMXj7pOgM
	rGu5ZG8CuomE2zXQeZd0Yj1oYM=; b=SVNyYgbVNRYm1RiQnbVu4eZFQazyWqMMA
	5TuKAZxttyNW7eKheijtkk3r7032z3MG87n2ZHgZ1+/UKY5JXaYiXTxvQRJN5vMK
	MeERjEBSF9vGtWBB4CPdw35JafZSBGCsvFPRNrtSLrcaP/iM92ishqCgW7qaon4O
	dxdvMLtMu2/PFOcf49Lo/vSJuTvJGl5IIsQq0vz7sL/lK5vcba4p+AWoiwoAujyh
	VUuyzhOn3PRiLKk7UR/URuuh/h89kIZEt1X3BJlpPZKfddxB2H6T/D0XFg8DbUBy
	bhSX3D4Zg5cd2XwY3UGsDeRUu795LP5H2A21kemizfnL2Bs29ePIg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6hawe82c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:59 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64LEO7SC017127;
	Thu, 21 May 2026 14:25:58 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e73wkcjcx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:58 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64LEPs7B13959524
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 14:25:54 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A330A20040;
	Thu, 21 May 2026 14:25:54 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 453FC20049;
	Thu, 21 May 2026 14:25:54 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 14:25:54 +0000 (GMT)
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
Subject: [PATCH v16 14/20] unwind_user: Flexible FP/RA recovery rules
Date: Thu, 21 May 2026 16:25:40 +0200
Message-ID: <20260521142546.3908498-15-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260521142546.3908498-1-jremus@linux.ibm.com>
References: <20260521142546.3908498-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDE0MiBTYWx0ZWRfX7ZJUSBf+G3UK
 rKmL9YDYxs5kgr1rUEmOtySwt5fGtl4H3LXCqT81sm1MtfXPshvCW8iShgRzRGOmcbzU5TbmSRs
 ypiqn5cqLz+5t882EsSF/RgrA9IWe3qAYJ6Bey1rWWsZaPNcGF99G7ZtdSCFyrmSpiWjzIy8lGP
 xwPnNkk340J8pgifFHmkNHMc8tEwFvYKXzhUKAzFLZeQVijIsMmnQpcODCVLtRE66qEaeZZJyfg
 WHK6mpPltkhvjDp9CqetN7Acy0Utzy+xRLgc1Zcu6HoBXRCwZCFxGN4uZZbuMOfbFN7nyGzMMRk
 LEgQWE1fxvvzENmDwxj//aUmIc7f4iSWgFHVbukQ9J8r7x3fPiTUDFv3I1ybZ3MjyGzxWquVF6T
 LWsRxxV37be2QFffthDOvSdgAd9sw+qksVN8GQ9EWw6v+90nAcuEOfni783XRWa8JjfK70u2HWZ
 UT9yZOKMy2FjzDAdiXg==
X-Authority-Analysis: v=2.4 cv=Np/htcdJ c=1 sm=1 tr=0 ts=6a0f15f7 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=-jr7Rsxdtpxs5_a9E3IA:9
X-Proofpoint-ORIG-GUID: kfl3y-ieUDsfAhXe2KpIVQTdWdSUw17V
X-Proofpoint-GUID: Q1sNHVN-26xTnZgcdTlOZrfmCnml6aRf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210142
X-Rspamd-Queue-Id: DAB0B12000B
X-Stat-Signature: fh3tfn8jkdznthm3ywon63r6ue846344
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779373591-620024
X-HE-Meta: U2FsdGVkX18A7qL94GwdpIKk1n8OQQj7F0xijDB+3HEnykGo8Is6efTLfRzjZB2C4loes2BzFMKmDDmt+ot5EZjtjgoRU52fvxBfG2w0P8rZe131OLQXufJJaKQLqaBgrGFDyfiBUI5aBz8O3K4/3k2IwY/a+x9FtOKSE0E7KQuh3T3wrUIMjNGyx2qT4FMt0TYRh/XcUVHRaFsqc4cdNepIXjS8hPLR4O1WwymOrpQXZZrGvlmtdoM7kIjjDZ1x2VYXdkiK5J4ObLguygxVBmCJykzMGJlP9ZgLJuaYa3Kod7fzMTI72PYpKft7foRtxSC4I7Unab+0d0aeS4LUEK4ojWLGn4GVRyrKsHtdr+7MTJukSyqQpCOaly/oPml0D4g2a7XN8rmuQk1D/u97nu3hfZzhtSox/8XW+MP89AgpwfnJRWo2wHHeBRGHWwUK6dP0eb9xoWU8skQaebV+yC+cP2CjTiee9nJ9frf0rGLqf23e6WtZQcw7Kv2JQ0zTRQIPd+pCVdDRrCn9qfgoh9J908plByP4gXPtnRwWVyVL/SKOzsBmNnsUb/ZOTf014m8n3TkaXEIWyihwhFn0Hgk2W6RmyZNRsbG8603ysBRYKrcl9sRY72I6/U1wgAZcCKnZ2LCOSJxJlfq6HwD5vm7KcDZbBUlRGys8x6hqPDKyO/4c/svXZ7tadnUmoZVwZOFjtQ3AAM89qNBzXBH3iZlKFMVdk91+w2UIJyz441CjGpQHVetRBaSZ+1S7d8niEcIjozQc3+Z4burfgImxRN9Fa2NFGTGvtv+LrS0C6ZN7lm53cwItN8i8LON6GlHEi+U+LKr+nnCJay5uu1OqgsBuJD95CniLueHTv0jqQDVNeEoSD0hLYSn40n/AWu348JiVaM58XQWc57AJWEYSrHxsFqv7PzthwDxUVKDmHctXKWEDROd222o10o0KTRFPbBWwEVqUh+4FK2iGpVS
 z15gEDhL
 L9WGmzg/qakdCpam8p9wnwGhwCf4YOUzxeGeM9mwGYYmNLMxpj1fOMnatFjtwUtqJw8wnLXTYsFZVp4J+NoN8ybJiiSJzgKAW828QFu420xV92sGpdSIEDreKo+Ic9BrL9pVBS4DKezaMhcyaKVTJmtRn4/weXeJzlSRiZIrNDHuP6Wte8olJLSRtqZezH9A/hOcJg8kxNTUZeEj1Mger58K03z+Rn0UgKIqg48oYggscajupLctSWAAAeaWfOyF874UYJxeMZq4gqWpFrur76PiQlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To enable support for SFrame V3 flexible FDEs with a subsequent patch,
add support for the following flexible frame pointer (FP) and return
address (RA) recovery rules:

  FP/RA = *(CFA + offset)
  FP/RA = register + offset
  FP/RA = *(register + offset)

Note that FP/RA recovery rules that use arbitrary register contents are
only valid when in the topmost frame, as their contents are otherwise
unknown.

This also enables unwinding of user space for architectures, such as
s390, that may save the frame pointer (FP) and/or return address (RA) in
other registers, for instance when in a leaf function.

Reviewed-by: Indu Bhagat <ibhagatgnu@gmail.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    Changes in v15:
    - Define dbg_once().
    - unwind_user_get_reg(): Use pr_debug_once() instead of WARN_ON_ONCE()
      to prevent user-triggered warning/panic. (Sashiko AI)
    - unwind_user_next_common(): Handle UNWIND_USER_RULE_CFA_OFFSET for RA
      and FP to use dbg_once() instead of WARN_ON_ONCE() to prevent user-
      triggered warning/panic. (Sashiko AI)
    
    Changes in v14:
    - Improve comment on why UNWIND_USER_RULE_CFA_OFFSET is not implemented.
      (Mark Rutland)

 arch/x86/include/asm/unwind_user.h | 21 +++++++--
 include/linux/unwind_user.h        | 10 +++++
 include/linux/unwind_user_types.h  | 23 +++++++++-
 kernel/unwind/sframe.c             | 16 ++++++-
 kernel/unwind/user.c               | 70 +++++++++++++++++++++++++++---
 5 files changed, 125 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/unwind_user.h b/arch/x86/include/asm/unwind_user.h
index 2dfb5ef11e36..9c3417be4283 100644
--- a/arch/x86/include/asm/unwind_user.h
+++ b/arch/x86/include/asm/unwind_user.h
@@ -21,15 +21,26 @@ static inline int unwind_user_word_size(struct pt_regs *regs)
 
 #define ARCH_INIT_USER_FP_FRAME(ws)			\
 	.cfa_off	=  2*(ws),			\
-	.ra_off		= -1*(ws),			\
-	.fp_off		= -2*(ws),			\
+	.ra		= {				\
+		.rule		= UNWIND_USER_RULE_CFA_OFFSET_DEREF,\
+		.offset		= -1*(ws),		\
+			},				\
+	.fp		= {				\
+		.rule		= UNWIND_USER_RULE_CFA_OFFSET_DEREF,\
+		.offset		= -2*(ws),		\
+			},				\
 	.use_fp		= true,				\
 	.outermost	= false,
 
 #define ARCH_INIT_USER_FP_ENTRY_FRAME(ws)		\
 	.cfa_off	=  1*(ws),			\
-	.ra_off		= -1*(ws),			\
-	.fp_off		= 0,				\
+	.ra		= {				\
+		.rule		= UNWIND_USER_RULE_CFA_OFFSET_DEREF,\
+		.offset		= -1*(ws),		\
+			},				\
+	.fp		= {				\
+		.rule		= UNWIND_USER_RULE_RETAIN,\
+			},				\
 	.use_fp		= false,			\
 	.outermost	= false,
 
@@ -41,4 +52,6 @@ static inline bool unwind_user_at_function_start(struct pt_regs *regs)
 
 #endif /* CONFIG_HAVE_UNWIND_USER_FP */
 
+#include <asm-generic/unwind_user.h>
+
 #endif /* _ASM_X86_UNWIND_USER_H */
diff --git a/include/linux/unwind_user.h b/include/linux/unwind_user.h
index 7bf58f23aa64..6aca38f89ddd 100644
--- a/include/linux/unwind_user.h
+++ b/include/linux/unwind_user.h
@@ -33,6 +33,16 @@ static inline int unwind_user_get_ra_reg(unsigned long *val)
 #define unwind_user_get_ra_reg unwind_user_get_ra_reg
 #endif
 
+#ifndef unwind_user_get_reg
+static inline int unwind_user_get_reg(unsigned long *val, unsigned int regnum)
+{
+	pr_debug_once("%s (%d): unwind_user_get_reg(%u) not implemented\n",
+		      current->comm, current->pid, regnum);
+	return -EINVAL;
+}
+#define unwind_user_get_reg unwind_user_get_reg
+#endif
+
 int unwind_user(struct unwind_stacktrace *trace, unsigned int max_entries);
 
 #endif /* _LINUX_UNWIND_USER_H */
diff --git a/include/linux/unwind_user_types.h b/include/linux/unwind_user_types.h
index 616cc5ee4586..0d02714a1b5d 100644
--- a/include/linux/unwind_user_types.h
+++ b/include/linux/unwind_user_types.h
@@ -27,10 +27,29 @@ struct unwind_stacktrace {
 	unsigned long	*entries;
 };
 
+#define UNWIND_USER_RULE_DEREF			BIT(31)
+
+enum unwind_user_rule {
+	UNWIND_USER_RULE_RETAIN,		/* entity = entity */
+	UNWIND_USER_RULE_CFA_OFFSET,		/* entity = CFA + offset */
+	UNWIND_USER_RULE_REG_OFFSET,		/* entity = register + offset */
+	/* DEREF variants */
+	UNWIND_USER_RULE_CFA_OFFSET_DEREF =	/* entity = *(CFA + offset) */
+		UNWIND_USER_RULE_CFA_OFFSET | UNWIND_USER_RULE_DEREF,
+	UNWIND_USER_RULE_REG_OFFSET_DEREF =	/* entity = *(register + offset) */
+		UNWIND_USER_RULE_REG_OFFSET | UNWIND_USER_RULE_DEREF,
+};
+
+struct unwind_user_rule_data {
+	enum unwind_user_rule rule;
+	s32 offset;
+	unsigned int regnum;
+};
+
 struct unwind_user_frame {
 	s32 cfa_off;
-	s32 ra_off;
-	s32 fp_off;
+	struct unwind_user_rule_data ra;
+	struct unwind_user_rule_data fp;
 	bool use_fp;
 	bool outermost;
 };
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index d573c2529926..29a874a67f32 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -285,6 +285,18 @@ static __always_inline int __read_fre(struct sframe_section *sec,
 	return -EFAULT;
 }
 
+static __always_inline void
+sframe_init_rule_data(struct unwind_user_rule_data *rule_data,
+		      s32 offset)
+{
+	if (offset) {
+		rule_data->rule = UNWIND_USER_RULE_CFA_OFFSET_DEREF;
+		rule_data->offset = offset;
+	} else {
+		rule_data->rule = UNWIND_USER_RULE_RETAIN;
+	}
+}
+
 static __always_inline int __find_fre(struct sframe_section *sec,
 				      struct sframe_fde_internal *fde,
 				      unsigned long ip,
@@ -335,8 +347,8 @@ static __always_inline int __find_fre(struct sframe_section *sec,
 	fre = prev_fre;
 
 	frame->cfa_off = fre->cfa_off;
-	frame->ra_off  = fre->ra_off;
-	frame->fp_off  = fre->fp_off;
+	sframe_init_rule_data(&frame->ra, fre->ra_off);
+	sframe_init_rule_data(&frame->fp, fre->fp_off);
 	frame->use_fp  = SFRAME_V3_FRE_CFA_BASE_REG_ID(fre->info) == SFRAME_BASE_REG_FP;
 	frame->outermost = SFRAME_V3_FRE_RA_UNDEFINED_P(fre->info);
 
diff --git a/kernel/unwind/user.c b/kernel/unwind/user.c
index afa7c6f6d9b4..c6a2abac78e0 100644
--- a/kernel/unwind/user.c
+++ b/kernel/unwind/user.c
@@ -12,6 +12,17 @@
 #include <linux/uaccess.h>
 #include <linux/sframe.h>
 
+#ifdef CONFIG_DYNAMIC_DEBUG
+
+#define dbg_once(fmt, ...)							\
+	pr_debug_once("%s (%d): " fmt, current->comm, current->pid, ##__VA_ARGS__)
+
+#else /* !CONFIG_DYNAMIC_DEBUG */
+
+#define dbg_once(args...)		no_printk(args)
+
+#endif /* !CONFIG_DYNAMIC_DEBUG */
+
 #define for_each_user_frame(state) \
 	for (unwind_user_start(state); !(state)->done; unwind_user_next(state))
 
@@ -64,22 +75,67 @@ static int unwind_user_next_common(struct unwind_user_state *state,
 		return -EINVAL;
 
 	/* Get the Return Address (RA) */
-	if (frame->ra_off) {
-		if (get_user_word(&ra, cfa, frame->ra_off, state->ws))
-			return -EINVAL;
-	} else {
+	switch (frame->ra.rule) {
+	case UNWIND_USER_RULE_RETAIN:
 		if (!state->topmost || unwind_user_get_ra_reg(&ra))
 			return -EINVAL;
+		break;
+	case UNWIND_USER_RULE_CFA_OFFSET:
+		/*
+		 * RA = CFA + offset does not make sense.
+		 * A return address cannot legitimately be a stack address.
+		 */
+		dbg_once("UNWIND_USER_RULE_CFA_OFFSET invalid for RA\n");
+		return -EINVAL;
+	case UNWIND_USER_RULE_CFA_OFFSET_DEREF:
+		ra = cfa + frame->ra.offset;
+		break;
+	case UNWIND_USER_RULE_REG_OFFSET:
+	case UNWIND_USER_RULE_REG_OFFSET_DEREF:
+		if (!state->topmost || unwind_user_get_reg(&ra, frame->ra.regnum))
+			return -EINVAL;
+		ra += frame->ra.offset;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return -EINVAL;
 	}
+	if (frame->ra.rule & UNWIND_USER_RULE_DEREF &&
+	    get_user_word(&ra, ra, 0, state->ws))
+		return -EINVAL;
 
 	/* Get the Frame Pointer (FP) */
-	if (frame->fp_off && get_user_word(&fp, cfa, frame->fp_off, state->ws))
+	switch (frame->fp.rule) {
+	case UNWIND_USER_RULE_RETAIN:
+		fp = state->fp;
+		break;
+	case UNWIND_USER_RULE_CFA_OFFSET:
+		/*
+		 * FP = CFA + offset is currently not used for FP
+		 * (e.g. SFrame cannot represent this rule).
+		 */
+		dbg_once("UNWIND_USER_RULE_CFA_OFFSET unsupported for FP\n");
+		return -EINVAL;
+	case UNWIND_USER_RULE_CFA_OFFSET_DEREF:
+		fp = cfa + frame->fp.offset;
+		break;
+	case UNWIND_USER_RULE_REG_OFFSET:
+	case UNWIND_USER_RULE_REG_OFFSET_DEREF:
+		if (!state->topmost || unwind_user_get_reg(&fp, frame->fp.regnum))
+			return -EINVAL;
+		fp += frame->fp.offset;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
+	if (frame->fp.rule & UNWIND_USER_RULE_DEREF &&
+	    get_user_word(&fp, fp, 0, state->ws))
 		return -EINVAL;
 
 	state->ip = ra;
 	state->sp = cfa;
-	if (frame->fp_off)
-		state->fp = fp;
+	state->fp = fp;
 	state->topmost = false;
 	return 0;
 }
-- 
2.51.0


