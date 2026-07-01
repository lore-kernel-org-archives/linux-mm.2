Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C95EAC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 19:40:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EC286B00A8; Wed,  1 Jul 2026 15:40:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59D096B00A9; Wed,  1 Jul 2026 15:40:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48BF36B00AB; Wed,  1 Jul 2026 15:40:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 139276B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:40:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7AE28404B9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 19:40:51 +0000 (UTC)
X-FDA: 84941225502.12.ACDCECF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id A3E55100010
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 19:40:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MrwWnInB;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782934849;
	b=z24rI4lmJvSWGuXGRqLq81mjvDwHs5lue4QpPYfWWS+7bSSUFNyqBq4gX++GRoKqvzyHzP
	XXg7c855LTlYtqWYvML9AJsFHXGheLhxvT4ay7Vh/Fn8mPhirKrSk83vv/iV6S0h0bvwzh
	nRpWfwVxtotgFUWwUCsrWcUTx/sIx8Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782934849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DflvHjH/owJ243aBh1KagQ+6z9OHZJFtTGrR2WDjRkw=;
	b=PCNl87jciwuk93nU0Kjc9yzLx88rehMgpN/FN0bSw5xwoPV7fcd0ZI14shvXV9FWYxzyvP
	Z22dvprurX5n5GjrGiinuzIzxH4141IPDFG+u8Js3Ymq07NPsA83cIWvNeyO21Km9VVZgi
	cJsdbqwDv8yQYueCp20rTWfQdEajLWc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MrwWnInB;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9408643A8E;
	Wed,  1 Jul 2026 19:40:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7E41F000E9;
	Wed,  1 Jul 2026 19:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782934848;
	bh=DflvHjH/owJ243aBh1KagQ+6z9OHZJFtTGrR2WDjRkw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MrwWnInBBUNl7gCPLF+dPg+VaCZJ7bsA7hf6R+/VtPqYc96Q319RDazNIwOrC1T33
	 phja8g+eCEjvkG+kXHxRd295SLnnlI6WhNxjdEH2Oeqjq+lJB2x6bUQkrAg9oIZNS7
	 KN13HE9MpegDxfV1JngnEg6iFgRD8h3JZ3ofFKOeprlO+npkWm6tncy1UjOwxprYx1
	 KOeCR3QROXNLJlIzbOWmbeI3uhOzgNZnpHoYiOigmpQ3yJUVZ5ZjD1otoGvtDgFUbm
	 lSPxwQJfdKeP9/QjU7mXrBbg2CTIicjgVJUF90s5OBjHfNeuwIblgC5AKHZQyK8zZB
	 lUrYq323RJlzQ==
Message-ID: <b7b026ea-2a1a-41d6-94b8-3fc215dc2d1d@kernel.org>
Date: Wed, 1 Jul 2026 21:40:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] mm/migrate_device: move softleaf_to_folio() inside
 device-private branch
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, kernel-team@meta.com
References: <20260630164143.1595669-1-usama.arif@linux.dev>
 <20260630164143.1595669-6-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260630164143.1595669-6-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A3E55100010
X-Stat-Signature: x11oipneg4gr8c1ian5es3nim3cco68s
X-HE-Tag: 1782934849-810663
X-HE-Meta: U2FsdGVkX19kzJPQ07Qg7Hs8HY7tltUm1JjFzdje+eAKmA5xx7XIdieZe/uHPFdXv9TtD8BJnSOvz1F/0k+M+95PEPNfbuv8JPYYlK5/dDCYQsmxQ/+Ijx421xuQVrN//ee7NDgEk7QJFz+JPqYe5RLeKQJpv4yLvFNa5O/VNctywKuF2sA+KPKcLWH65DAD604Lv4aWRR+bfVfQDd4Wqvfidx4QLJDzsaOrWegtGmfxOGRvg9X/lnsnAfyD24zhYGEGUj2HADvDKCal0MjK2uTMNCmvud63+pYWT+b2bcIUqQzwOyyusG5qIbw7iVcfN87GcQtxyCf40ubFI/FTM2SJlprLRtla6EN3HOmxG2WPvo6AvuiygWlz09hTwZSkcsrbqJmhFFLSJauy7epzAwVjdtt3BK4sVnsvHosNIhbXyzh+B4mX7TmnKiCavv1puu9UgC7AfR0zw71bK5D2Gxfk9T4WswFqDFe9qKAJ69K63YQRUkgCVpJm76jv5xvVujfiWXVqNmKDhESJshWLvH7SIa+1sqc0jdAVW4+vnkzkIvn0cHX+9llOuJc5bySxwmXYrFWl5jFp0X4KhGvmd1u4p9TlG5SJXP86UjcKnfaxzlkv00Ktw27qtfeI/d8LiGj7tpoMVmg9PmEjC1Bq6RAlB1clor7GKTH67Izdes5UH3vUrEp39A0PcD6dyEShUJ7QG2UHWhCf+BOyHdQfwazA+xKyxChi4WyLd/L6UTEtC6r6WKlAhdjrNXR99/uOrpyogIOmhbd+W81O8QdL/xvds0HCeV9PEGHDQctSNHcF+2hC0NJhIjxI+qNC+e6HZEKJimbvJuMrhUmSuYtd0OQYRlF0ES7bPGdH8oumZFNxuET0y3IDFUGRnuGe2acaWKyuv/+9usf+8EjUBq+gYjuqDzf6gvwjYR3strgyaT98pIuHsv/2bqYm8MohkEgJiJqYoEUCoxHyBPvHX+y
 RU4owVb/
 MLy9Wv0dxzTxJN2O5snCdQygylXTq+5vnUcIGFmRFGs63zPcNm/71MovDxTWn1shw2XTKph99XucJzXDnGzVqtRTUy8zGxVMOQeVMyal4zX9tD0BOKY/fq4+92RZH0Putt3A0uDaKXpuoO4nJI9T6U0R0qS2l6ymsqfbFQWFPec4tK44LsB0gLHClcqLK36ffFindhb67Fhk7WtexLLn+2XJ94c9mu+u6NRPAieBA4aorIO/d+VJ0zJSJtmWnMBDCOUkxp27yDn89T1JhQxEScJuYjARlI0WNgo9NtFqkuzFgtdXtU0F8KOdoYTgHYOq9cxE5YXIuWGZUNAhxjxumgvhrsF2RKg+jw+gJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/30/26 18:34, Usama Arif wrote:
> migrate_vma_collect_pmd() calls softleaf_to_folio() on a non-present
> PMD before checking the entry's type.  softleaf_to_folio() converts
> the entry's offset to a PFN, which is only meaningful for migration
> or device-private entries.
> 
> A PMD swap entry's offset is a swap offset, not a PFN, so the
> lookup would either return a bogus folio pointer or trip pfn_to_page
> validation on a debug kernel.  In the non-device-private path the
> returned folio is then unused (the OR short-circuits to
> migrate_vma_collect_skip()), but the lookup itself is already
> unsafe.
> 
> Move the softleaf_to_folio() call inside the device-private branch
> where the folio is actually needed, mirroring the equivalent
> change_non_present_huge_pmd() fix.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/migrate_device.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index aa948db49501..36287e958b2a 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -166,11 +166,14 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
>  	} else if (!pmd_present(*pmdp)) {
>  		const softleaf_t entry = softleaf_from_pmd(*pmdp);
>  
> -		folio = softleaf_to_folio(entry);
> -
>  		if (!softleaf_is_device_private(entry) ||
> -			!(migrate->flags & MIGRATE_VMA_SELECT_DEVICE_PRIVATE) ||
> -			(folio->pgmap->owner != migrate->pgmap_owner)) {
> +		    !(migrate->flags & MIGRATE_VMA_SELECT_DEVICE_PRIVATE)) {
> +			spin_unlock(ptl);
> +			return migrate_vma_collect_skip(start, end, walk);
> +		}
> +
> +		folio = softleaf_to_folio(entry);
> +		if (folio->pgmap->owner != migrate->pgmap_owner) {
>  			spin_unlock(ptl);
>  			return migrate_vma_collect_skip(start, end, walk);
>  		}

LGTM

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

