Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78EB1C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 08:57:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28D346B008A; Mon, 13 Jul 2026 04:57:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23DC06B008C; Mon, 13 Jul 2026 04:57:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12DD06B0092; Mon, 13 Jul 2026 04:57:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E4C606B008A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 04:57:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7A811120B27
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:57:17 +0000 (UTC)
X-FDA: 84983149314.15.A76FBE4
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 97B5718000E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:57:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AOQpnODa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.172 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783933035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eswem+fgZ39sD2pjf/HcQMj2cdVo6XyD72F/asLblR8=;
	b=VG6R0tcIJ+oVEofLlPRSVLxbURDfBxjZPLH+qlx1i1xIedWcFei2gyzbSKaBAhCji5xiqV
	iG6IYGJwtq18a0J79x7cI/4e/6hfvQXZToyWyIWFozDVicDkCh3R+bb8bf4DrtJtGatDJ9
	hqxUWMHdhR6EB0dBDD/0Z8zGJ9SYwmE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AOQpnODa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.172 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783933035;
	b=KMaaL9VEXaqz/7JgBU5QdiGMpwCTXeIeoL2hm9AlDlraw/j/f7txgan5Q1HC5Wj8axTAJm
	Yc4oOXKt3QtlMWwoOCbovIMEb1t3e09OkFcMilYsk/1k7U2vO6Uil8e6XAEpAzETMG+6w5
	8Dpx+pZS6cTnS2WQgFOjedD/H1XTNTA=
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-39c94fccf3eso16566761fa.0
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 01:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783933034; x=1784537834; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eswem+fgZ39sD2pjf/HcQMj2cdVo6XyD72F/asLblR8=;
        b=AOQpnODapsirbf3itMFW4w8SIe7rRV9jLuuo8A8w4batn187wFPyroTfmlaNn1MuOM
         +qPtFSq5/rHsnloPZ9RnGVO5gKJcUqWswm0awdr3O1UKCB2Hve0RMYwufKATVa0Wn/Tv
         1xcaolFTYeVuNYSuvGY4SEqk17zsxXgRPgG5ozlDlikISByAuAoqy5062JwV4YFeL0x1
         c4gAb7KAx0CrMMpWwW+LkWQ+P1FpajrQ2isoTFLtFWebvfybAg1Wev1KT4gQnTGO3jpL
         kShwEUWQLb5N5ek1MzV3Q0BYv9joStwWRbLQtDVbLdmVDZ240Ycl160DaQtIHoxcGAsd
         PVHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783933034; x=1784537834;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eswem+fgZ39sD2pjf/HcQMj2cdVo6XyD72F/asLblR8=;
        b=g1m+3t2ax+0h8FDTZVtP10tA/44PFP8DnascRhbonH18ig+domSfUvaAu5kHG7R6jQ
         RS+fjof0wUwE3fIJ4yfgnyT/6spmRww1FalBnKjcG31mXp8CHb/gBsee9kjxub10No6K
         3wTWyNKymXKbKfpGEAAnte3B5METXVpb3sHn9ZAxC6P5BLcmOQDlm6dP8HWz5HTrPFEF
         5HesIfdtmSq5oKD18vzwL9pdkycr4rrRszh8QYvVTP/aUtwULKqPuUSn5wPVZ5FSUTn5
         2bzsMDizmx3NWKMwh8WBXZzUlP0+hbmiyQxn9azNvC+ZfeA6Wl7x4Rlgtbl4riJnoUXt
         2lLg==
X-Forwarded-Encrypted: i=1; AHgh+RqhQiR0ZLsQ0bbu+3NyUnC9JhXkBr720byDY4kvXrvcq1u+66jRmmqgbl+NncRPj0GQL+88KWHjcA==@kvack.org
X-Gm-Message-State: AOJu0YwSnQMQBmVykwb+tZIM7ijz3C79n6adxm+dtrP8l0V/YW+DKZ1Z
	hnPJqsCfOCsSAyJhwbKBU2ryOruMQ/4EK67bl8Py8clealqZX47gLsgx
X-Gm-Gg: AfdE7clrQwwgVAlRTI0krygPk8bc/x+jXoz6mseUYxx4WMmhqslb1gcLbU9WOqEJsa3
	CKxTBo8LQSiBUzmf/I+PaNBupMFoOPfDiIYHBxNlNGmTpVpNvytZY6A7d1tyLAjupKfG6Gtx7CR
	ekvGyLkuOUfFKtYMIn1UyMk+/NPn9rH7YiTpWfx4U5SNarSxjobBL7m2DigpPTMKIzBjgBMa+r/
	W6UPi7qR3sthg2Sv1G6YKbwJooA5cFHpV8A+BPEp57IMwGo3X1mSEEgaOlU+8SVpelwI/YoWCCJ
	wNeCNCwaQLunDaNIBLglKYtoPKjVJhiGZlR1s/0X7+0nRyGvk6uwOEEd7GvwczTTm6ZYaBiDrps
	FHIAkzcgUwRuTX3FIVg8OkRAc+6M2kzw2kva8BHawou9hI1yKV8Jhr2SAnSgRAPNgkF74hlvYy8
	f748y208VIiHy9qwog7TiEju5IERjEGHvCNA+fVNwL
X-Received: by 2002:a05:6512:32d6:b0:5ae:b136:acdc with SMTP id 2adb3069b0e04-5b0236a4a8amr2022533e87.35.1783933033504;
        Mon, 13 Jul 2026 01:57:13 -0700 (PDT)
Received: from pc636 (host-95-203-16-226.mobileonline.telia.com. [95.203.16.226])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b01ca4a2e9sm2657309e87.1.2026.07.13.01.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 01:57:12 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 13 Jul 2026 10:57:09 +0200
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Alexander Potapenko <glider@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Marco Elver <elver@google.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	kasan-dev@googlegroups.com, kexec@lists.infradead.org,
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/3] mm: split a couple of headers from internal.h
Message-ID: <alSoZTopsSYAXM2z@pc636>
References: <20260709-internal-h-v1-0-956d5092782d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709-internal-h-v1-0-956d5092782d@kernel.org>
X-Stat-Signature: k73gj51fh16i95j6pr8bgoeq7fmcezum
X-Rspamd-Queue-Id: 97B5718000E
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783933035-539750
X-HE-Meta: U2FsdGVkX1/WSb45S3+AYE1FjpFdT4Gon28Rew/NIV7O4WF8kgIuNpQ6EpJw/0F+mNpthr5XfCllOYOVCzVntvQuOq2Io1L5E+XU37ODrs0dnDjtNkLygxjvT08rivlpZQDCrhHL3vu75l8KH1brDRZGuME5an+voKCDXnD38j+AwZ3B1JjnV688wOnKomSQ88M3qUVRgQ6rR8PVQjtHg9Hd4IqwK9on4j8ONPmJEnumOsPREdr4GWfDTesNclwyKcR32ELXKNbkS6gMyPfzQAkgewCTGOptGRpA83mqi3KjpZR+CPWnPgD52GlBXUqxL5tOgD057eoFnMjUZVqwAhaxhLVEnWXH4rMr1xUy6DhPgBTX9yrVT0fbVGo/3wlrUSziGqz4qCIKUShIawcLCp9wO0Ir4iiEUcX3e4Ol+XefNxPIB9V/aCXeloQ+NT3ihGE+MtQhInaBbOXcAxOy6GmHrF4ihry3ZxaV2WFG0xdbmWXnHcTe6OSefTbUNutxKVUzpwJaQemyywpbbNxV6CD13dRV4lcgubGktFXLKH2MoCGVbu/GtvoXeXaD8Ua52kkmQwYWnUm0p41e7USWzxgxy+Qx9EnwiTKCO0LNo52bYHzLAC641zNPKcsbCkE3wd6im9C3ckHXRUBZTbLPeqk67Yar9N0PBf7r2x6HBvXNEOBZHbzVB+uTWtrI6M6YrE8Np4Y4N0RpcPfvRorAyOVLrxiSmJLqmZA2bJhjm2boHphpV4EUtl7FqNI+wDXlBw+y8zGm/674UEvajH6eLUtGzUEMoAXQKwWgASUgEl1ASunxRAeix1pDBBxsaQ0CppBcCXPxx1BR3wT2BYMkdVlZH3qpQT3DihcSvR0YnFEYjDHVk+2kEhnx+HGwbPx84QM3RS6EG6oZ/RfWnLBsdWABPfkY4KFoYwYZPG2tyBifc2W5+HYG5u/JkDH9oCao3Je4XQ64SgpMUxkJ5H2
 vsBrIOgL
 c70pWPA5EPvMTF6J0p8Ww3Zo3vk6muxsNmEpnFNr0VGsSvL31QdhvhdTvrNDD/+rgjHM8K1p9IbVNEOkvfvYnx5ma8sGBCRLlct3CAeFPFiTJ2Y77MxDaf3QKfhY9KtpQamMxFd6fmVa56E6yoLA6Kg7JENxQWDQ0m23CAqnG04pbhf8f3u0T6FDFhsALTk+eWmRpl+aXSOPbUerhHlOJmPajqa0DpMDHDkG4cKMHxKCFGJgKYOASFi6dq0cptui6K4o0ZZ7PXPVCN4cWdYRktj/tqeWxOglEysjwvLCZQi0njZTLY/uFb2Rq7uQPFfCwuGyCwaXliPrasVVEF92Ym7CTqFNfpb1q3wuWxpKXKoaXIposYHiXDzoLRpSYCAXH1PuH8PRquGCQu1seV2EzkxWcEAZproUnSIdcb13w8gYdZPrnQUzZtag3Yg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 09:41:46AM +0300, Mike Rapoport (Microsoft) wrote:
> mm/internal.h becomes more and more bloated.
> 
> Split declarations related to mm_init, memblock, vmalloc and sparse into
> new headers.
> 
> ---
> Mike Rapoport (Microsoft) (3):
>       mm: split out mm_init and memblock declarations from internal.h
>       mm: split out sparse declarations from internal.h
>       mm: split out vmalloc declarations from internal.h
> 
>  MAINTAINERS                        |   3 +
>  kernel/liveupdate/kexec_handover.c |   3 +-
>  mm/cma.c                           |   1 +
>  mm/execmem.c                       |   1 +
>  mm/hugetlb.c                       |   1 +
>  mm/internal.h                      | 183 -------------------------------------
>  mm/kmsan/hooks.c                   |   1 +
>  mm/kmsan/shadow.c                  |   1 +
>  mm/memblock.c                      |   1 +
>  mm/memory_hotplug.c                |   1 +
>  mm/mm_init.c                       |   3 +
>  mm/mm_init.h                       | 120 ++++++++++++++++++++++++
>  mm/page_alloc.c                    |   1 +
>  mm/percpu-vm.c                     |   1 +
>  mm/sparse-vmemmap.c                |   2 +
>  mm/sparse.c                        |   2 +
>  mm/sparse.h                        |  63 +++++++++++++
>  mm/vmalloc.c                       |   1 +
>  mm/vmalloc.h                       |  46 ++++++++++
>
Thank you for splitting vmalloc. Later on we/i can move other things from
main vmalloc.h into this local variant.

--
Uladzislau Rezki

