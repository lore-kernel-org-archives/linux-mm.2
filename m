Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76892CA5FA8
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 16:16:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9A646B0450; Tue, 20 Jan 2026 11:16:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D47EB6B0452; Tue, 20 Jan 2026 11:16:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C47066B0453; Tue, 20 Jan 2026 11:16:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B275D6B0450
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 11:16:15 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 568D68C0DE
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 16:16:15 +0000 (UTC)
X-FDA: 84352844310.25.D6E47B1
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6B686180010
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 16:16:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GrwOLtMJ;
	spf=pass (imf24.hostedemail.com: domain of 3S6pvaQUKCLAfYcodWeeWbU.SecbYdkn-ccalQSa.ehW@flex--pimyn.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3S6pvaQUKCLAfYcodWeeWbU.SecbYdkn-ccalQSa.ehW@flex--pimyn.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768925773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zECdq2qx8LIRzMbM9dI3FS5kU++am0Lig5cv/EMeCDY=;
	b=dH1vIFLK6zVoeGS3K17Yo723KVsnk+Qvy9nRck1dqyeMPiUM7jbYQKHhi9O3csB2HNv5lU
	O14ij2jZWK9U7PBmlEVX2PmIKGqzXz/xCUYpiYUxtWaLwNbcTF1eenOTCM//Tg2jMWV+EI
	mEM0aMnNirtT8HR+KWAP4HbgoN2Cn4I=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GrwOLtMJ;
	spf=pass (imf24.hostedemail.com: domain of 3S6pvaQUKCLAfYcodWeeWbU.SecbYdkn-ccalQSa.ehW@flex--pimyn.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3S6pvaQUKCLAfYcodWeeWbU.SecbYdkn-ccalQSa.ehW@flex--pimyn.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768925773; a=rsa-sha256;
	cv=none;
	b=C0lk1Tc3NhYz9DUm090NUDFZfJPp2nYy2AATf5b1WvIjlQ4L2h/KLE5jRvas2V/tlS8OGB
	46UhRiRTzBInXJSh2tmBdgok+mO9WTvK1+zrnh9jYskdqiYAxTjXjdxvd0LXiZMySyFm2W
	1Ooukchv2PmzyemiFevtQ0FqMuwViQc=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47fff4fd76dso38201735e9.3
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 08:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768925772; x=1769530572; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zECdq2qx8LIRzMbM9dI3FS5kU++am0Lig5cv/EMeCDY=;
        b=GrwOLtMJs/bNJRAYWvQIRxJvs/TFh5BY4Rj/ePm8zfXFtlUyAjgKMF6lrKUN+97763
         i7w80pUZzQTYmTwUK9sFEf7OVApJsfj7ch4ZlETY3lgBQO5wezJloXYZMT/P2p11GM7w
         fHI6hcWVoGoZ159oprKwJ19KgyA8s7fcPUj+RwGzg29IJSKIwMHf4ZszWLYvKbABJcAY
         KpBNwirkVjNkuswpGdoRTr08Grcp6qxYWbhG2t0g209FBAMy9qEwdmtzmojYSZHg0VlH
         E0CVVOauxaVAb7AEQGzbMvjtvEuI6V3qMH4rJf4JcUwJ68eAHDCZfmI971wAzFkOyQHF
         mn+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768925772; x=1769530572;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zECdq2qx8LIRzMbM9dI3FS5kU++am0Lig5cv/EMeCDY=;
        b=ce1QA33kJa3N1VqrEK7cCxVjBlWmP0gcYD++6sMqQlL5A4wqUOfMMGdrZnLNaA0Ilo
         yMh/i5qAqntgHqNMh7MeSFDaRlXy3enkqLoqNj/hNVi5r0xsUBeY4TsJstkBtD90hVO5
         5ZmGdOnjzhqV639PoayibSQ0LpCvhi/TcnFSVIEztDZfqlWj7v308QC45A0HNYG6exLe
         xAFQdY/2pU4rKWmlypku4jNjB1lPq0njSn04V4PtRta/J76Ch28yitXJODarDCO5Y/MV
         7rzWWy+dXvyts923tH9BW7YI2dNXLcvRpEW4280JlYW0DggjavgGE8+JYe/a0jCEqX4T
         GxVg==
X-Forwarded-Encrypted: i=1; AJvYcCXdCNLtuKv7JJ4/5WLt9+gdqbIALoYEl1FjgrUvsNO9oBZB5P08+lM7unmFF//XhyqIdznKRFeE2g==@kvack.org
X-Gm-Message-State: AOJu0Yy8LLsjN6rSitfYDGQBRMqDNDyxsfeJP+nQ1Al2gdXEtIujGd1x
	+sVQxT9zpbeSe1oC1jEHP/rHhipFcrhyNdTTNMW1yoNZrVXxNtJuxrj5cdwSZDkDg0mc+mrkfh2
	qQw==
X-Received: from wmsm27.prod.google.com ([2002:a05:600c:3b1b:b0:477:9769:66d0])
 (user=pimyn job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8b78:b0:47e:e8c2:905f
 with SMTP id 5b1f17b1804b1-4801e30a790mr216491795e9.8.1768925771811; Tue, 20
 Jan 2026 08:16:11 -0800 (PST)
Date: Tue, 20 Jan 2026 17:15:10 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260120161510.3289089-1-pimyn@google.com>
Subject: [PATCH] mm/kfence: randomize the freelist on initialization
From: Pimyn Girgis <pimyn@google.com>
To: pimyn@google.com
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, elver@google.com, dvyukov@google.com, 
	glider@google.com, kasan-dev@googlegroups.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 6B686180010
X-Stat-Signature: wob6nc7wkkaxku3cfacjzmd5fsy7wk91
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768925773-62955
X-HE-Meta: U2FsdGVkX1/fPbOgeu9YdCxg8bzSYiPJlwqtOS7nZXKn4Qz92xcQEkKav48zcscfXCEdNNMmg1BmN45qGAyOBqB5Su36ZCDgMgZE05xP3PH5iUAoCp3+kuyqnldohsssyFlFXdP8FqU/CzpWS34y2L3GYLvnoSQVoeyTN5CVn+eEhpb6JD83b8oBfHQ1wn2l8DxIIBp3PBkVkiOe9zmL40v6aM/KhOquMzCaBCwC4qRuF97wG9LvBEw14RiAFRtHCZ4vZrdpszuE/s13XozV2JFxoycGrEa+iN/CBE6QM9+9eBGso9+QXZwkL3ZF07e2Yy1gpf9/kG3aO3e5GyvAXrIGWCsGUZWvCiDgCRhuFt/MPw/C/H1WgWcoXXRaHnS8nnghpgIOz3awm0WjfzPgGxqT4adyR6yWXqb/vNEs5Pu9E73GfdU7ZJcH0VPB2MNoO2s24wy0Xxw/Ci/cVVsiKniXXfPQjqBl1KRNsoqip7nzWFRnPRSvSYutIfcJVOGzMSgVj8qCN1ebX8e+6pnCJczggFihqqIN8+BDfCiq9Q5LRJUiV+cbJPKBOglTxImMW4O6gqAWINiWq39rxDOCkAFDfA9eVr0bKifmIA9TrJ0rEgOMpz4BOaDu0buMyWLfINYS520DjXwomOUdfeGKprS7bOuXx6UkCDi042VS2ZfxZeuIH2ox1e9wNIQdtg9Chq78aXqArcu2oCOKpQSVD8ecW2c3jKP0ancla6e6zHMKECFhHTqql8+e5tgz1v7IbUgOVupyZYUBwKBypuphDgJD08aeanmVTEMo+qm+5VWKIWgcGvzL+vZnB8RztBFRnjOy3nk/kPsyyI09A/4N4IFO1Hy+en760NS98jRRMx8u/VQz9cIIQtKsVrE4tAcnS3GWh3GmoqAeG8yqJegF9NJpH2eR9XFVvJQLs6DsEKJSmQp98bkk9LimEs1NLh52hvqbXFVGNHMqWWhhibH
 T8mUOPtO
 3oFbC4RFVt3U8Rx/RkNZM7AxM+VT2exRJXx3BfeFCaeg9PmUJnRVb32mQgIG2C9WczRXPYnD4OezZPeW5bIiEt6xy90YeGJ7UfSJ9BWJKa4IFeDhObNSS2GhBx+BlpJZqWoz/3lBhMiXFpa8yi4oW2icbbfLm8HFyPXJJcNJWbmOmfKBmy//QYpUlqfs7TRpk9kvEK87tzDhFxTyP83DoJyP9LFoOPqJnt3w6YqvSH+Y2PE4Sdz4Zg9n9+Skzrm5SLO/2wXxZV8xhZMyhLdD0jpIhO8HoCHs0NMvQqudYlTZFm9Ec9LBFpka4JL0o2lP2y1Ew2AdezTgJc1b3xq/b11FiafEQKGTRwdnzi2/OYgpvS2VHJRxWKAyCotn4sEWJOHCUX6voNH0/cPe/1ffFTr4W6fnorbkrXau+VuxlOUwkuTpuXAZfpISq55XUKYHuGdHYGQM7uPxKoEr2W6tUplY6ONeCnld40K6ICFD4SSr8iBu03wnpTcroUndcfCj4rt7h6h2xqAGHxS5cD9QVjgNXxx2xUt/wCSkKdSP4QDslVmQHIWeE6g/eLA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Randomize the KFENCE freelist during pool initialization to make allocation
patterns less predictable. This is achieved by shuffling the order in which
metadata objects are added to the freelist using get_random_u32_below().

Additionally, ensure the error path correctly calculates the address range
to be reset if initialization fails, as the address increment logic has
been moved to a separate loop.

Cc: stable@vger.kernel.org
Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
Signed-off-by: Pimyn Girgis <pimyn@google.com>
---
 mm/kfence/core.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 577a1699c553..9e8b3cfd3f76 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -596,7 +596,7 @@ static void rcu_guarded_free(struct rcu_head *h)
 static unsigned long kfence_init_pool(void)
 {
 	unsigned long addr, start_pfn;
-	int i;
+	int i, rand;
 
 	if (!arch_kfence_init_pool())
 		return (unsigned long)__kfence_pool;
@@ -647,13 +647,27 @@ static unsigned long kfence_init_pool(void)
 		INIT_LIST_HEAD(&meta->list);
 		raw_spin_lock_init(&meta->lock);
 		meta->state = KFENCE_OBJECT_UNUSED;
-		meta->addr = addr; /* Initialize for validation in metadata_to_pageaddr(). */
-		list_add_tail(&meta->list, &kfence_freelist);
+		/* Use addr to randomize the freelist. */
+		meta->addr = i;
 
 		/* Protect the right redzone. */
-		if (unlikely(!kfence_protect(addr + PAGE_SIZE)))
+		if (unlikely(!kfence_protect(addr + 2 * i * PAGE_SIZE + PAGE_SIZE)))
 			goto reset_slab;
+	}
+
+	for (i = CONFIG_KFENCE_NUM_OBJECTS; i > 0; i--) {
+		rand = get_random_u32_below(i);
+		swap(kfence_metadata_init[i - 1].addr, kfence_metadata_init[rand].addr);
+	}
 
+	for (i = 0; i < CONFIG_KFENCE_NUM_OBJECTS; i++) {
+		struct kfence_metadata *meta_1 = &kfence_metadata_init[i];
+		struct kfence_metadata *meta_2 = &kfence_metadata_init[meta_1->addr];
+
+		list_add_tail(&meta_2->list, &kfence_freelist);
+	}
+	for (i = 0; i < CONFIG_KFENCE_NUM_OBJECTS; i++) {
+		kfence_metadata_init[i].addr = addr;
 		addr += 2 * PAGE_SIZE;
 	}
 
@@ -666,6 +680,7 @@ static unsigned long kfence_init_pool(void)
 	return 0;
 
 reset_slab:
+	addr += 2 * i * PAGE_SIZE;
 	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
 		struct page *page;
 
-- 
2.52.0.457.g6b5491de43-goog


