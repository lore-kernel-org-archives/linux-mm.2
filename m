Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1B7A606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 20:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jawgVaPJ
Received: by kanga.kvack.org (Postfix)
	id C04C26B05B2; Fri, 27 Nov 2026 15:59:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB6816B05B3; Fri, 27 Nov 2026 15:59:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACC436B05B4; Fri, 27 Nov 2026 15:59:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E6B76B05B2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:59:29 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E022A1404AC
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:59:28 +0000 (UTC)
X-FDA: 85482114816.07.744523D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 42D1A140006
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:59:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jawgVaPJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795813167;
	b=bbFxVjKqYpgE7ixLoMZZoo+czrl5aFzORiLlOJVSD4Jc/faXLQRWGqRIKyHgQ5AqttIBrl
	ADaidkQJ+yIwGIFWBEVJKtm6KB0x8QNTjPjQ9N6wMIbKSFgKnnFTFq6FtYv2qsfSiz4O8r
	9LaVwwFZ5fkZ0Kz3mR+fl07E5JTAf3s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795813167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sGUE3FRU91WeCWpfrRYcG+pSF95rb2MiyCWB3OFDj8E=;
	b=fEwZ12/ypFTLYjGvDfEsgutcUlvFmAoUzR5hSSm233xhpBKy9NFVtwTyhDQ/kQC9K18AYz
	QYCV/JHjUrAHYWMOb6O89wKe7ViiJQdahgNEVRE31B6+/6Op5jDOG5pmpUPG9qMcaBg6s7
	dc662T+OTUWHAFMKdDOS9b/wHy6SB9M=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jawgVaPJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A0155601C4;
	Fri, 27 Nov 2026 20:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265401F00893;
	Fri, 27 Nov 2026 20:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795813166;
	bh=sGUE3FRU91WeCWpfrRYcG+pSF95rb2MiyCWB3OFDj8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jawgVaPJgTsEc/nKhz6RtARNumvb/bsH9EANc9nRTLCtZoO8AUKNmQHHMwt02PiB8
	 CiKAnVSj48yL8+8UcCY39ltzWTpNfW1ZGIEtdTLVoFlSFsg6DA6E4usrSqt2Kdqir1
	 5StqkmqF/vdsBCi/OAVP5R/lhEnbnpgj0RP2HFfc4SKC5Yf/fEZhmczpiEXcTFrCW0
	 iRIoEeWzPi0hbdNmW2l1GunOneaX1sZHasEIHT41tUs1zuDl3/A28Z1NNvPZJLxV85
	 dVK2fn1XRpaezexXtZvw16uOetzNXm3WBuF/SzPf9eYLttoYBrR+Eoi0/P16Xu7qbv
	 aV5+UXr9SiJag==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH mm-hotfixes-unstable] mm/damon/core: do not update stat for core filter rejecting region
Date: Fri, 27 Nov 2026 12:59:17 -0800
Message-ID: <20261127205919.95770-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-238270@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Stat-Signature: uar9c7ikww1eq9imax8e3n9wq9qstdkz
X-Rspamd-Queue-Id: 42D1A140006
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795813167-578842
X-HE-Meta: U2FsdGVkX1+5YS3DC6X5bJOpiDYtuQzQ8OwPIm6KzotgZmeDjaMvHYP2/dniwKpP0xG9bViguEkWEPPGW98qwfm03G8J253z7CGSGR7d7b6oqA9NchQDiZ85vTEdCQ27sTnTNmlmbgAV74bom68N3P6Ja9hVPyrvnnDhbeMQNoipF6tOWz9G5RuIxG2uTYxh3EVlWtXdZ1lWchg14upBlI3zHEi+FgXanHMEWinz+/jfKGmRULDiDER1JyTFrQg4y5gC246N6SPzERDoyk2nAwR4ezmNu4RQBVdiNOByUOAW6/UVdJUYl9aO7PHyxz7gcRne/Bn+JUCC+guCyEAp0OKAimHHPKEOQ2mHCtJM3/1ECqzTWWYvXucXJFQNojuT/PdNUAHbf1nn1h04eG98nMVyZqkq7FiIrhx3g+X4OeRiSQuB4mmoaRBVZUBECIl3Q9ILVXVZfD/2xweOIBE7001lb8ZTbvRXTo5RTtF2plQ6lqJuF1BNRnrsxmETqSU5KLA4ynnokgxGV4onQzmDHqxoH3we8N/FfZYIXf40rQAaIdYd+ZddBa73Q1d174WrrwM5po83OGfbM8LJo4lFmMHWcvpTaQisVCyt031BZbXa3RLT1dq1++T8Zg/FsDGBD5hsXLfT+zmyKFR3/tsiPpSmEsepwI/TsS1fTgIusdRZvPKmlD7BV+trGSynOEviYc8Kb3HXF1g2ColQnf4+d04h8iQGD2D2+PimM34BlvavpV/caJ9881o5b2h7p4YKLtrJnbqncJqgQfYiBRy327U2vbJvExPrafVjLElj2t+C3Zi5WrJbaKMYiLXWCwizpmQ+NFHgyenozXQRRAwluL1rsubGvcdSpoAOsIgisBh9BJBC9vLCJOVku6KN6xDWiF4J53Mmp0bjSyCQkKWhFM8iVlbGH8RMR/zFJjgEyBI29xMtpb8vy7wHtXZYgicWqiF+S4cUHbXjHwfK72f
 cB0PoteR
 wdr2zo1ey1WsVm3nM1qV8K5a9puCqaq1qIF8GJ9XD7s4C7SU9OSTcKqWAC5ycNl4WettMNgwU73GSh3eVMgO/pM2yQdqHhCiNtgcSDSQTv/t9nZTqFYbgOVfG0AxehYL3TGR4kdosxf96tQYYh+UFJrxhNu51n2zWIcxnrsQTVM4j2o0e4ZA3GYiNJhjaGyZ/LDl3DOv6CqTQ3QpZcJzbRQWbcRJ5rbaezSR7OgKRzYPgfo89aieOEiBmhZHLzDUCKKnma+luSCrDnSQAMdn9DBa3YoCAgUoyb8TA7EVzdmBQV6O/qf+BD/ErIn4LSIRo6Uvlvfex1eH69oqEnfrcicVwP4XCiOqKsGVqwUI2Okz0RhkpK27I8mqE9vFCA0wjGxieAItNsUmG+pFHgAbc529xTzWKHcUXU7zGwWt3sH1BGaB4f3b3ydsUYJy3w3Nqh76zPBHyPV0JH+Xgf0YlqjGYtKHVxaz/00kAcop2I71qm5h0DHlj0YFL1ljUFSjCeT6wcqtEKk1LxL0KjqfrGr1RsFyRkgTQi6r09LCDCb0lhEI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 27 Nov 2026 20:48:16 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [High] mm/damon/core: stale region size in damos_apply_scheme()
>   corrupts regions
> --
> 
> commit 2aba0f31066065a1efc163e77a7548d189458afa
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/core: do not update stat for core filter rejecting region
> 
> This commit moves the damos_core_filter_out() check in
> damos_apply_scheme() ahead of the quota enforcement check so that
> regions rejected by core filters are not accounted in DAMOS statistics
> when the quota is full.
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 0e6b361f97ea6..e0ea93de100d8 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -2785,6 +2785,8 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
> >  	}
> >  
> >  	if (c->ops.apply_scheme) {
> > +		if (damos_core_filter_out(c, t, r, s))
> > +			return;
> >  		if (damos_quota_is_set(quota) &&
> >  				quota->charged_sz + sz > quota->esz) {
> >  			sz = ALIGN_DOWN(quota->esz - quota->charged_sz,
> > @@ -2794,8 +2796,6 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
> >  			if (damon_split_region_at(t, r, sz))
> >  				goto update_stat;
> >  		}
> > -		if (damos_core_filter_out(c, t, r, s))
> > -			return;
> >  		sz = damon_sz_region(r);
> 
> [Severity: High]
> Should sz be refreshed with damon_sz_region(r) right after
> damos_core_filter_out() rather than after the quota check?
> 
> damos_core_filter_out() -> damos_filter_match() can split r in place and
> shrink r->ar.end for a DAMOS_FILTER_TYPE_ADDR filter.  Because sz still
> holds the pre-filter region size during the quota check, when the
> remaining aligned quota falls between the post-filter and pre-filter
> sizes, damon_split_region_at(t, r, sz) is called with sz >=
> damon_sz_region(r).  That expands r->ar.end back across the filter
> boundary and inserts a zero-length or inverted region (start >= end)
> into t->regions_list.

Nice catch, I will fix in the next spin.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261127203938.94339-1-sj@kernel.org?part=1
> 


Thanks,
SJ

