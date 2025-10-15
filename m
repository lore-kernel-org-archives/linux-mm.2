Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54B37CCD195
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 19:00:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A74DB8E008A; Wed, 15 Oct 2025 15:00:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A24D18E000C; Wed, 15 Oct 2025 15:00:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EE688E008A; Wed, 15 Oct 2025 15:00:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 797608E000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:00:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 109DA85367
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 19:00:46 +0000 (UTC)
X-FDA: 84001265292.17.C0844F6
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3C4D61C0018
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 19:00:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4h165s03;
	spf=pass (imf21.hostedemail.com: domain of 3Wu_vaAYKCEc57rqjwpxxpun.lxvurw36-vvt4jlt.x0p@flex--wyihan.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3Wu_vaAYKCEc57rqjwpxxpun.lxvurw36-vvt4jlt.x0p@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760554844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WKpGbUmSzOj72WrP0EnxSLypc0IcqdMmnVFCtJZuxlU=;
	b=Wyt2fcgSbZMNYisOSutrTMaa7a0z3n+RCX9LpGOCj9CiOHjFFRufsXJTzHUHyrCLioZznw
	8s92FsfRQdi89ddKh2/at5+nisurisqzoJFD1RN1Bj30A0XdYxMYD6YH9ImbgzL2yguKy8
	LIDqbO0yEesbWz++XeVwtM4d63sjd2c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760554844; a=rsa-sha256;
	cv=none;
	b=h0+hIl/dz/v/I7c7DyQ4BRjFWnzB11NqQjeHfV0zGYxSz+EyFAa+L1IvLKsOOgbbH4qGj7
	sorTleuWwqtVn1byoSpNs6sXxZNQsInNgyyaPBscAs/aaRF855BN+fQCUh1p3rm45I5774
	lJ6tYan3qcgaZsH1JGSu99MLn6DCeEo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4h165s03;
	spf=pass (imf21.hostedemail.com: domain of 3Wu_vaAYKCEc57rqjwpxxpun.lxvurw36-vvt4jlt.x0p@flex--wyihan.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3Wu_vaAYKCEc57rqjwpxxpun.lxvurw36-vvt4jlt.x0p@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-78102ba5966so10331389b3a.2
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760554843; x=1761159643; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WKpGbUmSzOj72WrP0EnxSLypc0IcqdMmnVFCtJZuxlU=;
        b=4h165s03iaBuNGXKqFQ/nmc548yfzq9cc3QnEs0Yq8qS1maVnjZZuiW+z0UVZ9CWE0
         Few3plsDKZbz/FcicmivvVtABlvI+d3Qe4jRCzXShrOwxZjdb1746GMYm2F7YD8872Io
         6gnY2XkAuFWV1tiqUvcp7KSVvns2Kd05aJLo9QTL8zpbp6ubulvoyZXlH2QD7WSkDEob
         kg2yun693I9ehgyFf8PNkE9SaXeg+5XVgwqlLiuMOT1Xe3c0iRJUhGeLaFmcxFj2ftn6
         E/fO88HH8tIi+uu/ZV/4EMuxjKgPMKm/KCF/Vng8yt8Nc5HtMmZORsShEm1Nvkze0wVz
         OaBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760554843; x=1761159643;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WKpGbUmSzOj72WrP0EnxSLypc0IcqdMmnVFCtJZuxlU=;
        b=F7SaVfCs0WVSe9xNgYYl2hKcq9n7KX1hfbnjPxeSp3A6uW2uMeyzIQrNqqNusNKuoJ
         SeDFzWgKQThlT6pEaSowyQI2HCiDO7i8+M9fS5gVb+QDq2y1yrhsb+oj/dnInYNedN/+
         QUnl9o6uwPwuOsLHDY11CDy+vJLmBHi08aN4x4hNx/fNWNdQaYn7XOqiJdMLvbt0uzDB
         nl0oJZSV31PwfTBFU3E7qz/urZgC0Lqbc267Zrf1dFUNnM8wApRTa4nCjLU9+61Ya/md
         8OUoQgSyl1wVCcht/ejoFphOAZTygGfxLf4nfiwJLH0uSSpoGpuw9ht2+msjlgy6X91K
         5c3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWC4OMThaEeJP9MGoNbmIZzYVMjphxn9S0raurDcrNnQfHBw/8n6FPVUKysbyegI/tV0B8zyHqs1Q==@kvack.org
X-Gm-Message-State: AOJu0YziDh7C/zHbbRqbC7PzRsKoNeaPrlCVBBppR7GkTpBkcM/t3ksW
	ks98N0rQjivyBAqqO1acAI3K3BlRHgKy+5j7Pctf3QeXD26DnkC2SBHxkWy6l9wEIAO8WhBVWxd
	anG3wpg==
X-Google-Smtp-Source: AGHT+IHyRappA+6tH9Os76YkQbRqGqpECognzksl9aFKwm+WiLtRqKUJv0T7aogOLuMAz2ED3mj7afM55V4=
X-Received: from pgip24.prod.google.com ([2002:a63:c158:0:b0:b54:fd1f:ef57])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a10a:b0:334:8dcb:567b
 with SMTP id adf61e73a8af0-3348dcb5856mr3480615637.52.1760554842922; Wed, 15
 Oct 2025 12:00:42 -0700 (PDT)
Date: Wed, 15 Oct 2025 18:58:55 +0000
In-Reply-To: <cover.1760551864.git.wyihan@google.com>
Mime-Version: 1.0
References: <cover.1760551864.git.wyihan@google.com>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
Message-ID: <57ed0bcbcfcec6fda89d60727467d7bd621c95ab.1760551864.git.wyihan@google.com>
Subject: [RFC PATCH RESEND 1/3] mm: memory_failure: Fix MF_DELAYED handling on
 truncation during failure
From: Lisa Wang <wyihan@google.com>
To: linmiaohe@huawei.com, nao.horiguchi@gmail.com, akpm@linux-foundation.org, 
	pbonzini@redhat.com, shuah@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: david@redhat.com, rientjes@google.com, seanjc@google.com, 
	ackerleytng@google.com, vannapurve@google.com, michael.roth@amd.com, 
	jiaqiyan@google.com, tabba@google.com, dave.hansen@linux.intel.com, 
	Lisa Wang <wyihan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Stat-Signature: t6yk9cxzjzng16o45ue5d8brebtts19e
X-Rspam-User: 
X-Rspamd-Queue-Id: 3C4D61C0018
X-HE-Tag: 1760554844-752704
X-HE-Meta: U2FsdGVkX18vx3HpmoxljaJrU8+4SdLLLolu1mB/ERigI31M7GTiAVYxi+6Ir1PxE7sDk+cgHMKxT0BFtPaW0iLbqwtcfwvDoe8O507LUAawaWB26TgFrKFtGUqYWn82OWEkX6NQy8q3MJ10r52Wvu165+EbITAOrhCzM6AX6722AOQhB7q/Ma4CnQ5qIsqBQeBtxSbty7iZCkWupjwlGnueNRIFi2q3/2ifKd53Ri1vOb7mDvCi5zbe4Ac8iKP0G9SQOflpYJXA8PxC9o8u0eNWz55+RngW0i19MgBlIzUhtxT/JMoo278S1ympindhY1YVwy58QIjMl7gdTfQuTAYM7N6KF1A+6DvIK2fUh4fjBfr+2kx1PonQPfXGKwqv3wFt7pSJKDMJ2nuB/UgYGyxHaVcron3u1/fx8q4iu7h5gdwtv17GcG6tHmhnVmx19/6PXp6YRvvxauzlRYGYKajEBazfqknYhd2FSt3RJYol+vCVCI2HZevO5Ok6vqwiB5V+GXdx2TONWiveTVOU6Wld46iEFi04go8FaxtmbmxKuUIADYu9in0Tu2YHo76IyIQqjKWS7fHHOkAJXO3JB4UXngotwpYFbQT9tV/LKaSp3l+BAUW4E5lMGNZVspliMKzgTLfebkkxqv8/jHRInlcLFEYa+BmEBukFU75JKz729yYmM4qU3u9wmn7mGp4curB29OGOUy7CeKYiV8FpWJy35AFZbWHtsZSlU5LxA5KxM+lYZcyPGMOUUikv1KXySQmE76yUFmz8B3Ua0vcZ2C1ruJUbVeAbau29b/SzoUgsm2cRSn65iAlBNEIbF5oanxO0QPosciKjkdy9Q3wO7w2pfCyTyj2146lLgFYaYRyQtYPy8+FFL5IIq2ZlPxzahitdfSAtx3Eg38EdAlKVsi5VTear8WYjrP2bN5Ttj3PMCbGaoT5K1aQ/5aIiyR1n2wu8YK+0BxIqly0xPsM
 +Nuz+w8s
 GxjpTzIeSqmwnWL3T3CgWacYX73XjwqSgIdaZWtYdk6s/nQW0AKs3IlcXzD/dwuEaK1nOvhfVCtZesTdedBeswmcmI45VuTSM/YRkiqZ7thrpj0vsgXSGeqZ2Pt9lB35h+GbzNLYEJXqrO+BpZhEGhemzvgZT+/M/Bct5uJPlYeu92sEdE7Deep6Nx/MjWvk8uZic0HUeAQB7xSBA0lQ9nz6hcdsdy3X5IaRWGHRQAdHvCgcfBhzcxE7dXCH7I50mL5GjK+JXzSZDtw6mqX1k/xLKw8HFxTZE5DxJbWImMCl4R4kN/gadk9JWg1osC9N0zg/R0OnV7MOalKL32BlemLE/dsJEIipavDgZ1KDmQGZA1J8Q9oCHQwCRBa3I/A0q+bdQYlODpkH/D52RIyz8sJ4vzGl89KFQuT/dKScK93+A5G9DcraRn7FumjswC2BKtOYbNRCykco82WAJl2/7PPevHyEYyD8kqLef99pJZ15m+6h8UNvUzgP1QgbWTLwTxM+hkPnfiUZEASeW4BRno3po8LyiCflSHVtPdb18p8dnUSxtxzSDcaEU2DHV4ByD0jvZXhEqXS1FDnyQK9w13QJ/yLip+CiB9dB3CIJG+FWujtNeLnlwFd/mcypKR0ANcSoduxdhIpfZy51yBZA1uSlsZItevhNEfStD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>
Message-ID: <20251015185855.6yjNyS3UCujHc0P0t77oCoQC5A6MPpKzIDVNOVbN4wg@z>

The .error_remove_folio a_ops is used by different filesystems to handle
folio truncation upon discovery of a memory failure in the memory
associated with the given folio.

Currently, MF_DELAYED is treated as an error, causing "Failed to punch
page" to be written to the console. MF_DELAYED is then relayed to the
caller of truncat_error_folio() as MF_FAILED. This further causes
memory_failure() to return -EBUSY, which then always causes a SIGBUS.

This is also implies that regardless of whether the thread's memory
corruption kill policy is PR_MCE_KILL_EARLY or PR_MCE_KILL_LATE, a
memory failure within guest_memfd memory will always cause a SIGBUS.

Update truncate_error_folio() to return MF_DELAYED to the caller if the
.error_remove_folio() callback reports MF_DELAYED.

Generalize the comment: MF_DELAYED means memory failure was handled and
some other part of memory failure will be handled later (e.g. a next
access will result in the process being killed). Specifically for
guest_memfd, a next access by the guest will result in an error returned
to the userspace VMM.

With delayed handling, the filemap continues to hold refcounts on the
folio. Hence, take that into account when checking for extra refcounts
in me_pagecache_clean(). This is aligned with the implementation in
me_swapcache_dirty(), where, if a folio is still in the swap cache,
extra_pins is set to true.

Signed-off-by: Lisa Wang <wyihan@google.com>
---
 mm/memory-failure.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index df6ee59527dd..77f665c16a73 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -922,9 +922,11 @@ static int kill_accessing_process(struct task_struct *p, unsigned long pfn,
  * by the m-f() handler immediately.
  *
  * MF_DELAYED - The m-f() handler marks the page as PG_hwpoisoned'ed.
- * The page is unmapped, and is removed from the LRU or file mapping.
- * An attempt to access the page again will trigger page fault and the
- * PF handler will kill the process.
+ * It means memory_failure was handled (e.g. removed from file mapping or the
+ * LRU) and some other part of memory failure will be handled later (e.g. a
+ * next access will result in the process being killed). Specifically for
+ * guest_memfd, a next access by the guest will result in an error returned to
+ * the userspace VMM.
  *
  * MF_RECOVERED - The m-f() handler marks the page as PG_hwpoisoned'ed.
  * The page has been completely isolated, that is, unmapped, taken out of
@@ -999,6 +1001,9 @@ static int truncate_error_folio(struct folio *folio, unsigned long pfn,
 	if (mapping->a_ops->error_remove_folio) {
 		int err = mapping->a_ops->error_remove_folio(mapping, folio);
 
+		if (err == MF_DELAYED)
+			return err;
+
 		if (err != 0)
 			pr_info("%#lx: Failed to punch page: %d\n", pfn, err);
 		else if (!filemap_release_folio(folio, GFP_NOIO))
@@ -1108,18 +1113,19 @@ static int me_pagecache_clean(struct page_state *ps, struct page *p)
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
+	/*
+	 * The shmem page, or any page with MF_DELAYED error handling, is kept in
+	 * page cache instead of truncating, so is expected to have an extra
+	 * refcount after error-handling.
+	 */
+	extra_pins = shmem_mapping(mapping) || ret == MF_DELAYED;
 	if (has_extra_refcount(ps, p, extra_pins))
 		ret = MF_FAILED;
 
-- 
2.51.0.788.g6d19910ace-goog


