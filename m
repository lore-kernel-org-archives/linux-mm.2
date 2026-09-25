Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5C98C9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 06:05:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CDBC6B0093; Fri, 25 Sep 2026 02:05:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77F226B0095; Fri, 25 Sep 2026 02:05:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6946E6B0096; Fri, 25 Sep 2026 02:05:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3EA826B0093
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 02:05:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B6DD516055B
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:04:59 +0000 (UTC)
X-FDA: 85251246318.03.186988C
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf23.hostedemail.com (Postfix) with ESMTP id 26ED2140003
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:04:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DdnQ6g8y;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf23.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790316297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ErGbHipHg92SiVnmafTU9VPVGftyId1XraUSz8ZzpyI=;
	b=4yH+2sOIYz9yQJ3wRZ2nZnQ5T1dULdh9xPh6H3iCQwlD1kkrSp3cZKGNOsNx6FhtRYGORw
	iHNIXPHGvVReSdxMur4P2Vykc1iQ1K9pEkXb5TZ08krOvmq/W9DxsDTPMz3Uo1S3ugxJvk
	FWgIPMpF+uYyUoWrQhvWuB57pM3hpvU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DdnQ6g8y;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf23.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790316297;
	b=8OnntJusBiSf9KFOa+gCT3Zg1LfFbTgBR17UYGwCDhhNGGAlHwAPVCOKeXHvMpKag3+NIx
	P/wHhcPX45DDkHySjGKnVCo6XaEot1ZRVlEerVGOnu6ws12iHV52+56teyl7G2v93YobuG
	uT/heBfxiMRNsW60/OzozLYaZ88unnA=
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc1ceb47d53so63462a12.0
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 23:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790316294; x=1790921094; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ErGbHipHg92SiVnmafTU9VPVGftyId1XraUSz8ZzpyI=;
        b=DdnQ6g8yaKxg3yvM6+icUB2vI8E5+87cGPC/8JbrtKJ/Ys2kqvGzIzWucqZTRnypJR
         IMqgvxi03MnWywdp7434aCjtVvph9X+oKy6Gq6FZZOVywc/G1n6jug1WZwxlUpyAOBa2
         X/HQHcu/30y38LpDyJD0R3M/+3y2jrauZTEzmCWHXm3XM5qtZuTXHT+YGknkacwxu1HM
         YYnt20WbdiL0CDZILSpyVlYIO3DaznlGeJGc5dcEbvP51myggJUH2k2tk69oZBr/w4DO
         zD0FZjZJBVVQPpU6gGf0EPSATQTIhxvG3HBpUZMJmVUlu4mw+DDymnT3vsByHNFlSeUN
         xPyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790316294; x=1790921094;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ErGbHipHg92SiVnmafTU9VPVGftyId1XraUSz8ZzpyI=;
        b=f7Ob1HUmqUo2PsoQmegR3zsxOGprzh68m56phGze2x9T5zDuIJkW3Qpv3LKv1FBfLE
         hw27Os4n4u4eCxTjtYSGBGyM+sfKhH4lJtEZmfgbO72LXw4tK34KDKe9LN7466KmrPFA
         eYRXCWPj1bp/bpgvzaucuafu81gzPowZmzs6bgoSC7oQcM4hZUV8vkubZd9v7hoo7vX9
         ADkhCAiaGiKjf4Gb+Tzjri2aYUBy4PUhvkZZloa0vPLiMvkE3PTnshfpHh+jM4OVejDU
         xoDdeBd9tro6HWfqk/9rvxQnDe4+ieAL3eJPBBnX7hDvijs08gwcLxaB/9NoytdbxNW0
         WBfw==
X-Forwarded-Encrypted: i=1; AKwUvBx+rjvnfbMdjHeib3Sjd4R2uMgz7BDHDCV4IxV7UXIm/GK15OpM/wqPzLTtQ14UmkCi7+GQzom48Q==@kvack.org
X-Gm-Message-State: AFuF++lnO1fgdVBLumtVaHO0xMzq6jl5kk/6hyWHND2V4Q7YwiUqlpXh
	+fw6QVFMvoFXHu2BC9NTyv1+8qNLilD6Nc23G65THfttUj8fz5Z1zmipsfl3LTkhmQs=
X-Gm-Gg: AYBFou0r+tYTR3aRnHsdRkVSyyGKlbsZqoRulRVEUcodxiQrDYWqgxX2N1SHWmzB0rX
	sC5DHeUgS/hi1KCooqMO9o2UzZT07ryfu7KJaalMBXOkVZZnbZDDtIZr2AaP4tEobgpmjzb9Hd/
	SnT2+iJkfCrI5MPm7F/UO1XLUl1a+Rvk4Y5D0OC8PpKFOyhZGsSoQdUsHQsZmSpTMG3J0UEgYco
	Yh2TkT+lBZAngFZu1kgGi3R3aRr5kZxnui5PnK5Jw3//6pvEbGggzNJaKCwQKQ7ZP6A4PCHjRia
	ZIE8jfSsNBC7k/QNlgurS5aSUidPjAlbMToh7cds1Bqe/D4WyyGTtLIiGQv/Pdz13tPeJNWTZBn
	SywITlHAbyyXMIDw27rChBRDynkZhmL3KzdBdHac84xLNquKGBpfbozoh9T2Dw0nZSsy5F6gLgU
	+6Y7CzZ66ZUvQNG8A/K0bOM3k7vSYa4qpMPxQqGjHyS+X4LxiuSSK/To3acmIRuLJ9o0KP6YTAz
	aE/LXTSgf6AZmB9mGlORsDxf0mGs/k=
X-Received: by 2002:a17:90b:224b:b0:3a0:78b6:588e with SMTP id 98e67ed59e1d1-3a098ac6431mr2758704a91.23.1790316294171;
        Thu, 24 Sep 2026 23:04:54 -0700 (PDT)
Received: from [10.254.237.61] ([139.177.225.234])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0ba31f408sm651548a91.3.2026.09.24.23.04.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2026 23:04:53 -0700 (PDT)
Message-ID: <d031dea9-aeea-4f2d-8b42-6b7362b857b1@bytedance.com>
Date: Fri, 25 Sep 2026 14:04:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/3] memcg,writeback: flush foreign bdev mappings
 separately from owner wbs
To: Jan Kara <jack@suse.cz>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, willy@infradead.org, tj@kernel.org,
 akpm@linux-foundation.org
References: <20260922125015.3435215-1-sunjunchao@bytedance.com>
 <20260922125015.3435215-3-sunjunchao@bytedance.com>
 <ncq6yhwolbwkivpsohfsanfap7qwix752g53zvo6hx3ywxn5f2@hgay3kms7jsd>
From: Julian Sun <sunjunchao@bytedance.com>
In-Reply-To: <ncq6yhwolbwkivpsohfsanfap7qwix752g53zvo6hx3ywxn5f2@hgay3kms7jsd>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 26ED2140003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: grdeyj3nddpa77orfe3oqfk7smntt1m1
X-HE-Tag: 1790316296-523863
X-HE-Meta: U2FsdGVkX184naGa+mUEWbqvefgYRd9FqyJHrbItWJqBMcEeHQvDNRPdsfBFIBvfkikPAuhcalgsghZSSZeUmi3hRDpK7cmbArB4RtUUT4JiuQ7GgUTmo9MvEvO+L/ntKyENd7gtK0bcn7Tm477aRKiF65QQwoFpV28QMiignBigfv0P2cEX81r8JFwVmvTtAxhXOnRP6a4WLGK3T2rBOkMp5OlTlAY27+xsaVRwchU5kddDPlyHuPgCCel5JfjVLH1NRL7hs75lq4/0Iy00L+CtF3JqWm/SYp4qkJaYuWF5g/GKkec/BdnFW4cnv0y3wRxKo4Gx/e/Wr3vAb1QOxbH/Di+S2LuwTdS/7jqdSjpMEoxro62h5SYhBua9MsmU4x5N84vCrJWi6E3tEtFpjTY4HSngGaq0yboSG5gNqPBoe2taNacsZRAvneHMccS0uebQGD8DoZh6U07z+Pwwbvq5UAM2zytznUB+AVGiY/TXm1xLdhbu5N+SZFc/BZqjwAAuSldluS8CXC0qqiJrIUzNrD5TzSKD+nKXJ7VnugNnRGOIDMICXKsWKsCuPNmZXNvWIp5/124wpEokELxVLQqqAUK+Q69lxdw0Aphm3qSodYiN3b/sO3SOOHeKGfUohpikqzCBPfxg2I60KTsCNIQvCxBNGsO1WfmClu4FHh2gA3bR4QaBgThSwKeF9qYZp8vsc/U2m52xrLzLSMSYWbCLifCV4LXlv9Wt5gka0MvnyWsHs3bmnNPAq9v2WUTZJxNM8+uQetQxaWxAd0FH3BP4STcGC0Z6RI2aauItxABtLP5TazcUge3Q8TvcGZuIqTvAsZSaA/CBLCWUJ/HtHyGDio0oB6D9G8/sTUc92GmkvQFc4jfxCRjMe26dG1DZMYME+CoKPROMHIT2QUP2KwcYtgYaTKQNYKXIoTONBiAheGVdxtLK2hpv5cbFfYGHtg+pVlLwZREvZUtrYMj
 M4l9g5LB
 7IraGaXGnfrnhv5cWpTUtT0wFH3BeZ8ZOcvtMRQG84JojTdgyxUaqP6shWdfA3WiCG7gaEwvp8HlbX87+PKmgAjUo6ddyCz/mtuMdkugbBl26BC9Xz1JcfDg2gBnBskpzJaCLaksw5xuJvfovH7RUvyp6bsPhcYEBOiGS5f3IePgQMWXVNJ4NwM0p4atZoP61Tw0XeZxzyVlvC+/PwvzEHK08F6xuIa5e4Drw6BpDYJL1Kaqo6unMDsOlOfp/CXffcYm8HqMVjoTr9tWDX0n56iqDv4CJq/dYU6CDzwOgrUW10PJzjb/CziPhXUcJz1y3wFJ9jQEJ6832KFfSp49QhBwSJcBBDS/C3iwX3UUxGnWpR1w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/26 8:02 PM, Jan Kara wrote:
> On Tue 22-09-26 20:50:14, Julian Sun wrote:
>> Bdev inodes are routinely shared by multiple memcgs. Recording their
>> owner wb as foreign can flush unrelated file data when a source memcg
>> enters dirty throttling.
>>
>> Record bdev device numbers separately and queue work on
>> memcg_bdev_frn_flusher to write only their mappings. Keep the existing
>> foreign-wb mechanism for non-bdev inodes.
>>
>> Use fixed per-memcg slots. Tracking uses oldest-first replacement and
>> expiry after dirty_expire_interval. Further dirtying during an ongoing
>> flush can trigger another flush after it finishes.
>>
>> Tracking is best effort: record only dev_t without holding device or
>> inode references. Records are updated under the mapping->i_pages lock
>> with IRQs disabled, but dropping a bdev reference can sleep. Also, since
>> foreign flushes are triggered by dirty throttling, a memcg that never
>> throttles could retain an unused record and pin the device object
>> indefinitely. Recording only dev_t avoids these lifetime constraints,
>> but device removal and device-number reuse may race with lookup. Such
>> races are expected under the best-effort semantics.
>>
>> Bdev writeback submission can block for a long time on congested devices,
>> with up to four work items outstanding per memcg. Use a dedicated unbound
>> workqueue to give these flushes a separate max_active budget, so they do
>> not exhaust a shared workqueue's active slots and delay unrelated work.
>> If the workqueue cannot be allocated at boot, bdev inodes continue to use
>> the existing foreign-wb path.
>>
>> This primarily affects filesystems that keep metadata in the bdev page
>> cache, such as ext4 and other buffer_head users, rather than the usual
>> metadata writeback paths of XFS and Btrfs. This also covers buffered writes
>> to raw block devices. The decision still does not account for how much of
>> the memcg's dirty memory belongs to the bdev. Even a single dirty bitmap
>> block can trigger writeback of the entire bdev mapping when the memcg
>> enters dirty throttling.
>>
>> Suggested-by: Jan Kara <jack@suse.cz>
>> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
> 
> Mostly looks good. What I somewhat dislike about this particular
> implementation is that we are going to have new IO issuers (additional
> workers for bdev foreign flushes) - potentially as many as there are memcgs
> using the bdev - which could increase contention for the device. But OTOH
> we already have as many wb_writeback issuers as there are memcgs for each
> device so it isn't something fundamental. What is unique that all these
> issuers will all flush the same inode (normally inode belongs only to one
> issuer) but OTOH these are bdev inodes where IO submission path is trivial
> and the IO pattern is mostly random so maybe the contention isn't going
> to be too severe.
> 
> So I'm somewhat wondering if the 'foreign flush work' shouldn't be a
> global 'per-bdev' thing but after some thought that would get a bit complex
> and it probably isn't warranted at this point. I guess the simplest way to
> reduce the unnecessary contention on bdev inode would be to use
> write_inode_now(bdev_inode, 0) which will just skip the inode if someone is
> already writing it (I_SYNC check) which is I think what we want.
> 
> Also one more technical comment below.
> 
>> +/*
>> + * No extra memcg reference is taken: this work is embedded in the memcg,
>> + * and mem_cgroup_css_free() waits for it to finish before freeing the memcg.
>> + */
>> +struct memcg_bdev_frn {
>> +	struct work_struct work;
>> +	dev_t dev;			/* dev_t of the foreign bdev inode */
>> +	u64 at;				/* last recorded dirtying time in jiffies */
>> +	atomic_t inflight;		/* flush work is queued or running */
>> +};
>> +
>>  /*
>>   * Bucket for arbitrarily byte-sized objects charged to a memory
>>   * cgroup. The bucket can be reparented in one piece when the cgroup
>> @@ -279,6 +290,7 @@ struct mem_cgroup {
>>  #ifdef CONFIG_CGROUP_WRITEBACK
>>  	struct wb_domain cgwb_domain;
>>  	struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
>> +	struct memcg_bdev_frn bdev_frn[MEMCG_CGWB_FRN_CNT];
>>  #endif
>>  
>>  #ifdef CONFIG_LRU_GEN_WALKS_MMU
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 856a7d07586c..6042c694d56c 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -39,6 +39,7 @@
>>  #include <linux/smp.h>
>>  #include <linux/page-flags.h>
>>  #include <linux/backing-dev.h>
>> +#include <linux/blkdev.h>
>>  #include <linux/bit_spinlock.h>
>>  #include <linux/rcupdate.h>
>>  #include <linux/limits.h>
>> @@ -104,6 +105,7 @@ static struct kmem_cache *memcg_pn_cachep;
>>  
>>  #ifdef CONFIG_CGROUP_WRITEBACK
>>  static DECLARE_WAIT_QUEUE_HEAD(memcg_cgwb_frn_waitq);
>> +static struct workqueue_struct *memcg_bdev_frn_wq __ro_after_init;
>>  #endif
>>  
>>  static inline bool task_is_dying(void)
>> @@ -3875,20 +3877,72 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
>>   * most recent foreign dirtying events and initiating remote flushes on
>>   * them when local writeback isn't enough to keep the memory clean enough.
>>   *
>> - * The following two functions implement such mechanism.  When a foreign
>> - * page - a page whose memcg and writeback ownerships don't match - is
>> - * dirtied, mem_cgroup_track_foreign_dirty() records the inode owning
>> - * bdi_writeback on the page owning memcg.  When balance_dirty_pages()
>> + * When a foreign page - a page whose memcg and writeback ownerships don't
>> + * match - is dirtied, mem_cgroup_track_foreign_dirty() records the inode
>> + * owning bdi_writeback on the page owning memcg. When balance_dirty_pages()
>>   * decides that the memcg needs to sleep due to high dirty ratio, it calls
>>   * mem_cgroup_flush_foreign() which queues writeback on the recorded
>>   * foreign bdi_writebacks which haven't expired.  Both the numbers of
>>   * recorded bdi_writebacks and concurrent in-flight foreign writebacks are
>>   * limited to MEMCG_CGWB_FRN_CNT.
>>   *
>> - * The mechanism only remembers IDs and doesn't hold any object references.
>> - * As being wrong occasionally doesn't matter, updates and accesses to the
>> - * records are lockless and racy.
>> + * Bdev inodes are commonly shared by many memcgs. Flushing their owner wb
>> + * can write unrelated file data, so each memcg tracks foreign bdevs
>> + * separately in MEMCG_CGWB_FRN_CNT slots keyed by dev_t. These records
>> + * use the same expiry policy, but trigger writeback of only the bdev
>> + * mappings.
>> + *
>> + * Both kinds of records only remember IDs and don't hold any object
>> + * references. As being wrong occasionally doesn't matter, updates and
>> + * accesses to the records are lockless and racy.
>>   */
>> +
>> +static void mem_cgroup_track_foreign_bdev(struct mem_cgroup *memcg, dev_t dev)
>> +{
>> +	struct memcg_bdev_frn *frn;
>> +	int i;
>> +	int oldest = -1;
>> +	u64 now = get_jiffies_64();
>> +	u64 oldest_at = now;
>> +
>> +	/*
>> +	 * Pick the slot to use.  If there is already a slot for @dev, keep
>> +	 * using it.  If not replace the oldest one which isn't being
>> +	 * written out.
>> +	 */
>> +	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
>> +		frn = &memcg->bdev_frn[i];
>> +		if (frn->dev == dev)
>> +			break;
>> +		if (atomic_read(&frn->inflight))
>> +			continue;
>> +		if (time_before64(frn->at, oldest_at)) {
>> +			oldest = i;
>> +			oldest_at = frn->at;
>> +		}
>> +	}
> 
> The handling of 'inflight' looks racy. After we check, the flush can be
> queued and we'll just rewrite the entry under the pending flush below
> leading to odd behavior (like missing flush later in case 'at' gets
> clobbered to 0 by the running flush)...
> 
>> +
>> +	if (i < MEMCG_CGWB_FRN_CNT) {
>> +		/*
>> +		 * Re-using an existing one.  Update timestamp lazily to
>> +		 * avoid making the cacheline hot.  We want them to be
>> +		 * reasonably up-to-date and significantly shorter than
>> +		 * dirty_expire_interval as that's what expires the record.
>> +		 * Use the shorter of 1s and dirty_expire_interval / 8.
>> +		 */
>> +		unsigned long update_intv =
>> +			min_t(unsigned long, HZ,
>> +			      msecs_to_jiffies(dirty_expire_interval * 10) / 8);
>> +
>> +		if (time_before64(frn->at, now - update_intv))
>> +			frn->at = now;
>> +	} else if (oldest >= 0) {
>> +		/* replace the oldest free one */
>> +		memcg->bdev_frn[oldest].dev = dev;
>> +		memcg->bdev_frn[oldest].at = now;
> 
> .. so I think here we need to block submission of work (retry search if
> busy) and only then update the entry.

Thanks for the review and suggestions, Jan. 
Your suggestions make sense, and I'll address them in the next version.
> 
> 								Honza 
> 
>> +	}
>> +}
>> +
>>  void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
>>  					     struct bdi_writeback *wb)
>>  {
>> @@ -3898,6 +3952,14 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
>>  	u64 oldest_at = now;
>>  	int oldest = -1;
>>  	int i;
>> +	struct address_space *mapping = folio_mapping(folio);
>> +	struct inode *inode = mapping->host;
>> +
>> +	if (memcg_bdev_frn_wq && sb_is_blkdev_sb(inode->i_sb)) {
>> +		trace_track_foreign_dirty(folio, wb);
>> +		mem_cgroup_track_foreign_bdev(memcg, inode->i_rdev);
>> +		return;
>> +	}
>>  
>>  	trace_track_foreign_dirty(folio, wb);
>>  
>> @@ -3941,6 +4003,16 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
>>  	}
>>  }
>>  
>> +static void bdev_frn_flush_work(struct work_struct *work)
>> +{
>> +	struct memcg_bdev_frn *frn =
>> +		container_of(work, struct memcg_bdev_frn, work);
>> +
>> +	bdev_flush_by_dev(frn->dev);
>> +
>> +	atomic_set(&frn->inflight, 0);
>> +}
>> +
>>  /* issue foreign writeback flushes for recorded foreign dirtying events */
>>  void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
>>  {
>> @@ -3949,6 +4021,21 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
>>  	u64 now = jiffies_64;
>>  	int i;
>>  
>> +	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
>> +		struct memcg_bdev_frn *frn = &memcg->bdev_frn[i];
>> +
>> +		/* Keep the workqueue availability check explicit. */
>> +		if (memcg_bdev_frn_wq && time_after64(frn->at, now - intv) &&
>> +		    atomic_cmpxchg(&frn->inflight, 0, 1) == 0) {
>> +			/*
>> +			 * Clear now so dirtying during writeback can refresh
>> +			 * the timestamp for a later flush.
>> +			 */
>> +			frn->at = 0;
>> +			queue_work(memcg_bdev_frn_wq, &frn->work);
>> +		}
>> +	}
>> +
>>  	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
>>  		struct memcg_cgwb_frn *frn = &memcg->cgwb_frn[i];
>>  
>> @@ -4202,9 +4289,13 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
>>  	memcg->kmemcg_id = -1;
>>  #ifdef CONFIG_CGROUP_WRITEBACK
>>  	INIT_LIST_HEAD(&memcg->cgwb_list);
>> -	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
>> +	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
>> +		struct memcg_bdev_frn *frn = &memcg->bdev_frn[i];
>> +
>>  		memcg->cgwb_frn[i].done =
>>  			__WB_COMPLETION_INIT(&memcg_cgwb_frn_waitq);
>> +		INIT_WORK(&frn->work, bdev_frn_flush_work);
>> +	}
>>  #endif
>>  	lru_gen_init_memcg(memcg);
>>  	return memcg;
>> @@ -4386,8 +4477,10 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
>>  	int __maybe_unused i;
>>  
>>  #ifdef CONFIG_CGROUP_WRITEBACK
>> -	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
>> +	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
>>  		wb_wait_for_completion(&memcg->cgwb_frn[i].done);
>> +		flush_work(&memcg->bdev_frn[i].work);
>> +	}
>>  #endif
>>  	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
>>  		static_branch_dec(&memcg_sockets_enabled_key);
>> @@ -5703,6 +5796,12 @@ int __init mem_cgroup_init(void)
>>  	memcg_wq = alloc_workqueue("memcg", WQ_PERCPU, 0);
>>  	WARN_ON(!memcg_wq);
>>  
>> +#ifdef CONFIG_CGROUP_WRITEBACK
>> +	memcg_bdev_frn_wq = alloc_workqueue("memcg_bdev_frn_flusher",
>> +					    WQ_UNBOUND, 0);
>> +	WARN_ON(!memcg_bdev_frn_wq);
>> +#endif
>> +
>>  	for_each_possible_cpu(cpu) {
>>  		INIT_WORK(&per_cpu_ptr(&memcg_stock, cpu)->work,
>>  			  drain_local_memcg_stock);
>> -- 
>> 2.39.5
>>

Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>

