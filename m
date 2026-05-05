Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78CE5CD342F
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 12:18:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF8B26B009E; Tue,  5 May 2026 08:18:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A53D86B009B; Tue,  5 May 2026 08:18:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 858EF6B009F; Tue,  5 May 2026 08:18:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 63F8C6B009D
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:18:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2FBEE1204C8
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:18:16 +0000 (UTC)
X-FDA: 84733268592.24.976B735
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf01.hostedemail.com (Postfix) with ESMTP id C66604000D
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:18:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=iKjdzuXb;
	spf=pass (imf01.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777983494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9jk0sPM0F49+3xsbmn4sxo0rBP2j0R4q+y+vLeY7bZ8=;
	b=UD5nvvwoqWa/J7rKMRoBbtmvdAxlPMBnd7fizkAxViUZNGG0UVS1N/lMsHfQYX2X3YwnS9
	MJXh5Oj7u1inavtKM2Oh6BVUK9s1xIhn+UDr+knS3tqtr6+2qp3ms0t8Sxz1Is6TXd0S6o
	d14eg/v8fICEcK7U2HJjUOgnAYFld1w=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=iKjdzuXb;
	spf=pass (imf01.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777983494; a=rsa-sha256;
	cv=none;
	b=qpPXLzaDUVihcVYRolgfam1I25mFsEN8v0PG0HbZG0hwacjyVek19YBPP0Ko8N5C44MHT/
	BPOoN9JfI7YB44Oo9yZg0iG2MbBIabCGs9FMN7ugaImCDnI4OmJyAvwie//4Eaz7Ft5rTa
	APO1m13uxLUDXDSOa06IHvrkfpGOfJU=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 644JlCCH1181000;
	Tue, 5 May 2026 12:17:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=9jk0sPM0F49+3xsbm
	n4sxo0rBP2j0R4q+y+vLeY7bZ8=; b=iKjdzuXbrhhlc+2Znc7c8kyL0c4RZpLnp
	BsPiUnGfd5H1BpjtK7Ii1Hnbi2kO41H15cRcsI9xc9BSx+VqMV5WwkliFfvqo0zu
	9pxpEBBfiriW0rrufpMrfJGziKG9HvVY09+A22EmBthGCtFTwWGBlkarsllS3+A4
	50dRIK7E0oJk6E/WmfYq1gxXJ5zrZI/UFOVDqLzLv59lIzNKIaktsp3HFd1sg2jA
	fuCOBiY6tfQ3lJ0cwz7l7IUSEZVUBRt8D+3pegzfXMiFx4lSFSr9/vOVQ7umGgVy
	LclKif646wOdKpC4dgdxFuGAx8voNl8WQUASUzOk9R4NY61Ro0tew==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9v7bj95-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:28 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 645C9okw028585;
	Tue, 5 May 2026 12:17:27 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dwuyw1m34-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:26 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 645CHN1828836326
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 May 2026 12:17:23 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0AD4D20049;
	Tue,  5 May 2026 12:17:23 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A16172004E;
	Tue,  5 May 2026 12:17:22 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 May 2026 12:17:22 +0000 (GMT)
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
Subject: [PATCH v14 04/19] x86/uaccess: Add unsafe_copy_from_user() implementation
Date: Tue,  5 May 2026 14:17:03 +0200
Message-ID: <20260505121718.3572346-5-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260505121718.3572346-1-jremus@linux.ibm.com>
References: <20260505121718.3572346-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDExNCBTYWx0ZWRfX0ihancRXGt18
 IJyGZUNmBcdxherEL9XDBqFi4UN2bl8lc7rvenJ4XR1yTQCEpuIGpBsBKpuLuN2FabrdAXx9j5N
 XM9G6pf5t5G/J+Yv6LavDjt/Y58BfuZQKUTMv2L89oFYLmGxMfSVMX5l7tU2gCGYGuCwIxjBdy/
 KNERiGkGifCQQs/YfrAQMXlvAfN2nMR8U4ADMEjRyqdA71NztLqpbFvJZkIxC7XBId/jUlZkHWx
 xQXUUc7aaOeyWYS1xhq+hv1hkZW2PbvvPzHd81xbcyNI8DtZz9x7rCTTddjnQ3fKG47ko33hk60
 VjuMCZJzdMWzyYtpFK4c/ImOgvHMZs4L7FFzquAwSX+GbWyqX//6heV+0KI14c374rhIWnAfXD/
 QPT2HNS6MiE02BAJy4h8bVOLLQPogUAYMOumG6h4CYOB3uOACP11bSOBqeYeHE0ohXCtMr9z9M+
 8wW08tLZ1GXf69M7LHw==
X-Proofpoint-GUID: 3xPfsk7dxks5BRMKUV_Iwiir8jU8tnjU
X-Proofpoint-ORIG-GUID: hJbz80oBTd2cuT1HmERswDPItq9JtWhh
X-Authority-Analysis: v=2.4 cv=eu/vCIpX c=1 sm=1 tr=0 ts=69f9dfd8 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=-G4kms3_kQfBhqX38bYA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605050114
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C66604000D
X-Stat-Signature: yrgtt3rf53tajyoc8r4q1ebkaxfuhcww
X-HE-Tag: 1777983493-441966
X-HE-Meta: U2FsdGVkX18o2iC3id4KYp9kMYE7knnSRINSnG7A2fagkwv/9WhMwrKlibANcBSGZxe3YydBrSBCHiwwTlbrz6dgEZzjQbbG/rYm5GBqywSpMn9yOm6iD2ZP9RgC7Ieik+b8LXUJm8F3Trg/ZGu3b5dhNvBBNcUgDjlhaFHpfI9aQn+5zPdLJ7RrqXfX7LHUCvhW9Sh60OjNg6IfnxanQrnecPwi9HrJEutrVX4QXSSP7K1tZxA6Pz7c/WKlAu7tUnsMKMtmDnYcjAqLm/rMdKqFJ/qlnav1s0j+8wbDvLSe/4z5t1QXEBmcJraoEj6P0TM+xvXMfi3jHmlPmE7MLlNjhkLFsgS1E3ZJ9hD8D+D1Bkrl3SzhYjd/p2YAClEzTHa/wqrh+M9iqI4/uVEyKTvh/x9YL7U/rC8x3zBAEgTbPlwjF4mFKf3OBoiLhYzXninBJzpYa8Iw+qwPF+jmD8hG1JofmkpgRgcHE8khBO4oYFNC+7quMr94DsdtwtJkbNuL83K9gLotvn+0B/btIpk++3pDWVxU50PHECzra5Msi5EtlAOXJ5dwdMURQ9ILpD90+2EKiCXVuCtzmvn+ixwF3svuOSds2VtMFK0PVc1H7zqrakKjg0tOr0xsdMKSuKhcYEtuSm095mprPbcFGxA7evnvlb4FllfBwRKgUNCZ7k1O+tUskp5Nk83iKNT0UDSax6leOLYGaVJRSrO3/U5lVptcXIs71a1eo5fMI4IP2Hluifkk1FuPy8ABQHdP+iSjaxEbgtqHbcVTYEq0bsAbnVA6EXTC5Gswk7yDR47OeobW8hJfJx2n+Tm7oeP0cuukXy5NI9dfahD0KlaEucNoSwfze7qKhR93ILLGTJhG1l+ITWUSnz5YUv4yDO9pbXXpAZi+eEgNyFp1T6UG4D4zupQlw9L9RMXNcOL1MRvXXDE3DG60NO6Jj5fG3cAtp9bwxvrTa/K3yy1wyEU
 U4Pvj50s
 7TXGMAF0CLbcJ1/T02stXC+8c/mxPfWc+rOt6NlZjhj93ozkhpGeE4X+MyBD72lKAjbBk5J/tcSyMMK8x1xrMiGo3AqFWXS5yiXfK0zU6rvO2ZtxO6rOJJkoh/qAAPuURXeNyOhPAtKwwotTZqtnTwhj09htip9XIQssm3OOhUd8ywN39AX4ihqXp5HFSlvYobPZTHT+4UAjGUocarN+nuklSVRXJTEHDc808o/ed1LLJORt37DJqEfkG5CGV3Yyue+UO8CRLE2ja7rT+cxV5UqEX+FutHMYtvhCkNgWCz6w1UUICIVH2w+v/lHgMA0ow8t62c9o57d37RsN7DzTlyug2hcXF9rVpHtcS
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
 arch/x86/include/asm/uaccess.h | 39 +++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 3a0dd3c2b233..79679779f1ea 100644
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
2.51.0


