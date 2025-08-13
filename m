Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A380C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 16:24:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF4B49000AC; Wed, 13 Aug 2025 12:24:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA583900088; Wed, 13 Aug 2025 12:24:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D94609000AC; Wed, 13 Aug 2025 12:24:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C6F69900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 12:24:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9A83382DCD
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 16:24:19 +0000 (UTC)
X-FDA: 83772256638.07.FC5EFD7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 41CFE160012
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 16:24:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IrzK2YPV;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755102257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lSm78Xf6MmSQdPwF52t8+Op26dEorL18vOLPK46y1KM=;
	b=ZrB2ziInOaXxwT74m/ZF7D5PCIdpQOYv2JT4KG49NeEjgLfJJ8I7FtrVyvYNS4phRf8XwZ
	B3WLtwy+xg/DhxHKUQ61wkQFILpKDimlsy3makuSQi6ZKy7jOCa36Ps5FWWvvC9uw2pMCu
	VfjlZvXyj5NefPOVJeLzFyxYUvP2Tj8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IrzK2YPV;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755102257; a=rsa-sha256;
	cv=none;
	b=h/LLswTHhIYLQUOYXKUHluISNQhTlHG6dhOu+eNffcy9degmuKWLxL/lQqVetICYlEoksr
	OYx/9JY5GvYcxlL2Lanc4BX1dQHz+YLjMcBFCNmMK2AtKQMpkxtx4npffWdbPu4z9g2ok/
	0XS6eVf9NnWT8DM1mdDOg2rrXPnp1pY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755102256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lSm78Xf6MmSQdPwF52t8+Op26dEorL18vOLPK46y1KM=;
	b=IrzK2YPVMX/9JJad8+rzvPIh86NZlnaxRzKkZSvgwK/XF7pFuCejicIT1o0zL2sVnPZUx8
	rCcMGfc5crzEIkAjmRaZVyXrrhmbFi5WEsQm+rANwGiuhXbFdKtVu7niEmARFkSBuZs85F
	Virv9UJkK3OxhnGI+P2krBuyx+/peu4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-462-fh2rGr3JOZWxoKhF1S29sg-1; Wed, 13 Aug 2025 12:24:15 -0400
X-MC-Unique: fh2rGr3JOZWxoKhF1S29sg-1
X-Mimecast-MFC-AGG-ID: fh2rGr3JOZWxoKhF1S29sg_1755102254
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-459d5f50a07so37513475e9.3
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:24:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755102253; x=1755707053;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lSm78Xf6MmSQdPwF52t8+Op26dEorL18vOLPK46y1KM=;
        b=NmLtNvKiEqSmDozbicO+fdXQLSoi7hiCCDzSaVyUuJanJu5oyN9mzzFfLQ3AkunpyQ
         x6RMbqpiwsmwbGhQSG1ip4Jr/pU+cBSSUH5YbYtHJVN+u0tlPi32YMJzeE1Y68s+Dw8D
         D4lJ4DxNFur9r4pB7rLYuiG357n45h5CwdsO3vDl3scKjpecx9SPuvN0yl/a3VE3Mr1k
         gWTL+MWXHcIRPQIuTCJtdC/naQjSWqj4mN5c3xnATr+n46te2vxZxN7BNgGMvxH4/WwD
         eXYN6XzmU1VJDohPmZPlULASgVAtx3K9XyfpApT7rVtGtxgYDyEKpdTBSFk94sz7jVke
         T9fA==
X-Forwarded-Encrypted: i=1; AJvYcCXGrfzgGrMxGKIMz9EUtZPutOzhA++fC9BJgL0h7hYsWn502sTD0A+BTl+o59FaWBJ38wP96bmmAQ==@kvack.org
X-Gm-Message-State: AOJu0Yx5LyHUHKGH78lYG2TKOhe6XHQMiCY2qTQdrr9J5rasOLBZmrk/
	snvWp3jqWUn7M1cwtRvYYHhWF4JV3l7I+wDw9MVX041VwOVu9icwdLpcrdh5mqnCxJL+qzRYz4u
	MKzCw0GREtfycrJ5CrMDR/IbGqG2yvkgiAyg7WHKG3vU08U1zcXZB
X-Gm-Gg: ASbGncvZY24SSjtsXgtgaet0jlmoyaZYF41eSEG1DcsrHXW+AoPgUyJNxZxoIwFAbs5
	R2OkJxD82Fw61cWQE8KTyY+IBYWOfNjTTS3NdGu6FiYdxbgg79vl0iIzyilTdzNVf3KH9L7OmsM
	sJ/tmH6vmzd/huyHuu1ghuqaoGEFWhan2Z21DICURJntTXE9Ddl0zuCQUmNHNivOdO4UyYm3YmS
	sGv4nyHeZNVwC+kbqxlgbMuANMY6OuTV+ndYSLILvFDNasYFV6bngy0ssLT+DMLMsoFGQdJnK2g
	3JUsI0xxazpF3EqNh+m430zokllrn1t0dkZwMOavW2+R6afp24VBq6n4jZjoZiCMokgeAhLHb/S
	GhlTmIMa2XfQQTjhDyBf/+yWcWLyJ86b7rx5ZyU6xNW6i3LllcYLoGlDx+nCAN4Tcr1w=
X-Received: by 2002:a05:600c:4f12:b0:456:fc1:c286 with SMTP id 5b1f17b1804b1-45a17949c46mr19492105e9.1.1755102253638;
        Wed, 13 Aug 2025 09:24:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE6F2DbaZck9nZoZlO5xU8PFCcMfBHNTCqmXxFrqYn1Ok+rrYGt2my+hYZCl6e7nfy5+/NLhg==
X-Received: by 2002:a05:600c:4f12:b0:456:fc1:c286 with SMTP id 5b1f17b1804b1-45a17949c46mr19491915e9.1.1755102253258;
        Wed, 13 Aug 2025 09:24:13 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f11:2400:5d0a:b6ec:2ac0:666f? (p200300d82f1124005d0ab6ec2ac0666f.dip0.t-ipconnect.de. [2003:d8:2f11:2400:5d0a:b6ec:2ac0:666f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1a5212b2sm8133575e9.16.2025.08.13.09.24.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Aug 2025 09:24:12 -0700 (PDT)
Message-ID: <bac33bcc-8a01-445d-bc42-29dabbdd1d3f@redhat.com>
Date: Wed, 13 Aug 2025 18:24:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 7/7] selftests: prctl: introduce tests for disabling
 THPs except for madvise
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Usama Arif <usamaarif642@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 vbabka@suse.cz, jannh@google.com, Arnd Bergmann <arnd@arndb.de>,
 sj@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kernel-team@meta.com
References: <20250813135642.1986480-1-usamaarif642@gmail.com>
 <20250813135642.1986480-8-usamaarif642@gmail.com>
 <13220ee2-d767-4133-9ef8-780fa165bbeb@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <13220ee2-d767-4133-9ef8-780fa165bbeb@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: A6YCpiApNlzgagOjYcJAKNlMZ5NtH6bz_BjSQXmmDww_1755102254
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 41CFE160012
X-Stat-Signature: csm8g9rf3x4ggfibjfu6s7n4fagqzuro
X-Rspam-User: 
X-HE-Tag: 1755102257-782000
X-HE-Meta: U2FsdGVkX1/Rax5wS8ZASeNFKnWlEwfLjnQ7Xk781h9VkzwtAciU8hCs746+iH8TR/7hESDHPs+xgSLRG0Jh90lGOIRVZdDa7dV6T8Wxl3z2RTBL0i4mH0uOaKiL4mSVlhuFgLcb3hOogKE0QpdYHSgLIJ8FD5vg09HSxhb9yPQkqFGu0C3sx9vbJqdzquZ2oF6XJuNl6/lDQ2KMmjwacMrxYkL+ekGGCTsC0iOMPqrzCDTIeh/jVD1d5kEifMFHTp8g03vAs0/DYCyeC0rDfQMLOTRFCsWbb9heKjGe7rKkog+JO5EooYdxnAIeqncvBm9QAHpVg5KrD5CuMaaXnyLhGQtli/XxzWan2yrtPZDY2sYfYPT6FmMP+/e1SzzCNYT0PaVMlzQ+sbkYno/IpXzust7Kdo0mJ0khD5FJC1fHoUywfW/IU2qI9bpZUi2dYw2Jnj0zsnWzxPqxjFImutKbMR80hzJC5ioskUNqHP9ZcXwJnodxPOPJ8z4sFsAlo/ufO+5T+vpN9DUhfsYRyRHQ8y/K2LYae1f+BPmn+Wv/dEhyFbbyrRVu/LsExFEPQ6HdCR9mte+eo6sdAzBxQqojN4gRQMrydNli5gyKctt7x6ZIU4PDOKNeENZPLvaGw511qAMrLZWK//+XpWogDl/AG1gFqWM6tFQPOjMJK1sj7hdwbtOkImTxloyQEEncD+FZ8Rl8st+KOLBF04c/VUvmtOsd1B8KBJPTrYKPJJDWkUveNuC/85yCJ5kBJw4OdL7MUEDRxEHcefBPiuuW+CtshF+MFQyeLXqzfrigLwvRfNtza57as9K8vw//SbR5O5SwJAMvlSmUXqMFnqe2pJlZeMPOUMZdNW0VD2dYsL2a1OiPCKFmw0N3PHtcXmkSJev1wQWYasJKMLNjvbLh5gaAvxKfMH3djrHHBNl1UwFwcUZasNic3kTfrGFUIJ2cFR44zFxjKmyTb7HQYOn
 O/bmKbih
 P8P/kbjG9IloStFaCA/HXBc62lVb+uHZNDvyVUDTKXjfSxFgM74SI0ui6FZy0QI2Xmemp+J+zfrBXVD8UaqYXwiZclpVtHdJ56ndeTTrjx5trfjCzeKlvkYXx7sSNhHlQmcNo1N4CEUqE77WELinfieoBcD6kT86tRVhyUsjZZWRW8A5Q7crNVza8XWAVrqMisiWeDae2NWvZ1Ke3C8OE9XlfCx2G3AVMj0nU+aiVjnGsFPgNGR1WaJuhmWpOIlsoX+Tdzi4/1g/aK8FQP5Ckk0BupWLReeoe8fX9LfrPCTus71dN0UdxzJV223JpWTFegS6++2PP9U3RO7yRVIlZCBW4+AsS67L8pKk8CytZ+6VkoOu9QczJwNkRrGTDO10mscYG/CJ0ykCwa3D1r/NKiDnipq2OIVD2sqRgYCxbnHvHbwpNUGFFuVwaJwI0fsc0LrevUw1TRB21RASIo18GnbtXOjTnFCz8DoNZGpmWTJ772cIYmDX8wm/SJCptScIvAOlZ2p8zST80Wtkmhc1YrV1flaC9npnzTcNWZvAiKsgwVhz52/SM9ij03kMSUMp0WWiMb5nFV0q+r0sD7r6er1emS1BmTlUngkCokAQr1A3JnMojK2sbhfHYOA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> +
>> +FIXTURE_SETUP(prctl_thp_disable_except_madvise)
>> +{
>> +	if (!thp_available())
>> +		SKIP(return, "Transparent Hugepages not available\n");
>> +
>> +	self->pmdsize = read_pmd_pagesize();
>> +	if (!self->pmdsize)
>> +		SKIP(return, "Unable to read PMD size\n");
>> +
>> +	if (prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED, NULL, NULL))
>> +		SKIP(return, "Unable to set PR_THP_DISABLE_EXCEPT_ADVISED\n");
> 
> This should be a test fail I think, as the only ways this could fail are
> invalid flags, or failure to obtain an mmap write lock.

Running a kernel that does not support it?

We could check the errno to distinguish I guess.

-- 
Cheers,

David / dhildenb


