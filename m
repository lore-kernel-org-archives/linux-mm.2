Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32460CA1010
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 00:22:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90D968E000F; Wed,  3 Sep 2025 20:22:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E5CE8E0003; Wed,  3 Sep 2025 20:22:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FBBC8E000F; Wed,  3 Sep 2025 20:22:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6E6098E0003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:22:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 219E0BC181
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:22:27 +0000 (UTC)
X-FDA: 83849666334.23.E213631
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf24.hostedemail.com (Postfix) with ESMTP id 430A218000D
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:22:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iVcf8uoh;
	spf=pass (imf24.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756945345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=06EnX4xNHqiA4W3dBLh6+8AEySVO628YRMoxqtZgpzs=;
	b=v+fuEnGo2ScMH9siB1bPnrwHSL+5lOrykpLCDT/y0y2VTPbZfjfcMzNTsj4BN4pmwumqvh
	OHxoyh18GBWcgz1rv4o8FBDxnyrb03XDRzw6av1GIvJ3pyqiqmKjqH9JiKnRUvFgdz3oLg
	e42o3MBwaAQq5IIVwU02UMFC4rjlyXE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iVcf8uoh;
	spf=pass (imf24.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756945345; a=rsa-sha256;
	cv=none;
	b=LH2/6kf8h9krwm6kslDqB19hqjyaLefzJFpE37+MZV7GjXJHeNk4ylhfWw20o26vTzsAeV
	QKVZE6rIpXnVr2J2kEVoQmImqnpprRAmoF3txneXy9eg7zagXZD+oHbe9PCA7a7pcHsSGN
	uynUku8IC/k96zndIRNdIbzp67M3UWo=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-77264a94031so368968b3a.2
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 17:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756945344; x=1757550144; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=06EnX4xNHqiA4W3dBLh6+8AEySVO628YRMoxqtZgpzs=;
        b=iVcf8uoh5QnYosXzHk7xJtGZL9orT9gXmkgnybfDPd4kDCA1weE4keTrybLYOGXWI0
         30Urir/yema8elilS8ftRHnpnxO4okiTUDJy1tG5Ph6iJZAPAamWDXXOt90wN0uDBPd4
         qA7lMcqXrbE8XaFE2lETgUI7Qlz4IfNIqbqf2bqOV3FK9N3/atnjQTYWoamqIz77Xow+
         VrLXPWrk8UcESMM1ZrzCFjEBaN8jtB1eukb3cuhHwLi1O6bBGKaqXgxxloyFWZ0oLDXK
         zib/CoalRbFsqrlDLzXZ7iekY0ecEYwoigtcyKQJQDqQyu42MHT4r+kSJ6KbDUVTjfBf
         vSnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756945344; x=1757550144;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=06EnX4xNHqiA4W3dBLh6+8AEySVO628YRMoxqtZgpzs=;
        b=OI4KCVNpZsNzerZ59CETXdPnW61/Rn+NK5CPH2CHCvqFGtQhh7dpxuzosNzKyQe37x
         eCOcXNV+65Dqptg7roqQ+5Qg1fc7RGDKbTJ3OfUIayxdedzHnwmqM0OPYYee3mLT4BLD
         IokcOnNLWp8cawBSdz/vlTTU3BKAQapG3IQqHGiDaJcSGroGG/eHYkOwg8W0Boirvhk1
         OxighNcvajZ9O9CNsDNradnPydiUdjqHZJ3kIez5tZTI+PYzNy0+ybThWzigqcLkknfK
         9p54FKIqwYkg7fWSsqWy8T6KCnOalkTjz7Weyqx4Ry/C3He6r8/DGmwp0x/FVfpWZbeC
         kHlg==
X-Forwarded-Encrypted: i=1; AJvYcCUKQG8h8WX1C4m9nHOl/nqhCE3AgME9At4MxyOk0Y15fqJ/Mfx47iRkTs5inswIPFY1P0dT9BtRWw==@kvack.org
X-Gm-Message-State: AOJu0YwA3lSbzotONrHePKnH456oeL4kD93099sZnTuwoqP7bhPtuxw3
	BweHdCoiEfWzFHlABAwbcdlr3RG51TSFLy24UnYBCVjJrF4wzbCcnQm1
X-Gm-Gg: ASbGncu2KPIq8isxBw3uQTuc39SIeB7QUYssl6b9jC0MDg56+eAut34zJw7OaLDuaph
	Z5j0giaQgEhMqj8dpSC0MIEuidjUVLNQZMu583+ttYB6HfwfZ+7T3UZ8UjfkOOXR1ypfnz+trY6
	tyUIW8gjMRRGUsEIp7AfTF7PwWscXBw/uf8nl2t005yMyr0mGOuZkzNNuOv2ndVymRGXONvyAII
	v8XdM2g6T2DeCm9p8zdstlvgUWFpI8e7kAu7lEoNB907jYqTwhrnWYqPm17xgVJ/xOWgmeyt7EF
	NIBVFyEvZV14hD0mRvxuNNuo6VilgpjEeRDtL1XBfVlIipY7DOZMWlZ1SJn+7nZUm3toQjL6DRB
	kuAulFYomYAAaF233QvR4a/2VC7e5NhpOFS2Qdbh+BExrlLREbxz7tZWLFFHDjwM=
X-Google-Smtp-Source: AGHT+IEA5bFflP+ewlk1s4zRmV7WjxdLsMy01rCTDV7VoKPhFZJggfHFuKygnu201Hh4P+tgmpwDhg==
X-Received: by 2002:a05:6a00:b84:b0:772:1a18:b8d0 with SMTP id d2e1a72fcca58-7723e3d1d5bmr16156720b3a.30.1756945344084;
        Wed, 03 Sep 2025 17:22:24 -0700 (PDT)
Received: from localhost.localdomain ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4bd2aesm17579551b3a.48.2025.09.03.17.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 17:22:23 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH v2 04/18] mm/ksw: add HWBP pre-allocation support
Date: Thu,  4 Sep 2025 08:21:01 +0800
Message-ID: <20250904002126.1514566-5-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250904002126.1514566-1-wangjinchao600@gmail.com>
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mc89e7zao867u81f6xr3e3e464n66e9i
X-Rspam-User: 
X-Rspamd-Queue-Id: 430A218000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1756945345-436350
X-HE-Meta: U2FsdGVkX1/Cf4j5+Xh1kyDZUBgIKJrkCy7HWh2n3xsjM5UhEH/8rk6ROP6UMwiMskY9u41oTLsnRXbmUkSvRnP2Aom/N1sJ+du/6+pbbkGGXDaoIwGhcbVzMF+zXKBe23omRHi4E23R5kh+mX8sjL2a5aGLSOzD4b6rIk0elpNX4QV2cNuPzGp1LB4KD0QSR4iJ+cMVULIDwJwj0CKwNppsiUFZpI2de7IT5+Hhr9QE4ouYUwZGbVouwdIQynRUtWzesWP4uYD11tmFSQ5NCTaeqxCEcTX9NOYAeK5ABDXNbyGRyzcqlpbF49+y3b/yBnojjwo8A9BJNbx21Iyso/aTvaRI8ZCTGnkjS83m1wY+2lV3v5zpNOsxGz+0oAPzVCXYkrPVjW4WLvEc9DqxxUILmw1AsVqNJBx1ltG1ogw+/CJOvjU8F/LObhfdzyeh7mP8K0fv7UvHW6VBbKMnEwQsOmKI3bArC1SCXUeSejXhIpey2IXy8CkFm4JuunyKNo5br66RntQ8R1uhwVQC3SrN+hqxAsBFugstMqq63U3uDlJLDeC3lcWbAR5ZVfdTeYL0g7COgU+LC6Ei8xdFjMH8J9mLVJndVEJ/F+M6HzxtdnUVp9g8DvaCSGQV/5sxYNLt4uI2i6AGrefx790q0ExQmlXPk7Tm/bhM1+FL50CKCg/VdDKUYKJ5BvjPac6WOc/+qDa+6c+ADv9oOSiUf7LIZxScM4cgALoOhP52kGaacX+ncxaoNp0tO0mZWfdFd2EQ52e/WASJktvT+bvoH9C7xQsxYwLRKI85i02WVYSPncfQgILNYj1/C4a2HNsJoB11fqJAT/iwVxXkxRAQsYhrsLIpyrlwObXN9Ley7ci3FrHxSrljKbutuotFCFW34PzQ+MV44BrMsTSuxH3Dep1C64A2H5uvFw1P7QIpYiZhCl5KKjjjxF+yXCGMKyysLIosdn8AY/eAe7D55SY
 vLZ1FPFO
 pb3lvCQVF9OXyGvXGQ1/f2zhOfPeeldI4jKAo3tj+gHZvHq4xUMy6cokZvbe6qC0xpDiPkMksaPtm7MMBfMPrOlLwF7MPuPb4lNWM9yVavNOn7FHwKdYngUTqh9S/i/2o6CQcvJLQWQ0XzawoSCfEiUq37s7VH5OeNYryFW+2teSJXzfh/+A82Od5kSVdmeqAxZB+gWOU5UE6lu+VwKc20VMve2lkz0EqMN99Ued1g0yb0CqIhhLpo8MpLz1QgqVG6mGShRyIrDGKvqyovImBej7XyzMwPmQVmXNfdz9CjuVtuWYyJWzbt3r6/kuju7F3fKBJ3l/uDe4UTMPbO+p5fT4L90jSDLpL5ArPOClMesRPvQeZP87gGxeuIT5MDHt9itO+WZhaOuO67VstlbSIg1rZupYkB9MIi47Fjcxbf8jCgqzZG+m4y7v1QvTsFlG5dMsx8+h51aiCpUoaldGdYRIL1z8GWjZOmkzl332Bmskdmv3zFX3bjlLbhnF+IODzCN4b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pre-allocate per-CPU hardware breakpoints at init with a dummy address,
which will be retargeted dynamically in kprobe handler. This avoids
allocation in atomic contexts.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kstackwatch.h |  6 ++++
 mm/kstackwatch/watch.c       | 62 ++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index b5f1835586c1..2318779bde70 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -36,4 +36,10 @@ struct ksw_config {
 	char config_str[MAX_CONFIG_STR_LEN];
 };
 
+extern bool panic_on_catch;
+
+/* watch management */
+int ksw_watch_init(struct ksw_config *config);
+void ksw_watch_exit(void);
+
 #endif /* _KSTACKWATCH_H */
diff --git a/mm/kstackwatch/watch.c b/mm/kstackwatch/watch.c
index cec594032515..e7ed88700b49 100644
--- a/mm/kstackwatch/watch.c
+++ b/mm/kstackwatch/watch.c
@@ -1 +1,63 @@
 // SPDX-License-Identifier: GPL-2.0
+
+#include <linux/hw_breakpoint.h>
+#include <linux/kern_levels.h>
+#include <linux/kprobes.h>
+#include <linux/printk.h>
+#include <linux/perf_event.h>
+#include <linux/sched/debug.h>
+#include <linux/slab.h>
+#include <linux/smp.h>
+#include <linux/stacktrace.h>
+
+#include "kstackwatch.h"
+
+#define MAX_STACK_ENTRIES 64
+
+struct perf_event *__percpu *watch_events;
+struct ksw_config *watch_config;
+
+static unsigned long long watch_holder;
+
+static void ksw_watch_handler(struct perf_event *bp,
+			      struct perf_sample_data *data,
+			      struct pt_regs *regs)
+{
+	pr_err("========== KStackWatch: Caught stack corruption =======\n");
+	pr_err("KSW: config %s\n", watch_config->config_str);
+	show_regs(regs);
+	pr_err("=================== KStackWatch End ==================\n");
+
+	if (panic_on_catch)
+		panic("KSW: Stack corruption detected");
+}
+
+int ksw_watch_init(struct ksw_config *config)
+{
+	struct perf_event_attr attr;
+
+	hw_breakpoint_init(&attr);
+	attr.bp_addr = (unsigned long)&watch_holder;
+	attr.bp_len = HW_BREAKPOINT_LEN_8;
+	attr.bp_type = HW_BREAKPOINT_W;
+	watch_events =
+		register_wide_hw_breakpoint(&attr, ksw_watch_handler, NULL);
+	if (IS_ERR((void *)watch_events)) {
+		int ret = PTR_ERR((void *)watch_events);
+
+		pr_err("KSW: failed to register wide hw breakpoint: %d\n", ret);
+		return ret;
+	}
+
+	watch_config = config;
+	pr_info("KSW: watch inited\n");
+	return 0;
+}
+
+void ksw_watch_exit(void)
+{
+	unregister_wide_hw_breakpoint(watch_events);
+	watch_events = NULL;
+
+	pr_info("KSW: watch exited\n");
+}
-- 
2.43.0


