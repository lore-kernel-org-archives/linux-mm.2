Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE57CCF34AB
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 13:24:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEE656B00BB; Wed, 19 Nov 2025 08:24:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9F306B00BC; Wed, 19 Nov 2025 08:24:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3ED26B00BD; Wed, 19 Nov 2025 08:24:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B0F86B00BB
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:24:47 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5AC9D1A04CB
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:24:47 +0000 (UTC)
X-FDA: 84127426614.29.6FC87DD
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf04.hostedemail.com (Postfix) with ESMTP id D933040015
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:24:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=DhKBmDT7;
	spf=pass (imf04.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763558685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bilScElAOM4k5WNcerarlTGdLza8WPvlYYI76EOMn9Q=;
	b=dDjMYGNRfdrw1XLQxHU+GHlEP5A7pf4ghs3XVkFqwz1daDJutyNd8yxsI4vs19oKCQRySm
	nOsz2kN7h72FGyrKwP/vixoAUWl/EpKHTKK6CYc1d0tiRScPT3qbSNC47Zobgt2su5Jfdd
	bA5+rFj5nQ8E/RDhYzueORVoK1BYdw0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=DhKBmDT7;
	spf=pass (imf04.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763558685; a=rsa-sha256;
	cv=none;
	b=nLSsxak9XnUWWed0w0b4Cqs+2sL9rgvTQK3N4LXm00R/kYcDAfPxzfzYclRJCR3Gxl+tvS
	AgGU9tNiIvv+4XIMNfEJb4BJ6h6+67YSSI/R4OIeeyHu6HkfW/R4ne8bMSFBMY3oz+qs5m
	fz1fCtSRxnv1G4ZzldG2ooZorXWKgSg=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJ60KeE005943;
	Wed, 19 Nov 2025 13:23:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=bilScElAOM4k5WNce
	rarlTGdLza8WPvlYYI76EOMn9Q=; b=DhKBmDT7uk5uBt6o2BhVF/WCAw3IJOcIh
	PPfnBJcVMWriX/ermM6bhqFSWlT4YLAg0ELLvit2LNlB4bQJ4qFzb32oYsySyKDt
	AuO/3/pRfHQZ1PTYtojPzC+wvsS4zLWu8GWmFC+IvjxEpgRsBLShqtGpSP9euwky
	P6D01SJimV/0mQN7UbQFO7lHFhWQC+SFkupDVSo/SDfNelvXCn9mYrwXzmhLY6w+
	6SKGWIB92+ECgI/SDavfhJHDHWhFNjrzxawxnRWs4ufhKBgiWop6OkBoXy3KKxHr
	cHygB9UUmns04+ZYZc9VKqc2pZJJV9f8m5YHJ5WzVkySZw8QDIyyw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejka0jcq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 13:23:38 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AJDLD9b028950;
	Wed, 19 Nov 2025 13:23:38 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejka0jcj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 13:23:37 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJA1pa5010419;
	Wed, 19 Nov 2025 13:23:36 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4af3us8y53-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 13:23:36 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AJDNX0P25297192
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 13:23:33 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E98D320040;
	Wed, 19 Nov 2025 13:23:32 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 68F2820043;
	Wed, 19 Nov 2025 13:23:32 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 19 Nov 2025 13:23:32 +0000 (GMT)
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
Subject: [PATCH v12 12/13] unwind_user/sframe: Add .sframe validation option
Date: Wed, 19 Nov 2025 14:23:22 +0100
Message-ID: <20251119132323.1281768-13-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251119132323.1281768-1-jremus@linux.ibm.com>
References: <20251119132323.1281768-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -ktxfelSEHO1S0-x_8XUubXNlHmX4VLn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfXxdKepSesuO9q
 yrignO2mA/haT12FscE2kh9D8BmR0a+5iFNzC2cLfmXbCIgr8YMIcGMJ58pWMSzJGm7e1kqBZ8J
 F7H4jSXce859bkoUa7Cs4EKfSws3BAfJB5Vcczt7apv5sSdXF0DD9IOI2ArdOLYUWk/G0eQTcgh
 rvb7lQtn+ZNxiZg7qiOidjHT36dxQi4/wcZ5rGYmN2NXeTvrI8h1ti4dXqk0Bq+3qRKU/PSqZMU
 krRb30d+UObAd4uahOyJu/MSKigoK5G/eIgSX7peNuFjyJJdz27zoblVdEhMqC1c2o+torAx01z
 pKWtAjCUzge6gML6kVDgBS7h00otSmvBN1b4m/iSiIJE5RwI3MfTEoS+DlE4EVoXJLyw/k92I3N
 oPWNU1oQLwI7jLog2qb3+NGmgjxRVA==
X-Proofpoint-ORIG-GUID: e1BxXyBm0ZA4EiM_3N3mCpNoscNDoDVH
X-Authority-Analysis: v=2.4 cv=XtL3+FF9 c=1 sm=1 tr=0 ts=691dc4da cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=7d_E57ReAAAA:8
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8 a=yMhMjlubAAAA:8
 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8
 a=meVymXHHAAAA:8 a=RXKZOtKmAAAA:8 a=X__uKv6Ezr3YNgStCWAA:9
 a=jhqOcbufqs7Y1TYCrUUU:22 a=1CNFftbPRP8L7MoqJWF3:22 a=HkZW87K1Qel5hWWM3VKY:22
 a=wa9RWnbW_A1YIeRBVszw:22 a=2JgSa4NbpEOStq-L5dxp:22 a=UFF3uGjEBZWolfm0k6KQ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_04,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511150032
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D933040015
X-Stat-Signature: 4yq5466dmgqfgkw3pzb5exdd6cuszwx5
X-Rspam-User: 
X-HE-Tag: 1763558684-670207
X-HE-Meta: U2FsdGVkX1+EwRATrwziw6qicjYdnYB/qMd3d7t1F+RhcOADMCS9TCy2bIi6KmkSZD5NCuoXQiDfl71o/75QnkBG13ULYJRccFUe0L5f0TExM9VtbFgPezMBYaxSPbhSi80jMuIQ11TLR9ENaOkW4ovxpYTQhaZZj1rjW2dOIXT9fnortqzn4hqcZELi3Hsm+HOtpMJhXsLZ+44YgDHwikdwzm6NhTNa0P5T/Ncfic+MsVdCR3r8xfnr/jC97MWVKDabs1WF4Ygk19b2FUGr9Q5Kzjx9vH+1vjLvuySq5ulNa32ip+IHJx84V/QAUOmIF7FV8hD26lS97t+hl41WQBWgn3iQ4khgkUW2FIoyauHc33uttAB9Sk3PqqualjAuZXxAdMsrMmZoTCQV2nAo4Of/jR1Pj2CxvZ8RWHmKNWAXzjAtj5njG8pOfxIALItH455AHG3Ds6bow8Qcms0RBu0hOjqPnL4s8qekO2JvzMKCziwHKlm1Fc9oAl6l7kDNzmyyBIiCNLNwLUKJxycc+m2UjaZM+zEfU2gpCxcnIpF4yYlk1oaa4rMUmG1oI1kT6qLWEadgBHDHb+s7bACpm2lQfcLPSUUmbUt2CgyZrFNn1zoa7loId6oo0YLDxc7IsVRSyRw4y/EVQ0xrxk3LfAtE5xp+0QyuiiMD1h9rgEanXe/AOo6PWJAaRXtzL57ek+9bqMaHFmZtitXpFaDjHOVR/Og6hzfsYForSX2aDfo7SQ27MZCvHepniJUXDPD/b+1SeqWavcesj0ZzV6qEiQkql/B2/sh4uNk87q4/linlu10jMnPOLIK1K+lgZ3/YSu2YMCWWpCCf8+5othgKGPgEDok5mT/5XvMZYMINlB8C4pqiXdYFkfDyEEtpIgV/wL3SYXG321wVqmHYiHOHaYH2wiwgU6biLFu8U13V3LG7/6lal/CJzAuJwVqjaEZgBCcBWDXMG8ogVsz3y0W
 bvkgrf9c
 LQ+Y8UN+H1pe7q5XCb+7UjbtK0GCDJ+xPjX7YCPBtf4M6a3IhKxL3E2QHhZYzXjtK625FDEElL5fUXx0l9Lyl7gn3qHvMclnLbnGiYcsyaCm4qu8Ykul+eKkreLUDlTCLBhvxWPx7MGrjiYobK1xLcdLTAudpNOy32puF888LGG6ipjYUC+U4ex/n/mPtrzFeImdF2Iaxs3ffBAvg5kFsUBrBt5SZaPa7ywseba/VEJNn/VR/LgFHHo765Ewqwp6OhjKe1okhRx+5uBc2XgCTwyaVjv+9osBmgaTyrgNSWxKV4R1xVUlzlKQLjt7ZxKPEknWao9wWcKyFG6hPHDui7QQC3sBpN9+UIxjL0yYnJ68vkuHz2Gyq2WXe7Lm9jD/tCP+72JwTmOoqHBwMYG5mUOgAwN65nl3NsIzuQ73itTrYfWYJuk/2HqkQ9KaYlAy0ueBF4uWELeIrHKB70smTmfriwLWlzXTnZTF4d5DzKZQFdFikwyW6LJUc9J9yzYhiH95YxS+jzOAP7vxfHUCujFrDPkKu0YJpnWP2gzF3p0EndE/BQoBcBzsrMPahNy0bF6jZbUsbMEFohLONTdg7bXhiF9JWnaiQMdLlI8aeLjaIeC1EIV0h07DriJk+gi4Hm3B7S2t/+bYEjnKca2VEwe7jXkO42bUU1bDeBiL/I79163P16eb4tXtgWXP/aeMj1tNCNeNKpGESEsG//vcuufT0lBSXfn/e2krNwEE5LeVuXmVM5V6sK23Vp8Hg9rHHmx+gvE7jUnZ4my326AcDSsra0gY7qPn87K4KSfqZ8k0P/kEje9vSN84c1EmpwclkTyw155vDpXGr4kgQM5iFPWkkDQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

Add a debug feature to validate all .sframe sections when first loading
the file rather than on demand.

[ Jens Remus: Add support for PC-relative FDE function start address.
Adjust to rename of struct sframe_fre to sframe_fre_internal. ]

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
    Changes in v12:
    - Adjust to use internal SFrame FDE representation.
    - Adjust to rename of struct sframe_fre to sframe_fre_internal.
    
    Changes in v11:
    - Support for SFrame V2 PC-relative FDE function start address.

 arch/Kconfig           | 19 +++++++++
 kernel/unwind/sframe.c | 97 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 116 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index ab1941ef1411..06c4f909398c 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -493,6 +493,25 @@ config HAVE_UNWIND_USER_SFRAME
 	bool
 	select UNWIND_USER
 
+config SFRAME_VALIDATION
+	bool "Enable .sframe section debugging"
+	depends on HAVE_UNWIND_USER_SFRAME
+	depends on DYNAMIC_DEBUG
+	help
+	  When adding an .sframe section for a task, validate the entire
+	  section immediately rather than on demand.
+
+	  This is a debug feature which is helpful for rooting out .sframe
+	  section issues.  If the .sframe section is corrupt, it will fail to
+	  load immediately, with more information provided in dynamic printks.
+
+	  This has a significant page cache footprint due to its reading of the
+	  entire .sframe section for every loaded executable and shared
+	  library.  Also, it's done for all processes, even those which don't
+	  get stack traced by the kernel.  Not recommended for general use.
+
+	  If unsure, say N.
+
 config HAVE_PERF_REGS
 	bool
 	help
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index 7d3e286c1b23..6465e7a315bc 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -351,6 +351,99 @@ int sframe_find(unsigned long ip, struct unwind_user_frame *frame)
 	return ret;
 }
 
+#ifdef CONFIG_SFRAME_VALIDATION
+
+static int safe_read_fde(struct sframe_section *sec,
+			 unsigned int fde_num, struct sframe_fde_internal *fde)
+{
+	int ret;
+
+	if (!user_read_access_begin((void __user *)sec->sframe_start,
+				    sec->sframe_end - sec->sframe_start))
+		return -EFAULT;
+	ret = __read_fde(sec, fde_num, fde);
+	user_read_access_end();
+	return ret;
+}
+
+static int safe_read_fre(struct sframe_section *sec,
+			 struct sframe_fde_internal *fde,
+			 unsigned long fre_addr,
+			 struct sframe_fre_internal *fre)
+{
+	int ret;
+
+	if (!user_read_access_begin((void __user *)sec->sframe_start,
+				    sec->sframe_end - sec->sframe_start))
+		return -EFAULT;
+	ret = __read_fre(sec, fde, fre_addr, fre);
+	user_read_access_end();
+	return ret;
+}
+
+static int sframe_validate_section(struct sframe_section *sec)
+{
+	unsigned long prev_ip = 0;
+	unsigned int i;
+
+	for (i = 0; i < sec->num_fdes; i++) {
+		struct sframe_fre_internal *fre, *prev_fre = NULL;
+		unsigned long ip, fre_addr;
+		struct sframe_fde_internal fde;
+		struct sframe_fre_internal fres[2];
+		bool which = false;
+		unsigned int j;
+		int ret;
+
+		ret = safe_read_fde(sec, i, &fde);
+		if (ret)
+			return ret;
+
+		ip = fde.func_start_addr;
+		if (ip <= prev_ip) {
+			dbg_sec("fde %u not sorted\n", i);
+			return -EFAULT;
+		}
+		prev_ip = ip;
+
+		fre_addr = sec->fres_start + fde.fres_off;
+		for (j = 0; j < fde.fres_num; j++) {
+			int ret;
+
+			fre = which ? fres : fres + 1;
+			which = !which;
+
+			ret = safe_read_fre(sec, &fde, fre_addr, fre);
+			if (ret) {
+				dbg_sec("fde %u: __read_fre(%u) failed\n", i, j);
+				dbg_sec("FDE: func_start_addr:0x%lx func_size:0x%x fres_off:0x%x fres_num:%d info:%u rep_size:%u\n",
+					fde.func_start_addr, fde.func_size,
+					fde.fres_off, fde.fres_num,
+					fde.info, fde.rep_size);
+				return ret;
+			}
+
+			fre_addr += fre->size;
+
+			if (prev_fre && fre->ip_off <= prev_fre->ip_off) {
+				dbg_sec("fde %u: fre %u not sorted\n", i, j);
+				return -EFAULT;
+			}
+
+			prev_fre = fre;
+		}
+	}
+
+	return 0;
+}
+
+#else /*  !CONFIG_SFRAME_VALIDATION */
+
+static int sframe_validate_section(struct sframe_section *sec) { return 0; }
+
+#endif /* !CONFIG_SFRAME_VALIDATION */
+
+
 static void free_section(struct sframe_section *sec)
 {
 	dbg_free(sec);
@@ -460,6 +553,10 @@ int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 		goto err_free;
 	}
 
+	ret = sframe_validate_section(sec);
+	if (ret)
+		goto err_free;
+
 	ret = mtree_insert_range(sframe_mt, sec->text_start, sec->text_end, sec, GFP_KERNEL);
 	if (ret) {
 		dbg_sec("mtree_insert_range failed: text=%lx-%lx\n",
-- 
2.48.1


