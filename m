Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9957D116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 18:07:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54B1D6B00B2; Mon,  1 Dec 2025 13:07:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5224E6B00B3; Mon,  1 Dec 2025 13:07:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 438826B00B4; Mon,  1 Dec 2025 13:07:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 324F26B00B2
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 13:07:44 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D51FA85878
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 18:07:43 +0000 (UTC)
X-FDA: 84171685206.29.E5DDE88
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id EEE3E80028
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 18:07:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HObGeKYZ;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764612462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0QyuTy6ek64uIdo9s8SZmB6RliPCLO8eDRQ9s+Wqlok=;
	b=TKpkdQhqKPj8BZdWTESi19r14ObNfiK5MKsQpRbVXKoK9217G2wKZUF8tMBwLYCZHMb7Ae
	3KRDFcTWMSVUiNq/Aoc6ma1i+aGxpv7YbwR1DS78RopXQr2SoK3sIfNq8Nigvy2ORU0Axo
	h439bvzV3nOp/FyP5V4YcH8WYo/8TPs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HObGeKYZ;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764612462; a=rsa-sha256;
	cv=none;
	b=bJhHHNL63e/ex1NYW/d7T0+coOPkUlXktjxbkY8Lb2P29I4P6hVSRmS/ERmmAKMzJexF3s
	Rv8PryYftkdPu/VobbRwALh665HGvbngN4KescWLh5F1LiWvkYr14NI3J+SHPHIjEMlTkP
	B+YBjaFkVw0uwiBihn6gb/ESVVWbvFM=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-78aa49cde3dso44692637b3.1
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 10:07:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764612461; x=1765217261; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0QyuTy6ek64uIdo9s8SZmB6RliPCLO8eDRQ9s+Wqlok=;
        b=HObGeKYZ/4CYuFpmSqC39nR4eecKRWu2dYZZ0UeIpPPPB28xw9kzsyWCwxNM9rhEo6
         tEYr68zvtuiBDDlNBMhimRbl6J3m9TI7FH+ZoJHnQpYqnR6BhneiOsNlMwsRPwyZKr2x
         3ty/6BfMN7FYlGgxtu2WtCcxNbcZUohEIrRhPQt25Ry/scEkoEjSxtjnqTl1gBjUlyTb
         oKfaAambwENU3EfLAOR29XXmtr7oi3Fx1S6uLbqVtlwg3//qiNYWQlsldGelQug1TLZu
         3XKksUdd3qNnDnPDkPVdxZS6AhlsktVl7WoNnLMJT4JkmrcEOeTLieNl9CG8/n1XRyoE
         GLKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764612461; x=1765217261;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0QyuTy6ek64uIdo9s8SZmB6RliPCLO8eDRQ9s+Wqlok=;
        b=hvZVbo7QQ9aRXqHgavWpcpt/DAPnJbY9xQP5wzfg0rkn7hruZjZ3z5nbJ14yjaJ+ox
         MVhtWPLFY2236kLpOYhUJBP/ktVSWxPDcFNqZrTVz0YATdtAfgfIxCvzRqyz39J5fsRY
         5O79FYdDb+QwjoVZD1huDE2kcqbpwiMpeIW+z91bR8VDCwmWMgV+gdCNfVErDMY++Mby
         3LA6fNMzjSGos1fsU4KXu9810ZpXRMk+yK5bdwO2srOH9S7KetVctFX/y8s8SsShQLN/
         uLlZJlFK4fQDmR96ZkKQfvg2CB6QGN0bAqRb0dh5DX632LvJB6Y5Glnk93BcGybf54HF
         DURQ==
X-Forwarded-Encrypted: i=1; AJvYcCVhDq6xqf0I+5bsWWDDfBkR3YiG6oiAw7wbnHDWyJUAJGQvP9usvgHpwAxkzpP2k2/T2yN2kXPKDQ==@kvack.org
X-Gm-Message-State: AOJu0Ywyu8HByWkrIZ0VTBP9WcZH6kFz6LmXVvaM90mKKvX5Klzjz872
	8Qo0p0V2pdqgt6ck6x+kiTqJ6ZHEHeshDTnhNMmNwvEqvHXRhPX/6PodXT/NPA==
X-Gm-Gg: ASbGnctlTHLytFHZ2xM8OA57sZAfz/i4g1mgBSHCoseglNJHfTUtumzB5vH2u/DwnjB
	D2bzAD2VSokiDegrNi+DdyYVauiI634WLwUoFImzgfe9o6h2w3JLqY9BTnf8MXUDaLsP0d+HoTA
	+/lltt50+OjbZ8q9/0sXEItN6Jzh0y07lI/Nmo70y2CmdjLcoggq2DPfr0d6yeAOGYzkTlF8iok
	R1clt9h6WT2omNA3TZ1sOS4WkwMltjPZnrmaUSIuRvqlusUzvNnm+UGTPGORggkim8AyQPwUTcW
	zqyOhJXw8ne15t9KbDBB4QZ/bDRdV5UcPDE6BQHlg9qFr7xDdFjfT6OmLr8k/EKFvx/IdnVlfIG
	n4atl6FSOndvSYV5mHEJxRr+ALzfypr8PhPt4YhpNqYM1tYRenTviXJ3mMjpmN9Nf7xK4Ea+whH
	avt1HgJsrTPi33IeXw6y7ikQ==
X-Google-Smtp-Source: AGHT+IGebBLF0eFSQu1V6/IZFq1lSrNOt+fw835UDZgXCTtz/zrjUyYDOacz1JvbW8Om1eqnkY9hqg==
X-Received: by 2002:a05:690c:6087:b0:786:5926:edab with SMTP id 00721157ae682-78a8b491ceamr335684337b3.17.1764612460818;
        Mon, 01 Dec 2025 10:07:40 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:5b::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78ad0d5fe7fsm52262427b3.17.2025.12.01.10.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 10:07:40 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	SeongJae Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Mike Rapoport <rppt@kernel.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH v3] mm/mm_init: Introduce a boot parameter for check_pages
Date: Mon,  1 Dec 2025 10:07:38 -0800
Message-ID: <20251201180739.2330474-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EEE3E80028
X-Stat-Signature: jqycxcj4ohiwgh9zxdqkwcxi3h3f31h9
X-HE-Tag: 1764612461-193167
X-HE-Meta: U2FsdGVkX19qKaH3560ly/nxSJf8pX2fNJece9JCiXS+YPdrf90DfMiMOI3DhXH9V19hdNqT7rzOqFL0WZv1l5yJM+VZg9dqlvrIaeWWYHzh4tJjDbHw8iVeRY03DSl+z6/99epC2ALiY84osNSrwGDCtFD+34XNJG0DFUN4PJ7wr/lc9AUz+RzEzkgoXeGRbpXAlJGfzFAH8UX2jATZwdN3nL3f2Vnj9OVC22TwTQe1hMMkEboqPjMyVHffiiZoelzfmrp9gJijEW/EMiY2Tyd6byhV2X1/OlaRYQSlZ8Kjvb120/11YchWPaoJXt4i7B1/iR+J3V8mjNzeqjwsJQguEOS5/W3+5/S40XXlx4CZQG0aptPACaJXtgYKc8WWhh4nRHbxU3N2my67GKqu0Myu+II49rhbmOdRposjfNuksx1e6ymjHPC54so2jpe9QMUjS7xnwB1vV35lvAUPvp1GiVMJsQOV7yde52SVH1YSlpi+xia1kv1vtI+KCurZ+lzc/+crMd0R/0EUgZalCZdGhrWBJNmhYBNW9Y5XY3VmWnzsvhWZKLi8X41EJ6RAkeSkwQzUcDDJtXoUziJ1/vJgoazMHF1VZWmSrE/TTtADd+kvwJUMdvy6k5v11kP/WbTc/rmnBaWw8CfAuo/JIQxzxRF4OPU4nozn03Z1pUMd1/BAzbrh8l0T1haOKoEnrp8zjObVk2dm0IfA6aWfRTTWneUjBeRWuwxt2QmO/fI2eaI65DeOeze0GaElO1vyYxpc3ruAl70XZqoGOXC6iH6mkO/uPdgwLew8+b66IxvyGYuXYL7XkhcRP32uPCcBv3UwFQ/WvrQrFXdxmvCnVYszNvNLiEJt33qG7DbZgysbtnenCVXi2+GPpB/W/iatbpIcfxKNkmxK5Rb/bFU8CZrBXK4M/GbgcsDuzNXbNM3ahKIl5X8gRdHbuAsT2PoURztCotO7iem9/Zs6mkz
 ibRF3hvT
 GXvE5St69F9BQUDjtN5j9xPCJrj/W6jMeX1f6tFZlac8ZTgK/YcsjSkaO72t3KVQvLPe9UPW0xK92jNJ7SRpalJTLymUi0saPPbsgtXl13805lN6utoVrzPwv9GGquw5etrQROyoBPUxq2zY5VHfax8QJX/ROR5KQjEURjtGhfIVBigY1UOwuT8k0in2G/t2TQ9CLA6dewvCjX3K1ulEjhaMH57q2y+KtTis9Pn1ZbabBI0Mf09jSCU0IZLsUGpi+dtwMxkXoPd4a+rBnOV4a2j/R+tUx/UOH6qHIFrNQBzxgFZzfOMcut4rBA/saeIKcxDLpQXrgSnWVObhMp5sywgs0JkdXWaAv5hAgtYVjbl0Dp4NJZB3DWsLL5MzQVfeGfMKpvsOaYEyWTRv4H/Faq+pTLqdhkgjmqArFs2fFGL9qIGLHJSstV7qhY7ckwdAIsfY1KOoiWQDxExDXJb+Iz6Q+4WggPCXGzNrASZJsF3mq5gAvRB7aRrhDWo/D47fFZAbSjebiVA6Xtxrl2QOcbgJS4Y+BbYcav4+wKYPB73PTinNkmatr/xTQAxqEIgv6UXkV2eTs8ZPFF293JK0DffCxT6wnoUGZ8NC0EC63NtJ8IXZ63iATkK76ug==
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

Acked-by: SeongJae Park <sj@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
v2 --> v3:
- Dropped the second patch. I may pursue it at another time : -)
- Variable renaming (dropping leading _) and cleaner check in
  mem_debugging_and_hardening_init, as suggested by Mike Rapoport
v1 --> v2:
- Changed check_pages from a build config into a boot config, as suggested
  by Vlastimil.
- Introduced the second patch, which decouples page checking from 
  init_on_page_alloc and init_on_page_free.
---
 Documentation/admin-guide/kernel-parameters.txt |  8 ++++++++
 mm/mm_init.c                                    | 10 +++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 6c42061ca20e..acdc7fbdecac 100644
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
index c6812b4dbb2e..fc2a6f1e518f 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2525,6 +2525,14 @@ early_param("init_on_free", early_init_on_free);
 
 DEFINE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
 
+static bool check_pages_enabled_early __initdata;
+
+static int __init early_check_pages(char *buf)
+{
+	return kstrtobool(buf, &check_pages_enabled_early);
+}
+early_param("check_pages", early_check_pages);
+
 /*
  * Enable static keys related to various memory debugging and hardening options.
  * Some override others, and depend on early params that are evaluated in the
@@ -2534,7 +2542,7 @@ DEFINE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
 static void __init mem_debugging_and_hardening_init(void)
 {
 	bool page_poisoning_requested = false;
-	bool want_check_pages = false;
+	bool want_check_pages = check_pages_enabled_early;
 
 #ifdef CONFIG_PAGE_POISONING
 	/*
-- 
2.47.3

