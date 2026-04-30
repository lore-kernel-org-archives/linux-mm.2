Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E162FF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 16:55:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79F0E6B008C; Thu, 30 Apr 2026 12:55:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 776C46B0092; Thu, 30 Apr 2026 12:55:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B3B16B0096; Thu, 30 Apr 2026 12:55:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C3766B008C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:55:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8E85C41E72
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:34:26 +0000 (UTC)
X-FDA: 84715770132.04.8AD57BF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id E84EFC0004
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:34:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vH95IIdH;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777566865; a=rsa-sha256;
	cv=none;
	b=J21GKS3XeJ2Ig0d+YGnzgRDtEtPOBrFQb4VoFPbOXxXOL66o2GpJV2imTwmDbOG5jXbIxv
	MBPnu9bXfn4Dx7kT+49f42QKBkELMiNyZTmHA7H2hBK5CKBVFFajrxbEEqbKtwG3F4R33W
	GlBDDsfhKJ7uQ1uCW6lxTbS25zv83/g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vH95IIdH;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777566865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+yqToUVXQEQVVFxrG5NllfwhR75Hm1TcxiC5iS8J11c=;
	b=iCVjSM5zPJOB4LJNZTtbaE44lkjFPiGXEJ0IKnC6uT1I4fEdd/oxOVH4AN7JMuowM/rZJb
	+AJxSOh20Mbwd3VbfgTfC3nIV0GTntUaqcbDODpRRKXyqjFc1F4TD/7l4EFV9rTLw44GMK
	s8BIQFmhJ/3HtmRJZ3EufOiRUgNqfmQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A84F6014C;
	Thu, 30 Apr 2026 16:34:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A94A7C2BCB3;
	Thu, 30 Apr 2026 16:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777566864;
	bh=VeeQit/WflYUE/oUXMVUBbywDewNNl1r0QHqPo9WK2M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vH95IIdH1a1hS7FTFrWes5ZDLADqVcRGqzS1IFnydyeFkwzEcZarrCiRD8xYQXusg
	 eMBHA7BTXap7elW+bD+pNwlYp8GIJzhHm1LFS+dkv7vBns40c6OI+8u1kujR36WQYs
	 kQ0Fl1vaSNds5gK5BSBR2gZh4YS2BBpeZCVd3KE0=
Date: Thu, 30 Apr 2026 09:34:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>, hca@linux.ibm.com,
 linux-s390@vger.kernel.org, david@kernel.org, brauner@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
 timmurray@google.com
Subject: Re: [PATCH v2] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-Id: <20260430093423.3118ff0f295a9719cdadd91a@linux-foundation.org>
In-Reply-To: <afN2GBAjBSGlTgvA@tiehlicka>
References: <20260429211359.3829683-1-minchan@kernel.org>
	<20260430074305.9d3389ed71af040acfe222de@linux-foundation.org>
	<afN2GBAjBSGlTgvA@tiehlicka>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gj1yge976a3c9hw1t4wexubeqceieeu9
X-Rspam-User: 
X-Rspamd-Queue-Id: E84EFC0004
X-Rspamd-Server: rspam07
X-HE-Tag: 1777566864-411136
X-HE-Meta: U2FsdGVkX1+lcIMo313YvI3P7/0OoNNcUureBeK2iB51vaG9T3n5N3+Lq9pPtRjCcg2Z+rcgpOBSPUR3iTxXnQeV2+GE66p9X9w6fr3aKC+cW3bU3YlvOZLfDJN8Ir/GWzBRf1ge37r30sBjiUEYQk2wMoBu0DWjGB0ugZZAU00YIwr7YzILwh2qaiq9SzC1jfz7vT0Akm0cnzUO9MVhkMMR4Ypcm+UBZeUBX72U+JRo0X73UUNJBjMnp6rgphceV0PTKphoBm8sip9X1maTqj/rdGAsW58MW17+1ludd2b1WcR1yXIt92xDn0LIq8GO16khVqLy9VMY1aTpEastvzU1KElMtDAJk9xXs/susX9PqVveintfo1BHbEGd2pjN1juS9v7xx0l+/4haO0+WrCVX8lSeitHFlC318kuI4W7I3hpdGm/PpGaUJ6MK8NVroSAbr/Dg+wf0L55ILSrQrly5IvUMZGuRoFmGbqkaX+5X13RoZTKwaiikPf5H6kLJZjqFNZVMdeLfjY2H5g4D1+tbUwAW3Uzbkedhe/56zgu2+7LuL9en+DsQJB9s8UBrVPgj1/gDApNxDq0HHuw/yUfv1xzbXuVQlOgDV+YbJ2HxsrWKQJmsGwY0DMIHtwmno9INteHjafuYSo5WAdo7Ev9IUCaw93JkY4nHrx6TfZmRnn4txr7kCABcWqBqXxRcrqlga7AWsfJlkvTp+Imvcs2FBR3YjlgrmZfa5wgxPHmPY1uxudbaDJr6G2FOeHgcPAXJA9JmyuUZz0gzfe8YmDfuf9bz0f7ifn2M8F48L5FXfii21Mewr+wOG5m85yDORnbrsl20wTY5cc2gjirA5RgV8/dgDE66RJm6m0ZcUOg5E0n+u63EiSTus1HAtMsUpFf5Z5nt5Yl+i3qHyc3i2Ju7ISzHoxMn/RytseDN8Zv1SWhasVnFd993YIFJ5TrJHxkuX1apCfo/tXuJ6lP
 X7n01nS4
 c42xAmhAAiF+FvYv8PLW7joKjQ6tTG0LXU7beB3Wc+kYmIgo6Q2Pse8QOev+sRJuOQGFAJU1ihesdxT9+f4xzXsgkdEZIMMhKQ51dSX0Z7fxUxobXjh2lYMlS8cw0ABPXmJeMVqCKSXiQ41GP9yGDIGD6/dIa+PFdcGGtZSeZ3oqLMpHZo7gIajMEJG914hYJ9eXvPIyGWWCFHwEQ31GHxvJN5lpOIlXSZcfLs0TqnlQLNLweIDUYhDOXXEQBp5vzSKzDMDFqcMT+qArDmK0ysFP2lABoHMWjZYPlh9O/VOENhZsrra6SDt7dQkjFjpFUxMjql3sXwQMtK5daImv3anMKgFjJJFD2pnUHjNWIDVygVfgimP4Kq3YmbBSdPUGqliEBuvwm5E1butLeDcZ7XYM4zgQgM5sTc4fSryV9RkfSgGQpdfSJk3abRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Apr 2026 17:32:40 +0200 Michal Hocko <mhocko@suse.com> wrote:

> On Thu 30-04-26 07:43:05, Andrew Morton wrote:
> > On Wed, 29 Apr 2026 14:13:59 -0700 Minchan Kim <minchan@kernel.org> wrote:
> > 
> > > Currently, process_mrelease() requires userspace to send a SIGKILL signal
> > > prior to invocation. This separation introduces a scheduling race window
> > > where the victim task may receive the signal and enter the exit path
> > > before the reaper can invoke process_mrelease().
> > 
> > Does process_mrelease() have a manpage?  My googling was a fail.
> 
> It does. Very well hidden in 884a7e5964e06


Well, that didn't appear to make it into the manpages project and it
doesn't describe the expected usage: need to kill the process first. 
But I guess all the needed info is in
tools/testing/selftests/mm/mrelease_test.c.

https://lwn.net/Articles/864184/ is useful.

