Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB2B3CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 07:04:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEE448E000C; Tue,  9 Sep 2025 03:04:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9F1B8E0001; Tue,  9 Sep 2025 03:04:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB4918E000C; Tue,  9 Sep 2025 03:04:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 958C98E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 03:04:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4C8CF13AC33
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:04:17 +0000 (UTC)
X-FDA: 83868822954.27.59059E8
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7FBF3A0006
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:04:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757401455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+bMOU7OXDUb7CdDMLHwHCfE2dtW4kbs92KScGwXbTcM=;
	b=DEmfJLyAb9NewsnUl4J6JtZ6Na+m5pLIYvEas13v9KTeJOSbijlWIi7JMs/lzlaHxsVZcq
	NEbtCs5U0vpsQC7o+beK2BowHRJgkJxptbYHVwCEaGYx9fIVzWzYNPsaRCj3t/tfH+iBNg
	zT2yErgOeld60lu6Aa3o9sTzFUon0GY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757401455; a=rsa-sha256;
	cv=none;
	b=gNhkmF/B2gofzohtPLHtLP/wqOkSH7nUhnJUoN9zUXYRR7z1qH655Ngn9Qs/52ZLyIzvn+
	Lf+EejHGWQTTa/2dCGJuD+AJEFaWF1z0TnG3NJT3Xx1AMXrnzHAgaPn3GBoikA8C1/8p62
	yvYbhNNX/3+8EEzQAeF+nWQ6xcW3MDI=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cLZSV2XqXz2CgMN;
	Tue,  9 Sep 2025 14:59:38 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 11C311A0190;
	Tue,  9 Sep 2025 15:04:10 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 9 Sep 2025 15:04:07 +0800
Message-ID: <bc4cbbdd-83d1-407a-a665-d503536afd37@huawei.com>
Date: Tue, 9 Sep 2025 15:04:06 +0800
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
 <aL7csJTwokJd7CV2@localhost.localdomain>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <aL7csJTwokJd7CV2@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: 7FBF3A0006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: uaa8pj4w5e65i5cks4qirkr8taiwskjb
X-HE-Tag: 1757401454-136880
X-HE-Meta: U2FsdGVkX18wu32E8LyhyyQ++vRRQjK9mzce0gAEhz/eVxBuVwCkBNuxCEdduD12/PHHdEmwV3Jg+S6N4wRHH8L4BEEqV1fp9ozH2GG9SL+LHfY2TUgSptgWXEg8dwtPm2Smn8ksEFMUwDmtBLdizR6PqpcM9wk1WBYPxzXTaJjrZmba6yEajbhORUQZOtPtMgfGGyucE7I5Zrq/WnLNlNm6VxbTJIVDY5ZOCkBT5pSYCf6kQ7GrhP7ups2NjHnuddqKR32qY2kD7Xf3iReo8w7y9YFVwuKOhyYz9LCcuo+BTjRAt5qal639ujGzJej3bzrWTMdgAT10Wl3+qGiq0NCVqB00cdillPJBOuA1kg788a4k6RXmTOdCjA7LywQM8JDBonnB9MogHttKrciqXo6Lb+4LbMS/oQPLiTHIkemJLWhPXC8HZ1O9n47gCgxHFgPU8jpaus9fYes55shwqd0g4vHjKjfEvyvcsyK+Bx6iEQ4BGwyOHhzuCeW4J0rHuvzHzRtKPNELpCgWdUZWQWOkKLZGFjJ9pUCEnrFLYX3Dck81Kw8tvwBZlisqlFs53jH4AgY95n5kZjZiydljJ4H9zNrAv2drmzqAvh9UfcVGn0xZSq1PTuqK6kgzbJDcRHHDNzBfefY+tyqe3HR5yW96/tirgigk43H62NZm5vBrlScIZ4J8zVZ3if/2jSAkGHId0tz2AxR7kr85k2xH/Ip7R+fKDxLKl6V+m45tjhVajFl+AwRCWZia28Zr/s7VnS3avanIblO6gA0Lvp0nPHMDVM2B6rM70uBS6cSG895HiAesTTjHB59SBWGeuGdHUdvXzDROpUkHV4JJUL1O6KELPnHKgUMZjMugvQevlQ+qekrI6tSx7EBgpldl+3O6+H4mu+Rj5NXRKS+vuTLA/jIlfYUpir+26+8n5hNFQ7ynHgugKhTTLmH1Iu0fLUSPfheRO+vwAoGfqnd0ohz
 TMzmyju7
 hulo5kB9nrNqPRObo7dXUF8QOacEfY5XUpVCyXBkinKZbVdekk4PH/Iy3t4ygKIPf4+LUxlr+J3MaU9l2hoDes9H7/+C1hkp0TjI30rnObGyR/Ahdr75iXvqWIB+R+Pknlg3STYnZxYoIgkIdajTEBtUb0ATnZl06RiFrFOLsTa0yk2ZzIdwHbWXED2DNNJr4+a/ewnq3KxeYx0BqrjqQXiNowP/qU5s+ovU8aefGKJLrEpldoj6hIVqbKCiXbjy9dALycgm3LsarOoX61GWJCUR+V5/Gym5N9Zl42gwArar86X3Jq/3pDSKtywEVYjyvIddZe0rneaK5/RRPiX/jxJEfWhEGK0i7I1EgmKPR7Nmd5d0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/8 21:40, Oscar Salvador wrote:
> On Tue, Sep 02, 2025 at 08:48:13PM +0800, Kefeng Wang wrote:
>> In order to avoid the wrong nid passed into the account, it's better
>> to move folio_nid() into account_new_hugetlb_folio().
> 
> I would state that we did it in the past, so it becomes more obvious.
> 

ACK, will do.

>> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> 
> Acked-by: Oscar Salvador <osalvador@suse.de>
> 
>   
> 


