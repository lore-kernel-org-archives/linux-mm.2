Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8E07FF885A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 12:18:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 618F36B008A; Tue,  5 May 2026 08:18:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FB296B0093; Tue,  5 May 2026 08:18:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 217BD6B0093; Tue,  5 May 2026 08:18:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E86CF6B0095
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:18:12 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 954AF8C6B6
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:18:12 +0000 (UTC)
X-FDA: 84733268424.19.29F2C55
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf16.hostedemail.com (Postfix) with ESMTP id 52CB3180013
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:18:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=bs2VY2sV;
	spf=pass (imf16.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777983490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fp1+xLYDCmmQpaXa0GhRyZ3txTr6LJNU+sIx4JTk2yo=;
	b=d6JxNLoNlOxypJPn/fG5lkhTwsmzeOp0rNdMMMoxNtVgIg1pGW3sL0a+m70C7caJRZDJhm
	JwNOgc4I/xbOfup9jY5l0Pz1mjDVzcMJo6wq53yH6VD1/escCgfPZ/sevU/3HPtSAHVtwp
	44PpV8mTM2qio9tLT6k5y3AEZpbyHrs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=bs2VY2sV;
	spf=pass (imf16.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777983490; a=rsa-sha256;
	cv=none;
	b=ruXqrCpOycqukH86RsCZ3H6N5cpZgbDd08UDGu1h11aMxUs+nDff4AUXIsXxIM3MXMhfN1
	kmUMJ/auRxgWL20jdSniVzcXCrpT6h2INH1WnFC0FDhEiPbFlz6AyEPPhoQTH0Z5rxhR4U
	sZHLTcMnk+ZXVuev+jFqhF3+bIqorp8=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6457HxL43253820;
	Tue, 5 May 2026 12:17:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=fp1+xLYDCmmQpaXa0
	GhRyZ3txTr6LJNU+sIx4JTk2yo=; b=bs2VY2sVy88C+O8BUtObtf/+9iBZmh8wm
	GoW7GqpdXGmZZH/KUL2Z5h5409DdM0+PYcEg0eDezGMidxHsNaK5ShxPzS1sZ3Oh
	zRSg9q8xTOvsJTbza7XwsoXy8RlgSPA6kwyq7LmSq0TOwUfI4w49w+LueKvcktZD
	aRbSdDBOgwniqiQ3xT9Gg05re7SMsTgVMviIEkZPTD8vYUrJ8LXaevi7RcZ2ddCZ
	w1x7VTvGfEgBmyyhXKNHIt4uaR0jDJPPkKriGg34JjdF3anNLhwS4+Pwn9rBU7z8
	F0faT3dPyx4fWIVS7fTdCV9So6lZSw1c59XbVsE6Fhr5Y1P+yE8qg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9w6b773-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:31 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 645C9aen028944;
	Tue, 5 May 2026 12:17:30 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dwwtg9bmf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:30 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 645CHQsK51577110
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 May 2026 12:17:27 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DB1CD2004B;
	Tue,  5 May 2026 12:17:26 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7DF0920049;
	Tue,  5 May 2026 12:17:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 May 2026 12:17:26 +0000 (GMT)
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
Subject: [PATCH v14 13/19] unwind_user: Enable archs that pass RA in a register
Date: Tue,  5 May 2026 14:17:12 +0200
Message-ID: <20260505121718.3572346-14-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260505121718.3572346-1-jremus@linux.ibm.com>
References: <20260505121718.3572346-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=XPQAjwhE c=1 sm=1 tr=0 ts=69f9dfdc cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=9BsmwnrB0_sKC25V_9YA:9
X-Proofpoint-ORIG-GUID: H2VCySc_vDGAaueYcs90S4FVKgDHL5RF
X-Proofpoint-GUID: eTbJ_UWu_DjCDFnu5ti1_ElXraB_HknH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDExNCBTYWx0ZWRfXwKMWSf7IevOd
 DpZx1N4JciusH35DQMxiGUsh0WrWOAHej9k6Zd05SLSE+MzQ5IFLn1JgaAHwqJ9ELE+1MpVOIfY
 G8+Orjk+3rKBI4+WlZwq8fOQChdEY8u+7Kkpaq3qJXvw0i6LBhBCabQuCh2Vda0ZUbWgJYp0m2W
 dtLp3ZkdVtJqYkLkJKVcjs4ZQ03W4ID5iJ4xlsf6WG8AWKRs+E+srO7uZItCT/cipVBU6ur3JXE
 ImQbABji0oKDJcrWWhbndDLIi3IJMUEgEFF3Yy5ff6TLVFPpAvgWkF9JZUdunc8OzWXv4qBjeBx
 YCyjiE3bJ1zxnUSKcztZwCK3dVfcANgD4VU4mWKtn9ZaXHcVAU58GTvxucI1VrjAEJsrqQqWEG6
 Zh4K2DIZY36tdsjz/NMnk4UJ0+Opoip4rfp27YrF/7bQalHbfeO4sSQqiWAKJPgeHYjHvM+iE4a
 bN4xQo4c4l5xMDZChuw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605050114
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 52CB3180013
X-Rspam-User: 
X-Stat-Signature: d58kwi3qten4srdhufnmcp5bza7xh5sy
X-HE-Tag: 1777983490-567159
X-HE-Meta: U2FsdGVkX1+nWQuidnivs1yKFf2G80/dq7OD94HJRlXDmvJV7SSxhMPS8ktAIXKH6dttYtJPW7cNEi89Y5eDLLLAZ5Tu8RQdyVcDYVmDNywKvsx8XfUAY+43Tas/3C5VQ4cILqjJ0prSrNelxoSoIaPZ2vBI5SVpikkO70Ys1KQpbOGmAmkLAX1LK03kzbLcXHzr+NmGF/Vmda47kVq1jPCuYElPj+aHxPbs1HSekIFlVkvzJDPyCh7Xrw9S35+x1Fn392g1KKIulQOhYxgCJTG63vBWznvSHW91jYv3gZfaMtmqynrcNApiSN8FTq1PrD3GKqxp5+i/Qd07/lN1MM6kwC0m/e+b+OlLe790UkUnmwHpGALPO2YA2RYBAEzMwwjt9iLH8jTYjPRpJ78aozb17w4Ic6ejm5DsJW6LU15caGEsNQRN2ONO10bhm0Mq0XaJIhr9NJ2LViLKBYjY3MpPNmhZ77Q07QU53UogIEWqAGD9FyJHBh7wpjpD9Q/9y0eAdWjRIAN4bX/iFNyZlXc8OLVBxCKbtwa5UFDrseYwmu4d1p/g60I7+TlCWroGNQjRUkLsypp52gfa+IAn+uyJM/PEFrcI2egDZ4H09CKM9gpRqNy8LNK4SEZzv6XmlWV8DcEVWYHXE9bUF+oebU5e1f+aUqXnCXZ/n2zQjEQxmJigcNWE6ZFrCeGXmviYJmKnE0WA3OK3TuWX0iXmelx6S1snlV7DCcMgxNrxoAetBoY41Jq3rDGaXe880CejNaZOWrGFKLT+C0o8Io0h0y72qBe6AWwo371lW3UvmNMRRB6ahVpBLEE6vryPfGpt+WwOl+vVGp36l8XEb+DU4IrrpcEYfJ17oFwJzOMt3Ofo4l1+gl1pvnCX7KW2Gq1hRLo8MNOxOMfD5G6vqTXEtcW/HOMFO8Cn9lH4a1p1LrT1JGk6yPArhoLn2Ig3UeO4V/vlLAk0wIkqztxfivf
 pGGLL2EG
 DHYhQ9ezwm4LWm9/Kvzj4iXXyuu49Zb4HRvjgNBkgVh+glQ6sur68wJMX2zHHkm7bSXw/Jercoth8DGrn7HifAnlhmhGAjtT7jKAaBH1WtKTKnXAFk6V09NRGNiVWU7kdxqZL5saxdHaHU0K0NaFo14Dc1jk7BSR22vP0fmkZyux/Bjn+Mo2FzvgYHOCP3DkyoZTt2voXOySMk/18qT19IyZLzMHtpxCIUNUlGJFGL0OD9Gh+UkMitJRvSAwDzp+BBRRPfEdcjxqC4qBvgJxSgGqEZsrKNtLgGnU8DQP/KyHDWER8IrtOGoZQZow1PU2Vb1PoR02YFT5r91fbdok4JTDZ06rOYXLeZ4zGyHOPI6AWnzc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Not all architectures have the return address (RA) in user space saved
on the stack on function entry, such as x86-64 does due to its CALL
instruction pushing the RA onto the stack.  Architectures/ABIs, such as
s390, also do not necessarily enforce to save the RA in user space on
the stack in the function prologue or even at all, for instance in leaf
functions.

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
 include/linux/unwind_user.h |  9 +++++++++
 kernel/unwind/sframe.c      |  6 ++----
 kernel/unwind/user.c        | 17 +++++++++++++----
 3 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/include/linux/unwind_user.h b/include/linux/unwind_user.h
index 64618618febd..bc2edae39955 100644
--- a/include/linux/unwind_user.h
+++ b/include/linux/unwind_user.h
@@ -23,6 +23,15 @@ static inline bool unwind_user_at_function_start(struct pt_regs *regs)
 #define unwind_user_at_function_start unwind_user_at_function_start
 #endif
 
+#ifndef unwind_user_get_ra_reg
+static inline int unwind_user_get_ra_reg(unsigned long *val)
+{
+	WARN_ON_ONCE(1);
+	return -EINVAL;
+}
+#define unwind_user_get_ra_reg unwind_user_get_ra_reg
+#endif
+
 int unwind_user(struct unwind_stacktrace *trace, unsigned int max_entries);
 
 #endif /* _LINUX_UNWIND_USER_H */
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index 45988cdc5c37..d5e0fa04b99a 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -243,10 +243,8 @@ static __always_inline int __read_fre(struct sframe_section *sec,
 	dataword_count--;
 
 	ra_off = sec->ra_off;
-	if (!ra_off) {
-		if (!dataword_count--)
-			return -EFAULT;
-
+	if (!ra_off && dataword_count) {
+		dataword_count--;
 		UNSAFE_GET_USER_INC(ra_off, cur, dataword_size, Efault);
 	}
 
diff --git a/kernel/unwind/user.c b/kernel/unwind/user.c
index fdb1001e3750..9ceef9b2b8db 100644
--- a/kernel/unwind/user.c
+++ b/kernel/unwind/user.c
@@ -48,8 +48,12 @@ static int unwind_user_next_common(struct unwind_user_state *state,
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
@@ -57,8 +61,13 @@ static int unwind_user_next_common(struct unwind_user_state *state,
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


