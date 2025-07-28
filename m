Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57D92C83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 19:03:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D50D76B0089; Mon, 28 Jul 2025 15:03:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDAF06B008C; Mon, 28 Jul 2025 15:03:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC9516B0092; Mon, 28 Jul 2025 15:03:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A7FF86B0089
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 15:03:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 21A951A03CC
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 19:03:22 +0000 (UTC)
X-FDA: 83714596644.20.7ECFE48
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 652831C0012
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 19:03:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DXODDJhN;
	spf=pass (imf21.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753729400; a=rsa-sha256;
	cv=none;
	b=PwlIicRbm5kBRT5Y/lfC4LYZPTE8vELIGS2zSEwVX5/6o6J6bXFRD6yUvR+ITNubv6d+GP
	6gHI+k6N7BMd0dauAjmxpJhB90jKHdP9R4V/xjWgEFTGCgNYki+3zwot3Ky6p3iTP8l3Wq
	C5CwplGwpDhc9TKqqCvfG6YkKVl6L2o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DXODDJhN;
	spf=pass (imf21.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753729400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=o8KYtns/52WNChA2OdVFuhj45qhIjxevu6bRzkjJVdU=;
	b=VWLnsRRtrxMXxg7I1DsP7emXMZ5ICf1j5YvX0sFAm8PiMPt0f68ADsDtv0E4gDoe/gZh34
	q5StxN0b9LJ2h6LNCUXB8mPvfeH6A53fi5wj8ToVIhHJZCP7FuYMOrc1U5b8FS6luI/FnV
	hOjLOJpRLHmLVVPPalBH7AEk0uaBm9I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753729399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=o8KYtns/52WNChA2OdVFuhj45qhIjxevu6bRzkjJVdU=;
	b=DXODDJhNe7x0mIPtqvUAChoHKMzghG4WuIXQnnvRYI2ZX/VpvSLeuku0mivw99lTMluXBb
	RCFaczfuvXGwxkFZ+8HcetY7TfuPb02BDdUTXwnzTYuPJ8GkOPUd4WfXNCHpyweMgz1R5h
	v0+dav9ANxpry4ueKuXQ6A5PI2HniBM=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-530-x4zQ7z2HNrONl-LZxjCPUQ-1; Mon,
 28 Jul 2025 15:03:15 -0400
X-MC-Unique: x4zQ7z2HNrONl-LZxjCPUQ-1
X-Mimecast-MFC-AGG-ID: x4zQ7z2HNrONl-LZxjCPUQ_1753729394
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7A292195609E;
	Mon, 28 Jul 2025 19:03:13 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.81.41])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 14EBF1955F16;
	Mon, 28 Jul 2025 19:03:11 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Waiman Long <longman@redhat.com>
Subject: [PATCH] mm/kmemleak: Avoid soft lockup in __kmemleak_do_cleanup()
Date: Mon, 28 Jul 2025 15:02:48 -0400
Message-ID: <20250728190248.605750-1-longman@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 652831C0012
X-Stat-Signature: rjzib9cfg8ayq7gxmnagtsuawa4gyb61
X-HE-Tag: 1753729400-671148
X-HE-Meta: U2FsdGVkX1+XyIZB/XQZ7I7vwlRXsF7xIA9FGk3q0oKLqFEaLNmDwFD2QISiuIawEPO+bQSRLdzllYqJYJF7PWnAZXXlbQjHK6D35wfxUmbKkkJcRuUZGHg348MHox8HlV3l9nzEmJCowL0/xj80eRzysQLfNN+dhHkEXkKhrW4Faf4Q4LQuALjNzY/uehQw8Ed1G0IyQwYLj+hVASE9I7xe+9/ErOknywEn8EoYNxZN+2vWDwQxI/u13gv6JHjJeqQI4tD0k8GbwrlEwCsBRhHimstyQ19BCo11n4msCOZrS2MPYw1QwQ3AfcB1JHmdLjO1dWqDGC2KNRvb4Ttf+RDq8L22mmLOxJbwGVlHlsB29OohfgN5RFKxt2sU0yxl+mz3rajx+2OCzjssnFo9q4jYrGcnrGTAxH3PGijQlorfN4YyDULcr07HLZZRms6dOLx8lO0g2NI5Fx+Zr357vLyYhnhnsMb1Cl+k+rKjblEdlosPuCRk3DZ34VOyXhhuSnqNrD4UuseBBObFnFJKXQJ94bzdyrDiB/aPkMrOqSInR4TyloEpw1PjFivllNdUu12zLKaxFCqKtQ0SS1rRfe9vtbdfUSw3kUNWlV34kNl/rXv8nWKsqxXojsI33Glg1GNN6A1nEB5d5U1AP6ag3ZJpY9OsO8QWUoppFXwOzPv7ZU4olJGPmlJVa9el1K+zflYI/9AwBta7sFMofVooOSLFZ89uCbnzv1NA+g1quHxZWATF393mGln6L/hZYkeNSxggXbBu9DptwgU7ufJnePMgJf1jDh2TVgTrNxKeY4f7Rkuurj2e48waxk0xmfg6ktCw/XOixsF9YHQA+GUgWPoD+5lhbC9V8WfdXCNF3cQI6UKSZUrK8XvZg6BuoJiaoTnFUEU5MCHPEV1fu9qljW2hMofxJLd/xxgvEBkT6DWuOLjbfjwvcPvKNWZP9BLrF8w3KEmkAFZaZq7dikH
 zYvWqMcb
 0cK2L4wr0mAVKd68P+LMNemVsgS/Ny7bwSd+R4zQgNBOojUdOqelc7HTuZbwqv57IYuwwIkzkfwviiMG4TagB8+4qcOR2fdM8duVHWJFGpGhLGVi+8NFzRN0ZiiMOVyxi7RGq9FBHzx3CU72Q/AG8KfdmJ2mxq+lHvAJTRFqJbU5vmHMejEMRma+DQ2xvJ79TRKh9iJa2fjvWdz7WsOcrXFzIFWQRWpcUJOtEhskw97tgjVSpAm3pZIBMQHn7yP8sjd1gvrLV5Q/klvztPZx4P/XZPtIxkUBOGT4WYhX+eo35dy0m2+AmPTl1kmWQYE/T7WF89nuS3JNi1YVuwbADgrsOODB8MztZu0lqWIANtK70Ky5/zI9tg7WtsA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A soft lockup warning was observed on a relative small system x86-64
system with 16 GB of memory when running a debug kernel with kmemleak
enabled.

  watchdog: BUG: soft lockup - CPU#8 stuck for 33s! [kworker/8:1:134]

The test system was running a workload with hot unplug happening
in parallel. Then kemleak decided to disable itself due to its
inability to allocate more kmemleak objects. The debug kernel has its
CONFIG_DEBUG_KMEMLEAK_MEM_POOL_SIZE set to 40,000.

The soft lockup happened in kmemleak_do_cleanup() when the existing
kmemleak objects were being removed and deleted one-by-one in a loop
via a workqueue. In this particular case, there are at least 40,000
objects that need to be processed and given the slowness of a debug
kernel and the fact that a raw_spinlock has to be acquired and released
in __delete_object(), it could take a while to properly handle all
these objects.

As kmemleak has been disabled in this case, the object removal and
deletion process can be further optimized as locking isn't really
needed. However, it is probably not worth the effort to optimize for
such an edge case that should rarely happen. So the simple solution is
to call cond_resched() at periodic interval in the iteration loop to
avoid soft lockup.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 mm/kmemleak.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 8d588e685311..620abd95e680 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -2181,6 +2181,7 @@ static const struct file_operations kmemleak_fops = {
 static void __kmemleak_do_cleanup(void)
 {
 	struct kmemleak_object *object, *tmp;
+	unsigned int cnt = 0;
 
 	/*
 	 * Kmemleak has already been disabled, no need for RCU list traversal
@@ -2189,6 +2190,10 @@ static void __kmemleak_do_cleanup(void)
 	list_for_each_entry_safe(object, tmp, &object_list, object_list) {
 		__remove_object(object);
 		__delete_object(object);
+
+		/* Call cond_resched() once per 64 iterations to avoid soft lockup */
+		if (!(++cnt & 0x3f))
+			cond_resched();
 	}
 }
 
-- 
2.50.0


