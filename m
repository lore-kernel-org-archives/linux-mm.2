Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D30A5CD5BB1
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 11:05:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13BEF6B0099; Fri, 22 May 2026 07:05:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D1C76B009D; Fri, 22 May 2026 07:05:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E32BF6B009D; Fri, 22 May 2026 07:05:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D313E6B0099
	for <linux-mm@kvack.org>; Fri, 22 May 2026 07:05:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 95C13140446
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:05:04 +0000 (UTC)
X-FDA: 84794773728.19.A66B27C
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf13.hostedemail.com (Postfix) with ESMTP id 327B920017
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:05:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=aFwc6IBA;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf13.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779447902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qiH+5t/dirTrzjD9ZdtQxW3Rb7kBj9PpVkHn0IEvdoQ=;
	b=RkpkYSTxk284w799MjBocMdukpJXkuG7Y5RSMsGjNjv69qRYgJTnA4AXyUqER5n+TeOgZg
	I0binSMFx7/bB/nG6P7xrS453Xshy+9zwvosR10JVGG69wQGnhf1oaZmoGGzrURtdLhpiX
	3fJxwWGFhxld9nslx2BjZBwdjGrL1D4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=aFwc6IBA;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf13.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779447902; a=rsa-sha256;
	cv=none;
	b=vvDHwsQvOHLQkJczcht+lkp8V/F7i2NkoZZ1SYEVLcmAgcnkjLmTQhgo09VDoM33koH04s
	EkYbed+I06Z+nhxZTb40nK1QTUpq5QkZMEO4T5BhPBfLjdoS8TYQ1LhPzcYugliX9b6Oa5
	csvl0btZzy1K8rAHq+XqVGULN45sN7E=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64M1E3iw513145;
	Fri, 22 May 2026 11:04:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=qiH+5t/dirTrzjD9Z
	dtQxW3Rb7kBj9PpVkHn0IEvdoQ=; b=aFwc6IBAvoh/srOHAKCE0q9hzcvbcB1nJ
	1z2sl4yO4jI8QbBXc27AlhO3w0514yISGN57CQ31jFbph3eqhzUOXZD2c9leAxOe
	FOkp0/2N2Y/dtaAprSXqK9DQDop8cs+RqzAUPSNMywzbGw+3oAIUgu3qnpFL9b9c
	lIBUKzLj0jzw/3SaS28s0IQufe6zU3apgqQPgeI++JHn2c6i9ovr1jtfHj0p1RjL
	p90vae8422hZvnvPcne4/4DKEsEVgDVuEgz67kzvJXGzAEZu/lmWb5imby/gntx9
	AS/dhBl64sIWpmT0tOXfB1bfVWeeFx2IVG/tKPUN8CDmkZtVCLYtQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h75bjs2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 May 2026 11:04:36 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64MAs8Ec021302;
	Fri, 22 May 2026 11:04:35 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e72wqgtnu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 May 2026 11:04:35 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64MB4WuO61669732
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 May 2026 11:04:32 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0D51F20040;
	Fri, 22 May 2026 11:04:32 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 917AB2004B;
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
Subject: [PATCH v11 5/6] x86/vdso: Use CFI macros in __vdso_sgx_enter_enclave()
Date: Fri, 22 May 2026 13:04:26 +0200
Message-ID: <20260522110427.2816637-6-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260522110427.2816637-1-jremus@linux.ibm.com>
References: <20260522110427.2816637-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=ffCdDUQF c=1 sm=1 tr=0 ts=6a103845 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=oGMlB6cnAAAA:8
 a=VnNF1IyMAAAA:8 a=zHpKlsP_3zAlDdbrjxAA:9 a=2JgSa4NbpEOStq-L5dxp:22
 a=NdAtdrkLVvyUPsUoGJp4:22
X-Proofpoint-ORIG-GUID: mzXT8lGS3hxAJnZz_Brd9pOJeJ3FS9MJ
X-Proofpoint-GUID: qE-NX6yc6gzjucuncESJ-GEGws4OGUWU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDEwNiBTYWx0ZWRfXz/zUEP1gEVoa
 VUWwxA1xU4aiImLCnYTFt9mbzLHZcsyViKAjAjWxXWvZMWjBOE6MbAYgC6n4dcaT6990NOudc9c
 VytVLPnO/UZTxxRslD+ps0/pco9yTzegpeM2+Oi+cJl4gkA9Xilw4ruWzC9eiPXkf1pro4TCMmC
 kdvylcCBWrieQqBAloi/QjPpDKRzHp2OJuaZmvfRNVCxDEbX4Dt/9Jza94YfzWbCwETBVJf8OvJ
 fo3Kd2LK7eI1Fh7A+PCvH+HgUroecG9sOQ+x2YYnDEy6+YLhjYvxtH4lgIQbK0hrNa0WObA0Tg2
 VebdHJQIJeDa+qxCOibRCGVeYMkjU92vnasA3+2/r+vuGp/ULW6d4SxpFwZeCah5yPEn3JG/Oj6
 AknOYvgt0e6r/ret/kAyM7XOy9RliooDCkwQHVxi7bi/rtZPu9UczhDuEFH+KUxz0v4GmmDtV5F
 zFl2m87kOE42pkZcR7Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-22_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 suspectscore=0 adultscore=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605220106
X-Stat-Signature: 9dpzk55zou3ey8p5qnxbasb8qbjcozwd
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 327B920017
X-Rspam-User: 
X-HE-Tag: 1779447902-892428
X-HE-Meta: U2FsdGVkX19r3o3QYYeURjx7i7bluaHOsJ8DGoXeTBjs6WF312I8uRoggUrVEzLRIbusac8dROtA33Fb6ptGF0l9I9LY46c6gY2E6581Uo/JhX57CJcz3DWGLjPXerYcguwLR6BynBAl/oMisFsQ+h/ZMHth5i2cmStEIeTrt8d+4MZAYIys+WhS/M0j0zhen2le9k1xcFG6CnkagmBf2RKntIzqO3AkNYAAWP64Uhdk2lAh140CZsUH9DxAgJlxxmmWpXXy60BB0cScN91ZK0jRSyaIlkXTQxDWgiLNy9j4n5rRs8wmdHCh6PKfZeQXhnRQ5T/yGGEnfzJeoAjEsXKlY/Wwma8/brQ0r9ouNbw5OVow/Exwq4zGleyss2CPyi05NBS4QWfnVfIE3YwwrrDGshp586/2t7xGhQTJIT7zb5DSCgEdhwAoa6s+uXjO5BIL+8SVaKK1MZV4TfbiakPDCq5w+lOFzT4nbwgycAdhb6CZritGrLAzWlHNId8Qgp2OWmsloZCAFjDqz0/fX3dZkW5N5xFJRXyhKyV91tj7KZ1KBOjv5wYbY+XBSPj4mIba6aovSJD9hN5JaNUB6KH8hlCJov8l5mCEF3o97W42P3bqr6+t+0Xie1ezf1NgDT/du+So6FCJkpmMdjIZKkRiitknZzpZNegBswnGWst2ssrTthSWnVAvl1GL8HyKDOItl9YxLHgk8oKrCIAXfBBKF2pnDHxhyXR83EGCvn01DbqJZKGJlovAj7ZDTXVfbUpFSJallgweJ335EDpvJZngXQXIG679OANP4RfSG/lPfQfoo0W+itszEZP9wXM2oLQR6o0OAoIMK/57fHcGg95/Ir8dG9YzjUTdaU4jc/8eqoYKW5qvnbcdnvqHOQ7Jyv2Nk9ISIiU6dYkLmU/PY9GA4XjyReGxPheulJ4zB/yGUVN7L3EUkPzNu3SPGa8El+KMtYYtbidjcYa0mv1
 iA/fEPyc
 cMgsEegyL94NHMsf2sfA4T4FwCNxhDxfzUmSa1VWIO9/MPFtRr7NkBhXK+4GsB051AnsdBZIuaEGjR1A545Jck0jLNzp+Wy28WsVLbLHiZy4QQ9Tiw19dt50mf1rIPvgbAe/k4y2KMbib7Vvlw6FY3uuGbT+l08U8uSA+s47WtVO5ZmuMDx+eTHw63RIOGbOZr5GQ0TrpOWTabSVIhL0JO2QPmBnaReNB3pSNYj5UqBzT/QyX1eoqZl6wGKng39eUZLNWbipBvRbNvd7j91wJjDSb79d8qWhpanllKweU61c5Sz6C6u3oPATXTsXiXzjnpIQsurFzh1KpwV4Qhy9HTGiHOta085Kr9t4At/pyw5TO4MZF5l4TBLmEL/tvdgt67YveLSsQF+kMMNSJXII3AgBzwL/fASOsHcCfG5rrlNIYn+uD3R4RsxsBxBZ19pbNCX+gUtY+4v1ItATuXoa+kYkMlHBKMSmBB+2vI49YMJj63xc=
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


