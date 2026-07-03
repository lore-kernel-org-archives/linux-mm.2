Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF899C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 09:48:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E72316B00B4; Fri,  3 Jul 2026 05:48:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E011F6B00B7; Fri,  3 Jul 2026 05:48:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC6846B00B8; Fri,  3 Jul 2026 05:48:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A2AC96B00B4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 05:48:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 24E40404B1
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:48:55 +0000 (UTC)
X-FDA: 84946991430.03.AB12AF1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8B4DA40002
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:48:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kTHi5+aa;
	spf=pass (imf11.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783072133;
	b=3EWvJjVsGmCSGf8BFBQqy9eeuYNikmOwmBQgxKiUrodiJtwAABjy6/+2k17916WpHrdOxJ
	MLoeYt9OtKl7thQ1VKqB1xpnZP379yMJ9dQ568aVkRec9eDeQmP13peI0bxIiVQ12dzl5A
	V8HmZkTSq5JXnsNqo4B2+95QWLoZQ00=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783072133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GU2sQW+BHbRyl8stT+ES8Av3G6KBfsKpnc1VSiXAaH8=;
	b=Uo+I/VdLgGv6iUMNOUg0N5NlcfOcVNwgpp768yLjf7E+PQ3QLbj2M/B3kX6HcFqLFPq5C9
	1W2IBkxn/5sTeRY/wWt5pkoeWXqjxdMDR+saMswB0kxGl98VjaoWusmRWCDvQs1UauSHet
	otBop0ub/eh7w4GYFW2pR1GUB/3AR7k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kTHi5+aa;
	spf=pass (imf11.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CB5A46001A;
	Fri,  3 Jul 2026 09:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F641F000E9;
	Fri,  3 Jul 2026 09:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783072132;
	bh=GU2sQW+BHbRyl8stT+ES8Av3G6KBfsKpnc1VSiXAaH8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=kTHi5+aaAp/rX4HTakkhjR3bFvlbbboB2hx19Nen/OQCynsTw3x/WIdUXu+frxwFV
	 89SbG0+Shaxd2FOCH4dmgKGnOQNd95ufhEkEGXGpT/32v4K6RPBMgJaLR03++i0XQv
	 HLnWwMqbhfMA9VGMcYWioEN6EpIjQeekAAIeSA8n3p4PU3sGcDhY+SXTEkDi6qWsvN
	 N6ri66YT0BOjRUFOiXivtMgrlnMXxRLN30aljrlnw5thKW/fQEv2TszzuBrW0Uq2oE
	 Hw8BoXQe/baC4Oi3LETFSwEwu7qrQBQfRHShyZgwSnxBg2nijHTJWdtguxJWbMqGZ5
	 OSuwx+53eId9w==
From: Thomas Gleixner <tglx@kernel.org>
To: Michal =?utf-8?Q?Such=C3=A1nek?= <msuchanek@suse.de>, Jinjie Ruan
 <ruanjinjie@huawei.com>
Cc: oleg@redhat.com, richard.henderson@linaro.org, mattst88@gmail.com,
 linmag7@gmail.com, linux@armlinux.org.uk, catalin.marinas@arm.com,
 will@kernel.org, kees@kernel.org, guoren@kernel.org,
 chenhuacai@kernel.org, kernel@xen0n.name, geert@linux-m68k.org,
 tsbogend@alpha.franken.de, James.Bottomley@hansenpartnership.com,
 deller@gmx.de, maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com,
 chleroy@kernel.org, pjw@kernel.org, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr, hca@linux.ibm.com,
 gor@linux.ibm.com, agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
 svens@linux.ibm.com, ysato@users.sourceforge.jp, dalias@libc.org,
 glaubitz@physik.fu-berlin.de, richard@nod.at,
 anton.ivanov@cambridgegreys.com, johannes@sipsolutions.net,
 luto@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, chris@zankel.net,
 jcmvbkbc@gmail.com, peterz@infradead.org, wad@chromium.org,
 thuth@redhat.com, mark.rutland@arm.com, ada.coupriediaz@arm.com,
 kevin.brodsky@arm.com, linusw@kernel.org, yeoreum.yun@arm.com,
 song@kernel.org, james.morse@arm.com, anshuman.khandual@arm.com,
 broonie@kernel.org, liqiang01@kylinos.cn, pengcan@kylinos.cn,
 ryan.roberts@arm.com, yangtiezhu@loongson.cn, sshegde@linux.ibm.com,
 mchauras@linux.ibm.com, austin.kim@lge.com, jchrist@linux.ibm.com,
 arnd@arndb.de, thomas.weissschuh@linutronix.de, sohil.mehta@intel.com,
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
In-Reply-To: <akdp6GAu77-ipsXA@kunlun.suse.cz>
References: <20260629130616.642022-1-ruanjinjie@huawei.com>
 <20260629130616.642022-2-ruanjinjie@huawei.com>
 <akdp6GAu77-ipsXA@kunlun.suse.cz>
Date: Fri, 03 Jul 2026 11:48:49 +0200
Message-ID: <87cxx4mmim.ffs@fw13>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: zbjirpwxaxny8y8g9y4of51e5babszqx
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8B4DA40002
X-HE-Tag: 1783072133-677854
X-HE-Meta: U2FsdGVkX19ldhu+g/hGAYe2l+OqjgT+63ZJfAxvQs/9xQDHTd9ZacW4L1t9hd9UVH+gm8qpBns/nVCpVCeaRPIBRPg+Dnpc9K1FC29T96RoOkPyvETQZhS9eTctBBA46KsL7h6Mraz/v1CHlFWG/7dHDGItlrTa3lZFIT1s5RuupFfksomgReJm5ELDccZjfmSlvi9LaonJFuuIOGkHLyXNxpITga6J0Wehz/Oe7l7bYVT9brwMzAy1FiKuayknCpc6wJLYtN9jfT+mbDpFLJ09lJ8Aovy+8L7GutTOWQb7lQLx6xXJOkYu77QV0WBcNSnrg1xP4KlLf9t4cOrajgn40kESlXjnaJMIzlxk/kZ7P52hyjbGmgb5zj7bcrMlMZHifOjhwmx1xcrAR9TnIQaXpKv8/RyBXkA8XeKAplOKnuYGZFyGoG8C4pJP0o6WAR4Io9UBT6L3CpOPSbqvUpa5jWNrL0tAIJ29reSjo7BTfpynDlJeWkmk2mV41SPhhUWi1Ydj2TS4HwfXD6aNxyr5Vq3CfGEMoa6jhlvDyGJfDHcTToisDxweP1iUPWteTOvx7tJllqt0MlyiDVFjx+98WWKB5PhOGC2MDvuGIW/Ui7rNuv7VO06zKTw/t31arNqJnAODEa+KlkDVI73s38vZW9ODj0KvvWI4NjB/mJDCw732I4fWbaMqn/hKginj16DDKktTc91pmy1+LPuwxjwqyV/Coi+YT2sIchrNlSaJ5gvadUPpDtZMIRPHLk8JRWLEycjXUiwDdY8Q+cDK1OjwFrQgSFFGtwrUyEZ414P1n9LsGsYZDEZTPZHOVz1kFjcgg66bTKQv+hfv92IVrRAHFuCciUfsLiSHwqyXr2wnKeaIHL6zJah5tnTmja9ba91Ah/tx/XHxfUtO5YrKkSQBkbJSL0D1crxNteZkBfE/NIng8mo9DHu3eIGPl/Az/0SXzk9s+K7FBV5aPxs
 DmlFWBpp
 iwdk8nZguIdRHb4LMElJ/sPtLKp4UNn7v0GLv70vjzA0PLTQMtPWo/GIyZkk1z444P4/nrql/KFlxxQCwoiE+a0CtLNL8UPOlUfDKk11a86oCXY6xw/1RdEHcQBczst18sVGkkW61dQqVRWCOmU/ebQqZdOqrlognxrQRhr9RAQLjJevcVs76MSMvH93VGKlLgK864biSBS7AjYw96h2mXHh1s0Rh8ZmXf7nqSfORjHZBvDvm/44yvOmBk37nHerR9ItwtTHPA7SyZfwIzM7CjOKx6kSvaMGm3l6081eEAMJuLU0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03 2026 at 09:51, Michal Such=C3=A1nek wrote:
> On Mon, Jun 29, 2026 at 09:05:59PM +0800, Jinjie Ruan wrote:
>> -	if (secure_computing())
>> +	if (!secure_computing())
>>  		return -1;
>
> Hello,
>
> I am not fond of this logic inversion. The boolean is meaningless in
> itself.
>
> Previously -1 was used to indicate that the syscall was filtered but you
> chose to invert the logic choosing true to mean syscall was not filtered.
>
> You could choose true to mean that syscall was fitered avoiding this
> inversion.

That's just wrong. Boolean logic makes more sense with having
(!condition()). Just because the old 0/-1 nonsense had it the other way
round does not mean it has to stay that way.

> Sashiko points out some places in existing code where it supposedly
> explodes which might or might not be true

The vsyscall one is correct, but that's a bug like any other one and should
be caught in review.

The blurb about bypass is AI halluzination nonsense.

> but any in-flight patches that use secure_computing would also be
> affected.

Maintainers know how to deal with collisions of that kind. Stop making
problems up.


