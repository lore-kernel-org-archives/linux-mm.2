Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46C6BCD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:26:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2F2E6B009E; Thu, 21 May 2026 10:26:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDF6E6B009F; Thu, 21 May 2026 10:26:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF5486B00A0; Thu, 21 May 2026 10:26:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A89576B009E
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:26:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7AFD41C0508
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:19 +0000 (UTC)
X-FDA: 84791652078.09.F331151
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf30.hostedemail.com (Postfix) with ESMTP id 13D2F80002
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Zh6v7aCn;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf30.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779373577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ZooUzQ2QaJzPuYG96lOZVdY7QXHL/KbZhDury++wpE=;
	b=kgDdcCVFIGNb6j4Wio1th7cLAp42QoUeIEDP0tI05MZL3IXallDUCoMM7rTTyNZbvSP9sR
	6Q6Ms7fdh4vdnoslBLQCELbCd5DleJMitp2XWio73YFFaDD2rgkRC6PAqdtQYlFP5jNMiF
	d7wpoC/CpEkq2xE/DjUWFTbwv0BraKc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779373577; a=rsa-sha256;
	cv=none;
	b=RGkGrzVUZhsDse1Ep91fZsB3OpJodK0NzS6166EnuzFCael8DOKMfElE29iuoqV6jfSu6t
	dv1tq5ryDOnXvLPcJgYYjPO+9NCAcwM9OpLXw9xZ8faWENOEjWokfkBc46P4Qtb7VwOjgp
	Ix/RkkuT6g4KX2QHkWa2uPj191iUzBE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Zh6v7aCn;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf30.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64L1dtx24007920;
	Thu, 21 May 2026 14:25:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=1ZooUzQ2QaJzPuYG9
	6lOZVdY7QXHL/KbZhDury++wpE=; b=Zh6v7aCnHl6/ehEMjfuOJkhk3yeaW6Uvx
	zvrImVf3YiYdBKKU4fXBjc8PG2089AIC/ZYMuoJ5QijMEQ89rfDgXcXqsM2zOwDJ
	Mn1N/+ULPK5J3/yXOzneKJKq3zwA08snacFQCQwLNcV4XukIFiWcikkqEKhxA7o3
	9A3EMjc1dECCtWGo1z2snvWwTrfLGp0zXjpp21+ap+UpveX0Eh7PLwPXXAIaBJ+C
	n7PnfQmz+ARgPv+4mbjQf5fOqsjiLYpPDU/s8H1J49u8jXgNNgfZac+opSEmCRUV
	+ayFca78G5SEg3cy/q8xHu/IW7vs/rRyqX7ZX8P1dr0DLZfd2+Nzw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h9y7gr2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:55 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64LEO5qt027490;
	Thu, 21 May 2026 14:25:54 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e739w4pep-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:54 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64LEPo5n17891762
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 14:25:50 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B4D962004B;
	Thu, 21 May 2026 14:25:50 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5CB0E20049;
	Thu, 21 May 2026 14:25:50 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 14:25:50 +0000 (GMT)
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
Subject: [PATCH v16 04/20] x86/uaccess: Add unsafe_copy_from_user() implementation
Date: Thu, 21 May 2026 16:25:30 +0200
Message-ID: <20260521142546.3908498-5-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260521142546.3908498-1-jremus@linux.ibm.com>
References: <20260521142546.3908498-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDE0MiBTYWx0ZWRfXwO0m16WCn4hD
 o/Ob3KO5UXgAEzdmWXWXgi80XvDvQ9aeLk78rCbWBk5lPAWKNbYTnbSV0kdJoKG7kjIXYpTkcJq
 uhoM1bHkWYfA29QdEcBCE7ROqgrohRZ4/Ew90D4ARkiS0nO9tzg4FvE54maqPU2uwz7A2+CSPs1
 ggcLqIFwv5fDbY+cAnNkJLUTRvI4wmJp3Oo86A7ulT2Mbw/fBGWSRWWxMA6ak6beezsmBbjAghh
 5HvGs0gAkGe1odKWNmZz8dFoXyiuWIiUje1Eg/grZ3BFNjpCkhZ1BGIAazPJYHXm3y4iCXkajt/
 cueDwbRgDI4mgFH+ctn9rbYwMg4AQEiKoEfOaU7j89fKfN/Z6ljT1EdkBtc7Q01qXL77MAQN3a1
 OIbdPeG2eWIEvWn/Ot7OV2yRK/vatxjrkWSQmvb2nfO9GlzKhnjFDe2BQwv/kfE4F75pDIqhJWe
 ebr+QFLR8GUj2rOdCXw==
X-Authority-Analysis: v=2.4 cv=BNuDalQG c=1 sm=1 tr=0 ts=6a0f15f4 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=-G4kms3_kQfBhqX38bYA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-ORIG-GUID: MJqE03EPVOgKZfrWFiKGuHq0HUysVT8O
X-Proofpoint-GUID: MIgYzg3bxZ8sWXFHjYoqPLKNUx8wptn5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210142
X-Rspam-User: 
X-Rspamd-Queue-Id: 13D2F80002
X-Rspamd-Server: rspam04
X-Stat-Signature: hs6haka1zc96x378isas5obq91jraffd
X-HE-Tag: 1779373576-448730
X-HE-Meta: U2FsdGVkX1/7UKgYX3CYgx1io5w6aMAMMFkZue8c7KhY4Ng4qlxuspBItyZzwRBCsnTW1CqNdeBCRhPH8YtCHOS4ZdbzYpEUV/+g42ctGwJ5uBNxpV0CrZQIEDTi5k405KRKhDkIZyA2lqX9EWnpMTiTcHiaNVIBKyKUjPyYoC54GUmo9w4u3CFh/aHyC7L0QJwHVn8TWSfmUS18TzZTtY+/IE3OjeeXkdk64HM0PXy3OPXm/j18ExWWzlL6rNmC/b+Zfr6zOX7XalNYMLHtpi9JEZJSo5PoO9uNbBXZ0Vz7S0jv6MqnXxm+JC1NJpl7WhY6f9qfAbIFC1YdH1+jZbXsPAzBjkxbWAcgmQ7FoKWG3ZeHDQMlpWK24B5ouCaaJ7r0karAtvMSB/Q/Oq9cfzzuZqWUVBWnbZOIcHD0PL2LnedCmJ5Cb43/eCQQG8z22SjWLRbsbc8IcRTqecD7CRTP9kfXkjB+S6+c+dtFMTC0BbS0zbU2C/3QMRtDm/fqmRrNf4rJlGfWF5rn7jm0ghqzZXwE/ZOHWGSUZUu0wuTKe4k+1HNYZSb7bXaCQa/7RRjUOfrP2awRU/B2VKBnlvPcKXZNiasyMHIGgyM8TUMT2KgJ6+BA3pmthxAntK8yQ05lSvwWveYBfqSRb9F7euDypaEAL/ilAAOG1MZN/D3fh42R8H87t/vPoZkskA3Pos7O2xYAonOGWp8NnV2+K9nncvBFF876pwg+JuexHMmQPNeT7CwJB25BlwQbH8T6ZJ0GYEPPeAttATRig0tPflC9ck7e2AX0oVuc8S4A+B50oyLDZyZQzOfgaVIoBEpDZQDBh6b+c4qbmr3S+qI32hl2owxxHZqn8bzLKYtXvNqtCZBlaaJFZh6lsnoaj42YMBq3DTBSzPYkyqXF/OhnOkA0Oc4gA1AaJWoDU6kW8HPMI4KXt8rQQjiX7PTxqP9vLNP34zwj49g8oD45KYv
 HNGARfcw
 oJdWG9GXy+2YJFMYgamUQInIxDs6DQNPNXFxs4qDM3VYuOAm3s4rUe7Qq7bP25RSS1CfSt/rzDUcnZASWMm2hURyrxgYGZpnGRzwRp1Uw+rQ4ebl5luMf51BpH5IV8cVBhAc5+2VM7FJExihVU3Cb4y0QWkYWT1UG43VAEHVqeWatTi9DknG3SW6x862gC4ZAmA18JTcKzP1eAkT5iGy+CXGstup7tjA9FhUartA9DC3qPphK8Qbuy2oyGO40F9Y5TDiEq4VecJ+4Cycei/eg1ReP7MP8ITksouU4vQacf4xyM/x2u09QKFCHRZi0rsKK3GX/+JzB2lISvlA8egaLtHQenJbSAT774KlehtSAYOHus0w=
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


