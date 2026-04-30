Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5B7DCD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 06:37:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A3EC6B0088; Thu, 30 Apr 2026 02:37:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 954F56B008A; Thu, 30 Apr 2026 02:37:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 842F26B008C; Thu, 30 Apr 2026 02:37:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6F0536B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 02:37:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1792B4049E
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 06:37:23 +0000 (UTC)
X-FDA: 84714265566.03.3C243F1
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3474740002
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 06:37:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of maobibo@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=maobibo@loongson.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777531041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6P4EJXVMSINavezQ4yJUJNQkbaSL8TRjRPQil8x4S+4=;
	b=rZ+Cp1lxsqYLZQP0RYSKt8ywU+5dPzRagO/hhqRL5W091+BZiV41cvYcMgvfbZr+vaJ80W
	OxRf3qYoUR8QeH9LzI8KM/LUlxAIcuOWjBNjejhDy6cAG3d3xeqF6aEw0z9ik3Qj5OKBrh
	G2ElwZuhyFt3GOXBiWINbjxsLhfZYHM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777531041; a=rsa-sha256;
	cv=none;
	b=AyNydOU1KA2/O4MeOodtiFNIZgPFmJSYhnPwCb5GFP2BCLljOT7UrvkmSflJZ3AhNURpdw
	cyi8FsnuMbGNuk3igXN365uzUCRc3zhl1rSX5sBMtgZVLSOarJZ5oFEbE61Onh/s0MGOI2
	w16BzEtpGHgwayAiJWJgkXMlR39uAUQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of maobibo@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=maobibo@loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8DxsOqc+PJpx2cFAA--.18461S3;
	Thu, 30 Apr 2026 14:37:16 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJBx78KZ+PJpue53AA--.32324S3;
	Thu, 30 Apr 2026 14:37:13 +0800 (CST)
Subject: Re: [PATCH] mm/huge_memory: skip huge_zero_pmd in
 zap_huge_pmd_folio()
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260430041121.2839350-1-maobibo@loongson.cn>
 <20260430042834.80895-1-lance.yang@linux.dev>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <e3f542dd-f22b-fc8c-b376-72ab5909b6c8@loongson.cn>
Date: Thu, 30 Apr 2026 14:34:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20260430042834.80895-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBx78KZ+PJpue53AA--.32324S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7uF1xXr43Ar1xAw43GF47ZFc_yoW8uw47pF
	ykGF1qkw48Kr97G3WxZa1DXa4Fywn2vFyrWryayr40vFn8t34j9rs7GrWjk34Igr4rGF4S
	vFZFvFWvvasIq3gCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE
	14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1c
	AE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8Zw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU70Pf
	DUUUU
X-Rspam-User: 
X-Rspamd-Queue-Id: 3474740002
X-Rspamd-Server: rspam04
X-Stat-Signature: 5potx89dx7giayacfsfwnp6hb7x1w376
X-HE-Tag: 1777531039-258103
X-HE-Meta: U2FsdGVkX18z5oMEeE0lzdqlsqfeuf/UwqLBmp8Nk5l+kCWjt+fR8ClnZPos/vwHKJ+0GrvGVjQ53cH4jnH88kozHlMm90OssruEBTsWs60ngSqLE+oVqmdfoPMK3uFo9yGeGW5TqRStW6sCu4959FrwnSz/8jpOCvoRNSEOgZEf8nBVdOieVf4HEu27rWb18MDw3r9H7+FLCLO9v7yvmHesFQ+2qVq4z6XcgGdKdntN8qOutT8t0dMGYHCD+Vd3L1FkFMI5TOhEEj8rHAPu7XKFznal1hsYKZNDLXYkukC5qhvHTvxgPgYIDonLvxHV3IGaBYeQttZ45JQu6qunQ6fqn9qcq8/VaGmUXBPGsGvsErC1QRaRATz/F2ToDyVZFJub7sssbHkfNXCyXOND5fLtrLl5UWW7qAtX0P20bM3EuoenuYIxQH99I4gdy1Uho9ROtGJZroie25/TQgG+GCPxxRVmsoogh8mBbltVDNAzBI6ef9PtD62+hYwBV0acK5OaFLw5eS5e8IR5iabrSkYxqPZ1+PHPSXEabddS4yjFq6repkOtp/WS64CKkubfSPMSdKbt2HjtkdiJ9mhiMNCJBHOtVozF9NplYfIitjvTPPh9R3ITEFPkL9bzlXme9PkHGhEyKpqbbtoXemR4jKwu7foY2sKb3mSTuFiRupKDjVFRRx3WXxYNoh4rA34uMfdjY4ZVjoCXSG3oB9ErOsDpxxc++z2s6y9ulWLr6ygYav3fcmAGtWJkjmpMCzDthVXwhHbeRfvdUWauJU7L493EM9bzMXoonLnKtFiTkIXP3V5TEClSwNBMA6N6pezl07YJ2AII3IBZQiYXhiXKwfNEX+Mhzsghktm4kqV2BNesC2heGaL2x8foEcQcNC3giOl0TWuE8mbgpyGNpE1tXAVHkbc/L/0BwEGlBBkQbLMaMhccM+IrzWh7xm+RHuy6BkgsCRLsqBP5lNMMyVb
 FImq1G0u
 KxwY6pl6ywYlzaRryi3IztJrp7yGF18ytgOJ+RWgJCCU8HY2nY3x34ZRiHeogOz/4vQpzWGkffkxe0zMF+Go3jXHdj4txJ4504+DKwfNZQ63jjdjsUkeJ2FKNiX9wmQjFzy7e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/30 下午12:28, Lance Yang wrote:
> 
> On Thu, Apr 30, 2026 at 12:11:20PM +0800, Bibo Mao wrote:
>> when executing command "make check" with qemu software, there is
>> error report like this:
>> BUG: Bad rss-counter state mm:00000000972846bc type:MM_FILEPAGES val:-4096 Comm:bios-tables-tes Pid:27802
>> BUG: Bad rss-counter state mm:00000000752180c5 type:MM_FILEPAGES val:-2048 Comm:worker Pid:27815
>> BUG: Bad rss-counter state mm:000000009c2f6a61 type:MM_FILEPAGES val:-2048 Comm:qom-test Pid:27825
> 
> Good catch!
> 
>> The problem is that when application exits, rss counter is calculated
>> with huge_zero_pmd huge page, instead it should be skipped.
> 
> Looks like the same problem[1] we discussed recently.
> 
> [1] https://lore.kernel.org/linux-mm/74a75b59-2e13-3985-ee99-d5521f39df2a@google.com/
> 
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>> mm/huge_memory.c | 3 +++
>> 1 file changed, 3 insertions(+)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 970e077019b7..3cbea344d4a2 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -2423,6 +2423,9 @@ static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
>> {
>> 	const bool is_device_private = folio_is_device_private(folio);
>>
>> +	if (is_huge_zero_pmd(pmdval))
>> +		return;
>> +
> 
> The huge zero PMD should not be returned by vm_normal_page_pmd() or
> vm_normal_folio_pmd() as a normal folio. If it reaches
> zap_huge_pmd_folio(), we already made the wrong normal-vs-special
> decision ...
> 
> So I don't think we should special-case it in zap_huge_pmd_folio(). That
> only avoids this RSS decrement :)
> 
> Could you please check whether the fix[2] also fixes your QEMU test?
> 
> [2] https://lore.kernel.org/linux-mm/ea1453a6-14c9-4334-ac7e-2758586393b2@kernel.org/
yes, I think it will solve this problem.

Only that I think that there should be tlb flush operation after 
pmdp_huge_get_and_clear_full() even with huge_zero_pmd page, so 
tlb_remove_page_size() should be called. Is that right?

Regards
Bibo Mao


> 
> Thanks, Lance
> 


