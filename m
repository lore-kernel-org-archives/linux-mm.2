Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52783F8E497
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 23:53:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ADC16B0088; Thu, 16 Apr 2026 19:53:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 684876B0089; Thu, 16 Apr 2026 19:53:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C20E6B008A; Thu, 16 Apr 2026 19:53:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4CBE56B0088
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 19:53:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E01FFBC225
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 23:53:02 +0000 (UTC)
X-FDA: 84666072204.17.477BAED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4FF0020008
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 23:53:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EvIXvpzK;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776383581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ULddpf7KZR5Sc8gebiF7kxPFmYLmlCsEVUaj2SAPphc=;
	b=FQUKS3cL4aBF1hazYvmRM1QIs8uRminC/V0JJCB10O+LDC3wBu/TFjl03RXRUcxTRcKvGo
	Zr8MLdcGpxGPQQ/6rY3lD1LopcBPbyJP7jO193arjz2oHV1UOfeuzDaQzqEN3h+zicfZdF
	SL4J2hbMnohVToRC578axh2XR+Chj+M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776383581; a=rsa-sha256;
	cv=none;
	b=f0bEjPVhD7UHfXegai9gbplkpLfpF7rphgUrkqh991/aQ8jZHhLI8Ztrz+/YESPT3HD8ZF
	65u0Kukwcv07pgQUlEJBP97umN6lAI6MlRAGvc5Ije0oa06+i2Sfj/YBeFX4ydzEmlHGf5
	wrY7zmFBllQ5MU2cflXGqd6MdBNFgKE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EvIXvpzK;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0BCD7444FF;
	Thu, 16 Apr 2026 23:53:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692D4C2BCAF;
	Thu, 16 Apr 2026 23:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776383579;
	bh=9SWONO6EtK9WNbOOzpbgwmw3MwdSQ2Hg0jtMrKPGzDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EvIXvpzKVVjOwwTpybD1uSPUoLx6n3xoVIdmWsQG3W27VAdCTj5AQipNMzjCDsA0n
	 TpaXtV9msRMvTnZQHkBfjIk7scNcAH+1p4HH90Wk9V7qdpbhN0TDAkKd4+xdvAgBpe
	 SkuNE9P5MDxqhDr1u7YuNmIB5NMKNCLC/0/1DjIiuKHtfbvanebyms9Yu6q6XefFra
	 5xudcG0atI/nE4oV7YxTCC+HZG6pbT5IxwJYhMDHDp4utIIYqdthQ2GQHVWABv2AJT
	 bpkqUD/JSVbNpzhnPlTmlGlmT9t8CDi+zUGRmHvnsNzmH145M5U5x1ZbtpXvj9iQwC
	 aCSPZS0ZomZ/Q==
From: SeongJae Park <sj@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Sunny Patel <nueralspacetech@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/migrate_device: Cleanup up PMD Checks and warnings
Date: Thu, 16 Apr 2026 16:52:51 -0700
Message-ID: <20260416235252.58831-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <d95ee512-73ca-4535-9fc6-a2c77eeb350e@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4FF0020008
X-Rspamd-Server: rspam07
X-Stat-Signature: 18gstay8xrf61rwbfojd7tk1xpjpn4p4
X-Rspam-User: 
X-HE-Tag: 1776383581-926524
X-HE-Meta: U2FsdGVkX19DBtL2Y6MoqZsqsTmzZfR4xevkTp5zHaWhUy+yZqUMcoUOjvHNDn8B9TnYjGeI5xusbVDDp85HIlDOPIjJssSg2431iHMnEcUssw9uQKS6fOXNzwBP1mIlby5/0wVH/wqO31N5yuiHJrMym39SUz/WsNgRCYtr1wI9V3TbZiGt4iao28ERprkD0R5bMml2LGm1et0P0fTYRmhn8creAJg1uvf3qhR17CulEvNONE/MaMvNoFZNgB0WS8Sn9qh2kOW+KL2fKa/SkapcyGtbU80kvLraVJQSr046PPKC9nKuxPUq716x4CDWQxd+BMg0trIhk0OFWN3mLXsW5/Lsmx8qQ2pmyHJfw/QxHdKeOk65Rl5a7djvgZpwdloxVFA5SyyNow/+Z5AsxcCWv+9t1EPGp1ovviw1BiKY6ardTccQwP76M3dCoyAgc9FHS2ScNqWOMlhZBPN1h1UTLWRUDssr8ASe519f1DS4yNpvyuMeF5iqsHC5vFHM6lhD7cvMM3ZHkt5ywAs+U9ZD8f5TmO6h7O7GFoBc+b/T4pWqOWhzsl3lW3R3XwdKdhRTq6rGLjMV72JT0jEwxvmOoqVe3/GJZt1ouSbvkBH92BykP9SinN6+0rPH2hHEPT1X85Vi60e7Dv0nHtC/DVtN86qWlOfVdc5Yk/GFFbdPWJKUPyucQnKKFYy1qUrwVeaL3Cp96TrHhEyA67u2o4LDxezvlMn/JIQ1XTf5wkRY2I64dkwyWg3pGm0OkHMJ/qA4ge9RILiIzW6z7UYoN5K1MrqhwP+PPonO2PafoX73G2gWx7AAHhLsXw091Lt2FAVZfQP2l8RdEhcvF6AgKfViSzvUTb859talTINijuuomnolzOSdTGLC2YfkfwWhAcLrBR0nqjcIR9zyd08DiUdx7WABgQ/MA3RrQMNFGMFzIkgwQgxGozbvzG7iaH4q3NeTYW3cTq53okRq6OT
 qNW8YsVH
 cdnpa1qmoFH+SvMC9g5R2Vfr/8eJ7f4usQL9koQpvsFD/fKMMHjOCNh+oBmGKO/lzkk88JfCT9l9J7jY7bNOEPQygOlQ2geoc6kmUcb8IBYyOA5Qn3ECvNzBBP/ZvPCKXuhd69TPR8cUQvT2PtmOu+33vcLFjTK+DkLZm0SSQhfBtDnJrvFsyZ/vXeU+2Zjvw0GVI6wtTd/noCcG+31nBMH0Eq9X7fWQ9MzeTfrurdA0JeQeEn/ZEgzg4j6Tsah1wklKkL/MIguQoLzYAc/l9g4aFakidKVKDBc1fBKwbWtjmUu9uHSQ2AuCzZt1otJyeYRhOhbTaJNCAkw3G3PrXqhMzxksf2DqpluEVsx9J6Vb1dj4jcjUAYzw2+jKDQZBCF5FY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 16 Apr 2026 21:44:15 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> On 4/14/26 16:13, Sunny Patel wrote:
[...]
> > @@ -865,12 +864,13 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
> >  	if (userfaultfd_missing(vma))
> >  		goto unlock_abort;
> >  
> > -	if (!pmd_none(*pmdp)) {
> > +	if (pmd_present(*pmdp)) {
> >  		if (!is_huge_zero_pmd(*pmdp))
> >  			goto unlock_abort;
> >  		flush = true;
> > -	} else if (!pmd_none(*pmdp))
> > +	} else if (!pmd_none(*pmdp)) {
> >  		goto unlock_abort;
> > +	}
> >  
> >  	add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
> >  	folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
> 
> is_huge_zero_pmd() checks pmd_present(), so we didn't have a bug before.
> 
> We could also do:
> 
> if (is_huge_zero_pmd(*pmdp)) {
> 	flush = true;
> } else if (!pmd_none(*pmdp)) {
> 	goto unlock_abort;
> }

Then we could even further remove the braces and reduce one more line, nice!


Thanks,
SJ

[...]

