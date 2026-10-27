Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFFD6606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 18:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VV3mOqzm
Received: by kanga.kvack.org (Postfix)
	id C4FA36B0882; Tue, 27 Oct 2026 14:05:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C263A6B0883; Tue, 27 Oct 2026 14:05:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3CBE6B0884; Tue, 27 Oct 2026 14:05:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A9996B0882
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:05:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 93D771C44D0
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:05:23 +0000 (UTC)
X-FDA: 85369183326.10.81B0B45
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8E0D81C0010
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:05:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VV3mOqzm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793124321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XCGMXv1E+uWpaO8NFz/pJt3NA5N0H2btcYbu81390RM=;
	b=QgOSxdYD5XaEH/AH5ZLG8GePBcBA6qVv3ocupxhNJxsyXM/tNEMfou/GEFtdq9WZbSsG26
	/lZEsb6WU1JcFnSQdkRoG8ixhSsEgyyXrdqlH6V/wIBHOXPvxD+EO8KtHjPO6zZJtcObQB
	Gom7d4oG+TwPiFLEet+6Ro3bCr5Zg9c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VV3mOqzm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793124321;
	b=oYpfwlfmYruwV5qMBqffITdo+bZcL1VnKO5OXD3Ic81tGdKkXyzyL8jQGff0b43vCUk5hL
	FnvWXjfsfkZHqDlze2M1FbVvcy0oIScjwa1NmsbRj/fG5sbCpsbpFTBwC/6MgMDUX5zbqT
	HaEdIdIRGglR2yFN5XvXvU/fOOSrZAk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B267B43DDD;
	Tue, 27 Oct 2026 18:05:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1FE41F031E9;
	Tue, 27 Oct 2026 18:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793124320;
	bh=XCGMXv1E+uWpaO8NFz/pJt3NA5N0H2btcYbu81390RM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VV3mOqzm6xlxH9fgzJb/Y5ilnua0BzAorwYuAhVNH51t67yDxA0SsJKmTC0KOyFd7
	 JXRXHpJdwOaD1howqkDOM6wEea35xUu4TZGucV06wwcmwQXWlXcHm5VSMyRMYRLaC8
	 boBMq8qTYn3CEuIEz6amnD4K3JUeHX3wgRYTmF2MuikCqZwmXjYmku8a1ebgN05+D8
	 cBh+SDXGxcThd35KFRIkJ0iXRcPrlo+IzsasFXtMr3mLQHHJ4p6aTFoM3BxKQgrEfl
	 EQ1JFyxTKAK8t3l4Zp2R4m/fxX4RcrYgeTaKiYVWcCSQOZ4kuXpzmO2T4pG8Xsur/U
	 1/uAfroW1k/cw==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id DFCAC198004A;
	Tue, 27 Oct 2026 14:05:13 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Tue, 27 Oct 2026 14:05:17 -0400
X-ME-Sender: <xms:2efgak9fXOFK30ZUX4R-ZaWJyzFTAm4zVocNdmRodjBv9jO1wKBDvA>
    <xme:2efgaoJA-xpyiXHwn8cMZ3N3PJb8Q2di-Bzxqy4yBXWLmKTU_yRHEHorwcqqiAb9A
    NcO_gRrAK7fA-gDm75pjD4_JjoKvy5qm1MUUH_g_URAKDZKHslaIFg>
X-ME-Received: <xmr:2efgatnYXz0vkwJ2PWV3IcO8Er6tV_5_Ni2XqzKzZuPoNb1woTL2-Suy1H4>
X-ME-Proxy-Cause: dmFkZTGtPC7P/KHU/vnQqgMeemFk41qsGgGidzkoZo+5/nF4Xg6iJDsaYYITZm1aYlhYa9
    Tfs1f3ktcNJ9TWE4LgdhaWeSl6NSXrK8CotGuDYdKl7WlSXVbRCnivBPKf37yJdU9TCYIy
    MYZCoDrqXrVntFob1F1UgBKN7xK11iHBQAw7T91xu+74cnrKm65skleYeuRPnZNx2lBDeh
    S4QnBxXBlfVkY8MO8O6uPfxLxy5TTqZ6zs/Wcf7Jz5XQVzYiAWtC4AxBMpS4IQqBYFLAV3
    YQMr7uQPp8Uv7e3vwJ3BRy9FcMNXA3kw69M+v+SZ+vfbIQCAbpGKr+pUVjJkJmlXmNjvhY
    yvqrNwxMvElC5lx3mBDyrsdpwUUksc7esOqqKGEuGpI1ZLkvtn5PN8jseyf3MRpWCapr6s
    jjvYwMgxQaNu7/Kwhhz5tbmr3S7flyL6R25VTpVNQwBW3iUl170yZReXnYDNkwTYZyIm7+
    4C4DGirk7+pL0wYA1WTUDeebLcnZv9Up/E2jlKKKCJz5AwE3ySPaBeugx3Coup8gtq4kjg
    2YyyYdE5M+VyRvSsqknqq+s1nuU2tpwGwSn6kaYqHLQE9JvKhGScJDm0je4miLMShZpw64
    AsGU6Y51/mFqoANoaP426NLE83HQqnI3VrLLZYMVPraSIyofGSyFWXZ9X0pg
X-ME-Proxy: <xmx:2efgatdptSd7ysv9bFChhZZ8_Oog7j1xULKYdZUs3ZgmQoxP2nt70A>
    <xmx:2efgamWj_C3a7nuowT_lEoxcLq10BQfxsMecgmoq1YUsSm1oxbpFdA>
    <xmx:2efgas72J1lKJOvDJdkKf-jhWniUB1cmJqyf_GANXekH37iZf-Zupw>
    <xmx:2efgah4aPEpEVbZHCFt5VWsYl3F_b40KCSDgf5COhWuYW4zXZI2GdQ>
    <xmx:2efgasFHZobIqtlg8aJCRETmV_6JzM54Od5Rs3u2vc5qbY7L_ggwu2N1>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 27 Oct 2026 14:05:12 -0400 (EDT)
Date: Tue, 27 Oct 2026 18:05:11 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	baohua@kernel.org, usama.arif@linux.dev, hannes@cmpxchg.org, alex@ghiti.fr, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 2/3] mm/huge_memory: don't queue folios when underused
 splitting is inactive
Message-ID: <auDm-LnEXgXENte0@thinkstation>
References: <20261023230006.3759543-1-joannelkoong@gmail.com>
 <20261023230006.3759543-3-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261023230006.3759543-3-joannelkoong@gmail.com>
X-Rspamd-Queue-Id: 8E0D81C0010
X-Stat-Signature: 5h3iscuyomuzrnjq896fhmrbjh61paj4
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793124321-472250
X-HE-Meta: U2FsdGVkX19IoQ96nqaIAuJlivh61zKQKfzYQJIv3+KWnaJ7YS1CW6RtF6EXI1+3ksujiC9abLZQu8CCClF+hN5tqEVW7BGNHAuodzLy6ulJeaWJBRjhUjsbIy4PqaeWLz0ZFwJ2T/GFvwUB2qlt2oWywmkJjJVo/Iu9efoxcd7NsAdLC6L6pYGiDNv91JsspVckQxHXp0478QHdE9ox2hNoZCEkjCPfFpc2//MvGMZqH8ZSfCzXY+AsE3Q/cWPJ8Jzx18XFtod+mZos9mCNPwC3AxY2gutaeZM60MM6ivBP6+YGDV2fuyktKdctQ1HFpamYHUDYxM5asYLOZy6us6h4ftuvsVahaD0sOb3595K0mdlaPbPKaHJSGA87lq492yJ+w5adFWs45Kgn1+zmKVjmzKDg2tSWmcRM13G2KoBAf/mUB1Lf3xExnzhyGd+YIVRS6lJ872Ch85LplQbbxtX+GeK92QM/+oyfMZPS97nFik2J5H/k4Y59qQHcnIHOWGEX0Jzs8ndUSRgEJ3k1VjM8OnA8hx+KpYdB5mcXMGxrNh2DmpGXJxYo+ijoJPsg3PT9BZER1XSuJejnn6fFqaOr5R6SkWHq5iKlTqn5UniY4i2sQVg4v40RKF7GCT6mFMJcAIz/X/I28WvzUgGciWlUhfaBAoew3+/qfqnjnWk+gxdH6VuUmcD1v9+hijhHmr3j7hE6EH/Zaudaofq6bMpLTMkCvq60Js+97HyJWOuDDvJw6QOX5g8hiqhgSWCGlLOqJTHrQo/tB7ltjGPrjHUEyJTKRg25prme6OvXgOlFj236OLdLmQheKvDaYJDbQ5jXmUcf39c35gprZpeiwOl9m6XifKRkFEylttaiKfDnHGGD/DwAuoanUxvGRqTPWHstGbsMWIcscR7EVXFG+gyiqrzmboydjEyPA2Be/N4RkJpR3Nnj2RCNxDoNNluI0Q0V+alKWC459LCNkA1
 PBD0IVwF
 ZtxDoPPEbdboqF21ZO5svpZMOKeM9glUowm3FexGw9itz2N9zFiUA6xLhHK1Y9S2Qw8OFSf6d/KGwvyn21S89lTT3S9bR6Fx5DUqOw4XRXi0pQBjhvQKdbVlpwf5HtYkDmcQUNm3Kch96WWweA09SGeKUHLQ5GvANn7ZoiB9L/yI5HMQ7GYSFSkXIMVCorOBcLH5YEW+tlekklfMSuH9G/GW/hr+DlOrFY+Eb/cPg29suC0p4/vx5k+psfJqBKLR6ouaQimk1leGeHR0CfPvNuqoKszo7yUxENXkBZv3W/dD95VAbwo1czKSOoKhoTlkhqq2a4pWAaqqGmbVBgCqkkPFZaj9wM5eSbI4+lVwMzfxNSaJ1RRQ0ecxpDiQzLL6KHj11nAWuaOUEJjECjW60haoNvqzv8y9BjFPxSLXuVKWYe6OwhGK2zIRWSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 04:00:05PM -0700, Joanne Koong wrote:
> Every anonymous PMD-sized folio is put on the deferred split queue when
> it is first mapped, so that the shrinker can find it under memory
> pressure and split it if it turns out to be mostly zero-filled.
> 
> With the default khugepaged/max_ptes_none this is wasted work. The
> default is HPAGE_PMD_NR - 1, which tells thp_underused() that any number
> of zero-filled pages is tolerable, which means the shrinker will never
> split any of these folios for being underused. They take the list_lru
> lock at fault time, inflate the object count the shrinker reports, and
> are then walked and dropped when they're first scanned.
> 
> Skip the queueing when khugepaged/max_ptes_none is at its maximum, and
> factor that check out into thp_underused_never() so that
> deferred_split_folio() and thp_underused() share it. Since the default
> is the maximum, out of the box no folio is queued for underused
> splitting at all, PMD-sized ones included. Partially mapped folios are
> still queued as before.
> 
> This also matters for a subsequent patch that adds anonymous mTHP folios
> to the deferred split list, as it keeps systems running the default from
> paying for that on every anonymous fault.
> 
> Please note that the queue has always been best-effort. A folio that was
> queued before khugepaged/max_ptes_none is lowered gets dropped from the
> queue by the first scan that finds it's not underused, so changing the
> sysctl has never retroactively applied to folios that were already
> scanned. Requeueing eligible folios when the sysctl changes will be
> addressed in a separate patch.
> 
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

