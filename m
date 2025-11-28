Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A00F3CFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 03:34:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BCBA6B0032; Thu, 27 Nov 2025 22:34:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08FB16B007B; Thu, 27 Nov 2025 22:34:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0ECE6B0088; Thu, 27 Nov 2025 22:34:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF1896B0032
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 22:34:42 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A31C5140339
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:34:42 +0000 (UTC)
X-FDA: 84158598804.11.91B954E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id E561080002
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:34:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QhrfcA6p;
	spf=pass (imf30.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764300880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pg3FSIRtMXU5szl2eh5KeSgVoSezIgfBLftf2WmfQUc=;
	b=Nnc6HFGy5Y0QUk5pdh0k76hmkNI+gmZuav4tHncXFfqW6Q7fsUzkmljnMXjJOWq+Bj3zlZ
	EcarOVgz0T4ATJmxOo5RnwYp0ML37dxiGEK0HYM0cuP4Tlxxymr44FDBbCitrNV37g3jEl
	I0wgx0gM3eBB/yHVMHZydjtY5GjkkwY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QhrfcA6p;
	spf=pass (imf30.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764300880; a=rsa-sha256;
	cv=none;
	b=6FO5qOjAUb7F7uunj/jM+GN1XCuEd1UIXOX65/dIZNjMVron80pMIdpfp+0SG60F1c+gCs
	NAabHoVNaGkl/z6oAOeYwC4yTM9ZSCVlW2rc3O6vHy7mEBNy8k8qlt1d/xlwwnv+C7aZ+q
	xZoYCxYIXSDhNWBUwl0+SQjy+GmEX98=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764300880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pg3FSIRtMXU5szl2eh5KeSgVoSezIgfBLftf2WmfQUc=;
	b=QhrfcA6pDSf0bo4YoeRT79ydQ53QC89g/CIrMokfCoD7Ni0ogqs0RjmIDElw2pO2dYzjVN
	Yc6WNcubMTP4lHDCQs1JwXc9gbLc6k1Xydi2bn+G8ta9MY+MkQf72ROF37IjbH/w0QHs9A
	7b++0F6IlUlrEpjVRga/CBq5JeL/4Ic=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-479-mu9y1m2TOWCTYfgb-eI-yg-1; Thu,
 27 Nov 2025 22:34:36 -0500
X-MC-Unique: mu9y1m2TOWCTYfgb-eI-yg-1
X-Mimecast-MFC-AGG-ID: mu9y1m2TOWCTYfgb-eI-yg_1764300874
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E7E61800359;
	Fri, 28 Nov 2025 03:34:34 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.7])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D8E4419560B0;
	Fri, 28 Nov 2025 03:34:26 +0000 (UTC)
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
	linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v4 07/12] arch/powerpc: don't initialize kasan if it's disabled
Date: Fri, 28 Nov 2025 11:33:15 +0800
Message-ID: <20251128033320.1349620-8-bhe@redhat.com>
In-Reply-To: <20251128033320.1349620-1-bhe@redhat.com>
References: <20251128033320.1349620-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Queue-Id: E561080002
X-Rspamd-Server: rspam02
X-Stat-Signature: 8kixx6ttb56irz3wka3gy7zmsp7qqzz5
X-Rspam-User: 
X-HE-Tag: 1764300880-595387
X-HE-Meta: U2FsdGVkX19xOqUbbmPyO5xOqGfkOrTVWTfizj0porrHSgA6daQcypGMw3YDvoLL3XulkTZN0KN+gsv8dJiIhNTTNUmMaJfANJik9aWfpKg/4BNntZPbfQxL27W7n590LLCK2DDJQDL/gzzjcjt353TgEprh/FZ2PUxIx+lMxh2q+OfAENZ2ZajvOkM97oxxmmfoT5gJbYMINAygc0fzslfYU540rkII7mCmnszZkFf01h860YQ2jbYEOzarqqEOuH3Ddx+WziYltzy8XS4nwmNW4oeoSUzjM070/4gk9r1KVftYesARLbLD5iJv7NlCwyPwmPDVYJeutAyr3x/x7b/BBtJa5n/gaeylCRnFE05uCDa87ETHwpX5tkPqChA6iJrIF5CIZvGrGcas9P4ZCssJ3/DTAQFisSFkZzfLQFM+ctZ3bfcWmU/F7GNEc532RB4GpO252Y9Gn7tMrTrmurYsIA5Kf/oELMG6+y8NgRYF5/wE4ws5c3KJARcgC5hIlyGIsg5GaVyfJJUBFfKGAkHDJXXdiibFNnVTHRA0NhADCVO3DrW9cv1gdLX7rd5aCeth1cFTy6RWuD2n5i7WcCjpSq76mO6LkKRPdZlvpYdp5CNMSBwpvqBLtAOmsMaDWI+EUTKnNRet7MHZZVolpOoP5cUWOp1kBUeAcvgR4P7P0K8G0eCeZZxQdxz6bzrAtF0uuw9OpFNWlnbzLs2xWbUE7FX0Dw5iKu8Lhoe9qRaJoldLavZwmX10zwU9Mn+taxA2c3PDCzzXyW12C8mjGXx5ypEFNgN8W+XkI6i/EIxcryN5tVxIPc5IZrSdonXeGyKb9VfuicZKAHA2YDQIh5NzU7yduUbGBrxKOxIiLRXEuESR28Et+mDXXFOwrrD6AVUvEJt4Kz+OIE12CrS1CYWmirVKHVCJSx8jQT5MB5TmRxhZAGUQJh+A13XVMJHECzdxY+/70PfpUhc3NYt
 TIRB3kyb
 aBEQA4/JJakdiVa9Nibv6zUZWslNw/IAcRbnLnG9B3rSwma+D5ZeVYrFBpjwwJ9oaIPQ/1H3SD7F2cUJhG38GeiplB/r52Brrgs5un6c1lLFTJz+0Tkpc1kFOpDqzvZpiewh6AkgqzScTU1FjAEUnA6GK5IBC3S5neV1iGvJKuVCTKs1w9/MuGEWVTnVkUKKUM6wCjwMj9t0RjOX2kyRmBpFoi1wU8uQQiKQPQr4JbOLfOMsXOCaH7W3qF3cp0wSIl78R8wxCq8XozHVdi4tbelpXFnMsmH6Pu44T14QOSZelvT+Z1tieupEF9TkhrIXjWpSX5Em/EMcRIjEiLX1qIwV4SYF2uoBcgMt0drd0WDJJUzxAquGnKSlEZ4hRkCSyiYcEykXhvvrMb8u5WrRR63ISqGRQQac3FLlfx+2XBY5IAP7yBIUBlzhhwlALoSBQsRSydQ+7FYnStZY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This includes 32bit, book3s/64 and book3e/64.

Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/mm/kasan/init_32.c        | 5 ++++-
 arch/powerpc/mm/kasan/init_book3e_64.c | 3 +++
 arch/powerpc/mm/kasan/init_book3s_64.c | 3 +++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/kasan/init_32.c b/arch/powerpc/mm/kasan/init_32.c
index 1d083597464f..b0651ff9d44d 100644
--- a/arch/powerpc/mm/kasan/init_32.c
+++ b/arch/powerpc/mm/kasan/init_32.c
@@ -141,6 +141,9 @@ void __init kasan_init(void)
 	u64 i;
 	int ret;
 
+	if (kasan_arg_disabled)
+		return;
+
 	for_each_mem_range(i, &base, &end) {
 		phys_addr_t top = min(end, total_lowmem);
 
@@ -170,7 +173,7 @@ void __init kasan_init(void)
 
 void __init kasan_late_init(void)
 {
-	if (IS_ENABLED(CONFIG_KASAN_VMALLOC))
+	if (IS_ENABLED(CONFIG_KASAN_VMALLOC) && kasan_enabled())
 		kasan_unmap_early_shadow_vmalloc();
 }
 
diff --git a/arch/powerpc/mm/kasan/init_book3e_64.c b/arch/powerpc/mm/kasan/init_book3e_64.c
index 0d3a73d6d4b0..f75c1e38a011 100644
--- a/arch/powerpc/mm/kasan/init_book3e_64.c
+++ b/arch/powerpc/mm/kasan/init_book3e_64.c
@@ -111,6 +111,9 @@ void __init kasan_init(void)
 	u64 i;
 	pte_t zero_pte = pfn_pte(virt_to_pfn(kasan_early_shadow_page), PAGE_KERNEL_RO);
 
+	if (kasan_arg_disabled)
+		return;
+
 	for_each_mem_range(i, &start, &end)
 		kasan_init_phys_region(phys_to_virt(start), phys_to_virt(end));
 
diff --git a/arch/powerpc/mm/kasan/init_book3s_64.c b/arch/powerpc/mm/kasan/init_book3s_64.c
index dcafa641804c..8c6940e835d4 100644
--- a/arch/powerpc/mm/kasan/init_book3s_64.c
+++ b/arch/powerpc/mm/kasan/init_book3s_64.c
@@ -54,6 +54,9 @@ void __init kasan_init(void)
 	u64 i;
 	pte_t zero_pte = pfn_pte(virt_to_pfn(kasan_early_shadow_page), PAGE_KERNEL);
 
+	if (kasan_arg_disabled)
+		return;
+
 	if (!early_radix_enabled()) {
 		pr_warn("KASAN not enabled as it requires radix!");
 		return;
-- 
2.41.0


