Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F66CCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 07:41:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 217708E0006; Mon, 22 Sep 2025 03:41:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C8228E0001; Mon, 22 Sep 2025 03:41:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08F528E0006; Mon, 22 Sep 2025 03:41:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E07108E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 03:41:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 69AE45955C
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 07:41:44 +0000 (UTC)
X-FDA: 83916091728.03.E2A25A3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0CF0C40009
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 07:41:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U3uSviET;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758526902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fzHIUQbJNzpGAehghm14zuXxtLTVpwy94eSLphrZ324=;
	b=utHWtIi0DVzXQD0ADAl5rxysuQDCMCcalp+OxZO5rDx8k+fNPI2iqMKalQ4WN5laBgw+mq
	ORYri4OWkk/UkqyxpsFf88XjKhHjCLOYaqRQxLs+kb9AORNmwOuaOg1z+ezuAW+Hmh4y9r
	2QLK0O9ZewNTmmhnzPq/u/t2vDcP9R0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758526902; a=rsa-sha256;
	cv=none;
	b=GZ+iuWp0+k3WdEFUF+2o7xE2wj1mZr+EHidVof8DBhg34Si8JTP71yqaHaVf0fQqfZia1U
	rpcbMhpLBUp12+vtD7m/Am05rpamraeoIDjH4xTg2qdlthwTcKSQabCeffZgSYUxlrI32J
	/ii7jFt4rINeA17ija+scohmTEwfKHA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U3uSviET;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758526901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fzHIUQbJNzpGAehghm14zuXxtLTVpwy94eSLphrZ324=;
	b=U3uSviETBw9QvzfoBI0ae571TW/RjiTeHaxS03i3UM2nwDFurXdtw2vOaRgtuHwE3mmSGK
	d1KvQx8ZgJBV2Q/NwUNli64Ul1D67NE2tibP9DFs32VDKL41rblAT05FCfbNx19zVOKlFR
	GaeTeP111etg1U7qsn9/1WJANx5pYRM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-441-KLXFZp5FM9m1VzGhNThPnw-1; Mon, 22 Sep 2025 03:41:39 -0400
X-MC-Unique: KLXFZp5FM9m1VzGhNThPnw-1
X-Mimecast-MFC-AGG-ID: KLXFZp5FM9m1VzGhNThPnw_1758526898
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3fba0d9eb87so329750f8f.0
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 00:41:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758526898; x=1759131698;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fzHIUQbJNzpGAehghm14zuXxtLTVpwy94eSLphrZ324=;
        b=iauGhmEKtHtJpt99UC+Mf0si200tT/ZncJ8vzdc11s8cYIfid2kt+BXkW6q48uCwXw
         OO49xUPaSAStcIagC+lT+tkkeHlluiJSENoqjhOnpWx5eIhqRyPT6D3ybOAB5TJ6EBPn
         MyuaND3euahj/qru2vvUCGOw72zf7ETRDb98fxmsfbrexhrKA+R9QUKZtMkhrZ+WvSBe
         TmX6OuGdR+YoyFvcta2y8aWElX2EHIzngeVJ+3Ja7eKL0EbO9r/qiuPj8Y3NL48oY7zG
         kXU5LT06y0mUJImIxP1MRL+nVtCJ4+5+qUUPBgj/VBCmjTn2vsudl0QJprA/BTttnWvO
         EDEw==
X-Forwarded-Encrypted: i=1; AJvYcCXzYTN1RVoV16P70Bm2tnSOwizBltqCQT6wUA7ftHdExMWVgg+vCm3sBe5t1mumAzXAdmPXHuadSA==@kvack.org
X-Gm-Message-State: AOJu0YzGrU1btxPt1Rbcop4+kVv66QZACQl53TQzF0+D+prBRvOiL2rz
	BcEyVjUJ4WOChYEBCLvCx/Eb3JhSA8NDnN2WZwy9smAxPqh3DYz9oNZsyoqNcIr0eZDZq1nWhVP
	4CB4X42yQ6m9cckxN2e8tf1OxBkbYo0NbWgMp3P0m8Kb5seJ5cxNV
X-Gm-Gg: ASbGncvvI04de0j9IXFMZ5vc1gNgYKKCoU6tywPOwHLYSgXP7XorLBaneNWlXIicv7S
	2vinDWR26Q1wtclL7Q2OZDzKQtiSmqjCkE0qvX+nxHn/I/7WIwKl8L7So9qTG0iTHP6KHJr9Xrd
	EEd30Jgixgh8UfogvcftVJqybLZh4dWHvTFaOy7JZCqDWURr1a7+vBoB0Yw/Wop8d/AdBcZW6hK
	cocRSD9grA+0rnzQiqqGQz7GL1m+MOFYnItOp5lj5C4qBnNAt8TOM17K7vc7/4+LraK/haPcYDG
	mMGSr6lEYbgtmjWf5wQf84oJ+bWCzBldEvTCCdE3YbS8pCrmbkzmlM8Q3hw808HXDcZfSwgD9cj
	7XrkJV11pK5Xl8hkfKDa5MByjx1T6bUOXbrSYObvpyHoAQ3jox9+oDGJO8Wbs5OU=
X-Received: by 2002:a05:6000:2203:b0:3ee:1296:d9e8 with SMTP id ffacd0b85a97d-3ee7e1066dbmr9258898f8f.17.1758526898167;
        Mon, 22 Sep 2025 00:41:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG9B1weiPfO6bMVbHAqxOgbive1f1Crq3xoi47kw3u1f8xvVepvQI2XfzLgozHSVwVEVQfJTg==
X-Received: by 2002:a05:6000:2203:b0:3ee:1296:d9e8 with SMTP id ffacd0b85a97d-3ee7e1066dbmr9258869f8f.17.1758526897678;
        Mon, 22 Sep 2025 00:41:37 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2a:e200:f98f:8d71:83f:f88? (p200300d82f2ae200f98f8d71083f0f88.dip0.t-ipconnect.de. [2003:d8:2f2a:e200:f98f:8d71:83f:f88])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee07407cffsm18716189f8f.16.2025.09.22.00.41.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 00:41:36 -0700 (PDT)
Message-ID: <111b1bfb-e2e0-4b2f-a559-9803828f3406@redhat.com>
Date: Mon, 22 Sep 2025 09:41:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/thp: fix MTE tag mismatch when replacing
 zero-filled subpages
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
Cc: usamaarif642@gmail.com, yuzhao@google.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, baohua@kernel.org, voidice@gmail.com,
 Liam.Howlett@oracle.com, catalin.marinas@arm.com,
 cerasuolodomenico@gmail.com, hannes@cmpxchg.org, kaleshsingh@google.com,
 npache@redhat.com, riel@surriel.com, roman.gushchin@linux.dev,
 rppt@kernel.org, ryan.roberts@arm.com, dev.jain@arm.com, ryncsn@gmail.com,
 shakeel.butt@linux.dev, surenb@google.com, hughd@google.com,
 willy@infradead.org, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, qun-wei.lin@mediatek.com,
 Andrew.Yang@mediatek.com, casper.li@mediatek.com,
 chinwen.chang@mediatek.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
 linux-mm@kvack.org, ioworker0@gmail.com, stable@vger.kernel.org
References: <20250922021458.68123-1-lance.yang@linux.dev>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250922021458.68123-1-lance.yang@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4t5Qna-WqrLpf8v1nGqnSKmQ3KnZ4RIdTODi0S5MjVM_1758526898
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0CF0C40009
X-Stat-Signature: a7amh7nrp7mt51ndqsmpea3rrn6k6zbh
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758526901-873340
X-HE-Meta: U2FsdGVkX19gjHzUYz19rlGWvoI4XJpE36n7pM0gDU9CHzEhCtFdJ3adOyEBzKAwlWhdKuN5VqoCqeiikow+gkM3+SViAmR7rzhhaz00YKo6l7vKLQRgnFUiRFrIJFE45Z/Fv9aueLpeFJo8tGyPwRhBSgaUIC/QlhfmZjp+8Hbt0EDFR/YeJtup8Es+Clo0Jjqh1zqb8B6r36ln5CJT2uTJR77LYMgBwbNEnZHsGNgalGJwKc2VkMxxVpp4fw6zjuSWSmfNmToMjspIvR2cTisodut/ZQ3NCTFeeJq5trZJpLGXExgBZLRj/ohVLAVRyMMCrzjIE+u3Ou+4I5e455eH5BVVC2irteVFDmB9H64QUP+pjZWLjkb02xuAz5iC6THpb4hCodo9t9eAmODkZejfqf6y44fg2YcO9IlYj/tRCuLm8K3mdvVs6Qlmz5MtiregnQFGpdvWNOGVAtE9wsYN5GnuLLJlhJgsaHhU807WKMO2HPYLz0mG+RnTbN1sr/Sprj4F4J0vduRFepXug0SzsHk/0ohadGUgF3EuIgn9aqD/laMCh8vtn+G5y7s6irkqT0+VwEPGmhzXhjbwazXJJF6VoHt0kUX8Dveuu7+i4vux3Uckw+7m7wMq7B7gNAE62gXbqzIVHIO3S+zib285A/x+7cRi6nArfNcRmNuoP66dn4PqkfBJ8Gu0kVdwz25QLY6eCqmWabODyOYGdlB2tWTYLt3QVl8nSZ5cywAFydBcrni526wkuidKK2F6mDZsVpvA1Maw+bqy+/NbAAwwhgbPCcS+eJa4Kq4UrtjXDsqPcSuYzmHiYYpWK81xwUD9JFDwf+zJbxhsi5zMromv1kkoU3hS7is2XLQzRxCCkf9CX4rp0qeZaP6f/yL456rQUH0tKPukxh84bosdzYscok0to/6EPvXwd5lSYgcIlnsvK1tL74cwO631yNczzss03lwZLGT8f0klv8W
 2mN/nCcf
 /qGo8xZi70f1J4cUxU07JsV0rYQbK3x1GXm6gxjb/jRkAFIY4CkkUiFm1fXwULOUsBs2kFNuQAk4MojiewXPlzNpXqVMJrFeDvK7pAnmvTEebjSZh72hI3CBuGuVdl7XfeJ/sE+OAlsHNo1qnWgLiTxHcZSQkzfUp56D7pv0cpgcHV0aYwwfyK4amdBNkqx3GOolKKpPootDeDnJ8f16f4wYNUdvR56XPAuyvT3Pq2xXo0Rz3lHWPQZiXRGa0ObzNXOALPSb31S7Aueq98OS+qV0TdrtXeYHKSr+WctdsypdDyEhRCH6wV4ePOToAp4+hVjbVRSEw2iMSdKIHnAa9xIIwrrRH5Ofl6EH6KlFUZqpzYOJ8vqzzsdXB40NIKjvoYIIpotoE/1e+DGeuLjqr6TZV58FoAFpfnt2kTVI2sYJ3P5ZS3/QM/MW5Xz2XG/jKRQoFT0fJGFf2uOz7gm2hq5AYrCf3ZKRHfp/SRmsi/bJ80N4NhoyAHQoxmxDc7kq8ReO8fWjxAj2+HznWVacqmKepKQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.09.25 04:14, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> When both THP and MTE are enabled, splitting a THP and replacing its
> zero-filled subpages with the shared zeropage can cause MTE tag mismatch
> faults in userspace.
> 
> Remapping zero-filled subpages to the shared zeropage is unsafe, as the
> zeropage has a fixed tag of zero, which may not match the tag expected by
> the userspace pointer.
> 
> KSM already avoids this problem by using memcmp_pages(), which on arm64
> intentionally reports MTE-tagged pages as non-identical to prevent unsafe
> merging.
> 
> As suggested by David[1], this patch adopts the same pattern, replacing the
> memchr_inv() byte-level check with a call to pages_identical(). This
> leverages existing architecture-specific logic to determine if a page is
> truly identical to the shared zeropage.
> 
> Having both the THP shrinker and KSM rely on pages_identical() makes the
> design more future-proof, IMO. Instead of handling quirks in generic code,
> we just let the architecture decide what makes two pages identical.
> 
> [1] https://lore.kernel.org/all/ca2106a3-4bb2-4457-81af-301fd99fbef4@redhat.com
> 
> Cc: <stable@vger.kernel.org>
> Reported-by: Qun-wei Lin <Qun-wei.Lin@mediatek.com>
> Closes: https://lore.kernel.org/all/a7944523fcc3634607691c35311a5d59d1a3f8d4.camel@mediatek.com
> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---

LGTM, thanks

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


