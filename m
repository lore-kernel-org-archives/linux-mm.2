Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08C82CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 12:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E03BB6B009E; Thu, 18 Jun 2026 08:01:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB1E86B009F; Thu, 18 Jun 2026 08:01:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C54B16B00A0; Thu, 18 Jun 2026 08:01:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6112A6B009E
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:01:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 00AE590FF1
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:51:51 +0000 (UTC)
X-FDA: 84892869264.05.CC7FE11
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4C3E9C0005
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:51:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf22.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781783508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GCbu82FgMKaPfSwRksGlsYKrqYwUmU9k447omj8ktmY=;
	b=lCTNAbBbAho/PBk1BUwk6jW0dbvSMVZUE06g0ytZ/lzlFmUsxh0ztc/7LgpTMWhDaPpGip
	Tas5jx72EaZKENOGvlPKqHXvKm3Qd7UYLg/zz3VN+cJ+AufMiAUGVTWjkUgiVo1XWN6UYq
	UhG6G+mYqEi7It1npu1Lk8Nnk1I1fBs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf22.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781783508;
	b=ArVeKjdSBx6vPTD4zMNFpht/i7XnoTcycDB4RgBljhK/UdbIOQGowtIqtF3N3Wr7DKlv/c
	Ujr3n8DZBeSXMQUWMG3iNhmFQF32z5qbc/iy7TJP7Kh7j0A29UBPX7Buhy8cRQ/IoPQUO4
	ir3e25ebHlqL9cT/wOQG4w2oaz4xJ1Q=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4ggzZs4ymBzJ46ZQ;
	Thu, 18 Jun 2026 19:51:17 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id D153A4057A;
	Thu, 18 Jun 2026 19:51:43 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Jun 2026 14:51:43 +0300
Message-ID: <3565736e-f33b-4220-9978-a1461b6d4ee9@huawei-partners.com>
Date: Thu, 18 Jun 2026 14:51:42 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/3] mm/damon: introduce DAMON_HUGEPAGE for hot region
 hugepage collapsing
To: SeongJae Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260618001609.83965-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260618001609.83965-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4C3E9C0005
X-Stat-Signature: f8nb6zbxe1ochqizctz64cpqh4nkirwj
X-Rspam-User: 
X-HE-Tag: 1781783508-711715
X-HE-Meta: U2FsdGVkX1/L4sutdnEaE36Krhhz0BQ3jH4qa81fV9IpQuMDZOTI/3vRHmH+HbgimFV8hyD3L81802ESfBu7irtrSOjEf5s6KXF28A/7GpAEnZzjNXe6mz5siJxA9fZ/JZDRjy/+yMdUi/vvfFy7hUJk7zwokmBMBqjZmPOF41oFji8gr3TtA8rJEynHA9bY9kYTyO9wvoqYoiod9eQpwbBwcPgtV6jP6OU20T+Gav3IT9YUgZ8eOufEw/UGUApvLBN4gGx61BcUVTI2s21xJRXY+T7JQ1D+DaAQi2X24rk6nJIn7ReG1lJ4WE9c7W2f7ZII2Uhyc8BkOhFbPV2G5QP+YYWoDp6JOYsHDF+rbrzv9spPlhCYGajbmKrlyYCbUbTPD2hh19BA3CqtmwOcC+TEa1jggzSr41DUzkJPwlaVVwLpfGtMmc7CMTKGF4LLOmYZi96Ie9ZeTx4wTW0xRHxtAuTw4dnzQoFZhOWCb8OnfNcqEKpLpYILe3c6ixKoiwQcXy4OSP6j0/wagoUt2jV0CCr73ejpGucPB9Gs3O5MOizPp2a7KmmQNrEnf5m/LVLw9jCVBak8TrZCv8oI/y5YhYNnd45e8uk+fnDnoup2Lt1C1k0TVrXQEMGfV81ceFA4VQ2qJ8/EbFFuSZIyl0bntVLarjbOb8GcNwUOaq9nZH/pLQ+7Qb1tqDFncbqjENrXNgj9nBqklauCYEexo/ubWg1IESI6JBupxMfoyPjgOQP9v/j1n23ahq+iHWhJzoCDiJGKfd6cNndmb3/JWL3DI9xOWPLsGGvdxScNMSoEbIYgurwYHhz415+gRe14wy3Jj5jMgTOJQQ3F5+LHjV2gClih9Kk/Ra70pEwLVAlc4GutyaD04uis2oyxV0lifRvUFwXi53TKhduOLR0sYwNaPSZY9TwM4Rf+ZBn6b2nrGGtN08nfhOz+Bah5r5vpo2HkaUZN+HK/2adInxq
 IjWCLAvy
 hhkgFEshSktAPn6tTDRf0ol87txOkZvGMM6g9NUJxMXU6wKX3/qPvlC4D591VfwhcSAoUW4oy8rdZIzL05RMiQnChkpI5DykBYncCk6exAu6S2jbKwdZDhRxHS9Ni9hbz2hZwJBT4/4mu3mKJv7ebOdJIOrjZq5zQxgJw5hmCJlH52VUtLwK6wolg0Yt6Bvb1jiLIG7pFQemyaaJzZOnJKFw1BZRatQ3/lEE3GSAeseYKaL9RnzX+CiHKNXqvzvG3AzrlWLjhPS2HBcb5uIUfYgfqyvBgCtrlYqUPPMlBtzPupFq0S7UJEuCseLa8oq7iY0a5xKRu634nc+brdw5HbvYhLIYuiVDjFMV5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On 6/18/2026 3:16 AM, SeongJae Park wrote:
> On Tue, 16 Jun 2026 21:04:52 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
>> On Tue, 16 Jun 2026 15:03:15 +0000 <gutierrez.asier@huawei-partners.com> wrote:
>>
>>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>>
>>> This patch introduces a new DAMON module (SAMPLE_DAMON_HPAGE)
>>> which collapses hot regions into huge pages.
> 
> As I mentioned on the previous version of this series, this sample module looks
> much better than the initial shape to my humble eyes.  Much smaller and
> simpler.  I really appreciate Asier's efforts on making this.
> 
> However... I was asking myself if this module is really needed last night, and
> still got not real good and confident answer.
> 
> After all, this is a sample module.  The purpose is to show sample code thhat
> helps people understanding how they can use DAMON API.  Maybe we can argue this
> module can be helpful at understanding how DAMOS quota goal can be used.  But,
> mtier is already showing that.  So I cannot say what new advantage this module
> is really bringing.
You are right, the main goal was to show how this quota goal can be used. 
> Meanwhile, this patch adds ~200 lines of code.  It is a very small and simple
> sample module, but still we should maintain it.  I, to be honest, getting
> little bit concerned about the maintenance overhead now.
I understand your concerns. I know code need maintenance, and DAMON is already
growing significantly.
> So, if Asier has a good reason to add this module that I'm missing, I'd like to
> humbly ask to consider dropping of this module for now.  I'm so sorry for
> raising this concern this late.  But, Asier, may I ask what do you think?
So, are you suggesting to drop the module and upstreaming only the DAMOS quota
goal stuff?> 
> Thanks,
> SJ
> 
> [...]
> 

-- 
Asier Gutierrez
Huawei


