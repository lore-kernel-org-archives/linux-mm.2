Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F423BCF2591
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 13:24:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A40DF6B00BE; Wed, 19 Nov 2025 08:24:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CA6D6B00BF; Wed, 19 Nov 2025 08:24:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86A946B00C0; Wed, 19 Nov 2025 08:24:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6DECF6B00BE
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:24:50 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 465984E508
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:24:50 +0000 (UTC)
X-FDA: 84127426740.13.EA6917E
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf30.hostedemail.com (Postfix) with ESMTP id B225D8000F
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:24:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=HTNXZ+rb;
	spf=pass (imf30.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763558688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ukMw3r1lj2iizg5Fm0FnJWDboVdsbED3DQACkvLaadk=;
	b=oz+bQKwGm38oEt1aPZzeH28qL7QC7LWlC2Ch/x/inBlPhL8wPvxYNmjh1o2TQyX7ItQojW
	TRUcseddiAaBfqH8eC/jHBWqOTbiP0KP0xVfhVs0f6X7trxGS41edJhYkBlpujFpD3LgW3
	q4XoGPNTA41PStdU5U/jzBwxUcPMb/o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=HTNXZ+rb;
	spf=pass (imf30.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763558688; a=rsa-sha256;
	cv=none;
	b=0mReTEWn6RI9oIdfnKGRMcsmQztHhJ+c4619K3StJRNNXp4BWhtIRrBNs9bXxnBu5Kg/qw
	DX2DvoZunNIc91f0htVMPlyfWaRYfGjHex1Bhem5gjW7abuLY2Rgcs49MPQGaQb3WJHVTY
	wezFLU/KvHjEXi76ywjcof31Eymjphc=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJ7vBpg006798;
	Wed, 19 Nov 2025 13:23:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=ukMw3r1lj2iizg5Fm
	0FnJWDboVdsbED3DQACkvLaadk=; b=HTNXZ+rbKr/hSu9V0SCdFnpqtKrRU3oP0
	drRVGgMOKoNmH8HAdMXKpmC/TSBmJSZV1z1+mLfjOX4nQZhdBBFDeWkwtoLfKgZz
	hOHr4CdQw6EbBlQl2Pi6kep2AWNJdUQtQk1Hx1QuOpoZfD3iaO4tXug4Nl0ncjYb
	wOpv7FBUpNrV2ypiv/8SvHN8v7nF2jKNL2tA2SgLm8hF0IVacH+Ie0wvHMdLIGDw
	Nl/rP3Mb+iKYAUOnKDzllzQ37/hCrG5fJfnevTSJuOZFIMyOaxNvfNsXRFUzE1UN
	FtQjoMf22ldgUQ8V9QChx34sBzFWaaWSc3dbmj/idCKUA5/AxEWgw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejka0jc7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 13:23:34 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AJCr9U4004743;
	Wed, 19 Nov 2025 13:23:33 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejka0jc3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 13:23:33 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJB28kR030854;
	Wed, 19 Nov 2025 13:23:31 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4af47y0wph-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 13:23:31 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AJDNRUg14811486
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 13:23:28 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CCF8320040;
	Wed, 19 Nov 2025 13:23:27 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4C9A12004B;
	Wed, 19 Nov 2025 13:23:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 19 Nov 2025 13:23:27 +0000 (GMT)
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
Subject: [PATCH v12 03/13] x86/uaccess: Add unsafe_copy_from_user() implementation
Date: Wed, 19 Nov 2025 14:23:13 +0100
Message-ID: <20251119132323.1281768-4-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251119132323.1281768-1-jremus@linux.ibm.com>
References: <20251119132323.1281768-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OUG11ymf4yULgNV2xVxRQamLPwAmbjBP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX+5fIfRLDeVY7
 290aufLFI1YOBvlDRZ7UruVGhmJnCGHWHsJQ7hSz45Fs5d2BIpIVcfzJCOzYd4rLamcU8DHfaRq
 VIx8iQ2S97g0N7OdkXz5aj58LpIoscY5SwTUKrXHRxs+BQurXPTuGDVswheBosby7I8N9cr8C/4
 OT2Okn5xrfWNp+BfRaenEkpxEm8XKihdAd6Y7aC5l0SEVGJknHNvaKQZf51n324/dA7G0EUgylc
 hhViAo8bUvuvde0e1y7Mxrr2jQ8wz0EgkyxBd+OrXEwM3nrmCIeqopY8fs2dNp9bM+l/LXuobpt
 kj91u5faxrS2R2gHr4GjfDm05agT2pFq2FKEknrlRTU/6ZFvc48oFzVz2j821a7MeS+DvdaX9CS
 UcRALHC7PNyjZKqar1P9+qNJRyrS2A==
X-Proofpoint-ORIG-GUID: lwAFvrJxVb-4CDyrCCBdlJOWDiKf1YUM
X-Authority-Analysis: v=2.4 cv=XtL3+FF9 c=1 sm=1 tr=0 ts=691dc4d6 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=7d_E57ReAAAA:8
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8 a=yMhMjlubAAAA:8
 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8
 a=meVymXHHAAAA:8 a=gpC398cPzQKiNBT45cIA:9 a=jhqOcbufqs7Y1TYCrUUU:22
 a=1CNFftbPRP8L7MoqJWF3:22 a=HkZW87K1Qel5hWWM3VKY:22 a=wa9RWnbW_A1YIeRBVszw:22
 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_04,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511150032
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B225D8000F
X-Stat-Signature: 94cp47cbshudrtpuf1wn8zns45ykp7fa
X-Rspam-User: 
X-HE-Tag: 1763558687-269476
X-HE-Meta: U2FsdGVkX19ZP1S6kJJTuwI+gmLyk7sQ16d9svEYYG60SIodhhPuhWrErpjZFIC+p4ac56bA1UDRhB0dgpQcxD2gNg/we3Fcf4J94Rev5jIcwk8DQaFXwNEr6a5KECy1AIOLGaA5sy/aqSzqOAwErA8vfcUCvMPF1KQatJTQjQiq23L60sHDHY9hlu4E8eVCmoX7/+01En2+LyGWBgJmFn5BRynAcHOPYZIMalI9KHZslqb/Y7GMKAlAvUH2u7do2oiCwQGVbNMpt6PlqgRfYgx6tTF1YGeINK/Hq7mSr3E1a1R4U48bRX5XX5/WYw7MPIh29aWic/6/we7s9IjtMx2umgv8sN/HEq4WHVn0aB9BBTY8un3JScL2viYq0lL+2dLZNIjH6dPtZ558D8zw7wxxWn5Bn6EdQAqvE5Na1VuimIcrdHsYlEuN9II/7NLRWWYD9+52qcja+SrNHaeiLIuu5+CpvHEnrmG+woCEykiSvBfoblcKj6mOEKvdwuKHTVhZ/0mFueqIUR5kfKtgu3V5j7FP++DB8kNBouNP58HNjG2E4cEnJaZFqoUH5GA3yWsJUmu5B8M0StTr6ZEBMLp9ypxKfiwCUpvsIjo13DjBWdbCDKj5OorV65SD3jR9nAzLkm/7KJ1ndhC2bmUTB3/bI5hcM5IPNcGMljPjeLYkhfsRIwEjrc5GSnjBNI5l3Au/Z6FCUrvzMOWM7potjjB0JCa3yhlOsGc693v5DYGd7qKFvmZcrnlWgR/LrbPIL06QAybFJSUqzkqwtLxRGPrSqAOnKfasMHrb2OwqaKSR+TiiuwAWJRTN5nsvxrVvVO2qQPLQahVwTT6mwg5XySnkhAA+zhVHynJW8RTATQ4XOg0lL3T88n64+qP7SkEc2MXd/rcfNokYX8J44bkEjmGCo34tZrwhTSxMQJuOThfUzrcZPKfuxo5tV581U/NMi4U19uNpy0pCgBHLckj
 YHM008zy
 lYDyTrwFMdKbCgFIgj1Wm/ggxLPqWkT9imX/qkOYnA2BeURrwEDzwiOraQm/JL7reESKO0QwLdvQdeAVnepO/R1Px4IIzrxHZC1/Kt0JEqEI0iAtpgg6k7hzgtqeMYRIcHX14f+iKEOrz2o+jgW5RiMB9NXv6kQoHXwEBlcfGlGzz2yX71WotdeoexFEAHyVVMwS1w9PBonQpGFxZptJKTr6H70g/dq0yD25gMyUuV7RtvHAE/4BOZxmVU6cbiAucXoZEpRltlYowEtJyy84SL6U16tbBHMnFiVeVQGRs+HoqcEvLpFn5vB5VtvAWThFeG7oxuuO99Lgnspklw/Rx7ZKGnw9Rtme4JhhYdQ98BBsC8GQqvg+sxWmmSe+fBfzpEuwTSARV/alo944WEVEjQ8A2gKESMKHog+e3nuxrXl/L8ANsIORHYyU6dicdedCE2mHdrWiuB3sj40GtEAhR11zFeTeUOgMHEN+y7TJjKpt5nlRaXYLkRmkTUQVK2fgedtpAvP3oKKJ482ZJBAPA51yjthXaxKD9sByT1VJGLxFcqrUrHTFT7mMZb9aN+Xst123HFLhiG+GsckFTJpEHHDqSlpBtqTd4GoRi9j6hOqo1Y+hWdOHK1awUUmPyfE+BAvrXw0VpsaAYbwuoSUnz0OEztybFAp33/Nll
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

Add an x86 implementation of unsafe_copy_from_user() similar to the
existing unsafe_copy_to_user().

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
 arch/x86/include/asm/uaccess.h | 39 +++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 367297b188c3..dfe143235967 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -598,7 +598,7 @@ _label:									\
  * We want the unsafe accessors to always be inlined and use
  * the error labels - thus the macro games.
  */
-#define unsafe_copy_loop(dst, src, len, type, label)				\
+#define unsafe_copy_to_user_loop(dst, src, len, type, label)			\
 	while (len >= sizeof(type)) {						\
 		unsafe_put_user(*(type *)(src),(type __user *)(dst),label);	\
 		dst += sizeof(type);						\
@@ -606,15 +606,34 @@ _label:									\
 		len -= sizeof(type);						\
 	}
 
-#define unsafe_copy_to_user(_dst,_src,_len,label)			\
-do {									\
-	char __user *__ucu_dst = (_dst);				\
-	const char *__ucu_src = (_src);					\
-	size_t __ucu_len = (_len);					\
-	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u64, label);	\
-	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u32, label);	\
-	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u16, label);	\
-	unsafe_copy_loop(__ucu_dst, __ucu_src, __ucu_len, u8, label);	\
+#define unsafe_copy_to_user(_dst, _src, _len, label)				\
+do {										\
+	void __user *__dst = (_dst);						\
+	const void *__src = (_src);						\
+	size_t __len = (_len);							\
+	unsafe_copy_to_user_loop(__dst, __src, __len, u64, label);		\
+	unsafe_copy_to_user_loop(__dst, __src, __len, u32, label);		\
+	unsafe_copy_to_user_loop(__dst, __src, __len, u16, label);		\
+	unsafe_copy_to_user_loop(__dst, __src, __len, u8,  label);		\
+} while (0)
+
+#define unsafe_copy_from_user_loop(dst, src, len, type, label)			\
+	while (len >= sizeof(type)) {						\
+		unsafe_get_user(*(type *)(dst), (type __user *)(src), label);	\
+		dst += sizeof(type);						\
+		src += sizeof(type);						\
+		len -= sizeof(type);						\
+	}
+
+#define unsafe_copy_from_user(_dst, _src, _len, label)				\
+do {										\
+	void *__dst = (_dst);							\
+	void __user *__src = (_src);						\
+	size_t __len = (_len);							\
+	unsafe_copy_from_user_loop(__dst, __src, __len, u64, label);		\
+	unsafe_copy_from_user_loop(__dst, __src, __len, u32, label);		\
+	unsafe_copy_from_user_loop(__dst, __src, __len, u16, label);		\
+	unsafe_copy_from_user_loop(__dst, __src, __len, u8,  label);		\
 } while (0)
 
 #ifdef CONFIG_CC_HAS_ASM_GOTO_OUTPUT
-- 
2.48.1


