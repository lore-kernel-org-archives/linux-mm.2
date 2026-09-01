Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57BCAC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 22:51:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C2AF6B008C; Tue,  1 Sep 2026 18:51:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 173D76B0092; Tue,  1 Sep 2026 18:51:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0628A6B0095; Tue,  1 Sep 2026 18:51:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C99126B008C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:51:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4522812050F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 22:51:09 +0000 (UTC)
X-FDA: 85166690658.27.4CEEC68
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8000C120004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 22:51:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sg+5E41n;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 32VaXagYKCEAugcpleiqqing.eqonkpwz-oomxcem.qti@flex--seanjc.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=32VaXagYKCEAugcpleiqqing.eqonkpwz-oomxcem.qti@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788303067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CyjsuaiM3cxUtm6fL7D4dZzUePgQ+dg4iTlfcvKm+Nk=;
	b=uNhzb7944c1BGvrQJD0Xq/iFfaB+Ds0yckyrDCdcGFhmBvkZAGa3KWdHssnPOPPZ00lnjX
	ukIyhulchflKUCN8MorkLDGDTZimp19Iqv3cIsFMmvSx8zHrhB31nnb7eg7TTAlyt6Bx4O
	3cMYdmJ9TkVEX2uxVAKYU9sd5RTxEho=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sg+5E41n;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 32VaXagYKCEAugcpleiqqing.eqonkpwz-oomxcem.qti@flex--seanjc.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=32VaXagYKCEAugcpleiqqing.eqonkpwz-oomxcem.qti@flex--seanjc.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788303067;
	b=kyESs4BIbOHYeI4POpMai3ZZk4KGD4g+agtVJFTVuikJrPahChwj3Lg+rr92lux7wffDmE
	9NmZ75xKVCb8WEw8D1a6C3iSTeAsfJM+n9dUm8BxxiCWdOHwe4fVNegZs1c4Fs3pqepdMt
	i3GhpLfQs+ojfXwYzL4W7Rxz0c3ciLg=
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cbee6bb8408so524109a12.3
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 15:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788303066; x=1788907866; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=CyjsuaiM3cxUtm6fL7D4dZzUePgQ+dg4iTlfcvKm+Nk=;
        b=sg+5E41n5SoxhHIQdY/iX2YwXGWY0xTEfOAF2r06NlPY/8aMKvEvOYW7GdkAmrXM7u
         GTyl/7sEL8esqhVO7tnxNT95/0y0V2MJgkvOIflEzs+3gI1U3/610+SB1MD/gcWj9XlL
         8HCU4D8it95pPy5iY+yKq+OGg8z3G9wjRGtcsTFeao3Q/UMQtPetuY4iBcq3/3kFw+JE
         Hp8OXAAWbJCzdyfAsDs3bQ2hHJJVLo+pnPHD7ZWmjCm+sWtQ+dwSgkvjLS6pNVt5DKEm
         pbtALD3md1u1earo9UUVD/hz4ifL0asJUJb0WhOtIX0IO8NFoK6gRavg7NJ9nQXQhP9W
         k4mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788303066; x=1788907866;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CyjsuaiM3cxUtm6fL7D4dZzUePgQ+dg4iTlfcvKm+Nk=;
        b=mpDg9YSngkqHTxNYu8s0Ihe9mHwBPyNiEsL5xhRiSmKFUKvy9ZwTDQGA1ysh8kNpeB
         FQ87lDzNzhBXjJSsAu3KTU0AZ0BfX/mvDWej+S6uex+bt0E+WA/j6+BHwIGp2DODXkw7
         1g9t9j4EQZOxM25k7V17rh7Xe/pbS3acbJBUTxawjIkFaC57gRaWcTL27NfByILIRVLI
         b/tuOXqdu4VoFQbMphNFttQ+cEB//lrRJjaIRHzU8fyIkNM+K+BWoWjlzv5A6qG0Y7FJ
         zOMnvc1WowY6s9waNQY71WENtGluEU7FgmoZ1t54kzPKgEIJChQaGH2I9RSB/tGXq02R
         9k9g==
X-Forwarded-Encrypted: i=1; AKwUvBw+TgnSy2qrUc/2BEJjuHzjdPjYXbddZPFUGptJjJZAQrX9uytSgOLYi3rNLCMVAduDwh2qB5/H2Q==@kvack.org
X-Gm-Message-State: AFuF++mQzkd/rP27Jd0Ucy+uvjWkp+XB4ct8udPM4qzHBcXjj9b3SkXY
	tC7aKav8VPgPJ+Qhvj0QeSSh0DHQEKXPERDE165ddmsPzIlK0sgukOqol+wz8c2RAXBhlNz4aRi
	Gdjx7OA==
X-Received: from plhd17.prod.google.com ([2002:a17:903:2311:b0:2d6:f308:c74a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:b87:b0:2d8:d4d0:792f
 with SMTP id d9443c01a7336-2daec7571c1mr7978855ad.19.1788303065982; Tue, 01
 Sep 2026 15:51:05 -0700 (PDT)
Date: Tue, 1 Sep 2026 15:51:05 -0700
In-Reply-To: <e3197a0a-e167-4ea1-bbde-9c7f11f42198@paulmck-laptop>
Mime-Version: 1.0
References: <69567965-48fd-48c5-abb6-0699d7f5bd16@paulmck-laptop>
 <124af87fb49c267eeb26b8b4d952b9b1a5b3fb68.camel@infradead.org>
 <9427a8e0-3ba6-4f31-a35d-54429bd7e071@paulmck-laptop> <3d0463b6099d4fcde9a025a2f9e231d75303b61c.camel@infradead.org>
 <b0be19e9-b0ae-48de-bef6-d905ee007c8a@paulmck-laptop> <c39bda52f4c1573193aed39246f0d705755143fe.camel@infradead.org>
 <90d91673-a912-439f-98ee-e43285294486@paulmck-laptop> <8cd4aa65b1b499d4c614aa4cba445b6aeb89acf7.camel@infradead.org>
 <apcjs83XSU4Eb9hm@google.com> <e3197a0a-e167-4ea1-bbde-9c7f11f42198@paulmck-laptop>
Message-ID: <apdW2edsT_ZKfuUR@google.com>
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
From: Sean Christopherson <seanjc@google.com>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, Michal Hocko <mhocko@suse.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Simona Vetter <simona.vetter@ffwll.ch>, 
	Jerome Glisse <jglisse@redhat.com>, Christian Koenig <christian.koenig@amd.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org, kvm@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 8gx975ia1s6z38oofxbzsqcnpufc94ic
X-Rspamd-Queue-Id: 8000C120004
X-HE-Tag: 1788303067-234415
X-HE-Meta: U2FsdGVkX18YN9PgYfTs3gHGpU3B3oIdI8hGRHZVDbV3u91wIML06F59NT/xOH7jhnquRsojjcBRT1aL2e/W+kbPkwYaNedRo7DzTO21IBMCLORybq3rWaCxwgR6A5lmhpbvY0opkcvJ4Vd0GYWOkqgXeEc1xtueZLMdiyYvEgfjNk7vvK3qqmVn+aFHGiUkL1CVHX2JD082iJrvBslE/voaDvPPCQxNGZfU61UD9fsY22G5oXj3wxJN8H81GT2YDoxe0+3sf2d6X5H04ljBXgHU7usYkP2xPlpC3QOWJSpu3fcCoNXFI8cC8PFfdjoP3xsKBGizsJA7rTq7SR/zAci/EuChMvVBA2KTYf4P5WD8nfmlmiqvM0izvK1Z4g6meGUmLTVcA4fgWA+VMLzq+NXH0pIUpxAYuRulv/VIx5vgU4wCNxSHpN6y2ZyhGlfCp9kOEoFbCg1mrGfhc5nENRwFkO1Du1whHLz2KgOJPz3u13xARij4Qow/mFzmM/uvvYIudZcZAbq/v5YQaC76UD7olyp0RwodGvYETeT85HhFhPltKlIevfyiT0gd17FxC1R+Rrt+zgiBkdyIhHkB4/WH9Clo1MSzUp+YJWfTCn1lKZQHMxHpQfy9RUPQIZJ2+tMiYDFJ/eoEoQ3QK8JakVA3LxjymP9oFwdzH9LUlSlbCJJDLs/1V2HWU/X1kb6sWZR7Hov36l8ZJq/JDMhcRnn4OFK0xuHWjDd3S3UpBCZNTYmK0hDJwwgi6PUXe5ImcLSaqGMWaI39UvJNECKaq9XNKOIW6rgV0VdAj7zc56E1DU/uskDkzNE7tdbeIS/c1s5M+XMkoyqADqkkCsQ/E+YhuIPBgR0c4o5nd6pa73GD4LwnjgBYyZvpvkTrmEGtvEn60NSj7UHEuHRmEzq5/kLLZw9dHkOaTJDTOmLkzK5ZctlWhN3r3ddURds+EtEcr7xzvuBqmkBwQunnY7D
 ECJ2uMxh
 LEA4X0x0tZf8NIbivwLGnmEARAOxS+cbEDJNNJwife0W+GFH9aNirIDj4jyqKiPM/830VYMzMCKfKqNzPKfp3hZM2Y7mvRUbhmMRDAS0wComnOBGkgSPUPkQ6AfZTNp17W4VnKcp26gbc+DANESBZcYdjerj+Dm0Wsp0KbxJ5m0uVlhhhi/iVNBjetVh78KjMUDq8RNI4fWuAA72Ze2iWOklhuyXJMXhZ5frYRalEmmIef4efv3mNOcFMn7ooc7vtG41+vKbChJu4xJmvhhmcEO3gin7fPgLe+z0yAsjIFbpbAtPm16Ep3/8OwbLIVeHQTcnMUq4VqswoVGNnkwWrlJX9/k6Jryf5YxoVcXfOZn3kV0u6xBzA5tD/3vw14Q3gpeIfS3c7ndxeNNaihvew8HdB6xZdcflqbeYNqo/B3YJinmQfIoT5u0rWBgA6NQXIJwTuogbIdL8naGPm1XS+6XoOrnbVMhEhIEbTTTwBiu0tWZzy01pld5uCld5eT9+H/fiXkRHpi6J7/9bbuxab4zA9cIeKFepa41DvIEh+A5kKj+E9DgURKnzPf2c9Blkcm482N+nhNvxAdE/e9a1JXtS13NepyMuPsYtvHAt2kMrqZz7jYVCv+ghlvQQmplsvCCUfM2zQsNzIpqFxagAQwUcDJBXuyvuCPpPviDurJh2gDsQut1J9QwU8CQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026, Paul E. McKenney wrote:
> On Tue, Sep 01, 2026 at 12:12:51PM -0700, Sean Christopherson wrote:
> > On Tue, Sep 01, 2026, David Woodhouse wrote:
> > > On Mon, 2026-08-31 at 17:58 -0700, Paul E. McKenney wrote:
> > > > On Fri, Aug 28, 2026 at 12:25:01AM +0100, David Woodhouse wrote:
> > > >=20
> > > >=20
> > > > > =C2=A0 * 23f10e07aba3 srcu: Add try_synchronize_srcu() for caller=
s which can prove readers absent
> > > >=20
> > > > I do not intend to provide a separate API for this given the possib=
ility
> > > > of indefinite postponement.
> > >=20
> > > Makes sense. In that case, calling it internally from the 'right'
> > > places becomes important, as the callers who care can't do so for
> > > themselves.
> > >=20
> > > We discussed the fact that synchronize_srcu_expedited() will also wan=
t
> > > to use the same fast path.
> > >=20
> > > I'm also looking back to Sean's call_srcu_expedited() patch from Marc=
h:
> > > https://lore.kernel.org/all/20260309193059.2244645-1-seanjc@google.co=
m/
> > >=20
> > >=20
> > > | Due to differences in how VMMs manage guest devices, and in the
> > > | architecture being emulated by userspace, some updates trigger call=
_srcu()
> > > | with concurrent readers (i.e. while the VM is active), while others=
 occur
> > > | without readers, e.g. when configuring devices during a pre-boot se=
tup.
> > > | For the later case (no concurrent readers), using the vanilla call_=
srcu()
> > > | is problematic, as it can kick off a normal grace period (totally f=
ine for
> > > | freeing the object) and effectively transfer the non-expedited grac=
e period
> > > | to the upcoming synchronize_srcu_expedited().
> > >=20
> > > So the offending path uses call_srcu() and triggers a normal GP, whil=
e
> > > the victim calls synchronize_srcu_expedited() and gets stuck behind
> > > that non-expedited GP.
> > >=20
> > > Sean, if the victim is the "no concurrent readers" code path, as you
> > > said above, do you think the fast path in the victim should suffice,
> > > without the cost of an expedited GP for every bus registration?
> >=20
> > IIUC, you're asking if being able to use try_synchronize_srcu() for the=
 fast/happy
> > of synchronize_srcu_expedited() (i.e. for kvm_swap_active_memslots()())=
, even if
> > there's an in-flight GP, would suffice for a fix of the regression intr=
oduced by
> > commit 7d9a0273c459 ("KVM: Avoid synchronize_srcu() in kvm_io_bus_regis=
ter_dev()").
> >=20
> > If my understanding is correct, then yes, that should work, and presuma=
bly would
> > be a notable improvement overall.
>=20
> Then we could abandon synchronize_rcu_atomic()?  That would not be a
> bad thing from my perspective.
>=20
> Just to be sure, please note that synchronize_rcu_expedited() can and
> sometimes does sleep in order to avoid odd corner cases that could
> otherwise pointlessly monopolize a CPU.

I think one (or both) of us is confused.  I thought David was asking if we =
could
avoiding adding call_srcu_expedited(), because the proposed try_synchronize=
_srcu()
would fix a regression related to KVM's use of synchronize_srcu_expedited()=
.

I don't think that has anything to do with non-sleepable RCU?  Or is there =
a
separate discussion and/or implicitations I don't understand?

