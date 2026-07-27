Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60CCBC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 13:05:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F7D46B00B0; Mon, 27 Jul 2026 09:05:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CF1D6B00B3; Mon, 27 Jul 2026 09:05:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E5B46B00B6; Mon, 27 Jul 2026 09:05:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 19FCB6B00B0
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:05:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9D076A076E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:05:04 +0000 (UTC)
X-FDA: 85034576928.29.0A6C107
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf18.hostedemail.com (Postfix) with ESMTP id B31191C000B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:05:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Ht5Jap5i;
	spf=pass (imf18.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785157502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s9wWiDjCW477tgZIUjVpQbdu88BE7PfzDyOZG1n0onM=;
	b=EGiQGxKd8C6Rr+6/MbPzaU9x4J0zHN7KGjlgfg9qn+uEl6NteeFgvetza1NHtCyKOrRaEx
	3rAu+St13E5kTl3MlkdwGuPg9j0bYrnu0OESG0RZcjCZtS38tXxDJrvKWBws/M8leEGFMf
	EEdOiLVBXPwPBPIzHV/Jcf0783Ruxmg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785157502;
	b=6YNd84xuqKTiGqyaTtJ+NauY7xNZk09HifZIBazr5BmEBuKJws7M0n091aRJ1UQiCTTM4O
	rk/WUz5khQglP/G9wfoPEQaXQnCDGBlf5bwAlNPchmWq+RtB/CBVe8UqM2if+RgIpItg2q
	Omi+o5q39rxoich7AR0or/roJsgkt/A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Ht5Jap5i;
	spf=pass (imf18.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=s9wWiDjCW477tgZIUjVpQbdu88BE7PfzDyOZG1n0onM=; b=Ht5Jap5i77PnqRGHRJ802tXx0a
	O0b3rd4TWLwB3x2XgwTlCrpDZzrM3Gf42i30XVOZSnCwrLQZ4gw0i1L2uUovANqFW+cBIAAaXPiRb
	AgpskSy8py7EGSxkV6eY5FdnBBugHkPHuBrTJr1YM2AwJ6BAd9edCnoGgFgL6rItqvEbnG6ITkQhQ
	IzIZiaCsuq645/RTDjOLOahDvGWOwkAr69MGaU8C3l0BBRsvikl5Sgj0ZgwOlnN6iDqz1t0UgOgC/
	nuVCcppC1qxuGmCx4LnFJ7Hv8zNrUkW+7YKO3YgPhhQ8WzRUPhhtN26m65ldg+BGawqO3anAQQmLo
	8uTm1X/Q==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1woL0r-006utr-0Y;
	Mon, 27 Jul 2026 13:04:57 +0000
Date: Mon, 27 Jul 2026 06:04:37 -0700
From: Breno Leitao <leitao@debian.org>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, puranjay@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/kmemleak: report RCU-tasks quiescent states during
 the scan
Message-ID: <amdWVTs0WKOxguxP@gmail.com>
References: <20260720-kmemleak_rcu_task-v1-1-5b460ade777d@debian.org>
 <20260720153917.2e428e489cd0873ac6d4e6da@linux-foundation.org>
 <5b83b0a0-708a-458a-bdbd-41c6d4610349@paulmck-laptop>
 <amCT9QEgJRsLIb_y@gmail.com>
 <ffa5d8d2-1157-4a30-995c-ddae3566e3a4@paulmck-laptop>
 <amM1xUOhcpGpqIpe@gmail.com>
 <39c90e82-f785-4b47-9571-dd4b1339d685@paulmck-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <39c90e82-f785-4b47-9571-dd4b1339d685@paulmck-laptop>
X-Debian-User: leitao
X-Stat-Signature: 1nsh8fatpxoj7ztxckydnb6jaqsdeimi
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B31191C000B
X-HE-Tag: 1785157502-44851
X-HE-Meta: U2FsdGVkX1/z2lDBZ7otdZ9yxYDrzrQ64nmDNFrCtptFG4KpJhfDw5ICN3s5K4Wjp1pyIesGtl6Nv0XlUo02jvoBNqhkq2Rm0EuDlBNTY31xulJEdMNBJn6ZDfJsXC0DTvtjr2WYXarDJ4qeoishu7uiOXmQ498dus/wV0YlsGDhqiOtZ2jm36VJibL4zJw2f5JY54ZNnnIEShSfS1QMDEL3RjmdAxVUcXLAj0SLp9ROuwfuZGkJZviY5eSUDC1pc8H9kh+Mi7/xc7F/9iJjwNCEKyQ1lyA/gVtEgamlLxEF13JjFnXgwEK58m1rge/j7r26D3FQE+owSfHTUgKnceHj5LTXREbgV0JaYjSodgvBEu2QroJF9t1FY62WY5MGe3ovKeC5Aat2l7CZJLPZ4yG9t5HQVmX/R209HksJQQ+dyEr9CJDiYjN9991Qj3l87odAIPsUOxoJyttc1X3qPXKzvvpgg5yzntu+LkIw6r1ttxhA4xFvOew9LY5KPSELikLxTyaZ78sR7okeYMSHvWiBkRxaqhGvhchxdXtaEMYW+DCsUeBpEWZ0cq/bJ5hWGlc4oUbcJSgzqO67hS/1Kl4KftCfYFdCfBWjP7S5oaEt5wuxzoZljTp6f2fD1cW8Mg4yCQnd+YGF8od5NcGyyIvCzLveJWvoh3giTMyj1X4uONRor2TiWKMXbXcjc+lzWhh+VxfjveRwBsLEchSJWpO0e5ncBfgZ2faahKIMM4z0MCxfde3GMGeVKfVyk8araM7XgEqYPXcygr9Q6nOodp+5K/saBmKSaIQwJjxSi1GGKFpLYn8ufbTqh8t6ovEzZNpbqPO/5Sm0IaJB4JpZWhFotsT5t9uKo+tpdoFqz5WDPN9UYSGypfnzHrhN1MZXkyC4KOWhO3vyJPTgYXSYQPKNziXknqESMRhXvZ6AMvwZ36CeAWcjQQ54DF6vVniFLjoO7kZY/e2gfxO5TWC
 r44EMuR9
 RB/WOeysCuHTkvjmCHSUGfeK8gmuPgCHMRq6oOeXOWHYNdYNdbmOQT0pVFRLB30ItqE/p9Si6RbIUJ1M0ywF+14itutyuIri52Ij9C8MwxKtNmVfqrrJfMh08aJRi4hT1acMtnFRcHp+DJ6qaFY+vffNJHzNRFAH5lhGGDfeGePR98rmEWjfpMLnpLCDaBPyR3bDL19vz7+DVPlL+LfYEBbPJVuTBnXzJnJjIQ0pJ45rZ+2W1usLQrqU0HyltoXdhwL0DAXSmhpEdgpwebT3bMMREuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > The document was not a waste of time. it helped people like me to
> > understand what the issue is, and what are the decisions we have ahead
> > of us.
> > 
> > Back to what is the best decision/design, I honestly don't have an
> > opinion, but I am happy to get more data about Meta production servers
> > to help with the decision.
> 
> Looking forward to seeing what you come up with!

I found 3 different cases on Meta fleet, where rcu task stalls show up:

1) kmemleak -> This patch solves it
2) KVM / kcompactd
  * Holdout: kcompactd0 (pid 1216), state:R, nvcsw frozen at
     716336/716336 across three reports 10 min apart (stuck ≥20 min in
     one compaction pass)
  * This is coming from: migrate_pages ->
    kvm_mmu_notifier_invalidate_range_start ->
	   tdp_mmu_next_root -> tdp_mmu_zap_leafs

3) Nvidia driver
  * stuck in nv_procfs_read_lock_params

Given we can't do much about 3) and 1) is now closed, I will spend some
time geting more data and possible a fix for 2.

