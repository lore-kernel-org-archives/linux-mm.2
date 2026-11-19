Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55FCB606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 17:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ernvEvoL
Received: by kanga.kvack.org (Postfix)
	id 613CF6B05FE; Thu, 19 Nov 2026 12:34:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C4286B0643; Thu, 19 Nov 2026 12:34:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B2EB6B064C; Thu, 19 Nov 2026 12:34:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1CF616B05FE
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:34:31 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9A6D7160BB1
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:34:30 +0000 (UTC)
X-FDA: 85452567900.11.A8D3D26
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf18.hostedemail.com (Postfix) with ESMTP id D80BD1C0015
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:34:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	none
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c50a2efbe1dso2436266b.3
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:34:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795109649; cv=none;
        d=google.com; s=arc-20260327;
        b=BBEwQsWU59hVMkBox8x4zI9YMxoXNXR9seosNSOZy303akHHwglUOsrDDoG1/bf8mB
         m2lMWA8dD5mqT2c8+X7RRaBPT9fh3UguU6MpEXsksBeD/+YDP1ksCqHncHRTszXb/Jgs
         Q6wOKEPNO/+2BTwHQDTdjKGiK8hSgqIQTAMS/66uIZFxeHApaP2TfLN51QGdT/nA6xQC
         eLVAwG2DJEPqYpROegCNckL0Tkn+x0bOwkK8CspEgtolYgoaJjBzSlg+kzKK70Ar2kSM
         QZzPU5WEWkobTdYkRX56kms6Ff1mnIdiRgCRxDXlZbv9CoXB7Wfgh9L1arkOGdTyMmHQ
         uRrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GU/DHzsJXxqhMdzOYAA9Okmyib9cC+TRn+DETm5eoNw=;
        fh=5z1VCU5jPLFuEM7U1Y1xnQj1jWK0DDszicBWVLWc78Y=;
        b=L24I3YxVuziQ9KAxcOY5WO7Tp4gVs+XMp9sp6608YxNeNtU/UuIt/9r1iysRZ7cLJL
         wZRYLMZMYsywUi0s1ui5j4Byc0r6Ig+u0i2ndKuoq3L48fi5iAnsiOIIiUaVKMiLHXie
         3XyzcaQE+tWSFs+XYSWWJdBUBNKX5gXETQb1THiu7tdk28dTKrNu1bPvzGNh9EnXLovE
         29uY5oP9/OzVrw0maLN2ug6MAnXy/FROCl8X9EvG5UMEUVrP4bONgx3Cz8RU7QC3wcaf
         Bm/5uA3I0oOFTG7Qyc3lrFLUD0kANgd/jy89aDB/a97oZvaRjgB4zMTzUBAG2fpo7AIc
         kuWA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795109649; x=1795714449; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GU/DHzsJXxqhMdzOYAA9Okmyib9cC+TRn+DETm5eoNw=;
        b=ernvEvoLEZeAL7a8n418hhxlOhO0m/bfvhJIzEXcXQU/nlFDyQchHt8MO7hzrD4/rD
         VI5wSQyvP3VVrr0HmQJXLCz2n9MnBv/rZuhDjzFP00TeZ1iv3lGxXNU96+W0PCJgsGU1
         LGGyw/nMESqqpLDjLV0h+dHv+OAhkgMGw09743jm8W3zC4mwphXGVsp/fcBURHV/VJ8o
         4N12I0wsWNWWG8YNF9o0lvPES/qTBx5At3A1G2Qt0QgOB8cMeQJvHVwnMkd/PnB8vWHv
         KUIYVfdDd++tYtfEMi8OWuIJLznMiETybj7VsHybFkQ4UT+gQx40OPkTMg+uzCLCaYit
         AF/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795109649; x=1795714449;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GU/DHzsJXxqhMdzOYAA9Okmyib9cC+TRn+DETm5eoNw=;
        b=EZ9/2p3l3N744tUqE8pV1ObOBEfXMItqc9eBbPKB7az1TRMtlO+2zE6gq0mVJazwrP
         RYbn8MfMAsRynKLeQbXJi6g+pcGjEEuAYUob6mJmau+cSt6tefY1EubfVSv2rstm0Aah
         jmqseP0+PZaFa6hzikWnCbkom6Bw4Wb7xwHdWrr06PXseM1QS77zQJrU+6i8Qd6aqO5A
         omMIao6qvb8/5RZ7yFKVemXS5G1ZxG/cNGhF8/Pais39X1CdDulO4mbAsFQIr/IeXFxe
         bldpFHgJIE2Cvgwu3A0nvDcksnAkqcQXCYT2cf/qATTZH601rQBHUzg4l6X0fUDaPfJ/
         jZ8Q==
X-Gm-Message-State: APuU4Z/60X48kcdqS+E4ObVmfhsndxIDKL9IBWrMHLWSskQf5v9lDLZg
	5a10bQJajxTzRyxia6Um2U8YFpsAqdUyepUm3qHyaDrUD20IiOBGTqv7SN2lUFlMnZbFkhDn9ri
	xUDoP/kkdtQAXD0NpBGgjqQxL91ExSog=
X-Gm-Gg: AYBFou2/ppi8V9K38377dY4UOPz0cLxARHokV6sEO2pQqKYXyTUUzRgNf9aDL0dnVyz
	Gx5XmYHM31C85damsFsQZbeuHuMfKlAndCEUNbBtEOTZuHE29ezdQlP7WUe7NFlrnjVimqv2aO7
	Rddw9kD1EXSyypjgxfVfdO75MYEkdmm23ssXxo63Z9SGT7sp/M5kPa0GzwGi9Pht5NwPe0Uqx9i
	ODshuQxB0PVWrM68HntL/icY+GEMhd8Mnl/LAsCg5EAHNeoN6/tWi9d5U8uH9CaLY+8qUGi6jhx
	9DLeCmdUdVmTVxlRkl8I9RpPt/IcZTlFsokF6w0J4EtLm8Eu4wrjrK+fqJyWFjWCHKfppbcaZVt
	OnqpttKQ1fhphgD8GGRyS5U9wLrhr7LyRznskiSS6eLvWnjCkNMjoQNkms2jS8FPR7OgcYTY=
X-Received: by 2002:a17:907:9693:b0:c4d:331c:2e97 with SMTP id
 a640c23a62f3a-c513ab47f5fmr64354966b.36.1795109649032; Thu, 19 Nov 2026
 09:34:09 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119112357.275352-1-hi@tychen.cc>
In-Reply-To: <20261119112357.275352-1-hi@tychen.cc>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 20 Nov 2026 01:33:32 +0800
X-Gm-Features: AclHuK_14i71TxMIEATGAgIqE0r8tCGaC_TLqpyybte_WVRWpRVBP4hHZoQKFT8
Message-ID: <CAMgjq7Dnjsq4vid7H4usOB4f5AS8XzhG75mvf4-Y=an95gBERw@mail.gmail.com>
Subject: Re: [PATCH v5 00/17] mm/mglru: frequency guided promotion (MGLRU-FG)
To: Tianyi Chen <hi@tychen.cc>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
	Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org, 
	Maxim Muzafarov <maxmuzaf@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: y9aqm1ykd87zij1f6hfjprgoajefkj17
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D80BD1C0015
X-HE-Tag: 1795109650-197386
X-HE-Meta: U2FsdGVkX19lJNoc7LANoKFG2vRrGXn0QQaUvFZnShLSRpQ8HML58mOUkQE7dT9xFBg3cfkzqsGA2bfsYjnuISk6SSi1JO6uycikn/uMgIA7xICl/IbR7+VzGBbgLQSrzsjhtxVkQaU7ZW4KJKLERS+ec8tFm3iqRuZSttTVphzAAZJNqMToM+LAaxS4/LmBJk5XnTOUx+bShgosYAYnoNIOUZkkW7gtkcHA7WAgAjg+b+3DZ7N28x+5l7OGSF+/KgMj9pHFkO2XmuGPneC3lSgXtLhO7/6l7u0ktnNDOWmMfmXkzes57xXyd40EbV6Xqsy+WiUXmiGwuYVIW4UzkJu85lC3GDsKa+2sop/Rx0zGc/QhanMAorn3D9c3DxmTcDf7kYUoJhAXiG0cYc2HBLE9xw35vA3p2Rzu5e9qRs30soMecGDmlh2y+qeoGaQ3Eps7ntBurdxtIX7/54YT0KCQduc91aGI8STYAakCPSA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 7:24=E2=80=AFPM Tianyi Chen <hi@tychen.cc> wrote:
>
> On Thu, Nov 19, 2026 at 05:03:32AM +0800, Kairui Song wrote:
> > That's because MGLRU deliberately disables hotness tracking for
> > MADV_RANDOM areas while CLRU still has refault distance.
> [...]
>
> I ran the OpenSearch k-NN test from the RFC thread [1] on this series.
> Its .vec/.vex index files are mapped with MADV_RANDOM, so from the
> paragraph above I expected no change. With FG the gap is gone in this
> test.
>
> Setup: 25fee5b1762b with and without all 17 patches (they applied
> cleanly), the same .config, and a fresh 4 vCPU / 5 GiB KVM guest per
> kernel. OpenSearch and a one-pass 96 MiB mmap scan share a 1 GiB memcg
> with no swap. 5 seeds, lru_gen enabled=3D7 vs 0. The script is unchanged
> from [1].
>
> Medians over the 5 seeds, last 1,000 queries after the scan:
>
>                   p99 (ms)   memcg file refaults   .vec resident (MiB)
>  base, MGLRU         66.18               144,387                 99.98
>  base, lru_gen=3D0      2.09                     0                117.19
>  FG, MGLRU            2.16                     0                117.19
>  FG, lru_gen=3D0        2.12                     0                117.19
>
> Right after the scan, base MGLRU had already dropped .vec from 117.2
> MiB to 54-71 MiB (median 66.3) in all 5 runs. FG kept the full 117.2
> MiB in all 5. All 5 seeds go the same way, and classic LRU is the same
> on both kernels.
>
> This is one synthetic setup and I tested the series as a whole, so I
> can't say which patch makes the difference.

Thanks! That's good news.

I think the reason is some of the hardcoded biases this series
removed: FG places purely by refs. Less hackish checks, more generic
performance :) I reproduced it locally on the base kernel too.

FG still doesn't track MADV_RANDOM accesses though, and still no
proactive workingset shift protection. Refault distance will cover the
rest including Maxim's case IIUC, as demonstrated before, it's better
to do that later as it fits much better with FG merged first.

