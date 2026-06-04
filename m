Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC881CD6E57
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 10:10:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEBA66B0005; Thu,  4 Jun 2026 06:10:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C750E6B0088; Thu,  4 Jun 2026 06:10:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3CC56B008A; Thu,  4 Jun 2026 06:10:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FC516B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 06:10:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6147414069A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:10:50 +0000 (UTC)
X-FDA: 84841811460.15.3FA24D2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id D165918000A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:10:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CGZwQshl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780567848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gkkN3rSsy1x2rUTT5oj5wUdRNrzE7spA48FJt094/So=;
	b=AMKDxCCkOIJjwJqbu5z+xbC/jLlZCQlCA6jh1PWtDGb1BgR6mYn8yt7w4Yl3vZceAF88Xy
	UeIL1NNv0PixErYwI3Zqn4ElWD03nLny0HXvxCJNLjprcHpPZsV4fCqMYTGFSKmyCGhMXV
	OhGeCbgkfo01H/jt/dCtyoSchjvQR1E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CGZwQshl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780567848;
	b=v4AJniMx0BFRsY4DMIIoSjPtm530ctwKa2uyXtl+i3QO6np27C53bovUIoK37BPtxz9ij2
	EjVwnz0l1H9MMc+qXrp6WpIwHmhbJZlQLOKgP0ZlUE3t6vEhHxneyEY+VSDGhWvOIDwoGS
	ds63fxMw667p4rTk0vyt4lrJi7kOXj8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 469E060223;
	Thu,  4 Jun 2026 10:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AFE81F00893;
	Thu,  4 Jun 2026 10:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780567848;
	bh=gkkN3rSsy1x2rUTT5oj5wUdRNrzE7spA48FJt094/So=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CGZwQshlxmc2XZ65+AI3hGi3KK0c2VD681fArvK6f2BFHTSRHLswxUOmVCb4sCt1W
	 Z9ma7nQfGtuA7lQiYx2fKdTlqUTmG+BIcgeCQfL2Ft0oGgI/3HNPGgog9ahiuDtETX
	 Xl1geh7I6bXjCsa2AirqS/z5tS58F7lwXKyYMrt7K0Zn7yig38OJG+sWAonnRQKFgI
	 0Laur7+CZ0U1AMh/yCTt6ur8/8bQ2CJgb1YdPFW+rBo7sBOuBgGRUEuBu/3wqv/Vug
	 UnntTmIGdNO1wzr7z87TEUllZ3vkysu/4bTLtGwNaq+Hf2B6fuzhyIqe6KE7/Mjw0X
	 +84CVI1y8zr/w==
Date: Thu, 4 Jun 2026 11:10:32 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, liam@infradead.org, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-hotfixes-unstable v18 00/14] khugepaged: add mTHP
 collapse support
Message-ID: <aiFO1RlpZ7Ki44y1@lucifer>
References: <20260522150009.121603-1-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522150009.121603-1-npache@redhat.com>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 9hmg6k6jaabb37kpo9ghyzqjofz3cwid
X-Rspamd-Queue-Id: D165918000A
X-HE-Tag: 1780567848-436842
X-HE-Meta: U2FsdGVkX1/UHnp8ELe/qr3Y8FfO2EGJI3gSibt8beOMjpaYdS+YqB3m1cFat+shXs8qyVHJVbFTdLjT35iGIYdcsMpTHkTr6vnjniBDP1IDyzpGEKPCj/wNcg0OywnDnBteUDSW1hS6wQviW2rGPt/AHclZs5/CqqmStBUquJp9BxT4gKVAJqIUw0sEYmgimhasUmysyBjG8gLQ7nfIeAeDxWHRo4I75HYYzhM39Itmzf3r8N+31k0xrZP1ZxUlR/pgFSTC9Bsu7oN4h/u524qKPCs5ZFkX2/FB2hURQS3QpVPXlfjQabZ7BFszPRa9yUbpONSunEHniG8dLZx2fdIi++MoJ3XDJYOMm3q2yiI6euDjQVvSrnLnlS9GQ8uksOknNwk97ZqNjyZK58lch6/7Tl6hcZX89IUSSR8WwaAJWCBsaoLbaJekLMI8uVk0AtC6I4bqE0yHRYmy+IcDhjD6iQuWY6Zhsp5B6Cozf12F2e4aCtOkSKg+XxteXoNlWqTaPxFSdSAoMRSik9aaKWLx1Sc3zWtQn9bAHSC2/bHhXpHk9T0d7okFupJPaK5NOYCdkHOsMuOR211ZK+kug+4bwB2OsYPCih8HnjTZl+4aOwMjY//CRGqaltq6t8JCQBF7ySk+BkoPiDusxRzCL3cHCT/evgyISlcgxOOssswJQkSXpHQojGljb84rb+9AQ7XDexd4sXhdpsz21QKeTjE3MODRMq+6t6h/i+NrlqMjOn9bVIaspqV/3MAaAKcYNacOe92VHS/mU8KGQMO4ldqLOpm81guDL3ctiqfvx6eUxX5NrSFxqqirNvmUv5OIBzaGQ9XcM8J9t7GvHQQEJSOHNItYdNMRVZzFcNP3cGNLIEZvSN6twqzWjjjDjtnZhWhvMWsf6/VrL8BccDifu6bPysgrkC99gapZpemfVUQAEzGeWo+HDRBQfgN9tbwKs5B+7JFrsJgEma1cGv2
 9nusqCgK
 QpkViSPdzOqDLXEWJPVncoNeo0WxmyCg+7dHJBBA+jF8lOc9ghhOXw7qOU4M5nf8HylDLBGx+cIz1bw5pPIbxgrBkr54qZ5J9Dvm8WBNw0a+hblNYoZrDYTpAZy7BQTYy9TKYhDXdAYwChcLS1gsSMKkk+Hh2EzKn2xetf4XrpTq5JX84wjY0A/t1wEt9Vh+gDwku78wqea4BSudSlREB5n0Jnl5sn/AGhQHLqcrPMJYSVTFqtV4s3wWst2j4hVbgwnjgADmCMrw8aVJ6DFv1j8eKXM2urnWipAfXHOze5i6HHTmZ+PegrmjR5sf2Q/D/D9I8yVYwfNQ7AB0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Not sure if already addressed for v19 but I just tried building a kernel in
mm-unstable and saw this (clang 22.1.6):

mm/khugepaged.c:1357:6: warning: variable 'pte' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
 1357 |         if (result != SCAN_SUCCEED)
      |             ^~~~~~~~~~~~~~~~~~~~~~
mm/khugepaged.c:1458:6: note: uninitialized use occurs here
 1458 |         if (pte)
      |             ^~~
mm/khugepaged.c:1357:2: note: remove the 'if' if its condition is always false
 1357 |         if (result != SCAN_SUCCEED)
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
 1358 |                 goto out_up_write;
      |                 ~~~~~~~~~~~~~~~~~
mm/khugepaged.c:1352:6: warning: variable 'pte' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
 1352 |         if (result != SCAN_SUCCEED)
      |             ^~~~~~~~~~~~~~~~~~~~~~
mm/khugepaged.c:1458:6: note: uninitialized use occurs here
 1458 |         if (pte)
      |             ^~~
mm/khugepaged.c:1352:2: note: remove the 'if' if its condition is always false
 1352 |         if (result != SCAN_SUCCEED)
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
 1353 |                 goto out_up_write;
      |                 ~~~~~~~~~~~~~~~~~
mm/khugepaged.c:1296:12: note: initialize the variable 'pte' to silence this warning
 1296 |         pte_t *pte;
      |                   ^
      |                    = NULL
2 warnings generated.


Is this already addressed in v19/review here? If not could you please address it.

Thanks, Lorenzo

