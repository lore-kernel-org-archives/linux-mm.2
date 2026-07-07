Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8FA1C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 18:29:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3DA76B009F; Tue,  7 Jul 2026 14:29:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C15186B00A1; Tue,  7 Jul 2026 14:29:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2ABB6B00A2; Tue,  7 Jul 2026 14:29:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 89C326B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:29:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0F3881C395A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 18:29:27 +0000 (UTC)
X-FDA: 84962818374.01.6303773
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 73B4D100006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 18:29:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Wet0H5S2;
	spf=pass (imf14.hostedemail.com: domain of chaithco@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chaithco@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783448964;
	b=Iru1JfDi0I24OLDTtJFOeRPSUXR0vhJ1N9LTCc2sXcJkGU0ydCGftXnFCp8+XnmZPO7BOZ
	biC02BNVXyox46a+54Va3/GW1wlmyn/0Q+sqAoCtI6P9CeEdRRhgHABzyoeS5FfwbLjter
	WMWvWxdw7YN6MK8MO6Tf09VJILuMFsw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Wet0H5S2;
	spf=pass (imf14.hostedemail.com: domain of chaithco@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chaithco@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783448964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9HRvV/BdSZtB6LDhoeM5qhtklSBvZEZTbpGHK8giblA=;
	b=h/HCEdHYZYqq/Ke1rt6auYJdU6xNrBf94LJij6612NulsKBlJPc26mKvLfPLqsLDmxpJAa
	gK5f561JvOe7yX56IdlO0kbVexrODgfPnFe7naBhBvtnu5cH/mn0RNQnsVCtdOj42A9ZVO
	8XhXqhEpAtjS8kGnU1S7S6OwBucrzeA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783448963;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9HRvV/BdSZtB6LDhoeM5qhtklSBvZEZTbpGHK8giblA=;
	b=Wet0H5S2zscIvrpT9PI/Nah1R86myv52XxqvaFLnXtcDlACspPStIVsY7eYpLmWmavnM+8
	vb2LwSteKt+8P4tGdY903de1Gmz4OQ2L1Uh0nZt4pmZbMbDq+SL9LXOds5WE7A2BIuijc2
	r9/jTZQURb0HGi+86APIWWAFfkVY68o=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-435-65U-xFRKPRmgqkE-ts9H5w-1; Tue, 07 Jul 2026 14:29:22 -0400
X-MC-Unique: 65U-xFRKPRmgqkE-ts9H5w-1
X-Mimecast-MFC-AGG-ID: 65U-xFRKPRmgqkE-ts9H5w_1783448962
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-44ce7e98e27so1395233fac.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 11:29:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783448962; x=1784053762;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9HRvV/BdSZtB6LDhoeM5qhtklSBvZEZTbpGHK8giblA=;
        b=H0SzwSv693CUtuua1z6p7IDpX/j7aYmlg1HlNO56JWIh4qdym07u7dNEhkNv1npm2U
         E/CIdgcYrTXmVonjBpww0ULsHVrGEbK5sp5eYa7D1+4T4y0etz0C54pYJXQ2e3A/KCcA
         lUx3FQhyj2M4hCIKbDRbnPnXyY8Jelv44QXooamqJHtEzA5S7UNhGEkx7T3WBTBZaZXd
         ttJhWN8POx4PacfKsyReTaVlsx5YU2umI2UL8ziw8VlrZfjrXt5DdG4rvxorBB0Dvtxu
         RYcg7Pk6/TvSiFbhGOnAVkgAJSI8NGl9pWAPSEW/8P3VAKPjr/9wKx1B5sABAEcn0ygS
         rFiA==
X-Forwarded-Encrypted: i=1; AHgh+Rr1y5N4Rx7Jf5+Y7x6ryyA5nGVmWk7xBVRSAgo4EleED0og90MU8+G6J0s4v5aYz9rFh4FeSF+DgA==@kvack.org
X-Gm-Message-State: AOJu0YxGdmZNihd2G2r94J6Qt9LaOJfsE5jJquqhCVF358wS8YkrzBel
	Y0XHKi2l5UyiFHaz81wadz8gNWItGkGPLZoyEXAUuB7g/Wk+EPIvewGe+OM0Xrog3x+5pHQrlQ8
	EeAWiwZlIvAB2vJy1TByKzjQiEseCLu9buM2X/jSYNK/y6Gn0H2F91XohswCg4B0=
X-Gm-Gg: AfdE7ckvw3KkXfFppp+hnbpW3CVvS1JJNiiGGi4e2alGInRiDF1/zhdkrI4REqc84LV
	lfWpsh2nmBS9K7isQ3voqwWz+xUjerxXnE9sf9vkHoMNgNRhxGm1FShFJqRhSzivq3RJ24mJyuH
	TCBe79v7ZeWwGfcFBmr9pn1qaFbMzA6vwwK2UPZyBmqV7ClfFkf4YcDYaNGu19xb+ElqLS6Ps02
	XS+axiRSOjA0aQboeqJEGjcOvpxLUQDoVnE7qmidfb+a0LubTtD2qt8SN+AhmSli50DJ5u3H+Hr
	vLzxn/PD+aJD0qov+OgltCRk9POWLv2Fz/RR3nXEIPjRpcje7shhHUUWJWYGqCfMZc+HaE5fKiw
	fc6TQH6mvA7lxNW2sOr96FkpgeX7muIJw1Vcu+MIkTXijvra7MmiKl3OnP06aRtslLgUuJ7FYNh
	Dyd89FYg==
X-Received: by 2002:a05:6870:b61b:b0:448:aa9e:b051 with SMTP id 586e51a60fabf-45118c70621mr2232776fac.14.1783448961791;
        Tue, 07 Jul 2026 11:29:21 -0700 (PDT)
X-Received: by 2002:a05:6870:b61b:b0:448:aa9e:b051 with SMTP id 586e51a60fabf-45118c70621mr2232761fac.14.1783448961294;
        Tue, 07 Jul 2026 11:29:21 -0700 (PDT)
Received: from chaithco-thinkpadp16vgen1.rmtusco.csb.cloud (184-96-191-56.hlrn.qwest.net. [184.96.191.56])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-44cfb55907dsm13550509fac.11.2026.07.07.11.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 11:29:20 -0700 (PDT)
From: Charles Haithcock <chaithco@redhat.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org
Cc: Charles Haithcock <chaithco@redhat.com>,
	david@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	arozansk@redhat.com,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: [PATCH 1/2] mm/hugetlb: Prefer mempolicy nodes for calcuating surplus hugepage reservation
Date: Tue,  7 Jul 2026 12:28:55 -0600
Message-ID: <20260707182900.483757-2-chaithco@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260707182900.483757-1-chaithco@redhat.com>
References: <20260707182900.483757-1-chaithco@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Lkx5qyzuxgJAcTkmucmyq9DFYpyKF-9GxawFOLzNZKc_1783448962
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 73B4D100006
X-Stat-Signature: 3pyz3jqrp94p14z8p9jrcisiycoxckx1
X-HE-Tag: 1783448964-848431
X-HE-Meta: U2FsdGVkX1+doaMyB8ACm+a4VvA4Gog87TZs5RgVJDTYJostNZa54Gh7d4C5d2zb8dtO9fKvw2IDG1ewpDsdOUFUMCrRhMzqYbF9/0E2D7gcMqn213CTg3frWMMtr0Mc3kd3KlZrluUJ1FgBE9zAGlXev2osmvZPwyw4ycb8btUx9r7WIWuS7KSZC8pxuLcog29ae3qh30qJjenQJZbdmag+rPsNKzgYhRo1BN1ETUsvpvBLQHSUPEZ9OQYC8nzgJeUzj7hdW10dnOUTcnER8RlpmRUuClNW5ec4aCDb+mbVwaYxwsizdBlMDvWI4H7TTfoWaTNoTn/xOZVNoigTEbJaZ0RmVpOqn4Dk4GaakCdLm7w7senxzuo4PoXZEZgef6BKr6hhfN+6gW1t9S25ZyYQJiqpJHuiIcfjub8vkS+u3sMbiPhuhEURtW6QJhR682yuKLmzeq2AMcz79huS96MBeubYHTKi6ejAaVVAiazJqKxyje57XaJqqt61zLkU8alP6GGcgtmvawJcCZiwykz4kriRcYpVyEIjiwEOuE1HCnbgxKSRlMXXkZK1HHZNAgJ3nOA0w6OxqtWn3AFsxS9G7DsvHOft3iLYVX10/9cpN5KSBC8/T28yUnf0wZ0amaIPx9pZPwNxdAoIMEfxrvXNvzZ+Rp9uDk7vE4a7skEgO3QsO9Kuqr1zyrGGjEkDzqvCjtH2/9/pUmHTU/Y8MRySLaHwEn1Qau3lFXHnABHyCKxU6+VsWjOE3duxyA2/GDLT+7qfcyNGmJ4DzRq7EH+HSA3BefsFtBDHV3Q+HMjHP7NcvS1+DwV/cp6C4oUK47VVHfoI1mpOcOoNsPR6vvhGtKSWoSDPa89RpajV/tqf1CRAv5ZQF52Zl0L74dbmopWM4Gc1eZLuyhg5bVEzGfngQD1PkmpsdI8FDjzoNJvCre6Inqg3Fs4+a3uJsz0EPxhxdpuZUGwQ2INZbOs
 rcff30P4
 9QIQyYmL525ot8JEGCgCXMUK8amF9vL/xg6EbF3I6BHpCHz68gmLhHtGethj2TB+tW6WGGJPgowpOdQlwJW3B6C1YlaBxz5+h2IwxINKVVhgviibvgiXQk/J0x+sT5yRzs4msLqSphQ2di55IZMSVFQF3rjqWoSp8nRIqOQh9QMq+tLKSNSJqY3N1brapFH7cvZAsA6tRx/g/44RodafhH5D4f0OEZ6jgMLtO6JePrTFgOJcdmsfR2qyslmN0CQUD0zQBdPOXHVsCGE7N+omv/XHwoUPavz4KCzf3gZISkkJ361+9OcDRwrfgu0FmGPCxKwHjD6y6Yu+hh7gCkPw639w95Mlyhywo6RUrxJZH5YwDJV0D/q3WRTlrrs6Bbt9knTUZ3eIb1A0hrfmxxiEQRCnZr90hx5gfvH7e966GzmRYtlA9nxO+gqaNbmReZPWYyLRehVZ9axpiF8/TlIjsgWbf8Q96A9xphqfCDN+uUYBqK+4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, reserving surplus hugetlb pages in a mempolicy still use
global counters for calculating how many hugetlb pages to reserve.
Modify this to consider the nodes in the mempolicy first but fall back
to all possible nodes.

Suggested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Signed-off-by: Charles Haithcock <chaithco@redhat.com>
---

- v1: Modified `needed` calculation to use `allowed_mems_nr(h)` in order
  to consider free hugetlb pages in our mempolicy.
- v2: Folded in Joshua Hahn's recommendation [1] to further modify
  `needed` calculation to take the max of either the available hugetlb
  pages in the mempolicy or the globally available hugetlb pages. Allows
  allocations to prioritize nodes in the mempolicy but can still fall
  back to offnode allocations. Also added selftests to check only for 
  the edgecase which caused this to initially be reported and sanity
  checks.
- v3: Split the change and tests into separate patches and clean up code
  to better align with kernel style guidelines. Likewise, fold in Usama
  Arif's correction [2].

[1] https://lore.kernel.org/all/20260602152022.2673803-1-joshua.hahnjy@gmail.com/
[2] https://lore.kernel.org/linux-mm/20260624144600.8159-1-usama.arif@linux.dev/

 mm/hugetlb.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f24bf49be0..f5e678e997 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2255,6 +2255,23 @@ static nodemask_t *policy_mbind_nodemask(gfp_t gfp)
 	return NULL;
 }
 
+static unsigned int allowed_mems_nr(struct hstate *h)
+{
+	int node;
+	unsigned int nr = 0;
+	nodemask_t *mbind_nodemask;
+	unsigned int *array = h->free_huge_pages_node;
+	gfp_t gfp_mask = htlb_alloc_mask(h);
+
+	mbind_nodemask = policy_mbind_nodemask(gfp_mask);
+	for_each_node_mask(node, cpuset_current_mems_allowed) {
+		if (!mbind_nodemask || node_isset(node, *mbind_nodemask))
+			nr += array[node];
+	}
+
+	return nr;
+}
+
 /*
  * Increase the hugetlb pool such that it can accommodate a reservation
  * of size 'delta'.
@@ -2277,7 +2294,8 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 		alloc_nodemask = cpuset_current_mems_allowed;
 
 	lockdep_assert_held(&hugetlb_lock);
-	needed = (h->resv_huge_pages + delta) - h->free_huge_pages;
+	needed = max_t(long, (delta - allowed_mems_nr(h)),
+			((h->resv_huge_pages + delta) - h->free_huge_pages));
 	if (needed <= 0) {
 		h->resv_huge_pages += delta;
 		return 0;
@@ -2311,8 +2329,9 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 	 * because either resv_huge_pages or free_huge_pages may have changed.
 	 */
 	spin_lock_irq(&hugetlb_lock);
-	needed = (h->resv_huge_pages + delta) -
-			(h->free_huge_pages + allocated);
+	needed = max_t(long, ((delta - allowed_mems_nr(h)) - allocated),
+			((h->resv_huge_pages + delta) -
+				(h->free_huge_pages + allocated)));
 	if (needed > 0) {
 		if (alloc_ok)
 			goto retry;
@@ -4513,23 +4532,6 @@ static int __init hugepage_alloc_threads_setup(char *s)
 }
 __setup("hugepage_alloc_threads=", hugepage_alloc_threads_setup);
 
-static unsigned int allowed_mems_nr(struct hstate *h)
-{
-	int node;
-	unsigned int nr = 0;
-	nodemask_t *mbind_nodemask;
-	unsigned int *array = h->free_huge_pages_node;
-	gfp_t gfp_mask = htlb_alloc_mask(h);
-
-	mbind_nodemask = policy_mbind_nodemask(gfp_mask);
-	for_each_node_mask(node, cpuset_current_mems_allowed) {
-		if (!mbind_nodemask || node_isset(node, *mbind_nodemask))
-			nr += array[node];
-	}
-
-	return nr;
-}
-
 void hugetlb_report_meminfo(struct seq_file *m)
 {
 	struct hstate *h;
-- 
2.55.0


