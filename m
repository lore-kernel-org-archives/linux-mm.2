Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76261E9A02C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 00:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 969DB6B0088; Wed, 18 Feb 2026 19:33:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ED666B0089; Wed, 18 Feb 2026 19:33:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F9CE6B008A; Wed, 18 Feb 2026 19:33:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6781B6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 19:33:02 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DC60216038E
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 00:33:01 +0000 (UTC)
X-FDA: 84459331362.30.2286F6E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2EE90C000E
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 00:32:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HhaUOlMr;
	spf=pass (imf22.hostedemail.com: domain of dgc@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771461180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0OwEEv1uAonmHDIvJcptoy47J75rIxz14AgcRWPJ0aM=;
	b=jdH+6VnPsWPvr90Og0c2m99jiRej0UuK1lrPWvHSJODNmoFuOr7cdlHU0AuqrkkpF/rWn2
	R6+KCNdCTMyOrZ/z/KUzMHtUh0W5i6xfsMfPEJb+SDfEgU0ontgjrFhwUmLHADrsJf/qrn
	OwxXw36H0YfwyW8qg3pfANNhxbsYdhs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HhaUOlMr;
	spf=pass (imf22.hostedemail.com: domain of dgc@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771461180; a=rsa-sha256;
	cv=none;
	b=1afWwqdM3FFhlgym5mNryusUUUqVqMh2FWkN5eEcpQlqtIuTiO17RB2eAX8bnj/W2gzGZp
	asDdN0INpoM069cS+I/cRl01/ZL7hAhD+kPLKNJPx0OJdYwOUw4QNbuhoVSiyCb1B+66Gp
	okgYiCoWCKNHQWjtSNc8x5vZw4XR900=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F04244380;
	Thu, 19 Feb 2026 00:32:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7114CC116D0;
	Thu, 19 Feb 2026 00:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771461179;
	bh=LshIPA616HGHej/yvGjLaNlyNI+47/IjLdNm/ls8NuI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HhaUOlMrPRQgvtMPpSxM20MBDr64vVJpbAY1pu+O8090E8NnRndqiM0WyCDxTDvLF
	 d03ezHeQ58t0QrKTr18pVUK/FibjSIgMck6c/JbiDQjybjfhZ0xq2KsCstIMZGTgyE
	 0rDBVSbsynuHFLHM8lmDQjXBYn7jo7bbecSYg+dF02lEADQBXk1eBzY4+QIwgchpwT
	 Xs1R7mywrf6yHWHuq2NndhnsC6GlYO5ZwP9+M2HZeYdKGBdjAElFUfVS8BiRN64g49
	 8Q8XfvYMHv8zeSpwe1Y19HMYXvQuTMa8j4rywwdACD9RQr+/a0oCW/x2WP1xMgv+Ua
	 sxoI0MirSmuDw==
Date: Thu, 19 Feb 2026 11:32:45 +1100
From: Dave Chinner <dgc@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Andres Freund <andres@anarazel.de>,
	Pankaj Raghav <pankaj.raghav@linux.dev>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	lsf-pc@lists.linux-foundation.org, djwong@kernel.org,
	john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
	ritesh.list@gmail.com, Luis Chamberlain <mcgrof@kernel.org>,
	dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>,
	gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com,
	vi.shah@samsung.com
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <aZZaLQhC-nFmJBTq@dread>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <7cf3f249-453d-423a-91d1-dfb45c474b78@linux.dev>
 <zzvybbfy6bcxnkt4cfzruhdyy6jsvnuvtjkebdeqwkm6nfpgij@dlps7ucza22s>
 <wkczfczlmstoywbmgfrxzm6ko4frjsu65kvpwquzu7obrjcd3f@6gs5nsfivc6v>
 <2planlrvjqicgpparsdhxipfdoawtzq3tedql72hoff4pdet6t@btxbx6cpoyc6>
 <umq2nlgxqp4xbrp23zjiajwd6ombed4dfwbajuh35xd4vphyee@26g2y6a4rdnu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <umq2nlgxqp4xbrp23zjiajwd6ombed4dfwbajuh35xd4vphyee@26g2y6a4rdnu>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2EE90C000E
X-Stat-Signature: ymtq9w7cu48ksgjredm649op43neof4y
X-Rspam-User: 
X-HE-Tag: 1771461179-815915
X-HE-Meta: U2FsdGVkX1/vld05sRdakvigp20ANFmcyyuqH67jAUk7kaSSuvHWf0EPFw5STsjUn7Fi77VrszCqhAwh60cT4DLV4jOM8gofPJBXk/iS10QinNROgXqtXGRk7f7dZMhuZZS3GcFVWsYrOUGof3OSiuA/m8f+FsNGrAhjEeIlPEWKq2b3fI9xsXVHh0Zml4Rf973gRwMYcJTO11rs1tgwp+uI5VRRvC60nHN7DZe7ay1swceX4VYdImLIHNiaZn7xgQMMYV47x+gxIwsGnyS5q13yV9snpHsgyDXGfb2ZCgetiOLmO8Ny/7skJD6H9bdkDHtV2D14YlKuc4W2kSIS4CUjmP/CJ0C5h8huD0uCXVM9tCzniLcfCh0Fyh2VvOdvEkEa6ASmmfVSxL1nbrxHhNcwna9+5SfvAC9G6ABEcz27pWEqdtgPYFG2CXuibPKBnGEdKwHvBDjKJFCmppU/3ExxxJcz429pcLN2hk772q8fyQOtwiegQk1TK5V7sTT1340woVNMv9fHWoA1Lb14M0y4c3lBJNRVcGqf6/6RCv4TMMaZ8CwE7fD69Gi2VUs3M8Iaxg5qcrRXrmM99AgHkny0EkhWYh/C5B0WHghYcHCsN4ZRzv+HHEzVYzmnr6DZQVXpnQQ+1Ioeb7eHUVtGGqtdtHJ4fUjciwFZg2fEnfByOCFTR105msK7H5HzusyO4HAUPw0MNNlomt56BcDF4ey3KMKCcaNW3+cEc+t/oVH9uySzC5X4S937kBUQvP/udgpY/56TOfMLSrX3fRqJAVYeOfFmGbbYlKd5uUABVfOnB9wRUcBOKnGv4Rya6WlNiOHdePGEV4PllScdVMSXK2s+Y7WUSGu9X1Q11Ef8TN2ztDSrxIahJDZcsdopcNS+KqUA5FJhJoQvFENF48vBwrpzCvi27xV8W8YrTcSf+h2IZAPalOrPGzieVSfXRpl9TEDCMtPaSqRwZw74PmR
 Kqo1kkPy
 ViEZ+L6Dsew/QgNBkup45IlxGIsYGKKkXHABlCtovWWJpTdRmkhRwdPapxoUHDOkZE7acMGXEIKLbhqqZKMjstV4sREk1FgzIuu3NXlwG7PQEAeujWahJLgOcqS/ls2mhIe9FDu4ciWk1x/lbYprVIl9dXNzNPE63Y8HIHj+JrHMVr/cKOOkqXLCKhlCNl9oK+rLSdMpX63WQC3cXmpIR5cx6447+gZlAoyyNy+HCKb0hqzcVtc8D/1PDAaLuVMsP0G4s8f1l87cPZ1V72pv1v1YSaVEjZKzh+H/W7VOwHEgM3NFRSPYr+wnPwu0RtV6OvbAqzgl8D97PsXUGIng/ibzIicpdL2XJl/FR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 06:37:45PM +0100, Jan Kara wrote:
> On Tue 17-02-26 11:13:07, Andres Freund wrote:
> > > > P1: pwritev(fd, [blocks 1-10], RWF_ATOMIC) start & completes
> > > > Kernel: starts writeback but doesn't complete it
> > > > P1: pwrite(fd, [any block in 1-10]), non-atomically
> > > > Kernel: completes writeback
> > > >
> > > > The former is not at all an issue for postgres' use case, the pages in
> > > > our buffer pool that are undergoing IO are locked, preventing additional
> > > > IO (be it reads or writes) to those blocks.
> > > >
> > > > The latter would be a problem, since userspace wouldn't even know that
> > > > here is still "atomic writeback" going on, afaict the only way we could
> > > > avoid it would be to issue an f[data]sync(), which likely would be
> > > > prohibitively expensive.
> > >
> > > It somewhat depends on what outcome you expect in terms of crash safety :)
> > > Unless we are careful, the RWF_ATOMIC write in your latter example can end
> > > up writing some bits of the data from the second write because the second
> > > write may be copying data to the pages as we issue DMA from them to the
> > > device.
> > 
> > Hm. It's somewhat painful to not know when we can write in what mode again -
> > with DIO that's not an issue. I guess we could use
> > sync_file_range(SYNC_FILE_RANGE_WAIT_BEFORE) if we really needed to know?
> > Although the semantics of the SFR flags aren't particularly clear, so maybe
> > not?
> 
> If you used RWF_WRITETHROUGH for your writes (so you are sure IO has
> already started) then sync_file_range(SYNC_FILE_RANGE_WAIT_BEFORE) would
> indeed be a safe way of waiting for that IO to complete (or just wait for
> the write(2) syscall itself to complete if we make RWF_WRITETHROUGH wait
> for IO completion as Dave suggests - but I guess writes may happen from
> multiple threads so that may be not very convenient and sync_file_range(2)
> might be actually easier).

I would much prefer we don't have to rely on crappy interfaces like
sync_file_range() to handle RWF_WRITETHROUGH IO completion
processing. All it does is add complexity to error
handling/propagation to both the kernel code and the userspace code.
It takes something that is easy to get right (i.e. synchronous
completion) and replaces it with something that is easy to get
wrong. That's not good API design.

As for handling multiple writes to the same range, stable pages do
that for us. RWF_WRITETHROUGH will need to set folios in the
writeback state before submission and clear it after completion so
that stable pages work correctly. Hence we may as well use that
functionality to serialise overlapping RWF_WRITETHROUGH IOs and
against concurrent background and data integrity driven writeback

We should be trying hard to keep this simple and consistent with
existing write-through IO models that people already know how to use
(i.e. DIO).

> > > I expect this isn't really acceptable because if you crash before
> > > the second write fully makes it to the disk, you will have inconsistent
> > > data.
> > 
> > The scenarios that I can think that would lead us to doing something like
> > this, are when we are overwriting data without regard for the prior contents,
> > e.g:
> > 
> > An already partially filled page is filled with more rows, we write that page
> > out, then all the rows are deleted, and we re-fill the page with new content
> > from scratch. Write it out again.  With our existing logic we treat the second
> > write differently, because the entire contents of the page will be in the
> > journal, as there is no prior content that we care about.
> > 
> > A second scenario in which we might not use RWF_ATOMIC, if we carry today's
> > logic forward, is if a newly created relation is bulk loaded in the same
> > transaction that created the relation. If a crash were to happen while that
> > bulk load is ongoing, we don't care about the contents of the file(s), as it
> > will never be visible to anyone after crash recovery.  In this case we won't
> > have prio RWF_ATOMIC writes - but we could have the opposite, i.e. an
> > RWF_ATOMIC write while there already is non-RWF_ATOMIC dirty data in the page
> > cache. Would that be an issue?
> 
> No, this should be fine. But as I'm thinking about it what seems the most
> natural is that RWF_WRITETHROUGH writes will wait on any pages under
> writeback in the target range before proceeding with the write.

I think that is required behaviour, even though it is natural. IMO,
concurrent overlapping physical IOs from the page cache via
RWF_WRITETHROUGH is a data corruption vector just waiting for
someone to trip over it...

i.e. we need to keep in mind that one of the guarantees that the
page cache provides is that it will never overlap multiple
concurrent physical IOs to the same physical range. Overlapping IOs
are handled and serialised at the folio level, they should never end
up with overlapping physical IO being issued.

> That will
> give user proper serialization with other RWF_WRITETHROUGH writes to the
> overlapping range as well as writeback from previous normal writes. So the
> only case that needs handling - either by userspace or kernel forcing
> stable writes - would be RWF_WRITETHROUGH write followed by a normal write.

*nod*. I think forcing stable writes for RWF_WRITETHROUGH is the
right way to go. We are going to need stable write semantic for
RWF_ATOMIC support, and we probably should have them for RWF_DSYNC
as well because the data integrity guarantees cover the data in that
specific user IO, not any other previous, concurrent or future user
IO.

-Dave.

-- 
Dave Chinner
dgc@kernel.org

