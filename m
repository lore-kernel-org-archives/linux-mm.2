Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77352CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:41:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BE2D6B00F8; Wed, 20 May 2026 11:40:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 292596B00F9; Wed, 20 May 2026 11:40:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 184066B00FA; Wed, 20 May 2026 11:40:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 01A8B6B00F8
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:40:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2DAF3C1851
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:40:58 +0000 (UTC)
X-FDA: 84788211396.25.8BC66F5
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf19.hostedemail.com (Postfix) with ESMTP id BE9311A000A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:40:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Jyb2ZaGE;
	spf=pass (imf19.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779291655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9wEhq4eFTNOSsfxhropjLVUcL6Dm05PluTrbU/V8aR8=;
	b=mtx29nj1yvhTrFYFXd/7OPyN4guqwxYSPiReUGmmlFp9536CT3DHgHDNTnNAuxb8mR/LSu
	1WbEzp483SHG69BanHcyX7GB2eMG/+hceI6Vr2sRvJklpwJKqGzY9yFIdyg8nv6GnKm/qT
	fJ1EYL+I2E/gG5PmVqGdzjF+kpfqbdg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Jyb2ZaGE;
	spf=pass (imf19.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779291655; a=rsa-sha256;
	cv=none;
	b=YC8dkyAOMDYxIVbMBF04zT77PROKcbihzf0yyWhdUMaxA3Kecf7kzcy5xvP5dv0JUz5eKY
	CtXDQSDBYWoDtrv0f3ikAJyPzTVL6YJFcqyHRzjYcsd2fopYy3N1H5L1aosgndxyKXAajS
	LRfo2RaeaUkDkFhawBURiqBOjgzBpYM=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KDZ4pS3681418;
	Wed, 20 May 2026 15:40:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=9wEhq4eFTNOSsfxhr
	opjLVUcL6Dm05PluTrbU/V8aR8=; b=Jyb2ZaGEGYPJ52sXZfxgtr6Lrq5gi2IRk
	vluTealQPhZWPIXC30Xp03HFWzkDJTPr46RIz5BGKriJyfLrZZpqR1hkpvPMGY/O
	0RYO/jPM5J4ApGFjprKKyG2NdNujrQ8Csmzqe2bziAHOdXfVNZT7ddtXe8L+9Xyt
	VaHu0/wQjOfKZfSTGjIVnPtIusk6+nUS+e4H7TXNj9nuyJ2tGiq5/JuiGNtIz4+X
	Bsl88MxyPj3FG9ZVeOJ+vLrSJ5Zlp5/oI2ipFJ2WRaPHeMJMILR8fPQVm22dnzho
	HmTjbjbG9vvelxScG24j3AqjAwBx8+B3spOSWeerdfVVE/m4MQYjw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h9y2vme-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 15:40:13 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64KFd7Mt016247;
	Wed, 20 May 2026 15:40:12 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e754gfrhf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 15:40:12 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64KFe9p851708174
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 May 2026 15:40:09 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1965820040;
	Wed, 20 May 2026 15:40:09 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 84D9420043;
	Wed, 20 May 2026 15:40:08 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 20 May 2026 15:40:08 +0000 (GMT)
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
Subject: [PATCH v15 03/20] unwind_user/sframe: Store .sframe section data in per-mm maple tree
Date: Wed, 20 May 2026 17:39:47 +0200
Message-ID: <20260520154004.3845823-4-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260520154004.3845823-1-jremus@linux.ibm.com>
References: <20260520154004.3845823-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDE1MSBTYWx0ZWRfX5TrrRi1QbhaZ
 mtb+viY3ZVyPqp2/LdmIKm9Mj0K++oKuhi5wWxDdXVlBzno28IkX/FXd7d7OFBvQT2YuOG303Nd
 Eyk8pVQJdGmp0Knuk+YvarqeAunl9pRr5glnt0FoSEHepTMJiFZ2MTt4o1X2dJhBa4NOH682k55
 5eQQlBaGORAU0EIpvHw05r8KWOF/7DDFi32sUlQcObU8rHqYm1hkF8JVnrUeo7cd6fzDqsPPEs4
 OVtpgm19tgGdWbmetigQo/r5YVDmjcj+zE2DW1zLbA1WKqi89g9cTJpDew6vwFfK5N9bjB4vmyh
 R7wn4mtMww5x6QJmCHKGKVuS0r/9m3bqFEg686QBOrxGQzoglnvf3G5b94lDQYy/NN6aR4JaZHc
 1HFFnyvoj815B2af8Rgmw8TiItxChY0ZaRTv2Od2ZfpnUyyk9Gh4/GR2OPg1Oq9Z7QJ41lLGpJX
 St1R0AUPHMMN1sWG4vw==
X-Authority-Analysis: v=2.4 cv=BNuDalQG c=1 sm=1 tr=0 ts=6a0dd5de cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=YdqKCSFLGneDM7Tu_fYA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-ORIG-GUID: jFA2BCFLIDNy3DfJcvarB-LzGoKGWbPR
X-Proofpoint-GUID: EXL2z-QuVSdgEqYVdBBkbCg6LsZjCogh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605200151
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BE9311A000A
X-Stat-Signature: ucof8eywsdgfpxo7q59duhexneg631kb
X-HE-Tag: 1779291655-786090
X-HE-Meta: U2FsdGVkX19gEJ82PqT2wfeNJ103rGA+0Ug7ef5BdDTzsFdvStjxyFTLalrJC9L25S8Jl5VCc5Khwgr2etTsWKtZk++iUN+nVSlYFxFPc7SuQqj5HAzO34jdUuuY94wGyEq9xDNZHCaYEyZTy83JeKfBL5+geaa6gVOpPVGUvpyEQK/gqzrltwkgMAeF5tzJPF1ZPd6a+m3KrSEESfMpasrVlOxp7MZHGPgzpxhzUbG3lqJ2M00+H/ys6/pRSJS/X/RuCdVEMz+F9VJElhwuoS9J5j+1ljlQW1shgvAKh8iMhko63Cpco2y4Ns8cNycida+R/5NB1MrcHWWLqtwliEFWTdHCUAS0IamrlfoU8vhIw0SwtrFMpyD79fNWJDgfZTq/igBzJKVdsdab/E9Lh/ocm67UVXtg7WrvxaWT9wBb6DMnu/5j5XGGD3qCJnxDViKPI+KiiUh/e4ZMJCCjyHyh6CNdRFM4fKQttUgBaqqEw3TfhoRPdiwaiEmA4Tuz/tHqP5fsllbB9LJUc2u5EBLl47bxrX5bR3oXjX01MyOA0LQ3dKK9ootluxL5ivSce3a19TYGoGAehmBKON154bcRtyAAA7xPvx+xoVYEcF5DI40hoM9Iklp2ZDinWCg98PkBSRRoq2N9xbQ0/GkAu21PAA1sSsj74vgLCdo8N639bPvXl3Rn878DB7Agq9Q5ULoRwxDnLnkTEoyU1gZgQvpFeUP9PIC9r4X0SqDNzbIqOsZG9yLvWIohqcWcl70TuGlk9OWCGQy/xPPXnNXiqTZcmAMUmS/P8czD9Tj7+owP6YuGO2NAqBSIcOAMw1NhpMZuv+qAuDoj4v1iBJW83QMudYkaSF+Isaitt0YBGBiPtjq6FojFqc76yt3/Z/SuG/Za7BYjXkklJaEXBM3sFUxl2b3e63j5szrb/XbPCCEgarYy+lcLdpnQi7Kr0WEh0f/DzTerwPkN9thqy3c
 BmBWerv0
 /QNOSwFvfwf5+gn41nhOTk5Y8CizsA3N1rz6YNYB6ux9LEmrNa+6aYRVJOX0CBmNY+1Rt9kG2SdK6ea8GNgsXgQr8A1Tgqu70DFy5oaaS1kVIM/3ihWgACTbJHQwTqa6oVNGADxp0OTBiII6RhSRyWThkdv3G8WdVTODAKxQG3M+bKgJWiSaUBv+gvEy8gEbTHxs4wFxRS625NkIVxIvtBiM64bZ4YKKZsgSXS9Bkil9yNCe9ybLCQNn9Da6FkgQ4cxMpcEV1QOcj3Tw8a5N0excg1CYJb1LKzdHLbr8jQp9prmlC18ScmQ/sk8I9pjAA02Ph5ntE856vRyGoW+pCMU0JKxq7i0s3JPipw55sJKTL6yN75Z4RES5pPBuYcTN+r7vM5Osto0YE1b7jzqJmtAdRDqZI2PMVxzjZ+WaaBTTuvEhnuPHqEuEkJ4SI+2fj0HROyCt8y8dx0TI=
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
 include/linux/sframe.h     | 15 ++++++++++
 kernel/fork.c              | 10 +++++++
 kernel/unwind/sframe.c     | 59 ++++++++++++++++++++++++++++++++++++--
 mm/init-mm.c               |  2 ++
 6 files changed, 87 insertions(+), 4 deletions(-)

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
index 0642595534f9..7ea6a97ed8af 100644
--- a/include/linux/sframe.h
+++ b/include/linux/sframe.h
@@ -2,6 +2,8 @@
 #ifndef _LINUX_SFRAME_H
 #define _LINUX_SFRAME_H
 
+#include <linux/mm_types.h>
+
 #ifdef CONFIG_HAVE_UNWIND_USER_SFRAME
 
 struct sframe_section {
@@ -19,18 +21,31 @@ struct sframe_section {
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
index d24e9d4f8bef..6b3ce3f8966d 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -81,6 +81,7 @@ static int sframe_read_header(struct sframe_section *sec)
 int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 		       unsigned long text_start, unsigned long text_end)
 {
+	struct maple_tree *sframe_mt = &current->mm->sframe_mt;
 	struct vm_area_struct *sframe_vma, *text_vma;
 	struct mm_struct *mm = current->mm;
 	struct sframe_section *sec;
@@ -122,15 +123,67 @@ int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
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
 
+static int __sframe_remove_section(struct mm_struct *mm,
+				   struct sframe_section *sec)
+{
+	if (!mtree_erase(&mm->sframe_mt, sec->text_start)) {
+		dbg("mtree_erase failed: text=%lx\n", sec->text_start);
+		return -EINVAL;
+	}
+
+	free_section(sec);
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


