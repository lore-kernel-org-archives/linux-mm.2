Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DE3BC61DC6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 03:48:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 175F96B0092; Wed, 26 Aug 2026 23:48:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F09B76B0095; Wed, 26 Aug 2026 23:48:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF7566B0096; Wed, 26 Aug 2026 23:48:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B6ED76B0092
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 23:48:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 49CF41C18F1
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:48:21 +0000 (UTC)
X-FDA: 85145666802.03.1479CDC
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by imf22.hostedemail.com (Postfix) with ESMTP id 92614C0009
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:48:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=olWKS+6N;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3grOPagcKCIM3mlspwlnvvnsl.jvtspu14-ttr2hjr.vyn@flex--wfelipe.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3grOPagcKCIM3mlspwlnvvnsl.jvtspu14-ttr2hjr.vyn@flex--wfelipe.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787802499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c7K4UtYlM5Taecme/MISRV3FY5efo57r9lhFcU8lc7w=;
	b=ggL5G5TVPx2jv1A7ZMcYv/LcvwMF+CPnKLajcGlqoX0eA80TBWQ80W8JHD0qPnZfn6Jo07
	u1PCB6Y0Ku+yj0lrKRFIsazMNlj2Y+wLAHU5Yzb6HDZG7QO4HqXUEsnWKC6pmhavY3j7J1
	5SHOXez2wRx12Yh4U0eTE71vjKwSmF0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=olWKS+6N;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3grOPagcKCIM3mlspwlnvvnsl.jvtspu14-ttr2hjr.vyn@flex--wfelipe.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3grOPagcKCIM3mlspwlnvvnsl.jvtspu14-ttr2hjr.vyn@flex--wfelipe.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787802499;
	b=YahsACBVBxuENclJQbHr6wWLzanh0h9+S390jPeXWjQCfUa8gzV+B5l79MLqtj1S0etomR
	ZRrMaF9O7VI05DLGcvU5Qr8cX2Dg4gE33q0KWD4y5UA0nKoGYMEkkXiHwGU6u2f8OvEuFs
	uOg43StICAzwGgUHjEQGxjtrL3O2ALg=
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-84857446424so3132762b3a.1
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 20:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787802498; x=1788407298; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=c7K4UtYlM5Taecme/MISRV3FY5efo57r9lhFcU8lc7w=;
        b=olWKS+6N8DEkNxt1h7MNu3S1H67PfC8HU8aY9Avkd2LXYX/qSM/Gk9i3ZsWhqASGbU
         fxBCHqA4+WzpzRaAfwrqpYrHdHHtoTcUTGWFnusukhu5uB+f0D8FzSA1lFAvpXLO1xL0
         bclcrd++TifhVjmi00HlxZRZ5cvV3Gqm2Q7nrZbYolV0lOTmuiXfPl0Xvf2lJd06a5pA
         AR0WspFqb8HZPFcBBkr96Y/D5nJWKKIwRLqg0cF1kB3bH0Ge5pG4bz5+HJWUakI1RMFX
         4c26/pYB4FIHIaLS4mIluSbIyvH8pKHZQOkGzYCBhdxSIkIZjCajdT/OTAHtRr8j+Pg+
         Z9Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787802498; x=1788407298;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c7K4UtYlM5Taecme/MISRV3FY5efo57r9lhFcU8lc7w=;
        b=DboCjqQFmZca3WHuTv50XCAEhtGjsgQtD13G1MiJGeUp/TRx+XRBrmg3d9CjLCk7Lo
         DxGHacN8gGIOaNRY7hS2ue1SamUvVkjncSKD32N1yQsKUb6YNK3MCS1gu8CGpNarmJAm
         bF9pVDI6BzVKkip4i1/uH2WSsJVClO1TorntMJ7O1eX6u+loBCEdWCNYci84DVs41Y8O
         nXrWNxyXO+MjGA7lhZeSi1XqkfbBKJ+af9+L+ao9vFUXyKBc/2Fp2eb/jRwMSIrsr45c
         pN8Asa6ffHcBYnWlQih0L73GylbIK4V7mFDWGcQVz9awLrsGGNBq/t+FSHgflg0yEcFf
         oqAQ==
X-Gm-Message-State: AFuF++mbecNQPJjeOW1JBU4UMZC18f43YPqo8ItmB43HOpPnyyuCV/C6
	FFiMuMIjjtpB2Xxh9ZgBU7RvWsuGhLEHGq95hJOSPuXyEWqQeMmf0VaI/Ie9lAFfSwGpS96xQRb
	KOVSbdOr7Lw==
X-Received: from pgbq7.prod.google.com ([2002:a63:5c07:0:b0:cc1:46df:8c43])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3496:b0:848:77b3:579a
 with SMTP id d2e1a72fcca58-853755c49b3mr22827745b3a.17.1787802498148; Wed, 26
 Aug 2026 20:48:18 -0700 (PDT)
Date: Thu, 27 Aug 2026 03:47:41 +0000
In-Reply-To: <20260827034807.2822234-1-wfelipe@google.com>
Mime-Version: 1.0
References: <20260827034807.2822234-1-wfelipe@google.com>
X-Mailer: git-send-email 2.55.0.887.g758fc8c411-goog
Message-ID: <20260827034807.2822234-2-wfelipe@google.com>
Subject: [PATCH v3 1/2] selftests/cgroup: test_zswap: wait for cgroup to
 unpopulate in test_zswap_writeback
From: Wilson Felipe Pereira <wfelipe@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Wilson Felipe Pereira <wfelipe@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 92614C0009
X-Stat-Signature: ifztjr7hxxwmyjwtd1zwmrpp6shqbhxm
X-Rspam-User: 
X-HE-Tag: 1787802499-218502
X-HE-Meta: U2FsdGVkX19xsVZvkmHmNCREoIf1cWbkIIg+wA0HBnlXjT5yVe+ZPh0i5jUUXvchBVYPvI/U6eB1zhIaWnoxRbMlymQ3tdSLRYucIc+3eLtVbRwDrYZWh17LIfgV58QlQ90u5BiVtfQW2lopo0RuRd8u6+RAlfSxOrUFchMMGjxh+2fzXgg8U30vrZK7bKEbM/e67ZLWspJGiH5VwjdWwh+3RZQhsejxmNRy7hgGkveDCg1nEdsTb4G4RQApIhfy9/MTy9nTWr1Q3DqJWXP/yWU+GCfR8QaRr2zyhHkUnx1DpJ0qsPYun99NcZTTv0WSP1fuWeJaFQjy8DENhWBZbpBzdauxtGaWUE/TDuypoEjdBVuGzpNBK0ccY+O8rL2c08fsGCYZ1j6DJWg32vgrOfQ+j4eFuheEzxbxU8xZSUUGZtlkDgnug/EoJVsQ8ozDPCbgC4/M0RkbThtUAgp2cz1/btVBZeoj+DKUmRTTMS+Xv3cnnepax1ygVp3oLmUbobCkg3m4DJN32HrqbcCIoEOCy4CqyQgtRLJpA6vp3s4Kqc7RgvB0rMelO36aoldrPenWo89z5tq3Qa1Xyohebzg/H8PARgW6RdirfCYzFbchNCkF9Tup6e85ukqoD1T2Yf/jIL3V5X1PYpO8B4+P0CxfR7W4SOI1/B+SjBa4A47cASjwQ0nU8QdlVonr5uIxgAlYIe33rwRRs2mLcwop+/0g6yOHXZzGz0Z4qZD2+li31JBcT67+esCW7NfTIsF3r8/ZnQeOnz8k5/w1I8/465tyR6yZVF6Ea6nXebSUGgvlkVgA8FdiO9jA+xCN40aBsgvpzUXh83QLsI8RmeOg2pEnJMt1jJpyJF+Qnlq0PcKuEulLn+Zb4YSC+0tgwruyTF3E5AEnI5yIP/tbPnkFGOrwCwN7dNr3kt+yFstamb+/q8cBsCHT+5ze4fp2IBgmYhI1Fto1ywzzz/uw9Js
 F2ZOlN5s
 HRgX4vwxLwEwDQ52dFvZZUMp9pSxYyA3pKRJK2BS359e10KH2JqIqwLNhvLk5WA0ptiaAlrlI4PdRWXj1TOpozjjxQUljwxOdbl31omEzsuxpNtf/fDE6vZMIEIE6rhyoJX7j5igkISbYFxPQ8rkgwVRPlQ8LA/93BU7XsJZIHE06qdSH/Pucx6RhQLAVooVP6J+NYDQdm9PZGJc+8bOhduZitrrE0SaRqyZXroya0N3MwQKR+XPyNs+jlPmQAYTmke5eJ7JnINjrck39YPGObGMZKdFPcu7k1ltBHXgLdClR/fdUrDpaLPADq+60HtgJ4RLc3YdjQ8a3h4qDgjEv4f4TWEOR1Fqoz+aiNZW3UEep5H6/6+RT84NohJ2QAGGM0HR1bvVsDDt9stoGnVpm+SvzrSdST0vkmxbOFjx8STXTwU3ufL/+ByRGeNqLUmFVGOZiKFJ8C3ywcYUcc+B0WERbvMVjwvL4oKFHnDZOG6e+fbk3OJnvZFmkkUTO6FAasuNnnlPrytB6+k+EY7m/y7lGJ4MgcBn4p9eYdHZopv8TlZj01vC5DyNQcVnAchYA4wyLs8q2GibkLfYuPgp9tYLuZDJSEMSvYe31+/6+vxC8Pcy8yqG77t+TLCLP8/MsLwHsyeFF2vMjCr96Oh7ddRRKEDU2rpa/fp9PNmB3lqpZxWIBI16ld42gRYJFu8k9CDCa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When running test_zswap on a single-core VM (-smp 1) with 4GB of RAM,
test_zswap_writeback intermittently fails on the initial run after boot.

In test_zswap_writeback(), after waitpid() reaps the child process created
by test_zswap_writeback_one(), writing "+memory" to cgroup.subtree_control
can fail with -EBUSY. Under cgroup v2, enabling domain subtree controllers
is forbidden while any tasks remain in cgroup.procs.

When a child process exits, exit_notify() wakes the parent process,
allowing waitpid() to return immediately. However, the cgroup populated
task count (nr_populated_csets) is only decremented when the exiting
task is switched away via finish_task_switch() -> cgroup_task_dead(). On
single-core systems, the parent runs before the dead child has been
switched out, causing "+memory" to fail with -EBUSY if written immediately
after waitpid() returns.

Fix this by waiting for cgroup.events to report "populated 0\n" via
cg_read_strcmp_wait() before enabling subtree control.

Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
Acked-by: Michal Koutn=C3=BD <mkoutny@suse.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/se=
lftests/cgroup/test_zswap.c
index 49b36ee79160..a7ff525c1267 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -407,6 +407,8 @@ static int test_zswap_writeback(const char *root, bool =
wb)
 	 * Thus, the parent's setting shall be what's in effect. */
 	if (cg_write(test_group, "memory.zswap.max", "max"))
 		goto out;
+	if (cg_read_strcmp_wait(test_group, "cgroup.events", "populated 0\n"))
+		goto out;
 	if (cg_write(test_group, "cgroup.subtree_control", "+memory"))
 		goto out;
=20
--=20
2.55.0.887.g758fc8c411-goog


