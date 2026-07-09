Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9B44C44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 17:41:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4C3F6B009F; Thu,  9 Jul 2026 13:39:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD58B6B00A0; Thu,  9 Jul 2026 13:39:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EB9D6B00A1; Thu,  9 Jul 2026 13:39:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 53B4D6B009F
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:39:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 064F340279
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:38:55 +0000 (UTC)
X-FDA: 84969948630.19.9FF55AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6CF4DC0007
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:38:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N3qST223;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783618733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dZrYQiJ29bguTf5G1/05HWK+MxMmFmBLRrxhZmbaDdk=;
	b=AVirONkIZC/XX19NzM/mG0CpeBDL4X0QEJrIhj4f9UJ1/l8/ATx4AhPI5+9gZHyvb2QuO6
	0W0ML6M23ah6JpieMtWsQkqILujcPii7NS3i3KbtAoQN0PjPXbNfQNDDPDi8+4ZCMlGf9o
	zkmB/KEzfc8jDGJjTIRT10+9zo4HhcQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N3qST223;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783618733;
	b=zn6l3/INWeZ05hDb8Yiknh31eEuhcJpBR/Xn0wc2onKTpLRbKLSMqdRQF3eqw7YNdMYSjn
	phXIB5sy2FqqRbEY10e3ZMJ8D9es0sfujXTMQ5nj9XXXd1XNIBeDmSEwSB2rvgvchQq7HM
	fyUg8Kh3+sz3ZMO5By60Oz/iV7EZAX8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 120166138B;
	Thu,  9 Jul 2026 17:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997851F00A3D;
	Thu,  9 Jul 2026 17:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783618732;
	bh=dZrYQiJ29bguTf5G1/05HWK+MxMmFmBLRrxhZmbaDdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N3qST223sfLQcdLUCumgNGqT1rNBeaftKWwMFJBNnkQ6p7LobmHP9UQf7gkut5Hwa
	 frQGl78LM7YpDCKcYypaVEg18SV+03j5mSz/q5Ykmo69+kwVKwiUMnBFpnM/5lflL4
	 eyqR00NFqyciItVQkCCbILPtv0KeM27+HBUrafLX8E7HD5CVKSQTnS3vaudkB3cYx1
	 5Au8w6IjYanFpidYYx18d5ewnHKjPe+aPONYHHpGWTovQ1RglaZPwIRMbkytuiaGW8
	 Y8uJknYsgRPfHYpeG6g2oyUkkmbRjI0e003G5vaOPijUv8Tx6+Mckx8p2GAY+PloKp
	 A90q/HySNLLAA==
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
Subject: [PATCH v3 08/21] kho: add callback for table pages
Date: Thu,  9 Jul 2026 19:37:57 +0200
Message-ID: <20260709173821.429921-9-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
In-Reply-To: <20260709173821.429921-1-pratyush@kernel.org>
References: <20260709173821.429921-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xh84q9xn6hgps7q4d65ganaopyh85153
X-Rspamd-Queue-Id: 6CF4DC0007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783618733-4757
X-HE-Meta: U2FsdGVkX18JSL2rnJ4fqeuZuu3m5KKcLO1u7Xqyndjp00AzQ2O4HMptT5SoExVcACUmS09lQJn8GI/ngYdq2jvEbC4nNTF9Cd5y46iepZYgyvmF5NkgPr9GZTIIX6/FR70wLUxDRc7BWqPI9mmHen5luqBH2IASSaWbEQzwXjIV5GYgLzT0Eic45bWtdkpxYTVJshyhI3J7+AAqiOOslxd5A9c1MWuTAaxfJpebtfRPEhVkElwf9i9pu+DoomCvLObO+JvQQvAf/5hD+qPwKhtBc1OSj62a5smUR7Rgw1M7TiOkcUWw9kOT0gBZNXivo6cbbJxwKJjKkb9+2uSaOrVVFyjpWqQM1zRnFN4gWorf1+r+A2cDZm4do877yQmzGqH3pBTIIGtwTp2hFc+2ILMjojVXmMqH5ouVIwy3cF6PzGvjPHUdAFfy2SCNRfaLd8NM/rz+MW0lSQkOl/xe0/3dT29tyKzkknqVn05gOOHFKUa8x0oxM2IWD4Ano9jXg/jIlvvLLJAvA7yKI3PSj67RnSYhdrTnFc91qUL7eL+aRFJh8Eyh6kXkdVP/cL7ady9BrhSHKsj4r1Xv6UbkIsr0qzqzH1BDRxB1nFm9hLNjhPoeVpBZYhN5Tlozj3SdBsE8aU70sGHzYcX2KrFbqOVdyCo8nBjPGJHOcajZadQ+ieA7TP1sBTw568lIP8g+Oi6rIbTS2yJ1jIwd0IurUj11und9PDrlu63xZ1k1uN1GZ349D9+zBl4z2n1b5bUeD5+FcXMCA4CXTSIHldqSLfs/qcc4/dVDthh9QUGl08tPWY6vRCOld1cBwVioLlkjQBRpnO+DG31Mn7fCRX2Ds0ZK16eNSUPpeIURf1hufBGoRMJJJ43TZWFZpYQCROZJoLYvGGH4tWDfoqP1WUZULT2dTLLIBeAbLrdTiqNixTTB9Q8O40r+GZ1Dw0d1CYASNUBc6m0tme+b5iFdyJx
 esFdmJfy
 6nyAl5JrzUAlK16Bkl1LavrpOEdIYbpv2A/mgeN6AY4U87I+xfi/iEB9Fjt/c0ahTkFOa6sr5sR1mE0RHjFjkwdg9v1hnRcOR3ajNYtujQ3tBes1DFGodLTAOId3sSH2x5GYmRTGzZl/Hlk3t0wN5BlStyk3hiGEsYAm4ADTeHhWeI/t0dEHGRNS8CQVqDlGz9CsV9xmr+p0cI4FM3K1XXB5fE84McS3VuVGzY4/s8IdeRVTbPiPwIzzlCqHrSPJHTiya366XAMzOxck=
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
index 426a9cc9bcde..ac7ba7e567e1 100644
--- a/include/linux/kho_radix_tree.h
+++ b/include/linux/kho_radix_tree.h
@@ -37,12 +37,15 @@ struct kho_radix_tree {
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
2.55.0.141.g00534a21ce-goog


