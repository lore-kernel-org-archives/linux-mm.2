Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07BD4C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 07:04:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D5478E0003; Fri,  1 Aug 2025 03:04:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ABC48E0001; Fri,  1 Aug 2025 03:04:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84DBD8E0003; Fri,  1 Aug 2025 03:04:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6EF498E0001
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 03:04:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DDC041411AD
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 07:04:55 +0000 (UTC)
X-FDA: 83727301350.17.57C7DF1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6484E40008
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 07:04:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=goJIW2gk;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754031893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QZB1JE8ru4mK4hnR9SsG1KVSQ/pprulHKoW6ee0NdMw=;
	b=m1tmjk0iumcoPLtqrH30bA/asiiCUCy+oU8YtPqsiE/FnrhB2/wGuSbE7qndwGqJWBSiJi
	6zMah1sqDFzSM3LOOIxvMnH/lhY/6ccATD1adsR7PZKA+U8QJvpiZskuLTzUz8775nip5k
	q48VLt0LJ0OALfAwh6HKuass8XFqaaM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754031893; a=rsa-sha256;
	cv=none;
	b=6Drte2gRmaXzhw2HXgLeh9+o0XpBggpIddrwhnwvptktre5ufP5KwMzj2jIgGHZrDWDFsC
	2SUWhZYQ5gEnqEb8OKgyeKTi1c8b2J+LA8FABkxMz2EUr9Wdrd4RfGzh6B1ftLqoqdKmon
	mc9yysMIGK7PrkYFCdFW7q5KIWshRRk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=goJIW2gk;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754031892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QZB1JE8ru4mK4hnR9SsG1KVSQ/pprulHKoW6ee0NdMw=;
	b=goJIW2gk0TZoSSJfVlaInMwaK8+5ACdRO19cqkVZcVh2DRnqIUmlSpuOa0RGFekbOfjkcN
	MIUOBtOawCy1+gZXvef6w0E14gTfBbLTweVz2moD3AU8Et7gK2lPleGTrc0iLjL5tvRayo
	okeODpDdL2l8EbkbrvhJwPMOuUVysPI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-ntaZS_mQOCWU09rKDTVifw-1; Fri, 01 Aug 2025 03:04:51 -0400
X-MC-Unique: ntaZS_mQOCWU09rKDTVifw-1
X-Mimecast-MFC-AGG-ID: ntaZS_mQOCWU09rKDTVifw_1754031890
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b81e16c17dso215761f8f.3
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 00:04:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754031890; x=1754636690;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QZB1JE8ru4mK4hnR9SsG1KVSQ/pprulHKoW6ee0NdMw=;
        b=Hv9F0KFOg+ixJGcQjwECmwgNlbQUXvuOAA99i4M+UdE31SPZ83OUGnj9gxEHkfwlG8
         i0RkYrx7NqzLBNFTR0u2CvZuCDOXj42YAzY87oMvwNNyKwjcttP1jsvxcSEdJs+9Ff7i
         8TZ5rUsY8ET63qEa0/VrdgLYjpyhFYSm8LsWeipYuXbfZ/PHuppJCEuCSAkv9GIwxu0F
         s8LC4cdag+JsRSZmw8eBZ/4pOp/5qtz4UwC1gTWvRdqYpBFJPsxtAgYjdJxCzMvf0AZ9
         li4zwiuP8GWrxc1zkig5CXZKSSGvp1v5lwWNbO/rtBhI1DZNyaa7VrqGSu11bNdo5dis
         nldA==
X-Gm-Message-State: AOJu0YzMdQ7Q3pl2YEnydy9FtS8nIOitg0BbMW/vwo5DmKOFlxzPbHUf
	gEOv2QTuDTPWn9EfSmwVfaAZUCHaOc4V/A8cSAIr/Jp/2oX7KfH7CQUY7T2fBeLPWGjFhrwdRMp
	QoHIbbzCuK6NQ56kIdhM3PutIZznX9weWzRF+VMiR3sqqt6ktSNFo
X-Gm-Gg: ASbGncsvKWLrxqz2wBrYmLXrwXXNc0+fUIk8JcNZaCLQ7pG6lllplVDGWs8/HQIcg+j
	LnMQDmEGNO8Tu28r9+qcFf+Gn7191zzA4yuMhBfHBFnxld15XPMQpMQZu6YI7jbWpf3Bv1qDHa0
	Vw12kPnkqU+l/Xt4EL+5+g1q6sR8/YDvRxFFiV1D0MmYyHKECRGVAu3i+FWaYj85qUha7Xf/qlp
	F5D48t+qwaUNVUHohoIFQQodyfFkuYZSF0AMBv201XZ4lc0ShgNvqYiNJm37EzSDdiaAFBu4b62
	+web03Mo5edNlSOZ2SoyD8mh/G57MHWUQ0mLR/PDMer//Ak089nvAsoMhFo7LKoTS9O5wA==
X-Received: by 2002:a05:6000:2303:b0:3b7:9bfe:4f64 with SMTP id ffacd0b85a97d-3b79bfe50damr4381971f8f.54.1754031890110;
        Fri, 01 Aug 2025 00:04:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH6hZNO2MOs+gHYmiW/mGq8CJn0yoVxXoy4BUDRU6DvzOkNMBu8QGtwGI2DcXSb21LZKGyUzQ==
X-Received: by 2002:a05:6000:2303:b0:3b7:9bfe:4f64 with SMTP id ffacd0b85a97d-3b79bfe50damr4381943f8f.54.1754031889594;
        Fri, 01 Aug 2025 00:04:49 -0700 (PDT)
Received: from [192.168.3.141] (p4ff1fa24.dip0.t-ipconnect.de. [79.241.250.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c47ae8esm4774774f8f.61.2025.08.01.00.04.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Aug 2025 00:04:48 -0700 (PDT)
Message-ID: <edbe38d4-3489-4c83-80fb-dc96a7684294@redhat.com>
Date: Fri, 1 Aug 2025 09:04:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 02/11] mm/thp: zone_device awareness in THP handling code
To: Balbir Singh <balbirs@nvidia.com>, =?UTF-8?Q?Mika_Penttil=C3=A4?=
 <mpenttil@redhat.com>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Karol Herbst <kherbst@redhat.com>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?=
 <jglisse@redhat.com>, Shuah Khan <shuah@kernel.org>,
 Barry Song <baohua@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Matthew Wilcox <willy@infradead.org>,
 Peter Xu <peterx@redhat.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
 Jane Chu <jane.chu@oracle.com>, Alistair Popple <apopple@nvidia.com>,
 Donet Tom <donettom@linux.ibm.com>, Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>,
 Ralph Campbell <rcampbell@nvidia.com>
References: <20250730092139.3890844-1-balbirs@nvidia.com>
 <20250730092139.3890844-3-balbirs@nvidia.com>
 <c2f2fe52-a358-489e-a1f2-5c0a6f5b4db5@redhat.com>
 <22D1AD52-F7DA-4184-85A7-0F14D2413591@nvidia.com>
 <F60614E1-28D1-466B-A434-7FF1061B0778@nvidia.com>
 <9f836828-4f53-41a0-b5f7-bbcd2084086e@redhat.com>
 <884b9246-de7c-4536-821f-1bf35efe31c8@redhat.com>
 <6291D401-1A45-4203-B552-79FE26E151E4@nvidia.com>
 <b62234fc-051f-4b2a-b7da-0c0959fb269b@redhat.com>
 <8E2CE1DF-4C37-4690-B968-AEA180FF44A1@nvidia.com>
 <2308291f-3afc-44b4-bfc9-c6cf0cdd6295@redhat.com>
 <9FBDBFB9-8B27-459C-8047-055F90607D60@nvidia.com>
 <11ee9c5e-3e74-4858-bf8d-94daf1530314@redhat.com>
 <b5fa0989-a64a-4c91-ac34-6fb29ee6d132@redhat.com>
 <EC99D49E-86FF-4A50-A1AA-FC43A7D3716C@nvidia.com>
 <14aeaecc-c394-41bf-ae30-24537eb299d9@nvidia.com>
 <e5dd3f46-c063-45ff-8be7-64ac92534985@redhat.com>
 <71c736e9-eb77-4e8e-bd6a-965a1bbcbaa8@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <71c736e9-eb77-4e8e-bd6a-965a1bbcbaa8@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GBnraf3Vf5YxnJi2d9dsei95ORGV9Fi2qmpnKjRmi08_1754031890
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pgoin8edxwqan9wr8h7k7n3r5bq9cmjf
X-Rspamd-Queue-Id: 6484E40008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754031893-146430
X-HE-Meta: U2FsdGVkX19aE9Uyiz3fsp7d//Qkp3D4bbW1TU8VCIwFo5x12unysyfcmH0hh/yUCNZ3HN3PZxm9++D0RZeWGM6rUOYCWTGl/5L24LvTE8WINR/xn3+4kWM+4s5vhbn6SZMHW4kZqsBVbFwCGYJPxHXxiraZrIi/vDb4KWttVXoKNSwszE+M28oWvUCmhC4F5P2wDgXxz/dVhgDIZWDGIGSCSsF391u52a7yl1z9J797BRkAdT0ehb4wWHEeF5UUZXRenHrM5n706Ct7A/6ko2vKtSXWq8viH/HB9XSlwi3SlWjFhSM9kb05jAQPN8935D2uDo56mttsI+enlQWbsAtVEDxj2tAJdz0SahE4W2s1Tl0betRKeBXFLPcn110EXXxiiMps1l7DVgpDqydWdJOkhET5eGwff5E3Gs7EEie4SKN393bplAislwrcAfdMbPsB4aMZYvgMzw/huHco3Li//kfLfEhknZHe2O5egUR9tUQ1UEHDXuMbrLhL2UeGZfkiCA5QUn5ZN44U8YXkmawtU8XanKlO62aMKBuTnqCQFHrTHfNaeNhkWlnIcbPN7S6BLMI8Lv7yAqP7wZw789U7vrGEHy6aL7wf3QOwl3XDHjsQKiXEZAEuZPNQwMEj3l8xHHRqp0vYEQ3ay1OdC7HxD8AObb4FXjyW//zxj6/fyKUj6Y+G95vWL0aeisHgO9+txZwAH5AZyFTsr9tyFstpTVwIKNNx9LwcAl8M+GMzbOgP8/T+fu2JdMx49cpxLaWrbnmCJDUgrbEC34/FQav1FeTZ/Y2yij9dqjyo9+WABWOm5UxPuHTZC7jrOXDd+vjoxAw8GQVhabncnRPPwrOPslqC34ojXnOzm1kInT7UMuKM/a7NBIbqusydRkjHu1Rpjk7nL/z26SRxmxvzW5oiMZ5JN8Vb1nhuB4kbqzS+he6jUxv9ZLsRfpHF5eTTgv5tc+zP1yyEyxKTa7E
 PC2+dxB+
 n8OUd5zbO2UtqGUxLLl/ylDUCWQwhNSDJsqyMuAzOU1llZ8VS/rr60XPImbd80migqKWbySrh/SM9Zw3Y9NZ3pj+HLHa516QzO9UXTBeRywWzO9st+RC1OEQtWH1X0YZjGEfeYVUyxCPk9OUJswRvicKr32hWIeNL/OVjSDmXuOCgH6SlZDoRrQGF5CS/4PVAp6LoJmozvGn3F644guVtW2kfcsR/sdiTzxiSo7yQb4V8Cpcglfzfia9RXmIxh5+G/qSVZLVrx3+sA6p4QpZmfHPgnzTI9xh+LstwYVsLfcl1GSQRlTDThC9V6nJXdKvIE3dFOYd749/s8qlCGsAzpuyYuyGsH2DWeiM+uQ8/8JJNbGIvfMTdyPMCvwQY+ybO4+LjWm2XKKorG3hp2ztr0+KUD/IQwNcbXr5FbrpssoYwRFkf4VMv3oyuOklF0UvynXLAspYBveXXd2zrsUVGOp5bKOyQ/zf7rbfP3AYI89VVFj5stg+ujHK+sl8CjkBwkyE0Ehx+TYdNBkYT4v+e5/M3Px21U5SxL1X8svGFn/Q8fGyrYTHj71rnBC2Y3tXK8qohTsNi4TCaAlm/wZUULSppOnc11CmbYcXvdjDv/etM7TH4mFl3dpH6CZyP1fQ//eoZNLfr2G6BhXbmHfqiZAUbO/vKsWGxvHZd++Jjvofh8p15r/ebMGM45rhw+vZRfTtOSVkC99WL/I3MjjTxIOtvdmyQhfnfKA5OINtb64RtSqtRTV6RXLosyhC4o66FaiOqBfjPQdZbmFd8Sqi7TBeILcVQsSf21luSmmZOYRCieeleBQWTAbE4nBJcgH/kVfzo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.08.25 06:44, Balbir Singh wrote:
> On 8/1/25 11:16, Mika Penttilä wrote:
>> Hi,
>>
>> On 8/1/25 03:49, Balbir Singh wrote:
>>
>>> On 7/31/25 21:26, Zi Yan wrote:
>>>> On 31 Jul 2025, at 3:15, David Hildenbrand wrote:
>>>>
>>>>> On 30.07.25 18:29, Mika Penttilä wrote:
>>>>>> On 7/30/25 18:58, Zi Yan wrote:
>>>>>>> On 30 Jul 2025, at 11:40, Mika Penttilä wrote:
>>>>>>>
>>>>>>>> On 7/30/25 18:10, Zi Yan wrote:
>>>>>>>>> On 30 Jul 2025, at 8:49, Mika Penttilä wrote:
>>>>>>>>>
>>>>>>>>>> On 7/30/25 15:25, Zi Yan wrote:
>>>>>>>>>>> On 30 Jul 2025, at 8:08, Mika Penttilä wrote:
>>>>>>>>>>>
>>>>>>>>>>>> On 7/30/25 14:42, Mika Penttilä wrote:
>>>>>>>>>>>>> On 7/30/25 14:30, Zi Yan wrote:
>>>>>>>>>>>>>> On 30 Jul 2025, at 7:27, Zi Yan wrote:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> On 30 Jul 2025, at 7:16, Mika Penttilä wrote:
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Hi,
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> On 7/30/25 12:21, Balbir Singh wrote:
>>>>>>>>>>>>>>>>> Make THP handling code in the mm subsystem for THP pages aware of zone
>>>>>>>>>>>>>>>>> device pages. Although the code is designed to be generic when it comes
>>>>>>>>>>>>>>>>> to handling splitting of pages, the code is designed to work for THP
>>>>>>>>>>>>>>>>> page sizes corresponding to HPAGE_PMD_NR.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> Modify page_vma_mapped_walk() to return true when a zone device huge
>>>>>>>>>>>>>>>>> entry is present, enabling try_to_migrate() and other code migration
>>>>>>>>>>>>>>>>> paths to appropriately process the entry. page_vma_mapped_walk() will
>>>>>>>>>>>>>>>>> return true for zone device private large folios only when
>>>>>>>>>>>>>>>>> PVMW_THP_DEVICE_PRIVATE is passed. This is to prevent locations that are
>>>>>>>>>>>>>>>>> not zone device private pages from having to add awareness. The key
>>>>>>>>>>>>>>>>> callback that needs this flag is try_to_migrate_one(). The other
>>>>>>>>>>>>>>>>> callbacks page idle, damon use it for setting young/dirty bits, which is
>>>>>>>>>>>>>>>>> not significant when it comes to pmd level bit harvesting.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> pmd_pfn() does not work well with zone device entries, use
>>>>>>>>>>>>>>>>> pfn_pmd_entry_to_swap() for checking and comparison as for zone device
>>>>>>>>>>>>>>>>> entries.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> Zone device private entries when split via munmap go through pmd split,
>>>>>>>>>>>>>>>>> but need to go through a folio split, deferred split does not work if a
>>>>>>>>>>>>>>>>> fault is encountered because fault handling involves migration entries
>>>>>>>>>>>>>>>>> (via folio_migrate_mapping) and the folio sizes are expected to be the
>>>>>>>>>>>>>>>>> same there. This introduces the need to split the folio while handling
>>>>>>>>>>>>>>>>> the pmd split. Because the folio is still mapped, but calling
>>>>>>>>>>>>>>>>> folio_split() will cause lock recursion, the __split_unmapped_folio()
>>>>>>>>>>>>>>>>> code is used with a new helper to wrap the code
>>>>>>>>>>>>>>>>> split_device_private_folio(), which skips the checks around
>>>>>>>>>>>>>>>>> folio->mapping, swapcache and the need to go through unmap and remap
>>>>>>>>>>>>>>>>> folio.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> Cc: Karol Herbst <kherbst@redhat.com>
>>>>>>>>>>>>>>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>>>>>>>>>>>>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>>>>>>>>>>>>>>> Cc: David Airlie <airlied@gmail.com>
>>>>>>>>>>>>>>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>>>>>>>>>>>>>>> Cc: "Jérôme Glisse" <jglisse@redhat.com>
>>>>>>>>>>>>>>>>> Cc: Shuah Khan <shuah@kernel.org>
>>>>>>>>>>>>>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>>>>>>>>>>>>>> Cc: Barry Song <baohua@kernel.org>
>>>>>>>>>>>>>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>>>>>>>>>>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>>>>>>>>>>>>>>> Cc: Matthew Wilcox <willy@infradead.org>
>>>>>>>>>>>>>>>>> Cc: Peter Xu <peterx@redhat.com>
>>>>>>>>>>>>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>>>>>>>>>>>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>>>>>>>>>>>>>> Cc: Jane Chu <jane.chu@oracle.com>
>>>>>>>>>>>>>>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>>>>>>>>>>>>>>> Cc: Donet Tom <donettom@linux.ibm.com>
>>>>>>>>>>>>>>>>> Cc: Mika Penttilä <mpenttil@redhat.com>
>>>>>>>>>>>>>>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>>>>>>>>>>>>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>>>>>>>>>>>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>>>>>>>>>>>>>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>>>>>>>>>>>>>> ---
>>>>>>>>>>>>>>>>>    include/linux/huge_mm.h |   1 +
>>>>>>>>>>>>>>>>>    include/linux/rmap.h    |   2 +
>>>>>>>>>>>>>>>>>    include/linux/swapops.h |  17 +++
>>>>>>>>>>>>>>>>>    mm/huge_memory.c        | 268 +++++++++++++++++++++++++++++++++-------
>>>>>>>>>>>>>>>>>    mm/page_vma_mapped.c    |  13 +-
>>>>>>>>>>>>>>>>>    mm/pgtable-generic.c    |   6 +
>>>>>>>>>>>>>>>>>    mm/rmap.c               |  22 +++-
>>>>>>>>>>>>>>>>>    7 files changed, 278 insertions(+), 51 deletions(-)
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> <snip>
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> +/**
>>>>>>>>>>>>>>>>> + * split_huge_device_private_folio - split a huge device private folio into
>>>>>>>>>>>>>>>>> + * smaller pages (of order 0), currently used by migrate_device logic to
>>>>>>>>>>>>>>>>> + * split folios for pages that are partially mapped
>>>>>>>>>>>>>>>>> + *
>>>>>>>>>>>>>>>>> + * @folio: the folio to split
>>>>>>>>>>>>>>>>> + *
>>>>>>>>>>>>>>>>> + * The caller has to hold the folio_lock and a reference via folio_get
>>>>>>>>>>>>>>>>> + */
>>>>>>>>>>>>>>>>> +int split_device_private_folio(struct folio *folio)
>>>>>>>>>>>>>>>>> +{
>>>>>>>>>>>>>>>>> +	struct folio *end_folio = folio_next(folio);
>>>>>>>>>>>>>>>>> +	struct folio *new_folio;
>>>>>>>>>>>>>>>>> +	int ret = 0;
>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>> +	/*
>>>>>>>>>>>>>>>>> +	 * Split the folio now. In the case of device
>>>>>>>>>>>>>>>>> +	 * private pages, this path is executed when
>>>>>>>>>>>>>>>>> +	 * the pmd is split and since freeze is not true
>>>>>>>>>>>>>>>>> +	 * it is likely the folio will be deferred_split.
>>>>>>>>>>>>>>>>> +	 *
>>>>>>>>>>>>>>>>> +	 * With device private pages, deferred splits of
>>>>>>>>>>>>>>>>> +	 * folios should be handled here to prevent partial
>>>>>>>>>>>>>>>>> +	 * unmaps from causing issues later on in migration
>>>>>>>>>>>>>>>>> +	 * and fault handling flows.
>>>>>>>>>>>>>>>>> +	 */
>>>>>>>>>>>>>>>>> +	folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
>>>>>>>>>>>>>>>> Why can't this freeze fail? The folio is still mapped afaics, why can't there be other references in addition to the caller?
>>>>>>>>>>>>>>> Based on my off-list conversation with Balbir, the folio is unmapped in
>>>>>>>>>>>>>>> CPU side but mapped in the device. folio_ref_freeeze() is not aware of
>>>>>>>>>>>>>>> device side mapping.
>>>>>>>>>>>>>> Maybe we should make it aware of device private mapping? So that the
>>>>>>>>>>>>>> process mirrors CPU side folio split: 1) unmap device private mapping,
>>>>>>>>>>>>>> 2) freeze device private folio, 3) split unmapped folio, 4) unfreeze,
>>>>>>>>>>>>>> 5) remap device private mapping.
>>>>>>>>>>>>> Ah ok this was about device private page obviously here, nevermind..
>>>>>>>>>>>> Still, isn't this reachable from split_huge_pmd() paths and folio is mapped to CPU page tables as a huge device page by one or more task?
>>>>>>>>>>> The folio only has migration entries pointing to it. From CPU perspective,
>>>>>>>>>>> it is not mapped. The unmap_folio() used by __folio_split() unmaps a to-be-split
>>>>>>>>>>> folio by replacing existing page table entries with migration entries
>>>>>>>>>>> and after that the folio is regarded as “unmapped”.
>>>>>>>>>>>
>>>>>>>>>>> The migration entry is an invalid CPU page table entry, so it is not a CPU
>>>>>>>>>> split_device_private_folio() is called for device private entry, not migrate entry afaics.
>>>>>>>>> Yes, but from CPU perspective, both device private entry and migration entry
>>>>>>>>> are invalid CPU page table entries, so the device private folio is “unmapped”
>>>>>>>>> at CPU side.
>>>>>>>> Yes both are "swap entries" but there's difference, the device private ones contribute to mapcount and refcount.
>>>>>>> Right. That confused me when I was talking to Balbir and looking at v1.
>>>>>>> When a device private folio is processed in __folio_split(), Balbir needed to
>>>>>>> add code to skip CPU mapping handling code. Basically device private folios are
>>>>>>> CPU unmapped and device mapped.
>>>>>>>
>>>>>>> Here are my questions on device private folios:
>>>>>>> 1. How is mapcount used for device private folios? Why is it needed from CPU
>>>>>>>      perspective? Can it be stored in a device private specific data structure?
>>>>>> Mostly like for normal folios, for instance rmap when doing migrate. I think it would make
>>>>>> common code more messy if not done that way but sure possible.
>>>>>> And not consuming pfns (address space) at all would have benefits.
>>>>>>
>>>>>>> 2. When a device private folio is mapped on device, can someone other than
>>>>>>>      the device driver manipulate it assuming core-mm just skips device private
>>>>>>>      folios (barring the CPU access fault handling)?
>>>>>>>
>>>>>>> Where I am going is that can device private folios be treated as unmapped folios
>>>>>>> by CPU and only device driver manipulates their mappings?
>>>>>>>
>>>>>> Yes not present by CPU but mm has bookkeeping on them. The private page has no content
>>>>>> someone could change while in device, it's just pfn.
>>>>> Just to clarify: a device-private entry, like a device-exclusive entry, is a *page table mapping* tracked through the rmap -- even though they are not present page table entries.
>>>>>
>>>>> It would be better if they would be present page table entries that are PROT_NONE, but it's tricky to mark them as being "special" device-private, device-exclusive etc. Maybe there are ways to do that in the future.
>>>>>
>>>>> Maybe device-private could just be PROT_NONE, because we can identify the entry type based on the folio. device-exclusive is harder ...
>>>>>
>>>>>
>>>>> So consider device-private entries just like PROT_NONE present page table entries. Refcount and mapcount is adjusted accordingly by rmap functions.
>>>> Thanks for the clarification.
>>>>
>>>> So folio_mapcount() for device private folios should be treated the same
>>>> as normal folios, even if the corresponding PTEs are not accessible from CPUs.
>>>> Then I wonder if the device private large folio split should go through
>>>> __folio_split(), the same as normal folios: unmap, freeze, split, unfreeze,
>>>> remap. Otherwise, how can we prevent rmap changes during the split?
>>>>
>>> That is true in general, the special cases I mentioned are:
>>>
>>> 1. split during migration (where we the sizes on source/destination do not
>>>     match) and so we need to split in the middle of migration. The entries
>>>     there are already unmapped and hence the special handling
>>> 2. Partial unmap case, where we need to split in the context of the unmap
>>>     due to the isses mentioned in the patch. I expanded the folio split code
>>>     for device private can be expanded into its own helper, which does not
>>>     need to do the xas/mapped/lru folio handling. During partial unmap the
>>>     original folio does get replaced by new anon rmap ptes (split_huge_pmd_locked)
>>>
>>> For (2), I spent some time examining the implications of not unmapping the
>>> folios prior to split and in the partial unmap path, once we split the PMD
>>> the folios diverge. I did not run into any particular race either with the
>>> tests.
>>
>> 1) is totally fine. This was in v1 and lead to Zi's split_unmapped_folio()
>>
>> 2) is a problem because folio is mapped. split_huge_pmd() can be reached also from other than unmap path.
>> It is vulnerable to races by rmap. And for instance this does not look right without checking:
>>
>>     folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
>>
> 
> I can add checks to make sure that the call does succeed.
> 
>> You mention 2) is needed because of some later problems in fault path after pmd split. Would it be
>> possible to split the folio at fault time then?
> 
> So after the partial unmap, the folio ends up in a little strange situation, the folio is large,
> but not mapped (since large_mapcount can be 0, after all the folio_rmap_remove_ptes). Calling folio_split()
> on partially unmapped fails because folio_get_anon_vma() fails due to the folio_mapped() failures
> related to folio_large_mapcount. There is also additional complexity with ref counts and mapping.

I think you mean "Calling folio_split() on a *fully* unmapped folio 
fails ..."

A partially mapped folio still has folio_mapcount() > 0 -> 
folio_mapped() == true.

> 
> 
>> Also, didn't quite follow what kind of lock recursion did you encounter doing proper split_folio()
>> instead?
>>
>>
> 
> Splitting during partial unmap causes recursive locking issues with anon_vma when invoked from
> split_huge_pmd_locked() path.

Yes, that's very complicated.

> Deferred splits do not work for device private pages, due to the
> migration requirements for fault handling.

Can you elaborate on that?

-- 
Cheers,

David / dhildenb


