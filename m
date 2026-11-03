Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 586FA6072C9C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 10:46:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5715A6B00EF; Tue,  3 Nov 2026 05:46:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 546126B05B1; Tue,  3 Nov 2026 05:46:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 483006B05B2; Tue,  3 Nov 2026 05:46:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 289426B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:46:39 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3861E80369
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:46:38 +0000 (UTC)
X-FDA: 85393479276.05.D41A042
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf22.hostedemail.com (Postfix) with ESMTP id 81F34C0004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:46:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf22.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793702796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LdIXNf/kbOEd603rTDv8mLco3g5Owvy0jg0HM9Q6Xrs=;
	b=4rCMm9YLMYzjrCuiI+vHr7xn554MUWA6/0YRQCLzsc4N+4J2VYws1R8lmTe4ecpavZ7d2D
	7nDXho+oTwx105WG7FMI42dIl8X7Sn6wgFi2c5e1FAAKQerU4pHtsQYTdBPOgSy3B7Zvh/
	CZ1j71Ow5AZcqX6biJOIrOXwXa8Eyxs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793702796;
	b=7zHNACq+dkaK0IiGDjP1R76LJxrmLF/k8D18Lxs1N1WIKqhsWx0FRx8r5t0UmpffcOM7RM
	F4FZ9EZeazdDAJsmkSKDux3QAq5fjc65o4U7NeIB+cyz6pUQaT3hVyBDDHtEktN1hBJDeN
	oJNJLdT6inIAdpj152yVaBQqK6/bJ90=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf22.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AA59A68B05; Tue,  3 Nov 2026 11:46:29 +0100 (CET)
Date: Tue, 3 Nov 2026 11:46:29 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, linux-nfs@vger.kernel.org,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v9 1/6] mm: take a folio off WB_DONTCACHE_DIRTY only if
 it was counted there
Message-ID: <20261103104629.GA7296@lst.de>
References: <20261024221152.6965-1-snitzer@kernel.org> <20261024221152.6965-2-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261024221152.6965-2-snitzer@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: 7wpyacwjkm7d7zsy6m1qksnnw6rwbwbf
X-Rspam-User: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 81F34C0004
X-HE-Tag: 1793702796-396947
X-HE-Meta: U2FsdGVkX19iWjN4lbk1HQIxOdcVzVHQvqTbUIO6R9fk1CZDCEqpPrwWQ/SkYnPg5ifCUrLL+PneiPcmOKMtbUBhxb1LYZldcKfzeLg6+6uVjuVJX+E6CrQvcgj0np4C8eAMBNshwjY3lQqn1/PoFdTkzTy6Qkkd5sdkWi4WEZr/ypiAyjQHphx8t06+M/jkG98hTSuANmY7Gndtj0JoprPrfQVUXBXEwfb2f45C2nNlSKo678EtnSNDR8U6ZHnmCQ8deTDap/uBeWPdBfWfv//XEl+Y5NV933mUG7uNR4osdG0fkbK0/reP1DaUiFmIY1oOWSxbeOjIYwAxuO4v+ylWzoyxHUlnfofGubm1FkyYQhUTaDELnW3vjfYZMDHV1IkK9KJ5hMejEAkALsS8DeMZekvHx6OL4CDZDFDeT+hNDJ+Ix1aimzTOtC1XhZm+qsL4KZH+qA6uJul6doxPYv5QENqO0UTT6SNNtiq7CbUnva/p/nNkhbeHE6WGGCxp0L0woJjBOs58vCrefR1IiYBdhCNt3DlF8iqVUIfcZBBCFpIJzCDJ4TD6aUYPXwaCwggbHlYbDT/DOAJKWtEoHE9dPMSgm3pM/JQCs1oWqpMtFCyXbqlSv3tLtizzoP/v5PIhHMIKMlwVR0Wj1hPRPnKPoDzPcf+L/m8C0jl4T2OmQretvpbeLErATeAmU+WXmrVc+JLvRUBiAdQlg02gOu9swW9yae4dwaioM4cZV3vj6HPuyMrKQbQ3s93QuUih3X7uS6U+2UHCh4s9jJ8fomACsLfKRjnwWrFaC1+t2n6R0uQWe9QLBxzefylqFUsXKsBr7JttVKOebnlp6M4iWERXDhlwouqOVSSaAAzdqnr5WUvzISoKZr70JUfJkvmrclSgZMSrDMj/9juMH9EjrP2VRoB1jysSEBc3PiXwL9ITxYnw2LJso2vonET3SCFBnkAO6AnGpybFbLbHrLL
 k8ze8Z8U
 oYP3uoTxGUglu9RNwj4KVVoQJ2oUrH+d+kGCeb9whb1hUasxR30znqEkHrI6Qk2aVt0vZ9mQuash6MadKW2oucacnrrqMlwyjWzJpZ/x0fSw8lAJiTnqO4wEiLw6cQhq3Rh8lX8sRhKLj4gsVbda3TCTcnwFPmmMHo3lZmEJmx0RKr/3FVOV23avO2xVs8wC0cjeyyvd8DaIwbhbKgRmIFoyn2oMNXlIIcJQPNnCv2toE0yvI7uPZrOKDKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Please write a concise commit log.  This is a long meandering thought
of eletronic dreams making no sense.

> +/*
> + * Clear the uncached flag of a folio a cached lookup found, and take the
> + * folio off WB_DONTCACHE_DIRTY if it is counted there.
> + *
> + * folio_account_dirtied() counts a dropbehind folio under the i_pages lock,
> + * in the section that sets its dirty tag, after PG_dirty has been set
> + * without the folio lock.  Every path that uncounts a dirty folio holds the
> + * folio lock.  So with the folio locked and the i_pages lock held, the folio
> + * is counted when both PG_dirty and the dirty tag are set.  PG_dirty alone
> + * is not enough: a dirtier past folio_test_set_dirty() but not yet counting
> + * finds the flag clear and does not count the folio.  The tag alone is not
> + * enough either: __folio_cancel_dirty() uncounts a folio and clears
> + * PG_dirty, but leaves the tag until writeback or truncation clears it.  A
> + * folio another task has locked keeps the flag, as it would have had this
> + * lookup not run.
> + */

And this comment isn't much better.

> -	if (!(fgp_flags & FGP_DONTCACHE) && folio_test_clear_dropbehind(folio)) {
> -		if (folio_test_dirty(folio) &&
> -		    mapping_can_writeback(mapping)) {
> -			struct inode *inode = mapping->host;
> -			struct bdi_writeback *wb;
> -			struct wb_lock_cookie cookie = {};
> -			long nr = folio_nr_pages(folio);
> -
> -			wb = unlocked_inode_to_wb_begin(inode, &cookie);
> -			wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
> -			unlocked_inode_to_wb_end(inode, &cookie);
> -		}
> -	}
> +	if (!(fgp_flags & FGP_DONTCACHE) && folio_test_dropbehind(folio))
> +		filemap_clear_dropbehind(mapping, folio, fgp_flags & FGP_LOCK);

Please don't mix code moves and non-trivial behavior changes.

Add a prep patch moving the code, and only then modify it.


