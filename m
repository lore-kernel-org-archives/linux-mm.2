Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC715C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 21:05:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AE446B0099; Tue,  5 Aug 2025 17:05:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 485DE6B009A; Tue,  5 Aug 2025 17:05:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39B926B009C; Tue,  5 Aug 2025 17:05:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A1ED6B0099
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 17:05:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9A5AA56163
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 21:05:57 +0000 (UTC)
X-FDA: 83743935954.14.6AF1439
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 14A7E1A0006
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 21:05:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eTn6mdnm;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754427955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kqRftw6bnCaiUsG4UzgVQFaWyDy/FQcqP1mg9FWcAs8=;
	b=u85OnqUYrFkPoti0TD1YLzvkxRRPIgrse5UUg7ekPJZrmJnkbLr5IYhCWmiJCIp4msxe9a
	9ddQ2CH/uctD/TJrnaW6h1vLGxMJEFVnygIveB7ChH8CpdG3YJBlY7YVFIyG3ntQR55Btc
	AA8JibfwPm4jwNd+3+V+xXs7+ktoEX8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754427955; a=rsa-sha256;
	cv=none;
	b=BZHnpPKTfNlulp5kuwEFaLpn+ie65sWZeKawwatEk3M4hBQj6K/9aYQhTBG3U1iJjXePYm
	SDI4AsGTjGX2V4wQ34psXglRHog4pYkvdmqqkweg46evSeWv32VURT3IsnOLJbmmb6pv1R
	ytTsrhQNyDweG+PtU2+S93L93ylDpcw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eTn6mdnm;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754427954;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kqRftw6bnCaiUsG4UzgVQFaWyDy/FQcqP1mg9FWcAs8=;
	b=eTn6mdnmQZX7geTCdKAUh91bnQNbJTNLUPCCBjI7OcCB7qxqIlDGm1QjHKFKsVVGbS90dz
	lzq2LmFkWYDnBXsJ5D1NH8+e5u7a4dVYQVAVpWFp1FIJ84x/W0I0BYkKqIIjLRYaULIFFi
	VBkH2PoaIaL8l7ftJJf3vOPI3SP3hCE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-JgL14pmrMlqvaSfZZpNO2A-1; Tue, 05 Aug 2025 17:05:53 -0400
X-MC-Unique: JgL14pmrMlqvaSfZZpNO2A-1
X-Mimecast-MFC-AGG-ID: JgL14pmrMlqvaSfZZpNO2A_1754427952
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-459e068b5f4so10022435e9.3
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 14:05:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754427952; x=1755032752;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kqRftw6bnCaiUsG4UzgVQFaWyDy/FQcqP1mg9FWcAs8=;
        b=WxEub1PmUnJIZ3n2BoQzSe6BJUXcnvPYVfS0niZ7+Z7M0iP2PPVpWIFsdm1geTWNOS
         fvB2nAZJZU809mvlVeojGfsd9tIp8n3+iV/17F5bG31RosLvTikasnSRJl6839uBseSu
         wO1olcSxnSzgHl5STBAAiTQjB/JkejgAU3OaU2d4eov+nhlHzYynvKJebcN3gPdhXFdC
         7ZQX+yh3gStBiGzVBY2X4JGv3nXQ+AsrulhtVprxLTIRpECm8thXjkRXcwUa0Yo4mK4O
         SNyVDLeUtDxe2R1Scv9oVV5tP7rEqa6XCfpkwdyr0IiTnyaQch8TBTExQ0wxcpobhFL9
         21tw==
X-Forwarded-Encrypted: i=1; AJvYcCW2OC2oDNkj8g30wQgjL6bQkghM9CHGP2t3+f1wB10uOdt8tkjDmE+ue8s/u7UaQfhU7ADqj9Qf7Q==@kvack.org
X-Gm-Message-State: AOJu0YwpSr7hJCec47ZgJIBkJ6ZjiKGFkIGKKzrYX1xAgvXApglAwuAR
	uuQWewCT7Qv9kK+lfCmyp100RqDjKnz9qzxPj2Ynmxt3lt1tya1AgT+XU3PZ938vzJQMeZbAFta
	oVqiEaxe3ONwqydDp+wGRBRLA/OZhNzemvetDS162NGQj3k7bca1U
X-Gm-Gg: ASbGncuA6N9mcQan7gfB6ItsXB5gW+B86aUDitQ8BtWn1AV8BzHve1b9aOtTi9AXyao
	mepcBLcVc4JbFwMvo8hPA7RG00jfm+yFtYtrV96IXErhAjgAujcEaM1hDe8KMNP/yz5ggiMVnf4
	ptQvfoC0TZprBE40SKRpQ3Wkk8BE/Ep70cRJd/kwssuPo/J2zEAA1sq6RfYuzkW0OUi6/dzOn7c
	8+MyyEy1FZWc9UNuYZkG5q+RIJw2nLOHHfz7e3eBhpNaU/9cdnO3GLKlWzMnIn9YK0rmq/PQmwy
	tyiWX+lJlQJjsOHX4kHwmvLs+Jt21h0odJyvrnAbOdCrYQmH7trQPqMdBgTlapjEaUWVtjJkS7+
	iynuBObcyZqMypAg8i5UQs579oRwohyxoBCCsFJ4eDzZ2BamiXSVy+TPLYqnhM4YBlrQ=
X-Received: by 2002:a05:600c:1546:b0:459:e165:2661 with SMTP id 5b1f17b1804b1-459e746f7aemr793635e9.23.1754427951903;
        Tue, 05 Aug 2025 14:05:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF5ovmpQA6VuHrG0lBxw9kWz1GZEQp6ylYtVCMl9eYwZWu5JTPAOqCzL2hWks9vBLR4tNTzEA==
X-Received: by 2002:a05:600c:1546:b0:459:e165:2661 with SMTP id 5b1f17b1804b1-459e746f7aemr793515e9.23.1754427951433;
        Tue, 05 Aug 2025 14:05:51 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4b:5100:3004:3864:4049:722e? (p200300d82f4b5100300438644049722e.dip0.t-ipconnect.de. [2003:d8:2f4b:5100:3004:3864:4049:722e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c469093sm20686698f8f.51.2025.08.05.14.05.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 14:05:50 -0700 (PDT)
Message-ID: <9cfb5b1b-f565-4129-a3e3-fd16a38997da@redhat.com>
Date: Tue, 5 Aug 2025 23:05:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: fix FORCE_READ to read input value
 correctly.
To: Zi Yan <ziy@nvidia.com>, wang lian <lianux.mm@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Wei Yang <richard.weiyang@gmail.com>, Christian Brauner
 <brauner@kernel.org>, Jann Horn <jannh@google.com>,
 Kairui Song <ryncsn@gmail.com>, Liam Howlett <liam.howlett@oracle.com>,
 Mark Brown <broonie@kernel.org>, SeongJae Park <sj@kernel.org>,
 Shuah Khan <shuah@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20250805175140.241656-1-ziy@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250805175140.241656-1-ziy@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: w0bkgO6uv7V5RxaX0FUk8zS7ZtxzG3X0KWmlV790Wp8_1754427952
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 14A7E1A0006
X-Stat-Signature: xkou5feudqegybfpyfx8bb4rqujrfekn
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754427954-405893
X-HE-Meta: U2FsdGVkX1/89AAE7TYI+5qeeKQlg8lX8AKnuPJjuX4//R1X4HG+51Ytqq6RTXMi2dM+/f7xQ7v+yvKvap1ppFamIFfKz8I6gUEUO1PrlekkDgFUqBsSrhi/aABsS1ez3mZqCatdwCQ23pLTGtFEvjppdoKjyB0U6ICaJRrmX3RuKTgJETVEexLHpTY+AFvvS9C8vP0+gkfRBm/RF9HqRlUyEto6T6oUcQuhRQTN/3cz53dAV4zz8CMA2zo4yij8WH4bzQ2LEUZ09sC6oOsTCov6lCQz6NM5fouPHOKNjfgu1giijBoUjS8wsYzTEXxK80Dar+IozPRRkBUwjvW/iRxbIBjVrQW5HnY6fnnJJ/I3MgmFvbQD+Oy6mRmRczaHQNTECN3LYk/1zVmKL4I7Br6r8U5RJBeXeiVEPR/3jLnTqRxY0+wfsxr4IoRRrB0xBjQfTu0R4D4LKOzbQk3fsNQM5PWCA989UnhuXyTMdb0lZNnpeO0npf9fo1tYDW2geAcTCAY0YUUJmLOkhAaPeLiTOUM8+7cNm5PTgSg1dItzOYPAEnxQV/Kxkxa73ELAQaYxRaXeHAyQHui2zOUn2b4jeyhfFd8viKoNsSmBxZoLLlckxYj6eAc6QNUV0eSm1q7JK6igbXG8HRpW6K31AJ1X6ZuSCwD/8L1XGku2jAfY7+h905MtymvgR/PjlHMdXZzXhs6W1G5reILmzLIPRHNT1JNrOaiAKL+/Vj1BE7HVTS7e7Xmj0D1yQrlKXBvbc4A8ceZgnkSV58IRxCH5mh1mNWQ1EtvZeMxVYhw743oDozkoKOKzNZI+WUuu5FnEf+8fO5I+iGxMMp4EfSSTYt8Tn78GkX14ytsk587+WmNuBErZ9wEN/4IR3tuTGCVWKlRJwIWIG22B0UUL8ceTHeaOM4vb5TNu9V7MHfOsD/Kpdl4UK6VBT6GYDtrmbdRZbitQyk9yhPwswxS2hJW
 lgQTxkHd
 yl2fcC1uRT5iUsIdKffR6/Tn7MM+xyq4xjBsrX44QP9WUfBqYS3inSb2dwmv1gJU5oDP986S+yv1owP8vTi6WugCk6OpW+oJsdKzr+8ExE2/txKslwLAU9qTZyx93ViaCvoAja98E90XRRQTd5Mq3hp8JuWMQA0BaGDoYi+tUnJpUPUcGLG2z70lokLYT3jzlxsWaFHhGwOSbVH1CAsDJof7qfp/jM+VH8ddbLWMr2/Bw3wqgtASF8A9K20NmXchCuk36env771Hs3I2m4h6fkpfZOfprwrCxhdbe3Xn2WteRECC34yZLHFzHfzUu+mutLpEVTzkHjxY/QGvIA/tyoIIbRz9UGQxX0atxa880+nkJA44zjvxkLRvopAWOlBTX4+NMBWHnOopJBpefzH9t47zMl+f0Qw6JddHpQyk+khagOxGHYF5xuR9U6e4vtjnDCL7pi3mPcjOw/OHtksQadB24pB3NIs9Xmu6T1uDYPeMnT4akF6SAvq8B7wHhIFSsur+p0uA8NQZDgKFDtjRku6VCFJ0d6Wmq4t4S1QGCna3ha6JmWyoR1MtZsmLJWrsUQx9aV7w7wShaxOqIg6j4/yR4Ixk5IKgRRL/yhzdsP6xKPLrcLW7b7H58sQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.08.25 19:51, Zi Yan wrote:
> FORCE_READ() converts input value x to its pointer type then reads from
> address x. This is wrong. If x is a non-pointer, it would be caught it
> easily. But all FORCE_READ() callers are trying to read from a pointer and
> FORCE_READ() basically reads a pointer to a pointer instead of the original
> typed pointer. Almost no access violation was found, except the one from
> split_huge_page_test.
> 
> Fix it by implementing a simplified READ_ONCE() instead.
> 
> Fixes: 3f6bfd4789a0 ("selftests/mm: reuse FORCE_READ to replace "asm volatile("" : "+r" (XXX));"")
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Ouch, thank!

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


