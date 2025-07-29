Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9ED4C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 18:20:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EBF16B007B; Tue, 29 Jul 2025 14:20:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C28B6B0088; Tue, 29 Jul 2025 14:20:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FFB46B0089; Tue, 29 Jul 2025 14:20:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 51BDE6B007B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 14:20:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E862812A7B0
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 18:20:06 +0000 (UTC)
X-FDA: 83718116412.18.9326DDC
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4D6BD160011
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 18:20:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YGs0fL0w;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753813205; a=rsa-sha256;
	cv=none;
	b=Ah1k/twOodoB05rDmkG+eksc9/XATU5/Z+/gZtpp5LV1GB6S73Xp6u/RJ8NIa3PLmH6QMQ
	KGhcEG+58YRpk8lgCiPfE8uoc9UQdEs2VIuy5GTsWaI9McqBwvl1430BXa8F+1ExILwIoS
	P+q44PNR0wHt6p4dKhVM+bkmS+DaHa4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YGs0fL0w;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753813205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8aIHtg6eEvo6ozMfh9bVpGQNqsFOaWRn7ax9TX4IvuU=;
	b=krbHAXoBEEMZGCgmQMl6b3+q57UsZwcMQWG6sb0lEWkrqp6LtvP0Zo/vYs7BKZognH7uW+
	u4f/5kabnt42naDEftZ5H8m0DcomVxYQ21R2lQUcf7CZnk5KzYC0WLHCiNt+bzNiSlVuOl
	Gf1HbRQY8fcGG0Eg/tkBDhf956TtDAI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id AB8DEA52966;
	Tue, 29 Jul 2025 18:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29AA5C4CEF7;
	Tue, 29 Jul 2025 18:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753813204;
	bh=QDwhP+ZU0XuVGLZz9IuLWC3Z2KwTgUVuszFTh8nyyqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YGs0fL0wEDqAIyz/fdOpOD+aaAcq63/Zn04dzV0gCTJ6JD7FhdWXdgIiA42cEAyuL
	 ZIy/FqjtMIDDheIlQtioQKA9Iov/4R4xpMA2W+uH/1y0paxmT/ZkfqyQ3ZN/crZU7F
	 OtknUeSs+22M0nsRA1GofKw6pdAM3dA7upEM99IHesY2px/EQSmUlomHtaKKPmjJzo
	 y9UJw5CaN8SwzP8geSJlkUzSZ6bYKgyUPWf2RNiartkJm/uMYQKeaIwfKJxohb1G7v
	 bkPfgnMOO5Msp+0Fqs72cqg2/nwA7+LFHGNFSbN1795F5ka/XspRv86QyTwKQ8z8Fo
	 GeziZJ0Wte7Cg==
From: SeongJae Park <sj@kernel.org>
To: Yueyang Pan <pyyjason@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/2] mm/damon: Move invalid folio and has filter to ops-common
Date: Tue, 29 Jul 2025 11:20:01 -0700
Message-Id: <20250729182001.56172-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <2e143ff5789954b2c3c5b97b12569bc324cff087.1753794408.git.pyyjason@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4D6BD160011
X-Stat-Signature: mb6ynptertu83pfewjp1d873x57iqtcj
X-HE-Tag: 1753813205-972395
X-HE-Meta: U2FsdGVkX1/4wPhdu6Dri5hB1GDfo5SoLNQ1g22WQLJXeEJjOUxSNU+X5FoFNa95S+j4NXRcdaaW+HTRxCxNr3ol14jWMxSAUfDsJVqoZ7Sxr3MjfYagvmc/vI3Ye5UlYlt+D2tFjr80bWkV37wHbyt1ORzBMQH5z4a5v+2qO4SrAPIFc9cJv9MX3iSHi3Q6pCvGru3NxbUvkjLj2edcj2vSlepDUOFpOyNO8w+yszhfMFdyeAYwrRpG3jjvkrcV7Fx3Vn47GTeVGM6WJwYm6hAXI8T3EXMe2cPA8fapegQ6tv7aVzlauyFiUvfKblv3wNMD/xYR2dVU+QEtPWdesc0WMV03LydmMxfczg6yn+3oPjQr7e+D9fTRcoeNeIMQtRbjLhlaYdYrFy2ioZRU1vuYvi6WEMS29hDo2EMYuwEhmgqDjBqbBe03cu9USLEbSu/HeJomS/Sz6FhSxusd20GKSrvdDdNqQXRx0tuoAXn0a++gEsI0C4cyjwU+wG3j6HTAgvkbUerWE+QgP7zV6Mp8soPdeV8+noU9+YL2x19rHtmr9RD43SSYOOE1dTfDP+iPAjJ52UeSLqMd4zpLR4CkNQe0mKnc3ZqTG8bnzds20EXPOgIvwjeWSnGHYOXpSl8iXUU2B3PHV5lPC1IAbQnYbl8WS1ShTjWJGQVqRi8e+aU2yR/Wxebuv7nJ28pyLLqrrh/H20CuhnzxABjTDsoMFduB45whErMLPJhnIVPC6JFRAqluYG/O77IJIM+yOmlORa/23a4AC4b+na5HHtP4b5MNf5sd+kIHoPsImIyPRFmRdilNMQ57IBbfJoP0P2FdCZb/FWsHw8Boh28DkIyETRay7ZcHzgwBugbgsVHTBO3I/kf6ZNhvnhnlU2FU528xj/wVWqgCkllF9i2MpBw0lyEGvOmZ93fGGJ4Lg/pWxDU1qDKepeETgfx5YMqCCcLJ/FV5tLnpVBSJxfn
 jNKimjpI
 OqEzLMS1UiWEjEoHN2mL7useUGOuUQFazVWojOeK01tiIN1i6oZ8ZjJdHt0mlDVwJP5IQ0gRlFjfeqtbwkkoopHFIYOLwKEwaJyFKzVkLYj5sddbt2v4sfHPvuFe2rd5a6UEfdhyy7AoBE0JDtVMnXBypO+PfuUriOqGJxPluQo+y945hqt2x37Gpbs08tUsoQf9ab8kdRDjGXU4z4sRfbjmqNKWJTg0Rn22oS98/fK9CLwIYlvIxsbIDifqb19yjdvrxwAorkKdhgZtS8TVRT3Z0Mg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 29 Jul 2025 06:53:29 -0700 Yueyang Pan <pyyjason@gmail.com> wrote:

> From: PanJason <pyyjason@gmail.com>
> 
> This patch moves the damon_pa_invalid_damos_folio and
> damon_pa_scheme_has_filter to ops-common. renaming them
> to damon_invalid_damos_folio and damon_scheme_has_filter.
> Doing so allows us to reuse their logic in the vaddr version
> of DAMOS_STAT

You forgot adding your Signed-off-by:

> ---
>  mm/damon/ops-common.c | 19 +++++++++++++++++++
>  mm/damon/ops-common.h |  3 +++
>  mm/damon/paddr.c      | 29 +++++------------------------
>  3 files changed, 27 insertions(+), 24 deletions(-)
> 
> diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
> index 99321ff5cb92..7d3b48cc0f86 100644
> --- a/mm/damon/ops-common.c
> +++ b/mm/damon/ops-common.c
> @@ -412,3 +412,22 @@ unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid)
>  
>  	return nr_migrated;
>  }
> +
> +bool damon_scheme_has_filter(struct damos *s)
> +{
> +	struct damos_filter *f;
> +	damos_for_each_ops_filter(f, s)
> +		return true;
> +	return false;
> +}
> +
> +bool damon_invalid_damos_folio(struct folio *folio, struct damos *s)
> +{
> +	if (!folio)
> +		return true;
> +	if (folio == s->last_applied) {
> +		folio_put(folio);
> +		return true;
> +	}
> +	return false;
> +}

Unless you have different opinions about this function I mentioned on the reply
to the next patch, let's not move this function.

> diff --git a/mm/damon/ops-common.h b/mm/damon/ops-common.h
> index 61ad54aaf256..4e905477fdce 100644
> --- a/mm/damon/ops-common.h
> +++ b/mm/damon/ops-common.h
> @@ -21,3 +21,6 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
>  
>  bool damos_folio_filter_match(struct damos_filter *filter, struct folio *folio);
>  unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid);
> +
> +bool damon_scheme_has_filter(struct damos *s);
> +bool damon_invalid_damos_folio(struct folio *folio, struct damos *s);
> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> index 53a55c5114fb..a8b7048e871e 100644
> --- a/mm/damon/paddr.c
> +++ b/mm/damon/paddr.c
> @@ -114,16 +114,6 @@ static bool damos_pa_filter_out(struct damos *scheme, struct folio *folio)
>  	return scheme->ops_filters_default_reject;
>  }
>  
> -static bool damon_pa_invalid_damos_folio(struct folio *folio, struct damos *s)
> -{
> -	if (!folio)
> -		return true;
> -	if (folio == s->last_applied) {
> -		folio_put(folio);
> -		return true;
> -	}
> -	return false;
> -}
>  
>  static unsigned long damon_pa_pageout(struct damon_region *r, struct damos *s,
>  		unsigned long *sz_filter_passed)
> @@ -152,7 +142,7 @@ static unsigned long damon_pa_pageout(struct damon_region *r, struct damos *s,
>  	addr = r->ar.start;
>  	while (addr < r->ar.end) {
>  		folio = damon_get_folio(PHYS_PFN(addr));
> -		if (damon_pa_invalid_damos_folio(folio, s)) {
> +		if (damon_invalid_damos_folio(folio, s)) {
>  			addr += PAGE_SIZE;
>  			continue;
>  		}
> @@ -192,7 +182,7 @@ static inline unsigned long damon_pa_mark_accessed_or_deactivate(
>  	addr = r->ar.start;
>  	while (addr < r->ar.end) {
>  		folio = damon_get_folio(PHYS_PFN(addr));
> -		if (damon_pa_invalid_damos_folio(folio, s)) {
> +		if (damon_invalid_damos_folio(folio, s)) {
>  			addr += PAGE_SIZE;
>  			continue;
>  		}
> @@ -239,7 +229,7 @@ static unsigned long damon_pa_migrate(struct damon_region *r, struct damos *s,
>  	addr = r->ar.start;
>  	while (addr < r->ar.end) {
>  		folio = damon_get_folio(PHYS_PFN(addr));
> -		if (damon_pa_invalid_damos_folio(folio, s)) {
> +		if (damon_invalid_damos_folio(folio, s)) {
>  			addr += PAGE_SIZE;
>  			continue;
>  		}
> @@ -262,28 +252,19 @@ static unsigned long damon_pa_migrate(struct damon_region *r, struct damos *s,
>  	return applied * PAGE_SIZE;
>  }
>  
> -static bool damon_pa_scheme_has_filter(struct damos *s)
> -{
> -	struct damos_filter *f;
> -
> -	damos_for_each_ops_filter(f, s)
> -		return true;
> -	return false;
> -}
> -
>  static unsigned long damon_pa_stat(struct damon_region *r, struct damos *s,
>  		unsigned long *sz_filter_passed)
>  {
>  	unsigned long addr;
>  	struct folio *folio;
>  
> -	if (!damon_pa_scheme_has_filter(s))
> +	if (!damon_scheme_has_filter(s))
>  		return 0;
>  
>  	addr = r->ar.start;
>  	while (addr < r->ar.end) {
>  		folio = damon_get_folio(PHYS_PFN(addr));
> -		if (damon_pa_invalid_damos_folio(folio, s)) {
> +		if (damon_invalid_damos_folio(folio, s)) {
>  			addr += PAGE_SIZE;
>  			continue;
>  		}
> -- 
> 2.47.3

Other than above, looks good to me.


Thanks,
SJ

