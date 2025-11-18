Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 916C2CEE328
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 15:37:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE5D56B0029; Tue, 18 Nov 2025 10:37:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBDB06B002B; Tue, 18 Nov 2025 10:37:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD39E6B002C; Tue, 18 Nov 2025 10:37:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CBBCC6B0029
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:37:15 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7FE55896AE
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:37:15 +0000 (UTC)
X-FDA: 84124131630.29.32D491E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id 92F7C20017
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:37:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=OnohOJXb;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763480233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9qRBOpRFp/y3fjy/IOWET6iwhgiraMFiQ0WP7HK72L8=;
	b=NOWwn/OD+We9IGobbufrHjYf+Pv4kBsY8wj4a4OGUq9c39NYc+1+58opn8O+x1BQNAeHsS
	hkADkfzBMSBHgeb3ACSpw/WBeIrQf9yXxkSnDSZzGgVRRPi0oprtkyMRsndxd0ZrhV8Ax2
	8jnG2y5DjP/eH4g7qaoTvNRje9NHdUM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763480233; a=rsa-sha256;
	cv=none;
	b=H2dD4xzfdDPYBW+dWMAfSfBf10NJRdJVm1KbD1QXO5bZxHp6c/0ysS8TG/4WqLKTCkCihb
	rckrApi/Mw0p95PeDuDPwVtfo3ppfOxc+y1se6tDrZzO9te6He5fo4L2Sq48Y/MAKQ12cb
	xp1pJ7iI1LK2J5WnhZS+dbHV5KAWXNU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=OnohOJXb;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9qRBOpRFp/y3fjy/IOWET6iwhgiraMFiQ0WP7HK72L8=; b=OnohOJXbkOwQ7YKpHLtvPNlxnX
	zCJ7Gu6R/b6rQm45h7RhZAQIhc9gMHB/1TUz8nEr81ED1rXx55nva88Vg0XwIZPBDpf9i2THDUJQu
	As49cZ11Y611hd0FpeIdAbKsQLZXJQRWfiJhuM+plSknTqYXy2lxCljOrQrDNstY1KZZbJ1ezrN0l
	tBlq3e0g4r5B0W6xufYIi3Bovt3Dfyl0BIy8O0VsZOdSN7wVf6g6r7PpOtkPu4lrOLyTTAAMVjBqN
	YftY6B/THUev24ihZV0FRT/NTZ1YBE4nSACUOZTAc6MnMD+OF85SE6r5iQJzs6OWcshv1/IzCOX9c
	WsYj+WnA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLNlV-0000000FgQf-2CDq;
	Tue, 18 Nov 2025 15:37:09 +0000
Date: Tue, 18 Nov 2025 15:37:09 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
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
Message-ID: <aRySpQbNuw3Y5DN-@casper.infradead.org>
References: <20251114193729.251892-1-ssranevjti@gmail.com>
 <aReUv1kVACh3UKv-@casper.infradead.org>
 <CANNWa07Y_GPKuYNQ0ncWHGa4KX91QFosz6WGJ9P6-AJQniD3zw@mail.gmail.com>
 <aRpQ7LTZDP-Xz-Sr@casper.infradead.org>
 <20251117164155.GB196362@frogsfrogsfrogs>
 <aRtjfN7sC6_Bv4bx@casper.infradead.org>
 <CAEf4BzZu+u-F9SjhcY5GN5vumOi6X=3AwUom+KJXeCpvC+-ppQ@mail.gmail.com>
 <aRxunCkc4VomEUdo@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRxunCkc4VomEUdo@infradead.org>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 92F7C20017
X-Stat-Signature: 6in5ki9f7n8d3pgq1kr8186rapnimufb
X-HE-Tag: 1763480233-312964
X-HE-Meta: U2FsdGVkX1+X0p8kN8Eap5vkCc/jai/1kQnqO0yRxCLoKpJrs+sXCtbqn1unahhU3ms2MRbCVhcTNKjVUu2orKIFcw6TI/WbeR3vl3yavVXJEQlhHQpssebrnD1cj8C2JqkAit+UGVaJdKfG788eBdaGPtmCiY8b7oi4S4g6BSV7+5I0l8ivXIaAWseicwtWy4D0eDk6rYn9ZLRpCGb57NfUUxwcL3x5XHWeUzbRgs4Opne+JLbsrb9u9OBTXJ2co716JYiVEANsFTVGWIilDnSSL5dugoG6YtSb/4MW2oib8vc/TudAKo7nLQl7BGw9ZFIhgPTOC1Avlq0hp8cIDiGK7epbU5VrHtt4hgBcyOe0aYgJG0/ZOjc+UPPiz+Xe705hdT2xEvQFpkWCiy4e/x86Npop8wOGFnTkeoA9CRVjxWMCVmFgaFpt1jbhsrc4EoJCSU9QqWj7OHRUP3+Yk2rPZN1iZ+g2BadX82GftD5T7+ug3ASQrRERohmzFizAvAXeoL9CViK0p4lyEp01dzNmDFmmL2F6AUUCm4Z3SIaeQNvyS2QCwAc4UrrCRYNiP5upta/Wujt99K2xSVD+/KG7HQB3WuaGR5Z8KQWW+VD/l8nZjiBmGFT5yr+tKSBVsImMMASZ75WI0zDwFphydxdkuMUNAqNGYJfY06IjTT2xXP4aDywJU63cdwbaVJC36mNo7uUC8m/EMgy++sWV6hkFGSL8i3sceipgwa434cyh/P0sVSn1GqXKjuZ1Ggynk60IHUVnI6Bl+RiqVSQrU6fn20agkTGu4gQoLeu7IKtWa0JSThjjwx8yZlRQAlKL89FTiBc9xFStYrtECGeLtHw5RUYJ0CUf/OndNwwnzY7aMM9UR1fyGuo0hr8LpBXpid/19/8FcYu5BpscrYtHtqWBzObNcJyqXunJa78W8dTYAsYhW3SbEXJ2s17fdf9SHOkocRHl/54Eeyw9AEk
 gLs/IIl4
 8Nk/HPQuSbyf9ylE0nbyb3oZWnHVTrUEBXVd+kL8uu2wz4uU5Wj1WB4lE30Ffvh9lZLJQq+O3m5eZ2uvJIgoRljwDHnVA3ghTRpWXWqSU4hC/Ts4/PLjCxzU6+cTDfb3UaKrEpXdVHncq/CKzVEhDup6WjUe5fCdqrSNDPCkKwtyB5XUN2k/39iaVQj5cmzYvtEHSE00ri3bm8s5gS9yKK3SuBmvFRnLhfbmzf1C5NO5GvenjtVrsMS23+9xKTKPXiwZN3MgSxQH0N3iAgCgD92lgPTE5EEF4l/glQPdRW5H7XaBCeT1uwVBH9iaqUkiDhfRVx66Wx4BqAGmbqJ6EObfrJuNUGLRijbZ2EA+vY4Ft3NH60SKImv3yaj5y5bpJtt+U+K/3wUPo78Ck1xlucdlWFAF3/ZYmRno1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 05:03:24AM -0800, Christoph Hellwig wrote:
> On Mon, Nov 17, 2025 at 10:45:31AM -0800, Andrii Nakryiko wrote:
> > As I replied on another email, ideally we'd have some low-level file
> > reading interface where we wouldn't have to know about secretmem, or
> > XFS+DAX, or whatever other unusual combination of conditions where
> > exposed internal APIs like filemap_get_folio() + read_cache_folio()
> > can crash.
> 
> The problem is that you did something totally insane and it kinda works
> most of the time.

... on 64-bit systems.  The HIGHMEM handling is screwed up too.

> But bpf or any other file system consumer has
> absolutely not business poking into the page cache to start with.

Agreed.

> And I'm really pissed off that you wrote and merged this code without
> ever bothering to talk to a FS or MM person who have immediately told
> you so.  Let's just rip out this buildid junk for now and restart
> because the problem isn't actually that easy.

Oh, they did talk to fs & mm people originally and were told NO, so they
sneaked it in through the BPF tree.

https://lore.kernel.org/all/20230316170149.4106586-1-jolsa@kernel.org/

> > The only real limitation is that we'd like to be able to control
> > whether we are ok sleeping or not, as this code can be called from
> > pretty much anywhere BPF might run, which includes NMI context.
> > 
> > Would this kiocb_read() approach work under those circumstances?
> 
> No.  IOCB_NOWAIT is just a hint to avoid blocking function calls.
> It is not guarantee and a guarantee is basically impossible.

I'm not sure I'd go that far -- I think we're pretty good about not
sleeping when IOCB_NOWAIT is specified and any remaining places can
be fixed up.

But I am inclined to rip out the buildid code, just because the
authors have been so rude.

