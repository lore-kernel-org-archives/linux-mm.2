Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BABF4CAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 03:36:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED2F58E0027; Sun, 28 Sep 2025 23:36:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAB0A8E0003; Sun, 28 Sep 2025 23:36:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE8158E0027; Sun, 28 Sep 2025 23:36:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE06C8E0003
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 23:36:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 77CC0139F1C
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 03:36:23 +0000 (UTC)
X-FDA: 83940875046.21.1549BB3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 50C9080007
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 03:36:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759116981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JGDnRdobfQCA94hTso0Evwk2L7bqYVznDxPJPTdsSGU=;
	b=aFxxuDdcur8yXA285OcrbYWwNqAxlJPP4KOB1HzVlpNxNlJTC3uode2NgXxS8Wx5JV78Wr
	+16Ui3wPkV3JRpQWlPzOLDTAx7X25EibNj2D1mUP8m0//vJxleGrxFJEkSSoARJ5kTtNBp
	JUMOke47LEQjG5OBb6fK3QcJNmW2OMY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759116981; a=rsa-sha256;
	cv=none;
	b=IKiuVxnbUinJO6ouFqxDghiu6yo9xvxuTQ86RuQG1ZwGWt4tDiBV4tQIGtrN8qKRrRvKRW
	O5NZGBay6xUjJtvSvSYq18pbpDxY/zfCttuQhyFjquHoF/y+04v9Sa+WphuYz0LsIgZ6eJ
	YiMLIkoYwsnpoIFph9XZ/6aenlAzxIk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E8E6514BF;
	Sun, 28 Sep 2025 20:36:11 -0700 (PDT)
Received: from [10.164.18.53] (unknown [10.164.18.53])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 06E033F5A1;
	Sun, 28 Sep 2025 20:36:09 -0700 (PDT)
Message-ID: <1d7fed49-f67b-4a70-bc67-7643e2db4e99@arm.com>
Date: Mon, 29 Sep 2025 09:06:06 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: Fix some typos in mm module
To: Jianyun Gao <jianyungao89@gmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org,
 bhe@redhat.com, chengming.zhou@linux.dev, chrisl@kernel.org, cl@gentwo.org,
 damon@lists.linux.dev, david@redhat.com, dvyukov@google.com,
 elver@google.com, glider@google.com, harry.yoo@oracle.com, jannh@google.com,
 jgg@ziepe.ca, jhubbard@nvidia.com, kasan-dev@googlegroups.com,
 kasong@tencent.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, nphamcs@gmail.com,
 peterx@redhat.com, pfalcato@suse.de, rientjes@google.com,
 roman.gushchin@linux.dev, rppt@kernel.org, shikemeng@huaweicloud.com,
 sj@kernel.org, surenb@google.com, vbabka@suse.cz, xu.xin16@zte.com.cn
References: <3c3f9032-18ac-4229-b010-b8b95a11d2a4@arm.com>
 <20250929002608.1633825-1-jianyungao89@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250929002608.1633825-1-jianyungao89@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 50C9080007
X-Stat-Signature: b8aeq8trb3g4e17d9nbyyfo84t57c6q3
X-Rspam-User: 
X-HE-Tag: 1759116981-981241
X-HE-Meta: U2FsdGVkX1+s9dE8RrX15nithkWFxhMKA/ZVhCx1ASqO1vLaxlMO5E0aNwHePKIQEbWCfeI2LCmxVgbpKTjQMHNvxvjHb9JAPmfaOfiSS/Hzemqpb9Qnoxm8FBMQ1IpYJy2nMF+nV6962bReZdN1bPDbSAWbyDLSIbL9e5WilUDoul24wgCZ14wPqoFXJ5TLfklh8R4rCF2toM8Abo+k1KCHICbZkpeAyaKwLmsSYEOCcZBlyNg6wHfZrhS/L9iOogxJEjnT6uy1pGD3boOmsk8U1zu/VPfgephcBBca6xZCaMl1yn2+eXJk7dtFZUuHAOpjI3hKECGafdIs6TrdIGf2dWiss/ELsGbDvh2izlAER78vxjvR2cswmK1Efo3/asWLKTdbl2zFuJI2oWFY+9uNGNYpnGiyR9mBiwDif8bsL/+WSuBB34+Ugz4oZn1bxS3Ke3e3hkmP0bGL6tT60bLcGq1bFInKt6CP2/DQIehBADjE3E5fTS4p57lSrx0HELFVhxZahGxEDqqp7Z2e/5vEtDfDhtthdjS2dBIyUG9iKG8fRVvLJbs1zBg836u92S3vKwATe0/mED5XLgd+C7kJgBPkuVB25emQGtx9OfU1/fDcoRra5hn1njTTXqOjlE0OfT9FdcLhUnwsGZp+vPgxB3XlBEI/+o6JFfT1iBYiRsl0xkk3f0VA0h+M09/0vHQFD4Mig6Drd7XoFBjIWlj8HlR86sV6UeJHH1/j/tqiMyaW8yBx6H9JJYzg5UCWcguCfGF9/JiOoz2v5DJ3F/xA3WLYkUx4MIToC3TwI7HxpEg5ntyN5v0PzS1LxpzxIivxq1korlb/lYtswLM9V7dvsKiWnRPt0/hx6r71gqsrZwS1BIo8YTr/OEFRvCbnFuoq45h6NjJ5L/wsFWekDYSCwh8opzLprHqoGghcImzisIDkYg12F/7OZ9rzE/KjHAK7AlH6Dyx1jBeNYUs
 kQc3XlIQ
 qyBBJ3glJDIZf3tVzISaMEndAaZBUgQLNsrKu8+hRtG6uJM/tERjImS0B3CzOamv2xedFTYTo3aJ9wKTBDs4ys7wJvhtu5C8Y1cSlJXhhiGZWcWdEQs89QAXsqBIxdJQBJbCGG+ZmwLNkWP/wsGG664bu4P5ZLEtdoC2A0eL8NWoynzy4uP3Q/zliAELg5UkrSR4WvahwS+WOkdy3OHwOrT9ReL7x3H8juy4NJTWGW0UAuMCL18dlXuHGleu+jWshSe7F
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 29/09/25 5:56 am, Jianyun Gao wrote:
> From: "jianyun.gao" <jianyungao89@gmail.com>
>
> Below are some typos in the code comments:
>
>    intevals ==> intervals
>    addesses ==> addresses
>    unavaliable ==> unavailable
>    facor ==> factor
>    droping ==> dropping
>    exlusive ==> exclusive
>    decription ==> description
>    confict ==> conflict
>    desriptions ==> descriptions
>    otherwize ==> otherwise
>    vlaue ==> value
>    cheching ==> checking
>    exisitng ==> existing
>    modifed ==> modified
>    differenciate ==> differentiate
>    refernece ==> reference
>    permissons ==> permissions
>    indepdenent ==> independent
>    spliting ==> splitting
>
> Just fix it.
>
> Signed-off-by: jianyun.gao <jianyungao89@gmail.com>
> ---

A patch is never sent as a reply to a mail - please send it as a
separate email from next time.

Reviewed-by: Dev Jain <dev.jain@arm.com>


