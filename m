Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19424CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 10:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7340E8E0017; Mon, 17 Nov 2025 05:14:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E4638E0002; Mon, 17 Nov 2025 05:14:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D2A68E0017; Mon, 17 Nov 2025 05:14:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 451258E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 05:14:28 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 19193129CF
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:14:28 +0000 (UTC)
X-FDA: 84119689416.27.1F57AF2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 856051A0008
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:14:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xj45fOEU;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763374466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Syp2rjAhsVf5n1xONKZgEAhJ64byVCJh36qlQZJd7oQ=;
	b=Bq4yRm31c8W5T3Jp7q1zYHyXB7zZfCrg8rI1y5rsnvmiPY/f/+poQrCbyGP1Qqy5UD4LyG
	gXaKzx68OcmxvgAODkw7wm/sU55Ts2vTXVh0dE4Sch6uWtVvYpC5+gG2GzbMgQwGLO73m8
	S7QBbuFUcbdVnUQJaDeqYLiA3p8H0MA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763374466; a=rsa-sha256;
	cv=none;
	b=JsA/8PbtxMQgSSXgNqYtszgGcSk0FvUWV/LYH8gZaZ7g7zAZOIhzpIsb2kn/Gsk6l4Oano
	IMxKJA8m2fXC836mqZ1TNX2dkmaaYCZsgYvnANPT9HTR5RJGIRqG0IAoaqV9VNBwpwTHLL
	x67sWORbndigN77OPa8xarNJgS+qNoY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xj45fOEU;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AA5F6601B3;
	Mon, 17 Nov 2025 10:14:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE50FC19425;
	Mon, 17 Nov 2025 10:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763374465;
	bh=EBfzAfm80HruebuGq2p7cOO/sNrPnXAIz69VkAF8qRU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xj45fOEUh1b4zxSnuffzv/I652kMh8I1mGK/g9DiGY1P+OpG5UGAfjIYotdBU9Syd
	 kjeGSbhNhewRynba4fT0Dnb4Z90P2Z5QgKN9pANo3fVipvwzL3dVbAV+VHF+Nx+M4H
	 LCqSUvA33EbgaNqvcTdRaDQfY9aFmbarjcKuW58f2UkZVzWH38FdApKDB6GOkKKHPc
	 GI32lOu2/CcojdQx7HGuVbVTKzKVsykpEbo6fOCEF0TrQN66OVP2Kt555LAvcM+dJt
	 gF+RvTLz3jF8uFpYRGcwF7cufr2udpC7X/OslgFQKRSjh1cvwwcj2B53ESd2bkFSNp
	 eC4X1HNOyFmow==
Date: Mon, 17 Nov 2025 12:14:03 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v6 13/20] mm: shmem: export some functions to internal.h
Message-ID: <aRr1aw45EYSFTCw9@kernel.org>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-14-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251115233409.768044-14-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 856051A0008
X-Stat-Signature: cju3tbksmgas51q9wzxf1boqeuhpsqiy
X-HE-Tag: 1763374466-129466
X-HE-Meta: U2FsdGVkX1+QCxxy09xTH8fWEkuTwRnlab4dEW84SSdBX+awxLq1rT96v/K65hLjZsHy616IUV8mW2jKy5YyyCfjDJSE0dlUEl15uqcrvrfyBEab5HySBFiHnA2rNfFgrTifcpcG2vDFh4H4Tzw2rKjOisgFPS8aaa1XczX4jEMrDAI8eeeaDwpMbbi7DhCTQFBlo0nMqe9oGiOcwQSv4DzAx0DEOkMU5lyQBTsdMY/rJ7RBpC5QD0m7PW08G5ALnFq9BhE519ZZ+ACEGmJ2wO4aPMxjU8ELPodQXGYpHc7Q64GUm0A1byuYmOI9G+JbRD9M50rmfsTVwqxnXFtFLrlPWeg6Iw97D8vXumJYFTeyKC/sCJ0t6CP0hytARgdtBAseWz/Ro0qOdxYC2sqNmlnaqtQsH6dpqy5yghOSYTHMMmAcCcrLP4zh7KHR9X2LKkub/ckb8Prm0PrH6X5jcfxYRK3YM5QM6r0oXdPiRM0vtz50s1v0wwSb0qEcA4S+7B1j07oyzlX57PprbEQMtNzK9ofjC50t0vckJpWlcU/Q8WoLTBNyKs6WeyvkfIY4oJobSoPP51TdO2NCav4rhAU78TqG7IbhElZq2ivFEv/6gQvugFWb2NsH+p3hCm6YL+VrExnRd2MlC8d7bnid6XG54zyEmaVe0uHKbS6FgUcyFcLlAgTqtKUWCYHvuIu9V5u836JR3tBk8rB2Ck6twFXS5EP1y+RbX0fQXyO/O5a0AA5k7KVToKybrxKKGDXx0iZ4UTY6CoKyQQ0FoQXGJ6SE5wtZQon0eSgSzkYOU/B9h7offfXzt8ZlGpmT09MS4VCKDxpefU0WBRfJDD88xZZ6NDDeMGpXO8UdrCeGNi/GTzLntNXJadtZ26TS+UwXuc/TO/GEa8QaXM0LnFfOSuREYh2FMO3Qpaj+kGcbVfFJ0UV4XBgO/EnQtdmBRlWoyMOfYtNH+9rJoWLGVKm
 xmNd06n5
 bPmWzpmiT45BhEv7u4fYOCGQUTa6ol5JKXxZgOJVAQtDCBq4ac69ed4eAKowlD/bU8Z+n/dZ17/4qPCEuSZezDdKlpVy7CCjR9cvw5NUsydq1rr+6RRheiLef4yCzHgHeQJAs/U4lHU96vPPd9fdyPMh5ZEubEnJoRbUHa+ZJ8KQ7OinXz9KrQrZLv7RZRn6Wh7btMXMvKMCi1ZXfVHPI2Xdu/lDfN5LVR+dfOnK7+wHonHNiRFA6KfCfz3YIQs/VKl0aEQ0+5OZSrub/LRohKPE92TLiZRAbVD/9U4SpFOd2PARFclB0ur+2DuAle0dH3xzqKCBN4uy6sNPgBiRzZQQD6y9aVYGLm8LNbpwlgpejgagxTfcRiUHIq41OHCTkL7gBzCg++NoFtOkJ8QsY+wvcrQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 15, 2025 at 06:33:59PM -0500, Pasha Tatashin wrote:
> From: Pratyush Yadav <ptyadav@amazon.de>
> 
> shmem_inode_acct_blocks(), shmem_recalc_inode(), and
> shmem_add_to_page_cache() are used by shmem_alloc_and_add_folio(). This
> functionality will also be used in the future by Live Update
> Orchestrator (LUO) to recreate memfd files after a live update.

I'd rephrase this a bit to say that it will be used by memfd integration
into LUO to emphasize this stays inside mm.

Other than that

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> 
> Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  mm/internal.h |  6 ++++++
>  mm/shmem.c    | 10 +++++-----
>  2 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 1561fc2ff5b8..4ba155524f80 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1562,6 +1562,12 @@ void __meminit __init_page_from_nid(unsigned long pfn, int nid);
>  unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
>  			  int priority);
>  
> +int shmem_add_to_page_cache(struct folio *folio,
> +			    struct address_space *mapping,
> +			    pgoff_t index, void *expected, gfp_t gfp);
> +int shmem_inode_acct_blocks(struct inode *inode, long pages);
> +bool shmem_recalc_inode(struct inode *inode, long alloced, long swapped);
> +
>  #ifdef CONFIG_SHRINKER_DEBUG
>  static inline __printf(2, 0) int shrinker_debugfs_name_alloc(
>  			struct shrinker *shrinker, const char *fmt, va_list ap)
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 05c3db840257..c3dc4af59c14 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -219,7 +219,7 @@ static inline void shmem_unacct_blocks(unsigned long flags, long pages)
>  		vm_unacct_memory(pages * VM_ACCT(PAGE_SIZE));
>  }
>  
> -static int shmem_inode_acct_blocks(struct inode *inode, long pages)
> +int shmem_inode_acct_blocks(struct inode *inode, long pages)
>  {
>  	struct shmem_inode_info *info = SHMEM_I(inode);
>  	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
> @@ -435,7 +435,7 @@ static void shmem_free_inode(struct super_block *sb, size_t freed_ispace)
>   *
>   * Return: true if swapped was incremented from 0, for shmem_writeout().
>   */
> -static bool shmem_recalc_inode(struct inode *inode, long alloced, long swapped)
> +bool shmem_recalc_inode(struct inode *inode, long alloced, long swapped)
>  {
>  	struct shmem_inode_info *info = SHMEM_I(inode);
>  	bool first_swapped = false;
> @@ -861,9 +861,9 @@ static void shmem_update_stats(struct folio *folio, int nr_pages)
>  /*
>   * Somewhat like filemap_add_folio, but error if expected item has gone.
>   */
> -static int shmem_add_to_page_cache(struct folio *folio,
> -				   struct address_space *mapping,
> -				   pgoff_t index, void *expected, gfp_t gfp)
> +int shmem_add_to_page_cache(struct folio *folio,
> +			    struct address_space *mapping,
> +			    pgoff_t index, void *expected, gfp_t gfp)
>  {
>  	XA_STATE_ORDER(xas, &mapping->i_pages, index, folio_order(folio));
>  	unsigned long nr = folio_nr_pages(folio);
> -- 
> 2.52.0.rc1.455.g30608eb744-goog
> 

-- 
Sincerely yours,
Mike.

