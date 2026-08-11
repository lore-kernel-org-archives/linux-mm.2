Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20902C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 20:55:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11C436B00B3; Tue, 11 Aug 2026 16:55:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CD806B00B5; Tue, 11 Aug 2026 16:55:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F24E26B00B6; Tue, 11 Aug 2026 16:55:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C1D746B00B3
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:55:10 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4C5E21A0229
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:55:10 +0000 (UTC)
X-FDA: 85090193580.28.F21306D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8A65620009
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:55:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OdcZNlmS;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786481708;
	b=BCmXn3c9vxifv+0eGZpInO85PlRkemd7s9sVeLrZ3BDloLbWGi2bYA6voT68mvL5VHRmJY
	ImLAJK2aaBIfTbtUpMAMZasJv4hWp5A5WrKaMg2YT58b87eFCLxtSFBwR0qs27jWr+gt1N
	XJrJnszE0N7HLnvvIMzjyBKPrf06ggs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OdcZNlmS;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786481708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aQNBClanQhcKXlEpeCTI+ghlkNL60DbeIDtW87Lh0Wk=;
	b=pxR2V6tiCOpr4r4B6q93EB9DP0UdKUBPFzi25dhPzf8FiLPdfJeE4J4TRVR4RmqnCz06zk
	bFqjCBNB8gQV2p3IAuHqnb3Pjzby51gUDoizNMjF6mTrn3qWjhB4W1p3tSUcSCdNBeIdsn
	04K2AIVPR9dLuW3+CX7c/uB34uk+nnE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8634344079;
	Tue, 11 Aug 2026 20:55:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271731F000E9;
	Tue, 11 Aug 2026 20:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786481707;
	bh=aQNBClanQhcKXlEpeCTI+ghlkNL60DbeIDtW87Lh0Wk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OdcZNlmSpnlJRGeLjEVeUj5DvZ8Ix6Lhlzc13RQ+BvCLPnyAZpflaGcOjujFWkisL
	 zoSCGkfa1K+3RazlVtZqWkANfM+hjaYPMRfroV23KO9qxU8tdG6NyVAA/FLX2Htg1c
	 kpIkZ6v1obesytonpw9MzZuzGTIuMawmrYwgDOUdRlk8ReqflGiTBuK6WvzipLgt7o
	 r2dO61VSgFz9UyX1nykqqw4y88jjE9/PuCI9TWxLuaEtqaZiV3z6B00CDgmrtyLh8v
	 ZvsbRJgLYL+JdX3TvbThNDha88TlzzC8dT8bSG4FVOS77BTbsa8jYXW7mB2EQuTfu5
	 9PNssn489T28g==
Date: Tue, 11 Aug 2026 22:55:00 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Omar Sandoval <osandov@osandov.com>, Jacob Lalonde <jalalonde@fb.com>, Shuah Khan <shuah@kernel.org>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 00/11] coredump: allow to create sparse coredumps on the
 coredump socket
Message-ID: <20260811-morastig-schadenfroh-kabine-e2ae880d038e@brauner>
References: <20260811-work-coredump-sparse-v1-0-cd3e8b1e356d@kernel.org>
 <CAG48ez3QwUopEyfB0tEc84A57g3GZdnptazJW+htiTi2e0Gc=A@mail.gmail.com>
 <CAG48ez0Ty5GTR_vYazWsWOigWP2=8SYstw13zaiJB3auBi1bcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez0Ty5GTR_vYazWsWOigWP2=8SYstw13zaiJB3auBi1bcw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8A65620009
X-Stat-Signature: axkwk49m66n56fwro8ye539tqxws5mbh
X-HE-Tag: 1786481708-136176
X-HE-Meta: U2FsdGVkX19g9OceOW/4DothB2FClN4nhJoheZbRORv1ayW8Nvz7hf3TYyYkO2AiQenFrGkaUohGErSAcoYthe8c9EzCbq3P8084Y2b7ERC10e4dzsVJZSoHRqOexrzvoK0pX90vn3tPTIY8ZTdfRkTK2Bri2Ju1RDOnd4AEKUFYLo98LyARoDhZAU/ZvXRuqTcPck8VSPwY/yqkY3ENyhwYDF/gKs4V9Pyi/ZPdgx2GqSpIu1ICS6IIZvd9XFrlwTO2odB31f6seDfu1WucfQ7qHcIspJAv4KTOwXwj3jk85lPOQGQUWsQVbm9QN9qkSKczDVKXXCRj6CLHsXUkDlxvdjfWkH0pVYuAhGbE84zQYNonWGI3gdQAQWKTQSIYMjd/GJfI/qp9lTQ7ADelThTbPuwGw2TMHR9rN7jVsQ/2c3+kPJ2XGJPaN2KxfJvHuHUc/EEObZvsw28My/CxCy/DeqkCnX8dNqJvF68kdNv/g7K17dadKoVm5g2uV+y27cWJvC+RXFAcYjYZQUYvoqxWy3+5Pdd8OfsL6cijYc8JY9o7bajYvrlXqPFjFABhb9S1/Qwp04TBP5XrR4t+zbWYSW8FOIeVzykoNRRI3V02bL9/ubJAy3GIXnf6NjsVeCWroNF01ppX5jMa3c3UYYZyZnyQeZCDMMN+GMZR+xz+5HnNG251q1VcvZex5WBlXPUA1SThTBe7U1Id0H1rIZH07p7+D+haTNJnO880idu9BF+M20ONy5AwhYkQofQq6OkKgkKuIr02dlg8ZVQpP49hzlLBQFWgJegZ77Z8FWrIbivIUlfHbwbbCCXFWP4XeF6A0Cvzuzw77q3mBXlEZQa09loxZzM+GQA6oRNQ5ujeXCaSt8WSpRjplTmXlwwXQxL0lMDrYKeXLaaklgHZsdo0WZKgWoEQhSMuZXgeNsIYPjTIiQz/Xt6Y0wzw1KcuhFr1Gj8ANiyAXlgD7I3
 Iy10UaYZ
 V7izAtfga79zLJFZUZRoH7oCMyA1aBwges0pCS8ryfigkDeiq1wRdnsdTQQVcsR99ZLCjgQTIaaq2l9IzbK8hj5pvWUMXvlYi1aebwsCxIw+xlLya6dkNnSMl7Yo9VKVrXJjm9kKN4mKZSoPMQO2hDJ1zOvBmEqrU+ojhkEbxnWy+3+ofhtonEQFS5DA3t/6s2DNYrs33+Pajvq8z2sO4dS3BboTwW0mJ9/hu78uWXdLgPc/7il4WC75DsjySZZgJlUhkdx1VZcbLP9UPL31vO6VPzw3xQrlqDR+JlNE/hjPO5c9xKpD30kVlX6zar0L8S9NN3A1DVWJaGKNMDAnlKJwHcSvKwmMz6uizVnT2MOsKd/ylK/CGHqJzXzJF2T2xZhB0ZqcFy8kTNT9iNtG781QVKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 09:39:12PM +0200, Jann Horn wrote:
> On Tue, Aug 11, 2026 at 9:07 PM Jann Horn <jannh@google.com> wrote:
> > On Tue, Aug 11, 2026 at 5:27 PM Christian Brauner <brauner@kernel.org> wrote:
> > > A server that raises COREDUMP_HEADER in coredump_ack->mask doesn't get
> > > the coredump as a plain byte stream but as a sequence of frames. Each
> > > one a struct coredump_frame_header followed by what it describes. A data
> > > frame carries its bytes. If a server also raises COREDUMP_SPARSE, zero
> > > frames are sent for unpopulated mappings. They only indicate how many
> > > zero bytes need to be written and to not include data. Reassembling the
> > > frames gives back the same coredump. A debugger and everything else
> > > still see an ordinary core file and nothing outside the coredump server
> > > has to learn anything.
> >
> > Hmm...
> >
> > I think what you're doing is probably the easiest way to do this in
> > practice. I guess some design alternatives would be:
> >
> > 1. (overengineered, not generically useful enough): If the transport
> > was a pipe (which already has the concept of different types of pipe
> > buffers) instead of a unix domain socket, we could introduce a special
> > representation for zero-filled pipe buffers and some API for receiving
> > zeroed holes through lseek(pipefd, 0, SEEK_DATA), but that's probably
> > not sufficiently useful for stuff other than core dumping to be worth
> > the effort.
> > 2. (somewhat overengineered) With some refactoring, we could maybe do
> > something like /proc/kcore and create a seekable virtual coredump file
> > that we send over the socket via SCM_RIGHTS?
> > 3. We could leave the userspace memory dump out of the core dump data,
> > and let userspace take care of filling out the memory contents using
> > /proc/$pid/pagemap and /proc/$pid/mem? That would also avoid task
> > switches and SKB allocations, and probably reduce the number of data
> > copies involved in this by 1.
> 
> I also wonder what userspace actually does with this data - does
> userspace just want to write it to disk, potentially after compressing
> it? Or does userspace actually do some fancy parsing of the data

That would be the most straightforward use-case, yes.

> stream to extract stack memory or something like that? Or does
> userspace buffer the whole thing into RAM and then process it from
> there (it kinda looks like systemd tries to do that but I might be
> reading this wrong)?

I'm not sure about that. I think it's writing it to disk and then
parsing it. But it also wranges it into a socket to forward to
containers or services.

Note that systemd has a pull request for the coredump socket up:

https://github.com/systemd/systemd/pull/43330

This should kill the usermodehelper soon on kernels that support the
socket.

> Anyway, I've looked through your code and it does look fine to me.

Thanks.

