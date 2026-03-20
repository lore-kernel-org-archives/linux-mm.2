Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED9DB1098781
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:47:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BEFA6B00EC; Fri, 20 Mar 2026 09:47:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3700C6B010C; Fri, 20 Mar 2026 09:47:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25EC06B010D; Fri, 20 Mar 2026 09:47:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 14E376B00EC
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:47:12 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BD00D1A0122
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:47:11 +0000 (UTC)
X-FDA: 84566567862.20.1C63CBB
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5E76618000B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:47:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XiYPAIme;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Riv3r3U4;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XiYPAIme;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Riv3r3U4;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FB2fiQ0cjoEpu/qGNrEctnM3RzKFuHSEIyrtHJjfqQg=;
	b=wvWKN1mh1s2jK+nOU0NqTSlfyQbaQgvLzVFJ55J0TSDc5BiWGfu0+KJH3YwwSh/fTP1X58
	e1DHmw1JgMdljsliI/Bqq9V2xeYd8x0jxcBP9U+wL5hwjQ9AwbNxamiHAAxAei8qX6izqb
	xEVCsPyZEfYmgL6tmoYrllZrP92h8+M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014429; a=rsa-sha256;
	cv=none;
	b=r20J6SKuXpkAs9as0gE+4Iwm7rd+mbGD0F6/1RgvosoKfrRQcF7uNuP8TNbwvgrV6Qot3d
	O6QKm/buzPh3vdfm2o/m5o28FqPNIlNZC7a5fYg2UUsP8BB5U7l9LkiLtisUg9DqenPN7t
	QvMKCFxzF1Xp9un0LIl1YHD+UFFxRNk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XiYPAIme;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Riv3r3U4;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XiYPAIme;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Riv3r3U4;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2B9435BE0C;
	Fri, 20 Mar 2026 13:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014427; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FB2fiQ0cjoEpu/qGNrEctnM3RzKFuHSEIyrtHJjfqQg=;
	b=XiYPAIme+m5drjp6bc9TampjpCODhLtv189M2HnxC2VSU7MNKwYbr89GgfDiCEirlNADUH
	HwtvtpplJPx54drs3R9knpyZvFv9ZTjVdrhpBK5JtJjgO6OrCaA5ljtrjG3wdW82YR+t5P
	idg2N6f6kB6KlRdRl7ci28d7/rjKEjY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014427;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FB2fiQ0cjoEpu/qGNrEctnM3RzKFuHSEIyrtHJjfqQg=;
	b=Riv3r3U49zeI7XfRexHJeOwQ4M9Iw6pd6Q0VUPoaYZewwRHh6CD/59QMwrt2MOPwMxnHTo
	sY2z2zy1LIgy+aAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014427; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FB2fiQ0cjoEpu/qGNrEctnM3RzKFuHSEIyrtHJjfqQg=;
	b=XiYPAIme+m5drjp6bc9TampjpCODhLtv189M2HnxC2VSU7MNKwYbr89GgfDiCEirlNADUH
	HwtvtpplJPx54drs3R9knpyZvFv9ZTjVdrhpBK5JtJjgO6OrCaA5ljtrjG3wdW82YR+t5P
	idg2N6f6kB6KlRdRl7ci28d7/rjKEjY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014427;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FB2fiQ0cjoEpu/qGNrEctnM3RzKFuHSEIyrtHJjfqQg=;
	b=Riv3r3U49zeI7XfRexHJeOwQ4M9Iw6pd6Q0VUPoaYZewwRHh6CD/59QMwrt2MOPwMxnHTo
	sY2z2zy1LIgy+aAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1D3794281C;
	Fri, 20 Mar 2026 13:47:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1UMeB9tPvWksDwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:47:07 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D1B0FA0A81; Fri, 20 Mar 2026 14:47:06 +0100 (CET)
Date: Fri, 20 Mar 2026 14:47:06 +0100
From: Jan Kara <jack@suse.cz>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
	rppt@kernel.org, pratyush@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org
Subject: Re: [RFC] liveupdate: prevent double preservation
Message-ID: <gdu6kqpymqgkzbw2yrvvsrububimn2ocuyi533d6llofqu32kd@sqc6d6hsuzic>
References: <20260317023834.487682-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317023834.487682-1-pasha.tatashin@soleen.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5E76618000B
X-Stat-Signature: mjn8937gwptntgpf7undibdm647dwj7r
X-Rspam-User: 
X-HE-Tag: 1774014429-174416
X-HE-Meta: U2FsdGVkX1/Q+JF4zMTVX446KbUAL+qj5MTkayzjdYV4BU2AELXS9KRcdMxjVhl/82vJZToykbOl96wiW2vTvsjguMCiHv05Cbb8jn5rgMY/MJir0dVbtBjPT9Uti5vg7AchNruS0DAijK/KyelWLRa/s7HVwasagciKQQ/Yz6rzJ3HSMDlPD/q+CtsNZikdjvWDqq61HluRyBZPPBlL+JITRBN8O3iPE8ECJF2QeclnWDROIm7hKQkGlSBqeyS1N5qXYvfTsfcVQOR9/ikmb2r2CspgGesWpNoFIKoVKa3jPYvx/5wqbKSn5Ftp3lQCAYD6adpdxRhWNtBRSCpVpNLdqrBEpoL4S4YCf0JFMVTJYlLsQSLl3Z2DFmZCyjWy9m5hNBJTa5tzdB+843kd2B+wAdIEZC2s9PlyYlyRpMzfj9AjDu5DFB+NrjND75PWkkkuH0k+IJjJ5AntTW7JX5zBcWk2BjMO0mvjQspuNnYVedgHL+5vwda6N02vOQBqUjmEYmPoJCJ2Rj5FCz7GYnYsNUH7ytHfsLEW686Er2GLi0acss97W5Drb2ZXYlOGhW/Hr6Nu1NUSls6YTXN3Y5nZ9p+iy+IvTox6hempOu/Xx28oqqkmSdpT/dQuSaY2Fp4mmtQeYApt+wspb7G1JB5T//JTWLpWMEufgpBcTPClJUkzuv4ILtwPfejLYmXxuK03AuvDFzv5vZMEKthGYK16hoLo7QKTxtBm1rix8AtVFwzyKMpUBbPFweY9lIvaByzPH0g73SuHMiULF68rvDdqe7zqmmLSxp5DWl8JluTuJGdXZmo3CCWpMIXNncZiMdX/vr/BG6UZ33ilP2zhxjQ1Qe68HpN76WKkSIeq32xwyVfWigSfYF3LOv1CMxbnw5XjkkU23MxDhgekRFkjCjpyHwZhD0MFOecyd4Kmr4I1jwGKVR3r78MsZ5/3d+ZTZ0uwjsu71cCgGPgAMUc
 GMhIQf2I
 BxCrCmFOr2Me0Acdgjt19/omoBwH2EXr7/vrkM5c3dDhIp/gKHQj55DxoxYCe6X7dHdfxr8C+maNObYZmxVMZhCw7AsPs/uLsDhecVbbP5lSgRSrhLl77DxjCFAtaQQQOtHB0hw0WOPwZ3o9RPTLCQSkoodNi4Ln6d68HHeNFAf5qo7JXSgE4ljgV/icFaadrDpPU3oOcUh2MD9D3BywvP5+/kvDmTo8EXBgeFG5sivv+7ePkrh0DtFpIz9P0oS6TPO4MuzqUMZgd04ZDXqNAq1CecekhBLuIlXXEugSFIbh372awn1HRNWnN+HsEVgJDjnj8+Z8a/qDEcE/jxL5eADnJvsYBFHCEPiObCfBCGnsiaO79EAhvkGLF6rA0DwujBXR3+PymQOlhAmPLPcquWx5ygDqzYP6CIL5KH8e/kZ5KyipzA50iULnlS0irDaki+NUI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 16-03-26 22:38:34, Pasha Tatashin wrote:
> Currently, LUO does not prevent the same file from being preserved twice
> across different active sessions.
> 
> Add a new i_state flag I_LUO_PRESERVED and update luo_preserve_file()
> to check and set this flag when a file is preserved, and clear it in
> luo_file_unpreserve_files() when it is released. This ensures that the
> same file (inode) cannot be preserved by multiple sessions. If another
> session attempts to preserve an already preserved file, it will now
> fail with -EBUSY.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
> 
> Background:
> Because LUO preserves files of absolutely different types: memfd, and
> upcoming  vfiofd [1], iommufd [2], guestmefd (and possible kvmfd/cpufd).
> There is no common private data or guarantee on how to prevent that the
> same file is not preserved twice beside using inode or some slower and
> expensive method like hashtables.

OK, I guess since this is a single bit, we can live with that although it
seems a bit wrong that LUO needs this in generic struct inode. But all
other "cleaner" variants I could think of were just an overkill. So feel
free to add:

Acked-by: Jan Kara <jack@suse.cz>

Just one nit below:

> [1] https://lore.kernel.org/all/20260129212510.967611-1-dmatlack@google.com
> [2] https://lore.kernel.org/all/20260203220948.2176157-1-skhawaja@google.com
> 
> @@ -744,7 +746,8 @@ enum inode_state_flags_enum {
>  	I_CREATING		= (1U << 15),
>  	I_DONTCACHE		= (1U << 16),
>  	I_SYNC_QUEUED		= (1U << 17),
> -	I_PINNING_NETFS_WB	= (1U << 18)
> +	I_PINNING_NETFS_WB	= (1U << 18),
> +	I_LUO_PRESERVED		= (1U << 19)

Add comma at the end of line here please so that we don't have to modify
the last line again.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

