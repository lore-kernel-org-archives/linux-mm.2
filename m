Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E315CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 12:04:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FA1F8E0010; Fri,  7 Nov 2025 07:04:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D1A48E0002; Fri,  7 Nov 2025 07:04:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 735E38E0010; Fri,  7 Nov 2025 07:04:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63A4A8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 07:04:43 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2ED501A0483
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:04:43 +0000 (UTC)
X-FDA: 84083679246.18.D4BCADC
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf06.hostedemail.com (Postfix) with ESMTP id 67CBB180018
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:04:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf06.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762517081; a=rsa-sha256;
	cv=none;
	b=K3tZef7g0uvbhClwkC0tCfKfMugtPkRu4CBanSsp7tj/NboBML6WHr8bNqHG/9mY73LdYO
	D3RhK+jwwdtCWJVRMb/Cp+enmzOWQN956Lcjwt/P6KhNBdtaTGtOPczKpVNjfjNbQKNews
	r2/KQsuBVu6eQzN5PSR5wJ3iEKLHik8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf06.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762517081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YPFZs2khNCaG3EOL/HwHEeY3etybqJDccBu8Jx5wX0c=;
	b=Bo5v3PrYCcmqn/uts9RKb206+YWs+e8J+jeavTRtDN8+9TLw3aWOcjkIcoVGHaxtfUpoHh
	0+37Ou7pHGnN3jP+SYbLgrCaABqwdTr+pmtqumOLN0VmJKkgikzII7XJGPzEl/XDupFTfw
	Dso447e7D2cgTBsGoJTlK696KIVlhZc=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 71163227AAE; Fri,  7 Nov 2025 13:04:36 +0100 (CET)
Date: Fri, 7 Nov 2025 13:04:36 +0100
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/9] mempool: add error injection support
Message-ID: <20251107120436.GB30551@lst.de>
References: <20251031093517.1603379-1-hch@lst.de> <20251031093517.1603379-3-hch@lst.de> <20251107032900.GB16450@sol>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107032900.GB16450@sol>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 67CBB180018
X-Stat-Signature: fwmywt5pfeczahqefyfdz77k63orfadc
X-HE-Tag: 1762517081-111136
X-HE-Meta: U2FsdGVkX1+rD59+tOW5hyFSYPJlAWOVz1nG/oTHr3HCQK2zwntXLNkeR9pbVN0I0QGxLYpFyw0fLjwJcWaSKIPWOpP4+wpZ9ky+iZ72SGq7iUhbX4jz/ksZeGVL2Rongl+8LHTEr7dLQzGTv/MNhIY9WjdXTNzXwfj/kpFFhZDio3pffXsYifP9hE68KOPcZGCovgIyqVqH+MXsqkJENrt80/gx4rk0XUWcDaXxRSvNYYk4fF8smtLZ1BZiI+RcYGJosGb0+mG9t5PRkJ4tboFkDKSyQk74ZGnhgVtpJ/ccgCo/M/vk5OhfBFd5R/zv4FIEgYhMjcDpDU+lTL0TrnqA9fB3o9rIp/YFSrr5/bb+3ODPKpfyTeHsOC100CIE2i+Or+tXycJeVGAa0NwKkHqtLw7iSu1YZmA1uA0G+7k6N191Msy06+cmC7N2md0BjAkcrzRkpbZmYpKp6HWtyJtqCmR5MblElmoFD6RUlgJXlHupY8lCYEmQnyEpgaXLtQZFSU/yyQLEVQKQrGCEtVzCvMvgI82P+3JLIWcZcrwp5ATFzbxSKxyglPvz/SeUaGwVCvuVg3w035ZHsrULWsgpJr6aOwSJr5qm7XzJd00e0x0UzHnHlQCYIly4jNfR0k8j3Sh6gvnGdyww1QLcyIlA1kt4i+N3LQCMk3BozSDXzV8yR9GvxJEkgRWAl2889DR0O7+pAjxunwiahapHNKK9qVn4NMfUdf5jYR3YsTca8r/DIKrclPZ4L5PhS+gDF2r9cRVy+G7P4FSfWvDJeHlfguPhjnMayaCIM783cbxE21xMpGbLRUhfCBbQq3JkxL32xOvfV6gjNa5Ic4fXnZXrD2iR+5132SuOY733DmT0iB4aNcI5/IQ1yBTQNsBk8qKyEHt2jqCbe0/DZSu5bg1SLFld1ZSeBadISFOTNqQdwEe5x9OLVBhb004485rA+8K37c5Kxi12YFnXp37
 nwlqVU/5
 7MIrXOHq5w5aGZxse/fvxBFePj+1JDPhDhqOp3fZr/yk/n4KpQYwSdQ5RNCHIbL+1Jfa0nBXYhbWRbNY4fQYJoJgb7shpfvuLnUP8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 07:29:00PM -0800, Eric Biggers wrote:
> > +static DECLARE_FAULT_ATTR(fail_mempool_alloc);
> > +
> > +static int __init mempool_faul_inject_init(void)
> > +{
> > +	return PTR_ERR_OR_ZERO(fault_create_debugfs_attr("fail_mempool_alloc",
> > +			NULL, &fail_mempool_alloc));
> > +}
> > +late_initcall(mempool_faul_inject_init);
> 
> Initcalls usually go at the bottom of the file.

For a generic init function yes.  But given that this is only for error
injection, I'd rather keep the error injection handling in one spot.

> 
> > +	if (should_fail_ex(&fail_mempool_alloc, 1, FAULT_NOWARN)) {
> 
> This doesn't build when CONFIG_FAULT_INJECTION=n.

Yeah, the buildbot already told me.  For some reason there is a
!CONFIG_FAULT_INJECTION stube for should_fail_ex, but the flags are
not defined in that case.  I'll add another patch to the series to
fix it.


