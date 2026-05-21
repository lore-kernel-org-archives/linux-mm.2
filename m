Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74F1ACD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:27:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C01C86B00A6; Thu, 21 May 2026 10:26:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCDA16B00A9; Thu, 21 May 2026 10:26:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A484A6B00AA; Thu, 21 May 2026 10:26:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 870D96B00A8
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:26:36 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 427AB40618
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:36 +0000 (UTC)
X-FDA: 84791652792.25.2575771
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf21.hostedemail.com (Postfix) with ESMTP id BF6311C000B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=pUdm0lBP;
	spf=pass (imf21.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779373594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tXpNIe7iOtik2FWOAaKIlzFM00E3KzCJxJoD0NRH//s=;
	b=QPNtT2ktnSw6TeLLUYMew2Ihv9toF9Vi5rngriFqTuGCQFVHzo1TPaOucv+OnPeaMpppTj
	juUZUvDKJ0Vbj8NRk5+6vKkKZTa46ZT1T9UKl9CPIj2qD2aopGUmurhBgRD3EolDWpfd0V
	C/E4mvel+UdNBSgoujk+G/419P7GXu0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=pUdm0lBP;
	spf=pass (imf21.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779373594; a=rsa-sha256;
	cv=none;
	b=bPqHaYkL6YIfAr2oR3U0kIdgX7U+Vjds7hkf85T2SDEfVH2k+4yHkHsmVEu4RhFO75j1nv
	MoN+5Od14Vj1yko8wHPcMXq9k4I//3QGfd4jjx6TJjvzoObxBS3qRA1adIKey6VXIwcD2x
	mBaXYCjeqsMyyPrYs0qHnEc9UV9uiCM=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64L5K7gl3386862;
	Thu, 21 May 2026 14:25:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=tXpNIe7iOtik2FWOA
	aKIlzFM00E3KzCJxJoD0NRH//s=; b=pUdm0lBPLgSHbq0mC/1gqs3dP72iRCvTL
	KaUXSrsywK5Wj62x7TVnnWXnklmZ8CjBWXn6EHeR23PDoYMAD6fkwG51ms2ee/xn
	pvZ6BTZFLK6TH1GoATaPXtc3ijsaUQTeORkz8RUacrq7GVNizlJ8Zxq2Ny10z77o
	0KJ861PXsednjzFlzip+r5JFWy1hnBP1SwgJgKsBZh4WOcNpCJLOjvew0VXNQ1is
	zUw8CQK5PQJ3nbzaot0RSx+JNCw5KcS7kV5rsb5ACQ6GpvRptS2CH/Y8v3lgUVI7
	EmDv/MkJI5SXW9Yk/NKq9UYUxNik0SVuI1Pc/1XTEuzpfwg21GMjw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h757dqm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:58 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64LEODZ1001765;
	Thu, 21 May 2026 14:25:57 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e72wqcst5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:57 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64LEPsdj13959518
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 14:25:54 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 400DF20040;
	Thu, 21 May 2026 14:25:54 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DED2F2004B;
	Thu, 21 May 2026 14:25:53 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 14:25:53 +0000 (GMT)
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
        Kees Cook <kees@kernel.org>, Sam James <sam@gentoo.org>
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
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v16 13/20] unwind_user: Enable archs that pass RA in a register
Date: Thu, 21 May 2026 16:25:39 +0200
Message-ID: <20260521142546.3908498-14-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260521142546.3908498-1-jremus@linux.ibm.com>
References: <20260521142546.3908498-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=ffCdDUQF c=1 sm=1 tr=0 ts=6a0f15f7 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=c48flIb4C_QYATK_dV0A:9
X-Proofpoint-ORIG-GUID: TsRj1JK-9_NOcNAOrQ63hcnC1LYaBrQq
X-Proofpoint-GUID: Gdy2mtPuOEojV51mMXhNIPimxaNVlX4F
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDE0MiBTYWx0ZWRfX3yjef41rB6Zq
 R5QuYeXLnQXPv5yOZJtgEzPNqCZoGljYuGOY2ZTi/xxP8a872DH9BJyBNOI46C81IrXvgyioPci
 +UgEhseJ/1XimuVL7sBjRH/fTUFCvRKjvlFGNF8nYFKJ/GSfkWEUsH4bOlgXtuxw+Ebp2KGgtUS
 McY1qXokwYq8O1P8MRbvvsUoxPjkA7rrQVGbcsZm7UveHaG6/9epJvFlA2xolz07Mg0XIsSi90M
 ojW51J/m1bNLhqB/gG6u5p0CmrCfTHWl1bgvgscjFKHeCq4mCOfFFjDo68cZj7WowXQ2Yi1buOv
 sDiNrk4R0mtK+wwujhdkOHuzm1EKG52ZStG1YByTEbvvhNfED1M2g3llRi3D+f0E6wWnywGZUFg
 j86oOUVHV+6/TnWjN0nbwnIS7PP8LPlKquYErnPn6f/VYMyoi5azRjus8cDXg9v0JDWZG9JN1Md
 yBMjriBPfVegPwClbQw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 suspectscore=0 adultscore=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210142
X-Stat-Signature: wzgrs4t8genmfagxdfj1zj4rrmn17nw6
X-Rspamd-Queue-Id: BF6311C000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779373593-751727
X-HE-Meta: U2FsdGVkX19mlDk9f/JwrFMQXNaGYs0vahtV/eIYODLIwwrjaSZ1nWypuz1utMV+2ia03ev4d0I5aLo/8tgasNrFsN5MVLWEB6uv1xSaKLVqQ3nU0BcRHhIvp2lnYh+ns7dNjGtqTtuFKYlVOVHcsjgyqzuQRSfq2rpdDhtpSkx4JdFLXcpUZZw9AyrgBNL+PC0ZCYgIUM5V3ORQTkgsrgcdJ0wPfgRzE652M81oBEm6zkWEJOcFOWJaEmbA60Do5RCw1FfX1tY2+DzoxPr3JmsMM30T+3w+H3JEdjImhXCpjkAXl7LWRgS/a5v6Kkp3iDaOozFXH4poIcaa2F24sd2576sseKHnSFtJdBX5fXY9VmFCjxzM/UYSD08uW5WYoJlglSePS9q6Ut9yuNoXy7NhGZoTRRFz8r3cH9p1YAHm7dGN+5yczkpIo1gDJ3Xv3pECBmGophYHesd8qg5AvEE7VStx0a8Ws45BJb03/GaYOc6KBydLvPO93UWhXHy4aK3IeZpTc5AfImUnAWlhmStddvWW8OwDHyw2dJXVVVtWjuH8BEDJaUgysUdfMaUBFnRHWo108n+WQSlJKBr6jagtzOl8a6tN8Hayns4MAYpMmJisMqpWM6tQ0GM0AnzO1TSFl1ntrmbPqFzqDcLdOogiOEiEJxzaO60U1IBvksqkAC4jT3jyU0zBJU3FgALzSBebVp2q2oL9kCRo8nhcc+wL5geDJmqdulkBtzRKjW+JzdT/uDYvOYru4TePy3eIHPdLSOuvJWl0rCyq9tjtP98zyfokNWtIaYqye0tCu//OzAlgIYynoFz4OZ8zIopUpcH+ddYLWjQUMi8fNAsElArZBU0yAHLpghlK9eCN0BCHm+rvN7lNRjkZ1NPDx9kUsmz/kPTgwO/hUcj6mE1zQyZz6v6E79X7eclBRMPuCvZZCXqTYtR3seSfPzhKaS4oqO/85dfHTK4c+WVZydN
 WSxwGE4E
 HdZcRsuDZ0e+ExLUGUvpl2u5Rmebr6S6zQC7lqLTP4nOXnE/J8DTJo4VVjGo0z2pezDTWcr3nbLTe2iLX7gbBo9xD1ql1yT85EqBmK3F37SbhCRvrcC9RK1nYl1JBIwg1L91Cbs8KRGuvpv5OKQ0graDiCCK1fWe1HkRztF2QJO6UHEDnwoS5N5ZNCo4hTJbcMDtJ3/UWjtuaUIWakWGlF9VElJ3sFMCB94yaDzclBmXSI4iL6Guhfux7Zl3OXmHSSNgkQYfZqD5AZ2ki78whowhrKFmyEQljEUWQbIliXXKfttSKf2ngXE3xgQpIxc9NrtFLDQaNWE6yB+UaRyGUQKUQ0xsJ6Dk2JTsQGINUJXSWitc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Not all architectures/ABIs pass the return address (RA) on the stack on
function entry, like x86-64 does due to its CALL instruction pushing
the RA onto the stack.  Architectures/ABIs, such as s390, also do not
require the RA to be saved on the stack in the function prologue.  In
particular, the RA may never be saved to the stack at all, such as in
leaf functions.  Unwinding must therefore not assume the presence of a
RA saved on stack for the topmost frame.

Treat a RA offset from CFA of zero as indication that the RA is not
saved (on the stack).  For the topmost frame treat it as indication that
the RA is in the link/RA register, such as on arm64 and s390, and obtain
it from there.  For non-topmost frames treat it as error, as the RA must
be saved.

Additionally allow the SP to be unchanged in the topmost frame, for
architectures where SP at function entry == SP at call site, such as
arm64 and s390.

Note that treating a RA offset from CFA of zero as indication that
the RA is not saved on the stack additionally allows for architectures,
such as s390, where the frame pointer (FP) may be saved without the RA
being saved as well.  Provided that such architectures represent this
in SFrame by encoding the "missing" RA offset using a padding RA offset
with a value of zero.

Reviewed-by: Indu Bhagat <ibhagatgnu@gmail.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    Changes in v15:
    - Define pr_fmt().
    - unwind_user_get_ra_reg(): Use pr_debug_once() instead of
      WARN_ON_ONCE() to prevent user-triggered warning/panic. (Sashiko AI)
    - Reworded commit message. (Indu)

 include/linux/unwind_user.h | 10 ++++++++++
 kernel/unwind/sframe.c      |  6 ++----
 kernel/unwind/user.c        | 20 ++++++++++++++++----
 3 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/include/linux/unwind_user.h b/include/linux/unwind_user.h
index 64618618febd..7bf58f23aa64 100644
--- a/include/linux/unwind_user.h
+++ b/include/linux/unwind_user.h
@@ -23,6 +23,16 @@ static inline bool unwind_user_at_function_start(struct pt_regs *regs)
 #define unwind_user_at_function_start unwind_user_at_function_start
 #endif
 
+#ifndef unwind_user_get_ra_reg
+static inline int unwind_user_get_ra_reg(unsigned long *val)
+{
+	pr_debug_once("%s (%d): unwind_user_get_ra_reg() not implemented\n",
+		      current->comm, current->pid);
+	return -EINVAL;
+}
+#define unwind_user_get_ra_reg unwind_user_get_ra_reg
+#endif
+
 int unwind_user(struct unwind_stacktrace *trace, unsigned int max_entries);
 
 #endif /* _LINUX_UNWIND_USER_H */
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index e6d66ae8e7ac..d573c2529926 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -257,10 +257,8 @@ static __always_inline int __read_fre(struct sframe_section *sec,
 	dataword_count--;
 
 	ra_off = sec->ra_off;
-	if (!ra_off) {
-		if (!dataword_count--)
-			return -EINVAL;
-
+	if (!ra_off && dataword_count) {
+		dataword_count--;
 		UNSAFE_GET_USER_INC(ra_off, cur, dataword_size, Efault);
 	}
 
diff --git a/kernel/unwind/user.c b/kernel/unwind/user.c
index fdb1001e3750..afa7c6f6d9b4 100644
--- a/kernel/unwind/user.c
+++ b/kernel/unwind/user.c
@@ -2,6 +2,9 @@
 /*
 * Generic interfaces for unwinding user space
 */
+
+#define pr_fmt(fmt)	"unwind_user: " fmt
+
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/sched/task_stack.h>
@@ -48,8 +51,12 @@ static int unwind_user_next_common(struct unwind_user_state *state,
 	}
 	cfa += frame->cfa_off;
 
-	/* Make sure that stack is not going in wrong direction */
-	if (cfa <= state->sp)
+	/*
+	 * Make sure that stack is not going in wrong direction.  Allow SP
+	 * to be unchanged for the topmost frame, by subtracting topmost,
+	 * which is either 0 or 1.
+	 */
+	if (cfa <= state->sp - state->topmost)
 		return -EINVAL;
 
 	/* Make sure that the address is word aligned */
@@ -57,8 +64,13 @@ static int unwind_user_next_common(struct unwind_user_state *state,
 		return -EINVAL;
 
 	/* Get the Return Address (RA) */
-	if (get_user_word(&ra, cfa, frame->ra_off, state->ws))
-		return -EINVAL;
+	if (frame->ra_off) {
+		if (get_user_word(&ra, cfa, frame->ra_off, state->ws))
+			return -EINVAL;
+	} else {
+		if (!state->topmost || unwind_user_get_ra_reg(&ra))
+			return -EINVAL;
+	}
 
 	/* Get the Frame Pointer (FP) */
 	if (frame->fp_off && get_user_word(&fp, cfa, frame->fp_off, state->ws))
-- 
2.51.0


