Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3BD7CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 16:54:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B7076B0095; Wed, 20 May 2026 12:54:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 240796B0098; Wed, 20 May 2026 12:54:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12F9E6B0099; Wed, 20 May 2026 12:54:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 00DBF6B0095
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:54:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9332AA01AA
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:54:32 +0000 (UTC)
X-FDA: 84788396784.27.96F33E5
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf15.hostedemail.com (Postfix) with ESMTP id 44FF2A000B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:54:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=hnHCkeic;
	spf=pass (imf15.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779296070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3c0nvh5itwhP8hGgKl3AyRHknls54+T11C0TpI4uHJU=;
	b=jg6ZxtQA2BKJrwZ35aK2bxlpHaG+v9kpQpB4SYCyJ6SszU4VOSKzRnxhmw1GmenBhxWBAA
	M8XxfJ7EJSfryvWR/P5plTyvO3ju44osFiKojQ04Pk//jMWZP+U0CF7w93+MIrYYA6N9Fw
	NRVH6qp/FOMge5MNRxIHLyCVpxs7WBc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=hnHCkeic;
	spf=pass (imf15.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779296070; a=rsa-sha256;
	cv=none;
	b=7YPIIpC0RjQzT+750ddF66mrTUejwb8sEHiqe/qvPHUw6TGrAPBpS4Cy0Ih/Hre+o4gOZS
	wtqtKl9Nvm8+1d+hW8nGSZipivf5vNsD9hszOr6FIF+9Hw4pEqsXcfCWg7ji88sdOR/Rbz
	8nRAgfqpBHIAwif9GP7paM+OQreJDTc=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64K6ocj8834424;
	Wed, 20 May 2026 15:40:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=3c0nvh5itwhP8hGgK
	l3AyRHknls54+T11C0TpI4uHJU=; b=hnHCkeicm0I/sdvIH+wOiMqWtFt9Ym/9e
	GaQFCntaAWNj/7/wKKp7ghBZa4R10xCcR5mhf0ylNF2jickqohLLf0suv+QhfDxX
	riw86hdg0rIJbhbvatdfD0Zdfn9JFiPU9ZBTqQ4CAumUF654AnPzTQpu72BgEK38
	xnc9qMMEOcppxyQeYUWvq/8kUivh0aX4+9CGiVrvcYs3xVZozVaMAHvOX6z7lHWQ
	7Hky/gMUIU7oDFulZi/GSmQXFn4cBBtxfcDE6c0Q+k6DDXYVrFKxNERuJn6DoFMS
	HqJHscKbYF/NvlsHh5Iq7v4EFscTZzTp+nnH4mLutkAkYH/KLbRSg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h8mtspu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 15:40:18 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64KFd4dP024644;
	Wed, 20 May 2026 15:40:17 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e72wq871t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 15:40:17 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64KFeDce49217850
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 May 2026 15:40:13 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B13E720040;
	Wed, 20 May 2026 15:40:13 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 28CEA2004E;
	Wed, 20 May 2026 15:40:13 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 20 May 2026 15:40:13 +0000 (GMT)
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
Subject: [PATCH v15 11/20] unwind_user/sframe: Show file name in debug output
Date: Wed, 20 May 2026 17:39:55 +0200
Message-ID: <20260520154004.3845823-12-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260520154004.3845823-1-jremus@linux.ibm.com>
References: <20260520154004.3845823-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: nOGEipXW_Vq4kLBKw8DEOnaegiLq7WTj
X-Authority-Analysis: v=2.4 cv=GYMnWwXL c=1 sm=1 tr=0 ts=6a0dd5e2 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=pfo6fe6KaiqNJ1UUovoA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-ORIG-GUID: tAQjVecBoP-dCCoo7L_C0wBnG0GrfXMA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDE1MSBTYWx0ZWRfXxJNpDQlYKZnC
 TBYNRBK75HFL20RcXOaKHoMyEFWef7YDs42GyablNEycjMtQixsgLIYaiy8w4Erewww6HIkl/O7
 hziswLCOT8RDnNEwpNUf5G1xqW0wXPwo6ffa8K3o/Qz37cnrTsvISx2EbS8ja4zzWmIWodJ/eG4
 G23qcbbwZ1hLeaifW58Qfm7qfNAiTBxcX+iZ3b451kQVYxUpdCvLx3AvdTtN/dHgLtymDgvDMVN
 WPyD5BL50ruvn+Bkw2Qq5yNz/qK2D0rVv8yW8xvtdzpDRwKaUIdRY/JjbAq2E/71CuSVDnyKtdW
 1+golc23P3PrSYt8eDcNA6al5nuW2XHq+Pw4OoQyViVYJlIvj11UD818J9XZVsBlozQ3DgzceUx
 v0miDnRbyMReg6kCkxOePDmntXRHIafDrVMpPcaXaIRb6JXYGVlf29l7n7Hi/w7LeC4SebJam/S
 xZCmMl4D0l6RB9tNraw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605200151
X-Stat-Signature: 4ka3x8ry4331nt9jzfueyri9todeku17
X-Rspamd-Queue-Id: 44FF2A000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779296070-538716
X-HE-Meta: U2FsdGVkX1/iNu/hK6y6mEqC6YjtYKCmnQqzwBZksNB3oJ1r4PEL7ZPm3y90hHpcWuaCnXDeJ1POeONW6syrFkTfQKQ3yqTF2/+U4Q3dRYorhigddszlT6SCcytvKkN9KALT6NR5aADswMyBIWgkuUQqmMI0xt/G+kw7DERQghD4MkMKY0gXPRu2qY/o9RATTDHrEFm7wVLIQ/MACInuoZbYJbcYGEJGX8pGKO+QgnaDOnkX0XbZFmiPUcSTW7QYEzkr4Kgje4nvwlR9xY45/ot5UMceFKOdlvqI6gqWG0VzNdVHjOKoWXKdXpZtVf2jBXZeJxb6HYWr6pQqeZM2TXW4OVMf88A7ZLj0U4lzYBhzNWjIhap1e2V7txJYE3D74Gk2EvM7Ici+pDVGgvapwNbWk+qae40aHmryp6D96+sZKRWL4J7b3NHAq19gchqHIPyYRxpzP/CGDC8aYTyND53DI/hSEsIoQGJMiwwF06puPCe29QFaHAKiGE634vJDjKKf874q2HrjxfVhMGYwejVemCSX7g0yrqyhWXQZifita84TDu8dadJ5dkcJPqOyAw+L0Po6gCdSH7Ob2jRFcF0u2wNxo5aKK4i1nLB4Yq+1ZAKWW8eN7hAIiT5yoVGk/deoKE+ekCZJ03yDEniqOPSzL6u5QdEjrq+BaeSQ3ntETGJmvRDwKAJIYK2kUB3ENZ4kgTK1GwG69ysg8sPuww72ruqGv7j3hA4Dg/pSLVNqiTQ3CyutwKgSO97WV+E7BiWfR0gtKAZaN3QugChx7/1lRwbMxst9LEjR2yKKnbjezHDyLAmt6nMqh6biTvWElb1YFql49dk6RnN7VR78rOn8WqdubbQ1OTOTI/Y0STZy7Co+pMAsNkMTHei9i0BGeRM26Tg4rkBeoSPdPlT4161Je1k2HszBINdgBxR+nfCD1V73X4S7KOD5q8IZPUwcbShzz9jZnPKz5emhmTR
 EX+GfJjl
 N6mYwA2aNpv9Ll3eOeqTFnFfn8cEWY05YHK2PLvShlKWFpOJGFd0xXykXhrh7VuYThDJj9LMm6Cgp/nyXVl4dloOrTsjJt5IBqtZTcjyDGaKW67kHVS3GcfTO5QZ8wf8bPEA3A93r812QacfXuo6kyIErk1zeOd5YdxMNbCj4QAVU/vSwgEter1snQEFhtNBm6aQeW2ARpP6DRPZKA5HbW6mO5cpuofNqI1hGJQXde7Inn3d3f1D41bJ4h/LWY7jQpW7kgJpbFcQHUFeumnH9n9OkNzeQWmtq3E598HJiuQTpLv0aapFZIsmFNZCTVzB7Y5mt/orTVp2l/9teKTmyRNinAqYjl6U270k7l4oZ7sMaWEQ4M2QesEGXRVDjl9ukm1xkT2AyRZglVFqzqUL7iU6y7gelnm76oOG1JpOOn4QOl85I85sQkke1jZfxAFJMNYuY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

When debugging sframe issues, the error messages aren't all that helpful
without knowing what file a corresponding .sframe section belongs to.
Prefix debug output strings with the file name.

[ Jens Remus: Fix checkpatch error "space prohibited before that close
parenthesis ')'". ]

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Indu Bhagat <ibhagatgnu@gmail.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    Changes in v15:
    - Use GFP_KERNEL_ACCOUNT instead of GFP_KERNEL (see
      memory-allocation.rst, section "Get Free Page flags"). (Sashiko AI)
    
    Changes in v14:
    - Uppercase terms FDE and FRE in debug messages.

 include/linux/sframe.h       |  4 +++-
 kernel/unwind/sframe.c       | 23 ++++++++++--------
 kernel/unwind/sframe_debug.h | 45 +++++++++++++++++++++++++++++++-----
 3 files changed, 56 insertions(+), 16 deletions(-)

diff --git a/include/linux/sframe.h b/include/linux/sframe.h
index 9a72209696f9..b79c5ec09229 100644
--- a/include/linux/sframe.h
+++ b/include/linux/sframe.h
@@ -10,7 +10,9 @@
 
 struct sframe_section {
 	struct rcu_head	rcu;
-
+#ifdef CONFIG_DYNAMIC_DEBUG
+	const char	*filename;
+#endif
 	unsigned long	sframe_start;
 	unsigned long	sframe_end;
 	unsigned long	text_start;
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index 02331956009a..f931932bd34a 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -374,14 +374,17 @@ int sframe_find(unsigned long ip, struct unwind_user_frame *frame)
 	user_read_access_end();
 
 end:
-	if (ret && ret != -ENOENT)
+	if (ret && ret != -ENOENT) {
+		dbg_sec("removing bad .sframe section\n");
 		WARN_ON_ONCE(sframe_remove_section(sec->sframe_start));
+	}
 
 	return ret;
 }
 
 static void free_section(struct sframe_section *sec)
 {
+	dbg_free(sec);
 	kfree(sec);
 }
 
@@ -401,7 +404,7 @@ static int sframe_read_header(struct sframe_section *sec)
 	BUILD_BUG_ON(!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS));
 
 	if (copy_from_user(&shdr, (void __user *)sec->sframe_start, sizeof(shdr))) {
-		dbg("header usercopy failed\n");
+		dbg_sec("header usercopy failed\n");
 		return -EFAULT;
 	}
 
@@ -410,18 +413,18 @@ static int sframe_read_header(struct sframe_section *sec)
 	    !(shdr.preamble.flags & SFRAME_F_FDE_SORTED) ||
 	    !(shdr.preamble.flags & SFRAME_F_FDE_FUNC_START_PCREL) ||
 	    shdr.auxhdr_len) {
-		dbg("bad/unsupported sframe header\n");
+		dbg_sec("bad/unsupported sframe header\n");
 		return -EINVAL;
 	}
 
 	if (!shdr.num_fdes || !shdr.num_fres) {
-		dbg("no fde/fre entries\n");
+		dbg_sec("no FDE/FRE entries\n");
 		return -EINVAL;
 	}
 
 	header_end = sec->sframe_start + SFRAME_HEADER_SIZE(shdr);
 	if (header_end >= sec->sframe_end) {
-		dbg("header doesn't fit in section\n");
+		dbg_sec("header doesn't fit in section\n");
 		return -EINVAL;
 	}
 
@@ -433,7 +436,7 @@ static int sframe_read_header(struct sframe_section *sec)
 	fres_end   = fres_start + shdr.fre_len;
 
 	if (fres_start < fdes_end || fres_end > sec->sframe_end) {
-		dbg("inconsistent fde/fre offsets\n");
+		dbg_sec("inconsistent FDE/FRE offsets\n");
 		return -EINVAL;
 	}
 
@@ -489,6 +492,8 @@ int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 	sec->text_start		= text_start;
 	sec->text_end		= text_end;
 
+	dbg_init(sec);
+
 	ret = sframe_read_header(sec);
 	if (ret) {
 		dbg_print_header(sec);
@@ -498,8 +503,8 @@ int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 	ret = mtree_insert_range(sframe_mt, sec->text_start, sec->text_end - 1,
 				 sec, GFP_KERNEL_ACCOUNT);
 	if (ret) {
-		dbg("mtree_insert_range failed: text=%lx-%lx\n",
-		    sec->text_start, sec->text_end);
+		dbg_sec("mtree_insert_range failed: text=%lx-%lx\n",
+			sec->text_start, sec->text_end);
 		goto err_free;
 	}
 
@@ -521,7 +526,7 @@ static int __sframe_remove_section(struct mm_struct *mm,
 				   struct sframe_section *sec)
 {
 	if (!mtree_erase(&mm->sframe_mt, sec->text_start)) {
-		dbg("mtree_erase failed: text=%lx\n", sec->text_start);
+		dbg_sec("mtree_erase failed: text=%lx\n", sec->text_start);
 		return -EINVAL;
 	}
 
diff --git a/kernel/unwind/sframe_debug.h b/kernel/unwind/sframe_debug.h
index 36352124cde8..a63e75cccc70 100644
--- a/kernel/unwind/sframe_debug.h
+++ b/kernel/unwind/sframe_debug.h
@@ -10,26 +10,59 @@
 #define dbg(fmt, ...)							\
 	pr_debug("%s (%d): " fmt, current->comm, current->pid, ##__VA_ARGS__)
 
+#define dbg_sec(fmt, ...)						\
+	dbg("%s: " fmt, sec->filename, ##__VA_ARGS__)
+
 static __always_inline void dbg_print_header(struct sframe_section *sec)
 {
 	unsigned long fdes_end;
 
 	fdes_end = sec->fdes_start + (sec->num_fdes * sizeof(struct sframe_fde_v3));
 
-	dbg("SEC: sframe:0x%lx-0x%lx text:0x%lx-0x%lx "
-	    "fdes:0x%lx-0x%lx fres:0x%lx-0x%lx "
-	    "ra_off:%d fp_off:%d\n",
-	    sec->sframe_start, sec->sframe_end, sec->text_start, sec->text_end,
-	    sec->fdes_start, fdes_end, sec->fres_start, sec->fres_end,
-	    sec->ra_off, sec->fp_off);
+	dbg_sec("SEC: sframe:0x%lx-0x%lx text:0x%lx-0x%lx "
+		"fdes:0x%lx-0x%lx fres:0x%lx-0x%lx "
+		"ra_off:%d fp_off:%d\n",
+		sec->sframe_start, sec->sframe_end, sec->text_start, sec->text_end,
+		sec->fdes_start, fdes_end, sec->fres_start, sec->fres_end,
+		sec->ra_off, sec->fp_off);
+}
+
+static inline void dbg_init(struct sframe_section *sec)
+{
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma;
+
+	guard(mmap_read_lock)(mm);
+	vma = vma_lookup(mm, sec->sframe_start);
+	if (!vma)
+		sec->filename = kstrdup("(vma gone???)", GFP_KERNEL_ACCOUNT);
+	else if (vma->vm_file)
+		sec->filename = kstrdup_quotable_file(vma->vm_file, GFP_KERNEL_ACCOUNT);
+	else if (vma->vm_ops && vma->vm_ops->name)
+		sec->filename = kstrdup(vma->vm_ops->name(vma), GFP_KERNEL_ACCOUNT);
+	else if (arch_vma_name(vma))
+		sec->filename = kstrdup(arch_vma_name(vma), GFP_KERNEL_ACCOUNT);
+	else if (!vma->vm_mm)
+		sec->filename = kstrdup("(vdso)", GFP_KERNEL_ACCOUNT);
+	else
+		sec->filename = kstrdup("(anonymous)", GFP_KERNEL_ACCOUNT);
+}
+
+static inline void dbg_free(struct sframe_section *sec)
+{
+	kfree(sec->filename);
 }
 
 #else /* !CONFIG_DYNAMIC_DEBUG */
 
 #define dbg(args...)			no_printk(args)
+#define dbg_sec(args...)		no_printk(args)
 
 static inline void dbg_print_header(struct sframe_section *sec) {}
 
+static inline void dbg_init(struct sframe_section *sec) {}
+static inline void dbg_free(struct sframe_section *sec) {}
+
 #endif /* !CONFIG_DYNAMIC_DEBUG */
 
 #endif /* _SFRAME_DEBUG_H */
-- 
2.51.0


