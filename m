Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CB26D29C33
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 15:16:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C56B06B0261; Mon, 19 Jan 2026 10:16:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2EBA6B026B; Mon, 19 Jan 2026 10:16:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B31916B026D; Mon, 19 Jan 2026 10:16:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F8E46B0261
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:16:45 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1C64614018E
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 15:16:45 +0000 (UTC)
X-FDA: 84349065570.11.BA465C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 34DC8C0013
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 15:16:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JtnM6QFC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768835803; a=rsa-sha256;
	cv=none;
	b=Z9CqxA0+WDGq8LBhTUAGOVdP7efT5LedLiU9eQhOTjOvJ16sd/Pjj/KLtVGgCnA7e0BLkS
	eqdG10m3zeSK0PnzCA0JnGgZI1Ep4FlTLb4JyaBraTSSHnoBg4Gi2fNFX3t2vMw+u9dW3w
	5wmJQt+EGuV9mhzQOld+YGbo4QBcuDc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JtnM6QFC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768835803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1o2BfOXWWQ2jUZEX+6sCyAuMz+rmWD/4v2s1mubND+w=;
	b=AmE3laVoYt/HxUPICRfAxLQHq8V4DWEfW2e7ICmJYluJOGd5xn5Me60Aiqc/kVLyXAmDIP
	TAuK4eU/zeaBmKP4o3ueqBvReikGHNsa/lzxJNZP4C+4aGEYM+cDdaw8NKx/Ryt3mCo5PR
	zOU7dLxWaLDgyi8R7GQj77dTlnHlHyU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3AEC343BDB;
	Mon, 19 Jan 2026 15:16:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2035C19423;
	Mon, 19 Jan 2026 15:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768835802;
	bh=hckTS3gmFRkxNWBtsceb6zn11jss+f3BKrZwJeC3S+4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JtnM6QFCOqRvP3fhKJwZe8ubr+qygGq2F6rMhmTS3c+/vs08+wVAKLX9K5sFj5j1Z
	 AuVgg5mIUtvWDPTYM7e01lAWUUsreZe9z2wYkwPqx9s6osoYtpUaYkOtQalRvwKttx
	 hjixW67WN9K8S55vfmvlhrk+sp2DmaDDGTC6vY4JwT62eufHPQPU3pA6Be5f4fDx6r
	 0pfW1waxsTgYV+OuoG1PKGeLft8fREvhN6RqW0DTO9kOR6wrwQoLWL4Ec+aplCTd/f
	 cz16IZHWD6singoUagzOV+gCSfbkCj1ZMv1o39T1dP0UrUHQDArSEBfMXq49QZXrVm
	 vkvzt5zm/KyzA==
Message-ID: <af260a0b-ee84-42d5-85e7-ea2b4789f31f@kernel.org>
Date: Mon, 19 Jan 2026 16:16:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] iommu: debug-pagealloc: Remove pfn_valid() usage
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org, will@kernel.org,
 robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, xiaqinxin@huawei.com, baolu.lu@linux.intel.com,
 rdunlap@infradead.org
References: <20260119142246.3821052-1-smostafa@google.com>
 <bca59694-6b09-4839-8577-c8ac4420eb56@kernel.org>
 <CAFgf54paL1O22-crK-RufOzwYBqQ-CU4BD6=h30WOOfdA2__Vg@mail.gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <CAFgf54paL1O22-crK-RufOzwYBqQ-CU4BD6=h30WOOfdA2__Vg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: pxto8jrcregwkxhzs8agnutycugfpeq1
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 34DC8C0013
X-HE-Tag: 1768835803-404074
X-HE-Meta: U2FsdGVkX18NB91UfFUFMxDLgEVllIRhDFRYJgAoz8zcNAWkCg8bep7v7sF9s/GRyRDJKdpAdm/08fhWjhk5KN66f4A5jJXl/M4GLjtO5MsC9lyyj5EFw/GX9XgbJZKjkpI2eMHRYn24ER3fbNFSkZ+mmNoZv7K1zfwjoweWO24eGl1j1hu79PnV8I5cQAQ7KTRNmw2MPKquMDu5RP1UfWyUfzQLb8dngxVgAU8ciXCnJ4OTWpp3DE9XL+yulGCMD3x8eqRIXY9mgsmdex0JakVo6RL4sV3g7jiva7vZSxxHfb8h/DC/sMnGIX2AyZ07Tdi+Q7O/uKrJRIIK+r3uBfbMZVCcAJPj/PAn/70DdpFpH1l2uwq8CNCt9a+b/d2ojHq0FgG1i2btuxFCJXAN6drGmfTdxEBWCTF77L7izSty86CVWIavkPKLLrbn+FVsbi4ISIS/dNjTGwlrLfGJ88h4efjn1eIjUv0zKU5vZQcI8cJGS9FjtHeuPxd4TIgpl/iao8D4TQocRxaNzoUeHT/IvGmPk71AtVFp49vwZ9qzyycKEnJB2EWTSpqKB0cJF/dQB3fG8YcMMZW/trHu184w0Qw8RU6780RVjZlyZl1AtrFTpIYOP+4s+hL1IASKpglrexXBN2LJtozH5m5RhNt2PCZr529QyAc2Vdl/Sa/hcrUoLvY37eGbQ4fKOC5O8n7kBqv2/8f9wQcRJnDzW8V91+l/cuGSdFCGVzzl1Rprsy1No8pjcESEmBOJq2WmSqULC38wQtNjTPZNnpmuycsRvlPaDSFUXZsmBupCkoM/E5KWrzdWg7nmxrE3Sv0WVt5IlSnp3/mvbdSQX+58IkbwaU4X36PtsqsqaFFkCPpDHGGeR0wGR/dn2bScXHiHJojjIWX0Y9uiL26We9jHecls6A1JBBFopJuKqsP8uWaE58q8ECRGI4JxkZ4m8a9KhIpnKBdiTNPzXhMZZNr
 qKK+WTGF
 vOkjbKhmRP+LhIPQBnaynFaBTya8aycOCQNKK5tNPF0vuAT9ZvZrUIqeoVWUN73L/ttSXiNuTAdYhyzfxmNuJrrm9stRgY+NHv8PzbSrdHjQPd8jUMIH7cF+ot2RAno3mDTvPV8IJcb2UgYDW1GaDGITDVdrCnVo2ZvBUtTZqxKU5erS2WVMn34lCG9UmeYU8+GiL/R3sxAM5JN/1waJiJpcy5n0pYB9NiFHwDm2HlihxY/J/UujZt0Nod6b0rY6f+TGniRY6d0GhNG0c58yqxJnRwVPh479dOpgkTCjAsSeRJfzvES1GjM+0p7uJGjLHCbCpW+TGjNf0wIjMVGPmCFimTvPsVbO+aTrJAV8a0FVGPkgbLLDraZFjbFBgrGZhZW1qy4BwpYuRLoEdY9KE3dszhA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/19/26 16:09, Mostafa Saleh wrote:
> On Mon, Jan 19, 2026 at 2:27 PM David Hildenbrand (Red Hat)
> <david@kernel.org> wrote:
>>
>> On 1/19/26 15:22, Mostafa Saleh wrote:
>>> This is a small fix for the new config IOMMU_DEBUG_PAGEALLOC based
>>> on the discussion:
>>> https://lore.kernel.org/linux-iommu/CAFgf54pBAUm3ao-UJksiuGKtvv4wzRyFq_uKwLe0H1ettO4DLQ@mail.gmail.com/
>>>
>>> Where it was concluded that pfn_valid() is not enough to validate
>>> physical addresses before access to page_ext.
>>>
>>> The first patch introduces a new function in page_ext that takes a
>>> physical address as an argument, and the second patch uses it instead
>>> of calling pfn_valid() and phys_to_page()
>>>
>>> Benchmarks with the new implementation can be found in:
>>> https://lore.kernel.org/linux-iommu/20260114164322.787125-1-smostafa@google.com/
>>>
>>> This series applies to iommu/core tree.
>>
>> This is part of v7 [1], right? Can't we just apply v7 instead or are the
>> commit IDs already stable?
>>
> 
> It should be stable according to Will:
> https://lore.kernel.org/linux-iommu/20260114164322.787125-1-smostafa@google.com/T/#m59d0b455e3f2160cb6f9980a0ae65bc481c53898

Shame, probably applied a bit too fast ...

-- 
Cheers

David

