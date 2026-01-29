Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4912DD61008
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 11:28:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D7326B0089; Thu, 29 Jan 2026 06:28:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26FB86B008A; Thu, 29 Jan 2026 06:28:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 151DF6B008C; Thu, 29 Jan 2026 06:28:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F0A286B0089
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 06:28:06 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7EDDB5BD1A
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 11:28:06 +0000 (UTC)
X-FDA: 84384777372.03.EA21207
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1823840005
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 11:28:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=GpzgnG9I;
	spf=pass (imf17.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769686084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T/tv7uGNVzdBXiYj+8g/zdyroyXt/WvYjxlfOqY4ir4=;
	b=DV9TQkpUwFBme42ENZrnQjGMeRIWIzLvSNYzM4uLaQmpCGldazP2kZZmRLoo576Nm9pKqe
	Z1US9No2eAQJ/YgWNoEUdY9EwXmfDuPNR3guxhGzbkX8UzJxXUdBs1LJylDrGN2zBYc8Cu
	BVH3UZcXTVJKJ5nZLh5MH1no/SCpJHg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=GpzgnG9I;
	spf=pass (imf17.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769686084; a=rsa-sha256;
	cv=none;
	b=r5nHMKpFOqtCkG/qmzDeR2r3CYdNXT8X1TkX+JV/4321i+qyd1X+wGntdN0cvyxgXx1zQQ
	dTIxgu6I59Z19VE+d9b1AltB5CvrsUwdXt+igx5Va7Bpx5GhGQi9CRcB7fRqGqJQFIRpTq
	KYBCMk7ISnO1WfiCmczsUXDJ7LCLGnE=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60SLbCct012527;
	Thu, 29 Jan 2026 11:27:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=T/tv7uGNVzdBXiYj+
	8g/zdyroyXt/WvYjxlfOqY4ir4=; b=GpzgnG9I3TsyTO/J2PhO8PLDzMg0chv6B
	GCN9pGOalT4HPyh+Q61UWPd5HFqVOPstkiaPQq1R+Xh/sr+3/6w9Pi1fcor+W/MD
	8rSakU1NfDEeznnUUfDqj0PejH5zRQwkE3FOCrx/+u+JncGonveTiEkHK0tnPgui
	+gHjpB4oX9b0Ce+pkcvN8rAzI8K2u8SYANonWS7wPRFip2YHjwsLcl94q7jvCDF0
	/q0LlPo6lqrHUIZZJt61jlHjnDxLCGeVYvx2SI4CswH1WzRlqlSghjRw1QEW9o3Y
	fVJeg4ASa1mTipeoEEn+noNgnhVWKqgd9+OqmxVgiRo9esPcDlS9Q==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvnk78e6s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Jan 2026 11:27:37 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60TBRbQ1029251;
	Thu, 29 Jan 2026 11:27:37 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvnk78e6p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Jan 2026 11:27:36 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60T6WHd0031067;
	Thu, 29 Jan 2026 11:27:35 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4bw8dsshpk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Jan 2026 11:27:35 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60TBRVKA17301978
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Jan 2026 11:27:31 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8AE322004D;
	Thu, 29 Jan 2026 11:27:31 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F236D2004B;
	Thu, 29 Jan 2026 11:27:30 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 29 Jan 2026 11:27:30 +0000 (GMT)
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
Subject: [PATCH v6 5/6] x86/vdso: Use CFI macros in __vdso_sgx_enter_enclave()
Date: Thu, 29 Jan 2026 12:27:25 +0100
Message-ID: <20260129112726.892340-6-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260129112726.892340-1-jremus@linux.ibm.com>
References: <20260129112726.892340-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2pZ6jq3_3TZLUYKEZ4Fg5cfZockyqzVm
X-Proofpoint-ORIG-GUID: 87Rop7QX0FZmS8jZbJv7CbnIFfFhKkn4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI5MDA3NiBTYWx0ZWRfXyRMuWXXkMvZa
 Z9Ig7jvW2bkL8h7WgLqnoESsHfZ7Y29gRJv+rIdz3xNtlIgN2JTi5OzRBWnJEIzhU45OkxRXzq9
 wq/tM+A9oReDEH6K+lCp7ecku/PdUcOpG4QRMm+dZkXgfOn79ooPLnLNJ1f7P1MIguXCF/bKE8R
 9ww6+1x7k6JZ2Oq8WLsb1wO92gt9mIUCLMqLChCDA1zHB7DGXGwVOLs8DSzlVBafxADGMibcl+i
 HuHn3dNJSCfeAfpvkN36X0+eLad059EU4QN2/FncQl28aKlZNme0fHbySyjLjpFyq47k4iFGagY
 XT1WNT+vNXlxKDU63e7LaqXvzvzRE5ozN49eRAfVYv/5lWbx4RBb/dEDLSUla4jjJwBHbfWmMrT
 i5Awycn2QNgo3RgDAWSz1131Qlc+F8m/E7yKdq4Y85NoaYRzJYlKDSF0Of6/FRZSzHGUpyvpyTu
 kYdAoAii7vOiV6eo9pQ==
X-Authority-Analysis: v=2.4 cv=AMiVTGgp c=1 sm=1 tr=0 ts=697b4429 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8
 a=VnNF1IyMAAAA:8 a=UlpOIAycHnb1QmJiUioA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-29_02,2026-01-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2601290076
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1823840005
X-Stat-Signature: d3x3mdk9ph5acyuwrqfte933suwg3xbz
X-Rspam-User: 
X-HE-Tag: 1769686083-629578
X-HE-Meta: U2FsdGVkX1+Nk9v7btk6LrKjtouRxjsTm7hQAflaQbk51c229oE9gpbfl29uKhLLi3WN1fwU1GOnfacbhzlk5Ub+i3hBN4MNUnbDPI+OOWd/2u6m+S8uynGbzXdLYfzuss4eQg4qa/XwTT+hPUQxylosapBG0D5dKNQxDN9YP3ckwyLgN4p6AyNl88RVh8Wd5J0tO38eMGOHUzfE90WoSNagUCC3DXfKKWuouuR7hgH4LOe/f7q74CiIERLURg4HbKYI9uvQbswC+/D7tiZArlBBYCY4M4c693P7jdAl9s2hQbkyxs+uxdasnW9+oWygDoEolFjaW1GY37nvFHp8nVT9psObVdaEpDbSjRw5tvZHPMNL+1Tsg6xU8kquRUfLFQGtWe49RMFRNF/qJEKNkNGcZxbdz1pkf+7uH9kfQnZkxPx6S9wkM0tvRRTMmfkcVI2LICJe/WROmOqnEHMumQH/etEa7URrVhlrU+rOOQzip+6m9zst2qHlexDgHl4rxTyHl+39SMhfhGePLSZHfJAH30iU47LTmg0r5e5s8ZERTYV+yPVj84GsIekfqAgu6FxP66w5N5MMK+BbiEHZlrYDO4CpPbURbErdiEHXInYs/GOujh64fRuB1mafmtVK4GXutCYf7dcIgV0U0h1f6HdU/evBPIGsmcGAvWw8vCatEW4Q3kjE4de4wVLuIUm3yMCbx2K9BkIOjaaqDhtLSmch/cqRff25XCaBAuIWkkWwcjhEbVfuAB3ruZ3O3zPN/7lephydi4mls5r6CXjE5Woizy1jZcbjsGIyCwpLa1DEAEbO814e+pSE7GY7cgZOfWWr5snzfcnNFAqT/oUGRmzf9CJeygAD2eH8g5nZDkqgHzM9KwskB1LQO5VHODCkA0Swwr7gP/SlFQuM5fr74qH3n5OxG1uNVnSqif0edKdosQBRo06pCIbjj8MUQjAKo3jnPR75Bgm7IEX4SxS
 ff15NcLA
 U2jsJPNW2Q1nEO561pjTElbQEWLTgD8EdEuL8ZPAUPbL4SKe8hFa5LyQFxhHsDMOn4QSJlbYdZnx+RhGox5qbaeF4WD68CAjDV/wvxZpd85APH4tfaPg04xM5LxHnuKsjXtogM0r/LPZ0xxxgsDe3q4aG25CTghr5yga+jgL5BMu8GY/xOkwL8nzYAJGUZK5mTaEGrFTr9ckALeToyabmk8VGF7jdZrEaegfmTKuyOM1fmBAojZiO3f38E0zH6o3T3Pd9QelMXGpUEB0ljo3F0hU3QIUwC7al9WxdOtFJKtyCT7r0VecqOmqFzwgIkIQbp94cZXDFmCZM56OPMYph3P7nxhmKFrFjQKAN6aNIv+P9GKEEcrIp9Glfh3ewg+YeZKHbXDmOBkGNEqCNgm2qqy8lDFytf+TPr7CFAy0NO3NKojs=
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
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---
 arch/x86/entry/vdso/vsgx.S | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/entry/vdso/vsgx.S b/arch/x86/entry/vdso/vsgx.S
index c0342238c976..8d7b8eb45c50 100644
--- a/arch/x86/entry/vdso/vsgx.S
+++ b/arch/x86/entry/vdso/vsgx.S
@@ -24,13 +24,14 @@
 .section .text, "ax"
 
 SYM_FUNC_START(__vdso_sgx_enter_enclave)
+	SYM_F_ALIGN
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
@@ -77,13 +78,11 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
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


