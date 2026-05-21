Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BF91CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:26:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C43CC6B0095; Thu, 21 May 2026 10:26:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1BBA6B0096; Thu, 21 May 2026 10:26:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0A7E6B0098; Thu, 21 May 2026 10:26:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 968F26B0095
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:26:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 55DE88F2C4
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:17 +0000 (UTC)
X-FDA: 84791651994.11.7BC26B9
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf28.hostedemail.com (Postfix) with ESMTP id 04A2BC000B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=iZeZjlWo;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf28.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779373575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SmI34slVZs1BNH9m6+m2YOZNt+zp/AB28hIWnnNMMn8=;
	b=6QV7cp/koRujTnjjgL05jxRtR8yB2bLViCxiG2ft2Nt4X+sI4DMF+Kl318hTisyS9GwZHE
	iHrI9VmojwZRjOZLyrzqcRd7Ortw2LpYdrT/I2Llf4Q+s2vihL9JOlwWkFjNm95aejxU9Z
	D7DxVRz5fgpqvl8BHzFEocrIEcXFVS4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779373575; a=rsa-sha256;
	cv=none;
	b=60ki6BdpCRk+++L0YqtlGCIZ5qT5iXuOeQmrk0+uYvPqm8EHKzqjQVeegt1hPThA/rYzm0
	c/0Nbg+pIaH0ItprOQhDIDgCpe2OZxG0sXcWAnMl+m2uJKbqH74wdVY+OH05JqyI0m34xF
	nC29AiVZsQCSe3cGbu+0tYP6SKAiM3w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=iZeZjlWo;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf28.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64L1kP7S2907049;
	Thu, 21 May 2026 14:25:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=SmI34slVZs1BNH9m6
	+m2YOZNt+zp/AB28hIWnnNMMn8=; b=iZeZjlWoa3xojRQ9GYDXflQBwFUAqq3KP
	PwrdPAAYWNnwxiHWuYpU5A0ZeySHLsEs8VwXeAdSd3Stinke4jbgo5e76MyX4Agu
	mozc/rVVPuTGwegRMLPPLdURfmfoGWj634slWKnmLjGWz8nFjC60znOPeKqszx6E
	43SBHY1aFmHZ4fL2YvyfXq1o3oBoawTxeOcKdquFPQJq/oaBy6Cfdl3FUzRJwBYn
	DI+aPy0cTv8KfqZuf1c9UJecMNH/JD2Ijx2qI2IR6wGA0yLQ+3O9kkez90obtOdC
	URQTYg+uS7EqlkI4FiRNlSbBD+4HxZH4KvcP1qn3hAtMqwdMpJgnA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h8myd9t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:56 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64LEO56P027486;
	Thu, 21 May 2026 14:25:55 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e739w4pew-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:55 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64LEPpqS47448364
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 14:25:51 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 919A620040;
	Thu, 21 May 2026 14:25:51 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3AA0B20049;
	Thu, 21 May 2026 14:25:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 14:25:51 +0000 (GMT)
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
Subject: [PATCH v16 06/20] unwind_user/sframe: Detect .sframe sections in executables
Date: Thu, 21 May 2026 16:25:32 +0200
Message-ID: <20260521142546.3908498-7-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260521142546.3908498-1-jremus@linux.ibm.com>
References: <20260521142546.3908498-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: BXQPl9o_9hJlojKYzPjBMR-se2WqGftm
X-Authority-Analysis: v=2.4 cv=GYMnWwXL c=1 sm=1 tr=0 ts=6a0f15f5 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=eNuN5pRUQDBy6NUwPKcA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-ORIG-GUID: l9IPRIG7Wx9EHFafGw2nEDMxjUpnlYg9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDE0MiBTYWx0ZWRfX7G3DLMzxR02p
 juBaGJ9UnhbR11PxgAq77UYKxICjNn9Bkz5kgWYIHO5o9QUgP+HOS3nSHsis4WpHkk+U8+LjCPU
 tHxmmejAbCHLoBzLgAXfE3q5ruren8okSHXrUcGCY/pFnw8Fs4HsY66QPIfEpe8V/1Aqnqy+F0p
 Zv6IZbXjOPGADi1TxPN7TAh9N4C+XJQdSSMtJWKDbcYbE1665cbc+jEKOFObXwrHCMtRpl6Agiw
 HfAqD1NaRfE5iSqruKcHYjgz6V8zJnkv11g3Zuo9tiQwgKiGllH4sHY5Oj4TJQ6L/cpGdtMRhTE
 Yos8nAUr75yuxIExbXCZ0SmrJxIhH/2lZOrrUZrMkEVlmLUhuFP06rXDnlet8MQSO+b1zrF106d
 63ejUjr73QcXxcpUeuG7NZBGmB0Z1Z9MvHE8mpDJQ0+8QW8tW0zXZbJJYbXB3fPJ87PEegZPssw
 LClfBuW9WvSWSlfadBg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210142
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 04A2BC000B
X-Stat-Signature: pb4u9kp5x5ozqffbuh715qrd6a5oaequ
X-Rspam-User: 
X-HE-Tag: 1779373574-126765
X-HE-Meta: U2FsdGVkX1+VqDzB23jii0Kyh1QvstVtIymiyzj8gVIiUBHAN81mFbtrbz1xhA46joHinz1RCUf3AOpeAnUD+9cThl+7Rd+UQqY5hiDgnhIU46blVF+hOlsyG7xJDftjV1qEpSHVe0glBUPo8jgeUqT7Kkn3daTEhKUcCM5l8BnG9duj1tM6jyC4uWUjZucsyGBS48HfFZyycuF0kiXGTDAV5ipl6OMk7r5fJ3VieelL7AMc5kwZ66rFUOLXDHacahKUJKoC1aV6mSLuO2B+oNi2oBySX1WE53Nwl0/Uh8VIOwtXiCyYH6d5U+i/GspWkC59Q9jJotsgTky2eSHZbSPOwxNDOcC0fbBlToVhUbTH7bNhV2puPlEhNrlDCsYhM6xjtjc+Lxq+ZoLaQAtA1jZUdtGx1jFdF13uMjKGQngOFTDfCYNj5jPkekyHvkdQJMe06ekofjKQMzm0elBJKfnMA3i64W7vDKv1jlaDFhIUUyZ1fxA0pJvqbqEKnHibfnDfYu8tPsedc4fI+WSRMGgbiLG9XMFKcrJxYRE2DYP84Q7Cnq8PKfb0ek1cj+jKcoxPaMmOlJXlfKQSKbdbX6b71zmged02SYyz9XHB4LfjXKnbEVKg6Ggpvi6z6R90+zzHDX+LrzhvcDuKceNIJ2+LZKRcSZAHtrQY/AIDNbliHXeP6jHyA5wm0LE/Kq/mTOYcAFU938BxOIi/+OBJG2GTuTkeGhmFazaXOaTXmCMPdjrmD+/RyqpAqmJO4pYj+rsV4EMBLPzuUOldV6VsAe87GG7N6/AHlSar5kCgvLf6IQ3tPwyZR0ocjCoOFLCO9+r4scVrrMkUah8NWpbV3jH8+lcobHdj7j/Nl+OV6UAhIejHlRdXORH6oA0eyoSopyNqI0gw4N5H2uTsdPfsQ+hddcSsHSATxUnXNe9d3WqLpsK5FQWtXX28t4y+ea4kl1ORft5J+y1dYa2dpim
 As63yavN
 gDUiqZoeU+rsHMdkfJpoY+51PRDnSOgYooPICREi2V76JIipnexA3FdVA2bIZwQFw9DglTaGAto3s8Vijv07UjVOhZV6zseeChjq9ITcNSgX7AEm715MtY68ewHNQg2PwgwqB235bjEDi08npMQAYxBCTLhvmJgNXDtsPGmPBzSkXywuo437IrRf8D0vs+Xkx9VZqtfoZ6SG3MTuo6yCM/5MjzmBxYFK0vczAiDHf7UQRg++wmkQI9f+E4b5qehR5NW8k0/HCJvm1fafTU0RdhX5rBSaAfXvP3J8G/NvuR3ZP1Ut1WrwIdGCj9w/e3Y0kxxY0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

When loading an ELF executable, automatically detect an .sframe section
and associate it with the mm_struct.

[ Jens Remus: Fix checkpatch warning "braces {} are not necessary for
single statement blocks". ]

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Indu Bhagat <ibhagatgnu@gmail.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    Changes in v15:
    - Only add sframe for text that is PT_LOAD in addition to PF_X.
      (Sashiko AI)

 fs/binfmt_elf.c          | 48 +++++++++++++++++++++++++++++++++++++---
 include/uapi/linux/elf.h |  1 +
 2 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 16a56b6b3f6c..980a9f229cd1 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -48,6 +48,7 @@
 #include <linux/uaccess.h>
 #include <uapi/linux/rseq.h>
 #include <linux/rseq.h>
+#include <linux/sframe.h>
 #include <asm/param.h>
 #include <asm/page.h>
 
@@ -637,6 +638,21 @@ static inline int make_prot(u32 p_flags, struct arch_elf_state *arch_state,
 	return arch_elf_adjust_prot(prot, arch_state, has_interp, is_interp);
 }
 
+static void elf_add_sframe(struct elf_phdr *text, struct elf_phdr *sframe,
+			   unsigned long base_addr)
+{
+	unsigned long sframe_start, sframe_end, text_start, text_end;
+
+	sframe_start = base_addr + sframe->p_vaddr;
+	sframe_end   = sframe_start + sframe->p_memsz;
+
+	text_start   = base_addr + text->p_vaddr;
+	text_end     = text_start + text->p_memsz;
+
+	/* Ignore return value, sframe section isn't critical */
+	sframe_add_section(sframe_start, sframe_end, text_start, text_end);
+}
+
 /* This is much more generalized than the library routine read function,
    so we keep this separate.  Technically the library read function
    is only provided so that we can read a.out libraries that have
@@ -647,7 +663,7 @@ static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
 		unsigned long no_base, struct elf_phdr *interp_elf_phdata,
 		struct arch_elf_state *arch_state)
 {
-	struct elf_phdr *eppnt;
+	struct elf_phdr *eppnt, *sframe_phdr = NULL;
 	unsigned long load_addr = 0;
 	int load_addr_set = 0;
 	unsigned long error = ~0UL;
@@ -673,7 +689,8 @@ static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
 
 	eppnt = interp_elf_phdata;
 	for (i = 0; i < interp_elf_ex->e_phnum; i++, eppnt++) {
-		if (eppnt->p_type == PT_LOAD) {
+		switch (eppnt->p_type) {
+		case PT_LOAD: {
 			int elf_type = MAP_PRIVATE;
 			int elf_prot = make_prot(eppnt->p_flags, arch_state,
 						 true, true);
@@ -712,6 +729,19 @@ static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
 				error = -ENOMEM;
 				goto out;
 			}
+			break;
+		}
+		case PT_GNU_SFRAME:
+			sframe_phdr = eppnt;
+			break;
+		}
+	}
+
+	if (sframe_phdr) {
+		eppnt = interp_elf_phdata;
+		for (i = 0; i < interp_elf_ex->e_phnum; i++, eppnt++) {
+			if (eppnt->p_flags & PF_X && eppnt->p_type == PT_LOAD)
+				elf_add_sframe(eppnt, sframe_phdr, load_addr);
 		}
 	}
 
@@ -836,7 +866,7 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	int first_pt_load = 1;
 	unsigned long error;
 	struct elf_phdr *elf_ppnt, *elf_phdata, *interp_elf_phdata = NULL;
-	struct elf_phdr *elf_property_phdata = NULL;
+	struct elf_phdr *elf_property_phdata = NULL, *sframe_phdr = NULL;
 	unsigned long elf_brk;
 	bool brk_moved = false;
 	int retval, i;
@@ -945,6 +975,10 @@ static int load_elf_binary(struct linux_binprm *bprm)
 				executable_stack = EXSTACK_DISABLE_X;
 			break;
 
+		case PT_GNU_SFRAME:
+			sframe_phdr = elf_ppnt;
+			break;
+
 		case PT_LOPROC ... PT_HIPROC:
 			retval = arch_elf_pt_proc(elf_ex, elf_ppnt,
 						  bprm->file, false,
@@ -1242,6 +1276,14 @@ static int load_elf_binary(struct linux_binprm *bprm)
 			elf_brk = k;
 	}
 
+	if (sframe_phdr) {
+		for (i = 0, elf_ppnt = elf_phdata;
+		     i < elf_ex->e_phnum; i++, elf_ppnt++) {
+			if (elf_ppnt->p_flags & PF_X && elf_ppnt->p_type == PT_LOAD)
+				elf_add_sframe(elf_ppnt, sframe_phdr, load_bias);
+		}
+	}
+
 	e_entry = elf_ex->e_entry + load_bias;
 	phdr_addr += load_bias;
 	elf_brk += load_bias;
diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index ee30dcd80901..e2a7dbed2e80 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -41,6 +41,7 @@ typedef __u16	Elf64_Versym;
 #define PT_GNU_STACK	(PT_LOOS + 0x474e551)
 #define PT_GNU_RELRO	(PT_LOOS + 0x474e552)
 #define PT_GNU_PROPERTY	(PT_LOOS + 0x474e553)
+#define PT_GNU_SFRAME	(PT_LOOS + 0x474e554)
 
 
 /* ARM MTE memory tag segment type */
-- 
2.51.0


