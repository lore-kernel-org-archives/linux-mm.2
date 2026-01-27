Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB6A0D2F033
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 15:06:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB51C6B0089; Tue, 27 Jan 2026 10:06:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B75706B008A; Tue, 27 Jan 2026 10:06:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A01F06B0092; Tue, 27 Jan 2026 10:06:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6F8876B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:06:32 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3AB27D2A67
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:06:32 +0000 (UTC)
X-FDA: 84378070224.05.9AF49E5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf24.hostedemail.com (Postfix) with ESMTP id CEFF6180018
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:06:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="N/NWS0Up";
	spf=pass (imf24.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769526389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K+YHoKAw+cbn5wzmOqW1aWOmzk7X5v1pFB0m2mI6QO0=;
	b=bhSIdLt3zei203aalseBFS+Np/sONLyQOf0P8NODPvjDykn+ijgmbdK6aZAQVVDdVitfCE
	fV4bghFQ7jfgrTLNqp+cmWKFxSIOrCEI3pEeyUoRdqx97g8gpe2Tict+CJ3NNsHo7CrYzf
	b8l++gYxPJQ1EcEpqBbJHFdI7gVzkqQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="N/NWS0Up";
	spf=pass (imf24.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769526389; a=rsa-sha256;
	cv=none;
	b=MPNLi3fMdr8gWh7tmZSt3Cn5zjVBYgRnMm2voj6wN0sEgAXJ+V8Nup+heZrincEmsozfVV
	IAChErkwcSGyNGQSxRWYnRdw0GIfMjNG9SKgduVo0tjudgB32dk+SO/HYZfmkazzbpo8g5
	33MbizkegWiDSjE9Q6mo/IoYu0RrKDE=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60REnaOS009684;
	Tue, 27 Jan 2026 15:06:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=K+YHoKAw+cbn5wzmO
	qW1aWOmzk7X5v1pFB0m2mI6QO0=; b=N/NWS0UpWzXtbnLKLLp8d815C5U1hpII+
	umo/IJHd9TgC6LFBl9u0ZD5vBYuPr4Q7V1jNvfKXMK0SBrcVhFUtOURKJrtdQBhU
	6nCULSBUfRZ6t/Wo7b3aRSPu2WU21A/jQRSOBpXNlTwkyZL7e8XuTs+Jn+Rw9VJU
	CbjgN2MzGkdRUiYLLQmPUFbttIZKfvuNamEWxTHNcFszO9yfMdDerY2ukdNmInqH
	JPfl9TzQ9j4IH8R/v1GduTpKIRkYKsaYMuYjqE+te6laYhASQPsdbEIfeb48JNii
	Orm5/oWCMpxyTf6u5Z3mBCRON0P1QZsFTUMXX9Ke7voJEdIyqkHkQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvnr646r5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:08 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60RF4ZmU031466;
	Tue, 27 Jan 2026 15:06:07 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvnr646r1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:07 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60REgU5f023624;
	Tue, 27 Jan 2026 15:06:06 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4bwamjrwj2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:06 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60RF62to50659832
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 15:06:02 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8D84C20049;
	Tue, 27 Jan 2026 15:06:02 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2C4412004B;
	Tue, 27 Jan 2026 15:06:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 27 Jan 2026 15:06:02 +0000 (GMT)
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
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH v13 14/18] unwind_user: Flexible CFA recovery rules
Date: Tue, 27 Jan 2026 16:05:49 +0100
Message-ID: <20260127150554.2760964-15-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127150554.2760964-1-jremus@linux.ibm.com>
References: <20260127150554.2760964-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDEyMSBTYWx0ZWRfX6cfqk7mkyDnN
 BKp7glWyYHb2jjLh3MumiA/bplBWiqJqruQKx/swaib6JOMAVA2drXb/+Vyi3S+6FLGjOVxX2FM
 xkHz3fx+zxg3nXu7uGOaaGM7hHFTc/QvHaScknYs7K7VAToz7icJnCvFXw5m0ODwgOAEzFApyMc
 T+m+osCzvQR5WBKDMlKs3cUo9qj90aYhdysC9ZqLsmlm2sUvv3gHo/E6NaBSwqZJ8PbhDbtRqJA
 uryz/Blnr9l8ZvVjyQiGS4V+d/36lXMxoA166Q6o5wit1lP06QybN6vL1gNe0jJE2BzqUQbfrQk
 sn9kgOczbUku7vii1yXR93Fr5shX4tnhebF2v0gG1kZAKn9Spt9hVQvCWlUYrTSXnHo1v3DAk/C
 TJdPERjdAZ645t4Y1JnfNpISFtf7aj/7nraVvf6JQWboLnSnPANuLA11OEp8nqTuk/Kozp1yMZd
 tPpJORTyQew5r8ttPhA==
X-Proofpoint-GUID: Vu9HWYWmyloL_Ii75PWM7aqhnZmB2Kq3
X-Proofpoint-ORIG-GUID: mYZ-0j0k0zbvHgd1DpkIZSE_XICv4fco
X-Authority-Analysis: v=2.4 cv=X+Vf6WTe c=1 sm=1 tr=0 ts=6978d460 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=7d_E57ReAAAA:8
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8 a=yMhMjlubAAAA:8
 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8
 a=cmUe23YjoY9pwAX-L18A:9 a=jhqOcbufqs7Y1TYCrUUU:22 a=1CNFftbPRP8L7MoqJWF3:22
 a=HkZW87K1Qel5hWWM3VKY:22 a=wa9RWnbW_A1YIeRBVszw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-27_03,2026-01-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 impostorscore=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 adultscore=0 malwarescore=0 bulkscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2601270121
X-Rspamd-Server: rspam11
X-Stat-Signature: ozrkyissigmpy9gyoyf6bwpwykt56zsg
X-Rspam-User: 
X-Rspamd-Queue-Id: CEFF6180018
X-HE-Tag: 1769526389-733723
X-HE-Meta: U2FsdGVkX1+fBaZ3f6W5YkcACcoYfmGeeYPpa2JELcaL5oKNHUkeCRc6Ngk+YqZUU7IfOlCeLnJbXDB8ik4KXFWTJq0RY/tXrXN548nj3ZS6LZe/yRdcheqT2/q1qWa7iqgThLHnK/umLPkAuTRJKWxvV10qD0WwLZoPknS77tbyu+34qzME9+VdPH/z7h1wAVfOsUaTb5Iw+f+/v6JPe0j3hRkushXV00n8gbcB9eLPRt5OmRL8jWmhz8ycJLbs65sMQfQiwv+X9XR3O5AePL+C9AeKTgDRp6swjCJRDvnuXaHfFyef4KKyilhUxRs/SvJ0+vtrvycNe2m/zx4r9BaW7ea2yZ1jCLASLeBtkkbkZHcO5L+AREDI/ELyZAKL+JL9r/Zcl3Yd8s2pXKJrGAJPp0VxHScQXlxTEhJZGNcuGVX2dkD9jIz3XSa3Cz5Gq7uGp1cSCaKFUQQr4FviMLSX7gEDa2qiJCbYs4vC2OYXykjpElp8fv/M1sxInOXvYBoB1GqQtZkXXB4fpV/Dvo8McC24ulPIxxax5qpS72vFNXiajz2Ep8V/czCvbCV9nDFsK/gToceXQw98uW8yaLSI/8IMjqE4wK5FXko/JveSLysfCVzjUjg2dTTTRL+KXdJU7eQ5/f3BfcYJ8agWlbEoROwrZsZXc4SB4J7tUabUcYZ5Fv9aUhg1M3XPcmxfPxab2XyZH/7pDh3znB1UAKpKrhp2k2Nab9ef9NLrp4AX8nbvbb9HJXoykLQ1g+38E7pxSzSaRYauJlmEeGH5I4KXG9VZ+CZhR3TPP3HSyDyC3oOuZupQfw9EvIvE6lz5SsXikGat2pEaA+a9ecJ6EbdSiV+a43atNHZuLjYrA1xEO9yd/osvN7F/OE2txZNWDsEyRAwZ2r48H7+KeSauGPHOYwAwxJiymrSIXO2mRmzcnTAR/XoLzKMIFCdG0mPK3PrxEWuMmFcCROI16cl
 63/BbZru
 mQxvjK/v5/bDvnn6dLugcCOoALDtATDGCrGr0Z4UgjZpTHiNzkAqaZw95bPsSWDYlVkTXG7BfsniSMumYkflwfM4wUa2U6b+1e/soUd5ftSqDAN/WPwLmLFvmy5G1VrPsIBzZV4AczcK8zQmfIBGdxkFRaUTeQvOc+AV9PwBe/lo7Xg60+g4sZ9DleyRz6rI3yqe/A0j9CJXvPP3euLYSygw3E4dtpBK1+Fe6LFxnjmiNr5UdMHOxIrO0bDepaUIYpysXpPzR5IitzToeo94nU+TRAzt4pLwT8rav5FNJvFXliBz2Cyay/nael+Pv+DRf0mjbXhQp4HdomCQ2deO3DospgDeRByWo+6JyFWhIPS/t/8hH9U3oxKtWQNG9DrpfHx+0ko8PKR7C5/UzxEZiEFWZFtzu6V8VDsjhuCINw09ODfUpy++0d5dBNqVHD3f7sP0kp4fTQcPkjrfvmczE/6rXg0l2WrOvtDHm0KGGz5dQnd0SWsuvpv5AKXByV+q2xDpcsuwLE0vG2+0qymc+7IiqSRL+RKj4Tlgbnd79XjLXPRP8aRP0ey8a6G1z+5mZ5ALYj/wEXeinNnaay5CDGs0lFtZlto+6kOOX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To enable support for SFrame V3 flexible FDEs with a subsequent patch,
add support for the following flexible Canonical Frame Address (CFA)
recovery rules:

  CFA = SP + offset
  CFA = FP + offset
  CFA = register + offset
  CFA = *(register + offset)

Note that CFA recovery rules that use arbitrary register contents are
only valid when in the topmost frame, as their contents are otherwise
unknown.

Cc: Steven Rostedt <rostedt@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
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
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    Changes in v13:
    - New patch.

 arch/x86/include/asm/unwind_user.h | 12 ++++++++----
 include/linux/unwind_user_types.h  | 18 ++++++++++++++++--
 kernel/unwind/sframe.c             | 15 +++++++++++++--
 kernel/unwind/user.c               | 22 ++++++++++++++++++----
 4 files changed, 55 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/unwind_user.h b/arch/x86/include/asm/unwind_user.h
index 9c3417be4283..f38f7c5ff1de 100644
--- a/arch/x86/include/asm/unwind_user.h
+++ b/arch/x86/include/asm/unwind_user.h
@@ -20,7 +20,10 @@ static inline int unwind_user_word_size(struct pt_regs *regs)
 #ifdef CONFIG_HAVE_UNWIND_USER_FP
 
 #define ARCH_INIT_USER_FP_FRAME(ws)			\
-	.cfa_off	=  2*(ws),			\
+	.cfa		= {				\
+		.rule		= UNWIND_USER_CFA_RULE_FP_OFFSET,\
+		.offset		=  2*(ws),		\
+			},				\
 	.ra		= {				\
 		.rule		= UNWIND_USER_RULE_CFA_OFFSET_DEREF,\
 		.offset		= -1*(ws),		\
@@ -29,11 +32,13 @@ static inline int unwind_user_word_size(struct pt_regs *regs)
 		.rule		= UNWIND_USER_RULE_CFA_OFFSET_DEREF,\
 		.offset		= -2*(ws),		\
 			},				\
-	.use_fp		= true,				\
 	.outermost	= false,
 
 #define ARCH_INIT_USER_FP_ENTRY_FRAME(ws)		\
-	.cfa_off	=  1*(ws),			\
+	.cfa		= {				\
+		.rule		= UNWIND_USER_CFA_RULE_SP_OFFSET,\
+		.offset		=  1*(ws),		\
+			},				\
 	.ra		= {				\
 		.rule		= UNWIND_USER_RULE_CFA_OFFSET_DEREF,\
 		.offset		= -1*(ws),		\
@@ -41,7 +46,6 @@ static inline int unwind_user_word_size(struct pt_regs *regs)
 	.fp		= {				\
 		.rule		= UNWIND_USER_RULE_RETAIN,\
 			},				\
-	.use_fp		= false,			\
 	.outermost	= false,
 
 static inline bool unwind_user_at_function_start(struct pt_regs *regs)
diff --git a/include/linux/unwind_user_types.h b/include/linux/unwind_user_types.h
index 0d02714a1b5d..059e5c76f2f3 100644
--- a/include/linux/unwind_user_types.h
+++ b/include/linux/unwind_user_types.h
@@ -29,6 +29,21 @@ struct unwind_stacktrace {
 
 #define UNWIND_USER_RULE_DEREF			BIT(31)
 
+enum unwind_user_cfa_rule {
+	UNWIND_USER_CFA_RULE_SP_OFFSET,		/* CFA = SP + offset */
+	UNWIND_USER_CFA_RULE_FP_OFFSET,		/* CFA = FP + offset */
+	UNWIND_USER_CFA_RULE_REG_OFFSET,	/* CFA = reg + offset */
+	/* DEREF variants */
+	UNWIND_USER_CFA_RULE_REG_OFFSET_DEREF =	/* CFA = *(reg + offset) */
+		UNWIND_USER_CFA_RULE_REG_OFFSET | UNWIND_USER_RULE_DEREF,
+};
+
+struct unwind_user_cfa_rule_data {
+	enum unwind_user_cfa_rule rule;
+	s32 offset;
+	unsigned int regnum;
+};
+
 enum unwind_user_rule {
 	UNWIND_USER_RULE_RETAIN,		/* entity = entity */
 	UNWIND_USER_RULE_CFA_OFFSET,		/* entity = CFA + offset */
@@ -47,10 +62,9 @@ struct unwind_user_rule_data {
 };
 
 struct unwind_user_frame {
-	s32 cfa_off;
+	struct unwind_user_cfa_rule_data cfa;
 	struct unwind_user_rule_data ra;
 	struct unwind_user_rule_data fp;
-	bool use_fp;
 	bool outermost;
 };
 
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index b5301fa9dbc8..4dfc8cf2075e 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -271,6 +271,18 @@ static __always_inline int __read_fre(struct sframe_section *sec,
 	return -EFAULT;
 }
 
+static __always_inline void
+sframe_init_cfa_rule_data(struct unwind_user_cfa_rule_data *cfa_rule_data,
+			  unsigned char fre_info,
+			  s32 offset)
+{
+	if (SFRAME_V3_FRE_CFA_BASE_REG_ID(fre_info) == SFRAME_BASE_REG_FP)
+		cfa_rule_data->rule = UNWIND_USER_CFA_RULE_FP_OFFSET;
+	else
+		cfa_rule_data->rule = UNWIND_USER_CFA_RULE_SP_OFFSET;
+	cfa_rule_data->offset = offset;
+}
+
 static __always_inline void
 sframe_init_rule_data(struct unwind_user_rule_data *rule_data,
 		      s32 offset)
@@ -332,10 +344,9 @@ static __always_inline int __find_fre(struct sframe_section *sec,
 		return -EINVAL;
 	fre = prev_fre;
 
-	frame->cfa_off = fre->cfa_off;
+	sframe_init_cfa_rule_data(&frame->cfa, fre->info, fre->cfa_off);
 	sframe_init_rule_data(&frame->ra, fre->ra_off);
 	sframe_init_rule_data(&frame->fp, fre->fp_off);
-	frame->use_fp  = SFRAME_V3_FRE_CFA_BASE_REG_ID(fre->info) == SFRAME_BASE_REG_FP;
 	frame->outermost = SFRAME_V3_FRE_RA_UNDEFINED_P(fre->info);
 
 	return 0;
diff --git a/kernel/unwind/user.c b/kernel/unwind/user.c
index 0405922c5c0d..eb7d9489f671 100644
--- a/kernel/unwind/user.c
+++ b/kernel/unwind/user.c
@@ -39,14 +39,28 @@ static int unwind_user_next_common(struct unwind_user_state *state,
 	}
 
 	/* Get the Canonical Frame Address (CFA) */
-	if (frame->use_fp) {
+	switch (frame->cfa.rule) {
+	case UNWIND_USER_CFA_RULE_SP_OFFSET:
+		cfa = state->sp;
+		break;
+	case UNWIND_USER_CFA_RULE_FP_OFFSET:
 		if (state->fp < state->sp)
 			return -EINVAL;
 		cfa = state->fp;
-	} else {
-		cfa = state->sp;
+		break;
+	case UNWIND_USER_CFA_RULE_REG_OFFSET:
+	case UNWIND_USER_CFA_RULE_REG_OFFSET_DEREF:
+		if (!state->topmost || unwind_user_get_reg(&cfa, frame->cfa.regnum))
+			return -EINVAL;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return -EINVAL;
 	}
-	cfa += frame->cfa_off;
+	cfa += frame->cfa.offset;
+	if (frame->cfa.rule & UNWIND_USER_RULE_DEREF &&
+	    get_user_word(&cfa, cfa, 0, state->ws))
+		return -EINVAL;
 
 	/*
 	 * Make sure that stack is not going in wrong direction.  Allow SP
-- 
2.51.0


