Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4961FF60D9
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 07:32:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE3EA6B008C; Tue, 31 Mar 2026 03:32:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6CFD6B0095; Tue, 31 Mar 2026 03:32:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5B476B0096; Tue, 31 Mar 2026 03:32:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A16486B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:32:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 41211E15B8
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:32:36 +0000 (UTC)
X-FDA: 84605540712.14.9794979
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf09.hostedemail.com (Postfix) with ESMTP id 755FE140005
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:32:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=imbJRG49;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774942354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9lGLRyHekliNWF/e73UsyDVKIPVttJC0CnEap7PKUCs=;
	b=AD4xaDb1FN7jgiePCcmg/3KyJhWa5ssnhcItxAknkvyXzPyZ9GHHFz4r95/uvh7I24mOlN
	9/SPTfERc1zUETqLJegQ6lOG8d4/5Xke0Nh3zltrcSUvWi+tKnpEVYXb4ZVpe53nLXIP+P
	HTht7zu18oQz7E5P8yZbo18GrHWmH6E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774942354; a=rsa-sha256;
	cv=none;
	b=0Srr9KlkurUvNG2hB/BOzmOqji2SQ+TM3ZWG9JpyjDctQmlDUtAg18dyk+F3NqPb8QOM1r
	c69KGZo17lxx+MKI1So5rbs9QYAvBQgVjHpRqQ6XkthBaRlB9DdEGRC9IGkPJeLehaou5Y
	LxDdVsQN11uIFVl9qXXbf2wA39iwbUo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=imbJRG49;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-358ed696623so2408067a91.0
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 00:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774942353; x=1775547153; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9lGLRyHekliNWF/e73UsyDVKIPVttJC0CnEap7PKUCs=;
        b=imbJRG49VLe4p2zwTQKKS00mFSha1b2Er2JZ/nsguUDAMrUr/pbK1S00WB6kPSd2YW
         pzE2GNJrstBkoaMY5XQ4AePeCdGbFaLpSO6N+3OwdmTQgBuSLvLaCdPZK21Rfgnio9IH
         yEsfHLdA4m8r8btMpca34Z9DVowthr+9RsslfZsUyRZZUJngcjzhLNOnq0/sb6Ph/hfa
         MSZc6TFDbX1KRTlMu41mEnfgkHc5C6Fc1iej+qwNAfpfD7l6F/G424QkU34JKzXSImtl
         47COEm76ciLIrU2FCCNnhKdfGggoHmGaN2+JrQE9BxtBZxB+/Q4B/D/M5osW+RI03OvU
         +ORw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774942353; x=1775547153;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9lGLRyHekliNWF/e73UsyDVKIPVttJC0CnEap7PKUCs=;
        b=WW1qWhxJ3qNVb37Hd8gywZbFVlNCTh3HxvMbNz/2Q4JUu7A+zI22oh3IDngZ6U2H9V
         SKkUtvMtH8fmzNng6J1cLEsLZPiaWw1Tm44Va1puAKYSbGprbw9/b1pNUtGcbo2kkX+3
         gxhwjN8uwRd/8CZ/x1i9yJkXCJdxQe2EEkRPfh5SzB85VGrqTifXm/XEbLSh+et0fbiX
         9HSZT/cdWQcZajuSj0Zrcjdyc8GVsuNyiAT94mJgVkTrYXOqRAqhl9QirBOMUZEtUCDe
         ttYQBnyVE/huNSNrppzkZxO9x6npRNrQjqi5hWDyw/yCjWgIyZpFD0PZ8P+OfjruldDG
         kqKw==
X-Forwarded-Encrypted: i=1; AJvYcCUGP4zBQm4b0fUS30CkQD4jz8WjCDshs/rfSmDtpURWjXGljvDoekuz5qwa99ziCHV34en1AqZVjw==@kvack.org
X-Gm-Message-State: AOJu0YxFgX1hXKGInf8GeFMLFUnKtRayZIx3Dfxh4N0waYKmSuCLPT8Y
	6DVL44pBcFq3Ak8UnSpFePaZfgJ6rEtr4Os0vbLQcfdNjOg8NAqJYKm4
X-Gm-Gg: ATEYQzw6TAcQGHNRPaqHGIbmvgidVmI3Iuii/IDXcVvySLIP7rgbEkvEjMxFCw8Cgu8
	Hgy8rqPvakBW9gwJGHIpYFyoi0ZGgj0MAETTNtgOB+ybEkLCn3SJ4Di9aBEjCD6n0I4S55pQ6L6
	tU+qJmsat6h0CI+WrDq0+kOjTjYdADiLlnPO1HVqaAe/GUcwQTN+BFBkyme5VFe4NmdeETrSHfV
	OqS4S82qQMV6Reu8hL+KD+Xw/91nwzLSxmN7HWKhZcJjmBCqb7XEBntJRnSCpnpYHFKVl6s8pGA
	T+rZd5Sp0UqtxV7RRtzGvUS6EHNo4YGFNWyS8pVxLmc83rqQAffvJzWaqWa8xN48KmtcN5g/KMI
	OHYEuHldI0cVubqF25JxZ2cVJGoTnZjov5cAoIm/c1tOEq4O9OK+F1O8Vle7QCfKbrsKaW49PCR
	/ajj5Wp4bG6kNcvm0qd2jNd5dLAIjfVXUrpTH/gyXpslOx/GJ0a/4=
X-Received: by 2002:a17:903:94d:b0:2b2:57df:264d with SMTP id d9443c01a7336-2b257df28acmr50704225ad.33.1774942353119;
        Tue, 31 Mar 2026 00:32:33 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2427acdb9sm105215045ad.68.2026.03.31.00.32.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 00:32:32 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH] mm/damon: validate min_region_size to be power of 2
Date: Tue, 31 Mar 2026 15:32:31 +0800
Message-ID: <20260331073231.30060-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 755FE140005
X-Stat-Signature: w3mw6jhgngye3abcjzonjzhonhkk8ayg
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774942354-233685
X-HE-Meta: U2FsdGVkX197N2f90HKhxGYVejFITlzf+c1G4FUoB8Mhrjvfj932QPCVSBx2Kb+lwhjAqR1ABTNDjNWsoBHjCxfDrGFHQtlTMyFSGSqRBa8qz5nf2GGozuKTiqk14aBvqFwiDdzOXkWsOv3/LYQAY2SUKM6VeslSfDJNHJ6JPTafsGQi9aW/78Z/zJG01EeZVvJM9EZUuU8FG+/U/HceCw2+xgF9hjVk4JoCfKrtLQGol/lLB4HTfFAyZRom9B5W1w1+4IxQYd+AAzjjolD3B29MJwLcfrnRdtFL9ZF9hGEwUYNimriZCvSUiuFwtoOYp7U+JCGmhZKDV47evlO1t2l+4n6eCqyxQXVmbOXWbEwmDOe3JZvoC8PseK7/PDDzaD7QnveVOpH8+TpaRREK/+E11awdp1P5gPvMvFkMtraS3y4fL3dmf/35TGxKKE1A/peHFSTmcrAzIeZ8zPOx9ps4aHuK6TPGierPKX9oI7iYZPSsNDu37Qb4mMcpPweQAq8lzCBg2TLwsI8maC1gFOAfAlDcUGiIyR/+O3n/8z3hAvfqbMLSJopSBJFXVJYptosbSbegdTuo3Q3lomFlQj3HhPOP4isv3am9RZ5+gR53uVEm7X5d3+WqchJeb2SxvT9+fPlAy5sEr25xyVYVaHHjsi1LwBIOHs/z8kzOVQAY2AbbQddiy3Bi/QQSSYoGqGwAlIPYqP44LSnxu0wJJ8QlkrpoJD2wRsEywTGkDK80eNj+XMQlGbE5w1uYI81aFflEFsV7YrvBFehX93xREzZ+2ac+Te2LKH1gmPk/L3fxZEziwgdoISjRIYtlqW5eCJJufjWepzEIu2ijoS7r60j6sSEKR0B1Wj9XZu521Yp9ajLl0Llu/zzgktEJklW9SFUVbprHSRCy4MdagybBg8oqAamO2zMLMKFPo9m4udkV/KqzQT94JJpywmV4Yfm6m2jJxs+lxsMrk1wsXKu
 kDNHn4Es
 Kfii+a1xXLdYiH0HMy42qC6Oko4WNR7iPSZ2xqhyMgSd0NiVeitbye2Di1u/WKOUUjk/Kbpf+li3mvXnj+w0Ph3WhR29yMkeK+8PPWz84qzLdklQpIblfjgl3XjAcexMFuIZ3zVIa6RId7fcA4RYlcO/32r2jt7YGKS5mj2SP9yrnEwYGvxjtLorcN2N/VqXV4JwkfZIdiOYsTnKxPKz0S44bBA4qnyj9iD5wgilIgJ9/OYt8FzyaM7U0/Em/bbqngE8+CSZ9vstGA5MqVt7a40cfv4hcqE1VlolsAPgWvG9QYoyfHGH9UmvSpjCT7/ETGAdIzX/LbRSS2i9U8A0Lxgg0jH3YH1JxDpY78fWiE5k0ev/t/mop3FtGTubgZyPtrj1dcWC60pWV8mPbHk4xaTLDOBFlCVfflDlCLUNpBEu1lxWJz/zFHVAMmfMegBYbzkq+39uJBe1FNIefmnH64deWWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Problem
=======
damon_commit_ctx() checks if 'min_region_sz' is a power of 2. But if it
is not, kdamond will terminate unexpectedly due to the user's invalid
input.

Solution
========
Add the same check to damon_{lru_sort, reclaim}_apply_parameters(), but
return -EINVAL immediately. This is to prevent user's invalid input
causing kdamond to terminate unexpectedly.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
 mm/damon/lru_sort.c | 3 +++
 mm/damon/reclaim.c  | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 554559d72976..205592194efd 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -294,6 +294,9 @@ static int damon_lru_sort_apply_parameters(void)
 	param_ctx->addr_unit = addr_unit;
 	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
+	if (!is_power_of_2(param_ctx->min_region_sz))
+		return -EINVAL;
+
 	if (!damon_lru_sort_mon_attrs.sample_interval) {
 		err = -EINVAL;
 		goto out;
diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 86da14778658..6e29d92670c4 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -204,6 +204,9 @@ static int damon_reclaim_apply_parameters(void)
 	param_ctx->addr_unit = addr_unit;
 	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
+	if (!is_power_of_2(param_ctx->min_region_sz))
+		return -EINVAL;
+
 	if (!damon_reclaim_mon_attrs.aggr_interval) {
 		err = -EINVAL;
 		goto out;
-- 
2.53.0


