Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 386FACA600E
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 09:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F6196B008A; Thu,  8 Oct 2026 05:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A6906B008C; Thu,  8 Oct 2026 05:56:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 095E96B0098; Thu,  8 Oct 2026 05:56:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DD9A26B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 05:56:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4BC6EA051E
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 09:56:33 +0000 (UTC)
X-FDA: 85299004266.18.9D1D009
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7330EA0006
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 09:56:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="g9fC/RVr";
	spf=pass (imf15.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791453391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1c2mwR8cYOL6Ygo+f93Zr8TE7ypOMqMWTVG83TPWuJk=;
	b=QKMSrEF91eNL/jWSBe7sEGBmfwFqMgtepsHbvCq5KRoVI/LIZFF84LopE5CUkjYQ3lRSCo
	hA1E9dKPSKLtMJVjT4a+6cYO4mXezzGSgiK4+d2rwFg/ysvADyiWrbh9nG4m592cT/FtIH
	ruWTSPzH3Jn2jRn/0mvF2rl0PkE7MPg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="g9fC/RVr";
	spf=pass (imf15.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791453391;
	b=Nj22vBL92/CoWASPEP5dLDxsR5OrDR/6AcXYPWiNtIP/eh3OS1cFtL9QbkXxZrl4m4277A
	0cwgq4uQTB0r3HoEgHE7e1vAfmgP9RQcylW9xAcQ3P2nKS2dSimwDxJj4NM1oqNPXCe074
	o/ybMTr3zW7ddRvFYGVFzgjDWe1RbTE=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791453387; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=1c2mwR8cYOL6Ygo+f93Zr8TE7ypOMqMWTVG83TPWuJk=;
	b=g9fC/RVrCE3TmzDiiOeo4Fn1zK21Ex0aEyL4TlqHPXlMT1hj+WxQYB06xQsFCPv/C1ZB8WU2bfpyQN+QGaIrxff8KbqalZixj0+GZ0ttsZzzyp2EoMbkhAEAF6JMHXPf63XSRxftjUzJTYrv5C6H6iXAGf+Kc+xo3Z0lpZfZsO0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XCO8HAT_1791453384;
Received: from 30.178.85.189(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XCO8HAT_1791453384 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 08 Oct 2026 17:56:26 +0800
Message-ID: <776ea9bf-88db-44d5-a80e-eaa958294bab@linux.alibaba.com>
Date: Thu, 8 Oct 2026 17:56:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm: memcontrol: drop kmemcg_id and use the memcg
 ID for list_lru indexing
To: Gregory Price <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Usama Arif <usama.arif@linux.dev>, Dave Chinner <david@fromorbit.com>,
 Qi Zheng <qi.zheng@linux.dev>, Yosry Ahmed <yosry@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 Xunlei Pang <xlpang@linux.alibaba.com>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260907110111.2286932-1-qinyuntan@linux.alibaba.com>
 <20260907110111.2286932-2-qinyuntan@linux.alibaba.com>
 <arNK64PxTXbVEhis@gourry-fedora-PF4VCD3F>
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
In-Reply-To: <arNK64PxTXbVEhis@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7330EA0006
X-Rspam-User: 
X-Stat-Signature: 3dje33e98ayziezp11phy3kfm5bu4gx7
X-HE-Tag: 1791453390-23565
X-HE-Meta: U2FsdGVkX18K5fJkgRwXxkJT3I2aJ3/6cPht1CjBNnyLat4ivCokHPk6aV0lB/Ef1yOWqc9BmFlq8vW/ZZYAkcbOOQb+QjTVJp8a4bgrQdCu7gM9RiIeHwHbEGvlvB7aK0fbINreOcUttJHb9LrMI1USQOrEefhQ37IDQVu7I9uJhWVxa4Y95/OtlUbIGByFywcXrX+Ta4K1aM0TtaLqXwr0zV+IJX2f6+kPFSwr6a+rkv2ONrJGYAB8gFh0NABfeiPxrX0xlKc9ZGUufQhY5ln+UPWVAyiHScO7WPa+Ks4I+Q/hoYV2AE/LS0Mlx5WTRGTb3tLdBcziUJwPV9cinq94kYkKCgoYX4L+tgtoku+JUaHgQ9Il3Y2jwEifeorMNfFqco7hqtWTRhYSet0g+fUiVaPUa7S/T0uAbbKekW+Zvly+yKR7lmtuitkKAQ/kqgBw0xBDshpoaaycdUol4b/JYWiojJYtp5xOT7IjVTpOae3t+61qlzcIlXPqrPge4zuXRHv3y7wqrwr5BMovtagULb73rXAvggyY1tJZ2kOA6QAssRSjzJGrpxIm1NALgowCtA6IYQLWRSdH74UMbegm4lJ0WF7tEyPe95ST086vV9qIfiMWQMMl19HFEzcoudw0A7BrdVOOB2MHutEtf2z8qWKMjpEhVwSJWh5ZkVGFm4d4C+ry3+GgvC6NsUHpwYELgTo8HoxfVHWaqdskfeDIkdK7mlaRKWd8cYy7a6+AbY+ggry1c3HYEG9T1nn7tMNQGKzeQepYq3QjjuiFx4Qks2bw1Ja2cGv7eRLFE5KbnrIPNFM4yJYztp5n5xlVzGSmAGUimtcQHJ9siZwvk9/jvnpCiQhYi8xsSOv8qR8yvbCcHcY8mxM5X043t86E56XsL52EnH4BQR+kGZlKwo5ix7I0VMIsorLkzy33pvVhWyqBgi/vQrhJxsE3R+SkeE845NqxYnOpnwb2gTQ
 bdxzm0KQ
 Zi0LIVraZSi71YDdy21GQQmAai7FPO67VuD2j0Gl+TlEjz7h6DWUEHJxxesgzTKLx0bdWFVnEJt3mtbqQwX8gFwZUwVb9cTT0a94c3ZfwuXA1PhkqHULzdBE5/LSNLmwQanUbtP/s59GVHSzgESHomNBZV0iXqYEenl4ihs1yw/NDs2PcQBU3/M+OUJBl2yxcKkhi29Q3DbotMKQw4FK11DWAG/NtlyUBKb22HM+lTLrY2dG/2+uzwlbF8ZqHzCekU6luGBTgr4wrwZFFtAWTtjwr4fDU9dFDzzVlnotL7aCJMTUN/XVsOnBCaTDEhpTxLxVKmjJa7CrNlZKwrLZfH0w3+QC50eulO7FK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Gregory

On 9/23/26 11:45 AM, Gregory Price wrote:
> On Mon, Sep 07, 2026 at 07:01:08PM +0800, Qinyun Tan wrote:
>> kmemcg_id is a copy of the memcg ID assigned in memcg_online_kmem(),
>> and is only used as the list_lru xarray index.  With
>> cgroup.memory=nokmem the assignment never happens, so every memcg
>> resolves to the per-node lists.  The next patch needs the index to
>> work under nokmem as well, so drop the copy and use the memcg ID.
>>
>> The ID works just as well as the copy did: root and NULL still
>> return -1 and use the per-node lists, and the ID is only released
>> after the list_lru reparenting, so a stale or recycled ID can never
>> reach a live list_lru entry.
>>
>> The early return of memcg_offline_kmem() under nokmem is dropped as
>> well, so the reparenting also covers lrus that stay memcg aware
>> without kmem accounting.
>>
>> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
> 
> This breaks an assert in memcg_struct_check - i think you want to drop
> this line as well
> 
> ---
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 5d7a26c91610..fcba9eb55659 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5886,8 +5886,6 @@ static void __init memcg_struct_check(void)
>  				      private_id_objcg);
>  	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
>  				      private_id);
> -	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
> -				      kmemcg_id);
>  	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
>  				      oom_group);
>  

Good catch, thanks!  I missed the layout assertion when removing the
field.

Andrew spotted the same issue in v3 as well.  I will fold the fix in
when I send out the next revision.

Thanks for taking a look at the series!
 
Qinyun Tan

