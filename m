Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AEBEC88E45
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 14:50:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FAAB6B008A; Fri, 11 Sep 2026 10:50:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AB3C6B008C; Fri, 11 Sep 2026 10:50:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09AF36B0092; Fri, 11 Sep 2026 10:50:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D810E6B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:50:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0F0BB160225
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:50:05 +0000 (UTC)
X-FDA: 85201766370.09.5A8E6DB
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3B5EF40008
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:50:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dCJzIbQ3;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789138203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PMudlUwrJYcDNoa2hJH18RbyAg0bqvV48oum1eI5mvg=;
	b=UkLmf9ult4jd8ECgEvRRZFiN/50SZe/JhYW3A/VDYzEwo6l5/223UTuFAW/Ft/Yeb3m0o+
	8R0e3ezfoFmm+uoxHURGL6axmpizs7RixXL0RWQvjTelDfezmWwnOOz+bol6hpsTOjo4YZ
	6aFmOuDcDaqcoSeu2//zvtGHBHvd46U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dCJzIbQ3;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789138203;
	b=sJNqnlysdAd3HOdJlOL1L60pWSNagkbGB5XpjdlsrDZg+sx177akXGUFcAINBlqDXNLtxm
	P1rAK3OAH56xm75hLJKZo5RV+k4AIcV7EwkWzDWkPVUqkZBqwBCFDG8d4EBD+VSz3gZ5vf
	0ayEsJXaOPw4DuMwRw1XUzmUYoF/ySA=
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7ffa69b7462so1042521a34.3
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789138202; x=1789743002; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PMudlUwrJYcDNoa2hJH18RbyAg0bqvV48oum1eI5mvg=;
        b=dCJzIbQ3Q4vLs02vY5A/alDgm+tF1AH7DNK20m50fFdQHemaiduqIM6MiVFT46xHXS
         hBZ7575iQp2H+5H1vdMdYgmxPeD1Buh4XuA4eWRTXmo2rqhkuAQz4qJi8yGArpyi3QYO
         w179K/c7R6IzjYIYHYIwZtQ+eekai4Y/QVlk99DvA54rrj/jUdg9n5jSzp/auANIYBrm
         NJgmMxZQgBx3jxzzRDX1aid5fHPjJ2cNmbFc+ntijRWpMHKIWQEtqrAMCXwdb0bfA0dH
         cx8Ag804C9j1YVfs3WW5uw4HktqJxIQh91b9MIzfbcYUI4A3vGpdymRzjMzByEVIGnjp
         swRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789138202; x=1789743002;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PMudlUwrJYcDNoa2hJH18RbyAg0bqvV48oum1eI5mvg=;
        b=RETjp5AfeF8+ZNrXBFA7N1+pEwhowP4FfqlMIUwrSrNJKkD8zW2mwp7krdDabdVwLJ
         Tf13hHikUQ8no333eECouX7PnzHSs3A/kcPucwAsa+iET9YoFHVl3AK0cydv1xvTmAHQ
         4W43WDBenLbHuHlGNGUzjyJcd1H0ZEtwDs4cc/uQACWLGb+MtEOMwyms7js12X4dTbCF
         DCiYgp2EMnFJsmpEmTJpD7p5VRTknWGLJ1gJJEVkI2PGck1EILKn5oIxnzudVMdK84z2
         7TgarePujKuX4EIY5PzSpqVUPDlC2q87ks4iDotFK+P0hlEj29ZIQDp2pB8stowEn4J6
         Yg1Q==
X-Forwarded-Encrypted: i=1; AKwUvBys7s1khj25kTRd9LnofgR+XRo59NYvGh+JWYiR4XnPWmNFlAc44uhkWiftRIqmCnPhWwICCxUJEg==@kvack.org
X-Gm-Message-State: AFuF++mMO5a5jWp/V3Ja5rXgBvSiLbYbBA7y77sX65lEOp3FB2OFwrQV
	HIdrcXu3xqjLJlri4fYja9Br39Avtaq4tnvmFPwCBNNksvCcUdt22cLR
X-Gm-Gg: AYBFou1Q54uRKG2ObI5WcxaRuBEmWzF+VkpHr9mfCoR3jEAMU7fZzi8ZSdbiYHpGDCa
	5gHlP7aUeQNI88OZsND5k9udWdrP1huoSMCLmhDvMULYpJ6E5aB1BLMqpusdcH/PPLQlgZ4rZfN
	3BCBIkWGFoAfrDC7pazyXKGI9x798BQ0J61j/WDJhcwe0XlBYiYESn+/oQ+NDhBy8g5VkIdiaEu
	lKp+4vmdDUcTMQ549jCnVKKHJxNh7mzi4GOFRCj0G5NZVXpsvsbaoQHNveDPLnI13NNhqQtCYM6
	UNrdc5n6VFzfhnRlLPC4GFL7g+foSgZxB9Q9kG6Ezy4/JtwhgV6pYQDB+3DknXnl5jPVC9eDW4o
	Oy90xOGMc2ZAsNxq6F3A2X1LzSkJZdcPtl8/fQY+rc5CuuUnxd3Ya8XViwNawWXxx/0xBqgu/t7
	oyHX1Te0Cmbljt9O9JVGIHkZNqVuzTFyrBnr/PU4ORxpw3TsRWFP2wi+FRIq4puXfuIGmxIWwpu
	MISJ3C6azWPqaxAocrTxVEzMSUZLA==
X-Received: by 2002:a05:6820:81cb:b0:6b7:8415:d779 with SMTP id 006d021491bc7-6c0bc0d6963mr2931638eaf.36.1789138202157;
        Fri, 11 Sep 2026 07:50:02 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:35::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6c09690af1dsm2652517eaf.1.2026.09.11.07.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 07:50:01 -0700 (PDT)
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
	Ackerley Tng <ackerleytng@google.com>
Subject: Re: [PATCH v2 4/4] mm: hugetlb: Avoid re-allocating global reservations on region add failure
Date: Fri, 11 Sep 2026 07:49:59 -0700
Message-ID: <20260911145000.3881046-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260909-hugetlb-subpool-always-track-used-v2-4-30c5d83b572a@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3B5EF40008
X-Stat-Signature: fctsnudqh83sqrj6nhik1y1r84g4i133
X-Rspam-User: 
X-HE-Tag: 1789138203-493084
X-HE-Meta: U2FsdGVkX19+EwDz3clzecvhbvzbKx1eJ4u+eZ9hNREtJ+1ccxDlgvnYbuo5GWdg2Ff86kBb/VfKOlPjb3b5xnwtMNj/Zm8azQYKhNtdLRSfTx02EPz4tA6Tz7J4kM7vS9ofZQvi5a2tDjvCNrV8iyIMYjzRZJbCQ9JePyU0JZvdcKSadWlmrLJrAnnsPaDCOXMcWuuexJoGkgyDSL3x6BWzYcjd3PGTF2kilD6Pgh8rHeIdeutGtzWq96KRHz3g/CTljyvAeawLXt2fUa6pEI8UpZgaX6AHiGWCmDfiKU+qZgkDtrZJhPMA50pSlpn0Yf/aAIXG9XjG0vB8+rqEdUil9P+Y3TwGBmjJbwu3pM3IWdVu7iB1mmsX5LwxezJOT/OUQ4lqTZnygCtn5f7r38XwBfE6Pqyvmrxp+WlfRzx8bA82aKhbnC1f1qq+C5ZZzXNwLFSa7fHM+NTp6vtiGOzFpPDoJMzFHuav7IIT7Fy7QUonyDJWH6CBK5PRIxBjkjaDEy/0fN+woLmkxBSMybXiMauiCjTZ9g9IhNnDi0oZPDvMLZyT4i1rTvyi+483CyAMdVxVPSNAS5uQmJ17sDDCjNi6ZxxSg4oMZIRMg6G5KJsW0HD9oBeRHPUIwu+ldN2bHIxfLnx/Agc7RwVVAdlJpG7MfzhR3CFRGaRNdUk3GzW5So+5zLZbA6r0/YQ+1BuPm+ylPbQxjxskA7T9XjCi9skty+HX+vQnjQ+U+/dZ2xZ8Xk9HDw+K25yj78jiI54s2eDY2cqhcLbGaAhqBUx90hjymqWc7Mc1exr0HlKBjktLvry+blphnOW5iuEnmX+xzDW9dmAyAipex2vATk9BDM5XMttSTQwQ8R1pt4m837BQOOZISQKkXZy6OIuFtpOyCgB0ELMK0020mKkIFtH4e8rR96EVpLrUz5Q03qhM51osDfjLRzN+MwapAcMGqvqBYUIAhn0U2+kBWw0
 yW5zoj55
 F8gEjKFVCI8EpQ9CO622T/dMqKAETqCOuRR6atx9qdXDGBJL/XXj7e9isRw6mMEnH3XaTb10Nc86DA0gI+gVi5XRFxYW2tQEDEqEZQ8v60ckj+CHV+Sg+JFZICLO75n63sjkvVidkMEYjhhilixOamPYJhJ/LHys+U/K/7jjpQwS11W3jUkMpAzdbmFmlTswnHEiXadMkpce9c+tGID/yfKgpATrJpcsyk9RVVTAENvCRiaNOyxtyO1CZV5cF0IsPKq1URpmgMTyKNoeK0cquOXjacMW25q304QgNF3lcvmUdwj65igVA0RcwaEnwZko3t9xhbQOfDsEBn9UtR9vz94cI6Aqyk3jfm3oAeFQQRUx9oumVkZpq5Go9wEPpMuU04fGTap5DSCD/jmG2G8lt57ndbaudrE6x0Ki1XtWLC+LMmQWx+Simrw/+SRV1n/Z6kG4JFEp+rEXzncejpwGzadmFNhuMvJFDDjx7iyZIp79EknzoHI4oaNB16/RZtKZUGqiupkO1MlV/EUIzJBmh9V+Pk7IXDUnFOS6KDGGbDdiyf2dJnIYeoTqkeuddSlUEJvLpw2OTCpM3sXYx/Zq0NW67mr+fNOaHuCE096uTyqiQNNEx3CbdHBTo+NETogiyw4Jbxi2M9WMvJbLDbNyod6FTCx9YWUuP7kNI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 09 Sep 2026 14:49:29 -0700 Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org> wrote:

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
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  mm/hugetlb.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 652cfb55c6e6e..1151ad959ffd5 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6678,6 +6678,7 @@ long hugetlb_reserve_pages(struct inode *inode,
>  	struct hugepage_subpool *spool = subpool_inode(inode);
>  	struct resv_map *resv_map;
>  	struct hugetlb_cgroup *h_cg = NULL;
> +	long gbl_resv_accted = 0;

Sorry, I think I have a hard time with this variable name ;p (I know,
even though the function is called huetlb_acct_memory) I get a little
bit confused because I can't tell if it's meant to be "accepted"
or "accounted".

I know it puts the line below at 81 columns :p but maybe we can just
split it across 2 lines?

>  	long regions_needed = 0;
>  	long gbl_resv_get;
>  	long gbl_resv_put;
> @@ -6768,6 +6769,7 @@ long hugetlb_reserve_pages(struct inode *inode,
>  	err = hugetlb_acct_memory(h, gbl_resv_get);
>  	if (err < 0)
>  		goto out_put_pages;
> +	gbl_resv_accted = gbl_resv_get;
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
> @@ -6831,9 +6832,10 @@ long hugetlb_reserve_pages(struct inode *inode,
>  	 * There may be a difference between the number of
>  	 * reservations to consume and the number to restore now if
>  	 * there are multiple threads interacting with the subpool -
> -	 * restore the difference.
> +	 * restore the difference, taking into account any global
> +	 * reservations already acquired.
>  	 */
> -	hugetlb_acct_memory(h, gbl_resv_get - gbl_resv_put);
> +	hugetlb_acct_memory(h, gbl_resv_get - gbl_resv_put - gbl_resv_accted);
>  
>  out_uncharge_cgroup:
>  	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
> 
> -- 
> 2.55.0.1007.g17ff1f9808-goog

