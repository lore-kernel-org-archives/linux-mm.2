Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C39D9EEA851
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 21:23:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2772D6B0088; Thu, 12 Feb 2026 16:23:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 241626B008A; Thu, 12 Feb 2026 16:23:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18C856B008C; Thu, 12 Feb 2026 16:23:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 093526B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:23:24 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B01C8C17D9
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:23:23 +0000 (UTC)
X-FDA: 84437080686.21.C9E20BB
Received: from mail-dy1-f194.google.com (mail-dy1-f194.google.com [74.125.82.194])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7E4B1160010
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:23:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fpKJtB1W;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.194 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770931401; a=rsa-sha256;
	cv=none;
	b=5E/VpSdYrFeNUVVTVzmn/Dppkh5glTp3VE1xorYwQQwv8+XhjMweJ2xCFbFot5lUPU5/mM
	seGJBnr8BtbGGMNPP90YInJKc1zk34XWjqrbVqFP5XzatEdkDN72HA/jRLAPsL+c/rhLrh
	obkp5Ix8/CvdLmRO6npS4L+DPMsv8Zo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fpKJtB1W;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.194 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770931401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k+9lU8ttHS0Y3rUeACRp1GPu77nMoViWOTfYZGCx7ag=;
	b=Gc2+6r7irCSUTL16a2Su8gwssoJ/4VFTUqhhKgjE48yf9G938Fn0ZYWRJeIVLQ4lcLuo/7
	D4FlcuHWLBf7KzOUjQQoN/lSz0a2PRm4w/YfWVXU6Soe/LEostWT2+BMM4jnapILsog041
	NONOzeawzbslyuHUStFahm5MnH6NlxM=
Received: by mail-dy1-f194.google.com with SMTP id 5a478bee46e88-2baaceb4613so561054eec.0
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 13:23:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770931400; x=1771536200; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k+9lU8ttHS0Y3rUeACRp1GPu77nMoViWOTfYZGCx7ag=;
        b=fpKJtB1WUX+YkEYdFpT7ij8q6zFHI3Zp/wFnpPzpnfVvG8/C9AAjivQf1d7WkbhaXr
         bA0NEzZDY9TVEZAJXqPhfnaoWR1NoiJgUj1340Of8iUJ6BjvVVCDylB6apzM7EcjkJDW
         KeUJXNRfh8v41wo5ZzqTKh5DdVbgrQYyS+6Ue3JoX8vnyxSkIvf1K/ycDaAt6sYfNSkp
         pNmXzOVPnmD1Vl7kWKtwR+VHNleb9j1uxMhgIDKFoqc7OTi6V95Xvo2zfM6VcLGll26c
         JrqajO5YBKrgkFNZjO5V9mhux+LtTKu5q1TH+Uj5EEErOAC3Po2VehvguT5mIhEBGJ5B
         cM5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770931400; x=1771536200;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k+9lU8ttHS0Y3rUeACRp1GPu77nMoViWOTfYZGCx7ag=;
        b=uRqVWSwBeEDYjxEIzX8BxLQA/8ppjE3sgcXREXYR3DIhqYkTHBI2DlrP+wCOv028D/
         2h2IfpMVt1Dlxtd3j6g+z3E07BBUGUjb8Tq2ytClzO7FdPX8Jx1YYIL3Yj/GekMDb/1q
         Iy6M9N8wXRhuBC0Avu5xUz84cbmI1aEmPkCqOZ+zpOimmvr7yugldADQuDMdhgg1wTBT
         55GdliB5+whNPeiAXYI2dqsMxFTnNBb3HdrZkzQbkrzTJapz7ksbRtfkOJT+B78iplqw
         T3kdcKvAxhiumfSJHwzh7FVVB3fCyc+4gRhAaZUJQTeQkQdUH6H8f/iBQZ989VO64a3S
         Wurw==
X-Gm-Message-State: AOJu0Yx+zacwk2bdHyf+1BLUozAtgciU57W6RotmhCtsagzR6LTzMR+m
	YSvUnJnqkbndJIm7rCaviSNemwFJUO8EFObIM0fkII1gKq4RH2fz8ck2
X-Gm-Gg: AZuq6aIrGjTXe1Bps5ap/2sbMUHUDD1snE5bqiP20H0vUdrj1CTNImGM6FSySZ6MnT+
	EyKrru3XpreMpJj4Lxu0mZWHFbpRitfPAE5kP2JJ9bljH7sssP3mEAZoi0fIpxbPtDxTSOj9+Pa
	YwCo08GHCK1dlExeafxdA2Ek5Kr4ff/d1GPDmivS4ymPHyxUzEYnpbWzW9Sh4+Rkr+gA+XyaeM+
	td5b75pqc2pY6IRNneLTTuvAln2Pz5WcCAymXJo7Ccaz3/I8UhDf/Jx1+2Gf96I7cP6pq5CPr/V
	qWX7yeQvv1hMkjKkFN2pMFnT944HE3yth5gU+gQlk2sCY1Z4T5QrxW4dseael348aJU7aKCNi1L
	xxvHMrtVeMkpBvJADJQmVz4CdCnIiX5+FQ0v6LRQjQKnDGq40dk9E8Pg7HueTxFIKF9LCQuERjo
	WGgWNy0Cy05gYTt3krqlybQo+6ZSMD07EGaz8GlOb4HYY=
X-Received: by 2002:a05:7301:4449:b0:2a4:701a:b9ba with SMTP id 5a478bee46e88-2baba1b8829mr112653eec.14.1770931400275;
        Thu, 12 Feb 2026 13:23:20 -0800 (PST)
Received: from [192.168.4.196] ([73.222.117.172])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ba9dba2aadsm4282884eec.1.2026.02.12.13.23.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Feb 2026 13:23:19 -0800 (PST)
Message-ID: <905f5ee5-53f7-428f-9560-13d9aa1d1b19@gmail.com>
Date: Thu, 12 Feb 2026 13:23:17 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/mempolicy: track page allocations per mempolicy
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, apopple@nvidia.com, akpm@linux-foundation.org,
 axelrasmussen@google.com, byungchul@sk.com, cgroups@vger.kernel.org,
 david@kernel.org, eperezma@redhat.com, gourry@gourry.net,
 jasowang@redhat.com, hannes@cmpxchg.org, joshua.hahnjy@gmail.com,
 Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, matthew.brost@intel.com, mst@redhat.com,
 mhocko@suse.com, rppt@kernel.org, muchun.song@linux.dev,
 zhengqi.arch@bytedance.com, rakie.kim@sk.com, roman.gushchin@linux.dev,
 surenb@google.com, virtualization@lists.linux.dev, vbabka@suse.cz,
 weixugc@google.com, xuanzhuo@linux.alibaba.com,
 ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
 kernel-team@meta.com
References: <20260212045109.255391-1-inwardvessel@gmail.com>
 <20260212045109.255391-2-inwardvessel@gmail.com> <aY3r75eewxbArKVu@linux.dev>
Content-Language: en-US
From: JP Kobryn <inwardvessel@gmail.com>
In-Reply-To: <aY3r75eewxbArKVu@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7E4B1160010
X-Stat-Signature: httaypxmnwedkz13qxemf1u7idbd5q4d
X-HE-Tag: 1770931401-681741
X-HE-Meta: U2FsdGVkX19bfkqbYM5JVoPYmDQy96lobzJ0mZlBUhSOdngS8VaxenJFslnpi5OV5WDAIGNNIOOy2UjhzxG95RqSODJY5+HZ4PLH2HJ3MtgOr9CHJNYUnQfi3mM1LbxS/XYKwcHBdLwoyJ4X0beUr4VgT82Aqc7U0We/SNeA5qczIgzJ7hFpOyejabKk/qtThddZc9AsmZePl/XpQIxpuKOAVzh/mXcBQ4qXLpgglNLrYa1WlbufXkMi488NZLXJb0tJAOc+YGcLvUmGkmrhp4ipqfyRvv8olwDbdK/wbb7IYXnBDGbFHrSaoQRBwRTdGrHhZl8oXL+SwsO6iSCFjfRQcCxi+X2kYcEnjAsTrPLp0Gh2tq0VxhTHguiHulKVNyLs8pN2OBDW9Sc6kzpwcIxnfhRne3JBYdID1gMEZFJukNPvl3s14dpcWZvu18Tz5V+EOcjni2NQ6BsNJURLzVeAWphAprwM47SWnOb0oK9KyEnpiZtX5XkzCUZG3BgRMCKR2ceL0WQqFF39p8v70QdhZjoa6oEQ6iXIZdzbTEfU3XH3rKuBmHfOwTNtxZQuoceJGFUkeN5E6t2F1fASWF5Z0Ln9P2UsgTqxjrEYzJUcwDPjNHgxG0a2Zd7Im7j1JqCOTW0OTbhiGaIzhOlQLUmtIrbkijnxw3xyGfdDyiaaD1+adxs1ji25UAlYj5RuI84u4DeBkAOFrWpj2Ng7V83ecCMPimsHgr/2O9bwFkaaahrJsPCt2+EtzxMXojdXYBRhTP0zpjvoneUdQTK6MDw7K382SG9UuaJgYN5u/j+nyi08jrttMPS9xfqIO9EN3wTpApoKBq+jCJL+DtkR9jpYxqllW7BzTsjA6vkOp5dAmx2/Oh311NLWQ7lT2Rj2KVDYsoatSDrF5Llok1RB+RBzqP+NetY+CxZyHW+BgCf51oFPex+IWXZMQ1EniBuRe5sKJLrWFW08MaFQ1+0
 uopLCj2m
 Y5/UmKe9rvY6UkS02mOJICcM4RycbVqNA7G1aU+4PfAvbwkzEtldsrPOoSEUWc/cM7jCbbqloNmz/P+h+TTsCp+mozTW6z7L8+ZQQMiOhx7t1hgmdqSC4/Gl/gj3GjEEOrrRK5dhDdOtPliK6gBRlh/KJv9wVsAmhPSlO/tBL7F3jfAwPaOFp3y7ea26rQ3XGlbplAt3ANKOwyRhaFeqvOK6UhbjmgoyoheU1klR+oVkP+rk4hBCFYZvWsmgJ5lo+ws9v3FXyqzcy90v63pl6XJUHnp2KCIJXiadnzMdYwDlOPXffwxSMStenxMvGo03WX2e7evOUqiEXaePn19Z8cB7NQg6P/vI/tBpYcKMizD/M+FB6GiJjQ+NthVTo0IDlI7/2L9yqIEF18EPZ3CYC0Kj1fYSoeAnjK1dqambXiUIffuXOxLUo3tgIjYJfHC1k5HJ4wp238ZFE4aSybd8yJhV1hdPXAYOd44TUfhHRvoqPbx3/x2C5khTEGhmUuuwhgwApoO+qJPkVtbwruRjtaGYMfUF/y8E3Yp22kG8NeKLanyS9g/UlCVBQnBK+gyW9OzNhtELKGmuAeBaAvnsjXWxXQz0h2cOd+3bJMd4fUrCGYAZewE1JJHey/4VF0Ho2qnJcMwYom8h3aq5W+5FAf9ycRADmaI2PsaaVJZO5KyFeKKw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/12/26 7:07 AM, Shakeel Butt wrote:
> On Wed, Feb 11, 2026 at 08:51:08PM -0800, JP Kobryn wrote:
>> It would be useful to see a breakdown of allocations to understand which
>> NUMA policies are driving them. For example, when investigating memory
>> pressure, having policy-specific counts could show that allocations were
>> bound to the affected node (via MPOL_BIND).
>>
>> Add per-policy page allocation counters as new node stat items. These
>> counters can provide correlation between a mempolicy and pressure on a
>> given node.
>>
>> Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
>> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> [...]
> 
>>   int mempolicy_set_node_perf(unsigned int node, struct access_coordinate *coords)
>>   {
>>   	struct weighted_interleave_state *new_wi_state, *old_wi_state = NULL;
>> @@ -2446,8 +2461,14 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
>>   
>>   	nodemask = policy_nodemask(gfp, pol, ilx, &nid);
>>   
>> -	if (pol->mode == MPOL_PREFERRED_MANY)
>> -		return alloc_pages_preferred_many(gfp, order, nid, nodemask);
>> +	if (pol->mode == MPOL_PREFERRED_MANY) {
>> +		page = alloc_pages_preferred_many(gfp, order, nid, nodemask);
>> +		if (page)
>> +			__mod_node_page_state(page_pgdat(page),
>> +					mpol_node_stat(MPOL_PREFERRED_MANY), 1 << order);
> 
> Here and two places below, please use mod_node_page_state() instead of
> __mod_node_page_state() as __foo() requires preempt disable or if the
> given stat can be updated in IRQ, then IRQ disable. This code path does
> not do either of that.

Thanks, I also see syzbot flagged this as well. I can make this change
in v2.

