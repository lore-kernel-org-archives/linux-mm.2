Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78F99C982C3
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 15:24:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FAA36B0098; Wed, 16 Sep 2026 11:24:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AA806B009B; Wed, 16 Sep 2026 11:24:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 799796B009D; Wed, 16 Sep 2026 11:24:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DB246B0098
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:24:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC1F1A474F
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:24:50 +0000 (UTC)
X-FDA: 85219997940.08.66EFC70
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 01F1E80007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:24:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XBrtQTwm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789572289;
	b=JzU4flG37BKZEao/bJQ7glEI/tKCPYflM2E81NLCCrH3V0eY79pNBlPJFP0zuOPxEZby1N
	xLBi0IstfI0gGtHC7S4gqFdJRz4+Xm6pjOLJj35FgAt+gHun2ghOnEVBP48c5akiP6rbC+
	yePyDNZestuRVxeT9y2OIoIMQT5jf8U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XBrtQTwm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789572289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wWgPjuwbSc5jEaUJNC+40afnrjI/axqY8ku0ks4GRGw=;
	b=y9yBK6ulgkergQnqHKZy38W4+OteGMY0aJ6DWzXvJ3inIzdJqGrvLtlxx3d19uDtdW+pzH
	5gYohhhkW4PCa851fN8GXxjak95rwxQuLuyYXBoo4IQj/EhJBMg46I2uAedsLF8qiy6A6G
	z7Nbbq5jGc8EJUoNQoKjPLF1AMcSUZw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 77DE8602CB;
	Wed, 16 Sep 2026 15:24:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC801F000FF;
	Wed, 16 Sep 2026 15:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789572288;
	bh=wWgPjuwbSc5jEaUJNC+40afnrjI/axqY8ku0ks4GRGw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XBrtQTwmgzc0YQljPdNaZA5nL0v3jtXla+a4z5LqoNelKQGVXFAJ86UzAtLXCD37s
	 UuSB7cX/bNdR+SJyZ5zpn/oDwzjJuCxffoiLhr4wiX1E57xbsDEEwJRe5CnMHhpDEH
	 kPzFTYIvPuBWPTpCe/auL4cgftfUtH1sfWdJ4EHbazoCN6LnuW1c46aLbGMS+/T+Hl
	 VPBKJgxhI/6Xp8IRHJkKtw+8xvWbCRdpx9RssJlfdA1lJ07EdErvzoapOGN341+/Qi
	 0d7wPbHBNs20JE1/Eshk0a1yIaTklx1Aucsr6hPZbwmdz4JOBAeGNHLPU7f7lBlVDY
	 lYw0HMu8sfnsg==
Message-ID: <4fadcda7-d96a-4cd9-9b0f-5d387b6f82af@kernel.org>
Date: Wed, 16 Sep 2026 17:24:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/madvise: reclaim isolated folios if PTE restart fails
To: Gregory Price <gourry@gourry.net>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org,
 jannh@google.com, wangjiexun@tinylab.org,
 sashiko-bot <sashiko-bot@kernel.org>, stable@vger.kernel.org
References: <20260912110832.3203902-1-gourry@gourry.net>
 <aqloB0zm3RjJ47m1@gremlin> <aql65IhMobL5Al9B@gourry-fedora-PF4VCD3F>
 <aqqTbGMJL86TzDrf@gremlin> <aqqbB_nFAOGenDhy@gourry-fedora-PF4VCD3F>
 <aqqjW5dpyznijYLh@gremlin> <aqqk89oTigJ9LS2N@gourry-fedora-PF4VCD3F>
 <5437871c-d9ee-49d2-b24f-965c73c29c3e@kernel.org>
 <aqquDtEZL1ndymGN@gourry-fedora-PF4VCD3F>
 <46d923e6-5724-4df6-b0d5-8dda7c547f6e@kernel.org>
 <aqqyhkZqcXDUrzeb@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqqyhkZqcXDUrzeb@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 01F1E80007
X-Stat-Signature: ybaodfk6wtfj5u3gem9n65grd7767aea
X-HE-Tag: 1789572288-412771
X-HE-Meta: U2FsdGVkX19vNw0vLj30kt6xHnxushobVPZOrWgqYZWdcOsDTJUk7Zvt5aFgdpOly3rNT6NbgMpl28M8bevg0fD32bQFdhmjKUxEUjCDsB+aKPRRiUF1Fw9U6TWhQbu2xL1TUMWohz3eOghrzbb/BIsx/HAwpQG0PCE/Szf7YF1PrV9pq9YInxY12bTVavmj8X+gudmMKg5JcvYXBmFPVyMVBOrjc+fIk05/NoADUiAeZcWZy1yjSD9JA3lV+so7j50qTOe7i6ugF1UUnCyv7s3z8pCkTUUhjZCKVCzSfzv16iu3kz7jJrfhNj8DOPItw5spSZmHTHA1uefxHwXnA8cLqWNHQQDOWhgaVFnNLIppH9y663Xb8cjGMrhd8aPArfRcV8WN7qDEammq3xP4JflwNnTs1X8Yj+DfynaVajEZg7flcdb7gMQgBliZmxjE27p4faRH+g0JcxwAmeG+5F56Au0nXH6nR+x6sMI3x7ClkmQ8JzQ9mWrKyVzeYwIgGqAyNv3XXUMZwvizt3BQL4eSaheivd8egWglDpK/DQ0rlOW6OXA8UtA2sPXLzuVGzDalUh4PoZClOx8mWQg7YNZ8xqLc9HhYCj43eURBZjUb5Y/2TMa6M+zbE4sMxnEfZiUyULrP8m14itpJMSk/WQB2Q2klcOjAsGugoU57yXqlrdYNHjDjqSUh80x/EtHuVGyqWvQLb78o33lkkWZhs+mPyJruDu4wj49ymxIlrXIyom5l++xYq/eVUMzyNEn97pIgo97UqCkdnWs+ic/cuxAOiTO1IYnGA+XuBuDGuGwwwCXek1gSzc36cevZ0qw47HUIpuENKT/d/ZLhN3NNg4+rLQ0wUlxa7CgFY44dYgZAQM+vqx2wxT+pcrUHezzW4x+7CTb3eMtOHBy3AIWXO7MXr3fOtzfD1yLyjWTGSypfJYus509JuVYCFugcLVWxtlv8QVHtnM75l3H1tLO
 UTw8Gs7P
 uL/+9PHDtchVFbG8yTKyeGEMVWBzjX5fM72eXTkz+mPCIhA4eRrmD28U/bYYr4w355YQTbWd5gjUJVzRfo2ZGfsCISxMVg/GSdrnZ73kc4ggEV+esUDkARGNxhwF3xlxuazRrskTYN2PB2XXQnVYwYUzBOLQmME5PzGQbm+vYpiSdD88/57J/rG9Znq6DN6gmrl0hDz1wWNV3vlfVpoBWT1xAbXp8phGkic3019o7XinO1TWlsUsf8HNMEq0uE3OLDgNr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/16/26 17:19, Gregory Price wrote:
> On Wed, Sep 16, 2026 at 04:59:32PM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> LLM go brrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr
>>
>> No schlop like that please, I don't want to hate my life
>>
> 
> You missed this part:
> 
> "I'm trying to be careful about not causing a bigger maintenance burden"
> 
> I wouldn't do that to you :]

I just wanted to make it very clear that I don't need another schlopped gigantic
patch series in my inbox that I'll mostly have to ignore because it's
un-reviewable ;)

-- 
Cheers,

David

