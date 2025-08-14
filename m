Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0055ECA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 14:07:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 894F990017C; Thu, 14 Aug 2025 10:07:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84315900172; Thu, 14 Aug 2025 10:07:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7316C90017C; Thu, 14 Aug 2025 10:07:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C7C6900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:07:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E2A951DCE3C
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 14:07:24 +0000 (UTC)
X-FDA: 83775540408.21.F45367D
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8E33816000F
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 14:07:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf08.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755180443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZxMyVulUQb07D/8e+rw8hCIpk8eYybn7DeqbTHPdG4c=;
	b=UcE0Ui8H2xLXkKE/HR06iSmC8baFzkc2S2cwcJIJa1WgZeVyp9jnZtwYQ0A2ulD/Qsxrp9
	de/77SrEB4fAy7KgDfMCpcKUMxjqr3lgQWb1aiPKPBAaO1e08q+2IBhLjfcczgvtT2+K2i
	PrbOEAuTez/Ob/aQNlrljQKa3LibidE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf08.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755180443; a=rsa-sha256;
	cv=none;
	b=lmE30lNoS7UFMBTl8crq4A6TvFhxSu6NMY8VdgV+ClqiifnPJiWOT7ONhjJ27rCD22XvMA
	mJ1b8XiySRrBNtDhBA1YuWY65cWUU8MkqyFNpi0/6r8bq/zWKaZ+899IF3wYNWut1lhrbx
	D/0eO1QLzTYSgTdC+T8qHyDi+xwwPdc=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4c2n8k1zdTztTJm;
	Thu, 14 Aug 2025 22:06:14 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 43150180B54;
	Thu, 14 Aug 2025 22:07:14 +0800 (CST)
Received: from [10.174.176.250] (10.174.176.250) by
 dggpemf200018.china.huawei.com (7.185.36.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 14 Aug 2025 22:07:13 +0800
Message-ID: <ee37ea36-7298-4174-b146-fd62b24ef345@huawei.com>
Date: Thu, 14 Aug 2025 22:07:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH -next 00/16] mm/damon: support ARM32 with LPAE
To: SeongJae Park <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
References: <20250814005738.52844-1-sj@kernel.org>
From: Quanmin Yan <yanquanmin1@huawei.com>
In-Reply-To: <20250814005738.52844-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.250]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Stat-Signature: 56c1y8p3wof66etogqf4orqe4pymgqs4
X-Rspam-User: 
X-Rspamd-Queue-Id: 8E33816000F
X-Rspamd-Server: rspam01
X-HE-Tag: 1755180440-718941
X-HE-Meta: U2FsdGVkX19y7GJliVqk/ueY4W+WL5lvXZ7SQV9+8m0FzkMUEbEybfNG5+pu2+IBTvgYBYcK10+tpuOAU/imHmty3YzTCA6w6g0ax3T+Mn7sCa1dLctxykrCQ5odvXzswPAB+BvoNQoQH2qG/26xyYpwv0jmTvKWvkssE/b8XG+7lA7JyTRtm06WhYcNyg29GE+SNNzzRPBepowc1hw22gWHxtLm6TGTkrcEsUF9Bx6Y2cKkvzzzLI8p21kGSQ5OSiYlTy8GPinlgf/SP4fOeQBVXihXqvZEMdkeoXmBIGELsWyUjtCT1Q3NbaLczAMMw7lvQEYA2bU75P0BrkZ5SsGBq9iT/ebuG0EJ33wa0Q2wtkSeg8BBhToer9CXwRImL+iYXQkoPqPSlFCWN9zW/lgLN2rq3QCsIJGhQxvU48M5DRjNteucJaO7+hPUzLjzvtLjKkuDFAEJu317VPpBL0e090E1agYYFLv2cfe44q6BLhPC8rQbmskuO2Y9hsrI+83l3I4ZPp5SubZHG8prt/UXKep6FgOiJdlbFVOuQvn1u5lbzYiJbCqhOD4L1CF74r0mFBLdsUOtaEs+R0NylxPe6gVbZi+zXCa46lVe9zNP/7a885nBnzpjPWXBe1GiQNvlrKji5kiQ3xQUcTNFW+/0lChVSxvJDVNTUtCCAt/AYabCL8NUY6GSJH77cvbvecrx7VjGEqOiIwTpzEnJgcsRUXrDRNIHs5juZOyAFtduEHdOiVjvSs12Z96Ilj/tD0Rb+Cd02h6gjBX0/ki2pD3BaCIW980/serQZzju77QRdYo5BEBF9/wGo9nsLw/IutnsEVXP4TknJbWU4TLwHvCsFbUb0BfGZHd8q0625oxH0CmWk5ZQ1tltTVFthTmwmyKf5pinA3sFpZ/D8vdvWyv5RuFSoYiL2atZCsmYGgCclaevQrPqw5U1m3g8UUL30g4xe6I1/GOZ7kTp3bj
 PYFkoY/p
 aFR7GeRHJuu5RIZnhezQ+wm021fDvFtTe23Zvm4p6IMJ1E09XwUuzuD+35+ePTGZt3wErCARmanYjmsUmaeUfwi1ud0OEVwUbNoQ1Bc2eR+sqsxMza+LmlDzI8Kr+ZSMAw3VBoIBaWExs8gI3ecWOPAj1iptwtOSHSTIyPTBiXoDECNuWoyXoIkcKMV8XCZdiN5X93Q/CVqD9JcT6qnASrI2QxutZy2Cdem/Ivjrk+p5MSiafv38SvHEyQNXMW3Tq6xYgeKG+8Irsu6In+NkNcpvIR6BTff7YvSm8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/8/14 8:57, SeongJae Park 写道:
> On Wed, 13 Aug 2025 10:25:44 -0700 SeongJae Park <sj@kernel.org> wrote:
>
>> Hello Quanmin,
>>
>> On Wed, 13 Aug 2025 13:06:50 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
>>
>>> Previously, DAMON's physical address space monitoring only supported
>>> memory ranges below 4GB on LPAE-enabled systems. This was due to
>>> the use of 'unsigned long' in 'struct damon_addr_range', which is
>>> 32-bit on ARM32 even with LPAE enabled.
>>>
>>> Implements DAMON compatibility for ARM32 with LPAE enabled.
>> Thank you for working on this, Quanmin!
>>
>>> Patches 01/16 through 10/16 are from the mailing list[1], add a new core
>>> layer parameter called 'addr_unit'. Operations set layer can translate a
>>> core layer address to the real address by multiplying the parameter value
>>> to the core layer address.
>>>
>>> Patches 11/16 through 14/16 extend and complement patches 01~10, addressing
>>> various issues introduced by the addr_unit implementation.
>>>
>>> Patches 15/16 and 16/16 complete native DAMON support for 32-bit systems.
>> Overall, looks good to me.  I have a few change requests including below major
>> ones, though.
>>
>> First, let's squash patches for fixing problems made with patches 1-10 into
>> patches 1-10.  If you don't mind, I will post RFC v2 of those so that you can
>> pick into your series.
>>
>> Second, let's keep DAMOS stats in 'unsigned long' type.  This require fixups of
>> patches 1-10.  If you don't mind, I will also do this in RFC v2 of those.
> Instead of posting completely new RFC v2 of the ten patches, I think posting
> fixup patches as replies to this thread might be a better approach.  I will
> make fixups first, see what looks easier for working together with you, and
> either post entirely new version of the patch series, or send individual fixups
> as replies to each patch of this thread.
>
> And one more questions.  What is the baseline if this series?  I cannot simply
> apply these patches on mm-unstable or mm-new.  It would be nice if you could
> share a git tree having these patches fully applied, since 'cherry-pick' is
> easier than 'am' for me.

Hi SJ,

Thank you for your detailed suggestions on the patch series. Please allow me
some time to thoroughly review each of your recommendations. I haven’t responded
to every point immediately because I’d like to first attempt updating the patches
accordingly. If I encounter any questions or issues during the process, I’ll promptly
reach out to discuss them with you, very appreciate your patience and guidance.

By the way, this patch series is based on linux-next(commit:2674d1eadaa2).

Thanks,
Quanmin Yan

>
> Thanks,
> SJ
>
> [...]
>

