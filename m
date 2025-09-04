Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D478DCA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 13:08:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EE3C8E0005; Thu,  4 Sep 2025 09:08:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19FA28E0001; Thu,  4 Sep 2025 09:08:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B4F58E0005; Thu,  4 Sep 2025 09:08:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EBF728E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:08:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 901F95635F
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:08:56 +0000 (UTC)
X-FDA: 83851597872.02.E0EF2AD
Received: from mta21.hihonor.com (mta21.hihonor.com [81.70.160.142])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7FC2F40013
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:08:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756991334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+bqbtOCGBvgA8j+PJ8O++U8dQCO2g+17vi/56mur+os=;
	b=vfYMq2FnkANKrNHh1NzOX37uq3qcJRN6EGur76zy4rPq8/ALO/NyHDonF2fwjgQT2EOoqy
	OQjV8K6Z9UY0q/OKMgxBrDVESUqEO4GMttrXXMU6NpQFP8Aw6CFOo0f/Qof/jInFY8wd70
	s/+x9q1jl7z5k03wzQcyDPJUC9PVnVs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756991334; a=rsa-sha256;
	cv=none;
	b=RGlCZLp4YtBZoOLj7r0A96jgkDUZlU10JHdrNt1S3qRS48BQ/V+/+FMnQAf8Z5vrnchX0h
	DOUuuf7Xz0VtQZmbgmCrvhMCSuLad+tM/oG18wIY7ynxQwZMMZGzCImQ4VY/RN46LMlw3Y
	YV0nTZbFkDfuW9ntGjwclK0GtWDWMkg=
Received: from w002.hihonor.com (unknown [10.68.28.120])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4cHftL2qLnzYl5WR;
	Thu,  4 Sep 2025 21:08:26 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w002.hihonor.com
 (10.68.28.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 4 Sep
 2025 21:08:49 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 4 Sep
 2025 21:08:48 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <akpm@linux-foundation.org>, <feng.han@honor.com>,
	<liam.howlett@oracle.com>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <liulu.liu@honor.com>, <lorenzo.stoakes@oracle.com>,
	<rientjes@google.com>, <shakeel.butt@linux.dev>, <surenb@google.com>,
	<tglx@linutronix.de>, <zhongjinji@honor.com>, <rafael@kernel.org>,
	<pavel@kernel.org>, <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v7 1/2] mm/oom_kill: Thaw victim on a per-process basis instead of per-thread
Date: Thu, 4 Sep 2025 21:08:44 +0800
Message-ID: <20250904130844.28447-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <aLg0QZQ5kXNJgDMF@tiehlicka>
References: <aLg0QZQ5kXNJgDMF@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w010.hihonor.com (10.68.28.113) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7FC2F40013
X-Stat-Signature: t7134138ittfhk87h9k9igxw4r8y3ezf
X-Rspam-User: 
X-HE-Tag: 1756991333-410176
X-HE-Meta: U2FsdGVkX1/KQ9fB18FL3zV2iQ2bu4zDyA+loF5uvG8zUhdx5+U1upl2jbhZoYPE/1f0zN5svnNCXWznw4lS8xpROHWWUHTB0pnhHJ2iz+TqYiWPNgqf7cRm2HvrVniydNCA9f5jimnt/xmrZ1jtJvgu7p2bMBM3+YZ4dNQIh78Pu0rNFK0Q/nP3NL1eoSC2cfVVUmh6jfrX7DCl9Ax4gBZDASTu1Xb9JgdzwVWRJWzCHemKPs+elqBz1ade+WaNRyVvpv63ejuMFZpussNmz2GyQ8f27CAxgiTMRdgTmMgsJETe1jeMeAlr9XvHT0zTDx4EBLCD9oQZx/15tSYSV+YVYlb+WBA+a/jmbqbg0EXPiyoFRtsxt8K2dV58+oE9JpcdF7kG27NFPZ/g6Pe5FeYcfxb89Sfny4JZ/J6abyJLdOOEJ1FbSj8V1HomugzRlAFn34tqb8P6ksj3UX1J4AOycdM+8pLWdYGWsZq5kqoYjE8AyKB12XDMoJc/WRSwkGvV8bVhE/g2mNXD2sqjDxmsxwdPScC/q5pv1RXXLoCY2a6RLoyhlUENvUCwaTYzlUfHVC7w/lMon2XIeieGS1o4KWWav8FhmDLGq1LjrrdwlKIqNiVTn35iipkNM2tT6HFsfZvYBbQV8GHOUoP6i9gwaHQSStIVzuWy8J4RoVPPzfgpr0tHA3avtNxowGcc/lDc2oPHMM+zRsN5Vps2LokML968Brj2C+SB5GFAqHqzwoULqkN+OadjRWGxhvzfGEYCdwye/Jl+akCM/It1ArPojapDR2JzVjbi9LYgyGo0BSnIvpkkXIvTPkPz8pIb0mOqLkpWVZMtDNWAPW0QCBLcipuld2vZMORLf2f4ktzCxDfKsJdDSP+RBv82uhqwTyUbX7YuFfdXBTBS+3fh8/NcB2EULBfgiHBkir1SJuUNIU+wyfRILNq1tOVNxzwq/tgmfsvKfdSS9UeVTwj
 FUZwwIrP
 tWdXklx0TXVvfaN/RZFWqBTIL5sbwfyvMTHkUlSvEpFu7iSA0mgIgkrv3bvRROwVuz8hCTaHt3SySSKfrbyQi7qbMHTnuT5l5KyUdGp5wUihLMj+XDBZE0Vh/2Ev3uHb3uo6GDJU9bif6bW1EQR/pyhKpF2ZCUby8YEj8J6mc5gblkoK/eHzrZi5cT/9GOihFQhnXWlnkVtHd4X3anqQQ+13UdTDHkNJLE2Qw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > OOM killer is a mechanism that selects and kills processes when the system
> > runs out of memory to reclaim resources and keep the system stable.
> > However, the oom victim cannot terminate on its own when it is frozen,
> > because __thaw_task() only thaws one thread of the victim, while
> > the other threads remain in the frozen state.
> > 
> > This change will thaw the entire victim process when OOM occurs,
> > ensuring that the oom victim can terminate on its own.
> > 
> > Signed-off-by: zhongjinji <zhongjinji@honor.com>
> > ---
> >  mm/oom_kill.c | 19 ++++++++++++++++---
> >  1 file changed, 16 insertions(+), 3 deletions(-)
> > 
> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > index 25923cfec9c6..3caaafc896d4 100644
> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -747,6 +747,19 @@ static inline void queue_oom_reaper(struct task_struct *tsk)
> >  }
> >  #endif /* CONFIG_MMU */
> >  
> > +static void thaw_oom_process(struct task_struct *tsk)
> > +{
> > +	struct task_struct *t;
> > +
> > +	/* protects against  __exit_signal() */
> > +	read_lock(&tasklist_lock);
> > +	for_each_thread(tsk, t) {
> > +		set_tsk_thread_flag(t, TIF_MEMDIE);
> > +		__thaw_task(t);
> > +	}
> > +	read_unlock(&tasklist_lock);
> > +}
> > +
> 
> Sorry, I was probably not clear enough. I meant thaw_process should live
> in the freezer proper kernel/freezer.c and oom should be just user.
> Please make sure that freezer maintainers are involved and approve the
> change.

Thank you, I got it, It would indeed be better to have thaw_process in
kernel/freezer.c. Let me CC the freezer maintainers before updating
with the new changes; maybe they will have other suggestions as well.

> 
> -- 
> Michal Hocko
> SUSE Labs


