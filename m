Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C27BCA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 23:07:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD0E26B0088; Mon, 12 Oct 2026 19:07:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C82016B008A; Mon, 12 Oct 2026 19:07:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9AE76B008C; Mon, 12 Oct 2026 19:07:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8468A6B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 19:07:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D7AD1140D34
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 23:07:53 +0000 (UTC)
X-FDA: 85315513626.01.1124591
Received: from mta0.migadu.com (out-129.mta0.migadu.com [91.218.175.129])
	by imf02.hostedemail.com (Postfix) with ESMTP id B801280008
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 23:07:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pxFBSrfj;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.129 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791846472;
	b=38WD+wXP9UNwC99SY88ZO9EMzu+p7B9FMSEEdcSOdvkxXdCQQ0Gx4soX/b68BUeBsGUwgQ
	wYPAEFQ8BzFtapDieSqDBNN9SevgSATQdcMenWM1cY3M9NxFBYLC8hK5S+RsfyYSzgzJmD
	vGS/3/TFdXM2qJK4ILWctmIIq7mM7HE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pxFBSrfj;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.129 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791846472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tXrMZYy+NaDEKUB9o3g2u6DruTd0QCFKYsobZ50HuG8=;
	b=g4KSFMFwqQfqJwbDSsqxc+HkaGqqPWe66njHUsdB9YFMdZ2ZdetljUF/EK1tSWy7ZNXDXL
	2SE4XpI2J91H3XhZtyHo3TTeTRlaBOWsI8Lq6kUjcWMt3AN5d7u9ksesuDoBFmrYrngjhF
	l2T9KwzI5abikvy3WSFm8YX9cLXQd6g=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4d9rOcjLsImPuDW5V2enOqFBvzCKpQlzawzMGLQRTGI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791846470; v=1; x=1792451270;
 b=pxFBSrfjjBS9dfF5e0L3BcLy0eStex7t480YvgeyFsn74xV0swFHsWQG2S498o22hkU4eJbQ
 iJNfKPf3+EXTHwAMaGOZViF7TZEMuuQmIeCIVfoOgBZc8K4LN206EHRT2/PxXXzdZCbVgyvaXq8
 RBGpS1jsq7porV8WNExn/Wnk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 235e8c915f036f3a;
	Mon, 12 Oct 2026 23:07:49 +0000
X-Mizu-Trace-ID: 235e8c915f036f3a
X-Migadu-Flow: FLOW_OUT
Date: Mon, 12 Oct 2026 16:07:44 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Peizhe Liu <peizheliu@utexas.edu>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Kevin Tian <kevin.tian@intel.com>, 
	Jean-Philippe Brucker <jpb@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, iommu@lists.linux.dev, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu/sva: Charge IOPF allocations to the faulting mm's
 memcg
Message-ID: <as1nxRIXe3-Ktfnp@linux.dev>
References: <20261012200823.699316-1-peizheliu@utexas.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012200823.699316-1-peizheliu@utexas.edu>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B801280008
X-Rspam-User: 
X-Stat-Signature: o5hiajrwxfzn8goozec64yut6p4rhb3n
X-HE-Tag: 1791846471-668011
X-HE-Meta: U2FsdGVkX1+6r8V10fJN+0nDivcPT21uEDKRiZTw+a/g6xommcntIUfmq3I9P7AArboMmgu8Sfh1iWWheiBSWd3bqayG5T/KQIF3OY8qgLyugq6LhBPRp1zJzRYtxYDJhpKQE8rCNEVdCUE+XRsxLolwELQPgeuKMAlonUQVFbVGoZ9rixAS/Cj+jc9K3Ly3VUCoe9wcPQkCatS9UybkEkSYjRHsZ+gmM36xd3ge8qr0RseA6Wv7v16478l6Q4rDISKiPnHt8qt+5L2uxE2l86otVZQvVRrSLhBASbn9Va1Dtu/eSKU+gzTwsd7h8KTZCEXyJKa/dceHgknyFRVe2BraZY1aZnviOT955y1D1cidbtmStZ0+2WegZj7xhw8ISRxEmsYn/nZETS4oJR1hZ7c6U9nuKdF/m31boxxZdLhiY7dpuc1N+7pfX768ZEQQEFUSTQwgfddxvVwCUBqXTxI2CXsrmLjHw6dL4q1VFPNV32Bjc4sHDPvMMl2MbyYNqMIp7G5RNqrtiU73v233aNmP1KISTai3DExPTf9OUNFDIxFrOHGQgQDDZ2fczOGFCpOiFjCOzZPGjkQUWaG3eqVPTFYtqrQN4VR/PaTgOxkrso9KnTRYqYjRAXj/kkXeawCjDvFnZ5Rehni14yAavHJLAVIk3d/g728jo22iFep/KZSXtio4lE9Qqw45+S5L7w3NFpFECFMVeDYJW/6QHevnqbUH3/jlCWqNzqUIjx1locUC8lMGWs6EMsBx6zTjjj/T7rFY2MOliNiGhOPfk5y95vsL4pqagdRUBLM40LTjv0EIbhfol7vqU88i2/H37udiRfbjqcMEmk74p/htatrXrJ1Q9ipWMhfMWHRSLa9JoBgsSHpcGWfxWFhRE3rLvJk4nwAYqnrIv0wuUd4SPPAlGF4AKk4mlYy9mRXxoZ/zWK95irRIYrm40gTS2sD5yB2QxaBFMTv7UCRBxrR
 ira3dGb5
 vKT/ZgdlenAKdKKXn2CJi92YvGcMqRgJgD7LvfWSpxVld6/qlSzqPNftSiWatlIAbx00KI8vam7m756fNoCfHobEvSjjqRwSG+oCtwTXQRdn6Ncx6q6m/vvLruPCe/NpVxWA1kJ86YDv+HCcQRnKkp6Qy2ORQ1sRJVQKpP33lGDjBcHZj93PvNWH999g6tgrrRM8dHzqua1MNWUK5AH0IFY+7+GQG5GBTB/3bfBvXbIVJ38OOW6Qn+RvLRbRnwQxWjJz75J3es3+LNrj5ykxm4OSaiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 03:08:23PM -0500, Peizhe Liu wrote:
> iommu_sva_handle_mm() runs from the IOPF workqueue and calls
> handle_mm_fault() for the faulting mm, but does not set the active
> memcg. File-backed faults can allocate page cache through
> mem_cgroup_charge(folio, NULL, gfp), which falls back to the root memcg
> when the worker has neither an active memcg nor a current->mm. Page
> cache faulted in by a device is therefore charged to root and escapes
> the task's memory.max.
> 
> Set the active memcg to the one associated with the faulting mm while
> handling the fault, and restore the previous value afterwards.
> 
> Fixes: fc36479db74e ("iommu: Add a page fault handler")
> Signed-off-by: Peizhe Liu <peizheliu@utexas.edu>

This looks fine from memcg perspective.

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

