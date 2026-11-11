Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92308606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 12:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=gekFgyps
Received: by kanga.kvack.org (Postfix)
	id B94766B05B4; Wed, 11 Nov 2026 07:43:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B45126B05B5; Wed, 11 Nov 2026 07:43:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0D546B05B6; Wed, 11 Nov 2026 07:43:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7859B6B05B4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:43:53 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1948AA7AD9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:43:53 +0000 (UTC)
X-FDA: 85422805146.02.43706B8
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf07.hostedemail.com (Postfix) with ESMTP id B85D540004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:43:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=gekFgyps;
	spf=pass (imf07.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794401030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qYmz3GqjaSkvnipcM4i+09arVtFA8YFo71Bfz4OiDvc=;
	b=m95w4sL2G8T8sDVTLB0auZcpyzSerxzTZjE+J0zKfTCXhJ7TLWe8dkk3aqYUnxoqJk9/li
	IOTmDDF1LTWgQXOvNLA+fq9WqkI/WQhvYATj8QV9C1jf23r365/uLMUEdcbhrq1qCZCAmB
	SUVadrgYwO+WbMjVgDZBQn0T8O9sy3w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794401030;
	b=jgohZkxLyK1R3ZLzQ71VkTwb8bgoMa2tjaODmiwTYGVzkQ9DMNFsPSYxr7aEdU8SimKMln
	l8ZTwHtWGLjxGfSNd4afQ9AJb54ovdzZ5jkMi2M9Kdj3OPHSG6f+jFekf6ejbnsDsT7cH6
	5UCLA5pwazlWnrp0PFd9zE5sgTx1S1k=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=gekFgyps;
	spf=pass (imf07.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AB5isfI3261993;
	Wed, 11 Nov 2026 12:43:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=qYmz3GqjaSkvnipcM4i+09arVtFA8Y
	Fo71Bfz4OiDvc=; b=gekFgyps+6BXMV2e0xzxTGfWuXeeX+C/k7LecAnE+KOyv1
	R8rp2Pia5MuDdRIjbbwQ2IUdbuCcfPmFfU1WaGYxjwCuQUi9BFcrk6uhgUbBcwQT
	afmwRcLda6sekLhCjy6+/b6ekIMw2g6OlGthF/vJtnfIzyTfyAIuynTLUJzvpLI5
	L7f2Jekcv4lkD8/obmk2pSrgNDE5Kf4ad2MGdwKA/yj2cEEK9Rib6BNHEaZ+IpXE
	u4CW81iVBH6xFxrVhf1n0gZpTQ+NUUAtOIaRYWGH8KRD25wdzPzi4pJipTvXiLJc
	K6zXPJmlFjKIbJWGZgY5q3oMsFs3gDTLwNH6RgXA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hstdg9h43-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 12:43:35 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABCYtVV3286275;
	Wed, 11 Nov 2026 12:43:34 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hv3324f04-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 12:43:34 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6ABChUs928508500
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Nov 2026 12:43:30 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5C3752004B;
	Wed, 11 Nov 2026 12:43:30 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F41E620043;
	Wed, 11 Nov 2026 12:43:29 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.68.17.117])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 11 Nov 2026 12:43:29 +0000 (GMT)
Date: Wed, 11 Nov 2026 13:43:28 +0100
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Elver <elver@google.com>,
        Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Steffen Eiden <seiden@linux.ibm.com>,
        Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>,
        Andreas Grapentin <gra@linux.ibm.com>,
        Finn Thain <fthain@linux-m68k.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Hildenbrand <david@kernel.org>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
        linux-mm@kvack.org
Subject: Re: [PATCH] [RFC] instrumented.h: mark instrument_write non-const
Message-ID: <9e0db1c6-a637-4fb1-b6ad-db22fd3ddbc9-agordeev@linux.ibm.com>
References: <20261111092231.2027735-1-arnd@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111092231.2027735-1-arnd@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=J+M/fwnS c=1 sm=1 tr=0 ts=6af462f7 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=h2GPdUkYvjar_X7b29IA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA0OCBTYWx0ZWRfX0upqQ5ce/Pm+
 wTrum7/HgBFv8XhZO3BP3hLfar++ZFblLByUZG8stu7JQmxBSr8RAaMRh+1ifcAwH/1gjI0z/F+
 6g8bdmY4uCwkrxpHgulA002qcNWKnD/PgEv0b8NWqGRYlp+YVwsyeKk6VFJ25PqEMQ9UhKIXymM
 CK74sVW4BPyMIVgTOjsdkaY/7/i6kcwfR6uxwgS5CCNEmkKVPNyFOsPHySE2uZHOInES1veLb63
 F4DybHIQPr1rTL9ksbRHAY7NOvZBMYqBKE4QiSxp2kZkMGfQddxvOHglGmXWSFjqOmMUwWe3Tv4
 2H3Ka9+xY9U9WqTkJyHCwdhcjkTojnh46V33YlHL4mbUEbtGvJ4ez7hc29kfgTMUXuDWXB4kYQj
 9KXUJacbJ+gUb4TLf2laayvHLO2i2Fg3anUxlHigxd93V3dRTDYLbkdiY/9hf46gNnicg/louNy
 g9gecn/t13QG+cmfkcw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA0OCBTYWx0ZWRfX852uAGi5PYiZ
 nsPkzATZy9mjHgTD4CjcAlWKU+nL19wJFYMIf81nhtsi7v18sJRwh1HwAnjLRLdR1x/vvoLQnpk
 8L1ITUuw8OvS3WicjbnkiBAysNXEnVs=
X-Proofpoint-GUID: ceIP_O8HdMhCYCYezPPo4tpjndDBOFMa
X-Proofpoint-ORIG-GUID: FUoKXVp3UpAvUAi1zykgiJVGwuylwcXF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-11_02,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 adultscore=0 suspectscore=0
 malwarescore=0 clxscore=1011 priorityscore=1501 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611110048
X-Rspamd-Server: rspam06
X-Stat-Signature: 4u9k3j45ig1fiwa15qmikms4mot7g8sr
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B85D540004
X-Rspam-User: 
X-HE-Tag: 1794401030-545972
X-HE-Meta: U2FsdGVkX18yoCGDFTBsP1i5AhtPAL7+sN2Dq8u3cDr89dm5sKwR86O2QoN6+ujT/qdqyq1TSzxz6DiV6RiXoLG8tGJ3KYduCY6Igitl5JqPSemn/Nf3Oz7L4lFQt5qwK5ozk9PZjh0U86xFSwA/BPTAhCiKC+4b71OONsEHKo7SHZQiy7nrOf+07OsAdsN8kYF8sZjHgE5XyL8GXBgguo4ZjulHSdzR/kzychdbvLtw5dshqiALN7sPtGo3Gc7hpxxQkzDRVPKN9jtHxEjugM8CXuIdU58FD7G2e4XtMKXbjIUAv56Fv3CD+Kc5imqkmFYhMw3yqEtvr7sGLm4v7VGIiAEgZB2j//SpvFKih2po0GY9QASOrXLJqkNKUEBx9f26HhW1tk8jqtcBz5jTwioo7nzW/mjAE/lYj5TCf+IZfjQI/9+CkHLm03R4IxUV7mvYNOnYLQQadpeVpjTv+8d/nukOs8MbtKBDiDJ+mHK5kUgwcSJXZnVQ9tqAR7e+grbVSlku93pTEDuzTOHPMqx6Yz1u5cDU58QbYJqcHuN5s8vT1HILYqHbMGZDNgB7oLkfFNLajrl1U4hejUsTvVMRYvClbx3E1iV64tlVYUsRptN1wWw/T58tznY0mEdST1XufTdnPJvk4/SnofXXVZPgKYDBnSt1D4xSC1d1ZzULV5v1VuKcYPYh3HsVLhiQqgUVNfpDSCuU0Dex0uBQfRuBIfZzPbm8RW8xV7thlkJsYSfWi2Fn9kj7n0CuYV+pA+w88redVyubYyTakkfQPlMTli4KAXOHeshK4Ep7+ZlHZ8O6VwGvskTs2VbdAAncne0aV72W7HyCCiC4/rb6I7sKHTIG98Lc9UmRJPprujezofnpYpetUxMQTrzPFAKxMD/qRMxlXN0D+YwTMKKlsnPguXTAPDYIn9q6Dpp31zquuG9tdEdnnrlUB7XBugurrrtVkkvSWry7QoTOY2/
 hB1fgS6+
 qETA9+r69I4Xf2B1aCqAqtrgVjBkfTJQYPxN3mmMDuaFHPGEuUbn6cNAueh0T+r44aMQlvDKN6yv+F+dybkY81ihJr6n7pt722IJniKV797pyFksDTqqvKcgBp/BmIIyB8MKMKUMv//XAMjdhZ5t8yKpg3loQxWe8EBaxacdqGIVBgtIrCGGJEu/0zk8xY2bNZOHr+vN14mlgDVmeOt3wYrJmMkkbP55Hb+eSt4VwXuF9cjE63qVbVuUGwkmWSsnJz2KeBVx2K6gJlE9cjtquleBA0lIBBgg9zKN2X/30Iry8h+lPqRar2S4YjtzJkPt464UTRviJViezE1fdgeUy2Px+B3snawy/6eTxv0p+zixOPSpus+9YoVdBLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 10:21:31AM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> I got another instance of a -Wmaybe-uninitialized in ntfs, as this is
> the only place that enables the warning:
> 
> In file included from include/asm-generic/rwonce.h:26,
>                  from fs/ntfs3/file.c:10:
> In function 'instrument_copy_from_user_before',
>     inlined from '_inline_copy_from_user' at include/linux/uaccess.h:184:2,
>     inlined from 'copy_from_user' at include/linux/uaccess.h:222:9,
>     inlined from 'ntfs_ioctl_fitrim' at fs/ntfs3/file.c:78:6,
>     inlined from 'ntfs_ioctl' at fs/ntfs3/file.c:246:10:
> include/linux/kasan-checks.h:38:27: error: 'range' may be used uninitialized [-Werror=maybe-uninitialized]
>    38 | #define kasan_check_write __kasan_check_write
> include/linux/instrumented.h:146:9: note: in expansion of macro 'kasan_check_write'
>   146 |         kasan_check_write(to, n);
>       |         ^~~~~~~~~~~~~~~~~
> include/linux/kasan-checks.h: In function 'ntfs_ioctl':
> include/linux/kasan-checks.h:20:6: note: by argument 1 of type 'const volatile void *' to '__kasan_check_write' declared here
>    20 | bool __kasan_check_write(const volatile void *p, unsigned int size);
>       |      ^~~~~~~~~~~~~~~~~~~
> fs/ntfs3/file.c:66:29: note: 'range' declared here
>    66 |         struct fstrim_range range;
>       |                             ^~~~~
> 
> The problem here is that copy_from_user() is called on an uninitialized
> object, but the instrumentation passes the pointer into a function that
> takes a const object. gcc deduces that any access to that object is
> undefined behavior and warns about it.
> 
> The only workaround I could come up with is to remove the 'const' keyword
> from these annotations, which of course is not great either, as the
> functions do not actually access the data at all.
> 
> This also found incorrect 'const' annotations in
> arch/s390/include/asm/fpu-insn.h, which writes to those pointers.
> 
> Any ideas?
> 
> Fixes: 33b75c1d884e ("instrumented.h: allow instrumenting both sides of copy_from_user()")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/s390/include/asm/fpu-insn.h |  8 ++++----
>  include/linux/instrumented.h     | 10 +++++-----
>  include/linux/kasan-checks.h     |  6 +++---
>  mm/kasan/shadow.c                |  2 +-
>  4 files changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/s390/include/asm/fpu-insn.h b/arch/s390/include/asm/fpu-insn.h
> index aaf1faeb3dc5..7cd6e9f30485 100644
> --- a/arch/s390/include/asm/fpu-insn.h
> +++ b/arch/s390/include/asm/fpu-insn.h
> @@ -359,7 +359,7 @@ static __always_inline void fpu_vsrlb(u8 v1, u8 v2, u8 v3)
>  
>  #ifdef CONFIG_CC_HAS_ASM_AOR_FORMAT_FLAGS
>  
> -static __always_inline void fpu_vst(u8 v1, const void *vxr)
> +static __always_inline void fpu_vst(u8 v1, void *vxr)
>  {
>  	instrument_write(vxr, sizeof(__vector128));
>  	asm volatile("VST	%[v1],%O[vxr],,%R[vxr]"
> @@ -370,7 +370,7 @@ static __always_inline void fpu_vst(u8 v1, const void *vxr)
>  
>  #else /* CONFIG_CC_HAS_ASM_AOR_FORMAT_FLAGS */
>  
> -static __always_inline void fpu_vst(u8 v1, const void *vxr)
> +static __always_inline void fpu_vst(u8 v1, void *vxr)
>  {
>  	instrument_write(vxr, sizeof(__vector128));
>  	asm volatile(
> @@ -385,7 +385,7 @@ static __always_inline void fpu_vst(u8 v1, const void *vxr)
>  
>  #ifdef CONFIG_CC_HAS_ASM_AOR_FORMAT_FLAGS
>  
> -static __always_inline void fpu_vstl(u8 v1, u32 index, const void *vxr)
> +static __always_inline void fpu_vstl(u8 v1, u32 index, void *vxr)
>  {
>  	unsigned int size;
>  
> @@ -400,7 +400,7 @@ static __always_inline void fpu_vstl(u8 v1, u32 index, const void *vxr)
>  
>  #else /* CONFIG_CC_HAS_ASM_AOR_FORMAT_FLAGS */
>  
> -static __always_inline void fpu_vstl(u8 v1, u32 index, const void *vxr)
> +static __always_inline void fpu_vstl(u8 v1, u32 index, void *vxr)
>  {
>  	unsigned int size;
>  

Acked-by: Alexander Gordeev <agordeev@linux.ibm.com> # s390

