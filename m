Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10DCDC83F17
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 12:33:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5B976B00A0; Thu, 31 Jul 2025 08:33:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A33FB6B00A2; Thu, 31 Jul 2025 08:33:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 922916B00A3; Thu, 31 Jul 2025 08:33:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7F5B76B00A0
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:33:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F2865114679
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:32:59 +0000 (UTC)
X-FDA: 83724499278.22.2417135
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 776EF80004
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:32:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="D/u7BzHT";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753965177; a=rsa-sha256;
	cv=none;
	b=7wHlPxJHDZ1UnMXtmAsGarcthxtUdbI+a18CZfBZbZSh6AXHDItDYG4HX9oG9s9jGSxPGy
	xdmZTT6RxOnrHmKyGz037olBFCZoweWENAelTrNDsKMMFH58bqTniNwtcO+HX/IU08wxcj
	jWE7rYCaY1Vosl4ye1rpFtn9lKl0SzQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="D/u7BzHT";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753965177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7osG0hSFBOUfuzymqwF2oBFIkyEwUqslxX8IXlG1JHQ=;
	b=a2RvShwx8kZJGgW0e8ygXUMNTQEC3MJMdBzVRKUeZZCQR5KH6Ze2HVwyVsYNyQoJ6ARcuC
	I33z++0k+onAyUtdzhG6i1vLB3jM4GljzOHcdrx6mUPRuDRxBLbUItBno7Iq8m+LCNh0Cc
	ah3KyJSWxLokSeypN1UyPK+yHF/tDu8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753965176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7osG0hSFBOUfuzymqwF2oBFIkyEwUqslxX8IXlG1JHQ=;
	b=D/u7BzHTyi6XTJNN9UB0OwqlEipQng6DhEFfnfQqknNOROHR1lYez5MVv2QDb+iNKHCPuu
	Ni9NRNdYal0PApHb1Jw4ROVp6f8MOOMo7uZr6MqLiH5fW6EkEHvq9ZTv8ZQBrtm6vaNiM5
	b4y2o2P+iRIqkOX6JYSMTuWa/u5mq6U=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-360-FRamAHrRM62dEVYGdKNdIA-1; Thu, 31 Jul 2025 08:32:55 -0400
X-MC-Unique: FRamAHrRM62dEVYGdKNdIA-1
X-Mimecast-MFC-AGG-ID: FRamAHrRM62dEVYGdKNdIA_1753965174
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4561dbbcc7eso1205415e9.2
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 05:32:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753965174; x=1754569974;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7osG0hSFBOUfuzymqwF2oBFIkyEwUqslxX8IXlG1JHQ=;
        b=miTM8j50bEFPGcVz60iaDE049aRbmono/ts1S2GhxAJK+OsZy5FXKPhSWvzK5gFfZl
         My/w9udkH0wFOu5OVCStKsVB9uFSmTIYDN4FMYbWgom1JvgWPzhoy7PDm9CXVOxuRc/1
         3it3l+JHbCxnY+H8XUPH+kQIWcQoibOYBLh1j2Kx1jRP6NqaC6evVxGsku8eCDIw2IPz
         UzDfs3TbOUzSodHHf8MZauZr2+j0cUPjdrjMpBKGc6i9WpLdNaiefbOY1xJMS4qiUZtf
         iWF79KCW4sZdK0OV5dgJTCa5ai3XtWty7hk/TKGGYr/RomzbNFeVK5h2/7V4MUbuJBxk
         LP2w==
X-Forwarded-Encrypted: i=1; AJvYcCXyJLRQsjw8YbO7jLj3cPBBtkAUE6ewB/X2oyVBDoJsV+IgleClWNTDvQBJncQFjEqTykcjBu3oqg==@kvack.org
X-Gm-Message-State: AOJu0Yz6QXGUO4OgMLLA85yfexPgwOJnihgNleMyB9qM4gkkEAY50nUl
	+l8jcrRn1t/WFH0gq/XyFAPIjflOnOV9ATbWuv9R3cw7d8znffYbHPzYf/6YGZB859ZkBETDL8w
	o4A4ayC2XHo4q4eJCIXrlrMBuviJos62TqyzWBuZuO2TFDhhuMiKn
X-Gm-Gg: ASbGncvcNZIJSkLeZqZA8L9ssrZ1cB1M9D+sQ9vOriLTB5y/bFSeQCGSfxxWiOFBmO+
	O8SQwA9wojUgYBJGnve3u4vO5x7Wc99MuP+6Hmu/WOiA2aaDq2//eECayHeeYu7g1V/I6uujxWv
	ARSqIgiI2+fxCjU8U+M7/DY83aptfUzc5D6OIoAaFnCPz+gc7MoguEVQ/iLP9diHYFWsUD9rTac
	m646hTPKW3/F+lnsm9CCAHUCfCgA9vvuP+bgH4iAyGEzHtZAuoiPFmcea9f2Kdcv29G2at9Ga36
	4de87RblC3oDv4MkI/CGJ0hDR4BZ5QaxVHY8Z/GnqJ7AHnZ8h+pPkG2Vt4iFOczZkaMkAwil45q
	3bunC/6i5lZW22uftcKzg/PV6XyQ1n/d8sgPOCz5cHK/UyehvCoLYT/C/sKkKCgF6bnE=
X-Received: by 2002:a05:600c:a08e:b0:456:1bae:5478 with SMTP id 5b1f17b1804b1-4589e542946mr39849295e9.2.1753965173781;
        Thu, 31 Jul 2025 05:32:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHqPdK1HIAKcEfmq+fbsvVkp1hlDSykzNhblm5kMJdMAYSo5ujno3Ica21c+1mqrxgTAIcyiw==
X-Received: by 2002:a05:600c:a08e:b0:456:1bae:5478 with SMTP id 5b1f17b1804b1-4589e542946mr39848815e9.2.1753965173285;
        Thu, 31 Jul 2025 05:32:53 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f44:3700:be07:9a67:67f7:24e6? (p200300d82f443700be079a6767f724e6.dip0.t-ipconnect.de. [2003:d8:2f44:3700:be07:9a67:67f7:24e6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4589ee5790dsm24755265e9.27.2025.07.31.05.32.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Jul 2025 05:32:51 -0700 (PDT)
Message-ID: <ce3e6955-4a4c-4cb6-8dca-9f15807b6165@redhat.com>
Date: Thu, 31 Jul 2025 14:32:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 02/11] mm/thp: zone_device awareness in THP handling code
To: Zi Yan <ziy@nvidia.com>
Cc: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Shuah Khan <shuah@kernel.org>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
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
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <EC99D49E-86FF-4A50-A1AA-FC43A7D3716C@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MXFKnxOswlWdOdEQaJC6jxKctAX9wYUnl30hsNst6l0_1753965174
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 776EF80004
X-Stat-Signature: h764dc3w6aebw5rth7diqj8ic9ujwhb9
X-Rspam-User: 
X-HE-Tag: 1753965177-12238
X-HE-Meta: U2FsdGVkX1+8TUfGnlOK7fiWLB8eMDJH6yQFHGBZJSl9lZf8Pv/RrALhB+ZRhqmRLvlUc1Nadb7vCkLv9jx0zAE8+PmK1sz1gte3c2keZso0nuMf9fmfHmoQruQZlj0U7zWarb5oO7agZ6ApCthPPPVArWNj6hEYCMO48RZVjNZpUOjhO415oyLXbcMDaoeJ8dkiRCC4FrKZe7KPu8JHHe70PNHEF6LpmAzDRPyIZsWmIdts7sjfn2VlJE0HWImpdqz6utZ2n62b6QbrAzMaaxxS++vfvRduI67vvKCRGYnuBKTTXfORkJ2GK+dvcJrb0T4CAbIZIGONHlppQrq1DxFmqlWNpWVl6WLjlqNk5FvDB3Ox2lfivmwSmC0Qe2hJxtIFN5x6LrZuISC8kNfTB+ukEJuIKO2vwK3Gmueh6FsR9jvowqj0NYOvFKoTv/FSOMkDfpLOaMS0YaQnVOgrV5gio8rjzOMgctxzKqiD2e+f52oXCMLRrjwUDpG//igHUSw+yQE8zvuWWCCCSBVSUXoM5ZD7KkwlgohZPSRh5eqrlWLX2vVWlXW5wIqPliVeGO1/pdEK25g29adkX1ZDdQtzB/4uvccKghLVA3zXgql5gJvkwOTMBixjyHiFuphNVz0Hjvf2MdpZ9kjYb8XHpumQFJ/YXYzw0CJJebXcbtWL1J4d3E8vKVow40wPPDtATV9xN3q+lb9l87oxxY+6GbK0VrQbWvI1lK3uirM+rJL7Nmge1ZkpR8yL+vCBj3z2x2e7Wj3NBsAX9obJq+rrOERSQi4YUWUWSKEmKafENDJkcE6RBAl4EcrMRDHW3rIEF/FnOnSJgZetm+csToiCKP3SPUoScUMz6kU1sDSORUQO+wFE7LtUUDewCLlRAAgTiLeHktDlLBbMnaqgV6MY4qEVAKkrAabefLhpXSWJ9814y3N87QpJvhsOIdZqyPmI1bu0uvLIpl9Wf8MIxu7
 ijwuEtim
 nx8TXSBMUWJBE9N1W7hgW0wTA/iOUy6RQn0O28YRO6O6YmNn+JJ9KypOlseV6Zo3M9ESC912o8kVB1BAleaxSLQakNITXM1Cwe4e8KBLKJa79G7nAmV/PKVOonvO6ZZXFSYu61hWCi0rgdfkb7u8bNsMvFfzEXyOMQYLdPZKh+RgmCA72yrYa5ok4slsBoFpFnQvfuTwpsWDNx2Me/I94s43f1s+pKpZh9M9rLUs6TnfXSgqVmXmFk08/BJwJHd0xtmTiSlfLyNumAQSENRJVanLV5EdIZv541IpgILceNgETgfGVIzdkaEG3jmjP0vFda2JC3bgDORcrpL3vlo24GAv9KrbYPH4alZFnQ8f7pr5pDHmQcmoCBNlQJZ6DwITqtiJ/tbQ5KsS0q7yNTjtq3YnmKz+i2sZkm1v1q0EZRpn3d6+zD6FPuppY+5jgTVLkUUomtq8WbxuNlQG+bpcqsGFw5zMk/ZAo4SXZDBvfC+7GntEX12G+4ESaMemOW7SiVJI5fHatQXCfIW+xtZomplti3wXTjg7+lFdwkAymsyNo6Y9ZIYpSj5yWhh1D1IhYpKECT3PuX+IezGAwHoyAA18abOJ4Tblc7eeMfFIt+ZQ9pM1liu2t4xmirLdjpPW38567NWuJJaIFhbJddrSyS/J6EV0A6912ltqDuYoMMDUnm8iWZ+De0dohc9kYFz2YPopYWxKXVQ1Ayo79olrCONI84rQUTrAMx2o4qfymTG01ZNFCEbcjqun6+6B9j7tD4J9xF2g8WKhVVbq1ZbF3zqAQLDACML1QYUpi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31.07.25 13:26, Zi Yan wrote:
> On 31 Jul 2025, at 3:15, David Hildenbrand wrote:
> 
>> On 30.07.25 18:29, Mika Penttilä wrote:
>>>
>>> On 7/30/25 18:58, Zi Yan wrote:
>>>> On 30 Jul 2025, at 11:40, Mika Penttilä wrote:
>>>>
>>>>> On 7/30/25 18:10, Zi Yan wrote:
>>>>>> On 30 Jul 2025, at 8:49, Mika Penttilä wrote:
>>>>>>
>>>>>>> On 7/30/25 15:25, Zi Yan wrote:
>>>>>>>> On 30 Jul 2025, at 8:08, Mika Penttilä wrote:
>>>>>>>>
>>>>>>>>> On 7/30/25 14:42, Mika Penttilä wrote:
>>>>>>>>>> On 7/30/25 14:30, Zi Yan wrote:
>>>>>>>>>>> On 30 Jul 2025, at 7:27, Zi Yan wrote:
>>>>>>>>>>>
>>>>>>>>>>>> On 30 Jul 2025, at 7:16, Mika Penttilä wrote:
>>>>>>>>>>>>
>>>>>>>>>>>>> Hi,
>>>>>>>>>>>>>
>>>>>>>>>>>>> On 7/30/25 12:21, Balbir Singh wrote:
>>>>>>>>>>>>>> Make THP handling code in the mm subsystem for THP pages aware of zone
>>>>>>>>>>>>>> device pages. Although the code is designed to be generic when it comes
>>>>>>>>>>>>>> to handling splitting of pages, the code is designed to work for THP
>>>>>>>>>>>>>> page sizes corresponding to HPAGE_PMD_NR.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Modify page_vma_mapped_walk() to return true when a zone device huge
>>>>>>>>>>>>>> entry is present, enabling try_to_migrate() and other code migration
>>>>>>>>>>>>>> paths to appropriately process the entry. page_vma_mapped_walk() will
>>>>>>>>>>>>>> return true for zone device private large folios only when
>>>>>>>>>>>>>> PVMW_THP_DEVICE_PRIVATE is passed. This is to prevent locations that are
>>>>>>>>>>>>>> not zone device private pages from having to add awareness. The key
>>>>>>>>>>>>>> callback that needs this flag is try_to_migrate_one(). The other
>>>>>>>>>>>>>> callbacks page idle, damon use it for setting young/dirty bits, which is
>>>>>>>>>>>>>> not significant when it comes to pmd level bit harvesting.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> pmd_pfn() does not work well with zone device entries, use
>>>>>>>>>>>>>> pfn_pmd_entry_to_swap() for checking and comparison as for zone device
>>>>>>>>>>>>>> entries.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Zone device private entries when split via munmap go through pmd split,
>>>>>>>>>>>>>> but need to go through a folio split, deferred split does not work if a
>>>>>>>>>>>>>> fault is encountered because fault handling involves migration entries
>>>>>>>>>>>>>> (via folio_migrate_mapping) and the folio sizes are expected to be the
>>>>>>>>>>>>>> same there. This introduces the need to split the folio while handling
>>>>>>>>>>>>>> the pmd split. Because the folio is still mapped, but calling
>>>>>>>>>>>>>> folio_split() will cause lock recursion, the __split_unmapped_folio()
>>>>>>>>>>>>>> code is used with a new helper to wrap the code
>>>>>>>>>>>>>> split_device_private_folio(), which skips the checks around
>>>>>>>>>>>>>> folio->mapping, swapcache and the need to go through unmap and remap
>>>>>>>>>>>>>> folio.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Cc: Karol Herbst <kherbst@redhat.com>
>>>>>>>>>>>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>>>>>>>>>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>>>>>>>>>>>> Cc: David Airlie <airlied@gmail.com>
>>>>>>>>>>>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>>>>>>>>>>>> Cc: "Jérôme Glisse" <jglisse@redhat.com>
>>>>>>>>>>>>>> Cc: Shuah Khan <shuah@kernel.org>
>>>>>>>>>>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>>>>>>>>>>> Cc: Barry Song <baohua@kernel.org>
>>>>>>>>>>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>>>>>>>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>>>>>>>>>>>> Cc: Matthew Wilcox <willy@infradead.org>
>>>>>>>>>>>>>> Cc: Peter Xu <peterx@redhat.com>
>>>>>>>>>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>>>>>>>>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>>>>>>>>>>> Cc: Jane Chu <jane.chu@oracle.com>
>>>>>>>>>>>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>>>>>>>>>>>> Cc: Donet Tom <donettom@linux.ibm.com>
>>>>>>>>>>>>>> Cc: Mika Penttilä <mpenttil@redhat.com>
>>>>>>>>>>>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>>>>>>>>>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>>>>>>>>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>>>>>>>>>>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>>>>>>>>>>> ---
>>>>>>>>>>>>>>    include/linux/huge_mm.h |   1 +
>>>>>>>>>>>>>>    include/linux/rmap.h    |   2 +
>>>>>>>>>>>>>>    include/linux/swapops.h |  17 +++
>>>>>>>>>>>>>>    mm/huge_memory.c        | 268 +++++++++++++++++++++++++++++++++-------
>>>>>>>>>>>>>>    mm/page_vma_mapped.c    |  13 +-
>>>>>>>>>>>>>>    mm/pgtable-generic.c    |   6 +
>>>>>>>>>>>>>>    mm/rmap.c               |  22 +++-
>>>>>>>>>>>>>>    7 files changed, 278 insertions(+), 51 deletions(-)
>>>>>>>>>>>>>>
>>>>>>>>>>>> <snip>
>>>>>>>>>>>>
>>>>>>>>>>>>>> +/**
>>>>>>>>>>>>>> + * split_huge_device_private_folio - split a huge device private folio into
>>>>>>>>>>>>>> + * smaller pages (of order 0), currently used by migrate_device logic to
>>>>>>>>>>>>>> + * split folios for pages that are partially mapped
>>>>>>>>>>>>>> + *
>>>>>>>>>>>>>> + * @folio: the folio to split
>>>>>>>>>>>>>> + *
>>>>>>>>>>>>>> + * The caller has to hold the folio_lock and a reference via folio_get
>>>>>>>>>>>>>> + */
>>>>>>>>>>>>>> +int split_device_private_folio(struct folio *folio)
>>>>>>>>>>>>>> +{
>>>>>>>>>>>>>> +	struct folio *end_folio = folio_next(folio);
>>>>>>>>>>>>>> +	struct folio *new_folio;
>>>>>>>>>>>>>> +	int ret = 0;
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>> +	/*
>>>>>>>>>>>>>> +	 * Split the folio now. In the case of device
>>>>>>>>>>>>>> +	 * private pages, this path is executed when
>>>>>>>>>>>>>> +	 * the pmd is split and since freeze is not true
>>>>>>>>>>>>>> +	 * it is likely the folio will be deferred_split.
>>>>>>>>>>>>>> +	 *
>>>>>>>>>>>>>> +	 * With device private pages, deferred splits of
>>>>>>>>>>>>>> +	 * folios should be handled here to prevent partial
>>>>>>>>>>>>>> +	 * unmaps from causing issues later on in migration
>>>>>>>>>>>>>> +	 * and fault handling flows.
>>>>>>>>>>>>>> +	 */
>>>>>>>>>>>>>> +	folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
>>>>>>>>>>>>> Why can't this freeze fail? The folio is still mapped afaics, why can't there be other references in addition to the caller?
>>>>>>>>>>>> Based on my off-list conversation with Balbir, the folio is unmapped in
>>>>>>>>>>>> CPU side but mapped in the device. folio_ref_freeeze() is not aware of
>>>>>>>>>>>> device side mapping.
>>>>>>>>>>> Maybe we should make it aware of device private mapping? So that the
>>>>>>>>>>> process mirrors CPU side folio split: 1) unmap device private mapping,
>>>>>>>>>>> 2) freeze device private folio, 3) split unmapped folio, 4) unfreeze,
>>>>>>>>>>> 5) remap device private mapping.
>>>>>>>>>> Ah ok this was about device private page obviously here, nevermind..
>>>>>>>>> Still, isn't this reachable from split_huge_pmd() paths and folio is mapped to CPU page tables as a huge device page by one or more task?
>>>>>>>> The folio only has migration entries pointing to it. From CPU perspective,
>>>>>>>> it is not mapped. The unmap_folio() used by __folio_split() unmaps a to-be-split
>>>>>>>> folio by replacing existing page table entries with migration entries
>>>>>>>> and after that the folio is regarded as “unmapped”.
>>>>>>>>
>>>>>>>> The migration entry is an invalid CPU page table entry, so it is not a CPU
>>>>>>> split_device_private_folio() is called for device private entry, not migrate entry afaics.
>>>>>> Yes, but from CPU perspective, both device private entry and migration entry
>>>>>> are invalid CPU page table entries, so the device private folio is “unmapped”
>>>>>> at CPU side.
>>>>> Yes both are "swap entries" but there's difference, the device private ones contribute to mapcount and refcount.
>>>> Right. That confused me when I was talking to Balbir and looking at v1.
>>>> When a device private folio is processed in __folio_split(), Balbir needed to
>>>> add code to skip CPU mapping handling code. Basically device private folios are
>>>> CPU unmapped and device mapped.
>>>>
>>>> Here are my questions on device private folios:
>>>> 1. How is mapcount used for device private folios? Why is it needed from CPU
>>>>      perspective? Can it be stored in a device private specific data structure?
>>>
>>> Mostly like for normal folios, for instance rmap when doing migrate. I think it would make
>>> common code more messy if not done that way but sure possible.
>>> And not consuming pfns (address space) at all would have benefits.
>>>
>>>> 2. When a device private folio is mapped on device, can someone other than
>>>>      the device driver manipulate it assuming core-mm just skips device private
>>>>      folios (barring the CPU access fault handling)?
>>>>
>>>> Where I am going is that can device private folios be treated as unmapped folios
>>>> by CPU and only device driver manipulates their mappings?
>>>>
>>> Yes not present by CPU but mm has bookkeeping on them. The private page has no content
>>> someone could change while in device, it's just pfn.
>>
>> Just to clarify: a device-private entry, like a device-exclusive entry, is a *page table mapping* tracked through the rmap -- even though they are not present page table entries.
>>
>> It would be better if they would be present page table entries that are PROT_NONE, but it's tricky to mark them as being "special" device-private, device-exclusive etc. Maybe there are ways to do that in the future.
>>
>> Maybe device-private could just be PROT_NONE, because we can identify the entry type based on the folio. device-exclusive is harder ...
>>
>>
>> So consider device-private entries just like PROT_NONE present page table entries. Refcount and mapcount is adjusted accordingly by rmap functions.
> 
> Thanks for the clarification.
> 
> So folio_mapcount() for device private folios should be treated the same
> as normal folios, even if the corresponding PTEs are not accessible from CPUs.
> Then I wonder if the device private large folio split should go through
> __folio_split(), the same as normal folios: unmap, freeze, split, unfreeze,
> remap. Otherwise, how can we prevent rmap changes during the split?

That is what I would expect: Replace device-private by migration 
entries, perform the migration/split/whatever, restore migration entries 
to device-private entries.

That will drive the mapcount to 0.

-- 
Cheers,

David / dhildenb


