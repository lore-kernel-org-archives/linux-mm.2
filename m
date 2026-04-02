Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 559EECC6B00
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 03:58:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 441976B0088; Wed,  1 Apr 2026 23:58:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F22F6B0089; Wed,  1 Apr 2026 23:58:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B9856B008A; Wed,  1 Apr 2026 23:58:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0FFC66B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 23:58:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BD3091603C1
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:58:42 +0000 (UTC)
X-FDA: 84612259284.07.1E5AF22
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4DFB940007
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:58:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tRm1Dv2H;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775102321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z0UR8Rxxhq+pF86gIZ4q0vSCFlGIryaCr3yZJRgbLYc=;
	b=7dDZoyyhH2K9fViqfO9ISp5lBBwSi776oRu7L6OwBlG8TtUZuh+5FEdnHR4FerRMh2tnPZ
	3z100cUCM403sDAgAkAFXzapAuKMxWY9155PowSMsQYPJxF0n2bSwWguefnxob2YKXQ1OP
	lBzMmNUciTCMcAkkVE0aPs9u5Yr4QUo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tRm1Dv2H;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775102321; a=rsa-sha256;
	cv=none;
	b=g7pBj7oLJqNyfcMt3eujRhOFwvwitN6CuyNBOcPi8eYhC/c3f5V+dOeCi8POmn8vhdGnH2
	iLheNAQEp9iVeZ/yxzOpZkhxNDmvFXCInyl6rZfssEgafTsrUXE5G+7prspTifiuA28LNC
	mE7e74vo6GC5H09XYf3zNgfHX1DyxMw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 794D36185D;
	Thu,  2 Apr 2026 03:58:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B7BC2BCAF;
	Thu,  2 Apr 2026 03:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775102320;
	bh=zmuodQKqPXnJljN5/Z/DtZcXm4ZNdE8k6tsXe4+G1cI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tRm1Dv2HmLCxo2uNB6VvMEFQo+V7D47Hcx80cMrWftIsXT20xG41Y8n1kHimrKZVJ
	 4ql3gx6G8X7ICK5gpKMx7CQqxSesYY/QknDH5RP4F1sV+vvQ6T434en11R+GrqU5m1
	 edB3D+ZABFVSpv9+/1t1QN+edIGFzNjspP6Vy/k3shYFUbcF4/giu71eBBUW26uVcK
	 X0Hc30lInPezEyDmcoxe+3/IznjWVJyP0IH3DwhXlv7SBDrxPVZJYW2kleKc0o1MP6
	 2u2qcww/wm8wvFLzlI7+Lths10620sqNiFyYd3KrALXHTjuSuyZM0CiwSLKAuDnPFG
	 BgZ+wf7pRNQbQ==
Date: Thu, 2 Apr 2026 06:58:33 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David CARLIER <devnexen@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v4] mm/userfaultfd: detect VMA replacement after copy
 retry in mfill_copy_folio_retry()
Message-ID: <ac3paYh6sPHr3EJd@kernel.org>
References: <20260331134158.622084-1-devnexen@gmail.com>
 <20260331200148.cc0c95deaf070579a68af041@linux-foundation.org>
 <aczOCqrCx7Xd5HIF@kernel.org>
 <CA+XhMqzdQLZD4YWzyZfTwd_+sDnLqj24APqBRgum97_=8EcM2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+XhMqzdQLZD4YWzyZfTwd_+sDnLqj24APqBRgum97_=8EcM2Q@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: 69ghia4dunabyu8gfawewbf9h9aarokh
X-Rspamd-Queue-Id: 4DFB940007
X-Rspamd-Server: rspam09
X-HE-Tag: 1775102321-288381
X-HE-Meta: U2FsdGVkX187GeF8lHfLBRo9RsiwPx24oCgKJqK5hCafpbcusPxBcj+xZ1nDFmfIlV0riOvI04JC8PEHHtZ+ejSvKFlOt/mrxReW8qvRoZGNXDmt0MRdUPvjoUFywHKDJcEg9ODr2zlQRnRDfvhVQwWU34c2RJg01qkYpTsYzdXQm3ZPPh2tbkfCZ2KdEU2dk8IcRhxIINY79D85dpIfnf/7Ym0kTq/oYNxb5GU3ilyCftbQRVE6jEDt5TYxQcj3Nbzso78ieA4njJJNwCkRPvpCpH9hMIDuyUPoFPnjBdtclerY4/QgVlYf/QVamOK8rErjusgZ7WXMENMlhLffg/9NG6WSN6X6sfy2pn+vsVG5DcCC7Ogcr1C2KkWwMnIYrCq12WKyKGbuQaeKQsoFpb9+kCwRJET65boCMJQGneG3cVOC5QMO4BRo5TfmmxiwgiCBvimr/74cDn6IVldW2C8jZaoiFQonwbMInekmGiCme62U7o7X+rxLXMlZcURccnNU9RaXWsKH/zvpLzTRrTXt968hSufmq8P3dfmls640wIuNDzfFPOlUeyM3M8/iQ8k2vcH8u+kFQqeQBbkwXKvM+jwsoh3ReE7hwsbT7H99drQjwZzPAg4x+TyFYPQY4C2Tb3UImkfk+pz8NCCgZTq/F849NaE74pJIdLuzUxZPtth3j0l4wBp7iwP19ztyp9eTH7psqz/eG8wSNfqhek7QLfm9qBjwmOqkrChsHppQ8YIXdW9x0FuJalTBldURyO8/UcI7AQ68z4MJrgM26f0ALU4AiEIkbjxLrRI148Qmd4IrdFk9PZf1gbdIV/ZTt9e5hxTvOz5HsrCbEh/cDUCHBBs1vlAb45X3yEFnG2KypNtc6IFZIzOqO2R8gcDzd17S3TWXtxfxYtQOZeO6LiYWEBkUcdGrmELvIK4soVoR3g+X7+Mo5N0eoB/6XRqMfAawB/IX2TkfI+bWM4G
 3CmOhk64
 wtIta
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

It feels that you use an LLM for correspondence. Please tune it down to
produce more laconic and to the point responses.

On Wed, Apr 01, 2026 at 09:06:36AM +0100, David CARLIER wrote:
>   On Tue, Apr 01, 2026 at 08:49:00AM +0300, Mike Rapoport wrote:
>   > What does "folio allocated from the original VMA's backing store" exactly
>   > mean? Why is this a problem?
> 
>   Fair point, the commit message was vague here. What I meant is:
> 
>   mfill_atomic_pte_copy() captures ops = vma_uffd_ops(state->vma) and
>   passes it to __mfill_atomic_pte(). There, ops->alloc_folio() allocates
>   a folio for the original VMA's inode (e.g. a shmem folio for that
>   specific shmem inode). 

I wouldn't say ->alloc_folio() allocates a folio _for_ the inode, it
allocates it with inode's memory policy. Worst can happen without any
changes is that the allocated folio will end up in a wrong node.

This is still a footgun, but I don't see it as a big deal.
Let's revisit it after -rc1 and please make sure to cc "MEMORY MAPPING"
folks for insights about how to better track VMA changes or their absence.

>   Then mfill_copy_folio_retry() drops all locks for
>   the copy_from_user retry. After mfill_get_vma() re-acquires them,
>   state->vma may now point to a replacement VMA, but ops is still the
>   stale pointer from before the drop.

And this is a bug in my uffd refactoring, and it needs to be fixed ASAP
with a simple comparison of old ops and new ops.
 
>   > Second, I have reservations about vma_snapshot implementation. What
>   > invariant does it exactly enforce?
> 
>   The invariant I was going for: "the folio we allocated is still
>   compatible with the VMA we're about to install it into." Since
>   alloc_folio() allocates from the VMA's backing file (inode), checking
>   that vm_file is still the same after re-acquiring locks ensures the
>   folio matches the inode.

Again, it's not that folio matches the inode, but folio is allocated using
the correct mempolicy.

>   The vm_flags comparison was a secondary guard against permission/type
>   changes during the window.

Permissions should be fine, they are checked in userfaultfd_register.
Some other flags that don't matter to uffd operation may change during the
window, though and then a comparison of vm_flags will give a false
positive.

-- 
Sincerely yours,
Mike.

