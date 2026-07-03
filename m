Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14A59C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 20:52:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B719E6B00B5; Fri,  3 Jul 2026 16:52:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B23496B00B6; Fri,  3 Jul 2026 16:52:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A39876B00B7; Fri,  3 Jul 2026 16:52:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7BAD86B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 16:52:49 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E0BCF1202B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 20:52:48 +0000 (UTC)
X-FDA: 84948664416.17.59AF716
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 54B6716000A
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 20:52:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="m/AEFhD/";
	spf=pass (imf08.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783111967;
	b=CMlDNFYC/rFF1g/bU/5khnZGRL49Y89WTtPEfjhq4FYCNCffHbHYDoJR+8RoKrK7EpYpA1
	QdTyRUVW1a4x+ssxUyFQqyhA9nJoGiBssfFkkAMGxkTPxLFPNaIxIvNz3zZhvwG6y8GpFg
	8u+oROYt1V44GqDFdXOt97iRDpPgy1Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783111967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qc6RQIMJ3TCgtwMlpFywp2lkPnh2VJAI6hIxptvIyMs=;
	b=ULokwztDpgJog58l++/olF2jI/c8+hUuJHXQIVQNnSBAUOArfDQqJ1DllgoUM/c/GiGXAM
	4mtCWNgmIshcbnieSf6XpxGvSt8rJEacQd6k2kERteXY2i2a/TKO9FFYr9lT98uLU2BOa3
	4BSRA4Wr7tsORYjKbOwvaktgz88pn1I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="m/AEFhD/";
	spf=pass (imf08.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A304600B0;
	Fri,  3 Jul 2026 20:52:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A6E1F00A3E;
	Fri,  3 Jul 2026 20:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783111965;
	bh=qc6RQIMJ3TCgtwMlpFywp2lkPnh2VJAI6hIxptvIyMs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=m/AEFhD/QQMVr60LVSSrHBJhZzSHloaCLPk21mBJcgCOInHXk9skqaY/SzJJ84tEX
	 UmT6M2g7SmZe+Xfl7u66KmHjHFowNBAw9iuDKrQPpkA0d+AKOFoNGiI4ScRdGq9tzV
	 5Bw71e6tMbrrNqTc7h68y+P8wFXYypmrKhsg4IoUL3B2t/kFt2ZfrsDK6qF5Axq7m+
	 0X+YpoR5DWk7RItGPbLuh218SieWYIlmdker7qyk9wbsyvgoZgAjV4Uu3czl1MVLAt
	 DcAB4UvUtBhMMozkhoRv21B/k0znEvzlBngIXWCHw9H0yTbipW6aseVsPvTnj3WZDs
	 DRMEjZMu/EqhQ==
From: Thomas Gleixner <tglx@kernel.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>, Michal =?utf-8?Q?Such=C3=A1nek?=
 <msuchanek@suse.de>, Mark Rutland <mark.rutland@arm.com>
Cc: Jinjie Ruan <ruanjinjie@huawei.com>, oleg@redhat.com,
 richard.henderson@linaro.org, mattst88@gmail.com, linmag7@gmail.com,
 linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org,
 kees@kernel.org, guoren@kernel.org, chenhuacai@kernel.org,
 kernel@xen0n.name, geert@linux-m68k.org, tsbogend@alpha.franken.de,
 James.Bottomley@hansenpartnership.com, deller@gmx.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, npiggin@gmail.com, chleroy@kernel.org, pjw@kernel.org,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
 hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
 borntraeger@linux.ibm.com, svens@linux.ibm.com,
 ysato@users.sourceforge.jp, dalias@libc.org, glaubitz@physik.fu-berlin.de,
 richard@nod.at, anton.ivanov@cambridgegreys.com,
 johannes@sipsolutions.net, luto@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 chris@zankel.net, jcmvbkbc@gmail.com, peterz@infradead.org,
 wad@chromium.org, thuth@redhat.com, ada.coupriediaz@arm.com,
 linusw@kernel.org, yeoreum.yun@arm.com, song@kernel.org,
 james.morse@arm.com, anshuman.khandual@arm.com, broonie@kernel.org,
 liqiang01@kylinos.cn, pengcan@kylinos.cn, ryan.roberts@arm.com,
 yangtiezhu@loongson.cn, sshegde@linux.ibm.com, mchauras@linux.ibm.com,
 austin.kim@lge.com, jchrist@linux.ibm.com, arnd@arndb.de,
 thomas.weissschuh@linutronix.de, sohil.mehta@intel.com,
 andrew.cooper3@citrix.com, jgross@suse.com, kas@kernel.org,
 x86@kernel.org, linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 linux-csky@vger.kernel.org, loongarch@lists.linux.dev,
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-sh@vger.kernel.org, linux-um@lists.infradead.org
Subject: Re: [PATCH v16 01/18] seccomp: Convert __secure_computing() to
 return boolean
In-Reply-To: <fa1f5b39-2703-40a1-81d6-3feba87e19b0@arm.com>
References: <20260629130616.642022-1-ruanjinjie@huawei.com>
 <20260629130616.642022-2-ruanjinjie@huawei.com>
 <akdp6GAu77-ipsXA@kunlun.suse.cz> <87cxx4mmim.ffs@fw13>
 <akeIK5TRCjlKbzbp@J2N7QTR9R3> <akeOjqMy7HVgRRCr@kunlun.suse.cz>
 <fa1f5b39-2703-40a1-81d6-3feba87e19b0@arm.com>
Date: Fri, 03 Jul 2026 22:52:43 +0200
Message-ID: <87echjlrs4.ffs@fw13>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspam-User: 
X-Stat-Signature: uiirpsq4dg7pynaocw7mq131gbdiyuq8
X-Rspamd-Queue-Id: 54B6716000A
X-HE-Tag: 1783111967-276945
X-HE-Meta: U2FsdGVkX19OabOnRtyUyVIxOwjNs40CD8X9s5q3BQZutybs+14oKDw1LmDVBUjfprCvg6bPiPoGi+omEHAAZMUT9nl3j9NWwsXvt0nWXzAW502KUVemZRJCaeE5oF/qtvkNkIPgRP2AFCHZF9yCuBv2wBk5g+Gv885EPZsLaKTqECo7J9ypNPDlIOdqge1XsYjPjfemnI8FF9tIU363PdHykIQQGo3v4uYmf9MZMEEeXrwDpSglphady2R5Xj41S25wP5OEep0RQe4WCt3y/HOXQnYPjGFiLvEOCetY5H+084JXNB0Six9znu3amvPXpDSoT0+PUTbQxGYiDzpbVo0UeoePVHxokJ3eh0N4C+fRjulnpQt13pfApm5ZtHoVOYXT1h/34GqUGThUl6Fwz7I9AEn7nBi1XYNxWiLoSBEFAi1CoEvcb1m93fvNVb7On1LiJFYjyJkv3NYpaDTIjFROOyI5RSXjrxeyEuUkloSuipqW0HHnsYuAcPUIe34PGbNqKN+SNfskJWoY+x1mMsLf1dBch0zTjMXfrlBNr21C2xhnfMcTPmRBptjT+mvkBADeALK3OF0dU/J8e4YeKPJBmVcUqv0BfpI9p7G/Ezg00c0RUUBqTN6m/6ds02QusaYbABks6QsbzEp+gV69865/35ynrpnkSnw7Uyf9zPYjzyagYMx1euUyAh+VClfhKmsKS9N3ukzHn+6fXz66vbwxmD/M5PphGzR1NHdOGxkRStYYw3GmEQnLRtIThHcIK6HpghNEyE5uy/YGLgTG0Ph4LusT0vY9IIDCqpijaJiC6/MGKWZWzKmCJir0hkwKiQB7wNH9iN7Dw0nQTZ8rlJYdmZuAy3mBLjRu7fkUHRnZ+GUVExrPqFKVxeU2dROlvkmoHKmqOM4uGfCrExrb7rsg7zTF8BAWMBV1BRtoj+GLzHhjme+T3QlCbXUbwKuzAsIMBwlGrsSilMhZQA6
 y7SMGcjR
 C4tkyH05KXVAv86cqkT9NcxR5kSHvcfWocsetPb+mEeGHtZ5Tp/LDc6a1lnf3Sp9EmJiBB80m7HK+4bNmYscUdQjdS0YGsDkkpOcY+i9x3f/DDRtPJi/U0jNWNjatNcbnA6eN8okF/jBYUE02pfSfWinmG/DyhSsbbS4lY4qSTPQS4/wm75n4p8Ul9tp+1Rnc4JQNccpnUScHDdWrz2VdautfdvWk+gthgbrrR18FOLgYE2d3LICiOC5VmaeWiSCEA2chMLOdwOpmqlnANFMQr7rNkqX/ISRFAXgYMujUOFnyEvDJ+jmnqoXY/1L672ZxtJRU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03 2026 at 13:59, Kevin Brodsky wrote:
> On 03/07/2026 12:27, Michal Such=C3=A1nek wrote:
>>> If we're changing the return type, it might be worth renaming the
>>> function something like:
>>>
>>> 	seccomp_permits_syscall()
>> Then not only it is clear which way the boolean value should be
>> interpreted, it also pervents the accidental inversion of existing
>> calls. Overall great.
>
> Totally agreed, if we have the opportunity to rename a completely
> undescriptive function name like "secure_computing" we should take it.

Absolutely no objections from my side on that.

