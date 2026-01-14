Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99E83D38FEB
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 16:43:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11C4B6B008A; Wed, 14 Jan 2026 11:43:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C2496B008C; Wed, 14 Jan 2026 11:43:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2D4F6B0092; Wed, 14 Jan 2026 11:43:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CB61D6B008A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:43:34 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 56E70580AA
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:43:34 +0000 (UTC)
X-FDA: 84331140348.07.86C64D3
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf02.hostedemail.com (Postfix) with ESMTP id 914D280014
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:43:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bBgUSipW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 3s8dnaQgKCDQiceijQVQWeeWbU.SecbYdkn-ccalQSa.ehW@flex--smostafa.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3s8dnaQgKCDQiceijQVQWeeWbU.SecbYdkn-ccalQSa.ehW@flex--smostafa.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768409012; a=rsa-sha256;
	cv=none;
	b=F+unLEXaywB8+veDSzWus31ebiwgfE+ZPiSR6W9lrvsf+i+wesV6Rdt7VP0LSYC9ulfhQz
	JUww3NKv9oFWW2cine7H8vDFDz8Fqp3cIsvLBMrDyb2KRHeoU79u5/kys8XeXnt6/Tiw0t
	1HBOloQARyWKawMyMhftG6AYCO8P7xw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bBgUSipW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 3s8dnaQgKCDQiceijQVQWeeWbU.SecbYdkn-ccalQSa.ehW@flex--smostafa.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3s8dnaQgKCDQiceijQVQWeeWbU.SecbYdkn-ccalQSa.ehW@flex--smostafa.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768409012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NagltRQpX2SlKWY3/YB/PdnajjFmvEiNKHSf6/veCZ0=;
	b=Vbwu26h93oWkfmJgACfvoR9MP6he3HF3tOe5Gcoz152vDNLHZYemleI+aPezqPg7GmOnqx
	bml+da70SkofVr57gr1gvl11v9bpaI2szd7L+lxVQSETTxatOeIGqbyCcK/YQHkWip9uUa
	l6YdO5RHmcJTAM3KtmKHor6+D6LVwBI=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47ee868f5adso387755e9.0
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:43:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768409011; x=1769013811; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NagltRQpX2SlKWY3/YB/PdnajjFmvEiNKHSf6/veCZ0=;
        b=bBgUSipWseUz7z6fDaw7Awz1r/bW2DWwBu8KBv7KUkk5f5YkeMhEUFCA6FMgZQ/I4i
         x16XCLRJns1hAD8Z93Kl1vms0eypjXT9pwizVcZWag1RCNHIr4Eq6scx7jhClUiS8eni
         /jUKmunrbo1g8emsubRkhHy1WJar9VXhiwmrrX5Xt6koO4T6zFtS5aLvvh0ty8kvc/kF
         TIWPbkyEGoG8X3jyJba5XjuwyStZ9TLlEe+ld7sOGYZkrjOmEun57DB6EyC6mnSwZUDe
         GMX8Cz0UfQ120e+7sxEBuJ8A+4itaPyMJtfVu0TWFE8gkho1gtEitk8FEcIouWqt4RH4
         cR3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768409011; x=1769013811;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NagltRQpX2SlKWY3/YB/PdnajjFmvEiNKHSf6/veCZ0=;
        b=f28trd2K94LXHOXFHItDSehqIvW+3KspXSF3RNkjjy2ZrSgwXwKBb02YT5I5BV/fSI
         oQs48a8PbOnNQMjUBBq5BYBiP4ouGZw5n3U1FpiibzyIueU1MUaVTZwZtIB2VTN8EoXh
         1SaDCtI3snLGisw5w8MwrE6YeGt/bidCGM5bT4oUK01N2LF5IeucxEE7fD6cadspzTOj
         e+p0yV3XeaQ3ZmYYxet/4S96X8Jpt4E4tYyDdz31q7jCbBYMVlWHNNSusekny6z4NePt
         g8TRk9mUT0eJhREJNGQXBbihf5ouoLADMY+1dhoHHkNpXUMBI2tWZqYq6MGxvWjovzjK
         6Tlw==
X-Gm-Message-State: AOJu0YwuIeF2ND4TjIOIfqlGIbVdobGv2hMQNzRTkVFD5oFH42+na2Aw
	N45vdc/KKjSePK2uM9llnPZfSh4fX3Ey4gCZdIha29zF+raW4HlGUIZs6Nh35JaDtG2phpTbv15
	iw6X/1tL3NTFuzdzHf1OdtBvSWS9R05DrEsfE7Ay2QEK9yQTvkcbD218HNrLf415LyYy2YbiaDX
	2bBtNPcF7yT8y7IHqw+EJT2MMjtnHKlXc6zxwvDRJTtQ==
X-Received: from wmbd23.prod.google.com ([2002:a05:600c:58d7:b0:477:9654:b44c])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8707:b0:477:7f4a:44b4 with SMTP id 5b1f17b1804b1-47ee33192c2mr42786345e9.1.1768409011069;
 Wed, 14 Jan 2026 08:43:31 -0800 (PST)
Date: Wed, 14 Jan 2026 16:43:18 +0000
In-Reply-To: <20260114164322.787125-1-smostafa@google.com>
Mime-Version: 1.0
References: <20260114164322.787125-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260114164322.787125-2-smostafa@google.com>
Subject: [PATCH v7 1/5] mm/page_ext: Add page_ext_get_phys()
From: Mostafa Saleh <smostafa@google.com>
To: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	xiaqinxin@huawei.com, baolu.lu@linux.intel.com, rdunlap@infradead.org, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 914D280014
X-Rspamd-Server: rspam06
X-Stat-Signature: 7dg59zrtd1e9jy9bb7ep9gnurpbcici9
X-Rspam-User: 
X-HE-Tag: 1768409012-133572
X-HE-Meta: U2FsdGVkX1/XtVyrZ97kxE6cjubMARz5oLHRqwDmDNKvWYgfrLOTwHLU/RX5CLYXvIYqYDC8Mjh4JDXYzyoDB1p5LUsP5Hz2opthpIuX6k/W6jvA9cZ4aHTeca9PiJnU+VbOgvFmMl6E0KfIOwJIZkbw4XBiXbGNEN+LpmcBm7qw7yEx4z+a3RB8oyhCrU6JR8R3acN/7QN0LHc1NrK3ql3CzVLTfO5UfqLcHeHWxe2rhrUACQTpVXis+TOwxRa/q4FcaAEhJNWd9eZetASX8PucgtTg9rAapiQ/V2Rb6B4jEcOjdc6HorY7WnvoO/X1jjnKuSUGloLh72QNJdzK12tXAro93AjOmUB+ud9cNou4zxuA7kmAvjNtU4vRQt348elcZLEv0IFZ0bNxcZzbGxKYPPYZkwJGzp++giv7nzxVnUUk0fxXsRbvERHO0hbYQ6qRdKGVMS30pHO0pLKPXDmyW4GL70Pl2z5D+NvVzXoatLZWpzg6Aef0FSWOYISTbRfiK7YI4F5RSuZL0i0x6c16uZz/xulVxz2UYG9mVq+ktZOMlaSitxD//67uZFe3x3ULsFP+UD5GZhBqepFLOW8RbaAvz/IP1pCvKCJUkv/EFLotoJQAuuH3bFAr7u/hugBnNyfDcmJdrZMiMA4d2wuokEUSmMrkSwWIe75f0hElljtBi/70E7EWs7wmyUoBkwqF6Ax1NMHLOxmGfDENBNJrGxV6W/4LK4ZWd2dscMJFPEM0EbW/KazDxrwr9TZlfrdPVgPiAesWKng8pT+QUNrfNde4zktlIOnfCaIdDTSwbUhUn8/127QM2tTqts/yux43Y7n2F2xEr24TtEhJxTzwe/wWmC2OY0BD7WZZWWcJMKZg5q34ymj5io35wg4kH8zSflhEPt6c9aSVEa6mnmTgGlEbjqvBoOxkQ1EV2YIJbu915a8/MqQqbka6fYj+r6LP1erAeuT7wu6dSsH
 htzwICDi
 hk6J6medtyFRidusxkPR7/pZepMqUKHgMGyG75m8j16TCyEWrzgHrD8skNCmLyP6obPO7ySweCU8kEIetFvEQlLpoqdWz+jqwVQthjoHvAWWxAiuOkOEWfG2096SQSEaRYhR5D4YlmKpmNEwsr8hUqzAJYeduL0n6G1fzt5f6WfjjHX97gOcXYMlHDFHUmQ0Ls8gasWiYyFmaoH3/26XxUwL2oSSyl+xyg3iKZbY0lBs0aGLBN8XGwEE/PC4yYdRBHX4LXH6Ga9UEEMoo7y1FKz5+uzrVG1wREIp8zzTyuAvDsUuHBQIcN9VM8wzTyfQDWZbT32MrtJWzpnO5dZ5ii5h4SwbFfvJxpm2ACYWFKVqTob+suFLUxQj0jqgIP0F/7bvUWUPQVZjTxi7qsjT596emH4sLo7JvKmNKBf2Pko5rPK9S4xUKgBDH1weGIC9N5QcXnKU6MRIJbnHvWNYHW8PrGGoVZeKSb84pb9BsCqReh+oKb53ZEDgAt801TUZyysW+wtuY4qGA+xljJYlw7VnxXQXswhRGZl9USL/pVi9ecBI+/+h5QCqnNV42TsFPbJzuYYl9yShFGInysA+sYd3Ibf57efpzYK7v
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the next patches, IOMMU code will add data to page_ext.
The IOMMU code would operate on physical addresses which
can be outside of system RAM.

Add a new function page_ext_get_phys() to abstract the logic of
checking the address and returning the page_ext.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 include/linux/page_ext.h |  6 ++++++
 mm/page_ext.c            | 23 +++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/linux/page_ext.h b/include/linux/page_ext.h
index 76c817162d2f..bd373496e166 100644
--- a/include/linux/page_ext.h
+++ b/include/linux/page_ext.h
@@ -93,6 +93,7 @@ static inline bool page_ext_iter_next_fast_possible(unsigned long next_pfn)
 #endif
 
 extern struct page_ext *page_ext_get(const struct page *page);
+extern struct page_ext *page_ext_get_phys(phys_addr_t phys);
 extern void page_ext_put(struct page_ext *page_ext);
 extern struct page_ext *page_ext_lookup(unsigned long pfn);
 
@@ -215,6 +216,11 @@ static inline struct page_ext *page_ext_get(const struct page *page)
 	return NULL;
 }
 
+static inline struct page_ext *page_ext_get_phys(phys_addr_t phys)
+{
+	return NULL;
+}
+
 static inline void page_ext_put(struct page_ext *page_ext)
 {
 }
diff --git a/mm/page_ext.c b/mm/page_ext.c
index d7396a8970e5..95e8c40131b7 100644
--- a/mm/page_ext.c
+++ b/mm/page_ext.c
@@ -534,6 +534,29 @@ struct page_ext *page_ext_get(const struct page *page)
 	return page_ext;
 }
 
+/**
+ * page_ext_get_phys() - Get the page_ext structure for a physical address.
+ * @phys: The physical address to query.
+ *
+ * This function safely gets the `struct page_ext` associated with a given
+ * physical address. It performs validation to ensure the address corresponds
+ * to a valid, online struct page before attempting to access it.
+ * It should return NULL for (MMIO, ZONE_DEVICE, holes, offline memory)
+ *
+ * Return: NULL if no page_ext exists for this physical address.
+ * Context: Any context.  Caller may not sleep until they have called
+ * page_ext_put().
+ */
+struct page_ext *page_ext_get_phys(phys_addr_t phys)
+{
+	struct page *page = pfn_to_online_page(__phys_to_pfn(phys));
+
+	if (!page)
+		return NULL;
+
+	return page_ext_get(page);
+}
+
 /**
  * page_ext_put() - Working with page extended information is done.
  * @page_ext: Page extended information received from page_ext_get().
-- 
2.52.0.457.g6b5491de43-goog


