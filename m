Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0767CCCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 08:38:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48C688E0069; Thu,  9 Oct 2025 04:38:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43B8F8E0002; Thu,  9 Oct 2025 04:38:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3509C8E0069; Thu,  9 Oct 2025 04:38:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 230878E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 04:38:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C010E1A06DA
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 08:38:58 +0000 (UTC)
X-FDA: 83977925556.16.9DF39CF
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7EAC618000C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 08:38:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LPpzFfMn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lrMgh0IH;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vZGttwaT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=enFzO5An;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759999136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3vO/c3Nr9/ShdfTU0FdyXLRof5Q362KAvhqM2kcVybQ=;
	b=0lgWVkkTK1DVlNz6w+nfrCZTrR4Kco08W+5N3i3PeqIgCjl9NB5PXAzr6hWtH6YuxRKmuj
	1njci9U5SlkgQ2RRPALYRD7SHGXuzWNPg8x9Wvc5XX6U/Mo5zLp9FHTPGwNdlk69Vkdk9D
	N8ttWgQCvbyOZcVbGUWOqDcOw9Uhguc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759999136; a=rsa-sha256;
	cv=none;
	b=jwab9v+/ibjJkrI8rkuWDrz5VgqzC1vj7CPTYtANPIjKnTfEschvK3Fci2KbAP1jBs05Wc
	vA0iwpEhW8vKNHMd/nKd0E2ecaeCKHqecZvwfU5z7zJEEv5bqQzqiIs0YC7l2VBI7LAP90
	6ouJCQ9HP3Tds0+pZkPW+mJbQZmH1ao=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LPpzFfMn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lrMgh0IH;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vZGttwaT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=enFzO5An;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DCD661F83F;
	Thu,  9 Oct 2025 08:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759999135; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3vO/c3Nr9/ShdfTU0FdyXLRof5Q362KAvhqM2kcVybQ=;
	b=LPpzFfMn2Xc71sBNf7SHexb1rKX0SVND+Q7PZQeo2IX+0BPQMjLDBri25PD1hGXJvpQVRF
	kgWBMnlJF6rOoGtt2vcjPVx+DgJUAC1N2pvkrYM3367uBoh3RCPs2X2EBg1M27qqoSDke0
	4m50eZ8aoL/h6/QgBMjEW63ON1d8Q0Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759999135;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3vO/c3Nr9/ShdfTU0FdyXLRof5Q362KAvhqM2kcVybQ=;
	b=lrMgh0IHrMQO2D7tnVV5rWkYXCzXd4D5juj1ccLQrfCjRtHjP74J8zRcedThxGGlHyGvex
	ImalzjldK6elkhAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759999133; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3vO/c3Nr9/ShdfTU0FdyXLRof5Q362KAvhqM2kcVybQ=;
	b=vZGttwaTa//klyZ7MbT0oDXWp1XVPaQbWw3RWYxBhQtq/mT0p3183aWIZxPQB9OmeYWdGM
	GmO54daV2M7UHn2g/5oD7Jz5mrm2QE+/rzbqZOiXRH7MV+i45yEQ4AtHgl5mS+KV99udbu
	ryptJE0bLS8aEaPjtSpbD9turPVobBQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759999133;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3vO/c3Nr9/ShdfTU0FdyXLRof5Q362KAvhqM2kcVybQ=;
	b=enFzO5AnfFeyCw2dgPggX6k6B7lky/cHhoVPVq1whs5XDCVALJbRn0cAEijZxY9GGivRWM
	1TUzIetlNiJ/wNAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C676B13AAC;
	Thu,  9 Oct 2025 08:38:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id d8dvMJ1052gEGwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 09 Oct 2025 08:38:53 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 50ADAA0A71; Thu,  9 Oct 2025 10:38:53 +0200 (CEST)
Date: Thu, 9 Oct 2025 10:38:53 +0200
From: Jan Kara <jack@suse.cz>
To: Joshua Watt <jpewhacker@gmail.com>
Cc: Jan Kara <jack@suse.cz>, jimzhao.ai@gmail.com, 
	akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, willy@infradead.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH] mm/page-writeback: Consolidate wb_thresh bumping logic
 into __wb_calc_thresh
Message-ID: <47nzppimqdsltrtjb2qz4ztgtxq73rpugagronbeiod5v6ygzp@nl4lwvjk44lp>
References: <20241121100539.605818-1-jimzhao.ai@gmail.com>
 <20251007161711.468149-1-JPEWhacker@gmail.com>
 <ywwhwyc4el6vikghnd5yoejteld6dudemta7lsrtacvecshst5@avvpac27felp>
 <CAJdd5GY1mmi83V8DyiUJSZoLRVhUz_hY=qR-SjZ8Ss9bxQ002w@mail.gmail.com>
 <CAJdd5GaQ1LdS=n52AWQwZ=Q9woSjFYiVD9E_1SkEeDPoT=bmjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJdd5GaQ1LdS=n52AWQwZ=Q9woSjFYiVD9E_1SkEeDPoT=bmjw@mail.gmail.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam05
X-Stat-Signature: wjowtsas74ndeo444quc9msfgz763wox
X-Rspam-User: 
X-Rspamd-Queue-Id: 7EAC618000C
X-HE-Tag: 1759999136-573519
X-HE-Meta: U2FsdGVkX18SzXreCtQxfZx2/GDAffCjst2134Noq30eDLCcdhAehbjZKsJq+nOkBZnlif2ANXBpJ80jXHV1dL/ZGdU1bV14WNYNNeL76Fx4G8JFEvQsSqw3+RmVU9t5rKtQTkhFjfO/57RPn8khIowD54rIbze692XFmyykx/zecLwau+Hrtn/Q3RsHYooXiiOqcfJ8zxVaKzY+q5fcM9KoZKK/fkM2KvySDQqrxqT3j7XFBVrXfynXFKGscu5hS+0DqnKts4vUkJvn0Rf5OBuqUhrUFh9iMMTvW0cZ7/30lhThy4+k2qXQp2z0DFt68PjVBHIepoelbOR6xM0kfSvL0kHfSQIZ5X45TTxnB8Vqg35L6sE+TieEpgpvJy9HhDe7Uo0GUXOpLAh7dP/2J2O3jE1e16gwuTwrMJEXIxq0fKDaReq0Ez2EcihDc1PbdYYECjNhzL+wvpVF7O9vDDcIjn0uah1B7JmGDx9x2XNM0vqsfRiCAhE19teuH8FW7L3VOs36z5rvcfZinqLZqBD864vpUjStsLqL2LhqJ85Y1Y4htcIyYU3xK/QsAfIMrxmD+WZPHGcFI80TaOvU9N6f9YU5Z9GBR1B2U28TmEynJUwUDQpLhE9UiqNIGqixMyNGMGPs1F3IlWTZnyq/CrGJgE4KNs7yr35x6h82iUjTHQfd1+z06/BVd7GCRQm8z2TCEuEv6i9J4yrMc7OE37jIEF6ZQPso0lFK/JniiV0I9G4/77P18WdpYnWv+HfRB8ThpiXXUA2U8m5CHGN+OT6qr4zmCntpYk1gipJvMPCY/Ga2HhUGTrFVBbQF/PrGEIpNYWsVyD/AQtq1j+SNORw6KsimPQEqNiQqcD0DQJIsTjh4Z3ndNuHwuEuSnV6TtMNA72QXkjQSKv/WA9JvdjFZsUuXPWwBNiKV3HgdyZ9WQZRwpzx5vQ4jUfskt7NGNZRozl0XULPYrJthILm
 MvV4AU3O
 XyeK3EpoGJVjzqMte1AXeMLHmgnFYhspJ6iOnTOGD4z5hrnoWRgrfORU1PVctMZedWTvzmae3R+IgS7LE8wIcv72j4bbOuTScglj0LHRLVuofzfVRXu2ggiMKzSfmjTAphdPJdvXHKrcXkfE5nTkRJfp3Q1vZxetqRoFbJQO8DhVwKITgDots4TqjDbALaXMR7O7v0zHszNQ2tCbUq5RgrxshL8bDdRz75YAgkYHJ3hVlzrFfp7FInjFFOZRVQ92tTzYNyN7MadWBarMq61s8SIQELrjNrO46I5qGL0ZPr5KSKbp0o806Kzus4AGrsQ1dFw6YXXI2G8iCwShWh/dRh9RX8hG6B/XddjGYR7lstT9uh3MmEyF8tXzqxRjb1Znt5UOovk3i+hLI+d0YZ2BWUFBtTnzIMixpAonJuBL6/DbC5c3wKAZqDfuQyZRPPC6you9pkv9r8YNsReV5iJD0XuGGD58eUUgompCG3cZf0EB6Zt8aXxcv80OWxA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 08-10-25 17:14:31, Joshua Watt wrote:
> On Wed, Oct 8, 2025 at 8:49 AM Joshua Watt <jpewhacker@gmail.com> wrote:
> > On Wed, Oct 8, 2025 at 5:14 AM Jan Kara <jack@suse.cz> wrote:
> > > Hello!
> > >
> > > On Tue 07-10-25 10:17:11, Joshua Watt wrote:
> > > > From: Joshua Watt <jpewhacker@gmail.com>
> > > >
> > > > This patch strangely breaks NFS 4 clients for me. The behavior is that a
> > > > client will start getting an I/O error which in turn is caused by the client
> > > > getting a NFS3ERR_BADSESSION when attempting to write data to the server. I
> > > > bisected the kernel from the latest master
> > > > (9029dc666353504ea7c1ebfdf09bc1aab40f6147) to this commit (log below). Also,
> > > > when I revert this commit on master the bug disappears.
> > > >
> > > > The server is running kernel 5.4.161, and the client that exhibits the
> > > > behavior is running in qemux86, and has mounted the server with the options
> > > > rw,relatime,vers=4.1,rsize=1048576,wsize=1048576,namlen=255,soft,proto=tcp,port=52049,timeo=600,retrans=2,sec=null,clientaddr=172.16.6.90,local_lock=none,addr=172.16.6.0
> > > >
> > > > The program that I wrote to reproduce this is pretty simple; it does a file
> > > > lock over NFS, then writes data to the file once per second. After about 32
> > > > seconds, it receives the I/O error, and this reproduced every time. I can
> > > > provide the sample program if necessary.
> > >
> > > This is indeed rather curious.
> > >
> > > > I also captured the NFS traffic both in the passing case and the failure case,
> > > > and can provide them if useful.
> > > >
> > > > I did look at the two dumps and I'm not exactly sure what the difference is,
> > > > other than with this patch the client tries to write every 30 seconds (and
> > > > fails), where as without it attempts to write back every 5 seconds. I have no
> > > > idea why this patch would cause this problem.
> > >
> > > So the change in writeback behavior is not surprising. The commit does
> > > modify the logic computing dirty limits in some corner cases and your
> > > description matches the fact that previously the computed limits were lower
> > > so we've started writeback after 5s (dirty_writeback_interval) while with
> > > the patch we didn't cross the threshold and thus started writeback only
> > > once the dirty data was old enough, which is 30s (dirty_expire_interval).
> > >
> > > But that's all, you should be able to observe exactly the same writeback
> > > behavior if you write less even without this patch. So I suspect that the
> > > different writeback behavior is just triggering some bug in the NFS (either
> > > on the client or the server side). The NFS3ERR_BADSESSION error you're
> > > getting back sounds like something times out somewhere, falls out of cache
> > > and reports this error (which doesn't happen if we writeback after 5s
> > > instead of 30s). NFS guys maybe have better idea what's going on here.
> > >
> > > You could possibly workaround this problem (and verify my theory) by tuning
> > > /proc/sys/vm/dirty_expire_centisecs to a lower value (say 500). This will
> > > make inode writeback start earlier and thus should effectively mask the
> > > problem again.
> >
> > Changing /proc/sys/vm/dirty_expire_centisecs did indeed prevent the
> > issue from occurring. As an experiment, I tried to see what the lowest
> > value I could use that worked, and it was also 500. Even setting it to
> > 600 would cause it to error out eventually. This would indicate to me
> > a server problem (which is unfortunate because that's much harder for
> > me to debug), but perhaps the NFS folks could weigh in.
> 
> I figured out the problem. There was a bug in the NFS client where it
> would not send state renewals within the first 5 minutes after
> booting; prior to this change, that was masked in my test case because
> the 5 second dirty writeback interval would keep the connection alive
> without needing the state renewals (and my test always did a reboot).
> I've submitted a patch to fix the NFS client to the mailing list [1].

Cool that you've nailed it down :).

> Sorry for the noise, and thanks for your help.

You're welcome.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

