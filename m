Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80EFB606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 13:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=lwn.net header.i=@lwn.net header.a=rsa-sha256 header.s=20201203 header.b=F2FY4UhB
Received: by kanga.kvack.org (Postfix)
	id A7A216B02CF; Thu, 22 Oct 2026 09:29:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2B4C6B0935; Thu, 22 Oct 2026 09:29:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 941866B0936; Thu, 22 Oct 2026 09:29:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A5656B0935
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:29:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C2A7D1A06BD
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 13:29:01 +0000 (UTC)
X-FDA: 85350342882.02.553DFBE
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf11.hostedemail.com (Postfix) with ESMTP id 11CC840003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 13:28:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=F2FY4UhB;
	spf=pass (imf11.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792675740;
	b=7qDVqW0x7h2SwLKWqbMEeYuORweIjfgwX4siXHAHZAssAGR92L60SMZS71tnazqs0YNa80
	i6ir4GwDqvQmbwgPv2KYciXne1f/oFwD7TrMbZ+esY/uzIS8PysaVK0zzPc9Wxlnm0zYAZ
	8kSZc5u6ezjyMDbY3nOskHoTwSztcXI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=F2FY4UhB;
	spf=pass (imf11.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792675740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ft/zTEz/wL8pC9DEQAzUBMC37NSK0YmpGlR/ZgjOZuI=;
	b=QNo+V6skNEGpK2hE7508c7JIKyqTk20uMKZzupHFluVpVUANoeA8l7jbyG13Nc2jWAuw0y
	YmlkwCOu3GAihWalaES35wrBMbmSr4ryAQ1fB5owGWKgbLV1zSNPXN/BwJPR5fdV1cnZ4D
	7Mo5TJfXb4no7P7UBlYsJpFJKCrNTY4=
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 4CBE7408DA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1792675738; bh=Ft/zTEz/wL8pC9DEQAzUBMC37NSK0YmpGlR/ZgjOZuI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=F2FY4UhBU7SaoUFlnnMu23tKtH0RedXqBRNNP1dpztVFHQu8Ek4UzmrVEEzkFxW7i
	 Hc8YnEasCAxA6tQvjx78DoTOseT0DMvmbHRR61r+MF9v94UVopCLjZKCzLbGkpeakP
	 Y62Kse9N+qPPbH4q7d9uaeA/JAFzBNKj3z/5CwCpXDYzcCaUfqxX7MQ4TBur9B/AmK
	 idkGqOs8Q3fVMpxF2Ddq0ug3JAJixXAU5VAVy2soTlEzFTSV5x9OQo8Rsxunxi0eix
	 CCC6AkMQMTsmURRfgG0f0ev2ucfo8dLKDmu5LWR2PQCqY21fQzBPNvL1+eA1BwysD2
	 UdUHHby4QLHbQ==
Received: from localhost (unknown [IPv6:2601:280:4600:814::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 4CBE7408DA;
	Thu, 22 Oct 2026 13:28:58 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org, Shuah Khan
 <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, David
 Hildenbrand <david@kernel.org>
Subject: Re: [PATCH] docs: core-api: include documentation from linux/uaccess.h
In-Reply-To: <20261021160345.f01d046a25999a2d6edfb65d@linux-foundation.org>
References: <878q3q4qby.fsf@trenco.lwn.net>
 <20261021160345.f01d046a25999a2d6edfb65d@linux-foundation.org>
Date: Thu, 22 Oct 2026 07:28:57 -0600
Message-ID: <874ied50fa.fsf@trenco.lwn.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 11CC840003
X-Stat-Signature: gpiux6xmb78jffifac8aimat6irgp6ro
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792675739-480223
X-HE-Meta: U2FsdGVkX1/dsR0As+7zckjg5pbjbrQT1qMhDuVFJU0NJ2f+rU+GTlkjE127/ZRrcPc6ejoq7LOf4vXs7VWThR0yXQsJECOBXxhS3/cw39+qyTx1nS1WB/wqfklFg/b7blXLmmTR56MvQie0P8lOorqjeNqCWzoUrbLCsEJv3uwJ02grsOGla/BVgiME7t1XtRE/UWF007/bTBtpVwqgxu/p+xS2PsWBhwtWUKZztt7DDhaqMJndc1fQ528DuT8NrjPRafQr9rjv5dKI6xCinHUKNR2N0hTQFC5o5cRd3xhqhEz/kxs8dQxfIdK7EvfOgCGOBKeCFq4LDyF9w18Q30LSbbwDXgf1roA16y54NJQksNKEwPQUkjd0BbJtpyRTopkzg4Ts2t6iROvdAWwEetgTb2X3hLPsvPFvffGngo+3UPUrUJ2siqstPw30Npt+ZhsSyBf8Dl+GWtgQ9BvonNywwvR/htWvVtRr9InxhMHqRAY1xEX7XSOPw0ZpCu2KZyRSvyv2fkUaidQ/iKeW1c0Vr7yNW1lWe3+pRGpL3e3MTC1ga6mjopuOFWKInFnOcKQ6SzKgtDuVlBJwVot2avdh4mdV5PDXpAkUux+uxwgr6MkBQ8w6zrQMjIdjppD+KusWPhEhO1OMZ8euhamay7HvNLmh/WROG1P0owGFSp3X4+FZK+zHJ6/Uemm6ewQjh1KRWJ/uEIrcXWHnGnvRzTbOQBhZkoBVcaOqKFXWvsB4S9nVIezbtV6kOumY95fF64lvrNORZQvU6BRFWKWmCA49bbWAxXASpX+RCXs7i16gQsSi3oMofynH3xpJefxUBe2j2xeKR9Xk5UXUqT7PghwqWe13Da1bHW7NndNMhEiN+9N2kU9Fqypz2gHvx0UzbRf7gjjOqAiKdHIJaJucUuEVM4kevNIlTgcmcFprCVryjnwNbWcntH5m0KBpx9D31ygUPgJ8TE/3I8EK/re
 CA9FZmh8
 m9MHCcSdGod5GVUaEOhNxJ/UfI5DqicZ+x4E6PrcOxKPE9UZ7AeQ7G/MaQW/DIuB6WPoeg9URzePwCPpgFjjfc7HBDYUM8Hf06pKOq1qiYbDb1x6bdUsEpm2yemU7MJsIbCgbkYOzekIl3nydjiSuAEpD2KzykdVJkthgdl8EJUGNm7h7EjuJSQ0+crMAveSv3c1StxraZ+nT0Ojdcsl14vYpecialaNeH6Wa+Ec/ZT5MbR3SsgH/N6ik5VEuA0t/q1bmrJR6vUKCRb1wsecHRCSvORS22k4kijm24NKnPUj9dPETr/+yJLmXpDOdyNK7MSxkRIRksvjBA614z/oGD5z/BfM5FKYjGYYkR6Oz3qb03xxOoYBsXqbfJRV1LSsMN1eVfS5QrezOYSV2b8I64XSIhms6jqIMNaVSMl1U3Sw+aRLNN3g8tf6gyx92LxqpHiDw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Andrew Morton <akpm@linux-foundation.org> writes:

> On Wed, 21 Oct 2026 16:54:41 -0600 Jonathan Corbet <corbet@lwn.net> wrote:
>
>> Documentation/core-api/mm-api.rst brings in documentation from the
>> x86-specific version of uaccess.h, but many of the functions in common use
>> are documentation in include/linux/uaccess.h instead.  Incorporate that
>> documentation as well.
>
> Thanks.
>
>>  Documentation/core-api/mm-api.rst | 3 +++
>
> It's confusing when a tree-owner sends a patch.  I never know "is this
> for me, or does [s]he intend to apply it".  So please make this known!

I know the feeling :)

I'll go ahead and apply it here.

Thanks,

jon

