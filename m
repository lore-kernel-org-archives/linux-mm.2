Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC95BF34C49
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 13:46:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D3CD6B0089; Mon, 13 Apr 2026 09:46:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AA9D6B008A; Mon, 13 Apr 2026 09:46:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E7E86B0092; Mon, 13 Apr 2026 09:46:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2D6926B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:46:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CAE461380FE
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:46:14 +0000 (UTC)
X-FDA: 84653656668.16.5A78EEE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1CA03C0010
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:46:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W1c4yYbX;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776087973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sMs/jbfNU7MLESbr8LuYR5aB9Z4MTrt8GzJAYIUIKOQ=;
	b=IX7fLoAJ+delQ+LENxMNvd6oMSkcsuMVaFWtN4wIaHhczBzlsfUU2tennyoqvJVWIa+HKs
	767f0WnbL2IQjsVU9XFCjI4UjdDhYcbW3z8nXIh5ky7OXi+LqvwhPQQfHu8sK9TYeFUpgq
	2olShsUx8u96OnrtKLBtpuEEq84V3F8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W1c4yYbX;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776087973; a=rsa-sha256;
	cv=none;
	b=wPPkq98cG1eckTmAVzD6TP5X8HUsSdY++6tDzzzAuG7bGm5Jq5t9Q7DelPdcovDCMJRFfe
	HjhsSzXYQMxffyiuerD59sY1QffqC6H8jmeDe/ON3NFsGUy8DoDrLfLKO3AKTP2vgKyUsh
	HFFqTcCUpBebYWYipWznq4OU1nuz+DY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F0E7F60180;
	Mon, 13 Apr 2026 13:46:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1BFC2BCAF;
	Mon, 13 Apr 2026 13:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776087971;
	bh=oJltz7AJrAszH5NkylMptNLavhPpBeWeTGj56+4UuNQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=W1c4yYbXInfelp0eUQAv9gO8+XT0Sbrv81Gm0Adb5EvlP79aa60vW1qyaRs6863hq
	 ywlFwnEXs2N+Csj1t8AT44QeeKBJG/F49Idi2q4rc2RmYot0SX7HMiTlvtWvn/yDH+
	 7trrgahjvxasFZ1G1mSZHuMwpN/FLXdUKO5A3DE4xduSAFmVqypbzmuyI1rt6S5Skg
	 mnVOocE28OqrI3sV0A1xJA4AMsFJUmV+SiC9+WzESG+evlqCHSH4Q/iOf94U+BkWPk
	 AcZh4PrKZrOg/knioNZ+bkeabHdk27YLf4Gl2MWAVIr2/8lUMYASANuBHtyTuYAsV9
	 CyYJUfeUbdazw==
Message-ID: <ed8cf7e9-4271-48ab-a410-d7c0e2832020@kernel.org>
Date: Mon, 13 Apr 2026 15:45:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [patch 14/38] slub: Use prandom instead of get_cycles()
Content-Language: en-US
To: hu.shengming@zte.com.cn, harry@kernel.org
Cc: tglx@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 arnd@arndb.de, x86@kernel.org, baolu.lu@linux.intel.com,
 iommu@lists.linux.dev, m.grzeschik@pengutronix.de, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org, herbert@gondor.apana.org.au,
 linux-crypto@vger.kernel.org, dwmw2@infradead.org, bernie@plugable.com,
 linux-fbdev@vger.kernel.org, tytso@mit.edu, linux-ext4@vger.kernel.org,
 akpm@linux-foundation.org, urezki@gmail.com, elver@google.com,
 dvyukov@google.com, kasan-dev@googlegroups.com, ryabinin.a.a@gmail.com,
 t.sailer@alumni.ethz.ch, linux-hams@vger.kernel.org, Jason@zx2c4.com,
 richard.henderson@linaro.org, linux-alpha@vger.kernel.org,
 linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org,
 catalin.marinas@arm.com, chenhuacai@kernel.org, loongarch@lists.linux.dev,
 geert@linux-m68k.org, linux-m68k@lists.linux-m68k.org, dinguyen@kernel.org,
 jonas@southpole.se, linux-openrisc@vger.kernel.org, deller@gmx.de,
 linux-parisc@vger.kernel.org, mpe@ellerman.id.au,
 linuxppc-dev@lists.ozlabs.org, pjw@kernel.org,
 linux-riscv@lists.infradead.org, hca@linux.ibm.com,
 linux-s390@vger.kernel.org, davem@davemloft.net, sparclinux@vger.kernel.org,
 hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev
References: <20260413210252672ZfdcegJLJtyvlYdFAUBlr@zte.com.cn>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260413210252672ZfdcegJLJtyvlYdFAUBlr@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ib3tec3ns7i9ye54qxxipiaisyenr4b1
X-Rspamd-Queue-Id: 1CA03C0010
X-Rspamd-Server: rspam09
X-HE-Tag: 1776087972-467730
X-HE-Meta: U2FsdGVkX18kztQDqUQTbx7El5YBHZ7JN7Xduf7hkrdnxY8/5PvVlj/h5gUz6wyQtb93c+bnckbqibcutNUQwOk7nVuBoJFYyhGha9KbRv7XNAftqmFudJn3f13PgNcRMcjRSK5eSoochJBcnXfJA9FXCEthfQ7oGmR4SaBDlUX7/yz70/MH3pwzSb78r5wB+Fu33ucpnOyW3Rgz9T8Ximm4iLjZXRci2mlPJXVykmm/1hxwvfjmWWVOxBXmyxnRjC8AkTx9LfXTs/TMQfvSgNnincKo7Xn+HkZZNcVrWHTg9zu4KwzWrZ21dyto8Af73yEXYMEdYk9fyJmYZcXttcR8VYFfNX8cKWUKa52oi9XIUyomk0LPE26WfQyAf0ONEM4RQoPiHlqTPLydJ5hY33WZIaQykRgiwVvLoCQW+4e3qI1d/3R/+MUn8NLEeCItw3RpJqScXhBjeoKA5zbUov8G/IjTrhDomK3q26IkBqZk+ZukibT2rzhbr2PC81OtfPBjSQogWhuwUYciWOVE1cU9W+pU9nEqMqLBlr8xqYSoo4oAGPqJWrXOBtVv1gYM+znk+rTf1WV+k/VvkKa/pEYVemAAQKIc8xp9z3Mm+/M8iKTVvglN2etzdAtxJ/FLIm33tb8btTICzaAKCSqap7OuDuZQ7ks79VYNt0iCjx0JL6hdouuxvMAWCn6BOTIUxteipZNzO1R2APWGQIlRMopfLYznuRAeAuNfUc4oY6qxh6xtfbSBiAZGhoQlCH8UduXwmaiu9MkqmDZMOfwwdM0CzAcLOTpdiXXklRF4JRvOZ5xPJCNw1d9OWkiIvgiFPYJRjB1Dcvzd3hS26PnObYozYQU+qkH5G1HR4LiEhZEhBnDwSmMTyHtWgixFA79VZZePQj4R5Cq9BnPSVitcbyj4xfYChzyEBpqlAAg/WCDKeCPsyc7PAvfGTB+nQ+4oZb1b+V7R26n1EBh4X0G
 RrgOLIOH
 QBZPmE7KlzEm14Ee/JP7/rZdqbp9qdtZRf1/H/VGKUlOGRbj1viynZqiKzJz8/hE6bheNuGXjArdyaOuEx/ODPdgyP891py23BlELH7NS1oJWlzW7PZhHgbzCUh2u0sNIPYYIflPjbEOH3gO2JWpi2LY2WVCDTb2fjXDyeMjLlwTFlNTpKrqoDVe+GAtR7uf/XKVwOc3yOlkS4SK5f2gWPf/59yaSi7tZeO5Gb8Mxaf4gbgmySaLb8Gt9ovt2zQGk5l8F7u/t5KtNIjjbKVvz9CSnmKfo1FcjxYpd5PNkdIWB1/L1JtF0tXe8clRGtRoaQ+p8g70zKdxPCk1KJFXVr0SQc/PMZ8lOOxFVpaW+BsmJ9q2wmFci8K2WcTaTBE5clSRHrTiyND+FmUAerXHuf2wzfone8ZwYYyCxwWnoU0CIKHrtOVydHPDQBnnwDZ8rNrLROEjqtbweljBAOoem2Yhxx/yLXLcQrtMbDhNSASKsrGwUHRRHJFjQoWR0zLL8E7dOPC8VCxeUP3Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/13/26 15:02, hu.shengming@zte.com.cn wrote:
> Harry wrote:
>> [Resending after fixing broken email headers]
>> 
>> On Fri, Apr 10, 2026 at 02:19:37PM +0200, Thomas Gleixner wrote:
>> > The decision whether to scan remote nodes is based on a 'random' number
>> > retrieved via get_cycles(). get_cycles() is about to be removed.
>> > 
>> > There is already prandom state in the code, so use that instead.
>> > 
>> > Signed-off-by: Thomas Gleixner <tglx@kernel.org>
>> > Cc: Vlastimil Babka <vbabka@kernel.org>
>> > Cc: linux-mm@kvack.org
>> > ---
>> 
>> Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
>> 
>> Is this for this merge window?

I'd say it's not intended for 7.1 as it's not in -next and v1 was posted
just before the merge window.

>> This may conflict with upcoming changes on freelist shuffling [1]
>> (not queued for slab/for-next yet though), but it should be easy to
>> resolve.

Indeed, it's a simple conflict.

> 
> Hi Harry,
> 
> Would you like me to wait for this patch to land linux-next and then
> rebase and send v6 on top?

Just send it now based same as previously so we can finish the reviews, and
we'll deal with it after rc1.


