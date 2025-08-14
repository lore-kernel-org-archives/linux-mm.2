Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABB32CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 10:03:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3870B900129; Thu, 14 Aug 2025 06:03:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35D48900121; Thu, 14 Aug 2025 06:03:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29AFB900129; Thu, 14 Aug 2025 06:03:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 18C46900121
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:03:38 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2CD6C138479
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:03:37 +0000 (UTC)
X-FDA: 83774926074.08.88DCAF5
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf28.hostedemail.com (Postfix) with ESMTP id C0390C0007
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:03:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=FyCovBqC;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755165815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ocqGFWwlEESKe0BZACXQhN4GorNLeklOvmcYh0YlYp8=;
	b=IgG9UyaGw5wdEkxWfW+hfpOcYtyN7HX50icp1hLZYYOgti+Aabz7elrwcqIK0pHquUyhY1
	3+lXYWwqCJscep9VCNl5PX5mcbO6hMlK2MRz6JlkiPY4NLPZY2LeiDCsOKVVmH/11MCQZI
	eGmgaN1vJLTf4BW7L0pBJmw8kIJ6qFA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=FyCovBqC;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755165815; a=rsa-sha256;
	cv=none;
	b=TaOy3HjMMzZgg/IJYwAT1Up6K/vS/V4urGfirdlVqDyHd9Kqvv4k6IblsKNEo1zsxlqfYx
	p0+fYEDaeTpuBBwC22HF8+zwgn3KbusxwGOjOlAdvu1anhCc5ZKm+o5LZOFJ+LC6IGaFsh
	yTD59cI1pdG9yf04WloCsBXRmey4SL8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755165810; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ocqGFWwlEESKe0BZACXQhN4GorNLeklOvmcYh0YlYp8=;
	b=FyCovBqC3Mt5BohHtPCdg4byY5rxCjP4UwSFIwRpIHoiJFUVO1j5qMhVgclrEtju0ug04MoMahclznUI8cZg/k3bzgOz79k1ce13saH797tEpnMJ1SVU5n/fuaBzIuoIpkDrqHyZJrQEV37VXFP4acf1iSuhZLtD62Aap+KeL3E=
Received: from 30.74.144.115(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WljqW7d_1755165806 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 14 Aug 2025 18:03:27 +0800
Message-ID: <323ed726-fc69-4d80-a7e8-e3762c161ee1@linux.alibaba.com>
Date: Thu, 14 Aug 2025 18:03:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: shmem: fix the strategy for the tmpfs 'huge='
 options
To: Hugh Dickins <hughd@google.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@redhat.com,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <701271092af74c2d969b195321c2c22e15e3c694.1753863013.git.baolin.wang@linux.alibaba.com>
 <e6898dca-d6c6-465c-a373-8298858839ab@linux.alibaba.com>
 <3705f034-808a-4afe-5dde-4b4e9815a8d0@google.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <3705f034-808a-4afe-5dde-4b4e9815a8d0@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1fqpiza7q4kpyobh3131txw1pgxbd3ec
X-Rspam-User: 
X-Rspamd-Queue-Id: C0390C0007
X-Rspamd-Server: rspam05
X-HE-Tag: 1755165813-646122
X-HE-Meta: U2FsdGVkX1+OC+pvH2th3xFmQLkFJ53QRVcKYaaiDBlriSGYhsI0PuhtwoddDts8IEEHnYRKLgGmhsX7fR9GE2oFyiTyPDxUqVIrypGInLgvPJJ/EQNEfgSqhm4xaPsgDdVp9Wqg+rYufRpskQCyHRp2JxVPIb6QQAYHxoBtNWDNlnO9lKzXs8AaTqNcBtBl1DcIFkhQdmCF9681AhhiN6yLnug/CZu2OstVyS+VmZ0myZtWFD0GYaE0rmX26EbURj451KilWeB0Xq9Kird0QvMzFd0QrRp2GyyQkMMGoeFKjtUw29G2xO+MCFMe9K52nfOOXGZDO+v4eGT3ARxoa9PJuSgLW2+CpvXrVtvrKFIRlsY4BP7qxFTHfe1b/WlZTmJC9xPx2r2/IBVz7Oyia31MThnhIpcGo/CQ+s+km4BgR27/6FV5y/WsDYSAALu9xO3r6diNVzLm3W1xIozX+IiRVY7mIkNS8WqVdmsIAAkJaNha56mgGcawWxYERZuYhDPVfjyM5GkmWj0mDS4boP93RMluwkV/sIeM08qjLz8vV3YsC0eGKRSov30EAPQSvE/zGG8sK3duS9gm7UmXer2hUMp7gQSbdZYnC7dpldyiAvhoDWKpaxXoHa9KIuXYP5DEEX8I8eU+5hv2/TLbEi6x0LPeyYnSPaxAnHZuAJ8RF5ia5FqzTZco60B2ol0mg90VJs0XaZAzejLgKe9BRPG+zoWZnZkkxugpF9lnWYm+cjHiMavYLieG7LJHYHkR/WN0t2h8b7ReYrRYr3Tc0sMfFD2i9oIra6BTkqacaKJUj+w5h7Qcjtd2wTQ1YlpOsGguz2/WEZdYzI1fdxZ9fLzguEU1fg2IpADAGqa2TrkZaK/SPG7B2LJM1JmF2Bjj80wVMTT+izKTtEcff5ycq6FOq9jdZoKj82wvyq/952ULU0FuQaHi2oaEwepWz9o2x/CyQydTa9lKtNo4JQQ
 +birAtZk
 ekTYvyf1kRLZO0k5Hrn7EusLixlGhVMoqNZI5xTlAZ1u60i4Cy13GvlosSf9wu/McMwokh61f1ahbnE4TMqRimEnjsWJeDTNxbXNKzcQszlolU9KOqaBSZjgH3JbxBGfnQAY1yeXnpgK0PJdxp/e9fvgHs1catrAHkjY77r6x5SR71vg0vaNM1B4+ncsdcNo1DOfDWlmsz8NiUEiVHg2brCPjVM8LybSSVhptujLBmKdRgGaKg38CaIof0kPzlpbmJDidxypVq0XX2cdvuZSA6eTKA8kVw2t8iDRih4yxUsENOBVUkVccmJzejaAlC+SWxPeodkYVPZ8mXhN+d3NpZpseO+qaucSvAzMI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/13 14:59, Hugh Dickins wrote:
> On Tue, 12 Aug 2025, Baolin Wang wrote:
>> On 2025/7/30 16:14, Baolin Wang wrote:
>>> After commit acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs"),
>>> we have extended tmpfs to allow any sized large folios, rather than just
>>> PMD-sized large folios.
>>>
>>> The strategy discussed previously was:
>>>
>>> "
>>> Considering that tmpfs already has the 'huge=' option to control the
>>> PMD-sized large folios allocation, we can extend the 'huge=' option to
>>> allow any sized large folios.  The semantics of the 'huge=' mount option
>>> are:
>>>
>>>       huge=never: no any sized large folios
>>>       huge=always: any sized large folios
>>>       huge=within_size: like 'always' but respect the i_size
>>>       huge=advise: like 'always' if requested with madvise()
>>>
>>> Note: for tmpfs mmap() faults, due to the lack of a write size hint, still
>>> allocate the PMD-sized huge folios if huge=always/within_size/advise is
>>> set.
>>>
>>> Moreover, the 'deny' and 'force' testing options controlled by
>>> '/sys/kernel/mm/transparent_hugepage/shmem_enabled', still retain the same
>>> semantics.  The 'deny' can disable any sized large folios for tmpfs, while
>>> the 'force' can enable PMD sized large folios for tmpfs.
>>> "
>>>
>>> This means that when tmpfs is mounted with 'huge=always' or
>>> 'huge=within_size',
>>> tmpfs will allow getting a highest order hint based on the size of write()
>>> and
>>> fallocate() paths. It will then try each allowable large order, rather than
>>> continually attempting to allocate PMD-sized large folios as before.
>>>
>>> However, this might break some user scenarios for those who want to use
>>> PMD-sized large folios, such as the i915 driver which did not supply a write
>>> size hint when allocating shmem [1].
>>>
>>> Moreover, Hugh also complained that this will cause a regression in
>>> userspace
>>> with 'huge=always' or 'huge=within_size'.
>>>
>>> So, let's revisit the strategy for tmpfs large page allocation. A simple fix
>>> would be to always try PMD-sized large folios first, and if that fails, fall
>>> back to smaller large folios. However, this approach differs from the
>>> strategy
>>> for large folio allocation used by other file systems. Is this acceptable?
>>>
>>> [1]
>>> https://lore.kernel.org/lkml/0d734549d5ed073c80b11601da3abdd5223e1889.1753689802.git.baolin.wang@linux.alibaba.com/
>>> Fixes: acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs")
>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> ---
>>> Note: this is just an RFC patch. I would like to hear others' opinions or
>>> see if there is a better way to address Hugh's concern.
> 
> Sorry, I am still evaluating this RFC patch.
> 
> Certainly I observe it taking us in the right direction, giving PMD-sized
> pages on tmpfs huge=always, as 6.13 and earlier releases did - thank you.
> 
> But the explosion of combinations which mTHP and FS large folios bring,
> the amount that needs checking, is close to defeating me; and I've had
> to spend a lot of the time re-educating myself on the background -
> not looking to see whether this particular patch is right or not.
> Still working on it.

OK. Thanks.

>> If we use this approach to fix the PMD large folio regression, should we also
>> change tmpfs mmap() to allow allocating any sized large folios, but always try
>> to allocate PMD-sized large folios first? What do you think? Thanks.
> 
> Probably: I would like the mmap allocations to follow the same rules.
> 
> But finding it a bit odd how the current implementation limits tmpfs
> large folios to when huge=notnever (is that a fair statement?), whereas

Yes, this is mainly to ensure backward compatibility with the 'huge=' 
options. Moreover, in the future, we could set the default value of 
‘tmpfs_huge’ to ‘always’ (controlled via the cmdline: 
transparent_hugepage_tmpfs=) to allow all tmpfs mounts to use large 
folios by default.

> other filesystems are now being freely given large folios - using
> different GFP flags from what MM uses (closest to defrag=always I think),
> and with no limitation - whereas MM folks are off devising ever newer
> ways to restrict access to huge pages.
> 
> And (conversely) I am unhappy with the way write and fallocate (and split
> and collapse? in flight I think) are following the FS approach of allowing
> every fractal, when mTHP/shmem_enabled is (or can be) more limiting.  I
> think it less surprising (and more efficient when fragmented) for shmem
> FS operations to be restricted to the same subset as "shared anon".

Understood. We discussed this before, but it didn’t get support :(

