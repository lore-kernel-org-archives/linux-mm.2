Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42789CFD366
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 22:54:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B8626B000C; Mon, 24 Nov 2025 17:54:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 268706B0023; Mon, 24 Nov 2025 17:54:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AC316B0027; Mon, 24 Nov 2025 17:54:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 04C4A6B0023
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 17:54:17 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1824F140508
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 22:54:12 +0000 (UTC)
X-FDA: 84147005544.12.C6FAB4E
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4827D180018
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 22:54:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IAhGGo9Y;
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764024850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YWuMPsKKgatyo18s+vz5tnI0IJ4a05j03miER+N0IUE=;
	b=tbnddeJoZkqbw0xNuKzCFDs0YN7WOMPy2CJPtsjW/58GhsH8CvihioFhYaFkuX0b4eKIQQ
	FPJ6KBX2g9Xm1DiSYXhO6JTNprBu/BBIEwJlTKo2YIOVaXxbP3f3Ai1s+nAd3N+QKCYqvc
	m9xab3OPmOnhS84LN93J8kEclsbNGlk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764024850; a=rsa-sha256;
	cv=none;
	b=Fn4CLBM0V4riZTRvIcHX+774FJMWtlIntRqNp+2XS5EFoaxw/xzQkYh0C6AC8sgJF6BK8R
	oG+RUhVDK7sYGWYbMr+0aBgfdIZZr0MvNQGHP5fr5Fb8a6hliKQ9GnT4ktX/MH4H8E9HbA
	WdhFx7K2C1YXgxPg0gaegrYWS5DTslw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IAhGGo9Y;
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-787e35ab178so45935977b3.2
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:54:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764024849; x=1764629649; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YWuMPsKKgatyo18s+vz5tnI0IJ4a05j03miER+N0IUE=;
        b=IAhGGo9Y31q/PotWeO04hPu3Ar615RZivyl/AfYlwSLo3u5Q50eJgwSRsXNrlCjLbE
         jtFUL9VgjMvjkYDno+VWC0WnCVu2fjAaXXaCRJS1dxZ6qPvkkWb0JevTA+ZxyZAAuM9o
         MXshzKkkfdHWWLNnsEAlUigdI9DaXaJt+eUzG7R6ek+kb+MRHZjaSwywlm7ZXrdfKQmL
         7955gdgzrIMx41zYKEJaDVIDhtZkr2+sXMxG9O5jppPS1sIJhM393OTT3tHNIX5qk3fR
         qf4y2TVieO024IF++iTWlYL35gbCAfS0LH1qFicvUiOsZMW8QcYS6tGgyys4SWANisH7
         UIMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764024849; x=1764629649;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YWuMPsKKgatyo18s+vz5tnI0IJ4a05j03miER+N0IUE=;
        b=I5xdxjPf8D5yF91MZ532ufZLwsquQF9oLV7ZQzEKDCp0JObnaZ7u+c0srlJnvg7/Hn
         nLtvwb+NwooR/0AoCP8dl8pbd2zc2ICTOHJOn5vhTimvgy7gzrCHnxVUxafEckIl4lrD
         oWMMgXhOu8ZWb268ySaqhoqRZLJzzDWS/UKkjujNY4SrhzF1L+U2kRB0YwP/6/Jf2ZcJ
         OsS73hZDYetKc3TL4xwp1Ekq9LU+J9nJy+oVXCzH/XtsQqjWcLOo2sTLFGGdnMkzLGPJ
         QE6V2+v53HI5IGDb/DALlGSo1t+5ydsD73BJreF7xU9Oef6dLDZobHNxb2i1+vWh1PEg
         OOaQ==
X-Forwarded-Encrypted: i=1; AJvYcCV9xVXAtQwDImaVNgj3vcwa1S7bQcs76lY93B2A0IG9OEqkDvs4b43oOc2R+s+vs5DlW3znbk+MZA==@kvack.org
X-Gm-Message-State: AOJu0YwT86kc5amY0FEri73wwPMYxs2XOsAMH6Lo6xyETILUCyAF9p+f
	vSBzbuxqWB2ShMgkX1DE5nArS/IfjIvdQq5PxWVxk15qpjL4ZDW2gXeG
X-Gm-Gg: ASbGncvbrWHcKs1OwXc6Dk7OvmNDvaTsYFTpPLzSZc80A4xw6afHkiJ9CF8zkGtYajg
	N+uCdI0RClvFur+bktVL2FnEopZAcrv00nVvgH5qkCgUvDp6pkYS0C/WrKxLme9nKWy+cUaavhD
	FpM1JloX4vJeyRUwWc5IExx0MAHWUx73e0p0Dyvl4BU31S7DYpa61eAuqJQZ53A4ncpQp3Rrpy9
	x551llqNttsu4AEFju/DBx8RbLKDe8/J4aOnB7TTnPksvv+SIbvEIQ53QkuMDBX26VRpzZDtpoy
	hF47ASakxz4lWJO/C54B86FTos9aWgvzdBd8VPFUQO9BZWmnp0N+PkdrNuUGU2Ns+oNEc5vJIFb
	BMWSkdyFVkiLOBLTj9U6sCg8Hr+sQOHDdP+7zXOkPA9m+vo9PUPAnXg5+YJXu46G57x3zqv7M1+
	Vp6ThbC4HPPcD1dMXizDUcFg==
X-Google-Smtp-Source: AGHT+IHWNL6nbfpxwuN4vaoDOcaitVPmqOrTZpRhfU4dCtIL5A3x3tBs6D5XV9tHVYVPQP1fZTsyiw==
X-Received: by 2002:a53:c043:0:20b0:641:f5bc:6962 with SMTP id 956f58d0204a3-64302b3f5afmr8307288d50.78.1764024849231;
        Mon, 24 Nov 2025 14:54:09 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:4f::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a79925c85sm49604297b3.37.2025.11.24.14.54.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 14:54:08 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Mike Rapoport <rppt@kernel.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH v2 1/2] mm/mm_init: Introduce a boot parameter for check_pages
Date: Mon, 24 Nov 2025 14:54:06 -0800
Message-ID: <20251124225408.2243564-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 4827D180018
X-Stat-Signature: ode9anupqc46ziuihpzmji1ggaea6qoi
X-HE-Tag: 1764024850-280560
X-HE-Meta: U2FsdGVkX18A4PFTmjU3lFGGKYCCwfwnuZyyDJtsIdgTdV+dUkK3+DFeNYKkJ1e7ln9p3OCblXU0R6HLmAytPQY3PkmJEg7AxS+CC9sENvSED1cESLVHK/oToNYctUxUEkIsBTo4tC5Yava4zY8yU8z8WTdxQMBS/kLXQn8HpTKWVhE/Zn6Z9xRZf+zB4eeydAkrpBH7CpG5cqfX7yF8k58fEI+qmrUQn3Qo4+yfSg+20ye5Jq7Kjcj10R4SYVWDiC2VOENCDpzwx5MHD3MrEyxTcVuSGImf/075aEXZzRQM/4JMvLxJ6DvCaO0tWRzeo8yxEBP9YAIWaj5UNAw77NzcWAJjLPNInpYo6zXNF8CZxGX5aT758aMrj9VXx3Dubq9Ymnikl17O4PjyNrFbgOc0GDKYG7KmR3u1BsoiapQsupoBoNfC8xw6BTMTwf4rvaPJyFZ8GaxrNh1fPNP6CHBvKPJyhwgWYLDmPxsahkKn8d2bEiJR0NXEk+6AE61+J1v0Jl06STRNopd4tGDIJzQFYVlc34SKLTayM6/GUOg0i5dXPo0x0BmIj8YRuQ6mFiZzXualMuGtwXezav4W9/3UG2t5Srelyo/V4ynGrnmDO/Ydvkld+olWnsJjD9aT/HzZgnsn+rWtjLGiBd+BMiwmMFD3O1gs5ZWVBjaw/7wtv29WtmTkt1FMMJAfIrYBZ451PcTGRDCFS9FC7co2ju1eYFIiQQHf7GhpsrgOkM3xK0w5fpvKTyfI8/wwAX54z6UMIBh/7UnWNb20Ujs7sbJU8+unZJOW1E8cLfPLVWZeylmbMj6y8w7/r97YRXUIMnKASgfkZWxxx7AY86oQ76yNPrzHJlgNXsXMYEDoAGXUC2yHR7xSssrnB87DWgo+aRuEWwtSw5k/LHI1jTQSNwM2aR/cP/wRXJ8EnFvPIOTVeLA+F3ZCvf+wjKuLAFPgieKmt18OpFJzTYFDXAr
 IM2DQIfw
 qgFcmMf+dqs5z680RAmy4R/yeZIexQze/O3pZz1p6r1vdUCBRz7/W14qr6u2cShQt+MPO3LNvJZ1+46fGd5pdqgDKrteDbK8DWIXihKk6qvuwmxiGGy84+LER6Fr6QReWlD6Jrs7D50GBUVyGnYwUrSy+FsdgW9BpHqQqEjHYs6oM8h2XhfCA1FpXKCMY11UdYyejvr1tf2ns6C7fL0LS75kDLBxJL5m8sH6TUQrLmTWA4ocXPCxicpDMCU2mtXWm1WCMgR59bcMh98vn6AoxrP8F62CKWTj+WRf3qnBj8SK6snxOjQ+NOgR0nf849pb4gwdHQRqNbU6orfdQHWkIOFr5ipB8ha3KVnnm/mrJBLkTmG9JahBrxFs7RkqcCgPUr04yJNIiHgA8FFYDHBETDQWbuQpSHVlcgXFs6jJ07vAAypDG4Ix8EhgwiH4+fdMCArMKkHCwpZ71cAPG+bU0NxtEvlhsDurwYIoAgVYMEto8nsx4vmWsd21Xqojz9jmoY5Hrqqz1yj/eyYQUy69uFyaTm2Qnh0ddDyy9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use-after-free and double-free bugs can be very difficult to track down.
The kernel is good at tracking these and preventing bad pages from being
used/created through simple checks gated behind "check_pages_enabled".

Currently, the only ways to enable this flag is by building with
CONFIG_DEBUG_VM, or as a side effect of other checks such as
init_on_{alloc, free}, page_poisoning, or debug_pagealloc among others.
These solutions are powerful, but may often be too coarse in balancing
the performance vs. safety that a user may want, particularly in
latency-sensitive production environments.

Introduce a new boot parameter "check_pages", which enables page checking
with no other side effects. It takes kstrbool-able inputs as an argument
(i.e. 0/1, true/false, on/off, ...). This patch is backwards-compatible;
setting CONFIG_DEBUG_VM still enables page checking.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
v1 --> v2:
- Changed check_pages from a build config into a boot config, as suggested
  by Vlastimil.
- Introduced the second patch, which decouples page checking from 
  init_on_page_alloc and init_on_page_free.
---

 Documentation/admin-guide/kernel-parameters.txt |  8 ++++++++
 mm/mm_init.c                                    | 11 ++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 6c42061ca20e..0ba9561440a7 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -669,6 +669,14 @@
 			nokmem -- Disable kernel memory accounting.
 			nobpf -- Disable BPF memory accounting.
 
+	check_pages=	[MM,EARLY] Enable sanity checking of pages after
+			allocations / before freeing. This adds checks to catch
+			double-frees, use-after-frees, and other sources of
+			page corruption by inspecting page internals (flags,
+			mapcount/refcount, memcg_data, etc.).
+			Format: { "0" | "1" }
+			Default: 0 (1 if CONFIG_DEBUG_VM is set)
+
 	checkreqprot=	[SELINUX] Set initial checkreqprot flag value.
 			Format: { "0" | "1" }
 			See security/selinux/Kconfig help text.
diff --git a/mm/mm_init.c b/mm/mm_init.c
index c6812b4dbb2e..01d46efc42b4 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2525,6 +2525,14 @@ early_param("init_on_free", early_init_on_free);
 
 DEFINE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
 
+static bool _check_pages_enabled_early __initdata;
+
+static int __init early_check_pages(char *buf)
+{
+	return kstrtobool(buf, &_check_pages_enabled_early);
+}
+early_param("check_pages", early_check_pages);
+
 /*
  * Enable static keys related to various memory debugging and hardening options.
  * Some override others, and depend on early params that are evaluated in the
@@ -2591,7 +2599,8 @@ static void __init mem_debugging_and_hardening_init(void)
 	 * of struct pages being allocated or freed. With CONFIG_DEBUG_VM it's
 	 * enabled already.
 	 */
-	if (!IS_ENABLED(CONFIG_DEBUG_VM) && want_check_pages)
+	if (!IS_ENABLED(CONFIG_DEBUG_VM) && (_check_pages_enabled_early ||
+					     want_check_pages))
 		static_branch_enable(&check_pages_enabled);
 }
 
-- 
2.47.3

