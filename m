Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5847FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 04:14:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D94316B0088; Tue, 28 Apr 2026 00:14:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D44F56B008A; Tue, 28 Apr 2026 00:14:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5BC26B008C; Tue, 28 Apr 2026 00:14:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B52346B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 00:14:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 42CF3403FA
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:14:52 +0000 (UTC)
X-FDA: 84706648824.25.4591F33
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0DC7CC0009
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:14:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tFdJ1tlI;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777349690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=surCf8gO3wT8Pdul782oJaTtr+PBu6+mjAu4GEjX9Ao=;
	b=aFhOcCu8yCoixRtvr3p/4IgGSW8dNSHGEgXEfSIEuuKUpRipdIxDj1+3bOdo7T85ccvAsW
	8C11bSKlwXxAMWM7DtMuf5ie379Ntgibrl0CEPMk5qkangQhJ7pG1l6K8Sx5+AeyWdlrQL
	UnQm00AW9YM2SAyfg9l8w7IKZi3lJBU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tFdJ1tlI;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777349690; a=rsa-sha256;
	cv=none;
	b=ypaimotWVR+7ty3neATtvooNoqKueC6+8gJRWxsa/ITHf3pL/5E0AZMeYRHNHh1ot2mX60
	D+0LBtFjTj1gAk/HQLJYbwCLiDZ+RU9CN79yVEqmT/TYDyuWbOcqFKUsL6rmtlVVmec1BN
	Ij3Q+Irtw4vECTsPwtrdqYlbJAZULS0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3FB6A1655;
	Mon, 27 Apr 2026 21:14:43 -0700 (PDT)
Received: from [10.164.148.44] (MacBook-Pro.blr.arm.com [10.164.148.44])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D99A13F763;
	Mon, 27 Apr 2026 21:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777349688; bh=BH42mJ/E+CpYMtpyTCO/zmkPXMLKWODEQUI0JcxIdvA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tFdJ1tlIf3LWIhKGhokgfq4Gat6MNCY05DT/Bs9YVeTEKtwY2/bCNo7vXFp6QTOBF
	 5KGg0Ivd4wqodleKXy9afHInJktGdlMqU+ny/5G3OGcWJCGRP7dJh3F/l17OLPNur1
	 apJCdv16ShVX1zzgZz3eJm6jDUCMN8AGBHZp4Psg=
Message-ID: <97bf11a0-0e0a-423f-81f0-91fc1ed9ad24@arm.com>
Date: Tue, 28 Apr 2026 09:44:34 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/8] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
 urezki@gmail.com, linux-kernel@vger.kernel.org, anshuman.khandual@arm.com,
 ryan.roberts@arm.com, ajd@linux.ibm.com, rppt@kernel.org, david@kernel.org,
 Xueyuan.chen21@gmail.com, jiangwenxiaomi@gmail.com
References: <20260408025115.27368-1-baohua@kernel.org>
 <fb022a6f-0faf-4742-8934-8a7ffae806f6@arm.com>
 <CAGsJ_4zwrsrKt5NiuN-rYCqJiyjNdv=UssLuf8VCu8xZ+5sohA@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CAGsJ_4zwrsrKt5NiuN-rYCqJiyjNdv=UssLuf8VCu8xZ+5sohA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0DC7CC0009
X-Stat-Signature: zed3m6h3s73wtnantmar1ngngwxwpbjs
X-HE-Tag: 1777349689-867107
X-HE-Meta: U2FsdGVkX1/T45stnXVDpJJzVpEpna1ap27ipeDPFMv3Ykmk0MYZB2U6dl6WjZsBV0Rn5AR35j5kv7JyuGkneDGblenIW2rwbm0jAkqSmcrYgjZuJBZon4EcVOM9p+9RFMZhUF5D3G0sw95onz60Hgadhyhi8XB53o0JpjitFm1zVlOJyoXNGbWOAU4DZLihEC2RoR2DOfAs+PSNvYwfy+mveDNsZSG3vJUqvFw2/XyIFf5AJ6Ccif6gWL6+EWXPREMgkNrN/DZRj4MuKlmCoLufGz0Is6B7oVX3RzOgEQgkMG3TOq21uqGlQpmRbTMTt1FR7fgSvE/eWsDhz6pztZ0e8RdXEl676J/hKQOPByKKNWrahukNKDUwsyh1Mk71HDlYXn/KmKb9BZd0WDFYSDFfvXn3gywBU9bJvIRzIlVa/ZrvKhp3nFR57ypy9CasTgR6P+PYQf0OsLYQMOjsDRKPMK0d1iQOnpaljb+gMVTmsp3ltzalDw6447XAbSulrbeGEsHvJk9Wb10ssYZkTk9nodr/t+9I3jRP1322PKdfd4r6TkKZvpe1qCH55F1xETuTyeJk6tqmiWdKnxso7kwZl0ty9SL8T0/wGq7pAjEknd4J9sSF0rlBm6N69R34q7OxsTDYbH6VZOMbUIYVDuUsscUDRd4nZn1RjrW02+QcsnL2Iqu3nkCPGMEyG9bD8cbmMqGnDdLCLX3StyLHy5+Q8VGMDOrUw9BhQUsMUiCovlewUDD/Z8a7HlIuvdMvp0SCMfaj/ZHgz/0+zs1EGsgy6zHD2jB+vzajkLCpRXLeLUmCQAVFAWrRenhzsJ8MLbaqWO0gAoF69GY+7alHO/yx4zw/2Sv6ayE5YBdQNS4mXIh2lhNgdOwjsQAqEzytzJkiYtSE4+AQxMQZUjNE1jc3yYw4hGCYsPGdJPBNrjvE437xxxON/gT5sv4HeynBEbG9OgAH0AligU7bsqy
 hWLdWBK+
 Wu8okQOb7uQmTOuhzDoXZEghdSHxvII6WxL46nCXvG0pvheGjnA1T9UB2DMOGzkhXqYuEuuR8ynZR0nY2wJnxhVGc3BbHyFNm/8u0My42H5z7FgBiiG8VuVo6fZEFJig7lkOp63cHObvBShyPiDV1izdAPteJUY8c8QyFx5xJVQ4+4SoiKvgsU7/sDcn9HTBrmN0VpLTO2zkCRIAJETOeeT4TGUgIDbRc5nDB1GX5jjeroCvRiX7iOyANZfqCI08QInJng7QsGUOBmOlEd3NleG67byBmAAkmiWBHYqebOo2Qq6/j1o1puQm5VMFC0PJ+FlKG4uEWIc08OFhazuHy5so/TZsV0z4zFgG2icRrlcVcaJsgGv6oDZtcY3rF4K296d1F9+vMyskFYxM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 28/04/26 8:46 am, Barry Song wrote:
> On Mon, Apr 27, 2026 at 11:05 PM Dev Jain <dev.jain@arm.com> wrote:
>>
>>
>>
>> On 08/04/26 8:21 am, Barry Song (Xiaomi) wrote:
> [...]
>>>
>>> Barry Song (Xiaomi) (8):
>>>   arm64/hugetlb: Extend batching of multiple CONT_PTE in a single PTE
>>>     setup
>>>   arm64/vmalloc: Allow arch_vmap_pte_range_map_size to batch multiple
>>>     CONT_PTE
>>>   mm/vmalloc: Extend vmap_small_pages_range_noflush() to support larger
>>>     page_shift sizes
>>>   mm/vmalloc: Eliminate page table zigzag for huge vmalloc mappings
>>>   mm/vmalloc: map contiguous pages in batches for vmap() if possible
>>>   mm/vmalloc: align vm_area so vmap() can batch mappings
>>>   mm/vmalloc: Coalesce same page_shift mappings in vmap to avoid pgtable
>>>     zigzag
>>>   mm/vmalloc: Stop scanning for compound pages after encountering small
>>>     pages in vmap
>>>
>>>  arch/arm64/include/asm/vmalloc.h |   6 +-
>>>  arch/arm64/mm/hugetlbpage.c      |  10 ++
>>>  mm/vmalloc.c                     | 178 +++++++++++++++++++++++++------
>>>  3 files changed, 161 insertions(+), 33 deletions(-)
>>>
>>
>> Hi Barry, have you got the chance to work on v2?
> 
> Hi Dev, thanks for the ping.
> 
> Yes, I’m getting Wen Jiang (cc’d) to send v2 within the next few days.
> The patchset is basically ready, but still under testing.

Thanks!


