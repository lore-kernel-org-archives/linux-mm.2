Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 083AACAC586
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 13:20:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D93D8E000E; Mon,  8 Sep 2025 09:20:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 289EA8E0005; Mon,  8 Sep 2025 09:20:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19FAA8E000E; Mon,  8 Sep 2025 09:20:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0C7448E0005
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:20:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B16661177ED
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:20:25 +0000 (UTC)
X-FDA: 83866142010.16.F00A842
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6D22A140003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:20:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757337624; a=rsa-sha256;
	cv=none;
	b=hg04Q1g8xDfTMOlbH5zhEf2oSFe5t6t/gySSEzIryYrB4vA27oF3m7Xqrroi/zFqSwsziN
	L57GLn/0ksRUkDXZADVlazjsxZ+mnWuzqXG6fNDH2uBYopA7xYDiNhZRitC08EbJ0vAs15
	Rl4WtuEV68OqFcxx5+ncAeHLv/J69/c=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757337624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zk6TOYAY9OHCY9YbaT8ltAM4xqZJYTcDK7QhPb+T/V8=;
	b=bhgJV9CNyT+dOuiak5t8rueqLjjhYmyCONdglI38gCNSwELf77bX9ui/USuZP71TzKSNLK
	qUyDGnrcvuhYbaCbKb+M+BL4S8FBfKgpEC+GGy0BAdle3/eRq7DrUPE1jTneV+qZlS6W8q
	Gh+TbXbtBiS1VxaZCOuEcsmyqJoO2No=
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cL6ry6qsWz2CgDX;
	Mon,  8 Sep 2025 21:15:46 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 55041180043;
	Mon,  8 Sep 2025 21:20:18 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 8 Sep 2025 21:20:17 +0800
Message-ID: <c4e05935-ebb7-41a7-a86e-07e00106bb56@huawei.com>
Date: Mon, 8 Sep 2025 21:20:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/9] mm: hugetlb: convert to
 account_new_hugetlb_folio()
To: Oscar Salvador <osalvador@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Muchun Song <muchun.song@linux.dev>,
	<sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan <ziy@nvidia.com>,
	Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, <linux-mm@kvack.org>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
 <20250902124820.3081488-3-wangkefeng.wang@huawei.com>
 <aL6hUFNImBtW8OdL@localhost.localdomain>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <aL6hUFNImBtW8OdL@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6D22A140003
X-Stat-Signature: yjs4h5o58e55x81pbf88xriu6efet3ta
X-Rspam-User: 
X-HE-Tag: 1757337622-90945
X-HE-Meta: U2FsdGVkX1/u5jM0EzNafH3mLa66knzmI0czUR8dBr0hB7DxdMOo6vwmyNDWLr3Ny3AFcrMWLhNJjKAvpLSjcNow5AdKTBeBiD8UM1jgoMaYD6zLh3A72thcnIoDtQ/MqqBCphCCzqLqn7lq0XPP5iq+2eudge+9lIf22ZAqQ563nuTkLEq0Z3sWBITwFE1mF3gosobpqLAyYSAq6d+xNEmUzlaos8ZQKJpghSzuKM31pq+dUybPfbBJvO1ghd1YrMG8tpE/9sIOZ/0rlm0vf3vjCYPhgtPECHoYKOhhH5dj/ftJ3XJ/qhaAkd+VqaVEfdI0QlWPg+2KKp7gOdoncQbrPVv6XpuMnaFp6yCiWfTLsIEV/ucWG/W4tyLr1bGwZ+9eWY0B18Bcc3MmoFFeZb30qGoQYhkIKXnNYfDzAO4wPYUfFzc19OyirmjTkElllf8d3XTpJZC+atP40LCiJVn1Ajwefo5rmmntDk43B/kHuELpK5oY3JdmIk7ao8D9NXoeO+j8ZZae+u7+xRG+sQOG1EvMFysQ1gTzcDTCG4Ka4ZiCZ/2SKxAA8+n44BcjKNXM352iH+eOxdx/OgcJpZcOFeK3UBgtKHSJMXZRFKEKRwMgFD0XiU5nXw05z9Rud0zvmNShSWoGp8x6Mf1xSJcE0Pd84xoLGBeRVuHQYAR1UrbHjeUpiCpRZUGGy4afU4fq33iUfa8FDUWps7BI0vQ0SXr2IAAHhOLLydOFsZ3IzkLiM7eX5zy9YiZiOZyM8mwCzdW9eiYxqy03EzJdWSSThQrwQUvWEWZ/fpLGSX4q5SmbOWEQiUgO59lPreJESyG8f/FwCp6rZo6gNPCH7uuNpH0KSNCC0/ORQDRdNSqcUseyXfS50BMTn7LtvRXMYOHIAedvQmQyGi4JNX7y+sHlTYa6fQwHPLAhgNmdT0ocmFABySakpYIFT3MSDpBeF3emC/SGdS2h4MWpwc3
 aMYYmY8l
 3obbeIf37Dk46l+7cMZ+5F1Lsg1yS8Oep+oJ2FX/YTAG6qtNsvdMoORMO46l2KVtlNF4l3lZ1vU+4/EBWX1ijtuvJdq8T8S8y2p1NzVVoXfQvllcz8z2gcUZKzfXaEJ6BkigMDI0tf62ogdH0HFBH+edpCqzUHeD8uoIrt4opg90KMgXEUrqG2toUCkBqM7OkDoAGFFgGczK8DyZzXU9EUfeszwRr9hprlVVJ5q0rP3zXpm2AhQh6CubLc/KZ9KkitN0UiveuZgiko1zqQ7HaBCMpG0jxPZBQ5EmaSNO0YwcpY75iSqf9AiXL7dNQw+nhJpHF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/8 17:26, Oscar Salvador wrote:
> On Tue, Sep 02, 2025 at 08:48:13PM +0800, Kefeng Wang wrote:
>> In order to avoid the wrong nid passed into the account, it's better
>> to move folio_nid() into account_new_hugetlb_folio().
> 
> I might need more context here because this reads like there is a potential problem
> and we are fixing something.
> 
> Are we worried about a mismatch? Have we seen it? Just theoretical?


We did make such mistake before, see commit commit 382360d289c1 
(mm/hugetlb: fix nid mismatch in alloc_surplus_hugetlb_folio()), so it's
better to move it inside.



