Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0735FF36BA7
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 07:45:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F2F76B0089; Sat, 11 Apr 2026 03:45:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A3B46B008A; Sat, 11 Apr 2026 03:45:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 193BB6B0092; Sat, 11 Apr 2026 03:45:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 05AEF6B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 03:45:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9EE1E1A06E5
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 07:45:38 +0000 (UTC)
X-FDA: 84645490356.13.DDA96DF
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5CD181C0008
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 07:45:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="AY/SLP/S";
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="AY/SLP/S";
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775893536; a=rsa-sha256;
	cv=none;
	b=JNegrUAmvBbY6Olcxm0BbDHo8EUXfLyvL1bpqFcfaY0ITDX58d/A0gZpZeV5tl9HuTZZ9I
	YqmLeY9cbCWYLFmI9gDZb069DXvls9jqsibWMiAmDckEeD4iyTaEItFxldUd1MGudllYrN
	21cSKVTRDM/qx/7uce6a67T9KcFeBK4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775893536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GB+JlqaisJkQAW2pvwxx66NbFm/L/SQFwt5rdeDTOMQ=;
	b=0NwA4JSt1jF/Gictd3hBXwCF2Y0vXKSLnCXJ1GrIKVg7G+IsikQ91ocdZiqZ0jZFE32hLx
	xamJv7bfiZshukHi2iHK8mj9Tw16l+8pn3Rlgl3TthWwesORY8iG4eVyocniJzcm7yx8/c
	BPj6ue0/mn2P9cBV3EYJwSkVIDL7s30=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775893532; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=GB+JlqaisJkQAW2pvwxx66NbFm/L/SQFwt5rdeDTOMQ=;
	b=AY/SLP/SQ2U2N43sM0BlJY3c/YZ5EP0T6L8/8HbLbarsZO3uVX+206jL1S5eCRYcHdpxeAw/aRhMXkdXwXGE6nOmd1fbDag4q8NEjiq2alj1gTtwcVphOkzLO/9uXO5aWZ3whSN9nKm4U7C4M/1WVt27JMupV+IOvQQyk7+Ye/w=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R971e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0X0nG2sP_1775893530;
Received: from 30.74.144.103(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X0nG2sP_1775893530 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 11 Apr 2026 15:45:31 +0800
Message-ID: <bb5d1b33-6880-46dc-acad-e99afc744673@linux.alibaba.com>
Date: Sat, 11 Apr 2026 15:45:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: thp: Fix refcount leak in thpsize_create() error path
To: Guangshuo Li <lgs201920130244@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
References: <20260411062152.2092967-1-lgs201920130244@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260411062152.2092967-1-lgs201920130244@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5CD181C0008
X-Stat-Signature: 3dpxnh9t7ztpz147pbe5zzp3hbchs899
X-Rspam-User: 
X-HE-Tag: 1775893534-288710
X-HE-Meta: U2FsdGVkX1/eegurNCltYuvXV8fhTQXbE3qk8Yx3Q0F/WHyOMEG87ynoA7leZDFag56+DjNmqQkVTwJ+ImAQeMcdC70QwdJM6GYqD9RRwX0rsUOINa2mveOYpnlZ7qBAx1r9WYEhegEWk2AX8dHeqlz+pNyFNU3emrpqq0J480NzuxVu9DxcffX+085VaRTVJiy+SehwrerKDNU1sgPX/ViLPMXmVF93hIE3jHu6NBc6669bjBIJv8j3Re7xQGsEyjNw5NlDx+vbcrpyrZcxfRvml41j+LeFLpWtIu0FS3d/ZEwSyyn4bNObmuKywJURrrPxdTwOyEIkArWc0mA+QPSohvRRNM0nyztDmcLIXzH5x791Wmr19uqvh1/l+ICCiYJ3aOnsAnM3IwMPYYtglnPRhxjrghD7HEEDLqD9wPHMCxgcZjq+Tg37RyXZXcVVqPWZ2f7w1sualKxmijNaAJQmx67aL5xgO4mrb5II49YEvKyKPWC8mT0XGVrRcH/c1bYXeyh+nJLc8mMz2UDJmZ5hYNUbAeFasQj5u77ZzekpGxN0J43LD3nl/IMifSMVjsO69rMZSOuSKPCKtsoX7J3Y647a33lOgzuvF6Bbf6qkcHXit151eYx9uYcNRxANWXI5b+5mc4w3+NR4u4sJS3Gd+OrD+fDUszcCxB6cZwIWGA5io/AxkDaPnc/FE5zvnK+PY6aqlwuLEqX24hAhRYJ7S0PB11MYs46BNCckbupT1X/PU05e7AJkjCjyYTSQSkrx34vnhqZmaGrzvVcvw8g1UmbcNjwsY23aOJK80nx0M/f3IQ8rM6AgSRwxHcsNNWiWEiMCoFtlDeSZrT+yaWJL3g5SkwHZIXG/a1Wn6dWbyGGWrFVkTNMbOF9QG9SU8ncXKfJRWlYZstmXEIZtnBn549HXfYusA14HlakX0pp2jfkoVnhD87f6E8CVwSXJ1zYG6AtjheABQM8o5nQ
 7JhegXDy
 e2dF5SiVUn5et0Wjv71OcDVUtHqZqcC+1bI+mqrjHltV8t1gmzOYqes0YSZcql/gnMttUrdUpnVpQyz/HWIPrkBI4Z2wQ9Pg4QnVItOI2uLTdfU837H5Kt96daoH0dGkTP3bcrT89TPgv36C3WA96WXdIgoS2axq8zrve/fyylm0TJR0KkTMR4K40GhjpWTTPBjL+g73eXCpQ/0Vn7YSF4F0pQRVPagjq785KB71n97ZvCvyga8oxPvWsSRPjp5T2b1I2a5YjcoA0MGfBUv2I100/9vGgpS/vqoqyCt3Cvk5mDgG0KYEkbP2+8fJYf5hbM6VDJDKhkk8IhNgh2es56jzsiThL6Ga4VxGQexi1SHkA0onzYi9yysZ4T2lIyTZI7EJet4jkegmUW8PYFzdLZJ0e8fppLo/AEt1J46IhWko4IRUnJ9260z6TGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/11/26 2:21 PM, Guangshuo Li wrote:
> After kobject_init_and_add(), the lifetime of the embedded struct
> kobject is expected to be managed through the kobject core reference
> counting.
> 
> In thpsize_create(), if kobject_init_and_add() fails, thpsize is freed
> directly with kfree() rather than releasing the kobject reference with
> kobject_put(). This may leave the reference count of the embedded struct
> kobject unbalanced, resulting in a refcount leak and potentially leading
> to a use-after-free.
> 
> Fix this by using kobject_put(&thpsize->kobj) in the failure path and
> letting thpsize_release() handle the final cleanup.
> 
> Fixes: 3485b88390b0 ("mm: thp: introduce multi-size THP sysfs interface")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> ---

Make sense to me.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

