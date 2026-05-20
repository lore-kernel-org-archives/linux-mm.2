Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8846FCD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:41:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A6FE6B00F4; Wed, 20 May 2026 11:40:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3577B6B00F5; Wed, 20 May 2026 11:40:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F9D16B00F6; Wed, 20 May 2026 11:40:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 048216B00F4
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:40:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AD0B0C1851
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:40:54 +0000 (UTC)
X-FDA: 84788211228.08.A8535CA
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf28.hostedemail.com (Postfix) with ESMTP id 72984C000A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:40:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=RmtPp3Yy;
	spf=pass (imf28.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779291652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MtnVctqCs7YoKq/MwD8B6NDfS4Kt/fyB5yJ2+IDDGco=;
	b=yD/aV0cGl0UPYGwZbjHP+uWP6s6Xe1EcxAkUP3N2Vv/J95QJWlDdyV2smQO6fHXQRWDxeQ
	CzOwhbqkcX7bfrgU4cTcc4gEE7ruVouukDP+JQNQdvGSjAYtCEmF8ue3rTSyWmOT9cV3bU
	ZLHstR9xWt1UUwaaG86tQmC4W4vIztw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=RmtPp3Yy;
	spf=pass (imf28.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779291652; a=rsa-sha256;
	cv=none;
	b=BuDt6oqjx8rvyk0R9rTmnDZg3aBidfsNCWStJ/4bijJNdNg8cxds+g27GX4jiKyGLtXIem
	uLrTtU17DVJ4SvW5NGKw8MOBlDhHHtddy6Pt92CqlFUeJLmkfeUAMcqsaMA/pZcZPDSPuH
	BlW4cL/j77a280eSEwgSpX6MEad6P0c=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KDiWDK441640;
	Wed, 20 May 2026 15:40:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=MtnVctqCs7YoKq/Mw
	D8B6NDfS4Kt/fyB5yJ2+IDDGco=; b=RmtPp3YyIDUtcOunstkoYqNG6K8x8vh0d
	XC/ylbnOE2XyhlxSEp2caZGJK2go77jARAMjTX7R+0+Z5v6UteO+Ls2S0qdgCFnN
	U60uDQ+tJ7p2a37n6ngn8nYZHs04DA58wxJ09AsbbwMRFC2C5r9F+Aty5zB+8bwn
	nl0ZqTv9JgYfbhsvKfiDQ79cxsGe5yXLaxK22G6KNFe4G4BF3loxLUbD3+4avKa7
	fQQqtic+nCDXObGnMn1UK5EOpZNQEB/FCQ4AzG/INNFlQTSy1YLrWnx7HNNrUgq0
	+vJ3WGF5O9el91TU3okL+GbzC+Lc3s7U4xk6dKR1zaIPkmRno8Y7w==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6hb8hspa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 15:40:22 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64KFdHi1026172;
	Wed, 20 May 2026 15:40:22 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e75ky7q6p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 15:40:21 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64KFeI7E8323522
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 May 2026 15:40:18 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 53BA320040;
	Wed, 20 May 2026 15:40:18 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C648620043;
	Wed, 20 May 2026 15:40:17 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 20 May 2026 15:40:17 +0000 (GMT)
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
Subject: [PATCH v15 19/20] unwind_user/sframe/x86: Enable sframe unwinding on x86
Date: Wed, 20 May 2026 17:40:03 +0200
Message-ID: <20260520154004.3845823-20-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260520154004.3845823-1-jremus@linux.ibm.com>
References: <20260520154004.3845823-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDE1MSBTYWx0ZWRfX1ynlGov/rsON
 ONpIgpdK/avkbTb7ZZZvkfzF6YGwh4OQEO1iP4y0mzix3CRsnkfAe4OxJsWfeTkyal6ZBnSGZds
 PHvbCTPIjXa1A74yNjXEftL/S6ji6anH1FY2m44uaCHmXJgsDSzr/AzjReP2/vFtbaSDJQ2Ib0I
 6Yk2WS6y77HwI59arU7bm2tsbOqHjqNhC1EmtLfelw08L5yun8E4M8MzAjBH2xoP4rmV4mKJzBC
 G4A9/y0TxBAXxZY9MtVuHcpLV29baPqcp+dUmpl4GGAmHKSIES6xTcip4N5bbWmjWge6oNRMtra
 NgcyF2WJLE/d8xjWezuKz+PlP+t1Hk2tBmC+0Ewjyae8g7rPnTKH2co8xCPH5bBRlE5xEM7Jd3L
 UVKc7ERzeHawHQemetQmdAjDxxeY7Ly9oEb3zo6El4/ksr8OO6c8iQSUnnJkilvFHfLCNk+p47W
 YhSFMsigHLvtK7lPNOQ==
X-Proofpoint-GUID: MY3deY7T0eQoBbntI9zjLIpcrmO-vjbB
X-Proofpoint-ORIG-GUID: xgx2UBI6tlWlIKVb1qHEiuYVnXS55moD
X-Authority-Analysis: v=2.4 cv=aYBRWxot c=1 sm=1 tr=0 ts=6a0dd5e7 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=BJDwMle8H-fvePKCLUUA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605200151
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 72984C000A
X-Rspam-User: 
X-Stat-Signature: uy7fe98yecm3jkype6nfxzm3bipzicip
X-HE-Tag: 1779291652-693985
X-HE-Meta: U2FsdGVkX18FmNmE1fghRsDHrvzOZR4lDD9oCIN7b83Mw4YNhKYhMG5Hn1bSa4AVY/rAbJ1VBXtrEEXcXeGsfy8lVWK7bAI0ue1H0AbHwN0hDtDdjsk5hhc9/hOltTZu6lIdMsforLm4wNsWqflJQFRIv8uf+IKjzrZcP9lT+uG9jWUtSAfQ4/mZMyEwuVvvy9jqT7Y0XvS+ue8yyfoZoGn7vIhGVL2Edes+i9CKFuAISt0aDUnHJaahqAY8+dAB7jIowRILVKNWNjaW9Le0xyNn9770Qgd1PTeNtL5ewWygn2r9jbkeAJbISC0MQgFdZIhHNfH2Bzb4H1ugmphTP8jhYof5An5iRjtK1sIuFYFXUS4MDsPwnNXCshnr605ASbAHT+vxqmqT44pg6HMScko7GwFMf0JiJeT5I0AEFjG5QKFfs6J8x5WHTBO0LSrFzBnQ7KZJKVcQzRxUzbOkuqs2NRSPFT3TBsNGd03hcVSIKU33p7Ox+TDH734IXsjiCcs1XMV8xSE9RyV3sIKndMK/13CYTOQjGWYdajTtS5E8fpaeuD2t5IjuoaLdIBjG1igLbwnBc8qcbcP3qgeOIJrmvgwBFlsCmhHG964swbQKYjxfZmaidBwRRfyOPBSHG3DalQ1rckdtsMtTIGpiPtbUIPvP/YKuK5OTv9A2+itlw4bcdTMo/PhIGH/vEDyaIQe2VQ2b9aQ5nz4Da9UJzmJ0DfHqdWD9xU5KJP0rnIYJJ1Li4DMwo5DOYbLkd3Gg/jbffbntr4M6hjA50/dI2QXnHHLdGtweXsjnJjNOKK0oPwqP1/Jw0M9W+s4IiROR8e2QY1cvX06TCPwm1pr3iS7o5Lfmgh6z81JA/TIv9yJmBRnTbXb8hEm/BWMPcuI5AC3wrouVeeTlWFUFSCg2egVsjTeZPSADFD25+zz1696YxnqAXB1a5wjxSGODSZ2jZyXu3YqXAr2t6juWH2F
 fkdRqzW+
 2qZyzUIZZi/SlwRX45VGvesoZ4OKou7y59oxl5wTOJGiGuQf/tKkSNbFYUKv+4l3OeDF8scX2IuiiKdE4VRTWVghsPIrPRRv17EvPyiux802Jdu1rACqjkqlOsYvGiP2jdajcXNqljEMvaOe1GWqJDt8mTMqQlkDgBs1EBnjJLsW4Y6jRc6Dvw70s9LnsyBCzqs0eqR3b4ubZnSGK8UEmNu4wnOIzBgyZqpYmjH3yvl1NZLU4zdcHje78HdebfJ5fwLoRmVCiR0R2eIx6Jo4KDvU0bGeUHtA55LLjrRZ0hAUONHOHOIsVwi6beO18cMOXeuua0Y8LIKCrRn5vfiMLUy8dqDAP7bYRMYOaEBd6U4W8ORpTRb/q6uvUNH+Jc9rkdEz2TYBwlebOG+MzcL6Hdkcmluz108npA1aKLx1yJg6yibS8QiscGgAxXccms9t9Aj/Z
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


