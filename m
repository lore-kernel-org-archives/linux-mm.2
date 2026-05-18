Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5A7BCD4F52
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 11:02:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 286AB6B008C; Mon, 18 May 2026 07:02:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25D776B0092; Mon, 18 May 2026 07:02:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19AEF6B0093; Mon, 18 May 2026 07:02:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0CE8E6B008C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 07:02:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9E014409A4
	for <linux-mm@kvack.org>; Mon, 18 May 2026 11:02:33 +0000 (UTC)
X-FDA: 84780252186.03.866E561
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id E1EE64000A
	for <linux-mm@kvack.org>; Mon, 18 May 2026 11:02:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iaLD3APz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779102152; a=rsa-sha256;
	cv=none;
	b=OzcPVPpaPXiK/rDCXTmMaZ7g5B0K4eHluVN76YiDFrVNQtE6GohvM1i5Oj7kJOefcHTDPN
	rVG24Dq9oyxLF93KCICNSnfHELZ6TIpuZ4ZtsZ4O9s1mLhkXPtv1VpaPpjRV/tQMP2oCXt
	1AekLV7hpUDxCWkSEX7ZH4tXvjklZs4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iaLD3APz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779102152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/BLK+OBQGbCnFI1w7aFy0MZOHEWf89KOZyoldo1q8Ss=;
	b=NcipMo570MOZyL6Nd7P9I7i9sFv295WdzlQlMojxwM9ehvKhv25S+gQj7rhGH7Rp5D8yZI
	7IjD8UIiSmd+lwlTqNbU4jvcpBepQYAwYphHCxLk7CYpym0IjtlCO3Zds+RIHLBje4IFzg
	7HI1VX796Gdl6IE9saJOqI8JQH2C0EA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BEFBF44080;
	Mon, 18 May 2026 11:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66DCBC2BCB8;
	Mon, 18 May 2026 11:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779102150;
	bh=g70XtJJPevCExq/iyrCHebLHBlkYshrO5L8eyIGBMHM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iaLD3APzLMg+QPrqeyqzAfh40yOr6tTNQBxRQyVAIYUzckafcMwfi4HqIU/dalg2M
	 sQVyXYFPEG0w4acY7ctzh/yZUDI0pmJNXMHF9I0YbaTwKk6k75D5PK8zwijx1cYHF6
	 uHIIsPh5HuGZP8uubWu6hXyIVj05zZQtu7QSTDghVK5jsswENRrGg/y+6CYYg/WaZy
	 iN1ou2ZJf5tDKaiEdux88NoD6iYYFoi00gymofc7mJe//yf0QQF45ng57D2YvL8O75
	 cQfV6LcwIipWNV0TOnFGt3oKK6D8ugtGKa16K8g55cL7FvtoKLO2gA0UDJSH1LPnJ7
	 1a058Sm28VaIQ==
Date: Mon, 18 May 2026 12:02:24 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, riel@surriel.com, 
	liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com, 
	baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	ryan.roberts@arm.com, anshuman.khandual@arm.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm/rmap: initialize nr_pages to 1 at loop start in
 try_to_unmap_one
Message-ID: <agrxiWhWb-yHT9Bk@lucifer>
References: <20260518063656.3721056-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518063656.3721056-1-dev.jain@arm.com>
X-Stat-Signature: bzea95wz8uyar6hoq9797kahuqst6gdb
X-Rspam-User: 
X-Rspamd-Queue-Id: E1EE64000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1779102151-398343
X-HE-Meta: U2FsdGVkX1/lqe6ICMP4eUI3XjN7m3waNSAQMcGTv35XMUq3zX16O1s/AjMsLssArObQby7sHOg4aiii21+uph2asdLeBCJXMBr924Evy6G8y0zjGE3lz1iF1oJAWI+VLTINh7ajh573Yhu8/S64uPy/gzQ7YoD/cjkGlzOovcVy9PWNLHRDQfIPp2E7Nb3l4gyo9GVcJtdmG9qvMxaV1ThTYBHA92mGI0+GXswz2YYbeZuX5+Bd932Jt/zDPUvXcg3u/swKijHjpfOSmGkP3F5EJD2RHB3UgSO3+59jq5vU+SyE010shf+NOS8t8cpV4fGjOs/GtBtvegpcbavav/Z8Tt0uu3w4ZW9h61tF+ucPraAHFPckE4Sa5zEtvaiarhs5P0A/Y7e7gL02gxPF/cHxpZdQ7QpAONFMq4LYvor1Ei1d420sLc9HKxv0ZQkcZVnM5QRTLnviddyaPvD+q5FC7344Tkr8mvRYpjCpCe1H8yWQbAi3GN9Lz2vpd48T1vFGTrnvCrfxi7tx567GvxfZEzoAQEAypZQ3QAGfwhWuJr4SBylpDqvOLYH/CPXLCtbpwErk0JKzDBSVGbLr1APzoQpyNVwZnW3C4q4RcO+QPgJKneI1Rei4v9EyFwNgoiE6DymlEsx4enuHz7wab9W+usXQsb8ZAP7AxQ7xT6OhhyZS8GudwKop64IKUN/MbNNi5Fs3hsm89TvjjEJJokF3DQKOQMXmaeslov2yIB/ldV9lJ2R4c0RdoD+lnqJjfT6egE68Y5IpnG7jKpCE9RGqnHgdoxqr2fyb4O2AUue2fgNzaX5k5VaprUVMSskaRUjMzhUuN7gvCoigKc7nIanHd7eRC+PgBOv11WAfI3u/HfH3YEmJ1Uw44dZnPkDZ12u/YIIlTaSQdssYEGGmtDr+2xvib9pAMrKYeCyjr9/MDPfTz/fOH8j7G+3ZmAWfiqrhvUB9yDCvB9l8xOz
 /ciTdxTP
 +nIHUJG2g1wNjEQENFNpqTjiVhtY5BJM0IDjEGTs1OUEZz0/BQQ5HyCuAEzzIPn71YzB4wwxEwk5v5wFltp0hXcZpFtQLJ662Q1uappY+QQ/rijh9bzxx4wKf8zb5KBGt6Xl2Z0pTFWzLIVmBmn3RinNIFgdvhhSRvBfwI1cAnCJ/bnhdyN56kkCcx/f4j8ON4ZgjZoGDhd5HO0qOjhY7UShflu7ElMn7+VXQ9GSTL55Rwu6/cFXJivMPXRmbAPaKJ0wT+f7FUDB6Lh/dFKgz50Hlu+nA6TPKTp/Ub8KB2JcUbeUi1qe5NLeUGGMlBDeErfv1nb9fZRkZKI99A+iwd0Q2xEkeJCTB5Kb1dQpEKbXAxNITKfA1sZkHiJjJJSdcu3D2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 12:06:56PM +0530, Dev Jain wrote:
> Initialize nr_pages to 1 at the start of each loop iteration, like
> folio_referenced_one() does.
>
> Without this, nr_pages computed by a previous folio_unmap_pte_batch() call
> can be reused on a later iteration that does not run
> folio_unmap_pte_batch() again.

Yikes!

>
> mmap a 64K large folio with MAP_ANONYMOUS | MAP_DROPPABLE, then call
> madvise(MADV_FREE), then make the last page device-exclusive via
> HMM_DMIRROR_EXCLUSIVE.
>
> Trigger node reclaim through sysfs. Now, in try_to_unmap_one(), we will
> first clear the first 15 out of 16 entries mapping the lazyfree folio.
> This will set nr_pages to 15. In the next pvmw walk, this nr_pages gets
> reused on a device-exclusive pte, thus potentially corrupting folio
> refcount/mapcount.
>
> At the moment, I have a userspace program which can make the kernel spit
> out a trace, but the blow up is in folio_referenced_one(), because there
> are existing bugs in the interaction between device-private and rmap
> (which too I am investigating). I did a one liner kernel change to avoid
> going into folio_referenced_one(), and the kernel blows up at
> folio_remove_rmap_ptes in try_to_unmap_one which is what I wanted.
>
> Note that the bug is there not since file folio batching but lazyfree folio
> batching, since device-exclusive only works for anonymous folios.
>
> Userspace visible effect is simply kernel crashing somewhere due to
> refcount/mapcount corruption.

Also yikes!

Thanks for the detailed commit message :)

>
> Fixes: 354dffd29575 ("mm: support batched unmap for lazyfree large folios during reclamation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dev Jain <dev.jain@arm.com>

Thanks, LGTM so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> Acked-by: Barry Song <baohua@kernel.org>
> ---
> Applies on mm-unstable. This patch was part of
> https://lore.kernel.org/all/20260506094504.2588857-2-dev.jain@arm.com/
>
>  mm/rmap.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index fb3c351f8c45..1c77d5dc06e9 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2030,6 +2030,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  	mmu_notifier_invalidate_range_start(&range);
>
>  	while (page_vma_mapped_walk(&pvmw)) {
> +		nr_pages = 1;
> +
>  		/*
>  		 * If the folio is in an mlock()d vma, we must not swap it out.
>  		 */
> --
> 2.43.0
>

Cheers, Lorenzo

