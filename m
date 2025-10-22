Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C4F8CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 15:39:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86C288E0017; Wed, 22 Oct 2025 11:39:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81C778E0003; Wed, 22 Oct 2025 11:39:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E3788E0017; Wed, 22 Oct 2025 11:39:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 523C88E0003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:39:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ED12711AA08
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 15:39:02 +0000 (UTC)
X-FDA: 84026158524.01.FDA226E
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf07.hostedemail.com (Postfix) with ESMTP id 97BF240004
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 15:39:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=VRA7uMwM;
	spf=pass (imf07.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761147540; a=rsa-sha256;
	cv=none;
	b=hZ42pbb4UR+OhP73MilpE0xLK4vJM8C5q/ipeQIHo5eQfHc4LImZ8Qffz+l/OWMFX32kpz
	z1Svuu+74+XUouV0Cb62B3GvXpb36oBaYZyOLGuhDCnr+MQf26o1u+x11OlLf89cvHW1B3
	nDtuOu6wIaQrvqFc05IWP5se7IaltoY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=VRA7uMwM;
	spf=pass (imf07.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761147540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IyfDQ0fRCWABljfyI/uFCelnyxxXtxBwmcMJOLUyHuY=;
	b=yFiHDHmRHMvv6A3fvtqDYwdOWSn0Hevw5bel/knnG5CqNcXCSj1D2L4N4W1JCDGOxGr4KP
	lPfNVLB4j/50LmoAn1YgY1c+OcW2H9TYeHn/4ICJq/sM2A0awcGcHNKZWISXnK2ZlZb54i
	1EqKFvr+hDE8DAKqK6XusKMJbD2+B3c=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59M6TYW0016991;
	Wed, 22 Oct 2025 14:43:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=IyfDQ0fRCWABljfyI
	/uFCelnyxxXtxBwmcMJOLUyHuY=; b=VRA7uMwMSqE5t+6ZxmU8B31CSFe9Zroce
	2CBVq8TWDDEpx57feoIIKHyxV5tWiYbrQw3xgS1yK7VvYX1kYCxMFAks6OgWSmEw
	afin2+S0T5HdGpyRX/FM6oVhpqiCVQZAax1gXxkxEj37C3EgyGAfx7MG00zlP44x
	+L/OEP8R7ziKfzpMk+8LO8JOHrgEQdSme9uoYAzfnw4MVQXrlQxU9TBkCS1TkFWQ
	JFSgndYsSRA8dRuNNhklLn+DFgnPt+YiW1JSTRtdfozgJF/bVvirjCAL6jEWt7jH
	8U6J9B6YV9Uo102cQBz25GLDWdzxG4RHt7NP/q4ukrCFZHCpuHqwQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v32hkt68-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:35 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59MEX8V4000530;
	Wed, 22 Oct 2025 14:43:34 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v32hkt61-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:34 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59ME4lj9032249;
	Wed, 22 Oct 2025 14:43:33 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49vp7n0tuq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:33 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59MEhTD238142222
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 14:43:29 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B0F7320040;
	Wed, 22 Oct 2025 14:43:29 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3D3EE20043;
	Wed, 22 Oct 2025 14:43:29 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Oct 2025 14:43:29 +0000 (GMT)
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
Subject: [PATCH v11 03/15] unwind_user/sframe: Add support for reading .sframe headers
Date: Wed, 22 Oct 2025 16:43:14 +0200
Message-ID: <20251022144326.4082059-4-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251022144326.4082059-1-jremus@linux.ibm.com>
References: <20251022144326.4082059-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX9UaopVgvKC5N
 bJ8jK5P6fEbdn0xftCXfIlNtCQzgKsO1FrzZWzlhCa083HH/dbUGZNn056uGuBarS5z7y6058LA
 jlUYhTl06yBMvQjL+9dD4XghFyhO9Gt1HDnyVr3Q//GOGR0F8eIXlMJVZYjbuYahZUZ34yooEht
 MU5cw3JRjB61vgJRmjnT5vV5FCNMFBgDc8zaVeF68dygp5hZaZflSe0KOyJB4XOP1+YPYgpUNMe
 5bzKCYkRu2cqXYKor/0JAiR4QYjyQec7mEUg91/KC8NXtypUbf7L2KDILFtdS05TYRxWbvnnTIR
 cHZRILVlAFuEuypFN5bhxA/E4MsiY4eIlH12hbGzL5asIbQiEF9aB9LcnziLzP/nZmQ5PjO3JTv
 goPEo54KoPcVLFAIpxSW83HtCh7t3g==
X-Authority-Analysis: v=2.4 cv=OrVCCi/t c=1 sm=1 tr=0 ts=68f8ed97 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=CCpqsmhAAAAA:8
 a=7d_E57ReAAAA:8 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8
 a=yMhMjlubAAAA:8 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8
 a=7mOBRU54AAAA:8 a=meVymXHHAAAA:8 a=LluR8GWN1CZ1pnULaigA:9 a=gWTG3a1JFnwA:10
 a=0rJyKvmL6cEA:10 a=ul9cdbp4aOFLsgKbc677:22 a=jhqOcbufqs7Y1TYCrUUU:22
 a=1CNFftbPRP8L7MoqJWF3:22 a=HkZW87K1Qel5hWWM3VKY:22 a=wa9RWnbW_A1YIeRBVszw:22
 a=2JgSa4NbpEOStq-L5dxp:22 a=DXsff8QfwkrTrK3sU8N1:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22
 a=bWyr8ysk75zN3GCy5bjg:22
X-Proofpoint-GUID: TlaTeOy2GQJS0jQaYIQunkq9Ld07q6EJ
X-Proofpoint-ORIG-GUID: JX4-9C6NCbMX27Z6pJNbi-KiucrlZX8G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_05,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 clxscore=1015 bulkscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022
X-Rspam-User: 
X-Stat-Signature: 4ejcnwo8hceyeejns3koy438e5tarmdy
X-Rspamd-Queue-Id: 97BF240004
X-Rspamd-Server: rspam09
X-HE-Tag: 1761147540-254427
X-HE-Meta: U2FsdGVkX19/VkNfkmQiLBUkBPSGOHff/o+2tYBtNgb3QjwXTr+hIpozngM6YWJFaDX/apZfqzbFfmmxFsJvwt/ZsRLESi2nDkboBnEiXgG4bL8bPovRdECzYk8CTjPmSFOHI0WuI6iKnNqnwXGjJAEJOfs4E1dMLDO0EmXOPWJiCzWrRDSIeI540imZsJZrmfL8aZgozcGZEpTY78qnb+dUmTYoTiCI3OZGsNx4h+ATXxudkTsEAnJXdEgs2wIypuJkX1vsCACTeF4axquuumoIHayjiAAowuyUPxgrcSHeAlcXyLt2hIQMDnD8RgREnG26Oj2UBLH+1QwPIHcheJpqBJQBuecyBwNnxKPW7xKMAHhqDsoI9dFPZKC3qw1FB5LzBy/HQgwcqy3bXe3hnvUhWB0RzzOqw72w235UFGoOtcEvQYkEUbw5nkEt8cLEAxdh/Xtz+GYd4YNTbDuWXeB/hNwBRwfI85MVf4141yPZq1aBHDr8rmGk5+qWvTzZP8PnKG72As7Rj0Y3qx7VzWjWTBvkayKtALtDeDPirchOfz1vR3X/j47DmKXMPtFNrVFh+F9LdJEZ6x3ug9UBGX+2VuV9MmgHJQuTLBielq6POsc159KR7M905WwXHPpwjLtRApN0veAn1FivnNnEBRPFPC/j8oYMl5mjpkg1ClHvJp6gt0sNn97YhliXCtPXum5zODFDONxMusMvdd7GP6y44LgS43aJRns1QnchOls1NpMpWXyVnCye10tAIIjIsD5psufK3fVGF33tHr74ShFZebWvMJJ2gF6/Wx+Yl+GJDxRf6OXxMONJCiJxet7irIr6fFhK03C1XymJHbvgBlL+6LD7Tss3UKRWYBEvGLVE5AVlSwY+/nhR4vhk0Xpgo6bqQStVTZRP8gV2wewHHrMgNUafsmq3TepgSdCvhJPWyOXAkyI+GmGF+9Ilog9wMBQBdrFVJfeRCkrHAdj
 sOB9cAwt
 J/QySkjPFuVYZxmb4SS24jSCN8oZzAFc64lAjMnw06o9uH7eEQv5kEtU32SkEbxx5tKA0SpvqXzatow8XhFzpwjbyKzmbynU5MxvWbbSHrCuCG7NleT5/FpuWcAwWZHyY1CXSn5hiiPy9JdOAm+AtiQdQ2zlg4I23nqQQhgf1urvDxwY85NjeJafgv2xQEp2agyUs8mEEdw1O0TWvA62Z1NVRTrgKFnwsK/ka9oBumf5LyX2TyAI3J8fDhx24OUQDzEemVVhS0/kq8zwFnclI1N9XA3cl+Kl30XMibFp+nVj1ek6dpJHeYBl7Wwf4vg6BgJQoqggEGHjRDvSkoV8bXZ1fGYVGZVCMVS+n0rITr70hhNBbL8T/hTmex5jYG1wFs8Dcy8g9madBoL1AnA0vRDr7CRShy93t62VhlEbABgRvbZamQvPafXEQDhPgAezc8xlET/ZEsp0B1/1wR2HHSTqL+RzHnpVAxEFAthtHNbQPBqH8WZPhuPJCDYFco+rrQHFHZQBkfGvtu/9LS8/nh8AWliMJbSW0nsaNIHdJqHBWUeUlyyohpFyQdZvu5VHCy+OHAa3AtbMm+sYQHpJ5CToQdSVuewRYHKqkspQz6NIhWdsOH8ibKphI5cFOk9elPV+1pnkztjcoX49NSW7JseV4fqycfSDnImV423jTSOKJFV9OK4KeYbgrnXZCfN4WwsGu/M469+/uPeaq4a8G3Y+koPkMXbF9GV+7eSkd6IV4Pfx1GImAw4lUfNBtpvXx70Hfb0DnoD2ZUvMRYWldan7XzKI26P8wp4vm/8LWhjfltbU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

In preparation for unwinding user space stacks with sframe, add basic
sframe compile infrastructure and support for reading the .sframe
section header.

sframe_add_section() reads the header and unconditionally returns an
error, so it's not very useful yet.  A subsequent patch will improve
that.

Link: https://lore.kernel.org/all/f27e8463783febfa0dabb0432a3dd6be8ad98412.1737511963.git.jpoimboe@kernel.org/

[ Jens Remus: Add support for PC-relative FDE function start address. ]

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

Notes (jremus):
    Changes in v11:
    - Support for SFrame V2 PC-relative FDE function start address. (Jens)

 MAINTAINERS            |   1 +
 arch/Kconfig           |   3 +
 include/linux/sframe.h |  40 ++++++++++++
 kernel/unwind/Makefile |   3 +-
 kernel/unwind/sframe.c | 137 +++++++++++++++++++++++++++++++++++++++++
 kernel/unwind/sframe.h |  72 ++++++++++++++++++++++
 6 files changed, 255 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/sframe.h
 create mode 100644 kernel/unwind/sframe.c
 create mode 100644 kernel/unwind/sframe.h

diff --git a/MAINTAINERS b/MAINTAINERS
index fe168477caa4..251dcb49e112 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -26305,6 +26305,7 @@ USERSPACE STACK UNWINDING
 M:	Josh Poimboeuf <jpoimboe@kernel.org>
 M:	Steven Rostedt <rostedt@goodmis.org>
 S:	Maintained
+F:	include/linux/sframe.h
 F:	include/linux/unwind*.h
 F:	kernel/unwind/
 
diff --git a/arch/Kconfig b/arch/Kconfig
index d1b4ffd6e085..69fcabf53088 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -451,6 +451,9 @@ config HAVE_UNWIND_USER_FP
 	bool
 	select UNWIND_USER
 
+config HAVE_UNWIND_USER_SFRAME
+	bool
+
 config HAVE_PERF_REGS
 	bool
 	help
diff --git a/include/linux/sframe.h b/include/linux/sframe.h
new file mode 100644
index 000000000000..0584f661f698
--- /dev/null
+++ b/include/linux/sframe.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_SFRAME_H
+#define _LINUX_SFRAME_H
+
+#include <linux/mm_types.h>
+#include <linux/unwind_user_types.h>
+
+#ifdef CONFIG_HAVE_UNWIND_USER_SFRAME
+
+struct sframe_section {
+	unsigned long	sframe_start;
+	unsigned long	sframe_end;
+	unsigned long	text_start;
+	unsigned long	text_end;
+
+	unsigned long	fdes_start;
+	unsigned long	fres_start;
+	unsigned long	fres_end;
+	unsigned int	num_fdes;
+
+	signed char	ra_off;
+	signed char	fp_off;
+};
+
+extern int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
+			      unsigned long text_start, unsigned long text_end);
+extern int sframe_remove_section(unsigned long sframe_addr);
+
+#else /* !CONFIG_HAVE_UNWIND_USER_SFRAME */
+
+static inline int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
+				     unsigned long text_start, unsigned long text_end)
+{
+	return -ENOSYS;
+}
+static inline int sframe_remove_section(unsigned long sframe_addr) { return -ENOSYS; }
+
+#endif /* CONFIG_HAVE_UNWIND_USER_SFRAME */
+
+#endif /* _LINUX_SFRAME_H */
diff --git a/kernel/unwind/Makefile b/kernel/unwind/Makefile
index eae37bea54fd..146038165865 100644
--- a/kernel/unwind/Makefile
+++ b/kernel/unwind/Makefile
@@ -1 +1,2 @@
- obj-$(CONFIG_UNWIND_USER)	+= user.o deferred.o
+ obj-$(CONFIG_UNWIND_USER)		+= user.o deferred.o
+ obj-$(CONFIG_HAVE_UNWIND_USER_SFRAME)	+= sframe.o
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
new file mode 100644
index 000000000000..b28ec77bc9a8
--- /dev/null
+++ b/kernel/unwind/sframe.c
@@ -0,0 +1,137 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Userspace sframe access functions
+ */
+
+#define pr_fmt(fmt)	"sframe: " fmt
+
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/srcu.h>
+#include <linux/uaccess.h>
+#include <linux/mm.h>
+#include <linux/string_helpers.h>
+#include <linux/sframe.h>
+#include <linux/unwind_user_types.h>
+
+#include "sframe.h"
+
+#define dbg(fmt, ...)							\
+	pr_debug("%s (%d): " fmt, current->comm, current->pid, ##__VA_ARGS__)
+
+static void free_section(struct sframe_section *sec)
+{
+	kfree(sec);
+}
+
+static int sframe_read_header(struct sframe_section *sec)
+{
+	unsigned long header_end, fdes_start, fdes_end, fres_start, fres_end;
+	struct sframe_header shdr;
+	unsigned int num_fdes;
+
+	if (copy_from_user(&shdr, (void __user *)sec->sframe_start, sizeof(shdr))) {
+		dbg("header usercopy failed\n");
+		return -EFAULT;
+	}
+
+	if (shdr.preamble.magic != SFRAME_MAGIC ||
+	    shdr.preamble.version != SFRAME_VERSION_2 ||
+	    !(shdr.preamble.flags & SFRAME_F_FDE_SORTED) ||
+	    !(shdr.preamble.flags & SFRAME_F_FDE_FUNC_START_PCREL) ||
+	    shdr.auxhdr_len) {
+		dbg("bad/unsupported sframe header\n");
+		return -EINVAL;
+	}
+
+	if (!shdr.num_fdes || !shdr.num_fres) {
+		dbg("no fde/fre entries\n");
+		return -EINVAL;
+	}
+
+	header_end = sec->sframe_start + SFRAME_HEADER_SIZE(shdr);
+	if (header_end >= sec->sframe_end) {
+		dbg("header doesn't fit in section\n");
+		return -EINVAL;
+	}
+
+	num_fdes   = shdr.num_fdes;
+	fdes_start = header_end + shdr.fdes_off;
+	fdes_end   = fdes_start + (num_fdes * sizeof(struct sframe_fde));
+
+	fres_start = header_end + shdr.fres_off;
+	fres_end   = fres_start + shdr.fre_len;
+
+	if (fres_start < fdes_end || fres_end > sec->sframe_end) {
+		dbg("inconsistent fde/fre offsets\n");
+		return -EINVAL;
+	}
+
+	sec->num_fdes		= num_fdes;
+	sec->fdes_start		= fdes_start;
+	sec->fres_start		= fres_start;
+	sec->fres_end		= fres_end;
+
+	sec->ra_off		= shdr.cfa_fixed_ra_offset;
+	sec->fp_off		= shdr.cfa_fixed_fp_offset;
+
+	return 0;
+}
+
+int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
+		       unsigned long text_start, unsigned long text_end)
+{
+	struct maple_tree *sframe_mt = &current->mm->sframe_mt;
+	struct vm_area_struct *sframe_vma, *text_vma;
+	struct mm_struct *mm = current->mm;
+	struct sframe_section *sec;
+	int ret;
+
+	if (!sframe_start || !sframe_end || !text_start || !text_end) {
+		dbg("zero-length sframe/text address\n");
+		return -EINVAL;
+	}
+
+	scoped_guard(mmap_read_lock, mm) {
+		sframe_vma = vma_lookup(mm, sframe_start);
+		if (!sframe_vma || sframe_end > sframe_vma->vm_end) {
+			dbg("bad sframe address (0x%lx - 0x%lx)\n",
+			    sframe_start, sframe_end);
+			return -EINVAL;
+		}
+
+		text_vma = vma_lookup(mm, text_start);
+		if (!text_vma ||
+		    !(text_vma->vm_flags & VM_EXEC) ||
+		    text_end > text_vma->vm_end) {
+			dbg("bad text address (0x%lx - 0x%lx)\n",
+			    text_start, text_end);
+			return -EINVAL;
+		}
+	}
+
+	sec = kzalloc(sizeof(*sec), GFP_KERNEL);
+	if (!sec)
+		return -ENOMEM;
+
+	sec->sframe_start	= sframe_start;
+	sec->sframe_end		= sframe_end;
+	sec->text_start		= text_start;
+	sec->text_end		= text_end;
+
+	ret = sframe_read_header(sec);
+	if (ret)
+		goto err_free;
+
+	/* TODO nowhere to store it yet - just free it and return an error */
+	ret = -ENOSYS;
+
+err_free:
+	free_section(sec);
+	return ret;
+}
+
+int sframe_remove_section(unsigned long sframe_start)
+{
+	return -ENOSYS;
+}
diff --git a/kernel/unwind/sframe.h b/kernel/unwind/sframe.h
new file mode 100644
index 000000000000..559a74322666
--- /dev/null
+++ b/kernel/unwind/sframe.h
@@ -0,0 +1,72 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * From https://www.sourceware.org/binutils/docs/sframe-spec.html
+ */
+#ifndef _SFRAME_H
+#define _SFRAME_H
+
+#include <linux/types.h>
+
+#define SFRAME_VERSION_1			1
+#define SFRAME_VERSION_2			2
+#define SFRAME_MAGIC				0xdee2
+
+#define SFRAME_F_FDE_SORTED			0x1
+#define SFRAME_F_FRAME_POINTER			0x2
+#define SFRAME_F_FDE_FUNC_START_PCREL		0x4
+
+#define SFRAME_ABI_AARCH64_ENDIAN_BIG		1
+#define SFRAME_ABI_AARCH64_ENDIAN_LITTLE	2
+#define SFRAME_ABI_AMD64_ENDIAN_LITTLE		3
+
+#define SFRAME_FDE_TYPE_PCINC			0
+#define SFRAME_FDE_TYPE_PCMASK			1
+
+struct sframe_preamble {
+	u16	magic;
+	u8	version;
+	u8	flags;
+} __packed;
+
+struct sframe_header {
+	struct sframe_preamble preamble;
+	u8	abi_arch;
+	s8	cfa_fixed_fp_offset;
+	s8	cfa_fixed_ra_offset;
+	u8	auxhdr_len;
+	u32	num_fdes;
+	u32	num_fres;
+	u32	fre_len;
+	u32	fdes_off;
+	u32	fres_off;
+} __packed;
+
+#define SFRAME_HEADER_SIZE(header) \
+	((sizeof(struct sframe_header) + header.auxhdr_len))
+
+#define SFRAME_AARCH64_PAUTH_KEY_A		0
+#define SFRAME_AARCH64_PAUTH_KEY_B		1
+
+struct sframe_fde {
+	s32	start_addr;
+	u32	func_size;
+	u32	fres_off;
+	u32	fres_num;
+	u8	info;
+	u8	rep_size;
+	u16 padding;
+} __packed;
+
+#define SFRAME_FUNC_FRE_TYPE(data)		(data & 0xf)
+#define SFRAME_FUNC_FDE_TYPE(data)		((data >> 4) & 0x1)
+#define SFRAME_FUNC_PAUTH_KEY(data)		((data >> 5) & 0x1)
+
+#define SFRAME_BASE_REG_FP			0
+#define SFRAME_BASE_REG_SP			1
+
+#define SFRAME_FRE_CFA_BASE_REG_ID(data)	(data & 0x1)
+#define SFRAME_FRE_OFFSET_COUNT(data)		((data >> 1) & 0xf)
+#define SFRAME_FRE_OFFSET_SIZE(data)		((data >> 5) & 0x3)
+#define SFRAME_FRE_MANGLED_RA_P(data)		((data >> 7) & 0x1)
+
+#endif /* _SFRAME_H */
-- 
2.48.1


