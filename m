Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D36CCCD195
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:37:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9E788E0056; Wed, 15 Oct 2025 14:37:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4F148E001D; Wed, 15 Oct 2025 14:37:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8C688E0056; Wed, 15 Oct 2025 14:37:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 984F98E001D
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:37:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4938EC0278
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:37:00 +0000 (UTC)
X-FDA: 84001205400.27.E24ACB6
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7C015C0011
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:36:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dcq4zs7W;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3yenvaAYKCKogiSRKXQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--wyihan.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3yenvaAYKCKogiSRKXQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--wyihan.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760553418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WKpGbUmSzOj72WrP0EnxSLypc0IcqdMmnVFCtJZuxlU=;
	b=1lrFuDQUJ7cu9aX2YPqTddxa3JUZah+jJpXNLRE9m8QSSYDSFjtsKQZtD3vvYjsii8XaQc
	TeTNf0B4+jJMwbezA6GoRpURSEciT4PlZmoskHqqPRK264KWsh0WS0ureLqDJ1Mgcw3SiO
	0JJxOc/mVZUlGnqWj1ymXi1nhadHvXI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760553418; a=rsa-sha256;
	cv=none;
	b=W9EXzT6+u6AAQhJ7iUo6P4TZII8VIejMibcU+8JgbPKa0I5g6on5lAH/VtOlPmDkA+ue1s
	aeJSSSDQoleRjdZuf17EEOZ7+DOJwDgbh+uwo4ztNc6zh1t1DyLqJEbu1+/Kt247t7/mPL
	HY12aTckGXY8KrTg1IJcow8mXFB6kdo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dcq4zs7W;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3yenvaAYKCKogiSRKXQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--wyihan.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3yenvaAYKCKogiSRKXQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--wyihan.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b4c72281674so7837008a12.3
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760553417; x=1761158217; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WKpGbUmSzOj72WrP0EnxSLypc0IcqdMmnVFCtJZuxlU=;
        b=dcq4zs7W+JrNRU4Ge2RcxNMTvD97qe3SjMh21gPlDrQEb9UP2z4PAtE2lXik0dFJoA
         hDrtPMvNvTgxMMV9fl9lbOfc9V8Q0cycuCn6ryyeEUyaMd64aAnTo94aA+hEN7c6mOlv
         VQkiU2YrZhzkwe+0NjM2cX4YB3ZVZprFXaYVPcuEEpFBkiRvdhwnsxNXNmlUsb7+SZeQ
         6OxZVDym6uWb4Nd/QiPj1FGaxE2NBRq4eJUNUneJzsi0K5aIYHqrFjhEZLvsZkRxYZpp
         HUrX/8sKyI0ZhNHTncnZ6OLkaW26lNeu86z9GtLu8ROQar5VgeaIh5f2wRcvilk5pocQ
         G6+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760553417; x=1761158217;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WKpGbUmSzOj72WrP0EnxSLypc0IcqdMmnVFCtJZuxlU=;
        b=pYRhmUHkJt0nqFK1LAmrsCjpurYL5on3jRJHJRuBR06e5U0CPNE1G6tpVIPhQOAzUB
         l8xaNHGjwmLtByEbJeyvqVnpx5SgGMIDPyDKg7it/BPnQkiJ7QspDjIRsaoDRB8uQzib
         YUjMpQum57sCv5nlOmC02nuJRKHJSUAdd7YBD2uJ2RK/A8ACv9fyTLp8IfkL2DoG5RvP
         OjJA/vSup7VvYa+8AdCFNpHkJ2xk2FaJE6kKaJkK+ZRXft86qjgwY9CNB3yWjQ9fMUvq
         BCYxVc7Sc+a+pIntpksksX7GgZq+XfQIuFjtK6E9uY1qn4NArx4cEpSHwrjvl1zpgOH7
         V3yQ==
X-Forwarded-Encrypted: i=1; AJvYcCWzKCU4hm4MbEBpPY8maLGR6mDEYRQrbW0tFT/4Usl8apTe7pgo9PUcFFO9wmx0cgFIWtapHyTpkw==@kvack.org
X-Gm-Message-State: AOJu0YwTbfeAqJBDW2eWf8tu8gdXuP/OULeGrurKFudHhruJVP/bDlg7
	yKZBwuWkFVN9D3YE60/8rzU1kyNxvxiBQIGT66edZJ5XYHetWg95NuNQLzpet70vfozHU0AzNx3
	45E1kjw==
X-Google-Smtp-Source: AGHT+IEYhWHuql5g9/FhU8JjSG5gGZZVyTNmxSEqKWgRSuyQCnr845g5xH8NjCRtjZ4IdBmCOokrTClIDdk=
X-Received: from pjg7.prod.google.com ([2002:a17:90b:3f47:b0:330:7dd8:2dc2])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6d8b:b0:2b1:c9dc:6db1
 with SMTP id adf61e73a8af0-32da813457bmr38309016637.12.1760553417387; Wed, 15
 Oct 2025 11:36:57 -0700 (PDT)
Date: Wed, 15 Oct 2025 18:35:52 +0000
In-Reply-To: <cover.1760551864.git.wyihan@google.com>
Mime-Version: 1.0
References: <cover.1760551864.git.wyihan@google.com>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
Message-ID: <57ed0bcbcfcec6fda89d60727467d7bd621c95ab.1760551864.git.wyihan@google.com>
Subject: [RFC PATCH 1/3] mm: memory_failure: Fix MF_DELAYED handling on
 truncation during failure
From: Lisa Wang <wyihan@google.com>
To: linmiaohe@huawei.com, nao.horiguchi@gmail.com, akpm@linux-foundation.org, 
	pbonzini@redhat.com, shuah@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.or, 
	linux-kselftest@vger.kernel.org
Cc: david@redhat.com, rientjes@google.com, seanjc@google.com, 
	ackerleytng@google.com, vannapurve@google.com, michael.roth@amd.com, 
	jiaqiyan@google.com, tabba@google.com, dave.hansen@linux.intel.com, 
	Lisa Wang <wyihan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Stat-Signature: c6adbxy3ncmbnfrxtu1urt8wjhttppn4
X-Rspam-User: 
X-Rspamd-Queue-Id: 7C015C0011
X-HE-Tag: 1760553418-180260
X-HE-Meta: U2FsdGVkX18IISZv3afUmBoS+dUmUK6nSaVxuXx/aWHpbAwZQmyWmoKHGyT3mlI/vh+vuN4jI3cxCTPxIooqNOWUmxcYZLbtd4kFFWVyxib+MlODeheLNn+2n+7MeW9E8CuFzivEKToRhLtdB67AW05gTa22s0wfGyx+e84DSuvre/Y9u6i69LbMIyOG8GcCuezVVlnLf01Byj5Yt5+yiNPfW65z742wZXbbA/V5gtGSKqmp9dUPUX87JcbISvoO+jLWA8GLqPQZFNCZRupNP4vgpbZUa6sgvSYA7zm+7L0zax+NVZw+VOBbxre4Du4LwThJlpBCEZprXqpuaWHM/hkoMzcQjT4rAin0cOKzF8ZT/YT9fmhlnQwxgyzUWwZBhftXNOXN0e558y4MLhRlUyfyGVXMsrlTVJS+wcvCEgvqRlJHPtoQm3XCkqmChcBhKAzMgvXrF3s9V7ZAgOLBRbTkp0IxGYaG8nobH7VkKb7hv8YNZJyrabF4ILokeLmx/FDFe5DvXyhlUD8ePzCDAp5D9dYwRI+VF5unOdo4Y67sx8+xACfyCtYrVzWmSnWIj5fl4bZCW81JXJsd29e44dgG6vW4ISIdgGUGaiFCaKOcByig7ie0ZOJe1vbeAwR5luuK8l4w31shLtl8APId7iiBF70K9lmdxQljSd4hQ3wr6fQGhOLmppRbdI2qjz+R0s34x8/1yAwqoiiLiForKUng+8RgaCpqH/lEkTLP1LHvNGM1yObwWDXoBQdIezNu88Y8friSTCN8PlgKg1pYXNJXKvof6KIvaZ+qdZYukcv1/fp1hXoJUIK4YUhibCK7HM4d1+O0gWcckuTo7lFGObriF1e4/TEVa0w551MINCkP6xqlfd/2hdATEP0RO9RZVN8BJRHET3lFEu7TqScAnC/6Nj2i9R+ODMankxvtPfCzPcx6mZrAcTs+KTgXQM/1PJEyc3oHkPXfFXbn0+4
 FaL+i4uj
 w16INs6BuP2rYTlNOkVv8jOz6y3jhdM3DB8qo9rn24LX/c8Ua7m2TfGZsHzW2eH4By26vI/v0U8//WzBoDfTkg7DYumugaDkMmngRm5/bBv0ISeJLoMVvW/s6ilZMHIAytYEddcC66DEZv5FxhALec3YbvXBs+OQPcfA2PKJvXEkVuQRRI3DDSjWRAVG8nJ5NGuHjdiIxSBpLlRxx2EH1JNXlnw8K/T2r0YsApYxBssJYEnbpKSROAMC+BTJYL3nR6U/IwqkeApr7eW7paURpCnnvhmg+Em/foV8MPkJFA15idqZVEVMhIrzDG8QU/eBNFpddZ4fp2t5Ce04ia5PylQB1UN6MLGY9ykv1xc3rDUPizuuhK2Ar4JtRg/a7ywU0/RuH0c6WAUWtD4QwxITWFoe6olXQIrdFrPOZaL/wpQzIMCDgLbqmkhIcgmSBt1ISaSj2osZrmoOJ7LodqiqLsMKElidjRv/5yRYkG314brw6/WTc8WqByb549IKFhUpye5lnrvSwvtWaEQehlIWJHbqtkc7ZoPijRrYadC0+9+nmyq2rq7mP6qtYhXoedcSpE/+8S5FJOLX1OEaOLk5kBsDVy54fDHTWxn60cy4JSFozLKt3AMv2QzcP8tMrhp2k8Mqg1hB3Nd6zvSAb/8UfL/dLL0MzULXFJL+b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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


