Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E803B606A326
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 09:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=ClPd2EYT
Received: by kanga.kvack.org (Postfix)
	id 1F6396B00EF; Mon,  2 Nov 2026 04:18:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CE086B05B1; Mon,  2 Nov 2026 04:18:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E3F36B05B2; Mon,  2 Nov 2026 04:18:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E2ED56B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 04:18:04 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E3227C0C7B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:18:03 +0000 (UTC)
X-FDA: 85389627246.13.77F8AA6
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf27.hostedemail.com (Postfix) with ESMTP id E69C240005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:17:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ClPd2EYT;
	spf=pass (imf27.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793611082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3cY2UudyvcyVZyFhsHmGpx4qCCcBQj/0zwP0XEW/fCA=;
	b=bYzQk5MH3di0LJtH6dCIgY7RhTU2nbG18ZKRi6gwza+7NJ1FOK0aUaS0qov7odiwU/n8a/
	QzTKCRCmFepmZ3qNEficC81vEZIV2vgFF08NjFsi/bVlPxP2P8c+RpGxoZUe7jPedAuHhD
	jyKqxHR0+tSNQs8rLDxlkIjZfNyJMYg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793611082;
	b=zs2ysfj5DP+qgf/K8AOWZa6My7af9tNKEOUBJWK4D1vNJQfNX/ncgHURhFV0EylsEwZhPN
	MPjWmjw7gv7Z4kY1/l4cTHVN5I8OJDI/IfOkGMZRiBhslRNIGnuu0t+oWKfWBQtVc57nBa
	OwZVswZI7G3LC4aG0FMtBZUHwaKdpXw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ClPd2EYT;
	spf=pass (imf27.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=3cY2UudyvcyVZyFhsHmGpx4qCCcBQj/0zwP0XEW/fCA=;
	b=ClPd2EYTruqDrFTIBXxg/SxZq0NfcKldWhARt3Kkf55FBkuk01TQ1hobDJ76BSvLhuF/XNLZI
	xmXfDPPmr0gsTaH0wUbz9XT1809qZ2ssd1mKYfdQqf4Mr/KM1iwzGdZA0lRmAP974K+A9ges6qe
	rsw7uo9T/HKBPirD6hjSrdM=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4jJ5hW4QkdzKm8l;
	Mon,  2 Nov 2026 17:17:47 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 01CBE40561;
	Mon,  2 Nov 2026 17:17:52 +0800 (CST)
Received: from [10.173.125.21] (10.173.125.21) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 2 Nov 2026 17:17:50 +0800
Subject: Re: [PATCH] mm/hugetlb: clear the hugetlb flag before leaking a
 hwpoisoned folio
To: Mani Tofigh <mt4022@columbia.edu>
CC: Naoya Horiguchi <nao.horiguchi@gmail.com>, Matthew Wilcox
	<willy@infradead.org>, Jane Chu <jane.chu@oracle.com>, <linux-mm@kvack.org>,
	<tz2294@columbia.edu>, Zi Yan <ziy@nvidia.com>, <kaitao.cheng@linux.dev>,
	<sashiko-reviews@lists.linux.dev>, Muchun Song <muchun.song@linux.dev>, Oscar
 Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Andrew
 Morton <akpm@linux-foundation.org>
References: <20261028-hugetlb-hwpoison-leak-v1-1-77ce56002523@columbia.edu>
 <sashiko-outbox-189633@kernel.org>
 <0043912c-4225-4d2a-a8aa-d160c832e7eb@columbia.edu>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <ae6058ae-3703-a1d5-d82f-4102b46f227b@huawei.com>
Date: Mon, 2 Nov 2026 17:17:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <0043912c-4225-4d2a-a8aa-d160c832e7eb@columbia.edu>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 whupemk100004.china.huawei.com (7.152.185.74)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E69C240005
X-Stat-Signature: 8fjpqe9ep59ofpdowxx8jx197fk4arut
X-Rspam-User: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793611079-988643
X-HE-Meta: U2FsdGVkX18Iu0KDBToC3phdvYCPONNoUjuvCBvQDPscyqChb96p7Hhky2LVSwsFzOCxdRFhuayhk0b9FdmCF3DxzUC4/IV326DGmo7Ot7jpVVdbIN5SSOr5TilX9ebSwK1+e+AkgTryexa27I6KmQt2fke6yUZIomNdOheEhLbNUiTxQTzfWJEA3LbNKzejhjEHl47C6KnQZ1gM7lRwa3B6fTEO/hNlVspnnfP0YPjPmE5ohepQqPyDaLyqsYFPxO4zEKL/ZyjrW2E3qwDOo0gViTQEwhsX0QQqNUS7aaVxZkxZCQ4DtJTUNoqswG3DT/LTx+iklG9sDpuS5iMufjHRvMhKdWprYdSCAluGWiSYunHgptHtLek406zyFKrA/kx+7b7EQrm0PAzQXej9hYjAVjadPE/q3VETBTxvcvLxbuPeJwyrcyWk3RS7IBB15dGuMLYJ1zznpeMfw0FREQ70bBfjqH8LyEml5wmnjsPGdeVMi0vunwoZsUkx7MHnqsXIehxlK4yh5yqqsCwpJUVwYng4V90ggAPliwitkKK5x36fJinwmaMqpJz43Zzevh+0+oEXeiTvGO7ORN0HYCGTIpOyRaQUvgIhxFruG3ukTt0gOMqAQ/pv4D3zDWR5JmvCIREihC/57ABRsDhQ4cOmBvz/CiEJUi1DZPVjooHh4N7Xc2vltGZLRoW8nESP0dcI4eH9dbrBAqz2lxJFu9BG06iDNR9I75SkeN1RF7EDQTByOLvTEoFvUH8dz4zNseQn8jatuZIq/uPlyv5pJ7iuODANfgmL5RtUpbUzozYKtH/JGMlMwKv160xh9L6RCTQrMiASuhSpiDiaNwNP88Fivbq/PjOF3SEQDZ9qyPKvTbD4YWVBFAPR97mlggHFv8zePL0VQQ+i5yKny/+/wiRz7IV8C07HZlu4+YoF577+78d04o5L2WBtTXe7tGWypC8+q5Mt/NWBlb16rwp
 boHrrFH1
 Wvha//Lt5aQ/NmcXAtYq0/MIJrZo1seg3NUZWKDgjCqXw4xOuwY2aOdviG3Us0cslsI4ceglVzCCLbD73a1IVGtF1R2NSOZ5zJC4C7bmy0gP6h3NQ8jZ8INVn+7rv63A3yUum6peka8ER1Syl1j3i29NEOWOtFU/8X36VRfE04AIAWBU2Vy3v4wKYL44RYk8KffTUAavNJBr8oByMuZEnAFpnaHIrz9MqbmtcIObrQW9F1YgB27sDaD1WTbDNG2Hq0Vh80A/w+KAg/sIoB/+7rIWucVxF5wU/Ga7nEflIvs87uCmBK5Z15oM0W5Hi5NoHKeCj8he2R0VquOfT4XIseF/B7P3JLvmQqLwpYzEsV1tqFWrri2e9FP+7dw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026/10/30 1:56, Mani Tofigh wrote:
> +Cc Zi, Kaitao
> 
> On 10/29/26 11:43 AM, sashiko-bot@kernel.org wrote:
>> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
>> - [Critical] mm/hugetlb: add_hugetlb_folio() clears HPG_raw_hwp_unreliable on error
>> -- 
>>
>> commit cae6d1104a254ddb073fab05f2a9308005af88fa
>> Author: Mani Tofigh <mt4022@columbia.edu>
>>
>> mm/hugetlb: clear the hugetlb flag before leaking a hwpoisoned folio
>>
>> This commit moves the folio_test_hugetlb_raw_hwp_unreliable() check in
>> __update_and_free_hugetlb_folio() to after the hugetlb flag is cleared, so
>> that vmemmap-optimized folios with unreliable hwpoison tracking are leaked as
>> non-hugetlb folios instead of causing dissolve paths to loop indefinitely.
>>
>> [Severity: Critical]
>> Can moving folio_test_hugetlb_raw_hwp_unreliable() below
>> hugetlb_vmemmap_restore_folio() cause hardware-poisoned subpages to be freed
>> back to the buddy allocator as healthy pages if vmemmap restoration fails?
>>
>> When hugetlb_update_hwpoison() fails to allocate a raw_hwp_page struct, it
>> marks the folio with HPG_raw_hwp_unreliable and frees the raw_hwp_page list
>> without transferring PG_hwpoison to the subpages:
>>
>> If the folio is later freed or dissolved and hugetlb_vmemmap_restore_folio()
>> succeeds, folio_test_hugetlb_raw_hwp_unreliable(folio) will now return false.
>> Wouldn't __update_and_free_hugetlb_folio() then call
>> folio_clear_hugetlb_hwpoison(), clearing PG_hwpoison on the head page against
>> an empty raw_hwp_page list, and release the poisoned subpages to
>> free_frozen_pages() as clean pages?
>>
> 
> This isn't something new with this patch. dissolve_free_hugetlb_folio()
> already drops raw_hwp_unreliable the same way when the vmemmap restore
> fails. Zi's change [1] to stop clearing folio->private in
> add_hugetlb_folio() would address this so I think this patch can rely
> on it too.
> 
> [1] https://lore.kernel.org/linux-mm/A1A14368-7A43-40ED-B2AB-C2EC2C5FFB1D@linux.dev/

But it might still not be a good idea to add hwpoisoned hugetlb folio back to hugepage_freelists?

Also, with this patch applied, these raw_hwp_unreliable hugetlb folios can be successfully
unpoisoned now? IIUC, after hugetlb flag is cleared, hugetlb specific information can not be seen
in unpoison_memory, so they are wrongly treated as normal pages.

One last thing, Can the problem described in the scenario below occur?
memory_failure -- VmemmapOptimized hugetlb folio but hugetlb flag is cleared
  try_memory_failure_hugetlb -- It's not considered as hugetlb now.
  TestSetPageHWPoison -- For subpages of VmemmapOptimized hugetlb folio, this could lead to problem?

Thanks.
.

> 
> Mani
> 
> .


