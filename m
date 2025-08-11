Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14E68C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 09:49:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95BA16B00DC; Mon, 11 Aug 2025 05:49:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90C8E6B00E0; Mon, 11 Aug 2025 05:49:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FC326B00DD; Mon, 11 Aug 2025 05:49:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 715D96B0143
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:49:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 234D71DD56B
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:49:29 +0000 (UTC)
X-FDA: 83764004058.16.7843B20
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id B411D40008
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:49:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VWYv7bV6;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754905766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zy7zoeBHdfB1I6ns8dWDx/bnOQrMxjU4C6kURFFGtA8=;
	b=OtJMCGNM3U+4INrIpvoXMD4g3tuP69MaKNtNOHsYQFdNm83/58UxR9B7ZbBDxtCdqYhDaJ
	mHvonTZq8c2UqEv9dE1hpTIK8wNQxP+PbObzqRoZSNsyaO1WTWrBdmrmrwlpCaHyIx5w0k
	zSMgpl+2ovkj42aG2CG8P2EzMoqXUcA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754905766; a=rsa-sha256;
	cv=none;
	b=q6dDxmI+REhTRdbkh8QzR5MNNXfBIVAA3TuQzucVabetsuG7k12E6Uu+V/r1FnF/Zdvfaf
	pispQ9pRnR8pkC7wWqSaika5fjiBDVsxl14ldekPAZLiBeelHn/ZLrOp0ta1zu0S4t37FE
	+3dFiqbXlDU8BX+ZxTIshMFs4bfufoA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VWYv7bV6;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754905766;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zy7zoeBHdfB1I6ns8dWDx/bnOQrMxjU4C6kURFFGtA8=;
	b=VWYv7bV6C/BQN5hkAjr/z90J1ZBFgx+Pui0b8UHAYtTbwHTxU+35QAWGn2mm4JEUhI/6vb
	BpdZYlq+YsbHSuUc9IigqvaFzg40/Dy5wLibKOc0HouaV/AbkRoE/qJes8EYUlgbAOKrEP
	YkUuAZLlBV7dKY5v9jf5CEvg9CC0sd8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-QYb1pb6tNT-FA-7KCeRspA-1; Mon, 11 Aug 2025 05:49:24 -0400
X-MC-Unique: QYb1pb6tNT-FA-7KCeRspA-1
X-Mimecast-MFC-AGG-ID: QYb1pb6tNT-FA-7KCeRspA_1754905763
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-459de0d5fb1so33111985e9.0
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 02:49:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754905763; x=1755510563;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zy7zoeBHdfB1I6ns8dWDx/bnOQrMxjU4C6kURFFGtA8=;
        b=EViyWHAP/0EFRh1sLRForCccwDPFeJ9L0IrLv4omHG237KKOrp91h/OgNOHRaVvaHW
         JXKFYLxFPppQ8bqWJ69MhBq1HyBKd1Axb5aakaqMdRkl+0jta7+ebz96bw/fO5JZ2Bf8
         GNSs6mJOo/Wq1WSDf/8XXe/PzagZKK/iBWQKg5GSdRdXtV+XF3xGCp9PXT4GD/ZdknqJ
         6dAbJ/OUZbJRsbjSgsrHRL6tf7EOP+d8EPlz90G5qCRqwnxa6mguJqgm/zX0GsntImIV
         S8HmXU+8kbkWEP46eWiqLEB5fMog461peIRXF/a25D6xG2RNddMGgXYGqdrxPYMtPRcB
         zYaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDcUZ5jO5ykr4u4R5Gly6BFMQKoUqnFQxJfrDFkSHIpbie5C5gmOKQuM3jaN6L4LL0d9Vr/Ke83g==@kvack.org
X-Gm-Message-State: AOJu0YyY8UC//rz/+Tjtv14LQr9OGyNATpjSyM/EYKJ3JTFqIS39rh9J
	fpOM/6zbA0YcsJzzeL4Qh3njqbqREYFFeiFQqNoFAiyd2OBQiEVfqgj+6sCHdeA5fwjeOjlJGli
	Ka8Z1wkVpg4AdA7SPHCmNZOYIC/zdjHxK/S9Otb4PUeMF5n26aKkZ
X-Gm-Gg: ASbGncvfMBixl7mnTE5bYDuPqOLOsMRxWX6/SDm7edM8da92EwnJDfXE+AVyKQUVQMO
	fVb5FjVsO8MztMDWttr7sxXPQb/amccR+JTkGMwZRq+4H821b0g6Z0GJMU8Gb6iMdjpyMvjuT0J
	TYABOqV388ilHTOyCYVX/ZqtG5tvPDVsJ4o7rHcaGlJ5bkVK3UTBeMN3G0i69d/nBPX11a7f/EA
	VE1/EE+wTdjpptnUH9zU9xdIZYAs4WgtGkShdw+dDlOqZ3PVg3JYmROtU3iusz/R8Hk+LfsYNin
	ZlHLFZWPm0vYOE2SQrGq6LMSOC5hmgoC3V6FLZ9cfF7xofX0D12kgReN/oWGz9COztY1W4/IAEl
	nwAR734SwZLNvCpRMkToEZwu9PfWvSvtBvHe7Y1VnjUZ9mbB2IcJcjIr0UiAtI96B0Lc=
X-Received: by 2002:a05:600c:8207:b0:459:dc81:b189 with SMTP id 5b1f17b1804b1-459f4fc40e3mr130800495e9.31.1754905762850;
        Mon, 11 Aug 2025 02:49:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGEa+lMPdCvEQQa/1iCFQjPws3MuVXvht3etKiuOL4kCcQ5Vr73iEgsX0YCT2GWYa35XBoE9g==
X-Received: by 2002:a05:600c:8207:b0:459:dc81:b189 with SMTP id 5b1f17b1804b1-459f4fc40e3mr130800075e9.31.1754905762394;
        Mon, 11 Aug 2025 02:49:22 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f06:a600:a397:de1d:2f8b:b66f? (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3b9386sm40066956f8f.18.2025.08.11.02.49.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 02:49:21 -0700 (PDT)
Message-ID: <dfb01243-7251-444c-8ac6-d76666742aa9@redhat.com>
Date: Mon, 11 Aug 2025 11:49:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/5] add persistent huge zero folio support
To: Kiryl Shutsemau <kirill@shutemov.name>,
 "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Vlastimil Babka
 <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, Mike Rapoport <rppt@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Michal Hocko <mhocko@suse.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, willy@infradead.org,
 Ritesh Harjani <ritesh.list@gmail.com>, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
 mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de,
 Pankaj Raghav <p.raghav@samsung.com>
References: <20250811084113.647267-1-kernel@pankajraghav.com>
 <hzk7e52sfhfqvo5bh7btthtyyo2tf4rwe24jxtp3fqd62vxo7k@cylwrbxqj47b>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <hzk7e52sfhfqvo5bh7btthtyyo2tf4rwe24jxtp3fqd62vxo7k@cylwrbxqj47b>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NDIN1fY0G9W7ViNT2xIcVYLGFgzO87Bdx6tKqTN3o5s_1754905763
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8e3gsjieu5goih73uit7a3984gdno889
X-Rspamd-Queue-Id: B411D40008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754905766-527109
X-HE-Meta: U2FsdGVkX1/zuxYdBvu6S39+5MfPASCAwI+0OpqeKaZyODXP3tN8yoHAFWta/X/2jtOXwrYab8rsqTg37JGVqyQFtPELt6VnR8NJgVWohr74N5ARGHX2LQYtChRwVGjnWYCCB+uY6Ic3hEAo8Y6e5w12uSmEWEMcuII2I8qL6rXGgFsFQgDHJ+0P1162XEomuAaHx58LEjf1qzw3jG/YAL1EXikczUdcyvbEiLleJU0A1z7zy0jfX7J8NH/j2y57NPAilh11rZMAaQPCPIagfYIErOAgrNg/anmL4EIp1BWntY7EeWSifqSvxAD1S+fmdP9pxboIvwdY4OVY06ZR+M+1KEIhCz2DA0U1KYPeZ3fE2dCJ2mOl0ziJp/0Zsn3CErWLOTLjOzMSMHYd7VZTqb+i4M3ayMz59C7ErZoDyRQi9B5b7ckropZl+8ZYE2Rhwtq/EiAFTrYq4GHyhf/a5SziZqgLvF9ESEobUS7VPtXiuor1pCmL29jYiRe8U5V4riJjL0MGp0pZ25RW/cXg8kHWZSjZT1JxDabSRtACwGmH955/qsAUtdonUwdrngeCU6GtuhOUMI0evN+5WIIOcWXnnnrIEYip8UIaNMKlpMjEV0Z2N1xgIk29iGpjA80z18bEZXai2ztf8UHdtnPRyuoj3ydpFQ7egomZdU3pRNF8SerCJpDAJEFev8/klqWDnfGPCLNmEXP+VDHaRDYO8tEYHmh6REa1PB5Sr3kTDqzhIT367UphwYyWNt0S92HFZtjDyE6ZEHd86nL4c+npJwp9cuulQLPbq9AMTvNU82kVRaNX7OWZUa+PzUSRB1vqnpu089tJObHbbdnQCHyr4D5zXfjJOj92Bnr/C0L7PXnObrz15ek1vWDMcTK7ua/ptep+JUAaJKZl4XQUcDFKS/+0YmgOmoz6cB7IKuZI667tnSuch4KZQCar4Twwo5aNuGT7fDThJf4Jn7Ar5dz
 CeuMFB0F
 Zrp8YRDio1s/CutkwdAiv//HUusQ7ECD13EfagJjloeBuujWrSzdhdT91umyHy4yzI6Ik1bVDMikeWWJcLuilGJjGWp1eTlzIwWBFj+HQD+PZt00sdt1g/rjmeT2LOPHXqC1u1sttgpbvQGathMNhDtYaM5XhV8ceg/Uqpa0YBfmcaUnqsddVCwwhUbXjqSQU17FIamm6FLlu6z+y7U53gmhaDzfcPIgV7QItatOfPIJlroVcUFx1fLwTRoAFLVhGYfALH5I2Nibj5U7WMDiuiE/p+ta07hb2fjJlNvO5CPxvOarMz/DQo2KBFY4iI0LCif+DTrMdTsgHxy1jyMbSweS6SciWDkQ4Jz27vYfZ77bma3G36NLjYDBJsDl+XeTjPiwvbWZpCxr9qOh2P3HIf7ch5hVFcy/X2k0AHFQfrNmjVYUa44DdqPsqcrW41a94kQQek3pd3G+Um5P31UzCIdJ544BfOF2Wau1FR6iGV6JZrjhAffFzC0TykdtjUR9ZxXp7L/Ewdmi5gZqZH4NDtsQ2oEnOXuQM3Nmu39tdOs1rSeldTxYZdwM0MA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11.08.25 11:43, Kiryl Shutsemau wrote:
> On Mon, Aug 11, 2025 at 10:41:08AM +0200, Pankaj Raghav (Samsung) wrote:
>> From: Pankaj Raghav <p.raghav@samsung.com>
>>
>> Many places in the kernel need to zero out larger chunks, but the
>> maximum segment we can zero out at a time by ZERO_PAGE is limited by
>> PAGE_SIZE.
>>
>> This concern was raised during the review of adding Large Block Size support
>> to XFS[2][3].
>>
>> This is especially annoying in block devices and filesystems where
>> multiple ZERO_PAGEs are attached to the bio in different bvecs. With multipage
>> bvec support in block layer, it is much more efficient to send out
>> larger zero pages as a part of single bvec.
>>
>> Some examples of places in the kernel where this could be useful:
>> - blkdev_issue_zero_pages()
>> - iomap_dio_zero()
>> - vmalloc.c:zero_iter()
>> - rxperf_process_call()
>> - fscrypt_zeroout_range_inline_crypt()
>> - bch2_checksum_update()
>> ...
>>
>> Usually huge_zero_folio is allocated on demand, and it will be
>> deallocated by the shrinker if there are no users of it left. At the moment,
>> huge_zero_folio infrastructure refcount is tied to the process lifetime
>> that created it. This might not work for bio layer as the completions
>> can be async and the process that created the huge_zero_folio might no
>> longer be alive. And, one of the main point that came during discussion
>> is to have something bigger than zero page as a drop-in replacement.
>>
>> Add a config option PERSISTENT_HUGE_ZERO_FOLIO that will always allocate
>> the huge_zero_folio, and disable the shrinker so that huge_zero_folio is
>> never freed.
>> This makes using the huge_zero_folio without having to pass any mm struct and does
>> not tie the lifetime of the zero folio to anything, making it a drop-in
>> replacement for ZERO_PAGE.
>>
>> I have converted blkdev_issue_zero_pages() as an example as a part of
>> this series. I also noticed close to 4% performance improvement just by
>> replacing ZERO_PAGE with persistent huge_zero_folio.
>>
>> I will send patches to individual subsystems using the huge_zero_folio
>> once this gets upstreamed.
>>
>> Looking forward to some feedback.
> 
> Why does it need to be compile-time? Maybe whoever needs huge zero page
> would just call get_huge_zero_page()/folio() on initialization to get it
> pinned?

That's what v2 did, and this way here is cleaner.

-- 
Cheers,

David / dhildenb


