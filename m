Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD93CC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 11:59:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B24406B00B4; Fri,  3 Jul 2026 07:59:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFCB06B00B5; Fri,  3 Jul 2026 07:59:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C75F6B00B6; Fri,  3 Jul 2026 07:59:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 731926B00B4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 07:59:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 043048EB7C
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 11:59:50 +0000 (UTC)
X-FDA: 84947321382.01.DCB0800
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 42AE310000F
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 11:59:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=BzvOXcJ3;
	spf=pass (imf14.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783079989;
	b=qZ8GU5KQeby9TV99L9Uqf/bjzTnL2QfR0FksShwZJjcf5jjOKgdczkcxE8J36OVer/rvE4
	c8x+vUrgyIeZQdAM/lxA5pHsQ0Nd/rOuPbH3Atqxlyg0y0Bg3lAzJimP28aMUn4V0YLak2
	bW4vU/vOib04/9lTg/cFzaDYpuD8PsQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783079989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nIRicYWAN7eALFj2WeVf3MGLGNgyyZRX21hN1DuKhnI=;
	b=c4DYBT7X+hW+johB0v3s+z0ci/HUPxAWTRR1pehEHHbRlCT1pH/y9vTGjQ7Sfs1mX3IWQL
	ISct+c0G9jrD/d/O1Qp+kSsWykT8INXa4Ifez/finHUvBv76dvt6Vlc+z6rn4/O4LpOlEA
	AMijHP6PBMPCAMXOpWlbngYAYDqznrM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=BzvOXcJ3;
	spf=pass (imf14.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5A44F463D;
	Fri,  3 Jul 2026 04:59:43 -0700 (PDT)
Received: from [10.57.81.24] (unknown [10.57.81.24])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 990933F673;
	Fri,  3 Jul 2026 04:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783079987; bh=CtML3PEXn1LHht7AQdQyqLzB0Qb9Ae10yAgK67397Zw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BzvOXcJ33pukFW1hsXEQNbx9QPLsxIFvrmHevHBsOp8nnm06vLzF5mha44X2sHHDU
	 SHr/Zn3XgMMxalHNhRBDOI53sw4fZs97H12agiXgP0ix1sp+Z6e44T3eAOSbucjLm7
	 PcWgBN9O+acHfIv6mNNUdNha0fe7PMafRvzBoqR4=
Message-ID: <fa1f5b39-2703-40a1-81d6-3feba87e19b0@arm.com>
Date: Fri, 3 Jul 2026 13:59:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 01/18] seccomp: Convert __secure_computing() to return
 boolean
To: =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>,
 Mark Rutland <mark.rutland@arm.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Jinjie Ruan <ruanjinjie@huawei.com>,
 oleg@redhat.com, richard.henderson@linaro.org, mattst88@gmail.com,
 linmag7@gmail.com, linux@armlinux.org.uk, catalin.marinas@arm.com,
 will@kernel.org, kees@kernel.org, guoren@kernel.org, chenhuacai@kernel.org,
 kernel@xen0n.name, geert@linux-m68k.org, tsbogend@alpha.franken.de,
 James.Bottomley@hansenpartnership.com, deller@gmx.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, npiggin@gmail.com, chleroy@kernel.org, pjw@kernel.org,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, hca@linux.ibm.com,
 gor@linux.ibm.com, agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
 svens@linux.ibm.com, ysato@users.sourceforge.jp, dalias@libc.org,
 glaubitz@physik.fu-berlin.de, richard@nod.at,
 anton.ivanov@cambridgegreys.com, johannes@sipsolutions.net, luto@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 chris@zankel.net, jcmvbkbc@gmail.com, peterz@infradead.org,
 wad@chromium.org, thuth@redhat.com, ada.coupriediaz@arm.com,
 linusw@kernel.org, yeoreum.yun@arm.com, song@kernel.org,
 james.morse@arm.com, anshuman.khandual@arm.com, broonie@kernel.org,
 liqiang01@kylinos.cn, pengcan@kylinos.cn, ryan.roberts@arm.com,
 yangtiezhu@loongson.cn, sshegde@linux.ibm.com, mchauras@linux.ibm.com,
 austin.kim@lge.com, jchrist@linux.ibm.com, arnd@arndb.de,
 thomas.weissschuh@linutronix.de, sohil.mehta@intel.com,
 andrew.cooper3@citrix.com, jgross@suse.com, kas@kernel.org, x86@kernel.org,
 linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 linux-csky@vger.kernel.org, loongarch@lists.linux.dev,
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-sh@vger.kernel.org, linux-um@lists.infradead.org
References: <20260629130616.642022-1-ruanjinjie@huawei.com>
 <20260629130616.642022-2-ruanjinjie@huawei.com>
 <akdp6GAu77-ipsXA@kunlun.suse.cz> <87cxx4mmim.ffs@fw13>
 <akeIK5TRCjlKbzbp@J2N7QTR9R3> <akeOjqMy7HVgRRCr@kunlun.suse.cz>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <akeOjqMy7HVgRRCr@kunlun.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 42AE310000F
X-Stat-Signature: 65a9kuam3k8y1df7ya1wu3kueddesb6t
X-Rspam-User: 
X-HE-Tag: 1783079989-521682
X-HE-Meta: U2FsdGVkX19mTJn4qKfVf9sfKd52TxC+XPl8zb+JyWw8hhD6LuU6bGVyYiKEf1tuo4ipIqnZjo57Sgx4LJZZZh7RirTxCPYQYiBrKEH9pDjh3q47iyzzOcMTGeXNbphQa7mavZcDTWNZy3mpjUzHSA9YA/n1KMB/LY92orIVTnq4VWTJLzi2tAjQrut8XcEHsbEZIM8Odetr588pAVxm+gwAR6lNmOU2REHsjot0jA7v8y0OkemfSaXiO+6fOggXnlXLCc7eywhbT93ianucoVI91i2ke2voe3othxI2ji2ZAqS3YSAfXGXLjniKMpDZUgvWZEWUvAQkiOvQmWZXK1rUNTPWIjpAVcbLJJhFHjfJb2933OY/Se2z1avfIDbMYtqRe0JOwlJlLTkVINtFgC9eDkeYfb2gXcKMAcwF88fboJOjWteKFRTPpckqM/PV1XC19UE36UBMuk8k/ReX2g1WC2mnlvLJLKkcnXgzr37MnxDoqKGJOAcMr9DHuD5M7aVPp8VmEYZcClxUnVxjoQiwI2LMPkqK5ro+5QHRRPNCi3c+SSY8dSyd0dANZpTkbCAgJ12zqB2PMLrxS5QhdMw1uPumlMfTfGaYATyntDhEG3ALx9xnuAGORMgygwwjY4KucIxoDSgU/DAZkHhplbwnkaDiG3Ar+Jehg20+pfCPlsD1zTeDIjWhc+gFUdziECyjZ439D1scfb4cIA3SBQf0iIMS3Ws4AM38vC+n6rhJ4JhKw7jWtap2l5JEvefJ3chJqepGqkcBwab2Di1WcLrz9vWLrWBnJeNkhNE94lKn2GdwiF4ZWwVvGDVxRIha2FHHIOdabGU5V2Wp36keqnXdgnJzoWSZ26CyGDlJHII9RJRCNYNKFQopB45jyG+T4gOZyoB+TNGb52ncHmFGlb8VSgPQRSdEr7r+Oe62Pe6VyxqVKMo6GECzaMrlY7RRvyvEVRq3AZAyszXg/Wq
 PnakVBJs
 Bo28lj3PnYbwXtDI/0pRWoGvXEOmjx78XSZETltAOgk3fEo1+bXUyZamPzo6lmzsczalZg1ErpxfQd4V9wGwnRSbclAuxESC6upreFhTX623VY6xKSQv/Z4aFDeK1ouzuFhzGSibHeWRpTGc0R9YJeselmET/C5oHVicWGHzC9rBGfz4tMBOU0G/dWd9ccFL6KEHmXDPgw1bO+ggJ3JSdf4vx3TjAfP7lF/9rdVeNhSoH2lak2oy5F4KRah/iHZx6uXQ/kYQEqcWbeX26eaNNXmCMvsr+bNG0Y6FrpSBIynG/MZBb6DD8AJnjqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/07/2026 12:27, Michal Suchánek wrote:
> On Fri, Jul 03, 2026 at 11:00:11AM +0100, Mark Rutland wrote:
>> On Fri, Jul 03, 2026 at 11:48:49AM +0200, Thomas Gleixner wrote:
>>> On Fri, Jul 03 2026 at 09:51, Michal Suchánek wrote:
>>>> On Mon, Jun 29, 2026 at 09:05:59PM +0800, Jinjie Ruan wrote:
>>>>> -	if (secure_computing())
>>>>> +	if (!secure_computing())
>>>>>  		return -1;
>>>> Hello,
>>>>
>>>> I am not fond of this logic inversion. The boolean is meaningless in
>>>> itself.
>>>>
>>>> Previously -1 was used to indicate that the syscall was filtered but you
>>>> chose to invert the logic choosing true to mean syscall was not filtered.
>>>>
>>>> You could choose true to mean that syscall was fitered avoiding this
>>>> inversion.
>>> That's just wrong. Boolean logic makes more sense with having
>>> (!condition()). Just because the old 0/-1 nonsense had it the other way
>>> round does not mean it has to stay that way.
>> 100% agreed!
>>
>> Bikeshedding below; sorry.
>>
>> I think the bigger problem is just that secure_computing() is a terrible
>> name that does not express the intended semantic -- it's not clear
>> whether "secure computing" means "seccomp permit the syscall" or
>> "seccomp is enabled and some special rules now apply" or something else
>> entirely.
>>
>> If we're changing the return type, it might be worth renaming the
>> function something like:
>>
>> 	seccomp_permits_syscall()
> Then not only it is clear which way the boolean value should be
> interpreted, it also pervents the accidental inversion of existing
> calls. Overall great.

Totally agreed, if we have the opportunity to rename a completely
undescriptive function name like "secure_computing" we should take it.

- Kevin

