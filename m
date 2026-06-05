Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D1C3CD6E75
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 01:57:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B7236B0005; Thu,  4 Jun 2026 21:57:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 641606B0088; Thu,  4 Jun 2026 21:57:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 508F46B008A; Thu,  4 Jun 2026 21:57:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3CE546B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 21:57:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B70071C1BBE
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 01:57:33 +0000 (UTC)
X-FDA: 84844197186.23.638BD0E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2377914000A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 01:57:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h5kFVbKG;
	spf=pass (imf09.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780624652;
	b=Eh11QxiqpAd6lqLdc2hRGpaCni7jyDjIdQLRQA+J2KcqlE0NMcyNeP1tOGaLiLZAfx94Y/
	cMN2ZNzJI6D2WuCa6c+dbHh5nJkGYbZGcU/jhzzAGEEQXr0gU1eBNf8JVPNki9Cz7dJqrV
	5z5jmMjoUqjX163TrNKj+MjynuEpSlg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h5kFVbKG;
	spf=pass (imf09.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780624652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hSMeDgYWfG9legqy7nLxVx38jDi5V+SRhptqZ18fLp0=;
	b=qLY36HIyHAtKO2yJ5hoI0b+iAg6opUUAVQ6QBAsWzf53p+0XnHalN5PQKCcE0dY+negc+6
	c3Q7dzEO30U+JDKgRz1hgT6QqG29o9CM3DzcQJTVbWyUMZPQJciXOi93efOOMEYVnIM0Kc
	D6xj3dNnBPQM5KUgFsN+wQNcBLS4A5A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D8C86001A;
	Fri,  5 Jun 2026 01:57:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4348B1F00898;
	Fri,  5 Jun 2026 01:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780624651;
	bh=hSMeDgYWfG9legqy7nLxVx38jDi5V+SRhptqZ18fLp0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h5kFVbKGgWVM4/By8YauS1zHj3ZfSM7nv7xk5g47JSYjO4uExbSJ8vU62gwc4dAjb
	 9QQCREwAtgUZqllgZ0AZ8AUIqgkKZFTwlNCOGAb9zpcS8ZM+lT1XkImHiYqor5wnS1
	 /XlH4Q1yDcsbIC2OsFk+IKqTlK9WBNa20C5VrMvxCEruIE9fHYYaJ7JmPuzX3Wtp2i
	 3EghSwMOFry9oSJBFg7uVX9Lsap2HZmy+EoldQIf4mz2RbBTkpKKaPMVrv4PmoLKgA
	 g6YTizz/03AnztZfkq647HYGn7jqBBAF5k1WupLx5j698k7fx5hbgFDH/ed/3FrRFy
	 43v2riFR3o/4g==
Date: Thu, 4 Jun 2026 18:57:24 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Askar Safin <safinaskar@gmail.com>, metze@samba.org,
	akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org,
	david@kernel.org, dhowells@redhat.com, hch@infradead.org,
	jack@suse.cz, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, miklos@szeredi.hu, netdev@vger.kernel.org,
	patches@lists.linux.dev, pfalcato@suse.de, viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260605015724.GA520134@ax162>
References: <f919874c-065e-48be-ac5b-300c4ab86d4e@samba.org>
 <20260603211736.755139-1-safinaskar@gmail.com>
 <20260604100609.6b37f500@pumpkin>
 <CAHk-=wjvb56qo27-axALOKCY-CjLsj9_294zeBovPVJaYm14dA@mail.gmail.com>
 <20260604183829.63c35fd9@pumpkin>
 <CAHk-=wip3mwLOHOYJ9TtjDxOaq9YUXmuCg2AycyASGgeY6qqUw@mail.gmail.com>
 <20260604223216.73468830@pumpkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260604223216.73468830@pumpkin>
X-Rspamd-Queue-Id: 2377914000A
X-Stat-Signature: o73ah3gqme69nd6rdcs76rgu3furqboh
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780624651-525016
X-HE-Meta: U2FsdGVkX19Gh6EzcSXc6iikolCtSitZOE04BTqE1NOzOx6PMOJTr1XVgBVeVFsfVegHstWrpJcRPjkCZbUcLiFaFhqxcc3j0iJsJryFWXl3hxK7tYFfBHtiWuv2qISeo46tQv0LY8lfnvPgsO/UmDoFu8Sem96PrqXtCA2SbDaqVHQjOSt3U65ProJ45qC8jMKbl8Dx9dih1CrRzjQPStrOIF4wfFHQUcFyu1gv3w19XUAkR/xz3owowOLUifLyJgiFDiCGGW0jn9tKHiYdUWODPIxPCQ+7I2Ni7NeS6tHEtGv5YXMsBxlwSDa2jiOQk8BymHNpR6N4m2AM6+7YS5rrZtXAQB+//AuBsyn3FIVDKaesG/KFHsUnYKSgIEEGQ/S7E45rtL4+YUEZpnHIOG9a6YHjhL2OJkChzZGSSeLLCkPYjI3/1reBmqsDkqew8z04fl7jJr+GCNSuZQRHTt6F7M27VAyPRt9xC2wxdpbpY5FAD1caDE0aTJvgPbFyXyQxCx3NoEqaDLsVhYRUChPuwKtVoUtbguLT0u9jRcat5aIZsgEmKf0zZqgGlTaQbmxS6yw/UATJ/KlPJBzeeKuz4Cf8GsJFfPvoqtD3XXhyWNH4QoJqtb80pTwGfwJZk/LTzHuYZ1xqwhLoncpXr9r6WHo4EquYuIIkH3GnEKs4et7G88dgRa5yMGeyf943irnFh59mh2DLumg5IbZiOYtZOQElWJvsez+/prqE6Lzqrrp44S9sF4GnzHYQG8ON8q7gzAuqD68jkHCFOtbFSzMRYlPmQWLGRDwa1q18jNfBEAuUFs0qvkv2ub5Pt7BP7SObVlm4//4MT/O0JHg1Jr/7KOPFWRxlpiI9ne6N8ljAsVbtVUvgtG+6zaecomWvT8wY1YavUAclSwAOXTsGJVTKW1YmDvHRthtJc+0mgUcdx/08xLewU8YwEHyLYXPgQ7BWJDhTbUOYJRT+kcf
 HZVlUNBT
 enHQdAil06huVpKwuSL9uZL336PR78xxVTkVP04WuLTaIbJPaq5OmRlfF0qqnYcpJrXgvbQn9L26VJ9W5wyCnPIFu93Oh4rCPbRQqdrgXrdePQJunnxZ5RssqvhHsi+FipIoX0N5hauSPRw/Vi6mnouHMHvDiWGMzwRIoUfWOmjCJfwVlfQc8s0SXcns+XgXQNttHNv3FU8dP39DdKnZXkXWItjnYqjzvHml0WjbU/Bj37TTDrtxh12QbedJhEtIAnm7sBDyb8scfiwu8YkRglIyGbqN6Dd8e8QAPPt19lxMJyVk/xZqtkw4sfbWKll1K/13p/SpNR/iH1TEbxtlmwt9KEStcd3i32o6VcmTewsGk7SlN6X3SXqGl2JlBIv0NvC/3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 04, 2026 at 10:32:16PM +0100, David Laight wrote:
> Talking of broken compilers, had you noticed that:
> struct foo {
>     int a;
>     char c[32];
> };
> 
> int b(struct foo *f)
> {
>     return __builtin_object_size(f->c, 1);
> }
> returns -1 (size unknown/indefinite).
> You can't use __builtin_object_size() to stop code running off the end
> of anything referenced by address - even when the size is constant.

That is the entire point of using '-fstrict-flex-arrays=3' in the
kernel:

  df8fc4e934c1 ("kbuild: Enable -fstrict-flex-arrays=3")
  https://godbolt.org/z/bvfrh7W58

Without it, all trailing arrays in structures are treated as flexible
arrays, even those with fixed sizes.

-- 
Cheers,
Nathan

