Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A495CA0FF2
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 07:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D10EF8E0010; Thu, 28 Aug 2025 03:34:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC1678E0001; Thu, 28 Aug 2025 03:34:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B892B8E0010; Thu, 28 Aug 2025 03:34:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A450F8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:34:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D8C5140A43
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:34:37 +0000 (UTC)
X-FDA: 83825353794.24.FB41325
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf03.hostedemail.com (Postfix) with ESMTP id 78FBF2000D
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:34:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q1Dc0Twy;
	spf=pass (imf03.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756366475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bG7HgZbRDL9zQbYB/rpSIbCyKAIzwo1Rr8phODu9KXc=;
	b=sqhSqB1eYI9VJ9EunJ7ZkjZbtrM6sxlxxxknRGKZIKCNj2I8Z/aHDEhGUEqd8E9A6nLu2S
	cL0fpb7iSh1a0PJb89fKKv/HSC0m1NJBSTIVlsQyZbzCjKnGaoZ2le2mu7tXJTVUrzK2TS
	wfY6E0eFybRHzp+0+2nxvbNtvwIny30=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756366475; a=rsa-sha256;
	cv=none;
	b=bVdKD6Ikpsv3BBpQNYP1O6mOmZqcItmopaipexGLq3z0ztcSfr9UhkSSZq2kJ64/a20yCb
	2nfs9/DWz0WklAV9AN5d1D+YumprkyzsAE+paGz1Diha9G2jUH3Bk5M2F6M0DKb3tljGwB
	JEC8QV630DnBOvse17MNXMpGqzWyKKc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q1Dc0Twy;
	spf=pass (imf03.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-771e4378263so534425b3a.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756366474; x=1756971274; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bG7HgZbRDL9zQbYB/rpSIbCyKAIzwo1Rr8phODu9KXc=;
        b=Q1Dc0TwyAkjfEQOJvcvmVkpNlQy6BI1STYyWEOFDw/mbCTcToqJofM2Mml9p+I3BQa
         pUu8ulNJJw9ekwZ0JmJ2ugGR1pbdAvL72cpkg1T5Vx7bup3evwQEF1LiQkuOj/qh7iPM
         zFqd8s64V2fYMgkulCtUx9X9Y5g2g/9f4KK55L3X8PVFRRWuBAimKg6u0UKH7VkSx3+t
         IbTt9PjFSCBmJnJeOmkQ1vT4ssvhkEcpQ1zaq1uUfFOsNClaUVLGT7DO8XjMhIubANXp
         t9stN6CXVPedVyOrQ27f/MCQz8BDYzQTUIGPvq8cmwnCcDsFOBOWCMTe7FyCyK3gYvWg
         6h8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756366474; x=1756971274;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bG7HgZbRDL9zQbYB/rpSIbCyKAIzwo1Rr8phODu9KXc=;
        b=f5o5MUx/yghrRmV55KTjxisUJtphU/8qHlqlooXIt9vW0jTGqINrsNBATMCgh0J9Ac
         Zsot/q0CnXltbUP638kHeJTHXW6yea21F7jX3qw5TRjUBR4kj42C64pRWNJ5ymLPSR0A
         8Qst7lXO1Hz01z7hW8R4O/M2CspDp1o/1hQoZS860NBwygnTWhHBaCUJbXsGKdlCWtwI
         Ar4X4qQOyYFe7RhxeYzBO6I4DB4aYj786jZM4lqyATBjWmDu8zAv2LhsARWBc4LT3gYr
         fbimsg4FIUevKDmjKCsRM1SJaTwykEXlF3KnbhXWC3Pg2b/UmYsGYLBud0d3uLafz8Ax
         6nMQ==
X-Forwarded-Encrypted: i=1; AJvYcCUS0k46g6SH3CE5Xa3IM/ZI2/jrVEvRhXXDSxaIEBBlHiozdwsaMmTc8+nBfAs7hsy0HowXfwJgRQ==@kvack.org
X-Gm-Message-State: AOJu0YxXyWwYxMwVdKwvNu1V8T5F5Zzzys3/s7WfMJsWcyDrCS8+VMlw
	mVkRwk1SYtAi4gSbD5clqWYZUHLZ6eAwRm8/dwxQvD2wnI3uM0KvF+1+
X-Gm-Gg: ASbGncs+V+6qoQFBxfJJhBz1gKmKS4FqZl81+nE3yzOrxUONQ6gL7Ksop7wGjyQEDHM
	hirZhxt/g8snD2ypxkLZhzqvawRP3ka2XNAkvn6hXgwHle3o/BrLjfQNK/j/ojbQD116gnf5sBn
	rp56naZrgFDs41wcdUOTKTZg6K6xgAnZjJDe68YPtPv2Kg1iMkoOkR8x2W/L9e1e/UJjTsxu9Gx
	l6As1fPu1EuIAAyZTxpxyAnXjuDx8cKtxRagczobj9eCePNP6FpYt03EoTCl7S3yq0cO1k2sDjF
	n0WfiVHT2a0bHo/vLEaf28TtcKsLIjj1Yg2mDfKzy0LX93zSecjF1TdU4rLM4vKjf2LXWcRQEeN
	a+I+yIOPOUOBuxSiAc31CTF6DoTwSLN5fAPQgBIOk/dzdpHP1EA4jf+Db0e4D
X-Google-Smtp-Source: AGHT+IG2cMUWd4+kNO3PHhwHAxn0aEjXgn4rf+81c8SxWqiq8TRWIkN8Ewenr6E1OgwngH659LqMOg==
X-Received: by 2002:a05:6a20:7f96:b0:243:78a:828d with SMTP id adf61e73a8af0-24340e2a75cmr34553679637.52.1756366474244;
        Thu, 28 Aug 2025 00:34:34 -0700 (PDT)
Received: from localhost.localdomain ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b49cb8afb7bsm13182613a12.16.2025.08.28.00.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 00:34:33 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH 07/17] mm/ksw: add stack probe support
Date: Thu, 28 Aug 2025 15:32:40 +0800
Message-ID: <20250828073311.1116593-8-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250828073311.1116593-1-wangjinchao600@gmail.com>
References: <20250828073311.1116593-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 78FBF2000D
X-Stat-Signature: hmh11tj9ox41wsihqfz11dc3x43ikdwg
X-HE-Tag: 1756366475-537189
X-HE-Meta: U2FsdGVkX18GymmzE4jnSlmmRfSITc+yArT9EiQw6ENkDr3vk5Qa5Bfs4NPetNytYfJbGZOZ9uodSR5qXnr6P1c1uhLPWYawko1blDqAnUehff9kzcEpOG9vOMpTbYkk2zQxEn6EMKzW9ChlF88Ixysh85LJuctuf7VWvVtsZNH4pt67Qx3lV1+iGZWMnjrAmOeANwrOCkxp/p7GZiwF5leCT3YtiLQZzHZIN3Xg59TTs0b5r0g1zMt92FQHd4CTewa6an9ASQxf7bHn2uoti3uqbyHgnkM6MF1vIUgFSNEWFfjLQL/fqmogKZNnwPLLGu2tf953E3PHDbp3qJHoI9SDGNPHqhaa5pXO0OVdGT0ldOUqSB+Oa7IQ3QfANnscfDMJIG4qSi2/iKXulXAhPLE6shWa9SK7SUqpa2CPQ3Z08vvjKK+8kt72/r176FD6Bb7o9Ai1ickLR2dxmVEjN+ceJ8PRQiN1ljxhwLXeThfSVGM5aM1BjX+0kSpqeIExEMZ2YahyST65OtpWq6E/fm82lK2Jp4S2oifaROJkgMCip1qHlx8fhFT3yZWv99ITDxBOh4FCAqDw5xt1hKF2Sf8hZi3F6v/apF5fGBf6qETQp8N2pB9Cy/L5gRUsKT9bb5bgnt22tpZJjFCtyd7xDPaexN5EFV4vHSp6o6DWdVBkbuLhr79ehrhlJXDYys1cEIwq+X+/i+cq3xUWYgiWHAzTxetMNOZXJWebS37w8EUWPyjirGXPbneAcmOQjsBlSzgNeP470IhxpGg+E5wLqHBqXEm5JF1EsfFVz64bbxsNT5P92XxqfhAp/0a4XDKJsRVBvxu4X0sBZ/Qzxhof1REkiPAVQDxs0oh90nIMJsFb6l6ccTT3vggLic89IC4147XppzlwRUUjaJYpxcPhL9eo6pX7oGCNRgBGPW3Lutgv7celUcDtj2QwdWnQ3pSUyvskjDxt+51VUlbCc09
 VC37lCw3
 U2nJJdfvRk2BPtyzMTDDqR31n6+vtwRdliofZqmrvaMhlJ3AQ7fxsG6xxNJqe5HWptGMeTEFRIUGNC+Akjf+CVHLDvTLDhpJ8ZmWLRI211mW9DkljWL5unyKlPyorGXToMtIBiud9TTaKfaagzPrn2x42hUBLsM5yCxLsIaz4RecTe5cMrqE3AcVQPWCp5a5G2QiNRjew4tmaZTLY38XLFCnETroxnwwO8HOLl4QCDCTwLYczNidBQ0/j/dqf2H02/9ZDl3p6RDuktPg8JiqFuov4iCP8uv018oMUXPpqFluDBqmAoDz1Scncqc4lvKxX61lAv8tvqO32pCC6/hoZ/oF7FgaHFhhwfppt2CtydapHDQ5EnUeptyUCGFDLpjGd/dyZ+Qqwc/vZjNQBy09n5Nxy+XJaQur/1nXx1pOk+0MumY1QJ/sVf07VCKwPxllRMQGVdRZz1TCFioltt57jNWYnNg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce stack management for KStackWatch using kprobes and fprobes to
enable dynamic watch switching:

- Entry: prepare target address/length and enable watch
- Exit: disable watch

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kstackwatch.h |  4 ++
 mm/kstackwatch/stack.c       | 91 ++++++++++++++++++++++++++++++++++++
 2 files changed, 95 insertions(+)

diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index 13ef8c79f855..bc8664af4fa6 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -38,6 +38,10 @@ struct ksw_config {
 
 extern bool panic_on_catch;
 
+/* stack management */
+int ksw_stack_init(struct ksw_config *config);
+void ksw_stack_exit(void);
+
 /* watch management */
 int ksw_watch_init(struct ksw_config *config);
 void ksw_watch_exit(void);
diff --git a/mm/kstackwatch/stack.c b/mm/kstackwatch/stack.c
index cec594032515..3b72177315cc 100644
--- a/mm/kstackwatch/stack.c
+++ b/mm/kstackwatch/stack.c
@@ -1 +1,92 @@
 // SPDX-License-Identifier: GPL-2.0
+
+#include <linux/fprobe.h>
+#include <linux/kprobes.h>
+#include <linux/sched.h>
+#include <linux/spinlock.h>
+
+#include "kstackwatch.h"
+
+struct ksw_config *probe_config;
+
+/* prepare watch_addr and watch_len for watch */
+static int ksw_stack_prepare_watch(struct pt_regs *regs,
+				   struct ksw_config *config, u64 *watch_addr,
+				   u64 *watch_len)
+{
+	/* TODO: implement logic */
+	*watch_addr = 0;
+	*watch_len = 0;
+	return 0;
+}
+
+static struct kprobe entry_probe;
+static struct fprobe exit_probe_fprobe;
+
+static void ksw_stack_entry_handler(struct kprobe *p, struct pt_regs *regs,
+				    unsigned long flags)
+{
+	int ret;
+	u64 watch_addr;
+	u64 watch_len;
+
+	ret = ksw_stack_prepare_watch(regs, probe_config, &watch_addr,
+				      &watch_len);
+	if (ret) {
+		pr_err("KSW: failed to prepare watch target: %d\n", ret);
+		return;
+	}
+
+	ret = ksw_watch_on(watch_addr, watch_len);
+	if (ret) {
+		pr_err("KSW: failed to watch on addr:0x%llx len:%llx %d\n",
+		       watch_addr, watch_len, ret);
+		return;
+	}
+}
+
+static void ksw_stack_exit_handler(struct fprobe *fp, unsigned long ip,
+				   unsigned long ret_ip,
+				   struct ftrace_regs *regs, void *data)
+{
+	ksw_watch_off();
+}
+
+int ksw_stack_init(struct ksw_config *config)
+{
+	int ret;
+	char *symbuf = NULL;
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
+	memset(&exit_probe_fprobe, 0, sizeof(exit_probe_fprobe));
+	exit_probe_fprobe.exit_handler = ksw_stack_exit_handler;
+	symbuf = probe_config->function;
+
+	ret = register_fprobe_syms(&exit_probe_fprobe, (const char **)&symbuf,
+				   1);
+	if (ret < 0) {
+		pr_err("KSW: register_fprobe_syms fail %d\n", ret);
+		unregister_kprobe(&entry_probe);
+		return ret;
+	}
+
+	return 0;
+}
+
+void ksw_stack_exit(void)
+{
+	unregister_fprobe(&exit_probe_fprobe);
+	unregister_kprobe(&entry_probe);
+}
-- 
2.43.0


