Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A955F419A0
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 13:01:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC3896B0088; Wed, 15 Apr 2026 09:01:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9AFA6B0092; Wed, 15 Apr 2026 09:01:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B0C76B0095; Wed, 15 Apr 2026 09:01:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 887396B0088
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 09:01:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 231DC1604AA
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 13:01:03 +0000 (UTC)
X-FDA: 84660800406.30.E6F6EBA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 28C24140027
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 13:01:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jb+0DT4W;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776258061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lLSvvy9qa8zWSMzTnss/XEjyfCf5hC74NXNaC32e3Dc=;
	b=5zv8GLM8+RUEAfSaWXmrBxLDb3VMiGn6I2KMFhzFMjDjEts9NtFuT/H0VgjcPMir2w14h0
	ArVoHJ65HpOr1S2s2wLff9IImMsqIqQxuLHegpEChGX4R966IcyP/Hc6qD/cyyjnkM0wrM
	7L427oMvwMD3pEoayOUBFajHwD6va/c=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jb+0DT4W;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776258061; a=rsa-sha256;
	cv=none;
	b=XOMCBqgvZ4h7S6WtvxhGDPrFMjaPdZIdvQII6wA+aZio9wGe6LDhe9sdhCId2hYvSbmXLZ
	nJAK55tCyzYO+DBUV85GdyVeK6B6Yw8fqUyWKjGSmkQsXKbcWj+a9spQ44dYVy7eVgXZMj
	EDVzlQy6+Hu1AX0OYa6FCC6WE+DW01o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D9B33437F8;
	Wed, 15 Apr 2026 13:00:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ECE5C19424;
	Wed, 15 Apr 2026 13:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776258059;
	bh=R9She/fty570ixfUUkm+hiI2Yw0EuREkb6cYfJweZ5Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Jb+0DT4W1wA4KEIVY4FoTtbFdUSZtISD7worO4gRLlYY13CxQryM6AF6d0YWZbYzF
	 LyX3FSawfZ0kMCSA4gRZSBZHETiCihTbBLv/EP9F1CduZHloB/MmIg5Ui7E/EouNKn
	 TeHzhu0uercSUy9wjPxl5S4QDwqFdGmdvmn6wfms/pbWEDnjVLyCz2CpziNgPzIJ6U
	 9lyu2kDRnQ8Q38D98pATzyqu4XMt0IBR4d44V2436QrK3tQsQUdmouWn62qrqXx3kE
	 btgIr4R3pdICtncO7p14CMOiRN4I88Pu2GDKcg/lLWRmMr8FkvK1VZqsV94h3ZAIFU
	 /EQQgy7FE+paQ==
Message-ID: <eaca640b-5006-489b-8b2d-148a3c4073da@kernel.org>
Date: Wed, 15 Apr 2026 15:00:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 01/30] mm: Introduce kpkeys
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yang Shi <yang@os.amperecomputing.com>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
 <20260227175518.3728055-2-kevin.brodsky@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260227175518.3728055-2-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 28C24140027
X-Stat-Signature: bdup1kahuxgpbu4hpxac6depam9aii7t
X-Rspamd-Server: rspam06
X-HE-Tag: 1776258060-781169
X-HE-Meta: U2FsdGVkX1+9en/ZV5FOWd926Du5XeF1BhiVR4kSm1z/uZBafnZkoRqQE6HJ36Mdri559IhloisrTi33DHbmiYltmGs+mUDu5wNc8b2lZRQ1X1yJmRZZTBToLy9cOnZ164dIbKe+GteAfauQOIiSJwY2/lW80VWps5lGS1NoLgQaQzoCQzM6QBt9/MsRHdbn0Dmn6nFgegztmT64Kw7Pc7QToqm2uXWMoyBQVOYGRCrr3K/1l8w8ZY7Jw8JhA0cFFGdz+Cuy/Qxjd1HwjxcAxJ494dbwcjBPj6JDf+7dw+RKO2Ze+PBRoFOYvU19SFK8rhO9QQYZTzRhCMFvp3wl6/Y+RhFeEmmMq7593wJNhF88jlF2SR7g3dRhYGKsTyeE0Y3ZurjgFjTvGcwtP557n3kuTlR4uBpXnDY43sQztxyD32rnJ6HcXo5/TuZxlc4FJYbsidpLFcjxjmgnxYvHQVoyA2m2heBYKWdGMOxuuQ7wsNRbFiO6woQgjCJ87cven48K0uD69EFPVnk5oHjRkvYx7MASTrVRo/pa/LbIv9SoNJMOjoHUkmh0ISS7xo83dN3MfNd4V2FXEKPJAKC6AoGZiRnkzf1Xt2TILzGcmVTiNvpIO2fhA3V7lTq0t6swtw+iUojfqYn44IYMzpx4S6xhxMvY9g3HEHNPwE4Knm519ir0yX6PT70coZNGVZqK+L8dRdINJxH9AJAl50FC+94zihOTbCj4/W9dWiAd6Q9+FuPYpYvfVz6ppEak3+RAxSVGBBpZ+HgQZ0RniFNOpLRsaiqQvGr2OQv5CqBSA0odJU0YmCDOSa6xMhgnOMT/6NrOBIdkqOBWVoTl1zAnBkOayvK7nbQNVQbQT5xlcVPWU6FX4L7hnZfai8UUGJ/t3t2i6TyTVeaDioDf2Htd7ZeSP0DCjyBU32FNxYI+DJXQ/nZgJ94yxAag+n639p5qRFXus+Jgudc/UyEvpgy
 p4w0AmW9
 II4hXcQw9pN2V8mS1UpKaPJc8eqsZzYFW/A571hs+NzZhl2YgYj0cnwKEo3aGBk9e4Ua+BmPOb8SgsjTqUh9Z4i8URyxkH4hsRHP2zR0+qQfzYphmmVCTkIbYPpJm+cakiASNoFVM5w+D+i4cPqnB8KnQEeBvXZGJML7RoyXpg4jysevWFRk91IQnocFRS4HV7xYndrc+kXSfYvEWL68zxqiS7aNwj9tX45WQ96bjDNNqLi4QLDuWYwS6BSj352iAisDz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 18:54, Kevin Brodsky wrote:
> kpkeys is a simple framework to enable the use of protection keys
> (pkeys) to harden the kernel itself. This patch introduces the basic
> API in <linux/kpkeys.h>: a couple of functions to set and restore
> the pkey register and macros to define guard objects.
> 
> kpkeys introduces a new concept on top of pkeys: the kpkeys level.
> Each level is associated to a set of permissions for the pkeys
> managed by the kpkeys framework. kpkeys_set_level(lvl) sets those
> permissions according to lvl, and returns the original pkey
> register, to be later restored by kpkeys_restore_pkey_reg(). To
> start with, only KPKEYS_LVL_DEFAULT is available, which is meant
> to grant RW access to KPKEYS_PKEY_DEFAULT (i.e. all memory since
> this is the only available pkey for now).
> 
> Because each architecture implementing pkeys uses a different
> representation for the pkey register, and may reserve certain pkeys
> for specific uses, support for kpkeys must be explicitly indicated
> by selecting ARCH_HAS_KPKEYS and defining the following functions in
> <asm/kpkeys.h>, in addition to the macros provided in
> <asm-generic/kpkeys.h>:

I don't quite understand the reason for using levels. Levels sounds like
it would all be in some ordered fashion, where higher levels have access
to lower levels.

Think of that as a key that can unlock all "lower" locks, not just a
single lock.

Then, the question is about the ordering once we introduce new
keys/locks. With two, it obviously doesn't matter :)

So naturally I wonder whether levels is really the right abstraction
here, and why we are not simply using "distinct" keys, like

KPKEY_DEFAULT
KPKEY_PGTABLE
KPKEY_SUPER_SECRET1
KPKEY_SUPER_SECRET2

Is it because you want KPKEY_PGTABLE also be able to write to KPKEY_DEFAULT?

But how would you handle KPKEY_SUPER_SECRET1 and KPKEY_SUPER_SECRET2 then?

-- 
Cheers,

David

