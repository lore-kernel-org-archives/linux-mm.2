Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE0B0C88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 14:45:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDD0E6B0093; Fri, 11 Sep 2026 10:45:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8E616B0095; Fri, 11 Sep 2026 10:45:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7D816B0096; Fri, 11 Sep 2026 10:45:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A2896B0093
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:45:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A945F1A0263
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:45:13 +0000 (UTC)
X-FDA: 85201754106.10.040FC5F
Received: from mail-oo2-f29.google.com (mail-oo2-f29.google.com [74.125.231.157])
	by imf16.hostedemail.com (Postfix) with ESMTP id AF5C118000A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:45:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=maPr28yV;
	spf=pass (imf16.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.157 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789137911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aHTYcbYj4j1qZKzZt30zdIUqIM0GkVQjFda8W78rUTs=;
	b=ZGjHYTDcbhxTRGIgfBjFJqj6C4OOcH8HV3eQypM6jPakie4oZaEMW4Zy5rfGnSpi65hthh
	tflI9wSv0UtlVdiYUvYb7cz9xoRPm5vDiM3lwNQfqWxfkkA4sG2/bRiMyK9cfG5ZTM8Swu
	v0ar+7HJxivHdi21/92EqTLRl/1F+jk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789137911;
	b=a5hB/TwOjISg77JPQ/+GFlXVVJ8crntn8e7dq/5zl2RQ3LPdBUdX77FHn1EWOh7leKoVp9
	7lNyq1lc81Ik+wVl2ZSqFjfzC7tlNHZiaPMWZNDLGIDMSbqPEbuEemGvqCXoKfumxXUjLb
	+fPWTRPytA+JZVnYbiAmVcCpJG4b3mw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=maPr28yV;
	spf=pass (imf16.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.157 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oo2-f29.google.com with SMTP id 46e09a7af769-7fcc35eeb48so666628a34.1
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789137911; x=1789742711; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aHTYcbYj4j1qZKzZt30zdIUqIM0GkVQjFda8W78rUTs=;
        b=maPr28yV47vzj72hoqAXWHxr2Frgw1X2mijpUUNMMG90R4vp0MIC9ns566ZDj8QufO
         f7a9ksTq/Gqbh6FhKjJQJzO8euZdhdcE59GkQEiHDjBI0vMbyw+JEKORNA71KWa3s6oL
         h9xhOujotajb/d6JAqJ/W4lsQ5fqgZPFbokumeUqLNXBylnI77o13IFNXowNVvjQNjvT
         FVXB1qb5VkV/CJwmRuei2hiE5JOnpE6G8g+e054kCF3xtbRBN8Bc6lI5fmyHaLGv82r4
         BAwOCXAz2ey8lDkwX91RnLldAFqudm4sK9AsIxr3iSwb3nOt721pXabek8lc5ewUzsko
         38eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789137911; x=1789742711;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aHTYcbYj4j1qZKzZt30zdIUqIM0GkVQjFda8W78rUTs=;
        b=qMKEE9gIojMFcRyfD90JPiCM0opgaEHMoIwUb37zYT6vRYqh4OkRnSqRI//T28DVL7
         9qLnuLlhG51jr2zGzFKbIKJm5nWLPSJFbegKKPCKLcLWsma2Qwx+bLoY8uXR/r3qeyUb
         DbrkBgqrjfe6YwXcHlROgPt0rk/+VUrEfrlBVUjt4csjxrqLAxIJopzQJsYlHfOqb8yv
         3jvZTJJ4OAuwEUbfnRsrESoDRkYLlQInm+Saa/iIlEpoXwgedgUtbRcuzraDZ+FrzXCA
         68r53GwHq/DzdDQAWtrG0wQPO7MGnvMKkADfPwvzoXnpakxCRx0+dPXNtqw9X/qUvHhO
         PlYQ==
X-Forwarded-Encrypted: i=1; AKwUvBwDaWwVPm/zjJuH1sue8HaRg0tMtA0Ua6Kq1qX1oteVyT++QPZ7whMmLclEg7fLMceCFEoA37az/Q==@kvack.org
X-Gm-Message-State: AFuF++nhUzT7T801S/6z/STfm5kEyzdBHqVEdOM6OEtypmlTeuEoF2bZ
	fk9lHUhauolM5LoRd3Wz8a/NxY2c9z2KbMqX8wTY1OAB9sMMb2AqaJNu
X-Gm-Gg: AYBFou0A7+GkITgn7429IYcRwDMm58KBQ03mbGitlCBsJSaxK2am7Nd9zvh9PyufoZs
	VnBLdc3lldWmdtrN2/h0c5P9QnaKnTT4oP4NPLpn2ESwyKuIsKvkckdoPwJh+fC37JNCDI72l1N
	b++XdmLwNyH+d0WPSlP9d0dsNcl9MkRWThapdrWG9My2EwhS4Rqh7tGbxlZU6ULqXXf+4vp1YcB
	0csdhXCGuRS/xdP3XXce/Hd1fcqi+pYTvZ2m7R4Ak9vf2xeMsL+FCvtECzEFdYO01YVUyK5CEE8
	UfR6bqyqj4kcSPni4ieH0li0hJcd6/xruaWyO3L+74cfFPT333bkTHN4emAcgrCg221P4iiGeFE
	dptwHbkNfi+kNNIJ5fcxPfwvMp0ubWyZuX9PfCMKDUFFPpjsxHiJzuARv8c7MGC8bn+WtBMVbOh
	FgwzCryLkDmTdiLgorFX5sVRyzbKEXlLVwd1BTafgoPjsFlH2C4A8ORGo5Af+xprM0vou1jJzu8
	orz89mtfdHdva4yb1X9lyYnygMP
X-Received: by 2002:a05:6830:448e:b0:802:faf1:3919 with SMTP id 46e09a7af769-803fc316ec8mr7479732a34.3.1789137910671;
        Fri, 11 Sep 2026 07:45:10 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:6::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-803f60fe54asm2969111a34.15.2026.09.11.07.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 07:45:10 -0700 (PDT)
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
	fvdl@google.com,
	jthoughton@google.com,
	rientjes@google.com,
	vannapurve@google.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Ackerley Tng <ackerleytng@google.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 3/4] mm: hugetlb: Fix subpool usage leak on allocation failure
Date: Fri, 11 Sep 2026 07:45:08 -0700
Message-ID: <20260911144509.3792211-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260909-hugetlb-subpool-always-track-used-v2-3-30c5d83b572a@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: d5a6u9cwjmq3goxk1ytomwtzgimswade
X-Rspamd-Queue-Id: AF5C118000A
X-HE-Tag: 1789137911-506539
X-HE-Meta: U2FsdGVkX1/92WQXa+K46yIufTDubZIYozc0/Tis9EOnRBAqahLCH+82m5jecmgWQ3yGLNDNkXSRQhagqyZsyd83ZSiLe1ggxa6XKtspjLBWK5iq47fGXdBPdRwtgFvqM+Wy6ceYYWsQ9sYceq/8DY+fkNe8RvZOSTZOT6Yj8uZCtdf2et8c6t150JZjc9SPOI7F3CuA6pSR3JdH4FS5IwmgKw2wX1dJQvV+3RK4H7JwGoZNnN3lyluFARiUKWhVgsh6tU6QOwr13heVNghFmJpzBseZbkp8IIAEhC8uIUXS4Vr74BQ++CXCIrZf1CuKCiT8Qz90AL3NGUC73+vgGbC1kEK6mJQ5tbYsYHG787K7eLCrB6YsLyIAAGGbFZ5X78dcl3R3bkJg4Htsmn4tLyMyE6N5xOLETMFQKZTWbNtFxmVK6iWWZMYT8OyiF+/rN4emYxxEXZgguL5phmHMKZABncGGw4sf5VBySpnYYlBUo1mPixNRskFTpByeM7cs5DQXAtb2s6pKz+1SQGSl8AOfD6Us2Q/PCrwNMaRBtIHBOxcYyFoIx4SZ17hr8W3bQVqdLaJK11zEh7Bxn5Hw3/xWq5epZGH07/gmzMMAPE8ADIgDBZNwkyY6nKCNW+GUAoyP51lxsRj/gLTwz1auvs9vEqrXQd5yPlsy8eNAM3OmJcAU1moJ4J4ztTuFS/Q5k7zOSwgKXx0jdmNWUUhNte1Nqf18m3os5XwlZn5dJNj/C4E3md0MS0LA3HEQ23eBcAYzu7wYvJ9OOS6PLeeee6z6nBcSCA+vmX4RB7p/IDQr+Z0PLruqKUJII31QYybPf/KeoQOMz97QUkIWbWJsgdYucVi8Oar6InNF6xxhVAwo4Ghn339BTx1ZFftrZTp/5eMXJ97Aa6vBi/Qsph00VFZdNEbzJ4pik2j6gtgcU77Oirjivf+GshRH2KSgtV6efh0NKdRK6E4uMsOWmpG
 aTM0sxjP
 pQcV85HDxHHgyTin3m6n5QJWRxDKWrHdKEhfD+svGachvtNn+2JX8SyMZOCZaWlL8WQuR4CthCnEHSz/29VuT9hYkmuUkSy2jOqWgCjVmd2Ha9k7S2CqEv5UPZxecFWo8CRhFxTbafC+tQtMHY2czIcQH5qEtlpUbQ8ZewT7Z2RhK3gh37GTKxICsWYmtJ1zSNbBtfU5xpNpvojQWgazc0RvuBcM1AykeazYwo38LaNkk1FcE55Gs78TfIf+kYLSuI4vZllon8dly+22enO4vo7BHVGeI+UzQsrGffmeFIs8wIjLhWJaI6r8uzYdGrYw0IBs+XPgC/pE0mVqEB7SXIe5cvUSPG7np4sqxHar11THZChVgqcEFAljr30OD4dM88Ds+AMvUq+y7kJph8gqDwToc1KyDlAuSEid8mq+12OHVr2ddo2oOwa5nmYwvXJodIqWmX40YWhxVg+UOwEwqyhUPyh8vqZZhXT7rZNbDZCBcth841juTWp8ZmCReeKxDI4g3c4+EAm4VGFoFA0YMXbh1WxplZ3qWbK/4KpxA9lMSgi9f8lXNESSOGfq7spCqOsVwxPl+TaX0rjQfTgoE863HIhWTFaAaPD1leh9s6Ia6NGiLsOwCitqjvMFhQdyOnBYEzjfSbvSOYJrssD6ismklSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 09 Sep 2026 14:49:28 -0700 Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org> wrote:

> From: Ackerley Tng <ackerleytng@google.com>
> 
> When folio allocation fails early (e.g. buddy allocation failure or
> cgroup charging failure) and a reservation was not used (meaning an
> unreserved global page was needed), the subpool page acquired during the
> allocation attempt must still be returned.
> 
> Currently, the subpool cleanup error path only returns the page to the
> subpool if a reservation was used. If no reservation was used, it skips
> releasing the page back to the subpool, permanently leaking the subpool's
> used pages counter.
> 
> With subpools now always tracking used pages, always release the page
> back to the subpool whenever a subpool page was acquired.
> 
> Opportunistically rename the local variables tracking global reservations
> needed and global reservations returned. This clarifies the accounting:
> a value of zero for needed global reservations indicates an existing
> reservation satisfies the allocation, while a non-zero value indicates
> new global pages are required.
> 
> Adjust global reservations using the difference between reservations
> needed and reservations returned to properly handle races where concurrent
> threads interact with the same subpool.
> 
> Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Cc: stable@vger.kernel.org

LGTM,
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

I think that we get parity in the accounting logic between
alloc_hugetlb_folio and hugetlb_reserve_pages is a nice plus as a result
of these two fixes.

> ---
>  mm/hugetlb.c | 23 ++++++++++-------------
>  1 file changed, 10 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 9eb9f3442574c..652cfb55c6e6e 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2957,7 +2957,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>  	struct hugepage_subpool *spool = subpool_vma(vma);
>  	struct hstate *h = hstate_vma(vma);
>  	struct folio *folio;
> -	long retval, gbl_chg, gbl_reserve;
> +	long retval, gbl_resv_get;
>  	map_chg_state map_chg;
>  	struct mempolicy_interpreted mpoli;
>  	gfp_t gfp = htlb_alloc_mask(h);
> @@ -2996,8 +2996,8 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>  	 * Or if it can get one from the pool reservation directly.
>  	 */
>  	if (map_chg) {
> -		gbl_chg = hugepage_subpool_get_pages(spool, 1);
> -		if (gbl_chg < 0) {
> +		gbl_resv_get = hugepage_subpool_get_pages(spool, 1);
> +		if (gbl_resv_get < 0) {
>  			ret = -ENOSPC;
>  			goto out_end_reservation;
>  		}
> @@ -3006,7 +3006,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>  		 * If we have the vma reservation ready, no need for extra
>  		 * global reservation.
>  		 */
> -		gbl_chg = 0;
> +		gbl_resv_get = 0;
>  	}
>  
>  	/*
> @@ -3017,10 +3017,10 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>  		alloc_flags |= HUGETLB_ALLOC_CHARG_CGROUP_RSVD;
>  
>  	/*
> -	 * gbl_chg == 0 indicates a reservation exists for this
> +	 * gbl_resv_get == 0 indicates a reservation exists for this
>  	 * allocation, so try to use it.
>  	 */
> -	if (gbl_chg == 0)
> +	if (gbl_resv_get == 0)
>  		alloc_flags |= HUGETLB_ALLOC_USE_GLOBAL_RESERVATIONS;
>  
>  	/* Takes reference on mpol. */
> @@ -3074,13 +3074,10 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>  	return folio;
>  
>  out_subpool_put:
> -	/*
> -	 * put page to subpool iff the quota of subpool's rsv_hpages is used
> -	 * during hugepage_subpool_get_pages.
> -	 */
> -	if (map_chg && !gbl_chg) {
> -		gbl_reserve = hugepage_subpool_put_pages(spool, 1);
> -		hugetlb_acct_memory(h, -gbl_reserve);
> +	if (map_chg) {
> +		long gbl_resv_put = hugepage_subpool_put_pages(spool, 1);
> +
> +		hugetlb_acct_memory(h, gbl_resv_get - gbl_resv_put);
>  	}
>  
>  out_end_reservation:
> 
> -- 
> 2.55.0.1007.g17ff1f9808-goog

