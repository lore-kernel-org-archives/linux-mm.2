Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BED16CD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 01:22:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1E476B0005; Tue, 26 May 2026 21:22:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD0146B008A; Tue, 26 May 2026 21:22:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE5F86B008C; Tue, 26 May 2026 21:22:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ADAF66B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 21:22:04 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4849C1404A4
	for <linux-mm@kvack.org>; Wed, 27 May 2026 01:22:04 +0000 (UTC)
X-FDA: 84811448568.20.F6047D0
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	by imf29.hostedemail.com (Postfix) with ESMTP id 22333120006
	for <linux-mm@kvack.org>; Wed, 27 May 2026 01:22:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=PSWDr8l0;
	spf=pass (imf29.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779844922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DJFkDvXxR0DjYA3xWYda2p1KUsjgyfsXRLcTLMKtZ+c=;
	b=eE1UxO4S9PkY74ULB3+uBxoIVRpLMmOrKEoD3+XgKV0JwNAfRo0QprLPzdgs9CkxiibonK
	QkLMvLM4NYwMTOiJWK/35GS2uMA2+k2XrOPgFHrINmz1lG6YkknxizLQVyqFfTFkwRiB/u
	+G38a0aUOMXLI6AFsqC/oSgKVcCLNgU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=PSWDr8l0;
	spf=pass (imf29.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779844922; a=rsa-sha256;
	cv=none;
	b=E8OsIGjgHLHpsXaz9TDgt6qycv+VfdS9y4rNt8o01953a3df5x0AJ4M2UmPiX1Hzj5wpYO
	BxLBPyWtIQ0ABH1DTKvG2u9WnwcaqoW+Uj95xDYw50qe2h4NQZQKu0EownrmRaV/u2nJlj
	TFJDZpnIiyGrJG17voX7NE93h2qv/HU=
Received: from macsyma.thunk.org (c-73-9-28-129.hsd1.il.comcast.net [73.9.28.129])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 64R1LhpE022642
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 May 2026 21:21:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1779844907; bh=DJFkDvXxR0DjYA3xWYda2p1KUsjgyfsXRLcTLMKtZ+c=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=PSWDr8l0xAxG+aO7NY0TUEScHYUAT3V1K6PjCEMN0Gxn7ksMEmUXWMzBHgXAR6Fz3
	 l9s+D8e3P0cM9uziJ/JcbbMnKrNZoaNK4EBsYi4ljiRX2KtqtM3uf4WRB2i0lzbZYr
	 qR3FneqDQww/s0jVBh1GakrN+rkZR+JGoW+N7YIaCJogB1WUuqkEIg++rTq1UfabQt
	 wln2UkUGPyOtKsWY7VWaMsjiZdy7GzUZlr1Jg1XiGUDgoblMJSzf06/8g0PvJ29Pf1
	 J6US3QBSYQDRI8t8isI8KP6cS+bC7W7MidFp7vFb96gFpK4GLP1P6dC3UlEMI3OgP+
	 Yij0XC/BpJXfQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 84D236B384FE; Tue, 26 May 2026 20:21:43 -0500 (CDT)
Date: Tue, 26 May 2026 20:21:43 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Akilesh Kailash <akailash@google.com>,
        Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <psj3kr2gcze2yll5xdbvyyzxwcwhds5gh55poobpkfxrkpbgr7@ljdindismzd4>
References: <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag_OVwPF49LSZ7rz@google.com>
 <20260522141115.GA8258@macsyma-wired.lan>
 <ahCNmWbcd_2lAJyk@google.com>
 <20260522224108.GA18663@macsyma-wired.lan>
 <ahTzHyHBL8t0iNBR@google.com>
 <ybmbjekuvzmaw4hmlxd7nxs546dqtwmxqxwyali74d6m3u7tat@b4q3japqnhrl>
 <ahYWKH9-ybDlZuJd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahYWKH9-ybDlZuJd@google.com>
X-Stat-Signature: gx61s9xmqzhocbq94o3pg7ebdudehr44
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 22333120006
X-HE-Tag: 1779844921-810699
X-HE-Meta: U2FsdGVkX19s3BHv8jzbQJK4AvlbpQX1Q81AzvNch5jiMqbNADAxQ3eXYkTlEqCvoMtq1lQ3Mg8QFz7luhAac/mJWSOdNMFTIlBrF0f3T3t0Mpcty8n2PnC03Maw6zLvWnkD5thS9iqtDGUDf+z2opXWIQLqHD6OOnDZEPurEAYY3CE7BBHAHBXmKXf3umvVAR2bVVOz8QwpLl5nVQB0ZtfRchTqMkAAy/8IkCdedCcQYkCGaHrG/15m1KVDTemr/n9eLPVy1MVvsvAsnW8GdZsviVCqVFLSeB5DQlU7chmcqEF5vUu13wd0/xnXx2xrdY2/EMrIQwxM0a8ffJita+Ehjx8PjSxCin3rytye5afjETLxuL8RNJ+bLl3+Oj8U3NThHBH7FIQfaiHTSIPPHyguMYG8SXBDQi2ZaUowAzqpkB/cRNcdGKbjru1IkOa6y1/pB/KCqpuSNYbr6tTJHHPzLp3mOWHAky+YPcfbJfvH8ZSnFzkbL0//ZSIftiDzGW5yTM5LFgAps39BeSAUz9TvWpK3Qp8eDCkdeor4LTG3umIKgbsnmeqqTvV1ElFTqghtdQcW8wUPs2BZiyu9Ucj2RI7G9uyZ31YoaddhwzulYXnoqtWKq5++oq9CvP/ghtX4/P5ZvyXDXzNXo2/x4Ve+zsDf6pmIjaVHOk5HxrMjFdN6JXsGM2tBToyTr4Vtoz2Nej6N7q0g72V2tOCsRwM0ir4tnjjjjiM5ToTlzy3KXpVOdSLlWdZyDmCeIGRNF9OyXL+6rAo3UYXBpeamFN9YdB5P6UJ9qxSFr4Ul41f0EmzPWjpIEgn61kNk/fxBqav7YAkr+Ezfsww/8foJG+NO6SwowZ3Y4YNBXQZBwQMCjcdXYuF6mnmfk8vQqkO+/1Nuv/kMGtAOwX+4VqaJRgNV4SI2+aUQS3dj2iVVPE+jZCJKFiojZx8Y2mCUE3evsKclf6lV5rpXr7H2ZPW
 KvkCOJqe
 fmlCLb71/DXiBby/9x0SYqHFMCscy3wpJg1GPYTXpqo9TdJrZX89UiQvzneXKEtakcAahX7IbmxBdMmQO34NcySsvLi9PWWRdfBQyzBBvA8mx9x+rgHV6EbhpeWUXYn8HXgXy6/caFTtUHiDdexpn2X+sOy6El8M5r6rUsZuam5A5lZfSOBZNU0T3dUbRu1kyFvx9oZNMJbaIF/nUdYGbtpj4vA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 09:52:40PM +0000, Jaegeuk Kim wrote:
> > It seems... surprising that the additional I/O operations are actually
> > throttloing UFS device bandwidth by 2x (4GB/s vs 2GB/s).  Have you dug
> > into why this is happening, and whether there is anything that can be
> > optimized below the file system?
> 
> I can't tell the exact size tho, roughly it's between 1GB and
> 4GB. And, per lots of test results with various tunings, it turned
> out memory allocation speed was the culprit. If we use 4KB page, we
> couldn't get the full bandwidth unless we set the biggest core
> running the highest frequency.

OK, if we assume that the model file that you want to load is is 2GB
then the number of 4k pages that you need is a bit over half a million
(524288).  So if it take 1 second with large folios (2 GB/s as you
stated above), and half-second without (4 GB/s), then you're basically
saying that it was costing you half-second to allocate 524288
singleton pages.  And the whole point of this exercise is to save that
half second?

And I assume that these timing was using a performance cores, and part
of the goal here is to be able to use an efficiency core instead.

Did I get that right?

> > But the problem with using small folios is that if you want to
> > actually *use* the memory, unless you want to segment out the memory
> > so it can't be used for anything other than the AI models (e.g., by
> > using somthing like hugetlbfs) it's just going to break up the memory
> > into smaller folios.  So that's not actually going to *help* in actual
> > real life use cases.  It might help for your artificial benchmarks /
> > experiments, but in the real life case where Android applications are
> > running and fragmenting all of the device memory, the large folios
> > won't be available *anyway*.
> 
> Agreed it's hard to get this done perfectly tho, as the best effort on this
> particular AI model case, I focused on two timings when loading the models:
> 1) right after device boot, 2) dynamic loading when required. To secure high
> order pages, for 1), I disabled the large folio consumed by EROFS, while for
> 2), I tried to call compact_memory before loading the model. Both of cases,
> I could observe we could get fair amount of large folios. Yes, not 100% tho.

If (1) is a common case in real life, the thing to do would be grab
2GB of large folios early in the startup sequence, and then letting
erofs do its thing --- and then at the end of the startup, right before you
load the model, you can release the 2GB worth of large folios.

(That being said, I'm guessing #1 is actually not that interesting,
since as a percentage of the time that it takes for an Android device
to startup, is adding an extra half-second *really* going to be
noticeable by the user?)

But for case #2, that's the much more challenging case.  If you don't
call compact_memory() you're going to burn half a second to allocate
the 4k pages, since the large folios won't be available.  But if you
*do* call compact_memory() in a production ROM, depending fragmented the
memory is and how much memory have, calling compat_memory() could take
**minutes**.  So what's the point?

The bottom line is if it's right after device boot, there are simple
techniques that don't require hacking up the f2fs.  But in the
demand-loaded case, calling compact_memory() is the last thing you'll
want to do.  You're better either asking the mm to allocate the 4k
pages, or do whatever compaction it can do to just free up 2GB worth
of folios.  (Calling compact_memory() is overkill, and only makes
sense in the context of benchmark / proof of concept demo.)

Either way, trying to get file systems to avoid using large folios in
the hopes that this will speed up large AI model loading.... doesn't
seem to make sense.

If the problem is fundamentally about making 2GB worth of large folios
available in a way that takes significantly less time that just
allocating the model using half-million 4k pages, that's the question
that we should be asking Matthew and the mm folks.  Which is why it
was too bad we didn't raise this issue at LSF/MM earlier this month.

> Indeed, I was off from LSF/MM for years due to various product issues, not
> related F2FS tho. Let me make some effort to attend upcoming ones like LPC,
> if I can get the budget from company.

Next time, as a suggestion, feel free to raise the issue when the
LSF/MM CFP goes out, even if you don't think it's likely you will get
an invite.  Indeed, with a sufficiently interesting topic, that's the
way to *get* an invitation.  It will require breaking down the
technical requires as you and I have done for the last few messages on
this thread.

Even if you can't attend LSF/MM due to time or budget reasons, there
are a number of your colleagues who are attending, who could raise the
question on your behalf.  I've been known to do that once or twice on
behalf of other Google teams.  But it does require that you approach
the usual LSF/MM suspects a good 2-3 months before the conference so
we can help you craft the an appropriate response to the CFP.

Cheers,

					- Ted

