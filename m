Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 166FFCD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 13:39:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 650E96B0088; Tue,  9 Jun 2026 09:39:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 628786B008A; Tue,  9 Jun 2026 09:39:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 565376B008C; Tue,  9 Jun 2026 09:39:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 47A276B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:39:08 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DAB7014055F
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:39:07 +0000 (UTC)
X-FDA: 84860480334.19.2EBD438
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id CE75C2000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:39:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DHA5pvdG;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781012346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YJV2I1pYWH8I5eTLLlBTFWiw8BNl9+kPEFYXmmxRFA0=;
	b=ve5NdaF49Hr6GAqWX4MPrgM7ObplblQRJH6l0hekLV7aBHBQzbTURkhCITgunJ/vb5HG6+
	KzRdE4U7rrIS5OS6jBmN4o2dMRl9vC4c4ZvRZfe6sb6DOeoOZOgabaEs1eKiKxji8Im0QN
	n4y7WXtP/gDX5+YQWHr+gHQ2oI8TFrw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781012346;
	b=TbhdqKmd65Uw+cR6JVNUKjr1joY2V1K7/zMslpLefYNswLAr+nL6J/dj+hRW/shXaYt6q9
	qJguUXdRC0xFekqnVU2l3wcT3xqZkJ/IQlRnhsrCL5TxNrCWnzZtR+EkwRGPLQOl2RXVqk
	K38J/hW3f6/NcSYRQG3mhwDA7v2mA94=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DHA5pvdG;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <86575450-1d56-43be-a4fd-6f451e5be4e3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781012343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YJV2I1pYWH8I5eTLLlBTFWiw8BNl9+kPEFYXmmxRFA0=;
	b=DHA5pvdG52Z8Irgr/MLUCeE3l55DgnRt1kYMY2LtcWTgvjyHXVXQzZmJRQoBDdVBAzJEN4
	Rqo+Pc3l9/iqRCZMu3i2P2MnJItVE+ySpQCrTGcA4wmxKkIqwdSPoVVHf8MV1e7lKqzy7O
	z3+XUebaAMcRd6oZZlVWxxJQ1nu+Jgw=
Date: Tue, 9 Jun 2026 14:38:58 +0100
MIME-Version: 1.0
Subject: Re: [PATCH] fs/super: skip non-memcg-aware nr_cached_objects in memcg
 slab shrink
To: Jan Kara <jack@suse.cz>
Cc: brauner@kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
 linux-mm@kvack.org, hughd@google.com, boris@bur.io, clm@fb.com,
 dsterba@suse.com, linux-btrfs@vger.kernel.org, cem@kernel.org,
 linux-xfs@vger.kernel.org, shakeel.butt@linux.dev, hannes@cmpxchg.org,
 riel@surriel.com, kernel-team@meta.com
References: <20260609123047.1948242-1-usama.arif@linux.dev>
 <5exadtggg276xp5tayiqbbomnms4hjyaopmgu3chfpl2ug56dq@vyhswy2afzmo>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <5exadtggg276xp5tayiqbbomnms4hjyaopmgu3chfpl2ug56dq@vyhswy2afzmo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: CE75C2000A
X-Rspam-User: 
X-Stat-Signature: oz17khbq4p7h8h8px4cegpw5rif3nccb
X-Rspamd-Server: rspam08
X-HE-Tag: 1781012345-228107
X-HE-Meta: U2FsdGVkX188SmNBNIGetEa/JezCQLHOhLpgp5xISzCbXOktsTft+Z/+XSeqDHplvGD61iDIahT3G8qufjj3GPNKgkiWH7Z1qqbWBKP3NE2EWwr0ZCWqx/gbDkREy1R/aNBSCFZTMAD1qVPJT5Xr7KnPnZeqL++8m39pAYRIt2MXkKTUjoua57yZ5NFbom5Y6PY1PjY9/ZbaDcMEM+vondf1DtFc+qh0cUQbtLesp/CibFwPcT9ueC8PebGgRUKJi4kaMmyALqLH4RTqlWwgVi/5XNacz/OqJmj7/l3u3yjBtW/VjU/3rxjTNTK/4hm5EvPvd4/56vuP5oXnvjEtn015Ptr1Pqluc7Ow2ciB+PNvIashQncKIjqvPsg/FKsH7Hvahr1R6cc9VpuoaZ/8Kv2lQx4foJFNQi6tShwLJwExBv4TF0Vq40ZObX5VzDjagTRlnHib5rGbibWDjbLTU922HHv3uR4sRSMVhatjtz12kdB+wuRdYFFeWAO5h5gOCt8o03zsKaUdFqynPxjRn55ItOfKHRYcI/VAOVAdAghpBd1mJ5JH4f5l0nrzIGcetsrlp7Ww62RPQaWTGuyZXcXqQ+duoGjLl3pZXnKKxoSUQb/xj1sI6ZVmhkS2PyMLZgJSKn01LrMmCfZuiOZ0TkviL5fLze6WFbkL0B0X4+L32dqqhwzwifk6xTQGSESLYfDz8R5nEYlinn3KcAl9xC1xQgNCiVm5P5JucnyF5IrVAuDoZojKcFKx5UB82RwMB7BpkWy5BVpPzH+OWyYdqBa5KtNa88PqnZ5MtrcZ6HqpjSVtFhTgJrgrpXHnYMwYxGOOddEc1r59Oo3snDRbIE3gOJTjZn12pEqo+C1zC4RPWPekEfMua/drv44GWZzD1GOK6r9owd/6G58d15sn7SXIAOtasOo1bh1Pg5oxWKPSjFoT7NBddPibSsDVFtKMVz/UnExN7ZO1Ix+c5Cu
 4Yx8EDOp
 xUOGkhlevSC8aGKAnyWxsveX3mY9zEO5BbKyarTUWWjbXhnUYN2yt/jO97I+d3Y5PHOqvtgj5o2JVj0LxGSkuYYl2htiqU7oDcqS6ag2yEDLApMbWw+pufSuww87jll9h6VpV8xbWmqKFJ6I2a3D3F44+J3GHkbi1p+QoTGKn1KwB+DJFhmamZA6FjZb/o5jQZA7qqaclZ2vq7f46JLITw2YxATn+fOWxGawBnP0FGuUXSGV3kzJVZ7xCRz/a4ZH6LIyC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 09/06/2026 13:52, Jan Kara wrote:
> On Tue 09-06-26 05:30:47, Usama Arif wrote:
>> The super_block shrinker is registered with SHRINKER_MEMCG_AWARE because its
>> dentry and inode LRUs are memcg-aware (via list_lru). But the optional
>> ->nr_cached_objects() hooks that the shrinker also drives are not memcg-aware:
>> btrfs extent maps and xfs inode reclaim operate on filesystem-global
>> state, and shmem's unused-huge shrinker walks a per-superblock shrinklist.
>> None of them filter by sc->memcg.
>>
>> The mismatch shows up under memcg-heavy slab reclaim. shrink_slab_memcg()
>> calls do_shrink_slab() once per (memcg, NUMA node) pair for every memcg
>> whose bit is set in the per-superblock shrinker bitmap, which on a busy
>> host means hundreds of calls per reclaim pass. Each scan queues the same
>> global shrinker work item that's already kicked from the root path.
>>
>> Because btrfs/xfs global count is typically non-zero on any in-use filesystem,
>> the returned total stays positive even if a memcg's own dentry/inode LRUs
>> are empty. shrink_slab_memcg() therefore never clears the SB shrinker bit
>> in the memcg bitmap, so subsequent reclaim passes from the same memcg
>> re-enter super_cache_count() and pay for the global counter walk again.
>>
>> Restrict ->nr_cached_objects() to the global shrink path (sc->memcg NULL
>> or root). The memcg-aware dentry/inode LRUs keep being counted and
>> scanned per memcg as before; only the global fs-specific hooks are skipped.
>> The root/global shrink path still drives those hooks; only their
>> invocation from non-root memcg slab reclaim is removed.
>>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> 
> To me this makes sense. However I'm bit surprised that XFS inode shrinker
> (which is what gets counted in nr_cached_objects for XFS) isn't memcg
> aware. I guess since these inodes are on their way to a relatively quick
> destruction, nobody really bothered. So I'm fine with the change, just
> I'd like to make sure XFS folks are aware and don't plan anything in this
> area.
> 

Thanks for the review!

Yes I am hoping that if there are any objections from xfs or btrfs, it gets
raised. Have cc'ed the btrfs and xfs maintainers and reviewers.

Thanks!
Usama


> 								Honza
> 
>> ---
>>  fs/super.c | 19 +++++++++++++++++--
>>  1 file changed, 17 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/super.c b/fs/super.c
>> index 378e81efe643..5216c5dbd4c4 100644
>> --- a/fs/super.c
>> +++ b/fs/super.c
>> @@ -24,6 +24,7 @@
>>  #include <linux/export.h>
>>  #include <linux/slab.h>
>>  #include <linux/blkdev.h>
>> +#include <linux/memcontrol.h>
>>  #include <linux/mount.h>
>>  #include <linux/security.h>
>>  #include <linux/writeback.h>		/* for the emergency remount stuff */
>> @@ -169,6 +170,19 @@ static void super_wake(struct super_block *sb, unsigned int flag)
>>  	wake_up_var(&sb->s_flags);
>>  }
>>  
>> +/*
>> + * The s_op->nr_cached_objects hooks (used for example by btrfs and xfs)
>> + * operate on filesystem-global state and ignore sc->memcg. Driving them
>> + * from per-memcg shrink_slab_memcg() invocations only burns CPU walking
>> + * per-cpu counters and queueing duplicate work: the actual reclaim happens on
>> + * the global path (kswapd or root direct reclaim) regardless. Restrict them
>> + * to that path.
>> + */
>> +static inline bool super_fs_objects_eligible(struct shrink_control *sc)
>> +{
>> +	return !sc->memcg || mem_cgroup_is_root(sc->memcg);
>> +}
>> +
>>  /*
>>   * One thing we have to be careful of with a per-sb shrinker is that we don't
>>   * drop the last active reference to the superblock from within the shrinker.
>> @@ -198,7 +212,7 @@ static unsigned long super_cache_scan(struct shrinker *shrink,
>>  	if (!super_trylock_shared(sb))
>>  		return SHRINK_STOP;
>>  
>> -	if (sb->s_op->nr_cached_objects)
>> +	if (sb->s_op->nr_cached_objects && super_fs_objects_eligible(sc))
>>  		fs_objects = sb->s_op->nr_cached_objects(sb, sc);
>>  
>>  	inodes = list_lru_shrink_count(&sb->s_inode_lru, sc);
>> @@ -259,7 +273,8 @@ static unsigned long super_cache_count(struct shrinker *shrink,
>>  		return 0;
>>  	smp_rmb();
>>  
>> -	if (sb->s_op && sb->s_op->nr_cached_objects)
>> +	if (sb->s_op && sb->s_op->nr_cached_objects &&
>> +	    super_fs_objects_eligible(sc))
>>  		total_objects = sb->s_op->nr_cached_objects(sb, sc);
>>  
>>  	total_objects += list_lru_shrink_count(&sb->s_dentry_lru, sc);
>> -- 
>> 2.52.0
>>


