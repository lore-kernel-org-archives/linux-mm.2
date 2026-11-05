Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B09F6606D804
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 17:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=Pei1+gTR;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=VbIGDJjm;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=eGgBk4uw;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=lv4BOyjX
Received: by kanga.kvack.org (Postfix)
	id 22C256B05C8; Thu,  5 Nov 2026 12:01:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B5B66B05C9; Thu,  5 Nov 2026 12:01:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02F9B6B05CA; Thu,  5 Nov 2026 12:01:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BBE3B6B05C8
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:01:08 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 501BA1C45E4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:01:08 +0000 (UTC)
X-FDA: 85401680616.28.E308018
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 33E4C80013
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:01:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Pei1+gTR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=VbIGDJjm;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=eGgBk4uw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=lv4BOyjX;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf02.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793898066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0sIowcuQ5IyfilZxYg4IseA453ZPtAePPTKkUBTmPjo=;
	b=LlMO5X/rVrAaZ8Ql+QTdCVxPLHt+98i9ZNoosJ8ypWUrTsQtUjo1YxKKkHrNuVoTIjo45w
	NthADaYQ4Nb60Xvtd3rvaPketYs8+iW3Joxgm8ZuU7krVb3XMrG2jJ/nMqGaleJbmY5REG
	o6HdXiUBG/+BHkU6xT8+FnZBfDVCuEI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793898066;
	b=H7MfCK0IEjAaedlYfB6NdUX4ZqESwCT6LcOKheVbw3qdO/MVzdwWojvyLQI0a3v+Vq0K+b
	sRDjJz9hZn7G3v5Y5eYszZbh7r7LbFQeSzFFWjIOpcpcMzRIKRoK+tuS2KfNJ/CrbtJLf7
	y4uLAPEdWLMSP1+9s7/BR9ALAwZHG0I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Pei1+gTR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=VbIGDJjm;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=eGgBk4uw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=lv4BOyjX;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf02.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E2B3E1FCFB;
	Thu,  5 Nov 2026 17:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793898065; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0sIowcuQ5IyfilZxYg4IseA453ZPtAePPTKkUBTmPjo=;
	b=Pei1+gTR/J1zBT1gB2ZeIJQxUCowvgas0b47E0oxSiRyXbqfWcWT9CdLgVofqWdP18Qg1v
	Ma8pSr6pCXEUEOa0V2V7ffs5/4vXBJVhoGTnqrnRVNYJiIbjX4ekZxUb3RcUoicU6NFpCa
	9Dzmz5lgpmD102+OnFKvh/48r+57WtM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793898065;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0sIowcuQ5IyfilZxYg4IseA453ZPtAePPTKkUBTmPjo=;
	b=VbIGDJjmTZVhO0JTDSy7XYPe54eMhLayiPZvsUM2mYuCPJZ4FLgK5H77l+InWBrOhXV5GV
	hIZsQZNN4vhg0qBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793898063; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0sIowcuQ5IyfilZxYg4IseA453ZPtAePPTKkUBTmPjo=;
	b=eGgBk4uwtc8odIcPkfJnvOhwvShX1Dzp80/Y9+pOvhwx2yg6xph2VIq2YxIEJqjm3b0zp+
	2ES30McqhT6ATAMyAkgShopGIv8d34lgBrlGUnLFvO0HDMHEpHDwCbbcwu22ILKAE+UIC9
	RBUzcteQ4gT3NeSyIoKLjzjert/tTQU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793898063;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0sIowcuQ5IyfilZxYg4IseA453ZPtAePPTKkUBTmPjo=;
	b=lv4BOyjX8HinF0YoiV2Xm9Cn46XE9J0/uhYRUvlZz2sLnoHhypKXYcPDivccnQoxvlqcHG
	XlE+f2wiywA7r9AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9C9B8133F6;
	Thu,  5 Nov 2026 17:01:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HMEkC0K27GqWRwAAD6G6ig:T9
	(envelope-from <clopez@suse.de>); Thu, 05 Nov 2026 17:01:02 +0000
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
Subject: [PATCH v2 8/9] KVM: x86/mmu: don't zap secondary MMU on permission upgrade
Date: Thu,  5 Nov 2026 17:50:05 +0100
Message-ID: <20261105165004.2663799-12-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261105165004.2663799-4-clopez@suse.de>
References: <20261105165004.2663799-4-clopez@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spam-Score: -12.51
X-Spam-Level: 
X-Stat-Signature: 1ncaky9czqqtjrjuud7my5ycpw9acoax
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 33E4C80013
X-HE-Tag: 1793898065-16850
X-HE-Meta: U2FsdGVkX1+paiAlivyrzqCYh09PIS3XG0y83TD7fa8VCmlHUTUaOSQIv8T+RK+dUgBTrzc2c1rle19DMDQDCU+a819cHfkCgTISNSJD3mJt6TTF/YRz9qLT6n51Qs05NYzas+SQlUerl1s9WyYTO5SFRjgzvfIGlJH6gYAqI5r4sW3hhielHrF+vmyizeWyUnEPD48d607PAB2go28NGuh7/t3oX8NhXf2OK/TSKKIkBCLXj1+bC3LTI5y07zDDEDTEjWJfZ208u4sFC/KlB+IjIoLrCHiPiTCuYOL2KQz/RX4nZlLli5yjMuGDpwXLw+SMHcokTgsklYCIR98YZKFJrCJgx5kCCwFo0taMrP+qPuOdWjmQ79J/fYcjI9cyIYevJcRzCFIo9pc81sYfDSD/R/1H3i3m4vm7yUyyLBo4CnX2Peq49q29t2sPpJobprpTWVfBaNYCU0Ghi9osLjBjZ0OwlzAUuaCCuv0E5pQin02KJxqpxGx3XyouletFsRWFTrC5G3NcpJQxoC1FhpxyGI4Fkr1jr9GNsQIVXZv39t4fU6Pe9jTKruW348zBxQsQxiJSmdcv+i51Uj9fDMZN/S4nLMKU0BI7nDIOc86A2fIX69vftSlnf7woxfrcQZbAjRCONNWoxVNxyyVFijuLQKkdTLG8mdL5E2o81IYHM5eTLBeq5CrsHvrBeOmJL2jmYZ6Yr96fVet/vbG56ZrHWQfc8ucxdkpkQes51X+J/xCFzgoEjR/Xkr4OQ61TdyqG+w06Wa6qPd8lPTvmVGB2RJXlWyNz6eult77mLzGdyCq503NxSxfEGncAVM978CXsuwG0+4fUXg+MvG1Wdiix289OemPlWgTKG6LbUddsEWtmgRwu5s5OZLg3yHxwtA7UATLiDf6f3LggUfbCI3iNFwu/PYPsxqQrzQZccEb2S8Il2U3Dk65m5Gmlt91sB6ed3c49hqIXWl28fOb
 YBiDIwj4
 Ba0+OGp9sJPshq3USxYnYs/Ut5hU1EHwk6DB9zJf2Kp6ZGjXqi+jGh+vUvYeB3EeucV30fcNICMfXFLl2e0yC6264wSK/S5EzPewyI71bFfA0xvOevJRxMD4lkK60sB2B15Bo/dPYeU83KKUL+7CbdVP5269iv70+er96F2EQBIug1r1k5ZN+VCMK+XgSknWj2D9y8L5LtcfEQYx6GQMTi6NHfEt/SYD6Q3YPo2RquOtnq2Po5gp5urUzmc1DFxdi+608rTajTer56jUrs/dh6x3P08IVcOESC9t1j3yU+LbHGgEBIn6uP+1s8hJRs58fO3EN
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
existing SPTE is no more permissive than the new host PTE. Permissions
for the SPTE are updated on the next fault, so dropping them early
gains nothing.

The motivating case is a userfaultfd-wp dirty tracker such as QEMU's
background snapshot, which unprotects every guest page as it saves it.
Zapping on each unprotect makes the guest refault its whole working
set. On a 64GB guest under a background snapshot, a read-mostly workload
drops secondary-MMU refaults from ~1M/s to ~2.5K/s and cross-vCPU TLB
shootdowns from ~1400/s to near zero. Uses of mprotect() that only add
access benefit likewise.

Note that this also skips the APIC-access page reload, which is not
needed as the page's PFN is unchanged. KVM does not retry a failed
reload, but that issue is pre-existing and unrelated to this change.

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


