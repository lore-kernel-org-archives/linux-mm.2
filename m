Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A10B3CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:41:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A0626B00F6; Wed, 20 May 2026 11:40:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 776A46B00F7; Wed, 20 May 2026 11:40:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 664D56B00F8; Wed, 20 May 2026 11:40:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4DBB66B00F6
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:40:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 222BD1A0374
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:40:57 +0000 (UTC)
X-FDA: 84788211354.12.F6695BA
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf30.hostedemail.com (Postfix) with ESMTP id AAE0A80019
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:40:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=csykeJEg;
	spf=pass (imf30.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779291654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ZooUzQ2QaJzPuYG96lOZVdY7QXHL/KbZhDury++wpE=;
	b=yHluFP7by5AlR0UQ39HlGSigdMmKrBLn5lUrpJ7XLgvFt2wLFWTErNq1sMv1w6bqj9Utx9
	LIuApz7yCNOUj/MenLpoftyyUmzczk6wKNN+iM+179volM/p8if+zK8gwu43BX8FkCMkRS
	aUTBZ+vZqrKrFCc0EQCzLQIcQ4PeC2E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779291654; a=rsa-sha256;
	cv=none;
	b=nEir5ucabBhBMVr5s8pNxoO2R6uDvr2KBD68p3UVm7BaEQtAM7nP4s+eG8jp5fhndFx6wN
	dIrPSf9Jdwd2LrmrjHImbj3CwNVXmqa9Z8s2CnXk+LN97W1DNVQeBMl3NruIeCKpTT0LWD
	l+nC5089zypsfjqwOP87S7TIS1t+Gao=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=csykeJEg;
	spf=pass (imf30.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64K7NK2q980011;
	Wed, 20 May 2026 15:40:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=1ZooUzQ2QaJzPuYG9
	6lOZVdY7QXHL/KbZhDury++wpE=; b=csykeJEgfh4cW7z/gK08+Jud+T6eO1ZpZ
	+ceiU6q4p9etSKI3PrRLywCg5ZLWkjcgDDNI9/dgdRD8qDVtCjbgmYL6e33Lf/Iy
	/+HBRZHrAT36LacECE+fv2V12uG4np0+fnu2uK1wht8f4GPeL0PTyrU73cY9I/lJ
	ZvvhtXHGLflbtEl5SPe8uM6ACRTqJJ0DPLMDP/sE6gjFA+izybDd0cw0Tn53UgpZ
	yUX9+pmZHBp7bSR54pdhVBYoYZ+0LTxmPV2lFummO/O4EvXC8Q0sk3hkf9x3uQn1
	JsNCXFqrnpGYPIt/RZ7M1K6VL2NtF1DBMBhwAgidBeA9Hj0mjZVHQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h8mtspe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 15:40:14 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64KFd8rN012021;
	Wed, 20 May 2026 15:40:13 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e74dhqwe8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 15:40:13 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64KFe9f651708178
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 May 2026 15:40:09 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A6BCA20040;
	Wed, 20 May 2026 15:40:09 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 214302004B;
	Wed, 20 May 2026 15:40:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 20 May 2026 15:40:09 +0000 (GMT)
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
Subject: [PATCH v15 04/20] x86/uaccess: Add unsafe_copy_from_user() implementation
Date: Wed, 20 May 2026 17:39:48 +0200
Message-ID: <20260520154004.3845823-5-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260520154004.3845823-1-jremus@linux.ibm.com>
References: <20260520154004.3845823-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: 3btCtYYv704e7QVRif3oIlL8SE6SlRb_
X-Authority-Analysis: v=2.4 cv=GYMnWwXL c=1 sm=1 tr=0 ts=6a0dd5df cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=-G4kms3_kQfBhqX38bYA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-ORIG-GUID: ZBNYzs-Kfe6qK0IRQ9H0uETwdsz5vRZr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDE1MSBTYWx0ZWRfX7agdQ47zcZUK
 NxJf7mhM9Dq8WEgXsNveuBMroPimxAQZiVHAQLkYTpqMg6wu2nEJi9xjwC+iE3pA80Q+XlKkYMt
 moMXJCsM7Nwo3EpuooQJNvHQzB7RbsnccORBLvA/HgTpC6TuF6Qu5q85PWo5PU6FS1q/25UBH7n
 cY77XPXSParcwgdpuX1oJWgzJgx8FtbKzQzrGzjW68RUCCghe/a4/d5oG+iwf9i5ak/9OLgIaov
 PAywMX80ST6bvL85kIc7iCwIVGApyFN7K5n1wr0Hn855NGJcOIp0aA85qt0V7smykBErn8yx3dy
 69CKNQ8euWtg3HsNEiCvg6KAhYjW+1HqaJFxXPd4Npw/DoI5gSPn52jnx0YrRJTRym58i6ofbMo
 L4ZOm3t7lzEAKMA6wtCv560LFFDiPx3LH0at8/dP0k7moj6g3+WeQK4LHm7Xi69n1V2+HxmGpa9
 nJwtefS7kTWneJvRqYA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605200151
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AAE0A80019
X-Rspam-User: 
X-Stat-Signature: bp7swreqq1z7mmm9g6n5r416u98mzxjf
X-HE-Tag: 1779291654-440226
X-HE-Meta: U2FsdGVkX1/GhEkJfYhdcdqCw7gAdxcUGndwtwZxxQsn1Pn85faCZQe5pwdrZAFDylBWOvlX83eE/sHMm3MQSxEDwfShkSk/sloj0FwH7AWIreG+uMiotrqaIUuDM8zAZJNJvTbx1LP9tuGfBgyAicfx6ap8xJ29TVEGRW4uxUflCJuRaEifuscRB1Vbu7/pl+XdVJpzSOnZ+b3IASPvECp4G57Lc+KEhNwLAKq4w9VifETzs5aczIM7/oxc6tlvUCOZr2vva7RVYvke9qffu1U3HQFiZAtDmQ4LChD6ecc//z8Vaf3M7SRULStIGFbGrKX9vIw8NFiRuWq2rCJpTvqUlYDeXOn9nu/mFdQ+OT2JTusDLmOwH//Z61eR74krTVF5OzjAyScrJhPhcwjv0wHYpQ/ws7apYksPgm3749YNlgnLeHjGLnO81R/ZxTNzEyMeATmppOUUJ4bjugVXOb1RUoRm3StjG7GGOP83Hoz7/tMetSslWqMNH4whkYBP4kchL6ca622tvSoqfnT76ZpJ4nt3njxFzeHTjuBx9KGmtGp2VprAllIYj+1m9FxGhR4OMZo19dksiKGAe/JTCPCjewO9I/fXScKYTZKsXjLDk5d0mYehbqJlpqjyLqYG74WwbxpOpAwcGToP3usvpmDU5O9Z9ayFbjUyczvB6jv3aY4sPiQ/r65TvEt/W9vlfiiIYGD5sXEImYe0LpziXK8UkAF5JrF36YPkTUFMV4uALyXo+03daXT/R9qAd59Lns1JuuaVyOimlf7VQat1G5KKSH4ldtQzKaFSX4b/KxvnAG68g2JGhUkr2dTGAPb9ml/HluhWH7YUyB5PEyo18elIdqHiJgxcmtEKvkZJLjzLuk8w2dj5lQlIfsVKI863PjWprKQ4DDoA+wEHZpg3ziPaysZ1blIdOoil18sJPekmmOMlMkTu/c9cFfZncDDyAu3FK/f2FgSZNrt5Kpd
 hnrTNNm4
 bTUvRNfjZofJhh9MRoB7TgrKcF7XW0UpZ+rgITCHeRC1nvX+jrrMoRDH4MFrpZV9RcfsdRfUBu50+o2dFAE4SCmzBFTU5Gkm14/g+f/uFIhUo9FauliByrFWrw2+PYTsnrkBghelUGa9uIZLqbGXZv0RU7x4N2+0WQIKDstyPoHL3KDSYpDPtxtBVOaU+dJL+XEqN4exQee7kHnZ76mvozd1eVfwv3WBdv6RuFX0f8jR664XJq4XNzTjz4HATQGQW03C92S2pFqF7VUkE7/9T4ztu36pCGiGa8lXRqKaPv9JoeJ2ef4OTKspO5scNpCq0YM0VU/esFheJe0viJEsgoDn0nKyonAKOJltW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

Add an x86 implementation of unsafe_copy_from_user() similar to the
existing unsafe_copy_to_user().

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Indu Bhagat <ibhagatgnu@gmail.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    Changes in v15:
    - unsafe_copy_from_user(): Use const void *__src. (Sashiko AI)

 arch/x86/include/asm/uaccess.h | 39 +++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 3a0dd3c2b233..235886106f31 100644
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
+	const void __user *__src = (_src);					\
+	size_t __len = (_len);							\
+	unsafe_copy_from_user_loop(__dst, __src, __len, u64, label);		\
+	unsafe_copy_from_user_loop(__dst, __src, __len, u32, label);		\
+	unsafe_copy_from_user_loop(__dst, __src, __len, u16, label);		\
+	unsafe_copy_from_user_loop(__dst, __src, __len, u8,  label);		\
 } while (0)
 
 #ifdef CONFIG_CC_HAS_ASM_GOTO_OUTPUT
-- 
2.51.0


