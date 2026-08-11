Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34A9EC5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 09:21:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B20B6B008C; Tue, 11 Aug 2026 05:21:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3631D6B0092; Tue, 11 Aug 2026 05:21:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 278D66B0093; Tue, 11 Aug 2026 05:21:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 061A96B008C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 05:21:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DD1E21C101D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:21:36 +0000 (UTC)
X-FDA: 85088445792.15.76CC4A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 422D140003
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:21:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mi4IM3Zm;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786440095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PG40/i9jiQY5IRXEmIjhZ6VgH2PeUxz+CsRiWBpSJik=;
	b=pJ2CBzAMfOAxUoKRDzi+ZqqEQ2dB5eg6Ro8vrELneGTqPsjc1b7d3MBvoXwuiFb5yj0g0T
	+aY1RoatpBa2mPBDOHMmE9XBcVWNkl3EZFEMIw4kn5wQmf9cMRu0sxKAHd+Dp6SNdptpAa
	/g84R0gdvLJ6ckDspXYW2MklEQZgMhI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786440095;
	b=7qqs+nPh0c85Nihr7Ms9QU9SRnt/o27kn8NCQOquFmPufkfzTlyZyOY6UhU6gbYj8VR/ZH
	ZNAdP/RF0lYEaUGePleLfCVt0Tu4WIALwlFL4QtJtgcqBD6xjiXUVk98XVZKgbcWdeakTY
	DjTabUBrsCQzMaXYZjKC+z8u1Y+JYRQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mi4IM3Zm;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D8D143B3A;
	Tue, 11 Aug 2026 09:21:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D7F1F000E9;
	Tue, 11 Aug 2026 09:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786440094;
	bh=PG40/i9jiQY5IRXEmIjhZ6VgH2PeUxz+CsRiWBpSJik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mi4IM3Zm1aUQHm/L3z82FoZcBlBiJKIUEdZEqXrTnt9We1xT+EENAL5sp88tEJnNG
	 EyRfyhbe2KrUB+juT3/8RZ6D2KPRZZJTt97aQf91ovs7ggMUGEeNOJINDfMU8t9Ybx
	 j+s1/Snpz1D4UodLuYAJWJLbSEGXsIIG7+5dV9GFr+B8s4y6kUgJctRB3Qgyx0Tqw7
	 rKRzSdkRButcubtIHmOhoJorAeLrZWgIZqxGt3zWoY2FZ6NTXJTrC+NBJYj/9ngvxU
	 dGwbo2QtLIDCRGheqZuY74iTzqGlc6jYp4Jw1CVPTGUK+F8onS5ohsbGw4qkOmFSEZ
	 N8ujtUPGwPYZw==
Date: Tue, 11 Aug 2026 11:21:29 +0200
From: Christian Brauner <brauner@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>, 
	vova tokarev <vladimirelitokarev@gmail.com>, akpm@linux-foundation.org, security@kernel.org, 
	linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: Fwd: BadBunny: UFFDIO_COPY shmem killpriv bypass leading to
 local privilege escalation
Message-ID: <20260811-knieprobleme-holten-palmen-4d42742b1962@brauner>
References: <CAGBKPgOm8q-8_rwyRPEmSj8JXdh_GaK1Q8vpJ=j-+yA0SgcNQw@mail.gmail.com>
 <CAGBKPgPPALX_5CQJAKUNjwi2fD28pBeS5pRuwQgePU93pOy8EA@mail.gmail.com>
 <anXnHMInq_JLYbWc@pedro-suse.lan>
 <CAGBKPgOfbMJruqcegJca6BBpEtpd91s5ASF_VU+gucWsjwp8WA@mail.gmail.com>
 <ancYCBUT8aB0qHwz@pedro-suse.lan>
 <anlOGOmO1HWVCMdF@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <anlOGOmO1HWVCMdF@casper.infradead.org>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: d1imxotzaqcmjqdmuhcjsys44mhs7qt9
X-Rspamd-Queue-Id: 422D140003
X-HE-Tag: 1786440095-341079
X-HE-Meta: U2FsdGVkX1+Tr3pKo/YqJGdqAphywrlzv/atrnY6DdlKiZB2271HsvgvP/mW1fWKcAlVQllM70ODHzAmy9c1SV9hTUF37fASnUHaYDBYuZfxKMZZkiC+HCv5Bm0Vu/hOYWFD23YQtvJrmI68chyWX36FPLgCQm7U6111lqnWMULomyALv/ge/ir0aUFvYI6G4GTwxg9TAkTPeI40ffkrz1wTPDGjm7oiWoPfUnFhuQFMEB9SOCT7LymHvh6z87USYZQa0CSGzFeV4kMrgJ6ltyWJmJYqRPIUT3sDAED4uApcJwvx+yujz73OeW2UzGnxVSFfj8xPE/d3iAC21FTTlKDeQH8oEsfEjQ0uJow//5GmJk8npa67EY/JUdb6HIOEZK2JqNL6UGe9HTY9vy268beFPAaN6phLA/fFOkZs6paOyhMDAceLTR3QdRRBG6Ojy0x3Vjp8TxuO+Y/Uvg5f7OWVKBwg/U1j7oTVpoyBc8h16LW9u4OjkshWyOpT6weHdSe/RXybun5isW0FSK9g3R3yQitsNkelBMzri1JkxExdyBq8281KoreG+epr/+Nxo6pnTd+4AXAr0ya1SDHDSIN9OCZYz3exQn2cH82ORBgSIe+PQT9gTATWJrEQ8e2H6RGRlUXcwpQ1phx5D7s6l4eYnQFROEES4pC7F5h7IvubmL1PrIEEHHmh7Oe4w8GIyK4yxgXPE27P2LD0aRXkmU/lMcfLEyvmjGK5vsJbRPNDy9bMPcPME6esf9deI491Z2uQZStM/JCIeDgsiq1m8w0EucPfsOCtvh5nGiIMYIL/QUQtYZjSZuM7KIeaBWcUp57tOYFVCY1M3/n1JiMTFLKOrp7BTg8TZdXiFyZAlU21f3M8tZqHYi7ZWicS8+I+4qMHmg6Nqi387MNtISyQzWWFJY/KgQbwbCNIyjIUcLtJDNMuLDNhzjEGZwwknHx1dcRfQ7wGBSDF8h8kFsX
 /DlShfg7
 5otCOzw/sRLgbg9fSmNmnbKJnLHTXXiRZ2Pwbxy2rHbSJWry0SB0/+S15+UtDVBKLP6y3ibRxey5mvasP+8QUZhnG9SHaynu2txMMroIDmG8oiWyf5pEBT+QOIuuJPjIIJ/3gvcPDaS6qlyehkiXhbYSXnZzP8Lzt3VUIouYPgrrCQcU7olQqUrdJHExfKjkIw1YQ+A3hAfO+jR0BRTz4sSryVbr+lU1/t/s7ez2lFfrSjZ2dR9Fn3+Xn1RdHKVVgSBnDv6ZLJhfDB+3YwGoLtvepvvuPI5ohMs6Xm80mnrriJYdEEZYKv7p3QCthuvycLfiVVD9LlUag0yg2MVq3ToDtC+DyMlEV+K8L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 05:05:44AM +0100, Matthew Wilcox wrote:
> On Sat, Aug 08, 2026 at 01:17:09PM +0100, Pedro Falcato wrote:
> > I'm adding a bunch of fs people that might have opinions about this. Please
> > see the rest of the thread below.
> > 
> > On Sat, Aug 08, 2026 at 12:13:06PM +0300, vova tokarev wrote:
> > > Pedro,
> > > 
> > > Thanks for the review. Let me address both points.
> > > 
> > > On the page fault comparison:
> > > 
> > > UFFDIO_COPY is not comparable to a page fault. Page faults serve
> > > existing page cache content (read-like). UFFDIO_COPY adds new,
> > 
> > A page fault can also write to the page cache. On MAP_SHARED mappings.
> > 
> > > 
> > > user-controlled content to the shmem page cache (write-like).
> > > 
> > > The correct comparison is to write(), which calls file_modified()
> > > 
> > > -> __remove_privs() to strip SUID/SGID.
> > > 
> > > 
> > > This is exactly the reasoning used when fallocate() was fixed
> > > 
> > > across XFS (commit fbe7e5200365), ext4, and f2fs to call
> > > 
> > > file_modified(). The XFS commit message says:
> > > 
> > > "as various fallocate modes can change the file contents [...]
> > > 
> > > we should drop file privileges like suid just like we do for a
> > > 
> > > regular write()"
> > 
> > I can't speak for fallocate, or other system calls. As far as I'm aware,
> > this is a best-effort kind of thing. As I said, writing to a MAP_SHARED
> > mapping does not clear the setuid bit. It's a super trivial thing to do,
> > too. But it's not a problem because setuid executables are not world-writable.
> 
> I mean, you're right.  But maybe we should make a bit more of an effort?
> I wouldn't like to see this used as part of a chain of exploits, and I
> can just about see a path where a confused actor manages to create an
> 04777 executable.
> 
> All the tmpfs on my system are mounted nosuid, and many of them noexec too:
> 
> willy@deadly:~$ mount |grep tmp |wc -l
> 8
> willy@deadly:~$ mount |grep tmp |grep nosuid |wc -l
> 8
> willy@deadly:~$ mount |grep tmp |grep noexec |wc -l
> 4
> 
> This certainly isn't a hair-on-fire situation, it's just a place we
> could do slightly better.  Not so much BadBunny as MildlyMisbehavingMicrobe

Let's not drag Bad Bunny's good name into kernel development. ;)

