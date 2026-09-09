Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29312C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 20:58:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADCD06B008A; Wed,  9 Sep 2026 16:58:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8DA36B008C; Wed,  9 Sep 2026 16:58:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97DB36B0092; Wed,  9 Sep 2026 16:58:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 71B826B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:58:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 417441A0351
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 20:58:22 +0000 (UTC)
X-FDA: 85195436844.14.A727448
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf31.hostedemail.com (Postfix) with ESMTP id 45A2D20008
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 20:58:20 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ty8Hm15/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of ackerleytng@google.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ty8Hm15/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of ackerleytng@google.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788987500;
	b=NCcN1SrDnZUj/c2ri3Eq/BXxlmpoQMSI0PsNzBQOzQiPMTCifVUf0+SXP85cMSQ3swqjno
	ST7Jsg97H3oEBelgNacMbggnhfPMY0Pb6oWMkzx7o0otOjSMyoIhSbqCMsJ4Vdl+Y8LJ6f
	kaUdfmIJTsEEuvmUdZAosfgl+LorTC4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788987500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fto8QffRRzc1iPbh04C4QLWgSTkv6xI4tqguxS1zB/k=;
	b=7MSsikhztGr5w7f1/lbqyR0hWEJjytUNt3gPNwmpzJp7sqgw73rHd66sRyu3LrvhfMA3mF
	IeprFPCoOiX4CNzjfpWKy4i58UfEDAKOGsm7qAnUaxk4U3xKUB2pNas6OLdIIFeeXev7le
	FguFn2KVztjKPpwpo51+iw2JOmJsbv0=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-39b9184fa80so844192a91.2
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 13:58:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788987499; cv=none;
        d=google.com; s=arc-20260327;
        b=Lo1xOx9+H0wdDTE+U2iIMOUkIBBKDMvwfSrnaBKRv7azoODg0v8A9+N58yNsF+KxAf
         HSg6hcxOq7UePiN4KZcC4v9x9iH/cJRDE2xRjf+nq0WkewRmTKE8dXFe61XWcDZ0meKV
         Mfg+94XyGFRBAX7hQeIExxKA3Dm4OrL6upATlh/vbTtoeRztUVU1nc6zcmnuGxPwQTPA
         OTznZe2kxsQjxXUydbv+hiSVOlQAr6tGLSsX8i/aSHUVHRcFpE2oysrfNuNWijifxv1y
         SnpF+uUB6tvbYdS044OBF6J6QZPLEmgpqsNMtVpldUYuvsY3zWsbR2EWuyME+iWP71Ry
         pNhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=Fto8QffRRzc1iPbh04C4QLWgSTkv6xI4tqguxS1zB/k=;
        fh=GfbJdiFMa8SXdOCNTsWAIKcoCA+pfTA7+CUJG1quH8Y=;
        b=IjPExIm7ezlAd1eQ79vgw/tJIilXWVYosPbhO50tTn70Lhb7sLKUXmFrw8aFKYAIZL
         q4wgCOIVt12LfhYJGCNqguQ1rJtfhNXE4kKVaSuNv7HKLJObMOSj8rkbfd/0gnDF/lQq
         UiDr2mozMs2+OAoPulJJ+sNrFZ2Hb3Rlt9MWl5Q0Y1CAV/YDAbUQib+IJPSuTZuUJXD2
         XmuWNckilq6VTHh8OhSsJmaRvJvil0koJE0GDLzp7786t10EVfuBkdAPyoid3tYkh0zm
         QY6WTe8ge+yZyiXndLM7pF/nOdX8dZd4XhiCkmIhDkmJENtAk4kbXTGK4HKIo/L30fjX
         h73Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788987499; x=1789592299; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Fto8QffRRzc1iPbh04C4QLWgSTkv6xI4tqguxS1zB/k=;
        b=ty8Hm15/w4VBrgx59A9AoH8qpF2bluWOfizHgIbg+vxec9luDnorB8mNoD1OHvL3dQ
         /QVGVBhW5CcyoccgSduk065r403ZXog9sOl+YIVW/vTPm9TLXnVjTJLKPOVk8s5aGBct
         MWNQSVhwjGlKxRt7oI7VNist65YvOPxNxh7YFedZ7903emnpkN5yymTrMBgQIkM+QXae
         IRY34NipRqHvAINyi+1Xf7LNA/Z9D1Udc8NhSbVOOV7l4mRM9vJ6cNPCw72598/5u4VT
         pzfzPvuDv5VWi/hk9BBClTizr8bu06hsNm+VnzhYGtjlQFGYoNjryPo0zYUpO7L5ZXqM
         5Fyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788987499; x=1789592299;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Fto8QffRRzc1iPbh04C4QLWgSTkv6xI4tqguxS1zB/k=;
        b=NaPDQMaxCmcGpuo4Cl2kcmN0E609WllgN6NyDBE5Fn9t5pWcTjwzJDstSO4c71uheP
         Va0fDMaUegnk7frdYiBrtQ7RcXHo4FNCvdm0gdKdy1YV17yTr3gyktyhsBBg4CnVaNYq
         Qad2IXECMbSf23YnsLuBC4k06nhUjgw8rV4dsWp4Rz4yBF2zNIC/n+MmUYjCklZ5SBeP
         Gk2q59b3I6uU7rTGpmOuoIYoKc/nbAxCynJnaDXVR2Jr+pFc+GUjedaKLmpHqTqMcHXv
         AbULgJ9yu6QBgPV84/BqnehzX841o77hIYXQluuFBiwWAG5y/oRNuLV5BK8d51LRn2ey
         5YuQ==
X-Forwarded-Encrypted: i=1; AKwUvBwjKX4yLDVgD7QfiL72iFgWqD5lFnay2AwBLfaN8aBt+xVDje+2O1cNl2t05coKO12SQruEiZH8Cw==@kvack.org
X-Gm-Message-State: AFuF++n43GlchmFclm4JNq3trS7VdHVALjWy0F8l3pfgjzGgYVrIddxq
	KpaaImRU/gMDSsAixNa/wM3aeNNWqIJnZtqHcdZxWtqFL9cUZ0ykG4hLnrIJobG1aBgwLAq0njS
	yLc7VpQh4g3wekybjFRgmJkC3lqgRlJR8NFQCRPQh
X-Gm-Gg: AYBFou1B072SmjQQrfl+XHxC81dvyzsBcrzm6yuJL1Pdd4cTar1MkbcEuzyRm4muzoZ
	tmvQ73esvkM3nSN+214m3RWZh1TE5gg/gfwigBAcamGS2aktR4GEFqkI55qs6BUK7UKnfIgvm2u
	MEdyCXY0cZ6wEeV6AaRPz6izW1usZ1xLnw5dtIzLGU64lj+N0Pd8cGQqPQtu8dFlyDEZMuTOqfd
	2B25SOUWlvbc16Fj4gB/Wik+w29e69Nr+N7P6uQq/+8FspcfBMEhN03lmZjRQmDauN+Kxto1b8Z
	oRc52gM/xj7Bc9MNIiWB3kLuTTGqIEl8uc+KvubFi9PcbkOrm/cH/LoyFPkGNvIYk5uPXF+2SKL
	Q40t0SRD54GKxHTEQYtAvftTJYnw8E6id1+t+A3l/EA==
X-Received: by 2002:a17:90a:d406:b0:395:4de5:1054 with SMTP id
 98e67ed59e1d1-39d70b4e3bfmr4942649a91.16.1788987498156; Wed, 09 Sep 2026
 13:58:18 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 9 Sep 2026 13:58:15 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 9 Sep 2026 13:58:15 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260902-hugetlb-subpool-always-track-used-v1-3-de1cd14bd713@google.com>
References: <20260902-hugetlb-subpool-always-track-used-v1-0-de1cd14bd713@google.com>
 <20260902-hugetlb-subpool-always-track-used-v1-3-de1cd14bd713@google.com>
MIME-Version: 1.0
Date: Wed, 9 Sep 2026 13:58:15 -0700
X-Gm-Features: AcwNN1VHOD9F3bWg7PfgqL3VQ7dHsVNaxKBOIXno-ubvbNrtHXi_elzy4mYJuNA
Message-ID: <CAEvNRgGRxRvAj_KC+RJ=7Xuddz+FRDP5pn7ZgVaZq5y9WAB9tw@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm: hugetlb: Fix subpool usage leak on allocation failure
To: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>, Alex Shi <alexs@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Dongliang Mu <dzm91@hust.edu.cn>, Hongxiang Lou <louhongxiang@huawei.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Wupeng Ma <mawupeng1@huawei.com>, 
	Yanteng Si <si.yanteng@linux.dev>, fvdl@google.com, jthoughton@google.com, 
	rientjes@google.com, vannapurve@google.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 45A2D20008
X-Stat-Signature: wfhbdhimouyo3pyq8kc8xfkcjy1xeahh
X-Rspamd-Server: rspam01
X-HE-Tag: 1788987500-208570
X-HE-Meta: U2FsdGVkX1/dwxJsK86s1NKOz5HbQyvqdhdr3FiaGmlVgVtbidGOTYcEqCKpLLyzxSM4o4JRhcSVMdSeV1wZO9iE2GbEmc5x47vpwq+4m/k1aAMMRpr30/z/uBKbxZFnd0OzGasX11RjYxvmS+SmL4qELQ8SGES2gv/goZ3LgitX0xgQroiUzFNfXlCCsQteiRQaS/T5ZVaCRrM0SrIjEwNhjCQVr4O6DuCSraI+wvY19NqqA/kqJ31eq+WzdoLkRo6YAfV6LWKf2inYhuFGNALbdBbdRlZWNYPtt7IHGu0PX4e3hTK19zmoJ+AzJ5lfGdRP6BYsZ2/sSz78lqbTE+DEjwr2IVZuUrwlmfFfLpJTcsjpte2tKCemR54w4oYnOPaZu2nL+l10p9oAe25Rp2vYCR+6oC3dF8Z/aIiPv4rWVgkAQEIxG9PZrikFYRRNnsvamedHnGzlI0zeCU1hzV/GqWJvZHgsS7IjuWjrenOEd+FvNo6dTYrZkd0T3NZOPR7/vq4QWHRM8A95pst2bhUd9BQBRNGPueGPgGzCSVcrjKUKxP/Lz1pzscct5ggmVf3w5g3nIVLcUSrVfNeqGAF1mgrrSD+0/5mQ8eDthTEc1HkDNUYrQgLu8UN+VHxpZfphjJ00wyiJcz1hX+H1LD2NwMz1IB3+ocrs3jUHiCP05vwqiKaLbrqQEybCZWisQv3tjTj0D3cg+SKAp7mQ/wSlvFbzbcJWxJlUl9KDeCb8fqe7OJhaRbRjnFuv0TtAaro8dTzvZa6mN9dx+OSygEakC5uXSJ4URMzNZlp+jfaJHht05kEHQ6mdMYC0OJACFnqDyqmEiVYavkR3dEw248w2ejDdU+lqgfDw8oZi4X3wQaTlCV8RzzYw+nQK2UMi6oYZZPUmQY+fg0Bo4YqPVIxIxqaczHbnxVPd5v99i7GJcG/qRsd2DuyESrYq8aETZlKAMrctfFTOXXeTDX4
 6pRpgr0Z
 tb7ttqKTLsCfcuiOg+UfBgOFGfgQYM5KrxW9ZNah9JgUs6T6YMtdlWEz8suy4Ym41WUZZAPEfljIhDi1vjKBi1fteZLnEfP0E+H3UGQnkRFMtZCwzEKPorxkhOhaR2RY/zBlXFuXp5AMXXrwMjsULfuwO5NQdEtRbtLmHmyXxS6dM1fW8MgTT4A45QabOLXGpYL74PTX3DPTzFipWSmMkeed3SKt3mPt1VbR5QvPCEElxk4r4oUJy7xdoXDl3edCYoOiBh8+iR7NBEP4LDzGLV6mhlqq7imKS4kv9sIt/aLe2rvzT94UQyoiLorLb/u9NvfCBfKlS7NopkInljv8IXadOhvsNEGdVa0y30An1VJiAiQAberOi8IZ8tUhWsXSVaoxEhq2PWmU5ldG7jUMmEkuliZtdgc20MwDLm/9euJbjm8vWBgoLyqEB9M6WU5YzMN93csruzpnzypwPaICgLFtTE+GQNMi88L6V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
writes:

>
> [...snip...]
>
> @@ -3072,13 +3072,10 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
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


Sashiko:

Does this violate the subpool rollback protocol in alloc_hugetlb_folio()?

The error path appears to unconditionally pass the full requested amount (1)
to hugepage_subpool_put_pages() instead of the absorbed amount. According
to the subsystem guidelines, error paths should return the difference
between the change and the global reserve to hugepage_subpool_put_pages(),
not the full requested amount.

Ackerley:

Nope, the subpool rollback protocol has changed since the first patch in
this series, where now the subpool always tracks used_hpages. After that
change, pages taken from the subpool should always be returned to the
subpool. The return value from hugepage_subpool_put_pages() can then be
used in hugetlb_acct_memory() to fix up global accounting, like in the
line below.

> +
> +		hugetlb_acct_memory(h, gbl_resv_get - gbl_resv_put);

Sashiko:

Can this result in silent state corruption and accounting desynchronization?

If alloc_hugetlb_folio() fails (e.g., due to memory pressure) after getting
1 page from the global pool (gbl_resv_get = 1), and concurrently another
thread frees a page to the same subpool dropping used_hpages below
min_hpages, hugepage_subpool_put_pages(spool, 1) will absorb the page into
rsv_hpages and return 0 (gbl_resv_put = 0).

This causes hugetlb_acct_memory(h, 1) to be called, which attempts to
gather a surplus page from the global pool. Since the system is under
memory pressure, this can fail and return -ENOMEM.

Because the return value of hugetlb_acct_memory() is ignored,
spool->rsv_hpages remains incremented without a corresponding credit to
the global pool, which can lead to an integer underflow in resv_huge_pages
and permanent memory management desynchronization.

Ackerley:

Sashiko made the same comment on patch 2 as well. This is a common
pattern on cleanup paths, where the return value is ignored.

I think the fix here would be as described in [1], to flip the
reservation tracking to track an available page count directly, but
that's for another patch series :)

[1] https://lore.kernel.org/all/CAEvNRgGN0HSJ2iLSDD2haSKOxifa-uhkO9Hwossh0+Q_d9fzOw@mail.gmail.com/

>  	}
>
>  out_end_reservation:
>
> --
> 2.55.0.970.g62bdec98f9-goog

