Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D33ADC43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 09:30:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DB6C6B0005; Sat, 11 Jul 2026 05:30:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8653A6B008A; Sat, 11 Jul 2026 05:30:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 780826B0005; Sat, 11 Jul 2026 05:30:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F0886B0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 05:30:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A1C141699C9
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 09:30:20 +0000 (UTC)
X-FDA: 84975975000.26.86441B2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1747040009
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 09:30:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oKHJRnBP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783762219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wMYPfyTsBLTuv/VNc1Ad6qGQ7OM9n6X/3M55TFPtdc8=;
	b=AuXaoy94/TC45Yw9Q173yE+F5XifzNSPyheWyIZMCssXBDjBeUaZKnx45m8eGwOJmCfiIr
	4GLOT20Mc6j4AkV61c0ADsqZZTUnTEowRZNC2o1/FgcFULkBeUsGTQg0mZjzkfCYNEAlU1
	iVKBBnzOKvjYVYhCZuIQIexgKlM5TKI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oKHJRnBP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783762219;
	b=Q6Z2CiSmn5PdrOqnj3KeoIkaIXBYV91jMr2tfw/+LmHwU7m+oJtSQ9NpzRWDEge7nyNb92
	r3ZYlYiK4akCovFPdXsrd9Dl7sd7Q8StVydnXC9UQ+tTiQecTyBOvPaEEizIBFmo9XOmWe
	I6ohu2BHiIeqXDiGG+r27cS/BBt4Wjk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A647600C3;
	Sat, 11 Jul 2026 09:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28DCA1F000E9;
	Sat, 11 Jul 2026 09:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783762218;
	bh=wMYPfyTsBLTuv/VNc1Ad6qGQ7OM9n6X/3M55TFPtdc8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oKHJRnBPFx5ib22zJ5SuEM6vSjo63Hsw+PMuKp0Vczhmn3i7ESnfc/eYbgMF2I/CG
	 Unvtjto65X/PtKcCKSHMn/hfQ7IBn6NNy0//Xw3Nb7lJH04SvAYHXtJ+7hLoAeu4WP
	 CXlo7sqO3wa+2fxlcy9vp5yMJDpl08i5VUvXAAAGZCSrSAPVICVtKWmuviqCzZEHfZ
	 YIf6DcjUaI0kIZZg0wupyGaHg8Pq8b5HJnup/4pjY8hxetJLZI2wpHcZk+x+HkxsMm
	 jJRH64uxBhsQssoRV6sOT0gYsnSxa0Ee+el6WJJCsjXGjCg7COYDZSVgJZ9bjUQEV8
	 lHREPDJ+GE7Kw==
Date: Sat, 11 Jul 2026 12:30:12 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jirislaby@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH v3 0/4] tty: replace __get_free_pages() with kmalloc()
Message-ID: <alINJCLaJ8xo4ein@kernel.org>
References: <20260630-b4-tty-v3-0-a8476c66c582@kernel.org>
 <2026071056-comfort-dynamic-a713@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026071056-comfort-dynamic-a713@gregkh>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1747040009
X-Stat-Signature: px6kxgs36nqngpxsqyy5tqopfoia43rj
X-Rspam-User: 
X-HE-Tag: 1783762218-215330
X-HE-Meta: U2FsdGVkX1+rE12E2bWqa52h8GBbs/CCwZMAw5uLlywFrU59ErAGNrs06rak0eEN9j8pV2S4isuWrqpz0Y3W5D9umbo7q9WlPBDp/uUyASzM8KR1Lh0N5FXSCo6vgF6xus/sMtuIojWNbttXzNH+AZ9PSz7806f5B6NXyy0cjmcrb0ur3LIVeqDX0k+qQLEgagWcNiAsaA4cNYs4i0HXQoCib6c83xVwBm3s2VH6hsu84yJDZbpyWOWoodnDzyEM3nUzUt+NM+isR4Bou6bJswARXj6R880+kUCKKLpe9ZtrtXp7ssOXEHC2QCGrJSKbQDl+KUYpuP9ibd/yxivyQcrpTLMXNTbTfCgJAq3pMId+E18TE1Ihc0WV9ahxyJ/04cgUm3P2MOG22GvChABou/N6FeTo+2vMyuecmMIe2hzFh4dFMEj2W9cosz7tc4SfO0yMwNHZhYJeFs17p/PWCUp5hNFOCr+NYKxREZO+BarGRG6qjFZQa9WekqIlFlJkxTMe76RrgzMwvDPQW4efIjT2gX9uU0Nn1DnmZZwLw7Tz6fCji3QHVLts/uqfvg0dFbkUmgJ796D5dDNpkBTIBe/1IqnEoEQhMlldZW3QdzBVCdUZzFXFnW08DxaKECvLCpyaTKkEivWqXK1w1XQRvFcsi46MCB0YgZbKVJUN/JG4w2Wnf8px3WOBwf4zpll+ngnaJcK9rfwLrfup+Vn1XLlLGl4Rkcmr+SRzkFtPEseeNmCfSJyTl+wxRVBZReWc8g7aN6EYAGe0kXNtAxKhWRuwCU2KqXKBWpLd36ADq4qzG1P6/tyJ0gwkEPgjfK1oF9tqu+tp/rS8/QmkTJB6abSMjTrMyyEkql1ZSc2mh6wX6lCPUKqVOCUX9UIyJWIVgk0lmvKpCISBXb/FZw6Etj2SoMrEcsIHdb2pr9KFq2QYv9XdVSkAJF0jzFy5ZqO4qP3kXs/NY562/Tdvzms
 mKGi2H5Q
 wrqiQnjjO9jDNsp1g+ZswD6+j+rQqd+EFKLiBCRloYX/IZ9yx76xd+DlBqf9mL/s+pGVdX6VqFc9wJy8vlqY/R4840sAK8JyaQkV1i3lkMeph1JJxzBTrjY+17Xky7rBPqoZxaba13mHgZ6Kl1mPBR5ZEZSPYFk5Nfd+7gksk+qzmBjFLqDm+tri8s5VEmPc4W+ypAzBDVxK7KsEKZqUd/gi5Obw5OaNY7T4ys90P2YREsNIa4YO0690Xh3WLpEX/xOgNWuxbHbMTmzAh3voSRNmrSzYTEYwbIEwJbBoTOjulnoc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 02:44:16PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Jun 30, 2026 at 12:54:02PM +0300, Mike Rapoport (Microsoft) wrote:
> > This is a (tiny) part of larger work of replacing page allocator calls
> > with kmalloc.
> > 
> > Nowadays the right way to say "I need a buffer" is kmalloc() rather than
> > ancient and ugly __get_free_pages().
> 
> I already applied an earlier version of this series, so can you just
> send the fixes you made between them?

The only change was the placement of include <linux/slab.h> in
men_z135_uart and it looks like you fixed it up when applying :)

> thanks,
> greg k-h

-- 
Sincerely yours,
Mike.

