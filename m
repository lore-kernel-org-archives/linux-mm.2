Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81942CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 08:55:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7B3C6B02E1; Mon,  1 Jun 2026 04:55:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2BC66B02E3; Mon,  1 Jun 2026 04:55:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D418C6B02E4; Mon,  1 Jun 2026 04:55:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C384C6B02E1
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 04:55:06 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4ACD1C17DA
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:55:06 +0000 (UTC)
X-FDA: 84830734212.30.8D40FD3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id BB204100010
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:55:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J9ThDFUX;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780304104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rJSMpk9HoXFtAyVKQEPd/j/LZtGmra81xUby14aTssE=;
	b=vTINyzpKwdY/uQaKV2GlJgnwhiElVrrERSGLaAwmcbiRkQW0g6uVY4Wf1670lRg3NRzm8F
	yUT6+w4/LnryD6xFFId5ZmQvlJXjQsVn9IzhHur1X+lisDDuYkyflZ9Gdlnl4lg28xISEN
	r3UZt9U3IcETWoskqI8stO953kuT+4k=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J9ThDFUX;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780304104; a=rsa-sha256;
	cv=none;
	b=JU6L/CZnItIiLC+3+WQl5b8PGHWmlhdplrNmOtOD63fKLrhjuXoNO27aP1Aia9kMJN94HA
	IXkFiinDROWxHTCaLe0Qa0XmAhWYe+Gr5Q+oeREOCBN2HuqRt98lZNvEChUFwf59W04Tuk
	dm7nl2GX0yRCv28az9OEU+D7qpF1/A0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A31860018;
	Mon,  1 Jun 2026 08:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495751F00893;
	Mon,  1 Jun 2026 08:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780304103;
	bh=rJSMpk9HoXFtAyVKQEPd/j/LZtGmra81xUby14aTssE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=J9ThDFUXTZvMVfDGZD7cVi4fk6awr1W/B1+llsneH8o8QSWQeeEH2/rJzbwXvYEEz
	 2HwyF4NbfepBEdKNDuRTELNFg6/acVdg6R5yAVTMhmy03OS4jC9QaG+7EKlO5TYeYd
	 3NiG7LjFGXwRlEP1XGlng1Mz99TrglE8ma5xQE9C/LbYjZZcD3UNgp2Dk9/kEwYd2Y
	 kfvR1bCI7JCpjjbeZqK/qiOWKylN8VX1HjM/HxaOcsLnf5ifgjppsLfzgQrcXY7B38
	 0w5x5voyYTOBiv+7TWzRW1jXbDHOSEGkshSlZfBDqqt6M6WO839xv1hs1y0iCYKW5t
	 N9AwlJdCkY/oA==
Date: Mon, 1 Jun 2026 09:55:01 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, SeongJae Park <sj@kernel.org>, 
	Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes] mm/huge_memory: use correct flags for device
 private PMD entry
Message-ID: <ah1IrfWfJuK3v5lG@lucifer>
References: <20260601083044.57132-1-ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601083044.57132-1-ljs@kernel.org>
X-Stat-Signature: h8brkpyd6zjmzykigemyrg9q5gjwo6y1
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BB204100010
X-HE-Tag: 1780304104-769891
X-HE-Meta: U2FsdGVkX1/0z9J3ATRSQll9uJxV4Bov2cDlJNbB1mpgKWw7yzrvz10hh2n1ZXtCiTp1mtme4VfNyoZr+5GfKakFgxYmAGsqfsTKdDLTo1z14rqcVvhl6xAUxaQrHf2gtm/CgVa9c4KlMIcuc2I95TWA3WP8h+V6G8HLaHm8eqpmlPEB2ElzbpHQs6JOSElTxinFG/rnkMI26VVpAmbYorb+6ZO0TywWQcgfWEioP+oMdaftIxRd9qkl09h5UQCXpW/NOWc5oE97f6X41GJtZFdKB6rGJFbkwY/POrSyEHgGUSE5YcWztuUs2W3Pm33OqQC/7hrqbJ4olFBiwAL1+ms5sxxuvhHdIT7zJxIozJgdnVLNJItf6byHnKJBX8+2GU7jBUGVthSkfK4HORhV4Uvk0kc0aMUOy7/21R0Hhacpl76XBriLLXJqvcrnjwXupy8AeFfS/zdlh1vyebBx+Si+AC/RwtbHzxvAHECASr38b3UbL/LahDVrjFkyqUV2PePsXzqm7TZIFvOT+0L0tf6qEML/nIlB4E1B2NDM41PWjTdSUFOwYAHjcgt0O8hxg1ZfD30BCSyZrfAql8Kv4rgcunNAujynvFJq+d3aPiF12QGy4OmNsY5kQ2wkB7jx/n1w1lEsYc1UWDJ+Qb8kT0lNT/nQFUDcVam59F5o43pZEjiXcvfohUprJH6KwMLF2vMHI1/RapnvLugDjLGYDaripHCWxpzlq5mmYexHh/lVnLJBv+iJuIE3q/8pQgjYl6VKxzi5Sak6pbibqOIQl8MjWFefCGIeJpnBlk2AE96hSZDqWGGBYWBR470cO46TUtzJclJFTpRZiDbGWtNyPQvkr+9OF0kzWajXuIVO9hw2FYXstE9qjEbwN06lcghP3CIyJZGVRWm7eooayzUJLTAAJrM4ZqiHIdR6Sbf4fkz/pw3TfXd7w8TI0Mwj0/k/cyNP6GbYwQwwc5FV/ze
 h7M+mqIl
 twgtsZ6VcsZwOyS4AK/CPzr+DsjzBBejHOZSEB9vYKlkY6j3N+KVv+utxbovrhEB9+FirTVXP+d9wLFA6nR5J+/xKMjvNm22r/xVbhnyUoY6lC1pMJz0RY/ij5q3zDAYppGFNReXSddU4DGsCGmlVCkg0whcxxSNgVuYDFRCJKifHt9pEdq+4YHKgEu4AhI1Qq6W0Y2GDg+E7zmmHT/G4B7iXvaj7PBob2F6zv2vmDYPUY9TdIZHQGkS5N7NFkIEwryxwbfPyw2jxObFZj2bL9ZQ+XxlBUlfg4LCSk6OllNlBebs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 09:30:44AM +0100, Lorenzo Stoakes wrote:
>  mm/huge_memory.c | 45 +++++++++++++++++++++++++++++++++------------
>  1 file changed, 33 insertions(+), 12 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index bf9b480bb3b0..79463c709c98 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4982,7 +4982,7 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
>  	struct vm_area_struct *vma = pvmw->vma;
>  	struct mm_struct *mm = vma->vm_mm;
>  	unsigned long address = pvmw->address;
> -	bool anon_exclusive;
> +	bool anon_exclusive, present, writable, softdirty, uffd_wp;
>  	pmd_t pmdval;
>  	swp_entry_t entry;
>  	pmd_t pmdswp;
> @@ -4990,12 +4990,26 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
>  	if (!(pvmw->pmd && !pvmw->pte))
>  		return 0;
>
> -	flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
> -	if (unlikely(!pmd_present(*pvmw->pmd)))
> -		pmdval = pmdp_huge_get_and_clear(vma->vm_mm, address, pvmw->pmd);
> -	else
> +	present = pmd_present(*pvmw->pmd);
> +	if (likely(present)) {
> +		flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);

Oh I forgot to mention in the commit message that I moved
flush_cache_range() into the present branch, as it's not meaningful for a
softleaf (i.e. non-present) entry.

Cheers, Lorenzo

