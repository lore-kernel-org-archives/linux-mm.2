Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51273CCD1AB
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 08:43:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 565278E005E; Fri, 24 Oct 2025 04:43:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 515DE8E0042; Fri, 24 Oct 2025 04:43:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36CF78E005E; Fri, 24 Oct 2025 04:43:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 032C28E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 04:43:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A370C12A072
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:43:17 +0000 (UTC)
X-FDA: 84032368434.01.E0CC3CC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 61B7D140005
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:43:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KODEM8nJ;
	spf=pass (imf23.hostedemail.com: domain of amarkuze@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=amarkuze@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761295395; a=rsa-sha256;
	cv=none;
	b=BojIW+yv02eXmvzQwOO+ZotFtH002BzSzjnOBeiVXAUBwp8vmzuay4I3uLU58e+wbbQ93q
	KI2MaXP16jacbI50D1XZJDEnA3IRCWnVGqJ7dCamAgsCYHCWVOrkPAiqGVTg+PnuB1VGWh
	Jv4fKlasv+JMI+gmmK2Lmunb+MjksIs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KODEM8nJ;
	spf=pass (imf23.hostedemail.com: domain of amarkuze@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=amarkuze@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761295395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G2mVM+FZvknTGaq+hz6VSPwugdEKaAfrXhCpssczAec=;
	b=L0Wz4cVs37yiHfj2/euq5CWWfdGZIhI+hsk4xPD8VwTveIc0t5rlR/5N++Wtn3Hf1nRKKz
	EMAqsrchr0uYzxWD5EfauKQJnbkPB1rt7XscbNcg/ltBGGKO7TyMdlODv2k1faU/7ecN/2
	KkFosGwziKnzmabdCOxPjfX8GJzK2aw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761295394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G2mVM+FZvknTGaq+hz6VSPwugdEKaAfrXhCpssczAec=;
	b=KODEM8nJ/X27CE80SGLOCfqSH47vM4ph0cQzpWwXCAvlHpGIk1RZSGESlcMSYUXnjPPHQn
	b1JjwvQ14sgvcYzjEXoCjp4Zjx0fv0u8I5siXoQdpmmTqKV7070LFcSHTinRCRMsqyJd5f
	FQLPMwE/2vpBf4VZ8GCkrbsoEeuVMPc=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-97-hcxM4C8eN4a9d6c1RghAnQ-1; Fri, 24 Oct 2025 04:43:13 -0400
X-MC-Unique: hcxM4C8eN4a9d6c1RghAnQ-1
X-Mimecast-MFC-AGG-ID: hcxM4C8eN4a9d6c1RghAnQ_1761295392
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-b6d700a0894so98213066b.0
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 01:43:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761295392; x=1761900192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G2mVM+FZvknTGaq+hz6VSPwugdEKaAfrXhCpssczAec=;
        b=fxBOhqs+rQrlLspQuqXRWt+eCDK05tm5aFJJh6dlWribY6ivARpg3lr7TSIjjlpm78
         TT0S213w9B+FEpuPPkf0U+e6jahv5GBYpiO52GKDsb50BN6ZJZUaePeP0uhaJy1P/sB2
         rW2tAZcW1XWfdVGxvkZyNg/+WkBRuBQE8l6wv2Niz8+UWyO+nWccl98nCiTlLEIw1Owy
         xIKlGH73FzoEkLc8hWF0R/wm73qoHd+k33XUM3ZMt84Mbj/Y4gOYI9sloA2RFZRVU+r6
         VhCMzTfg02rjdAMdkSk+uMJpG+/buUJFXCDnB0/NiVaKBfbpPBjzpUgvhhARnlmJ76Fr
         CoeQ==
X-Forwarded-Encrypted: i=1; AJvYcCVawskUrcTRktGWd6qZ0O+OQMkLDeKmwDGr6RRiArc1rwE9uOmqHLu7abFFC/U2IurM/1Dn1bjmBw==@kvack.org
X-Gm-Message-State: AOJu0YwRnEdQdn20r3YuooTbBTsbPvOMyrf3RF1S6S85UlP8iX0RVuj4
	Ix/SJhaeTWkgQembag3A5Pxo/qPncAjdjVyNcAJaJZFCYMZNsMstemL6BB82dlfAVXl30r12Czp
	ySXEpqnGJXPrOaAT5k9jgOWUw+K5rIcaBVZ/5NRhqG48Po4Mx12Ij
X-Gm-Gg: ASbGnctPFfcz5MkgkH+6HISK+Uhij5sXVp0N1CT1r9m1m7wYCDFSVDZc00bl8gYs3NR
	B232Yw6lexDo2kY/7vGgNYQYP+W+ehV7EHIkp6jeS2qX9HKti5+Be6OGaF/fDO1rItNtcvwqY4p
	rXcdD1VC1T9ymCekptB2Lzmy5ny5U1fcFMoBMdeZxEIRdZSTz4TmcPIxfbGovApY6cwQLKJt0CT
	6pQxqtdUa8UuJ9+bILAISUoeMiyDVPEYwK/NISdvpBpKPP5wRWa6CcowXMwbu8FpKEXPr4TVf3s
	Cb2Yc+TUdetHyrVAjaG//qYASnqArpcggNPxFfpTjLJQLTEKt2OcqFaPTkwUDHlEoy0QQvA31gt
	Pp3r2qh5tWYQUgXuFOIHn0V+izCJ4bsQj
X-Received: by 2002:a17:907:1c85:b0:b46:7e8c:c0e3 with SMTP id a640c23a62f3a-b6d6bb533f0mr227697366b.20.1761295392041;
        Fri, 24 Oct 2025 01:43:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEUhN3/9Ay6vxjiqFD8NjT6jaMrJJNSP5ARNhpCmGSoKcrjb4HW3vxJJXustlTOWkwKXslKQg==
X-Received: by 2002:a17:907:1c85:b0:b46:7e8c:c0e3 with SMTP id a640c23a62f3a-b6d6bb533f0mr227693366b.20.1761295391573;
        Fri, 24 Oct 2025 01:43:11 -0700 (PDT)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d511d010asm469226866b.11.2025.10.24.01.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 01:43:11 -0700 (PDT)
From: Alex Markuze <amarkuze@redhat.com>
To: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Liam.Howlett@oracle.com,
	amarkuze@redhat.com,
	akpm@linux-foundation.org,
	bsegall@google.com,
	david@redhat.com,
	dietmar.eggemann@arm.com,
	idryomov@gmail.com,
	mingo@redhat.com,
	juri.lelli@redhat.com,
	kees@kernel.org,
	lorenzo.stoakes@oracle.com,
	mgorman@suse.de,
	mhocko@suse.com,
	rppt@kernel.org,
	peterz@infradead.org,
	rostedt@goodmis.org,
	surenb@google.com,
	vschneid@redhat.com,
	vincent.guittot@linaro.org,
	vbabka@suse.cz,
	xiubli@redhat.com,
	Slava.Dubeyko@ibm.com
Subject: [RFC PATCH 1/5] sched, fork: Wire BLOG contexts into task lifecycle
Date: Fri, 24 Oct 2025 08:42:55 +0000
Message-Id: <20251024084259.2359693-2-amarkuze@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251024084259.2359693-1-amarkuze@redhat.com>
References: <20251024084259.2359693-1-amarkuze@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 430BIR5uQNPAjHUFtHNbc3Am9K7PZIjDMapssOplxA4_1761295392
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Stat-Signature: asuiuz53cynyqrhj8uetr5jt5iprqz91
X-Rspamd-Queue-Id: 61B7D140005
X-Rspamd-Server: rspam09
X-HE-Tag: 1761295395-986557
X-HE-Meta: U2FsdGVkX19ZbnupEdqMsIqbcIgjnLNoM++PxH61APe2rSqZBVy72CurSHBWt9wJrhIZXX1ZMULcwCEJevekGn2GYviJ/UdTh/wvQBgK4FX4kotfhhbLGrbsWGpAK3Zfi4dA1bKl1hxt/12df/t2Skrv9HRU58TA7JmfCHORZ6xTo+fSZzowjSuTjQZveSUb10eL9ziMilwpIBP0TzG1tJu7NG0MT1HX51MN1DSUGzlAcj+zou5BQL1I2Dn/QcoRRhpNcl54pURoT44UgjpLK2lxs3Z90DzOFRRjYgGXCV5XGtG0teBy9uQU2etdw+nUFk+5/8nQYyWdxFUlyxE6kinChmCUJBRNnoSA4Jwccvt2sirrhNbVAN4Gl2nKEU9q+QFMyc0xdWkWqE3LXfwFUmAB9SaylgP8D0htMN00tR5lnsMY89CHZpu8fgjHy/VCnEg6BHwhjUAjfqDtM02nx9stlY91Le1dXfRD5i5B74/B5uuVvXz83VaDa168jVOB2U8VTZmmwonHb+PgNjLVMYnX6okX7zqWShRE7niMYGasFzm7CzwgXHIkk6nGBS+gDHCsXHBEcx1+Sg5c+1xLiuwyyv3ec/bi4HSLKKzvxXvF8gcPchJY84TeLVqXjlR4Fr8CFyl0wy3nryQPZlNVkGVdYVeQZN5QR0B+kKu48FfLkqNWyv7KhXEeAYCR5P+KI+jJhCpps4sihHRNCDdyrKQlgXRgz0xpbWm4ASumz3D5hD8PAhajgYe8gmRbMEYKY70WU93uiFpngW/imyNqtBRKeC/0YpdJX+JgqJc1r/i5USY2mlfkqWtIawWU3G+prV1cg2nlDGGKl7oO/pzVMWIqCD7RFiaFdx/u9YGisyfEqf6ESU7hNIfNKr8sY9p1YuH1AB6tujGf1m0uMIDoDl3NuSl9BVNxSn65fXEK2juzHs0Iy+JvXqagZ1H6iHX7HbxHXT6A+c5jLBh0iZH
 fpNs4Y8L
 rzpO5anVPa8j5LSkrKkEXgImh1e7yejLq/e4gifw/zNWGAnQCqgiybx1lW0ovVWwaewranlLBU3mLWVzEyP5rVVHmB/owdYXgd+B+LeLA3ayctENWlJRZRdRQAiyoh7g7DJ4aIQI0dWYGgvaeNQVkmRThkWeeiTfgGz9ez6nT71QNJXBJqElKilRpuQSdpbKUOCE2ZEaSBYYTvwPW23Cqrd72/G3hNO7F8KmPxcmcVh2SJa5yfASUtCQgdTTXn3mOCWTsCbET3JvIup2YKV+7jD28wxwE1yjJFN/SRLvDRz7qOAcEzrGNqebVpWS223Z5JxoHImW1uT8P7paBwJYUVOB9ScFbLNSg6Q3S0KXqtbtuFZjEFGLr+L50/hwGQEf8ZlNY0oSqWUbrA9285b2Zduz60hhCRwT+6N+64GJ5riScxExZLJdcpk7I47LDBT2YxG1lfPgCmRZtJt4lQy9Y4tHn7g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend struct task_struct with a blog_contexts array to hold per-module
BLOG TLS pointers. Each task may have up to BLOG_MAX_MODULES (currently 8)
distinct logging contexts, allowing multiple subsystems to attach binary
loggers without interference.

The fork path (copy_process) initializes blog_contexts to NULL for new
tasks, ensuring clean initial state. The exit path (do_exit) calls
blog_tls_clear_task() to release any active contexts before task teardown,
ensuring contexts are properly recycled to the magazine pool and preventing
use-after-free scenarios.

These changes are conditional on CONFIG_BLOG. Kernels built without BLOG
support incur no storage or runtime overhead in task_struct.

This commit establishes the foundation for per-task binary logging contexts
but does not activate any logging functionality. The BLOG subsystem itself
is introduced in subsequent commits.

Signed-off-by: Alex Markuze <amarkuze@redhat.com>
---
 include/linux/sched.h |  7 +++++++
 kernel/fork.c         | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 07576479c0ed..e381f8421a11 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1278,6 +1278,13 @@ struct task_struct {
 	/* Journalling filesystem info: */
 	void				*journal_info;
 
+/* BLOG support - max modules defined here for use by other headers */
+#define BLOG_MAX_MODULES 8
+
+#ifdef CONFIG_BLOG
+	struct blog_tls_ctx		*blog_contexts[BLOG_MAX_MODULES];
+#endif
+
 	/* Stacked block device info: */
 	struct bio_list			*bio_list;
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 3da0f08615a9..b06843af05a9 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -24,6 +24,9 @@
 #include <linux/sched/cputime.h>
 #include <linux/sched/ext.h>
 #include <linux/seq_file.h>
+#ifdef CONFIG_BLOG
+#include <linux/blog/blog.h>
+#endif
 #include <linux/rtmutex.h>
 #include <linux/init.h>
 #include <linux/unistd.h>
@@ -186,6 +189,29 @@ static inline struct task_struct *alloc_task_struct_node(int node)
 
 static inline void free_task_struct(struct task_struct *tsk)
 {
+#ifdef CONFIG_BLOG
+	/* Clean up any BLOG contexts */
+	{
+		struct blog_tls_ctx *contexts[BLOG_MAX_MODULES];
+		int i;
+
+		/* Step 1: Atomically detach all contexts while holding lock */
+		task_lock(tsk);
+		for (i = 0; i < BLOG_MAX_MODULES; i++) {
+			contexts[i] = tsk->blog_contexts[i];
+			tsk->blog_contexts[i] = NULL;
+		}
+		task_unlock(tsk);
+
+		/* Step 2: Release contexts outside the lock */
+		for (i = 0; i < BLOG_MAX_MODULES; i++) {
+			struct blog_tls_ctx *ctx = contexts[i];
+
+			if (ctx && ctx->release)
+				ctx->release(ctx);
+		}
+	}
+#endif
 	kmem_cache_free(task_struct_cachep, tsk);
 }
 
@@ -2012,6 +2038,17 @@ __latent_entropy struct task_struct *copy_process(
 	p = dup_task_struct(current, node);
 	if (!p)
 		goto fork_out;
+
+#ifdef CONFIG_BLOG
+	/* Initialize BLOG contexts */
+	{
+		int i;
+
+		for (i = 0; i < BLOG_MAX_MODULES; i++)
+			p->blog_contexts[i] = NULL;
+	}
+#endif
+
 	p->flags &= ~PF_KTHREAD;
 	if (args->kthread)
 		p->flags |= PF_KTHREAD;
-- 
2.34.1


