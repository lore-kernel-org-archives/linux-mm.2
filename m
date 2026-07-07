Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9430FC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 02:49:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77BBE6B00A1; Mon,  6 Jul 2026 22:49:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 753546B00A2; Mon,  6 Jul 2026 22:49:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 692186B00A3; Mon,  6 Jul 2026 22:49:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 46BA36B00A1
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 22:49:18 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BF9451A02D6
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:49:17 +0000 (UTC)
X-FDA: 84960449154.26.99F68E8
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf07.hostedemail.com (Postfix) with ESMTP id DDA6C40002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:49:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=IDuxi9vq;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783392556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5i77ger88zezVroL5G7P1+2TsKTxWgK4e37XO/nKq00=;
	b=HOfvihXgEQps4u5iDNpqbi1A3OP8kU8WRJBrb5HM7rhxRwzxqs5wgLGAY5sfG61KnfmUMv
	bqGYYzF9bou6Goi3KePpoBkCaCSoajuEqFMPdQ5P30vENntFJifOqsr5AN3GQQwEj5mPZz
	0TjFByK903BAnLtvive36oSFHpRJY8A=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=IDuxi9vq;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783392556;
	b=kUzqS8cCPMD7nzDjbudsCgDqvPFCdB99NCMluPB3QHj596A1wG4/FG8CsK2rE8kN3DOOt8
	lR3AaepCszm+Mxerh6nb/ATo1V0muiv1X71H8bfd2rEG19+UL+JmSpozwdoyGWR1V3+uXh
	ynzW0atDfg3xwGO2/QTvv7+wBdGHSCc=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=5i77ger88zezVroL5G7P1+2TsKTxWgK4e37XO/nKq00=;
	b=IDuxi9vq1VQpihcnFfGXqwl38ueqQ2n/pwuhiwA3jcWXZUfOCRnfMPEquUhZAgeZTIRkGj1+h
	DwxwvKL9hpelqOOnsiEerb0UPIPaQNg9piMGX8b3Qdy0glKEio86/jyycgnvwcxyUhOVFWdYZ5f
	3pNnKRhr2FiguoUA6WybSpk=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4gvQSb0HWkz12LJK;
	Tue,  7 Jul 2026 10:40:31 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id EC2F64057D;
	Tue,  7 Jul 2026 10:49:10 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 7 Jul
 2026 10:49:10 +0800
Message-ID: <2b4b3fec-18e4-48da-8ead-82d0c4970c08@huawei.com>
Date: Tue, 7 Jul 2026 10:49:09 +0800
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
X-Rspamd-Queue-Id: DDA6C40002
X-Stat-Signature: a74g88rerk3nmp71dipukxhrxgi8dk1h
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783392554-221608
X-HE-Meta: U2FsdGVkX18PvGX8vPqiIZjUiX9Tvw8fvPyiKZw3vDXGBZchGIZYysJgqYxnK2CK+X2VKuS6QMhcPGubiF5wJ5Y25/UPlPsLvJCVkNhIXwJVwCTmY4jTbYPjBcsv8NIieVWnBzd7hazAK6x5recMAeNDOdfw40LZAwgTsPR7dz9Q2vWJEnW3gIMQDP6KngiQhr9FFuXqOo3g6N7mBIzYu+2kW0Lb9nAgFABLyeLnofSW89pwieAwroQtRyKwC7pUMwGHychWx/eZwgbNQYWWsEbB6mb0+yIRfel6vZ46GiW8je0t26dWX29kzjWoXhumqudq0XcNZ7xy6qfORqjknp08AAswACmIafc0GVGnjtRFcsudyPJcjCZ25gdAOGBjIjIsbeeabq/MCqJOk3J99NJ6P1QUaVCLhREnhYtfFLoHMymQyF+akPullslnzKAvkdmPxuGPOiQ/DrvvpmmbZK18Yv0wTU7uQB4pIzEZIBYAOVyVBrUl2M4e4k1EqC0pqkS4hgziPKWLk2Qnqvl8AItDSLiuJrM0HEJ0g/yuJrzAd919lE43HqHAl+bJ3kW49egPSFUgOJqT51a77F3Z2XOYR0wNBZY1i9d8mo33DuMH8ai0AqY479uR0jiUeln3R9+TkQuS5fjr3sU1IO+w9dBAxLzG8GftEWVFDiIK/4xjEb0cjiySex2qegpBRGwFzUM8WcNhmznW73uvMA51jzeK9SslQDyChz1NqcAe1cnpzdsYkwWC9PPT8td1etsQaYgz8/qHe89L2b4mMn36lVmrPgqcrAh5UOV070J/bCBYM3OIZyJ0ZXiaD6E85sXJ9Cn/wMoNC/5QYB/ySfY8Q5urP2ppGe7Jjrfn2juWYZ2HBFuA28EwwShzvkQH3gy6VNU+QiQR0/qyAxGRi2SRKI4S7Jo+ZmEKKjt7ZTFDdNTfFi78o+Jdms83cS7h/thaUWGjmfH2qx3FKmGlcPS
 Mu6mYzvg
 aD7163sN3PvP2WG73sk9WEYokm5lLelWfPvnR/BH50XHBwqOCwcj4VM2FQy47G20KUP6d9KirCcN7RxroT41LftdMP39vSPhfG8+4LIHGdt5B7FsTfMR/UwGvvfcWKbMuy9gzIKO2LuhbcQ9U5eymZY3TBFRaC6ej5nKYCiS+Vqxed2KDrxHDfY5pmiWPfVpVj8+aZPb1z03jukSLzdCXnhwkj1qGXkwDPnK9TgR2M1QuOS5dWsup+Mj8QbbB5B9n4729Pyxd90XoeV7JHqvZ0OUYNaW50fc0LtN2R3s92mwDzfKxKLJRpTw7pi1qt4Vz+On2MNd1mom2+L8odk5daDW22SVn6QKfoQYi8fatMBcwaH49/hXPW10Hm3yfNMVqfAaVIjtC61Nz1q0=
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
>
> An application will notice the difference between "zeropage enabled vs.
> disabled" either way because we'll also not account zerpages towards e.g.,
> "Anonymous".
>
> So faking that something consumes memory when it actually doesn't consume memory
> is wrong?

Indeed. As Documentation/filesystems/proc.rst says, smaps shows the memory consumption of
each mapping and flags associated with it. KSM-placed zero pages shouldn't be accounted.


