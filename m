Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4750BCF34AB
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 13:24:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A17C06B00A3; Wed, 19 Nov 2025 08:24:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C7FB6B00A4; Wed, 19 Nov 2025 08:24:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 869316B00A5; Wed, 19 Nov 2025 08:24:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6CE066B00A3
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:24:19 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1E4381604A1
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:24:19 +0000 (UTC)
X-FDA: 84127425438.28.0FDB40A
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9701440003
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:24:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ojnpFOpm;
	spf=pass (imf11.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763558656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4y3LM4t1myVzp8ykIRFVERQ9BO+2u20q4avccARI3e0=;
	b=RQscdygTCEB7lQTZpLmbRuhPiSSkJsLyzwYDm76KpzqUQOaxoN/cOToCA4WNn1pGBLtWLm
	0G4SHyBuXEQHxreQFWAaoX2pLuqIyUm/8tE4KpJmGDHQtP6UwXZe4MEFjSRxigSDHKOnw4
	LQccW/8wwEyZfR28PlhyALUgH9zX8qE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ojnpFOpm;
	spf=pass (imf11.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763558656; a=rsa-sha256;
	cv=none;
	b=R/gsbnzuWD/1P7ro2/x8DZIq5MFyAELilqeFIHDJlGa70+5FHQPmus4b2VfqnwBBnFrjWR
	vsniIhgZ0jqvoA2bDBaRWegmXHeprRuiWhpjt0TkOWsPHmz8nvseTt2gfElRTaZjFoK/YN
	Y32vZw7Tg88EoFS8aQg7p4xPfm+h0Nw=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJ7lPJS018097;
	Wed, 19 Nov 2025 13:23:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=4y3LM4t1myVzp8ykI
	RFVERQ9BO+2u20q4avccARI3e0=; b=ojnpFOpmkw+dE3C898yuZ8KmM8BDckVFy
	LhPLqU+DO4SC2zBYXeUwUdiCrA2kuL0N6+VJkejlKDv6fGSSz7HZ6oSsxtGbVP8e
	TqKmPD6fkIz1aBq6KkLKw1ruO5U1WIpo7ZqcFKcsifBN1lRKtgPjJJdxz+Xrl92n
	T2OnCLQ3NdBaJlT96eOTsCh5zBwOtsbbyHDy9PTjl00dyiOCslfztRscK4M9pprb
	RQhAbXv3RWP/daGMiYAvqGrTnqtcoLQk81lumUctGqq4w0LCrOvidFZd8UhqT56I
	KBCMghXOzheqs+HrKPXV0U/pmKkjFj90BznIoWRgQTCeIK65y2IhA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejka0jcn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 13:23:38 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AJDFsBb018047;
	Wed, 19 Nov 2025 13:23:37 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejka0jch-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 13:23:37 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJBEm2P022434;
	Wed, 19 Nov 2025 13:23:35 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4af4un0tc0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 13:23:35 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AJDNVO936045160
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 13:23:31 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C5A7820040;
	Wed, 19 Nov 2025 13:23:31 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 450B320043;
	Wed, 19 Nov 2025 13:23:31 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 19 Nov 2025 13:23:31 +0000 (GMT)
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
Subject: [PATCH v12 10/13] unwind_user/sframe: Remove .sframe section on detected corruption
Date: Wed, 19 Nov 2025 14:23:20 +0100
Message-ID: <20251119132323.1281768-11-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251119132323.1281768-1-jremus@linux.ibm.com>
References: <20251119132323.1281768-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dasUaUOJpHebFMhJgsmDmO-6X7S72ESd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX6roNHJ3Sgr5T
 g0w/TinR4dYGNLryUzbMNRTLxhl8RfezYgHQXTH0V+yLtFS/pADobDgArk198VDEycF6FGJaEC1
 a2NlUyWg++C3zT99TEnGq+AG0k3UdOf9z2PjeeARcuXqLm9MUN6tUED45JymJn5VyhGqOR5Ruk/
 vDROOJ+IcV4aBAvq2fAt3CA7lWjATXUQImh98anoIZiOjOcZJag/PfbTdV1HvkftYHXR0gsU1Lr
 I60+U1PmeS+vLhBjVRyKefFCuiMowm69B4LAPN4bqSW9jZWJbUSbdslhHIkrpVJ/jiy4wW+6T2z
 Wxti3biy8H3LHC5l6eLz4r0o+QPOq/Usib8fIBXidztr6ZMvMy/eJU1efVy/MJuzTkaHuZ6ax+b
 WGumD1SSFt2osQwS0n7WEHCh5ZioyQ==
X-Proofpoint-ORIG-GUID: SLtu1LenXUFsCw6Xve05BxuMJ5AzEBGo
X-Authority-Analysis: v=2.4 cv=XtL3+FF9 c=1 sm=1 tr=0 ts=691dc4da cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=7d_E57ReAAAA:8
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8 a=yMhMjlubAAAA:8
 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8
 a=meVymXHHAAAA:8 a=UW-gzNxWWvgdzlWFvSoA:9 a=jhqOcbufqs7Y1TYCrUUU:22
 a=1CNFftbPRP8L7MoqJWF3:22 a=HkZW87K1Qel5hWWM3VKY:22 a=wa9RWnbW_A1YIeRBVszw:22
 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_04,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511150032
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9701440003
X-Stat-Signature: o8osc86te71g8qfz8ena6rzfcqsmnqei
X-Rspam-User: 
X-HE-Tag: 1763558656-481094
X-HE-Meta: U2FsdGVkX1+njaerUvntk/IFjh1/uNc6NHtD8tJ9mxPzZq/wtlVHf1Zn0hGRfh3ZDRMPlEk3KCqPopN27jtLdj56tYnWwrvqFyT6mD9jGMMF0Ft5aF0sUmb1Chz7QG2GoaG3q45ClkAx7GW3AfaoEcz2e2ImElupHp2fn7Ynzsi5ji6xpuk89dok8vqT6GFBkLGKGT0w3HH6MEeka6YlaSQYO7m6PCifoWC0m6cotYBVAOoKyht7abtmeWDb2Mx91R0PMiYpjPL/IRxoUGCOzRffZ5039qghgAnI6EcOobTLRYrI/5zdTHa0Zjc6KBqyFCyd0csFG21aZq9y8MCUtSqw3EyCvBgcKUui4loYppVSry9rR01gtyCQV0t9q9crcMqY/WWn7pQ0n5BZExhB9qlRujJBJo+8ToGKRH5ftBQ15U0bbmshAQkuv1R/SlS4k0Fq8+R5M+ZbSsF4zb8/vTOhL/GdunsvCohoSZ6SD+WJQcKubGxHSDydZfABWvqan89IQvcyDghK0NAXyefIDykR+teJfwkuv40/hWfqqcuAWXMq6Fa9E+sZIPahZOnuwybixhza2yvuFym2DCoLFISUJ/DihWw5nyAJN/X9DYky3Ku3UvAoTKoT9HhIeRO8Uh2eZKHwR5labJ9WcgGx+uxBDelsqKQAusQ6kNmkqDOqZFlsjjIRRSQEqMbUI/CEK9rwjTmB9h7Nnjr6/S/W93QzzvNFL0zstFdN11S2L25aP1aZGy4iKFslkNsof/9QQRmGZzYHfumECDhLROxoh6v7tWxI/gHUcaBg1zcOxSMPPAIShljSf4Fj6y3U1S9sdPUU0nWPcOu4b4X7Hhgn8Z4szBiNurscV96594FApR1zZmLPiii4m8zP4qkgWx8Clvst9Fa1uPvAln2TaG8s4luy6H+z48mtwl60XA4BqNBmi8CIJ9YYMNtSB6VwvpOKeWIA8CwtIr3WpCFAsKI
 dH9dPtBB
 8IMQHbP6svfeYufMoW+SYxIKNXfHyOn33PO3rCb/Wb4LOk4s4+xk8hL8lK3ZFrF8eQdEmf+eh1BY7xYatvJCQVUNLsdqMa/oBccs5p95MhAAGyU8cgNuq/394AXe+em9EpGyCQpLpkoQmmg4eeKFYqVFoTWPnxQ4uxQBcHifmgVhFU9mbTbEGc9LRuDDkdl4zfqVrrqlNCvKNr5IEC8MWHeOAXHcJM06yvnVK9xKFkNFD3Y4aPw7kBABo5tfOYdT6L1LDmQ8bY9sun3yEo5diVW2lQVwYJOWVbQ1JzsAYAHTXDAryKs6F6xyojVRrfk3XWAQDukF7CfdOfQ1NPJFJCBf9Pz+VPuU/LoKxT6OfjusCdxZQeoSgp3sGUcFUYupAGQh09R9DJ18M+fZsht4rODm8SRf8VwHhnXZtPnXLj6mreeN2WEVC662Qo6codbBXcByXQd/VvG6JRZ8whtpUkRQvyyTxzKna4Zu25tIgI8KRm0u2tZr5mSrpYuDVt+ShPtHwV5LOVCtMt8zHLM9jHny4bv+9Y1LEvz26nAJHWn+EqBrp0OlytSHlJCOq0MtdGX+JxCBZ2mkbkBFZHfaPIpkPz5vEYtH9onxh+46kFNg8izFolZZDVhQxVE5MAk6BTHTXVFUCxKIm3LSeebBZ1ed1mFnsXBqOKxws
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

To avoid continued attempted use of a bad .sframe section, remove it
on demand when the first sign of corruption is detected.

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
 kernel/unwind/sframe.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index 1e877c3e5417..61340ee524c2 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -342,6 +342,10 @@ int sframe_find(unsigned long ip, struct unwind_user_frame *frame)
 	ret = __find_fre(sec, &fde, ip, frame);
 end:
 	user_read_access_end();
+
+	if (ret == -EFAULT)
+		WARN_ON_ONCE(sframe_remove_section(sec->sframe_start));
+
 	return ret;
 }
 
-- 
2.48.1


