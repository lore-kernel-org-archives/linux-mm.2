Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AAAFC87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 23:26:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A5638E0002; Mon,  4 Aug 2025 19:26:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17D0C8E0001; Mon,  4 Aug 2025 19:26:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 092D18E0002; Mon,  4 Aug 2025 19:26:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EDF2D8E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 19:26:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9AA2CBC3B8
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 23:26:26 +0000 (UTC)
X-FDA: 83740661172.10.9D880AB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1FA4112000A
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 23:26:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a4CtA8AV;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754349984; a=rsa-sha256;
	cv=none;
	b=n0GBL50SN/9IrQDSa81E9ls5D1qqZfmEbyLVGMygQ53P4giJMnf2ZSwj1fADk4pb3AV8we
	WksNPfVcw3hUjD0XxOLSXNU1Cc60ezPxW8CLM9ELxkcsEyou4lIdgmjcFHZ7JtgIXg9IlN
	DihazT0eLi/3Fm5AezoFlN/xPLEmfB8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a4CtA8AV;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754349984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R/sBgf25KIq4XBstQtvrTp9uQy+iKraytiBJrmYqeow=;
	b=FCZllFCCiCgu7IVIba+gRYM82f9cjNrmf5ttjdIrCuG+TjE6B5Xvlplpb0Ee9JiZsp5Qj5
	LSgWksIrEYQVsSKJWo4JD37ZSF/bXESzrncVqLZkikCOiUdrrYhjvyLuBR7hWnXM09Z2u1
	ZVUMLvwoL/5CHWc3CPbYRCUQSDYlFao=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754349983;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R/sBgf25KIq4XBstQtvrTp9uQy+iKraytiBJrmYqeow=;
	b=a4CtA8AVzhjcZwTcq23CvyCmV8sRi1ylkp93Gh+gr+rS6P+oIoIMD0yOoRMIJ2pU0dG8aD
	aOdsKOzykShszVab2+txoPzHZ+yQHkTdjFh29UETjB8mDX1vT5lq8SkCUxrfEMZLe72KoS
	D1rFCq74IXYffSaq+BKI1xTMav2Q4fI=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-505-vLFipnzLOpunVZLy_L5i4g-1; Mon, 04 Aug 2025 19:26:22 -0400
X-MC-Unique: vLFipnzLOpunVZLy_L5i4g-1
X-Mimecast-MFC-AGG-ID: vLFipnzLOpunVZLy_L5i4g_1754349981
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-55ba07af930so758384e87.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 16:26:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754349980; x=1754954780;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R/sBgf25KIq4XBstQtvrTp9uQy+iKraytiBJrmYqeow=;
        b=eqyLlMY3dJoWy6W20w9V8cBhc7PooFdocoHLU0/rc25M+Ee+ztgsym2++HN1RD9mZw
         hMcxezpt7n7U+PmIYZdPsO4OJGEnfkfvz2tAVz9Rj9ECrdQ6v7kRSqCYo2zlt/zIe6Zx
         L+sI/VuuDolHvchPF/ysZJsJm6u3mNPjppDmFUEW97oZRK6pcRwgQtxKMTnAGsMnz2tl
         4hjhdeiA4tI7xZjhGs/gPkzLLYgkNkPLYr9sxFMO4xXZKC0isENXLzrXW/GG1N04jxwc
         DWiyWDoEBUZtJmIjjGfSjw9EvKji11JHNc0AS9BM8mGZXhser/XQqNvqoFVrYF1r5uQg
         aitg==
X-Forwarded-Encrypted: i=1; AJvYcCUJgKJEWY9uWOTQOOfk5KHyFWqGZkP8k8IdUsyHeRJ8M7nE0taWX7FuPAt7olGuglFrvQUpGT64rQ==@kvack.org
X-Gm-Message-State: AOJu0YwZ396Xcm/8JxcgXBzhIczLQoSBWhG/SOjPObw3RE90CFET/UUi
	vDCBdiOjM4qTcYJCNl6UE3FdIH599ENYv9D7VGHIzZ49rpEOs4vyX9Gklg/qVwJsxuXjjaqdZYN
	ftyr5aZ8R/WWyoUMfpTjsULAotj2V5YE4SE7t8VtCfJpNmMee3Cw=
X-Gm-Gg: ASbGnctPmUb522oEw2i+SLsB2QaOwqbMB/+csHsOIzxu8MyL25hvxPQrroYgiKqwb1F
	oaplZ1/5P/mj6SyT3XwZYc4UJiXqLXm8fVxULEFy6I1a/fUGjXC/DbxTQJH3rh0GXxiwae6X0ne
	A/oKXm3QORdaDDTztMl1Jj81MqS2+5s1vGQvbfq7Q2FHUGODEl6YvfiY9d5JVLqA5gYvvV3uZ91
	vF0kZxkxHTmwWcZRXaIozNrRwiiMu0Wvmb/eNYTbljaggR9qgkIr8ybTz85dhWLyIauSAK026di
	xxF2VxXMkQYbWaWvi23YHOkfMW5UrHTjgoFB2+b/z43YwXmZm8tQrZkiniCYYbY9sw==
X-Received: by 2002:a05:6512:23a4:b0:553:330e:59da with SMTP id 2adb3069b0e04-55b97b89868mr2555453e87.53.1754349980394;
        Mon, 04 Aug 2025 16:26:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG1D8tWyEanLpTzMQeGxRzjxvdlufa89z+Ilb+5E9xvkQMSDXbSWzpAcuwoogYf/bOzIKwKyA==
X-Received: by 2002:a05:6512:23a4:b0:553:330e:59da with SMTP id 2adb3069b0e04-55b97b89868mr2555448e87.53.1754349979882;
        Mon, 04 Aug 2025 16:26:19 -0700 (PDT)
Received: from [192.168.1.86] (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b889ac4dbsm1777116e87.63.2025.08.04.16.26.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 16:26:18 -0700 (PDT)
Message-ID: <196f11f8-1661-40d2-b6b7-64958efd8b3b@redhat.com>
Date: Tue, 5 Aug 2025 02:26:17 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 02/11] mm/thp: zone_device awareness in THP handling code
To: Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
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
 <8E2CE1DF-4C37-4690-B968-AEA180FF44A1@nvidia.com>
 <2308291f-3afc-44b4-bfc9-c6cf0cdd6295@redhat.com>
 <9FBDBFB9-8B27-459C-8047-055F90607D60@nvidia.com>
 <11ee9c5e-3e74-4858-bf8d-94daf1530314@redhat.com>
 <b5fa0989-a64a-4c91-ac34-6fb29ee6d132@redhat.com>
 <EC99D49E-86FF-4A50-A1AA-FC43A7D3716C@nvidia.com>
 <14aeaecc-c394-41bf-ae30-24537eb299d9@nvidia.com>
 <e5dd3f46-c063-45ff-8be7-64ac92534985@redhat.com>
 <71c736e9-eb77-4e8e-bd6a-965a1bbcbaa8@nvidia.com>
 <edbe38d4-3489-4c83-80fb-dc96a7684294@redhat.com>
 <e8f867cf-67f1-413a-a775-835a32861164@nvidia.com>
 <ee06bd19-4831-493f-ae88-f1d8a2fe9fa4@redhat.com>
 <47BC6D8B-7A78-4F2F-9D16-07D6C88C3661@nvidia.com>
 <2406521e-f5be-474e-b653-e5ad38a1d7de@redhat.com>
 <A813C8B0-325E-44F0-8E30-3D0CBACB6BE1@nvidia.com>
 <ab46303e-a891-4f48-8a86-964155a1073d@nvidia.com>
 <920a4f98-a925-4bd6-ad2e-ae842f2f3d94@redhat.com>
 <f3e85850-bc5b-461a-9efc-d1961fb5d340@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <f3e85850-bc5b-461a-9efc-d1961fb5d340@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UqBmPHpxZk3U-jEtU5WMKSgUtUGLEL3ns_xqO2AfbJA_1754349981
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fw7xr1e78d9zbsbwdtkcwqkqscwpfc73
X-Rspam-User: 
X-Rspamd-Queue-Id: 1FA4112000A
X-Rspamd-Server: rspam02
X-HE-Tag: 1754349983-668306
X-HE-Meta: U2FsdGVkX1+RMgviu77lNct8ewpj3AiealDNEAMQv8cyktXPXJz+82VAjCOtPkmdiNDMmZ6aVk9jNDXklGUIyG8JLtqb8++HYpSZoy8HwcuCGgOXjNPl7Xd7YmgZC0FkDrP/45ZkYqJ3jBvBvIlA7AmojNd6AyNKYIZS/wdVPyvHBXvShVDlTllxzB1WBeO83OeJ7DOIRepdFT4Ytxw2NlXx8vYY7phAvorVVcCRg9RBRddXopsuh0kDt5gVqGbtjQpDyyBIGQCj8ahG5vafx8sxk1Mc/Lb8/V5lKbUGvKi9LnN/8Wp6hQsjVFio0DwXAtVDvILdSwNG84yv94rdkE9ItXgG+TFp2iB//7Sty2A41cxe35kKI6bBLYckdFHuA/x05kl8dqNeOVHd4mV2MEEfJWXodI6IsFxp8MN66lAUTYlYnFirpci82G5LOl60eG36Zyzc+tEcgpf2prjh5kxHLQZC4ox91/K5CJNqlqRYeQ+QPtF3VF8X+/gAWEU8x/TduvbpRwwY0s3xO9w2pdEz5lt0qP52VJ0doyqwcRVy42Te9TRahlft6VsFIBF/4pB35qtfP2f9TTftqCPdejj0AIyXmxVzLCB6TW7+HmtF6Maw6fKWoQSkKW6AvC9YoBIFG/JR5U0/XfVy5LpbpbJt6TcNxBsQtStElW2zwLBqEzlRDXjcE29YOdIztkL+8JjLhxaQeAaGyVe98z3+nMdPzNgGr30YJksI4412MSz6z8ZT8jLhDOT94N6KpzoSmfL2lLI+bRhsZy7VMQr+aHtFuLxD2x8J2yYjtF7R1EOkTxH4S1kWEwBydJTbeR3hEibZH65ghjIAM0Bw5aVo5HHWAQoTUsVNoXUmHw4d/iElgJKa4ya9fYdeuJe/yHgKiC0XlgmInj3PpiE7eFbu6nevr3Ys0vtFwkd+qKgOsbQCXto7XxautXznJl+wYM/aNho9jOqX+RPOr7hU5De
 mDTLsh2W
 amUT+A5y36J2k5m91NM96G8w0T6LkYkgiEMnX3dyiS4H5mBOMO0lP0D8XhZ5LCYx6m/PqY+Hp86SfjBwc0HWQzy3ujYJAFtzojA4iiTCOM1AGbwIy4yzVtDOV+/WIqMsk2cg68NbPJMTJch51M4k0GBvRH1ShlnDq9kuficwkfA4nkSCmvpzHYbBbxSML4DfEdXmN9ikakj4aP8n9bKlyGSUjrEN1Sa3ENWjLSeN1qHwpieVEkwGr9FBrD7G8QQ063QvJCa87L0L7iGep6/PLVDrNHsVETPW5jiucduiHDprBRqQJOPrhB2lgeMDB9Q3q+V5sKHQAcO0lgevKqVS9bpZkNMBl/9Ovp6covqCkp+yAOZSjlSW4zcutoJhWMnpoK6eOpSr5Va2m3OT75pbJvAbqB4gWEN0NkSyErTyMT1f0KkqPhaV2+50Ri8bTU04bEyWQ/uhYW2sFk1x/Vs6Z7j4mg1z/LO80CUA8A+zaAFV901halPeZ/FVRppGc89JwbpZa6dO4CzVc4viPg5ZZI3sUZh++7OfJFqSX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 8/5/25 01:46, Balbir Singh wrote:
> On 8/2/25 22:13, Mika Penttilä wrote:
>> Hi,
>>
>> On 8/2/25 13:37, Balbir Singh wrote:
>>> FYI:
>>>
>>> I have the following patch on top of my series that seems to make it work
>>> without requiring the helper to split device private folios
>>>
>> I think this looks much better!
>>
> Thanks!
>
>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>> ---
>>>  include/linux/huge_mm.h |  1 -
>>>  lib/test_hmm.c          | 11 +++++-
>>>  mm/huge_memory.c        | 76 ++++-------------------------------------
>>>  mm/migrate_device.c     | 51 +++++++++++++++++++++++++++
>>>  4 files changed, 67 insertions(+), 72 deletions(-)
>>>
>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>> index 19e7e3b7c2b7..52d8b435950b 100644
>>> --- a/include/linux/huge_mm.h
>>> +++ b/include/linux/huge_mm.h
>>> @@ -343,7 +343,6 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
>>>  		vm_flags_t vm_flags);
>>>  
>>>  bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
>>> -int split_device_private_folio(struct folio *folio);
>>>  int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>>>  		unsigned int new_order, bool unmapped);
>>>  int min_order_for_split(struct folio *folio);
>>> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
>>> index 341ae2af44ec..444477785882 100644
>>> --- a/lib/test_hmm.c
>>> +++ b/lib/test_hmm.c
>>> @@ -1625,13 +1625,22 @@ static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
>>>  	 * the mirror but here we use it to hold the page for the simulated
>>>  	 * device memory and that page holds the pointer to the mirror.
>>>  	 */
>>> -	rpage = vmf->page->zone_device_data;
>>> +	rpage = folio_page(page_folio(vmf->page), 0)->zone_device_data;
>>>  	dmirror = rpage->zone_device_data;
>>>  
>>>  	/* FIXME demonstrate how we can adjust migrate range */
>>>  	order = folio_order(page_folio(vmf->page));
>>>  	nr = 1 << order;
>>>  
>>> +	/*
>>> +	 * When folios are partially mapped, we can't rely on the folio
>>> +	 * order of vmf->page as the folio might not be fully split yet
>>> +	 */
>>> +	if (vmf->pte) {
>>> +		order = 0;
>>> +		nr = 1;
>>> +	}
>>> +
>>>  	/*
>>>  	 * Consider a per-cpu cache of src and dst pfns, but with
>>>  	 * large number of cpus that might not scale well.
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 1fc1efa219c8..863393dec1f1 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -72,10 +72,6 @@ static unsigned long deferred_split_count(struct shrinker *shrink,
>>>  					  struct shrink_control *sc);
>>>  static unsigned long deferred_split_scan(struct shrinker *shrink,
>>>  					 struct shrink_control *sc);
>>> -static int __split_unmapped_folio(struct folio *folio, int new_order,
>>> -		struct page *split_at, struct xa_state *xas,
>>> -		struct address_space *mapping, bool uniform_split);
>>> -
>>>  static bool split_underused_thp = true;
>>>  
>>>  static atomic_t huge_zero_refcount;
>>> @@ -2924,51 +2920,6 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
>>>  	pmd_populate(mm, pmd, pgtable);
>>>  }
>>>  
>>> -/**
>>> - * split_huge_device_private_folio - split a huge device private folio into
>>> - * smaller pages (of order 0), currently used by migrate_device logic to
>>> - * split folios for pages that are partially mapped
>>> - *
>>> - * @folio: the folio to split
>>> - *
>>> - * The caller has to hold the folio_lock and a reference via folio_get
>>> - */
>>> -int split_device_private_folio(struct folio *folio)
>>> -{
>>> -	struct folio *end_folio = folio_next(folio);
>>> -	struct folio *new_folio;
>>> -	int ret = 0;
>>> -
>>> -	/*
>>> -	 * Split the folio now. In the case of device
>>> -	 * private pages, this path is executed when
>>> -	 * the pmd is split and since freeze is not true
>>> -	 * it is likely the folio will be deferred_split.
>>> -	 *
>>> -	 * With device private pages, deferred splits of
>>> -	 * folios should be handled here to prevent partial
>>> -	 * unmaps from causing issues later on in migration
>>> -	 * and fault handling flows.
>>> -	 */
>>> -	folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
>>> -	ret = __split_unmapped_folio(folio, 0, &folio->page, NULL, NULL, true);
>>> -	VM_WARN_ON(ret);
>>> -	for (new_folio = folio_next(folio); new_folio != end_folio;
>>> -					new_folio = folio_next(new_folio)) {
>>> -		zone_device_private_split_cb(folio, new_folio);
>>> -		folio_ref_unfreeze(new_folio, 1 + folio_expected_ref_count(
>>> -								new_folio));
>>> -	}
>>> -
>>> -	/*
>>> -	 * Mark the end of the folio split for device private THP
>>> -	 * split
>>> -	 */
>>> -	zone_device_private_split_cb(folio, NULL);
>>> -	folio_ref_unfreeze(folio, 1 + folio_expected_ref_count(folio));
>>> -	return ret;
>>> -}
>>> -
>>>  static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>  		unsigned long haddr, bool freeze)
>>>  {
>>> @@ -3064,30 +3015,15 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>  				freeze = false;
>>>  			if (!freeze) {
>>>  				rmap_t rmap_flags = RMAP_NONE;
>>> -				unsigned long addr = haddr;
>>> -				struct folio *new_folio;
>>> -				struct folio *end_folio = folio_next(folio);
>>>  
>>>  				if (anon_exclusive)
>>>  					rmap_flags |= RMAP_EXCLUSIVE;
>>>  
>>> -				folio_lock(folio);
>>> -				folio_get(folio);
>>> -
>>> -				split_device_private_folio(folio);
>>> -
>>> -				for (new_folio = folio_next(folio);
>>> -					new_folio != end_folio;
>>> -					new_folio = folio_next(new_folio)) {
>>> -					addr += PAGE_SIZE;
>>> -					folio_unlock(new_folio);
>>> -					folio_add_anon_rmap_ptes(new_folio,
>>> -						&new_folio->page, 1,
>>> -						vma, addr, rmap_flags);
>>> -				}
>>> -				folio_unlock(folio);
>>> -				folio_add_anon_rmap_ptes(folio, &folio->page,
>>> -						1, vma, haddr, rmap_flags);
>>> +				folio_ref_add(folio, HPAGE_PMD_NR - 1);
>>> +				if (anon_exclusive)
>>> +					rmap_flags |= RMAP_EXCLUSIVE;
>>> +				folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
>>> +						 vma, haddr, rmap_flags);
>>>  			}
>>>  		}
>>>  
>>> @@ -4065,7 +4001,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>>  	if (nr_shmem_dropped)
>>>  		shmem_uncharge(mapping->host, nr_shmem_dropped);
>>>  
>>> -	if (!ret && is_anon)
>>> +	if (!ret && is_anon && !folio_is_device_private(folio))
>>>  		remap_flags = RMP_USE_SHARED_ZEROPAGE;
>>>  
>>>  	remap_page(folio, 1 << order, remap_flags);
>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>> index 49962ea19109..4264c0290d08 100644
>>> --- a/mm/migrate_device.c
>>> +++ b/mm/migrate_device.c
>>> @@ -248,6 +248,8 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>>  			 * page table entry. Other special swap entries are not
>>>  			 * migratable, and we ignore regular swapped page.
>>>  			 */
>>> +			struct folio *folio;
>>> +
>>>  			entry = pte_to_swp_entry(pte);
>>>  			if (!is_device_private_entry(entry))
>>>  				goto next;
>>> @@ -259,6 +261,55 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>>  			    pgmap->owner != migrate->pgmap_owner)
>>>  				goto next;
>>>  
>>> +			folio = page_folio(page);
>>> +			if (folio_test_large(folio)) {
>>> +				struct folio *new_folio;
>>> +				struct folio *new_fault_folio;
>>> +
>>> +				/*
>>> +				 * The reason for finding pmd present with a
>>> +				 * device private pte and a large folio for the
>>> +				 * pte is partial unmaps. Split the folio now
>>> +				 * for the migration to be handled correctly
>>> +				 */
>>> +				pte_unmap_unlock(ptep, ptl);
>>> +
>>> +				folio_get(folio);
>>> +				if (folio != fault_folio)
>>> +					folio_lock(folio);
>>> +				if (split_folio(folio)) {
>>> +					if (folio != fault_folio)
>>> +						folio_unlock(folio);
>>> +					ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
>>> +					goto next;
>>> +				}
>>> +
>> The nouveau migrate_to_ram handler needs adjustment also if split happens.
>>
> test_hmm needs adjustment because of the way the backup folios are setup.

nouveau should check the folio order after the possible split happens.

>
>>> +				/*
>>> +				 * After the split, get back the extra reference
>>> +				 * on the fault_page, this reference is checked during
>>> +				 * folio_migrate_mapping()
>>> +				 */
>>> +				if (migrate->fault_page) {
>>> +					new_fault_folio = page_folio(migrate->fault_page);
>>> +					folio_get(new_fault_folio);
>>> +				}
>>> +
>>> +				new_folio = page_folio(page);
>>> +				pfn = page_to_pfn(page);
>>> +
>>> +				/*
>>> +				 * Ensure the lock is held on the correct
>>> +				 * folio after the split
>>> +				 */
>>> +				if (folio != new_folio) {
>>> +					folio_unlock(folio);
>>> +					folio_lock(new_folio);
>>> +				}
>> Maybe careful not to unlock fault_page ?
>>
> split_page will unlock everything but the original folio, the code takes the lock
> on the folio corresponding to the new folio

I mean do_swap_page() unlocks folio of fault_page and expects it to remain locked.

>
>>> +				folio_put(folio);
>>> +				addr = start;
>>> +				goto again;
>>> +			}
>>> +
>>>  			mpfn = migrate_pfn(page_to_pfn(page)) |
>>>  					MIGRATE_PFN_MIGRATE;
>>>  			if (is_writable_device_private_entry(entry))
> Balbir
>
--Mika


