Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9BEECFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 03:34:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DE676B007B; Thu, 27 Nov 2025 22:34:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08FB36B0089; Thu, 27 Nov 2025 22:34:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC0C66B008A; Thu, 27 Nov 2025 22:34:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA7CD6B007B
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 22:34:51 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 75CF588D50
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:34:51 +0000 (UTC)
X-FDA: 84158599182.16.2FDBC1C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 774A840013
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:34:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OiMllP03;
	spf=pass (imf17.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764300889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r92fL9oKQlRTavP6tbfc36+c9pPVRtr0L8H+RYQ9Yos=;
	b=ONWl430HjLs/wQS5HvRZTnq+RJTRWxEt4BgRvVFugw+AKCuuFCfc2nJl5hyHZbYY3VosU+
	OYsYIJMEFe78701IwM72UD54yagzgtMr4pa6WJ0KRN2d9k5XRpC+HmeAshSH8XyB00Fqkz
	UUnzVbCBgpaTGGO/eiTf+NYLTIVKz9c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OiMllP03;
	spf=pass (imf17.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764300889; a=rsa-sha256;
	cv=none;
	b=rnSV1ZPnXEKtQs6EvuwzoRzxGdf6ecsCiMwGKF9x6TuweHN6IQ+9k+8FJmOgsvVOtQ/kjh
	U+s5X5RWvpRKdFWnEw/f+Cj/EmWub3m7UOT7o7hsvRKVajBkMBVl902wH2FdRurG2MCy7d
	0PvQcnSh2S+LtO7ciSKnixV7HW7xI6M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764300888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r92fL9oKQlRTavP6tbfc36+c9pPVRtr0L8H+RYQ9Yos=;
	b=OiMllP03jy9A801+I3n3Y23fgdXMO2oigZcg01Na5KwdqvqtmvHSb1geHOUXWZoVMk7qW9
	IN1bKC/cpmMAUWTnI1DtsMTfcjMbaye3dck4HZTFilE6bfSSi3NOd5PokQxv/sYulQRVDp
	/BRKPmOjrt2ribOKYZcpJd5xgaHBf4A=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-119-wgaq95i9OjubHDsKvyV9Bw-1; Thu,
 27 Nov 2025 22:34:45 -0500
X-MC-Unique: wgaq95i9OjubHDsKvyV9Bw-1
X-Mimecast-MFC-AGG-ID: wgaq95i9OjubHDsKvyV9Bw_1764300883
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EFFC8180009D;
	Fri, 28 Nov 2025 03:34:42 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.7])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 46F4D19560B0;
	Fri, 28 Nov 2025 03:34:34 +0000 (UTC)
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
	elver@google.com,
	sj@kernel.org,
	lorenzo.stoakes@oracle.com,
	snovitoll@gmail.com,
	christophe.leroy@csgroup.eu,
	Baoquan He <bhe@redhat.com>,
	linux-riscv@lists.infradead.org
Subject: [PATCH v4 08/12] arch/riscv: don't initialize kasan if it's disabled
Date: Fri, 28 Nov 2025 11:33:16 +0800
Message-ID: <20251128033320.1349620-9-bhe@redhat.com>
In-Reply-To: <20251128033320.1349620-1-bhe@redhat.com>
References: <20251128033320.1349620-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Queue-Id: 774A840013
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: b8zxaesogycgsgd38w7zypbwxfuwmzy5
X-HE-Tag: 1764300889-873037
X-HE-Meta: U2FsdGVkX19/nUT/gLAFXTn3flzwTHoS6ePhanJdHwP5CCvoGEHXvUk6mZ38cc4O2tQafzLPnD/eK3PxOA90q1wYXaYRFpAvqSXRUtF+si/KXtRukutEvW5s1FGWWKiNT+17+0n3KOnaa28hrkT/4H8J2hgcoTPtjaYtKxPLa5rSNU9nP+qRQF67yhiSQrmL9jcvFxHoHy9qWJOqRHY11qJ+U4hG8jnZ0Efci2qb507SjLDbDKU9LaCGANFLh6yr4/cLwwT3RlKVh01aQdnLFd0Lrg6GBw735p5Tt3X543t4tLsHNMWxBCJ1qbelGc/mbde+TAyWTx1VECpGDM/DCqFGJVml6RM3VAmHFaTqqj+9cpRwMDzMPngzqkmAkYiPPc2yyUX3M4VjLogX88OQ6+F5/efTY7wWuikE0DrEKIFU8sG9Rdc3N7M8lvNsTWvLI4K7ASh351392Gau5+PoO6QWxKQZcAr+0uUggadyQVKYXraRL1nbtqigOpzCI62NzRbcvoBUoFfSJXznmxTDamzzmZTGhkbjgpEQo2diMGStyfXpZ+Xquh/VdAeG/LN7zv4p4Yo1C2aQeyxithwgWwzyiD66CV44WftIlDCF5nLfl97x1L5vYbD6rPHOmQrfdutw4cFipjWam2l2RwuODH81KwERdQvj4ZrDHFnwIO/wh/ldRm4Ts1GkajizV7mkGQWeU5s4zrJfD/2q5XKqWhm8y35ID9pQtpHOcYpfrc8ecLdQr9UfCxPc1kSg9UKmp59wCjydZ0QuNIfzCGC0AixzJUiJy4Ub4M4HvnlmuObtLQRpU+n7igeyz7HHqXs95zNxxNXIvcOeqTdNjPWUE7RlV5EFlfkuBLDJdKn5Gfki/mNTuvbV57oXz4dpk40FRZ/NQiCKUzCMdYPNkqjehwn+/DtdlGiC4KBYl2IVvo1yP6sgU0TScGSA0pjnTjIFQFVxPeXL5uLdu6BMQjE
 4+h4Cb1X
 zFKXoqo0ikdCFODbz0RFw3YCQ2PILl6djY3MB8j7Z/meqM1Rsn47qSuVuf4qUu25gqbzcB/gZ5oFlvYdnneU1tCivt1mQaBdZgZQsYR80XUfGBDB3RGwY6W1QBQNPRuvlPunBYSaSYyAVDAaQMvWrfmhe6qQ/kscK4blxfEbiych7vzFJjjbN/mIXIR4OGslSYZrAAbdEvTu4Tto2CmYeRWRdNSTQVEO/z8IXOD1coUilhJr/KIlRDHSNEWUe1iLsHPrkFfaf2OEqnTSsCuoESOl4iuVqLqfq03Ww6a5yNFxx4iVshPvjlg7G6G3Cn8Oiv/ghz0TL2MogxubLyr7nJUR2FL6iFl/On3a46Of2U4iqHhAdU5M12e+9iHwl4KR/XgXBppkpNuZ49TZt9FOBC+pYLucFbY/CwZde5geuWvoUG4IZUvt2hQrGyJgbkLWGQ7xTXWqrGsqCmz4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: linux-riscv@lists.infradead.org
---
 arch/riscv/mm/kasan_init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/riscv/mm/kasan_init.c b/arch/riscv/mm/kasan_init.c
index c4a2a9e5586e..aa464466e482 100644
--- a/arch/riscv/mm/kasan_init.c
+++ b/arch/riscv/mm/kasan_init.c
@@ -485,6 +485,9 @@ void __init kasan_init(void)
 	phys_addr_t p_start, p_end;
 	u64 i;
 
+	if (kasan_arg_disabled)
+		return;
+
 	create_tmp_mapping();
 	csr_write(CSR_SATP, PFN_DOWN(__pa(tmp_pg_dir)) | satp_mode);
 
-- 
2.41.0


