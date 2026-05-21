Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A879CD5BB1
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:26:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 740A16B0099; Thu, 21 May 2026 10:26:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 712B26B009E; Thu, 21 May 2026 10:26:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F0C16B009B; Thu, 21 May 2026 10:26:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 24F0D6B0098
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:26:18 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C8AFA1A0373
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:17 +0000 (UTC)
X-FDA: 84791651994.23.7832F1E
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf21.hostedemail.com (Postfix) with ESMTP id 807B71C0012
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Csfx0ud8;
	spf=pass (imf21.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779373575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HNBbQrdilxxlDo0Yje7LeqecVTV4lI2XIhl/nW9XXj8=;
	b=w9nmgkoMIMYlNI4i2VXP/qZy7hfzhvWOrfwkNKWuvEdxRJCtp77Hc91JvK8bTPFff1krSb
	p7gyLdIXsoZhEJwKuHtmhZVsG5TghbNQfZj5wCHCD96zvOh3JxJmQ1268zZSxpLQzMuoST
	Taj5nMwmHYwsmuUxwsmExvkrZwTAPFM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779373575; a=rsa-sha256;
	cv=none;
	b=1FvBDzMx262e4axm4K3dkYlMwSbFFgl2QUIzfrdEtCJIV6c18ZdQRcKyzpTSdmS3QSvFhZ
	hECRdF6OitKDVFtoHfxe+8H3izRD8OoRSDUUE0Hc0CZZWRdq+Bt/K5i0dym4wbAUhnXG1l
	S45d9KJEKAgk85WDtQ4l7zb+SEaepTU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Csfx0ud8;
	spf=pass (imf21.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64L8OkB1730699;
	Thu, 21 May 2026 14:26:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=HNBbQrdilxxlDo0Yj
	e7LeqecVTV4lI2XIhl/nW9XXj8=; b=Csfx0ud8DpVys08I2TdPcGbcMNRJCXJ7z
	EnSoQc6HonQTdhGkuulAO7Ti+pCh/ksHm3Yx+Str/soZAot22XyTSaXbSHKqLycj
	7+/9hCKsIO95uafTiaW17shUBXT7xmXt0v0iCycIewdB3HLJW57DO9veYP3NVk+F
	u3nMiWwUO26Ln8nfsFI6WTkdNq263x8YBzfBNGFA1YUefp8/RfwKkyKjXZc2VSH/
	bT0URaZq2tEfGg6WxtpTLOmjZ9v+S6S+vPTPiIuANPDDZLdMujclzE2bGFuENhNi
	3KFHkEtU5lo1KQ8A4tmp0TuxIYX6xvJsFvnbFi37OgNVQwjHDm5Aw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6hawe82k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:26:01 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64LEO9CT017140;
	Thu, 21 May 2026 14:26:00 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e73wkcjd4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:26:00 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64LEPuVl60817692
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 14:25:56 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4B49D20040;
	Thu, 21 May 2026 14:25:56 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E991520049;
	Thu, 21 May 2026 14:25:55 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 14:25:55 +0000 (GMT)
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
Subject: [PATCH v16 18/20] unwind_user/sframe: Duplicate registered .sframe section data on clone/fork
Date: Thu, 21 May 2026 16:25:44 +0200
Message-ID: <20260521142546.3908498-19-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260521142546.3908498-1-jremus@linux.ibm.com>
References: <20260521142546.3908498-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDE0MiBTYWx0ZWRfX+GIwmHyIgaa/
 iEMghHH4xbHeQil90KcOstoov9/WrDDO4cxm2pB3MlIUpyID/lULwzJNnParCu5NOfdFvMkHjCA
 FX5nb0pj6Cg0otKRgSg3ZT5igTlwEBgvFeJ3DZ1qWpGEGGWwqptxnIbBL2enYAt/H4K2Wi3yDKC
 DRRHUCC5ld8qBj+Pr+f9Be8bXVvHMJfTTDjfSbGCrYREVVwBcmQK6Q9mhWcJJxc0CTUCj8NyYrc
 KYLuyfVYTm0kxrLsr+sXT0VNkWonMCkQvdTfPBAM/Cxx2G9SetZ2tj1IEKieZUo9FfL6LireQAV
 NyLEfRLTfMacAvYSIvK8xQPC7qckrDYA1p8xFb3iZawaUX7eG2Uv8WNkB4nHNxcdnPN4jX1Hkil
 DvTt/rGc1HPJDyhZNN9ioC78iM3OK8CzdgXKIKjYMfZMSV1/LCcf07HOEvPnyUlLUN9mrM2g7EU
 MEpcz1sYsFXFCIJW0wA==
X-Authority-Analysis: v=2.4 cv=Np/htcdJ c=1 sm=1 tr=0 ts=6a0f15f9 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=kI6mnXzX5LrxlMcTYKEA:9
X-Proofpoint-ORIG-GUID: viyUSvPYT66c6XW7QL_nwW9bHxSJ5P4k
X-Proofpoint-GUID: 5moAB6J8yQJuyxeXvVQmFH_ITAiPkjsW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210142
X-Rspam-User: 
X-Rspamd-Queue-Id: 807B71C0012
X-Stat-Signature: 699mc15amixw4u4x8wks7z5hgm5geq64
X-Rspamd-Server: rspam06
X-HE-Tag: 1779373575-583897
X-HE-Meta: U2FsdGVkX18ZojOOxeoCsvz/tU+zZMCJHO5CP1skhs/jMShRjRdSsDoucFN3NTc4Ap19KlSdkwE7VyDXlIRj+WuoMlvYkW+zsieuh9iAvhqkVzV6JzhwyHWmaCS2XJQlsMDMxTwPd2U3xFnUWpD4HObSbgPN/zNAoRrbwcEAr1/6hI4aQyDO7gpYNuoXGeQSgaVcYd4HywJ2YZeZybt9zr7ua6FDGPZ7K5sDLM5MlhNQoa8ts44xFFBMkDbUw/ynrjKKHxUiy8+ZjT2HAmZnyBU5kFR107Kspsrv18GZhgUFREWHYPKKgaeBLbqBX4qGCY2/ZaX1t5jiITMOn4fH9yuZPwXkQuerGP+2ZJhpGbXznE3vwsU0CybZlgsl+VtKJomSzPjz52GXzOAJFx+dwlNPTOQG3qGAmKX2TTQDsymhXGyxO+9z9ZbhjTj3wDySSYGnhBzlUZ952FMay7/gOH4RHbtZ11OQGHM6bY3cnFBSnYrKArhqfeflWzq59FvA4zbM/VbZGa2m/S/MrD2NOQP6chyLvcsD8mygNIlKWMV/hccCBLvzHO05QvDTN1BNEdWpjDRgPVcEycrKW+hWPITfWodXz2vjqbKUh4lP7PXtnRdJpkhXP9/Y2I96ElY0yr3y3330+c/j+5ByaPFkDZs5x68fwxjf/REma0IFQtnVMkXpGq6iP//gZBWhKNbE3nKu5D8bQtfPzKWupS8/Hl6Go7+jFlUZqX7lG+eEkzeqfteRqh6fGwYvhLlT8UUduTlQiP8x0PadsrJuPYpjaEGdcSN8zs0dN/CY+qCJwB6SRR7djI2MU6hzKydb9MtaxWpp6Re7dr/GqF/Qec0khVx3VUcfmrwRWn01lzOlc48m8Td7SRbtdAqn4kMdVJhIxADjmL4EtURpwo834BBMyK0Yfr/bfyS8UqjsQtkwLctJqumAR4hmZzoqqv+wDDbuZRx/MRALr/zdy3/HwNl
 3Xzm30DR
 o3x+1YPyzwczE4mVpu1rnOIfHJ/NKN0U2wrQ+gUm4R0gQKYfoS5rwSmfQntgNwYb7PfovIfnSfrVYjfbai88+xD7eWqw3PxgMljo1ME0b25fWlYDv0gv4KFjoZG+L04X5rc3cUiaFma+XHdgTLkJy8asm9O6JkcrX9tBKvn0KKIS8RbpUvNg7qHGPenUYl2R1rXmSH3OF3BaOu98eM85Y3ngBUSbKTbSVrYxxP+YV+7/H5/tLRbotk3gXi2Ph+8J9TeBlORztj8Pp9DjbFxdbH2qjbYm1rMw686go
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

Notes (jremus):
    Changes in v16:
    - dup_mmap(): Drop unnecessary CONFIG_HAVE_UNWIND_USER_SFRAME #ifdefs.
      (Sashiko AI)
    - dup_mmap(): Call sframe_dup_mm() prior to arch_dup_mmap(), so that
      comes last.
    
    Changes in v15:
    - New patch.

 include/linux/sframe.h       |  5 ++++
 kernel/unwind/sframe.c       | 48 ++++++++++++++++++++++++++++++++++++
 kernel/unwind/sframe_debug.h |  7 ++++++
 mm/mmap.c                    |  5 ++++
 4 files changed, 65 insertions(+)

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
index 7f439600b0f0..db88d993dff1 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -875,6 +875,54 @@ int sframe_remove_section(unsigned long sframe_start)
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
index 5754d1c36462..8715be691488 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -48,6 +48,7 @@
 #include <linux/sched/mm.h>
 #include <linux/ksm.h>
 #include <linux/memfd.h>
+#include <linux/sframe.h>
 
 #include <linux/uaccess.h>
 #include <asm/cacheflush.h>
@@ -1844,6 +1845,9 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 			goto loop_out;
 		}
 	}
+	retval = sframe_dup_mm(mm, oldmm);
+	if (retval)
+		goto loop_out;
 	/* a new mm has just been created */
 	retval = arch_dup_mmap(oldmm, mm);
 loop_out:
@@ -1893,6 +1897,7 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 			vm_unacct_memory(charge);
 		}
 		__mt_destroy(&mm->mm_mt);
+		sframe_free_mm(mm);
 		/*
 		 * The mm_struct is going to exit, but the locks will be dropped
 		 * first.  Set the mm_struct as unstable is advisable as it is
-- 
2.51.0


