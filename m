Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8756E7C70D
	for <linux-mm@archiver.kernel.org>; Sun,  1 Feb 2026 08:24:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD8C36B0005; Sun,  1 Feb 2026 03:24:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBA1E6B0089; Sun,  1 Feb 2026 03:24:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBBB56B008A; Sun,  1 Feb 2026 03:24:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ABDA26B0005
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 03:24:48 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 63D3013BD33
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 08:24:48 +0000 (UTC)
X-FDA: 84395201856.18.C01D3D4
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0A26B140006
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 08:24:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026012301 header.b="YQXB7/oy";
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf26.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769934286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=plHDA7QLJmcfQszbJlbjOYhF5Sm//GhH9ob/Ho1ZwUY=;
	b=tnA9zjwA3TEy8F+feYgVVDzlwNfmXrtwKYugfoDhSfRfnFwgvo2HvSwxPpoqgWsiWhKcLg
	E93ussSrS5zSUFKG2toa6GbQ2uREPzU73FY80iXyY/Erx3u1Fc1jBAuuuJFGogWBMX27k8
	WpRvCPJJX8F5N6F/6HmAMfWUh/7Kj5Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769934286; a=rsa-sha256;
	cv=none;
	b=25Up6t10nhwbwaRwxyhzTwIVU7pnfLBqBFvzgWJLrec92q3jMBdVjiiHI64aANO/G3F2ed
	3+cL4//apZ0X53pnwE8qOJRz0yMLmarMlse3z+nFPrDSbM2rKvCOug+hOxkqWd3o5Pe0wi
	y/D4zMmXOJryeRqERPuGiOXSDf8XSLU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026012301 header.b="YQXB7/oy";
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf26.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 6118NbHC2133728
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Sun, 1 Feb 2026 00:23:38 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 6118NbHC2133728
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026012301; t=1769934220;
	bh=plHDA7QLJmcfQszbJlbjOYhF5Sm//GhH9ob/Ho1ZwUY=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=YQXB7/oyziryyUrNtDf7kszFAnpmhF2NepxI+HHDQQrNJY7A5Yrs4EMHSsmkVFvq6
	 aUIbc52ZQjR/w5wSn7qpzj9962PvRGwfJ4wiKNsFhNpW2JFaUec0J1aCov8M6Q66wT
	 My2BtDMHUmvOITSNHlPFrTjo5elNnPW2gwaHTyjqQ7w0tbrtISg+wEJPQxzkU/7EtO
	 zoNFGnnpkYrzfM1wXCWRgeEh0v3Dc12ex5+thla7gIThvOSl5XbWjTcvlvn+lxJG+1
	 Re9XH6nub6A4SpAo98WVg8ZiY2ENY+b6Bn8xkkXZK+SNM2iPLx+6YNQNqyXs/qmK2r
	 edncvRF7Vno6Q==
Date: Sun, 01 Feb 2026 00:23:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: Jens Remus <jremus@linux.ibm.com>, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org,
        Steven Rostedt <rostedt@kernel.org>
CC: Josh Poimboeuf <jpoimboe@kernel.org>,
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
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH v6 0/6] x86/vdso: VDSO updates and fixes for sframes
User-Agent: K-9 Mail for Android
In-Reply-To: <20260129112726.892340-1-jremus@linux.ibm.com>
References: <20260129112726.892340-1-jremus@linux.ibm.com>
Message-ID: <B1CDD538-668D-48E3-A937-740B7D6575FA@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0A26B140006
X-Stat-Signature: 5fsqkxiupzn6s85swfoad7ioaafqzh7k
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769934285-606273
X-HE-Meta: U2FsdGVkX1+uA+hYzFsvP2Ce7/DxvFflhN7MqzhgNBrufZ/Ek4GRxd37QlRbDT0Zx+ShBdQ1E5KxKS0pexVVQ63oEn7nEiKoUtxRmGLMO9WsDUPe7twNkLYpveNlPI+mLoKW6ZDscRYYulxUnzlS3PDDR7RlunXNUQ/q2yM9WyWvMpV22WA1GAo9w/McKFV6YOBRpPDYabvSqWhVJ0HWfJIIjcWMuMvmQNTHw09US+druGHH/XvppOFnqpNhVYYA1DCqLYwsqBcT4Rz6Xoi1pjg7weSAAJPtaDJZTyjEcNgbChFGPQ5ULPpnhFPnj7tU/A7YRMUe8JPz/VBhQ7ULsq5yJ97/x4p5YLe+rm0xcttXnT8MuH/rxUYWwBW48azSvlWANQ+XAAsYi7cEPVW048ZSrNcpYIPiRTUP10aM7ZFlr6djntyUSnmSZ8aWHdRm/17rt+OcvNzJYEBnKIxUw6zC2vk0mhF2lkUMelZYekzgww06vTeqsgBRMChLhGfb/unewFaJkgqwccVoYrXM/vb7DYXIor/7RbmmAmFigtciiiRito2Wwx/qg4l845hoa3wnYmPgjBBIon1aWP+2/kRL8WHtmZTQjtPPzgO6ZX/aOchCABGvG8A3/IIGH4oCyZiD5g1hakOcTXpXHTCNfZ/h7ZiLjqTh8sX/okQxgMZfKNWVmeSUaaifIVNQfsvrw4kxktbQqcZPnB7B+SXJu1fhxbnFzKFaMM+VBZjrS59GjA8C+QebJiA2VIrJGrls/znLjKBNltIqLee+jgE/WQrpPX3J7kuf6mMz1bYxa6ySq8ZoRsxj6/Ea7drikTfHQdYR4WEkUhAEfw3A8CRQHdHnAqdyb9mOnB4oHRxt3zYhHwzmxLuJojrUlukb4StNbcrV2xIwsOpm869UDXM9o5rj7Mq2DJ7wjZ6AtfvF0o3OcK7Yc90QY2SsypDaegszVg7QD3S7VNeqEr7rOqJ
 l8JAAN2n
 E+pkgTfBo4AByhiuYGb0+NvyiHOCFmciibG0k/lMeQ/qUU0CtHoOxMAoMI4X1ELW3MaKHzDNUgg/xWv/43uITL+dQxMYjhEZH16HLa14lgUObzp+Vn6/mZE7yFmJ569pKd0JxXMZ7WrWlQpsrrytKVE/pUeXaWSvW8tpk2B9P47DTgYwe6VIEOjE3HX+EOgDcd8gtjoeE0lHXUFLTppzDxQUSGGjcDbtZKZGDXaYNKt+xDDvDV40W/GuZ9JGr/EkxvMpNZiuEqQtKLqP8FsDeeEke/9MhDAKHN0LVUjXL1YplkwT5Pyl5O9w/CWnMcwVT2/Tbym95lMFYyuqVUugY5Tf6NXB0QNvk04obmPmrQyVbe1YOmSJduNTo3jXTUBzWNwPyBOaFZeY5Nw5jb2uL26ts/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On January 29, 2026 3:27:20 AM PST, Jens Remus <jremus@linux=2Eibm=2Ecom> w=
rote:
>This enables generation of SFrame V3 stack trace information for VDSO on
>x86-64=2E  It's a continuation of Josh's and Steve's work:
>
>   https://lore=2Ekernel=2Eorg/all/cover=2E1737511963=2Egit=2Ejpoimboe@ke=
rnel=2Eorg/
>   https://lore=2Ekernel=2Eorg/all/20250422183439=2E895236512@goodmis=2Eo=
rg/
>
>This series focuses only on the VDSO code=2E They are helpful fixes
>and updates that doesn't rely on sframes (although the last patch
>is sframe related)=2E
>
>This series applies on top of the latest unwind user sframe series
>"[PATCH v13 00/18] unwind_deferred: Implement sframe handling":
>https://lore=2Ekernel=2Eorg/all/20260127150554=2E2760964-1-jremus@linux=
=2Eibm=2Ecom/
>
>Like above series it depends on the upcoming binutils 2=2E46 release to
>be used to build executables and libraries such as VDSO with SFrame V3
>stack trace information (using the assembler option --gsframe-3)=2E
>
>Changes in v6:
>- SFrame V3 support (SFrame V2 is not supported)=2E
>- Prevent GNU_SFRAME program table entry to empty =2Esframe section=2E
>- Integrate v5 review feedback=2E (Josh)
>
>Regards,
>Jens
>
>
>Josh Poimboeuf (6):
>  x86/vdso: Fix DWARF generation for getrandom()
>  x86/asm: Avoid emitting DWARF CFI for non-VDSO
>  x86/asm: Simplify VDSO DWARF generation
>  x86/vdso: Use SYM_FUNC_{START,END} in __kernel_vsyscall()
>  x86/vdso: Use CFI macros in __vdso_sgx_enter_enclave()
>  x86/vdso: Enable sframe generation in VDSO
>
> arch/Kconfig                             |  7 +++
> arch/x86/entry/vdso/Makefile             | 10 +++--
> arch/x86/entry/vdso/vdso-layout=2Elds=2ES    |  9 +++-
> arch/x86/entry/vdso/vdso32/system_call=2ES | 10 +----
> arch/x86/entry/vdso/vgetrandom-chacha=2ES  |  3 +-
> arch/x86/entry/vdso/vsgx=2ES               | 19 +++------
> arch/x86/include/asm/dwarf2=2Eh            | 54 +++++++++++++++++-------
> arch/x86/include/asm/linkage=2Eh           | 33 ++++++++++++---
> arch/x86/include/asm/vdso=2Eh              |  1 -
> 9 files changed, 97 insertions(+), 49 deletions(-)
>

This patchset clashes *hard* with the changes already in tip:x86/entry=2E

