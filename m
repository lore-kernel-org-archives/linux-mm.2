Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3A57C982D9
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:37:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDDDB6B008A; Fri, 18 Sep 2026 06:37:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8EB76B0095; Fri, 18 Sep 2026 06:37:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA3796B0096; Fri, 18 Sep 2026 06:37:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BD0CE6B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:37:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 49815120627
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:37:02 +0000 (UTC)
X-FDA: 85226530284.10.A5645C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id B6566140003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:37:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q42qAzt7;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789727820;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lw9zS0Z5XTShZWdFIGichHAPl+WNOp2mTX9Vx2b9uGM=;
	b=f9gjTluMCWdeRf7AHWnBBs+cEJhmCd2uNPyp3iAORR4dgd9b9w4KW9XqnCeMipplzEIzGq
	V4d6kqm5RB2fCU55YLfBJzl9taKnciZi5Ox6vhG6Ttu3lf06td+BGF/BPpcWdzTQDqPsr0
	x1/kyUmeJDDpryDcLhg5/deqjE1KtUI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789727820;
	b=6IGk9OVw+54qEQjsMxAN7J9Czz5ZBbVzd23fRdowDfUYV5RF2irGw+QXQKryd31FtoPkxq
	o74Yjx3IEGd19eTFZ3pj9h/8mXgjU+edR3pBRO2hROASZu2pI7EEyth3FKxRXZxuHQjUbx
	yAaxfbhnGMEiXWQtCvbI3Cy9mchgDE8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q42qAzt7;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 376A760A65;
	Fri, 18 Sep 2026 10:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC341F000FF;
	Fri, 18 Sep 2026 10:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789727819;
	bh=Lw9zS0Z5XTShZWdFIGichHAPl+WNOp2mTX9Vx2b9uGM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Q42qAzt7wO+OFo6NAoDwEE1MDA4cRI3i/Jy/Qfuq0/wpgUimD8W/1lqVrecho7Kou
	 WabJVL20LNw0REudcaOdeeb+T4PExYxgh/OrdVdLoMnod1bxNeVKjrL//TlXvOHr0x
	 uQHhG+p4fnpTaLGkuKPKt0lF/tSHSWpnsQUDz0yCQ6i6NLviOmP5AwbmF7hifJoymO
	 a/dj9wKcgweN0UsrgQ7dl0KBXGcJZvkPwCfEnGRPKB6PFdnVB0tUKh1QamLTWNKEsV
	 B4ughp0yGBPUNdq905IDJDtq0MYVx2RWuc4ruH3JiWRRurjm5VB3sZIQTW+1rluU58
	 6VzR/lgTAk56Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 17/17] arm64: crash: Add crash hotplug support
Reply-To: sashiko-reviews@lists.linux.dev
To: tglx@kernel.org, ritesh.list@gmail.com, mark.rutland@arm.com, chao.gao@intel.com, kas@kernel.org, linuxppc-dev@lists.ozlabs.org, yeoreum.yun@arm.com, x86@kernel.org, baoquan.he@linux.dev, hbathini@linux.ibm.com, sourabhjain@linux.ibm.com, linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, jbouron@amazon.com, dave.hansen@linux.intel.com, rafael@kernel.org, coxu@redhat.com, akpm@linux-foundation.org, gshan@redhat.com, vishal.l.verma@intel.com, ruirui.yang@linux.dev, seanjc@google.com, bgwin@google.com, "Jinjie
 Ruan" <ruanjinjie@huawei.com>, chenhuacai@kernel.org, pasha.tatashin@soleen.com, kees@kernel.org, me@linux.beauty, npiggin@gmail.com, maddy@linux.ibm.com, ruanjinjie@huawei.com, thuth@redhat.com, graf@amazon.com, palmer@rivosinc.com, chleroy@kernel.org, guodongtai@kylinos.cn, zhangtianyang@loongson.cn, eric.devolder@oracle.com, catalin.marinas@arm.com, leitao@debian.org, driver-core@lists.linux.dev, piliu@redhat.com, kernel@xen0n.name, dakr@kernel.org, pratyush@kernel.org, sshegde@linux.ibm.com, tangyouling@kylinos.cn, adityag@linux.ibm.com, rppt@kernel.org, mclapinski@google.com, takahiro.akashi@linaro.org, linux-arm-kernel@lists.infradead.org, will@kernel.org, ardb@kernel.org, gregkh@linuxfoundation.org, lizhengyu3@huawei.com, linux-mm@kvack.org, james.morse@arm.com, linux-fsdevel@vger.kernel.org, mpe@ellerman.id.au, mingo@redhat.com, bp@alien8.de, blum@kernel.org, robh@kernel.org, hpa@zytor.com, liukexin@kylinos.cn, maqianga@uniontech.com
Cc: kexec@lists.infradead.org
In-Reply-To: <20260918100442.3841135-18-ruanjinjie@huawei.com>
References: <20260918100442.3841135-1-ruanjinjie@huawei.com>
 <20260918100442.3841135-18-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 10:36:56 +0000
Message-Id: <20260918103657.0CC341F000FF@smtp.kernel.org>
X-Stat-Signature: iqf7n9rpnugmcck5w9x8f448ijwcbcee
X-Rspam-User: 
X-Rspamd-Queue-Id: B6566140003
X-Rspamd-Server: rspam03
X-HE-Tag: 1789727820-145839
X-HE-Meta: U2FsdGVkX1+Nx0u7OTYd2c3E+W/+jscGNlH89zxZaY2didM3lh5JkBE1T02HVX2FJ+CrsLumuYUA2pZs3pYa94ZXMbxiityu3jbZ5MM25pmKr8hBU4CNRGn07A5jRQbtuS50Qn4onsgz5KY3feNOV4VluQJHMXO53EOKRGHJIJGgMZc+cmJGhimx40L32urMoJ2SxOkkvkrl+J3wOp+Zu2D/wzo2zVdjjKMbZ7CG+DPOnF7/+20HRofGTzaEDmYAe4iY8bqeX8LUJSUnFdwdmhzi4sYYHRKNwF7+2iHHlTK3BSWJz8lyCuAI9rheicYb5RC1r7N7Suznbgx5g+VhtJUsyLS//tJrnGig/pEcUdU0clekRFgdo0Xm4+Au72bLbmZsGLuvIwpvq08EeT1k7RhyLMU25jp6JDB5880X3kJVVbMwmbDQ/FCT0pzYwnynp9AaqvYSE4vb4VxvXQ3kuIsvJW6uPse+sFP5Yyo6kYaxg2LOhfT02CM2ty9HGBkBCiPS73cQoqXqmGl/qxQLENDXLi1oHv3CzLudlpmFgEvkTS1fTX7259P/na4i5Uqog57x0HVMRLJ0xSBRQZxbtCh9hjkPc2kC+4wd1jcYmTXz9CL9fiOYBmLury4zRBd6+62hzRT+9QzGqOf8z0iZf4Jt0x80E0aN3ZZGGHRgTe9FJayLo9J39oWzNk+ZJfHcSRIrFX5zBVONKNoVp0m3qhmh/h/QoaP4+cOvQXWIejmMiol9f7gXP1RCgYJquyfLGPMJWBR/+acviLrTRJHOMgNcqioclALUmog1TyjaV1GzNWwdI0EJlHtlGW7XBfFafhSk2hoza+mbdn0HaisgtdzcLjDNZ7EkD3AndFQ7nW/e3wcOaJ3rHrPHkAk0kz1SJL0I3xomZVOSMxz8YhpF/cgg57TxMtdrtyqAE8KCRHBZgl+/wRTkhDEBXV56+4yBxKy956smfv6EpFZpdqq
 4Yn6ZR83
 D3KqioudEIDioXaEHzY8gT8C5wiTb6TOniS/poHdEy5can1mRULFe5dn1YmFgVWPuUjslz7mwd0gnmI3sdrnTUtXC5Hqp2h2CnnsLA7wjSJWUkUr/mWdodPK+sVmVkn7Jd+FkdYMGV7BvwQsGlB0nStulE1iWH51Irte/OUYMpz0CH1vqNZO3K/FS3Z1vUznlGF63d2rjDp+2BS3oM2WXLx3JT6cBI8J975fGPxAh/TMOrJNR1/NqhLdJGP9uuqeKOrSolVWGqHB96I2bdBpfc2HIgwGbvF9nsZopvT2KO1mihqFWhnXHKADrKZpOL9dfe5lIqePN1JZPLNMTAE7ZY+WOIwqH9DDtt/Q6L4LEc8XVZQeoUIEPj0Yvq2ewgSLg+tvlNSCyDtHDJfr3wsPKygM7n/Rw0e5IvpUYqxSNpDCbcbPDZJr+YsRMKH/msEx3QIWSqKrPGwV+r8xSEQ64wkKkZV/cHbUYcg2i2X1CacJnqn3mAqkSxph7JAl9o9N2LKxVC31wYp2j7n0KmWtDeEjMPfWuhxga9IQSgYvsinbW2Zf88uHrZEHOdioHx91XBuwjZx08BmO9AHCtghAW4u5a0I18kfFUWKNHDCbh209iyAfb9qdv/GX7ulkw/OrFGosW9M4Bw5aZO/yJsRlRFBtjCXOTFU5qsDJUDnnF460q1ldsLGGmlprsbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] kexec: arch_crash_get_elfcorehdr_size() exports undersized buffer =
when MEMORY_HOTPLUG is disabled
--

commit fd293f9cfd1a12554d9352f4ad58fc9f85721fa3
Author: Jinjie Ruan <ruanjinjie@huawei.com>
arm64: crash: Add crash hotplug support

This commit introduces kernel mechanisms to update only the elfcorehdr
on memory hotplug events for arm64. It adds ARCH_SUPPORTS_CRASH_HOTPLUG=20
and implements arch-specific functions to handle memory hotplug, avoiding
full kdump image reloads from userspace.

Link: https://lore.kernel.org/all/20240529133446.28446-1-Jonathan.Cameron@h=
uawei.com/

> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index b5a51b0ef9440..96de2660b1cbb 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -1720,6 +1720,9 @@ config ARCH_DEFAULT_CRASH_DUMP
>  config ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
>  	def_bool CRASH_RESERVE
> =20
> +config ARCH_SUPPORTS_CRASH_HOTPLUG
> +	def_bool y
> +

[Severity: High]
Does unconditionally enabling ARCH_SUPPORTS_CRASH_HOTPLUG here expose an
undersized buffer to userspace when CONFIG_MEMORY_HOTPLUG is disabled?

Since CONFIG_HOTPLUG_CPU natively selects CONFIG_CRASH_HOTPLUG on
architectures that support it, having this default to 'y' allows
CRASH_HOTPLUG to be active even without MEMORY_HOTPLUG. This leads to the
size calculation issue below.

[ ... ]
> diff --git a/arch/arm64/kernel/crash.c b/arch/arm64/kernel/crash.c
> new file mode 100644
> index 0000000000000..08dc9b952498e
> --- /dev/null
> +++ b/arch/arm64/kernel/crash.c
[ ... ]
> +unsigned int arch_crash_get_elfcorehdr_size(void)
> +{
> +	unsigned long phdr_cnt;
> +
> +	/* A program header for possible CPUs, vmcoreinfo and kernel_map */
> +	phdr_cnt =3D 2 + num_possible_cpus();
> +	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
> +		phdr_cnt +=3D CONFIG_CRASH_MAX_MEMORY_RANGES;
> +

[Severity: High]
Is this calculation missing the static memory ranges when
CONFIG_MEMORY_HOTPLUG is disabled?

If compiled with CONFIG_HOTPLUG_CPU=3Dy (which natively selects
CONFIG_CRASH_HOTPLUG) and CONFIG_MEMORY_HOTPLUG=3Dn, phdr_cnt is computed as
exactly 2 + num_possible_cpus(). This does not account for the mandatory
memblock ranges from arch_get_system_nr_ranges().=20

Unlike x86 or powerpc which might survive this due to heavily padded
CONFIG_NR_CPUS_DEFAULT values, arm64's precise num_possible_cpus() leaves
zero headroom. As a result, the exported maximum elfcorehdr size is strictly
smaller than the required size to hold static memory ranges, and any attempt
to arm kdump (kexec -p) will fail because kexec-tools cannot load the crash
kernel into the undersized segment.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918100442.3841=
135-1-ruanjinjie@huawei.com?part=3D17

