Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF8D0C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:56:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F71B6B0158; Wed, 29 Jul 2026 10:56:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A7BD6B015A; Wed, 29 Jul 2026 10:56:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E46E6B015B; Wed, 29 Jul 2026 10:56:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3DF226B0158
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:56:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B53E4140670
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:56:32 +0000 (UTC)
X-FDA: 85042115424.11.18B1669
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 28BD080006
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:56:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DUvShgph;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785336991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mmQtxiJQKd7IWjs9bi2BB93ctJ9Pw3cwj1Whq5yGN/M=;
	b=gDpOEjDk1sqF+zFeoQVasi76wsgZxftLtBRx9hmsu6IMeMhODpBuUufCS/XGkLBEoN6+TL
	kvKQLlU4hMMd+x2MXd+y9dEqcSxWMLP3pFa/xTcfsBhuCaRKr4yQwQtGfUhPRyConfKfia
	3/BiD2XsXYgiA47kEtKzK9k58TqzwgY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785336991;
	b=ibX5ntDkszDRGvQxUX8KMf1nwMRGYMZ8JbbINeWxMwRhIPSQ7xcpRO7KXmhkQ98KSTwlMN
	zAcVo7nMM7NKVFFwhaLBDIOqBDVc4sZ375xXprBgF22QQt2XpYPkflXjeG0eFI07u9zlX0
	PEKP3qtk6QDM17EviAvwnl2KH16oQ2A=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DUvShgph;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B14E0600C3;
	Wed, 29 Jul 2026 14:56:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF521F00A3D;
	Wed, 29 Jul 2026 14:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785336990;
	bh=mmQtxiJQKd7IWjs9bi2BB93ctJ9Pw3cwj1Whq5yGN/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DUvShgphV0HpF8KYUua/9LLKbfqc0fbegRrwSjbUVn8A+OnM+potPJQzEPd0AYvZE
	 MNFpBkNbD+DI6mtpj7p1nPmcXc5CID91D0KNIUGpZfxZF3bMpr50ncdpBsSu5QcyE8
	 xpDyqp+/2twCyV2kWaafcU9i108LC9rfGMSswE+Cq4YQ7eMGE9Si1+X9HQ7/96M1sG
	 KpNpLeG/bLIP8LvGFJDg3tQY4UOM/2Tg5AKwlSWxumQ6m1OzUSa9EWN65ImCPHhE3r
	 vy4TFapDE2nVXoLvxD5YGsLEK+5mpfUZl3wi4XsYdwKBtIy9rPYzP27yjbh+xqGkua
	 6xmdlIDXwNy1g==
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
Subject: [PATCH v5 03/22] kho: disallow wide keys in radix tree
Date: Wed, 29 Jul 2026 16:55:48 +0200
Message-ID: <20260729145610.2827231-4-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <20260729145610.2827231-1-pratyush@kernel.org>
References: <20260729145610.2827231-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 28BD080006
X-Stat-Signature: zd6rrwzpat3ins3ccxnib6qbufs8act9
X-Rspam-User: 
X-HE-Tag: 1785336990-200453
X-HE-Meta: U2FsdGVkX186vqkZhN71dnvcXRawqRNAxy8nq9NfkC/+Gy8HP9DXjzIHnZ2ymi3Z3PxgBPBvvIG8WysTqheJgaFRaQ/xPJdqwSvNT5EnhYNPcNkVLw5pbAv35OORWw6UAKnCrUPHOUOs3zI0IENUlzTNObOsi70svaoQLDHgO0dRzfj2sZzQzRF4r/e1ut4yKfHOC1GT4gtvuHk9nsZjVuQAh5Qz5zlUTgx18JXxZNParq9d66LZIZwojhnAEd34pF8ZOf6QhEGWtKEfL6C+Jnh7El599AfN36EvarU4hjXTITk+/MinphRDPVrjEuGabhIfUUJE92kv0H/+yW23hWNdGGtIMg05gEts5QIbacIfhxBP3XxUUHmsPSTvmGLWABkE4zQyHo7g63EPmf7cfeHPlHSSdmC05SyYiDlTE0RMa3Tum6rav4hO0GwSxIpzI5beCmmi8cy+UNdwG2EJzvOfB0TRQJNiQq1E4yzCjdqLMBy5IX+f1ipluEYT+142qq4YfBx6kFE0pzyaicz8NKKufF6h263Wro/B+0/Ee1u18poKNiXzyc4b56OXb3ndrVyguLaLic3W/tjRKqnx3W9ooDFZrqOcw9XFuMzv/N1ez0P8SlKYjhFLBopAEfDsuyEgwlcOqxvCKxj2X4BHTQiykJF7fzcCzN0wYRaItH41yJqRze9KOWQY3vzZKCFiYVlBDgYkpPB6aDW++UIlQskZzAl3yEqZ8z20ffQ8qFa2JbdSovAoS103c7xmkAoC1bji51VvWVwXNMIDfFgP8J8xGL/c0gWnLUQa2RhvcyLTODinWBO9GWgNFMFB4ubdWGY0Yey1JXGn72dRjVWYJY/dCWwBJrghEy83kV7X5ymqSdtEWgu9C07njAw1sSgBIu97kbTbTWpXBhRS4hcujzmhZww1yBLHt9KSfHDR80gfLXee+cYqD14KS2LfbBH983rkdjyCkRyuCA4hTDm
 ReMwg85p
 wwDWLKmnHlpNLZKmmw0G0HCFgIZ4z2Wev06Nx4dQNlZIRicAepDMer5IW0l5j7rpGHgCBmN9UvoZF3YG3k9CD+k+r/kW/nZJ1t69dTyLsvYfhP1qbO9g6H4dpIyJHdoH6B91lPwnLxcTXjI526Kb1Bb+nYNvwD6eaHySdanm4Gtlu/qGSHsKhTSthkUWP/rmy+jX6OByocM7oMkTa4PCrMUGgqCn9ejFId3uh+sLqvKV8Rgg=
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
2.55.0.508.g3f0d502094-goog


