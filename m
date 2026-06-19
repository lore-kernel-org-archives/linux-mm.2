Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D7B9CD98F6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 04:46:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C62286B0092; Fri, 19 Jun 2026 00:46:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C13926B0096; Fri, 19 Jun 2026 00:46:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADC986B0098; Fri, 19 Jun 2026 00:46:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 848AE6B0092
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:46:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 164FD1A0327
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 04:46:40 +0000 (UTC)
X-FDA: 84895426560.19.151E0D6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id F134FA0006
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 04:46:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UFR0Hsfm;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781844398;
	b=ExEYMcf/Yq4LbgQNPfbf4nNkyOrkUS5sQ2N+Npy2fyasGfn5p9PLMaee6PnSrxSktlyfat
	SDbmo+gLcLyMIQjigWaMOo8vfFOt+VtnYF1kOC7tKCva1BAI60Xu1j2UhQxZv79mXktU5C
	nCSnogCOoYFRtWytlr3rX0C6oArJW2I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UFR0Hsfm;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781844398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FKmvbTzK+90ueZ4AbighQ8tyOuU1wtuXRrG7vAo1zO0=;
	b=7NDCpz7FLXEQol6VR4ABMKwWLfpuZQdAFg2nbRF7pq4J2JylUNhdYqsqldSgWKrMcJ+gZ6
	iCpZZBS5G0mkMeeCbOdOj9hhktucbs0/oLnMjC8mVK0kHbsaJw1uIqz3ZSJpJMBR9PuOKX
	jb4fEgGr5p+HnsmBNKTM6xpRA1WOFGo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 86A24293F;
	Thu, 18 Jun 2026 21:46:32 -0700 (PDT)
Received: from [10.164.148.42] (D3H2TH2F54.blr.arm.com [10.164.148.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DF6433F632;
	Thu, 18 Jun 2026 21:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781844397; bh=zo7L85WEMQspgr+Xxc8ITBFT//tY1Z8VCvuSv/cXyLE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UFR0HsfmIgbVnXQm+nqkHxhtgz5uJsi6PxQu6nA5ExDABz7YYRT7NN2ntqyfACtfc
	 YYTLIoQYxo0u00Td35Ce4bhkgZmFJh0u8l1EU5h2mEcWWIy16lRJl/KwhmY7mFTxOW
	 hsefNn6008dILDD8tAKp+MmYZbEaeZK3tVneAAno=
Message-ID: <9abb0da8-e29a-46ce-af11-55c49b30b1b2@arm.com>
Date: Fri, 19 Jun 2026 10:16:27 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] kasan: hw_tags: Add option to tag only at
 allocation time
To: Lance Yang <lance.yang@linux.dev>
Cc: ryabinin.a.a@gmail.com, akpm@linux-foundation.org, corbet@lwn.net,
 glider@google.com, andreyknvl@gmail.com, dvyukov@google.com,
 vincenzo.frascino@arm.com, kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
 workflows@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, kaleshsingh@google.com, 21cnbao@gmail.com,
 david@kernel.org, will@kernel.org, catalin.marinas@arm.com
References: <20260612044425.763060-1-dev.jain@arm.com>
 <20260613060637.40039-1-lance.yang@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260613060637.40039-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3ex1sdotanjw5xc8g881ihomhijibzy8
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F134FA0006
X-Rspam-User: 
X-HE-Tag: 1781844397-862162
X-HE-Meta: U2FsdGVkX1/wX7xSVaAaW39PE5iZwfz3nnQK0KQuA+/0gXxz++jbZLIDS+aTZtDJcp/eojIImPTmrgHAl/C095bhp9GldDhRogKscUk9TuV/tFiHI2w2hgrpVUS5ZURSNDA6SXYYiG6j8zwMhPKH/Gl2oWDTPSOlSAsRZW5JVdugkCBhjW8lsCCGpLIbVL5KU+UmxtsmaZipXci5+ze71zBiN8oKiTdPOyCFj6B5PV6uMQtQaFlZkOjEhXbta6Gk6UMhzI64tU3S8RCCdPoUYmpqnmuJp2aGduGf/LkkmF6ub0BQ4/8s+R+k7jphk2/MDahoq04NJex05kQGVLh9PFwf/fPOCspl7moeIJ5fPWKMqmoGJ1spB310iVONdD0kwMLBrydApancgb4CAWMfeEUwOVU/sG2L/vWGZs9a7oVcNO8XSwLOokHxT3rMkwiorsFA07IBz5k/Iq5luu+9N7H/epZbDzcM294x7Jdlz8Ma0act+TiKzrSSEXo3kgMvKO1VIzu+qiLegeEWPoDnqLIEQWnjGm/iUZFYYIVf1HJOKj99fY6V+guAzqWvIPln1ZcswOuz+c9oZT1fAEc0U40NSjOD9R82xNvmjvaHEPYHKEMyNUWaH8OpId3wWP5G1MuoyFdg3gPmpaZazwFJChmgCJocjUP8m55X2bxr5LejbceyesRmuECOI4WeK6dSgu8G8g+onyxU6UkrgiE2k0ujr4b5t3Cx2NP0iSMcUcSr4vcJHsOnNnmLFlgWe2Zh2LWQRygYQVCgtFBQB/MCf1jx4EwzOpUXL4tdiEjUUYS4jaf3TH1XxiM4kblPiU1tXRTLma1pY1h7/swBoYTLYgkkHItUKJops5sxtii9qEmUXAbCbjjasDH1adCr/iw3iT5t6t0Bm4Jmfs76FaJg6dmA3I228k34Dyi8L6t7XTYU15fSbWgyi1kb5oMEc70SW93A8KNunQuezGW277V
 jToL9YEa
 TE8559iS9GpUd846iuEGvGulT7kk7AQBBt60cOIYlOZyMqrHryHEQ2M8jLEgP81aczXpqvnb3hx8aDMKnqJvcqaykl787WgptWRhJ/u5EO5BZVbaV7imxartg5/KSL+9ePqmZTU4iG6Dao7Pn888wZc9GIPDS2mJ2y9RPJyYbwY3x9Px6il3Gh3RMKtw9R6i6bpAwzkymIhZGOFaF6dCas+rtyQVub+0vL6w+2EK+L1Wwp6owz5uVFguUFI7T0lw/ZNFCSHvZIFrVyOJpx7JClVs4Ln6U81Kc9M1GCVhvHOnSBhX6BLOFrPTdUbM/RBesu4NgthUyCW2C4P8wAxyNYFY3J7gcJln5K/DOLmm5g9tzuvk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 13/06/26 11:36 am, Lance Yang wrote:
> 
> On Fri, Jun 12, 2026 at 04:44:22AM +0000, Dev Jain wrote:
>> Introduce a boot option to tag only at allocation time of the objects. This
>> reduces KASAN MTE overhead, the tradeoff being reduced ability of
>> catching bugs.
>>
>> Now, when a memory object will be freed, it will retain the random tag it
>> had at allocation time. This compromises on catching UAF bugs, till the
>> time the object is not reallocated, at which point it will have a new
>> random tag.
>>
>> Hence, not catching "use-after-free-before-reallocation" and not catching
>> "double-free" will be the compromise for reduced KASAN overhead.
> 
> Hmm ... do we also need to teach the KASAN KUnit tests about this mode?
> 
> With kasan.tag_only_on_alloc=on, free-time poisoning is skipped, so
> some UAF and double-free reports are skipped on purpose, but the tests
> still expect them :)

Yeah my opinion is that we shouldn't bother - but if we go ahead with this
patch in some shape or form then I'll see how to make kasan_test work with
this.

> 
> Cheers, Lance
> 


