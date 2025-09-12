Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E22ACCA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 15:44:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 310166B0024; Fri, 12 Sep 2025 11:44:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29A6D6B002A; Fri, 12 Sep 2025 11:44:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1136D6B00A7; Fri, 12 Sep 2025 11:44:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ED4816B0024
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:44:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 94E0C11AEFB
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:44:07 +0000 (UTC)
X-FDA: 83881019334.16.A7A17BA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id C244F40003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:44:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Uog7mF18;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757691844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4DxtwTQCPiZwtY4nVnJikc9BconF4cFntYOMVXEuMbk=;
	b=aj938FsW6OgGMyjhhzkIDpckbxaRCUMZL3XPgXHmbeKW8TKIChJ0KGiNAP/j6KSxF7bFoB
	cgIDOgTt0p8PylMk0Q0BTHW2/UlVHaT4wBdBaXiKGCRpotzcW1ZtOV3hLv+0rAaZxwsfIa
	7WvKCmMZ/Xy+ifeVNxRcFjYiv477viA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757691844; a=rsa-sha256;
	cv=none;
	b=XM7vcRoeX349TUxOIjFkmGjuCl4EXqqf6BkMU8+p7hgRyVvNbaRQyOVfdhgZWLf5NR7R5b
	GVBnYGUv94Cfj9BGHnlAN6nSxwBst+69rlgsH5cpSd+7Dmp1kuzZfSy2qwoHfdXAUDTGsf
	k1WBZWZIZ/P/pdQVDCG0tgAwxIy2khM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Uog7mF18;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757691843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4DxtwTQCPiZwtY4nVnJikc9BconF4cFntYOMVXEuMbk=;
	b=Uog7mF18qmUIcSopGtkwoj10L09cFZm17N+M+862LCcyAC4sHyk2e6NO8LzbH6cvtxm8D7
	zFdvhevq6e5i8xd0FW+X1Tmk4XnFUC5Thk9R41FB2I3QJitL1kGcbMGjonD1fxUYIYVvqb
	zwfw2lVHW/WdVjGYoYss2U/IpDj4z0E=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-492-s-SboU1nNQO-eJPdN0JxIA-1; Fri, 12 Sep 2025 11:44:02 -0400
X-MC-Unique: s-SboU1nNQO-eJPdN0JxIA-1
X-Mimecast-MFC-AGG-ID: s-SboU1nNQO-eJPdN0JxIA_1757691841
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3df9f185c7cso1143185f8f.1
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:44:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757691841; x=1758296641;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4DxtwTQCPiZwtY4nVnJikc9BconF4cFntYOMVXEuMbk=;
        b=eY/fGzYyiWp+pQFiI3HiVeHGPn2QXJSvIEmgYcOzQgnRz2lAITBfIJNbFEwV1Y3uRL
         kyNbQxhtvfRtocudeOKJcDuXWwK/LQApZQQ2oNoWZxTVYU4whoFQHTSGyvsRBNG25SGD
         4nhvHknf3UPqOxvKXz/qoraPHwClGboE9AJBPfVHcHJBCXw8TvgXjQFvUwXz3f0GiEER
         IWaiNxta4IJwTGElYKw0e2M8KlZ/xAetEHUDb8ckanGAJy78DaqvpGvQ5o5B8KRUGal6
         Z05U8siqDm0wix9Oonn+YNuphvke1DD6RD7NehoPJXRzTnP34CINGdSETg1m2DG3pEps
         peVQ==
X-Forwarded-Encrypted: i=1; AJvYcCULYhtebYv3gkgxezFbGO96thToYv7UIALTc8hjeevHTWBn+EINbZB0vaIQEEPP3hulpZQ2F29klg==@kvack.org
X-Gm-Message-State: AOJu0Yzul4iCahZuN5M/ULWqV8X0ZzQpIfiRVB6OtDxclgeuRxeoDLkq
	xFlVMRR7H5WOdxovjfAVxT5V9/vCDIf3D7pdpB4j45r/hevb/45JAHv68jMDXXwvdc2M41KZnl2
	+SEcFW+KaXEo1vSj1L/YQuJ53Nqfy/iFXgn6nXMHAmTBicNfcp2aJ
X-Gm-Gg: ASbGncvrhUaT5u9FpZ6xZMM5BRNgsBxuhMr3Lr+txAuuGeXwiOBfumy2JqpjhlowzOc
	DZXsf0Xt3/YaBBf5mMpbfdCDRD0Um/eGOwGhHuKjs3mY7Yb5WOns6rlkAg5zHTI/Xp3IUwWGrl1
	vrq3GyiWsIOtDUiDRcJbP4AXlhethsmHHsbD8ipda2yjiMRh0RxlxazW3PjkVsmGSi62GBvHm1p
	gkmK6i0jWQ09ovpyMDHoTtM0OwNLfIZYj+uUierFb4Ik+OP2PbhFf9WmlsQd5NVSUpypBWXa/Ln
	ci4j7blqREfeF0uQvdfcb7sIa5WxClHHap56FDJkeiLXiEDUkDc9xrZrVvGACXSXlPJegqA2j21
	i5zc661G+JcbPOuVs2ZmDB+WhcBTeNVzq5c94IGza0Wyzws+c+hS1qRfsQ8Ta1CuMHKw=
X-Received: by 2002:a5d:5d09:0:b0:3e7:17d4:389b with SMTP id ffacd0b85a97d-3e765a1b499mr3701087f8f.52.1757691840769;
        Fri, 12 Sep 2025 08:44:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHknotLSLP2K1zWqBYgZh5DKvVl0wcu4M9IAeXq4lHdbs1Rpq78uPryI29GX5fXqxYpJvssiQ==
X-Received: by 2002:a5d:5d09:0:b0:3e7:17d4:389b with SMTP id ffacd0b85a97d-3e765a1b499mr3701014f8f.52.1757691840256;
        Fri, 12 Sep 2025 08:44:00 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607cd691sm7166274f8f.32.2025.09.12.08.43.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 08:43:59 -0700 (PDT)
Message-ID: <aa15dcd0-15d3-45ad-b24f-737539bff861@redhat.com>
Date: Fri, 12 Sep 2025 17:43:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
To: Kiryl Shutsemau <kas@kernel.org>, Pedro Falcato <pfalcato@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nico Pache <npache@redhat.com>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
 corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
 baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
 wangkefeng.wang@huawei.com, usamaarif642@gmail.com, sunnanyong@huawei.com,
 vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com,
 yang@os.amperecomputing.com, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org,
 hughd@google.com, richard.weiyang@gmail.com, lance.yang@linux.dev,
 vbabka@suse.cz, rppt@kernel.org, jannh@google.com
References: <20250912032810.197475-1-npache@redhat.com>
 <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
 <d0e81c75-ad63-4e37-9948-3ae89bc94334@redhat.com>
 <20250912133701.GA802874@cmpxchg.org>
 <da251159-b39f-467b-a4e3-676aa761c0e8@redhat.com>
 <hcpxpo3xpqcppxlxhmyxkqkqnu4syohhkt5oeyh7qse7kvuwiw@qbhiubf2ubtm>
 <k54teuep6r63gbgivpka32tk47zvzmy5thik2mekl5xpycvead@fth2lv4kuicg>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <k54teuep6r63gbgivpka32tk47zvzmy5thik2mekl5xpycvead@fth2lv4kuicg>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xLAQVpTlO8wuP_EyFRKg4nItDPfsRIMybIaKaMmXLwo_1757691841
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C244F40003
X-Stat-Signature: fjik7gwusgxemycx91jjbwe54xy5wbyh
X-Rspam-User: 
X-HE-Tag: 1757691843-683286
X-HE-Meta: U2FsdGVkX1/kfvMO2jF8ZkM/odFCkZgcpmo6sHW1EuEcZoAqPBaatKBWaVLrbT+pAhuHz9U1ouh2gNLqjEkUc2DQWuXTyzNE7tR1Vf5jc3uIxfdkvKDmEcfzt+7uVQHCQrx+KYwvExOolrfYQsPtTS+YODMgsn+3+m1JON83TGEudTLyigQxtWWgOjYgP5e1MPR3ddVtuNxwTp/aI6f+SRYwiGjjoHUveEgefHjUS12DDAPerhQlYczfBY+utBEbgJB3w4aEhrvUfqW8F1UZK1d8fIwmiRGa+gJa/Jpyum8gYMrmA/QtiQ/XioQ+7GC9Mn3uNDhEk3YQ1ETDLnGotiRJJ82Yei+Yol4hwLnBwACAW6ajBYB3tqwSqkIY/l5QNq2muyEK78L5eqv0PAgYyuQBTBb+RIhcK6GKX9BfrJSb67hkZbX0VSyR8deWcYN72k4xoGNospfWdtOfIFysZVQIQI1Mna4zr+hh/lt4yP/k9L0enARD9LvItkur0JRX2lEXdgT31Sl2AwgUwFQ3JrSiMMTU5hS5MhEiM9bJGWcl8ZHD3OkgOmo1eu7EcWPuxLj1tshVWuCjYDC/EURNJpN0gaCcYHPN2v90lV5THJhwpEeGEVCQEgYKqp+8ErLcVzyWwvzx+uqWBpRmp+RLEH/8jfO2YHJidBftv8skey7aBC4g2gHfiOoQPXCGYao27md7YMZPUIA8g99kDNmodM18BW6S6LQftZLizmoFmUxm53hVdigcaRSUGIhMwi/87tEVEZ0oDSuLpFZRchZl1YQj1oXbtPTJBsZ/98y/SNzM5AnIm02oKkhy5sKziIkVLN/APet0czFOxbQz+uHx6CJcxRGHo+2jwsq56jsk96DADjkV1S8SH0zTFDDzjpDEOkdS6m4GT9kSpPRsLXNlyUWIzdzuredMpCaGTP5VlkMQNd+vQ+l/Ix+kLLXetkh5ubDPjo0eOK6rTGXvjf/
 yBNm0r/i
 aonE+fmq/Lm3Y7Ge4F5kGBlrYqro/h/LvoTqzNEIljxb3oyqEsGBf9tpBb/Qryh7y10TSa006qOGRrOD0xjLVCajiYxNJRrl5O9VYDNjES2VVlsl1W6nfMx5FFzKdHqGhI1jS9xhSZrAOImpFUnVxKtXa7T4ZZZSifu1A+hIAjprk9RjyLyPdzmRFSOk3WlzhImbpG1QyEvXc4c+y/v/RHIEX9ZB9Jpt/xGhd0EVs+bkiPkjwQ97KkVnFB3tEOjJUeJKepM1FiIyCul6h2x6GrNm98yLCV4HbpVK3/h30jYnnWJP/BqmsBQrN7B7rtj0ksFDJcQU+K655Yw8MlGEySRZnLDJ5dIoyfS5RtjkumdCIoBHCALfEPp5fDcpmjR24ImROI8jovRPDT7F46stTczgfzPIDT9owOgQq/dw7JgcmgErGMZDGomxmh1ngmRWqVZKL7hKjJkXMMrHmZV4FRBEtfyIP2hpIC8sZKib7mBOCXqT/sAn5ojR0FblW5FvGCE4Fw89BtezqIZpwuWkTvQfdig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> Maybe in the Great Glorious Future (how many of those do we have?!) it would
>> be a good idea to take this kinds of things into account. Just because we can
>> map a THP, doesn't mean we should.
>>
>> Shower thought: it might be in these cases especially where the FreeBSD
>> reservation system comes in handy - best effort allocating a THP, but not
>> actually mapping it as such until you really _know_ it is hot - and until
>> then, memory reclaim can just break your THP down if it really needs to.
> 
> This is just silly. All downsides without benefit until maybe later. And
> for short-lived processes the "later" never comes.

Right, that's why I've also been arguing against that (we discussed it 
recently in the THP cabal).

-- 
Cheers

David / dhildenb


