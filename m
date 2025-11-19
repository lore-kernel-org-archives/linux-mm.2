Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B084CF258F
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 06:29:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABB136B007B; Wed, 19 Nov 2025 01:29:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A933C6B0088; Wed, 19 Nov 2025 01:29:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CF5D6B0089; Wed, 19 Nov 2025 01:29:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BE5E6B007B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 01:29:46 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2DE4F888AE
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 06:29:46 +0000 (UTC)
X-FDA: 84126380772.23.F172BCA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6867D20007
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 06:29:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ICUwuB8e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763533784; a=rsa-sha256;
	cv=none;
	b=4X9Ky2fNI8mZOmPtGDoBRVBXlW+y1qPpimpaPfPZneIHKpL++Tb031cFYxsT7c29KPrnvi
	JLXwVWYYhewaQCS9qRGaqRhcZwjex/NMoMz+YUqQoD+Y8nMmMTfgb7mp2o+zqgx0gqf76x
	kNT+GML2yg69owyLSS1G+i8qjD71yZ8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ICUwuB8e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763533784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eGJD7bnct5uhIkUPetNRb4+fEAjom2vLxLhGWTIMuDY=;
	b=vSnnwSu611l586Hq0eV9P0MPlk4rMZVBmTCSX5SbVMAuPbd8uaUdOdR2jDdKSx7oDwGDCk
	N6RwvQ3HDkjdXKDwvGQY1VSNO7VZG0p8411FI1s1cJfPEseIQhv219gA3hU+Ni9KGPsszx
	NQhxF9RTEeh03nHWy0+mm7LcbqF8Fyk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1DEC9434A0;
	Wed, 19 Nov 2025 06:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80499C2BCB8;
	Wed, 19 Nov 2025 06:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763533782;
	bh=j4jzM65eMJ8upAfaVJtxFTNQTor5sIf6Au4okDTN5Z0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ICUwuB8eXhY6IyN+rUtf1idZGkjP6gvdnW4JPd1qpyAO4bXwdKdAlmzpB+dC6k+g3
	 nop7z27kCcURFARY1nR5/VBH9UKLGLDz7a0EiM+7L+a1p5gVAWHttRBOi+pCNN44Ce
	 z3zfJgUEyxI5S2MlrMdmPjOHR3e6VsLDQq6mRRJeQOSvzYPXE8rWo0m+2Zik7tcdm8
	 qDW1YnQ4F1E+1ce96CYJ5XMq8eEy+X/0uRp65LurPVFQIV9lFY5d43LxK215yZql/R
	 7XmAi9TqfpIhI2g3SEJgHS2dxrNSi7sl/ln/9aunkp81T9WPhgNqszZzYUGglYwWyH
	 BXidO39mzhX+g==
Date: Tue, 18 Nov 2025 22:29:41 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	SHAURYA RANE <ssrane_b23@ee.vjti.ac.in>, akpm@linux-foundation.org,
	shakeel.butt@linux.dev, eddyz87@gmail.com, andrii@kernel.org,
	ast@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
	khalid@kernel.org,
	syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com,
	bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH] mm/filemap: fix NULL pointer dereference in
 do_read_cache_folio()
Message-ID: <20251119062941.GF196362@frogsfrogsfrogs>
References: <aReUv1kVACh3UKv-@casper.infradead.org>
 <CANNWa07Y_GPKuYNQ0ncWHGa4KX91QFosz6WGJ9P6-AJQniD3zw@mail.gmail.com>
 <aRpQ7LTZDP-Xz-Sr@casper.infradead.org>
 <20251117164155.GB196362@frogsfrogsfrogs>
 <aRtjfN7sC6_Bv4bx@casper.infradead.org>
 <CAEf4BzZu+u-F9SjhcY5GN5vumOi6X=3AwUom+KJXeCpvC+-ppQ@mail.gmail.com>
 <aRxunCkc4VomEUdo@infradead.org>
 <aRySpQbNuw3Y5DN-@casper.infradead.org>
 <20251118161220.GE196362@frogsfrogsfrogs>
 <CAEf4BzYkPxUcQK2VWEE+8N=U5CXjtUNs6GfbfW2+GoTDebk19A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEf4BzYkPxUcQK2VWEE+8N=U5CXjtUNs6GfbfW2+GoTDebk19A@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6867D20007
X-Stat-Signature: 1frzjszterukmn4r5tpseb5yp3nof5sr
X-HE-Tag: 1763533784-529228
X-HE-Meta: U2FsdGVkX18ENyAmgz6uhmdcx52UBg/Jv043BdlDabNUHXdabHjY7lKtgzT5xcI2IG1Cd23V5wM5eMAFYF05kQb27lA2rCJ78JTLPLPlGOs7vJzEKBs5BgwEtKPPfcGxgHvmgK7e3YDwOOySgk6X2tC0m+//vNDGvfQ2eCuVsBf17nXr4EsDj12jNhsu4qwHMWF8Rn7GBjQ84UN0915aZQ03MWv5676BRNP+uMR5McRs8SaXMlsUe6gTr4VspCUE+K79jtE/L7GUgn2PQDpxI8bFg+diP7YQnJASrYLfV3gMz0BD/5iLVUj9SmhPz0Inx43Fe1OrlcUpmwdUPcfxMtXZG92k/XCdTFbIxcaa8T5EXQUqPggCZyIQaclZB41kTxuS9KCN938E0xt2civrRf4tAmS5JcOlJecNNDOHpAt8fqeyZMeiiRllq/RQ3FeTFna+t8sk0raKtzeqD/7iZALjMX+E9cpZNchlhdr6eE5TLtHRn0NiDpbA9P+arzjlRg8ehEBvWx3ht5AqoUUGTHDrRfJnAGs3Ymlo3C98dUodaIbVIZzoHckhXjmIaq3H9dL6GFQbA6qtXPzycunxnDiygaN3uzU8sTYgWS3/iEX2Zca9TiInO+wH7141eBrCUdvJuXt6HWYPpq5c74V7khdrGqNqHlvgKUGaMCwD+pZbbYiyai7ECAP7t0R93lFXyx5h6ea3xSn9njtHB56W4qejZXyx47yCchAzqESAnXCSyoPk2NJmGfZF7pULxJYB1Xq4xSdGWGn4Lys/BMxMABJY5WONqw7feL1AnkRWP/8oz7ghnOH3Xgiswv1rfJVyTSD+HCdY/HolK7SK30uK3MrSGsKdjI6cqr3NZ2Iyu0SB5OQdPJ5V9Nc6ubaeHjiMtPc0ysg+5zU0Wv6xKQrJ5gelI2EvT2ewHwkh8155UHgd6xPLRpoYzMTfXi8vZa/JYJN5DJeFflJhpd/5lok
 iPd4pRiT
 foYAQ/TvUCC0cMFcF+7Hry4J90PBFviwvQ96tlyvKlpgaTBMRWECqXPIIr/RUIsLWtcodZ02cEh1C4cbQ7d+/zdY1sgFJrk6ph4f9Z7CvlZbneJ2DTA6zvXAk3WlXDgZvjE93DFLX2KdDwocSshtwdoqzPn7G/u32pBmURDQZKSaJrjr2Pgg8wQLCLBH2cFF1OuJInsbpqerjPhaRcqldxSvm4tKOsxPWjUN/Oi/HbU0PlWpaclwd2jFViFuyzWGLnv7OgJHUCNQm+Fr1C9RM4CnHzQ8fE0WFxOyhTbxyNTejhpUt4in96KLGmxg4LukLI4sMTc/N9C/ZiOtM7PaqGQ2EwUoarmAQBIWVRReCj2LwogM/DujuvVExjFuKiKoI4qMQdenxYTT/scCNnxc31tJgcRNN7MhY7CRIpt0s9OHtfaDeZmmTePJrQYJzMHlunEnG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 11:38:36AM -0800, Andrii Nakryiko wrote:
> On Tue, Nov 18, 2025 at 8:12 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Tue, Nov 18, 2025 at 03:37:09PM +0000, Matthew Wilcox wrote:
> > > On Tue, Nov 18, 2025 at 05:03:24AM -0800, Christoph Hellwig wrote:
> > > > On Mon, Nov 17, 2025 at 10:45:31AM -0800, Andrii Nakryiko wrote:
> > > > > As I replied on another email, ideally we'd have some low-level file
> > > > > reading interface where we wouldn't have to know about secretmem, or
> > > > > XFS+DAX, or whatever other unusual combination of conditions where
> > > > > exposed internal APIs like filemap_get_folio() + read_cache_folio()
> > > > > can crash.
> > > >
> > > > The problem is that you did something totally insane and it kinda works
> > > > most of the time.
> > >
> > > ... on 64-bit systems.  The HIGHMEM handling is screwed up too.
> > >
> > > > But bpf or any other file system consumer has
> > > > absolutely not business poking into the page cache to start with.
> > >
> > > Agreed.
> > >
> > > > And I'm really pissed off that you wrote and merged this code without
> > > > ever bothering to talk to a FS or MM person who have immediately told
> > > > you so.  Let's just rip out this buildid junk for now and restart
> > > > because the problem isn't actually that easy.
> > >
> > > Oh, they did talk to fs & mm people originally and were told NO, so they
> > > sneaked it in through the BPF tree.
> > >
> > > https://lore.kernel.org/all/20230316170149.4106586-1-jolsa@kernel.org/
> > >
> > > > > The only real limitation is that we'd like to be able to control
> > > > > whether we are ok sleeping or not, as this code can be called from
> > > > > pretty much anywhere BPF might run, which includes NMI context.
> > > > >
> > > > > Would this kiocb_read() approach work under those circumstances?
> > > >
> > > > No.  IOCB_NOWAIT is just a hint to avoid blocking function calls.
> > > > It is not guarantee and a guarantee is basically impossible.
> > >
> > > I'm not sure I'd go that far -- I think we're pretty good about not
> > > sleeping when IOCB_NOWAIT is specified and any remaining places can
> > > be fixed up.
> > >
> > > But I am inclined to rip out the buildid code, just because the
> > > authors have been so rude.
> >
> > Which fstest actually checks the functionality of the buildid code?
> > I don't find any, which means none of the fs people have a good signal
> > for breakage in this, um, novel file I/O path.
> 
> We have plenty of build ID tests in BPF selftest that validate this
> functionality:
> 
>   - tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c
>   - tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
>   - tools/testing/selftests/bpf/prog_tests/build_id.c
> 
> This functionality is exposed to BPF (and PROCMAP_QUERY, which has its
> own mm selftests), so that's where we test this. So we'll know at the
> very least when trees merge that something is broken.

Only if you're testing the buildid functionality with all known file I/O
paths implemented by all filesystems.  Or you could add a new testcase
to fstests and we'd do all that *for* you.

--D

> >
> > --D
> 

