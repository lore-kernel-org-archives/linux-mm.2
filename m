Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ED55C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 11:32:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E1C46B00D6; Mon, 17 Aug 2026 07:32:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 591996B015E; Mon, 17 Aug 2026 07:32:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AB4D6B015F; Mon, 17 Aug 2026 07:32:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 22F746B00D6
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:32:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9FAB3A0767
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:32:16 +0000 (UTC)
X-FDA: 85110547872.07.00379AC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0FE2F18000E
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:32:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z3uQIP1q;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786966335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DTlJJQcM8pU6vk1pmcyVf5zZFnfSwwWA2cJ9LuzJSqs=;
	b=g0cIav8gAP2fUarR+Qsj3mtnN+Heej4Lo05+oE7nOcG8HSLz7e4LnN7JCfFbRE7BClDzMP
	3lnnqCQQ4muBJycrVa848Wm8CF7nqSCt779J6b0CZeuulTo3jlkkGtTYB6L9F3xO9QfT6x
	ZjCERetJAnqKC/FJETWepHlx6Mx6Dc0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z3uQIP1q;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786966335;
	b=JncK/EdMCz5ZgXM2UciVlN0IdpV88sjxivbvpd8DxmZ0J/MxwKbAEPJ0H+8S2SPpss6K3d
	+beNG0SzXRZNr5YMxJjqxhPmqY/5FeRQKup50cnc8bYBkVKExc3LrEWzs14EgbA/oPWroF
	/iRcUFU6uNRPZyIseqW5d17oCqs8Dow=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 86063600AE;
	Mon, 17 Aug 2026 11:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD9E1F000E9;
	Mon, 17 Aug 2026 11:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786966334;
	bh=DTlJJQcM8pU6vk1pmcyVf5zZFnfSwwWA2cJ9LuzJSqs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Z3uQIP1qLZMwu/5dFRFnYba/NlMZ4a6dgptRC0hlYZpRaQS5dCs7Cgp82k21wbr2Z
	 CEsiJpWD53fPeFzvSF8Xzk0qgI46xkC3PwQQCt6VVwTKueGIYktkR0WtZDW1LRP48M
	 1J6HJpN3kld5RYwmvd+2e/zcixbQyE2batnnwXy/GqxgH4fdQexVZZkgM37fuBhaOf
	 arp2oRbzY5hw9PNFx0d8uB2EN4477ABeg+Ky5VM6BQJb8CRbuxXBhxLAHa5q4W74MW
	 ccbbyagzfYc9MDUDg8t/Pe5ku4/wtJnv7Ps5Or2JPykvCwEL72uNs3ucmmHFyky4pP
	 5wLXW9T97m2ug==
Date: Mon, 17 Aug 2026 12:31:54 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v4 2/7] mm/khugepaged: extract reference check into
 folio_pte_referenced() helper
Message-ID: <aoLw_x_iVTPgm6wy@lucifer>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-2-ddac39d61c4a@linux.dev>
 <a23dd413-1462-4b7a-9ce1-136e1d806ed8@kernel.org>
 <b4b24576-507b-4617-b1b3-f03ef31934bd@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4b24576-507b-4617-b1b3-f03ef31934bd@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0FE2F18000E
X-Stat-Signature: pe94epk44miwubmn19i1d9h7boj98ecd
X-Rspam-User: 
X-HE-Tag: 1786966334-99987
X-HE-Meta: U2FsdGVkX19JwzTtoaxM5sNjTD3FyNGllOwWUF6pBeNhroAjU0b7+Wwx5x1/xU6hgbP9Z1ONSDzha3RngZqv+alPgfk1EHn8xAZ3VOmSsCyXZdtaAou2qc0BaiugJvEfOrgFeSmrNphQdxioKq29nR2ETDeNVjkQ7c6nik+ei13T/BqYa0X7AIm1IdhGhX0Q2vdoV2nYNXXmjZnTeU1QwgAdTk22WORDXSBqosXTE99lOwCeaBnTCHDzi4NVBaxUGLg23q38ylTpLzBzmpgzY3R1hvsmzbrWG4aBR1thddjFXJcdskP2aj0J60XX2EhKGjEJx091HfksIvpiwB9vCkpYAoOhhGDHNohe1bRKcydaScbZB1zDJo6YZGNCJyS2VUaFAlnFw2NN78P8McvfDAfsl5oBbGcgAD4tVNp5piJxFmOHCwfNds6Qs0hCYsyXnl8bJq4u0zFbi5489l62DQLzpHsKIZ9np7V4JClnmCkJRrdRWNhqMMl/f2jztV1X9XpiqGBINDwR6rfsJphZaxP8TKbciMcWCIU49bp9Pl93p7NMXav0CC+PuCDHcUFWvSXK1tee6S0HcsW6Uv8l8yW/w0cPXFQ0U6kUgn05N9hef4iACIncKp2SHpT6F1I4xbIxAH3hDQpsYwDdp3GQ4w89PfZCStn1m/yqIK9aVWmM6HAiS66NVf77rZxnLnqYDro+P5N9QYBLFtcD97Ii3/v2ONhwv/zdUzkth0pi31TRYsb/d5+FYO0pOKo0D/I/UF2E8kSUwzcy9U/3o1c7NnVoAmoRLfil2uYJwkq5/zg0uOqUBTFrhu0VvLkSAwj6JV4r2DHYN1agd9SQZjP8myUSgELAWPmFAkRHapiur7Y1WdWyeL2kVxL4Yq1JxHnlkb7yYi9ay1Bp1NSHTcXIauouZHWWykMXw3gjgccCsQP/LNwki0SroGYwbo/e/SWJJXVBZpW1FtbB8NRWVJG
 XuCfibej
 VN9aCsfJbfS62WCzVxenrG4z3wu8WkVlSSABLrb6fJyiQ8X9EhY1IwwXU5eq9Ag3JLbExNHzbW3FVeNAUfZIhXS9T8fI2Kme2L11k1zLzaQ+KtHLaSTrPJVcU+j2eHZ4T8RTeJkqPi26N+/3INhHPHinSZhck6gMVoI7ef7Bxvkn9LCqhfSoAWD9846ofUgte4W0QG1AfYcaT/3QEzogilv9fzox4BEL2bAa/mFnS+HDZ4kpnVv591hUW3fFzr9MhrUdbLx8QLyKp4syR/I89v0sEQaep3FZV2Pk/L5DJ705xbVgZBz/AeiNtFpkhTq/0ZFrq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 06:19:01PM -0600, Nico Pache (Red Hat) wrote:
>
>
> On 8/11/26 9:47 AM, David Hildenbrand (Arm) wrote:
> > On 8/11/26 14:48, Nico Pache (Red Hat) wrote:
> >> This change deduplicates the "is this PTE/folio referenced enough to be
> >> considered for a collapse" condition that was repeated in both
> >> __collapse_huge_page_isolate() and collapse_scan_pmd(), extracting it into
> >> a single inline helper function.
> >>
> >> Also move the comment and use it as the function header. While we are at
> >> it, updated the comment to clarify that a young pte is a recently accessed
> >> one.
> >>
> >> Acked-by: Usama Arif <usama.arif@linux.dev>
> >> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
> >> ---
> >>  mm/khugepaged.c | 32 ++++++++++++++++++--------------
> >>  1 file changed, 18 insertions(+), 14 deletions(-)
> >>
> >> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >> index 1e26ea97381a..8babd4c97db6 100644
> >> --- a/mm/khugepaged.c
> >> +++ b/mm/khugepaged.c
> >> @@ -672,6 +672,22 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
> >>  	}
> >>  }
> >>
> >> +/*
> >> + * folio_pte_referenced() - Check if a folio or its PTE mapping was recently used
> >> + *
> >> + * Return: true if recent access was observed through either the folio state
> >> + * or the current PTE mapping.
> >> + */
> >
> > No need for doc for such a trivial internal helper :)
>
> Ok sounds good I can send a fixup to remove it. Lorenzo has often asked for
> these when I've introduced functions, so I've got in the habit of including them.

Yeah here it's probably not so necessary as what it does is somewhat inferred,
more so useful for shared functions and those which have more complicated/less
clear logic :)

>
> >
> >> +static inline bool folio_pte_referenced(struct folio *folio,
> >> +		struct vm_area_struct *vma, unsigned long addr, pte_t pteval)
> >> +{
> >> +	/* The folio was referenced previously ... */
> >> +	if (folio_test_young(folio) || folio_test_referenced(folio))
> >> +		return true;
> >> +	/* ... or the PTE mapping was recently used */
> >> +	return pte_young(pteval) || mmu_notifier_test_young(vma->vm_mm, addr);
> >> +}
> >> +
> >
> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>
> Thank you :)
>
> >
>

--
Cheers, Lorenzo

