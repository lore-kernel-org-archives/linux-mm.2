Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C207CA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 05:36:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E5526B007B; Wed, 20 Aug 2025 01:36:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 196886B0089; Wed, 20 Aug 2025 01:36:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AC5D6B008A; Wed, 20 Aug 2025 01:36:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EDE0B6B007B
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:36:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9819816033A
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:36:17 +0000 (UTC)
X-FDA: 83796025194.02.C8110D5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id C9F934000D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:36:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="N9/RCAk+";
	spf=pass (imf17.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755668175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HIvq87a0AAq2d23Q/rNsSw9xnqrtCb4IHcYwpyhrt5Y=;
	b=zVppWme59H1DagvXA+aYx/azQJnLv/Of+EyAjafcfRvPbnhlSLgHDOgWQ/USEoWXZAn/Pm
	BMY0Bsuv685vAXZl5gQMpc0ERZDlKoXK8QdHA3m0dpyEi2TLOLbNAl/TSXoV1Dd8KOrRhO
	Bb4UYQsZIzAevSEdlP8jnc8cFkSjDwM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="N9/RCAk+";
	spf=pass (imf17.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755668175; a=rsa-sha256;
	cv=none;
	b=D/exyZInIhL9VaouW3aGHtloZwTfU3wyPvPVlscVEsaum/arjsa0PYbBa2i8WbP7h5rVg9
	JzAWhu5ELH6eLL7zmtaMmnQVzQQ7/Pmlk8acCMcIAlTKE4EWjjjfKx/w1QzAy6yzaotunP
	ZIInnAuiGXFVnLzEB6DYdpnZZ27bgRM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755668175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HIvq87a0AAq2d23Q/rNsSw9xnqrtCb4IHcYwpyhrt5Y=;
	b=N9/RCAk+81Pg9Ni1O+xoqWU6FAiZ6Xj5ksNq5TKbnDeMyLp7WcYeyV1JltsUrs27o3dRCw
	QDoBkIdfWrRpLbKviVndppGFDnQSYXc91THZi+LsLRj4FCp4lChYMYbmC7PhXxYKmM7m6z
	br2DcGN66LB0lIrBJUBTR/SC8BCANnc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-661-P3sGgTDEOVKL3Cw8VTzXMw-1; Wed,
 20 Aug 2025 01:36:09 -0400
X-MC-Unique: P3sGgTDEOVKL3Cw8VTzXMw-1
X-Mimecast-MFC-AGG-ID: P3sGgTDEOVKL3Cw8VTzXMw_1755668167
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5E17F195605A;
	Wed, 20 Aug 2025 05:36:07 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.99])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 661C219560B0;
	Wed, 20 Aug 2025 05:35:58 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: ryabinin.a.a@gmail.com,
	andreyknvl@gmail.com,
	glider@google.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	akpm@linux-foundation.org,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	sj@kernel.org,
	lorenzo.stoakes@oracle.com,
	elver@google.com,
	snovitoll@gmail.com,
	christophe.leroy@csgroup.eu,
	Baoquan He <bhe@redhat.com>,
	loongarch@lists.linux.dev
Subject: [PATCH v3 06/12] arch/loongarch: don't initialize kasan if it's disabled
Date: Wed, 20 Aug 2025 13:34:53 +0800
Message-ID: <20250820053459.164825-7-bhe@redhat.com>
In-Reply-To: <20250820053459.164825-1-bhe@redhat.com>
References: <20250820053459.164825-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Queue-Id: C9F934000D
X-Rspam-User: 
X-Stat-Signature: 7rgajpk8bif8o4hrs1j5hmoobqp6mugt
X-Rspamd-Server: rspam09
X-HE-Tag: 1755668175-89648
X-HE-Meta: U2FsdGVkX19dVTMdXEp7R7z6ceP4Kb/ZuEv2cTES62co51w0U/DSdBXG1r2x3xSwlMlimuGgzEBulanXknkMyAqjqTBE/HksktxdLrK1QGrMvdrQCadSqAcSXwvTTmignXpL8biavtweGG+Zap9qe3UcWT9TXGK+9X9mHK843NRgprHljLN7JWRt15GXb80+cDjFkHupP/m8QbN71kyy0Pm3PNx0thmYxt8suHn4efRwlQBrzDEiiyemf38SPEDY8NETYDWjQ/e08OClfxxSP0U319Nvssrh2ZdsjFYR2KabN0fJ6n/j7khbBd1EFbFsG5h0kVmT82hS2iC6JOpX/hZS6PRU0dVLKQHyxjcHbzmCjRNIsZqsR+GOnjaLu17L2HVZ3qndxrcPsTjRqaUQJBrZYV24PsRKXUFrAHU/V9JeCiqnWRW3MMmpKDcqAyH80D2HbbHnPDB5WqCt7v3965RRfXUI6yO5xIm6HY8CnzPA5dDyii7+IyHcQwM0UDiMMxPAeDA52iCCmqnf9g+HNr2PtPhiqsLwRkAx3MrZydi798BjYB8e1JXHrnHXBxcCS139yImpDgsrw5d2xgLGPc2FAFFXji8rzn+yx8JpX+Ugh8Yyn49c4ED+8qa+UhABFxODss5I6gDAzvOKHhZ8jid05F159phtiRvK3891xEQIb5udb3NhqtSeu7LPm2snCkl4qwt713nNH5hkPOFv+qBSyKh8XQ4STAyD2CBbgDKeMdd623kiZEof/RwckluS3r+qz+VXgY8pyK35j2sotjlCZlYFO4UnGURf70zzG4QESlnb9sFcyOqm9l2Bmi+ot2S1cvgub2kYS6uBk3jiv9s4F49iP1V3yv6A9Mnlf/r8SuoDCqhzlxxKdK29hnmwe/s15dQFFmmEpH8LSMA1IIdEfTOnfzxCVq7N+Lh6zZva5k5lKtPNa/DNdic4sM2QXrfRgaI0Hmiu4nZBsSc
 VEVU5fAw
 QRfzAvgxy7sYWXyp4EWGPIjoDIf/2jXbkkcFijd5YRu0uBwpI0NYSsUvf26LiO83DUbsBsuNCWtKRB9iBCHPeHY3WeEChK0lnPeMUSvutsl1Yu+taagTTpoylEjEWIJ/j5SJ/KpoB+Fs1VeBsxIcvP7A0i9nBNebPWr/ELYifeQQnhrbR8EnIVJl8ZXBPyuh4jpLMO+zhW3qySw4kHCWsYyudgbntyBB34aXibGCqjls8gNuR+8MBnpIElacGXe3Ik12vikK1Yss4IeQGFLkabzHDmFXZiYDAHbhbV2hPlsCOmrgg0wrnS7a5rQUeAZ8mLcPu9miOp//XLt7UbkUStVpM7FA8gtqr1nq1Kkj214kM9Q9VeDeDpgyMZkfrFNzBH46dNu24+oqhzeqQwJLDP3wm5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

And also add code to enable kasan_flag_enabled, this is for later
usage.

Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: loongarch@lists.linux.dev
---
 arch/loongarch/mm/kasan_init.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/loongarch/mm/kasan_init.c b/arch/loongarch/mm/kasan_init.c
index d2681272d8f0..0c32eee6910f 100644
--- a/arch/loongarch/mm/kasan_init.c
+++ b/arch/loongarch/mm/kasan_init.c
@@ -267,6 +267,8 @@ void __init kasan_init(void)
 	u64 i;
 	phys_addr_t pa_start, pa_end;
 
+	if (kasan_arg_disabled)
+		return;
 	/*
 	 * If PGDIR_SIZE is too large for cpu_vabits, KASAN_SHADOW_END will
 	 * overflow UINTPTR_MAX and then looks like a user space address.
@@ -327,6 +329,9 @@ void __init kasan_init(void)
 	csr_write64(__pa_symbol(swapper_pg_dir), LOONGARCH_CSR_PGDH);
 	local_flush_tlb_all();
 
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	/* At this point kasan is fully initialized. Enable error messages */
 	init_task.kasan_depth = 0;
 	pr_info("KernelAddressSanitizer initialized.\n");
-- 
2.41.0


