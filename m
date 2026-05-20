Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F20D9CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 10:57:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 668FD6B0005; Wed, 20 May 2026 06:57:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 640DE6B0088; Wed, 20 May 2026 06:57:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5309B6B008A; Wed, 20 May 2026 06:57:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 420B96B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:57:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D92C68C6DA
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:57:15 +0000 (UTC)
X-FDA: 84787496430.17.6C2971A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id CC24BA000D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:57:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vo2KQOz5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ARz4FRXu;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vo2KQOz5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ARz4FRXu;
	spf=pass (imf25.hostedemail.com: domain of ddiss@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=ddiss@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779274634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6kYOnY1NLP3hz4vVJSnAnkeHt6oJfDo6Aot7QkXO3qo=;
	b=iv6U5WJLfQp2DAetH015E7tMQxt2Y7Rvn2nqjYlcyaSup0V4CDVgdIWcjs18S+UP+a0x97
	fW/Wi2GOydO/jbfGNThB9SJG/PMBfawOGBxKatOOMOmgyNZM882snd2taCVPHMwRsBhOqU
	bpHpHrffHAV+KYu9GGLTdmU3ZiFyKG4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vo2KQOz5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ARz4FRXu;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vo2KQOz5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ARz4FRXu;
	spf=pass (imf25.hostedemail.com: domain of ddiss@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=ddiss@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779274634; a=rsa-sha256;
	cv=none;
	b=0NnPPJ39peRJ+oN2UxlX8pA5W/1dli2lBlftULhDwkgeBvRtaqnjBhluIh9cRcgPd2z6vq
	1SkFHLEmBlvo0T/4hWI8GVK0aWili4YEY9giU0gzo7M7WCuR6FcGb0wPTRjpsk8D3J+A31
	goajJWs/KLiK1+zcGegralPimfA7dio=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5C12A5D435;
	Wed, 20 May 2026 10:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779274632; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6kYOnY1NLP3hz4vVJSnAnkeHt6oJfDo6Aot7QkXO3qo=;
	b=vo2KQOz5E63hp05SxV86zHVJbtBN7gai126dcgSzm0uOubab48kE75zP2jSfXPlMgw/rew
	LKAPcJezUJx3SfdwnJTjix3NSOG/+7gBbY2905oKTcJElpuP5LZMbkQSEUUiH2KixlJlHT
	WyRO6xDPSjncOWhOOmX/zLw7SYXYzyU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779274632;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6kYOnY1NLP3hz4vVJSnAnkeHt6oJfDo6Aot7QkXO3qo=;
	b=ARz4FRXuC+gULBP8pWQMc3WCjYB/R1+L++d0AV6TlF6smdMwaCelQJkwDZ4Zcw4lLSs7Y+
	t6U+0/1s1tchOZBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779274632; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6kYOnY1NLP3hz4vVJSnAnkeHt6oJfDo6Aot7QkXO3qo=;
	b=vo2KQOz5E63hp05SxV86zHVJbtBN7gai126dcgSzm0uOubab48kE75zP2jSfXPlMgw/rew
	LKAPcJezUJx3SfdwnJTjix3NSOG/+7gBbY2905oKTcJElpuP5LZMbkQSEUUiH2KixlJlHT
	WyRO6xDPSjncOWhOOmX/zLw7SYXYzyU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779274632;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6kYOnY1NLP3hz4vVJSnAnkeHt6oJfDo6Aot7QkXO3qo=;
	b=ARz4FRXuC+gULBP8pWQMc3WCjYB/R1+L++d0AV6TlF6smdMwaCelQJkwDZ4Zcw4lLSs7Y+
	t6U+0/1s1tchOZBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CC9B0593AA;
	Wed, 20 May 2026 10:57:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MB4xIYWTDWp0LAAAD6G6ig
	(envelope-from <ddiss@suse.de>); Wed, 20 May 2026 10:57:09 +0000
Date: Wed, 20 May 2026 20:57:03 +1000
From: David Disseldorp <ddiss@suse.de>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH] init: do_mounts: use kmalloc() for allocations of
 temporary buffers
Message-ID: <20260520205703.590947d6.ddiss@suse.de>
In-Reply-To: <20260520-init-v1-1-aaf2ebac5ad9@kernel.org>
References: <20260520-init-v1-1-aaf2ebac5ad9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CC24BA000D
X-Rspam-User: 
X-Stat-Signature: enqooos767tm49hs1g3fq4z5ajg4zcen
X-HE-Tag: 1779274633-225070
X-HE-Meta: U2FsdGVkX1/ScuXqkJNzwlt1t1oOGgtGtIDCxcGGdWNFnQfqNYbaDQPNJLnebLEWQTPQgcJagaVKqzN19GhtBvEBfu7rCt4SWM6SfEOcZmBlzGeeQ8vWr0gGzJNFnLjGF8mnSBdeUJGNhcU1yHCp0f4zzAZ1vrnf/29Bzy8K20zccuzZkp6FN3XzK+4gJpWgMxhpz9aD95e+JlbxYjkVCrPsyA9ibZGv728mYBiMpGfdTOCE7Me9zYABMz4tFcXh+ZcYl2ye400yHOuBu7GZoKFWNiHx2wbx5qHBUeFBXPO7zKGp55YeF+VIgY0o50e7iUnf1n2WRr+AsFCGTudR3c98HAAG5VbPtiyQBamOgpFRL8dIWw86bTwh7byZbUV4HtAN+REDsdm+qjjTyLVIaVqj7W+OMRcNAmsfLBCCQUS4y0WxT5FEZjN/ZfdpZIXixeV4vm4lIYyefuxILHpP0+gFOiWtIOJI3I9BU1Hg4VMa7tks5c5ZaKfUfZxknzvzyWp2S8gV3DP40qJ9qaR4WoLnRM/ICQ8i6Xq0CQ4b2mHk1c9DJj5Z7mBAcmL8+ypYHtjuaF612GlCNeH0hK2X7SPV47779WqIARCeyhIGaZ7o3+uRahnKlY1R5uu/VyUk7aYqvuM+QsA3pt8b90OlEDRCWFW4vEO4ifDf9nnHs5PfRAfW7JblVHLS+3/zQUoOiaRUpBaTztr4MEiEvScvRteULtWmUjo9RM5pxDdp/dKVsy0UoNjzM7jFvH6EQkVm1KSliR+FDQ1v1UGyySQ4K7O06nLJXIjRQUv3EEuQsQnLa5bc2lYL75SHTuf7xiCjMi66VCvLAhyCAKSQ+1ydKEvCWFYfCQmiPR+3ceQGJsf+YZ99STfB4cW7doaUwOnKG8PLyxa15t4Yjo/lA6GyNIkhPL19Yb1HJT/RMLJ9sIAf49vxBkFhzWv3sf2wpPYHjWSmIBJKzfN3EmCEMDq
 gGompTre
 VH7XuV9oDCBXGnPjXBYxxQi5T85BbMG02nAd0RkEjYqhyeBuZUv5xX6SCMZk66F+RFNDVMR1BRKe1qYyJGrv33k4kfu0dipfyemM82fW0Ge1lvZ0SDZGFFR9ph9WFoPj4nZUmQ40X9io8jL/6OEVAXfoJellUeWc6nrGGNMaPvEzQjWGZloCIVLitfqLt99uF33N3ku52PaXAHrdhJCSfxDE4DXYtAlF1x/nimxTqKXJ+ivsmsQf/dDMiq2xt/Fma7YrIDHbrgeAansphKQGXtJzOPUkKE2iarGOssVomDayBzgL3bPnw/8YOMIubZogQqjUVXu4stW3mQBePpPwwLIo069FSROnIgaAav/HCUFCwL48m9p3l4yitnQPzHjX7DYqnQftWWXDkCgw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 May 2026 11:16:51 +0300, Mike Rapoport (Microsoft) wrote:

> Several places in init/do_mounts.c allocate temporary buffers for
> filesystem names or options using __get_free_page() or alloc_page().
> 
> Usage of alloc_page() APIs is not required there and only creates
> unnecessary noise with castings or conversion from struct page to void *.
> 
> kmalloc() is a better API for these uses and it also provides better
> scalability and more debugging possibilities.
> 
> Replace use of __get_free_page() and alloc_page() with kmalloc().
> 
> While on it, add a check for -ENOMEM condition in mount_root_generic().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Looks fine...
Reviewed-by: David Disseldorp <ddiss@suse.de>

