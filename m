Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64865CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 05:36:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 085C96B0032; Wed, 20 Aug 2025 01:36:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00F146B0062; Wed, 20 Aug 2025 01:36:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E19426B007B; Wed, 20 Aug 2025 01:36:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CABE06B0032
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:36:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F0E61DCB72
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:36:06 +0000 (UTC)
X-FDA: 83796024732.09.D9C3F4F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id B5AC3160007
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:36:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AVjw5Qp3;
	spf=pass (imf08.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755668164; a=rsa-sha256;
	cv=none;
	b=eHYIXCRRIH/7tAYNqH80cozBxi5vrTNdwY6CDBIw2Msnio3R9EZRWQ8tG5SyPH/7I4edcQ
	QsRFn06HSw5w01s/F7apGSgXo/9nvCbTFt7nNqg6WLIIP9WafI5BoB0Ujyv8m0OyX8GS3j
	NrEofy4A8RLuAbx9lmx7602ILhvbAAE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AVjw5Qp3;
	spf=pass (imf08.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755668164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oS87V1n70KnlvoMP4fCQ/ERdyh1R0fC3CtG4IQhVRyE=;
	b=adlLGbH+WTOeMEKf5V/XSEEIa9lodB1etQM2JY/joIaq1A2zJLr3eNE/a1J+IBTG8SeutY
	MQaJQtLJgC/nYuNsh5BXIXDh8K2Eg5Ruw47k5OpIxvg7+xjgVmi0smExlhEIxn5yCJ1Nir
	hRqtFbqEasiYwQk5QwfCnLM1UWcO9Bo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755668164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oS87V1n70KnlvoMP4fCQ/ERdyh1R0fC3CtG4IQhVRyE=;
	b=AVjw5Qp3ipHIFUMmfa33kKBEq7cD4HKcl9utkj3u0A1uBr7xngZ/HUyRnBIVCE4jUeIkSH
	+7pNgK2K7JSXluBYzVIYwhBrFgz7a7JPMhcf8SeSCuKPbYHRiNehonM3fCoFmRLXJwNV/1
	xL7pjtV2BcMjfW/xJNOcSTSJvPa7Wrg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-547-NwZMdlajPhyC9_mbi6VafA-1; Wed,
 20 Aug 2025 01:36:00 -0400
X-MC-Unique: NwZMdlajPhyC9_mbi6VafA-1
X-Mimecast-MFC-AGG-ID: NwZMdlajPhyC9_mbi6VafA_1755668158
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 84A5019775AF;
	Wed, 20 Aug 2025 05:35:58 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.99])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2B42719560B2;
	Wed, 20 Aug 2025 05:35:49 +0000 (UTC)
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
	Baoquan He <bhe@redhat.com>,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 05/12] arch/arm64: don't initialize kasan if it's disabled
Date: Wed, 20 Aug 2025 13:34:52 +0800
Message-ID: <20250820053459.164825-6-bhe@redhat.com>
In-Reply-To: <20250820053459.164825-1-bhe@redhat.com>
References: <20250820053459.164825-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B5AC3160007
X-Stat-Signature: tacsq756ucza6dwcd3dzspou5foe9c4s
X-Rspam-User: 
X-HE-Tag: 1755668164-432241
X-HE-Meta: U2FsdGVkX1/wbt6AfipObd6K+L1HGdyaDjw4QEMKNtOckNmKQl4s27MN8+Tn4yXt9zbZhdCzf4wHDXVRJGzJ+63WKiw8SWZGnRlNv43X47qwG0IPpbPu0YIleZrw6cQHnsThhPUh+VX+nKBq2nwwVGC0QQt2CIgVB6fRT+NbUQKSZf0uQ25tApe5a7BF3rggVPlVCOml/ynKgG/zmvehUo+ur/i2DKh71TygpEyjl4UZL+eUIjjphbet6p2C+GJhLpBuj9Uz9VIPCoomzps7X+696KDvutSFO76Y2qFmjqzKT1aTWp3QM1nBNxrwQgG/zbTCh7NtRRH049t3Hv7aZQyWX9ac26EiWlqTnjRASfdrSO3cxsYoBX93+/EfnopZF72pY1hLkkXgge4SWyWO5CoHB+vWFskQef7kzsjT0uHcWfdczCnhM3qTKsAgp/hAVjf/Kkp1TVi1a/0RyF+H+VqOVZfCk1hlju5+TqBVKsTlYp8E9RUVv9PlGmpiPP8snBIZ28Ygi3jstVfB3adoKHwIzdsLc91LbsSqf8pS08WZW1IevcDMzXCfCzNt2Gb+KlHeR6OCVgrsTXgdfxkozij+o8CRshAkeSb2n4NPcHwFKS2Iq0qP7nGJ3Licb4Ag4QeLRE6eZMWODTHrjFuIxumf14VF9ZteVtW3xD2Wd4XwsbhnPy/5oYQ7J13TPK/Ti2VxDbwDRL4OA5ajsbvUj0ZyRSAeB+IXCFfNFeAbf0zd+Kr3SMLCiqTC9bdfjMbk65jq0pZKJIuAZADVnLM5W0PPDZQ1hJzCAL/iLSEoW9S3BaIBy1eZY9+JIdWR7HhEDiaF3ov0hlWGmrJxaoOBC1CXOP8NhZs9HKg6RIovSx7Gk5pVJx+fhHmXRCKgI0i+qsI1DFpglVXDJzGJCpaQ8H69JtiLvlzL2zmOCEyTKWpsbvoAWUy5iYxVTDBDo46iCyEUO1BVLErztDt9g/D
 HGkuDraf
 YbLgxi/nB4M6Vu+LLFkUNUDAHmalRTNtzxcNKmbk7piehzLKhBPo5GUuYFtpiQy8sHY3AxUVmLsUM4UliZCTfn30wzUBfQGYa0hxhX9Qq28ryZXnLkU0MPascVrRFEUXd2QpTGZUS8kElarVMagcPiwEC3a9Imvy+t+l0AANzY3VKQ/x2ZW+rDl98/k6O/ipqX5XeWIyMKk1d/1VXu1POXhQAhLQjSlKbl7o/fNuQwe/aPpwgqqczQWD693CrP+XYmj49WNYgQvmRsswFmegPhPaQZLuU9j0GdPH/ucdcZ1tHyoqF8IqFIA0Dw0USpHM/qMx5AV1TTnqgA3SYIJqJ7g1ut6jOKOwgqH/kj6NATGMDooTsSwGsu/9FJW/Efx0tukemxrgD9gQ+/ULlgYCNgPNN0YDQZHbiXmsOrFscZ9diSppENYs/0eFiJwLCcvbU8yjPKIAPEg4+A8Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

And also add code to enable kasan_flag_enabled, this is for later
usage.

And also need skip kasan_populate_early_vm_area_shadow() if kasan
is disabled.

Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm64/mm/kasan_init.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
index d541ce45daeb..0e4ffe3f5d0e 100644
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
 
@@ -397,6 +400,9 @@ void __init kasan_populate_early_vm_area_shadow(void *start, unsigned long size)
 
 void __init kasan_init(void)
 {
+	if (kasan_arg_disabled)
+		return;
+
 	kasan_init_shadow();
 	kasan_init_depth();
 #if defined(CONFIG_KASAN_GENERIC)
@@ -405,6 +411,7 @@ void __init kasan_init(void)
 	 * Software and Hardware Tag-Based modes still require
 	 * kasan_init_sw_tags() and kasan_init_hw_tags() correspondingly.
 	 */
+	static_branch_enable(&kasan_flag_enabled);
 	pr_info("KernelAddressSanitizer initialized (generic)\n");
 #endif
 }
-- 
2.41.0


