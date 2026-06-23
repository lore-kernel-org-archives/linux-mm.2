Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBABCCDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 10:25:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 966BC6B0088; Tue, 23 Jun 2026 06:25:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F6776B008A; Tue, 23 Jun 2026 06:25:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B7F86B008C; Tue, 23 Jun 2026 06:25:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A4956B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:25:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AF3F5140447
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:25:01 +0000 (UTC)
X-FDA: 84910794402.12.01466F6
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf09.hostedemail.com (Postfix) with ESMTP id D333E140007
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:24:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kdPiUzEV;
	spf=pass (imf09.hostedemail.com: domain of cppcoffee@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=cppcoffee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782210299;
	b=dmsoQ8nlL5tJrD7pJPELtL4hv9WvriQ8MNyH1kUWuHeiAd7KhMptGBGtYltb3/yaYdidno
	BgSWvWxPEMetUBf3ZN/Ej08G79Qw74xUyfsTN0QmtR4BPO/kyO9e9b6ShzFRkN0Ofnr0y/
	CF2oXR9a9+hRaev5fRXC6XJ6D4I+EcI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782210299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MN3pPDGcF8EmJYIIls8L0QT+n17wsCPpidJtsIu7n1Q=;
	b=X9KX05262WBx4qls0wyUgtEiJSiQI9wk54tcBmTwdNF+VCDJZYssIL0BYKdXsgpd2KjoyT
	ygPL5K1KB3VRONCXrr7CqQ9mogR6x1qTONiqg8uaBb6RtpV1szLNraHDVuiqH3xGOh7aP0
	+9jxfiuTvedWXI0ZSb1k6dZQieSFxLQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kdPiUzEV;
	spf=pass (imf09.hostedemail.com: domain of cppcoffee@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=cppcoffee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2bf2247e38eso61625365ad.3
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 03:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782210298; x=1782815098; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MN3pPDGcF8EmJYIIls8L0QT+n17wsCPpidJtsIu7n1Q=;
        b=kdPiUzEVkaZc1TJ+HVF3uM5qnvgt70exgGDkxXFW44USyAGewXnCTKq605CICDBb/b
         ti6rwu0rS3A2MVl6130qV7/Zgr7ze2BjxJzd4GNjwlDf0ldZnjk6SrHz/EbD+QPDs6Kl
         EqqB8QUEXqLcphmDbmvzDrisgsLoJelX+3EsACASQuNQRV8b1B9lZFq8HGsTLyatelWk
         eKKg7Qq1iMLEv3P5r3HCdBm6ir0IZndN8v6gqfiTer2ckCqFmD0hfaG//5pOkU8T1W9B
         eTzNv+SS+oInpsBObghGgeeWemc7k+Whu14XnHz2cLuePLx20sGxArUHWzrcKv2MnB3v
         s0AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782210298; x=1782815098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MN3pPDGcF8EmJYIIls8L0QT+n17wsCPpidJtsIu7n1Q=;
        b=PSKaKKMW9vHA2K53PApWy73FjZMZCQDyRr717WGS3V08W7t8/K6N0ucX7xdDmf1kBo
         EZWl4rBG5C/ZON5w9V2kN003zmo+n5AqqRVXUFabTQgL39+6TCMHUsOKmVIYrB6vp2XP
         Tb7jf9U01Y8qo9+Tty/WqkKrMI9O9gGvSTfcrLf7xwOhQ/tXxOHaD4ECRt3WvZIMP6UK
         cZ9Svv2KOxBOTqMGZPL+wkzfMBoSZX6lwvKuK4eNsjyxVygBQEPokk0R2jRN9lkEyFyH
         CRVcI+0cUefXeNl2zbJNKtu/64Ls/zsgRYOF43QgELvKy36xUlmgHb2mS0o53bpkLzLP
         m6Uw==
X-Forwarded-Encrypted: i=1; AHgh+Rp6w92v2P1Xsd0RkLLbNCNSHYa9PyUVTpiYBLm0Ov+ED8egBPUt9tCiNrbGAePMSLXxJWXNGoIvbA==@kvack.org
X-Gm-Message-State: AOJu0YzCGruDuxGXx95xL2R3fImVJ7luTPu+KKKLhOqqCVcZ4uPZRwsj
	4AVyj8qvWdqtNHaGXow1SyIqGO3qKkoDEHf2KX/uzGFpWyrdFalRfG3+
X-Gm-Gg: AfdE7clWcrz87dMwnRHq881VWNogBpeTrxe3Woib/inZ3EWiE4GkM7P4m0AowGZtB3V
	d9+ggn/H1Yd6tjfMeQMYHsBFaUxh1Cp5waX2LsAWKZ/lk04Zi/sNliAFp/5fN3zjNOO0Vhpzkz2
	Mlqj+s0ygfhtizXOYa3k50wj+VXF5WKP8jBe4AzaxAdRA5EBVHAezt72lZrEM18iaTmEEOXjL8g
	w7wXf4lkyEt1JnY5L1kPVKA+Oaz6OrGj+uBeWjTRqE9MsTPLPCpY0Coq0xWsXkCdSvrAdgyFuWW
	zkxaoM7O3nsZi3ZyNo5B2g4SNgPfc/2lxFrwhPyp4c+8uREh+Dd0ccUyVROhQzTs9YR6dQSGOzR
	Eq0VuAoW1bg+Td//8dax+RAtnySsMpsXeAq8x8JBwSQ8+yUrRYzgT/0DJIlew3u7++qkN4ubvBN
	EM2nPJ1bZ5Q8ubDmLGLettqtmleGJGUg8BWailESK5/EW/6okIIIck66T3EEC0MIYlXp22HF/6J
	fcalvzNiTIaCyI7JJPVjWIEM0axUe0hJNdzn2h9VVmC7UlhrA==
X-Received: by 2002:a17:903:22c5:b0:2ba:4ad9:70f6 with SMTP id d9443c01a7336-2c718f953c5mr188846435ad.31.1782210298472;
        Tue, 23 Jun 2026 03:24:58 -0700 (PDT)
Received: from localhost.localdomain (ec2-54-199-123-161.ap-northeast-1.compute.amazonaws.com. [54.199.123.161])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7436ee37csm103161525ad.26.2026.06.23.03.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 03:24:57 -0700 (PDT)
From: Xiaobo Liu <cppcoffee@gmail.com>
To: rust-for-linux@vger.kernel.org
Cc: ojeda@kernel.org,
	miguel.ojeda.sandonis@gmail.com,
	akpm@linux-foundation.org,
	david@fromorbit.com,
	qi.zheng@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	boqun@kernel.org,
	gary@garyguo.net,
	bjorn3_gh@protonmail.com,
	lossin@kernel.org,
	a.hindborg@kernel.org,
	aliceryhl@google.com,
	tmgross@umich.edu,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Xiaobo Liu <cppcoffee@gmail.com>
Subject: [PATCH v2] rust: helpers: move list_lru and task_work helpers out of binder.c
Date: Tue, 23 Jun 2026 18:24:31 +0800
Message-Id: <20260623102431.3577627-1-cppcoffee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CANiq72=sSkApehxg6eEpAoNU8zSsRAfqD+RVymM3UQGuvfKyeQ@mail.gmail.com>
References: <CANiq72=sSkApehxg6eEpAoNU8zSsRAfqD+RVymM3UQGuvfKyeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4jsx9ftxar4m5ohe87qrgg8syhzhoedr
X-Rspamd-Queue-Id: D333E140007
X-Rspamd-Server: rspam06
X-HE-Tag: 1782210299-345212
X-HE-Meta: U2FsdGVkX18DY5N6ImFIA7l78EhK67/72QJSBu9GHj3IFS30qfIwOGV+G07pnyBkg3mLsSG2LCaJsOWnsXr3vM/nnX6ldPXARNfWZo430ClmYkUAiM+nQil4J0eqL0akxbZdRw257Tt5GmGcVKgKCCVSSqz5eLwpk4o1Sx0DNhzYJnKdjDuEmbJc+WRhk9Je/m4fBJiAq+uf0bGvYo+ApJAxL91mfIhMWZnHF/TjPuceLqUN+IiNTd52YSVo7/x8elCrdPUyncjvoFJgxW1xM7vDHUT2iHuK+PMexPLYM3i8yFKo6oCXAQRteqep+zsA25bEh+4xgJ2NumTWFNowvYhPKwqreFk9xaBfrGWE8S4VO1LhDM4cFYUypnd+ttxgLvN6cxluo9M/41qUmB0Fu7LCBUYf6EtRxciyW9VoicPvEXJNoVk6Rc8+YVmOgqSOzoS1uPUH8w/oAI/mpVBgxr3tWAZ4D77BtY3RVYMECd1jwW5xFDjM4HW31RqKctR503i9HVXg4g2kzRBESdfNOJoIZI8bUERAk7FfFj+Y8QJfdKZ5Ak5EHs0OmNECR2q9iVwExryd6fEKuS4r89tXP8WCuB81qnFSU88t1DaRfkCU0rHT094SK2dMUfIQBUpSSxVIZkXD0RyAiqGFJ3rHvr0fa38CCr8OXPKhYIztfwBWGVT1erzcfyOttsSAUQr7EkAUgeONtoaGd+BlRb6ricWF802yrfejopyCpJU2WVXCv7n998J1V0+y1xdwXSY53q8nELN9yWEGYYABa8nZElRKo/0JD9+5PYMql8T5wJIxVfMrfgxC0O7JBkUBgWIAvP90vZn+nw6Oq2R/ft0fveyQzUorwBh9Trqwxu5LvEbxYtS6N6LIsArr2adtGSdzIT53VMvCj7qHIiwqiUCxaN3brgP0sgty+ZxHt9tWH4DXgaJmbvsnHoGU/hJk4/+sXnGFKX2YIu3xx3hoT5k
 gcf8tUWc
 Ig7l4nWOWmVpC+D/gitE35K/b3IO9Lzl4A2EfmPGL0lw/flh5lAKqZkvtsjq6srsGXGwjqWujQ0DBBWSYbHuOFaei2i19P/EVUiOZ/8tiP/OzgkdUxE2cJL0MsDERSIaGS4/wLvNwc2Cqb3maLut0niSqqO3DdTGhp6wrtkUx62PgF+lSmt1aW7iDG7E8KljltWXcnSgXFPpIJqbtgtQyPg1CvJ0VpqHZFUt+n62xg7XYPw2wuOTmcKesI5+7SI+h0djxLaRHhVQWTf+JEdvPMxZ3zSRYzBvBctLfb3NNRYgKv7+IwNtok32yUWmtSCkBNHJAoVTl+8mCMDvmL386R8Lh2ZKrVfOMgvMe37muDdnic48Dt4sDkVFpGxnUm0wO9UxqEvEvg81QmUrlIpT4U6at6PfhKXsdGw8JNAYbg134n4D/hAkEtp7hFqKmMkCvrTGwHRTYoEoujava0Te5U9OYszW5XXoz1lVMm8v62iHIKGpJWOBrQvZZVoLmnq5LS7+TyyJm1giq2UGV2FeODuPJS9S1glNNW3Jn7sAOvYkFFJ1RuZTQMme4g3X/WLAzjYdUgs5ndggTk0iDrA8n3S047Yy8VkY6Jz+jdl2Y59B3pKojmJdkJjDItorqaBja3kJMsaN1qPwwfCpmBPYz3bTTq5F2BZdm3Bog
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The helpers in binder.c wrap generic list_lru and task_work inline
functions and have nothing to do with binder. Move each of them to a
file named after its own C header:

  - list_lru helpers move to list_lru.c,
  - init_task_work moves to task_work.c.

Add the new list_lru.c to the SHRINKER entry in MAINTAINERS, which
already covers include/linux/list_lru.h.

Signed-off-by: Xiaobo Liu <cppcoffee@gmail.com>
---
 MAINTAINERS                           |  1 +
 rust/helpers/helpers.c                |  3 ++-
 rust/helpers/{binder.c => list_lru.c} |  7 -------
 rust/helpers/task_work.c              | 13 +++++++++++++
 4 files changed, 16 insertions(+), 8 deletions(-)
 rename rust/helpers/{binder.c => list_lru.c} (72%)
 create mode 100644 rust/helpers/task_work.c

diff --git a/MAINTAINERS b/MAINTAINERS
index ba45953bb..428992431 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -24590,6 +24590,7 @@ S:	Maintained
 F:	Documentation/admin-guide/mm/shrinker_debugfs.rst
 F:	include/linux/list_lru.h
 F:	include/linux/shrinker.h
+F:	rust/helpers/list_lru.c
 F:	mm/list_lru.c
 F:	mm/shrinker.c
 F:	mm/shrinker_debug.c
diff --git a/rust/helpers/helpers.c b/rust/helpers/helpers.c
index 998e31052..ea34101b9 100644
--- a/rust/helpers/helpers.c
+++ b/rust/helpers/helpers.c
@@ -43,7 +43,6 @@
 #include "atomic_ext.c"
 #include "auxiliary.c"
 #include "barrier.c"
-#include "binder.c"
 #include "bitmap.c"
 #include "bitops.c"
 #include "blk.c"
@@ -69,6 +68,7 @@
 #include "jump_label.c"
 #include "kunit.c"
 #include "list.c"
+#include "list_lru.c"
 #include "maple_tree.c"
 #include "mm.c"
 #include "mutex.c"
@@ -93,6 +93,7 @@
 #include "string.c"
 #include "sync.c"
 #include "task.c"
+#include "task_work.c"
 #include "time.c"
 #include "uaccess.c"
 #include "usb.c"
diff --git a/rust/helpers/binder.c b/rust/helpers/list_lru.c
similarity index 72%
rename from rust/helpers/binder.c
rename to rust/helpers/list_lru.c
index a2327f1b3..3b88d1a96 100644
--- a/rust/helpers/binder.c
+++ b/rust/helpers/list_lru.c
@@ -5,7 +5,6 @@
  */
 
 #include <linux/list_lru.h>
-#include <linux/task_work.h>
 
 __rust_helper unsigned long rust_helper_list_lru_count(struct list_lru *lru)
 {
@@ -19,9 +18,3 @@ __rust_helper unsigned long rust_helper_list_lru_walk(struct list_lru *lru,
 {
 	return list_lru_walk(lru, isolate, cb_arg, nr_to_walk);
 }
-
-__rust_helper void rust_helper_init_task_work(struct callback_head *twork,
-					      task_work_func_t func)
-{
-	init_task_work(twork, func);
-}
diff --git a/rust/helpers/task_work.c b/rust/helpers/task_work.c
new file mode 100644
index 000000000..cb961cd22
--- /dev/null
+++ b/rust/helpers/task_work.c
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (C) 2025 Google LLC.
+ */
+
+#include <linux/task_work.h>
+
+__rust_helper void rust_helper_init_task_work(struct callback_head *twork,
+					      task_work_func_t func)
+{
+	init_task_work(twork, func);
+}
-- 
2.34.1


