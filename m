Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF911D44C5E
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 15:01:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F29B26B00A7; Thu, 15 Jan 2026 10:01:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED3476B00A8; Thu, 15 Jan 2026 10:01:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD5CF6B00A9; Thu, 15 Jan 2026 10:01:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C5A946B00A7
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:01:46 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6BB7B1A03A5
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:01:46 +0000 (UTC)
X-FDA: 84334512612.20.BCFA960
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf05.hostedemail.com (Postfix) with ESMTP id A66E010000A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:01:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025122301 header.b=Wd0An2uE;
	spf=pass (imf05.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 60FF0mj21228665
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Thu, 15 Jan 2026 07:00:49 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 60FF0mj21228665
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025122301; t=1768489250;
	bh=2u/6Gcg0spQu7Eg2+x4lk/M911ruLsvvbi547qevkLM=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=Wd0An2uE1zBF11eDkgfbXqQzZOT3Wz+ByZaZhqbhcKQZCU6c5ktpFfcXQjXUtmfsp
	 lEqujsbi49j3bIivcBo9Go5SHnerumkhStHfWo8PPiNYsA9WxVvgUw7PLH9pHghAqq
	 DrTyyaLf0l2MfzvgVFIs2ycGeOyrxRmUjqdQs8FtfwzV9JTGJYUkoGa0+fvDxXAdPK
	 4tJgCCxjO596YsMAILQQXi/l5htqcXKsL0SwEyS2dCl0P+6E1lLkAuZy8OBNmjWSbI
	 wHwEdTUgBTOFAmiw5UufMeRqBED0SGnWzcq4c7vEuQD2mxeUU0RUkgTOWE3KdiVSbF
	 r0Ebkmjb6eDDA==
Date: Thu, 15 Jan 2026 07:00:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: Thorsten Leemhuis <linux@leemhuis.info>
CC: "Peter Zijlstra (Intel)" <peterz@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-sgx@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v4=2E1_00/10=5D_x86/entry/vdso=3A?=
 =?US-ASCII?Q?_clean_up_the_vdso_build=2C_vdso_updates?=
User-Agent: K-9 Mail for Android
In-Reply-To: <16ea64d1-2a9b-46f9-9fcc-42958f599eb6@leemhuis.info>
References: <vdso-cleanup-patch-4.1@zytor.com> <16ea64d1-2a9b-46f9-9fcc-42958f599eb6@leemhuis.info>
Message-ID: <619B5E67-A6B4-4043-896D-5E4CF20EF955@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A66E010000A
X-Stat-Signature: fuxy9oxhensstf693wpfzac1s9mhecgw
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768489296-555064
X-HE-Meta: U2FsdGVkX1/rdA4na5WDPDrRMDSnusAaGFFiutpk2N1AHS62xaKCc7pzoieTrkZsJJEdChekAiuNqem0Ij0kKkmDRTYtdDuTNtGnif5+RBxb+QsL5/nBJ5FCDnLcqvdrqawfYdbAm3w2glVTobW0xdmiKcJcQV35f4jXjt6JMX8IdOkfOqxyI21nixkCi5Nn75fZ6OlLHNvKOtui7uLrJN911+6qchhF6ofS9eQxYe9+uXLcb+HIUKT8OlBYcKbwWFCIox7X1cX1M/l6zVaQfYtl6oWPzCAGqaKukicSWoTZ4L3OlR4thg13O9Ts41DUMjoSVCGAnOK7B2vLbAgmfNPv/dJdjNX0xz+JnQXlvtw4b/JPbJjtxHwyHM1XlOOEVPHWcVRCq5NjoEPwU5Jqm691sfrtEl3lj8KC5sbshn5byrTuLfvZkpX0XHoAPw8uUJvrGcnT6UfURCl9MmGmQGuuxRiUuTYYQzihqBu3Due9vFhv1nB7ryZ1oHPmzEEB7jGugyPIJeVbMZLbOdssa1RcQdNfOMGeyRtADQWZ/gOQkEVZ5ClukXmTAxaFU6/7g0p8Ve+V9ASqXGShOaiLuZ/aVYP/mgnx57pmKwhIDAHzbqQibk2+gzEQVFoVBFqb0UZt6rp7W7+INItJzIbSqLtz6inuYvn02JJbwRs92LgNwHuK4/y9eEewMufS2r2HDEXkSe6qo3qHc5b64cZ2rFKbRv0cx3rfdqgtNQ73KxKHFkYy42j5YV/EuBLkDGYROfU6TNl/ZepLWRhvbTd5mwRYNZ3eoaX7Xzc+5HTcNzZKMxcMb3reIYRL/0ueC2329xHbkdVsweFbaLWnOTeREvLpSteDECrEHLQ8yHGz/rZG7Rt6L+8EjHWZLa0xXLNSFMEHA3WA/Mr8qp2FWey6h8r0H0CvjNLlpFK4h7CdLRrGSpkqQJ6dZPluvtwVBBYxrYZp2qyC1z5ase7Ituh
 uzvAWf+X
 rE56CMo0mTk5adOGJnpr2kV+gOMeyKs9YzXYhnkLGa9lXMq/tWZUUm1RmD0CRsQAFu+xu9zhk0t1YnvooHGcOO4PILpM1HPhDepG3UFgecnUiPA2URaTnvtFvbgLFsltjpvSCPTRZuFb69yOHgyAgepNTNK1EtPeGVrhqPtsBOg0Kjk3x6dgxKTTAw4fg0Xvm0F2IXwIJfEGGfV9zyK7mQK/Wg/XdSzBKZTvPhclF1GHqxCEDBtygUnLgbqvhCare1mN+v/BEbg2E4hwync0xQ+zI+orz/g3wUesnvQ57ASScrXgW2TBAAJiOQvt2ynMJgJFEd/HoBkvAD6c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On January 14, 2026 11:00:55 PM PST, Thorsten Leemhuis <linux@leemhuis=2Ein=
fo> wrote:
>[stripped down the list of recipients quite a bit]=20
>
>On 1/6/26 22:18, H=2E Peter Anvin wrote:
>> [=2E=2E=2E]
>> This patchset cleans up the vdso build by building the 32- and 64-bit
>> vdsos in separate directories, moving the vdso2c tool to
>> arch/x86/tools, and by merging common code and especially Makefile
>> rules between the 32- and 64-bit vdsos to the greatest extent
>> possible=2E [=2E=2E=2E]
>
>Lo! My daily -next builds for Fedora failed on x86_64 (other archs
>worked fine)=2E Haven't checked, but from the error message I wonder
>if this might be due to the changes from this patch-set that showed
>up in -next today:
>
>+ /usr/bin/make -s 'HOSTCFLAGS=3D-O2  -fexceptions -g -grecord-gcc-switch=
es -pipe -Wall -Werror=3Dformat-security -Wp,-U_FORTIFY_SOURCE,-D_FORTIFY_S=
OURCE=3D3 -Wp,-D_GLIBCXX_ASSERTIONS -specs=3D/usr/lib/rpm/redhat/redhat-har=
dened-cc1 -fstack-protector-strong -specs=3D/usr/lib/rpm/redhat/redhat-anno=
bin-cc1  -m64 -march=3Dx86-64 -mtune=3Dgeneric -fasynchronous-unwind-tables=
 -fstack-clash-protection -fcf-protection -mtls-dialect=3Dgnu2    ' 'HOSTLD=
FLAGS=3D-Wl,-z,relro -Wl,--as-needed  -Wl,-z,pack-relative-relocs -Wl,-z,no=
w -specs=3D/usr/lib/rpm/redhat/redhat-hardened-ld -specs=3D/usr/lib/rpm/red=
hat/redhat-hardened-ld-errors -specs=3D/usr/lib/rpm/redhat/redhat-annobin-c=
c1  -Wl,--build-id=3Dsha1 -specs=3D/usr/lib/rpm/redhat/redhat-package-notes=
  ' ARCH=3Dx86_64 INSTALL_MOD_PATH=3D/builddir/build/BUILD/kernel-6=2E19=2E=
0-build/BUILDROOT vdso_install KERNELRELEASE=3D6=2E19=2E0-0=2E0=2Enext=2E20=
260115=2E439=2Evanilla=2Efc44=2Ex86_64+rt
>readelf: Error: 'arch/x86/entry/vdso/vdso32=2Eso=2Edbg': No such file
>readelf: Error: 'arch/x86/entry/vdso/vdso64=2Eso=2Edbg': No such file
>scripts/Makefile=2Evdsoinst:33: warning: overriding recipe for target '/b=
uilddir/build/BUILD/kernel-6=2E19=2E0-build/BUILDROOT/lib/modules/6=2E19=2E=
0-0=2E0=2Enext=2E20260115=2E439=2Evanilla=2Efc44=2Ex86_64+rt/vdso/=2Ebuild-=
id/=2Edebug'
>scripts/Makefile=2Evdsoinst:33: warning: ignoring old recipe for target '=
/builddir/build/BUILD/kernel-6=2E19=2E0-build/BUILDROOT/lib/modules/6=2E19=
=2E0-0=2E0=2Enext=2E20260115=2E439=2Evanilla=2Efc44=2Ex86_64+rt/vdso/=2Ebui=
ld-id/=2Edebug'
>make[2]: *** No rule to make target 'arch/x86/entry/vdso/vdso32=2Eso=2Edb=
g', needed by '/builddir/build/BUILD/kernel-6=2E19=2E0-build/BUILDROOT/lib/=
modules/6=2E19=2E0-0=2E0=2Enext=2E20260115=2E439=2Evanilla=2Efc44=2Ex86_64+=
rt/vdso/vdso32=2Eso'=2E  Stop=2E
>make[1]: *** [/builddir/build/BUILD/kernel-6=2E19=2E0-build/kernel-next-2=
0260115/linux-6=2E19=2E0-0=2E0=2Enext=2E20260115=2E439=2Evanilla=2Efc44=2Ex=
86_64/Makefile:1459: vdso_install] Error 2
>make: *** [Makefile:256: __sub-make] Error 2
>
>Full log:
>https://download=2Ecopr=2Efedorainfracloud=2Eorg/results/@kernel-vanilla/=
next/fedora-rawhide-x86_64/10010857-next-next-all/builder-live=2Elog=2Egz
>
>Ciao, Thorsten

Looks like it=2E Specifically it looks like it needs a tweak to make vdso_=
install=2E I'll look at it in a few hours=2E

