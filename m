Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5546CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 12:50:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 777888E0119; Tue, 12 Aug 2025 08:50:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7291A8E00E5; Tue, 12 Aug 2025 08:50:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 616BE8E0119; Tue, 12 Aug 2025 08:50:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4ED4B8E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:50:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D2D0B1DBF03
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:50:39 +0000 (UTC)
X-FDA: 83768089398.25.914AB98
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 19A834000F
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:50:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jPQXWaKl;
	spf=pass (imf12.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755003038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rmch9LxILHmDSZgEKLxWACfFjV5jmswbcfLkcrWwQo8=;
	b=DmuHwWz5ogUFR2shtOHF6apvFXrnH+gx5zn0Vv5w1qaETRiENlyNB86eZvSqlgZTLxADPH
	2g4+bmetGvt943qiFEtfbhLBog2Ymt17T14OKUG2/Bm2Qgv2Iz6MheAhrQlW7py1VYBMRl
	CXnug9cWNeV04BUtgm2TaUgFXfB/nPs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jPQXWaKl;
	spf=pass (imf12.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755003038; a=rsa-sha256;
	cv=none;
	b=OJ4NSU7lAjMfVVW60C13kXS9Af3Arc3N6EUHGCtr2mHo0o3CMjkmw6gIU/+/iMpjFjDBID
	UeO+qBKEej3MKHIvcKCejLdnNx/cC+UR6j3fqnKbh439VhLj3d/AcMiTFjpB4bw1Cj8sPk
	juHNuVNOMAWnT5JkOMg4aHd6Cd8kxR0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755003037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rmch9LxILHmDSZgEKLxWACfFjV5jmswbcfLkcrWwQo8=;
	b=jPQXWaKlsYJ73r/IaUWGLo05glYiekfRv3CKFh5TwkXxA8PzsCS21J+Lq6tAYGjRjoJm3q
	QWL2jQ6A0aPt/RQ0mjAS4rNiMDpvfe6tQDun1l9qLJtoFC2oMv9RENlVtRUFExkSJl4ZgV
	1OIJfuQqBHcPtSZHBJ+IswBzuO/YgyI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-57-v2GUSWdCNJ2cbTTT3izsjQ-1; Tue,
 12 Aug 2025 08:50:34 -0400
X-MC-Unique: v2GUSWdCNJ2cbTTT3izsjQ-1
X-Mimecast-MFC-AGG-ID: v2GUSWdCNJ2cbTTT3izsjQ_1755003030
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0D25E19560B5;
	Tue, 12 Aug 2025 12:50:30 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.156])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D92EC3001458;
	Tue, 12 Aug 2025 12:50:22 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
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
	Baoquan He <bhe@redhat.com>
Subject: [PATCH v2 05/12] arch/arm64: don't initialize kasan if it's disabled
Date: Tue, 12 Aug 2025 20:49:34 +0800
Message-ID: <20250812124941.69508-6-bhe@redhat.com>
In-Reply-To: <20250812124941.69508-1-bhe@redhat.com>
References: <20250812124941.69508-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspam-User: 
X-Rspamd-Queue-Id: 19A834000F
X-Rspamd-Server: rspam06
X-Stat-Signature: nr4tbbstrna8ekf13zqucr67c8kk1j6m
X-HE-Tag: 1755003037-506642
X-HE-Meta: U2FsdGVkX184TWqsVDYUrDpJQKgltLqozJo33Ww2787yYoSHoZC8bx4nIrxr1YvLXKiGp8YrzSVAglE7dqEijmhNFaAwZVKqyU/AzLoqG3IaW7dqJ/OiLQ4T9M1a+pwcQw22hegPcruq8blCoPYXowybAZ9g70apLXDLjZwkOvy4NMBG1OeCPR7kD7Ce/iidRmVAWY+OqYvjx5aCTKpYL1tWCblvZAYSEiame/RBqgERhWYO8rLqtSv5bwZIQYVsl1/i1rmJ6qPrygamtnOkJD9yeEBvg75aAep6L1q0T9RU4uFzR3LVe/XsBms0MIuCWWFHPIbyWlzA8hpym5ZHCIyemzjO0nVcBeiertDl8x5+cPsoLpYNHcUsho/Bvw/0b/EigZOHDp3bUnOFPlxUpWmc8u3zfqlEeP+sm6Asyd7SbVbSYDwW8lk6yHACE4uNKHotkRM+Td7VBZ1js/csFI2qfv/EMf+w1/XBAYofxrZ6F/oMH/pnCPHmSBNyxseL1KBOQw/vY+lmuENxXkFlRmn7xagE6HX7hPDBd16HgqJphAdbZeuglvnDpoPWe6cSExn9j/WaX71qmiUuho+S7gY9kwDr4VIr5V+pfysNVBhtk3FRMDzW8xb7LMy3ESSzRM27JUPnsrvYfpKCg79y/sm7eiFqD8YlUh5baGb8iruYXNnYoONOTPUEXzS7AmFjzM01zo13T/0eMwvjF8issRDBtUo1A/yyujC30cQ9apEFC5ql9z/vcDp5uYfDr+tFzGCh+28asdsU0n5AEiP+IMvGm+di65OKd1C32+6THh76Bv67Qt3x6UQ3D3jqQUBQKP4iEeynB/FhZkTQ39nzWgqbSeiuhzGCnBn0WWTqamzP9lI9hC5Hsnim26dK1RPCjv8a+KDxMdA9RubH1ID94AljVX6f4gu9AWCkJNIq+fufKhUIr1xn2hxTqJ2+93QHXWOsmMqHl1EgscaM2of
 rAQYzFMN
 c3vd34lLHR6U2N+xhuTES0kyE2VpSJKQdEjZMQCW8WyWeJHhovXEbG8ZbIUEWUw9jZIpYSzIhXd+CxIE6cKdeBggwWTKwPEIddfsXJonBs8Rptg/Wv7TYKT159L4vjombHnPLovtkQdCFpZF6fUn/WeUYisAgC4OuYVT5ivMMMATIMs/L0sKErGYl/RmsFlLaSLTFhMYQaEmYJIeVID5eYPeEFlT7m8pWUmzqzJ+oJ+sWtz3xkuDDS5abujlMRaDyJ9CznmKOIjzlNu00PpdBAV/O5ajS57wBydVAj1chnriNJtWusge1XmiWxVCArfwif2wZbXjrFpPGM8HM1irJo7YWidaDcw/Vd+XIomyY+wr9Q+54S1G0fu3BZwqvpLVRmbBMgcLsU3hZXJlSkYBLNdwNqA==
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


