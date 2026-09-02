Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12EAFC624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 06:15:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6F246B0095; Wed,  2 Sep 2026 02:15:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFABE6B0096; Wed,  2 Sep 2026 02:15:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC0076B0098; Wed,  2 Sep 2026 02:15:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 899BD6B0095
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:15:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EAEBFC0593
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:15:39 +0000 (UTC)
X-FDA: 85167810798.27.DA018A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 40B63C0008
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:15:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WvNXHcrx;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788329738;
	b=DtOJ6j/7dgbYZjwxTucO/UPoySNu5HvYNnuZQG1W81QUyAs1rUsTo9wdc1ed/qFOFHXLJa
	rCL0DOuwU+3WT8WRGIDRfkcP0Ac4JJ7AM1TFvcC2vBdqQ5wGXPuMRh5Anxcy7vbb5ZlTwW
	pQLxeiGgodf1K69gZyGzlyv0LfD5nbQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788329738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YsA6hNpdDuoXhmxFeC3uv8uIXxR1ksQ/iBUtdB1feUs=;
	b=Xg/r7syrYplgE0zWMx4zGwipZMPnb3U71Kqmstb+rWzhwfl8UJXi3vyd1C6Tq70d7py2lX
	0YsadVs14d+BQHqLEPsRx3m7hB5AyEbgqWus+zCLmlT2lJrUnCjd5JfwViyJWnN1dtp3Aq
	kSdKEKl+EXG6gFi6OIDWv5ZYIYbU8dg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WvNXHcrx;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8FB6144787;
	Wed,  2 Sep 2026 06:15:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587011F000E9;
	Wed,  2 Sep 2026 06:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788329737;
	bh=YsA6hNpdDuoXhmxFeC3uv8uIXxR1ksQ/iBUtdB1feUs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WvNXHcrxV8JKaRtt3T+TgHowGmPOJ4H4MgCw7LvVDttuAHoV8YajbSc586+Rw1gFT
	 1fgWfos2HoEwwgGmf2fwT7rUv/cZnEG6lheWHkQhjlrHRPyeM6CgQ35aBMGDOlIDQb
	 /fcMnjoLLunKuouuieMHEpD/HuxY9/fPUdnP1LS1tlXNxz4gZriv8nN3DIKHWLT+BK
	 C9qIfJouDe3OtAGA5Rqgs8L3WfXmxVGyHhfOx0HskVeGN/LsdbVntcaw3cwgRNjaAs
	 eydF7OqQZjyyls4A7K32MsYBafb4e24W6+SewzgGWol4DaaEcQIGEkf/29pCIx6ML/
	 Ts5YBGxnhGnGw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 02 Sep 2026 09:15:14 +0300
Subject: [PATCH 2/4] KVM: s390: Replace get_zeroed_page() with kzalloc()
 for the STSI buffer
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-s390-kvm-v1-2-3bc0986550b1@kernel.org>
References: <20260902-s390-kvm-v1-0-3bc0986550b1@kernel.org>
In-Reply-To: <20260902-s390-kvm-v1-0-3bc0986550b1@kernel.org>
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
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 40B63C0008
X-Stat-Signature: cbuy5j6yhs4cfe56bcabgpu4xkacy7ad
X-HE-Tag: 1788329738-498853
X-HE-Meta: U2FsdGVkX1+xp3FuJ/1J5UDBMGRlVYRrXClYsA2FMXuZTC1shq0eXpskwi47ale8szCKgLPro77K9wgDTyffI/Mt5wa4O9Q2Z+OKUGHSgZ5AOLSH6UG0PIhhKIBFjixXVwT+xMN967sy3m+W73FaVQeyt72SbkTmnqsV5YTiuYJnZE53lVXMTLeNIJzhIwIxbMZpV1cWr/aKj1EZ52gghbcHCpNuv9nLDhxgQwwWs5lOL+pFQ+j51TIA7wqwaeDfMboJPd3b2j5f7A9VNQyUZsiEFHL8iaUN+gH6HiBqtHG8GoqNMs5Hi9ytSQY/lyp/COfmkxPGcg5/TVtGC3x1CRoeQ7tyt7bB8M4O3V1KB5oJx5Cxf0dtd+RNbJFq1p/DXxetRmbxkYxPrKamBXyrFJk6Zc7lpqVCoSoqF73lCYmfq3upmHRXlq/hYCR9Ti8KAlvjVNvPL1cAzg75VeSgReI8ET9QvKVcb6B710JqXXOnj5Pa86fqe3SEhrI5iob0L1IQOmCO58OJW8eFUqDjyWdTajE+Jbh5avtSDMQGkJI1osi5Q8Rdcv0VaJBwPInNIwbcKdKH2/+wFzgrfk1afE97y5NeKe5XSLWGrnYCXF605oVVRG/ZS47ZYKrKIWsGYjbw+HvGGN19FNJpIOzGWR2ISkUdEafWfsvLX8ylPOq0+C3OqdF2DNaNGFmjVWg/1CTkvdfEjsleyO4stRP6rHRSyK4XnvKU9gADsTtwCrSvqv2EpGaCQEQtZTRxV835zO/lrGmHQhLZqfBv/edMHnq69LmTxmnixGOfblB2NrFD1ot/2IJvb5xzdlVYtQQzfuYghZsffMwbOPzyCCcFUjB8qepeQx6/ZswQnLKTKSXR745XE9w74kAihglYYzPmTI8gYhin9CH9TmSHfwxoYsF3KZIqHyg0BvM3/NntSWFgdMlzwGM/ksNrCw1SnL2N2Yp/zPx8dqMevs0fr6A
 jQ7EFAqG
 gXLLFG/zwanBCD/3kFbjChwqFa7QTMuhWcsrYhCp2FI400CQAVmJgHjFrJW1Sns1omydReaVCcHpR48qIZZTh/fyAf5d9ZUP1weYcaw5WmwuNiUd3IaCcmmQLqNWhQnMJI1iFNQeE0+x+ArHrllsZwxQ+Kom8L+38E6a/ndndA/7qjMNC0FZeIHOEU7Phlco0YKgEFrD7KlDYnAg4WKQg9KLvtk4lN550y3UvwsZR94f9Q8pCjD+MU59moaq7Y4zTbhe7ZRb0ISr4jtt5FK4K6zNOLUAJJjpOlgrN8+qaY1nclIwalffjusNqtCw9msNZwTE+
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


