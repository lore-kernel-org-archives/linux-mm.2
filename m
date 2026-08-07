Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9016C5AC67
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 00:05:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 872DC6B0088; Thu,  6 Aug 2026 20:05:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 824956B008A; Thu,  6 Aug 2026 20:05:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73A656B0092; Thu,  6 Aug 2026 20:05:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 43E9F6B0088
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:05:25 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 503EE1C083E
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:05:24 +0000 (UTC)
X-FDA: 85072528968.02.2C92C40
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8466C20008
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:05:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a2zpeh9B;
	spf=pass (imf31.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786061122;
	b=LVOHWr/qBb21jQcfROpOLPzDfK65CmwjxfMWPGKU/HgCm3LHsuzptax5CIUeuF+azf/EHM
	YgIE/GPNbKcMCCYssZ6gDCzeghP7HSJRxNHeIj2rk/Nf9cypSTSIv7Y6rjnHtsRoLUrfmQ
	NVWD0T84mhX1qBhT3ibnZkq9bgOBQK4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a2zpeh9B;
	spf=pass (imf31.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786061122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kdge44RFjCbdvrpeva3gnUDYQhMNVhu6QDL8c9EjZYI=;
	b=iNuNPeQVaTNrGTAjAGbCVY0OJ6+O4LfJPHs5PbjIWQ1hqoE6V3MyM4SxaWUA58TlzqRaD2
	EJtiTIty7aIECThvEr1P8I0moaD5emn0LSa9GERBHSm/FfoCIF2/uACiaAhZhkM2LCmXbf
	ik1CYyYyJowOEhoI7cmtFb+JRkp4Bmo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CC421600B0
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862761F00A3E
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786061121;
	bh=kdge44RFjCbdvrpeva3gnUDYQhMNVhu6QDL8c9EjZYI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=a2zpeh9BwOqG1YU62F1AiD6bp3V0nYM9pXRKxasyVpMTuocLPJ26o/qZ9LDPEZI7J
	 /uIReWYIShiHR7NdYJ0aqiijc0ZqPiMYCGfwgl61vvO13KxyrCpPbxGHl/iblx8jWi
	 g+EDu/Q3xj0zHGEaAKDTesN0/4dkmXNK21MWAy2CN6KGyK8EJNOga/a/i5E5027o56
	 vS9/4FLtRU7ZSJhhJ7MUEtwAAHmlSADJbWiFY9MF2Tvdp9IALaZ5kW3SCdRwLbjl6k
	 qCSp7bNaPsuYM29BTxo1beCQwaI5MTAyILU6HwRfqwgEcfaMHehK1buhMJjAUNyNoE
	 xQUK7LTDGFJGw==
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-69f7fa1c548so4381854a12.2
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 17:05:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpNAotKoScau/mcw30Xlfwl2trlcZhhGyVtPy56a5P6KeBt2aTMxWhzf1swilpOUZcAS/b1jxcHxA==@kvack.org
X-Gm-Message-State: AOJu0YzwtXAj4mSNOIVx0yUA4omm29sYbt+cWG7aufh1mUkVvdIhjduz
	iLCfpvePix5NeQmKXmQlbJDB8c+HllJUUID86oWQYI416vohjVawq16eIhh6lnoKbWm5Lhw+KhJ
	T+doEgv5+IKM/6QdkHCl838N4l8wI17A=
X-Received: by 2002:a17:907:e00f:20b0:c20:6eb0:ab31 with SMTP id
 a640c23a62f3a-c206eb0b4e1mr252852366b.21.1786061120400; Thu, 06 Aug 2026
 17:05:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-21-6f5729aa9832@google.com> <anJylMTl6GeM8OHx@google.com>
In-Reply-To: <anJylMTl6GeM8OHx@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 6 Aug 2026 17:05:07 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNOp_s1ivwpExTPYZ=iTyVhC0uxvc+Ew63kR-Nq3i6Vzw@mail.gmail.com>
X-Gm-Features: AUfX_myFHG0NH9j2R1azLACqElPJ6XZWeEmpYtYjpa4nPkbP1fqaPzfUIl3zA0A
Message-ID: <CAO9r8zNOp_s1ivwpExTPYZ=iTyVhC0uxvc+Ew63kR-Nq3i6Vzw@mail.gmail.com>
Subject: Re: [PATCH v3 21/26] mm/page_alloc: implement FREETYPE_UNMAPPED allocations
To: Brendan Jackman <jackmanb@google.com>
Cc: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, 
	rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 8466C20008
X-Stat-Signature: djb3x9faigp9p4mb44wf8h8rzg9i475e
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786061122-514796
X-HE-Meta: U2FsdGVkX19kYcGfW2PIYHyzLeoVJYCX7VFmepoco0zqfdqNPmB6O9WQ4aZHR5wQFJaeHDRz4E2wBW2freO4lDLKSE91S6nJsg/UWRlxmLIplXwDbzRpgvKIHx+Dx6g9+7p6e0U7OtpzeiX4VKSju+24dgXO7J4gDbjJXN1NLicKbemG4DPI6/bjzpZyZx0LkUeBMAnc7aboWWSaa1FA10YVSFw5vCJuy5zoJDgQCWCGP9teJU91CcktSgK9Erg7xj9fBtpyphN71SqOb5dCairEr3vuO0/SnYTMLhff58G12wvJ8IwY2LmdxE0uI2K+vUPzSHDlC1y/PVr/M6Gs5jlUBeIb94ErymjGfnfBCeeZ9HMFEUvQo/MDg+hvZ98+pKMo78tQZRlFMX9nX/wO/SZVVvyrcs9KL+SFhgFYRXFLHbHxdnmyqQuF9q78cZceDqOYZZrkzU5uO4VbJ4HX9hTG7mHsP3vE7uJYilvciomL6RMi4DZ/djjLIAnd+iqs+tKCYNnyby7fezeV0OYVYbVOs5TDWfiZJwazjB56964LdLsX8IlKdC3I1O8n1j/bQGM7a3xu7cKNp+65ddGmqJ4uC29VlGXYfmIpINQI7mVmY1yHHRmsoZieDupVT+J49vOEYbOHStKNoh0zfRoSi42yROKU9DvV9U944WuSC4cjRptKgn7funYP0edkrrrka3+ECzm/nwAjhtglG/s57LDPL3+jj28HYpsot5uECHMMrSFbSWQo5+mZUmoEsI+slBEc94KtjR/oRxMNrjUV7s5DFRAQEtKlEQSsaRu2e8OQnc+16k3QBCtevusVLCjiFvU2Oa35N1AcmbfRXQwTVp+XCNyP8pbxx1moNuEpJNT/TfpIse4akAc8vUd7Svy7RxRA27eosQO2NeguGDvnmBPIUpSU6nCjrhi9VWf2Y3HIWgC8opNJjX6mFDh1h2vIf7qmYHX5WAsZCGQ9HEV
 XOmdgpi4
 qnyy9MhyVWrQakWcBe4ASzo5pWhkJOSOc+esLPq3X9egsNO4SIDIFpPkZGPCGNZauzTmVPKVutVf2D4zBQIz+u1gdBaSWZoFWJp67iEid4gHAPs4KmVKzgmmVC38ZPkyMal1my/3eQURG1f/Jt+gdatSFB+LRKXml4a/S9j29U4MjPn21Ltr6a/T/QgAqil/bSkUF7Tg3YnGUOz9j11Y8Y5+Mv18hU4aWswt8w5b8MGnrOfkqm+1RMETCYTKUpvZNpWLF4w5kmBNJNIs1qEg7Dn8qc7OS5mxmxjPNgj7TAyxC3w43Rw7vCN82yBAJZsxmLKIUM5tMmI1zeV0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > There are some functional requirements for flipping a block:
> >
> >  - Unmapping requires a TLB shootdown, meaning IRQs must be enabled.
> >
> >  - Updating the pagetables might require allocating a pagetable to break
> >    down a huge page. This would deadlock if the zone lock was held.
>
> We also need to zero unmapped/sensitive pages before mapping them again,
> but seems like the current approach is to differ this to the caller,
> which makes sense.

Correction: we don't defer this to the caller. We zero the pageblocks
when we switch from unmapped to mapped.

> The only annoying part is that
> want_init_on_{free/alloc}() now silently skip the zeroing for those
> pages.
>
> We should document somewhere that the users of ALLOC_UNMAPPED are
> responsible for zeroing memory before freeing it?

This is still true in a way. want_init_on_alloc() is always satisfied
with the current scheme, but it's not a documented requirement.
want_init_on_free() is ignored for unmapped pages AFAICT, at least
until they are converted to mapped pages (if ever).

[..]

> > +     if (want_mapped) {
> > +             /* Exposing formerly-protected data; scrub it. */
> > +             clear_highpages_kasan_tagged(page, nr_pageblocks << pageblock_order);
>
> Shouldn't all unmapped memory be zeroed on free? If we solidify this
> assumption we can probably drop this here (and maybe replace it with an
> assertion)?

Also wrong, I assumed that AS_NO_DIRECT_MAP always zero the memory on
free but that's only when ALLOC_UNMAPPED is *not* used, so yeah this
is needed.

