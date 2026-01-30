Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00222D73E85
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 00:51:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63BFF6B0005; Thu, 29 Jan 2026 19:51:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E67F6B0088; Thu, 29 Jan 2026 19:51:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E8976B0089; Thu, 29 Jan 2026 19:51:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3B6E26B0005
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 19:51:07 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D2E2C13ADD7
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 00:51:06 +0000 (UTC)
X-FDA: 84386800932.10.9BB8349
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2A8F6140006
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 00:51:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Z/FaQ/kg";
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769734265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3beR78siDEEmK2spAD/HgnCu/E4OotAxU6+k9E99kQg=;
	b=0JcR5fKs0d9e6S/6KsyRTTHTseUb9CQl4fWjlG9NoNF3quWgdY1aeFEZ6D+Ft5xoqNPFw3
	WkxtPBHO2ly5jSCZtH0ofbf6MxuCJl1pcMc9xkVONHPJPgmWTa7Vo88ls9Uj0m9oiPkoGM
	ekTLdjuQoo3sCseNw0b6/KU8b+DCQBM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Z/FaQ/kg";
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769734265; a=rsa-sha256;
	cv=none;
	b=bgdcuy2peKY8unyy+hgngz2khnYXwDq48Wq/9Nq8rheNeA80AQANaju5FacBtLdZPmI26B
	AS+Crf3HD/hdkE0mNHbssZ+Oa+1q2mBkJncs9ppS7pjFcePr51SSZUZywEs5+fXL1E/L1m
	EfyoS5AayhyejsgqsK4NPjQ00vK+1kU=
Date: Thu, 29 Jan 2026 16:50:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769734262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3beR78siDEEmK2spAD/HgnCu/E4OotAxU6+k9E99kQg=;
	b=Z/FaQ/kgxOCkIdV9pj9isA31VgQFflC/MoNR38FryrcwIrK5Mas3RvcmCHNpwvvJWp4BSU
	u1jPf1N0mdSlIcRcEclZA5y4KSScu2Y3nwpAt87BQPqOY1spg5dQd3LjSS2HtQs5A6NZsX
	JDGHWhKyhKG9PMhWjxlqmTcvcshg0Ig=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Rik van Riel <riel@surriel.com>, Song Liu <songliubraving@fb.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Usama Arif <usamaarif642@gmail.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: khugepaged: fix NR_FILE_PAGES accounting in
 collapse_file()
Message-ID: <aXv_5Gl6L-1eXYQd@linux.dev>
References: <20260129184054.910897-1-shakeel.butt@linux.dev>
 <aXv8DjjJ3zqZEsgQ@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXv8DjjJ3zqZEsgQ@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: ydh17oqfefxqrpziifeeze9tdxxdk385
X-Rspam-User: 
X-Rspamd-Queue-Id: 2A8F6140006
X-HE-Tag: 1769734264-177306
X-HE-Meta: U2FsdGVkX1+2ALtIWrZ48G3jofnhyC1tWvvUDr0U97kh8RmjjI23lp/7vGP9Ficif2qN6F1P2hfJwjt46oquq7loga2LjmTrvIInRx5+F+yzVGQMbZMD6SMJ3In5l687S83DwPaYi+OZqjY7vZyToGesSKfQd/IuNTt8mljcLhW9GW9QUk9n59E3A+8fshT5DvG3fywsFwTH3F3dc4p3ZnGR2wxO5M3bdOLMnRBQKBH+n7yzSkdAfh9iP5IA2QNFc9xon0UG7RFypbRmya2QgdtFPSv8Jf6HxN5QNUJo4tOOJABGlVGqAkNzapWczr7Y6RlHmIxULtCeVC9nQHkrXuZGv6D8xa1oLZJLkjQdfqkdhHalh12jyyWJUUcZgKS8ZROgOGIVZd/1mAcIWeItNHqY+Z0nFcxw88OeQd2KuPdLuZBqdwzpwvXimD5Ia7Cr/3fIEjyIVeuyeGny6WIbGnatik0wDYTRAeLX2xEPdLx7d4qnX5NXck3s02LlzU+j/iz3VlS6iWQplu1c7sJsG84hCt+v7cIHbYzv8eJrBCangbKMkjV0s0bjRhUxNDuRQxKANKNqwFXsIa5WQnQWVmNPOzy0A0S8pDM/fD6hxy1dTxuz0HUvmCBiU/rot3icIzN/LOSPI4qNT5OGWV9/hWlxrZHMQ7Dzk7pQcO94bkY1aADC/ttUbqvNX+W+Zb5nqyy0926rD/YYeMyqn6x6i1MFgAVBjvcKWxXNKFUtNWzCQ4lSc6enPiv/pcGgbAHO8+Zj7mpwabsiFz03djJCugb7BBt3Rd8lSn/sRzcQcGaisaP5gWuQwLpDfFuqqiCU7IUdM82Ya7GcBN4hSn+yeD5ku/QzW0edsA2PjTaPZ3Uzh041Ky50qKFy6x9xlo4UbWaQEMRKfy273Wy5XAvFNkjAsMkG7I4SMxNzn4FQKZG1D7+5jrwWtpbYzg/6gi0z9vt2WGE+efJtw//YRHx
 kw/deSoj
 i/iXNxjh2FuoDncsz4hrun36tc2FFUUgQpzGA1EVgr75y5Gb3012xecq/9v5UFmrWLWJDXD8R02/PIWF9AAYVjbSCTI4Ncmy4VJGPOrthMqnJEiu9XMr7rKcsk7+3h7/N0c18MInRl9mhAFPAeHmbkkmiIYNWLG0wKTkyTipjcqvDJVXVhIYEdh4jllWmLqJri5KCJtzEjtbjPVH35q/L8n9dZTUbcLQyZL8FkY68fkFGoVgvaU5WoA5TfLC/cVhoJ4za
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 07:32:14PM -0500, Johannes Weiner wrote:
> On Thu, Jan 29, 2026 at 10:40:54AM -0800, Shakeel Butt wrote:
> > @@ -2200,8 +2200,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> >  	else
> >  		lruvec_stat_mod_folio(new_folio, NR_FILE_THPS, HPAGE_PMD_NR);
> >  
> > +	lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, HPAGE_PMD_NR);
> 
> The memcg breakage is more visible, but I think this has been broken
> for NUMA stats even longer. new_folio could also come from a different
> node than the subpages, after all.

Indeed you are right, so I should blame Kiryl instead of Song :P

> 
> >  	if (nr_none) {
> > -		lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, nr_none);
> >  		/* nr_none is always 0 for non-shmem. */
> >  		lruvec_stat_mod_folio(new_folio, NR_SHMEM, nr_none);
> 
> So AFAICT NR_SHMEM needs the same treatment.
> 
> It looks like that's been broken since f3f0e1d2150b ("khugepaged: add
> support of collapse for tmpfs/shmem pages").

Thanks, I will send v2 with correct handling of NR_SHMEM as well.

