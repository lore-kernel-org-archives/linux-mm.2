Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C998CCF2DE
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 19:43:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D46F6B02B3; Mon, 19 Jan 2026 14:43:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B5906B02B9; Mon, 19 Jan 2026 14:43:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D8326B02BA; Mon, 19 Jan 2026 14:43:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5A55F6B02B3
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 14:43:34 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05043B6E9F
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 19:43:33 +0000 (UTC)
X-FDA: 84349737948.15.1E81064
Received: from mail-244122.protonmail.ch (mail-244122.protonmail.ch [109.224.244.122])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0F86840007
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 19:43:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=mmSiMYG6;
	spf=pass (imf04.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.122 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768851812; a=rsa-sha256;
	cv=none;
	b=xqnq/fh6vtnVSgtyxGqcOTQUTEgOnSk0L7jIknUxcBJ5A/90kNOg/Wf1ayNFn/R6AVYU61
	QX4gGcEFLITpXBPmaAokhRtnU/pAmV72z3fkkfV5T3DFvVRfZFWKzGHDARlieWMgUYueL7
	LA6za0WXZSrkGNokAc37D9WOWjHMar0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=mmSiMYG6;
	spf=pass (imf04.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.122 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768851812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s9GRY0FJY6iHKv2Hjum9gopPHHwQIkfpO/pEZWZdRvM=;
	b=5LHntaDce+aUqoenJuef0jhU8HqCBkba6ICvKrdkD/aqyfczEf/i04YGTXKGhnnu0XMBZb
	NaJkll5GxaI9icTb2oG0RpOPD5oooVWXXHHYQM8iDwSCzNSzB0X0GSq5n2KyoDhZg87T1G
	JdGJxDrLJN41mYFS1RO1uRcoAFQ+LFw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1768851808; x=1769111008;
	bh=s9GRY0FJY6iHKv2Hjum9gopPHHwQIkfpO/pEZWZdRvM=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=mmSiMYG64YPT+CQ2wjQHoHi/YZc2cnwxdRHwxNUlyF5nEW8PzpH0VZc3HhOYq+8CF
	 FaChEkwkVLmrBvz027ugXCYoa9Dw6oR8nhShXt8fMNoMsjirTcTsUdKc4tfa+87dWo
	 g7J8yzuqRHz69j8YjGEwC+wz4kxz3xf27HtjEkhcHnr2TfHaHL9kzwwRGG9v5F4slZ
	 0bSFQATgcmirIgLi2xLDI0kRXAqEuT/gvcJiLCpDytXAsVoLUTj5+IxONZb80FXluD
	 w6lymthWpVEPALccPThV3E4Ok9EXUMEWIuvoAnAPIDgpBGOlzcZxqD2ddjWZuKPFwT
	 R1bShR6pmJUTA==
Date: Mon, 19 Jan 2026 19:43:23 +0000
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: corbet@lwn.net, morbo@google.com, rppt@kernel.org, lorenzo.stoakes@oracle.com, ubizjak@gmail.com, mingo@redhat.com, vincenzo.frascino@arm.com, maciej.wieczor-retman@intel.com, maz@kernel.org, catalin.marinas@arm.com, yeoreum.yun@arm.com, will@kernel.org, jackmanb@google.com, samuel.holland@sifive.com, glider@google.com, osandov@fb.com, nsc@kernel.org, luto@kernel.org, jpoimboe@kernel.org, akpm@linux-foundation.org, Liam.Howlett@oracle.com, kees@kernel.org, jan.kiszka@siemens.com, thomas.lendacky@amd.com, jeremy.linton@arm.com, dvyukov@google.com, axelrasmussen@google.com, leitao@debian.org, bigeasy@linutronix.de, peterz@infradead.org, mark.rutland@arm.com, urezki@gmail.com, brgerst@gmail.com, hpa@zytor.com, mhocko@suse.com, andreyknvl@gmail.com, weixugc@google.com, kbingham@kernel.org, vbabka@suse.cz, nathan@kernel.org, trintaeoitogc@gmail.com, samitolvanen@google.com, tglx@kernel.org, thuth@redhat.com, surenb@google.com, anshuman.khandual@arm.com, smostafa@google.com,
	yuanchu@google.com, ada.coupriediaz@arm.com, dave.hansen@linux.intel.com, kas@kernel.org, nick.desaulniers+lkml@gmail.com, david@kernel.org, bp@alien8.de, ardb@kernel.org, justinstitt@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, kasan-dev@googlegroups.com, llvm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v8 00/14] kasan: x86: arm64: KASAN tag-based mode for x86
Message-ID: <aW6HcGjkAZ3lITeA@wieczorr-mobl1.localdomain>
In-Reply-To: <e273571e-ab8f-46d6-a44e-c1d0d06d3cbf@gmail.com>
References: <cover.1768233085.git.m.wieczorretman@pm.me> <e273571e-ab8f-46d6-a44e-c1d0d06d3cbf@gmail.com>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 85c5e72275bf1238c6f06b30c2b28981083b1095
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0F86840007
X-Stat-Signature: xgbk5uc9hiyg53jeqieq49ktgjc3wgrp
X-Rspam-User: 
X-HE-Tag: 1768851811-275315
X-HE-Meta: U2FsdGVkX1+YDqSVBHQwSe27KkqX4J6Sv9Cw9zLR0J4eXRSM4wFHZYMm9qZzb47nntNxBn6rEcaqwzSSHePwG73iXWD/tPQZ+3/X+Uz9HeYihm+/Q71r/4quhuBkxGjDmMt5kfUGHaE33XY1Q+CgjD1U/yoPdrVNEPa5Rq3polRjNvQY6N/D8mJC5ojYpMYEGNfLLbhJuUPVUA7BIiNsE+l7x6Y/mgSRRjuamJPJlMK8C7XLCjxwbW73Xl/lffvMFy4C55Y3LMuhVVI0OnbwsrPHAv39/yM6Q0+p+gzcv/hJnRCgFTxorHgDS8cRh/JwMj0788tQ4utfrdGC7Qxih9q5WquSXFrp1D+sJHMm2cN8Rf92LnDTZaZqWiVq4+NZy5u2eQUKsDgc6tcRuTvH5usEW6RPi4JIxh7nOPA077kkf78HC/xO+fvhr/+neN4D0GATstz/MgCnDe4K4bgef86KZvtRuF6/uwsoyuw43PNW4wSlfL5QQKWH6fsINBAlUFAcAcXW8eHRwcfn3uHz1kbZE1AruYaYCZAqitApPtNcJ8QEmqQTR9dX6ca3R0w53lTnkC4ff8gFMPMG70IXVeJAkPG/EfNTGkVR6sGTYT7+1cEo8OX4jHo5Q9mrOtfSGwhBWI2idOc+sDz2EF8oCD4B6sxk99qbbcZdoIeiQDj6dbqDLpWGrkgD6uc85adHmnQVLGSEUA/QnXhbs+vh4ySs6VSRxohBJDQAGSUsPEGsDPnGzC4pvDnC4matvPKeZA7LI8Q8XWKEf0B7DNI4pjv1Lem5xkQxHO/oh9DMNikjEAgSudELC9gyGaVnvMwaOdyzwaqhrpKRNySboogS0bjH8i1gJ4kH4ySXXeQnxKxqJwpaAW6BFDOJh5pDPxu2s0b5mJ/fq1HOviKkAhAux0yQoTzGNWPLsOxVcn92NtnP4509xYLZBuSpyxZL+5xbNdue1C3wU+S0V7RE1Uu
 1UDud9Y6
 uTWAo54o9fy9mkCfMyMf4jyodUxYwEH2gD8/Nqic0oyUN0jFG/IDlxR9noBfQxku90L8YDpC8Tq+cE/YBKcFAPzvp/bm9XaQChkNYr3wjHo0LjSJuJG6ACQJEmy8zw7kgTrAEFM/CQ+5aUkSt2CIZLuM0t6cM3VxIl5DcLQoMIpYFvAwgX4W/LQ9eiK1cNF0DeVZxjIN11UrvIUKxuytjM8R1R82Oc+8dJMASmt585BNwYxPc5Yllso2lrbvbf4qDiLM7+UOF+HVEFa1Qaea2D7s3HR/y/Fh7/mjXEZ4WSY8W0nVriZ3iNaVCMsNzXzFg4Z5vt4OBeetKKe8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-19 at 17:33:35 +0100, Andrey Ryabinin wrote:
>On 1/12/26 6:26 PM, Maciej Wieczor-Retman wrote:
>
>> =3D=3D=3D=3D=3D=3D=3D Compilation
>> Clang was used to compile the series (make LLVM=3D1) since gcc doesn't
>> seem to have support for KASAN tag-based compiler instrumentation on
>> x86.
>>
>
>It appears that GCC nominally supports this, but in practice it does not w=
ork.
>Here is a minimal reproducer: https://godbolt.org/z/s85e11T5r
>
>As far as I understand, calling a function through a tagged pointer is not
>supported by the hardware, so GCC attempts to clear the tag before the cal=
l.
>This behavior seems to be inherited from the userspace implementation of H=
WASan (-fsanitize=3Dhwaddress).
>
>I have filed a GCC bug report: https://gcc.gnu.org/bugzilla/show_bug.cgi?i=
d=3D123696
>
>For the kernel, we probably do not want this masking at all, as effectivel=
y 99.9=E2=80=93100%
>of function pointer calls are expected to be untagged anyway.
>
>Clang does not appear to do this, not even for userspace.

Cool, thanks, nice to know why the kernel didn't start with gcc.

I'm going to check in on the bug report every now and then and once it gets
resolved I'll test if everything works as expected on both compilers.

--=20
Kind regards
Maciej Wiecz=C3=B3r-Retman


