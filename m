Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E829C982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 22:48:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C65E66B0092; Wed, 16 Sep 2026 18:48:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C399A6B0093; Wed, 16 Sep 2026 18:48:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1A796B0096; Wed, 16 Sep 2026 18:48:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7E0926B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 18:48:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 84810A0165
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 22:48:42 +0000 (UTC)
X-FDA: 85221116484.18.42C90DD
Received: from mail-oi2-f13.google.com (mail-oi2-f13.google.com [74.125.231.205])
	by imf04.hostedemail.com (Postfix) with ESMTP id BE3D440007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 22:48:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="s/rhj8sd";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.231.205 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789598920;
	b=wKSgt6vVXG8QvBwVdUYVHpSdDvZyV04JaR3DjlSJ1T6n2jOqoVK3bx+sk8iDkx8XsHPCcb
	N9vO3XOJjPANhGaHsAiTNcDkCQ9JG+/rRx+2HCYAJ/WAIur7K5QicmdkKPwakad+bf0yPs
	Gi3ojfOPqjukqM32NPL9FjulUC0e9EE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="s/rhj8sd";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.231.205 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789598920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y3DsruqsJ6vqWJnbbQmLKQ4RBGHdEmodPHIqSeb6nLw=;
	b=O//lxoL4OFLkvJ4CiJb8ZO6Y60uyzKsg/z4ErzNmpRripysKital9kMNBkWZ8CuH46bwye
	LMyyJa5RkRBvjne+81VUwOGBVTrgZOSyRpu7s2J9CBoCt9I6OPlgsa/BxHuxSYrn6LDkyB
	VxgKMM9oCj6xqAOL66piJwSEU3z6ooM=
Received: by mail-oi2-f13.google.com with SMTP id 5614622812f47-4bf948737e1so154497b6e.2
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789598920; x=1790203720; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y3DsruqsJ6vqWJnbbQmLKQ4RBGHdEmodPHIqSeb6nLw=;
        b=s/rhj8sdJ1cm2CYaK6szZuxXbiATqdjm1YKdw45EiBjoqJL958YBeO0IL5RdyGhtZE
         5dkye6SFOMrKACrsrquXBgpMuu4BrFo+CNuUedwYU2ICFcXd5t6F5ltm5TUrWHKzbznH
         Yx2o9HDxp9kAIyxthvH8B/nrEBIFdSCuq+F1MJNd5L5PcYjjvpsKmVVx0LQ5a5fw4eo7
         I4FQDT1i2WrWicZg4pKQVOerKiUiiiOuAgB6pX2emJ8OBUHDkv41vx4kDb0ecBDcCzgi
         6Iw7CuzdOlJ6f0rqCu++/iNObtpEk0FgSyIYEXiGJCS0ThlOJCG727sLsH9Hv/lsNYkX
         cQ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789598920; x=1790203720;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y3DsruqsJ6vqWJnbbQmLKQ4RBGHdEmodPHIqSeb6nLw=;
        b=B7rN3nRT+n1TrJ/p93FwIr7iOnECgTB8mg9N9VDjjtFGB6IA9MOCDvKVacxwyH71Zk
         ZDP18Yfse6gxTpjm8EFhJp43X8ZDlKJ2mWRn5o1g9hhNl4g5TcUY08erbxjR29pwTWR9
         oWxJkv/dg68DCck0xPcS29dbCF1hiPwUz66SKTCkGCeDQYJBZL7UTeO55FWZ3DjUb6ZX
         nYl2wXBQYkb0e1olwoMGlUqPWq2zXip9RNwcNEzeBKVnZn4StMdDG9iCHbR4y5yHUOh1
         dbC0w5C7Eo+R9wYp2Ecbt6RvYVhkpGJGPwQva7xdPqvXRE9qkOT2j3bQVqR6Jbnkkqv2
         iCLg==
X-Forwarded-Encrypted: i=1; AKwUvBxoCjcPeOcaQMeVWJBAmSF8Wp7ml8aHdXDsPtxnws04o9dtY5kl33q5Dr09QwARY5g2IyOvOUhMKQ==@kvack.org
X-Gm-Message-State: AFuF++kkKaY4knfAzufIKLP3rk4f7OX5cZkvvHxjhYyK2WTF6osp0e+4
	Z8m+5E+ssLnf6YAsdMMFoeq3Gnsgq41U/uiz5ywaYvKLuB5Ij/jPQ5k/
X-Gm-Gg: AYBFou3si3iOphRyqp43ypSWMpqtIUbiInTaGCjfgaNYOMt2U2rAzMjgFnfIifXr09d
	6PLmGYdNY4WYLYVSGaX/uzxrsMr64ZrPoeT3hx+9g+P06oJ7F9Xsau6zncxztWJYNUzFfvd4Aj0
	lg7vCO+wPrH3OBLXmZRMPFnY126VptubSFrAkcEM0yjkrtQVTT5Hs/AgZ0GJFSTmq6oepMrVcFl
	rDGRyZ+xiYQ5kBBOJwIu/rLToDdywwVFjYTpDQtY/TlioQAkEkJhFAa3sYPi0Eo3DgYLaOifqQr
	scKQd/PXfKA4zEdQuMZuHbzKAu0Woyzw3EE2fjlj963UiZX/Xwn2ZXX4OHyEzbdxm+9le7kcHh/
	ALNCy4bg6v3IxkAurErIpNL9jEHLESd9dWki+EwTfPxRMJ3cKvnpoFZ50LYNSa6E8CVr+1GT9oR
	cbRzGyTEZR6vt2Sj9RCXvF5n8njUneaGAyf99R6TSRkN48yTLMYs1SOMcGQHAiCby2vuWaUoP/y
	LoXP1LYdnfGamyDBTqQze/0QCCtd3B/GQ8OCX561vAs2EHYWno=
X-Received: by 2002:a05:6808:1393:b0:4cb:818f:d56f with SMTP id 5614622812f47-4cb818fe24emr1023028b6e.23.1789598919766;
        Wed, 16 Sep 2026 15:48:39 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:5a::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4cb6d9999e8sm1069913b6e.17.2026.09.16.15.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 15:48:38 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: usama.arif@linux.dev,
	hannes@cmpxchg.org,
	baohua@kernel.org,
	alex@ghiti.fr,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	willy@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v2 3/3] mm/memory: add anonymous mTHP folios to the deferred split list
Date: Wed, 16 Sep 2026 15:44:37 -0700
Message-ID: <20260916224437.1164512-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260916224437.1164512-1-joannelkoong@gmail.com>
References: <20260916224437.1164512-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BE3D440007
X-Stat-Signature: um9sbrw9ugg8gqi1hi1nooe696omb97s
X-HE-Tag: 1789598920-965403
X-HE-Meta: U2FsdGVkX19olIp3+VsOih7uaerXwHiWbKtglUkVxIrg/vv6vxVXyZOHVjOgc+WlCbHmiWcz8wtrCAKWQmr9+7lMmQdKIvL+80OKBxwd+wqksIxywepHX6sDUZLkysIophQBy47xWwcdyp0kZl/L1ijviv7r7n3LT5co8jMURAhAmQEYLT1dhjS8QtyK0z1zQYkn+xrRgGpdw/FHMrRLo9Tk9MpRD/DBPXwt+JEp6vMzcsn6Tv0C5uKNp6nUQVj2htmQmBgjWYleQseHU0YyZjcjiotQ0aTgkza0qOSG718n2uNIraPYAFGLlw4VaBZnX820EW02tNfZfYZETjdeQBQVdeWWV/aeUsN5M0qKK80Z5+iAV/ULKN7iXF+ErtU0StRecY0ZdykRZphqLH+SyxDF3TXxpBN52Sg8wxkd+vKL199+1kB9D37rNGN75GH+76u5LKMWkcelO6G60aQ0ciBabZxjb2CjSzlhfrYTWsKtUW7uwmTYqxTD1LlNgw1/hlb8EerUFEXHgN1iw1nWL9g+SUEcMQrQqGL1Hff40APFZ/5kVpVI28pYMlixzDSN3FPu9yTS1iayHRQUVck6LRccSEd0ukzZubAnGUai2yR0YfC1pHPfAOr5A5qrWeJYkgjJ1tXDdJ+UjvI0GmksaM3uYtAPRVlsPRrc8Vs2UHMOIewapvil0kyDnsRnKpI19Jyx8vi6v7FTukCo3dnjke3pD2UvGJsLFIVbYXdpiCK8BvHm9MtjRHwSJSHAAQinGXoHofxPQdR0+9vlmre0eKg5L8guetMyASkJOx578h5yOkvZyAbJqvfnX4yIRkfujiDxW8iLaLt9ZARYVdVEsFTsYrQiUbcTFBfxDfB51IrMmBmhh75KfizBawk2VGkZz95g321Sm8uTs4OkyF0sXSa8Cu+GvqSYqe8EjGO2BL/b5VM9fasyk0EmtJRZ2Yhb2VN8xjN0NVPLipI4Qdc
 E2u0pfic
 hks1W5es6b3e32gBDKfERQ57QPmGWNLFuK7n85N94J8ggQow7W13fWTj7BYA7zZUiV718YlJTB8qoOHKt1NqYLUgGHNOcYobFC87FwpbDHpLBB3DFhfxgvfn+6/G/FFPXNBzRdujQ+BWTO5VS0wgmnSk80LRC0AjTaOgToRK64nA0j4cHRXrDbtIWM7KN+eKYjCFf4vlWFpJ9WXvB1a/s+rAyC0kTzE3mU3Qu4lfEBeoGMEqBXRUjjsvRM7tKTxbVVv6J0NQMgCIXmVx89Bx5SBMlxGrtXjCExRQO0D7R2egdjKTz8k8ZpOFl7IpCsuFEhfUYzxZc9eqI/Dw8zbsRnDm90sTafXWJpoaNu86YGzt/y44dtXu4ZFczFfwSGqYUx/pTpXGh8Odcgtj1REVPk71LEbX2vqQ0TBrxI5oZ1KgqWTwc8uq2q4KeAaEMKAJny/IX8Ul34BEJ8rVRJ99I4hQLXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Unlike for PMD-sized folios, an anonymous mTHP folio doesn't get added
to the deferred split list at fault or collapse time. As a result, a
fully mapped mTHP folio that is mostly zero-filled doesn't get split by
the deferred split shrinker when the system is under memory pressure.

At Meta we would like to deploy 2M THP=always on arm64 with 64k base
pages, as 2M gives the contpte benefits while the PMD size (512M) is too
big to use. Without underused splitting this causes memory regressions,
as the unused parts of those folios can never be broken down and
reclaimed.

Add anonymous mTHP folios to the deferred split list from
map_anon_folio_pte_nopf(), mirroring what map_anon_folio_pmd_nopf()
already does for PMD-sized folios. This covers both the fault path and
the khugepaged mTHP collapse path. If there is memory pressure, a
zero-filled mTHP can then be split with its zero pages remapped to the
shared zero page and reclaimed.

The preceding patch bounds what folios can get added to the deferred
split list. Nothing gets added at the default khugepaged/max_ptes_none,
and in cases where it is lowered, only folios with more pages than it
are added, so orders that could never be underused are left alone and
systems that enable only small mTHP orders are unaffected. For underused
splitting to happen, khugepaged/max_ptes_none has to be set below the
folio's page count.

To minimize overhead on the common order-0 fault path, the
deferred_split_folio() call is guarded by an inline folio_test_large()
check.

Suggested-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/memory.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 8b0c2c735d3d..1fe76f72868d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5406,6 +5406,8 @@ void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
 	folio_add_lru_vma(folio, vma);
 	set_ptes(vma->vm_mm, addr, pte, entry, nr_pages);
 	update_mmu_cache_range(NULL, vma, addr, pte, nr_pages);
+	if (folio_test_large(folio))
+		deferred_split_folio(folio, false);
 }
 
 static void map_anon_folio_pte_pf(struct folio *folio, pte_t *pte,
-- 
2.52.0


