Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18DAFCCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 19:44:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38AF68E004D; Mon, 13 Oct 2025 15:44:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3625C8E0036; Mon, 13 Oct 2025 15:44:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 251738E004D; Mon, 13 Oct 2025 15:44:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 141FE8E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:44:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7C21646F30
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 19:44:25 +0000 (UTC)
X-FDA: 83994117690.11.9850437
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0EDC640009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 19:44:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BWwILwNw;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760384663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tpmxJccQttw3NZG2ruCVprCfEA+5py1uoFlC30sI2cQ=;
	b=2vLg9qY6xYzAv6a5f6mJGRqvn3N8JFIHXrO9fVqLNtOvnT+vfNEe40m8eE9PYhYU2JjIYu
	98GnfUNE+55NIw2mLKcS8ol1OHRso1IYF9yM4mJeyAxzs+ZXcfpGJ+TUY6sW7VxY3dlbcM
	CSIhpArosTp4zXX5Do1r/rf5mZc3QME=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760384663; a=rsa-sha256;
	cv=none;
	b=g6J3t1QZCMepco57VA43J3cypFIcKWdzDytP6SiuG+1HSbJxycge6Tv5jWImaWV7hGBUNS
	LXIibt5KA4mBCuHKEfpA0MQ5ImY+52Asenw0GKASu7kJr2zsjorj8FxxPBfA0OMCcWZQfK
	Kg17et+KPKai5S0jtqN01kzCbdZ6ytQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BWwILwNw;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760384662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tpmxJccQttw3NZG2ruCVprCfEA+5py1uoFlC30sI2cQ=;
	b=BWwILwNw5lhhmHJOiydbqF9Q2v/prdGSogujE3Ga6OJFrYvThCDDhd/dpb6T9GuRIBmaX8
	NUp5pg3eXwRmAA5rTj5bCvCv5/rDbm3i/O7ocwefZFE4+TTldtRIMWn/ifAZ5wPldH1B7o
	/MsHZUMakf2Yg5rNiF9dx6Fy0JJoI0g=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-539-g0Xplk2RMECx8ToEoXB3Pg-1; Mon, 13 Oct 2025 15:44:18 -0400
X-MC-Unique: g0Xplk2RMECx8ToEoXB3Pg-1
X-Mimecast-MFC-AGG-ID: g0Xplk2RMECx8ToEoXB3Pg_1760384658
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3efe4fcc9ccso4051015f8f.3
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:44:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760384658; x=1760989458;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tpmxJccQttw3NZG2ruCVprCfEA+5py1uoFlC30sI2cQ=;
        b=SwIF3BTbqCLSXsOo1MZTGuRCyQQS4JipZklAPMjxmjU59oHovR3mmoHcQcuVM5HW15
         6ci629G2eTH/OuRjqkXYkvsK5NeRHoVtJ5OH0cP7yT/burkQdJNrqkzpc9RoomFh7RCq
         +6RljhHBBLS+b8s9vr1qThivkqu8hOW5z/bY8UVlIaOotkXL+icVD8e8TWTT8savdmae
         YGDVKZGqlfDQY5X6EJa97HePlHpbunixV/+cDc1x1L7a8A1K2pizaT9/GyuBRBOBeV81
         A82AAxEB1YRNz/IfISBGB16AaW44aTU9Mu+emoRlfNFr9Sih7/U+6zabPjSMMfSHNjIE
         H4cQ==
X-Forwarded-Encrypted: i=1; AJvYcCW69EC8H1Panjj04wgle1kiKIk0owIjnBhsJue99XFK3xgeoz8UgcX9mIuxsaMU/qQ3G7WSK2bvXg==@kvack.org
X-Gm-Message-State: AOJu0YxJqTMD/IAT32CsDikyuf+HK/PrYj0tbvlA62dx5njQcMhoMlJ8
	AnBtmFAfALskEclg26rG3Cf7qHndA/zcNIxw/az1FmWVey6jU9BWJwavAKYq6JoL4h/6MVNd93y
	ClonqXv9uZYkk4BI0Q/l+Zda2uhsl5vIjEjLg3VZTzppQtii7hK3Z
X-Gm-Gg: ASbGnctetYSkxaTxMkiOfvdpVnnynhbtBm3k7qIlsvmpxF/xje3wlG2e2ZiB9LISkAx
	HQt8bYnOExTfL+iM4mrfuxzrOB8W4nC7V4NgNQDdjFhYSaTI8RLDtnJOj5uQFbFkkV5Br5JYIgw
	edmgxMhk4x/g/2RfMHFefQ+rPYsP9Ebj8uYCBBRaEZaxvp+YLouRZ0A44McHsfKfPw1S8wz1wo6
	4YT+Gmbi43O0rYHlKlnDTU/nmn021xFWkvtVtb8LtiXKTV7iQAtW+THgmkvelGFXc8gUTlcmp+L
	q166uzZLTa8OOQSFEAVYgxIeSXnDQ8aj93QwFHCB6RD8Ns9ToYVawqxBWfKbZxnievRqbnc0+CU
	T22Y=
X-Received: by 2002:a05:600c:8b37:b0:46f:b42e:e366 with SMTP id 5b1f17b1804b1-46fbbeb30afmr72148435e9.40.1760384657727;
        Mon, 13 Oct 2025 12:44:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG2DTOVPt4lvXv/lgrRhOALaBYDBqiAKGuJhLuVJZfy236VblOMb7pdACttLqxf3zcWruYTPQ==
X-Received: by 2002:a05:600c:8b37:b0:46f:b42e:e366 with SMTP id 5b1f17b1804b1-46fbbeb30afmr72148245e9.40.1760384657373;
        Mon, 13 Oct 2025 12:44:17 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fc7abca48sm36155805e9.5.2025.10.13.12.44.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 12:44:16 -0700 (PDT)
Message-ID: <2e06ed6a-1674-4eff-94f2-e44ba7de9663@redhat.com>
Date: Mon, 13 Oct 2025 21:44:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] mm: page_alloc: add __split_page()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Muchun Song <muchun.song@linux.dev>
Cc: sidhartha.kumar@oracle.com, jane.chu@oracle.com, Zi Yan <ziy@nvidia.com>,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
References: <20251013133854.2466530-1-wangkefeng.wang@huawei.com>
 <20251013133854.2466530-3-wangkefeng.wang@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251013133854.2466530-3-wangkefeng.wang@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rSciqqeyZV86kjYcTRlhnb-sPOriiotKmya2-lJGXC8_1760384658
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: ez5bjwbsiyo8duwm8fjw8r7nn5yfhssm
X-Rspam-User: 
X-Rspamd-Queue-Id: 0EDC640009
X-HE-Tag: 1760384662-426641
X-HE-Meta: U2FsdGVkX1+38WfFgBIzuTQ2nuAKeOB6zfywLDuUnhpuIpctvJYsW/AWdhpEam4hHp+FPCJwgi+waeFrmTELN856jNSxRZ5cGN2yhyqZpzWP5JFTxN0hcU5iheF3UjLarsE3P/lhfLLPcSKJhTBzqUoAEjoB3N7yotloncMMjAaps3UCBaHBjjbsjVWkNb46VKXWNVy4PLeCu6sZmNBk8MeABO2O92UCJQUk1JOyCOUxeKPqDxSh29mmqJArnoaVgRds+MQIInHbZRszTfBdRn/rw7pAYfEJZ9NMYGXGIXtlkHtaIK8gWta6r/IkxPkBulqRrKYy1/16mcjQesOUJ9fRpf0/7NEmxgDOskSxQx2VdrsyeTyyk2xAXjE6Z8QfT0XcNC2pp3Bw7VLco2Lezcsl/+kYZaGoQJ1BKhvOU2YxwF5K1Mp0nPs5utaNkQxtn6Yisf8ruEjR//z8rnSqhUXqVMZWDv5AsaLMilnDLstkJgX6Ucz0xV+dANFN7NBzFTCRp0Ap+ik6vtp3H2oGxQnfCRceYw0mWzB+luhSjO5Iaz8fwAfX8wCaQcZYgkIIsjqLnR+RDwhhWi/q0NwQxUQ5ONC3aqVvdmbpZxa+3upN089oGGXBSXfJ/IW+MMVRoyb/fSv4QhafaDXtZAMY8XgMF9zp8qa1gcHYnNWUQAtJWEHSeaLTiKJA86EtfyV88NYFclofbKB0CezPEk91HweM8Q8ZMtdmKv5+R4CV1gk45KegbDZTbACZEIcb0igfrW/WzoD03nS5Vm3DB0enS9L1OUh68kRYbZC6CAwE6qwCQl8HpFMXcSZG3OKC5M4IPJYhbNRBiFrPzMGRyrfnu45E/qUYavJNgvW31iJ1BMvTElai2oZqPfi8+0Qx0Ib3mRPwShbbpeC0BKpeR4lyUCrHW/d7WTUqtOYx19NZJpboPA2eYgPLoE2QVQ71gMuq/FS/buUXf6H0XETQ1O9
 pQJ3WZ9f
 Dvyp6ue9POktoy0QqY0y6MBxIJFk1dmUMwID2L1hhoYqKVgOYlsTSlQADxXktdWi70bGLOFyDarNQL0x4S4v19T+xYjIoEjWj1qF2Y846dS5Vc9xUTVTfCch+f4ZZHc4z77jwL1HRN/aWPHrNpKhR2vWr1sQr2xbqhYV8Vd6N/XKSjcg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.10.25 15:38, Kefeng Wang wrote:
> Factor out the splitting of non-compound page from make_alloc_exact()
> and split_page() into a new helper function __split_page().
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>   mm/page_alloc.c | 19 ++++++++++++-------
>   1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 949b01f293d4..646a6c2293f9 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3042,6 +3042,15 @@ void free_unref_folios(struct folio_batch *folios)
>   	folio_batch_reinit(folios);
>   }
>   
> +static void __split_page(struct page *page, unsigned int order)
> +{
> +	VM_BUG_ON_PAGE(PageCompound(page), page);

While at it, make that a WM_WARN_ON_ONCE(). Unfortunately there is no 
_PAGE() variant, maybe there should be one.

With that

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


