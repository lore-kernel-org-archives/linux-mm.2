Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4440ECAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 07:24:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8586C94000D; Fri, 19 Sep 2025 03:24:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8089D8E0022; Fri, 19 Sep 2025 03:24:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D07094000D; Fri, 19 Sep 2025 03:24:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 550618E0022
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 03:24:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C9C421DF93D
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:24:42 +0000 (UTC)
X-FDA: 83905162404.11.2DD9026
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 910E81A0009
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:24:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VGnIitzH;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758266680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w6LQl6jUD0WoYH2Vq/+w6/chslZaFWeBoUnTDwV9RJs=;
	b=OD9SWztGYENnXVoM0mlhZ7SuWQHyZ5EasWOPYKzEEQEX1RrHSAr9s54t623gNV1ZnVhL/H
	d8RbU+OF7kifvaxTIGufSslWKAkNg+/KrKwyhS8vVSg7uSViu60Z8xkgFWX8xjFgkCsVRo
	Ts65GIpL7AAF9+YTblZ1oHkBaV3bPkw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758266680; a=rsa-sha256;
	cv=none;
	b=smMfV2va5jQfqYU+AvNcibkZ3F0sBIRL3XVowdGW1bOEkND2XXCzr2cFEtQhNLc7MQn47Z
	rcQTbJao45F9nzYJG6f3VVSDbYLpvX95MPWDcYuj3SqDjOH6sl+E7aa8GFMgTVzyrH4Yao
	+j/2eMSlB4MYFTiwWJMWHseRLG3i4RE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VGnIitzH;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758266680;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w6LQl6jUD0WoYH2Vq/+w6/chslZaFWeBoUnTDwV9RJs=;
	b=VGnIitzH726qo1b3cr/bvDHjRx0zrdEsB/znVf4Crn6uy73MbZkSpBCaZ0u8QOQjxtueFK
	xKto+AM4ykkpOJz5SIZsljith5FFjx4ovAIpo3TKE6IXfYPRYcZfn4xrSyP2I/WWs5DqFK
	qZkoUj+/Oefg2tCA450EP0/OKt2cdWc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-jo8SSyPqPrqa5zS_P_RVWQ-1; Fri, 19 Sep 2025 03:24:38 -0400
X-MC-Unique: jo8SSyPqPrqa5zS_P_RVWQ-1
X-Mimecast-MFC-AGG-ID: jo8SSyPqPrqa5zS_P_RVWQ_1758266677
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45dd5c1b67dso8899275e9.2
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 00:24:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758266677; x=1758871477;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w6LQl6jUD0WoYH2Vq/+w6/chslZaFWeBoUnTDwV9RJs=;
        b=gE86WDiMabE9JC5HglYC9OrOgRvpk3q/AZDAFZBHFSkZLtHP+4VavHKRJCOQjyix+8
         g/81oyMv9EaCh9s5GkVSN6pTxVGKzlco7Jj3n3dxhiTy4t4v+ZKtp6UJN2MTne+PKhra
         2pV/VVPk9iV82rr8bWmS+bps5jL6iJYZoaqHOSTaXvJcEO6ObhUnA4lBlUbtwUsKtrBf
         e9MTpZPcY8L13ow3akD8RgD1neHYZCzZTwdnP4cyUS0h/v+EvMiD2kztflmdMD2fqUE9
         L8nPDbna/lxXQgAia67x85hsYZtyrIxLcY5jNhDo9VXWNpJ4lD7KJh68/g7IPusRJ0iy
         M5bg==
X-Gm-Message-State: AOJu0YxPfpnZVDfUI6EK8HtkaPx0qARvTl6bo7LXzLc0S1iR1LKHl8EG
	L7JhGFp/UtL3JbIHW91jKC35WZuQ6lb83/2I+SXQxlJwjSaWSWRJMG2S3FcwM2guayzSsOREw6M
	WUnU/S1BnX77iphS8BN81Vwj021P8vVn4KEjDVNHWrcIMTayDnbl6
X-Gm-Gg: ASbGncvYIAMYZ5L9MMyKk+UsgRXuPjY6AbrxDQ0yQ/1jAbN5fXUpZpEElXBhxplmxWJ
	qivKvZvzm9MLRiSI4GRDSSVUC2d5w55EsncqJkwFWK7uRnEeq7dRn+4oCN+fQwWeA4xpewg/X6G
	d6ejaHdY/FtarGP3q8TvwAIeSCJLBrSWN9wCpN/SgBmJt/qnoXAmFfsVgKbx4ZGHzBlTFx+Y19u
	7uxCgpW/mZ2Vr6lsAeReQo/UMjvvwVDnoC4AtRNNkQjRG4iJ7aB2bcdtFAO1O7vaa6MGxbeyqid
	kPwFFg4yf9pU4yp2Bs0o2nkGUJFYFkByrmZVBhLcM/Vze31v67liDb05hxjoVcpnUsSFaw/uQe4
	J8hvSDJLfZNrM2KvxBOfMqrhULAt1I8oxPRcmFAfRaPddJXP0aYI7NVMvmX3WMtgdwfsF
X-Received: by 2002:a05:600c:1907:b0:468:6049:95da with SMTP id 5b1f17b1804b1-4694b7bf517mr3956365e9.24.1758266677401;
        Fri, 19 Sep 2025 00:24:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHfG93XwkxYcO9Lsw0NB5SFL4xYU9MpZj1MzHbY30OSB3Rh9wskrfDmFgMAsKrWqeCp4Uu6DQ==
X-Received: by 2002:a05:600c:1907:b0:468:6049:95da with SMTP id 5b1f17b1804b1-4694b7bf517mr3956035e9.24.1758266676983;
        Fri, 19 Sep 2025 00:24:36 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:5600:727b:b2f6:94a1:a51b? (p200300d82f235600727bb2f694a1a51b.dip0.t-ipconnect.de. [2003:d8:2f23:5600:727b:b2f6:94a1:a51b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbc72e6sm6332457f8f.29.2025.09.19.00.24.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Sep 2025 00:24:36 -0700 (PDT)
Message-ID: <a8a4afc5-0dab-41ff-9828-9fe613ada3ed@redhat.com>
Date: Fri, 19 Sep 2025 09:24:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2 1/2] mm/ksm: get mm_slot by mm_slot_entry() when slot
 is !NULL
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 xu.xin16@zte.com.cn
Cc: linux-mm@kvack.org, Kiryl Shutsemau <kirill@shutemov.name>
References: <20250919071244.17020-1-richard.weiyang@gmail.com>
 <20250919071244.17020-2-richard.weiyang@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250919071244.17020-2-richard.weiyang@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: O-W5z-uoMtLJwI_0jfvD6q6tshf-b9pXh0za4p9_vQU_1758266677
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 910E81A0009
X-Stat-Signature: fz4ypred3e9nponznc9ewy4gyh5f5efy
X-Rspam-User: 
X-HE-Tag: 1758266680-327215
X-HE-Meta: U2FsdGVkX1//3mEMr5Gi4AodsLbJE9WDkjD87r306kdd7RlRgQHQDks1+iFWCMzhkaDc3QOBeUOv1tJmU5NI4Uda/jQeLyAwl3LaO1t0hgpr6LuyjIxVJo6AiVJmpToOFyf/G3HB+V4r7ih1S5yu8RJaD6djJiksKtM3JiuiLs3iXO6oevbPS68gXPmC7eYKEcP60n6BE6WgFv0cB+JIz7x9xCI+xKg0LPLp5ZxIlL+g4vNfV9qU7nfCvj5rB+wwcaYBp1XsxZep1uUMeS7YuYRt/OCySB6vWhkOzeMHSw5fbemPsRBmb6GfDX3WUtmP4AmeDO8ChEW9fczPq7NpVRgZ4tCWg/ugBi2UW2XFVywvYRqYii7LAwQdTfS2uNKBcYgvurutlEJ8gPfZUB3Vtey1g8IV6LJHcLn92jMYcfkj9M2YGpXGUCKClA2o+TsK1Ve1RX3z1vuRwOY4MjZ8F3a45wv6nSvFuqRlNbDU1yzI/Mu7RonjEmZss0fg8XKMf/z+RkLkcZlBJh4wnqMTdXjBf6aXn+LWUEULQAT6X+t44+wrXWG6M1pGlZqjsOtaKms4kTMasw3O9IknGf3amGGfvqHCPLOZeozF/fMQPWV/hyFGzPGDNwEwBNYhXGEPCPYHpiuZAKcUTSWUpzn1VBKHB5aWXDDvg7ohzL3S7udqmiDRcpEWrsKNfJKdSdRSZyjqH0PIiL+eeHcoTwfkYLppPWC69JREMfp4zj5mqlJPToTBKq2gPml/dVio224vUd8nih1QNVg9h34JG7Vn/N5Y2exD11WFR/5/FJQF/4KQX5Hqano0wdRGuyHojCbyo4bGPgRqA5cValsBCgrx03i/16zt1fD0/9oFYF0SKWVp1a5W8kmAt7ox0+yg5eLtPLTu82tjWAqGcV+c3vsA2iSXEgzozirvxbfMDz93cNu6fXQzSidIERuTfawOVGv0fly+/Dur9CNLGlsSlP1
 tc6llMaN
 Pb1b+T6TKYa0beMQxK554MYkEKXPmGbS3WKGcaJXUbXhdYQhAOXuRkPFhuxIYvxc9/s6Y8r5uqF7pWUGBw0Lt6DhCPoOKsTN/JW6bfm3F3Q5fs3u1djNfs3PPQp9IGKrWxD9Ysq3lU8kiekaUO34iLQzfheY6GEtvnH99g9nU5h5K43YIl9lp6kNGAHq/Iii5CLF7wwSU/EOk2S6GmgkiXlbUo3WZG7v7uPBe2pR9OKD2OOGi5EKrpEsZPA5v5i0SCikjj3ZeqcW3K3MrW9EfqZGQkwS+XbjuwfQYU0oUwh1xG/lFlYL/UZeVetCkyXS+jpE12rc7nSyD3ZM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.09.25 09:12, Wei Yang wrote:
> When using mm_slot in ksm, there is code snip like:
> 
>       slot = mm_slot_lookup(mm_slots_hash, mm);
>       mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>       if (mm_slot && ..) {
>       }
> 
> The mm_slot_entry() won't return a valid value if slot is NULL
> generally. But currently it works since slot is the first element of
> struct ksm_mm_slot.
> 
> To reduce the ambiguity and make it robust, access mm_slot_entry() when
> slot is !NULL.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Kiryl Shutsemau <kirill@shutemov.name>
> Cc: xu.xin16@zte.com.cn
> 
> ---
> v2:
>    * check on slot before continue
> ---

As discussed, we might want to do some other cleanups in that areas 
(e.g., slot never being NULL?). But this here looks cleaner to me for 
the time being.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


