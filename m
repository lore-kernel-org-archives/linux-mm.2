Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E357606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 20:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PgRwkHww
Received: by kanga.kvack.org (Postfix)
	id 75ADE6B05B3; Sun,  8 Nov 2026 15:07:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 713216B05B5; Sun,  8 Nov 2026 15:07:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FB8F6B05B6; Sun,  8 Nov 2026 15:07:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 389F36B05B3
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 15:07:52 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B2FA31A04FC
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:07:51 +0000 (UTC)
X-FDA: 85413037542.27.739847B
Received: from relay.hostedemail.com (unirelay02 [10.200.18.65])
	by imf04.hostedemail.com (Postfix) with ESMTP id BC1D24000D
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:07:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794168469;
	b=ImM3rmydiU/IzpetXoaItADsZjTBR75dHH/dCVhGQ4gUh7qwcbZzG6NHp0gqKuNTB+tNor
	jn7fRj+WbCm9UnwLR94JsHPTmjmj7pBAfpt/hsN3WyTzDqwNKTSsA84WroVHEXwAt2LwrY
	RhorV31+vjovn5loe7jNmuTZnz8qqZQ=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794168469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2TO+CpsEMkIicevAnwrknqp+HSpjmNynu9r53SRPWuc=;
	b=d1ZdlVTN+uDHYz4tIh8lrDW6VyVWdxXEGbDLFJ14fRPk7kVH8QFINYB3NjnN1GT/i+H0c7
	h26TptGdSzBsTmHcDYCk8IwyO/iaNnjSsuq8lrkBuDNrzh6iPaYyXNUxLTkIuBTg4HKGG2
	X5OYzSmkHv4vA4v44WIPFS4Y0sf+Rp4=
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5A75D1204C6
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:07:49 +0000 (UTC)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2AB18A04C8
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:07:49 +0000 (UTC)
X-FDA: 85413037458.09.510200E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7D7DAA0009
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:07:47 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794168467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2TO+CpsEMkIicevAnwrknqp+HSpjmNynu9r53SRPWuc=;
	b=sSDuR2EtSfZ/DX6RfRLgw3Yaseb8XBf3r/BY8bc1KTYiBAbIZiFrUAi4yUCpKQ3jFU845R
	nPr9ZTnXFCZEVb1o16YRZ4xGx14K6jR8mX4yXiaP4L7H5NtGYKpXXgskn3WJwdKl7sjuaZ
	PfC7nQsD6nKluWt4zpugQQ7Kfki7u8c=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PgRwkHww;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794168467;
	b=2ySkhaX2I+d50qaoU3FHFMDf3ptAkm62Uv9z5G82xWsAJq+I5zC+QJztDbKBHkgNeefWJ1
	MugwkDQZL+rRz7LoJhnSNTMOaRpb8K4FtLlv/SujjdAakGTNM2km4lHk3KcOv11IhNwZh9
	AkcH87CQ2YjLnXhkFG1uDmcdEgMYgnk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C20384115F;
	Sun,  8 Nov 2026 20:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A2E1F0089F;
	Sun,  8 Nov 2026 20:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794168466;
	bh=2TO+CpsEMkIicevAnwrknqp+HSpjmNynu9r53SRPWuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PgRwkHwwOmAE2ueWzcsEYsrtwZZxIFcB2QYHHOQN15qQM43ZwDti1n3zhOrGbqixh
	 sGNZoR1ISIeGqbr89cNSvODGlFtogYezoGsOmDsVjetf3yvL6zuLz3JLUeZuvg2+y7
	 uch30Ku/7hh5fwy9s43S5p9JbR45T908c0Ni6/IGw/nV9A6y74QvNnyae9vPMUipi0
	 sM2aYCx6Nh2KCZYMppTuclvoixIoRt/joRxrIbKwV7MME6QQvt6ftUfO0XMFBqwFJO
	 fepI2Bnk/djZYaXlKHUjODQFFOq+dMtFdBd2xuskq5zrSCP/b1b3rHAWW69TWsG7Bu
	 OG7UitbI8h0qQ==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Usama Arif" <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 6.12.y 1/5] mm/damon/core: skip applying scheme if region split for quota fails
Date: Sun,  8 Nov 2026 12:07:38 -0800
Message-ID: <20261108200739.116084-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-204000@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HE-Meta: U2FsdGVkX1+UCD62X5Wn+OW4zv70pnt29abJLg8mHkjxhDmeUC/VDoU9bcy/xsHA56xzIKI/AT/MMZnpzapDyPA0wprD/ZYhwEGIvqag2dq9lW0WL6+Qe5YQoTSVQc0wj6Bh4XQKOmS6hhfxGtOr6qed6TRswqEiQOER0R2QqN1YIDLyZ6R3HOSvt0wzQHXHJQet9aKPS55nSxPGNOR6u6ZaIyKXoU+pq9OZduzq4BwqYGGoGXrzvRmcinoUHjVciGdU5LcsdP5lM82CDBr59ghJKzYwdVaE39aCgqLKxT1OlYLBB5w3i8yZNAe0pa3/QIvyS+Oqg1hzLHb/N2cnkVAI/nWTqpja2iLWM9mvmKHN7GGtO8dQCDZBAzLgWaY+pDmaNAHQL46731/ZlHhsgadwbSTXIcZdnwfEyN9GIvES8jXQwqBxMMjMTIqwj7/rWAtoPwa1t/FJWuKz5Sfn7ZzxqnDJPkRuuUaurR9htPNRh0ZTvgkMrBa+aZfKq/tohb1YCJqPWa/pVPT4JK2SrYE7qIFe8dZmqthRNcqXq87yzu5MTalrB+kWEsLyKNm+AAJ/fZZF2vvB9b/iXDcVe9d3rX8nRsNaq1caC/ZoBmFSbUhIaMh1mvZPLdG9+ICN31rHzV41YPZpbAcPQwefPY1xgjL9etqK9hTrV1Mpp/J3WHSuRMSSzz+5ghllvijCshXrwyPuehtb5erohbK4nEnLtsyIxhdHXh6uu0mH0BIQUnsOl3lsA8JXPxcytlBAykSnkEZBy29HfpMWMgFHOZDef2yyKdDz+e5CHeZUziJ2np1cStRTPZscd9MJLzbJeayxTgMawi8AuW7K7/hvEFIVeI6SxOKRGBt1F4n9ZbXwjJa+LtiGxLXTemdXn2R5/QNz/pqEMdi+f+9XSMF58TIHR5vfvIJBXHB6WWeVWDu649O8Qd4lqGEnq7HjEM9yhuyVyNKLt+VJhAn/q7w
 y/lqxH5g
 mH/Bd9IKoAr+oqzmx2jsFzvY6RFJjaqU2JYnS8/MXL4pZZw/a3ljqVWKxkueE4cpd4gvbIqLxx4SAmmSFBQ1O3LrTizCuKXjdBoR5QcXvKTSG7SCfeMjFqJoMOySFLxZhSzhYidis8uJh+YqHR4bZILpoYD/O5joF/c9AWOEhUkKNkHlIm9tyBYbitPjS44bwJSwnCeXC/08Psq19V+dF4BnzLyV2qbJp8u0jB4IF7vqqnNYJoFKrSE5qiTx4oErkgBhbHPEpjEHKwoFYNNtXeYL13U3rwyvGMWZwaV4sDKhrCyk8QWg1lvnxvq0DhZdunpms
X-Rspam-User: 
X-Rspamd-Queue-Id: BC1D24000D
X-Rspamd-Server: rspam07
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: c7pdrjz771bwbmukdyhc17jpgqjwus87
X-HE-Tag-Orig: 1794168467-39536
X-HE-Tag: 1794168469-291101
X-HE-Meta: U2FsdGVkX19nblzLJP0+eKthDfBqAPJNS7SwptMcmgFMHFDAxFzWM23Uc5yZqp/sh3OeKtL9Ukn7OKvXvZBagxhErbXycdH/9EG+XUAmcqprEsPMRmO9DJwGJrSGnRnoPOtCq69g1r0WnRGdTZC/Mb30v8p1E4sADVe8cgqQQqVrxVZTtPt6cWzgoXsWel604FjPAIeoyFa2YH1Udg5sNszrdlceeR476seAdyIu8JxjeXnTtqvEbykLQqynI7IfoB9BaFdz9Fmfbg9bLCGkS73BhNlyQ7jEeme0Djfb+Tcn6pYHR9Vc/s5ql9KuHLmhFMslqPYKqilcDe0OAu0/2aZlW2UtYOdn/u6tLfPm1P4kVbIErqtbdJwzSL5UClaqLY4Asc7CeuHIy6lCTc4uNWDdvCkMOwR1vT7O7RNEb4bkpj8F2T4C+XH34+bHljK61hwitKihdAR0SX5GJqSj5DlxZbkD6mnlTO+yN6P8SRg/siEQrL539Xu1l2v/cUy7D24QftWnLNRubCrtWcBvVMBbGdu0RkrUGfWssGN1GnLYeOIJquVFgwiKS91RUrcy6ZrZ4rCJM/72G7Sgebn3/M7VIeElS/Z/xPZrnr5VvAfWfZRc2L0W+QjOBzslxbQRQLI47ULJzZQEiXWkwWn2AnVfay/s1GWi3cZbPf8oIJG9fsqE+Xpc/+v81ZSq+qzDtpHsimV9pd/dkSaKWU/58DysUThmkGvMyh21ikXqr+pE5Dn7WtUM5SBOGCMOxdboMeuGtXx7ncE7p1HE4fnlxka/X3PbENKzntnUeC7oZoAxOgiY4sRDXP0fE3BCfTogVhN6QQ9weX/BrUM+WxD8IUfB026nRWkPN3V1d079pPOb+sNf3JsFUPcTiwVeIh6VakgRjKt0MRRDKMC6wFRoZ91zoYTynl+TtUiaOjGEQKL0ATybRSyjbD49Ib3gyBOg3Kh2O0JrmYzFq3+9bHp
 smPT6PgP
 ZGsNFNWNatSx6vfQgzj05jUxi3ujG1SL2lunpJ3h1nZJqaDaLzymhzRkqnlQlqn+tGpODpsW8gpr4ejv31fq5Qyc2I3X9H7YsCi7ufar4Qe45VUpdJXBLCxLC5uYHnWc3dyzgcn4FecNEts2CoysYXjkQBGJlOwWC5Fr6z+enCqaKch9/0yku6Oh88R3t24faXcgCRqmoCN3ck99TQAP1pHzE7MmKu9nArQSaXXzdgGWOgJOSKaBAE1tDOnur6TRXqEcvPryyDrbSB0A+83UsqonlzHs+M2jOh3kdmsNBwp2jIweFnnMSlzXTj0qDRvKODPCYSv8anyhkm6sfnnysgFFzihZ76048T1moD7Zflbhb5r0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 08 Nov 2026 20:00:20 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Low] mm/damon/core: inaccurate tried stats on split failure in
>   damos_apply_scheme()
> --
> 
> commit 2d3797cf5f053ac8bc0b4587f17ff69eb9813ce6
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/core: skip applying scheme if region split for quota fails
> 
> This commit updates damon_split_region_at() to return an error code on
> allocation failure and skips applying the DAMOS scheme in
> damos_apply_scheme() when splitting a region to fit within the remaining
> size quota fails.
> 
> Link: https://lore.kernel.org/20260901131850.98037-1-sj@kernel.org
> Link: https://lore.kernel.org/20260901131850.98037-2-sj@kernel.org
> Link: https://lore.kernel.org/20260718171523.87547-1-sj@kernel.org [1]
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 81d44e41de210..6ef77741b783b 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> 
> [ ... ]
> 
> > @@ -1470,7 +1470,8 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
> >  					DAMON_MIN_REGION);
> >  			if (!sz)
> >  				goto update_stat;
> > -			damon_split_region_at(t, r, sz);
> > +			if (damon_split_region_at(t, r, sz))
> > +				goto update_stat;
> >  		}
> >  		if (damos_filter_out(c, t, r, s))
> >  			return;
> 
> [Severity: Low]
> Does jumping to update_stat when damon_split_region_at() fails
> inaccurately inflate s->stat.nr_tried and s->stat.sz_tried?  At this
> point sz holds the non-zero remaining quota, so damos_update_stat()
> increments s->stat.nr_tried and adds sz to s->stat.sz_tried even though
> scheme application and damos_filter_out() were skipped.  Because
> quota->charged_sz is not updated on this failure path, any further
> matching regions that also fail to split in the same walk will
> repeatedly add the remaining quota to s->stat.sz_tried.

Trivial user impact issue that also exists in the mainline.  No blocker for
this patch.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261108195145.115792-1-sj@kernel.org?part=1
> 


Thanks,
SJ


