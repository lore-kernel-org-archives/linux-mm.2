Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C5E5D3ABF5
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 06:24:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81FFE6B0358; Sat,  6 Dec 2025 01:24:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F75A6B0359; Sat,  6 Dec 2025 01:24:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 733646B035A; Sat,  6 Dec 2025 01:24:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6097A6B0358
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 01:24:38 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D83028995F
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 06:24:37 +0000 (UTC)
X-FDA: 84188057394.19.3E3B8FA
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id EEA3D1C000A
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 06:24:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KLI+QUb1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765002276; a=rsa-sha256;
	cv=none;
	b=Pb29WOrOJyG+vJHdTScLv5Hj/I8P2WiLYoa3Vy++f3xSCyvLd6FPGP0U/ieRBrVE7cYmdZ
	QCD+TJB/7fDjlZEm2Bsl4uOO9j7LPqpLYqxN0gU1nb19xTrpF0EIyTl4duZYKWIkOKaZS7
	9u5LIKpAKrVsn5i0ync3UU6aPBiLiXA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KLI+QUb1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765002276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w5oVSgIBCafXEGoSSuuxX91QRDxQwxmfl7EtVipaGVo=;
	b=g3iRIqqgWBPoqCj14hIi2LcAAhgvLCwgm3f8PyLl8UjT2ySo6g9+p491H78p89npHZyxdl
	Jk/CwH64VT/vWxnJEjJzF6Kc1IMkMtrelT25skpoaQifhMEu+VlkJpYtdUG0w/8F4SZPgw
	Muxmd7usQPX/IYmQIhuVdBnFt2EhE10=
Message-ID: <d93e5427-7cc9-4b34-a9f3-c9e8e991736b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765002273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w5oVSgIBCafXEGoSSuuxX91QRDxQwxmfl7EtVipaGVo=;
	b=KLI+QUb1SrT79p/Z0YWBn5xVhcImTk/B+taONF5EGVMXeTYbjz9LRf9VUpmkV7LiGzl2CA
	AQF9RYrHIkAQZXsOKzQ5dDUCssikkK/5FlUHMNjORPQKfyUZQ2SFsv/sNbI45/XDWdxzAd
	LJ0SZRZJnLbuM6vyiBBmfH6ghgwaOEs=
Date: Sat, 6 Dec 2025 14:24:01 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1 1/4] mm/hugetlb: fix hugetlb_pmd_shared()
To: david@kernel.org
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 aneesh.kumar@kernel.org, arnd@arndb.de, harry.yoo@oracle.com,
 jannh@google.com, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, liushixin2@huawei.com, loberman@redhat.com,
 lorenzo.stoakes@oracle.com, muchun.song@linux.dev, nadav.amit@gmail.com,
 npiggin@gmail.com, osalvador@suse.de, peterz@infradead.org,
 pfalcato@suse.de, prakash.sangappa@oracle.com, riel@surriel.com,
 stable@vger.kernel.org, vbabka@suse.cz, will@kernel.org,
 Lance Yang <ioworker0@gmail.com>
References: <20251205213558.2980480-2-david@kernel.org>
 <20251206055553.21759-1-ioworker0@gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251206055553.21759-1-ioworker0@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: EEA3D1C000A
X-Stat-Signature: zzmp6x1tpdhdxq9idq6ep7tjb8tqmxqb
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765002275-726961
X-HE-Meta: U2FsdGVkX18UD3JlLzbUsusgaVKIogfmaA9MvzN7ep8yqGAYPX0inNxiMdFLUhltY/btmnOKYVK5RmXZzWcX8tAGZRtpO5RvYxHJdsf271anCdBEhei2EmND42QSZyW4wJn+aX5VxmvMGyyyjCFJ0s733H0qQQW2ttsCwzTfDc3EDkh6Gqp7Zgb+VG+czQ613u/M8pA/kYGsUwMfOj2OyTjWv3s/u7erPDpADcKhr4yx/T1kPaMg0kvd209jzsVc+Cclp1CYNXSTtFrKFSHMAFnhQf3gZDffEIKm4djMOpHuwiDF2m/CBLXcSAxqnZl+e5Zd5GmpuK99a/KmTqF9WzESDzAHPhqSmuZf2AMbchhAO+PS1ETiHgdkN61mQCYAJMGJ2LwnBREN9r3WRDw3KjfxTDojEo0mIwA7EVcmmTDFSOQGkyiiqpmQIk6Fbh11NePK49cHlIi6b+5HYqfoSGMtZq2QEpUuIRTNIattg9w90LCE3jJWNphbGBwom5csFJ4ZQNAyDrxvEq2iXNThgtofSGrX5Gl+nPgHJK8xNmr6fJ4mDKPBA2dAFY7f1qG2SUm1mYFE/JO8Mxnpxi4FaPTxySqafukEVxcD7+IPj0c3+K/OqrhVLl80U69lzQerZwzgIVQJE1R+1ZD3l43Py8jr3UC7m1ne9K9S09TJh0QpPUoDcyELNVjR93WNg7CdgQHFLcxFH3IqQufSZszx40cgXRNWWxfXl2QKsqAsFwkq7XjGUsBYodQQRDtzNLJyV+9KeP7qDStl4rAM84/zF1JVblBIgay6eQwlUqXUgWxidB/n3DMIkBkSKOPajLhSuLaI3EJrvphB47XZ01qMvdZUElIWin7v9xpIi39CbKRZU2b4pRVK6tuyTWqYqfIHfhIMV4CT1Gcw1aXaNVrv9GzFR+NTRBbg9zv50pKoJlpo2KNug5vO198MCAtDhdjRySTZwwGn/pwolU58XAU
 vx8VcFnJ
 jLeEOU4TuOZXUYfOrq1ZUz+YLlUYcukIH2RqHDuXyeFhVAzwHvudaMmMca2eMDQNedGGRKVMeNz00baOHBFhv+xCun9Tx+uHbjVNdfKGuZzOIjQ0cSkp/XmgzYLCbnxIuZ8Hr8gBypMtxTwxNVx76d5iSTBZcStg//9H8hAJVituuYA9cx4O5SatI5cgCtZ8fy/EcJv+F+yomuFe6m8DfDD/APu8X75pN93Cd1c1edjYJhDB8qwC74lDmiryedHbsdYReikljYaXAQAIZzpNfWaemNtb0P5MJ1rGj8H3TmCZiHM89C9b2zDKbfAXPWmF+m00PUTapmw4cKeedsA4i6nIkZy7N06KaKq7HO+GRByQdUvaOig1N3Zq8VQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/6 13:55, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> 
> On Fri,  5 Dec 2025 22:35:55 +0100, David Hildenbrand (Red Hat) wrote:
>> We switched from (wrongly) using the page count to an independent
>> shared count. Now, shared page tables have a refcount of 1 (excluding
>> speculative references) and instead use ptdesc->pt_share_count to
>> identify sharing.
>>
>> We didn't convert hugetlb_pmd_shared(), so right now, we would never
>> detect a shared PMD table as such, because sharing/unsharing no longer
>> touches the refcount of a PMD table.
>>
>> Page migration, like mbind() or migrate_pages() would allow for migrating
>> folios mapped into such shared PMD tables, even though the folios are
>> not exclusive. In smaps we would account them as "private" although they
>> are "shared", and we would be wrongly setting the PM_MMAP_EXCLUSIVE in the
>> pagemap interface.
>>
>> Fix it by properly using ptdesc_pmd_is_shared() in hugetlb_pmd_shared().
>>
>> Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
>> Cc: <stable@vger.kernel.org>
>> Cc: Liu Shixin <liushixin2@huawei.com>
>> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
>> ---
> 
> Good catch! Feel free to add:
> 
> Reviewed-by: Lance yang <lance.yang@linux.dev>

Actually:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

