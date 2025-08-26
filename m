Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECE28CA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 13:08:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 248C76B0148; Tue, 26 Aug 2025 09:08:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FA5B6B0149; Tue, 26 Aug 2025 09:08:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09A606B014A; Tue, 26 Aug 2025 09:08:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E549F6B0148
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:08:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7A3791407B3
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:08:17 +0000 (UTC)
X-FDA: 83818937034.23.E19335A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id EA96E80010
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:08:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DcyAQm9N;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756213695; a=rsa-sha256;
	cv=none;
	b=kmv2rNPZ7gLXBkkyiJo9xwmLiEc6Wim1/uF2v7+NmrELqZEe1CTZPf0PY9IzA6Hcb+wWjo
	jqG1F2Vsk8tVW2/CDgVCaqtrONnxMK+G1/O5MX56k1P3a8ByukscPdpqqZZYGJ+aMoVJ/N
	5CgamVx2ijRLiwgLJ49mHgcWyAOGjwU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DcyAQm9N;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756213695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+33Ue2Cu5Y5oxJByCwLn3TsnRWViKb51w/F+XvIasfg=;
	b=v0lbmZZ/2Gfypd0Goqh8r+WDtGkzVmDcCO2IPqWmjnIzhVZH9Z9pxduEWHTggGHGcKG9tX
	neEgCvcwrdcFugnYBPsHz79Ntu+IPFDTky8JkkIH0EvqYXWMh4cPXRlYa/Yzbv9ne242DB
	OHgj4dOz2snUKqOAjOsoKDuTuagAxHs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756213694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+33Ue2Cu5Y5oxJByCwLn3TsnRWViKb51w/F+XvIasfg=;
	b=DcyAQm9NeNX0gNflVUjQyILC7pOSj8BOQuPJkoc9Ws5tkI4pIyooy809jkrmo/dtSfvM0u
	hfeTmrpUGOhtQW9NHApP4OmOlmgQVVx3j5nklKh0erN9odZL3Y8P3mYu2mSgxKFENZBUi4
	RKRvrldVHpFiQsfFXa2rkx/Re4Oy2Ro=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-hGbKcFpBMxqeQLQOH3ncuw-1; Tue, 26 Aug 2025 09:08:13 -0400
X-MC-Unique: hGbKcFpBMxqeQLQOH3ncuw-1
X-Mimecast-MFC-AGG-ID: hGbKcFpBMxqeQLQOH3ncuw_1756213692
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b612dbc28so13620035e9.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 06:08:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756213692; x=1756818492;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+33Ue2Cu5Y5oxJByCwLn3TsnRWViKb51w/F+XvIasfg=;
        b=MuWxYH5Ksmjn07sc9VhBMtlvqNg7jfDNV3CBNxvBUsT18KwLBX+AGodId9jNxLQLNP
         +4EgmzB0AbtqhsaRRJgNrpRKaC1zPqGnW6UuN7CD6l916jBDbDILhfDH5vwpbpGDa83z
         UR2bisGznghNVipUifvAjf8r/tH/HyNFsYQgBgIp5/4Ri0r387iEb1BUph738APcrc34
         ft1mS489ptlLw2pukzCJPjTg99FisqfDU8kbSldvXKlActaZPHL08UkogLi8h07Mv2MJ
         CcaoroPUJOBno1CNsyX2fzId1cDeNYqnJuRq1IzAYJzFUFUVphnJG204zwzfnE3dFnky
         5dUw==
X-Forwarded-Encrypted: i=1; AJvYcCU5/iGlARM6K1F9gmqGyx+w1Vw2MSSsgw9G4WaTWtdOIfHBSxOZ8ksk7sx5g7Me6ItLx/pSaLhlkA==@kvack.org
X-Gm-Message-State: AOJu0YyNEBo0fO2inV1sxUUpdCq9sTPiobUYQIJzWjh29a4DzlIuyLDI
	CUm6X8hxRpxFTMvfpERWT3dfZJqVVrVPVSdWy8qpMMagBwVymjz8OCEZ42RnlDqJ0RgGmVorDbs
	LNT0dUZqeIeLQSRtsc4sZi5Rd0QZOBIl1mLiXNd7MvrRqUBJGs+NC
X-Gm-Gg: ASbGncs9+AMgAtZT/1xk0Se4T46ElLyzwHgjeQDI8Xqfa+7scrUkXNqfv+g16RCEssJ
	RSDm0DY5/zcG3GiYo1gnaL/QZqms+ioaIm5B8hU9+7l5s5XGRdVNMSYVXB/WzK0oS0lLCGqyJg1
	E1tvj1ckLczVcvZK2tKuTq3wIG//yBAYMvaXkuh8QWZ3QGTYmqzImF56kkf0NjCcgmI7Cr/Kyit
	ygGkzh7q5i5U/06deOLRULfha9LI6gaBtXrDOD0rUY+0flkL3qQl8Qgoahz+mRimGqfVoHgsv5k
	qemEo2Q+2bHigzI4+Ds9N22YWa6hB4/2tSU7a8quufgrlEV8NIY1Vo9c2KN6z8rEkTUMru8Itg=
	=
X-Received: by 2002:a05:600c:19cb:b0:458:6733:fb5c with SMTP id 5b1f17b1804b1-45b517d2751mr126238475e9.28.1756213691624;
        Tue, 26 Aug 2025 06:08:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0uVvd3bkBu8Q9HfrtdCgTiP652NIGyMgKGC7lB/H2NXiQPCgnz3LGDq701BEdJbsSh2Pm8g==
X-Received: by 2002:a05:600c:19cb:b0:458:6733:fb5c with SMTP id 5b1f17b1804b1-45b517d2751mr126238015e9.28.1756213691060;
        Tue, 26 Aug 2025 06:08:11 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b57444963sm165603375e9.3.2025.08.26.06.08.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 06:08:10 -0700 (PDT)
Message-ID: <ecc599ee-4175-4356-ab66-1d76a75f44f7@redhat.com>
Date: Tue, 26 Aug 2025 15:08:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 21/35] mm/cma: refuse handing out non-contiguous page
 ranges
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev,
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org,
 Zi Yan <ziy@nvidia.com>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-22-david@redhat.com> <aK2QZnzS1ErHK5tP@raptor>
 <ad521f4f-47aa-4728-916f-3704bf01f770@redhat.com> <aK2wlGYvCaFQXzBm@raptor>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aK2wlGYvCaFQXzBm@raptor>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fvYTdahga0O2C-3bNDwTB96nkpnbEuPB4QuXMHo4VJM_1756213692
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EA96E80010
X-Stat-Signature: irg5jy1jpzgy6g411e7pxygzcdyodyqz
X-Rspam-User: 
X-HE-Tag: 1756213694-196271
X-HE-Meta: U2FsdGVkX1+sMBaIDXSYbmLZVyyyxQnMQXKjRPM1Laz2rGumCCXxOIBBdYpsxUXR4gRwocqhPQF+i3ZvAgyECG3WOvuELbkPMCjYy9+hU1dqrl+IlQLW/RQC1yUX/9Aa9qZQ0HPCfh0z9Mz/pVvTaiAFrfrRB8x/hUGUQZHnHVVnzhpa8qZFYvN69V5YOJSxUbfw/hOnckV3aXSOKV3hcUbF1/ht+MSFmLLEIX0lJAAIbFzcgT+rg2N9H83k+6MOeNsWpZHCoZsQEgU0m6vcnBBqMAtd7DG0/5Fjy4oFgO3+ZrIgqz8brP/HiMRg0at0nGzoDqOkvZl6HEw1G69LrtyC+ALXuCirNpLgNbuq3kcAvBwjAIyxMEX4CWUaqC3GazsZy+wxgkfZzXFMr2QQmDZZMTFthnotFmZU89zrfulGrFROMCUO+fkU/nhPkwAvJuKJCy0XnFw6nNl3vO/QnJyvzUUTrK5EzsZR16fgRiF+M6M2xLpTSR05F52oI2VefPV+VUVHBFrFuXLLahdJs7B1klxhnWWmRw83hBW4oNG9iGfDTeTygc7P+ctu+Hccu4O5ReP9bwGahKZCe+L9kjv6QJv6hWkH3P8tthnT6usKvfXHPVkkWPzsQTBjb3BaOuYN7YbJkoyCodoHgN9ZWoprvmWTKE9XrhUgusYdCuSwTbfeIcKzKguQoxaPtL+7dofucCw6+m8HOhZXzYmIJIQziSp1mHD4lSzrCzjoAo5H9DT5qQJYc+htX4bR/QmVMG3vS4cfpy9y61RRiQ24aU7YhuPmOIYzz76ox9SoIgllAkHK6yGpgmlderwfxabya+QUo5IFe8SA/uVvSRQQZzRf4wTSdOxE3wNXUvPy2Cn95NvQjMvIihS+J1d6osR+xpPaJRB574c0SmQCuNpJ2qUcvn5lDICF5Llg9jlW89y8iei6mbYB9kXih30TvxVfcHEEnGTCUGHvRT4AqR3
 rK6obvJk
 +mZJgdhgQaR88MSKFXGeBEq6TK3XF6iUXAu4b5eYyzdAst8ChN4zPe9I5RNmlSU/4sCkNKI3QdENbt2p/FfDAWSQQfwuujToqCmnd176CzknqYqAH3dI7n4KwbOrqP4FKlWCJwHgF3u0iBaG8RwWrC7DX/nYNiV9+q58s3k0kk3BmaOsScTrvRtlRUuf6ytr0sCXtK+5zIbLcXflPnfnGnSvTguDcdHeecp+aMZzTZLNyOGg8f94vFLxMMK95iE24iprjXXGYCHpmn5q3jTN9w7jFYaZnwshbSjAvvqpkm077sJiRLJDWViJu1GyZhgMwUR0H+oEu7CHJryJTkdW426KkpvMqSzHOLFJWVBuo95LJ5K1KA4JM4c0VKr478Ko3g2DIUifcLoIOVVykY2aW7haR2T4TvTVJCInRipT2YV6ShHUxjdqCoQbC7ZjsGXj9+1rzOxf4lCYaqPlgBKM8vdLY3J9auuB+aYZq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26.08.25 15:03, Alexandru Elisei wrote:
> Hi David,
> 
> On Tue, Aug 26, 2025 at 01:04:33PM +0200, David Hildenbrand wrote:
> ..
>>> Just so I can better understand the problem being fixed, I guess you can have
>>> two consecutive pfns with non-consecutive associated struct page if you have two
>>> adjacent memory sections spanning the same physical memory region, is that
>>> correct?
>>
>> Exactly. Essentially on SPARSEMEM without SPARSEMEM_VMEMMAP it is not
>> guaranteed that
>>
>> 	pfn_to_page(pfn + 1) == pfn_to_page(pfn) + 1
>>
>> when we cross memory section boundaries.
>>
>> It can be the case for early boot memory if we allocated consecutive areas
>> from memblock when allocating the memmap (struct pages) per memory section,
>> but it's not guaranteed.
> 
> Thank you for the explanation, but I'm a bit confused by the last paragraph. I
> think what you're saying is that we can also have the reverse problem, where
> consecutive struct page * represent non-consecutive pfns, because memmap
> allocations happened to return consecutive virtual addresses, is that right?

Exactly, that's something we have to deal with elsewhere [1]. For this 
code, it's not a problem because we always allocate a contiguous PFN range.

> 
> If that's correct, I don't think that's the case for CMA, which deals out
> contiguous physical memory. Or were you just trying to explain the other side of
> the problem, and I'm just overthinking it?

The latter :)

[1] https://lkml.kernel.org/r/20250814064714.56485-2-lizhe.67@bytedance.com

-- 
Cheers

David / dhildenb


