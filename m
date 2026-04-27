Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB821FF8861
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 09:13:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C3666B0005; Mon, 27 Apr 2026 05:13:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4742E6B0088; Mon, 27 Apr 2026 05:13:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 389F46B008A; Mon, 27 Apr 2026 05:13:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A5266B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:13:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C8E4A1407B4
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:13:44 +0000 (UTC)
X-FDA: 84703773168.17.862A1B3
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2AC7C1C0011
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:13:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=2WpVS3ko;
	spf=pass (imf18.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777281222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zmRjeX6dNGOmmOZ8y2g2riqMomZtnDChlOtrdiwKxyA=;
	b=FqSFy7bd6x9HczafJ/EfUxH8fQ4TprZ6xRo8VYUAuHy9ylGRuzp3PH7CKLCEw9b9Q+pCwR
	b6Kq7Mzp8fOgAKsisVoJuTQ+p5KgTuhe5fGGdbppmiuYVtSlr5nd9aQKKHJQA9r5C7qZEZ
	H/r2NHRUv40D61uyFxccKPE/neikm7A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=2WpVS3ko;
	spf=pass (imf18.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777281222; a=rsa-sha256;
	cv=none;
	b=gsgU9uCLJzSIX8PtB5acdAjs+gSxXzwlNvZxERqr7TFPGNqMGdaotQKkt+S+nHgJ5w4Hr3
	wIPCMbIvSkcPPP9PrjmSUV/ABW27sI1CRxEdRwi3S4yH0E2qHZI+0azw7CoKzvxjL3go+7
	HQjo+74wmyZemRF19f3p/ldotre8N/c=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=zmRjeX6dNGOmmOZ8y2g2riqMomZtnDChlOtrdiwKxyA=;
	b=2WpVS3kovfqkUg90WSAUnAPn7LuxSDyzTmtBZOzDWGZz5QJ7rF6G/1xhcl7HwcNENtuH0fmpe
	+zYUcaoLqGaMQIJ2WU2b2maEofBnlG2xr6WWKADTl4L8Rfc99FmqSniEjel140NpxbdUlcRPo5i
	Opcc3WmEjCy3zoCKUZpuLGE=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4g3yNz69cSzcb0l;
	Mon, 27 Apr 2026 17:06:43 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id D3B954056D;
	Mon, 27 Apr 2026 17:13:35 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 27 Apr 2026 17:13:35 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 27 Apr 2026 17:13:34 +0800
Subject: Re: [PATCH 2/2] drivers/base/memory: fix memory block reference leak
 in poison accounting
To: Muchun Song <songmuchun@bytedance.com>
CC: <muchun.song@linux.dev>, Ying Huang <huang.ying.caritas@gmail.com>, "Dan
 Williams" <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>, <linux-mm@kvack.org>,
	<linux-cxl@vger.kernel.org>, <driver-core@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>, David Hildenbrand
	<david@kernel.org>, Oscar Salvador <osalvador@suse.de>, Andrew Morton
	<akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>
References: <20260426144447.817722-1-songmuchun@bytedance.com>
 <20260426144447.817722-2-songmuchun@bytedance.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <7fe73023-1fd1-0c10-107e-5c0f47383453@huawei.com>
Date: Mon, 27 Apr 2026 17:13:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260426144447.817722-2-songmuchun@bytedance.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2AC7C1C0011
X-Stat-Signature: 6z5tk9dzgg1uumjibiiiii8ctn1a3brr
X-HE-Tag: 1777281220-880473
X-HE-Meta: U2FsdGVkX19YcrQ3nSR24hD/hyI5KrRdO+AFIKqrak9V8gPa6anQaEYIAWiWNSsrgFHirGu4xj9RkFpiXyNWx0SoZB7d7tTyoBOqWfIga1ZnxrBiZQbG6LsK1pvPrpqV8uTUncEooz6N4gG9brO1BRr4AGWsku86ztMvf8x8sA9bcBqbJeN9vFAVODT06TTX55mgZKKKbCsh/69yHxgXZN9nF+4JgtJXT+pDGTJhaSQR1rMHUPP/cHLVq+hMatp9BXfd/LHS02HTdLuHzIJnpqg5t86OJBVgoWTws2b2Pd4BCNBIKJfJ3ixc2Y0Z43oq7Tk/bGDo6PVL9el/D9tNEGeu5raN86XIPaPf+MkVqXqDFnIfdB6mZbUTGtMfg+TD/lLVsrWs6YjAzdNvYuiPuwsNKAPnK5ldh3tg8N1ypVI/ZSBRve0hOFMDozImjZBnfC7I7Xz+x4Cw0EO2/GXAK+vWur0OxL9oYO4MOCYmYM1Ou+n00+98/A35qrKecsjG4INeoaHuX8c65/NbWg+E8KvPbS01kc39rn0x2/z2ucnfQ3x+c6RnwXZVbk5HJNcJw8rwATd2VNKV0uGLxMYRk4hmuNbINYeQb8bIVzFn3lVNCH7b7fOJxBB91VVc21ficMz7IW1m2vihpx3wPOWmge3fM+Jd2gEaaD8R3xUBZWBU1Ti/zyPo3HTi7qKSh8dRD5lFCchqbXe8rdrKkwVRRS415lWXRU+3wDgncl25GU3ze/h+xU74i0FIQnEiJiK4hBxcKhHcEo1M4MiW11hN8oG+0MmsL3qjOAH9JF5qeNFafaxoIr8gHTtfaDlQnQCxTwpOqxhK6GMBFijdYJlP8NcnR6rY20YY3oELhRxaLXshPiLW2ika0IjjWFyrScbWep4vqILdMsVvwutBxAIeEu9ii+aGm4TSjsRFt+Rt0Im3ggrhzMW2d8DpxfiJipsUruSrhedNQUWDZT+7X86
 uMFpk6b0
 yNoxEspzutbWZhW+HH1p7iX+G420YBnxlQ9w1AZclFuCsqs6AlJJfUkOAWiCOXm2fkRz2/u7+qdgzb99rcrNehsBvZuAHXLIvnuwwUyXFOCEi7MS5KMWHGr/10HxJL9LjvN6lYI3TMX2zMZBkcDA3ozVQmrS1EXFqPK5GeipFfA/x89Zd+KmLJFahuIsteVU0wkhK7nayGZJbBVM0P12Od8YNYkJz3wlFxUltPHqmpcEDZDUsL/fogTN/ChJ8Zr9vzmXWtlv9I5nmaN0RY6cW/QfK+KPHkPL6Tj8PczTKXgS9xBeo9TyvfNZcFMTBxX9UXycdmxXRMJtJS+PC6lU5B671mO1mKpqekGCsuubhhHUs7wgDyBEFaq02U3Zndyr6tVxxEzVnJca9zwLvDmrB2PhY50RKHmh6QVJqIZERJRDAsTg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/4/26 22:44, Muchun Song wrote:
> memblk_nr_poison_inc() and memblk_nr_poison_sub() look up a memory
> block via find_memory_block_by_id(), which acquires a reference to the
> memory block device.
> 
> Both helpers use the returned memory block without dropping that
> reference, leaking the device reference on each successful lookup. Drop
> the reference after updating nr_hwpoison.
> 
> Fixes: 5033091de814 ("mm/hwpoison: introduce per-memory_block hwpoison counter")
> Cc: stable@vger.kernel.org
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

This patch looks good to me with one question below:

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

> ---
>  drivers/base/memory.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index f806a683b767..6981b55d582a 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -1230,8 +1230,10 @@ void memblk_nr_poison_inc(unsigned long pfn)
>  	const unsigned long block_id = pfn_to_block_id(pfn);
>  	struct memory_block *mem = find_memory_block_by_id(block_id);
>  
> -	if (mem)
> +	if (mem) {
>  		atomic_long_inc(&mem->nr_hwpoison);
> +		put_device(&mem->dev);

Comment above find_memory_block_by_id says it's called under device_hotplug_lock.

/*
 * A reference for the returned memory block device is acquired.
 *
 * Called under device_hotplug_lock.
 */
struct memory_block *find_memory_block_by_id(unsigned long block_id)

But device_hotplug_lock is missing here. Should we add it?

Thanks.
.


