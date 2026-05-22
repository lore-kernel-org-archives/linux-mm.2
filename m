Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 955B2CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 11:05:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C4A96B0096; Fri, 22 May 2026 07:05:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 075CA6B0098; Fri, 22 May 2026 07:05:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7FC26B0099; Fri, 22 May 2026 07:05:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D7ACC6B0096
	for <linux-mm@kvack.org>; Fri, 22 May 2026 07:05:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9BD1EC30AC
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:05:02 +0000 (UTC)
X-FDA: 84794773644.18.D2535C8
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf04.hostedemail.com (Postfix) with ESMTP id 60CCC40013
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:05:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=YDkJIrEl;
	spf=pass (imf04.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779447900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nZ3DtYU6oaP7UVk4PzUNWALcciYCvdSqiN7dJ9VBjQ0=;
	b=BUUBh6c44+hPyOU/cDIlpoJnyTqbqNv/epIB8wN/Su2ezq7xSCNk/5OvZk+GXpq/6Vt+SC
	7CzlPzvQ3kfHIF/SKNhOJJqnsFg4kQfD/CSeWDiyOuHD90hIyfpRAnEdq9149A9GKsE+lC
	Opryu6dsAlCEfgo2/ZaKZRIoPLNms4U=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=YDkJIrEl;
	spf=pass (imf04.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779447900; a=rsa-sha256;
	cv=none;
	b=ABtv7nzxIbNlUg0YUvxX7hKx2rpdkK/wtVNFJSlFXQltNCU2x5NI4wn4zy7DrYYbY9+pac
	QTdZZQ7LaoMRl3C8LFvBah1ZV5Vdju+6hgenVIMb+PZRvN2lB0HNipG1QpMS1enemaJf0s
	Us4gaKnbeG+Anm0EseKIZzGGQx8KWe0=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64M7NINa4007147;
	Fri, 22 May 2026 11:04:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=nZ3DtYU6oaP7UVk4P
	zUNWALcciYCvdSqiN7dJ9VBjQ0=; b=YDkJIrElHcESvSCvdyq/s+tbyW/PfsKyk
	gThpUMHBoMl9vkkaFWnlpuntxks4d0ctLgQlfhvfqDThvhgzeBpB20K+EKfvUZ6x
	y5A5YQgnmkVlkfCaH0d4ma6Oes8obi4esfwfIOC/5x0n2VjUWZR3f9Fe/DFXg8gt
	ZtuRmBDx/wnOKR58TLaCeBCC5w7+wEuXmRKJ4zj+2EAdcePiQS2Vz+I9DNrgKXxV
	otEUaDv0BhPjZdlnJ+qTRu1iw6WJwhSDqeChEi+n6kNeCNHOnPSBRShBFz5JlV8o
	wApNW4RogTwXM9YYE+AqpfFfpCmz/WZkkoMwpNc3LMtcmSdDyojmw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6hawj6me-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 May 2026 11:04:34 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64MAOClP016528;
	Fri, 22 May 2026 11:04:34 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e739w8pw2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 May 2026 11:04:34 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64MB4UVH48628128
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 May 2026 11:04:30 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1A0AB20040;
	Fri, 22 May 2026 11:04:30 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 99D902004B;
	Fri, 22 May 2026 11:04:29 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 22 May 2026 11:04:29 +0000 (GMT)
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
Subject: [PATCH v11 1/6] x86/vdso: Fix DWARF generation for getrandom()
Date: Fri, 22 May 2026 13:04:22 +0200
Message-ID: <20260522110427.2816637-2-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260522110427.2816637-1-jremus@linux.ibm.com>
References: <20260522110427.2816637-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDEwNiBTYWx0ZWRfX4BqTch/7Mj+8
 kAZpiYCTGOZDyxkqWln86ZtOJ48gEMWMoZRU5qf1Ldy/c5FS2Z1AtL4i/N86S9PqpN+V08e8a+L
 XaLxDftNT2EBsHdkbreoTCiqIsx1fCBKs1/AppHnijwLXRkxOvNccJCch+fuNcqaVXmzxPYh00X
 OaIW+KmswmyQBV1kvJt7mo6WcS6pTqqLQOQo22lnynNcHhZZPM8wlbfq3TLRQK5sTJ8zwCtj7k8
 dJ5fYe0zPPMKLjRqwkue0dSXutnKW4NnDI3CcPyVUIGAl+Zgapm+EkyoECOlBCCvULcJYprkxO5
 SmQjwJG2ibG6UA1GFZWO3KA8htG9tXHx5Z7jZwBQ6YCG1Yi5WRCzwq5iv3cmwEdJ+FA2WaMlVHt
 uqtukrt/sw+IsHMeQ0VK5QDG4dbqWpBxCuokprF/hVoTW9HLQP0Mh7A13QFZTg5Y6FhlzxwdKqI
 dZw+bfzl80b0ldPgP0w==
X-Authority-Analysis: v=2.4 cv=Np/htcdJ c=1 sm=1 tr=0 ts=6a103843 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=oGMlB6cnAAAA:8
 a=VnNF1IyMAAAA:8 a=rsc5PF6bQGhcUx5MhlsA:9 a=2JgSa4NbpEOStq-L5dxp:22
 a=NdAtdrkLVvyUPsUoGJp4:22
X-Proofpoint-ORIG-GUID: Yx5JGHNjDzLT1171h7_5WS4ppUYSxoXo
X-Proofpoint-GUID: nP85tu7wFetJHdO8Pmu6BOvWWIK9exl6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-22_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605220106
X-Stat-Signature: 6e9apywxo81ksi7jwywoaj7w3y59sq7a
X-Rspamd-Queue-Id: 60CCC40013
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779447900-839965
X-HE-Meta: U2FsdGVkX1+tBRX+5hEZ3PGCvk0Pbj5pQSGEwrQNG8LMiuxaiaLVpUdza9BwFxz/9VKZw6B+WTxQOvJ2EKpB4rSLGdt+eRrKuOgdnQkQ8KZPUPnfzR0hTy4t4SIJM6yc6zZD7+IC7vXBOnxqnNm0b8U/iLK7ik6ui6JmMPFaMrpuoH39eQNqJbF93mXlQa4a7bGMfix7Nz/s8RcKA/men4eBR1DNa1xxl49dpjBWAx36d/7pIy1RQ2PtQKMmMmq6ulHI2rWKmgIhDtUAETF1AY294E7I7kxQ4+XhGbHqihji2BQIFrqurU8n9EiXV8snNYnnB0WQnz0CYbNb58+0iQd0H4tNfKsm3AxuLtaFtaLTkriWwnZqzteKDYhUFt8ziSpRTksFAtEg5dqhZ6WU6fuXJHruqrhyFY+7QJUENi6HGeTEjPGHrtcYAik4cXqC7W+Hvya44HGztGOE0NYDAsfAZWTrkhfe/FPJNkLk5fKuhrdcXCxwokfowQbAg+LTYGOZqVM1djz9IfbPQ5qtPD315JJttj7GVvD8XKy4aXhgn6H1Vpaav9ODYJKfauCWhf2t8csw4X7GfVIZEshnPh2eXF2V/Tg0Hv9+xgXB5F49fJB9kH9Bx6W63YkrnZY69Fn6Wk6gWy6GhZCTsfDoI7JwbfRnXtctwJKqJMpyhkO/zeRXDzvf6BqRinzHOIMJx/bf0ZUc/pbFR9R8ezTo4ZlH7trQmNMjNXI7gnj2go4sWooRBr3t0cnZgWDn7GSX8eGsjOJJhkDUYKA7lfimxoQLI05jJWL/gcmBxtyt9B6okWk34HL9mJIWJc7OJ8DjeJQZhR4csq2cSwAZT91xXH73hxgTsDnRW7/xbQZri3TkGk5gaKFFXwcp3eAwxXzs1zRNGhovbE2D5Vo5czPlfr8KpeYuimETj7Y/HufjmDjctMVtff0rwhD6R/rZiuD+ViMckPIP2WE2380c4Yl
 5g4bS8NN
 8roRGdI3og1eGS3uo2zLxcOoUcZm1GuvbEld3XQuaLP7pdH/21nDwy5jRocPsEtVb9JSy8P5R3wua6vDP0Pnncw2CBIFFPMA0+LdM79txkBFMnRXmfq0w+SuDL5ZR2f9bQTP8y3maqp/uaWbQ0fdBKqvZK1uYgQWXmQMpPNG3NSWQUu8BV93ISfL64HqWcVIroBmMsJU8BSyb4gCu3WsCplCNsDBGlhBciEbLZkIoXjvmzol7cHJN1AKW8oBx15bcpjVYMhvIxUGkizhdkN2iVXjMf5dmLdcwZ3o9oLC3hfF8sEF6GJbMU8sG/NlhfF6ChB7MwHPhh1JcNc+gKwtvcWAw9A==
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


