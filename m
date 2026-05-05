Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FBF9CD342F
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 12:18:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D8066B0098; Tue,  5 May 2026 08:18:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39ACB6B0096; Tue,  5 May 2026 08:18:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FE8D6B008A; Tue,  5 May 2026 08:18:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DC9396B008A
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:18:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ADA241C0DC4
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:18:12 +0000 (UTC)
X-FDA: 84733268424.30.540771C
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf22.hostedemail.com (Postfix) with ESMTP id 513BBC0010
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:18:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="ErnKXTn/";
	spf=pass (imf22.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777983490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GD3koIMDWCSTvzfmJn4ypGNpgpj9uyVZJ+2c+Wijlmk=;
	b=Y50VJ61FGq3+5iFNyN8Gs5GpL4zJ7K5ssSmhQLA2CfrBSURIFiXz3OsCl93pSxcZyHupxK
	oHWCcFPEhLNAqyVtlWKioq6vOPRE4fFJt+0O70psmRp9UKYg7lmh219V0GH7pyi5cgNPUW
	NpuFJL4+MI/6YRRudrWbwvyl3IiH5Ds=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="ErnKXTn/";
	spf=pass (imf22.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777983490; a=rsa-sha256;
	cv=none;
	b=TaJa+TsMduZcNUSSDM93OhA65vloAMDtyylm3TUdSLhF5t0WPVO2FTeLQL2IsqfIY2YupU
	JofeDA8kpc737xcaa1zt8TH0e9SGMrZCXY3yYy2CSgxYRoGkkxFFhBTK9FEG1FektDxnnS
	mKGpiwtncvu+enbKviXDMXmeHpIrCNY=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 644KG4hJ2292989;
	Tue, 5 May 2026 12:17:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=GD3koIMDWCSTvzfmJ
	n4ypGNpgpj9uyVZJ+2c+Wijlmk=; b=ErnKXTn/ewKp8bL+Yp1bulUPWssex0Mbt
	01h2L5+u1EitZeKzKFC9pfi137qP6K7ICMOwCgwxjD+j+dhWx8Fk5J3pLtOWPxzZ
	GeHcirV7aYkkggmhC79RC6+66usGsxY5NVKRtIs7YmsSrp2NvAq3vnivvf8o4oEV
	FQ7lObWhBCT3MG7TpLdVj1YGHhomwhjWWMkBRUGwFQvc1As86gp1g7+nhwNB2mt1
	al0rTmucpE29s8bK1PR+fpKK+BBymU/VDJCfL6CMTd2udG70JQIeQuw6GPYGhoeO
	qDt6qc52TSVgnvg5+93tJ2sS7s13UCYL8c9RRQTh6ybdrAfacFRjQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9v7bj91-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:27 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 645C9k8a032554;
	Tue, 5 May 2026 12:17:25 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dwvkjsfvj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:25 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 645CHLdw10027270
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 May 2026 12:17:21 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B11D92004B;
	Tue,  5 May 2026 12:17:21 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5085F2004F;
	Tue,  5 May 2026 12:17:21 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 May 2026 12:17:21 +0000 (GMT)
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
Subject: [PATCH v14 01/19] unwind_user: Add generic and arch-specific headers to MAINTAINERS
Date: Tue,  5 May 2026 14:17:00 +0200
Message-ID: <20260505121718.3572346-2-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260505121718.3572346-1-jremus@linux.ibm.com>
References: <20260505121718.3572346-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDExNCBTYWx0ZWRfX0LIltCL1AQDa
 Zt4rnO8OGdQ9jq1onIz7f2sNzyC8YoUTZfl7VjlMVoLpb745drU8RXGLbQzgpqd5XonAXXryEbR
 p0EaYFsyvjvtU1xY45bS15j6ugx6GbNTqcqknWGsYGlO56mjtUjDVNdFJWKkSAodQxr3+N64IBv
 50lJFVv0eR9ax6BWYxIJZ6+NER/gDmnK2V9nY37Yw7Ug0Bjw3k2DYb8+QepmfplSZKwmuDzkaAY
 CYJ7AmJZqR6QI4iII0m5ltGbLikYXNSVMXQkpxOgNFLi9bGcXwd+R2iQcRnRCudSkEP7+hbWS65
 EYdxZEbAAUEF4dombl5KNK+ColZzpB77tHsN65JPvdZN8KO7xFOXExHw++miMDu2KJXk2xo5Dls
 ivm7TIQ6UNH2IFKVRt3MoUK8M8l66hp9r3jm7AJwpb9eey3Xiy+rxPVGqYCvrV5v+197x20L3tx
 cI7/5lqiZvjYFRE+lFQ==
X-Proofpoint-GUID: PCsahACsigXdLiDH_nJGbkO2jA4YCBJ6
X-Proofpoint-ORIG-GUID: FrR91evT1mN2u5qsD6w0MC6XWsuiwnAd
X-Authority-Analysis: v=2.4 cv=eu/vCIpX c=1 sm=1 tr=0 ts=69f9dfd7 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=1XWaLZrsAAAA:8 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=meVymXHHAAAA:8 a=HxY8WkbW6gBkmJkjgtEA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 clxscore=1011 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605050114
X-Stat-Signature: 8npf1gew3gzqjsb4xsih7t3d81iq5paj
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 513BBC0010
X-Rspam-User: 
X-HE-Tag: 1777983490-627369
X-HE-Meta: U2FsdGVkX1+3ez7k8P1d+zoEugehLSmVvzfprHZs/tFVftvDNBiulA1nBeu9FtI02LkG9HbDjz2+Mzu1sdXfnwzl0jKXgFGMQ3Jpby1ARtikCmSNsyia0N8guRjA4y70qH0HrqjsdE0ClTaIBcybnyE87N1zlJR+flN9RyriUSXaVIkH1wWZ4ONrfS/1B8bLGiOSm6VHEpWl5FROm4wY29hLNXxkzbtKofiPYLvsh03uXNT1tQukhXDz8kKGilU4ftOq/I4gzSXox85OHB7YaN2t55YvutJBtbMYN94zQrLQ+9ZU072kGb/9vTjVg+pK9r7BYVHvtMmVDrnu3KCutB4iN+1NELz5zw07yl+NhblLil1HgUmh+N3fvOuWkOU7AQStWbGM77Ya18VCjxUtwz/PJhi97GZMyy5y9BQBOa/jPSxP66VzzRa+JpL6pU5c2qFbXu5pX1uYNiCmP/IcIeEcH9EyC69A/3vY10dVxljcgzihpWu82ML8iYiT284R90UoZjEiR/qfEfAt3Bv6sSJqzymmyjRAIexNY+/E0MF8jyeo7kqapFxmw/PE98UjA6YTQdIwQbT6KWkEnF22RCQSajl7eSauWxKPMf/+/kgp8LrttzV2sE+W3FJuGNLYQMen1f7/uMz4fqKK9UE/CEu9MfMekwr5C/tQOyY3DAcxF1wVBBbUyHUop8NpBLBgtyAc2Q8UOUoKZ3Rk/FFvKo6yu/fyJW2C6xPOj9Vw7Du3PMYMVhg9Rye4Kz9TBZZpIHZQ/oBiqwK4Gqh7GuHb3KVhQpAGGna7QzCwml7Mf6iND1Jj6wuIULeRu7vjMPbHs4NaXWVzF4eXvn87bJEuCplwLHP8bMN6/ug3uLHE6c7uE2uR++pRWxHIVbkYMaYrGce3mGACjjzKt2dJRpmIxOYlUZtMfBn6jD1pIapx4Z2KpEBYQykv6rmPA4QEadPU1Gj88bnjYrHACT8TUPA
 cWkgwLOa
 8HlmZ9msAFXTBhXqc+TFcxzBDCncGwni91YoYGpzeX3gy88sXHrdggfR29R5CZr25WCW9rPSLbxFdeoujLYhKO+yp6IaevEzfRmkygO+rAxMJbc6QQ1FdLXvF/QthhObyeF67J+BMlrb8QjMMuk3Da9b/mNwcQ8UJTvP9rvqi1//b5TM259Q5NHj0pYFfaYkKH5XjqSxWG4es+f1FbvM7jmzgAj7M+gqA2hm1BtXCYqj/uEUyO8PLZ0aQ2k53PcJb+N+VgNqA4wHFwWJnyq073oRJET/gH3cYIS7aE7cYH+82P2p6aJLyXbZOBw5Ld9zW5vqSjiBbkGNzlkqDtp3dz1xdtm+SpmikHH9C4NBZ8BAo9jI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 71753c6ed2bf ("unwind_user: Add user space unwinding API with
frame pointer support") introduced include/asm-generic/unwind_user.h
without adding it to MAINTAINERS, as well as any future arch-specific
versions such as the one added by commit 49cf34c0815f
("unwind_user/x86: Enable frame pointer unwinding on x86") which
introduced arch/x86/include/asm/unwind_user.h.

Suggested-by: Dylan Hatch <dylanbhatch@google.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    Changes in v14:
    - New patch.

 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 882214b0e7db..8e71c6e7a68a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27862,6 +27862,8 @@ USERSPACE STACK UNWINDING
 M:	Josh Poimboeuf <jpoimboe@kernel.org>
 M:	Steven Rostedt <rostedt@goodmis.org>
 S:	Maintained
+F:	arch/*/include/asm/unwind_user.h
+F:	include/asm-generic/unwind_user.h
 F:	include/linux/unwind*.h
 F:	kernel/unwind/
 
-- 
2.51.0


