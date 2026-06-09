Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23079CD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 14:04:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42DC36B0005; Tue,  9 Jun 2026 10:04:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DE7D6B0088; Tue,  9 Jun 2026 10:04:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F4956B008A; Tue,  9 Jun 2026 10:04:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 209906B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:04:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DFA7D1C2D3E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:04:43 +0000 (UTC)
X-FDA: 84860544846.20.F3B304E
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf12.hostedemail.com (Postfix) with ESMTP id E1D4D4000B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:04:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dBp9B3Jy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781013882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c2X6ceXsUYSApmdLkh3PVusM4XweOQmUdFpOH3H9jJc=;
	b=5rEhThHcdYD8uiu72IIZLBwH/h5h/8R9NFZljmxO46uja8i2inHyIG26McvaQCJKOsGe6s
	kUTD1hNmA7+W4dJYAyMCs7TjvQs6SjwtOHCB+N1t9P4rk7GG/9OlOcdl5WfF+e+JyX6FoG
	D9/6plrWXF17Q9dSv500Yz2W2GG3y88=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dBp9B3Jy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781013882;
	b=Yef8kJ7HcSL3tWyoaNkDBIdB+eXF0ENIJPXOan6lqjzY9N9BoZBVMTIZgEgrMgEeR737sQ
	44fy2aiAd33JfWLlo2JH6nDPsgkgzO90JKAYtOPeAkYFyncCSyY3w4vv83MKQESishwiS6
	7oilZ2QC04ee2Og29CEQlO+oDeCRscc=
Message-ID: <b3a6dc63-7701-491a-ad06-ee0be7d23123@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781013879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c2X6ceXsUYSApmdLkh3PVusM4XweOQmUdFpOH3H9jJc=;
	b=dBp9B3Jymr0LeLKSWlvx32Kdjtkw4ksdKB90fajcjVzs2BdPKYQbEUWwCeAN4v7A4bJmxn
	dPm9v/Re4gl7oEf5/ABo6jAAG9/8emQh2zN/4SleDrwlKjBbN03QzTicHbCHQWbdYWQPGS
	p0Bd/Wv3HjYSwGtp1ya12t2vfhlM3/c=
Date: Tue, 9 Jun 2026 22:04:16 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/huge_memory: fix memory leak when
 kobject_init_and_add() fails
Content-Language: en-US
To: ranxiaokai627@163.com
Cc: linux-mm@kvack.org, ziy@nvidia.com, ljs@kernel.org, dev.jain@arm.com,
 akpm@linux-foundation.org, baolin.wang@linux.alibaba.com, baohua@kernel.org,
 "David Hildenbrand (Arm)" <david@kernel.org>, linux-kernel@vger.kernel.org,
 npache@redhat.com, Ran Xiaokai <ran.xiaokai@zte.com.cn>, liam@infradead.org,
 ryan.roberts@arm.com
References: <20260609131249.89288-1-ranxiaokai627@163.com>
 <c9500789-5a27-4348-84b6-a787230edebf@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <c9500789-5a27-4348-84b6-a787230edebf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 1iwmthnqdapo3irhe9tckbgmhogxwabs
X-Rspamd-Queue-Id: E1D4D4000B
X-HE-Tag: 1781013881-64504
X-HE-Meta: U2FsdGVkX1/kctI9nyFPLxkQ+k+d2QclC07mGfjH3seHc/aKNnyyl56xyhJVFmfLPYVpENQWiTBiJDvF9sr32dXNksYdlGsHUPZPvbTbUlDlWlbCPE5odB21RaUIGsFPxllvcI97OnXjGHW12FJqxfe6FqHCIYlbWzv3neYA4UKd3sOixjGnQauMJygd+h9Y2UgZGvsunjFQiiZZ4Q07p5BmDJ5M2Is0m8d4PA+JCPQaqnJnJd/CWOvAD9quClxJlZR7XUXfoixPb/rqxru8Q0M+bDja2lwqKhV7/bq8Vy7OH1QXrfmzDNe1Ikp12G9Dbl8S0GRzq9Fa9NxDSYJnzEW1eVq053CSxzP2YVbuPsdY/IBJqqtnnW+of5DA9D4Iht/1utulKvcss4k8dJhS8OaWDYYCS2/I7L4M5U7zkmTHxDiTgwF1ZF/4sY5kZTgKcootE/R+iB4CW+gdPGwVTHoSn6PnsKTBltiP5uRDFH8zWmbQ9PiSNQi8jE5R7SI3uqGkUrK4Yc9BiSPbRiSDLznFdUQ+ZQb/aUfmLVhba957LGtv4smxSV0UhpobaYWItbO03b5S9D4yhkwaSI0s8kDoU0Sm8gGswaAUC3CGX+19VbG8+yc1jGmX0zLDWbF8viZBCKIOSBwo13//KQYPoYNDIyPFnVnEO30iFUYH+RccnRjGl5VbFqvKlkN4FQang1UobVUHOlek8GEEnidNQEVHLCIe/wsQa+KqV9U4Sz/Pm5tT3gsmI5ZMnyh9z+Ua++AlGRYTg4012BTE9e2JjRmN3gDfzrF2VpGuTAmwxOBzoY+qQvb+XUqyl6tVngto5TOitzOEhDKFTi2YJOc9Mk+nSbp7z4jbhImz+W3sNU3LAuGHNWXecYOc6MODTedWm0y+X6Pc5pNRzRFDhLJB218oKjfDIhiiDbzads79jQ/1MQKAh7NvPyVt2l3r9cDcvpQfWdWmwb5TBtW2QmL
 b4coQVzw
 dvc30b1j91Wcm2xa7ItfV8GPn28FV0jlyNDvv8AoPNuFggvCxvUt6etdzFpQzQNw1eTzRgHiSS8AC7abux8PSXdxfwg8TNnZKqRH/S+3SLCzvyAnqutIhi0DxISfxAtr9GRavvzFCM5CyE9PLn/GY3ssdIWylg2pJszSy1bcfHGs0JA3358RQhUT/g3eOE3YmFSaSqEO6i9ohitfb0d/dTgNfVZ1mGT4BIQXS9s0fO6fKdbonqlAg1hU62OT4hqZQKGl1Wg4pQbDydo75CAp+mhPmW7fvFbdwaDMhS2QCpVumiw2k/3z99fhvnBGKSMznP2LTbgfOND86JwwPwgMLzdeASOYrELO/796TTUyi2s5tYc7hpLrvUWltpfcJp+tK52RD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/9 21:19, David Hildenbrand (Arm) wrote:
> On 6/9/26 15:12, ranxiaokai627@163.com wrote:
>> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>>
>> As documented in the comments for kobject_init_and_add():
>>
>> "If this function returns an error, kobject_put() must be called to
>> properly clean up the memory associated with the object.  This is the
>> same type of error handling after a call to kobject_add() and kobject
>> lifetime rules are the same here."
>>
>> This is because kobject_init_and_add() may have already allocated memory
>> internally for the kobject name (kobj->name), and leaving the refcount
>> at 1 prevents its release callback from being triggered.
>>
>> Fixes: 3485b88390b0a ("mm: thp: introduce multi-size THP sysfs interface")
>> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>> ---
>>   mm/huge_memory.c | 7 ++-----
>>   1 file changed, 2 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 653f2dc03403..601750dbe79f 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -790,11 +790,8 @@ static struct thpsize *thpsize_create(int order, struct kobject *parent)
>>   
>>   	ret = kobject_init_and_add(&thpsize->kobj, &thpsize_ktype, parent,
>>   				   "hugepages-%lukB", size);
>> -	if (ret) {
>> -		kfree(thpsize);
>> -		goto err;
>> -	}
>> -
>> +	if (ret)
>> +		goto err_put;
>>   
>>   	ret = sysfs_add_group(&thpsize->kobj, &any_ctrl_attr_grp);
>>   	if (ret)
> 
> This looks a lot like:
> 
> https://lore.kernel.org/all/20260411062152.2092967-1-lgs201920130244@gmail.com/

Right, the same issue :) There is a v2:

https://lore.kernel.org/linux-mm/20260412175428.2613383-1-lgs201920130244@gmail.com/

Still pending, though ...

