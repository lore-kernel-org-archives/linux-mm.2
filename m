Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93C7160A2604
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 14:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=FBQ+msAQ;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=50oxv05B;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=FBQ+msAQ;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=50oxv05B
Received: by kanga.kvack.org (Postfix)
	id 6E09F6B05C6; Thu, 29 Oct 2026 10:44:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B8256B05C7; Thu, 29 Oct 2026 10:44:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CD616B05C8; Thu, 29 Oct 2026 10:44:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 256836B05C6
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:44:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 948771203E1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:44:45 +0000 (UTC)
X-FDA: 85375935330.16.711FCAA
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6F43C1C000F
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:44:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FBQ+msAQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=50oxv05B;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FBQ+msAQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=50oxv05B;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf20.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793285083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GzhVoZib0ILEyLkVLyiQGLJMK7BbWA6VG7i+o0PVJto=;
	b=hVa3x2bZY42+Lucx2sqBgPMqhwqTHo2/GGkGvqodGvXegwBxY/dx6d0rIj22kr675V9M25
	TQ5bLik4aN4iJB2NJROKWPuKyIcHhwYwNn5sWmEJNV2dUwblgebdrCzQ3x81ZQUx2HXXwo
	yZjVFfnAwvydSAAeaDF50aubNunV1bA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FBQ+msAQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=50oxv05B;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FBQ+msAQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=50oxv05B;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf20.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793285083;
	b=IDt0E9A4DJvK42yRVtuZ0v/mRQSPdDWBEKKNdL1tVxKK+hJ8rVK47JIGQFMRmzriic8tzP
	2JEGL25zQouNQWeUEYq6bM6xzwb9KVd9QIuTZJQTQ1Mtf8AdxhawLV5e15oPDI1/+VTmtx
	5tuavsH+CSEsTZMlLWyZxHyiGMMf1t4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5F0B31F7BB;
	Thu, 29 Oct 2026 14:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793285082; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GzhVoZib0ILEyLkVLyiQGLJMK7BbWA6VG7i+o0PVJto=;
	b=FBQ+msAQwGPWfOlG0Y23qoGPR/RfctRnamOh6HCzvxwFFZb1Glq3JIJwRCbAHG+/X0uk+0
	+VIQMKrj6DSHbPMQoRWEwmA51tp4kVsW9K912w4YRyzc7TfkhQMTI5xXWrFUM5p5U52q5z
	4fzEcMGN/URISqGi3wB/qv5M8/VVuNI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793285082;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GzhVoZib0ILEyLkVLyiQGLJMK7BbWA6VG7i+o0PVJto=;
	b=50oxv05BuMTzzjIcFlmKyLDLyP3l+Q19Uy6YoGw6837vhZ3SjvorOodAG0d0zkgbk9gOxM
	TW1UiXiKnOu4ACAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793285082; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GzhVoZib0ILEyLkVLyiQGLJMK7BbWA6VG7i+o0PVJto=;
	b=FBQ+msAQwGPWfOlG0Y23qoGPR/RfctRnamOh6HCzvxwFFZb1Glq3JIJwRCbAHG+/X0uk+0
	+VIQMKrj6DSHbPMQoRWEwmA51tp4kVsW9K912w4YRyzc7TfkhQMTI5xXWrFUM5p5U52q5z
	4fzEcMGN/URISqGi3wB/qv5M8/VVuNI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793285082;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GzhVoZib0ILEyLkVLyiQGLJMK7BbWA6VG7i+o0PVJto=;
	b=50oxv05BuMTzzjIcFlmKyLDLyP3l+Q19Uy6YoGw6837vhZ3SjvorOodAG0d0zkgbk9gOxM
	TW1UiXiKnOu4ACAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3BD531342D;
	Thu, 29 Oct 2026 14:44:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iNqFENhb42qRUwAAD6G6ig:T2
	(envelope-from <clopez@suse.de>); Thu, 29 Oct 2026 14:44:41 +0000
From: =?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
To: kvm@vger.kernel.org,
	linux-mm@kvack.org,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: linux-s390@vger.kernel.org,
	imbrenda@linux.ibm.com,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH 1/4] mm/mprotect: add MM_CP_PERM_UPGRADE
Date: Thu, 29 Oct 2026 15:33:34 +0100
Message-ID: <20261029143336.390231-4-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261029143336.390231-3-clopez@suse.de>
References: <20261029143336.390231-3-clopez@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Score: -16.30
X-Spam-Level: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6F43C1C000F
X-Stat-Signature: 3sqd9sd39c9p8ah99rbai3ux8mkndu8w
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793285083-11005
X-HE-Meta: U2FsdGVkX1/U+9QCa+yaeOoO2/TrurGesY1RWYR64lXBA6Xfnp3jmYEVgRt1zUx6hCT61XwS9F8/7SNsLblPn2W6vUq3kTDfcWkm8Yh/R9jOhFko2lqJKP3Ia0MZ5NVOh0KXFkRSGGfMmS3Lfj5qfKKbneaMqqWHpLHWsXyw1pa3UVFq7qBiG+pHuRJyJeMKXmr3M9Nn37fDsSETmeBWIQRNJ/O13CzQXIIZgaeAf4WvzjMV+bT7yX8rdEFajhNTmtalIOApcbZ2TuHa4IVMkWD1Wm8GY1L4GBqploNhar3wflDPGssE9s65W5p9hVx76SEPCQtAUoV9IX4Z/3EVMqQnS2jzYkEIejiErJyJU7WJvMoJGYy5OSuJE0fDAxwe1ThWOHLABvrpz1F3irhT+d0x8maRETelUp2NMPVKnfXyxdr1K+wwk6tHFSFYzN+YhBw/0PQpGkn6l9PcxdWk2HmEOxkj2zZVy0pw9XPFM/NK1wXAZtEqqG3UDYZKJXk0xC56Brvns6XzVZsJ1zOesrxukNNPRltB+Y2oG4+Nu9I7LoMFJsdidIyx4Dul34sWB3GF+jnpVmrJ8/69Ri+YSoon6NDPg8qC0hQLTJ9yygbT8MqbRszlDMcQqA1MyEQCzFyq/rvn9lTJKkauIeQjlVuc1l6XMDj7239TT/U7g9ig+N4JMUf4JhYVkqgKKPoC7NDqW5Ws1fytAkKCyEciD8eG37CD+ceYGDt7J4Q/pwmgsXtuNnu+qHGJBQ2MC2r0W39Rp0lDy2jAEIx8vMd7JUZuAWI3drnl02fgfLLsJKotHHAqOlQefEdFo6ekmLvS/wL426ULpdg4BnvNe/qsUh2MGSZoGNBFFzp3ifz1QUGxSDu8/uQ078/g2hEAJTNLTY5S4sNAZpQkxPOUmf/bLY/bipSeZrZa7Zbtcov8PGdUAsmwhenDOBwlRIppky3OBzjMq8euDBBBAmMukxK
 G8TTZO78
 JfT5EOxlppgyM9vkJxfi3hPh+cI8STTD6cG6ZVTJiqe5JxELIm8omJEJphqgF7JbluA7Z7qrmkXW+gT+qr+R7tIUkhpfMWiTQ3rHzeRUNduK67vv5tRht44fr303EtYANr7kVnLUYwWgmnt8Q67wsYu+IbUUlhMuGwiiFTLHE9W+InjE/chvLA53it2cCYzN/FpmTgJ5DsyaW78GNgMC1slr/vEOZNDHvlEaFIR9YiOJr/ZYS2RJkW3i32LSKkDi+WejNR3T60jGqY0Q+5jq2N26av4GzZk6NfZhD70PZy4I2grrElg94CqTgZI3s69KTWKs1S7zbytf/DBgPLDECrXX09aIyezFUv6GNSLmCBsG384hk3KlyTFPdqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a change_protection() flag for changes that only add permissions:
the PFN stays the same and no access is revoked. mprotect() sets it when
the new VMA permissions are a superset of the old, and the protection
key is unchanged.

This will allow MMU notifier users to perform optimizations, as they
can avoid invalidating PTEs whose permissions can be faulted in.

Signed-off-by: Carlos López <clopez@suse.de>
---
 include/linux/mm.h |  2 ++
 mm/mprotect.c      | 13 +++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 691cef038d1e..f406ce9d1032 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3415,6 +3415,8 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen);
 #define  MM_CP_UFFD_RWP_RESOLVE            (1UL << 5) /* resolve rwp */
 #define  MM_CP_UFFD_RWP_ALL                (MM_CP_UFFD_RWP | \
 					    MM_CP_UFFD_RWP_RESOLVE)
+/* Whether this change only upgrades/adds permissions */
+#define  MM_CP_PERM_UPGRADE                (1UL << 6)
 
 bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
 			     pte_t pte);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 2888ee638d87..e9b636809c42 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -756,6 +756,17 @@ static const struct mm_walk_ops prot_none_walk_ops = {
 	.walk_lock		= PGWALK_WRLOCK,
 };
 
+static bool vma_flags_is_perm_upgrade(vma_flags_t old_vma_flags,
+				       vma_flags_t new_vma_flags)
+{
+	vm_flags_t old = vma_flags_to_legacy(old_vma_flags);
+	vm_flags_t new = vma_flags_to_legacy(new_vma_flags);
+	vm_flags_t rwx = VM_READ | VM_WRITE | VM_EXEC;
+
+	return !(old & rwx & ~new) &&
+	       (old & ARCH_VM_PKEY_FLAGS) == (new & ARCH_VM_PKEY_FLAGS);
+}
+
 int
 mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 	       struct vm_area_struct *vma, struct vm_area_struct **pprev,
@@ -837,6 +848,8 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 	vma_flags_reset_once(vma, &new_vma_flags);
 	if (vma_wants_manual_pte_write_upgrade(vma))
 		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
+	if (vma_flags_is_perm_upgrade(old_vma_flags, new_vma_flags))
+		mm_cp_flags |= MM_CP_PERM_UPGRADE;
 	vma_set_page_prot(vma);
 
 	change_protection(tlb, vma, start, end, mm_cp_flags);
-- 
2.51.0


