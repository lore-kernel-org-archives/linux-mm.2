Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A88EEE6FE51
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 23:23:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 164476B0005; Tue, 23 Dec 2025 18:23:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 113196B0089; Tue, 23 Dec 2025 18:23:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 011286B008A; Tue, 23 Dec 2025 18:23:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E23FB6B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 18:23:38 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7914F13B0B6
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 23:23:38 +0000 (UTC)
X-FDA: 84252314916.22.2538DB5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id F2EA120003
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 23:23:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RpvZ8nvq;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of loberman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=loberman@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766532216; a=rsa-sha256;
	cv=none;
	b=3pdwQR+cA+WAZcbxMpy4HD8oyGpByyiCz8LI6o0AW01uPlC8go8IjtcmYzR/xWD3U+acIo
	41kWD3kcOA8TKm3IsjBdkMHUOwjSAYFsOrmUyQ1nWTRvjP7SXxNsIU2fheWOsF/SOe4Ph4
	QUasSVL5iLZsqkOS03eBUuDeg13xBDE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RpvZ8nvq;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of loberman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=loberman@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766532216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j74pz2xp86Own0WTdw5XNAA+fhHwwXAxbc9yYGTvLvM=;
	b=FmulnVdaqZk0rauojTARTkprMp8VBQrJBw5rw9LXnw7sND/EVe9U8jVEeG9z+WpO+vYL47
	MOdKZgKMmbdaf2odDnSMDFqr3c0oG2GjM9uJzON71SPyER24D4vIagNAX2eHMypJg5RoZ9
	uI+p0EwJ/jNZVMyfLpnh6qbYNQCcpd8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766532215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j74pz2xp86Own0WTdw5XNAA+fhHwwXAxbc9yYGTvLvM=;
	b=RpvZ8nvq5eWWBljMZNsrCNVMLV7a9KU3lr1k6tIUehU8K+q4O4OB9AXy5DEbqk3zSRu+BK
	m78Wt6MdR1WICad8fz/EzIMzl0hpR+WVtPJnybwQHt2xGagHvcWBumWOGdJYbqtMVWcasy
	hSgU5Xb9wjTS4qT9gVMwos2qM2YNy8M=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-GwDte3rENfCGHnpuJ2fMjA-1; Tue, 23 Dec 2025 18:23:34 -0500
X-MC-Unique: GwDte3rENfCGHnpuJ2fMjA-1
X-Mimecast-MFC-AGG-ID: GwDte3rENfCGHnpuJ2fMjA_1766532214
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4ee21a0d326so30103601cf.3
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 15:23:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766532213; x=1767137013;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j74pz2xp86Own0WTdw5XNAA+fhHwwXAxbc9yYGTvLvM=;
        b=Dbbf+FhZ3pqcMrDjrWRUoP5LcND1BsRK3BxTstNnhKyrGWaO3fIjpPqCmu/9x1Yb4g
         fHCYVFBxxXD00DR9x1xdFVe4h1B40dnpWYTVPxjJXKuP06AAjbC786N8JnkJkOhUslnI
         nRFeXv68V+qZtGecvFA1SEB61IaW3erstbD11mE3O7uABiM0M3tROFGZ/mXcbwBiMCYD
         tpccsiixKKK3e4vxg6CYFeTYrp2nNklR6Yw5D9KAyQKdeRaVa319Z1P/zmZuq0JzIsyy
         EUndxwvn+cMj+r2cyxGhYuJeNLUS4B2lAhiJ86LhnZJMiI0ERgdq93GpzP97gG6EDUq/
         ttMA==
X-Forwarded-Encrypted: i=1; AJvYcCU1boY3N5AeuT4053M1RS5KKtfghcFaBPnTX55TnFdNljDaqHeaIzylAnmVk9e9KuS94JPcJrHx7w==@kvack.org
X-Gm-Message-State: AOJu0YwR212EQwZg4GLBOSpjkdJWyuCNLUbTC9l0EYo+3LzycB1EmGmi
	4hkrMqxeSq39wwPgL7XbgR0RYMkChwdFOYgAYb7X3BjZxsy1pBBsC4C38H45X3Gu+KVJNKz2vNg
	tSl/ndTF7nR7d1qS3R1q3yoCFFRfiQu//7LUn2CfpiW/OIs5BjHGA
X-Gm-Gg: AY/fxX6s8yasg2755Xfg7AheNvifNWq6nRtE7lJz/32mXmXm3Nw7CglFd5pPV9+ROUV
	KjBv9Sbc+BqL6syv4Rob0Rqe1tYHrjAK64IeyUe0lTntmS9VJAKs9pyKmE5+2kZ42sJiAopGKhj
	bDfUndq+agJzk0SJtolYuvACK3wB+/BvaeRx9HfzPiyvlcor4V+nPMxRneT2tC+e0GJSF+K2KPC
	conAKzdgAgWVV4lJpsgaY8pVnTkOyqMYqtp+HZ6YiXbBxVGNXlRmsESzr8hj0YSk4tRAnH8yRJf
	woEg/9EegUaS54kaLXWVvdUqludT/sZKJMFKpynyZcFGQyq839DqlgZUwHVSEugCU8nbwipAzRq
	sUy+CAxA9MbmWu5SWyTTorCuqLgILFRwYDR/s7PNBr7A76m1GfMipIfqwLF4F
X-Received: by 2002:a05:622a:1f13:b0:4ed:67bc:50de with SMTP id d75a77b69052e-4f4abd1c387mr231162821cf.24.1766532213584;
        Tue, 23 Dec 2025 15:23:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHAdHI2wD3ND1t7fPXe6qFtFHAW/7/HH1wOn3/aC4okrHJxh5+0pzdgAVbVs+yHegTNouqegw==
X-Received: by 2002:a05:622a:1f13:b0:4ed:67bc:50de with SMTP id d75a77b69052e-4f4abd1c387mr231162611cf.24.1766532213196;
        Tue, 23 Dec 2025 15:23:33 -0800 (PST)
Received: from ?IPv6:2600:6c64:4e7f:603b:1cec:a44a:989a:9980? ([2600:6c64:4e7f:603b:1cec:a44a:989a:9980])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f4ac66865asm115070091cf.31.2025.12.23.15.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 15:23:31 -0800 (PST)
Message-ID: <11ab64528debf3b3515e863610fc8b679a39189c.camel@redhat.com>
Subject: Re: [PATCH RESEND v3 0/4] mm/hugetlb: fixes for PMD table sharing
 (incl. using mmu_gather)
From: Laurence Oberman <loberman@redhat.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, 
	linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, linux-mm@kvack.org, Will Deacon
 <will@kernel.org>,  "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Andrew
 Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@gmail.com>,  Peter
 Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>, Muchun Song
 <muchun.song@linux.dev>,  Oscar Salvador <osalvador@suse.de>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes	
 <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn	
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Rik van Riel	
 <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, Prakash Sangappa	
 <prakash.sangappa@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
Date: Tue, 23 Dec 2025 18:23:30 -0500
In-Reply-To: <20251223214037.580860-1-david@kernel.org>
References: <20251223214037.580860-1-david@kernel.org>
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43)
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: h6YF_eWyLH33P492_E1X3rOzvBLVC1k6EmrYHhIqnD0_1766532214
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F2EA120003
X-Stat-Signature: 8t6qyxhswhf8gu9kn1y8fwadn5df4kym
X-HE-Tag: 1766532215-736659
X-HE-Meta: U2FsdGVkX18HMY+nLkyA2PR2DtfUdZZokC6xIKujv+ZNyrtSNZphQ3JCrALhXNuuOCzqF8v/4fqhLwIOEXUaMocArtz3okCRO+q0DxeEDHTX2z/ozGYX3u6fd4uywZ/EOsclGNW5/zLvjhB3EhZHnC7o1S+MDztSGErJUqgkPJfauMAX6v64SpJKwxPXgWUEXQyb/SqH1bpwCn1ot8DPCFGw59EVwgUF8Ir/A3r60WcW9t7ZPhgD6lnDB22r2URDmZLs2A0X40vZcvrRXnwPqKaXidFhNer4oFbMTgNbn10fw00uI4IHrD5bzz2Bq60i52dNtKMqlndyqM5bbNWNLT6WOU+9LMAO4CelLrveZq0kL1Nos5587o1H1ZTSon26SVyWYaTiWA5iL9zxeu1qRb/2pBJAPQsr683agBPcZj3cC8fU4JPzvBcqf7DWKPw4+76/HLLrp6qmxHxhX85fg3RxJZwwc/yfu6cn/+x1g57WP5FeRFIMwP37xSAdDD3F0Dg0ZazMZWgDwlUfGEVNm6lbNnKXkssVApbgJ7MOZVakKEN6JAAZP4lwbdunnWxFsX0if91IuI1L6i2LOdgIbLjKGzWD6mufcGy06H7RVCbOIe3ECR3i76Z3qHS3t72wiZ1/g8gLDxiHf5iA0N6KhLQg0wFJk5X6KsKPEXaP03YpAL6T29MepVIIGZ5TKbgp9uKoIujlq3FT0AIufmHMoNMd/9dYJnUtxlyCfDkcIEAuzwGegyezjjtqy77cVbX4eR1CHU7Ih6uEPgib0HUNukYmcNxg9/wkhajD4tzkUNWn6kB4cF6yvZJo88w/fW4J70mAwM2F9jFYX9n9ASoJ+E/TBBHCsZFAOPx7FVka9vqJkb/Z+0j52Ve1Xy5M1IXCIVLR1oX3KXoq2skK93bUI/VdItMyJ+mlMTmMPlhumyyH+L4opPZb3iOtUvudATYut67mDG273Anp7ola77H
 xuTB7l0H
 8hQV8rbL2O4SYPKye7sPxzaAREycxdESSpl2CzNlN1z02MeWUyvjmIYLAz8ZEy/nHoXDhuspk+dmtVAlzRCH7OJqycNu1j6lutz8n6VjCtM1zneekx3LaYrA5kxohaurvlvq9DuoVhGXUHPCDItLg/nZS5Czcic5ZdPpTVHUoj9Qw0ONe6TUCWTlw0jB0wwyNGqnENwj0/BcZ8Wr0l+eMLlgBa25CZBfB24tMsS0J0VALGDeZk5JBBcy0Ukep6zk+DLKQDZJczkuLJTx8oB9fOLwPiKarwEHL7ACJJb9D/dUBN1qQgZ6tU7I9ov3Oq2eIEvqR/XeF88dbZjjqiracbEzuaROEKKtpYYIm97y7UxvrYOSul5B1YA/ETFBqPvUCqcDqfaxQ8hv26cuIchb3aAj3leAbta3SXwchzDmSJMXqEr2DFCna0s5SrIcgR1f3RcEmykP0FyjeTtg8VB+85GDsfTBQtoN7dokY+YnKMoyKbD9sB2OKXhTS/DP7lPmxDddam13X28FGOndIbmpL/hjCDU6+Jvu6I8TB5rw3XKmAmezZGlsLUIBmwk0drD8OAg+d8yXp/PLAYq8NDTQHubcN769+P8BrgIpF3jJ+KKnZtI1kalufyILTJ9fqUIeIfkRCdtG+kbwT0VehoWGTgzYPaTxsacE/1E6C8F8DTTqog9I5qjryvVwLeJcnXlmOe2upz0DkLLGG3ZxLmgEKGPR1JuauJgjPN2TmIey1BT1UwVv6YbjTOqLvi+9aiiJX1Gs2q1a7j+BVRYhKXHkY9nriFD5+nXhyvDnPLWEvyBn1iWMwIv/Ksw829i4/wI4tJDYxmfeMLj1LL1BW/Zy7YQOj0Ftt9ZpuCBcpdWl2Ks/N8s8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2025-12-23 at 22:40 +0100, David Hildenbrand (Red Hat) wrote:
> One functional fix, one performance regression fix, and two related
> comment fixes.
>=20
> I cleaned up my prototype I recently shared [1] for the performance
> fix,
> deferring most of the cleanups I had in the prototype to a later
> point.
> While doing that I identified the other things.
>=20
> The goal of this patch set is to be backported to stable trees
> "fairly"
> easily. At least patch #1 and #4.
>=20
> Patch #1 fixes hugetlb_pmd_shared() not detecting any sharing
> Patch #2 + #3 are simple comment fixes that patch #4 interacts with.
> Patch #4 is a fix for the reported performance regression due to
> excessive
> IPI broadcasts during fork()+exit().
>=20
> The last patch is all about TLB flushes, IPIs and mmu_gather.
> Read: complicated
>=20
> I added as much comments + description that I possibly could, and I
> am
> hoping for review from Jann.
>=20
> There are plenty of cleanups in the future to be had + one reasonable
> optimization on x86. But that's all out of scope for this series.
>=20
> Compile tested on plenty of architectures.
>=20
> Runtime tested, with a focus on fixing the performance regression
> using
> the original reproducer [2] on x86.
>=20
> [1]
> https://lore.kernel.org/all/8cab934d-4a56-44aa-b641-bfd7e23bd673@kernel.o=
rg/
> [2]
> https://lore.kernel.org/all/8cab934d-4a56-44aa-b641-bfd7e23bd673@kernel.o=
rg/
>=20
> --
>=20
> v2 -> v3:
> * Rebased to 6.19-rc2 and retested on x86
> * Changes on last patch:
> =C2=A0* Introduce and use tlb_gather_mmu_vma() for properly setting up
> mmu_gather
> =C2=A0=C2=A0 for hugetlb -- thanks to Harry for pointing me once again at=
 the
> nasty
> =C2=A0=C2=A0 hugetlb integration in mmu_gather
> =C2=A0* Move tlb_remove_huge_tlb_entry() after move_huge_pte()
> =C2=A0* For consistency, always call tlb_gather_mmu_vma() after
> =C2=A0=C2=A0 flush_cache_range()
> =C2=A0* Don't pass mmu_gather to hugetlb_change_protection(), simply use
> =C2=A0=C2=A0 a local one for now. (avoids messing with tlb_start_vma() /
> =C2=A0=C2=A0 tlb_start_end())
> =C2=A0* Dropped Lorenzo's RB due to the changes
>=20
> v1 -> v2:
> * Picked RB's/ACK's, hopefully I didn't miss any
> * Added the initialization of fully_unshared_tables in
> __tlb_gather_mmu()
> =C2=A0 (Thanks Nadav!)
> * Refined some comments based on Lorenzo's feedback.
>=20
> Cc: Will Deacon <will@kernel.org>
> Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Nick Piggin <npiggin@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Jann Horn <jannh@google.com>
> Cc: Pedro Falcato <pfalcato@suse.de>
> Cc: Rik van Riel <riel@surriel.com>
> Cc: Harry Yoo <harry.yoo@oracle.com>
> Cc: Uschakow, Stanislav" <suschako@amazon.de>
> Cc: Laurence Oberman <loberman@redhat.com>
> Cc: Prakash Sangappa <prakash.sangappa@oracle.com>
> Cc: Nadav Amit <nadav.amit@gmail.com>
>=20
> David Hildenbrand (Red Hat) (4):
> =C2=A0 mm/hugetlb: fix hugetlb_pmd_shared()
> =C2=A0 mm/hugetlb: fix two comments related to huge_pmd_unshare()
> =C2=A0 mm/rmap: fix two comments related to huge_pmd_unshare()
> =C2=A0 mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables
> =C2=A0=C2=A0=C2=A0 using mmu_gather
>=20
> =C2=A0include/asm-generic/tlb.h |=C2=A0 77 +++++++++++++++++++++-
> =C2=A0include/linux/hugetlb.h=C2=A0=C2=A0 |=C2=A0 17 +++--
> =C2=A0include/linux/mm_types.h=C2=A0 |=C2=A0=C2=A0 1 +
> =C2=A0mm/hugetlb.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 | 131 +++++++++++++++++++++---------------
> --
> =C2=A0mm/mmu_gather.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 |=C2=A0 33 ++++++++++
> =C2=A0mm/rmap.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 45 ++++++-------
> =C2=A06 files changed, 213 insertions(+), 91 deletions(-)
>=20
>=20
> base-commit: b927546677c876e26eba308550207c2ddf812a43
Hello David

For the V3 series, I re-ran the tests and the original reproducer and
its clean. I see the same almost 6x improvement for the original
reproducer

# uname -r
6.19.0-rc2-hugetlbv3+

Un-patched Result of reproducer Iteration completed in 3436 ms
V3 Patched Result of reproducer Iteration completed in 639 ms

I also ran a test to map every hugepage I could access (460GB of them)
then fill and validate and had no issues.

Tested-by: Laurence Oberman <loberman@redhat.com>





