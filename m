Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94D15C5AD05
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 01:36:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9D2C6B0088; Fri,  7 Aug 2026 21:36:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A26606B008A; Fri,  7 Aug 2026 21:36:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93CEE6B008C; Fri,  7 Aug 2026 21:36:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 062466B0088
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:36:16 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 399D7120288
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 01:36:16 +0000 (UTC)
X-FDA: 85076386752.01.19B7C01
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4F22840004
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 01:36:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="LI/AXB+s";
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786152974;
	b=nWdWWYgRcE9e4aiCY0xVZMsW4tK3EQojv/nDpOPt0yNN6Kvvsm0LD5SyTJuSLBKYJ/twpj
	KFPZ77F1XRaYO6brbMK2RM2xSD2mjnFNITBSdJ2QWp2FYVYVRdAuWhNAZR9529Xv0AMH4p
	lEiwTQu2djxhMrclpMUFwFtYqA6+YHA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="LI/AXB+s";
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786152974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mBze6R+Yde21iZRthxsluHvPvQaZpfZt7IhiN6kDbGs=;
	b=KdOsZMu9O/w6QE+DaygY+8SlGoTH7kxcFuonoO59sRDg+YkXDwPaigev/l5R1Vq1vZ/Osj
	n0/soZQQaKw1pvXQg9vl6Gei2tVzw0suxALoZ/fjYiUNkYrwqCwti/NaZjtNzooZ6LzWCi
	chCFhgfV2D1qHgsaioq9mHsqMd7TMfA=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786152971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mBze6R+Yde21iZRthxsluHvPvQaZpfZt7IhiN6kDbGs=;
	b=LI/AXB+sl/lAsfXlZgmEG1cRftwk6gDS1C1hOcW1gnixTb7sKudbdP/f+F4XA2F7tLCXnF
	e6sGu5pPc2E6cB4241E+FS8cHpWkWeVlOdYK7nVO+Y0KFRjnp2wcHfJhfjzfj4EZURu/jw
	/XzeJHn5jY4kzwNsJMVweKHyhZ5XDBA=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v3] memcg: keep folio's objcg same as its node
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260807142406.443516-1-shakeel.butt@linux.dev>
Date: Sat, 8 Aug 2026 09:35:36 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>,
 Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 Karl Erik Hofseth <karl.e.hofseth@opoint.com>,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <9B30927B-4154-4FA4-B62E-425F6EC4FA89@linux.dev>
References: <20260807142406.443516-1-shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4F22840004
X-Stat-Signature: wuz1ddehsoowm6og11wqe19mm7x8idfu
X-Rspam-User: 
X-HE-Tag: 1786152974-20330
X-HE-Meta: U2FsdGVkX1/hyAyR45jMcrerp6Q7JFUHH6oOSZ/9uRcZjCUQ/bl2yKtCiMMhAoT3xANLRr15NUC7U3JNWtwprKTOY3L4sN15DHKv315JHhiawr75GYD07vtkUq9Ucnot4W2nWEkEARuoTaw4TWHnP7/fgRofMwaKdhjBIjRLPqdVDIedbDBnNnoFQYbJvLovzbZxatzHEXKqtVoTF/twGTGrVBZQKwhmA9osPq6pOMofbuWxArVvoFoOrh9fHPD7ihv/xzAeEQ4ryu0Wc85nnKdXDIvuhItmp08IGboRXrbw6jnSg3U5Y3zyssnTSeQPj7b7i4+HM+p7RJc7MtrrYr4omzgM2bjCp+skE0H6KcLp5sTc4t/o7W8q3Yi2BAJZZUBNrLuYznNoAg+PC2i6EWBexeBrEPml3XJGDJSQ2zCmig5h/BM97y34M5+hTvtqhgE+q9iinU3c+RqIyXzhuCrp64dXVo2m8I5X7/dV2LIXR2MAXqNmHWdnUY1vHUzOvTzZC20ZrM+tgVZjaaDA/JbOtbxMACZvt/Y7mhEEoitUAyqPSGMOjciOl5O0ITi0TjNFb3URtxBCRcN7oosoqKMsnQmGrzODyDhDxow47TdCHe2oOinYBbup6CGeJrSBM7ne+m6cQvfgQhbIqME+mxkzTYmOiDmppWkgBN5b0Y0zJB8Z8HctFftUMDYzE8XHW/vYs/5JB6UJCouLs5KpsnwfIUT639kHJNrpDG0/lZL3cuj3y7baoVlyZBsiCOIYFdGRiApzbTtGaQjYQuChgwZGriSmM3uO1BRYqKzzMy1vBy9nsRn4krTZNGsLIl19hUHAcYMHSYGMO1DJIpGpuk+A8IzzeD0Nnp+SWlj8adk6mgNYNRzXBXmaK1wwLZm5RUD6ADjG/8SPGYxHoYhU9jyffkQS38retJwOAWgQvULn+ZRkgeaEFLYuULIVSmHFADF2tEZhI1aoyESVrD5
 dvr1bspV
 M8Q01XqqzOZA98d23ScsuM6nJXLjU2VAT5us5SXZL8D+kk6TiojmQx3Zgx3GjFCcmmntMiDRXTsHnssIg2V+rRx4Ez0Ypk827KHxEAeWgxK79+TGfd73/XXILwduwEZk4XxaNZ8Cj1aKtxbL3ZUsE9OkBZHBA2lJ/WGHqszSrHpPCY7QDOsE394l31Ppiqe+lTGymrg0WXS4LnYRnHQYjt/EH/6VOBTmLlbMHdO8JIyByggPSqnIKCt8JNyMBQrRZPwB+qg8nPMzEUhcvGOpBEyCSVcUtDejPlpR0HzFD+WJ8vQuHbmOJvS5LWe7iwlE49TBdcPNtRtj3f0ANt2tdmo6Bud7IJfSEqnD1yx1fS682XdAdQWdokJT40BjdQmZsgNVJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 7, 2026, at 22:24, Shakeel Butt <shakeel.butt@linux.dev> wrote:
>=20
> memcg_reparent_objcgs() has an inherent assumption that a folio's =
objcg
> is the objcg of the folio's node.  Folio migration across nodes breaks
> that assumption: the new folio simply inherits the old folio's objcg
> while living on a different node.
>=20
> Once the assumption is broken, the reparenting of the folio's objcg =
and
> the reparenting of the folio's LRU list are no longer atomic.
> memcg_reparent_objcgs() handles one node per iteration and drops all =
the
> locks in between, so the objcg gets reparented in the iteration for =
the
> objcg's node while the LRU list gets spliced in the iteration for the
> folio's node.  Any LRU operation on that folio in between resolves its
> lruvec through the objcg, and thus takes the lru_lock of the wrong
> memcg, not the lru_lock of the list the folio is actually on.
>=20
> Fix this by selecting the objcg by folio_nid() at charge time, and by
> re-deriving it for the destination node in mem_cgroup_migrate() and
> mem_cgroup_replace_folio().
>=20
> Reported-by: Karl Erik Hofseth <karl.e.hofseth@opoint.com>
> Closes: https://lore.kernel.org/all/anMmd1ADrDVwMO6v@work/
> Fixes: f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of dying =
memory cgroup for LRU folios")
> Cc: stable@vger.kernel.org
> Co-developed-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


