Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB864C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 04:20:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0BF46B0095; Wed,  2 Sep 2026 00:20:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE5686B0096; Wed,  2 Sep 2026 00:20:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFBC26B0098; Wed,  2 Sep 2026 00:20:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8EBA66B0095
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:20:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1EFC61C25B3
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:20:16 +0000 (UTC)
X-FDA: 85167520032.20.B35CA19
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf15.hostedemail.com (Postfix) with ESMTP id AEBEBA0005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:20:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=BzywlILm;
	spf=pass (imf15.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788322814;
	b=WPkceSpcXefHnYD7Wtl/NpR8F639br3ZOytiudaD7lf47tFdeWNJaXWazV9FSUMsOQMHHG
	f3anlWdA/TiEPn3M8zDjVspDIAnRkon+Tii0OwuRt4TLW41GH0Zsa0Www1rbgUStrJMb7g
	TIvgaW76YA5HB+AAW/k5aOVKuUFqQGU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=BzywlILm;
	spf=pass (imf15.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788322814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Vt2Ic8657HcteJslXznvT5iwAK2HkL400J7GxOIdrs=;
	b=D/m9YLhG9iIcZM6X3UYczPk/p5d047pQR3rfhG7qU3tAfZI84aiac7+Pq1JQlPTcWHiJVJ
	EbbtVyaN4bpHlsglgm3kS6ainwYpNH3oLbobfBJrXMm928t/pP5ZzvFlrJgAIUIYGjcq30
	Dw7x8HqpQTzaZy1QQAUjVJP7qHMV9DI=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2d715f4a587so8739345ad.2
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 21:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788322812; x=1788927612; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=7Vt2Ic8657HcteJslXznvT5iwAK2HkL400J7GxOIdrs=;
        b=BzywlILmYtXuDUt9loAvhTzk3TQcFst1IS7IjgZzEACUcHiaDkjyybVb3Ozxuzj75y
         21yIfZ6wJ1HI0U0/IIBEbGYqueZdsbBmPAqL13YYakOQrvLJ297fYFJC5fEHj3gKrm2Z
         DP7iU0IoKeSGWKMAKDjDZSMlQ/r/9ToNLzuLSfxJvPiVjON0gV5So/QFgVDDs2aa9JZt
         6NLiytPdlbqQfJCG21Ky/EALHhYPQxHQzijE1dCejnzck3pxn34U3JLYjjZat3hKeYo+
         paky+4JNc06CQDOXHEauFhabzRp456i/vgQ0A0ieWGtto0CZI3DYROKN4ly/6eMC+h3X
         kuKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788322812; x=1788927612;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7Vt2Ic8657HcteJslXznvT5iwAK2HkL400J7GxOIdrs=;
        b=Ld7v/FfjtTG6vqt56SYaBcV7kH8NocO11OxnSXwVIofXurIilcW4hQ2URpjqukqjtp
         ziVkqCVIr3jGrL1nrBg+ef+GKZRkAESjw2BSbY4eohhXbgS2tJgTVUF3u/02VzvwsWAO
         Dl7cfYtxwF/upFZHr40CyHkFYgPqX6CC7MMdRbqc2iYnVobq+iW6wT/hOM5reuH9vJd1
         mlgA4EumYQD19NfWqi9Wjwf00FPfQnZz172yyPtu5wRd/tAsJWacki9Vhu/lpsjA7J0L
         Fq2GoJyWO986bLFyb607OCtTy9DoxMiIyB76LzDeTpEG4eI+boVPWUht11Qvann+VMgu
         9d4w==
X-Gm-Message-State: AFuF++l/JD5/jVrcdYExsja+rxoWVtt7Yk6oAd4X2bSU0BERTq5CIixj
	BRWm7o5zVkulsC0Z1eUUB3wGGvSIEFc8Ft0khPYGYw9TPibMtqm+LbIqoYAS1sEiGW4=
X-Gm-Gg: AYBFou2Bzrm2yg7ai7VIlYrprsk4JfRPlpvkTjWEGIsK48cQOMRMszcuPCuSEaM4MeX
	2wQNn9lKlfToJD+fEaZSYHfkK+khw4Zs7Qv5Cieq1YbyvMQwLfyvovCIOuxnAwi0pZR01wKZ33S
	3dqGWyl7j3Mv/krVOau4/RUTBDwfLD/bVHc4S6KiNougG9fJ3hhfe30DZN8XO7d9caRI1TFw7gT
	p5yv82d5TasXJR0QMmHScx2WorSTDs94nZVz3sCR2iLd5u9OsTk0mKTVD1xZ0qYlxkIeeGcnIJj
	yJYJah+E6UznDeR2IHP4vlnP5murNQIiYUBySz0TlcGuzLNXsp8IG2dsqUKauS8Ij60JcRhR4+m
	fm+In6jS8/cXsJeiDFld+5Sx15wvY8tDwudNAUBx463D/sOpShY72/lBUjH7T4YfFtN6XogcVSv
	O+rvf5XJIQvr2F0wJIB+ohy1WotQGXBqSdTIWabTeG1FudZ7Z13Wygxlk2wREYwS5bvJmy6vsWF
	OBiiCdl+0CzsyigptDCSpTNeOdHMyN8qw==
X-Received: by 2002:a17:90b:4fc5:b0:38e:49c0:75a7 with SMTP id 98e67ed59e1d1-39aedfe18c0mr3175817a91.8.1788322812091;
        Tue, 01 Sep 2026 21:20:12 -0700 (PDT)
Received: from [100.81.12.150] ([61.213.176.56])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3990d76463csm9067914a91.9.2026.09.01.21.20.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 21:20:11 -0700 (PDT)
Message-ID: <0103ea4f-914c-476b-82e8-c670701a5578@bytedance.com>
Date: Wed, 2 Sep 2026 12:20:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] writeback, memcg: skip foreign dirty tracking for bdev
 inodes
To: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, akpm@linux-foundation.org, axboe@kernel.dk,
 tj@kernel.org
References: <20260901131028.1120284-1-sunjunchao@bytedance.com>
 <b4yiuuthnjfgoc2djz5cju3jahstzwizqyaqxo5dd3qijmsww7@66sink2shhwu>
From: Julian Sun <sunjunchao@bytedance.com>
In-Reply-To: <b4yiuuthnjfgoc2djz5cju3jahstzwizqyaqxo5dd3qijmsww7@66sink2shhwu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AEBEBA0005
X-Stat-Signature: tcwq6uwozmni8heqyizj16deucib9ij3
X-HE-Tag: 1788322813-695406
X-HE-Meta: U2FsdGVkX18ibtfRQZz8X2yLNGvICrZJlPBlsj+KHiMzJDgbqD5YLNDVe6U7vmnEytelRZbOef5zbQMSSkNBuJCv42b50Vm51RVoNbCnEhnXxgCkCqGPttIOSzxgVDLtBq3vHOdmT0HmErqK2e5iOP9uO3qMbl4ORB/0zbh0PzkFfXqUeBoxT0AKRyD3qRn7ocdDcrDjFxmihXpOUyZ/USsCvwd9m+WuEeqGtXBA+f06p7NzJY/Vw5uCm1eWqBgXM5qpjMw2pLaixCalVSPff+KiMLHSphxugBhXNSIqvisH+uvOBuLN+sgZ9KWOn8t3LDrpH4SbfomEtox+x3SswVak5bRmlPzzrNLLlJWpzwLHyWOqfqVTC0bXML12ovHfy/j12SkVHkDjp/X/4WANx5JMRXxZKkO7SKmEburrrKKFA8cHvFhTjKvzAF7+tsOcLryoop3a2u6/CmDXQ8Fn7qiPN0nIrsxqqzFkj57/UDlJ8BnKkwEnHvoDmYshfNKdHVpd9K5kGvqPKDBPn6ZauV8GTZu60ZRZkuIas3Wp6l8kiaf3NecGE0NL13qqH5vrTLxWvWkRoZwKp9VBDnqM1iQgE29nYv9PejhFdZT1VPAai34NHgBbVXDO5fSr+Rt8b2Uo6sAczOwoNJ4DRLrSfpOXFXXItdKk3jWvxGtH3RKmzRIiSvA3ZoiDm91fHD8XL+cmecTOLSRW+qPsSCwIw83yR/W6pd68bgZoYKZRSEMMzyiLbxflA/DIb1IHfhwoRoTBquEejS3OIxVzsIB9mohlpJB4KD5xSvi0w3KxkISYUuYpJNeafQ7ow3/3pZu1bqheR8TnTliymJ/hGulizcHvqWyJU5PkURABJC/SD28PH6E0rVAT1nSH0zmCfzgZMLpQqyZSfao4g61xDz/hnPlLdaJtqYxT50oxfFagpVvq6bzdCW9CG7+y6Cl+tuOBZTTXFUPQwCIkjVqqj3a
 /xWJD4xj
 Boz4Jn0Ad6eUuLTagmMIymHNPxZPQkIO8aEqRuN/3jFCPEI2ZzGix1FBdpTbBN4N9olvM+FGp4SOTWkLdNnmR7z+H9U11U7RWjimYUxvww05UoZqUsBbE8VL3kM336Cd1+r2ZkZuHdGXUz4U6ADV5/K8mCs186+/nW05+b6mSc7oid4gXCzEdnEmU8BUGSmpvC9pQd+qDk86CzF7+43uM/u3MFrMDuDvaMxsOa+l+ejAv0okbXGfbnhgOk60QdBJyQkGc5XKqJb+IyL50vgMVEJkNnUu5u0KK513+JvsdNP7ab5e1B+8m5KQ5iIvdXDfi/zr7oXZ6a0DwAk11Os9ElehgxagbBeetVXYMDuLs5BnC5QE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/1/26 10:44 PM, Jan Kara wrote:

Hi Jan,

Thanks for the review.
> On Tue 01-09-26 21:10:28, Julian Sun wrote:
>> Foreign dirty flushing handles cases where a dirtied folio's memcg and
>> the memcg owning its inode wb differ.
>>
>> wbc_detach_inode() notes that "concurrent write sharing of an inode is
>> expected to be very rare". This expectation does not hold for bdev inodes.
>> A bdev inode and mapping are shared by buffered users of the block device,
>> while the inode has a single wb owner. On ext4, buffer-cache folios used
>> by metadata and journal I/O can therefore be charged to different memcgs
>> while sharing the same mapping. Normal bdev activity can thus produce
>> frequent folio/wb ownership mismatches.
>>
>> This was reproduced on cgroup v2 with the memory and I/O controllers
>> enabled, using ext4 on a loop device. jbd2 repeatedly generated
>> track_foreign_dirty events for bdev folios charged to unrelated memcgs.
>> When one of those memcgs entered dirty throttling, the resulting record led
>> to a flush_foreign event and queued writeback with reason=foreign_flush for
>> the bdev inode's root wb.
>>
>> Skip foreign dirty tracking when the folio mapping's host inode is on the
>> blockdev pseudo superblock. This prevents bdev-originated records from
>> triggering later foreign flushes.
> 
> I suppose the real downside of foreign flushes is ultimately reduced
> performance?

Yes, reduced writeback performance is the downside we are concerned 
about. We suspect that foreign flushes contribute to the writeback 
hungtasks observed in production, but cannot establish causality yet.

We have two production cohorts using cgroup v2, based on 5.4 and 5.15. 
Foreign-flush and writeback stalls occur much more frequently with 5.15, 
even though the core foreign-flush mechanism appears unchanged.

Our production observations show 102 queued foreign-flush works, 101 
targeting the same wb, while the owner wb has a continuously replenished 
dirty backlog. These flushes can therefore consume writeback bandwidth 
and delay other writeback work. Regardless of whether they are a cause 
or a consequence of the stalls, a bdev inode generating this many 
foreign flushes is unexpected.

> 
>> The tradeoff is that dirty throttling in the folio's memcg no longer uses
>> bdev dirtiness to queue writeback on the bdev inode's owner wb. Those
>> folios remain subject to normal writeback. This is preferable because a
>> single bdev wb owner does not identify which cgroup is responsible for a
>> mapping shared by buffered bdev users. Flushing it can write back data
>> unrelated to the throttled memcg. Dirty accounting, normal writeback, and
>> foreign dirty tracking for non-bdev inodes remain unchanged.
>>
>> Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushing")
>> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
> 
> To me this looks as a sensible workaround but I'd be a bit worried whether
> a memcg that dirties a significant amount of bdev folios (compared to its
> dirty limit) cannot be blocked in dirty throttling due to this - as the
> comment above mem_cgroup_track_foreign_dirty_slowpath() describes. I'd
> defer to Tejun to judge if can be severe enough. But I think if we go this
> path, the added condition should have at least a short comment like:
> 
> 	/*
> 	 * Bdev inodes are usually shared by many memcgs so foreign
> 	 * tracking leads to frequent flushes which is counterproductive.
> 	 */
> 
> because otherwise this condition really makes you wonder what is going on.
>

I will add the suggested comment and send patch v2.

> 								Honza
>> ---
>>   mm/memcontrol.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 1271d390b617..5d7320f76c06 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -3898,6 +3898,11 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
>>   	u64 oldest_at = now;
>>   	int oldest = -1;
>>   	int i;
>> +	struct address_space *mapping = folio_mapping(folio);
>> +	struct inode *bdev_inode = mapping ? mapping->host : NULL;
>> +
>> +	if (bdev_inode && sb_is_blkdev_sb(bdev_inode->i_sb))
>> +		return;
>>   
>>   	trace_track_foreign_dirty(folio, wb);
>>   
>> -- 
>> 2.39.5
>>

Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>

