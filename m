Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37FB5CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:26:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 328DC6B0096; Thu, 21 May 2026 10:26:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31B0B6B009D; Thu, 21 May 2026 10:26:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11FD06B0099; Thu, 21 May 2026 10:26:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F41B06B0096
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:26:17 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B2E7D140663
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:17 +0000 (UTC)
X-FDA: 84791651994.12.4C220EF
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6A31F100015
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=HAJHkPnQ;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf05.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779373575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9+eu9KzFa/Mwxg1rA2DGgUyHvjGhvtpbE7NFlm9DmI8=;
	b=rD9M2i1uSshOhH3yyYb7TPSK5ogOZXIZMY3c6hhbUCAlwYdp/Eabbmr3AiUx2wzOvV3S0E
	Wa4cNcHJFvFISSoFq6FmgBknyXtMdSmI7QbTRXLtLL4ikfs+7E11FPeBzqWM7JUvJUwwPU
	lWa4zyvVH6VALxLjsH/9jiNPZvWLkJM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779373575; a=rsa-sha256;
	cv=none;
	b=M0nc+S4RwCvTC2EI0HyMNqyik5xqe/qssQwTYCYkp45YGvona7kNJh4qdxzOqaO8RE/4V5
	5CF0uvk5p6GeBMvxt1CFkp4z8n3KJ+yHQrhNwvK3rOTupt9ccEhoJ574vROsGw/79zkOMe
	sJBp3EiZfVsJ3LmBJ6AKMwjcbcpou0I=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=HAJHkPnQ;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf05.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64L0PXHV843724;
	Thu, 21 May 2026 14:25:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=9+eu9KzFa/Mwxg1rA
	2DGgUyHvjGhvtpbE7NFlm9DmI8=; b=HAJHkPnQQtCMbJLV5PFiwjGe+d3aeds+4
	kG52XRu2jmTUIarlMntXCY2PJc20syYggBBXg0da31wy52SX23lIpfFEjoCMLIVB
	ARs04yeWzgTK7rFj1c9HULxBgGRpXqhu0Svsb9ZoCejEqb6S66JiVSiPr3gUYgXG
	m/4jdi5SVIBCygsx0RZQoKghf6Uee+7UFFsIbOUaS3fkreKdeKUYuKQBcZd1+4yV
	pvIqnD1xh9xw5Lzxs2eEzzY+Ear/lYEEOPmMLWHf/8aRpI/h4ecI/fGaOc3cWz62
	u+h9gIgefiNUa9SWliOiRL2SGc7UIGXeguLay8lbrnGJkWFQZ6AfA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h9y7gqx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:54 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64LEOF4Y001794;
	Thu, 21 May 2026 14:25:53 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e72wqcssu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:53 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64LEPoHr27722138
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 14:25:50 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5783C20040;
	Thu, 21 May 2026 14:25:50 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EB4812004B;
	Thu, 21 May 2026 14:25:49 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 14:25:49 +0000 (GMT)
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
Subject: [PATCH v16 03/20] unwind_user/sframe: Store .sframe section data in per-mm maple tree
Date: Thu, 21 May 2026 16:25:29 +0200
Message-ID: <20260521142546.3908498-4-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260521142546.3908498-1-jremus@linux.ibm.com>
References: <20260521142546.3908498-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDE0MiBTYWx0ZWRfXy2kGxoTWZUbO
 a78ioVhmxv/1Lm6FHJOueC62PP3+MWmHHI1LNaxZaU1/sMIILjZAjT69q9xw97AE2rPM35YbPd4
 gaK+i8KjVGnA/DPvNwGk+9FdMTSBXevGhIUvhYRsQNS8wgCotPd/44FysqH0kuiC4C+Vjg0ulxI
 zIElyF56mFunOuO/U27DsVUEZosxGszceqVawJx0IMF1dQIxz1dvcR+0Hn5LLGSP/41LYjj/0xg
 S1bV8ARPvlSJnTdhhtsn4CyuXl0msuJ4YqYJGE4jrc7yqpEC4hw5PrNSAho48BkePXOePCl1hA8
 3LRvXLOCoFH5xXpe3oeZD1vekiI5wZXmjnF8D8YL20ufSL/KuqGLZeu4Sh8oWenjIzAYGDeYcD2
 +nDEf4Mc+cglk6Rwg2HG8p0AlTbysoCwVlDnn9ssvY+FylxYzH7blxHVIDkZtGmCZIEcNCyr+XL
 ZVrW1XNiY0DrdGoMgJA==
X-Authority-Analysis: v=2.4 cv=BNuDalQG c=1 sm=1 tr=0 ts=6a0f15f3 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=kG-nbKyDqmrV4dykLI8A:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-ORIG-GUID: Yj0LaF0FkTic88FYSwchjc-y2t1JuMc4
X-Proofpoint-GUID: quXsH3SVjBwEiRlwOCP6xl2xWRlzy7vU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210142
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6A31F100015
X-Stat-Signature: eznwijyu7brjjub57mswyibci7s5m7ew
X-Rspam-User: 
X-HE-Tag: 1779373575-665475
X-HE-Meta: U2FsdGVkX1/G6jjo70BnYP0kSxYqGTgJ9Wg0GY9WVF+lauYjw3UWLJe+cGgX//DvqbRBxscZyVPkKowQfGs0l4RRTWnSKob8Ikw8rFfeZCtVe59MTkHhYMM9szj6MWes4QL6lwDuGuMdxFLmDYWio0aeCxSUlPiQigtgHKhvAIURmsTOw7+e8f0ARvkGsPfMz2PQeR1Ed4mIqZEtHDP9CNYY5KEl27RbRj9lnH+sqIZilCUHBPnLLEd3/eork7d8r6SaHPiA/bNAIFOktn9k5m7PzT8F1rX8yWAF4xAbQFGZ3DnJ4TOpesi0l4DgkAOl/wxeYFse6oaXHKOrJza7s0y5cksUKDSkIxXR3lOnERwLlZcH6fbA2M2oNlUeqUX3NYepLiLQ1454oti83oLFZkvUpTiINoxTqqkt0ZdXyyokZRzm/uFrvUYuvCDMgwWDsU+jd7Qgc1DMGRpBjWWjGMY3b2WYtoHljS5DkEiovq78dLf6695OH2waXqXs5NdNtEhWS1RDZSz/WIZn6kPNNeghGGUm5BhdT+h9cuthndjEw+3rhlKN/U53mCHY7TyL0AIJzDhvfKkoFwAOCH/G5VYz/Xep8GVrcyoBAFmzPjmjh3NyHTPyFlM5vE2VKdr8DgpjWD03ehjt6+yHh536SsoIirnPaw4H3vtFs+tJJOnnPtBK7E0PVe/9gUgq3hgwm5INXMMOwR80iWju5z6130K+s00bhP8f5un7v7MXRS0DOHlvVd7oeHIzG+hegJ4+ujTXmd2PsTearyaQJ1Bm+sDNpyTlG2yoINKBH35h/atvrA5rQ20219bcqKByyxtbsNI1YRagXzaHVLG+IbqN3hbMNJR1ndf2TPDwrnXTdc4MvYu6ZT3XLm8fxf5P1kEBKmGPs6igI1ExbfmwAhc1yWhKkJIhVaRmYYAPPIrZDtB3Rwtthang/aG0Kq++KeS5/nRm0g099N7Mvo3nO9Z
 QH/GSl8n
 znty3xgC/kidoYGoC+IhomsBoAkvWqP5pu6Hj8CNnni++Jh7kiX7vGlpImARzck3+WS994xX1Qik1LLewb21wy9OncwJvJgBQC+laA9vQXJidgVjzvshGGR7UEshbA+dBySdmYLdC5+FjhfooUG7PaFnIl4pgaOSylmqmcB5Uv3yCp4wBnNTxqY2XOmgoLMX/IovQiz6JM4KqAlS/mVGo/JdqQ/AVB1+zHgsJYy7DitpKT+LZbEQ6gRytla+P+GTYleImWfQJO8uLF92c/T7SxYA1Y7/Z9PPb5A5vYEiJgN2xIK1FCa2lCVt+/XiSlqQdP+ZFEv9NR0bGR78obV5CJuDWlxzRbrsecarM4haxEy0XLLE6dYHX11DBbZeaTq2S3Xr0e9PkTdbYBkjU6Eq2L0aEET4krzZdSrlwgD+7TDmqRu+Wgrpll1uI1M9m2V6JIkpI5AtO6r3gTmM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

Associate an .sframe section with its mm by adding it to a per-mm maple
tree which is indexed by the corresponding text address range.  A single
.sframe section can be associated with multiple text ranges.

[ Jens Remus: Minor cleanups. Reword commit subject/message. ]

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Indu Bhagat <ibhagatgnu@gmail.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    Changes in v16:
    - Move SRCU definitions from patch "unwind_user/sframe: Add support for
      reading .sframe contents" here. (Sashiko AI)
    
    Changes in v15:
    - Fix text section end passed to mtree_insert_range() to be inclusive.
      (Sashiko AI)
    - sframe_remove_section(): Add guard(srcu) to guard access to
      sec->sframe_start.  This also guards access to sec->filename
      in __sframe_remove_section(). (Sashiko AI)
    - Use GFP_KERNEL_ACCOUNT instead of GFP_KERNEL (see
      memory-allocation.rst, section "Get Free Page flags"). (Sashiko AI)

 arch/x86/include/asm/mmu.h |  2 +-
 include/linux/mm_types.h   |  3 ++
 include/linux/sframe.h     | 18 ++++++++++
 kernel/fork.c              | 10 ++++++
 kernel/unwind/sframe.c     | 68 ++++++++++++++++++++++++++++++++++++--
 mm/init-mm.c               |  2 ++
 6 files changed, 99 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/mmu.h b/arch/x86/include/asm/mmu.h
index 0fe9c569d171..227a32899a59 100644
--- a/arch/x86/include/asm/mmu.h
+++ b/arch/x86/include/asm/mmu.h
@@ -87,7 +87,7 @@ typedef struct {
 	.context = {							\
 		.ctx_id = 1,						\
 		.lock = __MUTEX_INITIALIZER(mm.context.lock),		\
-	}
+	},
 
 void leave_mm(void);
 #define leave_mm leave_mm
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index a308e2c23b82..c1505356b6fc 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1424,6 +1424,9 @@ struct mm_struct {
 #ifdef CONFIG_MM_ID
 		mm_id_t mm_id;
 #endif /* CONFIG_MM_ID */
+#ifdef CONFIG_HAVE_UNWIND_USER_SFRAME
+		struct maple_tree sframe_mt;
+#endif
 	} __randomize_layout;
 
 	/*
diff --git a/include/linux/sframe.h b/include/linux/sframe.h
index 0642595534f9..38047760e252 100644
--- a/include/linux/sframe.h
+++ b/include/linux/sframe.h
@@ -2,9 +2,14 @@
 #ifndef _LINUX_SFRAME_H
 #define _LINUX_SFRAME_H
 
+#include <linux/mm_types.h>
+#include <linux/srcu.h>
+
 #ifdef CONFIG_HAVE_UNWIND_USER_SFRAME
 
 struct sframe_section {
+	struct rcu_head	rcu;
+
 	unsigned long	sframe_start;
 	unsigned long	sframe_end;
 	unsigned long	text_start;
@@ -19,18 +24,31 @@ struct sframe_section {
 	signed char	fp_off;
 };
 
+#define INIT_MM_SFRAME .sframe_mt = MTREE_INIT(sframe_mt, 0),
+extern void sframe_free_mm(struct mm_struct *mm);
+
 extern int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 			      unsigned long text_start, unsigned long text_end);
 extern int sframe_remove_section(unsigned long sframe_addr);
 
+static inline bool current_has_sframe(void)
+{
+	struct mm_struct *mm = current->mm;
+
+	return mm && !mtree_empty(&mm->sframe_mt);
+}
+
 #else /* !CONFIG_HAVE_UNWIND_USER_SFRAME */
 
+#define INIT_MM_SFRAME
+static inline void sframe_free_mm(struct mm_struct *mm) {}
 static inline int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 				     unsigned long text_start, unsigned long text_end)
 {
 	return -ENOSYS;
 }
 static inline int sframe_remove_section(unsigned long sframe_addr) { return -ENOSYS; }
+static inline bool current_has_sframe(void) { return false; }
 
 #endif /* CONFIG_HAVE_UNWIND_USER_SFRAME */
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 5f3fdfdb14c7..8d8195561c95 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -110,6 +110,7 @@
 #include <linux/tick.h>
 #include <linux/unwind_deferred.h>
 #include <linux/pgalloc.h>
+#include <linux/sframe.h>
 #include <linux/uaccess.h>
 
 #include <asm/mmu_context.h>
@@ -735,6 +736,7 @@ void __mmdrop(struct mm_struct *mm)
 	mm_pasid_drop(mm);
 	mm_destroy_cid(mm);
 	percpu_counter_destroy_many(mm->rss_stat, NR_MM_COUNTERS);
+	sframe_free_mm(mm);
 
 	free_mm(mm);
 }
@@ -1072,6 +1074,13 @@ static void mmap_init_lock(struct mm_struct *mm)
 #endif
 }
 
+static void mm_init_sframe(struct mm_struct *mm)
+{
+#ifdef CONFIG_HAVE_UNWIND_USER_SFRAME
+	mt_init(&mm->sframe_mt);
+#endif
+}
+
 static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 	struct user_namespace *user_ns)
 {
@@ -1100,6 +1109,7 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 	mm->pmd_huge_pte = NULL;
 #endif
 	mm_init_uprobes_state(mm);
+	mm_init_sframe(mm);
 	hugetlb_count_init(mm);
 
 	mm_flags_clear_all(mm);
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index d24e9d4f8bef..46dba3cb016d 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -19,6 +19,8 @@
 #define dbg(fmt, ...)							\
 	pr_debug("%s (%d): " fmt, current->comm, current->pid, ##__VA_ARGS__)
 
+DEFINE_STATIC_SRCU(sframe_srcu);
+
 static void free_section(struct sframe_section *sec)
 {
 	kfree(sec);
@@ -81,6 +83,7 @@ static int sframe_read_header(struct sframe_section *sec)
 int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 		       unsigned long text_start, unsigned long text_end)
 {
+	struct maple_tree *sframe_mt = &current->mm->sframe_mt;
 	struct vm_area_struct *sframe_vma, *text_vma;
 	struct mm_struct *mm = current->mm;
 	struct sframe_section *sec;
@@ -122,15 +125,74 @@ int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 	if (ret)
 		goto err_free;
 
-	/* TODO nowhere to store it yet - just free it and return an error */
-	ret = -ENOSYS;
+	ret = mtree_insert_range(sframe_mt, sec->text_start, sec->text_end - 1,
+				 sec, GFP_KERNEL_ACCOUNT);
+	if (ret) {
+		dbg("mtree_insert_range failed: text=%lx-%lx\n",
+		    sec->text_start, sec->text_end);
+		goto err_free;
+	}
+
+	return 0;
 
 err_free:
 	free_section(sec);
 	return ret;
 }
 
+static void sframe_free_srcu(struct rcu_head *rcu)
+{
+	struct sframe_section *sec = container_of(rcu, struct sframe_section, rcu);
+
+	free_section(sec);
+}
+
+static int __sframe_remove_section(struct mm_struct *mm,
+				   struct sframe_section *sec)
+{
+	if (!mtree_erase(&mm->sframe_mt, sec->text_start)) {
+		dbg("mtree_erase failed: text=%lx\n", sec->text_start);
+		return -EINVAL;
+	}
+
+	call_srcu(&sframe_srcu, &sec->rcu, sframe_free_srcu);
+
+	return 0;
+}
+
 int sframe_remove_section(unsigned long sframe_start)
 {
-	return -ENOSYS;
+	struct mm_struct *mm = current->mm;
+	struct sframe_section *sec;
+	unsigned long index = 0;
+	bool found = false;
+	int ret = 0;
+
+	guard(srcu)(&sframe_srcu);
+
+	mt_for_each(&mm->sframe_mt, sec, index, ULONG_MAX) {
+		if (sec->sframe_start == sframe_start) {
+			found = true;
+			ret |= __sframe_remove_section(mm, sec);
+		}
+	}
+
+	if (!found || ret)
+		return -EINVAL;
+
+	return 0;
+}
+
+void sframe_free_mm(struct mm_struct *mm)
+{
+	struct sframe_section *sec;
+	unsigned long index = 0;
+
+	if (!mm)
+		return;
+
+	mt_for_each(&mm->sframe_mt, sec, index, ULONG_MAX)
+		free_section(sec);
+
+	mtree_destroy(&mm->sframe_mt);
 }
diff --git a/mm/init-mm.c b/mm/init-mm.c
index c5556bb9d5f0..77909139162e 100644
--- a/mm/init-mm.c
+++ b/mm/init-mm.c
@@ -11,6 +11,7 @@
 #include <linux/atomic.h>
 #include <linux/user_namespace.h>
 #include <linux/iommu.h>
+#include <linux/sframe.h>
 #include <asm/mmu.h>
 
 #ifndef INIT_MM_CONTEXT
@@ -49,6 +50,7 @@ struct mm_struct init_mm = {
 #endif
 	.flexible_array	= MM_STRUCT_FLEXIBLE_ARRAY_INIT,
 	INIT_MM_CONTEXT(init_mm)
+	INIT_MM_SFRAME
 };
 
 void setup_initial_init_mm(void *start_code, void *end_code,
-- 
2.51.0


