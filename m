Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FAAF606A326
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 08:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oMCJcnkQ
Received: by kanga.kvack.org (Postfix)
	id 912366B061C; Tue, 27 Oct 2026 04:25:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C39D6B061D; Tue, 27 Oct 2026 04:25:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78AF66B061E; Tue, 27 Oct 2026 04:25:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 49F496B061C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:25:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D0D6516096B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:25:06 +0000 (UTC)
X-FDA: 85367721012.04.5736F75
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 36BB340006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:25:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oMCJcnkQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793089505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2R51g1GKhJVpEHSsNmeCyBNO0baPm+a+p1RPH1MDDNw=;
	b=yBZXpp4cqe0b+S0J4k65UoElyZzoJEa3OYpTm+9BUkwobAqq84om8cyM5SvUhThsKzIRU5
	lM56lhjH8fS073lPD/VFq7NlWsM/lovwpdRua9oQS4bVj1HCqzDVNNP6s26zYc/HXW3HTw
	9NeseEEi22qYvetFq5q9d+ALPPE9yYc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oMCJcnkQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793089505;
	b=Y3D8o9YUXI2Q+JCb6CeeVgLochbIymjG1oRFLdCgKfM3eia1fVHxIvsa0D9Qml7rVhZogt
	+Ci2aJ2PH2H6qY7QVGMkF6qsk4N3Bl1QMrf4zonyPGI1g+tnRIvnLQsPKG1UeB4CRLYaPg
	dRrrpHzB+okwSIxhtD2MIWzF+C1wa3Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A94E2601F9;
	Tue, 27 Oct 2026 08:25:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4511F01825;
	Tue, 27 Oct 2026 08:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793089504;
	bh=2R51g1GKhJVpEHSsNmeCyBNO0baPm+a+p1RPH1MDDNw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oMCJcnkQ2ugmQRTH47VuoA3lVoRzsl34BDT2jKNZ7RUkFZzWRMbYSzo8WR8dK47mW
	 pqOc0eK72lDgDWD3QdHT/pBPnXi7ryj0yWTtmxBWUn+p5DRaD+1S+/Zz1qFJPw0jDt
	 lyPXK9okKJapfC2UEO49ON8OIAwvxBsXfw7kAXbJ0jwSXdgh4Nb8U2On849jV//cVT
	 XlO3MbW2lEPG9jGdLQoIYuXn+vfpx2LaaFHDs6IoRpEheK1ZpsFb3+BVmLglbhci3D
	 +YInIICeV3inpT7BSAzD/puAVkPVByrS2yMaytLjeB9oAMCCDWzd0u2d/tbYp4aR5g
	 N0rWUbD2viZ0Q==
Date: Tue, 27 Oct 2026 08:24:47 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-cxl@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 25/46] mm/userfaultfd: wake waiters when registration
 modes are removed
Message-ID: <auBcES74Q5M3MWCW@gremlin>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-25-6f74bec9a5bb@kernel.org>
 <179307782442.2301705.17273288326330283268.b4-reply@b4>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179307782442.2301705.17273288326330283268.b4-reply@b4>
X-Rspamd-Queue-Id: 36BB340006
X-Stat-Signature: ikzw8sgtft68wycehknmr71zf43ff47p
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793089505-457472
X-HE-Meta: U2FsdGVkX1+a5+ngOhG+dDTsOZLFYcON+/1K3fSCHe0W6/eMQHOb2WH0hLK9X/uzBQLuYIEbRO4SF65DsY++U93WXGGW1r4bhDz6unM+jLerRZybRYbcwfaNCRDxgkTi37y1zmXeIJSYdUfoCQFiqGza8DKWG9DdfA28SnCv6qEPQhC/j7t+PP8XqCFF6Cj/jx241QWDFyWAabSoFHNV7vTSPA9v7ap6g03tl5DfazlBsrmxXLDx2oeS4eOZtGdAJvQg4Ev9opE85IF4JUK0CkY35u2WafbuFrNYEu3teomndOFKy10M4IUxUB8IxTiFIKursZI/r1fbmuHCin5qweYtntqX8D/vTnNZvUpEOzcDijlz5ybrY3Nb1W1qzD8CzZUb0u38u7JdPUxX3Bh/VcPj/nzsgOINq2EU/q8XyfyChB2hw6ufIaKI08S+FYUREhQxr4HXiLwF5PL6iPIY0MJ/okACdzqA9ydUAj2OuT/COC3p5vpBPp2LdW416j46W2S17jxIN55jyw8/w+8958VlKd4Ot+RbHYPWpe+J1Uxsr+tNmvi8zynEykOLmRoHjr0LENUKS+Hs+AtPZIfBt+bmyZ3bqfLO2nFypeuuu8CE8Z84IxMsAIYhHqZ0lMo4N+CeyCraqgnhIjc9th+qCVdto/CiExmMYGQGFgXJcYSmZEjrU/kKNsC1yd6+lLP8TSdRax2hiiaP4XHAG3RExpzByPn+U60g3xa7mmioidFjGQGeTOSUw7jejnBWpdUQg5+YGdmRMz0ondNTUuN+7JD1GicAhZCbL1eNxOlg1ZS/xgLAcXWqHFGCg+G4FUqcVcNONTQ/xraqhNU6DsgyANgZh63FD07q0OFcPa3tRWjOwKcOHfSXFshnkiECQo0yKLPeJWcyfckYx6HrGitpBKlxVzeCQOnDy18LQA8Trj+RU8RG12/nQZ8y23X+YjdiwOm978jqvU/ln7/f3KH
 gI9XJvY2
 xCNGuLXoPCiI5Ar6VjZdpWJRLPekm3WS8wp7wQLdSh5EJNopv2gUXDUmt9VQ5G/+1kWX5disKrvOL0KjsLyV4RfV+vSWpyhSR74yk4c0aD3I3/n9AMu18iKdMFLy3OpxKZERbG+ecwLfI74MTaqt5Jt+HYOENMLb1yl4udK/9R6q5/CUqbMewcfxV1sAfWzcdEZt9IBKgJ2b5jnQu5OykT4HeHF6sgGKnQUraPyAAmYwT1qLepxCS/3Hs/DxgaRRUBCc9F/yMSYegLaAqGvwVJu3NiH98aT1Peukw9UY+NuYCewIpdcqK1YR+Cnks5pe8w348HLWPOgibygrAYKSljgDRRlPCNC3l3vWexXcTGvpUi6n0bsfa5hJdNM/wRRycenbkgE71+/9fmJt162Y43GLUzN7AoTc/4DXnuVtgXSyIstJzPpSPEAdGfKbK/CLSgIIVPIbc518pyRo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 10:10:24PM -0700, Gregory Price wrote:
> From: Gregory Price <gourry@gourry.net>
> Subject: [PATCH] mm/userfaultfd: compare exact registration modes before skipping
>
> Changing registration from MISSING|WP to WP returns success but leaves
> MISSING enabled. The no-op check sees that WP is already set and skips
> the update, so later accesses to missing pages still wait for userspace.
>
> Skip the update only when the current and requested UFFD modes match
> exactly.
>
> Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  mm/userfaultfd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 669f71d485d02..0a28130cebc99 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -2299,7 +2299,7 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
>  		 * userfaultfd and with the right tracking mode too.
>  		 */
>  		if (vma->vm_userfaultfd_ctx.ctx == ctx &&
> -		    vma_test_all_mask(vma, vma_flags))
> +		    (vma->vm_flags & __VM_UFFD_FLAGS) == vm_flags)

Would be better not to regress to the legacy API. I realise we don't use it for
backported fixes in general, but this patch obviously won't apply to older
versions anyway, so we should use the correct API now, and this for older
versions.

I'll add a better predicate probably to do this in one go, but for the fix,
I put the correct patch below.


>  			goto skip;
>
>  		/*
>
> --
> Gregory Price <gourry@gourry.net>

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 777bf122d32a..c71cb9179913 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2288,6 +2288,9 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 		prev = vma;

 	for_each_vma_range(vmi, vma, end) {
+		const vma_flags_t curr_vma_flags =
+			vma_flags_and_mask(&vma->flags, __VMA_UFFD_FLAGS);
+
 		cond_resched();

 		VM_WARN_ON_ONCE(!vma_can_userfault(vma, vm_flags, wp_async));
@@ -2300,7 +2303,7 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 		 * userfaultfd and with the right tracking mode too.
 		 */
 		if (vma->vm_userfaultfd_ctx.ctx == ctx &&
-		    vma_test_all_mask(vma, vma_flags))
+		    vma_flags_same_pair(&curr_vma_flags, &vma_flags))
 			goto skip;

 		/*

--
Cheers, Lorenzo

