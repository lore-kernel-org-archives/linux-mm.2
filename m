Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F27CE8784F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 17:20:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BF8A6B00B1; Tue,  3 Feb 2026 12:20:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57D356B00B2; Tue,  3 Feb 2026 12:20:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43EA26B00B3; Tue,  3 Feb 2026 12:20:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 302096B00B1
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 12:20:51 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DE673C1DB5
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:20:50 +0000 (UTC)
X-FDA: 84403810260.21.2DDF0DE
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8E712160013
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:20:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=bUPLywio;
	spf=pass (imf08.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770139248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lXwp98bz1jNqiTbUTxZsJVEJQVRp/j5BkYY+Xsqusn0=;
	b=SKkfxJQMi6hnd6v+XvG4gJQKpPwdflYIlYf2Xu7Hfp2i0IzavyCImmajdFxN6rvuZ8qy3X
	+iBlx1vr2ZoNbk/wEIHPeIJ5qbFQ3xEKGtsfxfnEqPfEl34qCZUpnolA4fZ4REnTg7vvYU
	U08T/Qej+mqtEbadXZhl1+jDUaON8w8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=bUPLywio;
	spf=pass (imf08.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770139248; a=rsa-sha256;
	cv=none;
	b=qE60rDrA+n/5MCKWdM3jhpfUUoWiRszr1nldsW2rhKW0++5uxEmKV8m0cp7CnxcO6lyR02
	A3fJNEygKZYMHETSD9XZ4IDHeH+PalLSG/vFeOGjj4hQqG6qd0kvcs3CmUQPLFwgsKgpbN
	AXCfywiRcQiFrbVVtGsTS1eT9370hIc=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 6139rVqQ009325;
	Tue, 3 Feb 2026 17:20:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=lXwp98bz1jNqiTbUT
	xZsJVEJQVRp/j5BkYY+Xsqusn0=; b=bUPLywioYo1bsk6VaCGA8tmJWRfVrIxeG
	2WwSeY3Zmtuksdt1kFavMmo8x0HHIEuPfaATmFlKBn372VB94bRokZR0ec9s4uon
	FjYETRxihZGIu+7MCEJ8LzVoNTLt9JC2Kxzj98iJQERA4dLfavH63Tl5jzTvKRdf
	2Kv0RoJBtKzSMck5YPZbtxYEL/v8WZ+fTIuonO0hUPCgpObF0+pQmq8j84r/k98p
	hfTg05xOMujccAxkf+j1aQXp+wizNBZLhb/yHsl31MJz8eswdqF4YkrYPGfKYgqW
	8xwPzZZ03ulskvtfFfC5ftKxWdnwwChZOBmAcg+C3wBy/SDqs74Fw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19dt6euv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Feb 2026 17:20:06 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 613HK6cn020223;
	Tue, 3 Feb 2026 17:20:06 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19dt6eur-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Feb 2026 17:20:06 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 613G1rd1004405;
	Tue, 3 Feb 2026 17:20:04 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c1wjjsx6r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Feb 2026 17:20:04 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 613HK0JM56885646
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 3 Feb 2026 17:20:00 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8571B20040;
	Tue,  3 Feb 2026 17:20:00 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F3AC62004B;
	Tue,  3 Feb 2026 17:19:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  3 Feb 2026 17:19:59 +0000 (GMT)
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
        David Hildenbrand <david@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v7 1/6] x86/vdso: Fix DWARF generation for getrandom()
Date: Tue,  3 Feb 2026 18:19:52 +0100
Message-ID: <20260203171958.1522030-2-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260203171958.1522030-1-jremus@linux.ibm.com>
References: <20260203171958.1522030-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAzMDEzNSBTYWx0ZWRfX8hGbLWMlJYO2
 uAMkK636Ieq+3YBBE6OByGiVEW79X8cUeztQBiGBEga7Umyn/C7wfimSvjdOekJpq5Emi1rtqn6
 rqO9dGxd1bWA7u5mXjjc+AP3jQrfj/6P6JY8LWC3gVgYtCfVmlvX9PejxzFkL+BSzoxuaD8Xfky
 R1JFGdy62SB/BlyMaaIUuCJ5vk3YLkHmdiA2xV+d746MBGfBJJTyLpHueZLt7VY+3GAb29UtLh0
 eNVzrALmYf0q+AH6s0USLViKTyE2RR46kAACa7mYv+DYkX5nMz9miTkGGLX0KVQjHFcW2DuJfcC
 qSjLX3A7Kt65oSHZrRwi1AcfNIbFH1w6aP8/MzmZVCm/RJywRYMdUee0g/1KImKIa6IXlE7o6um
 CPB1OUWtOuXCUSymlaWEQ2F0yfIl1Vts7PsHWwAuHSwNVpL80vfBPyliUM6L77K+tip91YL4aOa
 vFsKmN8MS12a0dSr+Qw==
X-Proofpoint-GUID: iHJK-QciKONg_XCCBDJAe98iWK2gGu_8
X-Proofpoint-ORIG-GUID: FrRdoqnxHFk_aiJG8gIbpgNhX6zHpsZr
X-Authority-Analysis: v=2.4 cv=LesxKzfi c=1 sm=1 tr=0 ts=69822e46 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8
 a=VnNF1IyMAAAA:8 a=rsc5PF6bQGhcUx5MhlsA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-03_05,2026-02-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015
 adultscore=0 suspectscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2601150000 definitions=main-2602030135
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8E712160013
X-Stat-Signature: ohhgcsjrdkxic8bry3zfoiugq3q5p93e
X-Rspam-User: 
X-HE-Tag: 1770139248-538060
X-HE-Meta: U2FsdGVkX1/bHxL406pMbES0bz0LJXq+FRLVcQ7bAMswb0H0v1tyhGiG1bj8YG6t/dKCkIQeD2GPIjnVbYqEMHUMkTFAUqDp2swBRX+zQnk2LOW9jyf1Jn/eAVHEzWPOXecOenCX3XhT/r0k2fYBbWvZtcioSsjAfzhVykOSj4HWfjCBCo6yqq64VxUqpcbwr5W2dNEAQwvARcvYTvhGvmMEpeZLzmgQ/IT/k5N5p/2iGxT1Jy3fX7NPboSgaSDDwvMFW5haJbTA5xMpkFP89CDZ3v2VMwfclS3zTCBQQ1XdJfDCOU5I7ucLwilELdl0njaT2WsADgIgjDouMizTt0SkHvk1hcLl3p8vmhn96X/mITmBKG1mW/B0LTyitLxcUMvme6OsCgcDrkqQf9sCymU5+uLvOkio2Kvn2WbNUsEBY0fwWVa9PkjjhReZ3v8UKbSv3GI7UElSVQ1uwAlFLmwe7X2FsDNFnnZGz7oqjCtpao3w6/wxtikR7x7HDloORIxlO5iX0pwofReoxHVSHq2To5QIkVzG4Nh/4gTCwW5kLwXaG7UuQPnNzh5fSBJxe6ZS+w4XwqWz9OBHtgSSAjah9nAzaCE89LL0GzbD8Vlguq81Yi76GGzBRo6i9C/OSSBI+LGN098PfLp0eio4Xi9wCUSoAn+VTDkAJFtdxpxzHG7DPqahwTTzv6sjP8r6nZFnlbN+42X9JDNp4vCHNXy61wXPPcDU96oe3Csn+AMxAOJ5Ow/STfkfpc68RlBgv/x6X1ZK8eWgQZqToJe7IW80GBvRkKR5dh/Se6tSsej+kYICzx503LLUuH8G4nBel1uNkvw6sA1HXbrhXe6Ga3lkxkzLmdhWTKonvMErqpxdUuedQzABJg==
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


