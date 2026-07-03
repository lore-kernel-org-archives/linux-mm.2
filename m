Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CCFAC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 09:20:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 786466B00B6; Fri,  3 Jul 2026 05:20:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75D8A6B00B7; Fri,  3 Jul 2026 05:20:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64CBE6B00B8; Fri,  3 Jul 2026 05:20:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 382E66B00B6
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 05:20:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C13911688A3
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:19:59 +0000 (UTC)
X-FDA: 84946918518.21.A3492FC
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9A519C0002
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:19:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=J6S8Rvou;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rHkIOYoy;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PLBvQUmM;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=RyJc3dXV;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783070397;
	b=ETDS/Rxs7qwCB3CzG9G5pWk7ocAfXvWz+8KdXybsE1ewrBQTbnBSVm0uqy/nnSbK55wB3R
	8ERiKlyqtJh7VVp/p+sjEWWpn4CtmpUX+5s+LcHS/9pSh0xZ5z5GKC1lMN6DJIaRIRlqp1
	6b95SIi3IV6wpvyzZVdx9dzs3LiQ+eY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783070397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wLNoIPFQAdzqlhhDjJljgWkTgIt0PBr/oUCSVxs3Zuo=;
	b=hqv8hJwMMou1H62Vm3963nwvVbSa0qCmnjh+0P0Rkqq6XrKmLdh2Xuqk1QpLw3BYYZv/Y0
	zZ5D7yYvpilt13IEpdHXTD0Gf5wwvaEzYJ1k1HQmhqgvG2yX6Nl7Q+z8p+/nBNVuJ6nAoE
	WAshVNqh3yjelW5H2dF20V19R+JL/OE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=J6S8Rvou;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rHkIOYoy;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PLBvQUmM;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=RyJc3dXV;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EE60174832;
	Fri,  3 Jul 2026 09:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783070396; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wLNoIPFQAdzqlhhDjJljgWkTgIt0PBr/oUCSVxs3Zuo=;
	b=J6S8Rvoua0dSJHxLdFrxFJWZM8hR6dSknFKcAwZHXB2IzZyj3aKXaoeMiZImqHX0DLmZm+
	svYGrDovejHKJHqoHsqiatns8PXCi1T2wm9E6ZSQKQfKJJlcZDdQ+XVEykUQ9WTdrC3F4z
	2q5V3AlISPlFskR4kIAjwVNNHfiwRKg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783070396;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wLNoIPFQAdzqlhhDjJljgWkTgIt0PBr/oUCSVxs3Zuo=;
	b=rHkIOYoy9oK2iBGSJenoueb7UarA4ICEW/qNf+dddBdOFfNk9eYrbA4mTgAai/ENT1rVJ8
	SSI+FU1bE8I7+xAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783070394; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wLNoIPFQAdzqlhhDjJljgWkTgIt0PBr/oUCSVxs3Zuo=;
	b=PLBvQUmMD5Np4IuyjLfdm9G8FzjBbaRQ3WyoW2tloAnkCBzSks74z10u+r7rmcaVwG/ju6
	qwO4dgFbp+5RVJRJzDIe+5JjswhzV58TNnYXy+ZT9ASqBrPqSV2Z1khQE5ottap5weozQ2
	dGhYPdi1qv0IkaJMgcj7870POHcX+CE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783070394;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wLNoIPFQAdzqlhhDjJljgWkTgIt0PBr/oUCSVxs3Zuo=;
	b=RyJc3dXVK/dYw+3iTJXMb3qEaBCULjbrWuBFuwA4FABcfAsT/HSJlGN8Q4clstduNeiUBT
	eArI1L2wvWMx99AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EA3EC779AA;
	Fri,  3 Jul 2026 09:19:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UBbKNbh+R2qHaAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 03 Jul 2026 09:19:52 +0000
Date: Fri, 3 Jul 2026 10:19:51 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Lance Yang <lance.yang@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, stable@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	Song Liu <song@kernel.org>, Eric Hagberg <ehagberg@janestreet.com>, 
	Gregg Leventhal <gleventhal@janestreet.com>
Subject: Re: [PATCH stable] mm/khugepaged: write all dirty file folios when
 collapsing
Message-ID: <akd-fJf7i8E9FuSA@pedro-suse.lan>
References: <20260702165409.164568-1-pfalcato@suse.de>
 <2DA84662-F9E4-4ED3-A225-71054FEC3849@nvidia.com>
 <d38263c7-b1ea-4709-8d75-2f2355ca38a6@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d38263c7-b1ea-4709-8d75-2f2355ca38a6@linux.dev>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 9A519C0002
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: bpmbuj6nuho34a56q3shq497k8f6wtx9
X-HE-Tag: 1783070397-864802
X-HE-Meta: U2FsdGVkX1+RiqZZvPFrwCnK/PTU0hFKSzW3yg6tG9grVBV2BhCcfzNeAjlx0EbnxwF8ObD2TqNYJXT5lbeN2IIG68+E3iWwu+p7cAXoDw1lyILktx2gHUY7nvc9Llp7ew7YV9Dwue81z99LkHHIzqW3/HBWRq4CoAGK1kd2Mb+Es0Zs6jxb7KxQhHcwwg9gEyFciMurU2VvFQmipuePZxzJe7KIxqQhS1L37CJgBDqh9aM5l1Br8EOmKQstiHONPrUE+KuCPMW9ShgWG48jz/fqj1TvpWaNYaSfknyd2r4fHuDNXAUfISTOcSTYqga3BVuEjE6+6CB03Rny0+zji/0J2Lii/9tQQWmxffKmEGLJ76gTA0nptQkRVHtpuhU3/mH8xXR/GCMrY5KUF/6yckPpb0BGxNWwYEHbLYJxU4bu/UQ4Ml63U9zY9T4f3iI1J0QpFvP7h9Rvbnc0PFHmKLpXKYQVnPgp2Be6mOOypnKxaod0Y2zRZLoa59klM/qwJINaaq+HydNI/BsV/qe19OqAprZgs44IG/BiaS1jm6P28BTBD76zFfE9mXAqjokWitSRVjchrup7zYMv9OKNpmO8a0FuENVip4ISCzBOl2htGcPTzmwwdE7BlciTxvr0cjMmYDD7C66LO0tenbxxambZbDxJWjr36AaRyl+C3CS6EAVha8miW9Uo7Nrs5EhphnPiBxsYKMTDNj7e/9ImKQztbbbeHuOO1d5TlbM2tcCKAExn3qpxFhvD/2i9Ukv5h0001C69eF2oYMU/1DKaKZvPnbVjySbyWGHYUmdwclqCSo1HFPfEbDE3nexFCRjAL1tJy3nXyuwR5Cx5e/poKVAGxQBSnkYOPllOwFU9le/IhoGsrtt7pVecDFzM1i1xbIqAWlXEEawxt2Y6pdUcosGCd/O07rrs9iOUNgkkXKhvpmitER4/YAzGD2ZiNPi6YHtdf1/m6LMiUl5qdm6
 6w2SQKZV
 7Aic2DwKVolsnCL6rhHakuZM773sf0oKvwZkIxLpj/uqFsqRI6waJthgf9yDZkiV/V6CejWf38ME4xacaAYz+JRwLJkLBawo28j8G4B9dh+mg0bqvrQW1Q43DfvWqJ9baGhid3FRxUDXTyUgQJlboJiBrPkdybZEEHDmrxJr5LUjlWyvrRh86Cy8Ut6GoUwVbFTqXTX98cfSffVyuuzsjTgCdj1T1RNvVjQ6C+Q1tb9WeNjfCdFt8n0kcu3q20bX5KWL5sIfMJcKoEUzKPb+KG/s3n50clUKDwmLWPAK6XO9hbUHFMTLCJb07cfUKikR+k8EradxsJPwkiiVwAL00Ddneng3nuzQ3YXOFIDIEwk4mstgmid/cvtVrt+2bPi5ZGq4qMKWOW1pN5t4XjhQuOQc62gJaad77krEzlZu3lEVF9sKl+v7sNnrYMrQRtDSfHeD6/cSDgXpQh5o4YDnhFWDxE6/84W+Y1glbGfx0gt6wOw0iKsHFbxpxu1s9/atjvk3pvH1QmLqBoIw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03, 2026 at 10:53:24AM +0800, Lance Yang wrote:
> 
> 
> On 2026/7/3 01:24, Zi Yan wrote:
> > On 2 Jul 2026, at 12:54, Pedro Falcato wrote:
> > 
> > > As-is, khugepaged and writable-file opening exclude each other. A file
> > > cannot be open writeable and have THPs (because the filesystem is not aware
> > > of them). khugepaged will never collapse file pages for files that are
> > > opened writeable. On an open(O_RDWR/O_WRONLY), the page cache for that
> > > particular file is dropped. This is fine because nothing could've been
> > > dirtied.
> > > 
> > > However, there is an edge-case: collapse_file() might not be able to
> > > coexist with concurrent writers, but it can coexist with dirty folios
> > > (from previous writers). Therefore, the following can happen:
> > > 
> > > open(file, O_RDWR)
> > > write(file)
> > > close(file)
> > > madvise(file_mapping, MADV_COLLAPSE, some non-dirty range)
> > > open(file, O_RDWR)
> > >   nr_thps > 0
> > >    truncate_inode_pages()
> > >      /* THPs are cleared out, but so are the dirty folios */
> > > 
> > > When this edge-case happens, there is data loss, as the dirty folios are
> > > fully discarded.
> > > 
> > > Fix it by fully writing back the page cache (and waiting) when collapsing
> > > file THPs. Doing so provides the guarantee that no dirty folio will be
> > > observed while there are active THPs. To fully ensure this is safe, the
> > > invalidate_lock needs to be held while doing the writeout, so that
> > > do_dentry_open()'s page cache truncation excludes this write-and-wait.
> > > 
> > > Cc: stable@vger.kernel.org
> > > Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> > > Cc: Christian Brauner <brauner@kernel.org>
> > > Cc: Jan Kara <jack@suse.cz>
> > > Cc: Matthew Wilcox <willy@infradead.org>
> > > Cc: Song Liu <song@kernel.org>
> > > Cc: Eric Hagberg <ehagberg@janestreet.com>
> > > Cc: Zi Yan <ziy@nvidia.com>
> > > Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
> > > Reported-by: Gregg Leventhal <gleventhal@janestreet.com>
> > > Closes: https://lore.kernel.org/linux-mm/CAFN_u7H_0ECF3jixP=T=U7AH5=Q3wQNvJMo8an3VqUDMerQfUw@mail.gmail.com/
> > > Tested-by: Zi Yan <ziy@nvidia.com>
> > > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> > > ---
> > > This patch is written against 7.1.0 (because the code no longer exists in mainline).
> > > 
> > > Zi, I kept your Tested-by, but I had to move some things around and
> > > use the invalidate lock. Please re-test if you can.
> > 
> > Tested it again on top of v6.12 (the patch applied cleanly) and the issue
> > is gone. My Tested-by still holds. :)

Awesome, thanks Zi!

> 
> Since READ_ONLY_THP_FOR_FS is gone from mainline, just to confirm: does this
> only affect stable kernels, right?

Correct, current mainline doesn't play any sort of fun games with
truncation and the code is fully gone from do_dentry_open().

-- 
Pedro

