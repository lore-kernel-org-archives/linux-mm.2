Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78DAFCAC59F
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 23:32:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7403D8E008C; Wed, 17 Sep 2025 19:32:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F1178E006B; Wed, 17 Sep 2025 19:32:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6072C8E008C; Wed, 17 Sep 2025 19:32:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4B87E8E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 19:32:37 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CEE9E8684D
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 23:32:36 +0000 (UTC)
X-FDA: 83900343912.14.1484990
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 293E5140006
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 23:32:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aJLsOO20;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758151955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=obZdY71c6iG206wtVBaUpz4UE1ixuLEtL1XWdvScHds=;
	b=SmHH1kvSRDY0JKHzbdnUb+Kmo82tZT92HAk6QpvjU99zkDYDKeI8hCmwhcY7VjSi3JReHm
	SipD8ecfNwI0Z+L80OYX9rbnez2mLlRW/btDGrt1oFjfPcuH57fe/FP4gDNf8bvzIHwG2C
	5BLVfycv1EPFx98W68IoeampWVLEmfk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aJLsOO20;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758151955; a=rsa-sha256;
	cv=none;
	b=j/KoWtjkgclqoVEnp9TLPqej2uq1E/FGN3UA/nk22MUgGsx3OeQGrKJ0M+QywBN9SLI6UT
	HEiN6YPysLJxsVIECuAwZpnrAsbXW915g8sXWGnhs3ZPdTSaLUYA+tkL4oNLb80gFywkE6
	BKhnF17XBB2ujrI7KJ9nX96zuoMIg7I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 103C460008;
	Wed, 17 Sep 2025 23:32:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29CD8C4CEE7;
	Wed, 17 Sep 2025 23:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758151953;
	bh=Q1LlePHFW6OFmWWxXRZb1NAOVgqhCDoNI3SVEIRy3Zo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aJLsOO20NeMd3MhLkP7ZWhd6G7WGkxoKAeAR9nQUOYFW2HD6DA8oxRfYjz1SPlkO3
	 hMrOaaIo+facT/wqvl8beH17JYZskJHqEMifp0FxNhHxzFUULQFiujGBFm+OU9WEm9
	 yhwfXEw95u6rhoXY+PCJJkHHQ/dlshEmTqngiFhM=
Date: Wed, 17 Sep 2025 16:32:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Kalesh Singh <kaleshsingh@google.com>, minchan@kernel.org,
 david@redhat.com, Liam.Howlett@oracle.com, rppt@kernel.org,
 pfalcato@suse.de, kernel-team@android.com, android-mm@google.com, Alexander
 Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan
 Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, Vlastimil Babka
 <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri
 Lelli <juri.lelli@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Valentin
 Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>, Shuah Khan
 <shuah@kernel.org>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 0/7] vma count: fixes, test and improvements
Message-Id: <20250917163231.b5f7b8012367f033a91e6f9b@linux-foundation.org>
In-Reply-To: <e85d0b14-28dd-418f-872e-57c0127ad572@lucifer.local>
References: <20250915163838.631445-1-kaleshsingh@google.com>
	<20250915153401.61cbd5120871ee7a4e5b9cae@linux-foundation.org>
	<aa95777a-8012-4d08-abcf-7175f9e2691c@lucifer.local>
	<20250916191645.15aae276992acafe7f7e723e@linux-foundation.org>
	<e85d0b14-28dd-418f-872e-57c0127ad572@lucifer.local>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 293E5140006
X-Stat-Signature: itm3wr6kn6f9cewfrx467m9tj1kuojza
X-HE-Tag: 1758151955-15619
X-HE-Meta: U2FsdGVkX1/2DJptqT2sRDRNL53G6KrCzl50GMBw8HGxjAjDVoobSuWnKQtjbfYSl398/IPsYaOZliDYrw6m63CnGjLQRPzF6PiyP5fXYdyOyo0VBqMIcXBiYo4UWC8ESQeVYhu1pZMIrqoGZ1oBWryzawoq54rVF52JyEy0+7+44dq5WPEuxMiuA65Qsg2TKqp/KHUlrQc/Z63uDj5akUswEWBgADuH6OOuTDoSOiEtBDgx9uth9GqTfPq32EUVKy31QzWgDS4B4qrr6GtfSwpW3iaMPjWDIcIVjZ0kOARxh4/qByGtmBSmsRj4ypQSwF870DFPZ1wRJOXAzrhLGuEb4kFkZbrzjsKjpyQvc883tuWOwh/zq7jV7WHyD71mxjFzd8kqMj/+9g+dZrSkY7IyqCVpPFsPQPm6vwiV5tCNk3HsiVtKiHfw+vxLNmN6jSfPuBlnMQKwEhX/gJYKXLFw+vqTqwzDPtlJUYpo0Nnm2y/3gR6fKj1K+nXPgu5vx4ww55LtI6Qg3tHU+Pgj9YT92z4bXKNEVCHySWLPCKv8CSy0s0eBzZXxRh3w4frNrsDn6145P4/bgbPwGmr3MXlB+qZD9M5I5+NSPWEAa0d1CdGMg14HBH0ZZ7goeABkdfQXxUDtkdOVo7j/y5AM0LfSMEyNY/6ONDcT6gDBrVRRDH4s4GQVpzzqcJfLHJSXDrQ/ZfeRxAVACZlwPiyeBFPSx1iyoUZpJaVaa63aJhT2Xe3+tNHoDuj/WoD0ouPO28K51Y8AGuv6G15fuoPe5Zur/DL1fTgUdZvwXbrGHXSdXOeWA9r5/JI5yF0ecwO1FachRbd4Ly3Bk3ehYDS78WqiB3Scqt/uTSRa2SYU9yKk9LKNsmRR52yd7jNNoWLC+WPHWdH+Y+DgDGBctuaT9P45Vycst+pr8ZlOPghpuxszZe9SeI3U46anIcRpaJoMne0W+utjsZalS+GiS4h
 oGVaDMz6
 T5Th0cgfuDEJV7JMMZbk8GjRLmjF9rKAbw2m+lQquoxgnDEHAhBaxyScIzObXsHRW4+xcv7YQs7D5/pJqp3J5NUv/K1RCy7AIvC76UH/RmUJL2WhC2P8hYPE7/+I6Y+ksh8SIBxLdPPDAjoTK3fMpMilFRTKJuhUMiemqnAbKhrw8VgC+ru/bDfl5mn0CnLj/kIoL1HVCn79BZJzt6sD0PXA6oW/7NCMo7P6o8t9gQooMeThdrXzA3VviiHRyjZbsCDGgVEnHRJ7vUpM+saXVbBLWAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 17 Sep 2025 06:36:34 +0100 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> >
> > > Perhaps being less accepting of patches during merge window is one aspect,
> > > as the merge window leading up to this cycle was almost the same review
> > > load as when the cycle started.
> >
> > I'm having trouble understanding what you said here?
> 
> Sorry, what I mean to say is that in mm we're pretty open to taking stuff in the
> merge window, esp. now we have mm-new.
> 
> And last merge window my review load felt similar to during a cycle, which
> was kind of crazy.
> 
> So I wonder if we should be less accommodating and simply say 'sorry it's
> the merge window, no submissions accepted'?

hm, I always have a lot of emails piled up by the time mm-stable gets
merged upstream.  That ~1 week between "we merged" and "-rc1" is a nice
time to go through that material and add it to mm-new.  I think it
smooths things out.  I mean, this is peak time for people to be
considering the new material?

(ot, that backlog is always >400 emails and a lot of that gets tossed
out anyway - either it's just too old so I request a refresh or there
was a new version, or review was unpromising, etc).


