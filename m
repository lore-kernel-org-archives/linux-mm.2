Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64A45CD98F2
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 15:58:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC18E6B009E; Sun, 21 Jun 2026 11:57:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C10236B009F; Sun, 21 Jun 2026 11:57:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3BB06B00A0; Sun, 21 Jun 2026 11:57:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 743826B009E
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 11:57:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 38ED2120302
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:40 +0000 (UTC)
X-FDA: 84904375080.11.E68A7A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8A87240004
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eoUi32Eg;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782057458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eFwh7/bBrNQXMDavjXH4Q3alYmiXXZ8Rq6jleDMJWMs=;
	b=UHZCSfK7cNjp+sNK8JWoBhzH81eX0PEny97kvu9BNOg1HHdfVcQUaihkRn2LVSfBiqTJJ6
	dNxCZHegryioKve2roJslyPihukyvz4P81V3+Obji8vpYtNAaPPBGBgtJaMNVTqqlfswW+
	RDkOgn1KWUpILHlP5PLFCGdbOMaZS3o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782057458;
	b=e8Fs7+oViiEy3Tv8tW0itMwLBHQFMylSl8uvAzekBeO9xLrv6daxaQl9gBtHnADq9gxSco
	kXsRsAKM2a1nKjDl7fRyyGT8kFjRg2XbhhCwbRziSZ4fPFi1/sq6ZkiXsqsHu/jB/Kl14U
	cH+ydo0HhlgrQ0usfLcZdsCSZLgPg1o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eoUi32Eg;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F33844443A;
	Sun, 21 Jun 2026 15:57:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269001F000E9;
	Sun, 21 Jun 2026 15:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782057457;
	bh=eFwh7/bBrNQXMDavjXH4Q3alYmiXXZ8Rq6jleDMJWMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eoUi32EgTXBZFLXkIFq6RL6kNp0DN3OL8RjPyY0eQyPFaufLPOtBUYGxXxOuXwWNL
	 yph3MhvEiOTsRk409Kz7F8MOmFoSusttagpTKOEDYqPk4gVbeOuKQ+cD34bq9pXerD
	 POR6Wlhc4mhCMWe7Z588vIXmAdVf9rIiK8EwXZHa8oEjkHxLiYcqYrstAIc8vxFTLa
	 +sDfHVEAsIdT3xJZvgcdyiUdYDpMDp6A4/BIYCfFcNJ6iQo8+T8gMJCfCytnv0LHbN
	 OusyM2xcQLT1GbIVHYbXizjS04BqqazL+Y6TNTYWBYezA5u4m7KC/fnSc2a0LiYUrz
	 b+XQSABVlra7g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 10/17] mm/damon/tests/core-kunit: remove nr_accesses_bp setup and tests
Date: Sun, 21 Jun 2026 08:57:06 -0700
Message-ID: <20260621155715.87932-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260621155715.87932-1-sj@kernel.org>
References: <20260621155715.87932-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: axggs5kz76y8edcs8xoe7tj6uip5mbob
X-Rspamd-Queue-Id: 8A87240004
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1782057458-909179
X-HE-Meta: U2FsdGVkX18GEM+zVolO5k+7AiHLTpKwYBuiFJ6iOKsajN4Nle577IisER6Wn7nHkRXVNyBvSQf0Hh9cdRoYKYlcWXB1rTQj4ldc6UR9zYIDMJKtRxT7zb2vz1I8B5X5Nop8boenrRsUCOqc7p4LWrLgfiZh4JMS0vj5ffquuDJqoPoZywqybIucQKOMfwlWnWvwcBIvWxb2tgj8sk7GUjwRE6g40OifeIvjwWmUtkevHL7sFgtvHzUR44SO3K+b2Y+prIlV7B9V+z7qlksb6pkj1EDMZsneDEgSSXZjydK5C33XgnKc1KuNy2Aq3gXA5Z/tzZTKdUliXyywCLuuHFqnC4826h3owCWR7Y+uxz+IUQ7LrhnPj1PBGldKeaDSBPXrsw5pskvWkhXjEqI1z3M4WLKnepmM+xTnUEErEvpGLOf0P6AbGLPnubvPWT26Q8mRrcvtLm2o2pEWt0dtzB9jj62D1LS0Kw0Chy0QmPg2EWKMhcB/d7uM9kKqQ5phiZjD6W8ZEKBTQwpWX5rM21aeCMGDKmDAi8+/ghL/u0t3GcQAAomL3XqPGP7qEl7hGO/nQqEVH1umV3rA3Cni/AGLC4s6rO92jQ2snCp4YJ1GwI2lBVG5QdYUz2osxNbBRam3fxEKOS6bXf0m7+QnaJ6WIgwRKcib9QqaTIkX4Xcv+wxRDDG0HyFv7Kn6MxkhSl5MPkhcscy+5GTAL+oOR8N8nQETt0MIpvfzyPOrYaZt4REw5AORqQPCQIkysRo8elaaXokrgImT0muCgL3+AGPohbaUM408mqXHp84DsTeThnF0Aa4SdMA+ULdFB+LOen0P+4pR+s+Nkzd5qulfw62lEc/PeC8P7UZiRuVtwphmpCTBoBMR7MaD/J/v8P3OcQMy4vIrC6Y/EY5UcLTTQtbG8TBEnVh1KsKAkbIfC+u32TZnY69F9MqYqgwFs4bLFF90lHvIQaraCbnMI06
 Li5LEbhV
 OBWQvVy4Zn9tBCO2L3G0w3Jt/rJ4cwpDX1BT2qajzoBSKoQBp4E53IU8pBtQr3OIYlzq9L7RWYf2qchLcN5OEzb6NoD/VsxPGpMcUo/AD5m4pegMMoDFI6WTsu/b/TX+3DnZVEsWx+p+XmBQpJh1VsHHC2qxdxM5CWrvvpc/xH6Z96CNXUf5/eXGDxEVbZqwVp3n0ePaOL2L2Kh/xLOX95er0461i0yBHnV7lbqtMLls0EwW/Q2CjIrOR1K7L7A+veLtP7x4tgjZ6si4k/2/OBAaysQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON core unit tests set up nr_accesses_bp for representing realistic
damon_region, and also test the field.  nr_acceses_bp is no longer being
used for a real use case.  Remove the setup and tests.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index cdab14396250f..d1f019ab6fc25 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -118,7 +118,6 @@ static void damon_test_aggregate(struct kunit *test)
 				kunit_skip(test, "region alloc fail");
 			}
 			r->nr_accesses = accesses[it][ir];
-			r->nr_accesses_bp = accesses[it][ir] * 10000;
 			damon_add_region(r, t);
 		}
 		it++;
@@ -155,7 +154,6 @@ static void damon_test_split_at(struct kunit *test)
 		damon_free_target(t);
 		kunit_skip(test, "region alloc fail");
 	}
-	r->nr_accesses_bp = 420000;
 	r->nr_accesses = 42;
 	r->last_nr_accesses = 15;
 	r->age = 10;
@@ -168,7 +166,6 @@ static void damon_test_split_at(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, r_new->ar.start, 25ul);
 	KUNIT_EXPECT_EQ(test, r_new->ar.end, 100ul);
 
-	KUNIT_EXPECT_EQ(test, r->nr_accesses_bp, r_new->nr_accesses_bp);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, r_new->nr_accesses);
 	KUNIT_EXPECT_EQ(test, r->last_nr_accesses, r_new->last_nr_accesses);
 	KUNIT_EXPECT_EQ(test, r->age, r_new->age);
@@ -191,7 +188,6 @@ static void damon_test_merge_two(struct kunit *test)
 		kunit_skip(test, "region alloc fail");
 	}
 	r->nr_accesses = 10;
-	r->nr_accesses_bp = 100000;
 	r->age = 9;
 	damon_add_region(r, t);
 	r2 = damon_new_region(100, 300);
@@ -200,7 +196,6 @@ static void damon_test_merge_two(struct kunit *test)
 		kunit_skip(test, "second region alloc fail");
 	}
 	r2->nr_accesses = 20;
-	r2->nr_accesses_bp = 200000;
 	r2->age = 21;
 	damon_add_region(r2, t);
 
@@ -208,7 +203,6 @@ static void damon_test_merge_two(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 300ul);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, 16u);
-	KUNIT_EXPECT_EQ(test, r->nr_accesses_bp, 160000u);
 	KUNIT_EXPECT_EQ(test, r->age, 17u);
 
 	i = 0;
@@ -256,7 +250,6 @@ static void damon_test_merge_regions_of(struct kunit *test)
 			kunit_skip(test, "region alloc fail");
 		}
 		r->nr_accesses = nrs[i];
-		r->nr_accesses_bp = nrs[i] * 10000;
 		damon_add_region(r, t);
 	}
 
@@ -556,7 +549,6 @@ static void damon_test_update_monitoring_result(struct kunit *test)
 		kunit_skip(test, "region alloc fail");
 
 	r->nr_accesses = 15;
-	r->nr_accesses_bp = 150000;
 	r->age = 20;
 
 	new_attrs = (struct damon_attrs){
-- 
2.47.3

