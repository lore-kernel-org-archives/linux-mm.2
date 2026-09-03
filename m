Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61D27C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 08:47:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C8DC6B00A3; Thu,  3 Sep 2026 04:47:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A0FD6B00A4; Thu,  3 Sep 2026 04:47:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B97E6B00A5; Thu,  3 Sep 2026 04:47:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 351E86B00A3
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:47:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B31851A0484
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:47:52 +0000 (UTC)
X-FDA: 85171823184.11.B96EF0F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id 509A814000C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:47:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EUz8hBvA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=O4QrIF0+;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mSgKNGw3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DChrvXuK;
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788425270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WRbi2rD+eFTwUJ5ZZTOJbWeHQrzHMzr4OJI3Dgz/GAY=;
	b=mMw7cAalTJLiaXFX41Z7tZoWLrJJytoufAls3g6xBGQN6RqZgW54qNwLQ8LaCoBEa0GLfq
	ZlmWEtAE4TAJQ/UCMi1k8kYlMl7nO7NEUXiW6Ny0JkOaSwqX6XZwtTh+jGybmcaO31e++g
	HYK+8geViJ/tdtT/NPzgOGe+gtCmulg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788425270;
	b=kDiKA+EEQWerwOkrmcOpQy0CnpUSrHuV7h4vGSYU1L2+OQuPuRuEZaN9xNYZgh5AMB3Ck3
	A9oG9ieQvhNUS9EcZmGf69W9c+0L8mhKZzXpbh03s5SaV56r5LFI0WzLiQoJ5lwCThEqG9
	TQuaLcQz9Cti2c4tu45cyN9xLpkDiWI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EUz8hBvA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=O4QrIF0+;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mSgKNGw3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DChrvXuK;
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7B6FA1FDF1;
	Thu,  3 Sep 2026 08:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788425264; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WRbi2rD+eFTwUJ5ZZTOJbWeHQrzHMzr4OJI3Dgz/GAY=;
	b=EUz8hBvApKxx5IgDTg/FlQC3HwWB9yyCE0LvVwnmP9MBTmBWo36+o29D7kf9SJY1YK05nt
	YvlW/VQuFWS3nm1Bk+LBi5woS24IU2sF3MLQm621xkRLtMmyGkA11f0wKTuY6EcCH8lRUU
	DPUbfVdEOfCGRVWQAHkCtc9b+fpShmQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788425264;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WRbi2rD+eFTwUJ5ZZTOJbWeHQrzHMzr4OJI3Dgz/GAY=;
	b=O4QrIF0+JZUFM2RfNEyE1/jKUPpJv2uA3CwDtKiJIdthO+4UMdFaHZ97hyHbDdihNyQxHo
	IFk9EzOD4nwmofDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788425260; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WRbi2rD+eFTwUJ5ZZTOJbWeHQrzHMzr4OJI3Dgz/GAY=;
	b=mSgKNGw3hUzw0ZA5DLotGb3bIcu2CXtGPQ6C33+rNEQJAoqm8sQJoQGIxf3Qd22sXdSjIw
	skfR+8avk9h0dTxwH6JBlFIOSku109Y2syqlHSgreKOZXmfe+Iut/zXSS7bsItI9lNW0Hv
	CVCLbdmnbRTdhyjnr1RvcqtqBHxppp4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788425260;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WRbi2rD+eFTwUJ5ZZTOJbWeHQrzHMzr4OJI3Dgz/GAY=;
	b=DChrvXuKBc/kE9j0IEbTY2enwJCh6DYNkDWWpqr6JfEnSOAy1XPZE/9qmtqvXy8wj+ge52
	ukX9ce6wXwiHwJAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5DAD5136E6;
	Thu,  3 Sep 2026 08:47:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JiTgFiw0mWrgOgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 03 Sep 2026 08:47:40 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E2081A0867; Thu, 03 Sep 2026 10:47:39 +0200 (CEST)
Date: Thu, 3 Sep 2026 10:47:39 +0200
From: Jan Kara <jack@suse.cz>
To: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, ocfs2-devel@lists.linux.dev, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Farhad Alemi <farhad.alemi@berkeley.edu>
Subject: Re: [PATCH 2/2] shmem: Refuse to enable tmpfs format for another
 filesystem
Message-ID: <hqcus3yg5hdnf42f6ccin3lmnzv6xzrbpev7c2qaabo3fh7wiq@jckmpvb36ili>
References: <20260902132458.23590-1-jack@suse.cz>
 <20260902133702.1313635-4-jack@suse.cz>
 <5f7e2e81-6a79-3b5a-1dc2-83ce775017ac@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f7e2e81-6a79-3b5a-1dc2-83ce775017ac@google.com>
X-Rspamd-Action: no action
X-Stat-Signature: xyxgo4pzykw7z46c38kt97wdfx9e36aa
X-Rspamd-Queue-Id: 509A814000C
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788425270-416560
X-HE-Meta: U2FsdGVkX181Joi4HmuKUpnYkptR0qm48d1W1RXsAOJmawtLy3L9tkZi0XT51gQYeMS3Ryjb8qAohmhrVxkRawGKI36MrMqxEbx4t8riYSyUhdRW6hrI+jTxZWjKgw6EjZAXqkpBd9z/3nOoMXU+yCCiwpUzmBOk7OCnJVHdiUgHcoDbk5JWjiN+eeHDNgAXUh9wtAMXWNLS+4EXLNsupW270hIz8YZ33jejstGXtZ4RTwurxv8HcHFhNtX1vt2oYbgSawALbr/Q+iT3WdViuSr2XiZzMYKLiCQw16RXcDTTOBaMZ9VMoibJgH4ibjNw0+EkPp2kMyyqJ6AxG2cboTdNQvkz5RyNnMNkupyCtKyTVmGmaiRzy7hEoCCvYOsS94u0RdYQsAH0nGy+c9r+GDwgoOAMSNCxfZaHG2DnX9by+WxzrnEkkGeDYzjomWJn5z54dvjCkTzUTHNdBCKD1cGGolrmoLlNvmEKJwzI8KG194Lq4IdoayxXwxsL/J87hPuEhUUok1qwozR5eA5N0Pxb/rtET4mHXNTa6DcrDe47LzGR/uoIJg7N+2m4ncQx9ozGdcQNBLk6F1nigy02FoFp+E8Qv8HeAXOH1VnfJELtl7uvAxTOLK3pYEyhJsA1HqB1Ge4YE9Wq0k3yqmS0CwXBMgjuibZkf+xj6lZ0qtVQbrV4BnQZs0IOpJiDwu+8uLknYGVwd//qYKPxomkZDFJteqHlBQq3QmzS8/QM8iUIffFtCi3USbVqHWWVQFUqsXWzzm3hu/wq41gcN2618l30sjkRgUlXqZXopCXgc1v3w6jlnJbIdyeolT8kt9EqgtS7vofCabTQFoetfj8TKjleCdEt+cGUmECjHZF4V+ZVZ3TZ/KtZTMoRwOmknouTTJwDbcL0s13nG2Yid/t1VfoXQBQbstgaKgEZ87XelO5UaGl7kioxTivTxlcVfn26fE53tNHRz/hDYxrIQR8
 bOmQUZL9
 L7X1JuMlUmyHqjFD5kySdOnF83J2ZZK/oebSQqGn8Fo8R7dgsZsUetQpGeg+NwPE45w6yOMT7+uvtPzXMP0c5WTWK/UsbVXDaebJbDBTu3WGjIWWR50CbHdSth0JGGXYxOxP0dSQyi13Umq4OZZvn7Su6/mCD/aAsIowSt5yQeDYJO8jLB5vWWGehkg8wnfIWfAjWJG+3frnrxKs51DpR2lHMhRi43+V8LX0D1eXfpyWsY87iwLaN0Nf1ddpziH9ZfFQi4aWrf4EUPFleL59Wm4SBDB/F7g3DW4z5pXWgo/qq3Dg0jeYQKbq4HfXmvDlDpW/wHSbUwodkg//2Fb84+YK8Og==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 02-09-26 19:31:39, Hugh Dickins wrote:
> On Wed, 2 Sep 2026, Jan Kara wrote:
> 
> > It is possible to issue Q_QUOTAON quotactl(2) e.g. for ext4 filesystem
> > requesting to enable quota using tmpfs quota format. With suitable
> > passed arguments this can actually succeed in enabling tmpfs quota
> > format on top of ext4 filesystem which leads to crashes later in
> > dquot_acquire().  As tmpfs quota format is intended for tmpfs
> > filesystems only, verify we are indeed enabling quotas there.
> > 
> > Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  mm/shmem_quota.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/mm/shmem_quota.c b/mm/shmem_quota.c
> > index d0b92d6da50f..6e0b43cbded3 100644
> > --- a/mm/shmem_quota.c
> > +++ b/mm/shmem_quota.c
> > @@ -54,6 +54,10 @@ struct quota_id {
> >  
> >  static int shmem_check_quota_file(struct super_block *sb, int type)
> >  {
> > +	/* Verify enabling happens on tmpfs superblock */
> > +	if (strcmp(sb->s_type->name, "tmpfs"))
> > +		return 0;
> > +
> 
> I don't object to this, but was rather expecting you'd check s_magic
> for TMPFS_MAGIC: isn't this the kind of hi-tech thing s_magic is for?

Oh, I completely forgot about s_magic. Yes, I guess that will be better
than looking at sb->s_type. Thanks for the idea.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

