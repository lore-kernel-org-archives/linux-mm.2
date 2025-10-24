Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2829CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 17:07:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B627B8E00DC; Fri, 24 Oct 2025 13:07:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B12C58E00C9; Fri, 24 Oct 2025 13:07:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A29108E00DC; Fri, 24 Oct 2025 13:07:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 938FE8E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:07:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A8E4C0F54
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 17:07:08 +0000 (UTC)
X-FDA: 84033638136.30.950172C
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6A121A0006
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 17:07:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YCfSN+lt;
	spf=pass (imf25.hostedemail.com: domain of ptesarik@suse.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=ptesarik@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761325626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wTI0WrdtdIM0l0EagSMX46E8zaYjfQnvEEG1YbIgJSk=;
	b=JqkNQMcrJQgEPKh/5Oy+gWiMIrMxXk1pZ6DYFjg6DeN0O7Dk2KxWotaKocuwKvb2GAPJ+u
	K7i5deNBnm4d00baI8EDnIAA8kVxhKZMT+YlHNJckuW1II0iNP1rQcKRn6bl7lURT7x1BA
	yodiF7ACvUppa/hDvvRhqKPTlsWg84I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761325626; a=rsa-sha256;
	cv=none;
	b=Wo1SCG+lJBVdYBngcOMyU6YuWN26X3kg+d/j6qxRViTGWNlux+xT/S2ychB/Ly3LsE50nj
	pCy2qyMbSIcVKqH8nPEV5/dj2f15JyoSkP3Z4zIhJ4ABe1OtEtCc1P90GJ/u8eKCh6hkxg
	6SfJdgqWU5KBkLQDN5xQB2DwICjgghg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YCfSN+lt;
	spf=pass (imf25.hostedemail.com: domain of ptesarik@suse.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=ptesarik@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-42855f80f01so366522f8f.2
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761325625; x=1761930425; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wTI0WrdtdIM0l0EagSMX46E8zaYjfQnvEEG1YbIgJSk=;
        b=YCfSN+lt2UDvxGpB+4zZQUJc1HV+D29BrKyj+wVIhOmDaaB4qnXjKg60moW8s1grcZ
         A0Ke4Tlkel3+ruwNuBCCyQBe1o9T+09KLMz9Hk9EEaD4C6ft8VnwvovB+YTKOWMPr1mY
         mg9t/fouW81NsAYWcqn0Ibcy2SqRwI8FqgYsVHlcuBeQh3X11ClbvTt6yzxr9BKOwaxh
         EbqUjP4fVPXKIN9gyzR5Jan5cwu8jC/SUUxmgIuwD3T2FPT2Jw6XNiZKvJWNXnsQ3iEZ
         YCFA1GC5saNJHaj222BSiB5pz6OZYtNypYRTmgdxowX1FZ1IrEhl9AfmPy4KBwsUMGB9
         tv4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761325625; x=1761930425;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wTI0WrdtdIM0l0EagSMX46E8zaYjfQnvEEG1YbIgJSk=;
        b=tk0aQ30qdaQMQOPafZ4Z460lcbaKfx56T4402FCVRj1qFIuZnHz2s3fN/KeesBvq1P
         OC5mT0vh+0PGe0A84kx72IVFvDAgQEFmwgXccPIgOa2hwZdsA65DGlu7J6hqcjvtcpUg
         irHS52hmKdRGyKpau2YoC8c0TF4NxyBrZam8E2NJfIZjZWM95npQx3OPE8C/InB/aIc6
         795jKJvcI/IMQY7cIZfg6/RRFUVoPcQWu3SpoA837D5XUUKtwSyWUh5LPrD838EIRWLO
         wF6AnezQDWYWDYPksi7iOocXpUUvL9QfROsqd6kuQ2lDaDC7Ni05n3E5vpE2uf/fqDaf
         d0fQ==
X-Gm-Message-State: AOJu0Yx+JDTXMHsykbHAtJvFk0tzqtK+NXIlTbdyceGC2uGtZ3eGLnwH
	MCMo0J8M2wFdf1evCUtt/rH03BLVOK7npHu0qr7vf7k7lzG+cKj5EPXODYscIcQtj0s=
X-Gm-Gg: ASbGncsMib7TToupw0Ro3zhlOWWoIEmtgcnAGxqP6uF7RyRMp3NnSX6kSLoxsRmUky4
	fAiKjnX88k1jgDNWMEW+BX3miUsMcX80DYbcY24RBa0JB/gIGRJdv9KMvJwtGgZH3Q853NbdDIx
	5vKMRLcA+JXoXKtnOf1fzc2BceZUBQ11nH77QjtD2qFykZsIVz31yXo/igEHjw5AJrAVpxozmut
	qOwTPEp0ROIBeZ8zD9/cSqkd0HKxl60OCqTrNowPnqychdKv+KLTjtm/28cc1h5YTxk0sCZm7p5
	3a35b8Uf9rUrkyQ2ZvkC/mG6ePeJgrY8vLKE29/0CICIrmaULgNVAbyn6v8tpXJUgHrEf0owpn3
	ctSEK58Mq2PFr/DiWO6yOKLKdsrVyRERSfv0FvdBYhf13j55zlxkLQxfT9FIMmqjeeJzM7V2jK0
	ySCWfgBaXP+3iQXWkVmaksvTTo0atHaRHvJ6DItxmShLVJBw4S1McZukxlc87Hba+lK22WTx5Ir
	SiG01bY9q0P9/11
X-Google-Smtp-Source: AGHT+IH88Xk2C96TCjVzuAAuYBe7oCUt2+32odpGfIEDb57P3nOWXPyKaYzrle+HrREbbngoJJbt7g==
X-Received: by 2002:a05:6000:2911:b0:3ed:e1d8:bd7c with SMTP id ffacd0b85a97d-4284e531aeemr6206406f8f.2.1761325624937;
        Fri, 24 Oct 2025 10:07:04 -0700 (PDT)
Received: from localhost (dynamic-2a00-1028-83b8-1e7a-3010-3bd6-8521-caf1.ipv6.o2.cz. [2a00:1028:83b8:1e7a:3010:3bd6:8521:caf1])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-429898acd69sm10349411f8f.24.2025.10.24.10.07.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 10:07:04 -0700 (PDT)
From: Petr Tesarik <ptesarik@suse.com>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Petr Tesarik <ptesarik@suse.com>
Subject: [PATCH 2/3] slab: convert setup_slub_debug() to use __core_param_cb()
Date: Fri, 24 Oct 2025 19:06:53 +0200
Message-ID: <9674b34861394088c7853edf8e9d2b439fd4b42f.1761324765.git.ptesarik@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1761324765.git.ptesarik@suse.com>
References: <cover.1761324765.git.ptesarik@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: yqx4xnxpgwk5z57bn9marjfs8pruh8do
X-Rspam-User: 
X-Rspamd-Queue-Id: 6A121A0006
X-HE-Tag: 1761325626-981104
X-HE-Meta: U2FsdGVkX1+b89Khl00Hlyq8YK6YD7QV3s72L9cISqEQ0EjYXrR9gpLt5eZL10u36HKtpMghhtSAUfhnW+J/P28zoroUH7hCIPaMYpDKcx3uDNioB2TOL2caJIDijrm+i3lsrfCqfvpp4bVSoNfS2l8kbxIBojqurJuxb8vfEqjV/2gXK7Jo6wOpRWrVdqNpAEY5Y83GAkEMCNmMsQrG0HgijZtZp9BX8hjxnqYaEFBF5YrZgpEgbUZFetyOI2xw6S/O5lvmBLUM5h72uHmGYxiHFzBkFkrbNUSgL91e5nYW8SWoB0MFAUtHV6L/Io6c8sdEMGDD4aMTHjLsIu32jU/U0F3qr2DmSczJ8UevRo9ZNPXX1qjAFTDm4WX2O6wh7S9f+v9N1g8+FCqswlDb40KytIya7KjP23qvm0bZ3bSgq9V5IUkie4z8ObjyUdm5qCVYmrCZ91dOYRY1Rdvt70nZ3cxZLxGzrLXJMPlJs9za9quyJlth1aVtXor+Mp8pmg6twcokjDnkdFyY+lnydPnKUsGZacjntwooeBg9ry7T4l180oUw25ydTGswY24+KWZE4Voh2EnwQb7fSpIhOc3xQIOEY6kEd4OQWaGKmIQl6saFrqa7c8UxwDdbFbjV6OMuKFIO4D01HNyg4EoLgLqzI5Gr1yHT3zn2e6W5Ngf5bWdFdWfviu2EhwxI+9pXo7V2eKcIC2qFDaxTn5fJDE9na4NN0xR1KJ5rLStBZHElje+7tDfWfkjSN0VUywHbtQBMDg+2tFg/9sSZ6Eoe+Rcx6ekGKlTPrGNpMslX3HrtwUp+q5P/05VKaXU2yc2bvM6WQeyKj1pcz2vuP7lE1ab4b0iL7Gxm6GzmoGqe8+ejjalMjrjvPAk4rdqCwyfUfY4QgTazQn4YLkR7OWuZZDuN8+blLMgO1Xle68rQKBtX/2T1E2NXZ7O9uDfPKCbs2rzWJk7y5qN6x1qIqrh
 TG5LSlhg
 7GQy2DQJ8xiao1X9S5bDSMDdJphEvcMbi7C/aN8u87fH9cGACaUdIkuHBujUYWWu8St9SDhibBKKEiv6xqVpByGhWmLPHX+s3HZJna1wLgiRMAN3uFffDWB1qxGo2M2/BeKlS3ZBajMFDVq4pK1b8NU9Q9xB9J/nJGN57rQbl15wmAC4xW8jnctRgNvOewl9MQIHpKVpHJaiitMfr16JL42AKqW2qxt2kQefNi/pO80f05mfnbZ22uKB1yGwA+A5fzTBS0VHc60bP2iUdQ/VNVQK9DMBev1ARVk/nh/AQ/wBAWDSCfpOcBCVPaiU8WSaua4UhwBwRQy1brnXfKgMp/i20ATcq0sP2bDEwBjz9i7v7MeV5WoOW0qo6KLXiaHObhf6N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use __core_param_cb() to parse the "slab_debug" kernel parameter instead of
the obsolescent __setup(). For now, the parameter is not exposed in sysfs,
and no get ops is provided.

There is a slight change in behavior. Before this patch, the following
parameter would silently turn on full debugging for all slabs:

  slub_debug_yada_yada_gotta_love_this=hail_satan!

This syntax is now rejected, and the parameter will be passed to user
space, making the kernel a holier place.

Signed-off-by: Petr Tesarik <ptesarik@suse.com>
---
 mm/slub.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 26faebcf27a2b..b124087b95f32 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1863,7 +1863,7 @@ parse_slub_debug_flags(const char *str, slab_flags_t *flags, const char **slabs,
 		return NULL;
 }
 
-static int __init setup_slub_debug(char *val)
+static int __init setup_slub_debug(const char *str, const struct kernel_param *kp)
 {
 	slab_flags_t flags;
 	slab_flags_t global_flags;
@@ -1871,10 +1871,9 @@ static int __init setup_slub_debug(char *val)
 	const char *slab_list;
 	bool global_slub_debug_changed = false;
 	bool slab_list_specified = false;
-	const char *str = val;
 
 	global_flags = DEBUG_DEFAULT_FLAGS;
-	if (*str++ != '=' || !*str)
+	if (!str || !*str)
 		/*
 		 * No options specified. Switch on full debugging.
 		 */
@@ -1918,11 +1917,15 @@ static int __init setup_slub_debug(char *val)
 	     static_branch_unlikely(&init_on_free)) &&
 	    (slub_debug & SLAB_POISON))
 		pr_info("mem auto-init: SLAB_POISON will take precedence over init_on_alloc/init_on_free\n");
-	return 1;
+	return 0;
 }
 
-__setup("slab_debug", setup_slub_debug);
-__setup_param("slub_debug", slub_debug, setup_slub_debug, 0);
+static const struct kernel_param_ops param_ops_slab_debug __initconst = {
+	.flags = KERNEL_PARAM_OPS_FL_NOARG,
+	.set = setup_slub_debug,
+};
+__core_param_cb(slab_debug, &param_ops_slab_debug, NULL, 0);
+__core_param_cb(slub_debug, &param_ops_slab_debug, NULL, 0);
 
 /*
  * kmem_cache_flags - apply debugging options to the cache
-- 
2.51.0


