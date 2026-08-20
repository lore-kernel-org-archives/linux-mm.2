Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF916C5DF85
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 15:34:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AEE56B0095; Thu, 20 Aug 2026 11:34:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 986636B009B; Thu, 20 Aug 2026 11:34:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89D226B009D; Thu, 20 Aug 2026 11:34:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 66DBE6B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 11:34:19 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E82E81C08C0
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 15:34:18 +0000 (UTC)
X-FDA: 85122044196.16.5635260
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2D52D100009
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 15:34:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=pfcctPuN;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=SbnMBF3Y;
	spf=pass (imf05.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787240057;
	b=v2sr0FAr5f2L5SMndESJ0e5FrkPlgnOm6DEItBdxVE4ZLKbxwez2ivv86NZz7fIRodLyD6
	XyTU4x71m/OlZSRW489A6rjDeuvGcY1uNfCgsPq+i4qRbShtldnKjBtzAJ2fXXwMXnqdrT
	JBa4O3jzQgd/NhA/v15JYQ0xIW1orqI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=pfcctPuN;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=SbnMBF3Y;
	spf=pass (imf05.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787240057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XnQ07X6Vq1lV2T06V5sf/SOjpM/4n7JqjKjnkaB9qXc=;
	b=sCqpqmAQiBO7OiNVoAryhnFrkcFoUm948QUEh7jkijAJ57SpBwH8Co0WDdkaa/l5wavaRG
	mTuG0QOxu/6Wjgk7Zn25nJSdFiPNmKGc8N1yGUEx4tAS8fmA6BmDTJcBMuPkibSgDJKyev
	xflauwwfYp1Fb0z53lAwhAGVAC5hZc4=
Date: Thu, 20 Aug 2026 17:34:13 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1787240055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XnQ07X6Vq1lV2T06V5sf/SOjpM/4n7JqjKjnkaB9qXc=;
	b=pfcctPuN5/Xbfx3OXgOZDbHxVwzMgOj+0VGDZnd2Tffm0m01fR0cJvlT6tINnj1YogvMNz
	iycKG7KKK5z+DtNSjyd7I5L6KJ98j+TuHFVAFDDJd4zP65mCNStqEyzp4hNi2FJydFiEeY
	vOADJVPPv6e+6zQAzax6ShueyhGSokHbl6mAvnppmno6TkgV0JJZPyS3nZV89H8GbFC8sh
	o2hxXTs4hWMZ1YmtDnYguiGQZHU1mc2Uj8zoEy7IXyPRQFy+Y09tbME7s4CUIiQyvCsAjR
	RW1eiGVXpyQ/ajFUfUjJo9FY4iixItpjyUtKPZKMmwazIg7lWKwM+KtT4dIwUA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1787240055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XnQ07X6Vq1lV2T06V5sf/SOjpM/4n7JqjKjnkaB9qXc=;
	b=SbnMBF3Yj7gzKAbvIHxsY1eMaDbTkPtAdcZdgBYd1G/FlP05ovO/uptZmhdHqzIV3qJjHX
	vlBOFDr8qv6M7MBA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Michal Hocko <mhocko@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Jerome Glisse <jglisse@redhat.com>,
	Christian Koenig <christian.koenig@amd.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sean Christopherson <seanjc@google.com>, linux-mm@kvack.org,
	kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
Message-ID: <20260820153413.1EAmdFht@linutronix.de>
References: <20260820133020.7ZCRIhwX@linutronix.de>
 <448c5c0128b08ab98d175ae1099ff4d4874e49b3.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <448c5c0128b08ab98d175ae1099ff4d4874e49b3.camel@infradead.org>
X-Rspamd-Queue-Id: 2D52D100009
X-Rspam-User: 
X-Stat-Signature: yoesrypzgor9jcw6ged91tg4s5js7gq6
X-Rspamd-Server: rspam06
X-HE-Tag: 1787240057-485743
X-HE-Meta: U2FsdGVkX18xmRLhks7e8DbpRGVk7Whs/bMgy692ZYtT5JGxBWDp46Cf+rIkXr/AaLpPCGdED9ChlUP0WFrdGiVHglWNF7+Fo3RDC1SyR9iSpjsI8Hp9XkEeN+goV4MYFLJMTT3E2XgRZwQJ5zZrJAs7dzDU8OqXPRNgDfUb1z1H2d5Z/fc5aheel4AKbCK6g4Bq52vurEw4dClKlBRCv5fpCzuB87Loq2Ugi1OtUkrpDuK8cpocRcP0N2qDNcUMdz4HnEBID61NzQxnL0Q+Etqavf3THO57D29psDVug9KDF0Pnkn1XRqzKM2p2OqzpwJ9EcGjvUuyuuh/SEDFN5EliIzkYdbpYPu6p0gcHF2e3O5+YVpJH8w+L80N9xHfhW1CR/GLkYE5zemcOsi88qKMVhyHKkZd7l8ZWt5NuQDcAiSGMm1E156NcRr1USrSavptEAu/uB6a+B+8xAKPU5CJqH7gAW2aPGho+I+N+4OccxAoV4LQaIJNN27T+Wq+KFdIcpRfT5Aiitb6L4l4dg4GMaRthHXEC+alkpvPSE9FCihQj/1s4VHZkq+nfhTIEKzjJQLAPvTqQzKil+MrSELtc8++kgf/dtvESQ03WmW07WEqXDCveZFh9YAjXIkQbQj9YtKVudEqNuBCWfUCnN0KVP53XtrgWi3bZ6cfyR0IfCHT/w3pis8SeXC/3hhsemADZw/AadoFTB5QvKEqMr3O69Urxfms98jmmlHU6+iTEuobRcezhzX8piI1YULvzzbD1cnDgBurkJSv0A3ts/iz1Y1hCdZPDEpAOHKlcz8tia75cy1tdXipZXZ4PxbLQe7CN8nm4QO7PJYwTXNquOCX8XxPXloISWwgYndzw5KH6TA+IwrMrFNwyFl3Pa5xyQXKvbmtf1hnBCmH6jjr9wlwv4N9zzM0EX6lfKtW8YStnu/AS5q/o87jCSwurVZf1rVre3ullgmCWGs4XPlv
 VB9uAT4v
 qDebzq7XqhERIUmBl6j1zNc/PPvVjlNI5GI3o9EWpNGuztHdMCirKHV6xqu6zaGTTGdslznXipGiB0x9dYO00X0PgiyGOPHq2G6UViQLcI3/1nqnhppAcB9r5dOw3h6BxTxq9rogsnfm8qxdfXtozAAQOjBFHIfQGnnD7q9dTm4443c5Ric+kYYwlg6DgdGPSKvSiVFwo1KMo4ieLbFELye/eceH06ztyKyyWfD248aOeYS+en3/PjwOiVxaZx0OZx2j3VUuprJwttcXbNk3mqAWOxCI5VTmBpUTITkSl+iUShes76nnOq8kKvwEnu4hMiLuo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-08-20 15:26:35 [+0100], David Woodhouse wrote:
>=20
> So if you fix the might_sleep() and Paul comes through with the atomic
> SRCU thing, I no longer care *much*, but still think the whole thing
> deserves to die.

Okay. Let me look into it then. But "the whole thing deserves to die" is
limited to the kvm usage, not in the kernel?

> Going back to SRCU atomic (citing your mail in reverse order):
> > In
> >    https://lore.kernel.org/all/a94b75e8b9b1d2191f365c0f4275fd5082332df5=
=2Ecamel@infradead.org
> > there was a suggestion for "srcu: Add an ATOMIC reader flavor and a spi=
nning
> > synchronize_srcu_atomic()". This one had preempt_disable() in
> > srcu_read_lock_atomic(). This is bad as not only forbids to acquire any
> > sleeping locks (such as spinlock_t) but it also does not allow any
> > scheduling of any kind within this section.
>=20
> That was kind of the point :)=C2=A0
>=20
> My=C2=A0srcu_read_lock_atomic/synchronize_srcu_atomic() were born of the
> "need" to avoid scheduling in OOM (RT or no), but actually I think they
> survive even when that requirement goes away.=C2=A0Even with my
> try_synchronize_srcu() optimisation, we saw higher tail latencies when
> deferring to the workqueue, and Sean was very much in favour of
> eliminating those.
>=20
> So I think we do want synchronize_srcu_atomic() if Paul can find a way
> to give us that.
>=20
> To your point about preempt_disable() in srcu_read_lock_atomic() on the
> read side... I don't know if we *need* it to be like that. When I threw
> it together, I was thinking of it as a raw_spinlock, in the "must not
> sleep" mindset.
>=20
> In fact, as long as the splats are dealt with, it would probably be OK
> for it to be equivalent to a non-raw spinlock: disable preemption on
> non-RT, but not on RT. I think that's perfectly OK for us from the KVM
> point of view. But does heavily depend on how Paul wants to implement
> it, of course.

okay.

Sebastian

