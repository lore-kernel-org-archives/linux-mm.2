Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AE8FCD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 13:38:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FD5F6B0005; Mon,  8 Jun 2026 09:38:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D5246B0088; Mon,  8 Jun 2026 09:38:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EB206B008A; Mon,  8 Jun 2026 09:38:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A37E6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 09:38:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BB11486D84
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 13:38:07 +0000 (UTC)
X-FDA: 84856849014.12.AF45BD5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id E19AB20003
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 13:38:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LdsaNTFq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780925885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3DmSeVsacdhuO8IPMvgQqcrU2HaMy5DBmzNlEy6t8Sc=;
	b=knmOUS65RzA8mu9PrcrpreNMz4Mc5qgYzoU0j7IFUZELFxYW8FFEZl3kvzlJFLoI7hJ0t2
	iMpLuFxj/W1oi7oYFQ4mriH0KJQ4UiguolDt2KJPBO/YYqn48Fd4ZVoWkVtWZB/KJgxwut
	EkQxqZHuh8bZV1xlQUR+cX8IIw8uE5w=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LdsaNTFq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780925885;
	b=8SQMdD8PCUD4Z1l30RuhfyACzhGZpJKiY4ExpdYvlegyWsZ+jc61Al7Jf3B2sTCwbpsDj+
	YUNiqTUG/3OzvoLPvQcffOT0Wqcya2RyIz2Yp0/QLdvB1ikdvvanWy9U+fh5G1ag61kpIW
	hIFHR+DWgmp5BNxIpJKuQZYCM9Lopa0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6A4D3601D8;
	Mon,  8 Jun 2026 13:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC331F00893;
	Mon,  8 Jun 2026 13:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780925885;
	bh=3DmSeVsacdhuO8IPMvgQqcrU2HaMy5DBmzNlEy6t8Sc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LdsaNTFqk669HcLwNMx7JOOX4hWjrgZkdHTXjB2Ko/yB6NiJ84DDHQVDBEtGCh9aw
	 r64054qsJC8nTwPq92DXSOq2JaFL82AgMWM2JKjFNXLF7GmMdagOvVpKkaHZkkF0Sc
	 ExYymswqWwGUOkqPW15y88enuDr+zbmnGJBEGrtn3JmDlWciDbyOvfQwcB9I3Rjtrl
	 6Qnva4MFkmBkzyVdb+0nOG5DtMDkuijAPhIGhog5+v/GLUgdoMWttyu1XIhbDfylFm
	 zEfP9wYD+cwAkFMdaeH9mDluGhviXSXoJmgY2noGNcbbFo84bUI9tioh3Ud4ssvuMq
	 1AS4FEKeyZXCQ==
Message-ID: <38b49fb2-c2c0-4c7f-ac5c-3e79d54728f0@kernel.org>
Date: Mon, 8 Jun 2026 15:38:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iommu/iommufd: Require write access for writable MAP_FILE
 mappings
To: Jason Gunthorpe <jgg@nvidia.com>, Yiming Qian <yimingqian591@gmail.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org, keenanat2000@gmail.com,
 linux-mm@kvack.org, Christoph Hellwig <hch@lst.de>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>
References: <20260607085320.73274-1-yimingqian591@gmail.com>
 <20260607120935.GG1962447@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260607120935.GG1962447@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E19AB20003
X-Stat-Signature: uaigyfhugfmee39u6rawdhxssyewht3q
X-HE-Tag: 1780925885-366302
X-HE-Meta: U2FsdGVkX18/jhvXKWdFj//dq3wnQ83L3/imbeoZftW9J5wxuTcbDc9e0hsfZF5nqSzHn/bSsLqi5FdZEEJPM7/hwz/T0LZPHr87FMBSzGyGYqvaCkdFoNAy7wOayjS9pro2N2p4eE93iF3YcfTDkqh3/LMjV3X7NGLl4LuvVBHvz1u8r/J7Ti0i9uyGi3voDzdv4LGWBnvoRYuq8Grn8dulJ6N+kIIkJz+VkQFGbYGgJReyILIqtIYHOmcGGjmnMAHM6D6luNvYxScStXS7B3kP7JugHoUVENG6Qat0j7MK0Jg2gzrvRLda3klQbwV/iw/nox6hW6QhdDTppLW4vRtculrgsYf8NebWTxkErOyncghc+SF6zC7M2oon8mnfYe8JYEZuikJGIAfcIZMBo9MVW7pOKvckRn86cGl6K37pdyzcNK7fpOQl2w+zAMtDYLtKtGixE1qpQegu8I4m+2gh0WPStsYEn0jhniesHgmSI5B7pFKaDfKE6lXnjRT6SlfoduEpJ5/skGIIZKG0elPdIezs+el0r7W3D+5g5b+dj5xc1xDy2Xo27GSmhuWrXkcjLBd31i5rJl7sKW7jDcIuHCbf1Wh4HKajw6dc373MXcVQ5814xLX1Vo/aNv9zkv625d9gHGXy9/2ItkfJI0avxIybFTwiuMopZZ3ctj2PS5bBRkCinr/uiVAU+pU9l1Ff3PxeFSkxGnFcyfjDcX/MGkD24tTUNdapaYWS8/gWDzgfATJzHMPF0NVjMVNJhl03/0zzZTkNKxhmfNLwzTJOu+k+yAA6peTx7dJlnVg1JPVKvhfFRvurGqupgCsCFJjKfCjyqO77q2vVm1P8rXpzZsiL6BWTFrpt+XsdhZWTNDF2tSnZLz4OU5EaGmHOxD50r/nmtZSWikvJYqabAM/NqT6mRmT8wpKHXLPXwHmBenvu+9uqAXbsTAxcEIiPkkI6GfZvmnaQXtER/ps
 aiAQNarX
 ada5o3U1ptquJU4TQ8JbAxgjoABnfOHRGcG1KBUXTp+9chlTxV1oZv0YvxjxtNQqHjyUpkzaHaL8ElNcQSjrM+gQ0HF4JEugLPxFDIezHOjULMwgmFAf8cK3SGj1q0oHvL+OG823/PT/7jj6kHu2hiYYd8De6l29E4/G/0hjuPOUog00UHO6PPBg0ewDBGZ3hXj4ge365JK1Vuywu9fabduL9iKdS/6ErM8yDEtoEFHRDgQjl0G+3Za/IbmUYCpGt4OpiYKun3DBHqNzg39Wfjmh70na6fd1dRWAlll0n6fOlRQlaukPCbcwX6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/7/26 14:09, Jason Gunthorpe wrote:
> On Sun, Jun 07, 2026 at 08:53:18AM +0000, Yiming Qian wrote:
>> IOMMU_IOAS_MAP_FILE pins folios from a shmem/tmpfs or hugetlb file and
>> uses them as the backing storage for an IOAS mapping.  When userspace sets
>> IOMMU_IOAS_MAP_WRITEABLE, the resulting IOMMU PTEs allow DMA writes to the
>> file-backed folios.
> 
> This looks like an issue with the API design in memfd_pin_folios(),
> all users would have a similar bug I think.

Agreed.

Not sure if it should be part of memfd_pin_folios() itself.

> 
> I don't know much about memfd but this seems like a legitimate issue.
> 
> Add those involved with gup.c and the patch adding memfd_pin_folios()
> 
>>  {
>>  	struct iopt_pages *pages;
>> +	int rc;
>> +
>> +	if (writable) {
>> +		if (!(file->f_mode & FMODE_WRITE))
>> +			return ERR_PTR(-EPERM);
>> +
>> +		rc = mapping_map_writable(file->f_mapping);
>> +		if (rc)
>> +			return ERR_PTR(rc);
>> +	}
> 
> We probably need some kind of companion API for memfd_pin_folios(), a
> start/pin/destroy kind of thing to manage this?
> 
> It should not be open coded like this.

The permission check is one thing that's clearly missing.

Not sure about the mapping_map_writable() handling ... it's weird to rely on
that when we are not actually mmaping.

Assume we GUP a page and then munmap, mapping_unmap_writable() would be called
while we still have a writable GUP reference. Hm.

-- 
Cheers,

David

