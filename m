Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FB03EB26FC
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 18:50:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10D846B0088; Tue, 10 Feb 2026 13:50:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BB7E6B0089; Tue, 10 Feb 2026 13:50:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFFC26B008A; Tue, 10 Feb 2026 13:50:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E03AD6B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:50:35 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7B2B91A0728
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 18:50:35 +0000 (UTC)
X-FDA: 84429438030.26.491FF0E
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf22.hostedemail.com (Postfix) with ESMTP id 541EDC0011
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 18:50:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026012301 header.b=f1rEPTPi;
	spf=pass (imf22.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770749433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cWf1IsI/pAy5WPRGsYGUniAQCZpzMFbG3rOVk0odWQU=;
	b=cVk/MYZVd63FiCpQQ/TZ0Bw0MXwuXYUWUuJQ3EoKFmI1oEFlr8Z8MPG2cc+OBW+gdKzAtg
	f7LXxLudCA+r151Fabx24i5ktIsJhIyy+JC8FYS+mGQcfzeGo7lbvzjSgg723DEd12OiJt
	RMv3zM4Bpe+phZaEj8u9dtIuvLr1m+Q=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026012301 header.b=f1rEPTPi;
	spf=pass (imf22.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770749433; a=rsa-sha256;
	cv=none;
	b=Q+yW/40iw/0yiBzI2+iHbxWvFgjxH91GiYP1pGTk7WN8+NVaOpWMOtTMK9EgpT77XYZQ0p
	MZQfH3PweAuFJowlbiubxiPAvf6n0rhhOm01FaNU4akeZYLNWcnoyIxks3tyS6TsxTDmoY
	iW+UH/Sx4+EvIYlZuvIMWhAiy9AD+8Y=
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 61AInRsk3481501
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 10 Feb 2026 10:49:27 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 61AInRsk3481501
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026012301; t=1770749375;
	bh=cWf1IsI/pAy5WPRGsYGUniAQCZpzMFbG3rOVk0odWQU=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=f1rEPTPiSKPoUGeoDhdGaBgL5cSJ7VfH+YhsIfIOHrtGQ098Q+FHVrfNXowcbvMeA
	 yDadyDDtFhf9aL/9HGTXiQXE888P9HTS+6oLLYPrAc3TO0QKL//STzW0rAJBEyI1+i
	 O5dl9S4264EbhUb2yJqRo5qGewEGRvR8YXAwQ3WFJAvxTUdIBOS1v8o2EsX9jArBk2
	 C+5BQED2HdZm118lWFa+txDa2ddK0uhsk7rAfITy7T//sBYbF/ZD4f5/FPEoEdQic9
	 zb4h4++3+VOXGUlMVZ/yQ6ARpbbz/r4ge2yLKsqVRRwBEXuRqlMj/U+hmyt/ecLuUg
	 ePICMN/3/wSWg==
Date: Tue, 10 Feb 2026 10:49:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: Jens Remus <jremus@linux.ibm.com>, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Steven Rostedt <rostedt@kernel.org>
CC: Masami Hiramatsu <mhiramat@kernel.org>,
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
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: Re: [PATCH v8 6/6] x86/vdso: Enable sframe generation in VDSO
User-Agent: K-9 Mail for Android
In-Reply-To: <15f2af3b-be33-46fc-b972-6b8e7e0aa52e@linux.ibm.com>
References: <20260206193642.1580787-1-jremus@linux.ibm.com> <20260206193642.1580787-7-jremus@linux.ibm.com> <15f2af3b-be33-46fc-b972-6b8e7e0aa52e@linux.ibm.com>
Message-ID: <8929995D-26A5-4F57-A41D-634CEB3D7C29@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 541EDC0011
X-Stat-Signature: gb3oienftffqqr7ndwm695uczq4ejmij
X-Rspam-User: 
X-HE-Tag: 1770749433-26567
X-HE-Meta: U2FsdGVkX19GZGT8vEKq243U6sCbEmNnWh9KAqx21f7dfgKWmCHB9tg21LuuGEwqIXGT0g7nI0P4zYCpE8duUTiP4HymrZrd25V3D3kgVo/tjstbIXSLvfPsZDeWwpm4/0juGmBnwZyfV7NNDsS4XRFe0UprwKyA3baNvImCeh80poGiM+S2UNFmaKtr4swgHA21VcYvPGr2FigsJNcu9unY0lI2BOsjsXMQWOI8Dl9l6ks84WgC8eDo++tVt5JkVIIN926i5II2gG/oaO31BjFtUShcQzySrgKdNJ6KSpFspovZJu9Q9Lrhm/dBTGZKA1vP0NSkur4PC6whR2BCq2NYZDjPAyCzotzZxlRiZwBbstz0sRbBOsuF/ggAB5NPkbh4R3GY85d5pdFGCWT2GQPGt3kbeVr8jre1wylushbBSeaZe5SfiDM1hNJTep6z1HDo8oQrk/KSK8KAVa4vJyCnkBhln76DYXjZzQqXI2e+3coiiYt8UW9+zwtnnEWyz3IsDeUBwpO5AruGuCx8eRtdbM/mSFj4ylAwsD9uxgdusPa4ts1ogyharh/DuuL9AW8btqNe7YvbjiUyeimARqJMeIEaLwIae38e4xSWcXJ7+X3yLJ760ba9A462Q5Thx+QdqZI8i2bJnKUd747TzrAXtFT6dmjUC++axTFSZunTYt8brFMDeZ7Nb+kt4hbfpDyi+oGBLB8W2yyKrHZ/HOwGod+A08mCvC8g3vxXj7aS38A1W0T7TAWMl7dYO/+YlCQF5zvpYFtbtAww1cN83Xd5bWeenxgQ+vM3XWkH8UHh9gkGr0g110SeiYQL2RrEhJFNPK7/nUTRyrMCjNhcrwgs/wQLXWxjq/P2q6AydtloXOwimvDYrUGpQ6vym1sul9dKKrf9Yj/V8hTIXDxI3voYQ7PjUcxIzcp9re/I3j5WfY8Bl7OSK989N2H+Eua+FERYaG6G4+wCgJzpJ2M
 +mqUZG1J
 Rv+wF5YZMmSDiosOO4RfK74LZjfPghB5IVpc15aXjcYOSQEw6f7rADY4eqfT5ZsHN082kfN8W+R2VDwG4190aa+O9MWfMes61qvxbLaAogF6KIy0ezzI6n10eiuM/hv+PgL6ZJ1dLsR03i2dg0Vstxc192FEKF04rBDggf5Z/p3UCQuy7ubGbaD55l+HkDLzCkbMgA6qyrSZXqQfZrG7oGpqjZKUT95OHlx1pr6Bxsp8yaQgOkUgpltolfpLtRgWmOSsReB2+BIWyjo0ji9U9Dz04ll7q7i6qhJOofaGfZSr0/Ky8mLV+e9hA+dos5RAksWAQDH9pUKUkxJsE/hKGpAP8LOnhYknNQen9DxIkJLYAHhjskbKONPlWisQVGMA0xhxG4AXX4DNYlxQ6qUl2RCQXMQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On February 10, 2026 8:46:33 AM PST, Jens Remus <jremus@linux=2Eibm=2Ecom> =
wrote:
>On 2/6/2026 8:36 PM, Jens Remus wrote:
>> From: Josh Poimboeuf <jpoimboe@kernel=2Eorg>
>>=20
>> Enable sframe generation in the VDSO library so kernel and user space
>> can unwind through it=2E
>>=20
>> SFrame isn't supported for x32 or x86-32=2E  Discard =2Esframe sections=
 for
>> those VDSOs=2E
>>=20
>> [ Jens Remus: Add support for SFrame V3=2E  Prevent GNU_SFRAME program
>> table entry to empty =2Esframe section=2E ]
>>=20
>> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel=2Eorg>
>> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis=2Eorg>
>> Signed-off-by: Jens Remus <jremus@linux=2Eibm=2Ecom>
>
>> diff --git a/arch/Kconfig b/arch/Kconfig
>
>> @@ -479,6 +479,13 @@ config HAVE_HARDLOCKUP_DETECTOR_ARCH
>>  	  It uses the same command line parameters, and sysctl interface,
>>  	  as the generic hardlockup detectors=2E
>> =20
>> +config AS_SFRAME
>> +	bool
>> +
>> +config AS_SFRAME3
>> +	def_bool $(as-instr,=2Ecfi_startproc\n=2Ecfi_endproc,-Wa$(comma)--gsf=
rame-3)
>
>Above tests whether the assembler supports --gsframe-3 to generate
>=2Esframe in SFrame V3 format=2E  GNU assembler only supports to generate
>SFrame for x86-64=2E  If the assembler is built for i386 (x86-32) the tes=
t
>will fail unless option --64 is specified=2E  I wonder whether that could
>happen in (the rather hypothetical?) case, when the kernel is cross built
>for x86-64 on i386?  Should this therefore be changed to the following?
>
>config AS_SFRAME_64
>	def_bool $(as-instr,=2Ecfi_startproc\n=2Ecfi_endproc,$(m64-flag) -Wa$(co=
mma)--gsframe)
>
>An alternative would be to enable as-instr64 to accept an optional flag
>operand, similar to as-instr, and use as-instr64 instead of as-instr=2E
>
>Or is this not required, as in a cross build for 64-bit on a 32-bit
>platform (or inverse) a respective cross toolchain is a prerequisite and
>the m64-flag (or m32-flag) is not used?
>
>I tried to simulate this using docker and an i386 image and then using
>the i386 tool in the container to switch "uname -m" to "i686"=2E  But bot=
h
>of my following attempts to build for x86-64 on i386 fail with fixdep
>not found:
>
>$ docker run -it --rm -v "$HOME/linux:$HOME/linux" --platform i386 public=
=2Eecr=2Eaws/docker/library/debian:13=2E3
># sed -i -s 's/^Types: deb/& deb-src/' /etc/apt/sources=2Elist=2Ed/debian=
=2Esources
># apt update
># apt -y build-dep linux
>
># make mrproper
># i386 make ARCH=3Dx86_64 defconfig
># i386 make ARCH=3Dx86_64 arch/x86/entry/vdso/
>
># make mrproper
># apt -y install gcc-x86-64-linux-gnu
># i386 make ARCH=3Dx86_64 CROSS_COMPILE=3Dx86_64-linux-gnu- defconfig
># i386 make ARCH=3Dx86_64 CROSS_COMPILE=3Dx86_64-linux-gnu- arch/x86/entr=
y/vdso/
>
>> +	select AS_SFRAME
>> +
>>  config UNWIND_USER
>>  	bool
>
>> diff --git a/arch/x86/entry/vdso/vdso64/Makefile b/arch/x86/entry/vdso/=
vdso64/Makefile
>
>> @@ -14,6 +14,7 @@ vobjs-$(CONFIG_X86_SGX)		+=3D vsgx=2Eo
>> =20
>>  # Compilation flags
>>  flags-y				:=3D -DBUILD_VDSO64 -m64 -mcmodel=3Dsmall
>> +flags-$(CONFIG_AS_SFRAME3)	+=3D -Wa,--gsframe-3
>
>flags-$(CONFIG_AS_SFRAME3_64)	+=3D -Wa,--gsframe-3
>
>> =20
>>  # The location of this include matters!
>>  include $(src)/=2E=2E/common/Makefile=2Einclude
>Thanks and regards,
>Jens

I think we can worry about that later=2E

