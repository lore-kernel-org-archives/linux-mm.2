Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03354C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 08:26:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 963CD8E0015; Mon, 11 Aug 2025 04:26:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93B258E000A; Mon, 11 Aug 2025 04:26:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8517F8E0015; Mon, 11 Aug 2025 04:26:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 72B688E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:26:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1D93111727A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:26:24 +0000 (UTC)
X-FDA: 83763794688.19.C7D56B1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8AB7E180003
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:26:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WyVOG08c;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754900781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DjTKxkTe0tmF6ZqQmCfbJH473lyi+VVvJAAe6OH9uC0=;
	b=t3jRLPFbFiBabPxkh5Lze9w0SoUKDYI23jWBi5HFOOxcjyXoQM+Vsj9CBa9ZLM4b9P6bvt
	9TnjPZCp7QV4MFtX0Kkliexz+fS0GXBwVt5/HkyXbPrPSk53xc1qytPC/cEIaXY3RuKH71
	1yX+vc0Z2oRbUdiM2IG3CNa2uS/5jOc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WyVOG08c;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754900781; a=rsa-sha256;
	cv=none;
	b=q3lhjODrSe730/SRtIVgGjQZpWuMyWeW2Q9Ia8qq7sFzstMqzNDUFyceVqWL04fo9rzggA
	MbDeU4Yl85fiPhAaecmJd3A0VwcmTcD0pqLphW5jPsl7KsnBYgQFgpYwy5ZxLLvmB+Yjsx
	rFtZy9N9XtlWt1ykrLse6jydUlraUrU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754900780;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DjTKxkTe0tmF6ZqQmCfbJH473lyi+VVvJAAe6OH9uC0=;
	b=WyVOG08c57hEKaa3r0HEJKyW6t8+Cxi1SZufosWxUNiqoUWTzrTrK9IRujrRl9cR9v/VDg
	wq0nhdbQll56e2t3omZC4dLEAAH0+etovlrA/WAmxazmF9pdwjRg1VIsFex0vO4fl8hky7
	Y/mm6dkmOh9kG6ESJF4hf8hZrP3AT7s=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-erwGCUF2ODK75dXyinyUdw-1; Mon, 11 Aug 2025 04:26:19 -0400
X-MC-Unique: erwGCUF2ODK75dXyinyUdw-1
X-Mimecast-MFC-AGG-ID: erwGCUF2ODK75dXyinyUdw_1754900778
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b78c983014so2727012f8f.0
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 01:26:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754900778; x=1755505578;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DjTKxkTe0tmF6ZqQmCfbJH473lyi+VVvJAAe6OH9uC0=;
        b=NEPTbIvyDc60/7wrzxvKoop/zOCMvsi84YIY75pczU8/iauqeusB+3e2zFXU56gtzr
         yo/MlLewRTiVDeDouaphZ13efCfmeoGvHF3Z3j6cR8wcYBeBZSSVpiajqB1mNoQls/n3
         EJ0uBcNl0FRWquMzMu7IJc/CCXEZPncEeonjItZx7BlxAt7T6USDxwhxsklAv0FDb1KX
         gHCp0muQR5fGgU/wTmwdSyDfccfBGs0icLhhaK7ju0JNPV/HiGsfCZqDIBX0VvRpVBlk
         CNb8uFLz4P1mxtWoXqge6XEvyQDG5aRkc5wTaZpHnpyFkU/sPhJvZ2Ij7Md0JK7JFIVu
         GBJw==
X-Forwarded-Encrypted: i=1; AJvYcCVs3we8LUzG4JHXLrqRML143LZHKgd+jAll2TgKbg2mCQNo4Me6qn3flU1x8jOFrn9QlFt/9B8Rew==@kvack.org
X-Gm-Message-State: AOJu0YwpxMvyrvpuqu+sAJTei2gqxkOvDaW9Xg6/Tz1t1B/bLcg8pFt/
	xbZtfZFEVA+SIoiG/qAob1/owxl+9tsRfN6W5v4jr/2/gom1d4cHV0zIj68z+ebHjc6NcKZhgyR
	j882XKUbbeA1I7eCeFv5ANQj9HsnB2Naameor9Pxkzu4Qf2PTRxIt
X-Gm-Gg: ASbGnct6fBwT099PJVIul0R1AZcg5rbP+gZ2bQThfU7D4+fwo7ZSmMsXoOnfDE0+e0J
	Nn6byz4wV+SPeAYmQ5Pr28ahZ4c7lzF9Ng0jSohgj5d4xOi1T0KIBY6Tt2/CuQpAuXuY5gSM7n8
	JdJTq7fu2VlHEY7xtxF7UqS6NM5Z0c2OgIfAhvBEAS8oYFUIRcMUR5FTIbVTI0G8n3VEFQTDT97
	UR+D5YFKniG/eCN4rAYrPpLNnFP3Hw9mKOtGUk02/GFtBNQBWeTIdn/Qfmm0l5WLGEf5WUJ+dOn
	YhPvwF7Aj52F+P5fv8+Pn1mf+163SbecMMHShNlAQesFzJbwjbTmERZbn9KrH+RnzlqZ5BbCeM5
	eiXR1ge4KQRWfUCBtYXKMD5pComEvL8AtDaAVQmEaIdfrRfsd07wdOrRroaJSXiYnXEw=
X-Received: by 2002:a5d:64cd:0:b0:3b8:ff39:486d with SMTP id ffacd0b85a97d-3b900b470b8mr8495031f8f.8.1754900778410;
        Mon, 11 Aug 2025 01:26:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHk6RKKxrY5nZ0KANzwIEQvIBjFFdFZPDE9g0xnnExj7Th5CeimssUgDeqgkKs0YNXeYtV/oQ==
X-Received: by 2002:a5d:64cd:0:b0:3b8:ff39:486d with SMTP id ffacd0b85a97d-3b900b470b8mr8495008f8f.8.1754900777940;
        Mon, 11 Aug 2025 01:26:17 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f06:a600:a397:de1d:2f8b:b66f? (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b8f8b1bc81sm17491078f8f.69.2025.08.11.01.26.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 01:26:17 -0700 (PDT)
Message-ID: <7fb6ce41-a5e7-496f-979b-775b8e30e764@redhat.com>
Date: Mon, 11 Aug 2025 10:26:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: Use max() to simplify
 hugetlb_vmemmap_optimizable_size()
To: Matthew Wilcox <willy@infradead.org>,
 Thorsten Blum <thorsten.blum@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250810214745.2368-2-thorsten.blum@linux.dev>
 <aJk2IygsxWKYf17u@casper.infradead.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <aJk2IygsxWKYf17u@casper.infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XiBFSRD090kRz6mKUJ4Dkc631raZQIVaAjRLlgwnlWI_1754900778
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: enttho55wcuqf5kpcyo83imhjeqmsaox
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8AB7E180003
X-Rspam-User: 
X-HE-Tag: 1754900781-665853
X-HE-Meta: U2FsdGVkX1+2SBjnIZLLKKXcVU2GKSRCQonVClSZ0YANffLCv5gIr7omymhtkfGuWI6Ph7VDJrRWLrXOOAYajPE89Cn4fM0Rwg1V+RWnHtJB2kOOfUYPiLFgmY2PiuLchRmfO2JQGKXnJzZSyYHy/fpLxvBxwd5P7tEeC0PeWp41TSrPaIBwxRbtWp6v3ZNp+vzMJqBSWwp/n/HJEMFxFBIJIV/fWWS4F1XivRryyVVA5WU3bXA0sQmaPdYIYxyI0kSR7kDMhnUI9WqTCV13uTuFsGdHYCKKpeAc7n5BtdW0C8ybpxdekQvfyU/FMgNXE/vWJ5028yL5Lc7sEWVywvFlfuHzgYuC90zICpLmgjxacs+rjDGCnhZIimstB32yQQrnM/g+c464X+x93utBXa5UHbjfD06OGiT6Y6dJ9pW9GyTVJJz7h9X965zAxIw9rwgIX+OIr68tpXcv3q5yKbHz/C98H27/KAzhdMbomKuE/ZyUCqhRlksWBpioEIk1zTQZ8CipWAAOoWLV4mN36jXHrcWczrleIr1pO4eU2NIu+gGX7wVs6BytEAJ9IBXoLBlUHugGXmnM++ah1rJDf4Rz/frjw6gJ6Yrxb+p/3UTy33oP7ge/aWnWO3aZkD+J53QyMZtVkJjG9xzARAO7wzRLM+L0/T+tarIwB/11d3xc2zpPE+fC1NPxva0UGoU/GSbvCrGEc+hYMQEUZ3nNbkf2+/5OZlek22Lv6ii4xp0SahRplmqJz+7LaK1h/Z0J2XQLwY7o/OhAnPvA5aRJKHunn51PVE1N2UHxibxrAPgmwA6gqCtnjmKfM+FsUUWvD7c5kQY4JzswrZ1Wzs8OkBUhnlSTlWeOqv7ooaoknBGo0z1vobkH+BTfrF3Kxh7ZxvFFDsNKGD+gZ5eaBRF62keCPwpG4kT4I/10DRbeHvHA8zkQemIiUZT5HEOLLijiIJ/7ONHY4F4+AxGVOwN
 Y8Qo/KxZ
 6oCEAoTxzfDRu0wjaevrGy828M34zGIAx1CFqpf5IGGv0Ojn/6PPrxAINJtfFuhunXrfvOKlghG3c6bzRgWiseEE2QAJkvHzaR2UEHNasqwVIW6Ch8cX0KgKRzVN/LvzZ1JO0z2ZpKpRl5Ntgd2to1RMETEE/aGkL+3WqfXKuWr2XvivRBzztW/hFHGUywChZErk6meCa/hP/6uaRDWkamgSX14gDgOT3lucC4DgPlxRGoireU6/rfN6gNPlSzAB3Fnj1UHYufqQz13XyEJK8pj1TmRvet01nwRTkrVNhrWwpyqf1DU0/SXnJJ1zqTKr/D0PAWt2KY4WUT5V+Gz0bLsauJpbR34pxm6UQjj9a24bujK9Eb2UqV3YPW6L8ptuUIzwEk9JQjxdDKbWHE3psgBqwbcSOF635PLw2viJslEOgTXI1vvatyBxuXKqQX+l5JOVrIJeIf8l6f1uGqOBQ2tczuC1DCcxBffW4JDaM0yt+ggCen99LI2lYWfiLX8I4jrsK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11.08.25 02:15, Matthew Wilcox wrote:
> On Sun, Aug 10, 2025 at 11:47:45PM +0200, Thorsten Blum wrote:
>> Use max() to simplify hugetlb_vmemmap_optimizable_size() and improve its
>> readability.
> 
> That ... isn't clearer.

No, it isn't.

-- 
Cheers,

David / dhildenb


