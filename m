Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87C88C55179
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 08:49:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 473286B0088; Sat,  1 Aug 2026 04:49:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FBF96B008A; Sat,  1 Aug 2026 04:49:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EBB06B0092; Sat,  1 Aug 2026 04:49:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 107CE6B0088
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 04:49:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7A73E1C064B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:02 +0000 (UTC)
X-FDA: 85052075724.24.CA83210
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 064BEC0002
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iN6maE3x;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785574141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+OQu0ViRo+OKTRZtwaee8K/r5CdM00+NfXwsPcZOUfQ=;
	b=Kc67p63aGIt1jKho5LcHpMJ9zwYx5i+0elGAVSIDR5z1nq8tK+kAiAlaDqXGPlkvFeO11S
	KrBh6TStqOCDyPvSU+TEjAoiyD/ezi9VP8nq4r/spdBMUjT+g0FF0Fp/yXFEmcZg3RlBNa
	2SeNgb6Mtm4d69LqmRalgpKAaN7u2Qs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785574141;
	b=7MssY5faz3PDmmdZApRly0xYr6JQUIxn2PP/967qriAjoDI8Ww6rR98pXirnohxYzUlfWy
	L/xZgEV9ZsxewNidorVCH8SLu+sNTVuzUWBqm3G8kT6uig5FiCCfNoK7rkTs8fdMUbvmHa
	kJQAvxex4RNXnsof6SgTV65lJ/8T8Ys=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iN6maE3x;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A7B8160AA4;
	Sat,  1 Aug 2026 08:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375B71F00ADB;
	Sat,  1 Aug 2026 08:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785574139;
	bh=+OQu0ViRo+OKTRZtwaee8K/r5CdM00+NfXwsPcZOUfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iN6maE3xvRcvR9jUGbwce4rn96e5OwQIjdICPdPSrYF8kYF+fzXqXuSbf13He+JhU
	 Pr5+jVVB2uie3CfEUIAY0LPGj7jLGkqeJkecAExLNEV44UkmthUtGbyOivpi31JwDA
	 wp8sb1Yh2r4W9SVGP1recS3Ehlctyc9rgXdbenDouG07UMdUv5+e+mI8EHzW7/Eiot
	 HwMzW0I0eZZaichos3gsrd9zGAIN2J8Lko1akYOl36He7VFzCLONjkFIZ5rxU5/n9L
	 4rOBjqxuNRpv22rz+iCjQkekW8Eh9fmzalOwDd2RD6md8bNVSyktoSHfYTgF92oiQM
	 KKZfhF7CY3YOA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 03/22] kho: disallow wide keys in radix tree
Date: Sat,  1 Aug 2026 10:48:12 +0200
Message-ID: <20260801084833.1897543-4-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
In-Reply-To: <20260801084833.1897543-1-pratyush@kernel.org>
References: <20260801084833.1897543-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 65cudeuwqpq6oo8be9nb6wnx6ake71rs
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 064BEC0002
X-HE-Tag: 1785574140-146711
X-HE-Meta: U2FsdGVkX182c5LMwKkC0eIBc3Nzdquot3b1cAAylPRS3Ny8hz/jO3sMj14gRxP5S2fmm39UqNXsAh/4Dyxwke3N8Ozq3SzfE9H5+gFgnp2SC6DKYcEE6TtTfSydLOZlRm/taogttZa0Km2KJEyWZ3T5/P32bN9jSsQ4iPz9yoL1THDplb7VHV6JhFMaUsdgzvHboP1lHG3TMTLLm3Ridy+10KAkrr5eaGoD0BXUsGAtBbPnz7YKwLq0Y+0z7++Ox5c6mQL3RizaM3Po7S+Y3YuphqCQpRUQ00J3a0U77FMsrCtWz2o6oF3K4C4eIzNe1Vc5xl3TLoyCAsmUXA+fyWXOgDOMTfBQtFQblka9hdm/5hDYvk/TO/5VwX0ye/DFe7g1ct24v0VwQrrmArio4U6MVQYPYUhH85AaJOLnADcmvZrXri8T3snCKtFoHXcMhigDmMUpsuVfUstssnGfCy9l/sMQ4JsFIzGzFXHyBZqcvyP+LpTTO/X/tTTNexS/SgEGdZ4ThRHMtgz9o5DA/cKgDq1gWkIgIZ0aXtiWI8z/pDJZVMQyirv7wkUHpBEAi1YBzrzNZC6gAKsfI5H0idALurnXcOpUMLmHRtWEg7y40Xwcljey6X8suqoBZntUKcVdwtnupMmTVocSCHIirNraRFUDS/Fg5H1LPIqBmWHUMBp/yr/qHZDpus9tdC0TaXCnLGcvRN7yKAG/k0USdkydaYTohi8YYIjytlkaXDEFgJmLHXSD7V6WWzSDXKjn02w330ziDHkHQVMNiKd7WOxwdNivrLoqn7ujmZo5oFOLOaGSTRe9Fd69FOg2eXcJbeDnpcEy4Bsk4of0R5Uth9HJYL6s+Ux2J7kyu67sxifoAgyraf8rENukF4k29cClO8vq+SefIMt1WYV27ojWylrgm3/JEBiL4Gk7WWBXfK1wci5xqxGUmzHQkfGjFklIqW840P3K/FjoRQqQTxH
 PVOKtset
 xwkmVNemNd5VnDEezt8ezyTly1ncr98eR7xUrd/Vyp2i25C7ZwRUFxgllPVzDvf1UQZClzvfDclzCY7gSF7down9gZTAZ+bAIEHv0y4sFTQo4qh/HidFxlidF0PwdGgolez7LSUbMeVgF69P4Co+vBUXl9rnWcAQgQ4uQ9GczAzXlPlHkafqlYiHR5F5OzJhGvmrWi+efHXJ3nSNh4Qn6wcLMUN3HobeP3q2whAP5BuJLaEo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

The KHO radix tree was designed to track preserved pages. So it does not
provide the capability to track any 64-bit key. Instead, it limits the
key width to how much it needs for tracking PFNs and their orders.
Limiting the width reduces the number of levels in the tree.

KHO is not expected to be the only user of the radix tree. With the API
generalized to allow other users, now it is possible to add any key to
the tree.

Check the key width at kho_radix_add_key(), and error out if it exceeds
what the tree can handle. Do this instead of increasing the tree depth
since right now there are no users that need to use wider keys, so this
avoids memory overhead and ABI breakage.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index ea24f23ce292..e7451743b87e 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -156,6 +156,11 @@ static unsigned long kho_radix_get_table_index(unsigned long key,
  * intermediate nodes do not exist along the path, they are allocated and added
  * to the tree.
  *
+ * NOTE: Currently only keys of width up to %KHO_RADIX_KEY_WIDTH are supported.
+ * This limit only exists because current users of the radix tree don't use more
+ * than that. Changing the maximum width requires changing the tree depth, which
+ * needs bumping the ABI version.
+ *
  * Return: 0 on success, or a negative error code on failure.
  */
 int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key)
@@ -172,6 +177,9 @@ int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key)
 	if (WARN_ON_ONCE(!tree->root))
 		return -EINVAL;
 
+	if (unlikely(fls64(key) > KHO_RADIX_KEY_WIDTH))
+		return -ERANGE;
+
 	might_sleep();
 
 	guard(mutex)(&tree->lock);
@@ -244,6 +252,10 @@ void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key)
 	if (WARN_ON_ONCE(!tree->root))
 		return;
 
+	/* Keys wider than KHO_RADIX_KEY_WIDTH are not allowed to be added. */
+	if (unlikely(fls64(key) > KHO_RADIX_KEY_WIDTH))
+		return;
+
 	might_sleep();
 
 	guard(mutex)(&tree->lock);
-- 
2.55.0.571.g244d577d93-goog


