Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 074CECCF2D6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 09:16:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18DC96B00CF; Mon, 19 Oct 2026 05:16:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1653B6B00D0; Mon, 19 Oct 2026 05:16:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07C3C6B00D2; Mon, 19 Oct 2026 05:16:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D2B0A6B00CF
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:16:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 59CAFC0486
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:16:08 +0000 (UTC)
X-FDA: 85338819216.11.1016E20
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id 23EEAA0002
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:16:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ghGHOwZ6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NiyW3Nok;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yC77sQaB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OXbTTu5b;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792401366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7yu3tr/XKjY08A8K99OkNRH8Z7mvGFgqqz1CA7bGCoQ=;
	b=umOXntdwK/+5l6IFdI0XZ4oFMF348zDpTbCT9VCHDrIi0DzQ7B0IIUAHiCMTkLdE7iX0Jh
	0j6m4FT2b4G9y1C9s+C7PjxALK6wmUJECtzjD1VIUB7KG2lY4Sw/UoxqxA1N18MQOaotu0
	47SYgSCuECxavJB5XolMnL9ueQQd7YE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ghGHOwZ6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NiyW3Nok;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yC77sQaB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OXbTTu5b;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792401366;
	b=4sfqB6Ndy91UQ5ndq045fXB+K9RYQb+FzjUkbjhJSNV9aaa+e5TgRKJ0SUkXfazbKrngP2
	6J0l/wyZyOwAw/OgAvxkANm5Y+70jRGpYbHR33QT2m+GYgiVtqRwOOHcAzy4ttcqjQ/a2u
	3KLVNklmRFEmpJVRAXS7t/85ye/JzOU=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 36E7721C13;
	Mon, 19 Oct 2026 09:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792401364; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7yu3tr/XKjY08A8K99OkNRH8Z7mvGFgqqz1CA7bGCoQ=;
	b=ghGHOwZ6JxMIYAZ26rWhTpweaoCboTRlTL999bMVvyF0E2aZvlajC6BK/JwQUb+GP8T6vZ
	QpYJUF6W+y1mzomrimeyLNCvmnyrxjwp7Seri96i1piyel8vRzZVgO5dZWa2mhLkRaC+hO
	33rSbF30BBO4HAdoMOLbGOQBAaetndA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792401364;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7yu3tr/XKjY08A8K99OkNRH8Z7mvGFgqqz1CA7bGCoQ=;
	b=NiyW3NokfsPA3E7a9inhFGaT20Sl0YlKV0Mjp7kg8WBDh3ren76IclmzfKPO6t+0UBeewT
	Aln5ixT4mweAfjAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792401363; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7yu3tr/XKjY08A8K99OkNRH8Z7mvGFgqqz1CA7bGCoQ=;
	b=yC77sQaBlmmo4b7SixoP8v0ykVb8nEozZqjSpHaFK0Q0fFqDF87llv3DaPBzNzh5CWKXxE
	8gosP/5itJsjOS62NqMDVHZ6RE8KHwU6Z6TD/DQLBDRiRDdTI6GbVTal3EcB41/okvGfzs
	XYhpDE6XhOp3uEX3iDXLm00HlOVNL9U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792401363;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7yu3tr/XKjY08A8K99OkNRH8Z7mvGFgqqz1CA7bGCoQ=;
	b=OXbTTu5bfXVm5PferY6twjbDiPg/4EpFJsGB4+Iw+QGZxYgpoXGqIFOBisjJhNvUhGnAuO
	Hh+gTeNTZwQ1Z6AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ECE25134B3;
	Mon, 19 Oct 2026 09:16:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1ML/MNLf1WrwFAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 19 Oct 2026 09:16:02 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 772FAA1413; Mon, 19 Oct 2026 11:16:02 +0200 (CEST)
Date: Mon, 19 Oct 2026 11:16:02 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linuxppc-dev@lists.ozlabs.org, 
	linux-gpio@vger.kernel.org, linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	freedreno@lists.freedesktop.org, linux-media@vger.kernel.org, wine-devel@list.winehq.org, 
	linux-xfs@vger.kernel.org, io-uring@vger.kernel.org, bpf@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] file: simplify and harden cleanup handling
Message-ID: <p4eitjefwpwhfouwhmvxmelxl3yncv3vjdi7wsgu7rna2zorqd@rlvbcpzcpbid>
References: <20260917-work-file-fd_prepare-v1-0-b87534ca49f3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-work-file-fd_prepare-v1-0-b87534ca49f3@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 23EEAA0002
X-Stat-Signature: kx6dixyzmu4kcjn4ydkjoohm3ok78fng
X-Rspam-User: 
X-HE-Tag: 1792401365-985788
X-HE-Meta: U2FsdGVkX1+AP1He1OxKJNXjx+GtDBmbLMRjmg367g+o8EJu59cIbNLK7Fb7arVKw/EU2FpRU7BmxepVrMEN5llZ69GhtWqDgguYd8J0c9YPhVX4qC4LxJ8eFQaNW3Hj2DrX2DhRTqV5G+/h264wr6hhZak6bScJfwIgHU+figY15jZE5BmagWUC3JHq5yJdMwnHOAFwhW1VPGPqdPbhklf3Bog00Mf7+gQkF5osBzU2AkYfn3ianzBciX3H0yiPIsjHe9QUO7Ujo/vuynNDbyOyZorwdVOrYmDRl85+1uhYu8twozI/Vm1Kcb7Ytx7y1749Mmrl9EUk8ITGKCXeoJS6m1cx42CkFEZJfJ6OSPtUmiDyyKQ8/wvwCiO5ge0hV+57MaDQ4ZTvvHNlQ5FE0YfPQT+h8BW2wD3YCB/muTvshcJ7Ik9+R2jN0ByXgZ9G0oCJgSqxqs3NlUu+hxEKmlCr7BCknel+syTjwcixh3sHBU+KVe3963YIZ4lQBkt3Sy/l7DOoVXXLw72fXIdQpiBQE60lTKY8diZ00zY1jHGdjN1LfUPiRqP39ikorbaOEsybB97XgWHGThnl+dd+dVsD0aNtvapcmy27sBMyHT2uUDel+YYs80ssL7hXQKBo094hi06sm5fRFzHZehCmyyIJnGt0zV96cZdsHtB/1BDVeLr7/1zVgp49hnMeeP0Chybx6DZNGlR5h5RiIf8YuWMcnnAvCo24v1+H82fAXRQKWYKmyC3AlUYak4QOptPMMvH8gFK8qVXMvT7DXVxD4q9C3NX8K1nLD775/zlLPK03bv2yu7wLXh311fNhnFl5CcEoGzkANDEGh8Ut1sS5iPAUxuj2AFsEPyPsA17gTwTg1Vt58xoR4LgxCAD87WuJCiyIdp2lVqle9rDpUejxzdnVPh6nM7QRnz73RdSE40YDc104uMy6RpWq7jB+8Xr7AKRy0hVKbggK3fyeaOx
 yBmGJhOw
 BcLVgbROsq8/mBJD0qahJhRGPYlnwImN8CGPw3NLoD0EQOWssjIignWZtip3qU4wL+o/NeerTCS951xPhi50cjys/jb5IxMP6QC9xWA2+z+NIkC7GWOwhw0VcrEF5J/fTYiVUk7gq9T8rz0Xs/2AT6iyP3MuJZOdyrMkB84Ify/y82RUTC945fHyeMYwu/CMSgZKB6qaoMMiW5V8llUIpAEU1/aZI2ZREH28al7scAI+Ujk0sHh4WvUecmRzieBhCB5KTWFUVm5vfqaPjApxDrpG2wK/5BpT6UvNalhBB6B/lw+RWvhl31NMA10rqG/X+BMmkGPsDZEfdx+m2YcCnsDKJvmhVplR3aYNsWsXISLjS6os=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 17-09-26 11:09:41, Christian Brauner wrote:
> The cleanup guards rely on unnecessary infrastructure and make the code
> more complicated to follow than it needs to be. Clean it up. Also shrink
> the struct a bit and get rid of the unnecessary error variable. We can
> just make this more ergonomic by using fdf->fd directly. Also expose the
> struct itself as const and hide the actual underlying local variable
> behind a UNIQUE_ID() named variable so we avoid risking shadow variables
> and polluting callsites. Code generation wise the outcome is exactly the
> same but simpler.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

I know I'm really late but FWIW this looks really great! I know this is in
PR to Linus so feel free to ignore:

Reviewed-by: Jan Kara <jack@suse.cz>

;)
								Honza

> ---
> Christian Brauner (4):
>       file: simplify FD_PREPARE()
>       file: declare the FD_PREPARE() variable with __cleanup() directly
>       cleanup: remove CLASS_INIT()
>       file: make struct fd_prepare const and kill its err field
> 
>  arch/powerpc/platforms/cell/spufs/inode.c |  12 +--
>  drivers/gpio/gpiolib-cdev.c               |  18 ++---
>  drivers/gpu/drm/msm/msm_perfcntr.c        |   4 +-
>  drivers/media/mc/mc-request.c             |   8 +-
>  drivers/misc/ntsync.c                     |   6 +-
>  fs/eventfd.c                              |   4 +-
>  fs/eventpoll.c                            |   6 +-
>  fs/file.c                                 |   8 +-
>  fs/namespace.c                            |  12 +--
>  fs/nsfs.c                                 |   4 +-
>  fs/xfs/xfs_handle.c                       |   6 +-
>  include/linux/cleanup.h                   |   7 --
>  include/linux/file.h                      | 130 +++++++++++-------------------
>  io_uring/mock_file.c                      |   8 +-
>  kernel/bpf/bpf_iter.c                     |   6 +-
>  kernel/bpf/token.c                        |   6 +-
>  mm/userfaultfd.c                          |   6 +-
>  net/core/scm.c                            |   8 +-
>  net/handshake/netlink.c                   |   8 +-
>  net/kcm/kcmsock.c                         |   6 +-
>  20 files changed, 117 insertions(+), 156 deletions(-)
> ---
> base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
> change-id: 20260917-work-file-fd_prepare-ea5966d68a95
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

