Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D94DCD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 15:09:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBB076B009D; Wed,  3 Jun 2026 11:09:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D44536B009E; Wed,  3 Jun 2026 11:09:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C32D46B009F; Wed,  3 Jun 2026 11:09:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF2386B009D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:09:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 555EF403B5
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:09:16 +0000 (UTC)
X-FDA: 84838934712.16.0F51076
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9A4A640004
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:09:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UrwgN6Ng;
	spf=pass (imf12.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780499354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=bndY4Rtt+kF0HA5uw8ulEDrFOIX6yTjDL3dqjriePQQ=;
	b=QEWg4JbmSlCs77m/LT0LxF70R9eJGoCeAccqPd7+yn5/MUtlqSSKt78YocmONrk1PZsCNm
	RMczNH2DJh0kPtHYA54rk7/SnPnsQ/bEeqdVUWsa2uP1qA6+FLmSmnjofHyCwkTwkaxiEf
	W8Hrw7YSV1onEVCMz3SQeyMaQ7UNDHI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UrwgN6Ng;
	spf=pass (imf12.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780499354;
	b=OX/EpSqErFlAoi3hN4Wk/PYFi3v1g442oK1bYCb0Ff5jgsjKFIXSrk5pha+soWC7Vj4YHk
	E+xp8JLn0aqHb8TRvHE73oR/MaPKQaoRoj4bPaUW43x6Ut+QtM9RhvqYccJLLsGf1B+GVG
	cDc/pu7jjb0HgeNr55NNL8MuL5AgcD0=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2bf1cda2b17so6427845ad.1
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 08:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780499353; x=1781104153; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bndY4Rtt+kF0HA5uw8ulEDrFOIX6yTjDL3dqjriePQQ=;
        b=UrwgN6Ngibu5Kk0Ulceys3GoM832LKq88dSkw249pO2zvOVZlM/aJAwPy/uAVqNTEu
         RYK8tM6c+OBr+703ieeO0d4sqsXKRP1VJD+rlMeNYYqPtCisqn++1LZzY9QYxe36BWuR
         KzM3Y4+ANic2eJGHdroXjzCFy95fyCM/43L2+F5zK6zYlR0VglmynpftiOFYXI+C0mYh
         Dd/beYBFO4V2N9+gX/spQzAcz9mbg54nZVn+kgYuQ5f+D4PBFvh/c8mT6GWZiTei4nw9
         tK7GgfjcYqwCyQD2dMqhbv0WL2hH6oxOtAHVdPwm/zS0QU60YjqrWulxInoDOKVzlV6R
         uAZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780499353; x=1781104153;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bndY4Rtt+kF0HA5uw8ulEDrFOIX6yTjDL3dqjriePQQ=;
        b=bpaxICuR06wmUW43mwwGgk/fHGU/srMoiTCcoSTzR7L+f0uHJqvkhA+hnHXJGgQvhj
         BoW7uoeaAmwuAoUuFNgCCzuS0A9Z6T81IxvINmc6Lx+BGva+1ExlWeyUZtVP0Au0Ri2P
         2L5F7YzGdojSvyuU+gxXhNIdyZJdHsVJziI9SZ2Gg8oy2i2Tw6rzifGxxePnbIQ4us7D
         jMBvPaiJzIDxQYUIAf97A3xOquP+sGvQbmTcj9WBE9aQxvM2VElX05gKSQ6ySPNoQbLn
         caYjK9C1D3xgo/rsJUVRvNlXfuuvuEXXpGcWtpUCpr1+EgxzSw3PCItWC/xXgAlxxA7P
         5gzQ==
X-Forwarded-Encrypted: i=1; AFNElJ9f9dtL3Psus3Pz5fUrD1GyC2aZ/XUpb6RHiFMTmTluwe5lrNLwYUNC76KhyqsDOYaddNWbvEE5tQ==@kvack.org
X-Gm-Message-State: AOJu0Yy596ULU7hWl3bVKhmH0Eksu26+LoF8zZs16QLPEcSQKjTv+igc
	DBkKXG5EmWXIR2xSafm9s/mCGhsKkg1M54GeiWXp6Iky/7uKBm4slwJ9
X-Gm-Gg: Acq92OGbd0gs81BRMTPfr+/xQIoUvCx0nDQqAhXank6LSQesbK8wSt9W3oL3USLtrfc
	uoD/BjfNsfXggzJNrzhArGQKU/o+2WypV2K0MdDUMhjvqPZA1sPwC73JZL9J2MpAorC0ayyq8ew
	XgreeWpZD5czHo0VulNTSA4yyHK5RJ/FKaWddnGrIY+gOdnshEWs15rahjGJzztr+Bvvzm7Uy0a
	4vAgz9uVIB0nWUWarB/p5De+xy+v1FhGL+93y3AzNstWHPszO3u+8YXi2hL4XWhT5F19Mp8yQZN
	HiAKKGDTQCzJiX1G0nF/4fKwAHmsiVxzUroF5D0aWzHMudPphQQdw+zjixigIf1Pj4LGlZlTbCK
	1/lK4CVDxMkzVL9TDFJ4cL6679SBAi/N564+Zr2WCrwzOujPmyGikQa/OT7gTKfeEWidMY1j1oU
	4qSbtsN3NQy5+mDSMc+qwXfH44RGsyQ9w8
X-Received: by 2002:a17:903:22cc:b0:2c0:af09:f3d4 with SMTP id d9443c01a7336-2c164d5f70emr29441875ad.27.1780499353373;
        Wed, 03 Jun 2026 08:09:13 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c164f6d2bbsm29577905ad.1.2026.06.03.08.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 08:09:12 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Muchun Song <songmuchun@bytedance.com>, Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>, Mike Rapoport <rppt@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org, Mike Kravetz <mike.kravetz@oracle.com>, Muchun Song <songmuchun@bytedance.com>
Subject: Re: [PATCH v3 03/19] powerpc/mm: Fix wrong addr_pfn tracking in compound vmemmap population
In-Reply-To: <20260602101039.1867613-4-songmuchun@bytedance.com>
Date: Wed, 03 Jun 2026 20:06:35 +0530
Message-ID: <a4tbwv0s.ritesh.list@gmail.com>
References: <20260602101039.1867613-1-songmuchun@bytedance.com> <20260602101039.1867613-4-songmuchun@bytedance.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9A4A640004
X-Stat-Signature: 9b43txukd76siuorti5u3cp8xewhxsij
X-Rspam-User: 
X-HE-Tag: 1780499354-385950
X-HE-Meta: U2FsdGVkX1+kk6Ht0fNiyyLN9mO42SKAaK1Qww+97HI+ph4Nu1YdUek2SyIzxuuYiemZh2wLms85Ine0Hm9SlCXWJCNWNSe1OAEXUsk7uI4ZylUQiH4o5iceZw0sE/dBBsvneAyCT18JeR6C/E1x/tLcSeWkLe2T1ys4eC4vFVQhvdV2YL8uNHEV5aX4JeMEn8WyFp1sog85STD5Av54ysX8JF1OItl5nF84Oeq+LVZVGdulNgljkF5Uv81yApKeHDZp8U9wJhpL5zc9wpquXChHh4h3WPzmC6+UFrDBm4rFn7b/yKo4GPwt3B0jm0N5O2J/RNDKB0uR+5DsvfMJRmnb+5tShoPi6clX2oBajB7PbOnA64gUPWFg831tCaXCWLDn+JOxG8k3A8ZscfKprue4xRPPTxmDoRoHGCSXTI8Qe07QVdxBYdcDsIQXVr4s3+PjBUtaXCRrUnJXYyBEi0wXTQX5bbQozVXe6kVGpusEBMalSSZEgDZsqO4JtKNsDsj7iH/FtMOqxAWoYRwMBTmW7cgNksbaoHvpI3CNNOkmlPmnpTyxQMPhTI07EWzx5DHYXBEo0F/mPOlPr41eUfbsFa8vmh6jiqxauKNcRMctuaIIY6ZptEATjpgJIUr0DLIBLMZZ9TOn5/dtSsVzRGanZ0XGaTzFAT1ReUQCahZPSEKOfV5LbUpDOAdlFsYmuaq4zUF4mgpOGtiLEzi7n/Dh1VIpEiZn1b5OHU/BckV5AEe8M8CHHA1GZ+ed2URRdVtaug7x75dKMKJRRKpCh+E2kT2Kj9d47QjMG9qXJoKkv8JGj2iCHLwDOfb5uoB5rzvnGb9gN6wrfBnmakLZL5uSNzXlFvaWseGhaZcYV5mD2H1KUzCVVcHEHsozAK/BMgzGH+LnFVtdWvIdmFbPX4ADnqbS907ZvnggDY/CWKNSo1KGMB/g507nOIQlyoFni7IjNpPLp8m5WZHkRty
 arws0uuf
 EbsvYdCUd8kbwKkwgUVpxkuA77K0pRlkJUjERqGMEGFjTrBnyarDOCqHIolkJU+D26xCWSo3nb7f7rvV6oRv1K0RLTCAZvURA76KnlkWzI0Z+a8H99gtZDuyftuZBvUsXqGRcwZSnvf5OHZww8/XUQqNCNR+JxThHGZ0VA/pgXBuCpXBrn0PhnG8KBJcGpAaddVO1mcwYhV04UG7zuknX3c0Vz1xWV2n7dSdTZ0mT4od2fmDrOSm/vfu+bVmevFrzFfVQCB36o9CucZvP62tF0HXQ+NYdFxYiu1HR6AzyNQyk/kgm+cVf1BaU4yDUmJ5/DUdobpcb64ziF9UGqgQkOP+5Kd45jSQcdRPnqyY4NMNAHHQ65iGUt5hvBCrJxks9tSTDDzLQHMtyZRILNwExzsJKJZhmoqKgkaXUyXhNMTBi/z143P+djlnxCSO3YoRNi/49bTzVdFW2DkIHXF1g3RS5ZrkG+tFOpuHErwhKDmQCZ1HGJ5Pfj0/AESVI+9J0wnECZTL+KhcoNJup52qHieK/XGdfs2sE9uZqGr65xeZreWEAJ61v6RT7rlNF0s9M1xstBwxdIPVhh+k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Muchun Song <songmuchun@bytedance.com> writes:

> vmemmap_populate_compound_pages() uses addr_pfn to determine the PFN
> offset within a compound page and to decide whether the current
> vmemmap slot should be populated as a head page mapping or should reuse
> a tail page mapping.
>
> However, addr_pfn is advanced manually in parallel with addr.  The loop
> itself progresses in vmemmap address space, so each PAGE_SIZE step in
> addr covers PAGE_SIZE / sizeof(struct page) struct page slots.  Since
> addr_pfn is compared against nr_pages in data-PFN units, it should
> advance by the same number of PFNs.  The existing manual increments do
> not match that and therefore do not reliably track the PFN
> corresponding to the current addr.
>
> As a result, pfn_offset can be computed from the wrong PFN and the code
> can make the head/tail decision for the wrong compound-page position.
>
> Fix this by deriving addr_pfn directly from the current vmemmap address
> instead of carrying it as loop state.
>
> Fixes: f2b79c0d7968 ("powerpc/book3s64/radix: add support for vmemmap optimization for radix")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Oscar Salvador <osalvador@suse.de>

Thanks for fixing it. I guess this was not caught because section size
on powerpc is 16MB and with 64K pagesize we have 256 pfns to map. The
vmemmap size required for this is 256*sizeof(struct page) = 16KB which
is < 64K (pagesize). So basically we never loop in
vmemmap_populate_compound_page(), because
next = addr+PAGE_SIZE will be > end after the 1st iteration itself.

But I agree this is a bug which needs fixing and it can be easily caught
with 4K pagesize, where we have 4096 pfns to map within a 16MB section.


The change looks good to me. Can we please add stable tag too?
Cc: stable@kernel.org

Also, feel free to add:
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

