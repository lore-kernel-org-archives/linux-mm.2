Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE2FDCD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:40:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF0C86B00DF; Wed, 20 May 2026 11:40:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA17B6B00E0; Wed, 20 May 2026 11:40:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8FD96B00E2; Wed, 20 May 2026 11:40:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C393B6B00DF
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:40:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 73D681A037B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:40:20 +0000 (UTC)
X-FDA: 84788209800.10.03AB6AC
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2C3031C0004
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:40:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="ivf/zv7p";
	spf=pass (imf20.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779291618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SmI34slVZs1BNH9m6+m2YOZNt+zp/AB28hIWnnNMMn8=;
	b=ONgZYuBFLPJc4sXoBcmW9QyK55Jf2FyxWJpG5B4K4vYFPNK2T9lWvvryA+t708Mewty7k8
	IqKAZKvRj0TKIzzgQx+fIH7VCD8ub4G6agsl0XHsue1UCVEEYFJaKFM0tOTOX2dJC4T6PB
	Ds/Rh/5Wm3ZrLtxa34dzsUXbtFV1xJA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="ivf/zv7p";
	spf=pass (imf20.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779291618; a=rsa-sha256;
	cv=none;
	b=sjulFmvWOuUFLKA45r/XUlx2rRC+b0Z82TyIHZpCK8QWWr07nVxZaXtnS3eJwq88s/PuOW
	jquQfCnN9tr1rH4IsNr5foMblAHll3XBFpx5EzbErKO0ik8Fuuvos7kp8AqTpZ/EMrxKgo
	vNSyXgLYwQA3bYGRDnR1zLuR2wjO2bc=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64K5E6WX1950620;
	Wed, 20 May 2026 15:40:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=SmI34slVZs1BNH9m6
	+m2YOZNt+zp/AB28hIWnnNMMn8=; b=ivf/zv7p9r5+XWye3TPo1ffSXxg1mU2LK
	uO5P9LJcSb0u7AbNzTbpTZelFvL2/7pU5dRtHbjBtqVyWw7bGcdat24Z6OjgCYFr
	SiEAYoepulLgUs4zbWs1xN5izpGY5X6zHCkU6uzw0zG8hM9qADrcnJK8d4vGXi1c
	urV9laWOvtZC9+a7bNA0iZspIOdZOt5CLqaqNwoukKe35gmUvMYFHZ9Lx+9FC5vf
	rGMo3JclhUZIiZ20ffGWUZggjkKdHyQrz64Svmh15vPZMEBA102eDn4WjIOCtpbS
	xA6UswKmZhmTGRF1wA+Bngd59m1MSy1Oj769DrawaIb5SNL7OCvuQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h88htfs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 15:40:15 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64KFd8U4008385;
	Wed, 20 May 2026 15:40:14 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e739w03b0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 15:40:14 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64KFeBsx21103176
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 May 2026 15:40:11 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DCECB20043;
	Wed, 20 May 2026 15:40:10 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 55B862004E;
	Wed, 20 May 2026 15:40:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 20 May 2026 15:40:10 +0000 (GMT)
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
Subject: [PATCH v15 06/20] unwind_user/sframe: Detect .sframe sections in executables
Date: Wed, 20 May 2026 17:39:50 +0200
Message-ID: <20260520154004.3845823-7-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260520154004.3845823-1-jremus@linux.ibm.com>
References: <20260520154004.3845823-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2ISu0SHUttbv0n9vfydNFpwKXpKjlH2q
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDE1MSBTYWx0ZWRfX7PV/sJz2ww+P
 3/f3BwtqiU3FT5DyPXz/orsUimp1undhsKdq310qkRgje6tdAsY2U4BkqnfSMhIEfWfuov+4rgR
 mo42nz8tcH/qemdVol+DHMPwvoE2yxYwZQqdVUUiQ0jyF4VmLrX8yIPILiNqjKnFPcnpoi836r1
 C7KiJHgX0dhkCMbdGiKnUIYS+AdbqK/rnvOgjhvu4fCZflSXa/UZB8VAq27Vc4j8WsH6nkkgPCx
 VSa6i+/e6LVr/6ZNM2amsTvZDWLUiPJtu7wFw2/a6Hc/qYDrf6QMfLroerbfywNZSIhorssD7W8
 FguGSisAkobDJ6ilrcRLEJ84WkXWPE9RfcH3HmlSBqmiKH6ATBzfN48AgW7/5E+CKQj1qamK3C6
 4O28N/xY7eBGwku9QCDhG3AS6KOFt1puUzFLO3Qy4CPu3BZohjGpl9F0EyjGlq3jRSzj0Goqegi
 0LV1b1g8mjUBWXNVPnw==
X-Proofpoint-GUID: 2ISu0SHUttbv0n9vfydNFpwKXpKjlH2q
X-Authority-Analysis: v=2.4 cv=apyCzyZV c=1 sm=1 tr=0 ts=6a0dd5df cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=eNuN5pRUQDBy6NUwPKcA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 phishscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605200151
X-Stat-Signature: 96g5cci33dcddrymkcpidosbecw8s4ta
X-Rspamd-Queue-Id: 2C3031C0004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779291617-406211
X-HE-Meta: U2FsdGVkX1/jJtu2cZ4NuFfzFHbgRZMSwG478iVc+fCSxWtJe8jivp+h5JIG4H9cIL5EY3APwRQq7W6c+JE4muhmXvciT8EBZ2NIOZ7wbXuIo5yp0kGHidTgXMPGvoFLjFQBcopj5GuTzl3zga3r5XkKb025KAbsOBuMOb7rg+JohPBDcew1P+lIaR3wUmOc0ciZFIkNfrFV3d6ktrT8bSfaP/coBrab0CeDfJPNNU3evyEHMMHhojPeaxxeqmnVSjzlUND7emBN3yLJ+5vf3lBWFBYd0PSHhuczONDl0u8yLfhVRl03IrAAXLJC/gNCEeBBA3OkCmU1CeDeNarMtZqENTEvDmT/m653yADKqMEJleiiHE/t14+QReRU1pnS5pzHG67JYpk2uieMvbAxKxWZjNKv0m1AIFr+LxsBlPEil90FZ8frw8DN7476s4Bh4jGw46S3KQiLCCoY2qB+hC1R+eDLHimTlZL+ikh0OGj4MIj06BlISkaSA1XR9gWNldFLLaRCcWBXyQOLr76vLVEIQN0adzxxlTEYcm4nolCI/OPYhHxvS1R3lYs05l93dcMhmv4tr0FCfEM+KVpaxYWqqgxNH1zOJ23hEjVYRvtuoUPH0AZAHmF55PFPhf6tcbD9bD8eqEflNe6dXNaIKMODIf6GjTW1vLRYJDOR3T6CtG5lZr55QJwp870pCETqfjSoXaRAjxYJwGURyBomb1FmNO3dex9hRb3opWcJ63E8JtNT9tEslKVqypHqyO7G5cWLmKBbcgKid6X6SIt6GTSId2egl0Hetare5iH/PcgTsm8kqOrdggfireifYPg1FHw+1my3BbBQNaHGCj33pdIyw8/hZfP8vyLYZL2Nrz2g+81/53AlSNkPb36duqCMKWxlpp9p1qoIBHWNXkpB/KPJaKMc9FYboc3f4+tfBBu0BZcDc5jVGBv8cOExdNiI2Di3uFAj2rVXKIBUxb3
 Z5fEgaRW
 thTZ2z4ndvXihsqzHVDvrx4hpVdTauV7R4UW35LbBcxF4wDBOXXuqhHV80ron4N+rfqy8Kifxkf0/UPKxoAzuxMP2GhudUz5L/vVqXExhdmmgggKC0+Ol6354+ertCYky92xu2dH7mP6V/WadfJeui9bTTvgpa/eYz2/zX1b5hBo4iyRlnl878xB2s6p2oDGpJ+hgiTvT8MwZol2n6Bx+5sz4l0n/flSMlNPKQ0l2mLLK+JUzc24vzTzo2ST7KQA9cSR9vmB/nWcGcDvmRA1vNmkNxSYuSYj7I7KyhYS3Wfb6nwIxeuPWuzFTP57Vxso20Qy2
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


