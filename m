Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47679606A326
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 14:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=UrdyCeEM;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=GWyd71jI;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=UrdyCeEM;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=GWyd71jI
Received: by kanga.kvack.org (Postfix)
	id 30FD86B05C9; Thu, 29 Oct 2026 10:44:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C0DD6B05CD; Thu, 29 Oct 2026 10:44:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 161966B05D0; Thu, 29 Oct 2026 10:44:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E1C316B05C9
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:44:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6B1DE1C3A98
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:44:49 +0000 (UTC)
X-FDA: 85375935498.25.51BAC2F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5AFCF1C000E
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:44:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UrdyCeEM;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GWyd71jI;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UrdyCeEM;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GWyd71jI;
	spf=pass (imf21.hostedemail.com: domain of clopez@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793285087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=On/WzBslNRdooO2nM6+KcAg+UNarkQsFuaUhWqaMpyc=;
	b=crPXAfgFon5LZeN/o6Jncyqm1H+M0Ce4HKqpO4OiMdCphTomWCm8jZ4ZJrEc+zJtzCWr9p
	P1ctaKhOQAi10IWqktVixxwynzZ3nQdxCBzDatPgYS/rZmWkgv73sCySkU4XgM/cyZFpXy
	VGwrZOa7plsF595x4mN1XJ3lQmlCM6E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793285087;
	b=ZUfs3Uk6CixlcceVPG2VZ1dbNNXbsSaqEcyQ7vRYmcHld92FDaSxgc8Wq/4995P+GBflTi
	kYKysaEIehoGuKbPFFQmV0YioIR9HzYAP/XH0XjElgwmj27WI2W05S1odHXdLZp2AS20Xr
	wlahTKYgNbp59KRIWB+fxkfZFt3Udrw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UrdyCeEM;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GWyd71jI;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UrdyCeEM;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GWyd71jI;
	spf=pass (imf21.hostedemail.com: domain of clopez@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B54C22210D;
	Thu, 29 Oct 2026 14:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793285085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=On/WzBslNRdooO2nM6+KcAg+UNarkQsFuaUhWqaMpyc=;
	b=UrdyCeEMKHhopqmzqB8HSWFgIEcKTFU4pSYcOCLxn3f/ee6De+XpoEYELmPbxsMduW0d3a
	596LYkT6TmeSIL8H/20MEj37EoRurGIvmzIGn+C7tiHkb9FRgi3NS1/YJIcCio8Xnl0i2D
	pRhue5Oo8xf5WTkSNWH5zZ+V+BQ3HvA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793285085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=On/WzBslNRdooO2nM6+KcAg+UNarkQsFuaUhWqaMpyc=;
	b=GWyd71jI75LiMrHVSGXVpQz70/7L7+unh/faDaAFEJ33aAcmosuQKzFL6yk0+RBTU3mlPx
	hi/UyO4w4CAHTyCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793285085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=On/WzBslNRdooO2nM6+KcAg+UNarkQsFuaUhWqaMpyc=;
	b=UrdyCeEMKHhopqmzqB8HSWFgIEcKTFU4pSYcOCLxn3f/ee6De+XpoEYELmPbxsMduW0d3a
	596LYkT6TmeSIL8H/20MEj37EoRurGIvmzIGn+C7tiHkb9FRgi3NS1/YJIcCio8Xnl0i2D
	pRhue5Oo8xf5WTkSNWH5zZ+V+BQ3HvA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793285085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=On/WzBslNRdooO2nM6+KcAg+UNarkQsFuaUhWqaMpyc=;
	b=GWyd71jI75LiMrHVSGXVpQz70/7L7+unh/faDaAFEJ33aAcmosuQKzFL6yk0+RBTU3mlPx
	hi/UyO4w4CAHTyCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C9C7C1339F;
	Thu, 29 Oct 2026 14:44:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iNqFENhb42qRUwAAD6G6ig:T5
	(envelope-from <clopez@suse.de>); Thu, 29 Oct 2026 14:44:44 +0000
From: =?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
To: kvm@vger.kernel.org,
	linux-mm@kvack.org,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: linux-s390@vger.kernel.org,
	imbrenda@linux.ibm.com,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND 64-BIT))
Subject: [RFC PATCH 4/4] KVM: x86/mmu: don't zap the secondary MMU on permission upgrade
Date: Thu, 29 Oct 2026 15:33:37 +0100
Message-ID: <20261029143336.390231-7-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261029143336.390231-3-clopez@suse.de>
References: <20261029143336.390231-3-clopez@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -16.30
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5AFCF1C000E
X-Stat-Signature: 7yzobmuooj3npnc6mw56spbha7wgcx1s
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793285087-776235
X-HE-Meta: U2FsdGVkX18fll+9b4tKdqM4rjGz3hE6Tn8QaR1tQydPgwgYlf8UrXepcRR7Mo26mrhv/mOblVX0Mmxvai5gltTnZOkYs6O8NQVvkjRouCFqnMJI5XYQEO8pvH2ojjC1/0WHs56oA8+WgdMJhqfz7u8OVhIWrzsKnSrRVZvrOwXfyy4jx/wKcjNmzo0X8/O+s8i7tJ90rWWNCIdK0/ss+XHNDOuCqw4EnoR724lpLuQLgblnCtAb6m3emgUNzT7I1QhfrNgeq6OVyb8Od6pjfYdNmFikrLzZHWQXCQOZKmdSmdPWAS7FHCtCw3btQsPuhQUSiEq8j/9jZCdYryTKBPse5DygaC/BRVHF/vLvABJhOYLABT/cOdOQIWi2DUMkQxHQMkUJ2XDaOKHGnXm7Tdg8gIW9ouf/03tz/3aOn15GSerdQREsN/mvvVNRJ/hK8kWVQgL2HCiXs/sUr3VZKVkJFdgsx5Tmn1YKyTuKwJojrr3ayJAEmFReCSwzRrYONQaXPHVI7fcOSNsmZaiQO7QYfkNiLmC67Ho6pZ/s11rNuhyaNsZX79gxw/M+ftct8CCPKBFPeX4H8uusAjJF3V2WK6MOWQbvxC7mX3ZZzu5KBTaL2VrXw86FjN8Mj3olOE+oa0HClFn+R54xV6X+yeruGm6mTH16W0XTjtFw7mrSDAVDWJa2GtpvR6moYRvfiOIVROF54ziZyNMXD/Lj/NquVorSMenH9JDvfqaaXvyJR4Q3MXgTp20KHulFf2/Kw4SDi+HfAbS2nZHm7oQLun9vK+r2DoNYDPvyl9x2htXttDVpOoaGt6jQd6+wm1XO525LVGN8vVZCpQjnqfTDoKt7Tj7jv/9ZPhVmQ0fa2t3wUGzSast74+qdI+rP+zh1y9qOGn7/NVn4XhgafiOWZq8I/97oi2XHnSnSC8Y8yKlCW8bE7hxP1exna6jEEPhYB+j23bAaS/SjwJvty0y
 Fzb8ZRb9
 mJVDl/itylCuTz0ohhCrZzPkifOkbvuw0MN0NPAb0sw9ERkPwzaM0X10maqx3g8Ew0IRxN+iEqHkTc4Lsk6eiwOnjabgkukjKLnRNpugNVqppAfGsyBKX3Ea7E1082ZYvWy/5jYPzA1E8UflR9qex3S1oICTNK1W+3YBdu9T8vNk4hVxkwb3HRKUhSVYMYaLeobrvDyFrfIdXJhLyKDCSKDxlAD02GKNad8i4Xj0YZELNpMQ8UcDQ0NyXVglF3C5bpzR87bk7rkxyi6Ba7dsWazS4g/T00A/lhUEmTZFxZpvHAXxlkSpSuYeYa3FXTpw7trfZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When an mmu_notifier invalidation only upgrades permissions
(MMU_NOTIFIER_RANGE_PERM_UPGRADE), keep the existing SPTEs instead of
zapping them. The PFN is unchanged and no access is revoked, so a held
SPTE is at most as permissive as before. Permissions for the SPTE are
updated on the next fault, so dropping them early gains nothing.

The motivating case is a userfaultfd-wp dirty tracker such as QEMU's
background snapshot, which unprotects every guest page as it saves it.
Zapping on each unprotect makes the guest refault its whole working
set. On a 64GB guest under a background snapshot, a read-mostly workload
drops secondary-MMU refaults from ~1M/s to ~2.5K/s and cross-vCPU TLB
shootdowns from ~1400/s to near zero. Uses of mprotect() that only add
access benefit likewise.

Signed-off-by: Carlos López <clopez@suse.de>
---
 arch/x86/kvm/mmu/mmu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index dc2aef72ffdd..a4258a8c0c89 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1719,6 +1719,13 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	lockdep_assert_once(kvm->mmu_invalidate_in_progress ||
 			    lockdep_is_held(&kvm->slots_lock));
 
+	/*
+	 * Do not bother zapping SPTEs if this is only a protection upgrade.
+	 * Permissions will be faulted-in on demand.
+	 */
+	if (range->perm_upgrade)
+		return false;
+
 	if (kvm_memslots_have_rmaps(kvm))
 		flush = __kvm_rmap_zap_gfn_range(kvm, range->slot,
 						 range->start, range->end,
-- 
2.51.0


