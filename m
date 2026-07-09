Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BC73C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 17:40:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC0E26B0099; Thu,  9 Jul 2026 13:38:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B71EC6B009E; Thu,  9 Jul 2026 13:38:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAF406B00A0; Thu,  9 Jul 2026 13:38:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A0C776B0099
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:38:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 032871C1B5A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:38:49 +0000 (UTC)
X-FDA: 84969948420.27.DB33E70
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5F8BF1A0006
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:38:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q9MAZYgq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783618728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aaLZ4qQHTWCpyDQ2KoikzM0c17LkOMu3nd+8SI8LJ7w=;
	b=EYswxvLV9f8iSPC/v7J5rnpUeFEmtSi16tdW3LNdHkUC7eJp1qcz0rBLlzs1PfCr+OXg+N
	DQR7+vl2DIymRQ2Yj3mdgvDVVoCVrauM10BrbKCYgzgKyt6d4M2IigOpBXfeUcsJmK0BNu
	fFJO9zKeSihw2SDlYZNFR/lwYZK732M=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q9MAZYgq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783618728;
	b=RYaDErwoXGfs4GhSllYlEQ5BTZXamywQN+sKKmkdPtF2GZ9H0EqoLj6uLSC6iC8yQVPS/g
	3bRN7ahHsYosHRTwKLIdi1La9sNPSZzM8C7ST6riP03Am+LqwSHKoyCKVNm079UX8NQGJK
	H0MouMcov7MRE1eO4XjgDMtB+m6kfSo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F15DE6138D;
	Thu,  9 Jul 2026 17:38:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BB31F000E9;
	Thu,  9 Jul 2026 17:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783618727;
	bh=aaLZ4qQHTWCpyDQ2KoikzM0c17LkOMu3nd+8SI8LJ7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q9MAZYgqd/AF604CZnJbZbLaFer6tRk0e5tGoqdHjCLaSAysygltdttOz7CHzvkP7
	 SZ0FJBKUmsa9vNn7xkkeR1Tn5w9OGZ1zmvNG7qMHgkEXhLzzO2tsFhKmDU2ce441h4
	 0flKgGKNWdUhW7xc62VFWrdhOjJUMfhI1LWOGn9/zH6oKISWTCOdpw3/0HWv083Alk
	 QGq6kff+bWafVI8aQ+3Kgnj9xtWnEJ1kkwQH2AWrsMU/Pon/DPQ/RMSo0LXYuuehjK
	 dPzye3KrTsbLWbjqIG1THpLI8L0C47Wk4IhMn+mYmG51aYunAJe8gbVR9tv/ritmVP
	 d1ePOupxhseqg==
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
Subject: [PATCH v3 06/21] kho: move all memory retrieval logic to kho_mem_retrieve()
Date: Thu,  9 Jul 2026 19:37:55 +0200
Message-ID: <20260709173821.429921-7-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
In-Reply-To: <20260709173821.429921-1-pratyush@kernel.org>
References: <20260709173821.429921-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xdex1oncfm9iocnmzhy4hf54n6f5o5w5
X-Rspamd-Queue-Id: 5F8BF1A0006
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783618728-666553
X-HE-Meta: U2FsdGVkX19D0/n0ZRFlKSzayItUUIa3l00rlVXXq8OKK0xwjftEuyfWGrVFhfgDZ3tL01alL0b6p7KZLUOyPqQH32oLA330KdjWyd4/o23Z/Fn9VBG9zUJHpX8tlJQ5RFWMDyIhc0O06kTLsSHIV2L+3zctP+6UfxztOFjj4NlM7v4DlXDE1gdFMIo22Jhyj/vfwZPs2L1ipBBr94KM/c8WWTbj1WSY54zC03zK9wl4XliWCSwvvUHRfGzC7wxRs1xaHhauJKc5V5bmhDimFfvD5G20IegVZ0wsfEHaLEi5ieW1pcNb4ll8jwkAUZEX4idyvJDwo93ODKP4px/QyX8wIj3pt1PWYkYogX2YUEnmB+rxuqr0TQGIpy55HbSUwl3DklmI1kpAKlYxTcf/xwlX0ydidwjOXW9FrhU1jgV3757mNGvmqKkkqVbprtnWYtOLNn9NPdOAHcj4JPmh9Gc1foYdWWcV+UQyCLZ9ymOiDaDxED35Jmbns6FtlSzhtBHAFUTvEx6yHtq/EBT+pBQiWm7IQm519dO/fnNPAS1aAhScdsT8xmndA+m5yu7/Rx71tN5kJ34z9GWa64Niz0iyFbLz1Uu6UgzU+ks+o6uX4GgHva64SixStXBF+NU8Hxru3qjX4diE01V+Ejri6GNTqdLMK/4aZ5RLZy+ZgmB4h0HZJz9RVCiUsJUd3uUFOZa4Vt2b1wHZoBcZj2KD28D3y9h1/5L4qk239mwt1GtiuzDq9SfHOzqr/Ar1uzfyRJT5n92l67A5CZ+j4ZoUCDlt5Ws2R/ZgsUQHPScT38ky2+Zs8Lal0qdeCYhLP3VOb9FRcEwYt/k5vTqtze3zlM2ChbE2wsq4RtNXMMR5H+MC+zPEJqw0YlUUFFloafotTVA87d4yc/iZhIDtMRRj+y4gnZulmID/v/hGszFaYL7nDgdOCGX+rKKvS4dFpAAe7I1CdeDW4JendyvYtBb
 Of4MbqYp
 f4VX1Aio04oomWs1VKMpCOraPh2hrgCClQvtkjs6w8/F6tcoppo4L3MK8bRc6cHNDLptS1b0OQqYbn+zrgOpgui9448EZnqrgz8H9jnFbYborDV3cUS3ObDUCuvKMxwrSXL5mprC4Axn6ZWL7BtxgRkrslLoURBG2Ccuvl8olwxso0RoeL6QKqU7szo712pTDYbBPwEM9+UY6JwzKMHvlrkBxLP+V2mvOuu7XSoSZT6MUp5qnv/OiQgRYhsxr1PfldkUJs476XUd0ETz3Lfno2a7d5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

The memory retrieval logic is spread out across kho_mem_retrieve() and
kho_memory_init(). The incoming scratch area is initialized at
kho_memory_init(), and the error handling is done there too.

Consolidate all this logic into kho_mem_retrieve() to make the code
cleaner.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 31 ++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index b53ae68ca087..e3408e1844dc 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1415,8 +1415,13 @@ int kho_retrieve_subtree(const char *name, phys_addr_t *phys, size_t *size)
 }
 EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
 
-static int __init kho_mem_retrieve(const void *fdt)
+static void __init kho_mem_retrieve(void)
 {
+	const void *fdt = kho_get_fdt();
+	int err;
+
+	kho_scratch = phys_to_virt(kho_in.scratch_phys);
+
 	/*
 	 * kho_get_mem_map() should always succeed. If it fails, kho_populate()
 	 * catches that and never sets kho_in.scratch_phys, which stops memory
@@ -1424,8 +1429,16 @@ static int __init kho_mem_retrieve(const void *fdt)
 	 */
 	kho_in.radix_tree.root = kho_get_mem_map(fdt);
 	mutex_init(&kho_in.radix_tree.lock);
-	return kho_radix_walk_tree(&kho_in.radix_tree,
-				   kho_preserved_memory_reserve);
+
+	err = kho_radix_walk_tree(&kho_in.radix_tree, kho_preserved_memory_reserve);
+	if (err) {
+		/*
+		 * Failed to initialize preserved memory. Clear FDT and radix
+		 * so KHO users don't treat it as a KHO boot.
+		 */
+		kho_in.fdt_phys = 0;
+		kho_in.radix_tree.root = NULL;
+	}
 }
 
 static __init int kho_out_fdt_setup(void)
@@ -1629,16 +1642,10 @@ fs_initcall(kho_init);
 
 void __init kho_memory_init(void)
 {
-	if (kho_in.scratch_phys) {
-		kho_scratch = phys_to_virt(kho_in.scratch_phys);
-
-		if (kho_mem_retrieve(kho_get_fdt())) {
-			kho_in.fdt_phys = 0;
-			kho_in.radix_tree.root = NULL;
-		}
-	} else {
+	if (kho_in.scratch_phys)
+		kho_mem_retrieve();
+	else
 		kho_reserve_scratch();
-	}
 }
 
 void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
-- 
2.55.0.141.g00534a21ce-goog


