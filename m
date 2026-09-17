Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9389C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 19:26:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F0A46B008A; Thu, 17 Sep 2026 15:26:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A1ED6B008C; Thu, 17 Sep 2026 15:26:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26A6C6B0092; Thu, 17 Sep 2026 15:26:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EBDAC6B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:26:51 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 62FBAA0476
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 19:26:51 +0000 (UTC)
X-FDA: 85224236622.16.CB100A1
Received: from mail-oo2-f39.google.com (mail-oo2-f39.google.com [74.125.231.167])
	by imf18.hostedemail.com (Postfix) with ESMTP id 938C41C0008
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 19:26:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=grCTFljq;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.167 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789673209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=se2Vsxe0TSsDe42Voe/AhBhDb+5OgYc7j9RLVDJ97eE=;
	b=Hw/B5R8iakl72hYaybsO8jJ4yW4g+kDYo8Oc/giNer4zbCWQzEBd76ZGv6Oh775bx6YaCC
	SzKI0zGEo/6Fe7ku6l5V4EydlFym2jKZFUN3RwELZlN+rguGp6/cXdWGDuqdVCuZOKhYwP
	KMoVKACXhJe30tUmXS5F66GcDxaHw8s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=grCTFljq;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.167 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789673209;
	b=8ALWeYiEU8SqQ0wMZt7Hy+zPR+dL6td/iA5lW/K5qqJmPG4+HupFrOCvfLen46BMzy9LkU
	cgulyAkIS5RkMYfTdE2KMyGeQ+7VsZZC45AhXoU/sFtKYeXDtVUoG2Y0pOXlEg+CUx3j6a
	auDUYM7flCb4C38zoz+V/UHjvMy8RLg=
Received: by mail-oo2-f39.google.com with SMTP id 006d021491bc7-6c2613d8157so486329eaf.2
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789673208; x=1790278008; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=se2Vsxe0TSsDe42Voe/AhBhDb+5OgYc7j9RLVDJ97eE=;
        b=grCTFljq4YW6jZNo/fGl1LfgFpH5VHKLC6QTDS5Ib1pQQyia0SJFT+eqUOxHfott0V
         slY/DEcNHe+5/OOtU59SpuPsuQhk5xnniZBnV0R96CeDIyIyArZ5Oui1wEYdg4CN/cx+
         ZAl4kb5DJisET9ly1axZp1Wxalj1hFPfpXarLyqgi23f0fxJLDkKGt52VjmoBNDLyGDP
         QeA/NmLzSFrGX323pEAxHefRBrtSAYgrE/lzGZoNf2v0nUosGEZtiB7pVAt2IiUudCDS
         6ARFvoQ1o1E4PL6gCq4PRvq+6gjr1zID4jYYg+Kl2Qeg8zd/E7lpDC1ZQrfWBztVA6TE
         uzvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789673208; x=1790278008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=se2Vsxe0TSsDe42Voe/AhBhDb+5OgYc7j9RLVDJ97eE=;
        b=2mx8dYQRrOCPJr89kBGHlkDOn3GJRQ8c5pTqeP5zcBeEG3MTHvp0SsKhxXhk/egcpq
         BGXJhvb7EBTRk07Lby2yZL1jGm9/XVy0KXX8JrTPrupdjFxwrcaSOe4wmOynl+aEFW/a
         Ozq4Q1DoO7YgmF1hP0o7lMaSZT5zVBFD19q1vX6jKpmA3Hdw6GdGzfgcue4lmA3hT04y
         gq4SlDG+anAZEKPNKRiTk0L04xz1CKQQmp5W6TCOQgzSs9sIWqbhPsB6IFCahdcPMFif
         qwdO1rBoSwpCRiwxlgf9laBurQpQcZeOMeJYwpz7MQ/0w33kzylqElvZNH3WBRH5S1/Z
         1h8A==
X-Forwarded-Encrypted: i=1; AKwUvBw5kvB2ByupDk/BjMRIK6bBvipX0hSaU0tynV3a7KXRXdiRwS37dKpzjrvPvBEjZdGOV8b/+6G6HQ==@kvack.org
X-Gm-Message-State: AFuF++mbgbV/jgz2nfnfmL7xmsqkUlAbu/hC33+nnfbgkcHNzmPXrS8E
	aU/a72zLDZa+azIO/4AQ7WqVgF9yVCBmXqH2oZhK9pPSFeJp45WnExKE
X-Gm-Gg: AYBFou0w9gGZdJci+heGRxwUMVPRdH8ld66EaI43rN+AIVLbHvt+9sFCeRitc0uUrvg
	SkWNque+3BnHz+TS/JH+kkEcplTZhApp05sCc7CU8iwGtF34ZbTGJhbShMSOZRyTvX/whtzFc5G
	hhycTiXlmAlLwmpBhycI0yZb724ECPsBxVZjH/BBg8xiywRQ+8q7/PIEoNjoduYmP/X6UtInuj8
	AxAKtxrspVqn/afSLJ0VuyZ6zUmoLe2EWM10EV6iTR9afqXkLOFMd97xpFnHIeJNNkKNGWM4kwx
	l1JgmlSdLLuY3I7j3MxNCumMeTxvfQWjYuZMQWFDl8X/2ClkyEZWPAcdfoac+4Zz2bXZhQKmOh8
	1u6EodRg81s2nlatAKrpUpkdAJuayJUYqEWom5MMziY1RK+zhc6mWsDUIH9BRy2CKk8fWSYmH7u
	h9enoN5oDW/OVR80XCG7/LIshPgGUq2PS6MnWoPJM3R7wNS6VQsVSzMPNNwIAJp46busf1I8ECk
	umIR4NSqV+fQQotw/0ig0ydidpIJg==
X-Received: by 2002:a05:6820:7091:20b0:6c9:80d9:5f6 with SMTP id 006d021491bc7-6c980d909bcmr2173414eaf.55.1789673207394;
        Thu, 17 Sep 2026 12:26:47 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:42::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6c8f727fe99sm3306425eaf.12.2026.09.17.12.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 12:26:46 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Hongxiang Lou <louhongxiang@huawei.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Michal Hocko <mhocko@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wupeng Ma <mawupeng1@huawei.com>,
	Yanteng Si <si.yanteng@linux.dev>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	fvdl@google.com,
	jthoughton@google.com,
	rientjes@google.com,
	vannapurve@google.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Ackerley Tng <ackerleytng@google.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 4/4] mm: hugetlb: Avoid re-allocating global reservations on region add failure
Date: Thu, 17 Sep 2026 12:26:44 -0700
Message-ID: <20260917192645.3436692-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260916-hugetlb-subpool-always-track-used-v3-4-38aae9b5ccdd@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 938C41C0008
X-Stat-Signature: s1u64jukt3m3k9ootmsqsnudtyhgg9pn
X-Rspam-User: 
X-HE-Tag: 1789673209-616549
X-HE-Meta: U2FsdGVkX18/wks4bFf7sZ/AlOijB5njpsJjCBcLao2TyJfwSxtIEyfCwPGIsIK0CnJVwM9qp1f/z/jsBkC581q+heoz3W6JMRHjPcwvZOAF6nGiJx31Hj2O6aWUjiJzZvT3bcdtBjlERNAEeJuCy+HmoU49lj/dPKcn+E2eLkJwtQymhrH9Bgt0dN9n0BzyXjz34mbKItbfswl4tfTnf8NObLFzYAMy2WQpaSJXeX1nkEyybxXonoWihxDGvVzUpa63RTSu7C2L7mK7vrIK5430GEKoG3hIqSl91NogF/cF2hpbbujpTGVvTM71yEWs9uqU0iebrpc1uNY7Lzy2SX1wiEbykg9CWJ9CgXaN/VLxWnAgaHH7C60QRqjqq2rOTEbs0Dhwi53EqWFhaTLiVnXgRaecoxyisYoXVEhixD3awZwIv4Ed95pJAtI+8yKSAoU5gHgz+z+ay+uIWksUgqa86FVGF2CQafIKzmCqo9IqaIt510Jk2XotGXg+zB+SfJ11JATwSVP6ME+PiHsT/rE/7Hp9/Hv6g7XYcARPel9TNSSg2YahUFmk/H9AWaNZtb+GW2f78R+/1ieKop76b6WApmsrgwHMoWgJBB3Jm2GmTVSx0cesB3+NlEfEvIpovDqkJmkz927Rv51WhCZntMKdLGFfuceXXitprzYFh270bfyQj3RWhfSZysE1qeiEtG8pkzZyOnZEqDIFXk2LJESF9g08koPYHkWNDRUEDo00QY2nBz7pWOYSl9zOHyj/kkLDbzK0WI2QewHP4qJewEjHoUAyRXYRy0d67X/343yZ7hmeO2SqNy2Q0XX723Ogz9/b94qMXq38RzbfSjMp5wgDidZDVZOuCy+kmI3tKHBLKnrqJ+3YATPkPlL1Goi2piUdF6VLCqZ5CZSr4iLGsR6McKOMFiu/mLFE4ddHhWf3vmp9Wwvz+juDh00Tp24fA7JP64YqWXRbLqOO5X4
 P3t24LCa
 As01tgRh+lrJKkujBN7FWTgwWNnIWUQTBkUoXVKIv9OeKrYkvSrZ0g9IPj6b6mkmRJO5Oyl7I4EAMCQsJAnMtXUv4zC+16eGscl3m5OSvh5v2J1FhkiOXfr0nMGCyKziSIo23B21peFBXr5xTz2fIXo1DatXR7Fy1+UmfJpNHLuoSYN99aQ+up766eUPql33rwux6pB3ttdIKVLN+6So/9TTxXVkLOf5dQTF0Tk0P+QJ66cJgrPdtuswrRFR75K6HKC5bzk1RYOTuvKwrdVDNn/pC7PCbeVHS95MHvlbGTV+DX6s4uBDESJR5mJj7LkNCkbjD9FbW4BlU0p1cfHVRbCYnjKiaJgaq09zrwOJJc36t1zqQ7pJdl8pp3PRZPcWKrja9M721gjeoqMFLqdTQC9eMp9SYXhFkAY0TdXtFHDIV8bt1P1Fzqndq6+jEOzrpVm9UzT03ixfJEDSGO52cwqhG/awGqXgMYxhpHFjJyJr8xKpL2XeMn/wTj1JfTCTwNGPK1UUWJ8yc+Af9byDS9okWnEAdqsMwbiDk/+c4oSzcLTmnk2a4pviz2d03lL6eW0M0XGwWxfMhEN9aYVmLy4uX+KWByaXRVjpUmWJ8w34Y+fNllN43rvtKJ2ACAlEKeHBbnfo9DJjF+ZCC77TpcDzVIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 16 Sep 2026 16:39:04 -0700 Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org> wrote:

> From: Ackerley Tng <ackerleytng@google.com>
> 
> When reserving huge pages for a shared mapping, reservations are first
> requested from the subpool, and any remainder is accounted in global
> reservations. When adding the file region entries fails later in the
> process, the reservation attempt must be rolled back.
> 
> Previously, this error path explicitly dropped the global reservations
> that were just acquired before jumping to the cleanup label. The cleanup
> label then returned the pages to the subpool. If concurrent activity in
> the subpool allowed the subpool to absorb more reservations upon return
> than it supplied initially, the cleanup label calculated a positive
> difference and attempted to allocate new global reservations from scratch.
> 
> This premature release was completely unnecessary because all requested
> pages were already backed globally: partly by the mount guarantee and
> partly by the global reservations just acquired. Prematurely dissolving
> those reservations forced the cleanup path to attempt fresh buddy
> allocations that could fail under memory pressure.
> 
> Instead, track the number of global reservations actually accounted so
> far. In the cleanup label, subtract the already-accounted amount from the
> difference between requested and returned reservations. This ensures
> that when global reservations were already acquired, the adjustment is
> purely non-positive, dropping excess reservations without ever attempting
> fresh allocations.

LGTM, thanks for this Ackerley!
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Cc: stable@vger.kernel.org
> ---
>  mm/hugetlb.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 6589b188cf657..ee1ba9ded0ec7 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6678,6 +6678,7 @@ long hugetlb_reserve_pages(struct inode *inode,
>  	struct hugepage_subpool *spool = subpool_inode(inode);
>  	struct resv_map *resv_map;
>  	struct hugetlb_cgroup *h_cg = NULL;
> +	long gbl_resv_accounted = 0;
>  	long regions_needed = 0;
>  	long gbl_resv_get;
>  	long gbl_resv_put;
> @@ -6768,6 +6769,7 @@ long hugetlb_reserve_pages(struct inode *inode,
>  	err = hugetlb_acct_memory(h, gbl_resv_get);
>  	if (err < 0)
>  		goto out_put_pages;
> +	gbl_resv_accounted = gbl_resv_get;
>  
>  	/*
>  	 * Account for the reservations made. Shared mappings record regions
> @@ -6784,7 +6786,6 @@ long hugetlb_reserve_pages(struct inode *inode,
>  		add = region_add(resv_map, from, to, regions_needed, h, h_cg);
>  
>  		if (unlikely(add < 0)) {
> -			hugetlb_acct_memory(h, -gbl_resv_get);
>  			err = add;
>  			goto out_put_pages;
>  		} else if (unlikely(chg > add)) {
> @@ -6826,9 +6827,10 @@ long hugetlb_reserve_pages(struct inode *inode,
>  	 * There may be a difference between the number of
>  	 * reservations to consume and the number to restore now if
>  	 * there are multiple threads interacting with the subpool -
> -	 * restore the difference.
> +	 * restore the difference, taking into account any global
> +	 * reservations already acquired.
>  	 */
> -	hugetlb_acct_memory(h, gbl_resv_get - gbl_resv_put);
> +	hugetlb_acct_memory(h, gbl_resv_get - gbl_resv_put - gbl_resv_accounted);
>  
>  out_uncharge_cgroup:
>  	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
> 
> -- 
> 2.55.0.1082.g2b9226bbc0-goog

