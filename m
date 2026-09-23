Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01DEAC9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 20:04:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D22B66B0095; Wed, 23 Sep 2026 16:04:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD31A6B0096; Wed, 23 Sep 2026 16:04:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9B236B0098; Wed, 23 Sep 2026 16:04:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93EA26B0095
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 16:04:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0E2AF808FD
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 20:04:34 +0000 (UTC)
X-FDA: 85246104468.27.E2BACB0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id D5AE140012
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 20:04:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dMJw0WTy;
	spf=pass (imf07.hostedemail.com: domain of agruenba@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=agruenba@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790193872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zm1LNtEwK9T1sjNJECvmjOVLS/gi37Rtr0x+Gxr1MIY=;
	b=VAfOt6uVlSt9ezuFWG56ZwljQylNF+FXxGgwlOHEYRYy8/bK2vl5Z3l3vew/RYjLtXoR/o
	SRCvAbSc1ICilQhSr6uRJ5QZXlgwj+Ph+v3OWZf9hBjqJpFlOhQLO6CYjWEwfRHavfXFor
	2WB9pFwaMWVPL8Okas7+S0pLDOBGKHk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dMJw0WTy;
	spf=pass (imf07.hostedemail.com: domain of agruenba@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=agruenba@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790193872;
	b=HVEb3n6qLU+EwR63GCz9Tx5Bmz08LqjrTkXTET/yvbQHoG7FfskijlpPTfe9JxcpO47H4H
	VKDHdh2MU4CaGUGp1d/xSdPEHIp3NzO97UYxuu7p+nYb2enDtJj1lNEDIlhoHRLGj9lFfy
	Bthdi1+26pUu14rbX2sekKUAYA4F6Yc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790193871;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zm1LNtEwK9T1sjNJECvmjOVLS/gi37Rtr0x+Gxr1MIY=;
	b=dMJw0WTym9lRoj9n5piGjavZ+CdsOMbZ6gpRXt8r3lvYfMFv2Qmz3jtjqG+ijSWIxVrrg4
	F8dmgFX5/CzRBozI0njSZeGlUH/0mzbeGXjxK0NlA+C/d73PiTb/LfdaWdSrlXtpyRlXfF
	d8mxN7vr88UnZtB2myb5y/ZoM/vyjz0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-338-mT6tXMz7OhykOpuHwXIijg-1; Wed,
 23 Sep 2026 16:04:28 -0400
X-MC-Unique: mT6tXMz7OhykOpuHwXIijg-1
X-Mimecast-MFC-AGG-ID: mT6tXMz7OhykOpuHwXIijg_1790193866
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E1CC51955D98;
	Wed, 23 Sep 2026 20:04:25 +0000 (UTC)
Received: from pasta.redhat.com (unknown [10.44.48.10])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 36B2130001BB;
	Wed, 23 Sep 2026 20:04:21 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Mikhail Rudenko <xyzzy@yandex-team.ru>
Subject: Re: [PATCH v2 3/5] fs: Basic infrastructure for offloading inode reclaim
Date: Wed, 23 Sep 2026 22:04:18 +0200
Message-ID: <20260923200419.1834087-1-agruenba@redhat.com>
In-Reply-To: 20260911085142.1774803-8-jack@suse.cz
References: 20260911085142.1774803-8-jack@suse.cz
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: V3EYxf6lxCSwRJjYXlDguk7kNyuNoaMo5v6IvtSEYEc_1790193866
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D5AE140012
X-Stat-Signature: a7xs4aj3z9x1tw141o7yn33ikdbur3j7
X-HE-Tag: 1790193871-275897
X-HE-Meta: U2FsdGVkX186TAGobbEo4si9LM4pfT+N9BGhkrF1aTm5UQLpp4VT3OenjY6lIp+V0eXb4XHcYUUOcZxBej4lAmh+GcO70bKhTcwFXIKC6qqCoX5p/QwDgdE1z+thDyTosO9aJEratIVJ7QZoPxum5YSNP2YZ+Vv22vvgAoxTFfvdn78Z8ucGbMsXhtVbqOwozpOt16yJYd7P8EAdk+eynA8AQ96C3eBko66ZO5S+HGKGyHLSrxkxpsSsdwk49QzjtrgDHYHZvVYkTpMJ3ScpTeNgdpyUP1jCZnOVP3RrZU5dNruOKjw3T50TXp0jEcnNf015tlCmHpnk0CiXYkmEmaGZ9jZ8C/eU7iHYubELlDpCJ8g+OPpEXbb6Js6IRKA/ZjE5dIdgE0VnTABeTFdetT6Fi8MdWC4LRz9nVTMHrwH+h39L+x+Xc6Nugdddy6Pq9DOBB0rMX2J55erowahXFH6FhcA8dKu0bzeu8P9TGd/FbyrcvzMEkpgKQaWkJtrrlG4XchxJRly/u5OZ4x0ZEWHmH1v7tG2AwAgggVDHZ0fZZnYmQA3BjSjGVgLseDx+SUwhyM3OyTWgdqQoxrgR38qC7mi9gwrzczegGdG2rYFAf1m5n8EIyYFRG4v/h39wJcIieeUmuRk07/Kgpi5GuoUcS2iLJmfM6OEs+Y6J4zNjeisok0gNarAPoSdinHbqNWAOKvSh1JE1C6NaRYOJzYp2yq0gBw0pdG1HU4ezks4WIP2UMg0/JfjhzQmx86kdovGt4yf3YZgbvwv/WWm7O2ACO2Q0GLFJkAzwFqEwQo0Kg1rNgFgAXxlsKMAwVjED4Oj07woDVdXct6HQtkTs8umDP+/VgZHhPfJLkK0YXAF0nxNkbbq0CSLx5DTAlZb8gIPkjiXEIHBc3Yojzf46QPUYEtN+COPFZfeQTitaM5ckSA8hyxAPkG24N0p79rwjuKCw/yWBj1jUqyZbkv4
 iTzMMvIu
 NsqRmD9NLt9Jb4ffwI4E5kZeRDW5ZviiktEJu7KC1sM0opMfna8pTO3I3w+QG43k6cdJVskLhoyUOoroAC9z2AuzcOlsf79vYf80i+16DIGmbhbCg0wlk2yn7RtTGAA/uQkBHIauOKDtjnxO8n+GDsVGSuyHJWIWtRaEgbT2tsPpCIGP6UxlF01C6ASRLy0p2QhkA39mJW2Ym2aAqd8Y8YgEQSRANu9pKduzV6D+44jDeFze321ycgJBrs3yBOOmd03dVd0QadtU89/JlLF1Wj1CEKLXidUqim+aXa1rUjL2FFYSTTjC5I5p0id92hellbIry8T6+Xt9tI9e04qdWv8bk8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jan,

On Fri, Sep 11, 2026 at 10:51 AM Jan Kara <jack@suse.cz> wrote:
> Reclaim of some inodes is rather complex requiring running transactions
> or doing other IO. Consequently filesystems end up doing GFP_NOFAIL
> allocations from kswapd or even direct reclaim which is problematic
> because forward progress of these allocations isn't guaranteed. Add
> infrastructure for marking inodes whose reclaim is difficult and offload
> reclaim of such inodes into a workqueue to not block kswapd with
> difficult inode reclaim. The processing of the queued inodes happens in
> parallel from several work items so that the reclaim has higher chances
> of keeping up with the inflow of inodes if reclaim of some inodes
> progresses slowly.
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/inode.c                       | 197 ++++++++++++++++++++++++++++++-
>  fs/super.c                       |   2 +
>  include/linux/fs.h               |   3 +
>  include/linux/fs/super_types.h   |   3 +
>  include/trace/events/writeback.h |   3 +-
>  5 files changed, 201 insertions(+), 7 deletions(-)
>
> diff --git a/fs/inode.c b/fs/inode.c
> index 5555a513a0a3..e902095cf39b 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -74,6 +74,25 @@ static DEFINE_PER_CPU(unsigned long, nr_unused);
>
>  static struct kmem_cache *inode_cachep __ro_after_init;
>
> +struct deferred_reclaim_queue {
> +       struct list_head list;
> +       spinlock_t lock;
> +};
> +
> +/* Inodes for deferred reclaim */
> +struct inode_deferred_reclaim {
> +       int workers;                    /* Number of parallel workers */
> +       struct workqueue_struct *wq;    /* Workqueue for workers */
> +       struct work_struct *work;       /* Workers */
> +       /*
> +        * Queue of deferred inodes. The number of queues is the same number
> +        * as the number of workers
> +        */
> +       struct deferred_reclaim_queue *queues;
> +};
> +
> +static struct inode_deferred_reclaim deferred_reclaim;
> +
>  static long get_nr_inodes(void)
>  {
>         int i;
> @@ -919,6 +938,12 @@ void evict_inodes(struct super_block *sb)
>  }
>  EXPORT_SYMBOL_GPL(evict_inodes);
>
> +struct inodes_to_prune {
> +       struct list_head freeable;
> +       struct list_head deferred;
> +       unsigned int deferred_count;
> +};
> +
>  /*
>   * Isolate the inode from the LRU in preparation for freeing it.
>   *
> @@ -933,7 +958,7 @@ EXPORT_SYMBOL_GPL(evict_inodes);
>  static enum lru_status inode_lru_isolate(struct list_head *item,
>                 struct list_lru_one *lru, void *arg)
>  {
> -       struct list_head *freeable = arg;
> +       struct inodes_to_prune *lists = arg;
>         struct inode    *inode = container_of(item, struct inode, i_lru);
>
>         /*
> @@ -950,7 +975,7 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
>          * sync, or the last page cache deletion will requeue them.
>          */
>         if (icount_read(inode) ||
> -           (inode_state_read(inode) & ~I_REFERENCED) ||
> +           inode_state_read(inode) & ~(I_REFERENCED | I_DEFER_RECLAIM) ||
>             !mapping_shrinkable(&inode->i_data)) {
>                 list_lru_isolate(lru, &inode->i_lru);
>                 spin_unlock(&inode->i_lock);
> @@ -988,13 +1013,27 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
>
>         WARN_ON(inode_state_read(inode) & I_NEW);
>         inode_state_set(inode, I_FREEING);
> -       list_lru_isolate_move(lru, &inode->i_lru, freeable);
> +       /* Inode will take long time to cleanup. Offload that to worker. */
> +       if (inode_state_read(inode) & I_DEFER_RECLAIM) {
> +               list_lru_isolate_move(lru, &inode->i_lru, &lists->deferred);
> +               lists->deferred_count++;
> +       } else {
> +               list_lru_isolate_move(lru, &inode->i_lru, &lists->freeable);
> +       }
>         spin_unlock(&inode->i_lock);
>
>         this_cpu_dec(nr_unused);
>         return LRU_REMOVED;
>  }
>
> +/* Number of inodes to process in one reclaim batch */
> +#define INODE_RECLAIM_BATCH_SIZE 16
> +
> +static int get_deferred_sb_id(struct super_block *sb)
> +{
> +       return hash_ptr(sb, 32) % deferred_reclaim.workers;
> +}
> +
>  /*
>   * Walk the superblock inode LRU for freeable inodes and attempt to free them.
>   * This is called from the superblock shrinker function with a number of inodes
> @@ -1003,15 +1042,158 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
>   */
>  long prune_icache_sb(struct super_block *sb, struct shrink_control *sc)
>  {
> -       LIST_HEAD(freeable);
> +       struct inodes_to_prune lists = {
> +               .freeable = LIST_HEAD_INIT(lists.freeable),
> +               .deferred = LIST_HEAD_INIT(lists.deferred),
> +       };
>         long freed;
>
>         freed = list_lru_shrink_walk(&sb->s_inode_lru, sc,
> -                                    inode_lru_isolate, &freeable);
> -       dispose_list(&freeable);
> +                                    inode_lru_isolate, &lists);
> +       dispose_list(&lists.freeable);
> +       if (!list_empty(&lists.deferred)) {
> +               int id = get_deferred_sb_id(sb);
> +               int i, wake_count;
> +
> +               spin_lock(&deferred_reclaim.queues[id].lock);
> +               list_splice_tail(&lists.deferred,
> +                                &deferred_reclaim.queues[id].list);
> +               atomic_add(lists.deferred_count, &sb->s_deferred_reclaim_count);
> +               spin_unlock(&deferred_reclaim.queues[id].lock);
> +
> +               /* Queue works to process inodes we've added to the list */
> +               wake_count = (lists.deferred_count + INODE_RECLAIM_BATCH_SIZE)
> +                                               / INODE_RECLAIM_BATCH_SIZE;
> +               if (wake_count > deferred_reclaim.workers)
> +                       wake_count = deferred_reclaim.workers;
> +               for (i = 0; i < wake_count; i++) {
> +                       queue_work(deferred_reclaim.wq,
> +                                  &deferred_reclaim.work[id]);
> +                       id = (id + 1) % deferred_reclaim.workers;
> +               }
> +       }
>         return freed;
>  }
>
> +static void __get_inode_reclaim_batch(int *start, int end,
> +                                     struct list_head *list, int *count)
> +{
> +       int i;
> +
> +       for (i = *start; i < end; i++) {
> +               if (list_empty_careful(&deferred_reclaim.queues[i].list))
> +                       continue;
> +               spin_lock(&deferred_reclaim.queues[i].lock);
> +               while (*count < INODE_RECLAIM_BATCH_SIZE &&
> +                      !list_empty(&deferred_reclaim.queues[i].list)) {
> +                       list_move(deferred_reclaim.queues[i].list.next, list);
> +                       (*count)++;
> +               }
> +               spin_unlock(&deferred_reclaim.queues[i].lock);
> +               if (*count >= INODE_RECLAIM_BATCH_SIZE)
> +                       break;
> +       }
> +       *start = i;

To clean up __get_inode_reclaim_batch():

--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1081,15 +1081,18 @@ static void __get_inode_reclaim_batch(int *start, int end,
 	int i;
 
 	for (i = *start; i < end; i++) {
-		if (list_empty_careful(&deferred_reclaim.queues[i].list))
+		struct deferred_reclaim_queue *queue =
+				&deferred_reclaim.queues[i];
+
+		if (list_empty_careful(&queue->list))
 			continue;
-		spin_lock(&deferred_reclaim.queues[i].lock);
+		spin_lock(&queue->lock);
 		while (*count < INODE_RECLAIM_BATCH_SIZE &&
-		       !list_empty(&deferred_reclaim.queues[i].list)) {
-			list_move(deferred_reclaim.queues[i].list.next, list);
+		       !list_empty(&queue->list)) {
+			list_move(queue->list.next, list);
 			(*count)++;
 		}
-		spin_unlock(&deferred_reclaim.queues[i].lock);
+		spin_unlock(&queue->lock);
 		if (*count >= INODE_RECLAIM_BATCH_SIZE)
 			break;
 	}

On top of that, consider this optimization, but see for yourself if this is too
much:

--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1083,15 +1083,18 @@ static void __get_inode_reclaim_batch(int *start, int end,
 	for (i = *start; i < end; i++) {
 		struct deferred_reclaim_queue *queue =
 				&deferred_reclaim.queues[i];
+		struct list_head *entry, tmp;
 
 		if (list_empty_careful(&queue->list))
 			continue;
 		spin_lock(&queue->lock);
-		while (*count < INODE_RECLAIM_BATCH_SIZE &&
-		       !list_empty(&queue->list)) {
-			list_move(queue->list.next, list);
+		list_for_each(entry, &queue->list) {
+			if (*count >= INODE_RECLAIM_BATCH_SIZE)
+				break;
 			(*count)++;
 		}
+		list_cut_before(&tmp, &queue->list, entry);
+		list_splice_tail(&tmp, list);
 		spin_unlock(&queue->lock);
 		if (*count >= INODE_RECLAIM_BATCH_SIZE)
 			break;

> +}
> +
> +/* Move a batch of inodes from queued lists to our private list */
> +static int get_inode_reclaim_batch(int *id, struct list_head *list)
> +{
> +       int count = 0;
> +       int orig_id = *id;
> +
> +       __get_inode_reclaim_batch(id, deferred_reclaim.workers, list, &count);
> +       if (count >= INODE_RECLAIM_BATCH_SIZE)
> +               return count;
> +       /* Wrap around */
> +       if (orig_id > 0) {
> +               *id = 0;
> +               __get_inode_reclaim_batch(id, orig_id, list, &count);
> +       }
> +       return count;
> +}
> +
> +
> +static void inode_reclaim_deferred(struct work_struct *work)
> +{
> +       struct inode *inode;
> +       LIST_HEAD(inode_batch);
> +       /*
> +        * We start with the list corresponding to the work but rolling a dice
> +        * would work as well
> +        */
> +       int id = work - deferred_reclaim.work;
> +
> +       while (1) {
> +               if (!get_inode_reclaim_batch(&id, &inode_batch))
> +                       break;
> +               while (!list_empty(&inode_batch)) {
> +                       struct super_block *sb;
> +
> +                       /*
> +                        * inode_batch list is private and I_FREEING flags
> +                        * protect us from anybody else trying to remove the
> +                        * inode from the LRU list. No locking needed.
> +                        */
> +                       inode = list_first_entry(&inode_batch, struct inode,
> +                                                i_lru);
> +                       list_del_init(&inode->i_lru);
> +                       sb = inode->i_sb;
> +                       evict(inode);
> +                       /*
> +                        * The elevated s_deferred_reclaim_count keeps sb alive
> +                        * until we drop it
> +                        */
> +                       if (atomic_dec_and_test(&sb->s_deferred_reclaim_count))
> +                               wake_up_var(&sb->s_deferred_reclaim_count);
> +                       cond_resched();
> +               }
> +       }
> +}
> +
> +/* Maximum number of inode reclaim workers */
> +#define MAX_RECLAIM_WORKERS 16
> +
> +static void __init deferred_reclaim_init(void)
> +{
> +       int workers = MAX_RECLAIM_WORKERS;
> +       int i;
> +
> +       /* Scale down the number of workers for small systems */
> +       if (workers > num_possible_cpus())
> +               workers = num_possible_cpus();
> +
> +       deferred_reclaim.workers = workers;
> +       deferred_reclaim.work = kmalloc_objs(struct work_struct, workers);
> +       deferred_reclaim.queues =
> +                       kmalloc_objs(struct deferred_reclaim_queue, workers);
> +       if (!deferred_reclaim.work || !deferred_reclaim.queues)
> +               panic("Failed to allocate deferred inode queues");
> +
> +       deferred_reclaim.wq = alloc_workqueue("deferred-inodegc",
> +                       WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_UNBOUND,
> +                       workers);
> +       if (!deferred_reclaim.wq)
> +               panic("Failed to allocate deferred inode reclaim workqueue");
> +
> +       for (i = 0; i < workers; i++) {
> +               INIT_WORK(&deferred_reclaim.work[i], inode_reclaim_deferred);
> +               spin_lock_init(&deferred_reclaim.queues[i].lock);
> +               INIT_LIST_HEAD(&deferred_reclaim.queues[i].list);
> +       }
> +}
> +
> +void mark_inode_reclaim_deferred(struct inode *inode)
> +{
> +       if (inode_state_read_once(inode) & I_DEFER_RECLAIM)
> +               return;
> +
> +       spin_lock(&inode->i_lock);
> +       inode_state_set(inode, I_DEFER_RECLAIM);
> +       spin_unlock(&inode->i_lock);
> +}
> +EXPORT_SYMBOL_GPL(mark_inode_reclaim_deferred);
> +
>  static void __wait_on_freeing_inode(struct inode *inode, bool hash_locked, bool rcu_locked);
>  static bool igrab_from_hash(struct inode *inode);
>
> @@ -2659,6 +2841,9 @@ void __init inode_init(void)
>                                          SLAB_ACCOUNT),
>                                          init_once);
>
> +       /* Deferred inode reclaim infrastructure */
> +       deferred_reclaim_init();
> +
>         /* Hash may have been set up in inode_init_early */
>         if (!hashdist)
>                 return;
> diff --git a/fs/super.c b/fs/super.c
> index 05e443173038..0852a40b2635 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -600,6 +600,8 @@ void deactivate_locked_super(struct super_block *s)
>         struct file_system_type *fs = s->s_type;
>         if (atomic_dec_and_test(&s->s_active)) {
>                 shrinker_free(s->s_shrink);
> +               wait_var_event(&s->s_deferred_reclaim_count,
> +                              !atomic_read(&s->s_deferred_reclaim_count));
>                 fs->kill_sb(s);
>
>                 kill_super_notify(s);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index f9d1e05e8ae6..a289402563f8 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -741,6 +741,7 @@ enum inode_state_flags_enum {
>         I_SYNC_QUEUED           = (1U << 17),
>         I_PINNING_NETFS_WB      = (1U << 18),
>         I_METADATA_WRITEBACK    = (1U << 19),
> +       I_DEFER_RECLAIM         = (1U << 20),
>  };
>
>  #define I_DIRTY_INODE (I_DIRTY_SYNC | I_DIRTY_DATASYNC)
> @@ -2218,6 +2219,8 @@ static inline void set_inode_metadata_writeback(struct inode *inode)
>         spin_unlock(&inode->i_lock);
>  }
>
> +void mark_inode_reclaim_deferred(struct inode *inode);
> +
>  /*
>   * returns the refcount on the inode. it can change arbitrarily.
>   */
> diff --git a/include/linux/fs/super_types.h b/include/linux/fs/super_types.h
> index ecd96aeb1cee..a41bd57fc2e6 100644
> --- a/include/linux/fs/super_types.h
> +++ b/include/linux/fs/super_types.h
> @@ -232,6 +232,9 @@ struct super_block {
>
>         struct shrinker                         *s_shrink;      /* per-sb shrinker handle */
>
> +       /* Number of inodes queued for deferred reclaim */
> +       atomic_t                                s_deferred_reclaim_count;
> +
>         /* Number of inodes with nlink == 0 but still referenced */
>         atomic_long_t                           s_remove_count;
>
> diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
> index 13ee076ccd16..4a9cfe458820 100644
> --- a/include/trace/events/writeback.h
> +++ b/include/trace/events/writeback.h
> @@ -28,7 +28,8 @@
>                 {I_DONTCACHE,           "I_DONTCACHE"},         \
>                 {I_SYNC_QUEUED,         "I_SYNC_QUEUED"},       \
>                 {I_PINNING_NETFS_WB,    "I_PINNING_NETFS_WB"},  \
> -               {I_LRU_ISOLATING,       "I_LRU_ISOLATING"}      \
> +               {I_LRU_ISOLATING,       "I_LRU_ISOLATING"},     \
> +               {I_DEFER_RECLAIM,       "I_DEFER_RECLAIM"}      \
>         )
>
>  /* enums need to be exported to user space */
> --
> 2.51.0
>
>

Thanks,
Andreas


