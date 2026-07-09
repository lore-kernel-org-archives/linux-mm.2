Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7079C44506
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 19:18:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93F236B0096; Thu,  9 Jul 2026 15:18:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 917256B0099; Thu,  9 Jul 2026 15:18:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82DE26B009B; Thu,  9 Jul 2026 15:18:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 51F626B0096
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:18:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D7D98A028E
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 19:18:28 +0000 (UTC)
X-FDA: 84970199496.04.188ACED
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1583420003
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 19:18:26 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TZl0zI5e;
	spf=pass (imf31.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783624707;
	b=q/WbQ7/tzfdrJnEnbFRX/I4oq1vGkgwDti8vMW5NqoUAaXtYEakx6ygqE0a2KxER9YCGZM
	QDlQNFyUNYyDzjDWkHKntRbR8cMHBfAucwsa2MOW7sa/RucIx8fVnEsj2lk4LVF4stWPS/
	/W95yjot6sFSbShGiU3jshT6Qsto/nY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TZl0zI5e;
	spf=pass (imf31.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783624707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4lZy5V414EOn9MhK1F1xbwGGbvkcelbw9AoBZCDSoa0=;
	b=L1tYkloDyOt7sU0GvIb22NFzykvt5IsTdaVweQ1q1ze2CDCaW2BfkKuIMq9N5tT6T0s47C
	d5zFXOgjf9TQkyujegE6Oqec/HZ5z6/19f6oq9w+a7virEe2CLODkMGd+yDuHV8R/UKXCO
	9aYcg/PeOER+Zq3xFu5zcfJkbslz2Kc=
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7e9f1f24cbcso195380a34.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 12:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783624706; x=1784229506; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4lZy5V414EOn9MhK1F1xbwGGbvkcelbw9AoBZCDSoa0=;
        b=TZl0zI5e4oZIRL/g2CLeO8c5B2hmK8ublNmSVTQuVdJIAyyFJXx9gy497Z+ZVoDQ1q
         p2H4VSLDEqWzv+gQ3lohhWpDLTngOWSZOm9gyMvbILzhsEVVu+PpYYje6/T2uBb9dpy+
         6bmQw3VWqGnMM9d0BNxM0JRQM99tO07CgWHDaAYT5tLg9BTbV5Chich06ar66VHog4W4
         9Pc5FrG4OcIWfcdNQmAeLWs7O9ETYJw0UOId2btooBTRPW3m4QB1WVOG6JI+1iLTlg5k
         31iqbJJyo+zNEIXVN23jSj2XsxWLdZ6TPbE75856bPQj5sFdkMRUslZM8Azq4siNwLxB
         428A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783624706; x=1784229506;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4lZy5V414EOn9MhK1F1xbwGGbvkcelbw9AoBZCDSoa0=;
        b=a4KhX/VNqnzWXEmrHDh8E0W4lUNjaR1J9gTKBS1cYLHAbiNpxPYwzQ8+zfdmICONA8
         1LDR2gftICI/XqlkXcA+yRroC+/O8Fk47GNCOYFwrw9z8SsZi2BZ5u/iZUX+MFlKtq69
         jJrpq23POxx22EzuEJSXE36XS/aBIv4gV72eu6fh5d21BMG6J4sb2zVlI6pr6DEvHIUg
         Q2uhIKB4DLWCrl8l0fFCaX+9UpX2+cveXTe/cq2nx0pGtFvicMN4620OI3xqxzp4DZUu
         mF3vi7B3gYDWJumKC2wCLg8ZyR/oeB3epiEYh/U+zSW1XiySdXdJYrbO2eTGzhXnAubP
         Q+EQ==
X-Forwarded-Encrypted: i=1; AFNElJ++Yw81Do4/LTIwofBOa8rZ7wSwkm0+Xirx6mZGnf9wLot1dvs8wQl1EwKyGM3OMUPC+5YVpMxjAQ==@kvack.org
X-Gm-Message-State: AOJu0YyYlpeoqYDpWpMN4PWPQbEuql1TsQgtbgqJJKXJ+W7IMWo4+1hB
	lV26vNXSB/e0LNy84DYXlRXy9D3x1L8Bt3bIGd0TrWAkgRMIpzWagA9R
X-Gm-Gg: AfdE7cn4EmYEOUVsS4vQr1U2NvB2gO565w3GJfCkc59NrKrVJpgzVcJ/JUftgEYYkfe
	ne8+/lveb0fXuamX5yp2GuKbI3TsYeLgOSEF7e0R/pouAxbBRH7QETCQMwHlD+uGbBve5QJOPNP
	BI0Y12IpplCbMbNtOhFNDLrpHj5s6K/T5dLpCjPzXqBJwQoMMX7X6XVkZsQdYQWyQiHAMCbQtvy
	kJT+AaQDRWPsX2u36rg0DGpVCYzAZaGX8gd9WoA0gisBY9xoPcetXds0qTByVWIp4/NED01f4tH
	ipEJnBatDicmSZ1Tqaa+AqhdoRbq+1+Wht7YtzGmPwCsWdp9esl9i43hr7hzzJ24T+s730wpnMI
	+hbtP3aDS4mLB45cCO4m1qI9LO6h0Riz9NJYS1AT6OOv8EGaFtYMtjC2RvQwP18ynvpQMbgq2fC
	TgxvFGNRtDyUdMylTmYIgHZ+XI4x7rF2reiRdCBpUABco=
X-Received: by 2002:a05:6830:26d:b0:7e9:e288:5d45 with SMTP id 46e09a7af769-7ebf291f688mr262898a34.18.1783624706057;
        Thu, 09 Jul 2026 12:18:26 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:70::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ebcb2631dfsm4741295a34.13.2026.07.09.12.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 12:18:25 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Xu <peterx@redhat.com>,
	Wupeng Ma <mawupeng1@huawei.com>,
	fvdl@google.com,
	rientjes@google.com,
	jthoughton@google.com,
	vannapurve@google.com,
	erdemaktas@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ackerley Tng <ackerleytng@google.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 4/5] mm: hugetlb: Return -ENOSPC on memcg charge failure
Date: Thu,  9 Jul 2026 12:18:22 -0700
Message-ID: <20260709191823.2180602-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260708-hugetlb-alloc-failure-fixes-v2-4-c7f27cbb462b@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1583420003
X-Stat-Signature: 6rmiptc86p9sqcwmqpnz7ohkeuys3tkd
X-HE-Tag: 1783624706-896477
X-HE-Meta: U2FsdGVkX1/YyZ8f9Ek6bqimVhVZDakGlHuR533LqOBkhm9s3SJ7R0qInxZwaoq+vj94dR/w/9R2HVJdP6oYnXuB6aQbPO40HCHZ+Ehdp4XCY2oR/b6TRD+YPt+J8S/GhX4tJsbWcPyyoglGHKGFWWZK+kDbuFvJy07xQNEs/ix8enmW1Z/0k0ckp8Qy3gYQmlHNY1GhNtkXcDmn+TSeMcWp5SyaYJxAew9wy5eFg/Xyjm4z1B/yM8Ij6k81QpfVjVqICsZnqmcKliJGL4/H3vQbWesC/01ciu/LRXCW324UorHudyDBNP+Oet2jWVoLRnY1j2+9mrtZM9x+5q9i3BGCMsXKSCGRc2A8c7iv0Xg6GVLs2KSmx5PNijkynE8oNbBnh366vo/BCml+V5AOhY4T5t8eoETHB9oBRH5TGYKJUZN5uYXS+5IGfy18mycNAE7sZUfgDd0AyawbcKyhvQMqAQ36VPkjzsulxP257pQX7eaCyMB8dIDPH9Qs9tFgvaBV3FgJ5ovyUYRFE47NYmFPNMlZUuzMFT6CBwrEU/JEBpLuzatGamTad9D3Z/gguFZdl5rHz3y2nBQEqrxnWL6PH0WnLDA7eI9yrtsPmR44U9TM0ENxdXqUTWK0ZzBNiZ/A00obVQ4DATOFPJjZrKwsaV2ciTDRAp3+8ESXmtZUggFEkH6fSV7lLiZg2igJUt6hLxLGbpYFKT/qBLfrgtROyNdvnaL7aZ1LLB3wN1laaM8a1RmZu0C4OZ1499AGbsZ02lXSZsxayOCWxnEDQ+gDJsZzbIuLqnyKqqFPE2T7FjT/GsesNq/F5faMfeVBamzWiLGGoJh9y7hrQwkPAxfm/60LInTMoZIN7S6XJwiVJ286/zVa3iWNAdt+cfqj1xD8KW912gknA2Smfg/LVX2Lq1f8dGhQNU1a6JqQmVwk++gISsvAgcVr7AQxrYE9XoH+LQ6IcYuFmaqLSyB
 mD01G2zQ
 IzHeyzttBNxlnhVcPMfO7s5dAzGp0ij5UcQRrg4KLX2hPES0q5MkO9h9UPVgOlyxM9agA+Q/W0/9FSgXWWv/S7hRjoqQo/NwoHrzz71jBFuI7AHSwy1ppMAvySWclgXIZ5AuFwUOjNlq6IDdIvyql6sXFQ6AoQqOX6WcmbVBw7Yf7yCfPK/HfS6tryEOQ3dejXfkJMQsuRfvH9IHBQuN74afgK2mx7v1jgLnhumqR46edQ/td7RsPW620jB3eAIzGyBRzomUX5H6xxy6e8VZIZ/EUWXij6s/fi7eTUjI/9FenW351MNia/zQHHH+GZQLemOGs8eoUHI/B6Ati8PEoBUd+YfqI4Y4xx6aHWzFiCbKBjvsfiLaiJSheDQjc+8UZF5BfmhrrIDK8fJNrFSfR+k4XxXhQStBaglTzPONVfxP11f8TkXrTfFti14WOFeziBQnyX756AY0MUWZYHfWNWaCM6XzxYDWrnG/qkMhUlVn3zS2iNGS7JpazJzL51xLSNtxAD7ghl2ALT4Wjus6dgeCJtBF0CTzmV64GJxpr5WGRj8vCAVytjBYvvOBXp/BGB5Z/m3Hj2DvMfDiZjQCTZkE56WG22l4B3HmH8GDlhn9R2QeyPRXgHnwPr0F+Ty+JzutewwWBJRy5jxNz2R32Hu3plw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 08 Jul 2026 15:12:52 -0700 Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org> wrote:

> From: Ackerley Tng <ackerleytng@google.com>
> 
> When mem_cgroup_charge_hugetlb() fails with -ENOMEM, alloc_hugetlb_folio()
> currently propagates this error. This results in the page fault handler
> returning VM_FAULT_OOM.
> 
> Because HugeTLB allocations are high-order and use __GFP_RETRY_MAYFAIL,
> they bypass the OOM killer. Returning VM_FAULT_OOM to the #PF handler
> without triggering the OOM killer (or having it make progress) leads to
> an infinite loop of retrying the fault.
> 
> Avoid this loop by returning -ENOSPC when charging fails, which maps to
> VM_FAULT_SIGBUS, terminating the process cleanly.
> 
> Make mem_cgroup_charge_hugetlb() fault handling use a common error handling
> path, the same handling used for hugetlb_cgroup_uncharge_cgroup{,_rsvd}(),
> which also don't trigger the OOM killer and hence opt to terminate the
> process with a SIGBUS.
> 
> Fixes: 991135774c0e0 ("memcg/hugetlb: introduce mem_cgroup_charge_hugetlb")
> Cc: stable@vger.kernel.org

Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> ---
>  mm/hugetlb.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 1f3f4b964b153..3e1d99f03c70e 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2991,7 +2991,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>  
>  	if (ret == -ENOMEM) {
>  		folio_put(folio);
> -		return ERR_PTR(-ENOMEM);
> +		goto err;
>  	}
>  
>  	return folio;
> @@ -3014,6 +3014,17 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>  out_end_reservation:
>  	if (map_chg != MAP_CHG_ENFORCED)
>  		vma_end_reservation(h, vma, addr);

NIT: is there a reason why the comment block below doesn't go all the
way up to 80 columns? I also think that we can achieve the same effect
with a shorter comment block : -) I think the essence is to answer
"Why -ENOSPC and not -ENOMEM?"

> +err:
> +	/*
> +	 * Return -ENOSPC when this function fails to allocate or
> +	 * charge a huge page. If a standard (PAGE_SIZE) page
> +	 * allocation fails, the OOM killer is given a chance to run,
> +	 * which may resolve the failure on retry. However, for
> +	 * HugeTLB allocations, the OOM killer is not triggered.
> +	 * Returning -ENOMEM (or anything resulting in VM_FAULT_OOM)
> +	 * would leak to the #PF handler, causing it to loop
> +	 * indefinitely retrying the fault.
> +	 */
>  	return ERR_PTR(-ENOSPC);
>  }

But this fix looks good otherwise and I don't think this a big deal : -)

Thanks Ackerley!
Joshua

