Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47017C5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 07:12:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13A3B6B05A3; Tue, 18 Aug 2026 03:12:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 112366B08F8; Tue, 18 Aug 2026 03:12:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04FA86B08F9; Tue, 18 Aug 2026 03:12:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D68FD6B05A3
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:12:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 74E0CA377B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:12:10 +0000 (UTC)
X-FDA: 85113521220.25.DF296A8
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf28.hostedemail.com (Postfix) with ESMTP id A98CBC0004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:12:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DyKL7VnZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787037128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ZWJKjjafd4rnjHIXgNulavUthCI1Xw98Pg39mbzNSA=;
	b=HmCmps1f5mIdSyRLOCw2nuwzT4a3EsGt2rPiLKSAncsyQP7c2MLNOJOR8P0O8YGr3t3DsH
	XjW3aEb+k/FX8ke2CT7om3rE1stzWGoUk++X7RiurfxKSCb6g52Lvg2IjY5nEcibYBaFGi
	mcB1S96Rmy5e24JO0wLgIvdkxcIoDfw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DyKL7VnZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787037128;
	b=4OMs34xBGI+tQohpVUDhChwlziYnQaPZNK3k8v4noTubaBhTB5O5QvQEJ0P5VDFGvmiUAY
	90RElo5ccZ5Zcc7uLwoq0dOmy5uLbfk4t6CTNPpvzWHBLLXdDYyyNENGS8uXdPt6x4nNnH
	r+zB9A4txq/SAGpX6C7IQkkW6fkpmZ0=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3811f512167so5998237a91.3
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787037127; x=1787641927; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3ZWJKjjafd4rnjHIXgNulavUthCI1Xw98Pg39mbzNSA=;
        b=DyKL7VnZHxzUtO9HqXWoK2qjbJmOPqyOh+0/FcsaTkko/EP3CjsbLQUnSq/dn+lGTN
         bED4Bl3LGkJtBhKE7cBHYlxcGdSpbA4lwu0vcZHrJD1oXWym9JbbhxmQJFPqGxsJ3IAL
         usyp71dxPmfg5UhQtRzovHH04f6NWsrCaCFV68XOMDRxYUBqyM3yT8f47QcyvcGXAHSd
         R7fEyPdexO67Jyv4eC2pxsZg7puYOh1r1wRyvvyZGtYjnu0l16bFHw/IEABugfuz0WYP
         2/y6xRO3bqtUzIZ1jTaLR7dTwkyZJz0STAq4KfBw3rggZT8+payuRClWB9o+tiS7z91W
         mmLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787037127; x=1787641927;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3ZWJKjjafd4rnjHIXgNulavUthCI1Xw98Pg39mbzNSA=;
        b=C+/RlJSYh9ZFtmR/oph+GTHtXCgK6wWinL6xcqLLWcr9hwbtEzVUvfVmURyAPWD2ty
         4T4BdQZCD3XVhBJ80fC8jWzOyXQEhSYutuUg0LWpzmNrFwHaJNIMZX/Gk/itxuC1nOyq
         lmDLX/fJB5W97oTOO0I3+4GcoxAXydKvO3giwBJ71tFldYuHOYl7/dLQXM18yf7mLND2
         P1fpYJ9x/FiOBd6su69gJgH5a57wQoQ//WQyxWv74k884b5rUoPagDh0n3SDo0Y3lH2/
         1wwxwwBnMPbZre+4kbmtPAeyWWsGalAqj18bj19n3GF8tdbDagmfXI6GDOMr1qEykBwZ
         KJmA==
X-Forwarded-Encrypted: i=1; AHgh+RpPcrkwBSGlNoYkXxIzIZ6uJWHj1+HD2FTNo2y19EalytUCQvqb/86zmWwhBviNGiUf3PyX9QoArg==@kvack.org
X-Gm-Message-State: AOJu0YwFuMV/uCa7KPjAjpkNjs3RJFCNHy1/rE/WkglrCzhXqAPNgvAj
	7zdt4aplQrx/lih3QmrjSoNTXtXMYjQmGKJ2WrG9pOt5VID9c/tPUB8W
X-Gm-Gg: AR+sD11F355nvC1UZ5L+LufTxkQ20Ouc7x2vlsY7otXEHVVCDRQ1iHI6ie44xoeFww3
	dLExePx1GAKtt3H2UdkVu/a6hhVwTqkskJOHhxQBsjaZHlNfR0As0TjbYjJ+9QOAdj5qN7ZTbg9
	b0kArvDnsTYJQzz38s029FrMT6V2GhigsNMJlcZlEw2nFaT5ntWfAv+sw6gumzWBa5sHQQRIXAv
	VUgeyMniWElO6Bwr62sOk6LtKqmjwtg/L3mcGGYSEMAB5MReW+0u2YvrBJINqwUh2CQRBwwVmnt
	Oj/YOed3WanzqRcRMZscvUCU/safaRzddka29+gAdUPwCOT/fqXZIfpKL/z12XlvvhPJtZsYr/t
	4vmKzgwVInfydcUyq7eSVxdcE+rTTe8F9tEQYNpQ76rvMVz8Nk5aTBjHiacBuFIkdgmkHJacVkv
	Yji7/o0FMBD6yDnaf/jvkKIr/2JJpQT7VmBDAsAK2tCRsD1Aa07Ufb1ptqcHBYnluEriPbxHkso
	ZaZoVmSMIwjbMKT5mA7S71jrKW3NSXxvXOojtwy67Sb3Q==
X-Received: by 2002:a17:90b:3f47:b0:37f:e177:f58 with SMTP id 98e67ed59e1d1-3955a774dbfmr7997942a91.9.1787037127315;
        Tue, 18 Aug 2026 00:12:07 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3954d1b0143sm5039834a91.0.2026.08.18.00.12.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 00:12:06 -0700 (PDT)
Date: Tue, 18 Aug 2026 15:11:59 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 1/3] mm, swap: ratelimit bad swap entry reports
Message-ID: <aoP-r2C9g9SwHtqK@KASONG-MC4>
References: <20260813-swap-v2-0-4a625ccabdae@debian.org>
 <20260813-swap-v2-1-4a625ccabdae@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813-swap-v2-1-4a625ccabdae@debian.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: A98CBC0004
X-Rspamd-Server: rspam07
X-Stat-Signature: 1nncstpmrqbcr6aips6szqtxa5dszbem
X-HE-Tag: 1787037128-793202
X-HE-Meta: U2FsdGVkX1/9Olzv+zeSMi2Xz5gNf/X9wJz7dAfk51hSh1IZAdL0sel1EuQXYBvz63z6Uduia89hxj9YAqLqMFgW3po1Z6CMzhtZcA2SgRaucEM3FkWYi0hDUryM6BvrYrbU9ZO6zkhTQIi4aZAqP9QRiJWjtdj7Xkm96de5Ty+ahqX1oV4cC3q+2bR0F6+gN8eW0LhNo7peM38UY4jqviKZq6LZROwiFoYz81iIfWnF3n1AhNLcZRtfxRo4vBHPXW6pXfXyE45hJwlSheUzSpP3jqweWVwuwGjISUrCekiWRunj0x5Riij0c2k7uqZx7JyvQ7honRMZtX0iD3mbiG/rf3hgif2ahK8Tg3V0VvwPvFzdnEv7/FvRr7kofYLbiSaffX65wnUQ8Sx+oU9x+sYOkdpyxtPDIriL5NlL1xYrdVByxc/DFRRdKdg/ZUiKXOxRd1j9ryYfVRBGSjaxt/JJTukXfaJdv/PnxYwDhIvVgo1mV/VcXU40G+lH8iHT8fu22SmIfbch31roww0Ar4+dalX0xhj8NlvKLfsaXhyLGjKiQ+pXJrNBMENIp1z5Ll/ki0ulvj11JelC50v6mr661sOwNoXoQStscmjM2M/V7Fu9N+WMWv9lvEH9uRUkkl6RfzHRcV4vxiIZGw3iV8kPkUoaxdUxzXAacKtdeXVVV88ij+OS1g78Ii72viBGfspV0jcBH4bxvULk6/W8KmMu4Iaw8d3sY932JIYTMza7uxUBO90t9++LC4ZoOHO0wOqhXo7JrzHE+zXcWFydzutd+FTiS/tYDdjeuQrgXo++lLiHzsXaJos5xVPYa75rLboXXZhVVwLS2+Ln1ZgBEBZ17IQ25bL88FPwt05HfR/Pl3OtADC41IqL5rtofSWT0R5jfaAGEXWXuM83bsdQuhM45HiMmyynbiu4aEu2eR+CTDy1tXedqEFCbHSFSnOVPrLezk2CWC0V+JF+wla
 EgVrRqPz
 eXJOJBTX5Quv4KvBID/mEaqnuUq/fkcZH0/br/DE8llcvRrKm3oupb/wFl5Gvtxb1rDcs40FfnM5rayBYVM5Rcf9xh81sLmd1es6Eixm9//nMUUlPFSZv7XWtNAad1TwhAcgA9iZJCYUEoj3HjftSNt0tos8qnCC5TkliaCQEHD/ygUkO4XEHMCGpuKM5IMtvX/8s1Hk2FR1ebDqeF1Q9BaSYDgQQ22y98WFLl/ss7Jpx2AxgVkDyKjt+563i5VlpEeH2ybhrxHPm3hSQxCeTwJ1sQpa7x2aaa/EX54sWFv99rPMSlhmnkKAsTXjc2Qm4u2oNMYbZhQrIdumgwc30Y7WKu50e9AseKJ53tYKGbJZGP1pUxKZ1fQ3Cv81ZnBZgrseB58KoBxOST9g688m3rGvezTP4DAPBuGeQclCB7odo1Oc4bhHfysAFKpkm7Nx/YDH7lwHgq83w2B45BrBSU0jpjvnr0SBuUuV0SdThldfgF9RbHtMxUJAdrD2HAXdxZbuQr/C+U/AlcPaBkHfCDfzQUKfeqiXKH5mFjLMziJm2lX+onoJUn11uVhu8oB7o6WUeoDNJ3iUxu0wFiCsRbQu8fg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 03:02:20AM +0800, Breno Leitao wrote:
> A corrupt page table hands the same bogus entry to get_swap_device() on
> every access to the mapping, and every rejection is logged. One machine
> logged 6185620 copies of the same line in a few hours.
> 
> swap_dup_entry_direct() prints the same message from the fork path, once
> per call: the WARN_ON_ONCE() guarding it warns once, the pr_err() inside
> does not.
> 
> Rate limit all three prints.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  mm/swapfile.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 4d4e3e3059f6b..31c8a340606bb 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1899,11 +1899,11 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
>  
>  	return si;
>  bad_nofile:
> -	pr_err("%s: %s%08lx\n", __func__, Bad_file, entry.val);
> +	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_file, entry.val);
>  out:
>  	return NULL;
>  put_out:
> -	pr_err("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
> +	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
>  	percpu_ref_put(&si->users);
>  	return NULL;
>  }
> @@ -3876,7 +3876,7 @@ int swap_dup_entry_direct(swp_entry_t entry)
>  
>  	si = swap_entry_to_info(entry);
>  	if (WARN_ON_ONCE(!si)) {
> -		pr_err("%s%08lx\n", Bad_file, entry.val);
> +		pr_err_ratelimited("%s%08lx\n", Bad_file, entry.val);
>  		return -EINVAL;
>  	}
>  

Looks good to me, thanks!

Acked-by: Kairui Song <kasong@tencent.com>

