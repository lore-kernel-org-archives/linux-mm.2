Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66BF1C4451E
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 11:49:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 472C66B0005; Wed, 21 Jan 2026 06:49:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4207C6B0088; Wed, 21 Jan 2026 06:49:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32C2E6B0089; Wed, 21 Jan 2026 06:49:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1ECD86B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 06:49:18 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AEC7C13C1F2
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:49:17 +0000 (UTC)
X-FDA: 84355800354.15.31204F9
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0EF9214000B
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:49:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="iuznYV3/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3Or1waQgKCMkyprz1p2qv33v0t.r310x29C-11zAprz.36v@flex--jackmanb.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3Or1waQgKCMkyprz1p2qv33v0t.r310x29C-11zAprz.36v@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768996156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hDVt8yY2/5hunMbzbLaciGoWHJvxPm3JadMnQq3QoQw=;
	b=23e9FYRb+lMgNZMeI87iOfH+fvUsfMeXi/jNhoVP6PblYBfCN8646isMZUOuo48aGxFWCK
	cH3IFKWkaXV1dR1eNUEU/usjRB/X7tki1Om1pzusxXx0gvcoHkKW95ay/2fD73qq3Kum1S
	9ZUffOYZu0fG2DxdrmzjjiPGaOZv8tI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768996156; a=rsa-sha256;
	cv=none;
	b=NwNA9LJnIWxxaEGHKucsxq+wuFzhOY1ejeUrsslSD2QgEbubgoIfrrLjDMX74iAakwmsGu
	Sz1vz/BUgD2gsN6RecnxQ3nmXtqA/dKHzN46qWbsDOYrKrXFeRELJcTx8oeKoXsk6n4XVK
	tqGCvAvMyuLqqug2Lbsay/rz1D52lDY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="iuznYV3/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3Or1waQgKCMkyprz1p2qv33v0t.r310x29C-11zAprz.36v@flex--jackmanb.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3Or1waQgKCMkyprz1p2qv33v0t.r310x29C-11zAprz.36v@flex--jackmanb.bounces.google.com
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b8773bf3ddbso581443166b.1
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 03:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768996154; x=1769600954; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hDVt8yY2/5hunMbzbLaciGoWHJvxPm3JadMnQq3QoQw=;
        b=iuznYV3/tgsXOSiMb9srgNBA33NFPYIvXS3yjWTO9XhcatIc5Z6jckdVKp3wWMN3F8
         94zz/TMq1SDumEOBUAmBC3NdDdpNeBC/oFMZ6ZsXta/8YgOuHsMidSTLUeUvOGuVL2Sl
         5AIgc8/ZUgyIeYuOdZ8ipfFsQHeY+Ayz1SDtWzOg+tGtvMMrVrf9dK0A1a1ub/pvlXTw
         t9B1AZmgcHE0udVA3mkloJkMNDTXA9P9VwoU1m7CpC45AFmv3nNZ8sPKy4Pq3C4qDoI+
         00BJqVIzuDGVsNyFKo509kd2+zgzcMM1qRkyIksjy9y23yNASUtaRzTbJo0/2xTx3loA
         4OnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768996154; x=1769600954;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hDVt8yY2/5hunMbzbLaciGoWHJvxPm3JadMnQq3QoQw=;
        b=v/CYPHpopEwg5DZ/oHESYOHuLg12cZzkPGe/hHFxKcUM9UD7YO+bFycp0z20ZqiuS+
         moonFp8NKPSh5HUnsmin5csmQQ5UHRz3Opu/OsVs4Xg46jZHGZncZPmzdh6MYdtwpVSN
         fR6RrVi2YHUdd9ex2bWzWvSe0COr7DJ0pJAohhzTI2NCEz9q51o8VtQXkdfEOff4kQPr
         fqIuROtkugH3+G0vBNhGHILql0bvZkrF8j8AsLHnwyyfsb+ntfhRKGAsqfz0Mj0TqrdC
         HDaFRz+vyOeDfSt8LxacbbWd4HLCHnm+FtjXPgVdy9eSg4tJMS+FHjPdJc8KJzP8dd0r
         0IfA==
X-Forwarded-Encrypted: i=1; AJvYcCU0H9ziUNH0gnMDCBR0vUuZplGl0MpkFxmP737P/gAsqyAAYsbVVZ6UOGmSbvmczDZkAgIFS2HJ1Q==@kvack.org
X-Gm-Message-State: AOJu0YzPxtousU5sNZ3K7m6VVs2EbYBMsFBygtCLD5w4pG+Hsnw4X6nq
	dI501mQ9FVeKOY/UNCKmH8GsDOU1GKDR4V1pBAF8iDXCDs8jLR1mzw85Q8+0l8n3k6rDetH/yQJ
	WTfx/Ve/t3/+U3w==
X-Received: from edzd5.prod.google.com ([2002:a05:6402:8c5:b0:658:786:7029])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:fe0e:b0:b76:d4d0:68da with SMTP id a640c23a62f3a-b8800234f39mr320389366b.6.1768996154161;
 Wed, 21 Jan 2026 03:49:14 -0800 (PST)
Date: Wed, 21 Jan 2026 11:49:13 +0000
In-Reply-To: <20260121112738.GBaXC4KgFQ2J667ea5@fat_crate.local>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <20250924-b4-asi-page-alloc-v1-5-2d861768041f@google.com> <08338619-6aa1-4905-bdf8-bf1a90857307@intel.com>
 <DD7WQ97R8OG6.1CA5E2FU5ISMZ@google.com> <19e5012a-3c58-4696-9e4e-39e2b7d2b5af@intel.com>
 <DD80374YZEWM.1L31D2VUKK80C@google.com> <20260120163728.GDaW-vSLGY1P_E0DqS@fat_crate.local>
 <DFU660CYC3H5.3L7IVBXG8AIY1@google.com> <20260121112738.GBaXC4KgFQ2J667ea5@fat_crate.local>
X-Mailer: aerc 0.21.0
Message-ID: <DFU8STXKQXN9.E9NXUMU72SFQ@google.com>
Subject: Re: [PATCH 05/21] x86/mm/pat: mirror direct map changes to ASI
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Brendan Jackman <jackmanb@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Andy Lutomirski <luto@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, <peterz@infradead.org>, 
	<dave.hansen@linux.intel.com>, <mingo@redhat.com>, <tglx@linutronix.de>, 
	<akpm@linux-foundation.org>, <david@redhat.com>, <derkling@google.com>, 
	<junaids@google.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<reijiw@google.com>, <rientjes@google.com>, <rppt@kernel.org>, 
	<vbabka@suse.cz>, <x86@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 0EF9214000B
X-Rspamd-Server: rspam12
X-Stat-Signature: 3ixhypbqrbsdrkmzs7d1373jgk3ci67h
X-HE-Tag: 1768996155-899349
X-HE-Meta: U2FsdGVkX1+/qNArXzc2SoVBh8w5XpFC6L3IymDBIbFYhIh4ucA0VL9ZPjzGTbZcCrO5gABXntkCiaWFwZeSiV7tBgufhSz1mijrXKQxnq0PgrGKpm3B1XMJjbOdErn6n0Gg7bnhDD00WjZ6BvmHZDTane+laxbXW5nBAfk5VlSA5+GqWZBlYFlW8E/EIWg+yQb5IHOo1YaI+wOgN3+LWbqabYicGq3t19LcTc1LycP7phsFEnLLqVP0dwt4zBL+xBjM9WQ/jSLDuDCYM5JPuSJwbd0y01ieErtLoel4wXZnH3GCYaxS49qk8I8sluJr/tNk3LSE/Vq1c0zWEPVYqseoV8mc58TaNFP4z8dTGgU3mLf9AF7BdafM/nfwZOecmcCFx3hP9nPDnVhc/Be6DGp+oPUS+v8j3wWo0Ba4F51/v0mI9leSPIedQfs/7DX0jLlGIVhDEjkWl/QH5sOpetqljeOh1N6dJMCK8HkBk9AWFomDBIUnOlMCLcZF0DiJe2i06IfiEzle6zwi+GDbDlOpbq6ir+M+8+oIuSEHuTHc7emBszgqBBDU4g6dzYYSc7DCaZyGlbEerN3988/uH2w1BZMIMoyoqC5BCOfO5q9zHCi7oR0/NXYBbPolR+dlH8IwqPZb1qWe76IXFohbIUCjv0iULyoul7+tDFDT9M50d7pU/GUH6GklNHEkIHwJhXsrPvSiysXKluFHmB1VcF0uLeWyqtU6FCBs6f34CXIKGiYinylTjsCap/DW8fZiVQuxG4fGrit2aVZ5pCxjiXlCD85ztQidRj3Kjx1XIPMhI8jSZnX0EVBC664zoci0xM03ZYgn09sF+YSWo4ydFEU/n4bmuTZB3oPAHk4Cb0y0Mgsaj+xlvvqs8zUNdjREQbyzUxggiy7/jevsFcNUTYQvbH9XeMH6tC/msZGCHpm7KyOkyqYBFHuvihVqHh+9NpB1Pr48Q26cVtztVcC
 lQSXMrob
 0ah98YbnlHsVtXr4tDRap/a5j1ynLa6rMU5HzT+HkmQSq+KMW47lAwP/goihAWxIgzM1FPa2ywokhopUoX30tyxMgkmm3YynnWZS+501CheJjRlZP4fXrXtOMqHb/sQYLpMfAwvDPAuAK59ClEUelYgZxUV4DkVTnUXLxAlQaYQ0/QsbIZLYgPrAH9rtU9XI56ESW3CJl6Cnitbyr4JZhcaJNiAa+kC+n6U5bJUbse/D6mj4RXXacsjs+zT+rR7lCDst74/4Fp2zTtzv/OJZmIbZb1RWyYxx+f3TWSv8tX1Hl5HoHPjR+7h1L5e30/R6n2uZJsj9NtoSJU/FX/lpt2NAXxDOGkb7v7CkWAZtLp5VuQV4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jan 21, 2026 at 11:27 AM UTC, Borislav Petkov wrote:
> On Wed, Jan 21, 2026 at 09:45:22AM +0000, Brendan Jackman wrote:
>> 2. The property of some memory being mapped or unmapped in the
>>    "restricted"/"partial"/"sensitive" address space (current patch's
>>    terminology: sensitive/nonsensitive).
>
> Why do we care about the sensitivity of memory? To the kernel it doesn't
> matter whether memory is sensitive or not. You simply map it in the sensitive
> page table or in the nonsensitive or in both.
>
> Having a sensitive and nonsensitive pagetable should be enough. And that'll
> make the whole concept a lot simpler.

Well, something has to manage those pagetables and that thing needs a
term to describe the stuff it's acting on. I.e. we need an adjective
better than "to-be-mapped-into-the-full-pagtable".

Anyway, I think this will be an easier debate to have once we're looking
at actual code etc - I'm still debugging my page allocator changes to
support the guest_memfd thing and that code doesn't need to care about
"sensitivity" at all, there's just one address space and data is
"mapped" or "unmapped". So I propose we defer this conversation until
after that...

