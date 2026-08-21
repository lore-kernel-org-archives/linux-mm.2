Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F9AFC5DF94
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 17:38:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 879616B008C; Fri, 21 Aug 2026 13:38:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 851816B009D; Fri, 21 Aug 2026 13:38:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7670F6B009F; Fri, 21 Aug 2026 13:38:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DC806B008C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 13:38:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CBD4016020B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:38:15 +0000 (UTC)
X-FDA: 85125985350.23.95D3DF7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id E5DCC160003
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:38:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NClu/56f";
	spf=pass (imf08.hostedemail.com: domain of "SRS0=P4xN=GO=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=P4xN=GO=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787333894;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fq1qopQjiGOPEPv7nYP2HWEyvKAIWD9DM17U/AxQx8w=;
	b=A8COkKEViRZl5edB5Uwv8lVC1MHD0Wt67y9zqhE0d5o4z9AJlPEDas3aLEf3nZNQkWRYBu
	Y235KKwZyAWB0xRottkd7SGmkwzkyf8a4cOaQCnNZ7ks0wpNTclSsRDoN7FTVzHDJ6a1tJ
	Uk//BmumNLxEsZjvNhDLkzgg1btP67U=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NClu/56f";
	spf=pass (imf08.hostedemail.com: domain of "SRS0=P4xN=GO=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=P4xN=GO=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787333894;
	b=W7igSPbk3B4QM0+P7+hpV43MJnxzcA9Je9s/gzcGPTsK/pSVXHyioge4n46hGCS7sNO25U
	AMpGv7ocO75xJ/SEkXNP3wAfZ+pGqNjZAPysZreDe9YHvdF0w4rBpMW+SfUXDMFHd1ZFZn
	BqfJ0XqhpKzxvwdfVHKd8y42S4S1KGc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6655143EB1;
	Fri, 21 Aug 2026 17:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405CE1F00A3A;
	Fri, 21 Aug 2026 17:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787333892;
	bh=Fq1qopQjiGOPEPv7nYP2HWEyvKAIWD9DM17U/AxQx8w=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=NClu/56frA0h3WA5bKxCjZdnf3aTWlzEWF3yD1soGE14ElWcChnEkVdNaLT3GRkDc
	 PKlC14Ixf6CvQBeTKsRKC8dvh+oB8yf6lh/YFOndr634PGp/TnTP10ixW1k6PV/o4h
	 JzXK/SByraA7LRcN+OluR519sEvtOYF6iegKoBiK7+vpUIumPAcUvoQ3+qsYqv2A6n
	 kDmYjPr/M5hz1H8WOy9rptUsmPN5KiUEAWxbkwHCOsNrxNsM1Qc7wTAnQvh72aV7f1
	 FngUTTtnoqTRUhPYNMQj4EtKGhqmtjHUtkjD1PzS5Xyu/Z49X41gXFFwEFE7XdFP6M
	 KzPvSdagV4CIg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id ECABCCE0978; Fri, 21 Aug 2026 10:38:06 -0700 (PDT)
Date: Fri, 21 Aug 2026 10:38:06 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Michal Hocko <mhocko@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org,
	kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
Message-ID: <333c4cdb-8f34-4e3f-a47f-961f47e089a0@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <a48e6e7063122b22a8083bb0792984a204f316e6.camel@infradead.org>
 <fb87f673bf290cad133d113dbb0750a7752b9d30.camel@infradead.org>
 <a94b75e8b9b1d2191f365c0f4275fd5082332df5.camel@infradead.org>
 <d0692500893f303906fba1d7d596eb59a07a806a.camel@infradead.org>
 <anydY25Cl78l1HfU@google.com>
 <932DB129-1794-4855-A61E-F4C2B54B1EE6@infradead.org>
 <b736237c-64ee-4eb2-8201-5685a3853844@paulmck-laptop>
 <5f6a0669f319951462c2aae3a50d595983a42e4c.camel@infradead.org>
 <49df45c6-4d0e-483a-8acc-0ace7f9a6484@paulmck-laptop>
 <a17c8d33102c49c74a64fb62d402b315ba950577.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a17c8d33102c49c74a64fb62d402b315ba950577.camel@infradead.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E5DCC160003
X-Stat-Signature: hwfzx5jgxni1hnip8kcn7uoog8pnzwy6
X-Rspam-User: 
X-HE-Tag: 1787333893-545109
X-HE-Meta: U2FsdGVkX1+dIbEt5EIQ9nRwOTV4I55J9aEVbl6gTrOA7Vd0v3FyNkt9MdmvrZ0mBi/7l03Cy8ETE2DsCZ0ZDNqvSIGk4Sgw6H+NP/D4HAS1t/0WLU9cuSbo5AJHwTOw2h0HRK5Z8GrVxf29J2ebRXhhVEse4agpCcIeFbdyYlI0D7McUu0/QXcrUGcWv2fc1k2quFgALhwf3c+QvAKK5IA8NPdbDOmFocalM/MMfI1mBs2DO2oh7uQpF10sqA4f1NvX0YzteNpj/NImX1Xn2xP519uMgI5+MRv7fLmuDehlrYgf5mu30Qwr55Y4RdQz5ORHhg2iTIrnWaNDlj+swY3i4nCNKkP8KEJtCRrpH9ROr0ZyvV6zc9wgHrtgQ0970bIXUZdrGuD8hpcor/1eVODxdqwccrXSAhZxJjrebk0QlGmDJK5lMKwJo58smbFzSNKMi214emU4hbOKacWrSC7ocOqTpxPKt8TQUzxUm8Y+dBRDJwIhyhJp4T8xzN+PanQ52D4iK3eOfj7GiuY1qk1zUoagro7Ky9vVXAP9+jMRA9MnBn8L+WWDYjgNOdYIjJ7koOYHwJgKrqre2+w0pzYqPm+QeF6r/tfIYdPG7GZJKp35tpcEiO6l7oJ+LnotbZziwA+aTTB/rxkgTFdq7hkJcixuLIf0tNWW22zW0h56urXnHKgpIjDrgi6F8L45/wZWLQxVn11ryyJ8P6E+MXJJ5EOfsZdSAbwolheurhOdL6lYKPqdlLRlQYfECYXTO89KpZkBEn4UkO9uRsY7riOAsB4ld2y/ngf7b+pCazI2CZLCCIazlvFBKZDNcA7jghceESeDIM9aIIYAQD22NCpsNp3YPZ06aw7oOT0yOrdJCuKXvTVYAsbJfDQA9JyakFvU0VyUN//IneUfrzwa5tHaTex0k3sbMgyqfhhMK/II6nItuShP/JayebBSMBGSeuxLz0IxKZKjI0cDkLO
 fsYsq4Y3
 xiBTLK0ycccTIcZWH3rM37VuGTMuL853JXIk5ys+1TBjFNhZsbuqaiyV9aLHLdPBlSk3GUPFbd3Z4Gify50DR2DnxJHU40Mo8TWRdIfSW6mbYGQHOL1ikO+UnkIWXxMlEl3l77LLqKAjuiWwmyEyBrXQ77jAkWB+CLTlIYSTGvvsgwNtdOJsdAOjFmedoDmrgSyt1a/xjzYQUasDLaA/2s72gJWpH9QZtmbPX7fbZt2SrQ8VquDgzEGx26+1JlzcL+TCOgr15l+9yFWbz2trn68sJ7kcEUeAuw6kWSSJJc+bRreCw70OKPTA9fo4uhFb7J5GDBwXZPH1MH/AncKTz6kJ7KGS0ILrvNtMzESqdZ0LH+qHD7PK6mXN0fDGdbyZxg165jiyvdY4htneA2D2KuyhLao5iBA8OVxTFmUYxvrwpzZQpCK8ie+o+N4Q3G2GmHiAfelpxHofpC/KteI+9NjhV2sz9dlNOxyKSKUTDC+YMHTdOyTVI+BaT2eNoyFBfbXqVJRh6oJM5o0yPgE+ZXAfm5eE0ZX/JsJjPzdmdZw8X1txUXWKTUCj3dqbtMH1mXlGEDA0RY+41QX07SNnvhECzvw1GvCAkkJUpklV85nRsu6KlhJB9Dw+lG+pLvvy/+PRWCtlyz6x20Uft+97SOGQ+DXUxYfTZWxvaU8ISJdxinS3thjyzNulrCYOVY327PLMj0cwKiei/ijWMiOFSQMiuxcDBEs5ImKPq3KtyeVdxA84CjmKOSvORUtvT/KZAwfAXBrPhYPrXIe0waQTWlgJvvT1twx7P9FoEPbn5b6rcFP8fK8J5JeCgKqCafAhZoHUQU3bkPOpbOcHXV7TfBudOSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 03:43:01PM +0100, David Woodhouse wrote:
> On Tue, 2026-08-18 at 11:18 -0700, Paul E. McKenney wrote:
> > On Thu, Aug 13, 2026 at 08:54:44AM +0100, David Woodhouse wrote:
> > > On Wed, 2026-08-12 at 14:38 -0700, Paul E. McKenney wrote:
> > > > If not, please let me know, and I will put together that does the
> > > > job.
> > > 
> > > If you're working on that, I assume it'd need the readers to be known-
> > > atomic. So if any of the read-side SRCU_READ_FLAVOR_ATOMIC thing I
> > > already threw together is useful, you can find it in my tree at
> > > https://git.infradead.org/?p=users/dwmw2/linux.git;a=shortlog;h=refs/heads/srcu-atomic
> > 
> > Thank you, happy to steal pieces of that with attribution.  ;-)
> > 
> > My current plan says that if you have an atomic SRCU on which you
> > use srcu_read_lock_atomic() and srcu_read_unlock_atomic(), you only
> > ever get to use synchronize_srcu_atomic(), never synchronize_srcu(),
> > synchronize_srcu_expedited(), or call_srcu().  Does that work for you?
> 
> I just said this elsewhere in the thread¹ but I don't necessarily
> expect you to be following that. So to bring it back here...
> 
> My mental model for srcu_read_lock_atomic() was that it was always
> atomic, even on RT — it was basically equivalent to a raw spinlock.
> 
> In fact I think it would be OK for it to be equivalent to a *plain*
> spinlock — i.e. atomic on non-RT, but might sleep on RT.
> 
> When I wrote that previous email I was thinking that might end up being
> additional complexity in your implementation, but as I type this I
> guess it could be as simple as falling back to the normal non-atomic
> case for RT?
> 
> ¹ https://lore.kernel.org/all/448c5c0128b08ab98d175ae1099ff4d4874e49b3.camel@infradead.org/

The current state is that if you invoke synchronize_srcu_atomic()
from a given context, then srcu_read_lock_atomic() must be invoked
from that same context, or a more strict one.

So, for example, you can disable preemption across your invocation of
synchronize_srcu_atomic(), but only if you also do so across the entire
reader, starting before srcu_read_lock_atomic() and ending after the
matching srcu_read_unlock_atomic().  Or you could instead disable
interrupts across the entire SRCU reader.

Does that work?

Also, Tiny SRCU atomic turned out to be a bit more complicated than
we were thinking due to lazy preemption.  ;-)

If you want a sneak preview, please feel free to take a look at
the first few commits on the "dev" branch of my -rcu tree.

							Thanx, Paul

