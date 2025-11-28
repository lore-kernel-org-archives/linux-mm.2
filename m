Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FE5DD116F1
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 03:34:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7B5E6B0031; Thu, 27 Nov 2025 22:34:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2B206B0032; Thu, 27 Nov 2025 22:34:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91A426B0062; Thu, 27 Nov 2025 22:34:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7F9E46B0031
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 22:34:34 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 43EBB139FED
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:34:34 +0000 (UTC)
X-FDA: 84158598468.10.745AFC3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4D4C720008
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:34:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Lj3MK88U;
	spf=pass (imf13.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764300872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lfKMAPgOw/dmuGwbVXfO4D5MkyZDnIUQ+/VwPEWi/wc=;
	b=pCjLidz4WgMse2D0/y8ahIBAjK1kt5VZRH07nEN8q0Odz5Cn1SbIrig1NPwSInZVWJr9Wi
	ciYE1dptVei7G1s3geVhSS59hhx10M3Z7HmD8hxPoQ0yj/cSosDSFlHWbCbMZ/OQggqVxO
	ol93iWCI5v3KlWnjsmcOg5+ZTEiPJ1g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764300872; a=rsa-sha256;
	cv=none;
	b=McS538DJUbxVro6ntduylhxu3/oRPmy7cIA3JqyLHI3pQJfNhSJkl0Hi6sBUBABrPOc5P3
	LSv6DcbpNB0XbouA+Bial+k+nbF66oomoBDmatEWEeykdKwGcAATa1r3urxcKSYlgRPer9
	ZjxoVS2GFSQZ2RbROfvwvA0mYC81v0U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Lj3MK88U;
	spf=pass (imf13.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764300871;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lfKMAPgOw/dmuGwbVXfO4D5MkyZDnIUQ+/VwPEWi/wc=;
	b=Lj3MK88UkxwclNkVW9+pv82yEiT0/CfqjoN9qFgdUuLo3wjiqo0oEdmxJcn0WC6Y3BbLJF
	w+eqGoLsq7LDXahQehG96m5XUfMbMDQQw8kAalK7jTRBdn4NWmR2EfTicK//2fMI6Ws/j5
	gL6QWPRj8/ePdsEiM0N6JiCeeopdfxc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-115-zjYbfpDXMs6rEpZfQ8z1Kw-1; Thu,
 27 Nov 2025 22:34:28 -0500
X-MC-Unique: zjYbfpDXMs6rEpZfQ8z1Kw-1
X-Mimecast-MFC-AGG-ID: zjYbfpDXMs6rEpZfQ8z1Kw_1764300866
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 256E11800473;
	Fri, 28 Nov 2025 03:34:26 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.7])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A827D19560B0;
	Fri, 28 Nov 2025 03:34:18 +0000 (UTC)
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
	loongarch@lists.linux.dev
Subject: [PATCH v4 06/12] arch/loongarch: don't initialize kasan if it's disabled
Date: Fri, 28 Nov 2025 11:33:14 +0800
Message-ID: <20251128033320.1349620-7-bhe@redhat.com>
In-Reply-To: <20251128033320.1349620-1-bhe@redhat.com>
References: <20251128033320.1349620-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4D4C720008
X-Stat-Signature: qrxpmmr86wh9khqhws3pozrdawq7368a
X-Rspam-User: 
X-HE-Tag: 1764300872-813058
X-HE-Meta: U2FsdGVkX19r8H5aosd9a1tQeAMt1cebfkkesFgzzXTNyb6gSgn0j05uWDvdxHdoo1bXAhQDUiQcpHo4zCJxzacP6TADEITPfonM+7nyIfyr3c8YSTy5i+aKpaRO8oHS18G0PW3kIjEIfuwm+1daJa1Ae5w7nw0hBv3fzkY8/Y5onOvlwFM6wriQ89d88ZWZUqEvkMqi2lhHnzOK+b2V++8+qPm3GgU48yzdjoIBAsHtVHiUgo3SSvKwnldwO/hVTHNXuBt0l8oTIMa997hyMCYLOdEpkAfkGp27jeLpXy0JOxlC0DCHhNpQL5aF2HY3TMYjZGwF1aB1ugCu2O78JkL7xXWLPBO/a3Ohgx2Nri5JIjYlyAJgiNiN3hfeaJHKieV2OaIAgUAl3VqJpJ+/rQGRTdUA7YxLBy+rZhQ1lXvrcDyQsXtEIotNRtvFs7GMUQX9zskjCcQuu7cOqNIf9+S0TwMuzOMxeXsBj0Se+MSnL02qraltH5AtRye2VJcHNlrJPWGrFLU/pB2oNOaUXRBWvcAUMybDIIQCUIPEUHU8mwTMQ40CWai8rDoszyFijdgixs/6Br20OkbpWNU3O/9G3lLwANxjZ8NJVD9onv1jVB8G4/UwoUGnfcS/qXJ3ED1TEn9y2iH5LMHDEqaxu2Wtgou4VEDi4vqxXaWdDBizeLjVB5RTMYdM/qotBAJ1mhR3SuaImuS/2SLF3w6B2yRfxep1IbmVEmOkxkVOlsr7EbjIHbDoEuB9ocDWfSixn+ZOld8hZu/HKEXKVdj7dGpBOL9nr7lkMOTS7HHGoTLcFja4TLqEjppQ4ixmGTrCvVWCysx7Ifb9prHfV7M/d9FkItwBzkqFo95XCpanrbqE8Hq98MCtqZEdM+yJTF2tpTAHQbmVDnoLhrLkWuxx1V0rOSRIvPo33cWvLnPaD9c6c3MU+/JLi+ml/rROGDNblC/TW9UYaWaGUlGE2lo
 av4a6YMH
 j2zlV6pDUGZDVnAgUqXweotLhs8LEgU4ohegcgu4ioz9DYtEvwfEnf+Q8mXX8sdgEqYMnLB02aW/AV/cT7GIqNmjBri8XY4YKzqvAZpwQcX6X87fOMiPZ07M5Hbdh7HsayyebVdUbqgpz5OSxgCaHjHHkh3uC6rn1qe4wHorH/nOzwastwTHKaE1JoWkmil5BLx1DR+eCN1HRId9S0fsioygh8k8O1FRejxWE9eyjraSP0k13Loak1/V1H4m+QtfqCSu8M1QciZMOdnvdq88ZohM/jTA0m+yzein0mfTkHZ/OdrV1lNw7hlmF8jThOywjZ2RO4L5P6ufLg7jxlWolGOefMYeV3LS0i//a8TTmwJlVjESpsEfQbB0l/jrYe32+l3ymvjIYK0/fhW24WZFGf7GtVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: loongarch@lists.linux.dev
---
 arch/loongarch/mm/kasan_init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/loongarch/mm/kasan_init.c b/arch/loongarch/mm/kasan_init.c
index 170da98ad4f5..61bce6a4b4bb 100644
--- a/arch/loongarch/mm/kasan_init.c
+++ b/arch/loongarch/mm/kasan_init.c
@@ -265,6 +265,8 @@ void __init kasan_init(void)
 	u64 i;
 	phys_addr_t pa_start, pa_end;
 
+	if (kasan_arg_disabled)
+		return;
 	/*
 	 * If PGDIR_SIZE is too large for cpu_vabits, KASAN_SHADOW_END will
 	 * overflow UINTPTR_MAX and then looks like a user space address.
-- 
2.41.0


