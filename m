Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF16BCA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 17:00:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 399C58E0003; Wed, 10 Sep 2025 13:00:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34AC48E0002; Wed, 10 Sep 2025 13:00:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 239188E0003; Wed, 10 Sep 2025 13:00:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 13D958E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:00:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8B182C016F
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 17:00:22 +0000 (UTC)
X-FDA: 83873953884.04.C55FE22
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 989D21C0006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 17:00:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OKHw7nnw;
	spf=pass (imf20.hostedemail.com: domain of gpaoloni@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=gpaoloni@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757523620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=FvizIHu59rp6upCtuZbBawOd7faEij62QkVXwUqHPIc=;
	b=1aFSxyMEcG23xTGV6C1gM0u+mEmawX5+yYLnWHsAltTcH47f7flxcrJaaFkRV+MFaHfuub
	JwdeRoD8hZDAxjO6kQpaNr0YU4N0Juwama6G/zuTLFvjwRMc1MwBMZUzkxXTv/v9H3VVj2
	l5jxUxt0MAcnc3c10wm58uG8pyGH/FQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757523620; a=rsa-sha256;
	cv=none;
	b=mXhTMCvvgUjLfdipU74E2PPjtIy/LQGG/vAY/4TCoXdQlFRZIHPSgVwccMqKZl/vIEvVCU
	DQEfDssxPv1FC3NgW+UUEQZT++DXmFTytWXSgvP4bw4wbrCDuRIa2Rpe8Chsd6bF2DPGsA
	6AxWUwK5MuMNPKB1Kyy6Q6sypFoA4J8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OKHw7nnw;
	spf=pass (imf20.hostedemail.com: domain of gpaoloni@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=gpaoloni@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757523620;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FvizIHu59rp6upCtuZbBawOd7faEij62QkVXwUqHPIc=;
	b=OKHw7nnwQvOwQDM2iUlsoEaQMDX1vWn240IoVu8WQH5xaKz+HCtvBxCQl44YTSpDE4sZ5J
	YE4ldSP7In43ogzzOW0EeWfq2uKnm6GpuTIJtOrnE8LUqHyq2sOn9RsJlhmcO8Xy2s0oc6
	DqYw+HtoaabOLddPSdO+j47O2AanLDo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-34-qS1aApQlNCaYjZGsIl4Ggg-1; Wed,
 10 Sep 2025 13:00:16 -0400
X-MC-Unique: qS1aApQlNCaYjZGsIl4Ggg-1
X-Mimecast-MFC-AGG-ID: qS1aApQlNCaYjZGsIl4Ggg_1757523614
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2FB3918002C4;
	Wed, 10 Sep 2025 17:00:14 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.22.10])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6F3D21956095;
	Wed, 10 Sep 2025 17:00:06 +0000 (UTC)
From: Gabriele Paoloni <gpaoloni@redhat.com>
To: shuah@kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	linux-doc@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: linux-mm@kvack.org,
	safety-architecture@lists.elisa.tech,
	acarmina@redhat.com,
	kstewart@linuxfoundation.org,
	chuckwolber@gmail.com,
	Gabriele Paoloni <gpaoloni@redhat.com>
Subject: [RFC PATCH v2 0/3] Add testable code specifications
Date: Wed, 10 Sep 2025 18:59:57 +0200
Message-ID: <20250910170000.6475-1-gpaoloni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Queue-Id: 989D21C0006
X-Stat-Signature: yoa1b1rm5jpfbmh63c1xid1jjnawgunj
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757523620-481297
X-HE-Meta: U2FsdGVkX18v14MLOIaOmxfvC4z7cVYzjX8aMFvZMV/zYDyuFkdaipiWkKYFNZSyf0Grk7H9VwhzXUkw0y1YZdzTsebCgeohSSrJJankyjAf3Sti5jYisoc9t6yOlJw46CV8eSSv0TcaM0eygS7migZEzXYvp7F7E0zHIYWOGUpu2D5e6T1QeXecpt678DVDw5YLZqcp388Ew6TOFgbSzGTGPKCNi2x6c+ZoWjYgeVcZaYH61OqaP9eD873I0Zhv/DHzuiUALL5EIo+Uv1VCiJxa5a1/6xrV9xU4LGei1iA/CY21Q0MuvI2F4IYLQWVlM41+TTik183rZtrIaUBPZ926cxHJgtFH0pFbALUTPdAFKas9oS5RI6hRAsyrZhULyr2cGLHMyLrFicM0eVTFPtbEMp5vZOloeu/3iJke1Vcy0jDrYgswXWJcA7sIVOOp7rd45K0nF2HRYe9ix3ucYR51BrRrWg53gOABdjxxkJaxOAOBNVgVeGB5QLCNJliHDCPyUhLD8C+dnGdA+1WvJcQ/P/X3bn+w2/V6ZSZB6faeSC6CNHxlffDbN0tfUntZB2H0W83Q8wVEnGPGKZvuZ0ajfa6MdN7Pr4O/MzVqtzr1/cSLYHoYbmboJGuGeKX3weaZofuMoj2B4tF/b6qjo4V5b2MIMhJatYUxTCUgxJN/jesuI46tliHVlc3Olr8O1OShWUpOcXLhEvb9LlbBTTXOA8sdbiKAx+NKWd7vnzbigIhP+QDXZR39V6j0c1bUunxM962mJiATFhpyCF9vO0AytDO33pS2l1v8wwleb6xr1xo6QFYOSP5ldSN7PF+OTOn9riO6DzTxG81lRTLJPjLemWfq5Vj2SPtTj8XR4HnepNzSmf7i+WcnCplBg3zJyVIHxrbpNcSCBqnjaSU8OhExZTTkJpiKbejILdl29d783uOGLjFDiZOlgX8uM2TYT/57lF9GjvlnyuGLXwl
 SjQwNpOv
 o3aMrnQJwqQ0eU8I9LkmKEb3WEzzgrBuVui14SwzF6TMiQx5kwHrjbCjc7wRH1+hbEj4fMa+KzEKIpVXsKLv+wC2e1/jM1/CUGvxMJYzOeqAdQvYgmp7e7Y1YytGseMHgY+sHkPwpm2X41PEqkNNYw8yaaGx1mSVTGd/vKx2bDZQuRemjZaIz+HxqhOpwaZkFY0/B0dJBMYSEwqOkO+3fQ9wEna7R2v9alA1CTDPj2fKcUSIiSxU8i6wJPQo5ops3uZZ6gzCg2/x2SjaiWT59xXxFWNL29vAoHBkz1q7zOkkGMxoQ6yYo5I/oCIU0P1AtxM8OkLV/wlsJ7PmXpfCP0gXA6WJTh2DIPhH5ZQ1TrxGRFe4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[1] was an initial proposal defining testable code specifications for
some functions in /drivers/char/mem.c.
However a Guideline to write such specifications was missing and test
cases tracing to such specifications were missing.
This patchset represents a next step and is organised as follows:
- patch 1/3 contains the Guideline for writing code specifications
- patch 2/3 contains examples of code specfications defined for some
  functions of drivers/char/mem.c
- patch 3/3 contains examples of selftests that map to some code
  specifications of patch 2/3

[1] https://lore.kernel.org/all/20250821170419.70668-1-gpaoloni@redhat.com/
---
Changes from v1:
1) Added a Guideline to write code specifications in the Linux Kernel
Documentation
2) Addressed Greg KH comments in /drivers/char/mem.c
3) Added example of test cases mapping to the code specifications in
/drivers/char/mem.c
---
Alessandro Carminati (1):
  selftests/devmem: initial testset

Gabriele Paoloni (2):
  Documentation: add guidelines for writing testable code specifications
  /dev/mem: Add initial documentation of memory_open() and mem_fops

 .../doc-guide/code-specifications.rst         | 208 +++++++
 Documentation/doc-guide/index.rst             |   1 +
 drivers/char/mem.c                            | 231 ++++++-
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/devmem/Makefile       |  13 +
 tools/testing/selftests/devmem/debug.c        |  25 +
 tools/testing/selftests/devmem/debug.h        |  14 +
 tools/testing/selftests/devmem/devmem.c       | 200 ++++++
 tools/testing/selftests/devmem/ram_map.c      | 250 ++++++++
 tools/testing/selftests/devmem/ram_map.h      |  38 ++
 tools/testing/selftests/devmem/secret.c       |  46 ++
 tools/testing/selftests/devmem/secret.h       |  13 +
 tools/testing/selftests/devmem/tests.c        | 569 ++++++++++++++++++
 tools/testing/selftests/devmem/tests.h        |  45 ++
 tools/testing/selftests/devmem/utils.c        | 379 ++++++++++++
 tools/testing/selftests/devmem/utils.h        | 119 ++++
 16 files changed, 2146 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/doc-guide/code-specifications.rst
 create mode 100644 tools/testing/selftests/devmem/Makefile
 create mode 100644 tools/testing/selftests/devmem/debug.c
 create mode 100644 tools/testing/selftests/devmem/debug.h
 create mode 100644 tools/testing/selftests/devmem/devmem.c
 create mode 100644 tools/testing/selftests/devmem/ram_map.c
 create mode 100644 tools/testing/selftests/devmem/ram_map.h
 create mode 100644 tools/testing/selftests/devmem/secret.c
 create mode 100644 tools/testing/selftests/devmem/secret.h
 create mode 100644 tools/testing/selftests/devmem/tests.c
 create mode 100644 tools/testing/selftests/devmem/tests.h
 create mode 100644 tools/testing/selftests/devmem/utils.c
 create mode 100644 tools/testing/selftests/devmem/utils.h

-- 
2.48.1


