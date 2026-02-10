Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E72D3EA811B
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 14:36:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 520D46B0088; Tue, 10 Feb 2026 09:36:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D8D56B0089; Tue, 10 Feb 2026 09:36:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 382F96B008A; Tue, 10 Feb 2026 09:36:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 260C96B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 09:36:47 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C7FF81A0546
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 14:36:46 +0000 (UTC)
X-FDA: 84428798412.02.A10B100
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3F954180010
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 14:36:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=NM2LxmOW;
	spf=pass (imf06.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770734204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xv775C+v9f6XgR+p2D0lIDqSm39LsMcZTlhZaKAdvQw=;
	b=o1RrfwyMsOMFNQ5hyk2AS4xb8zV4Mio5b9CC078XGGDapNQBj89zGgfaZbP4EK4I1mvT0a
	ncfJLp8x1IYzfM2l50Mu88PkIFTMIwSKhW/Wum8VXpnLEpKFb0c3p4pC+Isb5JUQnaFDAZ
	JDiIMYn6UU9AJgijAyG6L+3SZ33HV38=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770734204; a=rsa-sha256;
	cv=none;
	b=rNyqMnqy/0eX0eUhGCoLE5JMuw9kL12EzkM8gdnyct9i2LBqyBhrfxruFDnwZtv4P/wtLD
	xxUikBY8ms2y3QL7UNOho5VwGYsLi8yw5BRPkr//tR1gaH6djs+En/AZ6NOdo6gt2uPcLB
	0cyRQdXzAHI3Us+y+ECgHsjC/wnU5NM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=NM2LxmOW;
	spf=pass (imf06.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A96Rnu266057;
	Tue, 10 Feb 2026 14:36:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=xv775C
	+v9f6XgR+p2D0lIDqSm39LsMcZTlhZaKAdvQw=; b=NM2LxmOWiEjAFbLNhICE0P
	HZBRnHh6GBpD30ndfsu3cCteV44nfoAg6DeOGmGMWH9uArQFfk273BHZ6e1ZJN87
	guK0Q3yVecFi4Q1JuEcYnOaPWUz5pczWy9wODSGIKibWf5gnNsSqMmMhJBYuF/S2
	hTOIH21cx8PvZ/UrMnprYrvtdF1hZZBqvYBEZHRUcsEuFyNLp8ER5zS7XYpT70Zt
	kN1TGXi0BukYV6J3Y7wQZM+/srTE5vjJS0rOH5GL1Pk9no7EkIQu5ZBESeeifMSJ
	soUwr3eXVT0ODdrovPlx/7f6VSaKAcEHyM9kbOHi+N1Dz0fWmYDFhVC87RwJuOzw
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696v2g91-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 14:36:20 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61ABMm4S019246;
	Tue, 10 Feb 2026 14:36:19 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6hxk1fwn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 14:36:19 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AEaF6256885560
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 14:36:15 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AC18E20043;
	Tue, 10 Feb 2026 14:36:15 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 21BAD20040;
	Tue, 10 Feb 2026 14:36:15 +0000 (GMT)
Received: from [9.52.200.149] (unknown [9.52.200.149])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 14:36:15 +0000 (GMT)
Message-ID: <cb96d2bf-f2eb-46f7-be7b-8e144eda5d75@linux.ibm.com>
Date: Tue, 10 Feb 2026 15:36:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 6/6] x86/vdso: Enable sframe generation in VDSO
To: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Steven Rostedt <rostedt@kernel.org>,
        Indu Bhagat <indu.bhagat@oracle.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Jose E. Marchesi" <jemarch@gnu.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Weimer <fweimer@redhat.com>, Kees Cook <kees@kernel.org>,
        "Carlos O'Donell" <codonell@redhat.com>, Sam James <sam@gentoo.org>,
        Dylan Hatch <dylanbhatch@google.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
References: <20260206193642.1580787-1-jremus@linux.ibm.com>
 <20260206193642.1580787-7-jremus@linux.ibm.com>
 <4304d18a-f647-4709-9f29-43d9995cc24e@zytor.com>
 <22bc8f74-1943-4ceb-bc6b-ea404ba013d9@linux.ibm.com>
 <b074b10e-6b3e-4c69-a986-6b2eb665e535@zytor.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <b074b10e-6b3e-4c69-a986-6b2eb665e535@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: SFmHdxr9wKQnrtOhu1rvepaBdYcztLgF
X-Proofpoint-ORIG-GUID: uMzqvdgEmena8fMVWt0oSzSFDtD_Sgk3
X-Authority-Analysis: v=2.4 cv=JdWxbEKV c=1 sm=1 tr=0 ts=698b4265 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=CCpqsmhAAAAA:8
 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=bkxOAO0_A-Sbfl51zi0A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=ul9cdbp4aOFLsgKbc677:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEyMCBTYWx0ZWRfX57jBsQYf2w65
 HRQ9vJa/ZJoCGkLqOtkikprfJcivSiqxr/yN5UWg/dOrd/GzSEudSeBmGDj3erlKO5D1MfSrd83
 7C1KWfVwokSjGLwsxSpI0qYjl5qMbPAtIYqVEN/jSnAUQXWwTRoTgnbgN4TU6n3s76ClL2SRXZl
 NPXYnPBDZvMphAyBfRlE/Kdnj2TJWHkWFvSKUysDoDgOtLEE5E5iI5TbhUiT/6iZWgf/yAo3gwz
 oLciIA9bktLvWqca24eaktQJkEX/p3xgie59BjO/h2KnDtaq67OdYCMqJSxXxHrLKNq/UUhqIWr
 C43TxvSMu8EphC9uPaek7m8kjzebNHXJkD77xogmrVmSRiP3ysqWfGztNl9NVBTmBcYlVoURNfK
 LUyMk0Dlc9cGJdvjwDycut64vYLKyLNOvGDgA/BrAeih49oiQYtDAEDDfL9NCqGvfTxCTwz/DKR
 JfrLJvGCnTUeCbNIXhw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 impostorscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602100120
X-Rspamd-Queue-Id: 3F954180010
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: wn418bi75foysh9uk4te3zbe36655i7z
X-HE-Tag: 1770734204-797179
X-HE-Meta: U2FsdGVkX19ZnrqIkbmkHqMsbEhqeT46S71e/+l542W+pgLTPinKMcERK+00XYyp9sY75rXfTkj0QiH73eJsl+QsVjlTvDy3ESHsp5Udhn2HZgjfDoxN+XtjCHtlBvey7MNGBATdnaz84/2787i+YEtM0b1xU4BDgdYwy0whXuqNbBM26lqUK/JD91w+n/3YkQi3PckFif0a7ArVXRd0JM2BOLn4xJMBdGzIjLJQ9JbMlNG/CDWHOhQz88MYJADC7paQ+75RKfvijQqk6jfR+LF66WUDZ7/LeRUEVSBCuILhqNow/95BO0K3Ryhn7YlTN5WZthCU0PoUuB2zOesvPxjJT6k7mjkNmOl6BWijRwmUIHCuzj7+KMZ2R0/yfvqrAPDqK/eRyf7UUsyqxfI9Cnf3vWKVPf7nHj4lBiA/LsDbPXlC6UYIVFQE5t8f8kLLzCjDh3n/EzF8/xKcx4jCNt0SAMwXKbpUSwYhpv03MddcCki5ndzXbeWlGeCQt0H10lKNcKpTnTVrkbB3BtaWX0+Adp4lUTZ7lRpZxSy1apnyIJvZVYZO//8xyGWQEYM65dKfX1+B3LFCuKF7EFZyLzgNwOzXtZ+7OjekzTBQ1z7dqln24t3E6infOpuu1eJTpXxjVI0h3Cw/mcHypjTlfK/X0Fa1SYd91W3FNb/C1Xwu+XvyrN0nQ0/zelFdl2zIqRmqoZ3QFiiGq+6XZlMKc3vO5+ONl1zYEqzZqBZ7yjwGYXRpOYGNOTyU8ZHoCNIbyuaKMk6rhxTj3zvPAM9owbFaZVjjhlHutpdiLDj/unFnItsap1HyuQX0IHt5DIAmhmlxsEonazEstq1lnMU+b7P3e4TbtI+Natx5yUv7hK65uo4l0PTC6kfakOJhfGwJ71Rtmq6NfXDota3C9lP8yU2fGdjlHXSTZigY2CUihcUxsfcMCdFT0NFtgqUsDT4UKENwG1EBVIUsfKDP2Zc
 FwLuKefd
 IAKlAFYjIUHipwLg2nNzN/YSR06X8lXHX9sHzFk53uN8EPTuxnMCwD8c9F2CwmwMqduPXbBFpWLRlkDdzmaz/QMdo3j7P/D9PZWwxgB/bQNAMaTHuMHhvXeGcR3ViXOSsr+cy/jPV7qX+Col4JibQM3/1QmhAqWLQZQfrNvscmYsDT7oASom26EvRRXoeyj73PP3gzh2pE7ZcZ1DiR9/q1ta6ihxPiR16/khk5OsOStVVafSsJrs9lG6BDjR5COqlIqVfA2VzdQ8MOBlTn+M49BB1kQdyOomjLwuvqJeWdYQV9DAQpkqPH3snXMgoKVBz8Wh70Rw54HR8YEUzKWZ1UFlqFyZREmSsyy/sMIaiPy+IpK4YWDNAXhyF7qkUCK3bVQbjFKwQx1TNj0s9XA+TJoJ2mjqmLeuz0s72pJdSd8sBgcbF/+6K114SCmmX8OaLI3Dc0IpO3H1z2ihOGxAsZu1CSLH5uztFmIjIHapST31duM0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/9/2026 8:13 PM, H. Peter Anvin wrote:
> On 2026-02-09 08:45, Jens Remus wrote:
>> On 2/7/2026 12:08 AM, H. Peter Anvin wrote:
>>> On 2026-02-06 11:36, Jens Remus wrote:
>>>> From: Josh Poimboeuf <jpoimboe@kernel.org>
>>>>
>>>> Enable sframe generation in the VDSO library so kernel and user space
>>>> can unwind through it.
>>>>
>>>> SFrame isn't supported for x32 or x86-32.  Discard .sframe sections for
>>>> those VDSOs.
>>>>
>>>> [ Jens Remus: Add support for SFrame V3.  Prevent GNU_SFRAME program
>>>> table entry to empty .sframe section. ]
>>>>
>>>
>>> This will not break the x86-32 build if the assembler encounters .sframe?
>>
>> I cannot follow.  Assembler option --gsframe-3 is only specified in
>> vdso64/Makefile if CONFIG_AS_SFRAME3, which affects the x86-64 and x32
>> VDSOs.  The latter as the x32 VDSO is built from x86-64 objects
>> converted to x86-32 objects using the X32 build step.  Assembler
>> directive ".cfi_sections .sframe" is no longer used in dwarf2.h, which
>> affected the x86-32 VDSO if cross build on x86-64 (so that
>> CONFIG_AS_SFRAME3=y).
>>
>> The reason to discard .sframe in the common VDSO linker script if
>> !KEEP_SFRAME is to remove it from x32 VDSO (built from x86-64 objects
>> having .sframe).  It should also prevent linker errors from linkers that
>> do not support R_X86_64_PC64 in x32 mode, such as the meanwhile fixed
>> GNU linker:
>> https://www.sourceware.org/bugzilla/show_bug.cgi?id=33807
>>
> 
> OK, the linker not handing R_X86_64_PC64 is probably a good enough reason to
> discard .sframe.

For clarification:

Binutils < 2.46 assembler generates SFrame V2, which uses PC32
relocations.
Binutils 2.46+ assembler will generate SFrame V3, which uses PC64
relocations, which the GNU linker will also support for x32.

The intent is to only support SFrame V3 in unwind user sframe and
therefore also only enable .sframe generation in VDSO using SFrame V3.

> The x32 ABI and object format is explicitly intended to be as close to the
> x86-64 as possible; it even uses the same architectural identifier. That's
> pretty much the reason we don't even bother recompiling the objects in the
> first place; the 64-bit objects can simply be downconverted from ELF64 to
> ELF32. This also means that the compiler doesn't need to support x32, although
> objcopy and ld does.
> 
> This also means the DWARF data is the one generated for 64 bits.
> 
> This works because the following is true for all vdso entrypoints:
> 	- No vdso entry point access pointers or explicit "long"s *in memory*.
> 	  (The latter formally violates POSIX for struct timespec, but that
> 	   was a deliberate decision imposed by Linus at the time the x32 API
> 	   was defined: "no 32-bit time_t in a new ABI.")
> 	- No vdso entry point calls system calls that do, either.
> 	- No vdso entry point takes a *signed* long as an argument.
> 	- No vdso entry point calls system calls that differ in behavior
> 	  between x86-64 and x32, making it OK to call the 64-bit system call
> 	  from an x32 process.
> 
> "unsigned long" and pointers *can* be safely passed in argument registers
> (because the architecture will zero-extend those registers), and in addition
> "signed long" *can* be safely passed as returns.
> 
> If ANY of the constraints above were ever violated, OR the binary format would
> start diverging to the point that objcopy can't properly convert it, then we
> would need to start compiling the x32 binaries separately.

Thank you for the detailed explanation!

>> The following works and indeed looks nicer with #if KEEP_SFRAME.  Will
>> wait for further feedback on whether or not to discard .sframe in x32
>> VDSO before sending a v9.
> 
> I think ld tripping over a bug justifies dropping .sframe at this point. *Make
> sure* to document that in the checkin, and add a comment to vdso32.lds.S that
> that is the motivation, so that if x32 gains support for .sframe in the future
> (which should be simple enough, since the formats are so similar) we don't get
> stuck in some kind of cargo cult programming problem.
> 
> It also will avoid issues on the off chance .sframe ends up being defined
> differently for x32 for some reason, perhaps for consistency with other 32-bit
> platforms.
> 
> 
> Include the version of binutils which fixed the problem in your comments.

Ok, will do.

>> diff --git a/arch/x86/entry/vdso/vdso64/vdso64.lds.S b/arch/x86/entry/vdso/vdso64/vdso64.lds.S
>> @@ -8,10 +8,7 @@
>>   */
>>  
>>  #define BUILD_VDSO64
>> -
>> -#ifdef CONFIG_AS_SFRAME
>> -# define KEEP_SFRAME
>> -#endif
>> +#define KEEP_SFRAME	(CONFIG_AS_SFRAME)
> 
> This needs to be IS_ENABLED(CONFIG_AS_SFRAME). Otherwise you get either "y" or
> "CONFIG_AS_SFRAME", neither of which are what you want.

Good catch!  Will fix.

> 
>>  #include "common/vdso-layout.lds.S"
>>  
>> diff --git a/arch/x86/entry/vdso/vdso64/vdsox32.lds.S b/arch/x86/entry/vdso/vdso64/vdsox32.lds.S
>> @@ -8,6 +8,7 @@
>>   */
>>  
>>  #define BUILD_VDSOX32
>> +#define KEEP_SFRAME	false
> 
> Is "false" supported by all appropriate cpp versions? "0" is probably a safer
> choice, and matches the IS_ENABLED() output anyway.

Will do.  I assumed "true" / "false" would be supported, given there are
a few instances:

  $ git grep "#define.*\(false\|true\)" -- arch/x86/

Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


