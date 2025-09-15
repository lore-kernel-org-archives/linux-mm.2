Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0E30CAC58F
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 08:10:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ABB78E0003; Mon, 15 Sep 2025 04:10:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 483E58E0001; Mon, 15 Sep 2025 04:10:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 372B48E0003; Mon, 15 Sep 2025 04:10:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 170D88E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 04:10:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 82777C04F6
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:10:48 +0000 (UTC)
X-FDA: 83890763376.25.3A13D5E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4E2D6C000B
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:10:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fBpMrNP+;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757923846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KhuFMOmEPvdK2NhBlkWJP8nYDemufCbzLTzEFla3lLY=;
	b=A5/OSubCeDudqjOuMT6ga8dMJcE0CAGmqKAws0t1lzkc/WavJf7WuF7KFYfRiUVwygHIXx
	3Ao0AktO9CDZVHauKxkaE40rLZYFK4xc6iWjF5s1vEKXbLbEUuMuYdT7hIvzYtSFNWifR6
	HpXgXBdxoGp8lKcuCCuUs+iul8rJRtc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fBpMrNP+;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757923846; a=rsa-sha256;
	cv=none;
	b=pRcUbtGNGJ5+ZVt47Cxr5G9QmFLm3POXu6KGoAOUT7IKi6dLNg3X+VuEXH6pP5HDX9Dp/y
	TAenq/wbVm0eW4n11kKkbGLt+toBmCJa4fi6xBT0vXmJWfLQ7tCZ9cJagLwgFA9pNgqUPk
	jYk5CXXSakYQf5eoYWjeZmPxS2UQEVA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757923844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KhuFMOmEPvdK2NhBlkWJP8nYDemufCbzLTzEFla3lLY=;
	b=fBpMrNP++bczR1vLpj0edJklqx+WSLw3QGZjwQCNBcdVbbFL7JzJtZrsnu9YRC4F6uQkFo
	aXsU5geB8cPp0eE6jajkWKYGnjJRGzDGIf9H18QWPkD5kl6dmbxEWP34PDUFXMLM/Fagyi
	j4xqoHwsT7sUnfoqED8wtMayeSgw320=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-247-Dyj6_OaYP0eE7KxEJcjIQQ-1; Mon, 15 Sep 2025 04:10:41 -0400
X-MC-Unique: Dyj6_OaYP0eE7KxEJcjIQQ-1
X-Mimecast-MFC-AGG-ID: Dyj6_OaYP0eE7KxEJcjIQQ_1757923840
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3dabec38299so2168502f8f.2
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:10:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757923840; x=1758528640;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KhuFMOmEPvdK2NhBlkWJP8nYDemufCbzLTzEFla3lLY=;
        b=ogSBcFxXemL6v8xgKpfH9jrIwokdma4i/qGFOLmelWCf+ZQtruBAV+iLUYkNwi0w1G
         pLeH2wr5YnT0ARW7z7jGpCiTLE1JxgzjsG6HVrSXAzIeCL1wTm9Qogz+yDP501+szI5z
         YueD6WNN2h0t080R89wS4VlaCJ/CCJ8ule4GylakXqaDWg2rH4r6BJ3FmtQ8sUU5m9Td
         M26VrzQim8ood1pqrAG6fTAs3aUk2/tP/yeHSly3D8aKVFKsq6k7w/v3tLCx5YLSGJ6I
         fRyxRnOXQJtcedvqHjweujgCMma+I0VmmUHLmqi+RgsnZYYzFGrru2oqsqzx6lr7G1Qr
         AMeA==
X-Forwarded-Encrypted: i=1; AJvYcCVLQEtrIuhdbYNrNJR+wcRjpmfgD+bIzc9hBGy8zXgMBMoZrkPlaQXlOdT6t/OjL0X2AANlHMMrZw==@kvack.org
X-Gm-Message-State: AOJu0Ywe9hYI/9ta0jvY+hurRSAeWTrLL+lztV+5VZb57Z1I8mLiDEU3
	Np5uZTOvMrI7mTVLCrUd/+bn1B62ogmK9CoUpv5azOjMd0Rx4DllhWiY58r5WvYP73UO3DZJnuH
	VcmHuYH0XU7aWFGUalEYhNZV8AsdPiSf+a80MrdU3ZrMWN1iTxxcH
X-Gm-Gg: ASbGncuY+te8oWyycH5dyW0PFkA0xSZurRkJKM+yNQ6gA2S4gVayxpB+HQ4hUhcGdEQ
	mZZXXr4Ra9+ocii0jT5piIvANZEsDFkPiz18XLAkjW5f7P0GVCdKAkJCl+jVk4YObATlETNuHCo
	cvXX8y0m2veWJi85LBK7AzagP1OR6Tet9yQHhYwsJbyuEzch0S4hyT1oqr0US1XMjyQnU5jTz2E
	Uzh+FHRDra3lUFVlsEDg+UHff6uMiBTQL1Cb/qXEl66HrPCozBIHbpB3XT/KXdeUKUcl+ErgJP6
	qHLLQmilItpL8OAgGV1xxT/w38P/8OAPQVyiz6a9ir2KDN3k6EfJC2Hoa4Ae7adG2TmcIZ3RjK7
	/w4P0I8Z5xEwePRu6ByRaA6TtRmvfF6gqzRH7NS0HlcnXb6U3gX/Npvh5h1De6aB0t7I=
X-Received: by 2002:a05:6000:4201:b0:3df:d8ea:1f7b with SMTP id ffacd0b85a97d-3e765a1a390mr9676795f8f.51.1757923839612;
        Mon, 15 Sep 2025 01:10:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGp6oIXo1DUhThKGGzGXbobDlfNMu7CwZvQ1iFxxb8VHtiveWuBMx+EZLBiC4LIDIMu8y5MYw==
X-Received: by 2002:a05:6000:4201:b0:3df:d8ea:1f7b with SMTP id ffacd0b85a97d-3e765a1a390mr9676762f8f.51.1757923839149;
        Mon, 15 Sep 2025 01:10:39 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd? (p200300d82f18f900e0ae65d58bf88cfd.dip0.t-ipconnect.de. [2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3eb9a95d225sm868315f8f.54.2025.09.15.01.10.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 01:10:38 -0700 (PDT)
Message-ID: <4de00290-7c29-42f5-b8aa-58a77b17c1d5@redhat.com>
Date: Mon, 15 Sep 2025 10:10:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v5 02/15] mm/huge_memory: add device-private THP support to PMD
 operations
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: damon@lists.linux.dev, dri-devel@lists.freedesktop.org,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250908000448.180088-1-balbirs@nvidia.com>
 <20250908000448.180088-3-balbirs@nvidia.com>
 <17e3c19e-0719-4643-8db8-cf8c5b5aa022@redhat.com>
 <49776f0a-d891-40be-bce3-c2b1f16bd825@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <49776f0a-d891-40be-bce3-c2b1f16bd825@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VmDCk2joLeRprDfIkxqqNpVZMTlRxG4qjSTnhjXBpc4_1757923840
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4E2D6C000B
X-Stat-Signature: chmnquhk5ue8gf3ya6hkmh95477z6mcr
X-HE-Tag: 1757923845-576149
X-HE-Meta: U2FsdGVkX19kWR678zqtcvpH/02LnouRrnEV4+cOrsjFzV1wAJlMwtQG8J412VrmQuHU0kW60erU7GNkjeM+E3/vosrqLG4EMz6V3y+ilOqI2Hg7xGwQPj3dwkF/36owUe1RoBesesuBRJKwzFvqfi8yDx0k70biU5FjHlzJGChFQbGZ/6qFXcOOfOLf4TjGEz6Niz9O9jtWDjjfIgkjVmblcLEAdNtE/qHnlWQGKMsxqwYjFuqCqXqgvtLoPnDA5dDiEl6J8Zcg3Q4IwKjyPhIhfzaXmSSfkFEaP54pymskmqEwpwz2I2GRw5PdlY5anlGmU6/EB6t7/RGOORgK17r/zWlULT17diPgQ7yT3InBLnskfS3+4Qqsg+WQvVM8MsUpHmhPTnnQg01HXx9NpDsYQNv9d8/o3HNi61yy4yE0QE2mEEYL8k9vYrapBJv5iA6/Z2YsYpRsfIqKbNJu4In/RVW7HH7GM2gYvuaRg3bqwys1Z7ZFeNjxq3GHYGnNLs2K3c7bUQh1b4sWgV+uQNkPqjJaP2CozD2w5QRiranxnOGCD6SXjz94o++wmZtnWAkT8o1m2o6xqzTKV8CJgOf8fEsB0d/xZzonzSylt4Ey0btfnwkPEqsbgKASy/DzhSl9R1k5MkfiMXQgfyt4233OFnbn8/bsVnJVl8v50Oj+/afHuwdhkH+x8zMCAOZQkl+c1bTQfLPvH9jx/ljP6udR6yMr3Bj0ZsiCYitLkWAEL9BonJ43I4K0RnsmNiTDiadleO+MgYWoPB53c6fqaUO04x5sPmMgJxcQ9JMvT2yVJgsQSXU+2BawQFF+yimiFF7PF4oQMwx9YYLw46Ez1bnKj3jIwZ1Aya+4+QmzgKvK52t+xJVKF0aDR92ise6W2Y40cva69/VPJaoQ7Sv/pxpiMs09Dhg3/eP6iA0e9yiT2L1g/78uo8cnCp1aOjROYwQBeRNr7JsazP/ZYGg
 JhcWlICq
 EpiqsM5sIj1ed+KSTUxNHQMZRblx7VkxG5aroIk9lqA1k7XjyqwB7ZnXfunMcLq6XSjv2pBQuglkjuFOzBsQSydRO61MgG+KPwfoqpvUkdKcJ201FXgUo6Zemk4XesF32CBTokwY0VWhQClyEVjyy2GsMOuk8HSYizAzNsKDdzjR0BTubGxAtbQsPJN9Jh2hXI7nHpnFsmR0P/OTsLSe4/j8yvvIiCXAwh8d/RoeP8LVGNgb6lbhQh3D4FaM26CRwqBUUI0tAzCVklHQSgRHg0BLSAPksLKLnTMiD7sQCm65ouIK78VaoBYeS4MGpLKpY+dpb35AI7P5c+g3x13ZKZgWKbTcPE2FjaI045tdIhhEJkSVfV6R+GihlHoWlash1vE3ILecCvbQL1w0eLw7WaOtr6jyiN+4bqE5Jq/2AFAOr16VIysTv/ndpTGJmbrxJv41rSlFGg/ol+931cD9+fqIE2cZRkDDuuAddiwlyA3sCiA8O/EPmPB+fCERhVC8kvWv2znddCJoy8n+3Am3qHgQxhcHjzJshLTNaWTQNsxtQG73JrAzOOKcoi1IE+FsuCVZ1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>> +
>>
>> Wrong indentation.
> 
> checkpatch.pl did not complain, what I see is
> 
> +		VM_WARN_ON(!is_pmd_migration_entry(pmd) &&
> +				!is_pmd_device_private_entry(pmd));
> 

David complains :)

> It looks different in your reply (is your email converting tabs to space?
> did you want me to align the conditions?

Indeed, looks wrong, not sure why. Likely I messed it up.

> 
> +		VM_WARN_ON(!is_pmd_migration_entry(pmd) &&
> +			   !is_pmd_device_private_entry(pmd));
> 
> 

Exactly.

> 
>>
>>> +        if (is_migration_entry(entry) &&
>>> +            !is_readable_migration_entry(entry)) {
>>
>> Dito.
>>
> 
> Same as above :)
> 
> 
>> Wonder if we want to be more explicit.
>>
>> if (is_readable_migration_entry(enrty) ||
>>      is_readable_exclusive_migration_entry)) {
>>
> 
> !is_readable_migration_entry => writable entry or read exclusive, did you mean is_writable_migration_entry()
> above?

Yes, sorry, my brain was dizzy after all the review lately.

if (is_writable_migration_entry(enrty) ||
     is_readable_exclusive_migration_entry))

[...]

>>
>> Couldn't we do here
>>
>> if (!pmd_present(pmdval))
>>      goto nomap;
>>
>> To replace the original pmd_none() .. check.
>>
>> A page table must always be present IIRC.
>>
> 
> I am not sure about the pmd_none(), a page table may not be present, I've not audited
> the callers. But I think we can do

IIRC page tables must always have the present bit set. So we can just 
simplify to the single pmd_present() check.

-- 
Cheers

David / dhildenb


