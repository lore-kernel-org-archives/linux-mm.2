Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D2B6606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 01:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oyWy87D2
Received: by kanga.kvack.org (Postfix)
	id 85AEA6B05B4; Wed, 28 Oct 2026 21:06:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80B826B05B5; Wed, 28 Oct 2026 21:06:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FAC66B05B6; Wed, 28 Oct 2026 21:06:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4F8156B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:06:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DD3F0C01FA
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:06:20 +0000 (UTC)
X-FDA: 85373872920.15.3B4DDF9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3844E20003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:06:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oyWy87D2;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793235979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XhzgWvw9dix6dVykJ5a4PvaQa7adQLn21rzVdWA29fs=;
	b=Wjgf7H93yrv9vf+Kuf+R7B80NlKDuiYiJ5rWNYVISNc3W19eIRhqtl+xf4+7IaEcRtcbXq
	o0yvGc806gTZt/7vwbqdtlUv1Ia+PHOc+MohFu8Oof7C8lI/oOaz58drLpJg7ksa7I2N+Y
	p6Vf8iobMVf1m7GUMfZB3xTn40n6ZnQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oyWy87D2;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793235979;
	b=knIfMT+UXab8YJJm4Rx/oGB7MC7wfvM1mTTSpintI68mu7/hGogAqKvw8OEBN4uanBgBoq
	xAUDBH5gO0OqkR4Uz1AlGXxxfZvnw2VMQAVf1aJYyKrpzKY3kZy+Zvz7F/pYd9+g/PevwF
	sU1Y3zZS6RMGX/Q7wXpQy+G300DRqXM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 63CEA41954;
	Thu, 29 Oct 2026 01:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069FF1F01825;
	Thu, 29 Oct 2026 01:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793235978;
	bh=XhzgWvw9dix6dVykJ5a4PvaQa7adQLn21rzVdWA29fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oyWy87D2HsyvaSuz6Y7G6vhv6Mfp81D3sIv50QRIaDaq19WokIWz8vhdH+0htZQp0
	 DQO4apVKJ7BW8j1BmtfvA45GttkH13CJeuE1yF6LVnbNZgH08Pjt2Gcm7BxyDYDLpA
	 aJAmesjjc7A9bECK4kXjIRnavfGJ2YW5NMY6z166RU+cxn/fNM/kQ3qXTjaU0KAbRH
	 paqPiSdjGCpBzj4OfohAU9A7k74IZcdZY3VG22Pu5Jyzq0lkNxP/5d7cdGrGrHFIzP
	 F+xIO8pz4wrHUjFR+jnbWJN27CNEmegtOb73cAI8f4+0DVdic/y3tBlKpd812MEMwx
	 3hIxSHQOQxyRw==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Aveline Noir <jm5905938@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Bijan Tabatabai <bijan311@gmail.com>,
	Bijan Tabatabai <bijantabatab@micron.com>
Subject: Re: [PATCH] mm/damon: skip folios already on the migration target node
Date: Wed, 28 Oct 2026 18:06:10 -0700
Message-ID: <20261029010611.170686-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261029010144.169906-1-sj@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3844E20003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ky5kq6gdy6cpdyxzr8woj8u4dijx7nbg
X-HE-Tag: 1793235979-274093
X-HE-Meta: U2FsdGVkX18rlxWU9A9aKs88FuJoWE6V5HT7OEIupuvccQs7SBo/t6Xvk06P+6bILCpI/lVMyZL1YelrwBkEcD08s0xU3Wkdr565xFz/xt+9LO9y0DPaXj4HP3COEiEKUpmOFrxDoiTTmlBvm6e1zDyfDSbT2hgEMXaoZPKb/12VR0QxWyNh5o83eXuQvTQgmM6DUP+dbOJJzfyRDtUPeaigl+lAWdF51yWjC3jVLK1mLwl/nnnyAixbfoZutd2asRIGLIZ4eUR1DH10LhG2C1x+mZ0Aia0iYCkwqrzFB4xz5JHVS3Maugsc+0TjBVd9QUppQ7mBS3cTqLWe37Qe5GIjI2AxbIv/knfUiz/hkwufFVrrgxWsTPNaaJQhMLZa/tZsd8jCPKr1/pIYpUXpT+PbX20vU8m+8atUD7wV0DJ3u89HVl0n1QGaBYJfTe/12la0FwQaGbI0NXIbFytKu0vjKwt0rlrRraxetY4NyAzW6dxfhfM0GAwHuwcoLFUW0jcwjrCZ8ya4lw+GkRFCG971ZEKEDvxJ2nteWgjC46do87X4lqWKI3Y8jQfv3vFy6haOWvFj0fTPxp6gNRnk639e1RvCrfUDumG3CS3+AVGgVh0iMc1vvtLtkHAgNYJtcQQw5nyuDJ3KLe/tFJb/XgYrk8NrmIHrjnLprVkTEZKU4hkkl60WTzVkz1GF9wU+SReAqOreAczDEgTKyEa0R/B7hLCsBB8F7Z/CV/77ALcII8TF1ks93//eEQ54kEFJ+/nsUq0PmbI+agtCehbsZ27A72IIR0Z3Bbb8Xr91wxfh9x+x9gG8aLYfwhvm0UR2F+Q+ckn2dho+XU8/i7iunwBjZWeNSFITwruVT6cCFHU0Jvh8yGYcyUwMjDMyUsp+zfR7Hzi8Z8wkPmFohIUzHNMUPe00WzAg9ItMsDX17R8OpbDsJH+//cj3XpVTbgsZYX1BQ5ODDSzEj0mUtVY
 4Kk9SGPw
 4UGunfD1wNI2y3ODmrNmSoTInTnbffwRAS9vvFqxj7FZ4ojOZTAqVuiM8zI3nWalA0fT6/9SUd8a6sw7g4pUr8xNbtg5ilDymUfD6FABanAF5Lsa9OPOpTX7CkMIiEgw/A1ASJSuD4mCRp/Hx3mmSPYBNb+MWvPkc/ckDCMypPrEL+SLpplHzmu8liwozOiPBU7VHcSG1G3OxROeDWLnk0XoryXmU09IHhKHuMAj8BjzYPG3pxipUooakLxrtx9opigTlseSzvooDCqGGIWD13xyW5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

One more trivial nit.  Let's use 'mm/damon/{p,v}addr:' as the subject prefix.

On Wed, 28 Oct 2026 18:01:43 -0700 SJ Park <sj@kernel.org> wrote:

> On Thu, 29 Oct 2026 00:05:46 +1100 Aveline Noir <jm5905938@gmail.com> wrote:
> 
> > While measuring DAMOS migration overhead, I found that the target_nid
> > path isolates folios already on the target node, then puts them back on
> > the LRU without migrating them.
> > 
> > Skip them before isolation in vaddr and paddr, as the vaddr explicit
> > destinations path already does.
> 
> Nice catch!
> 
> > 
> > Signed-off-by: Aveline Noir <jm5905938@gmail.com>
> 
> Other than below trivial nit,
> 
> Reviewed-by: SJ Park <sj@kernel.org>
> 
> > 
> > ---
> > DAMON KUnit and selftests all passed. In a synthetic same-node fvaddr
> > test on a two-node x86-64 KVM guest (8 interleaved runs per kernel),
> > guest-kernel cycles fell by about 29%
> > with 4 KiB regions and 90% with 16 MiB regions. Median kdamond CPU
> > time fell by about 76% with 16 MiB regions, with no clear change
> > with 4 KiB regions.
> 
> Thank you for sharing the test result.  We don't want to add too much test
> results in the commit message.  But the performance part above is informative
> and concise, so I think it deserves to be in the commit message.
> 
> > ---
> >  mm/damon/paddr.c |  2 ++
> >  mm/damon/vaddr.c | 22 ++++++++++++----------
> >  2 files changed, 14 insertions(+), 10 deletions(-)
> [...]
> > @@ -858,8 +860,8 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
> >  			goto huge_out;
> >  		if (damos_va_filter_out(s, folio, walk->vma, addr, NULL, pmd))
> >  			goto huge_out;
> > -		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
> > -				migration_lists);
> > +		damos_va_migrate_dests_add(folio, walk->vma, addr, s,
> > +					   migration_lists);
> 
> Let's not align parameters on parentheses but just give two tabs indentation.
> 
> >  huge_out:
> >  		spin_unlock(ptl);
> >  		return 0;
> > @@ -883,8 +885,8 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
> >  			continue;
> >  		if (damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL))
> >  			continue;
> > -		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
> > -				migration_lists);
> > +		damos_va_migrate_dests_add(folio, walk->vma, addr, s,
> > +					   migration_lists);
> 
> Ditto.
> 
> Assuming you accept my humble suggestions above, I applied  this patch to
> damon/next [1] tree, together with my above suggestions.  I will repost it for
> mm.git inclusion within a week.  So, no action from your side is needed for
> now.  Let me know if you think changes to the plan or discussions are needed.

I also added the suggested subject prefix in damon/next tree.  Please feel free
to let me know if you have an opinion.

> 
> [1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

