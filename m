Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59077C8303F
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 09:42:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C3D28E0133; Wed, 27 Aug 2025 05:42:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99BF48E0105; Wed, 27 Aug 2025 05:42:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B1F88E0133; Wed, 27 Aug 2025 05:42:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 745268E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 05:42:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 25CB61A054A
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:42:43 +0000 (UTC)
X-FDA: 83822047806.10.BDAC66F
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf30.hostedemail.com (Postfix) with ESMTP id 20DDF80007
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:42:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ep6GGK1H;
	spf=pass (imf30.hostedemail.com: domain of asml.silence@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=asml.silence@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756287761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s4gNirUawo/2N73RGh/VZFmiZovBEw6Zvsz5pkyBSog=;
	b=MOrTw4lt5SmksjCX+mQbzOypEuzMi/57bfbtOo03sVZpMPkevznIAtqEl0rij9yvEZHHsZ
	oiYRshi1Dqjp5Mwh1+US90Uai0Q64R8tK1ujXqZbwTFvkfCyUK/d7i9FNV7X3eT+fKm/64
	JSY3+sc/H9jHQ6LYBtuP4xiEEGWBC/o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ep6GGK1H;
	spf=pass (imf30.hostedemail.com: domain of asml.silence@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=asml.silence@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756287761; a=rsa-sha256;
	cv=none;
	b=5l7HmQoF6LTZQGN1HfgV6ODE12ho4P3JiUZ2sAwbK+iNFaeQpyppXT7zziqYnTZpJMTj7y
	arqFdJsfJUr1UqRUHi+1jkBlC/K3k0qyeLVov0nQ0V+WlAjGSLDMNBWdph6kv2ZR0vOBuA
	QFVWyyXhDjDb2qzJG244aETrqb7+fDM=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3cd59c5a953so29129f8f.0
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756287759; x=1756892559; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s4gNirUawo/2N73RGh/VZFmiZovBEw6Zvsz5pkyBSog=;
        b=ep6GGK1HH3g8X3HP15T6uZ3nLVDXDTH8Wt2+KrbBLOkmIZh5RxS9V7STZLaVGznGv1
         fWxeH58T26cqQUnPoUCaE7+agVS2sd0UeIjsV5EmEhPlV9arWivzy0gctgDyD427PVEx
         N9HWzT2jviyfeyDz2nNRfOeN1dD6yBw/ci02AU9IImsmJKX6Y0youyrmI/BVuC61JWzm
         ubVgosDbtIlmVFUuITdpWPG65Mn0pZA2MHlY83/kiZpm6jGj0Y8MVi1hZ5LGfHTcKFCW
         M7nLcfs2M8UiFm6byHFcUIp0O7m/UauWlSeUX22jjauArgCKLhx6noOKnW9VgEXBnSr+
         bLyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756287759; x=1756892559;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s4gNirUawo/2N73RGh/VZFmiZovBEw6Zvsz5pkyBSog=;
        b=gELyHebG40MfgkbGBT/qDKw8VLhNyt8SqYPKozhCeI357SYnrbWC+TMtZVz++Kr3Ut
         f1aRP7cZV1tpT8K19gISWpZmhSOofIqLwoXpB1ODc6vftcqgGWfe0a3HdR28jU09EasH
         3UFSKSF1zUvnUF74tFX+Kt6nIu30m73zR4UtNZEgHDwR59E8ItaufsbbqLEvMLMYxWoP
         yAvpY/ZxRjByu3208AO/s9hzhchOiFk2teRE2yBfL55yunsP+xoKEtwkUdNVL/zH6k3h
         z41Plre6Y2NoR9K1PWxOE02bFOgsmNR4ti5VUsVQigMa09YRYRAyfNWRRT78r2bURWG5
         ZGbg==
X-Forwarded-Encrypted: i=1; AJvYcCUHnYjzLulwQyVV+zibPZkcji7micxDm1mLQHUFOcRiATvT7AV9hgh0Muo4EL81/HchTJdJmFFEkA==@kvack.org
X-Gm-Message-State: AOJu0YyvNm1NoCZzqobD8PkmX/nrQMGPSS3U7LnlEXWKLbZxCUPrj/uS
	zOBzLL5ZoKPSwII8siZwx1KGvG2WF896SrtqtVYRuMJIp4loa4udzLGQ
X-Gm-Gg: ASbGncsJKgC4acl6oa+P8OH302rPLbLUJFkjt7jaBs46MSz/RSMTjR7T+bPidhSN33J
	ARHQkZ9l0lCF7ucuEXxt0fBDwYyATZD5xE7yKfmh1QinjPSFjCz35G1BDjY66JTi+mNHSGWnIlT
	ji/OWVutXieIijqpelqwv8mEXB4qZTkRq/9tN32HIlkBlj4pCjkIXG0huC/8nKAQGkISX7HVQBM
	fuQmPijtGcKRNxcxr7YzFl47UeqxSkfiqHDCaCJDWx1zwoBUaTmt6IpWbUj6G8ezLhCrwVp1Qw9
	BO58Kr4FniOE6t2mRZM2V3IJCquuFqQ5AXKE1qixl0YmSaZXYfZH/zEFN093ZXuKwCFR/2X/vl4
	RBf2cXJ1EG35SPUSQAMa3BXjQqQXQboPsSieZ9pHskqU9bkgqX3m7tTfwe+syRiwSNw==
X-Google-Smtp-Source: AGHT+IFkjO5GHbU1+2MUuKQvNL0fwH2etmLb7S57NgBpdq01aCYpWSgROxwdQQpXxfO8aoPZevSNpQ==
X-Received: by 2002:a05:6000:3105:b0:3b8:d672:3cf8 with SMTP id ffacd0b85a97d-3c5dcb10b6amr14770182f8f.43.1756287759105;
        Wed, 27 Aug 2025 02:42:39 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:4a1a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cc4b102889sm3363615f8f.51.2025.08.27.02.42.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 02:42:38 -0700 (PDT)
Message-ID: <46d09557-1873-4d97-b073-ce0c7296b954@gmail.com>
Date: Wed, 27 Aug 2025 10:43:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 18/35] io_uring/zcrx: remove "struct io_copy_cache"
 and one nth_page() usage
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>,
 John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
 kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
 <20250821200701.1329277-19-david@redhat.com>
 <b5b08ad3-d8cd-45ff-9767-7cf1b22b5e03@gmail.com>
 <473f3576-ddf3-4388-aeec-d486f639950a@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <473f3576-ddf3-4388-aeec-d486f639950a@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: funybnesjh5xfg6pugqoa57e197mc7fp
X-Rspam-User: 
X-Rspamd-Queue-Id: 20DDF80007
X-Rspamd-Server: rspam01
X-HE-Tag: 1756287760-75424
X-HE-Meta: U2FsdGVkX19qeZ/Rx5rJOFgCf5ZvJw8n97y4mIiTuOguh9LvLvi6WhBZODRKr/EqVPFD4HcW77ctikPvD7GLwEtYq0MSpw3hhWA3r/zkHF1jp1K9iiF52wPAnKd5NKiX8ajrWR3D/cdDZnnTx14ZysAmHS8zqtOxwrK0rLS9HbVYOCm9gWlPAIlz/E35CU1y5708PbomLlYb8PHZXtau5STe7jows4EpdQf3Z5e5osfqZWhSexymUNxA87uf7qbNE3YkOaEoz5ma2Gv/BPMSL6s4WSlHK8LywgZKuDlXjwB4q9UkIdakccstg0hNuQt0FgLN/eV445yESiK3LhUSyz3/68alLs0sc2njDmG0bkgrhogaPC6IGBSzOHUFqqCiPEdjLDJpzn80nsJ4WHnW0h0OM8ewJViUGNkzuKs6FQIxDoL70higLcSdT2j9RE7683pUFGw1JyLwreS1D7D+bg7HHPzwA+RwjjRRp9d/gHrMpZvSKUxQk5RrQxAhXNlfGeUZeNWVLCatjzQf82m4AMKnVPXV57kjZOAnWrJzOAkt7yVa2fI5I1lue21f/HTRJfvLMptNIucaDRDCZWHhAs40F2C5iVwC3pRw0LBzdkbjn6jXuRfgy3tXHIcRGUP5+6nfMdmNLymySikt41iSE684TsvWM6XGAkYOfgbUZzOALYt2u4Gu20L2wiY1DzCfVVwoA/lcC0U0OFd5y4+5GIGnEP5CT0qJXVrhVgUaroJqwQhH4K6v4M32/ZwsUHUJ3ZgBwbj+7q8Ij/xvjLYSlX4+toYUMbshlzxQce4cUaEB3PtXdSYuJzKLH0W+3Vx70vXOQ4NSyTc/DY5XOPMtQyzox9lP2VXtn4Cj6BOwBa9YX+FpSPanpufvB+sxBoxTU7kTAT8GdPvGskTqsFv8iI9Do4eIAtc04Abifr0Y5BzpxePdxzNColemM8G++lQYl8bY9ibDtrTdq4/d4Qw
 USApa8A0
 AXabBZIcBWgVqLpVun+lsdbeBDfWblyE20mCZF60hZkjHMKMYtfpgnspYleaAhsEcw2xqtBfEfz5HMWu1lCPSigmVS3+/ZAIhyrJ/CtHrby5o9wA2FeKH5dvj10mTWWhWa77HrLFW9vNgNG3/BcgM0jqIBh4Ew1pErZmd+kttmB1InggD3ecNo35sjVl/C620QtnTPGXeC41gQeRE4nJTcWHHLPoJoboSASy718rDMLB3fwBDfl7RGpn4IzqAaOj5iAHE9QhefU+KDrGjHc7XbeojxFT+NDWTYi97IHQXLyXvIEs7RlheQwjcFCfP2lQpxR2qV8g4HPxZ0xpwJ3bJdFczSoLnBOt6OEXNbrEqX429krPuljXkqk+8bVrTQPJ1hpk7zrOdwCerTz8IXH7b/y6N28cMIJRlJ1PEYqbSkwC1tqYSGgLgIn0WJpx87QLa55dFAT88eCxhrsPR3xvkl2tqzoIqJwwxRrf2a5g1SLtQFVRljjdAym7Yg1FYsM8nfuwcZayOc7LR80lTg1Q+A6SYnPxzIZEvHlG3LdX0jHhn6QGy+apV4dXBm0UJqpNJ1oYU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/22/25 14:59, David Hildenbrand wrote:
> On 22.08.25 13:32, Pavel Begunkov wrote:
>> On 8/21/25 21:06, David Hildenbrand wrote:
>>> We always provide a single dst page, it's unclear why the io_copy_cache
>>> complexity is required.
>>
>> Because it'll need to be pulled outside the loop to reuse the page for
>> multiple copies, i.e. packing multiple fragments of the same skb into
>> it. Not finished, and currently it's wasting memory.
> 
> Okay, so what you're saying is that there will be follow-up work that will actually make this structure useful.

Exactly

>> Why not do as below? Pages there never cross boundaries of their folios. > Do you want it to be taken into the io_uring tree?
> 
> This should better all go through the MM tree where we actually guarantee contiguous pages within a folio. (see the cover letter)

Makes sense. No objection, hopefully it won't cause too many conflicts.

>> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
>> index e5ff49f3425e..18c12f4b56b6 100644
>> --- a/io_uring/zcrx.c
>> +++ b/io_uring/zcrx.c
>> @@ -975,9 +975,9 @@ static ssize_t io_copy_page(struct io_copy_cache *cc, struct page *src_page,
>>            if (folio_test_partial_kmap(page_folio(dst_page)) ||
>>                folio_test_partial_kmap(page_folio(src_page))) {
>> -            dst_page = nth_page(dst_page, dst_offset / PAGE_SIZE);
>> +            dst_page += dst_offset / PAGE_SIZE;
>>                dst_offset = offset_in_page(dst_offset);
>> -            src_page = nth_page(src_page, src_offset / PAGE_SIZE);
>> +            src_page += src_offset / PAGE_SIZE;
> 
> Yeah, I can do that in the next version given that you have plans on extending that code soon.

If we go with this version:

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov


