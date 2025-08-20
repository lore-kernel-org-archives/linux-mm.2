Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BE14CA0EEB
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 01:05:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2E3D6B00B5; Tue, 19 Aug 2025 21:05:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A05F16B00B6; Tue, 19 Aug 2025 21:05:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91B7D6B00B7; Tue, 19 Aug 2025 21:05:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8151D6B00B5
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:05:10 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 31683B817E
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:05:10 +0000 (UTC)
X-FDA: 83795341980.28.1C9804A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id F1EF740004
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:05:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TsJWzzK4;
	spf=pass (imf27.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755651908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=joAKDyFfJF1Jn1BV6nqdFRNo25EhXa7oaKvhAKhAMM0=;
	b=lR6DMdJQOVLxfHStzFMr3FcRc/F1MbJ8bm1pzWaAtmWZ4QGiKtmBwMY8DhF/DDoEjx8/Rj
	iT8kCIR3lNM4zeYLP3fLk1047u2ICpYdCBsHvVPVwxZ9wWfwrSdSKe6G1iOkm1/gZqydaa
	tE9Sbn5pbewyGuij61cPisxNPl3tN/I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TsJWzzK4;
	spf=pass (imf27.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755651908; a=rsa-sha256;
	cv=none;
	b=4wTKjPz/5uOjh8/SKNtL4j0/qA9Qcat91mse9UdHCMD69e9R0I4rQ2QTUjnWiHId1JnX22
	GZIiQx/kY1fcywyi6CimIsM5kLu/FAq/vwOZo1F6JZvJvs/UopF/cyvlhV27P0QFsd6GfQ
	Du5gL5TxzrUww1FrKZNyi1PRfL7bHLI=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JLE2AZ008324;
	Wed, 20 Aug 2025 01:04:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=joAKD
	yFfJF1Jn1BV6nqdFRNo25EhXa7oaKvhAKhAMM0=; b=TsJWzzK4uQdbD4trS9KNN
	X16/3jlvecQFlDTBLFpdvb5rsHhyjEBfgmBtqFSntlhbHzv1ujIlgxOGHSgfRX3i
	creZoVStTuzJ3HziYH6vx/BVhtO9NKH1DbpczR9BWElg5q6Ae9Sk6d2SOuTZO6HJ
	gIVbhOjPM7h+EnmcL+tf2Hvr9UCuclAkBaBYMLIoymlYMdiPt7jKeuLQp7wcKvQK
	4+wVwuqW0lCF8uhtocdZqRsyriOfe7m6GeqFvZfKmhw4lnUi4fL3lmG3BAAAgik6
	UjudOQxFfryrBGIoaD5SsbLBZeBIKREoedUtnC8WomhzK8DzMAllaEqsRw2Wi8rm
	A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0ts88gd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:04:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57K04sUS007394;
	Wed, 20 Aug 2025 01:04:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48my3q29tf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:04:41 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57K14NdG011685;
	Wed, 20 Aug 2025 01:04:40 GMT
Received: from localhost.localdomain (ca-dev60.us.oracle.com [10.129.136.27])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 48my3q29gw-7;
	Wed, 20 Aug 2025 01:04:39 +0000
From: Anthony Yznaga <anthony.yznaga@oracle.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, arnd@arndb.de,
        bp@alien8.de, brauner@kernel.org, bsegall@google.com, corbet@lwn.net,
        dave.hansen@linux.intel.com, david@redhat.com,
        dietmar.eggemann@arm.com, ebiederm@xmission.com, hpa@zytor.com,
        jakub.wartak@mailbox.org, jannh@google.com, juri.lelli@redhat.com,
        khalid@kernel.org, liam.howlett@oracle.com, linyongting@bytedance.com,
        lorenzo.stoakes@oracle.com, luto@kernel.org, markhemm@googlemail.com,
        maz@kernel.org, mhiramat@kernel.org, mgorman@suse.de, mhocko@suse.com,
        mingo@redhat.com, muchun.song@linux.dev, neilb@suse.de,
        osalvador@suse.de, pcc@google.com, peterz@infradead.org,
        pfalcato@suse.de, rostedt@goodmis.org, rppt@kernel.org,
        shakeel.butt@linux.dev, surenb@google.com, tglx@linutronix.de,
        vasily.averin@linux.dev, vbabka@suse.cz, vincent.guittot@linaro.org,
        viro@zeniv.linux.org.uk, vschneid@redhat.com, willy@infradead.org,
        x86@kernel.org, xhao@linux.alibaba.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH v3 06/22] mm/mshare: Add a vma flag to indicate an mshare region
Date: Tue, 19 Aug 2025 18:03:59 -0700
Message-ID: <20250820010415.699353-7-anthony.yznaga@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250820010415.699353-1-anthony.yznaga@oracle.com>
References: <20250820010415.699353-1-anthony.yznaga@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_04,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508200007
X-Proofpoint-GUID: dwMicK_aXrOx3OW1u1XRTV9-Cn-ar4zW
X-Proofpoint-ORIG-GUID: dwMicK_aXrOx3OW1u1XRTV9-Cn-ar4zW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX7Z/OUNiXSfdU
 sA6bstIT3iMsz8KRti2mg1l475gtdbbJ2FZvfqVhon8SqobWqbpI70WnKKusDCOzlTP+zksE0Im
 1GtwLD5XlOd8WU3IivD71koutCzR4dpDFAymxfQpdpN+XK84G+zSIbCDP3XqTw0edCbcwdsIyo7
 XHPOyoznkVMf/2cNQdtNyYC6KBgmt26xdKHBvgLOtlTOufy0shalNVxZ+E7mn2l9TQ8gNwG++0K
 aTobhHT8iI3wYywQOQfG50/xH66YiNV0FZQc80kLfDdQAIgt30n10SH7wdhWgb5cars1PV12n9F
 r8/TrvjKas0wGsX5ix7cFZji371+VVBtst2UjCa30/ha0QPs0rsLPjwbvEpP9ilQq58b5BEYOBP
 1iUldN1J0zsi5WsdxY3gUGWdT/1z5A==
X-Authority-Analysis: v=2.4 cv=HKOa1otv c=1 sm=1 tr=0 ts=68a51f2a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8
 a=sWrvqzRc1c8b1S7DXhEA:9 a=1CNFftbPRP8L7MoqJWF3:22 a=UhEZJTgQB8St2RibIkdl:22
 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=QOGEsqRv6VhmHaoFNykA:22
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F1EF740004
X-Stat-Signature: djash1ysxeqi3uqd734w49nyycmwxkir
X-Rspam-User: 
X-HE-Tag: 1755651907-248738
X-HE-Meta: U2FsdGVkX18NIrUoa4ma9Nsn6zTjgPg1lHLRyPwAAsoIxpPsSfmutzChh57J2T5Z0Qp2rbGjedZUq1yE7krnkE0dfH+QhKF/Bui+mOC1psxrhJu+g7nbZdfkzt44/y/B0/yg+HuidzOwT0V+LuNVLRUAQVWFUteRr8I6uSEonMGTWAQUWStJd0ugZ/ZFCAgIJ1FBMDol1tIhYBrMNVfefuSq2gTgkjlRxUzpxcPy+uLqu4HUu6dUyiHvKCgOSa0iUzIZ/s7wiMODiNA68slriBLYYoAsYnTTxuRCYZaBYCsuEEvDvtR4TPhdvTJmbZRbLLdExaC3g3ywKAnrae4ttJt/lsDnYt29Bp6CDGf7Q0Nv4LgzkdFuDnQiXFWh0W26HDrXGwkFzVAYUq2ZSwev5RVZYP+qKLSbmHFmyPICNVajpls2WXhKk6QkqKtl7NSHbJqK4xDj8ZsmKuohAcjqvq8IYk2ldI/KQTcpFtlAjZDKF7TcTh0i/O9Smr/l2PWBtCAc5/qjQXTKd24DcjhdQoCYQDmcX0a0kUBzrBGGG3HGM644LuUMINEtTgSmhyVOeUfVOSeT/r0icwPWkI9+QlILa+tZnetxtacsv08mCPjho2lZH1Idlfdp7IV4Xmi7V5Vjz4lN/JsSrA5XoMADb8WzZ4EU4BqBHKPUR/Po4Q5gMucjT+IJeC1wWhdv3MdwVkgXTn83qMIgpovUnactiYy7cJkM5lZ75/Hn/rS98MWMOx8wKfco4/zwgR9TDSdMCHnU6r0IbTkdqqkIQrK61yLvOZmSWpdzqD3fN/U8WyqmHfbLdslFdtfrBtL/9UZhPgOL/XZU0/29XB+3/3w6ePgK3OlDIvmTNnNKKP0n+lBowlL/qG/v5RXOy6p73O9lGy3yid0t71QShfAwuJHVJVAP4N7lWn03stKudDj5bIicSyXSXgWZTjaoIlA+Eft8u7uTwzH7Zu7EXEAPA/C
 aeNfy24x
 SkQpn4eZvM7i7NHdAk8c2BWdJWsaQCT3DQPH3FIDe6FVSKBOcrG8XapdPFRWMprlSJ3tzDyvZgEQ1/u9zT4BAK/j6DvolpuhH5eDnTPaWMKvf+LaokVTrmInwvi35ZTPsnSCZTHnm+5Rwaw1AdvHoPigVcP9kU0XTVstLsCO5RY0CUrtuiMHblpR2LGPWJlp2UkK85Ye/nf5ZRH1PIvsCYMVPS3KJHXv2+FSxSqHSwJSjQ4uzLdtrKwnbTSVGEu6MoqLgU/Xcor5Nqe1uDpiXAfyajTz7mdwXK1jyIlMzfmgxx7CtzCTlO2dLWIlfmAN4aTEOwykgm5VI1eH1M57iH/AcJnpNUaOGLiDR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Khalid Aziz <khalid@kernel.org>

An mshare region contains zero or more actual vmas that map objects
in the mshare range with shared page tables.

Signed-off-by: Khalid Aziz <khalid@kernel.org>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
---
 include/linux/mm.h             | 19 +++++++++++++++++++
 include/trace/events/mmflags.h |  7 +++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 76ee2bfaa8bd..aca853b4c5dc 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -431,6 +431,13 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_SEALED	VM_NONE
 #endif
 
+#ifdef CONFIG_MSHARE
+#define VM_MSHARE_BIT	43
+#define VM_MSHARE	BIT(VM_MSHARE_BIT)
+#else
+#define VM_MSHARE	VM_NONE
+#endif
+
 /* Bits set in the VMA until the stack is in its final location */
 #define VM_STACK_INCOMPLETE_SETUP (VM_RAND_READ | VM_SEQ_READ | VM_STACK_EARLY)
 
@@ -991,6 +998,18 @@ static inline bool vma_is_anon_shmem(struct vm_area_struct *vma) { return false;
 
 int vma_is_stack_for_current(struct vm_area_struct *vma);
 
+#ifdef CONFIG_MSHARE
+static inline bool vma_is_mshare(const struct vm_area_struct *vma)
+{
+	return vma->vm_flags & VM_MSHARE;
+}
+#else
+static inline bool vma_is_mshare(const struct vm_area_struct *vma)
+{
+	return false;
+}
+#endif
+
 /* flush_tlb_range() takes a vma, not a mm, and can care about flags */
 #define TLB_FLUSH_VMA(mm,flags) { .vm_mm = (mm), .vm_flags = (flags) }
 
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index aa441f593e9a..a9b13a8513d0 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -200,6 +200,12 @@ IF_HAVE_PG_ARCH_3(arch_3)
 # define IF_HAVE_VM_DROPPABLE(flag, name)
 #endif
 
+#ifdef CONFIG_MSHARE
+# define IF_HAVE_VM_MSHARE(flag, name) {flag, name},
+#else
+# define IF_HAVE_VM_MSHARE(flag, name)
+#endif
+
 #define __def_vmaflag_names						\
 	{VM_READ,			"read"		},		\
 	{VM_WRITE,			"write"		},		\
@@ -233,6 +239,7 @@ IF_HAVE_VM_SOFTDIRTY(VM_SOFTDIRTY,	"softdirty"	)		\
 	{VM_HUGEPAGE,			"hugepage"	},		\
 	{VM_NOHUGEPAGE,			"nohugepage"	},		\
 IF_HAVE_VM_DROPPABLE(VM_DROPPABLE,	"droppable"	)		\
+IF_HAVE_VM_MSHARE(VM_MSHARE,		"mshare"	)		\
 	{VM_MERGEABLE,			"mergeable"	}		\
 
 #define show_vma_flags(flags)						\
-- 
2.47.1


