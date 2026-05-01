Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5B3ECD3424
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 12:44:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3A0E6B0005; Fri,  1 May 2026 08:44:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEAC66B008A; Fri,  1 May 2026 08:44:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A004D6B008C; Fri,  1 May 2026 08:44:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B2736B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 08:44:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 13FC11401A4
	for <linux-mm@kvack.org>; Fri,  1 May 2026 12:44:21 +0000 (UTC)
X-FDA: 84718819122.19.F7F58C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 42317C000E
	for <linux-mm@kvack.org>; Fri,  1 May 2026 12:44:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RjmgYGCa;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777639459; a=rsa-sha256;
	cv=none;
	b=uImWm8Fr0KcpGJz9+wvfeSkVPZipqpTx5qo/CvwjEp6m1KISHTtIACRJrLhEk9p7EJq04Y
	cGQFL/CftUrrAVWxaZqPHas2q8pMFMd2lhz6SBHh1E2S6ukG92R+LKOHhw1+7gv+vmjcEp
	MLw/ecw2+tRLD/Cz5Kbb+2pHujxp8yk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RjmgYGCa;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777639459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6WLnk+/b5GTzb5PZ6wW05Xz3J7h34Vd4AYl81xS0iiM=;
	b=R6aBwmOQefxDWKNn7xH78Cb14xRB5P+rWkwZ4y2m+J2Cfs/jv2VazK95JxBT+Akf3eMs7L
	vsWF/p7OAnfOKyYZnmPICoDy7yiWUJR3w4bb4FJHW0hFnTTW3eXYYireC0gO541Rk/fBBj
	EeaZWV9oQIzKfFvdzZrjOPdRdEX01mM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D7CEF43477;
	Fri,  1 May 2026 12:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8ACC2BCB4;
	Fri,  1 May 2026 12:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777639457;
	bh=xTzYlDIqwIv4dqw3qIFMC64OF2XOl9jQzRn9UnXJSNw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=RjmgYGCa7UyCJ7lx7/0EfhK/J16gKr8IRsSrwRPcnbaD0PR32D/q9aPfI79+dW5ZT
	 ulVSkAUGrvA4wE9sbWn4LJ5en3nhaP9ATzj+xJs2SRYlw/UTo32LN3yLmQjl0J7WzS
	 RetG4K4helpFwjzenIuCqTsW3wTwnlWRlkBUigi4=
Date: Fri, 1 May 2026 05:44:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sunny Patel <nueralspacetech@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew
 Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory
 Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Balbir Singh <balbirs@nvidia.com>
Subject: Re: [PATCH v3] mm/migrate_device: fix pgtable leak in
 migrate_vma_insert_huge_pmd_page
Message-Id: <20260501054416.af0ed62d635c3eb01d425e61@linux-foundation.org>
In-Reply-To: <20260501115122.23288-1-nueralspacetech@gmail.com>
References: <20260501115122.23288-1-nueralspacetech@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rmjsryyqu5ntwffni36z7hesrn78wm6i
X-Rspam-User: 
X-Rspamd-Queue-Id: 42317C000E
X-Rspamd-Server: rspam07
X-HE-Tag: 1777639459-775240
X-HE-Meta: U2FsdGVkX18IJ/BVGioKrTykbwnrNyFqLMjRvczRMCyVjck9CkucxY/xIL9kmOJENlsNbx2Ix4PHaN4cy5a3XWFxwpnTUaamyuwss+lEfZB7XiuN9yObZ7Q0XlRV/bF041uHaBy99vwwrsTE99CZKuPl/t2VMPMMG+Sqy+cRXVSdOJI6eXKKZ0AkFVOWIdyBnhxieospK38aD6eorPzFZ4xwHjstYrOeXkZsgq7l/zPIy+VDe46uwXwc7tmbRwf4eiZ4B5Z5B25W1VvS88gTXFDu2tM9yf9L8WaL4/vxds9pAtor5lHEmuJgsAfgM0hYlJ2gcGrRq1WawclrPCQZ4AO1FlqKc9vADeDHk+dtXVRjURgCX2KVLwdZYSgy0XvMuDh9h1MOcMisUPatoBMolrSr/J+/h25IE82tRyoXtwEhuJZJSG995qdpZ1mF5qnuzB18tDl6yOT6Bsk005VXzB0b1st4PPd94ekEaNDp94q752rg0328xS/iVVz6bmrZ6IOS3DEykd8tzBmB+hR6p4P1tInk2g6De/LD/ETwkSdPyh/Ke7TlX8mkUzXXYMrCKVRmzkbUKNN8aqumfkc0mE44KiPPe7T3tAbA7JmK1LXOAM7V1VsoQznDMh3ksHnK6iRAN9YeMqFsxZcXas3eM/xAGcOXFtTAEk7IYnbkJ8mTq8JbXv8OusmHLsD6yJTychT6+/OyQxwy1S2VQsWjZGK57ctKNjYIUtBrt21yjgsqJZgWPOAkQvNMZ4i66H00d/a8TtJaqfp2mY59X041+rbAF/Ramo9WVORE9m66ZIJSYUvPiJvL5RXA2fdxgJbqRzRws4psLG5YOx9CbI4vC3AxBwqr0noJsgNrRq2+Zig6C4aUgqioYuf2JQaDOLt+4lYpTn/K3bg45PV22VlZ+bo4EbSRqi69Ov6HlHO/cCi3g2duUMEYoFBGm2DXrtfTAoLCScGHkvXnakdMjzy
 rbgk/H67
 QnfrKF65N2Wm/VQ5dGTJo6lGP2EnURnGwFU9v9891qIFvOxZtQBgQzS90jeKBtdCiQxsr1JYe+HBcbU4TRZjLAAHaV0+57hg4q8xKkwHebhg2MTzH8DQNFKDA+t18wk6dhHCOqVGTofFsUY1a6TVdajMcaA+TWjrHd5Y7YxALJ08Qkcp+atfc5BkDfq7Vc7zHNJvV4KOaPJFgMQasu8zRjApZF3S48Z5wWiQoD7LAPXoMBV3Qly7NvJskhGn2oHjBESz9v2Y9pT82/XsYFN3uYjXE1JPKWfKC8pM/7Gr/nCJYeEv1Vv8Qh9gAAwb0q5o82ardaLNklwL72M3ouUKx98Q0Xj6SYrHgbLB3SpMdWniY0xSpXazBoRE/o5xx9AIyMQGQDK+L0KPLP84=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  1 May 2026 17:21:16 +0530 Sunny Patel <nueralspacetech@gmail.com> wrote:

> When migrate_vma_insert_huge_pmd_page() jumps to unlock_abort due
> to a PMD check failure, the pgtable allocated earlier via
> pte_alloc_one() is never freed, causing a memory leak.
> 
> Added free_abort label to release the pgtable in error path.
> 
> ...
>
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -840,7 +840,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>  	} else {
>  		if (folio_is_zone_device(folio) &&
>  		    !folio_is_device_coherent(folio)) {
> -			goto abort;
> +			goto free_abort;
>  		}
>  		entry = folio_mk_pmd(folio, vma->vm_page_prot);
>  		if (vma->vm_flags & VM_WRITE)
> @@ -893,6 +893,8 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>  
>  unlock_abort:
>  	spin_unlock(ptl);
> +free_abort:
> +	pte_free(vma->vm_mm, pgtable);
>  abort:
>  	for (i = 0; i < HPAGE_PMD_NR; i++)
>  		src[i] &= ~MIGRATE_PFN_MIGRATE;

Yikes, we leak that page on several error paths.

Thanks, I'll retain David's ack from the v2 patch.

Balbir, please review?

