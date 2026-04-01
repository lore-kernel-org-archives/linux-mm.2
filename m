Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CABCED3514F
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 07:36:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE1456B0005; Wed,  1 Apr 2026 03:36:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D97AF6B0088; Wed,  1 Apr 2026 03:36:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA72A6B0089; Wed,  1 Apr 2026 03:36:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B6A6C6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 03:36:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 66A65160484
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:36:17 +0000 (UTC)
X-FDA: 84609178794.01.A99BF20
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id D7B3620009
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:36:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k4CtlpsL;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775028975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aaGGGLtWsNqiGP0rFsOLqi4riUuL7jqc5h1v9YiArE4=;
	b=p+5zYgT2bPZHWjo4pw5jj0X04Ict2xqZgoN1qu7wTxEUySnAlA6ry6V2sl7iBMJw6Hbj3D
	QgYpX4eIdTJNhiz0VsMqD1C4XCcGhl+3OJrIxF+MPDPlGfx88B97X276itdKw90+cbJRkS
	1SIZt1M7JnPoDHLPYgh3gjAAu1P1YLA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775028975; a=rsa-sha256;
	cv=none;
	b=gzgdWg0hOo82XedD973plBFXNfH8kybSFkDpRslq2yo577KNF9aNjPWoUOnnOUGhCJ7SH3
	uE/l8x3xgXaZwZynrf+cJGXL5hbEBkkGrIFiAXechQvWoXeYuTP/AQnJ3iAAUjveOqjhJq
	aVRY0sZ/9G2mI1nyP8B3MEpX95fMMmQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k4CtlpsL;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4451E600C4;
	Wed,  1 Apr 2026 07:36:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380D7C4CEF7;
	Wed,  1 Apr 2026 07:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775028975;
	bh=5rTB7ibb4EJd260wLqdjnMqvReSP2z55srJA8vs8o5A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k4CtlpsL26Rsw+EZZiTev651DLF0iUWb89sMoje+UpM9F2+9JyFQZV7uiePHV1H+n
	 /i2ukQTEDcgSXP4NUwDuAFdXGGwo/Skow9y1ktYu/p7/E3VMhv2M4hEufIewFANfj8
	 p/BLMWEdSs+wgnXhSzjJHNiUJoU+H+Ex153JmRFl3GB3ug+v36/cIap6jkeDHIb3Q+
	 JRUnqk4t12bzXNjWSMzpk1U40HVspfd5ZbNgLe5tm1fZfUSyJLrweLyQKM44XGSoKI
	 DaMJMVfeLeLKAMo2esv8n7fnhIzaVPkwV2qo94yC5nfESljP26VOXlECeRxjDtAXLF
	 kONBLyKbWn1wA==
Date: Wed, 1 Apr 2026 10:36:03 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrei Vagin <avagin@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 02/15] userfaultfd: introduce struct mfill_state
Message-ID: <aczK4-vrULRiTvyh@kernel.org>
References: <20260330101116.1117699-1-rppt@kernel.org>
 <20260330101116.1117699-3-rppt@kernel.org>
 <actxscYZGFiyvUcs@hyeyoo>
 <acva_NKf7T5rbIC8@kernel.org>
 <acvnEd3-s6XI26vb@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acvnEd3-s6XI26vb@hyeyoo>
X-Rspamd-Queue-Id: D7B3620009
X-Stat-Signature: hhqnrcrmkmcm7q6rcdm8kccnk7kfn8mn
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775028975-286600
X-HE-Meta: U2FsdGVkX1+mapltmJzmvEBBON7Cvzo/r4LS1pPalTFjLcSEnS6IfhDJt69a18fWMXnExucXKKdWvbq4TOEuBP5yhf6RGG50dJnLqLTwc213zdq/+/RGAy9emoEzyPtjGH2VjYry/nY+Ed+lsM8TEJtNa1o6bJrlWQsP4H1HbZnl14u7YkSTuC/RIDm2rmetJQQIuyku78TRexceC8Dt1UykX/Qnozoo6ludAfNrziHAKx3cv3ADr+053UcQve4qZOXqo2Mf0BRWXgrg15Jy2xubvYmazJkFXn7prg/SGdq213gOwLpN27Fu1XLtQGpZDMEtDBT4L8ccHkbfQqKhS5uXSXHXahrFslGiMFbXOhzklT2VaLAp4jO/x0RvTcHBhsLWPRRncW06LG1vChstpshjGa8/24aEKl3nvFpAu0nGFglcNi7enL9LTutIE0MlW3kAD+r6KKpml40SIX+5JC1++yCocFu4vKAYGWhLC4Br/edPnGLyiV52WP23GubHrqVqmMEBiKglty87/taddLomNF3QmKkWxo7LaFPz9OCQDyT2rJTzgh1FG6QpWg2mfG22M34YnqzruXtFlky+evuHREsNybRwB3sB7dToYDHmbqWN1phcPhEgrhx+gQYV05PNZ3jCPNvBEpB24ImSUEq2IH4zEDTS2rAUy3DZDZsb6M0xCzZrF6TTsvbLZFeHEnvKMDT06fojkEbVbpjVU1X3hgEQdrwVt67uUwOhWBFCoMufMN9xtaALtG1Arm1YepgI/5E3iBLovlSSBcuRv7fHd+2JXH/8fpxNOeLJ4QVi3mPxqjvKC1pT3JUgj02ytStGHMFZ9ZURvnrhaMhq+q4GOOq8RLBp/k756KMh3M23T8pc3JwBr7U0BSKBffo3x4x0ceF5kL629yJVBwOmAjPnXkzQZ6aYXIZ8Rqx/WHxb+asbhPgE14ekRKSmCwduJ5wttUEbVef78lxZki3
 7vMVVnaK
 pnborOf7Ptv8kpW5DQcpp+2/kx3km7MON8rjzSOrU+1OM03zmw0rZRT0Lb2ATpW+L+tn1XpBA0zcs6s35WFH7kNLB+RgbMpbHjV3PAt1eKYv6L1miHR0aPCVbWg5eYHL51bK2AZBtG7C6EnRo39NW/mBukBLV2GQ6ct9FeDeNYXACdIDto8pEh2vI7jZsFlzeu85uz+Ezo5xUn+RuliGrYOXF67DW9Mw65Ql26s13xBviZyT3X1hnG73E3z0mxVNvn9WeSnYANtEYr+8QJPKlOrcG2ExJqGcf4Z313hwsI0jrxls=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 12:24:01AM +0900, Harry Yoo (Oracle) wrote:
> On Tue, Mar 31, 2026 at 05:32:28PM +0300, Mike Rapoport wrote:
> |         /*
> |          * Make sure the vma is not shared, that the dst range is
> |          * both valid and fully within a single existing vma.
> |          */
> |         dst_vma = uffd_mfill_lock(dst_mm, dst_start, len);
> 
> It acquires the vma lock (or mmap_lock) here, but doesn't set state.vma.
> 
> |         if (IS_ERR(dst_vma)) {
> |                 err = PTR_ERR(dst_vma);
> |                 goto out;
> |         }

...

> |         if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
> |                 goto out_unlock;
> |         if (!vma_is_shmem(dst_vma) &&
> |             uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
> |                 goto out_unlock;
> |
> |         state.vma = dst_vma;
> 
> It is set here. So if anything before this jumps to `out_unlock`
> label due to a sanity check,
> 
> [...]
> 
> |         while (state.src_addr < src_start + len) {                              
> |                 VM_WARN_ON_ONCE(state.dst_addr >= dst_start + len);             
> |                                                                                 
> |                 pmd_t dst_pmdval;         
> | [...]
> | 
> | out_unlock:
> |         up_read(&ctx->map_changing_lock);
> |         uffd_mfill_unlock(state.vma);
> 
> the `vma` parameter will be NULL?
> 
> If I'm not missing something this is introduced in patch 2 and
> fixed in patch 4.

You are right.
Here's a fixup (it causes a conflict in patch 4 though).
Andrew, I can send v4 if you prefer.

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index fa9622ec7279..c4074b6f4aca 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -764,6 +764,7 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 		err = PTR_ERR(dst_vma);
 		goto out;
 	}
+	state.vma = dst_vma;
 
 	/*
 	 * If memory mappings are changing because of non-cooperative
@@ -804,8 +805,6 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
 		goto out_unlock;
 
-	state.vma = dst_vma;
-
 	while (state.src_addr < src_start + len) {
 		VM_WARN_ON_ONCE(state.dst_addr >= dst_start + len);
 
 

-- 
Sincerely yours,
Mike.

