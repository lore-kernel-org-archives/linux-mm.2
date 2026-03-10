Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33EBDFCC9B2
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 03:32:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E7456B008C; Mon,  9 Mar 2026 23:32:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76B2D6B0093; Mon,  9 Mar 2026 23:32:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66DA36B0095; Mon,  9 Mar 2026 23:32:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 55DB86B008C
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 23:32:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E3F561C437
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:32:36 +0000 (UTC)
X-FDA: 84528731112.19.7126AEF
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0AE544000D
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:32:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=25WpgtJU;
	spf=pass (imf27.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773113553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ukfr+AuSSjalhcEuGd775EwrTPxyhTtDQGkfF9cnnoI=;
	b=KQIuYjuOK8/W9p4TBY2aFT+ogBnTviFhvzRMI8m55MeWRkeefowqXbIzxM0LHB4MuMNvSO
	j3VyyhgIy9JIb5KrLZ8Psr/Gi4Ks6uaaw2Ta0OqN9BAumn5zusxvHPVt3NZhfig2pqNdw5
	1PaJoNsLVBkUpYwxMWROGG6AlBelaVs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=25WpgtJU;
	spf=pass (imf27.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773113553; a=rsa-sha256;
	cv=none;
	b=6PbdqTZhw8W8+nad6MEjOZqftql05sZpatCcqXNvZuojKwqyBgawwrBEXopZAYtSeow892
	k8xFYUHiPN1BM3t5su19vwvxFz2DFGZW50XlO49yKpuKKl4R9W5FxTY9grNWhREGRESojz
	6Z8wYGBK9V/g4Zf4dpkXVmVx8xGVhBM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ukfr+AuSSjalhcEuGd775EwrTPxyhTtDQGkfF9cnnoI=;
	b=25WpgtJUdMU4EPFULH4K6br31HYc+68SzizJgcjOO0/WwTWrFm0I23gaAhtwXnemVVXog/D/6
	BKz/296PrNYryXCSs7MiOe69iLEyRVgoaq5Khg5lETGv3V86EtVXKGw/JnmgCWQ0KZKoJSPlifM
	iFUEDnQb9cUjb9lEiLhCOWk=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4fVK7D71ZgzcbS0;
	Tue, 10 Mar 2026 11:27:04 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 0A90840569;
	Tue, 10 Mar 2026 11:32:29 +0800 (CST)
Received: from [10.174.179.248] (10.174.179.248) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 10 Mar 2026 11:32:26 +0800
Message-ID: <875a5d1b-4bed-4f70-a122-acd625265bfa@huawei.com>
Date: Tue, 10 Mar 2026 11:32:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 2/4] mm/pgtable: Make pfn_pte() filter out huge
 page attributes
To: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>, Matthew Wilcox
	<willy@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <david@kernel.org>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <luto@kernel.org>, <peterz@infradead.org>,
	<akpm@linux-foundation.org>, <lorenzo.stoakes@oracle.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <Liam.Howlett@oracle.com>,
	<npache@redhat.com>, <ryan.roberts@arm.com>, <dev.jain@arm.com>,
	<baohua@kernel.org>, <lance.yang@linux.dev>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<anshuman.khandual@arm.com>, <rmclure@linux.ibm.com>,
	<kevin.brodsky@arm.com>, <apopple@nvidia.com>, <ajd@linux.ibm.com>,
	<pasha.tatashin@soleen.com>, <bhe@redhat.com>, <thuth@redhat.com>,
	<coxu@redhat.com>, <dan.j.williams@intel.com>, <yu-cheng.yu@intel.com>,
	<baolu.lu@linux.intel.com>, <conor.dooley@microchip.com>,
	<Jonathan.Cameron@huawei.com>, <riel@surriel.com>, Kefeng Wang
	<wangkefeng.wang@huawei.com>, <chenjun102@huawei.com>
References: <20260228070906.1418911-1-yintirui@huawei.com>
 <20260228070906.1418911-3-yintirui@huawei.com>
 <5eaf3846-01db-471e-9903-b0b239d7838d@suse.com>
 <e8d5ba16-3071-4b4a-b6a1-d492cc46e8c2@huawei.com>
 <4d7c396a-6a48-4e56-b8d1-3ac7bd5d10fb@suse.com>
From: Yin Tirui <yintirui@huawei.com>
In-Reply-To: <4d7c396a-6a48-4e56-b8d1-3ac7bd5d10fb@suse.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.248]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0AE544000D
X-Stat-Signature: g19u4hzjijpgbcpmrwzgj4ngcancgn3q
X-Rspam-User: 
X-HE-Tag: 1773113552-240755
X-HE-Meta: U2FsdGVkX18O/wOt7dRB+BMbXco7CzPXxit5aIP+elsvMSR/7tke6YF4zIgd2BvdhA1oSZRGl9v0XTV7Y+awZVIiUEGWmteHv39tIMWVwl0qfvqDpjG2aaCtPKvuJTadLta06jIuV+OLmUAYUtCA5YA1S/nTEhaPxkODDJRwCM9GCOBT3kZUe5eN3vUfbnj6t1UJ824/MXWg0uF33jQai5ToY0aPOfnwIpUV8Tcb95pwdMTyBDvqzsrTgY3ueDUBTKONZB9XlY74Ao9d2S9tHiHh+e5bNVduMcuwktMysy+OkOX0Y0G9Hu9GjJEkZjX+BYJj0kAiUPy09fAio9WzuaqtPRikKrCIRb5WZOwyI8aq0ZV9f4rGsjY5dZu/7g5H8MY9oVuhaCSxskM+bZdUq+KFYaYnFKRnlwbP0TSci6SfArTGziQwc/UaXP/PnSJodPMN55N/aNdMT6LvzZPKCJ9upqHPaIVUwK5hZ2cIlRY/6LNBlTHmJfJTkq6fvvH1Ve1mqQj631C8/dIR6yk72KWNpnOKHVHjEpchFg5NaTyDO8YHaz8umz0ZaUaNRgEIi2JAyxzQC7ffVy7AYZVGUqU9jYE8I5aWVgb35OFlUN2Bmy+XvwIB2nt7bpqcwjRNIutEzcVJk77RyLjon56u6cDGCTHuP8BxFJr3Ktrly3hydzzDl3ev+mzrwrJP9wrl/Fn/J/yPLqrnYkj1XL4k0T4zwn+zGvlUfTm1fGbCnEV2FlA8sNfMuHaM0raPbIKDnE47+lr4RI9iq/eJvPN5s3s7p25zVeEc2/U8loi5MjXP/d5pW0URNYHb8H12YG877zIOl+EZz+CKtzBFI2RvbHi9KsE0wFmnJZe3aUdvPNlGdB7gT3nWfkywS+1mUjggQkjFARhbjckFMgDQqFSg60MgTY7v8dD8TTnOtFmdjMSCJT4GCCvA+6pWj0pZqO/Xb4nCyxs9mN1h3ILtaKE
 2zpZJ74P
 YJOjD9TYbVSnCTT+MeVPPUj9myiMbJt8RLeyYepwwm3jVxSg8+yrjv6vnb+O+VN8jIlD2W2iglRIzuv9K2eWX46Cww7SbJ7mb6sxy4LYbJWuqPZsnbBhcf2RBjqexbLOfXnpzsr1gWjKJ9ZpeZmD9pfzDA5Sl37+nLbvF62C7KfmiNLwGVPFEEAy5ZNj501DDGn/b8nkh7Z49GNiCBtVEOBDB/gF+ub0iTGmM+dGcD/RjTzqRBWuTbUZ4WW5nfgZ4f18sV8PXHfyck9oCVeX1qqrBwt0XheSe60WlW4z4azSSrL8lzSHG1i9a+A6cNVzQH2xTBzz+PIFnqXiSOFjdAxdcxx8l3ExDiajRSFdnXseW9UZxd5E5a7v18BLENqxYe7xBTw1Jp6RcSQk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/5/2026 6:05 PM, Jürgen Groß wrote:
>> Hi Willy and Jürgen,
>>
>> Following up on the x86 _PAGE_PSE and _PAGE_PAT aliasing issue.
>>
>> To achieve the goal of keeping pfn_pte() pure and completely 
>> eradicating the pte_clrhuge() anti-pattern, we need a way to ensure 
>> pfn_pte() never receives a pgprot with the huge bit set.
>>
>> @Jürgen:
>> Just to be absolutely certain: is there any safe way to filter out the 
>> huge page attributes directly inside x86's pfn_pte() without breaking 
>> PAT? Or does the hardware bit-aliasing make this strictly impossible 
>> at the pfn_pte() level?
> 
> There is no huge bit at the PTE level. It is existing only at the PMD 
> and the
> PUD level.
> 
> So: yes, it is absolutely impossible to filter it out, as the bit has a
> different meaning in "real" PTEs (with "PTE" having the meaning: a 
> translation
> entry in a page referenced by a PMD entry not having the PSE bit set).
> 
Hi Jürgen,

Thank you for your confirmation.

>>
>> @Willy @Jürgen:
>> Assuming it is impossible to filter this safely inside pfn_pte() on 
>> x86, we must translate the pgprot before passing it down. To maintain 
>> strict type-safety and still drop pte_clrhuge(), I plan to introduce 
>> two arch-neutral wrappers:
>>
>> x86:
>> /* Translates large prot to 4K. Shifts PAT back to bit 7, inherently 
>> clearing _PAGE_PSE */
>> #define pgprot_huge_to_pte(prot)    pgprot_large_2_4k(prot)
>> /* Translates 4K prot to large. Shifts PAT to bit 12, strictly sets 
>> _PAGE_PSE */
>> #define pgprot_pte_to_huge(prot) 
>> __pgprot(pgprot_val(pgprot_4k_2_large(prot)) | _PAGE_PSE)
> 
> Seems to be okay.
While the wrapper approach handles the aliasing, Willy recently 
suggested taking it a step further by embedding this translation 
directly into `pfn_pmd()` and `pmd_pgprot()`.

I am going to explore this embedded approach for the v4 respin.

-- 
Yin Tirui


