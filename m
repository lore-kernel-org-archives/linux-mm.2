Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AB2ECA9EC0
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 19:52:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E969F6B0088; Sat, 10 Oct 2026 15:52:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6F046B008A; Sat, 10 Oct 2026 15:52:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5E806B008C; Sat, 10 Oct 2026 15:52:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A727A6B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 15:52:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C0EBD1A0933
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 19:52:14 +0000 (UTC)
X-FDA: 85307762988.13.22765E8
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf03.hostedemail.com (Postfix) with ESMTP id F29C120004
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 19:52:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QyfM1iqy;
	spf=pass (imf03.hostedemail.com: domain of aa9736195201@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791661933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OmemQ6H4HcfXPuin0N8xQGUXoQ66JkiD41KqXO9jNc4=;
	b=8SGUwPtU8oZHka5KxDmCYVPqvKuEFV5YHPao2nrW5cUQDvDplq+iAhQwc8T3OOTAGYTV74
	45WAwhtdefpXjVC6c1E3D90by1R/MZ2FEmk2DuJxKnKgBo4It3F97qMsvCuMEwoHKWsEk1
	qC61eQYceZQdEyXlw04w5W/xRoFiv8k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791661933;
	b=bZ1wqsumMgtG1OLD66l6wrgM4e/UF/tcFZB0IYmKmteO2pc7KTtXLaWAUwKORbo50VY8B1
	f9k7/NgMt3ul/T8ntPKdnwjHAY5OH55hhAAOf4O26hYasQ6zSpX5lYrn5IS8JCj5i/uvqW
	8gIwSc4h9TA27egWH8fcY+ibnUNDMho=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QyfM1iqy;
	spf=pass (imf03.hostedemail.com: domain of aa9736195201@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-88bf90b7f07so193175b3a.3
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 12:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791661932; x=1792266732; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OmemQ6H4HcfXPuin0N8xQGUXoQ66JkiD41KqXO9jNc4=;
        b=QyfM1iqyJQyMRWzjp6Vio0hKuLoehVaAypNKsGCzfBnXI05XTEmY1tyz5L+OeWdJkh
         WkOzDLlIfDBzSfCbgph5eUgE4MUGB+AADblZ5rbyhApRob+xjbHyXk3qwrqnJ494Z+Et
         z2jhVRY2yM9Oagc2Dqis0m4hQ+XXX0RjCNXxcspZQoK2Piyu1I4WYBoTo9q8coK1TNjN
         cWLxEv0oKneui9SK8yBgiFgHRwFs1SfS+qdmhSD0lkSX/dBjYjWAy4VjhZmrvV9pKfrJ
         qqyooivlyVs74tN8b6NTK/dHp3TvtexJ+FwXpvGbmqTae2I1ZdQ/X0PXG8uRA5hrVeTa
         fB3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791661932; x=1792266732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OmemQ6H4HcfXPuin0N8xQGUXoQ66JkiD41KqXO9jNc4=;
        b=anw8WRqJ6k3vgBKuXjfgbWWEjar8cWKVZxuJKnHFKy1iIkwaHqVuCdm+goAa3YdvJC
         JTQTi3VlHvdCXX+scyDBG9TPVwJ/3EDEoZaICMeDJK8+lFju6mpCXeXaGhlusQtwfsHx
         CQOHj8dtpNieQbYozL181Ista6ye729ZSXAQWj3hd9rfCDeGxp8962SfWE3AD6ixmAKu
         55NuUEWXjGo/ekjCZRcwgOlNX1ofRpQ8WgpMtUWcCJhufuVRbCBq2SaLl6woGYwI0QD5
         8DR6jrFogwM8j1CXhxcZve1YVA2IX6wuKGCw+HOEPWS7cz8LfYSXQLiovffwP2porzRg
         cbWQ==
X-Forwarded-Encrypted: i=1; AKwUvBwyr/+NXoWeoO81dRLUBbkJ5cDwcXFeuFZyeHCafIJZHekwmlByqIDodlfVp7llkht5QtHj+tezEA==@kvack.org
X-Gm-Message-State: AFq9FYL0M4DxxeZXwNzjhAaRhhEvd0F8L5FO74rN4NI3MudoHeBayb91
	Xy7ZKIKeTxfTaSGhCdmcgrn7eZ/dxWcFVOKLiFIDfYcy/KXtczBLNq7Z
X-Gm-Gg: AYBFou3VRlRlw/PR+P+YdiefdVUZBuFCm/lNMLfRuAd9q3vmWpOHIy4IZwFbGEkjuER
	RspB7ClopN5Fd675pjWDmR3jQTpY3A81iYtYE776rTZw2wg/oNZf5ZUUhG3tzjXAd/vEi4V/cbt
	wqyxsQUocpbHd2X9mbV2z6qJA9SoCV3xop7vXgw22yzeaGm8HVtARFihY0dzh96+KZtdDcc+VHU
	GD5nmWKmkuDLQfM4vpjuu7rgqu2flZMU8OGGYGYGOQt42H2K/vnLxF39Agr7eUZB7XAzFIQCy0i
	muJgmajDkNaZS2YaUVfjMEKJha1hC+NUPuNXdGs+O2tCMuwv2Irrw9FSiDHDJIuJM1zeXqPzu1v
	v+Sgm6KvOE5fkGg+robifr/Km6Uc7hP+So1ncKBUQ5Tn15NOMDqiiGlL+9w2K9V+tX9Wf5hnvf6
	zc2yhvK4quCDQdoygAXJoDWdTlEkR7pI3Y9nqlIBUeWccsqlwBT2+J4FzgdWHj+7keoYH7b9Mjt
	qJ2ip48er+YXcdy8FF2l8h36igyrpweadt+BDgJvrAb9eADC/D4cWjPWzLXzfSfO+IgwYSKXwUJ
	WbTMDKuDsPI5c+b7YEVuuGwVqDclhWyOGg==
X-Received: by 2002:a05:6a00:1f06:b0:881:d48e:7138 with SMTP id d2e1a72fcca58-897c43df755mr4695645b3a.4.1791661931668;
        Sat, 10 Oct 2026 12:52:11 -0700 (PDT)
Received: from DESKTOP-TJS95SS.tail460ce2.ts.net (114-38-131-92.dynamic-ip.hinet.net. [114.38.131.92])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-897fb87c459sm2153250b3a.50.2026.10.10.12.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 12:52:10 -0700 (PDT)
From: Yuan-Hao Hsu <aa9736195201@gmail.com>
To: Rik van Riel <riel@surriel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	liam@infradead.org,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Aristeu Rozanski <aris@ruivo.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/gup: batch PTE-mapped large folios in gup_fast_pte_range()
Date: Sun, 11 Oct 2026 03:52:02 +0800
Message-ID: <20261010195202.689-1-aa9736195201@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <7dd4ec994502233cdc09fe5c4369adc89168d738.camel@surriel.com>
References: <20260917083747.786-1-aa9736195201@gmail.com> <7dd4ec994502233cdc09fe5c4369adc89168d738.camel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F29C120004
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 65b3pt8a38xxpx7f87mhiss4zth9dboo
X-HE-Tag: 1791661932-291527
X-HE-Meta: U2FsdGVkX1/ES5PmWE3km5dg7fhfRTd17MK5LKC3A58mMiRIQ28+MdB+PZ3lsEp3HgGfY4k48B1Q5sdUKcuAgBe0Jr0dR8XMgycA+JH4e4Yx3lah9L7OGZAmEN1V17CmQZve1Ek6vFNugF0zjVbXz7NAZgsd3u+kXKwsl4ORkMQC0hnsVQBsFA8PqbxMriQVRozB/Z54wN6QF254rvr6qJOsxKJlDpbPOb1WdkBokJ7kLeXUEZExnoa6eJcZzBRBOIMnkGmfSWmZtLoEur3IGOXrIUW1KLtLpzaufoprznno8Xuigm9XEexycGsxAe2p/EsSW+GEoZT0rKUyW7XfPFDOcxkozgxSmoWkn5UE/vebEJMDC6PGj2Wb5os+kn7dj6FH5EZ/gvi3FoR0753pVUIY9jqL9k98U0z+7Thctm3kFd92fAh0FGLKVhzlTy5mxkpbP7WIMTDGXrLZVsKP6IrLvAKAnzU4FlQCbYT8vWkYTVcF+pPtgcUnvVexcuSt4DnTobFvPBSbIJlnLdwVkrfYeWsqrtqJvqWPPqF1AYoi88WIqLT5+bLs8j/IZjqzHsqL0G3v0zCLJLQUMoUrju0CyC4OOS4AZzYx0F9kLPEmy5jur4UvTQ1V6IrwOYegjT7ayLLrkqfIpeoB1jEW3b71/qyJIsHpuzUirk4LWa+5eRDUw0TQwhpck5qYEh4zeNQVJSx7/F7anZw6JsK68La1zie3V1AthbMju3L+P3NuKlC7ZJKQE92UkvpP7VLhCOafmsYC5TJUubygd2TqxUmLJEpD0EaRRqumtl8EqNhBB+wVlIvQ+phJoHP5GcP2leFm6gOhnITmTV85f6DR3Ua3xf+Xj+KP18kD2Oo1hOzvTlh2iS5Ah+rfxLmNCtfghcLUQnLWi1RZTviuKhjBzmjE1w1ySpdcBR5a8sd03kMxR16nGXJPNtztzdH3JPJAwrEworrOWajM/Tg59Bx
 N/8SMOFh
 wsWuM7JLIANMX9jGVyUw1Nxbu8J9JtrjrEkL13SkFF3gqoj3PmOS8X4hoUmPuLoxM2/0hYMrwbYTL31KbX1gF3iU4H5YgqyehhuTyOzkT3sffbcUdRfzga7Vxi4iPRHpEb0c1nIQqzCINjXE6pciHD9CJ07ujSELUrC/Dz1PN2Q0+1PFR5uKYCC4FbdQb9ilDm6Ea9ZfAhEPergQzlEo7yplYf83mJYQxCvRk2PHyeCy9hhvefqpWodwIOBsTo+v0BGygO9ntwV3Gsv3M9m3sm2cXxMvi/ipIrks7aXAxFwKMfcKPxcRz+c/8TC9AHXRtKkVMu6PsRUSjt1WIc5WOa6r0AS4/k14pL/xsTZgypfWqDvPktbUbDnOhNcN6P518PRDUKKOSmojPLE/Xi2VpPBRaUCPHhDFhfMclUqsNJxNHj9/nnd6yk90/xQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 07 Oct 2026 06:47:06 -0400, Rik van Riel wrote:
> Since this is lockless, the PTEs could change under
> us between when we walk them in folio_pte_batch_flags()
> and the batched try_grab_folio().
>
> Is that race condition safe, or do we need to re-check
> afterward that:
> 1) the ptes still point at the same folio, and/or
> 2) the folio still spans the entire range, and was
>    not split before we grabbed the refcount?

It is safe, because the batch only runs after the first page of the
run has gone through the unchanged per-page path: the folio reference
is already held (and for FOLL_PIN the _pincount already raised, with
the smp_mb__after_atomic() in try_grab_folio_fast()) before any of
the other ptes is read.

2) With that reference held the folio cannot be split: both
__folio_split() and folio_split_unmapped() have to folio_ref_freeze()
the folio to the expected count and back off with -EAGAIN otherwise.
So folio_nr_pages() and page + i are stable for the scan.

1) The per-page path re-checks the pte because it has to pin first
and look at the pte second ("(1) pin, then (2) check pte" in the
comment above gup_fast_pte_range()).  For the rest of the run that is
already the order: each pte is read while the folio is held, so
seeing it map page + i is the same state the per-page path is in
right after its re-check.  A pte changing after that is the race
GUP-fast accepts anyway: the other side clears the pte and then
checks for a pin or an extra reference, both of which are per folio,
so it sees ours.  try_grab_folio() only adds references to a folio we
already hold and does not look at the ptes, so re-reading them after
it would not tell us anything new.

The pmd re-check after the grab is the batch's counterpart of the
per-page pmd check for THP collapse (pmdp_collapse_flush() detaching
the page table while it stays readable with interrupts off), same as
in gup_fast_pmd_leaf(): if the pmd changed, the extra references are
dropped and the next iteration bails out to the slow path.  The other
early returns in gup_fast_pte_batch() happen before any extra
reference is taken, so every bail-out leaves only the head page's
reference.

fork (write_protect_seq around the whole walk) and the read-only
FOLL_PIN check (gup_must_unshare() per page, after the pte read) are
unchanged from the per-page path.

Yuan-Hao Hsu

