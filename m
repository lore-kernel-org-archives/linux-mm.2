Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 183FDEFD209
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 08:16:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 775026B00D9; Wed, 25 Feb 2026 03:16:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75DB86B00DB; Wed, 25 Feb 2026 03:16:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65F506B00DC; Wed, 25 Feb 2026 03:16:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 522346B00D9
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:16:29 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1B7F71B6ECA
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:16:29 +0000 (UTC)
X-FDA: 84482272098.02.1ABF3D3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3F5181A0006
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:16:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UQblmx7o;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772007387; a=rsa-sha256;
	cv=none;
	b=5i/FFLY7oGL4gC4yFkgyDOxhsylBx0zMOsbluQLmp3/dWe9XBe/nher249IjfGQuBBJ59U
	P0VYdGHBan7cwRUgR8zKnwBwlmO93T9LhULvjkuUvYc/+mGifE+Wp4fq/fy2ux23zgerxw
	oJummdo1Rwg1RhMwf33VkAKnCMRlggg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UQblmx7o;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772007387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dmXeuzqCGEXbsFr6BMS6DZRu4kl8OFDlvdktSaTFzJk=;
	b=EuqgWqf/UVa1Jixb7UD7McqHut2IF4mSJaWTxr9mb/1k8uBXce6dyo97KF9oOo2V4S7630
	479xlPZFsXFUgCw3JjqoQftJM3jYI1K8MZSQou6YEc6NIJkEwx7qgLZFV59FvZ8meaaKtO
	c54o7dp+i6H+BXMT5NoLdTH7IZ5bXzs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772007386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dmXeuzqCGEXbsFr6BMS6DZRu4kl8OFDlvdktSaTFzJk=;
	b=UQblmx7oRS9e3+OhisC6B8dvjTVGB4VnN0sS0MTDDUfrKxMNbSJWnEidxqyqaL5yBfeLhU
	HxX17kF/ASY/CKEzL4hr1Emg9U0+OrhrQxMwkHNAV8Khuv2JxkKqtNHXs4qsGdNh0fuFJd
	pDZMrgdgCDDXJYVJ5Bg7arb08pSCgvA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-74-YXdFjCA1Mnetuo5LYiwicw-1; Wed,
 25 Feb 2026 03:16:22 -0500
X-MC-Unique: YXdFjCA1Mnetuo5LYiwicw-1
X-Mimecast-MFC-AGG-ID: YXdFjCA1Mnetuo5LYiwicw_1772007380
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7F2CF1800282;
	Wed, 25 Feb 2026 08:16:20 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.55])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 37D111800465;
	Wed, 25 Feb 2026 08:16:09 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: kasan-dev@googlegroups.com
Cc: linux-mm@kvack.org,
	andreyknvl@gmail.com,
	ryabinin.a.a@gmail.com,
	glider@google.com,
	dvyukov@google.com,
	linux-kernel@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	linux-s390@vger.kernel.org,
	hca@linux.ibm.com,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH v5 10/15] arch/riscv: don't initialize kasan if it's disabled
Date: Wed, 25 Feb 2026 16:14:07 +0800
Message-ID: <20260225081412.76502-11-bhe@redhat.com>
In-Reply-To: <20260225081412.76502-1-bhe@redhat.com>
References: <20260225081412.76502-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: ycbrXSvZyQPDejR5BPyy6ancFbtLWqAhUyURz6kK6tU_1772007380
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gnrfdz1tdwgnemo8osii7uomgnanmb53
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3F5181A0006
X-HE-Tag: 1772007387-186375
X-HE-Meta: U2FsdGVkX1950Mky46ijOJfcUDmYTCSUG5oz93u31AJMxXNJ6MAfAdd/qJ4xR5W3hvG4U9xGc6VPPfE/tzqoAgelQ+3M6/Y+StOdzGMBcfxdka+sqz+HZMoNVKIpQiLUgtWV1ofmSmSBZlTgGx7oVxySk4pOBcY1O3LXp6jGO2Yb0ytOmPD3qUMarrJpwOsJOfFdvdEejLp0N/+yA16Y/x/OGntEUCFVxgnrA87OskVdjEjcIUi5SPHygNKsD207BInkGwRK0Cek6Iaeh3WD730V18lwYogKdFyTQ74nFYxc7Fo7OYzrbjYvXAHZZp2WBMIo1ohWVh2m1AdQfOuyyKssE17BFMAcxrO30R3DKbO7P8Lm4wiK7AwfCiRtlbon5kLdGSA8ig/5SGkQ/Pl0WkUSWSpoKMZZUeXcUmxnD6AlljjAeHQ9OGUepIa/LdGGUVUHi9fPgrHa6B0ieaoFzszFNADRi5MXc/Zx6G7GpSfovIergJ1tcRS0OtIpLwpDPKQFrXfkaAiQobDT32hA1Sju63PdY3XW0lAWyRlw7UH8Kcn5nE8CX9Lu/oyrAGPeegc+DDX7Fb1ePytJu1ZCVreGg/sOLeO1ZLMHwuSbaXlEDgukp/NQdtfck0EClSWWLUWsvplH4nGKyA+wwQzmp5ekC601XI8ozxs3NcJA2ACoJSzFdaxTYYepE/GwP5uU3a+FB6mJlwPqytsOsY9Vg+Z1ATcZryv4VpLI9+9FFipJSgkZLffup/1qmZKTWMk9HFNzt//uYiChwoGCJuNP3LwrafY8kkH8xdhUaU4Jf8TUWEU0Bn9dT30230YebkY1nFoBfLASObW302cex9Ad8XCDG/tY0TIhQiCwxGdNoINPdFtLAgRrJIabDTz34f9Lz1g9VqBGKlvuaMZLcjLa5xFQT/3LQVMAux3xH+jadnT+MXX7fA4s7XcOMTuyOksdYVuIaSg8+uhb8X9HsC8
 2iy68btO
 pWl116bjmI5u7sdN8GD0ckcuPKac1jrEGOjGhTKNlZAMunhMXbxkqY449VlpgWKgu85FZs3SyDsamfaXAPPwB7+S+tvClEvmLxHbTL/Fnf6/jlUdX25tnd8ni3kQT/q9wrC1TQ7tt85d80atNFWlLjHonKpoZHmTNLkJA/JllADkq9AItQOJtuAfWchIgmA++P5DCMDXzBGvkycNNUM6bbNv12UXNHpVD0MXcC6JHIOS08d+7jvgGFwutufQoD4pAo5xIf2j7JpRADQgC5G5Oy1LCrWp9FQUDuPQilqkBO1n6ti8RNOdVvx3WrlnBnOBUiZZIkwaOsfIy+7VCDojy/0gkdABGL0V6xy+EDa5+B3C+Bftwjp9G6vJiALf1ieoJM3XcL4xCZgWM3mExoihlkOAMT/knI0AuqB2fvex64nr8kUqGvtYfDNptL0MtNJMoH7t1zblM+9VEROI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Here, kasan is disabled if specified 'kasan=off' in kernel cmdline.

Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: linux-riscv@lists.infradead.org
---
 arch/riscv/mm/kasan_init.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/riscv/mm/kasan_init.c b/arch/riscv/mm/kasan_init.c
index c4a2a9e5586e..dc7cc0dcc7eb 100644
--- a/arch/riscv/mm/kasan_init.c
+++ b/arch/riscv/mm/kasan_init.c
@@ -485,6 +485,10 @@ void __init kasan_init(void)
 	phys_addr_t p_start, p_end;
 	u64 i;
 
+	/* If KASAN is disabled via command line, don't initialize it. */
+	if (kasan_arg_disabled)
+		return;
+
 	create_tmp_mapping();
 	csr_write(CSR_SATP, PFN_DOWN(__pa(tmp_pg_dir)) | satp_mode);
 
-- 
2.52.0


