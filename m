Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0B18D25931
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 15:06:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CBB26B008C; Tue, 27 Jan 2026 10:06:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8415F6B0093; Tue, 27 Jan 2026 10:06:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 632B86B0096; Tue, 27 Jan 2026 10:06:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E0F46B008C
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:06:34 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0523E13979B
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:06:33 +0000 (UTC)
X-FDA: 84378070308.21.BA76AE1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7906E40020
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:06:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=gJFysdCM;
	spf=pass (imf27.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769526391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iv/QDF4F57jd/avnhh5oZwrTLD1Pr75CntdhW6Ulg6c=;
	b=A5/7tGSZ6jKqa6zVVRoFWG9T9lJG9xmVdPDal/NpOD2+F0wqXKCMQTI3CjDzod870ndDyG
	vmHw0KaugB+fTMkri3I8xLBLEBqBWDTDFn+hJii0Fv0fY0eQK8ieJP5X4sXBeDuktic/QO
	iBOrEoGU9DzMeQL+2zOTJzuMDx53RiA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=gJFysdCM;
	spf=pass (imf27.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769526391; a=rsa-sha256;
	cv=none;
	b=4egJ+aha6sdIUO7ibsfSOhohFlQyorh9NuuB/+75niXO60LtpUCIo72jLLNxk4NMJSvrin
	jHM3E5M13BkXZW1kriAnTPdTMRsQCkLjsJ0ybkzR4GB5VVcg62d8nHOUMp3gWr/JiNGIvA
	1z+1CGacC9zn2f3QEtyA59fHQG2n4Ko=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60R6lnHn007318;
	Tue, 27 Jan 2026 15:06:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Iv/QDF4F57jd/avnh
	h5oZwrTLD1Pr75CntdhW6Ulg6c=; b=gJFysdCMw1sIwtMoLFA4bXWkEuYTlzU+C
	CLFGgETXrSVVVOgf3oY7SOJLj2LWi06ciKfTNe1X5NqXVMdAdOlpX+geX5Sda+Ck
	yXyAWtw6viiiN+uJFfsbD9By3horReF8G1QCdCb9BBbAwNnPIdUOVVcB2u6xx3IQ
	paE2qYQaTohQr5Lj1Qrzy1BiPHcfJ21ynwDvXSZEUaHwlkBEkCXCu9BUQ3ght7HW
	jc5t1hQ4spxvJNzgsIxIlOozhm9XeJEtltnqRDiVmO77xRfWnN3Yi/BOIVApN2cX
	VkyYXtvZuJjIcW7f8yVc21ZUZtdc2QAD0eospn857roxBTG+whn2Q==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvnt7p1ky-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:08 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60REpwUh002598;
	Tue, 27 Jan 2026 15:06:07 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvnt7p1kq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:07 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60RDK24o026513;
	Tue, 27 Jan 2026 15:06:06 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4bw9wk91jx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:05 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60RF61g019071292
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 15:06:01 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B292E20040;
	Tue, 27 Jan 2026 15:06:01 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5C7142004B;
	Tue, 27 Jan 2026 15:06:01 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 27 Jan 2026 15:06:01 +0000 (GMT)
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
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH v13 12/18] unwind_user: Enable archs that pass RA in a register
Date: Tue, 27 Jan 2026 16:05:47 +0100
Message-ID: <20260127150554.2760964-13-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127150554.2760964-1-jremus@linux.ibm.com>
References: <20260127150554.2760964-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gN9Ie2oXE6XmK2pw2kxSTY9196utoeeB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDEyMSBTYWx0ZWRfX8+H9rMU1UBVG
 CK5vKwe6dghhRv0aEhpPl32RezsG5njc2bVoPZxqxHDt/ZTiHjd3xjC1fwJ9/wrZ1bI6PIFQHEp
 VuA/xlyfKuRsWxznKqabE8Mp4Z8+QhkMLOpfo83t+2j2NSCzqWm7ScLSNVEd9hg6spJE65OjJc8
 KdeCu9e1zobAxHqE3ytt1nAs5zMPRu1iWOPTMgyXDPl/xVBYF0gCQX4DM3sKBgPiC0uSjzQp6u/
 x7q3M7rzlR5U2Xhkn4tDioKSl4DBbPWatJfrKH2Hz3FVAyxpjuHrhtAdfGQ4jopp3PY9dmScZht
 uO+pKk8VhY5B1ohbiyFTlz7UdkRLy+0rNLcO6no5iKQintm/yedr77cBr0W3GTDcR2wF/Z/BSLI
 H3udbZyodkg4IUpQu/Q9S3lnyc+rmMv1Nmsb63etHcoAtJB5Crdyi5AflgOtPHpwRS/iRn2DQjj
 eJcVwkofOMw+X2eTJwA==
X-Authority-Analysis: v=2.4 cv=Zs3g6t7G c=1 sm=1 tr=0 ts=6978d460 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=7d_E57ReAAAA:8 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8
 a=yMhMjlubAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8
 a=BZmVhOMqpLk0IJKryeUA:9 a=jhqOcbufqs7Y1TYCrUUU:22 a=1CNFftbPRP8L7MoqJWF3:22
 a=HkZW87K1Qel5hWWM3VKY:22 a=wa9RWnbW_A1YIeRBVszw:22
X-Proofpoint-ORIG-GUID: tbgXXc5An2wsk3YCAZR6rR_lesBL9Ea-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-27_03,2026-01-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 phishscore=0 suspectscore=0
 bulkscore=0 impostorscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2601150000 definitions=main-2601270121
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7906E40020
X-Stat-Signature: 93j7pjh58jwu5wuk8xrc93zg74jkbo9x
X-Rspam-User: 
X-HE-Tag: 1769526391-361621
X-HE-Meta: U2FsdGVkX1/dlOvBsGd5LwvqzUWLqE6JuR/V6PwyetM9C4DfP3LnS4TmNb13PlDsB1AgxWRGfwv6YlweHPFY670XMVEOYG8cdwfZBLfQHvomPOSqWdr04obAYrMDIf48LARmRCsNY7gKXOMKRaXPvbhE8LXKvQ8MXYVRLm66Mhri3rWHwE4tDxkdV44ls4DQm4HtzAMctNYpgqoM/O9pR32BwkGmkCqM8rQp8yrQSziz7uucL8/tiDNOTIf7im51+yvpOTT14Hwv1e/9nN+HVeWjea4ZReqDZaUQ71R5jdTHmit3rqPPfXUjj/mKD6eCtM2ozF6XgScx/E+KBU8YqxTZRRd7H2HKlU7UkjFANS319YszJ8d4/mhH/EAC18BfYwp9HhUMc9Ekw4HcJLc5dEmPcl1JbMYPm87V0zcHnJUDA4A0YpxMTb5SQAnl2Ip3ZwZG+gnn3qF5Yr9sNj3+FMNvz0v4tZ9D01VmrhA8aGxnb3uWMsspTzz7Bv2VLBRUp33yUTaqikVrrZc2Vz8aoTz9lnrDW0G2Fn2l9O9FxWIMHwhdPD2ZUIA84EKAHvsIZzYjjGK8qLP3uEgKJ3vQYbwMzQosTNeWtXOl6RKbIkhlmra5DHO3Up/FDuPNWuEM2b0WCsgxe8J0IZMG31WMisXfRltGnxwr4K4EwqF76xojQLIZjU9Rc3EHINap1h7ns+o+tPgZwYTEyBTj9L/1fyb57sYr5xmJXStkWE3+IspncVNzlyB/f1jEn/zxp8Xchv6nbPXPZbn4+JB2/gGRjbMushwgLWlmWHiGRlUr5bl7yZAHr01UOZovvyMBvqnRZKzhK/tPwSEvfYWjQjTSyx3T5oJuXQf7EkR/E7/7xDuumfviJPFat7ywut7rqmXPe+VAhtDrPWveb6PtTbR7MbhS4+nTDK7xS0XcoO50G0AI68gTdqHYOlqgA/YfuziZJinOUZfYVCWNYANQxMs
 LT0+mNGW
 AuxUeEP9pRhX/7BxJbsEEJrUDM8a6oSnc3TM6BynJCWTABmdeNVdImc0CPTkoU43Z0mttn1KbMX9PA7WEedu5Zsezs3cQX4WmRQTt3rzESYaWk1xy9WiWKNtArnU+Pb2PXrpxgg52n4H7AHh7B6ox4NfB3chuyU3Bkdl8LJnYSs0JOb9npUDMxXQVEPIJL+BS91df+BgigBYdoOWUa7oj432a00IvSm0nPT5mG8czzWGrn+j3y43DcX7hJMINYnjX2dDe7cM3LMq+dEJl4t4UYahuDMuuV5uYSPwmG/xoU6jtwWWcMbpCxpnKq9nITYl/02glnT8pbEYc6bsqASLdh3Ec/lBX3JUCveFyAAmg61DjimXLvDkNMMmr5y6iR04Np3ZTYJagCNcHtT+Xrjqj8f0mlAiyYshkmoLBo5gXiBi3BNmTmJJbJhSlHcPy1TDd4QvDIai6RynTlqm7dFA860EsIFcva9yaKJ0r8ph3lpavymyX1KIQHdX9Ztkhn0geHtm/YCK1za4bUHKdgpE+Teqb0B84yL+ocwakvKG7PeG1oAmzcUOQadJH6qvuX6mJg+PrwbbYjPMENdZlrJuPJ8pJsb/9c/l+TNLR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Not all architectures have the return address (RA) in user space saved
on the stack on function entry, such as x86-64 does due to its CALL
instruction pushing the RA onto the stack.  Architectures/ABIs, such as
s390, also do not necessarily enforce to save the RA in user space on
the stack in the function prologue or even at all, for instance in leaf
functions.

Treat a RA offset from CFA of zero as indication that the RA is not
saved (on the stack).  For the topmost frame treat it as indication that
the RA is in the link/RA register, such as on arm64 and s390, and obtain
it from there.  For non-topmost frames treat it as error, as the RA must
be saved.

Additionally allow the SP to be unchanged in the topmost frame, for
architectures where SP at function entry == SP at call site, such as
arm64 and s390.

Note that treating a RA offset from CFA of zero as indication that
the RA is not saved on the stack additionally allows for architectures,
such as s390, where the frame pointer (FP) may be saved without the RA
being saved as well.  Provided that such architectures represent this
in SFrame by encoding the "missing" RA offset using a padding RA offset
with a value of zero.

Cc: Steven Rostedt <rostedt@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
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
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    Changes in v13:
    - New patch.  Based on my s390 sframe support series patch
      "unwind_user: Enable archs that pass RA in a register":
      https://lore.kernel.org/all/20251208171559.2029709-11-jremus@linux.ibm.com/

 include/linux/unwind_user.h |  9 +++++++++
 kernel/unwind/sframe.c      |  6 ++----
 kernel/unwind/user.c        | 17 +++++++++++++----
 3 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/include/linux/unwind_user.h b/include/linux/unwind_user.h
index 64618618febd..bc2edae39955 100644
--- a/include/linux/unwind_user.h
+++ b/include/linux/unwind_user.h
@@ -23,6 +23,15 @@ static inline bool unwind_user_at_function_start(struct pt_regs *regs)
 #define unwind_user_at_function_start unwind_user_at_function_start
 #endif
 
+#ifndef unwind_user_get_ra_reg
+static inline int unwind_user_get_ra_reg(unsigned long *val)
+{
+	WARN_ON_ONCE(1);
+	return -EINVAL;
+}
+#define unwind_user_get_ra_reg unwind_user_get_ra_reg
+#endif
+
 int unwind_user(struct unwind_stacktrace *trace, unsigned int max_entries);
 
 #endif /* _LINUX_UNWIND_USER_H */
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index cf353bdbc907..fc905504ddde 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -243,10 +243,8 @@ static __always_inline int __read_fre(struct sframe_section *sec,
 	dataword_count--;
 
 	ra_off = sec->ra_off;
-	if (!ra_off) {
-		if (!dataword_count--)
-			return -EFAULT;
-
+	if (!ra_off && dataword_count) {
+		dataword_count--;
 		UNSAFE_GET_USER_INC(ra_off, cur, dataword_size, Efault);
 	}
 
diff --git a/kernel/unwind/user.c b/kernel/unwind/user.c
index fdb1001e3750..9ceef9b2b8db 100644
--- a/kernel/unwind/user.c
+++ b/kernel/unwind/user.c
@@ -48,8 +48,12 @@ static int unwind_user_next_common(struct unwind_user_state *state,
 	}
 	cfa += frame->cfa_off;
 
-	/* Make sure that stack is not going in wrong direction */
-	if (cfa <= state->sp)
+	/*
+	 * Make sure that stack is not going in wrong direction.  Allow SP
+	 * to be unchanged for the topmost frame, by subtracting topmost,
+	 * which is either 0 or 1.
+	 */
+	if (cfa <= state->sp - state->topmost)
 		return -EINVAL;
 
 	/* Make sure that the address is word aligned */
@@ -57,8 +61,13 @@ static int unwind_user_next_common(struct unwind_user_state *state,
 		return -EINVAL;
 
 	/* Get the Return Address (RA) */
-	if (get_user_word(&ra, cfa, frame->ra_off, state->ws))
-		return -EINVAL;
+	if (frame->ra_off) {
+		if (get_user_word(&ra, cfa, frame->ra_off, state->ws))
+			return -EINVAL;
+	} else {
+		if (!state->topmost || unwind_user_get_ra_reg(&ra))
+			return -EINVAL;
+	}
 
 	/* Get the Frame Pointer (FP) */
 	if (frame->fp_off && get_user_word(&fp, cfa, frame->fp_off, state->ws))
-- 
2.51.0


