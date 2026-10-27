Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26867606A31F
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 12:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=EucCbRvd
Received: by kanga.kvack.org (Postfix)
	id 137306B06F3; Tue, 27 Oct 2026 08:22:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E80F6B06F5; Tue, 27 Oct 2026 08:22:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F408B6B06F6; Tue, 27 Oct 2026 08:22:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D27AD6B06F3
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:22:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 62DD81A08ED
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:22:35 +0000 (UTC)
X-FDA: 85368319470.28.2251157
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4351820002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:22:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=EucCbRvd;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793103753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PYupT4R2wrTtuLnmT+K+EYDPSdbL6IVQkich1PHb7RU=;
	b=coffo2eXHVlpPxli6jp5WYxNdDcptvZhrt0YC4x4LCxEv3d8bjvbBo7pNsd/q5ycycsCiX
	UkGnDNzafCEZ/izD+o5hSEm23rEs9f8BjN6SydmWuoZGynUKcOpSqlpzwvGsQJceaccWt4
	jsVv1YPDUMcNdtjRAeXI0fS3CgDz4xY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=EucCbRvd;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793103753;
	b=b6I5zuoFICLdnwGVafH1wCNCbfbGSCrN6F8vxJGCdujgiOXVtr7FlVEwzK9NfFZBen3FRx
	6sHbEpToNtmqhUZFmF2puM7HdAxsBmZkybrHc4Eo3+NSdUn8hs1hutBdOXJQ2X/RqudqBb
	Y9QVlRe2L/VQpfUFEJEocbu1TIZ3MN0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 102FE15A1;
	Tue, 27 Oct 2026 05:22:29 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 96C703F7B4;
	Tue, 27 Oct 2026 05:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793103752; bh=b1JEKZq+qFyqBeJCpYq5W3IAj8ygrX65I0RZCYtIPJc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EucCbRvd8KoSEkBB6E0N+iAtZB854R2c9Agr4NE1ihGmQzd3iO3ZT9WsNHayT2nJB
	 nX7jN2yfpviE7lXh91GBNjJbf9lTah3PoJrurIEBcOCXKguPqNxRpfwQ5hx7hSzVsa
	 RkUPOU0qMgMtzUGIFCSu8q/y5EKM0x0VpResoxQU=
Date: Tue, 27 Oct 2026 12:22:27 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Rik van Riel <riel@surriel.com>, Yuan-Hao Hsu <aa9736195201@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>,
	liam@infradead.org, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Aristeu Rozanski <aris@ruivo.org>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/gup: batch PTE-mapped large folios in
 gup_fast_pte_range()
Message-ID: <auCXg7VMr7NdkPdN@e129823.arm.com>
References: <20260917083747.786-1-aa9736195201@gmail.com>
 <7dd4ec994502233cdc09fe5c4369adc89168d738.camel@surriel.com>
 <20261010195202.689-1-aa9736195201@gmail.com>
 <ff62aeaeb5ced49640c959c047b2e9f320f5c10f.camel@surriel.com>
 <c3c6f83d-380f-4a9b-a204-fd157ee77648@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c3c6f83d-380f-4a9b-a204-fd157ee77648@kernel.org>
X-Rspamd-Queue-Id: 4351820002
X-Stat-Signature: me76traj6ek6kiymrr3wudnzr3dauuub
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793103753-121891
X-HE-Meta: U2FsdGVkX1/Qh9aDfOrNaJDM8wQLW0YCV6vTfO8GyqICMQkMWEY1HiTolUfu7Z9hZt59BErMVFIabf9jtcZOtHPCwyohChvx/rif6aYiwNc8sH4Qz4fZoY+7yjz4f1pfdF27+wM2YAHI0xqMGGLSMO9bpwbXoKlECKAbkijP0KtfnRJtmwRNh8srTYtB5t0Sw5FUlOcVLGw75/a6752i7qBRRXlWYfFQ8H5mD4UBZAnnCBOfarfdBrWDRc6QbQx6LFqkx9CmnZAO8ASrli2YJ+xuE5zr0JSwde3jAYsoQga22Jn8+YHWPAXOmnSdq/rGFvhMDEP+8Ror4R+qHoT8KPWMUmw5PNpWniepfGC+weMSF+d3egzTNCFXu7r72cbmXJJk/hEB2JbwyJviZB/6pmc2FIFkAHAvNwOo7rgaJrEoMmk35qNEyw9SW9sqeI3iYJua1o5W1WujvL2I1bIXPd88I8uwEcj+OLAer2KrCiZEQMlcQx/vKtibBo56R/n4lQmVTVIRmaZ+XIHxU12hZVJg+x676k7jOFEJXESGpjTk1P5D8UDJEvKTOYYU2ih3038MmxxlUTKOecx/Whv3prHYCYI8f/UmvPajxceDLvT6U9kWa32kSxYoBBOKvGaLSXchCLQ1OSK6FqfCOceo2TQdxprw5Lh0C8C0/g6lxb8oxiFQ0MKx7oSjPAmXS8aprTMya/CSi35mYRnt0naP/CFaMrWg2WvWUrRBaNl6SguwAegKqxMZbaD1X9i0FKe9q5bLbGyhmhDmrTG9+y9+cbgbmIycHdQyuIQ7s7LoWVyvIUUSvKAvQQR43YzPgXvW4hvTtLtUFHv/dD1Uw+ct1eUWelaZ8QMQrnqdi3kMt/KZzyB16aabWim0NH1iJ8I3w0DXi6q9IrHcXPsMZhh08Vw25KkjUsPpgf82G2/L1ensFxfkLsEQ5jV5sRTLHrVuuFAabMv9E/ReQqtY3ud
 DlA0VMif
 YrSVgpWVwvTRwQqTwepQgCvHdJD8ZgjSPjj65h0VrfxzaW+kQA7nKyCRe9y7o8vLWj7tehqEbEcGCSQjEYYkfMCpxuZGZKpUcfGGrQhf9EHlk2W8G9wl+u78tHEsN/9wWImwS2vqrwYQmc6snLNoZYOXpcR2AFALX7rUb3WVxVg3ZKXYevn0alatOSaE8zXVevrEJmh26B+oo2c4AJjdgm9xUd1qsrLUdscbR+j4AXOlzBspIVTzGcDcO2T1XqBg0G8fMIjV2+m2Py1HDIWaaWRGCMAcUvGxNGhU5EecTF4fWUhVjRbjKtIFowG1OhnXfP41N4BSRNLXtGg6qUaDNBBdUIS49fg8ac1Vj2exXXo+T+dCKhQY7OviyCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 12, 2026 at 09:05:55PM +0200, David Hildenbrand (Arm) wrote:
> On 10/12/26 19:58, Rik van Riel wrote:
> > On Sun, 2026-10-11 at 03:52 +0800, Yuan-Hao Hsu wrote:
> >> On Wed, 07 Oct 2026 06:47:06 -0400, Rik van Riel wrote:
> >>> Since this is lockless, the PTEs could change under
> >>> us between when we walk them in folio_pte_batch_flags()
> >>> and the batched try_grab_folio().
> >>>
> >>> Is that race condition safe, or do we need to re-check
> >>> afterward that:
> >>> 1) the ptes still point at the same folio, and/or
> >>> 2) the folio still spans the entire range, and was
> >>>    not split before we grabbed the refcount?
> >>
> >> It is safe, because the batch only runs after the first page of the
> >> run has gone through the unchanged per-page path: the folio reference
> >> is already held (and for FOLL_PIN the _pincount already raised, with
> >> the smp_mb__after_atomic() in try_grab_folio_fast()) before any of
> >> the other ptes is read.
> >>
> >> 2) With that reference held the folio cannot be split:
> > 
> > You are right. The page tables can still be remapped
> > to point at something else after gup_fast_pte_range()
> > grabs a reference to the folio, but that can happen
> > no matter what precautions we take inside gup_fast,
> > because it can happen after gup_fast has returned.
> > 
> > I have no other concerns, so feel free to add my:
> > 
> > Reviewed-by: Rik van Riel <riel@surriel.com>
> 
> There are a bunch of things I don't like about this, including suspiciously LLM
> -sloppy looking stuff like
> 
> +	if (!pte_write(pte)) {
> +		for (i = 1; i < nr; i++) {
> +			if (gup_must_unshare(NULL, flags, page + i))
> +				break;
> +		}
> +		nr = i;
> +	}
> 
> I'll find someone to polish this up.

Thanks David, I'll post with a little bit fix in next rc-period.

-- 
Sincerely,
Yeoreum Yun

