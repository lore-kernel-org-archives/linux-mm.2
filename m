Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A31ADEE6B4C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 19:37:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2D346B0096; Fri,  6 Feb 2026 14:37:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFBA06B009B; Fri,  6 Feb 2026 14:37:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B08996B0096; Fri,  6 Feb 2026 14:37:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7F7B86B009D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 14:37:16 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4A3CDC1749
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 19:37:16 +0000 (UTC)
X-FDA: 84415040472.25.69F9BDA
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf17.hostedemail.com (Postfix) with ESMTP id DEA7C40005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 19:37:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Pf2vmZ3n;
	spf=pass (imf17.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770406634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zcp5Naq2FPjOG1kV+prJJdfvki9PYjEAiotKE3UfUD8=;
	b=z9Cd9QGe9lLybsG0c1gClxbzf/+GNpmdKOu/b52opwavq3n21xBMXr8GexWB8EdKZaV5KI
	iy8gQdIQKfibTkZWaMl7Oo2EoSvJm0dPaQNtVGbkm0bkIXuI0QgNraQxQaaRP0VxdICpC5
	L+Z+/FCncky69EmvPy02j0w1Yuub4eQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Pf2vmZ3n;
	spf=pass (imf17.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770406634; a=rsa-sha256;
	cv=none;
	b=2uQk6g/MrdsJHBOt44cstxoTCu2v/74knuoPXfEbTCcnfbwvyxgAlaHj2LkRCqIBfI8NFH
	JZvbh9pz7Ui/2mZNJtWEQCcgjia+6YWkhi3sPHyyOxRQ7kgrMElZFU5Ic9XGVHwE/IgjXI
	m8R4q2c/+uCvRDWnRVW++AeXKKWYQV8=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 616ERlsL016796;
	Fri, 6 Feb 2026 19:36:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Zcp5Naq2FPjOG1kV+
	prJJdfvki9PYjEAiotKE3UfUD8=; b=Pf2vmZ3nfO6af3/45TVT4GNZo3hsN6yEx
	FukJvpxzckzerzitx6bd/uutdfCaEi62jz1iXAiyRIe6eJQSkMwEhqR+8JqBo5Wn
	Elc06lfW50wNswO7swz4ki6wPZp8utwq63QEMrMg4pBNZbJTF8ogqCWEMoRLgHFu
	lxsAvTeTOXXhXNN3wUHkht8wB9+89ErnDz75SKtou6ja2mWIzUiqg5vVcXc5ZUhL
	kS7/GQhPBGHv3B0vJE2QiVRG80+De75b72GlfdMabwd7bbtW7M0U2zYltHlhnon+
	F2Id44XN9q+ouMtif6wNGAUHvO+mubDmA2UOTx9V4FHrL3uRUrXcQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19dtn2k4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 19:36:52 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 616JapGW018714;
	Fri, 6 Feb 2026 19:36:52 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19dtn2k0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 19:36:51 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 616FfNFI015355;
	Fri, 6 Feb 2026 19:36:50 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c4gsgywpw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 19:36:50 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 616JakAj46596538
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 6 Feb 2026 19:36:46 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 19DDD20040;
	Fri,  6 Feb 2026 19:36:46 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9755B20043;
	Fri,  6 Feb 2026 19:36:45 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  6 Feb 2026 19:36:45 +0000 (GMT)
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
Subject: [PATCH v8 4/6] x86/vdso: Use SYM_FUNC_{START,END} in __kernel_vsyscall()
Date: Fri,  6 Feb 2026 20:36:40 +0100
Message-ID: <20260206193642.1580787-5-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260206193642.1580787-1-jremus@linux.ibm.com>
References: <20260206193642.1580787-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDE0MyBTYWx0ZWRfX6MUdgADcKgBV
 L9D4yBWk5NS2uv2XK/R6Yw4ZDfNYNF/0hdgm6X0oDzuN8LT81lsVv+ZNosZpRCwG1uJXHVJWr2J
 sPSXtrgqaoEjiFF5tv5MhkZjqkWT9BRbeTiabARGU0iRwHgtkdNKSSR9nFy4NSJvNx62sAmoqhO
 y4zLeHwnsC3QoD/9gLYen2YLidQkfpHu3CDLG71nMlVK8rnd+RGn9TVAdQKtb3k5G5UZptnAsna
 CE7ygH+dp3JBZAmbFwDyjnYiMr1Rj9gVw5xuob0aqPV8SZDHgrRyOMffJmdk4IJhBOWoNlADIA9
 sOYmaB9JBq/+C4Cx66vyE/zanabHh9jZIpW+eRRFWrgQGV6BWAw72oV1q+ErxCUa3WHFqHyZyqT
 ejLpCUd38EWZISHUA4hLQzgzTjac08Ynqeob0Apu6fzVksHE+NjUHXpUHH+/TAieHV+lFeYqz+R
 98Gmm2m/dKXo1kgD+Bw==
X-Proofpoint-GUID: 3G3zA37M8tzsTp2MgMUjmQt-X6LdyvvP
X-Proofpoint-ORIG-GUID: p0nCG_YctyTf1NkU38vgBpV0X0NDIDO1
X-Authority-Analysis: v=2.4 cv=LesxKzfi c=1 sm=1 tr=0 ts=698642d4 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=oGMlB6cnAAAA:8
 a=VnNF1IyMAAAA:8 a=lbqDleH5ITP0AWbVeFgA:9 a=2JgSa4NbpEOStq-L5dxp:22
 a=NdAtdrkLVvyUPsUoGJp4:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_05,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015
 adultscore=0 suspectscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2601150000 definitions=main-2602060143
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DEA7C40005
X-Stat-Signature: ejfa1ac9ejuqcuffoxhxaphk7x5tmchs
X-Rspam-User: 
X-HE-Tag: 1770406633-953473
X-HE-Meta: U2FsdGVkX1+UaFQgDz2Cyk6MeP0ftUy0TPL9t4MaEhYVVFfa4DfoxnZ0r5gr9kCeyvZL5VQyR6GflwdmSKkBKBPE1Q3rR8xqwMSllRwiGp0Q76MhG3tJk4d9vL23OhfYs20BalB2+AOKj5bkHhQMkAfbOT15Xo0F76sWxs3E9rx9glpKx9XlWq7/DuqJRrUkll/BYiA0TN2P+ZBTiqnWrAy0A9DKJlfKwz6luQ1vkpxm880R8k/nui6zJWjrPZwToUxGfDh+EF6QM/gIyCo3SabGNeMQvR3EEebX23/YUm1IVk+rppXkns86XdnmuLvrhtrqpF/E3ehHnuyezsnWMCjwqU2khSz2kXLAXpGYVaOMYnWR0uSXtXWI6B/3gXxNURK/cS9F3GPie0H8sgr42I9VPJPvUPW+t6QnLHHCCL5wzWw2gPwvaXSoCgoxgEY9zaxqubEUm2dxlKe6ZBHPiaWUjHpYqjY/twQgzOiOOMatcNSio2151/uhfgheteiq8JWXMcwGPMKGjFU5Qo7LWPjPrzXcNKadR5AhX5C+vFhZzFI7j9ZDzcFLXoViINgewyqXaNIxyg1Z9nHxrmPaiRCXX/21sXf7lTiKFYfhG8KxKJsCnxFPJtlTDvs3mqkSypFFRMP5whTINzPrY1K7/NTHjIA4HSgWWr6WK5GdhgWCgCwtaJuwTMxMLkx4FF6GBE2Vp8jYkQP09F+eW5eWGhZTysNMKll6N4OhGuw6wDvrr6MqP8Tbb4y/gcCJ4yMt3IumthtgC9qyqgl+eEGjVJvfS5yyM0+TGE3agDu2tjOYCWuqNn6amc0U2vMx/2tLvp1wW28uglU8arkPhhheu3LGBsVkdYgpO//nLrkTUvm4+oX1ujGzGp/oqsVcYSNXlYtn5SN7XeNAycX7n8GU58342y6phgCflasGk+XLqLrT/wbP0uLfVxfoaPSvNpxZXzF/VRVVW/TYW2BVnz1
 EkwCZIKD
 CwHjSPTMmRhnq56cFYBi4FwX/NRzb5Cms9AKEuBePLPt13bwkRuobwjGJohcV6wENu1KfSCi5llS8Q3EoRsI4oXZLaDxgB3SlRzzceXSbRSbkNk7AH+7HCUdDbDaoUfWNycFTHGCFrpk359shZg4xiE69MdGquLA65s4spFvLA2YNVcO0azTVWTT+OI01ezeslxUz7dw32vCpozqeLwk+GoPsuRNl/4MO3FqOdFApAthtt+lghyE0q5/Bw056SQfshf8P3pcZ10iuRc1tJfVwqhxMJ1oaRuQbESMvzNOKDH5SJHiqk1qA21yw/ughaeRgZvbxaeZBdubgQdWx3pdxgtEPEpQB5iTPdAFFp8GcODD6jpgrk44VjJvWMc7TsC+qaLlaA1HuvRHY9u8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

Use SYM_FUNC_{START,END} instead of all the boilerplate.  No functional
change.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---
 arch/x86/entry/vdso/vdso32/system_call.S | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/entry/vdso/vdso32/system_call.S b/arch/x86/entry/vdso/vdso32/system_call.S
index 9157cf9c5749..a90f4f7de396 100644
--- a/arch/x86/entry/vdso/vdso32/system_call.S
+++ b/arch/x86/entry/vdso/vdso32/system_call.S
@@ -9,11 +9,7 @@
 #include <asm/alternative.h>
 
 	.text
-	.globl __kernel_vsyscall
-	.type __kernel_vsyscall,@function
-	ALIGN
-__kernel_vsyscall:
-	CFI_STARTPROC
+SYM_FUNC_START(__kernel_vsyscall)
 
 	/*
 	 * If using int $0x80, there is no reason to muck about with the
@@ -85,7 +81,5 @@ SYM_INNER_LABEL(int80_landing_pad, SYM_L_GLOBAL)
 	CFI_RESTORE		ecx
 	CFI_ADJUST_CFA_OFFSET	-4
 	RET
-	CFI_ENDPROC
-
-	.size __kernel_vsyscall,.-__kernel_vsyscall
+SYM_FUNC_END(__kernel_vsyscall)
 	.previous
-- 
2.51.0


