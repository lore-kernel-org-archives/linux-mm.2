Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD7FED1953D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 15:06:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76AE76B0096; Tue, 27 Jan 2026 10:06:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EB7F6B009D; Tue, 27 Jan 2026 10:06:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36F9D6B0099; Tue, 27 Jan 2026 10:06:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1C1E86B0098
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:06:36 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D9A3A898E2
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:06:35 +0000 (UTC)
X-FDA: 84378070350.01.08C7AFA
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6219B180017
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:06:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ZrLz45tC;
	spf=pass (imf24.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769526393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OpFpBWS/xAQ6vWdqaep5WPali3+wOicQDYDVioZk2LY=;
	b=r6oAxMI3efCqDu7jYxfSDMDuW2XCOODFTyi2QxFdfp2NAWTvY5FbL0FFkvvHNkaxqFlHQB
	+NMrCDmu02vI5Yplp7K6Z/Wqkdo1Bio7oBeCbiDCLdjkDan9wMRLkI5I7FrPRz54McxhXO
	KZGQLrrnu6YzZtZ7L3wiXtmwLnzyEBk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ZrLz45tC;
	spf=pass (imf24.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769526393; a=rsa-sha256;
	cv=none;
	b=yx9XENoSCh8jLMC1cDjT4lpUhVVspiK/+2FA8tWSZ7SV7KMZ+XKJQD9DVV2rRGGoqINzQx
	FguLjVrX9g/PBh0q6W9AchI90O6nSb2RCVgceS9QVyLdSwio6NOTAcHQ+R7ftmuA2OocGN
	5nAD3gx7QEC0tc1771vru0iufGke6Eo=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60R8n3Ej004217;
	Tue, 27 Jan 2026 15:06:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=OpFpBWS/xAQ6vWdqa
	ep5WPali3+wOicQDYDVioZk2LY=; b=ZrLz45tCR7SH0jkkcoDPIuu2kDowMxQI1
	lzqvbX2tWzPG0CBus3MuI0fzbsuHotR9EdNJ/Puvt3UWrW1Lw7jJf9q0PCZcduvF
	yDObuk3umDgDJx1RsKNJyqz02j42yrqwjZJ9BH27zzgG81LV+6SiW5MDyFf4iVwR
	4Am2rF+r37mhDxDDQnpga9nK7tannx9Jo/Cidfqs51acOzMwLju19xveKPrZ/yLS
	njFNrZBrFuw9nwypd78BNfg8ifgKJZJluCb2nygvcNZHqpnvSHHq9FBDQaVv1uUf
	5wiZPJxmPxkNne6IbzXsqizBeI2mQUjdE3+9/a8swEh2dxdmN8I+w==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvnt7p1kh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:05 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60RF64YS031490;
	Tue, 27 Jan 2026 15:06:04 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvnt7p1kd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:04 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60REAE0g023722;
	Tue, 27 Jan 2026 15:06:03 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4bwamjrwhx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:03 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60RF5xDC37880188
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 15:05:59 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 568EC20040;
	Tue, 27 Jan 2026 15:05:59 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F216B2004D;
	Tue, 27 Jan 2026 15:05:58 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 27 Jan 2026 15:05:58 +0000 (GMT)
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
Subject: [PATCH v13 06/18] unwind_user/sframe: Wire up unwind_user to sframe
Date: Tue, 27 Jan 2026 16:05:41 +0100
Message-ID: <20260127150554.2760964-7-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127150554.2760964-1-jremus@linux.ibm.com>
References: <20260127150554.2760964-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _vLn3dmPI5jstfJPr09Re077zRhGt_j9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDEyMSBTYWx0ZWRfX+tZzNgx3Girk
 Q34EgBlH4RYHuj+XZucDOKvQxGt4E0LCZryiltuHy6cdxj3HbbjhLtaM+MLF6hiiSrC53ON2nzu
 0LALSK+Sb2K3hhHMluJZWm7NJGlcYK3ZZ+zGGTy60ARHu8sjrds8wPq5S8GDayOGjTfYVPo5YYI
 UBdgqOkMj+3ySFviF9UqmzIeJWA6C3hrZwvtvhxNWW9dMjIbW/BAcemAzGSfJnVpXP2hl71IQ55
 Fju4zEWnuyVyCehGPSStd8sEHlZguyyrN5mMR4P3qAYyCqf5Dk0n/R2GaI4EGlS8kZ3z019FBNk
 +p2ShdClPrTtBIIf2gEn7cGpI+A+m6NBGQmDJregnenEEQSfZrCM6e5TpwJeZxFVvQBHdUUl7/K
 eJuMKh9W5YzhsJSEgqh+rS5Ug1Zgq40cAJ+ILSihLjdwRlm5JLcil46mM6cAC9Ixe9knCvWqOiK
 2y1cTo0isDWxo4h6OMQ==
X-Authority-Analysis: v=2.4 cv=Zs3g6t7G c=1 sm=1 tr=0 ts=6978d45d cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=7d_E57ReAAAA:8
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8 a=yMhMjlubAAAA:8
 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8
 a=meVymXHHAAAA:8 a=ZumjT3II3fW-INSmAFwA:9 a=jhqOcbufqs7Y1TYCrUUU:22
 a=1CNFftbPRP8L7MoqJWF3:22 a=HkZW87K1Qel5hWWM3VKY:22 a=wa9RWnbW_A1YIeRBVszw:22
 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-ORIG-GUID: 93xmvXR5SG-tXz1DxtBs637NzhJoO2U1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-27_03,2026-01-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 phishscore=0 suspectscore=0
 bulkscore=0 impostorscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2601150000 definitions=main-2601270121
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6219B180017
X-Stat-Signature: z76cob3wod71gquicqqcayopxz9s75qm
X-Rspam-User: 
X-HE-Tag: 1769526393-77193
X-HE-Meta: U2FsdGVkX1+D9gfVAyvcSbgIg6gbG/3ncwGqIXI6XSB1V4GWkoX/LKvarYvprVb6i697CtlNuVixstZ6spmM7g54uBkhv57QEW1FXiREK0yyQwOeO0JaeYcAkxVlKOZm0CcehPkoTMUXm9GcM1IRSFlslBY7TscXVZ1U3pAhk2APJZesGTkkAo+5VVgXD4ZL7AtknM2T2EPBHf3IIvCQfGofwThYCMo9YqjTembKE42kKptIZyz6Kr4kE50P6eLkaPaIDUgH+e7AonPyCED7rOqKBgE3VeSY+dj6KMelBbixFvkTHbtxGDKsIIUpxwk4BkUHrZ7MGt91NCdU+HnVOYHpjVKzfnIBODNZDnoJu5GIEFvI+HEvRTuHBl12gpbdwxqvAfmsQfwW60rPj5g9+amUYpkJFcFDM2LI3wTOeyB/K276vdh+rEf5J6Lt2GGCnUMmwlfDO8NxOC9harm29qE0vGsu4P0B2FPBicoElMgg9pkj5YlDwZlcGbMdFEAZ5VgA9/o2ebbJe+/Q3XX/WNnFrfDTDzq7/PQGfm6OYy9IsQR94bW3RqfN/3cSJukwViQDGJmUfnUb5H5VEiC/Doet6Luh9o6d6VVe8b7J72ZKnIikb8JPQmSIu4UXosZMaYHDca2BbN+ubARNMLrYm+ST9sDR8BsioZfNvErKWnz1O2BHGjUS0tbGDskQC9KruXeStNN4+FBDj9d7/owLJI2lnZmZtxZIYIWBsaXICWBIKNQ13SmD/iJgGVb9pXZD78tKdHbq4TiXdwrTy6dDGbt87PrheJ9SQTpI95R7FP9OytVqt7qoOzSxC9IP5wzKrzkNyFrQ3NZYCuyRjm7pXhw2h5CwCb1NQ7O1M8rfC8VCsF3/r53aemlJQFPVJmnIBt7M/lpW9zoupMgYrXfjeh6yASthe5hK5PF1ileDZZ1k0hrU/3/RumYx6XZ/QyJT4YBjNSMGY3yI/WR/yvl
 FfhUQt1O
 AURRSjkgtS3ADr76xM3YrF76sj+WIh6t2yptFkdvCBEkeS6m4J7VE0/GFHWOXRbEeSp1y7gfBpaMiNamqf6pct7+tTqN+GV85YQFbySyzWRP3flDR30uZDmpL9dYeHJRTy5qeFzlr9xXmfwTbp/0V0dghhIwxrzCv6/Hya9RSWM9p7FVedR1AcqEUNGQxMR4rxX+knj9Y5DMb/RV/mk1Ir+P5YI7XJKe6nbMpd3Y3SD+OjvxWxLGaVFyK3Xqw32TA/iVqGziP7QHnl3k5DIWtVUUcxkAq/EWiZgtRagKOML1NCbInCeFWO1twXgLbL2ecv6K6b91BO45zqEjWcK3AbOTLiIQKAcGb6eZqBJSyzq46uEBjTehxJnNzauki9TkEi4crxPXl/X5220VDdvIcKndxSgYx+/h0WUtr7LMsALrSRESE6WZYpftKqVC9XSM2aUQrsZfQwXtH+tTdNtX3eR4MWKC1NXRz6aLwaCBF755ZjV4Lkp/8S9LdARQmVSAcwXRLcn561VxXDwmBzOeJ3bVhZdxFpA/Q29OuyuNzm0aTKvplwEHWMn6z6Mm1qOIz6qDo6frLifwHW4KbJd1VmGrjoI9xMNkk1J0ZUteoY6VoEatuUkJKajqKFRi3xEZERnsZpuRWg86gqex/ns2XvOFypNPqhuZwuezg4X6Nd+BZtxSe5NbPbK4w9gGliw6+9wJV63zHGy0R2DHln3JD1WFC0Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

Now that the sframe infrastructure is fully in place, make it work by
hooking it up to the unwind_user interface.

[ Jens Remus: Remove unused pt_regs from unwind_user_next_common() and
its callers.  Simplify unwind_user_next_sframe(). ]

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
 arch/Kconfig                      |  1 +
 include/linux/unwind_user_types.h |  4 +++-
 kernel/unwind/user.c              | 23 +++++++++++++++++++++++
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 7d5517364d8b..2ece3df821b5 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -488,6 +488,7 @@ config HAVE_UNWIND_USER_FP
 
 config HAVE_UNWIND_USER_SFRAME
 	bool
+	select UNWIND_USER
 
 config HAVE_PERF_REGS
 	bool
diff --git a/include/linux/unwind_user_types.h b/include/linux/unwind_user_types.h
index 412729a269bc..43e4b160883f 100644
--- a/include/linux/unwind_user_types.h
+++ b/include/linux/unwind_user_types.h
@@ -9,7 +9,8 @@
  * available.
  */
 enum unwind_user_type_bits {
-	UNWIND_USER_TYPE_FP_BIT =		0,
+	UNWIND_USER_TYPE_SFRAME_BIT =		0,
+	UNWIND_USER_TYPE_FP_BIT =		1,
 
 	NR_UNWIND_USER_TYPE_BITS,
 };
@@ -17,6 +18,7 @@ enum unwind_user_type_bits {
 enum unwind_user_type {
 	/* Type "none" for the start of stack walk iteration. */
 	UNWIND_USER_TYPE_NONE =			0,
+	UNWIND_USER_TYPE_SFRAME =		BIT(UNWIND_USER_TYPE_SFRAME_BIT),
 	UNWIND_USER_TYPE_FP =			BIT(UNWIND_USER_TYPE_FP_BIT),
 };
 
diff --git a/kernel/unwind/user.c b/kernel/unwind/user.c
index 90ab3c1a205e..1fb272419733 100644
--- a/kernel/unwind/user.c
+++ b/kernel/unwind/user.c
@@ -7,6 +7,7 @@
 #include <linux/sched/task_stack.h>
 #include <linux/unwind_user.h>
 #include <linux/uaccess.h>
+#include <linux/sframe.h>
 
 #define for_each_user_frame(state) \
 	for (unwind_user_start(state); !(state)->done; unwind_user_next(state))
@@ -82,6 +83,16 @@ static int unwind_user_next_fp(struct unwind_user_state *state)
 	return unwind_user_next_common(state, &fp_frame);
 }
 
+static int unwind_user_next_sframe(struct unwind_user_state *state)
+{
+	struct unwind_user_frame frame;
+
+	/* sframe expects the frame to be local storage */
+	if (sframe_find(state->ip, &frame))
+		return -ENOENT;
+	return unwind_user_next_common(state, &frame);
+}
+
 static int unwind_user_next(struct unwind_user_state *state)
 {
 	unsigned long iter_mask = state->available_types;
@@ -95,6 +106,16 @@ static int unwind_user_next(struct unwind_user_state *state)
 
 		state->current_type = type;
 		switch (type) {
+		case UNWIND_USER_TYPE_SFRAME:
+			switch (unwind_user_next_sframe(state)) {
+			case 0:
+				return 0;
+			case -ENOENT:
+				continue;	/* Try next method. */
+			default:
+				state->done = true;
+			}
+			break;
 		case UNWIND_USER_TYPE_FP:
 			if (!unwind_user_next_fp(state))
 				return 0;
@@ -123,6 +144,8 @@ static int unwind_user_start(struct unwind_user_state *state)
 		return -EINVAL;
 	}
 
+	if (current_has_sframe())
+		state->available_types |= UNWIND_USER_TYPE_SFRAME;
 	if (IS_ENABLED(CONFIG_HAVE_UNWIND_USER_FP))
 		state->available_types |= UNWIND_USER_TYPE_FP;
 
-- 
2.51.0


