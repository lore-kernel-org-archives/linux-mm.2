Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75A4AC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 11:09:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B8406B0005; Mon, 29 Jun 2026 07:09:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 468FD6B0088; Mon, 29 Jun 2026 07:09:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37E7F6B008A; Mon, 29 Jun 2026 07:09:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 115F96B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:09:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 929851C3782
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:08:59 +0000 (UTC)
X-FDA: 84932677998.19.FF61AC4
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id A7BB940007
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:08:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=codethink.co.uk header.s=imap5-20230908 header.b=R3zuo4BC;
	spf=pass (imf01.hostedemail.com: domain of ben.dooks@codethink.co.uk designates 78.40.148.171 as permitted sender) smtp.mailfrom=ben.dooks@codethink.co.uk;
	dmarc=pass (policy=reject) header.from=codethink.co.uk
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782731337;
	b=rgdpkDtFOJhaHfjlt1Tpy7Gg8HGsyBzV+NXdYCAojZgOOlD+KKNGT/nmJzeMWPIp0K/KM3
	NQupxY4TbGDJxRX1Cj4qQ1xHUfmU5IBU7sBYEEHp9M1aTPpdXVOfS5i3cYcmbrwR4QPwuy
	X8PSc16pre3KXacBdulWAa1sW9y84C4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782731337;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iMvLa3m/MTxjymke0lyeRSF+rdUhBWHoQ0wYwpxzL64=;
	b=Hx/DzMjIAXb9PLoizY3S9asyG9kUreoo4thGh3cqB9pXqmsJhBvYogg9AY9VT99PCh9gp8
	vHWvbxA6tIs3kKc6D81NzRyemtyY606Yb33Xn9e+ZdCdsPAuIwmeSNh2biV8iKu7duj7/A
	5UfEvZcovYCDF2QXKKA3xvmEIJ6BkhE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=codethink.co.uk header.s=imap5-20230908 header.b=R3zuo4BC;
	spf=pass (imf01.hostedemail.com: domain of ben.dooks@codethink.co.uk designates 78.40.148.171 as permitted sender) smtp.mailfrom=ben.dooks@codethink.co.uk;
	dmarc=pass (policy=reject) header.from=codethink.co.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=codethink.co.uk; s=imap5-20230908; h=Sender:Content-Transfer-Encoding:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
	Reply-To; bh=iMvLa3m/MTxjymke0lyeRSF+rdUhBWHoQ0wYwpxzL64=; b=R3zuo4BCpfrRInEp
	sINOybonM4Z5ElnYeWwJZNbNzm0Tzn0FaA6bcK/kGgMg10fcmbaP3MkTjhrDyqKTbImfJaGu4zDM2
	cYCHFGI0AILG5qePws4EJBYEg2kRm+Dtz+X+7TPOQHCbetNOMX41YXDd9BM9KdXfk1BS88DnSujGh
	h97LFdoOk6LU6jMWglYdrZugoP6m4fNzygFoBPtMvZQVLDawYFuvMoYxV03OgvTdYa5iPfUDxdRqG
	FCDBSk7HWKPIRIFEIkG2idq4fUW7L5TfjRI5CfIe/tkfUzvoeNtwMFy4AaZP2HLvZQbmZToPiu6dd
	woe2RijRqQ21Lsv/iw==;
Received: from [167.98.27.226] (helo=[10.35.6.194])
	by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1we9r6-000OrL-I8; Mon, 29 Jun 2026 12:08:48 +0100
Message-ID: <276820f5-76fe-4e6b-b1b3-d9235d097411@codethink.co.uk>
Date: Mon, 29 Jun 2026 12:08:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: don't build vm_numa_stat_key if
 CONFIG_NUMA=n
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260618100614.1321950-1-ben.dooks@codethink.co.uk>
 <20260624192742.afbd255b97d82ecfe7e11e17@linux-foundation.org>
Content-Language: en-GB
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
In-Reply-To: <20260624192742.afbd255b97d82ecfe7e11e17@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A7BB940007
X-Stat-Signature: paq8cwda78jrops4cuskky7ouyzajty9
X-HE-Tag: 1782731337-351715
X-HE-Meta: U2FsdGVkX1/QHjR1mfS2ULk4KrPtRQFBf7gOAwtZed599TEd67rr1bt7eknUEnYDLmTmGmLBkrZcMlDUs+YvgMmrwoXmF90srescUrkZKCMOCiwesUWYAGn8M9Et5TYuNO/SlsfYxfGBCQ8lCqbwwEBixynHRkY7ul8ov9jNCH3R4BYFWYAiXWO7T5+ffXzKEsV+FJDCHA23PE8g/zBM8bCfYEOAJe6BtszucFpHRWomV06BkEKArXQBtmi9eslVitjxoKartFntOqQHZwAbO7pmVTkIs3uzGl4AfC6gy9puB33HyR5GgeTua7nyihc73qWdTjVnOS5xcrnzHUMUWAvS3v0pxjEqd1iQzrIY7sk3wJlAXthI3yhX6gWHrXtw7iWxj6kRPQ/J93WVNF39xw8XpJ9khpz9JpXe8nE9BhVBn2jF29R5b6pgPnkyfyxJuwzbzmMlKukiQFkXqdLMk1sEqDkI5RChDuRlbzn+YnXMwnnka7rly7C2vJUukovPFbNcYfIpBeSJumMKIog7DrtWHkk35GxEPhb2RWQsO33kUe23LQJfjhtfQoIpvUoV8ipUIMYsy67iy856+Li5f4kAyHONI4cSBEiccDHziRWyrtyyd0nnOGvQPji/rwUcrg/N/0hS6ZYVSNAORxE2WyYFa+HaHeg/QZfwhRmhw3p7x6SP3l6fX5acX0DmUETw+p6jhYmm31PrT19E02lqDIKISd/JoaCbzbZ1tmIKuVX7s4rd3SGtLigEYYZD8MoQSkIcHMQpTt5qWan/M8qloyutpaf0Gb6fEThpJQlQTN12zYuKIpmhBMTfJc/taLx7ElCD7A9JzqBwNJ3pavikR+Kob5tUJPJRkx22IRJfd45eGiS0so/yoref2rjaty6bC+kldw/SKW5x45OSevrcAEAl65XloKO3q3bJsYEUCKDekauGypev0Ea7CV2tkcxogLAtH1I9tbvBgZa9zDd
 obPy0b+O
 F1ixmv5v5EKl5/Vdx1IEUpBNv434CZ2xSCcD5uHZe/n41Afj1Xkgi7Y2c7RdzgHnEyvSPr8ZwqTCxCDXPC1P5iNY6cKIdkDczWOTTXiNhw//gEyEWxqSNukuBxdO6nEwoRe2pcUPjRi2WrzZtpZW8c3ZwM0lQLEuq+vYm6u2soqsyvwB2GLxiFlnBdoONW3Vge0utlgaKxKxGzzJXnaXXk+BgYLk/XQ+S9vFDF61elTOCwyKhGxgttch7Y3yJnsmiDV95w7RrNsHKMWTFWyCl/Kjq4dZUdePNALJ/fzLXFi5oLUe5zBkapWQBGzrRjamdA88/mkGbURr5Z2qPeXlDWIj0VPFhDaSzIWeYKxN8v4miUlu/qvpBnqksE9QgWxXiPoY+ENARburS3srvFsIFsO/oWwf4mcRDPbSzPLTwEIF4LM1u0Xw4TwtLc9qWSYzyU2YuU67rV3vV6R2Ld0B3YxuPckD5cofNCqRqbPRKN4rAzPkjSLH36iQLGb/hCAQaDXK66S+NB5nzclGJG7NiwXXbtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25/06/2026 03:27, Andrew Morton wrote:
> On Thu, 18 Jun 2026 11:06:14 +0100 Ben Dooks <ben.dooks@codethink.co.uk> wrote:
> 
>> The vm_numa_stat_key is only exported if CONFIG_NUMA is set,
>> so avoid the following warning by guarding it in an #ifdef
>> on CONFIG_NUMA:
>>
>> mm/page_alloc.c:165:1: warning: symbol 'vm_numa_stat_key' was not declared. Should it be static?
>>
>> ...
>>
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -162,7 +162,9 @@ DEFINE_PER_CPU(int, numa_node);
>>   EXPORT_PER_CPU_SYMBOL(numa_node);
>>   #endif
>>   
>> +#ifdef CONFIG_NUMA
>>   DEFINE_STATIC_KEY_TRUE(vm_numa_stat_key);
>> +#endif
>>   
>>   #ifdef CONFIG_HAVE_MEMORYLESS_NODES
>>   /*
> 
> It might be tidier to move this into mm/vmstat.c, around line 38?

Is it worth sending a version of the patch?

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius

https://www.codethink.co.uk/privacy.html

