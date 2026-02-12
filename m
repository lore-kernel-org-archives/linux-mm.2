Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C894EEB491C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 12:49:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 232876B0089; Thu, 12 Feb 2026 07:49:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DCBE6B008A; Thu, 12 Feb 2026 07:49:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D3786B008C; Thu, 12 Feb 2026 07:49:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EA2496B0089
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 07:49:45 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8C9E6138B37
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:49:45 +0000 (UTC)
X-FDA: 84435786330.25.AF0983F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8A2F9180005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:49:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i7EGIJJW;
	spf=pass (imf06.hostedemail.com: domain of gpaoloni@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=gpaoloni@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770900583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mUo0gQwIqPNU9R/kZzDp0f/U84FL9/zC5A+f15msgTw=;
	b=RYqbZZlppBV2WlHHONL4kI2qeC9jU61NFihaiSK1hFia4SNAsOvDPL296y6liwnmrxAcp9
	OIRk3Jz6k9nZAhpiU4LPUBGuOzHJxNqWWmJSZyw0yE4m/dLmXH9VdYsFLtXusU2mcdS1sX
	GDzY9M+1VPWSdvs3Kz6gJ4CaJGKm3Ts=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i7EGIJJW;
	spf=pass (imf06.hostedemail.com: domain of gpaoloni@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=gpaoloni@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770900583; a=rsa-sha256;
	cv=none;
	b=mWHeTiGjoMTpFR9ze0UTGtxo9gFIgLSbbpd2tbg0hwz/dHYGs9WYw4VhKLHB/1j8scl8Fz
	EilmHo94lQ1Q5KG0bq0PegYqAsDVb+aSXaYy3x1yC+/puN0S7HzV5m4Akk7bM8tAdnV/YD
	976OVhTNin+njfmbp2Ek0TX2q+3xZHM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770900582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mUo0gQwIqPNU9R/kZzDp0f/U84FL9/zC5A+f15msgTw=;
	b=i7EGIJJWz/8TJLfV11Yf/sfpnsaIMnW7yfuhi52aGRRQusDoUpKkaHsiJhRvY45uq15l7x
	KpiiB8q3K7jmCBYjetBmVMxUZWXQtkMTwMNQcpJwERMm2lv0H85qkBabe+MyBUuYkxRhj3
	QoXnikZldxuPsElODAGdQlLZbeampmg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-619-ffetXpVyO_6xxqiGsxf1rw-1; Thu,
 12 Feb 2026 07:49:39 -0500
X-MC-Unique: ffetXpVyO_6xxqiGsxf1rw-1
X-Mimecast-MFC-AGG-ID: ffetXpVyO_6xxqiGsxf1rw_1770900577
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E804A1800365;
	Thu, 12 Feb 2026 12:49:36 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.22.11])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1546830001B9;
	Thu, 12 Feb 2026 12:49:30 +0000 (UTC)
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
	gpaoloni@redhat.com
Subject: [RFC PATCH v3 0/6] some /dev/mem specifications and traced testing
Date: Thu, 12 Feb 2026 13:49:17 +0100
Message-ID: <20260212124923.222484-1-gpaoloni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: g2a4uFQRGMPKtLptN6gPwNIVn42CPnTFBROIUOU9pkk_1770900577
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam11
X-Stat-Signature: 5j3rdrfx6yzgsdc1eyyfiozdpf3myyfu
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A2F9180005
X-HE-Tag: 1770900583-325339
X-HE-Meta: U2FsdGVkX1+uRLHTsu9xQ58dHDDIBzObvVxoiGnUsvwEsqrY1NJXpm9BvA8GDeMh16CGQSFuppW185CDU2MAGLPxr5cWmve96IdaqepVskmFWo1wGu/ZSlK3xhV+7qFCPTfxE2HbTSH2BsqtJEOX8WiJ5zg/zhWDNHWtTtwGfng1WXnC6gZwgfdX+iKCGz29gvDfyP3gPXuqohnJb11Ack0/0Xzgxi0XzgYmw9VhFckx274yQ+nX/hULvm/TCidaFWtXuplfZc6iWEDIEJLjJHNMyXI6/VWK1FEM+WL/41flJPCT2dNLs8rs/pWN0mC0SQZTDUgcl3wT0WY3BwaqtLUFaAdJNRe94FNh+31pgoVTvZnNzmKY8Kun6w5OFniD9hK3bggOZYpIrQ9USirBV6fIC7GrALW0DQ5TCqMIES01ej41hhOTBRzEfl4eoWkerz0GDr0ZuwMULC/D7sOCYUkKfshJVPZehu1/jn7cp76ySQrBr3VQ0LeUBDMRLVfKyTAph78IekDnLvDPchXQ+MTKJ9JovwnNVUbc45N6Vb1utQa96YsYA9EsK31Ixf8wO50seBjHe8wlizjlis/k28NQJeBdD6fxxgskk8vi6GvTXxwVagn/kqFrNELaZGuGLfa2CrjFDsNHgd+I7T7wqvp+I1jNX2IIrTh6muAgZ5dV8oBbWJFO6ruqrObDMyOAsdnf+viN/TnrJhXsaiYVPzP9ruBAb5f6HRI9LbU32aD9nfUWWZWYPFxHuzIl9RnvQOz+O63RwLkXPAWIm/ETN9REx9DRT3223A4Xt88L4rQT10ktNe5DZDHRpRJm0KKLfXzE4K34ji3pdx88oyZZ/cZUGZDWvwxNCve+p5Y5dMpr4Xxrer/YZkhROfzcT/hidu1gBwxlMMVGfNpd/Ke0428doR4Jr+XXjNmsZ4aTSJM99tQI/OTmlJvxidEwOhqy1JHHlpej4M4lk0Ymgna
 s85KZ06s
 IWuvKKt4UHxnhoSmtFbdvttMecZflHErcu8zAOZjfjXHvhglR4aTk5eJsswJF4gAkMOj89+2bqbrvLA+NYRd5RaqTNoQ1i6UCfh5wKK+ot7h3ekN+PcILL51PRakJm03BYzeKoeqFJDqfKWIQtmGyZQRE0G21NG9qwp73QAl0rqJYyKr0m56VtcB70oGEKC7wbteLhdKtkJvz5D1GCHRA/7P9HA6jkRNM+pqhbyqZOiN87Q89iXLEe8cbY6cJ95l4ytdWkBNtmQaTQw2TuzpTf0YH8vRgjyXWE8jkgmOVloA1WrhXpqyObg/LXNbPcdMUniuFacbHb80sH3aGhsystJE+r3l1ajS2US6jXnCMq34F+2c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

RFCv1 [1] was an initial proposal defining testable code specifications for
some functions in /drivers/char/mem.c. However it was not clear how to
write specifications according to the format and wording used for them, plus
tests were missing.

RFCv2 [2] proposed a guideline explaining how to write such testable code
specifications and also added kselftest for read_mem, however there was
reluctance to accept the proposed addition before having clarity on who needs
it, who is going to maintain it and for which APIs in the kernel it is
needed.

RFCv3 (this one) proposes kernel-doc API documentation according to the
current doc-guide for some APIs of /dev/mem introducing the concept of
traceable specifications to KUnit tests.
For read_mem() Kunit tests traced to the corresponding specifications
are also introduced, so that in case of test failure it is clear which
specification is violated and it would be easier to review incoming
patches agaisnt the intended behavior of the code.

[1] https://lore.kernel.org/all/20250821170419.70668-1-gpaoloni@redhat.com/
[2] https://lore.kernel.org/all/20250910170000.6475-1-gpaoloni@redhat.com/

Alessandro Carminati (4):
  kunit: add visibility helpers for static inline functions
  char: mem: expose devmem helpers for KUnit testing
  char: mem: add KUnit tests for /dev/mem read_mem()
  char: mem: add Kconfig option for devmem KUnit tests

Gabriele Paoloni (2):
  Documentation: extend the 'Function documentation' with expected
    behavior and constraints of use
  /dev/mem: Add initial documentation of memory_open() and mem_fops

 Documentation/doc-guide/kernel-doc.rst |   19 +
 drivers/char/Kconfig                   |   21 +
 drivers/char/Makefile                  |    1 +
 drivers/char/mem.c                     |  211 +++-
 drivers/char/mem.h                     |   17 +
 drivers/char/mem_kunit_test.c          | 1323 ++++++++++++++++++++++++
 include/kunit/visibility.h             |    2 +
 7 files changed, 1584 insertions(+), 10 deletions(-)
 create mode 100644 drivers/char/mem.h
 create mode 100644 drivers/char/mem_kunit_test.c

-- 
2.48.1


