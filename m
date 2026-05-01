Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B83FCD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 19:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D38D36B008A; Fri,  1 May 2026 15:20:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC2D16B008C; Fri,  1 May 2026 15:20:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8A6A6B0092; Fri,  1 May 2026 15:20:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A99AD6B008A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 15:20:10 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 61E6A87E95
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:20:10 +0000 (UTC)
X-FDA: 84719816580.30.6CF2F50
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 67D7614000B
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:20:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=J+Me5mbl;
	spf=pass (imf23.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777663208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CaWIkKYdLR4Z1vH/dlH7TEwhtG6xeVazXkNWF/UUsyA=;
	b=S1FfWiu0S30YFyx2sOHzr90KDi1iU+IlO4jtlPHi5ucNs+WChi3JD/o7Mq+MhrhrDtAXcu
	my9NIe77uaxYb2ZMSVla5IWhPt1Ylg450fll4WvVsIxaA8uIdqMCyx+McITg9IDJPUuSyw
	0aiYRKHgY+nQSBH4OGYc+SUOVy70SBI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=J+Me5mbl;
	spf=pass (imf23.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777663208; a=rsa-sha256;
	cv=none;
	b=WG6j82vHu3cKIhF6Pp2hTx9pZjyz5t/UZtzJbe8hsDzF9W2Uj49UklTURoYAhGZN2jNgZ2
	aI8HkXfHBpM+cxb9cUz1adQTffw1ky7L35mtsfx8y+z/vSSMlCqjNstCRBrCqrh/RdQrte
	anwvfc0nd+JwYSR6WccpC4PhPAb3aVI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777663207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CaWIkKYdLR4Z1vH/dlH7TEwhtG6xeVazXkNWF/UUsyA=;
	b=J+Me5mblOMj6i0mHtT1BIpJ2hkHXQQJakDPGWak2FK2oeitxen3YzyxhwJMg8uC/lE6nao
	H1XqkvZgo3A0NMoumE9zgueyT/T9H2xQNZPOwzKCbVporWkJxpbWPOb1OPVPoEgLZumyc2
	eKycP6q2DBJeIVbKq1cFPWxq4JeireQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-14-PR0FWLzPN6O1XuyJt8pdzQ-1; Fri,
 01 May 2026 15:20:03 -0400
X-MC-Unique: PR0FWLzPN6O1XuyJt8pdzQ-1
X-Mimecast-MFC-AGG-ID: PR0FWLzPN6O1XuyJt8pdzQ_1777663201
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2983C1800473;
	Fri,  1 May 2026 19:20:00 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.64.126])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4E9771800345;
	Fri,  1 May 2026 19:19:56 +0000 (UTC)
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
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v4 1/9] docs: tmpfs: remove implementation detail reference
Date: Fri,  1 May 2026 15:18:43 -0400
Message-ID: <041c4d9a9d57a9acba90324819bce6fc804b87a7.1777663129.git.luizcap@redhat.com>
In-Reply-To: <cover.1777663129.git.luizcap@redhat.com>
References: <cover.1777663129.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: iaUJdNop1HfJtrTVLbsJbHxv7bsBEmKS7D-q3aTAseI_1777663201
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 67D7614000B
X-Stat-Signature: 8fgdzbb8jcym77kkh5iyappqhpsdwpgg
X-HE-Tag: 1777663208-908016
X-HE-Meta: U2FsdGVkX1/DkAY9bX/ozD1UMQWOtnBdmYBWBmok0KeYuYZYbOmVrXPq4EwpvozWpnWYBcu8SC9xbkxSyFFUmmi+sFJdB03OJS5xIO52G/cJ5D5rXoVyXHV+9NcDH3RmFquDzYBtkldUOiBEMDhlIDZ2q7AbOWeo3l5zr7xNFFZ9zLt2u/4QlOvpkgW49MNat6uk0/aAXBe6o4/WVjmNGKpmantggirL1d9DMp0FVIFZmBzgk0SGztPzjRrwl5M0M1HEWsdjCRxQZrCiqWjt2Kq7/UpkRDLfaaI07nhYsB797JhfQbJZlGEUFCO/wPMq4WsjdHsDhtKbFRpMruWg8xTYvPOWV/w6ezjOOnuuwhakXahCQZ0k/QPoyKpGfFviXbJqSkIchbcFZETpiXlfcP0FRHvaAUsYU37Z4zpUa29B71pjvQI77whSlvVlgDs8e0EosABVeckKy5bQbHYDRKr6TZRoPtW+9HtN4N2YKTB9hw72Nug8x+Msi5GY7mi5avdHWfbNvhwAd/z9B3HMv2DEWWlCjH6WkPw1E/XZqiIisPQC40dGrDRQnXpD5rXOYNrcGfGT1bZ1292ZiFvhrJo0MU0ae9ncIlCB4k6zlqDFTExImsj2we2izHltIi9XQcUd7vjcBeQo29L5l8IU9Yck+6sw1z3FeMbYgs1wCo9/tlHNpFdKhg3PO+g+YtTfetjwxujG9TQAISiIJy3hhT0a3qMgIT5gAkhRzn6yKkPw64tJ7pVDskqp94Tg9SJVZJj9Rvp8vv85gREgQu/2NckkUKwKylS5EcnbDyk+HvJpW3BEpUm2SGiQmS8OZmizzPUp1KX3sJ1gK9VROq7MmkgVA2ylaP4CCJKtnKluI9TTz+RSlW2fa1odh7oZltiqYew8Nv6Zn9faKnoI6vYFsdM41sEJ8kVyWLZST3ZsKyNXN2y8nfYsThbVXOMjP6Ysq9Ccz75Ojl/KVsPIxYa
 jpiJTsFK
 tBIQH1xLtPLqGCQO+LPqO+77mUBGl2xYDtBcDPbqpsjX2Ro/RucSThmfUqwjR3ftWEziwLWyl+cdF/ipb9DSjv0J/h8ri6r8IolGtLma2k6vCMQsu3d4P5gx6iFGPrI3Apv2qk8Zl3IolX0w+EXQAVqP1Eusd4QqNAMRsW+d3R6KmKiXA4XQYja0P3xUu2PuF0nU7a0xdidhlsDBaTakEgso+mV81HpmS8XKeE9KlD630hJYnAXgRM2NCYls66570JbHlenM22GNSxWNjwrdePWB6+isUQsN7J6SnDcQX2l+Kv1asWfXIijQ5IK3YMyvsaFpjOZt0+Tg8M/IgQAlnSCn2hdF/QMabsavpWJjLINfdWe4NEZSMdrKyi9arHNol/pvMkwLWohTJuhKwoqxehn89Lr7vdEVL5ZGj
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
2.53.0


