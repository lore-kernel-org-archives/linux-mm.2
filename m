Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED87DCCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 14:44:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 715DA8E0002; Wed, 22 Oct 2025 10:44:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 629808E000D; Wed, 22 Oct 2025 10:44:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A09F8E0002; Wed, 22 Oct 2025 10:44:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 145A28E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:44:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CEBB05B989
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:44:13 +0000 (UTC)
X-FDA: 84026020386.12.AEF52D6
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf27.hostedemail.com (Postfix) with ESMTP id 65A5D40007
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:44:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=aG8U8rcp;
	spf=pass (imf27.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761144251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pBJdK67AksVU11IGyRHn665XT22A0I7Wg2zBK+A2YrM=;
	b=LsnlaTcemlscrLo++DNWBEkVCRmmzJqB9ggPpSL9Ztqee7dDMVxf1QbxPnecnvx+MPY6Zn
	kZwMdEjEE6sGd4iUo3OT3e83oG08pV0ZfqD2Jp7UvBSOMEJSBmSoKqiwop7HhAKWXOxYVu
	w/1BrxP4CjxQzAW4afvjk60VCHutGbc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=aG8U8rcp;
	spf=pass (imf27.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761144251; a=rsa-sha256;
	cv=none;
	b=p5Y6cO/hT/FkKPMDfMsmQ5kIXcdKbXnOxLcFL9cj0bFAOB6TVy3y5qQ/N7QS7nSybFEoPI
	E3fvKRJ/f4tDLsm798TgXoV5+U4YPbeYEGwGaOFVmzWM6/bNoEp9HIrwDNh5tacS1Toka8
	0tNHDoNMJzOV+TaqfXgfg3S29Xgri7c=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59MC7vuZ018832;
	Wed, 22 Oct 2025 14:43:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=pBJdK67AksVU11IGy
	RHn665XT22A0I7Wg2zBK+A2YrM=; b=aG8U8rcpDmRF/JJw22z0aiFpbeFwF9PYE
	ONbpGsXHzDb1R9JdkCgTjwEctf9ZT+8DgLmZvbhYjmwbD4fUXcBaJvW7L4QQYNvZ
	cFIZwN3TjketCteBYOOQNigNgFFR0ZBahef0FqZ8Ebal2b6/NpQSldQGSvQg2NK6
	5B9uPjOaB0XamVXbjYcVuv351dIFCODmk28ZxAz4bWoXq8vLJhPeyxEdFLvTS9QZ
	HkRRoaMTtYL78Bu0sr4Z8k04uXg4V1KH7AsOtxGtywnJTvvxBGmcFkHiF/qb2szb
	upeOk/5CSYyj6rZQtCbkbJ9l1ZUWbKWhAkMEkE/Vkc+vHWIUWLdPg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v31s5aeu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:39 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59MEKmII007865;
	Wed, 22 Oct 2025 14:43:38 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v31s5aes-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:38 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59MESOqf024687;
	Wed, 22 Oct 2025 14:43:37 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49vpqk0smu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:37 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59MEhXr237028328
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 14:43:33 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 64CD820040;
	Wed, 22 Oct 2025 14:43:33 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F0C3020043;
	Wed, 22 Oct 2025 14:43:32 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Oct 2025 14:43:32 +0000 (GMT)
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
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v11 11/15] unwind_user/sframe/x86: Enable sframe unwinding on x86
Date: Wed, 22 Oct 2025 16:43:22 +0200
Message-ID: <20251022144326.4082059-12-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251022144326.4082059-1-jremus@linux.ibm.com>
References: <20251022144326.4082059-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: F3xXjnxgxgrTIeryDNB1mEAo65nwNngK
X-Proofpoint-GUID: V7WfVzoyAZthuD4IL6uu6XdeiRVMqWoo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX2ao1s04eHvce
 R/pz6UGIhwX9zLB6ZPsT4sdvKTJXRJqM2KbTucvGBGOXOpxJA9HquABHh056RIu7X4UGVst6GZH
 8Dl+FjHGaRvptTEAcOtjrbu7rkH//zHUXR6Itm43P8pNOBFZmfA9rHvMnMBstxJPyCxTSWia6Xm
 e8ilo1iY+6abU2GlH+umdc/NLkZKyhUC3W2lIV25ggo8JfJdo/3+Q7iu7CpULVz+z4AvwCo1vTp
 pG7icm8pdXgG7jUOXU5Mgih7Wq+v8q9PqgMdaZEvzLrYDaekPK4oO/baSjZjxeW3YzhY1WJ51cw
 GDt/szvk0SnvoVkXexTEaj1l6kbVuVFkp/sYC960rUE5M+2hMoDjpAD7TLiPbTC83FnRDCnr2Ex
 QcG6Sit3KKf2Li/9CHz9wYLiaMPsLQ==
X-Authority-Analysis: v=2.4 cv=IJYPywvG c=1 sm=1 tr=0 ts=68f8ed9b cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=7d_E57ReAAAA:8
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8 a=yMhMjlubAAAA:8
 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8
 a=meVymXHHAAAA:8 a=uzhm0PpBqzKSIg-ONIAA:9 a=jhqOcbufqs7Y1TYCrUUU:22
 a=1CNFftbPRP8L7MoqJWF3:22 a=HkZW87K1Qel5hWWM3VKY:22 a=wa9RWnbW_A1YIeRBVszw:22
 a=2JgSa4NbpEOStq-L5dxp:22 a=DXsff8QfwkrTrK3sU8N1:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22
 a=bWyr8ysk75zN3GCy5bjg:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_05,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0 spamscore=0
 bulkscore=0 adultscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022
X-Stat-Signature: 5izih9iot7mjwd85s9gxj5ednm41umuk
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 65A5D40007
X-HE-Tag: 1761144251-832101
X-HE-Meta: U2FsdGVkX18lT32gL7TuBORHwqfQVsxEVhAMb7cPpE+Y4WIvoPO/mFnxYOCS56CRpNVQsNo/2cBCAYncfY5RUeGV7L7HQsbBapo9WLdRoyQ2rVTVuY+33FhYz2VJKKmQBC0gOp6TnX4n08I71eUAjGB8g1oXUpcRdStdmZ/Dd88VnbEySQ+hs4wgduO1A6qBUDgaix/7zf0RshHLyuB5cTZB9xctTpPpSRMrySGATCTHWVWawXU5bevgUWw4hVuktwYfOIHjfwCKqlaTNx8oYQuckPwGzUuFWLjH6Bvel19l625lKD/X1aeeZQDHCR40/23qWhCCI7Jc+XMj7n7HB6PZPn9hdeXpYiwWG0yYPWRzUJwsEfhp4TE1PtYb+mrC8AmKrFwQbTt183+no7CNr8SMDXSc4zdUpVQ7VKlGZgl+XinHUBRsdxANsdRffSHXIrflnKI4FRVyrlibvtv0QO0Mp7cLfuDq+4QD2pTnjqLyWq3pApbQBisZ3KyuuzeEnigdjeB4WGKXouyEyhCNdluXqAymXTwcN4Z825q8M4LCLbj0ImdT6LMq1MFYEY3Jo3mwMXI4+6at3miRqyc4BVH18yz9wk4UyPAVMhtz9G5zH+b1hpoQcboYngbbrEiCjgecZeWQiYUpuhHG9XJZtCuBBZju1SGjwp2ige8idPYwzjLvVujjbeWf4GBSZvH8piD3Fzio41sihmHau/ywEo+QmXtTRFg2J+S9dUamfuz9Op4b2auFa3sfutgkOpUjD+94Cdx2ZQXtKF/Jiph56k+oZ2//Vv09+VWArpbG9LEuo4q/zU4I4W0HNuEPd9Wvl1O9XIOywondSI3ba59euOerc2t4bplw1Syb6CQbwpiesrCF5eFmfgs0iINi6aapUN54W8KEaIcnvUGt76vcFZRzyGmy7ieMHhaMMmHdfrbjQwNnKE0Vd6LmZx8Y+k8CE1S6FfA4onAtfDU/DJW
 W9H7+Ddz
 HNs1z99y0q6fhvdbWp2yCdT1TWZxmzhN80aFDa2Abu6pT3LlDmNOFgqmZBZtcLTG4W2Eg+MFBeuCogHwXrXHiGUGFn9lmti/pDFazVGyueerO0c6qcf53IADmiQG3SmqyRW7oDXisG+G8/fY5+rq6AfuwZ6BsjagJf8dpBO3CUgF3PEy9Xhbq+byQ1rheU+tGlj5xrtJlKGmtCP4sBVJV51d0GkZAuETMup3tz5c4CdCky366J6kk8t94whfL588Tua4srrLMfrrG6Y4GfygW41QW0b9N6xoGqnsu09IzU6oITAIzt+AI/Mp/K7TEjvSjEodnzQv07z9wDGrRozApTLN/TnEO0tCHikaSTwzxpKCBChbFPXuS9e65RJIDPwr3WRQX5UIlSeI4kx7M1gw31U8RHVKVWnjRmYYw380cRqIlykIua4THg8PrWQacjUJ9V93YcTSgt0NGtWpDf5QaNZKgLl3clBJxhiBtsKePQYoD5zgRQqUI4QESyvFfDtGq/0TkvIdOR6R7P0pIcmK0k34mh/DxDwdecRqjvnlEg45B1MtUn1xw9gVU7eT7xcXFu80uWlkg2CMkeFUrMnQWY/Y5L4jMyhKpPUSXaSjKJe5YPTJ1V8zsvgQZA9jK7Lp7MimxNXnb2B6mw0VBWg97CbFW0na5rSbpSJEq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

The x86 sframe 2.0 implementation works fairly well, starting with
binutils 2.41 (though some bugs are getting fixed in later versions).
Enable it.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Indu Bhagat <indu.bhagat@oracle.com>
Cc: "Jose E. Marchesi" <jemarch@gnu.org>
Cc: Beau Belgrave <beaub@linux.microsoft.com>
Cc: Jens Remus <jremus@linux.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Sam James <sam@gentoo.org>
Cc: Kees Cook <kees@kernel.org>
Cc: "Carlos O'Donell" <codonell@redhat.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8f94c58d4de8..c3518f145f0d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -300,6 +300,7 @@ config X86
 	select HAVE_UACCESS_VALIDATION		if HAVE_OBJTOOL
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select HAVE_UNWIND_USER_FP		if X86_64
+	select HAVE_UNWIND_USER_SFRAME		if X86_64
 	select HAVE_USER_RETURN_NOTIFIER
 	select HAVE_GENERIC_VDSO
 	select VDSO_GETRANDOM			if X86_64
-- 
2.48.1


