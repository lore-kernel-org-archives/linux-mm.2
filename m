Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE947CF8859
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 13:34:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 348AF6B0023; Thu, 20 Nov 2025 08:34:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F9566B0026; Thu, 20 Nov 2025 08:34:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 236406B0028; Thu, 20 Nov 2025 08:34:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 167216B0023
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 08:34:30 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D8D5E140114
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:34:29 +0000 (UTC)
X-FDA: 84131079858.22.A979676
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4A29E180010
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:34:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Kqt4D9kV;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763645668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5MQr0CRFgIXovknIEHiu9j5T0LFNZ19+f2mtfiMOm/c=;
	b=rxygjUaia7GtnWcU9vp5f3Zx+KdGhOa7D7ieJdW7NaZPsi7iyB9sLAOAGTX3LQxMUhSED6
	U2e5eecvyUDfBIAlNz/WfHywJ07MhHd2WO4Ex61xL00ScoXk0SYfsJD6Y5bi22uwLvKAuA
	prP7KqmsewD043kJBegowX5Pcwl6s/g=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Kqt4D9kV;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763645668; a=rsa-sha256;
	cv=none;
	b=U0KasbxEjWHunNMEoGrBYEwAQOud1SJhXhb+azzRqXMXsNi/YMqEU9a7PWF4I7TEAhkO7T
	MZXc8sSRbiHGwgY80lyRvRTIKL+tdXcZNaWWMlze0ObKz1siIFvR/Dh9AQ3U2OEWNa2YhY
	qPIVyj7c7siZnGHGjHx9vMv4Pbl36aE=
Message-ID: <0addc62f-e0b3-456e-b172-9216a6d2b8d5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763645666;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5MQr0CRFgIXovknIEHiu9j5T0LFNZ19+f2mtfiMOm/c=;
	b=Kqt4D9kVgo8JwZMHBEt00cKHZB42GRhjYrKiWjFMfvK33V+97UY6w4oO/R9vkQ9g1cBnkT
	DhDgOFCKVj9TlInMNBa3UzYy+bGA+d77esp3+g2SSJkirJGUqfphWkKICH5rLdRzceXQ9P
	k6mwGTxtL++xKJpiNHrBZiSW5jpvixk=
Date: Thu, 20 Nov 2025 21:34:08 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1 11/26] mm: page_io: prevent memory cgroup release in
 page_io module
To: Harry Yoo <harry.yoo@oracle.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <3076467321061767e16ca7abbaa33998bfee97cc.1761658310.git.zhengqi.arch@bytedance.com>
 <aR2NQl-w2O4PgvHr@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aR2NQl-w2O4PgvHr@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 4A29E180010
X-Stat-Signature: dnb94tz8h17dzxyfeibe1uz961pxczs9
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763645668-567583
X-HE-Meta: U2FsdGVkX19P43Hro0jHD/9qy7PwbXlZ9e3PhMVqydhRiixMX8b4u4u6vv48AM8mxvQ6JLBaTU+TYuKsnKV7sGT61dJkPVmIXLmZ0Lv+0v3PqRPtsKHjkYa9+6BNWO3zhwgBzIQWzZPeubBI1iXlBFdfX9o44pleKo6T0PxZvGYV+MWwYR7QoJHwNg4hhg6lMMcqHeHKOOJkqhSX4ogrAoOsMf+5bj7knxhF7y9gIK3yi8Lc6P9qQxTe7h6u2O0NRESfWZAOZRno3af4IEGZpRXZwCfeCQ+VgqzC+n6DPDS05WqqeUef3ryHW/OK7haqb0WUVBNSPz5busyAtc/F9r95NpSskF37XjwsZ3ulNEaIC2kB1dibsmYHIqIz7msPMe2J9xl6/YVnWBh2OYDzn9orDi221fzd3MjqZTYO+WPmjOlphk1tUFeq/p3ei5anf+RQy8ZSW46mo/8qtbTU2TstoIMME57vAQwoqZaH4lGfs0E6Zivboq3G1vga0rPQgB4BJhQjo7Lh8eswdPI5xbRQR5kN8bTb3m3gG8BKjNszkQpfxX8cpjuS+A6cyR444WFmCqZ5x4TUlfH52P64SlNeQjcIzt3xDGOxfSRnYclq834/iWv8/qJZt7dLmbNheESCIz2BexA4kLg49hdz9zUpmP2Aj1cSAJxxfONBD7C3Oxs5kaoQEdAFzX9TVddBOydgww6SdJ5n9NW3QAiGwisydKtGtBj3LvxGjXRK/fVFGXHBfxXAeniTDj2ZBH/uKFCvpQGwJr+NWV0+ldCQEGsCyE9eORNXyhhxmyhanFiX1UZPZl6whVjl+F1rcjM/U65ZPrl2G1FnOVluE3Cr6/64mes3Ss6k0m5j0hATtrS4k7x6y80GQh1Xb+Jsv8qw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/19/25 5:26 PM, Harry Yoo wrote:
> On Tue, Oct 28, 2025 at 09:58:24PM +0800, Qi Zheng wrote:
>> From: Muchun Song <songmuchun@bytedance.com>
>>
>> In the near future, a folio will no longer pin its corresponding
>> memory cgroup. To ensure safety, it will only be appropriate to
>> hold the rcu read lock or acquire a reference to the memory cgroup
>> returned by folio_memcg(), thereby preventing it from being released.
>>
>> In the current patch, the rcu read lock is employed to safeguard
>> against the release of the memory cgroup in swap_writepage() and
> 
> nit:                                          ^ swap_writeout()

will fix it.

> 
>> bio_associate_blkg_from_page().
>>
>> This serves as a preparatory measure for the reparenting of the
>> LRU pages.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
> 
> Looks good to me,
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Thanks!

> 


