Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F4153F532ED
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 08:42:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E37D6B0005; Tue, 24 Mar 2026 04:42:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 494666B0088; Tue, 24 Mar 2026 04:42:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AA2D6B0089; Tue, 24 Mar 2026 04:42:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 27E0A6B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 04:42:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BA0EE5A12F
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:42:13 +0000 (UTC)
X-FDA: 84580314546.17.BFE0855
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1B77C1C000C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:42:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=o+JER3Hm;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf18.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774341730; a=rsa-sha256;
	cv=none;
	b=7bw02W3cI7bNhl/uT9kYKainuncP6yxE0+wVs3SNOaOlkQIjiUzAoHGeQ7DtixwM34SYp6
	fxc3nULnDFEy2Kq351ynmOIELO/JRacxmI3gDGPFG3J6vkEhwaHT20beUuT8uVMI49osKI
	LvhBy/IqDBYn71ZMk27XsurHXvZeAnw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=o+JER3Hm;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf18.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774341730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pbAujaAPG3PI7tjdCMceehwF0A1vZDewqB4hYIY6V0E=;
	b=w4csDcCw3JqLjcE/UYMIGHVaPzqjEOI4MNtqVAddQYxnpjdXk6kO1BeHbjrS+GKmy2QnIc
	cIJ2UqAKfib15JS5KTsZDYbfpzo268Z0hH89W0/D665JkeVBzx3UA/pePfsYOqRbKHLCYI
	xHdYNgasqf4r8L4hFnNvs+eMaG6Ds+g=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774341723; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=pbAujaAPG3PI7tjdCMceehwF0A1vZDewqB4hYIY6V0E=;
	b=o+JER3HmoBlkUZDUwtp8PhVRVDzPu5UbycGQgDUniw9/MDa8jDAH1Q//RfS48fu9PSUBaY23s2Qg9dcJgIZA+hwVcw66FjHnaOM9dm2VA02zCOj7F/3cKSa9V/nb/5Mig1ZzWh2jALCC+Q6zoc/8qkABe4ndil8AodUprz6fuW0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R541e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=39;SR=0;TI=SMTPD_---0X.duPY3_1774341719;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X.duPY3_1774341719 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 24 Mar 2026 16:42:01 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Shivank Garg <shivankg@amd.com>
Cc: <akpm@linux-foundation.org>,  <david@kernel.org>,
  <lorenzo.stoakes@oracle.com>,  <Liam.Howlett@oracle.com>,
  <vbabka@kernel.org>,  <willy@infradead.org>,  <rppt@kernel.org>,
  <surenb@google.com>,  <mhocko@suse.com>,  <ziy@nvidia.com>,
  <matthew.brost@intel.com>,  <joshua.hahnjy@gmail.com>,
  <rakie.kim@sk.com>,  <byungchul@sk.com>,  <gourry@gourry.net>,
  <apopple@nvidia.com>,  <dave@stgolabs.net>,
  <Jonathan.Cameron@huawei.com>,  <rkodsara@amd.com>,  <vkoul@kernel.org>,
  <bharata@amd.com>,  <sj@kernel.org>,  <weixugc@google.com>,
  <dan.j.williams@intel.com>,  <rientjes@google.com>,
  <xuezhengchu@huawei.com>,  <yiannis@zptcorp.com>,
  <dave.hansen@intel.com>,  <hannes@cmpxchg.org>,  <jhubbard@nvidia.com>,
  <peterx@redhat.com>,  <riel@surriel.com>,  <shakeel.butt@linux.dev>,
  <stalexan@redhat.com>,  <tj@kernel.org>,  <nifan.cxl@gmail.com>,
  <linux-kernel@vger.kernel.org>,  <linux-mm@kvack.org>
Subject: Re: [RFC PATCH v4 3/6] mm/migrate: add batch-copy path in
 migrate_pages_batch
In-Reply-To: <20260309120725.308854-10-shivankg@amd.com> (Shivank Garg's
	message of "Mon, 9 Mar 2026 12:07:27 +0000")
References: <20260309120725.308854-3-shivankg@amd.com>
	<20260309120725.308854-10-shivankg@amd.com>
Date: Tue, 24 Mar 2026 16:42:00 +0800
Message-ID: <87se9pzkiv.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Queue-Id: 1B77C1C000C
X-Stat-Signature: 7nrnyzsecgyzqh7uxpca76mzjhmmr1gp
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774341728-620779
X-HE-Meta: U2FsdGVkX1/oN6AQnx4OHVm7KZSkCvyWCr41DH5cPqc+cKASXnViIYV10xzH/QANFsWJ9f0Rk2h1ECz8Rxa1uHDLPUZgEXno60o2sGLe2Tnt8ZVRGfn1phm240W78Jez8xk203fH3vgtfcg58M1J0P8hny4B1PX263bIy77lUwwyb+rj+TfTzP9KWBy3hsMBsKYwKXdmw/PzK3qpuq9+27GOr+wH4X81SlYfiSunZLqIzinWYF7KA8hqDHhAXbVEw8coaaRc7akW/PTtJ1gC55DeYXeTFIsHu/DCPHNMivWYKMgmjVWVAOY40vS8ZbrGzAO5Uh2CdRRyLzMFUKh3qamMfPYegkHdJAKbiGSP91WgY7Yq4WwDNLmf6Fs3mevztKxHRSkNVL1FrLvwClfaZZvZU/MyRWkO/OHXCCo6gFAtR486oW/yFb/8oefcdgbWWB1FKs4qJG/U4e3boTazo7jqmExlcmF5ulqVDytzaVzWOrOu1QuCBXtQmADqTBjWW9Ij4L4J6gxYMS2I4ZFSxFovUvvkzLwg0e+STvZ0qBz96qgSJolJ99iOLoNoVgImnbOi4oGhR64f/bBVyPXbUUpCm5s5zdvr09VxtawJ7nDVpDc6Z1DbsAP9phQ5dMj+fo8PXYfx5doex2+nonCGZHvoZfjA+F7xlB5r9cLVvaMZa7abHOx5jHSbZaRqsRab5nCSsEMpkNyJXZXiIRhTUaMvFH3XPfR3JSufzLe7Cmidd++891EoKJTlm2m+m+CpGUFxv4IlcbzjUp2aeiEdN94bi81YQ80clQhZgHrtSirbvLWzjfSzLSFuSquSO6MQ736qnQIGQi1HTgi3BjF9ii4T3PJHTYZHyEBupBhzGitYt64qPlxrSxAnpd5nyqFIDm0rTsWCPrFQoy1vurrS3Nn4Ri2oOJvkBY/DqjxeTZ4WgCIrgsneYp6JCgxyew1DuZRI1/wpMpGkB71u0bX
 M6CroEGw
 GED3XKy/7oDwu5QfiUK8BhxMCcBtFimjVzF2ScaGCRbbvRd0r/b9+1pv9iqeaVsf1j0XbZcnlZ2mGHclqOWzHStN1TkzMwOvYD3mG34NNrrenmFpjTqovC6mRQiYymJvr2vaNxnUpUocdoA9G8z8qcJ3o95K/K3OvzqoGjmOmFKm2n/CDg0aC3QbPkGX1coRVHFuUoMw1OKsxH5eQSYHy0QSAMey7dl7JINPhdq5dQxHHMtwhkJozOS+KAquuW/QTnV0611bFDAcqRbTp3HH4mS/qof0OcrV41DWZefDkt66r2p7MdKOErt82gsa7jDm65K3TL+ggx229diOUHn7ZFuoMx8DYO1fV29GYThcapxCcReMcVEAdckH/0uP5odGPW2ra0TAhszTqkec0xVzM3vP2ZFfUtjgpLz1srZJxaYIR1b3qALHIK7iAeajvAbdf7SlZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shivank Garg <shivankg@amd.com> writes:

> Split unmapped folios into batch-eligible (src_batch/dst_batch) and
> standard (src_std/dst_std) lists, gated by the migrate_offload_enabled
> which is off by default. So, when no offload driver is active, the
> branch is never taken and everything goes through the standard path.
>
> After TLB flush, batch copy the eligible folios via folios_mc_copy()
> and pass already_copied=true into migrate_folios_move() so
> __migrate_folio() skips the per-folio copy.
>
> On batch copy failure, already_copied flag stays false and each folio
> fall back to individual copy.
>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>  mm/migrate.c | 55 +++++++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 44 insertions(+), 11 deletions(-)
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 1d8c1fb627c9..69daa16f9cf3 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -43,6 +43,7 @@
>  #include <linux/sched/sysctl.h>
>  #include <linux/memory-tiers.h>
>  #include <linux/pagewalk.h>
> +#include <linux/jump_label.h>
>  
>  #include <asm/tlbflush.h>
>  
> @@ -51,6 +52,8 @@
>  #include "internal.h"
>  #include "swap.h"
>  
> +DEFINE_STATIC_KEY_FALSE(migrate_offload_enabled);
> +
>  static const struct movable_operations *offline_movable_ops;
>  static const struct movable_operations *zsmalloc_movable_ops;
>  
> @@ -1706,6 +1709,12 @@ static int migrate_hugetlbs(struct list_head *from, new_folio_t get_new_folio,
>  	return nr_failed;
>  }
>  
> +/* movable_ops folios have their own migrate path */
> +static bool folio_supports_batch_copy(struct folio *folio)
> +{
> +	return likely(!page_has_movable_ops(&folio->page));
> +}
> +
>  static void migrate_folios_move(struct list_head *src_folios,
>  		struct list_head *dst_folios,
>  		free_folio_t put_new_folio, unsigned long private,
> @@ -1805,8 +1814,12 @@ static int migrate_pages_batch(struct list_head *from,
>  	bool is_large = false;
>  	struct folio *folio, *folio2, *dst = NULL;
>  	int rc, rc_saved = 0, nr_pages;
> -	LIST_HEAD(unmap_folios);
> -	LIST_HEAD(dst_folios);
> +	unsigned int nr_batch = 0;
> +	bool batch_copied = false;
> +	LIST_HEAD(src_batch);
> +	LIST_HEAD(dst_batch);
> +	LIST_HEAD(src_std);
> +	LIST_HEAD(dst_std);

IMHO, the naming appears too copy centric, how about unmap_batch and
unmap_single?  "unmap" is one step of migration.

>  	bool nosplit = (reason == MR_NUMA_MISPLACED);
>  
>  	VM_WARN_ON_ONCE(mode != MIGRATE_ASYNC &&
> @@ -1943,7 +1956,7 @@ static int migrate_pages_batch(struct list_head *from,

unmap/dst_folios  in comments need to be changed too.

			rc = migrate_folio_unmap(get_new_folio, put_new_folio,
					private, folio, &dst, mode, ret_folios);
			/*
			 * The rules are:
			 *	0: folio will be put on unmap_folios list,
			 *	   dst folio put on dst_folios list
			 *	-EAGAIN: stay on the from list
			 *	-ENOMEM: stay on the from list
			 *	Other errno: put on ret_folios list
			 */


>  				/* nr_failed isn't updated for not used */
>  				stats->nr_thp_failed += thp_retry;
>  				rc_saved = rc;
> -				if (list_empty(&unmap_folios))
> +				if (list_empty(&src_batch) && list_empty(&src_std))
>  					goto out;
>  				else
>  					goto move;
> @@ -1953,8 +1966,15 @@ static int migrate_pages_batch(struct list_head *from,
>  				nr_retry_pages += nr_pages;
>  				break;
>  			case 0:
> -				list_move_tail(&folio->lru, &unmap_folios);
> -				list_add_tail(&dst->lru, &dst_folios);
> +				if (static_branch_unlikely(&migrate_offload_enabled) &&
> +				    folio_supports_batch_copy(folio)) {
> +					list_move_tail(&folio->lru, &src_batch);
> +					list_add_tail(&dst->lru, &dst_batch);
> +					nr_batch++;
> +				} else {
> +					list_move_tail(&folio->lru, &src_std);
> +					list_add_tail(&dst->lru, &dst_std);
> +				}
>  				break;
>  			default:
>  				/*
> @@ -1977,17 +1997,28 @@ static int migrate_pages_batch(struct list_head *from,
>  	/* Flush TLBs for all unmapped folios */
>  	try_to_unmap_flush();
>  
> +	/* Batch-copy eligible folios before the move phase */
> +	if (!list_empty(&src_batch)) {
> +		rc = folios_mc_copy(&dst_batch, &src_batch, nr_batch);
> +		batch_copied = (rc == 0);
> +	}
> +
>  	retry = 1;
>  	for (pass = 0; pass < nr_pass && retry; pass++) {
>  		retry = 0;
>  		thp_retry = 0;
>  		nr_retry_pages = 0;
>  
> -		/* Move the unmapped folios */
> -		migrate_folios_move(&unmap_folios, &dst_folios,
> -				put_new_folio, private, mode, reason,
> -				ret_folios, stats, &retry, &thp_retry,
> -				&nr_failed, &nr_retry_pages, false);
> +		if (!list_empty(&src_batch))
> +			migrate_folios_move(&src_batch, &dst_batch, put_new_folio,
> +					private, mode, reason, ret_folios, stats,
> +					&retry, &thp_retry, &nr_failed,
> +					&nr_retry_pages, batch_copied);
> +		if (!list_empty(&src_std))
> +			migrate_folios_move(&src_std, &dst_std,	put_new_folio,
> +					private, mode, reason, ret_folios, stats,
> +					&retry, &thp_retry, &nr_failed,
> +					&nr_retry_pages, false);
>  	}
>  	nr_failed += retry;
>  	stats->nr_thp_failed += thp_retry;
> @@ -1996,7 +2027,9 @@ static int migrate_pages_batch(struct list_head *from,
>  	rc = rc_saved ? : nr_failed;
>  out:
>  	/* Cleanup remaining folios */
> -	migrate_folios_undo(&unmap_folios, &dst_folios,
> +	migrate_folios_undo(&src_batch, &dst_batch,
> +			put_new_folio, private, ret_folios);
> +	migrate_folios_undo(&src_std, &dst_std,
>  			put_new_folio, private, ret_folios);
>  
>  	return rc;

---
Best Regards,
Huang, Ying

