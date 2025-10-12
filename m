Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9153CCD187
	for <linux-mm@archiver.kernel.org>; Sun, 12 Oct 2025 08:24:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A582C8E0003; Sun, 12 Oct 2025 04:24:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A08418E0002; Sun, 12 Oct 2025 04:24:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 945158E0003; Sun, 12 Oct 2025 04:24:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 748E98E0002
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 04:24:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 99942C0815
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 08:24:37 +0000 (UTC)
X-FDA: 83988775794.07.BA96BB0
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	by imf23.hostedemail.com (Postfix) with ESMTP id 54A66140007
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 08:24:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=dy0RQGhT;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf23.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.171 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760257476; a=rsa-sha256;
	cv=none;
	b=2q8bVXBFiW0u2w+TjuJKahbSDPCFpKyM/ZeOwMCGXackx+QtXvTVy99bgTWOD9mGe6MGbJ
	l9kk9A+nBFUSgW7YGHMSWpGblIsoUEHtqgSRGPSOG8fvEHfjvQhjl1BQlguB99pIh6fdG2
	IM3zX92xxnryNfSlp7vMfjsibxBEMjQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=dy0RQGhT;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf23.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.171 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760257476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lZhwgTQSJZh4wRAyKM1kTP6Jj9b7XQ1HM2VBmL39PJQ=;
	b=3T9ehYDeyE3IXft5hZ3UsydKYwodTFspfUSgWgDRjPL4DQUpiKTo6CYVnKKS4kaCxGWK5+
	g0ZlIadBNAIP10FNgdRh1pcj907rl3S9Aiy5R8CKo0yA/FRSpV4BgQ24P7cZzxmMDozkSq
	mVh5UqOsh2HdiS8lizeuFpK8Rmp8rNc=
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4cktnB1zFXz9t3C;
	Sun, 12 Oct 2025 10:24:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1760257470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lZhwgTQSJZh4wRAyKM1kTP6Jj9b7XQ1HM2VBmL39PJQ=;
	b=dy0RQGhT6nKswPw1srr82MB1hCkNXTtUaCs4Mmjo1DKImT1Jf4xVR81H9dpu2YEYbYnJ+b
	DS+hmMBDDJiGaiyaTax9ykxk4nVliFl8jyVkINFBrBn6Rw5aHUuHe8rwkzn8EA9yD+37eh
	cBu5QoS4Bh1RXILDr5+ryJIomHRfmG+f6Qhnt/9uc+bk1tibuRdYt3XUhfhPq4tN+WoWWw
	9R9KCLhy0ew+GRkUEoGn2Qvd3yngfiEOLWUpKplkiJV8P3DRs9whceFiY74yyCbYLOY3mK
	Ruwln2Ag5PA1Xu8CHECQwqNfVVOLAnTYg+e3qZ7oQ3ASY1EcNrGjNj8J8XPoCg==
Date: Sun, 12 Oct 2025 10:24:19 +0200
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Zi Yan <ziy@nvidia.com>
Cc: linmiaohe@huawei.com, david@redhat.com, jane.chu@oracle.com, 
	syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com, akpm@linux-foundation.org, 
	mcgrof@kernel.org, nao.horiguchi@gmail.com, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] mm/huge_memory: do not change split_huge_page*()
 target order silently.
Message-ID: <e64diq7jjemybcwr2kgmfrp7xxj6osfdnjmpozilhyjjrt4g6m@brocsk7dnbgp>
References: <20251010173906.3128789-1-ziy@nvidia.com>
 <20251010173906.3128789-2-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251010173906.3128789-2-ziy@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 54A66140007
X-Stat-Signature: wa6ss61datnn1ep3d4wcnt9oo5xrw5gz
X-HE-Tag: 1760257475-733374
X-HE-Meta: U2FsdGVkX1/HK7un1nAhOtiJYjQfa9jRuFroLi+xpTvfv3u4+TrD4Dw+WTflkkmf7rGf7RWww9IP7zG228ufjEALi9f959WPwSCzAyj2pKGVDRIi10bxlIqjIHs55R09MLiRIFj0+isPdNAyxnwBrow9wbLSQgwsYxxX0+vCmnm4SjA41/rx7bl+Efox4BLicl1myoJ4VDz4j3Ws1mGV4eIKWNyyRShc8H+iXlEr7n4lFd3TuSBC1rhBkW6mUPTWIu1jkkH8bFJ+thAoCqwOFs0WAj95EPGvHnuZ8LoapnSjzOr/NN22QnM2MtmsXQ8tUS40qdAgIdJZP0eAw01jWCoRUsrdHLvhjT7IDwko6FGxFHNz7BTm61qemP7V2hBeoXro40O26iLZ0PGW7sqlrrjBt/qpsAOBxUpBfTWmwL9NZZG7kEUKBO/bCCjvmrU7UL9FbMBFrIqWcY/rUSDo0PDJB8L7Rh8aVLOz1G4GHmrpRNSwGoc7xIKzzeU4/t3d58OM1ACUN/ga28AzKkBO87gt3i2hCHoo1KvIcz1lYTdNQJfmZEKetPg4zw7MMX1XoXjKlzJR7SgemJNLFyjinQv0PyFjZ8BpSBj630Ikc/H9vC7JjdybOTauG7DTHm+C0RVDRjhWk+OhCuXCrGAZGyEdrJ8uIjQB1fCACHS3FDEZ5Eo4fw1FySgSEQBRco1tB12MZSas+jcWAzXx+Jm/+MwjYVMb5hiUwClvMKtggd29dHstChyues60rh0ih1oF8oHdArCmucmHEp/6i1sBKmVQRBZ7W9Vf6qYAxja/A+H7zLEnn2EME3anP6K9xc6VIrza/nzyEmrUjzFub8bs2hnmticAmAE3NRy3v5J4dmpWuMNnjlQvLlW5uzXQT6mKMq/Q4cEMQhPSfAFLY7qSE+PKtq04Gl6EQqxKPqbQDB2A4ymCUAlDGunH5k53DT0FGN7PWhgrT4viH8Q5NXA
 l2uabnbK
 aDuCEzQiXGsU2t956RZEhUzzmX92G+1+MElS9oiBJGoniSWnD8Ec8o0a3CSqwenBxTw+2wsBzB5HEpn6kw667q2wm7YnNK/fDAJ2rldAggrw0hIP6i1DvAgEjYekhxsEVA5G8615qzT+2jZmjiqdohgFHKiVUl38nJlht7dSft3wcUDAn1X4nXLN2Aw0YUUxdFosCPFKGYsnmHmIXTdKn6GUanwVmErlihqDd0Utw1JWQ31YtNjDuZ1lbPyQdwCYqN453cY+weQYeM0nBcx5lF5TUplg0be0zqrkK3sEe7jobQFWRxx9rowiuMnhBws8gnna4tvlIDD77UR2SnRskMLT5EKayzAlqJ7LIU+0utQtfFMjitm2yrsCE9JO6xzon1ONYNwsD8/sfyCT2mq+LzS0lBboatn+zbR4dTkKsuQKFtvghGSUVUfpg5VsQjrJEciF4BOXT+NmlDgpUOCDHSXIpXCJMWV6sFn6jBQ+0EPWv5eMVwoIK+1qBkyRU6dOPxjdc4It/EohZ48jN1c1c3LWTAypbJjJBbcwqwOKS1mEs32MkNAM2Ovs9Hev/7fa3DqdChvZBehZJyflQPlObgqniVQM1ldIRTNhZzDVroHG3apxm1gmAlOIfmj71CMvO42Zq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 10, 2025 at 01:39:05PM -0400, Zi Yan wrote:
> Page cache folios from a file system that support large block size (LBS)
> can have minimal folio order greater than 0, thus a high order folio might
> not be able to be split down to order-0. Commit e220917fa507 ("mm: split a
> folio in minimum folio order chunks") bumps the target order of
> split_huge_page*() to the minimum allowed order when splitting a LBS folio.
> This causes confusion for some split_huge_page*() callers like memory
> failure handling code, since they expect after-split folios all have
> order-0 when split succeeds but in really get min_order_for_split() order
> folios.
> 
> Fix it by failing a split if the folio cannot be split to the target order.
> 
> Fixes: e220917fa507 ("mm: split a folio in minimum folio order chunks")
> [The test poisons LBS folios, which cannot be split to order-0 folios, and
> also tries to poison all memory. The non split LBS folios take more memory
> than the test anticipated, leading to OOM. The patch fixed the kernel
> warning and the test needs some change to avoid OOM.]
> Reported-by: syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/68d2c943.a70a0220.1b52b.02b3.GAE@google.com/
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
LGTM with the suggested changes to the !CONFIG_THP try_folio_split().

Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>

