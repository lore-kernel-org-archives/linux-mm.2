Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FD66C9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 14:44:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 355B76B0098; Wed, 23 Sep 2026 10:44:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 306C26B0099; Wed, 23 Sep 2026 10:44:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21CC96B009B; Wed, 23 Sep 2026 10:44:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F1E656B0098
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:44:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 76C3EA0878
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:44:27 +0000 (UTC)
X-FDA: 85245297774.20.D181468
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id D9D57A0009
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:44:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jbBUI4ka;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790174665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k3Gj1KoHBPW+MMBGRDviu/+7CrZBzX4/UWALlX64Nu0=;
	b=le4iyuvm0Hwyw3XvmpQvgUXb0127S081thJ7AU6Ni4wotVXr3W7OzIrs0ayqQdw9PknWO2
	CYi9YThVpFL0TDBSnMyh1oEz2qW6p6/mBhrBV9IaeBot9hvU4Tt2Z0iE0PpySptPy6X4fz
	xk11GovcsZPkKEpkGgNmC0mwrtqcjAM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jbBUI4ka;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790174665;
	b=aYDJOoyE4443culblRgODp08akSAIM08TyxulCN7IP/vUmJZ164liHFQVl3sYzZGEC+mUh
	+zf61Fza4LAIfN+7XdEtJaxmYXbpd0gkKX5TqkJQGAKnoHhrBYGfaI0B9nifKh2NP7gPz9
	ck64+Z1HevoPNUGOJOsOzIaZ3oWLO4U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0E3E743FBE;
	Wed, 23 Sep 2026 14:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399D31F00893;
	Wed, 23 Sep 2026 14:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790174664;
	bh=k3Gj1KoHBPW+MMBGRDviu/+7CrZBzX4/UWALlX64Nu0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jbBUI4kagBJZFjXRhOfX2EXFsjw6WlIu8M3clwVpeBlyETtojNU73lDbB/VV878zs
	 2g/G9k/FSrL9yY0Mn3B7sK/Ll6LmbePnofTrehDk0gh2YzTH0vle0QA0Br2s5EG9OR
	 x+PWdZ4yVVX6ZYG66Tb5Z9OOt90KtC1mcf9kgi1GXDNzN+1RN0d9VqqQRObW5ACWx4
	 yfpjcFj3EoC4DcmwK7/xQxmtoe7VLZ7gDxNqcZ+9p0b7wjoA2l5ZcVnRTQgn6w2Mki
	 vmHxeI+MPs72HMzARGJGlcC6mVY6BXTjVjPw70A8Ug6rqrwMylmOhesyAg49/+1ftH
	 bbLOpVODsaErw==
Date: Wed, 23 Sep 2026 15:44:18 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org, 
	liam@infradead.org, david@kernel.org, vbabka@kernel.org, jannh@google.com, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org
Subject: Re: [PATCH 02/10] mm/madvise: name the shared LRU PMD callback
Message-ID: <arPhlePckOPx1r6c@gremlin>
References: <20260922235830.2350770-1-gourry@gourry.net>
 <20260922235830.2350770-3-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922235830.2350770-3-gourry@gourry.net>
X-Stat-Signature: jazsp1wsjxe8eunhf9fsjr3rm6mpy6an
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D9D57A0009
X-HE-Tag: 1790174665-782305
X-HE-Meta: U2FsdGVkX19SaM7H3767uwo/EhHnxEeMsihnH0o0oyWqDmGramR+nxy+alVcQiOpOLQ/9zTNqSrwRuNYEwQ7MhmzzUkpxrh8EW/uwC8SX2nH2T5jJ/PtYQQ34oOcV9GzQgn+Kes2yU19QJAaEUL8dGG+Yen8GTrzRg90TL/DikqETeDaOfXOQfwlu9mEWRyd3q13CzhvQ8AxuLYaIMxh6GS5Ds7ER6CsmLPuCQ/WKHBxJii74UudeHoGqf970sE4Om6T4DAG4L9NuG3DD9qKprekV2Zg2IYtgU/qyjXEZn+4lbrp1yjwY/KNCaHMp1+LfPXDeQHREuC/x7oSrvqOBubdkFloPA3C6R/OYvghHAQLuxWcwKZDy/pvK5qDX2zxNgafidfENlOJesxOiKt856pDwVBLIgMov0wiQzyZUB9Loz4UfsI0MXcaKr9UpH1wXQMeNXr4j6AqoJJ63l5mgfSNgTC09oR+T/jPzJk41RPF49yEBWNMjyRqKuo7NxFGWWz9tK1XZOxHxtyp+125PrXJrr4/TZGzTdcatJlc9mjvecr5T6fScMudb0eAGl8jqO7+x9zVLU0Q3mEtXgG2/oLBumX1iyTw0PZrmLeor03mEwxn2NUxuMH28CTLxfvlUvhl4C+lBP1RDGKuyjCPbDZU2T3ZHrfncoJC/A8vIsf2BnRnzi3pVvUA6Rbh58nIDeqSv59tz2+uw/PuXnKwMVZVeHyTWRBV99c4gDWpEPTwVIiCRzCMuWZeUhQOGNK3EEHmiqf/N8GL822PnS1poHmKr1FOn2DUuyj9TUt8hMQAAfoCXFwr9pC8+41PXwjPfXtorPaJZ+yZykgjRTVYkHLuwoITlpLCUpxFjEqnU1Rhhn+avC32a2n6ieRaQuJDdzYXsjmsEUJ0WHBdi/Vs3lOwR+M7zNE+fsGnIjGXrqJf0T5upQoNCxT/NbmVD/uSJRPlCeVuH2G2gF93jsd
 p1dVqaSB
 Rm7PXZvujz2EakyvCaAUcJBtGukUMb7S40ai0htAnxyJLEpHdZig/RABM9+LNJI5x03AWlAUDWAsr/sytDlj/VXTZeekVn8aXPj//WWOye8h23qldxndNYCoAQEdyJTwdVuJevf9bJTBbUuo89kcHbDmlZUfjlV0B46macECkHyo7OAUxI/J/NgHE5HTyuxX8e15ZkrnC9f22fGKNiaHVCuhUAm1XSOeo4kUMeENmwlC6JLy0uZUX0Xtrjn7XjFqjjz5qDMW9NPIGyU/vOU08GDKfTIAB+ZeNic3Qg7q4+VFw6UVPw/NHRAQmYnJ/las1VgP9+GotlcIOEbWQ/eF88aF5xA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 07:58:22PM -0400, Gregory Price wrote:
> The MADV_COLD and MADV_PAGEOUT page-walk callback is named after its PTE
> implementation even though it is registered as a PMD callback and serves
> both LRU operations.
>
> Rename it to madvise_lru_pmd_entry() before separating the PMD and PTE
> paths.
>
> No functional change intended.
>
> Assisted-by: LLM
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>

Oh yeah wow I was thinking 'reasonable in that it is the PTE range which the PMD
entry spans' but err, no, it does handle THP PMDs too so :)

And LRU is a resonable name, it does seem to me that these are the only madvise
operations that qualify so all makes sense.

So:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/madvise.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 00b1be655a8b5..83d54ab385da8 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -361,9 +361,8 @@ static inline int madvise_folio_pte_batch(unsigned long addr, unsigned long end,
>  				     FPB_MERGE_YOUNG_DIRTY);
>  }
>
> -static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
> -				unsigned long addr, unsigned long end,
> -				struct mm_walk *walk)
> +static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
> +		unsigned long end, struct mm_walk *walk)
>  {
>  	struct madvise_walk_private *private = walk->private;
>  	struct mmu_gather *tlb = private->tlb;
> @@ -581,7 +580,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
>  }
>
>  static const struct mm_walk_ops cold_walk_ops = {
> -	.pmd_entry = madvise_cold_or_pageout_pte_range,
> +	.pmd_entry = madvise_lru_pmd_entry,
>  	.walk_lock = PGWALK_RDLOCK,
>  };
>
> --
> 2.53.0-Meta
>

--
Cheers, Lorenzo

