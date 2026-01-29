Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 787D7D6100B
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 11:28:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E3176B0092; Thu, 29 Jan 2026 06:28:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D1546B0095; Thu, 29 Jan 2026 06:28:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7A2B6B0092; Thu, 29 Jan 2026 06:28:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB6136B008A
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 06:28:07 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8294213BEEF
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 11:28:07 +0000 (UTC)
X-FDA: 84384777414.26.8CEEBA2
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf28.hostedemail.com (Postfix) with ESMTP id 19ACBC0003
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 11:28:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=f9t7Vms0;
	spf=pass (imf28.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769686085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B283hHvHfpCL4IzCW7e5rgv/2m8+TWdu+bstikX4vaM=;
	b=EG6+YlBtjqEAqsMmxJ541Xg4mZnGBo3OgR0DYjl43kTL3s/ZJRK/UAFnrL4oHQ5iWvqreQ
	8TkR+giWYH2hMqTEqqI6zV4szcqk4Tv+VGHFlmwKNnoBrhUoRTGhFF4uqtQZEa/DDQbU10
	SSjPx/JPWMVUQpaxoObagDIweKYqe0g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769686085; a=rsa-sha256;
	cv=none;
	b=I7uzbLByoYmIwVSdfV4Por6ebO7uQ1uXlqLHPGAEIiPHp4pbEeBEpFUVjPoZCPaFucjzIu
	Ir+aqw/ZsoidmDZVuD3y/iBWO4uprk5q3WAA45VBlkQ8yja6TTYajTQ6JnJuszksfMPta6
	QIWfCjLweVhwIUEalF6Nv8myMMu0Gk4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=f9t7Vms0;
	spf=pass (imf28.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60T6M2iq006586;
	Thu, 29 Jan 2026 11:27:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=B283hHvHfpCL4IzCW
	7e5rgv/2m8+TWdu+bstikX4vaM=; b=f9t7Vms0oHYWy2Njxss1BI9Yit6xWcHfU
	KhKs9PqTkQKPa0lrkYoTHAlvngwEPYTpDkzm7X6PAU1bWDKoVOcoSxsah0LcTby1
	oBVvXp87ZgZeoeBntQYNSUIOgJffxSL0fIqYhTc8OUllpIVitL7nOF5O7tAxa7Vx
	g3KosQGbkqRJm8ADxw4+P6Nb9fQSeG0mDvAEXpzZuEOsRzmPGh73M224HIaO8tPp
	/wNuHuaNnxL4SdOfBHUTrFEDP0kMUuhhDcA++3UySGIUXo+1d7X2XmZIWnZv5AWI
	VtZPECAQbUOPlG0h1WcOVy4TLlFuRD3I9c0+xEXwsBtjgkkP2Y0NQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvmgg5rv8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Jan 2026 11:27:36 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60TBRZ59028418;
	Thu, 29 Jan 2026 11:27:35 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvmgg5rv2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Jan 2026 11:27:35 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60T8CBCA017960;
	Thu, 29 Jan 2026 11:27:34 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4bwb42177c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Jan 2026 11:27:34 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60TBRVNc29557200
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Jan 2026 11:27:31 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EAD1F20043;
	Thu, 29 Jan 2026 11:27:30 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 675B02004E;
	Thu, 29 Jan 2026 11:27:30 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 29 Jan 2026 11:27:30 +0000 (GMT)
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
Subject: [PATCH v6 4/6] x86/vdso: Use SYM_FUNC_{START,END} in __kernel_vsyscall()
Date: Thu, 29 Jan 2026 12:27:24 +0100
Message-ID: <20260129112726.892340-5-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260129112726.892340-1-jremus@linux.ibm.com>
References: <20260129112726.892340-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Z4vh3XRA c=1 sm=1 tr=0 ts=697b4428 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8
 a=VnNF1IyMAAAA:8 a=SHk8SSwph--FxXLRiP0A:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-GUID: GzN58o449zNzhgbs410pbsOCA_Ura9w-
X-Proofpoint-ORIG-GUID: 7CWBQA2JshkNNJssMQBUwtXXHG-gVvQq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI5MDA3NiBTYWx0ZWRfX0LTztqBnU1Or
 ia8Mn8GfauLW51GG2AW49SjkCbOem412svDvXMd1KGKmvt7nJfGAOyJwOQDVNVlOvVRv/tqTvX+
 SZiucpE10m1Ay3ajKvfZid6ho26vKi4dKz/H5iTNYVBJDZ7gzZD1fg6feseTudQv7O90+sHi9tU
 sVgBnGxlD1w5DF1FJOFmmpwqpSbOWhxVk3pbmUp9SmEqTHxojK58IEi0TZGBICaLlXQdBbYL+Do
 UV1Ra0TpAApcACZcai+loZ4D/n+g6Oc2ZrHzhmyZv1Is99dbfC1WfnT4WJHRvNOkf9I6APEVv3H
 MX/FWXaEzYoE86CYi3q9dj0jret/jaCH5TJj6NFsx7lnqXMSM+0Oks4ShvGOz5NczERB5QHHSNB
 jPPcGQveSqCL5oMR3zyY+PCvj9RzblMCxaa08gQ+NbBZalhY5nk7ULeFNLRThWzVSAIZPyKM4iv
 Opi809XMQb52mRzteYg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-29_02,2026-01-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 phishscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2601150000 definitions=main-2601290076
X-Rspamd-Queue-Id: 19ACBC0003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: zz7cxn6yhsmp84yiqdk8b47yna1cj8xj
X-HE-Tag: 1769686084-882914
X-HE-Meta: U2FsdGVkX1+EHRuT2cNxjOrgrAuQcQlOLafw4aNC5J/rho3C+SIxF2LvPSui1qwPZh7m38gfq+ewfZU7auTfDMlRTX4VT1JUSgrTdxYPQel7XvG3FWmdhoiOWQ0/GkY2z27H0dZIL47m8pt20983UfB8HSS9FMw7Mo/Hy7IcMdzhygYH3nUPZf/nYFLsqX4DsqSRFSvHx35yWY7odD/51a2ILGUJscS2yy//wHY1ds3iZQtaYVXcK960G/WmlSfMkELUcZ2/0cvg34ZMUtBCfhIfqHLYdBlm7FBZ6S24VYHwWmb9L8qWZKxAIXymq4rCCnY0zx+4LcF0cDzLXax8o0iVprntjn/gDohpR1Bs3q7l2DrZXeaIbBIqceilsUSz5YORBihuivQLTipCLy8TAB/SIbksaYVT/9rRJevzDM+8Lzt5TVNz2ZUo7cAzmvMujaZ9d/AJVSHc3unqV9yVhhkYowQt4k5UG43enp+aWObGP+q59zVUdj16x+bVPAfcPDj7Aefot9FTw2cP04B6XP7UNxSQoQB5gYGzqR87fNcN1Dpzx1cogeDajTGYZFTOMC6xQdfrs3ScPK56BrSYcZCNDCVmdAoSP7K5F1ShHfcRIrUbHVO2IYebQXANsM0/vwJNfuyStrjstErXjobH2HbXc4Ez1LBEMsK+WOA2mJnpiRfELlUFPhX7pyS4r8Mz6GsZTVurdCO61ts5F5ZRXJl/Jm5YKq79ZG97lSJhkjIjJ1A3L2eDnHRiRFr7sPypDj+n1y9euOzY6EepZNGd47u3Ybn52jZkp79TgahQETYSug6Pcjs0eJa+XepRKZEh5Nvt9HpKD7oyxhGMoRrfrvoI41NMnQnAObgfLRcQn8PFeGwm4lMcEOwJ8d1hce0WJhdzE3igKgcID/pSiYyoMPJShvcAvFoskk/87QKhcVjaVnpZs4eoEGFO0c8GjPs12Dy0gK3SY68OHt9uXgQ
 DzrBQvJG
 WIiWO2mqye1FEgSaaXA6l49BuI3eK0ReWFK4GYBjZqAyyd/hiX4vMqqF6D4aZH7L5zZvhvSdMXjG8e0QBRJ/OGeLTTWpxC5R4ztvntP5jee/5SbDPSKbnzE91j4wbdJybpXp5U+GD2xpkLIY2fFdQ/b49RdQ//FtsqepZcIC4P55GUoVUDrHhGZjIjUaJ9RAVntSfVP70aMqWWlUJw+2d4Mz7rWDHUl1zg8DK9qx7951jlePf+a/T4+7NdFJPcAywBoLV0hi0oJuj98CcJUfbPCCorwYsdHa0/vTZ3dzsFeiWojLCr1XRhb7VX8AnEFYf8j4S8ln6s2Dv9t8qI2hGSl0PP/oaW9K1eneTpitZADrHPD8t3eei/firDAySRO8IPkJVAbegNmxtDqzboyPfhkkK9Clh1R7fSqK4ffGomlevBN8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

Use SYM_FUNC_{START,END} instead of all the boilerplate.  No functional
change.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---
 arch/x86/entry/vdso/vdso32/system_call.S | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/entry/vdso/vdso32/system_call.S b/arch/x86/entry/vdso/vdso32/system_call.S
index d33c6513fd2c..bdc576548240 100644
--- a/arch/x86/entry/vdso/vdso32/system_call.S
+++ b/arch/x86/entry/vdso/vdso32/system_call.S
@@ -9,11 +9,7 @@
 #include <asm/alternative.h>
 
 	.text
-	.globl __kernel_vsyscall
-	.type __kernel_vsyscall,@function
-	ALIGN
-__kernel_vsyscall:
-	CFI_STARTPROC
+SYM_FUNC_START(__kernel_vsyscall)
 	/*
 	 * Reshuffle regs so that all of any of the entry instructions
 	 * will preserve enough state.
@@ -79,7 +75,5 @@ SYM_INNER_LABEL(int80_landing_pad, SYM_L_GLOBAL)
 	CFI_RESTORE		ecx
 	CFI_ADJUST_CFA_OFFSET	-4
 	RET
-	CFI_ENDPROC
-
-	.size __kernel_vsyscall,.-__kernel_vsyscall
+SYM_FUNC_END(__kernel_vsyscall)
 	.previous
-- 
2.51.0


