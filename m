Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65A3BD116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 18:52:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62CC76B00A1; Mon,  1 Dec 2025 13:52:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 603D76B00A4; Mon,  1 Dec 2025 13:52:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 541606B00A5; Mon,  1 Dec 2025 13:52:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 427036B00A1
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 13:52:08 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E91EB12D1B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 18:52:07 +0000 (UTC)
X-FDA: 84171797094.09.3862E43
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4E6951C0010
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 18:52:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=spyrard9;
	spf=none (imf20.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764615126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xQq4Rf5YSiH+AQ90gnOGfpSOtl9SH4z0g6Tkfjuou4Y=;
	b=R+saZO9zLt0hgfduhDLvY9JjdkQHM4mCFfHtE9X1xjcGnceWGJ4f9aLsQLLD7TNth4xeld
	5SaSB9vPajdiWtc7j/U3nQ+OEYgO0N2QZD2Vx3OAcQEL9B+lHheOjyyXTeIqI9n7QfJ3Ul
	kq0L9pAVqfSxpTSS9x5/r8G+lAPJC8I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764615126; a=rsa-sha256;
	cv=none;
	b=SWCNAWKGeUrvpPWYlxNA/Dm6eBmlwnEi276NE5K1MugDTB6sFynzdJawXvT5xbB0q+QPVE
	bATLUXml/qsiFj+JSqaXKtz68WS+KDfl570pqpdTVhNZOL08R1UljgSOao2g/PTYeWRhKx
	Y6dE16WbaJuzaSJXKKguWeyApAyjc5M=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=spyrard9;
	spf=none (imf20.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=xQq4Rf5YSiH+AQ90gnOGfpSOtl9SH4z0g6Tkfjuou4Y=; b=spyrard9ft38aVkUTVLqOnaXoy
	L82PpgzGDfcKbkfXHJM6M4CzE35OypceQzerURz2c6et4IIKzwYTSuVmwCFe+xWk9Y4PGz60rKkp/
	Xna952z0RlkEgKcWvgVXfXNiqJRr+T8hAaMqdBeC9uylxwUZpFrMutDf7hoQavBZ1BgCBqr/W9Uc4
	yNZXeanoXMIN67wcFvxcus5BgKelqc+TftabDLzPz97uGIG2lsKbSA3Bp7MfJ3zJUdEH9l8GHR3+M
	wvYwq3pmOjE/RT/0WxmBTO+NT19K0d6bMu7LuVguxhORnIAktTZBRo2CzCaZOOfiq/81kNaVKPndK
	DFJ8NIKg==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vQ90E-00000004RVo-0I4R;
	Mon, 01 Dec 2025 18:52:02 +0000
Message-ID: <37934c20-4cf9-480f-847d-212e7efb350a@infradead.org>
Date: Mon, 1 Dec 2025 10:52:00 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 mm-new 16/16] Documentation: mm: update the admin
 guide for mTHP collapse
To: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org
Cc: david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
 baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
 wangkefeng.wang@huawei.com, usamaarif642@gmail.com, sunnanyong@huawei.com,
 vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com,
 yang@os.amperecomputing.com, kas@kernel.org, aarcange@redhat.com,
 raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
 tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
 cl@gentwo.org, jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com, hughd@google.com,
 richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz,
 rppt@kernel.org, jannh@google.com, pfalcato@suse.de,
 Bagas Sanjaya <bagasdotme@gmail.com>
References: <20251201174627.23295-1-npache@redhat.com>
 <20251201174627.23295-17-npache@redhat.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20251201174627.23295-17-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4E6951C0010
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: b1ckn79yo6c77qyqgm7ocgbnw69bwz33
X-HE-Tag: 1764615126-933356
X-HE-Meta: U2FsdGVkX19zPBKBS1Hs50RowPGQZ5rmUESCsawdRKOrdOh7r/3kxjFAXhGaaopOeJlWQQp97QsXIUko18C8bbygVTXLFSlJttmxibkT1fej/gMYzmhBjyaiTqOm/+Ms8uC+XZs1LDBVmPXKZS8vogTSPjk5BIK1CLqq+ibMJX3yZdbcnB8q0b1hY9bbe36OU+QMvUkpdm7jUGMhdHGY/HTV1wJ8v1IEWzbDOMOE0neb3G2vqvq4sJPP8Yd5pSbi/tpHJZs5u/8Fp6j3e9zvI92fSsKj5mJdIIXG4Ck9yVy10IPJW9YBaYdkR7DWcAguJKMkWIDWq2q6E1U5dAx0sxV8a15lcMOAiHij+V7JU3Ina0jo177qyATJ7Z0cT3t/25A+sAjMnnprzSXz5ZCsHajL47HzV4udcFqKJWogzXgQi7qFSXWuFEcu4XRdwgA3FHtLccWnTnRYzc/OxEeNSyThgjT88R0qW3RTKgk22mQdrF+023DVqgA4dUPZclv23bRL7CvsxRcd4+gFTDoIPxu4FKpgJZ/Fc4aZCrKmzPP8aFxaigXSO8FPug8YwWJcof/zoCR4+QCPfvcclhhRaG5Q/dAGD2FO0Gf+DwuwbEdMRsmGPSMQsbvM05EuBSRKCSzB5viCbG+sUG52AwF1+Np2I+qYE42lYIYLfXkrZxXwVYCq2XyGIcIXYMn3KLRJk9R8qgKH+hZ45VCuQhqe9vpnTYg1U9d2MuRLMjz63FgFXC3mSq9aCZ3AWpjgR2dVeD4oIKZaEiqDY3B2DJRHpnqSiW2brqNeVgMbmY44E9lRANgRtbib8cIfVvm+MlyXTMV9TtAy6Z7V2tfRWNH0cUa26Q3u59VB/FdJzkE+hrrTPstz5F3QVZ1qwudcioQAuRQf+VbSgzUePRXJJBs75ZlRPWuSXV4KNCuqfHgE8vJy3404VUT+tfisUFVXY6N5rssDh16/VFpycU3x5pC
 p16cG6Ho
 7HL0Y91+SWfqbKzp4eJ0G55YhfYX/ivng8WLvdSyyzEsrVW7XAdEJRWhro+bKttEKAglZpe+9PTTgm4BlocLJykdiAzjc14KkbEaH94TbNGWeZzgbtzrKn82k/JvMQ1DvOKkfXeP+QJSbqAAMQXzj4KrH7zOLqZv6eveBKmPRxCakLVM7GkKBeHanaPzx93cMAZ20ZOenbVeaAQYXmd7viwiGu05j27yRn4o5E7fV1iZ8As7lHThRCHImOb5ScDfiZ5bT07onaTb+GWCOGpkOsOmxruCPv8OU3Ub9rTYa2yfEmtV7JKY8/e1NeGA430/vQJB7BXkH9Mc+yTLB2Gt6hg28h7bC7pCdnnh4rPSjgRZ0E1F/1YLgFWs0V0/ueOWEEW9tZQnU8FIQNHbm/V1dzK3XzIxdcaXsCsTA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/1/25 9:46 AM, Nico Pache wrote:
> Now that we can collapse to mTHPs lets update the admin guide to
> reflect these changes and provide proper guidance on how to utilize it.
> 
> Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  Documentation/admin-guide/mm/transhuge.rst | 48 +++++++++++++---------
>  1 file changed, 28 insertions(+), 20 deletions(-)
> 
> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
> index d396d1bfb274..87bcfa80886a 100644
> --- a/Documentation/admin-guide/mm/transhuge.rst
> +++ b/Documentation/admin-guide/mm/transhuge.rst
> @@ -63,7 +63,8 @@ often.
>  THP can be enabled system wide or restricted to certain tasks or even
>  memory ranges inside task's address space. Unless THP is completely
>  disabled, there is ``khugepaged`` daemon that scans memory and
> -collapses sequences of basic pages into PMD-sized huge pages.
> +collapses sequences of basic pages into huge pages of either PMD size
> +or mTHP sizes, if the system is configured to do so

                                                    so.

>  
>  The THP behaviour is controlled via :ref:`sysfs <thp_sysfs>`
>  interface and using madvise(2) and prctl(2) system calls.
> @@ -219,10 +220,10 @@ this behaviour by writing 0 to shrink_underused, and enable it by writing
>  	echo 0 > /sys/kernel/mm/transparent_hugepage/shrink_underused
>  	echo 1 > /sys/kernel/mm/transparent_hugepage/shrink_underused
>  
> -khugepaged will be automatically started when PMD-sized THP is enabled
> +khugepaged will be automatically started when any THP size is enabled
>  (either of the per-size anon control or the top-level control are set
>  to "always" or "madvise"), and it'll be automatically shutdown when
> -PMD-sized THP is disabled (when both the per-size anon control and the
> +all THP sizes are disabled (when both the per-size anon control and the
>  top-level control are "never")

                         "never").

>  
>  process THP controls

[snip]


-- 
~Randy


