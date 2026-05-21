Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BD18CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 15:59:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BAE36B0088; Thu, 21 May 2026 11:59:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26CC56B008A; Thu, 21 May 2026 11:59:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 181686B008C; Thu, 21 May 2026 11:59:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 070106B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:59:19 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B07E41C1AD0
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:59:18 +0000 (UTC)
X-FDA: 84791886396.14.896B049
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0C03320012
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:59:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=LeZnGv0J;
	spf=pass (imf03.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779379157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wTn+GnhNxMudbQm4gD4f9vF/cA4/h1qk9LUl7mxlP9c=;
	b=qrmbt3wAxzbUA3PPLDIj2E+PxAh6ytgRlzg9JeUNT6Ekv6IV3JbQxxmVkNMX/LQPkIaO1A
	KVNGoL2yMBfMNev4VKp5Zrhk66++/RWbMpJeyl7I38ZGaQOPfalteo32XtOZQupiFMsf6l
	2E/jdZAkXoKSJ0HWhWg2x5FgBM6L7WU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=LeZnGv0J;
	spf=pass (imf03.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779379157; a=rsa-sha256;
	cv=none;
	b=0t6Zo5S+amkOmGlx2y/A3NJeGWa8kofv62lwQNL97xEWRq9xsGWWCzzVTz7Qqsa2/b7Y2O
	jvYkOxnZruHcoyj9d43VdayIJ5jkwr0zX+/i/B0mQrEuywEtzy6rYhO9WtIqXgk9Pv1liC
	Y/jcIlOwhO1HGvXf5YYP6NvH3JNFDtQ=
Received: from macsyma.thunk.org (pool-173-48-82-210.bstnma.fios.verizon.net [173.48.82.210])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 64LFwmMB027517
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 11:58:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1779379133; bh=wTn+GnhNxMudbQm4gD4f9vF/cA4/h1qk9LUl7mxlP9c=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=LeZnGv0Jw0KN2cpmFMusUp0BDqatOhD1eCiQmfJGgSNLUg5e9ogcoxiH08zwQBTnF
	 Isbjbd75Ih/THtpbE0NzEbyaBqEOHUW4oMUAPZPfhEWCT/lNsgyTmJtMnmgy8PrfuW
	 BfCE6Xd2aINXdkFM8v9YmztLozt2nQYwXF14OzBCSVWMM5JRHZmHy/ORKwcER/zpdO
	 wp+kflSZAS/eIj4l6at6x2ZNDzQvltChJnap/adzvNaQwU8bEhffLchG+vErQwXj6h
	 m03OA6B5NP9+kyki85Fnak+wng+fBb1/bKnpG7j7sNwn/cnhlJS0EskvLMdv4PcJeS
	 kgtMjFEiFg6Rg==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 6B3A2697D19B; Thu, 21 May 2026 11:57:48 -0400 (EDT)
Date: Thu, 21 May 2026 11:57:48 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Akilesh Kailash <akailash@google.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-api@vger.kernel.org,
        Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2] f2fs: another way to set large folio by remembering
 inode number
Message-ID: <20260521155748.GA79343@macsyma-wired.lan>
References: <20260409134538.3692605-1-jaegeuk@kernel.org>
 <adhPZxtbZxgU-37v@google.com>
 <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ag7HfNryTmQ-bVIS@infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0C03320012
X-Stat-Signature: 7mt7ogfmutwhg7uwtspnere5ixf1tcny
X-HE-Tag: 1779379156-739288
X-HE-Meta: U2FsdGVkX1/prxEUlWtAiFVn01xVZXdrt+vsM9blV4wW5nBNRB8eV6C8xr07aYDjqUc9546e3GwwHoyzkpShdEVAc66Zbl1UgAH2HdTAx/wYHoqC1vZoL3ABBMwSC+9+WDYx/SUoSyNX9n6zzFJqEldJla7BaA7H/O8BwYMpe6/KcNqLUOhyg5kGlo4q1eZSXULfELHcZThwNe5/mBlvz1btd/Z1pRhhg5l4iNADpymtseAxHJcafDrxkkTi2Kzeth4lr4+7sYO86n48kuv8uzTtI2u4UlqGd2Kbfs77Z30rtFvINZDN2SmXzQbZGz6umepCN+An2Ins/5kj5HP/V2mgSa76LFwIqk+eC4wD39SrTRH7Xtxpd6eduIAoBfOVrrxt5uRkGJahoH5pZScUTKVlDtBG34ccQ+SKR6GF7JUnoP9pNKIGQpi/+H/OHxE1kh3+1tCRi4gzjvgnnmRALxUS2RQoGgiKGMJj4qW9apz/sNZjNzSN0L8N7MTcLD8HdmhILx38PTEaFfRUXz17reLnS2KSqmT8pZJ024+aoIrzchbZGRKnt8jI6anKKENgyDeR3alwFAZ7zCaBksSf5uNVRPSnDE7m8uW0/q/6dhkePk8Wyt3oWoGEn/m+FFG3G+TO8ByiOCC1XyMvgoptaqKfCxKOxXC5pBQp0qvBjQTwWsEgbkjmKTRqdUkDTiUpgxM4Rg8QX48C9cBS/pqJ1erHqWpdwKhouH5ZtNRWP0MkfyCUjWLE0ef3hOS2mJ6vIozGoVhbXBCmDCcfWCEjgcFkp3odYgkp7EYHWpp4gdEcxQYgaWdSsM3FxGrOf5MrfXKoJHPVQFBxfZbDssND/zYP2vUbNY5BgELyLf8MkOiT+4DnD62cD8uZeblXCm2eNwjjk4AnbX6S0AXGGw9qJlpLkgCzubBePhw6NRCc2bif7MNKMcEACOscwyLI2bD5ziuprPRJrnJXqDZzjdn
 +6WS+tJM
 Akihr47ytt7ESF2r8YQ6xBRwWHmgeMreyjyrvtLya4Lto/JZb/QM54wI7MoUCMYTjI5E744v+1yw+kY00Cq2lKXFRgxRrLLsuFa05ExfUEURmCwahu4KbGpiJqRDXZLnbAvGBT/xQx6DqiL1LCJSw2aIeCF8sHPpvCG2PCubvyz8J2g0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 01:51:08AM -0700, Christoph Hellwig wrote:
> > You haven't sent a proposal.  This is a reply to a reply to a reply of a
> > patch.  There's no justification for why f2fs is so special that it
> > needs this.  What the hell is going on?  You know this is not the way to
> > get code merged into Linux.
> 
> None of this got properly answers, and this broken interface now landed
> in linux-next. IT is offloading a user.* xattr which is free-form
> user data with semantics that are weird to say it very nicely.
> 
> All this was done against the advice in the mailing list discussion.

So let me get this straight.  This is a magic xattr interface which is
not even persisted in the file system, but instead sets a 32-bit
bitmask in the struct inode which disappears once the inode gets
flushed from the inode stack.  And it uses a generic xattr name,
"user.fadvise".

There's no way in *hell* any other file system is likely to adopt such
a broken interface, so why didn't you just use an ioctl to set this
magic f2fs-specific flag?

> I think at some point we just need to stop taking f2fs updates likes
> this.

Well, that's ultiamtely up to Linus.  I'll say that if I were Linus
(and I'm glad I'm not :-), and I saw this in a pull request, I'd
reject it out of hand.  But whether it's worth making a huge fuss and
asking escalating this mess to Linus, we probably should get a bit
more community consensus before taking such a drastic step.

Christian, since you're one of the VFS maintaienrs, what's your
opinion about escalating this to Linus?

					- Ted

