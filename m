Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B3D5C531D0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 01:34:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BED8C6B0088; Thu, 23 Jul 2026 21:34:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC4B66B008A; Thu, 23 Jul 2026 21:34:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADB3D6B008C; Thu, 23 Jul 2026 21:34:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 779AA6B0088
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 21:34:53 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CFB84140130
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:34:52 +0000 (UTC)
X-FDA: 85021951224.18.29918F6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id CCB66A0012
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:34:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=e9d9IL0h;
	spf=pass (imf25.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784856891;
	b=nSzL4GCZrRI1/jYlId/u0qlIVt3BAT259v7ogz0/KLCosrWkcB6UAV9BZuPMrMx7AJobXL
	Kvw4zu9MH0HtnZwpevXUWgZbR68CTGqf1q1W4qEFkOaVSXnFWb0jk3bAHuOU/WQvwl/5W5
	0vMu3x9WxkIU6rKJ3+3xSoTVZSX1JFM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=e9d9IL0h;
	spf=pass (imf25.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784856891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aTPhd0YOiSXsclxv5AA53kAUpU9ZSjRHrVegM1KWz8s=;
	b=FYmJbG/iT3XAyJniksJJJDzhCLS6op44QzGf7AZR6RmdJ1q2so57tDqH9BAg5nSdB4SGlo
	WQkjguL25jwx7AIVQ/lJK3l0qFG07t/xI97+iZUPNF4k9cieqCZpJBuz03vv8vT6ADh1fV
	wyxKJsGtkFd8frcGMfeRwDqUJ2uGTCg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784856890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aTPhd0YOiSXsclxv5AA53kAUpU9ZSjRHrVegM1KWz8s=;
	b=e9d9IL0hrPG9ztGwtNVh8dms6pdbxckR0tKXgg/e1T00aWte8EnFOYpF1rDFcDA8qzAiNb
	48NNuO1ounl2zztb+VtO198PTzPsQuXIuF/fr1BN47ZCCTbZi4IIqQTNnmczibiZyddG2t
	S1T81p3nPNo9OZbbbvpf82mCWfOBc0M=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-440-UQzh6pdIO4SVB24qQpwLsw-1; Thu,
 23 Jul 2026 21:34:45 -0400
X-MC-Unique: UQzh6pdIO4SVB24qQpwLsw-1
X-Mimecast-MFC-AGG-ID: UQzh6pdIO4SVB24qQpwLsw_1784856882
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F1A221830331;
	Fri, 24 Jul 2026 01:34:40 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.80.238])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F3AE31800594;
	Fri, 24 Jul 2026 01:34:35 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	lance.yang@linux.dev
Cc: corbet@lwn.net,
	tsbogend@alpha.franken.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	x86@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	ira.weiny@intel.com,
	hughd@google.com,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	yintirui@huawei.com,
	ljs@kernel.org,
	dev.jain@arm.com
Subject: [PATCH v6 01/14] docs: tmpfs: remove implementation detail reference
Date: Thu, 23 Jul 2026 21:34:05 -0400
Message-ID: <86170cc663c4bc70db88363f41e3b4dbb93d4a9e.1784856856.git.luizcap@redhat.com>
In-Reply-To: <cover.1784856856.git.luizcap@redhat.com>
References: <cover.1784856856.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: CptYAlDdURxWzHbsxv21ARkBqRe2FijChNxAlwOCUCM_1784856882
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CCB66A0012
X-Stat-Signature: c9tiqhz11yk7rfjik8htqyhetrpcchfw
X-Rspam-User: 
X-HE-Tag: 1784856890-512685
X-HE-Meta: U2FsdGVkX18X08/7TOALV0ol0DyMn+NZrzi5r8ov0+m1Gbr2PFg+kyamqnacoaXqSAAWRPzLreo8l3OenoSSh2gP79b3s4WKUW58V3929aQQmvyW9DSz3q3GWkGgrMzZXBcCZBnI0MNmM1nRIxvtiw/JcKVIOKbmU/KQr239tfOX1YPyDNOLuXFl0nnUUOp1whVVXsVqaCo5ZWV7u19irKkGRxSBfBFXmk2yG2jeHc/cVfQQtQuAftcBq02XAOP8UoVmFM2w8JKKsZIjBFOOK4SLIEzNJNCo7ziAIuSmHMiLDxfZSF4gjE8nfkVlnMzp1s3PYza4bGUDHLkbvIT+bS60z5arHcMQzjwNedvXwPcH5fFjEqxHHQjzQUi/6zVlPjerpkW9mxDvFBRLCqSA+Bh0hGatCvSya2pGW2dGCSUo7v2xYcte+EdL8syZXIOx+GepyO1DYZpNYkKN48Zezm7lQ2NmVwXHrK0sRBpkuvIUTOKppWNGd1msoxb65PF3woPgw0gzfhjyvGfb+qfjxfHyTQ784CUI4SEgAZPm/yFkjuAkhEOCbZ1lr7M/uVe2Sy2MIcEq5hmw/68RZ2r6pTMua/JlSbwkHCTv7dJyQb4sxoCcV9J4iosp5NjcImLs7X6Xm/Cnmoengr0dJ5Q2OJJV7yBGJMQfiNgW17KtDxSrQuORFKYFQCXD3TLaNqwQitPbtY6q490Fgz81mLbLQ4n2+XoHmXdc4F6GShZIg3lRRSmoBKw2UsZcSqus9djTdR6j8vut417XD28EzL6uQsrr9yFq+Kjh5w8z5lqc30GNp+8nzfYD9GUkTo13THOnoJeXOlThnTQRIXplzRi49XvDp8BkdBlsf5bQawfeynk7v6qamOvAXcPVkPItDWTHZ6Uog+zXcLScQhWQjuD7FtGWkQ1gAEJnHrrbDQx1ONIk0Hk74IvIWCYWuhdvV+S5RD6KFnnpwAi961Efm7V
 3I5cO4uV
 vK+BzK1PaEwM4Jwil93OSBPUNqF88c/gRIt7ATZSWJbt8Ma/plEqKdhZ7R94QpKxKGN0eaK0iMFPUM/pVIdpwkKSIKjMK4ZXA24IyhBo0AR57TQH98KkCNSnIyizl4WKBiNCCG7fU970o5yUsQgxXuIXtlcm3f0OGFfZuSmmrcVvupzxZYYbhQ3fhlTMDvGwEnBQfWs8aN6aXN1fa5xwdp7+Io4JWRdQHWcxLHZdiur85u8ba9AJa0Q6Hvu7uEl0EdSvYSmT5KpK8yiX3xg2T2I7hzIwhVMFXvPI/liax2+duxLCVUardwZQO116zvgh8JI5GhPOGc/j3Vw5IUba9lFiOYSybF9PeZHDE55w96uMYTxJDgTdGJtnofz84x4PbWHRoQXOSFAKpJTlA5euVOVy7BfNrqrcSOBqYY/gEnxR9sIETqDKaL9HtTjfLW6BNZAg3zQBT7aLBn9tuVjQP2WJyzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The tmpfs.rst doc references the has_transparent_hugepage() helper, which
is an implementation detail in the kernel and not relevant for users
wishing to properly configure THP support for tmpfs. Remove it.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 Documentation/filesystems/tmpfs.rst | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/tmpfs.rst b/Documentation/filesystems/tmpfs.rst
index d677e0428c3f..46fc986c3388 100644
--- a/Documentation/filesystems/tmpfs.rst
+++ b/Documentation/filesystems/tmpfs.rst
@@ -109,9 +109,8 @@ noswap  Disables swap. Remounts must respect the original settings.
 ======  ===========================================================
 
 tmpfs also supports Transparent Huge Pages which requires a kernel
-configured with CONFIG_TRANSPARENT_HUGEPAGE and with huge supported for
-your system (has_transparent_hugepage(), which is architecture specific).
-The mount options for this are:
+configured with CONFIG_TRANSPARENT_HUGEPAGE and with huge pages
+supported for your system. The mount options for this are:
 
 ================ ==============================================================
 huge=never       Do not allocate huge pages.  This is the default.
-- 
2.55.0


