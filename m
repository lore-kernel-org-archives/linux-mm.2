Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC460CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 15:07:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90C2D6B008C; Mon, 28 Sep 2026 11:07:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BCF16B0092; Mon, 28 Sep 2026 11:07:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D2A66B0093; Mon, 28 Sep 2026 11:07:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 54C276B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:07:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D504B4024C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:07:03 +0000 (UTC)
X-FDA: 85263498726.11.DA06D90
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2BB1518000A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:07:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DEfzoT9P;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790608022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pdaf0FQ30g0zD0j9dALtzclRPy/x07xaaFy8X/gBwYg=;
	b=YG2F6N15Ri2jG0gQ2wPCVjvuY5uV7jP1dHxAXGNqL7MBEgczApnfxbbwW8pECXmcTgBa1M
	+00Ix5eL5XphchfICxkkWED0Id5XakrXzT5S6K6vMtvJGFwuBboyS3Lmsnx3Q5kJ54coBB
	uwjbfimpyqW1AGYeCcgoMJG/U7kfjB4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DEfzoT9P;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790608022;
	b=tKfUk8Lqqgzoa4vpJ0WsVJEI5d8LIv3aPBJUWBojeFgU0WUgzbElOWeJM79wQT1MDOS7lH
	BpUifAzrFanrH3bpz0jkV0rsxF/suo0xLINAFXuwtmL28Cg31TZ+CPsmNwi88K3mzbkCHI
	y6ChsNnn3rNP1N7XHzv+RhlR0voWd7w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0107D4342E;
	Mon, 28 Sep 2026 15:07:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7611F00893;
	Mon, 28 Sep 2026 15:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790608020;
	bh=pdaf0FQ30g0zD0j9dALtzclRPy/x07xaaFy8X/gBwYg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DEfzoT9PtlYn8foW6UidpY6h/EFtPzGXSr5IBEM6s+1E13y8kzjYjwuO8fe0yCdwB
	 klGBLB6eUdKFQzCjy9tbMmy3Yv8wyl3W7CWaZS5jfTU2W1mOAAeRqUgVswqrCWh6Jw
	 MsWxlcA/P3xlNt5UwqU2aP9doFZ1T2TMtkxAvjvpvbhgM6bdKgmwdcjhqGUndUb9LA
	 baIkicrg4RDGzTP3f+C8QGi7MOzy+zPfo2RV2k80LvBgOAc9mEW1fQ6L8cRUrAdPfI
	 SOQ9S4uD8pDH9xp4BKMlJGJZMqTR0JNijnYJEztDvmvaHDP3lrecAYCaiQvjKv6pqt
	 3aFnZePtW9anA==
Date: Mon, 28 Sep 2026 16:06:55 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Deng, Pan" <pan.deng@intel.com>
Cc: Pedro Falcato <pfalcato@suse.de>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "liam@infradead.org" <liam@infradead.org>, 
	"vbabka@kernel.org" <vbabka@kernel.org>, "jannh@google.com" <jannh@google.com>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"Li, Tianyou" <tianyou.li@intel.com>, "Guo, Wangyang" <wangyang.guo@intel.com>, 
	"Zhou, Zhiguo" <zhiguo.zhou@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH] mm/vma: avoid redundant file rmap tree re-insert on
 new_below=0 split
Message-ID: <arp_gP_o9eacNXre@gremlin>
References: <20260924054301.2330822-1-pan.deng@intel.com>
 <araI4WsI0XMXOR10@gremlin>
 <araVBBBVY-jafePL@pedro-suse.tail5790ac.ts.net>
 <arab1d8-4b3SzoI6@gremlin>
 <PH8PR11MB68327CAD97AC4E0B161BB997968D2@PH8PR11MB6832.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH8PR11MB68327CAD97AC4E0B161BB997968D2@PH8PR11MB6832.namprd11.prod.outlook.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2BB1518000A
X-Rspam-User: 
X-Stat-Signature: wfi494dyzx38kkq3ed49qbi1res7erko
X-HE-Tag: 1790608022-201424
X-HE-Meta: U2FsdGVkX1+t09neSxE3gKaor5EwvouJ6+l30LddHFHGJe95PlvfHGm9abEHiB7MYFmhT4jMRvEvfbyBnGYt7WP9boaJj7G+F4eIXIqyWs3WpDyzgD+9P9oML7lieSNb4jNPEruiZfrlhrWC18EIrSYx7b73m0sRzc/+MCFnaqdPD/4tz5LYIhEIJgQ0Id9nbjvWWRaym2O3hv/mDN0FikQA676EwSi8kdekGfuVzF2JCAJlE8kvYd4OvbSjqEvxp9M49YpJjh2Zl1yXbCrw+fPOaZzRQKfyBS+rEMP/+v+oLjDrt8syMygnEdrSxdTXYcW/2zdEK+xK7Xrw1RD0DYKkyAKF9FXuxivZVySri5qdCrYWKIeKZImlX0gxN/xL60RozrkTuykoriwtbHnfO5bA8JHFAuduTxBRuHx3O2grSJFuC8yzu6g8zg/CoDrbVEVJP3FqvpEBDrMjlsGCMEOgqIklxKdEiV9QhA+BgBmZe1HvjNzx4j/DtjtGveG72eAcqn9CyyFS+EIg8O5SKkNoHaoFZm/USayu5YVJNLh9U/abZ8aCgiEadnhJAL5elp/QptypC16HggPiLzvEIOBkXjYPTbdRvCVohfk4hh3wd6flJAwVRvbZ8ih0yem6ZRoYakttNowdFLUvKCu9CdU0UHmWcJ5MRffZ+YlwpTRWNSFUPGntXezGzOzGRFSeHe1emQardZmM2NmtKA0avpxxlLYz5C6v2ssM5VQochsaUdpiRA9CHUTOrLuvBDrHr4pWmSEFdFQSune/LUwwXnrqapiRpQm5xe7GpO2ROYdtbFnjttVse7fLLKWNsNHAvuUTLcYw7hptgLeKuiVRnzKOj/XcyPRmwYjQXMJOxv/MKIhj0DtX1vnw891SDvb43dn/yzhh0MPjdGOiuM86XkVG/R4FsqjNznB2M3eGWa2CCwa6hbp6CfrsQZP5+wDMLGc7ihuM9PaRX4KEntu
 YJU7Advv
 jTTT5fMhOV4Ft/6o+4Mt60EeEoh7NUW8TkIsFeLZMscsJERwgmRF5rw/fr5SVK7ATPaBbF4NbELH3JwDm3dW4yy14z+0rzN4bmG8csssKL4FqcYxcqpx+v0vn7AJ2e0Yo81wd2MCcwWOgBufMSyJ9uMRPvu8StLMYRDEiPSpUBypMw5qk6EHEaJtl0N3dn4MX6NuRJnmuByPnJ6XcmrPGiQmLfwho0+2Aeyxqcli8iY2UVUxz9nrDbCrSEPVxB8i76RmoKnj5E47r8SBp0RNATBMAR5xr2MK9cmKMYG6qndCesD5C+jlvu/W9k6lUvtEm5Fi0TBufei1WyGUj5kAKehQG2BSjckwn2dcjyX11YD5G7t6//D8ZoviESl+MDPaBjYcE2ivtmwruWffPmgq06W/fQSPp0c8JiEV7GQ5EnKll8EyMQzE6n5+KmMiEHLVYOUqG+7rRNJaYQVEFLa/ODjSfSfPPRY2QhF0HL3ZmmfsILaMR/P12i7lFd++HhKukqWjBn7i6TrhCsau91FqOrkqppSDE4tbu8Za6eTQne4psHq8D13AakaF6wDgm68yqHlA7k8WH+EfmueTgpdZlxmbT8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 02:44:14PM +0000, Deng, Pan wrote:
> > -----Original Message-----
> > From: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > Sent: Saturday, September 26, 2026 12:09 AM
> > To: Pedro Falcato <pfalcato@suse.de>
> > Cc: Deng, Pan <pan.deng@intel.com>; akpm@linux-foundation.org;
> > liam@infradead.org; vbabka@kernel.org; jannh@google.com; linux-
> > mm@kvack.org; linux-kernel@vger.kernel.org; Li, Tianyou
> > <tianyou.li@intel.com>; Guo, Wangyang <wangyang.guo@intel.com>; Zhou,
> > Zhiguo <zhiguo.zhou@intel.com>; Tim Chen <tim.c.chen@linux.intel.com>
> > Subject: Re: [PATCH] mm/vma: avoid redundant file rmap tree re-insert on
> > new_below=0 split
> >
> > On Fri, Sep 25, 2026 at 04:43:37PM +0100, Pedro Falcato wrote:
> > > On Fri, Sep 25, 2026 at 04:27:44PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > > > This change skips the re-insert for that case.  vma_prepare() no longer
> > > > > removes vp->vma from the tree; instead vma_complete() detects that case
> > and
> > > > > only recomputes shared.rb_subtree_last up the ancestor chain.  Everything
> > > > > else keeps the remove + re-insert path.
> > > >
> > > > This could really do with a diagram and a simple explanation.
> > > >
> > > > In general you should rewrite the entire commit message yourself and not
> > > > use the LLM output at all.
> > >
> > > +1 on this. Even with the Assisted-by, this needs to be understandable by
> > > hoomans.
> >
> > Yes.
> >
> > > > >
> > > > > Measured on v7.3-rc4, on a 2-socket 192C/384T system running
> > UnixBench
> > > > > execl (384 concurrent execve of the same binary), dropping the redundant
> > > > > remove + re-insert yields ~14% higher throughput by shortening the
> > > > > i_mmap_rwsem write-side critical section during the file VMA splits that
> > > > > execve performs on the shared libraries.
> > >
> > > For what it's worth, I'm vaguely accepting of a similar change, but this needs
> > > to be _really_ well commented out, and ideally in file rmap code, _not_
> > > spaghetti'd in VMAs. The interval tree is complicated and some bits are not
> > > very intuitive. This needs to be robust. Not LLM'd into existence.
> > >
> > > This also reminds me that I should reboot the sharded file rmap effort...
> >
> > Indeed, which is why I'm treating this as a report rather than a patch.
> >
> > A member of the core team can do the actual work.
>
> Thanks everyone for your patience and time to review this patch.
>
> You're right that I should not use the LLM output for commit message. As a non-native speaker, I used it to generate commit message and comments to make it read more natively, unfortunately it had an opposite effect. I'm writing by myself, from now on :)
>
> I just saw Lorenzo has picked over this work in https://lore.kernel.org/all/20260925-speed-up-inplace-rmap-v1-1-babc48ce7c83@kernel.org/. I've read through the new patch, which extends the scope to anonymous and covers merge and shrink scenario, more complete than I just sent, it is great. I fully agree that it is a very subtle and fragile part of the kernel, I did spend time and struggled with the patch, very appreciate your help.

Thanks :) and thank you for your understanding.

If you are able to test that locally with whatever workloads you've been using
and report back there that'd be helpful? Thanks.

>
> One last thing, and please read it as a question rather than a request. I read submitting-patches.rst, and it says "Reported-by" tag is intended for bugs. While I wasn't reporting a bug, so would you consider "Suggested-by" instead (or even "co-developed-by") if you feel that describes it better? I'm fine with which tag you think is accurate, and I'm not trying to reopen the decision to take the work over. Again, very appreciate your review and looking forward to your help in the future.

Yeah it's not quite the right match, but often the resultant final patch is
quite substantially different than that submitted, and Suggested-by generally
implies:

Person X: 'hey I want to do ...'
Person Y: 'have you thought of doing it using <great idea>'
Person X: 'oh yeah great thanks will respin with that!'

Whereas in this case where it seems it's end-to-end LLM, none of that really
matches.

And if any tags are to be given then Reported-by, Closes is closest.

However, since you're explicitly asking for it and the idea itself is nice, I'll
ask Andrew to switch it out :)

(One small note - please wrap your lines to ~75 chars in emails makes life easier!)

>
> Best Regards
> Pan

--
Cheers, Lorenzo

