Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80BA0CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 05:24:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC3A88E0007; Wed, 10 Sep 2025 01:24:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D788D8E0001; Wed, 10 Sep 2025 01:24:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3C7A8E0007; Wed, 10 Sep 2025 01:24:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD74F8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:24:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 58A57C06F4
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:24:39 +0000 (UTC)
X-FDA: 83872200678.13.72F14EC
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7CE34160002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:24:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zat8Nm8K;
	spf=pass (imf08.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757481877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BQYOiNSD0BVFYt8LJn6Fepybq7p8FLHlj9qtf7JwQoI=;
	b=NzU9e5spIIz2mm1viSXZusxUntvLy1WhMn8zVxJKDq4zQf294B6M98oNziIB5V/Zk2hKLc
	CyakGzeGiTkcowFsQYWEra4iNTVSEUoqzfk4ab6dcS7zEGAIakoWepq0WRy9ihU0z2ldpD
	Kde0wsv7cuFAoWzlB/AV0JJQJrFUsD4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zat8Nm8K;
	spf=pass (imf08.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757481877; a=rsa-sha256;
	cv=none;
	b=LLuGoIgJEty32UWb0SafWASGWMHfGik46/+5Xn5LwlVbo8UXDBg18ElyOGt4R1yXBWJauf
	KmH/aiiDfk7DSN17vw8xTUsUXSw4xHk32f3Gav71GVtqCIXz08ZoX5Hp+eyn3/IpRqXZJE
	ER0KtgODxmqYxQ9uxJPCT1TQhvmK2xo=
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b4c72885c8bso5309148a12.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 22:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757481876; x=1758086676; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BQYOiNSD0BVFYt8LJn6Fepybq7p8FLHlj9qtf7JwQoI=;
        b=Zat8Nm8KycGD40KkVmSOQizRdLhWG4gC3GhWxlsXBTiZo6CsSdApcvQpsE0G6tmZDL
         q59IU36hsMmGjmqfO4kcKZb/gPK6A/zU5qLUI/OFAt/PHNIrFkQPl6AK+SlMcYl2LnQT
         aJdfJ75EG/fspALon/9Hx/B+VOzlWehkQ60EuyWHFeluaMti/vQH8OpiPvMWje6nPllz
         3ORdxCf6uZkPGMqVz5W91WaVd+c4zOylVcPmfr0wXcK2cN2SzjPkfW14AI7oMut6PDkB
         oDP0AMl/YNbXV8FY1OnOqORS7MYud6Ev3o0fp8Cbkx0trO5SpT1JuVryQidYDnxa9lm4
         a3pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757481876; x=1758086676;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BQYOiNSD0BVFYt8LJn6Fepybq7p8FLHlj9qtf7JwQoI=;
        b=UzCWX8zzLifDkPRqf64j0EtwXsP5WE7d8clRrhMntJjmMccW/zCZ7Md0QgJccFHU2A
         bNDuT2zrsnUA5seihURUYBrGoFVySIWIqAcozJ7ol+p4RL0lucovEO9p/QiyLoeVEJh+
         tkQcEWwYl38VPSfxhCeDvyLhsJIUaGeEThR777sSgF2uuD4OO92XVkvkcHwFcTw44JGG
         +ztJQoIbAGr72odhF7eMx2wFJxorMS/8uKFbR5RKsWA6ubGSl9UgMDQjmOu3Np9DEqR6
         AM9Hg/uJqON1i6Q65q7rYpxWeH+B+v1UK2i03EDT3JdNlyfvjsyUlD6FjQx7pfjs3WWM
         SwYw==
X-Forwarded-Encrypted: i=1; AJvYcCWCFLUA6B3XM463K4RW6E6FwJQeqAGZOWrSwrRrDYkfwIQYlJqc7fZ5UNNjLgzPHI4lIIcdLSHbFQ==@kvack.org
X-Gm-Message-State: AOJu0YyxLA2NGENNS677yqYbQ8HBB4FSxOYZrwOL97Qfc+IaXvYt+NV1
	YQS7EaMfNm0aFrPakdZfvs9ohG2tkKGM8lnjXfUg2RrI696w8M+WYLDT
X-Gm-Gg: ASbGncuA6vkN7JiyXIErJcr09qKuElYDfnjZ6AvVGBrNRD4yOSiNpJfsu9cJJVpE83B
	DOwy+3DiKf60cfd65FzidzfLPqiqUzCsSGmz/hrIszUbjsRsOnsdJcbsD6tonL0R+Gwzipuo2fV
	akEgMdJ+oEkGv5wAu6kCW30ImTASVKHprvOmdxl64Zsxm+lY1pi4BUWZNsUIUYmjR/7ULUTGpaB
	eqyRmqMqi6KOEz5WeJ4cvhH1LE648LgqgnJtsPPHMKyrYWqZhlGr31LXUPtKUI77jdcCV68JfAm
	FFCzhRLc9Q1EnkrC12KGN61YEuJ9/Q7y6ugDVKVPafWKep6h3lsMOcJzYQ6kxJE6lHhKnx6DEzA
	+OZADMHN8BeaE4S+tqdHlktPBjBZZ2aMLZA==
X-Google-Smtp-Source: AGHT+IGrE4fctqYtjowG9QSXjEAoPEpi/FvbZq/u2mOblf0m/w0KO47bW05N3FgRHvP8LO7tJLRT9g==
X-Received: by 2002:a17:902:d4ce:b0:24c:7bc6:7ad7 with SMTP id d9443c01a7336-2516ef53bb8mr204775165ad.3.1757481876261;
        Tue, 09 Sep 2025 22:24:36 -0700 (PDT)
Received: from localhost.localdomain ([2403:2c80:17::10:4007])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25a27422ebcsm14815125ad.29.2025.09.09.22.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 22:24:35 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	kasan-dev@googlegroups.com,
	"David S. Miller" <davem@davemloft.net>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH v3 01/19] x86/hw_breakpoint: introduce arch_reinstall_hw_breakpoint() for atomic context
Date: Wed, 10 Sep 2025 13:23:10 +0800
Message-ID: <20250910052335.1151048-2-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250910052335.1151048-1-wangjinchao600@gmail.com>
References: <20250910052335.1151048-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7CE34160002
X-Stat-Signature: canmcf9hafuk3s4ykkrcyo1mxrct4w4w
X-HE-Tag: 1757481877-761766
X-HE-Meta: U2FsdGVkX19ghCEY6u7TFyUagLcyN5fQuYyjj90IIfR5XmoWIGvw8PD81DkN44RMTu9wA6M17W/rvks9hKpcqO+aAUVsMbd8C3gogLH+acgAIZKMOuQpAwWVQ0Kqxbgl17pU9WMPHJmUTKDSB1vfvogWwzmqn00w7g1ydS483f9eJWucYfiV+HivyGb9o+KbSJj8R2Nw4HscPeDT/RyhnKHciqtRpXaff0UssWyf9PAqwBg2hxGHgJqVDofdHpc7U1iS+TKZH1pQHi12Idnse6R9pZPQHw/4gw1bUq9UX/w2OQLDcMqMs+bekkPMeukv+GP8eVyC+/S2WP8wnFYSOS2osBmAOIOnvF5mq60Vbs2CeMB+ceGd0gVeIE8opOl2WzRSDopJyKE/izlO0D6gOG68Qd5ZHfxrnyehbtZ2lRdaNG+0gIeGIiQJ9fEDDbHKcKSnRcWwgULXeHmEWAU3eCqWNIc6MRwER9RvVzwtAfw6SDP5vSd5qF7Vkv7m/tSgMYCHLrkYZvTjtvZA3++7MXzNJNFQG8y1AMVHVrtKulv7MdDhyGpzVjKK90uF9UKxyjAsDaWFr/tJSRVj8p/XE2IwUdE+yVacwfJJck/wE8Riy0BuF+jIZj9IqkRH7Kshy5lWwjLeJmx3/Pam03zqENhFlWKibMIyy59tyGEV9qacaYdqkuZkR87i4ozm1m4UO/1R/7ypsWTvsV1+Yr7rm8iBEyFahRo48eiEKgk0pn7yB4Do8Nm/E38LkO4Q/kx373KxITHqnDr2/3z/cJm1PMY6HgXzIRZ3C/fpAwU4kAW/ED7AQcyObL7fEjtBtlWfXoQ14f6VzazzEgD8J2Kx9I6Hsbux3GHf71mGd1/kO7SphQv8q3pyg4JtgBlguJ0DBbv07bOR2Is8LteqzREJmZNDzocPuLaqYcZ0Py6bPDm55u3/Jv7sxB95JUeJl6Nacfqv3m2aXV811CuGjbm
 PmqO+OEw
 j8BuPfB9jZmtTQAsHZ1/2qqLCWk7vqTei0YDeX6SfM826tcktOnXK/C3VgJ3z/86P9ifRABl2n5JJnp091/4HeyMVCTH+H+CgP7sj2RGKFW68s4/V4WQI+KxcFRsfsPo14SL++Q6rn4IeIinv+J9d+robFAHWw1LHMB+x1p7DEUqq34yrzztdb4acKfSjtimX5jVB0b3kd9klsHPDzv5w6TqHjKp6a72olp1o2iLeBmjvVf2URArbkoHMzrFzGKOYxe3nresrLQT0Fg1GtvX3ECeCrLiFvWpI+Czc+aqOSCp5TRqEaCBBkqVkn8auMlC6maHrHkVHbM8ufQZX8Ee8xWjnJUoZx5x2LC2PCd7u0ilw3Tw+XpoP94RrJuEpOXohYumUSdRRUBCIeUy53ncAdhoQn8TT3SL50Gjp4kpTITZDGDG3Xxp082S7zliU08mQkQr86XQNEXlbozDpGd7QDH+YYF3cCsMeDm1lp3Fkj2irlXODb6KnnalVr4EFCuz7eMPRp1BE8KE46ZJRaPa9EKEqpO49THo0IszbGChLHihtri8l1rDcVyVfg6a4Nby8RJLWVFJbXUYjxWNBJEcH1a1TQbNriCOQ5L0n
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce arch_reinstall_hw_breakpoint() to update hardware breakpoint
parameters (address, length, type) without freeing and reallocating the
debug register slot.

This allows atomic updates in contexts where memory allocation is not
permitted, such as kprobe handlers.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 arch/x86/include/asm/hw_breakpoint.h |  1 +
 arch/x86/kernel/hw_breakpoint.c      | 50 ++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
index 0bc931cd0698..bb7c70ad22fe 100644
--- a/arch/x86/include/asm/hw_breakpoint.h
+++ b/arch/x86/include/asm/hw_breakpoint.h
@@ -59,6 +59,7 @@ extern int hw_breakpoint_exceptions_notify(struct notifier_block *unused,
 
 
 int arch_install_hw_breakpoint(struct perf_event *bp);
+int arch_reinstall_hw_breakpoint(struct perf_event *bp);
 void arch_uninstall_hw_breakpoint(struct perf_event *bp);
 void hw_breakpoint_pmu_read(struct perf_event *bp);
 void hw_breakpoint_pmu_unthrottle(struct perf_event *bp);
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index b01644c949b2..89135229ed21 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -132,6 +132,56 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
 	return 0;
 }
 
+/*
+ * Reinstall a hardware breakpoint on the current CPU.
+ *
+ * This function is used to re-establish a perf counter hardware breakpoint.
+ * It finds the debug address register slot previously allocated for the
+ * breakpoint and re-enables it by writing the address to the debug register
+ * and setting the corresponding bits in the debug control register (DR7).
+ *
+ * It is expected that the breakpoint's event context lock is already held
+ * and interrupts are disabled, ensuring atomicity and safety from other
+ * event handlers.
+ */
+int arch_reinstall_hw_breakpoint(struct perf_event *bp)
+{
+	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
+	unsigned long *dr7;
+	int i;
+
+	lockdep_assert_irqs_disabled();
+
+	for (i = 0; i < HBP_NUM; i++) {
+		struct perf_event **slot = this_cpu_ptr(&bp_per_reg[i]);
+
+		if (*slot == bp)
+			break;
+	}
+
+	if (WARN_ONCE(i == HBP_NUM, "Can't find a matching breakpoint slot"))
+		return -EINVAL;
+
+	set_debugreg(info->address, i);
+	__this_cpu_write(cpu_debugreg[i], info->address);
+
+	dr7 = this_cpu_ptr(&cpu_dr7);
+	*dr7 |= encode_dr7(i, info->len, info->type);
+
+	/*
+	 * Ensure we first write cpu_dr7 before we set the DR7 register.
+	 * This ensures an NMI never see cpu_dr7 0 when DR7 is not.
+	 */
+	barrier();
+
+	set_debugreg(*dr7, 7);
+	if (info->mask)
+		amd_set_dr_addr_mask(info->mask, i);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(arch_reinstall_hw_breakpoint);
+
 /*
  * Uninstall the breakpoint contained in the given counter.
  *
-- 
2.43.0


