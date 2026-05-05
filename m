Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CE72FF885A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 12:34:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 369856B00AA; Tue,  5 May 2026 08:34:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 319776B00AC; Tue,  5 May 2026 08:34:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BB286B00AD; Tue,  5 May 2026 08:34:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ECCA66B00AA
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:34:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A87B01A04A9
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:34:11 +0000 (UTC)
X-FDA: 84733308702.30.1CADAF4
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5E39C160004
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:34:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=jMWdBP3m;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf08.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777984449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nZ3DtYU6oaP7UVk4PzUNWALcciYCvdSqiN7dJ9VBjQ0=;
	b=VDHAkibjxnUbrAreO89GSAZcHN8/MD+8JSbKQmyznO+egIL8lMl5Qv8vWmJSMkoyx5YghO
	mTu7KoyWzcgeAdBDIFKmRAc/BDToHbrV+web+I3L1khYzSfQ2YFQfx++VOC/M8j7mjgJx1
	zgwpY56BeILXly/UVGQyKreBvkvjDfU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777984449; a=rsa-sha256;
	cv=none;
	b=ZAB/+R256dPhEhFiBFHhXuuhIpqrMgaS81Lx4kVn1n/yUM4LvChLkJfEyAEBBGFKLM5Iet
	BXH3c5nDVK0Am22lwwAyRxS7sun6fB+LMQvK+IKG+5vtqSDb+ejuK5IUkRF2RBupYFpF7C
	7v3WUUn20tvbTg7apFCrT8YlTTfwRAs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=jMWdBP3m;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf08.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6458CHe73828299;
	Tue, 5 May 2026 12:33:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=nZ3DtYU6oaP7UVk4P
	zUNWALcciYCvdSqiN7dJ9VBjQ0=; b=jMWdBP3mSv3PeOeQRl4pm7AB2L3LS00K9
	WkkTLydfu7Rlw7brwMLzSzyfHeZ2AGOOx4c5JRoNFe25rAXHUTDe/5FH3S6ZGIHu
	cJfJfagsP3aM6CvnH/A/ohryiUCCoI24lvpazMu0Ze5I77/L0IBZpmax+F7OSubv
	jc4QYz7jWtAGXK0WX4HJLLx0WDI1AMsckkfabnjYS1goQpiXJjCmJ1zAHiTJ74aR
	SMsehFzgV8eltn6Qu7ckrAEDRjrZcTfRHwGVuNdcAC3jECSNZyQhQCVwODklJ6NI
	KHuC4pUfZlS00TfX98oZoXONh5gxqzosZVBIn0B8TSRY/KRQ3wiqA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9xxk80b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:33:47 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 645COOav030967;
	Tue, 5 May 2026 12:33:46 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dwx9y9aq5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:33:46 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 645CXgPE41681376
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 May 2026 12:33:42 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ACD552004B;
	Tue,  5 May 2026 12:33:42 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2FCCA2004E;
	Tue,  5 May 2026 12:33:42 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 May 2026 12:33:42 +0000 (GMT)
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
Subject: [PATCH v10 1/6] x86/vdso: Fix DWARF generation for getrandom()
Date: Tue,  5 May 2026 14:33:35 +0200
Message-ID: <20260505123340.3770025-2-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260505123340.3770025-1-jremus@linux.ibm.com>
References: <20260505123340.3770025-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDExNCBTYWx0ZWRfX2GRnzfkZK3nF
 QDtkHe4+WgAmmsutPIAWoCB8RgyNwGDI4TzKmBtaFR/xVVaZ230slWJs2dtF3CB1ZppjGuyEpyG
 7o7tZuOSyHJszsu3wjMTzUSVuE2/8+yOWgMmX96zOZ0X9RGZjyiQWfyqW/+ULfYNYgbnVlfB4d0
 SdC/BBIC5F/NPj7ZwEgwIQYlEFepfQxSj9rfsKJOboK065dNCL9zzzNnQ40OFYk1Hwp43DUtlsF
 QrLifpnCRaZfVjoq9mLtQS0gCwBXC0e63yhW+T0CBJ3oUR9e5zqjOncFIOoMpLpaEthzc8Jnl+1
 nhNE0EGTDsCHWvnfd0Q7R/U+RhJ4HPkAS5lg8kIVCbjXZYQRkn799zfIFVlaHlmnOIoZqS4d07i
 NBqONMKaXZf8X79kIHiDJKg+kGuPlWlnnrwNDceS0mVCS6ugsUfeSZW5DqIRCruX0RfvsyJKw82
 Gk63x+Scd3ZVh7+kI9Q==
X-Proofpoint-ORIG-GUID: R1pcfcGcWaQmFvKCckkQUkBEXRPT_U9P
X-Proofpoint-GUID: x493YNJDYyNO_h4WMWnoSuua8T33_v-k
X-Authority-Analysis: v=2.4 cv=ctWrVV4i c=1 sm=1 tr=0 ts=69f9e3ac cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=oGMlB6cnAAAA:8
 a=VnNF1IyMAAAA:8 a=rsc5PF6bQGhcUx5MhlsA:9 a=2JgSa4NbpEOStq-L5dxp:22
 a=NdAtdrkLVvyUPsUoGJp4:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 clxscore=1015
 suspectscore=0 impostorscore=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2605050114
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E39C160004
X-Rspamd-Server: rspam04
X-Stat-Signature: 4o8ew9nqzbdj8prhq1g4pdeiqh3cp5xp
X-HE-Tag: 1777984449-126142
X-HE-Meta: U2FsdGVkX18nuZaSnEzAEhnI3tknZH7/5UZShmVNj/jrx+wRAB8cV8PGX2FUhmGXCm1Lkvo9r71qVCG3pATVkdEWGaCna/S9TAZA17F7ourxcFmL9Mrj4ch5PvOAp3Ad/+oWDMHOPAvLh4t/yO/D9p7ecIDYYcXWdN7PQXYb3sZz6TR6CWEgkjsfJGo5Q/NVCi88US4rXLuGYmq6xeAXjm0cDThapvKOY0Gal/liOIlApwoO9blADUqusbi1H4IeAZE3UYOfWqPf5cHWtaXI/d0d5tBSoYOarGQTw1zXpW5cLDxbtPR0F2E7OlOWVFDJUN7rgJWwgx9Q04tJVP/146QXEPsr4jmDpiPmrI0ySfaqAN2TUS2v2RMWRyD/7dfp2eBh4WShpATUAfIBKsvBafPMBEE45pgO+fjS0+EOZar/b1wHGmIGSnqFAwMK3b/3KBd4E0CuMPiAvLDMTjYdAtIF7gl9YuxVSBPk9GMnGQGC9nz1+NfrFVOuDoSwbx/H5ccqk4s/t19Fqenlt3mEzlW7ImTMIWz/ijXr5yvf9uxDoKJU9D1IrvrBGGFzyn7Q+OXSUzrQvLZwDmkAGtchVx3Y7r75nU5SGS3fhKIFLjpM+t77tT0C2yXOjld7vbjBLOA67piGfKO+Oaoj4aA1ckYgQQ85pzqVqgF++BdDiltsmXuSj63GeLP22bIuKajygVAaAZpS9ys04efmZgNHZHEHX4G9QUieYCyHesQ/YpFQpAkp8RoFC2eoXitqCemad2/jeZYPPTlcIyr6Jxh1jJciOVjtwL37PtPXlFQ17h5wa3FD3TBksV4Zo6iEwuNNYEyEZIrjZ9JbqSb8J+AYuHK179sIwQMC+rI6itmgxT636te62gwt86Z1pCghwK0PlwEbE1dHSVFMoZTbcYjb7wKvh1AnmeRPuLdvUx2p+gbHzDvXSfSlSOGqRS2pmuTFUgP+9qpQQuDJ+I2Btp9
 Ew9oBZhk
 qFuRwJLP4gEEeEEQSr/Mjd1cJy7f9Ott/m6euSegsGTHCxGzOPkVbI81AEZvRXJvBEtjnCJ+I+V+WhAsI+d4gIwA7neGrqMFdHhoVfAxKKb9jel8wDV4V8q0DFl3ds5O9DXCloNm0JbRB6q8+ZEgk6PCnY+BbCafGlsgnwyV6YimGq0yNoYnHa+4SZFFVSSaghsvRvVdE/qTGp/Lm09hhKN0a+yBp2kF13d5RzTCHJXez7zkDHh2HbNMQno1LdHaFx2ociCKB/7HpdsX4EZBayN477RUY0cOmnruKqfVC1eT2usvVTHG+HQotHTw2hyqDha2VNeSNDAQwCxppr9UvTwlu5aMYCgVIfOY7aCoPKmwaa9Du3hQI4Q+Zixam/NUT964sJwXKOoxuZs8OWFRMzWX5M5IaNhDxUTXcXPduOLFZ+00kF2YWFp8glA==
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


