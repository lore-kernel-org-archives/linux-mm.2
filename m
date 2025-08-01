Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69A11C87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 12:53:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D37CD6B007B; Fri,  1 Aug 2025 08:53:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE8956B0088; Fri,  1 Aug 2025 08:53:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB0026B008A; Fri,  1 Aug 2025 08:53:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AAEC66B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 08:53:25 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F04E51DC3AF
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 12:53:24 +0000 (UTC)
X-FDA: 83728179528.25.DAF464C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 60A4B40007
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 12:53:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H6Nr6og6;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754052802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h3ruNDNlPjMbrJaLbLdhknmMkmPcPZs8o/QuFn2NwxE=;
	b=7GuPACN+mmNnFiaWudhg7Dh3rgvypFA+tHKF+xJeQdjlLfna0wp+X9zyPlB38wFMcj3mRJ
	xohOhLaldRwkQKWKyGopipquz/mJ7KZl/mpUqk+o6R5QCOq6n+qstcT1+9qOx3+AHgyf0W
	Z2Qx5X/2M/fhAWlpdDua2myHQ5Bmfn0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754052802; a=rsa-sha256;
	cv=none;
	b=xXwLfM6P6I0MmZLwk//9gbXs3IzCNvZIKLUHSFZ7r5tBORmTp/88oLZzv8o+uQviQE3p4T
	dKcCGU9TPzDGwisUtXWNlBk7QdREWtxz034SjNEFLFsEsH9MNWlhv4KG51qDmTq2DsLyDe
	JGGW4S0uWRDX8YKWeAYknk+ImSjEfIM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H6Nr6og6;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754052801;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=h3ruNDNlPjMbrJaLbLdhknmMkmPcPZs8o/QuFn2NwxE=;
	b=H6Nr6og6YmFWQMwJ5gVzWly92bsTpp5UXTmgfl+OTay177QxFKZDygEoT4mxjtukwR4qdc
	oCoDFhH5GevqD+gnDDXryJA+xcuBYJ4sPr0bJxxSgm7ZR7Nyyl7paox+En4WaZOGQ1Cu+Z
	FH0qnSvOXBwREluRjZ1dJizUAJTtSv0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-_A3oegpHNJGfGIAYlirZjQ-1; Fri, 01 Aug 2025 08:53:20 -0400
X-MC-Unique: _A3oegpHNJGfGIAYlirZjQ-1
X-Mimecast-MFC-AGG-ID: _A3oegpHNJGfGIAYlirZjQ_1754052799
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45867ac308dso4572625e9.2
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 05:53:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754052799; x=1754657599;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=h3ruNDNlPjMbrJaLbLdhknmMkmPcPZs8o/QuFn2NwxE=;
        b=g+RHmekPTda0lsHCW/4oCANOeSbKY6T+juICJcF2rXW1rOiZUaiyY3LTvOwnnBBDlo
         M9iR4sHCidk6w31QrgFsEtJVCivRm2bQz01geso2BXO6XApKlKbkQQ2uBVcqKJGHIu0k
         JFOE/eoMlwEz0SyOsNrDQ6elVaw40rjypjtZR8QEfqPM4CiL+BSgm68VEul/prxe/MMa
         xhUVXMCA07hexMXPD4vkmV62h1JOAAdsgZltpWo/lsRHmQOSjZtDXXidNHZJFolI0Hph
         G64pb3kkCGxr/HvFMNHPZt1Bf9FQlMfVMtE4Yb/J+bQIJVvbYjMG5phRLcwXMENg+u6d
         q4Gg==
X-Forwarded-Encrypted: i=1; AJvYcCWqI2pcgDRhuJaozfFhGDGDFKBk4bc7hOAno1+rt1gxivaieW1l5spTuvFPLdWIdMvNCN5W3/hlEA==@kvack.org
X-Gm-Message-State: AOJu0YxIGj4aIJpRk099nKEKrje2GoTsnAMhPS5QZxRN3XoDuTuuc9F3
	YxZEU03y5VuODYL6iryLbYEJSVpp432aUcQxG62ol+XcDpfwdwtduPKF/kzqR4qJPyvEBPFKNzi
	q8sGIs/kjQXTMPQTjuBehMtzJyi4B3+A1fDF1bUDG7kYt8QzX+Siw
X-Gm-Gg: ASbGnctZdeGBvX+lF45uTo4UPk3/ywYv/MWsS2PXKz9CVlKW0c4lPE9hHZ3NbsjWClp
	pkAbdLKC5ClGjCo3bYs1F7B5OJQXF644p2xK63v6Ym/6z5C+ja0xc3LSpia97rgEsqIqTBgRg4r
	54pSvdTqYKlVOHiZFyVSQjm+s1WM7pt8cSToDqxQvrbOO1ctZJWlTnYEMrrFL9G/Xe0uqiaurWp
	5uoU07Nj6M391SvnDQLLlnN33qosdxvIq8WM2f0ZZS7s2+T/iVbeA4dotoBdzFWiHgDyk1a3+o7
	BG69ooHv/cbilsttKN5dMND2O9jlbShjRPza4egUPSftONPNlbjufVL4J1Z8pAaymuxcyNsICgE
	RYPmjfZBkuXtjc+8y9M7ECHw/vPbKVxIcId6fcTcEsInjtAkyJmUQiNJQk62LBqxU
X-Received: by 2002:a05:600c:8b6e:b0:456:27a4:50ad with SMTP id 5b1f17b1804b1-45892be4bf9mr87196845e9.33.1754052799309;
        Fri, 01 Aug 2025 05:53:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFdOjdW1qaq63aXhEjK0A1+Z+TR4so0aHNv+en625bxoCoFF4KP1QmdOz4NRJh+MBuuVmlFrA==
X-Received: by 2002:a05:600c:8b6e:b0:456:27a4:50ad with SMTP id 5b1f17b1804b1-45892be4bf9mr87196295e9.33.1754052798771;
        Fri, 01 Aug 2025 05:53:18 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:7500:5f99:9633:990e:138? (p200300d82f2075005f999633990e0138.dip0.t-ipconnect.de. [2003:d8:2f20:7500:5f99:9633:990e:138])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458a99ce1d2sm26772525e9.23.2025.08.01.05.53.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Aug 2025 05:53:17 -0700 (PDT)
Message-ID: <8ba84519-7e69-4058-9ac1-d3e2e622a6ab@redhat.com>
Date: Fri, 1 Aug 2025 14:53:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] selftests: prctl: introduce tests for disabling
 THPs completely
To: Usama Arif <usamaarif642@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
 Arnd Bergmann <arnd@arndb.de>, sj@kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com
References: <20250731122825.2102184-1-usamaarif642@gmail.com>
 <20250731122825.2102184-5-usamaarif642@gmail.com>
 <7b13d8b5-a534-47f8-b6c5-09a65bffc691@redhat.com>
 <22e263a3-a1d2-4159-b3c8-44f7a29bace9@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <22e263a3-a1d2-4159-b3c8-44f7a29bace9@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vv2ngLdnRulDFy50K5-HL1_AOchJ0RXnlMbdTic9qSA_1754052799
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: e19zmkkpymwcwrpuju4xoytud9p4rk3b
X-Rspamd-Queue-Id: 60A4B40007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754052802-700363
X-HE-Meta: U2FsdGVkX19v0ZgFDm0kdc8E+VSwAxYgfIeGlcgVa+RJPpFZzeoWA+VNY6S9lj6HHWnklOh9xmLMSVKfOXpeyhdp+sD8kXvwBGMyENuRKkeRSW3420pvczHnqm2mYqTAMI7ALd+d4iPMho2iLtWuLjD8Gxg5rEdeJN9JJehehF4km6//NTerd/y662nW2WpWYeMEeUnMRIyE5pqBek937fSnLFxCuP1Jr2+BmkVekrrt+50g2uhW5zkXb3E/gTdfswpeuWOZMQ+0LTUn49EMytuu/8LAAfNY8AQzPqEojk/fsSwFE395OBPzLozHUeOAtY2neeFbJoaoGjNEkx86lQO0GSgXSrzXveXgh9EF5xNRkA7ei3lDbft45au207sAiTN9Mbmvbm75lg80fWgQumgXQO7PmWS8z2WUK0RSDrs1qvzgdytVk10JTRi1pimQ3Z5yPIkDces6eCD+bYBeeo7tDMhfAFe+ZaLhs73XDtAlwR1O6M32U3a7MQEPtfid9YJraIs6EE6S3FwgaBNTALS91Myfscs1BN5oUwkQguGuum0I8OzTNciWHYT1qO/gkwGx4uaBzWgDzMBHVWCdf1jjjBDxXG7pE0DajV7sOf62vZhb3+bg9LiHIalmdoOR4GR7IO97/7IadQDuUqVeAaLoHQ7hcbmq613B6PRzYSRDGDugi99hIQ93Uc9GsKv+jlCy535/69Lmnn/Wql22ZfEgAwzHjxwM3HmeJap68RSAdR4sMbMvhAfDScDLx38X14Y5D9GxP75qVHWhzKnI38fa89g0aW2nBTpSZA1cPJIniZ43cN0oRK+qdRPO2yyNhIV5RRsCcIB5hT5BPX6YgVuQMYbjc2cHW9G3fFEL59pxRp1wltLyTWs9YoW+rky2FqQNlYyR9+TSjbjK56mgiVcpBvagLr3a35OVmkn7Bg1owO6VA3SbrS3dkmwDNdvfzraRrcEccQvS/syEt5J
 oq4ltHdK
 Q5OkPiTjsQvK35ATYALNn4IXcTMpwInRti0TYettRlbx2OASM/ejGANPSZbCikcbn+Ytz9PMudIIUh+CSyVS0g2gOoO/pOiRf8/wmLzDxkYiR9tJ90CSprwlsdXUCPQquEjvVfTtEbB3PTlSoT7CZXWCF6lnGfT2vepiUxfesHZkgKHGNuRYtd2EPs6q/GRrWOHC0Y5vzgj12+kNe7f/vyFWw/6QnaJyXjzwALtdRVNdQ9UBXIBTrQp33G21wz9U2MG5gLdKrOrCcihShI/49JYg4Fxs4rL8zHgBp1uJGEaYxC15F51sTUJdap81k6twwUNhzEmFC642fbEdTQmIiOcyZqIxZe5+A0RmuiSZmBC++K9XfXKI+bq7jlLLMN5b/9yu/MHDRlQ/Cta8ClN72SUmdXc2QkKLEoYmBYeYqTxScalmoLMkuzRwDtAbZIehadFiRLu7Tc8+ptBkGCh0v/HlS9+kqCm6Wc3Q2w75HfZnRGxDYkoUz6cPO9hAZnN5SpwBduAL9KZT9llYrqvwsIZe0QjAowbShv+6dQ3XfZndJve82BiUIJbcj5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>> +
>>> +struct test_results {
>>> +    int prctl_get_thp_disable;
>>
>> The result is always one, does that here make sense?
> 
> Its 3 in the next patch for PR_THP_DISABLE_EXCEPT_ADVISED :)
> 
> I will remove this struct, but I think maybe it might have been a good idea to squash this
> with the next patch to show why the struct was useful.

I think it's reasonable to keep them separate.

> 
>>
>>> +    int prctl_applied_collapse_none;
>>
>> "prctl_applied" is a bit confusing. And most of these always have the same value.
>>
>> Can't we special case the remaining two cases on the current policy and avoid this struct compeltely?
>>
> 
> The values are different in the next patch when PR_THP_DISABLE_EXCEPT_ADVISED is used.
> 
> Just to explain how I came about using this struct test_results (though it doesnt matter as
> I will remove it for the next revision):
> I wanted to maximise code reuse and only wanted to have one instance of prctl_thp_disable_test.
> I actually started with special casing, but went the brute force way of adding too many if else
> statements and it was looking quite messy after I added the tests for PR_THP_DISABLE_EXCEPT_ADVISED.
> I saw this struct test_results in another kselftest and thought this should make it much better and
> extendable.
> 
> I have removed struct test_results and changed prctl_thp_disable_test to the following for next revision:

Yeah, or just duplicate that function and call it 
prctl_thp_disable_unless_advised_test() in the next patch.

Makes the code easier to read and the duplication is limited.

-- 
Cheers,

David / dhildenb


