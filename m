Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5461ECCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 08:39:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A2A58E0006; Wed,  5 Nov 2025 03:39:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67A068E0002; Wed,  5 Nov 2025 03:39:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B7648E0006; Wed,  5 Nov 2025 03:39:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4C73B8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 03:39:30 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 19063140245
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 08:39:30 +0000 (UTC)
X-FDA: 84075904500.11.A95ACB6
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf28.hostedemail.com (Postfix) with ESMTP id 44990C000B
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 08:39:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Pyx6Ff5c;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762331968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iACYjLabBUF6JiLupF4Suvn3LPuLCNXMAQpDmoncQDw=;
	b=ZfM6pDFAUVK7C5L7gs7yDSYKidHIktM/s2zLVZFpa9/qUmLU4tVzdsqh7LThalnDtbT8z9
	SSymtBHcLEUD0NJ/p3w196iEKbtgLaiyNfYEAlInXqJZQwnwfNISJHYywKa8eTwN0isKYc
	kEr4czTUthrDh+CfVRTtx+5ncJEfkHU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762331968; a=rsa-sha256;
	cv=none;
	b=An8KsGsXESenYgBVD2tww5x253TQbgWvL2qtYYATHC9Euu3V15AK7EQpD1zLkD4IJZwIve
	y94xTo+0GpTVyZiBf8/IUS+iQsPN4jkKnnQyg3cjwV7UQpXwmRHYr87y0yLYqAPp21HLq/
	SVFPNzdkyAWNyI4C5butuaawP9osuzM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Pyx6Ff5c;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <19986584-885b-4754-b98c-948e4bf9716b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762331965;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iACYjLabBUF6JiLupF4Suvn3LPuLCNXMAQpDmoncQDw=;
	b=Pyx6Ff5cbTDxh6bFMoG56H+cQ6sG/0QG4qgsZ9U/tgGmlWxDHgKBH8LRRuc/D04Dzw5pNX
	g6ZfVel4yEKJAW2CjwpU6eKy7U0KdoQjwCfCxRL/M8IrFCSUtUTNNFJd6uaN19l7qnpWJF
	MThr76Zp+1t0ReNALTjfAzsXQoS1c1Y=
Date: Wed, 5 Nov 2025 16:39:18 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v2] mm/memcontrol: Flush stats when write stat file
Content-Language: en-US
To: Michal Hocko <mhocko@suse.com>, Leon Huang Fu <leon.huangfu@shopee.com>
Cc: linux-mm@kvack.org, hannes@cmpxchg.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, akpm@linux-foundation.org,
 joel.granados@kernel.org, jack@suse.cz, laoar.shao@gmail.com,
 mclapinski@google.com, kyle.meyer@hpe.com, corbet@lwn.net,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org
References: <20251105074917.94531-1-leon.huangfu@shopee.com>
 <aQsIq_zQXMfNNo6G@tiehlicka>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <aQsIq_zQXMfNNo6G@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 44990C000B
X-Stat-Signature: ygk7kijkkk69h1cjg5gbmxjnpk5kwjgw
X-HE-Tag: 1762331968-129749
X-HE-Meta: U2FsdGVkX1/ICg/O72tjBHhNWtKOhrfbEnKQ5bShoAJAL2VtPloWB3ec62ZbQPRRp+YqxUB6Batyq4M13bXa/r4Tf1kVHoQbtaz/+sKkj6X3tM5+0end+gumPxy4Supm7QF0bhxSOeFDb8xLb79n8FZdXYO54bNmYz8s832habdid/DMFvTnzZ+AmxOTkB8f36sZ7f6UQu+MoygZQLXyoxNVbvEOCmhTMksKAr3YePw/o2lWAJOzp46Az9XyyIc4GWy4/MZYY0r9OGH+c4G8730te+0BD016dTaDl4gYiesa/u7ST/yitEsjDpcJhC5IZmWORVwWOpohCGg/9RDFWRCdeKe6XQJry05+rM0kP5S8B/UFxV5Wqkco2BcpaJy+GP4arIki4oUznptH1rJPFAn9LH5ypmuWo6DwMa3M6W0KCPQqreQnFvCNObS7FCOP/c2h6f0Ayya+UgKlOglBbCZ+rJN0MDlrPc0+/eqN5T1GM01FIlMpR8osp1xyhh7RHsr/v47cx+NwNSbmqEhCqYKwYfyft4CxLcl3K6uYpNtYkXs956dTzfNMXUs05gGI6JrNei7vNahTYggujIVuj1S2j+PPGINuAp3kajjQCdss4eVA6tu42ANDWEWiN9UnTfWuBpCqINgH7uAcI9RLoiP+H/Vq5F351BxPYQc9GifeZUz2Lhl+gAoKA8780itkP4HSBhwPJ1oCwUNTCc6l4i/V7mZqN2WJqpwAlVkD2hcckD31RsabjHqePHaTbSInEJnmUGaK8rV70/EgnGzg6SMvDDAhPJKD0aZjDzs1h3WPPztHZ7Yqv2CVXIXvfUlHP3uTtZSiBXUZVf201Cjt0ewNMD0OargzrVnKeIoasPWVmG+F0S0tSmymQ6WzakQEJoNvWvln/8Sy9+npLMHCtFpZku7ifOaxaaRaZ7Tk5fhEPlB3xUFvgg3J5sv2ZOLe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/5 16:19, Michal Hocko wrote:
> On Wed 05-11-25 15:49:16, Leon Huang Fu wrote:
>> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
>> index 6eed14bff742..8cab6b52424b 100644
>> --- a/mm/memcontrol-v1.c
>> +++ b/mm/memcontrol-v1.c
>> @@ -2040,6 +2040,7 @@ struct cftype mem_cgroup_legacy_files[] = {
>>   	{
>>   		.name = "stat",
>>   		.seq_show = memory_stat_show,
>> +		.write_u64 = memory_stat_write,
>>   	},
>>   	{
>>   		.name = "force_empty",
>> @@ -2078,6 +2079,7 @@ struct cftype mem_cgroup_legacy_files[] = {
>>   	{
>>   		.name = "numa_stat",
>>   		.seq_show = memcg_numa_stat_show,
>> +		.write_u64 = memory_stat_write,
>>   	},
> 
> Any reason you are not using .write like others? Also is there any
> reason why a specific value is required. /proc/sys/vm/stat_refresh which does
> something similar ignores the value. Also memcg.peak write handler which
> resets the peak value ignores it. It is true that a specific value
> allows for future extensions but I guess it would be better to be
> consistent with others here.
> 
> One last thing to consider is whether this should follow
> /proc/sys/vm/stat_refresh path and have a single file to flush them all
> or have a per file flushing. I do not have a strong preference but
> considering both are doing the same thing it makes sense to go
> stat_refresh path.

+1

IMHO, a dedicated file like memory.stat_refresh is a much better approach ;)

It's cleaner, simpler to use, and much more intuitive for users.

> 
> In any case, thanks for considering the explicit flushing path which is
> IMHO much better than flushing tunning which would become really hard
> for admins to wrap their heads around. Especially when dealing with
> large fleets of machines to maintain.


