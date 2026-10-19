Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE248CCF2D6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 10:08:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACBDB6B0195; Mon, 19 Oct 2026 06:08:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7B8F6B0196; Mon, 19 Oct 2026 06:08:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96AF76B0197; Mon, 19 Oct 2026 06:08:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 620166B0195
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 06:08:30 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EEA63A822F
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:08:29 +0000 (UTC)
X-FDA: 85338951138.29.BC1AED4
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6CBDC180002
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:08:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2j6yhaJO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4+XFpOjI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=g7uDNZIP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=y3evbgPT;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792404508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Onx+JeZfqT4n7RqEsTp5HZW4tzK5tNL6plqqoY4dhVk=;
	b=PSLKTQjVtqMoxy7EBKp+wBFnVqHippeLyaSgWmOH9U0kDl/FYptmpPoQ9lTd8BOEwMcWPx
	pGS1JbPlO+BKhgLau65I7iB7J3QXZglozCi7Ru5mQe2u8yIbMeQ9b1dTnu+EtJu/+4/bLX
	9+noCSwAW1ZNbKxMwSXXtMyxLtKVT/w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792404508;
	b=7sC3+7wYlVRcqlhigfBOiwrUhA0sbR2dFe0PdarvMuR62m7Sw7Tk+aMtcsXcVWMR/iwGqD
	MPB4saO6x5qVJgQxUNL+55roLCvwW/NTIiGdavxlhpIzM+yKqhe1RbaJ7RLVGTKNqCUNZ4
	Q64wkE217LIY5eaf9ds18xZzjWcXi3M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2j6yhaJO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4+XFpOjI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=g7uDNZIP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=y3evbgPT;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BCB9E21C12;
	Mon, 19 Oct 2026 10:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792404506; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Onx+JeZfqT4n7RqEsTp5HZW4tzK5tNL6plqqoY4dhVk=;
	b=2j6yhaJOCaIivir0SE6H+TxgSjRNEeEo8Y7vd/UgyirvA4Lbll3mdscbM7KESQGVWMU3n0
	Nw6A/+8o7FcmauMj1J/vidT0P0+uiI3EbR2BVtYpYl3eIRFjDc2QjtyCe5CQ++CTqPDpAv
	Y/BcUj717agCPF2s6G3xABDGSRdp6Lg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792404506;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Onx+JeZfqT4n7RqEsTp5HZW4tzK5tNL6plqqoY4dhVk=;
	b=4+XFpOjIhT5MYmu6nuoe8mbULZGnUBeLqtc0OVg0M2rjvj9bmQDysZPeWHotyf6uCH4kVi
	HxP6FlJl4MUi/KBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792404504; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Onx+JeZfqT4n7RqEsTp5HZW4tzK5tNL6plqqoY4dhVk=;
	b=g7uDNZIPEpg2kFzeIAwWJt0X1jbKHGG/3UmOkhLl59qCjVe3OiPcjYTA5R1rg7LiIFVCM5
	/oCPGceBaNjA1I3QeI9F6cGDDFa/RDZrcZtFBEYB0+Tc/jBnA44zDTf0vv8ZWmIbDIEBGL
	mjWqztuXStAcA5BZtDgyoDaKxX+1taY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792404504;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Onx+JeZfqT4n7RqEsTp5HZW4tzK5tNL6plqqoY4dhVk=;
	b=y3evbgPTXWaM6PrgtT/BQ6enNXBnrmxMlayO1rf0Oce++uNu1CJR59WkO+SuFk8tUozpcF
	cmOZpAGq0xXkhsDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 951BB136CC;
	Mon, 19 Oct 2026 10:08:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id O/jdGxjs1WrSSgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 19 Oct 2026 10:08:24 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 230CDA1413; Mon, 19 Oct 2026 12:08:24 +0200 (CEST)
Date: Mon, 19 Oct 2026 12:08:24 +0200
From: Jan Kara <jack@suse.cz>
To: Liz Fong-Jones <lizf@honeycomb.io>
Cc: Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, 
	Christian Brauner <brauner@kernel.org>, "Patrick Lu (Anthropic)" <perf.patrick.lu@gmail.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ian@honeycomb.io
Subject: Re: [PATCH v2] writeback: keep cleanup_offline_cgwb()'s scan out of
 syncs
Message-ID: <lw7ovj3ubo27lfhyyklzt6cevl2silk7g7dv62wlk76l462thg@nnskkgjljah5>
References: <20261015114307.1041273-1-lizf@honeycomb.io>
 <20261017040710.1174009-1-lizf@honeycomb.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261017040710.1174009-1-lizf@honeycomb.io>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 6CBDC180002
X-Rspamd-Server: rspam08
X-Stat-Signature: qxpxow981umh78qyycj8o17ungkw3k66
X-HE-Tag: 1792404507-650510
X-HE-Meta: U2FsdGVkX19RIObSHq5cPSyJimgkldmH809Kvd5gDOImoshHD7UCYulwlqWcUENkEOjKGueO/bIlAaCJXCeN7XDMsDXpdcDtNdxMVj9LHApoWp1USULPqOkj/GL1vMnz+aRbX38TxnvbsTlbldooZH05GwE9QljMr521zKFUxfKz4uHfc7UQXbwd/a5LjsC2v4PTNGDnl/qJWJtjVVGY5JJdINkLVvL+p8Cv/RX8MLRz4qp8vhXFTEMcWQxk3nTulIsDFHMlGJ6gDD8HayyRviTcM2w0A7C82RH7pOsuEClls/9OXptFa/gBVWsRaRGh27jS2z7b7L7WzMhvaeoU8XQ982pI3AUmVpl3F1Oic9Nhd97N8oCHmXqTczWx87zQfB0o+1Nggpu2r0HV1xVsRD7NNOYdzy5vKVOtU/YkPYhjP8sFi30sfDouHyY/mmdyQp9R03ljRh/gFXYlKAIQ7+sdHciKkKhnv3keFd8sJ7z741hFwCdifB5BdiEvXkZoHOZMH/0mtik7fweGIwDmneDN8TTPwzPq4M4kH7VCNbBb4DgcoR35CAg5JtetLyPQT7VSVQI0N9qfJ0zM3gJJI5N+27kB/ZAIOQH6bZ2gDfITFYMJg6xsirbLTKLVCbCvzow9+ztKzA0FmdtsdZxePNlBBO+xQvmhXIytIBQXaTqkMVyhiNTEXewVSR+4dIOMR1QZuVU/Afxw2rzF8an3x1tGkjIAw5ClnTl53Ai0CrvfMuNqq+5exybqFWhbzRtYQ36rwRi/+KNR3k91wHeEZByWuOy+3hqrkILAsF1Cuh0+RXiTIMgz3CPY2a8nMH8tjHlaBq3RnK8WcwD2cyUR4m2OhAlBheyBtYFZVrtj0kx99zCAAgD3b9ZCnxLWIktkp01Di52bf39T1fOcNw9i3VEXd6wFvvX5cQ0+hcSCmWLcu6R8aiD5HN6LrBZIimxFrl6c/k3yy+3WCpNhiQe
 icAS0sh6
 iu21V+ZVBiafYz39ZTFP0RAknXcdGNIRkjARzTqiRkP2nRlUJBGfqhlWTYQRR+cUd2bAmURbcRd1tH0Ggu8prfYmQe8z55CGSLoj1R2eZKh17ghM7dTNTJrwj5zqtGDHPvnkIFm6tw0UalnqfXhmoOp5qnIeJ5UgzefhCAm46eHZMGmzO1+ackgzVgVMr+HjrE87hmXkjclxQKhYAMNgt6YkwcmHJLLaxW0r7NqLNiP0Wjqa5nnvIpFdqEwx2ng+3qkj1vSEh69hFwSLpnYXdJR8JP+LAXQpAkIjcay/B1RY92gG7aPLxR0HfYjrIvp0sAdZYZcCTtFnjFZ33SOIZ46UVWZS48WhhONStObFx9pEXV9wPkAkijhrPV9bbw4hjCMbeXW6f3piCwfvP8T3DktFCHpy1LpYnWwqhpvXdR8gwcvloL2134Ld0tcxYDMUJc8KXbf9OL/pAMJvdkOCpXKNLPkEL3ZZUG29kvtfcdEVW+aM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 17-10-26 04:07:11, Liz Fong-Jones wrote:
> On a filesystem mounted with lazytime, sync() and syncfs() can return
> without persisting timestamp updates of inodes attached to a dying
> cgroup wb, so a crash after the sync loses them. File data and sizes are
> not affected.
> 
> Since commit f6988c90671e ("writeback: bound cleanup_offline_cgwb()
> rescans by rotating scanned inodes"), isw_prepare_wbs_switch() moves the
> inodes it walks to the newest end of the list. When a pass fills its isw
> before reaching an inode that got its lazytime update after a sync's
> cutoff, the walked inodes land past it on b_dirty_time, and the sync's
> queue_io(), which stops at the first inode dirtied after the cutoff,
> misses them. The late inode has to be one without a pending lazytime
> update; one already on b_dirty_time keeps its position.
> 
> The window is narrow. cleanup_offline_cgwbs_workfn() skips wbs with
> anything on b_dirty, b_io or b_more_io, so the scan has to land between
> wb_writeback() fixing dirtied_before and taking list_lock for its first
> queue_io(), unless a multi-pass drain started before the wb got dirty
> IO.
> 
> Take wb_switch_rwsem for read across the scan, as
> process_inode_switch_wbs() does for the switches.
> 
> Fixes: f6988c90671e ("writeback: bound cleanup_offline_cgwb() rescans by rotating scanned inodes")
> Cc: stable@vger.kernel.org
> Suggested-by: Tejun Heo <tj@kernel.org>
> Link: https://lore.kernel.org/all/0bc5d58533f10b4841807be3025daa11@kernel.org/
> Assisted-by: Claude:claude-opus-5-5 checkpatch
> Assisted-by: Claude:claude-fable-5-1
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>

Thanks! The fix looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Changes in v2, all from Tejun's review:
> - Correct the trigger and the reordering description, and note how
>   narrow the window is
> - Reword the code comment
> - Move the test details here and trim the description
> 
> Test, with a debug-only delay holding a syncfs's work on the wb between
> its cutoff and queue_io() to widen the window: 300 files on a cgroup's
> wb with lazytime atime updates, one more read after the cutoff, then
> the cgroup removed so the cleanup ran. Without this patch, syncfs()
> queued 48 of the 300 and after a crash 252 atime updates were lost, on
> ext4 (-I 4096, so neighbours' timestamps are not written along) in 3 of
> 3 runs and on XFS in 1 of 1; with it, none were lost. arm64 KVM guests,
> 7.3-rc7.
> 
> v1: https://lore.kernel.org/all/20261015114307.1041273-1-lizf@honeycomb.io/
> 
>  fs/fs-writeback.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index ea3eb40bf828..372ac9785e03 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -789,6 +789,13 @@ bool cleanup_offline_cgwb(struct bdi_writeback *wb)
>  		new_wb = &wb->bdi->wb; /* wb_get() is noop for bdi's wb */
>  
>  	nr = 0;
> +	/*
> +	 * The scan moves walked inodes to the newest end of b_dirty_time,
> +	 * past ones it didn't reach. If one of those was dirtied after a
> +	 * sync's cutoff, the sync's queue_io() stops there and misses the
> +	 * moved ones. Exclude syncs as process_inode_switch_wbs() does.
> +	 */
> +	down_read(&wb->bdi->wb_switch_rwsem);
>  	spin_lock(&wb->list_lock);
>  	/*
>  	 * In addition to the inodes that have completed writeback, also switch
> @@ -803,6 +810,7 @@ bool cleanup_offline_cgwb(struct bdi_writeback *wb)
>  		restart = isw_prepare_wbs_switch(new_wb, isw, &wb->b_dirty_time,
>  						 &nr);
>  	spin_unlock(&wb->list_lock);
> +	up_read(&wb->bdi->wb_switch_rwsem);
>  
>  	/* no attached inodes? bail out */
>  	if (nr == 0) {
> 
> base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

