Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B920DCAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:11:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E3758E0024; Wed, 24 Sep 2025 11:11:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 194468E0007; Wed, 24 Sep 2025 11:11:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05BEE8E0024; Wed, 24 Sep 2025 11:11:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E65F18E0007
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:11:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AAF57BBEA3
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:11:38 +0000 (UTC)
X-FDA: 83924483076.11.6C59F2A
Received: from postout2.mail.lrz.de (postout2.mail.lrz.de [129.187.255.138])
	by imf27.hostedemail.com (Postfix) with ESMTP id 930DF40011
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:11:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=lmu.de header.s=lm-postout21 header.b="E RCmo7G";
	spf=pass (imf27.hostedemail.com: domain of patrick.roy@campus.lmu.de designates 129.187.255.138 as permitted sender) smtp.mailfrom=patrick.roy@campus.lmu.de;
	dmarc=pass (policy=none) header.from=lmu.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758726696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wp7TACVDU5DtOz71qp4hjyzNeEjUGnycsxHnG+BQylo=;
	b=p0wSMpwYgcl6J4Vjv/QmQv7IHW+ZqeRm0H6ShL3PD38ypVaLYKUQU72qTKm1n2IUp4C4vm
	vmwfWR0vA+3V+IeFlCMl90xACkZStBuSaAhnOebFna10o29nHRQcQkWNkt6QcVtqol1pu5
	WmAK95ZX3Pdex/rbSaGXr6s+Vv9qFYQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=lmu.de header.s=lm-postout21 header.b="E RCmo7G";
	spf=pass (imf27.hostedemail.com: domain of patrick.roy@campus.lmu.de designates 129.187.255.138 as permitted sender) smtp.mailfrom=patrick.roy@campus.lmu.de;
	dmarc=pass (policy=none) header.from=lmu.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758726696; a=rsa-sha256;
	cv=none;
	b=ZM7/jqY9dzXY2sK1iAlIbDAx8rObvQARdYw0Rg6AmOtioXiHIc3Ii36U5dbzMdmUc9yLhv
	AdJLN7j/a3eV+cQ5sJVMLlBEvHIWOs5smfwEqBB8DaJcWUUZvPAcEKosrplQmOko6X0/dk
	Lyb5VjpExB568061go8JYh13z5nHJLQ=
Received: from lxmhs52.srv.lrz.de (localhost [127.0.0.1])
	by postout2.mail.lrz.de (Postfix) with ESMTP id 4cX0gB4hkgzyTD;
	Wed, 24 Sep 2025 17:11:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lmu.de; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=lm-postout21; i=@campus.lmu.de; t=
	1758726694; bh=Wp7TACVDU5DtOz71qp4hjyzNeEjUGnycsxHnG+BQylo=; b=E
	RCmo7GN3cJorQyZx7veOPX1uJX526B979gcoqD9YQPNg2IlhNVxWPFsMFg+QS/q3
	L/wVNxo8mJlMHtkp/bEvKP7Hn+Gec2q7CNLyZt0EpSMka0FGzp5jCLM+/4Q4Yf9m
	bVnNe2Tm7A8+i74QMY7Y1jxU7K7i3ZBWXNk3nMdvTZsDVJlux0h/VG4Yw7pbmUSO
	RpLfSu4b6GZEIpe3sZKqyNWAaDHGBchXBCWQzjhHNdflPiUJAQ9O1DmlqkXQb9EW
	Uhe+iIn9Bv6pA0Z2aDaAYUqxTzRjd0IKO7k1GlUoiaatpmzPZUMKJctUANGLq63W
	fc7ujWT6qB0l70vnk9IVA==
X-Virus-Scanned: by amavisd-new at lrz.de in lxmhs52.srv.lrz.de
Received: from postout2.mail.lrz.de ([127.0.0.1])
 by lxmhs52.srv.lrz.de (lxmhs52.srv.lrz.de [127.0.0.1]) (amavis, port 20024)
 with LMTP id bdh52MywZE5f; Wed, 24 Sep 2025 17:11:34 +0200 (CEST)
Received: from spacestation.cable.virginm.net (oxfd-27-b2-v4wan-164230-cust474.vm42.cable.virginm.net [86.22.133.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by postout2.mail.lrz.de (Postfix) with ESMTPSA id 4cX0g40m58zyXY;
	Wed, 24 Sep 2025 17:11:28 +0200 (CEST)
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
	ackerleytng@google.com,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org
Subject: [PATCH v7 01/12] arch: export set_direct_map_valid_noflush to KVM module
Date: Wed, 24 Sep 2025 16:10:41 +0100
Message-ID: <20250924151101.2225820-2-patrick.roy@campus.lmu.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250924151101.2225820-1-patrick.roy@campus.lmu.de>
References: <20250924151101.2225820-1-patrick.roy@campus.lmu.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 71doqgtwqgs51ds7zsrk7qq94wkg3yuz
X-Rspam-User: 
X-Rspamd-Queue-Id: 930DF40011
X-Rspamd-Server: rspam04
X-HE-Tag: 1758726696-888744
X-HE-Meta: U2FsdGVkX19g1dfr6PXsWkWNYn8xbbF5BD48K29XeBE9kdpXajfZ2Gv5uYcHNZikPxdj3o3vlkkA2nQjAISQ64aH9zapyM2m+LmQ0Ir9EMsc2C6jQHyOTbKvyrq84S+WmlXYeRtfrJzIeAdoSbTramTJky2h2RFiDOLtNs04m0HY6DPRQtmAKOSifA3B9V2p7vi65DaVMoRx1iWyt/8qlVOCBPKAQ2ocnZ9z1Of7v+d0z8DytY2TfGat5bO9FTCjnx2LV5OrVhYyvO+fOxK83zLiX9N3grtAQSwACuHlZ3/RNjoHI4iG6ezrUwyEt1R7FEuX/LXF4HStmCN6uKLwr9C0ByjlRzWXCxDG84dn2dF7hLBZYQ3ZOPn7G0RVHo3qtYsr89vmF8dpEv1MtCMIXdh8YzpGeu4zQnefKv9KRCmmESx+/qQAUIIztX8TgPRe6EUnqoVtXOwoeG+5keoY/ZFF1IEUeGBkCO/uZMMqtFn+4/UN7hVxuVjnHNwHs6OZP53UNhQI49Lq9eA7Q4Q/u1qHjD34Jho2k7k+a8uX9FqHKKZbc2ZcmL7epsDXZmblWIO66N8g8eXetMKTw2xPPZW0xzNfwLsvTAAM411rz0bWe0k2uCq2OZUAix0nU/CQt829zI9bNoYWVgcXztu4Di2xE1IaQxBz+15hOW8Z4Ilt6DRrtZatTR2biDJP2rMpIJanuD0P57Br6jiBYm+BZXsTcwnHryHfai3sm5eJViVfz58/MWxl+T084MooJorgk3Kt9OjVgt+mzir76503p3M512DmGB3GbSgFRE0jd/CT4LfumdEnjSsfNpK/xRGmhKgqI5SYnSjj2wmEL6L6rVvAuzM0LJxTaCKJfl4jIoXynqK4b5QtXJDJTI3/j7I/UK8q0vlOp++huZwvnW/Ayb4wgKaS+I6fl1WTLnvd4i2ccOOJgDU1PIQLs/Z/k1qgQDXZTHUcwtczIW2egrf
 sh8trKW/
 cd+GqXfHtQqkHhKcYscV6oBqqnLGmfceDikKZL+5nrw6KTLBi4KfNTkbFgHJlCp+swTeogVDB3rmvKoXv9orrL8azKWtvEFi/pgBqlcJetXMl0EBBSsQA13CxlJ83Aa2OzcxHg6KgRiu8U+q1YPBl8em6REmTevO5FJh6g6AgMHdQ5EtGO7OuLjAumHc2sehs7Rw9drBa1rSH14hiDxPsp6PG594TfgCyF60RgF2y8jjOT944Iqs5IH8aGwIy2Iao0JZOh2hNQka2kSgAt5e4sDDkHqx69HnTnist6Zj7o9tvNPbgooBf1HWSQQUHWZvcGh/N5QWOFBsmTqYN65x16/Vk3yYZB8C500CgSXE3iXdS/om4Ut4iJylRVI97QINIkM1PvdvkbT7wuCX8VJ9uzeqHXA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Patrick Roy <roypat@amazon.co.uk>

Use the new per-module export functionality to allow KVM (and only KVM)
access to set_direct_map_valid_noflush(). This allows guest_memfd to
remove its memory from the direct map, even if KVM is built as a module.

Direct map removal gives guest_memfd the same protection that
memfd_secret enjoys, such as hardening against Spectre-like attacks
through in-kernel gadgets.

Cc: linux-arm-kernel@lists.infradead.org
Cc: loongarch@lists.linux.dev
Cc: linux-riscv@lists.infradead.org
Cc: linux-s390@vger.kernel.org
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
---
 arch/arm64/mm/pageattr.c     | 1 +
 arch/loongarch/mm/pageattr.c | 1 +
 arch/riscv/mm/pageattr.c     | 1 +
 arch/s390/mm/pageattr.c      | 1 +
 arch/x86/mm/pat/set_memory.c | 1 +
 5 files changed, 5 insertions(+)

diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index 04d4a8f676db..4f3cddfab9b0 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -291,6 +291,7 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
 
 	return set_memory_valid(addr, nr, valid);
 }
+EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
 /*
diff --git a/arch/loongarch/mm/pageattr.c b/arch/loongarch/mm/pageattr.c
index f5e910b68229..458f5ae6a89b 100644
--- a/arch/loongarch/mm/pageattr.c
+++ b/arch/loongarch/mm/pageattr.c
@@ -236,3 +236,4 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
 
 	return __set_memory(addr, 1, set, clear);
 }
+EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");
diff --git a/arch/riscv/mm/pageattr.c b/arch/riscv/mm/pageattr.c
index 3f76db3d2769..6db31040cd66 100644
--- a/arch/riscv/mm/pageattr.c
+++ b/arch/riscv/mm/pageattr.c
@@ -400,6 +400,7 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
 
 	return __set_memory((unsigned long)page_address(page), nr, set, clear);
 }
+EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
 static int debug_pagealloc_set_page(pte_t *pte, unsigned long addr, void *data)
diff --git a/arch/s390/mm/pageattr.c b/arch/s390/mm/pageattr.c
index 348e759840e7..8ffd9ef09bc6 100644
--- a/arch/s390/mm/pageattr.c
+++ b/arch/s390/mm/pageattr.c
@@ -413,6 +413,7 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
 
 	return __set_memory((unsigned long)page_to_virt(page), nr, flags);
 }
+EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");
 
 bool kernel_page_present(struct page *page)
 {
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 8834c76f91c9..87e9c7d2dcdc 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -2661,6 +2661,7 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
 
 	return __set_pages_np(page, nr);
 }
+EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
 void __kernel_map_pages(struct page *page, int numpages, int enable)
-- 
2.51.0


