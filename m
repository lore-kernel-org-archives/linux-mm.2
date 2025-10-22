Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35A07CCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 16:18:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65AEC8E0006; Wed, 22 Oct 2025 12:18:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 632628E0003; Wed, 22 Oct 2025 12:18:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 547B88E0006; Wed, 22 Oct 2025 12:18:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4385C8E0003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 12:18:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E124B88D59
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:18:13 +0000 (UTC)
X-FDA: 84026257266.03.B2C5883
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8C2848000F
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:18:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=hdyieGlG;
	spf=pass (imf02.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761149891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xBRQsPxF7lgFkmhaLVNJTT8i8pgCefyYz7nQYMBFMus=;
	b=GVffIA+/5d4tKMmHHJcZAbzuEps4P16SsLYane5HDHyc2Wgx7D2xf8PlQEYVGgIpbPyxLI
	nW0+07rIOrFbXrwNazJyLqRxLkNZq8hJYspXWPnUstECB+IVJSto8xEGqPikPHcWzUOBFT
	oR30IjqFlPYMRp16eax8yqc+4UIA+r8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=hdyieGlG;
	spf=pass (imf02.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761149891; a=rsa-sha256;
	cv=none;
	b=nqZ+lGgWqr0LiPvzrZ0GTz4WCh6WwnddCutlKPm4Xosx1iTuuFFLsDAfpvA1VR+LIlJP2A
	JpOleT1Fjrmgt8fYFeGDqRXqFdPqNmUlhpCpZStvCmsLlbP1Qyqfo26I8iIQIBhURm6xkU
	z6gWemnyU16N3Ycv1pWWC0ZpGbhXyP8=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59M5doRN016636;
	Wed, 22 Oct 2025 14:43:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=xBRQsPxF7lgFkmhaL
	VNJTT8i8pgCefyYz7nQYMBFMus=; b=hdyieGlGYzfzQqQXi8L/iViM5oO+3ZBaX
	7r1MVNUJYPgsute18+h1btdHqM8LFsrpVX/A4S5Ogn77oZHx5Sj3wml4XY3eomHq
	S8u31oOts3wPdHdZ6W8diOhx1UYQiySZzyeya15aDM377Xn5t7p1jMeeoF2GS1bR
	IfSxRJOn5/fwH+fpO3hc/7Hq0UJOJxFn9NOKoekTNS+oQNpla43H+KFqsDup+WBo
	YajWq0CELq1LcjsAVqS7HGr3KYvwqlubb9HMrjCzcP/XIwnV5DqlXHYqvTX9w2V5
	YqaGclBLk/upw5ItCYRy8B3C3rSsunSqfEhcrzrjSeqAdFxVjGIFQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v32hkt6c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:36 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59MEhZcr029150;
	Wed, 22 Oct 2025 14:43:35 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v32hkt62-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:35 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59MBhucQ011015;
	Wed, 22 Oct 2025 14:43:34 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 49vqx18jv2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:34 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59MEhUdX39190982
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 14:43:30 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A355A20043;
	Wed, 22 Oct 2025 14:43:30 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3B9E32004D;
	Wed, 22 Oct 2025 14:43:30 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Oct 2025 14:43:30 +0000 (GMT)
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
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v11 05/15] x86/uaccess: Add unsafe_copy_from_user() implementation
Date: Wed, 22 Oct 2025 16:43:16 +0200
Message-ID: <20251022144326.4082059-6-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251022144326.4082059-1-jremus@linux.ibm.com>
References: <20251022144326.4082059-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX92n2m39iUTtF
 Fg7EZnLqu3cPrzjV9i2XkBrAVN/IOSbKbJASYKg+q7zizo78XQmtxfC4KbUx0Wqe65c3aPb5aQb
 gEnryojjSjAhLmFnrtXUBvCoW3rz+PEgdMB6UNS0NCSZkr/wr/lOhql5HW7bgNi6e/QWCgwZdrL
 ISDcKWbk60R7ujpUNcP+cdRdYnYT3Qrt/+0p8aC2fnH1g36dtnKbDdTsloRvn0GA0UfMOi1glkv
 tCLwQy5hm+ELIYq2EET/HDQT2egK1nUsW7dslX1m1JDLosphNPKCOTVprGSA1Q1hcQ3Rey7UPE5
 WB777bGP0GfWOTngoLgy93Eo1dqS/R/VaQQ/qYZ0nyupdeby0DD2Bw3bR5OlWqWg8h4q9+but9k
 5zTZmUPCpqasjkeFBOFlkrbVhzEZwQ==
X-Authority-Analysis: v=2.4 cv=OrVCCi/t c=1 sm=1 tr=0 ts=68f8ed98 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=7d_E57ReAAAA:8
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8 a=yMhMjlubAAAA:8
 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8
 a=meVymXHHAAAA:8 a=yMDg07iuMX7FxPBFrYIA:9 a=jhqOcbufqs7Y1TYCrUUU:22
 a=1CNFftbPRP8L7MoqJWF3:22 a=HkZW87K1Qel5hWWM3VKY:22 a=wa9RWnbW_A1YIeRBVszw:22
 a=2JgSa4NbpEOStq-L5dxp:22 a=DXsff8QfwkrTrK3sU8N1:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22
 a=bWyr8ysk75zN3GCy5bjg:22
X-Proofpoint-GUID: y5DtCLccp4sD_fajLJlhEc0XG358nHlw
X-Proofpoint-ORIG-GUID: Xr8P_8No_goqu17G9N_vjmUJF036Z68R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_05,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 clxscore=1011 bulkscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8C2848000F
X-Stat-Signature: hierpi16t8omh8zffa6iurk6nogxbufa
X-Rspam-User: 
X-HE-Tag: 1761149891-932541
X-HE-Meta: U2FsdGVkX1+OJPRJZZIxezM2+3B4oeKGBq391Lov+o83G3S3zKNBVzfH3FaAZqHm9kIEGOABPqKfIhQS9WlrxVAgA0dZNnUHhRwFXL6ToMn1Gbne3x8m4JL/OODJFt8aKf6YNcTD7fs6P0CO4bou/dBGQ/mIyn8ENxMsjEKX6nP83KOmpZ9vEInn8c53MQ3LZHi57qgXedPJdLh7qv9PE0JstzDwvveM+BqfVx9VCMX4ffoxz4RriGNHnEykDEXUJsF8caTiL6n0bmufK3pj4+vyXvjn4k0to9lbfijBAJ2ZvJSfBLG6QFamM03Q9PgifAB7Te1Wsms0ZMhbMQvItDZJWZipSLKZlhelS2gvIBtL5b28XFa9ImHhaE2gJG1I0VMnRv6b+zwwg5S6B0BalgdKjbTUObZDpEIXz9Dkv/FiE2PTVTO563w91Ri/k5SOuCMh4rwzC8QY4SzcPcr1SmhjrW9Qdfsk/IYaDEE5TZd2XA5XRjkllNIp3+AYEkP+Ce4MKVvwXLP/VJ3aUwWjc2q99fzPgSJ+Rg4VE8Whceq2h+8/vx76K8GrNLHn1vpb+hc4zxF84CP+S1ShtsUcHDDAVenmdxdwas16mi8B80B8VNzqMIrXtLXePd00gxoVlcMcTOvpRXGU2Ja+fkO+MpZFVGwFfsK++4Ul8TAGN91aHllwbcqMA93D9+op/Ji4u/i6neH/I35b43CKCoZsLou+WiD6i5nZ1vn9XNYO09EfJLYXyxy/S9+z4IxzR4Pp30DQpZVcsFhNV/0dbdkRDvQT2jtoPzw14jcIckyM+g5I0e15AQmVZaTAJIwO9sDOS+26sQw/YjNWyOOJs+3Ja7XT1dyA+qwA7GAMrru0zIRoeqnZM9Zv+i2aI0KosAPrOvI+ewqB4MVgz+39APVlxoOyaktWTK5H03qCBPntBSWu0hDaSdAma7EmP6R7EigjJx14GF8R4STyYINu/cu
 0iZmlIKx
 Px5cT6kCnVJxU0v9Z3LLtS5n6MEhzDWCr90Zgrs0cjTJ716biOX4bN2xMdUB7ou21/2IaSRxDJpogezX1Jz0+C9jpm16gyQ1IAIZFqJSiHXaB5lA5+v5dyTUYlYq9Li1j/UPIdWct3Yqupfp+1yUT7DywGzYFfIaamFW+/NiFYq1Ubm8wvDwdsMmgyJ5HR1s7w3WeaZFF9kvT7Np0T8mscJjn1ekRBtmA0bFDyTGdeKpOXANvxumV0aBc3VxIUd8UssCByfXWcZDHfJC4kchHJKZPfAbSYtnmre+O2nmgP59LS6xLodyRUGzXacuNVPf4mTN42KGRqWjHK/x3IbY69oQ4mFVuFyu127vzJ944FgI6TLUsRvDF0osSqqJLv5S49EHtvv8NcLCUTRhnYmJ1QP+8BkdeEgFI2faGBMthF+XiZl+0OOEVyd+t6DtOu16I8zZ9mF4dHQ53NNg3N1bPmnA14w6TqZ6+wEqJH63qFxl5h75vehAkZ/ijwfs7GAg3/tJehwOBLKi7nqe0CXTl22oK0/+HHxV0bkn9HiFkktIvFFOFXHBUSz+2wm03ff8G07b3Dwx+eRsuu5AK+2+ozJSx5BMpDGEJSZys28P8hk2I5jSABn8/UXAoKOQWK1hU8pwG6lBEcF+SQf9vSSeYSRmgeHh6LXavOh+I
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

Add an x86 implementation of unsafe_copy_from_user() similar to the
existing unsafe_copy_to_user().

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Indu Bhagat <indu.bhagat@oracle.com>
Cc: "Jose E. Marchesi" <jemarch@gnu.org>
Cc: Beau Belgrave <beaub@linux.microsoft.com>
Cc: Jens Remus <jremus@linux.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Sam James <sam@gentoo.org>
Cc: Kees Cook <kees@kernel.org>
Cc: "Carlos O'Donell" <codonell@redhat.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---
 arch/x86/include/asm/uaccess.h | 39 +++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 3a7755c1a441..3caf02d0503e 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -599,7 +599,7 @@ _label:									\
  * We want the unsafe accessors to always be inlined and use
  * the error labels - thus the macro games.
  */
-#define unsafe_copy_loop(dst, src, len, type, label)				\
+#define unsafe_copy_to_user_loop(dst, src, len, type, label)			\
 	while (len >= sizeof(type)) {						\
 		unsafe_put_user(*(type *)(src),(type __user *)(dst),label);	\
 		dst += sizeof(type);						\
@@ -607,15 +607,34 @@ _label:									\
 		len -= sizeof(type);						\
 	}
 
-#define unsafe_copy_to_user(_dst,_src,_len,label)			\
-do {									\
-	char __user *__ucu_dst = (_dst);				\
-	const char *__ucu_src = (_src);					\
-	size_t __ucu_len = (_len);					\
-	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u64, label);	\
-	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u32, label);	\
-	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u16, label);	\
-	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u8, label);	\
+#define unsafe_copy_to_user(_dst, _src, _len, label)				\
+do {										\
+	void __user *__dst = (_dst);						\
+	const void *__src = (_src);						\
+	size_t __len = (_len);							\
+	unsafe_copy_to_user_loop(__dst, __src, __len, u64, label);		\
+	unsafe_copy_to_user_loop(__dst, __src, __len, u32, label);		\
+	unsafe_copy_to_user_loop(__dst, __src, __len, u16, label);		\
+	unsafe_copy_to_user_loop(__dst, __src, __len, u8,  label);		\
+} while (0)
+
+#define unsafe_copy_from_user_loop(dst, src, len, type, label)			\
+	while (len >= sizeof(type)) {						\
+		unsafe_get_user(*(type *)(dst), (type __user *)(src), label);	\
+		dst += sizeof(type);						\
+		src += sizeof(type);						\
+		len -= sizeof(type);						\
+	}
+
+#define unsafe_copy_from_user(_dst, _src, _len, label)				\
+do {										\
+	void *__dst = (_dst);							\
+	void __user *__src = (_src);						\
+	size_t __len = (_len);							\
+	unsafe_copy_from_user_loop(__dst, __src, __len, u64, label);		\
+	unsafe_copy_from_user_loop(__dst, __src, __len, u32, label);		\
+	unsafe_copy_from_user_loop(__dst, __src, __len, u16, label);		\
+	unsafe_copy_from_user_loop(__dst, __src, __len, u8,  label);		\
 } while (0)
 
 #ifdef CONFIG_CC_HAS_ASM_GOTO_OUTPUT
-- 
2.48.1


