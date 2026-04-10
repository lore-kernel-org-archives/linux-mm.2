Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73E9FF44846
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 11:58:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5F696B008A; Fri, 10 Apr 2026 07:58:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D36B86B0092; Fri, 10 Apr 2026 07:58:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C73996B0093; Fri, 10 Apr 2026 07:58:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B90056B008A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 07:58:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3B3721A04DE
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:58:09 +0000 (UTC)
X-FDA: 84642497898.03.D732768
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id ACFDA40009
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:58:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UtHphArR;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775822287; a=rsa-sha256;
	cv=none;
	b=Gm4vukSYXOfXa3C5gFERqaTDTjRbgNYbb49aWC663sejo2fFv3VZfMZ2La2P0XdUShp9f8
	unZYySrR+vKEKHVZGiGZnFKar6XlB0aXcajm+XL/yKTkRDz1CVff4gSG4sjCZV471S5sFc
	5gINMV+uljyojYuDHKxAAtsJXImPmmQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775822287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hW/7P+Q9ewTp+Nlxs63eE8WGljMMtGMjz8FRskYNhcA=;
	b=xOx8hvvJkfhX9O/NtOX9fyKnifs1SqTMJWxam39Jq2oG9hP7AL71YJ2ZMqh+/xpjw0woBJ
	5oiylgKtlra/yO9Cy1G0FtWy0amVPyEbXDJKmfIIoDVZuLZoi8xDIJ+sBDqKHZchD1Art/
	aTaPo4GSbSU4NdDTaAeE4P1ucD5SRe0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UtHphArR;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E2316091C;
	Fri, 10 Apr 2026 11:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48805C19421;
	Fri, 10 Apr 2026 11:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775822286;
	bh=1IlVya3cDWf4jvwWxchg1KQjmwkbJ5Ag/jKFwWp3CvA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UtHphArRe3+5ugz15PPQLf6OUxnW5LjX8Uc0gNt4yDfRrnoVH5t/QvmsRE8v8eU/G
	 sRJBY0NdCHSYQbYIZWfu2YxuJDgJoKOz6l60yejqkGC8+Mfk7oBJNHXmQ+Z21ZbNkc
	 04yw91ZIEBNPLKwXcj1PzNAqLrUBNItgu1itsAuNmxJ4ggjgvHYrDYnph59t3oeG5Y
	 tNthufSoSeozDo1o4+7hZqxC94QnPrqhFxjsqdc4Bjqw/01zMPYQrWYnXNDpU30g8e
	 UmR0k+lA0oE3rNHj4yYfHTr9q8EVyi9xhAYeMRYukwGGyalwhuE5brmODVtAu0aDgi
	 LkDH/7lAFYepg==
Date: Fri, 10 Apr 2026 12:57:56 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	willy@infradead.org, ryan.roberts@arm.com, linux-mm@kvack.org, r@hev.cc, jack@suse.cz, 
	ajd@linux.ibm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, brauner@kernel.org, catalin.marinas@arm.com, dev.jain@arm.com, 
	kees@kernel.org, kevin.brodsky@arm.com, lance.yang@linux.dev, 
	Liam.Howlett@oracle.com, linux-arm-kernel@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mhocko@suse.com, npache@redhat.com, 
	pasha.tatashin@soleen.com, rmclure@linux.ibm.com, rppt@kernel.org, surenb@google.com, 
	vbabka@kernel.org, Al Viro <viro@zeniv.linux.org.uk>, ziy@nvidia.com, 
	hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev, leitao@debian.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v3 0/4] mm: improve large folio readahead and alignment
 for exec memory
Message-ID: <adjllNan2vgBNBHJ@lucifer>
References: <20260402181326.3107102-1-usama.arif@linux.dev>
 <803a0c15-0a6a-4c00-b6b3-eaae56d5fc15@linux.dev>
 <adjkCOiLgZ_-zovg@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adjkCOiLgZ_-zovg@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ACFDA40009
X-Stat-Signature: 73iiwxa7ubynuc19ij3nahw9d8mxiifg
X-HE-Tag: 1775822287-429697
X-HE-Meta: U2FsdGVkX18qafjqrwSTCPdfWufBTsNPVkdqk8tdNygI/beMZ/SgGAfoYPtu6Gd4/iHfhw97X0hjEEFONjpLID0bj4t7MuV/vfsZZiwIP7PueXh3QfU52vMtFemDMtujcIPbjisYkv1ROmM4DokSB/aHsMr/aqMBYDnspIDkGh2wGZ1JdG7BO7V1CFAP0I+zhb4XKv+nFXrC+GGYYzXE2guXYq4R/yCsbp0WdtuW8lPb4Hi6XErp6vS48Xh4Su4X6LNDgd4roEQiNRpuGBMMGhDEf8PditjXijvERZny7xilkUX+BiJcCQeyE3EuwMxo0Cz9YkbkE0uE6cczhneuiCEvWdcaCcZpb4n81rBS9pIrA3tprXPKsm0Sbv3RJhU+c2Aof3YoA6MIlFmorCgut50uVz/URZwfjR0UlINMeXX45z/o2NGJYhg1i91UMRsY3viZfBjA8MRCHGEXlAv4m6oxcOF/crDiRH/Vjy0Lwj6QxyiZRUivFzMGz645yCQiJftx/iXHY3Ai9CqYW6DUEYVE4qsNFJxpHtM537CiLfOSG0X8l3K54DrT6wIvGcH+musI1E6SO5TxXs4WtdgcKFqYTubs6zIgryHII50YLO4Z6T/yrjJdQAjv1axJQ6ALxX+ljeSU2vQMWVz/MEIHnIPTEiizaV13k+0lB1LYzb2ioCkfOoSOdb7g+r6u07NXmGtRRqg8XI8ih5BVFBbycu3csx8I5EZhpL6mCwP/y4qNkQgLVmePhL6p0yXhlquqVShp9VIMIexPSMiBO99+yUIb53qkJNmMCBmUa88QAX6ffMsSoMqRryx8ONpdyE9B/2UYvauJJOXuJ6cs2MpFx18amwcx1KYrH4R27fhRUCdSqBy/Zn8xN37JtlmF7NSA0DcPVH493Did0IUqeh3t0l0luBTmpBWlMKHFHAp0++P2gDTa0zFBnOM/Ju1EoD7DgUz4OCKw8Dakusp/TGN
 gc38Asn1
 E0gqfivL+TrCZHvrBfJupwGhwL7W+AWtWrYk1EYEsZY46bjfpCBA2J8SBnwFs5vZpGff4nJGUEzhzui1NGjD8fiFi56+i97gAtJhzr5pvlVBjnLjPmQlV2bBdg80DTaSG17NgmhYvURAvEgdMiqlpm7vjWDrXWGWqhW8OTht+gMDW3C7ev6vhI1PV/56sVt8pvnWqGZdDMQsV4Y3ZzEDQE9/CrI7Q9Lz/QlMVppYHZGXxy+JbQt+Ahr//DO5epDY3375jDvPvFGG3O2DuQka3P+gulg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 12:55:42PM +0100, Lorenzo Stoakes wrote:
> On Fri, Apr 10, 2026 at 12:03:03PM +0100, Usama Arif wrote:
> >
> >
> > On 02/04/2026 19:08, Usama Arif wrote:
> > > v2 -> v3: https://lore.kernel.org/all/20260320140315.979307-1-usama.arif@linux.dev/
> > > - Take into account READ_ONLY_THP_FOR_FS for elf alignment by aligning
> > >   to HPAGE_PMD_SIZE limited to 2M (Rui)
> > > - Reviewed-by tags for patch 1 from Kiryl and Jan
> > > - Remove preferred_exec_order() (Jan)
> > > - Change ra->order to HPAGE_PMD_ORDER if vma_pages(vma) >= HPAGE_PMD_NR
> > >   otherwise use exec_folio_order() with gfp &= ~__GFP_RECLAIM for
> > >   do_sync_mmap_readahead().
> > > - Change exec_folio_order() to return 2M (cont-pte size) for 64K base
> > >   page size for arm64.
> > > - remove bprm->file NULL check (Matthew)
> > > - Change filp to file (Matthew)
> > > - Improve checking of p_vaddr and p_vaddr (Rui and Matthew)
> > >
> >
> > Hello!
> >
> > Just wanted to check if there was any feedback/review on the latest
> > revision?
>
> It's -rc7, this is definitely something for next cycle :)
>
> On my part, my upstream bandwidth has drastically reduced, and review is
> probably going to have to be a hobbyist thing at least for now.
>
> Also, not to be mean but:
>
> $ git log -E -i --grep "(Reviewed|Acked)-by: Usama Arif" --oneline | wc -l
> 21
>
> So... :)
>
> Review in mm is very lop-sided, let's try to balance it out a bit!
>
> >
> > Thanks!
> >
>
> Thanks, Lorenzo

(Note that we're in a 'quiet period' from here until -rc1 of next cycle and
won't be taking anything new until then. We plan to do this from around rc5 or
rc6 of each cycle in future).

