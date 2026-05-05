Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D10DCD342F
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 12:18:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 684856B0005; Tue,  5 May 2026 08:18:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60E3C6B0088; Tue,  5 May 2026 08:18:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AF856B008A; Tue,  5 May 2026 08:18:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 35C9D6B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:18:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D289D403F2
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:18:10 +0000 (UTC)
X-FDA: 84733268340.24.D171705
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7F61E4000A
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:18:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=M700GsI6;
	spf=pass (imf17.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777983488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D7noqCPYCazcZYmegzK8gDeD27rc6gFSdojocdj+bIE=;
	b=ugkr1ifkPTtOzLNfPW45AuzmAfRIubDkF3OLWWp3wXm7wJW2deF2f4EjyDN40TZt5tbCI5
	W7XqBxPmg8UNkh//6c7gIk6uioGNuZXNMxVWgDofi5AsR2x04g7Jy9yfLlH/a7tSp7KOQJ
	UwFg3Li1KyA265pcQJzarGwJNIz4cI4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=M700GsI6;
	spf=pass (imf17.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777983488; a=rsa-sha256;
	cv=none;
	b=mBk8OFpddAcflTLj8hppfo2/6Tmg4xQJqen7jvv+HzSWKImKxy7GwnUNqOOrjWPBgn7vNJ
	Q06HZGkemge4a1Q+tUFSuyIbJlvHfUajLq1zqd4g4D2fR2nteJq1S2TOJ49P/gb5C5/fS5
	JLjbkUNgGzwWiaHMncHvSra4nXhTElU=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64557vch2799040;
	Tue, 5 May 2026 12:17:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=D7noqCPYCazcZYmeg
	zK8gDeD27rc6gFSdojocdj+bIE=; b=M700GsI6fpLxZY39qIuGfs8gU26ppyxzt
	sTplffnoicHjs9+1ukSb26TbYpOQlLySg2kQUv0cDeGIVvD4CDpuvhL45B3t7FqD
	LwKvPFKxfuzxx2zFnaWUJnShUivIqxtVIDim4w8i6YPEs32rMD1b6LfLEAIKX2sr
	COeA467Lpo6rlqBv+VDLDKACNFUKAra3J2s1ji+DBqKJe0AFlYNk4FyRA4OJqq0w
	fZM5YTddQNuUcMqcOUrOw3YUVUQrHN79ZUAGqntPHVXpN6AKpwl5gaXoE72TChbK
	N/txdF4hoddSlcYVw09BZf1ITgzLf7WtSDh0dCN7VuNbdF4JG5IwQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9w6b778-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:32 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 645C9jXE024681;
	Tue, 5 May 2026 12:17:31 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dww3h1eqe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:31 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 645CHRWj53412098
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 May 2026 12:17:27 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B4C862004D;
	Tue,  5 May 2026 12:17:27 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 574E42004E;
	Tue,  5 May 2026 12:17:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 May 2026 12:17:27 +0000 (GMT)
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
Subject: [PATCH v14 15/19] unwind_user: Flexible CFA recovery rules
Date: Tue,  5 May 2026 14:17:14 +0200
Message-ID: <20260505121718.3572346-16-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260505121718.3572346-1-jremus@linux.ibm.com>
References: <20260505121718.3572346-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=XPQAjwhE c=1 sm=1 tr=0 ts=69f9dfdc cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=3ITeoxp6sJ8ea140DuYA:9
X-Proofpoint-ORIG-GUID: kbRZY4IQNb44J3QDwjWTe3rrmKPEvSrT
X-Proofpoint-GUID: IKG3yKTeIFE_ZvRr4_l1EAD91bUT7u7_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDExNCBTYWx0ZWRfXxw+wtvybTk5m
 UqUmubf+XGIa50ShpnhdjdKR1mte9y4sEK1qLuS9ZV8b1CEzY8RiGsm65HWuU7vB3vAlpZv9t0q
 lSekdtoA4Ekrkv69qxCRBHfJzW3xI9R4HA65x51hotseMjTtFL9bkbNl0MbQoGD90upqC64XF1X
 jcy13mu5SBssMZC414Xlb/3DSrPnBqN/SZYE0NcP16MVD9qc0mQjb07qZnag5Kel1N2zvyN2F66
 ENlzb2BGRDJOr1lkHLxG6SuXiYlb32lhMQRrbgg2fiFDL8TTW6YZHDlH/zvW8icecZc5iwvqnLS
 R5niyvNfawCpuQMm1jE9WO9C7yCVkw6tORgog2ulun0BE+4PmqAbnk07p1AktjeHO4E52rkMCAk
 YJrufw3+Rq1I6WQbldYZd71huomWhxFfAU2wJqbGArKwpqQC81f4HU1sQ0xEGq08osD6ea+wgEX
 Nop9U7RssFhhKcvX0vA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605050114
X-Stat-Signature: wcigbcix43rg69axr4p5h5b5hg3zogpz
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7F61E4000A
X-Rspam-User: 
X-HE-Tag: 1777983488-601674
X-HE-Meta: U2FsdGVkX1/udZ1Lswh5dM3vlzESeLOZ6kPieOgJozvGEQUsYF9hNHJAdqWVIseJsri5KrqeGk5/v/AH0ym1s6OOPKT1YLcBCb6O5PjuB4MD+JX/uxs9BiX/U5fypTAKlyF0qh14MvBN1kzJeX2P61JLN0PNPxcdIpT8/9gZdgtd96iRjxDD0pxEvaBtzPeYsM7qYCcHKkPJ5InGF05cmw4ijEIYFWEBy1goYrsxB81bYO3DjaUkbQW4xA0R7M/wOWeELNFuA1/xkVyDc9viLtWDWwflWk8PI0psFLusMrzLSDnf8hIgEwTCPz4Iol5q8vsd6kGuxqZBQ/asr9MsShR7vcozqJ2jE+JUP7VmsfsE0ha3pUn7VW9wSu8rQLjWqTxNpehLb2q0ytp7BeqvWhQf8hVkwVuHGwHH3bXfb/zs1OLcTOM6JC12A65s/nMmiQf7/TCtg1titTHX5zSHYsUeYA1HtAfpKW/bBXUYSk/j8+HgxT04HMiDXkZFexebb3f6eEaxDXLnAwEcHzeDNllgLJcGUMRhrajkfqIHFTbhvmJsQ5Q1X+a/+4fH2G8Zz9veBEjtC6xgmt1pev17qXi2mM/rKILXcch5IxYCqPOjMcUwKLdpmWmlndaryyfISvbRXpJNANEE0/TXGRbWVgRvSluim7/0KuBIgKLJs2gqqIJ+8Gd5aTy0WQCtpPLfQ5kb6Azt5GhSxcjLWmVWD9oZTmqi4oDl3sAvLt68SeYODGex3oaZEHMywlIUmn/fq+I3pU9UiOQMflDMvVBDTvJQOWhRwjpuhe0nqyYKGfnQUVVHmu4vI8jrLWZBDwsXZrt6DMxCgmi7vjVnqgsyH1EbSWzR3RsVoHdVHRxNStuiOSMYRB4kiktsDNgwzcB/iyMnqjZXEAdGM1vb0JDNUe78bp42Ao1vOLsMaNNmWtytKgescmvcbn3MfkzyF65vm5fY+Z/QaPkJ9SJQha/
 32LaBBhL
 VrYteHM4qiLrOjJ6F1craZrZQURkMwueQjNqw9lNo05MOmwRWuVhIp7C9kWlEBQCq8OmWCjx0P1UNQ5/aErXu3X9j/Ir3oZc3bUNLog+so7hz/buCSPijSsoRUAt0AU44WVkAdK8Vo5aQGmbkZzX9Tcl17dKi/jW3/kqneYPuyf6gHPIiyiKN2Ro3bFJ5m3pFAlE2gV/8wk5baE/yaIvr0HjAXE74rTmBFW+C8yqgESqlK208A9uua2RC3x36S9AvVj1YuVJdV1zeoXs=
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

Reviewed-by: Indu Bhagat <ibhagatgnu@gmail.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---
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
index cc57804aa3b1..2721f4af53fd 100644
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
index 89aecfbe3e84..3d596da588d0 100644
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


