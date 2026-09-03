Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54BA1C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 13:41:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42B6E6B00A5; Thu,  3 Sep 2026 09:41:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4028A6B00A6; Thu,  3 Sep 2026 09:41:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 319046B00A7; Thu,  3 Sep 2026 09:41:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 139516B00A5
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:41:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A0C991A0532
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:41:06 +0000 (UTC)
X-FDA: 85172562132.02.FEE5E17
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf16.hostedemail.com (Postfix) with ESMTP id 169F718000E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:41:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ezLDGvXe;
	spf=pass (imf16.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788442864;
	b=qVc4TFuKPQDtOMQVtwByxowSIge82X2J1ygw3kT7WG7V+Vi0qC/DWPDfTbd7UK17BIvA0U
	lOisBaVYtdYpgcWNauRFWHIy5hrfMeJqKU61s32+J72uC6/5LfSk65LDycDqgBqnFp3ILt
	ikxuL9VYvlsP01n5gFGKWmD/iah4pQQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788442864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fQtyka4OcFhdtfGP0HUFcu8ekTPMTXBkpViLDk0kGes=;
	b=zN88SmkoryRuiXUpHddIoM9yLXjdzO/2wqAzXz6JtGPjhCpPcAALq1jgyx98SWrnEa0L0E
	H2S3cf0zgIMprwQHeeKon1kzwLY0uOL7AZgGdbaKr6uEc2bqLRjdB4A86lDEgiqUN8pXZt
	7gHuwb6KspOb36PngakdsIAuFhDe0hs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ezLDGvXe;
	spf=pass (imf16.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=fQtyka4OcFhdtfGP0HUFcu8ekTPMTXBkpViLDk0kGes=;
	b=ezLDGvXe7CoZkFO93WGPG98VZOeBPrtQVEwrHshQc1iCFmCaFDWr3bhpgIj19lLKgZwJwva64
	GRUod5vHqxXqZV1CgtFfBYxcMdg7O//e96me8/gBrIeen8Sq72HnKMkWY/rScnVmnqdSUm/x3ub
	OZyvnzxmSR2u/UZ4EXtn1Is=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hbL6z5qnRznTx7;
	Thu,  3 Sep 2026 21:29:47 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 53ED640586;
	Thu,  3 Sep 2026 21:41:00 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 kwepemk300003.china.huawei.com (7.202.195.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 3 Sep 2026 21:40:59 +0800
Message-ID: <cff1d446-4994-4321-a37b-09936520fc50@huawei.com>
Date: Thu, 3 Sep 2026 21:40:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] mm: replace PF_KCOMPACTD/PF_KSWAPD with
 kthread_func()
To: Andrew Morton <akpm@linux-foundation.org>
CC: <brauner@kernel.org>, <djwong@kernel.org>, <cem@kernel.org>,
	<vbabka@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<brendan.jackman@linux.dev>, <hannes@cmpxchg.org>, <ziy@nvidia.com>,
	<david@kernel.org>, <qi.zheng@linux.dev>, <shakeel.butt@linux.dev>,
	<ljs@kernel.org>, <linux-xfs@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
References: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
 <20260902134417.c44503a1d65533f81fb1c391@linux-foundation.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <20260902134417.c44503a1d65533f81fb1c391@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 169F718000E
X-Stat-Signature: mcpg3gbszox4qa95a15pr1mycw87yb77
X-HE-Tag: 1788442863-453354
X-HE-Meta: U2FsdGVkX18sx6RFwBNCGUojelVR3xRfIuiZQZLL/GIx+2ixesOILRLjJivu9N+ZU20hirdyKpjA5LVQIefKXOTok8h7m2ZilxHWUdbRHSURMiP374UsJJHeMCLJsOGUcGNutXEdhjpm39jMFY9WzM6uMU4IJ4pM5V/f+5/WwJ5l9O+eTAlOVPPhYajvgtbACyCh+dOmNCBmhGaxXlHmZcKZ/hhTK8qry7D6qhX1lLa83jripitSxE/k5rEoFEe0eutr4erkO2tDbx6J/TIPGLzLwJjMkXELxGg1o2RdqXMATbgGAkSxNqdSk5qN6SvKcXxJBIXDk8MZTnNwwulc6qr5/47kqTio4kRCQIG3mpmCsvuU11h82J8kMHmMk8SWWtnbvpQT5JETGXfZC0JdkFfXtIdCPeJH3F0nDhy9olKyTScPIEHXTsNBos74dI75rBtsHLRGA8eSC6N+AtRns4R2x/+aemmNFNQ/zfbROIUB/tjdKXnvyHmpL1p3NBCK9CbkT1gHxfRS4fI8Ow5ojzb68yT/XsOVVds533+III4dhomSOCyirXJrnJS8q7MXJa6WnRa6gXlXyTYch1tz/4SGcbh1Tguo7wwKwO8wK024dYJxC3YX8mMJ2h2zBbNgXXWSRVTD5UEJ1YU/RgyIB2NGRhgrWvdkkzr79pvH6NnRl6vxUh3x2Tq6EgHml7c9zrEzuNS0D2jbEZwARQXdPXlmBDLoNTUh8GXK4egOi6F2WfvooLuX6TRwjMhQ4DWFrvs/7iqTIZ8ExM4XgMFTB9rrp42VQ5X1/1C2oldHOREsb3+tTDQwSCuQQISfSzzwhFLszrnUrt9xAO8wjDnMmlawNJ+K29PcxspwAkrVX0J6HCNSRV2wTU/E1SKeD5Xo3jDHW0Gi9+INpJ4fTP9w7XB7Ta1OfV7hCm19deQp2/tklOFarLK4wFY1iEOecLJl3mlH6ZwWASaKOYuJVy/
 eKsDDFmn
 v9K/cekwY8fHRZXIn1IVJ8u3Z9oA+3zl6Al5lHRWkvDobOn9ODjyXrTNwcJHxbu1k1Ev3GqDgFvo8Mi4SpySNofUmPbGOO3W6hzAwb+Qs2xDLMGkenn40v/mk5JzseCBRFVS4mIFkw8rybe37chLYMk3Yc+ltZtpQJOfUzkmjopOZZ9Zj5DqPN4DZSAiJ0kyYipRLyzzkDc1g4YcLNU0GtTxvJiNRklXFBioNmmYPyWyc1Jp9EtDqrksCv8HteGyVj2+yYIdDTjO+Bsu96nUke3NxPMYh6h1KS9XchbFa+8sth3IGDUw5OoC/mugPhxjBpEhiyopM3yYMbtSmxIMPjNpvDz/CbyY0U649zCwYdq8S5AUKfJUH+V5R2k8a+8NMbSd13rKYVGZcDkxszFmpU7m+VllLeHc8bG7oyZiRJYVsQgbdZ2tT0xhzOrpxQp6lQV1G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/3/2026 4:44 AM, Andrew Morton wrote:
> On Wed, 2 Sep 2026 21:16:49 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
> 
>> The task_struct->flags field is a limited 32-bit resource. Two flag bits,
>> PF_KCOMPACTD and PF_KSWAPD, are used to identify whether a kernel thread
>> is kcompactd or kswapd. Converting these to use kthread_func() frees up
>> two valuable flag bits for future use.
> 
> Well that was popular.
> 
> Sashiko might have found a problem in the existing XFS code:
> 
> 	https://sashiko.dev/#/patchset/20260902131653.1338227-1-wangkefeng.wang@huawei.com
> 

Sashiko looks correct, I sent a fix patch, hoping it will work properly.


