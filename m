Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC94BCA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 14:42:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 315696B0005; Fri, 29 Aug 2025 10:42:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ECE46B000D; Fri, 29 Aug 2025 10:42:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DBFC6B0022; Fri, 29 Aug 2025 10:42:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C6346B0005
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 10:42:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BE2AE1DE69B
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 14:42:40 +0000 (UTC)
X-FDA: 83830061280.09.16CF74C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id ABD291C0007
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 14:42:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=abhe8uRZ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756478558; a=rsa-sha256;
	cv=none;
	b=LX+NdpWzRLg+YE1Nl7pj3KbVAtzOmhw7ePytR3MGHApijYhdTHFK4nfQ4oBMcvTSPBBU53
	XPou+Z68sIuIC+v0r7QM3G380cJp+9o+8OGVFyIHgmW0OmMbIAOoOXCEHnbKLaaJcGeErA
	0z72wqhA4FdOM2P02jkP7vYKg/hUT6o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=abhe8uRZ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756478558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ReHesm1JzI77Ttn1crqpxEHfJBy9ITN9OqG2sWgOwWM=;
	b=Kt1pls+WY5A+qoj+bXxURBNaXhVGZiegVfgAe0Y65c/RvjX/rD0WwS1Xp+WOcUZ8Rk/sAO
	kwA/gylFiG99FkSyJt1NDeSkJbL/Ui4ZI0phL5X3O6S2GxMY/6+V2iVLI73j6ULb5OVbYf
	zDnIQbJaF6NDrs+D5zvxPAKDUgFY/rI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756478557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ReHesm1JzI77Ttn1crqpxEHfJBy9ITN9OqG2sWgOwWM=;
	b=abhe8uRZx1YEbjTqtSpLQY84uxrnhQU2GURENE8xWJPyi5o4AiKha9GjKPUgEvB5tT+fa6
	Bc5bdYIMFUPbOyVmZZR51hIP0JLCcVJXRC2ag4EZXxtAm7Jb4ducwTo9mUyQSoLKElfEVr
	DRB9PDNrJhEtBOwaEPENeGV9ImUaxtU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-113-45NZuplEO6qaw1nw44wXwQ-1; Fri, 29 Aug 2025 10:42:34 -0400
X-MC-Unique: 45NZuplEO6qaw1nw44wXwQ-1
X-Mimecast-MFC-AGG-ID: 45NZuplEO6qaw1nw44wXwQ_1756478554
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b7d84d8a0so4841865e9.1
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:42:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756478553; x=1757083353;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ReHesm1JzI77Ttn1crqpxEHfJBy9ITN9OqG2sWgOwWM=;
        b=hUJ71caWqTt518RHR3gyk+qvg0214rA3+Oo/BJZUMzVIxwi+nzugydlCI4LjDQ7IMf
         P4n+AxBOZYkdkUdHQpE2bWkEycxpaik3HfsVbYtlghhUHeFZ8byZIdVkZDoYedx0jvxl
         KgLQm5TfDRGwYOJcDWem6RSkTYWiNEb6D669okbGNMrzEAi5MJZX7leZVOlxjLekf601
         bg7SU7sObGiabbZMCHnGKNyB3J7DtpeWFEYFy/zn7e2g3Y+3eKwwycRSzpZwHmBGLh5t
         VdC86aOiUeIq/vx000ihqoJ5ZmWX7EVuWPu+6HggbGepFzwJPdSnjLBMHnTQkbhJHhco
         wmuw==
X-Forwarded-Encrypted: i=1; AJvYcCWl+51U38TAf9IFmimmPF415PbysejpcFuwr5d8L1+TMbDur5Yu7M+ovesiINfNZiHZ2PBmoAG/sQ==@kvack.org
X-Gm-Message-State: AOJu0YzhrjNIS0s6E9QSxMxKNnn5rkmJaC5nsJYKSV9xY69UE7jtuvtP
	+zC7sCITUnQxZ0hdnTeqmSvU1npKrUlcnL4JjyV/Xs7mgJQfFG3kg7ikL3Ih9ZdjFmWaH349c4o
	z6RRaCZzgPjazbmzkw4s+8JjwRKPcxmXT4ZN3hiWzEB7inhsKmAmY
X-Gm-Gg: ASbGncstjGE6i3Oh0zaLBk0oueRCX56AoGZ0IAfpdSSRAPirwlQFsS6jENW1SiqtS5T
	TxA3kqXdhuptcQCRqpN8+DoQU9o7/LdC1KDC+FGLDWe2y+lLlttOVRDkNGlQQsmsH17z/JF8vyQ
	cHAPz45DZN0PkRelbp7oMZynSoB+ARZzblbjeWUrGLZCu3bucope+0iWhkjcZYoiqx4zzAdfj80
	ZVMhm23i9hBXM4Xb+Q3FjB5zzgq6M5cNi2BP4HAd34NbS/aZai3uplc0rlIxm07415Go1QdxbNK
	ORwUU7dQ5SY+UZsXZT95O39G0I+1pBmYwR5AfEdGNqfbTFw+/0gJ2c1IgahHBO6wsqSDN7SRbu4
	sQlB518N29lyckAdbOV/wE0uwFft1e2rRHQ2EzV0JDh7waUWtj4c0qGhxVOCw6yTN
X-Received: by 2002:a05:600c:a47:b0:456:1824:4808 with SMTP id 5b1f17b1804b1-45b517cfe66mr203887725e9.32.1756478553407;
        Fri, 29 Aug 2025 07:42:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGqWe4aldLOwoA0lSJmYOAtk/gyCTKTz2xhXTH3fTqBq+gNs3GiB4PdE3KR16CB5LbW/sn45Q==
X-Received: by 2002:a05:600c:a47:b0:456:1824:4808 with SMTP id 5b1f17b1804b1-45b517cfe66mr203887385e9.32.1756478552938;
        Fri, 29 Aug 2025 07:42:32 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1d:100:4f8e:bb13:c3c7:f854? (p200300d82f1d01004f8ebb13c3c7f854.dip0.t-ipconnect.de. [2003:d8:2f1d:100:4f8e:bb13:c3c7:f854])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e89920dsm46578795e9.16.2025.08.29.07.42.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Aug 2025 07:42:32 -0700 (PDT)
Message-ID: <7cd5f8c9-9bd3-40ed-a3df-a359dcfe1567@redhat.com>
Date: Fri, 29 Aug 2025 16:42:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 36/36] mm: remove nth_page()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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
 linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-37-david@redhat.com>
 <18c6a175-507f-464c-b776-67d346863ddf@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <18c6a175-507f-464c-b776-67d346863ddf@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nz1nb4diFGMB72GsLWVe11SA3-YNceV1xYEkURZwiAY_1756478554
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: ABD291C0007
X-Stat-Signature: krgpto6gopafkihufrzait7s9jh1n47r
X-HE-Tag: 1756478557-773793
X-HE-Meta: U2FsdGVkX18/FDmVHAjq+Ynnw81R264KLh55ZYA1qthLekZZOq2nYlx82WAN9s9zgVn/vZ5J5uobE5zQ2qvIo0M2YxuiUJyOu8OQCUanSTYr4fBPipC0PU+sHZjoJOJ+o6UsazjZM9uS7egkCMoMedOSXej0QkYw2mhf8rbSpUjYMYRFX0xcK8YGdXuy1TEvO5fQ7r+XNo8XH1Ya7ZOVgd2mnDtaAyAC8FCwVoIN7RbI6Pzx766V+0AvtyIVFT5YlOE3qaSb1SWTF2ECj6YnxoWlRE3GI3Gw4PU4Qhs8AtpK/4ak4a1QBt7kV5Tp70Z8kRSZFmP/ZBhOA63iHloGBkh0Nql6ZHI5WB+2fdEesBAIJaemsenxYFTxq1yoI1bvy8wEx4yKYOfVb1pm3aDg8aRzKi/XBqjBbwp6xbURWo7R4uZVmS+RM+hIvk8J1Yu6bVFV6hS5C8n5MlT0nTM7CJyxLzHkQw6vS9rwI6bzLXUaVo6mYikNExCcy59hoi2Q/o3Oq8k2POqffABHNRm1OwmzpHdVlhbhmAQnKZgY0NVMbZUrsBZEPas+oks3v3ppdQH8DNyRU7QpWMQAlHMLXlAQzoH0ZhvCzinZQAwhME7+5kxe2tpYcgqu6TC8A8JrxEkwtYbZCZ90OvjeOGXjOXNeST8YJpFaGjQN0R2KH9a5Wms7ODS5TEzXZmgyNEMehmdfYBPYoWQ310CejFSLvnAYc0JVId6n22Hv3VEEUBpS2YBjRLu96f6OdoSNw76B/V7Vj/f/LB37FkKgV6AH9yRQO2mtotPmvqFGrhEDMl/l1LNpC/jh4wYF2DdCru2j8rxKc0wnWe1RFRJjxDyhJRJQoW7X7qOyBL0D+rupWXGwm6ruMeMdFz2U11KZYvHM4/J/WmEDTDrZk9RMfziD9bxbWtw0FsSxJ+AbuXtnMdfSIbERzyCX0bsxEMScJi8P75CHw+Hvowbhts7HPGh
 x7gqLW4J
 2WPolTomJln7MO607yGZ/6qGkPrANZ15T2pwM/Wi4EBlmEiCJk+upYhsqW9pwgWSYGxnL6PD6WjwwBxgxvoq8WwefW/g5jdRFAf8+la9ZcImPGXxgbc2gk2isTYcKPb+tUQFkIhbbH8D+hrno04FN0Hq5mOeq2Atv1gac73b0/MKLgt34T2OWMIvKljO3psyCc/HhbieOK9F623FI6kahj3io56LcUUhdKW8U0ur1uib7LLsNoKitng+my/pgpQMPpWJWVnzmWsLo8VIBGTe0YDbflDrjjw0Zre1TD5zAbGU8AF+SqOeGRj9n9bJjzj14/Isdka7y211kBvSttxnHpDYPAiZX8wNIszR40+sv8kDTUzroSbyz9hbos9WjxjeLzv0x+vnp2z1uvzKdZGTlDv0ZNgimcLxETyJRmw+C+Kkz8xn9H3fQNPWqi3YQrRBlGM7h48ewyrIThozun4n0UhpBKw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.08.25 20:25, Lorenzo Stoakes wrote:
> On Thu, Aug 28, 2025 at 12:01:40AM +0200, David Hildenbrand wrote:
>> Now that all users are gone, let's remove it.
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> HAPPY DAYYS!!!!
> 
> Happy to have reached this bit, great work! :)

I was just as happy when I made it to the end of this series :)

Thanks for all the review!!

-- 
Cheers

David / dhildenb


