Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FBF0E9539A
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 13:07:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69C386B009B; Wed,  4 Feb 2026 08:07:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67DCF6B00A9; Wed,  4 Feb 2026 08:07:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A6CD6B00B4; Wed,  4 Feb 2026 08:07:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BC446B009B
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 08:07:50 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E1EAF5687F
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 13:07:49 +0000 (UTC)
X-FDA: 84406801458.12.D96C889
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3A5CAC0002
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 13:07:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770210468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p3b61zAwG+EG/B2dJ4JYY9LqFwDVxhmn4f7iI8adQsQ=;
	b=QpTMgb1mlIoagiuWdM6i1ntKuFt/9MixCL5u7EGocNFaUof5NE/AWuJWwUQKJnAa2TQ0jN
	kbLOWB1IeiWDqt33w4YqEgn5fQvvRSRbkKKTcVV23Ly5AJWEWBxCQ6KfLdtEvcXGFzqoVw
	OEaGIuLRy2+C68c0PhOEHHqwMlm5dyA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770210468; a=rsa-sha256;
	cv=none;
	b=6DWcwLTB4whXliLOHRv662p+g+pVFj12i1Naiuq7S3HecWByHZQpE/YJw+V+mUd1vtBr90
	pTr7DNYt9mxWxz80Yf9BoDueO8MNRV5xuUYxJGtpOXH9Qo3ikixYdC1vj+RyIetg8PbGap
	1gcYAxoWSfqLZinoQJnFqRht8ryLFP8=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f5gbg5N0HzHnGk1;
	Wed,  4 Feb 2026 21:06:39 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 1E36D40569;
	Wed,  4 Feb 2026 21:07:41 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 4 Feb 2026 16:07:40 +0300
Message-ID: <8b8e9dde-33ff-41f7-8563-d9aeaf5efeb5@huawei-partners.com>
Date: Wed, 4 Feb 2026 16:07:40 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 0/4] mm/damon: Support hot application detections
To: SeongJae Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260204071712.16325-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260204071712.16325-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam12
X-Stat-Signature: wyi75td8oa8d7nwuy4o8wyisemsuc3nz
X-Rspamd-Queue-Id: 3A5CAC0002
X-Rspam-User: 
X-HE-Tag: 1770210466-700287
X-HE-Meta: U2FsdGVkX1/r6fSdoxqsEPXovXwGFztPpXOONOdCojIr2/u8cfex0/as+M33QL820GVJ9KGYyut7Lb0UL+c0XqyYCDY0oPUD8CP/VTPdWC9LVxzyGPe5Gyzc4CHyBdPleJGiCANTslnaCFLxYQo6h9PjNZUhwyxjV8QMd9NESug3AQSPwssyCCBHstEo7J3V4pZetGPBeo/kSLl+PbmklC8viHMke/lTxSuRrvHcV5T/KbzTx6/RgqMpVDMOVI4faGFbQxmH+hPveKkvIra9LlQoLIr7Mbu/pIJEo7ZeV0AHSqYhqZaHU9BY8w2OdXR26rs2mFTV2jn6838s31SSFSQj5o1SHrFArwL8v110ODjhJJ8H7GWkNRgre6SxcHCpWIds7Xa+u4eqneZtKvmk/Ft1Mx6ltfAw9siO7Qn0qNXfw6FuZmRgLdWsuGaC4JBwB+BtdbfBX0ox1ulW/vshnHR8lwi3Y0v+dpYo3YLlCDPzTBzS9bUvF4YwqnzYGfjW73Brrf65VOl5aIZAPsRfzZX29GQMzmnHxnF9Zn0zY81VyKIvlM4jWaV7kx2GEks9HgfkE+zo8ftDv4gw1Lp44fxPq9+kV5wlSfg2Vv2MlsnquuVF5G8KazbrdK1KdIGJXaZhISYG8QRFLaIhssckSkDBEHSCoPNs+eF6V/XvlpOw+Jp8qXCe/IYK2LFNJcFGmtgfsIBHGn9PeOaim1Fj4W/U3P0m2DcRFOEstzx5SX6A90nmCKyV5HY+DUd2rJugPQ/ns4NeMVpiYnEAEhrGUB9qzJQVVT27Mz3N5xe0Io50r6y/ET516SdPyU29WXPD43r8BCt5eh8AeMq7MiYBTqfzAwdInq+sc2rq0kIB4q9DbLFUZb5MyRQfQBoZdoeKUhOv6toJH9tEG5CZk3UoM+dVZ+q87fOmYBiow8P+FL3S7PCcF4lDdhmgK1/ZIhJ5pLOxFHcM5n4Eekg80cj
 rjdUgh3C
 R5znSdDsmEKnZ/XDzW+A5vrRI/IcSZ9XlIao/xjODCYheFED1wYWKOD4xfRLEe7bMTetbd3ZPhJg+z8troNfDspOixT4Zr+0iPOLRq9tWToVZlvU/ItuoKC8loEsjuqbCIZeBt+JFZbbE/H0THQfFNqvMcHm0350qoPDwHN2SA1YvdzlCjX1l7C2z6k/SrRaWVaP2DWV72T4UXerBNf0TCsu6b6Sbcfne+39Jyqdfexu33JYGa6xRG/yTMPlEv6zBLglpShtGIkH10Xqgda7hn9gq8g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000376, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/4/2026 10:17 AM, SeongJae Park wrote:
> On Tue, 3 Feb 2026 17:25:11 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:
> 
>> SeongJae,
>>
>> Thanks a lot for all the useful feedback.
> 
> The pleasure is mine! :)
> 
>>
>> One thing that I was not sure about while working on this patch set
>> is whether to have an external new module or adding the logic to 
>> damon core. I mean, the hot application detecting can be useful for
>> all other modules and can improve DAMON performance.
> 
> All exising non-sample DAMON modules are working for the physical address
> space.  I hence finding no many opportunities to bring benefits of hot
> application detection to those.
> 
> I agree the hot applications detection could be useful in general and creative
> DAMON use cases for virtual address spaces.  Implementing the feature in DAMON
> core layer and exposing it via DAMON sysfs interface will help such use cases.
> But it seems not straightforward to imagine how the sysfs interface can be
> extended for the feature.
> 
> So, I think it would better to be implemented inside the new module at the
> moment.  Later, if we end up having more modules that use the feature, we could
> move it to the modules-common or the core.  If we further find a good way to
> integrate that with sysfs interface, definitely it could go to core.
> 
> From this point, however, I realize the feature can also be implemented in the
> user sapce in a pretty straightforward way.  Have you considered that?

I though about it. However, accessing the task_struct directly and extracting
the utime is much more efficient that getting the required info from the user
space.

> 
>> What do you think?
>> My implementation was module based because I tried to avoid changes
>> to DAMON core for the RFC.
> 
> If there is a good reason to implement that not in the user space but the
> kernel space, as I mentioned above, it seems the module is the right place to
> me.
> 
> 
> Thanks,
> SJ
> 
> [...]
> 

-- 
Asier Gutierrez
Huawei


