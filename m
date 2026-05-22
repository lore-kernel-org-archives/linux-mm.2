Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB016CD5BB1
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 11:05:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B0E56B00A0; Fri, 22 May 2026 07:05:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1617F6B00A1; Fri, 22 May 2026 07:05:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 002226B00A2; Fri, 22 May 2026 07:05:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E38456B00A0
	for <linux-mm@kvack.org>; Fri, 22 May 2026 07:05:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ADCC71A0A4F
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:05:26 +0000 (UTC)
X-FDA: 84794774652.24.E052093
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf08.hostedemail.com (Postfix) with ESMTP id 56C3D160006
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:05:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=i5P5Zhkz;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf08.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779447924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cSiBsMiyvS7cygGX52RlC3XdEyvxbuMMGQjKtYeDTPg=;
	b=IBJv49j7Keoqv9/9QrIghGMqInRKLdMQz9AAq2IuB2Z7LKYHttXDJ3uSBL7JzEtD8BGWrD
	QeI2TuL1SKpFXxlqrin60dJE0ItF38s/WbyTuTA1laeEwvKRvEr7BWL4BfkK7UNnF4NRLo
	yXZe+zdYnZryjFOUDhbwBn8KCwiDVBY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=i5P5Zhkz;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf08.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779447924; a=rsa-sha256;
	cv=none;
	b=xwAXpmgTuqHGhaA8bLelmBC367PS/JgC9zk9Swsrsc/uqgmtf/GB8XOweBN8zZ/aGwsvTT
	QdP4Ly3se0h63ZLNAWBAP2e9MgfaKhxA9UGJp09F6xBlZqdwufGt1X02SiVoOqlscEhMbV
	Y0Fe/II5anQIp7ns9R5Fyrbdl85IeRo=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64M7SMQn069628;
	Fri, 22 May 2026 11:04:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=cSiBsMiyvS7cygGX5
	2RlC3XdEyvxbuMMGQjKtYeDTPg=; b=i5P5ZhkzaeywfvOUr1t35AoN22Fxd568w
	n4QyfqFAsluWrvOlT6veZwv0e+zIP28DHeYH2wArTFIYIRGcXrRmLO7Mfum8P136
	r1fMFhIe8mO2eI1mK5LDx3ns3be/mnOOBh6nZMQNlJLHLCjh5/8rqumn1FYyI7cs
	dCfNCGsczFOohXjTAPprI8nCHYZAuV9n+sIE9m7N4OqSX0RMhT+THOe62CIBDBYy
	bjvZtpVbccta9RTi1KOLPURSqVt1wfbeDZjJDdqJy2KtiSN1EPTHtobZui6TzN7v
	LzOZTWZN2g/cV7vtviGHwtckaZSvTQEIBH1AQd6SuLZXyM9YUvkHQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h8n3jar-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 May 2026 11:04:35 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64MAs6ov022842;
	Fri, 22 May 2026 11:04:34 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e74dj0grh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 May 2026 11:04:34 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64MB4Uvs35717462
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 May 2026 11:04:30 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 951F82004B;
	Fri, 22 May 2026 11:04:30 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 204E620043;
	Fri, 22 May 2026 11:04:30 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 22 May 2026 11:04:30 +0000 (GMT)
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
        Kees Cook <kees@kernel.org>, Sam James <sam@gentoo.org>,
        Andy Lutomirski <luto@kernel.org>
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
Subject: [PATCH v11 2/6] x86/asm: Avoid emitting DWARF CFI for non-VDSO
Date: Fri, 22 May 2026 13:04:23 +0200
Message-ID: <20260522110427.2816637-3-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260522110427.2816637-1-jremus@linux.ibm.com>
References: <20260522110427.2816637-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: ZddEMLOQrfvITJNkqALVMGRlJxt2TLYE
X-Authority-Analysis: v=2.4 cv=GYMnWwXL c=1 sm=1 tr=0 ts=6a103844 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=oGMlB6cnAAAA:8
 a=VnNF1IyMAAAA:8 a=zOOTxvlrTZNIKiBVQswA:9 a=2JgSa4NbpEOStq-L5dxp:22
 a=NdAtdrkLVvyUPsUoGJp4:22
X-Proofpoint-ORIG-GUID: rvJDq_F-CyNalpWNGqTe6-A1u88MGFUr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDEwNiBTYWx0ZWRfXxDY83bHMAKkS
 /y076Q7Y1FPHjMslUIPL3wlRp7WPy+UBH49MkIB7tUH7yqqCRXnB0sq2/OZNU9LnlY67OYKn7IU
 m5Q2QWddtd8/ZfrVIXsC6NH7fvZNEnY2v4Nb8BYEnMBKuEXr7aFvt5ZLchkM3QSygYeBlgPZe+k
 QdSslQ1LgFFZA7yug/Pvrep8McDwJBS+xhG8CWrMWanGluw3JZKOs018dtBtM7KWX1+fKrtnrcz
 XDmqzoBX8t2XPTuLDyqcTK1CnoNzvFPop6dO8GW3tZdtvaMjxHoM/z7FVOlH/ZA9UC9cEjCUaOS
 nvSgTJTWpepW48m3spbJlNau/zU1Neeo6q0aDRchUPO7tPOs4/K7gDp8FE5cwdM+/UIaLIiJvt9
 ce+Tk4E1I/firvQzn90K4h8DF/BVBc52sAwNxTL76W+3nRJXLNqjAB9rXw27JY9DSlpNTDBiXPv
 p7Z4m5ZqmVSo5KYiLRw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-22_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605220106
X-Stat-Signature: qoay1yjs3rf5ox8meb4k3jg7sz68ixzz
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 56C3D160006
X-Rspam-User: 
X-HE-Tag: 1779447924-292114
X-HE-Meta: U2FsdGVkX1+p0MEFAoAGrtjTquExfdq2bbSV5tlgbZfrWS70JemuieQaT4YUH2UjixoJ4zxUzYS6JcPzLNCiNorlUoWezAugpV/S7vIG5sy8KAX+G69YOPSmQY6g5YjO/b4QNLQ5dmJzdPi7X5A63OfpZPTkqIFi+ykLLKMpdCEcHzNfTK40gBXzesYQVlwWxFTRZVimMdRJ77dvbo/Snv87TqQ1mGAtMg3OU+24pYVwpfU5iU9phjBn/2FYoI1UppkWHFEsnOUVX/+z5dOI7JR7FC7bZ6aCX+Q2lM6FFOkBcstGJ620JPAU6H1ECDXTYdAzymmJgQSAo3q8uXW+rd/UkNHEpnXzozmvEjvSqy2hgebengjl0dM7JMFb57KhE+4tg2ddCvHB8YD8LdY8EHr7aDzCh4dQs3Y4n/5NqhkZ2Q0Axl/yIVhYrFwf4RTJOXyoB0l6sM+Ay6rviOCDzwRXk69OJvNfxRLMmCIbkR+hvqvYO0vG+knfWLGq/ifJ8lC0bCJO86Cjk4SmwjxlJf2mj2PT6LhqhlOU4nY2aAQ1UGOX8XPzLFZZRqLupZC9EXGZG61REeDTWf60jpWMgj1fn01HNiGFfpgOL9itIU8IQR1gYbtKSNNaH0NJuUALWuCs4XcMgNaaPwYVOhvovEAab+oFBLvNaA5WhzHNTjD1ZoDXw6RFH2MNRLYWiUzC24xNqbQjOL6zNA4dTULRuTIHHsSSz6XIWD07C1Jfv53L0I6Ap1JPFCoDZDmyrJI1QPbR8hKbZQAnp7FuGn6JE9RuJ3TfzR4e2xaPmTrcrpmDfTJ7lKUKh3VDDdJw1YNJNcW0vB8v/Ik7/e2dJ1dfdOFA4ooyZlhCBi6aM0iJvBJmqooZQjt1L9lYEUhRgqBy8LKZcsugrUL6Cp6bv0I3Y9Mw8aonC08i2qYY0Nk9+iRO0samMp3hbgSscXNiqDTI1XjWcBjHJLZ20e7NcDK
 pY9SNxi0
 KYkYDG7ARbAPaZ75ked/RKJ+meUjRabYgvg/NtJuSsHreQmIHzVajRfXcCCnmf97mRHxp1YYaITZviEaxxdAf0l7+OpPNwWJUgS6Y/pnbpR16GEN74pdo+owr+ctuh3TEEV+8kl3XNGn9ZPI4AhsdkqUhlV+rnXZCjXN2I6uCUz4EP06BdiYW02GM+qEXLsNUajjbXo4Gbv5pp5ERrk3+CkzyeXHPzfvVmZOP1Ro2UzLLM1tXs1NXT0fxHJ99bWNZ7qDyfpiOcIoDMJHO4kDlHwKkbFdGE3ww+HvzpLqdZu+qbZCda9nuYD4OzdUI8M58wged2E4qM5MDmHlfDSpv3TFGL3ygZ4iE5wQa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

It was decided years ago that .cfi_* annotations aren't maintainable in
the kernel.  They were replaced by objtool unwind hints.  For the kernel
proper, ensure the CFI_* macros don't do anything.

On the other hand the VDSO library *does* use them, so user space can
unwind through it.

Make sure these macros only work for VDSO.  They aren't actually being
used outside of VDSO anyway, so there's no functional change.

[ Jens Remus: Define CFI_SIGNAL_FRAME for !BUILD_VDSO. ]

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---
 arch/x86/include/asm/dwarf2.h | 52 ++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/dwarf2.h b/arch/x86/include/asm/dwarf2.h
index 09c9684d3ad6..13e2e64ef265 100644
--- a/arch/x86/include/asm/dwarf2.h
+++ b/arch/x86/include/asm/dwarf2.h
@@ -6,6 +6,15 @@
 #warning "asm/dwarf2.h should be only included in pure assembly files"
 #endif
 
+#ifdef BUILD_VDSO
+
+	/*
+	 * For the vDSO, emit both runtime unwind information and debug
+	 * symbols for the .dbg file.
+	 */
+
+	.cfi_sections .eh_frame, .debug_frame
+
 #define CFI_STARTPROC		.cfi_startproc
 #define CFI_ENDPROC		.cfi_endproc
 #define CFI_DEF_CFA		.cfi_def_cfa
@@ -22,21 +31,32 @@
 #define CFI_ESCAPE		.cfi_escape
 #define CFI_SIGNAL_FRAME	.cfi_signal_frame
 
-#ifndef BUILD_VDSO
-	/*
-	 * Emit CFI data in .debug_frame sections, not .eh_frame sections.
-	 * The latter we currently just discard since we don't do DWARF
-	 * unwinding at runtime.  So only the offline DWARF information is
-	 * useful to anyone.  Note we should not use this directive if we
-	 * ever decide to enable DWARF unwinding at runtime.
-	 */
-	.cfi_sections .debug_frame
-#else
-	 /*
-	  * For the vDSO, emit both runtime unwind information and debug
-	  * symbols for the .dbg file.
-	  */
-	.cfi_sections .eh_frame, .debug_frame
-#endif
+#else /* !BUILD_VDSO */
+
+/*
+ * On x86, these macros aren't used outside VDSO.  As well they shouldn't be:
+ * they're fragile and very difficult to maintain.
+ */
+
+.macro nocfi args:vararg
+.endm
+
+#define CFI_STARTPROC		nocfi
+#define CFI_ENDPROC		nocfi
+#define CFI_DEF_CFA		nocfi
+#define CFI_DEF_CFA_REGISTER	nocfi
+#define CFI_DEF_CFA_OFFSET	nocfi
+#define CFI_ADJUST_CFA_OFFSET	nocfi
+#define CFI_OFFSET		nocfi
+#define CFI_REL_OFFSET		nocfi
+#define CFI_REGISTER		nocfi
+#define CFI_RESTORE		nocfi
+#define CFI_REMEMBER_STATE	nocfi
+#define CFI_RESTORE_STATE	nocfi
+#define CFI_UNDEFINED		nocfi
+#define CFI_ESCAPE		nocfi
+#define CFI_SIGNAL_FRAME	nocfi
+
+#endif /* !BUILD_VDSO */
 
 #endif /* _ASM_X86_DWARF2_H */
-- 
2.51.0


