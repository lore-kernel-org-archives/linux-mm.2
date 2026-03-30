Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADFC210D14AD
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 12:56:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08AA86B0092; Mon, 30 Mar 2026 08:56:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03B886B0095; Mon, 30 Mar 2026 08:56:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBADA6B0096; Mon, 30 Mar 2026 08:56:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DA4116B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 08:56:31 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 77A0A1605FB
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:56:31 +0000 (UTC)
X-FDA: 84602728182.18.331E961
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id E266A140004
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:56:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=HIqM33CR;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774875390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ABb3mCmxINvfC74mwIx/aFMr/5W/YrJg7LRCk/iB4A=;
	b=5w08ywH9392hBMBP0TdeAYd2aiua+TxTHCGfL6XQH80tJyAE4Rpkhk2FITiZQ6vhvr5qpj
	lJR0vclmAcF4SWZ4zFJJaf/K0KwS4bOY8UU12fSrGYoM8/+SCJKmMRiDJ5lfmJbWr2q17A
	Ey2i0QTpCguaDfdrWkD6U1xouZfpi40=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=HIqM33CR;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774875390; a=rsa-sha256;
	cv=none;
	b=AQ8dgDdXlKM4d8knNlgUDoVY1au40HX0yn2CfMmuKFFWjfdoiBxHy/VtRsS72kMdCzshcF
	8HSWzIkMTHmpKPsh/pMl1687Qef6HRPhUVhWzpBLxUH+OAA6uA7zVruAIYsIHT5EPrIBfx
	cYWxHmYS5pmR3hi3kcwl9WRS4HYK48w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6ABb3mCmxINvfC74mwIx/aFMr/5W/YrJg7LRCk/iB4A=; b=HIqM33CROqAhISIXKTEGIZr+1O
	bfqwa7rBYHRXXoGMNNncKV7ZqE/BQVqqNEY1+Vb4vLrFrpdabkJVms6fUnwJr5c1yMrzTIJgWV0ZK
	DVffrdyimh2J265xgwjnUlEkVa9ZyAomWfYJ8bsS3b097CgBA8e568vhSyMBl2xIvtO8GHH8XQJuF
	7v6bhdX97EaFCxpQ/pFgL14hRrYowpHKUF4Vi0v2DaDbugPZsiwh7a3MNLMG9ODGO9r6TOjOPdn4c
	MOiUJ8nhTS2w3wDLH0/nHuIO5uPc1MYZHLHeyFhK5ECQN/DF0+yLRGlim+PAOoYcVwpAXSARgi+X+
	/r/DNaEA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w7CA4-00000006gVN-2Qj0;
	Mon, 30 Mar 2026 12:56:08 +0000
Date: Mon, 30 Mar 2026 13:56:08 +0100
From: Matthew Wilcox <willy@infradead.org>
To: WANG Rui <r@hev.cc>
Cc: usama.arif@linux.dev, Liam.Howlett@oracle.com, ajd@linux.ibm.com,
	akpm@linux-foundation.org, apopple@nvidia.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, brauner@kernel.org,
	catalin.marinas@arm.com, david@kernel.org, dev.jain@arm.com,
	jack@suse.cz, kees@kernel.org, kevin.brodsky@arm.com,
	lance.yang@linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com,
	npache@redhat.com, pasha.tatashin@soleen.com, rmclure@linux.ibm.com,
	rppt@kernel.org, ryan.roberts@arm.com, surenb@google.com,
	vbabka@kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH v2 3/4] elf: align ET_DYN base to max folio size for PTE
 coalescing
Message-ID: <acpy6DLjPVXXzwJX@casper.infradead.org>
References: <0725ce97-b8a3-47c9-952f-7b512873cc35@linux.dev>
 <20260329043700.19355-1-r@hev.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260329043700.19355-1-r@hev.cc>
X-Rspam-User: 
X-Stat-Signature: cgakqrfjabuwmfwa7xxt6na7kxwm3fkn
X-Rspamd-Queue-Id: E266A140004
X-Rspamd-Server: rspam09
X-HE-Tag: 1774875388-230183
X-HE-Meta: U2FsdGVkX19geAebuQK6Cu9L1g+MqYBBtiPchTvw5FrCccxj7m/peZcMJxIKE0xSWVlh88UJGZyPI/a+vUreBeiI3MP6BxP9zM7cwGz7062zDRE2cVhP58Sb88PR4QRBXPedt6Wp9xmnHhr7hEC7sY5PvFmZ5CA4M9g2etCua6b8rjlTe10uorm+59Gd/NMESwcdPaKvtFuzgPzZwWPDBMpZQJqeYp8MbtKHuWNQ4a75AF4wNay6+97u3EVOvFcdA4aoxzawYC4idjInUIp5yuFAkalkw28zNs0Z1t2VUAf7GWPpyYibv4yqoBZIrr6CAQLAduPYQ17yRQqY5kHflTaL0NyjXOMB04c831xkaFg+Y8o39pG2EDSfXDtmN3991Y8GaH1fsU/+V34CrB9WBF/Yyos2t0H2JUtHECS/X7rPls4yPTXJDS+MSDNKYkHonKuE0Wit3xIaYKtpPbP6luzTsauPEGKy/Mn4Bq85b6+WiU3g1j3944A393XbWUshZMt8lnuLAu0P1TrFjPeDtOJLISlaqbJONIwIVh5vucD5mY1rLKfF7YW8038xwr56eSKhlapVsNsnFI22TP+W3O3kOa71gCFYVAiz5pKzAbPt1Hya/UoIUj1mjbthxvzRE3YFN9KKsFUAIzBLCdEDQH5i19AbSioBsVDqKwpGHZNsZvOZAdftB/OiDa/X05+nzfEJNrX3qTaqge4zHKsWM3eY+zR1kV0FNScxO+4U9UcF0t0dJ7yFVVx8+tY1H4qepzzuZgrc7fNANzIgyplyyU03twugpCcxSoal6S/oqdDTjYdNnVHph7ZiXjPJ7y64SWc07KWBUe/895lmIVYjgMP7ZIMDGD8YeZNfbDO0yktNsfXREghZsqqCm+ScX3WECkIVklTk5sH1pZXEyFi4In12cwdpu2Zg+2xHWf8qrMeTdZcPVB7JppvDxwdQykLF57qK2kuqbvXzYG5zxSU
 FRH6o95Z
 4zVaBawcjkNHD9aFITeoqY8k3hLl4QTo6R2EF6tNs55N1ecUFOvCg6hd9kqOIdPesPrFiRdNcKHyL7VBwJBTJDD888nwuvW/L7xZ4tIGzLENcuYAHM2WEEcS3eK8fMi9Xg4S2UQrWHWKG00Cwb7kFCILEAUupMbZtT5PNecLC9KMr/u4k0r/M/pERSZJBH2NVKTceaWhuw2SSdNG7xwFijc37IxK4zALOuU0ODmzTW2CKNgpPFGA4O2oHzY8DrcMekUjL1UCEzj26L75X1GjQR7MYDbhNnQeZlKefwSuIMts3V+U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 29, 2026 at 12:37:00PM +0800, WANG Rui wrote:
> > mapping_max_folio_size() reflects what the page cache will actually
> > allocate for a given filesystem, since readahead caps folio allocation
> > at mapping_max_folio_order() (in page_cache_ra_order()). If btrfs
> > reports PAGE_SIZE, readahead won't allocate large folios for it, so
> > there are no large folios to coalesce PTEs for, aligning the binary
> > beyond that would only reduce ASLR entropy for no benefit.
> > 
> > I don't think we should over-align binaries on filesystems that can't
> > take advantage of it.
> 
> Ah, it looks like this might be overlooking another path that can create
> huge page mappings for read-only code segments: even when the filesystem
> (e.g. btrfs without experimental) didn't support large folios,
> READ_ONLY_THP_FOR_FS still allowed read-only file-backed code segments
> to be collapsed into huge page mappings via khugepaged.
> 
> As Wilcox pointed out, it may take quite some time for many filesystems
> to gain full large folio support? So what I'm trying to clarify is that
> using mapping_max_folio_size() on this path is not favorable for
> khugepaged-based optimizations.

Nono, that's not what I'm pointing out!  btrfs is simply not putting
in the effort to support large folios, and that needs to change.
READ_ONLY_THP_FOR_FS unnecessaily burdens the rest of the kernel.
It was a great hack for its time and paved the path for a lot of what
we have today, but it's time to remove it.

