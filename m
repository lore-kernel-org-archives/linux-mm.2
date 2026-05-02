Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F869CD3427
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 01:56:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 814226B0005; Fri,  1 May 2026 21:56:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C4A56B008A; Fri,  1 May 2026 21:56:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DB1D6B008C; Fri,  1 May 2026 21:56:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D46E6B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:56:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1F5E2160455
	for <linux-mm@kvack.org>; Sat,  2 May 2026 01:56:18 +0000 (UTC)
X-FDA: 84720814836.17.1B8CA59
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 91C8D80005
	for <linux-mm@kvack.org>; Sat,  2 May 2026 01:56:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r9n8A8qg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777686976; a=rsa-sha256;
	cv=none;
	b=qMC2KZieVWyDiTDpHHTgsV48dDwdzdkPixueP7ECw1IvTNHBtkNvdSC/MGApENOaBDe5fr
	zYxC0WMT8zVHbixH5RlnIdWXC0sOqVjnw3Juiih7XilNstkgu0xbStQPnPf7ziPxO98pKM
	gFqfViOYwHguRHjna9XqAWZHuo47HBA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r9n8A8qg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777686976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QbWd4ZYyMiwBG75JZ37NfXJYITH2udCJjImma1JUYOs=;
	b=UGIdShiNnKfwe5oRbQzOCB3NmTr1exrFpDjNnXIgBqfCDeHZuIHXYSjJ4QQnhsdqRjI5kH
	5VBp0pXZ3fA07CQewHq1mb5vg3XC5W+RD4/7Wm2aiLtlYLxTDEq3bcgNe2tRxxqGekksMo
	h+MSMql+cxkztjgI+ZSZDelI9blEVHg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E2449600AE;
	Sat,  2 May 2026 01:56:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF6FC2BCB4;
	Sat,  2 May 2026 01:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777686975;
	bh=jdf1fy/AOE9duotFUlzo2FacHlWMe7E9VEFUMMiyWis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r9n8A8qgFspnzGkNmcw8lKNXv9qFv5CkWJe2p5OEfWitUudHlXaTgBS/Xwe+7OChP
	 1MHbCxT2B+Dak8KTL3Nn+FcZn5FFtrMeEoD1DzS4xo10MEwq/Z2aND4jSzQucs8F/r
	 wNVpn03FrlSss+qcterKGSXHxlkukI3iANmFn/KgwDMojxTh2NyNTwII0/rlis6R5u
	 NznN6tBIi7qsiQpK4Go/nLFdvhzxsOMuStKfcIlSr5ctmoBfvJ+G+2w+6IhxLQXPeC
	 ng+jxYwyxbAH2nKZIGZXTH7u/Vn893hcKvoBaRKWF0FQwRqqqRlBGYudG7P0AigTAP
	 2AF+qQaDDLhYg==
From: SeongJae Park <sj@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 00/11] mm/damon: introduce DAMOS failed region quota charge ratio
Date: Fri,  1 May 2026 18:56:06 -0700
Message-ID: <20260502015607.79341-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <761b47b6-c2f1-4fef-bfab-48ee1d0bbe47@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wa14za8b58uop1ra7hsgtdzzab8nw4z3
X-Rspam-User: 
X-Rspamd-Queue-Id: 91C8D80005
X-Rspamd-Server: rspam07
X-HE-Tag: 1777686976-656450
X-HE-Meta: U2FsdGVkX1+KxfWRjHfCKFT0I8n0dNX0Azr/q6id+ctpO7sxprJ9BeaGV8MVdndL+vPv1QExOFB1XY9pJGzG6AceICbtK8iZpbcI1qr03sEoG2Sz9kOgCgcxKIRa3EQMyCXCkv2B4XCfucIsEeSiqPZN88AhWff+KJbpt71nG+RcO8rgHaYO2rf3AFqzLvEs7JevUcz4udbeXs042W9MBNop3Xs/FPz3VkTK+P4KQtQETEzonXu6wRARdY5qCRYBForyBRlvoekOrUP55eIB4F3aET21o1EHwvuzQGJdPPAA52uuRHtKkivx+NnttRVs9Ruvij6Y81uKTixqIrWUCO1Nvhwjd92myP6fppM1d9hBZorSAuB7VYIorHxKpxnd/rLVPcLUUUJ+cHudmbi77o9A4YmY7Gt+gluwArpox43AmI+NwW9F1nUvF1dFGVoA3Ctow00p2DbjNDzmJwi1I7qtukCW1BLxYg1U8B7IFJEwxaNeUVWGuWOthxRbuTERdr6L5yqOJdG0RaRCfYVheJ29DG2bpJJJ2Df4c37XWd6g8S9QFUy8Q+IllgpcOCDO4M03+MnG1/yYdTb5lxYta/xQSxUik99bmf5lNXoJaeIpQhk+VAB2TOUdwd2Ms4N6UuxMhuOXu8YIR2tb8PtttyOESfDCVJ73EouyL2jA3/B9VZfOO7287I5xjTTx3tVxBPRhS6WgM+PYK0FPsdBAicY9k1IxeshgouMEFrYVPgK8jzGw+SkpoZHYUvy0bVqZR3K+A4zbYC05uDeDqNqdO5jc6moE7SybYiBoK5IHdnWlZ9bg4hRdR96VzmKIKc79U5pERVT8jF0n3i0YQpzz4I29s0HKjRYHFxBBnTeTJJtg4befdRM51CfIMgFP1LAxMJ1uraR4a7u6QxgTM2fezgCWc4IcvnbmlRjpredlVicShFQXQyGkGDwRC5RDGOoFKE6X4ZwoRau46Omw1NQ
 GeCnYZ8b
 Z8p0smPujFwGYch412h4w6SecCU6hJFEz0WcrXhllikSH/W28+DpUl5kts4s5DtabF1jxvNoFU/FLYLHiCEdHxbWzfd1ZCoAQKmoD5DF9BDUI3dMU3ytoFMN/zrddK4H+QJ18WwpPfrQSd3+n+/hpU8yPAmRmRCrHD9/XH8JghwvGmdDJtKLzyffcWt3/S2NOqLu2IeloqQAhlhQcjrXUA6oM7NoIPviJaxwXn/so9+Bp2QA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 1 May 2026 08:49:43 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
[...]
> For Damon Andrew should for now just trust your ACKs. If it has your ACK, it's
> good to go.
> 
> In the future, I expect you would pick up the patches yourself, which is where
> you as the component maintainer would look for any blockers.

FWIW I'm picking DAMON patches to damon/next tree on my own, for my testing and
for a case that Andrew might miss those.

> 
> So for Damon patches I don't think we need the AI review notices from Andrew.

All make sense to me :)


Thanks,
SJ

[...]

