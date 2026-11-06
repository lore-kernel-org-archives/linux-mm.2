Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 386D6606A32E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 14:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=FIawBo5u;
	dkim=temperror header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=GAIC8+xY;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=FIawBo5u;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=GAIC8+xY
Received: by kanga.kvack.org (Postfix)
	id 52D1D6B05BE; Fri,  6 Nov 2026 09:18:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 505CB6B05BF; Fri,  6 Nov 2026 09:18:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41B576B05C0; Fri,  6 Nov 2026 09:18:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 124936B05BE
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:18:13 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9B48540DFE
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:18:12 +0000 (UTC)
X-FDA: 85404898824.27.6D444D6
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5D81F40007
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:18:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FIawBo5u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GAIC8+xY;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FIawBo5u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GAIC8+xY;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793974690;
	b=2hnTCWml/3sKi3zb8eJIPGASVfGZ5xhJWMgN4CK2zCn641Ks16vsBNU73/ZaojocTv5Z40
	13dGAoSUtcE5B/fFnsxWhyt0qOUcFHSUr2xb6CSv4acb7cn4zINX1zlKIdgo6bVroTc7cl
	o0gD3mJ6e3bW9ffJz2RfwzROaVvp/l8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FIawBo5u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GAIC8+xY;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FIawBo5u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GAIC8+xY;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793974690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DbXOMRc+RxyXDwhPgVxgq6OSlAD0HlpBTR9dAYmXezE=;
	b=Mu4YtsiCJRnHhPneQx6tHqyAe5urm+RoJhNU0A1UnhS6I35GoKfioMc+9DLVHa0NoIias9
	WeKkyhRaBp+PPfn0oVRiba/myt3JdVf9y5+TDZkuVdZa9nkYYuqY7eT6M+SWFCE+2tYTIw
	qHRHwL5sc7ZzClmyu6GLii9fHCg1mmQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1D076221AB;
	Fri,  6 Nov 2026 14:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793974689; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DbXOMRc+RxyXDwhPgVxgq6OSlAD0HlpBTR9dAYmXezE=;
	b=FIawBo5uxM6qqiDjVJWp3+osfdJHTB7/9k/8ZXnfwSqMSVMQsrA+ls8eohG0IqsgJpshAu
	4k11WqrTgHHWctbcwqEkg37q29R+/n7gnGuz2bQMgmmTJ/h2bxDAuTJMuFv97yn+PnssG4
	8k8LiAdzcqtEIdwStCzpo35K3tJtj+M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793974689;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DbXOMRc+RxyXDwhPgVxgq6OSlAD0HlpBTR9dAYmXezE=;
	b=GAIC8+xY/rXGUL8rB7GiG/X98jUIopLTsD8tl90kFvlhyIwDk5QTCQpDh/2tRDj5r7pbP4
	TKSB1zBzbcO0FBBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793974689; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DbXOMRc+RxyXDwhPgVxgq6OSlAD0HlpBTR9dAYmXezE=;
	b=FIawBo5uxM6qqiDjVJWp3+osfdJHTB7/9k/8ZXnfwSqMSVMQsrA+ls8eohG0IqsgJpshAu
	4k11WqrTgHHWctbcwqEkg37q29R+/n7gnGuz2bQMgmmTJ/h2bxDAuTJMuFv97yn+PnssG4
	8k8LiAdzcqtEIdwStCzpo35K3tJtj+M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793974689;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DbXOMRc+RxyXDwhPgVxgq6OSlAD0HlpBTR9dAYmXezE=;
	b=GAIC8+xY/rXGUL8rB7GiG/X98jUIopLTsD8tl90kFvlhyIwDk5QTCQpDh/2tRDj5r7pbP4
	TKSB1zBzbcO0FBBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EDB5D132C9;
	Fri,  6 Nov 2026 14:18:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WnUKNKDh7WpnaAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 06 Nov 2026 14:18:08 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 8BE5F21B85; Fri, 06 Nov 2026 15:18:04 +0100 (CET)
Date: Fri, 6 Nov 2026 15:18:04 +0100
From: Jan Kara <jack@suse.cz>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Julian Sun <sunjunchao@bytedance.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, kernel-team@meta.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/4] writeback: add the missing newline to the slow
 writeback report
Message-ID: <qmosz7e5iaxgadaltvzzcduym4z3dpzw7qrdcwahfvoh75mbzm@2gfo7v62qajq>
References: <20261106-writeback_stall_report-v1-0-bf0c3b9023a5@debian.org>
 <20261106-writeback_stall_report-v1-1-bf0c3b9023a5@debian.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106-writeback_stall_report-v1-1-bf0c3b9023a5@debian.org>
X-Spam-Score: -12.80
X-Spam-Level: 
X-Stat-Signature: m738xfuafijgdisxzebj394o8awa9gww
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5D81F40007
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793974690-101936
X-HE-Meta: U2FsdGVkX194ZnaBkJ2wLNerNjMJ4tVqdNt66G5AnzeIkegdWblS/jbzU7sGxGHZ885zejI3AbXydXbU/cOi9Kq90tkJ50jcqXF9FaRdurNbznAn4/AhgmaejPzAId6+L7K7aWmWHyq2Wx9S0Hj+6EPtCXIx8mzAD6nkkdYSM/TiFnmmiP1crZc4tphVQU3b5PppnjgcC09VxIkc3IJgCBWWTY2d04LuPwJdnmESIN6A32UwbxkgbiB8tulH2fPPCSWgeguiRaeduSubbjXuy/TAwHf6IhOeUxLriWdpZptkASo67eZsw4LF4/d5bgzGuueW8HL3vnjj0cvyysIqOw+emjshcO8tXvD3d6wt1IQoxWwRKFNtxq3wF/p2RN6HpSReV47vSYJqSku68a1evQuC210DjOrdiFqT2/PqkJc65a9MOqPu67oJC+BVciE+HqFNdQKzpAlumYq4ILKsY0f9kPJyIHPv6+7ToFWYyRoiG6GLxATc3tRr9zDFMiITkEC3L31hwygf+5jGBtvgTtoXFKzyzxlI7rVSE2SATTaXT2ZK1e9iAPCp3PmhxziXeya3glkojRBrYo8051fE4de7fYPQVgHy/OFFuMDqR8H17Hm61dBAwLHBvU+htPd1g0BgtClJm/w2H6fo1ia8tY+bszrIY0UB9YGRxgh6FdBt8wGMVCwweNlAkX2aRgtXlWdNWlOvcLssDVSir4XnDv9Z4DGwIrRg/pClyIozEcLjRGe3ww29dkjKctpC3U8lKd9TXAmTztbXZnnPI4M9RyHL6EJjU5xQSiWnfNTVOk/gnmxgm8x6+gEJlIbjiwAmsF6SZuMiVwfy2c4gs6fI4LZJCQrI4gpP3zEbJvatL25zuoFDQBNmkZYfdFnpQ8nUU+XybvImXjOjNh5sIjpYrvajaBNV0TabUcCO0X1txlGzO1JQUs0CWR+8kbaqyA/3JiYsf2hrr3w7O444HlD
 OXCDLXbL
 /nGI6bH3qPkMuAEaet/9uFp91Cu6JzGI1tzEkNn6FKNYB5VcUW8KBmRuspDvb6w0UhMcO8tPH1o4t6NarbT5gXaDkL68dI4c86xd5PtYSueQR5dtMBCXw93JlZBkA/YHCtBS97BQ+wpY6pLqDvS1OfqfR0pjUQTNW7G/hZRA3HjH2PVCAQrobiEsGmtz5ARpWXJhRP9JmzJ1GL3m600zMHioHxD39dp1bccwb/iD/vB3HQF3kCXvfRFWuBWymZ2RpOL2VwNqQq7IM50mWn2yezzLHdzo1OvMSOHcnFD8W4v7rInz+fXSytvRpbUFE5+vb4//hOVb3GV1KTSOgRXI+xg48Q6IuzQBIXqDkFTIyHPLgqjsElRJ4eo5RWsJVBPGQG6R+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri 06-11-26 04:26:31, Breno Leitao wrote:
> wb_wait_for_completion_cb() reports a writeback wait that exceeds
> hung_task_timeout_secs with a pr_info() that has no trailing newline.
> printk() keeps such a record open for a continuation and does not
> finalize it, so dmesg, the consoles and netconsole only see the report
> once the next message is logged.
> 
> Terminate the message with a newline.
> 
> Fixes: d6e621590764 ("writeback: Add logging for slow writeback (exceeds sysctl_hung_task_timeout_secs)")
> Cc: stable@vger.kernel.org
> Signed-off-by: Breno Leitao <leitao@debian.org>

Sure. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/fs-writeback.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 15260cf2a29b09..01a00d7542b371 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -204,7 +204,7 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done)
>  	done->progress_stamp = jiffies;
>  	if (timeout && (waited_secs > timeout))
>  		pr_info("INFO: The task %s:%d has been waiting for writeback "
> -			"completion for more than %lu seconds.",
> +			"completion for more than %lu seconds.\n",
>  			current->comm, current->pid, waited_secs);
>  
>  	return !atomic_read(&done->cnt);
> 
> -- 
> 2.53.0-Meta
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

