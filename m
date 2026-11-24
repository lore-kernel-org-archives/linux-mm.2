Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52B62606A32D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 18:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aOCxnsb8
Received: by kanga.kvack.org (Postfix)
	id 56D936B0819; Tue, 24 Nov 2026 13:01:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 545406B081B; Tue, 24 Nov 2026 13:01:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 482766B081C; Tue, 24 Nov 2026 13:01:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 272146B0819
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:01:40 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 79A7580928
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:01:39 +0000 (UTC)
X-FDA: 85470780318.14.A24995E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id B761E40021
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:01:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aOCxnsb8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795543297;
	b=ZDt+RhbCw+0URjAbUMQwwJPghC3N+hKqGbATzi/3EHUzGYt58T5uesrSq7RpKx0ha9p+0Z
	7b7QajbmwHW5CIbXV5XM7x+fYSY/mFDr/koYl5EfZfCwCFkrNpaPE/UwIpUlLbgzeyE0Rv
	2XdNkWC4zuNqKPTNN5SamBgYImwoOrA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795543297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kHUlsupwDOpkHbLX8S2w072pY8Rr3ikdGTNicvjXqnc=;
	b=RyRdHC+G7eWgc6DMXTO7yzqbnwdf5Y96XigPcZ0i29nLBFh+idIL3sxxtt1J0HV3Nb9dSp
	T7rZbtsMH4m3I4z0DZlXQvNTssUxUBHES/QQ668u5UB2Bd5yQWckhgjpdzPM0cX+CbsGMt
	9Ih8pyRlcg2AGj3Amojxv/J7XmSjHQQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aOCxnsb8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 75CD462884;
	Tue, 24 Nov 2026 18:01:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF151F000D0;
	Tue, 24 Nov 2026 18:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795543296;
	bh=kHUlsupwDOpkHbLX8S2w072pY8Rr3ikdGTNicvjXqnc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aOCxnsb8KPo+uJrOTN2VG0/4LzIxOzbWkwFqqZPQqsYidT1LLQds618V5lhevH4cZ
	 ej1MUDUfWcJgncApHe/rrdwWbCxUG8cV5c6de3Q4njvOYqmVc01Uv/Y++uX6vESr2m
	 45lz90ReFnUu+mllQHU/ZP/mRkUaa9hXavmj0vO2IXP3+q1U/c1I27mqUXCb3ZJ/4P
	 vP4hw80hjwtC/HjjhEv5DXnz/NJN5w8MMALFsjvA68MUA+ciDfSjXrbDDhFLqZ7wtu
	 iq+89nJGM972PYb5N8h9knZmqK9DAfA0Zj9W07jBwwW1p57V47z4WmVx0uNShB2Dzs
	 +NX9oH8Lpn0+g==
Date: Tue, 24 Nov 2026 20:01:30 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3] mm/memfd_luo: don't use memfd_pin_folios()
Message-ID: <awXQ-sYNkY-TALqE@kernel.org>
References: <20261123130115.4021199-1-pratyush@kernel.org>
 <179546369651.425130.14155931836758567682.b4-review@b4>
 <2vxzo6bez3hs.fsf@kernel.org>
 <awWx1YnA0PcB2RaB@kernel.org>
 <2vxztsl6xj59.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxztsl6xj59.fsf@kernel.org>
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B761E40021
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: y44e3sbamuxg5f7x7zt5aztrktpgxi71
X-HE-Tag: 1795543297-173543
X-HE-Meta: U2FsdGVkX19qpR82W4u0otQT9CDxZoI+rJF4oUh+/XtxlJJ1+Yd43qFAv5pVwuzA6HiSpSkgJ6ztkQk66n1650kEMM8iiG4K+qDwS4ttAIylZALhaOBYaKAGBhOMOvTpRh3ZkhqvBzjM/z0z6D2zl5zGAhwonh+ACRVFOXE1Yf1Knb+U1A9fgJWWRusj9blZkqy3/Ya9oiPrROdc7a591V3u6yscVVwZYtgz0ZCzTfn+rPeNiDKYox3/K/+MQVO0qbm+25BggaTA4LhRR/Ib2IBdWKYGhMWTjYt0KGyuiSj3QrZglN3asjCpVEYZiMk9d4MVKk8yKY8yloUZBQlC7z3rV+T3qoKQzZK0eGrihkIWRc4WiNzJXE9a6RlRqQFcVi54+xWf8PxLRNoreBHFKjG46oKVRFh06LbCC8kVbrZWHTYA518aTBmyefZzYMfdNbh5mugadrzIC40Ixx+3RUj+dhhr302hocR1TNbuRrcQXgRTPJRTFUVrq0GEy+ixlq/+/8KI9FnupfXbPTHyqgs4nQHrazgP5SANeF2+TFsuOHLa3MjBijSE1xey3Pau4Bszda0tCLxvA8ty/TdLtMhRcFNqeK0TmmFh9XDYNl5CyEPuAJK/9dt5CV/5cf+wnCfLZD24ua1v2JM5CpMqxKYlYt/systVNM8xzHXAG1sjGoNAEsIIhs+dKGKsdQwTc90i2tUKze+gCX9eNJUqKQzIajlJ14d4MaTyjhfbrmxHyiOmeNrWFcq5CRFumUS5z4ygn3gQ97YTl1/IxvR5eK+oYE5ImCqp/x7A9hDfTpIj1v5O7cpSJwnCrYR5YQ3XYtRS5GxGzENIeBresppjHtn8QNO5Eih42PCFdVHThtaGhd1B4mkvMIMF3CpnjJ+7GrINqWxHM6ybAVknFWebVeqC0xKxzCFjjo4pWbc3Fe96sYVQoawshK/PYRA0oBWW6dpkJoi4RpzJe59xqzd
 MDjNSQZU
 xRooIu12qH4Wup+1fo/xDaLTmiFqpkqgkDrzUglXC9W1Kx4icfEZ/InwbYFi1KXeDj8C6yDueMyWBsNP0gXkxH6ztkJ6ho8CfuPHr6sDLeiV3Oxmf1f+s081sde8tzY0dsCaOZRLnP932Jrz46bgtykMztgagQ3TpkBfyvUoKvLkK4QT9C1vLNSCEm3d2/DaiWEmpJ7FPI2mJRK9eCl3rpxgCupI+fnpcI3g++IuXJCh8TSGwLVLMni5IUw3PDmeBOz5tmeJhewt8s2leW7f8zgIV0kK42NprXh9MYqjnzwfoC+sT2DM1Y/33ybNkGMqe+UcRw77KKj8zw+8e3g0zMI2wpEAkUjOXTHLOfKJni82Q6tgdfVPK9YBRPxsTqRJUMHAtzpylTCu5mFgqM8UTIZeyoyqUT9M8tPzqjATS8lrqM1t7sqyhFcHS+86AcdBGfqD13xvCTH7v08GY49tGlxmNUGzjvOh1zWbbTwV2C+h3pDjV25uuQNETtudbBwb3wp1tasMnE4cbVz0Mlawge3bYfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 04:56:50PM +0000, Pratyush Yadav wrote:
> On Tue, Nov 24 2026, Mike Rapoport wrote:
> 
> > On Tue, Nov 24, 2026 at 02:51:59PM +0000, Pratyush Yadav wrote:
> >> On Mon, Nov 23 2026, Mike Rapoport wrote:
> [...]
> > v2 was better I think, but it still had that
> >
> > 		if (err == -EBUSY && ++busy_retries < MEMFD_LUO_MIGRATE_RETRIES)
> > 			continue;
> > 		if (err)
> > 			return err;
> >
> > which I don't really like.
> >
> > I came up with a variant below that IMHO makes things more explicit:
> >
> > static int memfd_luo_get_folio(struct inode *inode, pgoff_t index,
> > 			       struct folio **foliop)
> > {
> > 	int err, retries = 0;
> > 	struct folio *folio;
> >
> > 	for (;;) {
> > 		if (retries > MEMFD_LUO_MIGRATE_RETRIES)
> > 			return -EBUSY;
> >
> > 		err = shmem_get_folio(inode, index, 0, &folio, SGP_CACHE);
> > 		if (err)
> > 			return err;
> >
> > 		if (likely(folio_is_longterm_pinnable(folio)))
> > 			break;
> >
> > 		folio_unlock(folio);
> > 		err = memfd_luo_migrate_folio(folio);
> > 		if (err) {
> > 			if (err != -EBUSY)
> > 				return err;
> > 			retries++;
> > 		}
> > 	}
> 
> This has a super theoretical corner case where the migration can
> succeed, then the folio can migrate back to CMA by the time we do
> shmem_get_folio(). So we can loop infinitely.

Oops :)
 
> I think the if (retries > MEMFD_LUO_MIGRATE_RETRIES) should be after the
> folio_is_longterm_pinnable() check and retries should increment after

Maybe after folio_unlock() then?

> every migration, not only failed ones.
> 
> Apart from that, your variant looks nicer.
> 
> Does that sound good?
> 
> >
> > 	*foliop = folio;
> > 	return 0;
> > }
> >
> > It does an iteration more than v2 with the same MEMFD_LUO_MIGRATE_RETRIES,
> > but that's not really important.
> >
> > Your call really, I can live with either of them.
> 
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

