Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0C2ECD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 20:56:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12C376B0088; Mon,  8 Jun 2026 16:56:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DCBD6B008A; Mon,  8 Jun 2026 16:56:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE6BF6B008C; Mon,  8 Jun 2026 16:56:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DE48A6B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:56:13 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7DCF3C17E5
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:56:13 +0000 (UTC)
X-FDA: 84857953026.12.E2B46BE
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8B2D6180006
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:56:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GOuLT0PR;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780952171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fHaHyUtmd7xYX3FTc2W1dWbFRus+iCyGxuj8fCGhfn0=;
	b=JCx58lZ/Hsg+A0b6VX+sTPdCngIn3YK/ezn5GkdTVpuasf7jy8ElxwihfHBrdF20q8SZiw
	6isJ0mI8nBBZxnbH/UrvDzySNB8aYvKN3dkj5IahpW2liQGaCFzKvTSovtEI9wb8lWQRm9
	V/fCGS/Yl1KGdaCK1BYyPJQeI0B/LjM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GOuLT0PR;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780952171;
	b=pJ9UAmehv4XyREOWmeo/TB5X6hDK0AKCafsFZrXu+fPApxaJkgxlDROm88DS+ohzTwf8WK
	Sy4sS0oby4Po2aH/oreqQWogbXxDKzL7psxWhcAyuZOLpfUpcwohrT7kfOPVHmpnL9fe80
	9R1MillxUoBp0aIjW/JcsQJgP4p744U=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5175cb5946dso31050881cf.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 13:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780952171; x=1781556971; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fHaHyUtmd7xYX3FTc2W1dWbFRus+iCyGxuj8fCGhfn0=;
        b=GOuLT0PRywYM/C6+Mdl5Wc7cespm6cXt3PifwIdbs9HCrusciyjXCMJiY27ezEHO6D
         1sctx1glEkkpIyC+c64IrapdwwS5+w/REv5tUdUO63Akc0jrDuXIZBptzn1R5hEdiEpN
         10J0MtQw/CG+A2WwcKlvis47WT0cP1Yd17JeUh/JpwzjBYvXr4trMziYe/KXEFjam3+y
         ZtbyfiXq0KkpShBUlkDcbJZ/59M+dYmr2a4u91heP/TV+LVo+5pIXV3w/GS7WKv4Ndfh
         TY9dWm7XizDR2y/auSAAdeNDLxvEHBqNcIpFBFiob1ivaIZFmyccrgap6RTKYSx99Y3J
         fUTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780952171; x=1781556971;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fHaHyUtmd7xYX3FTc2W1dWbFRus+iCyGxuj8fCGhfn0=;
        b=gvv9gRUqwFoQsuyKNBhG+Bcprzlk0xgdp+hGdb41OOT+KDAZ0d99cApwu2H988PR/J
         TolE0nJsM9hz2+hQX3PwSFyEYRg8mUCBkjFR+85Dk8FmBntFeefdGwKlLbWNU5xwrSbA
         H+7cUh5BgzDp+mFd1/X81L8rFIOIYg6BNAtcEzUcJiH1RcdepsoPqokuMatjpm3FFudi
         R4IoPW7in+KnPx6V+fPk6jRjIYdgJQnz0uvavq4I4VodORyPRd5PgbB3EPPDTezJStcq
         iSjeLrWsJHihHW3kAkqHg/RaZxvyio+1MVcsDym90xJLc/UZlgtIrurJ/DsAl9YhT62/
         pwcA==
X-Forwarded-Encrypted: i=1; AFNElJ8MUgPH6ZzOIdErmlqBeVf9KDVKAgVTAV09MegJyegMkWzA5kn4liX7PL2+ozC5HD9JGI6jFniFjA==@kvack.org
X-Gm-Message-State: AOJu0YzRt4c+bV1LIPO9phNG4Rtv39C8M4LlDh5yS51YdATjqiu8Blkw
	hk2El7VBhZkxs2zA/DZ3J667iLtunope82h+DjCr4ca2Fhsp/O6tYakFKFLvGJ40B6s=
X-Gm-Gg: Acq92OGBOFDFyhj2NG+ZNNX2crdLtAi9ZjOppVNnzwPVxRoPHTl4EltmTvcqibZth3C
	MPMyabxlnhIlnJMGxUDn+EQXRUtTBDRObFg35NZe5geLR2Fbo1i1pWEerYWzNS42DzgHu/GPSUW
	M8IHNbYmOoo1zb26Nq+tGWJN2wueNmZVd0o0Dd7jnMq8NxtWXNmH1Wqbv8YGjRvmKZb0a3UV0Ug
	r8BhucZxuLQ8BsIZ7e6ScdJo73jsjmFyXrrhOQWwwwk+TVzR0cVwJtf6C52c2yBaF9SeSqP6+1O
	SlKzxwQUXC4uhoMNtiG477j3jPnN2ntnszifynzFrfGxyOwcVWv+OrsGbXZzVWo6xYudqid6+gK
	nKOdLzbI6xUaUmKv/gN6E2tQGW2YrfrX4QKEnY0KVFOZaisKsZJYQMcWm7lziC52+r1erenQSSn
	11gvD6QrhUU9Af1z3SaZtqLwwZsHC8bVsIViPp8gM6KTKgMeeze6gpU6IGwq0L3O7ATwwRc02JP
	mBSqhPg96r0ac2H0w==
X-Received: by 2002:a05:622a:2597:b0:516:cfb9:2856 with SMTP id d75a77b69052e-51795be2429mr255289181cf.31.1780952170668;
        Mon, 08 Jun 2026 13:56:10 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ceccd9fda2sm180883106d6.2.2026.06.08.13.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 13:56:10 -0700 (PDT)
Date: Mon, 8 Jun 2026 16:56:08 -0400
From: Gregory Price <gourry@gourry.net>
To: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 07/37] mm: thread user_addr through page allocator
 for cache-friendly zeroing
Message-ID: <aicsaMeDd2C08_xf@gourry-fedora-PF4VCD3F>
References: <cover.1780906288.git.mst@redhat.com>
 <50d410b47fe3f45327783e05bd306d5eaab75e65.1780906288.git.mst@redhat.com>
 <aiaUDTeHDA45ZXFS@lucifer>
 <64f2e580-aa82-4849-9236-b8ec4208ca24@kernel.org>
 <AEB19464-20A9-4C5B-97B8-681CCDD81031@nvidia.com>
 <2475e4c4-9ba3-4091-9bfd-1c1c15163da7@kernel.org>
 <aicbZ9lewv1wJqqS@gourry-fedora-PF4VCD3F>
 <8BB8D6E5-8644-4CBC-BAF1-0AA19702E042@nvidia.com>
 <aiclJGgB07L3rV-P@gourry-fedora-PF4VCD3F>
 <D754DEDB-3A3A-4F6E-BF64-79086F0A6467@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D754DEDB-3A3A-4F6E-BF64-79086F0A6467@nvidia.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8B2D6180006
X-Stat-Signature: kux7yqtgh4tbn6u6sk675pomoe1nt339
X-Rspam-User: 
X-HE-Tag: 1780952171-908007
X-HE-Meta: U2FsdGVkX18N3kAaJSQNwQ0337vO2I14M2Mqpi9+du7DJc1cwxVcNfcwkPYT94yf7LbGfoCEVBLccZfiCoSWrsyzaYoNzO1bS4HgM/ldQ91CGUxjeSaogBqF11mr//z/IEbB6BbT76MGN3N8RtXnjmRTQ0JEXtdED/xv2Vc6DK9xV9W3evlczpj6ZNb7YdOqMnvPtl/WYsIdrBGku6xTEUq02g9B2QrS4Yl5mEmZMH845DHuMBMbw992buLZ1ycp1G8ljXznTI4rdMJx1Sr4ow1YvfQo2R62r8PirRYH5OT5EPAcsPXCvTCPdOrv7AN7v62yyVOXsuUM61fBDHm/3K34fbPJxJ0HUOLecjv8q5HoxM26cFaBYQz2+uG56OPEqVMKjLZs6rZFEn9OfRC297DWEUErDhd29QHYSZ/7cNswCWbERYZKNHIv1Td8YfvbfI7535S2aqNW9wFPepcODDYu3WzSXWI8TSWvgfD8ZFpHHNks/sOEglR3K5pbxuDrDuy/uuiUJljqbHraBxSnLGGuq2e0Wjei+y9HzE5HQBLHMm93euLdFVhL11g5g/2jNwNb9k0bqVp/lQuVrpAUe1dkSJYSieDDPr8Far2NQYMOPTgjk7e7RUCS9c6b7wrZ9/61N2SbKruPO//4iI9kegxqmcp5WuYpGE4lsN5LeWIy49bw7rvaRzmWCzLqdMC2S0PD8pJrif+9XW355pOp7/iZ17zL5/WHO2RNoHzVbSRLhXJTCTtdrs5L7cD+GSNgT82fMKkbIJVhtsAp+spGB31YYm1YKq6Lj0ILzlG8tjvrx9HM8G5UokdGt+2PN7OglscTyUbMMWnfUgpSXOr6OzfiqrZBboguNsD7Gu/kYLFB24MRHRs+Y6I/RMsCqo/CFjuH2l+ilanKqi9PfrnJxHge76GHMgBlBy52ENChe4R3pKFelrcqILLOckkbgnDji9MAlA9h3Vw8qjJEaV7
 bBTTihlz
 RE7VW7+/edg9q7Yi6642d4HbwYJgwEiBke32cwMKg6A+43mQQu+8qpmlh+v/aZ6rHTGWXPDwmDHQ9uf7NAqjEpHKGTnLFfjCPL4hWHrT3YGkywGbvrv7CwJyIwNHCME7jFirAEXP8TOkpsX24x/IEf/nNC5isEdszE8TxQIN3xuWN0W9ZL62ikOdj4sOMHolJHk3paxWYBsvPQrBUn/mrCLisV1OL039YjF1MqDtNeqEenPDRjY15MP/PEMWaXrAN43hmvr/AHEAFdKrOhKlMBbWlKlyGA05LXT0SQhogfUszkYzmBDGDXolWD6qPUMvgcCVtnqdL4ihjQ51oKsOPYOyS78YenntbwGLuKrdpTbdhyVloqAdNNjki8QnhVHlDZ74it6KxiJhaOM7DReryolRAHaU5GIIOXLuXOQ/MpbGTU6i06xxopck0vzAa4PQtQ6jnjaSz5lChMOk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:37:59PM -0400, Zi Yan wrote:
> On 8 Jun 2026, at 16:25, Gregory Price wrote:
> >
> > essentially we end up with something like
> >
> > alloc_frozen_...(..., gfp)
> > {
> >   folio = whatever(..., gfp);
> >   if (gfp & __GFP_ZERO)
> >     folio_zero(folio, -1); /* don't do cache flush part */
> > }
> >
> > alloc_frozen_user_...(..., gfp, user_addr)
> > {
> >   folio = whatever(..., gfp);
> >   if (gfp & __GFP_ZERO)
> >     folio_zero(folio, user_addr); /* do cache flush part */
> > }
> >
> > The downside of this is obvious: it's easy for developers to get this
> > wrong and call the non-user interface for user-bound allocations and
> > miss the cache flush (that is only needed on some archs).
> >
> > Not saying that's a deal breaker, but it's something to chew on.
> 
> I agree that misuse can cause trouble. But if we do the churn approach,
> what prevents developer from doing alloc_frozen(..., user_addr = -1)
> and using the returned page for userspace? It is possible the allocated
> page can be exported to userspace later.
> 
> BTW, that cache flush thing is fragile even today, you probably can
> do alloc_page() + vm_insert() to get a page without doing proper flush
> and export it to userspace. There seems to be no mechanism to
> prevent that.
>

Oh of course, I said that elsewhere.  It leaves us in a spot where we're
not technically worse than we were yesterday - except that the surface
of the buddy has increased (developers need to know about 2 APIs instead
of 1).  That carries maintenance burden (if something in alloc_frozen()
changes, something in alloc_frozen_user() may need to change).

There's a careful dance here.

~Gregory

