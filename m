Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F36F0CDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 09:57:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4E046B008C; Tue, 23 Jun 2026 05:57:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D25586B0092; Tue, 23 Jun 2026 05:57:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3DA66B0093; Tue, 23 Jun 2026 05:57:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95C926B008C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:57:41 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 096EF8DE7F
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:57:41 +0000 (UTC)
X-FDA: 84910725522.18.9FDB81E
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf20.hostedemail.com (Postfix) with ESMTP id 372101C0002
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:57:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CwFbM4bv;
	spf=pass (imf20.hostedemail.com: domain of 3kVg6agkKCIQ1iz2v0ip2owwotm.kwutqv25-uus3iks.wzo@flex--tarunsahu.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3kVg6agkKCIQ1iz2v0ip2owwotm.kwutqv25-uus3iks.wzo@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782208659;
	b=GYOjdHAj2BSdnjp82XfK8W0FHQMc9o+cWbhD0/20Vg36OQVN9GqUP4BUdnQg+998Qu8mpu
	Vm04UC8QXVfne2JxzNMz40sS3JEUUMnCPdXjhkWrFerPJvN8x49edpFaAvM6mRSpu5kYuZ
	zdFV30oDUWZG/imw3JUJtvsIfgNh+PQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782208659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X6h9atGrmwYrKKQwd5mU+K5DW7kaXkRukWRnYNelZbM=;
	b=tX5NktXs1NVISQ1ZJBADfXNzPoPp204LWf5pnkpglfEf8jKb58D4qN5nN/NpBIpRTjUBYf
	PCr1hfmYcEwlEXMJflKStscrnKTMelL2Cb2rt7aSVzdDvgF00C8+j4/17JJbBreX6RMjXd
	ZDiAneht0eZKJXcFTACYP4qp1mvsUn4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CwFbM4bv;
	spf=pass (imf20.hostedemail.com: domain of 3kVg6agkKCIQ1iz2v0ip2owwotm.kwutqv25-uus3iks.wzo@flex--tarunsahu.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3kVg6agkKCIQ1iz2v0ip2owwotm.kwutqv25-uus3iks.wzo@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-696bf062625so4339330a12.2
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782208658; x=1782813458; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X6h9atGrmwYrKKQwd5mU+K5DW7kaXkRukWRnYNelZbM=;
        b=CwFbM4bvFHSqxPdKXPRUUrdm4jUuAGUZSh4oaHR3VZ16/DzQZDwO/zFtuitE1GHq8O
         4NcEY4EC7I8RIgLLtJif1T12Icp8q1diGdYBdp2fRh1oFGLmrxSc9HGf1RC1IqevE/Vi
         aS53QtMjPWG1j6yehwAHmF2YtiQnIC0Wk62AcI6vcd6Sa+d7/FRVUT5ohOd9dDy0ZJPm
         /pBrrVexHvPfzWLfDPk3+wfQIKOD3nc/eUR9eWb8wrr0MayCy+16705zUffOv/1+Hq1J
         pa+EU6uMiXMqwxPgvOfmQYPLVmmmgx0SokqdlAQYVA25StuOFlB9KCeehUZxz1TzLO2a
         OV1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782208658; x=1782813458;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X6h9atGrmwYrKKQwd5mU+K5DW7kaXkRukWRnYNelZbM=;
        b=FBb/aw1hLUmtDKPprTiE89fyrRAQ8xKbLLmOSSwpmwQDwFX+holpubgtZPJU+jgdyE
         0YIX9FsLOo9NCKg0CvkxelSjQ3QaX9fqMFUL2u9/AGmqD5mJldV2jdBY/PtDwUBOsZEi
         LlNraLWuQZei475qFDRDyZW1WHlLvbv1AzlExZm95fku+99w+ZR71sR3TU7lyZ34KUqp
         segFg3NqZorK0BRIjtHn7xDWToXrvRezBwLY9A3qLXGz0fOQ55RjftPK7czM28+uLokx
         sD1WNOiZVuv31X9oY4x2NL6wysemQyg7hpqLUsd681RmJ13OyzEntwqDwyA3mRHnRT8g
         2FSQ==
X-Forwarded-Encrypted: i=1; AFNElJ8HIyVmDOehDrNLB/WIQKm4iuNvcc7HF3RIN9jyB+vHGXCKQvQH6mUAsMchtmi0eOX3Dp803TlCXg==@kvack.org
X-Gm-Message-State: AOJu0Ywf4azuajwuvqhobBVKpE+i5e2Nvh4lkxzgDzAI1k0oNpuETmmT
	M+lg+LvmB3N4m1xKyPniP5khV8eRFJZ2LrmQda830OzyFaYQFFKP8u2q+dlGMqZXVkoI9hAdKkQ
	QkJD8X1z7KceGErQW9A==
X-Received: from edim4.prod.google.com ([2002:a50:cc04:0:b0:696:edc4:b307])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:2710:b0:697:6b05:e801 with SMTP id 4fb4d7f45d1cf-697dbb38f5emr1011923a12.17.1782208657371;
 Tue, 23 Jun 2026 02:57:37 -0700 (PDT)
Date: Tue, 23 Jun 2026 09:57:36 +0000
In-Reply-To: <178220761161.162773.13771896658073176.b4-review@b4>
Mime-Version: 1.0
References: <20260622225736.2961438-1-tarunsahu@google.com>
 <20260622225736.2961438-2-tarunsahu@google.com> <178220761161.162773.13771896658073176.b4-review@b4>
Message-ID: <9huzmrwl37fz.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 1/2] kho: add KHOSER_COPY_TYPE(UN)SAFE for phys copy
From: tarunsahu@google.com
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: cnmxh913o8ejapdu5wbcw3pytpexfezh
X-Rspamd-Queue-Id: 372101C0002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782208658-616338
X-HE-Meta: U2FsdGVkX1/eco8bK+msQOtsfkp0pEayM9EWEm/miT1En+syonQ/ZJPqv/v2KR75RPHN+YXHxjlUFnbjio8YmYcDE8fDB3XxD360QK4ZeBgs0KJm/SOORZgBl1aQC1tf9PeuYUiEOhirfA2LMCRTvU+r+sPJnvX1KNeM03K9SOf9FygFxewwzY2Le36yHfBqkOjBAdpRUJGgPmCRe01sQIJV+maAkQw95j5AxgplnJymn8S4INdwtPtiMo2A/7r3Xyviv/7fcBRY7HiRaKA/ObBA02Ffg96xaabQEc3noz6fj/3Ta/45P7gIwVQqewJvS2GiY+d0wSoZJrACqDuVUFIVjyoIDUpL3wnrA6BGIl2/WRdvw6GcCoE4mg+x4+eFsqJL5fcAJRGQEabGd0Il7PHswDvypIo2IAhF9LX6RG3tGP9/BITi1BI7DCI/SMXE4BZ+lQM1t+uhPytTSSq8PF6HvSHMIl90gUmDyybERs8v6j3Q7QZ2y3cgYFegw1hp+8dzqcRKuKOXBI7SEbYGhITCtWjRovqOSsyih3ejPzvGX6rDB5usXbnUSCVyqUDgeIj3gWBsXwQJ92vO+5kKzdY8l2NFyoM7z/d4yXU0vEzsI3hvXqJDBQp7CAtT2DI5FEcqSi5+G9SkDqy7pryT+BkdQN1kWN/ctYO2WqWsuEDlNEh6u0FLc2vqR+uxjepOM8xb+dIDsWoWtxQULIg8ig8NBMRGMhKCS0AgNKVufch5XQblVhjk/qm7p3/P4/7bHPznxyn/CVCnceOYleCjy+wYYNkhil83rHfpNXHKtsRVENx1v80gh6j5eD8rCb7nLpv+NUXFH2JwhlQWNZbWHL2uDsFeswASd1r7b7yRNUYbnnAqOhvk8GGirZY6shNBVIjOYuAKP2qTVjc5rzRsIs3XRYqi4oBjJamZ3ObiYHpJShgKJzxyxEjuZgdAP8qpH9ycAFVvf5pqnhkzcnE
 zwgGsrdu
 aO/MVxeC5IptCrFrsaxSU8moA2uEQQI/ASoMLOBdpqs97+RWK7TBsDa8Lg5fgyrnJLUJDKcYt3jdOJwId91O0v8+P9+XPkL0UQcfxluWNHFy02D8u1j+48+oQl8fiXMJ02xqsxRs0s50DWhu4x7ucVU6Rcg1epUPBobndLcwm8g1j4x17XfRnF3ke5wV22JBlgjOjw8K+hdhgFXTQ7pe8nhfW1u7tPrp3HduFvPzizOUlUaa4yT9NB2BaBwvp5zxTn/oQ8jo2YBN6u42Q9QQ0DgADAspPu6q0TJtjY8wOzSmjOgbMm+sJvUeu2Gdui+c0Yl0p9jxam9FsNlJEJ/KRTvCM/3DBmbCMxhxM3ogmy7FUIQ73PS7XEZw3Qa4t3ERxwm1eQ2Sy/j8Ai/48Zmv9/Z9Km9Eaxbm+4XaGRgYYq9ynZH5gd1KebXi0r3072mlE8/0ayEnBUaKNV3k1W1yZXbPhXEMjN/rewt/SAe4rwRMtL0XnSL5do34xnBK5X4+dUMl26N1IRSj18Y1bZ4soHebOtzYMd/8c16uMEsnUdCMRa0Ma8IiCw/UK79IwZHPyhX2S7KoMJi5PNeyHOoU6JuWjPGHx822Lrstn0qb2u8bbUiryreODbgLZxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mike Rapoport <rppt@kernel.org> writes:

> On Mon, 22 Jun 2026 22:57:35 +0000, Tarun Sahu <tarunsahu@google.com> wrote:
>> Adding KHOSER_COPY_TYPESAFE and KHOSER_COPY_TYPEUNSAFE to copy one
>> serializeable pointer to another. It basically allows copy of phys val
>> of the serializeable pointer.
>
> Please update the commit message :)
>
>>
>>
>> diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
>> index 5e2eb8519bda..c1b61d875dcc 100644
>> --- a/include/linux/kho/abi/kexec_handover.h
>> +++ b/include/linux/kho/abi/kexec_handover.h
>> @@ -139,6 +139,17 @@
>>  		(typeof((s).ptr))((s).phys ? phys_to_virt((s).phys) : NULL); \
>>  	})
>>  
>> +/* Copies one serializable pointer to another. */
>> +#define KHOSER_COPY_PTR(dest, src) \
>> +	({ \
>> +		static_assert( \
>> +			__builtin_types_compatible_p(typeof((dest).ptr), typeof((src).ptr)) || \
>> +			__builtin_types_compatible_p(typeof((dest).ptr), void *) || \
>> +			__builtin_types_compatible_p(typeof((src).ptr), void *), \
>> +			"pointer type mismatch in KHOSER_COPY_PTR" \
>> +		); \
>> +		(dest).phys = (src).phys; \
>> +	})
>
> I'd suggest declaring local variables for the pointers and verifying
> their compatibility. E.g.
>
> 	({								\
> 		typeof((dest).ptr) __dst;				\
> 		typeof((src).ptr) __src;				\
> 		static_assert(						\
> 			__builtin_types_compatible_p(__dst, __src)) ||	\
> 			__builtin_types_compatible_p(__dst, void *) ||	\
> 			__builtin_types_compatible_p(__src, void *),	\
> 			"pointer type mismatch in KHOSER_COPY_PTR"	\
> 		); \
> 		(dest).phys = (src).phys; \
> 	})
>
> IMO it's easier to decipher this way.

Okay, Will update in next revision.
Thanks for reviewing.


~Tarun
>
> -- 
> Sincerely yours,
> Mike.

