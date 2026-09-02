Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B863C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 08:23:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 627946B00BB; Wed,  2 Sep 2026 04:23:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D24D6B00BD; Wed,  2 Sep 2026 04:23:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44D236B00C0; Wed,  2 Sep 2026 04:23:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0BCE26B00BB
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:23:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 97C861A011C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:23:03 +0000 (UTC)
X-FDA: 85168131846.18.83B0B09
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9CCF620004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:23:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aqyQJ0C1;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788337381;
	b=GJVARFzgVwvJMbVriylsK9DRxhmIpvPRp1DbZQ55zo4yQjgDkfr7hn9LVdIPzrZ2sZmQTN
	Smf58q3R4M1Hf6jtwRGf87ZXYXpnfL3lPTlOpLLesvM7UuRaAQH+XzkqgjF8rnruC/UnJS
	vGjQqXB8BwKfJspB7cKa3sJsG/wkznA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aqyQJ0C1;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788337381;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z+peb9dpzKQQ3Z3IUN9jt4EDtAYfNapVJJOlr6ZayL8=;
	b=JtVN+0czFzJHUGHVaDibMHwwtYMTcD/qHeGGRl7oHSb2tyTe2B3DP0q73TxZVm14iSjjSE
	C9OI/pI5cBc/KP6CnpSlmntLMO9195ttg4LGkt6FLiDoE+4lNBPN6P0iXShe89GDty3id3
	D3MG24cg0kxQnJFZZ6gYhnLxuzZPshY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AC6CF43F2B;
	Wed,  2 Sep 2026 08:23:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 79DC7C2BCF7;
	Wed,  2 Sep 2026 08:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788337380;
	bh=pvVk4daAHR7Yy5UIGnTf8/tE6JkSvAWJQ6/StZs6/IA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=aqyQJ0C1tP4t8Z+EYuN8h7oJ57FyX10cf6mxo4BTZOtFiFk9SJA9kYKvzbryAgGQP
	 SEwpoa6f9Dyup2Rg3qyuPkQL8zBPRWA467KEI+USe8mF5hLXsbuG4tBGlw/yew+39N
	 xVsCTM6kqE8kkRWWqJaVQzgjP6IIE1V5xkxP9VBTYtWMqbQPIUKj5r7HhJl6/Aiv2g
	 XoNxGnTmSWn5ivHCifQta3hWKokmwk0fUnbFPw4wa9jDhr/A4SBzYKczPrWdQLWxUY
	 Rwj7anhaAhTak844iM44kDZcMhx5QR0PtE5Us9/aPEzrRvl+qkdzwapPlNOULlG8jW
	 DgK4CjByuwRKg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C449C624D4;
	Wed,  2 Sep 2026 08:23:00 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 02 Sep 2026 01:22:57 -0700
Subject: [PATCH 2/2] mm: hugetlb: Drop refcount before freeing on memcg
 charge failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-hugetlb-alloc-folio-memcg-charge-error-handling-v1-2-e3e8942c141b@google.com>
References: <20260902-hugetlb-alloc-folio-memcg-charge-error-handling-v1-0-e3e8942c141b@google.com>
In-Reply-To: <20260902-hugetlb-alloc-folio-memcg-charge-error-handling-v1-0-e3e8942c141b@google.com>
To: Alex Shi <alexs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Dongliang Mu <dzm91@hust.edu.cn>, 
 Hongxiang Lou <louhongxiang@huawei.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Nhat Pham <nphamcs@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Peter Xu <peterx@redhat.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Shuah Khan <skhan@linuxfoundation.org>, jthoughton@google.com, 
 fvdl@google.com, rientjes@google.com, vannapurve@google.com, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Wupeng Ma <mawupeng1@huawei.com>, Yanteng Si <si.yanteng@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Ackerley Tng <ackerleytng@google.com>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788337379; l=1301;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=OnyqM/8Pr6ZsV+BsOfwDFJ0IbKPvQMMic3OIlvC9rcI=;
 b=B27Ds3U4PhbNKkOtqFYJY/xvCHiXLY5gLSpcHZYLqE1ILOZivlwW3tTQwCnRXp1T4sN1CklBi
 SqpDi7PBF7pBrwlr6s/WJ3+2NQ7j5mO3CbRN6vN8WwFFvpx6oChTAC9
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Stat-Signature: dtf75tkz16k8zcah3jx9jn6a6hskmkt4
X-Rspamd-Queue-Id: 9CCF620004
X-Rspamd-Server: rspam06
X-HE-Tag: 1788337381-195582
X-HE-Meta: U2FsdGVkX1/SnYAkSC2X0V+bvjnTSXok3tUdKdUivvDrZ2mp3T6bKJOzbVCcQPUlhvBgRwK7KB9SBUsDfSVYuaa25/Gwo1omxQnfyyIZMlXGMbca1GfaGjpuC6T4h/hu9Qfa7skNDz/YstTESCqBVGdSE+FxO705zFr+hks+8Wttkph23+97xjvU2uTqgmeAFQmRniCvZ8NiFsok3hDvEQlMwbi75XeLvywsgcakhd6QR8E40HSuzB4SL5Xl5P3fY8AIKCshkHprWMOVTCggmtAqfAMPLbOoCF1VzUK+a6PE+iDPvEb1mpQn1JApaMwt6NY5153bUvzr5zlJyVTywZCzznRtyUXkEjKB1z1cwMD+4mGlMJICKKcbh762jHUEknsRmv2KFHW1igzCXFdjAn/3nTjugPL0k1zNmThg2J7/Aln69sC493DrXfXs+wHgXTQorg0F6QSAbKEMrdTm+NuufYvjtYg99/10sXbuzx+wjrT/KdvqbWPOK76k0ya4BKGfYGjsJtxcAHetaqI30JDFxQyoyuAQH4as2n0vJHCxS0G3DuvGTLyIqPZAHoZOOoz5+Fv7GBiC331dobgBINNsF+nHYaE4idYhdzYcAxPSkzgzsl/xj1asqAepx0e1HrPdztYfdldBpbxe+FywO9IRDxdukqO+E3OyR3rhOStgHGPeMOK7ycyx3QyzqVbZxdILcfBgM/NOyAAETQB5QbgoH8RQDdecTCMRZCLuasOuh7yC9to8akxN76Jyz2XfW05KWUOJGMvewQsdrih6JaXGZ0IkgpbLwREeHMoS2EmVbbT5e1CtZFIrdIJgSDuG0fRA7g6+VdldYEGQjSiSQjkLkYHFP8v4nSidaHvV3YRrhEsbOLJjZ3R/UJUGD1Y7paMs73RIrFix14okC6IyyU4chGcViQaSR8/SUhRpu13oakVDclp/9xgTsXfR08S4c3vAT5stnI4xfIfsbRC
 c3CpuXo4
 ytWsmkLvoYd/CZkcLaPN9Nin3J0gxQPdYVqIlRrKvWQiSLtxveDixf3SWGdppxryXbqqKWKAH4C6qTmM+nrl99jPXytIkFXupT8rLpQh+qZeVvOSwQiuAZIEz4ZkLjo/7AOCY5YujItX05Jf05ERAYjgnHeCjSgNs8nkPit0vRcCotWgHSciQL9HrQjXOXkWKYqK82fx7AvWnla+ZX57TsogP2bcVzyYW68yLc08GZ6VPcYDAlQ5GNuEGgDdhpkcMveCjTqXQlZGtALsxy9wQbZSQnNeFoK3uqd/u3nL1bNuhOcGVfLyvSJ/Vlbs0JkhGPB1DcPjWZY4Qa90/zUrfCCja3lvXvV90a5G15Ab9nCOTUx5xVTh7MOapW3G08Ag97J/qvXXSjIJdl3vni2TRKPD//lB/7RC7K1feCXjuWZM3seopB1caI+on2ufvUCSbOUGm+OZ6N4DTCXdhaTtdBI3ILvI++QPaus45
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

When mem_cgroup_charge_hugetlb(folio, gfp) returns -ENOMEM, the folio has
its refcount set to 1 via folio_ref_unfreeze(folio, 1).

The error path calls free_huge_folio(folio) directly, which expects a
refcount of 0. Hence, VM_BUG_ON_FOLIO(folio_ref_count(folio), folio) is
triggered.

Even with CONFIG_DEBUG_VM disabled, returning a folio with refcount 1 to
the freelist can corrupt allocator state later.

Use folio_put(folio) instead of free_huge_folio(folio) to properly drop the
reference before freeing it.

Fixes: 991135774c0e0 ("memcg/hugetlb: introduce mem_cgroup_charge_hugetlb")
Cc: stable@vger.kernel.org
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
---
 mm/hugetlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 01b57f6d3b804..97c06f227ef8a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2889,7 +2889,7 @@ struct folio *hugetlb_alloc_folio(struct hstate *h,
 	lruvec_stat_mod_folio(folio, NR_HUGETLB, nr_pages);
 
 	if (ret == -ENOMEM) {
-		free_huge_folio(folio);
+		folio_put(folio);
 		/*
 		 * Skip uncharging hugetlb_cgroup since the charges
 		 * were committed to the folio and freeing the folio

-- 
2.55.0.970.g62bdec98f9-goog



