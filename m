Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21A48F327CC
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 09:22:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AA1E6B0088; Tue, 21 Apr 2026 05:22:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 682256B0089; Tue, 21 Apr 2026 05:22:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BE4C6B008A; Tue, 21 Apr 2026 05:22:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4CC556B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 05:22:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EB1D1E58F4
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:22:09 +0000 (UTC)
X-FDA: 84682021578.01.E304E7B
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf05.hostedemail.com (Postfix) with ESMTP id D76BE10000D
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:22:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gsy3gvDo;
	spf=pass (imf05.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776763327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gjhwBOa3I6lJB6O5Zxac6J4WhufkpISfcLSmTDALcd4=;
	b=CAAUM2qs7/RpuaGaIppJaf5w8u88kMrhQ1UeUdqeqZRl/Ry5C+FLuABuAHdC1EdI4v2DyH
	dbMubAMLDVtyuIFpHJ6/N6tHDx+3ioNfzOeQV/EIY22VxcncOZltYQV+esobkMq2qJ7iRS
	UlnkkogM3TBmjWXN3JOYKCCvayd+c3w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776763327; a=rsa-sha256;
	cv=none;
	b=TlTTCZq5fLc/goE+QyeEKmV907GvDKOwD72V2cKULj7ohtcLDS5nx1sCZlUE/RHUSDCE20
	wWL/UA96H9zTkxYX8ztc5IEsD6P/nbmo19ZARZE8AzdssONXgEh7rL6MAl+TouHDdR2oLh
	iR4hy90ioqbh3Spxsub3jKjlOg48OsI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gsy3gvDo;
	spf=pass (imf05.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776763320; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=gjhwBOa3I6lJB6O5Zxac6J4WhufkpISfcLSmTDALcd4=;
	b=gsy3gvDolgXdQPPZ/xyieWpPLLQCNTQsjxHTmsOlF11/d0JPcqNdXI/nvLzYj+XIYatkB0ykEqpgzLnghPW+/U9v4Zv3hmqF1zykdLysO6ecpSS8OoxsGED6rUmSZQoFgCvfSDjR40L8QxQoAzfibrWP8crNG6W4tJdXZ39+Pco=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X1SeSXl_1776763305;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X1SeSXl_1776763305 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 21 Apr 2026 17:21:58 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: John Hubbard <jhubbard@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,  David Hildenbrand
 <david@kernel.org>,  Lorenzo Stoakes <ljs@kernel.org>,  "Liam R . Howlett"
 <Liam.Howlett@oracle.com>,  Vlastimil Babka <vbabka@kernel.org>,  Mike
 Rapoport <rppt@kernel.org>,  Suren Baghdasaryan <surenb@google.com>,
  Michal Hocko <mhocko@suse.com>,  Zi Yan <ziy@nvidia.com>,  Matthew Brost
 <matthew.brost@intel.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>,  Rakie
 Kim <rakie.kim@sk.com>,  Byungchul Park <byungchul@sk.com>,  Gregory Price
 <gourry@gourry.net>,  Alistair Popple <apopple@nvidia.com>,  Axel
 Rasmussen <axelrasmussen@google.com>,  Yuanchu Xie <yuanchu@google.com>,
  Wei Xu <weixugc@google.com>,  Chris Li <chrisl@kernel.org>,  Kairui Song
 <kasong@tencent.com>,  Kemeng Shi <shikemeng@huaweicloud.com>,  Nhat Pham
 <nphamcs@gmail.com>,  Baoquan He <bhe@redhat.com>,  Barry Song
 <baohua@kernel.org>,  LKML <linux-kernel@vger.kernel.org>,
  linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] mm/migrate: wait for folio refcount during
 longterm pin migration
In-Reply-To: <20260410032333.400406-3-jhubbard@nvidia.com> (John Hubbard's
	message of "Thu, 9 Apr 2026 20:23:33 -0700")
References: <20260410032333.400406-1-jhubbard@nvidia.com>
	<20260410032333.400406-3-jhubbard@nvidia.com>
Date: Tue, 21 Apr 2026 17:21:43 +0800
Message-ID: <87cxzsis7s.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Stat-Signature: cg5r7azhptdz5iggc46pmwr77tpdq3ei
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D76BE10000D
X-Rspam-User: 
X-HE-Tag: 1776763326-234293
X-HE-Meta: U2FsdGVkX18z1zPAnFG1gsDNyENkBKY2swuHa8IdhyDmg3cUdTHmN9wmpRAjixPnVE0aqjR2kyxCHNceMENYQ5Ecc97l19Rlf6b7qTRZ9F9MfSGtUtj3ICaEIyLDigFRU28meIhP/2fZc2lVv6zePuIFxuTKY5dc16cm0spuv27twGbPA0xHhL4LlWi0Z/A8O65eaMO8UyuGVmuOjtQ+7zE/+IkhXGo6dZhF0e09UiGCzZQczVbhGOLtmb+/Niu5C38Tw70qGAZzUrRJi8uoAS57q9FM+NgLGNSgZsqWxHwBhtJo5VUUVy58ltCIXwIadf/2zyeahTIXILIuKF+uNYoXxE4UaKlPtXm1odPf/jeLbNJPHZz/cQ9xBTxSPN57TEsBWDMSZ5jewFFzrrzjIxkZgFZbFaTTPbKgsN47tR7eV7a9fYB1Tg2HGUdbOZbQ/GNFMK/wykk5VMXuN6z4mlql9DHCeFmfmvYZkGHapwspC7CutJEQ0CuJKnBDDRQRT1yDww3CUQN34wFjddSxDofftkxOCLnVpXUXyQ610zY7LGuVtlZr84EzOFQHHDJYJa66tlzIQWf4EczqALlWeLJrOkHPEYh+6r8bJ0cU8YFXS7CF04GrfWHop1gN/Pw69nWqQyN38D1s4XoFvtxzla7xVYXKpZ7oUDc8ZjcyQLFSgMJEwniRm4BPt4YnYjF42R4jJtxfOysCM1Tj731UpFgovYvSvn4hO/cEMp9EzEXVzZwohS1atcIDJzWh4P5hQUabe04l+wLwWz/V0fVRchZm+b5XElpKdh9+zyIa0q/FRtJj+4V3ddBSuZvbdR4PELjPQ4z3OieTMQkDsRPFr/qSaiJtHoDtatj13TQ9ZXUmyMFmcYdPQXRPup+vqIN8n6dL798INVKADJIBXgMuB7ZfNS9ICx5nPxBLKXB3eGcnHe/ffH1BV3/WaCXRO0sSNw3eY4Gfc0uFRd+dd5+
 CxjKXGn+
 XeomuOOCer0nMkPTKwZjpQtir69L4kvMmz2QVCmfyaonIRENTcDAT7NkPbCZmfSOuqGRi3DKYn/n3EqtwZD2YcyOVUgVdxAglZ11dyyvQSd777YoEcWSQ8GCqLrZcimgK2L8eLXXu2flkTDGpJGz+RJyKiYguUcLWHAlKSAjJ6gHLSFaxXg9poDw7zLGmmxr+FwAaZmkSMtDV96n6JgHbgw8ecF+0TIwGPZspInfdLim1k3Wa3e+rsXRQhsH+Mhltku8RpmVvP02iBhRQaPvjZNWh8D6pPL98+eBC1HAYJicmZA/G1DAgUHhpLmMv7Kk7EA4QauFREWm6RhEPSZk4CaWW9T5veup/SyJToSIL/rzM7rCTS4E9ZLBqJ+nhTM6eJy87dHMdmZNYpRgHotnLij8LXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

John Hubbard <jhubbard@nvidia.com> writes:

> When migrating pages for FOLL_LONGTERM pinning (MR_LONGTERM_PIN), the
> migration can fail with -EAGAIN if the folio has unexpected references.
> These references are often transient (e.g., from GPU operations like
> cuMemset that will complete shortly).
>
> Previously, the migration code would retry up to 10 times
> (NR_MAX_MIGRATE_PAGES_RETRY), but this busy-retry approach failed when
> the transient reference holder needed more time than the retry loop
> provides.
>
> Fix this by waiting up to one second for the folio's refcount to drop
> to the expected value before retrying migration. The wait uses
> wait_var_event_timeout() paired with the wake_up_var() calls added to
> folio_put() in the previous commit. If the timeout expires, the
> existing retry loop continues as before. The folio_put_wakeup_key
> static key is enabled for the duration of migrate_pages() so that
> folio_put() only wakes waiters when migration is active.
>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  mm/migrate.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 2c3d489ecf51..a5d9f85aa376 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -47,6 +47,8 @@
>  #include <asm/tlbflush.h>
>  
>  #include <trace/events/migrate.h>
> +#include <linux/jump_label.h>
> +#include <linux/wait_bit.h>
>  
>  #include "internal.h"
>  #include "swap.h"
> @@ -1732,6 +1734,17 @@ static void migrate_folios_move(struct list_head *src_folios,
>  			*retry += 1;
>  			*thp_retry += is_thp;
>  			*nr_retry_pages += nr_pages;
> +			/*
> +			 * For longterm pinning, wait for references
> +			 * to be released before retrying.
> +			 */
> +			if (reason == MR_LONGTERM_PIN) {
> +				int expected = folio_expected_ref_count(folio) + 1;
> +
> +				wait_var_event_timeout(&folio->_refcount,
> +					folio_ref_count(folio) <= expected,
> +					HZ);
> +			}
>  			break;
>  		case 0:
>  			stats->nr_succeeded += nr_pages;
> @@ -1941,6 +1954,17 @@ static int migrate_pages_batch(struct list_head *from,
>  				retry++;
>  				thp_retry += is_thp;
>  				nr_retry_pages += nr_pages;
> +				/*
> +				 * For longterm pinning, wait for references
> +				 * to be released.
> +				 */
> +				if (reason == MR_LONGTERM_PIN) {
> +					int expected = folio_expected_ref_count(folio) + 1;
> +
> +					wait_var_event_timeout(&folio->_refcount,
> +							folio_ref_count(folio) <= expected,
> +							HZ);
> +				}
>  				break;
>  			case 0:
>  				list_move_tail(&folio->lru, &unmap_folios);
> @@ -2085,6 +2109,9 @@ int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
>  
>  	memset(&stats, 0, sizeof(stats));
>  
> +	if (reason == MR_LONGTERM_PIN)
> +		static_branch_inc(&folio_put_wakeup_key);
> +

This should be done in migrate_pages_sync() before the sync loop.

>  	rc_gather = migrate_hugetlbs(from, get_new_folio, put_new_folio, private,
>  				     mode, reason, &stats, &ret_folios);
>  	if (rc_gather < 0)
> @@ -2137,6 +2164,9 @@ int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
>  	if (!list_empty(from))
>  		goto again;
>  out:
> +	if (reason == MR_LONGTERM_PIN)
> +		static_branch_dec(&folio_put_wakeup_key);
> +
>  	/*
>  	 * Put the permanent failure folio back to migration list, they
>  	 * will be put back to the right list by the caller.

---
Best Regards,
Huang, Ying

