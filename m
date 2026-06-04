Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF757CD6E6D
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 14:46:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E44FA6B0092; Thu,  4 Jun 2026 10:46:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1CCA6B0096; Thu,  4 Jun 2026 10:46:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5A756B0098; Thu,  4 Jun 2026 10:46:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C86266B0092
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:46:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5BC68140113
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 14:46:43 +0000 (UTC)
X-FDA: 84842506686.12.74C3D2E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4B38712001A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 14:46:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=niy8gQ+G;
	spf=pass (imf29.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780584401;
	b=1jCG3tGXWeWbJeNOm246c8RXMQJSbjmRdHlSSz8nINuLvYgdnx6m/EMh/K2pKlvAVmRyp0
	g1RkbtwSNdutVTJo83UZ1YdZ5ZogWHHaavCgoi2F8Y3yd2JZ9H8jf3uhdge8UytaRKYPND
	JEboJywCTgLel5Dz5kjTKDWJyIIVJIQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=niy8gQ+G;
	spf=pass (imf29.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780584401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V97EjziPWX7/aWg2UdD5uDnb3HG95TQLDqrOqOVej0g=;
	b=SpXYT6E636lbYcNc7m4+a/H61QKosxu2myRHm24VIPDz3kdGcDOEZDEbb/HZL0vIE/1y7j
	aRqpoU1++xeN2HgOLu7DqbxgthqShbBRLXq75aSES7dEqRFuTr/Kp4CWox23mPVxsw5ZTe
	mhMg1bs+am0TsOyFUe60Qu/Qy0eDuXY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=V97EjziPWX7/aWg2UdD5uDnb3HG95TQLDqrOqOVej0g=; b=niy8gQ+GsklXMudI64cl6QUE5W
	PusadtssOexwTK1gOY6YfSiIZk8qPfZMLZqZKDbr2D9LPzlERlOwh09zygRqx6HxjXCXGcJdtAmMZ
	POnFqCq8OdkcmIyEb3PuLPIJ/nK6lenV0stesjXWfqY6rKtaoE3LSDfNLS78swMmacO3n535Gxceq
	wKrVGtNXL+RjdTXGduiuwW/Q4ykv06GRzswmQ0A/KbL0BfZHRne1PUTDKZ+lC8lW4UKqno0rOScRt
	IfLWtpjB3ixeK+TFnCGQOcwvyFIDtsJICOpf/lUWnYXrasc19dnYxhzIBgS838XtY6oODL/hZp1Im
	/tbghusA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wV9Kt-000000064Qn-0gwN;
	Thu, 04 Jun 2026 14:46:19 +0000
Date: Thu, 4 Jun 2026 15:46:19 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Mike Rapoport <rppt@kernel.org>, Jan Kara <jack@suse.com>,
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Dave Kleikamp <shaggy@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Breno Leitao <leitao@debian.org>, Kees Cook <kees@kernel.org>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org,
	linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-ext4@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 10/17] jbd2: replace __get_free_pages() with kmalloc()
Message-ID: <aiGPu2XwaM31fvl9@casper.infradead.org>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
 <20260523-b4-fs-v1-10-275e36a83f0e@kernel.org>
 <yfzx3jgzwesernofl7mzixa2mhjfii5v3o7yapghtmozixrpfu@6bsh7iixyiov>
 <aiEX4UTxEnBTjVKo@kernel.org>
 <ximvn6jwgtam665a4droqkp73o55kwvd5uukyidwjesmysobth@oe7rigpsjfkz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ximvn6jwgtam665a4droqkp73o55kwvd5uukyidwjesmysobth@oe7rigpsjfkz>
X-Rspamd-Queue-Id: 4B38712001A
X-Stat-Signature: yz9d3ijypdm5c8o6pgrwndzjpph5ecso
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780584400-53500
X-HE-Meta: U2FsdGVkX1+Vbl4mqZSIZEFU4/XaG5S20wJIm+0MourDOEh3i7rL4tSSQu/AJ/G4lupNLYHA5GRKcz+KZ06xd5hrzu8kTmqeiSJJovEHzKS1krZBbSsSi0D5L0i3XuW0BK6Yl0VRLnQgKK9sszEmLJPT1NuBMNEG+tGH+uZdk2E3i30fGGCLu7CLNTrrWsFvgtO8I1MDDlpN7/jDufoVZqgd9cUMjfQBrG7RNCVOxqjgc9fWgKUeSBAV3DEREu+1bBcMH7xo4+V7zToxpLbLTlpfHMlrNVIKMRbHQpQfIG3oejDiuDFA49yBP5PJX2gdIfFt+4QVah4x8CiNgWGiY8DIIfh6fMq7vlV67PzE5COibi1NjIIVM+Iu8Zsm5Rmz4xBFzQF6Hiq7SwnbqetuAOZNrKx6yduHlYs7lQMHp/GM6aG9pXjVu9Ww2WNFSSzaMAVtejEjdQ0IoF8qnx8MUsU6jc1wliNN7ZOFpVihOsD9I/7GoFO2oFuHEECUdbtAtREtVZwMd/RZLLZCXI5tr6oVK0YoGE/PdrOH42vPDYVf/LicEnPRwWUF9L1bYL7hanFgzHpOaP41Z/HZnC8YFZPrqGx8ymH98tL7A8kZYHkODq5ItT1A9Cv7E/t0qbIXQAQzJYXqCuBJFK47le50W9MXlr64vKgoyhAJk9cYgW2ovXv9CZyqI6iHy07DRV5FlAxb4i9qj8V0mabRvNQIsmaqDNwIunCGNr0r+OnLraiJ+jRZAlZXistxXA6NxZJhj4IXSd5nOANWGMJLwIWBri5pLsEzilDOYhlmvNr0F8vEDrOsSoXnvkUUjhaE99lKGQlFuRUfclTTfXd4yEXkEQHXMIixTGX+R2zk2E7xvhqSQvQt95vtXXmzRVyEdDNq6jNbR2r25YlZg4Ur0d0ZHK+xLdBQLoUpejrfhxvilGio5yHTVFIPe+Fq09emb5ARgSgYjOJSQSC2BFbsbb7
 7elEBCNt
 jXO6onQ6FibICU/VZ0PHjCG9KBXqGLWC9R1J0aBnIt6oK6Z6RfFZBbkj4da1MV4p6aiBPmz7w/Q0c8e7Eg7VlgurQ4HpiyRnSlsh/XE0/yI5F1aupm9+xLFvQdAgJvXmsNNhc25bAcMt6TJObfwRynTKYDlnp+FJyKp0gmkIR/8pf3b4umfJPBMMytEmiPIE8FSnDHJEeB6yclEbsfhanbacmVNMq2VC0ozrJFMkhdBpQz4Pbjuvo64PpO6WH5q488CzERDD8dYN4m+gGwHocAriN8GESzobsO6x/TMH1JZ2PlDETWSLkazMpXw4oJqza2XP/RcMxsrTrfvb9UTA6Au1nXKk8E8O/ca5JTBzaSEBm4Kb8mq4cJDhoooY6N4k0mGLZ6wzfp2De2lI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I'm hoping you'll take my "Remove special jbd2 slabs" patch instead of
this one, but answering here anyway ...

On Thu, Jun 04, 2026 at 10:05:52AM -0400, Theodore Tso wrote:
> On Thu, Jun 04, 2026 at 09:14:57AM +0300, Mike Rapoport wrote:
> > There's no memory overhead when order == 1.
> > As for the CPU overhead, the difference for the fast path allocations is
> > not measurable and for the slow path it is anyway determined by the amount
> > of reclaim involved rather than by what allocator is used.
> 
> Thanks for confirming!
> 
> > Larger allocations (> PAGE_SIZE * 2) go straight to the page allocator.

That is a detail subject to change.  I have some ideas ...

What users are guaranteed is that kmalloc returns physically contiguous
memory.  And that if it's a power-of-two that it's naturally aligned.

> Another question: Today, we can either use kmalloc() (or
> __get_free_pages, previously) or vmalloc().  Is there a way a file
> system can say, "give me physically contiguous pages if possible, but
> if it's too hard --- with some TBD to specify what 'too hard' means or
> can be specified --- fall back to a vmalloc-style approach, with the
> page table / TLB overhead that this might imply"?
> 
> I suppose we could do it with kmalloc() with some flags which to
> prevent forced reclaim / compaction, and if that fails, then fall back
> to vmalloc().  Is there a better way?

I think we'd like to avoid doing that.  A lot of code has various
workarounds for deficiencies in the memory allocator (some of which have
been fixed and thus the workarounds only complicate matters).  If the
memory allocator(s) aren't providing what you need (be it performance
under load, fragmentation avoidance or whatever), it's best to get that
fixed rather than having fallback paths.

There have been people who have suggested "What if folios could be
physically discontiguous", and sometimes I've hhumoured them, but the
simplifications enabled by requiring folios to be contiguous are quite
immense.

We've been trying to move in the direction of exposing more high-level
APIs so people can say "I want to allocate 10MB of memory but it doesn't
need to be contiguous" and have the allocator either fail the whole
thing up front or make efforts to ensure that you get the whole 10MB.
It's a lot more efficient than calling get_free_page() 2500 times
and possibly having reclaim run a dozen different times.

(anyone else try to create a brd that's actually larger than system ram?
;-)

