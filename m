Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAFB4CD5BAF
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 01:52:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17CBF6B0093; Thu, 21 May 2026 21:52:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12D4B6B0095; Thu, 21 May 2026 21:52:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0440F6B0096; Thu, 21 May 2026 21:52:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E7F056B0093
	for <linux-mm@kvack.org>; Thu, 21 May 2026 21:52:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8C54B40967
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:52:08 +0000 (UTC)
X-FDA: 84793380336.03.9DFFCFF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id C58281C0009
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:52:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=L2Lh02D+;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779414726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dyfcsiq/DCFXpxq5yQbpU2tFM6IQFzSOs7Lzid8qTR0=;
	b=nN03JdaRl8DCxl/vbJ1LzWtQzLVwl0KSDDjxSu26vP0duhn8orpUSGj8BHGPa611s1WfxV
	8GuME65hT4yAqtshX4svqB8cgGDAcpjwAxfP1HcpSV3pBI+5hvgxvMl6RuoGswVB+COZNA
	Ze/wbbsB46mRsk/X7kLcO8EDeJMypeA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=L2Lh02D+;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779414726; a=rsa-sha256;
	cv=none;
	b=OywiIYAfKTRWX4r+5h8tXM1p+5LuU+LmaIs7G05mVNvbMP2tZ44EU/IuxT+U50Ji40ENX1
	piL9sRCJXDppcgAb+p+H31eEjQl0UgNzpKkC/pE41a1XY5dQHZanrrVKp/F91YzuukWFJc
	oiVABeU4pv2+mXLBHmXuneKdLggqFHk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 14BAD60136;
	Fri, 22 May 2026 01:52:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A231F000E9;
	Fri, 22 May 2026 01:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779414725;
	bh=Dyfcsiq/DCFXpxq5yQbpU2tFM6IQFzSOs7Lzid8qTR0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=L2Lh02D+6lZ2EjThkr03oBOiuaO2ST3bKnMDgaqAUoV/V2ap+v5QhU49hIhzv5YIE
	 gTokUqnQb/0UGvN0asj/Aj/ZZ59YyBasIyRUxsL411orhSXQfXKpZzsnowk71dcsFi
	 3GWv1UkjvYatzyEj33JPVZk6lMsmZ6JMfSgH/lTU=
Date: Thu, 21 May 2026 18:52:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kasong@tencent.com
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>,
 linux-mm@kvack.org, David Hildenbrand <david@kernel.org>, Zi Yan
 <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song
 <baohua@kernel.org>, Hugh Dickins <hughd@google.com>, Chris Li
 <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham
 <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>, Chengming Zhou
 <chengming.zhou@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>, Yosry Ahmed
 <yosry@kernel.org>, Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH v5 12/12] mm, swap: merge zeromap into swap table
Message-Id: <20260521185204.a109bfcd1e0e8f52135c5ed5@linux-foundation.org>
In-Reply-To: <20260517-swap-table-p4-v5-12-88ae43e064c7@tencent.com>
References: <20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com>
	<20260517-swap-table-p4-v5-12-88ae43e064c7@tencent.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: e4qbw59rk91ojk5nohsiej637gugy4fe
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C58281C0009
X-Rspam-User: 
X-HE-Tag: 1779414726-434931
X-HE-Meta: U2FsdGVkX1++Uc7pUdOb2SUnxxZ+e8v12bqliA9mRdooc1qOO6vCow8k1f8M8+lZ4pi1l31Z++F1k7Dc4Gh6P/m/72bEK4YPQq3khqdh+Q3xyZMfykPdd6HzaoSoK5e5wWh2dAJeiuH2kFwBUc23D5sLuX5diRmEi5ysX3L1WVvJzRI3bveCbqzWhsYx7DX7xOpaN8LVRJXaLBDJJWm0bgE+Fp1ytzllF2DdYqyJnEN+PKltLP2rYQRQM6ynUY7L7LzE6Rkxs3zaY9sMqtVRkiTlSXDWpSxk/nrGJ2TsPeIfQW+G8dveCyke6DcEgLOkL5NXN12xi4eUg9KcXZHLIc5BXRQIBD8lgpn/OWGZOTX0huMRJamthIdvf1Yc4ADV22woPioPMSrjZ90xnNquuY6ukpK2h02+Pl6T/cSABVZXn4e6qPfgDeyTS9clnIjy2qL7j/sZsVEjblhM6fw4GTMQ1yBZcNF9AVsjMq+IzSbsl5RRpe3qEsgH7R8NzoOIWJ6AAHorcTaSW3FuOkm48Id+eTYlOUFkRoBv0xIxAIMdDYe5GxWMX8kJotra9dVSyL1tldplKMXosEvobRgKhZBz3sdb7Om4eDSdKa6dcpCHGkTrU1IQRo5OsdFP0P4+A7M/ABEIdj1o9Vdvr8F4JIJaFKjY5r+6l9Tk+XDtnf1O+1vmDi2WC3mUs1LVcc0y9n0XBKSZIioaIMZVgEhuVTIM/cKu2sUHFsCW/R/iQxAU0M0AvoxIBNyHWCEXMWrHyEMaGo/nP6ffAn/XVJzgD9uG2dSK3RLA7sHqfTDF0+3QLu+XkMlt9xKrSfL99WXG0iX8aWxnB61rTrd097psie+r3wHxRoOz+DZ/lD6db+5Nogp5Itsnpyk17E9Nc0F6b7a3F37g+ek5IsID/gAVHsXtT8G/GmgeKeHCXi7QbOuYZRptY1SHio00k/ALzPxzU06hbXdTRgLNHVzFOrE
 PGU8ZUan
 IMM2sLoQfCGgsH47peFDCn0GnG/1hQRWpZocgVN9j76RRdVT5dlQpNm2HCTp0D51dCHt7v86A/ly7ob5BO4flOxQMPqB8Yd2P3QMN7M/R+sPHKhPSrJz0A3ea41kcoozXa/cfuSc13y3VdsdePsXgyO0QJLY7poXoJUxXh4lF5uJyn+9BUFBe2c9XTo+gBPJUlSqmcVf07KDhbHgkqeLVx8yRBdnt6y57W6idAdd4DhG4Dye2yws0cz9+bO7V0orIgV/psJQbjrLwHZsMEXs2cAhvktij0OuikyhHYzD8HSvHxiN58fc1HwPtEH5jL2IJ+4rwl0RITxnZOmsZYvlB/zD4uL31o/JfaVCbo/0sQe1Wj41QZOteZLD7EnnWQESCG68PNYSOb+14G1mVdneOfj5lZBd49x+GxYLC01155CU7ByenNmugZK5vC7N4nHhbR4gWDbRPZjDVRzVuKxo/DX7CZWbZf9xp+owim1m4dbOdGqghzZ6BrWNJ9G3kCfYK1wVeu+OBK8N9p/TGFWaGqcryk+RTaRNOnXrtMZSpPsg+6rYqAa05ZcTqu4eOxai+PkP/C4ReTOityATgv39gBEOQ9aaXtoYiV2x534+WuGQ4EFKu4kAMx/laSWg1S5CSHEjZndcjdHJZhE9l12fvBnlS+P9gTqjENLbVyzDvfCaV9vw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 17 May 2026 23:39:51 +0800 Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> wrote:

> From: Kairui Song <kasong@tencent.com>
> 
> By allocating one additional bit in the swap table entry's flags field
> alongside the count, we can store the zeromap inline
> 
> For 64 bit systems, zeromap will store in the swap table, avoiding zeromap
> allocation. It reduces the allocated memory. That is the happy path.
> 
> For certain 32-bit archs, there might not be enough bits in the swap
> table to contain both PFN and flags. Therefore, conditionally let each
> cluster have a zeromap field at build time, and use that instead.
> If the swapfile cluster is not fully used, it will still save memory for
> zeromap. The empty cluster does not allocate a zeromap. In the worst case,
> all cluster are fully populated. We will use memory similar to the
> previous zeromap implementation.
> 
> A few macros were moved to different headers for build time struct
> definition.
> 
> ...
>
> @@ -469,13 +474,21 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
>  		VM_WARN_ON_ONCE(ci->memcg_table);
>  		ci->memcg_table = kzalloc_obj(*ci->memcg_table, gfp);
>  		if (!ci->memcg_table)
> -			ret = -ENOMEM;
> +			goto err_free;
>  	}
>  #endif
> -	if (ret)
> -		swap_cluster_free_table(ci);
>  
> -	return ret;
> +#if !SWAP_TABLE_HAS_ZEROFLAG
> +	VM_WARN_ON_ONCE(ci->zero_bitmap);
> +	ci->zero_bitmap = bitmap_zalloc(SWAPFILE_CLUSTER, gfp);
> +	if (!ci->zero_bitmap)
> +		goto err_free;
> +#endif
> +	return 0;
> +
> +err_free:
> +	swap_cluster_free_table(ci);
> +	return -ENOMEM;
>  }

My m68k defconfig warned.  I'll do the below, which looks good enough. 
Please check.

Perhaps a custom guard() handler would clean things up here.


From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-swap-merge-zeromap-into-swap-table-fix-2
Date: Thu May 21 06:39:20 PM PDT 2026

mm/swapfile.c: In function 'swap_cluster_alloc_table':
mm/swapfile.c:488:1: warning: label 'err_free' defined but not used [-Wunused-label]
  488 | err_free:
      | ^~~~~~~~

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/swapfile.c~mm-swap-merge-zeromap-into-swap-table-fix-2
+++ a/mm/swapfile.c
@@ -472,22 +472,22 @@ static int swap_cluster_alloc_table(stru
 	if (!mem_cgroup_disabled()) {
 		VM_WARN_ON_ONCE(ci->memcg_table);
 		ci->memcg_table = kzalloc_obj(*ci->memcg_table, gfp);
-		if (!ci->memcg_table)
-			goto err_free;
+		if (!ci->memcg_table) {
+			swap_cluster_free_table(ci);
+			return -ENOMEM;
+		}
 	}
 #endif
 
 #if !SWAP_TABLE_HAS_ZEROFLAG
 	VM_WARN_ON_ONCE(ci->zero_bitmap);
 	ci->zero_bitmap = bitmap_zalloc(SWAPFILE_CLUSTER, gfp);
-	if (!ci->zero_bitmap)
-		goto err_free;
+	if (!ci->zero_bitmap) {
+		swap_cluster_free_table(ci);
+		return -ENOMEM;
+	}
 #endif
 	return 0;
-
-err_free:
-	swap_cluster_free_table(ci);
-	return -ENOMEM;
 }
 
 /*
_


