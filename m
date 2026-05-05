Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27FF9CD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 12:34:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95DA16B00B2; Tue,  5 May 2026 08:34:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 935056B00B3; Tue,  5 May 2026 08:34:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 824216B00B4; Tue,  5 May 2026 08:34:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7530D6B00B2
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:34:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4190A1404C4
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:34:38 +0000 (UTC)
X-FDA: 84733309836.27.CBB5775
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf05.hostedemail.com (Postfix) with ESMTP id E31FA10000D
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:34:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Nc8EM48t;
	spf=pass (imf05.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777984476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UczKkIqfVmHqRB8Daa9rtjVAZntNUMhh16BffZj+guM=;
	b=4e49pPOBCronuyYu+FURs22b7QyMRpza4JdquqKlySX4cXYGlIZ6vFtzgB/o+TuoOkAA2d
	kzwqamrPqQawzZidMHlp6M/8+SRJ7Pgnd+APZsBrFkM5pDrOX1ULzDk6eHIZIY707oNxAb
	XbrFe9fUfBNr7Z8n8ELa+BbypTS4v7Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777984476; a=rsa-sha256;
	cv=none;
	b=Bm2IGMT6f/EjPboeUigsMWA2JiOMvZBVqoadDoGUWYRIAXh8EC59wNCvFjq7RjFycTwO9b
	6W55dHO2ZwWkgoJuvDqCUrUge/vesMuHMZ4yXjLKDyc4kRahR3Aowaey6sBPg5V2A8sCmP
	wOvzn1RMjM4o+dwHCr4Snbxd6UdPnpU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Nc8EM48t;
	spf=pass (imf05.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6457ZZaR2791324;
	Tue, 5 May 2026 12:17:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=UczKkIqfVmHqRB8Da
	a9rtjVAZntNUMhh16BffZj+guM=; b=Nc8EM48tKLa3YXqMMGPt3ogo5GX0/wr/n
	5ABOXcujgkAYouVH2Btd1OOOKqumzuyQi1YGJkB9bcTrXZPrN18ctuEkXrMQ4mcK
	qsP3JzsGX1d3vGnLN9pOtWqbJXjWgILxvhjbasQwlHafLTaUkpqFKskJwl0IeMme
	pN+C/Q/ruDSlO0S+Dza9Yw7V2IcTqbrPPcSFLIj4lz5u9my0osidvju3SKNHmgiU
	uZKgRzC422Carb3l/RNNfgot2EmtF1sUaj0tOlOWx/tWKLb877vQSO8MPlFUX3YU
	SZ8o/2QQmKEcRVhco6jH1rp27b99GJshDdOfE5cf/OxGPhsbiyqVQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9y1bh32-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:27 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 645C9g8g028543;
	Tue, 5 May 2026 12:17:26 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dwuyw1m32-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:26 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 645CHMXo36045192
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 May 2026 12:17:22 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9B1C02004D;
	Tue,  5 May 2026 12:17:22 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 31F742004F;
	Tue,  5 May 2026 12:17:22 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 May 2026 12:17:22 +0000 (GMT)
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
Subject: [PATCH v14 03/19] unwind_user/sframe: Store .sframe section data in per-mm maple tree
Date: Tue,  5 May 2026 14:17:02 +0200
Message-ID: <20260505121718.3572346-4-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260505121718.3572346-1-jremus@linux.ibm.com>
References: <20260505121718.3572346-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: giJmQWgdJ0WOmXNWmGSQSaFhX9DyKVaN
X-Proofpoint-GUID: pEU73BEv-vlb3ri3d23VUWwQ4itBwYa_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDExNCBTYWx0ZWRfX0JWXrg8Ok70Q
 4bSVl2U8pmcCJvSQN72e134eO7GtJ7avXnGZdECkXB6TZ0NvC2MdA1+IkrzLHcPYYKq4LWW7hod
 dErW9b6bkrJOyFWT1D8ZBUiP/uSLEh+R4lRDy1MwXh9o5ERI12/W9jK4zma6vv64go9JD1oFo8p
 28jf92a6y6bNUOsmJvR+MYUKzks8nE0gI6MtFRp1za5qGW0e7An+/JwHQFRB4SSnmuX8bTlCg+h
 Pe28GQSjJQjc9YvDkT6oxwERGaGQl0FdPAnUJFRkzuFej22t0uKte2PhzLy/fVDW4jmx3TXFgkU
 8IYCd/a33ZRcwAo1Jjbo7U+ANSO5EQwVf6gp7Oguv9WxnxW1+Xl64UeZatA1lJSMPpVlZxnMxUp
 3FJueGTGih5fEeB7LX4lvCU+e4yerzeQM4/OEmjggMHaCmYB++V7nKEZzhkdGTSXBNcRLdfjfwX
 3KS2nbcBEwR8shnN8Mg==
X-Authority-Analysis: v=2.4 cv=UbFhjqSN c=1 sm=1 tr=0 ts=69f9dfd8 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=Oh2dYGMcuWX8t7tWpUQA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605050114
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E31FA10000D
X-Rspam-User: 
X-Stat-Signature: zqfo9b7mt7atr8sdfpduefkur71tqccz
X-HE-Tag: 1777984475-449351
X-HE-Meta: U2FsdGVkX18dvKkEnZckClxzv8kCwJfRCGOI3SMOYuX40TqwPhWuEmdVbGBfsDP/WvlHci64wyhadWcPloA9BNEJNaWtj10AlrcQFWtJ0Wudj15uOpGNzKJVn731fgD3t7UOX+xllC7l7/XIlldIy9DmTH3+cE6RZBbhO0GZ443HzJ7c2b+2jzU7jk6+myLJxOlbGXyFxIWVVHbTHZNbVEStqKxMLtVoimPA5iDs6v/Zpkq2TtjSZpBZouRBDOC2J7f4xWWwA9Qn07vUnGLId/5qKOcHUnAiZ1RGtCrlI1vSxbqGx9EMlzLBnnbYYgs82zSVlbvBocy3TslTitDHStGM8OPBcJQZU3Bk71LA7XfCA4dyEukk9cVBmduL50g9eyX9d550XTFjoCCwW7507e/9XCf8iUOiYM2n8cZf5ECg5YwhQmmtUYebtH9cIYcacGvk17rG/xfX3QjIfsycY4mcl9cl8NjpyVWH3hezCTwgjScAmDaTW6107/4hz/QUTbN5yMpKxUA0HtvFnJFHu17gGJiS+RhBxy5POOm6eA5+1hvk+3DLdNpZYmejNYlTGlZ1ZlHqyiXexfASg0WmnYTsnSo/wRFOXTNjibuCzgas53FkHXaLGHJ5cXy4tFVdnMZvpsQwUnaim8gmlEW9S6FCX2v4NM15kek3NEXd7+NUSU6aWbo5KgpTjDw679WCZU6yDS4n2arEklSal8MjaZy72yPDZZCv1Nd4ePuYuQLoc49IaRnd5+fnVEOio+Zpk2F1bTDADj4DDv/OA5SZXUE84yWWPUufLQVtotJXwywUePA35kwKCql4e2PnYwfYbE8P7DQnZEDI0v1BwY5LZqXfhOi60XMxmhJnA7jcFPiuxs3EnD5JVqHf8fYjh6rSaOM9bQAIYWosfImt7U2p+s+InxbWmwLUQD7CYk/AXqwip8GQ5+dsAOmjSUxODx9sv+nDGMwVuA0nyUWmyes
 T1s5Mpue
 HWnT4RrQfIEJo0dpHkNE9od68SRZYf2kD4T4yV4ltRe2M/ogLj1miTsUVXDHGGGYYwS1R65knMyfO4ZQ+Sd3tg4yiySplU31OICLaMwXpWJGnvpd/p/ApWS93WxFVv6bG2GM9I0BOc26owf2/gzasStQGPD6MAdubNoxFbCtco4TJgZS7eVYoBjuziVg21bCyRq0VdsygqN45MS4BE9HP5Bk9cGYhRGiS9KCQTPeJ2xh4u7FIYO2iidHXRgaEPP/xQYe8CYQt1f8E4EbWmttI+BnAbnCdzTRelqrXwd85nwDNaUirFkANSZWi2uR56CZHtIbQAQJWmy2GYd4HxnnwbC3uMjh4KvSmNSZ9vRij46zX++3n4fmvlXT9ZGB9A78SShB36eACH4hQKVQ=
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
 arch/x86/include/asm/mmu.h |  2 +-
 include/linux/mm_types.h   |  3 ++
 include/linux/sframe.h     | 15 ++++++++++
 kernel/fork.c              | 10 +++++++
 kernel/unwind/sframe.c     | 56 ++++++++++++++++++++++++++++++++++++--
 mm/init-mm.c               |  2 ++
 6 files changed, 84 insertions(+), 4 deletions(-)

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
index c128c1eeaca2..fdb2a4908563 100644
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
@@ -122,15 +123,64 @@ int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 	if (ret)
 		goto err_free;
 
-	/* TODO nowhere to store it yet - just free it and return an error */
-	ret = -ENOSYS;
+	ret = mtree_insert_range(sframe_mt, sec->text_start, sec->text_end, sec, GFP_KERNEL);
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


