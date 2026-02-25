Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCC1EEFD208
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 08:17:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BB536B00E1; Wed, 25 Feb 2026 03:17:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A68F6B00E3; Wed, 25 Feb 2026 03:17:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A5F06B00E4; Wed, 25 Feb 2026 03:17:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 278466B00E1
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:17:13 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C93C01B5CF7
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:17:12 +0000 (UTC)
X-FDA: 84482273904.21.E23F3D3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id ED66820005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:17:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UyA4w6Sf;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772007431; a=rsa-sha256;
	cv=none;
	b=N2mK+uOtEErUlDYYjTpTY3QjbPZ/hIok9S6Qj4NG5JGuB82G65HQeyKfymWF7EoanUGZ6e
	URKlLISqD7teGoUqZPR3U44YVXjMMzwJTH6IeWbQszB145AbTLFqElaj94qZLNhcm8S0Tf
	nFaZ0lpDcJEzXHsNObjyBbYSCQXCObw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UyA4w6Sf;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772007431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oT83zYbQb0MMseAk5Xm5Eaz7XNiK7MPHbcs4LQizA5Y=;
	b=2YZQIb/E4ZpBhewr/sH69Qo1VljvyDGsVB4f1Dn2U4OJjCdm3ZJZzxx72pGRd6WsTJ5lm5
	D8xT0IvpZ2Ur0Pa/F8BmJ+44gvxgXLDUohHNODIvi1yVyxeVdSTdwY0jedMnF6UfSz6y9y
	qKU7ayB/148R5X8eRHfobax3u6NhJUM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772007430;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oT83zYbQb0MMseAk5Xm5Eaz7XNiK7MPHbcs4LQizA5Y=;
	b=UyA4w6SfPvwS7Xv996Sx9ieBzAb5I2kIksU4Z9AlfjcT3X+bC1x4KECxwpTNhcbe2tE2XT
	lFHtUFdGsCaFC8Y6ZuHcStK1GABgNLGeNUhyixH5AEUv7wtfIRFrhEPP54w0cOkU48lv0Y
	n6DW6QDNGVzvbjwpVLUCgtqucoSGfcw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-68--PGROTGBN1uM5wyFliyqng-1; Wed,
 25 Feb 2026 03:17:06 -0500
X-MC-Unique: -PGROTGBN1uM5wyFliyqng-1
X-Mimecast-MFC-AGG-ID: -PGROTGBN1uM5wyFliyqng_1772007423
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AA092195609D;
	Wed, 25 Feb 2026 08:17:03 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.55])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2EF4E1800465;
	Wed, 25 Feb 2026 08:16:52 +0000 (UTC)
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
Subject: [PATCH v5 14/15] mm/kasan: add document into kernel-parameters.txt
Date: Wed, 25 Feb 2026 16:14:11 +0800
Message-ID: <20260225081412.76502-15-bhe@redhat.com>
In-Reply-To: <20260225081412.76502-1-bhe@redhat.com>
References: <20260225081412.76502-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 95dIczq0JzJpi40Rv-dzos7GTy3O1yMgQfUQ3TSWSsA_1772007423
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: ED66820005
X-Stat-Signature: 65mx14iujdz315ndbow37rk6xnkq16fu
X-HE-Tag: 1772007430-263284
X-HE-Meta: U2FsdGVkX1/7pBGSlFcIygLrB4J+1/ZVmQBGn1mgjUVQCHJkybBJobkyUNn8sdDA7ESovMO4Df4lf2RbqRp987cg1wYXXI/+YpixmJJJAUeL/XP++hCY1nuAh5nuQx6n/SZ/SkkGHBnQ2S8jE4ZReRg0Ui3HIJfXtHzkD2QHon61E6O08CCblFHiMRG+CZT75NCNMxLPvmdMvceRxHzDQo5isdJk+ujTfDu4ZP/XkISPAlWVWOkL5yVNxfX30oZs6P8vUgz1wx9w8D3Uea0SbHohuGMIWNY9Ovu8ysXTB3geaZbZOUWh469FhFgmlRbQgUOkekAc/6ccQIhUPMmomKIcEGU0mPIZHRI8cyj8NRbjGyRqURMYiBdaEI0sSLw26DW62BwiGo1ezQpCZ+wJUyjuP8JOlJd+YB1AC3AdgaPUbXnq96661i4SImAfR+yvma5J1I+8NKTJl73Ubpz9JnkfkOFM2IkG9DvuJZy1NrB+TZ9oIp5ZalD0HAAWXBI1ukGV+JwP4+leHrJVWbksHSfjowDvUy9ppXefbXLYH4IkcX0q66g5wnjJGwPnokZ3TtYg8z2rCwdx9xlksTIlVoW0GSvmNRi2mEKegzAdUc/p5/gD/tZWhKxHqdLbeOLCRTH9Y9JJObVfa0JM4BGT+q6BT8DbSld3cIzfVVWr1H0h7WKFDUZRpf8iBTq3CCr4jLKksuhDP9mfPTS0mGO8BpU/Ia72ZbisbVCepbHFMYG3FKfWSbC0C7IOalj+A4FedG0/OgQjhZ+V9ucYkVe2ZFcDybynBun1Ptzojo2zEmSIynFTV02qfU9S16BXLUPFdziGPiiU2zC0Cs8YW5b57purntTTlEzEStEtGU7dcEnRmgxBCEMU4WIomO6HllWVkJOCOqk0p9AJJJXFBC70DlVqVPOVlnCh4Tsx7sz3qGVGhKxYDnmYimIxubw4DvG/JNZupYzJ3kT5ISxsrCN
 3LC8wZLJ
 2o9smy7+AaYpY9Y5NFNv0KC96GCQ5PUKgnjtOl2vdfiebtuwNTw1g56kK1ZczkyS/9xi+T7bdvyMtS71DlgRmZKhuv4TR5DBdWRdfB4I8o+LIa+3RGQQmMPb4o24C6+qoZ+nLM8SkbZoxOxJNrkrOZ/VYYznM2BnggjD2VRe3FRRTpVBUtPAX3KrtjguO3C1gwozWWLnVPAAV+y6LgG5SCyosQ/f+h6m//gcv9BPGT4K4HgLTnGx2l5ZGvNsmIoCHdNF7o2oXh7jzEY1LQTtCnjjd6NhtkPeaYaJvyxCH4YPee8KHYJbzTtSlBHns1maddJec3rtRHNqJ7c7TlB/krB0lgvnI1mYtQlFK0COI1LceGqfltzDxA7UDO1tGowijwp7bhaRTq46pc1OHk75RNSaDjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

And also remove the relevant description in dev-tools/kasan.rst
which is hw_tags specificially.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 4 ++++
 Documentation/dev-tools/kasan.rst               | 2 --
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index cb850e5290c2..e0115fad9e60 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2899,6 +2899,10 @@ Kernel parameters
 	js=		[HW,JOY] Analog joystick
 			See Documentation/input/joydev/joystick.rst.
 
+	kasan=		[KNL] controls whether KASAN is enabled.
+			Format: off | on
+			default: on
+
 	kasan_multi_shot
 			[KNL] Enforce KASAN (Kernel Address Sanitizer) to print
 			report on every invalid memory access. Without this
diff --git a/Documentation/dev-tools/kasan.rst b/Documentation/dev-tools/kasan.rst
index a034700da7c4..eaae83fcb5e4 100644
--- a/Documentation/dev-tools/kasan.rst
+++ b/Documentation/dev-tools/kasan.rst
@@ -129,8 +129,6 @@ Hardware Tag-Based KASAN mode is intended for use in production as a security
 mitigation. Therefore, it supports additional boot parameters that allow
 disabling KASAN altogether or controlling its features:
 
-- ``kasan=off`` or ``=on`` controls whether KASAN is enabled (default: ``on``).
-
 - ``kasan.mode=sync``, ``=async`` or ``=asymm`` controls whether KASAN
   is configured in synchronous, asynchronous or asymmetric mode of
   execution (default: ``sync``).
-- 
2.52.0


