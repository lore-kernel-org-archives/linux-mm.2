Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14254CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 12:50:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C0818E0116; Tue, 12 Aug 2025 08:50:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 951918E00E5; Tue, 12 Aug 2025 08:50:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C3978E0116; Tue, 12 Aug 2025 08:50:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 627A28E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:50:24 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 05D4482277
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:50:24 +0000 (UTC)
X-FDA: 83768088768.10.F9DFBE6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3D4F5A000C
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:50:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HICRWSxA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755003022; a=rsa-sha256;
	cv=none;
	b=tyK2zwm6d4ajTi/iY3jt6AK4LS7exwvq1puzYEzQ64fqi1ypt9w9FjvrjZtsPJt0qn8DCM
	tS1w72pHf2a9qN/bf1ojOWgOWp6qpXQSYTOGeyjPDpmD6UvD4qO/UVMxPtcuEF7Q0GWY2K
	kRf/s8pcz1hp4ymgr9g737Hns9GJKHY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HICRWSxA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755003022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lC7gxKLfCffY1/zE+RJo3yBumyZwu5V9Ft7avRiVVTY=;
	b=n+gUWVHmCo6i9V8GfsOd9O0ieyVD/c0KtoH35ZlBRo2rYLeo7kFZRFAb4c2llEx0UzcPIN
	+34McpSJiyVgBShm1Tu2gFD9syIBRdpZbbDxMjN6rDWYBYi6W20T3Z+GulyKjT2kbVjNcl
	EHT0M8a5ynxKQ83TGR+pwUJKK+WtbjQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755003021;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lC7gxKLfCffY1/zE+RJo3yBumyZwu5V9Ft7avRiVVTY=;
	b=HICRWSxAerVbk3w6nQufi1Ml64ABpm7X6swIsjZsjKfXIfGMX6mUJ+V6/S7fwQ7EIEbTdN
	TVZyUb4iIXAcnVyy1G1Wpz2Ot0L+CLGFSK/LiKX6gjoBN6JDS3QMrWdnbmUi4k/z8m2JhH
	7cb1R4b0wVf0DGSpUf/THHc5+m09kc4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-121-Ahe-8VyWPdGdPbA0pY0ufQ-1; Tue,
 12 Aug 2025 08:50:17 -0400
X-MC-Unique: Ahe-8VyWPdGdPbA0pY0ufQ-1
X-Mimecast-MFC-AGG-ID: Ahe-8VyWPdGdPbA0pY0ufQ_1755003015
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F3E78195608E;
	Tue, 12 Aug 2025 12:50:14 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.156])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 173963001458;
	Tue, 12 Aug 2025 12:50:07 +0000 (UTC)
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
Subject: [PATCH v2 03/12] mm/kasan/sw_tags: don't initialize kasan if it's disabled
Date: Tue, 12 Aug 2025 20:49:32 +0800
Message-ID: <20250812124941.69508-4-bhe@redhat.com>
In-Reply-To: <20250812124941.69508-1-bhe@redhat.com>
References: <20250812124941.69508-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 3D4F5A000C
X-Stat-Signature: ws9qeghm7f6uy6779bs384hwd1t5nj94
X-HE-Tag: 1755003022-538955
X-HE-Meta: U2FsdGVkX1+Za8nyof5cAAMdYxBsGx52//nVLzDqlvAyG3Bj8M6aB8VYdr5JD7fetHIYPuwxq0L6PCRnQQIHwJw6xiAFWPXLSYRmwC6BeFp0QCT3R3waltbeVZWzPogC3F4W2TzivteGseHuuamsyShGa90ggCMpHAPOes0jCCmBPanwWcFdZSH7cZLTaYj0xj+HgmvmKZgE1sFdxFc3qGEvrSmG+0hheuH1ska8MSw4q0k982Aykl9VX3HDZ9vZ5GjR8FU9OtEkCso9x8JJeoz9kh0VjS5vecmSV5Nn0PhecQpDbFcTITskBUXAfsDLkjkvIDlDnC6s6arMb7jYrZGVvpmhh+qBwtWlP5LZbeOu+2EyotTfcX4IoD6puvqDIG1iamnVMAE3fjJXNLL/idU3q1UblnLwakk78SeEK69hfCoWjiJHZAP4+vEKhqshE+YA1l07/EPYwMHdoGfSF847C3bbE86b6NcectRolm2xrpqV4YqcqHk3Tch+nCTjD8S4yBOfrmwmY3oVKeC4R6lslwtuAIYY70B/MIeD3zxaElCwkD+cCF1EEQbZdzHxMtPPfxoDAMJdKN+jL5j40zeiyn3CqQq7wwx5hXQD4ykpT4mOV/IcqhWKDas86hAH1VXLvI39K+sCpZsk+v+OcomMEfZgY7P3un1CKdOWatK8Pll4GxUz3xEv5B5jod6g+zJM1W/cxi7ZGDAKl5EMh2TlYQwD1UisWmXOGMm+WOaqWu3qbw4R1ua4BVLBnUksQKiTIfUCjau87J58kS6j1QTvjPPLx1+z4gBKhqLMAuwjZacZUErJN/A7nfgJ64kLb1vZXgFhsssS9r+Q4pPFCSyUPoaVizq5HqTAM7yraFAvn2CIfcuHvAOaKDMUZ9RtaFfbfm/EP0xa++kOhHvTZFagnwHSYU7xR5L4jmJPDGFjMStZTg9rhQ6M5oZ8zjuvYIKA9sdtF9uhEE4CJlx
 7cWd5gh+
 Zv8W2U3OJ1a7aaoDYOBspeZGtPZiBucbm9/WVechdDzwvEJaUs+jhuTEa81Sw/1Ridw/6YktoQtH9cn8molOfKpOd2rUMgDGkqyqMB8UhXu6PLqnZX8s2ID2byyGnzcwirc20oir521g7b2jEG+Ejic2eqIRosgeemMDREPOQtFhFxQ8MU8sLHPwFS087T+yvRIb91JPbegv+DSvOKHb+VvxCi/8iBxyEmgD4eQopjY1PAeuJbZkgJbbFgjjPGC1zzVGhPpyqlgFtiQM3gjlTipmwgtgUS1qUmgJAVJTat7XPyHZed9M/IKeoqqhQVLPamqNo5X2lT6cEZSwZg7v+8zQY5dD4+fogelCYjn23j00OHSZmwIrUlsGPN8VDujfb0nRYUCsKcpzT3WhivfMAG70M5mPsnbtMmDxDZSbmoG7K/P/s1i5lM4MltXWIn3CAub9pbRTHKbL1/lg=
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


