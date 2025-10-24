Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26226CCD1AB
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 12:11:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8291D8E0083; Fri, 24 Oct 2025 08:11:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B1238E0042; Fri, 24 Oct 2025 08:11:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6799D8E0083; Fri, 24 Oct 2025 08:11:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4DEDA8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:11:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1567249881
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:11:16 +0000 (UTC)
X-FDA: 84032892552.21.D950BAA
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id CC35F40011
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:11:13 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gw12pWJ4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="b2hgw/mR";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gw12pWJ4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="b2hgw/mR";
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761307874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NenQ2Wom+07dIl2jW8BeU68cV0chgqY+KBmPwDVWLbw=;
	b=YOLAOK7liDQ/E+SZNZ2ry9An2YWXh8EKaUT4RDmYILcXWkoHHoUB49BDPiDNm418R4/lyH
	Ri+W4TqjKnaP3mBh3bKIk0CA0joEXWr/ppaBKdq3Z4Pepd3ZGWRffDOcGdNqx7cgIX62w0
	32IJk0jSdZHFXsLfVRByppbJ5SFtifQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gw12pWJ4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="b2hgw/mR";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gw12pWJ4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="b2hgw/mR";
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761307874; a=rsa-sha256;
	cv=none;
	b=ode2cQ/0QfGkgpj4tv71dkCyOL+eQfo1VoN2Y3hdUjcJbp4BDaF4LmRdhiQTnrI5n/FoxI
	7/SZYxJyNsQ+aiICjUyE0KTlzPzDSHhTbz2SPlb+KFQOIq30Kki5iQVN9CgTa5lkgCKS/h
	YOzbUfM+SRWi6ZzGOXYM2nitqRCj/nU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 47B581F38D;
	Fri, 24 Oct 2025 12:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761307872; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NenQ2Wom+07dIl2jW8BeU68cV0chgqY+KBmPwDVWLbw=;
	b=gw12pWJ4dBervOkm4c1wdpprEpUqlQeWPArxYlUpX+1wjQaYgBlWw9o1llMEE7NqtHZ00v
	Xwu5paU0pUZgqU7j4Y44qNPMavuA+1pvb4L6prQKH89bIn60BpNivnCVRYVnb+NV/td2lB
	+uPdROXqPLp7tKETWM5DKokgMabTyEE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761307872;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NenQ2Wom+07dIl2jW8BeU68cV0chgqY+KBmPwDVWLbw=;
	b=b2hgw/mRbq2JF7vAhHufNUG/FiOVZulsx+5sZnxygRLE3d2wabKfCkXCLqn+k97//SK6wt
	jbZRwwG/DEKPw0Aw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761307872; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NenQ2Wom+07dIl2jW8BeU68cV0chgqY+KBmPwDVWLbw=;
	b=gw12pWJ4dBervOkm4c1wdpprEpUqlQeWPArxYlUpX+1wjQaYgBlWw9o1llMEE7NqtHZ00v
	Xwu5paU0pUZgqU7j4Y44qNPMavuA+1pvb4L6prQKH89bIn60BpNivnCVRYVnb+NV/td2lB
	+uPdROXqPLp7tKETWM5DKokgMabTyEE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761307872;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NenQ2Wom+07dIl2jW8BeU68cV0chgqY+KBmPwDVWLbw=;
	b=b2hgw/mRbq2JF7vAhHufNUG/FiOVZulsx+5sZnxygRLE3d2wabKfCkXCLqn+k97//SK6wt
	jbZRwwG/DEKPw0Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 207C413693;
	Fri, 24 Oct 2025 12:11:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id S0znB+Bs+2iwNwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 24 Oct 2025 12:11:12 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7DA6CA28AB; Fri, 24 Oct 2025 14:11:07 +0200 (CEST)
Date: Fri, 24 Oct 2025 14:11:07 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, 
	Dominique Martinet <asmadeus@codewreck.org>, Christian Schoenebeck <linux_oss@crudebyte.com>, 
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, 
	v9fs@lists.linux.dev, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	ocfs2-devel@lists.linux.dev, linux-xfs@vger.kernel.org, linux-mm@kvack.org, 
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH 07/10] mm: remove __filemap_fdatawrite
Message-ID: <kxl45u4l5u6vrecxj4ib7uxmptv6x6heksachfymh3ffu7xl3d@bza4durxfmhp>
References: <20251024080431.324236-1-hch@lst.de>
 <20251024080431.324236-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024080431.324236-8-hch@lst.de>
X-Stat-Signature: hoebfrndifazna4fbhjaziu6owquw7ob
X-Rspamd-Queue-Id: CC35F40011
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761307873-915807
X-HE-Meta: U2FsdGVkX1/MAZZ/lJ01UHhcjPsRjeWB0K2X7MstLjNSuT7+AttUM74oLdW25/4gHflcIBFiqnSvPgWA/gVOlssl5/UtZNer+XY5YstEvPw/DuG03K0HeV1Qo+qRq8ETY8hA1o2GoXji2eUT+2sqOHrlfPLMWvjzUzWdGtp77H1a+CYl0eoecjseKz1t88CTnqbhaqX29zKBdIIUUOJodnjGlpHDwBNwTpodnca90sDDSmh/8mvS7VlYQ06fOH8L/BQS2CsNx53sBkZ2ugLlm7QBc4Ecf70oBKC1+yrMPHIxnOdYq4IyZkrSRWGWRmeg4PmsOy+23XLG96i3TXzB1QIpHeHlLT4blX6fJlvJCpjGh0GHc7v0UGdJ1ZYQ4PJ7PoNMoj510ab8Vrotr7Ya3SaICaAL/f+BAdBHgu+xcHat0HrZ5daMoX8USUmsKdekB8paNv2OqBfie/PsCCBCdWtv5goRwtcDvcGQjgElEsz7n5Tntqsmlkutye8JE667GvvomcegGwDQAJ/Kk0ZLuaKW6hJ0fweBOT49CuOkq1FzYSDrg47NWU5LaCFHpmCbYMYsqPQlN1tzm0sfptXYQZUps3V4v94rmxvD+TTBgp0rME3KMRRdJJBBg6xEJ8WU9ZGioK+YAJ1XO6fOrMGfcAyhtRYOtB7hLacXr/5O7zLE4MVOy7R2Sl6zKO7lICj6//AW0BHh3cSKHZs6nA7TowPkyaWVwF1nncOm8YD8f5cbXmZ6XaSj8hgrCCXdg/lc8eYgpf3gfuTSNIqw3aw5YyAJs+bD0jFmAZyE4NYTiHzgLBhRiMIa0eCAYQUnBkWCWqNNkfy8vsz9IW+c8my7N0D8EDLJ5Yph4k0ucwndbATunOjWJOETKjtB8jwEKmLT0Vz81ecrNhwPr2Af49lcecXAdELOF5TEGh2SyKFGY6sEghS0QGaYP826vvGZbDS+CLvFXsVkFzzA28eyaq2
 QnSv5fUr
 slJ8dPd9KKFTPxvSwkQ0JXDxWQP0hK+e/fx8dnfewi+KQu/KpZRtyZDeFqc+bkSdgD/9xIS7LiPhJ5SPr8Zl5OwC9gzOs2ylBpuLnd11jP5loYpOPaJ+zD+di95vTfQS4acU/Ztn7iC5Yw6xS+Ffg5u1JGBNDuSxLRL6dgSnGBYkbYU2pTSonJNm995SP0mO1lu7KmPh4fSzv8VUASwGdAjb4m2DIUalADJB+gDJwTWZXgn8jMWQrPmFLSWACzotDCsAEKXJ8sBlPBxWuTj2aRSZeEMhX8wa+vE/F7yvK5pBa2eI87YMIjCmgOEtURIEwGAlD/ss2httP1z5tHpj1bn+SdP9vakrk9FDDlj9jAdAhzVEhUBnlTETHjZNn+bpdwcQrvt6ZRLFe0eeGrrNfuTc4IQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 24-10-25 10:04:18, Christoph Hellwig wrote:
> And rewrite filemap_fdatawrite to use filemap_fdatawrite_range instead
> to have a simpler call chain.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/filemap.c | 18 ++++++------------
>  1 file changed, 6 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index e344b79a012d..3d4c4a96c586 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -422,25 +422,19 @@ int __filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
>  	return filemap_fdatawrite_wbc(mapping, &wbc);
>  }
>  
> -static inline int __filemap_fdatawrite(struct address_space *mapping,
> -	int sync_mode)
> +int filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
> +		loff_t end)
>  {
> -	return __filemap_fdatawrite_range(mapping, 0, LLONG_MAX, sync_mode);
> +	return __filemap_fdatawrite_range(mapping, start, end, WB_SYNC_ALL);
>  }
> +EXPORT_SYMBOL(filemap_fdatawrite_range);
>  
>  int filemap_fdatawrite(struct address_space *mapping)
>  {
> -	return __filemap_fdatawrite(mapping, WB_SYNC_ALL);
> +	return filemap_fdatawrite_range(mapping, 0, LLONG_MAX);
>  }
>  EXPORT_SYMBOL(filemap_fdatawrite);
>  
> -int filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
> -				loff_t end)
> -{
> -	return __filemap_fdatawrite_range(mapping, start, end, WB_SYNC_ALL);
> -}
> -EXPORT_SYMBOL(filemap_fdatawrite_range);
> -
>  /**
>   * filemap_fdatawrite_range_kick - start writeback on a range
>   * @mapping:	target address_space
> @@ -470,7 +464,7 @@ EXPORT_SYMBOL_GPL(filemap_fdatawrite_range_kick);
>   */
>  int filemap_flush(struct address_space *mapping)
>  {
> -	return __filemap_fdatawrite(mapping, WB_SYNC_NONE);
> +	return filemap_fdatawrite_range_kick(mapping, 0, LLONG_MAX);
>  }
>  EXPORT_SYMBOL(filemap_flush);
>  
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

