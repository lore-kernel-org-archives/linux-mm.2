Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AC3DE9E310
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 14:14:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89E936B0092; Wed, 11 Feb 2026 09:14:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 818996B0089; Wed, 11 Feb 2026 09:14:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DB506B008C; Wed, 11 Feb 2026 09:14:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4CEAE6B0089
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:14:32 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 087C358BE7
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:14:32 +0000 (UTC)
X-FDA: 84432371184.25.4E56DAB
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf15.hostedemail.com (Postfix) with ESMTP id AFD4BA000B
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:14:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=aX6wkzsO;
	spf=pass (imf15.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770819269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zcp5Naq2FPjOG1kV+prJJdfvki9PYjEAiotKE3UfUD8=;
	b=Y66g3J8qufAJKgBnmcmaxqnIVBLCnZFhhdLpAxb5AkcBU6y2mykProNxDo40O6jh3BgtA3
	dAzopOgE6qvTGftyEETU9GU++Qnk8S6L+OVkRZhhESvuYYr4P6huSKm9JtnoZeXs7SJiwW
	tman/pxXDSD1g1RFLwpWAjgI0o1xj8s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=aX6wkzsO;
	spf=pass (imf15.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770819269; a=rsa-sha256;
	cv=none;
	b=FMxX+KLNXoJUQftgm7xgy8vtS/5frpFnmYYO2GidNhvp5Eb2uLYdXZEkqRe0TjRhnP/iUP
	W6MwSqGoiX/Oysdl7KFkAH6XUFOMh28XEUlvPsDC2/zXdue89+uOuYA3XiHmnDVosNuU/N
	oPAEwmlWAM5B+perWwos0tfn/KEBATc=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61B1m5jN565607;
	Wed, 11 Feb 2026 14:14:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Zcp5Naq2FPjOG1kV+
	prJJdfvki9PYjEAiotKE3UfUD8=; b=aX6wkzsOomJrnSmZTnsjodoMr2cJgje9G
	neRJdVXnwNsAICQIey5kLmYoRnzsSmWGdq0oDBjiCsqyu4B6QsZXiK+EkLEmtv9s
	gp9zKxXAnPfElnNdgNYxySwl8/7XORzEvkNKfmPRl70HWXIwGcw6qcjxKzG+5xr8
	CFy8V8L7hG8qAorXM9ZAJl0cWVcN1NuIOMFmgzqTo45/cWiHthQIyI6u9baR24NC
	JVZ148EOh1IIRgOSYfOkWmIHsIoK8f4ti48UKdJZx4YaVu/Dwib0XVF1zvx/FIjL
	Hv8xURBqOGa91hvNL09m2SPSTJmlqu/HAC5cbO3hRUF94CPZEL9aA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696wy13y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 14:14:06 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61B9v0YZ019277;
	Wed, 11 Feb 2026 14:14:05 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6hxk5waj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 14:14:05 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61BEE12x28967514
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Feb 2026 14:14:01 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5584220040;
	Wed, 11 Feb 2026 14:14:01 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C61F220043;
	Wed, 11 Feb 2026 14:14:00 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 11 Feb 2026 14:14:00 +0000 (GMT)
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
Subject: [PATCH v9 4/6] x86/vdso: Use SYM_FUNC_{START,END} in __kernel_vsyscall()
Date: Wed, 11 Feb 2026 15:13:55 +0100
Message-ID: <20260211141357.271402-5-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260211141357.271402-1-jremus@linux.ibm.com>
References: <20260211141357.271402-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=WZYBqkhX c=1 sm=1 tr=0 ts=698c8eae cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=oGMlB6cnAAAA:8
 a=VnNF1IyMAAAA:8 a=lbqDleH5ITP0AWbVeFgA:9 a=2JgSa4NbpEOStq-L5dxp:22
 a=NdAtdrkLVvyUPsUoGJp4:22
X-Proofpoint-GUID: kz4-PgsEcTSzm-2r0wzqb-Lk3s4dyfyA
X-Proofpoint-ORIG-GUID: O-HOHeIoS3U04pkYu2_SbRe2Ovc3uHRr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDEwNyBTYWx0ZWRfX+Eyu6SdqHHJY
 OnDHDX8s6SkYNUyTyuWAMGkV+wFFcvS75c8fY5jaUoHjOPJ8bn/cQRJPN2ALRxeGbShs1cdFcWZ
 H9UTcg2vGHAsnkBOtn/kZE1STpq05s11yUFOqFPCNMyi5F0eSPK5TypLqeaoswFGynJE6YDOyBb
 7QCVhuNAyqWYaGiS3AsPooE5qDpItfFxdAy8mTfpxPbELI8RM9X2mnBeopUXGjeR+FcdsOJ1bX3
 gY+GY3APOnbaRV+IQf8ViygA9vXk6/gLLHLQdI4brNZ/QLjNWc3xCsG056Z1iCdYVPvniqG9bRF
 6OR62eLELk0N2lW9liqlHwaMHhtVfJOhdQm6aHRi9lNVpqDQi3vGFd3kSh0R9Y/apLGXaAeO8Cj
 e4sWWsBiKu1p5yZRs7vqY6poa5WS0tWQyYsnMunhL2OVd2sBGc+aKlBoGqmnIeo1mcZFfH2gSme
 xmbh7DTQIFuVXTtKMHw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-11_01,2026-02-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 phishscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 impostorscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602110107
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AFD4BA000B
X-Stat-Signature: rmq6xs8pp7tfsg9jzbsuu8oarj9rfn8b
X-Rspam-User: 
X-HE-Tag: 1770819269-285409
X-HE-Meta: U2FsdGVkX19VBJkoS856vRVlyEzChx/pHJIDAIlm4XEAx+6JBcHi48sVfFTJZSMAMbXfNTBPUwNncm1DzFQCQp8Hfroz+3ZW3rgKOkMV7NuOgD/kN0nNa9SVPH0/joKVXQLxUbijaIe02VQ4VIDyarxU9hc/BSfe09Zui0Jl/5KzF59dQjI+nT4pRyG3GnHgX3POUEyI0lc6qbiv2Y+kDlkz8Qu/HE+6XTiADea+3WXiC2UeNrY5FeE3iWGWXX7f+jBUKjZlzGq11ate3dJNF9vRtxBBGJpRJOIguv1vSDAjpgV8/vQpp0F5HLTYjHLDXIGKHTF/57v7xLXOag777V5/EfxN5FGmhwSMho8G7zn03wV22cJeTDf9JmDS9BaLoZ2B6xVA1NpW60/qC1+QK7Au/7tD70inoT4eBYnR4pSQ8sP587WCxDqez5CvJCHyALEFOJv+GyxlAFzTWoRoSlLQ8rbYkNclwaZ4C82uyOFJRvSl15hnuXL+F4Xk07INIoAkOsF3FBwQqW0HNoS+e25GJNtIbQ1eTi4cSAXbPZ7vGPm4bXdRgHFlACqfrEU4NmKItYwz9I9uKNOYcb7Cyv+/WYjcR1ocfsUtjeGgKtT7yUZHDlZVEAWfcI3DnqRv0359tuqSYpXke/Efvnw8QQpxnjAuB5Ao34XhiiVSvtABC7zc2FDVUJKivipL3Vzgis2mKkU8VM3bFC8OxNJzOE5A3kg01E+VeWRfj2Q72MSD61RhKZgWFb9GodM3xhpGuLKVHwH5UExEuqWpFcCQ8gW/C5WKDaAx5yZc+ZKLowROCANIZv6RYZWFHFxx2XMXLZLA04NA6/gu5YF8wMFuOVHv6Wa1sFY9hrbMSg6o+4FrU22O8Ko/euyUyDFD0DT5bdvwKJUrD+S63pmmOImQkTmy9CXILrFs1ZFLWWEh75T0zEddtUN0QxDiITcIHRvcPYCBmy3H/mhVmTeSpx/
 FhNmkCDr
 TpynoxrUCKUZj+Gp9eWTsA2Kskzf6Z/k4iOMFPYb6NMACEUK0QvJaXuR3Rp1WvsYZHckvZoaiMBHhFVBjg9OREQKHNlotPcv9eD1ue4KcW7b4WvJEbFo2oDd72LaZzLV9P0UlC5aRg8lnJ+N1p9p/aclPEPvf/uX8xm9jnaetYkvLYzvvGlJIJi7yFWe7WPlDo7nBhSjOoMhzaR507P4VuoJRg5RIMHPKtK/fOGxYXAuP1e1ZV+VDAZAOV0B8Gs3bUg0+0scTRmZXPZSFz6SlnMLdRQyvG0q9DXI9gF1Vudu97N3tzkbV3rkm7T8UGDCoQ2uAYitIEtjOvNpPC6FR4Bz3r2zz6/dedBzobCkbI5etGOcFpByXhyTO+MjRa+1UNAqh7NBOIJ183GLGAIzxtueLT0sNSAhAdxu9DyyWZBzvupxGU+JPbNEvFc0AMC/dORIFunVthkbNhyv59fSrKZcQA9UOUX7c/ciYqYPDQPrur1c=
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


