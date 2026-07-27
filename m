Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95D0DC531C9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:02:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 865A86B0098; Mon, 27 Jul 2026 12:02:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 815226B0099; Mon, 27 Jul 2026 12:02:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 707766B009B; Mon, 27 Jul 2026 12:02:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45A836B0098
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:02:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D309D80115
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:02:26 +0000 (UTC)
X-FDA: 85035023892.02.43BEC94
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf18.hostedemail.com (Postfix) with ESMTP id 154831C0012
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:02:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=C5Ez8iUU;
	spf=pass (imf18.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785168145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YA64e0u3ORB/T3g3HJitepVs+M4RrVR8jCHTxIeqSbE=;
	b=oXuv2Ianro74KxdJf6PuZhAxe3c7GUa4tjPB0gJ2MPy+zEnzGHYbyHg2Ap0W9RW6henpw4
	a/CZjOLiewxRwdWV76BShZjZkr6pcbUUqCfIXH/udusqkHApt2YXnNuFfW0PlvkBd1UaXg
	WhQqG+2c9jWF/hVwMub29MATjcpsSiU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785168145;
	b=GMKo6Cmg9LBgg8bcoUEbIbLfdjEZIHDi5tU2EvYYxXqEPdg7vGJCOVAaoCRomM4v7M8jVF
	j57zerv93tC3oNq07IqPLFqIiz9e1zh/lslSbJneN83uc4ZMg1ZzbmBKnHvlaeh14UZ4Ws
	ivV0NiEdjFOV3tLo6uPqy3yT8lBM4eQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=C5Ez8iUU;
	spf=pass (imf18.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=YA64e0u3ORB/T3g3HJitepVs+M4RrVR8jCHTxIeqSbE=; b=C5Ez8iUUw4drynAwsF7B/DB9WJ
	i+WQJYNS6dc+RjSQTkH6SzUiANBlfOu9pstP0UwdeyrufXjqdfuIo/V4B426PEivn/gnHqG4vkOC9
	dkeZkGnU57g1jQ+mIFpsRcZRLMRQu1K4+d1vMcTSQMDBhpPvDsyp4xxRZCHPYB8HbUROUpeujWgYn
	4F+FYAQwRv94jl0aqGI70SXEnLGfEhgN280kY8vBdtXt2bRNeoTfbiCbJFFvzcaVTlZ8H8N8q88br
	AMzX+ac8EriOPduOd9IFaPP7x9NcQ/76m/10t55bsDk0f4HBvbfHxI7O/HQj9Y4ZXOg+DsV8vsCw9
	XAriO73w==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1woNmU-0070nm-1C;
	Mon, 27 Jul 2026 16:02:18 +0000
Date: Mon, 27 Jul 2026 09:02:12 -0700
From: Breno Leitao <leitao@debian.org>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, puranjay@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/kmemleak: report RCU-tasks quiescent states during
 the scan
Message-ID: <ameA03TahRgsWoz5@gmail.com>
References: <20260720-kmemleak_rcu_task-v1-1-5b460ade777d@debian.org>
 <20260720153917.2e428e489cd0873ac6d4e6da@linux-foundation.org>
 <5b83b0a0-708a-458a-bdbd-41c6d4610349@paulmck-laptop>
 <amCT9QEgJRsLIb_y@gmail.com>
 <ffa5d8d2-1157-4a30-995c-ddae3566e3a4@paulmck-laptop>
 <amM1xUOhcpGpqIpe@gmail.com>
 <39c90e82-f785-4b47-9571-dd4b1339d685@paulmck-laptop>
 <amdWVTs0WKOxguxP@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <amdWVTs0WKOxguxP@gmail.com>
X-Debian-User: leitao
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 154831C0012
X-Stat-Signature: kk5rz38jx5f43nd9harm8ezsmmhgjrbz
X-Rspam-User: 
X-HE-Tag: 1785168144-102838
X-HE-Meta: U2FsdGVkX18A3wx5bHC3dsQMBkwkHf/TezduJDG2dGV6sQlyZKllPbA66LVAMEnmbDLIxmTVZSSm4tG0vOZTafmNsgkkilqRnTA6wQKAJWlE6sbG8XUkgQpgd7rKvxx33h+XO07EVaFlR5ElPoe8qvqsh8hP9cuvV0Kw5t0e6xyy/BeJg/r66Hhq/5aXHUumGnCox8I9v1ubVf17b6piEIvMEjYE0b44Lbob+FBNpwRRIxaLYZN32Nx8iM5QoMTDAnT84Dc9KgksXHZ0sO1L5PfW6u/EyVN3TLr6273hbE+/K7tzo0T5TJNRpSaGqAtQg3fcfcBkZnCTNpUe6d76nzI+ELiTnQKZ3kNNC1vU/h7GOECO2Ca2lsQIsOuQcOc/J4IhyVeW5ezlpImX0sn0kYk1vACrKkzM5WFoC+Dvd93NTKdLOO7tZj7mdK9JOHXpj1inn6oaZz5tvQYnjuDBLfsrY/arAiuzTnsLzX6gxyJMOmH9rgWtb/T22JGuTEmZl7bSCMpmb9P2prZvbcdlZ6scUMgky22QiqIsjhs3tiyygegyewvQkKirbzQ+uaG7LmtzCDWAXkvYRA/HtOJos1Jsrv2pJjD2s5o0SIyFCsogLYTKf8vHZgVJhiKYceup7Sr/nY4gTMM7rUEwN3MsEBhkOeX1sWwZTQCmYzG+XmhNpFfxtkXCBBlvoofo0abVQA587msxiDYXRgjyfNYixlWL5Bnzssr4qvS85Kq4IuT3O+SMCfmT6Wgi8AzD/G73q7S/ZNMWuFI4iJfswOFYY9rmkB22CdSIsnpeALwx0DfjNIQ3dJOnmxhDl+BF2IYi6uqJGerY4Ic7W9uVaKFUygMvJHXdAoytD3l2ZSF/DcCLbD5IjLbP06951u65WeqTwFJLcVVuPORGYNzbZy5dXD/nZ4ecSVPakDs2Ls8B4buGmAhmmrlKugPeuMh9Di7brhwkgsb9xV1UNcu+CeS
 O7eXUrDH
 +wH3LjDt8pDkAqBSM5ZUbMD19isIBPtO4zxiTNVfRXqAWwnWbyBdpLX8BK2CEX5B02Y4EEJ1KCsfZd8Y4XsrWYXxQTQfd7qXb1NMKMiW5iFEwIJpDnjoETku48cA+ykhFWaRIhkJqYqjYd4VITVUPcL0qukZE75p6RdlD5Vd3eqWTwCsca8PZ8vZ7Ls0zIKiC1aqgFLBN9bCmNuxH0++K8eXYzWLzqvlblWbaQOgXMM0XeI+VQ8YdM1Sa/Z1LCprF3olETB2Uu81sp2j8r1nZlONQ1Ttm2N+YFLMk1P0vbrilvToIX0SnACMDIw3kNGYw8t7q9TyeppG97lU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 06:04:37AM -0700, Breno Leitao wrote:
> > > The document was not a waste of time. it helped people like me to
> > > understand what the issue is, and what are the decisions we have ahead
> > > of us.
> > > 
> > > Back to what is the best decision/design, I honestly don't have an
> > > opinion, but I am happy to get more data about Meta production servers
> > > to help with the decision.
> > 
> > Looking forward to seeing what you come up with!
> 
> I found 3 different cases on Meta fleet, where rcu task stalls show up:
> 
> 1) kmemleak -> This patch solves it
> 2) KVM / kcompactd
>   * Holdout: kcompactd0 (pid 1216), state:R, nvcsw frozen at
>      716336/716336 across three reports 10 min apart (stuck ≥20 min in
>      one compaction pass)
>   * This is coming from: migrate_pages ->
>     kvm_mmu_notifier_invalidate_range_start ->
> 	   tdp_mmu_next_root -> tdp_mmu_zap_leafs
> 
> 3) Nvidia driver
>   * stuck in nv_procfs_read_lock_params
> 
> Given we can't do much about 3) and 1) is now closed, I will spend some
> time geting more data and possible a fix for 2.

Quick update about item number 2), I've investigated and found that
migrate_pages_batch() unmaps each folio before moving it, and every
unmap runs the mmu_notifier invalidate callbacks.  On KVM hosts
try_to_migrate() ends up in kvm_mmu_notifier_invalidate_range_start() ->
tdp_mmu_zap_leafs(), which is expensive. Patch at:

https://lore.kernel.org/all/20260727-kcompact-v1-1-bdfefddd6874@debian.org/

