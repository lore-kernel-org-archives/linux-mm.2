Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECCA4CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 17:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 248018E0002; Thu,  2 Oct 2025 13:09:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21EB88E0001; Thu,  2 Oct 2025 13:09:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15C108E0002; Thu,  2 Oct 2025 13:09:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0456F8E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 13:09:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 980FB59A1B
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 17:09:04 +0000 (UTC)
X-FDA: 83953809408.04.1219F1F
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf22.hostedemail.com (Postfix) with ESMTP id A6F0CC0005
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 17:09:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SC0osd5q;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3rLHeaAgKCNcC35DF3G49HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3rLHeaAgKCNcC35DF3G49HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759424942; a=rsa-sha256;
	cv=none;
	b=6n8tF5e8WtdKMhCq7X4gMKlajxl9OuUx0k8ryNEyvz8kndNeKEW+RkY2BKuTeMlt1WF0w5
	0v1ftr56wQi1mXaWZvxsEgKyQ74YyaHQMmG8Z3Ubs5KEBtqJrOXB3+ObjOXjnVA3abpWq7
	V763tHHOsBOgNBCrq/9pnOeJl6twwr0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SC0osd5q;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3rLHeaAgKCNcC35DF3G49HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3rLHeaAgKCNcC35DF3G49HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759424942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d+9vf4Jwiso9F3Y02vPP8NSYVqJvXagA/c4Pp2UKX20=;
	b=VMEK+2NZYZcUKovV0ktnecK0ImaovuFlb52xEu52Eg3k8zD+bYbmTT2hMUeo7NcnaG9rra
	+lpG4rEsSH3UojaWAuUpq2pOL7mFv/MyLwdJuinnM3yCfj52DpEZm+PQ7xvgt0WZ9JiMEl
	0Zh4zjnzglsZhnnXZaeg4e3WpHwWfBg=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b4626b2d07bso134684866b.1
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 10:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759424941; x=1760029741; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=d+9vf4Jwiso9F3Y02vPP8NSYVqJvXagA/c4Pp2UKX20=;
        b=SC0osd5q+0Mb5wPxMfELbjyF2+wAUY+YVVrCcK1MO+MNu9bs6fXf9XVpJbG4iOXt7X
         qlxDv+gEg4cVIL5jmOOvqPAzqqJ9eZFnC/Ogy4flMdnD8MpcB65twRpg8s9IhZIe9INJ
         y4wJWpn81GRIzBis/8bb3uiao/BlaOqHijWOl57vQOjdRxn9xFsn0oROppgZjzFdcoE2
         giOBCeyikthzl+HrjXz5cLLkAOpJirLPvesfuLcFYvsr8Vn7iiB7JWkvve11ylY8iGvQ
         nGj70wzWbIva6lr2U2oWaGzYoHoEfGU3d1Lc+rMFlP4aOuAPqxoqk+vMHoghuQDYWvrC
         0DCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759424941; x=1760029741;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d+9vf4Jwiso9F3Y02vPP8NSYVqJvXagA/c4Pp2UKX20=;
        b=U69CNbeIde+F0sPsOuWMmbhjZDRQ+B4/FjoJdBvQpVHiR7tZLcEAGKRum5g1g9P4z2
         ekchLNBpC/mK397DBpraumw9XSN2kY63Qo6d4X3ShrPfG9JduYuZxCUcSYO1IEguUBsU
         K9ks4Q/mND1EIEZo/TeGZPhrdJZBOSQpTS0EpbD8+zrX7950mnHkLiGnr3eP6LjEc8l7
         avMEqjwVj3Is/rrd3LVTd1jzssIRMnYTiryUrzWG4kD9RrsuSnmOtnA8GIZrnaHrK96M
         nG1Y4xGYeUDWcSV+gz50HU+2TR3ZmK8QTuUmciGY6VxmjLzRGiLeDLB7P34xbnqVXc+h
         ZgNA==
X-Forwarded-Encrypted: i=1; AJvYcCXsyKwCqEZpWjz2LTYM8FBqMYEVlSIz6nsOOxeqhq2SWvmqf7Su6jQnMpG0WWuobbPK6KzcdGMGrQ==@kvack.org
X-Gm-Message-State: AOJu0YwhrPVcJYLbE5NGTqWwIj2NLPyV4MN0u2N5n567fLbMSGm/j7nZ
	iWJbHH/7gEZGaOHK47PRQJXnA3uaciVC+TA1rEQ9GfI8Cy6MAmndyiLbYFl5M1pwqIROu6QZbC9
	5kMPq5fEQqZNM/A==
X-Google-Smtp-Source: AGHT+IGKMxTwF3i3+/qTvA5h7gHpdu2tX1PHS/EAhbrLp6zU/xDFnlc2KHFRVhsXz5+haLREIW8oS2NfjBoTGQ==
X-Received: from ejdf14.prod.google.com ([2002:a17:906:84e:b0:b2f:99d7:b88d])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3f82:b0:b40:8954:a8bf with SMTP id a640c23a62f3a-b49c1b6d3cbmr20560166b.2.1759424940627;
 Thu, 02 Oct 2025 10:09:00 -0700 (PDT)
Date: Thu, 02 Oct 2025 17:08:59 +0000
In-Reply-To: <19e5012a-3c58-4696-9e4e-39e2b7d2b5af@intel.com>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <20250924-b4-asi-page-alloc-v1-5-2d861768041f@google.com> <08338619-6aa1-4905-bdf8-bf1a90857307@intel.com>
 <DD7WQ97R8OG6.1CA5E2FU5ISMZ@google.com> <19e5012a-3c58-4696-9e4e-39e2b7d2b5af@intel.com>
X-Mailer: aerc 0.21.0
Message-ID: <DD80374YZEWM.1L31D2VUKK80C@google.com>
Subject: Re: [PATCH 05/21] x86/mm/pat: mirror direct map changes to ASI
From: Brendan Jackman <jackmanb@google.com>
To: Dave Hansen <dave.hansen@intel.com>, Brendan Jackman <jackmanb@google.com>, 
	Andy Lutomirski <luto@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: <peterz@infradead.org>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<mingo@redhat.com>, <tglx@linutronix.de>, <akpm@linux-foundation.org>, 
	<david@redhat.com>, <derkling@google.com>, <junaids@google.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <reijiw@google.com>, 
	<rientjes@google.com>, <rppt@kernel.org>, <vbabka@suse.cz>, <x86@kernel.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A6F0CC0005
X-Stat-Signature: 6tpjzz9gqxnkqfirroxkbsofc6xzunzo
X-Rspam-User: 
X-HE-Tag: 1759424942-705245
X-HE-Meta: U2FsdGVkX1+0E/Xk1nhe0AZojjmoHbyPqFTK1RfDrfgILjqWyRKD1QWSJkrAwOm/3QVaOSOeA2NaayISLzYEBklQjkAi/MCkjK2vEG9Xz2qwZYaI4a6nB7BSd4oA1BV6c8eMtcqNMak3DPCfGdT3CCLhQmOqwGGlJvNopgMpRfNuv9XOl8zyCZBVgt4R8xV7uPNFdDJBDGhyTnraUMczLJD06cZm5hVCuepbQNMVf8rFIPkAnJHZLucUoYnU5348Cf4vufejBVldGT34oLHYonJ/BU0N45ZlywU154A1gQ8bwi7QBe3c+Psh5H3R+vwaEWmlZT3fpfUyZ+DeZFgkiwZ6uVtBb535CN84nfYWgKGIKbhUOwURtEg+1g8hF7A51RHD1KY3AcLbwaXnweMQwmWYCLA1+kFrtM0GwYi4EQE7/qoenv3yeFAfbIx8THRG9k2vXxCdhjHKCpC/SAL6Z8UiBY3jIdMw4GgDZ+p6qejp27pa847IugpLn8xlzir0F00dTJ/ihPwGo0U/fIYnuvs1/LaEPBIkTJLEBk9rqj7IqkB+mUOHUF+A4lX9AGMAlBkxIgRR1kCai/JKDkJCK5bhFCBpTI/pbQ0G7OQEEHHLKlEHbm5it7Dg7msDA29IT5QZt3XZliqP1QPS+fjcQ4bXEuL55g83pXugvHYyt4lRijAXR8hyLZT84xozap6AMbIHI1pv9BcwJIzMUHhbdFCN9T4zEVk9/R1EyCguAc8KQezxyeVQXTbzWBYbnZuKVy0S2arYL/GDV/B+fM1E2bik28f0A4ZwIxQBEZrvq8c0yFL+n3baW0mQqx+FnOCW/B95tYsMjBBrQyj6zetJcqBgJwKK056s+BdpH9Z7NyUOZObWLR0XXFs72824viOiZ0xXClr93C9K1ZyTOjxv/9YON9Y5zyNAjjrNl5nacySZ6sbkTVmDUWXwuKuy0V4GrHcfuMFxd23tqPjNzp5
 gZuMENO4
 HVkCSYp8jT8PWDcqQi8oMp2H7hLWeJTXiBjGIn79npdy+9ervq3O4DDSSxmMEF8C9eaNW5S3GMJ37vmvDbdN+aYcBKIDlBkeZp2gPPG4f/HmKdhCRx8UmsG3yRZ0tgpfIqSUKfs2bPDnOgPka3JKU1yugEr7kp6IjNqo0pgSUfQZVSjfqwvtN8VRfG0i9GRzRL1NZSITYdlcM6mN8O2SrIkwJuleiprNAIT5MV/6bs2/fIzLPnAyLX4VbaX8VXSKlTKbDKX8eJH8+9Pm22x3kSj3rCl9tDzNBlkYXJ0DpNDfpBWkdg7Mfe6W1yAokdNVSdP4bEgVHzW2VyIDurPqI55gBb1FhAYIUqyLkhH7dcBvKr+dAnwzqr1JyBKHrEUZq3RDy5UilcPjR9wzotmo4E3WCup7iQanLZM9WkGmFc6VsiZcIPWE5I1zTB7uP2iPyf1tZTZoIASHxyOansL9reuBskCvn1jizqEqlpgMHD63Y5btM1l2jrsIgfbUSM5IGxYwGY+r4EFfNYN6cY8TCMKFhCCPc3p7sEL7pLvtnRcdkDGGpawAyG/u+xDSOOtoScOw1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Oct 2, 2025 at 4:40 PM UTC, Dave Hansen wrote:
> On 10/2/25 07:31, Brendan Jackman wrote:
> It's actually anything that has _PAGE_PRESENT in cpa->mask_set. There
> are a number of those. Some of them are irrelevant like the execmem
> code, but there are quite a few more that look troublesome outside of
> debugging environments.
>
>>> Also, could we try and make the nomenclature consistent? We've got
>>> "unrestricted direct map" and "asi_nonsensitive_pgd" being used (at
>>> least). Could the terminology be made more consistent?
>> 
>> Hm. It is actually consistent: "unrestricted" is a property of the
>> address space / execution context. "nonsensitive" is a property of the
>> memory. Nonsensitive memory is mapped into the unrestricted address
>> space. asi_nonsensitive_pgd isn't an address space we enter it's just a
>> holding area (like if we never actually pointed CR3 at init_mm.pgd but
>> just useed it as a source to clone from).
>> 
>> However.. just because it's consistent doesn't mean it's not confusing.
>> Do you think we should just squash these two words and call the whole
>> thing "nonsensitive"? I don't know if "nonsensitive address space" makes
>> much sense... Is it possible I can fix this by just adding more
>> comments?
>
> It makes sense to me that a "nonsensitive address space" would not map
> any sensitive data and that a "asi_nonsensitive_pgd" is the root of that
> address space.

OK, then it probably just sounds wrong to me because I'm steeped in the
current jargon. For v2 I'll try just dropping "[un]restricted".

>>>>  static int __change_page_attr_set_clr(struct cpa_data *cpa, int primary)
>>>>  {
>>>>  	unsigned long numpages = cpa->numpages;
>>>> @@ -2007,6 +2033,8 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa, int primary)
>>>>  		if (!debug_pagealloc_enabled())
>>>>  			spin_lock(&cpa_lock);
>>>>  		ret = __change_page_attr(cpa, primary);
>>>> +		if (!ret)
>>>> +			ret = mirror_asi_direct_map(cpa, primary);
>>>>  		if (!debug_pagealloc_enabled())
>>>>  			spin_unlock(&cpa_lock);
>>>>  		if (ret)
>>>>
>>>
>>> Is cpa->pgd ever have any values other than NULL or init_mm->pgd? I
>>> didn't see anything in a quick grep.
>> 
>> It can also be efi_mm.pgd via sev_es_efi_map_ghcbs_cas().
>
> It would be _nice_ if the ASI exclusion wasn't so magic.
>
> Like, instead of hooking in to __change_page_attr_set_clr() and
> filtering on init_mm if we had the callers declare explicitly whether
> their changes get reflected into the ASI nonsensitive PGD.
>
> Maybe that looks like a new flag: CPA_DIRECT_MAP or something. Once you
> pass that flag in, the cpa code knows that you're working on init_mm.pgd
> and mirror_asi_direct_map() can look for *that* instead of init_mm.

Sounds good to me. If "The Direct Map" is a gonna be a special thing
then having it be a flag instead of a certain magic pgd_t * makes sense
to me. I'll try this out.

