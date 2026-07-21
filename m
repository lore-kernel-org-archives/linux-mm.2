Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A03D1C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 09:27:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AE3E6B008C; Tue, 21 Jul 2026 05:27:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 986AB6B0096; Tue, 21 Jul 2026 05:27:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C66B6B0099; Tue, 21 Jul 2026 05:27:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 64DBF6B008C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:27:19 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8F9A6A0BF6
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:27:17 +0000 (UTC)
X-FDA: 85012255314.29.2564199
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf16.hostedemail.com (Postfix) with ESMTP id 03C6A18000A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:27:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=jIxiaBiE;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf16.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784626035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1c85gg17qOp2jVI8fhxIGgJrpPOSpSPj68RXsM9YqFQ=;
	b=DJGQAgT+HpB4zUJPIRZQNRfu+1FdPVNLpMPe2MPxONWEem1PruHPvD8j40OZfTneU2k1/8
	6EvQg/DBnbqBsJpRbynuOPZwpe+IUuLH8D18e/FsZNRQ4UslJ1j8a2Q1Telkbvh4Cr9WuC
	woX7r/Ypxhza/xBt+SkYMjmRW/pcs+E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=jIxiaBiE;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf16.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784626035;
	b=Oc5vh+M5S/YxDSIZ+Rzhnca1KEvdqdWbkmj56fkVvtgc7Kh16WToHBHHRD6crjvGCN4ukv
	R9q9DypEc/ETv4P9/ukabqMC4KalvoQS9l+a3h3o14aR3dJrU9Eoo0ZUxQOjRVHNG6ytVQ
	nJkgMZ+I0F2c0AIY8aYyxsHijmg9284=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=1c85gg17qOp2jVI8fhxIGgJrpPOSpSPj68RXsM9YqFQ=;
	b=jIxiaBiEZUASBc8flQ1I2Kxi2AQjwRTVk+7jv2wnMBVzpgVwbrHH1P9sWOOXoQKOmfpGn8nRR
	X2lgXtHd1WrGwtiMFog4QqUZi/Gc3IoY1fNRbmS+gCErqIfBa0tXGkgqtll21JVbEXAywqIb9Kn
	rsA7SAzkcvjTsgPhf9LV8vA=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4h4BcQ1ZvRzKmWF;
	Tue, 21 Jul 2026 17:17:42 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id BE91A40586;
	Tue, 21 Jul 2026 17:27:06 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 dggpemf500011.china.huawei.com (7.185.36.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 21 Jul 2026 17:27:05 +0800
Message-ID: <4b6d760a-8270-443b-878f-37d46d9bed47@huawei.com>
Date: Tue, 21 Jul 2026 17:27:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 15/15] arm64: vdso: Expose sigreturn address on vdso
 to the kernel
To: Linus Walleij <linusw@kernel.org>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <kees@kernel.org>,
	<oleg@redhat.com>, <luto@amacapital.net>, <wad@chromium.org>,
	<thuth@redhat.com>, <peterz@infradead.org>, <mark.rutland@arm.com>,
	<ada.coupriediaz@arm.com>, <kevin.brodsky@arm.com>, <yeoreum.yun@arm.com>,
	<anshuman.khandual@arm.com>, <james.morse@arm.com>, <tglx@kernel.org>,
	<broonie@kernel.org>, <pengcan@kylinos.cn>, <ryan.roberts@arm.com>,
	<liqiang01@kylinos.cn>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
References: <20260721081858.1169276-1-ruanjinjie@huawei.com>
 <20260721081858.1169276-16-ruanjinjie@huawei.com>
 <CAD++jL=Ou_HF5VchexnjUf9qwzrz0xgY+NhA5gZhOwiwdxUi-g@mail.gmail.com>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <CAD++jL=Ou_HF5VchexnjUf9qwzrz0xgY+NhA5gZhOwiwdxUi-g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.109.254]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 03C6A18000A
X-Rspam-User: 
X-Stat-Signature: uwwoj3jza8ep9b9h5bsoerwfkpbet4yy
X-HE-Tag: 1784626034-44057
X-HE-Meta: U2FsdGVkX1/nzfHcInbBverUMzQdhxZG7qQ860JJrsV9SrJGTCFHSMhuY8AVn1DCuyexVqMIFeKIuSuR88DjR0m3jPi6FSVNyxTSa8Yx0O0hsnMG4QhkFpMb77Rc+r6o9Hs5fzw7QuedTRsT2ch1KBsxnp9CxVDdiTEepl+WHRaaObvGVRGtdJ8rdejQy8dcCeRogGfviqP90CH2SN8MLt0+De8QONTfOfcRAXQXF7XmAX6wkmQ5wvdN2yyQ7qAVC6x82TsBrOKh1VkyER5zD3XhWR5YlvT9un1DmbjoXfPT7R1TVbEnKnKVLMa5m0IrEJimE4SRZaTOlrwByezaA2uKlaNOf5QnWn5SFwhhzVqnTkyumwX6WLyJXi91+fqYOUMgvUR62Rrl/O/yyZ4Ro/eZABzJD0ifCMyYzjzaByYEowuP93nK+s4mhPgwtWaR/Z+dMwKmNnFDoOUOa7bceV9fo7kQVDy8WOCZ0yLf5WOs6sQyMqQrzcL3rQpD1cEZt1icRitr7m8Z2Tcn0o0DTuWmiVYS5+5Lz98OojKQSLhQGUsrxI9O7q6KGhxrzgvX20vlYSTCEr1Nl3VRt0pigTouCI8f5dT9bqEYyVmEqtN3lSfH7MSrxndDoLHGhD0qiFqSg7w6U6fo+Z5YugH8wpV3YVKxtDjVhYCu7RYxdx74SSgAHpNWzCKZDs/h3rcIEuneNzCouJ+AR/l+77YIQBANCxJNHUkw/GWh2cXB5Retek3QJmHWwK7xqjPsxfuSKHwQlFSAyvZMnr26qXkzQWar4RFYxRIAc5gjzXdD+WhIjW6Kzcj28Kic/jQ6UXVSK8IHNZ1IQyZpHn/KjClElfODFnQrnx6mJFBWj8l5EnxT4HFViZ6pfE7zq7e0U+XGnzCBrrhpQ3W8OxsCsMLOPzAQcF3vI0icleHlC8e51p8MWqAbSZpXIo+8Ut/0vnA2KDQ6KGKutRi4A38vLEq
 YgNvmdcO
 DWB0Nzc+/K/cLRyhSQyn7zcZnR2DIv8NlkQD13ZTBR7n1qoI0xUXtWqkJnVL2sHvw6vwIeQlG6e230l04mSv6l5dDeuU30rSAKMM0LSJ+uI1PDedpJxW0Prwwjf1LutbEW6NbRnS8xpBFb2g7nYOHKI3+Umc2UPaYyWc/xL5CDjH6UgWDZVSGlfyFM+MjKaNMvGTvRGBMM8RHzoetmAS4znYeZaYM0+t7F5U0lkTDPTf1WMsTjG+viCXa0KK2dVPevOlxY8QNCy4ocfIXtjb/XGT7xHzkg3gw8PUo+P0lw0rdIbv1b3UfyyD0Xhxw1KvXOuTZak3YUoyXqjYkXqrVF+i4Ksy3aJCmRRC4ISqxv0OJrqZkUSgTyEdVsshuVMJtIxGNNl0m/mY9lPILuh86gLFSNm8Ixy/rLcAvurUIBCEAnEg68wpXF1Aul5YAXQouCKn1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/21/2026 4:55 PM, Linus Walleij wrote:
> On Tue, Jul 21, 2026 at 10:19 AM Jinjie Ruan <ruanjinjie@huawei.com> wrote:
> 
>> Syscall User Dispatch (SUD) must not intercept the signal trampoline
>> code, otherwise returning from a signal with a locked selector may
>> cause infinite recursion into the signal handler.
>>
>> Provide an arm64 implementation of arch_syscall_is_vdso_sigreturn()
>> to exclude these sigreturn syscalls from dispatch.
>>
>> For native 64-bit tasks, check whether the current PC matches the 'svc #0'
>> instruction inside the vDSO sigreturn trampoline (defined in
>> arch/arm64/kernel/vdso/sigreturn.S as below).
>>
>>         SYM_CODE_START(__kernel_rt_sigreturn)
>>                 mov     x8, #__NR_rt_sigreturn
>>                 svc     #0
>>         SYM_CODE_END(__kernel_rt_sigreturn)
>>
>> For COMPAT tasks, verify that the instruction falls within the dedicated
>> 'sigpage' range, since compat signal handlers use this architecture-
>> specific page (not the vDSO) for their return trampoline. This prevents
>> SUD from incorrectly dispatching syscalls issued during signal return.
>>
>> Suggested-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
>> Suggested-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> Suggested-by: kemal <kmal@cock.li>
>> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
> 
> I'm a bit scared about SUD.
> 
> Certainly we can merge patches 1-14 first and iron out
> any trouble related to that and split this off so a separate
> series to be applied lated?

Yes, Mark's idea is the same. We can place the SUD patch here separately
and wait for thorough testing and review.

Link:
https://lore.kernel.org/all/akZgV0Y4YAmB43_g@J2N7QTR9R3.cambridge.arm.com/

> 
> Yours,
> Linus Walleij


