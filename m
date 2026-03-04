Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23C2AEF8FE6
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 13:38:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8408D6B008A; Wed,  4 Mar 2026 08:38:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CDA06B0092; Wed,  4 Mar 2026 08:38:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ECDC6B0096; Wed,  4 Mar 2026 08:38:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 530126B008A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:38:56 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 014111405C0
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 13:38:55 +0000 (UTC)
X-FDA: 84508486272.28.CF14F9B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id DF12410000A;
	Wed,  4 Mar 2026 13:38:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aOmZC+qm;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772631534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UdKI9s6+5W1BrJUD122GCcYkhCa0pFKHAdJxdPpmiQI=;
	b=aOV4F0fWjNANjhKQDpFMPTp0GElNJOOB44AXEPPdT1xOd4WBSuEZOpWTlk8oNBRvQ/Eg0v
	VU98X96Mo/JdDm4AQ+TIUEvnQOIE685A64VMiVtQs1I3w0O6v3jzkBu3ePC1TWRndl3NBb
	05eSXYbfruFif1QQHq3IcnxSVIBJhP4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aOmZC+qm;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772631534; a=rsa-sha256;
	cv=none;
	b=hCrJJkJaW2dJHok4Ez/kWlNTgSG9aF4N+pP6KXas6UM+Tz+/fKo/FFmNoljN7Ls+lG8K2l
	U1bdUVzh14QLtARxoyaZOHTrel01euzH0RBKb5FGXe4zf53VkBiRzp/t6N+pEiqLu+Co1t
	W2+j8SisuumscDtfnYwCY39gxyJZ+YM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 29E55600AD;
	Wed,  4 Mar 2026 13:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609B9C19423;
	Wed,  4 Mar 2026 13:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772631532;
	bh=9Gu41Q7tWvFsmLiy2GzG+FeazMjJOugDDDVf94ibiOs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aOmZC+qmGcMNUWoK1VMUGr6qSifG9f+/P/l07kDDW+5tFJVzCIb5FjTTwHh7tRNb8
	 MmdTjNQI3NcWEDgEh2opMdW5fc+YvW1uSibKvrtH+1rSxYMX19tqC95uPTFVwxno2C
	 YX/K4cLc5NCZpey966c88ikl9JrXUCb6D9MAIiITidXt8NKo/I87KSVDp4bIlwpeE8
	 wKgrtHScCsZpt//F3pLzblKhRQX+Tx0rVHfhxOz5l5N0eNIEZ/Obj4g31eDmtAWdS1
	 pBVsn8rCgw5ArWEAjz2DV1UNSPfHtuPMx5G6bEZssIyJRkZ3WFDmA3b2gmDtDfHJU3
	 F9S64NMbnc9kw==
Date: Wed, 4 Mar 2026 14:38:47 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 16/32] fs: Fold fsync_buffers_list() into
 sync_mapping_buffers()
Message-ID: <20260304-bildmaterial-deckname-1995a115de52@brauner>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-48-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260303103406.4355-48-jack@suse.cz>
X-Stat-Signature: 69r8ukds1w7thh8sbnh3o4b6xdquzoeq
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: DF12410000A
X-HE-Tag: 1772631533-364072
X-HE-Meta: U2FsdGVkX18YmfjTc6tHKCpM65NKNOm7e/UDnTxOAeRJ3EX1rqsaPo5Bc9oONP4krB9sKCiHulnp8UFus4pxGkd3MmlOkicu5n7X/gvJD//1X1qqpkbp3NUDImobteG7KCYoWcT5PWztbBW9LMwkN3S2y2bgpkBeULeWxKWMNeSzU68e/yOtOsBeR4COnRWMFzpSQNUa3zZ8a7Ejky9F+bq3LXNRf0uK/pg//Zo2FWWE9aWiXTW0CllSAQFt98Jlt15hssxoQWSGlGBYd2uFsn56x+AAumpMOX/mxkbyOvmYiAMOqlRK7xUq5wqKXejOLnBBI7zDav0TUkaOJ/GU6HBbNZqa6fLpHj7cM1DFn8LdQ+ZFFAtj+TmwVi7EIUVlK01U2veFb/VDvX0hW0XFcNi+KQL10LCQmXXs85KSD+pqC5dJHdNKUYI6mLmmMd/zWF4gnDgZPKUVlHLTcXjG30iGx25+9v78hM2sUq7GfkPCiJ9SL6GiaDto0MtXF9owy9KJnqUesyilE0yj0dDSTWGOhQAK99rfUiPMFO6g4qGhRZMsT8L9bhpHBY3RuT3/veNtOdtCtWHJjb6nKz+95ONMd3if1gCl5Vo0LceVgQ+TkcG1LG0LhqwBwgciCoZP8krbOW9E0S+8D1e61N65RbHITct8mzlyGrcsa4dobWNB/1KJMsJBRYe5g8ydSRikE7PWp6RHocMLInMEF3yf9XoZTdoLtAPxwUE8LCfR4EtsfMQ/AmBivGdm+Bhr2uzmczrc/q1bLqEHN2y+AvjAzAeHLKCbaOvIBqBJ6nVaIimaJ5vHg2jKSARpIxN4zFvGzJkJna7KERZ5PnwBJHYNHsPW2d6LSM4XvdgPRdoLMgz9uPL7Pe6ma/RJ8KEIBxEkzxPMYOrt0Lg6xHluieAr4sTG7XJWw8EtbkgpJN9gGF7l1U8h2nKXimuchSksORaeW3Dq2DXn82Sna3mfoL1
 omsOhhTo
 Nfyq13jKo+u2YV6xnZRfLGDOIgn3bmDvj1oY9PEi9ZxqqnpanfDEU490nEaiEFdQNcs+odpe60SsNperdZTxjr93Q1W5Taj6t+ETl0sO9C6dEWUx1no9eiDaHQTxX21qzQNK38bMQ7+3LDDZf7xp+Zg760jEGsrc5FAEn6YbeXMGo7NlFzXzq1hrLeT8xDCvy2/7n2XIdFJrFwfPPZRXTay1lyHxcWePVO0OCq6B014Rm7wpXCPlslXFCwPDlK7jBoTQlWs+WCUWAbW53RDIim7WddN0faQvBTIRRihit0oJnadr7FIBCCgM9uC5no9Odm6W7OQn0CycbxyuhULOERhh+bWIn812jAkEAJ+p/DnTAYDih63j+wrHNCkSUzt5PB6PmNvImn+EaS9t+Nqh5xJnrcVh+uQGcGI+450kYbSbv/Pc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 11:34:05AM +0100, Jan Kara wrote:
> There's only single caller of fsync_buffers_list() so untangle the code
> a bit by folding fsync_buffers_list() into sync_mapping_buffers(). Also
> merge the comments and update them to reflect current state of code.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/buffer.c | 180 +++++++++++++++++++++++-----------------------------
>  1 file changed, 80 insertions(+), 100 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 1c0e7c81a38b..18012afb8289 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -54,7 +54,6 @@
>  
>  #include "internal.h"
>  
> -static int fsync_buffers_list(spinlock_t *lock, struct list_head *list);
>  static void submit_bh_wbc(blk_opf_t opf, struct buffer_head *bh,
>  			  enum rw_hint hint, struct writeback_control *wbc);
>  
> @@ -531,22 +530,96 @@ EXPORT_SYMBOL_GPL(inode_has_buffers);
>   * @mapping: the mapping which wants those buffers written
>   *
>   * Starts I/O against the buffers at mapping->i_private_list, and waits upon
> - * that I/O.
> + * that I/O. Basically, this is a convenience function for fsync().  @mapping
> + * is a file or directory which needs those buffers to be written for a
> + * successful fsync().
>   *
> - * Basically, this is a convenience function for fsync().
> - * @mapping is a file or directory which needs those buffers to be written for
> - * a successful fsync().
> + * We have conflicting pressures: we want to make sure that all
> + * initially dirty buffers get waited on, but that any subsequently
> + * dirtied buffers don't.  After all, we don't want fsync to last
> + * forever if somebody is actively writing to the file.
> + *
> + * Do this in two main stages: first we copy dirty buffers to a
> + * temporary inode list, queueing the writes as we go. Then we clean
> + * up, waiting for those writes to complete. mark_buffer_dirty_inode()
> + * doesn't touch b_assoc_buffers list if b_assoc_map is not NULL so we
> + * are sure the buffer stays on our list until IO completes (at which point
> + * it can be reaped).
>   */
>  int sync_mapping_buffers(struct address_space *mapping)
>  {
>  	struct address_space *buffer_mapping =
>  				mapping->host->i_sb->s_bdev->bd_mapping;
> +	struct buffer_head *bh;
> +	int err = 0;
> +	struct blk_plug plug;
> +	LIST_HEAD(tmp);
>  
>  	if (list_empty(&mapping->i_private_list))
>  		return 0;
>  
> -	return fsync_buffers_list(&buffer_mapping->i_private_lock,
> -					&mapping->i_private_list);
> +	blk_start_plug(&plug);
> +
> +	spin_lock(&buffer_mapping->i_private_lock);
> +	while (!list_empty(&mapping->i_private_list)) {
> +		bh = BH_ENTRY(list->next);


Stray "list" reference? Shouldn't this be
BH_ENTRY(mapping->i_private_list.next)?

