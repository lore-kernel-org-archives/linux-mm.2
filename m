Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DC95606A953
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Un/xWjeC
Received: by kanga.kvack.org (Postfix)
	id 404486B05D3; Tue,  3 Nov 2026 03:42:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DAFD6B05D4; Tue,  3 Nov 2026 03:42:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 318476B05D5; Tue,  3 Nov 2026 03:42:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 057236B05D3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:42:36 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6D8B4140318
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:42:36 +0000 (UTC)
X-FDA: 85393166712.06.1F1BE69
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id DD35320003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:42:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Un/xWjeC";
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793695354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N6lF+Cgq07u7hRt8qodG60GURr6XJTFAKElEWQyNaqk=;
	b=ksveo9Nu1T2/5AWkj+k2tppYnG3iJwOjhcXJKhGHxquKg09yJHa8/eOlrd1Dpoql1RpudB
	VSownkp3UUm34iqVSUC0giXoetT/z/2RDYNKK3dKrRTCmPtpo/fshp/+tycmi6Xb3FjN5N
	aQQh1byjYXIEGwtTMMDrpj2l8yZHUfM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793695354;
	b=vchBL1pk7JZ6aPJfacqkyz5Yyz4q3V174/g2tmrms93iCB72ok1giXvjFYqTaFtDytWWVo
	3wcA9MpIbKhPP3w5qHvOHeitNptDEMNgll0pn4pq8Wy609g6xRwv4D8E3l62SjkLUMdL/E
	+f2fFzWiYu/ycvqsnNK+zDZA3yJ8rvM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Un/xWjeC";
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 71BDD6021D;
	Tue,  3 Nov 2026 08:42:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9FF51F0093A;
	Tue,  3 Nov 2026 08:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793695354;
	bh=N6lF+Cgq07u7hRt8qodG60GURr6XJTFAKElEWQyNaqk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Un/xWjeCpHxG02qi7ifK2pzrR3XHFSDlXq6bk5LxW46SJ3N8TkY6AHCyfecvj8TXC
	 HVgo/Zn2AsykqrS+mIEDgxkxMdXzjKwu4t/zp7Af6BFGnsxxHAmMu94Xwxk69rdhEw
	 ZeYluik3rkad0xgx/07HLsT0RAJsn21T79n7Vnkvzv9UTCM4iDsJHGhmc3JGlYLHii
	 WMNGBT8LAid85gaAHYjmzhmAnjY6ACYNzGloyeBEY3srVGo1QwzGDxdjr52LxWWEqi
	 gL1EhVmLPS6pZHreauTHLFqdwIbxhu39thl0zR86q4Wm59q//5Ta2/nKKFs0ZKR5dA
	 pzcrDGaVKt1Iw==
Date: Tue, 3 Nov 2026 08:42:26 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] mm: remove thp_size() and thp_order()
Message-ID: <aumeA1i8nIAlS1EZ@gremlin>
References: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
 <20261102-page-wrappers-v1-8-e7280bdb31f6@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102-page-wrappers-v1-8-e7280bdb31f6@columbia.edu>
X-Rspamd-Server: rspam06
X-Stat-Signature: dc7jff8jycwrj3rce3shrbwc6s3xy13g
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: DD35320003
X-Rspam-User: 
X-HE-Tag: 1793695354-658297
X-HE-Meta: U2FsdGVkX19633G+JdrCzNLJszbzyKV5q1M7daRi9SC3+ao6hkA4R5lGCjw37QNOIVgNxo8Eo5B+1FU7Zo7Z/GyR/iHw2PtgPb99STdqymxLIaTno7Lf00K6d5pCVNdEKCER+IWMFm5A7930JiuhtbCwhW16Bp/o9ZJWrE/3yo8vJgtgyzSAeGFUEq1Ywq2Te+86pLZWPiRN9es8qdoaqbj26gHXR6QmnxLmHjUjCJFkvuYGTI39SOVRDRQyiRqy9EagJecViuwc6pawfVcfpjaHsD0clFmt8roVpg9sbZ0JRJNPNbhynGK7JTMqkbE67SKoSHFB833mU2vsQDgfazIopXPVzquorr1D8NVs0tr22++fHqJVjKZbSc5gOTZOHhE/qyQOMl2R3soiZsunWYmxcA4jtquAGjfUuyoMvU0stMqa74Wxy/QP1SQqoHypbCNCXkTc8E5Xzg++JRBul3MnM+ifbkdxh0xkn0WP58/NefCVA184uXfz16Y6p4OpwpiXI1xdBJryhvl9VWIyHZnisyzVs4Rt1NDpiYm1bsTLylwP63kDNZ0FY1bMWSpJ6RCrIYlK36uPqqdmBdoGNVFn5HRC6zRJ+0RWehYpYtdL1P1WZgAlCh1G7gcJZVS0H2ylh1h25KreNyKlQYR1l3YsFh9Hu2mICJvDsudf58+6O4TmY67O1K5rUa129BpeTtyjAQMp7PCcm7rYZw0uP88l7oCPJaAOw2hJFuOFlYjAXZgil1q+Jh1/es3yuG9YsIB7GKjhxBH1ZZgdZRd1xodXUSe/AP74mp84FwNjqmv2+IoI7JUXrT7Tw4/wPovjHwBIx+RWysYugbyYS4F7l/kaO+j6DPWEsdSNmxpOdZaMZ9DRnFdd7ivqWvP3vaQ012o53YZPiBT/0cbLhvt5MSjZEGNcRTW3WTijGgN3G7Ajr+e8shEK6fHaHj/s+5QQUmpFz607AJWvLT1nPx2
 wWm5hnyL
 QuIGGrr8wsLo0dA5+lYiSAWdfBzIlHtX3wic8D420Gq5pJ0a/JtfFxOIAn5eFAv2jxirdRCUmBgTZxqPgmL8/bZxv9g5GSqwOva8HNL30YItnxFaTGRTRar4IBvUUK9W0CzuUH4V61N2QRw6m3P46XchuczmoLCXlIIVj12f+yY6Rdi+ou17jJ37LdtoPowecB7SRH8fuE/aaVGVr360B9bAYp1B36bTiom2/knSXyadT8nuOvDmtagIQS/zaQ35XeHCBTBjyZ6SBGZ71Vwj2nW0OumOh+dY1Mis7LFSO+o+qQ/OI0uZdMvtfSUXApYiucVyyEqt3j6b+1ZiXToMGc8KRGctzFe5BXGUt9cDiUCRa9jorSQqQbLDZp2liS/qVqmtFuIunoDVYH+U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 05:54:13PM -0500, Tal Zussman wrote:
> The last callers of thp_size() have been converted to folio_size(), and
> thp_order()'s only remaining user was thp_size() itself, so remove
> both.
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/linux/mm.h | 21 ---------------------
>  1 file changed, 21 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 8b5883878538..143865580169 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2146,27 +2146,6 @@ static inline unsigned int page_shift(struct page *page)
>  	return PAGE_SHIFT + compound_order(page);
>  }
>
> -/**
> - * thp_order - Order of a transparent huge page.
> - * @page: Head page of a transparent huge page.
> - */
> -static inline unsigned int thp_order(struct page *page)
> -{
> -	VM_BUG_ON_PGFLAGS(PageTail(page), page);
> -	return compound_order(page);
> -}
> -
> -/**
> - * thp_size - Size of a transparent huge page.
> - * @page: Head page of a transparent huge page.
> - *
> - * Return: Number of bytes in this page.
> - */
> -static inline unsigned long thp_size(struct page *page)
> -{
> -	return PAGE_SIZE << thp_order(page);
> -}
> -
>  #ifdef CONFIG_MMU
>  /*
>   * Do pte_mkwrite, but only if the vma says VM_WRITE.  We do this when
>
> --
> 2.39.5
>

--
Cheers, Lorenzo

