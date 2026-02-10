Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D22FDEB26E0
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 16:47:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 425E06B008C; Tue, 10 Feb 2026 11:47:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D96F6B0096; Tue, 10 Feb 2026 11:47:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CE476B0098; Tue, 10 Feb 2026 11:47:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1EA7B6B008C
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 11:47:14 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B78D81B23B7
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:47:13 +0000 (UTC)
X-FDA: 84429127146.30.2BA7EBC
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3A8F41C0004
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:47:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="kysmhW/u";
	spf=pass (imf20.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770742031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hWIG4kTyswI9jcJ/eF4E6+Aw6IleHIzONJBK1RVFQNA=;
	b=rkdRY6ObMKXv2Qb3cfdr8floQJM8AUIOrJgCOxKPQd7ohr5b/4ugXpU5hWEjKnOvyaaa1G
	5t7+4jpFAGeAjmZmD39JyIYPHe9anW83qsiZihyZWXBZyn773AQHkyfAS8spxsSefXz/r5
	5NdLK0Mb3vYu+J1QrhpNH2x2VGE757o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="kysmhW/u";
	spf=pass (imf20.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770742031; a=rsa-sha256;
	cv=none;
	b=XZyuSGRYu0R9LtuDxYSh6h6a5SaxtuwNOIrL8RXoRzxmzELzJYyzQjfhXrq0//+QFzZOpl
	Qbn3brx5qQcoAZ7gTPmM7/sp5PTdMCSQTRqpj5SapNkOWHJv46Jo9YVF07zL9BxW2XtkVp
	qvGqTDkiGH+T2impY9XX4+13adU+NKA=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A3aBC93408670;
	Tue, 10 Feb 2026 16:46:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=hWIG4k
	TyswI9jcJ/eF4E6+Aw6IleHIzONJBK1RVFQNA=; b=kysmhW/utq4d6wdVlZnUaF
	r/IRwiaChYl1wuGU3Uh8Wxo+msm6lJsXuxQfn7GsTpZJ9C62AKdIOQqgHrl9xwYS
	5BVJVGZ7LaQ19aQmhYkyPDunPolrBVTrc013Jh/HAe0kJ0+3ber0+89Z7VbNQttU
	zexHliC+wz/QSQA41kHSt9zwK/cxvSxQwZJS0AAmOKUy+N/RgTpKLOFaz4V01UzI
	sXvP6h5MpJEiZCZR0D0O3diDeHCVU/RH79T5Cg/vQJejaYG3H9m/DJ7XsLmXOLx6
	abDnwzd6xLbC2+zEzw6ZceagIEemby/9fcebel9/Sh8VrRya9Lx1fdezqUoNJ4ww
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696uu4qr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 16:46:40 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61AEbFxq001499;
	Tue, 10 Feb 2026 16:46:39 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6gqn27jx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 16:46:39 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AGkZf230605964
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 16:46:35 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EBBD620040;
	Tue, 10 Feb 2026 16:46:34 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6E7C020043;
	Tue, 10 Feb 2026 16:46:34 +0000 (GMT)
Received: from [9.52.200.149] (unknown [9.52.200.149])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 16:46:34 +0000 (GMT)
Message-ID: <15f2af3b-be33-46fc-b972-6b8e7e0aa52e@linux.ibm.com>
Date: Tue, 10 Feb 2026 17:46:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 6/6] x86/vdso: Enable sframe generation in VDSO
To: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Steven Rostedt <rostedt@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
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
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20260206193642.1580787-7-jremus@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEzNiBTYWx0ZWRfXx0hBg5sfg+Sm
 RCuatqOyNDSemteUA5F+r4Ge2cM0/zQOT5n/ZqVCnhyWG/QDD8i2JZhH1g/2iNZAlUWMjFcAQVv
 pLQReX4/gIcOywzLhe9vqmurQ5b392gkE0KkGwkYXtgA5vQqorSZO05XXfmGA7F3cHoV7IuOb0W
 SVobFFKAR0XUxdXlnR4vIoqeLG8O3jVoiY7hQ6NzvemQWA+EtgEVvD5AlP3e/vVG9Qaa3drVQy9
 /sgxePwtuEN1f8WRa82RYtNS9SVWFZlrfXcicv/IhhD80u3BXV48SQ2VkPvaBjKDUA9TbF4+KFb
 tMseD+WNlwQAAB+vVNDVm8wRqwnIolO5Etlys3u7FIrx9imuqvSssMtnTBNkfnBTmdc43e0kyV8
 9aIDMBhrzcmT5khDY9al2AMmIMlQjsBL1iF949YpEinx01JHeY8jM/0sXyRV+4rbE/yYRPRyR05
 564StLrk5fLK2GaTHmw==
X-Proofpoint-ORIG-GUID: lFUhbotL6mZHHQBIGQHNWFr4iFqXQvoQ
X-Proofpoint-GUID: yXXBPSDw6CtLkz2VIBzGSNLoMPEAqhQX
X-Authority-Analysis: v=2.4 cv=O+Y0fR9W c=1 sm=1 tr=0 ts=698b60f1 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=1YTvd-3GSpCLN8fQQIoA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 adultscore=0
 malwarescore=0 impostorscore=0 bulkscore=0 clxscore=1015 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602100136
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3A8F41C0004
X-Stat-Signature: mqh7mstb56cz7c44x43ua6ta1fqaddac
X-Rspam-User: 
X-HE-Tag: 1770742031-338046
X-HE-Meta: U2FsdGVkX1/Z6JSffBOR6pyH8HOerIUiTqfkKiGVzk5+MEdLmH7TlPs9IrtoZm0MJgi00kDFJ0Z4S+zccLQgbxaBUx67kvj99OJR2I+OrJs8uDQTSXFbEefDK/Bph/qCkCo/0Bq0wst5Y+KJoP+KihZ9S9opB940cLTt8m1iCRG7WGI5uNo7LDphUOiSVqc8g0xJmN0QL4gwRh+va/f+Oqc0uBevBaYiQ14GyZQ5qImqvND/3F6j8RYrsQGiLmqNvobbv8zhnSnvlNG95UpVLHyrunrXQo2XcOOHjuioQ09YMl6ylfBFj0EvsqbL6Q+0JFZx2NDRXBVsi0eNRKAh6eOAJcsXuIvNotoLGxyPFCYcyTFImRyqfJYJ8ta6ytJHD1pZlxUEsuZDRvG3oVIxXgIsJalo5AZdho009ZuB+9aQD0G1pcn0VWm9DwwZAix1qFaYHoRTk4X3E9IPfSoCEYPAYWCZfsZ8iMj60kPXj0hj0cjBbCQN4G52R4TmB00Y+q22m4f+nvW8GYDd22efJZIYTNHfC0oYNwmUhnQgsaLHbvxLARPVE/7ZapYH3wqsQPFt4NmAuNY27k0Q2/DkaaGr+ESsi5GdZQftAmgnb8Nsxth3RcWGPXx0Q0Bt8HuVCv+Pi7WUdFb2TwxLx5koJedI1RN8786m5BM0KsAlsFc0918QmjWrpwy6LM8twC8Y/j5N+YrwmoWs5418oVEQrLsuKSIVJxhN0F3mRgEHF7SBkgFdLvr8Em5CbRYfXZoGSIEf0TwIMH/Xqlb65C8mAII6KHXbXqIsEgPriAEu5mqlWe0Tvtvl6Sqba6WdaJh27nNSz4M1jy7OYmAmaHB7s2QBuW8BHO328CEJG/RzeGlJWIH0K6W4IalwDIKAGwQW71H/SnjpfMdzM/NRlQquHhH94uWNXlEP8psM4eNG6H7z2cbJ5ZxS3vJTIVsU5tg1rDckx9V7/VnGW5BzAWo
 VAvRTmxe
 K7ywG4OJQl684Cmy4qVvlLjWBmXeOBszXlWq+AEU0QT+MZ7LleOrvGh4sc2jHifPtqcFfGnzdfibYHCjC25Gfj8CAH4+61NqNvU5yzSFgwieVsXAtZEegPcVStMqR+Ck6b72yu8GVG6AUo2GVVlAoRi0udjHHW+TgIIPXfLuHK8XnN56FHb9UdWavVgYuqeBxXrLmWcjsR2dvO9xoCULdyx9zztzhKa8/je+/UwzMpXz1k0w6pf1wO8mG3pNCZpP66RnTxrbRnn5R4V9F2qOwM1KkCAogWu9ttL+uYN1A+N/TJwXxVr32eC/F+jf53adROzrY22uWG+frDZgqLoQYKpCGNSadIj5VgCpXZIZ4RtZqHUrT40wd+ic107jlNSLn47/KbMqyWiTdHCs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/6/2026 8:36 PM, Jens Remus wrote:
> From: Josh Poimboeuf <jpoimboe@kernel.org>
> 
> Enable sframe generation in the VDSO library so kernel and user space
> can unwind through it.
> 
> SFrame isn't supported for x32 or x86-32.  Discard .sframe sections for
> those VDSOs.
> 
> [ Jens Remus: Add support for SFrame V3.  Prevent GNU_SFRAME program
> table entry to empty .sframe section. ]
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> Signed-off-by: Jens Remus <jremus@linux.ibm.com>

> diff --git a/arch/Kconfig b/arch/Kconfig

> @@ -479,6 +479,13 @@ config HAVE_HARDLOCKUP_DETECTOR_ARCH
>  	  It uses the same command line parameters, and sysctl interface,
>  	  as the generic hardlockup detectors.
>  
> +config AS_SFRAME
> +	bool
> +
> +config AS_SFRAME3
> +	def_bool $(as-instr,.cfi_startproc\n.cfi_endproc,-Wa$(comma)--gsframe-3)

Above tests whether the assembler supports --gsframe-3 to generate
.sframe in SFrame V3 format.  GNU assembler only supports to generate
SFrame for x86-64.  If the assembler is built for i386 (x86-32) the test
will fail unless option --64 is specified.  I wonder whether that could
happen in (the rather hypothetical?) case, when the kernel is cross built
for x86-64 on i386?  Should this therefore be changed to the following?

config AS_SFRAME_64
	def_bool $(as-instr,.cfi_startproc\n.cfi_endproc,$(m64-flag) -Wa$(comma)--gsframe)

An alternative would be to enable as-instr64 to accept an optional flag
operand, similar to as-instr, and use as-instr64 instead of as-instr.

Or is this not required, as in a cross build for 64-bit on a 32-bit
platform (or inverse) a respective cross toolchain is a prerequisite and
the m64-flag (or m32-flag) is not used?

I tried to simulate this using docker and an i386 image and then using
the i386 tool in the container to switch "uname -m" to "i686".  But both
of my following attempts to build for x86-64 on i386 fail with fixdep
not found:

$ docker run -it --rm -v "$HOME/linux:$HOME/linux" --platform i386 public.ecr.aws/docker/library/debian:13.3
# sed -i -s 's/^Types: deb/& deb-src/' /etc/apt/sources.list.d/debian.sources
# apt update
# apt -y build-dep linux

# make mrproper
# i386 make ARCH=x86_64 defconfig
# i386 make ARCH=x86_64 arch/x86/entry/vdso/

# make mrproper
# apt -y install gcc-x86-64-linux-gnu
# i386 make ARCH=x86_64 CROSS_COMPILE=x86_64-linux-gnu- defconfig
# i386 make ARCH=x86_64 CROSS_COMPILE=x86_64-linux-gnu- arch/x86/entry/vdso/

> +	select AS_SFRAME
> +
>  config UNWIND_USER
>  	bool

> diff --git a/arch/x86/entry/vdso/vdso64/Makefile b/arch/x86/entry/vdso/vdso64/Makefile

> @@ -14,6 +14,7 @@ vobjs-$(CONFIG_X86_SGX)		+= vsgx.o
>  
>  # Compilation flags
>  flags-y				:= -DBUILD_VDSO64 -m64 -mcmodel=small
> +flags-$(CONFIG_AS_SFRAME3)	+= -Wa,--gsframe-3

flags-$(CONFIG_AS_SFRAME3_64)	+= -Wa,--gsframe-3

>  
>  # The location of this include matters!
>  include $(src)/../common/Makefile.include
Thanks and regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


