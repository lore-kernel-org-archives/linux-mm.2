Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA9C7CCD183
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 01:19:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33C098E0033; Thu, 16 Oct 2025 21:19:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ECE58E0002; Thu, 16 Oct 2025 21:19:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2298C8E0033; Thu, 16 Oct 2025 21:19:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 116278E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 21:19:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9337011A19A
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 01:19:20 +0000 (UTC)
X-FDA: 84005848080.15.E91B637
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf29.hostedemail.com (Postfix) with ESMTP id CD3C2120004
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 01:19:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="imTp//37";
	spf=pass (imf29.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760663958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8GdIKXKSuyoQ2I8o+Rbq8hN819PD6bayvqWnle+WNBA=;
	b=IaevztLtn3mX3aAN5osYbs/d1UQOleqDsR1Wd2wEIZ3yRxiuaAthQTpmZ3IJSaXyFGb/l9
	t7/qQRmalCj9TznDZqxW5rO0a8QLH6GgrArJBqfNpI/lfZhivJBU8kI4M/Ej+S3rjHkJ/E
	V+tYoMQLs1yHd+O7HJf0I4X9R597Khs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760663958; a=rsa-sha256;
	cv=none;
	b=V1bcXhRJL2Jb2xFW99sW5VtrJBzvFfV1+dZfIWfuTt/VSm3d65fL9DdsivmY2zawzI3bQz
	Q2L3IZIte4i+ZvejTXO1d0l1sjRtk6Z/ZK0GtTcE4dvExpfDqJCLWs85ACZDKdNlTDKEvJ
	zx02dkaM5N9/b+j7vBFMwezu2Vdu448=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="imTp//37";
	spf=pass (imf29.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <51f86d0e-e9dc-42ef-baee-0dfdd39b7cab@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760663954;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8GdIKXKSuyoQ2I8o+Rbq8hN819PD6bayvqWnle+WNBA=;
	b=imTp//3755IrNDCBBNh+hP7nBOKNj+g3rU0OfOwdNwRYq7dnSjQkADbbgS7uGpGkm6vTse
	MIhzcPlu+Jw+G2bTUVX2bPyPPNzDOuAEwmwtzV00isvxhy7cXYPfc2yBFdmxMVx4gm3F+2
	XmMNLjwILu2ktOoE2KtPPW+J3PyLDJE=
Date: Fri, 17 Oct 2025 09:19:09 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] tools/mm/page_owner_sort: add help option support
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251016201051.67097-1-sj@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <20251016201051.67097-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Stat-Signature: rc5se5mepmnyor9boqaq59q485sawfw9
X-Rspam-User: 
X-Rspamd-Queue-Id: CD3C2120004
X-HE-Tag: 1760663956-63628
X-HE-Meta: U2FsdGVkX19yEVD3gKDzZbSJ5EH8ltHnS2vg/UL90zMlKNOaGak388h9PMpAhCcENynYz6l+zp4AEHS+YMTHHMUMuqvsXpLDWtyFbLTAQpyKIolj+ilrH5ITKN4WpmHb47WpTsDsdiic6y9oxzj5uSPnwt6GnMQbfVbKqvJeYGsedbTe2nZc2Xe2F+SiFipz0s8Pnxyas94pNEmIleXbIf4nZhFZPfHmgd6CnwoKZwS+o/pgl9XH2af6rcafd/QJD3EmDdn8E1aNPuoqb5jQvONic82jb0hBzzzRD2uq/c8fqi1RudYkKO9PWl4Zz09j5pnVYZtJ1x8cYjtfuVb2HGHVBThMyfkdhNPaKiwp4Hg/LEivxCWWcGyadrf5tjvoaEmrN9O/9C01sAKb/CTg2/GLP+BMV6o7GSIjCNaiAQ0QoVJG0bPd46F3PSFmRqkf4nljiXN4YrvLrH4HkRWB7+bRuiC47r9K7luOQdLuNLyyW/gb5CD0FYgGXjv0Jujof6jMjUzYyt6Hr/psRM/eWz05MgM7/xx5dWJ/sO4nCs5qQgJspbaEy2L+qXjxjoaEsuLiQIIWijHaRUmBIyENtVwK8a0beUYHvo/kLb5rpZfhaBz4UZkssa3KfcEw1ZQmLXam7H/7MhiHkecV/7/YaOg+iaG+C6FmKJJjOasCdCM88ZfgHF3wN17mspQAdnECQ2o2axkTq1kF0n0iFlgqnc/Ixv9pdSqCc1RTO0gzYcLdmk9Il0hmTj+ll+tu+nqqwAmDHbSga7HJwww3sO4vAHjzVB+z6Qq2O+3ga4QUFfxkVpgJmQT3LeUZ5/LO1xKRZdelzdq3GlTODL39DKz8/X0gz6U/nd5JrN2REbZYlmO3DgwdmhiBRikzfvEumeWvVOBRTkBVq0OHZMjuR6BbA/wzjEmr/brAEbcJgI9spBKYvz0BT+YpaSePFcuTtJw+a7bMw2ZT1OmBZp6Bgyx
 Kx0/XVxF
 orDGiC/TbGKCEy+CPjyFowkZKSU5Ijzp1941esU/0cKYQum4sx5IKzJ4LCb4tgTpUH/oEv+Zf2gnIETeBI29UFzCTvSQ9Z4kuB3sV6d/OSbENQb4FxKpODnfyITl9X61112QBPNzNkPP9/6/KR3FZl8xpSn5ncrBUOSIbHHpj1RWlOtokDnt6fadnMFoIMFvf/lZssWYTKhMsBUsFgdW/Rob6AavFRnJLVVdWMvqHO0blYj0kX2+dsAPcSusVSUWJv7uK79xYWnaNVA+fVgmmvzEgggXpoJ8QPTNDckpWS3hOwLPhgz8VPmqDP8gl/LF59bBAbDFqJnJG9AK8UxT0KHgVdg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/10/17 04:10, SeongJae Park 写道:
> On Thu, 16 Oct 2025 13:49:25 +0800 Ye Liu <ye.liu@linux.dev> wrote:
> 
>> From: Ye Liu <liuye@kylinos.cn>
>>
>> Add -h/--help option to display usage information and improve code style.
> 
> Looks good to me, though I have a trivial comment below.
> 
>>
>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>> ---
>>  tools/mm/page_owner_sort.c | 10 +++++++---
>>  1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
>> index 880e36df0c11..202eafed66a9 100644
>> --- a/tools/mm/page_owner_sort.c
>> +++ b/tools/mm/page_owner_sort.c
>> @@ -669,14 +669,15 @@ int main(int argc, char **argv)
>>  		{ "pid", required_argument, NULL, 1 },
>>  		{ "tgid", required_argument, NULL, 2 },
>>  		{ "name", required_argument, NULL, 3 },
>> -		{ "cull",  required_argument, NULL, 4 },
>> -		{ "sort",  required_argument, NULL, 5 },
>> +		{ "cull", required_argument, NULL, 4 },
>> +		{ "sort", required_argument, NULL, 5 },
> 
> Seems unnecessary changes.
The spacing changes fix inconsistent formatting in longopts array.
Since the format fixes are simple and in the same context, I put them together.
If you insist on removing these changes, I will drop them in the next version.> 
>> +		{ "help", no_argument, NULL, 'h' },
>>  		{ 0, 0, 0, 0},
>>  	};
>>  
>>  	compare_flag = COMP_NO_FLAG;
>>  
>> -	while ((opt = getopt_long(argc, argv, "admnpstP", longopts, NULL)) != -1)
>> +	while ((opt = getopt_long(argc, argv, "admnpstPh", longopts, NULL)) != -1)
>>  		switch (opt) {
>>  		case 'a':
>>  			compare_flag |= COMP_ALLOC;
>> @@ -702,6 +703,9 @@ int main(int argc, char **argv)
>>  		case 'n':
>>  			compare_flag |= COMP_COMM;
>>  			break;
>> +		case 'h':
>> +			usage();
>> +			exit(0);
>>  		case 1:
>>  			filter = filter | FILTER_PID;
>>  			fc.pids = parse_nums_list(optarg, &fc.pids_size);
>> -- 
>> 2.43.0
> 
> If you remove the unnecessary changes, please feel free to add below:
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>
> 
> 
> Thanks,
> SJ

-- 
Thanks,
Ye Liu


