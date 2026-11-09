Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3206D606A33A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 10:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=CscclKHE;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=qufVQwoT;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=n7NL+oR7;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=qZ3i4Ij6
Received: by kanga.kvack.org (Postfix)
	id 214966B05B2; Mon,  9 Nov 2026 05:55:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C6766B05B3; Mon,  9 Nov 2026 05:55:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B56D6B05B4; Mon,  9 Nov 2026 05:55:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D45C86B05B2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:55:52 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5F63E40632
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:55:52 +0000 (UTC)
X-FDA: 85415275344.18.1FCE419
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2804240003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:55:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CscclKHE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qufVQwoT;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=n7NL+oR7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qZ3i4Ij6;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794221750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WjVWX6E21tFl2sD8Mx7SLeOlrK6FQokIkj+LlsMQstQ=;
	b=TsCX+Vx5FXaqFZGOU0Aez7NbqFy8t0OFipJTxPKu4n7SIrkAoV+JChvwrUQZnDbi28m7ww
	B2cJWz2mlUWdTNKrimqA6dHWJ47uugRSmmGNrPFJz/3jyee67c47RVmiJyZCfo7IxN8XPF
	aXlJXN9FLY3QWD6PgiH7qPvprIXyi1I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794221750;
	b=Elln+hHF9/XsgTAslisbSSWEW5A0ga3wKIy6uvcawdOkh9hPRuoU87UIXRMsrkDwQw5XVx
	lTVzrFHD7HHhXuwjVfT47FvnjVPU7PXXc1MRdPDfCkU+LNRyKHAzEsTItQ7es7Ago2bZAP
	zi6Q/NxxgfShNRkqzHH/VvC3x70yzLo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CscclKHE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qufVQwoT;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=n7NL+oR7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qZ3i4Ij6;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0D8DA2202C;
	Mon,  9 Nov 2026 10:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794221748; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WjVWX6E21tFl2sD8Mx7SLeOlrK6FQokIkj+LlsMQstQ=;
	b=CscclKHEIlu/Q61Xk5Hh4VchYO+eezj+MGVMuYCp8E2Xs8ENpkkNja9WQp0ucIIyQeV2j6
	y1OUzfzv9zSFSYqILcH40oukwIWrfPsWf/R325cZ/26GCAPCOdIWciItDUKgPjS9jNEH5P
	scALSnazHU/dRIuYjQkKonIHiB/++24=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794221748;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WjVWX6E21tFl2sD8Mx7SLeOlrK6FQokIkj+LlsMQstQ=;
	b=qufVQwoT1LMSP11eAa4ve7TRhyy8JX5taO1QNjgQEqXhR7vyx1RyLzuyOvwWCS/AvFH7+o
	TmrSXifcntz7kUBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794221747; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WjVWX6E21tFl2sD8Mx7SLeOlrK6FQokIkj+LlsMQstQ=;
	b=n7NL+oR7Reaim+RWNUMTZHX2Q/WVbcqcqJ9pPXizXf0ljWHkiTQIpIQU0hx2DR4wlkL0c2
	E9RdrhClQELefsBi9xLJ3fp4aLVAg62zrgC8QSHXvFYbHtqgJeTCJh4NDxz0rCQOj+fy9f
	fiLlhmj1UXgEtQFAwHEOfmHojYtvswE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794221747;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WjVWX6E21tFl2sD8Mx7SLeOlrK6FQokIkj+LlsMQstQ=;
	b=qZ3i4Ij6wVdOuvLQnvtDp3MHdOPaZc5kDK/WlKCa0WV3s07OnP1hl2zmKhc0L7VHGK3VR8
	2bIKy5Lnbba3UjAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D703013319;
	Mon,  9 Nov 2026 10:55:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aeYKKrKm8WqQBgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 09 Nov 2026 10:55:46 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 5CE2221EB8; Mon, 09 Nov 2026 11:55:38 +0100 (CET)
Date: Mon, 9 Nov 2026 11:55:38 +0100
From: Jan Kara <jack@suse.cz>
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: willy@infradead.org, jack@suse.cz, akpm@linux-foundation.org, 
	kas@kernel.org, dave.hansen@linux.intel.com, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] filemap: prefault writes starting beyond EOF
Message-ID: <vmzll2iszhdaycphuyjjp6vwki7gf4npbfb2eltzt3rc7pbdsk@bcnlvrzc6c2g>
References: <20261104071002.49693-1-dennylin0707@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104071002.49693-1-dennylin0707@gmail.com>
X-Rspamd-Action: no action
X-Spam-Score: -13.01
X-Spam-Level: 
X-Rspamd-Server: rspam06
X-Stat-Signature: qw6a19cxuno6bsj5ize4ds9y6nn8bw86
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2804240003
X-Rspam-User: 
X-HE-Tag: 1794221750-345972
X-HE-Meta: U2FsdGVkX1+9h90lhGXZds1oiYP5GinnyPXhNegaICMVXpURJsGiA2ast3OiJZTM82qcmMWTipGhfegZyXakysQJjksynKDLEAEJGMcvQUFBJuE+SdhcYGV8qvwzKwSgu9RWmZ2CXi2FUl/tFldScEa4wQIaQEtYDvv8s9jq1XSm3m2fOTFhwz2GcFXRdKyPND2s4gr5ADmtWGqsnjdoFAN0Yke/UL91wnRW1I+zxvBKdIqXwvy3ySD2X00TqfZuhRIPMDn8bQ9g5TjEpN1pDqyyjPdhSag/saaKYANLPmbEcVWXpXNpqlr5CDzAUbvpvctKT2i+vp1LBUXbeRxrb05EavsrgLjmska6as2+7I1fYqNq2AW2Meu9/reDbvs8BXpS9FAtz4VwLq1RmBMcGc7XhNuKeIgg8MZ7rx50dVfovTwkWCLoejKbs4g7G5Cz+p5TPzGcbxmgzrQR5okAPFMv+CTa65mvWA2xsnH4+LUJwkURW4lBoXw7OTD5OKkIe4/rf0lhg/PZF80nsP/lEG6e1O7RX8QrUW+hbuMnWOFRmnwvPfAMMWLW8P8WNNPNgy53ya/oq8dSg58Yi1Mx4doQ8HAC2qPmMsjyVrxKxQ7/e1mdJpoEwmPHzmrovFPU9uT4OwwQfHjicuGHzEOlKrl4f9jFoJ94Y9klHw6/zDwkVbWvcxcFwmlQMeNDbPBupXI9ENM93+2CDoetB4WapbhxYXanm0S7DQ4bE0eoCvDs58zgMAPt18esUIQKntDZEhJYU2d+r+2IuZwZLhfJsLFbOkrY7j59+t99G0UX15VUKVlH8BkFaLY2n8qTicJNeyyzS3DsP6vLbNjp1gG7+5kdfO/ZkwvuZbeZx1C+TzEXffQ3WNd8iB6XWVIqJSKZw2xONM6yNhknrgIxtqHn1u4NuPjcuuIefez9/BEd5eokkGbLoQJ6v/1SNyNQzydhjiyipNPvqZBr4K+6Z2y
 xWqUa4nr
 FIGTytf3g6xnO3EBCXoQJGVOS6aI2xKgl243OLRwZvHNh6SLPwAYAxALgcVtY1TJc13m3oI9r6a4+RoWtgeozztYFaSPjrFrDImP2BaUMSBKQAIrzjcVcaFD2+4ETdodRRoRIpDP4hUy8Emje1UBOr5bpF4uWYG62YuTUFBFIjYoiM/27eh0KO8vRE9esYvVgMLd9ppCvGTK2isnkyeDM5aDMAO7PuCabwG20ZCyq76j7HPm1a0he8JdeamhL9dpjYiDuMEIvp9Yj8VljOqmvXPLynC6gT/3SOU96EF7xf6ENVRgCSAV/HMuKCHkS7hLjqsTCHqeQ4jIWgJWLFX5qdcA0tcnvnfi6njDt8uW6mhLzuvKiLO1GorsF8SvqY0VL+JXS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed 04-11-26 07:10:02, Hungyu Lin wrote:
> Since prefaulting moved to the slow write path, a buffered write can reach
> ->write_begin() and ->write_end() before discovering that its source buffer
> is unreadable. Several filesystems can extend i_size in these callbacks
> even when no data was copied. For example, a one-byte pwrite() at offset
> 4096 into an empty file can fail with EFAULT but leave a 4096-byte file.
> 
> Prefault the source before ->write_begin() when the write position is
> beyond EOF, and return EFAULT if no source bytes can be made readable.
> Overwrites and appends continue to skip this prefault. Keep the existing
> slow-path faulting for forward progress after a failed atomic copy.
> 
> This also leaves intentional zero-length ->write_end() calls used by
> generic_cont_expand_simple() unchanged. As with the previous prefaulting
> behavior, a concurrent userspace unmap can still race with the later copy.
> 
> Fixes: 665575cff098 ("filemap: move prefaulting out of hot write path")
> Reported-by: Kiryl Shutsemau <kas@kernel.org>
> Closes: https://lore.kernel.org/linux-mm/at9xXRhD2xZhszEj@thinkstation/
> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
> Link: https://lore.kernel.org/all/at-XtWBQg3jv3H8Z@thinkstation/
> Cc: stable@vger.kernel.org
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>

Looks good! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> 
>  mm/filemap.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index b74bc1e5015c6f318333427f223b9f42061a6213..30414d55412b84f11ebe98b8eea607ee8c04eef5 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -4389,6 +4389,16 @@ ssize_t generic_perform_write(struct kiocb *iocb, struct iov_iter *i)
>  			break;
>  		}
>  
> +		/*
> +		 * Some filesystems can extend i_size even when nothing was copied.
> +		 * Prefault writes beyond EOF to catch unreadable source buffers.
> +		 */
> +		if (unlikely(pos > i_size_read(mapping->host)) &&
> +		    fault_in_iov_iter_readable(i, bytes) == bytes) {
> +			status = -EFAULT;
> +			break;
> +		}
> +
>  		status = a_ops->write_begin(iocb, mapping, pos, bytes,
>  						&folio, &fsdata);
>  		if (unlikely(status < 0))
> 
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

