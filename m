Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EBF8C88E72
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 02:50:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9753C6B008C; Mon, 14 Sep 2026 22:50:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94EB86B0093; Mon, 14 Sep 2026 22:50:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 867B36B0095; Mon, 14 Sep 2026 22:50:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5BEBE6B008C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:50:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C59ED40303
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:50:44 +0000 (UTC)
X-FDA: 85214468808.30.D198E5F
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf29.hostedemail.com (Postfix) with ESMTP id 08D09120008
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:50:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FkSJfhQa;
	spf=pass (imf29.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789440643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=opmE15Ezj7D6sPRc2lGbWMcP8W6cvhTlzz53Mdzz0Gc=;
	b=vd0u5nBwc6abMd6yFtKydI/qZ/qP6lV8Icwg/h7BHYXe6CxikzYCe9HYyf68STh4tfqU6X
	f+8Z/1nfnSdiGPO+oIjwJbOA8NzDM5+gndI8FaK6s51PrX6fZjbO33OQ7i4M+NiZ3XNyTX
	AQoias8Qw8V8Nxrj6pHCw/M9b+ljjlg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789440643;
	b=k7bHovKCNHw0cQu8OyKiv2jXR+/UzapOsZOHVGxbcS9DSIYz6d/dC2zEeWvwsl63xo49MA
	KsV1+s7FoIXROJ2BuEbrPqLlTvKdeEuU2D0QkNhpMv2Tb8YERKlZ3k2dIOOfgFl7B+18wA
	81BVkIKE0kiELbS8+ZMjt6DgEMIwXeo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FkSJfhQa;
	spf=pass (imf29.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8692be1cda4so3366329b3a.1
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 19:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789440642; x=1790045442; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=opmE15Ezj7D6sPRc2lGbWMcP8W6cvhTlzz53Mdzz0Gc=;
        b=FkSJfhQais967ywz1gi0Faz0tPzHZWKY+Oq8ZvNf04NhIMRFiRaqR7lyyj5vnLobjR
         XaU9O5M5PVSFt/x2nzKhAcwpSqJl4UsgILRkvWakOXLlYyEh7YBB4eP0dP2cx4/xweOk
         CLgVnZzX7T63qgmcKAnjBp92bOGYT1hvX7kQmYNDm0qDu6gAGmznD4tFf0nAvT+7CqMG
         wSPEinKhGioEMj49fHC3ftHsuFqrrtGeu/lz5fPfgQwROca53BzgHPkodXOmZqtnIrOf
         EheNj/P8PhWBJUoeDEa8FGqGaBZVHCjIOCHdP0YF8hui0ze6iPtExWy+V0GlT8qpWs2Y
         gUCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789440642; x=1790045442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=opmE15Ezj7D6sPRc2lGbWMcP8W6cvhTlzz53Mdzz0Gc=;
        b=RIsZCp7QWDx15YoJzzyr0qd2ZP7EhVsadOnjBT+ueUwS1HpjfUkowXmj8WTid1ICDD
         QXCoU4LYF7sPIwfIbBRdZ2rj6kNGPwTkyuOSSVIm0tVafjtFsQi/KNafViobPMe2XVXh
         tGOImatz1ZWTa1cyhmXCBkPh4vHqywZ/ZsginUTwnJRO7Stt1Etb2O5xyMaxV17fEEj5
         7jm1V8q+aw2EFZSp9lPjnxADEEgq27Z+sDbfM0FZJ9KpHTis0TGUd4UsR25zWmxv8dRd
         4U9DJhscwUVqum7JHeAvsyXhyyJF9W9qiob4jO+cSUulF9giJZyUTEQB1uPbP4l1ctkX
         1mTg==
X-Forwarded-Encrypted: i=1; AKwUvByoHwDf/JQxpo1MzxfgFICVpd/d0+Fcl7EiYviy9YYC4SSIUfxFjQ71rVGWS8X4uT+jUU4OjcH69Q==@kvack.org
X-Gm-Message-State: AFuF++nlMUtdmsAoYS3P+LYIvTngZrFkjnLI0g/dahiuKqgxFlnVEdSm
	mVjiFxlCGh3JgP365Hr+EZgkjK7yOTK9EIdpRLJEF46uQn/wEbkzyQds
X-Gm-Gg: AYBFou18XMGG06WdIQ9tbU/vVoVnOB1UlPi75R8KfLq6aArxDbMcGx81z3YbTPNn1W0
	fy8mEgFBd8scpT798W0EXGXHXbATS/RHLk2MGnlt6iSGdyM00poJxm0ShD4vuZOzkpJHQZtCHrI
	5KJhcpaLPt4Bm95HFVT9cgoSnQlG8294lex957nQvoQJUhN4Q8aPiOwlVRR2+KWHva9O1T3Ug4w
	7Ucoa5PW8ZxYZkfdA6Odq8LZv3Hd5cXK/TilGs1w/zMmLivDqiW7uBfYVFSkIwDuR4D9ybN/5ux
	ns5YECQZEli2NohfLydjZw6PAitoCf2MgdSdcTrLWjQb34nOq6hwN0OqFEbTdVNfaAQg5/hUUUE
	uoxRnncb6AVV0lkWf3z2+28xB9TDMm0fgtMtB0zu5Uax1apK4quvd2F6WQ8/yNdwi7ZV9QoznPs
	yDlHVh7q5LhjHzbQjkUVeyNyTEOKJxfS6E6FKhVaaL5StLcKo6Ig2DDXAcdyOPO17zzxnhMpAsE
	xSI/WEMIBoSJNEqpDZyAEDHmeoxHtng/bd2tyl3
X-Received: by 2002:a05:6a00:e8e:b0:848:2e3c:9955 with SMTP id d2e1a72fcca58-86f833446f1mr10734859b3a.4.1789440641733;
        Mon, 14 Sep 2026 19:50:41 -0700 (PDT)
Received: from localhost.localdomain (vmi2317699.contaboserver.net. [85.239.239.237])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b2a2c1542sm5484353b3a.55.2026.09.14.19.50.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 14 Sep 2026 19:50:41 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Barry Song (Xiaomi)" <baohua@kernel.org>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Wang Lian <wanglian@kylinos.cn>,
	Kunwu Chan <chentao@kylinos.cn>,
	liz2nku@gmail.com,
	xueyuan.chen21@gmail.com
Subject: Re: [RFC PATCH v2] mm: Improve pgdat_balanced() to avoid over-reclamation for higher-order allocation
Date: Tue, 15 Sep 2026 10:50:12 +0800
Message-ID: <20260915025022.2061-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <1abcc4cf-fc84-4dcc-947f-8733df44e625@linux.alibaba.com>
References: <20260422021842.78495-1-baohua@kernel.org> <aejtfpBUu7gNV6Tk@cmpxchg.org> <20260914113353.94964-1-lianux.mm@gmail.com> <1abcc4cf-fc84-4dcc-947f-8733df44e625@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 08D09120008
X-Stat-Signature: cwgnr4cpjufdts4bejupxr36pk1ri59k
X-Rspam-User: 
X-HE-Tag: 1789440642-739939
X-HE-Meta: U2FsdGVkX1+HTIzg+LG1LBvm6x1VyDb/SCmgE3odVB9mgr4oS7Js2rd96lNgFm+EcM8jPntglVH0sGWcjFBWEt6qtfLsqiekp4eVYzdFpT+VNiJSlwF4bcOsR9n3YZoh7V28wUKhw4YbPMvvyqw2STpJAXxw9EKCSFrfQZrzB5nf2TlojLh9/M3/fkaRAag8Uls2vGOh3hkwd9mL9XxcQoSuwbjF0r9fOKC0tmbz+yXivF5dX6rEsVRU7POXMg0ndlkbxqSmFpSS7cRUOix93gaG0GFBIfY+AjCAg4/yqIIkQoH9taw5t0p1H3jJz49Jg1H6GiAKqWfMDfhcXOZsXzbz34JQFbzeghsC0i4c4ZAA5ItGHntwAVt7kjZQPM4j/KyOcAIQrVLyjCA87al8LkS81Jyr+V3PPLVwnD1BaL6YXA2R+N0IzaxethhXrBJsiuBuPpRGH2AEsgPli6SV8vAy5vRLvFz7xi/HqY+jhv9K9L/wBeOBtjnoOEPwGOVU7oxs3tkWq3ilYtGIAEP02u0wbsWeh5X9zOZrSHlNu/7U39H+IXihBWxmy1KgTCLSgs0pe0CqMo5yfbDYAfM+1EgCpM1AjlxMHkO2gDa/CAK0yvPr+isf/FaVqMgI82wx3BXKeb+b96iYivfTWGQKYQHSNE/f0poyzXRGx3ZjKS5Qbgjp2LW2Qgs5+jackLytVzOuij3pE0WDbcL+j1HslktVBMYfo+EYH60lSaNOzam6NLR32a9ATQjlFE60KtbQUopNFAHHAqhmUv3JgQOhQIg4Ke1nrbGJbUnslOM3QMTJZYahw3KOm/vkUetRecYvtjflz+7+jJ/3V9YKwkjec++jAR9g0MmR3MIM49hWLUAsrUDmhKD17A9oWf0RIq1ctxtKjGv18voPH+qWfFZAESg5Y+M1V7yTdO5XTGOvrZxsuHWOpfUZ65lVEBdcOoJMXB1e3/C8rQrC3L5De5Y
 tp1RMgp4
 Ca2xZ5JyLZp4s50Fmj2dCjQCXC6ezNDNs7GInjpb4LtL15+9iMfDl1Xeqz2/mwJuzrK+N90oZuP8+7Q4ipi/PEaWZ49C0CFdTzQ6LkVPP+1zg/R0vuUUBF/hJSTphwhMnCnfUG6C6HBalwooPz011e+kn7zKeLg5jfqFkmDX+euCY1uHrsWdQtp5hw0J8sZ5gPDLAf9MZXMJtRuyQFHMowJETTU7+iZnEg3ZXGmFa3UEeqefTlu5j5njJXMYi28jWoEmSApE8GaC831KBqQoxEA1fseKWKHs7OPd+PRPTAq6s0CXngT1DWPwwF0hSJw06gRpaMeOMKAPJZwhyVa+WHenlIqNLKzxYxWf8EVZpHLliIRI27nWrH4ZP5bariIB+2IH/XqMXdJHi7LJb+HgZLQ/p1qNgiWDN8W3gBJr65VJQodKT+wY5+n0duf9VpNQ5dsZDuF+yVH/Ex/ER4ESEWRlIWe62Kl83ftDgZ8MuyfF9jj25+6xQfaWsbB49VtUa5rVeEYzgjLWWjLvU3BTn4aQ7bWLkAH2Nxf5ssjqFQMsIn3o/7B+KL1H1Sh9vnXOiSWCXVS5cPJEBoXA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>

Hi Baolin,

Thanks, this gives us a concrete server-side reproducer. We can set up the
fragmented-memory test with one workload requesting THP and another periodically
accessing file folios through fio. We will keep free memory sufficient for
order-0 allocations so that the test isolates fragmentation-driven reclaim,
then measure fio latency and throughput together with kswapd reclaim, kcompactd
activity, direct reclaim/compaction, and THP allocation success.

We previously reproduced the kswapd CPU and reclaim behavior that motivated
Barry's proposal, but we have not yet measured the benefit or possible
regressions of the patch itself. As Johannes pointed out earlier, limiting
high-order reclaim too aggressively can regress sustained or concurrent huge
page requests by moving more work into direct reclaim and compaction. Therefore,
when testing Barry's patch, we would like to cover both the fio interference
case you described and concurrent higher-order allocation pressure.

Let's also wait for Johannes's thoughts, especially on whether bounding
`sc->nr_to_reclaim` should be combined with better accounting of outstanding
higher-order demand. In parallel, we can align the test matrix around:

  - best-effort order-3 network allocations with immediate order-0 fallback
    on phones;
  - order-3 scarcity with sufficient free memory and repeated kswapd wakeups
    on PCs and VMs;
  - fragmented THP allocations competing with file-folio I/O on servers.

We can run the baseline and Barry's patch with the same reclaim, compaction,
allocation-success, CPU, and workload-latency measurements. This should help us
unify the design discussion and avoid optimizing the phone, PC, or server case
at the expense of the others.

Thanks,
Lian

On Tue, 15 Sep 2026 10:30:50 +0800 Baolin Wang <baolin.wang@linux.alibaba.com> wrote:

> In such fragmentation scenarios, I don't think we should reclaim a large
> number of file folios, instead we should wake up kcompactd to perform
> defragmentation. So in theory, I prefer Barry's earlier proposal to
> adjust 'sc->nr_to_reclaim' [2]. But let's see what Johannes thinks.
>
> Based on our problem, I think we can setup a simple test scenario: one
> workload tries to allocate THP under fragmentation (and free memory was
> sufficient now), while another fio workload accesses file folios
> periodically. In this scenario, kswapd's reclaim should not affect the
> fio workload's performance.
>
> [2]
> https://lore.kernel.org/all/CAGsJ_4x9vkv2G7d-gANf8kqUJVxQh_P9=AJxr98LFUgQeOTqow@mail.gmail.com/

