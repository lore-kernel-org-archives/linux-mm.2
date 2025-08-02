Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D643C87FD2
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 12:13:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF3026B0089; Sat,  2 Aug 2025 08:13:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA2A86B008A; Sat,  2 Aug 2025 08:13:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6A5E6B0092; Sat,  2 Aug 2025 08:13:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 93BDD6B0089
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 08:13:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07829C0343
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 12:13:43 +0000 (UTC)
X-FDA: 83731708326.20.FDA590D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id CFAD64000B
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 12:13:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b2EILeaR;
	spf=pass (imf07.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754136821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xyp8m8lS9VhgQmQLaOoHjEiaPk30EpYo8qfbtcybK1Q=;
	b=aGqPDsyUtX8P/c78dyIG+7OAdMk3VvD6kYyDvun5TrSn21WWjrvTBtCn3ZuH3CceGzJdhr
	LsWc5iJIUFUL594UUTU3bOtA2SUUn9TfzH9qgTG3wEpuwSslq21+YVExGg1HqIFuQCpD2f
	Qq3gkcMhAi+UCerkLH9Zrs5c/aXDKCM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754136821; a=rsa-sha256;
	cv=none;
	b=wVomW07yRvA/Dv8BMZ7llP/0sSmapcZpNUmul4DV7ZuZxPtZ3L3ti4pn8ukltCFAJThckI
	L2R8gDiAt+PWOP/luMoZzTbU17zL23W2yP72BR63SkNjmHpLyISYZdjqg8q3WXxEmaL5UV
	hT4E35uTcANdxNETp4Dd5+/sJbhDV7I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b2EILeaR;
	spf=pass (imf07.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754136820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xyp8m8lS9VhgQmQLaOoHjEiaPk30EpYo8qfbtcybK1Q=;
	b=b2EILeaRKHI0zsS7SipkVWktuny/Z1pOo/bvBISVQw9UddnPqeFAVAhRQ2FkrW+i5tzylk
	qJfF0z7S0MmK6EYv18uLgRwgxMQo3Pqj5u8pHW2JGclnd7ZnE0CAWnS2PT4t7JWmPfBk1J
	Rrkxwgl/CjBDkjuxIIyyj5kS/z26T9E=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-sEOlqPkcP1W4lSSoUO_5hQ-1; Sat, 02 Aug 2025 08:13:36 -0400
X-MC-Unique: sEOlqPkcP1W4lSSoUO_5hQ-1
X-Mimecast-MFC-AGG-ID: sEOlqPkcP1W4lSSoUO_5hQ_1754136815
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-55b958a091aso674797e87.3
        for <linux-mm@kvack.org>; Sat, 02 Aug 2025 05:13:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754136815; x=1754741615;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xyp8m8lS9VhgQmQLaOoHjEiaPk30EpYo8qfbtcybK1Q=;
        b=aADts63sVd4X+tehjDi8cNdN5XoGT9NnvLj6luVuSCEFvgXW39CQLGYlrI2gAwdL2n
         fJh8awjdeQr7yZyYlRwxMn7is5D9Q1ZBcUsrJ0q0Rt99RvC77MQAqvbcmTzEWxQKLTs4
         Q4OeTFx0EvSo5T5FEnMydx3JIkXmPz7Dq7w822Uip9uKlcD9YaNE21EDJEa8HXOcvjVh
         2tR9yOdvd7M51wid0uwzu27n3uNNIV2+B3ZrXIaw/JiPpjDoBNF44GXlHS37HvOBj81T
         JlynHkpsLBy+kRlA4jWzUqoY1WY39D4vbWKWZOIKXaVMTl3tT/QlXegnFZc9blrl+gHe
         R33g==
X-Forwarded-Encrypted: i=1; AJvYcCUpC1Y4dXmjENxWDIxb4j7JlpoJXLpvOd6QCdmztytkkSDYImbBur5+P/j/oK4z+imWQ/1l8jn4kA==@kvack.org
X-Gm-Message-State: AOJu0Ywg4axlXp7SVUpGNvSQpL38Xhf8aR5huybiYYsX4lsLEZ4RtWaa
	gFD66OvrZlzndl6PBtrvddq3vV8m/cpj2b8cMADu9jRWpt1oMPthwrDisgiWvPNaxrCHA1E0Q9i
	GfEkiEPRxse+kP1EWTC2VsHOWZXGYGSQeYZR5TzelqOAcsyEC0mg=
X-Gm-Gg: ASbGncvY3Xp+l979WysQua8/VR6ZH8wP8Nbz6nfLgigDsWFekBGe3XjhxHLImBdLRLO
	I0bVPKY0aw8+R0r6hSdQaDaGYRUJnV5CA/OzD/aCIz495f8R4gi0dzI0vbmPQDwDro/8JdSBPTK
	BHX+0gf5qkTZgz5akCogm1T4XNEYpg13wdDCK63iAsSUoDaxP79qWt3LIL7Oj98Gj5YksmO0ltT
	pdfyGB9kfCR0fAPp7IWOu6oB4A6TQjPgtPqRxYHEPtcjbhe/G6LRmwLHjj4IpokAIxuXfirjqw8
	jjxrePvPV2LbqcZ/pXMtRnU7p4cE74/CDhzuyDSvXQvSmXEK8Bs/qUozWIFxYsaThg==
X-Received: by 2002:a05:6512:4012:b0:55b:90ec:6ed8 with SMTP id 2adb3069b0e04-55b97b985a5mr752748e87.56.1754136815194;
        Sat, 02 Aug 2025 05:13:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHA7zdLNVZmeXzpW0GFByMMenAAShU9aB3wWw8n3CAeoSpzy34PgleHh6NJEtOiykr5mWWPvw==
X-Received: by 2002:a05:6512:4012:b0:55b:90ec:6ed8 with SMTP id 2adb3069b0e04-55b97b985a5mr752730e87.56.1754136814671;
        Sat, 02 Aug 2025 05:13:34 -0700 (PDT)
Received: from [192.168.1.86] (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b8898bd28sm972518e87.19.2025.08.02.05.13.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Aug 2025 05:13:33 -0700 (PDT)
Message-ID: <920a4f98-a925-4bd6-ad2e-ae842f2f3d94@redhat.com>
Date: Sat, 2 Aug 2025 15:13:33 +0300
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
 <edbe38d4-3489-4c83-80fb-dc96a7684294@redhat.com>
 <e8f867cf-67f1-413a-a775-835a32861164@nvidia.com>
 <ee06bd19-4831-493f-ae88-f1d8a2fe9fa4@redhat.com>
 <47BC6D8B-7A78-4F2F-9D16-07D6C88C3661@nvidia.com>
 <2406521e-f5be-474e-b653-e5ad38a1d7de@redhat.com>
 <A813C8B0-325E-44F0-8E30-3D0CBACB6BE1@nvidia.com>
 <ab46303e-a891-4f48-8a86-964155a1073d@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <ab46303e-a891-4f48-8a86-964155a1073d@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1YY1QfibhnpH7n9p36hRQHLSCgDnlpkr31r6Qr2gSf0_1754136815
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CFAD64000B
X-Stat-Signature: hj91jdyz19b56y86pr63i9wtut7hjycn
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754136820-73004
X-HE-Meta: U2FsdGVkX1/VFxF2uNg5524UMr3iMECWN4sHaOVjRU2daZwjSl5OiDEzG7Kl1HaDod4StQA1rtNoTBq9ogQw6U2+3yAXxVdhAiZHAVozzvXeGvHTmz2idYvvRySVN1dgBWgeVVDEJAzaLlgSE1tBYXoewYBDDP9a9GLouWidnM47asgY3xA2M/UsbS2eH7bu9+Hgov3HrBHgF1OweTZ+1Lx1GyUI5+HNGzVWR+bQY3fUmBZ0aNKCIlrebZILNf3m8nKWaSq7ZkUZfMgfoOBKQAvKPJihQZoTll3sylT8dUJxhqxeoZW9IwAza9o7Ux0bNgbjBLU4aO5mNZFe6Y9MRwjc26U1WSBOxPTWidwXvbbMRvj8pGzTKANsirIf1a47CE/f9Qnglo5kqvnb/UREm4cwiimL5FbNNPZUPax7h927KZhglAp+Cufu7wcpLUmHq20Zqogz+70I+40M3dWpCHjQGafpd2fWd929Ccc1Hzm8LiS5chktrJKy9OD6xfv+5ti/vPpfsMkNyHwrLzOV/ZAXWN82go0s+zyA9acvbFaRDYbCZSVPKRP7A+3U1e3i06Zqld0FFKO4RX9SQlCt7hGd1mmdqw8EgrAULdB4zwcakj8c+NGn4034W2L6zHPVUy1G0PoDPvtAymvw9jnuy7geCmicVLDOGDHJbzyYT99tzbM9slLXV+R8DmOU6p6YazpZT+HuLtVkL9GmE9lwDoi329ypF6YA9taZUvrDfqxQfCl+tmGx13zU09HlJkVYuc2KAEBWOrODPc6RmAaq2IVVune/ATtaQLxwAfvnRfXQERQXLZbIBDkJpirfJalE4bCPyi4ecO+Bg+89YTiE5npMwoOwGAXwhE+4IEtx8OpCQHCxMpPvjLAIFIIU+Osw4l3yOH3HMPi82lsxZsWVwJftwx9jD5xNsWIG51GMb/u8O2a7lV59fQDXdKut2KXT+w419buE5GyRnYOp0mx
 sHkJ74yw
 OvcDyaPCP+muh5Du9W/Ds9c00KLwxRGv4PyK0CSgIAGKMMc3YVL462BSaqAwPt6z7cdrhjbbKOFZXYLUSSebLElNb9O4o+wTXjiiCzL6vnN9259hwlLSP0t+xmLKASMcM+ChfPYk3pTNvtrZts62M52vIXGFXAu9PYelrVtq02KHj0m1q5pRvYUi7N1QJToRLO3l5BlSNWvPuUw8A61ijsqVNPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 8/2/25 13:37, Balbir Singh wrote:
> FYI:
>
> I have the following patch on top of my series that seems to make it work
> without requiring the helper to split device private folios
>
I think this looks much better!

> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> ---
>  include/linux/huge_mm.h |  1 -
>  lib/test_hmm.c          | 11 +++++-
>  mm/huge_memory.c        | 76 ++++-------------------------------------
>  mm/migrate_device.c     | 51 +++++++++++++++++++++++++++
>  4 files changed, 67 insertions(+), 72 deletions(-)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 19e7e3b7c2b7..52d8b435950b 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -343,7 +343,6 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
>  		vm_flags_t vm_flags);
>  
>  bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
> -int split_device_private_folio(struct folio *folio);
>  int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>  		unsigned int new_order, bool unmapped);
>  int min_order_for_split(struct folio *folio);
> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
> index 341ae2af44ec..444477785882 100644
> --- a/lib/test_hmm.c
> +++ b/lib/test_hmm.c
> @@ -1625,13 +1625,22 @@ static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
>  	 * the mirror but here we use it to hold the page for the simulated
>  	 * device memory and that page holds the pointer to the mirror.
>  	 */
> -	rpage = vmf->page->zone_device_data;
> +	rpage = folio_page(page_folio(vmf->page), 0)->zone_device_data;
>  	dmirror = rpage->zone_device_data;
>  
>  	/* FIXME demonstrate how we can adjust migrate range */
>  	order = folio_order(page_folio(vmf->page));
>  	nr = 1 << order;
>  
> +	/*
> +	 * When folios are partially mapped, we can't rely on the folio
> +	 * order of vmf->page as the folio might not be fully split yet
> +	 */
> +	if (vmf->pte) {
> +		order = 0;
> +		nr = 1;
> +	}
> +
>  	/*
>  	 * Consider a per-cpu cache of src and dst pfns, but with
>  	 * large number of cpus that might not scale well.
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 1fc1efa219c8..863393dec1f1 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -72,10 +72,6 @@ static unsigned long deferred_split_count(struct shrinker *shrink,
>  					  struct shrink_control *sc);
>  static unsigned long deferred_split_scan(struct shrinker *shrink,
>  					 struct shrink_control *sc);
> -static int __split_unmapped_folio(struct folio *folio, int new_order,
> -		struct page *split_at, struct xa_state *xas,
> -		struct address_space *mapping, bool uniform_split);
> -
>  static bool split_underused_thp = true;
>  
>  static atomic_t huge_zero_refcount;
> @@ -2924,51 +2920,6 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
>  	pmd_populate(mm, pmd, pgtable);
>  }
>  
> -/**
> - * split_huge_device_private_folio - split a huge device private folio into
> - * smaller pages (of order 0), currently used by migrate_device logic to
> - * split folios for pages that are partially mapped
> - *
> - * @folio: the folio to split
> - *
> - * The caller has to hold the folio_lock and a reference via folio_get
> - */
> -int split_device_private_folio(struct folio *folio)
> -{
> -	struct folio *end_folio = folio_next(folio);
> -	struct folio *new_folio;
> -	int ret = 0;
> -
> -	/*
> -	 * Split the folio now. In the case of device
> -	 * private pages, this path is executed when
> -	 * the pmd is split and since freeze is not true
> -	 * it is likely the folio will be deferred_split.
> -	 *
> -	 * With device private pages, deferred splits of
> -	 * folios should be handled here to prevent partial
> -	 * unmaps from causing issues later on in migration
> -	 * and fault handling flows.
> -	 */
> -	folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
> -	ret = __split_unmapped_folio(folio, 0, &folio->page, NULL, NULL, true);
> -	VM_WARN_ON(ret);
> -	for (new_folio = folio_next(folio); new_folio != end_folio;
> -					new_folio = folio_next(new_folio)) {
> -		zone_device_private_split_cb(folio, new_folio);
> -		folio_ref_unfreeze(new_folio, 1 + folio_expected_ref_count(
> -								new_folio));
> -	}
> -
> -	/*
> -	 * Mark the end of the folio split for device private THP
> -	 * split
> -	 */
> -	zone_device_private_split_cb(folio, NULL);
> -	folio_ref_unfreeze(folio, 1 + folio_expected_ref_count(folio));
> -	return ret;
> -}
> -
>  static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>  		unsigned long haddr, bool freeze)
>  {
> @@ -3064,30 +3015,15 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>  				freeze = false;
>  			if (!freeze) {
>  				rmap_t rmap_flags = RMAP_NONE;
> -				unsigned long addr = haddr;
> -				struct folio *new_folio;
> -				struct folio *end_folio = folio_next(folio);
>  
>  				if (anon_exclusive)
>  					rmap_flags |= RMAP_EXCLUSIVE;
>  
> -				folio_lock(folio);
> -				folio_get(folio);
> -
> -				split_device_private_folio(folio);
> -
> -				for (new_folio = folio_next(folio);
> -					new_folio != end_folio;
> -					new_folio = folio_next(new_folio)) {
> -					addr += PAGE_SIZE;
> -					folio_unlock(new_folio);
> -					folio_add_anon_rmap_ptes(new_folio,
> -						&new_folio->page, 1,
> -						vma, addr, rmap_flags);
> -				}
> -				folio_unlock(folio);
> -				folio_add_anon_rmap_ptes(folio, &folio->page,
> -						1, vma, haddr, rmap_flags);
> +				folio_ref_add(folio, HPAGE_PMD_NR - 1);
> +				if (anon_exclusive)
> +					rmap_flags |= RMAP_EXCLUSIVE;
> +				folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
> +						 vma, haddr, rmap_flags);
>  			}
>  		}
>  
> @@ -4065,7 +4001,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  	if (nr_shmem_dropped)
>  		shmem_uncharge(mapping->host, nr_shmem_dropped);
>  
> -	if (!ret && is_anon)
> +	if (!ret && is_anon && !folio_is_device_private(folio))
>  		remap_flags = RMP_USE_SHARED_ZEROPAGE;
>  
>  	remap_page(folio, 1 << order, remap_flags);
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 49962ea19109..4264c0290d08 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -248,6 +248,8 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  			 * page table entry. Other special swap entries are not
>  			 * migratable, and we ignore regular swapped page.
>  			 */
> +			struct folio *folio;
> +
>  			entry = pte_to_swp_entry(pte);
>  			if (!is_device_private_entry(entry))
>  				goto next;
> @@ -259,6 +261,55 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  			    pgmap->owner != migrate->pgmap_owner)
>  				goto next;
>  
> +			folio = page_folio(page);
> +			if (folio_test_large(folio)) {
> +				struct folio *new_folio;
> +				struct folio *new_fault_folio;
> +
> +				/*
> +				 * The reason for finding pmd present with a
> +				 * device private pte and a large folio for the
> +				 * pte is partial unmaps. Split the folio now
> +				 * for the migration to be handled correctly
> +				 */
> +				pte_unmap_unlock(ptep, ptl);
> +
> +				folio_get(folio);
> +				if (folio != fault_folio)
> +					folio_lock(folio);
> +				if (split_folio(folio)) {
> +					if (folio != fault_folio)
> +						folio_unlock(folio);
> +					ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
> +					goto next;
> +				}
> +

The nouveau migrate_to_ram handler needs adjustment also if split happens.

> +				/*
> +				 * After the split, get back the extra reference
> +				 * on the fault_page, this reference is checked during
> +				 * folio_migrate_mapping()
> +				 */
> +				if (migrate->fault_page) {
> +					new_fault_folio = page_folio(migrate->fault_page);
> +					folio_get(new_fault_folio);
> +				}
> +
> +				new_folio = page_folio(page);
> +				pfn = page_to_pfn(page);
> +
> +				/*
> +				 * Ensure the lock is held on the correct
> +				 * folio after the split
> +				 */
> +				if (folio != new_folio) {
> +					folio_unlock(folio);
> +					folio_lock(new_folio);
> +				}

Maybe careful not to unlock fault_page ?

> +				folio_put(folio);
> +				addr = start;
> +				goto again;
> +			}
> +
>  			mpfn = migrate_pfn(page_to_pfn(page)) |
>  					MIGRATE_PFN_MIGRATE;
>  			if (is_writable_device_private_entry(entry))

--Mika


