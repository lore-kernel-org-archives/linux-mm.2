Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BEFAC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 18:37:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D653F6B00A9; Tue, 30 Jun 2026 14:37:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D155D6B00AB; Tue, 30 Jun 2026 14:37:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2B146B00AC; Tue, 30 Jun 2026 14:37:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8BDDC6B00A9
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:37:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E1E5E168319
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 18:37:07 +0000 (UTC)
X-FDA: 84937436094.05.AE4BF93
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id 449D880007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 18:37:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=aN2oOJXH;
	spf=pass (imf02.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782844626;
	b=3ChYhYcba3knub6/7q2oAhRAWgikiedaz1lvldX8/nlvvm5KC4OCmTK31N27sT82X4WI++
	IxexWDYnC+XWjUgcy9RqDy7OsDmBvEwN+4ZxilXBaeli0P2thF+q374C/D3YDjdiyGgYCn
	EwRz8jOo3smSfSk7+yPF6Nf8WjgkBcE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782844626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sxmahw67jvFH8EYoUlnhdZ6NYwIof1KgSy2fQ7/QPiI=;
	b=gQ2AvzwmdygeWeMCbjR9Z6Jj96lhVy49vwj/DXYIZpysoruExeBwKyh0hLdLc4LDwBQcAy
	UvsOITtCCNTTYy6tHFb2v9aCKZwyWmt4XGV1g0Lm9PfREL8tCp6Jck8BrW0430cqYuUNTj
	8iAqxxfVVyNBC5lfDcP3PsMaLcSsaL4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=aN2oOJXH;
	spf=pass (imf02.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sxmahw67jvFH8EYoUlnhdZ6NYwIof1KgSy2fQ7/QPiI=; b=aN2oOJXHM1LRftU+o0io32YJhc
	AY/Cy7EQ4WqzgXhobdNspDCNb/4gwDOC9rCIGwzU6DBRUwXI4HmS8ceFSKI/GtX09aLaF4l4InTWi
	m65uufH7LUVdI17APyKm0uyk8NuSlGTJW78mMS1O1vRNRw20eXupIWK1ND14r4JIBI5HjQ+RZWyMl
	xe0wtmmbMTk5ldPHEHc3r5V78LWKCXjP3Q/IKTQP1pG9SzpogXg4DRaADlRxJE/0rXPVJalJTs146
	t7snZRZvZyHJttMttdNVdMtkbpQU67drR3gsDZw8/X58VrSte8T5m/G4WUUenjvkGrGjF6DQmXZvK
	q2Ibxtfw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wedKN-00000005Nc2-1soS;
	Tue, 30 Jun 2026 18:36:59 +0000
Date: Tue, 30 Jun 2026 19:36:59 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Gregg Leventhal <gleventhal@janestreet.com>
Cc: "To: Alexander Viro" <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Cc: Jan Kara" <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Song Liu <song@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Eric Hagberg <ehagberg@janestreet.com>
Subject: Re: Subject: [BUG/RFC] write-open file THP cache purge can discard
 dirty page cache
Message-ID: <akQMy54dxVTVkMJ6@casper.infradead.org>
References: <CAFN_u7H_0ECF3jixP=T=U7AH5=Q3wQNvJMo8an3VqUDMerQfUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFN_u7H_0ECF3jixP=T=U7AH5=Q3wQNvJMo8an3VqUDMerQfUw@mail.gmail.com>
X-Stat-Signature: uj97trgzhxphcioudoit957ymgprmqma
X-Rspamd-Queue-Id: 449D880007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782844625-407063
X-HE-Meta: U2FsdGVkX18SEoWkO2N9CtAuOWpWmmYsudKTijBH0fADEe3FQU243VeSew045TR67QW0998BpR4COmfHFccnQE7DicTa4Utq8DkNhYxgv8eZ59gPujxkLgsbDjEFzz/meSS5xeBZ/UIuISjJRjVsCXGiDPfh5Sz8duArNiCQMFPouOR9Jh78YcSed3fIkmGRpK2hWtnXcQq1O1wvot0t26aifL1fKKN9PoeNnRUXqQFhH//jP7HuG0lUCUTeksQcV5bixGh/hcQfzsEjS+NPl2fvNA70MiTlXsV/eliiKcW9PhlbsdqhmtHy8HtvgT+NtmyNae955DTNgAL40Sh3HD8bcCrJB5ayHlqFK8jmAweMOMnLGst+NH3diK9K9guxaTUvxNwayhpZCKrZ/3mJAyYbv9rMNYCwZysBquRkWOknmZdY1bPHZOYEqijhG3srY/NvPhXdWoPJe3oLZRQnvQWWu6kD7Ton39MgnU9Bgoli+oDKaDYRv4rtXSYGI1PctkHQwm4McNIaVhJnJKg8cN5mG4KL/DAY9nWzb31RhWPz7YH9eTdzHvHLNfnKegCTXX4+BZEkPckVskiECgD0huAzE5UvTGGCa0Qi0zw7GFX+4lBxB8CBVV9D/fsTqCvpa0/sqVYZ2SYZbYtMzecWHBROP+OUBdVY5DnwQZJMXMrdxOsszdcsAuHePq3NiupRbKkW/Imb+IIg2Rzr+SYM1sUqSjFCBEYZaT+unGcRYxtxEhkpLC0sG9bb0BXi8FCsqaocGmN+u3Hx52f8dD8KqfNjNgzK7UOhi/PtwymqmGNWsfSXVL/GboI8gAsJibSpAINapsimK2qe5MdZDDLirRMuS1yYhX6NPwF65mzzBCvkrsu+SnGKxN0j0sW7rmLdwQUsy/F9zABY7BD6SAjEDp+LZ7FLblaq4cB7V8a6GfMCi2GLza+mHmzL2RypBFQLe7URKNu2jheIRcou6Y2
 9yOsNgjy
 d98p0EGrP+2q0BKQjU+XVDjKj6ZQ43hL0kFPkHFjcUXmNS/n06rcgKsWTxCV2vtJkZYxi9du+vtU6RgrBxXTMmFZS8kPYcf7SAGbzA8utqSxYGbGF7rV3/s3TYgo/5pRxA6P6anXmTNTeqnA30zER1kf2FseUVpF4tdgP9pV+cDzPto4il9ZmYYS7P976wPJHCVcWhtL/P3U/dt9ynRj0sRMUCEMmuuwJcV7WIUQ8c9dVHb7cu+a2ghDI/RZcFNf2IHNJJlXAz2BWs1F3TTU3plm1X/kYbxoRafmvpjghQauU1kaYXrYWb39CEswSYSRkE09u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 01:01:53PM -0400, Gregg Leventhal wrote:
> On an affected 6.12 kernel with CONFIG_READ_ONLY_THP_FOR_FS=y, a file can
> contain read-only file THPs installed by khugepaged / MADV_COLLAPSE. When that
> same file is later opened for write, do_dentry_open() notices
> filemap_nr_thps() and drops the page cache:
[...]
> 
> This is unsafe if the mapping also contains dirty folios.

But there shouldn't be any.  It should not be possible to have
dirty folios and THPs in the same file unless the filesystem
supports large folios natively.

If the file is open for writing, the attempt to create THPs should fail.


