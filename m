Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7DFCEB4917
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 12:50:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B2496B0098; Thu, 12 Feb 2026 07:50:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23BD56B0099; Thu, 12 Feb 2026 07:50:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1486A6B009B; Thu, 12 Feb 2026 07:50:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00B986B0098
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 07:50:24 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D013EC01A2
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:50:24 +0000 (UTC)
X-FDA: 84435787968.18.F7A1911
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id E916BA0002
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:50:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I2jutKwk;
	spf=pass (imf25.hostedemail.com: domain of gpaoloni@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=gpaoloni@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770900623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sGcCgAZHk66I41sdH+V/InTAwrTE9rISL0Ovf7HhMvA=;
	b=z5gnIqh1yBGOEX5OBbfvgPy3TaA2KSTVvMZJXOSsvb+blNkvOP2zc+2H3vRJfYIeyGH4vG
	s9l8QKqTigd4bSSBAwJfbsalyHgkRk56b2JDQQoYe/veveFz80kzoCq35fEbLZMR7mCCEd
	+YS+kVhrCYaZDqo7SeMWbfJGguCucZg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I2jutKwk;
	spf=pass (imf25.hostedemail.com: domain of gpaoloni@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=gpaoloni@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770900623; a=rsa-sha256;
	cv=none;
	b=UX2rYmIAOE+VxJyQI7jbIRvkZZhJ3oQ6s8dxgZ9NcS6i6Y8y6N2rKuySaWg88iqmkjwXEV
	u32XCcm1GhiAPa/3cEGDVuzOZa1xJ4C9oNGp6rWVta+C2KX/rL/rTgaN1XEHKI8nT/4lpB
	tf+AYuYRuRTe4S2AFk04uaznj5jhnmY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770900622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sGcCgAZHk66I41sdH+V/InTAwrTE9rISL0Ovf7HhMvA=;
	b=I2jutKwkdZ9VBIMD/WWQajwbZSLYOFGg4jlDvWNRkawXWxUYwua+JK2FDC31Co4LhgOGRz
	E1mX7+u4CDXIQOGHAgnQZBZso4S+SM34uxGQGXBC2/oMvHLtAlrAjGvGYB0Hrr+W5YRWms
	/RyOc0Z/jQxNKsPdEG2CYEY5JRhGgoo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-663-6JYgwUA6O2Kf_Ktz0zIqKQ-1; Thu,
 12 Feb 2026 07:50:17 -0500
X-MC-Unique: 6JYgwUA6O2Kf_Ktz0zIqKQ-1
X-Mimecast-MFC-AGG-ID: 6JYgwUA6O2Kf_Ktz0zIqKQ_1770900614
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3209918003F6;
	Thu, 12 Feb 2026 12:50:14 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.22.11])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4102130001B9;
	Thu, 12 Feb 2026 12:50:08 +0000 (UTC)
From: Gabriele Paoloni <gpaoloni@redhat.com>
To: corbet@lwn.net,
	skhan@linuxfoundation.org,
	arnd@arndb.de,
	gregkh@linuxfoundation.org,
	brendan.higgins@linux.dev,
	raemoar63@gmail.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kunit-dev@googlegroups.com
Cc: acarminati@nvidia.com,
	linux-mm@kvack.org,
	safety-architecture@lists.elisa.tech,
	kstewart@linuxfoundation.org,
	chuckwolber@gmail.com,
	gpaoloni@redhat.com,
	Alessandro Carminati <acarmina@redhat.com>
Subject: [RFC PATCH v3 6/6] char: mem: add Kconfig option for devmem KUnit tests
Date: Thu, 12 Feb 2026 13:49:23 +0100
Message-ID: <20260212124923.222484-7-gpaoloni@redhat.com>
In-Reply-To: <20260212124923.222484-1-gpaoloni@redhat.com>
References: <20260212124923.222484-1-gpaoloni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: JRu9IaKN6M5LXBOzdKcSGJtNfIrbc_jzqQY1I9oXFB0_1770900614
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: 3jjg483dpan3bbzie5zbc71p838mp3dh
X-Rspamd-Queue-Id: E916BA0002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770900622-95251
X-HE-Meta: U2FsdGVkX1/AFipJY8m/1A6wb2NsU6ZN66Nx4zyfX8e9YaoLuC8mZeESuKHS6Zv6EY5QzmagW7QD3pMUfM07o3ijz6Lp/8uTCUOQ/eexkO0/tMzRbc6xVvydd8TxGB0boazu/HYJjDd3PMy6vzdVdLjQ743v+sAk0DYbGQX+yzekOc4qSescjy8aNWuyF2P2iDPpxsIvLcKHU2ohUIQJqHRyoikCX5DK7NLL8iSt9BwM1R9zXAyFwaZZmHpOn8zxHxhC9MkuOzmi77HBKHbrbEHE9Wncix+IsaiJVaB3wBtt5Z7lBQW2YtLgVNQrFRLASjho4QPBh82du2ymMfM120dapViWFgCg3FZPCuMrShf0Cgv1aUBhXo3JpkfSpimEr9KmYB3ODjoGKqWnzlZMggcM6S2E2XT3Xt/jnksRlCrAtmBb02Nfb3bMWIQjAq8oYf1F5n8CVz6WHNbP3vZKSTCVb9JNh6U9sfTMIAO9lSx8jojOavAaU+FkjtUTeOxFvsgvUmXLJMFcEA/z41y3GrLjTMYCAhPxTQhYaInkil7tt0SxCPPtD70zRyNSnxQO0U7MdxtR7531dCZhbuXtPuuEKhjP2OeiMBMYd6r5I1k4m3XVxGEXd+ln0usBYSFIZqBFAs4s3I7ydKRrba7mIWUT7rq73I6+TxX2rd2+L0XJZgddDnlGNUO1QH61k4ThWliUP0O8PwqM60jFdcltJfmZeWT7jehpL5nCUfEWzd90VkKiD6kS5MK+JdkF3YtXowbNLy6QU/y1e07B3jvXsVIzNZLwFTPOe+V4di44xpJcLX4TaEbrA90Ujg2mNvDllvwO70pBlFzsMwnmptzkqrDbnhEj9qiSRgmyGySpps2BPVBUpY9nIcTEGTHQIfsAKymdaNrKNk9EZjWEnCZsdgcBdkHQFrfr8frlYpDH9b86rGANqcPVZXMBgQ4W1dwmJzCjVFUo2MK1/ZQ9B0V
 gE5ccgup
 Ty1TN8qPzKZQ002T21h+JDXWPwXgNQXctxIa8FwVC31HRdWktFCjrojwRX/qYAaMJeDO7ct8PUqFXJD97sC8sR5mkv/zuEUVzQzV4LCJP4Rqj5ogegpU/Tcn4mQrEEPwjTDpeJ5+UeYdu89yswLkUfgobbj8EunstEQePwTVJjxrQjtv4hiadBsW5eSqx5nbCMmG05ObHwDpijwRtdcWADM+haYVqSgjhDqvRXr8P1QfWT25lDt+qGxEBmORvNHI1prS8peESxpgqDgsaD+J9JFBgi0nk7tcA14h13b9nkbbiAxIJWhG6SW1ZzURQ1LaTmZlXbeiAvm/2oalpKbTvHTXhHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alessandro Carminati <acarmina@redhat.com>

Introduce a dedicated Kconfig option to enable extended KUnit testing
for /dev/mem behavior.

The option enables tests covering I/O memory access restrictions,
including behavior under CONFIG_IO_STRICT_DEVMEM. Because the tests may
perform reads from I/O regions, they are opt-in and documented with
appropriate warnings.

This keeps test coverage explicit and avoids unintended hardware
side effects.

Signed-off-by: Alessandro Carminati <acarmina@redhat.com>
---
 drivers/char/Kconfig  | 21 +++++++++++++++++++++
 drivers/char/Makefile |  1 +
 2 files changed, 22 insertions(+)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index d2cfc584e202..cd3e47b47f44 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -317,6 +317,27 @@ config DEVMEM
 	  memory.
 	  When in doubt, say "Y".
 
+config DEVMEM_KUNIT_TEST
+	tristate "KUnit tests for /dev/mem" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Enables in-kernel unit tests for /dev/mem read/write logic.
+
+config DEVMEM_KUNIT_TEST_IO
+	bool "KUnit tests for /dev/mem extended to I/O space"
+	depends on DEVMEM_KUNIT_TEST
+	default n
+	help
+	  Extend KUnit tests for devmem to cover IO space.
+	  When CONFIG_IO_STRICT_DEVMEM is enabled, the kernel denies
+	  access to claimed IO regions. Enabling this option adds two
+	  KUnit test cases to verify this behavior.
+	  Note: These tests perform read operations, which can have
+	  side effects on certain hardware.
+	  Enable this only if you are certain your hardware handles
+	  unsolicited reads safely.
+
 config NVRAM
 	tristate "/dev/nvram support"
 	depends on X86 || HAVE_ARCH_NVRAM_OPS
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index 1291369b9126..176f2b8f98dc 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -4,6 +4,7 @@
 #
 
 obj-y				+= mem.o random.o
+obj-$(CONFIG_DEVMEM_KUNIT_TEST)	+= mem_kunit_test.o
 obj-$(CONFIG_TTY_PRINTK)	+= ttyprintk.o
 obj-y				+= misc.o
 obj-$(CONFIG_TEST_MISC_MINOR)	+= misc_minor_kunit.o
-- 
2.48.1


