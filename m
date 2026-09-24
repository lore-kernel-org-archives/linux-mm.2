Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 702EFC98310
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 07:42:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BEB86B0093; Thu, 24 Sep 2026 03:42:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 795EE6B0095; Thu, 24 Sep 2026 03:42:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AB956B0099; Thu, 24 Sep 2026 03:42:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 400E46B0093
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:42:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B810F120242
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:42:04 +0000 (UTC)
X-FDA: 85247862168.02.899E445
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0AD6720007
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:42:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ES0zvcia;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790235723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gjt5XjrNKMQPzV/3UEe/LYYj4bdbaLRC10yKeAaf19s=;
	b=ch5vFf4AGlPTZ9ak7VKWosXhQKQ6itNH76Wv1VhxJKrX0SrWPaXAaab2vv78dWhLI1e+pU
	akL0KoFbhQgfOvkEdTaCsyJbWcXF5b4R8O9Bm87+iq1ymdfgh9c1f7k4HF0J7NpjcpyyXR
	pbd9rpvS5rHV36pL2tdpS4MpwCGuTpI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ES0zvcia;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790235723;
	b=vzUsH6HhrG98Z0GjwK87zftg1OHh/U3Oyi0suNqz64frFqsLIAt6G1J+5GZYH+1V6Ssnwp
	DhFVNgXgJ8zEQ3Qf162IH3SNj/Qp9wwZ7XdWzQTRuSkLXc6e/iNF5A87GJ6kAEghdgQQdF
	Bxy009kn9BZ1aLFIwqXgd5XiTuEHGZw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8335460209;
	Thu, 24 Sep 2026 07:42:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5FE81F000FF;
	Thu, 24 Sep 2026 07:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790235722;
	bh=Gjt5XjrNKMQPzV/3UEe/LYYj4bdbaLRC10yKeAaf19s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ES0zvciaohK0J9+7RmpXYjxpFv7LJFkSQIuMXxwQq8Fi5yRl1UkDmApnSBn553hSF
	 +tubvcCgI4Z24G/XvGoPi5Q6XubUAuvumyNyf6Oi1cIKeyfAemPWH7ZLaugspv+HCr
	 oxs6viXmtcxe3aP2U8mNykHgORNy/XdZLPA5ZZea9wk338T4ZGJuoUq3FjMY/BY865
	 ScNXtQAvn6n8kK3RGk5oc/v0nq293LYsMmBynLr8+9ymIQ0sTzy55ZkT+jkE6ms85c
	 NmBVz6PrZemA+tHQGrJ+yQvRCUbzKlUc9IO1Ib0JEyuyDTxZ+11wiCZ+ZITS/UCJuK
	 xQSW//hBZGheA==
Message-ID: <96d3c629-6c03-4924-97b2-565a04c5861d@kernel.org>
Date: Thu, 24 Sep 2026 09:41:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: Remove slab_folio()
Content-Language: en-US
To: Matthew Wilcox <willy@infradead.org>
Cc: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
References: <20260923183655.3364885-1-willy@infradead.org>
 <arQqdeTaYf08TYl0@thinkstation>
 <9bbdcace-0769-4391-9c97-e18e8a0fd207@kernel.org>
 <arQ5YjQbs3pd5-KS@casper.infradead.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <arQ5YjQbs3pd5-KS@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: agn1izi549tgxzqx43gn4j749798fa77
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0AD6720007
X-HE-Tag: 1790235722-440843
X-HE-Meta: U2FsdGVkX19vprUIKFNXMyPs+Meuzn0Q6AEvojStbLBRkG5NRjIbcslEuiaDfqa/ou0fB1UbeFRTZSm/eAnsaKKqKqt/HGYL4X8lv4MMrh6+cMeraZUhkwDZcK6h6Cap4j6b9juzNETB+9CtzYk2oMvwZ698Y1rkWLPqxJVtWT0P7KVJj/oOqDCiHFl5DiInClSmalACVmpAid9ZTA+lStMzfhUAmi1Sbp7XTCwnCUlXpOBEvfRfuZ+xDYsHpG5UOLAhUyWsqxWTXr+De1PgKTvWPfL+YsVegUQflpHYb8j6Cddww5eCHOaBeiH4CGqh7XE/Lu9b2bmRuESmHFNbA0Myk3tyh0a1AJbOO1igGBn91irz5wWs+TzZt+47Tc1XNl+VySgBRSiF3bdu4xkJG7Vu3hzAGWvxXTBz+McWpu/0BDwoOSaO45HJ6hk2UTX4AS4kMwaSZpXHiJxcp1uQdOZIYl18dK7OhzA3i6cuO/TUgTJVGTM98kA+hj8vjRnfXEviz8fPGLcMNfG0kfzYQ2ZQNiJZNmpMe8O/8ZNzuzxCt5Fv4+aPXthijbDzJMXNQg6qqwTVFjBxsT6eEwe6HTr4W8iw2y5oysSDTT/XWFiAaauUQalVX1GyQp/VSL8q0odmqai4peKcQ6jDfk48uVyi6nPm0sZ+wi1T1SIqjOI57U50XWz/A17EF8pCjOIPNrClJKHxGoTFx1ZIsCxRzYlcGdQdvd8HtnKDBxCRcbVM2wMUbV/xpnekZD5W/gk5mB5TRUhM2rkFailrF8gDlo/uwSX3NGNy955qY32PQLUDRhUNZPDeQzZFVSapOC08eQizR6+SA2fvx/LMMCfpNfdSUhaQvpjVpgzOGGDM4e+v5p1UsAQRcDgrlJCeN0PCVtmJ/e05s6Ajr6OClGnqXXg41ZRsRHzNyLEpyYrD4eDh9vT2a9++KgDrhumdxVrK6/VE7kj7tB05jAGRRcJ
 uvZ2Mmjm
 Ckg12JvvRFxAi55Wv5gWiedOTJH6g2aYZFnGTZrntlKa5Wg9I9n2Lyv9ziZ/sHHGx5jZbzGThYEXyaOZRkGyS6a+AkHM/p6eygEF7kYx7zlYggsdI8kpuI+BX8Wrzlinbkh5HKtXVROOcuPtdw4nstg+wRquGlwMmlWPYdhBvc4K/ff60BC2G/i+3Q8eLzas2CLecXQd1jdxbGe8k9RpVLqsOLZeE8KDI4Ij+mg8ouqlDalqneKXRzAITVUu30rxI0lT05GILQHlVNvZk4SRTS+OvrcBCp6BEzY9gPjVyAJwqzDKTf4pOQ6RYxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/26 22:41, Matthew Wilcox wrote:
> On Wed, Sep 23, 2026 at 10:11:06PM +0200, Vlastimil Babka (SUSE) wrote:
>> On 9/23/26 21:45, Harry Yoo wrote:
>> > With a tiny little nit:
>> > 
>> >> @@ -184,15 +169,16 @@ static inline struct slab *page_slab(const struct page *page)
>> >>   * slab_page - The first struct page allocated for a slab
>> >>   * @s: The slab.
>> >>   *
>> >> - * A convenience wrapper for converting slab to the first struct page of the
>> >> - * underlying folio, to communicate with code not yet converted to folio or
>> >> - * struct slab.
>> >> + * A convenience wrapper for returning the first page allocated to this slab.
>> >> + * to communicate with code not yet converted to struct slab.
>> >     * A convenience wrapper for returning the first "struct" page allocated to this
>> >     * "slab" to communicate with code not yet converted to struct slab.
>> >>   */
>> > 
>> > Perhaps you meant this?
> 
> My eyes are old and don't notice punctuation as well as they used to.
> What I meant was:
> 
>  * A convenience wrapper for returning the first page allocated to this slab.
>  * This is for the benefit of code not yet converted to struct slab.
> 
>> Yeah, and I wonder about the "code not yet converted" part, and if there's
>> anything we can still convert right now. What I can see among slab_page() users:
>> 
>> - slab_order() - we could probably add order (aliasing page's order for now)
>> to struct slab right now and that would be future-proof
> 
> That's trickier than you think because it's stored in the ->flags of
> the second page when PG_head is set.  When divorcing slab and page,
> it moves into struct slab, but we can't do that in advance.

Ah, I see.

>> But:
>> - slab_address() - I guess can only be converted once slab is divorced from
>> page?
> 
> Yeah, it becomes slab->virtual.
> 
>> - __kasan_poison_slab - same as above?
> 
> The loop calling page_kasan_tag_reset() makes me think kasan really
> wants a page here.
> 
>> - several VM_BUG_ON_PAGE() usages - same?
> 
> We could probably introduce a VM_BUG_ON_SLAB if you're interested.

Maybe not worth the effort.

>> - validate_slab_ptr() - same?
> 
> That'll change dramatically -- if we want to validate that a pointer
> really points to a slab object, we'll want to, er, ask if
> virt_to_slab() belongs to the slab slab.
> 
>> __free_slab() - same, obviously
> 
> Right.


