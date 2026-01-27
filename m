Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5709D3408E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 16:01:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 369896B0089; Tue, 27 Jan 2026 11:01:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3139A6B008A; Tue, 27 Jan 2026 11:01:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 223446B008C; Tue, 27 Jan 2026 11:01:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 119FF6B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 11:01:12 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E81821A0219
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 16:01:11 +0000 (UTC)
X-FDA: 84378207942.27.7A9C00A
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf07.hostedemail.com (Postfix) with ESMTP id BECE34000C
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 16:01:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=JRPfsCvi;
	spf=pass (imf07.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769529669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s8yD6zQnCi2VjhbmMKBe6rWarjh0LI+Iy4NKcZSO5P0=;
	b=zsPZCS92enwR1L3/FWG+8AqL5u6UW7iapeS4duMjZMsFcXnq6fYyKHMe1iI98SJKZZXU3t
	BqukWt7aPZa2kW8XIhwBZhzuWFsDskFUtat300XkJCk9rbV6cCAUzeZWxEHoa3qANUufch
	Yp+CYHMhPkEoP1SuFiaa4RlKuar9KKg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769529669; a=rsa-sha256;
	cv=none;
	b=De5jKuuzSw/B00LgR3uMvmw9Skq1aCkSzwBesYddWgrJZeDEk+NTMNV2hMT6LZ6qU1KmFD
	kafDsSezCVPcrKbguSDroVC09KDTBzLaraqxiLpP0l4fxeyQ1H2SChFUUcsgiU9TXmcHsY
	sbdilAsw/sNros2HMHc3WUuljslajmc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=JRPfsCvi;
	spf=pass (imf07.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60R6bs2q011850;
	Tue, 27 Jan 2026 15:06:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=s8yD6zQnCi2VjhbmM
	KBe6rWarjh0LI+Iy4NKcZSO5P0=; b=JRPfsCviGf2wItF2wOmIZ3Q5v2KPBdTl4
	IaaZAzW3SbUM0PpNfFdLOpGBraHkRd5WJw8TGj/Bi8RdrLaTi6fzKTzIafSy07JX
	tsK4Nps1fMvX5NTRf+PY2jpTUsJDh7fiLoUhrg4FgXTsNydBf4ZBiu6dSTZK2bqW
	IiA9JkkJOYH6EdYEQ0h3qebYDP2fwcZA+xr80yu1bJEVZ7iLMhUt9U82XNDCj8Bf
	QicwsZ2hgqrlxJCnBYjD61uUZOX3W5gil5z3kPcEaUekthP/lRPLwdmAQTBo4sMy
	eFCNG9dmMc8A7aRZg33ZBPe9GVIfoitt9UZu6LEzyBymKq3zCgAoA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvkgmmhhv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:05 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60RF15BX026039;
	Tue, 27 Jan 2026 15:06:04 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvkgmmhhr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:04 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60RDxiae019733;
	Tue, 27 Jan 2026 15:06:03 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4bw9dn13qg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:03 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60RF5xEY50397512
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 15:05:59 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BBCDD2004F;
	Tue, 27 Jan 2026 15:05:59 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5C7952004B;
	Tue, 27 Jan 2026 15:05:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 27 Jan 2026 15:05:59 +0000 (GMT)
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
Subject: [PATCH v13 07/18] unwind_user: Stop when reaching an outermost frame
Date: Tue, 27 Jan 2026 16:05:42 +0100
Message-ID: <20260127150554.2760964-8-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127150554.2760964-1-jremus@linux.ibm.com>
References: <20260127150554.2760964-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Gr1PO01C c=1 sm=1 tr=0 ts=6978d45d cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=7d_E57ReAAAA:8
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8 a=yMhMjlubAAAA:8
 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8
 a=_1qlYuAciRtwIPuEvDgA:9 a=jhqOcbufqs7Y1TYCrUUU:22 a=1CNFftbPRP8L7MoqJWF3:22
 a=HkZW87K1Qel5hWWM3VKY:22 a=wa9RWnbW_A1YIeRBVszw:22
X-Proofpoint-GUID: Yw30ofjYvy8yVTEj7Cr__KxhMse0QOAk
X-Proofpoint-ORIG-GUID: YvUxJJmHnkqwmkKr8zAyE1qA-LQB89ro
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDEyMSBTYWx0ZWRfX/7FotBWprXgZ
 biwo8FtHSXqaJzBJFIv8UYyr2c4GphiWUFtNtvN39wBUDBcDU2rR92g08b7Bbp0hvkKW9ru77mS
 e55eqDl1WOqARysSdOPyPD8TvPyoX7HLZaDbSAvLAU2Esqw3qbHp/aUipF9GgTrVQoR4bsyRiZl
 KOKa7Mgvz/TCDTynGAt/O9BO9evBB8kOmpBzZog/6u99c9xlP/Hf77QZp7k0fb1we+isuNLXMKN
 SVXew722i2Fdfn0Yew6eKD/4oPmOSMHxNjVL2DDpJNqCZsL68n+vlcPXKKuqbSaiezEH/XI0FH3
 7VFB4/9/kd4l/4wtuVxGkPMNHQSgF1aHJn86h/mRTP/7p3c8ihNd2aTlxXlknOwB3zrOnn7IBOK
 8EVpzCGoi1E5TvPzq6Q1GFoG/bLmCdxKrZr1qdFC7CXZSymYoN8uTK7WN7VeIgG23mphn4LZsak
 kXRzLa9qghCRBH/QVVA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-27_03,2026-01-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1011 lowpriorityscore=0 suspectscore=0
 impostorscore=0 phishscore=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2601270121
X-Rspamd-Queue-Id: BECE34000C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: d77dpbr8x54u7cdh96iam9pj1nhadiuu
X-HE-Tag: 1769529669-960895
X-HE-Meta: U2FsdGVkX1922NqJT1/g5ZvWHgINSVUb9vX8nySO7tRbFlnkB/bGtQv+oIUGiaha6L4xsIHqp0G95CTORShTyfo1ml1C0PtOOR9NCPJ7MroSxoPIC37LdgGnwo63vcAW/rCYVF903DIND9BrVakadxlHCLRuJznCYpCNtgjzKx4G8HE5MeH7fTvFCS8RbmcGNASVpmpD+8pdCITNl/pGDHgdWhKdtZwp94pK+0S5BCfQG74bLZYFiq8ude2X4/91fmvjOy8J/0hHEz+MKdERq6tC5I/7/fk9plLmOnzZETxc5A4fKpFkYcZWnerO9k3kQiPdxUaMAjFgJ4Ne+TwGN9Lrzai9BKULyOiKb5yD2RUhLEKmBaiX24jORCGYZsnLBCFiSvE2pZLEa22dqPVvNpjDiaokK6sRgPW9lKWW0Ly/n9E2OW2yvR3fAoHjo7cKbOYdVttqlEGEdYj++IyDHpN2U73nj/fPMeE7P3EcyqQpgEh67tdOeVlBCjjMIYqo0rZOLzwaJQvTjht0GxlCW/N+VqGzvoEYiH2Hvus44X0AC2dJ7GXUhDxn14PRYw2JsVAbo1PqCidi5EVi0U4eK/ECmbpi52ul+aGUiYaWlmVKTAiWmZ55IltBFx7hQTkaVn5Wr/7qSYeZ22u23P69YlzAWxdJqVlz8X1PStLg4e/K4IhWhc/PTIDCoLND/djxOl2VbQJIPhyRu9+l7KRwfjQl6XaYTSq/134UhOEJCdKbyOTi//gQxvJOGuxSrIR2u4507npo2d312Sw9q58wUe3LpHPLA7Yw/xq7VLDvsCV9vdp30PtRD+NMGWwAAzDnhEnHLBwDKy6SDiyLWlp4ewR22oSZdxEHtdbG/DqZ6yoLcg2dbvATHupuW2vq54Q4QALqtlII7a5dCtBDxL7IokDpObcxupti
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an indication for an outermost frame to the unwind user frame
structure and stop unwinding when reaching an outermost frame.

This will be used by unwind user sframe, as SFrame may represent an
undefined return address as indication for an outermost frame.

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
 arch/x86/include/asm/unwind_user.h | 6 ++++--
 include/linux/unwind_user_types.h  | 1 +
 kernel/unwind/user.c               | 6 ++++++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/unwind_user.h b/arch/x86/include/asm/unwind_user.h
index 6e469044e4de..2dfb5ef11e36 100644
--- a/arch/x86/include/asm/unwind_user.h
+++ b/arch/x86/include/asm/unwind_user.h
@@ -23,13 +23,15 @@ static inline int unwind_user_word_size(struct pt_regs *regs)
 	.cfa_off	=  2*(ws),			\
 	.ra_off		= -1*(ws),			\
 	.fp_off		= -2*(ws),			\
-	.use_fp		= true,
+	.use_fp		= true,				\
+	.outermost	= false,
 
 #define ARCH_INIT_USER_FP_ENTRY_FRAME(ws)		\
 	.cfa_off	=  1*(ws),			\
 	.ra_off		= -1*(ws),			\
 	.fp_off		= 0,				\
-	.use_fp		= false,
+	.use_fp		= false,			\
+	.outermost	= false,
 
 static inline bool unwind_user_at_function_start(struct pt_regs *regs)
 {
diff --git a/include/linux/unwind_user_types.h b/include/linux/unwind_user_types.h
index 43e4b160883f..616cc5ee4586 100644
--- a/include/linux/unwind_user_types.h
+++ b/include/linux/unwind_user_types.h
@@ -32,6 +32,7 @@ struct unwind_user_frame {
 	s32 ra_off;
 	s32 fp_off;
 	bool use_fp;
+	bool outermost;
 };
 
 struct unwind_user_state {
diff --git a/kernel/unwind/user.c b/kernel/unwind/user.c
index 1fb272419733..fdb1001e3750 100644
--- a/kernel/unwind/user.c
+++ b/kernel/unwind/user.c
@@ -32,6 +32,12 @@ static int unwind_user_next_common(struct unwind_user_state *state,
 {
 	unsigned long cfa, fp, ra;
 
+	/* Stop unwinding when reaching an outermost frame. */
+	if (frame->outermost) {
+		state->done = true;
+		return 0;
+	}
+
 	/* Get the Canonical Frame Address (CFA) */
 	if (frame->use_fp) {
 		if (state->fp < state->sp)
-- 
2.51.0


