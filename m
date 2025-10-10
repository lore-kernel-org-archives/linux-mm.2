Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62F57CCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 17:17:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6986A8E0030; Fri, 10 Oct 2025 13:17:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 641228E0023; Fri, 10 Oct 2025 13:17:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 530198E0030; Fri, 10 Oct 2025 13:17:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 409118E0023
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 13:17:44 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 943C713AD43
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 17:17:43 +0000 (UTC)
X-FDA: 83982861606.14.F072BF7
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	by imf23.hostedemail.com (Postfix) with ESMTP id ACD2E140002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 17:17:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=eUw7rxWA;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf23.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.166.43 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760116661; a=rsa-sha256;
	cv=none;
	b=3az7rmzhHWCqFdzSsqvlWBhxWYKpKqGd6aFVOlCeNi9cPYb1xoq59mmIt2KWTYKzKb5RuT
	DR5Swfyi/P7Lj9ck3nUAiVHsMk1TnbAF/Rdj5NGeaZt5Q7iUn8bAKiS2zhls+zl7WGH4cY
	tnr5VWrKI+MhwDc5OFFf75EheuYoEME=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=eUw7rxWA;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf23.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.166.43 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760116661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6G/IEc8eQi80LISFTxnAaN67mBaGX3+NUViuwGCrxp8=;
	b=ep0trmpyQACnSxeHxA2AvsfWYfY7FG0xk8pmFj7GeBHq9120McNuTYZpaHPs94kQaZNzUY
	Ycj0BxtQtZ7RYW9VOIezCsBLhqyvzDs3KZdkt8E8gg4IpiO/hJx8lO+RexCCbQVwPYx43v
	kZuc9zt55Q+041IfY5qEpoynmZ1QxTI=
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-92b92e4b078so97147239f.0
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 10:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1760116661; x=1760721461; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6G/IEc8eQi80LISFTxnAaN67mBaGX3+NUViuwGCrxp8=;
        b=eUw7rxWAUBI8pdnF/TN/xY9ssGgRIfHYzOkQbu7kwUx1ncvyXgnR+FhFQwmTkkCXVI
         q5pJrGtUfjyXbgsKZu9PKNSf+KHpclg7K2KlNCrVsfzx6ytA7RKiUxKvhq8Ep2lnm5Us
         To7YEk5BWgeQHvDEeYXWrC6CpdUYu6Iq5A1bhjzPrutJjP6ZSulDeS8/46nMXOOIw0PD
         l6wlWgKarEgDmW2j7pf2Qij3fMtS5zXqNu0EspPME2DUCMNQ80ILC8jObSBbSfHITmxM
         9SZVKWSBBQBixzezkpz/QDUSj0ubOPSnanDg22eNfaI6Ug8yxcFEK2yPD4br+C00/0LT
         4F2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760116661; x=1760721461;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6G/IEc8eQi80LISFTxnAaN67mBaGX3+NUViuwGCrxp8=;
        b=jLfMB6VCfqBVPKrZU2QP+8JRWoYoCeogT3XVrm2hl3FyiSJq+q8C5/ChoXqSEpR43L
         bGZGYGFHkO5EXdi1ZynfUxFNu5ZM25h2ozGsh9B4LYY1SryQcTau2n6KqWx5n5Afgzg3
         XWc5AllBz6UJVPGa5qsO8YCa2ctykWdR3Se9qytFF6tgTmwx0HZiV28Zjp0MnNWh1ERN
         Eg+h0gMtwTFrGb35gCNVoT8PeXGYSPV41zo9zHAHC8uYUa38MWKbpMintPEnIBrrf8To
         hoGktRW9g53hpXqNa+wzcK2QPDbqq7DO/0OGWRFfWizIzFWGo/GVz2m4O8BHMbjs6aPQ
         TQvQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmFNKTWhfWD2xlX2rYLU3cnBjI1DYUsDMZlvaxSsqWbdoHhJL3xd4kmaPAvqq64sxwaGANdixDlA==@kvack.org
X-Gm-Message-State: AOJu0YwBeS9cskJnSj6/6Q1j/8BoGP/aC6gXKFr2I+Ze50SwWISc5foV
	xX7idvoYVe4uEX3kf4KZLS0CZHTyxGp61/EyjDvTreX1st6UOJHEP3PwbmaI6o7rCOg=
X-Gm-Gg: ASbGncupkTUX9LeCcnrjNGxVaAYFThXSbh4JQ9+nyPy29flH6WqXpYwrECtbcjx6d8S
	2C1ituZCT9jkdqIp0NtorRSUPqgnBv6hwaVx/hr/rkhyelyl4PfnWKk/NhHQKVyQgAQHycbLvMY
	JC8P6oSdyCQrA8fG0fXhshLijlxORAMi4m5pfGQHOCLXMwhCT6Q9xG3aoGAB6PMQCHrbnBortx3
	jBrJSiXn2UXO/Xc51Ntihm1MkyPVpSySIh/NazOwiwDWGkIiOOBz8KxoRuZFLa8Pvef5Z48gMcD
	NL5E2e9p0idr2sC8ln7H7UtVhKB49lcI9CkJdabFpun6XOeIO153b1ok8E7O348ERenJHfSga9K
	THowgJOkRyt1+F9c0xNvhlYZVPeLoDFdOqwOj9eb4J0NMYyMX+QfXZYwGVw==
X-Google-Smtp-Source: AGHT+IFf3Dfk1VAV0Y7S/J8epFVv9DK6aEZ68GWSHSQhqH0ufWaX/0UhdYSoDg68NQQ/vOlVIsMBKA==
X-Received: by 2002:a05:6e02:1a8f:b0:427:b642:235 with SMTP id e9e14a558f8ab-42f87374f3bmr135463955ab.10.1760116660354;
        Fri, 10 Oct 2025 10:17:40 -0700 (PDT)
Received: from [100.64.0.1] ([170.85.6.207])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-42f902962fbsm23231445ab.18.2025.10.10.10.17.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Oct 2025 10:17:39 -0700 (PDT)
Message-ID: <126d2381-c913-4815-bd9f-b6e9fe3cf5d8@sifive.com>
Date: Fri, 10 Oct 2025 12:17:38 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/18] riscv: Memory type control for platforms with
 physical memory aliases
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Conor Dooley <conor@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>,
 Emil Renner Berthing <kernel@esmil.dk>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>,
 David Hildenbrand <david@redhat.com>
References: <20251009015839.3460231-1-samuel.holland@sifive.com>
 <20251009181559.7bfa3dce6cb7265822b2d5c5@linux-foundation.org>
From: Samuel Holland <samuel.holland@sifive.com>
Content-Language: en-US
In-Reply-To: <20251009181559.7bfa3dce6cb7265822b2d5c5@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ACD2E140002
X-Stat-Signature: e1x7q18pw3gbjtyoufuuuanfi49q8knn
X-HE-Tag: 1760116661-183575
X-HE-Meta: U2FsdGVkX1+jnp2mu4jmtewz/aAyVFbHZ1XYbqvdBv7vOzWTyHJNjSwYRHG2WezGv4rGfICpVkfFGCgC1ioK3cc03YaV/QVppTD0wKJZiYMM+MDW8jnnnz1au+Y1a5vo+NoE8efFsNm7ZkDGrZcu4N91SHjTBt/W4POzQ0hxJPVvlg4cjf0JweWaBblpJTkXmkqwj/Jru8CLR1ZPFxKGkkvHIP5HQk+WDgEazXy2ayqQBLqYI0Q/eiyog1+SU8tBsCRiAthzAi0MEIP+jIk4a1ekbmY5/EGBAsFUB+BnjfoFB1wR1NrdfhqPwwpFSM7vGLwgFtd04ottvRu17OPbD2QhDd4kx26siNxL9RSMfDsbxeaeVjeNUV6SRgWaOzbvEct88UsM2EfduFnqN4Z+XCK7USCNmyKyotyn2uw54RNDhfRLr608n7qtEl1xQDna0nr+TMAzPE2sO5Kk2k+fRRDtWLYZ5J/j3aUS2VpQrCTI5lxuI3jr6zG7UFdBgt+7op2jL1OYUf/jvIsQ+DkxtoOx/NMDVofQjcrJrhw2qRragrxWMH+XlVVWrZTN6CWvrzBPfjYkfhcg461VLJBDL0WhMm+UejnAMjx3CKsIWArhjhfvup1FHuu0gBn9ZERb2a2NolV7OyPNZXFst/DV7u5t8Rwsy7UiMd+KxQXNHcFQE3im/KrcFheP0YfvFjG/j+7oJbFA8octFCXx3cw1kcywq8Mgf6bccHHcg5O2MSk36Ec7+i8lU7pYKn8MDXdDHEWzwJas3BICkIQbdA8KDdREN3cCV0onK0slp7dkKkKTAl942T0dBCbSC05VUyY4GuLIMQ5xY4VbXH/Qn/1p9FlToVbLMczZ4TL78EsVfJUIrdgfQjDtjekYNGnexU3oiXtKNJNL0e3zYryWgrIMd7y8pSi7QZZSjhwP6Z969Cp9aTnJMgz/fcaSDBvJ+v2MdSDmT9uiPNSAgOm/DH3
 aFTO8VkD
 uRkHmbKvh7U6FEEgxkeM+bq59bemPLtxzVDuvMvGz8SRNbC4tVXnc1HQG0cXZjZTBrO+fPv8Ke6rHel22TcIoM1Vzo/PkuFhg+P0s
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-10-09 8:15 PM, Andrew Morton wrote:
> On Wed,  8 Oct 2025 18:57:36 -0700 Samuel Holland <samuel.holland@sifive.com> wrote:
> 
>> On some RISC-V platforms, including StarFive JH7100 and ESWIN EIC7700,
>> DRAM is mapped to multiple physical address ranges, with each alias
>> having a different set of statically-determined Physical Memory
>> Attributes (PMAs), such as cacheability. Software can alter the PMAs for
>> a page by selecting a PFN from the corresponding physical address range.
>> On these platforms, this is the only way to allocate noncached memory
>> for use with noncoherent DMA.
> 
> Well that's weird.
> 
>> --- a/mm/ptdump.c
>> +++ b/mm/ptdump.c
>> @@ -31,7 +31,7 @@ static int ptdump_pgd_entry(pgd_t *pgd, unsigned long addr,
>>  			    unsigned long next, struct mm_walk *walk)
>>  {
>>  	struct ptdump_state *st = walk->private;
>> -	pgd_t val = READ_ONCE(*pgd);
>> +	pgd_t val = pgdp_get(pgd);
>>  
>>  #if CONFIG_PGTABLE_LEVELS > 4 && \
>>  		(defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS))
> 
> OK, but how are we to maintain this?  Will someone be running
> grep/coccinelle/whatever on each kernel release?
> 
> Please give some thought to finding a way to break the build if someone
> uses a plain dereference or a READ_ONCE().  Or add a checkpatch rule. 
> Or something.  Let's not rely upon the whole world knowing about this.

My initial plan was to add a script to scripts/coccinelle so `make coccicheck`
would catch any new instances. This would require some way to avoid false
positives in the few places where these pointers are safe to dereference (like
the ptentp and pmdvalp mentioned in commit message), such as a separate typedef
or a naming convention.

I had also explored using sparse to annotate pte_t and friends as noderef. This
would require changes to the sparse tool to allow noderef to work with a
non-pointer type (and get inherited by any pointers to that type), or else each
pointer parameter/variable would need to be annotated in the source code
(equivalent to __user). Neither seems ideal.

I hadn't considered a checkpatch rule. That's probably the most straightforward
solution, to warn on any instances of "\*(vmf(\.|->))?(pte|p[mu4g]d)p?", along
with a coccinelle script that could be run occasionally.

Regards,
Samuel


