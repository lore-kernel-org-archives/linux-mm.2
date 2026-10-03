Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 540CCCA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:21:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6B7C6B009F; Fri,  2 Oct 2026 20:21:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C43326B00A0; Fri,  2 Oct 2026 20:21:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B31EE6B00A1; Fri,  2 Oct 2026 20:21:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8499A6B009F
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:21:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0AA00A781B
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:40 +0000 (UTC)
X-FDA: 85279411560.06.59BD3C3
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf18.hostedemail.com (Postfix) with ESMTP id 507051C000B
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ed4y8Tez;
	spf=pass (imf18.hostedemail.com: domain of 3kErAagoKCIMq0ov1no0vunvvnsl.jvtspu14-ttr2hjr.vyn@flex--jthoughton.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3kErAagoKCIMq0ov1no0vunvvnsl.jvtspu14-ttr2hjr.vyn@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790986898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=93aW5kJ7TuXndYGEWNCSD+XJA7ltxFbIps3WQL+8iZc=;
	b=HQenhSJ6Eu0WC564yCr7dO393c2bR+KRqMME3qiJX1grDMWt0TRdD8lhxEHCc4hYqmYgBK
	6vwztXPnxSELB+rHltG48Dkm2v2aYME3a940dnbv2X7uVDydu4suwn8hth8IHMuSuywmdG
	n5dWcSSykva9gitMzUuql28adL9mmFM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ed4y8Tez;
	spf=pass (imf18.hostedemail.com: domain of 3kErAagoKCIMq0ov1no0vunvvnsl.jvtspu14-ttr2hjr.vyn@flex--jthoughton.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3kErAagoKCIMq0ov1no0vunvvnsl.jvtspu14-ttr2hjr.vyn@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790986898;
	b=PJFr5f1MLQLSOw+zbWBVHtQqDXazrXqoTh6f7JMJ7670pT/PqGgDLypF21wI30DKf59P5f
	SxCokhP91yBx5Cdv8vttLWvRU2pvJFCBaEMqgEszgR6KsBsnX+TN9zluKFqlBB6SQNyN1j
	in44Pfa50tVWczMRcPLazIanFUW5608=
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3a4a0017549so118893a91.3
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 17:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790986897; x=1791591697; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=93aW5kJ7TuXndYGEWNCSD+XJA7ltxFbIps3WQL+8iZc=;
        b=ed4y8TezZiD3KXgIuyr3LakcKpdsjTbGypLZ946md6/Ji+vLfpmI4py/kLRbgcAv/4
         GtukaodHwzbi3pIjUd3w8Lc2XVgPpggLBi0beTAzXjUUmIEisc9vDnmH+0ogDhm9FBZG
         PJgGZLXTKUsiM1q1DCV0HIkhuawA7Z99nHmYaobyc9UBBmC7R4YXKxDQkVO8ccTGh+rz
         S+bWDXY9Km6UWnkz+3ze7QdJJePkdxT2p7LsevY8doj24ZQeLw1fKQBvbS2ZGOErMK/9
         ZkcH3acBS66ekefBRRDlchUApkpFyYANOsKFcy/iUlPc8am8E7qyPtun5ZzQ57PxZfoY
         C8Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986897; x=1791591697;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=93aW5kJ7TuXndYGEWNCSD+XJA7ltxFbIps3WQL+8iZc=;
        b=i1fD17C5sBiCE0MDzFmJcLGoXcGb+S9G7oUBYiFllY0xhKoF9sh7TrK0wgX3RINKXz
         2qou615joeAvMLu8oDwpJMCk9f2SHBbcdXNWqnPWTytf5knEB9zkb42QHOuDnH+oJtfw
         CAot6rHPe7v4rSA/pkMYNXu0I0DXOyPD234iR0RuqJlJ9cB4wtwvPf/gGidtrGPfzE9i
         HF3z8Q05vfabdsqPx5KkbsjNZW0mn8dwM/lrP6YnNOZEjREEqv2aPYjorN/eta8LmqNB
         A2zZfD988VrAOQO/7LU2QHe/KZ9R3fOylC8+1R07Y9RrDyX2XvNuTPk0aUmtMR4pEO5d
         /vgg==
X-Forwarded-Encrypted: i=1; AKwUvBz6H12R8HuNZ9dNTJ+8hDxqIX3xRxQYW2HQ7kql7HUGoZgA3OpJZ46AuX3p39IjuflYY5gqpfuXAA==@kvack.org
X-Gm-Message-State: AFq9FYIjyAUN28uA5zdfW3e4SZOaZVIvO6zvDxZA+dwWUb/EKUKKDuDM
	lbhhGLkOgDGVagSOIEvFSfkMcA4Tn0TMrCSJ6bw35k0nnm3/M6fOB6N4RnZyX7nnmA1xREso2YQ
	c1ZCf5QmEMe2XJambq8NFvA==
X-Received: from pjbfh14.prod.google.com ([2002:a17:90b:34e:b0:3a0:6f00:2a50])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3d86:b0:39e:6c68:c77b with SMTP id 98e67ed59e1d1-3a6ce83b91emr4273665a91.49.1790986896998;
 Fri, 02 Oct 2026 17:21:36 -0700 (PDT)
Date: Sat,  3 Oct 2026 00:21:06 +0000
In-Reply-To: <20261003002123.505555-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20261003002123.505555-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003002123.505555-4-jthoughton@google.com>
Subject: [PATCH v2 03/20] hugetlb_vmemmap: Always flush TLB if needed upon PTE remapping
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 507051C000B
X-Stat-Signature: 19drf7x4pysetryoqomx6j1qwuz1j9j3
X-HE-Tag: 1790986898-285711
X-HE-Meta: U2FsdGVkX1/ziKhEBmbrPz90z0281BRfcP7zymolQa1e8oaCV3/fD+3LH5FCj2aFC+i4g2Wq7RdRzyotEnBdWKK/UZvn7GZPyVuvS0CYAcYjAiMNLAAlMtk9zH3JruVETZh+CaQ3TUHB+7iF6xhvC24hoJnMGgt4XQInl6UVj4ajmnWJVxM5XSddBbeyOmNFynXpZbuLPV9xrIGfaLgvHErH+ZROy4vrr+ikKEzgNVzIiGVYunP6IlHDYzmlYpLHcHH3TnJSvqdQnQXUmaxTL8iRG4baiJTrUwLwP0eB8/S3q0VWR0RVtL0GUxHNnCV88ZkdtxYRFzD7/nGJK/So7Zdk/JhxHSwFVXb/7K06Di8QfvX6hQuAVsW4UMwyWcN4+RyTCqHcDgV8OSnVzDEGILZ7Gc7wxNEejaD/98nWB0kSrx5KsIwy2I0rgExSIZWkqqmIfoEIgBbPTcpTNaRTvj8rvkBdxauWchRZSo/sDTQmmCBE1t0IcRHk2H+hiRkQt3RaAvlzDyYywHpKBJNKzm5YAMDRCWlGrA1cdYxajg53TS2Z7Z7urm+RvyF0rAxi6VswPx06nv2493MMdLP8cDivbNOm3jdFaIsyGDTxpT1Y+xKeEwddqIxuVvn4fROzBGIuyMQyixvyeWUlpE3XUj8A1T0nocu+5i6ko03lYqKP1dpudw57B7r7PzMUw6b0VKxlZjisDZ/KB5JCnXor2ss3b9yi6tSwupqAGRhDgEQl/Wf7qu2zsSqbN/S+O/K1woYeqVIjWyZo7rKSxCw0Y1vm4bF4FXHefsjz9rxGBipXxoQN3nlMkWOMfsQqPbgnTvt+4TjSKnkmw5i1o7hgJ9aw5njyX2us6LQEcJml4xNEpWPlDp2tU+Jr2qKF+NCS5ouzuAmth4InWIrYQYxHQSG/aqzkVEmBDyNIRsWG0olwouoSTOjR1mXiL40+Xcm1g4IViV8/OuBYpudSAKw
 AyM/5qKD
 hztUhp+qRPf8R4p3NWcPcQFwbyyntgjcJ8IXubPTGUsbt0E9eh4gtBezl9crRRVZk4Cxhiiq6Ee2wvxsH2R/SH6qSXV2BYh7j6BAP8oJRUmABq+74QOMzsv8loG3GWJn+H+eadkWL5WYKCON9syGrWQYImD/Ib6lcX1CAFuK3K5r2fhJ42od9OUW85k2YQZDFhwzdjOhsWljbDj1BBfNTww1qEWysXmHJoAZz6sfYdJtU9j4s8TYBaqkgMZlz79ZxnP9v90fKX3M55mrC0myu+KWUI3fy170nVfsS6SOlm8WO8MyiHIPJw5MSz6dbkmEmEIunOi7CIHwnNwWLdzv500pl4zJEoYo2kJkmz9/Mc5ftCx41LdSsSUZUOHkq4cM2B/Bp8NCWJLdjnx65p7MCyyTj6zyaLwIAQZzCzefQOaWEoZqW+Tp3eOm6zDLfaukCcr/hKD/GtfgS39gpLx3H82IXR7OStLeuPOyk/WcCyfXkAbVrnRNCVbCDPqBs74M5mYzbfQTd+miEAO2NTivNawZlS3VMlcnkFdhVhRuOJ6Nxkqup1oiAys+BV9/M1L8tqOdHzkhONrmVzskXAV8zaSwcFrabRYEZT5WogG3HqjsOBIrR0Oldum+Bj8vrG+Hz8SRaatIEH4I3nUNzmuiDvvc/jg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmemmap_remap_range() can potentially leave the vmemmap in a partially
optimized state. In this case, a TLB flush should be done if the walk
caller asked for it, even if the optimization was not fully applied.

A follow-up patch will more completely deal with partially-optimized
folios.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 mm/hugetlb_vmemmap.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 0057fa2a16a8..1a2645c382ba 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -163,13 +163,11 @@ static int vmemmap_remap_range(unsigned long start, unsigned long end,
 	ret = walk_kernel_page_table_range(start, end, &vmemmap_remap_ops,
 				    NULL, walk);
 	mmap_read_unlock(&init_mm);
-	if (ret)
-		return ret;
 
 	if (walk->remap_pte && !(walk->flags & VMEMMAP_REMAP_NO_TLB_FLUSH))
 		flush_tlb_kernel_range(start, end);
 
-	return 0;
+	return ret;
 }
 
 /*
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


