Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 138F3606A329
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=LQR5RuTl
Received: by kanga.kvack.org (Postfix)
	id 319916B0817; Tue, 24 Nov 2026 12:57:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F1696B0819; Tue, 24 Nov 2026 12:57:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DFE36B081A; Tue, 24 Nov 2026 12:57:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E71196B0817
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:57:11 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DA3F980C56
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:57:10 +0000 (UTC)
X-FDA: 85470769020.14.EF677A8
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf06.hostedemail.com (Postfix) with ESMTP id BC9B618000D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:57:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=LQR5RuTl;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf06.hostedemail.com: domain of nik.borisov@suse.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=nik.borisov@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795543028;
	b=jXirCfkrEbQtF1Q/rbqaLwZugRifdbSdqdK248Q8Lklgl+gsVjZ+QwVlrCfl3A+u/PeoR8
	wDQ/GxRSHcoFOrrrtoTmmgztGRBsH32SzQfAaIqsHcwfey+KOmp5JSGfgR0QJQtd9TsnNG
	qdzeKqjO20cCzsDjrAD1xnWUAKyyCYE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795543028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=icWoxjPKMdK2zuS82/rLrHvg+EKrMTW6YtEm9PqDifw=;
	b=3Brq8j0VA6d47ufhhy4NFNMTPGS6nvezgD87lgqKPQOSFdUkDSsMTothZ7ISHSM0yDMsU5
	mq4V+tQQ28VCZPVDQuW93IjNfdMRDx9ZS3KFoSVtEfq9Bdu/Cr+b9NT/XBKwUEjqShGQ8T
	aZ8TXggtBnpvjWy721fAym19RI3J2kM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=LQR5RuTl;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf06.hostedemail.com: domain of nik.borisov@suse.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=nik.borisov@suse.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c4cb6834eaaso802314466b.2
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795543027; x=1796147827; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=icWoxjPKMdK2zuS82/rLrHvg+EKrMTW6YtEm9PqDifw=;
        b=LQR5RuTlz6bcuVhl+OnSVXXN9MM5Xsh8r+dJCm70FeP75z3krV0nkcw3TjNFVjCzmh
         mWAdOspKaljcuzhVz4ucT3XaEJqbIULtrgt2mHw2+DBY6COK1LxHhOS4QxKKkWtJZp8k
         wsjNtNhtgwmQHg9NqXYqzRiCfg4paAMb7xCeehVl+ismju3VPHEPe8R/t4VxR5krMDDj
         rNLnCXRsh8w9GNNf0xDafvD4AB/RMiiEdxOvOut61AyvtIBL/bPrakpXF+HMxWHPDK9w
         I+eIlCoohNX2QMu5A5rXtSVhHILfcEwSZzMwrtvHROfZyYx25UekBbzix2lToIDxfUu2
         iyoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795543027; x=1796147827;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=icWoxjPKMdK2zuS82/rLrHvg+EKrMTW6YtEm9PqDifw=;
        b=ok1quyjNUfSx2WEbB061xZfrH3ovJJsdIPg6i+BQ61O3nVpFUTZ77lxQk0cIAwFgMY
         Q0VixZArMHg63ojtRhTiRMZ463X7Nonc9U3C0wl2r2PXv+nsXrn0y6Sxc+zEeyjW4lIy
         1+IJXhGWZUT9XruYvfjVQWcAKsj+7kGbIhtpnVExa/1LoYPWu41y85HQcZ3UE7b5pdGj
         eMwnAaV1xanYTl8LT5a/WD2tD9Q5d393yrCt8DRs/IvPKh1e8/RUIyilz7d3hYN+JeeO
         epjWjaSIoW2T/XRf84SYc5u8UNWm3XbsE2OMv99nynBsT4MYK0xgRPz2jLNqQReR5MdQ
         4QfQ==
X-Forwarded-Encrypted: i=1; AL+hErHHRZV7kb4IIQxmZEn8mLwjgN26mvo5shT1Hx481xaeACu6Pe12zlhm+CbPNZl46+P2b9BkYmdNtw==@kvack.org
X-Gm-Message-State: APuU4Z/+MILmZ5q6ccn0g8WNDB+tH9yeiRCFza3U+e4bea3PCpFyEs+l
	9MMrsAwXv+gKwQs04h2cBM2+g4892jjhTfboQ2HHreQQkoz11aL6L3G6/f8rtUZDZR4=
X-Gm-Gg: AZFdTZc1joIl4Du0Ju9QtuQ/CWFfIm4E4kY6bYgLjQ65sy4q9+fLikpJN9MK5KA0063
	UQcKpmII9I8OMWTzNrF4DHE31NvDC+0L9Z6HMP8iSIxNHzwyCd6AeEp4avDSBqq2QHAmZdWq3Z4
	YTIgKe7Z+cbZ3fzDipPa5xE87TtiJCLRj5nkALrJIVOyY5E66eVL9nBrInTA9of/b1c8hYB1feQ
	SFJHAWLt/VPdCBXLPwRZjsU6TV1xpBhzbyzfCBR9S7lWX1v19rNymF8i85kqwv4UFMJY9bfv61B
	vhZUi8zjHz7uCWL0c9ZkBcp3pBTNu8Cm9jPJSSmhVWSm/fNoylYYh10iP+NOIuXebtwBdxbmzOI
	9NKlqStS8aSHkdaU3/K4kLXh/U0E0PXnNLXtRMZBy3xyAuuenGEUFaCfhUy3Q1pwzifvZDUchQD
	q3sxewiUv5xtRBcy2zfUH80Wznz75/AzmRSEApVdTI2nw/jG7kJDjDboDnU3hptCvPSH3YcNDZM
	HC1+EmIN8PGc+QDhJS4Xywe7AwBVCTJzrsgVqZNPoCDNvNrqTKTkcel9cwvW9/5BmS5J65+WSc2
	ErJWuY2MAbp/uVmARYohX312WQNe5xwp
X-Received: by 2002:a17:907:1187:b0:c49:903e:1e19 with SMTP id a640c23a62f3a-c513a8595d0mr990271566b.26.1795543027309;
        Tue, 24 Nov 2026 09:57:07 -0800 (PST)
Received: from [192.168.0.20] ([212.21.133.162])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c513afc2d97sm541021466b.59.2026.11.24.09.57.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2026 09:57:06 -0800 (PST)
Message-ID: <8500860b-d2ff-45c1-8604-28a2b3d66382@suse.com>
Date: Tue, 24 Nov 2026 19:57:05 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND PATCH] x86/devmem: Drop /dev/mem access for confidential
 guests
To: Pedro Falcato <pfalcato@suse.de>, Dave Hansen <dave.hansen@intel.com>
Cc: x86@kernel.org, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kees Cook <kees@kernel.org>,
 Ingo Molnar <mingo@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Kirill Shutemov <kas@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "Naveen N Rao (AMD)" <naveen@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>
References: <20261124160025.738362-2-nik.borisov@suse.com>
 <0dc6759e-ada2-461c-85de-809c170abd6a@intel.com>
 <awXBtrPSHfs51Y2f@pedro-suse.tail5790ac.ts.net>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
Autocrypt: addr=nik.borisov@suse.com; keydata=
 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
In-Reply-To: <awXBtrPSHfs51Y2f@pedro-suse.tail5790ac.ts.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uipdrzqic6tzuhsodmaqfk84bnqak96c
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: BC9B618000D
X-Rspamd-Server: rspam03
X-HE-Tag: 1795543028-795035
X-HE-Meta: U2FsdGVkX1+2mv/SgFRJDh+aWbws63VwqsN+X0YXXz2bxxe3Udlfp4DaW5KWLRtVlMjIgxMccLHk/slUnu1gQP9Os9N86x56srRmZNRcPaVqzH4mALauA+9mCxSPAGzAq8AJX6f6nkfutzpek8OENEC9n4QY9TNE+020FC2rgWcg7k9JE8ZH8PJJH9RNrCQYEctG4PqKJOxMllHV8GpxeiIzUr+Ge1m+ZXAcCpt9zQ2Y1nEp/MTosdaneCk925QtZNkiJo8Maaud/BDcjUdoVGO7jJ/75DjGjNKozM7AZztXxktrk1+IqwgGP8W4kk3Z0tkYrcmCumrywA5YdM0J6jVldX05xh5h6BDJm+gcL8QZ9Ur2jdlOpi/TyJ6gPUkBKSybxHEEQnjQ1Mn/Ko7PS33Y+LLR/OjnlQQyxhnPLJN4jGS0Jyh+STwpY2CEr9PJbrCpEXxxMxDGOoueFTbcqIfLm7mBdErVR6SkQr7GvT81LKwvVJm+hs8MoMWQbv6jgbbremh2uHAGG4lHQrYPTl/8lyzCoFjyWy07CgHFW4bq5cRpei041xM52KKTEbrzaHpdlrCIrei1f4QEmzS2pWdyq+1GuZgT8YXTnhbke/27h+egu+EiPNHCy4tTPrtya/TCL5u+ut5wIP9eveTz3cBz4OZfXfNDH1IYmRvdNVk3Hza0Plbnw7eMl+iUko8tRy9CXc4MII1M59bvI+xjzMHBVqpKtMABcDzEITJrDAmKbi/cpzSooRZwMz0lsqF1shZsR6NFg3IDfnUJdqtOfDWqux9GYl9WZp4bqj1eUytqHiUw450EqMpaAY/PEj/ror9Hue8klCCpON7Ud0Tx8SdRbhQzod9kAQ+xMnw4qXN1UdEsNsd0jCp/dFUUpajrBEkmX/1bClPeLIBb0+8X8nhfa4NaP0hwIicbwetUF+AKPUxwtA4CU6PynPQ/W6Z9qWSWZBM4B+xJN/q6GKP
 bv1jr14s
 i8Od3P7f9a9oHronI310IoqgaHF8vvMivLD1znQQvHK0bNpqNcOtmt5K+6AYbKLcim2by6PdukxVIsvhAWdCC9IaHZik0QcwssM/5l+aY4rBhIinUGMC1nwlVJ7jjJZDr6ZoMUJ7dGaM/V852AwjxDKe6sUhhlA3nGI2y5nxXf6nhRfEMYJW5vjj9UFdg+uRQfw4i5IrDuNccxlTcVr0pUr+o3FZ9G7o+gzuaRoOXlCW+psUq+CklwMZyFdK7czvVfRy3AqxpJ6uZ/zFvLon21XE0JHnmLmW+fYD0SUOfENTOpt3b4sT10btlmqfRIdfqqZFMvSxhULm4bdQlgrH8hnlSgNK4hrHCxWXIAkmhjFZRbd0y+HTw0jykBahpp3skO1mvlWDHWJkKT6xBcM+Cd38Teb0YQZLENis8HP1sOaJDy0bDENGrPHyYAQxN5LHCssphu/QAl+A04OmjgJ/Ds6Gom5ofG/MDO1azvCuk7YDItqfXU3miKpsH48ZdGILHWRJ/6T1Y6LMNoiQBNGfCR1Kx6GM1JFWL7h7m5DSk/ihr5vSq6fN1+XPIsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 24.11.26 г. 19:10 ч., Pedro Falcato wrote:
> Holy cow the CC list is stale.
> Fixing some up.
> 
> On Tue, Nov 24, 2026 at 08:36:45AM -0800, Dave Hansen wrote:
>> On 11/24/26 08:00, Nikolay Borisov wrote:
>>> Resending this with the hope of either getting it accepted or
>>> arriving at a consensus what exactly is missing so that I can take
>>> it from there and eventually get something merged. As previously
>>> mentioned this results in real problems for confidential guests both
>>> on TDX as well as SEV-SNP.>
>>>   arch/x86/Kconfig |  4 ++++
>>>   mm/char-mem.c    | 10 ++++++++++
>>>   2 files changed, 14 insertions(+)
>>
>> I'm still OK with doing this.
>>
>> But I didn't want to sneak an mm/ change in via the tip tree. Any mm
>> acks or naks on this?
> 
> For what it's worth, I don't love this fix. Yes, it fixes issues in /dev/mem,
> but it:
> 1) skips any other potential problem spots (I don't know which)

Well that's not saying much. Of course there are thousands of bugs 
lurking around the kernel and not any one patch fixes them all.

> 2) open-codes random CC checks in mm, which is kind-of regrettable
> 
> OTOH, it's unclear to me why that CC check is needed. If configs select
> STRICT_DEVMEM and IO_STRICT_DEVMEM, shouldn't it Just Do The Right thing?
> in iomem_is_exclusive, etc. If not, could the CC awareness sit there
> instead?

Well, you are right that if we retain just the select 
STRICT_DEVMEM/IO_STRICT_DEVMEM it might fix the immediate issue. I don't 
know why eventually Dan decided to also add this check, I guess it's an 
instance of "fail fast".
> 
> /me doesn't know much about CC other than *if you touch something you shouldn't,
> it goes boom*
> 


