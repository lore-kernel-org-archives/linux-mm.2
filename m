Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F088BCD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 12:32:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 254966B00A9; Tue,  5 May 2026 08:32:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 206486B00AA; Tue,  5 May 2026 08:32:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F4E96B00AB; Tue,  5 May 2026 08:32:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 000E06B00A9
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:32:33 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8B046404A4
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:32:33 +0000 (UTC)
X-FDA: 84733304586.10.DD86972
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf08.hostedemail.com (Postfix) with ESMTP id 146A8160016
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:32:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=rfAcTdCf;
	spf=pass (imf08.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777984351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FvnhYyrYWxk5OBPJwrKrmJeEttrxtHxGpLoGH3hJxZs=;
	b=jiCILAcfaNUHGaoGPSN7950DSGDewHrEsKrA4rGCVhJG5vb5RmKUi0fiac9Cl5Ync7LVrG
	FZ7Ky2rs6mWyV1bphbabptO2WX+55D5I8a+ESNkzJxufhSiJJq2FgLDdZZpjgs4tiuZ+RM
	GPzWJVLI8yqoN0PK4uXkhOQ1wmJnVg8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=rfAcTdCf;
	spf=pass (imf08.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777984351; a=rsa-sha256;
	cv=none;
	b=6iEnUtFW+ihoeKQYM475hJxpxeGraypoOiNJ4x/TZ2meV5Gu9Z7iVTCb5QPJZzE82yQpqU
	wpecjb6J5kf2eL7nc+UCBOFcBVht1Y3LMp5zRpPuD4ck22kRflWzO7DYH0zf7I6eqn9VQZ
	DU0mUhV3p7N2r9NhAANHELtwwrop2u0=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64581TKo2735981;
	Tue, 5 May 2026 12:17:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=FvnhYyrYWxk5OBPJw
	rKrmJeEttrxtHxGpLoGH3hJxZs=; b=rfAcTdCfZTdCJIhg279MiEJuXikE+HU87
	VW1NgFhBqmN66S2/ZP/MFVX49Npq4TmI7nXuUz4dunypkCq0+hCWVEZO8a/oubJW
	aokHCUARaQXlCdfCdiT5SuCvZcrX0QFx7WHIa1YEpOqxkf202VhNkfCxE2PJlsl4
	kEq4kZgolvFpJHVVcQ+9K6vmH8F2qxlwRjNERx4L4+b1VDKXotZtkVX7pfRUwDEj
	E6fky+n4f8TIMvhs86IafghGrDB3Wk7aSTuhyzjVE14vlYbT5Z1r/LQnd98meHsP
	TxO+uVjm5OsRVoSwCc3CRnM1hBn/gWeeXIfK4zrCV9paRbCtwt+cA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9y1bh3b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:29 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 645C9c1v029300;
	Tue, 5 May 2026 12:17:28 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dwwtg9bma-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:27 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 645CHO2G50921758
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 May 2026 12:17:24 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B30B2004B;
	Tue,  5 May 2026 12:17:24 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F223D20063;
	Tue,  5 May 2026 12:17:23 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 May 2026 12:17:23 +0000 (GMT)
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
Subject: [PATCH v14 07/19] unwind_user/sframe: Wire up unwind_user to sframe
Date: Tue,  5 May 2026 14:17:06 +0200
Message-ID: <20260505121718.3572346-8-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260505121718.3572346-1-jremus@linux.ibm.com>
References: <20260505121718.3572346-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: LBHznMHNrGwcMIVAjy5FTSmb0VZFbhh9
X-Proofpoint-GUID: iMK_zE08jUSeI2qYJTeWXZRqSR2k0krj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDExNCBTYWx0ZWRfXywHpJhLi2dEn
 P9AYd5vJFwFBj0+QRrHYpUfiE+qsWW8lwgPfGnTbYrZ00nCVd4cVw13LfK5s1O+tqWVdchKQslK
 P4iR3E6GuDFf42quEGZwgu2CjLxSkt2L44ESlTNYSxJQCqp9A4nS4cOAiQ2pkR5IZPE/fFk1VeH
 Ppl2kp2xH17XuTsAgd6F0apNsu9Pk6Uu06A9SnfxcnXeqLVLAnVq2/GzfZSeZLyRKuOQxY2/3Ey
 qbuRpwUyaU3cA079v56RztjzEqB6/TbBlDf7BNq6APTgO9RAmbChK+go9kOHT9muzzeRNe5F8/p
 OwaEq73tBWmeq+z7x0oW0x8GHFuuiUVtas0zTiKF42wcb7pK9+Rs2EO78dvX97hdm7l2EuRmrEN
 jdsw7wtnZLzh0qhZHZxxIRHNa4XB6tIbdx/zFRoArcVSgpGE4u38Cf+t73M0M+Bbjcw12Z1HUce
 6mkwA8D02yA9a3vywMA==
X-Authority-Analysis: v=2.4 cv=UbFhjqSN c=1 sm=1 tr=0 ts=69f9dfd9 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=ItKwCHsCKAUqeRWvWoIA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605050114
X-Stat-Signature: zncqb61f53qq5goaq5e4jwyjmmde5x4m
X-Rspamd-Queue-Id: 146A8160016
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777984350-636539
X-HE-Meta: U2FsdGVkX1/MLeOg0LHmDrMg3QwKi+ZDrIAJSjCGDybunidtfS2CHZxsSGg+6Jq1CoMMF5zObQzazBj+O4HZWo6Gy1I9Hw+r7V2CXhDnQuEVCKn9zP/n23gRzeAqrIFlSwBSuxvaYWr8fmZSxHNCz40sHSmf/tAnEg1sn6PMYmCpikkXWM9WwPOWH8VuzeM+adel5sdx7HBRhCeiFn+CukKTCo8FcxmFNLaFNEpGKfyMh5UHCb3OjwDza+r8MVBDM0xdQS/yNCDXupLvEnb86g8MitdLjBKQNaBz4xISVXiUo1SjG6i/cW8xq86tbGFhXqG6b/U1r/rFNUM69GH9GccEP2Veok0sQxXNr5hKysHdI1RVRAQly1vSpzmIKcIQpKIpzCuFKMU9r8Riz6o/FVtnhaGtr2xu4A5t5nLXRmC7pB+q5G4Bo6t3+dJMdNQPy65DEwo4uh0F8su+jTY77gdVrixHJ9DFpz/3bvcC7HcyEi86rZjDFxAm2HaQaNTJJ5b98gvCIceAjDxsNtlQLseoVTy9Zyi03QvkUmdU0f0vwFcu0bB0UEcykXmj88GZhLN8gfutTcJxJaQM2F0M0YUvRXlWrW+eGHwuZvI8+wQnEbfUE+58lfW7mAXzUUEmXWAVKKK3z3RiYhileOaStzU0aGjgOD6apyFecEMP2lMlgwGHd7ihH5yCmvyZqSLHfkOHLDXKIq1oU6zdHHNRNq2oNkU/HaZWGZ9VNCYtZ3jtmnQri1gsFOH9YLMQ2lXsjYRAzS05cQg/OL+M3P1D55Y8TGtiyINu3xTLVtomTnanxtcqKsVNDeSj+meEMLRZFJSP2sJCuBeFymvFtOzP+2AhkuvTHcO9z2VYaq6ZkXb/Lr+phluZteg9yYi3x7VAaWjLpa1VTuBr0jkeolydz7n0Sz9jOxcNmEZ/YU/1aVevJxxfKyd/2PR61ukfMVq8zd3HsEkY58n7Yz2a0EM
 Y1xSabnG
 S2+VEvvgCFWWRROeK+vP8IbXzYJI2GCuEJHKlK6dXsBd3fq08nGVYCNL3D3oRsSk3hiJW0J0pEMgOOOf9T8OmTOfgxJVnNEDQ3leVR9q4Gykd58xdWbntbPldbiMid5QZRfW7S77eyzvrhn4R4n0FhDFnR3kp2CjJGcHRqcpFlvZHV518TsayeGLuMG8yEldbnEDWVhWdHhZo1QzQZO+p4yNdT5gsFZCX7AR0D2GwUzq95wV3HBgvcGcAuQ+vworaS5vBBNemtbNJPAUuwFp0agnTCuq4iZzWMEFtVOtnlriBlUZE1rSeG2q2BFpHc6UTEnUD8AQjRQJgATBFLMA1ZhC62vvNDB2mgliSVQDbR0VSMrDFFQZTXB6oGMadjWmsMhF2CcwhlJ48YCpnvdp42XzVvdrQsDRUkmNo22nAUiDzh1nRNxw/b7Ge4vqvgmEsn3Z5
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


