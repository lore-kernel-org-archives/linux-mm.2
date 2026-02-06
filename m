Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1AB5EB28F4
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 08:57:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28FD56B0089; Fri,  6 Feb 2026 03:57:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23DE96B0092; Fri,  6 Feb 2026 03:57:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 116936B0093; Fri,  6 Feb 2026 03:57:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F3D9E6B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 03:57:40 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9D32E59BE7
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 08:57:40 +0000 (UTC)
X-FDA: 84413428680.17.A7F1BCD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id ADDD6A0006
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 08:57:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M7ZGwqYS;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770368258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mEjvjjnoEQ8yPMVV9mpXh4oeJLivMQ0z9LltKg1l65U=;
	b=6hqIapsDc5/CNbkH1fiVSZ/aYV/Iq/AiNy0OgqCHUjw+LOEmWHMAgMtou45Z32/lfGV9cH
	KaoWUbV6fyhqFv5mg/MfsNdVSZce2Wyt5uiRQxTKc87X8Wd6hIRofi8iDNwns6PWxTc4Rs
	xg3OzgdgsYCTVFa1znRCmGvHjfxMXDA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M7ZGwqYS;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770368258; a=rsa-sha256;
	cv=none;
	b=2TNH6qlFDriu7vn3w7giD0IDBx9jyo6vT4KgPd7wLLzqdR2/6IuFNbkEq+HbRDzRUmWVhP
	kIG7mVNs9ixc1OY5Xenf7xeB0z/dzLx5zY1mEHNY+vvcZCzx5d4xpi2EMGCU8n6m5LiwKq
	DSm95D/QGdafEDiT7/p8cN729GCe06s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2943760010;
	Fri,  6 Feb 2026 08:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73BD8C116C6;
	Fri,  6 Feb 2026 08:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770368257;
	bh=BNqLlP1C2QQRYT3cauCuGbS6VIzB2UtD/mDklrJGgj0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=M7ZGwqYScqb8Vb44+aMn7oeXGgz0wzyTYSMrJWovuPJVLfzDZ5+VQYRZyGNdI1T4L
	 gjxRHBRW43XfrsPkGZVqk33JVi2ORXoymIZgeX5GwpSvTaFALlaGeINL0wgxGF5z0/
	 +Yh99nQNSrGO37lwdfaKHOvFypQQyOxdchEG029djyd8jjtogxIVIbKlhWlN9/npA/
	 6cK0ekUA+CAop4yFPBkvr7NTyXjB0/9PN6ZMo+LMGMD4S6HGc/YPYMn5PPx5OtOO05
	 ngSsN8iRoPgpMrY2KcGxMCHS9/cGeAqy82emexPvApJmFHKBuLcylGz+2Cg0/iLZgj
	 aw3mOOIeBp/WQ==
Message-ID: <b1a8fa64-b690-4125-815f-46f61b65bc16@kernel.org>
Date: Fri, 6 Feb 2026 09:57:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: folio_zero_user: open code range computation in
 folio_zero_user()
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
 mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
 tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
 chleroy@kernel.org, ioworker0@gmail.com, lizhe.67@bytedance.com,
 boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
 kernel test robot <lkp@intel.com>
References: <20260107072009.1615991-9-ankur.a.arora@oracle.com>
 <20260128185943.2397128-1-ankur.a.arora@oracle.com>
 <9206a7c4-bf88-4138-b8af-961625a82439@kernel.org>
 <20260204143116.968730e769500aea281809bb@linux-foundation.org>
 <87a4xneo5u.fsf@oracle.com> <a9bbf82b-bed5-436b-814b-cd9fa3f976d0@kernel.org>
 <87a4xmctr6.fsf@oracle.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <87a4xmctr6.fsf@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ADDD6A0006
X-Stat-Signature: yp6pxpex9e4be66hf1rwraerk8a7jfod
X-Rspam-User: 
X-HE-Tag: 1770368258-117989
X-HE-Meta: U2FsdGVkX1971gstydb1G8FkOOp9OZVB5zyDtXb7zl4A6HP2yGarjFZkv82/thvF1lM2o6dcNyXucf64wa20OwP+lCSj+GqvPwUjApnciDx+Fv+kHkBEm6vjW4+G0ic6+5xhSyUjQcNKQZcZ8G0pLhZEGiSJ6y9oKg5p50gbK6Ge/vtoxE7NUTtcWk4sYoG2aVml68abrJQnb9XbF3OwpefW90Qv0EGWxdKNoRI+fvrWNnCSxnqr9ir6oygi6ncRPWJ+W7J97AoVarmNRz2Uo+jeqQDvqmEW7QfybVwURhpERrJIXlscAZA9Ai9p+vsbz9swMZJJ4cWqrWqrLlxjpqD3ik7xY0HF6Uw2ohHtWnrUvkRsl43qycChcET//Y8tPLuWxA9SLDClfKjsdwjKOtqhdhER1AlJMFjFIF9qXWT3vhS/Xa/dvWpVeJ7EEScX0Shj2D6VqYz891xsZVhTFdTZ71qT147QzWn12xaXZCze+aSDUR65+ruwX2x3SLnm8XrtVO4T2rlViusyqAld0DKYilooKZPPE7BZMdenviUuchkB1F55u8FP5KUKqjWO9kTr3XOXSRBZMNu7EskCr7dbChGe68PoQDG+677MVOymlw+zkGKGVQE57CM4ish+Nqwe7AFZ51ML7MF0EOCKcD6pJTjlkc2u9euizjY0qhA5gklKTZONUeHGVD9m7SVmMOz9t8e9TMb6Ks75G7cuwgjljBIsuwegTPYCc6KGr55oj+FRJoKl9gtzbtt7wrHplk6Mb66k1qw8yhcLOp/hY/kLM4BICBqcIfWIuZFVgil13Rfj8mNhR98QQjDWhlMO7i4SncmG9rxWMKKEuA9VPoYcbiojncZroh/pn3iCe/RPAP5vDw+FZ2hZYgIITpYoNWKx8kcTgnX6vSdsouyAQS60iImNSFYR08NEBDrTulyFKkWr5H+GMyWZhUgotg13yzLmSb8rmfBjJvgs/hg
 T3TzuI2p
 +6jvqugObW0mqEh/mfmKE4JA6TJF0pZRwzC1Hoq2m9SeKPG3foirp3XVu91yAUCcPGVlbILlhr/R6ene8ia4zhLXGfUCXJJkpuxJAfOz9asi9zXXTXzrWCm+tp5TgW1OFq1xRaDkIUAq9i5Hl1Z2JcU9whZm/f1pRdYlHJLppVSIMyVis8ZqCzbo8Mscukxh9vq85CWLy3KxiqHe1Ix+wZhHyAr8GwPVABL4h63WG+SJVGeQpYGSwuAU7fhzuZwTSSX5V219AVDQIKorvJzB6i3cgvQGrbAZaEaSBZ1X5mC8CS38h23RlaCTzH3v1s+Fwf6zYzBqbfyGSXcX0YXBwISTaJzED/U6DaAw8vTZBjmdmPITDm7MMsB7jP1gX7OpaFtbWOPMxrD1ANq8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/6/26 06:42, Ankur Arora wrote:
> 
> David Hildenbrand (Arm) <david@kernel.org> writes:
> 
>> On 2/5/26 06:48, Ankur Arora wrote:
>>> Andrew Morton <akpm@linux-foundation.org> writes:
>>>
>>> Yes agreed.
>>> The first u64 is because currently struct range only supports that.
>>> Then the cast to signed long is because the range can be negative
>>> and the clear_contig_highpages() is only done if nr_pages > 0.
>>
>> That makes sense to me.
>>
>>> And, the third one is almost certainly unnecessary for any realistic
>>> hugepage size but since nr_pages is being truncating, I wanted that
>>> to be explicit.
>>
>> But the non-silent truncation is no better? IOW, it doesn't matter.
> 
> I never seem to get them but I thought we had some kconfig option that
> makes gcc give a warning to that effect.

I think we do it all the time :)

> 
> I can update this patch to just implicitly truncate.
> 

Yeah, I think the implicit once can just be dropped.

>> You could just make clear_contig_highpages() consume an unsigned long ...
> 
> Unfortunately that'll be an even bigger mess. The clear_contig_highpages()
> version in mm-stable uses the unsigned intness of nr_pages all over:

Right.

In any case, thanks and feel free to add

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

