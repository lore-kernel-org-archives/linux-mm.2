Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53405CA0EDC
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 01:29:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA4709001FC; Thu, 14 Aug 2025 21:29:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7C649001D5; Thu, 14 Aug 2025 21:29:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C69D49001FC; Thu, 14 Aug 2025 21:29:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B3DB59001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 21:29:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5B9FEC07DD
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 01:29:11 +0000 (UTC)
X-FDA: 83777258502.14.C1BB472
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id B51C9100007
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 01:29:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uhfhNylk;
	spf=pass (imf05.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755221349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EvOx8YJGoL8XjrEaDdqtn6ehN7T5qVmlpqM2R57SM4Y=;
	b=NVMNfTJpiyQkgD2V77kZqlDcZMkJ5dztk2pQMz7OHWq+ruVPbPlf0pKi13GbVBwrO/z0wY
	tTJLJynmPAblZ62tL1jLauB0J1K8gqTvqWqzHyrCAy8sVTZ5IT2e7XZ3zT+dQ1nrAmVC2i
	i45QBFLIW9o3bSIZoVN4e9YcIc47zB0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uhfhNylk;
	spf=pass (imf05.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755221349; a=rsa-sha256;
	cv=none;
	b=xPHpNf7BGOFDUuKstcbEVQPOerfZmTTXEbPrph8zNYOV+2wlzMhobHS+Yjz5PVYTiXFbe4
	536fvYYgm7Sjn9UXw3L4tUPd7BVcDAdgFmz6PHuRqCEL46dGdG7lWZNMx4NcZvxO1x0qY9
	6TQHogwzA76ge5LfJT8x0svWkcdXJQ4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755221345; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=EvOx8YJGoL8XjrEaDdqtn6ehN7T5qVmlpqM2R57SM4Y=;
	b=uhfhNylk+lfH9dSWPp/ZGEazWtDrYDhM+XJUoFl8V3FQ5iGubGqTjz9bh9HigER2JmZSfukGpZ4G06E4Qt0fFcZGkBTmyQRpyr72Heg+BYuNW8w3nseum6qlVx137pK1lLJZB3x356limqXJkJH+EkUiK0Ymb6oWzhGjAU8Qsco=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0Wlmcoul_1755221341 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 15 Aug 2025 09:29:03 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Bharata B Rao <bharata@amd.com>
Cc: <linux-kernel@vger.kernel.org>,  <linux-mm@kvack.org>,
  <Jonathan.Cameron@huawei.com>,  <dave.hansen@intel.com>,
  <gourry@gourry.net>,  <hannes@cmpxchg.org>,
  <mgorman@techsingularity.net>,  <mingo@redhat.com>,
  <peterz@infradead.org>,  <raghavendra.kt@amd.com>,  <riel@surriel.com>,
  <rientjes@google.com>,  <sj@kernel.org>,  <weixugc@google.com>,
  <willy@infradead.org>,  <ziy@nvidia.com>,  <dave@stgolabs.net>,
  <nifan.cxl@gmail.com>,  <xuezhengchu@huawei.com>,  <yiannis@zptcorp.com>,
  <akpm@linux-foundation.org>,  <david@redhat.com>,  <byungchul@sk.com>,
  <kinseyho@google.com>,  <joshua.hahnjy@gmail.com>,  <yuanchu@google.com>,
  <balbirs@nvidia.com>
Subject: Re: [RFC PATCH v1 1/7] mm: migrate: Allow misplaced migration
 without VMA too
In-Reply-To: <20250814134826.154003-2-bharata@amd.com> (Bharata B. Rao's
	message of "Thu, 14 Aug 2025 19:18:20 +0530")
References: <20250814134826.154003-1-bharata@amd.com>
	<20250814134826.154003-2-bharata@amd.com>
Date: Fri, 15 Aug 2025 09:29:00 +0800
Message-ID: <87ectde5k3.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Stat-Signature: ritgkb9wcm3bfbtrfsebz36ug9fxprkc
X-Rspam-User: 
X-Rspamd-Queue-Id: B51C9100007
X-Rspamd-Server: rspam05
X-HE-Tag: 1755221348-531306
X-HE-Meta: U2FsdGVkX19pu/sKP7kIu31Sfgl2oUZiqWNMJPtfNQWP1nmA8J8P/BrGE1WzqbbmAmLHfyjeTfI4E+cEjoajUJzY7DyH+rzhRqrY5Z4lX4DsKQRjYID90zbthpYFlU0rPMS20JTgPNUvbybo3f6ZEa3KXT6E8aBGwA5/zouMxT1P0gAt4dkK08576beziCAfVovgCqsV0VfCoZK6rzJRof42aD61kWNKEg6Z0YO4Hw2ua9QAqFf28Zhi11ITEWrZb/W0L5GGX7eP4N40ZOSCYioazU3FzK3kmrYS5dg5CmOvSVQGJn6sNHsq0faBhKAMvFD+jFlJbEtfdfP1OjPr6YDXMqYZaVT4iV73SaACx4vnHOYUEVbrMstTPHT8CZWi56HDHmXauYAfl1eC7JPfIoMXFQPSMGOsPsV7u3LsUYQISRx8kL66gumzTqYGKI9QEBo2oO/MuCI+ihgBstqScT5+3Xek9hbWK656klqgBAY79zjNEDv7d5iFcPQ721G5MlHpraBF3B45JLdCCAJXflrqxlwcjLU8F/J3uSDiTKribl/3t6QEpNDvJqslPkS6mQoV2v+EDz0mfIKVwCHuapsSqUd8NadY7wOIixxTEwnr6fUN88bIOns6kKTj52LBDMsz9DYmI9UYHDlLbq2wZsvbPxO/9ybGhkTACikclklsTvqYYzqlBHwZU/qYjdt2bEHOU4RaK4pPjZh2i/k97Zi6oIspAMNixlPhDrJaYhPDRKBUJ+Sk4Ncsf0T5H1y76xljWnYEKfp8+r3raRcIRryv9kVGNFAc50LGkSxHPynJwkKldoYrtG039BkHAjX/Nzs6bK1m8sROciT7yurYlB9cVen+SHpm8E8kwE5pnU1r+cACqGF795pldartTcy8WM669zJc9RrG1xwsdqn3JXzepnEe/yaT+uAwbRemBAUZW9V4n7wkhB6cvO/BL0BzLp4qmlYmaYCwZxHg3uN
 QYozXGn+
 BIkB5rbtwK6JWsPPBQWrSL6N9Tnyyw6B8gRG5Dc/OZR7WDATcjjByWGYAFyi7D4gsYlFK+RK3eNSrGpmf4VohC49XeZ5NY5JoulATSaNtIRPlYoSKZulGTrIwL58S2NPwQsHvXT1xuRec1J0xosN84cZGG5/TmX96VTFeHIxQbofKzdzLK1MlvOhj+d7zdkdcev32YSFeZWyPgq15Yx3gp082vPIqVz+obRm6eR4xOrmvx2zvKmaDxYle1AsRE2ix2DuOc+YoU6NuXOJqOy4/xBbrkDfNDXoocQDYagH72CgoUDa6DfdecT1DnKZ3aZ5pDUqlR4Qk+95r/ZiBykJ+ke+0CxGtlIJ6iDtQLfNUV9bWpDvcZL23kqxT+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Bharata B Rao <bharata@amd.com> writes:

> We want isolation of misplaced folios to work in contexts
> where VMA isn't available. In order to prepare for that
> allow migrate_misplaced_folio_prepare() to be called with
> a NULL VMA.
>
> Signed-off-by: Bharata B Rao <bharata@amd.com>
> ---
>  mm/migrate.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 425401b2d4e1..7e356c0b1b5a 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -2619,7 +2619,8 @@ static struct folio *alloc_misplaced_dst_folio(struct folio *src,
>  
>  /*
>   * Prepare for calling migrate_misplaced_folio() by isolating the folio if
> - * permitted. Must be called with the PTL still held.
> + * permitted. Must be called with the PTL still held if called with a non-NULL
> + * vma.

The locking rule is changed.  IMO, it deserves more explanation in patch description.

>   */
>  int migrate_misplaced_folio_prepare(struct folio *folio,
>  		struct vm_area_struct *vma, int node)
> @@ -2636,7 +2637,7 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
>  		 * See folio_maybe_mapped_shared() on possible imprecision
>  		 * when we cannot easily detect if a folio is shared.
>  		 */
> -		if ((vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio))
> +		if (vma && (vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio))
>  			return -EACCES;
>  
>  		/*

---
Best Regards,
Huang, Ying

