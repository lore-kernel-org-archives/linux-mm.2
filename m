Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16F13CA0EC4
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 15:51:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F0968E0078; Mon, 11 Aug 2025 11:51:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C7D18E0060; Mon, 11 Aug 2025 11:51:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B6108E0078; Mon, 11 Aug 2025 11:51:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 77C4D8E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:51:19 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 513B81DB6EA
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 15:51:19 +0000 (UTC)
X-FDA: 83764915878.13.BBBA50A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id A39A720004
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 15:51:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BisNoc+1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754927476; a=rsa-sha256;
	cv=none;
	b=FmPXfqsTv7QLmFwe2QuTxpbggKJZQcQ/SSKbT9J9SlwcpCq1D+CJH+qe9YQy+DaR9dzxbm
	C93LSwWY2qtnGEKkPCYHi4dC3NvSGFzioL2IBnhO/5mynzUjv14VChjSlJG0dLhzvkoqUS
	Gl7mzRn/sjmxN9gqJCAyRCq8TRP5loA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BisNoc+1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754927476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LWmO/tqWZA8f11WmPuI3V0neC5qWaeQE6R0YCXV55sI=;
	b=D6cASr5VZ0U+2lgRuu/Ce7D314iL2KR6y9u6ceMrX4tZxbPMI7oiqzArzKitHUn+j2Mnhe
	LRkaBRavNMelPaEh5mFOT2N5HMAzuo/GvrAyheqGH6V25C7A6hdXjWBhwVORExpT7I8at+
	BS9L7psakhol7yZcThU8oj0LzIqqvGs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754927476;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LWmO/tqWZA8f11WmPuI3V0neC5qWaeQE6R0YCXV55sI=;
	b=BisNoc+1gPuLkK5hvfivVFyGm4PKdRHRf6h8VS5Rv8RujvtW6Vxis2PU6GYCG1YVHTwkem
	lCPYgRHF804xYuDb2HJuJ1hi373kH9xv2bWcs06xKzTr+z1QLG1w6fI97FzgGEmbAsV5C3
	dtxkFtHPh+BxubEPc5h8Fg1zafNDbFQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-449-B5gvaHwJOrqgcr7RbkJrsg-1; Mon, 11 Aug 2025 11:51:14 -0400
X-MC-Unique: B5gvaHwJOrqgcr7RbkJrsg-1
X-Mimecast-MFC-AGG-ID: B5gvaHwJOrqgcr7RbkJrsg_1754927473
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-459dbbf43c0so28194225e9.1
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:51:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754927473; x=1755532273;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LWmO/tqWZA8f11WmPuI3V0neC5qWaeQE6R0YCXV55sI=;
        b=u5i7VVdQKjy+tOjHxL6HVjzFX32fsvR1q2L2Jy9d7p/0SF33hmpcgfGbX/2G9oUdjP
         On5EZVxrXAokU8jG8KmTC4tqIiDG1aeL4BH7OcOszJ1JP/uStl8qAGZXKsuDC5Ww1z2c
         cy3mFvOPKDY7Tz9atNK4US79p4+Fuxj0JGHZx3TOaiBtkzWrdAZAzHJqr7WmwzzTrtvo
         KftniZ5R2AYo3MeoDhVjrdab9zRN1x6ylaKt1NLsO6kMiaL/Tew/er45Jn8/4RE50BaT
         xpjvptMSeNu5OqaWwmHK6CwlLVT8nqnOMIFVh3xBL8/kVxwhGXqIe6d+gjbEYDFSR+0a
         lJUw==
X-Forwarded-Encrypted: i=1; AJvYcCW4ZOx3ltF3/tIbPPIx3vrKViMtdcWmhuEJ6aIaAlAXTa81gg2t25zSbN+/uJBxyDJ0vpmezsKf1A==@kvack.org
X-Gm-Message-State: AOJu0YwU7Wkw2I961pyce7YE8RUBa4HptnDL2/2NA8mXWU8BPZ529OEm
	KswQp+5frgoKiCBpMchUu9Uecev2tU1Csh70rg/O+1bnGByll4MIPeqjedzSkvYNLRTlHz0OVFf
	o5QvqlfKrSFI986d6dGwsvITU0ZfAD9YBQ253ikcwEX5WjmTsYNWI
X-Gm-Gg: ASbGncuOWlWHNjsrbmmyblMGZdCO9+tCpWC/pYbbdnWoVYCHmbTI5GAA0sI7LblbPb2
	ULzMcrMUf305cp8N4+4GEqtqXh6eQtIBxdlUyLi29zXaSE3o3rYUrZq1W/2ICkq+MeqsQJOvlQe
	3tO2PFaA7uvetR+LfS/fKATg3fuugY8TRTw4MydGely7BEw5TPSRiz0Ww8g3g5meLcu1+n0oGm3
	34ZgH4JaH6+rs+OIexQQ3R/bJI4MtNnoPbknKKhRvq9EGl6XXtA2cIBVqbHlY1FNnF5rgDm1XsC
	FvYIBFMmcJgegPabry7+P3F7QH3Cow/cKW5WDlHjfk0c4IHCTGT+FSZ4kpxZZKOE6lKcYohufzJ
	tSbQ+QPj54j4jOv7XGU6H5d8sGBqPjkXy4+LWI7ElfqtaHCqJsnjPOLxEX0qsWKYhHKw=
X-Received: by 2002:a05:6000:26c9:b0:3b7:828a:47df with SMTP id ffacd0b85a97d-3b91114884amr68904f8f.4.1754927473354;
        Mon, 11 Aug 2025 08:51:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEWhkXQWO2b9wlb7gq7SkBLTpoqfeCqixrWyQfS8jXSb4i59XsYjiDlM2VUN25fLUn+ORlUvw==
X-Received: by 2002:a05:6000:26c9:b0:3b7:828a:47df with SMTP id ffacd0b85a97d-3b91114884amr68873f8f.4.1754927472936;
        Mon, 11 Aug 2025 08:51:12 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f06:a600:a397:de1d:2f8b:b66f? (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c48de68sm41359250f8f.67.2025.08.11.08.51.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 08:51:12 -0700 (PDT)
Message-ID: <c63b9a78-6a39-42e1-8a72-b4ce4a7025b1@redhat.com>
Date: Mon, 11 Aug 2025 17:51:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: swap: check for xa_zero_entry() on vma in swapoff
 path
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Charan Teja Kalla <quic_charante@quicinc.com>, akpm@linux-foundation.org,
 shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
 bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
References: <dedf7436-9afa-47f6-b676-88f2dd8b638b@redhat.com>
 <f008107a-2741-476d-9e32-ae9fc0f81838@redhat.com>
 <29e080fd-5f9a-4760-876a-a6ccef33129f@quicinc.com>
 <fec5ad61-7caf-4076-ba81-7b454ec7018d@lucifer.local>
 <9178bf98-2ea7-4ad8-ad43-cdcc02ab863d@redhat.com>
 <904f85d0-acd6-4f47-ab45-fbf18b80f1c6@lucifer.local>
 <7e7bfd05-434c-40b7-98ec-8ce352a8147d@redhat.com>
 <fd35dd5d-95cc-4c37-bf72-52a27fe822ac@lucifer.local>
 <efe3aogdw5wxsn46xyy2rrqui7oghyi7elam7aiv3c6o6hsfbx@ee6dayztcy2x>
 <2e8df53b-d953-43fb-9c69-7d7d60e95c9a@redhat.com>
 <e7781de2-dd05-495a-9a40-7718f04adf0e@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <e7781de2-dd05-495a-9a40-7718f04adf0e@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Dan6Su7OCmNFoa5GV2ZgYaayZdPBKUo_W5tA0vb5FH0_1754927473
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A39A720004
X-Stat-Signature: utxwxgz9wska9actc7u93mkpffsa5sew
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754927476-698836
X-HE-Meta: U2FsdGVkX1873EGrMneGwBzcBEFZmf/aSqnVRNC/3dgCi3wlGqtYFbb2Jmd3nG+qo7U2N3H9oS5lQqQRRdZ+qEmfXPWlj//xQrdZ4ghrwAyTcqB1Yjv/7cSSKgPJ2Y/O7YkyOm5p2QwaHK7qDiGwpZKLnJzMLS0sDERHt3/C4w2+y9+a5fCAvu1dneENEbOwuBmJbFykBfxROZ+gkWErxFsIIlTeS056Lq5ezw8/2lj0NTVuFw2CtzSh7IVHrpvyxBpU1Qu+BZ7sB4ZpgMMG9zjtTbQxjUH2PO/mMAVScsLNhPyBqs9zCMYFlHykaI6k0oAcCQC0b9wlnle8G3WLnKc79UannT2dqtdA0bitHgpyorX5aBl0yvdSiCKJO6qxOPLoMFmYYkEZA8bfOZoDBSl4qRQZaQvUyUxBeyBzidRDh6gVf8IDWIl8BDu6jBxA0JxAH/kxa/TEVI1P2IFWccWUUFZIbvXUZedYfC5szHxMRlPHD6+oLaufEKEGewp9aUw4L9pJE+MSEAax87xKS4HXyA+K4iReoDet2Fi/DvtbDmG13H0jUcBMWBxkWxrY6jTXq9dmGHtHuYpbeLXSIGWbTAkHf2JXcXjw/h2JIAtZe7Tqr9M1TjPSFqeTK/ZeVkmYfspGF/ERFzPihExS0VE4GLTFSmgefIyCjeiSp31elA1L0nNBNX/DPj2CzeKYb0ADyOanE+MSjMxr1DbiYsFgKEk1uxoPWHT+A7N0whJ6k7gtzRjs+Hcl2KJLzKqr2Ots35qJETTDu6mrxRcthuRujhV2bALGHQyQngPSk4hhi8rQkdSY3kTIZSP7xCZrAP/QKdsPpTUzCtztDfjFPs/SpfSWTpahstZl6ZvWRHWgKZejxDErMi+n2tn9L5gdpG/q7W2NHquVb4+67oOX4jBmxicFO0KDcYJaxT2ZyixV2a8/idfNhsqcmXrhzy6vrqVRA7V7nYt3iOEbhej
 o7qkLzCn
 Js/PaChUesjGL+4G9PhzM4k96fyYYZDbdgC99ou8LcRRdOXFUDKuGxS4bvWxOkk8iVT+052peir0V2B3N+dukofKutgdL5QMFGU/9l7k5Ium00sHf+/IecY7xNZWnelwPKFpbYIEg6JDXyUaPXSQUJHqMYsyxjjsqwWexd/uvjI6iBqMAs4zr7zFRZUoqAAvNGbUUqF+5ZNPrYqW2d3fGuq9aiEOZS22jIpCZI0GKUB78EgUsiG95qEbbq2cbann1n08WPzAimADiU6Uq6fvBX836e+g8/mPrGzltIcKLYdIhL2E9wCpFcLzpcyYa2I7XUn+Of7C5eRgYYi1LWaX4No03zCFWH8OnGg6HJMHHosN1YL164HzISMfz8TnqmpB6w0f5HaeTsSsvsZs4QVM9PynRjmHZhY3vSvTx19RgeRfevQApSPjDU13yT0VPf0X1ztttfhwKjwMvh9ZqA2/cAlW/W1cBV5QZsmX+8d8KwzIiM8N1X4BC7DSIGSWU8aeel97eq8I3DjyxfCzqKJDRZYO24mjX1oBZ8MRQXt2gwN0W5nVvgH/sjeRpAn27u85kUm/CmegIKZUOTt2VbCB+NlIfWep++YL5/pr7n5VgrLMfdXoi5DfqwsAN8xGfUo8QaRZH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11.08.25 17:48, Lorenzo Stoakes wrote:
> On Mon, Aug 11, 2025 at 05:39:32PM +0200, David Hildenbrand wrote:
>>
>>>
>>> I could make a function that frees all new vmas and destroys the tree
>>> specifically for this failure state?
>>
>> I think the problem is that some page tables were already copied, so we
>> would have to zap them as well.
> 
> This shouldn't be too much more egregious?
> 
> The issues arise when it might be an OOM issue, but if it's a fatal signal we
> can take the time to clean up.
> 
>>
>> Maybe just factoring stuff from the exit_mmap() function could be one way to
>> do it.
> 
> Is exit_mmap() a problem here? Or maybe I don't understand what you're getting
> at.

We are dropping the write lock in between, allowing for these races.

-- 
Cheers,

David / dhildenb


