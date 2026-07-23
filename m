Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F5B4C44536
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 01:54:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C5216B008C; Wed, 22 Jul 2026 21:54:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09C6E6B0092; Wed, 22 Jul 2026 21:54:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1B206B0093; Wed, 22 Jul 2026 21:54:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CFDED6B008C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:54:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4036BA0EA7
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 01:54:52 +0000 (UTC)
X-FDA: 85018372824.20.5E02261
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf06.hostedemail.com (Postfix) with ESMTP id 652F4180003
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 01:54:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Hp2fr+eL;
	spf=pass (imf06.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784771690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ywYub6wAD+jWjHOKqOLf/FFBRh9k7vGnHg3v0LBqTPs=;
	b=I0kld43z11bAzhIB99xXlHnEIyRrw7cMa2dBDKUHc4snAJae1w7117TKbGrm2cjlCkPeGs
	j5zoXUtoBRj99FeYBXgZxYe3Kk90lJVqZO8u8tfo7w0jCSMhdLEH+biftrv2FMwH9JkWbv
	Q51ZJmrh7sT76WQGR1B08m+u1BeQznU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Hp2fr+eL;
	spf=pass (imf06.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784771690;
	b=eZKDbQod36YDeV8R1QscFqJsZlROwC84zq5mXuD9zy/wpD8n4F4Iyv2hBozd0kO9gaMqob
	bk+fZmaczhfmOu47sQUUzJvWI0VdpXKfxDC1NMm/yMVTIShIrjnt8zoCBt9oYzLFQeYPpK
	CYLNf4XRtaFVQQWnaShkN3fQLStqblw=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ywYub6wAD+jWjHOKqOLf/FFBRh9k7vGnHg3v0LBqTPs=;
	b=Hp2fr+eL8d+7nGr2HKuNoE+794wuVsTucWVzdE40kbsCKHajUrBfqnINVC44taxA3OM1+ccnH
	0CNp+pxpyQZhw9sbuJeW4heLU1u9qQ8Vx4+VvWGD0Grb0n15LCa7e0Y0QbIb4AOjvHHPdy8J3KK
	HAyZ7GPZQBBpASoLXjmfgbY=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4h5DTS50dqz1T4MQ;
	Thu, 23 Jul 2026 09:45:16 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 436894057F;
	Thu, 23 Jul 2026 09:54:38 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 dggpemf500011.china.huawei.com (7.185.36.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 23 Jul 2026 09:54:36 +0800
Message-ID: <5a200b28-d970-462b-ab49-ccb6bbe6c94c@huawei.com>
Date: Thu, 23 Jul 2026 09:54:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 15/15] arm64: vdso: Expose sigreturn address on vdso
 to the kernel
To: Mark Rutland <mark.rutland@arm.com>, Linus Walleij <linusw@kernel.org>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <kees@kernel.org>,
	<oleg@redhat.com>, <luto@amacapital.net>, <wad@chromium.org>,
	<thuth@redhat.com>, <peterz@infradead.org>, <ada.coupriediaz@arm.com>,
	<kevin.brodsky@arm.com>, <yeoreum.yun@arm.com>, <anshuman.khandual@arm.com>,
	<james.morse@arm.com>, <tglx@kernel.org>, <broonie@kernel.org>,
	<pengcan@kylinos.cn>, <ryan.roberts@arm.com>, <liqiang01@kylinos.cn>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>
References: <20260721081858.1169276-1-ruanjinjie@huawei.com>
 <20260721081858.1169276-16-ruanjinjie@huawei.com>
 <CAD++jL=Ou_HF5VchexnjUf9qwzrz0xgY+NhA5gZhOwiwdxUi-g@mail.gmail.com>
 <amEJkyKFvVOkiGao@J2N7QTR9R3>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <amEJkyKFvVOkiGao@J2N7QTR9R3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.109.254]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 652F4180003
X-Stat-Signature: irwmuefx3y44yg8esyfabr5z4u6izjky
X-HE-Tag: 1784771688-676225
X-HE-Meta: U2FsdGVkX182o+900vfS+hTeI249y4RlUwlORg16CT07i0LkbqBOADNNs8CQkbJW5vc4o3GijizEEv53B4wgz6lk1SvyQuLHMEHc3GUm3S2+TIXf3RCgRBeZLvGyHQKftBVs5eWpF8/yHVaxOMNu0yC3KhL7m29ql4zb5xa80x8JOQuInuP80Gq5UYcDOVSqZ6YNqW59jDLlolq0NeP6lAuR4ul4rHUEc2ipnaD6xsPttgrqTXA07zLOjpeYA6TvA9IdNZUAhuhaSU3Z1RAyWMs6g5JsKI43zSo2wfEUzVDyi0957Ug0LnoGj0XvRUg92Jw4q1GIhoon6ztVlhkbczLnPq2cqRUq9bC+Pl6m+Inie6m+yvtFILXVVDqdIBkOLWdH1legFG5FjKQ5zTiEQ3qBFV6Tip8bvBwtOX7Da2wN7mfqnUaE5fX0/7nTQ3wFlcKThn8TwO/8uHy8Su/+LKSlD/GSdNsEliDDSTd+E0sCiwDgzEeoDU4BDCRFgQIJsXFZV3H4Jyrhwm8Sc7NHzEcLRc4hKoXfmA46mo75goi6rCs1b4t8MP8RNir6yQZf7iDauVKkdu2qBze2BoAMJqShBnXTbwlshuRKNc7G8KqaALMk0dc7ckxhCROUU/MdlB9KoPokyMxVhhKlg6gv4mbB0FoYicEnYQRyHpY07b23RSzhvyyaW6LoF7xobivyh4hWcHgL5R+z4TVumjC/iz+Ytl9Khq4GeVjN/Pjt8Ax3iigvJ/3Ewb0oacHo81vLG5J6HY1ke1MyOAwRcURVnhuQrtJkPBgMR5igFP08f1zzfJtmc80AGRbRba4pfuRPjgaWFxbrLzj3VVu8fLEffzkU/cwHP27PbMi70kVccSIDiMIdFkNK0eBo+CWE+A2Cz/q/gNthVsLk7s3z+B0BVWCyW7IG01n+5Fa4+H/RpvDzAKA/MnlD5lMhhxPAkfAyYh4Kle1psHnfrSgPlIz
 eVpDDUj0
 tZetN+jXl2zrDWywnKhJdEolQso5NQ5+++88A6RxaSrnaGWuETdcLMEiavYpytuNFtYt9fARgrzeX9lVCTQ7ns8WeIAguSFJ8Ndicb7k2K96nmBNcY0CEAeSHoctSSIw7oFhQohKMnzQne98foQaVbX5UGJkX2KwrS1BdIgo0EIRrFyoXxrTsvmrr3uyTOVocOUYZxZfTt2i+1RDMF3WGtipbG67CcIhHxCQ2JqQ9ff78SKDsCdGpftkXLJUYpshCz9h9V3bUdLvK8ps4wny/cajnKYiX1h2SdX9onn+n7s4ReY5bi6vImB4B423df5leHfVtRAqbay1oUyxRK35ZsnK8FHyvYnt3Lc3+DZGv6mQQ4QkCr9gLSHfFvbMC21sj7H/JjxTJPpLcdm5bxZOsLYLWkzVkVFfCVjLYtAIHbqK5o4V4LB+Hi/H5lDE50JU1RpvK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/7/23 2:18, Mark Rutland 写道:
> On Tue, Jul 21, 2026 at 10:55:03AM +0200, Linus Walleij wrote:
>> On Tue, Jul 21, 2026 at 10:19 AM Jinjie Ruan <ruanjinjie@huawei.com> wrote:
>>
>>> Syscall User Dispatch (SUD) must not intercept the signal trampoline
>>> code, otherwise returning from a signal with a locked selector may
>>> cause infinite recursion into the signal handler.
>>>
>>> Provide an arm64 implementation of arch_syscall_is_vdso_sigreturn()
>>> to exclude these sigreturn syscalls from dispatch.
>>>
>>> For native 64-bit tasks, check whether the current PC matches the 'svc #0'
>>> instruction inside the vDSO sigreturn trampoline (defined in
>>> arch/arm64/kernel/vdso/sigreturn.S as below).
>>>
>>>         SYM_CODE_START(__kernel_rt_sigreturn)
>>>                 mov     x8, #__NR_rt_sigreturn
>>>                 svc     #0
>>>         SYM_CODE_END(__kernel_rt_sigreturn)
>>>
>>> For COMPAT tasks, verify that the instruction falls within the dedicated
>>> 'sigpage' range, since compat signal handlers use this architecture-
>>> specific page (not the vDSO) for their return trampoline. This prevents
>>> SUD from incorrectly dispatching syscalls issued during signal return.
>>>
>>> Suggested-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
>>> Suggested-by: Kevin Brodsky <kevin.brodsky@arm.com>
>>> Suggested-by: kemal <kmal@cock.li>
>>> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
>>
>> I'm a bit scared about SUD.
>>
>> Certainly we can merge patches 1-14 first and iron out
>> any trouble related to that and split this off so a separate
>> series to be applied lated?
> 
> I had already asked Jinie to drop SUD back in v14, and he had agreed:
> 
>   https://lore.kernel.org/lkml/akegeU59jSK9t7FX@J2N7QTR9R3/
>   https://lore.kernel.org/lkml/3ac6d4be-7c57-44c2-80a0-408e2c6f8136@huawei.com/
> 
> Jinjie, please drop this for now, as we had _already_ agreed.

Ah, sorry about that.I will drop this SUD patch in the next revision.

> 
> I will look over the rest of the series soon.

Thank you! I look forward to your review and feedback on the rest of the
patches.

Thanks,
Jinjie
> 
> Mark.
> 


