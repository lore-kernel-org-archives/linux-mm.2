Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 067F8CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 21:29:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7765A8E0006; Thu,  6 Nov 2025 16:29:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EE248E0002; Thu,  6 Nov 2025 16:29:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32EB28E0006; Thu,  6 Nov 2025 16:29:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1397C8E0005
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:29:24 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CD1D8C022A
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:29:23 +0000 (UTC)
X-FDA: 84081473406.24.07FB56D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 19927A000C
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:29:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SwqjyRU4;
	spf=pass (imf15.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762464562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zUO+xVShs8OiZifdHLWjxbQxTWazvLbIeIkNNKtnLDQ=;
	b=RYHIG59zpkG2ED+yVgf+kVn+NNJNTNa9OxTT9KvgGLNt18pQRjTIDgMNR8gKSiTgqdpL1f
	3JI0l91SGAkaQqHTrSsfM8DqJqegvqjLcz1TaYo8PEfjVX0l0t+NjIDd6rt5xJ6aN/sDDg
	HCt5gPBbs9P1gAUr9ODGIBqZqHMJDX4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SwqjyRU4;
	spf=pass (imf15.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762464562; a=rsa-sha256;
	cv=none;
	b=ssT+VOSc1l7gjSuXVBcQl8FORHPh78bkmtMbheoE5Xoq3w3n/1LcoAIcS+reWjqKAv/TCl
	zsOoa9VEvJlOuwp2Q+403nSH233TwcDlab6zKRxpTIV7unfShxn6e4dUUSJDGQppmVee4Z
	zIiNdl8gaEVtEQjKo7/rJ4kd+Wy5ooY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762464561;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zUO+xVShs8OiZifdHLWjxbQxTWazvLbIeIkNNKtnLDQ=;
	b=SwqjyRU4lB0wCEDGgjeFnlie1wEpIBmYUo1PJqwfMQPBi2OR29C0YLIm24PuSPNSBEa6H2
	xUhPKI+t0eBrBdN0IHPJ0WTk5nU5sq6Txz83aOwuxyzK5l5+eM/FUIW60uioKZlTVjtZkb
	tOXY4Ue6csM6yLSv2ft600R/i0bzWSk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-184-5_-hiZhPM0Ofg5aLSYqB9Q-1; Thu,
 06 Nov 2025 16:29:20 -0500
X-MC-Unique: 5_-hiZhPM0Ofg5aLSYqB9Q-1
X-Mimecast-MFC-AGG-ID: 5_-hiZhPM0Ofg5aLSYqB9Q_1762464558
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B988A1956094;
	Thu,  6 Nov 2025 21:29:17 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.65.101])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C160519560B2;
	Thu,  6 Nov 2025 21:29:16 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: david@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [RFC 02/10] mm: introduce pgtable_has_pmd_leaves()
Date: Thu,  6 Nov 2025 16:28:49 -0500
Message-ID: <50fc95b4c806eb4bfcdb578f2ce8d634faf93d57.1762464515.git.luizcap@redhat.com>
In-Reply-To: <cover.1762464515.git.luizcap@redhat.com>
References: <cover.1762464515.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 19927A000C
X-Stat-Signature: ne7iiwi7rrb3nkfzaiong5diighoz5zm
X-Rspam-User: 
X-HE-Tag: 1762464561-542127
X-HE-Meta: U2FsdGVkX1/STUSekrpjl3OVqzyeFOBrPagOpAGHM6g1ZOy+HmxaMMk034SHzLxaWWAcDufQK5vU494VarpQ1sVj7d3+bQkmRhCYuucgBAq0gRstj8vp5Kv7F9EQ+VRy39iXVtIOamExBrevXV4XCv9/NOCweLPPTA8DxeHCn7FHBDrLly3odlkRandjV1Ti2lPL+RnKO2TBsN3hNBzy6TKqpJrW34V0Noc5AcK3N/x5bf+PDmZGwkVvOaG0YnyksEk0adtusuoEF/umuPKNMhH/eGdpcX55jj0SFeMo0wIsbk4XW6kCJMuQXY/Koqsq6lkJSuSy2eY7GLpPBylozhP6DUjF7Cf8fPzxLz9N2Itnjaa8fvqyN27elSblxlxxFi7wEcx3+V30OvyDz/FhP2+ZP0jvcEkpWc6JOUKxleyAlmWLOQe0y3W4+lh5LrCEnJ8Rc40HHxgpmGAWYLlvDY7OnVWJqz/BZqotSttzbs1WKpxMjzsgfnGHTWltuFOagZyC3qddTwhD8MZ1Oh3lNyh5Lq/tFTcPO5S+EDSpQkD1h1pJ9ZhshKEEUt/pWwU8lgj1C/PPHqsur24HV88aSPfuYT6F3+MPTrF4wIKJAaxh8gsz5BpUOq6cS+MlpZWDVg1wW0U4aKE0W1JgCW36ZMnHQN2UpelwAVI09N01MXuO4WCQZ26X0kdmjFBjjQe7sEY1MkuX/QbK4HcLy0BNL8VED0/zl5fWZmlcdqBGGCYhq628KdXLGSFlMCL22KNSIdYQG0no8hxdABXaRXJtC6y24Fug0eU32g40TeMkYbBJ94FDbY9EnJ0W02ALHs8nwZq6tD7FkoMJqubFITnT8CB6hOqxApWPB4OTvC/ibX1xmJgpjA0H7P0Rzi7QuN/bdHtbl9M+ZsGFJloloWcmRdwT4DmyfGtjz5m+KEZd+5dovv8jEDERoQ7+jGfhCTVPz1CXvqKQW93cx+janow
 DWVKSNuS
 xWRVJj1aqClTJnmk3PAjYoUaBdQ4Ut8AeIyMk/kdN4TFk7yCajHEKINLMBBDza5AvJ5zOYw84Et+fe/SkB90UG7U2HWcOefw35eSKU6zu2ja9RhnTVT400r8t1QF3UKKGHB6QaJ09H0XefVdhc1+rWpPnJrBtwrc0zfueygYL7Af19WjZe5ayShZcFSZ2ls9j4olIPxa9Ck41vax+WaRXuFd2mBgj7uBfKKyRlWS96v9Z2rGcIreoULwIUGlHjPmUdDxyBxuP5GVkfNSO0+l/q1nEYzcO9bo02DJqTOdVCz7XIlAAiTuGEI1N/XB8d3Jd6kxv7e4cPUFjfFi2KPNraxmSBuA4ZalQSqoHdoGsJmG0rYMe7erHqDEEApiSyJJsvBt9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a new helper which can be used to check if the architecture
supports PMD-sized pages. It's intended to replace two existing helpers:

- has_transparent_hugepages(): it's used to check for PMD-sized pages
  (not exactly THP support), but it may perform a hardware check so it's
  not intended to be used in fast paths

- thp_disabled_by_hw(): also checks for PMD-sized pages support, but
  uses a cached value

pgtable_has_pmd_leaves() implementation is split in two parts:

1. init_arch_has_pmd_leaves(): runs at boottime as early_initcall as a
   wrapper to has_transparent_hugepages(). The result is cached

2. pgtable_has_pmd_leaves(): just returns the cached value

The next commits will convert users of both has_transparent_hugepages()
and thp_disabled_by_hw() to pgtable_has_pmd_leaves().

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 include/linux/pgtable.h | 10 ++++++++++
 mm/memory.c             | 10 ++++++++++
 2 files changed, 20 insertions(+)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 32e8457ad535..e4c5f70b0a01 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2001,6 +2001,16 @@ static inline const char *pgtable_level_to_str(enum pgtable_level level)
 	}
 }
 
+/*
+ * IMPORTANT: pgtable_has_pmd_leaves() can only be called after
+ * early_initcall, since that's when __arch_has_pmd_leaves is set
+ */
+extern bool __arch_has_pmd_leaves;
+static inline bool pgtable_has_pmd_leaves(void)
+{
+	return __arch_has_pmd_leaves;
+}
+
 #endif /* !__ASSEMBLY__ */
 
 #if !defined(MAX_POSSIBLE_PHYSMEM_BITS) && !defined(CONFIG_64BIT)
diff --git a/mm/memory.c b/mm/memory.c
index 74b45e258323..7b50f3ec9b37 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -176,6 +176,16 @@ static int __init init_zero_pfn(void)
 }
 early_initcall(init_zero_pfn);
 
+bool __arch_has_pmd_leaves __read_mostly;
+EXPORT_SYMBOL(__arch_has_pmd_leaves);
+
+static int __init init_arch_has_pmd_leaves(void)
+{
+	__arch_has_pmd_leaves = has_transparent_hugepage();
+	return 0;
+}
+early_initcall(init_arch_has_pmd_leaves);
+
 void mm_trace_rss_stat(struct mm_struct *mm, int member)
 {
 	trace_rss_stat(mm, member);
-- 
2.51.1


