Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4359ECAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 11:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88C838E005E; Fri, 19 Sep 2025 07:49:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 863E28E0053; Fri, 19 Sep 2025 07:49:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A08C8E005E; Fri, 19 Sep 2025 07:49:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67C9C8E0053
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:49:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 13907140657
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 11:49:30 +0000 (UTC)
X-FDA: 83905829700.04.3A80B67
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 486C480006
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 11:49:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758282568; a=rsa-sha256;
	cv=none;
	b=rAkSPXxWW9V6W/OI2j/PMrFXTEYfsf3cNXCr57iRSEW79l6tYHK8nzHWGcfTjuSHthJbPD
	9JnNoJ6eXFw1RHZ51bnoGBjSW/X/yP49JoL7BrbLK+scEr8SOT4BdRTMBVI2Ozmwcn2bk/
	yt3p9liRvzZQKGdWs0udigOBuaaG794=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758282568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UeCv59JB3G6AoNIDuRn03RdiRvm7Zc9pTM71DO+CB/w=;
	b=5GXxkuqwTlh1HX32Vd5LysTMsRN+9P9+uVGPFTooN4N2vMRoR82SfZZSE136RGS330RMd4
	bw4zcSGNGnzGUVanmvVGJdCBQ/cLv5WkAO3DfCxYYcUKNrShf6hGVsguHzaBDVyA2fJ1ie
	knycOjL0NIlbF2wOk7bO2t9hBh6zNsg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 18CB71691;
	Fri, 19 Sep 2025 04:49:19 -0700 (PDT)
Received: from [10.57.95.38] (unknown [10.57.95.38])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C34EB3F66E;
	Fri, 19 Sep 2025 04:49:24 -0700 (PDT)
Message-ID: <ceaf604f-8ad7-4e19-812e-7eeace10d835@arm.com>
Date: Fri, 19 Sep 2025 12:49:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/5] arm64: support FEAT_BBM level 2 and large block
 mapping when rodata=full
Content-Language: en-GB
To: Will Deacon <will@kernel.org>
Cc: catalin.marinas@arm.com, akpm@linux-foundation.org, david@redhat.com,
 lorenzo.stoakes@oracle.com, ardb@kernel.org, dev.jain@arm.com,
 scott@os.amperecomputing.com, cl@gentwo.org,
 Yang Shi <yang@os.amperecomputing.com>, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
 <175822779944.710258.10028837182267037801.b4-ty@kernel.org>
 <fc43aa07-d4ad-47d5-8381-61d4a9b8c467@arm.com>
 <aM0-FQlepoxxGkRd@willie-the-truck>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <aM0-FQlepoxxGkRd@willie-the-truck>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 486C480006
X-Stat-Signature: 9yexo1n5iy4rupc9jz5sdcik6nu83th9
X-Rspam-User: 
X-HE-Tag: 1758282568-22508
X-HE-Meta: U2FsdGVkX19a+pYodO665bK1NvtuyD6ZeVc4GZ5D4CmxS8SdZcRTU0QwnR47MBCOndOJ8xICFISBeq8biyijxBcYfC3ZdTh5/THEYt3PtbtiKqCgCNOaoJ9y4UL5n8nBeTiDHo5sTB+8lLQPRVWVqJzM94vCblH8RE1wRKXClkjvG9hmmRt6YVfuh+C43MZvkcftNN8QeD18Yp08M3eWknZiKwXXmdFB2brYkBHpPR+n+PL+jasyoIfZyjuxRSr9XvBV2LbDvvv7mUMdAOKarWwDt8RKMx0QUFD+2yqTk9oIJFk7zI30lIkeH4fEa9qj4CEEHWziHvyhwSEx5KSe7UiG6lEeJvVoJI07SCD/B4med6VkjGaKMqUiDKEvndYCGiH+E/nCBdQk8OW7U/KNo0W+Rj3t34zu8rTlGPJGmVOYp7f0eQGtES8ZSvdVePHjF+8DcDADyIKCUFuIkD5wYg9PODdOVqbhjDoWhLgUGj2pyXDt974Rb3tZWij9KY9JBIsdyhGUDRokTWFUOa7XRZqO3KyzILsggyg6F9APWl1jH+xBAuB/NemOmSzQxYElmhWOltScWnCVStS9ckWFV3p3x92f6VmEBP4hOwNV7t2fKq1zfTa1Vrb59WXpow5NYHnLHh8+uz+7NVDdZnMgPnBUVApBQypamLfj8m4RGlF8j2QRScUNGXMkMMF9PUOkKNvxTYcSjnFt5DqpwqHOBZTG0OyAvyPTzRC99ZxxsWX++QFDtBu2Pgzy4i3xADlLShEowUVAAh23fQUp6OmDhZBCbjM+i6yL7DF92+QOGaixN6snyyGeEtn/L5gbzsHk/dgV/FXBcaPH3pjMgBgN5Ur7P//GKHMct5Wwg1SXxZWApZipjfAMB25GxK2Ho5lMq05Bb6BVnEIw+CkFjW8isP43rAIteGHIxpQQnU6kT38+SwHJm3tiC74iyu006wU6mn7r/3Fsn9qNtOyDqrV
 Lrs2W3Zc
 GMPHaZyweXvk/1DEhRywfSb4vtWKIus8P4V5WfR/rTp97lI+H3l2T7iz2kB1Eky0UeC/+b70V6rvxWDkA6A6y28w1xhT/qHpSrnrD6NpngpaLEujKHUjTUiqkR9+9g4hjWWdCq3M1eOBYb/SDcI5zcsqWG0B+8FS5fl8Y2SXTk8O6KQtvK6Z8KwfZIfSa48WkriZfd1gFuZdta57ayMH9drBBgg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19/09/2025 12:27, Will Deacon wrote:
> On Fri, Sep 19, 2025 at 11:08:47AM +0100, Ryan Roberts wrote:
>> On 18/09/2025 22:10, Will Deacon wrote:
>>> On Wed, 17 Sep 2025 12:02:06 -0700, Yang Shi wrote:
>>>> On systems with BBML2_NOABORT support, it causes the linear map to be mapped
>>>> with large blocks, even when rodata=full, and leads to some nice performance
>>>> improvements.
>>>>
>>>> Ryan tested v7 on an AmpereOne system (a VM with 12G RAM) in all 3 possible
>>>> modes by hacking the BBML2 feature detection code:
>>>>
>>>> [...]
>>>
>>> Applied patches 1 and 3 to arm64 (for-next/mm), thanks!
>>>
>>> [1/5] arm64: Enable permission change on arm64 kernel block mappings
>>>       https://git.kernel.org/arm64/c/a660194dd101
>>> [3/5] arm64: mm: support large block mapping when rodata=full
>>>       https://git.kernel.org/arm64/c/a166563e7ec3
>>>
>>> I also picked up the BBML allow-list addition (second patch) on
>>> for-next/cpufeature.
>>>
>>> The fourth patch ("arm64: mm: split linear mapping if BBML2 unsupported
>>> on secondary CPUs") has some really horrible conflicts. These are partly
>>> due to some of the type cleanups on for-next/mm but I think mainly due
>>> to Kevin's kpti rework that landed after -rc1.
>>
>> Thanks Will, although I'm nervous that without this patch, some platforms might
>> not boot; Wikipedia tells me that there are some Google, Mediatek and Qualcomm
>> SoCs that pair X4 CPUs (which is on the BBML2_NOABORT allow list) with A720
>> and/or A520 (which are not). See previous mail at [1].
> 
> I'd be surprised if these SoCs are booting on the X4 but who knows.

Ahh. You can probably tell I'm a bit naive to some of this system level stuff...
I had assumed they would want to boot on the big CPU to reduce boot time.

> 
> Lemme have another look at applying the patch with fresh eyes, but I do
> wonder whether having X4 on the allow list really makes any sense. Are
> there any SoCs out there that _don't_ pair it with CPUs that aren't on
> the allow list? (apologies for the double negative).

Hmm, that's a fair question. I'm not aware of any. So I guess the simplest
solution is to remove X4 from the allow list and ditch fourth patch.


> 
> Will


