Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8495C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:53:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B60026B008C; Tue,  8 Sep 2026 05:53:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B11156B0092; Tue,  8 Sep 2026 05:53:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B2D16B0095; Tue,  8 Sep 2026 05:53:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6FF7B6B008C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:53:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EC9C81A04DD
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:53:56 +0000 (UTC)
X-FDA: 85190133672.17.DB69AFB
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id 81228C0002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:53:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GG1fySeW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=k6HS48F0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Y8vD/srn";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="N0sXJP/5";
	spf=pass (imf28.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788861234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7PxSZzuhiEVQPTqO05fMglEfYCmdRCQL8xD7SfCY/WE=;
	b=gibI2c1nZ8qDc67MHaq6S8T2Bnm0jl+lwgQk15VFtzoaBKxdtqLTh09GR5OZftI8bnm8cz
	nq01UV1Sydtn4pfmzsLSZE9lcqX+zUmAKGlQB8mNjhmyt3uXWa9Mzlz2djSExqS/MoUlB+
	Y1V/OPFGierXSX6T4US41UeCG8mIlso=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GG1fySeW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=k6HS48F0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Y8vD/srn";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="N0sXJP/5";
	spf=pass (imf28.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788861234;
	b=wtQFs1PklZ4Dst2K5mjBllxK4Elm9nL3MNwmCahrTwQPY7o1bTECocph1wpOZb+ksf058c
	uV1/46OjMmt9Tw1K8TvGOty1QsEg6P1VBnyOA9Xbh8ll6MhQZDMzMWuoftDQoT7sIi4wvh
	4BPcnvlBr/eFTXgmGFddGHsVwTsVf8Q=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BB5B021983;
	Tue,  8 Sep 2026 09:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788861228; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7PxSZzuhiEVQPTqO05fMglEfYCmdRCQL8xD7SfCY/WE=;
	b=GG1fySeWVzC7v/sjU/PcPMQ7s38yV+K1u9lzraOQlpJua/14A1ynljVS+8BUsm7vYZ9IBh
	TuRfpowFgF8XSCWqLAwx9my+UGVXranpfhgkncNPC31GjyHfKs4wxqA0Ygj/gXqbI6MCNt
	C6mKqaLsrcdowSGhEl5MHfU1zYXDKsQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788861228;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7PxSZzuhiEVQPTqO05fMglEfYCmdRCQL8xD7SfCY/WE=;
	b=k6HS48F0AatfwT4PRO/j6uKfn1eG/CV6AoMC1DRH7odtmHYjidMo85wA/LAHDfBjPPiEWW
	38xFglA6Ovr8FDDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788861224; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7PxSZzuhiEVQPTqO05fMglEfYCmdRCQL8xD7SfCY/WE=;
	b=Y8vD/srnNtZQMUFTh44Cj0oN67vSc/MViRGVBP3LckrOEt/VLmK8w1HhwC7uwbC8uJ0Mtx
	yGu5af1YDeqChm/LjgotNtrE0Mtp5nFQfpHvpqsbyTyz3HG7vz849kXAUp8eQ4/blbcIwi
	x+xsypZGSiyMSC/PFdULm6uVvqerHxA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788861224;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7PxSZzuhiEVQPTqO05fMglEfYCmdRCQL8xD7SfCY/WE=;
	b=N0sXJP/5nOZMx8CI/e0ZK5vRp2THy1H98LeQVqHy+vtrqajakK6LMjDNyW+jUILHkwCL9a
	IcxnqmwN3SbCsWCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9944813332;
	Tue,  8 Sep 2026 09:53:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vdZiJSjbn2o1cwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 08 Sep 2026 09:53:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 33C40A12E2; Tue, 08 Sep 2026 11:53:40 +0200 (CEST)
Date: Tue, 8 Sep 2026 11:53:40 +0200
From: Jan Kara <jack@suse.cz>
To: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, ocfs2-devel@lists.linux.dev, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: Re: [PATCH v2 2/2] shmem: Refuse to enable tmpfs format for another
 filesystem
Message-ID: <mdwfu5l2lcdumckkgwhsbxwae3shhylkv3da3tkimwbzuoosjd@2cfx5p44mkgo>
References: <20260903090053.13120-1-jack@suse.cz>
 <20260903090508.1360863-4-jack@suse.cz>
 <3b119174-7b10-6eb6-7aff-462949fcb49a@google.com>
 <CA+0ovCgQaS0mAJPDz=qMQkRgMQ0Tco5PRFHPtQo+ForkqdgC3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+0ovCgQaS0mAJPDz=qMQkRgMQ0Tco5PRFHPtQo+ForkqdgC3w@mail.gmail.com>
X-Stat-Signature: u8hn1e8nzw4s1pwq5mxaebtznytt7ncx
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 81228C0002
X-Rspam-User: 
X-HE-Tag: 1788861234-291656
X-HE-Meta: U2FsdGVkX19U/AhbdDlpKDEndO5Wfelj2Bzhy0Dpk6VcL1XnQur+yA9/wnJqgidrdePEuqIEAKnK0UG6ar27pkpZPFQytwiVG+DgBF/8NO++Ace4DGL3s25E+CxqfaczXFg/1mm5MJovClzlfl+aYV66MOIzRqOJf7a/sNJkNYjt2Fbvwr9CFuuGXUI+YSRxHLHJqS9iBaMBEv5TTOH6W/Z6ElO+fu0dmmctiMWtx4EQrJnZ9947/Y/JERFWTAOL9t45wi35zNAU9RhLraJRJ6n8M6IdU6+UggDzPBg62ucfYx0eMns3PHKQD4DekpDlDBF5yRwfkiVyVnvBKNYJy4OYJEjokFn9qaNtucE6f65BtLsCsViR+6aPXhlkkcH+8jhl5p9lPuqteENw55Y1amb9/iKn6I7mZyX/k0vukQt+c+m0sxs5CDVrBIqZ3gvB6lnFztoDkzcSdBKeqvrCg8l3K3BH6TQSQWJMDiv7yZwIQLBYF09lLNCA+kNcZ27CwOeBWONANF3k1d0EyjNbPW6w+1j2sATtpPRYCurmzV9BXEM0AuDLhJTMOAqLurgEpxsLbRGRQdVCIR0iF6XfTU9RUY1yJSbiGewBYfifiOttca2jE3y2JVj+gmjXXymJmnYXnYrQhEAwvRXp9mINzMD4j7/i0fAEoOh3gm+0DnOA/lBnBUfzR8uVqv7gjWVk4rLyu0p+5/4jyPEzSd3jPTyeptDFFvxIQZDBtJAk6hsQMqnm5kvIT26hKR3J+ZMyNVeweaST/TCwieyz16w/leKGdBHqVWlHKqAgnK6sMWov/amN4lePlTxpxT40dtoXmMEmBRjuaTINZg/G2XJqWNxn8nNUZUC8+WyP6HOGKJoQ1K+6MzDLfPhTHRsD1JJx9VSAcVLMiEJSbaJJ8TnNQbY5oTbRXrmajKhoAa1KXeK7mwMCFvY7IuAiWrtKARiKJoBXXfzRTdbsDrkJpYl
 Z+UJyNqP
 zajRAAyGu+kxo96m9uIE7hP/cD1kH3V45r1aMz9xrWVWXrUbnjrnqRpGEhv0+vAR6aqtD99BhhI9QRZFkjZsFF+srcIAPxrkndRdodWsLpn/rSdpfzZxv2L+yRmsdOBaVzHryzj57lpllyK5x3axIAc03RNgtrwRe579Hcm6lgxoQheSc65F0HQsnB2MlX5/eV1QuHXRtip2Mt6wqDccO2qHDkmp6SgWvh62g8nrxSPO9+BEcrnJnP3IhzVoguOutWzZksltl/4ceJH5DnrWl0JCtpCiuJhcKU5ugfC4HathHn5Z0SslPY0B+pNRqKF0YpaRjranrYab9ciExVqbmq1wS7t/8v/wKN3PCx167+K4FwtTkewtEVFvFR0LUwhmbBdjG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 07-09-26 19:32:20, Farhad Alemi wrote:
> Apologies for the delay in response. Upon our run, the patched kernel
> (this patch on 28924df2a08f) no longer panics on the attached
> reproducer.

Thanks for testing!

								Honza

> On Thu, Sep 3, 2026 at 8:15 AM Hugh Dickins <hughd@google.com> wrote:
> >
> > On Thu, 3 Sep 2026, Jan Kara wrote:
> >
> > > It is possible to issue Q_QUOTAON quotactl(2) e.g. for ext4 filesystem
> > > requesting to enable quota using tmpfs quota format. With suitable
> > > passed arguments this can actually succeed in enabling tmpfs quota
> > > format on top of ext4 filesystem which leads to crashes later in
> > > dquot_acquire().  As tmpfs quota format is intended for tmpfs
> > > filesystems only, verify we are indeed enabling quotas there.
> > >
> > > Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> >
> > Acked-by: Hugh Dickins <hughd@google.com>
> >
> > Thanks: yes, please do route it through your tree.
> >
> > > ---
> > >  mm/shmem_quota.c | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > >
> > > diff --git a/mm/shmem_quota.c b/mm/shmem_quota.c
> > > index d0b92d6da50f..a3fa4bd93e75 100644
> > > --- a/mm/shmem_quota.c
> > > +++ b/mm/shmem_quota.c
> > > @@ -30,6 +30,7 @@
> > >  #include <linux/slab.h>
> > >  #include <linux/rbtree.h>
> > >  #include <linux/shmem_fs.h>
> > > +#include <linux/magic.h>
> > >
> > >  #include <linux/quotaops.h>
> > >  #include <linux/quota.h>
> > > @@ -54,6 +55,10 @@ struct quota_id {
> > >
> > >  static int shmem_check_quota_file(struct super_block *sb, int type)
> > >  {
> > > +     /* Verify enabling happens on tmpfs superblock */
> > > +     if (sb->s_magic != TMPFS_MAGIC)
> > > +             return 0;
> > > +
> > >       /* There is no real quota file, nothing to do */
> > >       return 1;
> > >  }
> > > --
> > > 2.51.0


-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

