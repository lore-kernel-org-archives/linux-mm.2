Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0157D3CCB3
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 07:01:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B406E6B0088; Thu, 15 Jan 2026 02:01:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1E426B0089; Thu, 15 Jan 2026 02:01:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A244E6B008A; Thu, 15 Jan 2026 02:01:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 90ED56B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 02:01:07 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1D37C160210
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 07:01:07 +0000 (UTC)
X-FDA: 84333301374.07.7067EC5
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id 42F25140007
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 07:01:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=leemhuis.info header.s=he214686 header.b=rNc3Xwoq;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of linux@leemhuis.info designates 80.237.130.52 as permitted sender) smtp.mailfrom=linux@leemhuis.info
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768460465; a=rsa-sha256;
	cv=none;
	b=efM95bG6qnZH3ez14DC9NW1ykLkCUdRg/0kfGmH9PSnRmCQy6xf0UbbvNQFzhIcmkQpZwL
	onS6DJC83AbpatkAd4/Sb5+h4w2q3ahUovW7Wft48DQOPM7CT6dKPLA/K2UkTToD3UVBdi
	k8n250f5RpoiYRhz+DEm8/NbYoPtiVk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=leemhuis.info header.s=he214686 header.b=rNc3Xwoq;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of linux@leemhuis.info designates 80.237.130.52 as permitted sender) smtp.mailfrom=linux@leemhuis.info
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768460465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=92kyb/l1XrVqgOYYCDlnzdTp1L5gMW6g0JF4poxao5Y=;
	b=SUTB0LYOg9zQN41DNImOK4Ibz/VfRNXoTSe6f2OOIrHj3+uYKgVu/EkOCEmEyQw3JpmCMa
	hcVl8YVWmf2BSdnhzwhy5NeGM8p07He0YbK2uIWgRFuBVH6Dn8m9EIdW0KrtX3sOGPHdvH
	f4RtBz+PxgW0m+QJxAYLp/51n/VQzZg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:Cc:From:References:To:Subject:MIME-Version:Date:Message-ID:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=92kyb/l1XrVqgOYYCDlnzdTp1L5gMW6g0JF4poxao5Y=; t=1768460465;
	x=1768892465; b=rNc3XwoqLFyxi+RJ6f/QupfNeVwxVfKigLtyIaQv7cSyjLLqNxqAleUABVRk3
	I+mYTXE5lSOr9MH6GMClikTT5RxopSQiU7vjwl2HLhGIS7P7WJM/QZHpy6zqSwPmy8jCjPO6WudbS
	17dP4elrCqKSTN8vBF5yrq9K/mEY5HJ/uW+fzW8nJsplP4TbC6Qe4KsdeFdTUQhG/4o2Ll/njsV2+
	08eSCqheCpPOs3w1gPvIWeHxWva3EJugHumNA9NkJW1Wbjf3qYVaoK0Q8H8nPQTwVWG3F4SvsUKUZ
	GatY9QvLAYwpM6n8IXzeeFmazn3c3OIEYTPmBYZERy8ES7KzGw==;
Received: from [2a02:8108:8984:1d00:a0cf:1912:4be:477f]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
	id 1vgHLq-00ENNS-0R;
	Thu, 15 Jan 2026 08:01:02 +0100
Message-ID: <16ea64d1-2a9b-46f9-9fcc-42958f599eb6@leemhuis.info>
Date: Thu, 15 Jan 2026 08:00:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4.1 00/10] x86/entry/vdso: clean up the vdso build, vdso
 updates
To: "H. Peter Anvin" <hpa@zytor.com>
References: <vdso-cleanup-patch-4.1@zytor.com>
From: Thorsten Leemhuis <linux@leemhuis.info>
Content-Language: de-DE, en-US
Autocrypt: addr=linux@leemhuis.info; keydata=
 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 MEK4
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
 linux-sgx@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org
In-Reply-To: <vdso-cleanup-patch-4.1@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;linux@leemhuis.info;1768460465;5fd59061;
X-HE-SMSGID: 1vgHLq-00ENNS-0R
X-Rspam-User: 
X-Stat-Signature: b3hyfygzwy8jtsnijhniubaiz4r6eoap
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 42F25140007
X-HE-Tag: 1768460465-57239
X-HE-Meta: U2FsdGVkX1+AWyzlTHWTo3egosEwcLx6SQWr6dQ5iZ+1ChiFL+BW/4BYGqXQOEDnOaKT+ZlFRkJpmTNsoFEzx9CA/rNZzHIzWDIbkoFtFILdjrYCCyoxc6wMSHt76mqEVoPfcNfRRpwjQYnRvXC11H8aHmI58p8yQXRLm5x+3uIjHst/w3q88QrTtxgGFhrKiULOweF2a5KxbDzvwNDkIr4MhlXn77zf0JGleQe2wrQ63s3h1MH7wv7ec8o0UCkRhGhZt0mZsNZ9JNTYq4llzqF6GHPbnazkP4njLTMEG/zyPd3EqwD2UYjZn4aJRQT5n9bBfSUP7IQ/CCssE1G5XFPslb9QiZX7c7NmAoPkj6jXe3DcSK5D7I6SVwRerg5S/yf6iW5u5847ns+FvR1m1z0c7wpzuTjzsgzXbi0wBTvi7ZuKXRVfPMD5n9iPE1QsZTbNT+EilYtORXAGQ0VrXL9bFCL9ZyaWMvB2iwH59fpQ7DXH7kLX1RM8U9AmDQHWFQrNSD+Z5rFiW1u4L1DoJoYfVj6k/L0BlJf+6gGnDdA2VWrBAQvUVTHtgtDyGHx7A/Aap3ptq+3g8AkA/M4nyJ3qvnOzmtfDW9D/QBCgd3Ui+dD6P951qbhQ0+hV+HvCsz9saZ75o1Mwlpz/O3kX31Oc2+k5QE1QOcEv8rFpodGWiosfpeav7ypjbDXJkd0/E0PROFX1aehboured6lCQ51jAm6UFdCtedAvxkZqtdZAb6OPGhONCPKM9pwMydh5VQ9C1bemwcu4NFKM82WQiTNV6etavD5R/Nu+yD4d3cBfJZqtm2ajry7jJv6L0Lz9ZCiAHmdfQmfAcaToDMiK99gDr7qLwgX++4KqLDRTaPO4PM6mgrAla2tQG/kgU0P8RS5bPcYR7gzKgHdDhtULVmWpL6TOK0Ss
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[stripped down the list of recipients quite a bit] 

On 1/6/26 22:18, H. Peter Anvin wrote:
> [...]
> This patchset cleans up the vdso build by building the 32- and 64-bit
> vdsos in separate directories, moving the vdso2c tool to
> arch/x86/tools, and by merging common code and especially Makefile
> rules between the 32- and 64-bit vdsos to the greatest extent
> possible. [...]

Lo! My daily -next builds for Fedora failed on x86_64 (other archs
worked fine). Haven't checked, but from the error message I wonder
if this might be due to the changes from this patch-set that showed
up in -next today:

+ /usr/bin/make -s 'HOSTCFLAGS=-O2  -fexceptions -g -grecord-gcc-switches -pipe -Wall -Werror=format-security -Wp,-U_FORTIFY_SOURCE,-D_FORTIFY_SOURCE=3 -Wp,-D_GLIBCXX_ASSERTIONS -specs=/usr/lib/rpm/redhat/redhat-hardened-cc1 -fstack-protector-strong -specs=/usr/lib/rpm/redhat/redhat-annobin-cc1  -m64 -march=x86-64 -mtune=generic -fasynchronous-unwind-tables -fstack-clash-protection -fcf-protection -mtls-dialect=gnu2    ' 'HOSTLDFLAGS=-Wl,-z,relro -Wl,--as-needed  -Wl,-z,pack-relative-relocs -Wl,-z,now -specs=/usr/lib/rpm/redhat/redhat-hardened-ld -specs=/usr/lib/rpm/redhat/redhat-hardened-ld-errors -specs=/usr/lib/rpm/redhat/redhat-annobin-cc1  -Wl,--build-id=sha1 -specs=/usr/lib/rpm/redhat/redhat-package-notes  ' ARCH=x86_64 INSTALL_MOD_PATH=/builddir/build/BUILD/kernel-6.19.0-build/BUILDROOT vdso_install KERNELRELEASE=6.19.0-0.0.next.20260115.439.vanilla.fc44.x86_64+rt
readelf: Error: 'arch/x86/entry/vdso/vdso32.so.dbg': No such file
readelf: Error: 'arch/x86/entry/vdso/vdso64.so.dbg': No such file
scripts/Makefile.vdsoinst:33: warning: overriding recipe for target '/builddir/build/BUILD/kernel-6.19.0-build/BUILDROOT/lib/modules/6.19.0-0.0.next.20260115.439.vanilla.fc44.x86_64+rt/vdso/.build-id/.debug'
scripts/Makefile.vdsoinst:33: warning: ignoring old recipe for target '/builddir/build/BUILD/kernel-6.19.0-build/BUILDROOT/lib/modules/6.19.0-0.0.next.20260115.439.vanilla.fc44.x86_64+rt/vdso/.build-id/.debug'
make[2]: *** No rule to make target 'arch/x86/entry/vdso/vdso32.so.dbg', needed by '/builddir/build/BUILD/kernel-6.19.0-build/BUILDROOT/lib/modules/6.19.0-0.0.next.20260115.439.vanilla.fc44.x86_64+rt/vdso/vdso32.so'.  Stop.
make[1]: *** [/builddir/build/BUILD/kernel-6.19.0-build/kernel-next-20260115/linux-6.19.0-0.0.next.20260115.439.vanilla.fc44.x86_64/Makefile:1459: vdso_install] Error 2
make: *** [Makefile:256: __sub-make] Error 2

Full log:
https://download.copr.fedorainfracloud.org/results/@kernel-vanilla/next/fedora-rawhide-x86_64/10010857-next-next-all/builder-live.log.gz

Ciao, Thorsten

