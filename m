Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77A1FC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 06:15:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 371186B0005; Mon, 13 Jul 2026 02:15:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 321EC6B0088; Mon, 13 Jul 2026 02:15:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 238BD6B008A; Mon, 13 Jul 2026 02:15:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED97E6B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 02:15:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 65BD916A04A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:15:24 +0000 (UTC)
X-FDA: 84982741368.02.E3BF8E1
Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.8])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7A87E40007
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:15:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=126.com header.s=s110527 header.b=JURd2NP0;
	spf=pass (imf07.hostedemail.com: domain of zhongling0719@126.com designates 220.197.31.8 as permitted sender) smtp.mailfrom=zhongling0719@126.com;
	dmarc=pass (policy=none) header.from=126.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783923322;
	b=pxfINK9DrsFLLLzsA76AhN7oQigpctsikBc2hJ5Mj3B3RYQ0jkT44PbaZBd5t5lb7nzUou
	Mm/4qUKTDznYBW0ejDWdM8bjkxRn2cTnFpJsA7rDUhgz65/XOLK9Y5dHnEjkj31zUtIirn
	0o06gtN8N2q/hn11L5ERz76wYC13hoY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=126.com header.s=s110527 header.b=JURd2NP0;
	spf=pass (imf07.hostedemail.com: domain of zhongling0719@126.com designates 220.197.31.8 as permitted sender) smtp.mailfrom=zhongling0719@126.com;
	dmarc=pass (policy=none) header.from=126.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783923322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vuKe8obP3PPRho0ooKW9/QhnrwO8R0l3sZh6B7h7Ymo=;
	b=PlHH+zPpT3sYTLknYGsNxC4smRUnmNhzl70Nk0rBLMugmG2Rm+yZAGJZA2qAJ0VJNBbyTZ
	VqfApJW7EL/9QpeSxugpuqY5ZlFomHri8R3JNv7XZEB6tjhJkPv3TJZJcBW3uHcVN0/u+L
	/xQR9iUqdGIhalFjLtKAn2Kkrh7rWwQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Message-ID:Date:From:MIME-Version:To:Subject:
	Content-Type; bh=vuKe8obP3PPRho0ooKW9/QhnrwO8R0l3sZh6B7h7Ymo=;
	b=JURd2NP03aYq1nnqLajFaCGjFGs5JVBTC81Hd1Peh1Qcc4cTT4YEOIu5wrRlSr
	EfJpBQfUTTzxa2g33/wGyBzRbEwWb+XKGvsP0rSwm8l0ToXoSn5eLcodbfwODOmp
	RcLpg8cv7RmabiK0CLumdMYBsizUUQG1XWIW/zw7Btbdw=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wC3b5NUglRq33tmDA--.15770S2;
	Mon, 13 Jul 2026 14:14:45 +0800 (CST)
Message-ID: <6A548241.8080802@126.com>
Date: Mon, 13 Jul 2026 14:14:25 +0800
From: Hongling Zeng <zhongling0719@126.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Harry Yoo <harry@kernel.org>, vbabka@kernel.org, 
 akpm@linux-foundation.org, hao.li@linux.dev, cl@gentwo.org, 
 rientjes@google.com, roman.gushchin@linux.dev, vdavydov.dev@gmail.com, 
 davej@fedoraproject.org
CC: Hongling Zeng <zenghongling@kylinos.cn>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slub: fix kobject leak in sysfs_slab_add error path
References: <20260713055829.127864-1-zenghongling@kylinos.cn> <bbadc488-e5b1-4868-9da8-26e2cecd93b2@kernel.org>
In-Reply-To: <bbadc488-e5b1-4868-9da8-26e2cecd93b2@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wC3b5NUglRq33tmDA--.15770S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJr4xZrW8try3Wr1fZrWUJwb_yoW8Aw4Dpr
	9xXa47KFZrGa1xKwsrX3W8W34ru395JFs8GF4Fgw40krn3uF18tr4xKF9rZFyDCr48Ga17
	Xa12yr90gF15CaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j4Hq7UUUUU=
X-Originating-IP: [112.64.161.44]
X-CM-SenderInfo: x2kr0wpolqwiqxrzqiyswou0bp/xtbBoRVlNmpUglXHBQAA3M
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7A87E40007
X-Stat-Signature: at9ufzbi59xscfmj6h3jhnuk4dye55n8
X-HE-Tag: 1783923321-50835
X-HE-Meta: U2FsdGVkX19izt+UqVQaDAR2fMrrB/gG9562LaMW+P79JooO8s26Tz7vceCCuMXE10ls1RtyUb7MeqBPcLE3orTTNM07qJZg7mFpxEinlMaG6yb3ZpdLTF8dlv2mqlVFXDFnVUv9cp8OZNClW1Cw9Z4CdaiSuPxBN0iwKKh2WiWHUNRgFaiL126C1+XifdnM0yQcDCbkjQOYiUxdiyjam44Bgk2/GMa49p59ChAsA/vByUI99jaOyKrk1VGkWSyPNSRAn3BAlPMnrPuNZ3c0BjB8ZbUp2iazlJh0GUQTr7UJzElB1Rsk+GU2+Z+jGU/78Syy6e19V3o0m2mDhKAX/5uhSbpzPc3+HFBObBjcO9GN/xDmdc8dzO/t+BXfV3MXGiusSO4TFIPiZ94X7zMgjN8V5De3OWR/ce2dI5JcUB8shRI/VcyJjzIhg/KbO927uUUfBfLBtBnxxq8XatdCfDvs/lRMMfvVlwKpHbSWO6PaKwM+mbvvCvb6LEF61QAuX85/Pr9OiU2apD4ivwJ4pO7COdqKjVMGzf133tpgCwMZ8t4qnglZGXuwrDKY6ZuPftCGeR8AmQpcJIFkQtLxwQEfTgTqaOj0sjoB6NV9K/fjBk067Hg12dBsCNDHF0lKz/IMqLBYXtcxvK/JUxcHpOK2I9AhDvX7DDXQl20JCpm//1S0y70PPYI53pd6fBoEFBPsP8N+y+QhkHuQAXLVMpWZBI6tqKf22AEGhg6Jmb5Fkn4HECFEiwBEt+5mYAssOw1woObJDrvQ0/GJfaKGig9WQ/G08dRI7j7FeJg3YqF5n7os164V0kX//e1vQuvL7YvzhgMC8OY1WSb9pTSUkfeMgnLuKWG+WPc/lRroeDvI+Ht+5TgR3maozqE/jrQ749PtkPzmfKCZezWLHltmRT2IM2Wgk8eNKFR/dX0+LWslOUKf7++l5e7t8VyxFylPAOu50pTme6Gj6XXkPdG
 iqlLfCrw
 vwRL2ZcYoyKMQ6e3p3Hyod4NArFccDKmemzCPQHzHgxHsAekkpKSAiOSPR4r90RgStjruF2gmxvGvSyEnVPQ7zBg+/Q4iFd0kjaQMLfCYbRNWggh+0ekyE3Iv1xbVWM6wBRbOmaClaLdW/dIQWHFNsOFs9qsyiNIHd2XvKTrDQfN7Ehq+1MYpcLBzROYp8ndtGt7r1MH9bQ8h3D0fef5KwTQxrSe+BW4UdO5nm7ATB+NGtjnl3hgIzDPaQSV7um9EU2OZfr1O1zNJrT1dPuWyaeD9kSTsEt7x25fLS5iLY8/qbthabspGiM8kOZEked3ZuKEVit6CyPsrDZuWG8vbRghHzIJbk5hntcDnSNfAYCVUodnpR/7V7pmdMLNMssKkm9A2kZFVTEzXhGyTfxYvv+8xSGp1dUZK2u15mkRGsWsoJAOuRk9ee91ogyg4C4FQZ8i0+dOHiNlWS3t6KQqOwnlnl0mQdDLFgGvLih4H4E8Krw8RdJkf6BHU9XMYKpJgT2Oxn89eB0ZZxQV7i7WX+ztK58e1DjbKFLTneHTIN5NumkVfjEHPwe3f/iZodTwMJGbMaYI3WPqKFWU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026年07月13日 14:07, Harry Yoo 写道:
>
> On 7/13/26 2:58 PM, Hongling Zeng wrote:
>> When kobject_init_and_add() fails in sysfs_slab_add(), the kobject
>> is not properly cleaned up, causing a memory leak.
>>
>> According to the kobject API documentation, when kobject_init_and_add()
>> returns an error, the caller must call kobject_put() to properly clean
>> up the memory associated with the object. The current code only frees
>> the 'name' string but forgets to release the kobject reference.
> This was intentional, please see commit 2420baa8e046 ("mm/slab: Allow
> cache creation to proceed even if sysfs registration fails").
   Thank you for the clarification. I see now that this was an intentional
   design choice to allow cache creation to proceed even when sysfs
   registration fails.

>> Fix this by calling kobject_put() before jumping to the error label.
>>
>> Fixes: 54b6a731025f ("slub: fix leak of 'name' in sysfs_slab_add")
>> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
>> ---
>
> Uh, there was a similar attempt recently...
>
> https://lore.kernel.org/linux-mm/gimwkjjpvwu2sg5625b3eeatw2vhv7rs6enm3vepdduhcefbf5@xen5iec7sn3z
>
> Sounds like we need a comment saying it is intentional!
>
  Good idea. Would a patch adding a comment like this be useful?
           err = kobject_init_and_add(&s->kobj, &slab_ktype, NULL, "%s", 
name);
   +       /*
   +        * Note: Intentionally not calling kobject_put() on error.
   +        *
   +        * The kobject release callback (slab_kmem_cache_release) would
   +        * free the entire kmem_cache structure. However, sysfs
   +        * registration failures are treated as non-fatal - the cache
   +        * continues to be used. See commit 2420baa8e046 ("mm/slab: Allow
   +        * cache creation to proceed even if sysfs registration fails").
   +        */
           if (err)
                   goto out;

Thanks!


