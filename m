Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 602DDCD5BB1
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 11:05:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41FD06B009B; Fri, 22 May 2026 07:05:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CE9D6B009D; Fri, 22 May 2026 07:05:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FD636B009F; Fri, 22 May 2026 07:05:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 096AB6B009B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 07:05:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A5BC71C1D76
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:05:04 +0000 (UTC)
X-FDA: 84794773728.03.319CEE7
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3FFD44000A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:05:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=CbRzUMcy;
	spf=pass (imf07.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779447902; a=rsa-sha256;
	cv=none;
	b=PsiFWVjZjZ/vRipQB6WOakrSTC/DRysiyZk1rxZG/BSEuG1ljluqQdIZMFzJGFLl+h9IqF
	2wgrTQ0/+rlKNu/WhLDzbqCV48Se/SxN4mK7kfWIGSoArKuErZ015C1OlRzHYVOhhm38WO
	B0QOEam+e36SG+wxF7pc0Cjxx39mdXA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=CbRzUMcy;
	spf=pass (imf07.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779447902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zcp5Naq2FPjOG1kV+prJJdfvki9PYjEAiotKE3UfUD8=;
	b=gHiFtMg5GNFnjzSkqLP+cEGYmCwIWJrocV/paSVDX0OGol/ZiPjPS8hww+p4vGwHRWE1CU
	LFtvHf//rAYBGvFdJ9Zfx7NRsN6JXwUvhq/nsJbkv/YAWmcmsEZ4ZfwkZ0n6XEOgWniC+J
	RV4TmyH4c/zD73evGdPSGgGFW8iuFbw=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64M8gjpX4104744;
	Fri, 22 May 2026 11:04:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Zcp5Naq2FPjOG1kV+
	prJJdfvki9PYjEAiotKE3UfUD8=; b=CbRzUMcymi1aDcsKkdt4nhhI4Uwf3qiA1
	HpBtvV7GbVfyk4LYRjyOvEhNirakl4a2CpmaC5Hqtqvr8xiqmuApsRhlti0vrd4e
	iY9FJjrbF8TiRFnLl+e6uEjRleb87DpaZn71Ubd7XNppBqGWak6Zpd5VNnF4PB9r
	TMVoH4sorDu0Y4gLVPI4jaTnE4Cab4nuIWXBuW8Sbp7lmNlMNYyeA6E6Sv/X5N3G
	pqAlvOxuc53N4utG5sBnjqUJSfwnBYsSVegErwc/3HWJl3AJcRhu0bSQc/MxsigX
	Y1/tffNfzggjdT11PK1Ne2MYw2P7Dr/nqC7KHa59RFbyU/o+0XrYQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h9ybpy3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 May 2026 11:04:36 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64MAs412023355;
	Fri, 22 May 2026 11:04:35 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e754grbvx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 May 2026 11:04:35 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64MB4VdI53412240
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 May 2026 11:04:31 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B8C320040;
	Fri, 22 May 2026 11:04:31 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1C04720043;
	Fri, 22 May 2026 11:04:31 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 22 May 2026 11:04:31 +0000 (GMT)
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
Subject: [PATCH v11 4/6] x86/vdso: Use SYM_FUNC_{START,END} in __kernel_vsyscall()
Date: Fri, 22 May 2026 13:04:25 +0200
Message-ID: <20260522110427.2816637-5-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260522110427.2816637-1-jremus@linux.ibm.com>
References: <20260522110427.2816637-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDEwNiBTYWx0ZWRfX/P+uhVtwQr8m
 jhzMNaPEWoxj6Aqb0Z2DWWrXmNUy1ftmdFxyoj8e/9okIXSBVlSgejEHULeqLn/u1sP9OMOTy1G
 8mT8asYURR4ixiKKjicXsZ74SLZQxc/+4r0dpkU9PeiWGe8Diu+Opbg0CzqEVBEQg0mMqSk/pMs
 zqb7lwX4Vybr/bccO8cJ6PQb/6CSUXPdnDuq1FVgSfHDKC5BNfpe+ItQQ4n0hRZ7qT7OPS9da0y
 /1F9qQkVPp2dR8mai4arUnYrrc1g+pI8zx//w4YoB2XQS/+cgJCgoyeVy5Ud+wu0Z9E4IO9O//I
 LjnhswJblw8RQ0IPBk2+5H3rRNHgP0piy7bYEPduxIb2oKKq8HFFD5K7NtjNH3Nk6tDKs9xuJv9
 G6uwntNAoCTj36tUH+5jHk4hHX8EKHe3BM2KEHWLRBmy5+psHxqc6MYdOmYsn+KyGbpqajcbHsC
 WeSo6msJrgvQcON2EcA==
X-Authority-Analysis: v=2.4 cv=BNuDalQG c=1 sm=1 tr=0 ts=6a103844 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=oGMlB6cnAAAA:8
 a=VnNF1IyMAAAA:8 a=lbqDleH5ITP0AWbVeFgA:9 a=2JgSa4NbpEOStq-L5dxp:22
 a=NdAtdrkLVvyUPsUoGJp4:22
X-Proofpoint-ORIG-GUID: V04qTLS_ndhFQVXOrx3v6E8pDtAyfImf
X-Proofpoint-GUID: qfbfDGJSQ5fC5_k0WxLQ4DjWXQ-o8VtO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-22_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605220106
X-Rspam-User: 
X-Rspamd-Queue-Id: 3FFD44000A
X-Rspamd-Server: rspam03
X-Stat-Signature: 3op5fbwdd6w859ip5k6pyh4zyk636ryr
X-HE-Tag: 1779447902-329266
X-HE-Meta: U2FsdGVkX18D1STZqH6HmNwRZTrTXRU2QB53UB/1j/ZZWf6vshREXxOvceFrOGv7AmNNucejOFtDW6vpgy4usXfstRLcfvzT+WfVrsA6uiffBQqjTC/WaW63Gd3EC63kBmxPS3lRzSpeT0vkC8QDjvlI1SVrL283cpm5uh0oqiG9tz98ShABmGU9uPxV91sIFBfwCEL43f6ZNQ5L5bchWzxve0WWGp4JzAYqBJ24gL9UZ7WSE+xg/dKLa27nSQ3sBHbj9D9EWruo1FYKKOAxeJ/0dPj/YjaS37x6W1l4Vp59bybQEEwEy1XPcbmO7bLAchvJCbArAiu5/cIqxbp0QAb0XDkoKnzI7x5FYmms9WsaYkeDL/Cr8yCAv2ODqNNU/3dE7yMEj3rn3FUMlnBCTw8HZ0M1L7S++vVdVhOudVGjLtJ4Vic6cHYvfSNunAYaIpqEFOPOe0DoCktkAfOzebqblDUQIYiWkJfSl0IaMJQG4SSv7jqyt2tK99RQruRwee2wo6zbBE+L0h3bSOef3vCgo+wRwWJhAU6xLN+88syYOio9KaEVxD8bxqEWeXQFJp9Jp06y71aXjBDl4n13u/Q+yQ3ZEU3Tl4k6rT5aK8dDmEgxgi8yAlVPPbAaES/ZepR8JB2IiRLk5xjsUswumLfO9sbVbnkZhuJEQAK3fetI/GmVdY8W+sgN83KO/h/vMYFFUBi/5Snz6re73eRoeDCwgtKXhltmVnw8XNYoXnv7WMBnqXTitntpv1En371NFlEO9Nk+H42B1glXrmFXm8FqdajBUcUAjN/cPjOzt+QuYUw7jao+czEPL47dl7CP/p2lswILg6uO095/9zEmbKRsls4X6mr9xjDFFY1wdYBymO27QhfDjixfSzE2IWQ2YqY06Wyh2y2NBcPmsnoruVW51ZtMX4j/4yzjkFIHpYD0sr6sJvOgOxjKicbvh3Uyt/F+qrciCyrQZ2RT7wq
 Tpdhype1
 dM65jPAp+JppL3HejzRk/NI5ZP2qMaHXpSGjVynhInEOglXxpxWasHEH0RwJ7g6raPY+6YKkt2VBbEGcj8Z7LotmxrELeGXnOUXCdlRFnGFrmISJk1BLKIUC8nHPVlS5UG3ZTzmqPxBUcuHvbkl0e6iYx0K43dDogo2zxoKIPFFpr7dYlh+W5fvUgMU7dbS8qle8XHalQ8tTZ6aISqMob4H/4md/QAEbWidjbjyOEC2/1AFo0Hfsb1GPzAO86+SJGBJgbkCCTL5Uv21n6esZWgvBcu8Q1untsqQBdVgUC0Ul84cB2QwD3alQVyjRe+DoErRnhn/JyTq9JXOkMgaZNFzuiWGjH1W/HNNe/LTlN3VY+Ii4cH+jUD3bPd39jH36dJX+EQftUS/dvU4y8EKd2mpFdw4CH/rPL6qG44jfs45QlXbzxkSkbNEkYrv239m5UHxJNQUN51qdSLWVBcl2AgSQYLK/F2EEtjWm4ho5MoIaKeio=
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


