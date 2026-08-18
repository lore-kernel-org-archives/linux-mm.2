Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A37A1C5DF67
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 07:20:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 827EE6B08CB; Tue, 18 Aug 2026 03:20:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8009B6B08EF; Tue, 18 Aug 2026 03:20:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73BF16B08F4; Tue, 18 Aug 2026 03:20:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 504C16B08CB
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:20:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D79968064B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:20:20 +0000 (UTC)
X-FDA: 85113541800.03.8CF9689
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5895F180003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:20:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787037619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BbMueGs3xqoCq1zuqCds/NOGUNOzg/1Vmvs7Cc1zyow=;
	b=kw/+qeJtwTk7QP4IbZDSwl6/6sdEwfKnPvI5YfIj0sglBrllXh61eXk/bMfX523L45IJCu
	5++8X9gl3iBuRCX6tom6bo3acuMctXXr/FVUIBClbTNyT30kSNgRjSThcrvJTkHKLoIVaB
	eej/Bk7U1vlEeeV5bGvQSLmsv2iu4PI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787037619;
	b=uByMOUqt+7DbSTzOri1hcrFEorSCDzuVOXQCxtouYDVj9OO2Ua3oZElEAzvSFLtbr5rWPi
	bvIuH34G7NDke1HZwguguS4KGQbH01Hom9Nn5TRukxhlYEW+X2a+tx7EmUPV2+m2oK3DWp
	re5IGjpAXHmX2RVkdP4YkMjFIzddMtI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C56FF60204;
	Tue, 18 Aug 2026 07:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2750B1F00A3A;
	Tue, 18 Aug 2026 07:20:11 +0000 (UTC)
Date: Tue, 18 Aug 2026 08:20:05 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, vbabka@kernel.org, 
	jannh@google.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, balbirs@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm/mempolicy: skip zone device folios when
 queueing folios
Message-ID: <aoQHgUBfTqChH9_-@gremlin>
References: <20260817220810.1175596-1-gourry@gourry.net>
 <20260817220810.1175596-4-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817220810.1175596-4-gourry@gourry.net>
X-Rspamd-Queue-Id: 5895F180003
X-Stat-Signature: gj4bo7an4ojsj7sfbasekeamjf74z6bk
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787037619-44481
X-HE-Meta: U2FsdGVkX1/bCblv5HMgMZQ7vUoCmIMxCrm9BeIqheOeWJmxTfiMRJMS29KmRMk9eqFzsgMacd/erleIO202Af/ochAvkgNyiwODzotz+YqFgVNSCF8+PuN/vkgNIrcuhXuudQAu4qIvVtJYrCKTmaGc6LGfqYu74RmC+Qr23c+1A82JukarTqv827uyt5mCzKGnoPPJPHftRKZpnXSoWEcvIgIc143bq8Wzfpz9J+rG+jgvhlRH+UXbe817DvL3JoWRvCim6mG1umGDjClcyWymNMhAhNWWYX4b7/Q62PMwqX2v2bDDJz0Tt+GF4ZA+SFwqvXRmSqn9WLERhZ2SPKm5V6a7LkJF+8MNxNrKeEL6L80UTrDrzjgV7fTPbRnrBbdcGTstkmOho+TeTUB3eAzHiGi24UttS6iefs7gIA/Xk4IUVkLIlqeb3dtNXTsf8V3McdK6B4PZd9z2BfUC95rEw0c9Q30nTqt7gM00A8zr6rjNbCqO840D0rSUIwVjczA7vI1psc9dJMl82H90QKbnWOJu+IN/3pnmwltM6uDreKZPGZGQLDbw0eG8RtkU693EJb3DID8oQU3+P5C+D50gjSCEaHhIoEPFQLNlOkrplwlxeoJZRDbSoIWg8xZQ93lhvYeOxCPYrq6uataIsQlaFqgAJQE3R1FEH+lZsFrD1A9jdLD6F11904sNdMR/0tVgM1GI8LOR1lXv2Y2LWatG/pTRITyDn0VkPrCK2VuepRNrhg/CYdolLzHNKRm3SWvoUpWyHv5EHEaqISAOidFIE0OzwTaEKzTr5xPQIdKXMeUAd4tYxL0FrL4tthn75JHOKJuoPxB6nqoKexakFaIuXo9ASZl3OlHT9AQDO/fSxq8hCxyBKpG1sAG+KRaa5A+/LbbYAyuiWlZqCpl6DyZ/EgzZ2ctkT4ZCV6u3Lb59H9tGDU9h4PMFlS0SQxsne77Pv/wQPg/RFcO+bIx
 EYiFLxx7
 04QXhZIs6T/Cyz+0b2JM8+JSQQ3B2T0izlmfj3nGjjeZKyU/0qEGySak9VBzC0cb0+VX+59FFwGvtR7mRU3UvqCvv6nLso/yQJNuR7SnEWrgqKdo5d10z5mteRKfZUPSyvoOdvrfwxTvOvTFWQj7I4TTcjcEXi/9rcDRRixIhA7kMKeBGXG7TYZong/qlNHPUunXVm+qzfFkQ5+x7DiqCAZZbIK36Q/CnXB9NGqTrfii518cgFGWKmm79JywWOyaS6cBI9CVXWF041TJ+GrMoCgt8kczq1Hi3AtUC4U14Y0HH3R8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 06:08:10PM -0400, Gregory Price wrote:
> queue_folios_pte_range() already pairs vm_normal_folio() with an
> explicit folio_is_zone_device() check before adding folios to the
> migration pagelist.
>
> vm_normal_folio() alone does not reject zone device memory (a present
> device-coherent page in a normal VMA is returned as "normal").
>
> Mirror the explicit check in queue_folios_pmd() as well.
>
> queue_folios_pmd() uses pmd_folio() directly and can encounter a present
> zone device PMD - e.g. a device-coherent THP.
>
> This is not filtered by existing checks:
>   !pmd_present()   - only rejects non-present device-private and
>                      migration entries
>
>   vma_migratable() - excludes DAX and VM_PFNMAP.
>
> The early return also means such a folio is no longer counted in
> qp->nr_failed under MPOL_MF_STRICT.  This is the same pattern used
> by queue_folios_pte_range() (skipping zone device without failing).
>
> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>

Seems sensible so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/mempolicy.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 3498a5651d50f..3418b5664dcf8 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -662,6 +662,8 @@ static void queue_folios_pmd(pmd_t *pmd, struct mm_walk *walk)
>  		return;
>  	}
>  	folio = pmd_folio(pmdval);
> +	if (folio_is_zone_device(folio))
> +		return;
>  	if (is_huge_zero_folio(folio)) {
>  		walk->action = ACTION_CONTINUE;
>  		return;
> --
> 2.53.0-Meta
>

--
Cheers, Lorenzo

