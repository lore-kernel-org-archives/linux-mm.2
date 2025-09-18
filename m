Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3A2ECAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 20:59:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34EE08E00B7; Thu, 18 Sep 2025 16:59:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 326818E0068; Thu, 18 Sep 2025 16:59:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 263EE8E00B7; Thu, 18 Sep 2025 16:59:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 13BD88E0068
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 16:59:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A9CA811A427
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 20:59:52 +0000 (UTC)
X-FDA: 83903587824.08.CE4DE85
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id F14BF180005
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 20:59:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0IiWOYqd;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758229191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bfW2Cz+0/db8RPrmt4Tb8ibMLod9UUtO/BmQr6x/cdE=;
	b=5To/6SrkPk7swzDIZ3Y+EAlBtbcwzF67mZEhOkKFvNXe9LtsC36buYqJuhzuvfdEscLdoi
	BHPlRq5zqRPJvTI0K9H+U+i6rvUDnEoCZqpWa5H0ceBAfNoWEG8rq0WR3admfiS7I7iI2I
	q2uqV2pDhB0AUU244GtR5yDl2tRwP4o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758229191; a=rsa-sha256;
	cv=none;
	b=MwrGVI/RyrhQnUvznbuR6kbxwEzW8HkUd8aPVOuyEIsTW+Mf8yAm60NMGHI0iSCjNnRVqx
	lsIuGKktf3ylBCcJCYZzWRuUlqKFkq62w271/cyVw3cN1H4IDWJ4J7ico3HHUdKpA+Crwb
	Z7uDRwn9iWPsYynpac4EojGYoifnzrk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0IiWOYqd;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AE7BB44166;
	Thu, 18 Sep 2025 20:59:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F17CC4CEE7;
	Thu, 18 Sep 2025 20:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758229189;
	bh=elOhek8sIU44GYAtre1DnN6ZeNY6fSeRLQXHd5WnQrQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=0IiWOYqdGBx5hvY1ckMxBqlziJs5ywHDrD8bc3p4KEQ+/unJWdMR6cAFZ5LztZtz4
	 tGUeXgnad3ckGnURulgoAObqqeDPibMEE8JFGibkowfhv9rknk7PftaPGmLbr4Rb1s
	 R6Snd9ceQES6mfnhzrNLgQ5AnRfzcDTu6ExYwZZE=
Date: Thu, 18 Sep 2025 13:59:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, Kalesh Singh
 <kaleshsingh@google.com>, minchan@kernel.org, Liam.Howlett@oracle.com,
 rppt@kernel.org, pfalcato@suse.de, kernel-team@android.com,
 android-mm@google.com, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Kees Cook
 <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Steven Rostedt
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, Mel Gorman
 <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Jann Horn
 <jannh@google.com>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 0/7] vma count: fixes, test and improvements
Message-Id: <20250918135946.4f4432e0c69a465c89af14aa@linux-foundation.org>
In-Reply-To: <7e3de8d3-c064-4ef4-85f8-48294a238336@lucifer.local>
References: <20250915163838.631445-1-kaleshsingh@google.com>
	<20250915153401.61cbd5120871ee7a4e5b9cae@linux-foundation.org>
	<aa95777a-8012-4d08-abcf-7175f9e2691c@lucifer.local>
	<20250916191645.15aae276992acafe7f7e723e@linux-foundation.org>
	<e85d0b14-28dd-418f-872e-57c0127ad572@lucifer.local>
	<20250917163231.b5f7b8012367f033a91e6f9b@linux-foundation.org>
	<cfabded7-442e-40d9-963a-597a42da581e@lucifer.local>
	<0c068e35-0954-43fd-b3b3-20786a6a12fe@redhat.com>
	<7e3de8d3-c064-4ef4-85f8-48294a238336@lucifer.local>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F14BF180005
X-Stat-Signature: d4wsrfpzdnixysi6zoipj3796osqg4b5
X-Rspam-User: 
X-HE-Tag: 1758229190-225335
X-HE-Meta: U2FsdGVkX1+5S8FPLnGC9jZvGI95TTQ/2Oael5v/6tlKS4lARQ24UNmZxcaNDYN7+9Nd/C2oNVAW0upiMYGCdODTj7hFSNFWqwXesNdGaRTXm8TVCGTJ32oYQPd7o8W3jzo0iWOsqNsI3KTjifc1R6jBhFANH0nDIt754gIGs0RRSihgwzQ1iVIaSXNM6CNTSSzT3QqkCksekNAZqlXgu0bfa+nWaL7C8MknYh7l+jbJu2XzPDrsc2eKmPcgaJjqTkNUVOxQHqX5zlx8u7gz8wwcFZ9SAag0AIXRs98UOiyP+TaSynRO9mF8iBtC1bon2dgmPAMCHa2pncqVEQTj1/95qElY5QBSD/JlYqWj8WKShpiB0B4W3y7J9MKM6GPolTKlUcHHBA5bFRejtuED33V8b4h86vpeKdFsNlrowdDWGqUZKwupmxqxMzcC1tfc4ZnYMNqxz8DKoqG17ouP0FSqpN0hJXVaf38BxmAN3z3aNS1YBmwlr/4LC4LXv0KZi9LOo7Kga7Fp5lttg1jLfpBDk5p6Y/NxD9wwnQiUh18oJPrPhw/wzcbz3YBbgh8I3PcQ0t2OyQAgnMGSYEm1yKblFEBQZRKGHwoj0h09i4O2uS9w7FPrgR1VPBwTfm8xhkg6//GJS420kropqTKtRuJZeyfkocTFGHpGubCHz64egOlqmTzFCOYd27GMxT4REeRlG2MOsOesjXbQAis8DPzbrAhE4znMZRNv4kb0kSCAEgS0Yu+q/qdrj276GMZTTChCqjswink0DhkMjftKa1dS8gMOlyrxNPDCewDhImM4lBU6jnD/ahSh4SSNCJWESEA6++7jDU+HPhBReoE5f3CtRJKxCw1cMVt94EYKmE94JM9cagtZ5BSZ0dkz7QLwEro3gfgbQ6r8N7mugAfI3BcZ5bTkFKCoRzIHHL36ZDE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Sep 2025 13:49:33 +0100 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> > > I'm confused, why is the merge window a good time to consider new material?
> > >
> > > People have the entirety of the cycle to submit new material, and they do
> > > so.
> >
> > My view is that if you are sending a cleanup/feature during the merge window
> > you cannot expect a fast reply, and you should not keep sending new versions
> > in that timeframe expecting that all people you CCed that should have a look
> > actually did have a look.
> 
> Yes exactly.
> 
> The problem is all the conversations and respins and etc. _do_ carry on as
> normal, and often land in mm-new, queued up for mm-unstable etc. unless we
> happen to notice them.
> 
> So it makes it impossible for us to just ignore until the next cycle (or need to
> go through every thread that happened afterwards).
> 
> And people know that, so just keep on submitting as normal. That was _really_
> palpable last merge window.
> 

Well, what else do we have to do during the merge window?  The previous
cycle's batch is merged up and there may be some fallout from that, but
it isn't very time-consuming.

If you're proposing that we start to use that period as a break for
sanity purposes then OK, didn't see that one coming, don't know how
widespread this desire is.

But perhaps a better time for this quiet period is during -rc6 and -rc7
when the rate of merging is throttled right back.  Or perhaps from -rc7
to mid-merge-window.


