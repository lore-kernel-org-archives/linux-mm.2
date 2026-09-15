Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EACDC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 09:19:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60DD26B0088; Tue, 15 Sep 2026 05:19:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C0076B008C; Tue, 15 Sep 2026 05:19:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ADA26B0093; Tue, 15 Sep 2026 05:19:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 213866B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 05:19:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 712781C04FA
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:19:44 +0000 (UTC)
X-FDA: 85215449088.30.28F60F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id C2F19140003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:19:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ne36Z5E0;
	spf=pass (imf23.hostedemail.com: domain of cem@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cem@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789463982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9WB1e/2MQV+b7qkpkJIoykj9JwyVRXM7+/yJBvrMtOA=;
	b=E5AZJ+mBeoZz/pl8089WHJXg7d56mQ7KlIinhmegtiHPT6SM2lS9uuIGAwaaz51Mzfw8Wd
	HNQZTrRk9p5S4yHLq2bHUUB7/VjlyrIQ0zPpCV17uKYueH+C+tS868lC6djg7A4e7Xn2CP
	FzmwmtutXFbuLUrvkf0dJnDmXFStTRc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789463982;
	b=ZgIMIZVSCHWBHk5mJAMPQUjlDFiCPGnR3wyfATewBtKy2B1aFrNNHlCf2AUsIpoAG7HQ/d
	R25NKf5uPZhsH6feJgT4GrU3egdVyDR1L5kH9qvAbNzp3xfPmOSdRcWWY6CkLW8DAeCXQ4
	Y6luFZUH17EH5ta+cK7ok4GIy5P/Kyw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ne36Z5E0;
	spf=pass (imf23.hostedemail.com: domain of cem@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cem@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F3A7741619;
	Tue, 15 Sep 2026 09:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8564B1F000FF;
	Tue, 15 Sep 2026 09:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789463981;
	bh=9WB1e/2MQV+b7qkpkJIoykj9JwyVRXM7+/yJBvrMtOA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ne36Z5E0okmsrSkA9AWinJI6ebJIl58mipyEkrPsaDOJ/ieGL0xltqR4Jwi9rgoMN
	 3GZfMmiMEAGhIpLhDuG+IQXOa2GdggfbRoaV03z2+F4qQE0S7/42f/meL9IPQELO1I
	 fFRpRUPkSx/qY0SPDsRLCH4UVJzL425lMbb6DbeFBQV3I5o7ptser7WGm+tyqp+vj9
	 q68JoQrkx+Owk6y3IIHgwqjlytv3nU70huLEZu6wuqIIUmBBCv9jwfqhuAzyRHrJdk
	 9QE/Q+1q/hXfMndQCXHPqZCMnkbt2hM6DADCt7KFdrbghMP7VMmpbNRMayjv4r8spI
	 HiErzATK+pYoA==
Date: Tue, 15 Sep 2026 11:19:34 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Zhou, Yun" <yun.zhou@windriver.com>
Cc: Christoph Hellwig <hch@infradead.org>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, brauner@kernel.org, djwong@kernel.org, akpm@linux-foundation.org, 
	vbabka@kernel.org, surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev, 
	hannes@cmpxchg.org, ziy@nvidia.com, david@kernel.org, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, ljs@kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] xfs: fix NOFS state corruption in btree split worker
Message-ID: <aqkKPU8HNkt_uV-m@nidhogg.toxiclabs.cc>
References: <20260902134417.c44503a1d65533f81fb1c391@linux-foundation.org>
 <20260903133756.2006032-1-wangkefeng.wang@huawei.com>
 <aqJEWmUN3Jsajoyl@infradead.org>
 <38377447-ffa2-43ef-bbfa-43d05decda1e@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38377447-ffa2-43ef-bbfa-43d05decda1e@windriver.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C2F19140003
X-Stat-Signature: y8f67ck3samazy9nkb4bwyjrtny4x7rg
X-Rspam-User: 
X-HE-Tag: 1789463982-880144
X-HE-Meta: U2FsdGVkX1+1k+A4vy2Zq/MaaUon+MoKvD6J1X7AXzB5sN0XH5OUxtS5D8N+h2W1o0ydYY+lH5+T741Jm7OJ58qKmwBlFI4cHX5d+//aExpDkU1B6OIdsmd7SF6i6czPbMrbBvAkbNHHPfL8AMRdP74IzD5+16WrAM5QQGPfoOtyGq/6sb5GsWr/VRVldEUBNryClwwNHjXhHJOHNZf03EUvIyCdPzTvcodhbziqC4aHDCfXZn1M8xapf88RnVCBfoYbb3F6Wnk/u9cIvxwJzOypba4W6qTt823krvLx/i6CSPidpEEV41RZdXURaU/GErOuJuAbOb3MjTNyUnELG3yEBipxnTSFNlBo7NT2BRUldGZ5ubsJKuPmIoUuW6JYoKvCSN2L0Dt37WY+/ab1kAj9+YR0xjv9/kQzfk4to7wVwwPYesOH7PrdUCHq+IKi0IQpWdW4wRyxUZxi+zhkNDUauQU156QpGAS6nsQFb4G/NfyUA5mPHQEaiS41dl9ddYMdxP0INjg0d8+COeFQOZeB5WPKt3IGS5xdwr25gCQs1OnYJR/OTBOetvWmLwPLrfUBAvD7TMmiSk5oIlQ+22EdFESZ5xBXuuiPAA65qiCFOcEkyM1p6HGVlJ1zd270psk4RblT+gNTo0zYg/stcGznmLz5Gzn6R4cgELXGWTxxLimD/jyKfQq09JT413AWwZ5aSyq82NTbiu+bz4BmurVstA4EcBbwvWYGz6mwmbuQfPhwDkgOyTy05bKJ+8T8C5vgHQ5nf9iSimx9kSwR9uhuGQIVFdRJ2bAqdZfKUN5akKlKXowgP9JrP2wo61Q2ICqLg4ZseAINUS7TGPn8ROE3k7AEYrPMwMhuBR08VA0dF0fn1WyTIXajor0xeAYB1bgDLY/jOESnFP/16jg9bVX31zN6Eyum4B6Nzn/SN/EWxVpnYwxpo0reIQGkj1rWNk/kriAdo9EaeJwaiEV
 JFCnbroW
 d5vJ9i6m7IyvrDghIxd6sjBr7fIA5vQvdbTUk2HY02gSDA+PQaHKQrgX9DBbDznPK9YUuwpfij+O1NEvozoVI0NtM4otCGZjeMBEhQpUsGgccEZtIcev3UM2CGU71Vf7tD+E7sxCqg1B6l7ryEilzgvLrzcBauWOWiyev2rfbluWFUVsXMjgardEm2ZhCcs/KcRjmrsuCXGUJoMiwYAMFOpBH/hESmrLZK+LZhWV7M67tbIGfEtp1+drwP7lBJAlUhFNtlWnwf6C3uMP2BcE6SBml5SklDqUgyWPOxRLKLK5gKCQzr4RZOmB5IvMYM/ZoyAI+7oWlJTef+eCm4J/MgNBscQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 03:09:57PM +0800, Zhou, Yun wrote:
> 
> 
> On 9/10/26 13:47, Christoph Hellwig wrote:
> > Adding Yun Zhou, whoch touched this area recently.
> > 
> > On Thu, Sep 03, 2026 at 09:37:56PM +0800, Kefeng Wang wrote:
> > > xfs_btree_split_worker() calls xfs_trans_set_context() and
> > > xfs_trans_clear_context() on the caller's transaction, overwriting
> > > tp->t_pflags with the worker's NOFS state. When the caller already has
> > > PF_MEMALLOC_NOFS set (e.g. xfs_end_ioend_write, xfs_dio_write_end_io),
> > > the corrupted tp->t_pflags causes xfs_trans_free() to erroneously clear
> > > the caller's NOFS protection.
> > > 
> > > Use memalloc_nofs_save/restore with a local variable instead so
> > > tp->t_pflags is never touched.
> > 
> > Looks good:
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> > Btw, if you have some spare time, it would be nice to kill
> > xfs_trans_set_context/xfs_trans_clear_context as follow up given that
> > they keep causing confusion.
> 
> Yes, you finished reviewing this patch [1] in July. However, I'm not sure
> about its current status. Perhaps I should ping Carlos to check?
> 
> [1]
> https://lore.kernel.org/all/20260720050522.3101824-1-yun.zhou@windriver.com/

Ok, now I see why Kefeng Wang re-sent these patches...

The first submission in July slipped through the cracks (I was on vacation
that specific week FWIW). Feel free to give me a heads up if something
don't get pulled in 1 or 2 weeks.

This one though is buried in a multi-subsystem series because you sent
the patch In-Reply-To one of the emails in that thread.
Please don't send patches as In-Reply-To something else, specially to a
multi-subsystem series because it's really easy to skip such patches.

And then I got a "Re-Send" series with zero information why it has
been re-sent, and one of the patches in that series was already picked
up by Andrew. So I can't simply merge that here and mess up with what
Andrew already planned.

If this patch can be merged before:

commit 14ec230f93fa928090507cfdc67ca67e928d0c9f		(linux-mm)
Author: Kefeng Wang <wangkefeng.wang@huawei.com>
Date:   Wed Sep 2 21:16:50 2026 +0800

    xfs: remove dead kswapd flag inheritance from btree split worker

then please re-send it, otherwise wait for the above patch to land in
Linus's tree, rebase and re-send.

Cheers,
Carlos

