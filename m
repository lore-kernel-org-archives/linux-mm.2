Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E37FFCD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 21:51:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19D596B02A2; Fri,  8 May 2026 17:51:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14ED86B02A3; Fri,  8 May 2026 17:51:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 064856B02A4; Fri,  8 May 2026 17:51:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EB1736B02A2
	for <linux-mm@kvack.org>; Fri,  8 May 2026 17:51:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2167CA0353
	for <linux-mm@kvack.org>; Fri,  8 May 2026 21:51:25 +0000 (UTC)
X-FDA: 84745599330.13.02686A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7CF174000F
	for <linux-mm@kvack.org>; Fri,  8 May 2026 21:51:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WmGqQ8vj;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778277083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jFdAB6vGUZfUy4gl6FaD1tbgaxgu0hXjB4e9w+RjKAY=;
	b=n+myIlGj+4HfXO1DAsKihoonyCpgvauTDAhCb8o4s/7nSsjOWIyVQT9KNvC/kdFfUlPnA4
	9Z0cPKCg3rgOzHBkKjvfFdHOJ7RdenGeqBJ0wOiiMU55WE8YO+pTBdjs60OGR5J/GLjNru
	IVe95ISRb/6+LMRYI9mohgg3jEbuPJk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778277083; a=rsa-sha256;
	cv=none;
	b=PlFNoUCCfLVf6n2HxG5LURiIP7NbFg6iaSIB1jfbx6Db8p3rZQTxQdLdL7RlS53KI81eJw
	WAbZDPef3A+B2H4Cte0rfUVtUd+sWXLmGgg2qJlINgmQOWK63HOg+C1G7vHdmwFcthEMpS
	JWaa/kif2sAc1p5rwSE3PSi6onUeSI4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WmGqQ8vj;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E88BF60181;
	Fri,  8 May 2026 21:51:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35131C2BCB0;
	Fri,  8 May 2026 21:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778277082;
	bh=C9QhXNau5H10Vsv2I9QSQcs5z5pQXQI4hTBlKbEYUdM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WmGqQ8vjDV4ZvaVH0iE/01aNlECAJH5GwTvX/6N/C9UCOON+ZhEYc3GRFoVdtqlVP
	 Pe+U4KcjjA2eNCttCtcX40ltu8dhR7FldWOGqSFoLE1Y5FpKD43ejXBYFmSltjxCVA
	 Qhd2mi7zwjvAAky8ZGiu9TKD+Qp1A66NHbqKgQRY=
Date: Fri, 8 May 2026 14:51:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: david@kernel.org, ljs@kernel.org, riel@surriel.com, liam@infradead.org,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com, sj@kernel.org,
 ziy@nvidia.com, balbirs@nvidia.com, linux-mm@kvack.org, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/page_vma_mapped: revalidate and do proper check
 before return device-private pmd
Message-Id: <20260508145121.35e2552d403b94ea6f748b90@linux-foundation.org>
In-Reply-To: <20260508013728.21285-1-richard.weiyang@gmail.com>
References: <20260508013728.21285-1-richard.weiyang@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7CF174000F
X-Stat-Signature: hnumfc9adyep6we9u8xrouniedh8jeug
X-Rspam-User: 
X-HE-Tag: 1778277083-647189
X-HE-Meta: U2FsdGVkX18PjoZ3QQLZ05qzk4EsaFXO5XuyZPzckqFNJkjLncsrQiEcSipNaVhbQpt/vIgveFQpFdHGsxJCk9JuEtevaja4s/q6tdmHCoXYVvyBFZz+w0qQqYSofMirBetG3kJp298SR+2V98kYhjaUrorZwBXkeLgo1N7lMjyhL+Dx89wnsqWBbZ2sr+QehBEasgSw3bv9J9bPVKDcogGrlKqSjL60sSMp4Fu2nvd5vImMnPP0KnyXqrXVFP3yzzBgCBifgRte2h675F77QNOmWDMWrHOOWmrgusJWov6B1TLtxCgJ/42htdy1Qo4mol0lKWgD8lvcTyqxqeMdGc/lkLwEAcNQU0rct1tXr5dq5PWh73DT8uyZ9AJzF13vD4bQVBtHIaNzc/Q37Y0aSAwafvK0YLF1HTPjXJ163xQKKfdVQAwWgctj8fjQuGPHjUeyEfhH2h8I8JRTRG3tFRZatzzzEQH1XxcJK85VCE2u0DZlNgb2HpvzhH2wd5p+m8pDliKzXSmfeUPXegusO+t+DA4ueSn6Cmh7pDF5Z/Sr1wUBMTI7X5F9lFNYwxv5B3vK5ZXt9gHG0e2PnRxOOQ8rbLnXP3jM3iw9wnr8VleGwhzAozRuo+P3QBRyLUjSc8bCvRLniVzshzEM8K/SY/BEKwiaTNuCTBJqy22UrVN0oePZ4opTnIkAmL18/gHZ+F7AoVvEIpeb0rTrKZngffZG4oAyRMeZ0WbJFPCzloSlvfEVPJpqK/UzrxOOOSQLi+0vRuJsQqMojO6eAyw3Ez5+BDBanN5TV24VCqOCyWjwVMWnxfxsQcai+5kW/9GFEVXWoMrO0Q7ArKID/6NzufHGSerXF2ueZrWY9/U6V2MEAQaRrM4n+lLqSjMaHMdtUvqv7HNqU/+5zea6H2lxXNj1DUCDBFVZ73FybQG8cRoP+ehCQdA7bspsg6jDunl4NXQTp8hVyu9/wWqQkNN
 v2c0mP28
 XEIRK3UC9XmeMcYNq5oSeo6Z75Kemv0l6LNys6v9Ry4u4fFcHDO7mspzCLkhKCSLPaIXcbsBk8B5nChnLbW/bNpRxZX4AV9LGgtKdOnhWzZqRhIoDoRUCG/gy0ynEdmvRCHaNJdIhi1xfGkmFFeQXyIbNsEv1DesZsPRDd/h6ci5rva7aQ/dVxE5dXdsFHhwPe8jERc1/1Ggi6nqzVsZ1j8emWPVrb4ewiJztknlI7GPJVkFv7kZ2z3AQoUzrVIOEX45EQeMGExe++2CMtjWlUaKOkdt/oNofcI8YBtPAmW78NHjtvav+Hgc5aX6UEZ22COmDVQeLefKviZAgkXSN6CdIhgTo4UzmUCwgRbXNA9QCqsT13nTYRaqyxFjb2c7wxncHsO1mRVgoi2hjC80Qhs99Xc1DBavxyT16L08N5M9oM5HGy8BzQp8VWgTPtQYecVemXizdzGjeMU50dCFFXz+XfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  8 May 2026 01:37:28 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:

> For pmd_trans_huge() and pmd_is_migration_entry(), we does following
> before return the pmd entry:
> 
>   * re-validate pmd entry
>   * check PVMW_MIGRATION
>   * check_pmd()
>   * handle on pte level if split under us
> 
> But for device-private pmd, we just return after pmd_lock(). This may
> lead to inproper situation.

What is "improper situation"?

> This patch fixes commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration
> support device-private entries") by following the same pattern as
> pmd_trans_huge() and pmd_is_migration_entry().
> 
> Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: SeongJae Park <sj@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: <stable@vger.kernel.org>

If we're to propose a fix for -stable backporting I believe we should
fully explain to -stable maintainers *why* we're making that proposal.

IOW, and not for the first time(!), what are the worst-case
userspace-visible effects of this bug?



