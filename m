Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54CE2CD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 06:26:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BB7E6B0005; Wed, 20 May 2026 02:26:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 993866B0088; Wed, 20 May 2026 02:26:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D0596B008C; Wed, 20 May 2026 02:26:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 79BD86B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:26:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 10B671C0067
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:26:53 +0000 (UTC)
X-FDA: 84786815106.14.09DD6ED
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf21.hostedemail.com (Postfix) with ESMTP id 652511C000D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:26:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf21.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779258411; a=rsa-sha256;
	cv=none;
	b=tZqahY9eGbx4OtJsg+muHWLZD7GiI4O3QRTCphu/ClqSvJsc6wCWiFD9hCj+W03TYvxcD6
	EOecI0lqxrh+1Ry16rh6h9eDbYWpQLOrKFvSHgGfTV0MxoltA5s9na2JIYpI56z0DGevic
	dGkdUO36PYI7Fjm9+YEh+f7IfdnmpSQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf21.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779258411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2m4i5+AR6XFU8iTqGEs3ueJBFSU4ChElsWI8oEvD9gg=;
	b=eCwAdtvmRGEJb5u1xDx3GWLslYgckvvM5gX966ZsnywhrKVcLbbffeYcUaxUTImUKTdj/B
	5G+gmYKNGoC8UmZRm9PjFHDZZdQAVHTSHlPb4k7sG09TszDboqi7smDpo/uuYEj2D7K/lP
	PP1r0RMDnhaiDXBN6wOFRR1HYAY+O+8=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gL1ln4rpVz8Xrrd;
	Wed, 20 May 2026 14:26:45 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 64K6Qdxd006094;
	Wed, 20 May 2026 14:26:39 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 20 May 2026 14:26:41 +0800 (CST)
X-Zmail-TransId: 2afc6a0d542145f-ee5e7
X-Mailer: Zmail v1.0
Message-ID: <20260520142641245K2bbRXvUcRR_Q3Gdbygi9@zte.com.cn>
In-Reply-To: <20260519100156.05043f9d043889a5f60e22d3@linux-foundation.org>
References: 20260519220536792dMIKRMurt3vZ5lXC5pwh8@zte.com.cn,20260519100156.05043f9d043889a5f60e22d3@linux-foundation.org
Date: Wed, 20 May 2026 14:26:41 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>
Cc: <david@kernel.org>, <ljs@kernel.org>, <hughd@google.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <michel@lespinasse.org>, <corbet@lwn.net>, <wang.yaxin@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2NSAwLzVdIEtTTTogcGVyZm9ybWFuY2Ugb3B0aW1pemF0aW9ucyBmb3Igcm1hcF93YWxrX2tzbQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 64K6Qdxd006094
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Wed, 20 May 2026 14:26:45 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A0D5425.000/4gL1ln4rpVz8Xrrd
X-Stat-Signature: tcgf7oos6pkndqx4kecoufu1imbe6e5g
X-Rspam-User: 
X-Rspamd-Queue-Id: 652511C000D
X-Rspamd-Server: rspam07
X-HE-Tag: 1779258410-16661
X-HE-Meta: U2FsdGVkX1/okqByneyYa/rFk2XYn6HSEj+aYHcvh/zK1pQywklGZWfy1DI3X2SbW2BexlzfBmuql9vX+Zq06uE9Guv7a98CE7uwMVUtNC9IshQd8tf0xZ0b8gAE1uFBuNui2leCIO2ybR+8s/f71h+o0alXQHfSC5cfpS/hWPUjyyv/HTjbwSYoiCk5E96sqBYAITl0XXJU/a2mseWE7epNGvt1AItjixmJe6UCfuUMhX3rUDvQPRIosE09T/6F0qbS7Q/nSh21Ve0wsdnaxUhtnOabs2iVv6i0r6hLHjQc3OSJi3R4E5kPbmGAfCv/MJEKUop8heO2jgXY3O2Fx3WQmSBKDK1Gq9khKIOJmt3vdP08w3CxNG/Fv7AOhLH3GU0+5eK2qnH+TLawqaj240hdzRFH+mRJYIK0n9k1F8s6ZKt17vSZsZ1j607nUG68hbIaosobiWxlRr0sKLz2tEdVi08IfbEDrUnuC8OX/nOIOtfkI6lS/xahGounGzH7K+NiL5QKb817nHzehj3Tqh5lRMpuf5ThjZ5pKxKxD6N8W2Kb7q/+MSlUYFjMjou3cP2KX3019S866ZvkGUl0he2DceNtlBLn2CYv1MD3vr2w3cNjFURRtP1EpVnI0/XcKoe6I2jrarYFTBccX8fxNc8fR2/ukYpUSXJ69HXCLXtKT8OWDDNtDHaunBu4fES42cavoEuOXfogmGPxc0ddEMMheCWMmfclAhi1N240gnQPvJUpjtWEn6//YMxzWK8Zro6QvpOreyPqrGJ2WtCuYIv++VbWQ9ZxbgIcVKko17UNoopzIeQhpsBU1rlf3ENGvdOV+/pGRUeu4lnj015IASfqMkRRD53zoIxGcO05mFw5KZwiHoTsBGyIK2u5tLuWGZlOhpDU+C1ziz3ARxNvcuDBddY83lEvHW0qalv5ztX+PdgGmQ2yt8VJakrwHXAAmvmuE7at2eLmqsY2jRR
 QMbawjOb
 xvRspNFwKwAeNsYbOCoCtJwPSxxCIXrjcayUxQvx/ptoyVRmflT3R085ZwO/sxyMRwIJ7BciPZQFDT/L8cmsxihO5KDfULtZUHNJLrimUyuYF5MjUyTA9ipjP1albPnD8RpwB0/5FQM3PZeOTkcHp5yTOy4Pg28vFg0VhoCQOFgRn62hQetCcuD16wbXvQ4qkM6YtVRLdS/wOjg9dMPWZo0+U0SMplS11BkQ9ZfXvStFHoGWg7Q7W+r/bHP0eCsxFOB61KiCYSUu/ohdwna6EsLMh2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Two key highlights:
> > 
> > 1. Lock hold time drops from >500ms to <2ms
> >    - In our benchmark (20,000 VMAs sharing an anon_vma), worst-case
> >      anon_vma lock hold time during KSM rmap walk went from 705ms
> >      down to 1.67ms (max) and 1.44ms (avg).
> 
> How real-worldish is that benchmark?
> 
> How much effect are our users likely to see from this patchset in their
> real-world workloads?

Hi Andrew,

Thank you for your thoughtful question.

The benchmark intentionally simulates a scenario where many VMAs share the
same anon_vma without any fork() involved. This happens in real systems
when applications repeatedly split existing VMAs via mprotect(2) or
madvise(2) (e.g., MADV_DONTNEED, MADV_FREE) on sub‑ranges of a large
anonymous mapping.

Real-world examples:

 - JVM / Go runtime: These use mmap for heap regions and later call
mprotect(PROT_NONE) for garbage collection barriers or guard pages,
splitting the original VMA into thousands of small pieces over time.

 - Database engines (MySQL, PostgreSQL): Large shared memory buffers
or anonymous mappings are managed with madvise(MADV_DONTNEED) to release
specific pages, which also splits VMAs.

* Why the benchmark numbers are realistic: We observed ~20,000 VMAs sharing
one anon_vma on a production system running a Java application with KSM
enabled. The lock hold time before the patch was measured at 228 ms (max)
during rmap walks triggered by memory compaction and page migration.
The benchmark reproduces that VMA count and lock‑hold behavior in a
controlled environment.

For systems that do not have thousands of VMAs per anon_vma, the
patch adds negligible overhead (a single pgoff comparison). For systems
that do suffer from this issue, the improvement is dramatic:
1) Worst‑case anon_vma lock hold time drops from hundreds of milliseconds
to under 2 ms.2)This directly reduces blocking of parallel operations that
need the same lock – page faults, reclaim, migration, compaction, mlock, and
exit_mmap.

End‑users will see lower tail latency (fewer application stalls),
higher throughput under memory pressure, and no more spurious
lockup warnings or container timeouts caused by excessive lock hold
times.

In short: workloads that do not hit this pathological pattern are
unaffected; those that do will see a 100x to 500x reduction in lock
hold times, which translates directly into a more responsive system.

I hope this clarifies the real‑world relevance. Thank you for pushing
us to make the changelog clearer.

Best regards,
xu xi

