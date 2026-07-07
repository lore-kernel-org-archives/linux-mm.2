Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2ADBC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 02:42:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F5836B00A3; Mon,  6 Jul 2026 22:42:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CC646B00A4; Mon,  6 Jul 2026 22:42:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80A686B00A5; Mon,  6 Jul 2026 22:42:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 549F16B00A3
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 22:42:24 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CF5A51401F1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:42:23 +0000 (UTC)
X-FDA: 84960431766.29.470CC2B
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf20.hostedemail.com (Postfix) with ESMTP id 14A0D1C0002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:42:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ENFRIItb;
	spf=pass (imf20.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783392142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QHzU3ct+4jvkw954wX1fuSd83oPCWlFHer4z3d/39Bo=;
	b=VGJ4mg30OZI8qAbR+rYabVWdC3srHr/ygzWVJsbqJLHD5LFMDTytnMpn+vPYmrz9F7I9Z+
	zbMcwUhzxTZaJkolqEdKdFqAD8ltZLMlpahcECUXE8CKDV3+eDEFiLyvIuFS9mVL124Zki
	HHsxqGnUk6fTrYfL7BXqRYBOoazHoFs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ENFRIItb;
	spf=pass (imf20.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783392142;
	b=fhpGRxshm5GEJu3eIAk8vHvXigFl8qii0nnKdxj7AuFtcpNOfOMH7aFN1mo1fP9QluMMV7
	iP2VdqoSP4hNmJbvKrHwAgi5a4PFPgUkxL+AmoW/IwbU2Z4qbZ19iCCO4BV+gtpSh5SP+L
	N0AWGXVwXK9mA4rIGw6XX0HEPEslHeA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=QHzU3ct+4jvkw954wX1fuSd83oPCWlFHer4z3d/39Bo=;
	b=ENFRIItb2F/FlVI7RJ+1OuW5ULJ7gPfCK6qW5TYjO3EKw49V27wdaITAzoTQ1PpAgizXshQMo
	2p0b5cU2AkEhZCfY4wMIURRCVU/8aZew+KX6qeT+/p+sOMMoopwYj/K3IGZxjJOTe+A1Cg8vClN
	0Jwit/ZqSSmIOoQ/6mULX7w=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4gvQJ02s2Hz1K96m;
	Tue,  7 Jul 2026 10:33:04 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 661D04048B;
	Tue,  7 Jul 2026 10:42:16 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 7 Jul
 2026 10:42:15 +0800
Message-ID: <3aa50eea-ad23-4b19-9b31-a111dd5efb71@huawei.com>
Date: Tue, 7 Jul 2026 10:42:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/proc/task_mmu: count KSM-placed zero pages in smaps
To: "David Hildenbrand (Arm)" <david@kernel.org>, <akpm@linux-foundation.org>,
	<liam@infradead.org>, <ljs@kernel.org>, <vbabka@kernel.org>,
	<jannh@google.com>, <pfalcato@suse.de>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
References: <20260706121323.1149847-1-tujinjiang@huawei.com>
 <6ef49a9f-af0c-4bce-8402-16926424ea7a@kernel.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <6ef49a9f-af0c-4bce-8402-16926424ea7a@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 14A0D1C0002
X-Stat-Signature: t83dp8y1uaswjsimmzk1nzysrni1r7gf
X-HE-Tag: 1783392140-874168
X-HE-Meta: U2FsdGVkX1/n6nouxClb0VK6rXbxaxDx7QD5NYPJyCXCWLDlrS8DYDfuE6SmkPj/XyV19LyM7F6qHAgOpxC4uZ0wqX+HFsZJjFVSC/bgl16dDk7sdoWHmFbolmkBW5Y7E7P0THCp5sa7dDUA0V8WV/ZCiUVnEJMbdVJhYN08nCN3AQrIxVeeeGXNF6rM2G+B0FRa5eGISBJaogF6nP3wSrEhu6gsldBs0sEl5laoHnqvkEK0ka/wEPRaGYrxlDnOGMvRC7Dn0GW9xCmputDUfm0QRrMfIqr7pef51w/vHw5GY8y9YgOWWS6FTiwNWye1Vd/16ge1NEu7gUW/3YGkZfY8HqJ6UTK1+FcYDggyzBXPIj9kZpmApzzjpfwg5/a9j8W7YFWZFE0ohmlEM9pYagFANvuE4aBHw0ispLre5556W2L/V/T2xeTIqIRdo4X4g/nwnWunseTU6mf+PDwzS0C3JYq7JKlm0fhhDatMFQL/1tp+9Tb3YzCIiLUfIWXjl4/AW+yQGpVLTgr0zYJ5XrRk2TvnssbDAWYtBO6aff94sCbnyOAyxT4IBiGaOYsQ0qYXRjFoKLdKugyyKqk3tfJutSzTL0bAxT4eKn9FXfBoZG2nHDvyY16nw+bn13kGZPOPxPUrowVAsjmY2/HBZuhu0bcXa/mBJM44fk6j5C+cFTf/0ZKAr6MUrGpFaKGuHCv1ngFKEK71PkNuzF5Wz0VfEeBjWxAwCfacuoQMnmozMd7vsBoCoRfE7YZ1P0HiYTVZc6xTQuCOMr3VYNJkw6DRg20vnZad5J4oKKO2PhwLpExKsDVoTGwYGQIQcxy7s43+jg4MYoZ1qB56M/WEbOSU3iX9cyvPTOmu8UdT09LrW1tS9bHshaixRc+e9qO5yI1gicDaM6Uqfb1qxkbCMdmpQz9ORgDfWvN87BQ69YO1UznzcMEa41vkuKnvYN1Rnqfgak7rgy1MsPhZTt1
 SjMVONsP
 4fkEdX2IOpP4YpW0wmjIk8zcH2KG/bqj41qiVQX3AR1iRg0tuXHWyNy+6ngBH0VA0tmfxelcEjbgUdTK9AuRaB0fItZXY4ikHDhDvY/vJzUgNcgbFbdEddlV1q3v+QiZHUfzC9Vv4plt9zYnP4OL/CRt8u2HUETiYPffJSwsq/s01ZyFRxQmTKcf5hSaPtkqzmYWlcybuabARwTW6qx4lT7vVc8V6TL9Nfd2oyEHr7w7aEsdxky50YwMdec7x7RfRekWUH2WBPguOdUFBX3hboC2Meim0srUq6cKv1mw/1YYjwlhol4eXAbkgiJXxyuFVZhJHWMVTrHdeBqO3NF8g3poiTjlcShHJrj2fLlwy/dwhrxdbn3aEDHxdWOic3tr/RmhzjG+v7LPU7fs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/7/6 21:40, David Hildenbrand (Arm) 写道:
> On 7/6/26 14:13, Jinjiang Tu wrote:
>> When KSM deduplicates a page to the kernel zero page (i.e. when
>> /sys/kernel/mm/ksm/use_zero_pages=1), it places a zero PTE with the dirty
>> bit set. vm_normal_page() returns NULL for such PTEs, so smaps_pte_entry()
>> bails out before reaching smaps_account() and these pages are never counted
>> into mss->ksm. As a result /proc/<pid>/smaps and smaps_rollup report a KSM
>> value of 0 even though the region is fully merged.
>>
>> Count KSM-placed zero pages directly in smaps_pte_entry() using
>> is_ksm_zero_pte().
> Hm.
>
> We do expose "ksm_zero_pages" in /proc/<pid>/ksm_stat for calculating the KSM
> profit.
>
> Why would we want to expose it here as KSM pages?

I wasanalyzing the KSM profit of a process comes from which VMAs. However, 
smaps does not include the savings from ksm_zero_pages, make me fail to 
analyze.

> An application will notice the difference between "zeropage enabled vs.
> disabled" either way because we'll also not account zerpages towards e.g.,
> "Anonymous".
>
> So faking that something consumes memory when it actually doesn't consume memory
> is wrong?

