Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D319C79F99
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 08:27:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F3686B008C; Sun,  6 Sep 2026 04:27:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A1DD6B0092; Sun,  6 Sep 2026 04:27:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71D756B0095; Sun,  6 Sep 2026 04:27:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D1A96B008C
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 04:27:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B631380489
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 08:27:32 +0000 (UTC)
X-FDA: 85182658344.05.736EB76
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0CD78180009
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 08:27:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AcR5c2yr;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788683251;
	b=iaVbBFgN7NCok5gr5u+lZPPpJhkwi+t87+HQfgdhk3bzu+YRmjuKMFcCmlFtWdmVV8E+Qv
	sHobG3GnLrAZRXn96jDK6rpPltRvHSUvYiVLXi4rf2N35bvqVR5YLcohAf89ExqQNUnm5L
	kLAcPrhUYhHN1/fel2Q6VoGzGogI8aM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AcR5c2yr;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788683251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YsA6hNpdDuoXhmxFeC3uv8uIXxR1ksQ/iBUtdB1feUs=;
	b=UIG5fPALg463Kn7+QEVgzkxRgWj6O82ccOtzuIRrn6Nc5TVIHgDU3etlAcHjlgajQf27ne
	96s9CZEqXrXCBIYo6AzqcQ/m34xl1uGh8YKeYFRitGjVWRhZbqiEOcslkBBMR7vASjcVlO
	rQjtVUEe694bh+A28tYjQpFFH7mDe08=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6048941600;
	Sun,  6 Sep 2026 08:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361E51F00A3A;
	Sun,  6 Sep 2026 08:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788683250;
	bh=YsA6hNpdDuoXhmxFeC3uv8uIXxR1ksQ/iBUtdB1feUs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AcR5c2yr8yOxaqMU6PZEBu6m02H8NVpIdqeHBB2EFX2dbaMH3nSarLvRXgeWGBiM7
	 MIeq9DCB9ddMgZ9WeZwLv9n9Y20tR0MzTXQj27Hwib1mXac85h8xBvnuyCvHWezux2
	 JIfpisVjB0kWI3S0X3DZ9SuUMtd+02l8kekxpIcWiS19ONEN8aUAy+NihFDQo50gZq
	 53+02iM0MXsyxPvBUALso3DG9nZBiUHyTVdEGOXM0u10Vm8Kaf7ONJfjE+tVA10+dk
	 78/QrcPBTu8wyNMeh/0ockC9hYKzU2A2vYBSNZhg9kITxws6XQw3NY2P6WmueaV82Z
	 hfqq6KEYyZXHA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 06 Sep 2026 11:27:10 +0300
Subject: [PATCH v2 2/4] KVM: s390: Replace get_zeroed_page() with kzalloc()
 for the STSI buffer
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260906-s390-kvm-v2-2-2cf6434e6646@kernel.org>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0CD78180009
X-Stat-Signature: nmifd86xpb6rb5h7gw76g86cq85mi5ng
X-Rspam-User: 
X-HE-Tag: 1788683250-35975
X-HE-Meta: U2FsdGVkX1/Kp0QBBOwphSmCgM9bPjZmKE0hl+imWEoTSWex/jRMBuleF5cCiX6jWyCIOtid1GtfxOTcC6ahLNdQSx7HlBPH7lXCF1KZTwN1Dp7pFWMZ9W/l63pMuHBksmn+MxV04/NtyoUV8MIiYUglKl8qSTur10kumb5fEAEguvAKTxGsdHpDPrcThn9vuv9EBsgClqCER9VObPd5Aoc7V2II6hsCx1yCtV+k0Q9d50AFMk7tAmYlZZ3JQv8wv7i0ptXCAnaehoWy0ncob5pLwsST2IhcthMFvDWiFkTXtlbZ+PhjR7DQbWvfyWnBMO/Zd7RLmagq4ncCvRQo4CmtMmsBdBYd0TotT1aHwzXVZd42iTfPUTmfCkJpI3R32uDv7ZVJb4uL+LeFCp1PU6hkb3QI8nxvvdQRvy4QdrL+3+Bpg3yiEMxe2/x5zDOgapezXP2DpVn+P7ECkaR+tDk2AiKghR1BATYPTSZ8VoAo4smjXQANL4G3b6P6rH60l5KWowT6lWVGY0jnlqrJesVvbIiO5YPQQpSxL0P7ES6ggTXtQujYkjR3UIkEAQK2MFfp3LXd2NQTNZE78GeDHhjfB4UaHFMsrSQmukldWPnFqA3jbBmf3fv57D4jX9Xbc+luxHGzCeb6JNL1ylkmyVGDOiZqZ5Oe5SQKE1JbYde9GJYRsaeCLM+IspLjEC/nIbvAveVbKK+MWtQSwXIAWImEL64rtQPTVgi78GPnpaPZGJwv+bx9jXkiVUP5hpzIPzO9WRlC3Xnfn9BLsh1I4XYzaZhack3ko8g0OJqJldQKobzVCq7f4+3XDFCiBYOfk1LN23snafkbWjQ+dEKeGclK+PRkR6nyXgDpA793F+ay/WzML30tqte4xPtpNwv3Ek3bDodVHqJJxFrzoOHmFQFvA/C8VEV16gcsWJNeRd63uky98lTO0pSP/bV2Hlre3bT8x1dX7oAXR8YGaVp
 sWG+eX2p
 9X7GfkFHRPaPYSyrHIr9aomT3tE+W5bxM7gQgzDCX2hlqOnNd81b+TytriaCkPMtdnN8fURR3dUKyyE3m5R0RjE4orNGRK8soILsqA5okJ+z727gdLaPv21gBZ7qE1t4l2jqQVNsNh2f74g1d3ovVKSs5UgLMmAOcTM+1Vqk8zofkesfJQIq1okaEgCpDJso8QFpU12brPsw8SO3wDrPk4HX+a3LVIrbKI6jd/2C5qaGC+oGWe7nb9q+S8YHHZp1tRu60e3pJYRsVWAhV41tlMGKLrX9qkVDhbeEoPeA7gO2qwllnbw9z8Y9QcwhsU3Qw3p3R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

handle_stsi() allocates the buffer that receives the STSI response block
before it is copied to the guest.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

While on it, make the buffer a void pointer to get rid of the casts.

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/s390/kvm/s390/priv.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/s390/kvm/s390/priv.c b/arch/s390/kvm/s390/priv.c
index b3cb2c2c3aa71..856939acf012f 100644
--- a/arch/s390/kvm/s390/priv.c
+++ b/arch/s390/kvm/s390/priv.c
@@ -14,6 +14,7 @@
 #include <linux/mm_types.h>
 #include <linux/pgtable.h>
 #include <linux/io.h>
+#include <linux/slab.h>
 #include <asm/asm-offsets.h>
 #include <asm/facility.h>
 #include <asm/current.h>
@@ -869,7 +870,7 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
 	int fc = (vcpu->run->s.regs.gprs[0] & 0xf0000000) >> 28;
 	int sel1 = vcpu->run->s.regs.gprs[0] & 0xff;
 	int sel2 = vcpu->run->s.regs.gprs[1] & 0xffff;
-	unsigned long mem = 0;
+	void *mem = NULL;
 	u64 operand2;
 	int rc = 0;
 	u8 ar;
@@ -911,19 +912,19 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
 	switch (fc) {
 	case 1: /* same handling for 1 and 2 */
 	case 2:
-		mem = get_zeroed_page(GFP_KERNEL_ACCOUNT);
+		mem = kzalloc(PAGE_SIZE, GFP_KERNEL_ACCOUNT);
 		if (!mem)
 			goto out_no_data;
-		if (stsi((void *) mem, fc, sel1, sel2))
+		if (stsi(mem, fc, sel1, sel2))
 			goto out_no_data;
 		break;
 	case 3:
 		if (sel1 != 2 || sel2 != 2)
 			goto out_no_data;
-		mem = get_zeroed_page(GFP_KERNEL_ACCOUNT);
+		mem = kzalloc(PAGE_SIZE, GFP_KERNEL_ACCOUNT);
 		if (!mem)
 			goto out_no_data;
-		handle_stsi_3_2_2(vcpu, (void *) mem);
+		handle_stsi_3_2_2(vcpu, mem);
 		break;
 	case 15: /* fc 15 is fully handled in userspace */
 		insert_stsi_usr_data(vcpu, operand2, ar, fc, sel1, sel2);
@@ -931,10 +932,10 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
 		return -EREMOTE;
 	}
 	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
-		memcpy(sida_addr(vcpu->arch.sie_block), (void *)mem, PAGE_SIZE);
+		memcpy(sida_addr(vcpu->arch.sie_block), mem, PAGE_SIZE);
 		rc = 0;
 	} else {
-		rc = write_guest(vcpu, operand2, ar, (void *)mem, PAGE_SIZE);
+		rc = write_guest(vcpu, operand2, ar, mem, PAGE_SIZE);
 	}
 	if (rc) {
 		rc = kvm_s390_inject_prog_cond(vcpu, rc);
@@ -945,14 +946,14 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
 		rc = -EREMOTE;
 	}
 	trace_kvm_s390_handle_stsi(vcpu, fc, sel1, sel2, operand2);
-	free_page(mem);
+	kfree(mem);
 	kvm_s390_set_psw_cc(vcpu, 0);
 	vcpu->run->s.regs.gprs[0] = 0;
 	return rc;
 out_no_data:
 	kvm_s390_set_psw_cc(vcpu, 3);
 out:
-	free_page(mem);
+	kfree(mem);
 	return rc;
 }
 

-- 
2.53.0


