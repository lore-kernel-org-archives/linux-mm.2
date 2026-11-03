Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9AD0606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 04:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=AiCKDC/D
Received: by kanga.kvack.org (Postfix)
	id 904076B05B7; Mon,  2 Nov 2026 23:06:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B7326B05B9; Mon,  2 Nov 2026 23:06:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CB616B05BC; Mon,  2 Nov 2026 23:06:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5A28B6B05B7
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:06:33 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D4C8C12031D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 04:06:32 +0000 (UTC)
X-FDA: 85392471024.02.FDEB338
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf24.hostedemail.com (Postfix) with ESMTP id B4A94180002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 04:06:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="AiCKDC/D";
	spf=pass (imf24.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793678790;
	b=QX0pFRwofRmYjalENTWvyh9FlzbBz32EIDHJvWPvsh03tfESTT4nemBgNywZeTXM59A1Lz
	PX8JGjyNbVWBUCvcFWzgO8VgKkX9Y7ZFU64R1k2d0WMn97tTWJ3nJAicr7XrQeZF3WxmOv
	x/UN00pAXsbHOWurGgwbrxkL+tziIAY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="AiCKDC/D";
	spf=pass (imf24.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793678790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AcFqDwtiV6rX/1kiFJP1UgoU1QYRoQe7e9iwLBlgccg=;
	b=ezGh3Cal868mx3Yl2oKTiG5mNvqaK4LFYM/r69GWOGSAqFBY/eS0NxMC01qYr9l5U73S5y
	XVzeLhyXcxiQ1Ei7cLmT03OOiVbDbA08s6WrPN+NUexCxV7xciHxEnC4tEUd5Lj/ESfbg1
	yBOVtieKG67B+EOAfgwqWrsiRUbNvkI=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=AcFqDwtiV6rX/1kiFJP1UgoU1QYRoQe7e9iwLBlgccg=;
	b=AiCKDC/DGECtzH42U4ECstiLVnkgVLuQrpERgYTGnpzUsnegWgKUA6n88EA/TiKYbKrlhlM0j
	4nIlEr7UNR4uWhR11O529qeX4pfaxLI0TJDWlf/ZK1m/i1ghtEsgxpz4AWzl1U9IGBiFr0+fy6r
	iFxjbLV5OssO8j+iBcjgOtE=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4jJZkZ2WFLzLlVb;
	Tue,  3 Nov 2026 12:06:14 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 6AF8D40563;
	Tue,  3 Nov 2026 12:06:24 +0800 (CST)
Received: from [10.173.125.21] (10.173.125.21) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 3 Nov 2026 12:06:22 +0800
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
 <ae6058ae-3703-a1d5-d82f-4102b46f227b@huawei.com>
 <5b5dbd0e-6f29-4573-bbc4-1d07fbcbf1fd@columbia.edu>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <add2352a-cf04-aea1-d253-e7279b18bcbd@huawei.com>
Date: Tue, 3 Nov 2026 12:06:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <5b5dbd0e-6f29-4573-bbc4-1d07fbcbf1fd@columbia.edu>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 whupemk100004.china.huawei.com (7.152.185.74)
X-Stat-Signature: 5t3pg4kaxzhmsbitzmya4gksxgrkbe4z
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B4A94180002
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793678788-46616
X-HE-Meta: U2FsdGVkX19WigTSUobpQGXzHdGoG3gE4T+JdkMrUXlCn4SvDfuKd3LERM+yPf4R0XY0mD4USDxUivDgUHNWhLUy5bvNrjxGUgx4YzM6quZrPuMvMhyQeKnd+D4uPB0eT1wZ+WD656RnCMvNdyKnj53cnXSmstcAlnSv2PCllUKM3lhHvd5r+96gH3SNWXzZtVEmi+93fTej2j8eNFbKYJdvBKWryipX/sjfKOUiEwXD51GZtpN5+ngxfkM00HxZiMfZAE5XriC9QfV/sWjyTj8lG5bWCn57vOOfazdL/PbVNWEmCgl/p8ul44Ml1W59JYpnNveOv4jBRr3VfyRKDiueTTGnZk2LqOCa0sx686yQNybo7xPr8HpCKoqoN1vG4MAScWWCHDmIfuOM1dclNQt/0db7rQMCXgG2mbGCt6iJKGqyx5czDOEjUGoIx5/inIN/kkEEB9ZOiYHfIYmbxojlgA0omKTDa+zT2FYZy2PaggJQWe65G5kFT7e90DQ4XVFJCVEZi3XbTvNPit9UFyiMauJuuCd2UrGw74CI+sRf2JOi5xnWEmHuxJMbb5DVtsj+PnjYkBWioh0wnBIKDj8YgIjc/0QnNOkH7+nV4kLpUnhdTBbul5mvh2ZQqb++IJo+PJVLBf4Tk+d84B/JI7bkAGko6hzPAdHTpUVIT8bz2fYGQ/mVzBBvXBQN2w2+FCd0pDEwBZK9KWZLrq3wZH18FgspJB9QvDazB/ItNdgGI6ArHYthM0JOj8oPjbl5gzqSjBWCHoe7NiQtiTbTgvlgknlDvtdwtMAPCf/hMbjeaa4/cHKwpstKOTwDld78Qadk2jThdWrTMvXNgikVoNDRdbPLemm3FHYb4mwZqC8qq6Q39kvuJvD1ee+Wjt+p2lZ7IifkBnbHqLXj8+9ZVd70+SE6ypxb19nhBfaahv/8Bd1Go7Ci8uB8QV3mq4iexJDk4BZitQkMG+buomz
 mFMaPMZz
 xDwW5WxER9Hi92LeqqJFun4eZ7LJQxi1cS0pTbvXK4Ai1StGkTWHVjqO0xXiLtLySgVC7LrBTQQBLtxbPgfxGzQoP5mq4NQMNodoLVpmWKd3/ADCVzWLlzmVxuwODILJec+SlKuuYgv08xYOT5fKCtkTh88n7Wo/d6hPsSSog5hzIVdJi3//+HUdPnev7QS1QMyEjgXoUQJYuPoOuNxmd5yJ9e4fojahC9mlgIGhgo/bhJdrm6tFckvCGksHwN18fJZAdg8OC71teU5anqudbcQVDgjqIWawbdNpVxU8kA3+5ot1js6ddJsw6x8m0rOTKnyxwXKRLB/mbOtD8sv6t6YXW/MaJrjkNFXplGkVLeGLuMKRUpqjeNnS39F/0pz4x56hD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026/11/3 4:24, Mani Tofigh wrote:
> On 11/2/26 4:17 AM, Miaohe Lin wrote:
>> But it might still not be a good idea to add hwpoisoned hugetlb folio back to hugepage_freelists?
>>
> 
> Agreed, but that's already what happens to any hwpoisoned
> folio when the vmemmap restore fails, both here and in
> dissolve_free_hugetlb_folio(). dequeue_hugetlb_folio_node_exact() skips
> hwpoisoned folios so it never gets handed out, and a later dissolve tries again.
> This patch only lets unreliable folios take the same path.

I see.

> 
> 
>> Also, with this patch applied, these raw_hwp_unreliable hugetlb folios can be successfully
>> unpoisoned now? IIUC, after hugetlb flag is cleared, hugetlb specific information can not be seen
>> in unpoison_memory, so they are wrongly treated as normal pages.
>>
> 
> Good catch, you're right. I'll make unpoison_memory()
> avoid this in v2.
> 
>> One last thing, Can the problem described in the scenario below occur?
>> memory_failure -- VmemmapOptimized hugetlb folio but hugetlb flag is cleared
>>    try_memory_failure_hugetlb -- It's not considered as hugetlb now.
>>    TestSetPageHWPoison -- For subpages of VmemmapOptimized hugetlb folio, this could lead to problem?
>>
> 
> I don't think so.  The hugetlb flag is cleared only after
> hugetlb_vmemmap_restore_folio() succeeds, and if it fails the folio goes
> back on the freelist still as hugetlb.  So a leaked folio always has its
> full vmemmap, and TestSetPageHWPoison() on a subpage only touches that
> page's own struct page.

Makes sense to me.

Thanks.
.

