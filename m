Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1563CCD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:40:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CA7E6B0088; Wed, 20 May 2026 11:40:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A1A56B00E0; Wed, 20 May 2026 11:40:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B7926B00E4; Wed, 20 May 2026 11:40:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A1266B0088
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:40:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 01C9B12039C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:40:44 +0000 (UTC)
X-FDA: 84788210850.20.7D9705A
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf23.hostedemail.com (Postfix) with ESMTP id A9B2E140012
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:40:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ts7uHLp5;
	spf=pass (imf23.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779291642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uzN6ExvwjSRFvHa4QSSdgJXqamOyosXCIwBkfX5X/iU=;
	b=fDbWfHvmW7lYdGna/pi+Jis43g3+XFz99xs1RQg9fs2CZpx2GXVgrzUz8/9/0S7wrkjBdC
	OFxwyZINUM7du4CHOK3QlAzzVfXMsTtnIeHjKhHu3ognHlpbQuGdHtUP++haBpG8fJfzC6
	tz+gVIoxWb5xrcRghtGymF2QYbStGX0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ts7uHLp5;
	spf=pass (imf23.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779291642; a=rsa-sha256;
	cv=none;
	b=peOuEl0RnZWH0QU59O43E9r6Vz32B/4NjwIPiE3eoqul+aUmCTK1T0/S6V67AzFFauT1qi
	w8mG3KN4ArJmQGKgo0xEyQC0JYos9Tn4tGIyejFKv1UYV2zRtd7wy7TFyqleP0Iwc8Do9k
	Ka//YHj0rFqXXknCrHX7HX/qfgyLfgs=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KBdqLq3067542;
	Wed, 20 May 2026 15:40:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=uzN6ExvwjSRFvHa4Q
	SSdgJXqamOyosXCIwBkfX5X/iU=; b=ts7uHLp5+jAdPzzdtXNwyUUJbq/sFvFAn
	lLvSzN9o3lEosyNNra60yNtsXvldsho217Evi4tQ/f6VWXM7qoXRFwI0Ks0GQLn4
	yeWFIOIcB/ZEZmnS6sH3ms430Ie3nFlv8kzjCxdxhBLgy3h5K4UCxgOmBIxS9tlU
	6HYLJj86mFIC0G075qvhefxzMq3eqvYJGSX+MmCIxR5DfUtgpK1cKZtYxd8+UWpb
	yaj4fhX4LSHxiITZLaEtVcVZiodoWKBhIJurFv00ee1E2F5xzu9r+pfYNXeGapYT
	8thbbO9WyfwgMMVK3bT4atxW59264X66EKiDYrbGU/+ZO5VByL1tg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6haw9u5s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 15:40:22 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64KFdANZ026110;
	Wed, 20 May 2026 15:40:21 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e75ky7q6k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 15:40:21 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64KFeHFO46268892
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 May 2026 15:40:17 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BF0DD2004D;
	Wed, 20 May 2026 15:40:17 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 403F82004B;
	Wed, 20 May 2026 15:40:17 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 20 May 2026 15:40:17 +0000 (GMT)
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
Subject: [PATCH v15 18/20] unwind_user/sframe: Duplicate registered .sframe section data on clone/fork
Date: Wed, 20 May 2026 17:40:02 +0200
Message-ID: <20260520154004.3845823-19-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260520154004.3845823-1-jremus@linux.ibm.com>
References: <20260520154004.3845823-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDE1MSBTYWx0ZWRfXzDf0BBVwHN8H
 OeYMoeWwylZgdLIw/zdKsHPEr0h8qkx6aYfbKMNVY9M4EMtgIL7FrGt/O8Naku/9q0paeWVFdT4
 gTsgm4xKJrGYSMlt0O2RDqFlmAUBKrEsCB1AxRjVb2EvoJ2E9H0YcTI+wp9lFMafcrpr0kZmm+5
 2ydSK8BuLe5n5lKwwDWKM2PPlEx8YzqBbcsyc8jVx/Qhw6RKIVi7RcqOxVA1aK9voiJwsqlaTPj
 jk5RhH3M9d6K/Yf9SrOe5RMg2N8S3TLy7o6W/7o62UTeiW2fgCgm2TmTU3Qndx3jJ7cDxoBUTeI
 +zogwZ3kW8aNY9XginzO89ilwIE7sHIiAc/mYrLI3FcSmuijRjUw2MHdlGPqRe56gV6LwYFCP3a
 UrC+ER0nKFYbe6vXYBtEQpvek90hqt4hoMEZXida0H8Erda/xzhjqn7rAjEn4dvzVZcsg+j/76v
 9Jvx3aYknaAT05uHjeA==
X-Authority-Analysis: v=2.4 cv=Np/htcdJ c=1 sm=1 tr=0 ts=6a0dd5e6 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=H1ImvsCuyUzGZUZlsssA:9
X-Proofpoint-ORIG-GUID: 0v1vB95jkJXiZWaV3My4cqKvh1HEwtRJ
X-Proofpoint-GUID: eDqNSvCepqPb2rATY0Fc-wAC4b6k_woA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605200151
X-Rspam-User: 
X-Rspamd-Queue-Id: A9B2E140012
X-Rspamd-Server: rspam06
X-Stat-Signature: q3a9tnwpk4dca165y77ewwfqqw95ir7k
X-HE-Tag: 1779291642-134605
X-HE-Meta: U2FsdGVkX18Z79/jn+lUt8iDatrN4zj9uXz3j3t/3k0cmk/5GwULSMzneGKQ+rbOuvfkmYJswnQyYnOptLvcoyv/hOS0QqSQglWNoB3hud7l8Qa+Whq+gYEBtTOzks2/WVGJXOxFe0GPFRNPSlW5kfZ2e7OGZPoLKNWCKK1hMPGDHBIOjWsINiNWPrRD/pMugdLm2+nJzUJhVcKDwDg0aDlbjjQN636pPW3mIJ1lSMS/VzelbCUjIiAD1DH1mzLAnleFbnKXIfPpUWuPbN959Ljee3BvdMtRDhYPCCaYcehnRtbcdY/jMV77yCGN0FFRL4RtqT9uPbiiN+vt78QXLLIz7P4vlUSMjTKJ9RCSem1DGhURzcJvbe1WIQUBQDeo1BdTZsC2s/qH+eu/lEhkvA31JjJn3khxbbCrXCu3m83WuvrhHF2/j0bDVoVrVDoRV3CV/jMC6XYAjK06Ea+mBEhQVlm3d+zyvnBkFOOv2i7LXYkhfUwFAdM1tTzsZmawYWZFA95iRR/whpU1HJBfTSKZxZEs3V5rZtRq7+95epPITJrq1cP692djE7ppiRGlSM7Mr1QBSAD+Vnul0sEBInxxq19Kz55GqndDKtSwXh6AEeCst5A1Tpl7OTeoIygS4vcsJlei7hodQ1yNoVDwEz9PiQpw0laRckiEoq5Hl9Xqf9QSmq0nrhIgNCLzghUBtq5jLf+WVUyKRj+NALALLNmoS//mGuPkLhwI15310ESMkwpt59YvUU290o/5P6N6J0FIvAot3SHKuOihYs4yTPB4RCEhs2hhV5uO623DRc87nAEsKMYHafOROZoh3/ftdPbmAu+8JJRzwGQNTXXncQ9ZzkaD3tbX3Hv4mLDSucDyaFJO/3ckkabRdRImGEKhEjEIhGgFCo3BIcbm6c9fIQQqbfMBcY+9l6cR20BkqBgaXPImQjtOiIdTtb4CzImsG4tsIE0d2Eom1Ra9G+y
 Sfz5pSYM
 /zO2sdoOPZbgMIKn2Qkxvi9rCPywaQCO64yxE9eJnE4i9T+JOVWzphrCURL/Z54jg4FmJ2Q+9IdY3p7tiO5/spUuj7BYBYviBQOUU72utfapXsdhNyj2dE32AAdc3R8jxqZUYWm1vD+YiS066GTBMslB/9o+1kpiiscz7YUyKMgEXMikLDwy7mhNV98FEk/ruaKIL1RPb/dJDIQy8Tq/K1p9PD/DOY2GQLIQMWp7C3L9jFH6KNwzuDK0Mgm6WXXYljHnveZwu8+u9fotgxA3TuQgwgNL/dGXPCP1jnS0c/28Of9sHNmOWOPy+xGz3e5tqZMBUbBE4Iuuq/HBbTSNzUyKIGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When duplicating a process' virtual memory mappings also duplicate all
of its registered .sframe sections stored in the per-mm maple tree to
enable stacktracing using sframe of the child process.

Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---
 include/linux/sframe.h       |  5 ++++
 kernel/unwind/sframe.c       | 48 ++++++++++++++++++++++++++++++++++++
 kernel/unwind/sframe_debug.h |  7 ++++++
 mm/mmap.c                    |  9 +++++++
 4 files changed, 69 insertions(+)

diff --git a/include/linux/sframe.h b/include/linux/sframe.h
index b79c5ec09229..91889b4fe3dd 100644
--- a/include/linux/sframe.h
+++ b/include/linux/sframe.h
@@ -28,6 +28,7 @@ struct sframe_section {
 };
 
 #define INIT_MM_SFRAME .sframe_mt = MTREE_INIT(sframe_mt, 0),
+extern int sframe_dup_mm(struct mm_struct *mm, struct mm_struct *oldmm);
 extern void sframe_free_mm(struct mm_struct *mm);
 
 extern int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
@@ -45,6 +46,10 @@ static inline bool current_has_sframe(void)
 #else /* !CONFIG_HAVE_UNWIND_USER_SFRAME */
 
 #define INIT_MM_SFRAME
+static inline int sframe_dup_mm(struct mm_struct *mm, struct mm_struct *oldmm)
+{
+	return 0;
+}
 static inline void sframe_free_mm(struct mm_struct *mm) {}
 static inline int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 				     unsigned long text_start, unsigned long text_end)
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index ec8318977a2e..0661090dd5bc 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -886,6 +886,54 @@ int sframe_remove_section(unsigned long sframe_start)
 	return 0;
 }
 
+static void __sframe_dup_section(struct sframe_section *sec, struct sframe_section *oldsec)
+{
+	sec->sframe_start	= oldsec->sframe_start;
+	sec->sframe_end		= oldsec->sframe_end;
+	sec->text_start		= oldsec->text_start;
+	sec->text_end		= oldsec->text_end;
+
+	sec->fdes_start		= oldsec->fdes_start;
+	sec->fres_start		= oldsec->fres_start;
+	sec->fres_end		= oldsec->fres_end;
+	sec->num_fdes		= oldsec->num_fdes;
+
+	sec->ra_off		= oldsec->ra_off;
+	sec->fp_off		= oldsec->fp_off;
+
+	dbg_dup(sec, oldsec);
+}
+
+int sframe_dup_mm(struct mm_struct *mm, struct mm_struct *oldmm)
+{
+	struct sframe_section *sec, *oldsec;
+	unsigned long index = 0;
+	int ret;
+
+	guard(srcu)(&sframe_srcu);
+
+	mt_for_each(&oldmm->sframe_mt, oldsec, index, ULONG_MAX) {
+		sec = kzalloc(sizeof(*sec), GFP_KERNEL_ACCOUNT);
+		if (!sec)
+			return -ENOMEM;
+
+		__sframe_dup_section(sec, oldsec);
+
+		ret = mtree_insert_range(&mm->sframe_mt,
+					 sec->text_start,
+					 sec->text_end - 1,
+					 sec, GFP_KERNEL_ACCOUNT);
+		if (ret)
+			goto err_free;
+	}
+
+	return 0;
+
+err_free:
+	free_section(sec);
+	return ret;
+}
+
 void sframe_free_mm(struct mm_struct *mm)
 {
 	struct sframe_section *sec;
diff --git a/kernel/unwind/sframe_debug.h b/kernel/unwind/sframe_debug.h
index a63e75cccc70..2503972155e8 100644
--- a/kernel/unwind/sframe_debug.h
+++ b/kernel/unwind/sframe_debug.h
@@ -48,6 +48,12 @@ static inline void dbg_init(struct sframe_section *sec)
 		sec->filename = kstrdup("(anonymous)", GFP_KERNEL_ACCOUNT);
 }
 
+static inline void dbg_dup(struct sframe_section *sec, struct sframe_section *oldsec)
+{
+	if (oldsec->filename)
+		sec->filename = kstrdup(oldsec->filename, GFP_KERNEL_ACCOUNT);
+}
+
 static inline void dbg_free(struct sframe_section *sec)
 {
 	kfree(sec->filename);
@@ -61,6 +67,7 @@ static inline void dbg_free(struct sframe_section *sec)
 static inline void dbg_print_header(struct sframe_section *sec) {}
 
 static inline void dbg_init(struct sframe_section *sec) {}
+static inline void dbg_dup(struct sframe_section *sec, struct sframe_section *oldsec) {}
 static inline void dbg_free(struct sframe_section *sec) {}
 
 #endif /* !CONFIG_DYNAMIC_DEBUG */
diff --git a/mm/mmap.c b/mm/mmap.c
index 5754d1c36462..250e8bea73ef 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -48,6 +48,7 @@
 #include <linux/sched/mm.h>
 #include <linux/ksm.h>
 #include <linux/memfd.h>
+#include <linux/sframe.h>
 
 #include <linux/uaccess.h>
 #include <asm/cacheflush.h>
@@ -1846,6 +1847,11 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 	}
 	/* a new mm has just been created */
 	retval = arch_dup_mmap(oldmm, mm);
+#ifdef CONFIG_HAVE_UNWIND_USER_SFRAME
+	if (!retval) {
+		retval = sframe_dup_mm(mm, oldmm);
+	}
+#endif
 loop_out:
 	vma_iter_free(&vmi);
 	if (!retval) {
@@ -1893,6 +1899,9 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 			vm_unacct_memory(charge);
 		}
 		__mt_destroy(&mm->mm_mt);
+#ifdef CONFIG_HAVE_UNWIND_USER_SFRAME
+		sframe_free_mm(mm);
+#endif
 		/*
 		 * The mm_struct is going to exit, but the locks will be dropped
 		 * first.  Set the mm_struct as unstable is advisable as it is
-- 
2.51.0


