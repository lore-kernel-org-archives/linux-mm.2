Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBDE3C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 21:20:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 666FC6B0005; Sat, 11 Jul 2026 17:20:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 617F86B0088; Sat, 11 Jul 2026 17:20:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52FD06B008A; Sat, 11 Jul 2026 17:20:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2821A6B0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 17:20:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A56761C8C8A
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 21:20:53 +0000 (UTC)
X-FDA: 84977765586.05.9B85F0D
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.186])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2429140007
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 21:20:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=VDU6jWu4;
	spf=pass (imf07.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.186 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783804851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xeac5EVu5qi4Q79F2YWykkgRu5GzQIzzrlLxl753Kqo=;
	b=j59nZrPSTWkbwdOqAfLHT5p2ab14GV4tHz9qhEGKaGqWB1k1v501K1DC0i/8UpBfK+b9Ok
	pNOHL/xGE98EM10izSN0OsUdolBB8jD2/wMTehpumnezgSRGQNKQJHephasD0zfkWFOCyU
	4sACPkEfP0RYl51jAZXLiTmgW9q2GKI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=VDU6jWu4;
	spf=pass (imf07.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.186 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783804851;
	b=MwG5MsNnLElg6NRpdRSY8P3f1nyf+p3yg3grBJ//5NMcDOBJEVXnMwZkhkR/U0yceKYmFK
	t3pINR3WvM8KTT3Bu1o3uphXNqMLPuklA5TU5AjwhnUNG9IMdMITRIUn8udLTjR/FlAvIi
	wJxoYkt+wK9XUty7eBRLvJdVIjDr/zU=
X-KPN-MessageId: 6305fb61-7d6e-11f1-bfba-00505699b430
Received: from smtp.kpnmail.nl (unknown [10.31.155.7])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 6305fb61-7d6e-11f1-bfba-00505699b430;
	Sat, 11 Jul 2026 23:20:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:message-id:subject:to:from:date;
	bh=Xeac5EVu5qi4Q79F2YWykkgRu5GzQIzzrlLxl753Kqo=;
	b=VDU6jWu4Dk13vxkwScWOqAMptQTAYn4MDczcNvry5dYPEMhKs7CaqxMCr3bqO9wnBBkpNFFTCdMCl
	 c9HwLTKtlkxUwBd+xpE3eMzOQArPPm4tshM6ohEoZaywWPGWOc/B1rlME4kjSa1UN03C5m0OGtv6kY
	 ZkPDhNu6rkVowdIki6LPgqXy5nJxb/X5cEOlmZy0AHTzpep5d7Ti8UkuvqRXhQtJZ4AeWs5lJ3y083
	 MBus7KW5eRsWuEbKiNTbnNYXzY57LmT7orM93oa8ycWy5B9J1V9BvqAatHrpPs5+RMkuqMxPrJ8hC6
	 N15vHFDgrQqpLCoSEc4xhHQ017KlrmA==
X-KPN-MID: 33|MZHY6HNOvUJdXnLQtlvnu7ROFiCu5tboXf/em/FrjBzcWfhG3bSuw4SBdSdxYaT
 et/JDX/ViAKOarnHn1zF/OdiR8GsBWmM9i6qQ8uEF8UA=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|pFSCXz8ciqPxmrlndYSJ+cOubXeU6shJNF6QminkDJUrNcnWOiMpjQS2XAXbB5t
 hb0Rh5zz+S25nGxLpWj7XbQ==
X-Originating-IP: 178.226.150.234
Received: from localhost (unknown [178.226.150.234])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 62d9bf51-7d6e-11f1-807d-005056998788;
	Sat, 11 Jul 2026 23:20:48 +0200 (CEST)
Date: Sat, 11 Jul 2026 23:20:50 +0200
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
Subject: Re: [PATCH v3 04/24] binfmt_misc: convert entry list to an hlist
Message-ID: <alKzLtO46jszVrfy@lt-jori.localdomain>
Mail-Followup-To: Jori Koolstra <jkoolstra@xs4all.nl>, 
	Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
 <20260710-work-binfmt_misc-locking-v3-4-a162f7cb58d6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-4-a162f7cb58d6@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2429140007
X-Stat-Signature: i81zmtgeanfyaysegis4igq6m7zyi47a
X-HE-Tag: 1783804850-780936
X-HE-Meta: U2FsdGVkX1/ej1M9BN6xm8DCvr28cBT8QFgkgLSoURXNzMEHE2M7SAWlF8p3pBQdF7n6a5X1Zpczvdqs3deYPKIZQahKxtzBWv20qhFN2FHUCYvRxGB8frDc/RgoDSMe6Qt0V+jVHrgDSp9Vy79gJBzt9HB8d1wVFx1O809sJbpNv4VYxrlzuMDD+mrlukOElZSaNE+f5IVTN3rgyCrEthgSE+2dGyOMQyvvDSzFx8vg3LJnld1Qd+J3ZU2shx9LlyDY6Stpl+OSK98mjR+u+uD1AEs0cftanYUvTITgIGb6wjaHkWymIMZyacwiL/7InVNDI9MEc8ZUbJ69a9tecFfzg4ZHuOif6f5j8YH5P876Fep86G2OB9BQO8FRL4CK2ryySkfT9o9vP5MW9BSKhQsUz0EZE9xphM2G4KVFHKEh9So1ilx/7ubOqAw0nSKDtXcgwId/2oiYYJ36Gs10nVYXoONAAwdebzXMFXkNy+vVvmFzUhgXp6yIEDIODUHhPqpqDe4hhcqEPTPzh1YTnGYM30yG/k/wBrm45BR++NuocdpkgToGYYNecuB/jtYS3/wRHT6s+lQDPXtDHxoVyhl1U8cF60zdonfjbqDwT3DLgtnyKBCrsL+raox7TdOT5GBT85C5SvYU7UOcREJN05zmNzQpnNlBwglKKY1mbr+uqT4DinPj9nvqTDhUj3iwz8N8P1Bw5s4+br9+EU0tkTdavLTcBF3RxJ5ECLtknIXTV+cwQdtupt531ke663kp/IFeEC2ewDbjUKKfFB2S7jwCmW09iesrNCvKRSUntLPkMTFS+t3c9Ktwh5X7IWUYsDlab5eoyoTa+zJPy32halhycE1GSQ81exXcSy+2bZZ5oKRHqATc3Wih8RYHhhKQgRBGGDDkkKxhNriu5RjcR7GZnZm+LuvMxypvIPkvr32Ho81KWuaKVk8pJ6uEixQcp3yr/LcYvVdCBOyfWav
 Zo2QtjWW
 lgE9e3H9N75zpO3JUJuzKGZMzc0+fbuR3Pey4WD9mJEL83kZ6RAoPwRMmCVb++xb7lnMcoGA2EGQpNqaU2JsJRIRDUhtjZZ1Iueu+VGpYTFmo6mURUGB7cR7vpYihV+IHYMPrASVWqrwvYOCVlrq2GHWHNLtK+TbdVWY7ac1KSXlbN647bB+lTWkN6Gmlx1PmQxDWvKmaIlbUwTLn08pP9y9jDWCux/QLchJVdiDwqL+470vmiNbVebMUYrTkaFMoeeKPCJB1JfMKpSxKM4Q9I1jBcVle5a5y0GzAxYFqnc4zVzmYcpUhA+u9I3FPW0nvXKpIBbyp7U67sqa3f+n40mbadBjWLEC3lETt/6D72DNM6KKp7YeeoWUCKWlJewMthoWhh2oT+DfvWKXSem6g7EyK8XZoe1EZA8YV1KnBotrf90+lQFsTmXDQ56afhWEZ6USqT0Qd79mOFZOXR8kPu5STMK6eghPhhN/myxGjJzaCEJH8L14TF67765GlCMNG1fACf3A2cs81r3AgodYfhO/2moRibztqLy0DbUcU5Uuw6O+s5GcvRtphlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 11:33:05AM +0200, Christian Brauner wrote:
> The upcoming conversion of the handler lookup to RCU walks cannot use
> list_del_init(): reinitializing the forward pointer of a removed entry
> would make a concurrent lockless walker standing on that entry loop
> back onto it indefinitely. The removal paths do rely on
> reinitialization though because bm_{entry,status}_write() and
> bm_evict_inode() need to detect whether an entry has already been
> unlinked.
> 
> hlists support exactly this pattern: hlist_del_init_rcu() keeps the
> forward pointer of the removed entry intact for concurrent walkers and
> only zeroes ->pprev with hlist_unhashed() serving as the linked test.
> 
> Convert the entry list to an hlist now while keeping the rwlock so the
> subsequent RCU conversion is a pure locking change. hlist_add_head()
> inserts at the head just as list_add() did so lookup precedence
> between registered handlers is unchanged.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/binfmt_misc.c        | 25 +++++++++++++------------
>  include/linux/binfmts.h |  2 +-
>  kernel/user.c           |  2 +-
>  3 files changed, 15 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index b7664d90eb8f..89da2d4e7f91 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -48,7 +48,7 @@ enum {Enabled, Magic};
>  #define MISC_FMT_OPEN_FILE (1UL << 28)
>  
>  typedef struct {
> -	struct list_head list;
> +	struct hlist_node node;
>  	unsigned long flags;		/* type, status, etc. */
>  	int offset;			/* offset of magic */
>  	int size;			/* size of magic/mask */
> @@ -95,7 +95,7 @@ static Node *search_binfmt_handler(struct binfmt_misc *misc,
>  	Node *e;
>  
>  	/* Walk all the registered handlers. */
> -	list_for_each_entry(e, &misc->entries, list) {
> +	hlist_for_each_entry(e, &misc->entries, node) {
>  		char *s;
>  		int j;
>  
> @@ -666,8 +666,8 @@ static struct binfmt_misc *i_binfmt_misc(struct inode *inode)
>   *
>   * If the ->evict call was not caused by a super block shutdown but by a write
>   * to remove the entry or all entries via bm_{entry,status}_write() the entry
> - * will have already been removed from the list. We keep the list_empty() check
> - * to make that explicit.
> + * will have already been removed from the list. We keep the hlist_unhashed()
> + * check to make that explicit.
>  */
>  static void bm_evict_inode(struct inode *inode)
>  {
> @@ -680,8 +680,8 @@ static void bm_evict_inode(struct inode *inode)
>  
>  		misc = i_binfmt_misc(inode);
>  		write_lock(&misc->entries_lock);
> -		if (!list_empty(&e->list))
> -			list_del_init(&e->list);
> +		if (!hlist_unhashed(&e->node))
> +			hlist_del_init(&e->node);
>  		write_unlock(&misc->entries_lock);
>  		put_binfmt_handler(e);
>  	}
> @@ -702,7 +702,7 @@ static void bm_evict_inode(struct inode *inode)
>  static void remove_binfmt_handler(struct binfmt_misc *misc, Node *e)
>  {
>  	write_lock(&misc->entries_lock);
> -	list_del_init(&e->list);
> +	hlist_del_init(&e->node);
>  	write_unlock(&misc->entries_lock);
>  	locked_recursive_removal(e->dentry, NULL);
>  }
> @@ -758,7 +758,7 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
>  		 * read-only. So we only need to take the write lock when we
>  		 * actually remove the entry from the list.
>  		 */
> -		if (!list_empty(&e->list))
> +		if (!hlist_unhashed(&e->node))
>  			remove_binfmt_handler(i_binfmt_misc(inode), e);
>  
>  		inode_unlock(inode);
> @@ -802,7 +802,7 @@ static int add_entry(Node *e, struct super_block *sb)
>  	d_make_persistent(dentry, inode);
>  	misc = i_binfmt_misc(inode);
>  	write_lock(&misc->entries_lock);
> -	list_add(&e->list, &misc->entries);
> +	hlist_add_head(&e->node, &misc->entries);
>  	write_unlock(&misc->entries_lock);
>  	simple_done_creating(dentry);
>  	return 0;
> @@ -875,8 +875,9 @@ static ssize_t bm_status_write(struct file *file, const char __user *buffer,
>  {
>  	struct binfmt_misc *misc;
>  	int res = parse_command(buffer, count);
> -	Node *e, *next;
> +	struct hlist_node *next;
>  	struct inode *inode;
> +	Node *e;
>  
>  	misc = i_binfmt_misc(file_inode(file));
>  	switch (res) {
> @@ -902,7 +903,7 @@ static ssize_t bm_status_write(struct file *file, const char __user *buffer,
>  		 * read-only. So we only need to take the write lock when we
>  		 * actually remove the entry from the list.
>  		 */
> -		list_for_each_entry_safe(e, next, &misc->entries, list)
> +		hlist_for_each_entry_safe(e, next, &misc->entries, node)
>  			remove_binfmt_handler(misc, e);
>  
>  		inode_unlock(inode);
> @@ -977,7 +978,7 @@ static int bm_fill_super(struct super_block *sb, struct fs_context *fc)
>  		if (!misc)
>  			return -ENOMEM;
>  
> -		INIT_LIST_HEAD(&misc->entries);
> +		INIT_HLIST_HEAD(&misc->entries);
>  		rwlock_init(&misc->entries_lock);
>  
>  		/* Pairs with smp_load_acquire() in load_binfmt_misc(). */
> diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
> index 2c77e383e737..071da63f2b48 100644
> --- a/include/linux/binfmts.h
> +++ b/include/linux/binfmts.h
> @@ -101,7 +101,7 @@ struct linux_binfmt {
>  
>  #if IS_ENABLED(CONFIG_BINFMT_MISC)
>  struct binfmt_misc {
> -	struct list_head entries;
> +	struct hlist_head entries;
>  	rwlock_t entries_lock;
>  	bool enabled;
>  } __randomize_layout;
> diff --git a/kernel/user.c b/kernel/user.c
> index 7aef4e679a6a..c6a2bfb4d918 100644
> --- a/kernel/user.c
> +++ b/kernel/user.c
> @@ -23,7 +23,7 @@
>  
>  #if IS_ENABLED(CONFIG_BINFMT_MISC)
>  struct binfmt_misc init_binfmt_misc = {
> -	.entries = LIST_HEAD_INIT(init_binfmt_misc.entries),
> +	.entries = HLIST_HEAD_INIT,
>  	.enabled = true,
>  	.entries_lock = __RW_LOCK_UNLOCKED(init_binfmt_misc.entries_lock),
>  };
> 
> -- 
> 2.53.0
> 

I'll just go from this series again:

Reviewed-by: Jori Koolstra <jkoolstra@xs4all.nl>

