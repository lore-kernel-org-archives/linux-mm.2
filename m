Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36F6CCD4F35
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 11:16:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E0AE6B008A; Wed, 13 May 2026 07:16:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 991276B008C; Wed, 13 May 2026 07:16:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85A936B0092; Wed, 13 May 2026 07:16:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 75AA86B008A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:16:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 280701A0892
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:16:22 +0000 (UTC)
X-FDA: 84762143004.26.E0DD4AF
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id DE23380002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:16:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JfFhp2Fq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6M7yswMb;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JfFhp2Fq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6M7yswMb;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778670980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lycp/moaJ9lpEBSEImhT67gHpALm4OfaRBlzDnz4+Qs=;
	b=TDHlY/cgPu934+bhvMXzYaG5KJfFfgFf9YSzNQEQEsHI8DYcp5Rgj3nT0saG4kHJ/cpP8/
	QpHL3u9L7wwSQtEDvRG/CPXbCQ5mjXTxmSt6hOZNEMBGc8qzk0EEEkWp6vsUvEH0BImHJ+
	Mq1DR9knvzZvWc6yKop2jntQDIyuRSk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JfFhp2Fq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6M7yswMb;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JfFhp2Fq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6M7yswMb;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778670980; a=rsa-sha256;
	cv=none;
	b=q4HhM86R3LuqIy77jG8N39W5lJORo3ANhHlt1phUERKMJ1otVd9Dlq/3K+prAcyJO6zjV4
	J08Ow3fj0M4/JftvoJgwAP2bdSH2gzdOR/jGR/XqwD7huKWosKhoKJyOKGq7OV1aXnpJM4
	jRwl4h3ABjzbsNRhYkb7i2LkSOw4Lv8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5A2A675AC1;
	Wed, 13 May 2026 11:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778670978; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lycp/moaJ9lpEBSEImhT67gHpALm4OfaRBlzDnz4+Qs=;
	b=JfFhp2FqnQWMLpq+wOOMAeynqHh69MjGq94AvNQ4gF9ZkpdrgnnMz3rryzu4VfN6gHhgS6
	F0kKfbCzXjIT+L4J33x5U/h4i4tuo7UZy6OswUR/UnRFBFdbpZXu9MVo2/FnU/5wUSKUiH
	bkg77cXivpw3f4jlpLMmQ/0dWQsMt0Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778670978;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lycp/moaJ9lpEBSEImhT67gHpALm4OfaRBlzDnz4+Qs=;
	b=6M7yswMbrzGxme0KrgazzRA+lz84tIGwq11vrtljhnF9y4ukubt4ZuxtSCwEhpJKDUXMZ2
	7bBy2ydRIP+tFhBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778670978; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lycp/moaJ9lpEBSEImhT67gHpALm4OfaRBlzDnz4+Qs=;
	b=JfFhp2FqnQWMLpq+wOOMAeynqHh69MjGq94AvNQ4gF9ZkpdrgnnMz3rryzu4VfN6gHhgS6
	F0kKfbCzXjIT+L4J33x5U/h4i4tuo7UZy6OswUR/UnRFBFdbpZXu9MVo2/FnU/5wUSKUiH
	bkg77cXivpw3f4jlpLMmQ/0dWQsMt0Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778670978;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lycp/moaJ9lpEBSEImhT67gHpALm4OfaRBlzDnz4+Qs=;
	b=6M7yswMbrzGxme0KrgazzRA+lz84tIGwq11vrtljhnF9y4ukubt4ZuxtSCwEhpJKDUXMZ2
	7bBy2ydRIP+tFhBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4F28E593A9;
	Wed, 13 May 2026 11:16:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fGVKE4JdBGp5VgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 13 May 2026 11:16:18 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E3A88A0800; Wed, 13 May 2026 13:16:13 +0200 (CEST)
Date: Wed, 13 May 2026 13:16:13 +0200
From: Jan Kara <jack@suse.cz>
To: Frederick Mayle <fmayle@google.com>
Cc: android-mm@google.com, kernel-team@android.com, 
	Kalesh Singh <kaleshsingh@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/readahead: no PG_readahead on EOF
Message-ID: <l237hfckt6dyz2zpsaeewyisqh2rpbgkdciucbfvlpmjkls3lt@2tazs6us2dak>
References: <20260508181237.670645-1-fmayle@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508181237.670645-1-fmayle@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DE23380002
X-Stat-Signature: j9f77pprs4jne5w5gb9dzat5s6o38ofj
X-HE-Tag: 1778670979-780169
X-HE-Meta: U2FsdGVkX1/a8eO0l3Zr7fMMRmM9ZHwJGHay0NUefuw8nOXD1t+qZH4nfHyn+cFtQ96sSpeiJrDhcQrT9DjdUxVxk8i6wPqdBzwiwWCrjMWh3r+uBcjpZYSwkYMBeHsg+UfQOQcPUhTi7qtzCHNEIBFlN6VG4E23yEGiU0Sl5n7F4rqUS+zQ7B/mizyL+eKFhwsVACLuUQNCn8Rvd9HKOX24UJfrbANGl097WPxu8VDZce4uXwUrje9wCCIsnJ1bio16hkvHAmjoiHlqy1cnCabGoEYG10QclTYwivm0mScm9a0w4cJh0Ipr6juBQl2b6gqdk5o7X1sPsQvXv962e+Qtrd2ZQ4Xr6yegeebKa88Ll+C0hZhhjw/kIO1JLUreMSjCyht6bA8X6fR4+PVLH/U/QQRZGK3BjblmXYkdr2DQj64l1iKHH/53v4J3WC+Tu6BTLq5wu1Dru4fV+0O7YHlimTUGog/OOJw7FxhjZiohiI8MQLW5X+jvQX29QeXBzvOZ5DeTkfDKWA6TmoxTYLttIzatWLjy48U1uPtXVYBiXHnKvttHfuXTFiFIq1yp8AEwD6uaGyQhxP1CK8pmxnBnjudTK6KJzpPD/NXDbkbpQ1Dc3g04uvO+hM2Swd7Ufq5DzUrkVnlYnwu41b08mSKLZF0ev32PTive0kR0oV/IutOqu0SUYTORV34nRG1xuwphROPaoiQZGV/raDzDuCji8mxmWe0CqNtnDz9iJcA3p/HzRZMrtxxdQF9bd7fQ9ZubLauTqPh/DYq07AykByPysFQYbprRSZ1tB/ZVj+PLcOghf5uI+KIgx07L4TjJc84hkE7chUAEjU58l7E/iDEWaV+awiUtCwa6NMYVlyrclXMN0HTQJqWIfdagc45sm3twCF0uRA9ybCMjdzerJNR2NK2vJ2JhbmtpstNIbIS3kgIwv2a/PjOKS69Z2t+tIOQHUoiLkVmu4+CaM6z
 FOzScWxt
 WaRPGi4XgXLgUZ2wFKdGwABDlKv6ZJbUWANmm26tlWWn/fcScW2RkSW3t/o7R8BvAkr1vTQl0cb5Fvgr7cMsvvY/wjh4LMc/LwITSN2ee3wyrP8L3diDbosvljQOy1cu4EQpq3hLk1+hefAJH//VUxae/58qX/+74Mi23hZiYIDK/YeZ0dVKTEEuFpWlk3EkQ31EZiL+Yx9li2VMkxDwHuCJVh0001mupCuzTSBEs4/9ED5089aeotUa+ApvPZ3A/UgErAHZSRSsqrdPWu/MnYTROQU2q53GL8MB5iCbM+Be/7xfnKNO4wn0asGII3wdNHkSaKw2eR9cyHY3FXue99bs20QhFartcfSGIe+EksYWQzUKahU9Liuao8zCai8XM5YNt11uf86w8J++E7fhhiUnTMQIS8hGMrOSOLiuhbQuedV9lbdl4q6IedYjPRfHZ1v+gWBSnv97TDL0FmDc50JsVXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 08-05-26 11:12:31, Frederick Mayle wrote:
> When readahead pulls in all the remaining pages for a file, setting the
> readahead bit is counter productive. The async readahead it would
> trigger would almost certainly be a no-op. Additionally, for mmap'd file
> IO, the readahead bit limits the fault around [0], causing an extra
> minor fault when the page is accessed.
> 
> This was discovered when looking at /sys/kernel/tracing/events/readahead
> traces for a simple program. With the patch applied, fewer
> page_cache_ra_unbounded calls are observed.
> 
> [1] do_fault_around calls filemap_map_pages, which finds eligible pages
>     by calling next_uptodate_folio [2]. next_uptodate_folio skips pages
>     with PG_readahead set [3].
> 
> Link: https://github.com/torvalds/linux/blob/v7.0/mm/filemap.c#L3921-L3939 [2]
> Link: https://github.com/torvalds/linux/blob/v7.0/mm/filemap.c#L3721-L3722 [3]
> Cc: Kalesh Singh <kaleshsingh@google.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Frederick Mayle <fmayle@google.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

The issue Sashiko pointed out is real but preexisting issue which isn't
really related to your changes and your patch doesn't make it worse so I'd
just ignore it.

								Honza

> ---
>  mm/readahead.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/readahead.c b/mm/readahead.c
> index 8c12b63ccd4a..784a3bde82be 100644
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -329,8 +329,11 @@ static void do_page_cache_ra(struct readahead_control *ractl,
>  	if (index > end_index)
>  		return;
>  	/* Don't read past the page containing the last byte of the file */
> -	if (nr_to_read > end_index - index)
> +	if (nr_to_read > end_index - index) {
>  		nr_to_read = end_index - index + 1;
> +		/* We've reached the end, so don't set a readahead marker. */
> +		lookahead_size = 0;
> +	}
>  
>  	filemap_invalidate_lock_shared(mapping);
>  	page_cache_ra_unbounded(ractl, nr_to_read, lookahead_size);
> @@ -474,7 +477,7 @@ void page_cache_ra_order(struct readahead_control *ractl,
>  	pgoff_t index = start;
>  	unsigned int min_order = mapping_min_folio_order(mapping);
>  	pgoff_t limit;
> -	pgoff_t mark = index + ra->size - ra->async_size;
> +	pgoff_t mark;
>  	unsigned int nofs;
>  	int err = 0;
>  	gfp_t gfp = readahead_gfp_mask(mapping);
> @@ -488,7 +491,13 @@ void page_cache_ra_order(struct readahead_control *ractl,
>  
>  	limit = (i_size_read(mapping->host) - 1) >> PAGE_SHIFT;
>  	limit = min(limit, ractl->_max_index);
> -	limit = min(limit, index + ra->size - 1);
> +	if (limit > index + ra->size - 1) {
> +		limit = index + ra->size - 1;
> +		mark = index + ra->size - ra->async_size;
> +	} else {
> +		/* We've reached the end, so don't set a readahead marker. */
> +		mark = ULONG_MAX;
> +	}
>  
>  	new_order = min(mapping_max_folio_order(mapping), new_order);
>  	new_order = min_t(unsigned int, new_order, ilog2(ra->size));
> 
> base-commit: 2d565cbaafd43b10b75da56e43e5db9852a56afd
> -- 
> 2.54.0.563.g4f69b47b94-goog
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

