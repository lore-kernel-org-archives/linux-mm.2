Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D8F2C44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 04:00:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 326AC6B0005; Mon, 13 Jul 2026 00:00:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D7906B0088; Mon, 13 Jul 2026 00:00:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F1076B008A; Mon, 13 Jul 2026 00:00:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBEF86B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 00:00:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4FF761C9633
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 04:00:11 +0000 (UTC)
X-FDA: 84982400622.09.54B372F
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf10.hostedemail.com (Postfix) with ESMTP id 50985C0002
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 04:00:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=JKCK0sjq;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783915209;
	b=V2hiefidPeOzTT+OKGDIzpKE4LRIULEJHzUddPGR1YH640HTxlbyWA/T54I4CbVjjeqpiu
	mXet/+qaVgBBejGdasiiu36hPSK4ON+00LD0oxb2ZqUEG0SiXcOKeAT20/CMvHn9NJZxhr
	4D0q6uikkPW7BBu7jCgYyr1fI+VUV4I=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=JKCK0sjq;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783915209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ljwlEjAyEcgRK25Zkv2UU0+NoAlULoGnEZMopZiRIcU=;
	b=ZhrwltK9Ip0eX0pFxJD+HteTOzvmWrNQayWBfYdvEFrfbAn6w2tu6OVkZ1fAZ3i8UCtUGX
	NmoXdFLQsUvNSAnDi+XMkXIALvfhvkP2NuQo1rWtItAqvnlsPXmqasOhOo0Bd3s8nwn86T
	oJdRvDhLlM1iQbOQgOH+nb1UzfGkd2M=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783915203; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ljwlEjAyEcgRK25Zkv2UU0+NoAlULoGnEZMopZiRIcU=;
	b=JKCK0sjq6RbbyX/DE11Li7nGowizchrK69kf42YjqhNx4iV5qc3Xhp1Y/7nUUQEWiDVYD/O2NJcNI0opuFTR77JmdN49elkGcaJKoiOYe4hAMC8okO7+E6DkYYW5iEOesa9MX3RDKqYjicsBx1o3DiDLHoy+/UaJaNBqoV2WM8g=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X6tcPXS_1783915201;
Received: from 30.74.144.131(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X6tcPXS_1783915201 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 13 Jul 2026 12:00:01 +0800
Message-ID: <368ddc3f-1206-4e2b-a45b-c67b0f54c58b@linux.alibaba.com>
Date: Mon, 13 Jul 2026 12:00:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: huge_memory: Fix kobject cleanup in thpsize_create
 error
To: Hongling Zeng <zenghongling@kylinos.cn>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, ziy@nvidia.com, liam@infradead.org,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, zhongling0719@126.com,
 stable@vger.kernel.org
References: <20260711084624.207777-1-zenghongling@kylinos.cn>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260711084624.207777-1-zenghongling@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 50985C0002
X-Rspam-User: 
X-Stat-Signature: x1imw18bguqp4e95w9kfa4zy59i4u4t8
X-Rspamd-Server: rspam03
X-HE-Tag: 1783915206-796318
X-HE-Meta: U2FsdGVkX19B6BIRU7ldkCyIhhbMVBQMxeqOmej3bCQpIBcFvXZ20UtN81/AYxxtfjFVOO2VPR8SFo4QY2a14S4dmZJ0PaJ+ESfKzGvPZZZ+Jn/5rhAk4MsIlsM0elvH7XH2wsZf8qi/m9ZVs+mGi0Sqzu6+utidzKz4ZTtyJl2QFtdVeMsBB2zCQwbDHiGprPM7HFiUiomZVfxGtrhe53fm6nqKK9LhYEgUKxk80gjwI8oXtxwPzTq3njBngzP3EpD5Dr51aJXB0TFUDW9WdahRcTSfL9j92vaerxk0VPD12oS17jTam86uohFsAvVcobfq4/wHvQiu2kOL+BIdu9K9hDkgXMjBFfPyf0y0Xnr+6dWDtk7IGveF+4LiCIKcaqvEyNhq4Tg3AsB8mTYHeyrNcag/F0Q5rx99OfCgrWh1JxW2LFkod/o565lzx9lmxEyNsX3SNDV51/zlmUL3g3u/rqjgjTuuCdOWmPOFRslOP7kjrHnlUIVO5gH6/OoGW3HgiXuCJbYx5reRoR7ThMUrTrdxVDjkNTRPAJafiXni4JrlObqTHegAnTq+1+fMvVd88NhOveJy0Pja1D/WE6aUd4HLohsO/XbfN0AzSHGJzdVwrLI2ka+w94VwapE4+lkjIfCOZUMUi+6QFHRunoZYlNcmIoQ+uLTVXyyBd5X7oRgF9rAI7mYEVblr9HG4jshWBAZipf2ObqkdFlPaMYW/F8Q8zKiclaVsEDkm5rv/6ENJgUowhXFvQDcxxL47B4Ql4VmcOKuBzQMFOfFY9SIjV+y3Jkipj2V0BBGpXbFaD7UrzkVQISzltiBDeHOO9jhHScF/DGrqhYHVwjb0kM2bHrJk26hlJAlFhEQIyeFcd1yV35MQ6X4y19ewOMbDlO62gsGPaLQ1mCkCMaDbn8CfSsYtiqy+1zSZiIZAZqlDH+/8HpB/0hqChRmdmcVOH4MFOcHFkVJWVcJrbe+
 08Nqhbc5
 zDD1GZAT4bxzQTVjTAcZbDSp9QkzWgN5IJFIHRxU3Z7R0vk0veEEY9qw5dIkfxxu+KUYvCbHiMei8aDK3xW0k3U7t2xakw/97DnpFnoIEX9JOIXW9c9lDoytOjDXcMoJW+b99VZsE5OyhtnSJWqkNHEJl5UDVap6DnOL4AY6wr6vRxcdfkG3Bc5a/WCICfobOJ4UeLl8U5xpaKUzGeF40Gsnbe3LccNJOm4G3exPuReGfMkpDiu8b75e7MTIeeRvzRoP08axKh5A1xBDByvz5ax0GikstwbmWN5fRq6GR5T6Ql1ByfeEMLCM4tRqg64QkaFNK5fbLmjICVRFXO2/K/e3AkSTGk+UVMbONGAcJA/RqM5BtA4onnX579fnmNfaMkZb/m53ombNh/YvTXw+oBsLsGQw7hZd1NZFTR9uFgaATqzMCObWBpSzf5h7oMy93bxerJGygCUGGwSdHedoFGcoSrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/11/26 4:46 PM, Hongling Zeng wrote:
> When kobject_init_and_add() fails, the kobject API requires calling
> kobject_put() to properly clean up the memory, not direct kfree().
> 
> According to the kobject API documentation, kobject_init_and_add()
> calls kobject_init() internally. If the subsequent kobject_add()
> fails, the kobject has still been initialized and must be cleaned up
> via the reference count mechanism (kobject_put), not direct kfree().
> 
> Direct kfree() leaves the kobject's internal state (including the
> reference count and kset membership) uncleaned, which can cause:
>   - Memory leaks of kobject internal structures
>   - Potential use-after-free if there are pending references
>   - Inconsistent state with the rest of the error handling code
> 
> This fix matches the pattern used elsewhere in the kernel and in the
> same function (err_put label) which correctly uses kobject_put().
> 
> Fixes: 3485b88390b0 ("mm: thp: introduce multi-size THP sysfs interface")
> Cc: stable@vger.kernel.org

I don't think this need to CC stable.

> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
> ---

A related fix was already sent before[1]. As noted in the previous 
comments, just change it to 'goto err_put'.

[1] 
https://lore.kernel.org/all/20260412175428.2613383-1-lgs201920130244@gmail.com/

>   mm/huge_memory.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2bccb0a53a0a..7aeb17d60ac7 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -819,7 +819,7 @@ static struct thpsize *thpsize_create(int order, struct kobject *parent)
>   	ret = kobject_init_and_add(&thpsize->kobj, &thpsize_ktype, parent,
>   				   "hugepages-%lukB", size);
>   	if (ret) {
> -		kfree(thpsize);
> +		kobject_put(&thpsize->kobj);
>   		goto err;
>   	}
>   


