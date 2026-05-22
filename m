Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B9ABCD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 17:08:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94E9C6B0093; Fri, 22 May 2026 13:08:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FF4B6B0095; Fri, 22 May 2026 13:08:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83B9A6B0096; Fri, 22 May 2026 13:08:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 737306B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:08:46 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 108B21C0916
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:08:46 +0000 (UTC)
X-FDA: 84795690252.14.5554BF4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4ED42140011
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:08:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OzJ6y0n+;
	spf=pass (imf26.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779469724; a=rsa-sha256;
	cv=none;
	b=ipIg3OkRs54o49+XJZ3ZpgN4y6TprYEptH39qvoVVf4HO+Ad5C/CWhukfhwHxusyVCc7r0
	GeHd/Ab+Eu1UYmEHTbJlR0xaVXva6KInSE3vwjunCTEq4/SNRQFGbPwlaGGHGIL/fj6xA+
	+otVQacJbLeNiXVxoTxPsFHP7zHq5iw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OzJ6y0n+;
	spf=pass (imf26.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779469724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c23yxkM0+/60YQOR3FKGtI6McR78Ee+YJUODTCKTIss=;
	b=5b1algJltjSWWrsRc+gRFO5aLzCjjFSksvtoFjkZjcjjW1aB4K4YfYKUAEyGMQRNQZclhW
	RBPE1/suJNlJkO7mx+GmvN3YMtedgG8cXuqGzpNzjDyoNNg+luYrYlZzg6x0PjEjksdFze
	KxRM4ARu9zvIGNdfkLzgpMjJlyRtXtg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 73392432C6;
	Fri, 22 May 2026 17:08:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79BE1F000E9;
	Fri, 22 May 2026 17:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779469723;
	bh=c23yxkM0+/60YQOR3FKGtI6McR78Ee+YJUODTCKTIss=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OzJ6y0n+zfW4+8WQGFFIbfwbnhp6Kv+qBK9H1sgDjZOELbUwkG34A+MtzYhcyghwQ
	 nrfe+NcdHemO7jYCA7aV3PfT7SaOud7n/OQycUYBIhSL7CO9++tBPbXgcl/QS+69gf
	 n1cGbOPUqj2ZCfDoZbf4ImCy2xQSS3pyLRuKeOepf+0jBS3SPuTYdt2JZ1UV6wtj5o
	 Em/8yk5bmWeLIV1wWHSEaNiqviQ3BwSC+MLhXk2Fs44SXHCFCatdF9dA6hgWDbxiyE
	 fDpSnQbBwhWWCGTzo/yjjKcytOvjcNcAP1TEV5yc7GuI0KKFJ2ZEd+gvk++fOksqEZ
	 Uzp89DIhXWvGQ==
Date: Fri, 22 May 2026 17:08:41 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ahCNmWbcd_2lAJyk@google.com>
References: <20260409134538.3692605-1-jaegeuk@kernel.org>
 <adhPZxtbZxgU-37v@google.com>
 <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag_OVwPF49LSZ7rz@google.com>
 <20260522141115.GA8258@macsyma-wired.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260522141115.GA8258@macsyma-wired.lan>
X-Rspam-User: 
X-Rspamd-Queue-Id: 4ED42140011
X-Rspamd-Server: rspam03
X-Stat-Signature: n6r6rc8ctgqtbkxrfj4uhw3xi77qkdo4
X-HE-Tag: 1779469724-59994
X-HE-Meta: U2FsdGVkX1+vsTlHIq+PBJEibPT2Ci0XfzUdlGP9KEgN4GZkhpj93aT7vetnD2agb9jmuOicuyQwMAwQOnfUer1tlpyGGK0S4CShbqVv5/Rz7kPbSDzA+kzPQGeYP4RG0/CNKMsvEMCHWoqPwckE+Ec3lhlOLQwgc1jRdAbtPFWJJmpTbfv2WTNhMens/oC710eXBaELclk0vfp+gk5/g9M34CIPYMFqR+tQvjAWugB/pwzaekFIKrAFQM/iqG0OsmjYmhH91GvZUPImnp17eOtXdO/7muRXW7UbjTAsM5roS7ucbkuGvTH2xv7OlhdJNnzgEq4qgObIfmjWb4NYf+wbNXxH4hHdMozBj+pxWANVDhZG7DYAOM6DDKWEwJ7HDJ12nJGFqFL7epP/bIHtsTDn6bb/USMfpbkcP+4FEasIrvstdob5KEgA+Cz2qup3WnrFctatkswLEXXq+GCr1JzT0rgVpT0Z1vXLccTE0tZn4eNtPJzq8suAyQIbNjbJYvunCUQFrmO+oTsQfHVql0apbpzb9JkvzpjwTouvDGtfgG/XhYo6cg7a//K7Jdz28c5iE6v12bQckHJBEe7itD4mbjAoMzd/Yqq60RGI9tTHcIn+Tgfzz0ahuwWiotGalDHksyhDFV9MnBl6SagloiqrLO7TT5Cbt1Ud4iuuLlk9ONRl99qs2/mVKDMcYshVIk0qHhPEaKo3Jvlxkxj1jgALoNVo4s6plGobK5rkK2oUufTpq/xhluGR6sjGAlbQDQZSQc9fw4WezjxHj99Mo5+Vyrf0+0FgFksIwcf9D1Sk1dejgptRWuJ8gg9SgMBv1KKRJ9dqvhzVA4FJ9hOWkDBo1PsmJ1WRNmljD03cQ8opXgp3fMjgqq9yqJR4I9mju4qfnWhqBasX44mp59+oyo2FqY5GCbOJdnRh+hnZXEEtiNcH5tjEnRnxn8mlAdOFvz4NqMGB0kVv0Nt0o+c
 urDS9Eyg
 2C3E9qGUP4pikY2p3BGWouE7KYeB1nGXQYVVO9S5gqxnIlR1QfT0JcXl2tbcdNDEsNwtvsHpxnXzoJLWk+3qhr6kCisFE3qheDkxJzO9P9Msk3ETno+ccPGL3qn8P2wmJjp3Pexa26FdhkN0GZI2w/0qJtoujzkrGLLOhU8EjWDqPfc5YvvNmIr6XM2ovxi0O5aqNMO1LuVfqQ+9595+pMtOV/XeKnQiG44HTPuMR0CrWr/O7Scxjt9eRnjSNUGGQKNPxXfA1efJTt+fWe7hPEhlnEKayREYTznx5Jcih1khmQIzcLOLhiSbc+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/22, Theodore Tso wrote:
> On Fri, May 22, 2026 at 03:32:39AM +0000, Jaegeuk Kim wrote:
> > I went this route because Android heavily restricts ioctl() permissions
> > and we needed broader access for this to work within the framework. It’s
> > definitely a pragmatic choice just to get it running in production.
> > 
> > If ioctl() is a right way for upstream, I'm happy to change this patch. By
> > the way, I really don't understand why all the messages are so offensive,
> > even without trying to understand the problem or guiding right directions.
> 
> The reason why some people were getting annoyed was because as a Linux
> file system maintainer, there was an assumption that you would
> understand that extended attributes --- especially in the user.*
> namespace --- have an intended use case of storing a user-chosen small
> piece of metadata that would be stored in the file system.
> 
> Hijacking user.fadvise such that it no longer persistent stores an
> extended attribute for one specific file system --- such that if a
> hypothetical user application might decide to store a piece of
> application data in the extended attribute named "fadvise" would do
> something completely different on a single mainline file system is in
> such poor taste that I would have *hoped* that any Linux file system
> maintainer would know that this a Really Bad Thing, such that if
> someone in your development community suggested such an idea, you
> would reject it.

Thank you for the explanation. It seems I made a wrong assumption on the
usage of "user." prefix where each filesystem can support in different
ways.

> 
> And then, when people complained that it was a bad idea, and you
> decided to put in the f2fs branch, such that it would show up in
> linux-next, and there was no way for other file system developers to
> object (short of appealing to Linus) --- well, that's basically you
> taking advantage of your file system maintainer privileges.  And this
> is why I started proposing whether we needed to appeal this to Linus
> so he could make the call to reject something that the community had
> already told you was in terrible, terrible taste.

To be fair, I hadn't queued it in linux-next for weeks since the first
post, and was waiting for more feedbacks. If I was able to hear "user."
is a generic prefix used for all filesystems and use ioctl from the beginning,
I'd just drop and be able to start arguing with security folks back. Since
my employer is funding for production mainly, not much upstream work, I
couldn't sit and wait for the response for months. :(

> 
> As far as trying to understand why you were doing this --- I have to
> turn that question around.  Why didn't *you* explain why you needed to
> do this thing?  I went through the e-mail history, and I couldn't find
> an explanation of why you decided to do this thing.  

I shared some motivation when replying to Darrick's feedback [1], but yes,
it was not enough for all heads-up. The problem started that some speicific
application needs as many high-order pages as possible mostly for reads. So,
I thought we can turn on large folio on the specific files per hints. One way
for the hints was using immutable bit, but it turned out it's very hard to
manage disabling the bit whenever deleting the files. Along with limited
ioctl() and requiring inode eviction to manage large folio activation, I had
to implement this path.

[1] https://lore.kernel.org/lkml/aeA5C8byIpXWla7f@google.com/

> 
> Perhaps we need to add an explanation the Documentation directory
> explaining what the intended use of the extended attribute case, and
> perhaps referencing past cases were people tried to use this to bypass
> the linux-api review process (f2fs's user.fadvise is not the first
> time someone has tried to do this) thing), so that automated review
> bots like Sashiko can explain why it's in such terrible taste to patch
> authors, perhaps we need to do this.  Up until now, I think the
> assumption is that file system maintainers would know something this
> self-evident, and if not, if it was pointed out, they wouldn't try to
> force such an ill-advised interface to Linus.

I believe this helps a lot to all newbies like me.

I really appreciate your feedback.

> 
> 						- Ted
> 
> P.S.  As an exmaple of how I hanlded a somewhat similar scenario in
> the past, my employer's cluster file system needed
> FALLOC_FL_NO_HIDE_STALE to save $$$$ in TCO storage costs.  But the
> concern was this would be an attractive nuisance for enterprise distro
> users, who would see the massive performance increase, not realize
> that this would leak stale data, which could result in user PII being
> exposed, thus making life hard for Enterprise Linux's reputation.
> (This wasn't an issue at $WORK because we enrypt all data at rest, and
> the cluster file system daemon was a privileged server who (a) knew
> what it was doing, and (b) only it would have access to set
> FALLOC_FL_NO_HIDE_STALE.)
> 
> I disclosed *why* $WORK needed such a thing (it made a huge difference
> to storage TCO costss for Google's Cluster Filesystem), and after
> discussion and negotiation, we came to a compromise which involved my
> keeping the (very small) patch out of tree, but reserving the code
> point upstream to avoid future bitfield collisions.  They key here was
> that I *knew* it was controversial, and I understood what problems it
> might cause in the rest of the ecosystem.  That's part of the job of a
> maintainer, and it's also why a company might want to hire a
> maintainer.  They can represent the needs of multiple stakeholders ---
> the upstream community, upstream users and the greater Linux
> ecosystem, as well as their employer.
> 
> 
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

