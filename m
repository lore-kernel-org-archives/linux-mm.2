Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EA0DCA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 12:28:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEB3D8E003C; Mon, 18 Aug 2025 08:28:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC2FB8E0003; Mon, 18 Aug 2025 08:28:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B000F8E003C; Mon, 18 Aug 2025 08:28:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9C5908E0003
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:28:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6A4BB1408DE
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:28:28 +0000 (UTC)
X-FDA: 83789806296.13.10A1540
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8F9C21A000C
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:28:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C6gIySWf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755520106; a=rsa-sha256;
	cv=none;
	b=7L8nqyPMUuA5IMqV0OMdHcqX1kyXNqhYV7JT2N6bzOYpCQlvpa82vspOyhuFHszYNZUj3L
	ZK2svLrM8j+xmLyVbKR+SaP9oiSgGgRX1Iew47FaE3aEidgRSWLsCeaFUqaTey3D4Syqw7
	EYoRdKYrVxBErKtSIKrrGVUHJc/H8l4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C6gIySWf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755520106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wKDvPcpYKvhUCRu7u5ZD1MVAzzFCPS4KkCyAHcO/poY=;
	b=P0S5o+EmFqNIFv5a7bFRnj0J7d4d3T2KJa24lsazs2krfENvqE5kt4UEQlTcS8H/SqE0FI
	JkfjQtbeZac3sup+TauwaG0xOVVYu42QiISdPeImvTFTimHOZ6pA7wcTlnOHsNEtYJqirL
	OT6aBnHfPSjvHz1IJFZelJigFfQMW04=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2445811e19dso30964295ad.1
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755520105; x=1756124905; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wKDvPcpYKvhUCRu7u5ZD1MVAzzFCPS4KkCyAHcO/poY=;
        b=C6gIySWfhu8VWfb7Ao9eLE87Y3ro3Wug478zOgWIgdTd5oL95BIf7PeEHUy6hMogdy
         qhWC5FXFcWS0KChbQCxKegVdAF3LQCwy2CH/WwpBjQNEW7+BZ4QLKIVLI5TM7OfE0oHr
         DHobr2XSFrQspttPmSMsKa1C4XjBcrGk8tQha5IE1kL72ZmQicME2f6FI8tmxDyrFjXg
         PvzZ4c7Pb7cj3oJVWHhWDcsgUbJOX5htRza1XzWvKTB3207EXpGETguLarrq/mApMV2V
         976IflcpEmIw877Q8x0oW4FsA5D2WcaPjq+7erpFnGsqzZq6iB97Y1WBorphe2lvahZ2
         lGCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755520105; x=1756124905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wKDvPcpYKvhUCRu7u5ZD1MVAzzFCPS4KkCyAHcO/poY=;
        b=iXLzeJQXcEvScpVK6jS7aGM/FdY232CSTzh+1p/6XLILtw9jcWG9JDdbocb4BMiCWq
         D31fyv0KfsgOdM/f9YMpoz3Qwb9EY/sxUssEaIxloUOU4opv5OWnLg/NP14czwKEu9FR
         Xf4y1FgKPMBkzxU/W45ZqefxgAkPlqcPKvz7nmbELTrLjPC95MDluEEqQx+q3eK18QRs
         ivwVITS0R1bwDRZXixIrMT45TODlvmqAs3udJPvDHZqpIuKZHJpzXgMLvJxD5Zx0mxOJ
         41NkT4Nk0r5VXgrcoT4VB9ehsR6/AIWm4dJ1KB+UU81oGnNalgDrNCMViY2t99QTZZ6b
         6xuQ==
X-Forwarded-Encrypted: i=1; AJvYcCXXOYXJ+44tTfhKkYoV9bBVR1og/LDQZC5+dhsJtAsFv1kX7QxQ0o5CGYz1ZYIh0s6SYpw08FSL6g==@kvack.org
X-Gm-Message-State: AOJu0Yw337D+f9mQMENljYpxNAtbxvxs8WZ+io+pGhuxCzUM9auV1TMi
	2/ZFz3qoWvPmOD0CuNFpxAn2As8eZ42MhJthbjbKPu/opdmW5nUkAZPC
X-Gm-Gg: ASbGncsmyhHWZHOC1sb4Rnvlm+fFUaDy9yTzTeSzcFGB2+6AbI7yoQkD6qOvtzTpUUm
	+qbyEx4hKedqMA87bNoH/jLmr+3/VsgO+LIxXH946ri5YhlliO6D5ZEVC/ohkqIAZOcFcpAkIE6
	/ydvGa/NtWBAc0rdJ9+iLsY2NKhaSv9wNw3EPxwSDJq19kgtbe3i+FbbF6bzB/Z4r6wijmsUxO6
	lEJEzKqRoS2Me8slNnypYp9qdLPH0r7tRQuY0jz9yLqoATPqgI0NRPYhMd7cIcCC4VgZNV0VZ1P
	aS53cj5qe0ZCdZOnoCkZMfrRGRzDbnyHbUHf8bwLFeZsjDzqzmKdDo+/086voQjxMAItEMd4JcD
	678bajMBi71DK70LVi8gRt7itXEfj
X-Google-Smtp-Source: AGHT+IHqxDjVWhE3iAZ1X67hYb9HOz1KKkxasAVNPhwxJzmSbHWpUcT79VGyxRMFfFsWEKif1OddXg==
X-Received: by 2002:a17:903:2f82:b0:244:6c39:3383 with SMTP id d9443c01a7336-2446d709449mr143610625ad.21.1755520105347;
        Mon, 18 Aug 2025 05:28:25 -0700 (PDT)
Received: from localhost.localdomain ([2604:a840:3::3008])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446d57f12esm79236705ad.157.2025.08.18.05.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 05:28:24 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: akpm@linux-foundation.org
Cc: mhiramat@kernel.org,
	naveen@kernel.org,
	davem@davemloft.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [RFC PATCH 07/13] mm/kstackwatch: Add kprobe and stack watch control
Date: Mon, 18 Aug 2025 20:26:12 +0800
Message-ID: <20250818122720.434981-8-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250818122720.434981-7-wangjinchao600@gmail.com>
References: <20250818122720.434981-1-wangjinchao600@gmail.com>
 <20250818122720.434981-2-wangjinchao600@gmail.com>
 <20250818122720.434981-3-wangjinchao600@gmail.com>
 <20250818122720.434981-4-wangjinchao600@gmail.com>
 <20250818122720.434981-5-wangjinchao600@gmail.com>
 <20250818122720.434981-6-wangjinchao600@gmail.com>
 <20250818122720.434981-7-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8F9C21A000C
X-Stat-Signature: gskdzamdhfaimxn8miaemzuuzao7nhpf
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755520106-906113
X-HE-Meta: U2FsdGVkX18Z4IGL6u8kl9sfuuMAOwY0tLCifqTKunuf1chslQ4Bo28qeqKre3H35vFJrGgQxBvv8uem4B0zlCx7h8pMRA+ECM6g4aVWC7mXQ0uT+S1AFYgOJ04hfB1bCva3Ixg3JC8UA0hoeZX/A7BHtylTlRSBtHdl66dbu6V670+Py51bmDRNJjMGT4aUSKKecKok0u9EdXRDIy7mkWBRDKxPxaszNzZ/7ujBfQmfQ1hHEkvj5Q+nchb1CN/KKnh6N7zebukHt1SRMUWn0F7XO0jfXx5cKiTENvBQ30k3Bw8Nrb8+nwnfNAySS9YEdfuw+NZkcmVLtmaJVRviNnJBRuvT1XJoFOncvQCk+2bw8c21fUV5UA+roOUOvV7lWetogb9h9jcOmjrDxghjKJcobLknHaJfVAfc4sfA78aPE4iqOZ5qbIL9QdqqCzwTJiu+0ci8YHqJT7iNCbqiY2DQYp3jJiw5TWlpmk7kvGYmShlC4kdvjNW3kdq/ITHsr+7neLFL0BTqRi8CJuVNJ9/Ht8XGuLinJM/SFRQ8CCGFESatqjHq2keOLfZmhpSBc3hjujuH2wNH+VXeWtsGT89RuuHe3sDHBxtjHcE/W9O1R0EEQnFAuYQGL1i4WTJ3ViCwt7uVuGezs7DraceiA4hhSm6PWBj6iQ1meyxt+p98ISnrTHBK/3mu9kriQlAU3B/tr7PHS297dYNxT7CM6kNHBnQqcxR4yy0N3OXFwg6oNu/sEfeHDw4XOZUNXkPU9a1mfxmX3Q1dWQj2wuPw65/+LwWCXk5dCmMfGduRhvPgUc3mgRViRMnP3kWmRifiOmtoAdLspmBWsUzghQo9yLDZyWPGHbzk1wsbCcvzrYWM8gXm3Z5/elNyZ8cFZR2xPS+DLFvWGUCeu7uR3I9uMNLkoYwuFqDBwxRD1cr379qhTEIIcK5aWuhUoSUFantpUEt6Rbr+CaypixHCU1D
 gsQC/0Pk
 cFCZli7qKWkisaytwuclb56HzyLYiogaBnfpWX1KSAJVS/LTMLxEvTGwQcERMnmCIYvhqLaYYTg5pEVPffRi3aYXneZBaSuDyW+80Io2qp387l9cg6BtChmokp4P/29jhgxQJj6tLJS9A+UJUbEuqJOQMvwwsNdaPam+CE6v9aOJNSAAUxYqq0kTjd38lVp/HUJnQ3DS9HAOtBYDioFVlXyxOAbJKJRNQ8aOH/OUjuM/WThrc5c/VjoQLlB2UEftKNVYlR66/DCdswFHoQirOuT7/f46o16cSx5CNOqmHqYkQBaRh57uIB0qEXjK8SKYVI75bXvps7WQoujrh4cyWIQZW8pxNtvsyqzq7Ok+PMlnrmN5tVDfzmdnzzdeSP1m8VmZK5KqiUGfMaCiZoMdNEWgjUA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch adds the core logic for controlling the kernel
stack watch mechanism using a combination of kprobes and kretprobes.

A kprobe is registered at function + ip_offset to turn on
the hardware breakpoint that monitors the stack. This allows
the tool to begin watching from a specific instruction within
the function. At the same time, a kretprobe is registered to be
triggered when the function returns. Its handler is responsible
for turning off the hardware breakpoint.

By using these two probes, the tool can precisely watch a function's
stack frame for its entire duration. This makes sure the HWBP is active
only when needed, which reduces overhead and avoids accidental triggers.
This also provides a clear and reliable way to manage the HWBP.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/stack.c | 86 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 82 insertions(+), 4 deletions(-)

diff --git a/mm/kstackwatch/stack.c b/mm/kstackwatch/stack.c
index 8b558cdbda97..ba5280787e8f 100644
--- a/mm/kstackwatch/stack.c
+++ b/mm/kstackwatch/stack.c
@@ -6,8 +6,10 @@
 
 #include "kstackwatch.h"
 
+struct ksw_config *probe_config;
+
 /* Find canary address in current stack frame */
-static unsigned long __maybe_unused ksw_stack_find_canary(struct pt_regs *regs)
+static unsigned long ksw_stack_find_canary(struct pt_regs *regs)
 {
 	unsigned long *stack_ptr, *stack_end;
 	unsigned long expected_canary;
@@ -33,7 +35,7 @@ static unsigned long __maybe_unused ksw_stack_find_canary(struct pt_regs *regs)
 }
 
 /* Resolve stack offset to actual address */
-static unsigned long __maybe_unused ksw_stack_resolve_offset(struct pt_regs *regs,
+static unsigned long ksw_stack_resolve_offset(struct pt_regs *regs,
 					      s64 local_var_offset)
 {
 	unsigned long stack_base;
@@ -53,7 +55,7 @@ static unsigned long __maybe_unused ksw_stack_resolve_offset(struct pt_regs *reg
 }
 
 /* Validate that address is within current stack bounds */
-static int __maybe_unused ksw_stack_validate_addr(unsigned long addr, size_t size)
+static int ksw_stack_validate_addr(unsigned long addr, size_t size)
 {
 	unsigned long stack_start, stack_end;
 
@@ -73,7 +75,7 @@ static int __maybe_unused ksw_stack_validate_addr(unsigned long addr, size_t siz
 }
 
 /* Setup hardware breakpoints for active watches */
-static int __maybe_unused ksw_stack_prepare_watch(struct pt_regs *regs,
+static int ksw_stack_prepare_watch(struct pt_regs *regs,
 				   struct ksw_config *config, u64 *watch_addr,
 				   u64 *watch_len)
 {
@@ -110,3 +112,79 @@ static int __maybe_unused ksw_stack_prepare_watch(struct pt_regs *regs,
 	*watch_len = len;
 	return 0;
 }
+
+/* Kprobe handlers */
+static struct kprobe entry_probe;
+static struct kretprobe exit_probe;
+
+static void ksw_stack_entry_handler(struct kprobe *p, struct pt_regs *regs,
+				    unsigned long flags)
+{
+	int ret;
+	u64 watch_addr;
+	u64 watch_len;
+
+	/* Setup breakpoints for all active watches */
+	ret = ksw_stack_prepare_watch(regs, probe_config, &watch_addr,
+				      &watch_len);
+	if (ret) {
+		pr_err("KSW: Failed to parse watch info: %d\n", ret);
+		return;
+	}
+	ret = ksw_watch_on(watch_addr, watch_len);
+	if (ret) {
+		pr_err("KSW: Failed to arm hwbp: %d\n", ret);
+		return;
+	}
+	pr_info("KSW: Armed for %s at addr:0x%llx len:%llu\n",
+		probe_config->function, watch_addr, watch_len);
+}
+
+/* Function exit handler */
+static int ksw_stack_exit_handler(struct kretprobe_instance *ri,
+				  struct pt_regs *regs)
+{
+	ksw_watch_off();
+	pr_info("KSW: Disarmed for %s\n", probe_config->function);
+
+	return 0;
+}
+
+int ksw_stack_init(struct ksw_config *config)
+{
+	int ret;
+
+	/* Setup entry probe */
+	memset(&entry_probe, 0, sizeof(entry_probe));
+	entry_probe.symbol_name = config->function;
+	entry_probe.offset = config->ip_offset;
+	entry_probe.post_handler = ksw_stack_entry_handler;
+	probe_config = config;
+	ret = register_kprobe(&entry_probe);
+	if (ret < 0) {
+		pr_err("KSW: Failed to register kprobe ret %d\n", ret);
+		return ret;
+	}
+
+	/* Setup exit probe */
+	memset(&exit_probe, 0, sizeof(exit_probe));
+	exit_probe.kp.symbol_name = config->function;
+	exit_probe.handler = ksw_stack_exit_handler;
+	exit_probe.maxactive = 20;
+
+	ret = register_kretprobe(&exit_probe);
+	if (ret < 0) {
+		pr_err("KSW: Failed to register exit probe for %s: %d\n",
+		       probe_config->function, ret);
+		unregister_kprobe(&entry_probe);
+		return ret;
+	}
+
+	return 0;
+}
+
+void ksw_stack_exit(void)
+{
+	unregister_kretprobe(&exit_probe);
+	unregister_kprobe(&entry_probe);
+}
-- 
2.43.0


