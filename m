Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D5FDC98317
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 12:02:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F09A6B008A; Thu, 24 Sep 2026 08:02:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47A716B008C; Thu, 24 Sep 2026 08:02:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 342B56B0092; Thu, 24 Sep 2026 08:02:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B5E86B008A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:02:47 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 712DCA49DA
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:02:46 +0000 (UTC)
X-FDA: 85248519132.17.E3BE3AE
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id CAD3E20019
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:02:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WGJcNpdW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="GupBP3/s";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RjDFKhAC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gL4waggk;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790251364;
	b=BX1hvChlodlH88L4PyrAPgNe2MbmKwAipQ9qAgSHi4Ch+EDrBimL7+/+GoKHjegF/hSmaD
	HZR0osGmPdmu2AuW+XXWkNnZo4M3/QnJMoylrZa0pWGbfOtq13GHcYAcYrr5w5AajBSbBC
	oEkMaFp4SCSOWo4twq66FRF+aUooiy0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WGJcNpdW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="GupBP3/s";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RjDFKhAC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gL4waggk;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790251364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DeK80BXu3fA+B4ZVp9RerKkLs0GpQ27/dDvgj9rvyjk=;
	b=QmW9ZxEsl2kPOvvoOTGoUG93QaZi/m3fOGEAt7Wqzm5C1PIG/iGTZH4ziSuPT61KAnW7Ou
	mT7VZ2SKfZH8kdJKXRoRqXbfb/XsiOr0vOikJDB6QnDC4Pi43NfWP1WMRbTBLNk49ljSKv
	O7A1HTma3gVkvFgCAKg89PvoXtN9S7M=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 657C1200BF;
	Thu, 24 Sep 2026 12:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790251357; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DeK80BXu3fA+B4ZVp9RerKkLs0GpQ27/dDvgj9rvyjk=;
	b=WGJcNpdWWOhvNf00dsDpnrm1g2CbDrpIJ0iOheBGHUbfBAtwHYwlavwj7X29DzJrLaoHv1
	lJs2jJIUZ/pRIaYeNfRSQZKfK5RnIgAoE7xV63acLH5sxoVnSmFwyGBrmbNtpkgQiPUfwK
	eLJ5u65e4LIE/JD0yioXMjUUnKYAcbI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790251357;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DeK80BXu3fA+B4ZVp9RerKkLs0GpQ27/dDvgj9rvyjk=;
	b=GupBP3/sLQku5BfKU0MUOYpNWJOSpMMPkpE2tFvjd0EMaQVhFUYlB2RWDlAXYB73PqxQNl
	av8cQaJzWR+nfcBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790251352; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DeK80BXu3fA+B4ZVp9RerKkLs0GpQ27/dDvgj9rvyjk=;
	b=RjDFKhACLFCcDjvnWKldaxtlQ4qOIjUndgq1fBnvRUDtwRt7+nroIj+pbZprwF/6Qxl7Ih
	OQMEOREwOUrwQj2nZWagOBkP61PUjdrygJSRLrjhK11WnknM7KEvaB94lQdVnaYuq+Y9kN
	wfhK7cKh562DnjFtdTpZANgP1xqRIXU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790251352;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DeK80BXu3fA+B4ZVp9RerKkLs0GpQ27/dDvgj9rvyjk=;
	b=gL4waggkRY2AVpBPK0qYIGcHjy3n+9pSBoh5cXZfMUTcYCBgfqPyB4XeQOw5agPbT50QXZ
	RSISW2EhVSGYDgDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3BDA813354;
	Thu, 24 Sep 2026 12:02:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gTYjBlgRtWrsSQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 24 Sep 2026 12:02:32 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B3DDDA132E; Thu, 24 Sep 2026 14:02:31 +0200 (CEST)
Date: Thu, 24 Sep 2026 14:02:31 +0200
From: Jan Kara <jack@suse.cz>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, willy@infradead.org, jack@suse.cz, 
	tj@kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH v8 2/3] memcg,writeback: flush foreign bdev mappings
 separately from owner wbs
Message-ID: <ncq6yhwolbwkivpsohfsanfap7qwix752g53zvo6hx3ywxn5f2@hgay3kms7jsd>
References: <20260922125015.3435215-1-sunjunchao@bytedance.com>
 <20260922125015.3435215-3-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922125015.3435215-3-sunjunchao@bytedance.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: youyfo3arug98jt6esidups7otrzp11s
X-Rspam-User: 
X-Rspamd-Queue-Id: CAD3E20019
X-HE-Tag: 1790251363-909210
X-HE-Meta: U2FsdGVkX18jR6yaYhcCZXsB8VSQWRSdqWtOHUz9aL435P1zJSyW459IS4iqau+2WyQIMloTBAEBOqWhCVlAKf8jSuM1PeKAWlPTUnjxaDxBq6X/AxQTXTXnHEp5bu6s/fLJBMzvVVEh+bARr3LL6Iafs/zrT21WUo1+E0y/4eFNexlcZ8F/K4mvxh+4p7Bgx6THmMa+gF5ftGN0ItW3+/Jm9Zbvmx3M6jqSj+Pi+pdg7nCZQ+CTep2KRMofMwvAnZ61VZ7pkSWa1AwVhhyVQdTHpz3hb2e367Jc51vr66uuQEJarcevnWtxmatQWNu7326bvZs0+rx2alYyblau/fWjY8llRCWLDGE6K/bx7GuUuwVq/Z9BpDxQxYDw/AVe2U3AeYHuwlt+AMbiFz96IyCrASEpPNRQLB1UNRVUMSHMu2Ak58OPoxBqIY08kqWWo4cY/WS2hXxw2vkOQsd28XKd+JRvmhR/jib5B7FKhdaZvgMxEjrwet/H+CWipVMKPUlwn65hJ+9yYYpE2Ve7mUGFTq88HMMqBlEm1PArT6hQ0FZm7ZMw+0MeiHhf2JzLfzyFFcf8vTVYqAj/eKQmBjbUxH0Pkrp1rDgW3hxl5UXKQmKeiPFQJnY3JQSOOFw3KJwFsMrsy1sO/AQqzalRuf++jUXV2wNHS90pbgQwcvVdL2aeu5gv7hTl3+qI0ZF9fWu7IGRxk26p8Gbv/p7kJBXbfZWnj3yChDLzrS+X3Pm8iNSlUboSdIXupRQ/22D4gJ7QpT/UuG4dUPJIGbaT7PW2JEOQEK6n99nXNU220hWXdBgk3WFdY9l7Liv0DCtAi51A5vpYTQhmKMPPmr5f4kXP7IlXuttVoY0pV7Lz6XfA4HJJ+XjM6uGvI9UX2LZQts92ruFRr5w2sJybbf3+rSfcqzKK8bPPJNRRTaTOTfDlep2BV3ezYmTgCSRTsJCQLdn+wU7VZv/iCO3WvMy
 X5rjJUjp
 hOZK71BwlZBzQ7hydo0DOXdGNXBTHcbJyGOC0xV0PmXCUUzZOHFdmnXh1NXYNmQ47PuuV4TRLWNxT3GdyD49wgpKYQHQUp7D7rYjVjLUUAZKC0MMDL/HHveYnhhlSb7EwtTCVteU5JUgyfhFyEpvu9L6ju6DKefGXtGnokyc6fPgJ70c31p67BeYOuMdGk9qeQ9K8V4hHPra/1DEBMbfcrXNMDOWA1MVEgutmwJ2ddL8kITawX+xYC25qjJlDz+SyQUD810DoKnBrX3I+4VuLUIgPf69JPe6EjwxnL7baaB7LQVrMGEC/DqoOLF8YWEcZJXDzJcNocDEYhDOyCcihl/65+lzlSROAo2qjFQjZw2teJRs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 22-09-26 20:50:14, Julian Sun wrote:
> Bdev inodes are routinely shared by multiple memcgs. Recording their
> owner wb as foreign can flush unrelated file data when a source memcg
> enters dirty throttling.
> 
> Record bdev device numbers separately and queue work on
> memcg_bdev_frn_flusher to write only their mappings. Keep the existing
> foreign-wb mechanism for non-bdev inodes.
> 
> Use fixed per-memcg slots. Tracking uses oldest-first replacement and
> expiry after dirty_expire_interval. Further dirtying during an ongoing
> flush can trigger another flush after it finishes.
> 
> Tracking is best effort: record only dev_t without holding device or
> inode references. Records are updated under the mapping->i_pages lock
> with IRQs disabled, but dropping a bdev reference can sleep. Also, since
> foreign flushes are triggered by dirty throttling, a memcg that never
> throttles could retain an unused record and pin the device object
> indefinitely. Recording only dev_t avoids these lifetime constraints,
> but device removal and device-number reuse may race with lookup. Such
> races are expected under the best-effort semantics.
> 
> Bdev writeback submission can block for a long time on congested devices,
> with up to four work items outstanding per memcg. Use a dedicated unbound
> workqueue to give these flushes a separate max_active budget, so they do
> not exhaust a shared workqueue's active slots and delay unrelated work.
> If the workqueue cannot be allocated at boot, bdev inodes continue to use
> the existing foreign-wb path.
> 
> This primarily affects filesystems that keep metadata in the bdev page
> cache, such as ext4 and other buffer_head users, rather than the usual
> metadata writeback paths of XFS and Btrfs. This also covers buffered writes
> to raw block devices. The decision still does not account for how much of
> the memcg's dirty memory belongs to the bdev. Even a single dirty bitmap
> block can trigger writeback of the entire bdev mapping when the memcg
> enters dirty throttling.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>

Mostly looks good. What I somewhat dislike about this particular
implementation is that we are going to have new IO issuers (additional
workers for bdev foreign flushes) - potentially as many as there are memcgs
using the bdev - which could increase contention for the device. But OTOH
we already have as many wb_writeback issuers as there are memcgs for each
device so it isn't something fundamental. What is unique that all these
issuers will all flush the same inode (normally inode belongs only to one
issuer) but OTOH these are bdev inodes where IO submission path is trivial
and the IO pattern is mostly random so maybe the contention isn't going
to be too severe.

So I'm somewhat wondering if the 'foreign flush work' shouldn't be a
global 'per-bdev' thing but after some thought that would get a bit complex
and it probably isn't warranted at this point. I guess the simplest way to
reduce the unnecessary contention on bdev inode would be to use
write_inode_now(bdev_inode, 0) which will just skip the inode if someone is
already writing it (I_SYNC check) which is I think what we want.

Also one more technical comment below.

> +/*
> + * No extra memcg reference is taken: this work is embedded in the memcg,
> + * and mem_cgroup_css_free() waits for it to finish before freeing the memcg.
> + */
> +struct memcg_bdev_frn {
> +	struct work_struct work;
> +	dev_t dev;			/* dev_t of the foreign bdev inode */
> +	u64 at;				/* last recorded dirtying time in jiffies */
> +	atomic_t inflight;		/* flush work is queued or running */
> +};
> +
>  /*
>   * Bucket for arbitrarily byte-sized objects charged to a memory
>   * cgroup. The bucket can be reparented in one piece when the cgroup
> @@ -279,6 +290,7 @@ struct mem_cgroup {
>  #ifdef CONFIG_CGROUP_WRITEBACK
>  	struct wb_domain cgwb_domain;
>  	struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
> +	struct memcg_bdev_frn bdev_frn[MEMCG_CGWB_FRN_CNT];
>  #endif
>  
>  #ifdef CONFIG_LRU_GEN_WALKS_MMU
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 856a7d07586c..6042c694d56c 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -39,6 +39,7 @@
>  #include <linux/smp.h>
>  #include <linux/page-flags.h>
>  #include <linux/backing-dev.h>
> +#include <linux/blkdev.h>
>  #include <linux/bit_spinlock.h>
>  #include <linux/rcupdate.h>
>  #include <linux/limits.h>
> @@ -104,6 +105,7 @@ static struct kmem_cache *memcg_pn_cachep;
>  
>  #ifdef CONFIG_CGROUP_WRITEBACK
>  static DECLARE_WAIT_QUEUE_HEAD(memcg_cgwb_frn_waitq);
> +static struct workqueue_struct *memcg_bdev_frn_wq __ro_after_init;
>  #endif
>  
>  static inline bool task_is_dying(void)
> @@ -3875,20 +3877,72 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
>   * most recent foreign dirtying events and initiating remote flushes on
>   * them when local writeback isn't enough to keep the memory clean enough.
>   *
> - * The following two functions implement such mechanism.  When a foreign
> - * page - a page whose memcg and writeback ownerships don't match - is
> - * dirtied, mem_cgroup_track_foreign_dirty() records the inode owning
> - * bdi_writeback on the page owning memcg.  When balance_dirty_pages()
> + * When a foreign page - a page whose memcg and writeback ownerships don't
> + * match - is dirtied, mem_cgroup_track_foreign_dirty() records the inode
> + * owning bdi_writeback on the page owning memcg. When balance_dirty_pages()
>   * decides that the memcg needs to sleep due to high dirty ratio, it calls
>   * mem_cgroup_flush_foreign() which queues writeback on the recorded
>   * foreign bdi_writebacks which haven't expired.  Both the numbers of
>   * recorded bdi_writebacks and concurrent in-flight foreign writebacks are
>   * limited to MEMCG_CGWB_FRN_CNT.
>   *
> - * The mechanism only remembers IDs and doesn't hold any object references.
> - * As being wrong occasionally doesn't matter, updates and accesses to the
> - * records are lockless and racy.
> + * Bdev inodes are commonly shared by many memcgs. Flushing their owner wb
> + * can write unrelated file data, so each memcg tracks foreign bdevs
> + * separately in MEMCG_CGWB_FRN_CNT slots keyed by dev_t. These records
> + * use the same expiry policy, but trigger writeback of only the bdev
> + * mappings.
> + *
> + * Both kinds of records only remember IDs and don't hold any object
> + * references. As being wrong occasionally doesn't matter, updates and
> + * accesses to the records are lockless and racy.
>   */
> +
> +static void mem_cgroup_track_foreign_bdev(struct mem_cgroup *memcg, dev_t dev)
> +{
> +	struct memcg_bdev_frn *frn;
> +	int i;
> +	int oldest = -1;
> +	u64 now = get_jiffies_64();
> +	u64 oldest_at = now;
> +
> +	/*
> +	 * Pick the slot to use.  If there is already a slot for @dev, keep
> +	 * using it.  If not replace the oldest one which isn't being
> +	 * written out.
> +	 */
> +	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
> +		frn = &memcg->bdev_frn[i];
> +		if (frn->dev == dev)
> +			break;
> +		if (atomic_read(&frn->inflight))
> +			continue;
> +		if (time_before64(frn->at, oldest_at)) {
> +			oldest = i;
> +			oldest_at = frn->at;
> +		}
> +	}

The handling of 'inflight' looks racy. After we check, the flush can be
queued and we'll just rewrite the entry under the pending flush below
leading to odd behavior (like missing flush later in case 'at' gets
clobbered to 0 by the running flush)...

> +
> +	if (i < MEMCG_CGWB_FRN_CNT) {
> +		/*
> +		 * Re-using an existing one.  Update timestamp lazily to
> +		 * avoid making the cacheline hot.  We want them to be
> +		 * reasonably up-to-date and significantly shorter than
> +		 * dirty_expire_interval as that's what expires the record.
> +		 * Use the shorter of 1s and dirty_expire_interval / 8.
> +		 */
> +		unsigned long update_intv =
> +			min_t(unsigned long, HZ,
> +			      msecs_to_jiffies(dirty_expire_interval * 10) / 8);
> +
> +		if (time_before64(frn->at, now - update_intv))
> +			frn->at = now;
> +	} else if (oldest >= 0) {
> +		/* replace the oldest free one */
> +		memcg->bdev_frn[oldest].dev = dev;
> +		memcg->bdev_frn[oldest].at = now;

.. so I think here we need to block submission of work (retry search if
busy) and only then update the entry.

								Honza 

> +	}
> +}
> +
>  void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
>  					     struct bdi_writeback *wb)
>  {
> @@ -3898,6 +3952,14 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
>  	u64 oldest_at = now;
>  	int oldest = -1;
>  	int i;
> +	struct address_space *mapping = folio_mapping(folio);
> +	struct inode *inode = mapping->host;
> +
> +	if (memcg_bdev_frn_wq && sb_is_blkdev_sb(inode->i_sb)) {
> +		trace_track_foreign_dirty(folio, wb);
> +		mem_cgroup_track_foreign_bdev(memcg, inode->i_rdev);
> +		return;
> +	}
>  
>  	trace_track_foreign_dirty(folio, wb);
>  
> @@ -3941,6 +4003,16 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
>  	}
>  }
>  
> +static void bdev_frn_flush_work(struct work_struct *work)
> +{
> +	struct memcg_bdev_frn *frn =
> +		container_of(work, struct memcg_bdev_frn, work);
> +
> +	bdev_flush_by_dev(frn->dev);
> +
> +	atomic_set(&frn->inflight, 0);
> +}
> +
>  /* issue foreign writeback flushes for recorded foreign dirtying events */
>  void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
>  {
> @@ -3949,6 +4021,21 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
>  	u64 now = jiffies_64;
>  	int i;
>  
> +	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
> +		struct memcg_bdev_frn *frn = &memcg->bdev_frn[i];
> +
> +		/* Keep the workqueue availability check explicit. */
> +		if (memcg_bdev_frn_wq && time_after64(frn->at, now - intv) &&
> +		    atomic_cmpxchg(&frn->inflight, 0, 1) == 0) {
> +			/*
> +			 * Clear now so dirtying during writeback can refresh
> +			 * the timestamp for a later flush.
> +			 */
> +			frn->at = 0;
> +			queue_work(memcg_bdev_frn_wq, &frn->work);
> +		}
> +	}
> +
>  	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
>  		struct memcg_cgwb_frn *frn = &memcg->cgwb_frn[i];
>  
> @@ -4202,9 +4289,13 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
>  	memcg->kmemcg_id = -1;
>  #ifdef CONFIG_CGROUP_WRITEBACK
>  	INIT_LIST_HEAD(&memcg->cgwb_list);
> -	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
> +	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
> +		struct memcg_bdev_frn *frn = &memcg->bdev_frn[i];
> +
>  		memcg->cgwb_frn[i].done =
>  			__WB_COMPLETION_INIT(&memcg_cgwb_frn_waitq);
> +		INIT_WORK(&frn->work, bdev_frn_flush_work);
> +	}
>  #endif
>  	lru_gen_init_memcg(memcg);
>  	return memcg;
> @@ -4386,8 +4477,10 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
>  	int __maybe_unused i;
>  
>  #ifdef CONFIG_CGROUP_WRITEBACK
> -	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
> +	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
>  		wb_wait_for_completion(&memcg->cgwb_frn[i].done);
> +		flush_work(&memcg->bdev_frn[i].work);
> +	}
>  #endif
>  	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
>  		static_branch_dec(&memcg_sockets_enabled_key);
> @@ -5703,6 +5796,12 @@ int __init mem_cgroup_init(void)
>  	memcg_wq = alloc_workqueue("memcg", WQ_PERCPU, 0);
>  	WARN_ON(!memcg_wq);
>  
> +#ifdef CONFIG_CGROUP_WRITEBACK
> +	memcg_bdev_frn_wq = alloc_workqueue("memcg_bdev_frn_flusher",
> +					    WQ_UNBOUND, 0);
> +	WARN_ON(!memcg_bdev_frn_wq);
> +#endif
> +
>  	for_each_possible_cpu(cpu) {
>  		INIT_WORK(&per_cpu_ptr(&memcg_stock, cpu)->work,
>  			  drain_local_memcg_stock);
> -- 
> 2.39.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

