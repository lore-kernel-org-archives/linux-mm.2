Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89F7CC5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 18:36:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0E396B018D; Tue, 18 Aug 2026 14:36:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E2AD6B047D; Tue, 18 Aug 2026 14:36:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9213F6B06E1; Tue, 18 Aug 2026 14:36:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 72A7D6B018D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:36:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 095681A02B3
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:36:21 +0000 (UTC)
X-FDA: 85115245362.16.6514F49
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 728BEC0009
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:36:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MyHq7W5o;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787078179;
	b=PZbKnQY1kys/0Ks8t3e20njh31pF6vCqrEXYmQFoD1/QPW5RjYfRlVXn7IdA8RvALuih8f
	7N8UERPekniMaVdayB1fdhZHVZPUhxBwhhvinuGjs4ciRejjFUTqddIlnZdiyl66waOvO1
	PHxRtWAVISyrf2wQXnV/lYn5FMp6jjs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MyHq7W5o;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787078179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gLXr51pEzCHb64ANlWwZ4uIr0YOOxG5gL44VOYDF9ao=;
	b=WzjKGUHgQeSZ6EDZ+2j/lCCDOgZdlVAEiFpN1kBi1zLYqkdXjNu/vSeWMdaqyw73Dh+T0h
	p8zrhUFZnpBLxhqoWGHV8s2tKV7FArEqeu8fqabHvH0qBL3KewtoYUc3Fan0p5xxAOezwP
	q7g/ljZDE54nf7e6J7nLnVvKF65W34A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E60560A58;
	Tue, 18 Aug 2026 18:36:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789A31F000E9;
	Tue, 18 Aug 2026 18:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787078178;
	bh=gLXr51pEzCHb64ANlWwZ4uIr0YOOxG5gL44VOYDF9ao=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MyHq7W5oDXYZnvecjeNJ3DZ4zGEdUDSeKFlocju1hBoH49qYmq2UB2kWjY47Bspna
	 v71OzKQV7UyMhJrXBXs72BTWlIsYj1pZ+ft6/8v4m3lhrnjT8E4LOtKQutuDjcJ1+C
	 vP25TI14lVPJzISwlnC7liKSjZZLx63tpGPmb6HyIsnDzBDZrS0CL5ivipLLt23szL
	 rGV01JIl+ySkp0uSY9SRGXtENONcVandoNltQv5274MbIaBvswX1esEmibPYjNNaU7
	 jqSDg216CGrXCSL60EnQs8GdYYKEexrbR0EbGpVLjUV9+B7gpTMow9I1j5foVxFzwm
	 pyGmBHIGJz6Xg==
Date: Tue, 18 Aug 2026 19:36:09 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	chrisl@kernel.org, kasong@tencent.com, ziy@nvidia.com, linux-mm@kvack.org, 
	ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>, willy@infradead.org, 
	youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev, 
	alex@ghiti.fr, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com, 
	baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>, 
	lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, yosry@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v6 01/12] mm: rename pmd_to_softleaf_folio() to
 pmd_softleaf_to_folio()
Message-ID: <aoSlo79B1iDIPfQC@gremlin>
References: <20260818131202.494754-1-usama.arif@linux.dev>
 <20260818131202.494754-2-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818131202.494754-2-usama.arif@linux.dev>
X-Rspamd-Queue-Id: 728BEC0009
X-Rspam-User: 
X-Stat-Signature: pxdp5sr96qqeay7yxdsec44u5ghwfg6r
X-Rspamd-Server: rspam06
X-HE-Tag: 1787078179-850000
X-HE-Meta: U2FsdGVkX18VcqOI3w9XouauYoiMDflqZyJgj+hen4fArgd9JDWycD/mf9U2ypi/Rzo50em0VGHYbcjH0dw3liaU9zV6BagT1AI/miWc6a+ikHlw31BnZDuIT53f8M5yC6kHq4PkeOpgiLZa4ud4F5xkFdzyNuzLFNu0FzfJvjr8vElSs40gDBA0XLYT2wBdlcQSTIDwsH24G0L9BH8BXxyxcztTjLXCT2/vHYElStVLcQtEQYezjMlviID0EznIfQGLGcJeHigMCq5qfyG9uRr9EK7KLq9tvR9rGMzIzKPE2gycvIeJORbxY0I3yk5BYduz+S6RUwu8TychpNCJr4PS5Z93+q31q97bV56na8xFHoVE73kGsaegiYO1vIMLzO2E4g4mqTMn9atMuWJHgtG46ZxsUitEGHeaxKbNAHOIn5Nk2MsyvqG1IqYojI2ES6l8vAMq/eKThLrM8HVn2Qtq41pxkXdjfmbGB5G1254Fh8VxhIDAM1dxcuSHUzj0kZ1eDmkOXYm7J1p285udwXqV3Wp5cAqNFhJyU69arVSPwmfApsTV8qe0qw8ajCNT5ebOmRQLpLZ56wcaa8+FTeKpYOvEGooi8bfyVYl9RiluITUDsDbPWAOyog+GOcR6ZYO9uau6EQ67RjhRx6/jAZ9WhlFU2Naf9BxQ6uGKemequXfjUwMPpYKvbIaSJbbOkBtaGKx8uhHyfWBam1GHOrPhfBYj6XTgCESKZvWBXXUPvEXaUbEMO9fYw9ak0o/CoaGFX5Pj8Zi4H3h0QU04AlC3u6xBE3Xwv4Bd1v9CyM6syft1F5iOEvE+CD1wF0I4+dKDIMeAAQrlrCZW96T8jfFeU7dLbQ3HXkwByAbojNj/bMwKMVeK5ucyG62vkyYR2p4tkFGB8d3EbsRoiCBXYdBLBuOchgX3TFQiwxh9sUUCDfTAvwyIf/84ythCInOvocrrkgsH45QTSh3bH8C
 VqG2JVt2
 uj+AlrI6qczKwjLhuUrZxNfE1mdhKNC+xFtxe2hKRRu9al8S/8H5QVZoRWMfgZExeDY7H0DFw/S4++YLhsetq0moLrQTU3+Y7g9iZQK4UMsddOIKH6pbD4S0AsrmkBdd1ji0iQXBibzWd1wSRwgk3iJXp4ZNug+StfTBeyAAnbHgM4retjJSxh6nexSpCy/QpRF18KNzRsyJZvdMmLlURGizgNVVC31fod87lQAt50bW8UVBRlMrE8LagET6Y66dUnS+iLUep0rW0iLbwZ+XTLJ1zoCwBFh/fhHXB2NBsqN+xoIorWGzPBYy/0KWh0JDoetGqWHGjRTgyeJkwG+SpHUEgmLtyrsZRdVHrbI715KDOWZ2bJXSq/Dq9GVcqUbYVL3gj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 06:09:42AM -0700, Usama Arif wrote:
> pmd_to_softleaf_folio() converts the softleaf entry encoded by a PMD
> to a folio. Rename it to pmd_softleaf_to_folio() to make the conversion
> direction explicit and align it with softleaf_to_folio().
>
> No functional change.
>
> Suggested-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Haha OK fair enough that's a valid correction!

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/linux/leafops.h | 4 ++--
>  mm/huge_memory.c        | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/leafops.h b/include/linux/leafops.h
> index 4c1476ae32343..7c13c58a5e218 100644
> --- a/include/linux/leafops.h
> +++ b/include/linux/leafops.h
> @@ -657,7 +657,7 @@ static inline bool pmd_is_valid_softleaf(pmd_t pmd)
>  }
>
>  /**
> - * pmd_to_softleaf_folio() - Convert the PMD entry to a folio.
> + * pmd_softleaf_to_folio() - Convert the PMD softleaf entry to a folio.
>   * @pmd: PMD entry.
>   *
>   * The PMD entry is expected to be a valid PMD softleaf entry.
> @@ -665,7 +665,7 @@ static inline bool pmd_is_valid_softleaf(pmd_t pmd)
>   * Returns: the folio the softleaf entry references if this is a valid softleaf
>   * entry, otherwise NULL.
>   */
> -static inline struct folio *pmd_to_softleaf_folio(pmd_t pmd)
> +static inline struct folio *pmd_softleaf_to_folio(pmd_t pmd)
>  {
>  	const softleaf_t entry = softleaf_from_pmd(pmd);
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index ced400f72d43a..1b6b0aa2baa3b 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2467,7 +2467,7 @@ static struct folio *normal_or_softleaf_folio_pmd(struct vm_area_struct *vma,
>
>  	if (!thp_migration_supported())
>  		WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
> -	return pmd_to_softleaf_folio(pmdval);
> +	return pmd_softleaf_to_folio(pmdval);
>  }
>
>  static bool has_deposited_pgtable(struct vm_area_struct *vma, pmd_t pmdval,
> --
> 2.53.0-Meta
>

--
Cheers, Lorenzo

