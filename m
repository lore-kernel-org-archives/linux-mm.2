Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EB03EE6B4D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 19:37:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D0BA6B0099; Fri,  6 Feb 2026 14:37:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 487DD6B0096; Fri,  6 Feb 2026 14:37:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A14F6B0098; Fri,  6 Feb 2026 14:37:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C87FE6B0093
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 14:37:15 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9286C1B17DA
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 19:37:15 +0000 (UTC)
X-FDA: 84415040430.16.AB5B62B
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf16.hostedemail.com (Postfix) with ESMTP id 37246180012
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 19:37:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=jZu2R8dS;
	spf=pass (imf16.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770406633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sn287xhEf2Z9VJU3yh0bF7Kq6J2ymS6I6sGqlb7excs=;
	b=6/sPPDPiS1zY6I6uEhfYVCkL4xJUg82LopcadtzV/ZxQJl1LO97K0vJaxWf1hElmkydSkA
	4f7gXy99OPgxCmCpIyDNtCzSdPb/uP0/qQjEuAHyL66s6V4qenSXdfBva2z0vG9HOR8EoO
	GIBmZXf8xzuHYegpzTWK5ylLBgDvQ3A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=jZu2R8dS;
	spf=pass (imf16.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770406633; a=rsa-sha256;
	cv=none;
	b=VdGl0ChNtcpuUTEaNMDDsK9Ro2Y0jHJO2cdyd7hriR/DJ6/OKXUZU5s8IAj6UF83dPx6bP
	Z+sYwilmwcSZSWMzhRRXHppKbJmV++p80/FWq13ZzwquappAXSNn4xPT4zLdHJmemiffS4
	zyQ0BF4MUqmDgDBd4ckXD50LdqVuwzk=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 616CwK45032189;
	Fri, 6 Feb 2026 19:36:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Sn287xhEf2Z9VJU3y
	h0bF7Kq6J2ymS6I6sGqlb7excs=; b=jZu2R8dSykYgcVDA4kkGoc2G9HgWjqfPu
	mXJq9KhhkB7iMm4MEjXpWb1sZD7EbAJ6fNB1QGkjL2bpuXtLQ+vzaHr7sA4j6zPJ
	mwXFphLGB9NgD6Tkhglox36+Wvl1ZfwbFC5Qv28c5MU7ADcoNKFm/DOr5vCs/ABz
	JrHp1DwLX8ImLINkg9B7v4zdT0c30t1MI4kKfQoWNUdhmGOBL4kkDuSFsSBW2vzO
	s8N7T23jH6b+s1mPsYwQ/Mi7rnabHQOeumwg3R04sJTcRBzAK5bdHHMg4xBQqa+c
	A8Y++PbcG0NTHjANs81yM8+GBf/0yyw3t1+6H90RpE0LgOrCo9Yuw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c185h9yhj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 19:36:52 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 616JaplX004342;
	Fri, 6 Feb 2026 19:36:51 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c185h9yhe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 19:36:51 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 616H0bKC025703;
	Fri, 6 Feb 2026 19:36:50 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c1w2n7j9r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 19:36:50 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 616Jak7w46596546
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 6 Feb 2026 19:36:46 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9333820040;
	Fri,  6 Feb 2026 19:36:46 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2081E2004B;
	Fri,  6 Feb 2026 19:36:46 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  6 Feb 2026 19:36:46 +0000 (GMT)
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
Subject: [PATCH v8 5/6] x86/vdso: Use CFI macros in __vdso_sgx_enter_enclave()
Date: Fri,  6 Feb 2026 20:36:41 +0100
Message-ID: <20260206193642.1580787-6-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260206193642.1580787-1-jremus@linux.ibm.com>
References: <20260206193642.1580787-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=UdxciaSN c=1 sm=1 tr=0 ts=698642d4 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=oGMlB6cnAAAA:8
 a=VnNF1IyMAAAA:8 a=zHpKlsP_3zAlDdbrjxAA:9 a=2JgSa4NbpEOStq-L5dxp:22
 a=NdAtdrkLVvyUPsUoGJp4:22
X-Proofpoint-GUID: bymhufXf1uUZ3hm-vPfESYKQzLkRnFG-
X-Proofpoint-ORIG-GUID: g3m2Z2TPNlXn0rou7v6QvC6IKZeplVJt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDEzOSBTYWx0ZWRfX7dA5giIZIQ3P
 W8A5VU6cBOu0y+u5fkH+98aeWtK18LL7CbyetZAC7ac7ALHGaQ2HjfHySUTlz8xJ6ciXz7T4lv6
 woUzzuAI7FsrcJYFjA4MIIQCmd5BaeUj9FpDrBUXl9Rfmnsive+MSJQmFsYMxC+PjEs1wHBZe4o
 0P+JsC7c9tZtYR2VsL0sbsbpEHy+gW3mREpQgW+tQzdQJ728kK67+iWYIe53jajHu90mru05sQ7
 6roJfhqp4Chndvlqw3Zen9YbBumH59+6JgdOLwECQhu+fdzscS1J8IOfC3TcelQLaKGYAvq27Rn
 X/EHO4L7DjYWOTOu8xMDXfQ3NpCj1j/ZGI5DHN+K+WMJtHiYnNZ6LnxgYhmmO9sqn7nWnXorIm7
 05LaLLJ+15NbJ/z37iCCMrFWZnGq5xlHtRhRVZPPvY6c+cef9C64rihc1UjXvgZVJqZXs92i8XM
 G7r0Rfzv+Gx6BSI9ftQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_05,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 impostorscore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1011 bulkscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2602060139
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 37246180012
X-Stat-Signature: 845wy1hgtiw5qyp9oe6nyhm3bp5kw81r
X-Rspam-User: 
X-HE-Tag: 1770406633-490644
X-HE-Meta: U2FsdGVkX1+c9NK4qutZSTlhc1NBBdSmuGK85T3bNgF5gT4zASv3mrrhI8FrbDZgDMDxvwIPyphLe2/WUMz2C5GL9UozyAKCNuOUe5VIKSw2yIVnOdHGTvx6eciAuWRljIVWc89LI1i1Jt2RgS26x33hSLpXwsyvlo9zaiv/oC17bJRhx9mExA7V4du69ZNmEejpUjiGMPyLIVlLf37LcPEgbGHXUOX77R3VmHCymwf5eMi0jqyWVlCQcx45CQOWniJTGFywLuvuJwqxHyOd4qN2xvzGpJn3BuOts4lkKh4HOBf8kC76J0rY6Q0ZyRW9in7RZqP3m7A2Oz7PxaVJ9k3dh/+mttGjsQdP3sw+psfb4L/nL7f1TaCh6EjS4fyDG9KN11jGkwCi93Zqgg0yjI+f3oeb0UgDbfIYbTmv1uPgHWjoD+s+UTkM4xSVFM/nuuNkDMZrs54ekvdjn2htSa11vzPrH6bpSlNMqa6Y0yqdB8oiL/OySGe+Wq/1ZTFETrae8i2/nLVlO5nUWS9IMAQ1LOv9VDDeVb/iG9XBsZX5wgQ6SWhCSkSHbXNRl683eWAlEb63NOPfQHva8Z0bjQ5PmHsAiAvA3dVTUtJ/GeWVROTcgXIqUuQhmjQVIlHx0MTMa1GbgY+oPq7Ah8VVakKQb39+C7GThj5EBEtRtwWqKzRNFA+t20eATJ/oQaRENRrts2ooiSoeHoWGzoszWuVaW2FeiedGR+5E/4N5tsBH5GsKodrHeNPa9TR9BHF3QZvsuW0svTD8r9vqhDurfytV2rpBqjDSfNTJwZRbf85KE/MST2ikzWaYk9voY2tC1VLXQMOTx3z1hn5MtVBf0HJeLQ2GkczBWLi+g65NFl/CJ+NluqTgTCJPOxIzCSDKryWn2Xa2Af0wHaZxzYiqNR7XXZONkIz1FUctdpeJeAxGwlqOhRFvNoW5iQMaaAbb/ZEjVcBJRy5AY1M2uLL
 3O/zaQ/+
 Kmd8Sep5TabPZUI4kBN3SWqaNGq1xJZpt/ApoWRQNybXVkrF5E3yoIgRExh60VY168bQ5oIRdPUR8szCi1ENVAfu8oO05YkR+eDo2QSSobFfrhXmdeuNrWf4a96KRH1BHYMCJQpUd4x1kT/b5ED+cJM6MxlBoQjgf4O9zYGi1AJ67vpW6q9iTe6yxbDEoOlozNy9Aep+GGI9hjCFR/yiyDnsIojXTl1VzGpbGsX8RLXsWDS3L8/MEhr/Foh2hSQ0j4K9bKZyZljPqv6y3ww64Rrg4cy2bF5z0PjD7hASEtxKLciCbspUJ86sKNfWsj6qeBrnzs9QTMSmiHJjgkER05w6OFwNCyALCM/dX6emDoZiakcW71f6VUUgxyGYNrRdn92sJv4l3k+JJTFo=
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
Acked-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    Changes in v8:
    - Remove SYM_F_ALIGN. (Josh)
      https://lore.kernel.org/all/amh7fzsjx4p5nowy3b3j6blkty5ojqf7jawtlslexwzdbxrhc3@zersgacmcnai/

 arch/x86/entry/vdso/vdso64/vsgx.S | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/entry/vdso/vdso64/vsgx.S b/arch/x86/entry/vdso/vdso64/vsgx.S
index c0342238c976..76efbeb1e287 100644
--- a/arch/x86/entry/vdso/vdso64/vsgx.S
+++ b/arch/x86/entry/vdso/vdso64/vsgx.S
@@ -25,12 +25,12 @@
 
 SYM_FUNC_START(__vdso_sgx_enter_enclave)
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
@@ -77,13 +77,11 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
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


