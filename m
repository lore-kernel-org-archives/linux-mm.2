Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59CC4CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 09:44:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 892688E000A; Wed,  5 Nov 2025 04:44:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 869ED8E0005; Wed,  5 Nov 2025 04:44:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A74D8E000A; Wed,  5 Nov 2025 04:44:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6AA608E0005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:44:40 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05CDEB7141
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:44:40 +0000 (UTC)
X-FDA: 84076068720.09.E40348E
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf13.hostedemail.com (Postfix) with ESMTP id DB2E020005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:44:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Xl4yr03g;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of libaokun1@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=libaokun1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762335878; a=rsa-sha256;
	cv=none;
	b=K0EnPZwSREfsa1OQ+vXlApWrTvh9R9snciU+8HVWtc5dKoe0NmTcB0xtpBmxgJ6u86PxY5
	O7osAAIgoeyKmeDJKsOxAEYs9xjs1oiyLn2MajLOtywrRQVncZaRF8Np6TBZ6gHTYgPXG0
	dWLkHZSraqHjC/7C1zFO2bSXlDwGqP8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Xl4yr03g;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of libaokun1@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=libaokun1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762335878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ULBjQjfTQ2PhD78f/wqD4u2pFSqPbYJY7fZ9PMrAk2g=;
	b=kxAlxOgI1S/BpU/XZDQLQWkLswaFTSpgH8eqEH8c8NMZ46PFMFc4kKVBHOYNpXzsK3orod
	EeT/ALpcG7BUFG5GiK+8MH/vGcdLPBWCRK5qXA4aStdpuLhOyZzl2NC3qkmt5ebnCkZngk
	yxeYAFwNZJ66dA7sdB1kTxkrLK3UQhs=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ULBjQjfTQ2PhD78f/wqD4u2pFSqPbYJY7fZ9PMrAk2g=;
	b=Xl4yr03g/f6ZMnj5GicYAb2bjUPpNqrsDwGaUvWjzZYt3z8PRrBWnK0IkFrfkeg8NaXIfqMw0
	2a5b3MBSA+BOdYGDHZvzQaLEFUUqjI+TLkwAnXhnAfK3K8mGxH0qimjxp0gfk6NGvDEac1aFfvf
	6apkBZlSE41pxIdeWt789mg=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4d1gNd4sY5zLlSM;
	Wed,  5 Nov 2025 17:42:57 +0800 (CST)
Received: from dggpemf500013.china.huawei.com (unknown [7.185.36.188])
	by mail.maildlp.com (Postfix) with ESMTPS id 91B751402C3;
	Wed,  5 Nov 2025 17:44:32 +0800 (CST)
Received: from [127.0.0.1] (10.174.178.254) by dggpemf500013.china.huawei.com
 (7.185.36.188) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 5 Nov
 2025 17:44:31 +0800
Message-ID: <5280bbc0-be8b-4e46-8410-28719cb79ef0@huawei.com>
Date: Wed, 5 Nov 2025 17:44:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/25] ext4: support large block size in
 ext4_mb_get_buddy_page_lock()
Content-Language: en-GB
To: Jan Kara <jack@suse.cz>
CC: <linux-ext4@vger.kernel.org>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
	<linux-kernel@vger.kernel.org>, <kernel@pankajraghav.com>,
	<mcgrof@kernel.org>, <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yi.zhang@huawei.com>, <yangerkun@huawei.com>, <chengzhihao1@huawei.com>,
	<libaokun@huaweicloud.com>, Baokun Li <libaokun1@huawei.com>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-13-libaokun@huaweicloud.com>
 <5kbyz6ilhj7zde4dtv7fhy33yks3bhs2g6xesdzwptdenrrfdg@ydurgdouhuwn>
From: Baokun Li <libaokun1@huawei.com>
In-Reply-To: <5kbyz6ilhj7zde4dtv7fhy33yks3bhs2g6xesdzwptdenrrfdg@ydurgdouhuwn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.254]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500013.china.huawei.com (7.185.36.188)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DB2E020005
X-Stat-Signature: b5yr67yxfec66eb9sg1z3fga6cugigrf
X-Rspam-User: 
X-HE-Tag: 1762335876-741895
X-HE-Meta: U2FsdGVkX1+nhz5fg2nWeilCjbvQYb/v6QnzNYVl/LNwsJItQfhOg2SAxUWAtvNT0PmonkSlTP3trNizSQ1IEZUmLXaA5ZlxJWEAbvK50ejPER59QbnE9s1lYeEsKWbuRWV5ltHa590STz+23fbgUGo7fAd7kM/gDMoTuJksJd1GF86SeSnw4ZSWMovEBv7kkmBMmNxBJne7A36VifUk5YMpZsliki1TByRVVwiSSf9/UnDD21FkPDEenoUHAK41q+TPUd4KkwKdK+YrlqWVejhw74sGpsFYftEZCDHYoA8STD2EbDatHip5yt+3ShjiH036WnrA+Ika2M/r8jwRqLGf0LsxtPlzwZoOowLZz7hdYXhlkYPo7aexMT9FKncP4O5a+oPUy0gydnnpDYXqt6JKaFI3gOunlh/FfyJUHnx3SdcVs5Wm9mB97h5zGwtSRxE6pmjrk+u/vvp/Cb+ZNRpYabwNFmPp8o0xmFara1+BrkJHb185OPchNchTSl9c/Ykf469ru5MGuuxaeNpW/gl6xAUoIYVxNsPuDRZHpyGd8tNDx/rie1HfNRB//HB8xSP/I1zKn9ckvTo6HHcRjmJxWEv1C3XaxEflzv7JWayDhJUWaDrBTEjk19ei8vy2ORUlfoquqTtm+0Sp7wiKZkfn9K5M1bbbwr6FDFMLvEgiphMEl8z/7XMSTXypus9CEpKdZp7ATZPolYQJ0U/iGTEIJGWipyAzURcx6qGskHuqt9qz4D8nBVs3e2bmxlf0vDwE7/1/xr34GFZBzyaGnZcGiIIj8tFmuIjEXw/KsfogKvhydfLReFQkvn/IYNC4Cce7WgSnNA+YpSESw5nAqq5gRmlRTNYyUN011R7aIHAJKdRyQPfSAyb2p2dL8C3VPHifPiApUX810oKJ8pzzIwJofMAPIYlR+NLaKDO3e0cLWcGJPjP8q9qC45hPIoUcKff6rwCghavcOWqM2Lj
 9Dvk3FAa
 QBfU+vhtqQx7B2xv930Pw4YYQTibhW8lGvg4Rjy6TM4Id3WB39hDAtrwo3ANFwMpgyUdCz0+gSnMLhalbhii1Wpac1jtznsp5eeXNYLLH/pdxRIMPAw3emzHhlFinTJQYcpw6gjjIcFoShsffY+kIRTGZfrAjjDDr+4l7tgzDTE31RnZnu0KFzewTxUWyzYr/N77OQjH1wzYeP/zNH2aDVOVcojI36I/IYXLYVOzv3qweKGfIhIGZlVyxBV46DMZD9SUS6WP76olAeLQ/342URoJsFLPduNkJe3CNxCHRwDcDOf0kPT3mcg5uwA7hc/6YNEzsBixZbkEjbF8GfaCGAFy+eyOtn5eRVvotaoe60CZyLWuVzsq/5i/X6HV6TGr9w8WyXCsgJrITDLnAcSA60XfZVmqCKK+nJBguCxfjkBApHRBoU6Xsa1EpP5yj8izDRKo3uRs6m46f8fx+O1NKtelWQDOz4bl4qqP8ufAk0LyNgDM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-05 17:13, Jan Kara wrote:
> On Sat 25-10-25 11:22:08, libaokun@huaweicloud.com wrote:
>> From: Baokun Li <libaokun1@huawei.com>
>>
>> Currently, ext4_mb_get_buddy_page_lock() uses blocks_per_page to calculate
>> folio index and offset. However, when blocksize is larger than PAGE_SIZE,
>> blocks_per_page becomes zero, leading to a potential division-by-zero bug.
>>
>> To support BS > PS, use bytes to compute folio index and offset within
>> folio to get rid of blocks_per_page.
>>
>> Also, since ext4_mb_get_buddy_page_lock() already fully supports folio,
>> rename it to ext4_mb_get_buddy_folio_lock().
>>
>> Signed-off-by: Baokun Li <libaokun1@huawei.com>
>> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
> Looks good, just two typo fixes below. Feel free to add:
>
> Reviewed-by: Jan Kara <jack@suse.cz>
>
>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>> index 3494c6fe5bfb..d42d768a705a 100644
>> --- a/fs/ext4/mballoc.c
>> +++ b/fs/ext4/mballoc.c
>> @@ -1510,50 +1510,52 @@ static int ext4_mb_init_cache(struct folio *folio, char *incore, gfp_t gfp)
>>  }
>>  
> Let's fix some typos when updating the comment:

I’ll fix these typos in the next update.

Thank you for your review!


Regards,
Baokun

>
>>  /*
>> - * Lock the buddy and bitmap pages. This make sure other parallel init_group
>> - * on the same buddy page doesn't happen whild holding the buddy page lock.
>> - * Return locked buddy and bitmap pages on e4b struct. If buddy and bitmap
>> - * are on the same page e4b->bd_buddy_folio is NULL and return value is 0.
>> + * Lock the buddy and bitmap folios. This make sure other parallel init_group
> 					     ^^^ makes
>
>> + * on the same buddy folio doesn't happen whild holding the buddy folio lock.
> 					     ^^ while
>
>> + * Return locked buddy and bitmap folios on e4b struct. If buddy and bitmap
>> + * are on the same folio e4b->bd_buddy_folio is NULL and return value is 0.
>>   */
> 								Honza



