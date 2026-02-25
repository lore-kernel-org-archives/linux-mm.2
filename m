Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E471EEFD202
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 08:16:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F6626B00D4; Wed, 25 Feb 2026 03:16:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AA6A6B00D5; Wed, 25 Feb 2026 03:16:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D6FD6B00D6; Wed, 25 Feb 2026 03:16:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2A8556B00D4
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:16:00 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 653CB1401F7
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:15:59 +0000 (UTC)
X-FDA: 84482270838.26.8E6463E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7DAC1C0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:15:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cnrbxVUs;
	spf=pass (imf28.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772007357; a=rsa-sha256;
	cv=none;
	b=i+rDSGLeCJi9Wmh6qpuIm0u5MwKSipXTqmNZi62P50k5WqzTHqsI8NucT4OxAxU9zoeSm7
	g/B8ZLMxsRXD8NOwy2Gu3zrrHHM7GoHvJoabsMyrHGwYiCHauhB/5sVf+O0BSG0ZNDjrJH
	HRRTN2ex5sKR9kGn7Z58mlN9Eg8mFKU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cnrbxVUs;
	spf=pass (imf28.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772007357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qbXEkZK+UBZ3F7j2MH1sXu6emUlCr8xCSA0nHJ3EKL0=;
	b=zeoQiwnV1Wv9RJnhKvgN9D5IBMcAOmf+fG9OqZ9uTxvdVJsTMVFUAx7ul872w78iT0XFYY
	Kd+RtV1drQk06aorxeGmuZxYCruG33KdY7nAp8+O07z/wGe6nSXjswdOxZXtEJ5EXkQmgc
	sVxveigaHMrv3Xe253pZJE++V/TsubE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772007356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qbXEkZK+UBZ3F7j2MH1sXu6emUlCr8xCSA0nHJ3EKL0=;
	b=cnrbxVUszwCaslcZTfRHbNLrp5g5eETyj6MNYCYlVR1Dq4IC1CK3orCwRn/9t2GrZ9zZS5
	cnm+IFpOzjovYbnxrmxGI39B4VwA3mlMRGvnhvg+NHedg2s4ajwUvS2qOaay4G6/k1It6R
	gp00/4DCC+TREmImCJ7AFCMKrEiBXoA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-304-4chxBKYfMym28iynbNI3jg-1; Wed,
 25 Feb 2026 03:15:50 -0500
X-MC-Unique: 4chxBKYfMym28iynbNI3jg-1
X-Mimecast-MFC-AGG-ID: 4chxBKYfMym28iynbNI3jg_1772007348
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0CB5F195609F;
	Wed, 25 Feb 2026 08:15:48 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.55])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C1E3A1800286;
	Wed, 25 Feb 2026 08:15:38 +0000 (UTC)
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
Subject: [PATCH v5 07/15] arch/arm64: don't initialize kasan if it's disabled
Date: Wed, 25 Feb 2026 16:14:04 +0800
Message-ID: <20260225081412.76502-8-bhe@redhat.com>
In-Reply-To: <20260225081412.76502-1-bhe@redhat.com>
References: <20260225081412.76502-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: RNfWFmKPaOp7fLdSXxdCe9rDMWLF-oLVZR35WM39Zbc_1772007348
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7DAC1C0005
X-Stat-Signature: hqghrdhqoxej79twb8rfqxc1qjx55yo6
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772007357-512224
X-HE-Meta: U2FsdGVkX1+yRwj8y71wNX8ad0v7YKiojR2Q2El1r1yFjazN3BIfZpfiqGTK7lBcFPz6T1r1xJqxOyfrXbN8WSoZiq+pj6mPg8hk55PPx3cbBKUe1dQG4P0bgSPWF4UvPom+6dfn1KNvEuNAG04bUhkCnL3GPl6HwCHqwewZCw8D/ODkOB5WLnjyIWjLxh+xgnjun9fB4OPzBbA0QpPmKdq1/pr0AxdN4lwuzRzUCyC+vBmxS5nnGsg3NCLiW36aUs8c2VNAiSa+bJ7KFuWTRTjVvC8pl1CWY0Jma//isul+/dU8n29tTaJCjqxddGT26+SyKni3xedsL65o5ph2oWMvOrsoLZk+iZ3fDsPHcR2PqFACdhzU3YMITFS+SrKCA2IzMmwoKYpp5wlblUW+yFp5Hi3eZR/l0kSNVJsFfXN9BOWiGZPfchDprcSKhgARvzwNGPyQrPpSVBpTVEnBKR7x+7Kz651karEXTHUS76CGA+2q83yPKUGEvttIMlYE6l5v5rTFnEHb9XYo0sc2oIUgAwT6Gy/KhRy1UahJZiQyEi4A00XO1xewh/oeYo1Td95+4S7Q5gUmjTKTQBoS9WUYIlQlsOX4fCmfyHnY/FQPqnk3BZwvFUpBnb0k8hAvCIzV16tM6hMLihONC4mocchqNiY/d1v3/AdGwO4mpeA1sje243sujmORZIszEgufO+aVnWRHp06GPZ+oqF5ft6dQKl0FOrRP1pys93RM+EE7CU9tUDXmlrHMFYpMrxPaecd/FCe9M9WHB+Ijdgp3mJ1cbbiiPXFId9gXu5YySRx7YceCuAAPCDyuNl5URCVbrdLf7jNPpyv5ThPQaE3euiFLFk2pfdfzwf4g6AZd8cU7A/LrOLi2ncQFnwuVOWcE4TQ2Pj+XoiZDkE6nlcJpwiNSYBVhOVwMzVFx+A4B+mnQh2RpTG2q+yqanHoflfoQM3BLKxTDZoMPQL8Lq2s
 l5H+Ox/3
 Ct7oL6INrxvGwOGzx2wuFOhLDzvnDGsya+3ufA/16WToJ94oqfayVTD1g7gLJUJfrBnJMpfKWsGX9cU758Cs5VcQnmnAHbLg3sXaBjUviCyYHrB6kmnRuqWChpdcxwCsxTjn2WZmfYnY2cwxPau3QzgHTAvGpmq4QiSwJVFYCeMvSSC7kIhiAxs9Nmf1bxm7emiz/Vn4ahEPMBUVSsSj0TRtRFnP5yFKtG5fVvtVKMl2XPxWqJcfCzpA3F1grwcCZGP5C63Dt8DFYZWu/OxWVLoCTMexlhKBp337CM3DFX+dAzg0OJKRBwlzAA7wRVqjrzpV5hKGsd6VRQFRzg6fMW/IcXUXSp5svO3bRDwP6plL3bZp10R4AumoOvXQ5EzFnQsrcyPtql6BOttzrx7nlFWDkzh5GJihxufkPweOd33p5mzDxWbZc19sGH+t2Mlx9DCK6eJGcd/tF1TY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Here, kasan is disabled if specified 'kasan=off' in kernel cmdline.

And also need skip kasan_populate_early_vm_area_shadow() if kasan
is disabled.

Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm64/mm/kasan_init.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
index abeb81bf6ebd..4a58e609c81b 100644
--- a/arch/arm64/mm/kasan_init.c
+++ b/arch/arm64/mm/kasan_init.c
@@ -384,6 +384,9 @@ void __init kasan_populate_early_vm_area_shadow(void *start, unsigned long size)
 {
 	unsigned long shadow_start, shadow_end;
 
+	if (!kasan_enabled())
+		return;
+
 	if (!is_vmalloc_or_module_addr(start))
 		return;
 
@@ -397,6 +400,10 @@ void __init kasan_populate_early_vm_area_shadow(void *start, unsigned long size)
 
 void __init kasan_init(void)
 {
+	/* If KASAN is disabled via command line, don't initialize it. */
+	if (kasan_arg_disabled)
+		return;
+
 	kasan_init_shadow();
 	kasan_init_depth();
 	kasan_init_generic();
-- 
2.52.0


