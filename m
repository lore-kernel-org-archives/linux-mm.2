Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEB99CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 12:00:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 483068E00C3; Fri, 19 Sep 2025 08:00:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 459ED8E0053; Fri, 19 Sep 2025 08:00:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 396098E00C3; Fri, 19 Sep 2025 08:00:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 295DB8E0053
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 08:00:57 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BBD3C140631
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 12:00:56 +0000 (UTC)
X-FDA: 83905858512.24.BAAFCB7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0C85B4000F
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 12:00:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758283255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sze7ON4qmTfCIUSrLryhWAaJPsC5r0i+cIjo9nF08iY=;
	b=NB48gVk7QFZhslP3fJYCNn3Lc6qkHJfXwVUoDBTaVGWDRlv/SqTTwk5ddPWScgbMwfjhoq
	B3EUT1CEHPHjzmunUuryd/xXXtq+5LwDY3VFmfnEk8LHc4y2DuFq3P/7f9nGU2xiQYwtWG
	HvftylfjNKFF9UuhQYPUsgkhLmQ70Qg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758283255; a=rsa-sha256;
	cv=none;
	b=guGqCV8ITiQ18eYKL9R7j5SbZmmCw9JRnlNgSzHk9nYMy6dwHhQ1PyMyk5AD4elaHXj9CR
	yul9Yd17YTcsUIXPuGTVVfVjDe/DHWVU6Zdk6gYt/0Vm6EI+9jRUkG7h/z4RGk2rnGl8ao
	kuqgy1Ul76TA0fFNt6UAFljBHsNNqk8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D3B35169C;
	Fri, 19 Sep 2025 05:00:45 -0700 (PDT)
Received: from [10.57.95.38] (unknown [10.57.95.38])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 92CAB3F673;
	Fri, 19 Sep 2025 05:00:51 -0700 (PDT)
Message-ID: <38fa4717-9105-4bca-a2cd-914afc109570@arm.com>
Date: Fri, 19 Sep 2025 13:00:49 +0100
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
 <ceaf604f-8ad7-4e19-812e-7eeace10d835@arm.com>
 <aM1E34lRjKg7nlRu@willie-the-truck>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <aM1E34lRjKg7nlRu@willie-the-truck>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0C85B4000F
X-Stat-Signature: hy8jr8rstbxeryzofxgp1zq1dikzc8hq
X-HE-Tag: 1758283254-17046
X-HE-Meta: U2FsdGVkX18cLGfjaEvsqU0V5w96o00wDhYHVV2lWahD3jzTgYtleW6+t/zeMz50J7zqRBgCYMwZYEqBOi3f71zhh7M7tGIaED/AHGhGCXHP+sQTmmUutnEKaWTAJa0+JUWCJQJmFeItfSpF5o0ojWM3OAWJhbvjsoz+8kzXoMAmcvXWRP/A7oujXCUNhls9XiOhv+LA3O7+U31QVECT7DcaA5pus8DmFpl1AtBGMn8OMfhTUN95XhXRgPS13obfXqcd7SapQRGxPqspjm0NOUDlO3hEKh40tVa/pTHRxhBsM2S2Q/bFbjDBvrGdMENXllQAwlsSeLGFYB3RJZ8zqZJRNUo7b1XKYU7mWwRTE6YM0pjgBvJ4Tw3z5G3Mq5Dfe5IoU+XmiE9RsRIogGBPVPJccDpH7L11VAi4gEDhi2shcSA+6zPxWi06tQqvRTjLcq/ZceSwLAxcClHD92z76uL9EbZr2zoJZJu+DNViIOOjmT4LLMJUMonaN1qeQyNzfslNJ0kKQZPBxQiAEj4HScPQXTL9JpE1Ydg3aIsUW7bJmrEO3iLoo3LdvSlD3SlC3Z8J2q4UW1tdnYf2oTAFnPw1/1fHunqHFrw7/R/TJA30O5NFbdG1QjTZAiFvoWy0Y7cnQucvZZ5Tgl9h/QJzCl5FNBhUE7Pr6zPrQVAyfH5pxb8OAk0ktc7bqg8WrTqsbqoM+29H7Z09gPxdqyc007M3YrxmuaR2MuU6LuQdIs6z7zoHLh7IJ5JIsiA+ylA37UWq00hsVQg13foo0/kw1XXhMQUt7jkPk0Ys2XZzEk/zDf1uaNruyIoM1TpduF81XE5rULTxoQSV0dN4eUJkmcb5zppv99KxJvRcPvpAbMD8nOHHGhKL4fPKifdsNidxmmXxTS7mX5k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19/09/2025 12:56, Will Deacon wrote:
> On Fri, Sep 19, 2025 at 12:49:22PM +0100, Ryan Roberts wrote:
>> On 19/09/2025 12:27, Will Deacon wrote:
>>> On Fri, Sep 19, 2025 at 11:08:47AM +0100, Ryan Roberts wrote:
>>>> On 18/09/2025 22:10, Will Deacon wrote:
>>>>> On Wed, 17 Sep 2025 12:02:06 -0700, Yang Shi wrote:
>>>>>> On systems with BBML2_NOABORT support, it causes the linear map to be mapped
>>>>>> with large blocks, even when rodata=full, and leads to some nice performance
>>>>>> improvements.
>>>>>>
>>>>>> Ryan tested v7 on an AmpereOne system (a VM with 12G RAM) in all 3 possible
>>>>>> modes by hacking the BBML2 feature detection code:
>>>>>>
>>>>>> [...]
>>>>>
>>>>> Applied patches 1 and 3 to arm64 (for-next/mm), thanks!
>>>>>
>>>>> [1/5] arm64: Enable permission change on arm64 kernel block mappings
>>>>>       https://git.kernel.org/arm64/c/a660194dd101
>>>>> [3/5] arm64: mm: support large block mapping when rodata=full
>>>>>       https://git.kernel.org/arm64/c/a166563e7ec3
>>>>>
>>>>> I also picked up the BBML allow-list addition (second patch) on
>>>>> for-next/cpufeature.
>>>>>
>>>>> The fourth patch ("arm64: mm: split linear mapping if BBML2 unsupported
>>>>> on secondary CPUs") has some really horrible conflicts. These are partly
>>>>> due to some of the type cleanups on for-next/mm but I think mainly due
>>>>> to Kevin's kpti rework that landed after -rc1.
>>>>
>>>> Thanks Will, although I'm nervous that without this patch, some platforms might
>>>> not boot; Wikipedia tells me that there are some Google, Mediatek and Qualcomm
>>>> SoCs that pair X4 CPUs (which is on the BBML2_NOABORT allow list) with A720
>>>> and/or A520 (which are not). See previous mail at [1].
>>>
>>> I'd be surprised if these SoCs are booting on the X4 but who knows.
>>
>> Ahh. You can probably tell I'm a bit naive to some of this system level stuff...
>> I had assumed they would want to boot on the big CPU to reduce boot time.
> 
> One of the problems is that the boot CPU becomes CPU0 and that inevitably
> means it ends up being responsible for a tonne of extra stuff (interrupts,
> TZ, etc) and in many cases can't be offlined. So it's all a trade-off.
> 
>>> Lemme have another look at applying the patch with fresh eyes, but I do
>>> wonder whether having X4 on the allow list really makes any sense. Are
>>> there any SoCs out there that _don't_ pair it with CPUs that aren't on
>>> the allow list? (apologies for the double negative).
>>
>> Hmm, that's a fair question. I'm not aware of any. So I guess the simplest
>> solution is to remove X4 from the allow list and ditch fourth patch.
> 
> That's probably a good idea but I have a horrible feeling we _are_ going
> to need your patch once the errata start flying about :)
> 
> So how about we:
> 
>   - Remove X4 from the list
>   - I try harder to apply your patch for secondary CPUs...
>   - ... if I fail, we can apply it next time around
> 
> Sound reasonable?

Yeah that works for me. Cheers!

> 
> Will


