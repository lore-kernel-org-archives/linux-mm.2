Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AFAECA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 15:25:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AC148E0012; Thu,  4 Sep 2025 11:25:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 983C28E0002; Thu,  4 Sep 2025 11:25:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 872B98E0012; Thu,  4 Sep 2025 11:25:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 740988E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:25:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 14857160256
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 15:25:03 +0000 (UTC)
X-FDA: 83851940886.03.51A1606
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id DD65F14000C
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 15:25:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kjXAefPq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=kC7i+lo0;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kjXAefPq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=kC7i+lo0;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756999501; a=rsa-sha256;
	cv=none;
	b=WKHNgTv1vx0WKsQrEDoMJZpxVAwNAUujM4eK6q5DNC/nghD3NOmIbiY45u8F+5LWf9qP/W
	gGv5JApOs8t2WaWe1D6YjFOdntaOm2WhjGp4X3KfTTDMHUxurw1jAGElqD4VPWMyk4ig7M
	6+M4tRTj5/6rCAub8G8LMJSsz2L/lbQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kjXAefPq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=kC7i+lo0;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kjXAefPq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=kC7i+lo0;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756999501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NL8T0f8bsgsh8WsNAI90N4zr5/umNEqCtxWVlPWGNG0=;
	b=F+Hn66QAuqZSwZnUA7IE4mSK2Z7q4FRgxzKLZB0GFbXtnborVDRjtrZbDCG9iD5sSixac7
	p1hRUXoUHBbQnumNyCA8BoYPZNbSfDk6xREEzqrt+3Nv98fyLjBlVSmu/y8I5ZJ1jsc6qw
	eb36oqxTIgFIVmIKOnN0pzAzbKIrTKM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4EB1C603E6;
	Thu,  4 Sep 2025 15:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756999499; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NL8T0f8bsgsh8WsNAI90N4zr5/umNEqCtxWVlPWGNG0=;
	b=kjXAefPqYoNG8Ma0IpSoGZOwQgheUlxRs57VnudLeaqkoz31z4UEzPJsJq1CkdEU3m3NlO
	772chMlSZSeqgSk8xXFNyhRzEg2IhEmUk5le9vCPUIBARh6lxmU2Gnw/vGu+sSIKjc12dT
	OORWQclkjaTHB98YkTbLCzB83lTIzBE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756999499;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NL8T0f8bsgsh8WsNAI90N4zr5/umNEqCtxWVlPWGNG0=;
	b=kC7i+lo0lDkYWwCT0+zRR/hUhf5nKlwHNcGXmgG3RoBMp6q33uZnBWim7zwQZAoXxU3aoh
	EfVeyNYpNj6StyAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756999499; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NL8T0f8bsgsh8WsNAI90N4zr5/umNEqCtxWVlPWGNG0=;
	b=kjXAefPqYoNG8Ma0IpSoGZOwQgheUlxRs57VnudLeaqkoz31z4UEzPJsJq1CkdEU3m3NlO
	772chMlSZSeqgSk8xXFNyhRzEg2IhEmUk5le9vCPUIBARh6lxmU2Gnw/vGu+sSIKjc12dT
	OORWQclkjaTHB98YkTbLCzB83lTIzBE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756999499;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NL8T0f8bsgsh8WsNAI90N4zr5/umNEqCtxWVlPWGNG0=;
	b=kC7i+lo0lDkYWwCT0+zRR/hUhf5nKlwHNcGXmgG3RoBMp6q33uZnBWim7zwQZAoXxU3aoh
	EfVeyNYpNj6StyAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5E82C13AA0;
	Thu,  4 Sep 2025 15:24:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VmvfE0qvuWhLCwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 04 Sep 2025 15:24:58 +0000
Date: Thu, 4 Sep 2025 16:24:56 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Kalesh Singh <kaleshsingh@google.com>
Cc: akpm@linux-foundation.org, minchan@kernel.org, 
	lorenzo.stoakes@oracle.com, kernel-team@android.com, android-mm@google.com, 
	David Hildenbrand <david@redhat.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: centralize and fix max map count limit checking
Message-ID: <7eh332fqbhxak2afcwt6mwzaxu7s3dj2tx4hrtt7ivo3oxovcg@avz6uniwdzpi>
References: <20250903232437.1454293-1-kaleshsingh@google.com>
 <qa7b7pvrycejnn6pjytxysu57xckhexupjrzefmk4j5hlaxka3@ayeg2vzpfe3r>
 <CAC_TJvd0SnHpEv0MSwXsF4UFpP0MNvRc033=JS1xTEHAOjQY5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAC_TJvd0SnHpEv0MSwXsF4UFpP0MNvRc033=JS1xTEHAOjQY5A@mail.gmail.com>
X-Rspamd-Queue-Id: DD65F14000C
X-Stat-Signature: or7ibbokjdcc7nrikjr41gombr974d36
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756999500-673680
X-HE-Meta: U2FsdGVkX1/c1mHE2dqHWM+8sEVNzNO3zazO89oeoYRhSuLyI1VJxc9KKvoXEZya+7UAenQF13aK3d93H5avb7uDeTjJwHyExX4RLVC+W6z/wlgGhI1lU9oDp457JW9Tquw0Z+Jskdv1EE+sxsAeuxC/29T80qbwjezlRzWM3zUfYSZBkN+lvcZIdvpUoLnesuj/4mUNFSZPKgq8hrAnJQeVktdIZQmIPilsIujSpVYEXaEK44k2tTPQ8rjt16BDV/H7o9KQeLq/h54efGItDuE5CNrkrq2IY6yMVZCHLICxvKV0+OrztgCe4inbdD+WqD2kJC82iCzZHZ8UPIZM/NzklLg6VNhiQOb+rY6d0d9gRFzhG0IzBl6it22Nfs2soCEBXoRBZfiiCdQaEFGfASYrX2Cil8khwTQe4sKRWlXP/Q8iFp0HVRNwkapV4gOQqezQ8F3xM2S0D3zvtXseaz25YGiMFpqhyR3ZsAf/fOqI/9UdsJ3nYnAlBeCHODmVdeD9ZYRFJBZI7f0ccUYQci2o19JZ7o6+eJiwEQqm70SEWnExmOuxUWofgkzKa6kQYCAzKrmmjES5H7To3yvZMk1VaWcoEMJG2dDKfl5IxUQpizODXo7cC6/TvShms7KvaDeR7hWlaAbLDYILvy3pE3tEvDlRfnbwPV+blnTyZ5BhyVJkLOt7RUhzMInLLKfpNIfeBRe4MgVxuFL48QcxVDCbV0qJGeDFMXv78Ma3YWmH/3Ppmgfo6jqavFentCYNlVOwgCq98q+VaDQD+4OwmG5nxVjJzn99it9X9oLbH7VO/1BBx8xJdfbxd1PUN+ShP8FJXNy7DxjROmFvLn4Ls72AMyzWvUHNtJLC6pkW8OSJ0KjDGahCX7bE2DWAcweespKCw9xn4x9s6tYWvfOqSp/hYpGJQsfaU0umUWoQLFXx+G09RmErPPOi/x+9U9WNwN+O59Ont4GoSAikZw6
 pdyM27ge
 8YgjyzZCLa2/kzCB73xZlfqtkNOFtWJpN9/EYAPep1aJQQO7ll5rT6jvq1Y5rmvNOut0wmTgS/UdiP8UjfYDlBzL0mmgIa+UI1E+nYTBlkufSugAXN9dnNhEge2B+wBj60PpBHgDw7rQ0dmsWCvAkG5Kt9QfMzjL6OUKWJ8iVTYAauCsPF7ESffK9IZFgqc1Kpr3l9l2u/kpknksPnIwMQS8In7r2wnGqomuNEyErA/ll+SHwphJgZhC23Ydime/9T1WHqM1S4BdAMRfTe8zpsDeghVpzlbTKzjT/8Oj4Mjjdrv/q4XCbnNekn/tXurEmMp2zhV0fNAdb2kM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 08:01:50PM -0700, Kalesh Singh wrote:
> On Wed, Sep 3, 2025 at 4:46 PM Pedro Falcato <pfalcato@suse.de> wrote:
> >
<snip>
> > >
> > >       /* Too many mappings? */
> > > -     if (mm->map_count > sysctl_max_map_count)
> > > +     if (exceeds_max_map_count(mm, 0))
> > >               return -ENOMEM;
> >
> > If the brk example is incorrect, isn't this also wrong? /me is confused
> 
> Ahh you are right, this will also go over by 1 once we return from
> mmap_region(). I'll batch this with the do_brk_flags() fix.
> 
> > >
> > >       /*
> > > @@ -1504,6 +1504,19 @@ struct vm_area_struct *_install_special_mapping(
> > >  int sysctl_legacy_va_layout;
> > >  #endif
> > >
> > > +static int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
> > > +
> > > +bool exceeds_max_map_count(struct mm_struct *mm, unsigned int new_vmas)
> > > +{
> > > +     if (unlikely(mm->map_count + new_vmas > sysctl_max_map_count)) {
> > > +             pr_warn_ratelimited("%s (%d): Map count limit %u exceeded\n",
> > > +                                 current->comm, current->pid,
> > > +                                 sysctl_max_map_count);
> >
> > I'm not entirely sold on the map count warn, even if it's rate limited. It
> > sounds like something you can hit in nasty edge cases and nevertheless flood
> > your dmesg (more frustrating if you can't fix the damn program).
> 
> I don't feel strongly about this, I can drop it in the next revision.

FWIW, I don't feel strongly about it either, and I would not mind if there's a
way to shut it up (cmdline, or even sysctl knob?). Let's see if anyone has a
stronger opinion.

> 
> >
> > In any case, if we are to make the checks more strict, we should also add
> > asserts around the place. Though there's a little case in munmap() we can indeed
> > go over temporarily, on purpose.
> 
> To confirm, do you mean we should WARN_ON() checks where map count is
> being incremented?

Yes, _possibly_ gated off by CONFIG_DEBUG_VM.

> 
> >  Though there's a little case in munmap() we can indeed
> >  go over temporarily, on purpose.
> 
> For the 3 way split we need 1 additional VMA after munmap completed as
> one of the 3 gets unmapped. The check is done in the caller beforehand
> as __split_vma() explicitly doesn't check map_count. Though if we add
> asserts we'll need a variant of vma_complete() or the like that
> doesn't enforce the threshold.

Right, it might get a little hairy, which is partly why I'm not super into
the idea. But definitely worth considering as a way to help prevent these
sorts of problems in the future.

-- 
Pedro

