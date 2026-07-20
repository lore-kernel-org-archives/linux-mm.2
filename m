Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D5CAC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 11:19:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59C5B6B00A5; Mon, 20 Jul 2026 07:19:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54D706B00A6; Mon, 20 Jul 2026 07:19:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43C456B00A7; Mon, 20 Jul 2026 07:19:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 199216B00A5
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:19:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8E652C0142
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:19:57 +0000 (UTC)
X-FDA: 85008910434.13.7B17C99
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf05.hostedemail.com (Postfix) with ESMTP id 05217100004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:19:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=kE76nugT;
	spf=pass (imf05.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784546396;
	b=JoSzP1oUDeRJgdqx9uUIXsvfwGIl85ZXml+etWV/FnDCY6sQ98ci9xFYw9VzkXXXRlRIdN
	MTjuTFigxqYPQcmG1UUS3OESA7mBQGy56mX0sIAL2JUZ7+FnNwixMc9YhsGfMeS5GgTPoH
	mZL7uiOouvImhonfzI4lrxcRCRPo8h8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=kE76nugT;
	spf=pass (imf05.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784546396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b9DJpAd7dJus4uCxgZw4x1NB6kjRhyCZJJkvMlelICQ=;
	b=iB00qD6HRKJvlWPdWTJFylXWKXDOL8VKUXnBIs2pOjt5UGS/eWLJZc61AZ6q/TtxoiRtbG
	56+C3KUzwkE6azOBMUqgha/oJSzkwRS4hBRIqiakrxFxtUl3lBLBJPuM5Q8azd8G4E7QRU
	mayCO6VB0+rOUzfFMzBcUafyrOWpRn8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784546391; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=b9DJpAd7dJus4uCxgZw4x1NB6kjRhyCZJJkvMlelICQ=;
	b=kE76nugTxJbz4oat1q2DMqGAK3PyBRj1ummPnrdyv6IN6PoFxmlc4SCn17WPYx2Fwt1mxSrhzNRKICmY3X4k4nlws0AmGQMsntbsFdTVAOuD5nwTSZVWRT68TQ2weTx8pS45f1RLk1CT5JqSsPXw23Oobq5s8uVrCIoPBSaq9n8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R631e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=46;SR=0;TI=SMTPD_---0X7TBCA6_1784546373;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X7TBCA6_1784546373 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 20 Jul 2026 19:19:49 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Shivank Garg <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,  David Hildenbrand
 <david@kernel.org>,  Zi Yan <ziy@nvidia.com>,  Matthew Brost
 <matthew.brost@intel.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>,  Rakie
 Kim <rakie.kim@sk.com>,  Byungchul Park <byungchul@sk.com>,  Gregory Price
 <gourry@gourry.net>,  "Alistair Popple" <apopple@nvidia.com>,  Lorenzo
 Stoakes <ljs@kernel.org>,  "Liam R. Howlett" <liam@infradead.org>,
  Vlastimil Babka <vbabka@kernel.org>,  "Mike Rapoport" <rppt@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>,  "Michal Hocko"
 <mhocko@suse.com>,  Karim Manaouil <kmanaouil.dev@gmail.com>,  Frank van
 der Linden <fvdl@google.com>,  Teja Vojjala <tejavojjala@google.com>,
  Pravin Tamkhane <pravintamkhane@google.com>,  Kinsey Ho
 <kinseyho@google.com>,  Wei Xu <weixugc@google.com>,  Matthew Wilcox
 <willy@infradead.org>,  Davidlohr Bueso <dave@stgolabs.net>,  Vinod Koul
 <vkoul@kernel.org>,  Bharata B Rao <bharata@amd.com>,  SeongJae Park
 <sj@kernel.org>,  David Rientjes <rientjes@google.com>,  Xuezheng Chu
 <xuezhengchu@huawei.com>,  "Yiannis Nikolakopoulos" <yiannis@zptcorp.com>,
  Dave Hansen <dave.hansen@intel.com>,  Johannes Weiner
 <hannes@cmpxchg.org>,  John Hubbard <jhubbard@nvidia.com>,  Peter Xu
 <peterx@redhat.com>,  Rik van Riel <riel@surriel.com>,  Shakeel Butt
 <shakeel.butt@linux.dev>,  Tejun Heo <tj@kernel.org>,  Fan Ni
 <nifan.cxl@gmail.com>,  Jonathan Cameron <jic23@kernel.org>,  Aneesh Kumar
 K.V <aneesh.kumar@kernel.org>,  Nathan Lynch <nathan.lynch@amd.com>,
  Frank Li <Frank.li@nxp.com>,  Dan Williams <djbw@kernel.org>,
  <linux-mm@kvack.org>,  <linux-kernel@vger.kernel.org>,  Mike Day
 <michael.day@amd.com>
Subject: Re: [PATCH RFC v6 3/5] mm/migrate: add copy offload registration
 infrastructure
In-Reply-To: <20260630-shivank-batch-migrate-offload-v6-3-da95d7e8b8a2@amd.com>
	(Shivank Garg's message of "Tue, 30 Jun 2026 07:28:39 +0000")
References: <20260630-shivank-batch-migrate-offload-v6-0-da95d7e8b8a2@amd.com>
	<20260630-shivank-batch-migrate-offload-v6-3-da95d7e8b8a2@amd.com>
Date: Mon, 20 Jul 2026 19:19:31 +0800
Message-ID: <87wlupx60s.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 05217100004
X-Stat-Signature: g71cj3uwo5nbzqt1bnrpfybesofjmtwk
X-Rspam-User: 
X-HE-Tag: 1784546393-190164
X-HE-Meta: U2FsdGVkX1/mRCyr+G4Azs5sZ/HjG9MXDM38UGLEzeRMInPEC9WY3S/PDZ5grVUpgOPdv0oMA4ShOKZZSqs9W3mILMVoy5tFUiTABoNPqwA8Wnuo5FcKUq4CQT21dkDvFqrql23EAkFUI+AVtUr8SzxN6eDtw2qGGMEXpU4ODyjLgwJpJyx8UGeP75X6eDVZA11d11qKfCh0dd1xCwvZB4nMMNarADsJpBaX++kOHC9XvVuPZh9wU5MP+CSEaFGk4Q/bKVAOe+ZZFzF1z9GXcdOMmkq525z764I5PziFE3CiEdUo1qh38u5kkKeWg/cfNUbifPhlEPIjYU7MlhyY2ZsPOdvHgqLREh5vNWxa54Mdz7uP+ccYP9icf/V+M1JZJW8HLSF/jDvWfRFKe1YNUx6rkiWbC4FZl2F20IR26wgAirFerW3hGA4BbM9BYkxjrQ+GJ+QkhmucU+eygFc/LW7DKjMp2psmYFKgo6LwxgiPzY2JAcK0IeKPrXoV7Lxk6/4r6o+8wM6Gmto04Gk3FBruXYiip11EY2nIVWSM2cH5IEskW4oEVTu3EuNhhohoLjwlQgvCH42W5rSVfW6Rjizz4SkMPEBDSDKMRVTTqDnnJHF86OCE2NSbf6fONb4bILPr3jbj+0s322J9Mur+q/f3EZNnQEs7op3NQEC7ArrMb6d6FVpRj4sP2V0nmPYgkctvTJtTnxrBLuf+kcurBM3W8pFKwjm390RnAgWBeIddo+uxPA3I30eTHCWukbb92AzueVnnA4TsO0kcoYVdPgPsdksxzQ07ZnmyHGXcI2X2qLiODlt2fCzsrcPVqbR3hJrtii24PmOEIsNZjyMlB1fC0G2+f7IqXBmDCLCY/I3fXJFFJuW4fYUYGLQtGNBfxHkpA9WEnwpw8RMT1oj200q7wry7ONlbxg8CrEmsglnnQkHX6RUJNg1X3CP1hu3yoRc5GjzVkvlqky8/VZo
 TZMdl5xb
 5YqmyIup08FRLiINkRFyEAH6IjslunYQBlpNunTeUuKbnlvSl4AUsVneoq8y6YkxGgcQm0l88/FVbd17/Wo1Li0ZKySdw9aBS4h7keTdkWeKtGOFKjnHj3nFV9Vx7I5QedIA4uZpJdponf9kNczsk1HBYNsty944KA/eOpeM2J8twiKioomHg8DWnZKQ8+f1lINEsRRzZv+wDPFYw6fL6zTbSrn1DpYAOHSZHZGJzqgBuDJGA9XKKeGDwLeCfdudqYP8PPhEMzl//Beb0tkjYCP0IB8Kf/ND6l3ybhcxbFeEiBbo+dJVK3pTNuWv9thEg1ZHkDPtVx6emUtVcgGWs9Dtjc28lE/B5+5dJzbsUcEELPBAFoyFnqYdMMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shivank Garg <shivankg@amd.com> writes:

[snip]

> diff --git a/mm/migrate.c b/mm/migrate.c
> index 41b732e78a67..4fed3110ca0a 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -43,6 +43,7 @@
>  #include <linux/sched/sysctl.h>
>  #include <linux/memory-tiers.h>
>  #include <linux/pagewalk.h>
> +#include <linux/migrate_copy_offload.h>
>  
>  #include <asm/tlbflush.h>
>  
> @@ -51,12 +52,6 @@
>  #include "internal.h"
>  #include "swap.h"
>  
> -/* For now, never offload. Wired up in later patch. */
> -static bool migrate_should_offload(int reason)
> -{
> -	return false;
> -}
> -
>  static const struct movable_operations *offline_movable_ops;
>  static const struct movable_operations *zsmalloc_movable_ops;
>  
> @@ -2050,7 +2045,7 @@ static int migrate_pages_batch(struct list_head *from,
>  
>  	/* Batch-copy eligible folios before the move phase */
>  	if (!list_empty(&unmap_batch))
> -		migrate_folios_mc_copy(&dst_batch, &unmap_batch, nr_batch);
> +		migrate_offload_batch_copy(&dst_batch, &unmap_batch, nr_batch);
>  
>  	retry = 1;
>  	for (pass = 0; pass < nr_pass && retry; pass++) {

Found a difference between v5 and v6 here.  In v5, migrate_pages_batch()
checks the return value of migrate_offload_batch_copy() and acts
accordingly. While in v6, it does not.  Why was this changed?

IIUC, FOLIO_CONTENT_COPIED is now used to indicate a copy failure.  Is
this necessary?  Is it possible that some (but not all) folios fail to
be copied?

[snip]

---
Best Regards,
Huang, Ying

