Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70E01C624D0
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 19:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A8446B008C; Tue,  1 Sep 2026 15:12:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57F186B0092; Tue,  1 Sep 2026 15:12:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BDB66B0095; Tue,  1 Sep 2026 15:12:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 24A7A6B008C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:12:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AAD661C2151
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 19:12:55 +0000 (UTC)
X-FDA: 85166140710.17.60E0628
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf12.hostedemail.com (Postfix) with ESMTP id EC50C4000E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 19:12:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gE6rhD6c;
	spf=pass (imf12.hostedemail.com: domain of 3tCOXagYKCLMlXTgcVZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--seanjc.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3tCOXagYKCLMlXTgcVZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788289973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kt0LuE28XbF55ehOiA2DPZrjnmRa799DCvT54SE1CAI=;
	b=NQfAQHc+XDa3YQypmScipTQcJ5MYZi0VAwJhhlzrDLPt6qbPlHW/8Be7KDTApEj2DBRoEV
	IImT1ieWVUd5Eg8Yzeh0yvO1WDB8OcylWGAZ6VwT19GdKQpdB0qaIJbl/2yrYSpndUy6aL
	0qt6OzzuTDJwFci67ZQIjwcWJPV9sa4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788289973;
	b=eYWUvAXAOTaucPetAj/XjmssuXdqnMV+ha9FCy+HTuwRZbBaPFlSv1Zuq0UShh7nRHlIXZ
	Z8o+lGleeWogBOj22aNzMIHsMm9geFeG7gHb/32Ps6F1X/TFa5bgue63KvB1J3APcxMmre
	834H63+YimqECjTs5rTt4pQ+nm/0FAo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gE6rhD6c;
	spf=pass (imf12.hostedemail.com: domain of 3tCOXagYKCLMlXTgcVZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--seanjc.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3tCOXagYKCLMlXTgcVZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3823dcc1647so202411a91.3
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 12:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788289973; x=1788894773; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Kt0LuE28XbF55ehOiA2DPZrjnmRa799DCvT54SE1CAI=;
        b=gE6rhD6cFHqZPFb7xu8uRJFEjfvxLEEd6du9wizTfrgE25SjOh05wA245vU4tLspyH
         d6zABgw8ESg83UrvyWxkT6nHPI0IEPlKI/htMBuuX7RINymO3QK5LahTVDh8DSZAfOgY
         DUa0i6HXdiaOMrj5i+PBWxtfosfDRRJ/6Xr0WAGksCotweQ7t/D3r1gLTAhTaibrZR3W
         pai9pXPehdbQie9RH0FPqP47zhBtZzYQdSQ6tIw6hNLiHB+xzTAH2gfKr9GCrwfzFJLQ
         ydDkAcFivr703yz2WquIgxOB7RonorGLyBbMlxRiAdP7vHutkMVixmLNrzqExsRs8RwT
         fDRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788289973; x=1788894773;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kt0LuE28XbF55ehOiA2DPZrjnmRa799DCvT54SE1CAI=;
        b=BALx+mjCpZ9MRlyfEvhHPl+45PHhb/m2w7VIZ5MYQwHcRbUEqkUEa0kKp5ybLBD4bu
         IlF/apY9WlWVrJz4X0e9CJxvCMa4x2tNBxZmkE3OQ4VIVAb7OkKTGgLJPHp5VMqJA2xU
         UY1+M7e83uFn0pjsAchrGYBNkdW1NbMvvmBFrU5UCHoOQzoGoi1SzVEp3vbW5qhAZxH1
         HF4ILQfY9h4LrhukBpc51SY3T9bDf//j77xKOo9557uffU/sT3RMAzozAikXjqoyiMm4
         GukY43lS07L8CKzWj7dF2FgqFoTEyibNas00OfopYVYpnFpmVJ8hFZXBrfANSjK8/kuU
         MPpQ==
X-Forwarded-Encrypted: i=1; AKwUvBzZ7lT+YFcgSmM8hnmK3bY15IHu9B4j1BTbgAIDGnJy4pOKxhRGZ5UU/oRwpEBhf3IscyaLGwjU/A==@kvack.org
X-Gm-Message-State: AFuF++meHcZJDVQ8I+wMxgwrxD1ouaUriJyGx7xMnHyIuAfZGkbDUdMo
	j/Us7nms6gAwdo1EOgxXTJ7Huj41gqFInXS8CVnm4sFYmTY6SzNs172xjxTME6P0ba6q+fs++/c
	yXfl4hg==
X-Received: from pjtn13.prod.google.com ([2002:a17:90a:c68d:b0:39a:e7d1:b083])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2d06:b0:38e:5964:97a8
 with SMTP id 98e67ed59e1d1-39ae83ec5demr364047a91.16.1788289972383; Tue, 01
 Sep 2026 12:12:52 -0700 (PDT)
Date: Tue, 1 Sep 2026 12:12:51 -0700
In-Reply-To: <8cd4aa65b1b499d4c614aa4cba445b6aeb89acf7.camel@infradead.org>
Mime-Version: 1.0
References: <333c4cdb-8f34-4e3f-a47f-961f47e089a0@paulmck-laptop>
 <11dcf5a87125451897982f728c1f65a5151987e4.camel@infradead.org>
 <69567965-48fd-48c5-abb6-0699d7f5bd16@paulmck-laptop> <124af87fb49c267eeb26b8b4d952b9b1a5b3fb68.camel@infradead.org>
 <9427a8e0-3ba6-4f31-a35d-54429bd7e071@paulmck-laptop> <3d0463b6099d4fcde9a025a2f9e231d75303b61c.camel@infradead.org>
 <b0be19e9-b0ae-48de-bef6-d905ee007c8a@paulmck-laptop> <c39bda52f4c1573193aed39246f0d705755143fe.camel@infradead.org>
 <90d91673-a912-439f-98ee-e43285294486@paulmck-laptop> <8cd4aa65b1b499d4c614aa4cba445b6aeb89acf7.camel@infradead.org>
Message-ID: <apcjs83XSU4Eb9hm@google.com>
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: paulmck@kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, Michal Hocko <mhocko@suse.com>, 
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
X-Stat-Signature: sdyatao6d8hhyii9uezhfasqgo7e7nmu
X-Rspamd-Queue-Id: EC50C4000E
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788289973-116760
X-HE-Meta: U2FsdGVkX18w6+KbXlmLUmQLu9XXPH9aHccI1FAW+01Cf5w0iKLvbvKdy5sIIWJLu9e7pgtJAQKG01JQSK5JsdH46depZ3Y3pyXIjh0PGDC7NG3bziqQYljwxUEYg3YxWNQvYZ7mDgx9dsfx3AAKuJwbX4uIOL1/iB9o2NMOtwJQ6aXrdHueqqKSgxr3cernQsaC/vv0t8Fu3PKoi1jQUmPkvlN1eRzKhPFnU1qkx29ZkEznLuz+8VbfoXVm0PtUfdPEzMdYnKuBtXTAxWfiVcxGRn8JN6s4eBTAZL0w9+AQLGnKILx0/MtBqhwj3R5Gm0o+9k2IPXvShC6n+bDgh19x5h4EKzkkc1mL4mokg2PT3pvZGhrusMz6X7A2P/1bpfZ1MWeAnc97asSJiVYZtQV1gVwaO0w2bRGAVGwze/EzkaT/0uEHG4Q3KunfIMlvkxkKqONSSJrCRzrGLtR8N1OgFM2Fybs3+v5fIY9/2xeJBVSrDMb8EgWyUldoWCeGPdgdFXcGZHSdA7nC0/MnMB+a1wCVc7QG2QJa64ukBj/lNIHsPs6uIgmrYdfP2OV56j8kwPP3ze5m1+bKa6Rmrrgy9tabccWR0te3RecJRmVh37DMB0+aAiQjB0Rn+OoFCh9BRBnXkOxwYSby72m4azN/oxveyshsl8iUt5V28cpcJkF20w4xlL0Z/+EPgm0KGHWO63vfEjURjp8shbYS94I5A/ZXOVhbUN6fMsR+5YMmOUcxX1Lv8kjMRzynTEwC90LYEOjrcLfkY6l5cdaZ2WvukD/ibyzmu0zIkpqrxOIbtvNn0Ducm0ZDB+aKbH8rkNYedZm0M55I/Nzd03UN07pIWaJ5xx/zy4v3fUZTSfkvCfWLqhF6hDv+74cVyQEX/wgIugqnbwnrHjyUHHlRmcevXeTfswTIzjiAEAChohN3DzhM4svaZMWGtS6VRtBOIVQ2/XRWYzA/9M0q2gT
 pFWMT/KK
 1gfPWBqdSDEVGZo2RlwyGwPMM3y/9mCYLG5XKFrbZu/3HQ1Q2HvEW5RZ9SVlUVMxBfK2eLAvJsPcTNfUyzns72fTpQjKa2IJYKGDlrLl6csTSlBbhnvEJOxZP5uPA0blIPrDrLhBFItlRak1pD98zEGCdItV4uwHuyeKlDQ1FVviRyUMdNIIVBB5JYwEbctsE3godRTZvTNewVeUYbxxFGkYWOD8LofZx4ItxnnD4VKAUAIRU1Y3kbUX8vERVWL+sUZqzcLIpBScRXz1GLT1TKqfRsdHjp0HsODSsVMKJqyxHa/WZUFXWJKs81irujnyiCWQSL6hwPywKqq/av01U6eavqDVsU5Iu8rgFyXEvB/X9fwFoUeGUst+QZ8oe4uv7/4iZT0wQxrD9R+q1W4/bzOZJ1G9LKlIf/nNNdjOm5TmvEOA+4CoinhNKLk4sBWPTjfuNifWrf2lCHyaTBslCnX3NxYmLToXkufqee+dwrfEWRXS7a0fkrftwnq3a1FubJshmbN78gJqDHnLPGrHwQrH2okSFJ++qVsYEPDN5J6DduNQB+fbA/drDaqvzWMCVC7b6NTCGHLX1ZxsY4WBM/9e6fT3F2nDpbi4gGVprdm6LceaEWyCDYPd1G+nH+vLj5JEPrYywGleTC5nfJU9qQVCuYJyD4wpgAm4nJhq4ljrXs0riEMS3dDZw4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026, David Woodhouse wrote:
> On Mon, 2026-08-31 at 17:58 -0700, Paul E. McKenney wrote:
> > On Fri, Aug 28, 2026 at 12:25:01AM +0100, David Woodhouse wrote:
> >=20
> >=20
> > > =C2=A0 * 23f10e07aba3 srcu: Add try_synchronize_srcu() for callers wh=
ich can prove readers absent
> >=20
> > I do not intend to provide a separate API for this given the possibilit=
y
> > of indefinite postponement.
>=20
> Makes sense. In that case, calling it internally from the 'right'
> places becomes important, as the callers who care can't do so for
> themselves.
>=20
> We discussed the fact that synchronize_srcu_expedited() will also want
> to use the same fast path.
>=20
> I'm also looking back to Sean's call_srcu_expedited() patch from March:
> https://lore.kernel.org/all/20260309193059.2244645-1-seanjc@google.com/
>=20
>=20
> | Due to differences in how VMMs manage guest devices, and in the
> | architecture being emulated by userspace, some updates trigger call_src=
u()
> | with concurrent readers (i.e. while the VM is active), while others occ=
ur
> | without readers, e.g. when configuring devices during a pre-boot setup.
> | For the later case (no concurrent readers), using the vanilla call_srcu=
()
> | is problematic, as it can kick off a normal grace period (totally fine =
for
> | freeing the object) and effectively transfer the non-expedited grace pe=
riod
> | to the upcoming synchronize_srcu_expedited().
>=20
> So the offending path uses call_srcu() and triggers a normal GP, while
> the victim calls synchronize_srcu_expedited() and gets stuck behind
> that non-expedited GP.
>=20
> Sean, if the victim is the "no concurrent readers" code path, as you
> said above, do you think the fast path in the victim should suffice,
> without the cost of an expedited GP for every bus registration?

IIUC, you're asking if being able to use try_synchronize_srcu() for the fas=
t/happy
of synchronize_srcu_expedited() (i.e. for kvm_swap_active_memslots()()), ev=
en if
there's an in-flight GP, would suffice for a fix of the regression introduc=
ed by
commit 7d9a0273c459 ("KVM: Avoid synchronize_srcu() in kvm_io_bus_register_=
dev()").

If my understanding is correct, then yes, that should work, and presumably =
would
be a notable improvement overall.

