Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67764C54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 09:03:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C5116B008C; Thu, 30 Jul 2026 05:03:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64EA96B0095; Thu, 30 Jul 2026 05:03:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F09B6B0096; Thu, 30 Jul 2026 05:03:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 28FB16B008C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:03:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 24854808EA
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:03:10 +0000 (UTC)
X-FDA: 85044853740.13.889AB06
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id E34951A0002
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:03:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0cUIwe9Y;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mWva2A6K;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=maifyACd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gDc1BEZz;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785402188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2lcyjIV1UgNCG8dyBWciVmy0meoQnVsrSi06pjEH+so=;
	b=CVUmU0MGIRfJpG4BZf4xBSFtzcAYqxQ7bWtciK43Mzg1QAwZtJESVdczEBekRGSgasJtkU
	ThD1vee33FtBE3naGOYSsbMyxExRscEM4ItGtMqIPheZ0RRhJdSC0zDV1uwvkRWiTUXxY3
	F7JrUwTKloK1jV+njngleB54WtRNMGI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785402188;
	b=10c/7lPa5Nxr9BQF+1OUfiIAbrYfA4whfp6R/D4sYhM4gkJpkCBBKQEzHmi74ssL0ZXati
	LR5rCqeke+fm22F8MFIG0MlkDQCOa0L0n1l1FNmEjoK0jwPqQcdUYw34D8PDz/NjPPupQ9
	7goym1Kd6fPl6YBhLQR4jzJB5SkRjVY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0cUIwe9Y;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mWva2A6K;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=maifyACd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gDc1BEZz;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AF3897D4B7;
	Thu, 30 Jul 2026 09:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785402181; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2lcyjIV1UgNCG8dyBWciVmy0meoQnVsrSi06pjEH+so=;
	b=0cUIwe9Ywz6ANAz5DcQmwuwm3N/lnDg11kIQFZTq9WiaBTTkmIGW7MIv9ohor8Jw3CXiDj
	chQOCdHSNUaNW8YdZSIWGUrdxsZWocDtRQA1UQ9/vfd4uFMRdtiGqpKMHYSFUcWWYQxBnE
	zgg0tbWDfuD6T5NsrNo2ZfUqR7idszY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785402181;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2lcyjIV1UgNCG8dyBWciVmy0meoQnVsrSi06pjEH+so=;
	b=mWva2A6K46mRjcGrjCcIU6z6ngn0i47JX2KuHiRKNdPYG1qdewJRuOHNuTUILQPDUZhHiN
	CXtzCanVf+tlmaBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785402177; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2lcyjIV1UgNCG8dyBWciVmy0meoQnVsrSi06pjEH+so=;
	b=maifyACdq8mMa8+y4Wq5AXK7l4BKn2Sg1/SGME6NZ+ohi26yk6cGO58fiDoFPsu6OYlg12
	btSuM7+HRyYchkuY85FJ4KQw2s/tO+5Lf6RX7n1/qDF7lp5zctTlsb+y2IRokjiRuEXGL/
	t0h7rCE3VJeRmr2F20ECKslkkBcOr+M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785402177;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2lcyjIV1UgNCG8dyBWciVmy0meoQnVsrSi06pjEH+so=;
	b=gDc1BEZzFv6Juckc+df3mLmF5Bi0EdNnCFS10baD/7YUIXPo3aeDT1oqiebPSv1TZQDEnH
	v3kAHSzxRmA8xIBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A3B18779CC;
	Thu, 30 Jul 2026 09:02:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +CDyJ0ETa2obWwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 30 Jul 2026 09:02:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 42EE7A0AAA; Thu, 30 Jul 2026 11:02:57 +0200 (CEST)
Date: Thu, 30 Jul 2026 11:02:57 +0200
From: Jan Kara <jack@suse.cz>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, Dave Chinner <dgc@kernel.org>, 
	Bart Van Assche <bvanassche@acm.org>, Hillf Danton <hdanton@sina.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH v7 1/5] block: introduce bio_in_atomic()
Message-ID: <memvwweih7kaket63x6tee7a4z6nefgkelv4xznpxrqysjob2c@t5rfbf53s2og>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
 <20260730-blk-dontcache-v7-1-3e8e6850068d@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730-blk-dontcache-v7-1-3e8e6850068d@columbia.edu>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E34951A0002
X-Stat-Signature: dhw9e9uqeh68id851boqm7rq9fet5aq1
X-Rspam-User: 
X-HE-Tag: 1785402187-859682
X-HE-Meta: U2FsdGVkX1+jQyKTFSkdI+LRYPSJRa89OeQzPzpX03bGe9MoEl5KFE9Jn4DDQV/t7+WW5H/sR6mZl4cwJBXigYrWE+I/jCSAtRyyHlwZqoGg9rzBe/SlbeCDhPSq9Pr1BWm7t5XdoQNNg8jQ76k5hyg+gBp14LYnNwdbcaiZei2wuR2Rzg4gywVRqPlPWgofQl/nEsGROwsCRuNQiD9b2B5wYvV2ckVmvo5XGqFsTFHB+Vw9SBRyuTAF1VwsIq4nrLVcM14vGyIHq5+Rm20XSbz9sGdlc+2h9kzjOB+8JTaNy5kPOg9EpxyHkVBrLiaYgYPoj1BKo+TO7xSwYk7pfQjCGjiltFPes714/huCV1metWNhpst9yQ4B+dtyACgeaEw/2qOTHIoRTtwIF5b+NrUeMbSQfduhumnZSbayFjyeiYUOO1Tk6KkJUpUMcvNzOQRtmh6neP8uCACu1jEBirAN1FMIbAU/lZ8MwnUcI3Em5vDwgsSuilUZc5z9ppqi1KoZxtiE3WM2t2P1oh3aBQch8Aig9m+Hseu8Wzy9ICnwpdY5ERPSRU/7EYdlyuQEX5fmihGFmvBOHWqflt9mtkmcgdeiCdA1FhEeoELMHMlZSIjvaMZ/D45Sa0JM2CHjVMKevieW5byOewE/mRo0b8PtbDs7rDNSK5/2Xy2umXu+ShUSFeaXAedXeo5W6T636IHmXYR2iT8RbmhvRb5ZpcNre1uKVXRLgT4Q6YKI2PcQ0DodkR4SJ86WJnFdS81oNQxKlby/hJdxNKzU2404xDqHNzHx6N0c/KkJXoBp9ahWVIpIm5lAEahNcqEkiIdx641Agb+Q+VM4ibeQMXExG6/TA/wvkjDJODs9LnYoa5pm6mDCZeE9eXKvxEk7zrpL5D4U9XW6f/GINK9jC6uthV84YmCdLgzaPHolH735bSLG8WXwSW6ZOWuVdp011ibb2DYwH3apkTRF99W4s1c
 Ml5dvUnQ
 iQeKfPWTIle0S+uRoX3ksK7cf36bmshuJtaKyN3R8e19Z10lBIaQ67X5gik9M8vJy7uwJ6ZGd1N0vMlsGbDZ8VSZWjTTZ+Sz/IEHODmbiiSWqt/I3ogY5ZrS3dfDp093ehAVwAZZeqFv/rPY+6w4EZtQIzbqipgP8kDpleHL0ozpR7/H5RTxcQSIosZBUU0JhCeCFi5t4ROlokodsRZmHjwnE15kQX/BOC5qQjJDeHs+tCtxIayKIf3hawXyM2gY8AK8GQUvrLEPJ11qibTP8pw0sA4wlP2TmRBsug4kv8rZ9lYFd4/TGyg7fSjRmiN9lf+nBpeAvUdTklBtKU8u6IUSLy9dThhfIcfpr8hSko8KY9he2iB/TTDsur6b2pMcvKtPpEg2oESNqnI6LeM6Z2Cn26vEgVtugdVoDyH2+F5L0jR/WLi7MmMANEYXbvsHU4l4R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 30-07-26 02:57:51, Tal Zussman wrote:
> Move the atomic context detection logic from erofs's z_erofs_in_atomic()
> into the block layer as bio_in_atomic(). This helper returns true when
> the current context is unsafe for sleeping bio completion handlers (e.g.,
> hard/soft IRQ, preempt-disabled).
> 
> The logic was originally added to erofs in commit c99fab6e80b7 ("erofs:
> fix atomic context detection when !CONFIG_DEBUG_LOCK_ALLOC"). A
> subsequent patch will use it in the block layer's bio completion
> infrastructure, so move it to include/linux/bio.h where both subsystems
> can share it.
> 
> Convert erofs to call the new bio_in_atomic() directly.
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> ---
>  fs/erofs/zdata.c    | 11 +----------
>  include/linux/bio.h | 15 +++++++++++++++
>  2 files changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
> index 74520e910259..f796bb3ef53b 100644
> --- a/fs/erofs/zdata.c
> +++ b/fs/erofs/zdata.c
> @@ -1427,15 +1427,6 @@ static void z_erofs_decompressqueue_kthread_work(struct kthread_work *work)
>  }
>  #endif
>  
> -/* Use (kthread_)work in atomic contexts to minimize scheduling overhead */
> -static inline bool z_erofs_in_atomic(void)
> -{
> -	if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
> -		return true;
> -	if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
> -		return true;
> -	return !preemptible();
> -}
>  
>  static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
>  				       int bios)
> @@ -1452,7 +1443,7 @@ static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
>  
>  	if (atomic_add_return(bios, &io->pending_bios))
>  		return;
> -	if (z_erofs_in_atomic()) {
> +	if (bio_in_atomic()) {
>  		/* See `sync_decompress` in sysfs-fs-erofs for more details */
>  		if (sbi->sync_decompress == EROFS_SYNC_DECOMPRESS_AUTO)
>  			sbi->sync_decompress = EROFS_SYNC_DECOMPRESS_FORCE_ON;
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 8f33f717b14f..62a983758e09 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -368,6 +368,21 @@ static inline struct bio *bio_alloc(struct block_device *bdev,
>  
>  void submit_bio(struct bio *bio);
>  
> +/**
> + * bio_in_atomic - check if the current context is unsafe for bio completion
> + *
> + * Return: %true in atomic contexts (e.g. hard/soft IRQ, preempt-disabled);
> + * %false when a bio can be safely completed in the current context.
> + */
> +static inline bool bio_in_atomic(void)
> +{
> +	if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
> +		return true;
> +	if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
> +		return true;
> +	return !preemptible();
> +}
> +
>  extern void bio_endio(struct bio *);
>  
>  /**
> 
> -- 
> 2.39.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

