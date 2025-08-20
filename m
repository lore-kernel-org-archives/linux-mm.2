Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FE11CA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 05:35:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42E836B0023; Wed, 20 Aug 2025 01:35:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DF246B0024; Wed, 20 Aug 2025 01:35:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CDE36B0025; Wed, 20 Aug 2025 01:35:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 160A66B0023
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:35:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C4C00B8A49
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:35:47 +0000 (UTC)
X-FDA: 83796023934.22.64F5893
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 33D80C0005
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:35:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XY7DJoGt;
	spf=pass (imf22.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755668146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lC7gxKLfCffY1/zE+RJo3yBumyZwu5V9Ft7avRiVVTY=;
	b=ThVfzebMlV5ayDSCyOaCJjGq0ZVmgu6VSY7mRnA4Y35UxdaOqrH/2GNOcnZlVte/GEgib6
	3UFedSb0hC6nipjvGVgdZIXAbR+CQaith3veZ5KpnbY1KRCRrZCM4bEm3yw5Btlwr3/Rjl
	bRieW7gwt173jpstmx0eIGHergfEzp8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XY7DJoGt;
	spf=pass (imf22.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755668146; a=rsa-sha256;
	cv=none;
	b=GH5XBkNy362xYaOjj7xr5HSWYfgLqPOieH8Cet3vwAdG/f7//gIxMkw1Cn6yQ0EH3QLKNi
	8uuOA4np8Cc+HJ//oQDmzZCXy9M22YeOnXu84tCQZhK/+JN8WQgGOnyWQohVOLEYz8PJsw
	cYSJnImr3cU0SwE5Xig8wGyyB/Y4wbM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755668145;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lC7gxKLfCffY1/zE+RJo3yBumyZwu5V9Ft7avRiVVTY=;
	b=XY7DJoGt1ZpL9OGDuL6E31SlPaDKPanhcZzs8S/aE5UggDLCxcw3uz//VGttBpb4AXzsl/
	lveRkH2VdxMEq8Ev7emT2Nvpidiltz6aaToBq3Ul8HjUccqZbST6VDgzwQ0hLSO+K1ldhg
	8gbl2VAW7RtzMpZ0Zvg55XiMiSjPQmg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-265-6LzTzuBZPxSmLJLuVYPWIw-1; Wed,
 20 Aug 2025 01:35:41 -0400
X-MC-Unique: 6LzTzuBZPxSmLJLuVYPWIw-1
X-Mimecast-MFC-AGG-ID: 6LzTzuBZPxSmLJLuVYPWIw_1755668139
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4AE39195422A;
	Wed, 20 Aug 2025 05:35:39 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.99])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9FD9E19560B0;
	Wed, 20 Aug 2025 05:35:29 +0000 (UTC)
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
	Baoquan He <bhe@redhat.com>
Subject: [PATCH v3 03/12] mm/kasan/sw_tags: don't initialize kasan if it's disabled
Date: Wed, 20 Aug 2025 13:34:50 +0800
Message-ID: <20250820053459.164825-4-bhe@redhat.com>
In-Reply-To: <20250820053459.164825-1-bhe@redhat.com>
References: <20250820053459.164825-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 33D80C0005
X-Stat-Signature: d5u45xsgiwh7khqu7q95kxkis71ow1ar
X-Rspam-User: 
X-HE-Tag: 1755668146-222434
X-HE-Meta: U2FsdGVkX1/Pk1Ns3XIj26QmVVSn0N0otvmlMFYc+4sqFrmhdtOXCZP1u4mFM1qrBTY7j7aG4yoSrKf4Chxt6Z2J7TGdqv3EKglZ44f6plTnwSAlu2rydeokpV3dM60+NZpkA0/Jj6FcruFIjzMrZ0UVgkhsymwlt9/pQazDXIuJh7yOI+qgr8gxy8AzLKInRD2MafANJpWga7yHsbMfGXT32SftDNQJ2UtBDGB1oU++17z7z30OBgpXHbCH71BxTpYNRlWL6KBnfKNTkODkVG4K6dkC+p1b5s22onhfmvrktVTpWUSNt+ifQKbkM0IW2+hFvanD7pgM6T+gviHuhOBIaTglwTr3d/HLVQaqly5v4kvIOzqu3mF+G9VxuCnmxN3cEmlLI0oJrQOELoXDkGjXiwNi1qThqVqjVw5TlLWsyxaQyyWWuawuC2JZgpzaTHsXzqTz2y47bbWC8RB7Rw7RbAwNs8E7LE5of+RyP+J+Kjy8cF3+cbM0ewN8890uI80gVgpGTGA1zereic53j5dvIXvJW1sy9GtnouP8J3G+liV74p0NFWdtSt/pl/Sr8RikmTQinBpOK/vvXdwEcVFJy74Hqawj1LtFhxtfPkjvn1ZHn0eIEzi8mcW4hhfRMyINwO4yZ4onDRvyDTZzPqSqMXvq5VXde2oVRZt5FgoJANnRSyZbld7BTW3i3d52Y/KsaIAnps/73VZG2Ybpl0/9NBRfhcS+XIGn1OkyG5qfmmIwZqxyNywfIZU5jEsauiW1SUP3VVt0gKgTtB4j6C25XmuwC0DPtO9SbuzsjCmiP3wonz8PprKDgo10Ehhk5BSe70Ua6g5dlgArH4+c5+jAzjeuKYFJIlX/henU8CnzognubvoOIvZSFO0vdU2JcInKtxxO3miUkeNFbCLNFUesGLrbZD4Y9kytTjSP6QhBNR+PGTwO6N/AXaKicP6St/X6YLcKeZHrTqnye3x
 qkIsY9FS
 LW9/UY8w/NrEkOTNX3ZDBB4vyDi6EZV1/cIuHVLNsYN6GT+ghqVwBbNqG4aedaSboLbmufapvg3DEGsGUXPqhae01qg5z6xIA/a493b0opgIWHreNMWJw65GdYk2yT5ShuAPxQv2ClAOw4My/UPLK713VvZMXXdAOYZOc8Bs55HWWes6SRWT8wPvfiA==
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
---
 mm/kasan/sw_tags.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/kasan/sw_tags.c b/mm/kasan/sw_tags.c
index 01f19bc4a326..dd963ba4d143 100644
--- a/mm/kasan/sw_tags.c
+++ b/mm/kasan/sw_tags.c
@@ -40,11 +40,17 @@ void __init kasan_init_sw_tags(void)
 {
 	int cpu;
 
+	if (kasan_arg_disabled)
+		return;
+
 	for_each_possible_cpu(cpu)
 		per_cpu(prng_state, cpu) = (u32)get_cycles();
 
 	kasan_init_tags();
 
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	pr_info("KernelAddressSanitizer initialized (sw-tags, stacktrace=%s)\n",
 		str_on_off(kasan_stack_collection_enabled()));
 }
-- 
2.41.0


