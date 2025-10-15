Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67245CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 11:04:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AE628E0005; Wed, 15 Oct 2025 07:04:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 886668E0002; Wed, 15 Oct 2025 07:04:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C31A8E0005; Wed, 15 Oct 2025 07:04:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6B9E88E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:04:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 39EE4160446
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:04:34 +0000 (UTC)
X-FDA: 84000065268.17.7BFAE5F
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf07.hostedemail.com (Postfix) with ESMTP id 222BC4000F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:04:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Icl28WZ6;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760526272; a=rsa-sha256;
	cv=none;
	b=dyUe6y66v1YiwrNsuHUTAY4G3x5DQArMhcBByIHguzLG7AcgiSHdrnnC68cpsxndkPocLe
	O6+H6W0OiEvGWhrErAzYe/T7DSkyDfb+XfkYKe8ewQe/kpq+I5OVxlOJmShh6Exxixtufx
	+L1xYjU/29M5pdTluKay5SbBa5Pn0o4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Icl28WZ6;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760526272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=waaSkUTajFSu7GDeeSsIK8w04Eebv+AgJ9uThxzjal8=;
	b=LB94+ZK6kpN06bP6AN1cmp8uLEEUwgXrpeA8TiNx+zGDb8L+LDHltEpgRWaJRRmwWJTTR6
	18g1IVfZdj61EH5FtDXgIL60vVkxupIXG3rHlYMkg+Z3MRtvLrmGzc5E2XJU1eMoRIm232
	eFbjUzw1DKyYdH2bxklQiBW19eYidrM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=waaSkUTajFSu7GDeeSsIK8w04Eebv+AgJ9uThxzjal8=;
	b=Icl28WZ6lsFeoM9TrI4J7xcfYvnXScN7c2Y7cycjflql+cwJ7OhVl5gBKMPBi3mEnxTZPZSDR
	i0SUU1UbXkuQ5NkgjIh4siK9uGLa/hrP5Tyhs39eu8GvaYxAIK58KfeRNYBLw4CkUOePDYm957W
	YlSk7BFcrvd2O7uqfnE+X1o=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4cmp9C6fJszcZxv;
	Wed, 15 Oct 2025 19:03:27 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 695CF180B72;
	Wed, 15 Oct 2025 19:04:26 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 15 Oct 2025 19:04:25 +0800
Message-ID: <c5f19802-3d40-4e0e-a9ab-1de64b6869e8@huawei.com>
Date: Wed, 15 Oct 2025 19:04:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm: huge_memory: use folio_skip_prot_numa() for
 pmd folio
To: David Hildenbrand <david@redhat.com>, Dev Jain <dev.jain@arm.com>, Andrew
 Morton <akpm@linux-foundation.org>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, <linux-mm@kvack.org>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
	<lance.yang@linux.dev>, <Liam.Howlett@oracle.com>, Sidhartha Kumar
	<sidhartha.kumar@oracle.com>
References: <20251014113349.2618158-1-wangkefeng.wang@huawei.com>
 <20251014113349.2618158-4-wangkefeng.wang@huawei.com>
 <1c020f8f-4722-45e4-af1f-ee3d4a67068b@arm.com>
 <92490858-fa4c-49dd-bb3b-2820c794a8dd@huawei.com>
 <77fe5471-ed9a-4448-8a0c-75e41729bec4@redhat.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <77fe5471-ed9a-4448-8a0c-75e41729bec4@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 222BC4000F
X-Stat-Signature: 7edd9qtksu7acq9b3gbtckokqzqupapm
X-HE-Tag: 1760526270-807878
X-HE-Meta: U2FsdGVkX19AVsw1F6awX1oFQXihPXT3VHvlAPIeHxNt8Dl8XSGkeIgSCAfa3B/dypZCos/EtI8SFP6lvBvZEirMJD/hbEdKX8X0bEdhpgWe3Yxx/exkTS1PUM685bdn3qCclyBm37qV6b11/j+nrsBTKDVAggwjvC4u7+J3a7fuZWbvmutxOTGiXylXijhLktl4Bfl2gDjwY61NNimleSo3zW3kyCJBIxPB4NFro+zioMqXg7Dx0fV4O4QRgQ8uTo1inOfsILnMW25wx1OPSbIccqXHDmk3AzPzCMNtZ5y4zeGyNUq2HF15K36nPXwVnCxp/wddHjUBzYPMdPq6RAKnzywIIz8u1W1lw3Bnm1rSvEEh2L+/52QzWL1LQ/s5yplSjGBWj1ocrAjQ027HeHiyJMxh2EEUyGY7WaQuxVTvk1LGBVvLwPGQuWaxElGyr0H/q4h7Os6oxQbHNYg7IPfmPZHugQaO/J9GDY/YMNSJUYJThX6FMYkJqo8gYVR1yE6D7JZuh6Jko0RcExfvKEyZnj4lZaZQP6OaLpBb7ve6mlWQ3fZHu3nhVOKWwpr0E21D8oxNPa+Guq/Sk3xjfj3IL1SDj4bgNxyg2DGMqW5zwpb4eM10LBfW7DrExs4QGaadwbzcLWOEtBxm7JpHCbZBTZRehBvrGf+/dvyin80IHUfpoyG42xiO1kA8NS04qkMSSUwOdFsdztDSIO3gU/pSSv0kAgRff7VUQD0Zx27Vgi2r6P0npDgDxx4PFqMLbmC6f0elAUifqF/dnuWv/rD4MAH5g+Xb7iBc692ctvtTEnUiOV088XaHLVEZnuAwhB19iwzLLELXoe/s7eZ3lgG/p603aRT7frVqniXi/3ehvgHBM73QdpYb6faR9TJdrjXN9eEbH7xnbzo2ga1aI9wgb1BrKoAS+VpghBF+6875vnYzfpj9kNuqJZ0GurZ6FRV7Kvkp5bra0Dlmmbs
 MXsUnQNA
 xURNPpbr+QQLgDdhP/uPvWt/hCos7wC+m3PVwebh5BXBilB2eIG8FYDzchppgxvscdLnzRn6hhoSMJq5UiQYNjjUrT9+I2Qou+hNBM9EE/ANNhJdqN5BiTy5Oo3kJoA0X1cVBJ8a7h9pWEykELMqAflnGyuIYeitVcBfpw9rj/oyhitDHTuXF0pcj7njJ+VBOW+76aDJcqeWCdN8kH94tN7okCNo7kpwtl9rB0OQGBOMTOmOjh8Zn4IZULzcnKSu1YjfWBG++mTXgnZT5QEt6NzT0JYgqumtm1H4kktP+6Ui6Mi9u6tBAqsTgcGC72yE/3wEPkgwT1my1q02I2oFOBsX13EI2ZrwhNlPMK2Z81U3dMaT2Z1IKU/RBhZD2B2uh1qbTaD8N8BC6jKQAzDxL2jATtp5OhgV1bYbgx8YpFDPdAdAWwgiMbsbqSg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/15 17:54, David Hildenbrand wrote:
> On 15.10.25 11:21, Kefeng Wang wrote:
>>
>>
>> On 2025/10/15 15:30, Dev Jain wrote:
>>>
>>> On 14/10/25 5:03 pm, Kefeng Wang wrote:
>>>> Rename prot_numa_skip() to folio_skip_prot_numa(), and remove
>>>> ret by directly return value instead of goto style.
>>>>
>>>> The folio skip checks for prot numa should be suitable for pmd
>>>> folio too, which helps to avoid unnecessary pmd change and folio
>>>> migration attempts.
>>>>
>>>> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
>>>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>
>>> In the review of my mprotect pte batching series, reviewers had
>>> noted that the branch "if (folio_use_access_time(folio))" in
>>> folio_skip_prot_numa() did not belong there - it should be done
>>> outside of the function. But I see that that would duplicate a line
>>> now that this function has two users. So in light of that, would you
>>> mind changing the name of this function to
>>> folio_skip_or_process_prot_numa()?
>>>
>>
>> The name is a bit long, and it only update access_time not change the
>> pte, so maybe we leave it as is?
> 
> Any such name might make the return value weird (which indicates whether 
> to skip) I'm afraid.
> 
> We could invert the meaning and call it something like
> 
>      folio_apply_prot_numa()
> 
> And return whether we have to protect it.
> 
> Maybe that's better? Other naming suggestions welcome :)
> 

That's better, or folio_needs_prot_numa() as there are already some
similar names with folio_needs_ prefix ?


