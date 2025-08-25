Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3795DCA0FE1
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 11:33:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 806A08E0013; Mon, 25 Aug 2025 07:33:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DE558E0001; Mon, 25 Aug 2025 07:33:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F4158E0013; Mon, 25 Aug 2025 07:33:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C5288E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 07:33:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DA170B904D
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 11:33:06 +0000 (UTC)
X-FDA: 83815068372.08.D50F056
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7368140015
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 11:33:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vM0JmMt8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OOGTAtHz;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vM0JmMt8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OOGTAtHz;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756121584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tomkV9nuT3frr0dWuW+rpHLgqKT+MFjV5H/omKZ8HQI=;
	b=G13fmrxaTW+/UfWOXjl2iUWx/sSrzqMhHT2vVboQ4v89vxRLf5mEuIamxJZxubZW7LEJL9
	dKeBJc2+AZnP1VQsEf2yKG4CSyt4HPzGqQxjuvkWzznSbCX8DCjBodOnyFABaZj5kFjitV
	oBntqlOtDsKaO3lVwYaQydk594pXujU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vM0JmMt8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OOGTAtHz;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vM0JmMt8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OOGTAtHz;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756121584; a=rsa-sha256;
	cv=none;
	b=ogkD5O3E5p3W455LrAVVlr56S7Dw1p/iZ8QapGuM+h7fTx9bQXQto8K9MRY+1t842bBGv6
	kVK3zTHf7YaqmheJhAdossYNUZpUjdp6D9rY5ECg/PzbMpXcHH/IbNoh4A73VGkqj9ZqSY
	wDMnwvpNffAMRbtVezajXH/VcAlhZEI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BF0DE1F79A;
	Mon, 25 Aug 2025 11:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756121582; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tomkV9nuT3frr0dWuW+rpHLgqKT+MFjV5H/omKZ8HQI=;
	b=vM0JmMt8wvd1jNqgCn9PlBu1BKoOyBmc8g4JRayRBduJGl7G5bMeIHuWHqcyhxC7VVpw+o
	OWpGDTFEoSWIOkpRGdNq+3RVobpP1dl+yx2gtS3yT/FVxFh/CeG4IzVl10PIoqWscbsWe8
	Pe56YnYXL8LzIs+wmQbuCYduWVXw04A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756121582;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tomkV9nuT3frr0dWuW+rpHLgqKT+MFjV5H/omKZ8HQI=;
	b=OOGTAtHzhWpJM/oD0VYEhQMvX4oTKFcCtFklyDgTAiZ3LpIwMIynTgFLBCUYmk31Bj7H2S
	lagUB7SRl1wN2JAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756121582; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tomkV9nuT3frr0dWuW+rpHLgqKT+MFjV5H/omKZ8HQI=;
	b=vM0JmMt8wvd1jNqgCn9PlBu1BKoOyBmc8g4JRayRBduJGl7G5bMeIHuWHqcyhxC7VVpw+o
	OWpGDTFEoSWIOkpRGdNq+3RVobpP1dl+yx2gtS3yT/FVxFh/CeG4IzVl10PIoqWscbsWe8
	Pe56YnYXL8LzIs+wmQbuCYduWVXw04A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756121582;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tomkV9nuT3frr0dWuW+rpHLgqKT+MFjV5H/omKZ8HQI=;
	b=OOGTAtHzhWpJM/oD0VYEhQMvX4oTKFcCtFklyDgTAiZ3LpIwMIynTgFLBCUYmk31Bj7H2S
	lagUB7SRl1wN2JAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AF20113867;
	Mon, 25 Aug 2025 11:33:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PY65Ku5JrGjqAwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 25 Aug 2025 11:33:02 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9FFCCA0A94; Mon, 25 Aug 2025 12:13:53 +0200 (CEST)
Date: Mon, 25 Aug 2025 12:13:53 +0200
From: Jan Kara <jack@suse.cz>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: Tejun Heo <tj@kernel.org>, linux-fsdevel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	jack@suse.cz, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, axboe@kernel.dk
Subject: Re: [External] Re: [PATCH] memcg: Don't wait writeback completion
 when release memcg.
Message-ID: <lvycz43vcro2cwjun4tswjv67tz5sg4tans3hragwils3gvnbh@hxbjk6x6v5zk>
References: <20250820111940.4105766-1-sunjunchao@bytedance.com>
 <20250820111940.4105766-4-sunjunchao@bytedance.com>
 <aKY2-sTc5qQmdea4@slm.duckdns.org>
 <CAHSKhtf--qn3TH3LFMrwqb-Nng2ABwV2gOX0PyAerd7h612X5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHSKhtf--qn3TH3LFMrwqb-Nng2ABwV2gOX0PyAerd7h612X5Q@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7368140015
X-Stat-Signature: ddyi89goygneh51w4e14ak6hk7x1diac
X-Rspam-User: 
X-HE-Tag: 1756121584-721989
X-HE-Meta: U2FsdGVkX19OUxYEDgVdSsJ3pDJoZBXz5oyAwi1kF2nBFZ4ZLEzqS3QwoW2u3C9BUonVFXZPjJ6hMq4hOppgWSJkV2huR7xkTlyBxAhBbM81DwhkIyZXoEF5zn7k7u1LKX75MYB8L1hes68bQCfHARSihtPnJXjxAqArbBjYqxejIRYXIniTJQugqg1SDWpnJvqHOtJ8Q7OgfMJvZeWdR0/XCNrpWcRCMLk+wL3hxG6Ph/Zt/CNCFVCNFg5yNtbGv059clp+pYWi7uyMZyfr3cn6xTLNO4SulWaEe3bb3rTdTHhIuAvrTJhDV7rV2R6FIgLWcXRwKOquZm/N3eJkh3dcTedbReBx3CtDprqzdh3q/9UP/cnF+XjY4cm9Et5lQaOfvha+g72afW/PmHcdy/OP/Wba0OBsJPZ4qci6d5xCjhQSAo99xiYpFlxqydjy4dpdaL7y+FSV2CMmTUAtUXEaTD74LUqmxCiItGj4kOm826FK/zrliaL+qYB6j4u6wrItvRn5EBqN0jIkuXM3aAWdWv1SZ19RSwKWIETsddpgd8K5E6ASlFqF4hHeVk6KWAsx7qMgcPQjExZEYsZjvzcvQSSvXi4EWQAJ3WWT7yozZmQAD5J3LNAnFcvz4W1U4htZH24Y1LdDVJM8smW0tpkUkqYtI6UiNi6UVQGjpXCrSKPj7cCNJpeNp3wetmAcQ4FzZJa0/TkC+E3N+ZJanYzvXO9nLrgZcbr6bUReSExOI5B1c9l929SkIgetifsr6xFWVokJbtMgU0vYNCVVBreJ0n7Oo/2v32w348f3w+5pbhguob20+xVdEETWZ37IkeKG7/qOjhfJ7jC10tcjwDvy45jHazMbAF9HCZ7uvVCkXAz2cVKBTHecIIqNXgmb1Y6Pw7IK3vl6oObwGUT0Njei8/NNw21Ix/r9Xe5wpN884ooBzHSm/l+PkQExWoHPH75/tF25pWmEBwUQgl5
 uaJe26uV
 HEH3n8PNkJgm3ihMMqmg2Nfg21HGNiGJpeMFYnmaBJRvmPGwg0b6Vf8a2ETPh3EqxYF/0r7SgXEnuMADesySHJ23wyAAAEyR39itL9yJ09bFuVzzbpAWlBqrJz9W0CAp2Sddp+drRCIP1+Q+kRo6HxAvyvagcf+D0lHYthqsI8+7isbuoyUMGyO+WtPWluDbRsoP9vlT/iplvGnHXIhVdvnQuUW9oDa0wxZfSJdXN6Yt4ZJbu+fBaupmWKI6SZODoEOH44eTHckUdDgnKkut8Wmk+fWdpSVNlzo5LwKl5K05PSs+V9Uq4wl3/T6PoyU3W7w+S8txZG7IynYXjqwZZrbTLtcfbHr0djeSmmWFoozUdHYp97paLPU+rrwoWZDE71tbE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 21-08-25 10:30:30, Julian Sun wrote:
> On Thu, Aug 21, 2025 at 4:58 AM Tejun Heo <tj@kernel.org> wrote:
> >
> > On Wed, Aug 20, 2025 at 07:19:40PM +0800, Julian Sun wrote:
> > > @@ -3912,8 +3921,12 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
> > >       int __maybe_unused i;
> > >
> > >  #ifdef CONFIG_CGROUP_WRITEBACK
> > > -     for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
> > > -             wb_wait_for_completion(&memcg->cgwb_frn[i].done);
> > > +     for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
> > > +             struct wb_completion *done = memcg->cgwb_frn[i].done;
> > > +
> > > +             if (atomic_dec_and_test(&done->cnt))
> > > +                     kfree(done);
> > > +     }
> > >  #endif
> >
> > Can't you just remove done? I don't think it's doing anything after your
> > changes anyway.
> 
> Thanks for your review.
> 
> AFAICT done is also used to track free slots in
> mem_cgroup_track_foreign_dirty_slowpath() and
> mem_cgroup_flush_foreign(), otherwise we have no method to know which
> one is free and might flush more than what MEMCG_CGWB_FRN_CNT allow.
> 
> Am I missing something?

True, but is that mechanism really needed? Given the approximate nature of
foreign flushing, couldn't we just always replace the oldest foreign entry
regardless of whether the writeback is running or not? I didn't give too
deep thought to this but from a quick look this should work just fine...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

