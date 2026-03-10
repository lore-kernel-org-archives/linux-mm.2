Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E761FD4F19
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 19:18:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7F3A6B0088; Tue, 10 Mar 2026 15:18:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2D7E6B0089; Tue, 10 Mar 2026 15:18:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9393C6B008A; Tue, 10 Mar 2026 15:18:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7225F6B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 15:18:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 21988140130
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 19:18:03 +0000 (UTC)
X-FDA: 84531113646.03.4E9E38D
Received: from mail-244123.protonmail.ch (mail-244123.protonmail.ch [109.224.244.123])
	by imf09.hostedemail.com (Postfix) with ESMTP id 20E0C140019
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 19:18:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=rR9gSYkh;
	spf=pass (imf09.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.123 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773170281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qoHZk/OhrSl6MrxG5Mj/wzOQ+Ag6/K1R4s+ErDzpvw0=;
	b=xDl1vmdmARh2FUiv2NijerFzEQ3FC4y5L37ZmhQr6unNh6GKV1LJnBiLJoWByNsFM7uulP
	HseUMuooQPZnEQhTYelK/bSiHGa+eCLkUylFg3hhZAqsO68KPkQm8160ec1drJAgwTxAej
	CNCCFq4NoyJIyJ+UQ8/7q6bGfn6Qygc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773170281; a=rsa-sha256;
	cv=none;
	b=lpiL0HE1ieSgmn6958wMKEOljrb6YnUaFUxtoCqYszUTv1llif1CADedIfH4qfBWG2gkaV
	r7T6jEu2hZdGCYU4xv8ewljSvctq08qrbRfZY8pMPcR4/M0VFp+f5PFl3/80oeWweioMWy
	pkJhwpMI78/O2uzphZj0CshlMRSUG9c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=rR9gSYkh;
	spf=pass (imf09.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.123 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1773170277; x=1773429477;
	bh=qoHZk/OhrSl6MrxG5Mj/wzOQ+Ag6/K1R4s+ErDzpvw0=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=rR9gSYkhvunRslGRTcO93zUtjG4S9QPohyc7ONkvqctlqRe5PAr6eHvbGcQDs36n3
	 33yQN5T+ps4YqoZEpt+gLyhdwBysz/a2OO5acn6s5y8CxSR9RWbUEH0PIVT6p2UtCC
	 +uztI4Plu+Gmk2sFw6yDf1p441e0Y4cmuh6BD8HOGwl+MQRtA42Sm5SodKs90+7Td2
	 wlE34NSb2zzCAQpxCfImaeT7NnWInHxaoALO26ADLN7txCDcMhSVsLhxaqpIcUfY1l
	 2ik5c5wMsrTJTnUVu9RSRaIDQtui9rXEXNSCN8Gl9GupewNhLmIv1OHtkTl1zTwqU0
	 2OvHHg0vin3Mw==
Date: Tue, 10 Mar 2026 19:17:43 +0000
To: Andrew Morton <akpm@linux-foundation.org>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: urezki@gmail.com, ryan.roberts@arm.com, kevin.brodsky@arm.com, samuel.holland@sifive.com, dave.hansen@linux.intel.com, jeremy.linton@arm.com, peterz@infradead.org, weixugc@google.com, ljs@kernel.org, ryabinin.a.a@gmail.com, rppt@kernel.org, bp@alien8.de, luto@kernel.org, jan.kiszka@siemens.com, mingo@redhat.com, david@kernel.org, mhocko@suse.com, andreas@gaisler.com, kas@kernel.org, Liam.Howlett@oracle.com, morbo@google.com, thuth@redhat.com, catalin.marinas@arm.com, ankur.a.arora@oracle.com, kbingham@kernel.org, nick.desaulniers+lkml@gmail.com, andreyknvl@gmail.com, dvyukov@google.com, corbet@lwn.net, leitao@debian.org, hpa@zytor.com, tglx@kernel.org, yuanchu@google.com, ardb@kernel.org, vincenzo.frascino@arm.com, tabba@google.com, joey.gouly@arm.com, nsc@kernel.org, will@kernel.org, yeoreum.yun@arm.com, nathan@kernel.org, maciej.wieczor-retman@intel.com, skhan@linuxfoundation.org, axelrasmussen@google.com, osandov@fb.com, surenb@google.com, justinstitt@google.com,
	kees@kernel.org, vbabka@kernel.org, hsj0512@snu.ac.kr, trintaeoitogc@gmail.com, jackmanb@google.com, maz@kernel.org, glider@google.com, linux-doc@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, workflows@vger.kernel.org, llvm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v11 00/15] kasan: x86: arm64: KASAN tag-based mode for x86
Message-ID: <abBpbS3tplFSlVgx@wieczorr-mobl1.localdomain>
In-Reply-To: <20260310112421.8ceb7415e14b49cbd86db715@linux-foundation.org>
References: <cover.1773164688.git.m.wieczorretman@pm.me> <20260310112421.8ceb7415e14b49cbd86db715@linux-foundation.org>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 0e6fddfcfa9693d70ed9e03b42a5ca69edab13d7
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 20E0C140019
X-Stat-Signature: wt8whx3mbiau6ohhbk911u5rsaieubym
X-Rspam-User: 
X-HE-Tag: 1773170280-818325
X-HE-Meta: U2FsdGVkX18skw+QniFzx9vOEOURduR0pD1+BYIx69F9rktkSEYSjmNHq39XPht2O9LlrHk+opipVRi4XsBcCZRb6ZGjLs3q70oNp1Xc9VFybGf8UVKKY+xGqIN4qQZf8SlrAWO8izsqzIBR6Mhab7jlp1cFWGwJj8aujfCRzTU/SKJvdTBUEUXlAMBllndLIShC75KVI1abcoxZUSCenopXsbwCt4clgbPOK06voAIgy+0mAwM47yoRQnYKhBm+JeyqEcRg+xv39XysxOGhSnxOmcAR7K2U12bXNKhTxRyj1DjFCTBr9Ct2hWS1hRk4pWJ3owKVa9HjntXxqX3wl95PMofGtM/60uIErVxZbiQPt4QCV+ActNLlu2PM66DDOgOhYnS/9s1ag0YHMQol+3CEfW1hmQghYtJZI5QDm6KwzsUdZ4z3hXyJI8LuhQmC5Z8LpSQdAmEyXn0XaMcGJq3XJ3h7YXVu7mA2Qx/u4zEG6pEOEdVWqjohmvH3oCmCEqnz9v6KzRPuu2yCc9vSDQPwM+FQYwxn/blckzhh20QgJGzP/a3AIYv+RJwfDlv7rAmDgPayNQFeZOUaCTGn/pD4imhKreANERtnEQ6C1k02exfRccJdUTMVI0KnjmmspwDlKyg/amC7UW9TG1vlH/vHMU4thUZ/KohTHKvo8S4b2D4j60lDe+3XSB2LsqFQyjNKKf3kRWDZMKxSZ6V8/Za1Dpz9L+zE6vFJO/LDnGWNL9ux4nVEBbBs8kXmcUPl3mwD5WRDTSxn44CiVbPPh9LNHpR8Hfp5qEiS7KuMdJkDqtd5BiHbjna/Y1ifcCtpi2aD1XkWOxcMf0PDIJgibp89T3oY2h988BH0/MSXGu+TdqUJtIPcHYdVxSzTovcSmitmzlEjnnWsulpTEiWazvmAjWAvrcMdB1RoQlMHgLvE6V+dVaTKDUHNfmbVfeOFihBBu+JRzuA+xKENLSC
 O55gEtxS
 ZklKdP0huezldxw2b3pP0pq9025ZV0IiDvZRfF0f6NYOBhg5XqvhBGNxt3kyvG0I+SuH40vDQEBmonlAPMyKdzSnE/tFjLhVP2AimcN2n/t/yHx+5kF2CQ2oHIeVmuNRA6bE0XBPeTTnWkSn11HmN8DQbskBgkiwq1DvKGj1+zT/uDYi3HlkfTxAbka6jo4BkmPae+6r9ftmf+pVBbXrNsXj/UEddOvPXc9WW0xZ55tBtRamrtfazlvBKJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-03-10 at 11:24:21 -0700, Andrew Morton wrote:
>On Tue, 10 Mar 2026 17:51:19 +0000 Maciej Wieczor-Retman <m.wieczorretman@=
pm.me> wrote:
>
>>
>> [1] Currently inline mode doesn't work on x86 due to things missing in
>> the compiler. I have written a patch for clang that seems to fix the
>> inline mode and I was able to boot and check that all patches regarding
>> the inline mode work as expected. My hope is to post the patch to LLVM
>> once this series is completed, and then make inline mode available in
>> the kernel config.
>>
>> [2] While I was able to boot the inline tag-based kernel with my
>> compiler changes in a simulated environment, due to toolchain
>> difficulties I couldn't get it to boot on the machine I had access to.
>> Also boot time results from the simulation seem too good to be true, and
>> they're much too worse for the generic case to be believable. Therefore
>> I'm posting only results from the physical server platform.
>>
>> =3D=3D=3D=3D=3D=3D=3D Compilation
>> Clang was used to compile the series (make LLVM=3D1) since gcc doesn't
>> seem to have support for KASAN tag-based compiler instrumentation on
>> x86. Patchset does seem to compile with gcc without an issue but doesn't
>> boot afterwards.
>
>So LLVM works partially and gcc doesn't work at all?

The non-working options are disabled in Kconfig so right now only outline K=
ASAN
with LLVM works fully.

>Do we know which compiler people are using?  Google tells me that
>Android, ChromeOS, and OpenMandriva use LLVM.  That's pretty thin.

I don't have any numbers on this matter, from working on this I only got th=
at
there is much more KASAN traffic around clang. So I thought that most KASAN
users prefer LLVM.

>This is all rather problematic and it isn't clear (to me) how to
>proceed at this time.  Do we have any projections on when all this will
>be fixed up?

My understanding is that there is something off in gcc support. I recall An=
drey
Konovalov mentioning that gcc also doesn't work well with arm64's KASAN
tag-based mode. As for LLVM inline support I do know the codebase a bit so =
I got
some WIP patches there. But I wanted to see where this review process goes
before posting to LLVM.

>> The series is based on mm-new.
>
>I actually carry kexec patches in the mm-nonmm-[un]stable branches.
>But the series applies OK anyway.

Should I base this patchset on top of mm-nonmm-stable in the future? I was =
after
one patch by Andrey Ryabinin that was in mm-new and I needed to rebase on t=
op of
it.

--=20
Kind regards
Maciej Wiecz=C3=B3r-Retman


