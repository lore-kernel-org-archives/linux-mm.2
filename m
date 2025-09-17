Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1AC5CA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 07:16:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05EC38E000F; Wed, 17 Sep 2025 03:16:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00F4C8E0001; Wed, 17 Sep 2025 03:16:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E18FC8E000F; Wed, 17 Sep 2025 03:16:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CBE068E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:16:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 85FE31A0453
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 07:16:37 +0000 (UTC)
X-FDA: 83897884434.24.CA5318B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1519E140011
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 07:16:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RwfhhQZ0;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758093395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dVrVz1y1JTYA35iR89KO57gWYWUGvkIopfwpVXaBh+A=;
	b=tO8dJRgvMDhiXabKUmaf7vLSDffUWqbyVrcUdVtYG2y6BpLWljc4xmtKd035270kaDwZHH
	F78S6k4vznIpUtK7myb4fk4GyKt9KXmPjCUngHkisMt4Oa4vDB1ZJPiS5ameiB2dVhpzIp
	eQ02/4r/PJGoL6VAFsoB4XKT0ZlWtJY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RwfhhQZ0;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758093395; a=rsa-sha256;
	cv=none;
	b=6HyMF84iqByeLmEnL+RcNFxYpW3ARDWw5fSiCC9+7O0FSG4AtcXezdAf/G1v8OOho7+d1D
	GOjQM1/BwPS6hWHcKi5YIXa7g5lxAOT/5KKtTiYjLhmPCjkLCZlXu/9WBRzP9Q3IUIEyWS
	9x0l8C6ymmvRVv618ylub/A0qOzgn38=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758093394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dVrVz1y1JTYA35iR89KO57gWYWUGvkIopfwpVXaBh+A=;
	b=RwfhhQZ0nGYUBf/zLChUZ31fGuBHJ8Z4MVzNZGayr5OdngOfmrPQEwVB91dDc4NEjKHKB/
	KOf6SCCd5HC/tVsgEKmEsU7Pjz42Sd+nmD8OsH34aEfwgeqN9rnHj0suwvydz/5jUvv0Zm
	LISK7ZgwZ6hx1oK+mNnZwUYilPrqpJs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-3XoB0-KRPxm1thWJQiVnbg-1; Wed, 17 Sep 2025 03:16:32 -0400
X-MC-Unique: 3XoB0-KRPxm1thWJQiVnbg-1
X-Mimecast-MFC-AGG-ID: 3XoB0-KRPxm1thWJQiVnbg_1758093391
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45e037fd142so52181085e9.3
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 00:16:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758093391; x=1758698191;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dVrVz1y1JTYA35iR89KO57gWYWUGvkIopfwpVXaBh+A=;
        b=KiPuqmj97dDeM81dRI+Q2KO/48KhDvcRE5P5RnKTbSnVnjcLQZdDRf8Z0ts+swYJIF
         oKbipT5HRu43dagJt4Tg2sWYnKyz9ZSHmfZPon+mYKeUZ6Q7wmfq6sUq2NlzM+9AANn7
         OoKpaAiUMW15xmKuq6D8ZVfbdRaauI0eA2wH6KkMsKuwZYhR0ZJSRRV7oJlq6+XNgDki
         4vjmEmmNnWnvXLxQ1GcvllVx54pE/Q28z/LyovCz4JkfW/9cJQ22yJyx2OzdGWEp3yGT
         m8LmFCfqtWR7nNJxAngPBcP+x8+GITbwHWVDCiVe9O8DAEb8gZ+jT1rvFDvEn3eoNb/u
         WWyg==
X-Forwarded-Encrypted: i=1; AJvYcCWVf/QOj2suTpYu5WnANZJs7wI38EBSecGOKUAkiT04u2lx0XKy0qOqgnC6meYBZhtftPryfZ77ZA==@kvack.org
X-Gm-Message-State: AOJu0Yx5tDTOBHGhZ1S9FjhqNLnXlCaGAAqgg2418u30PEwJlkMLDYUz
	SkcsKZI9jcqoqn+TtNtaRj7daWUT9rO4H+XyQQRdKIb2+mcjKKAYwM1T6AzOkOVpeqWqDFAgqo9
	lTe61S54Y3Xhrcrp14LvJEHvX1XSDCtKmwx9CF2mQzysZVDx8exDW
X-Gm-Gg: ASbGnctaW4XRuJ0o5xrQWC9BOJLG+1LPn8aamw89UPLegzxszG7yEmz84KGvbiIfylH
	BRCyu3ptXAfxY5uRGyW9YEiOVVEOWVkIQwd38Zr1BGmZtKGeIHMDeRPwhdypiQ8pdZ9W8ZOMjWi
	wsZPJFPeisNEu8jWNk74PQwcl7fwgdud8n7Iib5uH6yI/qDO1sjzVDCd1Z5YxSknIquxVHP37Aj
	WK/W/+SXEJBqK5B3mN1w2ktYw+Ge+cQYRP9zg1p1Val5UInSI2XHrsSHa5EgTjmdCtdANkpF4aj
	KPDS5nr7LE9L2i/NUi2eZnh7Ol6DE/O8lAl4TXkO0mvJG5MVfdq7OkNHoyplcISTeZBnrDJG8GF
	2x6/FGOL+YhPrTEgVX6oYYX5Y5vKcz4Fvg9qkiHNV5ZxNOMgJtoaXV8j9Rr5cQ4CN
X-Received: by 2002:a05:6000:24c5:b0:3e8:b4cb:c3a0 with SMTP id ffacd0b85a97d-3ecdf9afe4amr737103f8f.8.1758093391213;
        Wed, 17 Sep 2025 00:16:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE6KvkUbAw/hWHVpyZFeQHd7+eZojTjephumHug7ngWtVuZzWRraD7sIx3LIE+G0iYk+zOhBg==
X-Received: by 2002:a05:6000:24c5:b0:3e8:b4cb:c3a0 with SMTP id ffacd0b85a97d-3ecdf9afe4amr737058f8f.8.1758093390674;
        Wed, 17 Sep 2025 00:16:30 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f27:6d00:7b96:afc9:83d0:5bd? (p200300d82f276d007b96afc983d005bd.dip0.t-ipconnect.de. [2003:d8:2f27:6d00:7b96:afc9:83d0:5bd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46139122a8fsm23710285e9.7.2025.09.17.00.16.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 00:16:30 -0700 (PDT)
Message-ID: <2bd45749-e483-45ea-9c55-74c5ba15b012@redhat.com>
Date: Wed, 17 Sep 2025 09:16:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v3 09/16] genirq/irqdesc: Have nr_irqs as non-static
To: Eugen Hristev <eugen.hristev@linaro.org>,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, andersson@kernel.org,
 pmladek@suse.com, rdunlap@infradead.org, corbet@lwn.net, mhocko@suse.com
Cc: tudor.ambarus@linaro.org, mukesh.ojha@oss.qualcomm.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 jonechou@google.com, rostedt@goodmis.org, linux-doc@vger.kernel.org,
 devicetree@vger.kernel.org
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
 <20250912150855.2901211-10-eugen.hristev@linaro.org> <87cy7q9k8y.ffs@tglx>
 <87a52u9jyl.ffs@tglx> <8df2cf28-c15e-4692-a127-6a5c966a965e@linaro.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <8df2cf28-c15e-4692-a127-6a5c966a965e@linaro.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2P15Iwn-uPDoVHH1-35_06dVbVF7ncv_Ln_r_h9Z9BI_1758093391
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1519E140011
X-Stat-Signature: 9khtbyxz3qnnn4au8outipuhog1skt66
X-HE-Tag: 1758093394-560886
X-HE-Meta: U2FsdGVkX1+EYGtyBhFu2uaGgV3fzI31qU0UDkyEq7C4MG8HZEbbsTOKDBeRbmBy5pWiSSuAEUCeU/PJDad+t/vMOG5cgKTG7za9zjjsbIvxVs6P4blM0niM6bUm+2dInF2p1uToADe1fAs2jB44lC6CAigGsiz3Kt0X4EGDOfZ6zOLbEoAhKtuGcFVCw7jdab/T19tYVhIMwtaDryYIL2gO8GlyoXwzQS5QVzU45dQRBAVNg2+EfqLypsDfwoF1CeS3f1bupqeM2HzVofxmrzWBPFMro27LE/DDPFW81gvICLq3u4BrN181O921P9icIibPZCbDFHnHX9K2DZ7EAjKdSlnWAS6DRHYTF2DJkypvIkIGDGjuKyJOTUMa7lT4aiEasdXhOqCbUavcIeK7ByhJs9IC+mqJFqxbQf5eaP+cXmCjIzr0+lZ/ii/Aw5wjhoG6xqOHxo3kW7HVLpEHvXb7JAZpHibriUtNW10QSbDqNCMb1LRPmKJZiICVEamWXycrBo4H4J505hzgM5voOGrOg7//Vv1GyIuxcLWP7bqk1Rlv/bstjlI+bH/pxdSOdwBBrWeNE0tGk+HbeE1m3MaU1azcJNTKIVF1hkGUC9iVOPbDfUUuRWszVdIjZ2xU+4qb/bhKwrs0LoqWij7tns8OvDJisvqRloKbEoZz5pQ0xC+TcdjAY32kjq5993qUXsWpjTc6MTW/CmxFZ0EQCZ4UoTpy/VNGX43yr2I06rGA6qPMahNXjNuUbgpXAKMUZSGHKMoNWc5VbNSNRAt+k70OQ3XpweYuNb07gWIgbOlRWaCiQxgURGp5jQzdxiqM61ZhOPX5gLduuHklpWxbz/7rZQAbH49rZrEXc+Q7PwoEnJvB51rxhrjWPkljqUYVJDLHki9kz7tu3LWlnDN5P6H5ekynWA8wn5FMlFk8nRuo7LhiN8NhXix3oHqCQmXP+WilpF/eAAR/N3OoRUL
 v6FJZrRn
 iY1HMxGWmdptEEUXWd62c5LSIW8t+zJHxAl0yNDslone3ej9SXZN0ljRA92R6y6ecVQDqPwrYw2ZCi+aoPqGeKozn3SS41zsDB3Q9fCdzz0p6jvMwVf6biwXj+up13JGMXxtOFG4zTuaP6Fx52eo15EF6zTfmI17PS37O2oeP6q68cJKB5LaXjCd1CqL/6KxGnPbmcUj6A4mKu6mhaCY/EGTqzSvpdT12Up301F9z6Q+UDtxFxAXLXORutegVXi2EP4DvGjsS7v3U2G6+yzJMHRcAQR4dC8WxivZfmH5HmB73LJbMORw/yzPKch//Q8kJrDg3xsIswaEqorWxv2uGloURVsO4HdVGHoT9LENJ2yGUFAx7eZc8jHWvOWKNkpXdjjGGTOPq8tF30j5TptMjsYkGUB2taE4iFCpjPOtsLJvXZxCnVnn5m2tMuYjqCJBKe4j9XR9Pxq5z3B/vWvtG+eHczkQwPT93OO0A
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17.09.25 07:43, Eugen Hristev wrote:
> 
> 
> On 9/17/25 00:16, Thomas Gleixner wrote:
>> On Tue, Sep 16 2025 at 23:10, Thomas Gleixner wrote:
>>> On Fri, Sep 12 2025 at 18:08, Eugen Hristev wrote:
>>>> nr_irqs is required for debugging the kernel, and needs to be
>>>> accessible for kmemdump into vmcoreinfo.
>>>
>>> That's a patently bad idea.
>>>
>>> Care to grep how many instances of 'nr_irqs' variables are in the
>>> kernel?
>>>
>>> That name is way too generic to be made global.
>>
>> Aside of that there is _ZERO_ justification to expose variables globaly,
>> which have been made file local with a lot of effort in the past.
>>
>> I pointed you to a solution for that and just because David does not
>> like it means that it's acceptable to fiddle in subsystems and expose
>> their carefully localized variables.

It would have been great if we could have had that discussion in the 
previous thread.

I didn't like what I saw in v2. In particular, having subsystems fiddle 
with kmemdump specifics.

I prefer if we can find a way to not have subsystems to that.

>>
> 
> I agree. I explained the solution to David. He wanted to un-static
> everything. I disagreed.

Some other subsystem wants to have access to this information. I agree 
that exposing these variables as r/w globally is not ideal.

I raised the alternative of exposing areas or other information through 
simple helper functions that kmemdump can just use to compose whatever 
it needs to compose.

Do we really need that .section thingy?

-- 
Cheers

David / dhildenb


