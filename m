Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05985D3409E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 16:07:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36DCF6B0089; Tue, 27 Jan 2026 11:07:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31BAA6B008A; Tue, 27 Jan 2026 11:07:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F0966B008C; Tue, 27 Jan 2026 11:07:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0A5BD6B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 11:07:07 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 92FEA8A84B
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 16:07:06 +0000 (UTC)
X-FDA: 84378222852.22.0E63881
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8567E180011
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 16:07:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=KuUi5gcZ;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf16.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769530024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/3PfnVmrJ4bjdUuPibRsWkINJ7RY5gnKqjYR9SGs8lk=;
	b=NL7BuoiNRh2wLu44TXt8q+tdjhPR9Ixl4QE7fEHiR/VjDfIYo0YABkLgIDmnlHeOljt82M
	y1hPQ/GW0MjeJjBrIc2ZRbAfAYLf9hsaRL6cTIR2lD1nijtArg4Y1dqnNFluhYQ6N2d64i
	32NNl+iaJMB07uxkIpZqqQDHSlE2udU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769530024; a=rsa-sha256;
	cv=none;
	b=bSGOWZdkIvH5P/p/5l8f3w6fGkUbV5tE/CcYgIQ+hZoPqMaGfJ2flDUpWQcfn/EW+AEQ/f
	XFg3+z3hSFZbX1pZJ83j6UaU+mLCm9YyHLl0Dy6+NS153eOkhE4nJK6ZihS/GEv5yMUWzQ
	Q1BfCJSu+gJai4CBR1stZ8sExgvVpdw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=KuUi5gcZ;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf16.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60R8VC3L019081;
	Tue, 27 Jan 2026 15:06:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=/3PfnVmrJ4bjdUuPi
	bRsWkINJ7RY5gnKqjYR9SGs8lk=; b=KuUi5gcZFeyz0ICxuIdUgcsT6tsE+VaSA
	uo3WH0cH0I8rNElydSgIcawC0FaTGu/8Jrgh+x/3o227fX91aYQ67QA7Xp2Kf2rz
	95gzrKpweL9wCDo7y26ra6n9DHfqYU9TeBikOq4vHO0g6PFVOh1LsU0rNNhM4d/+
	dOs+MIpGiJBQtO+74pYyzEsVyvb4nwXG++X4odtSctKFT+ZTjc0tC/RpDWJyyOfz
	qfed6SEkR3xFgJvVIQIMHU/4ZQ+KtQ6BuLWFKuCAfa6tHyk8elIpRLN9XlOQVjtG
	0vtRSFyZfaPL6/8YCRvA3zYpZFlcry//toK0gRJdzsHGk8Sr98nzA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvnk6x32y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:07 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60RF67I1017499;
	Tue, 27 Jan 2026 15:06:07 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvnk6x32t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:07 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60RD4EJN031030;
	Tue, 27 Jan 2026 15:06:05 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4bw8dsh6cp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:05 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60RF62VW50659822
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 15:06:02 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2575B20040;
	Tue, 27 Jan 2026 15:06:02 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B9B6320049;
	Tue, 27 Jan 2026 15:06:01 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 27 Jan 2026 15:06:01 +0000 (GMT)
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
Subject: [PATCH v13 13/18] unwind_user: Flexible FP/RA recovery rules
Date: Tue, 27 Jan 2026 16:05:48 +0100
Message-ID: <20260127150554.2760964-14-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127150554.2760964-1-jremus@linux.ibm.com>
References: <20260127150554.2760964-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XE0RzFmCVQb5zWyHjwUBrwMS-vJMXWBs
X-Proofpoint-ORIG-GUID: KAkSN1-K_xFuumNvJggSiF3ey7msAwbx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDEyMSBTYWx0ZWRfX3BM4sLcNzZgq
 6z/lYcuuColZwrV7LGol9MsOo0DjdLJJIgEql10Fo9L9tt1I6lfIUhB+TCwnuQxr41SzWdbkg2X
 t4NrzOWrR+mfZRm/iZ5sLT3uWmLX0pTPn/KPXrZ2a7xwvcYjSnbaXOpKCquqzz2npupcP/8UPoS
 8lKSKtMwJHB7zrvWRFZEj82suALaNdBWVRX6q9pF1/eOwF0MxTKN6n4XSccM6oMEidAnw5nQRYO
 daYo6gM3yZJ/lr9tLXX5lwQUszkwJmdc103D9T9pFByrVymMYzHD4lukJNSBkq8qDgo742uTywe
 ULCAXsnj9Wkzti4oTyFQIRVHJi3hrCA+T4wXYfZnrIdNZM0Pi++bNlx8iYOF4IM4SwYLJGd8FdF
 dDx+yh92q2tuixN1g16+Hes7lSMhERL3sDatdRrtwPp0WbtNoLbKJaPWXo3Qs+B/h9UuA/BSJ5y
 zvQsKiWJNgyIUVbWDrQ==
X-Authority-Analysis: v=2.4 cv=AMiVTGgp c=1 sm=1 tr=0 ts=6978d45f cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=7d_E57ReAAAA:8 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8
 a=yMhMjlubAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8
 a=-jr7Rsxdtpxs5_a9E3IA:9 a=jhqOcbufqs7Y1TYCrUUU:22 a=1CNFftbPRP8L7MoqJWF3:22
 a=HkZW87K1Qel5hWWM3VKY:22 a=wa9RWnbW_A1YIeRBVszw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-27_03,2026-01-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2601270121
X-Rspamd-Queue-Id: 8567E180011
X-Stat-Signature: psnxdfwh9wsogsyfprac7hh8kr57r5hq
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769530022-169071
X-HE-Meta: U2FsdGVkX18HuzLmYz/TSugvrjyBzLPnVtji0ShHH7Gtu0lcrMDofZ3a/nWSBXc/WfqvcUY/PrRvoM05iEKZyKF68tINedXa46PBzAuIIUqkI1DcD3lmFTwH1/pJH862QbppTNfvQXFnQ6H16HsKvabv9s3Z9hMjeBeKT+OZYFctY4u5E/gLWGSKIR8QmWhKFdq2e+YqIDZVW6eqiF+ODkQJjO1r37ID1Eiwuzl8kyVv13IhZ3fwsUO1af0oE1SNp/Kl16aCe+f624h591mxHxcf5P4Cm5b1xw3TcBesw+WZXk5L/BTWpjbJ2dSVKkitkdREzaGVovq8dYPYju55sbzLzu8uP3VT0H0U39xOsg5Hp1NT/29bV9sOliiLl4bdjxADoreKakI2+OpiHCFNxej7FtkI6VrdwjmQiOMgdZ8TtpKJy0WHYvw9j7Tyx1pzv9BMDaFJ/urwPg2HEe5NH+4olksVj+N5reIAc3G+uKwMVWk8Pw/eyYG0tIW3qWYKG2pGOZgyIQLPwg4Bt22rdIRVcc1WG5480JY56tvVIC6EBfUmHVG4EEi+jp8q7XplZ6XXmOoJvdSaGaEzdrexCCSDxM3xHJp3A1clE7LpAkNNcUuEM7qWFaT4+BTkTuuDDRrWKM/P0/0pus/RIblyzcVyWVCs6Y2YJ2b95Vi+d8lG2F1sUGx3cz2RgcoT2I6zw750nAU426debHjbC/CbW9ojybIxyroOvkm7O9dwVVRxcZ2QNnUYQOp7tojvXvG1rqcXAuS+XtKYe+h6aiESURUdPr5xLXFqakhxzbEzq1pax3zywLLSqDEPuHIn5SlXn+hnb9MOrASBFNXEby1oya3NSHBU5pBOhKKE37rfCDJWO5ZHuY8ZzevAZ/Ho0pvZ4W2h2nMijV4Hgw/oZoWc9Aj6k12zj/9z2O/WrxoDODCTImxGG3XwnrxYonavz+jdKpIYkma54Au1VjuRXu3
 EzFSiGjP
 gBBhWa506SId+VGU60bCWm/cJQZT/T5dqjYymL6mr5YctGwUvaMWy1GvRG4IkZV4ok34hjUnLEwY9la5xdozKN2S4QxF/tyzgqGLUA6hkMNVmyZ+ptHZCaNc/QgVDKA0V5KSZr6pSahU7ogVX0hq8iLYba/bJqyZDaxvaHF9fVSWGvmw4dYhMC/4smH7/TxrZJ7pCwHRmKnj+AegNee47Ms9Nwk9ujQwix+jZwmTKGdHpcPv7ctwSb2HK1QQqRNDX2awFQjjV2Bdd70GuM2oELznHBvW8zgiy1BchAuxauu3MhnbmDDPLkTlrImkpl4Wzfafonkm5/rEZPXJvf8LThorggAzN6JAnTEPXMX9pJePMZixYTiXZWjhgglXLxZRtQWpirQRaJdLgMCPx8f/vOly4tJz9YeB2a7/npGLGrP7DNkt4DWT4iJdOOE/pu1OGsdN+9mBTwH7J2RCuXLhfPF3ONQd1KRHIB1IHM9VmOTsaEzwdXwRcu9T6shHiW0a6LudTbhkWBwgLJJF9KguO9JCTYF5m2sHxlU5DZserJALwOafgRYg9L9AOVxwqhlwcUTUO6iYhOcJQUM+ilbz+CI4OdCo3D8wotstaIUFCtu2TcFs8WXo70eI44pHmGv02OyVqA+zV5elAQ3hMHruan8YZlfO+fNrmmlQwErT5PyiPrqvR90ptLoo2fdBx/rjukgL2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To enable support for SFrame V3 flexible FDEs with a subsequent patch,
add support for the following flexible frame pointer (FP) and return
address (RA) recovery rules:

  FP/RA = *(CFA + offset)
  FP/RA = register + offset
  FP/RA = *(register + offset)

Note that FP/RA recovery rules that use arbitrary register contents are
only valid when in the topmost frame, as their contents are otherwise
unknown.

This also enables unwinding of user space for architectures, such as
s390, that may save the frame pointer (FP) and/or return address (RA) in
other registers, for instance when in a leaf function.

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
    - New patch.  Based on my s390 sframe support series patch
      "unwind_user: Enable archs that save RA/FP in other registers":
      https://lore.kernel.org/all/20251208171559.2029709-12-jremus@linux.ibm.com/

 arch/x86/include/asm/unwind_user.h | 21 ++++++++++---
 include/linux/unwind_user.h        |  9 ++++++
 include/linux/unwind_user_types.h  | 23 +++++++++++++--
 kernel/unwind/sframe.c             | 16 ++++++++--
 kernel/unwind/user.c               | 47 +++++++++++++++++++++++++-----
 5 files changed, 101 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/unwind_user.h b/arch/x86/include/asm/unwind_user.h
index 2dfb5ef11e36..9c3417be4283 100644
--- a/arch/x86/include/asm/unwind_user.h
+++ b/arch/x86/include/asm/unwind_user.h
@@ -21,15 +21,26 @@ static inline int unwind_user_word_size(struct pt_regs *regs)
 
 #define ARCH_INIT_USER_FP_FRAME(ws)			\
 	.cfa_off	=  2*(ws),			\
-	.ra_off		= -1*(ws),			\
-	.fp_off		= -2*(ws),			\
+	.ra		= {				\
+		.rule		= UNWIND_USER_RULE_CFA_OFFSET_DEREF,\
+		.offset		= -1*(ws),		\
+			},				\
+	.fp		= {				\
+		.rule		= UNWIND_USER_RULE_CFA_OFFSET_DEREF,\
+		.offset		= -2*(ws),		\
+			},				\
 	.use_fp		= true,				\
 	.outermost	= false,
 
 #define ARCH_INIT_USER_FP_ENTRY_FRAME(ws)		\
 	.cfa_off	=  1*(ws),			\
-	.ra_off		= -1*(ws),			\
-	.fp_off		= 0,				\
+	.ra		= {				\
+		.rule		= UNWIND_USER_RULE_CFA_OFFSET_DEREF,\
+		.offset		= -1*(ws),		\
+			},				\
+	.fp		= {				\
+		.rule		= UNWIND_USER_RULE_RETAIN,\
+			},				\
 	.use_fp		= false,			\
 	.outermost	= false,
 
@@ -41,4 +52,6 @@ static inline bool unwind_user_at_function_start(struct pt_regs *regs)
 
 #endif /* CONFIG_HAVE_UNWIND_USER_FP */
 
+#include <asm-generic/unwind_user.h>
+
 #endif /* _ASM_X86_UNWIND_USER_H */
diff --git a/include/linux/unwind_user.h b/include/linux/unwind_user.h
index bc2edae39955..92cdf38c8ade 100644
--- a/include/linux/unwind_user.h
+++ b/include/linux/unwind_user.h
@@ -32,6 +32,15 @@ static inline int unwind_user_get_ra_reg(unsigned long *val)
 #define unwind_user_get_ra_reg unwind_user_get_ra_reg
 #endif
 
+#ifndef unwind_user_get_reg
+static inline int unwind_user_get_reg(unsigned long *val, unsigned int regnum)
+{
+	WARN_ON_ONCE(1);
+	return -EINVAL;
+}
+#define unwind_user_get_reg unwind_user_get_reg
+#endif
+
 int unwind_user(struct unwind_stacktrace *trace, unsigned int max_entries);
 
 #endif /* _LINUX_UNWIND_USER_H */
diff --git a/include/linux/unwind_user_types.h b/include/linux/unwind_user_types.h
index 616cc5ee4586..0d02714a1b5d 100644
--- a/include/linux/unwind_user_types.h
+++ b/include/linux/unwind_user_types.h
@@ -27,10 +27,29 @@ struct unwind_stacktrace {
 	unsigned long	*entries;
 };
 
+#define UNWIND_USER_RULE_DEREF			BIT(31)
+
+enum unwind_user_rule {
+	UNWIND_USER_RULE_RETAIN,		/* entity = entity */
+	UNWIND_USER_RULE_CFA_OFFSET,		/* entity = CFA + offset */
+	UNWIND_USER_RULE_REG_OFFSET,		/* entity = register + offset */
+	/* DEREF variants */
+	UNWIND_USER_RULE_CFA_OFFSET_DEREF =	/* entity = *(CFA + offset) */
+		UNWIND_USER_RULE_CFA_OFFSET | UNWIND_USER_RULE_DEREF,
+	UNWIND_USER_RULE_REG_OFFSET_DEREF =	/* entity = *(register + offset) */
+		UNWIND_USER_RULE_REG_OFFSET | UNWIND_USER_RULE_DEREF,
+};
+
+struct unwind_user_rule_data {
+	enum unwind_user_rule rule;
+	s32 offset;
+	unsigned int regnum;
+};
+
 struct unwind_user_frame {
 	s32 cfa_off;
-	s32 ra_off;
-	s32 fp_off;
+	struct unwind_user_rule_data ra;
+	struct unwind_user_rule_data fp;
 	bool use_fp;
 	bool outermost;
 };
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index fc905504ddde..b5301fa9dbc8 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -271,6 +271,18 @@ static __always_inline int __read_fre(struct sframe_section *sec,
 	return -EFAULT;
 }
 
+static __always_inline void
+sframe_init_rule_data(struct unwind_user_rule_data *rule_data,
+		      s32 offset)
+{
+	if (offset) {
+		rule_data->rule = UNWIND_USER_RULE_CFA_OFFSET_DEREF;
+		rule_data->offset = offset;
+	} else {
+		rule_data->rule = UNWIND_USER_RULE_RETAIN;
+	}
+}
+
 static __always_inline int __find_fre(struct sframe_section *sec,
 				      struct sframe_fde_internal *fde,
 				      unsigned long ip,
@@ -321,8 +333,8 @@ static __always_inline int __find_fre(struct sframe_section *sec,
 	fre = prev_fre;
 
 	frame->cfa_off = fre->cfa_off;
-	frame->ra_off  = fre->ra_off;
-	frame->fp_off  = fre->fp_off;
+	sframe_init_rule_data(&frame->ra, fre->ra_off);
+	sframe_init_rule_data(&frame->fp, fre->fp_off);
 	frame->use_fp  = SFRAME_V3_FRE_CFA_BASE_REG_ID(fre->info) == SFRAME_BASE_REG_FP;
 	frame->outermost = SFRAME_V3_FRE_RA_UNDEFINED_P(fre->info);
 
diff --git a/kernel/unwind/user.c b/kernel/unwind/user.c
index 9ceef9b2b8db..0405922c5c0d 100644
--- a/kernel/unwind/user.c
+++ b/kernel/unwind/user.c
@@ -61,22 +61,55 @@ static int unwind_user_next_common(struct unwind_user_state *state,
 		return -EINVAL;
 
 	/* Get the Return Address (RA) */
-	if (frame->ra_off) {
-		if (get_user_word(&ra, cfa, frame->ra_off, state->ws))
-			return -EINVAL;
-	} else {
+	switch (frame->ra.rule) {
+	case UNWIND_USER_RULE_RETAIN:
 		if (!state->topmost || unwind_user_get_ra_reg(&ra))
 			return -EINVAL;
+		break;
+	/* UNWIND_USER_RULE_CFA_OFFSET not implemented on purpose */
+	case UNWIND_USER_RULE_CFA_OFFSET_DEREF:
+		ra = cfa + frame->ra.offset;
+		break;
+	case UNWIND_USER_RULE_REG_OFFSET:
+	case UNWIND_USER_RULE_REG_OFFSET_DEREF:
+		if (!state->topmost || unwind_user_get_reg(&ra, frame->ra.regnum))
+			return -EINVAL;
+		ra += frame->ra.offset;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return -EINVAL;
 	}
+	if (frame->ra.rule & UNWIND_USER_RULE_DEREF &&
+	    get_user_word(&ra, ra, 0, state->ws))
+		return -EINVAL;
 
 	/* Get the Frame Pointer (FP) */
-	if (frame->fp_off && get_user_word(&fp, cfa, frame->fp_off, state->ws))
+	switch (frame->fp.rule) {
+	case UNWIND_USER_RULE_RETAIN:
+		fp = state->fp;
+		break;
+	/* UNWIND_USER_RULE_CFA_OFFSET not implemented on purpose */
+	case UNWIND_USER_RULE_CFA_OFFSET_DEREF:
+		fp = cfa + frame->fp.offset;
+		break;
+	case UNWIND_USER_RULE_REG_OFFSET:
+	case UNWIND_USER_RULE_REG_OFFSET_DEREF:
+		if (!state->topmost || unwind_user_get_reg(&fp, frame->fp.regnum))
+			return -EINVAL;
+		fp += frame->fp.offset;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
+	if (frame->fp.rule & UNWIND_USER_RULE_DEREF &&
+	    get_user_word(&fp, fp, 0, state->ws))
 		return -EINVAL;
 
 	state->ip = ra;
 	state->sp = cfa;
-	if (frame->fp_off)
-		state->fp = fp;
+	state->fp = fp;
 	state->topmost = false;
 	return 0;
 }
-- 
2.51.0


