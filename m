Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E974FCA0FF6
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 01:52:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 106BA8E0007; Thu, 28 Aug 2025 21:52:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B71D8E0001; Thu, 28 Aug 2025 21:52:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE8A78E0007; Thu, 28 Aug 2025 21:52:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA64C8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 21:52:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 58CC11604F1
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 01:52:53 +0000 (UTC)
X-FDA: 83828121426.04.F184E81
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id F204C1C0002
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 01:52:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yvM2fhup;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BCXIM4gw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yvM2fhup;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BCXIM4gw;
	spf=pass (imf21.hostedemail.com: domain of dsterba@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=dsterba@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756432371;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m5PjV1QuRgaFx0hIiX2Widzl5+PIyq+xRHTpwMuiIVg=;
	b=qhUpBYombAFue6MjVnnJC3D1sk7xQYJxRsVqkpG6YENWCZfCgaxpvZPUzCIlVDVNU3xI5q
	XrBvbLQt7zVa3y3NUoBByld56ioXVgqtotX8EP9qBaFd1jUBo7e7jm5M7gT2Fpqt4yqn3j
	jgakbH4qCT0KuT1Jh773WOw0mjh19L4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yvM2fhup;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BCXIM4gw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yvM2fhup;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BCXIM4gw;
	spf=pass (imf21.hostedemail.com: domain of dsterba@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=dsterba@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756432371; a=rsa-sha256;
	cv=none;
	b=EGYSBK8nl4ADx1KbBoJzw1hQNaEl2uVyyV6O1Uk25zBMpuqigI/7q3Yx4yFj2VgisBjbMY
	Cge9dDv7gJRbEigB5Zq/u6k7t9FpIlFZmiy2lJ1sZF/21Wv9ifyeyXG/D6E8sTEe+xGa0U
	vh5f5lHx0HA2CSFlt42FaoaWOtAA4z4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 15DC933A80;
	Fri, 29 Aug 2025 01:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756432369;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m5PjV1QuRgaFx0hIiX2Widzl5+PIyq+xRHTpwMuiIVg=;
	b=yvM2fhup4rBkZcITx5B+l6Aj3FXyJw4oxIsu3au2HfR1WSnCAswugdHO1SoviztjZYfx/6
	HbclGBBd25M/K80U0f3GAMZ2fh3U6iwCKVjosqLjQMoiPT9GUJgIqJNvXOmdjnAjLCPgoV
	YpVCaEq93eb+H+UhOGw0sPFelO1SuRE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756432369;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m5PjV1QuRgaFx0hIiX2Widzl5+PIyq+xRHTpwMuiIVg=;
	b=BCXIM4gwGM9NlgtoMDV+uaSe5/qq1Ysi47ADNXsSJHjYTRQUdzN2FTx10XPimgLzEbFKRq
	oFQccs21R/F7QvAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756432369;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m5PjV1QuRgaFx0hIiX2Widzl5+PIyq+xRHTpwMuiIVg=;
	b=yvM2fhup4rBkZcITx5B+l6Aj3FXyJw4oxIsu3au2HfR1WSnCAswugdHO1SoviztjZYfx/6
	HbclGBBd25M/K80U0f3GAMZ2fh3U6iwCKVjosqLjQMoiPT9GUJgIqJNvXOmdjnAjLCPgoV
	YpVCaEq93eb+H+UhOGw0sPFelO1SuRE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756432369;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m5PjV1QuRgaFx0hIiX2Widzl5+PIyq+xRHTpwMuiIVg=;
	b=BCXIM4gwGM9NlgtoMDV+uaSe5/qq1Ysi47ADNXsSJHjYTRQUdzN2FTx10XPimgLzEbFKRq
	oFQccs21R/F7QvAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E9B9613310;
	Fri, 29 Aug 2025 01:52:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hpziOPAHsWg0EQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 29 Aug 2025 01:52:48 +0000
Date: Fri, 29 Aug 2025 03:52:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Boris Burkov <boris@bur.io>
Cc: akpm@linux-foundation.org, linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	kernel-team@fb.com, shakeel.butt@linux.dev, wqu@suse.com,
	willy@infradead.org, mhocko@kernel.org, muchun.song@linux.dev,
	roman.gushchin@linux.dev, hannes@cmpxchg.org
Subject: Re: [PATCH v4 0/3] introduce kernel file mapped folios
Message-ID: <20250829015247.GJ29826@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1755812945.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1755812945.git.boris@bur.io>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F204C1C0002
X-Stat-Signature: 5w3d8meordcce55ad9uzce1uyocmx63f
X-Rspam-User: 
X-HE-Tag: 1756432370-803634
X-HE-Meta: U2FsdGVkX1+4wDazva7xbHw5AqgfTzogtpDIW86f/ERqxhNEkssbOkWw0uHYGm9tOuKXzZNUfMr0/Ae9tQq5AtfTwDRQQCv5FsMAYqORXl/UzTHGtRMtnbVEvN2pzg60JI0ombiq7OHGCbwoIyyiBULV9HMOW+eefikz4J31asyLvvZz4AjMEnIdg4Cj2S3p0Y13gWXCIvpYxih34s51d+jNAMzGWdKtqET49nEYPVLJy+MUsFdcgu69vWQdRtnRTeDjma/xsX5dXGNhp/sClsqHzxJ91SeSow++xarOMkjHcUKhxXyCdZSx6xqkJHm8oOvcaEebyHVdlJSRkcggaNYUof1dj2onMrixQTwfr1Rznw7clK0lUGCdafrSKAeeQhOejl2+8IN06U8cqiU+gbz3pPnIta8E9yUnS0TvllZSC2BM4tYtBdrPdbTxLKwE5OIAVPF8yc1+okqyC8ULRKh0u89+I4+ZwivOBSO7gOx9VwP//Yq387d/MdCaniiRbePrkmrYGSnOeZWinFSuWreNqYK8Tx6oyZ3R+/5izJQrNlGfjuusAoctDVRhcDBxvMO+ICpvRgeJ3DIW0G73Flnsc9wH06Zal7OqSosXM7MPhjPE6UMRE+rcV1Dxss4TphWfw2Cb+zmqjXvx++PgsbtriTh+xsg3pt021ixmbqM2beCDhbPLLViicIAOiWq3djhTG3Ox5XVA7MgW8u0KKoYhjqdI/6CSpbQTQedGCwOUtRssTIENVbKjoXnym4xLPrOWgHxnbzdZQg0OXHwzQIM80gZpehsDHNh30iL2h6wGqitZkYH2zayRkRwrjYDjeWNqjW3ItPjnGdhl1vtRvXjVHCos2aL1blgrW/jY8fpB2SkyDaJaL0YeRHS2QQZcLSTmkEp8DzsSwR6RaU+20RAiAbRtQDF/m/gVkTNIqL0AIE+VeZCGGrVIG7CVVngnmFLzkjcuh+6H1Drbhxs
 0re5kujU
 98/s/8Yda8keift5bcoh6DbKWPTMqSRaOSkjYNh9R4bXN4qY2W/HOysnK8gJCfLkEe+0rAnRU28iIJ2aD8E+7fFZtnwmCP/NtI2h3stf5PM7ifiW7qSBPHLXl4eO62hKP6Jf007e6dc7PT/sn6vPX9UILI84dJga7kvSHG/qaxP53nIMRbhnCQmJ3cfv6qhZFUawpZkzhzzph0tP/ul5no0WSVBXNZ5T1l+TM6KBgAuDZpMN5hAbnUsQjTjG+3cwg3iM8YiH99CKaYoVJrSghF+YK6INGbNYqnFEz4+vcBxNiCvtkzEkWYhshxM7hpAmwDJHWzwknTXdcQdVighIoBE2mrH0HmEIZ2mIcsYimISnX/hto97QWJlnOfBFxfSVHLq5osMPQxQhSk32pMOW6TxiDEj15pLrzYA0ogaRm2XDa2qD7cla+W3PzEA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 02:55:34PM -0700, Boris Burkov wrote:
> I would like to revisit Qu's proposal to not charge btrfs extent_buffer
> allocations to the user's cgroup.
> 
> https://lore.kernel.org/linux-mm/b5fef5372ae454a7b6da4f2f75c427aeab6a07d6.1727498749.git.wqu@suse.com/
> 
> I believe it is detrimental to account these global pages to the cgroup
> using them, basically at random. A bit more justification and explanation
> in the patches themselves.
> 
> ---
> Changelog:
> v4:
> - change the concept from "uncharged" to "kernel_file"
> - no longer violates the invariant that each mapped folio has a memcg
>   when CONFIG_MEMCG=y
> - no longer really tied to memcg conceptually, so simplify build/helpers
> v3:
> - use mod_node_page_state since we will never count cgroup stats
> - include Shakeel's patch that removes a WARNING triggered by this series
> v2:
> - switch from filemap_add_folio_nocharge() to AS_UNCHARGED on the
>   address_space.
> - fix an interrupt safety bug in the vmstat patch.
> - fix some foolish build errors for CONFIG_MEMCG=n
> 
> 
> 
> Boris Burkov (3):
>   mm/filemap: add AS_KERNEL_FILE
>   mm: add vmstat for kernel_file pages
>   btrfs: set AS_KERNEL_FILE on the btree_inode
> 
>  fs/btrfs/disk-io.c      |  1 +
>  include/linux/mmzone.h  |  1 +
>  include/linux/pagemap.h |  2 ++
>  mm/filemap.c            | 13 +++++++++++++
>  mm/vmstat.c             |  1 +

For the btrfs parts,

Acked-by: David Sterba <dsterba@suse.com>

