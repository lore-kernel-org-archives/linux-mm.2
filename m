Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60DA360703A5
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 14:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=k/xP1Kb4;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=/hUSehq+;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=k/xP1Kb4;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=/hUSehq+
Received: by kanga.kvack.org (Postfix)
	id A0CCF6B05BC; Thu, 12 Nov 2026 09:25:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E4416B05BD; Thu, 12 Nov 2026 09:25:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D3346B05BE; Thu, 12 Nov 2026 09:25:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5A7DF6B05BC
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:25:44 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E89F61205ED
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:25:43 +0000 (UTC)
X-FDA: 85426690566.21.C4292C0
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id D842A140005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:25:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="k/xP1Kb4";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/hUSehq+";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="k/xP1Kb4";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/hUSehq+";
	spf=pass (imf23.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794493542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=egAgTK39zABd/gJChkYURwZvQvarzAr/B6j4tF3tOn8=;
	b=EOPOEh/aUBLFbZm3+qyY+B0MLvczz10s5Gg0WcFc3dYhyNgAQRhMfXHD3x9l1Gjagyi03T
	ANya+KUcD61iRln/3wqASSegxd3ZHwrQCjdTppp8KOUishhLNEhhbUXCtNWP2tsc8S44iE
	he6xB70QQ2hCJAaCCtBSmiGpRUoTlm4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794493542;
	b=vdoDlSjLzm7k5ujuDA3ziDh5x1WC73T2H7oRDt9PbP4/11Srycf7TxqVMeakjaRdvSUA2Z
	IpUuvN8TIiZB0M4M9uieX/MkKDSPs3NK9gsChjA/Uyl2WOvAEwQHuwrYPyVayLSpmTGnvC
	MtZuSayJ3p6cqYkAzRPcQj4UlZV4Jos=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="k/xP1Kb4";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/hUSehq+";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="k/xP1Kb4";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/hUSehq+";
	spf=pass (imf23.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CB18F1F7A5;
	Thu, 12 Nov 2026 14:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794493540; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=egAgTK39zABd/gJChkYURwZvQvarzAr/B6j4tF3tOn8=;
	b=k/xP1Kb4Y0Ig/EixInInOwWOvMgi0T6ABSaEYlalEBYLYUCF5f8zAbGs/mdAEUZbRmN4PR
	ifNh+GYizIzxkHuN2WWC8ffk5lrSWwQ2YJI/LS1FunKlwt27uDNH0fsezbS/UdKRFgiFNv
	QuoLwnyFNFbS9hRk1P8xFoO4z2HfJys=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794493540;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=egAgTK39zABd/gJChkYURwZvQvarzAr/B6j4tF3tOn8=;
	b=/hUSehq+rUZXwcxCjhPMecIMFavt7F/FpLJSnEGR+nK44h8S9YvRwsG1kO0xIZ9OsEHR+Z
	l1CKWMuJt5U+mECA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794493540; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=egAgTK39zABd/gJChkYURwZvQvarzAr/B6j4tF3tOn8=;
	b=k/xP1Kb4Y0Ig/EixInInOwWOvMgi0T6ABSaEYlalEBYLYUCF5f8zAbGs/mdAEUZbRmN4PR
	ifNh+GYizIzxkHuN2WWC8ffk5lrSWwQ2YJI/LS1FunKlwt27uDNH0fsezbS/UdKRFgiFNv
	QuoLwnyFNFbS9hRk1P8xFoO4z2HfJys=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794493540;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=egAgTK39zABd/gJChkYURwZvQvarzAr/B6j4tF3tOn8=;
	b=/hUSehq+rUZXwcxCjhPMecIMFavt7F/FpLJSnEGR+nK44h8S9YvRwsG1kO0xIZ9OsEHR+Z
	l1CKWMuJt5U+mECA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E0FA113432;
	Thu, 12 Nov 2026 14:25:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id w9GzDFnM9WoAPwAAD6G6ig:T8
	(envelope-from <clopez@suse.de>); Thu, 12 Nov 2026 14:25:39 +0000
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
Subject: [PATCH v3 7/9] KVM: pass the mmu_notifier event and flags to kvm_gfn_range
Date: Thu, 12 Nov 2026 15:20:36 +0100
Message-ID: <20261112142039.907090-9-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261112142039.907090-2-clopez@suse.de>
References: <20261112142039.907090-2-clopez@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -16.30
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D842A140005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: b617txkattffiubenegg4bqpo6tt9mdt
X-Rspam-User: 
X-HE-Tag: 1794493541-581772
X-HE-Meta: U2FsdGVkX1+MfSZdZhdMKSoxiAr33o6fPyFUdHOYg3e/rJrI1WGu6Zxcm5beAy+nlq6UkeCseNIM6TB0Vs99wDrR2InEAlAVwj+VKv2snLPWOTSyqI57KqqGteIfwA/wpI20qU3I9HqgBlX3cOrPPUu3DrNmT0HJckhCqNuWW9WI8n6fibRxfuH3OLcsl8VLdgoXO1gf2UeerMcQKSyLQqwN2Tj14NMyFySK23iWaQ8w9yh/qWEkVM3OB2pEt8ZEiCCBUOd4tUyn0qD3KibYSBinzMx0cxVodLCnGZD+ZkHTwEZzt05vxtk8AQKBMLMNe+m8zzX4rCO8KYIS8EXpfJXS/Ty96M/jx+IlvGByzs8NzzPOdpS5q3e6/pP5Dc7NDb9+GM2yV0qmoVb5kQipRRDPcSHMkP6+rk2d57JAq3GIt6wz/5ltyhWMzjatmr7v31k8UEXgTVq2s80ElY+253Ej2H0AFmQM/023cflWs9k2Ncl5lwLgd0XXbKt7e41Q4J1W6WaAei9tAtbv5bYpgW/MZKqXRwjIzr4xyJyIBxc9aY1zdVrP9zkvDVo4xSifwWlQLWQWSdz/NDpJ+0hdoqHEvtWQxBn4YhE26zIXrwnvNFcS+egM+3sXzVRc+uqtN+thG2dVjIW3OsjoBMo9c5eZ/B9ACHf6MjcnO7EbJ/60nsO5cclU/6NOFa1b6jnoZR/7dF+7kRH9ZmvJjkM/IechVNsDF60UxPV/m4q4J5GuYDqGaxrr1JsGFiG42D5VODGQl+3/M9uTa4MIG3mZwjXFkvajDWNOw2j2/m1jiDooi+ISuZc5TW1a433IZKm1qxYNoceQdOB/NohKPxnoVeR0E3iKtkhLUIJjEIGve+2DcKJLTQOAcfqpHBHhVr59eRI2Sl+0zPqjDGkpvOjOqClryxikJa5rSPg39yybVNsxpXY2avM8o0OvtfTiiRgmO0BJGys179xb6I7NbL2
 0c2w01eF
 sfU2xl48yQya81I9o31KjpScbd3DTxottLVLDEabpKsKNWIFjh/icSIxal+HX0E//DjpHvEnJrYhHWWc1G/I4F/2ckU2xtyiCUH67+Gso3UMFQtYRWSOT4oYVRLZNsR1x54XykCLdv9xGVLBKJ4vQofWLwyZ+xLukEnBjsh3Kk0EYUlgrN68PO/u503Vr1UtiQwF1rqHJhP9MQcAj/6UPVxrhV7244IaU9sVZOkJPDSrzuGJlLgWPj+0By0zNIqcG/VZkThPxBx5vhxliAV9v3j6cy1WZuvpNrFbbQQyZb7G6KznzyLOEJ2cehgSM8o51fPNrRf1PanlPytG6bjQEg+h/LD69FprW0g5mdgW34Pek8UfSBbCBiv8BVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Propagate the event and flags of the mmu_notifier invalidation into
struct kvm_gfn_range, so that architecture handlers can detect a
permission upgrade (MMU_NOTIFIER_RANGE_PERM_UPGRADE). No functional
change.

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


