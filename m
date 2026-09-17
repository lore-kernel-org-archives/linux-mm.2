Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AB62C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 20:45:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 652A46B0098; Thu, 17 Sep 2026 16:45:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58FF66B0099; Thu, 17 Sep 2026 16:45:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E1446B009B; Thu, 17 Sep 2026 16:45:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0CA3E6B0098
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:45:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9023BA04ED
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:45:14 +0000 (UTC)
X-FDA: 85224434148.08.755290C
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf28.hostedemail.com (Postfix) with ESMTP id B46A3C000B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:45:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OtR8+MsL;
	spf=pass (imf28.hostedemail.com: domain of 3V1GsagYKCAg46qpivowwotm.kwutqv25-uus3iks.wzo@flex--wyihan.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3V1GsagYKCAg46qpivowwotm.kwutqv25-uus3iks.wzo@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789677912;
	b=myo+nqITYuh9ihy0V4ijJ1I+YC5HkrCD9l/c/WLG5iVuYJAmq8NZjrTr8nrKzt18bstHaw
	d6Wcjiz/bbRRrr1P7Hn19xa1IZCYX1IKsp9OA8T/ug/C2YxSQMAhKxMqS8UaTmy3+UeeAK
	2h9uZF11GlHSiGKEQRbVti/hOwNxSoI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OtR8+MsL;
	spf=pass (imf28.hostedemail.com: domain of 3V1GsagYKCAg46qpivowwotm.kwutqv25-uus3iks.wzo@flex--wyihan.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3V1GsagYKCAg46qpivowwotm.kwutqv25-uus3iks.wzo@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789677912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kGFXLYLaJ+InCA49wUVYw7NUJomlNkAd8fgmCjgGvRw=;
	b=V6ySN4YAQjySfcp2AdfN+ZOikO5Tws+8SRVmh2PN+ZJDNGGNdGF7YjNBtVgFHs5Cyu0/zY
	x6kLOzoyivj+eZSxJtuEe4K1aX7dxrTLQivPu3U2tpmlEaQ/YDGBO0fmwyB2YA9vjhS3FL
	BZiT2VgWchWsKP08TXzF6oWuQ68BX20=
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc4c1fc9ceaso1064695a12.3
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789677911; x=1790282711; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kGFXLYLaJ+InCA49wUVYw7NUJomlNkAd8fgmCjgGvRw=;
        b=OtR8+MsL39niKsTCtOpSbp6ewDH/6DkU/XCmhPzlZG3Zl9MwMMA5uWUxkhxG3vhquJ
         FiODC8Y3XWjx5WE9X3O5cSBlwjnw02eKdeREArH8FcwZR4cnGzHgqyKm30SLCppQByeO
         Rqq8iyEIMG3Pr+PhQXjrGqvQ2qZ5nlmTPpeusbm4wK3hDEBcXqZrDIpzFtR5D0duNrF9
         UMWlhktgLfLpcCAjXHcRHEPOsFDu3sj3vNjIqqc77sZMQMnI6A2zBmZeTHtqcwmIHKfx
         zhj8J5h3LkpTe4/S/CxHwsJ1yzw8CWBRp3oQ7LJN6gAtGFr8Fky4AH4loec0iR1izFwF
         1rAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789677911; x=1790282711;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kGFXLYLaJ+InCA49wUVYw7NUJomlNkAd8fgmCjgGvRw=;
        b=RSGITHCHusnbV3O4AGBcw9Koex8/v3xDWrJj1lrwt03Dih/4RHvvZaDrgfIo+EsMfI
         05Wdbxp5VoqDT1Hqcq68LSUPA3XL8af8XzgW3sURCUvquNz5+Z2VfVcue8ZU0tvv5WuO
         oHJRsHjhsAL/6jrrm5FFf2ST4WjPFKURqn+D5rI330JkZseX6QFNHO3q+d5vLYTM8Hw5
         QqLS9f5ssc0SfwctFcIs97URgK7tQSp2wadnKRDmO9IRDTnjvq4KY2TWGVD+w5sLGIiw
         ibNOSgxsd4vje27RN4KWF1A69cxJ1ft/69rLFoENZL/yrTNUkEKwk8r58DYPMcf06Wl6
         L9RQ==
X-Forwarded-Encrypted: i=1; AKwUvBxmOlbxceax/St3tS2OussLCr3RFidVSeLcaCopd/iQtjagO/jMB7SneNwzsrKRaXT6ZLS1Ifshbg==@kvack.org
X-Gm-Message-State: AFuF++m/Wcr37zWdy0zT9u5stTykcoP9cQkMU6UF4KKXppz8oaioSO6X
	vMr56+QjeMMFcmutu0FWSnxCMIIikJNI1uaqlnGCpSq8ytqElpPZBALhZm0EFaFw6JFoq7tx3vA
	GTyHR2w==
X-Received: from pgby18-n1.prod.google.com ([2002:a05:6a02:6512:10b0:cc4:b427:4edc])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2586:b0:3dd:85aa:452a
 with SMTP id adf61e73a8af0-3dd8c53aa87mr322161637.37.1789677911269; Thu, 17
 Sep 2026 13:45:11 -0700 (PDT)
Date: Thu, 17 Sep 2026 20:43:50 +0000
In-Reply-To: <20260917-memory-failure-mf-delayed-fix-v6-0-4b00856b5364@google.com>
Mime-Version: 1.0
References: <20260917-memory-failure-mf-delayed-fix-v6-0-4b00856b5364@google.com>
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789677906; l=1694;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=y+kljbprzv16FEW0R5LMRlVvQbhp1uI0L+ucmxjcblI=; b=dGqQYjedOERCKiCjnJKisYhsTZMBcs8c13M3JPpg6A9i4it98kymjesDKoJjNEGSRfSyI5HCc
 ODtrd4OL3p8AnfgcbvoGkMFMPXtlua/Nkbp4d/SrhzytfRXP5wu1rg0
X-Mailer: b4 0.14.3
Message-ID: <20260917-memory-failure-mf-delayed-fix-v6-4-4b00856b5364@google.com>
Subject: [PATCH v6 4/5] mm: memory_failure: Generalize extra_pins handling to
 all MF_DELAYED cases
From: Lisa Wang <wyihan@google.com>
To: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Andi Kleen <andi@firstfloor.org>, 
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, Rik van Riel <riel@redhat.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com, 
	vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com, 
	tabba@google.com, dave.hansen@linux.intel.com, Lisa Wang <wyihan@google.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B46A3C000B
X-Stat-Signature: df4d7aqsokaim5k9tgh435j3ek4dgkc9
X-HE-Tag: 1789677912-256497
X-HE-Meta: U2FsdGVkX19GgGmDJiqVXaXpykUIZukwFEnFy8w8rFLkkpld2N9EkoIG7udlx6/1PFICKb4Ib9fqysWl2sT3vL17sd8JfoblQxkajbePjjfo8GjexlqPoJzXRJjeTNnv6WcS8ZbbKrZfeI19U1GkP2FwnXqeBYokLpLF20TEyVbmdL0ZheA9G0XZxZsSZAtZZ/uxrReZkLUpmo2i8V23SdYHYrDB7cgUphZMZfYTgq5bJhVeIlqC8bRv3w0RPIU7+u2SyjORQmUAeLQQp9IqbeZMNcwV+1vUho+oiHBlCEYyTtN4VArzrsYddzXXu0pB1YxwowVLsJgWLwLVG0pz6Ssf74K0RbsKTC1VKRxDj31Aeu15zzsv2gf5URlK+U8s6oyc0qAuImhfeDZH72NQsdSunoyvdDhcSGHx4gx6uBi+ooeBb4j46e5MWUB6BlyvW/oDVrdLWA3cGAXsIVIbp8lfNXuLGibNAeNbzV3v+77UAhSZNGpFp5nX3g0MBgTRtQPQrvdFTGbjUviZbVYzymShB2NOV/BpBVopx18my0TE51viQdKVBPg5hWLcSHHiTLTFg3UM8SfgN1eHaYGjadBTBHrAxHXdbIZj528JhCtrOMsCMbKSqVT7c20/6s5wxQyN9JldT56IwP7sq6iDgQM/fXWVJJ4vS+0q51mDKMtc8Rx0mK3ICKFcNa/MQnXUPQBMf4Fh2ohxwyalPurM+8FJaijLlk+AfRyzzwAUsXCBAsQWekbqmEpXP3ygew/THWjgri4rejk79EizXWv7ghTyo8mjkbk7i9gobaNDPnELvB8sexKAcIYKLQSHsGZUBNIIw9Vc5gqPfUYbjTRwp4sFj5hKacdqhmnK8cCV6BtwC90eZq7W+v+58QHu4jmqf627+AVE25GqH7cVBgPgZ1nwgOxritdq9KjtnBMe4IeAZcfX8hujJ53OJ+YkW+brT4M9QUMmieDM/kEWqHW
 +aReuiI+
 9z8j1ArfSS7ybI+AgZVVF6p12WfVER7C5AUiiQAKkKsAlnK8hOhykgpZuOBm8jTK1hGLDwZBMAWexnqUaR4huTsLjIsCHI3FIyl9hNyWfSmK8crpdnEddVYeBw7hH3nDyy4wRxxrQxzLPKy3et6zg7n5w4dXlFOx+YzfPHYOsc3UccCumQtu3A+d1UYyVCRAZBNB1rzZmBLuySCbMzVUQ4XSBu523iY4uy3Oi+NzXMw4s5lBHPsOaGdan3iLKTV7Y91POIsyDpBrPMxKsRt9Oo9MykWBEQxamcoLcXvyST2U6vAADOh18DPJvrzHI934lj9xRq5kMe4C/n52c8/FVfzwNKRxxruC6rcvQJvPift4g5vG1ux+kh/EzXpoCmiid2KXay9lU8I58eehQ5UUs4eTI3bBEUbEXMk4YqnYTtqdkLxcjz+DdIQXsl9vXvWFSsqoQes8YWBSf9ZCWjgHoPai5dxdB5qmmMrIkrkZJudE9kPnB4uJOPwqrWmxgr3aLVTXMvb/50JGo4xiQOgAU1lLPFkjd5DL+1FJtKwXMTPWkn9uWK0upmXsJYoFrokJjUBEiPuZI2k6aHUEGTIt3FYfVyXJ3+VumOoQac5kCWvoUpCRyqWmHbbHSZZGj+rgGO8aZH0jE5DZ37w/RUWe8foPcI+RrzgjxKszclmG91G7T7HLHAO9D7XVLBI3GwHkGQ5VD2pkf53ZtNs0n1ksDFMSKfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Generalize extra_pins handling to all MF_DELAYED cases not only
shmem_mapping.

If MF_DELAYED is returned, the filemap continues to hold refcounts on the
folio. Hence, take that into account when checking for extra refcounts.

As clarified in an earlier patch, a return value of MF_DELAYED implies that
the page still has elevated refcounts. Hence, set extra_pins to true if the
return value is MF_DELAYED. This is aligned with the implementation in
me_swapcache_dirty(), where, if a folio is still in the swap cache, ret is
set to MF_DELAYED and extra_pins is set to true.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Lisa Wang <wyihan@google.com>
---
 mm/memory-failure.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 37ea23489b75..c7a00c7be368 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1039,18 +1039,14 @@ static int me_pagecache_clean(struct page_state *ps, struct page *p)
 		goto out;
 	}
 
-	/*
-	 * The shmem page is kept in page cache instead of truncating
-	 * so is expected to have an extra refcount after error-handling.
-	 */
-	extra_pins = shmem_mapping(mapping);
-
 	/*
 	 * Truncation is a bit tricky. Enable it per file system for now.
 	 *
 	 * Open: to take i_rwsem or not for this? Right now we don't.
 	 */
 	ret = truncate_error_folio(folio, page_to_pfn(p), mapping);
+
+	extra_pins = ret == MF_DELAYED;
 	if (has_extra_refcount(ps, p, extra_pins))
 		ret = MF_FAILED;
 

-- 
2.55.0.1082.g2b9226bbc0-goog


