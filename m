Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D89F8CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 14:57:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FC6B8E0012; Thu,  6 Nov 2025 09:57:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D4348E0002; Thu,  6 Nov 2025 09:57:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 310D58E0012; Thu,  6 Nov 2025 09:57:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 23D358E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 09:57:08 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E19C0160145
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:57:07 +0000 (UTC)
X-FDA: 84080484894.25.C6454A1
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf16.hostedemail.com (Postfix) with ESMTP id BF928180010
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:57:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=esZB6Rlo;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762441025;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DaFzM+6TkUYBD9DDhYKswYgd7YEqnag9emUi5wWYwKQ=;
	b=6dzPeKrLp57qEe1qJ7zKxbU/oTwdeFQIgjXXKoFfRcwy/8q5PLhJZGzzKSd+DQcNbSVgkX
	ZKngZK1aqrfMw4ATohwGdDODQaSw0XKqtXO3E5VzYCpMu8p+V+o0p6Tcf/76uyojuZfBvY
	v1zBrqHS6gVqgPj0bUFI4iCJA8/8ZSQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762441025; a=rsa-sha256;
	cv=none;
	b=PRx5YIVcMx7C8X2n/b47IhkW5R5NFp4Ig3fb00nXoSPPVUTwklCxTrtD5n+U5exlGnm9qc
	WrMQP3dvi5yzaVHdJBtan+2vQfMPyUx6Qa93GvsCcX1telb6es8+AtDBDMRXJ8zOseppMS
	I7P4qpd2+UiWVgi0ekHiEHNuJfUoK38=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=esZB6Rlo;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-640e9a53ff6so1988832a12.0
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 06:57:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762441024; x=1763045824; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DaFzM+6TkUYBD9DDhYKswYgd7YEqnag9emUi5wWYwKQ=;
        b=esZB6Rlo5MPfMzrFhTdwc8XirUg4AtZOsGKjabT51xe4h/PTYpa+VPa/sAOanTIdCI
         wg5i1w8OghRv7Fmg/vf1sVswYKqFYM7y1/FuUq+bGGVvrtIgOFcfsUFoz5o+qNmu5nn8
         /yYY5UiW0Lv4va5dmEAsszNozmVsDwWJ4gJVvoZwwP6gS5UCds7FY+VZqbtpRSjtGl9D
         MyneoyU9gzyNo8tRTmzOMblc2xHqJffCoZxCAROf0rubQ/JzR7gqR525PQMGqmV1qHVv
         AnHbbDDf74bk65f0GfTB8xlYHXn0KtjislLu2UeQqPkT6PChpobm0ijiNp4cvVT056bQ
         SjqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762441024; x=1763045824;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DaFzM+6TkUYBD9DDhYKswYgd7YEqnag9emUi5wWYwKQ=;
        b=w1bZvfA1gs42SLDiGP9qU7gkPzcVNLpnkKPhf/C7P5gs/3N6pQYz9Y4vVBkZNpyR4e
         mVkUStwSGip08XW52s7lBi1wdP2AoTfiPzzm2itII5KWeLXlww7hsTfmWduabVsT9U17
         hx8li7BT+Z1XLCGcA+7ms0FSFwAYM1sfYfonet2Kdp7R7B0/kjxGLQTVGczy37HTcVMh
         mY1v3GcodL19reihOD+MC0rqVwqq6D0gnUI9rQFA6hryrxJdkUIrIL57581t64jA90Qd
         ElEv47Q6/DEpv/Z9fvv6hBjH1kfXCE/Y+Lhb/yh93vgLvYjm08qfz36m6Cqp46OOmTXD
         5WMg==
X-Forwarded-Encrypted: i=1; AJvYcCVGggvMbWUzHHSLn+ly7BxozEOer+bDpGkiEmUGPVfhHGea2qL/dwGxhLy9U6Tf6Vd4rmRZNYx9nA==@kvack.org
X-Gm-Message-State: AOJu0Yyy/GtjuTcCwMBVHSsjQZZD/aL1CGoYoO9NxGJP6eRuskoDOubT
	M1/UUDqpQpCj3eNL13QUtkHzsFxIAnkH5FWiaAY0If1pI7HsY2qlnYRE
X-Gm-Gg: ASbGncucQoL0IIo2OPd0+DOeyZLI4PhRsmn/OyxkBf9LNUQyzrDiOvJhioP1qrqZ48K
	tUH3fxLz5Bz3aIlK7LKQvnVCnMPZbQySnhvj9IP/F58bnubqeu30PEuEZVSjl35aGOsyV49oHQ1
	eBadHRRHGYGUQYYjaUcPJBboAvg6jMxkAQ29wAUaWDs7j0kMW6ZLMudmEBiMBE5qASM38XbB+Ix
	8hUQ94zZ3EgKwN0/fd5wbZqR+SxFASfYJVvFnUPGvJOpf/bJvDJltNWRFyG/2Csl4StAeaeAIOs
	mEFTVoQ24GfmX0jMU+ZAZtoVKe/d0nvAn8hBapCYXhJWFS/K7ocSAfE8zZsbyiWuofVdVzPY9PF
	dqWYSkJcBDHJwsRwr9wcFfNyTXpFPd5OXT+JjKH4YXfMgBSaU++MjOm5JSTrSTFiZQPTH/kvT/S
	sxQ8n+AHssDw==
X-Google-Smtp-Source: AGHT+IGmZykIZPTuvRMPNOiMCw+8zE0WyAATNm2cJzj4VHhIcsOfGQMgovFIvK6hCbAwZzfyDdNyEg==
X-Received: by 2002:a05:6402:4304:b0:641:3189:a196 with SMTP id 4fb4d7f45d1cf-6413198eccemr1230175a12.23.1762441024249;
        Thu, 06 Nov 2025 06:57:04 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6411f6780b7sm2085016a12.0.2025.11.06.06.57.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Nov 2025 06:57:03 -0800 (PST)
Date: Thu, 6 Nov 2025 14:57:03 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v3 1/2] mm/huge_memory: introduce enum split_type for
 clarity
Message-ID: <20251106145703.7eotqtdxcilghju7@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251106034155.21398-1-richard.weiyang@gmail.com>
 <20251106034155.21398-2-richard.weiyang@gmail.com>
 <c2d8380b-6452-4b12-9d51-2741f86180b5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2d8380b-6452-4b12-9d51-2741f86180b5@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: qodmoistu34mdbnd6s8in7cju4dj81gq
X-Rspam-User: 
X-Rspamd-Queue-Id: BF928180010
X-Rspamd-Server: rspam01
X-HE-Tag: 1762441025-502181
X-HE-Meta: U2FsdGVkX198ldoHbAaJQ9RMg9jk3OagFi99k4da2nmwMwQOgKBqzrGXro1s6H3loqzAGdekUIDTqZ4OHU5eM1oaCOGsfVfMsq7+CZjLv6lB5uJxMVDtfWBEBfm95GZz17LpTsGKAnNkg/zKsPmP9MI1nwfRnJudLy15yKjwIQBf87yXOn2d8UxGzipXo5Hw5mQepWRxgaKrLKMvwgRNxpVCyA7Gb2c1fMDW98HD2WsntGhtlgMyzpmMzq1DxNW7juzMqZC8Y5oantj7l9XIHaQiCAZWJgcQ7CuwrpRLElPbQj6FB2nUznY00HMeNserIJTaHc/q+pi1UBaPwn5kgI70fI1dhKyEXwiD8inyKZ5uCrtO7j9zqiEZxw2pV56QwqFEr5GwhuuyFrlJSDSrB8sraaor7A2QpCGqF7QW8P+OkYkBr2PFOnT7tLrBuvoPODzRqO/pw1cbOAssgZ2m8S5TsSvnWvEoldgoM0XscuxG3eolvHJmW/+5rKMCdmQ5ZQsUsTg4LRvVwr+DfduloyV6mU6/qyVXkcLus2KVrcEU6A/Frn63I6MmhCZniBiSP1w+92Nb5IXKyQbq2euWyGhjsR2DNYIL27DLH469CbfxHRq/WYGwq/IHCtYJ0iN6FER/+JrQqlJsjXxUiix7tv9zVQy4o8B9F9eKByki7jKBdXnJgOZuA8xt0Qtl+oA2oDY+e7T0/cdfK5h4VJbj23pg6c5bgJgZU4+b+apIDMYWnhTgbUkL5ki2gUeDJT7306p8LDsth/7k7hYFX8S2VSWfWZ8ZsxbJkOBSJs5qrPXQGcn3ttCI2OkEvL9i4sHkLuvLy9HYkhCLGga+YiUyKz8Zi4rV/YiZIbcwp7qwCL9uPWQMYYYGLprX119uKpmQFEgdpffjzkABe2PvWSzrfaXHjPMOcchnBDxCuao7r4OVb7/liKhyr32fh4Qll+XI/MNXClBaJUoZYiXEykF
 YKSSLDXD
 ImDIkyQzWe/2wU1SmdPB8oV/BkPXHGTuhLlSzMkVcjHj/fA6qQkMsjTglpECHYkl6L9mbMGsAhLNljZAfSJeCK+oAzKqf8A6fZJ82hTWq6RnC1Vf7xCD4/l7lbfvutCZ1mQnufr2La03rDxnDSdJU+srzws5z9yq4C4NHxFiR4VsNq8sn39rwN9E31fw8rIcFN7/kN4UTHqeuVr2ZcOmTJvCSSWYV0Ne480/UKHUvDvWQt1RDRqlVxjLTdCRkMC0YrhMRvU0c8BG85M90YZHJrN8OaC0F/7jcfAaAe98fUR5tBk1Fe8bDEl2u63cPSC8jGB0YD8bGpoFqms9sC4L7RVtP+pXNc2rvGJ66zHGpWzds2Al33MdlLRwpIJbGliOzwy/vsn95WcWiYdNV8YgPYwJXzBfunga7tRvpWvS+F20lcg1NzUg2DtHZA+NmMrJ3VHMNKAowpYIvTzLOP/kebDR0r0rCUi/9rLkxNyQXhlC6KRjBCgRZurMteYZp5yIeLtvTrbQ6ycRj/ZmsL21OU6Mf8zTl753Amc27aiNPWVmKPhl31uBSQdu4XyyTxbNsOYDou7WCymS0iDXyTa2KoDt0Mtt+2WywPhUSMnkEgCimRTPEMESbwcAlPVJfQgnp678vmT+qiqgC5dGwB33GihYJvDYGRqYNbNmZ52duk6fpCXl086kPssX3vO/ITH8El4j2dXr/QHFQNR+AvFmjdUWrlS6VZysEFgUu4GoC/KZIMCNi6fix8IDt7BM9W7R5xcdixXedTbwNtUGUZYGKTvd2KaJp2gXJ8do690e7q6508xVEqOtrI0RJjZYxafYhC5sL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 11:17:00AM +0100, David Hildenbrand (Red Hat) wrote:
>On 06.11.25 04:41, Wei Yang wrote:
>> We currently handle two distinct types of large folio splitting:
>>    * uniform split
>>    * non-uniform split
>> 
>> Differentiating between these types using a simple boolean variable is
>> not obvious and can harm code readability.
>> 
>> This commit introduces enum split_type to explicitly define these two
>> types. Replacing the existing boolean variable with this enumeration
>> significantly improves code clarity and expressiveness when dealing with
>> folio splitting logic.
>> 
>> No functional change is expected.
>> 
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>> ---
>
>...
>
>>   		 * Unfreeze after-split folios and put them back to the right
>> @@ -4149,8 +4149,8 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
>>   {
>>   	struct folio *folio = page_folio(page);
>> -	return __folio_split(folio, new_order, &folio->page, page, list, true,
>> -				unmapped);
>> +	return __folio_split(folio, new_order, &folio->page, page, list,
>> +				SPLIT_TYPE_UNIFORM, unmapped);
>>   }
>>   /**
>> @@ -4181,7 +4181,7 @@ int folio_split(struct folio *folio, unsigned int new_order,
>>   		struct page *split_at, struct list_head *list)
>>   {
>>   	return __folio_split(folio, new_order, split_at, &folio->page, list,
>> -			false, false);
>> +				SPLIT_TYPE_NON_UNIFORM, false);
>
>Looks like both these are not properly aligned.
>
>Should be
>
>return __folio_split(folio, new_order, split_at, &folio->page, list,
>		     SPLIT_TYPE_NON_UNIFORM, false);
>

Thanks.

@Andrew

Would you mind helping adjust this :-)

>
>Thanks!
>
>Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
>
>-- 
>Cheers
>
>David

-- 
Wei Yang
Help you, Help me

