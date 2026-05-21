Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC985CD5BB1
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:26:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 566A46B009F; Thu, 21 May 2026 10:26:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 517EA6B00A0; Thu, 21 May 2026 10:26:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 390DC6B00A1; Thu, 21 May 2026 10:26:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 23F586B009F
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:26:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CC7E4120382
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:19 +0000 (UTC)
X-FDA: 84791652078.12.8ED633D
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf14.hostedemail.com (Postfix) with ESMTP id 70FBE10000F
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=e0Ywr07o;
	spf=pass (imf14.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779373577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5irpr9rOlWjTWrqmW482DA2bRuYyju7MyCwzXKRg+uU=;
	b=mzH0ssgf65DqVckFK0DHQdQzFD/9p7BSsKEktVMLARK0Rworunpub7ZCjnSt54gIdXrwEb
	HxilQ1YNA8xElHA91HmVnX9lcT8XteHW5I1ETaDNOfla9WclC3P9wLaxsDrSA7q8ullGZh
	pvj7yzrqNtnSwgYTrt3j7teUUxPQfb0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=e0Ywr07o;
	spf=pass (imf14.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779373577; a=rsa-sha256;
	cv=none;
	b=yUJ2+D8SPfeXBR6zE1eLrfFM+yMGlKt0yoK/8q49JirAbodWfMNkvsvpwhTs2s4eo5FlZd
	koT1ujaBEd4VAmjuK2Q5z0mQ6ibWTCkIvLERaODiAhCV/lSR3loaAlaGd8OnUyO8+E3F/t
	sS4vq1l17ZBXnuH2IdOcbkFINu8+IJw=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64L56Khs069859;
	Thu, 21 May 2026 14:26:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=5irpr9rOlWjTWrqmW
	482DA2bRuYyju7MyCwzXKRg+uU=; b=e0Ywr07onk9FcOp5qUG1/jwrfyqcr/GU7
	eEU604e3M65Tf0sTXHr6CdwMxr9UZmFSJYopHy7jhpQbKdd9JTfQEFH44xDZ0rLH
	oqn6XAxLk5k2DZ9KkEXrjrCxvBzK7Lu6PrxOzY+JdfJ8ozFjnzmmgmyPMqFhh9Ii
	fWsbfC9tJe3UfNPaoWCf9ydY62nF0KguZFgh/ZmsoD6A/jSdMUEbgujOsJdDrMRq
	imViCKbi32RVAKKjtAIE+u0689E7Tf0U6p6QIpczGl2H4W5NE7OYfRQPKV/XV3bF
	w0kvQ53YqjZ+QC+fqWpkaDiTDfSyCCELZL+71VgYMy10sTQTH3JQA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h8myda6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:26:00 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64LEOCKi031746;
	Thu, 21 May 2026 14:25:58 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e74dhvg7h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:58 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64LEPtQs41746878
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 14:25:55 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 13A3D20040;
	Thu, 21 May 2026 14:25:55 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A86CC2004B;
	Thu, 21 May 2026 14:25:54 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 14:25:54 +0000 (GMT)
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
Subject: [PATCH v16 15/20] unwind_user: Flexible CFA recovery rules
Date: Thu, 21 May 2026 16:25:41 +0200
Message-ID: <20260521142546.3908498-16-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260521142546.3908498-1-jremus@linux.ibm.com>
References: <20260521142546.3908498-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: kwhKWSQeOAXgzUmfflqpuN0wDjKfueBz
X-Authority-Analysis: v=2.4 cv=GYMnWwXL c=1 sm=1 tr=0 ts=6a0f15f8 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=BPVtMwLGy6aXIs-GLTYA:9
X-Proofpoint-ORIG-GUID: 6RquB8GktKPEIBT5chMdl5xPc8EKjIzb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDE0MiBTYWx0ZWRfXyoEnIV/bfXRh
 isAk2DjOkMXZyrH532IbLlnMwNTmqvg9jJ9slIx1qFEHqYxd7GFsoKt95nCPvm38KS5WQByyuX8
 s3AHrMWP4KkbYrpBXlbmsRCieTOJ+wxZ409zD5VsZH1tT3bnfjBCITUHivN/hvp7PclPI+/qUo7
 J4Imcon2yQrobiJnqZ4SGIvXajywFoMkP8zb1ZBqjfsB+FFh0IlBLhEdh3RsMrn4RkSyA1gMmRm
 tPCm5JIsgmikq8dLo1zI1q5679+xTWR30GFG9pr+o7GhncOKTkFsfWnDh2IEmIFHcuYBEUTVH+p
 DkAXU7GdBbYJ+fERkuYjTTH72gIa1FVPoS1YLpaHDqtL45lxS+j6l14G2yG0UTPvTIBIK8qDv37
 4SpW7kupcZzHz7sNkzuuapYZlGPOW3sjgnyfYh1eu2OnYebQ7wobBQ4ds1gMYcw7OeZ6UTC567r
 GGRTszWzSGZEpR0J++Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210142
X-Stat-Signature: kwwz8hp5cqcoq5jhxjggrxgaahx9mfyn
X-Rspamd-Queue-Id: 70FBE10000F
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779373577-700575
X-HE-Meta: U2FsdGVkX185Hne/HRI6POE7K5GKvNebKkSvfT6G0we9LSiN+YIfiJybeaI7QJNUNPYHC7g3Wzy3XqHeOPoe43E3ExuU9B/TCPw/8uzu8Bd+phGe6ZovG4lUHjCJ5xHA2j/yRWRnPDZDkbuNRXig/b/fIPh5PyDVINxf3oOEjF65VscwEaSnC1UBW0xVTztrb/PqrJ0xjEykiRc90qln3Q4m8bIRtuD3rvxkB+0EwDJwQMVqKTW79eckmqX7LBdzQ7z427ijK1EWQPRDpcLWV35lNG4gzDMTNbyx5IKe4OkewA/WTdKko7HWF/sTEUarSFz5AHhWMhcooHdsf7KMXtTIOhOq0OdPEC5OUPRMZZW6yPFjV1Zbu+3W5gYIYLHbIPI1J/PgKUrNjFJ2b44nepcPBL/z0gkqsmt2zp9ARkH0ymMsbMA6buu9Q0QNgj3J8ZQojB5qRJTuO+LLoa0G4A0k+TD0QCCxWEdqW47iZwnCeLCjjFzB9LjZWTk64gcGtvM6tWqw8fVtVvWi5HcbOfuEWtpu4wigwKOZKSQ4jik9C1FQQkfmVmZfn8L5dZv0fJ2T2frV9nhLpXLcKHhd1YKJkljqOgHG3b0XhS2NpNSy+3aBS6pxGic+ADgkX+drEk6ECUsHQEKsvgxLZiO+dD0KnTUIFU/u6lmuvjoGlLBPd9R7ZKMuBrv6VNcGZGSYTLs/l8fNjU/YQeZ7ZXjdTB3WNWgZJtwE+edDFyiw0ZaECeqBfxHDsSP5MF/HoGkq6aao97IJOCtxM/dKn15AFhyr0RTN+3+7Y67I58nr50Sp0xwVWT4yWygZ2b6TtxJmtwvdN29JBTC+hKMH5LFMYCjSC1Ta1SqjDcftBGW+vzFvDe9hOjB370V0c0MuZ1coVCl/U2pVLyGz3wKN/1ps8u5uG6PFOoE7wJ/pv2jgmMl3zUpQ7PUSHPb7TfCKwRmH+nkZJeI8dG31DBHOAo6
 77WatTwT
 eWOnaDgghhkL7sONGw1xIHlHxIvXVWMR7xnJO/FFnSezAWieytE6IKUScWjn6fpgcgq23+HxTRuh05tZK/np6m8xMvZYMoVs9VukGXXbpiEcJyQoDk2ZFdlf3jman9ZgFRvUr55wf+sAmBteDU2xBB/J8pTrT87/MSRAWOn0WY8cWqh2tFM2MDw+S/9FTIQ70z0NHMK8sUDb5clpGkTItJxFbZFQJBvHMcvkNbtLixMvdLji9ihrW0jEVubU2XcJluUhBKsZ93ZtOFmA=
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
  CFA = *(SP + offset)
  CFA = FP + offset
  CFA = *(FP + offset)
  CFA = register + offset
  CFA = *(register + offset)

Note that CFA recovery rules that use arbitrary register contents are
only valid when in the topmost frame, as their contents are otherwise
unknown.

Reviewed-by: Indu Bhagat <ibhagatgnu@gmail.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    Changes in v15:
    - enum unwind_user_cfa_rule, unwind_user_next_common(): Add support for
      SP/FP-based CFA recovery rules with dereferencing. (Sashiko AI)

 arch/x86/include/asm/unwind_user.h | 12 ++++++++----
 include/linux/unwind_user_types.h  | 22 ++++++++++++++++++++--
 kernel/unwind/sframe.c             | 15 +++++++++++++--
 kernel/unwind/user.c               | 24 ++++++++++++++++++++----
 4 files changed, 61 insertions(+), 12 deletions(-)

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
index 0d02714a1b5d..c18be5b7d586 100644
--- a/include/linux/unwind_user_types.h
+++ b/include/linux/unwind_user_types.h
@@ -29,6 +29,25 @@ struct unwind_stacktrace {
 
 #define UNWIND_USER_RULE_DEREF			BIT(31)
 
+enum unwind_user_cfa_rule {
+	UNWIND_USER_CFA_RULE_SP_OFFSET,		/* CFA = SP + offset */
+	UNWIND_USER_CFA_RULE_FP_OFFSET,		/* CFA = FP + offset */
+	UNWIND_USER_CFA_RULE_REG_OFFSET,	/* CFA = register + offset */
+	/* DEREF variants */
+	UNWIND_USER_CFA_RULE_SP_OFFSET_DEREF =	/* CFA = *(SP + offset) */
+		UNWIND_USER_CFA_RULE_SP_OFFSET | UNWIND_USER_RULE_DEREF,
+	UNWIND_USER_CFA_RULE_FP_OFFSET_DEREF =	/* CFA = *(FP + offset) */
+		UNWIND_USER_CFA_RULE_FP_OFFSET | UNWIND_USER_RULE_DEREF,
+	UNWIND_USER_CFA_RULE_REG_OFFSET_DEREF =	/* CFA = *(register + offset) */
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
@@ -47,10 +66,9 @@ struct unwind_user_rule_data {
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
index 29a874a67f32..daa97d8b0231 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -285,6 +285,18 @@ static __always_inline int __read_fre(struct sframe_section *sec,
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
@@ -346,10 +358,9 @@ static __always_inline int __find_fre(struct sframe_section *sec,
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
index c6a2abac78e0..447061b10613 100644
--- a/kernel/unwind/user.c
+++ b/kernel/unwind/user.c
@@ -53,14 +53,30 @@ static int unwind_user_next_common(struct unwind_user_state *state,
 	}
 
 	/* Get the Canonical Frame Address (CFA) */
-	if (frame->use_fp) {
+	switch (frame->cfa.rule) {
+	case UNWIND_USER_CFA_RULE_SP_OFFSET:
+	case UNWIND_USER_CFA_RULE_SP_OFFSET_DEREF:
+		cfa = state->sp;
+		break;
+	case UNWIND_USER_CFA_RULE_FP_OFFSET:
+	case UNWIND_USER_CFA_RULE_FP_OFFSET_DEREF:
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


