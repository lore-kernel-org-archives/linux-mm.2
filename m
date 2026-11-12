Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4174760703A5
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 14:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=NoYzXDWf;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=27/HHTUY;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=NoYzXDWf;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=27/HHTUY
Received: by kanga.kvack.org (Postfix)
	id D68186B05BD; Thu, 12 Nov 2026 09:25:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D40106B05BE; Thu, 12 Nov 2026 09:25:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C564D6B05BF; Thu, 12 Nov 2026 09:25:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A36E16B05BD
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:25:45 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3C17980375
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:25:45 +0000 (UTC)
X-FDA: 85426690650.15.A8F6F6A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3AE6D1C0010
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:25:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NoYzXDWf;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="27/HHTUY";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NoYzXDWf;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="27/HHTUY";
	spf=pass (imf20.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794493543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pds7Uqtuvy1DGjOeeoA+Vkfk5LWosIAipoHj1WXULeE=;
	b=P6zKi7r7uejRNGzd+fVdXvcfgH/WwJgeDk+VQPgJsd9OYrBEo7HuImw38tOqjcp41NHJy1
	jIX8uYoTECL4aKauEhj4iZDVz4Bgn9/cEAihId8+Msdsn4/wAXs1VBVlR8CAaQXu+HZtlN
	qvk/4Kwj3Nk4tcIQQvey8x7fbjS1PpQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794493543;
	b=mbMPpsxbSx7YKPHjPeXgRIuqNPoZb5deqzme+w+ZofI/KfkvXnlBcJsm2UtziDBaU04a4G
	fwZ2P+LkEAs3iXkjW8Uhc3fVuRR03U5ltpR0Q/HymFDI+mcNeRf3MtbEVNnRbrC9n0mKM5
	xD5iRxw2XId5ma1WiiYwBTCJ+347OLw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NoYzXDWf;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="27/HHTUY";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NoYzXDWf;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="27/HHTUY";
	spf=pass (imf20.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3588B1F7AB;
	Thu, 12 Nov 2026 14:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794493542; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pds7Uqtuvy1DGjOeeoA+Vkfk5LWosIAipoHj1WXULeE=;
	b=NoYzXDWfAOmI8zdX5+chynT7UmwhBQTnmoRwZoMJ/VGhFM0PKtfGA/JYP/bSAIOADu9kGQ
	9gOBQ7k7ZTXpUlGUFGpEfaj3G9VTwdpmvysWY4H7QdBJ6dxmg4p0Id7AeGXlHPNsGl9x5k
	nn5xl4sAlY5CnQHYIWz4RkNYFCqp2cU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794493542;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pds7Uqtuvy1DGjOeeoA+Vkfk5LWosIAipoHj1WXULeE=;
	b=27/HHTUYBi6MOz2Dw2T7fjj9pDuC9sG1BBJdzOY94YAfUiu/eHvOCNpuZOT9gxMVmfVKLl
	tBbKllXxrTJz+JCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794493542; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pds7Uqtuvy1DGjOeeoA+Vkfk5LWosIAipoHj1WXULeE=;
	b=NoYzXDWfAOmI8zdX5+chynT7UmwhBQTnmoRwZoMJ/VGhFM0PKtfGA/JYP/bSAIOADu9kGQ
	9gOBQ7k7ZTXpUlGUFGpEfaj3G9VTwdpmvysWY4H7QdBJ6dxmg4p0Id7AeGXlHPNsGl9x5k
	nn5xl4sAlY5CnQHYIWz4RkNYFCqp2cU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794493542;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pds7Uqtuvy1DGjOeeoA+Vkfk5LWosIAipoHj1WXULeE=;
	b=27/HHTUYBi6MOz2Dw2T7fjj9pDuC9sG1BBJdzOY94YAfUiu/eHvOCNpuZOT9gxMVmfVKLl
	tBbKllXxrTJz+JCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EF33813432;
	Thu, 12 Nov 2026 14:25:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id w9GzDFnM9WoAPwAAD6G6ig:T9
	(envelope-from <clopez@suse.de>); Thu, 12 Nov 2026 14:25:40 +0000
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
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v3 8/9] KVM: x86/mmu: don't zap secondary MMU on permission upgrade
Date: Thu, 12 Nov 2026 15:20:37 +0100
Message-ID: <20261112142039.907090-10-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261112142039.907090-2-clopez@suse.de>
References: <20261112142039.907090-2-clopez@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Score: -16.30
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 1n8jfnrnmq1cqqzmbipkapmj5ynuu887
X-Rspamd-Queue-Id: 3AE6D1C0010
X-Rspam-User: 
X-HE-Tag: 1794493543-736596
X-HE-Meta: U2FsdGVkX1+z8B8BSkoYR4voXAEmwDee3LnlfBJMqjnLfJTeIDpLWu3bxzpYUC65a8FlQxD31ZbBKQiJDZqdyFj3QEiYpXKGdxB+8N0LLhxsxYB+w5irN8JpUSYV+er2WXKhqSYkyQ044vS7BxKYsfGY9ylLPQbNR8tBr+Lfa16N1gjIyYP4DquS84dkl4eWptTCd1XNyN7CpmXFrJpKJcq3rY9wn6MPNrLw+rv9VU6SgPS9BmJcYZ+W6OREwLt4hOquj4XBHYr6HVHGlvhslqVqcM7pS2qJSLN3EKPX30DzKmyHJ0xoqMOT0sA1QrUBrkRBjyJdZ2yR2gdWPJo4ebcxDuXLzBuMH06StnmC7ULjWwrYCOoSCiB7CMLdnHYT0mCKjBjn+1P2N/ugIfZv7x9R25L2V807FW22f0rSJ+D+jT/c5RMxvi2EArwxcvBSHE0Y6dSrQHWS/2O/zKA/lHV+4tDh93w+5h8zqZ+s03+E3PtD16M0jf/O3o7iCrf6K6DmK6TP64mjuwGwh9TunLh2aKx/8grPD3WDvusWwcMC9mS0Uv7eFp14rzdUcvvxef3hSUlF8/+JOux8RAtNDLoC4dahdcArLy5XqvDwQ/itz4+e2hqdD/r/8IE+QsSHDQfFYI14XNXxDnIKSfkye65zWlBUhmQNrzm3aV3vfzY93kv8ZNi+lJrIGRv/cWP7DXw2BznG52WbOTqXKUa5QkD1MsH4cdK5/vlgEaOSgW3Y5Ur6Cj3xg82+SJwfB9uKL2+dlARG61uMZkZwV4jJz8HtzVBV38CUHUC08YCsA6wEIYkpauttnW0P9wIviGVT4KAfZ417idYXfNXF8yEwk0Y3TlrpF7IoA2UuPggjDQaQ46X44XpDaKphNUJAEnQQFVWe8c8ygtATtkrTxhAO0mTDw510H2wcw4FW4a+Jt93OaM8SQA0nuGUgS6lW+KyPe7yKX7JWrYy0QujsqSI
 7hpGM/fP
 jh1HFUCjP4eSCN2X20oeweeTrFt681bj92VmYKcOYBtlm9LgiYrvE9im/ifH7Yp5lcYN1+BQa2H8Efkncvd/dmfUpejgKgGaL/ZnU5eMVkdF8pZRnm8ZnE81pQc+8Hi+XSmUVPXybtDy+zxrxIRMZT07HsCMGqjFCWk35F/ifPCGb9hxES4ysNGI/cpCiNPw0ouQ9C/5xi51RLPf7JLt34w+7VyMtIeYFuP7V6jso4hT6JCol2cCahgOKFCv/BDCRg8Xr2b4J/jIeFvP2Vo2GqTyVKUCBl8cTs9hu88q/VBhnC9iRoOdQGQO4bifljdQYHMHH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When an mmu_notifier invalidation only upgrades permissions
(MMU_NOTIFIER_RANGE_PERM_UPGRADE), keep the existing SPTEs instead of
zapping them. The PFN is unchanged and no access is revoked, so an
existing SPTE is no more permissive than the new host PTE, and the new
permissions are picked up on the next fault.

The motivating case is a userfaultfd-wp dirty tracker such as QEMU's
background snapshot, which unprotects every guest page as it saves it.
Zapping on each unprotect makes the guest refault its whole working
set. On a 64GB guest under a background snapshot, a read-mostly workload
drops secondary-MMU refaults from ~1M/s to ~2.5K/s and cross-vCPU TLB
shootdowns from ~1400/s to near zero.

Note: this also skips the APIC-access page reload, which is not needed
as the page's PFN is unchanged.

Signed-off-by: Carlos López <clopez@suse.de>
---
 arch/x86/kvm/mmu/mmu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f89e9f8a6cc2..3c92379bdbe0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1719,6 +1719,13 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	lockdep_assert_once(kvm->mmu_invalidate_in_progress ||
 			    lockdep_is_held(&kvm->slots_lock));
 
+	/*
+	 * Do not bother zapping SPTEs if this is only a protection upgrade.
+	 * Permissions will be faulted-in on demand.
+	 */
+	if (range->flags & MMU_NOTIFIER_RANGE_PERM_UPGRADE)
+		return false;
+
 	if (kvm_memslots_have_rmaps(kvm))
 		flush = __kvm_rmap_zap_gfn_range(kvm, range->slot,
 						 range->start, range->end,
-- 
2.51.0


