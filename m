Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF769CA100B
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 06:23:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 402C88E0006; Wed,  3 Sep 2025 02:23:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B3C68E0001; Wed,  3 Sep 2025 02:23:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F7868E0006; Wed,  3 Sep 2025 02:23:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 228558E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 02:23:08 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B8F1B1404E0
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 06:23:07 +0000 (UTC)
X-FDA: 83846946414.15.2695DB8
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id E525B4000A
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 06:23:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf11.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756880586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xPv3BwPAMgx4p3qpUZqWmSky2KO+HERu7fEQ1KpK6cc=;
	b=qhKJuDbGlUMFM52qKaq8dw60kQh8U2EIieUPOdakKc3LQLMFvy3JY6u48PD7e7AUpLnRvK
	tTSXJTDSL+Jiqe6y0pBuFqpLWSDaBNpISxNjKLs6He/XLGJbVvDwa5A5rPXNQKOj3Rz2QK
	pdMtDYGySzaibuSEVMxXlj3/VSifkkc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf11.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756880586; a=rsa-sha256;
	cv=none;
	b=GIOl66dj2xwxaM5cFaqicog9r/BTfAL2WEfQD6RYT+jyYHEV3meYz28zdllyjua6xLg6MC
	fBntKCBtTLR52Y4GQTVrve2vZ7lDbuJ8hUOkLJQgWsTyNdW4/iniV+/2qeo/SlFP9ZOEU/
	bWIxoJM84PCGoPex2us5bSmcQNB/sRg=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4cGsyJ73bZz27j7G;
	Wed,  3 Sep 2025 14:24:08 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 296341A016C;
	Wed,  3 Sep 2025 14:23:01 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 3 Sep 2025 14:23:00 +0800
Message-ID: <763d9a72-d1a9-4352-ab77-05891bd94dc3@huawei.com>
Date: Wed, 3 Sep 2025 14:22:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] filemap: optimize order0 folio in filemap_map_pages
To: Matthew Wilcox <willy@infradead.org>
CC: David Hildenbrand <david@redhat.com>, Jinjiang Tu <tujinjiang@huawei.com>,
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>
References: <20250819140653.3229136-1-tujinjiang@huawei.com>
 <aKSdsH_yk69EvkMX@casper.infradead.org>
 <b7a1100c-2302-4781-97c3-1146ed2b44a7@huawei.com>
 <aKXCz0QOlE8QkPIn@casper.infradead.org>
 <98f0333d-1ae6-4a5b-b5cd-c8abddbfae5e@huawei.com>
 <aKcU-fzxeW3xT5Wv@casper.infradead.org>
 <bb6e89e1-ff86-43cf-980d-b03b644d85be@redhat.com>
 <aKcdBrq_xwOeUQTp@casper.infradead.org>
 <b990aa82-bc98-4739-89e3-44c96e0117a1@redhat.com>
 <1c51623c-818c-4135-a9b1-28d0b4edbc89@huawei.com>
 <aLfJFKBZCjhH7so2@casper.infradead.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <aLfJFKBZCjhH7so2@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E525B4000A
X-Stat-Signature: 1qzs9hxqpxutcic3ir955s6jibeyxt5a
X-Rspam-User: 
X-HE-Tag: 1756880584-36816
X-HE-Meta: U2FsdGVkX182uEQze9yUXJOjlXwnDAJseZJpB49In57h/58pzbyHnT15ciICSRbJUSz8I9UepI9bQlGaMb38KI7Llst+BMj5IAlt6P0KJRfdBvcveBlwW+5US88atWi8uln3Yb2SafPSuByNF5d6BshYt6TqfySWw0WlCZmUY+hnXG64sRDhw7hp3elPefZfgCNnInkZ2BvNkuRt3NijPY6vjMimKi9p5vAwD08cS1C2WKDoEBOQc0LVOfNnfPjlox4bjIWuDFrjTrp1gqYikdtxd30P/vtf6vvO1eUpzkRLeWlU2jxS+bmbtTvxrOJbD3PjCwSmhEbz9bbX9Zbc+TQLaYjbESBocPztWVdG8U8jllz8MskHLZsADGrKlxUBKKlvpBWdtPAXAmJujEY0vQZKMLEmcePwhd7jpnoNlOYetToI+ditlLaHnKFkUmvdwM+q2EpusWkC0DaUZ7bXFCjZz+jfyBVAxkoV2iYQVSXwBrxvFew768pzBhAZLoBpcHg7uxRJuEjyDS/leaDk5UQPHMXeDBCvKfquqqXsnFzI1Kjlv/MwI8ev3HVzyX8xk0aXCLXohpOWI+07FGw4/XVR0qLAkhZKg0gOppOpQXsJMR/OKvBL6rwnk+RW5DFBbg9e13EagFmq7/XvtcyAYvmpSQ7v342Os5HOB4JgthUHAAy+ytCpc/8UHtOuXKgeAQUUxz7JoLaQ1XGTRthdjLQQAh8JYjrmqlx1TvnLQUUO8u+8Fr7f/kuhjeE0rSOjgg9kCIj0R0r0XGYpg7P++C6Vk90ZiQhbFzM97ilmhY7s7CMGKfkEWfb8KyxIBv1y3QqkswNzcsm1D2nG1zLub6Orzq5tKLWBXLJsyUOt8mZw8GvrBh62BHfybLhm2EZPUFIa0hKS895m+UxcYOI6sLthnUYiXK7qaNN51GMV3RwPskKqs9wZRCwH7GU+3W8D77LHDCTwM1psc61C67t
 8qZAM1fJ
 SusK8KBzXEXIiJZzXlcJMJIYVQICUGpgIkShcjzdWmXUg4ZLbZ7ryld2QmaSk4H/JuzCV1APusCfm5637MuInE+XH9Yp66Y9VnBn0/Tu/w/qZJLXfFye9mBeOlCnzx4l93ZiDQoKEdCoErPcByPeu0bx1PeCSKgQUTpl1U/DBEpRQewjEMmD67peXuAjZE/MMEwAaD3MnzcNEjLZPUqhnobG0pAcP52uR/lDwebLMMWfxTaE3PPibmzrAdPrZnzfpIZJ9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/3 12:50, Matthew Wilcox wrote:
> On Tue, Sep 02, 2025 at 10:04:09PM +0800, Kefeng Wang wrote:
>> So, Andrew, could you help to pick this up?
> 
> NAK.  Send a version that does not move the folio_unlock().
> 
OK, Jinjian, please update.

