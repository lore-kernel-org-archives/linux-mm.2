Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53F3ACD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:26:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 603346B0098; Thu, 21 May 2026 10:26:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DA2D6B0099; Thu, 21 May 2026 10:26:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42D726B009E; Thu, 21 May 2026 10:26:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 258D16B009B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:26:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A7489160E66
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:17 +0000 (UTC)
X-FDA: 84791651994.28.970D327
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5C0022000C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Zd5Rh94G;
	spf=pass (imf13.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779373575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RJbYLbBCunARAkexCBPIaYfKkGr0g5Hp8xsvdMvOuGE=;
	b=5Gw/Y+tcvUZIZKz93PvVQbykZ+ZdrrDmXl2fTPDN0v49jGkzOvS5AFalRYAZXi/vDjvn3v
	7sBvyiUgt2e5P4XC9ahgTC/woMAyDy+VuPo5IzzzHejwzo5VO2UdqSEhhOpMOfOYXTUj9v
	cPmLiGnbWYkhbIgSmurjCua30mXfBMY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779373575; a=rsa-sha256;
	cv=none;
	b=AFP/oNV5J0/jFebPIe31cQRfsT3P7Fgd1T7jCmMVCdi77GPUhI29fC79lxLUud5m1QmMjk
	UfKf6LlBq2C7hyj9monh5wkMsdNdkwo7dns9aM+llyOA79x2znGAFnALqPwwNHUNogOEWf
	PuxQoid5wBO6Dc1nJgxEclndvRfa3x4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Zd5Rh94G;
	spf=pass (imf13.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64L1SiTa811826;
	Thu, 21 May 2026 14:25:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=RJbYLbBCunARAkexC
	BPIaYfKkGr0g5Hp8xsvdMvOuGE=; b=Zd5Rh94G9FCHJnhpZV0UgyKUGJItK+Qj4
	O1TmsLPKDat0LuPY2lpo3uhjWdjSBQL6KPAdPxIsIjR1zAK6BM4wZtqCwKqffeZN
	AnRLrwra7O5qL6wxIYxUxQb8QTn32xzeZ10MAuBpRw0QrerLkITdvdqewkLULdyi
	LU+f7Zk29HC+Jwu07u/3Y6eqlPSGhqJh3kJvkCRQ3I+02PTQO0oaXWLNMSN5V9Ar
	u2LHDsFWr0IwMHWbs1y/4WWroa4QewvE5ApmqM3ygldhbDgNSm2CUhtdoO6gWwHu
	6jptL//dU6SgtM0HV9EtSaIPPrRfGg+YGE/eKr85Z+dxcoGWvzccQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h88p6fn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:57 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64LEOCmd031749;
	Thu, 21 May 2026 14:25:57 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e74dhvg7e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:57 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64LEPrFl51118430
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 14:25:53 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7D99D2004D;
	Thu, 21 May 2026 14:25:53 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1E2EC2004B;
	Thu, 21 May 2026 14:25:53 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 14:25:53 +0000 (GMT)
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
Subject: [PATCH v16 11/20] unwind_user/sframe: Show file name in debug output
Date: Thu, 21 May 2026 16:25:37 +0200
Message-ID: <20260521142546.3908498-12-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260521142546.3908498-1-jremus@linux.ibm.com>
References: <20260521142546.3908498-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: OG6_1GvXnp9XCYBYePjMSPCRFU8PQ7o9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDE0MiBTYWx0ZWRfX7alz74T3v5dF
 MizONbWUXel8uRV5y7xi7S0CKnUqNuA8/0XW7woDrzT3AJjJfglEBJ84+YyDXc3rrD+r96iMFLV
 cI6i4aENuRYKdfPHwl0vqnPO6N5kARzC1dXlSQbdqJvHjXPUwgzay14W9QTRNJX3O3fbIU+/bfV
 7cKGYWjMjJEY3fktrh/5R1HS9Wh4V0EmwPCr/1n2E1+KNiGYpPnmViLc6JyNwLqnnY2ZdJLFfyF
 xyJp/il0OQNrubRgjM3LnsFzmcrKNdc7uOJblw5e8nFYmvhlBoTF08NY8RLChp8TKFt/BUrztzi
 brNxseVz5Dta7DuGFI4U4uLz6yAyMshk9ty+p1XX7WDT85jdBVtLwwTCG2ZGgugxQFKNRigZqNQ
 0UBG47CF2XD/mp+fR5rSC5wFPtkYowbK6xlmi4O8xfWD8pU7xaqrJWFLVGmzyniTym/3jnAzZPH
 MbFLejO1z0FOoXHqg9Q==
X-Proofpoint-GUID: qquEerBesUTiIF3hcpHY_IsFPH1JTuMj
X-Authority-Analysis: v=2.4 cv=apyCzyZV c=1 sm=1 tr=0 ts=6a0f15f6 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=ySwrbc1SU130mKywBQUA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 phishscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605210142
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C0022000C
X-Stat-Signature: opwd7zefc9asxj51k8wiqe9ay9ibgtz3
X-Rspamd-Server: rspam06
X-HE-Tag: 1779373575-17861
X-HE-Meta: U2FsdGVkX1+tvqDk7WMP+xEzyGyQ75hAZqOBN1qlEhhqa2VRKa3LWZsvnDIkmx9lvH9BPavP7kOZEs7RpX7OYuzAuaskgQyLlrvICpLlYD2FJLjEfwRw5V+Q3rfCKWzGU0Eab1BPOEjBG61/Xkm1Zw4O7l9sL8p0RAPMd+fVwsDTuepcg+KkDUBYCDzOBQwF6tD0BmpsIENU3Wg0iYJsvlvAV/d6dZNg0z79Rr/9TLvjNofHl6kt5uEUJr7qZxHeneckdkBEqmZFYxvlevp8Cs/TBG814aUeRCzXJ7uMiroZz8jvwiu4DxYOxhs2AIOvIPLwYLGWyjJTcb/caQ8vbbwOtgToL9DOEDpMVN80KmpBPdDk4kr0DP90M7W0/VXTPwx0qpbSVtHVlTI1Twk9J5OpQlka6PLGWXO/TcHI7zATr0OeQyD5HnBP9/lYAQ2CAh5nvPv/Qbd1cGb/0IFsfOwUshKYF3Osno8L8DSNmlS4RG0suTWBVN7wHe4YtJN3LgWz+erlGE36cevNTGG2e2yMKmvBWui4yl+AfonCDV8bW9P+6wbM8YauRkfgUnRfi5Mz+qarTUaHbsN2dfhcCqZ+7EWAJQ3AEjFtyxB4v8BZ6NKZ7JYdJPulD+yx2C9fCU53OpPwCqDYbXSWkUDw1Gms6aB9igF+S90ED13ZXUVzO9m/bH+RZDmXE+j59kzNAZbIUJIPcQ4thgG7gYrANUHWjEx6N7XI0zcrwNwhHBABux3dh0DCphDjIwGEYcATJeIyfKoHd4MFvbSIo5A/Fb/kEitTwijZYwuqb3E5gnBqZOz6NQT61MtCxH0KkLbUkvtTcU8mEw7TqtJZZGPtQCvyrcSrvkUrLeNd31WetCpMx9z7DDIZ62kE2prd5wCUCF2Ew8ia24wGu/xPjiKAn62IJVXIETM7n5xmK+wmgcJGNxgNzsjOABLG9vhtU7aD1HGomay9IhB+a8TsGAR
 vsZZ0xSl
 esUIJkkkDgD6nQAoYkaUPQ+etxY4BLT4jbCDe7ffxiYs0Sx7ug1Ug4ixEegF43+YSE3bxxEjXZDpbMtxZOY0r7/+O4q3tcdHz0yJHj6pdWDtsxb/1Q71JMv31lSX+ADUbqbGM0End74xuwhf066sLBMkob2sQLafoysiJxc8IAAZfYrv7KdjknqrcU3SlcP6p0fl2ylhTRvLO/qIkeY1yMDWkLxzRJBLONWC1edt5q/noUnlz6qLLl5mKgc+BCdagubYeXdmUGWcB2TcIWlOhIHkP/2cbzETu+teimNXLw6sewy+i/1/DG5nodXQvUOClGY3xTxuO/ILc6sbte+SdxNpLOd4cxlEO0X0dGy2g7EI5m38i7516NwupsUfgOS5UyXqRVj9lh/ZhALQ=
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
index e0eb2adf5a07..2cfa274cd8dc 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -372,8 +372,10 @@ int sframe_find(unsigned long ip, struct unwind_user_frame *frame)
 	}
 
 end:
-	if (ret && ret != -ENOENT)
+	if (ret && ret != -ENOENT) {
+		dbg_sec("removing bad .sframe section\n");
 		WARN_ON_ONCE(sframe_remove_section(sec->sframe_start));
+	}
 
 	return ret;
 
@@ -384,6 +386,7 @@ int sframe_find(unsigned long ip, struct unwind_user_frame *frame)
 
 static void free_section(struct sframe_section *sec)
 {
+	dbg_free(sec);
 	kfree(sec);
 }
 
@@ -403,7 +406,7 @@ static int sframe_read_header(struct sframe_section *sec)
 	BUILD_BUG_ON(!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS));
 
 	if (copy_from_user(&shdr, (void __user *)sec->sframe_start, sizeof(shdr))) {
-		dbg("header usercopy failed\n");
+		dbg_sec("header usercopy failed\n");
 		return -EFAULT;
 	}
 
@@ -412,18 +415,18 @@ static int sframe_read_header(struct sframe_section *sec)
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
 
@@ -435,7 +438,7 @@ static int sframe_read_header(struct sframe_section *sec)
 	fres_end   = fres_start + shdr.fre_len;
 
 	if (fres_start < fdes_end || fres_end > sec->sframe_end) {
-		dbg("inconsistent fde/fre offsets\n");
+		dbg_sec("inconsistent FDE/FRE offsets\n");
 		return -EINVAL;
 	}
 
@@ -491,6 +494,8 @@ int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 	sec->text_start		= text_start;
 	sec->text_end		= text_end;
 
+	dbg_init(sec);
+
 	ret = sframe_read_header(sec);
 	if (ret) {
 		dbg_print_header(sec);
@@ -500,8 +505,8 @@ int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 	ret = mtree_insert_range(sframe_mt, sec->text_start, sec->text_end - 1,
 				 sec, GFP_KERNEL_ACCOUNT);
 	if (ret) {
-		dbg("mtree_insert_range failed: text=%lx-%lx\n",
-		    sec->text_start, sec->text_end);
+		dbg_sec("mtree_insert_range failed: text=%lx-%lx\n",
+			sec->text_start, sec->text_end);
 		goto err_free;
 	}
 
@@ -523,7 +528,7 @@ static int __sframe_remove_section(struct mm_struct *mm,
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


