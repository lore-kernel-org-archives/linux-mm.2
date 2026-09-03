Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BA1FC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 15:37:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DCFB6B008A; Thu,  3 Sep 2026 11:37:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68D626B008C; Thu,  3 Sep 2026 11:37:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A4576B0092; Thu,  3 Sep 2026 11:37:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 34E4C6B008A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:37:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 929E41205A2
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:37:41 +0000 (UTC)
X-FDA: 85172855922.13.A45FC82
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id D2806140011
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:37:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XwbiNMYl;
	spf=pass (imf09.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788449860;
	b=rDafAbvct3RXZThsYaPzyKRFCVlCgloHIyFjZA4IRtVyx6WOunl6E6NgKMSh4yVbVVLc9z
	dubdO5cm6LKQ6pxX2dyMfPPTF+wHK1KWwuIXUye44jivxwzfgX7Edv3+N/rbSCQpz8PS/7
	W4dhDo90vDuyUfDrukFNsneFDjwAxh4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788449860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SAaGuiuwmKSEyoiV8Zah8K/3km4skoA5hchj++a6j6E=;
	b=a1gj7Q2QQWLgVSZDu4m720fGljsTYxj+389aktj0IyGxlHexmuB0G85iqCwK0kNZXd7Rl3
	ZXRzZfPI/evK0Qjy+WrbcSY2DEHiQa9jBHa0cmLTKJj3rGZtUWf491WNfggnOYhm8wpC8Y
	ApWlGxsNnxBVyPgtnLamk+2G5YNRCLA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XwbiNMYl;
	spf=pass (imf09.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5001441193;
	Thu,  3 Sep 2026 15:37:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1A21F00A3A;
	Thu,  3 Sep 2026 15:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788449858;
	bh=SAaGuiuwmKSEyoiV8Zah8K/3km4skoA5hchj++a6j6E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XwbiNMYlFIe5noAKSrlUGhYbLna2L+uP8lSXziXkAW62TAf8hQPWn9u+lWp6iYyo4
	 2406vNU8X6hwJGPli4Z0q2ege3NMjGMxsocs4c0PQ+1U/F7zAodiC1YypWAr0O5cy4
	 JvFisieON+V/L86uWXU8vC5wKcx8Q6Qq/rjmneZl4FpCLZj/CgxrhuDEI0TmUN61y9
	 jlbnpKu3/KYACkoWnURxOuutOBHRIFQ+cB9Qf1djpVCrt86thiQG0Qgm/le+dZBfqH
	 JTXDJXvobCVYMvtofNtJ6HRcgwWaVWeQ/J7GSBdP4bQ81ERzGbrHQfpvFQcV0FeHCi
	 uM0wXamhjq7Sw==
Date: Thu, 3 Sep 2026 15:37:35 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Chao Yu <chao@kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH v2 06/14] f2fs: stop using PG_private
Message-ID: <apmUP1p1TPDOaBe_@google.com>
References: <20260831-remove-pg_private-v2-0-3668159cd9e8@nvidia.com>
 <20260831-remove-pg_private-v2-6-3668159cd9e8@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831-remove-pg_private-v2-6-3668159cd9e8@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D2806140011
X-Stat-Signature: 6ry17ddw5o3nbxh1fsqdzwec44kwjfic
X-HE-Tag: 1788449859-472150
X-HE-Meta: U2FsdGVkX1/952p0m4/lcblrQZB47tAuDRzkP5hU8Q427KRo/E30TaUqotlmrZveumo5xq7vGfA25F08G1FeuMGwZ2EPA794/3m1TdJ/K3HlRYV38RPkUUD8prKRm466H42LwMkgdg7oZ5gACQXNmANQyHlmQm9eP4+AIjc48SSvj1Z8GCpoZ3hsjuBPftuNWiS8y2PPRbFq+Vg8xhmXZVoKG9G8a50K0WJ50WkSI8tjDlBASy1f2VvbQnyv/3aBwC7LhFZOsXIUPVe/EADC/soqfBC00wgE8itXL6UxkazazJzchb2Zy6QYQLDEhc7Cbfj82RsfPb4Wc1KiBHeV7+tQH0YbcrQmlpeul8zBf3gdHSddoD9eWYtHJp0NUWgpNVMvqEMtPjyPNanqXmxFRtpHOdV7GUhcOPlXbrlqlgbrxJ53O/4fX7G6GjvtuWYj4r8PywDDDtDsG8uVPuw1yfU2JtNbHk7JBDEjW5O+B6p3XmdN4lNIqrcHwkDKLOvLKRy00Rx7oN3ye6C38Y4ksJ3oK1O9JaFTkvqCgxDlqq48s1/Ei+kVHpKZ6zEVoRDBp2+4uQRCicPJzN5hAVXcBxMLl9V9+fFh+zr3CSKHZR6OcZK0ZfxDkzkaQTD0GbSfTBvsFo8i0SWLLtjZWuKV7KQQ8bhScylzE/EQftvkzKdtPSYVFKQzka1Uf6xTAgl3TfnyFxHRtQPT/qJtY30vtYH6e2VERFfTr4YAQwLeddhr6iFG2z8E4pySCVSKEX1NkAlWn4wIrELBvdZW+iK36/FJ2lXj0j0so/rRsX8qjNmIyIolwgPmHD4o4aXB3CJa+5KTB/3NdoZJW58jkDaHHrb1IDFR0Om4Km0xXu3nhz/e428jwg05XsdBhzbtJFnNK1I9Nm7BYaRbVrbaA50TwEeHmNhOMGp9BIdtXdhiPr3cjqhlXS92l5FP7jNFN4gUlEeIDWMP64yCCRIgiwa
 qQ1mxg03
 qksnGOl8KAauTMG5lkO9cMEh7bl1rjWVAI1Rhbat4egVxF+t8kfK2dQ2HcdkuSFluEO7B18z+zYlJ7eWIu/Hml0RJv7Q+Od2u51W0XynI8f8ih5/UVu+VFOB11BPPE4SMCVBt5CFfnyQA+Iez3cDDT11jIrrY6aKQOGn7haxpv8QxngvXEuxbeTPJC6EsBdEoFuilYtGdJX2W7ZZvGT1BIlGV2s2fvpgCScDoq/ZtCzUtLhOUOwjIdnEYdI8Z0A3tu8VTW9Ur8/z+phN9r3uKJLXCq//LTqMg4wE8pac45HSbyzTYJsA5hzac9jOlOuF2u2D/qQJPwskcz1j8JB3YAzUgV+5D6hOU0VZ4dST8RC38R4K1FsqpXmh1Ow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let me take this patch in f2fs tree, which looks like a clean up.

On 08/31, Zi Yan wrote:
> f2fs sets its PAGE_PRIVATE_* flags in page->private and checking
> page->private != NULL is equivalent to checking PG_private. Change
> PagePrivate() to page_private(). Meanwhile, in set_page_private_##name(),
> page->private is first set to 0/NULL before an PAGE_PRIVATE_* flag is set,
> but it can cause confusion when PG_private is removed and
> page->private != NULL is used instead. Change it to initialize
> page->private to PAGE_PRIVATE_NOT_POINTER instead and retain the original
> semantics.
> 
> It prepares for a future commit that removes PG_private.
> 
> No functional change intended.
> 
> Assisted-by: Claude:claude-opus-4-8
> Assisted-by: Codex:gpt-5
> To: Jaegeuk Kim <jaegeuk@kernel.org>
> To: Chao Yu <chao@kernel.org>
> Cc: linux-f2fs-devel@lists.sourceforge.net
> Cc: linux-kernel@vger.kernel.org
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Acked-by: Chao Yu <chao@kernel.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  fs/f2fs/f2fs.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 9940a6cecf1a2..2f7ab5888b078 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -2691,7 +2691,7 @@ static inline bool folio_test_f2fs_##name(const struct folio *folio)	\
>  }									\
>  static inline bool page_private_##name(struct page *page) \
>  { \
> -	return PagePrivate(page) && \
> +	return page_private(page) && \
>  		test_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)) && \
>  		test_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
>  }
> @@ -2710,9 +2710,9 @@ static inline void folio_set_f2fs_##name(struct folio *folio)		\
>  }									\
>  static inline void set_page_private_##name(struct page *page) \
>  { \
> -	if (!PagePrivate(page)) \
> -		attach_page_private(page, (void *)0); \
> -	set_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)); \
> +	if (!page_private(page)) \
> +		attach_page_private(page, \
> +				(void *)BIT(PAGE_PRIVATE_NOT_POINTER)); \
>  	set_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
>  }
>  
> 
> -- 
> 2.53.0
> 

