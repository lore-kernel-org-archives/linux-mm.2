Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC7E2C87FD2
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 22:42:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CFBD6B007B; Thu, 31 Jul 2025 18:42:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 482696B0089; Thu, 31 Jul 2025 18:42:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 396B76B008A; Thu, 31 Jul 2025 18:42:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 23EC36B007B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 18:42:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C404FC098D
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 22:42:01 +0000 (UTC)
X-FDA: 83726034042.12.CEDEE99
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 01A0B1A0006
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 22:41:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qdkKqmjm;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754001720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6JU6ErdyoxvaosduHZiX5FtqAgqZCbLAXCMaW7QjJoM=;
	b=Ka5jYCT/6mICtxLWaTRFxwA7R+DcTmu/jtzu7m8lZefX02qUYIFsbyO/hOX69ERUjelHWW
	+WalrWxZyRsj8R0YfYVEOuRJkJ1a1KTJ7Uhsgi3Jok0UiQpeqGcBCGU9e2yfiE3BUHWiTJ
	4M0xZInnu320s2oPhxbXHmC5x7uYPI8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qdkKqmjm;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754001720; a=rsa-sha256;
	cv=none;
	b=DfCE7dfpPawnRL/jgSfNybz3/Gki+xCW7501uviAoPMGEW1hZIak+MPyG3fsMAQzLHXSu5
	fiKcwBTN1LIxXB77TjAUz07wPI5PVBy2L6xVisZbaxuO8/vFM+7zKas1v6PE7BqR4LCCeh
	FNxwK4+DFV4+CCNWl/e32N66FkP8qRM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C5AAC41758;
	Thu, 31 Jul 2025 22:41:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D68BC4CEEF;
	Thu, 31 Jul 2025 22:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754001718;
	bh=NX3VDwS2KlMRe0hwzmcACuSTvo8Y4CFQGjFkgf0LbB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qdkKqmjmcmujLYDVA5N7mG/bn/cMLxTSmWjFuCttZmMsEQRupy82AlwKaJq3+KwEw
	 k/ROFw7V5Dkrusts59WmZt321IrJwdzsGdwY5g1Bv/Aovc4CG1IrKMztyydubQEPev
	 VPGUPCMBIT65IWwB6Nb4V9kJ0q4vJJCsG2U7ck2GU0qOyYhQVyZkurTVQLAz5FgVSj
	 GDn6gDB1PitRorEcCfea5Q77DucDNa3SsZAttjWsBrzC5l/FBHpgK281t/sIYdux6M
	 p/xFQhB2r8cJCagWBny6OmwjOxcnajRn9G38Q7Bgj0PtgXm/8PWl9MLZAa5YfCyiEq
	 A50uiISpybLtg==
From: SeongJae Park <sj@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Alistair Popple <apopple@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mempolicy: Clarify what zone reclaim means
Date: Thu, 31 Jul 2025 15:41:55 -0700
Message-Id: <20250731224155.1646-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250731210738.1451854-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 41aif4ddaqgpg3fi3mxqg4kuez3e4pm1
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 01A0B1A0006
X-Rspam-User: 
X-HE-Tag: 1754001719-536456
X-HE-Meta: U2FsdGVkX1/99epr2tLT3xdo3bEmx+SgKSPJjBZZ539Zc0GyM6tKoymlv4ERL+ze9MtcSC8ViTUlI6wtyuoXJfojCmYMWLFN82qhb0Oz35PP3TQJ7ePom8UzLB3bIRF9biniPvmTHcXNcPAKmrJw6Wm/GLBSgSqjYutmWn8quiF0D9mE/MnXPCCFo4PZQpMZtRlKpFhSHvks7/C/XdJwyTOrNCNuyAEXwUEgzXAMK71tBBYf6RWeP1v/OF/1cwsz1SaY82ROXwvkOiQw2zURHK1TmyuQsI47w4jVizs27EqU5RVGSGDiULpONBrB9XTVLgD9NHALAHPSoRNN57TSYAr2hfLZmG7lU7AS3B28AV9QyvZmIDcSLQU5/hSOkTmX+DW/fLGOnUVQH+MSaYeaFVjXYpZyII0JXU9iTQG5pzYhD6SaQFio/RUHh43MgorAa3WHQUWqs/eGY/Lw+qjOA9ZYmNUhy8MPYPVI3DaX3BsXyRK9DV7c5Fb0y8fDifZ/varoYawxqcfCRIfFob1iAHEywJFtMAdjs+HMtlfATXwPn3CinkdLGsVq4m1FZnUMs8ywwi7/d7r+rrDDFNeiKiP0TbvXxtlmzQGx1TJxnUGHS2789hlE85Cxh6eYgy2v/A+U54aa/5Js1+SbiN2V5HE0xswQVoijarOWekwynsWblzjxlEu3NpgSS+jkAxkFxwQHHumT0JVj7q00ZqT6Wv2giQFfjKU3W6bHaX2yZxB/3J7V6FyKJd52NJDLhZ/8PYzb9YDLuHNcFV3TWxuCpWFtnMuHsVqTStd9ccqcqIWmOX2wah26XGjZUi5Bt3Wz3YfChmoT8Yt707G8Z+FaWCPg1wMFB0HxjtdlIYForvCq3kyYOdAz28EqXsrFE+luMR5YBfFOukI5Cf4wMTefXNKaMQrD/Mnf/71jMSHt6c3M3g5dK+kOFSZCqOeix7pvLBTXAkGqC798ZF6u82r
 7G48Ur1u
 uQa7Qn3DEt7/SCO8bBSRV+Zjc5Qpc+S0UxVugUvCPT7lomjs2sLPjidmIXtzpa5Ic/nP6Q0JIxd6bIN/t/K3urvG/EoIb3Ehg4F05oXSvonRd/D0NeFmHrvrGaoGBziomfe0pY+QAY7FkLAR/YXTyHcElNP2kMmEYe2Yn2Sqniagk3ftNHqfUkVrc+pFb/99Unyqsjji8Ao1i5+gAibKeS6xmQeC4QwDFN5jCZo27q/BvaAQAV/mB+9di829gdUgJPg4jGf4h33J9I6O3R66/w7CCgtyHrS3yYv4Q5mW4yr+qcXL+jW9dAfnSzfg9cDuDiPOeNhZTwx0sHVJXgmOlLdW6hKPtF1CdXSoJ4ASUjdgF8mBfRz4tvEUPdQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 31 Jul 2025 14:07:37 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> The zone_reclaim_mode API controls the reclaim behavior when a node runs out of
> memory. Contrary to its user-facing name, it is internally referred to as
> "node_reclaim_mode".
> 
> This can be confusing. But because we cannot change the name of the API since
> it has been in place since at least 2.6, let's try to be more explicit about
> what the behavior of this API is. 
> 
> Change the description to clarify what zone reclaim entails, and be explicit
> about the RECLAIM_ZONE bit, whose purpose has led to some confusion in the
> past already [1] [2].
> 
> [1] https://lore.kernel.org/linux-mm/1579005573-58923-1-git-send-email-alex.shi@linux.alibaba.com/
> [2] https://lore.kernel.org/linux-mm/20200626003459.D8E015CA@viggo.jf.intel.com/
> 
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  include/uapi/linux/mempolicy.h | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
> index 1f9bb10d1a47..6c9c9385ff89 100644
> --- a/include/uapi/linux/mempolicy.h
> +++ b/include/uapi/linux/mempolicy.h
> @@ -66,10 +66,16 @@ enum {
>  #define MPOL_F_MORON	(1 << 4) /* Migrate On protnone Reference On Node */
>  
>  /*
> + * Enabling zone reclaim means the page allocator will attempt to fulfill
> + * the allocation request on the current node by triggering reclaim and
> + * trying to shrink the current node.
> + * Fallback allocations on the next candidates in the zonelist are considered
> + * zone when reclaim fails to free up enough memory in the current node/zone.

s/zone when reclaim fails/when reclaim fails/ ?

> + *
>   * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
>   * ABI.  New bits are OK, but existing bits can never change.
>   */
> -#define RECLAIM_ZONE	(1<<0)	/* Run shrink_inactive_list on the zone */
> +#define RECLAIM_ZONE	(1<<0)	/* Enable zone reclaim */
>  #define RECLAIM_WRITE	(1<<1)	/* Writeout pages during reclaim */
>  #define RECLAIM_UNMAP	(1<<2)	/* Unmap pages during reclaim */
>  
> 
> base-commit: 260f6f4fda93c8485c8037865c941b42b9cba5d2
> -- 
> 2.47.3
> 

Other than the above trivial thing,

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

