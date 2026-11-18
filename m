Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8354A606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 08:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=SUB4oc9H
Received: by kanga.kvack.org (Postfix)
	id 7CA8E6B05B1; Wed, 18 Nov 2026 03:45:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77B4D6B05B3; Wed, 18 Nov 2026 03:45:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 691236B05B4; Wed, 18 Nov 2026 03:45:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4414E6B05B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:45:44 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AFDDAA8324
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:45:43 +0000 (UTC)
X-FDA: 85447606566.16.89665DD
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9566B40003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:45:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=SUB4oc9H;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794991542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CL1Kb+/j64ntc7xw8JHIyID3bJJ/doyvWUN8+vUnQ9Q=;
	b=b04UjWhdLXqVuaGQxtApOUIAb7pjf1YeSKd5Cjf6CJd5ezSERPf44nmH91PeuGF4BmrVHm
	o6vYOElRSy7pOliWlcLGxboXW/VUH4NBNW2lhudl5i6JaQknHW2Jbm01UdYgGlZ5MpQhO9
	YZCcwU3sNMgN+HqDsiM51gSMpB8vtUw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=SUB4oc9H;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794991542;
	b=EtiU4SQl7cO5lSk9/QYql8b6O1eJkWhRw9cp45/s3Q7RICkJ47ZfjluqimzP02Bq7Z74CF
	vUGFUYCcOT1xpF0PHXPAbBiQ5nluSXt5aeGOuiF1zJnrbaSbGtlvLC3Iz+vUDYl5Io2135
	Y3OKOBrGHda5sAn46//oVxYItoJjZro=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=CL1Kb+/j64ntc7xw8JHIyID3bJJ/doyvWUN8+vUnQ9Q=;
	b=SUB4oc9HwMnPHmTzpOhpKHD7saGp4F2pDd1vz3kEEdREGmKKTeDzHrc6qPoGd7XPhmfj+NCQB
	MXwaag+Lva7rO7gKYjNUzUAXiTNeh4WV7t4B1AeVXeDe/qUIbHv7dLRKrgQ1m180eAYpcO4vfk1
	wtxJ3lmi6rrrwkfd8zxJHSM=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4jTwCb3ddhz1K970;
	Wed, 18 Nov 2026 16:45:15 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 21DA84056A;
	Wed, 18 Nov 2026 16:45:29 +0800 (CST)
Received: from [10.174.179.68] (10.174.179.68) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 18 Nov 2026 16:45:28 +0800
Message-ID: <0ca5bbc1-2101-4a13-971d-b5a14e56e5ef@huawei.com>
Date: Wed, 18 Nov 2026 16:45:27 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] mm: add spurious fault fixing support for huge pud
To: <sashiko-reviews@lists.linux.dev>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <mark.rutland@arm.com>, <ryan.roberts@arm.com>,
	<peterx@redhat.com>, <dave.jiang@intel.com>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
References: <20261117020237.4037980-1-tujinjiang@huawei.com>
 <20261117020237.4037980-4-tujinjiang@huawei.com>
 <sashiko-outbox-219925@kernel.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <sashiko-outbox-219925@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Queue-Id: 9566B40003
X-Stat-Signature: 7yppngktgmcw11otgfgao36hnduyn5up
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794991538-910267
X-HE-Meta: U2FsdGVkX19NjOjjqDB7pmRnMlOT7hFRjmyEoPFSw8//Uva99k2J+DKqunYP/oYCrXWVUjGYkqP9FIiXHebZakRcNtZufFCXHIwKdfEAIbJdvT+bpN6FgfCtSIIJ1KuUbj//K1OYioZEJvBUOPGvPA/eMfpEjK4fl0PVwpeozATB17F1YRK1VQGVDNT0OOEWRku2OUCQrGwnjC+oZQ2MyW4Ey9qTVhg9DqbGTqozm9hbAWMFYGer6zdG5Wx5BSV4yKHaYiUuuQ9zcyfUplFqMbhHJChQz9rfInq1UrTzbyXnwYnTKFuHV5acrUqgkpKNeKN3/2Y/U1JrU8H5ptYNaQQwO/W6YXsb4589jaP5e/GySAt8OWygPSK6xVQ3Q8p8UIfMsX6v9YOuHai9xoM+o5gY4/rWTksOk1wbXakN+mKJXOeiNfHGV0XG6zylTyfDSQ+ceQYtttB3dJ9j171NFa8e49SCV/WqFwQwSsJWDPcFZYOJXO0iMUVqLgt1d7tZcnaMr81q/9l/rKK/Y8XVol6mkmMm+8KQH0oP8/X8rVlDq54hBu6SQBqXwzLA27lkK3cSHGE9FfiTs9dmiNd3dv8a3MZTMHSGDK57L7IiWCkmhJZHg8ghNSXcx2rlWes+dgcFU+QlKDveGwmJWQ7mf88KJ54vM6dwUGekfHAOuQxzoyio0Tsy70hs1QmsxpBsB16QUr8HGi1cE025KzZbcNv0m50JxK11ryrQy10LTBb0XiDdUuEvSZFlU+f3k3IZejovJAKbpDvsZAzE3A5AYLWn0yFv/2ZCoKFMyuZk7mkWg9+aO+WvpMCkFfYtrsiLud15g0pvRr9z7uYMpR9tYDVGONY7tzCZxTakpXBTDWGsDd/F/YR7Rb1nWf2TKNwJv1XcCKJvrnKyUiiVeEQtxWcjVve5+yQWFVJMm1T0hjQCsiIKfY/s3PHqrrefEKbK3b8bZ+Cl64nSl1mjFs6
 XPpOS1PL
 +YJ5Q2SieNehocqAR9do5mMxJ4j2gvScsLYzem2lGFHygMIsEJK0+y5YznVTlGNW8eI2EUZtiMqmRV+BxO84YSkfYW8uigzena9vgfRrlEcgrGu3IzMyAZkgcJY5j9J9J0Z7lHfRzGWn8Y2QN80D4zKi8EmwQfQV2+UQzTLqvGW+gvWce38ZV5pQVawWygmtTk57n9cZf2okiAnnBfj5sL6wAhCJoQqZipU0vc9h12tCD/Bcqp9f+VB6xcsUawmok3B+me9gEBqAgGjlGIOZ1K45OCQ7E/UrRhmIYMSsaH057pGU2nsw0rbhSCeL7niyucm71FmcI0EJXLpKbjwxl89Xmc2UWOVCXb8xrZpeerKJieJXTTO2HUbBxlded5wBgD9SFRjDlcF7ICgc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


在 2026/11/18 10:03, sashiko-bot@kernel.org 写道:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Low] arm64: mm: unaligned address in
>    flush_tlb_fix_spurious_fault_pud() flushes 2 PUDs
> --
>
> commit 89132c364112921acce9427dab367c258f86db04
> Author: Jinjiang Tu <tujinjiang@huawei.com>
>
> mm: add spurious fault fixing support for huge pud
>
> This commit adds spurious page fault TLB flushing support for huge PUD
> mappings and implements flush_tlb_fix_spurious_fault_pud() on arm64.
>
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index a06b0f5c34111..3c1c000cc5dd1 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -107,6 +107,10 @@ static inline void arch_leave_lazy_mmu_mode(void)
>>   	__flush_tlb_range(vma, address, address + PMD_SIZE, PMD_SIZE, 2,	\
>>   			  TLBF_NOBROADCAST | TLBF_NONOTIFY | TLBF_NOWALKCACHE)
>>   
>> +#define flush_tlb_fix_spurious_fault_pud(vma, address, pudp)			\
>> +	__flush_tlb_range(vma, address, address + PUD_SIZE, PUD_SIZE, 1,	\
>> +			  TLBF_NOBROADCAST | TLBF_NONOTIFY | TLBF_NOWALKCACHE)
>> +
> [Severity: Low]
> Does flush_tlb_fix_spurious_fault_pud() flush two PUDs instead of one
> when the fault occurs at a non-zero page offset within the huge PUD?
>
> fix_spurious_fault() passes vmf->address, which is only aligned to
> PAGE_MASK.  __flush_tlb_range() then aligns start and end to stride
> (PUD_SIZE):
>
> arch/arm64/include/asm/tlbflush.h:__flush_tlb_range() {
>      ...
> 	start = round_down(start, stride);
> 	end = round_up(end, stride);
> 	__do_flush_tlb_range(vma, start, end, stride, tlb_level, flags);
> }
>
> Whenever address is not PUD_SIZE-aligned, round_down(address, PUD_SIZE)
> and round_up(address + PUD_SIZE, PUD_SIZE) span 2 * PUD_SIZE,
> invalidating the adjacent PUD range on the local CPU as well.

Yes, confirmed. flush_tlb_fix_spurious_fault_pmd() has the same issue, which
is pre-exist. I will fix both in v3.


