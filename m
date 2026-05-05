Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57612CD3430
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 12:18:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43AFF6B0096; Tue,  5 May 2026 08:18:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39CDA6B0099; Tue,  5 May 2026 08:18:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C8F16B009B; Tue,  5 May 2026 08:18:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0104D6B0096
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:18:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AD65AC1C88
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:18:14 +0000 (UTC)
X-FDA: 84733268508.12.FC630D6
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf21.hostedemail.com (Postfix) with ESMTP id 768301C0004
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:18:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=FtfZd4ry;
	spf=pass (imf21.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777983492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x08tC+lfWLJ46E0BXz9C4AQirN+u4zkUsjRqoQtFpXY=;
	b=lT9MZH+jZryARAXhLf+lRPF7bgh8+VJzC+EifLYW6AvvvaFCtpJOhXF9S4GJp98axHBNCn
	22uTULnhgOERvZLMGEKr94FEpGvMH8EfiCCTF2qkrHPLPzw657Ap+1px/D1YwBQrkspFYC
	Sby9O9Yg8fmcj2vTAu1obrBTD5SLXPM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=FtfZd4ry;
	spf=pass (imf21.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777983492; a=rsa-sha256;
	cv=none;
	b=EpCxZWs847FBH7tBFuT5HLvQUZ/lGSGT8tCp54KSxH2JRObrGBGKcEKRQuKfixdldrOB8E
	jWSwGH8l/dNK9/UNGQA4xRK55RpFurOECdOSZCDnc8a0pi1WWVtZSIdcFJ95TswZNlZ+q2
	DWT50apKlnxgvTefxHThboWwVgGtg7s=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6456A3de3182093;
	Tue, 5 May 2026 12:17:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=x08tC+lfWLJ46E0BX
	z9C4AQirN+u4zkUsjRqoQtFpXY=; b=FtfZd4ryPVkLU7KElGl42+t6ua2i+5MPX
	jSKgi+4yIyMlJS7Ibui3E7r/LLOa2gwUHm+sbE0dScbkiFppYIgyIX8QFSxiJNxQ
	BcO4t3p3kzWNhQKu8mAzepFQbxVWpE/B8p3YQ/TOiVlPLfjzhxv7LBJKa2rPxfW1
	fibTcToytoBGjEbKYCb/pTHH1hrrfi8GMScujpka6DpPcTzIdvw1XoKson5yhZ1c
	TqwNnWbWVweyNFWECeF4PcaT0YqHHldmevMwfiI58UMXznZ4204zKiP5s32780lT
	OrL7F8ROQzRpTjvevtK7vhZ2DBFHTWd6B9evzQjVb5S3hQKBrKSFA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9xxk5dq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:33 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 645C9dd0028522;
	Tue, 5 May 2026 12:17:32 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dwuyw1m3n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:32 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 645CHTff48955718
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 May 2026 12:17:29 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 089EB2004D;
	Tue,  5 May 2026 12:17:29 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9B3212004E;
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
        Ilya Leoshkevich <iii@linux.ibm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v14 18/19] unwind_user/sframe/x86: Enable sframe unwinding on x86
Date: Tue,  5 May 2026 14:17:17 +0200
Message-ID: <20260505121718.3572346-19-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260505121718.3572346-1-jremus@linux.ibm.com>
References: <20260505121718.3572346-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDExNCBTYWx0ZWRfX5eIgOiYSAVYE
 gElSVNIYwjC+gm3x9lJpoB3LhvyZaM8ze69qZvB0gkry/I2PHAEKK/M+0J5TilUholuTcn6JMjy
 RqwDtQzBNP7c52ykWcs4vBzV8Kp7lzrSkEbL6vCRA2Syg9STB8zwvaEnB1/qoC3w2XsxAeJUvH4
 nVpavikiq9He78B41gzJu+SY2m6RDpEwuKrwO8UPKFNg4Eh/EWQ/k/CNR4fo+/Du9BzfYuwy9cX
 lxbSQYuxBhp5/sShe0Y+SG+yB2YJXfR1cQsWPvL8lyyfY5fvuyPDLd2NVVD9jZEQelF2KxfCteg
 Lo3sQc4HS8+QPHcyDi0cnci2/EfR70uH4wXjtMQgEDVFiCM9c2XFCdV984+Q/5cxQKBGbxOtlTN
 xvUMXQJ7TmNMi5rnc5guWvcMBxmX3RF3edENd8v02WbNpszEIzStA4PU7xKMSwGcXRBtsubJ9rv
 kNWp0wqRkScUu6NA6MQ==
X-Proofpoint-ORIG-GUID: AQlMQiA4R5gyjNW1nup077lPuGq6n5_t
X-Proofpoint-GUID: rWYMWQbXEDhvt5xo-cN5CNnAkkafnuaD
X-Authority-Analysis: v=2.4 cv=ctWrVV4i c=1 sm=1 tr=0 ts=69f9dfde cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=Nb24OjdhCh9FoptYTSsA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 clxscore=1011
 suspectscore=0 impostorscore=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2605050114
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 768301C0004
X-Stat-Signature: 7k8iszteqksppurdyeps4oobehssjda5
X-HE-Tag: 1777983492-28693
X-HE-Meta: U2FsdGVkX187lNsfKv6YH+gKiFAA/xyXMm0xy33CRTQjEe81QZuCuV54Jsu85GDbUIscsh9MXtCL0elrCX+qJMsIIcKdCXWUoku4FqjpZqMqc6rkzbfZapeFIWX4z4Z93XxXtQdYapTEghMj6faMT2n/2I/oumxhjQ/xXlZpvDmWfeOpxzXPdNnxx0o9ChRDVv2ZyczAXiZ3ELvi9fpgv9PTt/MUOCvEpIGdf/LXXRoi0aPGftpR6+/CLjQ5n/T1pkvQxM/imrsDuG5v3HjUFouNJt9JosfqyV0/jEe4SwTY4AvwqNq7pguXv7czWJiuVvTfSdyEqeWyuLYBFUn+uUuJy0XXj/5Dn9hkadp9/GgxHFMbb+bEbOqFFmGk4CcLTKMj1Krku18e96FFg1p/1m3kh/OePaZdCLMetf2nPYdN00F6ENO/u0UGgC/z7frkwyyrUEa5Dcfk5GAXqH0SyHl62z+P2nzRJFwJbI//jpc5sOT694l7rOVbQNLU1eZUBmIkF1GWzrAdQWndbWJNMY+wCvtKx+w7uTU2X4kBisRUREFKVTNtjmGQn2VvJUCASV9GOPIuihX+nE16FRMljQ4zNC/sPrkLEbsBfL8jKumIY8NknkHXxMgTjO2UeOSd3Cv/7EH2aX2Bd6VOMN0pMjNvCsyknVlxXLZyHu+vGLt7g1SfunKHs8+L/S2ubnmKNYZU1OPrajcRNBFzY4GIzLWvPN/hjSkcjvFSC1kfQlo3QWiNRnA0wLEadhwpz0owi5Gmfg07ixIuQIhqbOaY89++21Yy7lon5/beHWWpq/QqrVd26Hr1CZlpqIi6npHZGI+ZpFrkk7DX1elJYE9somlxFbpKinY/ZNOJ86cdyBxyp/2wqCobr34HK9AG7eAdcuEdfNDgnH5Btad6WHiUjH8rQNvWPJ3sQiTfhjQ8OMawB5OSlRZxSE2EdLyGVR7BqDuO52GiRC7Cpu44ygv
 gTP3Ffrh
 y6HzGE401Hs90vQ5oJMU68YNni15tl3tQFVqegSdt9sEfFYeOnQDu33v0VTHgEV8T9S8aZRFSnE1z/jA53DxwPGmEk/9ytRcogJKIMKN8AUPYvX36W/pw+S5S+xhcQ+g8fTQKNjORat5Nb2Wet8XqNpQ2DEeFGFHOUqDHC3nTuG7iRoingsmWB5zwxIlOlleQ8Bi/VS9absLz33cQCHStyS6r7iSbRS15EaUKxlOlkH+Bdz/abllpQDgaI7f6aTWwuQhB1RF1wNqU2IEcTvthdjmEn30URPCjyyK3VpjoICLswYoCtcOU71G7eCkO+A8WFVSwzDchH1sgJDmcvh88GV7CiIm+ODj1SNfW
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
    Changes in v14:
    - Drop superfluous empty line in unwind_user_get_reg().
    
    Changes in v13:
    - Naive implementation of unwind_user_get_reg() to support SFrame V3
      flexible FDEs (e.g. used to represent DRAP pattern).
    - Define SFRAME_REG_SP and SFRAME_REG_FP to the respective x86-64
      DWARF register numbers.
    - Reword commit message for SFrame V3 and (upcoming) binutils 2.46.

 arch/x86/Kconfig                          |  1 +
 arch/x86/include/asm/unwind_user.h        | 33 +++++++++++++++++++++++
 arch/x86/include/asm/unwind_user_sframe.h | 12 +++++++++
 3 files changed, 46 insertions(+)
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
index f38f7c5ff1de..b80f0ec0f7a7 100644
--- a/arch/x86/include/asm/unwind_user.h
+++ b/arch/x86/include/asm/unwind_user.h
@@ -15,6 +15,39 @@ static inline int unwind_user_word_size(struct pt_regs *regs)
 	return user_64bit_mode(regs) ? 8 : 4;
 }
 
+static inline int unwind_user_get_reg(unsigned long *val, unsigned int regnum)
+{
+#ifdef CONFIG_X86_64
+	const struct pt_regs *regs = task_pt_regs(current);
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
+		return -EINVAL;
+	}
+	return 0;
+#else /* !CONFIG_X86_64 */
+	return -EINVAL;
+#endif /* !CONFIG_X86_64 */
+}
+#define unwind_user_get_reg unwind_user_get_reg
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


