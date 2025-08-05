Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B04C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 07:44:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FF7C6B0098; Tue,  5 Aug 2025 03:44:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D7596B0099; Tue,  5 Aug 2025 03:44:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 013BA6B009B; Tue,  5 Aug 2025 03:44:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E62776B0098
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 03:44:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1EC8AC02EA
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 07:44:18 +0000 (UTC)
X-FDA: 83741915796.28.023B3F9
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5F2D14000B
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 07:44:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of gubowen5@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=gubowen5@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754379856; a=rsa-sha256;
	cv=none;
	b=xBrt1D8ctyGgA7FORcc/1EEEeRxDaQgWkAbzYXbqIQIRqhxfyORNf8I9+AcPNjBiM6bWaS
	XyOYb08Z1zpqP5PlS4jQwfo6i4lhWDLEjSmJb/r/vh7Jgg2xEPH7YAX8au8igzZzgAFEIw
	r/uOzx/aWhH/5rVtkXArwqzvyR2uOUU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of gubowen5@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=gubowen5@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754379856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z5DCuqED07zp9SZbafUcARzewuoFKv4F7nHBWW7it+Y=;
	b=I/I0MEVINzeXB1QEeht1xqGjbM5iuwD8KmphkNAeNel7ZCNEor+kZzej3UEdJQnVQHqz+x
	or07ZFnN6NR+QuQ40455tWeHdGW9iu4BRNvUyZlR3v/lPfrXSsy2/06OxYOxdJbkaUt95t
	qtA3Vodh1hCwxrAHB1KhYXruDgSD208=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4bx5154bWKz14MFl;
	Tue,  5 Aug 2025 15:39:53 +0800 (CST)
Received: from kwepemh100007.china.huawei.com (unknown [7.202.181.92])
	by mail.maildlp.com (Postfix) with ESMTPS id D2456140155;
	Tue,  5 Aug 2025 15:44:09 +0800 (CST)
Received: from [10.67.111.31] (10.67.111.31) by kwepemh100007.china.huawei.com
 (7.202.181.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 5 Aug
 2025 15:44:09 +0800
Message-ID: <d9128aac-1731-4cf6-ae04-0a86bc761b5b@huawei.com>
Date: Tue, 5 Aug 2025 15:44:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Fix possible deadlock in console_trylock_spinning
To: Catalin Marinas <catalin.marinas@arm.com>, Breno Leitao
	<leitao@debian.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Waiman Long <llong@redhat.com>,
	<stable@vger.kernel.org>, <linux-mm@kvack.org>, Lu Jialin
	<lujialin4@huawei.com>
References: <20250730094914.566582-1-gubowen5@huawei.com>
 <20250801153303.cee42dcfc94c63fb5026bba0@linux-foundation.org>
 <5ca375cd-4a20-4807-b897-68b289626550@redhat.com>
 <20250801205323.70c2fabe5f64d2fb7c64fd94@linux-foundation.org>
 <aJCir5Wh362XzLSx@arm.com>
 <o2gpvdtxqrdfrsbayorvzvjqcreb45puojpgfye7dimbuuvbdt@gxquukahrxo7>
 <aJD72syGyJs203Mw@arm.com>
Content-Language: en-US
From: Gu Bowen <gubowen5@huawei.com>
In-Reply-To: <aJD72syGyJs203Mw@arm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.31]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemh100007.china.huawei.com (7.202.181.92)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5F2D14000B
X-Stat-Signature: ayys5xb46icqy4ede1tzhd1gayjgu99e
X-Rspam-User: 
X-HE-Tag: 1754379855-246232
X-HE-Meta: U2FsdGVkX1/0+CnVxjhQJUNercTmaKWwamiiueZRyZDmwig5w/eRx37QeXUVXMEa5f63IPE7FGV0o7mHWdMRPNpuLDCHSbj3SCgxnklNyVYCqhTpxy/UOOFI3Quk+0+hoPhC0OwIyeIIg4I70TEjS6OHYWjuz5S7JVjog7WssqJxJBt78cKN7I48x+Yk2wIcFuv49tiyZ8+R76J7iv5epxZau4lSPp+/d2xwiK/6EgQi39rrrlNkLmHHxfB2ZlITSn+692UeR6+WrzmGc9RfpjBLTJVa5Z7/GdxRnKHwauKY9w+lbpmaWICggjIUN+WcaQWWz+2qTN4GMGQTLvjk5vb8FB3B/dKGb4/wzCq+NlXu0m2zOz6IXgUbE3RefJgRDWUamAzz59GQCKj/cnLzcbWEia4RCMLWamLj8E4ttMvtdfGbgVdbAdTL95gXN3UXXiaF3rNi0xViapBqMHgOF0xrmi7oyPbnPYUShSKi9fgWYKjglstAqKlHWhXv4YEHjgjRvZapGhBHXzOSYjkusVjpP/1WMkgucYlgXXmAEqNOgiPsakp078lIkkJPexNzTBEp2Wg50iA6NTECwH10Nf2zTebK8Omc0/lw2PMg8pq1cHVg1RROiUjPKEmeeda4G2hIzKRNQ1ivyy+mqaJR923C0Bu1sKE3rWOuZmwQre+jCTK9l2fAEIoV51vwUZeAh20yrbX76gamzx1bY0oj2T/0wGGQk04EnXVzfNSJjH8LNdvTS8r+94huwnmT7Vw4THaZJNawt5Noql/dcwMmB7iZ3XMusdb7Rs6yTYZrL5W9b7ym4aUBLvVlbK0M89Eqt7qFtdcvDENVPtW6c2GwGYlSbN8U8sHyG445WUuZyhoZFPr2I9u/7feLeZFTfk6AlzTvZMJ08+6lsUHrVApf/0kGDhyhvDR1+ff/hb7XNCQElQULrNnfypiihityjZ/md14yk9pha52VS3ZD1P3
 tZuZdjZF
 fu6fqAXxTAVmiNoytjJir1ZagyIO+ey4CfRtPwqs60SKizI4lDbNUhDfbOBhx3XSm09NkGp5b7V6Rj2+o9/v1qJNW2x4zIBmvCguzlVU1O25+vqCp2Om9wrtYcJvDeGesaxjKqNZ2J8kzO3f5sLwEZSo6DfkMIqJOULWquagfbTOaxfP0p8qHiHNq7EQMrbRKgHGGzbCIEq0SKZPibjo5OtTJTFnI/2xNFMdRWNhYhFf2d2x62PdyyMhPStL/2ZwOTHlB8b8A1JEkblRBHQMUekTXsVgjJNmgXhFo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/5/2025 2:28 AM, Catalin Marinas wrote:
> On Mon, Aug 04, 2025 at 05:34:10AM -0700, Breno Leitao wrote:
>> On Mon, Aug 04, 2025 at 01:08:15PM +0100, Catalin Marinas wrote:
>>
>> weird enought, lockdep never picked this issue, and I have a few set of
>> hosts running kmemleak and lockdep for a while.
>>
>> This time was different because I have decided to invstiage the code,
>> and found the deadlock. Still, no lockdep complain at all.
> 
> I guess it's because kmemleak is quiet in general, unless problems are
> found, and lockdep never registered this combination - printk() called
> with the kmemleak_lock held.

As you have guessed, this issue occurred right after the kmemleak warning.

Thanks for the reminder about printk_deferred_* and the suggestion 
regarding code comments..

I will send a new version after verification.

Best regards,
Guber

