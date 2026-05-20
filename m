Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14A12CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:41:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57CF96B00F5; Wed, 20 May 2026 11:40:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 490B36B00F6; Wed, 20 May 2026 11:40:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 363D16B00F7; Wed, 20 May 2026 11:40:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A7B06B00F5
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:40:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D2314160C12
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:40:55 +0000 (UTC)
X-FDA: 84788211270.26.51BD19B
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf12.hostedemail.com (Postfix) with ESMTP id 841A74000D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:40:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=DkbeqmY0;
	spf=pass (imf12.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779291653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=odsVNex6R2VPSghnYDx1oLCB8plgZo4cXgSkUOTP2c4=;
	b=mlrkHeLq707poTNwTlsfL5tiFI1CT5NXhpqCKvEPRLF5+4v/Uao1dwOKRuXGWjhp8pbxGq
	2CSCmKOwxs3hAhMalcEJcd9vsKUXu+uIPz2KBdzDObKaCgpCp2gBP3qWv/AsN5b7dOvBiw
	eN8vox+Dt16tSGrblY4Vr4z2zWv1yTg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779291653; a=rsa-sha256;
	cv=none;
	b=1kECDb24R5AtCxrunYNZ7PFUkK0ksyKE00by5MZwstyYJEa0QNpXyXkM+Xlfw4KLgl+q8s
	+6gj+SsW/feTFxEHfOlvvSA/UHj2jQ5krhZPm+BocmFNFoWcq4/hs3CdoI4X6IgDRu4AaA
	JUwkztrnk4O33Q3IllYH+oe1ngLm7KA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=DkbeqmY0;
	spf=pass (imf12.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64K6ocj7834424;
	Wed, 20 May 2026 15:40:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=odsVNex6R2VPSghnY
	Dx1oLCB8plgZo4cXgSkUOTP2c4=; b=DkbeqmY0FpKoye0tkduxW3umy/JdqbtxD
	6/xtJ+lGDCVdYMbJVcxk+y0crv4PoTalkDb0o7px6e4IiJHP9bDf+Pva3gOpRej0
	nFQ8/RH7jX+FQ/Jc4QeIw27lnmKmMp6q100/zrJ4WbXkgxf6qs6MRtbp21PVpbb4
	utDDLO9U0X7mI7HtGhSrfxewg1S0UYD3n/QC3DdgjNGvMnbXTbSLyDklfZKo7Iol
	HTVebyT+Ugr04GfhnCQd0Nal47ueV1FsCOykPP5OO9/axmVL2fRpfHtEYA1fh8UK
	rtr93pl+IR2ONvyWqnXYIvEHlihLQH92a2TAfEMsGlIt+9tKuzGZA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h8mtsp2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 15:40:12 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64KFdACW016266;
	Wed, 20 May 2026 15:40:11 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e754gfrhc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 15:40:11 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64KFe7v344892612
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 May 2026 15:40:08 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DD6DB20043;
	Wed, 20 May 2026 15:40:07 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5AB932004B;
	Wed, 20 May 2026 15:40:07 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 20 May 2026 15:40:07 +0000 (GMT)
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
Subject: [PATCH v15 01/20] unwind_user: Add generic and arch-specific headers to MAINTAINERS
Date: Wed, 20 May 2026 17:39:45 +0200
Message-ID: <20260520154004.3845823-2-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260520154004.3845823-1-jremus@linux.ibm.com>
References: <20260520154004.3845823-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: YKvfFXI6TIxbisoowa3fG8e0_F0on43b
X-Authority-Analysis: v=2.4 cv=GYMnWwXL c=1 sm=1 tr=0 ts=6a0dd5dd cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=1XWaLZrsAAAA:8 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=meVymXHHAAAA:8 a=HxY8WkbW6gBkmJkjgtEA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-ORIG-GUID: hi_SJXSzHYSz7oiCOl1mI8qRHjox_iF9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDE1MSBTYWx0ZWRfXyhBN7BRDhO4V
 fLT3CBvE35SKtEj/bGNwvGcyb80PUunwDw8MWIrpJDxnHfqOzZPLRSAbLjrpqOgA166QrqXlbXf
 +a/SDwN0ZCyoKUA9pdsHIVJGkx9wy/OzNBRAkMVt0AIVEn3D6Z2LiFaCCcWJ2dr7Rrr6/v7q4/N
 MET/5n7AzhxawpcaqYxAZk5mX6S883co5SuU8p8w0nS6TiDoDafGFkbpzNhr6y9xL9OWKY82pZE
 /9po9qQF21/u84dndhQ8jhmTPiXeyL7Wa9NYW0H1xjfJrHTJfKw4pgYLX+H09uXQdwkp6NAmqop
 kQ4jDz2pWlW0FeY9B9A4Vl2wD+DRvmq/M04w1L3HowEzyIPyQjezkC0EfCNUjA3wvOziGDq9BZa
 clBxs22wAyMm+1+D5TRXdWg2//wLH9uOnhdHuh5KsLRQYUjLXxe+XKJT/YJ3QHREXBIIqOufAmn
 5ZKNCpsfzF+e6tHPtFQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605200151
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 841A74000D
X-Stat-Signature: 7maeujwi8ng5z161rudgt9qg69kejh8k
X-Rspam-User: 
X-HE-Tag: 1779291653-10153
X-HE-Meta: U2FsdGVkX1/uO0/fjAvntmTzh4t9WNYtoNlrMkrLPQGjrsLkp8xTmMKonSdPdUT2EOvWWO4pcCFhhXV9eBJNgtJdvrOCIgw3g//snARs726PThXDpf7s7Zo+z1IUrH7o3Pm5qGDNV12wFOwkUaL24XqgBUVpCyAGf5fjvd2LXAbHiw9HzthC+E5SzUtEGjkuA0VzEYToHlvUjhk/bY4da78IB6jFgn5hYBdlD0of0gfXZJ9WHnVlbgOcj/lkZ6TzeoLRYhaxA13vduS04mOxSuIy9zdnyDthLi9pyjY5U7ez3dwC0NdZtlK3UwkqyyKKKzxFf8WzPkHBocCp0HR+v+R8fHyRtJ/qJc5cJINXPhLQTSDjehOrr8cqChfUKlROQgCVHHhq1i9iUMHsSD9i9FnHQI9mm85uH7Gu5bFKdOgSOTTBDO/BzmYZ1WCweXWMIS2BgtAohTSsRKdujqYBKRpamXQaT+eN6HK15QqdwOrtM+LoBRHu5MjavUDT15AaBhl+e8gWnZhY4zA+Bf0dh9bSw2koAjH+DnggApn3EPyXQtnXJGSqGvb782woPJb9uRn27KhOLgVIlmPHAbcWx/YvDuIziEeAGUC1ZTTyf1ZhPLL9bQIxnU0+MT6xARdFYwxA5kMgeL7AzAicyH32TLXYZHD3tr0h4GJUfyIODk4cipkLjf5mPW7MK0lLD7GyGl2LzVD9uqW24pNL9479M4ijyyKE89IroLNMRrpcDgH4cpTQVSDjaapMAYzDm523CpjCQi0HexndGSj8ODEhV0ruWIjdpMNlHq7aMdONj5ZG6FE0FrcvmdOxMm+6kqaELrlr3bjbP7gdgeOsO88AwyMgzH8s2FOQ5zBbgsk4ts1qUzBeu7LrHMLj52f72GqRs/4NG4HiqU6X3jCa+14BTCpJaACX0KYZxan8msQE9rtXeRmgrThbw0t3g8rCsWvMAfGFmg9v2dht2sc1lWG
 9kahEGuF
 RUfNZM/aHY0nnpbO9rRI5ehCynMBpeqqymcWath5a85chhTVwnmuzcOYM31sA17Cbcwrrtfy817CYawM923LS4Ua2lT5TeC+qqziQNuGLAQaqg4WLh5d2PJSBmTy+sC+3m0uOlmrDxphldDxqM7zgtLnDjxmE3P9vcTVXGIBfGY6YL+9vylGvc8hPqjQvIVuYMiCl/3pbkKLC2056ZFiE/Cgzif0Qvo0WqKnLCSlx57EV33vVsrMSCUAnKA1YScb9hNskGus57egr74lHBAVI7y4uCHC8j79iF/r4SYP4vbK4yPwh/dkVcFZyBuNOTCZqtJNzaM95CES6SvAnhgPK8lideJEsTqE046OYrj1KaQxPsl5/hHS5TvyOv/D8IwRfTvCo/Dy49kQA/KNzcsscFkkmYtbKUZrLwrbnpTz9Ik02E0m7U1ZmxmH4h3oKocXBgugE
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
index c2c6d79275c6..7434e9d7b33f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27874,6 +27874,8 @@ USERSPACE STACK UNWINDING
 M:	Josh Poimboeuf <jpoimboe@kernel.org>
 M:	Steven Rostedt <rostedt@goodmis.org>
 S:	Maintained
+F:	arch/*/include/asm/unwind_user.h
+F:	include/asm-generic/unwind_user.h
 F:	include/linux/unwind*.h
 F:	kernel/unwind/
 
-- 
2.51.0


