Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8FEECA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 21:51:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 235E7940007; Thu, 21 Aug 2025 17:51:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20C558E0056; Thu, 21 Aug 2025 17:51:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FE78940007; Thu, 21 Aug 2025 17:51:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0F748E0056
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:51:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 31AE1C0540
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 21:45:28 +0000 (UTC)
X-FDA: 83802096336.13.867FEED
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9688714000C
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 21:45:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dRqQIkhv;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755812725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xgU+Z5k4KPqEraeKDWCOzJcpc8HGVmW4oZxLQRmx6Ws=;
	b=zweeVPTkXlFY8ZGjqkALrXM/G7LmRWdtb7XFKQVBOiJzfGHbsbjW+dWpLCuWNxcrZjrvoY
	o/I7tTBjsIDUZrvbyjaxc+mKzO2KbJefogx821UNkLtxmeLtsJTShIUB+mRIHFe9g/yyZl
	vxJFY+4sp8p3G/s6MdQy4hIg7hOhEbI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755812725; a=rsa-sha256;
	cv=none;
	b=fC+gVqW9yND7/A4efcxYL7Yc/bRwlQJcRmB+cgYtk4MW+1GBq2uxrHb3bc0LlyxcJr2UhP
	RFAp7zp01GJC+PBxbWwNiiYc46vJORosx43am+DHrfpgE4FO73nLo0jfclhsMaaMS9h5i7
	P34IsEsHnOW+vnG153nKmzvcTXqLYp4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dRqQIkhv;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755812724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xgU+Z5k4KPqEraeKDWCOzJcpc8HGVmW4oZxLQRmx6Ws=;
	b=dRqQIkhvznsxHhME/+IsWavrsBXHmsqA0USw2cVx2/8Cna6y7TDXT7A4V4YY0RH+Vyq445
	cqT9YJffSaWiz53FMiq5lWOj7T5uEy3nhzvy3Lhlxxc+eG9yvep4UwD5yR53gAaUEx77Qt
	8YtGULrUxS3zsblyXIHRYH0/wkdNEZw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-670-6sosH_vMPQGCSBnHlgylMw-1; Thu, 21 Aug 2025 17:45:23 -0400
X-MC-Unique: 6sosH_vMPQGCSBnHlgylMw-1
X-Mimecast-MFC-AGG-ID: 6sosH_vMPQGCSBnHlgylMw_1755812722
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3c380aa1ad1so542125f8f.0
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 14:45:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755812722; x=1756417522;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xgU+Z5k4KPqEraeKDWCOzJcpc8HGVmW4oZxLQRmx6Ws=;
        b=I77/Nn9VlaR79iYvuRFtW7PLqcZyN2+jmznyMbmgpA6iZLgrLgg0jQF8SPHBu+//3X
         o/purlw9cqxnaQAgmgO11pTjyUXjebaIAnnUDkDWg3aUHcu8P4KZq7dS9Fjxwd9RvQyd
         hnwhmeJOSrhm7Aw5G7K11amfEAEfMo9UQJaOvL7FfSKaCPfM0wBorxxzboQqKJJaDJi+
         zoKbGsV3XoEkmV4SZpeMQ1zNoVUV+yJx6JfmeCOyFF2IcEFWoBaZ796uBmsEms0rmmLa
         gjUNu8rHlu2T10bPmUICwmE1rfLbfj5+SzmwMN24sxKbUqleRrAl/TYfjmBALFFyu5/a
         SBlQ==
X-Forwarded-Encrypted: i=1; AJvYcCX73CYyK317N/fUe2rh9aOoqCk47XQMvPeTzwNYQxFTwSpzBEWS2xVrNxW8HwnMnIX628n9fG1QJA==@kvack.org
X-Gm-Message-State: AOJu0YzabBuzzfcboP3712KRMp+Psjs4Fc4AaK+KGtHknXRoIHKpBafD
	sKBrcZHGv8qMIeLw8yZl6LcKxMHW8KtYHQSjARtRoL+hHcZDbWcAV2RWVfh8mrmsjAgqn+wSsxz
	E2UamtkN3Clt5OetRNoJy5MOFSk9LaCJw5co8X3n6JEERPZbf2q9d
X-Gm-Gg: ASbGncsQYCpRoOKP2vddNHz3c39oF2u+/8Lxgb4npj1mihf1AU7EU/suOniILZALDEI
	f7ou6I4vTu/WJq8W2q6hbcMsH0mBTZcGnkR2v3eUC4+l4a1Lf46zeSixboV8P5arlx+y1OQ0SiA
	h/MGE13/x2Q62u2RCdTLx12OWsLa+vIKfZoT+Lb1YPeNMNVainvaCyrCfzjoncEDnl2zD7il4Vw
	nsrCz1yr25hvAqvc6gEeRHbMnQf6REVg1hlbclys5NxU4FcsiCJw1OM7uh7XPiWzWjxZsGHyyaA
	kb5RaVTbxEkEwwxPh4DySr3SmcltuesNfU2rYtO2M0Z9b0c3Bkif/s8acUEIv84cn96lJUF8xN0
	zROPslgqE2rlISpViW441uIwBKD0OmSqPNqolrcfTiKYdOROTsuuAWJBLLA4ELw==
X-Received: by 2002:a05:6000:2902:b0:3b8:f925:8d4 with SMTP id ffacd0b85a97d-3c5db2da00amr300070f8f.26.1755812721886;
        Thu, 21 Aug 2025 14:45:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEfnhl0R8ZwVLuxUZYmGD7nMrbthuKRx51tD/iqNpCQL5sxy24UygUdE3xc6j7fC/B+t7+yTQ==
X-Received: by 2002:a05:6000:2902:b0:3b8:f925:8d4 with SMTP id ffacd0b85a97d-3c5db2da00amr300045f8f.26.1755812721421;
        Thu, 21 Aug 2025 14:45:21 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f26:ba00:803:6ec5:9918:6fd? (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b4e25da97sm22067085e9.1.2025.08.21.14.45.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 14:45:20 -0700 (PDT)
Message-ID: <b09b7ef4-5b06-4bb8-9be3-1194e3904c92@redhat.com>
Date: Thu, 21 Aug 2025 23:45:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 33/35] kfence: drop nth_page() usage
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, Brendan Jackman <jackmanb@google.com>,
 Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
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
 Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-34-david@redhat.com>
 <1a13a5cb-4312-4c01-827b-fa8a029df0f1@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <1a13a5cb-4312-4c01-827b-fa8a029df0f1@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3XaWbA2mhIXUQpoxs_OfMrUorNxs7bnVCzFjEqJHJZs_1755812722
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9688714000C
X-Stat-Signature: qnqd5tec389iuf9itor86bz774rghsat
X-HE-Tag: 1755812725-77374
X-HE-Meta: U2FsdGVkX18ewcSBE62bdp1Pw3uIvlDiINxAlKywgZNVEZGVdqUu09b2sUrG5NBDMrQvr+6S3b5oqnyLWUfNKlTVp984tfLlVQGOJjGOLSN360h9GILRoERdWN40Ycj4jz7LqacDG3UVfql2yk1Co0pfGrJENApxL/gzAZ71d1L2Tt9HLo0xzATpj71946JN6G5gk0k+QBBRUXND9KMet1PHcGU1kwL/bAnvdcqQjWfMkyGaUYS3ACtRDDk60uaNqmg9JoM2+E/KiH9kNPGPTkfQNuDMkXp7uWxLE8WmJ3FHpokWUBO4Bkt0lv7uBctTYO5k0MFSEkPzSuQxDyfbDmVPTzQdbvla62SU6Xe8AGfF1WtxMONszCugop8NJqc8Yhvh/vM+cb4Nxi6KCygHeVmITyDA4ohLz7HxSs5L+JcV7YgreaiuelR1zIFtCtPb21yRdicuQKyhaAqvDSZkxnAD56FmKlD7GGTNuiJKLlsE2PLba0WV+uDSp3KPpl57snzqTNCBnrPvKEXqFEArsMZ/tQsS7VO8smgjgheM+hzH6DSrMhbyQV7JbPA/gLjzFrGAc2mUUGOfFKAHOdFA4OnkrN7MOa0f7cSpKT1kEGCVsQWnwF3q6Pv3PZQxHT+zAyCcTG+E0EzMCIJKfhou0XKLeO36zcKCm0ROpPSeDwiarjaiN4wjmXY8PvL/LJ63nE3O1mQWfjR4M9nDm75n67hL3akfTx6hnnCXs1tY246C9ViSUN2flDVzGpSUbNG/KH9OkSLZrKP2bwBhTqlWqvmalXffZtXL1MSet1YLXO2KoWq5a4UVDERDh9KHDPfqnuEwbUwDUtC95GgkH+OhMIp4/MrZiD79TfuHC0yfswV6Hbctih/3eZ76jd0WZTmqtuCig4wWWK763GCT0JjBGtl6ZfWFWuUxruoqDZVVUaLNjbOW4U6V+W5qUjo6fUX0Ge6TLGGnl8tAooHW45c
 31eHZDmc
 Wsg478/xXICGp9rBa7cT2ISdTlNFXBGPvsfTWe6vwAiQVyucQXcmK7x5zX/E8XbgaYlh5gKgqsTKaZHzLQmuv1PoEYRwhZyOfLMGew2hMSAX9eFCO/SCyAQMpu3oWtNryAHon8zvaPJ4S8UM4nB3apx+fWsfqxSaSQ3Lr54RQheOK5iXHU04XjeLSRut/XTR6nWe53pd6EaPtrNoNnLjfXNGra0LkuM/pgO5721/gwvIYGsUqSeEuAAB/TodQF2JKmTv60yr83YRI/8/F0ZSOPWA+7Tx5foCUOchN571xFViXRFKiSP9WDUgY2/+c0zi7ir6rBMTMZ0vcLUoIg8tsny8RSKbxbX1KRkvfKM1rRCUS6enN5v9deMjm5zAt+4LzuATrOtDf4qgJZcvPklwjXnFm8CNNQsIL58k6aiP2TZBrRgMTaaYoFsGUKe68/NhfSuw+4rUZplW1KILeLbDjutVrjw0eWLTBgbw9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.08.25 22:32, David Hildenbrand wrote:
> On 21.08.25 22:06, David Hildenbrand wrote:
>> We want to get rid of nth_page(), and kfence init code is the last user.
>>
>> Unfortunately, we might actually walk a PFN range where the pages are
>> not contiguous, because we might be allocating an area from memblock
>> that could span memory sections in problematic kernel configs (SPARSEMEM
>> without SPARSEMEM_VMEMMAP).
>>
>> We could check whether the page range is contiguous
>> using page_range_contiguous() and failing kfence init, or making kfence
>> incompatible these problemtic kernel configs.
>>
>> Let's keep it simple and simply use pfn_to_page() by iterating PFNs.
>>
> 
> Fortunately this series is RFC due to lack of detailed testing :P
> 
> Something gives me a NULL-pointer pointer here (maybe the virt_to_phys()).
> 
> Will look into that tomorrow.

Okay, easy: relying on i but not updating it /me facepalm

-- 
Cheers

David / dhildenb


