Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDB6E606A661
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=bieAlkYB
Received: by kanga.kvack.org (Postfix)
	id D65546B05BD; Fri, 13 Nov 2026 13:47:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE7916B05BE; Fri, 13 Nov 2026 13:47:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAF116B05BF; Fri, 13 Nov 2026 13:47:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9715F6B05BD
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:47:41 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 24CF51A0148
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:47:41 +0000 (UTC)
X-FDA: 85430979522.01.604023D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0474D160004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:47:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bieAlkYB;
	spf=pass (imf08.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794595659;
	b=CAP/XRO/uYrmRztCydGMTxU60xqfx4+KXXForjdMNsne8zsrs0AWmoOy19vQ2iZD9Xo1T5
	ZzVUIoc9k5Z5yHiHTlKitbtKrKkzOXu/DhKvyHtXbyQiGxyNh5KIArSsSHibEV9yGGS59y
	iWYilHW28dbF8Jm1pBg29siy57m1FdI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bieAlkYB;
	spf=pass (imf08.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794595659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1C5B03h9LkM0Rfb71CtzbzXspL8HxxnoCixsWU3wVKo=;
	b=cKcV+/nYWla7JcCgQn8F7Dh2R/aSUZj41vK9gYd7PukHIR4qE1unv3ffOI+z7pQRJTVeP7
	3TPQuX+7ah23Y2BJB+nY9Ot8VYkfoHmX69G69lDQgE+qImR56vd8HycP16xod8dCZxj/IW
	9lX0QEOT+WK1XOHGSmwNkOpGC1edaYM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B30E3143D;
	Fri, 13 Nov 2026 10:47:34 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E29AA3F673;
	Fri, 13 Nov 2026 10:47:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794595657; bh=FlyuBewiCDaPu1+s79sWx/lfGstyIBmDKHKwd7lp/vM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bieAlkYBHpiq7QexIl6ZIv6M7QaRTP5zcRITuv0go21Gf47D3IhN291ITaYxrPNPD
	 WP+N1VV8XUBe2tMhPl8J4zlu4fJoNSx3g2TVg15aXVlmGGEXdFO5JvV6Sz2g5qC0wZ
	 dide5nesRF9/b94f0Vka18t5XTni0ynuw8xegKs8=
Date: Fri, 13 Nov 2026 18:47:32 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2] slab: allow sheaves for SLAB_NOLEAKTRACE caches
Message-ID: <avdbRHMbKxVlIRnu@arm.com>
References: <20261113-kmemleak_sheaves-v2-1-8c557c66cec2@debian.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113-kmemleak_sheaves-v2-1-8c557c66cec2@debian.org>
X-Stat-Signature: ds6wro7tn915c8tckqsmx997noqjsr5a
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0474D160004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794595658-480709
X-HE-Meta: U2FsdGVkX18oAuu8/YfIiA5tzzlewCmpl01uU9KtxcSpxWceJjrb58dT8LlFj7B7fqXJg+CoLbkIbzr2sscXrS+d+CahhXi5YZ1JpmxeZiNMzdnBvhV48d79ds1U4EqgPGXO12rDnIQyf8cvo+MKqWlw6axVGXVitz0IC/OGDhrHjF0NHyv2RDb4cIeZ/FRgCr4zFjX/roquOWm+PmqDSXoQ1U4O5ZDP5kY0ZkMtdlYDv5dfrM09bY7FwcOhmu4IbBLort4HdJUoTQ45SF9o3nwVAwMjMbVWqVXiKogxnszbaNa/C50fYOMmd0NTscdDaNWiIs+uNoAUlaXtiELL9vRR3GFdzvGL7f1Ue00hlFt33s+mX6Mxk7UGPRtF0sEK8ilsRp9JUwsg+QLPg1qInFE28kZ8M16CxwfMfqRe3ojzeGlVQwFerUZUkzPC33HkAEdnQrzpjMXGle2Lb9hr/rr7M/TP1uq22LnqHtAMn2C9/yR+hKwihOeWFqmWBEfZRAUtAwohTtEGUz04umOy57jwuVwWJZ0H6zJFWF7Q+MZOHWHeDYYyhzVMiqqt5S88VJ/gOs1TJagmeO8Wk4S+/A6AEg9IZqRmu0bZZiUWyw6UKvao7kHHfjuYve48Nj0s9znZuQ4tfYS1Xqlq5qsq1pMoQj/wLf85jAx9KmeHaTHd5MhSJ9zs+PZe0Z5uAdVXn3kZbDJccjOrbC3Ee4Zo+S5TEbhC4IxVRyTUsCchSc6ul/hqPigSN1gafasye3GRRkYnsHmAvzjWhaLE3peo6N4GVie8UQqKrU5sYg6TgkLEkz4ZMQwvDO5AQOUFHeJ/3nJh69cUtboLRgRWPPFAu+PeloxjtfrxFn61nkPJaF4TGukY/k8mvkN+6V3nF3/gD/NhG7jfzdDNXO/Vl7uwkm9matkZZm3cWGvxDoV/oraKQ7dTDXH5IoGBIb4z12sCRWZNdfmVmChmFpeP6wH
 QZ2AimvX
 xJ1KkD5iVs1LAVCnwwAM5HIAmvSnI6TM6a4ViEzi0lVgaVrPtrwWfAxLnL10T1J/iubdtoPByNhEkVzlvgP1e6df6+dnxZdANE6V10Fym5b+050GI3D9tCnNG2LX5+jUR5uwZCHpVB1xq8Jy6MhRtiFlODFbReQtD5rGg1haUGqt073WO346Yq27rs+VMst2lufKyCMoB2G1y2LeYFCl+rVoRDkRmm3IJJGrhBNLL0Ea0xcPiVQq3nZyet/LnRBszDjLvFtqM+LnFmBiRtIO1cf5Hiz8d43ZedWxXVn9BeNCECtGiJBs9FxiSiqishc2ImcL3FfTIW8CVSREHCTEiBZmLqGle5Kzw9yX775bSxtL80pvg4ohdrmFN2Il35pTTIAXNb3Ac4JZPsZYb4Rfpf3GHm8GZTevl2MGx4uhitceVLFvLRyBgrw2CH/RFxzgL+RxwhNzKYd4Ks9zozfjSVaJUw6PypA7kxGDOC+VngdYz+fY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 06:36:56AM -0800, Breno Leitao wrote:
> This is a patch that makes kmemleak cheaper to run, by letting
> kmemleak's own metadata cache use a _new_ sheaves type. The flag only
> makes that possible without recursion.
> 
> The cost today:
>   * every allocation kmemleak tracks needs one kmemleak_object from
>     object_cache. An RCU callback frees it later.
> 
> Why that's slow:
>   * object_cache has no sheaves, so each of those allocations and frees
>     goes to the shared slab lists under n->list_lock.
>      - On meta's fleet kmemleak kernels, list_lock is the second most
>        contended lock, after kmemleak_lock.
>      - About 88% of that wait is RCU callbacks freeing kmemleak objects.
> 
> Why sheaves aren't allowed:
>   * a sheaf is a kmalloc object. Tracking it makes kmemleak allocate
>     another kmemleak_object, which needs a sheaf, and so on.
> 
> When I reported the recursion in [1], I suggested keeping
> SLAB_NOLEAKTRACE caches away from sheaves, and commit e47c897a2949
> ("slab: add sheaves to most caches") did that. It stopped the
> recursion, but it took the sheaves away from the whole cache, although
> only the kmemleak tracking of the sheaf itself recursed.
> 
> Commit 17c38c88294d ("slab: remove cpu (partial) slabs usage from
> allocation paths"), from the same series, then left these caches with
> no per-CPU caching at all.
> 
> In hindsight, skipping kmemleak only for the
> sheaf itself, as the new SLAB_ALLOC_NO_LEAKTRACE does, would have been
> the better fix.
> 
> The sheaf is allocated with SLAB_ALLOC_NO_RECURSE as well, like kmalloc
> sheaves. Without it, a backing kmalloc cache that needs a new sheaf of
> its own allocates it with SLAB_ALLOC_NO_LEAKTRACE too. kmemleak then
> does not track that sheaf, and can report objects queued in it by
> kfree_rcu() as leaks.
> 
> SLAB_ALLOC_NO_RECURSE also skips allocation tagging, so mark the codetag
> of these sheaves empty on free, as is done for kmalloc sheaves.
> 
> Link: https://lore.kernel.org/all/aW_NK2NXVgtuzCVH@gmail.com/ [1]
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
> Changes in v2:
> - Fix sashiko findings:
>   - Set SLAB_ALLOC_NO_RECURSE along with SLAB_ALLOC_NO_LEAKTRACE, so the
>     flag stays off the kmalloc cache's own sheaf allocation, per Catalin
>     Marinas.
>   - Mark the codetag of SLAB_NOLEAKTRACE sheaves empty on free, per
>     Catalin Marinas.
> - Link to v1: https://patch.msgid.link/20261112-kmemleak_sheaves-v1-1-e40e3d73b253@debian.org

v2 looks fine, so my reviewed-by stands. Thanks for respinning.

-- 
Catalin

