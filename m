Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A581C44506
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 18:38:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BBA06B00C8; Wed, 21 Jan 2026 13:38:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5931B6B00C9; Wed, 21 Jan 2026 13:38:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 492246B00CD; Wed, 21 Jan 2026 13:38:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 35CA96B00C8
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 13:38:11 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D61685C16D
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 18:38:10 +0000 (UTC)
X-FDA: 84356830740.02.2AC0F2C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 356C7140002
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 18:38:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MegpK9gs;
	spf=pass (imf26.hostedemail.com: domain of "SRS0=IiP5=72=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=IiP5=72=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769020689;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F/uQZqP348MUBC3B1rmkS1Tv39JUtKuWbpk7OML86L4=;
	b=Sghcs0PkfJQyoSI3og/+3pP1aV3NBPfwpJ3mhV/QcxbB9aj0ysSlhaNUaRgmempwVxbmG4
	DErYr6gkkS8SqD3Fb3g9NvSI4et3MaP9yMV3MjB/RZ/qKwKMvAheW5dcra1wCq3XuRb52+
	sEONXxqzm6cfIm+7bHzqti/JFKf/WEg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MegpK9gs;
	spf=pass (imf26.hostedemail.com: domain of "SRS0=IiP5=72=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=IiP5=72=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769020689; a=rsa-sha256;
	cv=none;
	b=lVaDc+tXJPfkkn8/5ZCG5buWVUXNWGT+kHnlAEZG9E0CJ+BWQvPfK/9Dn2LsQGKswPVC93
	QkhXkxpIm7W185ZgIJf8faAoG7mw1sKL9iTzj5N4Ky7ehqqtT82VvR46HQA89/BV5twNSy
	0ARMj5YjZMEFQpfwOuoE4VG0JGGow9c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 46FDB600AA;
	Wed, 21 Jan 2026 18:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9DBBC4CEF1;
	Wed, 21 Jan 2026 18:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769020688;
	bh=1hh4ex1uDE6widfQ/8EJAr1hxwctCfZZuy9aDzidOUY=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=MegpK9gsVtYVh4R0tEQBj55SnWzqUincnli9RSKL3/Njw0EQvPdKkdqaYEMDEaadk
	 yvQw2P5P6XJTY7KPskg3zSVDoBcBCcXZfADOx8rR7245xMP82speBsUjUcA+Ztq8DN
	 AEyM3lPUGEjGTW8XwgpDPyw//3BvJ2V48gdLo9qwT1BCZ1yJEQaFXjeMc8rGkUaps4
	 nTBzZOYSwYHqFhMCDTpkQ5uBo/qNFZTBIStg/rOeDvAJaHOiD6pQjQCzciHFhJIyTz
	 zvd+Lv71sYyuv84IqXXdhiI35gmFA1fipY0QcBulzm0xniQtlgmR0oNcxk+1jE/VJg
	 GVV06RrmP6aTA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 9900ECE0B2B; Wed, 21 Jan 2026 10:38:07 -0800 (PST)
Date: Wed, 21 Jan 2026 10:38:07 -0800
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Gary Guo <gary@garyguo.net>, Miguel Ojeda <ojeda@kernel.org>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>,
	Andrew Ballance <andrewjballance@gmail.com>,
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
	rcu@vger.kernel.org, maple-tree@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH RFC 0/2] rcu box container for Rust + maple tree load_rcu
Message-ID: <15c256da-a1cf-4b7f-bd60-10042a8e9fea@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260116-rcu-box-v1-0-38ebfbcd53f0@google.com>
 <aWrSkAPFkdH_tvtN@tardis-2.local>
 <aWt4muGXbe7lBmXt@google.com>
 <aWt8Ze-otTkexNIe@tardis-2.local>
 <aWuKqLERqpNz9qtz@google.com>
 <aWuV858wU3MeYeaX@tardis-2.local>
 <aXDCTvyneWOeok2L@google.com>
 <aXDRHerRiM7TzACy@tardis-2.local>
 <aXDS6rNbsWhDVGK9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXDS6rNbsWhDVGK9@google.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: 8rp4g8cg8z37cygd71wdfqki4zu5w5k1
X-Rspamd-Queue-Id: 356C7140002
X-Rspam-User: 
X-HE-Tag: 1769020689-68154
X-HE-Meta: U2FsdGVkX1+DdpB/v6MaQ4rDHl+XuKksT/6npNfz1FEIYaeVYSEApv/h1NX4dH6a9Y3OEzVs6TDeb0qtK372oXr2Agk4PPs1W9h3+RXzEFiMXPteO3PWQnhU7tVZNdRemKcS8oFyeEGubGOvRyk+TtqgdXFgay8CNdmfI3HyQbeXUzHhxZTSoFlyWCngueR50bvG5jw85tbotIj4D5+IOOcXLVf5H4cIGKEQLBX5o8Kvt+ejM7C2WPfDtA6yLsA6OcVf10hLSmy9/obgSHY9dHyn9xMtz6EFJNduQiUOme+oyk1jogS5WwXIZacvrjs795Gx62j3nVWRTL3hyqa1eQCdW5SKzfT02yBeW0AD2vuq04inn9asaHOsZwkv8zuleLa1KmUPWjPPT5Sth3YMhtJMAfn4luE1cUF+A4UdngW+7rz72vVGkcQmBh25bgpYYthjPwPJ9H7fMO33+wP5943eYjxBTAjkjgGA2khByIXxiykJ1XxFFbYKzzx+rSv11RuiPcjWSgHirqX2DjE8S3bq6LjzdD+G9sDL5ORxSAycn3+/ORPcxbjFJaXgPbdSIcvZUGssFqyQFEK7WsodF8IAQreQsAkLAdL+lypjIaeKmv77kB3yBETuWEGs3XudNw6AJTLCN+4z5XerA4jIiW2v3/dfBMuZQ+Eer3KCGKuaA9F3ZPnN8ajV1IfG0cbd/Oaw7dIbaKUR/r0xC9ueMUVs8TlXOgsFd2lfGoPQw2spblp823iL3JZjw+Vdra2LaEeBU4S9A5fy829yNWgD5p6o2fPSi/LPD/cJXWsLJjzI0/GAWMqJi1bHr2Bw8Yl2kdeGAWI+hWbstXkfsMwBpSQ1Mq+Fzwn3iibJVzQfBTpMrFQ8wnupVglTBqN8qhWJQcBdKtXmtDKU/X63k2A4rEOMtSbTsmKyJHgRjKTHcHgenLLDIZDSo7UE8HvFa2i2Oglje8Hd3GGH7JKMRym
 a9Di4d8k
 F7MYAZpG8ehKPQdc9+vZkC7vlKaMux8dTjwP08N0ILZlJmxXTkvsPQHud4IY3eB2/lgrfrijKNUqxNRyNxFGdyATjV4N3KAFaPUm0smtjIu2bcmnA+k8rbapRjuDZeuueA0SJf8Ko+AZE3ImDc0VPZqV3DorvjXi4uw0ylkqhOOgw15+1izj1zf+b94fX5rgQXy38ED/wXaDwgbGGBhNSAbhKgoOZlxhzw057GBBL+0loU8/J8IOV2t50bA7Hq0ccylV5yHF1+L1opViFAtmvJ8lBL7KUgOwUeQtam6CULw2Kz9EqY/KkAX7psW9uwKG5kRiWnXxI/u5qnUbItKtPkKcpg5p3fBmtO2e7BrB4nob5Hsv41Ag3Vc4dbE/hxakGon8dKoN009ZrrLEJgtw1OsXHQDjUpVmv/I2KAxvBBBq9YrZ+sO3E5wHf7feFhgwLYWHSFVrf+AGp7aMZmgZ9zTm5gxiKjh3ylwoj8XQblsalo+udsGp9vmBsAS4Uhtfo5A7pSdRaYLy7HED53KMeLOmwXf9qGxt2RPHPIAOmIrJFtQL8PB5KjKMiy++CmDzg3/qf8Aj6mZNSJrMvamldRYXTKKIOVzYa5n/mE21oDEeImijTFa0uXovrX7+PYCD+ZIrQY5yInFgqPtBsHJwCRwZSfs9Ecp0Bchi0WdDc/QyZ3g9rl+ZgTWziYvfENI5h4WbUAWbMbF6Unpuh/eym7clRG31IWoEyamMQTKO48zNlVOQ3iUIJ9/cF61G3+eDKzF/6cDOJUz5BrHU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 01:21:46PM +0000, Alice Ryhl wrote:
> On Wed, Jan 21, 2026 at 09:14:05PM +0800, Boqun Feng wrote:
> > On Wed, Jan 21, 2026 at 12:10:54PM +0000, Alice Ryhl wrote:
> > > On Sat, Jan 17, 2026 at 10:00:19PM +0800, Boqun Feng wrote:
> > > > On Sat, Jan 17, 2026 at 01:12:08PM +0000, Alice Ryhl wrote:
> > > > [...]
> > > > > > > 1) "relaxed atomic" does not sound like something that provides an
> > > > > > >    address dependency to me.
> > > > > > 
> > > > > > If you look at rcu_dereference(), it's a READ_ONCE(), which is the same
> > > > > > as a relaxed atomic load, and yes in LKMM, relaxed atomic load provides
> > > > > > address dependency (Please see the DEPENDENCY part in
> > > > > > tools/memory-model/Documentation/explanation.txt).
> > > > > 
> > > > > You argued that we should rename READ_ONCE() to atomic load on that
> > > > > other patch series because "atomic load" naming is better than what LKMM
> > > > > normally uses. Fine, but relaxed atomic load is a much worse name than
> > > > 
> > > > To be clear, in that series, my argument was not about naming, it's
> > > > about READ_ONCE() being more powerful than atomic load (no, not because
> > > > of address dependency, they are the same on that, it's because of the
> > > > behaviors of them regarding a current access on the same memory
> > > > location), and we want user to specify the intention more clearly.
> > > 
> > > Expressing intent more clearly is fine with me. I still think it's weird
> > > for us to not have READ_ONCE() when it's a primitive operation of our
> > > memory model, though.
> > > 
> > 
> > But in our memory model, it's exact the same as atomic_read() (see
> > tools/memory-model/linux-kernel.def and search for "atomic_read"), so
> > why do we want to have both? ;-)
> 
> I've been saying Rust should have both because I've been repeatedly told
> that they are different. If READ_ONCE() and atomic_load() are the same,
> then I retract my concern.

I confess some bemusement on the allergy to READ_ONCE() and WRITE_ONCE().
However, we have a similar thing within the Linux kernel.  READ_ONCE()
is the same as atomic_read() from am memory-ordering perspective,
and WRITE_ONCE() is the same as atomic_set() from a memory-ordering
perspective.  The difference is typing.  READ_ONCE() and WRITE_ONCE()
will eat anything, but atomic_read() and atomic_set() insist on pointers
to atomic_t.  There is also atomic_long_t and atomic64_t, just in case
you want more API members.  ;-)

							Thanx, Paul

> > > And I also think we should consider using an implementation along the
> > > lines of what I shared for our atomic_load() or READ_ONCE() or whatever
> > > you wish to call it. The perf impact of helpers makes me sad.
> > > 
> > 
> > I'm not totally against that, it'll actually help Atomic as well, I also
> > hope that we can use `asm!()` to implement the cases where
> > `{read,write}_volatile()` cannot cover. However currently I would rely
> > on helper inlining to resolve this to avoid duplicate implementations.
> 
> I'm in favor of using helpers to begin with. I think it's probably worth
> to do atomic_load() before we do the other ops, since it's so much
> simpler to implement that particular operation than the ones using asm.
> 
> Alice

