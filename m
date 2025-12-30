Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D8E3EE4990
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 18:10:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 751346B0088; Tue, 30 Dec 2025 13:10:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FF586B0089; Tue, 30 Dec 2025 13:10:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60C396B008A; Tue, 30 Dec 2025 13:10:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4E5566B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 13:10:33 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D435413A7D9
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 18:10:32 +0000 (UTC)
X-FDA: 84276927504.19.9F5E486
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 27D8A16000A
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 18:10:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fdEij2TB;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767118231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/JuR8HE8mfPa9jY7HutISL8z4nsVzug8C0Lgd99O3D8=;
	b=E4nJ5fd+psL/O31pj/gzO1FJkr3n2WRANSyYBkewUSAtWfDpV7Cw02k5lnVWi0YzLD9UYx
	5fUb2wrfDd15XSwx/AQlJV46dwRGzTF3btbyIFkSQ/o9aqqLJDsTmhoBcfJWxBnAh9/se2
	qVD0X/ibUOnqkCyYTc+prba+QELtWL4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fdEij2TB;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767118231; a=rsa-sha256;
	cv=none;
	b=aY4LdbJQHvExg1F6pysvPogy1XpIAvtUNSZmjjkDz0YHQDuQ63clh/9VzxqG122MgAPWlv
	niBStdWfBKlCdogzgIZk9eEKHuAq/NP9OrZJH7AMrMhlbm/XXpKT6ZRFrUOs5egf7OzNzQ
	CxwBhLZndzZp7IZ1sEJ5isvni9Vchx4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2EBA460017;
	Tue, 30 Dec 2025 18:10:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACF3C4CEFB;
	Tue, 30 Dec 2025 18:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767118229;
	bh=syp7Zgtx+zgJ1L0ASo6OlDm55/XqkgxP5b6kmNbRhvA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fdEij2TBe/dyl21797aoUsSaASOQmLEgBanqAD7lue1GY0UUa4e7oes1/jVke3FdK
	 Q2evTpkMKMWw3DLcx3WE69kGa32lNeKsbxsNlILIJVECR7gD4D0mz7ywP2nEG5jAIl
	 PDfIHV/ZYQE7pHt8DS2fV7RwIN/QsfD8zKFK8Fhg=
Date: Tue, 30 Dec 2025 10:10:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wale Zhang <wale.zhang.ftd@gmail.com>
Cc: chrisl@kernel.org, ziy@nvidia.com, lorenzo.stoakes@oracle.com,
 david@kernel.org, baohua@kernel.org, matthew.brost@intel.com,
 linux-mm@kvack.org
Subject: Re: [PATCH v2] mm/swapops,rmap: remove should-never-be-compiled
 codes.
Message-Id: <20251230101029.8471aea6c786ab33a85c55ca@linux-foundation.org>
In-Reply-To: <20251230130110.1366374-1-wale.zhang.ftd@gmail.com>
References: <20251230130110.1366374-1-wale.zhang.ftd@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tnm9gny8krxrw8p8m9op8uqq55xkhxu7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 27D8A16000A
X-HE-Tag: 1767118231-863293
X-HE-Meta: U2FsdGVkX1/UR0IYEQ5r1zvknpbcW3VtSMgAs+eWk/9ptnxxoLMSQEmX5/nSPtYoGbcY0vVrHdmBjfhvW6RvHFBJlpc0DyIk8I41zOSXz/brG2bAiytpdGapQSSwj9RsnXduh09XVfsBMxlxDJM+ywHWx1yqlzBIu7reV3/XFudKbRTb/x8RO4LQI/ILa8IbqpV2N0ms1G2feqrruV9yd0TGKaNpHXQTuwQcgM7x5zNdn0CxGImaTlpkdtkaa/oQUj6KU1XFFkQEHg8rIN9zlZCSNgMmndehaoGHpdUZqF00BnSBelsFcdOMvCuVlBCe6SeOeehbrKKhRm6t3rcwJyUMnAZXa9/0k8DEuS+qnp2gT/GRf39fwC0DLmM1WrTMSlJbj42l0ZeJwGDuxDeygfTQC1PG+WoO/sGsQAMpsdwhFmyGXsVdltdiuFw1ZCLOXfFbzDJCn1seCyecFVzTA+YAN2QJYRJBFyR/2CHOV+13eNtpPU3ZVGasKrvREqYvay7YYAB405nLG/WesK1F6ndZfLZd/JyqFwACQYLjNEkg9sP+Fj88ijyTsxfTE12Vtoui7NkuCfTDdRRffm0KrcwSRENR/lo5oyxGsQNAMZFEVG00NqiDDhSL390gvZ10sQxR/sxZGI60+Zc9e3YQ/r0o59ILPwRPLQAr9ttMXu6cxBwSLaw2uky/sq7C8Pqtn6zlTyvN8Y8ziGYsqeEFUQpcU8fyVBekYqbs2wX6SzihK6Gl/iXoaAM4jjHqbLFo27F/Wv2oNA2y5zXcNpI+6MZDDUP7lFXnnh5OFGykDoIjj4/h0QbxmM5XpxlwDSJpJVnNtBGjChvicZn+Wnc+I/fwH64Dl9mtdOM7veBNGdsmj+XZsqfArEXd5LWJexkFBWImNuKEMCfVlZC1wiTZAVlRvlfmv6ztaStsXczNeb69Jnd+amUTKz3f2KRGD926XvYBox7AIFjew1FPD4A
 5IyZdad2
 LR7q60p7H7phunvDnv1kGTtpiBmyt3cJp1YjclR2mfbjWIaJ+nFvG8Gug/HSz3BYHbRIXznk/9eb5XUgWJoNrbtrhgQZn67V9Vm+O+SC1KJkpXS5q3Dx4a0nsiKTBkPj9JQSvp4pf52XpRp4wWIDmMH83pI930pH48bQNczg3BDC2CaI96Dq6uruuiOlDMcfTOYmRV6gJbqAecc+ufknSkGiWfmmos6OBXHNtpp6MWcoaTzUwUhmd6LZx6/RpJ9y9KMlet5BnmWvsDObgY8Q9aE+Lijg3FJTPfeHvK0NabOPnHUVqikmWEQjjTdIzzf9rQwrF/o3hIEfPkujY4kcE3XE0+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Dec 2025 21:01:10 +0800 Wale Zhang <wale.zhang.ftd@gmail.com> wrote:

> mm/swapops,rmap: remove should-never-be-compiled codes, included
> folio_add_return_large_mapcount(), folio_sub_return_large_mapcount(),
> set_pmd_migration_entry() and remove_migration_pmd().

Please provide a reason for making this change.

>
> ...
>
> @@ -1264,22 +1262,21 @@ static __always_inline void __folio_add_rmap(struct folio *folio,
>  			nr = first;
>  
>  		folio_add_large_mapcount(folio, orig_nr_pages, vma);
> +#endif
>  		break;
>  	case PGTABLE_LEVEL_PMD:
>  	case PGTABLE_LEVEL_PUD:
>  		first = atomic_inc_and_test(&folio->_entire_mapcount);
> -		if (IS_ENABLED(CONFIG_NO_PAGE_MAPCOUNT)) {
> -			if (level == PGTABLE_LEVEL_PMD && first)
> -				nr_pmdmapped = folio_large_nr_pages(folio);
> -			nr = folio_inc_return_large_mapcount(folio, vma);
> -			if (nr == 1)
> -				/* Was completely unmapped. */
> -				nr = folio_large_nr_pages(folio);
> -			else
> -				nr = 0;
> -			break;
> -		}
> -
> +#ifdef CONFIG_NO_PAGE_MAPCOUNT
> +		if (level == PGTABLE_LEVEL_PMD && first)
> +			nr_pmdmapped = folio_large_nr_pages(folio);
> +		nr = folio_inc_return_large_mapcount(folio, vma);
> +		if (nr == 1)
> +			/* Was completely unmapped. */
> +			nr = folio_large_nr_pages(folio);
> +		else
> +			nr = 0;
> +#else

Changes like this made the code unpleasant to read and harder to work
on.  What do we get in return for this?

