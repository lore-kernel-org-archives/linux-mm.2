Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E4ECA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 12:28:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70A416B0096; Mon, 18 Aug 2025 08:28:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E1A16B0098; Mon, 18 Aug 2025 08:28:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F8506B009B; Mon, 18 Aug 2025 08:28:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 496B76B0096
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:28:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 179BF83FF9
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:28:53 +0000 (UTC)
X-FDA: 83789807346.10.D25320B
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3A4A5180006
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:28:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VJzAutGt;
	spf=pass (imf16.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755520131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9/RS8QNjk0KWNIhfT85AHfvR5fdku6bJ5ncWD3++qNE=;
	b=nWRDn4Hmcw7rIjEpL0zzto29afWPFIGaUmYptsIM7/a9NoQXxLJUZmXcs91MZLtEc7QAKD
	u7+8nvzm10wvb7Zv2AKiDO36wD8YJry5jiuZXW9kOyMHARK3byCQdrybI048G2Lp8D3ZU1
	R6YsCufOiF2DPjfnkTA+NSWEWAR6/ls=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VJzAutGt;
	spf=pass (imf16.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755520131; a=rsa-sha256;
	cv=none;
	b=XC83rtuefRHxb0gk9OZ1l/a9FJaVla736I4jrB+W/262UrOQgudpcYxnOgaY5TRoN431D/
	WlF+pHx6tKTMz+ASKgPw9tQHJA2oJy0Z/9+51Y3ZJC24hLe1Z8uPC5bwVvL9xR/mRdSobx
	ygTuKUjMDMKlWBzx9cCjSzEkJqkHk30=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b47052620a6so3965136a12.1
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755520130; x=1756124930; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9/RS8QNjk0KWNIhfT85AHfvR5fdku6bJ5ncWD3++qNE=;
        b=VJzAutGtRXz0NPPAhKfyIqax5yukR3zThCZxKDNTHhGuDdOTpokg2cSxVw/olNSnXB
         2dOc+mmXpfHhzfIq+H1ZjfTFzKsuvqcnmCu8MsWotS1vokdLB8v9c5Z6ZQ4qxUrr1c8t
         jvXpPyYp9lfLoUlZw7lRzAcxehM3FYLvgOXx+0Wyqs2iZccJGFt2ej0OaCPf1um4112B
         WKR2wqBRlUCeoBwmNyZko4BrMURRcaEw1lluLY9fLExFxN7GyX1dkI4PPSpNQ42hL2kt
         4RwFXZUOyQqbV5FGH6KTKMVJM+oRctEGQVK+LUJxjQvWC/Z5ZYhiZoinF8s8LxNEKyTc
         9vYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755520130; x=1756124930;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9/RS8QNjk0KWNIhfT85AHfvR5fdku6bJ5ncWD3++qNE=;
        b=V+cj9EDIXjmNgGkIMi2NrfPG8oP0GCYsIcHRIyfjucnnYu6+1kQDaxC97CD/bXgi85
         3WG8G0PdjjQStWbmoxP3l2faTrtYWEY9nu/FyzayHkIbyvRiNsewe/NngMCWKmgo/rWP
         SdgBxKZsFQX49RF7tX2/orqkzr0z1QWhS22zAp2OPtctmI80xm6ZAwaAtwt+mh7MFwIM
         Sskfm31JaCNgRgmoM3siVpxtFOW633ENEBZecF+WFrIG7mnEnkLgGzcHd1dKjU0NPcSB
         q9AJ39heq+UOwnVizjCaeQTkpJt/YE0jthBuUE2bKD9vTFuhe+CSYEbDF5eRIGqDukk9
         YHgw==
X-Forwarded-Encrypted: i=1; AJvYcCWSm44FRY2uH2wZ/vzb2F74LzbuqlipHBpDi+M9HDQANcJfbWjn51J3mKWFjih0NWfLazMVG76Wgw==@kvack.org
X-Gm-Message-State: AOJu0YzjwdE8ICbnfooEmHBD64CZM27oD5D6qt7BHyfU/lf6bRncGKCx
	05e6aBmhG2+b6L1By/N8hGpAIWSSVKoWfV3GsEUAEYwunZ2l1MXEgQGV
X-Gm-Gg: ASbGnct2xrj4wfsu8K3VARQqbrCjWlkFu2efTsb/AdMGfBDD9UFFdthD65kHnlJQU2d
	R6qYr20Afg5ps/Q2oZvHmbMg0JRt1ZSPqVSvXitq+nYIydnBX8+bMqtKZMjoV8Jdgnd8UumPlq0
	S6WzAeZNmdc6owy4BU+7S/Z3YMsTBg1z//hzVo4vl8UyudbcNDVZKr+2qynd6MnbfvJaSiYymdx
	P9uPq5vahMsvEIt6Ajz8r1vuKA0uZDCrI6uknDM9FzRybnD0l5vEsOKJvMHrBacmbVLQ53K6DRp
	6q3XKppbWiF0JCxMnGR0I2y7BErL+AbAXL4+JwaMhAnuQXTZBTCf2myEGLMjMtD/Sl82W4tGbST
	TcxcsaokRggaGFdFuQn/J+BlMOueepYswZPphpEbLsSUi
X-Google-Smtp-Source: AGHT+IFshKCn58LpNxaRlYFZ6LZcaPJSmzPeYiERgbkx+OgOwBhC9613S8BZN35Pd779veDghhniVA==
X-Received: by 2002:a17:902:f550:b0:231:d0da:5e1f with SMTP id d9443c01a7336-2446bdd72ffmr162785695ad.21.1755520129990;
        Mon, 18 Aug 2025 05:28:49 -0700 (PDT)
Received: from localhost.localdomain ([2604:a840:3::3008])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446d57f12esm79236705ad.157.2025.08.18.05.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 05:28:49 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: akpm@linux-foundation.org
Cc: mhiramat@kernel.org,
	naveen@kernel.org,
	davem@davemloft.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [RFC PATCH 11/13] mm/kstackwatch: Ignore corruption in kretprobe trampolines
Date: Mon, 18 Aug 2025 20:26:16 +0800
Message-ID: <20250818122720.434981-12-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250818122720.434981-11-wangjinchao600@gmail.com>
References: <20250818122720.434981-1-wangjinchao600@gmail.com>
 <20250818122720.434981-2-wangjinchao600@gmail.com>
 <20250818122720.434981-3-wangjinchao600@gmail.com>
 <20250818122720.434981-4-wangjinchao600@gmail.com>
 <20250818122720.434981-5-wangjinchao600@gmail.com>
 <20250818122720.434981-6-wangjinchao600@gmail.com>
 <20250818122720.434981-7-wangjinchao600@gmail.com>
 <20250818122720.434981-8-wangjinchao600@gmail.com>
 <20250818122720.434981-9-wangjinchao600@gmail.com>
 <20250818122720.434981-10-wangjinchao600@gmail.com>
 <20250818122720.434981-11-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3A4A5180006
X-Stat-Signature: h3sdknsswtjqn3cr6yfgm8at5gbpco9u
X-Rspam-User: 
X-HE-Tag: 1755520131-873314
X-HE-Meta: U2FsdGVkX19/jMYTS6RoBgead5vgxwGqQVplZSs5ky0FyQFUHnzAs6jik5DbxFWzTEWnIQn0gg6YVwNHShF5MqQKvbwt3CeQx3Oi95o+g1McWOtYY9iuc+eoUlrY8D/81JjH5u5VWllNvG7fYlhcPw5LtfeiZjuuoRXNthSzyOwpBY5kPTHNKrQZhOKJwBqV4MfZi/PRi+qKTCWVXKXIwPxMjzxv/tb0NxH9XiBhNaL/Hk5BOZ7tM7wY76z26o70OWgt08M4o0Ai/bFoKj5TlD3gG3lQehINEvr15LFwUTh+UXols3ca7helTimvTJmNO+204celhHquNJkuSX3i75AXa8uMZojWmuNbQvvN0jVOOoJed7v3vJHs5BRmTUrsBc9+50bIjM385QN6TOoJQUuzNWsZkKN5MyYoj2fCK2fDsKf5wEbR33KtcOvzBsVAMNMPBabjGyNXcBZlFUmpFIOclAEKwOgMYJKNtPkxFzDJkio1EeLcoL5RSd2OZBnn1a1xzIO8neV5nSXOKdKtr40FRD4RmJxzjddz+MPsT3ITEHkG4x3PhvLpdVHciuq4DjH12azEtEtegSfZ+7gLbYXW9jFRatgcq8V61czTgL3N2VXjc+4Agpj2z5/ep5rHipJ3W9eHXObjEB+00/cZJrF1nqSsS+9kUYEoxjdZlPJFJ/5QX4cmbZ/mpjNkD+JVf/LZvXKthYyPJ+8fFJe4P3Gh0cFvUwtMPQ+ZUHkUNaaiRMnH+btRbDQAM8siSTgA4BDs0FPeeQpJ7Y7wiai8K6GJ3TQ6+FTYao4+GXsdlDSBqBQmShF9+vutCTOA+Y6fGntv+SEQjqoZMHO0YZ6Ya7Y3lV2PTBncM3UgjL/tR5YoKR/T3xsA7oSpDBecaR4TZ3UjhHsCFsq9O5pwaSUbrLkLOc8KVpoPDzVnX9QW1TjgatXQE0Vlc/946N4WQduVkXjdGJqFoKeIGCB0wjc
 Jo+VzVJ4
 j3AzyhECrzVSSdI3T55a83nDYm7JkH/GJMG8MYbpTOai5Zw2TP5izXaaPcLLJBTXaxYDcG+wwjIRgtuQQK2BwivIWgMY7ajDyfSWZ6sCPutEwe7BtuYW/0EvvQL3tY+NUZ7eULp/TG2R8/mrBlbbOC7pFhHsmGfajh7WSrRnVAcY6Q0T9AnKtECkqGKxmUVVrjXgwSlVyUSVxChsmIibFRorBKjlVYObo0FNQ2RkI0blPTbrGA7pO2zUGFgdZzR+ONfiHexr6FcfGJo/n/BS1PcXQYGE1afkDKoEH1mqlP830/x4hAJgjhLYL1hRhr0hfOcG49tEngQBQaIh/+FQ9HqzhGAdiintHqYRxTA388pw1hOGMHzBed28mk4Q+jeW3PK2msiVs2A/9vXyp7UfTa0pTZfat4MUc3blHDrPAMSgR58aixtVQCa0PHTJDeON+vyLN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000002, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch adds logic to prevent the KStackWatch tool from
triggering on events that occur inside `kretprobe` trampolines.

The `kretprobe` mechanism temporarily diverts execution through a
trampoline to handle function returns. When a HWBP is set.
It can be triggered within this trampoline after the watched function
exit, and before the exit_handler called, leading to a false positive.

The patch resolves the address range of the `arch_rethook_trampoline`
and checks the call stack within the breakpoint handler to see if the
event's instruction pointer (IP) is within this range. If it is, the
event is ignored.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/watch.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/mm/kstackwatch/watch.c b/mm/kstackwatch/watch.c
index 7ab247531961..1b4cf5d42db9 100644
--- a/mm/kstackwatch/watch.c
+++ b/mm/kstackwatch/watch.c
@@ -31,11 +31,48 @@ static void ksw_watch_on_local_cpu(void *useless);
 static DEFINE_PER_CPU(call_single_data_t,
 		      hwbp_csd) = CSD_INIT(ksw_watch_on_local_cpu, NULL);
 
+/* Resolved once, then reused */
+static unsigned long tramp_start, tramp_end;
+
+static void ksw_watch_resolve_trampolines(void)
+{
+	unsigned long sz, off;
+
+	if (likely(tramp_start && tramp_end))
+		return;
+
+	tramp_start = kallsyms_lookup_name("arch_rethook_trampoline");
+	if (tramp_start && kallsyms_lookup_size_offset(tramp_start, &sz, &off))
+		tramp_end = tramp_start + sz;
+}
+
+static bool ksw_watch_in_trampoline(unsigned long ip)
+{
+	if (tramp_start && tramp_end && ip >= tramp_start && ip < tramp_end)
+		return true;
+	return false;
+}
+
 /* Enhanced breakpoint handler with watch identification */
 static void ksw_watch_handler(struct perf_event *bp,
 			      struct perf_sample_data *data,
 			      struct pt_regs *regs)
 {
+	unsigned long entries[MAX_STACK_ENTRIES];
+	int i, nr = 0;
+
+	ksw_watch_resolve_trampolines();
+
+#if IS_ENABLED(CONFIG_STACKTRACE)
+	nr = stack_trace_save_regs(regs, entries, MAX_STACK_ENTRIES, 0);
+	for (i = 0; i < nr; i++) {
+		if (ksw_watch_in_trampoline(entries[i])) {
+			pr_info("KSW: Found rethook trampolines, ignoring hit\n");
+			return;
+		}
+	}
+#endif
+
 	pr_emerg("========== KStackWatch: Caught stack corruption =======\n");
 	pr_emerg("KSW: config %s\n", watch_config->config_str);
 	show_regs(regs);
-- 
2.43.0


