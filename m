Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4634E9E311
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 14:14:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 300656B0093; Wed, 11 Feb 2026 09:14:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D9426B0098; Wed, 11 Feb 2026 09:14:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EF5D6B0096; Wed, 11 Feb 2026 09:14:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4D8A6B008C
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:14:35 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 60BBD13AADF
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:14:35 +0000 (UTC)
X-FDA: 84432371310.10.A6E2B49
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf27.hostedemail.com (Postfix) with ESMTP id B665640016
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:14:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=OtHCEJS9;
	spf=pass (imf27.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770819272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qiH+5t/dirTrzjD9ZdtQxW3Rb7kBj9PpVkHn0IEvdoQ=;
	b=aOqFIDIlRenWvuyBFkfvAth2sOjO+QSrMdwUMnOw/gN6avWvQ0ry8a9E3sBByLjByS+wMN
	zVI0UJhFaep4Wosth1PLMLIFmNLhLWsxJCr9vTwm9FBlni5MEL+EbBggeMf7XedzWVXvBG
	QM10LB+u0rparo4Kf2kj4o6112YjP2c=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=OtHCEJS9;
	spf=pass (imf27.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770819272; a=rsa-sha256;
	cv=none;
	b=wrutzNV/gWxd9jPZTX8A5eZUwjOppyIkFWVcdIoa7YQsEw3N7ajV/WRfnmJLrPFY5N5Xsg
	KUl6mWniL2KhvfPinrKVI946b7/J7DXZpOfLUwQJ1/XaKxj5quDjHL74rvkjKYu2BdUJ3u
	HIUnu1I0BvAhKKVWLBU3/7TiVFoVLR8=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61ALUH8n111923;
	Wed, 11 Feb 2026 14:14:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=qiH+5t/dirTrzjD9Z
	dtQxW3Rb7kBj9PpVkHn0IEvdoQ=; b=OtHCEJS9FYwWQwev3XdeyV80sYiX60gha
	1o/sM9KcwYWvyQ8bAD3QYfkFgHibOqhVyYfH1+YFimppjc0nl6BEpUnydRmJfHxI
	Vha+nJjpbJM6+kswkEvy4AJUmYLP0/PKZpboICxCFaGP8mRmpUSIRS0ScOn4SOpH
	hDdwG9eLauie4j1MHHe0dPE74SstV5E+7OEBKOYhLhe9BagCycw7qERpzBAqCzV6
	zIDGYgr/W0AsSPK/Cnf+ScRCjBtq9o/Y917pFiH0OWOuTdU7O9V6EQafh7UHn48E
	JlkKfJuWyHolj8NAvKTN05URL7lLlk/2zM010EhPPpa74Z+/1hiVA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696uhfmh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 14:14:05 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61BA3Bx3012611;
	Wed, 11 Feb 2026 14:14:04 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6h7kdy99-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 14:14:03 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61BEE2dT28967518
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Feb 2026 14:14:02 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E128920040;
	Wed, 11 Feb 2026 14:14:01 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5DA172004B;
	Wed, 11 Feb 2026 14:14:01 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 11 Feb 2026 14:14:01 +0000 (GMT)
From: Jens Remus <jremus@linux.ibm.com>
To: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        bpf@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        Steven Rostedt <rostedt@kernel.org>
Cc: Jens Remus <jremus@linux.ibm.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrii Nakryiko <andrii@kernel.org>,
        Indu Bhagat <indu.bhagat@oracle.com>,
        "Jose E. Marchesi" <jemarch@gnu.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Weimer <fweimer@redhat.com>, Kees Cook <kees@kernel.org>,
        "Carlos O'Donell" <codonell@redhat.com>, Sam James <sam@gentoo.org>,
        Dylan Hatch <dylanbhatch@google.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v9 5/6] x86/vdso: Use CFI macros in __vdso_sgx_enter_enclave()
Date: Wed, 11 Feb 2026 15:13:56 +0100
Message-ID: <20260211141357.271402-6-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260211141357.271402-1-jremus@linux.ibm.com>
References: <20260211141357.271402-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=YZiwJgRf c=1 sm=1 tr=0 ts=698c8ead cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=oGMlB6cnAAAA:8
 a=VnNF1IyMAAAA:8 a=zHpKlsP_3zAlDdbrjxAA:9 a=2JgSa4NbpEOStq-L5dxp:22
 a=NdAtdrkLVvyUPsUoGJp4:22
X-Proofpoint-ORIG-GUID: -gdRSFuNxD8GhVPJMs-jCnse1443Lxpw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDEwNyBTYWx0ZWRfX1ReMu2KCVkfu
 ZN0r/55zCFkn/SPqGxL+kneTVoBlTgbwr1qFAv2AQkMduD4/AGxoOxXQza9mztMOLal9nYY3bY8
 NHKbuhb0vbi9dzsgC7O6QJ2J7WZiqs1G5aw79P0gbM0csAaD2M/LLlP0Lv38hD0QBZqA31lH0P3
 H/YlCgtPIp1JnWJJsqH8n9RbQItWjVV1Ei4WiNp4aNT09BOy+vliacWWT1ZfVPTQ4RwTHJrCZ8p
 XU3WPaGcJIApxypuDEfrnEdJ8LkG+IXmwuzM08u4PmDtN2le1IqGIB0hQ6drQmdjmb5hbeKPHd4
 uZz0pRRrbBlJDO9OOt1FvkCTfvm1rsSuAjRwAwcl3TIqgqeXvHrVg6KZzGf5zyHYw8Nn9fIwxg5
 kr87/xH9tquhGNcluPAibFqJt3YvL9A3/iMAxjegDgd+Lm39VLeLXm+yZdW48cw45R6IMDEihwd
 MC/xkSzlylzN3lUoDrg==
X-Proofpoint-GUID: HEqKmnsoSR16Jfq_QSRBrMc9AjQH6I1R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-11_01,2026-02-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602110107
X-Rspamd-Server: rspam11
X-Stat-Signature: rwc37upt4yjfzf4wjs34shkujdtoks5o
X-Rspam-User: 
X-Rspamd-Queue-Id: B665640016
X-HE-Tag: 1770819272-470267
X-HE-Meta: U2FsdGVkX1+hTIhikoQy/1fPGyTPLwoa5orjcPaQYHsB7zPI2nLn5wv/Euq3Bo+E519mv35Jb1INTZqX6rt2w5jcs0yVqYO2NHlaPQhw3XVRP6nv3x8pci7w3Maly56orHTvBZlEKhzk3qZaFCcD6HpVjOd7yvz8NmT8mOgHv8iudATFG9QA1JYt9C5hxEm4pOIUWbMYcE7/lY7SE2bXN029XxWQGjYOgIK0EbJrSaUn3sLmFn52DKsuJIy0f7D99QqFmOLJKEUvTDRRSFNqaygMHQ4rJKhVA8d26ILBEVi2nC46wj7WGzSgcTP3vc0N1AiRmI+WwitgpKW2MsA/tbTj2GNbcvKhTHuX4lHyRJVo+cBcRX5XWd5Ptq52dmWVBegFiNm+B4BJ8SLL0Ca/Cxv0p9lIbj1bnvFjnhlFufg5aX6iRy+BE52HAQcPbSX6g92XOgX3FN3z5xW+M+z7fOwdiY5/C5VmsNbzW/2xrdNe8j5KK4fYPqVMtemyZ790Lx+pxkcxMnGn3+QRrd56V0XhRK1FzONgyOohYLPH9Yc3diuZhXQvjuO3WjNoupYpm5uybVyoXD5ByFBJuEg7NTmcW999oqxuBviFWSqbhOldX3rbezbtMC0F/olKnLSx3h74qlj/inSG4oq6KeXIx0lIkWm9wJW4M7ebs38L5Q4LB28cAujKu4Zjmy7P/bAbSIQeoxRZ3kfO3PTrz8NxeOsZbeMbcn0puhHEMmYoZWhaTMWOVyUU4K/viKzaJbGuQMYq4CDylRNgOar9oT0gSc5eSYf7xkgz/EJHoGcrUs4waQQTUWFVVB1MkU8NvmMoGsTML8bZtsMu2d3lX5/I/V8EjZe6PLJg2qub4oz4dNqWMU2R4iI47KDcjNUvImPA3R+w6IC0x9MYj9T16A6VNDAuZJCd8qLZWcPW96wHdGSatBcFfS4CTi97H9aB23vK44Hs/j48Qsu3iis5cO9
 boUO5Bl4
 ze6KQuSDFpI0+b79XH9iLcYRAwWTodOsG+9+rCxBtoi6wf7PRp10yfxvxEkkj28/HoCtwj4a8Wj2CGI3mmq6mElCJbFcwtBeI1Gvi5QjI8yLGW5vEF5c35a65lc6Wej9cMfHgdGV7TpvL1BAcjyYZ6H8SmmKZodpkpz3whGJ5K/kCtyiS0j+f19lEfIj+2v6FaiPqVfvULOJuFBPAZ5QOhYf8jlOgUqYxhptKNUe4ndbpsqMRCMm4qYjmWbX+XZ80dWLQwtgw0jtvrPzKJrsggv7TbX0Rk1eidn1Hyny13SFYvTAftvKhMwNdDcq6JKDuuKU2Fhu197hO/uWm/5Dsl1piyhH7n9uYSakgzB7qxLnW5vQ/+cfqoMN+USM4PCVkOjwmorlaPfjcm8Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

Use the CFI macros instead of the raw .cfi_* directives to be consistent
with the rest of the VDSO asm.  It's also easier on the eyes.

No functional changes.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---
 arch/x86/entry/vdso/vdso64/vsgx.S | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/entry/vdso/vdso64/vsgx.S b/arch/x86/entry/vdso/vdso64/vsgx.S
index c0342238c976..76efbeb1e287 100644
--- a/arch/x86/entry/vdso/vdso64/vsgx.S
+++ b/arch/x86/entry/vdso/vdso64/vsgx.S
@@ -25,12 +25,12 @@
 
 SYM_FUNC_START(__vdso_sgx_enter_enclave)
 	push	%rbp
-	.cfi_adjust_cfa_offset	8
-	.cfi_rel_offset		%rbp, 0
+	CFI_ADJUST_CFA_OFFSET	8
+	CFI_REL_OFFSET		%rbp, 0
 	mov	%rsp, %rbp
-	.cfi_def_cfa_register	%rbp
+	CFI_DEF_CFA_REGISTER	%rbp
 	push	%rbx
-	.cfi_rel_offset		%rbx, -8
+	CFI_REL_OFFSET		%rbx, -8
 
 	mov	%ecx, %eax
 .Lenter_enclave:
@@ -77,13 +77,11 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
 .Lout:
 	pop	%rbx
 	leave
-	.cfi_def_cfa		%rsp, 8
+	CFI_DEF_CFA		%rsp, 8
 	RET
 
-	/* The out-of-line code runs with the pre-leave stack frame. */
-	.cfi_def_cfa		%rbp, 16
-
 .Linvalid_input:
+	CFI_DEF_CFA		%rbp, 16
 	mov	$(-EINVAL), %eax
 	jmp	.Lout
 
-- 
2.51.0


