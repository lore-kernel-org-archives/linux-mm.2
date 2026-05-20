Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFF19CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:40:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04B8B6B00E4; Wed, 20 May 2026 11:40:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0243D6B00E6; Wed, 20 May 2026 11:40:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2E996B00E7; Wed, 20 May 2026 11:40:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D3F736B00E4
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:40:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 96863140379
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:40:46 +0000 (UTC)
X-FDA: 84788210892.04.8077C2B
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3B9C42000E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:40:44 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=XKSutO62;
	spf=pass (imf31.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779291644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NhEny1+IV3hVg/kbIp/lU5dvCc7jZRXTsSPWi4iKz4M=;
	b=rtCXEcvSVtmyXMrSW4TYLVs2YHbRSHan0TbRGcSC9Bchviaibn6zju8no54XfGn2JjtVxR
	PJLceOzLIGnIalHP+WzpzZAUgE1EKlgq8bGXdQSqpN/eYMhoK3SqBMJQ8L+aEbSxT9OTAr
	AeC5SFtCcascg4JEZ67BoqPoE99Ji48=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=XKSutO62;
	spf=pass (imf31.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779291644; a=rsa-sha256;
	cv=none;
	b=c022yqkIri5Vg/fy3YLZNmtGH8iJswTgFwrqIWNUM/kd+IJKjBCJK3TbC0BYXv0YwWVg2R
	LlDNn0yBxmppuNZ1VBevLWErddwTBJoxhVyUCYfVs0nyDKY4OtwRo+Ll6vTn85MfMm5TlO
	qaHyGVr1r2z2t5BbhkcBxCsHRBh1sMs=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KDohNu3469512;
	Wed, 20 May 2026 15:40:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=NhEny1+IV3hVg/kbI
	p/lU5dvCc7jZRXTsSPWi4iKz4M=; b=XKSutO62orZcFI7NYLJDdtxPV0lEem7KM
	kRNuiUd07S7rN5+9E0kBglitMCXC+oLoSIvZdJTICgGPilVZCsJmvbB187/Cu18n
	jxGdgSxXPZhXj5cRXTOH+FOBGny2Wzq5TBQxDoUuM62hf+6ue1U82MB7OP/3GfKH
	qCbNIEbjjtXQ420ato8GJ5kAQhtgdZZZQUFAxIs8LKFbmqD2S7FZyOZT1fsXO9Jk
	Lf24wmoW8Gqoqv7hWQYPcLXRC2VcER2W2MgVLew7A2EGfk/yWcKEgEWqQzJL9Qzs
	f7j51kJHMe37Va8zYSlgXTCpud1TNUMWKrhvUrpe211mZhl/vxxjw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h8mtsq5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 15:40:20 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64KFd5l2031979;
	Wed, 20 May 2026 15:40:19 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e73wk801r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 15:40:19 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64KFeFEq28836250
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 May 2026 15:40:15 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6CE6620040;
	Wed, 20 May 2026 15:40:15 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D9DB320043;
	Wed, 20 May 2026 15:40:14 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 20 May 2026 15:40:14 +0000 (GMT)
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
Subject: [PATCH v15 14/20] unwind_user: Flexible FP/RA recovery rules
Date: Wed, 20 May 2026 17:39:58 +0200
Message-ID: <20260520154004.3845823-15-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260520154004.3845823-1-jremus@linux.ibm.com>
References: <20260520154004.3845823-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: bjb0sOXAnH3JU91njUgX4braTkmoUJrB
X-Authority-Analysis: v=2.4 cv=GYMnWwXL c=1 sm=1 tr=0 ts=6a0dd5e5 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=-jr7Rsxdtpxs5_a9E3IA:9
X-Proofpoint-ORIG-GUID: 1_L5HKBB9bos9ctA5fqW-NLNXeDxe97w
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDE1MSBTYWx0ZWRfX/CuZ9+mDDKtT
 f2ZnKPloOuEcfESTT5B7C2kP9j/vkmW+mGu/lXkfZA0JwAtKX0n17AJOLSdFDZ+82AVAUAaycvf
 ri8c/DdCG84hRhK0NuLSKt4Yn4wjZZAAGCGOp/76Oz069hwNR97x0z6F3sJYvg3Zpq01z/CCSL8
 SsY0qT+RCjalTsTwwuLvkJN08NWvnX1nRGwBn6eNfg4wHBS8KqcHsitBbdFe/XQCdghgp/eYo2E
 mgQ9EJx/uKq60Ra/pAAY2/gDsqEmTdbzDKXftLWRD/U59KHlT/PLHFDMoPkStBfgr8zL94O5wYG
 M14jtEVvKggdLjWechuy+tw+9AU5mJb3ghneRPJspKWHCN+B1hoZlhnMiQH5AXODhdrMAL9ftS6
 YUOnBQOQvMFIdwVUEN9lnsZZEEBe/Md+dKOuxGcndJAkU2wWIyyNFrdE51vDJHGNvbJ5yfs7Vn1
 ni5dviHW6zu+Yr//m/w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605200151
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3B9C42000E
X-Rspam-User: 
X-Stat-Signature: oqbaweb8akq8hhyfihuqdacpfgz5msew
X-HE-Tag: 1779291644-378136
X-HE-Meta: U2FsdGVkX1+miUTrDdj7XS5ZmrJn1wN6W8ZTMgmwcSxj0SgUYGrfSI6VLIAL5tfappfrcU34SmGQYpSsdfD2neuhU1v1XGuZSBOa+QtQBTpgJwT02pRcucaHGomkMUsN40h/BU590c6lpFQ5BgbrNiIZcfYLyrBb3T5MqtI8xAeXn7cGAqToRImiBUcFjNqvG9ll6zyeNXl+D5JVB09T39Wy3/hwziVj/6vo14xiL2oqSViy1XX8K7ph1PcDyIEqc5ifXxD1uQJ1lKHHWC5KmfjkUysJnwOI/Oa/zuAQmYJlt3dCS7NPjj5UI0YYxgFtMkCI+Pgq5IRaBILakKp61J3LzbotAcZqEQBxYB8DBUOPh0SmqgRcJCP3NuaW7XqIgitMSMO/GC3FXkrLMf4qgGBk2htfSuOJh7vEX3bIwKt+czrEHvQlWrHUwiBF097RY4G1PLJTnS8GoupWnhcJw2/Jm4BEXaSi6UdUAO5TvZZLbRkpxzcrOzDXY0H+tAua2G6gTjEPoWfG2vyQ/bdymErZIV73wdtFsVAoE8M3f4hP4+GbDpEkMsI2iNYmj9zIxulF+lZ5fYWqYVEuSFmovmPOkQa0OexRZpfW6L+/cL5SPFKrZ6khN3z1D2TkPtZH/EGR3dVAJjt/ROLzxif+xCM2CCg8bj7bAEUumPgGzpwzVGFchHSq+m8mABahzPBlv0aXCjkLB2EhweoK32o5KJdt3zJHY2UNsMi7ytVJK5Iet/MUCPGpDiyWzyDWu/x+ou+1pxP2mLtcN6inYAnKjZpFGBmLoGqJz4pU0k1AV55jePQl9VyfI+x709I5C1gPF9LDYQwj/ZRNhE2S676Wtl35vxZ/z6esZwiq9BaHC/nJpo6lvMnf4hd3oBf4/gpM75fCRhVfV/tgqei4RVpeYDYimwBb0pBsZI/k4VkuLvOwhWsrrs/numJLttacwRFxDW7sZBdTZFuhlZEtnyh
 mTWq1hau
 35qwcH93Jhq1ss8ggouuyzEkZLq0fqXolisUMtGncbo1u3t9h4etX33Y3mtCJGKdR7Q1dbAI3fqfriapYzhF6GGsb64sCxuw1YRQ8o+VVpiVV2EqbgPujq7r01jQEjsDeff9zb/XgVzFEXuo/PKGCLCzRoqUreJzj5eRxrH7uKXfA9wAfBEkBApEtUtGBtguJkq3wYIkjCp2o6ZFekLJoejmt4l0WHOucrle8hAa9s2eQW37s6XLQM/fq2r/yhotHNl8tlw+4NtCReEU=
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

Reviewed-by: Indu Bhagat <ibhagatgnu@gmail.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    Changes in v15:
    - Define dbg_once().
    - unwind_user_get_reg(): Use pr_debug_once() instead of WARN_ON_ONCE()
      to prevent user-triggered warning/panic. (Sashiko AI)
    - unwind_user_next_common(): Handle UNWIND_USER_RULE_CFA_OFFSET for RA
      and FP to use dbg_once() instead of WARN_ON_ONCE() to prevent user-
      triggered warning/panic. (Sashiko AI)
    
    Changes in v14:
    - Improve comment on why UNWIND_USER_RULE_CFA_OFFSET is not implemented.
      (Mark Rutland)

 arch/x86/include/asm/unwind_user.h | 21 +++++++--
 include/linux/unwind_user.h        | 10 +++++
 include/linux/unwind_user_types.h  | 23 +++++++++-
 kernel/unwind/sframe.c             | 16 ++++++-
 kernel/unwind/user.c               | 70 +++++++++++++++++++++++++++---
 5 files changed, 125 insertions(+), 15 deletions(-)

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
index 7bf58f23aa64..6aca38f89ddd 100644
--- a/include/linux/unwind_user.h
+++ b/include/linux/unwind_user.h
@@ -33,6 +33,16 @@ static inline int unwind_user_get_ra_reg(unsigned long *val)
 #define unwind_user_get_ra_reg unwind_user_get_ra_reg
 #endif
 
+#ifndef unwind_user_get_reg
+static inline int unwind_user_get_reg(unsigned long *val, unsigned int regnum)
+{
+	pr_debug_once("%s (%d): unwind_user_get_reg(%u) not implemented\n",
+		      current->comm, current->pid, regnum);
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
index 4af533e9f980..e82d1dcdd471 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -283,6 +283,18 @@ static __always_inline int __read_fre(struct sframe_section *sec,
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
@@ -333,8 +345,8 @@ static __always_inline int __find_fre(struct sframe_section *sec,
 	fre = prev_fre;
 
 	frame->cfa_off = fre->cfa_off;
-	frame->ra_off  = fre->ra_off;
-	frame->fp_off  = fre->fp_off;
+	sframe_init_rule_data(&frame->ra, fre->ra_off);
+	sframe_init_rule_data(&frame->fp, fre->fp_off);
 	frame->use_fp  = SFRAME_V3_FRE_CFA_BASE_REG_ID(fre->info) == SFRAME_BASE_REG_FP;
 	frame->outermost = SFRAME_V3_FRE_RA_UNDEFINED_P(fre->info);
 
diff --git a/kernel/unwind/user.c b/kernel/unwind/user.c
index afa7c6f6d9b4..c6a2abac78e0 100644
--- a/kernel/unwind/user.c
+++ b/kernel/unwind/user.c
@@ -12,6 +12,17 @@
 #include <linux/uaccess.h>
 #include <linux/sframe.h>
 
+#ifdef CONFIG_DYNAMIC_DEBUG
+
+#define dbg_once(fmt, ...)							\
+	pr_debug_once("%s (%d): " fmt, current->comm, current->pid, ##__VA_ARGS__)
+
+#else /* !CONFIG_DYNAMIC_DEBUG */
+
+#define dbg_once(args...)		no_printk(args)
+
+#endif /* !CONFIG_DYNAMIC_DEBUG */
+
 #define for_each_user_frame(state) \
 	for (unwind_user_start(state); !(state)->done; unwind_user_next(state))
 
@@ -64,22 +75,67 @@ static int unwind_user_next_common(struct unwind_user_state *state,
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
+	case UNWIND_USER_RULE_CFA_OFFSET:
+		/*
+		 * RA = CFA + offset does not make sense.
+		 * A return address cannot legitimately be a stack address.
+		 */
+		dbg_once("UNWIND_USER_RULE_CFA_OFFSET invalid for RA\n");
+		return -EINVAL;
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
+	case UNWIND_USER_RULE_CFA_OFFSET:
+		/*
+		 * FP = CFA + offset is currently not used for FP
+		 * (e.g. SFrame cannot represent this rule).
+		 */
+		dbg_once("UNWIND_USER_RULE_CFA_OFFSET unsupported for FP\n");
+		return -EINVAL;
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


