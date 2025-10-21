Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FB3DCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 15:01:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B82078E0025; Tue, 21 Oct 2025 11:01:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B328F8E0002; Tue, 21 Oct 2025 11:01:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A21678E0025; Tue, 21 Oct 2025 11:01:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 90A9D8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:01:39 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4F984BA421
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:01:39 +0000 (UTC)
X-FDA: 84022435518.03.D1EB934
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id C462D120031
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:01:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="iaUhX/B+";
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761058896; a=rsa-sha256;
	cv=none;
	b=qk2MxOBtRbBqRU/s3lMFUSsNctIU36r5Cb3dVdvL3eTo7mdiRO/olYLoxRIHglXyD6Nvq1
	kclKwl+ACNXnQzfL7iG1QL2Jn67Ayid5jEvEVAQl+Z4UfG/gWHVjzORWOsI3cvOuRyNLCP
	c9DgjQUm9IcFffC3gtVKiU0u1TqQ7RA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="iaUhX/B+";
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761058896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7yJXVe0wtPJFfv2cJfTRsZF81HFcfy2+HNNXgqJJNAo=;
	b=FYsCOVQQrJZsXhKLLsgbK9gkDr1u9Ot81vO6fkvM2yO3PRjC5f8H177sKVoupbjHEzoj0v
	SEh43vx0hoKu5Sl3Wdf+0GOTyqRV0hIVsYOQZ9yXiSCo7KRBFTzLs0Y09s5qqhQWOrHRUW
	IUxNeJ2ZT2cFnljzxYKEemJ9MuMgeBw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761058896;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7yJXVe0wtPJFfv2cJfTRsZF81HFcfy2+HNNXgqJJNAo=;
	b=iaUhX/B+fdpQGSqNprj9YXul6u8nbXkWu23m/aLV/HvvC1mutk/VyO5/Gnfnb8+cOVW+xo
	27KssyJTg3KH9kZ+alZwfxnIl58EMWcNEERJR48YPRPNofd1dzyM57iEEDBvP8rr3To0xl
	8yaD9fZWTofMcGPcSpc45APFKX+BUYU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-UTSjNBh9PLO_3QMZUoh4Fg-1; Tue, 21 Oct 2025 11:01:35 -0400
X-MC-Unique: UTSjNBh9PLO_3QMZUoh4Fg-1
X-Mimecast-MFC-AGG-ID: UTSjNBh9PLO_3QMZUoh4Fg_1761058892
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-427015f63faso2930211f8f.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:01:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761058892; x=1761663692;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7yJXVe0wtPJFfv2cJfTRsZF81HFcfy2+HNNXgqJJNAo=;
        b=e7KGh2Ak1ASHPx/R1VgVOwnIiNuD56Uvp/j/XbRrEednOK7hxZnv48vaUrqTGyEGnM
         Gt9Rs/Vvdybz3U7gq/KRhMRSVd6Pb9QXzKbHiBCZFP4OTlNdvNpm65oH1TFi/NV2HgJ9
         i6xIW5e5VwdIoxUXXeVqdU5Is2+p1vXclAnLKMJIANn7xe0E9nYlZPr+yToJyAich9Zi
         8qF8tjDuF0ytl67kvRgerGxaeKPQ0wOXeegZT2+muSOS3ENilSiXMGJbUALkE6iqKHKX
         lBfGWx5bqpwD2xfg5hcayp7lSDZb8LxWmb+gAjYQ/+qA6a/Awy7Gm3r6PNsVndluPuc5
         VHDg==
X-Forwarded-Encrypted: i=1; AJvYcCVG2GzA+alEni2pabWSXLOZ2VyyXGXWLMCuUZicGuvRxUhQffACfA2vilbz4HvYag0uZ+z0KnSa8w==@kvack.org
X-Gm-Message-State: AOJu0YzDAyU2eSuDE67BzqS51vv7las4rDGdH4PnJTS/mCo7UsgA+KHI
	NvcQVorfoAY+SR5qZ1Q9lHaG5Ti7P0R5Pi9oFcSK04jTBUjVlBZNHNIl7aKDKkMXfg3HmziyRfq
	8lZgo6PRqgn3FWnfELFq/MyioOJStpm1jg7avFqW5lfVWAYUh5Ajq
X-Gm-Gg: ASbGncvkO3QMuZzNwLrVdZ5LGCvd3tbk080XGIJ0IXOiDIyEddra9FhhpN9v7IeSIqg
	XcT74MKENMSOznHvYGkVqmtmO1V1ZWQBiGnfLgo9YKSRmyRZ8CA0AlfcdbSMXJgOA1qpmxo3ikC
	2TDEzWSiofD5iK08HFpnnAPcaz06RUji9Cj3QlafDj9CAHitUEu6JeJ5heDbtClVorclf+nV4YC
	FnaLOu1uHd94qJSpBpC33nPJysOwuArOOlu81XNV4TKL3y0yPiPMhXRY6OuiDxcAUoL8wLmxI0b
	hsga9uR/p48rHD4zpn4olYJ6B/QKvEDi2tyml6NlCz2HBkpNen6G6IsHXL5I83LtTHVQX5ZXv+S
	3AW0+k5v6LRDQqfenHh8oWjYdsXJ3dJSHcQJTQUJn0M5bvjnZpOJbmdu2sgRl6amUx9Ju3mDkgK
	nfgcCrCXyBY5ROJfWzS9ezVX7GzzI=
X-Received: by 2002:a05:6000:250d:b0:3fd:eb15:77a with SMTP id ffacd0b85a97d-42704d143e3mr10233690f8f.6.1761058892394;
        Tue, 21 Oct 2025 08:01:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFwXCegWMvFMDqUTrdWPWYQhBvcB3gYT+S6wH0TTeKXDvD07N8N2HfBjuhwqDqYRGce4dHqZw==
X-Received: by 2002:a05:6000:250d:b0:3fd:eb15:77a with SMTP id ffacd0b85a97d-42704d143e3mr10233660f8f.6.1761058891846;
        Tue, 21 Oct 2025 08:01:31 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f009a75bsm21098836f8f.23.2025.10.21.08.01.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 08:01:31 -0700 (PDT)
Message-ID: <5703e7e6-f037-4b4d-be74-8c256e7a3e10@redhat.com>
Date: Tue, 21 Oct 2025 17:01:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/4] mm: mprotect: convert to folio_needs_prot_numa()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Liam.Howlett@oracle.com
References: <1a97f0e2-fc97-4257-8540-cff06a789e32@huawei.com>
 <5ff1ee06-375b-4d5b-b513-7b8cab4e8139@redhat.com>
 <f1d3d11b-6ac8-4747-b2e7-952d4fc3e09b@lucifer.local>
 <719c8df8-b4c9-4a6a-bedf-d62becdb09d2@redhat.com>
 <759578b3-d582-48cc-90af-491210ecd90f@lucifer.local>
 <3ee89484-9cdf-4c50-a5db-79b9f2ca6886@huawei.com>
 <967f61db-0ee3-4257-a44e-69ef15ced012@redhat.com>
 <944fe458-6391-4cb9-8719-dbaf69f3958d@lucifer.local>
 <72e2f6b9-d241-43aa-9a3b-2f13c763bef8@lucifer.local>
 <3554c866-5087-4beb-8d63-6a3cea02d431@huawei.com>
 <16ca4c3d-7c18-4cb9-bc04-d2eccb5d9b67@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <16ca4c3d-7c18-4cb9-bc04-d2eccb5d9b67@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: u61RrAXsulyIZD8E-ZUuRi6dWWMOKWo8cN6JzDfIJTQ_1761058892
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: kjmodg4hzkyazke3gjy5xwyg8p6fas4n
X-Rspamd-Queue-Id: C462D120031
X-Rspamd-Server: rspam09
X-HE-Tag: 1761058896-863859
X-HE-Meta: U2FsdGVkX1/g3YfYoI49Gj9JkUOMcf1chtffMSzFlwPadsXxHcu1TPzTluhbs5wSIiosH9kGpUhDZOa8ioZh55QPQsR/9PNQHdgXiokC99S6G95xx2Ark8S/wr6Pu2RRCgZs9ZypdD1O4J3Cs8TUfrR4R+8WuJEPZv9mQhzzXBKcL4s9j+/br45h0zjCZ4FIYprz/iCoQBd3wK9dQjHvozrlEuYdttcHqIHWvN8uWtWAFLy+WQZaDhvvN9Lk0yEUI9Cvbh4d4ovHugaN48fPCC92hcHOuSnf+vS2aAclgu2TK3LpHEbVVCYG8AKaN3fHZijka7VZt1QBgX+u6aQEXbBDRbpYFgBRsDmE5LyvEurS4vm3cucWIUtJDVkGtQ9lAqwK1kEDXG6NNpsAR0FJyYTtXUhWhmHiwK5SuJVdV61ottet8O7a+RjirDoe3LK/xE8F1VSDqtcwPvC1qYYT/2P9LCIC8oiZYArNDXQV8h1DQC5Otgq9GgnkOAOLdMRIgXKtLOW/54n1ejCUdMnDFzSb+k48egceJaBXQrbYiHotoXbDKLOt3JojIFJ2Gwx6hy247xHPKS51cuAzBCXCgLC20o9Jt7QlJT34gegHryrkgYk37ZXTZbztMXAgmtgSMkqCrKQ/w42f9/HcHklcCkwDAKe/1+5M8sVZztqq52rSYASWHB0I8LadCPmtntyUmagVI+FR1j2KzztHN1AUvmuYtXYxfrzUvRB2zWQqh9WTO88j0nvgOM9bClPj/4NJbLI07Jk7WDVogZbCMb2AKHZ3aJ0zT5iYvmLhe3tYFiNi1Ijn1mo57Ew9qojV5WojAEhDI4Y7gq1ez3CH47uKsezRldTumOakku1iaRe5CUBLMRZRy/ams61qe6mIptgbhkpxDhlmcW8BIx5sceNwjvOUQDE4Tw1k4CFZ4GUNEoAIcEfkNiuzcRRc6HFb3xxzha94F2KZoSx5VbPDeZh
 n9sjNmJH
 Y0z381Fs//Qs3WviEIe0+AX9AnV07fCqHdfkL8eNhl0cnkANaIyJdCpMBf8mf9IaiqULFCpQ5OLN8kj3pb1ST7STV4PngeFDkG2p5Uh3nXWg5+7ogv5XFkMZiGMYl9o97fDnGOplG0Xo1AvzmWQc6pZigTWS8hDX8hOwHqB1OofxCXayAr91zzCCKEbmQJspoQEn1uPx4/raY1m7/6Qmql68CmJOdLpH5CMOGfPkiHrmkC3d3Wqm5mYFZAfgDmmxVi8Mlu8xdPtGJLRDXipZZjK1wY98ceqTJMaTJIyTebYckGVeYVCGcZeXV2kTskVf1YLmwERv2aB7sT6dhfIRBBxbqKILZTr4M2ckiEeBeYCmWmIVEQZwpwO9gs2gRoWbwKvP78wwrGmw6R/jgjkqas24694vNbyp4m2HokSygRdfj/O8l274ivc10AdJeBKGS3nqAGBFJPt4kN7IoD9c0CBZajRvr0cjl8/Bh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.10.25 16:56, Lorenzo Stoakes wrote:
> On Tue, Oct 21, 2025 at 08:54:08PM +0800, Kefeng Wang wrote:
>>
>>
>> On 2025/10/21 17:45, Lorenzo Stoakes wrote:
>>> On Tue, Oct 21, 2025 at 10:25:08AM +0100, Lorenzo Stoakes wrote:
>>>> On Tue, Oct 21, 2025 at 11:13:32AM +0200, David Hildenbrand wrote:
>>>>> On 21.10.25 10:41, Kefeng Wang wrote:
>>>>>> Maybe folio_needs_protnone_mapping()?
>>>>>
>>>>> I think prot_numa should be in the name one way or the other, because we
>>>>> also have ordinary PROT_NONE unrealted to NUMA faults.
>>>>
>>>> folio_can_map_prot_numa() semes to me to be the best choice.
>>>>
>>>
>>> I don't want to hold up the series so if you guys feel strongly, leave it
>>> as-is. But this reads better to me.
>>
>> Let's keep things as-is for now.
> 
> It'd be nice to have an argument as to why (I did say if you guys had
> strong opinions...), but never mind.
> 

folio_can_map_prot_numa() works for me, so we can just use that and call 
it a day :)

-- 
Cheers

David / dhildenb


