Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99E27606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 00:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ckQTyi5t
Received: by kanga.kvack.org (Postfix)
	id 940856B030F; Thu, 22 Oct 2026 20:54:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F2636B031A; Thu, 22 Oct 2026 20:54:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 807296B031B; Thu, 22 Oct 2026 20:54:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 54C266B030F
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 20:54:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 364911602D1
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 00:54:04 +0000 (UTC)
X-FDA: 85352069208.07.D67B021
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 91AF740002
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 00:54:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ckQTyi5t;
	spf=pass (imf04.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792716842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nYW9SB9bemiFfYhVQt1sKLx4FrVO5SfLiirdrRHkEdY=;
	b=pvBkynXLQTDDVyFfb3cf9LCAQIXLwT+WMFNKtktsNE2zmbzIfQT2gxel+Xx8xSfNFQig3Z
	nEpOk99AVetCyOmQZo1Xlh2oAGH8P81k6/1s/Ompyc1dQOt0zV67g+b7M6xhtzV1EwSkOe
	YepIdRSMLpPGns1PaUWHGI4v7GQo5kE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ckQTyi5t;
	spf=pass (imf04.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792716842;
	b=xbBbpdVXCss4xOk7//y5E3yodMOmNjPFg6MHeQ/6m9BpecILLHXgUCLEVMjG6Ea1/rAfR3
	9oWjI8QP3AgmMpzDqZHj3138g9hISXnbKTxaHDC3ZMUfAbn+PgYqBuUfmTJXi+AIUsjxdw
	Vh541vMPt5dhx+JjjDBYfEVzpexk9V0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CB61F42E46;
	Fri, 23 Oct 2026 00:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6BE1F01825;
	Fri, 23 Oct 2026 00:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792716841;
	bh=nYW9SB9bemiFfYhVQt1sKLx4FrVO5SfLiirdrRHkEdY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ckQTyi5tq4/uNcGqzn0KrC0dZAdPhP/AtBfqNIwiBRoxxCCUvlBw4H1j+3rB3M53r
	 jpJQZCRg9VLrGMFib3wkr2lp8KeoljEIShPdDkA3ryT0MmkYynXQawdcEx171/gsDc
	 KUc3enj+LPcxyRMpLzF1bY7CzpZPRiq+oM7b036qeX0DhVbxhesZ4ZGlBCu3Jw/7px
	 v5Aa+OZT3wA/Zm5LV59lZsIocOLhltNd8hqgejsmGrhBZJcT7fECtijN8iylmXOYpY
	 LQGALnFQQe2Tn26eRXn7ZUBDzU9rnDcE8EhPLzf67NPrQFbns2cx+RElemCH3D5lZb
	 FYrI1CATMzysg==
Date: Thu, 22 Oct 2026 20:54:00 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Mike Snitzer <snitzer@hammerspace.com>, Chuck Lever <cel@kernel.org>,
	linux-nfs@vger.kernel.org, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Matthew Wilcox <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v7 4/5] mm, iomap: let an uncached writer complete its
 shared pages itself
Message-ID: <atqwKE2fJ1mH3s4p@kernel.org>
References: <20261020220346.28020-1-snitzer@kernel.org>
 <20261020220346.28020-5-snitzer@kernel.org>
 <39b14c2a978ec71138492debe95d883aebc3cfe5.camel@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39b14c2a978ec71138492debe95d883aebc3cfe5.camel@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 91AF740002
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: ra794h33ttnrmxfh4mjcqj19eo4qrzjm
X-HE-Tag: 1792716842-541075
X-HE-Meta: U2FsdGVkX1/C4eVSWkWNWHB0+DkwwNmNVwN4tWQELQ33bFMxwMokUEaxmMdC9xOYpCbfU8uvTLlQztALVtlmERkEhkDv8HVeOwOVZF3+3BfUBwvmfo4ns9cxIe/RxygAihA1AqPFQ6FSbPTvSoDlnqesxpJ4ziipu8WlaQhz+d8qseXRPzrJ8rpMWXy6REu2eGBbhuALQ+WLlofMlpqLTcBk1eP02P+/B7NpRs0NWQYgKOD2b27X3DgC5N4efHH3wWCHiKS2L3Xqfxrnm+sy/wyhmyDIvrkxG8HrZfG8M0+I2DSJxZ/485ld5DRypAQ+QPYeCPF3kcIc5bRvdYJIbY0kJUYkOtcg/F/PbjB1VVfz1TkS9woTU7dLtG4dxCa+eKIimujqtQnU35cicLagK5rt56+oemF6pWpLI8B1kjqUsmjTcrTVxFLb2Tj5/a+NwwcQbpUqbkn2uBcgSUPCVm+uxvKCMGWwkLIi2jB5+bsNi4BkjqTtX7bRrqsGqEN3ZfhWPxih9sv4q19k8zMxwx8Rz4wW5+amjkhPu6ixZsRKjaF8mZ83FVd/YALrMRrN45OPMmxzukaGHn6hEcf+8Gfo7Xgw2Jf8DVGvPStIZdZ6SpF0wnfo9OunQ8ArphpuDfbBo8HYdPaB7ujpi9DQZqtkBHJUuSHIpAfpLUWN86iy05cTfS6+oBnPl27mcj+rE/K7dAozF8qPwpikw2KjvtiBKtji+wMyxXeBCLSLzo49l8OMx3hMht7kJCyj2k2G3zOgvSRMnwCO8bIDEppRPNL+F381q7CgWMUPt2sAfNpvRthY9yLl8DgrmSuQFV1b61lpwBOJdfqU2L4pPyixtvmKQRc+ptij13di3hKr/uDeInM1jIwg1TIDzrPEAps96Tv6kHZV8gn1tCUZt6emA0pw3ZmUsT5+EFXOIZdMj4a+t2ml/utpWEHZW1/nraTrt4cxQdawHHJ1W+c+zA4
 bS/IzvCr
 iHcE4vCfMC1lw/u0nYOq+WZLVdCXnGOTGmxUJiKOtm/LMeQ6chp7pT+pmM94hTFRE+I/+9JbHPcQr70ojQbkQEx+qXefFHqlQ7XTzVs0dh+InnvKf91Sa/3GA+7Pr843NxLUjoTUCRgsuMNsK3HY7lKW2E6Hs4drZR4vvCigqSovj5HatXVsAd7PxXCzgoP319Vhh8zmYKKWvlUFtAzBebJ1fnbFeregMQYr9fqdYDu/JVtSIVxK6FgDPmmi0omJsulNiJJ/TYONHPzFrutaEG+GhBsLa1tQ/93eFVohkdMzcAFNSR5dlJ0g5lYI+ftOk/cTHLbIltHGwZWw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 06:54:14AM -0400, Jeff Layton wrote:
> 
> 2 comments from Chuck's sashiko on this one:
> 
> [Severity: Low]
> Could filemap_dontcache_edge_complete() in mm/filemap.c avoid missing the
> immediate drop when another task acquires the folio lock between
> folio_unlock() and folio_end_dropbehind()? In that case folio_end_dropbehind()
> fails its folio_trylock() and does not retry; if the folio is already clean,
> there may be no later writeback completion to drop it, so it can remain cached
> until unrelated activity or reclaim.

Yes.  There was no reason to let go of the lock first: the folio is
locked and we are in task context, so v8 drops it with
filemap_end_dropbehind() before the unlock, as folio_end_dropbehind()
does once its trylock succeeds.

> [Severity: Medium]
> Could filemap_dontcache_edge_complete() in mm/filemap.c restrict marking to
> the boundary page when the mapping returns a large folio? iomap_get_folio()
> in fs/iomap/buffered-io.c limits a partial edge request to one page, but the
> mapping's minimum folio order can still cause __filemap_get_folio_mpol() to
> return a multi-page folio, or the lookup can find an existing large folio.
> This helper then marks the entire folio for drop-behind. For example, if a
> caller uses deferred completion on an XFS mapping with a minimum folio order,
> marking one edge can account the whole dirty folio for DONTCACHE writeback or
> invalidate the whole clean, unmapped folio. Could this path handle only the
> page covered by the completed edge?

Also right, and it applied to 3/5 as well: the folio a write finds
uptodate there was marked whole in the same way.  3/5 only creates the
edge as a single page; a lookup can find a larger folio that readahead
or an earlier buffered write left, and dropping it drops everything in
it, including other edges whose second write hasn't come yet, which
then pay the read-back this series is meant to remove.  A folio can't
be dropped in part, so v8 marks a found folio only when it is the
smallest the mapping allows, folio_nr_pages(folio) ==
mapping_min_folio_nrpages(mapping): a single page, or a single block
where the block is larger than a page, which is then the unit two
writes share.  A larger folio is left unmarked, cached until reclaim
as it is without the series.  That is in 3/5's lookup and in both 4/5
helpers.

Looking at that turned up two more places that used the page where the
smallest folio is the unit, both fixed in v8:

- 3/5's iomap change decided that a write covers its first or last page
  only partly by page offset, so on a mapping whose blocks are larger
  than a page a write starting on a page boundary inside a block didn't
  ask for its block as an edge.  It now tests against
  mapping_min_folio_nrbytes().
- NFSD cuts a misaligned end of a direct-mode WRITE on a page boundary
  (80728157d1bd, "NFSD: cut a misaligned direct-mode WRITE at page
  boundaries", in Chuck's nfsd-testing), so there the direct middle and
  a buffered end could share a block.  v8 has a fix for that at the
  front, so the end is cut at the smallest folio as well.

Measured on XFS on an emulated 4Kn NVMe, 4 KiB pages, 32 threads writing
interleaved 47008-byte records, 1 GiB, 4 KiB reads per write from the
device, v7 against v8:

                                                v7        v8
  RWF_DONTCACHE over large folios readahead
    left (pages resident after)          0.94 (6%)  0.0026 (100%)
  RWF_DONTCACHE, 16 KiB blocks              1.62    0.0014
    (12288-byte records)                    2.89    0.0004
  NFS WRITEs through NFSD DIRECT,
    16 KiB blocks                           3.46    0.0016

(v7 in 128 MiB runs, v8 in 1 GiB runs; 16384-byte records, which cover
only whole blocks, read 0 either way.  On 16 KiB blocks one block read
back per write is 4.0 here.)

Thanks,
Mike

