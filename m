Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB67DECD6FF
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 00:37:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 211C56B0095; Wed, 11 Feb 2026 19:37:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 177386B0096; Wed, 11 Feb 2026 19:37:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1AA16B0098; Wed, 11 Feb 2026 19:37:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CF7376B0095
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:37:38 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 926F913B3C3
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 00:37:38 +0000 (UTC)
X-FDA: 84433941396.25.B06AD3C
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf29.hostedemail.com (Postfix) with ESMTP id DB90612000A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 00:37:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oXw4zfL8;
	spf=pass (imf29.hostedemail.com: domain of 3zyCNaQsKCJg24C6JD6QLF88GG8D6.4GEDAFMP-EECN24C.GJ8@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3zyCNaQsKCJg24C6JD6QLF88GG8D6.4GEDAFMP-EECN24C.GJ8@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770856656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h8YVk6TJ+SxHQqdzURW4gj7SpPw0Nw5yYajSbj7tT84=;
	b=rYNhaO0TJ2TrdpCB18GgBIXYaOJCu+7kCqwmGaGfkRjmFr48gZESgdlcSLT9c6srtaObRJ
	BOW0INhYXLhGKbrY9vYpkMMKCc5qCg4iMx0c/72Uquf9O3OWT2Efd0kKftyGxhqru0WXFp
	9DxdFsSxpe+9w6VbidC2qgbxRoBGYRw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oXw4zfL8;
	spf=pass (imf29.hostedemail.com: domain of 3zyCNaQsKCJg24C6JD6QLF88GG8D6.4GEDAFMP-EECN24C.GJ8@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3zyCNaQsKCJg24C6JD6QLF88GG8D6.4GEDAFMP-EECN24C.GJ8@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770856656; a=rsa-sha256;
	cv=none;
	b=QuVXQAwjykGLw/sWNROmgp/TEb6sT5zeNeCMinddMgvXHvIhoDmQTTohuzdn1beFt4wU67
	NTEESrf9hoYwlfiXJ+YphjRFRnkuLscRwotX8Wb/FrAKz3gtc78BrrQVJKEJ0x+pXmWkpQ
	PBKjMHCYB2DkBrvY0viDPA+rHCIrmhA=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a79164b686so30002705ad.0
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:37:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770856656; x=1771461456; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=h8YVk6TJ+SxHQqdzURW4gj7SpPw0Nw5yYajSbj7tT84=;
        b=oXw4zfL8aiX139IY0k/3cctpD+hiHCILOAA7gjj5MqajwMK0IU5yp6ArDdC10JhPZy
         Zj6cjNi4YPqj7j/1hvX9GO43NOqhRcRuHpoDSGbqA6A+WV8RUNMA/BaXrBjrm3nLGc2o
         wksDf4cAFtJsW1dkr6fdZfwHgCaufw3TVHgJRu1ljWFXf4Uwhc261gQQu0Q+CpwN7j87
         ctmKGsxjBjSJMEEeyZ5SprwO7G4Y3+SCB30oz80WQp6VhE4ThExXcFgxDpj0acGynP6F
         XCdcUbqa1EA0wdxokVD+V+hp1IpD2K+Q1idkwRycxbtlRYT/192y+ArqU4zNlT3p/if0
         eAMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770856656; x=1771461456;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h8YVk6TJ+SxHQqdzURW4gj7SpPw0Nw5yYajSbj7tT84=;
        b=frIMmGkLdo7Uv4QCaOx29o3UA6nHozIcwd33Zttfx7ITZpuhhOvHYA1HhHqhPblAjB
         Q7FRGMyveHy0DTga4HG/t1VB5mQ4uRvNdaTR8XO+EUuJYbsgziHM+31sbff18bdZkhKG
         eFw6hRBA5iTuAFaRV/TTuyrB+y+QLaw8VCEnf9mtk1UsZD+nuHr+q6dYBkJkuEsOy7wq
         iUTfT9cQaUtR/yRtdwdf0SMcSfePpvl7fB2/0o5w2fFdc042VWAsCpZUpHcxZFAnsCRM
         0xPk1Ms/thk39M4zbpQaLlwYpnOBxk4zESDIR/oa9zo2UD2dNUnHOOJ7YEWRDC4DK3h/
         coQw==
X-Forwarded-Encrypted: i=1; AJvYcCUohAl/AYTo8uvIwHfmY4JglekdCBqqc3cMb9dYBcaqDhRZNIDj7/HF7ALodGFixxucoMGNFKu1sg==@kvack.org
X-Gm-Message-State: AOJu0YxE/IuSi8++CXT9WEyk/M5n7wCeouRkBF4cQ7aSshiWe3E/OYqY
	kBbuLTXiBBBnEJKJE4doSMZkHbcmYR6wPuI1k0NZc8SUqGkyiSDun0Zafvnk8hGVVjCCwzKMlic
	hUJZ+LpJ6or9YkT7oASmgrIhR3w==
X-Received: from plok7.prod.google.com ([2002:a17:903:3bc7:b0:29f:2b44:973b])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f788:b0:2ab:1eef:0 with SMTP id d9443c01a7336-2ab3b2accc3mr5208665ad.51.1770856655751;
 Wed, 11 Feb 2026 16:37:35 -0800 (PST)
Date: Wed, 11 Feb 2026 16:37:17 -0800
In-Reply-To: <cover.1770854662.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1770854662.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.310.g728cabbaf7-goog
Message-ID: <9b59772c1c06f6628d842d5d30f1f7777c621c90.1770854662.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 6/7] mm: memcontrol: Remove now-unused function mem_cgroup_charge_hugetlb
From: Ackerley Tng <ackerleytng@google.com>
To: akpm@linux-foundation.org, dan.j.williams@intel.com, david@kernel.org, 
	fvdl@google.com, hannes@cmpxchg.org, jgg@nvidia.com, jiaqiyan@google.com, 
	jthoughton@google.com, kalyazin@amazon.com, mhocko@kernel.org, 
	michael.roth@amd.com, muchun.song@linux.dev, osalvador@suse.de, 
	pasha.tatashin@soleen.com, pbonzini@redhat.com, peterx@redhat.com, 
	pratyush@kernel.org, rick.p.edgecombe@intel.com, rientjes@google.com, 
	roman.gushchin@linux.dev, seanjc@google.com, shakeel.butt@linux.dev, 
	shivankg@amd.com, vannapurve@google.com, yan.y.zhao@intel.com
Cc: ackerleytng@google.com, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 7mz81kso5shxb5bca8qqwgg6jsoegxe3
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DB90612000A
X-HE-Tag: 1770856656-813660
X-HE-Meta: U2FsdGVkX18sFsqjGl3aovpFS/+ZjZwGg/9jd6hdB0TiGPedal3TA64UN28kRrFdo6nyQNYn4vV9h08nO3LkrdK7U/P2Y1lyH9k4YP+fWNE3EWECmQW3f9W3qJyqB/pk4gLYFaibArgXKAIZZeV4geZ5HQcfTrSNLSw1q/z+Rs/5SctA6sCk+LU5m97Sr1umvGKHhMy4FmRKL3lzIySfo8eKTsBriPDKbF0xT9Ef2t5PILk2vaV+8prDhUNMXMT7h0X+YwqR1G6BQSgqX/bhUkCr9W2oPoXdb9Wo8ICPm6cVMgwXwI1MXKdPTSQQiUaxiSZMkSDjepb8dgxRRy7ug2rQ1iflGEvOegv9w+GEiTexf6nYx//90q44YLEgppoaW3jlmot3G2NpN/kwoyScXiB3QffnOl1DnXWQuuI9BoBatNt7cyYmspoyRqno2tngGzxtSAmQLLfaPe/Iq+ODRSEoTAf98Yh3vh6sqC47arXAUb6ea3O5jaHR1SD4tUmxar65ywZoWD5eQlNeJgskno9kdi1PwYn1oCpzcgvjhg/Xv5NfXq0p+NnfU3GcRr3E5Cpw0a8hRMP47UCD/UH9Eq/5XfeXUJurpTUib0Ux5vrbXnxkVObjR8/g35QOy8BZGwJ35VBnexSCmsPnj8oNP8xrbeZxNj64LccBuaK7qq4KsILA9lyXAqVI3D3EGgEYMVTPJEXplnuML9LMqOTOoPp9tiY+n4GTLPwABjQAaJd/GvgQMgM307TeYE1ERDOF4v3P/t4aZQV1fhnaC3tXqnntUbQgCFvR1atqhwHFJgFy/dtdk3IM7Ohyr8s10G+voimsR7YODogtQsslzSiMl82ugoVMVwIzy8nQBM4dC4QtlPhZdE3J2jvrblM41U0uf97i0IK9leIasDBmL8X0zIawAoQj85W3jRTL0nrQVJcuR8vqqTyUFW5AfXfPumoRJDPszTP0OReUBqe4Po6
 Sgwx19e4
 ckAYmvO/YosLaXOGaubBP17g8cKJ/wpeKOWX4mXzGdsFM7zF+EoWxUBx8un3PRRUPDOjjGDdeRrrLGi5AQQdcKrwlloNrNz/k080SRb9PR9lqCVtd92wt0lYN91mWuUNcqs6L8O+R0FWN0e6NOv1KNIpFBex6xw4m1zchAfuE6wA3YIGtAZVIE+epI89jLJReZRfuPOsbQ9LYviV1w76lo4s3uvS6XotjJsy8SnMUOU+OWB6OclkoYW+A/DsV2s+IdSM+rt7sl/QU1L4YX/d22bmE+wBcmLge1RAW1D18oW4Pojhxc4J6AOEWzN64/Cwc7KklNFViv8dJ+NtamaOfcgleLyFHR39vFEVVV6yXPuCH0fvkL7jGYiWHy3v6CBS1XrOggzJefu+8z37zH2AWfxJS1VxiIf6ENqvihHCWzQ/gA94mY3dxguI++H2+qBod//EwvMSYcbwmCB/ECw3Aj/nGbprymLXPMLvko5Y9fs+rOrT29/30lwfgnHfNf2bBL5CldFZEj7tqfvkCLYAN7M0L1k4XIucMjLlRn47+hsWPmB+BXu39kOYA1RHNNmeiepGAb2cg2Xz5yIgk6wfSf8FGfX5H7wGshVRwJuc0p/m4+nImWl/DBxcGK4Li6WTEsqQ2+6u5GT7wELnT+R255vOTnWClsPMy0DTX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With the (re)introduction of the try-commit-cancel charging protocol for
HugeTLB's use, mem_cgroup_charge_hugetlb() is now redundant.

Remove the function's implementation from mm/memcontrol.c and its
declaration from include/linux/memcontrol.h

No functional change intended.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/memcontrol.h |  7 -------
 mm/memcontrol.c            | 34 ----------------------------------
 2 files changed, 41 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 59eab4caa01fa..572ad695afa40 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -668,8 +668,6 @@ static inline int mem_cgroup_charge(struct folio *folio, struct mm_struct *mm,
 int mem_cgroup_hugetlb_try_charge(struct mem_cgroup *memcg, gfp_t gfp,
 		long nr_pages);
 
-int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp);
-
 int mem_cgroup_swapin_charge_folio(struct folio *folio, struct mm_struct *mm,
 				  gfp_t gfp, swp_entry_t entry);
 
@@ -1158,11 +1156,6 @@ static inline int mem_cgroup_hugetlb_try_charge(struct mem_cgroup *memcg,
 	return 0;
 }
 
-static inline int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp)
-{
-        return 0;
-}
-
 static inline int mem_cgroup_swapin_charge_folio(struct folio *folio,
 			struct mm_struct *mm, gfp_t gfp, swp_entry_t entry)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 70d762ba465b1..87d22db5a4bd3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4855,40 +4855,6 @@ int mem_cgroup_hugetlb_try_charge(struct mem_cgroup *memcg, gfp_t gfp,
 	return 0;
 }
 
-/**
- * mem_cgroup_charge_hugetlb - charge the memcg for a hugetlb folio
- * @folio: folio being charged
- * @gfp: reclaim mode
- *
- * This function is called when allocating a huge page folio, after the page has
- * already been obtained and charged to the appropriate hugetlb cgroup
- * controller (if it is enabled).
- *
- * Returns ENOMEM if the memcg is already full.
- * Returns 0 if either the charge was successful, or if we skip the charging.
- */
-int mem_cgroup_charge_hugetlb(struct folio *folio, gfp_t gfp)
-{
-	struct mem_cgroup *memcg = get_mem_cgroup_from_current();
-	int ret = 0;
-
-	/*
-	 * Even memcg does not account for hugetlb, we still want to update
-	 * system-level stats via lruvec_stat_mod_folio. Return 0, and skip
-	 * charging the memcg.
-	 */
-	if (mem_cgroup_disabled() || !memcg_accounts_hugetlb() ||
-		!memcg || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		goto out;
-
-	if (charge_memcg(folio, memcg, gfp))
-		ret = -ENOMEM;
-
-out:
-	mem_cgroup_put(memcg);
-	return ret;
-}
-
 /**
  * mem_cgroup_swapin_charge_folio - Charge a newly allocated folio for swapin.
  * @folio: folio to charge.
-- 
2.53.0.310.g728cabbaf7-goog


