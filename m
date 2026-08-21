Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C8CFC5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 20:39:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 560DA6B009B; Fri, 21 Aug 2026 16:39:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 537986B009D; Fri, 21 Aug 2026 16:39:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4758D6B009F; Fri, 21 Aug 2026 16:39:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A1526B009B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 16:39:02 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 20630160240
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 20:39:00 +0000 (UTC)
X-FDA: 85126440840.23.B7BB0E4
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4EA0E140009
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 20:38:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=NQRzIMPf;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787344738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hPUCAwEXwmsDm1Y08aAC+83jadz2wtDI/6cWny3G4v4=;
	b=wzoXpSk2MmC2fgp1G+Eny9TVHtTdQ9fZlL1jK+IYXAL+aTFymgXkwUXbYDDTlJWcoODHfl
	8wYnsGRDSUjGiU6GxRWDoIvqYVTILi0oVfwLcw54MHJB7JqD7vkEcMlyePT8FxK9/WRhZ2
	OW92RoW+oI9R705QrCsR+Btl+k9J5p0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787344738;
	b=mwt0sPKYFPCK8Vhl6EOwgpWLU3OElPa2W7ib/vf7UyjseG3rsfAMBUZmagvCPnsuETDmDU
	U4rNA/L2ZO9cO5bQGtHcuNpiXXpWs33wdXqDcx0lixdOR0MGGAncb6ZLNnjzQlB3r5ZDCw
	ngueCLCMbpt6GvpUFQyB+/CCrSZ7gt0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=NQRzIMPf;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51bfad59921so8745281cf.0
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 13:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787344737; x=1787949537; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hPUCAwEXwmsDm1Y08aAC+83jadz2wtDI/6cWny3G4v4=;
        b=NQRzIMPf+Aj7d8gs9EJDWVyTx9JtceCdZN14wPq/Vt/lE8V7P3NuytFWrHlaVG9PmU
         voxUOPWp8Uy11AXu4kOUqQge17CYILJ1bOwiIm3s+s8umdUEkJM5TbQvssEcvtS9qC+3
         3nbyWbteP9X3rG9VXi3sbBGZUgtkmuB6vcRj6hqVT7WiyKC4fx6sGuTbZsHejhNpDEGb
         ofou/XXkaUixtyTXfXwlCRVPVgWnBgrs8Kds+DIRzbrT92P1q2/zAdcLKVxBJBkvIrTo
         FOUvFUrOD+fHXrN9Y5nQCSFBVSm7Q1NHNt3SRYjTVLZUrXQcuhYkmBK5wBHNpWcccPJF
         WEzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787344737; x=1787949537;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hPUCAwEXwmsDm1Y08aAC+83jadz2wtDI/6cWny3G4v4=;
        b=qE9hR+Innehgn7cwU+ZpgspUBEdulvTFgo1Epud2zTJUovQkoGxEshpZF8M/HUz7jU
         big1mDx38M/h5FiKsen3qT6cpCVJWQnWktF54DTZtr7p8rm75Nq0lbiR4ryW7Za0H1c2
         5fsfvgorPgtFEci/drq2F3T4ZQCI/qPEhsBHX4Jlb6WksvLtnMtKBeugk/e3/phFp+ti
         icNnuD63MXfCXpRsopvXKSVgf2v5V8GTllZIsXdi5PTPkFqgcI8eapx1l2Yf6InR3Ly0
         L+hLUXQn3c0L8yjDCgpjGHtwLOtaVXG/GjNEOZlQ5Jr0QfniGX9LLRFFL1SREoVlWk0W
         HFCQ==
X-Forwarded-Encrypted: i=1; AHgh+RqNt6ibt2CYNvtyYh1GvL7Scc+sPKnMRBRS/Rr886uFYyODs2bH/orHVT4vA/BCNEJQm8h2pc3GOA==@kvack.org
X-Gm-Message-State: AFuF++mwRUxWQQQpduuMDTmiSzdtyPJczKJ2r5BRm9wPQQSzVB8HL6iG
	lhNcEaM9p75/rYZQ9FwQp4dR9kqFMjaz62p6d+YwUKngrOI11TqW9wuoEA4kkiKherQ=
X-Gm-Gg: AR+sD11VIEqwumeJf4dcMMu1rIiUKwmJDRUBW7Xf96xbny48jvsu/YdOOwY26qzGHp2
	KGYUR266o9x11ic0coHimfVquGmAjtksRJ+hfVYdVTJciPbCflSETRWo6tzf8TDs56y+qBKR2xb
	6RZObo7iTk9XVFV47lqBprFbMrW0gws25E4fkEGBDdbKEsyC/vokWi3Xwf1ytw8TIDHzUlkiahI
	aM3u+42y+eRfOUN5l3oIW8KT46AHIR5PWFQPsrEopW+HZxIXx1LBwNqVZngJk42WIJIh3CsEo4j
	6i3n07ySIamNKz6vL2sLR2M7oi78a832dNxlqdctRm5Bj4qf1Gc2QTXYv9VeVljqRaPGRXAZiFF
	pRx+dMFjDGBok/A8QuAEjN11y8LHm7hbUWLq1fIfJw35RkmDnfobeBeEmQAPUI3FZmHReQxFXUm
	CkG0CHSTs63Nm3XOz4OlzIZS/FSla5Xlc/O1A1e0XA1VrKIcjh+87bihk3CCyDE+j/3BRpyoxs2
	SFz7i6v5a0HRw5LdJP8b9ZGQCHyYiizJHv/D9sbY6iCJc/i5ukkNAc=
X-Received: by 2002:a05:622a:991:b0:51c:f3:34e3 with SMTP id d75a77b69052e-52df5a34145mr94885981cf.28.1787344737418;
        Fri, 21 Aug 2026 13:38:57 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c5edb45besm71093336d6.2.2026.08.21.13.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 13:38:57 -0700 (PDT)
Date: Fri, 21 Aug 2026 16:38:55 -0400
From: Gregory Price <gourry@gourry.net>
To: Matthew Wilcox <willy@infradead.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org, 
	liam@infradead.org, david@kernel.org, vbabka@kernel.org, jannh@google.com, 
	sashiko-bot <sashiko-bot@kernel.org>
Subject: Re: [PATCH] mm/madvise: use folio_trylock() in the cold/pageout PMD
 split
Message-ID: <aoi2pQecMUndgFzo@gourry-fedora-PF4VCD3F>
References: <20260821150912.183976-1-gourry@gourry.net>
 <aoiWZjgcitp0nSk0@gremlin>
 <aoirfBmxkQA-HwJ_@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoirfBmxkQA-HwJ_@casper.infradead.org>
X-Rspam-User: 
X-Stat-Signature: 8pbdim76eftpy7ns7s7s83hwx5s5n4i8
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4EA0E140009
X-HE-Tag: 1787344738-886754
X-HE-Meta: U2FsdGVkX19Y37AUK2Kik0X16qZTOjdFsun3KhxyWj2n1o2sW0sTC/9bhiREkiHsGCIpWn0o+wUYVvHH9GakVgEhRQ1RxRkL3YXjClFnEdPyesjEjPIBy1v13WHI+l4/jj68YQpNuT1GUAMXz94v7oXWZkTpCm5VU0z3b+naIbwBUpqh/wM9nLJyRjEG7UuD95qn+4cNbtAwRYR9Y0CCeKPleGoCiq7Ng3ediYRJEAL6ZM47S+iiKWY1GR3QrtfWCwb9O3QNSqFug7b6x9MTtL1XRAK1o0DWOcv4wAt1mSF0+sfYP0LSykXyS0BsV1oKBA5/p9hv3i1Qjrne+HCxbTpUq5pYYaRDdoQTepdxkOOBs1w9TGUZHGMk3TrjW11l79adxlWig0JLK2IXariQXeyub5ri4nGq96foJCaaS/Uulls68BZ2XZ+6HIlk49GOYCxf2axrefZTPxw8ycDSXKHmIZc26+w6qEbcRLnWa3NPEyLqtrvPwTH0DoT65Oe8OrdvZO06Sfv4zQge1970Mq5d9WqMJtAV4KIaSRDzSylGL+NjXdGxgpYhVfTeLfVG3O0PPEZBYsqdKmlTSUmz6mhCYZPtEb6mwTSJCtApPXWo9Tbag+cZbl+tRU4C1WLXQkvg7wgew3P85FohY4mXygnJlKtkirs8Aad3OmWJ+FvdoY7UyxILUe594D5Po+XaDfwRpvXeNmddWcE8aHLFXiIMUg7PSkx0ECbAEAA3ldeATrQojiEsW7RfE1bKiso3rYUk8TXwMLEN9Qt+PJcOzTKSqrz5l9g0w3+1j00ZRBf0NP6w6he1TvyRQJCOyyHV9+TSsxP4oZQqU/nnbsCJ3NrnVJw/x5yWFvihXH9lxPoC/wNtQ/8XHgFHxY/pG/seKgYbDDzuiI/mE1j/KLX5xzAbHTwsOkfxSd+Wr+uiy0ZPcKo3MlapjupMSRsOMtvhDIBMNuHUqNqDCPRRRq7
 iWFLZkWg
 EPLvYnjPeiv3bCLHk6Bqy2ZUdENzkp41A0H4nUSpwG8b9kz5SS3XkgFoAf9nz1iUteZ9EOhdWqO1zA2ydSKpnBcLRrXJBosLvHA6sKp2PKcvw/OmtGK80niHpOl4UFdpaiEFCe2OnIvV6Uwx6IKHkEkS3eQWGnIueYbbZY84G3GslO5AXsVKJW6f0oY3+yI8MtTxUOT0RgKAHCPmbAN/7K2JkhSqnk8yBaE9ZJV6jnfz/6htC76nYJfaYCnt5Pbq0Q8GypATz2bpfZ5BxFqLjT8V4lme8ZQGS3/nvJ8PgARr6n2sSiWTsDuZr8Napcep7LZpvXsNXmMTJE/fUUy0Mpie8x2tp+Vrdpy1tPczb1JWQD6qej66xdtpJNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 08:48:12PM +0100, Matthew Wilcox wrote:
> On Fri, Aug 21, 2026 at 07:23:34PM +0100, Lorenzo Stoakes (ARM) wrote:
> 
> For the task running on CPU 1, yes.  But the folio does get split rather
> than probably both failing.
>

Which, thinking about it, this patch actually solves non-spurious
(but exceedingly rare) failures as well, since prior both CPU0 and CPU1
can fail.  After this patch, one of them is guaranteed to succeed.

The inflated failure count otherwise are the spurious ones.

> We couldn't quite make that work here since the whole point is to _never_
> get the refcount on the folio if somebody else has the lock, and once
> we've dropped the PTL, the folio might have been split and thus not be
> the folio we want any more (indeed it may have been freed, reallocated
> and now be a pointer to a tail page instead of a folio).
>

Makes me wonder how many more of these conditions are peppered around
THPs just eating cpu time.

~Gregory

