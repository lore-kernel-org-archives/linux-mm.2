Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25D2ECD342F
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 12:18:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C51796B009D; Tue,  5 May 2026 08:18:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDA966B00A3; Tue,  5 May 2026 08:18:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 942596B00A0; Tue,  5 May 2026 08:18:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7738E6B009E
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:18:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 14F51140494
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:18:16 +0000 (UTC)
X-FDA: 84733268592.05.D3A2333
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf28.hostedemail.com (Postfix) with ESMTP id A6E48C0002
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:18:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=e1wY+P2W;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf28.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777983493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k5ofOJ1moPTodwUkbfHb65qSUnojL/Rp9HGldnq8Qw8=;
	b=7yF8BKmOwIO4WsGB2OLncbXXvxDVuEqOHqfT1kIf8WvP6GbQzPyDgRoD6zFdOvJB7hj3/3
	MnFY1urf2Eix89D29i3uDUCqVTaO0EA/gajdi80cNUcBgGhxqnMkDuUcOaDUeh56BKf6Cu
	hxC4SMEJlZXx/uP5IRbBd0HE2eIBN9Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777983493; a=rsa-sha256;
	cv=none;
	b=DoAS7epfS+G+IzokFioVz9moS7PcT5joi3JMfosuj3P/CkuI0zSGLAJvwLGaGhAEG1kW9x
	nR+fIzziQj6/0obYdycynlt8X5v0v71xsBpwuK7unim3sr54ufSZrCkPSZpbvWahIdjtj6
	NyFY5TbWiIxPygFgv0daa3DV25ZncZ8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=e1wY+P2W;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf28.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6456dK0w2830434;
	Tue, 5 May 2026 12:17:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=k5ofOJ1moPTodwUkb
	fHb65qSUnojL/Rp9HGldnq8Qw8=; b=e1wY+P2WZuQUQXbFnRer74oVxovh+XLrd
	+yp5CK6KX5mfum1cLjx1aoOH3iaY4ROEOJfEZMYPj4c4284r6/JbR7uIm/tgPTkp
	Fdk2ILbq2mQhqpE6fxUpl6dwEvggLzTpOJ1tcWeDjdI97vadltUeGqiXp9rxlu7H
	i03iZHF7zS8wuF8GwlpnnZMyA9sdGOcBT1zu7laZYiTyzSC/AXJ/kDynqWKAjn1m
	8HAiFxFSgdmpX1BXQpKx1ZNYvSLBGta6geodvqr4elOxBL2OV9aIvdCEEf8u/KMb
	hyGTgXhkHmJX3wU1qw7YD3ZWUn7B3sKCsjWlV97LI5UyJbqlUPyCw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9v7bj9c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:29 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 645C9cg9028517;
	Tue, 5 May 2026 12:17:28 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dwuyw1m36-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:27 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 645CHO0U47120820
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 May 2026 12:17:24 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ECB012005A;
	Tue,  5 May 2026 12:17:23 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8BDAB2004F;
	Tue,  5 May 2026 12:17:23 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 May 2026 12:17:23 +0000 (GMT)
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
Subject: [PATCH v14 06/19] unwind_user/sframe: Detect .sframe sections in executables
Date: Tue,  5 May 2026 14:17:05 +0200
Message-ID: <20260505121718.3572346-7-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260505121718.3572346-1-jremus@linux.ibm.com>
References: <20260505121718.3572346-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDExNCBTYWx0ZWRfX32jibKdZJZCs
 ZePO5pCYnL9OPPWGB+AZwqGlPiDnBByysOkOSBVZvn8MiB3mja0YLF8/Ruf+NpxcjzsyqtRNzB+
 gsfKQ2gwcFfF0IyoZqZAInphG1u+bRB865bCSXLOmW2y7Cg8leSRCSrPZB/sNT3YbGGNeWQIcWA
 09rflUMWCqfEDyGcK+2HK9GAQ1YxRS4u44QTN5yBBVIEeSxuaAAWjZJI/+FBKr5I97M93zRpsyF
 cbJrdE9tBFzMujYhBpbYAytSKGl89pE/gR3QUUUenfmWMizQqJd+9HtrP57M2PWZ1If1CkXCXyU
 5vRtZKMsuWgN0Maon0OkBzppepywSd/Vme2iXJ4y2ZMzb3CZQps5NXfXqg/ekT7Bq5DpTEL3Fkq
 y/Ku3HOQoJp/N+p9tNKW15ckxVVNXqOb0MToCl3Nr1xYZgZ2ELQ26OvOo5z+IW0nsv8MZUY5Rdp
 lTlxGy0TmBroDdkqSeQ==
X-Proofpoint-GUID: fzj9uFsf6c7HKjWKSDnaPdn2Yfv-VtP_
X-Proofpoint-ORIG-GUID: PWKs1mmxDnri6Rb3HU6o6VZrxoTM0UrX
X-Authority-Analysis: v=2.4 cv=eu/vCIpX c=1 sm=1 tr=0 ts=69f9dfd9 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=eNuN5pRUQDBy6NUwPKcA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605050114
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A6E48C0002
X-Stat-Signature: xankqf8jukdwd5u9nng9fshgc8xnugm1
X-Rspam-User: 
X-HE-Tag: 1777983493-162159
X-HE-Meta: U2FsdGVkX19EDaFAwCwhJ0wzANOtZ7TsyDr+lVdK62q+8GD6Dc5RgQ5/dyJ8cltY2Gxl1hXeu7IoBVAiAoS7G5IY3e3/eN6G4AIsaeG9dr0q3Xii5hull87b48+bhGnaQA2J2R98S/DFedqQIb0D2z4uXi+Mz2Fs31tVHvGM2BzRy+IOpjo6H2Z55rdjqG45DpZKLzoz4PLl6WnGmWvQZHH8vSH1unmK6fanCnxvD4Sp0fzEuUl6tpnMzMhbJGBPrjydf7kPaD8NRrjWX0Jr/1fwau4BMTLmmRVhJFPtcLKHr2l3iCEf5Z1wSPOspMCC1KFORDNCNEa1LCXrnDHMYnraMIQ8mQSE7OYgS7DiS38DFVDwNdlRcLRPsWbcnUq4F0DIfMK1YkdcstCjbHDbluo6gMXqJ/Ylhi4xCNAlNdlN0g/9StKgkYjDtksM9zHlKPOKVlRsbASjH8Hea2NNIKj2EoRFISeCE3w/Mja5h0ZHjf2CekGZFLkQryuHqqBYF7p8ZEb0d2rbh1aGkAngQAnML9hhzGmfuRybz6m5ZDvpzuVgQDlSxcNeLlisspHynVEqZbH0ANpmJIpLFb6Ke4W1hxr2Hv0zlFYeRBYc4wPMbOwMCsZfG+8jDJinAS38u5VP/hlhFtJXb/fex28HXB8WAjpHSm5PnkvCz7nCjtzzJP0lv5hJcVgLeL9cflZoFu4s6VXPkbso0SKq094JTvbdBVL2qGlBdqfRM2xHbGFMUVbRrdVQpe5xX+WrUiOyjULOcUyooEvMVNIR764+aWo8+WMs08VkSMRxA5jmDV7WEDLey8bDD2s3EHVVTBXye99CZ54+flF8jqXMngtiCuZRLaMoxXbIDpAKsaeB3sBBSpmjxFFk3CnOIh1DrFf+NF4JmdsXnU7wFSh15OVFFUVhvljBaar0lCEOAyWGtX+QtteYJzjyji53YCZQMmIgy8hzznK1M03U2k5e4CT
 I91beMvW
 agwtHbFjOqHh27am6ZB+k4P49nG6hHvALhvpx9x2CE8WpgW/hlMsY5uGcG1xvwcZ9gkU7MXzxhh3Qn3+Ao64MYJK5fAVZ5Byf7HEUPbzMhSi31uPlwvj6o2mMVy8PUwtHPFZoWTa2oMXyT75VUMcpyjHFWuQuqf1eG2ZtIIM986fsUbTNZ3p0e42/Ag35R2372SxWnp9/59gr1zrMF0FXsMsrCfGgjCoTUTQifnKKfURVKQi7+U90m07jDhv+WOew9fBVfd7QOmJTIYjBKHZXj54DlP0qfMEPhQRTdihYZ38S6G32MkhVnudGooCGgJP+ZsPhZ/8Gq7M/m8g1+ymQI0wCMoj3u5B35t+w
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
 fs/binfmt_elf.c          | 48 +++++++++++++++++++++++++++++++++++++---
 include/uapi/linux/elf.h |  1 +
 2 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 16a56b6b3f6c..55047659a3cf 100644
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
+			if (eppnt->p_flags & PF_X)
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
+			if ((elf_ppnt->p_flags & PF_X))
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


