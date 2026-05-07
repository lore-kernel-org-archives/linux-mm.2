Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7F70CD3427
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 11:19:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E83356B0088; Thu,  7 May 2026 07:19:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E34486B008A; Thu,  7 May 2026 07:19:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D49B26B008C; Thu,  7 May 2026 07:19:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C725E6B0088
	for <linux-mm@kvack.org>; Thu,  7 May 2026 07:19:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 71FC11A04B7
	for <linux-mm@kvack.org>; Thu,  7 May 2026 11:19:09 +0000 (UTC)
X-FDA: 84740377218.23.9AD040A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9BA3FC000C
	for <linux-mm@kvack.org>; Thu,  7 May 2026 11:19:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FJmnhhhI;
	spf=pass (imf10.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778152747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hA5PCxb84E2Xtq95oQ8hu6gGczV7TDw0G4pcLQvZIQs=;
	b=ucCfZ2I/rh76+0BAyco/r61McXwWrO1FWLzG3hFzGdRGSacEz73jtabscGdIYk7uXJRkbW
	eXAPNz2vkXYp8P+OIs3XY554vlAS34rWIHQWB3gnELs0l+uHNqxSM7wjdLSAdhFwbxJztX
	j55uob0V8IClgkqjAi2GaT5BS2wnItE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FJmnhhhI;
	spf=pass (imf10.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778152747; a=rsa-sha256;
	cv=none;
	b=ZDg0IkQ5RvOtCq9msuqEjmbnDut+aZkhRMVz/AeFctWhlpZaVH6x/Pq7smAIbS95uIugwY
	UiTIIKmuxozU7NPZTQw/P0cS62pVWwrT00btslsaIBM7xQxotFcyWgy5n0bup8NX5O71ee
	13wN79ib/rrD7fDC6Qbam4TL/TXAEbw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778152746; x=1809688746;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=cRZ8xZxDQBKCBLucxh+QxCSTByF79kLCv2C9OryZKKE=;
  b=FJmnhhhIqE3lWU+n6VJl2T844Ru2TCMTGvFl5b14gRtkfexw/segwQmO
   v2cXcMlZWVyag/iM85xLtgDM1iNrLBjj3gwFAGQuSelaqXvnlB+DP6qnG
   nLjm/596GqO+dsmv+fvlTPoPlsCS/F6IqyWmG/csE6tALFSOmKNuGvBKw
   5jq2H3IMxKhEWFOIUypsc252QfxT5PRfcoTfxEdEZxceQIOY25m7gP9Sz
   b+IV9NDRP3ZcVcPQWtdpkaUxAAlKLaIUl+CJYXn/rMe8Wt2aC2kzJCIhP
   zEj8P5J6o8t0jfljToTw5LS8+9yMySUInbWHiOfBu2z4KavmCFVBNey3F
   w==;
X-CSE-ConnectionGUID: Z0MNiVA1Tk6vjt30INJM/A==
X-CSE-MsgGUID: 2oyAtd+/TdKAkM/xBkOxHg==
X-IronPort-AV: E=McAfee;i="6800,10657,11778"; a="79284818"
X-IronPort-AV: E=Sophos;i="6.23,221,1770624000"; 
   d="scan'208";a="79284818"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2026 04:19:05 -0700
X-CSE-ConnectionGUID: u1EVoKdtTHywPmK01IfJKA==
X-CSE-MsgGUID: 94HmaLugRCGSOTaDfrcreQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,221,1770624000"; 
   d="scan'208";a="235437341"
Received: from klitkey1-mobl1.ger.corp.intel.com (HELO [10.245.245.94]) ([10.245.245.94])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2026 04:18:59 -0700
Message-ID: <334d943c54608568a52409cd342f629bdbdd0e11.camel@linux.intel.com>
Subject: Re: [PATCH v5 4/5] drm/xe: Set TTM device beneficial_order to 9 (2M)
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Matthew Brost <matthew.brost@intel.com>, intel-xe@lists.freedesktop.org,
 	dri-devel@lists.freedesktop.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Chinner	
 <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>, Roman
 Gushchin	 <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett"	 <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport	 <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko	 <mhocko@suse.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Shakeel Butt	 <shakeel.butt@linux.dev>, Kairui Song
 <kasong@tencent.com>, Barry Song	 <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie	 <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, linux-mm@kvack.org, 	linux-kernel@vger.kernel.org,
 Carlos Santa <carlos.santa@intel.com>, Matthew Auld
 <matthew.auld@intel.com>, Andi Shyti <andi.shyti@linux.intel.com>
Date: Thu, 07 May 2026 13:18:56 +0200
In-Reply-To: <20260506033300.3534883-5-matthew.brost@intel.com>
References: <20260506033300.3534883-1-matthew.brost@intel.com>
	 <20260506033300.3534883-5-matthew.brost@intel.com>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Stat-Signature: wyps7ezhurdrcgo6766n3tbp656h1k9j
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9BA3FC000C
X-Rspam-User: 
X-HE-Tag: 1778152746-241032
X-HE-Meta: U2FsdGVkX1/OlQ7pj0N+6hh/5K7KPeEooP4guL5D90+7SJJ+r0wZahrgLYycflcLGw5EojBjaN4L2AQkaggE1uxgXLyz6s/ijZcAbPjkSnWAXtGiC2L81xDt5w8gda46BUgXWLVi0aicMbLm7mlio0/qHTfw+EPjgIm9XJ8tSudYvD515erlRasaPyEZFkxMaTvjEsFzLjyfA/QxPbZw87L6YnGi+sFg+NjzywkcoK/qODS6cImU8c6nk8irvjTBKlDgi2Y1ZOyFsiGZnrPZZmkK6CVIUAzKlNj0KxfhzivvXH1UIw4DkpzY3GCgELgsjBFm1FmiF+gSPK8WTLDCrJzijn8C5BTGA6WqUI9pXYBF/WiZYwLNxZyD04Z405tJowgBcmE9yzzE0qxBPRQISABXOaErS8lhPz7ILykAQ1zupzx2SrYCy5/Six5km730LSLTkAMhu/QKrRv45f07NnSiLmL7cjDhUEakBFNwbZMt5AFxd5UyuLE3l4Q95KFqjLIlCN3EJ4QBv4YPjnrq+Ocy8Qj8s2MSV/c3zReCtFhEIt+hs5VVd94FS7VN/R+DFaBXzu+z0FYieZp3O6olHch2KzXBu6yxtVpZrQFYkxaV//ht+lyD/XwCd4UUoDJSwVscWPaM+1j/xPq7yiKJneEpYv260v6uVHDrfV8H36hwbFe7U3TUr8W1I2wzJy7yZAXmkpVt0CCbpMPwyCs0TiJ5uVHha72UHnmsvHrCuwyiIbqPhQC7TPkL4SMlbpUB2XXbBRGo64SQXIJnaDTXhGk7FN2TLyKXulbtX+KsUq3Vnd5GJDAALI5hALeA9MYYDyDYiGrhjirDTHxTaJWxT49JEz80BGJ8xGM9ttYRGd+d4/5W+zAVvzp2rsLPsv7B+5P226MQMxzdVsdU03Rh3YXSmh1NG2vGk6sQVe8Oeq1pVNgteLBMYk1dO2i+PHJz0Jw1MpJ/Nxj19kPL24o
 +bDbhnGQ
 lnTRr6F/pmh2tDvLZF/SHDOEleiQeEbT9tSq64Iem0JZQhHEcym8U/bLkRLMS1Ew+RLNWtNzZiHDxyDxga/VdR9TaMz14h+eOFCVZ4BfzqW5UxIz0Mc0uS1LBptZBbYopJrTeJtC0QZuh6UKKH4cMvB1Zfesw0R0dMj6N2DQ8BHgbAJVjIjFX0JKqlHqOylYfnTGCXYTMR3tMqEEyR3ZzVhPVyMPvAOiiH/LaZuhtqXQqFEWveP7LlD+kUDrW0Ydoa+6vGvH7g7qLHMbFR6WYqdg0cAYCJ7W4HH+cZ2KAX2kkKIEcraUSOJBu499J6nlX135Bw/tuaJL3CtIdCIVojSItmmfXod/FLCJgX4Ep2R2H1nMsDSbxkpmzTXkt2ZnhdtQBOHCofA4I7SlnlSvaA7MOfuEx4yYIWgEZpFPkBslF1/pZftAXtIKsJSRXpBgGiH6ji5YwEkzglQE7NStpC9q32D5cu68ozgcGqiL1gw+Q6iKgivYZFrwenVdNnaCLRmp6RjOkJXkjHlJa/zP862UnH502G45cvEfWbOgxkXyIJmCdRsmNjQ2I/Hr3vE1wvX+4UxGl95M6gAyIsigMz5LYk3LyPFbGQM3WR9Dxen/SFluLB6UXSGaedM5UeQFOYWlY0PEP9R0/roKAY0EUxntUHX+U7VIh03Rez+MnGRxs6UHtdZ9X8A/2iHY2YTlZc8n1FfnBWFWUJkpMMXorWbRYjjDt4ywm3/6D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-05-05 at 20:32 -0700, Matthew Brost wrote:
> Set the TTM device beneficial_order to 9 (2M), which is the sweet
> spot for Xe when attempting reclaim on system memory BOs, as it
> matches
> the large GPU page size. This ensures reclaim is attempted at the
> most
> effective order for the driver.
>=20
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Qi Zheng <zhengqi.arch@bytedance.com>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Kairui Song <kasong@tencent.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Axel Rasmussen <axelrasmussen@google.com>
> Cc: Yuanchu Xie <yuanchu@google.com>
> Cc: Wei Xu <weixugc@google.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Cc: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.com>
> Cc: Carlos Santa <carlos.santa@intel.com>
> Cc: Matthew Auld <matthew.auld@intel.com>
> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>

Reviewed-by: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.com>


> ---
> =C2=A0drivers/gpu/drm/xe/xe_device.c | 3 ++-
> =C2=A01 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/gpu/drm/xe/xe_device.c
> b/drivers/gpu/drm/xe/xe_device.c
> index 4b45b617a039..3f719ab08d1c 100644
> --- a/drivers/gpu/drm/xe/xe_device.c
> +++ b/drivers/gpu/drm/xe/xe_device.c
> @@ -500,7 +500,8 @@ struct xe_device *xe_device_create(struct pci_dev
> *pdev,
> =C2=A0
> =C2=A0	err =3D ttm_device_init(&xe->ttm, &xe_ttm_funcs, xe->drm.dev,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xe->drm.anon_inode->i_mapping,
> -			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xe->drm.vma_offset_manager, 0);
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xe->drm.vma_offset_manager,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> TTM_ALLOCATION_POOL_BENEFICIAL_ORDER(get_order(SZ_2M)));
> =C2=A0	if (WARN_ON(err))
> =C2=A0		return ERR_PTR(err);
> =C2=A0

