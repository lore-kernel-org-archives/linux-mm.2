Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D41D9CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:41:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E08076B00EA; Wed, 20 May 2026 11:40:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D917D6B00EC; Wed, 20 May 2026 11:40:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C31706B00ED; Wed, 20 May 2026 11:40:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B22796B00EA
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:40:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7CE771C051A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:40:50 +0000 (UTC)
X-FDA: 84788211060.24.ADCE4C2
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf15.hostedemail.com (Postfix) with ESMTP id 48F10A0012
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:40:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=EL8NEyKW;
	spf=pass (imf15.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779291648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dLUdkq8a3Y1OwT5DXjpOwlqcJtqrXG3rf2YuzJ2NkbA=;
	b=NnoZ6XntNgKKmQc0/DBxB2Xv77dDQ+zlwX4RQ1jcgmrovwb1hdy3tn7XnT75/ZHDaAoOIt
	+THgAQcygV/k3Hu9CVAhbfpCyM4yFTD8Tg/pdnLf8JGpBLRzkZje8XJwwi61yfEkh1HDjQ
	KP3ihIB9jFaPZFYegi0TMn53xTSZVRw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=EL8NEyKW;
	spf=pass (imf15.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779291648; a=rsa-sha256;
	cv=none;
	b=clP2ZGU2keqRy0OLCU3A3+mFtT5l2i5W6Z122BpBqPWLx2/Y7nJmw8eSqc8NC9l8k6YNIc
	sBP3xOUZOZBeb5aYRS0DwXvnaDZUaBIvMegT1AK3XSCUa+WNcYQqJlwveLh2iItKP96/Zx
	faihuP1aDdVita/eHx2WvcA71UCWEjI=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KB1EQZ4011095;
	Wed, 20 May 2026 15:40:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=dLUdkq8a3Y1OwT5DX
	jpOwlqcJtqrXG3rf2YuzJ2NkbA=; b=EL8NEyKWSaXJlTxXv8KXd9ycG71OtFeS8
	UM98Gt5+gOoBIgCoDSc8FtZaLnJTZQkO3lIntTTczo6R+B9Qq0xxz4alttM/TH2C
	J5nQISaXq7U+6XIAG4Wmv9UQTxIIPIpkG6gdPeinOJYMkAubcbFj/KVccUBoSnYN
	iIiIAmc9NPHkgG8lDGdT+RKmO14814PpuVXkH3gWhgwODieDI/L3p315TRI8kToi
	xQgP5EP8ZOB2jdDtf/jSpvMJMQKHEZ9dQ0e0KnHBpXslahbRB+Ptbc8HTPILWaY7
	fq4b9fgyYf/3AfpN4tl+Mf/nn7sWdB9uQ+g8HTSIQP+rOVHSPZldQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6hb8hsnk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 15:40:16 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64KFd6mb016241;
	Wed, 20 May 2026 15:40:15 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e754gfrhq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 15:40:15 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64KFeCI860817858
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 May 2026 15:40:12 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 04DD820040;
	Wed, 20 May 2026 15:40:12 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 79E1920043;
	Wed, 20 May 2026 15:40:11 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 20 May 2026 15:40:11 +0000 (GMT)
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
Subject: [PATCH v15 08/20] unwind_user: Stop when reaching an outermost frame
Date: Wed, 20 May 2026 17:39:52 +0200
Message-ID: <20260520154004.3845823-9-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260520154004.3845823-1-jremus@linux.ibm.com>
References: <20260520154004.3845823-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDE1MSBTYWx0ZWRfX5tXd5a79RShz
 qd9w4gNTPiiJY7CMhk85NzHnBFXOqudYX4kmjm6u56Q6DwYTCwd1UuzIZxagLdGTDMpMeMAZ8/x
 9BhfFPSYyWqEY2cyeseDt+7cmLOcQ7Waf8lHW0uDwUUdghM5sl0Qz8/Q1gLxk+GDmJxxDyzyT1I
 lLfBs3cnXWTlPx3oMF11QJ8TkXId1G1M6UBVOmj7vgI2ozMvB7qi5qaR+xxkT1Bb3sIEqwypXIO
 +nECMOeDW+04DheSJ/Y12vLekS8UWt34Z5EvFtankilNLyfElwfcnlKrzlqy1e6d4lUJs6w5O4m
 GCK5XBCb32B3qaTURrIGCT9YFj725eJbPsjFzQRIs0ZlI182S2QlqtYH7pT3dREJaklq2tG8Sa8
 d6/JgchSpyfADmKgda4f99BuELQmkrTF8F5+eP2jiyTW2vgVGzgiqMuxqPXfQJmvIKTg/vaCHZR
 GJfyhoEcuLrjGJR2B8g==
X-Proofpoint-GUID: wvBUGDyFlzpAOgjPw_K_8hx9qpGk4_yW
X-Proofpoint-ORIG-GUID: 9bbppHG8EDr34JUJC_qg9IOyE4sI_bx3
X-Authority-Analysis: v=2.4 cv=aYBRWxot c=1 sm=1 tr=0 ts=6a0dd5e1 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=_1qlYuAciRtwIPuEvDgA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605200151
X-Stat-Signature: k88xqucmpqthgbz53bykzot9pzdjdry7
X-Rspamd-Queue-Id: 48F10A0012
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779291648-632979
X-HE-Meta: U2FsdGVkX18xP2Elr02JvMrqYm/7hgPklVnsMn2VKSpoVfhAAqgl40d5OLzHBEL+8spGNVKDHuTAVIbg7J8TDJ2X5gdt8cfegMBDbxaDSfBWOJ/PnMwVZ9gm0yO9/t4AF11+LOSBJaJCkBkFejifTD+4fBAuNCevq6zHZkuVhulljUiZKagUNwRfGogda6h7nudQykETV2lDFqV/e9VBIW9tyOHdVmXoSXX/J4mXaKgJn5A3kE1VERv/bVYbtJv9Jc+0OvDn0rCwKxa2T+Iv8jquBpDbi3pBqkeeYMjebjzc9RMKQ6ttCuvOZWXGAaRHFxKdfooWDPp3gVnk1hjhbS8wi2IqqNkRt55AVHNC7Wy99Xd6T7xHd1b2tynKmwyAua30FcxA+6cs9g3wTJP2QNOXitfi5Cm129mXmIf713u3sBsKhrI0eCLER3x3bzQ5lJmSJpI+x+ipp8RGWzm3FrU5tTyMLjasNGepZpnKJyWGV2v0+AmjBn70oLemSOS4hMIaUF74xrq/jL5XZrltM828QbnWmminQX4yw3kXf7wWgKuXCEB+h3Rblh3KYbc6QsOKp6vyjkmJUEfQQVKBPro3am6OtxfpL4ZXjHVbcBsnoCdMqtOASZdPUu5EWxcRKncRt+9CKDFz/DA+7bX32AK8t1ogAgBUsQ1ZHfUBNdWiJ2kPE0L6+BA2Reu8HbdSsz4ISVZmeRMUUsJQvz14E9AYZAP4WH0TLbvsV5Vn/KBxgKp8c/hGt7O6ZkjIIFyrhC2GmMr9SxzcIh8FKOxi+0MClFpqwGjA495jzugLYKFY7H2Zmd+uicsXFnD840P0l0KfcnFJjVmawlgr1wtVWbwZV5j1RUqWiHKkfC+cbCc70wP/7inugs3GEZXdVFD8pgmnxU7bhfBKkPom94+wkFrzkZ/KhtioMrSnl8EhhZuvAjUB8O1bwTj4iNuafDPcEjWdr2WRaz+zRnbgfaV
 zt+1JTty
 ZL3BxQm6XDgnRg9jXKqWP5ygjt+TcwI7O1MJm0Z0rocd+blHh2D4rbM005N+qGD8KQs7Uh5bwPdBm+WyY730sAmXBN037OZkA/jfQuji+CDuLlUiBlLZAycqmHKeKrkH/9n9E6h2cscvliGFqv0JCVDIOaeRlU7n7lxyInWnmpPhBh3cj1+lsGCJUGOGWntNl84Em2JCNHr70dfe+Mf5tpKJRG5tOAm7QBUUO9sTXBc60dxxNqkFRZ439zT0YfKWWvbqegl/L/c+6eXeo6Jgzu5K2n2xfl+gn3phWIR4N04kHz0uDdM1iMlxKhJR0VrhVd4sDYjoHcA6MgUbdysU64r8KMbyliaBZS+jN62g1r3RgqPwH8pcFdZm6xg==
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

Reviewed-by: Indu Bhagat <ibhagatgnu@gmail.com>
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


