Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C614606A8BA
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 14:26:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 552BD6B05BE; Thu, 12 Nov 2026 09:25:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B5086B05BF; Thu, 12 Nov 2026 09:25:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37C5B6B05C0; Thu, 12 Nov 2026 09:25:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 14E6F6B05BE
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:25:47 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9C325140579
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:25:46 +0000 (UTC)
X-FDA: 85426690692.06.92D9FDA
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id A44FD40005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:25:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf11.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794493544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w7T2ylc9Guag4RlzXlw1wbZ6igDDXq/UphBkpee43Ak=;
	b=H4BInfRPQXdgF7zI1Vkx7d7y0cXVijVUFiU3LpOMlNZQ8IX/w+SZ9yN7MTSRE6feVGipW8
	lusLwdHBiaW/l10Z0kNfh2y6Clo5qbcVK8AadVLYmAlbPJMpxT33nLgif0v8dEYMBpgSDR
	fsfuiSZe9MEkhGGSN3cFLYDgzbXjVzs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf11.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794493544;
	b=WZqF15Oo5yugVUar2I3sTj+oyunt2tJCjse7gAy2rjO0jes6IeQSsBm1O/l5PxhkXbGqOD
	FATJEK8tqsFMH2SsOkxD+kSwalZfBSfodlveZNvUKcIfeYzuxAgAAkVLzo4wDWeoW0KhsS
	TdugEm252PlP5iHg8i60JZIVZElpFLk=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AB13C1F7B9;
	Thu, 12 Nov 2026 14:25:43 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5FDE913432;
	Thu, 12 Nov 2026 14:25:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id w9GzDFnM9WoAPwAAD6G6ig:T10
	(envelope-from <clopez@suse.de>); Thu, 12 Nov 2026 14:25:42 +0000
From: =?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
To: kvm@vger.kernel.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	peterx@redhat.com,
	ljs@kernel.org,
	imbrenda@linux.ibm.com,
	borntraeger@linux.ibm.com,
	frankja@linux.ibm.com,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Andreas Grapentin <gra@linux.ibm.com>,
	Marc Zyngier <maz@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>
Subject: [PATCH v3 9/9] KVM: s390: don't unmap the gmap on permission upgrade
Date: Thu, 12 Nov 2026 15:20:38 +0100
Message-ID: <20261112142039.907090-11-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261112142039.907090-2-clopez@suse.de>
References: <20261112142039.907090-2-clopez@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spam-Score: -4.00
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A44FD40005
X-Stat-Signature: ofjmphjsf7znn4oi6jo1coaze7d61dje
X-Rspam-User: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794493544-862775
X-HE-Meta: U2FsdGVkX1/LRf17tXC1UAoSQWyERpCGOovCvz+AhsAqyuX2arNQpfHsyZs7WE4FrhY+AuJoXYhB+IUkgNe8z4gU5RpNJERHxokF+6jK0a3a7OmgQ7nDboNRtsZqVEDivWbHnXUzEBQrb7OMdE27lKz1nKCO4bs/D9lKE9UvGamLtctbhlGtDXjJki8G4+p0t0GcidSm8/8Wl6oXv6zvB09ku0OkKfsJhotM7xE4RDYdAe2d2Xxz+gchelUah5eo15ZNwutO1/2q+854+GCfncjj/Io02Wvrnr3VPRQxFn1S+aF0MYqH9guYcutEQHnNCWP5T2NCYSTQMF8OyS5Ysv+II8gC2prgdjBa4ixnJ5HfRFPXL2OS3WZDFTlp31OIC7sdZupc4Hq9j0sQWnU4JjoJzBuVpYDnLbBVHNxao8fyIWplAKHYmhvWqHEcu9Qsu5DndMQ9aF7dn2WnXCCdAF2Kp5CBXhrnA2O8CnZqsPGYy9BrpjHOznYEmG4PFsZ5LoIGXzzrJo5yOWI0wE5p40Hf/jVk7FDtJ4JLQ5MORwybjsxzDoZtSFPSHWhShpn4q24j7y/CZBqhocuMpP6pJDKl92DIomheRlJET2P3OqlcZynoS8O8vTFLUjiPXdwrm1KSHb1MMbX/L6NxzdyRn3ffzMnszaCJ8jGYiUxkeDQUNRCQjWa71oUnl7nD2wrfZboOdboF8J9dE7SQeWU8KmlAX9QDW9v9j47urrE/4l3mMtebNZpBmRA0tyyoRQYh962ROCuEWjyyDnW9VWSl8F6qb3Wuw3FB4YwN+Evd7JBmiijAmCZQHXgI2j+Z0qlCW7uAsrc3jEFtGu9MgNP4DrpdhJiTEazhcYP5LaY1dOlXQHzhk498n21nfqRQ8vmxUFaLjWYmZVCc3eDZDEeBg6xUqk5hB1/NgkrvUOW2v4dBl1iHolh8WORiFzQuUN5G09dVniPU+6xa7PW/gy0
 HUanSthT
 STB6WXigJlce8MiswqUYoOAyyiYQgjXNfOvWbcwtrYXJkOkqNhB+E9fv8Q6CB38FLz6WTQxWleFxTKDe0KkdNbqODp5Fy/d9YnZslEyUOwVNHvs4hdYmRmf46GtILe6qGatPtPNAH73uG6OtuKpy1sbMfN3ps9tAuF7PpXU/1y/n0Y6GMMJgDs4F2CA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When an mmu_notifier invalidation only upgrades permissions
(MMU_NOTIFIER_RANGE_PERM_UPGRADE), keep the existing gmap entries
instead of unmapping them. The PFN is unchanged and no access is
revoked, so an existing entry is no more permissive than the new host
PTE.

A write to an entry that is still read-only causes a protection
exception, which kvm_s390_faultin_gfn() handles as a write fault. This
applies to both s390 and arm64 guests.

Signed-off-by: Carlos López <clopez@suse.de>
---
 arch/s390/kvm/arm64/arm.c | 7 +++++++
 arch/s390/kvm/s390/s390.c | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/s390/kvm/arm64/arm.c b/arch/s390/kvm/arm64/arm.c
index bd9d85235f43..5aee1817aad8 100644
--- a/arch/s390/kvm/arm64/arm.c
+++ b/arch/s390/kvm/arm64/arm.c
@@ -678,6 +678,13 @@ void kvm_arch_commit_memory_region(struct kvm *kvm, struct kvm_memory_slot *old,
 
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
+	/*
+	 * Do not bother unmapping if this is only a protection upgrade.
+	 * Permissions will be faulted-in on demand.
+	 */
+	if (range->flags & MMU_NOTIFIER_RANGE_PERM_UPGRADE)
+		return false;
+
 	return gmap_unmap_gfn_range(kvm->arch.gmap, range->slot, range->start, range->end);
 }
 
diff --git a/arch/s390/kvm/s390/s390.c b/arch/s390/kvm/s390/s390.c
index 18fb200f854a..954bf6b64683 100644
--- a/arch/s390/kvm/s390/s390.c
+++ b/arch/s390/kvm/s390/s390.c
@@ -5871,6 +5871,13 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
  */
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
+	/*
+	 * Do not bother unmapping if this is only a protection upgrade.
+	 * Permissions will be faulted-in on demand.
+	 */
+	if (range->flags & MMU_NOTIFIER_RANGE_PERM_UPGRADE)
+		return false;
+
 	return gmap_unmap_gfn_range(kvm->arch.gmap, range->slot, range->start, range->end);
 }
 
-- 
2.51.0


