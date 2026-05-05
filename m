Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 494D2CD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 12:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B31C36B0095; Tue,  5 May 2026 08:34:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE1C06B00AA; Tue,  5 May 2026 08:34:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90D6B6B00AC; Tue,  5 May 2026 08:34:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F0E76B0095
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:34:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2D0D41C0FB9
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:34:11 +0000 (UTC)
X-FDA: 84733308702.10.E066235
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf29.hostedemail.com (Postfix) with ESMTP id A8F24120003
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:34:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=cHqo6+wg;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf29.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777984448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zcp5Naq2FPjOG1kV+prJJdfvki9PYjEAiotKE3UfUD8=;
	b=SwbN5meSMfsgxrg3TMIT9FUPWC8bkNUBWa5NR/nJkodvEQfgG3OdSNok+Ex4chmYvXi8sb
	UKGmqhzU2DVxFTe0wyHoqK6/UYgw2cGCFEXezIDj0wtw7SfKZdLp5aQ/1m0/7U4G7KkX4G
	NCD/e2ybAlu9Hx4R45YSkx0wZapGemw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777984448; a=rsa-sha256;
	cv=none;
	b=xOgGKoYXTK0/skPlBE1iRexE5yjN6RR6eOP2poRFZ15ZZKk+lI2hwlG+oFUHdXNoNdTzPR
	yl0/g2dEzksa2sK4wCgsrv7hP75L6FcloTwLIJyPYsyWLggeckru68v/rxhhxTa+cT5gW2
	vkKgkkCzR5lUv2HBrF3fvx2EflqXsLM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=cHqo6+wg;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf29.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 645AdpE01590574;
	Tue, 5 May 2026 12:33:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Zcp5Naq2FPjOG1kV+
	prJJdfvki9PYjEAiotKE3UfUD8=; b=cHqo6+wg65TLT8wlMUXLNWeY9kET2Rq92
	ExrSfHMUPlNSQ9r0ATQvmuS9pr1QfM6Fjyn3twJ0UnCpCzFHuRPwdMJcJsJ0MNGS
	zH+5HA6WZUlbF8JWvpPYbLf4ywM6FLjFuM5m7i7wqAfaqeNMfDXYFTgJvFS8rplx
	6w3rDdmqEVdCOhGQrcdz9Tm4JUy63lLWIdezTC/Yj4Z48+BwxFZpUJ3uWCOHyUAC
	EzQXbN6m/U1749mWwZG2kZwG6LDwWVn8j3W4i55zVT+eUSak289PWma7KpAHKL/S
	7m2ocxH0Aw1iL0Y3lDy2mowmxGqmzw4kyvF3It1+2EydLcp5UTpvA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9xxk80h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:33:48 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 645COUn2016297;
	Tue, 5 May 2026 12:33:48 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dwvkjsj53-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:33:47 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 645CXiwK50200996
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 May 2026 12:33:44 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2ECE220040;
	Tue,  5 May 2026 12:33:44 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B6C122005A;
	Tue,  5 May 2026 12:33:43 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 May 2026 12:33:43 +0000 (GMT)
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
Subject: [PATCH v10 4/6] x86/vdso: Use SYM_FUNC_{START,END} in __kernel_vsyscall()
Date: Tue,  5 May 2026 14:33:38 +0200
Message-ID: <20260505123340.3770025-5-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260505123340.3770025-1-jremus@linux.ibm.com>
References: <20260505123340.3770025-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDExNCBTYWx0ZWRfXxDMSoAGXgzYO
 vq72ttSVTmAfPDlZMmtjrN6qYw3na/XNuTmVHxJsp0hKzh/haxPgublgpq/0mnDlVcGuGx3RPRD
 jah99+doIS/RAbrVfLhfRIw5TQLK68uN5iec/6jezTEpxAwxFs9kVuKWCPa9bQb7kWStY37S+8w
 89lEaV2/Muw3LucNZisk9nfxVmnezb/ocN9bXsDQa0gOzOxdbu6U17c30WqbR8NRrpjNbmc5mE+
 FRVHxcjwGKq2DlQOSm8+D6H7OLvw0OVTlbkyQCwwMNnY2dTbeSA7i2tYFJAfW2UZ5LBug5omCvf
 Qp9vRB5jMv+5gzOVB16jfsLhnvpslPaTtWhISX1k8dQghA+C40krPofrR6+CWYD4fH94nz84JjX
 wTAEw8G0KaHGd+VgVM6uED6f2ZGuxNVd7AbY4y3KIOMiB308vWo/mkRZqw38P51XrtHYPiJwn/F
 x7EEu1eYhaJhp8hFeEg==
X-Proofpoint-ORIG-GUID: ASK8dr_FrGhfcBMP30XGKMQLlDwMWLNt
X-Proofpoint-GUID: NtM52iwUiEW0KM0daYxvmN24QhXJCd1v
X-Authority-Analysis: v=2.4 cv=ctWrVV4i c=1 sm=1 tr=0 ts=69f9e3ad cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=oGMlB6cnAAAA:8
 a=VnNF1IyMAAAA:8 a=lbqDleH5ITP0AWbVeFgA:9 a=2JgSa4NbpEOStq-L5dxp:22
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A8F24120003
X-Stat-Signature: rip6q78cfdaaxkfspdqs4q1c8s7x8a7o
X-Rspam-User: 
X-HE-Tag: 1777984448-559513
X-HE-Meta: U2FsdGVkX1/YNvfJahVkFFa1FmPS4IXmX3cv99AxVA19UeDS5VROkaOs8gXdNd0dIAG5nRc7Bp1Hsbwcwjq4+7FglvHRTgGf+5bmjvoqq4bEpWES2XlXMyDHRU4vS1WNNhGLSeTtRcOcKgV/oT6b+tiDwheHcLgdjaBQI16dEbG39JnQiEVWOG50hIEYZGaAHrlptIQSln3ZYjjN76xlNK+XLbacM2dnWLdxlPkP3dTVj8TSpb/bUPfRyDGfWTnJmuqLJ6Jdw57LQUlS9kKys4v0je5BXuDxBLpM1HpcG8COErC+30wcdKF1ezKCPorlPuZzLtLXHN9s+Vb8p0GoYqTWv+osp3NMi9axU5sHiVSv482UfD7x3w2rtJUasyFXgQX2KAaJNmw/LlD5ud7muLnWA0QMWsUph57TCgVVEj6j7kgO9smE89o5nZpXbU0zs+mm58uqi7irUJQFRfLxKcDmgAsXvJuAR79eVawDkV1zVfDNP/ToPYv1ICtDDtg4X5MVYoc03hEndWAcsEZK/0zX1ZutdN+0syaM5xSFKq15khYdsnlC6bHNGazsW/sBYx5R3i4FGQyOrjrG2sAB381LUHXBevGVIAGQ6WdY7DeSOz28qea4533R+/CTxZrDV3/RAUCuyZRYFMFuXS7GrNpF+fSXkZEkji/FMrOVG3TWCFm7FWni0XRmSb1sX1jCzv9MFKyay+/SO2brGfIGtFs/pdejbc2HCGGvP7dbQ7Plp4CRSo3vK+LrvzTaefIrXAZKHNqnIuxbwpi59Zw2OoZkXwWGWoP8xjXR+eN0dAOonru+pSkiI1hsj0SRwZpTWMh5MyRrNsYzjcyTev5qWvrAKhPKY+6gq7sDWjhJo5Ot/sTL36B1opEiJdpys+UGShIgI+p59GoAu97NJjmzfpw+yzHH2OepDyTNy4N4414F35Qn1jn08n88TdCwz1fuq1IWVi/ftCeXTD25kBg
 EEGiA3rq
 IX3KaMC0Db/TInrqA0yhB38ZaVft2S8+tdeHHEpat7WNHGUrRXbPwbw4jI37k26Tiqh0K75dyxgcNPD6JQO/lhOl1Fqy4SYVZntpyO4p3NrDxNHW1DgjWd2g2arRiKaSVWAGJNOv+sTUnR1WDx8KpsDD5M+JXI0jIa4xyFAnKFTu8uYDDk/urilW44RjxVF0ESXr8mSsIKQitnorgQBQRFGt8WUxqVx57v6xQZC7Vfmc83cDN1O7FBMdFqsebX5syFyqUHVFDlUUDROVNUdFtmcd/CsyPH8qFHWLcbVnkxM2yYZh0JWEnnmqaNb2Fcj8XtO49l0FfIHpjzB+JjRLoJFvfN59Yrvo6vXRimBUXq2Ae3ho0YrNROkorFyd88PL1MjIKaDAkS9tU/hE=
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


