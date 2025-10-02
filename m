Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B954CCA472
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 05:10:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 057928E0003; Thu,  2 Oct 2025 01:10:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02F228E0002; Thu,  2 Oct 2025 01:10:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E86B98E0003; Thu,  2 Oct 2025 01:10:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D64878E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 01:10:57 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 81B271199BC
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 05:10:57 +0000 (UTC)
X-FDA: 83951999754.22.9055599
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4A34914000B
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 05:10:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UQd73q1D;
	spf=pass (imf26.hostedemail.com: domain of syoshida@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=syoshida@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759381855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4JQvSrEFCsoxe5xRRs2Oi0PpRnlMQT2kkhwm1m9/XgY=;
	b=Y8JYmKJviHUe/d04FFClWbMWWZZvdRbn40BY6CD2EoUPKwFMNDJJBba00wocqgzDe6Rrvt
	TKc/Is/xVjX8X5S6ITpVWMMRaVTvWnsJNRhje5nGSHptoV5POgPPRxUGbSTUdQAF16sDL3
	RYI7G2Y5BgV49IvQNfO+H6thgF8WfvA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759381855; a=rsa-sha256;
	cv=none;
	b=CLUtLo6j6kFzlkeFGd7w0Kz2zkFfHcBfv7qcyRWuu9Cw2b2lZeislkT1E350kXZYXyAM2k
	TqKbrk8teVglpO+WN1fB/3SJh6YfzMJiAJh0rLxjWbXAQCtzEt0tdk2dD0Oe2QsfHnNdLa
	3sycamlMIxWdEfUeKF0ZFaxGXFtgmDw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UQd73q1D;
	spf=pass (imf26.hostedemail.com: domain of syoshida@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=syoshida@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759381854;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4JQvSrEFCsoxe5xRRs2Oi0PpRnlMQT2kkhwm1m9/XgY=;
	b=UQd73q1D3IZJROLubamnxZ0P9PkzGzKiAHDwGSXUtXcPyrgujqgI99vQNKNRWuIJ5TrHNS
	CZcel7SSvUeroy1KhsJ7sSy1MGKHBOiT1Xyn54XEtHxf4A7UXQMw27gCno2RVlfTAI4LVk
	CPnhdJOKk5ZfKgIl9tDvzq0/9HZMols=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-8FkvHvEoO0-SgHgPAGTXAw-1; Thu, 02 Oct 2025 01:10:53 -0400
X-MC-Unique: 8FkvHvEoO0-SgHgPAGTXAw-1
X-Mimecast-MFC-AGG-ID: 8FkvHvEoO0-SgHgPAGTXAw_1759381852
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-28e90fe10feso2938505ad.1
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 22:10:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759381852; x=1759986652;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4JQvSrEFCsoxe5xRRs2Oi0PpRnlMQT2kkhwm1m9/XgY=;
        b=iSVg3F31MtiMj2KSD9nyhyiipz2vxX/tjMIr9kM3CtxMN6sG0UkjCrD0ddAWaobuAN
         BstckU8+ZZoF74aRwHOUyFy3rON5M1VsWXKbNjLL9DEPdzBLXNK6RghiodPQ3qvtmHhr
         uEEtXVXB/mzfNGuNAcbR5c89tJ6Xes9HvvsaVQKm3Lgd7VKKpJm2VQAFAU3fY2TjDvhQ
         inrNOG+dtFXwdGmmYSWAa0FXhIoHACGi1lQAfQN9V68pQ/3ZnnG270bPQjIJq9nEMit+
         7XtN2SjeDXXpbnzMo0Nn8riU7F9op6FSjZdX58QPfjLb7WxmdKnICvCuB0qwk4TWwfAx
         Wl3g==
X-Forwarded-Encrypted: i=1; AJvYcCXAw+ZYbvDe3CI3junUfshrYhVhoMKVrfWgqvi9YcdTbdXsmieqq36TAp8a+Way/maKvTADZv4MJQ==@kvack.org
X-Gm-Message-State: AOJu0YygvmFFEYmwXIKqrmVdUmez9c3M2pMBWwIblojMOlvG5j46xXfL
	3MaKWwxKr9FROlMbPbYGJ1niyN0FAP3n/HLbxnzI9r14PtjWQiOdy7ID45ruUuok4gWxZ5+yDb4
	WftgAj8w9z7fxuBcfn++h/kyYQ8nEHv+/v0QiDR44rHziuQucJlbx
X-Gm-Gg: ASbGnct0KhxSuDpgp2PSLlowqsIeZWskLqMVg4KA0HXC0TMvmoaIQZ+HsAkhS3e7jl6
	cT1wBUzBXpIrwu9+bvaWqEbjhmrpNcMIkNemzFuPpVZVD5NQdIozbbHTSTeea5JO03n0ERT8WoC
	K9glY2XKMSdc2pC2oCLNJNi0/Ri2Vgxed/pAf6cdTw6Siff53zDvow7JY6EdQm+wOSA9w3us5Oi
	GEfQOsCv2WLSoDLAFo7SZY1Go05uiBkv48nzO9MAu01iElrkYd+4kQPdvidJYFdThUocHKHdsYX
	kA4itT69mqYqGqRFOWxk72xoTNNnM7Q0LvskUD9rubIrzgg=
X-Received: by 2002:a17:902:ea0f:b0:27e:f005:7d0f with SMTP id d9443c01a7336-28e7f32fa44mr76227955ad.44.1759381851857;
        Wed, 01 Oct 2025 22:10:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFdvHBv1w/DMsRepJmnrpr/Uz5Or//RIDtinprbRfs9s6Y2noLSrKbxSpBIfjIvctsC+934vg==
X-Received: by 2002:a17:902:ea0f:b0:27e:f005:7d0f with SMTP id d9443c01a7336-28e7f32fa44mr76227545ad.44.1759381851283;
        Wed, 01 Oct 2025 22:10:51 -0700 (PDT)
Received: from kernel-devel ([240d:1a:c0d:9f00:be24:11ff:fe35:71b3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-28e8d1e9de2sm12545715ad.121.2025.10.01.22.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 22:10:50 -0700 (PDT)
From: Shigeru Yoshida <syoshida@redhat.com>
To: glider@google.com,
	elver@google.com,
	dvyukov@google.com,
	akpm@linux-foundation.org,
	jgg@ziepe.ca,
	leon@kernel.org,
	m.szyprowski@samsung.com
Cc: kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Shigeru Yoshida <syoshida@redhat.com>
Subject: [PATCH] kmsan: fix kmsan_handle_dma() to avoid false positives
Date: Thu,  2 Oct 2025 14:10:24 +0900
Message-ID: <20251002051024.3096061-1-syoshida@redhat.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lNkwARiFKZ9VpM7V8OlvS42oFmIRhzp2i9pomhGkrtc_1759381852
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: d7mwbsg7f6yta1qb1ded9x1o3j6w9sj6
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A34914000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1759381855-734806
X-HE-Meta: U2FsdGVkX1+JfEe4KJUvuy6k1QtZC6e+hdjdIrGf+9wb/qU1ten4f8NxmumtoA2SRoaVvP07W4xxXsO8bUclngXmGeBPaiuU8SftaEeSOejUUxjsDRDJQR304PeqFWSenJ8lxME4yD+cAb9OEFIVMTLJL+JR6LbX3XbqlwfUYrULLLvHqpMIRDVjhhQU+bMZuuW2sJOWiKv7LEo65rKWnO/nDRKECg/wV5n/c6V4HceKxcX/+76MR7XNh5mxtz4/vI1hxteybOS+3rfqT++qE4GVaix8KHcbYwqhN6mX5lHT2+kdYw/NWdNiKl9U2KAkJz2HRocbfLdhw8uDvGzy+hjvu56sCErJqxasFevpOKIQQiirMM1kVhuQZbFlmz0hlAJsqcqihDcGtO5Z7nj6svKYVJykgtxpjftSbGvHXiOJGnUojenGUrn4C2YcsisMIj4KojxF3b3+kPcZi9O91Ak6tQJOG0EhayF/yKdgg/9ev7oQ/7udcOvQhya5t8LWvfYhgBsE7NN2fiNSds1D9Ia+ICExsf1KSMgNgVHC5BZIZRIRUCMr7Dx2wn4HdkZ2uPee3DIalWC8R1u0aFi2WiGCq4fcqtOkKlua/VUwavlpe3j1YsfxioIy75PNTQiYpAliVPIFpwcFeha6NYhqsNVt0M0qaBpU0QExw3Y4HafE/UQ9OjEcZX2W6Z27yPxpzWyAQiQD5/ytf156rU6XLp5RO2/cp+nC25h9bqcsEJzwYmM5qLZZgZBlLMSnMW1ah3o4AepVRGd5ah+K1sxujBpMsDZwwgaK1wVxcMW+D2/pk6wrhJ5YFB2Bi+CrOF4SFAFCJOfw/dxwPyEM8esNgs5QNPcTlJTzs5d2PqJ5XCClWEi5SfFZe+EdO/1/k2lSWTsAMnq++m496MIks8yNtLi+Ar32IX36OOY3X1kYX4mpz8XYc36zo+28dC1M/WoNoR4RA31uArrNhEPkOoQ
 WNP2U/rI
 8kl5TNt74HvfJXitht5RccxL0FttVREIpgmsjJCWtTpb/f2tb59FfPzMPr7ej6jP2MrhOOEoAQtzO0JLFDyAfDrrKz1KrcbDmlmLNsWoso8g5/y6BZMcIVHwFzyNZ4QWeCYFrPJY81lc3U5r4uI2APKqZD8VoYrOgt+0ldMXYOrq1lpBBjb0EdayihuLvEhvRcdw6vTkNAzBNGt+Tpu11Fd6rbyvciQDabZWDXqoG++9vP2dGs79X7oOBw1mKwEUk6qwJ34zMaXb+C79qr6Ewj1s4y1TGoaayk9+cfHJo9F0q1gn5hKfoCyzRMDfY0A16xJ6itUPhuzcnE6hkMtgsOF4lAD5fb8Tc7VX6L5j2YtJrt5J3OKxbXREeeHpmMJvq26jaFjeF3bvLFQ+Ytokh4gKdxuXBdCDtSRbjs0NXRaHooos=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KMSAN reports an uninitialized value issue in dma_map_phys()[1].  This
is a false positive caused by the way the virtual address is handled
in kmsan_handle_dma().  Fix it by translating the physical address to
a virtual address using phys_to_virt().

[1]
BUG: KMSAN: uninit-value in dma_map_phys+0xdc5/0x1060
 dma_map_phys+0xdc5/0x1060
 dma_map_page_attrs+0xcf/0x130
 e1000_xmit_frame+0x3c51/0x78f0
 dev_hard_start_xmit+0x22f/0xa30
 sch_direct_xmit+0x3b2/0xcf0
 __dev_queue_xmit+0x3588/0x5e60
 neigh_resolve_output+0x9c5/0xaf0
 ip6_finish_output2+0x24e0/0x2d30
 ip6_finish_output+0x903/0x10d0
 ip6_output+0x331/0x600
 mld_sendpack+0xb4a/0x1770
 mld_ifc_work+0x1328/0x19b0
 process_scheduled_works+0xb91/0x1d80
 worker_thread+0xedf/0x1590
 kthread+0xd5c/0xf00
 ret_from_fork+0x1f5/0x4c0
 ret_from_fork_asm+0x1a/0x30

Uninit was created at:
 __kmalloc_cache_noprof+0x8f5/0x16b0
 syslog_print+0x9a/0xef0
 do_syslog+0x849/0xfe0
 __x64_sys_syslog+0x97/0x100
 x64_sys_call+0x3cf8/0x3e30
 do_syscall_64+0xd9/0xfa0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Bytes 0-89 of 90 are uninitialized
Memory access of size 90 starts at ffff8880367ed000

CPU: 1 UID: 0 PID: 1552 Comm: kworker/1:2 Not tainted 6.17.0-next-20250929 #26 PREEMPT(none)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-5.fc42 04/01/2014
Workqueue: mld mld_ifc_work

Fixes: 6eb1e769b2c1 ("kmsan: convert kmsan_handle_dma to use physical addresses")
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
---
The hash in the "Fixes" tag comes from the linux-next tree
(next-20250929), as it has not yet been included in the mainline tree.
---
 mm/kmsan/hooks.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
index 90bee565b9bc..2cee59d89c80 100644
--- a/mm/kmsan/hooks.c
+++ b/mm/kmsan/hooks.c
@@ -339,13 +339,12 @@ static void kmsan_handle_dma_page(const void *addr, size_t size,
 void kmsan_handle_dma(phys_addr_t phys, size_t size,
 		      enum dma_data_direction dir)
 {
-	struct page *page = phys_to_page(phys);
 	u64 page_offset, to_go;
 	void *addr;
 
 	if (PhysHighMem(phys))
 		return;
-	addr = page_to_virt(page);
+	addr = phys_to_virt(phys);
 	/*
 	 * The kernel may occasionally give us adjacent DMA pages not belonging
 	 * to the same allocation. Process them separately to avoid triggering
-- 
2.51.0


