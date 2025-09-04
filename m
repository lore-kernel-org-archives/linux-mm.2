Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 930E4CA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 06:42:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7D498E000A; Thu,  4 Sep 2025 02:42:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2E088E0002; Thu,  4 Sep 2025 02:42:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F5B78E000A; Thu,  4 Sep 2025 02:42:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8AD7D8E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 02:42:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4E8B613BCEB
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:42:25 +0000 (UTC)
X-FDA: 83850623850.14.1B41487
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0A6F7140006
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:42:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a+N2XwRs;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756968143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KToomWKj9mg5gO92HiOMCLhfsKGdUXoXNpj3PWwnJys=;
	b=GWemWtMmthOVzN6p4ZGFbodBNmwf4nol7svyIp2BTTHgcekKYK8xi9pMyQut3JVLGNmAH7
	gY7S5B8tzTrqR5rJAxOQD/Q5hTdSn7dcLWorr+UsfW7/C7sPxVDL+6WbSnGkSXGA5Ua1i7
	R1hA4O3veT7vKFlytluHGz8DzLW+Cbk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a+N2XwRs;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756968143; a=rsa-sha256;
	cv=none;
	b=B0yCAFoPWbSZJBwVaP95D4m1XrnJEDW/0AArm2eJ3DgOI6sXpbqmoBa0l0oO4brktqcUJL
	ugM0I4JrJnMQvm8fR0znAHGV0CxN58FxCKrBfEtlFfP/4xO5+sQobWrI85U+Gk7n/3D0rV
	iHmhRAljwqHxzueoW4v074NcmDp+it8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756968142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KToomWKj9mg5gO92HiOMCLhfsKGdUXoXNpj3PWwnJys=;
	b=a+N2XwRsVY1jQOT10nRME0eYTnh6g1eK9MEB/vFifgJXRlAGrt0uqUvDGJFR06JvesM384
	dBA3Dg6Dc3cQTmskahgvd6jnEpQdMSTO27MLw72OOPuPwBsf33DxPGwuytV8oRM218qNxx
	Kw7axC7klSDyWcukl79J3eEXJGhLGkY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-166-fD_cFD2oNoePs4ETl18WoQ-1; Thu, 04 Sep 2025 02:42:21 -0400
X-MC-Unique: fD_cFD2oNoePs4ETl18WoQ-1
X-Mimecast-MFC-AGG-ID: fD_cFD2oNoePs4ETl18WoQ_1756968140
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b9912a07dso3298575e9.3
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 23:42:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756968140; x=1757572940;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KToomWKj9mg5gO92HiOMCLhfsKGdUXoXNpj3PWwnJys=;
        b=QpgyrpcmQ6VY74eAQ8Kvy5iRJQUbZyKBxNoUBWz3sFdzwBuV+bsG2wuEsMR48CxF9+
         zEQLfCTa7S3OlBIzRZmfkhBu+ttEl5azvAl/KUzA69n0hs2WT5L9LmnQfOIam31t5luy
         IwFKTSGXZbRmajjDOVhcUgFszerr/vKEy3+3Upt1QPCGMs6snUGBFxggN+RylPKmkMQC
         4zMObhJGKP/jybNc9XQlO0UoGZ58AXdEuNVHUM4W+9UYHe70+YctWph75ytsDiqqtZvG
         XiurFV9xCaL/01fk/vJxIIO4xZIr8uMq3Cvfx5PLq/XMxD46yHYjNxmPLmVp4xPvBCwz
         JJgA==
X-Gm-Message-State: AOJu0YyzKgzJ+kGpxrbez9oAjs75rjrkxeQeSEbIK4FTuLlZAGJsbAyh
	HIEgmbkODI7O+WQF4zqlTkwbf6XJtnvmKXdSKJzPoz+VA4kMqEfk9CB2REgCECVtjKhtNh2jGwF
	71+wc0vlpIvZ++DZ5bIrkee2A8f5v/+i9quuJlS2S8ZGbkpOvMd2a
X-Gm-Gg: ASbGncvyjdQ3J9F7pVVxvu+YdYWWVkZ0DQaL8f4AzBwxkh8+ffDkUeP3OkaEk2+VILo
	MkKQlJYBJj8tDELqqFGFj+1phvO/RZFdWSeQl9YcavxV5q5xQRg/au/azq1C4o+8t9SXm181Iao
	L+aQCcsu7GphbxGFl7zz2V6oMx0SUwZBDbDiH0JErSvp+5/okCrJruuPhyZ3UmwzW8l75YpjuUa
	hG6Kn9O6DfK34mB4YLLIprRWslyHrQmYUWLiITYBlailpZ2vao/8WSjrGM2vjRULVTx/1otMbgs
	VxM91Tn/ZHaMEE8VQQYAjlCtDiGL1MAE3nf3Ew4SA3aKB6lXzQbeWmc5kal9drH2vF3Gm2ON+dB
	ked5eyPpz4H8AOoqvasoe5h1n1zdR/vfDaZQeJp5p8fLWTzaKAUwqV6I3qHieINrd
X-Received: by 2002:a05:600c:3f0a:b0:45b:8703:741b with SMTP id 5b1f17b1804b1-45b870374demr140352305e9.32.1756968139750;
        Wed, 03 Sep 2025 23:42:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEDY+KZJxIteq5+5ELGWzXe1Yo4ms4pskv7HMB5FhUoffpW2kCYxWLFHE3oFlp3rlHbnFi9+g==
X-Received: by 2002:a05:600c:3f0a:b0:45b:8703:741b with SMTP id 5b1f17b1804b1-45b870374demr140351995e9.32.1756968139315;
        Wed, 03 Sep 2025 23:42:19 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:1e00:ce4c:be3:97b3:6587? (p200300d82f251e00ce4c0be397b36587.dip0.t-ipconnect.de. [2003:d8:2f25:1e00:ce4c:be3:97b3:6587])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45c6faad9cfsm80007195e9.0.2025.09.03.23.42.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 23:42:18 -0700 (PDT)
Message-ID: <239ecae6-2fc0-43be-bc63-08f52b39a524@redhat.com>
Date: Thu, 4 Sep 2025 08:42:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Fix kernel stack tagging for certain configs
To: Matthew Wilcox <willy@infradead.org>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Kees Cook <kees@kernel.org>,
 kernel test robot <lkp@intel.com>, Dan Carpenter <dan.carpenter@linaro.org>
References: <20250902175903.1124555-1-vishal.moola@gmail.com>
 <aLdFxtVpOX-qf0qc@casper.infradead.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aLdFxtVpOX-qf0qc@casper.infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JbV-4TxZ55lHxDQXtW0VL9tk0G3JQT94zaAUF2gT8d0_1756968140
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0A6F7140006
X-Stat-Signature: f64k3w59tppj68xpimc7pfdut3x74hm5
X-Rspam-User: 
X-HE-Tag: 1756968142-312258
X-HE-Meta: U2FsdGVkX1+rkbPg3N2XpBmYEtDE7RYVyIDye32Obw8ORD9O8JtoQqewelcuBDzLY6CfujJGVNM6UIWY7kb3giy5js7sF7pgOhtDQBzfhdqT3FuZGFemPrKHKJT7UKL9u2EEPF9OPO+nXKuEhO4Eh1EJ89Dz3WVAJACb74E7EtoduKIkL76MBQ7brP4bstd/3zDqMGc4cRaVfq2ank/sMw38zinRqnXK/hIwTQRVy3e1LE59+5gZbDDDpn0+QewJVSKdHn6cNhbMsCi/rXagtEYddbdO4yfxtwiPtHehtGRenQ1AMincGUYZETqEKzWTEASZOolpXz4gbRTgyu+MRprglvE0PQm6aUx8eR2jr1bpUtDlNyZl4OUGd0m2JxxMrZ1mlX5p+F5aZSIuCcwx74gYiunkMICwiMfH6Zz/Z9dq5uCkYIOPwLJFAEacL/N6U1/Vn3ukdj92xXgI/lPWB2A7LJ40316dAeJCTnxVtTzXBMW23Y/xaR66SMQCjOPSJP6xt5APs/+q1E2s/jSkhiU7Ni6RI7sC3/YJarmnATQ9JmI3wIecyBy22KQVDfDn2BTG2KEwgDJYX3hjD5JWHBuwN7TkHD2YCEXly27FCnUVJ6iRnqC1adFYFqoG7gOqpOBMee85SZDcIu+YhcE2tfqoxSKJyGryvq4wmG2E2Gj4lnkFiMVpxkhwk53wfhBmum8d2foYZgAaPfHsF9ioFwdBULPZ8qYOFzEoWfIdw0AbPw4H+Rc1imu0lK0eQvsecwMDcEvKGY5jmpPzawJ2WO2kYeI2Bzl/KQ8iqq19QaW5ZZmQeMMVArmSqDgT7EyA2rpJCPljnHDSiDkbMvyK7U2q92Lm0xhUMTfQZH5R51xwcjxhpdToEP7EYmF2z6nVEVFXGDjk7WYAya6QX3e/0ganZbxiYNRKXwJcxJApywHwtsw18MWymU//MiFdszsQQbCL73cyhuYN35X5S5B
 ihgSBquc
 NjI9JIWybKuOUl3GCDcKFXrXxl4+t+1oGmeZgCZCaP34XlC9xXdobsadOQJe2il5wtUGbnwvoWT4x42IAWsDIYw07TkGOdy56SXOKqZlaxZoGENR2xg4IDqn3OxjY+e2xI810622fgktyucskYuVGLkpf7BnI22ijAipMRVirCHoRQn9J/tf0gQUUMrVfl3yPmdUOrxESMsuekfVtzSfSsKWGQXw/JKkebbdqWuECcmNn9adoSNrJytRi7ypcAXt7nw2TXiqX5PP0372gSdO9WLg3p+ZtJz4e5O8b/A3SQmnH9jCFVNY/ZigfRVpUatASq2CZ6j8hC6feDZzHWfiV9i/jzwlFRjDdrkPPCeYOazfAghVAAT+ep97cSvjXboDJR29LSvM3cPUVlL3KzoR5/0THrhGXfDEglrDmpxmvRdiMELo6vs9pUrmrEXLQBXLvRwPBmyYupXfSMyRDhUb8FL9wow==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.09.25 21:30, Matthew Wilcox wrote:
> On Tue, Sep 02, 2025 at 10:59:03AM -0700, Vishal Moola (Oracle) wrote:
>> There are 3 cases where kernel pages are allocated for kernel stacks:
>> CONFIG_VMAP_STACK, THREAD_SIZE >= PAGE_SIZE, THREAD_SIZE < PAGE_SIZE.
>> These cases use vmalloc(), alloc_pages() and kmem_cache_alloc()
>> respectively.
> 
> I missed that the third case existed ...
> 
>> In the first 2 cases, THREAD_SIZE / PAGE_SIZE will always be greater
>> than 0, and pages are tagged as expected. In the third case,
>> THREAD_SIZE / PAGE_SIZE evaluates to 0 and doesn't tag any pages at all.
>> This meant that in those configs, the stack tagging was a no-op, and led
>> to smatch build warnings.
> 
> I didn't see those smatch warnings.  Were they cc'd to the mailing list?
> 
>> We definitely have at least 1 page we want tagged at this point, so fix
>> it by using a do {} while loop instead of a for loop.
> 
> We can't do this.  Pages can only have one type at a time.  Since
> they're allocated from slab, they have PGTY_slab.  This will lead to
> a warning at runtime:
> 
>          VM_BUG_ON_PAGE(data_race(page->page_type) != UINT_MAX, page);   \
> 
> But for our purposes (trying to figure out how fragmented the vmap
> stack is making the memmap), we don't need to do this accounting.
> These pages are already being allocated from slab, and slab allocates
> naturally aligned, so we can skip all of this for these configurations.

IIUC what you mean, I am not a fan of having PGTY_stack being properly 
set or not based on a kernel config.

I much rather prefer this being done cleanly for all cases, or not at 
all (OOT for research/debugging purposes).

-- 
Cheers

David / dhildenb


