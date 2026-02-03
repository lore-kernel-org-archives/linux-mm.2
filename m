Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEA19E8784E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 17:23:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C67E56B00D6; Tue,  3 Feb 2026 12:23:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C15EA6B00D7; Tue,  3 Feb 2026 12:23:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE9FE6B00D8; Tue,  3 Feb 2026 12:23:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 94D296B00D6
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 12:23:14 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2BBF6D5110
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:23:14 +0000 (UTC)
X-FDA: 84403816308.04.23B9AED
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf17.hostedemail.com (Postfix) with ESMTP id A25DF40012
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:23:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=K1sQJ++W;
	spf=pass (imf17.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770139391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CnWoYOdHFi1HilfZZLKuTxOQwNFfkM0hR+YIehVIffE=;
	b=xy03fXIYO26rgrxqu4yoqwneuQyeWb6JkhqaRHpnxpXPra2thpLpM4aAjFN4ARC1hB/Ygo
	lEIM/FwxkEsU6hBnY9Nja7l0AuBxny4I5lVnyLV/el3seQCQQooRPnZkxketdhJOwXwsZ5
	CDo+9Nj8CVKU+oOzmXoJRb4ikQw5MlI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=K1sQJ++W;
	spf=pass (imf17.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770139391; a=rsa-sha256;
	cv=none;
	b=SeOWKiI9RIrdPbzmQ1S4/SlA4qYoj1ShoXs2DH6CP9wRVUTqPNGYLTM3hoT79uacF9e3YQ
	vN22o+Qksu1Aaz8CO01+1MZbhAT2g1izAs/cmxZvszTRcCIUDyLYVbgKbDfOmft511QgML
	uZSE0tav3SUT0jqIenmKEFcavs0Y7t0=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 6139ScWr027933;
	Tue, 3 Feb 2026 17:22:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=CnWoYO
	dHFi1HilfZZLKuTxOQwNFfkM0hR+YIehVIffE=; b=K1sQJ++W8uy17wl/eEnoea
	fNCoj4q9pjEwAxKnq45sEdDpPrhWc+vgFP4Zc8wpH5b1C4RC0wNQNEse0A88BFAs
	l/2xWxKy6z9RHcpV1FZnbFg9p4+LyMnFlrJPHMfMaPOLB5KYSMD0BbvfHNds1W9k
	CXYcICcm9UXkgpGorCuMa0fWdmORKQ9gUVhpGc/D7NDflpm59O8wdqag0ZoVSfkj
	WRWT9hnmF7Pybg1MsE7jcKnlLfoD8hGUJckcwv+ZblcUV1le2hTujtE6+4UX25PA
	5cFm3nOyft2WTD2BHpDZuWaYl3+fYHz5AQW8J8VG8yzIg/fMw6oPH0e/Y/6oltrg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c175mvbm9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Feb 2026 17:22:52 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 613HJYI3002446;
	Tue, 3 Feb 2026 17:22:51 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c175mvbm5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Feb 2026 17:22:51 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 613F9Hfd029064;
	Tue, 3 Feb 2026 17:22:50 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c1v2sa4h0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Feb 2026 17:22:50 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 613HMkGQ49545670
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 3 Feb 2026 17:22:46 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 90B4C2004B;
	Tue,  3 Feb 2026 17:22:46 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1B67820040;
	Tue,  3 Feb 2026 17:22:45 +0000 (GMT)
Received: from [9.111.139.54] (unknown [9.111.139.54])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  3 Feb 2026 17:22:44 +0000 (GMT)
Message-ID: <afd7d47f-82d8-4b29-aff6-605960f64757@linux.ibm.com>
Date: Tue, 3 Feb 2026 18:22:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/6] x86/vdso: VDSO updates and fixes for sframes
To: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org,
        Steven Rostedt <rostedt@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
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
        David Hildenbrand <david@redhat.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
References: <20260129112726.892340-1-jremus@linux.ibm.com>
 <B1CDD538-668D-48E3-A937-740B7D6575FA@zytor.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <B1CDD538-668D-48E3-A937-740B7D6575FA@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1RNeFjye9XQ2Fwo7nGuZWqe11dNYv12b
X-Authority-Analysis: v=2.4 cv=VcX6/Vp9 c=1 sm=1 tr=0 ts=69822eec cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=VnNF1IyMAAAA:8 a=LFt20mCCc4CE-LtB3JUA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-GUID: KeLrE5dJXpA6vYgjBDeZ4Ic5-NwvD2yo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAzMDEzOSBTYWx0ZWRfXwUo6lcJE1Ffh
 llct2qDpO79y6S40lWcrdflidPGemTRXFUeYRVaUUNInoKRunyTTXgZJb6ijipEeL7FJwOPbYdt
 QzJIH0ve4Z7wZHt4EIWrt4LtOMrAQtTZFt7eJ+vIy+u6tgM2AjAfkt6yKxthLWFXak2wFo1VoS7
 BHHTrMiZuIpQIQZr49B0xcuhGoQCvZJXVhoXutTZrVgKkbjkB1bIqrJzC6SFfP/1I05PZKPJNIU
 V0Faq2BJI1AaC/xMJv9LpH4X1jwofwdDX9uCH2kT8gxzkpyu9lGnKQl77yElTU5+etX+jv9rGK7
 9fwJg0Xh1rV/qctBadRHOiHNAosNqlDGc2mAo+I8lfQKW2Fe667BfTLH/A1qiDZCVNKJGuPNOo+
 gFgub+Kjw5wj2mov/DPK+HcqqkCyiBoV0s4YR756ImCoZm3Vu1L6gZsrkZeSbHa3mlQGOSoZfYR
 sOH5G/cj8YYfTDSjHOg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-03_05,2026-02-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2601150000 definitions=main-2602030139
X-Stat-Signature: any3zz48oi77y17aatr96zn5cj1gfueg
X-Rspamd-Queue-Id: A25DF40012
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770139391-747485
X-HE-Meta: U2FsdGVkX1/19alUnhaaiDOAPPVSf9yx3VIK0Ip3j672aBfbhoBHoTmYDLvBZXxcVweBfccD1oVSVOjT6qSvnpr6Urdelqf5PYBHpYiGUmXN4gXC2yCZFrZ9O46HQ2+Zm4+/t7KcXjfUDNI90iqcT8f3JjnWknFER5+cNslxff7rIE7fQR+I2FUQiKLt/Ro3un0D8Isoc8W4MiJ8+/QPhdkynHhAuSrYYuqfylmPu7nTVdWQE5qzO4MfM8UnhgbCTImIIUITCK2MKu5CPs60tA6Zy9E/qyxPwR1y6EKV41ZL1VpXaCG+aAIsuiDnMmFOZQuZ+ChHC+EvWFZoylYtkqQJMrD9cBhe2H/Ep+BtPG7oXkbVFSB14gmUSxp5hJMa5LCULXzznzJpD9QlbDrAW32gWOJLiJPS81nP7mTizE2fnZ0MPDz12uy6oxYYvEG31IdrGb3imB/ySnryjlQUyqjMJ0DP4acwF3nnNUEgh6G0bgaTG/kqNr2B5nFag0/rJMMR362agXclE+/S12Pi8YDlAGpiw6czuudqnwNWfXBuug1Es4Q+AnxOs12W6IifmMrvqYwkpwAdJPx+Hv6A2WVBBwJSe266yt8HT15T77YQOzOa2nLSFLe7uGWQA5piHYfypABEt5M57wRC5Zxe7HQclpvMflLMZIFUyUa4PR/BGILibcQT9eXDra1/3k2U0yp4ZnI1IthIy3nOUr8zM1iSYDYdKr5GdhejrjWuELzQgp+HDpTYj1cYWXtPqKzhjfkZnlmhy7CQZ0FsWS3gugF/AfeYGlhpUJGqT2GsUiwdDK+MGEZlzLr84Lk1yeVwo9dkiMJGlO0BsgIKrXryni2o8BuPZEvvvONzKXILpg/54l2Biq9QrbGi52XN+qDmLlTpXBJefP+SazfcXKDZyxc8JRJaqfze6hM4iBCRLxHJ7Bug7pvEKmUqC/WrZ9PKIdbR1l7oleFZLwbm6Qc
 /Wmor/fu
 n7aRhY5Oo3P13t6yH2pgTsWBYvMV3c4kt+YJAQjYdGR0uZYgLSBolrNKXCImRgL8keU7D1JppRGuDDO8Tmrayxwj+MVAvl7FpBH8nDvHvnHZbN0dWuJa/dNDqaKQIMKc8K764caZ7iJV5BgnQ7llbvPmgm2iQt7RhzrWrXW2oao5rtcTO0riWiQhHy2AadcTSOKJsfYsDAX1AwiSNDEt2xesxEhMO/aC8Sfs60jiruI0T/74hBbwz8nFT/czHdQQP5j0X5pXaf3MDDp0zWN2nTvfQ+l35eJT+p/6PuMt36JVI0QjprGzwn80rYjI9485Mb8e/VOoIUSroa3skQveKpBKwOJMpFhJZ/jyaf0khlVj1yAFbrB1lOElunimUYfuJAMqyzWNR3qRt6eaoAu1eVvGf8LuI1a6YjmK/5a169PUuW6NicVNbERm+uus+uryu5zdRNLyuKJWc9LOD5PAKDkGg3NOLrzxZj5oRJkte5EhH+ig=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/1/2026 9:23 AM, H. Peter Anvin wrote:
> On January 29, 2026 3:27:20 AM PST, Jens Remus <jremus@linux.ibm.com> wrote:
>> This enables generation of SFrame V3 stack trace information for VDSO on
>> x86-64.  It's a continuation of Josh's and Steve's work:
>>
>>   https://lore.kernel.org/all/cover.1737511963.git.jpoimboe@kernel.org/
>>   https://lore.kernel.org/all/20250422183439.895236512@goodmis.org/
>>
>> This series focuses only on the VDSO code. They are helpful fixes
>> and updates that doesn't rely on sframes (although the last patch
>> is sframe related).
>>
>> This series applies on top of the latest unwind user sframe series
>> "[PATCH v13 00/18] unwind_deferred: Implement sframe handling":
>> https://lore.kernel.org/all/20260127150554.2760964-1-jremus@linux.ibm.com/
>>
>> Like above series it depends on the upcoming binutils 2.46 release to
>> be used to build executables and libraries such as VDSO with SFrame V3
>> stack trace information (using the assembler option --gsframe-3).

>> Josh Poimboeuf (6):
>>  x86/vdso: Fix DWARF generation for getrandom()
>>  x86/asm: Avoid emitting DWARF CFI for non-VDSO
>>  x86/asm: Simplify VDSO DWARF generation
>>  x86/vdso: Use SYM_FUNC_{START,END} in __kernel_vsyscall()
>>  x86/vdso: Use CFI macros in __vdso_sgx_enter_enclave()
>>  x86/vdso: Enable sframe generation in VDSO
>>
>> arch/Kconfig                             |  7 +++
>> arch/x86/entry/vdso/Makefile             | 10 +++--
>> arch/x86/entry/vdso/vdso-layout.lds.S    |  9 +++-
>> arch/x86/entry/vdso/vdso32/system_call.S | 10 +----
>> arch/x86/entry/vdso/vgetrandom-chacha.S  |  3 +-
>> arch/x86/entry/vdso/vsgx.S               | 19 +++------
>> arch/x86/include/asm/dwarf2.h            | 54 +++++++++++++++++-------
>> arch/x86/include/asm/linkage.h           | 33 ++++++++++++---
>> arch/x86/include/asm/vdso.h              |  1 -
>> 9 files changed, 97 insertions(+), 49 deletions(-)
>>
> 
> This patchset clashes *hard* with the changes already in tip:x86/entry.

Thank you for the hint!  I have rebased the series on top of
tip:x86/entry and sent a v7 for review:

[PATCH v7 0/6] x86/vdso: VDSO updates and fixes for sframes
https://lore.kernel.org/all/20260203171958.1522030-1-jremus@linux.ibm.com/

Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


