Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FD34E9E30F
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 14:14:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 840486B0088; Wed, 11 Feb 2026 09:14:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EDA16B0089; Wed, 11 Feb 2026 09:14:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EF926B008A; Wed, 11 Feb 2026 09:14:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 60E516B0088
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:14:31 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 06A7D1403FD
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:14:31 +0000 (UTC)
X-FDA: 84432371142.30.5A20208
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf07.hostedemail.com (Postfix) with ESMTP id A30924000E
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:14:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=FT9AP11Z;
	spf=pass (imf07.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770819268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nZ3DtYU6oaP7UVk4PzUNWALcciYCvdSqiN7dJ9VBjQ0=;
	b=Un3SWsFiY4YcrlZjTNgAbLvhiCjWI8UERTO8SoFL0/z4rZrccsnI5yB2WhfH8feS1GJkbz
	OUBi4xzwDxJVwGpQntMk4DQri90TSK1Qi5vi+GaPdciaBkda7F/uZioI4JQ7BmtqIZaapf
	N39FHdb9Mq+cXsqXo0y3JqR618a6Hjc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=FT9AP11Z;
	spf=pass (imf07.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770819268; a=rsa-sha256;
	cv=none;
	b=E+A2jk5gfwm3Wl7jVaOs7SFLDNe2G/OW4fOhkf5O7Qv7g4ifxIprUPawW7piH75KJVoQ+k
	41LWUVEt3utM0e3aYt3Ax90/aoUyobGFzHh0WoKsN2yimvmjuNmmD8qH41wpeCNmXZikTB
	NwrVnamlQVgPZwO/JUCRm+v10YVoN5w=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61B1gTxK2771696;
	Wed, 11 Feb 2026 14:14:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=nZ3DtYU6oaP7UVk4P
	zUNWALcciYCvdSqiN7dJ9VBjQ0=; b=FT9AP11Z+GCNfyF5lav+mCn3P9v+8aSza
	lMI0b0Ge4bjElNawf6zvpIGpXP/rU2a28nD0+WDthkqDL7Ul/0kvci9tkmhtJUyc
	xe358SlIoVjWqGVohKo9r7rfmbjvRwQ6iJyFLBqslxD3uHj5Wx+cFGSU3GPZhTte
	k+7T1LHv5XTcTolBXr5CUTVeGAsr6a8A+vy36hIJGfMZzWvRD3iknfx5LhTztH8P
	f5k5Ib/tmi88uisq1S+7/GSEcZ7682v96OxJhcOMWqu0BKh7OzxDTo0RmaS61bpb
	MXJy3VB9GgSOh49nlaOqghPfT4DxsPwsbg1m3bUnABW73VnZe6VSA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696wy13s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 14:14:04 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61BBA3LT001847;
	Wed, 11 Feb 2026 14:14:03 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6je25spj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 14:14:03 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61BEDxTO59769306
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Feb 2026 14:13:59 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8FEC020040;
	Wed, 11 Feb 2026 14:13:59 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 050B62004D;
	Wed, 11 Feb 2026 14:13:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 11 Feb 2026 14:13:58 +0000 (GMT)
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
Subject: [PATCH v9 1/6] x86/vdso: Fix DWARF generation for getrandom()
Date: Wed, 11 Feb 2026 15:13:52 +0100
Message-ID: <20260211141357.271402-2-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260211141357.271402-1-jremus@linux.ibm.com>
References: <20260211141357.271402-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=WZYBqkhX c=1 sm=1 tr=0 ts=698c8ead cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=oGMlB6cnAAAA:8
 a=VnNF1IyMAAAA:8 a=rsc5PF6bQGhcUx5MhlsA:9 a=2JgSa4NbpEOStq-L5dxp:22
 a=NdAtdrkLVvyUPsUoGJp4:22
X-Proofpoint-GUID: coOlGK5_Y3eioVjFxn1dt-jFO-6QXvjH
X-Proofpoint-ORIG-GUID: hCiBiAg_lSUcbnUCAx289HQUzG6fCHkp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDEwNyBTYWx0ZWRfX2URJV1E8ko/V
 FYOQMGVlZpMxXxdGg9YmrhVbUUEC99giRAiNLHyPm6TJGCSYZAOBPL3g0Q1mB+br2n/IOiPaOSL
 OaSumIDOrcUrdU7Lb+zF6eoHEcK+hVidv3PV/kdQec4Bnj/jAq93gUKvY1EnC4h3mSKfUBUQWS3
 L1wBJzwcxTeT6PmNX5CdS6Jmf4YGHzLzO+Ep1wxYd0osZaaMuLyHob071b1rwIGsgKERKp9Dp/X
 tzApMzOMBdHt02bysDTv0YQ0voHL0RY4ZG2IpfnO3+PvhhTIOrS/sr61M3ph+FAqLWa2k5aErYe
 /TKcYXJ1JOFaBXWTzjlAXo08wAs+VVtIU55hUqeSY1joNSx+pMW93SwgTyt/zIKUAWd/EpD4XB9
 le0veV4Poz/qdFd9Hqh0VQxadQ+1rb4LAHKyi6mqNBK/RfDYktYxVs0aZBeVXVokBi2NLl9bGQn
 KumaDRN5X6qvgdLfSqw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-11_01,2026-02-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 phishscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 impostorscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602110107
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A30924000E
X-Stat-Signature: wk4h4x5zkj5zhjfez95uumq9ezzzuf89
X-Rspam-User: 
X-HE-Tag: 1770819268-211262
X-HE-Meta: U2FsdGVkX1+SWaTuJSWbcjU38V8fiZlcortwW6UrGZpgjmoE4w69sDHXqLFCd5xefOej0unY+MxFYXOb6UQUQf1eJcPfDG7tt5Uy8zgiUs+QMCfjUHrzZrR4N3fa+SPL6rwHMWn/5b3VaRjiqYryI182Li3g4MXjgNVJKiZ1sE8pSaLeaKsPjXOpdtPMW0HcVFIXSCgcMiLBzC1212NUqtZnk95OkvkiT57Vt4ScCSOQgnbLIJp2TUY/mubRTjzK4tPSYdO4t90NFpDWZL0uLYVKYoTTL80r+fGv3RN5lZ4tm7/edOKrfD7GsCK+8aDBNy0XESp7+7QugzR4rGzYeaZjlY9JDk8Q+1DpFpIXboVY4Strey7jNbFFL4Mf9wNlTrP9XdElvtmwV71PhDv6AcZUhm16FIBB5S5qvjo8RUuYlAqwaMbbuhvFiOr6aoShWPFjHtqb0cnzm5mWqN39NwyWlENwGvcxoWQEnXKiXYpzGXoElvV7mR9UNdEpQeancPi1GucYFq5swbSPKTkBGpOrRgcdQuG+xTZQoUMdSlaiACRAvHWgfHEOFSqHXh6VwVFvjCK+J8rYm1WNXm+NlStS4hx+af6h3MTEA6Xuv60AiN+46BhY2+W3C8/tHyQVGFF2q4NDXZRbBtJC1qiXKIvhL9RZk3jswjogoV0jMe9V3k6zYztfszJEuWr/IzghYDTjb8q2K+Ble6ToCU663uKpf4A4fPyd+pbPmmqlMs2bSlx/r3/wBs6hWoxwGjJAVG4gtjzNipbaSlN0aXEjkt1TSM9LbFA7LVqcJzrf/DfLEbh4ArumZeV7W0MBzEtd2sNrybdf/4sb0QPFXNfJfscmcY+Mf4AxhvLo6M5Vp7BQK1+/4AtVCF2rvVTVYP7Ql51aJ+EZ/VqKpSs2yldwqPg7BrWES1evSfhgsBXwqBT6aCFuUIvxkr+QFsq6yv3cNFTcegnMx79b44Pvc2J
 ZJQZ0LjF
 ADQGcnSe3TRGsAQFrNJZA9CDLa49d4GTECyzRqUVGI1GZ33KzXQRJUk78aa6WKPsRnICjaYQb77xxbOu18MELu25MDIIYW3nlSneQxCiPOJJPDajjl1zWbXtCwitqwAXadV0xU8Qk50c1nW/5E302sT70rghTxrw4uMyMozQ6BtqI3bw4U8DNIq3/JBMPIyL6FmjczXjO0CXa4YcwIBGXjluvVVeFy3HJ4Bl0N/R46JPzVlrzegk3VlcaF8Kpt4jir8Uq1gxd4yGOWVwyhraOMmOKU71qcq4atcGBp/igoQx4t4O/ihXNQskkm3Lzseb3yoC+Eipncyez8Ehax2WsCVOB0qwSGXE914n9FbJ+/fXFwrd4L1ZqJW5LbP+XdVcEW21sR1nHzMkLiIBl8UyqelyH1ISu67nESguBvV3cbUa1G18x3UXPDMsSKA==
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


