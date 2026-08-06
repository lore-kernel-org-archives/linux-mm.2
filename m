Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0E4AC55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 07:36:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 081E86B008A; Thu,  6 Aug 2026 03:36:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 033126B0095; Thu,  6 Aug 2026 03:36:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8D3B6B0096; Thu,  6 Aug 2026 03:36:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD0A46B008A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:36:50 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 50F2D40697
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:36:50 +0000 (UTC)
X-FDA: 85070037780.19.804B02E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id A4B1C80008
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:36:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lJ54ZhiM;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786001807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/EuPo9BzIEL6TJajvnJfARgjYIOaagoJUP61Dbwv87M=;
	b=zpYkD0giiaOny4l3yCcyYJZngGyiCwK2fXKkWdOOYEVZqyWTNf5JQ5R7zJsr/+hSBYkXWi
	2Uuv6BsKqPibE/jWQhpzGW37mCzd/w1IaR90DFL4KXcf4c6ceEFPLWuZPqJXz0ojE00k2D
	RT8WVB9Nj63FnREDgd6vrKWJfOEAGh8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786001807;
	b=qGXdW55AMN04/EZpU8dm5+KOyP9jattYKM/1EVC0BtcyhmWAbAkYi+xjeBqYl7xH7rpzNS
	WnKLgwpTab4sUjRY+1GZE5bTU61oVnb1V8F6liQI+Ta9X2D2ihigZ8kGV0rNrJRW3UWDCd
	G95In1sB7n34ONDNJUAx7kZt9E9Kroc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lJ54ZhiM;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2386760AAA;
	Thu,  6 Aug 2026 07:36:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020EB1F000E9;
	Thu,  6 Aug 2026 07:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786001806;
	bh=/EuPo9BzIEL6TJajvnJfARgjYIOaagoJUP61Dbwv87M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lJ54ZhiMKhc6tjFw/KwXQsf5FGPpccVt1yOddsanx6fYsuSs5s2+hKeUNKh/AgG4K
	 7lhUsuusNo0G7A4IVB7HcDvezwxzUzpt3dMFtVz+00yo2Njdd4mWcVqh8TPq6UKSj1
	 aeZodgEOPTCUnTG4edDpDW8vzGSY6mmg7LhF3onuBpR08IXwV2ODh3ScMDmc/4EtU/
	 cOLotw59yf6tRtPVf1CMYSHKlOaGymL5pYIdxLzugvFTSUeq3fwdb4eXctuow/JCdI
	 8uD7KEhr/ckwLiRZbXuHuduO2RTX8dAgceMszMEByBooocT3T+n7iKC8/yGwN22qkv
	 dO4ZgD7sSynqQ==
Date: Thu, 6 Aug 2026 08:36:29 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: =?utf-8?B?5p2O5L2R6bi/?= <dayou5941@163.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	linux-mm@kvack.org, Li Youhong <liyouhong@kylinos.cn>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [PATCH] mm/huge_memory: add VM_WARN_ON_ONCE_FOLIO() in
 min_order_for_split()
Message-ID: <anQ5QyzLCdXxlEOE@lucifer>
References: <20260806032116.681060-1-dayou5941@163.com>
 <anQqEfCEbWmm5vX8@lucifer>
 <17316ab0.5714.19fd5fef275.Coremail.dayou5941@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <17316ab0.5714.19fd5fef275.Coremail.dayou5941@163.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A4B1C80008
X-Stat-Signature: fnsdfacjsabkeopw5bpa97dtppf71kdw
X-Rspam-User: 
X-HE-Tag: 1786001807-91432
X-HE-Meta: U2FsdGVkX18nNMIwkHERzYf9FbeBgtZgZR56G4Sf+fZrFQjCt2nHSniWcKcouloXOCEtdGuvRa2enyg+sbGdDvr6SBgtYWE0lhvUVTSlJxwalQ759u17GnDNJsYZX7pr2GNptq+/7ZdjnKoMvqxCS3smtRdyKiXgey4p8QDJN+zvGePlbQcvbSV2wVMzoIbMy+lD+cVZLfdxtkMdHnEqRJ4KeRk6XPfMHFOBaWsEENarlBd7WZY5Dx8HKN53BVfM2ZUV195ppb4PMbnBVLMxQjmMm1xWpi+saM0dnO2hjcVsWjMaZUElK6heXbeumkNpUvowFa8Ck3LA28fFhgtJITKfnDG+hBDputLvv9ujQ+81bFwLLBlwx3k9nAM8BN1giq95Dpwj9QCrbrnWaARxbCRC5P0r6JXpGFR6gsF6Q9XGRjLHIZzqpd8XRn6vPdfofob53y2AonlhaZiGzyPZgsh/qB6KgjuVFZwMxlXZRtIsWdfPpWWud9nMYMcg+z/Y9y6HzkS2ndpMYoX+EomtuJv09OdAXQZJWKek5+zfX2DmB/RWWv1azg/TMarK+KCk51O0RVMpPJjLyoj2YiDPGfEPJJ/7NSbJsWXncfFdVRov918eKYkL+nDFty7zn6q+B1RsUFCyC5uuiIcxf6eOooIKaDgtOjebCil4DFiUUb6Zt3qk8bdYPxH7Dtelu/RxyqO+nEnC3QYxynz6O1CyiI+9cEmGl1pEbBQELscC0ByX6G3QQ6xn4Tnn4xzW6GustYXb1M7I/j1bv0bRBxs8a8Prd0bn74eO0PbVFPytrAxCtr5jLUqZEowFgONe2VsQd8nqgT+iYtdMMpfVc0hbxWWsXrI4VJt/UDguLIfqr7J6BP0RXvS9MaG/6Qi9UuGGDofaqKTDtGgPA7gVH9lFZNTnOu6QQ5UIPIoqYJG7UO2y+Pq/yPxlDiLg+odFu1/OOODTaLkQc8nQI8SqaAb
 MuEhtSRb
 6Q/pHhN0B8LKPMDeHw5HZcVugs/PCEILU495YSezSvhlrmtc5UAzD4AUCbJAmnzg8HJKtQPnuwAnB2kTVBJzsehncNXT++rWwBTomKys2of6LRUq0ohPOtxoNkdqwW/+Q1NZNoju+K343qJnXbVvykN1bUbb1miXCFLnAbHLEGQQpUIk0vqiJ92wByPgisTnIjyjSAQHTVMFnFJBkO2vZdwntddt81pQ49AGOzFQbiF8jNmayS4O3uB3acfvQRIjnbvFEc2xKQ+5WS/V02GHN4US2YGdFGnsObAF/ZblvlTtlRewIQUkcnmL/RlsIrs2ZPeaX6jzTGaRTgtbK9uAFCVzTMlEKYrjQ2sUz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 03:34:43PM +0800, 李佑鸿  wrote:
> Hi Lorenzo,
> Thank you for your feedback, and I apologize for that.
> You are right — I may have misunderstood what you meant by "separate patch." I thought you wanted it sent as an independent patch, but you clearly meant as part of the same series, placed after the fix patch that makes the warning meaningful.
> I'll resend the full series as a single patchset (v5 1/2 + 2/2):
>
> Patch 1: mm/memory-failure: fix folio refcount leak and locking in
> soft/hard offline
> Patch 2: mm/huge_memory: add VM_WARN_ON_ONCE_FOLIO() in
> min_order_for_split()
>
> The second patch depends on the first, so they must go together as
> you originally requested.
> I'll send this out by tomorrow as you asked. My apologies for the
> noise and the wasted review time.

No I think it's better that we handle this patch, please don't send any more
revisions.

--
Cheers, Lorenzo

