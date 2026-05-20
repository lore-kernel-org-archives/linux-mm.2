Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0E24CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:41:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E300B6B00F2; Wed, 20 May 2026 11:40:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1C466B00F5; Wed, 20 May 2026 11:40:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A840D6B00F3; Wed, 20 May 2026 11:40:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 854A66B00F2
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:40:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 503E0A03A8
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:40:54 +0000 (UTC)
X-FDA: 84788211228.05.2AE976F
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf13.hostedemail.com (Postfix) with ESMTP id A4E392000D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:40:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=k1KFasrD;
	spf=pass (imf13.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779291651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FvnhYyrYWxk5OBPJwrKrmJeEttrxtHxGpLoGH3hJxZs=;
	b=I7Nj/OM2Z/OFREVmPRg7MXMKnw37oSwOvMxurTBxbQXfFbTkEDeeeCRd8Jo7B09e7twRxo
	BeT0DbjcnPjMwDZ0rDbB6Jv5gr+9aCBWMChL+vRk55muiRWpivR3EYxvQk7JMICK3iCbjT
	jsBzOSYsFgtBgU5OCW9LaWmuz3i2QDY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=k1KFasrD;
	spf=pass (imf13.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779291651; a=rsa-sha256;
	cv=none;
	b=H5KN3rYcw6Gn474px53T5cAkKLbLO+PIbJ6aquWAVi0CSijKTy7PP1E04yLOr9gfR6eTEp
	v0bSFb4+TzZcOsJscbUO7GPWhN+tvIkLXuwexHOK2adrArYnr7y91be/9fQLyWlXx+ppaw
	S1vYf3RV0z9BU798qjVNUjscGsDofUc=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KCRhbk3865883;
	Wed, 20 May 2026 15:40:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=FvnhYyrYWxk5OBPJw
	rKrmJeEttrxtHxGpLoGH3hJxZs=; b=k1KFasrDyTafj1qOG5EIYrtKV0BVDDtdb
	1wfpIV9M6qRX24vBDSW5+ZV/3vbXPhXE7JOMO6LSB+NhWs/LUDTEPFI/AcI7dJhF
	+R0JkefrN/fLK/PjXCG51fSSphb1+v9UrpSrD0GzFMoAmkcCzTlCY16B73qmdI2R
	bXUqWGD4PuSt1RyDjv4+018fNfTTclqKxzwKXiEXcVAHqckI0PKALjmzhqULw32s
	KOwz2wQxQ1z2561GHdYk00MFcu5cJ/uw1Ey/SrkP/lEO5oD2UXOlF8/nS7E8GNaN
	m3cADQz1wXr67wtANX74zBxwEnXq0f35ZM1ZzNGANK1eL72jQI06A==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6hb8hsnh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 15:40:16 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64KFd5QZ026071;
	Wed, 20 May 2026 15:40:15 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e75ky7q64-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 15:40:14 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64KFeBZ515598062
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 May 2026 15:40:11 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7236420040;
	Wed, 20 May 2026 15:40:11 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E4B102004B;
	Wed, 20 May 2026 15:40:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 20 May 2026 15:40:10 +0000 (GMT)
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
        Ilya Leoshkevich <iii@linux.ibm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v15 07/20] unwind_user/sframe: Wire up unwind_user to sframe
Date: Wed, 20 May 2026 17:39:51 +0200
Message-ID: <20260520154004.3845823-8-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260520154004.3845823-1-jremus@linux.ibm.com>
References: <20260520154004.3845823-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDE1MSBTYWx0ZWRfX1/SYL7+2n3s7
 aLSsXixcBHlsytcw5OQTh3jpKRlKfFSg/jpcGOoSFbT5WCNeZIcg6OZmPPWaj6ynOwGlCbSAPGM
 G7kEBRbez8PijWmEAZ8Yw8xzDHP0/KY+ZVyYf5tVsBUSqAxz1hVguRch08pJ308XuzkLv8Ygfd7
 Bh+WwQb5r1iqsma8FF2P9uyc8WkdAh6x1BnWL0AXM4RJvrpPwg0676nz73fxvT3Y8nQXCJwj1ig
 tAf2or4g0gOB5WuZTISmc06Icmo2cUG64KTreuseZM0ySFKlxd+yXIaq9TDMeHmAGUhcOjK0X27
 Dxxe6pqcqDqBXDblIWS/EVcVzVKnq81wDS1OB0dUQO7PIw8PparzGnsWy0vSlJtF0eoV1hEl9q3
 P2i47GHpjKG+XRZlUnv87ZHXUSvIE70zcVctHnl7Kpzcqa52Eu5qCjvIb9TYmF6f9GgqwLqI/bj
 FTHFPHUHYd1v0gWWf3w==
X-Proofpoint-GUID: JJRgHReXCbHr6ZJcTDCpGLa5yjE3ZG_H
X-Proofpoint-ORIG-GUID: kwkMNcL2g_NLE0Oar4XAplhdwsm003rE
X-Authority-Analysis: v=2.4 cv=aYBRWxot c=1 sm=1 tr=0 ts=6a0dd5e0 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=ItKwCHsCKAUqeRWvWoIA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605200151
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A4E392000D
X-Rspam-User: 
X-Stat-Signature: siddiz44cqaczi986uopag8867j4t7i4
X-HE-Tag: 1779291651-604140
X-HE-Meta: U2FsdGVkX18IlFjtYq2Zo6MMJDdms74g2EQCHcVB7elzXZ10ewQ7l0r9b/sI0Is23iHF3CydNQlIamk6JB0HkfUjJ4NcFarCaWbrEy2s27JTPuKDf6f1HD6pMSGozviiXiWrRomAAgDASq/E2HMR2Q9JaKbh+TzmbKdHYuvOypVgDYPKWM0C7YfIREiv3A6myIaKyit2plxRWP7UWQreipi3GPko6KJoEwfOnbCCDmU2pX3aujGa88wjvpPJVBsYu7HHAJ1S1vOrUDOB/vPsYVOgeBc3GF3ixLNig99SbmCeeWaTq+CjRT9XpT+IS2Q3Svm0BfhupJ4JPkhjsRgaEFlw9XmUUqZkbHpix0FkisAoYmWuvVwKNoi7MDGHmiEE7IF0mlsAKyDqlf30IplM34rF781w0NwPjnnKs7Oj8UFXc/nnhDli1qOZcfcCkncj1FW9ZMEvWnyDj2s+82veN3LL9u/fir6Stx2tVS3JBadGwOA9astehA4IpJiWfn1JFb8dDoRLUHFShf35J/8RQeTfcBXr7ZI2ntVNvOWsFTVwn5ysaqWndaABVVPgSj2dwlapnvdbxoMEiDarNVe3hRweD2qs2bbaSvqAofLM8MM8mHSuPD6Tc8LUJkIoaOm2FgnE03HqetKX7diVlT0T2MAngioAa6oOuWdJbIEPUwY9eTiyN//3g12L8A77ObHVrg72kuS72c9Z70uFr5Q1+Syt4GazmhAX6MDiwRYdqtzyKn3teK3tOYzDw6y7pAUCFt2EEqsrfOnwyBq3NvL9743Jhoyrv541DQ10M310Q1/v/J1qQ9ZoxxwRyk6KGETPCFGVfs8NMpiY/A3wvSUQEkc7y8qPcGEOfAgbSpsvrvO2hwLriT7AAG2g/9cM2T086tyhwBdfwb2brdfq052AmrEtxYiF4MNCgfHbuvlRrhRCCsr9u6vi1IkpJhiCHNmyt+3Px2nfblQ67YiiUJs
 n66I8Nla
 WxM5eBfqYUuoL1qaO017EhE1E0vkCBKBkUe1IKSTyM4fVh+1nmZ3mPba8TtycoDh17Kne5opWZD2iPj9G84kcHgB0Pa47/kgTd2ReY6hhVzEkK4v0AS+hUwZgm/Ge7ykdV3LMnFSSQI+97V/mlIoN9tP7mXqgtr0w47WnGRZHai0pxI3s5sffzF5LwnSUjJl9/Plg8/UsQ+tk0mQp2tUZH+S6a+zoXWhuBKbL0edp39B5pCdcuDztKK+9ZtrK+Tm22hb6Ata7mKdopgaEXZtZMZnD01+rEQ7SCuhqyb8RUeBCJlKU4uUKnK8JLkRvetvK8df8CfRyK/HRAh5XdMZ4HtPZ5XZOKuZ8iIpWFQHJDkHYd6WO1+9/JGvX0O93+oATBUtgcMXo9SsKdBjXGM3kN7g2tfLE0ADQYM6xUHgbfgHliTlZvoQ5nqOWGj84vR/CPoU3
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

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Indu Bhagat <ibhagatgnu@gmail.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---
 arch/Kconfig                      |  1 +
 include/linux/unwind_user_types.h |  4 +++-
 kernel/unwind/user.c              | 23 +++++++++++++++++++++++
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 94b2d5e8e529..37549832bd1f 100644
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


