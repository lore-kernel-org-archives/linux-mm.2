Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 451BAC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 03:06:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3778D6B00A0; Mon, 14 Sep 2026 23:06:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 329256B00A1; Mon, 14 Sep 2026 23:06:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23FEE6B00A2; Mon, 14 Sep 2026 23:06:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F093E6B00A0
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:06:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CBC1240303
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:06:26 +0000 (UTC)
X-FDA: 85214508372.12.2F14ECF
Received: from mta0.migadu.com (out-205.mta0.migadu.com [91.218.175.205])
	by imf31.hostedemail.com (Postfix) with ESMTP id B2EA120003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:06:24 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CRCsoEYU;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.205 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789441585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vM9Tk8MscMlzR2l3LHyKuRfAudspLFeMkX6o4LIbTq4=;
	b=6dtLJo87sHB5YYAnoB/GtzvWODdYIFzv7zVE1ZipyEqgCxeeeuRuafaFBpvrbxbFmA9db4
	6GyoC+SiyGME+WHU2JTN9pElHzKwv4y5kKKa3GHuVXonqtbeb6kcCVw0EhLIBPhnbwwMWK
	TnF7BUyDPrKktPE0KGW4LuA7lYBeaq0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789441585;
	b=Zx6LYrZwi7vft5KzFdIPrfTnfKnMMLLhhNZSjl8Ew/cM3q4Ws0DDgvB8aLM7hN9RIz0MTc
	ij+RBLrrx6P+utcyxCxNANv9GnSbYm+4ZirlXuGI9wU+4YeIcnyxRX8QTQ0tiR8z+pJeiQ
	cxfavuVPgFh4T4ym/35Vmjz2xwwKqfc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CRCsoEYU;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.205 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=uXNMDvyO4kl4ltOhJ8oInY+Sy61HJ839sxYVp5QCT/o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789441583; v=1; x=1790046383;
 b=CRCsoEYUECttlVZWyUKGf7DOwzORbBibH9Lqi/vOuv/QypPfxEN9xpSx1KflR56gHBNJNzUB
 cdjXJAJ2WJyxYZtkU5LJ6rRMWdaZfm6gB+jtehF3urMbvOb8oUguQy8ltEF8pBOU/N/6g1t0a07
 637icX+Khjd27+J4CKPFkM74=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 5e95220afe937ecf;
	Tue, 15 Sep 2026 03:06:23 +0000
X-Mizu-Trace-ID: 5e95220afe937ecf
X-Migadu-Flow: FLOW_OUT
Date: Tue, 15 Sep 2026 11:06:20 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org,
	ziy@nvidia.com, linux-mm@kvack.org, ying.huang@linux.alibaba.com,
	willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
	riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr,
	kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
	baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev,
	linux-kernel@vger.kernel.org, nphamcs@gmail.com,
	shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev,
	luizcap@redhat.com, kernel-team@meta.com
Subject: Re: [RESEND v7 01/29] mm: rename pmd_to_softleaf_folio() to
 pmd_softleaf_to_folio()
Message-ID: <aqi2LBchW2ehBhCA@fedora>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-2-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914122950.3283997-2-usama.arif@linux.dev>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 9c1d4cbbwhs4m7dxu4wdxhkgmxogsm37
X-Rspamd-Queue-Id: B2EA120003
X-HE-Tag: 1789441584-263822
X-HE-Meta: U2FsdGVkX19Db1ZltMM/8g2qPsquIzqx+xHJAmG6YMrupy5SmPlPZXSQ++viFmp8zVkS/zPrWN1NK9RMZBgi290gJ/9r0Is20UPqkkO8GYkvBldYBmrNtuCnwGkoXxfLfNQWafZ1gCBJzYji/CiGu/r59aWUo0xwVivtpDGoNg+LSzxhAzQRXLw4c36u3tdv7U8mef05+T0lKp5YwDqZxDk8akVY/3CNW0SR+woI/HV+KJz9VEqNzz+NB+jygnXhNhwrAKiCXy/B0s3JTMp1PaSzwSKdeJxnEUx7ir62jxEqJIGIHzlX3jONG3E40/HCN1FaRHll780JFX6cAITeLEYQ6LQ8M1GbUK5rsdzMCn8vJxxpxY8BoQuLl8fk6YznESBS/XeLb6WAJ6wOhma3rSunGBSC8yqG8SM7QnJ2ywcnJkdZozBPPPz97gTfFuF99sCFrPYXupvVLbmUgh/aRKhthxJlGZ/nsoSTfBDzXFzpdRJ1cLs4me/ivYMC5mrNeacSSmjOQEfsFr/6gcZB/mNa8JMSvwwjzgOcTDnb4xv8iTY7eSGZb8xsv3ebMvIcv5DVctKhVJmLbzq/2oh9hrCfPGRe2dHxPMmlVRzdyVsvLUcnjkW4WEU1beufFTV8M6aQxpS/qZ2E93wmFeKvTISarcpgEIvhUwv2EgOJdIa0+g/etRALww0JA43g2tFGAy6l8L02yiMBjx0hPY1vvqRn8KkgbvRkSL//l+awNDp2eR18VPTJ4LWCCAwGH6QQ9vAqBAKfLZ8zaXngtPEM/nF127uMMMqCJf5JJ5rnvO1ZVjOzA6xTqChKCjoHcYFmkB2uekZF2DG5WOIQOU7ATP84jv1WW84BNwi4Pb9g9LeS1cG7I+cK8rwjfevKVRMCaMf1DIom80vcPyWcwrPEA/aDfIH+6afVfsiNThVoLQbEy8v5Mehua39XJjwPBNmPjlhUsOk5zj5sZrqLYYP
 HES96Mng
 Y7FtYK6Buz0hiPFCLdZiKfQ/HXXsC8g/uc8hPeZgJTou8V+v/d87gBKVtajlSUpSJCggJ5IDl68oab2c6XA2Jahdbzup/yehXKnKun1swPmfJwl9FxGDrDZYIeaCRdMrn9bE47QYNg1J45glC/eU8dpflWG/+trd/h4LB82QD4hR/9Cs8qdcttk2de9Yyp+5b79mEybNPoSWmYWQ6yBvHI28sAR9YcZP1qLDbh8g4S9BMKebhDYEWjZ7kFXCPgf8Dq5baM1YYoyxlsuLKCOQP+jF8DsxIbmbA/bhRgG/Znw3xPHZ1KPQIUaTa3YEsqnYAISwIn/PatZWBPD2Tcbd2xrIWu21Wpb1iqE4MrkF1bpfJ/K66I9tpeGPvq8nlc2bmmIRyOnqb39kMr4oeVP55pxOuNIgnmdI32embCkB/hu0Pw+s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/14/26 at 05:27am, Usama Arif wrote:
> pmd_to_softleaf_folio() reads as if it converted a PMD into a folio. What
> it does is decode the softleaf entry stored in the PMD and return the
> folio that entry references - the direction softleaf_to_folio() already
> spells out.
> 
> No functional change intended.
> 
> Suggested-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  include/linux/leafops.h | 4 ++--
>  mm/huge_memory.c        | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)

Nice cleanup.

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

> 
> diff --git a/include/linux/leafops.h b/include/linux/leafops.h
> index 4c1476ae32343..7c13c58a5e218 100644
> --- a/include/linux/leafops.h
> +++ b/include/linux/leafops.h
> @@ -657,7 +657,7 @@ static inline bool pmd_is_valid_softleaf(pmd_t pmd)
>  }
>  
>  /**
> - * pmd_to_softleaf_folio() - Convert the PMD entry to a folio.
> + * pmd_softleaf_to_folio() - Convert the PMD softleaf entry to a folio.
>   * @pmd: PMD entry.
>   *
>   * The PMD entry is expected to be a valid PMD softleaf entry.
> @@ -665,7 +665,7 @@ static inline bool pmd_is_valid_softleaf(pmd_t pmd)
>   * Returns: the folio the softleaf entry references if this is a valid softleaf
>   * entry, otherwise NULL.
>   */
> -static inline struct folio *pmd_to_softleaf_folio(pmd_t pmd)
> +static inline struct folio *pmd_softleaf_to_folio(pmd_t pmd)
>  {
>  	const softleaf_t entry = softleaf_from_pmd(pmd);
>  
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 7140a1031fb2e..ee8d46827ffdc 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2518,7 +2518,7 @@ static struct folio *normal_or_softleaf_folio_pmd(struct vm_area_struct *vma,
>  
>  	if (!thp_migration_supported())
>  		WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
> -	return pmd_to_softleaf_folio(pmdval);
> +	return pmd_softleaf_to_folio(pmdval);
>  }
>  
>  static bool has_deposited_pgtable(struct vm_area_struct *vma, pmd_t pmdval,
> -- 
> 2.53.0-Meta
> 

