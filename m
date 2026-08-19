Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD282C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 07:54:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA8726B00A0; Wed, 19 Aug 2026 03:54:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7BAE6B00A1; Wed, 19 Aug 2026 03:54:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6B036B00A2; Wed, 19 Aug 2026 03:54:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 82EE16B00A0
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:54:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 161E416045A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:54:32 +0000 (UTC)
X-FDA: 85117256784.22.59CE47E
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id 621991A0007
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:54:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="V7/KOyGL";
	spf=pass (imf19.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787126070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=obrJmH7a4Ni9aIsdLK+EIF0xJOtmVJE2s3WP/K1iU20=;
	b=mUoIECly5xzGKgi0/lPcsJ/mDBCXsrwc8iF/0B3aQ5xuoqEhiPF1ulvN08kTPCFlNo51Gj
	J7xTpUSkL6/PCow4yZ6KUS0Cmk9+05VCv8JabD4GC7acoGFC63NbBuMQ52MDqep29Cdp3S
	pxSrBuFcjrEGZw4Y+7FHcVKVEHVL160=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787126070;
	b=Qn65D3LVxuQh08LK81uyNotu1NSWTTKqJEMGQi4DeNtHfV8kTQm7cLuDCzJdYm3Pt4e79f
	mZOnkVRttERaC/ZQyK5EdvGMQjYR9/w/J4nUEYB9Va7X0+zXallpTvXHWc5AM8oG6FcrUG
	18B9RP5yEzsB2Asb8wRvLeVgHZuqaMc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="V7/KOyGL";
	spf=pass (imf19.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-38deea72eebso837675a91.1
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 00:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787126069; x=1787730869; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=obrJmH7a4Ni9aIsdLK+EIF0xJOtmVJE2s3WP/K1iU20=;
        b=V7/KOyGLKigfllp8nCm6bD3QJuuCU2m9rM4pQ41bUyKJs2s51S2TdiCER5AwJThclP
         KDhYLV0Ncvva7p1yEdEj4T3cQAWZXZ4eiaf3nR68Q4pCnh8qdSYn+sesEo/MkkpWHbvZ
         Z7vmMg9AY3YLW/uQ6IyowxCo/JgALympYZnAuIVJ/SuTyZbq7vua+RKq0+t+mGOMFm6y
         YHXjtxiLS/yc80tQh/727GautOmguWTkttpMMwN9ZzdYy/WVb21GUa4qhL6dBX94ap2P
         amEsI0w60UVV0IU1V0YNeXrSdvSBmiR8jXzi6FvwZL7fm7qzZUL0Dbg2+g4HjY9DItLG
         19kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787126069; x=1787730869;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=obrJmH7a4Ni9aIsdLK+EIF0xJOtmVJE2s3WP/K1iU20=;
        b=TnujaKDJ39/8nYCDjY6TK5+TvhvnRUUIpa8Hjlpc8FbrmIB8zr8Bf5/Z41QdG270xK
         bKPcr84qf4RSE6pMMarzn62qg6wSnybCj2x4a3OSN8bX5zKyMiDBSYSb2K7p1AufczX5
         VQFVH4zTqvyBN5kbixZ4V5azwqdRXbwObZ8cHqRWDZ9dZJ8upKDOYnJXV2XOXxA3sMIm
         F4/IlmRo9dlK4zUqgWti4Tck+GdZgRpBnKbxqiCkCRVPjjC16MZ6ezASLo2ZMJll+NRQ
         xfGQZfQtURgCqFoLTS/aV6qpUhbehhg9G7+kWnA7rxm1+xrRq8IRfL4L6/e+ZN4adJmL
         arLg==
X-Gm-Message-State: AOJu0YzZeyhQQl9VqzfdmdXdGBRd5DCdIssJ9/O2CMVAOKUdlHnA3U+Y
	VYVzLbd/aKJDiQ0yHwi9q4G/i4Y1HUmjjwNGV6whgnzQW0Zw4MnaUFYNvefJk1FL
X-Gm-Gg: AR+sD11IpzJ4CdXndWiAUqhd8CAmGQKZhoA7nfULrysNXwCYHG3lxKk1SfLv6mmR7cI
	19wGvBp0hISQaqBqxnuoJ4D/PNYY6LIwIoLvHinI86ugUEedC0i1V/FhYC2EiMox8SP57X06/bu
	PYueeIPfEgpsI962CyXVio30JdEKxpicSwjT9o7dGve/yAZHteB8XeuCEmDDot2HwovVuuEQrrO
	MX85yGgCjmVP54LHE0aCOh3ftQ9bLaDhwDk9Yp0ralV42gYW2UyqLXv2lNFOcfj7Uy4NXSnAotL
	/0FBrMX93eSOKbnfyLUImJYoF+TVFVK8h8zfZh9u6g81KLIfpWLSEjXcakyhGlcgJZXQdn5eTlp
	gwVgPZRa2BBk/R0uUIX75H6mO7vPxoaw4SAmxeJkZqwvLDYHlo30x4nPWIO/0Ej8oSy7Ac049w/
	qthJ/RVUnzby1IPyHh7OG+FxR8sQzualQ66KYuOqCibrkqbXOQLIHbKRSutBzORMEmPL+IhkyPm
	3jmzyQeE8XMzhFV2B7vEKd3qXxs/w==
X-Received: by 2002:a17:90b:3c8f:b0:395:4de4:92c8 with SMTP id 98e67ed59e1d1-395810e9626mr5779737a91.15.1787126069151;
        Wed, 19 Aug 2026 00:54:29 -0700 (PDT)
Received: from PC-2B0BA31200898.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957faf596fsm1668929a91.11.2026.08.19.00.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 00:54:28 -0700 (PDT)
From: Meijing Zhao <zhaomeijing100@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wandun Chen <chenwandun@lixiang.com>,
	Meijing Zhao <zhaomeijing@lixiang.com>
Subject: [PATCH 0/2] mm: memblock: fix debugfs flag reporting
Date: Wed, 19 Aug 2026 15:54:20 +0800
Message-Id: <20260819075422.2387980-1-zhaomeijing100@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: zrinrk367zq1f8m8p96fsjakg5sk1tmh
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 621991A0007
X-HE-Tag: 1787126070-537216
X-HE-Meta: U2FsdGVkX19Ts2HUFrnFYN7v4qO91huLWaTklzFeVt2Ztwk0rFIk2PZH15LhCAHbDwjGJ8LGE7DxTBLT5zp+hjyKg00yaftmbvCZix2yUTaTStjjV8z5aXkQsnXOqv3/c1sFISyes1WlakDz9WIcfI6s4aL9vA0uoD3SjBx50fOAv2gfdsEX8jfccjK1gOCpEGJmBFlxx784oa/0m55Brmgw2qX4QBKJlGMtlsi338qZvvbGalePcHnLy1ZIFwCAR+wdaqzplWLyneV5469yAYWQyZjYQOzPgp5KEMRj+xboZiFTEVAQ0AX0/zcjZip+45+MsOUHxvLMJwqiHQvUuPLZ6i1FC/iEitKMIqcifdDsNfbZjT20pS923uYBC+1FhYcPx0/7HUsMceLODAvXJGOWv4T7bwUJv2p1y+0BnSAafyqCKr95zY2c2GeqLe8exI8N2zDupxoEiVtX9Zn/RlloZmM4MBz6VDErC7pCWgZu6UHP62iRUYL+gnGWkda/iNNJ0jFYtAbGT91De66Q5+Mmj2Ihwe3iO9B3D6QSMr8bhWsTykN6NibHCKEBy/P/Tx0VCEpRP7/JBqRQ0TXgS/AaPFbF/63lH6me0L/Jt5CCEil6GmQf3XPoT4HyQzm+lcj0l3CJJZloGTk77xwwBqOEZpWfWumZlgk4fdiolZcPgwW9i9ewe7GMpwiRNz5iLixPeW0eLsXMVbLHSAzTWxShumyx1vESU1g0UPJ9zdNdVqhshWQL+TVRjFHU+f9Xnc/WReyTVrg8ZwYSgcp1T3tL16KOoyTPTixIJFc3WG4PEb0cuOgI8lybpiZNse/jKtBqOFIM4u78IleK2AOjMrPA2FswX7VCafxDEI4cIMeb/b9nYpkuY4b+Ww/5F9SR3ad0IS1DZaqws6ce4I1UBBhbHwGTdccuObGwzNxN+onUBjhL3gMyagNe/HqKyDPPITr2HGY9iOan3SNzc3d
 Rity3cwj
 k43s8E2OM8BQM3cjANDWr8oapHTLw6p/fO1ZBSvKiwJB2ruMpRQvSwNxt/Djj1UyIPoSoqNcTRiiH+vstxz7z9SLWbN9/ebR6AOTzajCsaPvk8h7eEmVUZfFUZlNmjHa1uedPFnkuSI8gn5HwufdPJPWTcw4zT3a3Aa675I0pvAalf3eVVPR3W7yeBCLpUO3xBjFhF7JrQDMNOoUDFMWT5jCjmCdKjAShLbaD9oJZECNztbTNF7S2RLBKJmnXxuYpEGP4Z1bWXZPj6B1D2y++V6UscKvynFrJ7j6xTlkIjXfh5xubOhTXEpLUyhiyEiWy4M4Lkt8p+H6OeMKdcHsv9WAwR/Z9XFJXH6mZKZwtMgv8c1wscR913b6pslj4u3NGf4mY8UCqmZLPw64CPKG/0sEC8+11+jiy8Mm5qcSaUS5yNxLQW8WplmpiFqdm+pNCGD3HroSzw1MPyEilhiiBOqnIyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Meijing Zhao <zhaomeijing@lixiang.com>

The memblock debugfs interface has two issues when reporting region
flags. MEMBLOCK_RSRV_HUGETLB has no corresponding name, and regions
with multiple flags only show the lowest set bit.

Add the missing HugeTLB flag name and make memblock_debug_show() print
all flags. With the series applied, a HugeTLB bootmem reservation is
reported as:

  RSV_KERN|RSV_HUGETLB

Meijing Zhao (2):
  mm: memblock: add missing HugeTLB flag name
  mm: memblock: show all region flags in debugfs

 mm/memblock.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

-- 
2.25.1

