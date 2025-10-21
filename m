Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BEB0CCD1A7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 16:46:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78AED8E0010; Tue, 21 Oct 2025 12:46:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 762F08E0002; Tue, 21 Oct 2025 12:46:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69F2F8E0010; Tue, 21 Oct 2025 12:46:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 549FD8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:46:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0936EC0631
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:46:51 +0000 (UTC)
X-FDA: 84022700622.04.D9160B6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 56C854000D
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:46:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="gsG/gyUz";
	spf=pass (imf17.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761065209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6tV7T5OengZRGLMLGopc7dmtJtAh/cFAgs+ry0/4uRg=;
	b=pyeAntizPyDwD+bS3JM9OxOg7tze04zQLhA3xV/3ZJS2x9/+L/2YdRvWe9e4hkaBv+dWS7
	WJ2/ycm+JON97Yn7vdTeU4oX3SZ3o7iw2q/QSxZfxWG90IkmCFpqwAhPpjCPvGUlPhOe3S
	Iyz45IHTT10IAPbkDNpXRFEbl7BgOdk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="gsG/gyUz";
	spf=pass (imf17.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761065209; a=rsa-sha256;
	cv=none;
	b=ESyuQjDRjehRczYPymXvfqFkuZoD1ea09G0mREy29yABWdRVl+neujuedckY0+/62RZF5w
	rGeDv2erTyemY46T6Mieg5uYg6vHydvGKnLCkLR3x4Y5mydWhiZr3Ml172SsgKPvYu788u
	SznywtA8ZBtC4gxWasxYHkyqNi8iDvI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9B5D1601BA;
	Tue, 21 Oct 2025 16:46:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3D6C4CEF1;
	Tue, 21 Oct 2025 16:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761065208;
	bh=arHrvou9uQqGbHOB/p6IMtkA2TNGKttCri6QEWXzjxg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gsG/gyUzuDKYqVOuHlctFQ/BUjwTW8253Q/OoKIbt8mKs/yJaITjMj3rQBa+JAdBX
	 LVtTd8QQm91N5li/9P0LkppGSfZPs5ib5VMM+6C4hFggchYFS9xviUSlWZgEt6KWtm
	 mkaP3Qaoi7DjgfO5kNC5Z8otPquVU9IvBZcuvBbg=
Date: Tue, 21 Oct 2025 18:46:45 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Gabriele Paoloni <gpaoloni@redhat.com>
Cc: shuah@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, corbet@lwn.net,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	safety-architecture@lists.elisa.tech, acarmina@redhat.com,
	kstewart@linuxfoundation.org, chuckwolber@gmail.com
Subject: Re: [RFC PATCH v2 0/3] Add testable code specifications
Message-ID: <2025102124-punctuate-kilogram-da50@gregkh>
References: <20250910170000.6475-1-gpaoloni@redhat.com>
 <2025102111-facility-dismay-322e@gregkh>
 <CA+wEVJZEho_9kvaGYstc=5f6iHGi69x=_0zT+jrC2EqSFUQMWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+wEVJZEho_9kvaGYstc=5f6iHGi69x=_0zT+jrC2EqSFUQMWQ@mail.gmail.com>
X-Stat-Signature: hqoriphe8zcrxr5hdrextu9sngkyeqrd
X-Rspamd-Queue-Id: 56C854000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761065209-223361
X-HE-Meta: U2FsdGVkX1/mPhBOyxbgjNt6wiGo9iaU1e5BJ0jIqlVwUwftGC9dp5izIo+DRMFSqXNxWFDXD2aW8SeF+mooELpUOraAfuwUYTAXzv0xQnJMMu4QcGV0ftX4d2qpMcgWoWwkd/k7HyoDgRP6GnnPYB2yUopshUItXckBBVPrkaqnPjLh3JGBPMvCEi87M7V9zlVWzwYD34NFaFGZoDdHnxwdgOiAIA8eP1SqhTuN9t3XktLABW9q+k5lxdBjR++qZJTDV5cIhi3eAIw/rA6Gr2/1dT6gS9i96xyDIhsCifx9YSwJxCxPI8cddcPlQ+SMCW2XLtFSybnZvVwSPEv+EtQMfb9+mWeb5YZxMOCcudtJLJROo7IBB7e5x3f1IOC6wKHZ1YZ22QcsUbrm0IDGQz0VYcLfk2hjIWrds2+XqheyR56biQ9tk9xQo4ywmWyhu/CxJzfF4KheqvXKAZg9X7JHHHRnXCXspCViROPIadP0H/ubDOUXwL1zL3rU6I/x86UZ/gySDzaL76uPcDOnNCOqcEfz8A7HSRUck272EuJOCdTLTZHgAjgXpz0yzRsOz/eqMhB8PvhOuKHJrqWnbDYlI3wHeqDj+y1xE5DZL/L8stqEcPtdTeXu7RIwOPK1vJJ+c6n/YmgVi6rE+4HUkvzu69hgC8+TVZAQCyX5VnU4kDvNbHr+jWQqvDxE21pi9SU/OuQNT72tYWn9tMSqQA2kAVWyI5gPAbwFyLst8AHJ9uJEHxw9bVdxHCp6mO8p+Q5Yh2MamfoTvclPv5SsBstvaZ8oP7jMBXf75GAIjjWqdXm50eDRcHZc+gAvzHB98jdRBpG7T+qMKCnQyPi8L3EriL1GvVT/MD6autVfoHWK9T2PW0Grw6K+UT4MpYcPeMwo61xsovI9469X+urwiCRr1vQdscFmyNim5hgUIVrmpbE8sXKmt6wtk1Or9eezF14aYO4HDLjNsT9vmIe
 8CXrydyP
 NrIQvk4WxCN+74l4IGzuIyOdIOMhXJEwNoyMs4QAe0zvmLwxXXBC028zwr/PBu2k5m9Lo+hitlpZyA1NUob80Q9z9tgsDI6sJ29vbMpJiYzn1LBrgCjojDoySM0yUjw9geAXCQm4L4w8FPLQO89mzwT7CKt3/WCk1fWXpX10XNyBERygtasaRzML1tkhe4XmraLB6B+pUXLi3s5QqglCPlRS4Q2hGOgVFzspMvgWT597CWXEbJe+e3B3+xPujTSxV80c4QfQYt353BL0rFpZnmcFmrRqSe4yMCQ6sWYWw9a8mMuYF2x9ktRuS7eW/ua0o2mxlZngEZKcpxuEjuMq91IQtJbZFaesjXDsg9dL+VEU/9kpVUF5VFaFdwhVn3GFDcOXkDwg9acLosi8hmkAd8o6kw6ixeGwTk+NgdbqqmhoF355FLWr3TDfjIlz0pjGsh4sS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 11:42:24AM +0200, Gabriele Paoloni wrote:
> Hi Greg
> 
> On Tue, Oct 21, 2025 at 9:35 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Sep 10, 2025 at 06:59:57PM +0200, Gabriele Paoloni wrote:
> > > [1] was an initial proposal defining testable code specifications for
> > > some functions in /drivers/char/mem.c.
> > > However a Guideline to write such specifications was missing and test
> > > cases tracing to such specifications were missing.
> > > This patchset represents a next step and is organised as follows:
> > > - patch 1/3 contains the Guideline for writing code specifications
> > > - patch 2/3 contains examples of code specfications defined for some
> > >   functions of drivers/char/mem.c
> > > - patch 3/3 contains examples of selftests that map to some code
> > >   specifications of patch 2/3
> > >
> > > [1] https://lore.kernel.org/all/20250821170419.70668-1-gpaoloni@redhat.com/
> >
> > "RFC" implies there is a request.  I don't see that here, am I missing
> > that?  Or is this "good to go" and want us to seriously consider
> > accepting this?
> 
> I assumed that an RFC (as in request for comments) that comes with proposed
> changes to upstream files would be interpreted as a request for feedbacks
> associated with the proposed changes (what is wrong or what is missing);
> next time I will communicate the request explicitly.
> 
> WRT this specific patchset, the intent is to introduce formalism in specifying
> code behavior (so that the same formalism can also be used to write and
> review test cases), so my high level asks would be:
> 
> 1) In the first part of patch 1/3 we explain why we are doing this and the high
> level goals. Do you agree with these? Are these clear?

No, and no.

I think this type of thing is, sadly, folly.  You are entering into a
path that never ends with no clear goal that you are conveying here to
us.

I might be totally wrong, but I fail to see what you want to have happen
in the end.

Every in-kernel api documented in a "formal" way like this?  Or a
subset?  If a subset, which ones specifically?  How many?  And who is
going to do that?  And who is going to maintain it?  And most
importantly, why is it needed at all?

For some reason Linux has succeeded in pretty much every place an
operating system is needed for cpus that it can run on (zephyr for those
others that it can not.)  So why are we suddenly now, after many
decades, requiring basic user/kernel stuff to be formally documented
like this?

In the past, when we have had "validating bodies" ask for stuff like
this, the solution is to provide it in a big thick book, outside of the
kernel, by the company that wishes to sell such a product to that
organization to justify the cost of doing that labor.  In every instance
that I know of, that book sits on a shelf and gathers dust, while Linux
is just updated over the years in those sites to new versions and the
book goes quickly out of date as no one really cares about it, except
it having been a check-box for a purchase order requirement.

That's business craziness, no need to get us involved in all of that.
Heck, look at the stuff around FIPS certification for more insanity.
That's a check-box that is required by organizations and then totally
ignored and never actually run at all by the user.  I feel this is much
the same.

So step back, and tell us exactly what files and functions and apis are
needed to be documented in this stilted and formal way, who exactly is
going to be doing all of that work, and why we should even consider
reviewing and accepting and most importantly, maintaining such a thing
for the next 40+ years.

> 2) In the rest of the patchset we introduce the formalism, we propose some
> specs (in patch 2) and associated selftests (in patch 3). Please let us know
> if there is something wrong, missing or to be improved.

I made many comments on patch 3, the most important one being that the
tests created do not seem to follow any of the standards we have for
Linux kernel tests for no documented reason.

The irony of submitting tests for formal specifications that do not
follow documented policies is rich :)

thanks,

greg k-h

