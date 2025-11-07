Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25A52CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 14:18:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4907B8E0008; Fri,  7 Nov 2025 09:18:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4412C8E0005; Fri,  7 Nov 2025 09:18:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 357718E0008; Fri,  7 Nov 2025 09:18:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 271A28E0005
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 09:18:02 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B52A113B23C
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 14:18:01 +0000 (UTC)
X-FDA: 84084015162.23.67FC7D7
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf29.hostedemail.com (Postfix) with ESMTP id 47B22120006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 14:17:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sN4IZ86W;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762525079; a=rsa-sha256;
	cv=none;
	b=fI6YSYBMqxAgYZhXbvofd1tWTKXQQPjr+fPjsPIwiGl50cqCkuZZasotOezg9m0COsTxSg
	tZejb+dHXmR5/5Y+4lYasHGINyObIgEj8iYqWFkUIzBkhrlvKWOEDp9CPh/+CE04vIe9ZW
	ptRry7l9KRG1/7hrwloq3byL3F79M8E=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sN4IZ86W;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762525079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ykW1NxfmAyfPid0Bv9EkP65yYrb8g2y4oaOywpFdm8I=;
	b=Va5qK1sCMexi+MaRriChcIaMrT3NZ/zYKSWs8JW9AY4BDzJVPatRIM6quNp5P/ylGX5l9c
	MmkYJrNqMOFvVVPBQD3cLkV4Q0CU77/9PqUnQ3xwdNkqZVwneCF+pljD3VB0xz1uqYOR+d
	NmwlKD2x8IFR3yirqP9xj093dJ4TfqQ=
Message-ID: <46a03f86-ab38-4a6c-b1fb-6f77122eff0d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762525077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ykW1NxfmAyfPid0Bv9EkP65yYrb8g2y4oaOywpFdm8I=;
	b=sN4IZ86WVAG4Olc7M1q+EZefrDrYOz9yC7iz6UK+cC19RzbPzIJK9onGxB+RMlrYmMwNDG
	4NAW5gu9nibVu2HvO3tsZtbu1IzQf/ELSYqchfavu1h6FnH7B3XS89Nt/3fLjNCmU3Ek6q
	k0+MPu+biM3cAI81N7L2OS+aok5bVIU=
Date: Fri, 7 Nov 2025 22:17:44 +0800
MIME-Version: 1.0
Subject: Re: [PATCH Resend] mm: Refine __{pgd,p4d,pud,pmd,pte}_alloc_one_*()
 about HIGHMEM
Content-Language: en-US
To: Arnd Bergmann <arnd@arndb.de>, Huacai Chen <chenhuacai@loongson.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Huacai Chen <chenhuacai@kernel.org>, Jan Kara <jack@suse.cz>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Linux-Arch <linux-arch@vger.kernel.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, david@kernel.org, Lance Yang <ioworker0@gmail.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, vishal.moola@gmail.com
References: <20251107095922.3106390-1-chenhuacai@loongson.cn>
 <20251107114455.59111-1-ioworker0@gmail.com>
 <f0efca40-aa3b-41ba-a8e4-c9595c19778e@app.fastmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <f0efca40-aa3b-41ba-a8e4-c9595c19778e@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 47B22120006
X-Stat-Signature: k94y5ftsesz1n5gg63osh7qs6mzjxnqb
X-HE-Tag: 1762525079-614705
X-HE-Meta: U2FsdGVkX1+qTv/XWp55JSNT1NvO+nkIy0C6aXWs9BULIbjkOxAq5F0BqK19dcW1R1Swf4udn1TDjvxwXbNb+4qoEeD8k+ji+jWJLhRwXy/o6gH3JsM4+3jjxeHstCNXwCdIBsdMIeH5Wt9k/1APH9gmKRcNzLwQ9tix3fCfhx/vB9ckeq0VzHIhzZzbAv1sbCgZ7MuG/pJjAvdbpTGYwhwr9DL/15d1M+7+5INjFLSh7zLyFkistuvPPLehkR/3la+Mezno39v297ikdM6WvPTSqaFxD/kvArWPbbNV608mvsK8R40pRk5DrhHlQKiYiuSPa2WAp+w4P9UvUyT19HnapjmCizv2yP+7BDaWn1IQd6HB/PEgRDypls0hUG1hzVlYTePP+9M82ZMO7nS1v3eld/y2o9/X56zNieCqtyUZGLhO0u5TOUXG66tgilWiNGOv1gNOgN0/Rj3nsDWQ2gnmh+Pqe2zfjQtctm6zIb9Ck16lA6QzjrEXAqfXFMUS59xv+ZRXy+wNmNEQ8496LCe3m5mRYCGAYEf7oKiTyFbx6lI0yzs57qFklfEWkZKATEjn219zDp3VHCjoEAR0uH4jSH04MJiG7E52PlJ0yOCFtrxBCfFEQYv4NhGTKo/xJE2JaZxf9ycAfagglCeKf2LNDUdn6tEavZ2GWuA0KNe8QdsBmIBuWdGzKmUIZcsKzPTcyDdM3n8WULSAv7Om98/jnITZ6doryo/gW2G2JcKAyhcMXQGE6jvN5lPJnh+JX9ScZRDlydvB8gxy/gG9eeoXCGFQ5ljydf8LBsmf2NXtPjioz7rRfUkKWtCNQYfeisRicPoKcRvS/7HmO902ii/AQgyuBISArWDvIEgpgxvhxxFRgqr/VWBJKEFT3lCepk2s+xmmeu8VvAq2XUmPdsNsbxKZVpcwtKJ5LYohfae2Q/oxblKGUL/Vr4W0PrfH0Z1s4VIFzA5geLhREPi
 EnrSE1Rz
 2WCUIgPQ+CefFHYuBpR0NW5H+wMC4OIcC1TcuP04g9V4Vmm/NE/cfxrBV33Ga88ocU8owgbmRip7WjRzq47PlNv0s9hUwxSpMbJPLeUt2zDRtTCNXRUzfP8RY7gySfco4muttXWUhGj8VaWdEDEriM0hNPZcLu89zGTiA3ohiB3ixp1JLiqgUpfvXlPmI9yZpZIVH5mgZ4meG+l9emrLXDQSPku0xlhc6HQnj0zwQa1opOj/MGwm6vNhV5EF1gR44CtWrKzDsSOS5URKMGy/fOZHdiP4Nm7WxwBsAndJQDwJVvxUUHfLH2cMYcCwONrg2FzmwdKJXgh586f8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/7 20:50, Arnd Bergmann wrote:
> On Fri, Nov 7, 2025, at 12:44, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>> On Fri,  7 Nov 2025 17:59:22 +0800, Huacai Chen wrote:
>>>
>>>    */
>>>   static inline pte_t *__pte_alloc_one_kernel_noprof(struct mm_struct *mm)
>>>   {
>>> -	struct ptdesc *ptdesc = pagetable_alloc_noprof(GFP_PGTABLE_KERNEL &
>>> -			~__GFP_HIGHMEM, 0);
>>> +	struct ptdesc *ptdesc = pagetable_alloc_noprof(GFP_PGTABLE_KERNEL, 0);
>>
>> I looked into the history and it seems you are right. This defensive pattern
>> was likely introduced by Vishal Moola in commit c787ae5[1].
> 
> Right, so not even so long ago, so we need to make sure we agree
> on a direction and don't send opposite patches in the name of
> cleanups.

Yes, better to get on the same page now than to have conflicting
cleanups down the line ;)

> 
>> After this cleanup, would it make sense to add a BUILD_BUG_ON() somewhere
>> to check that __GFP_HIGHMEM is not present in GFP_PGTABLE_KERNEL and
>> GFP_PGTABLE_USER? This would prevent any future regression ;)
>>
>> Just a thought ...
> 
> I think we can go either way here, but I'd tend towards not
> adding more checks but instead removing any mention of __GFP_HIGHMEM
> that we can show is either pointless or can be avoided, with

Makes sense to me :)

> the goal of having only a small number of actual highmem
> allocations remaining in places we do care about (normal
> page cache, zram, possibly huge pages).

Right! That's the ideal end state. Making the code cleaner and
the intention clearer ;p

Cheers,
Lance

