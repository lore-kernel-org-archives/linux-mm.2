Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DC64D1953D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 15:06:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9D856B0092; Tue, 27 Jan 2026 10:06:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BFA76B0098; Tue, 27 Jan 2026 10:06:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FCAC6B0092; Tue, 27 Jan 2026 10:06:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 520C46B0093
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:06:34 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 12E2EC12FA
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:06:34 +0000 (UTC)
X-FDA: 84378070308.18.A484FC9
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf09.hostedemail.com (Postfix) with ESMTP id A018E140007
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:06:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=q9USiT6A;
	spf=pass (imf09.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769526391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hfsP7eDwLI1bgJYLsyU2XjwkAw7+pqh3tU+FZJn6YBE=;
	b=Aa+kbpVmCMdP9RS6XwHKHF7uPHIPb4R1KTOpvlir+iOTQdy4wUgy1HVRKPWSXQEbqXc3E3
	84t5javJtOFbf6VCS611Z67ZZUAO3Ow9DJ3xe8PbRsl2QU9WOSnDKAuLw0zFHes86EqZiC
	5FolAyyHpw/SBJD0f31rIoMnl28wquY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=q9USiT6A;
	spf=pass (imf09.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769526391; a=rsa-sha256;
	cv=none;
	b=lLKWFg4zvmZCFvxjVx4NbY/z97kmFhdo8EkZULNmigrGvWL5btBk/zqXdBfpgBI1dVlEE2
	6EVF5PLHjjlVV9/0FZ8E6SpaP5xSwKQJARZdnuQDH1Q9OEudEqar+oZe8cZX6B20p2ZeRA
	fcOylHFpz9xf6AHmBotZC7jO/TN5irI=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60R1shiS000830;
	Tue, 27 Jan 2026 15:06:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=hfsP7eDwLI1bgJYLs
	yU2XjwkAw7+pqh3tU+FZJn6YBE=; b=q9USiT6AhsV9WfM83XsrNvA9tBQ/TMKcL
	xYUGNCbSvupqYIUvjPOHkRWgu2845oyHyqzX/zUEaDA3uu8b3sQjPYlH4Y3JaK3a
	bSpni5dvGagrtgBvyeo5UbluJeRfxVG5c3cWmlS2HR3QGGrPsTED6z6Vdb+W5FgL
	hiQpsljup60RNuGx9bhpKkL+Fdac8/w24gfR4f4ZqOxhZ2zxnPjgFDbHVPFWOlNb
	opYalfhwc1lqeuZk25M7X+H5pPfJGkD6zFqQeJZocz5o5o4gDFNCpmGar19kfYPG
	yBckk484xhVogOsxIhnMsHeMsf/4ZOEQ/lcSJFzo9/pvBy425IEjg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvmgfvde5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:03 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60REww8J009059;
	Tue, 27 Jan 2026 15:06:02 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvmgfvddw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:02 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60RDWomZ019844;
	Tue, 27 Jan 2026 15:06:02 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4bw9dn13qc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:02 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60RF5vHX15597878
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 15:05:58 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B5C5520040;
	Tue, 27 Jan 2026 15:05:57 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 500F920049;
	Tue, 27 Jan 2026 15:05:57 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 27 Jan 2026 15:05:57 +0000 (GMT)
From: Jens Remus <jremus@linux.ibm.com>
To: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        bpf@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        Steven Rostedt <rostedt@kernel.org>
Cc: Jens Remus <jremus@linux.ibm.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrii Nakryiko <andrii@kernel.org>,
        Indu Bhagat <indu.bhagat@oracle.com>,
        "Jose E. Marchesi" <jemarch@gnu.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Weimer <fweimer@redhat.com>, Kees Cook <kees@kernel.org>,
        "Carlos O'Donell" <codonell@redhat.com>, Sam James <sam@gentoo.org>,
        Dylan Hatch <dylanbhatch@google.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v13 02/18] unwind_user/sframe: Store .sframe section data in per-mm maple tree
Date: Tue, 27 Jan 2026 16:05:37 +0100
Message-ID: <20260127150554.2760964-3-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127150554.2760964-1-jremus@linux.ibm.com>
References: <20260127150554.2760964-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Z4vh3XRA c=1 sm=1 tr=0 ts=6978d45b cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=7d_E57ReAAAA:8
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8 a=yMhMjlubAAAA:8
 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8
 a=QyXUC8HyAAAA:8 a=oGMlB6cnAAAA:8 a=1XWaLZrsAAAA:8 a=iox4zFpeAAAA:8
 a=37rDS-QxAAAA:8 a=meVymXHHAAAA:8 a=WXPXSJi59xPm3fQCPWUA:9
 a=jhqOcbufqs7Y1TYCrUUU:22 a=1CNFftbPRP8L7MoqJWF3:22 a=HkZW87K1Qel5hWWM3VKY:22
 a=wa9RWnbW_A1YIeRBVszw:22 a=NdAtdrkLVvyUPsUoGJp4:22 a=WzC6qhA0u3u7Ye7llzcV:22
 a=k1Nq6YrhK2t884LQW06G:22 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-GUID: Bib1A93bPA3qtU-1N4Liwkq5g9MzjKPC
X-Proofpoint-ORIG-GUID: 1BXUtyl1a6o4dLxcV1g-OuBe4aIut9rl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDEyMSBTYWx0ZWRfX+UZmCDOpdjui
 m2eW5mhjZ2WF2ziWdvdAp732U6dNV6M2cSSMobNMMkswDJKSPjJqcBh5sbPdAbnX/MX35WN48Ms
 bMQ6mIVo9mEplqR7+al+QgDqVVkbH8xzxY4WDX7Q0aaeFcuGOUZnujQFwCfm8AeLjkbJUFofm86
 xNmwvVb7XEFniT6Q9syRg+KYxZoNvz+i1A0YeQxU9/UCYUJHknDrN1DyiDsaCFD3SduvSo31Y74
 x/6sVRjSF8TN7cKodcTKiHl5s7FnGyym7V7c9LEKLHj4XTOs20nvNli0wR7vaVefl9lvm03G0uG
 ssaVKIRsKIsMEJmRFZ4fOSAS+k6BSbss1Izcf09yzkDpJQToueAHeYqVGQ9UZSn8KsvAszF4fom
 eL9d6pdbP8opxvPGB4v5codweC7cfoT69q3JlhOjD0PQeQpVE0xfWSpLgMWH0GCGciuHVlDzFS1
 4DmsfjHgBH1MadZ8pgg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-27_03,2026-01-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 phishscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2601150000 definitions=main-2601270121
X-Stat-Signature: 81idh4gheqoc98767yrki6nxrkok7uqa
X-Rspamd-Queue-Id: A018E140007
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769526391-326406
X-HE-Meta: U2FsdGVkX198+7k8feEp324ziydiM3FNegaCDfFu7lviDuntE7yyj1azhKvzIUqyTiiSZjNdCQOusqzq6KqSIk4/xcu6ElmoMiJpU72kg99/Olrv28LedxkYS9OiwTcj7QDIRhFRy4XhwyOVdbIW1oMLQeBrc5Aj7fh1P7vXFLl6DH5z+HzXRKp2aPryR32vDxRSW/t0Jp96DiwNSryhDE1icaQkK+qhLAjGPRLZraKOnjGT56K1vOrHdbtJOGLt1nHP7EUEyOijmNfs2KFFhMiCeyGVdfyqjQEpfkO/rNtAvtfT2TDWXEC4zMoBCdLREhpnHVeUi6hMyhGCmdiSAXdrKYctRQSsM7fCAbsJEqxeD52dRoFxdcrkrnRcmRjLFU9l0zDtPLF/CY6+fZprqCYBhCLI95NvYHi4IDAWK2VujtPov6f5pQdM32+rWhoHdJZgzEYP5xYngP1Iy2z/l6E//UykolU1IVRUMtXztHXAUgohsggDBasSzzEyBYNJ6/EA5fzvACF5hT+1qFIH6U77Q5SRCJS2oRPuS7vh5Y5QHaScLUVJ1ABnr1lj61ffTfY5HE/P0cgM+b0NZSDUjTdsyjf53hV5Asq7UXmBk5xVGTRGFkuUB8AW5zKtYZ0b/gA8hXB9g1ABC9zDg5wTYT2haXWthyZ3Gik6xJcnkqezp2VViqkT+qQGKuppaXXbzYmoDaUEeWw3SXsAZ/WyE3RAcKCiWC5kRm8Nkrpvu3GnWY9pKizfvH/7jwBRZRtY7V69UQTqL7fWLTtMMd8pTGAW5Z/4IRXUGEL+khf3zNeeJXJHq7FKzYAqZWLkx33pBPJT09PYvLSWPBDnM9L6qg2e6sfDwnIiScy70G9Y8WsRELmOs1jRdv9TaMTdjJ/SF79qVtMcduCUlKFruFRbMOWp5dB03fLv2dWyoYsGFF9mZXCRG7nf0wk1FtoNmoDAULjntRrZqh3dDMQQMk2
 DyZu2RMV
 SdKntqxr2yrr7/BrLZ23oDrV85fH8Yxlq+RPocVG+bWE1f5tbbSYVdShgt/wq7R/5ZVBXTV0KVwFxDIF2/H81Egm8MHNV4KAfcxnKliQLSYumRBsrTD3En2yKVoZ1MeCMnXRDFxb4+CAz6z7bLwHDqUhqUVVZg9iqswEx8TMxFCOao3lSo+c2uUNU7BUN/eHNYfR+WcUdtB7qWc01lcgA43HHvEW3S/gXS0jIgYgS0BNTfpqnoOqAUEZ+VgbWIY3Atjhu+2H3BROhoCvAHwtXeJGxEtgZhmb4RUyh8S3cxNBgiH1BsWdCm14UpZIY0Qro6+JWQo4qQK6xQjfCbRQS9yDvyi2xBZ8g5UaxBOU4u+0bBSv8dfGG2mKJzDQhgjacM/J7P3YF6wChp9oV0bLJSXUIExBkccP82fsPsfk9ij0yGGgYUimWtrq5RGfv651TAs4WW0trPLtSqaVLEWGhhZCOvKN5HxhxvSdux2keg/S3RXf5JI5TfIDlybStapcCXAFE0c9vLNcakFx9k4es7M1Syhv8c6Smu3SZhIIV3KFFIYQWvE42Ts93FrKeqZwAfteB0oF68e7KYSHxpSjvFJWPU5/QTVPqM8aqriHDamFp0c4s/kC0X8+6Yifse8W8ACLpEnEUhAObTkJ4Bo/gVlZeRrkgvAmnyh4OLeM99YEw+F/KrOeTZcP5ogqAG4jCC9Up5fwe0Ez2N9JK/delEcDKUBDLYCMklSOWXYAFIvti4Wx5nqkt4WVmtfDVK/7/2iW3EIYd0sRJ8CI30yxsuX078vCPabQ4Un+wOiHP1zHgaUvHDUJ5/fSaaALWbtxc698tqt1HBT0lNdSBb6rGYSjVQDcTO0hq2LhPkyuHF6OaM1LtLGfbvFdyz2UpSap1/AqVc7V4dfX5Tyj3okNjfA5jiK5j3aY4pnmjAJxhVHuiE+I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Indu Bhagat <indu.bhagat@oracle.com>
Cc: "Jose E. Marchesi" <jemarch@gnu.org>
Cc: Beau Belgrave <beaub@linux.microsoft.com>
Cc: Jens Remus <jremus@linux.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Sam James <sam@gentoo.org>
Cc: Kees Cook <kees@kernel.org>
Cc: "Carlos O'Donell" <codonell@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: x86@kernel.org
Cc: linux-mm@kvack.org
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
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
index 9f6de068295d..c764d00fa522 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1323,6 +1323,9 @@ struct mm_struct {
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
index b1f3915d5f8e..d8a7a32f8b81 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -107,6 +107,7 @@
 #include <linux/tick.h>
 #include <linux/unwind_deferred.h>
 #include <linux/pgalloc.h>
+#include <linux/sframe.h>
 #include <linux/uaccess.h>
 
 #include <asm/mmu_context.h>
@@ -732,6 +733,7 @@ void __mmdrop(struct mm_struct *mm)
 	mm_pasid_drop(mm);
 	mm_destroy_cid(mm);
 	percpu_counter_destroy_many(mm->rss_stat, NR_MM_COUNTERS);
+	sframe_free_mm(mm);
 
 	free_mm(mm);
 }
@@ -1067,6 +1069,13 @@ static void mmap_init_lock(struct mm_struct *mm)
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
@@ -1095,6 +1104,7 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
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
index 4600e7605cab..b32fcf167cc2 100644
--- a/mm/init-mm.c
+++ b/mm/init-mm.c
@@ -11,6 +11,7 @@
 #include <linux/atomic.h>
 #include <linux/user_namespace.h>
 #include <linux/iommu.h>
+#include <linux/sframe.h>
 #include <asm/mmu.h>
 
 #ifndef INIT_MM_CONTEXT
@@ -46,6 +47,7 @@ struct mm_struct init_mm = {
 	.user_ns	= &init_user_ns,
 	.cpu_bitmap	= CPU_BITS_NONE,
 	INIT_MM_CONTEXT(init_mm)
+	INIT_MM_SFRAME
 };
 
 void setup_initial_init_mm(void *start_code, void *end_code,
-- 
2.51.0


