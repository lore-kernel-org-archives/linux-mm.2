Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27E63F99C73
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 12:27:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E5D06B02B3; Sat, 18 Apr 2026 08:27:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BD736B02B4; Sat, 18 Apr 2026 08:27:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D3CC6B02B5; Sat, 18 Apr 2026 08:27:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 27F0A6B02B3
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 08:27:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AB83CC1F0F
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 12:27:29 +0000 (UTC)
X-FDA: 84671602218.27.80A7A4A
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf25.hostedemail.com (Postfix) with ESMTP id EBB01A0004
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 12:27:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776515248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AHSunHiaH2wyyOgKq5tcPEEZr/Dbmlo6IUL+Ik2pKzM=;
	b=0z5ijbf8RYUd/CWRIKMmYEE8ixcK7BqHFiOmJFveGKsuaZhWb5Z0dUNChWrY2Ja/dd+p9K
	krCiUxpUziv8tFXTOG78V9fFQeNoft1GiOwp5uQ5arggAYWTn9Hp8Ux6iFqWKN5wW0ycnk
	mw4OPNIB9VlrG7LZWc6mGcrQrMc0o7E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776515248; a=rsa-sha256;
	cv=none;
	b=oM0NXj2JkvPVuCC2qFcbQC6nBW3Dlp+A71UKt9ex5aER2gXQYJKegHSjrnYZkIJlQU1P0W
	thG9SkzjFJUyd2IdPRsU8EMX/t21UbCX6ySNwiH1Kz+Vwg+pkfOGhPMEBTbvTF7GZ29KZ7
	QGfds7iKPJ1pWJ+HQpfP7x7fDRQGNVo=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 18 Apr 2026 21:27:23 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Sat, 18 Apr 2026 21:27:23 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, Yosry Ahmed <yosry@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>, Michal Hocko <mhocko@suse.com>,
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH v2 11/11] mm, swap: merge zeromap into swap table
Message-ID: <aeN4qzqfyFpWJXYZ@yjaykim-PowerEdge-T330>
References: <20260417-swap-table-p4-v2-0-17f5d1015428@tencent.com>
 <20260417-swap-table-p4-v2-11-17f5d1015428@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260417-swap-table-p4-v2-11-17f5d1015428@tencent.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EBB01A0004
X-Stat-Signature: ssnu6afnnfn3qta46y1ttf3aj9wn3uak
X-Rspam-User: 
X-HE-Tag: 1776515246-580
X-HE-Meta: U2FsdGVkX1/PbuvxrAdAB12YeHR017O8+YCzS/fasT3pjOFOQH4aDJby5hpyH7Dv3QhSV9pd8SI0CQ2KuBGUBM3Oe2ghQZJp8j3u5Zh0ZEwKHH27erSNi7OOgK/xqQkqxAelJ04XXxZHrKDEH3GODY76D/IsBhJjE4HmArzAM3m/R9Epz1nK/CMbOHeYcCWbbKFQf+nTp5oVM+2r8cBvxlrYdHoRG3kj2/Te/jKHYAW4gl9yD/Zw5XU3/4TmtVR5985/ELIoKA4TjM8MGEL0lgwmy5U3H9j3czzPLdbNQZjYkHSIW1tRBkzvo7FbKBaFQWJZLRsTD7EWbC2w04pEEsAamCXto/Vq0TAHwCVKvNsptEr/TJKTb2hNl2xa6bE+Gz+WRm8u6Wb9HGP/mUJwDWSyrIWHin6ED5Inqe7M4tHfayLc39NvgaNnlbD48qoCUNT/s7ZgBrWKZutv4CUCMbj5eDdF3qqpoHJwN3xY99KVK7FAjkBQYXDyq61mQrLnxN57IRA+Bmyi0pHIz6DynlzajT4YMFcN79yQ1qaAlbSf0KKEhRNM/8fyegsY+KdhLaffJ+I7ObIPZruOsTQWWbOFLehjlM3261sadtbbFTx++TNIaauMvh7Vn719UEYB3pkBCBozWF4XK779Bdx5f5lv+CQCku3EH1VTJzr+xy65DzUpmxfWPwC0KEyhpQahivwL54eMmLjYtMziIwewYcdkBZFq+XISsD/K0JWU/xgfQ3GJwXphlxIi4BCe6K7T3DlthvECCXwGTTOVoyj+NPiXeX/VbSWHZlwv8vsa9T6Z+QCrhzbaebx9APQJVLUtoEc1NiYcEToIACaEpn3E6NllWjpmo06dtTAhinYTW/t2E+tnkSuH91BCAO62VwPhRNtFWgybeCNqf5dqs+bXlu+iX2jkeObRLt5ojscVM1wQLIfJKR6Bd/LfETcN1JcUZ1MsCdSutszU8P97v1c
 1LpafDcO
 zX6qeVk1RbDvHUKdrsnNhERDoWpROYSgc2Gqnw3OLClnRoKspCsoIjNXZ9F8OhvtKwMak9La77Ppso4LBhUQaz+zpNVVDzJ1FKlCJsqN/NHA6BS4l8l5vB3xqO+rl+4mEf8ZwtFrIqHqqEAH11VxJm47ufNpUlABVFRZqYIBedIgTG7hh6Rbi1fqDS7j2F1yiEXEqZW+P+tMcEgMwl2gj5r0UFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 17, 2026 at 02:34:41AM +0800, Kairui Song via B4 Relay wrote:

>   *
>   * Usages:
>   *
> @@ -74,17 +76,22 @@ struct swap_memcg_table {
>  #define SWP_TB_PFN_MARK_BITS	2
>  #define SWP_TB_PFN_MARK_MASK	(BIT(SWP_TB_PFN_MARK_BITS) - 1)
>  
> -/* SWAP_COUNT part for PFN or shadow, the width can be shrunk or extended */
> -#define SWP_TB_COUNT_BITS      min(4, BITS_PER_LONG - SWP_TB_PFN_BITS)
> +/* SWAP_COUNT and flags for PFN or shadow, width can be shrunk or extended */
> +#define SWP_TB_FLAGS_BITS	min(5, BITS_PER_LONG - SWP_TB_PFN_BITS)
> +#define SWP_TB_COUNT_BITS	(SWP_TB_FLAGS_BITS - 1)

Hi Kairui :)

Would this break the build on 32-bit arches with 40-bit phys
addrs (MAX_POSSIBLE_PHYSMEM_BITS = 40)?

Architectures I checked.
  - ARM LPAE   (CONFIG_ARM_LPAE=y)
  - ARC PAE40  (CONFIG_ARC_HAS_PAE40=y)
  - MIPS XPA   (CONFIG_XPA=y)

Calculations.

  SWP_TB_PFN_BITS   = 28 + 2 = 30
  SWP_TB_FLAGS_BITS = min(5, 32 - 30) = 2
  SWP_TB_COUNT_BITS = 2 - 1 = 1

The BUILD_BUG_ON looks like the real problem. it needs at
least 3 count values (free/used/overflow).

  BUILD_BUG_ON(SWP_TB_COUNT_MAX < 2 || SWP_TB_COUNT_BITS < 2);

Confirmed with a cross build (multi_v7_defconfig + lpae.config).

  error: BUILD_BUG_ON failed: SWP_TB_COUNT_MAX < 2 || SWP_TB_COUNT_BITS < 2
    at __count_to_swp_tb (mm/swap_table.h:227)

I think the right fix is widening swap_tb to 64 bits
unconditionally (atomic64_t).

(Or, uglier, these arches could always route counts through the
extend table.)

Best regards,
Youngjun Park

