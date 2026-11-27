Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21477606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 22:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PC2epmmq
Received: by kanga.kvack.org (Postfix)
	id 03C0D6B05BE; Fri, 27 Nov 2026 17:42:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 014736B05BF; Fri, 27 Nov 2026 17:42:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E92FA6B05C0; Fri, 27 Nov 2026 17:42:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BF0126B05BE
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:42:12 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 21B01C055F
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:42:12 +0000 (UTC)
X-FDA: 85482373704.22.7C0EA1F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6E29740007
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:42:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PC2epmmq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795819330;
	b=RSUpQKxNbCHUTELYAAzABKIKYwpUj0WCusnkIBrU92dWetikUdM+7B8XPNDJZEJR+CSU8h
	JCSVcnH8j4ys1CZOSgoWg6lIBYYU5J/ACdDSIcArwzIVYqGfJ4+cIKpmehFBkAAz6N7XVI
	g6qla3JXQDK59aMGgHwkQ8wAtz+hnbc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795819330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H2QamErgkgfwsP7LyCOuQ/swCiUPTeBoO2jKl7hZ6Nc=;
	b=qRoIWgP8drmJm1jpX3Y7gwcEO96MhFmWdwgp6BUATiot3kwnDeJArYlzxhSDqZQw9i3mHC
	NauW0vi3X21oSziBKEIZGtNpU5sRbNwGRJx95XJUH+y3Y4Fur5+Rdir8N5ZAHh9K6xjpUz
	TJwds3Ff2fKYFMyu3dQl7WHqpFk5yVM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PC2epmmq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B3B444069D;
	Fri, 27 Nov 2026 22:42:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDD01F00893;
	Fri, 27 Nov 2026 22:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795819329;
	bh=H2QamErgkgfwsP7LyCOuQ/swCiUPTeBoO2jKl7hZ6Nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PC2epmmqXYvUeMAnz+7Dufe7cROLyPEMfG5YbdXft7Ef3xnyGr6IrJGwtWsaT+mMr
	 uN1XCR79hXc0FZaI5NOBPrm38JtFwNx3/MVAZZTenvV3xVAGXcuIOk7D1rIHmL8M0i
	 EhSV3Vsz1ob7IPJW7qX60LqEqs/WEaHdfEiYmhK9UDjrmMXtLnSJ8zY7SZR+ZcFyxk
	 icWeSIvrF4IJZU7rx16nbo0e47Q33JDIFwxkrgIslI8L66tbBRvpcFSSygcYjsI0jC
	 ppZ0/EaWVaZoBNADYTuZ+5QdT3flkQE8QC6ce8GsAabSkJ7GvUCzJ7rkj/3S19aoMP
	 VzD+TUMsOcpSg==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 3/7] mm/damon/vaddr: implement sz_filter_passed for migrate_{hot,cold} action
Date: Fri, 27 Nov 2026 14:41:51 -0800
Message-ID: <20261127224152.106358-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-238334@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d7dd3xbwe5awyocnmfb3zesnior68ben
X-Rspamd-Queue-Id: 6E29740007
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795819330-901118
X-HE-Meta: U2FsdGVkX1/PS5ktQlvkdTYUvtgRCHHc2UOMEl4egfU7GFq3eFZR8nz8mmJ1Wq3azmzxfAvy/blIy+NX6JaNN1v98PQKshcF7nJyJvgt8Z6rgIGBgRWsRHdW81E6NOmDnxuuLb8y33ExPvwAHlH2/k2xnJ5y/tbGDg/SVtDtrmQz7G6u0yrawffBuqeSCD4SCfpakJ9+3Nqqf/AZRIhkupZqoirlYtzHy/VyXBBQ3pPD9jBElJCKFwCLW6GjXMZGXoDrPXh+Qig6PF5eC2KufJ/pm4/u0/OzLiJlSakL+qAsfeoMtOSANhDpWK3uXzwcWrfs+i9Zqd03bSf449XUg8Qx8V6g3QwHGMuAHHZPz8kPF+4BN4HWJx46tmc999+1NOTVQkCvIZ3IwkSuLinY/q/OESEcaLyT8VNNPLmjTxRhwNV9tB9JZF0I9TIo/umJHxqEogbZLVQrDkrLo6ff+n3PuNahbK0CwNhgslHwjy+k/trFKIae5b38z2WJJUxbpdYkH9TF92pVqcpQnKxroY/kjwMB9qeDhaQMKuAxHnDT/GD0pvCAWk4fncYWwiJJd6D6T7mvs3+RkLC6yqibPIjF/f8o7Jlv1meZdcRIMs8oIh8QMyQtTkacPfqfk/fdW+VebrPfqc2XaSwIRSF69KUasua4RFL7YnYBCtSFvzCWVOFQfBSCnBi94MYPdE7DqtWJJauxt3aHKrq4VNE01VLbJjhOlmQThXZcRgbbEniNe9wWboWjMgF1i2W9GkqgZtpvYixlBkUtN+ZJvo9lzWFWafYIaLxNdAX4WwHCC/WwWYSoedO7frrHR20XU3eLepOrIPsd6R5MGxIlDX4NNg1ZPskBFA9hmxG1ML4xWIlX4ec2DD0E6IEhBgEXviqTBzOuNaSyWYunBlq1DlmAKPJHCXE2dcrRqlBXKKOZsLT/ugiujImvlkwb+fUG32+bHDXF8dMGMsB5GFk3udb
 cnmaEHDq
 vmzGChuKJ2sjB5+sdydU55h+lnkyPJu1qSczAsZN51/UCqgc7Hup2RjaDUjr764Cg2dFOtZT3wA6qKK2aq/JAXiB1lMsSBBcE3DHf0oFdh7iVJlO/E+Ap1RxvtgU1lPaoB/16pgnB8P68fDbm7hYAzQgZ2wCvDAJi1h4a+a2IA0+yB+tNL1k9xjNTtTSjvOCB0Pp+Ri3MWNWcsvE2ojM3fwRyY0PF1MpvKFCjEWAU7D1RKs1eXnz6yNZzv+JzgEBG5j/L7GFnz+yKxfpcrON+jHMe4+gGSdoBu8/8qAUW/S5qhpnTTbKr3hsSyvsLRrY3PWWTbggcGhnDFfYl1wDiK6iW553gv6j54JjN8vQ9nSP19g5AeJZ9A2r79TfwDTwBhDYuKgM4NyOl1n7XAobDo/+357/4ZeZqAK6PYhSj721MeNgg7SoOhuMILoeFOiiitE03D8GVGUi3AzeB79hWO6uQxtRLrbkwsmDz7Nj1f2sHy71Zb9Y/S6ZDw7Gt4lj6HPOAqP7YjfdEpdQr3jjZqn1/NnAQJArxgpoKNTOFlxQjxluwQwNb4cY6EdrQ43DPAaCbQO2aioNxpVGo1KxFTNge6ewmigzhAoaY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 27 Nov 2026 22:35:53 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [High] mm/damon/vaddr: NULL folio dereference in
>   damos_va_migrate_pmd_entry()
> --
> 
> commit 446fe1a8fb2f01d2025ab8ed2dd156f643ec9800
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/vaddr: implement sz_filter_passed for migrate_{hot,cold} action
> 
> This commit threads sz_filter_passed through damos_va_migrate() and
> damos_va_migrate_pmd_entry() to accumulate the size of folios that pass
> DAMOS ops filters during migrate_{hot,cold} actions.
> 
> > diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> > index c8f93a19c840e..721a23856ee16 100644
> > --- a/mm/damon/vaddr.c
> > +++ b/mm/damon/vaddr.c
> [ ... ]
> > @@ -895,6 +898,7 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
> >  		s->last_applied = folio;
> >  		if (damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL))
> >  			continue;
> > +		*sz_filter_passed += folio_size(folio);
> >  		damos_va_migrate_dests_add(folio, walk->vma, addr, s,
> >  				migration_lists);
> >  	}
> 
> [Severity: High]
> Can the PTE loop in damos_va_migrate_pmd_entry() dereference a NULL folio
> when vm_normal_folio() returns NULL (for example, on the shared zero page
> or a special mapping)?
> 
> Earlier in this series, commit "mm/damon/vaddr: use damos->last_applied
> for migrate action" placed damos_va_invalid_folio() (which checks !folio)
> after folio_page_idx() and folio_nr_pages():
> 
> mm/damon/vaddr.c:damos_va_migrate_pmd_entry() {
> 	...
> 		folio = vm_normal_folio(walk->vma, addr, ptent);
> 		page_idx = folio_page_idx(folio, pte_page(ptent));
> 		nr = folio_nr_pages(folio) - page_idx;
> 		if (damos_va_invalid_folio(folio, s))
> 			continue;
> 	...
> }
> 
> When folio is NULL, folio_nr_pages() dereferences NULL while holding the
> page table lock.  Checking !folio (or calling damos_va_invalid_folio() or
> checking !folio before computing page_idx and nr, as in
> damos_va_stat_pmd_entry()) avoids the NULL pointer dereference.

I will fix it in the next spin.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261127222719.105510-1-sj@kernel.org?part=3
> 


Thanks,
SJ

