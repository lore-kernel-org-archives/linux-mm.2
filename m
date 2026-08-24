Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C461C5DF9B
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 13:29:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E2EC6B008C; Mon, 24 Aug 2026 09:29:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79A756B0092; Mon, 24 Aug 2026 09:29:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D08A6B0095; Mon, 24 Aug 2026 09:29:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4A80B6B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:29:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4B2CCC015F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:29:40 +0000 (UTC)
X-FDA: 85136245320.11.24612BC
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id A663B40011
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:29:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DVpXuCgB;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf12.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787578178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UP1TeJcQT74aqE7HfHCPzdq0084a2GndPFA/TBwUbHY=;
	b=aokjM2Axe233XkDdf/YbBoz9nqGXGO1ie284pPA4SB+Sr7X6rQo+CDWRwfnjPexqT2HQOd
	LtQ4wLTeqjlTbdY6D17lAP4yZr7TiicEhWzXveO5ApueAtDqHxNq4PAfy6CEfHxLuwjE3Z
	X7l1I6mIN/8q8wm1G4nzEF/TqPJc+OY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DVpXuCgB;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf12.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787578178;
	b=FrkfdRIjs29RX7F6ARqiu95EeGUw78cD0xnNtm8RaoGkeWEZwJEU770HdCdCFyaYc5bpxu
	HbuIe2SKAX1zXNZ71alIOQk2s3mQDMfqbKa0Wq+lTWmPtbeHiCasUKJXDUYd3GTCPZhu3z
	3Kn8CGvROwju35TCjV2oCbWIeZjPhFw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UP1TeJcQT74aqE7HfHCPzdq0084a2GndPFA/TBwUbHY=; b=DVpXuCgBWzg4bh1HoyTUjrvA7a
	g10c2SRZCIct6G9ZFfmQ2xDtSRhzhvqg2iqKHeN34oUDs2mF8AkL4J1MbE3654XNJFqg/ZdbF4oxj
	pf2I0N7VJIOWBRcdbFZgSYn9avDzAW+Xx+qe+fjTKty5JOw0KvHc2fk4qUalN5QpwUDn9VN4e6wDh
	W29tgfU11wmdEgc6SYoRRgsdTfw38IlXNfwZYxT15ovSXkeoFOtT4JVo27hfDLiGm72vzie5Vf2fH
	ENPz5NXe8NNZi5OSbLqQgl6OKMlEWF3mvgt5/cF6qcPLFK6DFenQCIt/gE91p/L6xfUTQUq4PmRu9
	pCTg9upQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wyUjx-00000007HHf-3ewO;
	Mon, 24 Aug 2026 13:29:29 +0000
Date: Mon, 24 Aug 2026 14:29:29 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-nfs@vger.kernel.org,
	devel@lists.orangefs.org, Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 2/7] fuse: Use filemap_invalidate_pages()
Message-ID: <aoxHOSC9kTPbKeNq@casper.infradead.org>
References: <20260820193343.3852967-1-willy@infradead.org>
 <20260820193343.3852967-3-willy@infradead.org>
 <CAJfpegvP3i8ZJc2T=+f4rAhZ4E1QcT5+jC6mQPLxtB-yoK9Brw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegvP3i8ZJc2T=+f4rAhZ4E1QcT5+jC6mQPLxtB-yoK9Brw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: A663B40011
X-Rspamd-Server: rspam07
X-Stat-Signature: sbnu558586cmn7cfidwq8cfdm3z6mt1t
X-HE-Tag: 1787578177-587182
X-HE-Meta: U2FsdGVkX1++qtiFaOy2vivkHSQFaC1lL/YYqJ8wnJ74FbH6/XqgRtlUKAaKXPedZ7OQqP/8dsAPB9a8DRKErtmNSmx3Aj+TQxGX4n4zUuLq8OyCLp4A17Y95Y39F9w/l6U+a4MKkJndupmqPL3r63Et6wJ42JtoNEiWm6c1oOj2qEYekQjM98t3TnuZOp08liz/oix1oUeCSUarbd7W4Ie9mGnPjwj52peoEHs7HT/vcxyI8CXKzEct6KlG8Nj/d2bWGhDqcHptUfeLlRVlzens3DudnWZytLx/oI8s4aIX06IqA9Js5OxyXAeHVqsfaft7GQDcKREXo/rx2LoIHrbE+Th3xiVG8S0Lt3owOFHVsXDXBhQcQDnIlxt55sLV2nHuYxC4X2AgbOh7KE3+IhZGr2aAaatM4YQanrGFl+uH9MTC3LLS4k2R3QGZvymexLGfKqQRrj6rgqf7zxIB3qQ/ERFnwIBC2aGnwlYYkPv1py3cfpbra7RMrVSLtVAsXkcDjqmk7NQ5RH9KPIJZR+UPuuNzlmbMIShAg6T8pXAa75cG6wrwXDDkEZy/f/7JjMTPMEt4MyL4zVRKVRjyOsIMrH9PlyFstFMbdG0tAs7KIb9wIVyS5TTaymz5qioiGFWerLTYAGBI3pg5Fu/xOyxOpCmoY4J6vACJfq78Fg8qyLc/jTo+3O5fRJ4pdJLPhqstMX+RhBwfZf9ecposDIDm4KntmgHwHEopbfMGtK/JHkr/fOoy+G2YehDp44Md6c43q2oKlaR4bzWmgupLI/YZYMGM0G/AhxheM2ybxSVUorIWXnUiOmpi5beCoZZkBfqEnfJ+fMrUmlvUPMYSzMIaPUN416ahYebKO30lBoTdAr0Y/8mrt/C4NZFBbAlVZrbPNG1iioW1qUI/zpLiJsFn+A4TVra//8b3H2DPSD9XsnPEijimvif9ycqI1VKUZeYB2Fm+tgD8AwL1AKZ
 b9eS3QBz
 DZLi/+OJyVMnbdjNNuv/Edd7S4Np72Mu1u2nxqMWiMSOisCDt+swbm8gto/xnFltIPzEgol0xxeJNPdpMBuqVXHLCO3shups7QelXw5aSBJqDeeR4JmUBJuOcPg3zVkVC12kUTz0uL95bhYR2ijbefWSS/Zt66zTLdyi9SxP9dOYHzTOpx7mEcBU4A6UfUuKqNvBa+Qp6lfXGlxZGec57n5c1LjLvFBMWq5Kiz2NLRqoAhWwkNc/9Iz9QHRDAEp1M65l3YdTJDlpr2nIBI3S5RXK4QOL+/x24isvA7xypZ0NLcO2fkDiE4QM51z1M0/vxPAW2/eWYfHhox74K+E3k4Fp5+PBugCiojiNyWzqH4xFRG2Hjqo8Vk6v82guupA+YJLIOez3mhv2o4BFJl36bX+AAlrvjOgQ+5J00crshIwNZipZldjbxtf6KK99pv178pc1TAo1jOsaP7yc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 11:05:46AM +0200, Miklos Szeredi wrote:
> On Thu, 20 Aug 2026 at 21:34, Matthew Wilcox (Oracle)
> <willy@infradead.org> wrote:
> >
> > FUSE relies on invalidate_inode_pages2() / invalidate_inode_pages2_range()
> > doing writeback by calling fuse_launder_folio().  While this works, it
> > is inefficient as each page is written back and waited for individually.
> > Far better to call filemap_invalidate_pages() which will do a bulk write
> > first, then remove the page cache.
> 
> filemap_invalidate_page() suggests to use invalidate_lock to prevent
> races with pages coming back.  I'm not sure that without it the
> behavior is identical.
> 
> Maybe add a variant that takes that lock?

I don't understand what use that would be.  As soon as that function
drops the lock, the pages could be reinstated.  If the caller needs the
pages to not come back, it must need to hold the invalidate_lock across
the whole operation.

Before any filesystem people get funny ideas about closing the O_DIRECT
race, you can't do that because you'll deadlock on doing I/O to the same
file that you've mmaped.

