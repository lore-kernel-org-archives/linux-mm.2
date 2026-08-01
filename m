Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF319C55174
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 08:49:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A6F16B0099; Sat,  1 Aug 2026 04:49:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 758BA6B009B; Sat,  1 Aug 2026 04:49:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D17A6B009D; Sat,  1 Aug 2026 04:49:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 321916B0099
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 04:49:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9EAC0160249
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:14 +0000 (UTC)
X-FDA: 85052076228.23.1C0A26D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 04334180007
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fH7Q9Co9;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785574153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JrkBED7KT85yC/ETBmppqUy4I2mZbe+o6Vny+4DxgfI=;
	b=c0rDBLxeZJ/BrdVwyv5VumMb38JG9H/UlzVy6M8Que9etsZUpYXyq941Og4uyvo8ENJO5b
	Y6doBtkuwUd9d0sNG88Rtq9biMN+9633UHNPr7m3/1Id7ZW8GGMG4OPg5F6HIohuZg/bFw
	ZcC2nxjaDYZgPKkSKfsSmjDnuZWysBQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fH7Q9Co9;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785574153;
	b=bCG0LBohtQ5+MCwfIeFT/mBqEHngyqibvgzl+X2bwcg9vKUXKBNfxcVWAUsPlqRSKdRRsN
	PquvUsOU7hwtW7jRawZKNMzftX+psUHzNIyPYmMtnSwPGcyD3IyMoq5xxIX24uVvW56ZCr
	MR/+eGW/QCIdoJ6Vrt5uAna4cfNmraY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9051B600D8;
	Sat,  1 Aug 2026 08:49:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA141F00ADF;
	Sat,  1 Aug 2026 08:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785574152;
	bh=JrkBED7KT85yC/ETBmppqUy4I2mZbe+o6Vny+4DxgfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fH7Q9Co90aLn4pZHLfAZHKWfqeqMxQkiyoH0OPMw0VHVNMpmMphb886dRHxBjKgyk
	 hgCD4TLiEdm/3FbUPTjPzskFtd81SO3AmO5HJEPLc09YD5I7EmU1BvxrUfXG6xluy4
	 d5KTBFzhuXUaKHTUqv94YyJTI9s++Vn6u1v55WZyuMnRZLGvWzNn0o/EVBDGPicrhE
	 FZNmgaehyZ3MDXkbnqxoHPUenEKjq384GWwLMNXI+QYkAfbQ0rSEY/7vlTg6+7V9aM
	 xmv3NYt8uCvxni9qfkiA0qJ2J4SL5uMrQ0OlnN7wRzedD7AjxrJCXBY3R8gOuEgE2g
	 U+X35ATmQq3Dg==
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
Subject: [PATCH v6 08/22] kho: add callback for table pages
Date: Sat,  1 Aug 2026 10:48:17 +0200
Message-ID: <20260801084833.1897543-9-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
In-Reply-To: <20260801084833.1897543-1-pratyush@kernel.org>
References: <20260801084833.1897543-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 04334180007
X-Rspamd-Server: rspam01
X-Stat-Signature: igrzsei79iuc4rjdu9bnu3fnpfbm9746
X-HE-Tag: 1785574152-884737
X-HE-Meta: U2FsdGVkX1+S4OrPpZi7gWIKZRgAiTikmfisrLb9NFNbyFeXZ3sFHekiIC3xGh4KxXzG7cPh2GtwcZeUBaHba61Ts8SPGD242PoN2a2nkl1aL6LCfDwzUiot4SUnpusBm3BH02200a2pkHi7EhUqRprK3ZhUrK0GsOsBfntjckCXgYov4Rc5pHEzUZ0paZq/qIhzZOYJfDV98uXg/OfFtwtUAo2BT6qRHfWTRmyJ2avtU1GJ5UzRyizSUkuWl1B8SGWPfdFkgR5U2+gzeUAO7spQluPyeJywE1d/lg2IJhrPdnV17U5C1fOLHHwwKatTBjDpil1jYldmTLbnNexbRFUyDXHvVU3kKHr2tGn58YStZrwlCqsIyW5WGZr3ipEr/vlTg0x2qTVbKIY1rymlCszSg8c4VBYRcXjo2+k16y9+CnoNKGbVR/XEPlAt7MrjvRvZk2BFfi9UNU0oJpkwX8al/Nb8CUnQGCTClA+DBa2Gc39A527ojRVtt4i48ZdgcGwfIDz6Ftsv/8Cb9xZjkhAQ4/gW/YGVSBYkY93Vd1YZI5Ks86aRHvLxXZ2+9YleaUgNfuVhF6rRR71cCpkOWJNbq9qBAfHVgC0CVSdfH+Yw6LOVLDLY2b30MQeIglR1ImWtdH28R7ia84ihSEhF0XarpP8xd6BXWZUU3eHyGKAwjkaO6gDiTX5HxKHQbDl+XuNhkqfVu+y/6EbD11yVg3m75fMCFS6SYS0J7bvBG61Tc4sc4kGGD3fo3lg+fB4L8jabEoqjlbuqxkWsCVKaoXNMDdscer+wR1brVXRBeVhUaZMoQvSFGU9wQay4h7Xf2bEjndOWWaaIHpYgR1Xk92s3bx6Ad0/CU+6f3yoqtkZ8ooDoLFE7aH2SKtM5pwacbH7933JhUaVNs6qYGvW+QJRDgw+0dAJ5YfK9CgYjNqElkLefdjuTb6a3sFSe0x8wfB+Dsm4PPnKOxAxuPk3
 C9b4WaVf
 cX+p34wSxPltlmMurRw2qwL+qMmtDG4rv1qb6SIk5qx+iuHiausK9iO/QsRN1pL9i0F2Z+63A+zyqMcTMOAPxBj5r9zZrw1eqvm8AcbmoBuoUMc+zosrcojBBRzlkLTxmy6x7DyvX3Oif9x/iLLJ8nRiFXP7CO/UmEnc2/ofHMgzPG2zmziqxJCkh0YVqGSFWj83hi/zY4L6UE/zpOoccE0XcJ6xq/XplB5l8rDQdhi9yo2F+DqfDAlxEXTfnbGZlGNCuEuBuTKS6/Yg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

The KHO memory preservation radix tree does not mark the table pages
themselves as preserved. This is done to avoid a circular dependency
where preserving a page can lead of allocating other preserved pages.
This means any walker looking for free ranges of memory outside of
scratch areas will ignore the table

Add a table callback that is invoked for each table page. The callback
is given the physical address of the table page.

This is useful for the upcoming mechanism that discovers blocks of
memory with no preserved pages and lets them be used for boot memory.

Another use case is for users of the radix tree other than KHO itself.
The radix tree does not preserve its own pages due to the circular
dependency described above. But external users of the radix tree would
need to preserve and restore their pages for the radix tree to survive
past early boot. They can use this callback to do so.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/kho_radix_tree.h     |  3 +++
 kernel/liveupdate/kexec_handover.c | 12 ++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho_radix_tree.h
index 486e193d58f4..902bbeddcbb7 100644
--- a/include/linux/kho_radix_tree.h
+++ b/include/linux/kho_radix_tree.h
@@ -41,12 +41,15 @@ struct kho_radix_tree {
 /**
  * struct kho_radix_walk_cb - Callbacks for KHO radix tree walk.
  * @leaf:      Called on each present key in the radix tree.
+ * @node:      Called on each node of the radix tree itself. Receives the
+ *             physical address of the page containing the node.
  *
  * For each callback, a return value of 0 continues the walk and a non-zero
  * return value is directly returned to the caller.
  */
 struct kho_radix_walk_cb {
 	int (*leaf)(unsigned long key);
+	int (*node)(phys_addr_t phys);
 };
 
 #ifdef CONFIG_KEXEC_HANDOVER
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 9fb07c0ef18e..2044f35cf1de 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -288,6 +288,12 @@ static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf, unsigned long key,
 	unsigned int i;
 	int err;
 
+	if (cb->node) {
+		err = cb->node(virt_to_phys(leaf));
+		if (err)
+			return err;
+	}
+
 	if (!cb->leaf)
 		return 0;
 
@@ -310,6 +316,12 @@ static int __kho_radix_walk_tree(struct kho_radix_node *root,
 	unsigned int shift;
 	int err;
 
+	if (cb->node) {
+		err = cb->node(virt_to_phys(root));
+		if (err)
+			return err;
+	}
+
 	for (i = 0; i < PAGE_SIZE / sizeof(phys_addr_t); i++) {
 		if (!root->table[i])
 			continue;
-- 
2.55.0.571.g244d577d93-goog


