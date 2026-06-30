Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2227C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 15:14:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93B0B6B00AE; Tue, 30 Jun 2026 11:14:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EB776B00B6; Tue, 30 Jun 2026 11:14:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B4A86B00B9; Tue, 30 Jun 2026 11:14:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 54ADF6B00AE
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:14:31 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D27B4168143
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:14:30 +0000 (UTC)
X-FDA: 84936925500.16.74DB82F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 932E140005
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:14:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rBelcefg;
	spf=pass (imf11.hostedemail.com: domain of ada.coupriediaz@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ada.coupriediaz@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782832469;
	b=z4413JMHBjNL96EUEMrftW5lVxOBzXso7TcI9Rzew0Zw+p1/XJasCUL4dgi7k8Sw7ITTOP
	Ht9goaPD9QiQgCMGQQ39G3KHFVgwm0iDqD0O+zjI9fsBey2YkMok6ENcWZEX/chteW6I50
	zVnwEvnyJMK8Xwg4p/bAm5CIM+mIh5o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782832469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ucS4ebDI2j4bO1fUALMmV7MUhoPr2jiJW6R/TQevAbA=;
	b=bxrz3//p55WLX4Ueo2BJTcxv4rUVq2upDEop6TUylSPMXc0/fdJW1FC1xKxNzBVl8EwD4t
	+4f9AUjTTK1tjmLAIdn3w5avSENYXRoijOeXJh50weSy9v5hZ6+bJhZp97L3N2pmBZGNQD
	WtWM2JnBJzAEGP+faveNRXWASwiMRNQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rBelcefg;
	spf=pass (imf11.hostedemail.com: domain of ada.coupriediaz@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ada.coupriediaz@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 083E02ED2;
	Tue, 30 Jun 2026 08:14:23 -0700 (PDT)
Received: from [10.2.213.21] (e137867.arm.com [10.2.213.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A1E603F66F;
	Tue, 30 Jun 2026 08:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782832467; bh=9xr72TE+igvLVlNPFv4xah9LNvL/PNLDVngoXViM8xA=;
	h=Date:Subject:To:References:From:Cc:In-Reply-To:From;
	b=rBelcefghtcBpRKZUtImOBOvZpcpzuS66Tdd9PtWjH1lndhmKvXc5oRUJnVvzYSLi
	 kUWFuS08wtKxVHnqnfcNbzXSNYrA86n3SBraqSsgsolS2NfrxBB54e2Pq+31suSTHG
	 4RM5sxZ9cWKEA9YxYOaYTctt7dUPMUTWUkQK+Mec=
Message-ID: <7dedbe2c-09d9-4d5b-8b70-1977cf526675@arm.com>
Date: Tue, 30 Jun 2026 16:14:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 18/18] arm64: vdso: Expose sigreturn address on vdso
 to the kernel
To: Jinjie Ruan <ruanjinjie@huawei.com>, kevin.brodsky@arm.com
References: <20260629130616.642022-1-ruanjinjie@huawei.com>
 <20260629130616.642022-19-ruanjinjie@huawei.com>
From: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Cc: Ada Couprie Diaz <ada.coupriediaz@arm.com>, oleg@redhat.com,
 richard.henderson@linaro.org, mattst88@gmail.com, linmag7@gmail.com,
 linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org,
 kees@kernel.org, guoren@kernel.org, chenhuacai@kernel.org,
 kernel@xen0n.name, geert@linux-m68k.org, tsbogend@alpha.franken.de,
 James.Bottomley@HansenPartnership.com, deller@gmx.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, npiggin@gmail.com, chleroy@kernel.org, pjw@kernel.org,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, hca@linux.ibm.com,
 gor@linux.ibm.com, agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
 svens@linux.ibm.com, ysato@users.sourceforge.jp, dalias@libc.org,
 glaubitz@physik.fu-berlin.de, richard@nod.at,
 anton.ivanov@cambridgegreys.com, johannes@sipsolutions.net, luto@kernel.org,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, chris@zankel.net,
 jcmvbkbc@gmail.com, peterz@infradead.org, wad@chromium.org,
 thuth@redhat.com, mark.rutland@arm.com, linusw@kernel.org,
 yeoreum.yun@arm.com, song@kernel.org, james.morse@arm.com,
 anshuman.khandual@arm.com, broonie@kernel.org, liqiang01@kylinos.cn,
 pengcan@kylinos.cn, ryan.roberts@arm.com, yangtiezhu@loongson.cn,
 sshegde@linux.ibm.com, mchauras@linux.ibm.com, austin.kim@lge.com,
 jchrist@linux.ibm.com, arnd@arndb.de, thomas.weissschuh@linutronix.de,
 sohil.mehta@intel.com, andrew.cooper3@citrix.com, jgross@suse.com,
 kas@kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Language: en-US, en-GB, fr
Organization: Arm Ltd.
In-Reply-To: <20260629130616.642022-19-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6jqwrb3n5n8tjd9g5qdppbei1b3b5eca
X-Rspam-User: 
X-Rspamd-Queue-Id: 932E140005
X-Rspamd-Server: rspam02
X-HE-Tag: 1782832468-379458
X-HE-Meta: U2FsdGVkX1/tV5K4dqRJDqjIn0k6GLSPpJXmOLWOCr/Wi+ryMLEhCASgjIN8eK0HY6yyp47NOE/tZXMv/XxbskRZ0Z8M4nGZvPnaPhrAmOPkBY+G38kRRTAvcziH31btETTQ8gVUpGz70/TKEqmW/6nJYB9zwmLE5wcIYM5xLCP2mlOvebvAG8y/8ykA+PV/UZdsz0hfbebyKJL8iqgsnGscjAElLkpnw+ZwxCXeTbFc5wuTBQjEaJWhFE+udDkv+aJj2PNaUVdCywIddQ6xhsW9WXqLdOVC2kfoEu08vSosJdOthDHvjcfOdhCs9ht1oEWcxUHi12nruudCnoc+voRaW3q3nMEuw+Rt+cu0gH6WhNK94MdMAGnN+oPs4NP+8vdddeGvBRRv7TuvtmO3nrHm2QAjFHRt7KycudYPWL8ldIkiD8D1qODqAHs3WAONOMpyHmXSmTcTlzUhRWLxN0BXTNkunaI2Qw3MVE6jxiU4nXAC4mI180ZGYBOWOkV4fgPhdYeH+68T360dcYdNheMfRxI/Pe+vbL8i7Z1Z8HalTTuit59Ip3XO8n5C6npkFqGSGcG/j4HxVzJTHRHPNqC/cowo+cyVGHcdl3ABrHtBe8EeElbd4Why4Pc0ldnuZPe059z+JYt5I3/SdMsXM/NwtfidxSv0aM3KXYJfshCSMEErqDPRbvFdJ71a/IREnpO5lttEr+m0ki/ODdqRIzkM4qj264Tn19qVvFOjjajBfyHslhGCRyIMRBz4DSCyGeEhlfiWSW5khnZ8sy8RrfOCxH+K3BgFrXuPz2unq5Xdw3ge4cf4AF78N5FqdC7iewFf69jAOSW5UVAcYPR4ev+UDoNXYVyG86Jq6BJErEZHln49gYp1kDUu6DqwKAOwQmqZuYedld3nB5q9dBiHEWCJ0BrGq8TaCI3idYFWtsxh+T3iIuDe7kzy3sz/4cQ4ZIcs+6xNDnSQEoh5Yoa
 Rb7VdbrV
 Vtkwo0OT+p38z0pzibdl9PDItcTRtdKy5H6HeCQm6favWyY0vEf7eFVmPhLXvFJFoBqZl4RF6POnJtYX8fezjgsYKgtGNO4N3loQSuhwu1fzdWwl0fu/Q/DSM/9cSSqCVPsYP1ap9Gkq1+u0VmRqGGu5C8TwAs2nxDN0EtHre3vfpm8oGEItuqyAnrMcQTU4dvLoeaUE/KjilHPBSobzXmUvsIXu3fs4QEBaFEJu2xjSFZBEc3lH0Roq8PNU/mkjE3YdgRWnao0amEhx6ymZVSFtPna6Immc3P6HWmwOQ5OiofdtBQO0PAxVSS/oiAM0idrzDpXFhUrMhmOBPiZGGliClZIxwVJySLcrnMkcbWN/Ac2vjxKDpstfUa61nWsXPkzAX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jinjie,

On 29/06/2026 14:06, Jinjie Ruan wrote:

> Syscall User Dispatch (SUD) requires the signal trampoline code to not be
> intercepted. This is necessary to support returning with a locked selector
> while avoiding infinite recursion back into the signal handler.

Thanks for splitting this out, I find it is much clearer that way !

However, this should definitely be earlier in the series
As I mentioned in my comment in v15, Syscall User Dispatch only depends
on `CONFIG_GENERIC_ENTRY`, so enabling generic entry for arm64 in patch 16
also enables Syscall User Dispatch.

Given that this series adds a weak default function returning false for
`arch_syscall_is_vdso_sigreturn()` before enabling generic entry for arm64
in patch 16,  patch 16 and 17 have a potentially broken SUD enabled,
as we do not check for those sigreturns yet.

I think shuffling this patch back just before converting to generic entry
should be OK !

>
> Implement arch_syscall_is_vdso_sigreturn() for arm64 to support this
> exclusion mechanism. For native 64-bit tasks, it checks whether the current
> PC matches the 'svc #0' instruction inside the vDSO sigreturn trampoline.
>
> 	SYM_CODE_START(__kernel_rt_sigreturn)
> 	        mov     x8, #__NR_rt_sigreturn
> 	        svc     #0
> 	SYM_CODE_END(__kernel_rt_sigreturn)
Maybe add `arch/arm64/kernel/vdso/sigreturn.S` to mention where
this snippet comes from ?
>
> For COMPAT tasks, it verifies if the instruction falls within
> the architecture's 'sigpage' range, allowing the kernel to safely bypass
> dispatching syscalls originating from these areas back to userspace.
I think this might benefit from a bit more details or clarity on the "why"
of the COMPAT handling : there is a vDSO page for COMPAT tasks, but
COMPAT signal handlers have their own dedicated page, `sigpage`,
which serves the same purpose and is handled similarly, so it needs
to be checked as well.

Hopefully that is correct... Would you find that relevant information to 
add ?
Pinging @Kevin Brodsky on that as well.

> Suggested-by: Kevin Brodsky <kevin.brodsky@arm.com>
> Suggested-by: kemal <kmal@cock.li>
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
> ---
>   arch/arm64/include/asm/elf.h |  1 +
>   arch/arm64/kernel/vdso.c     | 16 ++++++++++++++++
>   2 files changed, 17 insertions(+)

Otherwise this looks good to me, great to have more context with the 
change !

Thanks,
Ada


