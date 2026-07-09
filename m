Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 680C3C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 06:33:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39C4E6B008C; Thu,  9 Jul 2026 02:33:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34CE36B0092; Thu,  9 Jul 2026 02:33:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23AF66B0093; Thu,  9 Jul 2026 02:33:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D887B6B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:33:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 62AD31403D2
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:33:57 +0000 (UTC)
X-FDA: 84968272914.06.0902EB7
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5E5A580005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:33:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=d7cujAJN;
	spf=pass (imf30.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783578835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ym4eiUCAjK2DhrxFwWA5wga0jDmwedhuhpvWHZWLYYk=;
	b=sRw7BuIs6ItB3Iuwz1foBXkPXG0rGXeAtiLrzSM3DTPjK7vIbMOY9VRD0PkYO+Caxt2+7T
	cBFRcHZsrasXmiKDhJAxyawb3/muvdZ4qO9NenB8MFZYx98IOblbehnh6Y9vsnNxxXWTBo
	VIj2NkQ5HrhUCWKkeGW8gkSg/Bp7+Jk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=d7cujAJN;
	spf=pass (imf30.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783578835;
	b=Vk513n6xLimwFt5dPACAAkc5O5vXC+Ftsty877rdBSOkJAqC8cmWrXcIqQgapLBiKW48on
	fA4DXqMWl67A66/Jpcarc5cSC8dS8zzsU38qb1hzJIgtcf9Ef6aC4ETiJoGWkSeMSgynOr
	4HCEbBqHIUltHXsUyfmnkNw+KFYdPes=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ym4eiUCAjK2DhrxFwWA5wga0jDmwedhuhpvWHZWLYYk=;
	b=d7cujAJNGo5jnZFiP+W6SrCeNzRmHvUDNU5CNjySnsbZpXbkM4EkSHiThUvpyyyNIzg9gSeOx
	qUvtVpJRBUtRoWCi9MuMhRGlSwPGZftJR9R52n57KmOeVeychMXwFaniTMFisavWqKH7xbcd3Rk
	EqkVcI2HEL9A9LS9jTmoaPk=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gwlL52D2bzKm7T;
	Thu,  9 Jul 2026 14:24:29 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 5E9894048B;
	Thu,  9 Jul 2026 14:33:46 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 dggpemf500011.china.huawei.com (7.185.36.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 9 Jul 2026 14:33:42 +0800
Message-ID: <933879ec-3d41-4ed3-a0e6-e26144540f90@huawei.com>
Date: Thu, 9 Jul 2026 14:33:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 18/18] arm64: vdso: Expose sigreturn address on vdso
 to the kernel
To: Ada Couprie Diaz <ada.coupriediaz@arm.com>, <kevin.brodsky@arm.com>
CC: <oleg@redhat.com>, <richard.henderson@linaro.org>, <mattst88@gmail.com>,
	<linmag7@gmail.com>, <linux@armlinux.org.uk>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <kees@kernel.org>, <guoren@kernel.org>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <geert@linux-m68k.org>,
	<tsbogend@alpha.franken.de>, <James.Bottomley@HansenPartnership.com>,
	<deller@gmx.de>, <maddy@linux.ibm.com>, <mpe@ellerman.id.au>,
	<npiggin@gmail.com>, <chleroy@kernel.org>, <pjw@kernel.org>,
	<palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <alex@ghiti.fr>,
	<hca@linux.ibm.com>, <gor@linux.ibm.com>, <agordeev@linux.ibm.com>,
	<borntraeger@linux.ibm.com>, <svens@linux.ibm.com>,
	<ysato@users.sourceforge.jp>, <dalias@libc.org>,
	<glaubitz@physik.fu-berlin.de>, <richard@nod.at>,
	<anton.ivanov@cambridgegreys.com>, <johannes@sipsolutions.net>,
	<luto@kernel.org>, <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <chris@zankel.net>,
	<jcmvbkbc@gmail.com>, <peterz@infradead.org>, <wad@chromium.org>,
	<thuth@redhat.com>, <mark.rutland@arm.com>, <linusw@kernel.org>,
	<yeoreum.yun@arm.com>, <song@kernel.org>, <james.morse@arm.com>,
	<anshuman.khandual@arm.com>, <broonie@kernel.org>, <liqiang01@kylinos.cn>,
	<pengcan@kylinos.cn>, <ryan.roberts@arm.com>, <yangtiezhu@loongson.cn>,
	<sshegde@linux.ibm.com>, <mchauras@linux.ibm.com>, <austin.kim@lge.com>,
	<jchrist@linux.ibm.com>, <arnd@arndb.de>, <thomas.weissschuh@linutronix.de>,
	<sohil.mehta@intel.com>, <andrew.cooper3@citrix.com>, <jgross@suse.com>,
	<kas@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>
References: <20260629130616.642022-1-ruanjinjie@huawei.com>
 <20260629130616.642022-19-ruanjinjie@huawei.com>
 <7dedbe2c-09d9-4d5b-8b70-1977cf526675@arm.com>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <7dedbe2c-09d9-4d5b-8b70-1977cf526675@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.109.254]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5E5A580005
X-Stat-Signature: x3dkhzr87g4bpaou88its5w1eme8psno
X-HE-Tag: 1783578832-257622
X-HE-Meta: U2FsdGVkX19aCL0IZUGACSb3jVqKFvKXcL2d7Pd33CqGEH1V/QLIdq/Lkz5YDlRytP/24WLvpFGUlf2zvijTQKCtrkpfdCjdICmO9zKk2Gh7GVlEIwKrKa6TSiRvvWnUwvWsI2cv3mIbT7dwwGOXfpAcSyg6LnZTjSk9xOwvoRQlCg9/lbjfUk9o1lMQ1BlyQAGe6sMaxvs9K73rIekELcTCArOIaJnqd1aIF80wTPMkBlmpdrgawC3BnqqA69cMDEKGtbNpsq0Kpcp8MAau+rYzmotu2NvumbLs3TV+Tt27fTgLZ8ge4eFth7UcZE/EKf6V9FcxTKVBwJKFkonhxZiiw65t/3iVJ/Px8Z+N46zNwzZkDAMIUuHhX69JSYT9O4B9sBfbuPrpO5sjpkAfI7f3qLgSRx3eNB4+c2I6CKEUMAqW0jHuoaCBCcvx7GPqrGH+1+QJf8FwtkPoxzP9u7K7z7TAyyw0RiGFq1W5ydt8EefejH4z2aSNo4FDSRHhP4DPBREffVYeRKBGhmfrivfm1Uam2FuEm5ZlGWiYLNAD8zzd1cCgWRZu54kNaHxiSV6cBvJyWIYNN6AR+eV7evsw2CvuvSRPx3olD8hkn4gU7ysAcL2C3mQjt5Kg7rKDW9I3RipC0MylXO5DKiDTOVUHfSwUd82qRI1mwVwCEKpkaFU8f1UI2jeQC/rVhxAF9EsS5lzECFXzyZHbusBExIVJ1Z6uimjkO3dH4ApUXOeaEcyPNXPyfhSW4rQ3g7zV1UZzqZXaWri+JHX6skBG3Maf4jEhrScGv7VDzvNl0VBYpLFz4D9P0OOKSRIVzkKpEJr1l/d3I2u7bHJiNuAHX9NN9995kKBRxoHjIzTdhuuKlwoR7OhZ2eEhkQ4X+a846hE0SIi7zhAukcRjt75FlabxbPJ62VJGac9OgGYQJwWyPX5JvKLCQRCizGrg7B8MAA/MOUu1hjY7ydQkADF
 t0sxrmJP
 2kAopLW02Q0Z0bb/4HoDv0LOG3soN6lS/GL31k3R9GffNuICLDwSDNac2nN365DERoO8iYSAl8nsQjZbge8SRGCJLvLsqNkdE1HHF5C3871TZPPDH3iP5KruKweCzWYA4PB50JxY8j+GoGADg+PDs296I2JB5M6gMBsXfsvxuJIwm+uc+3IpZe1u8KO2NVk1khUMNztOrON5qrpgZ3maNuXIWu48YdPxGvxKlMOxpKEy1wZCLfy3qY/ppBwLIUo6w3h1czdRi9HSvGWPCbb4NX1kShw5rvXdqLJEH8ds7wTO6PeXtqVpqNF8+IMwamlzxu/19H25brj/zvCocAv7TYhQj5kvqFiwR0lfOjPf+yxFrHLi9bwSdxIbO8wQd8TvFYD2yJ3ZBgj/aSDszIbPEvgCvqQUSqbT+0oQfttR9cKVZ+Ed+fYuLhfzyWGOFzwgdv+jpS6+Qm5sI0jM272X83w4ne0mJx31xNxgKRdbhmRRw4N0ONFIOLCFkbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/30/2026 11:14 PM, Ada Couprie Diaz wrote:
> Hi Jinjie,
> 
> On 29/06/2026 14:06, Jinjie Ruan wrote:
> 
>> Syscall User Dispatch (SUD) requires the signal trampoline code to not be
>> intercepted. This is necessary to support returning with a locked
>> selector
>> while avoiding infinite recursion back into the signal handler.
> 
> Thanks for splitting this out, I find it is much clearer that way !
> 
> However, this should definitely be earlier in the series
> As I mentioned in my comment in v15, Syscall User Dispatch only depends
> on `CONFIG_GENERIC_ENTRY`, so enabling generic entry for arm64 in patch 16
> also enables Syscall User Dispatch.
> 
> Given that this series adds a weak default function returning false for
> `arch_syscall_is_vdso_sigreturn()` before enabling generic entry for arm64
> in patch 16,  patch 16 and 17 have a potentially broken SUD enabled,
> as we do not check for those sigreturns yet.
> 
> I think shuffling this patch back just before converting to generic entry
> should be OK !

As Mark suggested, we can decouple the generic entry and
syscall_user_dispatch features. First, we can focus on switching to the
generic entry, and then implement syscall_user_dispatch.

> 
>>
>> Implement arch_syscall_is_vdso_sigreturn() for arm64 to support this
>> exclusion mechanism. For native 64-bit tasks, it checks whether the
>> current
>> PC matches the 'svc #0' instruction inside the vDSO sigreturn trampoline.
>>
>>     SYM_CODE_START(__kernel_rt_sigreturn)
>>             mov     x8, #__NR_rt_sigreturn
>>             svc     #0
>>     SYM_CODE_END(__kernel_rt_sigreturn)
> Maybe add `arch/arm64/kernel/vdso/sigreturn.S` to mention where
> this snippet comes from ?
>>
>> For COMPAT tasks, it verifies if the instruction falls within
>> the architecture's 'sigpage' range, allowing the kernel to safely bypass
>> dispatching syscalls originating from these areas back to userspace.
> I think this might benefit from a bit more details or clarity on the "why"
> of the COMPAT handling : there is a vDSO page for COMPAT tasks, but
> COMPAT signal handlers have their own dedicated page, `sigpage`,
> which serves the same purpose and is handled similarly, so it needs
> to be checked as well.
> 
> Hopefully that is correct... Would you find that relevant information to
> add ?
> Pinging @Kevin Brodsky on that as well.

Thank you for the review. The related information needs
to be improved.

> 
>> Suggested-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> Suggested-by: kemal <kmal@cock.li>
>> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
>> ---
>>   arch/arm64/include/asm/elf.h |  1 +
>>   arch/arm64/kernel/vdso.c     | 16 ++++++++++++++++
>>   2 files changed, 17 insertions(+)
> 
> Otherwise this looks good to me, great to have more context with the
> change !
> 
> Thanks,
> Ada
> 
> 


