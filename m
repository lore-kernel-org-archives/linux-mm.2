Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D58ACD4F3D
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 00:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 164F76B0098; Thu, 14 May 2026 20:44:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09D866B0095; Thu, 14 May 2026 20:44:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E814F6B0098; Thu, 14 May 2026 20:44:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C9B896B0093
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:44:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6D0981C0657
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:50 +0000 (UTC)
X-FDA: 84767809140.21.F79C44B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id BF4782000C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="eJy8/cVJ";
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778805888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gyLpV3WgKI+P7PQhppjz5FJDwACfkONuuHvvz3bhj30=;
	b=m8s5kZQ2l0K0EOPzeBdreZAitz7YhAL9gXV1ZMo8JcfK5mR+++CmI9p7YOG1GZnCHfwdrM
	BaUFeqFx+4Y9ZP+ftY7hF2NcHIYp5oRCBbUMtB5DP0NhvnfBiRjmQaguOeh36A2zcsOMZo
	KkoxPmWXX42Ya6HyOuIHbV5gHhl6E5I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778805888; a=rsa-sha256;
	cv=none;
	b=RE7+Hai2k4e4HWYaNzg+4+txNy/O3EFY1zSBCuj+0b3rcCXmNrHHZ1gQlmmbZZHxn+euTq
	pMHkxW3quGO/bAq2NCH0WEgEdS8/O9Oc1vsnUHBh/mZB1zDGDcHAX4HofvQKTH71AvzDZ3
	icxZa30aXhW4Iyt8oc2odwho3z4IyIM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="eJy8/cVJ";
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BC84543A70;
	Fri, 15 May 2026 00:44:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F6FC2BCC9;
	Fri, 15 May 2026 00:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778805887;
	bh=nUMg5BO3GWRW+rFzmCKpLHBjk9zjtVe3/poBms+RH3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eJy8/cVJ81Ae+2eCoSi4N8ohqYC0QqIvbbjba8mrFJOd/qQkvPhB4yjhvbIwjqbhw
	 UCheQXHCUszPehMT6MEus2ROhKegttMtt/GHOEqMmRsEVVepNcVOelR8fRxJlo8alI
	 zLi+heVms3v8nv0gnstcOKjaIDDEHeYkUeEfcvjpdh0QviJxJmy3anIhXhDULEN7en
	 W6/vEXumqA1yiJyAH9k0Cr5KmM+h73tGLjLQtG5W7KKrj8Ra11FWfQJA9e5IZWKacs
	 oB/rSPWu97y/lKHb+dJJqFovmqzkP5fkYSXxESmlGXjx+W2KmSEFSskTYrndslnW6n
	 sMbIwpOvcWszg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 05/28] mm/damon/core: introduce damon_region->probe_hits
Date: Thu, 14 May 2026 17:44:06 -0700
Message-ID: <20260515004433.128933-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515004433.128933-1-sj@kernel.org>
References: <20260515004433.128933-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BF4782000C
X-Stat-Signature: 5c6jyopttzidux55mgyghpu7cay4cckg
X-Rspam-User: 
X-HE-Tag: 1778805888-832816
X-HE-Meta: U2FsdGVkX1+FzM3ltsVilgd3ExsP3I/IdrY0HPWhToTnuL9an1L6Md+no6oLFzG3rZmiiqt8aiS6mVkG50niBWmHRmeD4j/VbemUrUIB9eMj06MRuRGYnKbE4FHI7etyIKvMT2wjKiXPpb6H3xoFuwXEuTFl4yK+mk0B5V1BWYpfJM19TjbfmeOlS0JRGdRu+SCtyNV+px0ILZVKKdXGS53eCr2kqG580Vyjq0Rcsqp45gQG5t5lwzL4Z1DXKcpSwtOaPk7xe+NXs6hzi1V0AUds8tLXrgsUuApcPv7CHauDJcgTwrkIWmvmxhX1EZboU2cxd4jfWra+LRIrdlW1ZOLU+fZ8BnmOKucgfrHYl+TeSWIIr3yvwVeasVqTfWi3z0Sh8V8NmwEgdNDGf75LoAixOoJBIF/RPXLuZAsd6gt+zD8rPr2HAS/Ot2VK4ppzqzaGHonil5RyJM8gdWoeq/MhDov9LPTv8RHJFK3q/RYUeDRhpqYoPLcdITOCPeAxg/RvQrNzpgRHq8mwjY2f+WPGsHZ8SrHoR80A3WVwOBIwjcJNR7kSlE6d25J2QFwWFRfVwQ1s+xQC800iG4XCj5yJTjIbJEf1Yu7kU1BYVSj6u71ize5TxAK+oijsxdvOW3ZKEX1nSfIdSUltO1wjlGevyTJQ7H59DpPC9zSwljnXulQx7fkYRoWwsLkgbC8QBH1qIBtDDusBALdfBnQA/sLr+7s884RfQfJ94P+xpEkx6tt8UD7rOTD7pWob6hyiaKMMnHRSfvXsH+exXjPf5iPYKGwwi31M+Ub8jVzcdJo4U1qyl8llNlFZkxsZZwVwzRrN8ZBoSY/1KgRIFvsLuOwI3Csg68nvekZxqIUJVfenMD3IYKiFBECVLT4SeomPoHfPamdOxXKQIKymjdJxDUKmQaSBTQoFF/mGnfZUibcx4AHxUlF+DES+mjX30ULqjM+NjzGQkq3n3uiAOX+
 Da78cUhy
 nXmY2crsNJVuaV8nD1IXWomcOKgiaOggzHYEOjXYM055Qu4xHQGufLgivvdpRIxVJmiCk7UJtHi/gIH5LlR/Fl2NeIQo8G77sKUoPjas0cHWc/4iaM/rwTWnNbj0D9vauAZSDIxz+682tjgu+DyNqwUQZdrDLK/nP+hXK/xoWSHsEA9nFYiQsrBIt+vyILJwzD1SRGlvkGD8Bp9U3aVEZRgn7LQrTcQELM3A37dRZ43Cd9Emex7Pm+tSfl/Gs1oApEzXPCuGS5xQzkhHda9kdO/GCvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an array for the per-region per-probe positive samples count.  For
simple and efficient implementation, add a limit to the number of data
probes and set the array to support only the limited number of counters.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 4 ++++
 mm/damon/core.c       | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 9c2576f103767..bf78ad849a9be 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -16,6 +16,8 @@
 
 /* Minimal region size.  Every damon_region is aligned by this. */
 #define DAMON_MIN_REGION_SZ	PAGE_SIZE
+/* Maximum number of monitoring probes. */
+#define DAMON_MAX_PROBES	(4)
 /* Max priority score for DAMON-based operation schemes */
 #define DAMOS_MAX_SCORE		(99)
 
@@ -52,6 +54,7 @@ struct damon_size_range {
  * @nr_accesses:	Access frequency of this region.
  * @nr_accesses_bp:	@nr_accesses in basis point (0.01%) that updated for
  *			each sampling interval.
+ * @probe_hits:		Number of probe-positive region samples.
  * @list:		List head for siblings.
  * @age:		Age of this region.
  *
@@ -80,6 +83,7 @@ struct damon_region {
 	unsigned long sampling_addr;
 	unsigned int nr_accesses;
 	unsigned int nr_accesses_bp;
+	unsigned char probe_hits[DAMON_MAX_PROBES];
 	struct list_head list;
 
 	unsigned int age;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 15f2795a1156f..f6b4beb4b8ecd 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -225,6 +225,7 @@ static void damon_verify_new_region(unsigned long start, unsigned long end)
 struct damon_region *damon_new_region(unsigned long start, unsigned long end)
 {
 	struct damon_region *region;
+	int i;
 
 	damon_verify_new_region(start, end);
 	region = kmem_cache_alloc(damon_region_cache, GFP_KERNEL);
@@ -235,6 +236,8 @@ struct damon_region *damon_new_region(unsigned long start, unsigned long end)
 	region->ar.end = end;
 	region->nr_accesses = 0;
 	region->nr_accesses_bp = 0;
+	for (i = 0; i < DAMON_MAX_PROBES; i++)
+		region->probe_hits[i] = 0;
 	INIT_LIST_HEAD(&region->list);
 
 	region->age = 0;
-- 
2.47.3

