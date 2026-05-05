Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAF61CD3430
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 12:18:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F11436B009B; Tue,  5 May 2026 08:18:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC1DB6B00A1; Tue,  5 May 2026 08:18:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4F966B009B; Tue,  5 May 2026 08:18:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9088D6B009D
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:18:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 025F31C03BA
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:18:15 +0000 (UTC)
X-FDA: 84733268592.24.A5733B0
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4DD2B40012
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:18:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=FttzhKCJ;
	spf=pass (imf11.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777983493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AqkRAL/F99BswCpNXxBkMsZDONc7WSoAsmYzBCMlE/E=;
	b=2h7Ee5T2HtiTGbp2o/rTjgkxV8kMxwQovsL8mThy3mM6zQ1C0FeCCnQ/4k3YJqEl6CDrks
	yzZIvXeSGfU2pX+pRpO/Cn5yf7wBbXq3WVYRFCjKBiaqoQBoq3Y37vGgudoe5DLncag87H
	5s1I3xjtzbOzNIv30KTg+Oo0JgPx4Tg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=FttzhKCJ;
	spf=pass (imf11.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777983493; a=rsa-sha256;
	cv=none;
	b=7YPyV+UMJAMc5sseU4t+KNs6bAWBAH+Pk2pPh6JRswdfCRGJa4tGxghgllFuOM3Wgk2jNs
	07fc6BpFB5odNpCO4XA5oyEL5yHpDLljE9lI+Ge/SgtDA5aHFM0Q1kMU4hWi+7nzBM94i5
	vtNEzqVBvIKFnFyXpVXuQOWf1joN3qw=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 645AF2Us963512;
	Tue, 5 May 2026 12:17:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=AqkRAL/F99BswCpNX
	xBkMsZDONc7WSoAsmYzBCMlE/E=; b=FttzhKCJzAKCa9IJVeIrO713e2CR5igL1
	m2xgyu3IMZul5FMziNKnqvaM61KVxfpbNrXPpK8lsWPsoNkYj6BBwerjikaSxAwr
	WNZw3GAHQqxDYMDO5PoJcZdSAXSDDwMdInDRmTWhF9EXx9QqnV+lrJh+luKjpqhR
	nwz3cGmSRfIPqdlqpQDOGfGL29loe7CM469chD2A5nvSFq5bOBApxRR+7+r6jf6I
	W7bPEPy3XM+LOm8VX6+/u07lbPnLMdwUTleUzCtBGoLfD5Y0Ltt/4kiZejc0xM9Q
	WveBoVVsdWL4Xjg+vct3Uotk8USkYRAsWmi03/61YDrw/PXPAxeyA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9v7bj9v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:32 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 645C9okx028585;
	Tue, 5 May 2026 12:17:31 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dwuyw1m3k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:31 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 645CHRMD57082294
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 May 2026 12:17:27 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 522AE2004B;
	Tue,  5 May 2026 12:17:27 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E23D72004D;
	Tue,  5 May 2026 12:17:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 May 2026 12:17:26 +0000 (GMT)
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
Subject: [PATCH v14 14/19] unwind_user: Flexible FP/RA recovery rules
Date: Tue,  5 May 2026 14:17:13 +0200
Message-ID: <20260505121718.3572346-15-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260505121718.3572346-1-jremus@linux.ibm.com>
References: <20260505121718.3572346-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDExNCBTYWx0ZWRfX0wRCLw1jLLWz
 WDXtsIOYA1bpJRM9NL7n9w+WuJE3fZ0sghrbhXA80rjVn+TJxwyDqef7Tj2AyE9LmEH2kVVRr47
 aCMw4aKhUweeAvX3L/6rG3QJrLAhjiYdyaLCfjWtVXITRmbmY6eOChpe2qhQrUleIdn0abE+8Bk
 oqvin1EOSezmh3pjQrQmPm7dgYcBOHKlkzEjyKVTTQKMV2ucvLi2FbO+aFoKGfNdWsNdD9cziHM
 SGltGgqgvf9vqe8eBhaFlQHENvjhPFOzxvILcWosv1umy2zs2i8QMLI6N9KKFgfjTws5aBuU20Q
 NWGPFM5kRXNH71mPvHhUxCJ/xVIB3Q7p9O6gRO/3+lqqvdP3BPkJlDpmsSHIQ7xrIdn7MyP+bbH
 xww+Ingn9cAHByC3DSCisPcyvZJKxjspMdAbEitTn6VTm0pkFh6pE2PLBiS6+3508WRhVD5QaR8
 lf1PpcLAH5eQoR6sFtw==
X-Proofpoint-GUID: pnR1nFaxQUpyd1FpSrOluPbIAnOgGWMX
X-Proofpoint-ORIG-GUID: YDladW5h7pO8Ko9AlmaJN6qgQyb2EtqC
X-Authority-Analysis: v=2.4 cv=eu/vCIpX c=1 sm=1 tr=0 ts=69f9dfdd cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=GjvnxKKRlEeFsqGDDKkA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605050114
X-Stat-Signature: isj16pife1cz5k9uozaab1ssd6w6d4yo
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4DD2B40012
X-Rspam-User: 
X-HE-Tag: 1777983493-612858
X-HE-Meta: U2FsdGVkX1/RQWZcNt3FW76zBXRg/7y6PeyB318DTN6dNig0IeyuLxTHlC4mVERxalf8h/LnFQsgZbyJAkjok/s4dwPEX0jyKixKB2s0sMplfwCNY+D8T74QmX+Cod1+j+oIUHyn0N8j2E6kUNUVbKhBouWzp+FgB0mGvE8iqdKKFfjCKc0NXOigOJNfMSsrLcMdtDSSQqheDceNZxaI2LjGJ1v7I1aFRy+JYn97nLveN4IhPeu3VFzjO2nVfRr8IJWvoumKu4zvbPWe19cS+hyVCMqbG42XpuzzLUSbVRmhfjCuxKTzWq5/KBG6/9OGAkJ+DbrH2Yrht4d6hHJc+4quHi+nSR4EAGcVC7G5GqK1+CvGo6jh6gn0Zc9sdqyk/efzJhUFfbBz7hI+ARw+fBHxFZHnlekdm7T6F5A4fU+V1F+WYgIO0XCkgqWq7ZP6iNiFWXvhzYsW97yVEqYq6fa9PR3soZ8atzv+O+WpwwMivfiiTpMs6fnp6uuCumaSGC55FMtOw5Nv5+z8sIy3HyvfXL5DfHqFoS2M4a9Yj0rjszobKHUc/xUyPAlT32PrHusA4H5SVcnNl/p/G2vh5eISj1h4BuMFsfW+RzKQWnDBAZx6pkUZdxRPRfAm3UA2obYL0jHzG1n8TW4QWtcGtlRgI0erP6NOGYPzGKOne9E7IduxrWONkJazpeu3hKX0Mby+T677WQSE3uQP1GVsTJVjXd3CnFSqkBvxxlDOJZdwwtN2+QFdQDN6d7ooy54SioQjoUb8CcTkhs1YKRC/gI0njHwwtoz0z7E6mwhB/yABrCtM0fcPNKvh4GCFHzJrZmFsIZEdNzmcR+ynFUsuGK37TuZFD36rmioLFqP76cHP+eD4CA3LxXKCRC0JGbjFjpwZC5d+f8erbUFRPlwUSwIQbOHEEbBZpUurQ9SWRkx/gGqhYAqtli3gr4XyG1Z5RwNm6CPrIVO8uOdjJ9K
 KYqagA+1
 2gcPsm1wmQ4Kse4FG6G0/wVgC98/uLBEFrWC8Hrncm42EPIHpgkYJnqj1wsyBEdF2v3mcox8Lq8UgnBk4BfE/jOtRXRRMZ0yajljQWIN3okcpPi/vEswY0drM7otehqRnueT3QCP+bSelAfahKABFpuUUbohwhzScul1TvjHPqfId3LEEW4BX+5AAJZJntevWBbvQ0xTqVRxsYeQwAk88ksB3OLdoOVpkNJijPDREeAbw7nEDTw8LO2X1WFnz/nVbjLx3EnEwV34HLcy3u7QVEi8f0A==
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
    Changes in v14:
    - Improve comment on why UNWIND_USER_RULE_CFA_OFFSET is not implemented.
      (Mark Rutland)

 arch/x86/include/asm/unwind_user.h | 21 +++++++++---
 include/linux/unwind_user.h        |  9 +++++
 include/linux/unwind_user_types.h  | 23 +++++++++++--
 kernel/unwind/sframe.c             | 16 +++++++--
 kernel/unwind/user.c               | 53 ++++++++++++++++++++++++++----
 5 files changed, 107 insertions(+), 15 deletions(-)

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
index bc2edae39955..92cdf38c8ade 100644
--- a/include/linux/unwind_user.h
+++ b/include/linux/unwind_user.h
@@ -32,6 +32,15 @@ static inline int unwind_user_get_ra_reg(unsigned long *val)
 #define unwind_user_get_ra_reg unwind_user_get_ra_reg
 #endif
 
+#ifndef unwind_user_get_reg
+static inline int unwind_user_get_reg(unsigned long *val, unsigned int regnum)
+{
+	WARN_ON_ONCE(1);
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
index d5e0fa04b99a..cc57804aa3b1 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -271,6 +271,18 @@ static __always_inline int __read_fre(struct sframe_section *sec,
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
@@ -321,8 +333,8 @@ static __always_inline int __find_fre(struct sframe_section *sec,
 	fre = prev_fre;
 
 	frame->cfa_off = fre->cfa_off;
-	frame->ra_off  = fre->ra_off;
-	frame->fp_off  = fre->fp_off;
+	sframe_init_rule_data(&frame->ra, fre->ra_off);
+	sframe_init_rule_data(&frame->fp, fre->fp_off);
 	frame->use_fp  = SFRAME_V3_FRE_CFA_BASE_REG_ID(fre->info) == SFRAME_BASE_REG_FP;
 	frame->outermost = SFRAME_V3_FRE_RA_UNDEFINED_P(fre->info);
 
diff --git a/kernel/unwind/user.c b/kernel/unwind/user.c
index 9ceef9b2b8db..89aecfbe3e84 100644
--- a/kernel/unwind/user.c
+++ b/kernel/unwind/user.c
@@ -61,22 +61,61 @@ static int unwind_user_next_common(struct unwind_user_state *state,
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
+	/*
+	 * UNWIND_USER_RULE_CFA_OFFSET doesn't make sense for RA.
+	 * A return address cannot legitimately be a stack address.
+	 */
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
+	/*
+	 * UNWIND_USER_RULE_CFA_OFFSET is currently not used for FP
+	 * (e.g. SFrame cannot represent this rule).
+	 */
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


