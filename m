Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEDD160A2617
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 14:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 077CC6B05C8; Thu, 29 Oct 2026 10:44:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 001CB6B05C9; Thu, 29 Oct 2026 10:44:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E80F26B05CD; Thu, 29 Oct 2026 10:44:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B8F356B05C8
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:44:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BBA1640457
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:44:47 +0000 (UTC)
X-FDA: 85375935414.15.E741675
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id B368014000A
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:44:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf26.hostedemail.com: domain of clopez@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=clopez@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793285085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=46myARG/OGWuh/nw73XrNi2XTON/aEAFXw6IJmuSHJY=;
	b=fPcS7YfAvG4TJvpNaJhe1paZcICcJ6VnqGmKg4MDN1c9/juPrJibnBq1HNjKzv7TH7pe1j
	rV9TpDM6mlo0vrVVKXQjBwxIRE2zWFYjXsO1oAQ5gcr7z6itBAS3Evbznat9d9KxVFfnJ3
	vPfl/WzKjP42Ko5ulOkttENLuZGuUfY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf26.hostedemail.com: domain of clopez@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=clopez@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793285085;
	b=ueGi81snWq4qTMuIN6BCn+y3z72lkkofG6ctFPMUe9GLOU0aWCQX1fJxYtnK/v7hTl3lLP
	CRKmAhCju/pgek06/mJtEtd4gRW/ObpShgv8/lF0etbgh82BY/nMH4NRJMnQnkNRBmy2Tn
	dzZCqiyINqGUfHNBd8Dwlw9PnDVDB2o=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A3EFC2210B;
	Thu, 29 Oct 2026 14:44:44 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0F45A1339F;
	Thu, 29 Oct 2026 14:44:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iNqFENhb42qRUwAAD6G6ig:T4
	(envelope-from <clopez@suse.de>); Thu, 29 Oct 2026 14:44:44 +0000
From: =?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
To: kvm@vger.kernel.org,
	linux-mm@kvack.org,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: linux-s390@vger.kernel.org,
	imbrenda@linux.ibm.com,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH 3/4] KVM: plumb MMU_NOTIFIER_RANGE_PERM_UPGRADE into kvm_gfn_range
Date: Thu, 29 Oct 2026 15:33:36 +0100
Message-ID: <20261029143336.390231-6-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261029143336.390231-3-clopez@suse.de>
References: <20261029143336.390231-3-clopez@suse.de>
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B368014000A
X-Stat-Signature: 5k5oqmrd1ah117o5khbpzorgun8yh839
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793285085-359436
X-HE-Meta: U2FsdGVkX19eiwRih1YYZmMWN5En4uN9DKobOM9p/3pwAYPK9hiAGEufGmuouJKmePrUfxKDC4rLyvGBVOnBkgfi/L/eZn5oihvvhdoh91HrRAlV3EMn4HY2bsY98zWNEokt5CvVOwDNXd5riIYXGFO0JihGXTMBwDcduwGjdiVBwAwmYnQbQmPfllyIfY2a2dmlnARkdHzcieCyXuLnWnwNsDlMCeifsXaOCmh1Wf+xFyOqorCicJzaZK9fI5ysOcdvuhC+svyI9bOhgaNT43+sFgkSalKBUOYatvSyIVu1lbKjKKRZuSHCmplfB4m/MgQnPZo7TCa6BmnqqxO4I8V/ltG1k0WgPX0OJYbGgctW15FwYsHDAijZRyqdE19nWTgWSnhZ4wE1yMipnWZhvMAlrkyWBU2hB4bDHAY+Ng9wy3K5z1HQT2fX6tohWycAxfmUeOzAwP6be80Szu5nyvks8cJXZ9/ftLQ+ZjKwAAr2nxwKU2IH9SbmYz6mdJQw4LVXcZo/1GNhpIqR56RICcb8wf/+HMwiKIYNU9gLQeqY8QnpUJFTytAx85UnunkUWO4HrUzr5oM7CiCFI4FFQFCsr97OFgWnRxUi5/QPCX5EtSKMJgCXsOCTbIGcNGjOyExqetIk4O09eavLO/M8LE462jjZX9VMjoDHSdF3HqIxcTMhzX9dp6iSXqT13QYT3EAtHMZRrI6x/4v/Vq0L0j66nk3ocVGEUNwawe/LLJ6nStWZmwEho+qNyWOHxz4FmRZQnvw15bHkeTb9ZrNwyJ76D6rBMfdg6LVd7ABmh0NVcyVS9G3sGEw7LYRs6Yd8fnVOER+GmRPpiXR5Yl5ma4iceIcvvtja+Y0fPeH4hqz+awJIrDIPXAJDdjeGyOdqS/ecRg56ADdbSER2wtaS9rPpN27K4otTpNS7ouug2wnQmkIm9isE9zJFnvAkZ9MwoTPh4uE+pd6eA8zi8GQ
 cGARKcj+
 +OGAxICJAtAg6kq+gYtknMvrxre0u5atF5H9c4o4YAQ3bENSOGVpvfUyGe1A0Ja0sFIIHOkovUq/pVsuwhIyal+V1vGIWHRyn4bTZt6fVZoSvgPEMPnYcAX5zRGm9h323zWmLqihp/V+3k/GlJYN5eZO7FmTDTqxOwba88xAZHN0U+28+o6JLdHgn9M7SgwS4X51Rv4j21Uz2YentXkaKFMJMmZ2kukjkBrkt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Propagate the permission upgrade flag from the mmu_notifier range into
struct kvm_gfn_range, so the unmap handler can react accordingly. The
value is not consumed yet, so no functional change.

Signed-off-by: Carlos López <clopez@suse.de>
---
 include/linux/kvm_host.h | 1 +
 virt/kvm/kvm_main.c      | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e7fc94e2910a..aa109818cede 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -274,6 +274,7 @@ struct kvm_gfn_range {
 	enum kvm_gfn_range_filter attr_filter;
 	bool may_block;
 	bool lockless;
+	bool perm_upgrade;
 };
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cf4cb586f140..0d0073615fa8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -532,6 +532,7 @@ struct kvm_mmu_notifier_range {
 	bool flush_on_ret;
 	bool may_block;
 	bool lockless;
+	bool perm_upgrade;
 };
 
 /*
@@ -613,6 +614,7 @@ static __always_inline kvm_mn_ret_t kvm_handle_hva_range(struct kvm *kvm,
 			 */
 			gfn_range.arg = range->arg;
 			gfn_range.may_block = range->may_block;
+			gfn_range.perm_upgrade = range->perm_upgrade;
 			/*
 			 * HVA-based notifications aren't relevant to private
 			 * mappings as they don't have a userspace mapping.
@@ -738,6 +740,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 		.on_lock	= kvm_mmu_invalidate_start,
 		.flush_on_ret	= true,
 		.may_block	= mmu_notifier_range_blockable(range),
+		.perm_upgrade = !!(range->flags & MMU_NOTIFIER_RANGE_PERM_UPGRADE),
 	};
 
 	trace_kvm_unmap_hva_range(range->start, range->end);
@@ -2552,6 +2555,7 @@ static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
 
 	gfn_range.arg = range->arg;
 	gfn_range.may_block = range->may_block;
+	gfn_range.perm_upgrade = range->perm_upgrade;
 
 	/*
 	 * If/when KVM supports more attributes beyond private .vs shared, this
-- 
2.51.0


