Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF96DFF885A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 12:18:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C1866B0095; Tue,  5 May 2026 08:18:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5217E6B009B; Tue,  5 May 2026 08:18:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28D6A6B0096; Tue,  5 May 2026 08:18:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 057F86B0095
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:18:14 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CE77B1C013E
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:18:13 +0000 (UTC)
X-FDA: 84733268466.21.6E97E34
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf13.hostedemail.com (Postfix) with ESMTP id 774DA20015
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:18:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=X7cka+Fx;
	spf=pass (imf13.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777983491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dLUdkq8a3Y1OwT5DXjpOwlqcJtqrXG3rf2YuzJ2NkbA=;
	b=XwU+2rTdz2d1C6C+Yhu15J2+6YeCFDTr9WT9051MbiMZrKNi0VZFfruT+UvSaB42pABgtQ
	ApewwveDbgeDJncm3DRTeCh3nvtxjvpTWFftK3+jXqrnIgU/SFdOwc/8A73+aVSixXngJL
	ELo5l6muV3B5nE0c/bTXdSh0Ye1GXnc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777983491; a=rsa-sha256;
	cv=none;
	b=AHyq599UfPCep/UJ5rK6rRymw9SEWhwclV5yu9O6finteKQFONc2YyGUEUn4Ms8OG1abZi
	hyFRxkRDhraGrsjRPWiaXmu+iM7gAE2DMMpDCYKXf8/qTSDN7eRlP586om/1K6io4B+oFJ
	FZAuc/yHT1SulpeINfcYlha3bNSFar4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=X7cka+Fx;
	spf=pass (imf13.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64563I0U2236368;
	Tue, 5 May 2026 12:17:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=dLUdkq8a3Y1OwT5DX
	jpOwlqcJtqrXG3rf2YuzJ2NkbA=; b=X7cka+Fxlkuxg3fa7fL7DkyXZdCRhE2pz
	BTBsiVrkaYM1y4geOYzbsmoSvkPnMdBNsqscjhBQMbVaD4W3GuhJFGMQVaZriqzx
	c8ArxrKaNVLBMzM9hgRFgcZs5yeph2wxIKej0NeiOQMn9VxVWYmA24OFZwkL1kAm
	xh2acRy2RRTLccqg159V5hWMJw7bQn/raaNQtnM+8rBX4zK7gc2ee5dcJL6b3DDF
	enqhF57N9MwN17Naz/gJJqXCYCg5GPWyWHf8pVoa0cOYfJpdo8KYP0qVjEVFeINh
	yXEt8CghXIfPfDFEmVte/p+FLwv0VZYTM1VOEwW0hjAzV6/nuHVrQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9y1bh3e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:29 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 645C9bkD015131;
	Tue, 5 May 2026 12:17:28 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dwx9y98g0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:28 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 645CHOUg43057458
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 May 2026 12:17:24 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C46192004B;
	Tue,  5 May 2026 12:17:24 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6092D2004D;
	Tue,  5 May 2026 12:17:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 May 2026 12:17:24 +0000 (GMT)
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
Subject: [PATCH v14 08/19] unwind_user: Stop when reaching an outermost frame
Date: Tue,  5 May 2026 14:17:07 +0200
Message-ID: <20260505121718.3572346-9-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260505121718.3572346-1-jremus@linux.ibm.com>
References: <20260505121718.3572346-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: 1-0-ys_TCaBcSRISAfsRo81sfod1BNXN
X-Proofpoint-GUID: w5dqYWUxr6Si0ukN1IIY6K1w76LcbiVL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDExNCBTYWx0ZWRfX8Swk4vct0uCk
 p7COYGCK6DzKtfxlk1afvXZijPdN3wCiC0Z9nP8yt/ZyATSIGhc+GqitKeNkfW6Hzihx2ZDaqUC
 QtG+jDGO6sw4aR7+RltMPB9Hc1qTqx6XTpwnt+ufrb7xCOhatT37skvkwV6/fqgnGtvWeR13HmD
 lrGkU0QUpyc30+rlWTK50ckHXiTdVG2DPHQwbX2VSZ1e6EcWPRfGEf+KE2/4gJdnvVJUDBs31gA
 bif6mtQbO/GL9mQxm40/zy2++U4l8mz2ELbPgJaSe7doX/Q0stZpOB6MgfXFwBoczPiI4FpibPV
 +1sZU0xJHOHMaazO0EHbRe3i6tdVUKkHc9cmLmRcbh3VDVdh7VgjtEn+zYgBGyOTrCO2npUFepH
 TzHja9M/YguCYSSHj9pGqdtvM56gG8cHnd9BfGI2HnQuaEV/JXxJq9XV4Xrgvlx+ztiiU4wzSE8
 uBUFxa5zAhEBX7MQZ6Q==
X-Authority-Analysis: v=2.4 cv=UbFhjqSN c=1 sm=1 tr=0 ts=69f9dfda cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=_1qlYuAciRtwIPuEvDgA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605050114
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 774DA20015
X-Stat-Signature: dkcoueen7wdue9z55ngpeuhby94jwxgg
X-Rspam-User: 
X-HE-Tag: 1777983491-730331
X-HE-Meta: U2FsdGVkX1+4+mOke1ZaWrFWEOUHQaX32GmnNSHCCl1jLLtsh80YEREO8mVBqzw5C/m4/hmy56LZe9ZlshSuuPiswktqBTCADqi2JFx1WUqegUKUV2/NLTRoR5ZVYJaJSbP9mGfFENfnxoE+4FxSxnbLxm9oXG8Y6/QziDT21dab1GrB2ZhKahkMt3TWH1+2ldSNRs+SXvbjD8h1n5c802UfvoX28CyOtZBiZ6FLMs7LLUDGTz81xGXEzdEKZorslgmKnwFBg0lO5EciJpHv+meRABWHV7xH1+/h2peV1E2R0Xxuce1mdewzfExqNZ0YwW0HCsyRO2pqLrqwKq08LZ+uuc1QHCnJwl8zMwfW1az40Rlu95ADIMnMT7zU4FBh6GzuX/4XHhSYEPCECXdzEyiuwAB4hQhH4Tfzly1l1brpQouOzXeR8flnEbZl67bCLHJueZ9T2dz9d/hkMRGLWxvhVyaSll0nwkxof2R+g12RvvM02vTGr+mJU80Vxn3r7eUDwf668Z4BmM1XlhacMqyzGShyINMMOBhL1bJnA5ul9BSNBMlQj2CxUAT5PQRB9yF68MmnJIemsAy5923T5tGUKjhGv5ISqmDmwL8P48ocZFbeBNvHJhQMCACCLjRFQ2/qM7N8BMExOrHFhmb5ZKYUfljG0lMj2JA1TQrOxmAl2R2V4xsimXjvBQ5Hptg2Wzf5mZ3sD/mhqvXbRk4bfIDnf8CFCcKJOU+fSChmGsRb6igy0I7KXb/nZibKLQpL/0ylr4Xfyj/J6dr7toMjtKXpNUk6auIJChicSPyqx6v/aYz1l+s3rtS3bd628X10Pt6W6k3eRIdn5r6Y1CMcFU/2rmkm3dGDstXkWUPSVdJY90tmFUxWklse/UUN/bBJR0MNkqVXGXhSNrEEN5NadLMrsu1Z8w3eaZUmqAgtWFGesqxSTQeT1HQsZVHBk3DwXU+Jb3uY3ci9J8FXYZW
 OADHBmN2
 ORfFvgMwZ0YDqmiblxI5iL8OjfJbboywTQI0tDTlu/zx8HMK8zwtxgC1I0sI+cPXLWUYy4rde9Eewi4jotMek5V9O++gip8YoYljzugwsfhbiJcg7nwyzD0Db34b1XWcfdfvi77xBafTpDKt2Ubws5dEHFfqbCeM3lef/FAhD+uUaPdnNJ2d95NT0x651axFA5aRZuOuwOZelevurLVswN9kupdnbSKL5idWeidru0z6MYGoVEQikRkDJJaLKuAzM9PvKZ+WFlWG+tFKwnSiw7jAMLlx8PJMexb1d11TR3IKH6u/6dgunOiIpscV0HfXo7ch844VBOEggUxiusPAIxkwK8mt5wR0puNaxpp6OSoTMq4yJxBTVu64AEg==
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


