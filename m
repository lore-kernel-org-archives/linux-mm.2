Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7388D105A594
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 12:56:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C66A6B0092; Thu, 12 Mar 2026 08:56:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87C666B0093; Thu, 12 Mar 2026 08:56:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 788CA6B0098; Thu, 12 Mar 2026 08:56:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 60B896B0092
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:56:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 19E2D1B6FCC
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:56:31 +0000 (UTC)
X-FDA: 84537409782.05.028388F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 40AF280009
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:56:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PGRtm0Kk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773320189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kF4s7HIpx1BdA3ijIt6TrMdK6qLhaWoQhyAgSLgBJjA=;
	b=eb7p00DDT754ITGEJahkYg7+oL+k6dVtkQzFUZvl4uH02GenrDNw7pi+kZp6ekMaRM/akF
	qM8H9CjjGdMg4ow8HH5usMXKpjv7Khcy7f85Zjs8YjttS85jPZLiEXdedQAskkKgqBD1yB
	8kSSPk1hSlQr3GlblDyDGhGTBJpOv8k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773320189; a=rsa-sha256;
	cv=none;
	b=uUCseHisPApGAxbHeApXY8yolqAa9iJ8uu7GNDlsMRZibXx9qbv7SDDCf6Bm99cZYELBcP
	mBs1yobMKHachceWXIzjA5kDx9z/u2jDggk5YaiWWFBiRXG3/SPsHoh3vgupkZcNo4ouN4
	wvYDl2c5PsuqToUTOyCvNeTiFya9iH0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PGRtm0Kk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F0CF4195B;
	Thu, 12 Mar 2026 12:56:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED56BC4CEF7;
	Thu, 12 Mar 2026 12:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773320188;
	bh=q3h/02q/FIlvqotp97NZLb/PN0lyW2g0sXZpqfK9aFk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PGRtm0Kkzl+sKjrxr1XFkfDzoOEMVo0po4REuofgBxyqG6m9Yn7gG+Kg7vWpD/CO9
	 2oaoF5sD9YDzmji/GtJ+cooHjmCGdJe3OlLXNv1EngzRwBU9ZBnpiLFUbe4J4bj2Xw
	 hCtH8c6u6OurSxUGxv0uDvA3ukcqlyQ0K2aQqder7zp9tXGiuewcFGg//jJ5WSZhsm
	 iEL7NAUTLcS9WwqRqE6D+J0Yg+besdF3da9KIHlF4iptObFmoxr7TF1Koof+TtB7Gy
	 6nmyr17Ird0129PyX6rR/AfOGdiksDlQqmvgDXRa4tVvsc/QjYoaVDCBQXmzgA8oOZ
	 r+Cnngf54P4KQ==
Message-ID: <c679971c-fd4a-4c92-9301-67392abb1c8d@kernel.org>
Date: Thu, 12 Mar 2026 13:56:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] mm: Move demotion related functions in memory-tiers.c
To: Alexandre Ghiti <alex@ghiti.fr>, akpm@linux-foundation.org
Cc: alexghiti@kernel.org, kernel-team@meta.com, akinobu.mita@gmail.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org,
 zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 gourry@gourry.net, apopple@nvidia.com, byungchul@sk.com,
 joshua.hahnjy@gmail.com, matthew.brost@intel.com, rakie.kim@sk.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260311110314.237315-1-alex@ghiti.fr>
 <20260311110314.237315-2-alex@ghiti.fr>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260311110314.237315-2-alex@ghiti.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 40AF280009
X-Stat-Signature: 1wtcht6yuhdfx5ai735umsbxc4jcs9ym
X-Rspam-User: 
X-HE-Tag: 1773320189-931555
X-HE-Meta: U2FsdGVkX1+adIN0ox9jKM4EljiD4O0Cr89WPpRwqrwK5dM/hOvcuGK9QQmc1e2lzlAuDzr45Kpn+EhzrMDLN+LU15x8cKQqGXOpZEjc0zCEWK5bQyTzOH5etlwjpEncSXBswjZkgy8qWUkcP2rRX/vLPMDm2Psa+61+hNRV/YvXz5NRW8G7a8WoVbdE5QACbc7oOxBNQD/1J8uT8rXD33gwHD49FSqazYpsDCnwm1tobBVEzMVLXlHQ2sMU7v86Oh2B3RbQ4OH93+KV6CJHwZCUAjPbuGXOQdnx9V9f3OcvdvYfN1/tbyJswEqOwkvnpsWupbpYJu3l99xX9ERQdBSMQm92t5hLxNLpaufMWUQYn89pj7PWxNnGBZi3CiJFePt/SBjCNG1s/GDqvrRn9o9PLj42pJdDWO/N9vmIvN3qIo7pflgAgIx+HffjT+iDYcy1CE7apl3VpJ/xkFrCWJl9bS90p033tC/y2oyheaxbh1ldazK9qLX1jcskhx+IIRbbn9N4AsIMUjvAXwgAXprDMvkK9aEhkZs3UFfNQN8TM9Nr+vnd3wOFbBNsGjyiWH2YfVdrwaDszNIv4A65lmRmvZvLbE4lW5AqA3c5r4qC3RdB3L71+CwZ/DFdeVhRRLwFaht5u/kvO53J4p0PXhtC4sMe5uXDbGRSywh6HDDjT3RMNYamHMMlid0dQzzWhfp1Do8v8Ac/9He9j/5ynVmDzVWE0VdIynw16q7hfwf2hDSPdGka+iOmJFxjWylZnbcnESMjdX1IX4a6h/HrNHJf6Fbq/76Vix1OEKK2TbW88qJxeLZbrE9aNc3EGNPUP2wD0Cv527jNPdUkEX3WDWfiRqpji2a6Fx+ZG2gpvctJ8aQaHHM4K3K4Nn4gS9yYnXDKhx0AkWUzMkLSoIMDLX4xb4F2zDvS9QT8Ld1sE68mmSsLbtVv4GkD2MdA8SAS/+M/CRqwtPxX2rvOqCM
 QPKeXewl
 Sq30qka3ZbFgAp+VTxvSlM1dU9afRZL77boLWyJQR7gdmwZh+LzWcbaGlpJ6DlsNp/LGldFwnBUwo/lgf46+RONsjtrmipGDLdqtiGrUEpZkOKbr37H7HA5+qsVR9VmJxCQYlVXCTCUjijpDxadoU3T9I/GxFdyN9G01ualohp6mNdG93agN6rgpBhvZiuRAvORrt9eVKSk8iWzqWONGmclqTj6e9WMa0LeBliDeCw0LKK3ZbgoQFzg0rkC9hzVj/QCSnxwGfH7IfeihGZWGAWvnHhCFBkRLHG+6leajsa+9NwAvZsa265cNj8SUDzQJprY2xXNRKM+QugGDqqgv3f8tXIs5iVxBpr1oUy06mA/GBK27XhEsyT59bYlk2HfLRGVD4xsf+MPH5TpUBN7YqQ1Xhd/rikiD0yAwspwsh6pziTjA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/11/26 12:02, Alexandre Ghiti wrote:
> Let's have all the demotion functions in this file, no functional
> change intended.
> 
> Suggested-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---
>  include/linux/memory-tiers.h | 18 ++++++++
>  mm/memory-tiers.c            | 75 +++++++++++++++++++++++++++++++++
>  mm/vmscan.c                  | 80 +-----------------------------------
>  3 files changed, 94 insertions(+), 79 deletions(-)
> 
> diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
> index 96987d9d95a8..0bf0d002939e 100644
> --- a/include/linux/memory-tiers.h
> +++ b/include/linux/memory-tiers.h
> @@ -56,6 +56,9 @@ void mt_put_memory_types(struct list_head *memory_types);
>  int next_demotion_node(int node, const nodemask_t *allowed_mask);
>  void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
>  bool node_is_toptier(int node);
> +unsigned int mt_demote_folios(struct list_head *demote_folios,
> +			      struct pglist_data *pgdat,
> +			      struct mem_cgroup *memcg);
>  #else
>  static inline int next_demotion_node(int node, const nodemask_t *allowed_mask)
>  {
> @@ -71,6 +74,14 @@ static inline bool node_is_toptier(int node)
>  {
>  	return true;
>  }
> +
> +static inline unsigned int mt_demote_folios(struct list_head *demote_folios,
> +					    struct pglist_data *pgdat,
> +					    struct mem_cgroup *memcg)

use two-tab indentation on second parameter line please. So this fits
into a single line. Same for the other functions.

Just like alloc_demote_folio() that you are moving already did.

[...]

> -static struct folio *alloc_demote_folio(struct folio *src,
> -		unsigned long private)
> -{
> -	struct folio *dst;
> -	nodemask_t *allowed_mask;
> -	struct migration_target_control *mtc;
> -
> -	mtc = (struct migration_target_control *)private;
> -
> -	allowed_mask = mtc->nmask;
> -	/*
> -	 * make sure we allocate from the target node first also trying to
> -	 * demote or reclaim pages from the target node via kswapd if we are
> -	 * low on free memory on target node. If we don't do this and if
> -	 * we have free memory on the slower(lower) memtier, we would start
> -	 * allocating pages from slower(lower) memory tiers without even forcing
> -	 * a demotion of cold pages from the target memtier. This can result
> -	 * in the kernel placing hot pages in slower(lower) memory tiers.
> -	 */
> -	mtc->nmask = NULL;
> -	mtc->gfp_mask |= __GFP_THISNODE;
> -	dst = alloc_migration_target(src, (unsigned long)mtc);
> -	if (dst)
> -		return dst;
> -
> -	mtc->gfp_mask &= ~__GFP_THISNODE;
> -	mtc->nmask = allowed_mask;
> -

I think this function changed in the meantime in mm/mm-unstable. Against
which branch is this patch?

-- 
Cheers,

David

