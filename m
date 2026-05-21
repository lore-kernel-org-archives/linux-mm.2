Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BA2DCD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:26:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6B5E6B00A0; Thu, 21 May 2026 10:26:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7FEB6B00A1; Thu, 21 May 2026 10:26:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6DC26B00A2; Thu, 21 May 2026 10:26:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8D75D6B00A0
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:26:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4803F120356
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:20 +0000 (UTC)
X-FDA: 84791652120.16.EB90446
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf23.hostedemail.com (Postfix) with ESMTP id EAF2B14000A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="ipeEtmR/";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf23.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779373578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eASCnMgc6rfNC1RznpdZo4UAmVmQlzW6RDQt5jpiuXA=;
	b=h+gTEFaxWdUwmfcRcaaW11SKrN3K/fPkb+ubkAEh3vZTByzz91DkptIzKpB5GN604Jek93
	rQJoLMncmb9FE3mzLUDaRdIqIAfcWfD+mHLtvz54pRREhoXJzMTBgM66wJmLr2+V3l8Rrx
	u9ZzxIVwWr/sI+Bd/vE9muFfjlPxVeg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779373578; a=rsa-sha256;
	cv=none;
	b=wFxnjc/c/L22LbgjWOcwQHprQVP9tSxZ8OXAkosTz9OaDLumA1PR0kxUDQp7SsRW7SEsBb
	je9AmXUdf5zvQw5sib0QG44Yro+QCsQfMfS+dNTss7d0xGMeY7LyjEVxEc8OZVvVlr+Lpo
	AypSE1QET+ncCw+p6fDwpwQGlJkh9ww=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="ipeEtmR/";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf23.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64LBBENk1522114;
	Thu, 21 May 2026 14:25:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=eASCnMgc6rfNC1Rzn
	pdZo4UAmVmQlzW6RDQt5jpiuXA=; b=ipeEtmR/RptD7K9cpddBEnq1hsvP6oKHs
	scnfXENq6v94re16JF34DqqQcw3QeA5h25I6gYHtmUVpmhDOAjMigULYAF0CkXgY
	6yu3BN523cvc3uzHB+WRSCjBhdRTC1C2ldxXQabV0Na+lcEq0DkZ8fEMNdh2el44
	3nTG6vynRPG7Mh6aiSCIWx4ZG2uzH09u+HLxPvaNFfShdESYRQSMgOYLfJHrLBbT
	7PaFNJmRH1THylWM8lElLaDr/+OLAlbkd+0l4BPq594KEqGGRwOMGul7NjgDl/wf
	iChRXEtAjJl9lsUn7pvw99ZouqbyeG/pfRnzPS8uAcHU0Qp2mcQlQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h9y7gr8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:56 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64LEO5c5017107;
	Thu, 21 May 2026 14:25:55 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e73wkcjcn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:55 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64LEPpKU50528532
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 14:25:51 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 34D3320040;
	Thu, 21 May 2026 14:25:51 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BB2E82004D;
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
Subject: [PATCH v16 05/20] unwind_user/sframe: Add support for reading .sframe contents
Date: Thu, 21 May 2026 16:25:31 +0200
Message-ID: <20260521142546.3908498-6-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260521142546.3908498-1-jremus@linux.ibm.com>
References: <20260521142546.3908498-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDE0MiBTYWx0ZWRfXzM9tzVuB9At8
 JIzoeoqz1In+tZuIdL8K03HsFHZAUr8+DJEUnQeolooQJfSfmpqWBjXP76YgolVEMMEUpLSwgSf
 5CaV0FzZ9UsQG4SlTGncvMQsYjQ1kOVrR8Fk/s9M6aCuW4NwIRq5hEpz9GLRyZP7trHu6fqmj5w
 aqT4nPHHbGVXrtE6wpHGC5KIUbW9ZbBoOKDg4faSbXMZhCaliuXNGCjMM57Z4Wn3TYCkarZTanT
 +cts1qoNVaSDLngkqGzatYV2RF2pURuhqoTte8vfLT2cb5TJ8UXN+68b7UOnk+qtof04CozwHYk
 sC8bOUXwKcC0aI01dUEHq0xy/wsnckYW5NmswCWQVG1omRFL8b1x/jHfgiHJHmCu6IiMoBoG012
 MVYxj8sbHpOS/DTkgUpvBYjtCzjNEXmq8RpAqr4R2Cy21J9jO1jbYQ1khTFwWBXnnviMQI0pfXq
 Xq3illrKAvQIU2GLl1g==
X-Authority-Analysis: v=2.4 cv=BNuDalQG c=1 sm=1 tr=0 ts=6a0f15f5 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=meVymXHHAAAA:8
 a=pGLkceISAAAA:8 a=YuDcBBqGAAAA:8 a=eEjjhumUK4yHDpHCs10A:9
 a=2JgSa4NbpEOStq-L5dxp:22 a=V9_jqlfyBUA7Gw2gN5zN:22
X-Proofpoint-ORIG-GUID: yAzelrH9X6qqcMbuAY6v4ZUAkj6Y5qCQ
X-Proofpoint-GUID: B5tVsh0kPgJpsXxGGJXnLp27nY_bG9iY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210142
X-Rspam-User: 
X-Rspamd-Queue-Id: EAF2B14000A
X-Rspamd-Server: rspam04
X-Stat-Signature: 453cgk78h6qqqgn167s55yinxuunracg
X-HE-Tag: 1779373577-198724
X-HE-Meta: U2FsdGVkX18/FASDxcvXqndp09/qLv8a0MGHCLHg6rErcqkn3m5pNAgev71u7tOjkw82QNUeK+v0QVeHPeiZT86Ohv9WY0Rx5iCSiIxkqFV8f4Et83UPzkA7Bh+agawYDKBGQDJyLdXCl1SkQOWX9yQQw3zKhpN7Y6qxQ6uXT5Uj7jq+HyM0MtS9xaEprx+fCz0Cf44MnfqcUaQfK1BfKjr8obR9QUFd/rLaPtAtahA+W9U1kaw2F7qFpLRnN83a8wXspxV1ctT59DCZmADArs1dk5ktLI2ecHFWwfPreKj6fgKWeAbX+GbIrB7b4H5FuvLoPDF8DDr2eIiwN753i45eKf7qSveTMIewgE7J5TWx/Yp3zaR6TnCCJTkOoSXF6h1auptqxaFCkMIeWLIr+CFctWkkzCvppaFbClk4Vp2ehfsztLxsaM4wM/9ddTMKoaZNx2tXyQ520zWTfIYtQDeS+MWzmaeeIzBCYAtqlL+t1BOTY5TRRi5FtqzMHebPAxApNAovuyo7wY9sZ7ylARVyVvhidX03o47au3Uwrbehc8CaRQ5Vo1fIikBncbVrChcM1un6fm0NiJmbLrYg5+DwitCSU1r7eOMcaRopLNyJBIZtYKQVcJw4eYDKUosAPhLEtT6yjKtXvLSEw22VkflabHmv/yuOhiRXK9MSm3xAo2xjnx3ZEhg/Dbd2WRTufWq/uEw9J7RNpKq/BDU+rj2nFjhjCMOlJIp442u8SBa4aSoxFY6i4wYNoochNwrfytDdyG9fdITMKeZ41tt2xTax60sm6IE0ShoswIZ+tcEZ4JEzysriztmdX6qeLSm+owVnHXb6xvW/gDd3OAB/PQdmWfiNFwdpEFh47ZJ+a23xtsAnubdsULiJy/PksBRwy9JlnXbkW7+QFbs3a+LYEIQmRcNgzVxCeMFqM5KbipNuYvoc8A0V6bC9ficMeEW8OIQ4c8chYu+nK7HIbYf
 PGFFvElJ
 Q7DmtXZvxcOEfCH0AJSemgJOrVt4yLxCokyCklrV1YIIEAp3oHSatVZhCN3WSuEs9Ye1K/1w/zwgEbm4IvVRcuLDNW0V+Qbhbw0MlnMohLiyAO/+NXjDdYXabsbAYLNQ0+ojViZdMKURZ8XEC2flJrArXLvq2tBeM52tizcimQgXUHp7qe1SC+4hoHSr87hPqAh4q+sNWzhNPDoGCNd0yFldDXxm9i09AxFKPOUHz1xdF2UEtpS94KWphDwngLTc3HZ3ARbjEjcOmvQTzTRydHhFjaiM5U0dCxv/a6igMMQCUFoxVzAPLAGOTKJiozaqYR7BYW00ZsUHEOb/nyGW3LIy/iHdOr6GqCmqHo8FHbNja/5ho/2VGCcOIdgQ2HBi5nHHiSXSk8383baVgYjm4h+Il+hNEgaV5lZ0n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

In preparation for using sframe to unwind user space stacks, add an
sframe_find() interface for finding the sframe information associated
with a given text address.

For performance, use user_read_access_begin() and the corresponding
unsafe_*() accessors.  Note that use of pr_debug() in uaccess-enabled
regions would break noinstr validation, so there aren't any debug
messages yet.  That will be added in a subsequent commit.

Link: https://lore.kernel.org/all/77c0d1ec143bf2a53d66c4ecb190e7e0a576fbfd.1737511963.git.jpoimboe@kernel.org/
Link: https://lore.kernel.org/all/b35ca3a3-8de5-4d32-8d30-d4e562f6b0de@linux.ibm.com/

[ Jens Remus: Add initial support for SFrame V3 (limited to default
FDEs).  Add support for PC-relative FDE function start offset.  Simplify
logic by using an internal FDE representation.  Rename struct sframe_fre
to sframe_fre_internal to align with struct sframe_fde_internal.
Cleanup includes.  Fix checkpatch errors "spaces required around that
':'". ]

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Indu Bhagat <ibhagatgnu@gmail.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    Changes in v16:
    - __read_fre(): Compute FRE size before mutating dataword_count.
      (Sashiko AI)
    - __read_fre(): Convert user read access to scope-based cleanup.
      (Sashiko AI)
    - Move SRCU definitions to patch "unwind_user/sframe: Store .sframe
      section data in per-mm maple tree". (Sashiko AI)
    
    Changes in v15:
    - __read_fde():
      - Validate FDE repetition size for PCTYPE_MASK FDEs to be non-zero to
        prevent division by zero. (Sashiko AI)
      - Validate FDE PC type for supported values (i.e. PCTYPE_INC or
        PCTYPE_MASK).
      - Validate FDE function end against text end.
      - Validate FDE's number of FREs to be less or equal to FDE's function
        size, as each FRE must cover at least one byte. (Indu)
    - __read_fre(): Validate FRE function offset against FDE repetition size
      for PCTYPE_MASK.
    - Change type of struct sframe_fde_internal field fres_num to the one of
      struct sframe_fda_v3 field fres_num.
    - Normalize error code usage (.sframe is removed for all but ENOENT):
      ENOENT: No sframe or no FDE for IP found
              (FDE found but no FRE found is EINVAL)
      EFAULT: Bad address
      EINVAL: Invalid input or sframe
    - Build-time checks for config options:
      - 64BIT: SFrame V3 only supports 64-bit architectures.
      - HAVE_EFFICIENT_UNALIGNED_ACCESS: Unaligned access to 16/32-bit
        SFrame FRE fields and datawords using unsafe_get_user(). (Steven)
    - Reword my changelog in commit message.
    
    Changes in v14:
    - Fix FDE function start address check in __read_fde().
    - Adjust to rename of SFRAME_FDE_TYPE_*.
    
    Changes in v13:
    - Update to SFrame V3:
      - Adjust to SFRAME_V3_*() macros and macro/define renames.
      - Adjust to struct sframe_fde_v3 rename.
      - Adjust to s64 FDE function start offset.
      - Rename local variables fde_type to fde_pctype.
      - Add and maintain struct sframe_fde_internal field u8 info2.
      - Adjust to FDE split into function descriptor entry
        (struct sframe_fde_v3) and attributes (struct sframe_fde_v3).
      - Rename offset_count/offset_size to dataword_count/dataword_count.
      - Limit __read_fre() to SFrame V3 regular FDEs (FDE_TYPE_REGULAR).  A
        subsequent patch will add support for flexible FDEs (FDE_TYPE_FLEX).
    - Rename struct sframe_fde_internal field func_start_addr to func_addr.
    - Add support u64/s64 in UNSAFE_GET_USER_INC() for s64 FDE function
      start offset.
    - Reduce indentation of assignments to fre.
    - Reword commit message (my changes).

 include/linux/sframe.h       |   3 +
 kernel/unwind/sframe.c       | 362 ++++++++++++++++++++++++++++++++++-
 kernel/unwind/sframe_debug.h |  35 ++++
 3 files changed, 396 insertions(+), 4 deletions(-)
 create mode 100644 kernel/unwind/sframe_debug.h

diff --git a/include/linux/sframe.h b/include/linux/sframe.h
index 38047760e252..9a72209696f9 100644
--- a/include/linux/sframe.h
+++ b/include/linux/sframe.h
@@ -4,6 +4,7 @@
 
 #include <linux/mm_types.h>
 #include <linux/srcu.h>
+#include <linux/unwind_user_types.h>
 
 #ifdef CONFIG_HAVE_UNWIND_USER_SFRAME
 
@@ -30,6 +31,7 @@ extern void sframe_free_mm(struct mm_struct *mm);
 extern int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 			      unsigned long text_start, unsigned long text_end);
 extern int sframe_remove_section(unsigned long sframe_addr);
+extern int sframe_find(unsigned long ip, struct unwind_user_frame *frame);
 
 static inline bool current_has_sframe(void)
 {
@@ -48,6 +50,7 @@ static inline int sframe_add_section(unsigned long sframe_start, unsigned long s
 	return -ENOSYS;
 }
 static inline int sframe_remove_section(unsigned long sframe_addr) { return -ENOSYS; }
+static inline int sframe_find(unsigned long ip, struct unwind_user_frame *frame) { return -ENOSYS; }
 static inline bool current_has_sframe(void) { return false; }
 
 #endif /* CONFIG_HAVE_UNWIND_USER_SFRAME */
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index 46dba3cb016d..2de29c836f6b 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -15,12 +15,355 @@
 #include <linux/unwind_user_types.h>
 
 #include "sframe.h"
-
-#define dbg(fmt, ...)							\
-	pr_debug("%s (%d): " fmt, current->comm, current->pid, ##__VA_ARGS__)
+#include "sframe_debug.h"
+
+struct sframe_fde_internal {
+	unsigned long	func_addr;
+	u32		func_size;
+	u32		fda_off;
+	u32		fres_off;
+	u16		fres_num;
+	u8		info;
+	u8		info2;
+	u8		rep_size;
+};
+
+struct sframe_fre_internal {
+	unsigned int	size;
+	u32		ip_off;
+	s32		cfa_off;
+	s32		ra_off;
+	s32		fp_off;
+	u8		info;
+};
 
 DEFINE_STATIC_SRCU(sframe_srcu);
 
+static __always_inline unsigned char fre_type_to_size(unsigned char fre_type)
+{
+	if (fre_type > 2)
+		return 0;
+	return 1 << fre_type;
+}
+
+static __always_inline unsigned char dataword_size_enum_to_size(unsigned char dataword_size)
+{
+	if (dataword_size > 2)
+		return 0;
+	return 1 << dataword_size;
+}
+
+static __always_inline int __read_fde(struct sframe_section *sec,
+				      unsigned int fde_num,
+				      struct sframe_fde_internal *fde)
+{
+	unsigned long fde_addr, fda_addr, func_start, func_end;
+	struct sframe_fde_v3 _fde;
+	struct sframe_fda_v3 _fda;
+	unsigned char fde_pctype;
+
+	fde_addr = sec->fdes_start + (fde_num * sizeof(struct sframe_fde_v3));
+	unsafe_copy_from_user(&_fde, (void __user *)fde_addr,
+			      sizeof(struct sframe_fde_v3), Efault);
+
+	func_start = fde_addr + _fde.func_start_off;
+	func_end = func_start + _fde.func_size;
+	if (func_start < sec->text_start || func_end > sec->text_end)
+		return -EFAULT;
+
+	fda_addr = sec->fres_start + _fde.fres_off;
+	if (fda_addr + sizeof(struct sframe_fda_v3) > sec->fres_end)
+		return -EFAULT;
+	unsafe_copy_from_user(&_fda, (void __user *)fda_addr,
+			      sizeof(struct sframe_fda_v3), Efault);
+
+	fde_pctype = SFRAME_V3_FDE_PCTYPE(_fda.info);
+	if (fde_pctype != SFRAME_FDE_PCTYPE_INC &&
+	    fde_pctype != SFRAME_FDE_PCTYPE_MASK)
+		return -EINVAL;
+	if (fde_pctype == SFRAME_FDE_PCTYPE_MASK && !_fda.rep_size)
+		return -EINVAL;
+	if (_fda.fres_num > _fde.func_size)
+		return -EINVAL;
+
+	fde->func_addr	= func_start;
+	fde->func_size	= _fde.func_size;
+	fde->fda_off	= _fde.fres_off;
+	fde->fres_off	= _fde.fres_off + sizeof(struct sframe_fda_v3);
+	fde->fres_num	= _fda.fres_num;
+	fde->info	= _fda.info;
+	fde->info2	= _fda.info2;
+	fde->rep_size	= _fda.rep_size;
+
+	return 0;
+
+Efault:
+	return -EFAULT;
+}
+
+static __always_inline int __find_fde(struct sframe_section *sec,
+				      unsigned long ip,
+				      struct sframe_fde_internal *fde)
+{
+	unsigned long func_addr_low = 0, func_addr_high = ULONG_MAX;
+	struct sframe_fde_v3 __user *first, *low, *high, *found = NULL;
+	int ret;
+
+	first = (void __user *)sec->fdes_start;
+	low = first;
+	high = first + sec->num_fdes - 1;
+
+	while (low <= high) {
+		struct sframe_fde_v3 __user *mid;
+		s64 func_off;
+		unsigned long func_addr;
+
+		mid = low + ((high - low) / 2);
+
+		unsafe_get_user(func_off, (s64 __user *)mid, Efault);
+		func_addr = (unsigned long)mid + func_off;
+
+		if (ip >= func_addr) {
+			if (func_addr < func_addr_low)
+				return -EINVAL;
+
+			func_addr_low = func_addr;
+
+			found = mid;
+			low = mid + 1;
+		} else {
+			if (func_addr > func_addr_high)
+				return -EINVAL;
+
+			func_addr_high = func_addr;
+
+			high = mid - 1;
+		}
+	}
+
+	if (!found)
+		return -ENOENT;
+
+	ret = __read_fde(sec, found - first, fde);
+	if (ret)
+		return ret;
+
+	/* make sure it's not in a gap */
+	if (ip < fde->func_addr || ip >= fde->func_addr + fde->func_size)
+		return -ENOENT;
+
+	return 0;
+
+Efault:
+	return -EFAULT;
+}
+
+#define ____UNSAFE_GET_USER_INC(to, from, type, label)			\
+({									\
+	type __to;							\
+	unsafe_get_user(__to, (type __user *)from, label);		\
+	from += sizeof(__to);						\
+	to = __to;							\
+})
+
+#define __UNSAFE_GET_USER_INC(to, from, size, label, u_or_s)		\
+({									\
+	switch (size) {							\
+	case 1:								\
+		____UNSAFE_GET_USER_INC(to, from, u_or_s##8, label);	\
+		break;							\
+	case 2:								\
+		____UNSAFE_GET_USER_INC(to, from, u_or_s##16, label);	\
+		break;							\
+	case 4:								\
+		____UNSAFE_GET_USER_INC(to, from, u_or_s##32, label);	\
+		break;							\
+	default:							\
+		return -EFAULT;						\
+	}								\
+})
+
+#define UNSAFE_GET_USER_UNSIGNED_INC(to, from, size, label)		\
+	__UNSAFE_GET_USER_INC(to, from, size, label, u)
+
+#define UNSAFE_GET_USER_SIGNED_INC(to, from, size, label)		\
+	__UNSAFE_GET_USER_INC(to, from, size, label, s)
+
+#define UNSAFE_GET_USER_INC(to, from, size, label)				\
+	_Generic(to,								\
+		 u8 :	UNSAFE_GET_USER_UNSIGNED_INC(to, from, size, label),	\
+		 u16 :	UNSAFE_GET_USER_UNSIGNED_INC(to, from, size, label),	\
+		 u32 :	UNSAFE_GET_USER_UNSIGNED_INC(to, from, size, label),	\
+		 u64 :	UNSAFE_GET_USER_UNSIGNED_INC(to, from, size, label),	\
+		 s8 :	UNSAFE_GET_USER_SIGNED_INC(to, from, size, label),	\
+		 s16 :	UNSAFE_GET_USER_SIGNED_INC(to, from, size, label),	\
+		 s32 :	UNSAFE_GET_USER_SIGNED_INC(to, from, size, label),	\
+		 s64 :	UNSAFE_GET_USER_SIGNED_INC(to, from, size, label))
+
+static __always_inline int __read_fre(struct sframe_section *sec,
+				      struct sframe_fde_internal *fde,
+				      unsigned long fre_addr,
+				      struct sframe_fre_internal *fre)
+{
+	unsigned char fde_type = SFRAME_V3_FDE_TYPE(fde->info2);
+	unsigned char fde_pctype = SFRAME_V3_FDE_PCTYPE(fde->info);
+	unsigned char fre_type = SFRAME_V3_FDE_FRE_TYPE(fde->info);
+	unsigned char dataword_count, dataword_size;
+	s32 cfa_off, ra_off, fp_off;
+	unsigned long cur = fre_addr;
+	unsigned char addr_size;
+	unsigned int fre_size;
+	u32 ip_off;
+	u8 info;
+
+	addr_size = fre_type_to_size(fre_type);
+	if (!addr_size)
+		return -EINVAL;
+
+	if (fre_addr + addr_size + 1 > sec->fres_end)
+		return -EFAULT;
+
+	UNSAFE_GET_USER_INC(ip_off, cur, addr_size, Efault);
+	if ((fde_pctype == SFRAME_FDE_PCTYPE_INC && ip_off >= fde->func_size) ||
+	    (fde_pctype == SFRAME_FDE_PCTYPE_MASK && ip_off >= fde->rep_size))
+		return -EINVAL;
+
+	UNSAFE_GET_USER_INC(info, cur, 1, Efault);
+	dataword_count = SFRAME_V3_FRE_DATAWORD_COUNT(info);
+	dataword_size  = dataword_size_enum_to_size(SFRAME_V3_FRE_DATAWORD_SIZE(info));
+	if (!dataword_count || !dataword_size)
+		return -EINVAL;
+	fre_size = addr_size + 1 + (dataword_count * dataword_size);
+
+	if (cur + (dataword_count * dataword_size) > sec->fres_end)
+		return -EFAULT;
+
+	/* TODO: Support for flexible FDEs not implemented yet. */
+	if (fde_type != SFRAME_FDE_TYPE_DEFAULT)
+		return -EINVAL;
+
+	UNSAFE_GET_USER_INC(cfa_off, cur, dataword_size, Efault);
+	dataword_count--;
+
+	ra_off = sec->ra_off;
+	if (!ra_off) {
+		if (!dataword_count--)
+			return -EINVAL;
+
+		UNSAFE_GET_USER_INC(ra_off, cur, dataword_size, Efault);
+	}
+
+	fp_off = sec->fp_off;
+	if (!fp_off && dataword_count) {
+		dataword_count--;
+		UNSAFE_GET_USER_INC(fp_off, cur, dataword_size, Efault);
+	}
+
+	if (dataword_count)
+		return -EINVAL;
+
+	fre->size	= fre_size;
+	fre->ip_off	= ip_off;
+	fre->cfa_off	= cfa_off;
+	fre->ra_off	= ra_off;
+	fre->fp_off	= fp_off;
+	fre->info	= info;
+
+	return 0;
+
+Efault:
+	return -EFAULT;
+}
+
+static __always_inline int __find_fre(struct sframe_section *sec,
+				      struct sframe_fde_internal *fde,
+				      unsigned long ip,
+				      struct unwind_user_frame *frame)
+{
+	unsigned char fde_pctype = SFRAME_V3_FDE_PCTYPE(fde->info);
+	struct sframe_fre_internal *fre, *prev_fre = NULL;
+	struct sframe_fre_internal fres[2];
+	unsigned long fre_addr;
+	bool which = false;
+	unsigned int i;
+	u32 ip_off;
+
+	ip_off = ip - fde->func_addr;
+
+	if (fde_pctype == SFRAME_FDE_PCTYPE_MASK)
+		ip_off %= fde->rep_size;
+
+	fre_addr = sec->fres_start + fde->fres_off;
+
+	for (i = 0; i < fde->fres_num; i++) {
+		int ret;
+
+		/*
+		 * Alternate between the two fre_addr[] entries for 'fre' and
+		 * 'prev_fre'.
+		 */
+		fre = which ? fres : fres + 1;
+		which = !which;
+
+		ret = __read_fre(sec, fde, fre_addr, fre);
+		if (ret)
+			return ret;
+
+		fre_addr += fre->size;
+
+		if (prev_fre && fre->ip_off <= prev_fre->ip_off)
+			return -EINVAL;
+
+		if (fre->ip_off > ip_off)
+			break;
+
+		prev_fre = fre;
+	}
+
+	if (!prev_fre)
+		return -EINVAL;
+	fre = prev_fre;
+
+	frame->cfa_off = fre->cfa_off;
+	frame->ra_off  = fre->ra_off;
+	frame->fp_off  = fre->fp_off;
+	frame->use_fp  = SFRAME_V3_FRE_CFA_BASE_REG_ID(fre->info) == SFRAME_BASE_REG_FP;
+
+	return 0;
+}
+
+int sframe_find(unsigned long ip, struct unwind_user_frame *frame)
+{
+	struct mm_struct *mm = current->mm;
+	struct sframe_section *sec;
+	struct sframe_fde_internal fde;
+	void __user *sframe_start;
+	int ret;
+
+	if (!mm)
+		return -EINVAL;
+
+	guard(srcu)(&sframe_srcu);
+
+	sec = mtree_load(&mm->sframe_mt, ip);
+	if (!sec)
+		return -ENOENT;
+
+	sframe_start = (void __user *)sec->sframe_start;
+	scoped_user_read_access_size(sframe_start,
+				     sec->sframe_end - sec->sframe_start,
+				     Efault) {
+		ret = __find_fde(sec, ip, &fde);
+		if (!ret)
+			ret = __find_fre(sec, &fde, ip, frame);
+	}
+
+	return ret;
+
+Efault:
+	return -EFAULT;
+}
+
 static void free_section(struct sframe_section *sec)
 {
 	kfree(sec);
@@ -32,6 +375,15 @@ static int sframe_read_header(struct sframe_section *sec)
 	struct sframe_header shdr;
 	unsigned int num_fdes;
 
+	/* SFrame V3 is only supported on 64-bit architectures */
+	BUILD_BUG_ON(!IS_ENABLED(CONFIG_64BIT));
+
+	/*
+	 * Unaligned access to 16/32-bit SFrame FRE fields and datawords
+	 * using unsafe_get_user() via UNSAFE_GET_USER_INC()
+	 */
+	BUILD_BUG_ON(!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS));
+
 	if (copy_from_user(&shdr, (void __user *)sec->sframe_start, sizeof(shdr))) {
 		dbg("header usercopy failed\n");
 		return -EFAULT;
@@ -122,8 +474,10 @@ int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 	sec->text_end		= text_end;
 
 	ret = sframe_read_header(sec);
-	if (ret)
+	if (ret) {
+		dbg_print_header(sec);
 		goto err_free;
+	}
 
 	ret = mtree_insert_range(sframe_mt, sec->text_start, sec->text_end - 1,
 				 sec, GFP_KERNEL_ACCOUNT);
diff --git a/kernel/unwind/sframe_debug.h b/kernel/unwind/sframe_debug.h
new file mode 100644
index 000000000000..36352124cde8
--- /dev/null
+++ b/kernel/unwind/sframe_debug.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _SFRAME_DEBUG_H
+#define _SFRAME_DEBUG_H
+
+#include <linux/sframe.h>
+#include "sframe.h"
+
+#ifdef CONFIG_DYNAMIC_DEBUG
+
+#define dbg(fmt, ...)							\
+	pr_debug("%s (%d): " fmt, current->comm, current->pid, ##__VA_ARGS__)
+
+static __always_inline void dbg_print_header(struct sframe_section *sec)
+{
+	unsigned long fdes_end;
+
+	fdes_end = sec->fdes_start + (sec->num_fdes * sizeof(struct sframe_fde_v3));
+
+	dbg("SEC: sframe:0x%lx-0x%lx text:0x%lx-0x%lx "
+	    "fdes:0x%lx-0x%lx fres:0x%lx-0x%lx "
+	    "ra_off:%d fp_off:%d\n",
+	    sec->sframe_start, sec->sframe_end, sec->text_start, sec->text_end,
+	    sec->fdes_start, fdes_end, sec->fres_start, sec->fres_end,
+	    sec->ra_off, sec->fp_off);
+}
+
+#else /* !CONFIG_DYNAMIC_DEBUG */
+
+#define dbg(args...)			no_printk(args)
+
+static inline void dbg_print_header(struct sframe_section *sec) {}
+
+#endif /* !CONFIG_DYNAMIC_DEBUG */
+
+#endif /* _SFRAME_DEBUG_H */
-- 
2.51.0


