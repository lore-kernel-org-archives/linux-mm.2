Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FC14CD3424
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 14:59:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 369146B0005; Sun,  3 May 2026 10:59:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F3006B008A; Sun,  3 May 2026 10:59:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E23F6B008C; Sun,  3 May 2026 10:59:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 093546B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 10:59:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A6814A0920
	for <linux-mm@kvack.org>; Sun,  3 May 2026 14:59:52 +0000 (UTC)
X-FDA: 84726418224.01.81309F8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id CC0A64000A
	for <linux-mm@kvack.org>; Sun,  3 May 2026 14:59:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XBKD6Gfd;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777820390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9lOfFl0SriVGKkQJn2K4C2vEkVTlmden7k1vzvPyw6k=;
	b=R/eGy9Qk9K/FWRH6zS88yo/SXZSLAK2Nn02P4OTDMX+azv4ilgaE3mq58vJTjzPvMcsfm2
	knCp8NmMLNTzm5bfe/czuWx0dtQemxF9O9+DxAa94KmwvREqaBvUA/tcj4iT+H3gelRJEX
	SAx5rSJYqbVHBiyGM0H9GQitTrvWq+0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XBKD6Gfd;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777820390; a=rsa-sha256;
	cv=none;
	b=eegZaNSCoKmNxdVEFO1UsJGzzDCgzQ9Zw6VZ81QEyH0Xl1WzqA+edheo6ldTJQBy/lblxt
	NQeWXpXHGi6GE7F6A7r+lqLiLnB2IorRcH6R37vkxEqyTIFPDk0xs1aMplTeIiolcqJPzX
	Zb1Y/jVTFK6IvLTNvIglaZCbtHTco6U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0BF8B60120;
	Sun,  3 May 2026 14:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39A7C2BCB4;
	Sun,  3 May 2026 14:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777820389;
	bh=qd+6m4qTwQ++ioMS8gFbxaokMWHNwz5bq5v1CdNG3LE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XBKD6Gfd5BTPGg8/bdEfNKvUOJkpXmg9TRc6RFjcCMacqkeMHrkrJrC3wlPDm2uJy
	 SZMe6dox0ys34wBPeN6gaXqMPzEYYl5JpMCOWQOISRJBi0GUh+dSok7nnz4WKSJbzi
	 Vm4uWYL5K/qiGniHPJ7j3KdCToV6ksgBKNz1htLY=
Date: Sun, 3 May 2026 07:59:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: <xu.xin16@zte.com.cn>
Cc: <david@kernel.org>, <ljs@kernel.org>, <hughd@google.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <michel@lespinasse.org>
Subject: Re: [PATCH v4 0/5] KSM: Optimizations for rmap_walk_ksm
Message-Id: <20260503075944.0c19e048e7e20f6715d9e86e@linux-foundation.org>
In-Reply-To: <20260503203538194jFwVGloy43M1F3sQGaFt7@zte.com.cn>
References: <20260503203538194jFwVGloy43M1F3sQGaFt7@zte.com.cn>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oyejcghwqoei1sqi88bgw5nhochqwd58
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CC0A64000A
X-Rspam-User: 
X-HE-Tag: 1777820390-429091
X-HE-Meta: U2FsdGVkX19XyjEpY8F/eBvCW0ArsrvHo6FiUpzhv8CtCK9WwrxQqHYFEccwF40NSNCZ86mR4Le7iReZ7JNAgEjK7FWKP9X3G90f97KNq0cH44GNsazlOtpHhb8SQ1E/rkg/Hbbbrgjlqv4TZaCddptwjo6p3Z6Hm+LCU5Y3cuv0UgW66yOGfDqy4Wi34WELdGZTzeEjxzp44T44Uu9AHeo4/dEYLYU5u+ITzbUeKcUUpao1/yqgHxcyI8QD0bGPTEzCX2P+oy+MI3FKR/5Q4fEP6sAJZvpGOum2RRjWPh7pBBzkSzOp3Pmzdss+zMrvrR/+luXS2anE/nzpE5H+HFG5plBMyu0z83tvXf0pje82ZVMkvo61CKnjZdW7/36bLLBuDPfDN69FUXEMdqzjIhZvGGoSj9fs/c2Uf50iMH1KnejjcZ3xts5o9wreg+1I4krHW7/3LM1txc8vsyWZ0cpxJGPzV5k0AxQNJGkv+IyORiARskV5BCXQ2qr+HcXYWf1b1flhL1dK9x4K+jcTDjnpLStDmPaXkNPodk191Z5K1gezljx/4vSmQLfnCN0MYr2U9oGIz/WTaDI6N+vVbUx0bRzbwRZGZrDckmlQFe8FDJ6Ozb50/Qe44zi8I0qfPcSkHobqz2PBAuiejnR2OP7i/aQWh/vY09VzpaulQLQUCAvBaFcb3eGBxK0v3jedNYn+6tVk/quUg/XwSvA+8N3F2tbcgOOmAol+DLZEO6zWwJYBZPGdF6/fb0rdeSO3VMytwNcDH9byqtE0q9IZdcdeohyz9BA3b+3o+U81V7DShFTJ2nDHHFou9NCXKOJQMRoTQfkAuUfeWlrnQVRs3dBSuew2h637oTblm/M9E2NocbwBfygPaVhqjtWEE6Ti10ZBKDtfu8dCl0yJChQJlBYBDjf5RiaSlktEG6IOzEz7KjiNI5Bmu+8JEhzqPwYKCVLif2AcqWay5zdzxno
 fC3u+Frc
 g5HjC0Rx+oCXY+JaaExmBCpWfAR9X+sUPNB15rj7M2QHwIEokQStyUIgphmf76Rq2EiIjrEafldc7LPQtYOIPvzoues9swWfPMV8nURgZApDKHhRQPUGn0iSWRIduZ3sYZMFKelqXGYrmbmhpkcgzSn2swhGU7XoGKH6ctWbaSnSm25Gg1QE8Ekmi4iXw/hAIWJPUISrOja3AYO4GQTh+O7EvXK+NVI3bMvgy2Cy3Q7DhCFiE9DvjqbR1MhztfPukoqBaMCUPXCPOnXHunsRV9xhE37tdfpbjQDGa0rKUGrD/++axeXJ7ffdk2lnybQFsvC/GGdqIl8hfkMvsPs632NYGXn5GoDHbACMWRrYgdyoXuryeTJe3bAugQHlYBiymHGlEYQ+M+35lUD+aVQ5NPnlBULOSbCRq47QtQL279xTVpKJUk0iuxbrHPNKwb/+P72UooBjt6VmzEia4MjyDV6EW/IO/330/CqTL+atjxYOTOLI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 3 May 2026 20:35:38 +0800 (CST) <xu.xin16@zte.com.cn> wrote:

> Deep investigation revealed that rmap_walk_ksm's 99.9% of iterations inside
> the anon_vma_interval_tree_foreach loop are skipped due to the first check
> "if (addr < vma->vm_start || addr >= vma->vm_end)), indicating that a large
> number of loop iterations are ineffective. This inefficiency arises because
> the pgoff_start and pgoff_end parameters passed to
> anon_vma_interval_tree_foreach span the entire address space from 0 to
> ULONG_MAX, resulting in very poor loop efficiency.
> 
> An initial immature thought was using the "rmap_item->address >> PAGE_SHIFT"
> to be the pgoff passed into anon_vma_interval_tree_foreach(). But this is
> flawed because when a range has been mremap-moved, when its anon folio
> indexes and anon_vma pgoff correspond to the original user address,
> not to the current user address, which was pointed out at:
> 
>   https://lore.kernel.org/all/02e1b8df-d568-8cbb-b8f6-46d5476d9d75@google.com/
> 
> According to the implementation of anon_vma_interval_tree_foreach —
> it essentially iterates to find a suitable VMA such that the provided pgoff falls
> within the VMA's range [vm_pgoff, vm_pgoff + vma_pages(v) - 1].
> 
> So the solution is to add vm_pgoff field in ksm_rmap_item and use vm_pgoff instead of
> address >> PAGE_SHIFT.

Thanks for pushing ahead with this.

Regarding the [4/5] changelog: I don't think I understand how much
effect this change has upon real-world workloads.  Are you able to
clarify that?  "How useful is this change to Linux users".

AI review had a lot to say:
	https://sashiko.dev/#/patchset/20260503203538194jFwVGloy43M1F3sQGaFt7@zte.com.cn

Human review was wondering how much overhead [1/5] would add.  I do
note that it adds overhead even when CONFIG_TRACING=n - the rmap.o text
segment gets a few hundred bytes larger and there's additional runtime
overhead.


