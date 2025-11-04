Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D17E7CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 14:48:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CFC18E0148; Tue,  4 Nov 2025 09:48:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 381868E0124; Tue,  4 Nov 2025 09:48:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 296928E0148; Tue,  4 Nov 2025 09:48:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 19A8B8E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:48:20 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B9AC788C04
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 14:48:19 +0000 (UTC)
X-FDA: 84073205118.20.C314BAA
Received: from mail-10630.protonmail.ch (mail-10630.protonmail.ch [79.135.106.30])
	by imf24.hostedemail.com (Postfix) with ESMTP id 25BB2180015
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 14:48:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=DjjSxPdz;
	spf=pass (imf24.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.30 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762267698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=My0lcXrG8cShyz59I5w5UE8WjsZYKZx5nmyqC76eTx4=;
	b=sJxRfS8Gko+1Jorm66JbHushG9H+k3+py9ZwQual3qm+kLyXSDW2jRr2nonC/K8XOCZ0Rf
	2FAaJBr4QtssKUKQ0G3bo9/lj7dFcAqmkfrU0K5lULbKKKdxY9z8Hha3kP03flbe1O8eXp
	GBEdX55LTUtWV3N97dE1omLSyUf0JKg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=DjjSxPdz;
	spf=pass (imf24.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.30 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762267698; a=rsa-sha256;
	cv=none;
	b=B1Uvw1j7nB/PBnb6s5EXoakTdyghaijifuzJbclu5y1HZcrXfIKr2q+94RRGncpInGhYOn
	/kuYVRrK3ps9InUNVNcDss4BkIr2YSSMshlQsZog5aD/dCak7Gpc/oRrmOuLgjG5fGtt33
	121y9k1le21iC3As1kbKjMe2GXhP7ek=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1762267694; x=1762526894;
	bh=My0lcXrG8cShyz59I5w5UE8WjsZYKZx5nmyqC76eTx4=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=DjjSxPdz8f9+6EQiHOdfGc9ntzSl9Ub+pKG2MllZ8PxNEbtJpEFqPHOgGG+O0ekXd
	 SpX8uhzxckJHe4ZN+MUIg4tW3wLywA+0yuZySC2uG24FfAV6vTkSSskNFdTa6KmDJB
	 tPMNhEysZkFtgwJGI3maZo2FQxMCazYHOnry5shRcpbIwn2r67aNgAxqr+WAS5Dg6k
	 NgDg3q4u6evkq/ckpDH10xJH6bgx/WOFAdRPij6g6STaVsOAKAl/M8XMOE7EkZuTXi
	 LigYtBppxumrSaPlquWUZA4SQPDeRDeRe7jd7AfflY6to+oMm4pvv33KhEg2GXNtDk
	 9hr2LvbGsWRYQ==
Date: Tue, 04 Nov 2025 14:48:07 +0000
To: andreyknvl@gmail.com, akpm@linux-foundation.org, ryabinin.a.a@gmail.com, elver@google.com, dvyukov@google.com, vincenzo.frascino@arm.com, urezki@gmail.com, glider@google.com
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, m.wieczorretman@pm.me
Subject: [PATCH v1 0/2] kasan: vmalloc: Fix incorrect tag assignment with multiple vm_structs
Message-ID: <cover.1762267022.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 6755a8c21333141e5fc9d41deffd2e258c429b93
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 25BB2180015
X-Stat-Signature: 5t8c9rfa4aq5u84ar164oagwggqfu5gj
X-Rspam-User: 
X-HE-Tag: 1762267697-988094
X-HE-Meta: U2FsdGVkX19W5DWxK4oOw1R0C0Ox4ILAhkk/LC4Kh4frbRGfpNNoT3WDuT/lhgC3i5pVlOkX9hQ/VMLJ34KUwqvs8IS+XaXBDBz/Fm+I1g6pLstPPN+f1NUjyJjXSQhY09KQdC5MA6g1ONCdcEQpeFPUJBEm4MYxiwqBtJ7YTSSZ/3/V8a3NVylE4baBrC02xTeGwOgaYBV4SGtczf3nNLDgQvjqJO9UajCO4OsmeMVVE3LqQfFYAsZYHdMsgmJ4r0cttunZwYUyPjirtDhKUvRYYDa65GZH0gY/O7UFmZ7/kGn8vU05G6EbkDp+i7isymj3t2A/Yjva3VmWWe+woAQ+Jhh1UjA8rZYvw8emllXBQtyzP/nLVdSDUrzYjl31ULmJfkAyXV1TaO9Q2HOYFiZvBSZPHmlAHfp0uKeZ3WAQDHC4/py5l3V/mD7BpRzLSzm/wGLJZDvbauAQfm1LWfR7WmtVQs3rYsVqn3ol5l3wkZ7zox18K4A4zOW92H+wLUfzsE9suoSRsblxlmcOg873Su+a0+5kxU1Su3zEYpxJqIKIwA52EYqRembFB/IMJPzrZ3Hix/9h40ahL3CbogLHp2j/eiODrY4yvy0YSnTLYOHL4u0KNYPydJU6BKvqcLtlop49XD61VPqXG5spBPWZRTiHI9xjSRMmOc5Mvzb0QOhz8Grs95T0sKNSBVWvro/mM7inktdQXZ6NVF3zlqOxjsZB7SalQYnLzswT6dnL9kx0K6eO16fECx+3HFXgwMWPP71Paxzs06+5S/YjJ7s88q2J4IPzodml47DG7FJriGWGp1A+XuSXEMdUb2aI+TYV/46WQ3fMT4T0junkRlW5D8clnrt3EWmMJwhuqTtCjKs2INUXz+T5n68Lcp6gunZqXyHg3m6XrDJkHF5E4hP8FeVC7vUDsG8n4gkM9JDqXihpXHIbfKpgcnxOa6zTanIH0jAAxBI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A KASAN tag mismatch, possibly resulting in a kernel panic, can be
observed on systems with a tag-based KASAN enabled and with multiple
NUMA nodes. Initially it was only noticed on x86 [1] but later a similar
issue was also reported on arm64 [2].

Specifically the problem is related to how vm_structs interact with
pcpu_chunks - both when they are allocated, assigned and when pcpu_chunk
addresses are derived.

When vm_structs are allocated they are tagged if vmalloc support is
enabled along the KASAN mode. Later when first pcpu chunk is allocated
it gets its 'base_addr' field set to the first allocated vm_struct.
With that it inherits that vm_struct's tag.

When pcpu_chunk addresses are later derived (by pcpu_chunk_addr(), for
example in pcpu_alloc_noprof()) the base_addr field is used and offsets
are added to it. If the initial conditions are satisfied then some of
the offsets will point into memory allocated with a different vm_struct.
So while the lower bits will get accurately derived the tag bits in the
top of the pointer won't match the shadow memory contents.

The solution (proposed at v2 of the x86 KASAN series [3]) is to tag the
vm_structs the same when allocating them for the per cpu allocator (in
pcpu_get_vm_areas()).

Originally these patches were part of the x86 KASAN series [4].

The series is based on 6.18-rc4.

[1] https://lore.kernel.org/all/e7e04692866d02e6d3b32bb43b998e5d17092ba4.17=
38686764.git.maciej.wieczor-retman@intel.com/
[2] https://lore.kernel.org/all/aMUrW1Znp1GEj7St@MiWiFi-R3L-srv/
[3] https://lore.kernel.org/all/CAPAsAGxDRv_uFeMYu9TwhBVWHCCtkSxoWY4xmFB_vo=
wMbi8raw@mail.gmail.com/
[4] https://lore.kernel.org/all/cover.1761763681.git.m.wieczorretman@pm.me/

Maciej Wieczor-Retman (2):
  kasan: Unpoison pcpu chunks with base address tag
  kasan: Unpoison vms[area] addresses with a common tag

 include/linux/kasan.h | 10 ++++++++++
 mm/kasan/common.c     | 19 +++++++++++++++++++
 mm/vmalloc.c          |  4 +---
 3 files changed, 30 insertions(+), 3 deletions(-)

--=20
2.51.0



