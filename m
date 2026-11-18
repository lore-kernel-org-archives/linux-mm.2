Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21AF5606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PyWxjUBT
Received: by kanga.kvack.org (Postfix)
	id 368126B00EF; Tue, 17 Nov 2026 21:19:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33F8E6B05B2; Tue, 17 Nov 2026 21:19:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27CBB6B05B4; Tue, 17 Nov 2026 21:19:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 051AC6B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:19:02 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 973F716062D
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:19:02 +0000 (UTC)
X-FDA: 85446632124.27.8BF1E86
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 098831C0005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:19:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PyWxjUBT;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968341;
	b=fbZbgXzlgFftAxIMQFWruJa38muG6jyHX3juAtcFEpTth1+Fp2JF19tt8kT2Hb7t/1aGr4
	cBBwv0SyH0RxmRioV01njgVMrZkxGdm+Ifo8IWS30VYOGEgYTcQDMThxpPrnRslDieDxUp
	xD4aatPljoqGbFvCNzgsMi2JyxW3hU4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PyWxjUBT;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0QuAID6gYCgQHLnYu2K0S2/YQFv95gs4xYpBZYbbrMY=;
	b=uNpf5pcOwApAW4PFQxZkad6t/MeH+QVcUcTKbcDCTdpK5NoyCPZOjtAr1W2RAdZSfoBVJz
	5k/fSZFDYkc37w/yncwJOoIEzybgq3hbD6cOVAomkGLTDH37KJvXs5haN8ceFEmga2+Olr
	QnSfgxaLlrxdKHFkHEb6mL7cJxn0zKE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3EEB843E76;
	Wed, 18 Nov 2026 02:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4C31F000C4;
	Wed, 18 Nov 2026 02:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794968340;
	bh=0QuAID6gYCgQHLnYu2K0S2/YQFv95gs4xYpBZYbbrMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PyWxjUBTcge2zprNhDW5qHno/QbUTPi0FHn1B6mxQ0AZp5yajfTuET3DOHi2jWL04
	 c3/cmNMroDwrMWdgmZ5UD8F4ALizOCi1ih2Vi6YsMe37YfwNbZJM1AqwryEsqpa2dG
	 mk+UPwwHbyJ3V99nnrIr6m4nDASTQD4iWkwtL3w20ndnpXBfi9tmMfqz8kGfxgdwX4
	 OJkfHhOEu/PekVgSwJr/j3YP4fwjGvK78CYFTKwniMsNKZYaabR9jjbTtBgadvpVjq
	 mRLmVc+1+u+JstZMu2X2f6/eXiDubM2bIdo5faiE1dzGUJn3GoeYHGkekYSjQrZAh4
	 XGwN/a9/ZMMfw==
From: SJ Park <sj@kernel.org>
To: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/tests/core-kunit: add test for damon_call() on obsolete ctx
Date: Tue, 17 Nov 2026 18:18:52 -0800
Message-ID: <20261118021852.99595-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117172219.26725-1-saileshnandanavanam@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 098831C0005
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: fkg1h4ox6mkm9msrffc49e4rr43dr549
X-Rspam-User: 
X-HE-Tag: 1794968340-995520
X-HE-Meta: U2FsdGVkX1/sAbr3oPmBo2efsTtYCJt7fahypf+bVyxOEsw1meARj7hnrly16rzvv6FjMQqeg/9Kuqh+6pBLjukZjTe0/I6xlQramF4v+nSQY7X20gN1vAPTr2PzJtgpsI9Geao3lO8CDkM6vHolFwrgxXGP0REuxSd/pg2CxL/8K3nAgf7Y49je/wshOYerzhCL4RjiFSMG2qMlb1fG1yz3k7i9uh3onGxqXXuH/ixrMmgDf3ZPoc96/68rVDsOyqRdxfPvtR2CfnKh0NqU4lzOmQnf73nCz6tIWTDEsxz+wCD5AAgHlM69Oi+bdeDgWnzxiOn/0/5xmNZGnVLdE1uSwPAiwjNzzpLJ9wKEpw8jZsfXlaj9fd7wc/ATFTryvLkWOyR35AJW4hb7pID+egbtOEqK/2gmyvTktg1bsGTHuBQ1ECTe+3AsT09YLWs9xzb2sJ7/xB6MyWaYb8XGkg06pOLkmuWvVDutIv/V/IWUmGPKNEjlYHYItvS03aE9kTH289gWSUwSBeSOx71dUKDLDZ8M6EG0UkWmWdfRpviRsbCgqG0o3Oap+ofbNtYzEpJOc4AdznNVAf5laMlh6+J1CTJyEHKZP3Xp4SNnWoze5UBUItdna22jLbtiQZ2Lx/lNUjiCPcqYYjQhepv0m8pIiWYTYqg+DtNB7VxIslQ3vYS8SvSh/ij7/uzzcHOAh/Fk4Dz0n1ObInARgvr2ocAlAtXjhiymL2zxwJireXFkBfVmhGlaEoaQtgLOgFPkkQtdLvsZaTdFcL13ypniBNON89I2JBoUOgiiQfDwg2wtS6FTOiw9yPPdk/3hFmsVgd7qj701QTZ1QurpVSXZ7/rD8r7J3xnnXbQpQca25hfwr5+iCbL9rPKu98J6knLIPMUi7AwOrOVRmqA0Bbi+D4WX2wJUXvpqtJkYau5xlZ1KHdiGgppVwX79sbH0t1n5v/b1H6Uw77t/EPy468m
 y5qLCbWP
 eC39IAUcSlKC617mKwUQ1VLbIwVZ1jW4YcBcXXFEycxCgR9k9mzWv9twBT75xB+IPMDVYEdztoFWfm023gOn66y2t/3hFYAbn3X1t3fXdUQBeoRJHMy64Gu+pyd2LhgtJokhctlU7Pua0U3poIUJR+Fqa6C06x4GhESkzBdEcIBzgx3KrR4FGpAw/J6pGMseC9AWI2FYkIKPVIS2e0hUKcMOCKumFCh67EeqwDO7evt9bGjCJCXDHFjoywXHDHEpeTiOtEsjCUApN/LKzIM6qfE+ixYiQDxapvkytbChsOn1ShaE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 17 Nov 2026 22:52:19 +0530 Sailesh Nandanavanam <saileshnandanavanam@gmail.com> wrote:

> A newly allocated damon_ctx has call_controls_obsolete set, meaning no
> kdamond is available to handle call requests.  damon_call() should
> return -ECANCELED in that case instead of queueing the request and
> waiting forever.  Add a kunit test for that.

Please check my suggestions on the reply [1] to your another patch.

[1] https://lore.kernel.org/20261118014632.95656-1-sj@kernel.org


Thanks,
SJ

[...]

