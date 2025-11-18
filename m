Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E7BECEE334
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 16:12:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8142D6B0028; Tue, 18 Nov 2025 11:12:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EB9A6B0089; Tue, 18 Nov 2025 11:12:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7294B6B00A2; Tue, 18 Nov 2025 11:12:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 61B5E6B0028
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 11:12:26 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 27AC21605DC
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 16:12:26 +0000 (UTC)
X-FDA: 84124220292.07.0229953
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 65D0240021
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 16:12:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gzWrwAHz;
	spf=pass (imf01.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763482344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=28hAv0wP6OWuUdhTcmdSbEdcBJwXhi6h/avgklwAGLM=;
	b=aXXIZbiOCuiho4dB8hW5v4MF4bclP1gM0IOXnjMKL71oXkHNKmMkQW7zjiW8BUAp/vg9vy
	Ek+dzffNohzFypjatDghQt+yMJ8zVrTznYDVbWi9tmcC26U3P4ULm1G5Hop5AYL1JldPXS
	dnHgJWGyMMkG9OBLg0mT4a2nwO9/lcg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gzWrwAHz;
	spf=pass (imf01.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763482344; a=rsa-sha256;
	cv=none;
	b=5ZKMBXzH7uYkQNRFFsC16V9IcVcMf//efmnYeWS6JFQcb1otNeCY5tWWf+tzr7f1A6y1p5
	ZEshs4ZT0Be8aNszMOTY2kv56d/wmMqF6En+5jbNxiZjGPIZTUKmNnLV3gL+vAuAu1VmtR
	pNJJr7NCHI46cZ1QKFxm94KSLqmf1z4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 29D4A44657;
	Tue, 18 Nov 2025 16:12:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B969C19423;
	Tue, 18 Nov 2025 16:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763482342;
	bh=ZP5K4o/QCarBYT0cdcf/UtWV0Qrt3XMjzieN6I85paY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gzWrwAHz6PlrkLBt6xTex441mtplP/B1zXXOCxql4XgVwKlmlxscpS6VEFJXtZLDW
	 n5RqZyKy2RAVlvkr1hTQLMH2vuBy3+2viD00B6NVy/DyOLZ5btxAd0VjFfdZfB04X3
	 FFx2/sYXRruhb3SawrX4VXfJorB4MwUBcwYuTrpnnzYvz5nUjLr9dnedTui1e1P0o9
	 OFOexYhysPY7FJKEI7dKUpjj6VeeC8AqVZRHljg6HYVTkUeGdnIa5PJV4m15bd7el7
	 9bavzNe4widEMWjmwwBYWel2t+VdQMLzF81jn3RxPNYb36X9WIa6kxexaU01dYfY0O
	 68u1oGca1gwRQ==
Date: Tue, 18 Nov 2025 08:12:20 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Andrii Nakryiko <andrii.nakryiko@gmail.com>,
	SHAURYA RANE <ssrane_b23@ee.vjti.ac.in>, akpm@linux-foundation.org,
	shakeel.butt@linux.dev, eddyz87@gmail.com, andrii@kernel.org,
	ast@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
	khalid@kernel.org,
	syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com,
	bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH] mm/filemap: fix NULL pointer dereference in
 do_read_cache_folio()
Message-ID: <20251118161220.GE196362@frogsfrogsfrogs>
References: <20251114193729.251892-1-ssranevjti@gmail.com>
 <aReUv1kVACh3UKv-@casper.infradead.org>
 <CANNWa07Y_GPKuYNQ0ncWHGa4KX91QFosz6WGJ9P6-AJQniD3zw@mail.gmail.com>
 <aRpQ7LTZDP-Xz-Sr@casper.infradead.org>
 <20251117164155.GB196362@frogsfrogsfrogs>
 <aRtjfN7sC6_Bv4bx@casper.infradead.org>
 <CAEf4BzZu+u-F9SjhcY5GN5vumOi6X=3AwUom+KJXeCpvC+-ppQ@mail.gmail.com>
 <aRxunCkc4VomEUdo@infradead.org>
 <aRySpQbNuw3Y5DN-@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRySpQbNuw3Y5DN-@casper.infradead.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 65D0240021
X-Stat-Signature: ufyemmfd36hx5iud85y677gs3tfdmawb
X-Rspam-User: 
X-HE-Tag: 1763482344-548585
X-HE-Meta: U2FsdGVkX19B3gnfim5KuGXJVNNiU/t8nvSwby2UHE/RFwT68Ony6O2eHD7kNjJFMM1C7aLJ5M/4MIaW+tSUYyw2ZH8rhb4299wtI7o3b6KKCY1Xl67KYjI3rsY5+RgwK7ypDVOD3i0A8LNinMsdyAqIOiUtAefTkxnSVc3Xd5ev1t2o+dhuLKozu7rqY7fd2ySGQ3rmkNbNkk/7+q5iXFiBSD/67LsYV/oplhWQ7kYgbdsUCuUVZneUMD7Kq+Q2RS8hE8jeuVNzkwhmOGPMdn9B+Yuxy0RQj+Lsd0LVeElugUrmR9CjnBAu+H1GBo9jZjweUK6eMLcl6XHYbGkMmB2TarLY5tCZvwCg0+4GhkbINuZYETkaZCPFUKZV4AMUsatOLQMn8iYIWTifs5pZw2h3E6kBnB7v8bkaANR+OSLchY7nGtYEKdmlUhkW/JlqkoCw1dx5rS02kITwmzcMpIMXWGy62RiMOnl5VMe20w4eVUB1JSCG5HIk8XChawXBkrbCNdXOGmHfKkw+tsUOyjBOSldARa5N2RwbGZwoaTxxE1wmMvlFRUy5GrshoM5d5871AfyfiHRg9FsbmegZZA0nl+bQSr+OuF6iMeW1QP7Mw/taa3olkZuhtSGZPDJQIwyhzLkRXv86JVa9kwq76FsQPnJTpGebk2jlTd30mfKgpiH+Gx3f19kEci6kZxonKnetzGQcqHPkv980TxELUZb5PiLZZu/l9WRQAKIC42FxzLd/lU66qEar+uZ2MpxyCt1diqJL+/HdWTMLR0WvnpTAHjK47qL/LCgXc1qdsglKOWvOqFE8NSOVP4ga5rPY0wOkjHKPD8+d2nPTvAXAgeQKfmnBZ5TQLXK7KaoqpeTgKdURu25GjFDMBy72+ciZ1BVi3iRNEUQCze1kV0Ima5Wh9Uuf+0iFQjq1YriqFT2cL9hPFJBLrwgxr4CO968hRbBwvbLq7k7X3hUxOKp
 clBoDfpD
 SpxuIpLGahbjxXkxBwtu0Ikg6ZbdGtE36oN/4FitIy5EsuYxLo7njQitmsvMaPvAwlQnbcpV1O//qEgdTscRpjyVgwfARJ2x1/hhxEsXfWWyHvRp7YvYO9uFX6d2126bqUe6NGpdd1pfZnJmwTPAOEJVogt4nYFjtd+J+IrjGzJgUXPGUjnOIZmmjxu7UKWxXl/gQHLZrE0JR/bG4qyNIXlmMdze3rgz/0g7Vxh7lO9FeoFzafp7LDoInvNtx/SZpm7MPciZ3N6JSkUtfMpsQMEdeDMzAVQ8ptciCWTAYpMz0Npu3fuK/td9L19i7aUQI+rGpu/riRzfqsm6EmXZkF6P3LffsJrPulfqqTuzvOyIApAiTnu0963D1d10XDKSvvkvxpnx8vBV7R7jHMnNNGLkJ2F8+AQAmwY0tSA9wbX+X79Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 03:37:09PM +0000, Matthew Wilcox wrote:
> On Tue, Nov 18, 2025 at 05:03:24AM -0800, Christoph Hellwig wrote:
> > On Mon, Nov 17, 2025 at 10:45:31AM -0800, Andrii Nakryiko wrote:
> > > As I replied on another email, ideally we'd have some low-level file
> > > reading interface where we wouldn't have to know about secretmem, or
> > > XFS+DAX, or whatever other unusual combination of conditions where
> > > exposed internal APIs like filemap_get_folio() + read_cache_folio()
> > > can crash.
> > 
> > The problem is that you did something totally insane and it kinda works
> > most of the time.
> 
> ... on 64-bit systems.  The HIGHMEM handling is screwed up too.
> 
> > But bpf or any other file system consumer has
> > absolutely not business poking into the page cache to start with.
> 
> Agreed.
> 
> > And I'm really pissed off that you wrote and merged this code without
> > ever bothering to talk to a FS or MM person who have immediately told
> > you so.  Let's just rip out this buildid junk for now and restart
> > because the problem isn't actually that easy.
> 
> Oh, they did talk to fs & mm people originally and were told NO, so they
> sneaked it in through the BPF tree.
> 
> https://lore.kernel.org/all/20230316170149.4106586-1-jolsa@kernel.org/
> 
> > > The only real limitation is that we'd like to be able to control
> > > whether we are ok sleeping or not, as this code can be called from
> > > pretty much anywhere BPF might run, which includes NMI context.
> > > 
> > > Would this kiocb_read() approach work under those circumstances?
> > 
> > No.  IOCB_NOWAIT is just a hint to avoid blocking function calls.
> > It is not guarantee and a guarantee is basically impossible.
> 
> I'm not sure I'd go that far -- I think we're pretty good about not
> sleeping when IOCB_NOWAIT is specified and any remaining places can
> be fixed up.
> 
> But I am inclined to rip out the buildid code, just because the
> authors have been so rude.

Which fstest actually checks the functionality of the buildid code?
I don't find any, which means none of the fs people have a good signal
for breakage in this, um, novel file I/O path.

--D

