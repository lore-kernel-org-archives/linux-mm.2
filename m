Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49F2360A3802
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 17:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=q7V7OJU5;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=HQIptzs2;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=q7V7OJU5;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=HQIptzs2
Received: by kanga.kvack.org (Postfix)
	id 67E056B05C6; Thu,  5 Nov 2026 12:01:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FAEA6B05C7; Thu,  5 Nov 2026 12:01:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EA116B05C8; Thu,  5 Nov 2026 12:01:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3101C6B05C6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:01:06 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B9DD8120883
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:01:05 +0000 (UTC)
X-FDA: 85401680490.11.11928D9
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8DA592000E
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:01:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=q7V7OJU5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HQIptzs2;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=q7V7OJU5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HQIptzs2;
	spf=pass (imf13.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793898063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xEZ9JJfmqsHwOWZ8ElxjeuHq5z5hpn3BAo1KSIMWKNg=;
	b=ZjPcgdh05hvk6doij5VwJmDfrPiGhr+hbQ7/jzDlk+De627TkIkkNhjMBUzQmVKqNBsaMH
	DP41L5q2DwNN2KFQZmNfy7q4EQMy1jeZ1Jbxz36eJZb7uDU6PoErvP2QYzu/8fS7Kvb6+T
	p4AAe67RQuksjXh/Y7UN6TRfcLMAWlw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793898063;
	b=mNklF4rcVMW+WBRuUiUpaNjJrwn01oN9sXNVmLn8uMi8BYogsRu0MROWvpOu9dc3J7QGN5
	cwMlwNnwMgeIBTjy/zugmiNupxz1iJ4rM3TXc+NU7qD7Nuerywew04ENw6jWIgByRdI1qI
	TTnYjSNJwNSVY1z9+peIjUFI2atoF0M=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=q7V7OJU5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HQIptzs2;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=q7V7OJU5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HQIptzs2;
	spf=pass (imf13.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7AE0C1FFF4;
	Thu,  5 Nov 2026 17:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793898062; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xEZ9JJfmqsHwOWZ8ElxjeuHq5z5hpn3BAo1KSIMWKNg=;
	b=q7V7OJU5V3kHEmtMC+LW7OPlBP2+X1BkkbG18zyn3y4BGYvK/fgcCEK1aPjhjRnJP2Bqy8
	J+COa3CANIoqRNfmnlqPmBE19vl4XySEEdxN0tI4dTFBIUJYs11QtrVG8F6Hd9R3zqpGzb
	fvEz/nka4/mM+a5fXaLH9lgK+wVXm3w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793898062;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xEZ9JJfmqsHwOWZ8ElxjeuHq5z5hpn3BAo1KSIMWKNg=;
	b=HQIptzs2YWEwUY035nAUQ/KX3dN/98aVd1ncESN86TGDKhwlZOcEvouUYVi5ZD6VFx4oD6
	ANOmGc1e9j6Kn9DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793898062; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xEZ9JJfmqsHwOWZ8ElxjeuHq5z5hpn3BAo1KSIMWKNg=;
	b=q7V7OJU5V3kHEmtMC+LW7OPlBP2+X1BkkbG18zyn3y4BGYvK/fgcCEK1aPjhjRnJP2Bqy8
	J+COa3CANIoqRNfmnlqPmBE19vl4XySEEdxN0tI4dTFBIUJYs11QtrVG8F6Hd9R3zqpGzb
	fvEz/nka4/mM+a5fXaLH9lgK+wVXm3w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793898062;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xEZ9JJfmqsHwOWZ8ElxjeuHq5z5hpn3BAo1KSIMWKNg=;
	b=HQIptzs2YWEwUY035nAUQ/KX3dN/98aVd1ncESN86TGDKhwlZOcEvouUYVi5ZD6VFx4oD6
	ANOmGc1e9j6Kn9DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 825F2133F6;
	Thu,  5 Nov 2026 17:01:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HMEkC0K27GqWRwAAD6G6ig:T8
	(envelope-from <clopez@suse.de>); Thu, 05 Nov 2026 17:01:01 +0000
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
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
Subject: [PATCH v2 7/9] KVM: pass the mmu_notifier event and flags to kvm_gfn_range
Date: Thu,  5 Nov 2026 17:50:04 +0100
Message-ID: <20261105165004.2663799-11-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261105165004.2663799-4-clopez@suse.de>
References: <20261105165004.2663799-4-clopez@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -12.30
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8DA592000E
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: bf9byyq3b95s9s7uwi9yf7syr8wj84d7
X-Rspam-User: 
X-HE-Tag: 1793898063-749982
X-HE-Meta: U2FsdGVkX1/d0jrXeHBX0MAW7FZpTBsWI+oI1eLTllsjzAwQ2+MCxa0DjDiQGUvSw7eCIEe+UDwl6S5RvvYJmZMjq9AaY2KSUMoiB0aabm4xMIPjAMLXmG2rfMoyvyHWGfp4oqHy2jdVJRqQ2qRuBCBXD048zzWqLWJdWD6Oapq8QezRrpvwpoKtoMnd/OQOz2O+OZu0dfUl2GXKyVN/ue8mFFUZjftfxW0CZ+oi+7o8AcJqFoLe9upXj8B64i6cw3b5KArjib/59pc6HpQWl/1L+c7Fbbgod/I6RahQ8vZmk/HwbXnvx0u+bSjNjrmp33zjmjolXir6+TSdZGmaX0Md1pAACQSe16OEd30MQ5M26ORYAtjA69rm5nxDSnN0Cwd8qDG6mwcPvynO4QUJdXFj3T6tatLnJOYk5jlyD+fZz32ajI+V2kmx5u8ae1A62dMSSXXiP+FfMceNZkpc5IjXtjOnEq7iNGjAzlcchUYSzHMoRv9PLjrYL+ieI5Ks5gVROLz9e6U/IsGYu44Aim4Vnty7TERkVyd4zxb3zdpdmB4wh7UlEmd1gXWkLyew8YjoSxWk2XlA68Azu14K7x3DkPquojaQsmFS+eo50kORMdR6pUjW35+WblU2hv3yalPE8j7K5tmPnB8p62D1oQdKGB0KSZp1Y9zehQpbt+TetpEPmsmC0g/+pAbo/HgMJdjOvkGF8y9nVPkSYBOEv4isLxQvGNHaFQneuvIHiWJMcVcx+LizZF+jFF+WluGSAsPQU2mMrkloJ5+1LsxyV2sD1/0WMc3Tk4lwHCPj6z5nqJt5wRD/Z8fcLr8AASEztC91AM6RDABO+AI45JtY9ukfwDBDwYWmQa/zPzT5lAAGN3bTKbUcjYpBjzmlD35kSb3nmZQaN6hKY5wLdB4FYnRZzXMqZMfsDdtIT/fkIpqirCCoHJdAz7NJqf5Lq5rEo47bTdnKzBJRpU6C7Lk
 VtmyiKsp
 OSUsrYrWwo+wpY1REMN0p6T0qFwIc9q2cCY5j4CIRVnxnCQ4k7MP0+NlOIxQGLPVUWZZfcdFflhCiBXbVHfrfqJDRr91lcgj7wNF5xThwDFVRWyg9Qj0H04+3otN0KUvDOBjdbsRHk1zQ+qqMcZ57EzYk4HKGM+5hG7ogsPp7aUSRIJgzQSoQo+auzJYvEXFl3oiInCwVFslD4IoyWm/0OiPnRKznmm6jQ+bJaSZpoCD7N1MUAanT03LayUc+Nq2OVOkaYQwIFw2WGd8mpjbAfKFSpmQ0o0SiAweIde7stixUC7F1vi61NGl566YkwvvBNKNEv+3hsJqHsoOZdnUAqlRmjLZ4xqFHEI4RRPriLTcXgZD5PiJ2PmWeKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Propagate the event and flags of the mmu_notifier invalidation into
struct kvm_gfn_range, so that architecture handlers can tell what kind
of change they are handling, such as a permission upgrade
(MMU_NOTIFIER_RANGE_PERM_UPGRADE). They are not consumed yet, so no
functional change.

Signed-off-by: Carlos López <clopez@suse.de>
---
 include/linux/kvm_host.h | 3 +++
 virt/kvm/kvm_main.c      | 8 ++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e7fc94e2910a..1f5ce4410ddb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -274,6 +274,9 @@ struct kvm_gfn_range {
 	enum kvm_gfn_range_filter attr_filter;
 	bool may_block;
 	bool lockless;
+	/* From the mmu_notifier invalidation, if any. */
+	enum mmu_notifier_event event;
+	unsigned int flags;
 };
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cf4cb586f140..c517d1deb488 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -532,6 +532,8 @@ struct kvm_mmu_notifier_range {
 	bool flush_on_ret;
 	bool may_block;
 	bool lockless;
+	enum mmu_notifier_event event;
+	unsigned int flags;
 };
 
 /*
@@ -613,6 +615,8 @@ static __always_inline kvm_mn_ret_t kvm_handle_hva_range(struct kvm *kvm,
 			 */
 			gfn_range.arg = range->arg;
 			gfn_range.may_block = range->may_block;
+			gfn_range.event = range->event;
+			gfn_range.flags = range->flags;
 			/*
 			 * HVA-based notifications aren't relevant to private
 			 * mappings as they don't have a userspace mapping.
@@ -738,6 +742,8 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 		.on_lock	= kvm_mmu_invalidate_start,
 		.flush_on_ret	= true,
 		.may_block	= mmu_notifier_range_blockable(range),
+		.event		= range->event,
+		.flags		= range->flags,
 	};
 
 	trace_kvm_unmap_hva_range(range->start, range->end);
@@ -2552,6 +2558,8 @@ static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
 
 	gfn_range.arg = range->arg;
 	gfn_range.may_block = range->may_block;
+	gfn_range.event = range->event;
+	gfn_range.flags = range->flags;
 
 	/*
 	 * If/when KVM supports more attributes beyond private .vs shared, this
-- 
2.51.0


