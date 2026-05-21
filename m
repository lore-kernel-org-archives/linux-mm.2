Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A9F1CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:26:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58DE06B00A2; Thu, 21 May 2026 10:26:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 564E76B00A3; Thu, 21 May 2026 10:26:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47AF76B00A4; Thu, 21 May 2026 10:26:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 37D646B00A2
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:26:21 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 05C811A0652
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:21 +0000 (UTC)
X-FDA: 84791652162.22.9F3ED58
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf31.hostedemail.com (Postfix) with ESMTP id A66912000C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:18 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=qnijCFYT;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf31.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779373578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MtnVctqCs7YoKq/MwD8B6NDfS4Kt/fyB5yJ2+IDDGco=;
	b=nV9S1ab3OMXzrytVDqOCZekpp5sP42WkgJBStYKPZGIPgOiumTlSu68xh7VnKcQy0D/c0T
	/Q3u+W9IY5N9mslqRaV8MQxqEiqsXv11vMnwWY5G0ocSLg7tBEJMQ/jIonutRno9pxc6wD
	lGpTQKbkwv2NbOWAlJwE7he+82pw8xA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779373578; a=rsa-sha256;
	cv=none;
	b=WoKOWoEGGFQb3Pb7Ylev5lpY5ZC8v6a+omYHv8u3sKwETKXVm4jmD7r8McbaG8Bq6wUcKV
	ff18+j0gaST7ri3Gd94aWu+xs6YxXVV8jLr54Ze82LaqUBumpPnkL33xlZYvOmgDKaLPx8
	zsZIE2L4iw2PrzJzvCGN5aStqsI/Y7g=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=qnijCFYT;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf31.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64L3WRtY3952986;
	Thu, 21 May 2026 14:26:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=MtnVctqCs7YoKq/Mw
	D8B6NDfS4Kt/fyB5yJ2+IDDGco=; b=qnijCFYT0JL+d8HnxNf9t8ZlQAxhk7L6k
	J+flA3rmfhq/uqxsTHz94h5il9Fx6mtk0/kh09W3Vo+nhmRBNuGs2D72mjvE/pGR
	yrxqhkkiZMYg6QulApK7pW1pgdNqClP1l3pvAr1gAiSMkGLysJncNHt7WpYe3Tjh
	j323k6JjGTswHC7H91TqpVYuZtxHGR+b+MuVoPZQ+ummkaGAw73pE7oT8XSSYEHH
	IBt2vSh453hmjLetJS3jdG2u87NJfo2SEFlE10OyXB3A8UsG/+Uu22ZXvFSUtkku
	WSCzJtOn+9WsunNjn7qUg3ThKY5JbkCWCwUxqUPj2XgWpwiuulnPg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h9y7gry-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:26:01 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64LEOBZh006250;
	Thu, 21 May 2026 14:26:00 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e75kyc9ty-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:26:00 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64LEPuaE31195492
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 14:25:56 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A796120040;
	Thu, 21 May 2026 14:25:56 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 50B7A2004B;
	Thu, 21 May 2026 14:25:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 14:25:56 +0000 (GMT)
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
        Ilya Leoshkevich <iii@linux.ibm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v16 19/20] unwind_user/sframe/x86: Enable sframe unwinding on x86
Date: Thu, 21 May 2026 16:25:45 +0200
Message-ID: <20260521142546.3908498-20-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260521142546.3908498-1-jremus@linux.ibm.com>
References: <20260521142546.3908498-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDE0MiBTYWx0ZWRfX3aaks8cGjNm/
 ++Hr5s8xN4Bi/HcgSMZbVJDia2CFlHihPXcLfrpysBicMwvkgv01mTsG+AguXD6KQppz+xCCvWD
 Lsavazdi0eqA0ubzOXDk6vokeV0DpL0BRgTFmkoXmbfwIPDfcaG+CsP/7LNa4hrPFQVDtVZtFTp
 AR6lb4Ac3IOIOG0chZ0bKa4CtpPKu4kegP/N1OUNrhS9W8JKrHQ+4+oZHRF8BNj1ob6eRpRfgNI
 629nlNETdm0RE1tyF2zpUF2XOKM2LIMrozNNjecbL1yldZweTpso4I8imUxAzv0xX9lbGnd8tw8
 UQCwmRqu/Vfj1s6g2kl8TVo7yEWkEH7T6ggR3amhuPdh/DcwtHgwtKt1xMMX2X1LpEMyDSWiZBf
 Vmm7DIQ5aR5rj2Huw54rqaS/p70JkuJYhir1ZpxKNcyFTiWp75ZNVgnPK8SOiEe0TN4+ExKxCPs
 7zC8v33/3avKxWQLtwA==
X-Authority-Analysis: v=2.4 cv=BNuDalQG c=1 sm=1 tr=0 ts=6a0f15f9 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=BJDwMle8H-fvePKCLUUA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-ORIG-GUID: yzX4j4RwPWUINlwMZXvrPIwazG-uPnkZ
X-Proofpoint-GUID: ImyEabwoZ1xRcpTYbu_y2YOmZgnpuTgb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210142
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A66912000C
X-Stat-Signature: c4e7cksctofdoi1d5ys96f7b7fmrn79y
X-Rspam-User: 
X-HE-Tag: 1779373578-160571
X-HE-Meta: U2FsdGVkX19bs5EO15Hgu8H2iLSr7avYi6bZq3SH2ZKisXEaqNzwyxRHTrt1tKpZrf4FrRUgpWfHLDtM66t5BUL454wbma0IYS/C9PWjqEXSe8RH7u9Tu1Lug0wilp1DSN1avjh2Es2L9MCJQPhHc07LDdiSUxP7WReUFmnSA8CBnN/4R5V5C5G5rodEJ+OgSrf84sFt96tW4G7YVt13s4YD2kH6ms4erEODUejafCNyjPesmcaogq2uyFF6R/z0vmWGdbkqz6xXuXvJ1WDlfuLo3L5PkUCNJ2JpVh892v21jimcsYqF8b8KT0swi1fV7r6ViFD4bLD2jAd4wpenSy5Lc0ttMNpfhOk72FQYFlOf+mEyExJAmARAYy3lhb8UJbQhsAKV1Sqg6ozZVOVX+Nd70b8LRu8JhCJNGR28dRrqYm6N6Al5Zm0yAUNXxiFGcRI7I9tf28xLun0ZKqvAJR1MBvmZc32gHwhdAhFdO64dk9OwYH6nGPir498YHUq9yyL99TS/HzcLV4Z3w1SKTzGkDayYW/Ej1bVfzG/wOFuqOh8GB/xXP+1xbiSUJPzoEkAzJ8aBIX+4j4HuU5SZ9odSOrzrGd03LWOH6sFALYfzErXdc3IkLnZfOPF5e1WeUHdCsLCh7TPNCVLsYL4mvR0+GTeJmNkO+Cu/JUjlnCr4wWQy5lEuo4c58ghPWW4Ut+b5Jv6zj3nSIUA57Fc6vTGtUebabxsY5j+WaY2M5aG+TqXhtxFDQoHQodOEx4v4uVVbwx62VJHTn8jXh++nz5FLvPtsdXIXUwc/q2uuZBj5dcNcGDQPj6fGUULP35TlRyohG7SXXfjTGvceRlMUdTLJUlz/K5hX0A/HLQrBuaFdyGp+q2Jfvgbz0fOcBqHLPP4vNfDvblq4qp0y8TbXZ3vP1wbsBqHaFtKr/1g4crGb9TbQiLMv397RORSkqa7W6TrceZKFASwuO/xKWnK
 MjzlAo8W
 et+PipJYWhvkyNzxAJJwqTf/aXbVGSi71alBvOU9WN+nRCLLcsGf15Jl2a1RMH834dcvHJM9PaJwybsxFTfTjz8cHoxiTRFpEZfZdrUwLxpqWgTM+2LLGlTIdfl8il2YYrU+zVO3f0az++uA0iKOPQZkQvo+WlJuCsLwgpr185pOssu/97XfVfBnRrQ8dC6DdbHZ+bdTWLiWDIz5oqU0HJPqRvXuaTnUxScrvaHVfEgQ+klSOlbUpTj+tYR75NdMMS5eTf1OcN9Ni04S8DOE5pyyEpERxQpPIpaxywMB2lsGmrePX6GUDEl6DvGs6dJxn/kp/zlrBYIn3ZHnbWxTZRvT/KPfyB1fUMsBTLg9GzNzV+jMmlr796uLP207dqFcMB4awwqURlv20ehiai3VcNbR0Wv5OJ8gjNYqYvpqh4DvhoNJ0A62ERQTmuInvaPvQB4jB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

The x86 SFrame V3 implementation works fairly well, starting with
binutils 2.46.  Enable it.

[ Jens Remus: Reword commit message for SFrame V3, starting with
binutils 2.46. ]

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Indu Bhagat <ibhagatgnu@gmail.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    Changes in v15:
    - unwind_user_get_reg(): Fail if !user_64bit_mode(). (Sashiko AI)
    - unwind_user_get_reg(): Simplify guarding using CONFIG_X86_64.
    - unwind_user_get_reg(): Add pr_debug_once() if unsupported register
      number.
    
    Changes in v14:
    - Drop superfluous empty line in unwind_user_get_reg().
    
    Changes in v13:
    - Naive implementation of unwind_user_get_reg() to support SFrame V3
      flexible FDEs (e.g. used to represent DRAP pattern).
    - Define SFRAME_REG_SP and SFRAME_REG_FP to the respective x86-64
      DWARF register numbers.
    - Reword commit message for SFrame V3 and (upcoming) binutils 2.46.

 arch/x86/Kconfig                          |  1 +
 arch/x86/include/asm/unwind_user.h        | 39 +++++++++++++++++++++++
 arch/x86/include/asm/unwind_user_sframe.h | 12 +++++++
 3 files changed, 52 insertions(+)
 create mode 100644 arch/x86/include/asm/unwind_user_sframe.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f3f7cb01d69d..51286dfdb5f4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -302,6 +302,7 @@ config X86
 	select HAVE_UACCESS_VALIDATION		if HAVE_OBJTOOL
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select HAVE_UNWIND_USER_FP		if X86_64
+	select HAVE_UNWIND_USER_SFRAME		if X86_64
 	select HAVE_USER_RETURN_NOTIFIER
 	select HAVE_GENERIC_VDSO
 	select VDSO_GETRANDOM			if X86_64
diff --git a/arch/x86/include/asm/unwind_user.h b/arch/x86/include/asm/unwind_user.h
index f38f7c5ff1de..942475235431 100644
--- a/arch/x86/include/asm/unwind_user.h
+++ b/arch/x86/include/asm/unwind_user.h
@@ -15,6 +15,45 @@ static inline int unwind_user_word_size(struct pt_regs *regs)
 	return user_64bit_mode(regs) ? 8 : 4;
 }
 
+#ifdef CONFIG_X86_64
+
+static inline int unwind_user_get_reg(unsigned long *val, unsigned int regnum)
+{
+	struct pt_regs *regs = task_pt_regs(current);
+
+	/* SFrame only supports x86-64 */
+	if (!user_64bit_mode(regs))
+		return -EINVAL;
+
+	switch (regnum) {
+	/* DWARF register numbers 0..15 */
+	case  0: *val = regs->ax; break;
+	case  1: *val = regs->dx; break;
+	case  2: *val = regs->cx; break;
+	case  3: *val = regs->bx; break;
+	case  4: *val = regs->si; break;
+	case  5: *val = regs->di; break;
+	case  6: *val = regs->bp; break;
+	case  7: *val = regs->sp; break;
+	case  8: *val = regs->r8; break;
+	case  9: *val = regs->r9; break;
+	case 10: *val = regs->r10; break;
+	case 11: *val = regs->r11; break;
+	case 12: *val = regs->r12; break;
+	case 13: *val = regs->r13; break;
+	case 14: *val = regs->r14; break;
+	case 15: *val = regs->r15; break;
+	default:
+		pr_debug_once("%s (%d): unwind_user_get_reg(%u): unsupported register number\n",
+			      current->comm, current->pid, regnum);
+		return -EINVAL;
+	}
+	return 0;
+}
+#define unwind_user_get_reg unwind_user_get_reg
+
+#endif /* CONFIG_X86_64 */
+
 #endif /* CONFIG_UNWIND_USER */
 
 #ifdef CONFIG_HAVE_UNWIND_USER_FP
diff --git a/arch/x86/include/asm/unwind_user_sframe.h b/arch/x86/include/asm/unwind_user_sframe.h
new file mode 100644
index 000000000000..d828ae1a4aac
--- /dev/null
+++ b/arch/x86/include/asm/unwind_user_sframe.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_UNWIND_USER_SFRAME_H
+#define _ASM_X86_UNWIND_USER_SFRAME_H
+
+#ifdef CONFIG_X86_64
+
+#define SFRAME_REG_SP	7
+#define SFRAME_REG_FP	6
+
+#endif
+
+#endif /* _ASM_X86_UNWIND_USER_SFRAME_H */
-- 
2.51.0


