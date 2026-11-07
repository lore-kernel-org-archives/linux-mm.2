Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27D98606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 22:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CIKJ08AS
Received: by kanga.kvack.org (Postfix)
	id 04B9E6B05CA; Sat,  7 Nov 2026 17:37:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021CA6B05CB; Sat,  7 Nov 2026 17:37:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7CE96B05CC; Sat,  7 Nov 2026 17:37:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BFD7D6B05CA
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:37:41 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 41F1D40460
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:37:41 +0000 (UTC)
X-FDA: 85409786322.24.CAFE95F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9ACB3100003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:37:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CIKJ08AS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794091059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uTIW9ZNXo7IGqTDCIPcbW/4Ni86f8N+1UGLWhTVhaP8=;
	b=7dvA5BiI6dX+bWQYwA8YJzgjJq1Ey3c9SGvFMirdcvLjp76L6DLk5yz4jLZSN3WHynt22L
	g/TnS06M3FCiAxVbXjKYPjljzL5eznd7qKreChVL3rmIdDAkMa4YFnYbYJtrpMdDsp3z+O
	j+QXtdhMCCA76h2wY0OUPilaOl9vL+w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CIKJ08AS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794091059;
	b=ulAdauNFdJZWu5VVlKiASUjyPPlyABqLwRForjpLA3Ow35GQ1SG+T3AYHry2ztvehYOz0r
	BJZHTgv11QdX46+nsinZHTqVId/LDdgqyp6GW74CG6tkb6IbEUZ1c18XhULQqN7HIfw17U
	m6vAsN79MWTseE0CMym+HKNoRN4Gr84=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D0EFA61213;
	Sat,  7 Nov 2026 22:37:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACF71F0089F;
	Sat,  7 Nov 2026 22:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794091058;
	bh=uTIW9ZNXo7IGqTDCIPcbW/4Ni86f8N+1UGLWhTVhaP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CIKJ08ASs6Z/18JYlAd7yBe6WatK4BqkdG/0IGe4R30w9gZQUdYrT2S8/9cYK2RSg
	 scu5N709Ae8PvmqNXQWl3KxhUuiNoVanGaRRRUV2sF6m2v8FO8b+ugVxkLx05Wo0AH
	 PcSyHi4UU/gSBbm/s+W2g8nruCmUBikifij8wpdKWBY/dXlAnMka1VMyssO5YaVG9P
	 ZhZukBKtBCluRLYFjEbn9SUr6LlVx6GzZqx3Pur3jJCEnBTAR5/TenfHmO0gVLnEkJ
	 4uUKl+cLP6Yhry/nV/4w1IOEC5OXv4XohmtrgN3l4aAgu6PacUA+mX7yRBQBPC1E+S
	 MnTathE26L9KQ==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Usama Arif" <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 6.6.y 1/3] mm/damon/core: skip applying scheme if region split for quota fails
Date: Sat,  7 Nov 2026 14:37:30 -0800
Message-ID: <20261107223731.331778-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-203366@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9ACB3100003
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: a4xy1nem8caamssuocjoejd3xwgom9eg
X-HE-Tag: 1794091059-734904
X-HE-Meta: U2FsdGVkX18YkG2pp1zuxmK5i1JW9V73eyznjUrIBNgdNWDUgTEgJ1m0Q6Nj9oydaK3Un47hcXwUrTxs4eHu6zVElZ2aWtzrjIeVFg2C9lgwvSOPN/G4X3FOEjSev3FONdbuqLT0eb6O4gIbkjqP8X7eX8GBrTRBZcb1Z1HhdnJSyiAF42kzbPvUNHkf6dNqf4qDYSzZOXOBwiC7v5yFfXauZ6tZmBQyC02LsifVMios9f3oUrN+W2nlWMlHbKa2SS1tCsajas5ZI4CRwRkqUHyToSml5Cnu0K5xeVl848efYnmNv/x75B68lGnb3ErY//TSvsfOYyZSk6xFJU+CtZLGKyZe+RFTO8Rg51U2x+s8Gxsyfeuz77tnTu18DPPhjPLuQWvNzWec5azs++OWMepSBhyt5PCi7mil9NShsfTP4COXhlXmJfHvhkKhwxHJJuwiUx93ZL/bfOhl1GYKhhS0AjxmgePNEyF76pJhA9wy3AyezokI0ZV+o6ANKuJJ773vdMRmg/Mx8bbowUwJyxXs7Mjis6jAI1tyzBuqOMwK0dj+c/B7gJn9HDYDzpcKjgViIlWiKCMOzDeCxbiNRT/yNVUQDViAtKDtoTMwi3UdRJe69WEbRfgg5IM4zMV3CJw2i5Vlyg0elgudwNI42Kcb9XaHMpDIr1V6CFT3Mhlm+IOhpMi9N602TYLyDC3IjVhriTbxAOQMu7Ymbi+WUzUt9jRVh+7UFEkXeD1DsSkDnQrkwIMxfccWzG1sXh5P2kq5sNXFZKwvhNRfXr+IfkLEvNGaPcYZ0qsIRYo6VuzLlRJo8lBegDWkOCqIS05Vs8+ghzzdfFAVkItuhI56snjFnBrV49/twCXHwLNNFCz7DSHsj2iXVQumrLNF5YLsUdSCkBNrTezj0J3bUduRrRyf6Z6YlBXwEhBr7DyU+Z9KEmeRW784BgVwo2dyPvTiy3KgrkRbI9vtzsCWMxj
 A4Z5Yfki
 Ia9OtYPkE3w311B6gFb3xtFjAxe+cYgsOOP8X+dYKssF9v0SYRS/wygaLrUGmFUegSdkv6xrfC8gd9rwxhi0kdyqhrVJuAWuJeXYssTTANJO1X6BLVbPNlbpNX3vm6HA9dardfvY4KFzi7g2T3mnSisJI3eaWVcLNjXOiCt+oqrHBVa+qooHQl6dIKqhLDNJbYVwgeC0+zlvWGvlHRj0di4tZjH2ZxhqJreUYdEm56xfO9Gla50UEQ23TCb6fBGgvZG6o4+E5tDSDv5+VX9QVkpPsYe5fkgURp6lu7IrouYDgq24jSq15pfaCkZD6P1ve4UTA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 07 Nov 2026 22:33:38 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] mm/damon: false tried stats on split failure in
>   damos_apply_scheme()
> --
> 
> commit ae5a2312a946a6108ba6414ca8a1f6fb984dd078
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
> > index b5b6d00d7a3b5..9d4a78deaa06a 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> 
> [ ... ]
> 
> > @@ -1004,7 +1004,8 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
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
> [Severity: Medium]
> Does jumping to update_stat when damon_split_region_at() fails inflate
> s->stat.nr_tried and s->stat.sz_tried?
> 
> At this point sz is non-zero, so damos_update_stat(s, sz, sz_applied)
> increments s->stat.nr_tried and adds the remaining quota size sz to
> s->stat.sz_tried even though scheme application was skipped before
> damos_filter_out() or c->ops.apply_scheme() ran.  Because quota->charged_sz
> is not updated either, every subsequent matching region in the same walk
> that fails to split will add sz to s->stat.sz_tried again.  Returning
> directly instead of jumping to update_stat would avoid accounting the
> skipped region as tried.

Good finding, but no blocker.  The user impact is trivial.  Also same issue
exists in the mainline.  I will think about whether to fix it in mainline and
backport to stable.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261107222202.331476-1-sj@kernel.org?part=1
> 


Thanks,
SJ

