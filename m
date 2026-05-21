Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60E81CD5BAF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:34:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8C746B00C1; Thu, 21 May 2026 10:34:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B16466B00C2; Thu, 21 May 2026 10:34:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9905C6B00C3; Thu, 21 May 2026 10:34:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7A3C86B00C1
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:34:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 35C98120665
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:41 +0000 (UTC)
X-FDA: 84791673162.03.F06B7BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9CCBEA000B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ln2jHlAr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779374079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7YG6GjDiTDF7+hhcDJxfKB/57kZkbDeh0ESzV1mlaFU=;
	b=yC/jE27apei9ZyYbe8CRqrqrJbcK9ugPjAyLrGjgtAXOOuUrDnCe9f54ka2aQZw56RA6am
	4wAbumWO1RUBZE41L6t3fRnHksyvYfaPbRdvaSEbuy55fRc114UJVzq8kbOkWT5u6j6Jm4
	qeFbHvQ1xoLbJvL66vBUF93WECy0Stg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779374079; a=rsa-sha256;
	cv=none;
	b=NkNQrDBQXm9CescZmpJxOvxEUD3wH0yuFCYH+of4LX0Fx7X5A1vnIO+XK8bAw0Q5sgB0BO
	QmmKhQj6tmShCYEqS6I6K4xCDLBR1xcjmHGcBKg9HlfKOfwhKjp9wd5XZImkU+5bLiGSEr
	3rkHKlx12TYwNMRcg5pYgkxrGaAerd4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ln2jHlAr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3864160210;
	Thu, 21 May 2026 14:34:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D8981F00A3F;
	Thu, 21 May 2026 14:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779374078;
	bh=7YG6GjDiTDF7+hhcDJxfKB/57kZkbDeh0ESzV1mlaFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ln2jHlAr4jbvgui7gZ1N521h/uXjENEZDiuJzweT8xNGaj/u8J8BQMiQcDOiNCDyz
	 KEBnafI/4+P6m+qldnu7G2ah71+fkRmLzz2A3/PPDNSAJ6JwcLjd/MpfDMoY9AwMyi
	 ngtmvFOlAZ+b4lnGDaPp5R9eU/FJQmm5aUvuyDHKkGN2+p/+3a9SHmIbl1/spRvL4k
	 BfUgZ6JPZZpAe+1Q7chPmvULUqca4KDkYnWCsl38aLBG4z3qhgkXwcGKfKoI99m1si
	 Me0m9R6UJueK0iK/77Zwu8v2AKhrjrbFSkJCSOMVIhcVlPcLEuHFWtpp5m/+dkuans
	 s4FVf/cu4lCzQ==
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
Subject: [RFC PATCH v1.2 04/14] mm/damon/tests/vaddr-kunit: replace damon_add_region() with damon_set_regions()
Date: Thu, 21 May 2026 07:34:14 -0700
Message-ID: <20260521143428.83157-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521143428.83157-1-sj@kernel.org>
References: <20260521143428.83157-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9CCBEA000B
X-Rspamd-Server: rspam04
X-Stat-Signature: krxwa5u67u9r154zrjhehiuoic9n6o78
X-HE-Tag: 1779374079-91106
X-HE-Meta: U2FsdGVkX182T1gw1qxwnjnBAagX9ZEqkZHJZwKWpYKWrmtPM2UROjegAa1oYAmJeuAM0zJsktJuLz4xbQAQKUiWhehNmqy4KKuBdxLQgyeFueU+X4YUao+hh9pJLqigJ4ccmezQxq3lXbgVunbYGWR52Qi4u3pt1e49mxC+6oQ7S/UoPh3iPohv94ZM47ah1Xvz/XeU+/AC5k8pR078CmlpaP8egPRq2UyTB8HCEJqZPaVFLZDz38+en3FhCE3MvRWmhA71zBVrCnhqtsstx/XMdCZ3zUcK2qM7stxRKUQ6FGyO4McXieumoDRbPngt5K5vlDpEce+sqFu5Gob2KVX3qz2dkCO4LoZ7N7+t7EV9Xv+9adr8d09J8U/rS5cchpEe2vb40H0bbYuy8qrBfSR3LrgLdjNPq/ZMkyxnXdlv7kIa2hKq/VBu/YL94Vay6qfRWfvcZZigSNeXL04rgN7m9Wj3jsRcKNp/qXd93SL4SM2xs9zch3+tPn26Lsn1CexNJUEeJ6iTacIhYtCmZ5r5xHAxoGaKeqX1E14Le7N6iTb6Zj7MUIslRZ6qPn219/Q0mtLp+lthF20i+pWLt+czcaPYLogci3FyCx4laprjXdo0WxhW4ZLJXDZe2bJcVFCKHjgy2CjrMgO3eno9MAzmABz0mnqPrBFYeeD+rip7B/UiPxwKpwtWeenYIe25GkoCMrZensT22xmXRNhHb9kUfZ2vd+bp4MyHH+w/z2bB0Fe6MmgSmveXqwns3s387ewDUnsHvAGAorwqJzNNcN4Y+Um5QB3FfAcjTXVa/emSRtjCGTnaZNdEGv19+EpWZftPxH9vp7dWuhyyjZJI2k/j/OvZh3vWdxU6Q3TL1rL++QT4Vgemez6SfOYXhj/kWUCQM6ie2JQ0Y6paAE661qqlAm3o9nsZ/ezoZy/N5/xfQnShhEh9VufUIS0iCYze2PXjOJW9ojI4UezQbwU
 fX9LGHSX
 VMsHXjRjRBndzBqdgWW9kqFKMzFnx3162h+i698rsECdS0wiZKlxtNZDCZrcn+W4vXqh6rvosZ+GIkU2QoOLD/PmXFiLEaTphbotEokrQuy7wQvE4C7JSe/E3WUd5PkYJe1JvePqPIvMbUzhDaizgrHddvW3ssgQJFTqCLrhChtFdW2jACvF8hryXC+1kFJREHT0gBrfhoEephIUm5tT4i7XO8cHeMEbaYXDlgCiNOuArp+Rxq+G1TsQHBN+axgpK+3SyjdeF/jJz3/xN9116XlUfqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON virtual address operation set (vaddr) unit tests is using
damon_add_region() for setup of DAMON monitoring target region
boundaries setup.  But, damon_set_regions() is designed for exactly the
purpose.  All other DAMON API callers use the function for the purpose.
Replace damon_add_region() usage in the unit tests with
damon_set_regions(), for unifying the use case and reducing the
maintenance cost.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/vaddr-kunit.h | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/mm/damon/tests/vaddr-kunit.h b/mm/damon/tests/vaddr-kunit.h
index 98e734d77d517..563fbc7e3f448 100644
--- a/mm/damon/tests/vaddr-kunit.h
+++ b/mm/damon/tests/vaddr-kunit.h
@@ -132,22 +132,35 @@ static void damon_do_test_apply_three_regions(struct kunit *test,
 				unsigned long *expected, int nr_expected)
 {
 	struct damon_target *t;
+	struct damon_addr_range *ranges;
 	struct damon_region *r;
 	int i;
 
 	t = damon_new_target();
 	if (!t)
 		kunit_skip(test, "target alloc fail");
+
+	ranges = kmalloc_array(nr_regions / 2, sizeof(*ranges), GFP_KERNEL);
+	if (!ranges) {
+		damon_destroy_target(t, NULL);
+		kunit_skip(test, "ranges alloc fail");
+	}
 	for (i = 0; i < nr_regions / 2; i++) {
-		r = damon_new_region(regions[i * 2], regions[i * 2 + 1]);
-		if (!r) {
-			damon_destroy_target(t, NULL);
-			kunit_skip(test, "region alloc fail");
-		}
-		damon_add_region(r, t);
+		ranges[i].start = regions[i * 2];
+		ranges[i].end = regions[i * 2 + 1];
 	}
+	if (damon_set_regions(t, ranges, nr_regions / 2,
+				DAMON_MIN_REGION_SZ)) {
+		kfree(ranges);
+		damon_destroy_target(t, NULL);
+		kunit_skip(test, "damon_set_regions() fail");
+	}
+	kfree(ranges);
 
-	damon_set_regions(t, three_regions, 3, DAMON_MIN_REGION_SZ);
+	if (damon_set_regions(t, three_regions, 3, DAMON_MIN_REGION_SZ)) {
+		damon_destroy_target(t, NULL);
+		kunit_skip(test, "second damon_set_regions() fail");
+	}
 
 	for (i = 0; i < nr_expected / 2; i++) {
 		r = __nth_region_of(t, i);
-- 
2.47.3

