Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 639EBCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 07:46:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ACE88E000C; Thu, 28 Aug 2025 03:46:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78B9E8E0001; Thu, 28 Aug 2025 03:46:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6736C8E000C; Thu, 28 Aug 2025 03:46:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 564278E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:46:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 21A76160A4E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:46:37 +0000 (UTC)
X-FDA: 83825384034.27.B402577
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id A580F14000D
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:46:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g6Pj9NgB;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756367194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QIPVhNdDqwyEUU2mMSzlYSdtbuVp92JbzlpYQuyYJ0w=;
	b=vbrdkRI7M8ad1qiHmQnwWuzNY1jRSrbsCoxJxXxOuZENPGt1sssee6TXwP8qeU23sIs8DB
	DfEkSL514DPvcOFXg10S40AjZ4rTZ9Pp+2IDxYzaoWZ298E6ttfQiYG5IEZXGKW6xvYJXv
	aV0EmbeSHENi3XYwbA9gqqCu25TY5Fk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g6Pj9NgB;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756367194; a=rsa-sha256;
	cv=none;
	b=7WMBmPL7RKCLePqwhx862fc9fvPwhSr2ahEEQ63fCdJREqbOx8fT2ZEZZ3cWooyMZ6F+Ct
	ZC7Wb1A93/FVhS4gHI2WpLdAONzKCyHkxV9z67gSnSlBJC2c5th65y1ZkZOV9+ZR3YeeQR
	ZM1oU5deKFj30Xh9rL9XRH69oeTRiRs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756367194;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QIPVhNdDqwyEUU2mMSzlYSdtbuVp92JbzlpYQuyYJ0w=;
	b=g6Pj9NgBWHu7LdxQZWkSjPb5F41x9eynGsqtTIV054VoDN8Vv4vSB+I9EBRjmBj0SnVv+m
	QqQKMw7l9+LSQfIQakxylX7sETMsFNj56qik7jyZeci8TWOGc6XAaIbPAlR0JekKfUnJkI
	ENM6/Pz6x1E4tz8rZWq89GVWHKzBRNA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15-yVLpikOCPX22dnte4GBurA-1; Thu, 28 Aug 2025 03:46:30 -0400
X-MC-Unique: yVLpikOCPX22dnte4GBurA-1
X-Mimecast-MFC-AGG-ID: yVLpikOCPX22dnte4GBurA_1756367190
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3c79f0a5bf3so377645f8f.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:46:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756367189; x=1756971989;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QIPVhNdDqwyEUU2mMSzlYSdtbuVp92JbzlpYQuyYJ0w=;
        b=mKDmncIaH8SmbJu5q5g+ZJVwu1uy5ss/YvJR/t+QGB32TMwf2aFq8yAHxZfojqBzwv
         aEiz2kDErUhuo6/ymYoaJjrw0ke8baeR5MWtUbR1/8NGJPAb69SOfnwDA3NbNJSOLmGZ
         9PTFbjER7TCeLcs+DeM0Q6Pqo2Mt3AGGMcTKu8FkZvKtQIWdTOrpcI5wYNII9tI71Ceh
         dswVSjlV7IOT0ct5oWvHUOEc67CmHz8ZSzitYFkzj1+6UeqIZw0FFuWEzKwHs2Xp6vnM
         OmLIa/yBeddTgO9e0js7tygjw1Od44EBvz39Ni5U8kvFSe04/UvsnAeHD90T2vTcVNqn
         S+LA==
X-Forwarded-Encrypted: i=1; AJvYcCUgeS2E7fbRPqu3vE7BE9mjS1WRdUzk/PjOjH2O3NiDVcQEu31w1SohYqoozP21DX6N4sO2S2eC2w==@kvack.org
X-Gm-Message-State: AOJu0Ywg3bwX5/0m9cYN3/E1h0mjKgMknuJ5Ioo+XbNkF6edhOYsCq81
	Jkpq2BwpJRDGDjxrxasJkX7vHVbI3fPCgiLLyNUBjkpgFoUyum+SlPHG5YWESG2dq+E9IF/jlhZ
	i5oP9ml+1cQuzgp+LcKbS7IqC9c3TvZkmrXrHqUcBkHfgn2t194Ci
X-Gm-Gg: ASbGncuD4NuhYK2/yJptr+Bmtn4bM1zVmMPMnaMKbqfvI4RmnN+8Ut5pZU6derfTvXK
	dWeIjjcTV3udSwC80LPbYhlWPbu/5ttH9UD8ZE63VMi7n5A2G+RLzJ/SPiJyEds3X2KHbW15pSd
	ov8ULJqq5FRamICTIkBTuERVwxhs65BOvywQZce4/qxlLpfS8wEsp/HPwRG2P/XRi1dWu72Ixp4
	9Q3UNPhtMJnYJIiIeaW5Lp4ZK/gZaO3eeDVYSQkx8j9/bcIsyfhgFbmgnoF/scNTgT+MIuj7a1G
	WIyer8GLcF5FNNV+w+5avKaKwpxmnLT73XbzN6OQV4uSjRliicb6ftCv0OW/BlQ5wl+zfx0Nx3N
	nlZuyRsHPGzgrWFcEl6nWXZpSkFVuoOdydfsAWdeAZXyG310pmfl7L2242lh3juqb8Ts=
X-Received: by 2002:a05:6000:18ad:b0:3b7:948a:1361 with SMTP id ffacd0b85a97d-3c5da741330mr15989045f8f.6.1756367189574;
        Thu, 28 Aug 2025 00:46:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHbZS9TwQor8utX8Cftd7hubod4ESO9oJ14F94do36paGGmjXBbrC+y7X5MmcQWQ6JKGQD26w==
X-Received: by 2002:a05:6000:18ad:b0:3b7:948a:1361 with SMTP id ffacd0b85a97d-3c5da741330mr15989008f8f.6.1756367189132;
        Thu, 28 Aug 2025 00:46:29 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:c100:2225:10aa:f247:7b85? (p200300d82f28c100222510aaf2477b85.dip0.t-ipconnect.de. [2003:d8:2f28:c100:2225:10aa:f247:7b85])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6b1cdf05sm35411485e9.1.2025.08.28.00.46.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Aug 2025 00:46:28 -0700 (PDT)
Message-ID: <0e1c0fe1-4dd1-46dc-8ce8-a6bf6e4c3e80@redhat.com>
Date: Thu, 28 Aug 2025 09:46:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 12/36] mm: simplify folio_page() and folio_page_idx()
To: Wei Yang <richard.weiyang@gmail.com>
Cc: linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
 Alexander Potapenko <glider@google.com>,
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
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-13-david@redhat.com>
 <20250828074356.3xiuqugokg36yuxw@master>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250828074356.3xiuqugokg36yuxw@master>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zmbEV9RL7uQXG7WQxZ8gCIbL7WpmHEnP9rZ95rXJJB8_1756367190
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A580F14000D
X-Stat-Signature: gq8bkec9f1grbs4xtope511scckw8uu9
X-Rspam-User: 
X-HE-Tag: 1756367194-140227
X-HE-Meta: U2FsdGVkX18CVsVO2AbUU/EGjCe7bKWJGyhRbUnULCz9TZXmnPVKmZGhxjTAZNznk+DYHCyutWleZMAVhfCVN/DyVkULPetGjH81L9jXjkkVoRb3FWJtXkbdovqvlQ0lyHF17hvue8ynyaKU6t/UV1X0O4tFyahZ5n7a2zfpK7R6Tio6bX62ArsUTz12w/VxEeNn2H34o5hocAb9BjBtVFyzA+v5pfPX1l5vdAqJFad4JmDbarHv3V5hq7b63E9ayYsN8vUAy2OoxLboWaCrC4YeMfdbWpJVHO5UsoFQYvrUljuVhfZ2QBqkCj7cDesJRbbdpglJ2O6nOgxB0PK6SoJPJbkwoPp1q0dr/1j6bCojRMb0V59qotFOcqDmtFEWWmBRwaF1bUQLU9IgWtUcv2Ul3DBP78kvJtFrYGPUKx8G1hAg01diBsGwCBIvWBFVHRwdqrPSrQ7ZRGiz/XctRjeGKeT+McqUv6MLJOTI2qluI3Ob6WLCSZbjVSxBwzOJIfK5XgVDczRCh9LqJLqN8mB/btNdDS+NLzSSVvGkTscdqX9jM5j55ZUP5LHJl0VAge95XJFAoj+qSnf3TFAxsAY9r9+eEl/7sEilgcEoBvYCzSBkolzSQuyVQKn2Ghu59zzlKcvUwjf3uq+BiKm1q/sbVBnwcV+5ItNHoSshASMNrFFMdkAmW/bapQlFYL0UBKkd9KWkyIh14DkRRd4CBEnWqVqkvCBK3bEn6+Jys9/lv7lcN0Kt5HN3tDN8imN0UL5ss2zXPvIkF+RoYeU01TG4ZyGlMU60mHuqSIT1+hJkQoN7ymUYhk69oF6dx6X4RAXEuXLrGNy8crcC0fhIMAQ7OMijCr8NlovqnX8wrXp4Y83oNU7U0VqZdbxXKMTtPChqPoe5M8XQnouLT6o8BUyHhBuFMxa/ZHt9h+oTUG3G6msv9DLKyxwnGUZ1lghvzuWFRdkCN5K5KLjXUOX
 h7xjK60x
 Qz04lFvOvoze7baIwDFTyeYjp1PpM8GOi2E2HAPsKYvhhrm2YzkkV7y5eODeGLhewc7jeo78jCM8neyh8NmFPToML3QfbOiHrTYMVIzj7/OdgclecbGLVgNgMVw/WMm4d4rUNsndCbf55Aoz+nlqanBaHMr8Mmp9n7Lg54erpwkH8+5UaBJgO8rn1HyZp8NPpNcYDY+5k4wYYIRVC+lxctm9+6DedW+0qLhrgrt6ZyK3/sLecDIBI7tZd+qt72MXSTQxKTO1I8JM2xcE6RpRxQY5VYj9TlQZUM0b128Um/2063W66jadqANNd0vIYfQUithKbRLAnwLu0W6ZFcqIfjBLGRirlQ11El1q1je//1n+Kc0ytHzSmkdw360AkBFs9wmpyl9OS/IlPyU6yeVY/MZxjoRHlW4nt2aq8TSjbK1iBjvRh8xR1BksoQK0CiXMwo06ntiDKmxXauwRXVMOPzu31Rm60gqjwVNMxVXg1PmbAEsxhRzx+29BT/8ccLKAEwgRvB0vISqw/Vm/dtdrAffuBxUrvblXT3KOLqtM5BDsr++E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> Curious about why it is in page-flags.h. It seems not related to page-flags.

Likely because we have the page_folio() in there as well.

-- 
Cheers

David / dhildenb


