Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 594D2C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 14:19:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E0946B00AD; Tue,  7 Jul 2026 10:19:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3929A6B00AE; Tue,  7 Jul 2026 10:19:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 284236B00B1; Tue,  7 Jul 2026 10:19:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E3B836B00AD
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:18:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5E53AA046F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:18:59 +0000 (UTC)
X-FDA: 84962187198.23.FF11055
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id A4457120005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:18:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nmiYEDXk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783433937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ktqpqtiz95PjMFN81dPctsXJOWOULvpc2/aL54me+as=;
	b=kjBaj4qajErwm4QCVfSzKsIYZhEWrzxI/SZ7rtIlLvrI5WAQWj9yJ5ond5ZsPcZlVTx+zS
	Sq8s2xu40R7jxnFmVphvm5X/c/x5y3ZD7nLe7a5WGTNHMMt+/XqPfQMap5BsedR5Kvq3am
	vyH2RrWGPQXBapN7ctwS6L+vdGXenZw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nmiYEDXk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783433937;
	b=QnC3FytOStE/U/6dZMUnv4VCdqD2513d+/YyZS497E7tr4Qwld15M944K4s+STTEGKiHpv
	jbXB+CS0+SH3AmJPbEM/FwOxdm1524HS5TFdimrH8xt7kdxZD4PoU5uOTWzN0BG1VdhtLo
	qFmMZl2OIN+9j92TKqIUDH5eE+bng04=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D019618B6;
	Tue,  7 Jul 2026 14:18:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C254C1F00A3D;
	Tue,  7 Jul 2026 14:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783433936;
	bh=ktqpqtiz95PjMFN81dPctsXJOWOULvpc2/aL54me+as=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nmiYEDXkEZnSOwyL9BvX8iVgZm3W9BGDeHjceORW9SrFJc3D/Iqs1IIu73Xg36lUK
	 3sJWnyNIJNbPOHvhlrneVotAiUPcsKX3VdGovD4afEX+8CJ5KRVaogopZUy6WPVVdE
	 0olwgM1nHW2a9dY2JWdS0poCxRgSjomO394fPG3MWtxjzSD3LbZVyDmM4V+JIWWcYn
	 FB9oYXmlWOYGaSdF7WeVqjn6zgNipkrxq+tLEMOx+vYsWwl06FriYDDJCgBKyqf4KH
	 hEBOlReb1TwGqGEYNFi3dWZvzEDCV+g9Ym2EonfBAqq40HfnK5GbDjzak/vuHsFKa5
	 fYh2uO5sVRevw==
Message-ID: <22fb2f54-da23-40b2-91f5-aeaf54037bcd@kernel.org>
Date: Tue, 7 Jul 2026 16:18:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] mm/rmap: refactor some code around lazyfree folio
 unmapping
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 muchun.song@linux.dev, osalvador@suse.de
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260707121128.373192-1-dev.jain@arm.com>
 <20260707121128.373192-4-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260707121128.373192-4-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A4457120005
X-Stat-Signature: d8wurt6mdf3yw4669bqgrrisqhdp1sdp
X-HE-Tag: 1783433937-532239
X-HE-Meta: U2FsdGVkX18ImhA+ese1yrQXSbkBB6CsMNfSAqjnuwfctucxj/s/9cUY57kNJ7AewuaBjn1JT4YqJYo5hHiiyy8a0ohqMWqaL5lCrn+ahGcqke9F48NK5ATvPaqFdjMNEobaVnAjF5KQSCPFQxHm3XYZT/mH+Xrb1mvhpBfjZz8uf1o1y1YSfC0cTbmP39kpSx81dX4mi//bWgS2Y52SNN/0ZKVVsuo1WdLrOvwvxjzcTMftB8zaR9WE9o4LQjPTNv8ikaT3EMu89/2J197RCi8NDqb3nSmxZ40JxNR6i1YR3Z/ECDaikfKbpuTCawwa9i8ZX3ZjQA7bgKIFvsQOX8r3cUCiyhY9Ju385xe2E/6XjdK44Poc8/GiklE196iLmusZ123kCLVIowXSc568v+hNE/2/7JjAQx3Cr3I0BrAnIG39tciMEx1noxWDwh9qAwdSLXXltRtlleEPax0xk/NsqZOlRkcyN4JNF8GSUJVmf0rqHi0Ms+/JEoiq/zG/WpD/AtSxqd+5mDqP0rTfNbi5UQURggn5UI2fgazuFDn9uS5jMctuLRd8o4L3l10bhCrGThrYto625pvrJswiSHLSqSBNT+wrO1gn+7U4yYeE9pSZ392IZ5QyELFSs2NJvLX4HVG5qerPOz2UyGiu6zTIzyoNidk6LdRtTYyk8oy/PNTJNeQSWZuRU35kgzyk5PfdRWJayE8aktPOuHCttkA/aNJcBYGD1RmbrDwhytTUMIAr2YUJjLfWsQwjRqRJokkracyatZMWh4KOiAH7JRIKzl0ogeJJckZzE65zdWPBSg4Iu8CePFoNekPWu+AQs8BAP3FYI+Kg4kAA6c5lD4AyOLTE3Ok+REUGQp0nh1FV3g9kDijT/2euU6h9XJQPhZeKt8OedkTQLwiS0bf5nPmiwvsCNwSkmmg3Xs1OTsQexVlCJBhz1Hfrzb8Off4+8gP2kwyg7QGoiVy0jE6
 kh1rataw
 KU8jn4E1/0mOBtbUwYhcebUqCdSmCR04cR4c8+QBnZ7MQbP8xawgsUq7EtuSwmy8byGpL1SiFN1K92nIeDNUs1uPMs430UyFX/xQnRyVA59kRCLxchACGjso7iCY1wZT6uITrDVzft3mnLCxaHSRiYTVsBpxwxyk0DCgqZdeCte540VwF4Rr9soIUJs2rH37Lu5p83KZu46PVfdSj8cCkzh/oaiDgiM86ZwwD/CPrWHDA6J2zdZL77jQav/3OQIFf8FotuoqoNp/gpi9KAcQkUBOdZ3acrXE8fxJeZFtbjDfSIIOKkmaHZlUBiUDtlNd5CJzFtlp0+LDN+acq/FwrhwDuug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/7/26 14:11, Dev Jain wrote:
> For lazyfree folio unmapping, after clearing the ptes we must abort the
> operation if the folio got dirtied or it has unexpected references.
> 
> Refactor this logic into a function which will return whether we need
> to abort or not.
> 
> If we abort, we restore the ptes and bail out of try_to_unmap_one.
> Otherwise adjust the rss stats of the mm and jump to a label.
> 
> Also rename that label from "discard" to "finish_unmap"; the former
> is appropriate in the lazyfree context, but the code following the label
> is executed for other successful unmap code paths too, so 'discard' does
> not sound correct for them.
> 
> No functional change intended.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/rmap.c | 87 +++++++++++++++++++++++++++++++------------------------
>  1 file changed, 49 insertions(+), 38 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 934773dfa2f2a..00b571c2a1bab 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2067,6 +2067,52 @@ static bool try_to_unmap_hugetlb_one(struct folio *folio,
>  	return ret;
>  }
>  
> +static inline bool ttu_anon_lazyfree_folio(struct vm_area_struct *vma,
> +		struct folio *folio)
> +{
> +	int ref_count, map_count;
> +
> +	/*
> +	 * Synchronize with gup_pte_range():
> +	 * - clear PTE; barrier; read refcount
> +	 * - inc refcount; barrier; read PTE
> +	 */
> +	smp_mb();
> +
> +	ref_count = folio_ref_count(folio);
> +	map_count = folio_mapcount(folio);
> +
> +	/*
> +	 * Order reads for page refcount and dirty flag
> +	 * (see comments in __remove_mapping()).
> +	 */
> +	smp_rmb();
> +
> +	if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
> +		/*
> +		 * redirtied either using the page table or a previously
> +		 * obtained GUP reference.
> +		 */
> +		folio_set_swapbacked(folio);
> +		return false;
> +	}
> +
> +	if (ref_count != 1 + map_count) {
> +		/*
> +		 * Additional reference. Could be a GUP reference or any
> +		 * speculative reference. GUP users must mark the folio
> +		 * dirty if there was a modification. This folio cannot be
> +		 * reclaimed right now either way, so act just like nothing
> +		 * happened.
> +		 * We'll come back here later and detect if the folio was
> +		 * dirtied when the additional reference is gone.
> +		 */
> +		return false;
> +	}
> +
> +	return true;

You could simply do


/*
 * Additional references could be due to GUP or from a speculative
 * lookup. ...
 */
return ref_count == 1 + map_count;


Nothing else jumped at me

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

