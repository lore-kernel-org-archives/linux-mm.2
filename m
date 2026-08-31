Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB28BC61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 10:08:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3B006B009E; Mon, 31 Aug 2026 06:08:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E135E6B009F; Mon, 31 Aug 2026 06:08:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D04DA6B00A0; Mon, 31 Aug 2026 06:08:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A442F6B009E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:08:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3518312039C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:08:40 +0000 (UTC)
X-FDA: 85161140400.17.A37D6EF
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 132F6180007
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:08:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wvCAPAaO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MuNFlc0w;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Uzb2LIye;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2QEJLTbQ;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788170918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lA5FCsiRqGndfeMhZtC7v36Drbd7FKDYcliDfcaFBCA=;
	b=L+SgzvjkM+BlpoxhNnVfqNSOnpc2Ec4JLGSyLepcu2PD23936klSUdxH/On51JH+RCAmBQ
	fk3W2Q/zTX8vRh7uVXnQTnLX9PxjOomPlm4yzaHk9ZxoUkpG/1oSL/4lqqBrU2+D6rJw8w
	kSCgoNIOubEkjpwYsy10oUUlQskk5/Q=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wvCAPAaO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MuNFlc0w;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Uzb2LIye;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2QEJLTbQ;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788170918;
	b=v+2V62GHdFsbL6pAn7ZAxl7wZcN0xoeIxgiUcAzJ84vJXim7L+MzaQNMKXdNIfqbzo3Xgn
	fH0UaZ6PX9+cdMIjExtCGDt2vswpJv2zJvEj/YAl8LuXbzMv8mPrdTZijhDZYXmSnhqkNn
	o74yx/8ez7GKF14nBSgbssAgkDhqBqA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B04771FAAB;
	Mon, 31 Aug 2026 10:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788170912; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lA5FCsiRqGndfeMhZtC7v36Drbd7FKDYcliDfcaFBCA=;
	b=wvCAPAaOBjCH6h5DpcGNw20wGJraW6tqmFfCZRE4f0gB9Uldet5NHUI4/7ss0YhFfzjiUi
	Ib3XtHq+lR7ra/rHE57SPzW9JwUbR3boz3K17aubjxatwviLB59gnaatZNB2lS4P54uFl5
	sdLceqjzcCPyhFSxqs0pTeLheSXwxsk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788170912;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lA5FCsiRqGndfeMhZtC7v36Drbd7FKDYcliDfcaFBCA=;
	b=MuNFlc0wuVFNREQjM3uDInI1xqoKYuSIku37TCzfZRKnr3m8sObEzSqGZ/FZWxana9tuBh
	plS0E1jvKoMxVDCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788170908; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lA5FCsiRqGndfeMhZtC7v36Drbd7FKDYcliDfcaFBCA=;
	b=Uzb2LIyeuI2zzZ6PPJCUe3sYzl8wN3xZ45UCQ0bozlLNXU5s9kHegZuYzn+z08Z+iteFb6
	IAyEIvGBGy2dUmap0bFSJPtayw6duO9d0Gh93m8pb5tHjQAEKcvTPK+p8Ey+6liQIPjile
	ketJuKT0EYc9GbdtiBJWDiD3bqZdpJE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788170908;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lA5FCsiRqGndfeMhZtC7v36Drbd7FKDYcliDfcaFBCA=;
	b=2QEJLTbQMarN1cka2KHebxL2wHEsQtXf2BBQREtgNuzIvrRzInPCHYKgZM+PjsOG4QBFeH
	9hQozRRssdd46YCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8BC1213682;
	Mon, 31 Aug 2026 10:08:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GhsbIpxSlWpOeQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 31 Aug 2026 10:08:28 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 34131A13B5; Mon, 31 Aug 2026 12:08:20 +0200 (CEST)
Date: Mon, 31 Aug 2026 12:08:20 +0200
From: Jan Kara <jack@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christian Brauner <christian@brauner.io>, Jan Kara <jack@suse.cz>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Theodore Tso <tytso@mit.edu>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, ntfs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/9] erofs: Remove redundant FGP_NOFS
Message-ID: <7cb6z6bmqbk3dj7mwew3tiomxstzjigs5tel6qhbxmhej3rd3q@pajlpq7y25og>
References: <20260830041901.2668-1-willy@infradead.org>
 <20260830041901.2668-4-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260830041901.2668-4-willy@infradead.org>
X-Stat-Signature: to13qmk6wqhkm87pc5xixbcs3sn6mo9w
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 132F6180007
X-Rspam-User: 
X-HE-Tag: 1788170917-298970
X-HE-Meta: U2FsdGVkX1/v4ZYNxynGJJ1VfPGEHZujmkpEzXIV13/LZT1lhL3RoLHHclZM5HFjQq+tgRKYuU6ms/SumaPlEeTUrAwhstV0F30SSeNA6mIaMmdY7bwPUlVn7cjygkimv1SwB/PMbwxLZl9yLcmt9ES59eV0v3PGyV0sPVgt1cnmHxBoZQubea3K1/ce+cvIXl6bCHfmF1FBtLhtJaljJqeqgXDZWI424qD2ga8RJqKHYSPXFzHirto8jD/1od1YCw2Sr3szdCDT7fPudRS2FJppRLis5xo9WysLHfLH8AqhO+ZD1JzkMGqNedrinvmjvrTopP6KHnsI6P3nE76OkDlLZP0JRhqvWYxBF623R652ujlr20hXhceFnpRG/yd8c1JiLqyaENfiqCV+gX8JIRIpN8WSabykPxttVRyqTFp66yo41zyPs42p0Bm0rV95t7cz06kOT7oJRYK0NnV6TDN/AHnDnntsmDAOFVd4ls0ANF1MyLq1AUcYaY3p1wWG+j+LSHTasEbaZkKlxwk5gcp9gtE8aZylZp5eIyG3kMmXmZpVXX2E0qcT+sTBOwIN/LiR3WApN77e5//LE8OyS69lX1sAN51Li9DuBpo7Q+3nVN8AavnwOEgo0wkzxmwDcmsyVwZWp2QGo6EF9ghEq2vfKzJdVweVqdes9oXnPY6Jds9GYnhJT+6sfJCQWTLpL0rqOYU/hJD3s9/IGoufFiAX/eiZRiQ40XgnKoD6j4X2jUJvrX2saIxvjwQ41fLLmXPoI8gpAHxf/Q6fh9Q/fVkzJUBQZz0Vb3PoSx7BAUIdSKSeTMJs2yuqSaYzX5rKo48FFk2jE+E2rxvyeUice+kHO0WARtFb7pJSeCvXX1TBVGNgMSBHkcAVFer5zMFNhr5y7Sx9ziSzHM1j9tMjFSWhXjNAY+6n0pC3xKO7CsW2LsnwXH7TEcH1AYSFuvLTrAiFZ1yBFan9obZkzzl
 C7vpqnhY
 JjacoaldfWG1ufhJ18n7mY6Zav4xkB57dX54SRPywLLjUTD2dUAcKEAc3KSO2/7f6zIeaqCmRM5R+YUCZ9zLKtzCDhN3GojPuMfZY3McM/GYiW59fjVruZjwpsLN9/+7PLbIxFvP6CltHb39PNzY6N6iBcz+6PJr5UnECrPqRcIJgC1nSOfWMtrRSOH2JIIfhsor5+iNkLagN9wAcajMvyuvabD1L7o9Yc6Ceo9Ww+OhGHSREH7qLlSayfDwmXbH2bZk2lyf2FfQQ1dSvGHAFDk1dfOXxEhHznEMlCzAjSnKZS/Bs/YYxBeZzYqEjEn7diC5Wb8U03yN91WfzwvCBzBSGJTNurP+7SOWWByTxOgPaTUITVYcpQ8GnNfHHilPmKcz2TqikmbEie0W6kSJ6j52OScq9yp7PWb8KMfPaaGHDmb6LP4XLS6RmkVVmIZtitKMIj/G9FLKFT/yrlTmRJ+9qfqHyqKGuMfu8T3yHx43bPbJ+vYg0YwUAn3BS0DXM5DbX0RtTJRwSUQc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun 30-08-26 05:18:50, Matthew Wilcox (Oracle) wrote:
> The flags already include FGP_NOWAIT which prohibits all reclaim, not
> just reclaiming from the filesystem.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/erofs/internal.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
> index 65974e57aebf..84b3cdc8e88f 100644
> --- a/fs/erofs/internal.h
> +++ b/fs/erofs/internal.h
> @@ -327,7 +327,7 @@ static inline struct folio *erofs_grab_folio_nowait(struct address_space *as,
>  						    pgoff_t index)
>  {
>  	return __filemap_get_folio(as, index,
> -			FGP_LOCK|FGP_CREAT|FGP_NOFS|FGP_NOWAIT,
> +			FGP_LOCK | FGP_CREAT | FGP_NOWAIT,
>  			readahead_gfp_mask(as) & ~__GFP_RECLAIM);
>  }
>  
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

