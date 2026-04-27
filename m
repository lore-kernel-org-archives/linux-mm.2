Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B9D9FF8861
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 08:50:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53C956B0005; Mon, 27 Apr 2026 04:50:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EDC96B0088; Mon, 27 Apr 2026 04:50:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 429EB6B008A; Mon, 27 Apr 2026 04:50:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3192B6B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 04:50:05 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C7149120771
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:50:04 +0000 (UTC)
X-FDA: 84703713528.15.3D7D4F7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id CBEDF12000F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:50:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FAQ0gJlp;
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777279803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I4Tv9eBsAoGe5eEspNt+G2Qm1hMHUXuiYny5ua9hJKE=;
	b=Ngpue4pf04kqQpn4a8jEPZeeUYC5wMDuHbFPfryA1P75yd8tgCI4dQaKI9i/LjV/nSy+WX
	gFG9onEZRR0mMMh3d0i92KPvv46KaUJfjWR7uNGztb/LdoIDBJTwGFsLxl3QR/HPy1IE5s
	pG4lFBSMV9sgzGaUj/qteUfJvEu5Gj4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FAQ0gJlp;
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777279803; a=rsa-sha256;
	cv=none;
	b=rZHBpUJx9syuymMLjA4dLEZ9qFd84G2PdqW+UMT54+6VHvipCIjRiFl76MWAz2HRv4YbuF
	wkL0Hk3JRYQphQk51yfVsVDsTXby9jvpJOt93Pq5mDvDsAGlKMIZ5/QQRZRCUain42NPAb
	WAYEZhg+4LSfntA5RMX2S4jjew54kko=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 341D01684;
	Mon, 27 Apr 2026 01:49:56 -0700 (PDT)
Received: from [10.164.18.48] (unknown [10.164.18.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0C0D33F62B;
	Mon, 27 Apr 2026 01:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777279801; bh=0GWUcMnbWktPaU4qy3M0B1w8OmTn/iOg4VU4cTHjVL0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FAQ0gJlpEEoTvwEwhsU6JZVwgxLpcaIig7al3nYlT9Ydh8NDbExHUZBUoIWUQ/SO2
	 rC6588/nH317mQspzt6mCBrwa0C2N2StAQo7oziQ9uI3uBX9qL4v0s3A0IW7s0gmaa
	 A2uvUy2uEQrdF0BPHmTh8KBSXwWQSwE+X7txYka4=
Message-ID: <453d3e2f-5b29-4fd5-987f-de590d89698e@arm.com>
Date: Mon, 27 Apr 2026 14:19:55 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_vma_mapped_walk: add missing pgtable entry
 accessors
To: Oscar Salvador <osalvador@suse.de>,
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 linux-s390@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260427052000.196402-1-agordeev@linux.ibm.com>
 <ae8g4jipQxQZRe6E@localhost.localdomain>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <ae8g4jipQxQZRe6E@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CBEDF12000F
X-Rspamd-Server: rspam06
X-Stat-Signature: xgoph6r7zxbmz4kf44uu43iterp4s3wy
X-HE-Tag: 1777279802-190379
X-HE-Meta: U2FsdGVkX18+BUkbfkLhXq5/8dhZyboxPa3pK44NqagHZe3nAXluM2HJ6hGhkxrX3ohLC39LIZKDc67RW4m/ac8pvO9+SFACNKtc9x1LCOsiF831MJM7QD/kMD7gb4GsRa/h422uCyTuyw+kYdwkgpUYjlY8fJCzkN2Zfn0fA728+MrZ5p0JJBa9H2VO1horPX0+KgHTWgR2hyhjmt5+YN+/y2xQRzsRgfcuGB9f5lrYhEgiYTUXpeQwk53B8DIMWyVYAMgJctEHBxmDYAQnKbKLpOqRhPisx2a0t/UDvXmukeJ1wxtv3mTxIt+2U9yXZJ8hmwFn4g5q/8PFqpR97TD/8kxtxLkaxV+FrwBAfEdsnNi68/of5uScVdO+dj1n77fCr7T70E5mzHIv2FmvLbHUvKq18DR2tr1sidaZA0VwVMCXazwyZV3X7FCOPIEuXKKm2Po7yAjxe5uJiv+N4fme6PZfV7+WpFm7in3p2MoFm96Cij6zxySexspo0jIP2HEZP1xPYdpFsbngO/dpastPfdfhlYxfDSp5Xuv/dVH3KTheXeIvSXhRzAc2ENT4i9EjA1hrJVQxfdynX0Kahl3Inb4eI7Cip+3h/fe76DMhzs8094N+Pv3tm01Hv9YKOp6wj/sjpeKPx3u8iVxl8hmH/RB7FNXkeEupfH32EkZabTuFBKY5AGq2Z8S+ej09c6hacwmBn99bzYNIew0el0xnN/c19MZVfTzXZmxe/4+XhtauLQ1x0rFhSNj03SCLqBGp3TxFrVNp3Y8NAKlzvQts4Dmw5MsgYtiDbFbCQ8Jzhhh9CWg0h0Q7b0tUoztx+zvNWq4cxQ0omPjHrEejwDNEKvj8qCDcQXbLxDpoRZROTTcO86dJssNAKmV9jfVSiZCg6d4mN0dZsp1X/mcDEGuMEjh4tp+kYuYOc6M4AjyyMcuDJRL7zXvleYmcpCIdK/0SGHBX01me+926qES
 6Nmt6vM2
 mdhKpSmQGjgB8/xF4klT3RKkI+eJRwiOEMNHoGw5gewY7MZS2zhTYEZ4flFjw/BmdVHZ0hSur0XjK9zcynZjHHV01TANZfZnDmR2Cy0d+Zes6dsdo5UPZvgW5wBLwBsg/WR9XcxfVYCdPg5AQV7B73d1at7Qdo625H0pu7llx44mupgVzzVsdrMcWFY3hocTpU3SkoJJkkX4XE+1HBrejOoHoK8/U0Y83CKEP2qXG8PffuKcNNd2Euvait5C8vZFKG7UjSaCju7VCoCv1ozj/iPiOPPK44CJchIrd/Q116l5zm4M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 27/04/26 2:10 PM, Oscar Salvador wrote:
> On Mon, Apr 27, 2026 at 07:20:00AM +0200, Alexander Gordeev wrote:
>> Convert pgtable direct entry dereferences to the corresponding
>> pXdp_get() accessors. Use ptep_get_lockless() variant for PTE
>> reads when no lock is taken.
>>
>> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
>> ---
>>  mm/page_vma_mapped.c | 12 ++++++------
>>  1 file changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>> index b38a1d00c971..a4520bb10d2a 100644
>> --- a/mm/page_vma_mapped.c
>> +++ b/mm/page_vma_mapped.c
> ...
>> @@ -317,7 +317,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>  				goto restart;
>>  			}
>>  			pvmw->pte++;
>> -		} while (pte_none(ptep_get(pvmw->pte)));
>> +		} while (pte_none(ptep_get_lockless(pvmw->pte)));
> 
> map_pte() might take the lock if PVWN_SYNC mode, or am I missing something?

Right - should leave ptep_get() unchanged.

