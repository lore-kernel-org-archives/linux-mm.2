Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DFA1606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 10:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=NQHo0OpC
Received: by kanga.kvack.org (Postfix)
	id 204FF6B05B5; Wed, 11 Nov 2026 05:25:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DC1F6B05B6; Wed, 11 Nov 2026 05:25:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 119B76B05B7; Wed, 11 Nov 2026 05:25:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E70226B05B5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 05:25:00 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A030A025C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:25:00 +0000 (UTC)
X-FDA: 85422455160.02.C38B4A6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8880A40003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:24:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NQHo0OpC;
	spf=pass (imf12.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794392698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JnH6E3m3OytwHtdIb9v7wOGuBamv9Irg/1uvzHNiYxQ=;
	b=sj1GsQn0C04ZSB9fl1R0/Xk8b8nYV8fT9UeiXOJt1T+bmasnCmu/6YI95Qb2fwifb/Z8Sy
	M6CqL4xnQUolNVjzthWnnLwLu66ldm+VZNQfc68IL+ZGzLx4htbP2Xa9rlquIHd1PVd2Jb
	katrueXjlpslO3F7XplDTlphgr2TRCU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794392698;
	b=uIWWPNba7CS8LcmO58ggOUGSTsok79s3/NVWWDFTRvW7LPdOBcFG4eOkm8rld/KJQZlMdI
	9izuwstXS8T/jQ6monsqfxnPsnjNZwtAB5244Q4yV6Rh4qcd//T4NotSufUCHze9Ronf4f
	CWpljFoEd6mXWRnAeKNQ6GuHpR87xSQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NQHo0OpC;
	spf=pass (imf12.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A4FF51576;
	Wed, 11 Nov 2026 02:24:54 -0800 (PST)
Received: from [10.57.63.24] (unknown [10.57.63.24])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5293A3F632;
	Wed, 11 Nov 2026 02:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794392697; bh=fS7+dm1lVrR3kORF0oVfw8gO0FZtBp9Mzni64/2uajE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NQHo0OpCNlDTSyVwt9AskltMoLOC5DmzwE0FLofcyuQKXSh1OQ1LRblNqRoVCwt5D
	 47za/dhQFqhiljNKutssaQNItZ5vVOwNbXueiF1wf174d18hrJ0Dw+pX/osNlH1KtV
	 wvmVCbGhtttzbT1gy+aQN1BIJ3boc+tDGe7M8IOI=
Message-ID: <0dcf6c71-9584-48c8-86ba-43b9bda0d16f@arm.com>
Date: Wed, 11 Nov 2026 11:24:44 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v10 01/22] mm: Introduce kpkeys
To: sashiko-reviews@lists.linux.dev
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Ard Biesheuvel <ardb+git@google.com>, Andy Lutomirski <luto@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org, x86@kernel.org,
 Ira Weiny <iweiny@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
 <20261109-kpkeys-v10-1-aa6c4d9603bc@arm.com>
 <sashiko-outbox-207315@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <sashiko-outbox-207315@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 6e99szdu9hcy3e7jynrore3wo17cpf8t
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8880A40003
X-Rspam-User: 
X-HE-Tag: 1794392698-989159
X-HE-Meta: U2FsdGVkX1+J9iZhtRRkdTJHm4DYxzgfRM/sxgRDG+BJCxEmzUkchDTivmEtsPt9zPueOuqMHw/9dItdXsDolqPKoAEtX9eqimCTKlfsTZIeF+IZkZXlRIzgOhPRPuWZEXyil4ShVn/77jD1OqEDi2hKxpKVzUxoad+OyjKRRYVjZr9aE0KokhSCx/1uJz1F8Qx87t+voaPx5piL1EhVoo5IBfEy2rVppvKM+dn2PYK68WEjHvudwGNMx2U/fJq2EUT4cc8nro7ZMmwHtW6xyPkgw5riP7krFtga3FIfWTxLiklD/L5RkuIPFcF3i//4UW91ema5s/JMHIzTNoNRbM25i1K1XZCKuwrqPe26DCSaTnHD5cR53kJe+iKJqV/mucovGg1dt/DGA9sp/TW0/QM6xrOLwz1mvSMFEd3/1botOYuby9SYGaTOZsJhUW6vKuJKXAl+FVbUPl9q9b+uxJorxiZTlI/RpEC+zb/KFkcHKno7WuJcSFZYUqk1TSXUoTjkmqiU2FsXzjjzCYMgV/meM78zqwEHvkD3qp/5c0So2DwzRWD1OuPrGFW0z4WGJoWrJAwquJtEKQI5zkFMjd8SucFIawBBKZl0MYHd2THc24mZBubqTIyRQdgTCfgPTxboRMcL4JXP6X9JuOSZjFLozPtLaySn3rVwpQfcaB9KSF87aWVKne5MWTchY4L5ks/hlrG3Zg3UyWJudwPlidezSZ/Quqk+EXkH17VyYI9oJYodcTvs/pGhb2tfoDCiOndJcZZx8gBDhRuuK+BpCkmKrO68lMuI/rUJWf+tr0RFAMSMmutujnW1pZKqcCYl37y7lv/xiEr8k+klJYq6PgcHmgqH9PUpYH6/xj2ps4pDz0BShkTOxDXENYJWL41dlU/HEFvo0QyhsNVHxQ/AItKmoa11dE8Zoyd1H4y1VWvvZLmRz1l2SsVV852NDw/kBcAw4ZVaAVgIpmoKH11
 l3PyIRYj
 Woc+nU9EFsjxdYVsvs1z1VVKZSNtOEGFXZWdpGl38dNqPAcR6KKea4meyluxtpNPtRfoiNLwvAoilCh0eORJo++pSHVUzHsdf/Ee3jUh3BDnHa1Gui13zxoRKx5ftn1OiB9KjNvXVYxvaVXn+tKpoQ6fCPEB/0D2w/xafIPKUw3/VRmIJBGt90jUnNVYo1XJlwm6gUOZjy42RrxOjcgGdl6sB+fjvNVRXpCCD19/n1N3YpvK4+aFHWSgs5cpZOlL6IBm0JKtvXZ1SS3I80UCPppPNgif3sL0Mo+x/lg34yBDWcjThcTqmAmNmnJ1Ae6aaO9Aa+ZkFRRRFSSoZw/uQ1p05ziohYdVVMBCSGSW+thiTYsD9Fmp6VT4yVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/11/2026 17:02, sashiko-bot@kernel.org wrote:
>> [...]
>>
>> +/**
>> + * KPKEYS_GUARD_COND() - helper to define a guard type that conditionally
>> + *                       switches to a given kpkeys context
>> + * @name: the name of the guard type
>> + * @ctx: the kpkeys context to switch to
>> + * @cond: an expression that is evaluated as condition
>> + *
>> + * Define a guard type that switches to @ctx if @cond evaluates to true,
>> + * and does nothing otherwise.
>> + */
>> +#define KPKEYS_GUARD_COND(name, ctx, cond)				\
>> +	__DEFINE_CLASS_IS_CONDITIONAL(name, false);			\
>> +	DEFINE_CLASS(name, struct kpkeys_state,				\
>> +		     kpkeys_leave_context(&_T),				\
>> +		     (cond) ? kpkeys_enter_context(ctx) :		\
>> +			      (struct kpkeys_state) {}, void);		\
>> +	static inline							\
>> +	void *class_##name##_lock_ptr(struct kpkeys_state *_T)		\
>> +	{ return _T; }
> [Severity: Low]
> Could KPKEYS_GUARD_NOOP() and KPKEYS_GUARD_COND() use
> DEFINE_CLASS_IS_UNCONDITIONAL(name) after DEFINE_CLASS() instead of
> open-coding __DEFINE_CLASS_IS_CONDITIONAL() and class_##name##_lock_ptr()?
> include/linux/cleanup.h already provides DEFINE_CLASS_IS_UNCONDITIONAL() for
> this purpose, avoiding reliance on internal cleanup.h helpers.

Agreed, that's the helper I was looking for but it didn't exist when I
first wrote this code!

- Kevin

