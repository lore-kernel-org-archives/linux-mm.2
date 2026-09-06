Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7B03C79F99
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 08:27:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D120A6B008A; Sun,  6 Sep 2026 04:27:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE9F36B008C; Sun,  6 Sep 2026 04:27:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C269F6B0092; Sun,  6 Sep 2026 04:27:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9E17B6B008A
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 04:27:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8F9FCA02B5
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 08:27:29 +0000 (UTC)
X-FDA: 85182658218.08.1D86BA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id D4D2680002
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 08:27:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B9xOmBhf;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788683248;
	b=O55LzzMRs9wuI1ICTG4SGuFjn+MrixlXxPd1CcyYQq2a9b0ENdsYO1aoCSSdYH+FdGDvUG
	XRPYu+TwnfMqzVm79k1+NEGUii53Zz8ZJieO8mUEbwfRG2vU08eGP4smm/mDEUAvHrzttf
	fsE+N+2Pt6N7PJkMl1f1xJIoY+z4Opg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B9xOmBhf;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788683248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+/DLks/ODhSSfW/GITBux87qvqpTH/gxUu8xFDYHwLA=;
	b=gcHyyJ6fJNMZGXkZlocpKNpZVu7sJkv0ikl5cyRnBiBlbsylhFRKUbCNdcvNcDpr5HGnvW
	3TcXLqSbmJtCDik48VxNrM7O6nUe7ROgkD6Me/dZ3nrXK74HegBqhW3JoloB50c0hpEHTe
	YDGjNOkW6QA4HAJLSS8C88udyvA/5Uk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CBE0F41600;
	Sun,  6 Sep 2026 08:27:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B3C1F00A3E;
	Sun,  6 Sep 2026 08:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788683246;
	bh=+/DLks/ODhSSfW/GITBux87qvqpTH/gxUu8xFDYHwLA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=B9xOmBhf5s1dNs5ihOaIRxoyVrbv3vnNPdqW1m1NfKoTMp2VCm129J6VEykH+qPZy
	 TYo/4xEBX69W2vMkcM/8fu+tw+R4A9OS3OLvpBmVySnAEgusWdb85ZFx7idRl6qYmv
	 8iElq7IoQW46OE+TTLDuiloZmzhPMfm8DuRYIOkdyCVw0R9QiAaKQUVYyOOe2fdaKv
	 lcJpzhvsJdNb52UKsz6NgKjJsBFqv5aA3FMT+9lqSulnkIrpwNf9N7FzssS3icUuFR
	 vh5/spbemJxViWOplTH8NDh4Mc/rX3ETRLyXT1/ulYvl/lKJ4LgwU9W42ROUFOxjn3
	 Sdp2QgxR9wNnA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 06 Sep 2026 11:27:09 +0300
Subject: [PATCH v2 1/4] KVM: s390: Replace get_zeroed_page() with kzalloc()
 for the STHYI buffer
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260906-s390-kvm-v2-1-2cf6434e6646@kernel.org>
References: <20260906-s390-kvm-v2-0-2cf6434e6646@kernel.org>
In-Reply-To: <20260906-s390-kvm-v2-0-2cf6434e6646@kernel.org>
To: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, Heiko Carstens <hca@linux.ibm.com>, 
 Mike Rapoport <rppt@kernel.org>, Sven Schnelle <svens@linux.ibm.com>, 
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-s390@vger.kernel.org
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Stat-Signature: emc3m5zaon1xo84fconrsioeycheta4s
X-Rspamd-Queue-Id: D4D2680002
X-Rspamd-Server: rspam06
X-HE-Tag: 1788683247-543050
X-HE-Meta: U2FsdGVkX1/2hm+soSmqmgHP7C4G4UXSEvf74cFypazjA5f+0XAYhP9O1fpYGZ+euSPi2aV/3QkC7V/bpfzqq9pYrHQwZdGxrF8jJk5lheHK0nPzPQxzDp+7dyv09LR98tBLNuD2bsZ59INc5Ex2+dwWCSc6uXXye9pkXn27PnXq4JACzSC4fNsZL6e4/Lxp2cHgsrxXMpdtNo1u5OSwccG95ySni/uyWir/lPYrpt0nUcobhei0HWWZL37FZxjdxUGA2WjvKsIvzo4M0draKqNLLWR9+E7jJ7+CFWz9YgRVeYBQd4xdDhSJ3WdLQRKSbcBps1v8M9b+bfQhfEScWWwUabR2IUpEJuOc6d+gwOcz8xHPjohEDRI1E+S7mI0GY8VLN3SDf4U1mwZZ088HKmWjZTtN95x3vM0P2hWYo01FZ4bOYCw3+Ar6+nzGZDO6dnThHy9NNniHLkZuTvkDy77l4XQZnZoEV3QhXyxanR3IT4RFsnJt4l/JlRsFu3DrX4J0ohpoGx6wH5QuUE50qbyWCi81WUQ8WczrNCr+rpM0G33GL4bIolKvD42o9dQ+R2Hlu4ybbogRf3CA1edIlFkpKAtPM6b9kwSTnIR/RAoiiIuri1DpDfGXE7FEb1mPJ5rkEXWeXprRl9z7J1GCdWeLCPnjkYL825OYIpk1IrXmNWHSSPlqewY8p9CcIdMMvXR+koCQ3w2FVJ8BQQVaDjRiA6kBb6K/uRTfRNC7YVNZGASBg6GZI9ale9dVlCDK6/T3+luKHpqsJDeSbq5VT6MIRZUXCJThFKX1WuFaqc2OJxfGRqXirkdSxkwdRPQOPIuU1yicLhbmWPMXWB7c1vGfyXBJNTwWpxCpk5WDrA7FxFYrmFfLwaHJ/cZlxC77ZVG2+GeOzma3PlGJpdi1rggGLwh4sJ7dQbKrCA7tKxa475rf1S7VXxLyr3Dtb0XQGuwTYmIGUHKLuUphxNC
 l42Yaixr
 jaafV+f7XdbE7qbvDNEFIXnfjthyXAE9RrfHp3gBVUMiYY6VR/b2c18Kq1MDaYAiWNe0m5zvLgf5ZW/0slxPUGyChWPhbg27xq7e+D+jem/ifgzhI7bwTphkJQr0o+kEnfzglrSDNP+LcLdCR7CB0dhaJ7K+Am+17xHgylIHMJ1NX6lwGHFxsmPLyYrK4ARrJBJmrSWDEAUSx3Fd58d3Ve+eBaAI1FvfbdQqlHxgmKoC/dx5dy115oE6Hg20qNDOM6IpNGqC6Ut7YG8I4tDwpEno0zzjBrvzBsNyp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

handle_sthyi() allocates the buffer that receives the STHYI response
block before it is copied to the guest.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

The only goto in that function does not unwind anything, it merely skips
to the exit when the function code is invalid. Turn it into an early
return so that the buffer can be freed with __free(kfree).

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/s390/kvm/s390/intercept.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/arch/s390/kvm/s390/intercept.c b/arch/s390/kvm/s390/intercept.c
index ca1205dfac8b0..f7ad111f259c9 100644
--- a/arch/s390/kvm/s390/intercept.c
+++ b/arch/s390/kvm/s390/intercept.c
@@ -11,6 +11,8 @@
 #include <linux/kvm_host.h>
 #include <linux/errno.h>
 #include <linux/pagemap.h>
+#include <linux/cleanup.h>
+#include <linux/slab.h>
 
 #include <asm/asm-offsets.h>
 #include <asm/irq.h>
@@ -411,9 +413,9 @@ static int handle_partial_execution(struct kvm_vcpu *vcpu)
  */
 int handle_sthyi(struct kvm_vcpu *vcpu)
 {
+	struct sthyi_sctns *sctns __free(kfree) = NULL;
 	int reg1, reg2, cc = 0, r = 0;
 	u64 code, addr, rc = 0;
-	struct sthyi_sctns *sctns = NULL;
 
 	if (!test_kvm_facility(vcpu->kvm, 74))
 		return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
@@ -430,37 +432,32 @@ int handle_sthyi(struct kvm_vcpu *vcpu)
 		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
 
 	if (code & 0xffff) {
-		cc = 3;
-		rc = 4;
-		goto out;
+		vcpu->run->s.regs.gprs[reg2 + 1] = 4;
+		kvm_s390_set_psw_cc(vcpu, 3);
+		return 0;
 	}
 
 	if (!kvm_s390_pv_cpu_is_protected(vcpu) && (addr & ~PAGE_MASK))
 		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
 
-	sctns = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+	sctns = kzalloc(PAGE_SIZE, GFP_KERNEL_ACCOUNT);
 	if (!sctns)
 		return -ENOMEM;
 
 	cc = sthyi_fill(sctns, &rc);
-	if (cc < 0) {
-		free_page((unsigned long)sctns);
+	if (cc < 0)
 		return cc;
-	}
-out:
+
 	if (!cc) {
 		if (kvm_s390_pv_cpu_is_protected(vcpu)) {
 			memcpy(sida_addr(vcpu->arch.sie_block), sctns, PAGE_SIZE);
 		} else {
 			r = write_guest(vcpu, addr, reg2, sctns, PAGE_SIZE);
-			if (r) {
-				free_page((unsigned long)sctns);
+			if (r)
 				return kvm_s390_inject_prog_cond(vcpu, r);
-			}
 		}
 	}
 
-	free_page((unsigned long)sctns);
 	vcpu->run->s.regs.gprs[reg2 + 1] = rc;
 	kvm_s390_set_psw_cc(vcpu, cc);
 	return r;

-- 
2.53.0


