Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22132CD98C5
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 20:33:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6529C6B0005; Wed, 10 Jun 2026 16:33:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E21C6B0088; Wed, 10 Jun 2026 16:33:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CAB46B008C; Wed, 10 Jun 2026 16:33:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3803A6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 16:33:29 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D5B568CEEF
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 20:33:28 +0000 (UTC)
X-FDA: 84865153296.30.DE72841
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3B3FD10000C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 20:33:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QMyPIU42;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781123607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MeFCnd1HkJMSS1G/3jmmfWDV0XllC/uyHmcaIoiXzGw=;
	b=5bPGnIv9DrLj2nX9wrrOulnUIpxCkAeT3o0n3s2co61p9MysFB6k5JN7O4pVgYQUC7aEQz
	stiipQpe8JSljWHddo3nisI7UvTEA/g2LHv3T9NFqrqKIUV+FwmTm9Sse/iJ2Ud46h7gA9
	WOszmPi3kgNAQZ/tiwmveAE7TdaGfhY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QMyPIU42;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781123607;
	b=O8tTk1CSCTgWxtoToe1rPdyOzrII5LuBb12R0MqX+XasIUapvtHgZmR1JlHYEKCP3aB5wO
	YIFrj5swnh7wzix1lwdJu8mDnkep/Zta5CEFT180YdXbN35LU8gHTElXwnDUB3Z0CDkBsW
	veCMgVNV0BpqVZ55d68qBfLKhdW6QP4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8FDA1601FC;
	Wed, 10 Jun 2026 20:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEADC1F00893;
	Wed, 10 Jun 2026 20:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781123606;
	bh=MeFCnd1HkJMSS1G/3jmmfWDV0XllC/uyHmcaIoiXzGw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QMyPIU42joDy+HDnBw+dgcKKIyvtruqbfbs2j67CxLuoCGIrmvPQ7MmQaeqMTvj8C
	 Lvw3z0y0NfqMEY57T6XaZvbTaBml812RqtdN9CVJnZUx7qvdqA3kAsfvMd/Oycyh7d
	 xfXjW7hPIHprnh6JOdZRWBap8UjdlroXjdRup9YQ=
Date: Wed, 10 Jun 2026 13:33:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Samuel Moelius <sam.moelius@trailofbits.com>
Cc: David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 "open list:MEMORY MANAGEMENT - GUP (GET USER PAGES)" <linux-mm@kvack.org>,
 open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/gup_test: reject wrapped user ranges
Message-Id: <20260610133325.617652c3639b27b131de8b8e@linux-foundation.org>
In-Reply-To: <CAE+C+DZWRsKF8m5d-N-vkyp6rEw_T=ccWpUdqZVVYZ=oNfCvnA@mail.gmail.com>
References: <20260609004814.1240586.6294d614ac80.gup-test-range-end-wrap@trailofbits.com>
	<20260609182705.7b3a46e7c4661bd55f8561eb@linux-foundation.org>
	<CAE+C+DZWRsKF8m5d-N-vkyp6rEw_T=ccWpUdqZVVYZ=oNfCvnA@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3B3FD10000C
X-Stat-Signature: 58sfiyii48s96cmnfcz4wkk36r5scy1q
X-Rspam-User: 
X-HE-Tag: 1781123607-325814
X-HE-Meta: U2FsdGVkX1+u0QCTf8U9MujteAnyPtfagkRM3hJb0FQ9xr3CxBe/xrAMxPTfXN4el51UYiRhfpXbnI10kqBl/ZtEn9610A8sJ+8GwZ5mOOX0e9EUWxQzLSDpBEiV2vcTfjD07iWTKBODM0yuE/kCwh4+Z1kCAbXNuOH8HtRq1EZngvXM41o1+DG55qpUzbje/ZUt5ZtgKdCsV+QUAmwI4mpeIXSKLgVwJJeaP0eut7eIgcHl2yV9Is18FzEZvhUvFo1YPGC7RaxpEt8nLLAvsBiELNR4rZOkw2mUxNh6ddVZ+iDJqW6vGjSkTdJmEF2oXWGAx5WyCw77KVl3JSBTq0Uis82VD4xplS5LOHGefsmqDktIfbnfLSsDkBT8uvSzSKfsQh8TbpKew9CKtSunxiS6ygOVhxiNw/W9KQa/Qt6sabbgtnK0g6NlyA3Sy2uIF+6l4qlL+XzBD3uJ/tfE+ekQF7LJDyPzcMs7Na+QITVezNW4ho5pq0dtY/H/7TOzlau4k+7tNXNeMA3vWa+e3uNDq9T+E7iVF8LPO1AN6+zQd7Oi55MK0PInYCekRX8Phe11ztXHWR6eeTQQ8nE0VhiCZc3h2OjMrP2fNvsbZgGoozlx+yTiD3HYzk8QHvhAHOyg2YvU/7ein/6rqKWp+DAVUzUWhxHCaRcp7XUxFN2yYpTb7c0Tmiksjf9qObBy5/pOf8v3OkNsIQcf7mpf7OkPVxR5vHS8V9sFPejfEDXIViK7urIWWjWWz6u5ZJMNxtTnF+/uU6pk2/2hKMKny56byXVMGhi0gN3mCvHkJMhDr8BoGvdK42THExI7Mkil0svRWh4VQzn89fbS3WIyzjnW+nhQlDT0RJoxZAv9iFuLrPSN2twb520TuBv7Roa3/UvXeLvG4fOS5ZTuptwnMCUrBeVNqk1FMRT76RUQUEQq7AzoDihvMrNeRR6Kj/utiKeDqnKZLNQhsakmBLJ
 PeF2W4Dh
 5YO71sLqWxxS2o9s9EbekFIti/0qTjD4XwhtXC2v2amJ8BN8RWc3Vy6iCGKzsj7svp+Qet9/PwOJLuLSDwjdK7ngHRrtenuZ+sAGDpFzMIUfr534u8qaY/i1rVxwgXwAjKA9r6gPS3c6KkgTztAnFss4xWf/yk/T2gvaAavV94e4qvbA7k678Jl881E2knVBg8yiRFMhYfl0K+fKhemzDqfhvdCz5iyNBKq1fl2h/FzzVg6ClrSGGfLOJFRKTIJOXw6Sx6NQNh66izvlRlMsERO0dxj12g3pBnVdgZaE4O7Cu41dBpUC9solOtoJ35QHvYP1KMOC+M3j+9+vtZIb4lSHe1gv+LvyBhFLK+ejEfbHNdvGSRODyYkimSsxEYApTfMcZfyM1DhNBm8n6bi403TlSFDUSPoQgBKRX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Jun 2026 13:22:32 -0400 Samuel Moelius <sam.moelius@trailofbits.com> wrote:

> > >       start_time = ktime_get();
> > > -     for (addr = gup->addr; addr < gup->addr + gup->size; addr = next) {
> > > +     for (addr = gup->addr; addr < end; addr = next) {
> > >               if (nr != gup->nr_pages_per_call)
> > >                       break;
> > >
> > >               next = addr + nr * PAGE_SIZE;
> >
> > Sashiko AI review identified a pre-existing possible overflow here on
> > 32-bit machines.
> >
> > https://sashiko.dev/#/patchset/20260609004814.1240586.6294d614ac80.gup-test-range-end-wrap@trailofbits.com
> 
> Does the __u64 or Sashiko AI point require action from me?

Not really.  The patch makes the code better, that's what counts!

