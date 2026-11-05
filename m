Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B190606A32C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 17:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=o2rewCfA;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=gNOFwnmK;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=o2rewCfA;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=gNOFwnmK
Received: by kanga.kvack.org (Postfix)
	id 5B5886B05C9; Thu,  5 Nov 2026 12:01:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EA2E6B05CA; Thu,  5 Nov 2026 12:01:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D88E6B05CB; Thu,  5 Nov 2026 12:01:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C15A6B05CA
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:01:09 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 89B181A0BC2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:01:08 +0000 (UTC)
X-FDA: 85401680616.23.B5BD43C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7FD41100005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:01:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=o2rewCfA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gNOFwnmK;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=o2rewCfA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gNOFwnmK;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf14.hostedemail.com: domain of clopez@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=clopez@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793898066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zJ4YMgar/+f3xch1CQmR84D/AWFtiNZ8AwAhZEnWX4g=;
	b=HrQcSg0Ep+YP+xHABbjE/4cBQlqhEpZuxtazlB3yENlbbz+PQs8me/40eazgwiqNrMu251
	BhrE2NM1kaqH+h3GK1SxPaZps63cGQtxHs1sCut0ltLmMKf13tFrXlSuyeyYjdNFp/P94v
	GrLH6xddWP1KFJd/xEPW+RUwaqPkU2c=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=o2rewCfA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gNOFwnmK;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=o2rewCfA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gNOFwnmK;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf14.hostedemail.com: domain of clopez@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=clopez@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793898066;
	b=dDcVoVQDYoetrmQEMbB1EHr8eVHXoiBIVv7tJe11HAgbYcyINlGEEOgY1fg2WIPl5k3XzR
	HNiVkBnJtIpXnHV1KocK25rJRH7x8g9SQDuIeoBd7ad8YKVmU5jPXfp5sMNMso1+dyBohj
	k5njP9HJRKCBVpdaezGd/dG+ReQZ8Js=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5FE6D22937;
	Thu,  5 Nov 2026 17:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793898065; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zJ4YMgar/+f3xch1CQmR84D/AWFtiNZ8AwAhZEnWX4g=;
	b=o2rewCfAnbi1hi0MofFMdb9Ixx8NBxq97b3E5eyBcNFiBDcnEHA/FcNJrljUp4KAPbfEuN
	MO7dqjK5dOd0b+XN3ue2BGEy1uOew2ZFUM7ucie5f0BEUHakLT+5Oxhlpe9roQPHm+E6Nc
	QXqStp0DXuqg2djuEq5GdV7OvbrQtyA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793898065;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zJ4YMgar/+f3xch1CQmR84D/AWFtiNZ8AwAhZEnWX4g=;
	b=gNOFwnmKOfXqFUyiXGIpJJR+IwTNMewBrh/2d7AdIwYvDM6h85yo91Qf+wKyAI2vats1dw
	WdwdsPOSHQyQngBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793898065; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zJ4YMgar/+f3xch1CQmR84D/AWFtiNZ8AwAhZEnWX4g=;
	b=o2rewCfAnbi1hi0MofFMdb9Ixx8NBxq97b3E5eyBcNFiBDcnEHA/FcNJrljUp4KAPbfEuN
	MO7dqjK5dOd0b+XN3ue2BGEy1uOew2ZFUM7ucie5f0BEUHakLT+5Oxhlpe9roQPHm+E6Nc
	QXqStp0DXuqg2djuEq5GdV7OvbrQtyA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793898065;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zJ4YMgar/+f3xch1CQmR84D/AWFtiNZ8AwAhZEnWX4g=;
	b=gNOFwnmKOfXqFUyiXGIpJJR+IwTNMewBrh/2d7AdIwYvDM6h85yo91Qf+wKyAI2vats1dw
	WdwdsPOSHQyQngBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 16CD5134F6;
	Thu,  5 Nov 2026 17:01:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HMEkC0K27GqWRwAAD6G6ig:T10
	(envelope-from <clopez@suse.de>); Thu, 05 Nov 2026 17:01:04 +0000
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
Subject: [PATCH v2 9/9] KVM: s390: don't unmap the gmap on permission upgrade
Date: Thu,  5 Nov 2026 17:50:06 +0100
Message-ID: <20261105165004.2663799-13-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261105165004.2663799-4-clopez@suse.de>
References: <20261105165004.2663799-4-clopez@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -12.30
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7FD41100005
X-Stat-Signature: q7ixbsr951hd7umxc1tx5s3qehf4gggc
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793898066-962796
X-HE-Meta: U2FsdGVkX1+Wn+8vm2ZawZWJ2TfnNdqngcxzBK9OgCMKEZKcy8DHeP/vPm3fU7i/+vup+pSCCiA1MN78JoRhpYvgMRd1KZbigxhwPyNOT81MC6B5BJJnPapuDmbrtuEonrMp6HMA36TmckHd2p0I7mXgAqtXVucMPr/kRB8bWZFCTZo5of6KsOeKN5MwRMSrCPhdngEsf7tDrreRhXzxgO3qQfUtotmL9L20yyEUTm0P4KaNpU67PbWLRNU7naKwaQODPF0f4A7lzbHZXiZfZOdUVWjjcDU+MZN0dK47UniESPQOKdk65MuKJek+wlgJ1odu4zDsF47+Tm1lZ9l0snj682oXgXXX1f8vpAdeVgBmvKBmUcPOXwy/zrhFF56a7lx4A5u3G/+j4bIhK65AhNVfrDn9HpqEEFKLQORHNV8St8+vNay5kiVZV3JGgzafYKsGE8FvNJ3DW2g1eniJUTYsXPqtmJtyu/Mf4APYHYR3/d7EJKw0Lw37rDj9RA6TB7Cyef+uYIxZlfac7hIcDOKPqgURD8Srz/Wy4eJ7y2zPn3s7R745dXrW5WOV922srrshuLGV02j9w5AwVg+E9WgLLVXC8myB9MPZiHNoiRBrDkSoMecnUqCZ804A3DfnkTXsdeb8tQEzovbQjPbaOdsELI6lUu8YBAKlpeFXahleWaXOtIEF2k2CJeotZ37jbTFmBXYN62xUGqDe6tjU2SIO74u9QDbeXCHAatEimJqLPcRAFIiAlJkwf83knYllkM385Om86Z5F4RlhF2AM8eHhq1GFhI6Y3dJ0jKapy59thekZ3i4d+fojf7Hlfy2oiemx8DxCGchhlrcuhcPFkTeAjFdQg6EaeQDqS5lZqVpLtItd6HDBa+eOPQw0ecdYT+gjkiJWdsOkQgXA//VgS75z1D2++bX5MuOd3HhLDBySzy0vfrj2M0CEV7pTp0QyXg2WUrZVqXns8vD4yqc
 PDFhKdEj
 MDylVWgk8wfr2nCrsY1FbU/qq2o4T/+09U7b2Q3W0YUJdFmdvgpSMHHTO+HLyAk9k9D7lJONqDQ7h2Xb3PG+PqaYHe3HMV33/f/ucOygd6y/VFgJ2FRxYOVwEumGHWPsYNyUqmHdruY0THpNAZDBah7IXEOzwX54sYywQvB6DgamM78GaU0KlfQf5Uqv045YTZzqCpkbxOgEdGNDWsRTia8Du2S9wtirp6K+2m8+yfPn8mbrr8MwFjxiNoa1oD8HcHWkuZS5DWBEf9sx592q7D/g91cvBCYaAaNoruy8qoeALxql3b6Q/F7oee0cgrg5Hl3A+
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
exception, which kvm_s390_faultin_gfn() handles as a write fault,
picking up the new permissions. This applies to both s390 and arm64
guests.

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


