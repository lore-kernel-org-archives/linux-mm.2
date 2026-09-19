Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5148C982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 20:15:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89D546B0088; Sat, 19 Sep 2026 16:15:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84EE46B008A; Sat, 19 Sep 2026 16:15:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 764656B008C; Sat, 19 Sep 2026 16:15:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 521836B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 16:15:24 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D5F75120334
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 20:15:23 +0000 (UTC)
X-FDA: 85231616526.29.36D80C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4618840007
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 20:15:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FkK11MMA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789848922;
	b=EtA83td5nC90/aj9+CxpmNZsgU/Z9QD24TEubA8QAVSiIxJ/kdSRuicZqpbfI1ktKhZpHJ
	QdlF5/mibLnkpr58A5fR3gdg95fZMpaOF0cxUiB5bVdRKyJOzuT04xRsFw6BXCWdhLASHN
	L471M3DrmU+38ANjp2FDHTurpJP1zMY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FkK11MMA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789848922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UMCYRHH+u6kCE+TC7+k7HyCfREF5gJW/SeJl0LZ1kaE=;
	b=YLlHic0zODo4xh5AhhFcUBEGF8lUOsYyQ6uzxzALQt6PaHrcZ57e6Fc/V+SQavUbshVYpL
	RJEjdb4XBnmUEehFlpewMZ28ouV+j0M/gDTMbMF5Q0N0978j0SnnG5Crydb5ybi3kF/p5k
	LmCyDIDAOrNXRMQPGlDBH8ccGxKw6VI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A958601FB;
	Sat, 19 Sep 2026 20:15:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F362A1F000FF;
	Sat, 19 Sep 2026 20:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789848921;
	bh=UMCYRHH+u6kCE+TC7+k7HyCfREF5gJW/SeJl0LZ1kaE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=FkK11MMA5bHZ5DgXxz2dLsrnyGP50FK38Ngh9Cgu3paof8NAHnGA+UzpT/mF8DY74
	 Ax9RNit870IPIupHY2qJ77DtsqEntP0bIzOIIol98hL1wvMStJOy+XexY/xreRJB/2
	 oMuZEggNNeKSpJLvheeFCaABbhuddi5wErGY61LBKi/QavcTZ/+WsWend9rC/mXYzt
	 Oow06x/jqbr9GCRA7gjj9nBM9F3rmfNNjWWNkB6ToQNQyPGF8bo/J8F0+DH7NatDaZ
	 h9OvySbPYfbQW6PubLQkGg3Ryvxa7X43PYgg3/RLcPTE0d/c1mn3HKugyM4eyOOMMh
	 zFki9mqk7luwA==
From: David Hildenbrand <david@kernel.org>
To: linux-mm@kvack.org, Aristeu Rozanski <aris@ruivo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>
In-Reply-To: <20260828015542.125576330@ruivo.org>
References: <20260828015542.125576330@ruivo.org>
Subject: Re: [PATCH v3 0/2] mm: gup: cleanup gup_fast call chain
Message-Id: <178984892095.1919703.7079872905260203898.b4-ty@b4>
Date: Sat, 19 Sep 2026 20:15:20 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4618840007
X-Stat-Signature: ckwshkyjs69icuyjs6h4z479spd8e19u
X-HE-Tag: 1789848922-643064
X-HE-Meta: U2FsdGVkX1863HYkVExbgULZUN3PQCIijkQVQLG1Xo5xJJXGNUca7P13WtQu4k0ihsmuLRkA0UnsRV1UXx//7ZyKBcPBfemr18mUyfUpEIxVrkydZSCYzosjNz4Bdn/lC2ihvEvIMwGdDN7T48Rikcc7/fg5d2+F0zqUoHHvJ023qaWfgnGg+R+QLt25Q2jOc2X30DwWpYr0RvSfZxShBSBQbFRVpq0Cwyp3KQzG96j5jqGNF2mXWIiBmAfo41wXQJXI7XOPBsTF3zXUyBKvE0f19/CXlbY65F2yb65XqOcJ9vu/5+2/gMPFWx9x/K38/CfcdmqPo63fSk6/Yx8xbGTDQTIoRsjMLVU+6RvfBRYJ+ed11RgzUK8RHgaV7jK4+C87iwNkYc4ZBsPsxN16jx2Lq/BrTXUODb7lJY+gEhB3kzgt0bkajtdiRGRQc2zC4ivJ9OHQU5rmS0jpKtBcFfm1qwwblGoOs5Y4sFntjX0TMghRjK1HMSDCyPeni0Wp9SLlb5xFQRaqDcBXCVxsL92AS2POuzT9VPUvQUOWY1z3+iSKWcaPEo1LxA31beG9hHtkpVV7mBY0zkdWY8izhVI1FIDoj5j4mSwdDTpLEGzlmPn1ZuMEoACDqIfVeIHTzUjynWJFHEvblo6tQ8p0t2YKEZfJzSKDQSSP75oqMSFC+PjIZvE48sLqUDmMCr/vLCNxoJFv2pUnMIgi8PFGU6+KGOKy8qk4RCFqOGCL1O6MSr9qAhU8ka3IajjdemtePhmojobyXP8nb0WGzut63EiOinfM6LHrJ60GovtPUpR6F83b9xheSzNmhrDjNiN3aBf+uL9nia/JG8vcdYmU10QWp+obN/pWJGKjFfg+7x2cGvEvf5nNqRhDv7YoNWPrVhCDf2Y52ljChTUyV4tbzCfwUxVrAFS1jOfoCl45E3U3xqxumWtfxMWyRRnq19ddV1n3VCzYoeknevUMsTy
 l3XephoM
 cps35XxRSTLrXcvvK2SaG08r7ltRysUPz47q2ThVZFeZ/bZLYyoROkNDG9jr6o+ZNAhq62ov9QwGE3tnOx1Pkiakqv0BAHMkY4AVzgbok3lWNe+nhzJpgNItW6Xg9b/EnNgWDI7gb9eAKsWgGoPg9N03b8phpZ4hpO7kePWhxL5gE+altG0+gF9VD7MgSO2cNRRXRtRSg2U0SSRyBmBCqRGFNAmftHU/VdX5Js9U75CulBYLodzuyZbDw4B5uLuBTiYkbi/or1ngxAs31i+RpyIHyZIizUifri/+odVvj++7UkYsIUihRkeKBtg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 27 Aug 2026 21:55:42 -0400, Aristeu Rozanski wrote:
> These two patches implement the refactor in gup_fast call chain David
> Hildenbrand mentioned in
> 
> 	https://lore.kernel.org/all/85e760cf-b994-40db-8d13-221feee55c60@redhat.com/T/#u
> 
> v2: removed unneeded initializations on the second patch as pointed by David
> v3: fixed gup_fast_pmd_range() nr_pages initialization as pointed by David
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: gup-7.4.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/2] mm: gup: move pmd_protnone() into gup_fast_pmd_leaf()
      https://git.kernel.org/mm/core/c/9ad472cf
[2/2] mm: gup: cleanup the gup_fast_*() call chain
      https://git.kernel.org/mm/core/c/49f7113d

-- 
Cheers,

David


