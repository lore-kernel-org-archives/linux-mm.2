Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC9C5ECD6C7
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 16:16:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DB2B6B00A3; Wed, 11 Feb 2026 11:16:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 586246B00A4; Wed, 11 Feb 2026 11:16:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45D946B00A5; Wed, 11 Feb 2026 11:16:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 361246B00A3
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 11:16:15 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D73A3B97B0
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:16:14 +0000 (UTC)
X-FDA: 84432677868.09.35A36A8
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2D3E1A0008
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:16:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=i+NG86ra;
	spf=pass (imf25.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770826572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=umi07jpeP2Tr6jMEZnWWMP6LArkgwK0Dnoab54QNTbQ=;
	b=vqNytK1hUpNzkGmDIQztOV7css6FKMTwiKjNcMwT2J2/Ok28FGj8DdNWYTRwglZTgwvPkL
	fJFM7ZhlYse8Dv7rsOnyBs9zXbuplVFUNDisQBRydPrMdrHzp20qnZ0P85srKmWNCgo/HU
	n7AJOVRnEtdWYflaMO0QQATQroIQStg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=i+NG86ra;
	spf=pass (imf25.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770826572; a=rsa-sha256;
	cv=none;
	b=Js2jOxSCQdR2sRlUwwEQvVaYDaTQvL92omhk48Ox72+s8EzoSV55c/pxtnrKO1pMMG1Qgb
	M7gpxFyNvl0rR8k6XJYjIv9Wwa07Sm47/E31YSuB7SP/Nrn/jc+l9zDANEu8gF973Gsvn3
	kptW+XUV7Io+QO448KjDORIxzvRbaRY=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61BEnOYm455148;
	Wed, 11 Feb 2026 16:15:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=umi07j
	peP2Tr6jMEZnWWMP6LArkgwK0Dnoab54QNTbQ=; b=i+NG86raRz50IPD6K0xZ1h
	NENwJmYfaqqhgbCXaKX+jJYlxALR7AtD4u2bZzxrRSJsvs7MxIWgPMkFtBjYDZyk
	FW+3a/vlerAcWWsE4hLgQ/4GK54Ti6zIce3ekIGzQzdEPVDpUWdjikyF0hKNBrzt
	XiWDnjZQgzTJT0hdLBgrUDNNsYRh00XAKn45NGL2mKGqYD4Z8XQRM8pI3rhdJYbE
	Ffvbb8JvHjvMvXW2rH24Q2q1a6lOo9oTSL9Vacnfg91Cm+kyA/qRo65e9KXfdqpy
	e7ud9ET/rFn9cS2lKP+vW5l9tKFNyNFVEF6TX1iS6MdZNAy1xshNsijnUrh390lQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696uj3h1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 16:15:47 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61BE6KrV001499;
	Wed, 11 Feb 2026 16:15:45 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6gqn6gqb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 16:15:45 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61BGFf7t52625716
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Feb 2026 16:15:41 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BD14920043;
	Wed, 11 Feb 2026 16:15:41 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2E89D20040;
	Wed, 11 Feb 2026 16:15:41 +0000 (GMT)
Received: from [9.52.200.149] (unknown [9.52.200.149])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 11 Feb 2026 16:15:41 +0000 (GMT)
Message-ID: <29c760a9-7dbf-4fe7-ad78-44c95bc00c4f@linux.ibm.com>
Date: Wed, 11 Feb 2026 17:15:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 00/18] unwind_deferred: Implement sframe handling
To: Dylan Hatch <dylanbhatch@google.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        bpf@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        Steven Rostedt <rostedt@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
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
        Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
References: <20260127150554.2760964-1-jremus@linux.ibm.com>
 <CADBMgpyHw_kgb+Fc+h+Z3ytwMBwDG9B=yai=7g4UWP6AErE77w@mail.gmail.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <CADBMgpyHw_kgb+Fc+h+Z3ytwMBwDG9B=yai=7g4UWP6AErE77w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=KZnfcAYD c=1 sm=1 tr=0 ts=698cab33 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=CCpqsmhAAAAA:8 a=1XWaLZrsAAAA:8 a=VnNF1IyMAAAA:8 a=6YJJy05I97Y9SfkmSYwA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=ul9cdbp4aOFLsgKbc677:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDEyMiBTYWx0ZWRfX/I6pD2K4TFEy
 Ztk8SRCKRSzVUREMPCRJPBuULx1AE9K15Jei1Yw8pkzWe0xVpmAJ7bww5rxSyAL6biaNkaGFSCG
 COP+d5VXrxgD75hp3lbA2s6p3+geiZ3cLHUrCmSUoNxBTRf75XhWbwZ9/U3TLzfQu/vZXkqmyAj
 CKlrNna/pG7N76+vvV9MAgDZdme6jBMnyIxJoulJ9Ox4ahQIdi2/PP9pgnPZ9ZExIU60ZxUBCJ8
 aVcHwwhuu+JnHYkC2337ZQ1PzyiP7spbcoDUiSMPqS7IBSWejA3b4h1MZOIhk+/HeaW0BgAgGx6
 AffB3ACJicsOvCYVjhxPXu4mY6gMyyvMXrYcBcY99Hwvy8nPA21uxMq23Z+fM6ByRTMO3Pt9CrZ
 3/gVJtId9yGdahi5mrd8N2eKe7CBFwW/YBVAySVsH4AdUTxL07YoDuMUrMxCB/4uqBVCztJwiUR
 xTW7BgPeNUarLir2zAQ==
X-Proofpoint-ORIG-GUID: 4l_lO-46vS7Iysb2OZJZw1RAe6BrHG2z
X-Proofpoint-GUID: TFUcd-LP_fOH215WDHCHEKfbKeHlNYfN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-11_02,2026-02-11_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602110122
X-Rspamd-Server: rspam11
X-Stat-Signature: dqdqyfw8rxdenp3hq8s7rzmhnd3od9by
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D3E1A0008
X-HE-Tag: 1770826571-585934
X-HE-Meta: U2FsdGVkX18SdHQr/MqR9m9xnNYm46vxXsL0YjQjZT0+7xhhNZvS/98YfITTWnr32SPbEbm50SPmCsY9IWjJh1ofxXoQ3gA+XizSsYAONuT/Dnm9ulZWbGu0K4ceac3wMvAVOpIhNM5RjrNLSFdpOJ6XyECzJsQN/+ZJI0Fq/9DytQdIbJvjhmUubtHB000agn/5wCJ9gBHD6xKzGZ7zf1f0sy2PyrN3Qz+2tLolstiX7XKHYm8kh7Kl3tMpi8LIgs46xWloqxgmjx/NfSvk6oDQnm8y5DcjMYYF4P/lsbrYPDo9C050u1297guQ8OOxRIncAwAn0/jyupbvS8zwpPlr902wwzWvn6u/42eYTgwImhrOnzRzEA7A8AfrpC37aRvC4AYX8oAy1mahfGirGOOU8MyI6LDd3PH6QCb4SaTIoK4IIIyUhTNa6abrV+7nQEoVmC5uekJIXIIm/7BPATBb+h6kIonbwKaUEzoq1SEbLVZVu1TRu8BAE5ljSmGCHw/5ZaYdr30/Hw6abgHkvlZhS2EXTSrAjNNv8wgH8ZjxpQUq3nrgdfPS+17rBlt6sTKwKGB9857HEAuxRMLG4Cf0l8qdsXEgvdTghL/jN2Uolh1EuMUuNKmRfudta3MwD8CoMUX3WSu8KuIzYpD/cEsFafNECcWmwlMXmWqoFExRJ7g4dZ7mAkVOW8xouG8x8j4TI9fLEiUtZ2HdswyoYeVrjpLYTqolP3DH+xyedMkkuMr9D0MCLqhcqJrv6NoClSDKlf0DI3jbN10sVPChhH9bPeYWVISRb2G5YgtM4EnpWkU1D7RIO8svlfSX3cduKFEfjTyDDQUfcUDqxToOMXlVuAmUmgcD61CD3Ym9QwwXFbAm67R4AOaQrQ2krq+gEakb5xeDTZW81vIpYRTO7AbwRCH8S/Ezhu/8w1rtycSt23uvVhV84ygVSKKtglkyS4b1Vcn20msiHHGp31Q
 J9GnRE9l
 yaOznAyuokf7B45mD1ZWfHBT/E1UWrcB1hYHGCCedNaj2tLGpGwULgb+gEbipDyBFHYApI2svSs5jHwt3UGUKqlGDfJy+tsgoX3ebMWxEsKn9ypnW3greARGNktTWCEutYKmGPMvkRNW1vyz268DIumvh0tMq8Fdh/vIC7CRfzq4wzb12xiLqhx7SvGjpSo/e/xXvV/avouD2mk/32SvwYHP+Gq5H4NlIoslWbVTNBxeyEcKXTXkl9uPIhqIV8492rZNpDygde1A8SydmXhSkA6MC3lPxDksD9cq9+121fh3czPhT+ZJOqHhm1zkL4q0a/S3KBuBlLVTXXdhm7M/exQO7AalaL6v2IWrloMOG8Ff/ZVskrV4zlkp3kFlr2Ima0R5Saw+NAdnFZmnBsGoUNJefv+BlsKJiU7Oob/PpnQtZKH7VlcIg7JC82XPmU/U3hZz9CnXl/+hxZfAM78wft6R2+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/2026 2:47 AM, Dylan Hatch wrote:
> On Tue, Jan 27, 2026 at 7:06 AM Jens Remus <jremus@linux.ibm.com> wrote:
>>
>> This is the implementation of parsing the SFrame V3 stack trace information
>> from an .sframe section in an ELF file.  It's a continuation of Josh's and
>> Steve's work that can be found here:
>>
>>    https://lore.kernel.org/all/cover.1737511963.git.jpoimboe@kernel.org/
>>    https://lore.kernel.org/all/20250827201548.448472904@kernel.org/
>>
>> Currently the only way to get a user space stack trace from a stack
>> walk (and not just copying large amount of user stack into the kernel
>> ring buffer) is to use frame pointers. This has a few issues. The biggest
>> one is that compiling frame pointers into every application and library
>> has been shown to cause performance overhead.
>>
>> Another issue is that the format of the frames may not always be consistent
>> between different compilers and some architectures (s390) has no defined
>> format to do a reliable stack walk. The only way to perform user space
>> profiling on these architectures is to copy the user stack into the kernel
>> buffer.
>>
>> SFrame [1] is now supported in binutils (x86-64, ARM64, and s390). There is
>> discussions going on about supporting SFrame in LLVM. SFrame acts more like
>> ORC, and lives in the ELF executable file as its own section. Like ORC it
>> has two tables where the first table is sorted by instruction pointers (IP)
>> and using the current IP and finding it's entry in the first table, it will
>> take you to the second table which will tell you where the return address
>> of the current function is located and then you can use that address to
>> look it up in the first table to find the return address of that function,
>> and so on. This performs a user space stack walk.
>>
>> Now because the .sframe section lives in the ELF file it needs to be faulted
>> into memory when it is used. This means that walking the user space stack
>> requires being in a faultable context. As profilers like perf request a stack
>> trace in interrupt or NMI context, it cannot do the walking when it is
>> requested. Instead it must be deferred until it is safe to fault in user
>> space. One place this is known to be safe is when the task is about to return
>> back to user space.
>>
>> This series makes the deferred unwind user code implement SFrame format V3
>> and enables it on x86-64.
>>
>> [1]: https://sourceware.org/binutils/wiki/sframe
>>
>>
>> This series applies on top of the tip perf/core branch:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git  perf/core
>>
>> The to be stack-traced user space programs (and libraries) need to be
>> built with the recent SFrame stack trace information format V3, as
>> generated by the upcoming binutils 2.46 with assembler option --gsframe.
>> It can be built from source from the binutils-2_46-branch branch:
>>
>>   git://sourceware.org/git/binutils-gdb.git  binutils-2_46-branch

> Do you by chance have this work uploaded in a public branch somewhere?
> I'd like to get a new version of the SFrame for reliable stacktrace on
> arm64 patch series [1] working for SFrame V3, ideally with the SFrame
> library in your patch series here.
> 
> https://lore.kernel.org/lkml/20250904223850.884188-1-dylanbhatch@google.com/
No, I don't.  Following is how you can easily get to tip:perf/core with
this work applied using b4:

$ git checkout -b sframe v6.18
$ git pull --no-rebase git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf/core # pre-req for [PATCH v13 00/18] unwind_deferred: Implement sframe handling
$ b4 shazam -T 20260127150554.2760964-1-jremus@linux.ibm.com # [PATCH v13 00/18] unwind_deferred: Implement sframe handling

Following is how you can get to a tervolds:master with all of the latest
sframe related series on top using b4:

$ git fetch git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master:sframe
$ git checkout sframe
$ b4 shazam -T 20260127150554.2760964-1-jremus@linux.ibm.com # [PATCH v13 00/18] unwind_deferred: Implement sframe handling
$ git am -3 # resolve "unwind_user/sframe: Store .sframe section data in per-mm maple tree"
$ git am -3 # partially resolve "unwind_user/sframe: Add prctl() interface for registering .sframe sections"
$ git mergetool # manually resolve prctl.h and kernel/sys.c conflicts; bump PR_ADD_SFRAME and PR_REMOVE_SFRAME; each case must end with break;
$ git am --continue
$ b4 shazam -T 20260211141357.271402-1-jremus@linux.ibm.com # optional [PATCH v9 0/6] x86/vdso: VDSO updates and fixes for sframes
$ b4 shazam -T 20260127151926.2805123-1-jremus@linux.ibm.com # optional [PATCH v4 00/12] s390: SFrame user space unwinding
$ git am -3 # partially resolve "s390/vdso: Enable SFrame V3 generation in vDSO"
$ git mergetool # manually resolve arch/s390/kernel/vdso/Makefile conflict
$ git am --continue
$ git am -3 # resolve "s390/ptrace: Convert function macros to inline functions"

Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


