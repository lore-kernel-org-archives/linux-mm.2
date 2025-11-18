Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2272CED620
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 11:37:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A5136B002F; Tue, 18 Nov 2025 06:37:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57BCA6B00A0; Tue, 18 Nov 2025 06:37:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B93D6B00A1; Tue, 18 Nov 2025 06:37:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A10D6B002F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:37:10 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D6F40160528
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 11:37:09 +0000 (UTC)
X-FDA: 84123526578.15.D0D3337
Received: from mail-24416.protonmail.ch (mail-24416.protonmail.ch [109.224.244.16])
	by imf21.hostedemail.com (Postfix) with ESMTP id D16391C0006
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 11:37:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=A62qJ3HV;
	spf=pass (imf21.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.16 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763465828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DE/tg0nJoToaNRa0UqK6uA3/ue+ZalTDQdxOe/ZUB5I=;
	b=w8fNEmDPRBlGPSOD1Cm0guG6YVfHhTBCQ84984C7UHCYpwADLpLTQ05qfZYtgIARQqkJBl
	yl39HlMLVNsdnApP+bHlPiNBSaRPKB99/3aQG7pe99rSzlbVntIFd7x5dH9N9+r4RSrL9z
	CB+A2A52ln+FEUjkraNXjKEPYPtIsKA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763465828; a=rsa-sha256;
	cv=none;
	b=rlcDn6kmP/Nm/pJXLDX+rzvQtqVFsQ4pJw48zfy8lG5ep8KVxpZ1Fem5Oe2JydKeXu1c68
	HqvpuGJyFD/ascH4YFKhbAsbkGysTTKk8LBJ6nveueOIK7aM8Qgdi2q3gCmcpbPwLQBeeb
	AJR0MF+3sWu8ehnqhxdRnr+W6DoXaQQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=A62qJ3HV;
	spf=pass (imf21.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.16 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1763465822; x=1763725022;
	bh=DE/tg0nJoToaNRa0UqK6uA3/ue+ZalTDQdxOe/ZUB5I=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=A62qJ3HVc/QcFo3EtY8f3xbhHwUHHS73FKrm5NfXWUzkSzKMpPSlwVVOHMs992Ntn
	 TcokQ5u/tjEK627OMqjj1qaY5+gMYz7abk+5IQtsTR5DpJNASN32IN8GYdQFZXhy0a
	 smfh1qEFWDrtY7OlyebMVnAL+/VMy8ImKJ0FQo1No/NbT/jAQge7GNBbsmuIBua3Fk
	 PGJaIMpARX4R4JEW8jciC+zf0IJqnbjhtwItFaSaJl1JYRXvtNbWPPHsQf1MxD4yLR
	 TuRDUrxA0XL2uIIrSikjiLnz8S4JKgtyCgzLxEoQVqgZh5/J/YPxSzVSiUDoEzwexX
	 2rOnoL0lhYHzQ==
Date: Tue, 18 Nov 2025 11:36:54 +0000
To: Alexander Potapenko <glider@google.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com, ardb@kernel.org,
	Liam.Howlett@oracle.com, nicolas.schier@linux.dev, ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, rppt@kernel.org, will@kernel.org, luto@kernel.org, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH v6 14/18] x86: Minimal SLAB alignment
Message-ID: <wzxmteswfsj3idgwyai7m3ou7kulfmxerxkq56xfhoqhvpz3tq@omy5z7eb3esp>
In-Reply-To: <CAG_fn=W033hGM7_jnj0irwW0gc6McLw2nbhfZROWfieqKTxVdQ@mail.gmail.com>
References: <cover.1761763681.git.m.wieczorretman@pm.me> <0ca5d46e292e5074c119c7c58e6ec9901fb0ed73.1761763681.git.m.wieczorretman@pm.me> <CAG_fn=W033hGM7_jnj0irwW0gc6McLw2nbhfZROWfieqKTxVdQ@mail.gmail.com>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 91807d56d4653d1f85cedcda318ac58c40da2783
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: getnynmoadzjofkbwx63gjpqd5x4zokk
X-Rspam-User: 
X-Rspamd-Queue-Id: D16391C0006
X-Rspamd-Server: rspam01
X-HE-Tag: 1763465827-437991
X-HE-Meta: U2FsdGVkX1+Vr4sOBsafi4DKWGKkiecKgv1gEc1IYuhnxEb8/QpobHXV+zs7M6DwvGrkpHpiSUVz87IUYkTv9MSQptqYsmk9vOwmFSU06lEzN84hqDwhfrUIipt43AhsNfHQGMxz8cjlELIF3vRabF6nxTUUNiA0ABVM+rHa0d4PJTCucQLORN2ZjdbU0H7u9rq8kvoz4EpRhV0vXzHTdBWYDwMmfMj+G7P0+PVdK8YMg3rykhp0ijv/2Qhke+hlO7K+mMqU6d3v8yhpoPoNjY6vVGsy3MUYHVlRAvDpLhJuQoDbbOIDpXkgNsb7hI8rKIwN4uzXqmOGs26xWyP4X9lORc8L2wxwHI6cWdpDBJcgVMYCkteP8oPOygABefR6lQLFAdSP9J+FS4cMUy1U5cUYqHCQqCCcdJaCMYiIZRIUprL8IJlwbehhQjW+jDZKM6RAw4bXbUaH30i1WXxWE3Rog4esnTh4V3dloOqQxxmYL/pSQ6/Hbg4K+BTE8ygLjuOphIVojcE5tJgIYGNb3NnGpjl7ctzl8k01zekUimxqGbmGp1nBJKh3r511ft41P5s7y1kyp3K/NNm8HiP0/EnAbJcSH4k8KmxRxdYhbbKUKfRzPfxWFrSdmhClTpRUTny8AGHUUT5uQDZMp/W7LDq8OSJ/TIrocAiWS/BKscQurHCP0E+Bn9wqj8uJrvQwutpAEmYocSHFTrhHxjz6FAO15knzrHTBTm/hwHfQfEvHNyKRwDPH8MFLbW63+lVJDJt4vVu6N217JIM8USWjfzkFUYHFuwyKxYe7/FskaqaTcTI/2dwD7/4nJq+A+haIMrXtKRgwDS+O838NXVuQibQGD3bBtixvJyZsjVf/DkTK9RLzsfU6CQfGUkK4b1xCevEGBf50n4rLt0PLOqUGeynRQb5e2Vv8uQAV0vjjP1JqlgbZii+1CJeVGmqRiK6dpSopaQ5utWNy/i3OPNQ
 K5r2Z/Ie
 flbxY9SfOLoStwgT5k70Mc1tXC+arIcpCZkanU9uYNhEaoiPNbtTPpZdY+LUiUINC54MofjPIHvtJfgimIZ8HUOEr66v8NFWxbmIN5b2wrj8ek41tJHX5eVa/+TmJQ3YIcQLLVc/SVr6Zdp47dt56mWLEO3CfAmEfhv0NBQYCWUDTB7pBMIhKkDjpaEuxjFYHbPri4g7dKzKWm0+8wMl/9/tTErID0sZsnhQdg44CjugNz5a+BJiZB0zefkU8dOxPjf4IdZJt5zFVUZX11EHoMb6HLctqXCtoE09e
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-10 at 18:48:35 +0100, Alexander Potapenko wrote:
>> diff --git a/arch/x86/include/asm/cache.h b/arch/x86/include/asm/cache.h
>> index 69404eae9983..3232583b5487 100644
>> --- a/arch/x86/include/asm/cache.h
>> +++ b/arch/x86/include/asm/cache.h
>> @@ -21,4 +21,8 @@
>>  #endif
>>  #endif
>>
>> +#ifdef CONFIG_KASAN_SW_TAGS
>> +#define ARCH_SLAB_MINALIGN (1ULL << KASAN_SHADOW_SCALE_SHIFT)
>
>I don't think linux/linkage.h (the only header included here) defines
>KASAN_SHADOW_SCALE_SHIFT, does it?

I revised all the x86 and non-arch places where ARCH_SLAB_MINALIGN is used =
and
all these places also include linux/slab.h which does include
KASAN_SHADOW_SCALE_SHIFT. So there are no cases where it's undefined.

The minalign makes sense defined here but including kasan headers causes
compilation errors all over the place. And I don't think moving
KASAN_SHADOW_SCALE_SHIFT here makes much sense?


