Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30429EE6B4C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 19:37:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F2A96B0093; Fri,  6 Feb 2026 14:37:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27BF06B0096; Fri,  6 Feb 2026 14:37:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2D136B0099; Fri,  6 Feb 2026 14:37:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D6DA16B0096
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 14:37:15 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AABD3B806E
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 19:37:15 +0000 (UTC)
X-FDA: 84415040430.06.50AAC45
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf26.hostedemail.com (Postfix) with ESMTP id 43A84140015
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 19:37:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="AACl/Vx+";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf26.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770406633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nZ3DtYU6oaP7UVk4PzUNWALcciYCvdSqiN7dJ9VBjQ0=;
	b=pAO7IDz1BEGaTFWM4H0sBNUjBBXaslALLw2Yt1BRTld5xdXnai4TEzW3yV5KiDNP0TTaUI
	zf1iTj8oQbwfT3Bm81lNK5NHtM1WNppUNcwm2a/BtyckNXqbRa5BNTYhMWXFhKHKD1gwMR
	wx3VtcJLFvO+z3Wcg6Y8FquWUWf7XJw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770406633; a=rsa-sha256;
	cv=none;
	b=Mrx/HkYkzCMjzpidFV2ZAhwwyCFfXRpP9l5N7o16AXR2MT6N+J1WKLZ7mvxr43Mh2MQMHu
	pHdqMFWWm9XNcvXNzRodeGPVmC/O2BkAzDlEI4WHi2FW9uUt4EJ1j9wRMMkWIEe4FsJI2d
	VLfw/BF0zt5qz1E/y64SIRL2R+T2wBA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="AACl/Vx+";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf26.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 616D0Xks008818;
	Fri, 6 Feb 2026 19:36:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=nZ3DtYU6oaP7UVk4P
	zUNWALcciYCvdSqiN7dJ9VBjQ0=; b=AACl/Vx+mxLHsJQNIT5jLg50yPheArZjn
	aj0ZLiuoUM+lQR9QpMN/vGWkLiwuDyPfXXkltWcxWKGSmWeXbnJh3V2zEi59H/f8
	Xw7xHmMdCheSNB5ZNS7xdLB2EGTozo/CmC4HSQGEQLE8DON1QXzNsLrqqjS85ZlA
	UO8MLT3C43AshcUTiIJBomfN2yo8xsuSi+qe7BQLVkwvNYp0a5d1nc7pZaKHi1Hu
	FHFP+xoElL3/4tHxHmCBdrPwHUGMAcLXrq5DdalUkF37eSnTqMF9pUP+Je9CM5XI
	PPJreVXZE+/pYU4/QBalY2rio9LqDceRKPHFC4vD1KLAqu1GuhWEg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c1986w7c5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 19:36:51 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 616JaoRK012994;
	Fri, 6 Feb 2026 19:36:50 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c1986w7c2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 19:36:50 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 616JPkZa029082;
	Fri, 6 Feb 2026 19:36:49 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c1v2sqq17-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 19:36:49 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 616JaiI659113752
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 6 Feb 2026 19:36:44 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9184E20040;
	Fri,  6 Feb 2026 19:36:44 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1A48A2004D;
	Fri,  6 Feb 2026 19:36:44 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  6 Feb 2026 19:36:44 +0000 (GMT)
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
Subject: [PATCH v8 1/6] x86/vdso: Fix DWARF generation for getrandom()
Date: Fri,  6 Feb 2026 20:36:37 +0100
Message-ID: <20260206193642.1580787-2-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260206193642.1580787-1-jremus@linux.ibm.com>
References: <20260206193642.1580787-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDE0MyBTYWx0ZWRfX//ngAxkJ97Id
 yxNP+DrkxShtUE0R+EYG2O9cYVZ+PEApJzk9rdGzGg9Yn+O+V/BshCZp+5IuZyFrL/OkFq2MKv8
 Rk2ZnEHUYTl2CFGwhAPcdHJhMyC+BBBtJ0qTH1NQlvnRGSmIwjXjGDU88fL7WvzNug238MmNq8d
 hAG9jsyyWLB9/pMkpIPTPB7sI5Eo4wjzBFB/q+EquoiwScm7ss0ZXuGwx/bkcHhYAAf39ZkXdpw
 f0YxNQmvtIYLKio6h20fp2bDbOJX8pH+mc8ob45UBQJbo8b0C2CkFOcJuTs5XLAIJuuBmnk1P/1
 ZqBM5SZ0+IaFgM/YNLSF6DNLSOXkELebFMXXJFDrDU3BIeQNt2A4nJJ3pINfVUTUVT/4UgV9NNI
 kt6ipeyF3vgq3ly6baLqtdVtzVzLvou0RjflvPuyEUgFnCNdmmln6Rtfxhzjn4dJfTLepTJBRSC
 EU2hQi9/H40LOvuS8kA==
X-Proofpoint-GUID: pFAHhq3f3BpNXuJ4YV9EfDzrLY0VwEwE
X-Authority-Analysis: v=2.4 cv=DbAaa/tW c=1 sm=1 tr=0 ts=698642d3 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=oGMlB6cnAAAA:8
 a=VnNF1IyMAAAA:8 a=rsc5PF6bQGhcUx5MhlsA:9 a=2JgSa4NbpEOStq-L5dxp:22
 a=NdAtdrkLVvyUPsUoGJp4:22
X-Proofpoint-ORIG-GUID: j1PEc7-sCw_jGVfvfOiamut4VxifSQth
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_05,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 adultscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1011 suspectscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2602060143
X-Rspamd-Queue-Id: 43A84140015
X-Stat-Signature: 9nikh8ratay5ky3xff6zkxmm8ekg3ko6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770406633-710109
X-HE-Meta: U2FsdGVkX18docu0lYvH73Sh2Lun75z+Botynh8KUdV3N7SgvkLAvd6Lpm5yDpZydEnfVSjdGxP4bCkTEWEQEnvjSxNA8MZ8SC3QXCWy1MY3hg7Ed0tIw3TDYYnRRaqp/epTTiDdjSyVAjO54fNHyAj49BoK6NNTk7RnEn8VDOff6LHYL/onP6V+6VgpBXwQT5K0nEl/wYnJJreEehEfCgRbTlMBKMqSX/4P105CAn7L0H1U2B095lbs78Q+nDJZy90w2wYYw9hsm48jX+8vyNZRSJhhwwv5n976K9tSTmtOkgr4hYK1h1FvtCc4Gsl4+sHcbT8BuahzkIWDnrkr3OfUER+nLMIrkhvwBGRtgr4geEaFwsmGcIxBgF9SURWUeCEtVIMf2CMtMCCyB4bhq1Ja+bhGHskSriKfhc33y30VSho0P/9VWtDVmSWKU8Ge6czFxHScU0hfojdudL4kKZ6gPFF3r5DC19rRy+N/Efj6OvOx3v1jTbl+yZciiNv3s+SGNX4hgHjlnwNlO6IhsrTENRnxCVjjxJZNHopsWq8RzlftxQF6RvaNXCIMOKONesTt6tLMkFKcmkQTnAwsw/RrE4LjfQvzHUvczx5qqw3jQMgAbfi7rl0a9p6sI+QAC1/Nru0IWB5F94DYD+tF7ZSQm/bOHG5IFz95YZUaqYItaUil0OolXBz+4xAAYAPzc7VA1QJO5FpQ3zs4+qXx83c8Y9Bj14tgblBTJKtLSTb1QBf4JFm83IsGN7RcwE0zfXVH3UvnSxmQFd4c6G3pubb4d5LNp6aphXhDoRxpjJDQqh95odpfFpDDBQMGuMwbeC09asP1kL96rtULbXo9mXKlWwmL8QsvPnNh/8n0RE0FTMes2tT++4xSYu0v0hi/0mEw5QR3SeauNoFEQrzbSDpG88Fgtmw12Jrm7OPDpmnh5PePNTcu8f7M/kcn7PECS+CWCOvnppGRxj+44jv
 XM1vKJwh
 d/ABkEZBQhNapGQhK8a4gezZTTuYDc8rbd4kkObIWd2eHtp8sL53RV+SDOh8QjqaxZL8vU2GojCuY2G3S2JTzC8jgY8J6MKeu6rjxIrHnzG/d3v/N93GkjkEkp5g8l1RV/i9bVuCm5kbmTxP+7qo0wuSjUVVFo4rcoi+Y3w6hvz0UIz7egU5zsP2h4DWbHrC1DPUvmWFsEfxyxdOp19RUQdD+JOFvMjtntQSIGRk3UEawH7wrcfz2TxDnhvW39LZ/Fsv7yWIGR1TbOoZBaHf0nwxBgvPBQkYkc/bUgy6Bg61Cza2yBcPMV+T9hr3aXLJCRvBlwU5vUjoN/qZtCsBXfAFTmAoK63X9ikStgD3w6Y+upwRPlAQYLdM2bKvRDxAoRoq++AoPphHnXfs6Pot2308qGJwbMb0xTUiq6SSpALIZmukGAD76FsRdig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

Add CFI annotations to the VDSO implementation of getrandom() so it will
have valid DWARF unwinding metadata.

Fixes: 33385150ac45 ("x86: vdso: Wire up getrandom() vDSO implementation")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---
 arch/x86/entry/vdso/vdso64/vgetrandom-chacha.S | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/entry/vdso/vdso64/vgetrandom-chacha.S b/arch/x86/entry/vdso/vdso64/vgetrandom-chacha.S
index bcba5639b8ee..cc82da9216fb 100644
--- a/arch/x86/entry/vdso/vdso64/vgetrandom-chacha.S
+++ b/arch/x86/entry/vdso/vdso64/vgetrandom-chacha.S
@@ -4,7 +4,7 @@
  */
 
 #include <linux/linkage.h>
-#include <asm/frame.h>
+#include <asm/dwarf2.h>
 
 .section	.rodata, "a"
 .align 16
@@ -22,7 +22,7 @@ CONSTANTS:	.octa 0x6b20657479622d323320646e61707865
  *	rcx: number of 64-byte blocks to write to output
  */
 SYM_FUNC_START(__arch_chacha20_blocks_nostack)
-
+	CFI_STARTPROC
 .set	output,		%rdi
 .set	key,		%rsi
 .set	counter,	%rdx
@@ -175,4 +175,5 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
 	pxor		temp,temp
 
 	ret
+	CFI_ENDPROC
 SYM_FUNC_END(__arch_chacha20_blocks_nostack)
-- 
2.51.0


