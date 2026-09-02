Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62BEBC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 13:29:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79A8B6B00DC; Wed,  2 Sep 2026 09:29:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 771B96B00DD; Wed,  2 Sep 2026 09:29:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B2676B00DF; Wed,  2 Sep 2026 09:29:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3DB466B00DC
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:29:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B713916020E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:29:11 +0000 (UTC)
X-FDA: 85168903302.12.6A1CCA7
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf10.hostedemail.com (Postfix) with ESMTP id EE939C0011
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:29:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TUrxo7F4;
	spf=pass (imf10.hostedemail.com: domain of 3pCSYagYKCKkbNJWSLPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--seanjc.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3pCSYagYKCKkbNJWSLPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788355750;
	b=ONM6kBqCYFX4FP04ZqthDJXLLP2xLRIlHrxKDO0UB0sAPkTO7pQnawZLmEBQjfgG6gRcrr
	odKVuXmjOZmBfb8ZBYKrvwyfn3pFhfDn2zYhHODucZffIYnoaMXd3JbFWJG3pr9O1jyCsT
	lowpO90J0GWLHg4QtVkk6g6EYOJlNOY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TUrxo7F4;
	spf=pass (imf10.hostedemail.com: domain of 3pCSYagYKCKkbNJWSLPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--seanjc.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3pCSYagYKCKkbNJWSLPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788355750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ipWz6RsGTzunItby4GsbJNxElWjk3oalhREfbMO20mA=;
	b=bSMxogCR8/MfvtRMKXHOdnBgMn5BfB4OF7qgBfJsnWz6Q5H/RxfNKj8CwxkEijWgRncp3k
	cgL7h7e+gH9ouRJzS1mB1p9c6al8hT0ODXASnPmiKwJJnjkbl98BTPnGJKlTov2IBySJES
	Q5l4mSx0FspckvE4sp6lmx2fRete7YU=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cec4226c70so13401905ad.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 06:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788355748; x=1788960548; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ipWz6RsGTzunItby4GsbJNxElWjk3oalhREfbMO20mA=;
        b=TUrxo7F4cEFvuqdIseAdKIxGC8DX1AO/ljL96rYvM30cyaE6wF0W/AUdvcKqiu2z1t
         Xfwe3QvMi2SEyJ1nzUiIS8p/ipPefBlksBSWv3rCn3djTwqkfmXUg/ltC9VJejmfQIgh
         mLq8lwZEch6+99vwVqsoMRDjqKa+xjPDOh2Fq/XUn9wx6BWUMSWJPXbstsrm9K9MareK
         vxeYhnfGwoN3V0xXImTIk8SOJmpqZwUZMttwM+UcIWLGxqfv1JixndHxjpL5D4Lpu/9T
         IGMMRw3SkNDNzEg8LPSmRMbQgEQtQwx+Q8dVwTmh5ZH+79d6fUMDkcZny1CV/XW9Vc+N
         5CYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788355748; x=1788960548;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ipWz6RsGTzunItby4GsbJNxElWjk3oalhREfbMO20mA=;
        b=T4e+HwAtSzZwNFffw4/xF+6YxPjbH8CxkpX/BqEudb2SMCeI9wT1FCRjTFe3uHystL
         Zz121GP/haeN+AOF2+lcluhhTtX/I4eE/ozkdeIr7wBjQOnfRUvpA23u+UbaewMOX4sl
         RllKm+nkVa+KXZAX4c+80CoUrMrKqLKtkk5+W00nq/z+T+XQiIPHaEcEsLbJcrPjB2Uq
         zQQgPgChrJ1nx2ZVJyBr7qyLYkVquzKb8e1QGYyZyxKtHUvWsZbrxWh/1WuIJyd+gkIR
         VXT/sCKiObAUFO58h3J1Sve94WdF4t7Nbj/ECChDz0U6Iro+fl8rXEpGMbT95Mn31V4F
         2cew==
X-Forwarded-Encrypted: i=1; AKwUvBwyGx0EGpqLSPGh6k+omX6YSqx6NFolqdJvh+eZnkxecEuPkggbZq7HjRuWmsm8DaK+NIBUe2j+Rg==@kvack.org
X-Gm-Message-State: AFuF++n8GGQRytY5Qa5G9K9z3xXVIuBfGtya0/WRO46Htb5Qc/BQcBKH
	ozi82s7nHpDLtJr+99XCPnDM1TD2FHNNR4n5PosjhzYst7u5i5ifVDStx02OC8xlb6j5wVs76w8
	n9pVriw==
X-Received: from plxe5.prod.google.com ([2002:a17:902:ef45:b0:2c9:b703:3bfb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3887:b0:2cc:864b:539
 with SMTP id d9443c01a7336-2daec625d64mr73388455ad.6.1788355748310; Wed, 02
 Sep 2026 06:29:08 -0700 (PDT)
Date: Wed, 2 Sep 2026 06:29:07 -0700
In-Reply-To: <02876cea-5727-2ca4-bead-73659ea6fec4@google.com>
Mime-Version: 1.0
References: <02876cea-5727-2ca4-bead-73659ea6fec4@google.com>
Message-ID: <apgkowGgWeWQPz0m@google.com>
Subject: Re: [PATCH] mm/folio: EXPORT_SYMBOL_FOR_KVM(lru_cache_drain_for_folio)
From: Sean Christopherson <seanjc@google.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ackerley Tng <ackerleytng@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, David Hildenbrand <david@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EE939C0011
X-Stat-Signature: kqpjdzj4wrumoyf7pgesiexfhma7c5y5
X-Rspam-User: 
X-HE-Tag: 1788355749-350113
X-HE-Meta: U2FsdGVkX193nDtVqONQ6rBWRmjpNBpKZPzrzNXkXY303ktcG1ItP0Fgy1QvnvIevjUp9xNp296VgeoYrnJL8rkuRoozXb0p+jUbVI/tgMaOqwgqKuKWHSJIMEQGFB6INsdu+w8ULdpp2Lf6SS/rPvZ5bfHVgg2gqfo2R9aArhx8NzrqVFMd70fnX7Vb42Z3DuWLUPHlaV/ZuLi0jnC8TY8uENs1EslMNtXXPvjDlfzwHt7gNf7u+RsKNVE/Pw8sPSPO/FhquXGaCA9tbritZy3jknpQx8kdHxrIEgHCENLCwIQfEdwWEiPhcp3+RAkqURBdIuO9Jy0qp9Ke1cTQtkfgTjmUy18MI7GMxUEsbPrkrCX7KQfFhg59/GvSw+Pp7xlKlkzDmvTGwRDImqL1/ofHmFVUGgHmqXNEldVHlYvWuk11nT6wtTt7uKnE2bGITBxsm9B33l3Lbab2qtASreeHP72qJZueLpzPxV3NtJ91RLxH6Gt9JSj8LfUU03LQO/K0lkyPDtny2O/O2tjkIczxnuxHmXkgesfzlK5/P0ynb60oqn9uouIiQ/5rvHOvAl8IXFAZLli/cz42zKaWAavD83Fruz7mbLxN6H7bN+oknVXfp4kRb6Nm+eLwA7EKhsyL8B50rFLyys+GDhD/u6erlE4fID3Hmg6YfzOup7X6a0IV3kJDHI5su5EDCsI5zvWlYgQOGRYajKAjG/XXagCeK2l9ndjIrA4joQdGGwubDevPho/DSXpcvmJLfcBS70oL4UB8nsjUCkpczbiM3ke+b3naAJ949x3WqvFzxyiYQE/Bz0UC7Hj4a8HgE2lZYQ/zeQv3GzXX2ZVYY4Jlzup9hPublzkzlZlNLsyDB+wfENZD8P99tamWtt/whX9g5OKYq3NaUhQr5zk6eDKCT5XQsfaccOoPHCbu0EGrzh+m2cITa9LBk40oxyskpYQLPNp/Z+Zlhq5rngIV30j
 Nz+hUt4Y
 6y5GW61xFTpoQbpLZ2aUNOOj0D6V9/kCQjmjeRvv7eGDxz6EyygFxvKmjCWVDWyAIsJPWw2DVKR7zqxJ5lOBtjPJxnPvaP7e8I13Cn2eU1XiV3RlB9L2hdmbyjkD5bv5VQqvHpmw1MTSFOND3FzwNXaProj2J2raHVkkpVw6se4XGqtEw2fBBNPEY6f1EsDDzKGXd3ZFk4E5ooyPUDcMO8BNiB1VJKZI0nErACPR5FSeRO/GvJ6N2+9ZmWBnyhGyskTbTXV2FFQzau5piNskgUZuXxbc0WLBlj+6E4nk4f502vI4vUnDR83eQlH6axTFCXUe/Bqx316S3GifGarIzckbPrNAfd9b9/+wi+u3tePKbP9BiIDswv1llSxyXSmlHUEEFVMmwN/voB9Py+7kvrJVz8CbhmyAxGrm15jsZl9pbVTW0kArFx+b194zj9OebNzW7mEvOiagppkp6oRHWKeP92owAUiKQuuqlbm5OXnUcY2DB4eIns/Gtq79o28jSLZsIr4FX/nvHIselu3/vo6oIJv76Z0fUHtlBsMCd5qdux7FRf+gvtYOmAprVx2qEMHQg726aZdUR1bVusbDu57+QlDD0gJI1UHQIq4AorGFOKJ8mOCrFwWOFeB8I4fnCpJgWXSf6M7kGEUe70KNkQJEcbRYNjzIAYA/QadHBHkFrY1hXGHnzDVgaJ0gnHII4gUmdCHMIX7/ZXL0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026, Hugh Dickins wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> To simplify independent development in the KVM and MM subsystems, now
> export to KVM the lru_cache_drain_for_folio() which MM added in 7.3-rc1.
> 
> Link: https://lore.kernel.org/lkml/bd6c9c74-e374-a9d3-ba1f-8b6f430894fc@google.com/T/#u
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Hugh Dickins <hughd@google.com>
> ---
> Hoping for 7.3-rc2, which would make my life easier: thanks!

FWIW, squeezing this into rc2 would make my life (marginally) easier as well, as
this is the only non-KVM change in Ackerley's guest_memfd series.

>  mm/folio.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/folio.c b/mm/folio.c
> index c02dcea9c03c..50a6dbe55998 100644
> --- a/mm/folio.c
> +++ b/mm/folio.c
> @@ -33,6 +33,7 @@
>  #include <linux/page_idle.h>
>  #include <linux/local_lock.h>
>  #include <linux/buffer_head.h>
> +#include <linux/kvm_types.h>
>  
>  #include "internal.h"
>  #include "page_alloc.h"
> @@ -926,6 +927,7 @@ void lru_cache_drain_for_folio(const struct folio *folio,
>  			*drained = LRU_CACHE_DRAINED_ALL;
>  	}
>  }
> +EXPORT_SYMBOL_FOR_KVM(lru_cache_drain_for_folio);
>  
>  atomic_t lru_disable_count = ATOMIC_INIT(0);
>  
> -- 
> base-commiti: cee9395acd8043be0644b25c34bfa86623f2b935

