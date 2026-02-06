Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5C91E9D414
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 04:39:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24F566B0005; Thu,  5 Feb 2026 23:39:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 219A56B0092; Thu,  5 Feb 2026 23:39:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 150496B0093; Thu,  5 Feb 2026 23:39:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 02AD26B0005
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 23:39:08 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8E1A613B95D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:39:07 +0000 (UTC)
X-FDA: 84412777134.29.D464FA6
Received: from mail.eskimo.com (mail.eskimo.com [66.114.134.197])
	by imf21.hostedemail.com (Postfix) with ESMTP id B4C601C0007
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:39:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=reject) header.from=eskimo.com;
	spf=pass (imf21.hostedemail.com: domain of nanook@eskimo.com designates 66.114.134.197 as permitted sender) smtp.mailfrom=nanook@eskimo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770352746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zup41lvkrnL0ifRwfB0fZ3oVF6u/waUSXO5NDXbh1Ac=;
	b=OvM0Zput3ijsfJWtV84KdWWhqvhaeUQkWQNiKKiiKPU0K7718r6i/tX6N9RN44T/N0kamM
	4oaVNpkK0yycfqcw5zKqien7jyAFSZrgaYzV0HZrECI1UwGdqiwMK1VODbHjrJJGijrYFL
	iWx1KEUx52yRhtg+5QlSqmvD2CqJcN4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=reject) header.from=eskimo.com;
	spf=pass (imf21.hostedemail.com: domain of nanook@eskimo.com designates 66.114.134.197 as permitted sender) smtp.mailfrom=nanook@eskimo.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770352746; a=rsa-sha256;
	cv=none;
	b=8mpxb1WDPiJ+YLMkwFZjoNj4cUmrFD9QiMZ8ORxM8Vy0lmKisfogeamNeFs+/s9nTU+ZOm
	xJ2mtG499nweHzr8REz2+f80EhBlrm6Wo0RiFVgNKsODEI5WNR1qNIfqNVKPOXw+hQkD31
	PXHacpZGZAeiEXkmxNHGsjNVB9f87C0=
Received: from ubuntu.eskimo.com (ubuntu.eskimo.com [IPv6:2001:560:4407:1::106])
	by mail.eskimo.com (Postfix) with ESMTPS id D58993C4119;
	Thu,  5 Feb 2026 20:39:00 -0800 (PST)
Date: Thu, 5 Feb 2026 20:39:00 -0800 (PST)
From: Robert Dinse <nanook@eskimo.com>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
cc: akpm@linux-foundation.org, linux-mm@kvack.org
Subject: Re: Subject: Regression: CONFIG_ASYNC_KERNEL_PGTABLE_FREE causes
 memory exhaustion and stalls on busy Cascade Lake server (6.18.7 only)
In-Reply-To: <e3759678-0b2b-4236-abb8-a16ffc81d4d7@kernel.org>
Message-ID: <f2ae255d-bfc4-3d7b-5908-3dd76d4069ce@eskimo.com>
References: <06843c7a-909b-41e5-9359-2be51cf9dffa@eskimo.com> <e3759678-0b2b-4236-abb8-a16ffc81d4d7@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1916979846-1794693057-1770352740=:3430994"
X-Virus-Scanned: clamav-milter 1.4.3 at mail.eskimo.com
X-Virus-Status: Clean
X-Stat-Signature: 7xoynwqe34b3czxjztny6188rk6gnpsa
X-Rspamd-Queue-Id: B4C601C0007
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770352742-310258
X-HE-Meta: U2FsdGVkX19+ZukCQQjJrlcaK/UBx1yKCz0yBZWeltZCQsfja3pVGikwWHb+1nTnarehew7aqyx4SCrULKan5oallMggJwIdcNYz96haEsd/QQ6TYAz4nzKtB71I8z9xzkHa3egu2Kmqgu1VKvVJ+2pAryU8+eCMAqUpoXDdNvYhCc63PJgB6wFBEM1Fo7fveToDReaulC768gIL6l+ZInOXx1MVN9MFBmkXP1ZKZHWTI1pz8EeqhyGl1hfQDB4eWvwBJiuNpWKCPdj9B6fPB14GBG2z9NLy8L1Jk2NHWlcYwBhUX+sQuXQy0aHk5l+I36CYRvILxttAu/uipri2D3XFdvgn43JSXaJI6zrVMs2Fnu2L2oVJr7AcBOmdiBg0TXVq2uQY2nHV5QBlFNjflgsssU/4CTMXEK8yF/Ffl7gaO/npOHkCyA1akdESnnPFEKGA+4khpMoChjhatDXnM2VfrdxbF/EQ6tlnALWELab/OkdihkOIPo9hz565at+TUnzNIdbC6omVMO1PF++M2oGqDUBVUQylSgJG5sRZscmLr/Heegl64XzS12sCXMtPEWhT5POrP38a0K4WnvWWi/LhZ5UXuG3UEuONhW52NF7cbSuGsSh59U3TvGBskA0NWw+tn6QH7V5KWFX6HgaA1q+QeToV9i2k3at1JENyGFBSapkX0/iF4pZg+MwALK6xfYhCDaSbD+nBW2kpNqg8r1RV0LscM+oAcHXw4jr0yeckmNbL+oxPVjgBUB2FKJdxAbQ9EfJ9nOqm9fTC3o0jc2p/SCs1GK+ltP5rs8eVtVEczuTfK5VPyD+//8lcpFtm+LCbGsLhuQ+as97CoK97hWRCakV0pGD5orXMW3bdhDgirVeFf7EUXvh/6MFV3JVNQtb2l3Qi/Tqnh+UL+/aFYBX8I+O73WmoQZUG3VU4KHIR5t2kGylOPshN32RkekuxvZ/iBh9I9Oj9Zm7kmjR
 O9PZxxVE
 EP6pBcdpzJ7SP/uuz3L1hIICe07khNLmyAL+zbBNfdjbrJUv0oXpBejHO7YNVb8nEEYHPU7SvydZpTa959otwAsIhHNQ9TdZKopkMK5yOEYzphUyR3s/FtQMGqN/P2UwwBCNNzrZp+D7rjI3igdyAX7quK/V0SdA6bqG/QmEXzHZQfBWNzbXiZcVl1u7e/601NwtMx2xO/jht0d5Qt+K0nNdP5CgpjC464gpPIuGy4WkZB30hbUe8uuI1HutQ1R2g61PsvN7fbKtVsFR+5UYS9Di1Dq6kWhp99zG68BOwGJ+xw7iJ2Ruo5kX3wSeav4WXEmBIpQ+iTyJwIG5HPiVJQDa8t6GjLS49fM5GfX9mLXWyFMf5HYf1JqJUcU+QdOKmQh9JGumdEMQKuQDW/Ne50RSvxPxJsK2PbaPQOhuqnqW4wJ1/8yDpb9VGSDjTGf9toau95kalDmJ7+Qt0HpYM99RyCvrmSOl0Pwlm1FvYHVwPHAH1R+CGIrr2erDD+vWmxAYgYCg4YOr96T4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1916979846-1794693057-1770352740=:3430994
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT


      I've tested 6.18.8 on both machines that were having issues on 6.18.7 and 
they are both running well, so don't know what changed but the issue seems to
be addressed in 6.18.8 so I would like to close this bug report.

-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
  Eskimo North Linux Friendly Internet Access, Shell Accounts, and Hosting.
    Knowledgeable human assistance, not telephone trees or script readers.
  See our web site: http://www.eskimo.com/ (206) 812-0051 or (800) 246-6874.

On Sun, 1 Feb 2026, Christophe Leroy (CS GROUP) wrote:

> Date: Sun, 1 Feb 2026 19:16:43 +0100
> From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
> To: Robert Dinse <nanook@eskimo.com>, akpm@linux-foundation.org
> Cc: linux-mm@kvack.org
> Subject: Re: Subject: Regression: CONFIG_ASYNC_KERNEL_PGTABLE_FREE causes
>     memory exhaustion and stalls on busy Cascade Lake server (6.18.7 only)
> 
>
>
> Le 29/01/2026 à 07:10, Robert Dinse a écrit :
>> 
>> 
>> Reverting to 6.18.6 immediately restores the previous stable behavior.
>> 
>> Attempt to disable CONFIG_ASYNC_KERNEL_PGTABLE_FREE
>> ---------------------------------------------------
>> I attempted to disable the new async kernel page table freeing feature:
>> 
>> - The symbol `CONFIG_ASYNC_KERNEL_PGTABLE_FREE` appears in `.config`
>> - However, it does not appear in xconfig or other configuration frontends
>> - Manually editing `.config` to disable it works only until the next 
>> `make`:
>>    - As soon as I re-run the build, the option is silently re-enabled
>> - I tried to chase the Kconfig dependencies, but the chain was too 
>> convoluted; it appears to be effectively non-user-selectable and forced on 
>> by default for my architecture.
>>
>>  From an operator perspective, this feature as currently implemented is not 
>> workable on a busy machine like this, and the inability to disable it makes 
>> it difficult to bisect or run with a known-good configuration.
>> 
>
> Try reverting commit 9f0a7ab700f8 ("iommu/sva: invalidate stale IOTLB entries 
> for kernel address space") ?
>
> Christophe
>
--1916979846-1794693057-1770352740=:3430994--

