Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74A2CCAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:11:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B32E38E0007; Wed, 24 Sep 2025 11:11:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABBA58E0025; Wed, 24 Sep 2025 11:11:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9819A8E0007; Wed, 24 Sep 2025 11:11:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7DACE8E0007
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:11:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4A208C05C8
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:11:39 +0000 (UTC)
X-FDA: 83924483118.27.ADE2E5C
Received: from postout2.mail.lrz.de (postout2.mail.lrz.de [129.187.255.138])
	by imf12.hostedemail.com (Postfix) with ESMTP id 06D114000B
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:11:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=lmu.de header.s=lm-postout21 header.b="D s3tHqp";
	spf=pass (imf12.hostedemail.com: domain of patrick.roy@campus.lmu.de designates 129.187.255.138 as permitted sender) smtp.mailfrom=patrick.roy@campus.lmu.de;
	dmarc=pass (policy=none) header.from=lmu.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758726697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PniUGv6KoWbLzxsjGhaF2BGkvfN+PIVzF8ZJsy2VjBA=;
	b=2xTf1HyDEB7CccUo5h3W7Chkm1Z79gr/gec5GU1LQNbMe6zmadCqW0qitUZP/eyTshlGhV
	awg/tRhCXny24Am1oo+fWGGq+YHnJ8MEuI5t0aJHEjrY2mCkNuvfVHpSTMNukSyKXKi5fF
	uHP3w3PJepJpebCkM8tdDFU7mCtfhOs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758726697; a=rsa-sha256;
	cv=none;
	b=RSPlN5k7kZUMbPpOx3chKSCT71F/NB5QRCYlAJyxXJTEDeXe09S2JzM+CQ6q5pCVoE3klA
	jK8OUaGxb9BSrP+ecEqifqhkdxLWzinWdQ0gqCobHyJmUWZSmMiYvJct9HrbcniwbVTdd+
	j3yxA1aTx04K0jRx0H2Xx0kio5yQz3I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=lmu.de header.s=lm-postout21 header.b="D s3tHqp";
	spf=pass (imf12.hostedemail.com: domain of patrick.roy@campus.lmu.de designates 129.187.255.138 as permitted sender) smtp.mailfrom=patrick.roy@campus.lmu.de;
	dmarc=pass (policy=none) header.from=lmu.de
Received: from lxmhs52.srv.lrz.de (localhost [127.0.0.1])
	by postout2.mail.lrz.de (Postfix) with ESMTP id 4cX0gC2Zl1zyXy;
	Wed, 24 Sep 2025 17:11:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lmu.de; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=lm-postout21; i=@campus.lmu.de; t=
	1758726694; bh=PniUGv6KoWbLzxsjGhaF2BGkvfN+PIVzF8ZJsy2VjBA=; b=D
	s3tHqp43ssNDXomgsZBIvc4eGGgChOsGKqbB8qjdKMv2lHKagMLmabwzb4Spn3RE
	8UddA5FG7r2qcfUPf4G5tP8KUJYLZHqeVXljFu6VvMXApZbymhc0YPnqs/PsM0QS
	4Fnxf1X7QSNNc5XguswqkqWhMpjTO0axQxglgsgeTEf4Gx1J4t0rqWZJeQw6g2+H
	AF+2u3P0wFYeJK3k4oRR0a0AMEjmlhkfvKOwlYEI7nM/9Dv7/I0Wwo+taajRFHDB
	iePy1P7pfoaz1x/To3Yks5rBkethnWV4Fr0dFuVz+y77Ct+PM3h+DVhu5MXb7iTR
	gGGXfxoGKznCXx+o6b43g==
X-Virus-Scanned: by amavisd-new at lrz.de in lxmhs52.srv.lrz.de
Received: from postout2.mail.lrz.de ([127.0.0.1])
 by lxmhs52.srv.lrz.de (lxmhs52.srv.lrz.de [127.0.0.1]) (amavis, port 20024)
 with LMTP id icm6tp2oYbWr; Wed, 24 Sep 2025 17:11:34 +0200 (CEST)
Received: from spacestation.cable.virginm.net (oxfd-27-b2-v4wan-164230-cust474.vm42.cable.virginm.net [86.22.133.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by postout2.mail.lrz.de (Postfix) with ESMTPSA id 4cX0g74qG5zyY6;
	Wed, 24 Sep 2025 17:11:31 +0200 (CEST)
From: Patrick Roy <patrick.roy@campus.lmu.de>
To: 
Cc: Patrick Roy <roypat@amazon.co.uk>,
	pbonzini@redhat.com,
	corbet@lwn.net,
	maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	luto@kernel.org,
	peterz@infradead.org,
	willy@infradead.org,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	song@kernel.org,
	jolsa@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	eddyz87@gmail.com,
	yonghong.song@linux.dev,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	haoluo@google.com,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	jannh@google.com,
	pfalcato@suse.de,
	shuah@kernel.org,
	seanjc@google.com,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	xmarcalx@amazon.co.uk,
	kalyazin@amazon.co.uk,
	jackabt@amazon.co.uk,
	derekmn@amazon.co.uk,
	tabba@google.com,
	ackerleytng@google.com
Subject: [PATCH v7 02/12] x86/tlb: export flush_tlb_kernel_range to KVM module
Date: Wed, 24 Sep 2025 16:10:42 +0100
Message-ID: <20250924151101.2225820-3-patrick.roy@campus.lmu.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250924151101.2225820-1-patrick.roy@campus.lmu.de>
References: <20250924151101.2225820-1-patrick.roy@campus.lmu.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Stat-Signature: itc9ne6f7ynipoiymcpoik6wnubjt4a8
X-Rspam-User: 
X-Rspamd-Queue-Id: 06D114000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1758726696-542243
X-HE-Meta: U2FsdGVkX1+7XJf1BnCIo2QuU1vNgIsORs60Jfpar7gZh6/mP63w6HCel5EpplSWS1V3eR/qz8UfYZQMIuIFEaFtcqTVDdQnYyp0PF7cihmdH5/QAEwjzLYs1Dg0ASmoQevyCopZKWGtAe2eiQ6mojdyeH5tTPsIy5KCiLbvP1nnWa4SfasxerOoHFu0EBXy6HkgNudqU8uQeDCJv3rXHlBllajTxPHe7+y+KI+d21wfDak+KBqdAe4E/H4bCbdvGvLdR6+IPAjtnshhtlh3NciwceCUWBYAkIzzOTxSW0DI0pHS7DG4mh9g5I86D4E+IsF38Vflokdo/CTepuJMmEEDtahFsNuy3BQxpEAmGrsjccaCXvAbVKVEMQmilgstc8S8DS2raOUpyYLecAHsSoOij7Fe7t3gbRvEEgDXShSTnA+Y4ozPVtPpX3kY0P/PVNkNfH4mzre0+pAXxiQpUEYVO9+JaD0SISxMIo42/tS4kvmiU0CylLwEEV12sxCUM85/L9/iBRYbUEZXTIjeobY3rZEo1t1/oTpUE1Cwjp/UWl/FvderBZw1P16iROSrXZt0lnTOvCtJNU+K7/p7BU0IAXPnYEkuYegRPxzoiQbRF+lStdEcZc2eMb+oQFFHHzYBf0BQvPRhYxMuKHieI0aRDrfSErjfrCjlvNfbbM2XTUTGVz3b8t/3NCmKuieqfHxftP8gSpzi5FIK/u2gpfsRDWH5i0NzwnUKGLrV8drXN7M4aa0hmHPZK1Y6KtMxGJ/I3xy69QZMLdt0be8CUJEIcY/KJK5VRmbsSl9DC9REa6JYApQnN2httq7F+kBuiTxhCLEph8SIvGu/0ADdzlld0UXCevL0Wd2rXiDjwq7t3TXQJQf+/T05V+/3xjtw0P/dcvJ78J+iDoS1bmoHnZQVcDaV98JZybzUUrUyojWD3q+W7p5PcW/u48H5PkJO/RSSUgxFNgzMYkoQjUc
 IjIWh1jR
 0Lb4ctG0ppQSss6tWAJHZkoRxs2oGens9bOBLoo1aZv5JmuER26GVHqE0l1O8LahihVmc1G/11EntWL3RQb/OIiW7EZEKCRSqEsyv9SS35QvJ8W8fsMMOWUUk9pFWgNoE0Bgxy/dEUcL+/pcPEdjqNGaTqojvirK5zX/2M4M0noQK02Z/1zaehkPGTObExBoo3rAsga5y5YzHI674tTplhhqDg25guS4P75KjspjGvPHJWvVRQbTOachkZq0DA1ITr9WK9//AVTr8D/EWQK/kIR+COJtEkX0FcNaY87ZuPOBoGSM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Patrick Roy <roypat@amazon.co.uk>

After direct map removal, a TLB flush can be done to ensure that the
just-unmapped memory cannot be accessed through stale TLB entries. This
is particularly useful on modern hardware, where one can not rely on
timely TLB-eviction to ensure these entries go away.

This export is only needed on x86, as arm64 (the only other architecture
supporting guest_memfd currently) does not allow building KVM as a
module.

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
---
 arch/x86/include/asm/tlbflush.h | 3 ++-
 arch/x86/mm/tlb.c               | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 00daedfefc1b..6f57f7eb621b 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -317,7 +317,6 @@ extern void flush_tlb_all(void);
 extern void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 				unsigned long end, unsigned int stride_shift,
 				bool freed_tables);
-extern void flush_tlb_kernel_range(unsigned long start, unsigned long end);
 
 static inline void flush_tlb_page(struct vm_area_struct *vma, unsigned long a)
 {
@@ -483,6 +482,8 @@ static inline void cpu_tlbstate_update_lam(unsigned long lam, u64 untag_mask)
 #endif
 #endif /* !MODULE */
 
+extern void flush_tlb_kernel_range(unsigned long start, unsigned long end);
+
 static inline void __native_tlb_flush_global(unsigned long cr4)
 {
 	native_write_cr4(cr4 ^ X86_CR4_PGE);
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 39f80111e6f1..dee5018bceeb 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -1541,6 +1541,7 @@ void flush_tlb_kernel_range(unsigned long start, unsigned long end)
 
 	put_flush_tlb_info();
 }
+EXPORT_SYMBOL_FOR_MODULES(flush_tlb_kernel_range, "kvm");
 
 /*
  * This can be used from process context to figure out what the value of
-- 
2.51.0


