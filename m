Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5920606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 11:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armoriq-io.20260707.gappssmtp.com header.i=@armoriq-io.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Izd+3302
Received: by kanga.kvack.org (Postfix)
	id E5F796B05B0; Mon, 23 Nov 2026 06:44:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E36E96B05B1; Mon, 23 Nov 2026 06:44:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D26436B05C0; Mon, 23 Nov 2026 06:44:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE74F6B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:44:57 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5388CA83A9
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:44:57 +0000 (UTC)
X-FDA: 85466202234.11.4306881
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	by imf16.hostedemail.com (Postfix) with ESMTP id 86212180006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:44:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=armoriq-io.20260707.gappssmtp.com header.s=20260707 header.b=Izd+3302;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of harisudhan@armoriq.io designates 74.125.82.180 as permitted sender) smtp.mailfrom=harisudhan@armoriq.io
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795434295;
	b=ZVCaDJwkvz+qH8Bn0HNUEXg7lP60SS28mZzKrqnqO6wr36MdfsWvitWcS3uyii6ZTAGFW3
	e/godfz45q4+tebLt+dLIPTFZhT31wALqygKY77/OGgghqjE5/Zn8/Y4HsYmXVfWs7DBOS
	zP1TSIueeF5xLS8Kz7PigobkCZn/iPE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795434295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wao1lDLNbUFd8H98o11hNOXj6BtvvuLII7zQ8aDHCoA=;
	b=UbtEE0q7Oy4qD7nu/FGGKLA/p1f6jyUVGahcuZi5+TTTtlQKDyt61RVuKwzwfuBZNtXW5Y
	SmY6MCauk0Ry/hphcqA4BSRSWUScuHb29LH6gy/c+q+deKYZLnblbnjucSzhzxa4JFInfp
	ylMge8/82PIQmzrkm251hkFtIL42Mug=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=armoriq-io.20260707.gappssmtp.com header.s=20260707 header.b=Izd+3302;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of harisudhan@armoriq.io designates 74.125.82.180 as permitted sender) smtp.mailfrom=harisudhan@armoriq.io
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-380b40312e2so7721977eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:44:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=armoriq-io.20260707.gappssmtp.com; s=20260707; t=1795434294; x=1796039094; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wao1lDLNbUFd8H98o11hNOXj6BtvvuLII7zQ8aDHCoA=;
        b=Izd+3302tUQ1sL5CZvPeLjbUfmQaXAPw/OMDA69UHjHAicr/VpUkIH5Z4MryCPcKM1
         RDevj+qlbpHWL632GIif+6K0KGHKJXWjUCswfwIpo+ZReCXOYy5/ZuPTnUVHopAqUmCl
         81UKRNrk4M1sU0zRSsf8NYTfekkJq1H/WMqt2b8vquDGptIFsRUDaKQS9/2EBxffWjnD
         LQUBZP0LnMKLTTCuwVp2u7YwtBwaA8f/i9XGnvcHvtyllQiWX2PDkZgCpyLATb86mZme
         nG4pAAfumsfKfxNbhsrJowerf4kL1gLRtUIrHErzjnR0wmnfbAzxuUmcGlhf28ftUptN
         Ql2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795434294; x=1796039094;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wao1lDLNbUFd8H98o11hNOXj6BtvvuLII7zQ8aDHCoA=;
        b=M7+yM88R51vLrpVvVLnzXNxgOnaEjICNbLBxuNqiCBlYDbK4jZx5SDns3bO4Dumcvq
         wdXX64ChUsnhXY+R+4AShIJtkbhYYXxcJHjtU3S7LRKYCe+lM5kHm8x1DEpOnngMnwyn
         habX3+qfuKliQw7ma3bCsfmKUqG/WbxQAlSr8Roq582C5uOCm/gl9HqJj4SdKw+GwPC5
         rUouOlO/8JYVwnY/G2eBQbmKu0AJSFFSDjHyoPOW/N3ST7Uvie3Zv/nDgkMPuA28XXGw
         FbcsqpbkeGcIHHWaEkSeYqq80AHfRfTSP6gveHRghLNuJTRHD7e/z19YPvIzJsW9N6NW
         IOdQ==
X-Forwarded-Encrypted: i=1; AL+hErH/iIPefUKYwPtNN1WDzjCzNetFFIgiePGphwP0gOaW07gP7vbSQAWCB2OIGyXW+0QTG0i9ENc4HA==@kvack.org
X-Gm-Message-State: APuU4Z/M1dLWyJ6ZUG0vPD0rjvG0Z+4xyz4W8muxkMzEtHHCuFihmwbt
	+8iySai/kJ7ZIFuuhkUKeTlq2ircovriF5+kG8C2QYurvvQ4y4w/GViNIKGmuGnOq6GN
X-Gm-Gg: AZFdTZedYfO545ob5Q2fj7l8ssoc6BEn0M9HjQHCoNgCVa9kk4a61Q41+euPIAZDTiC
	ZJ9MNULRUfsT2S6UJ/Wi/iyjTgTPGnUNuvYM+ALg2SNchxSnqFxBNQhWrWzSf0FnovTTnGPumGy
	jwgafD9ANphFWgL8xpTHa9Wan4cxzhEWXQRnMTU+MRhadLYwAYIVLC+PLhLSOt8kWl/ZNEtoWUx
	bc4AnhU7rAhlN20oY94ILNeGtD1cB9lwTU3XcxHslrUnBAGovS2Pa8ErRUGMt7WSPOQAUEOQROO
	twFXFbYke6toO4Bg03YNdI0Cru3pvyo1ZYN/pMcK6nOJURyF70xZVeIh6j4Da9Q4aSXDjgh8dUP
	AvRlf5Z1z+ARLTqrRY0KLYE82Xt/VB4EXsSdDN0LLNiVU4BL3g/XThGk+b16expz8v8BVaFEKBP
	pslZc2TROvhMfSbVgkk8CT8QMisqlbduEc9qb4SYVkl3iT/SBOsFt+JZ1OXpgwOPT9urk8NMIRJ
	SPT9g6vQpWd37GgZ+PbikmqXkFXynTk0UI8mWIoZBNbtlY/4OvKr9nq6C28CfQvc3R5Y+An0Pnx
	VwKfLSorXcwqxyTxlwaC5F/C+XZI3PBCeTkFtfK1YJS9UV5HpiNDlxtqnLvfzFwQMMuYdy2tKco
	TF+aa4sHjxfYdNXoU5sYBt2N0AbQB/K3ugcL0/6Jqpy/LkGVmHUyQZg==
X-Received: by 2002:a05:7300:f797:b0:386:95e7:848c with SMTP id 5a478bee46e88-38695e79009mr9525592eec.7.1795434294209;
        Mon, 23 Nov 2026 03:44:54 -0800 (PST)
Received: from localhost.localdomain ([2409:40f4:14e:94e0:654e:d7ff:13d2:447d])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38566cd40c5sm41943583eec.10.2026.11.23.03.44.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 03:44:53 -0800 (PST)
From: "HARIHARA SUDHAN. R" <harisudhan@armoriq.io>
To: bpf@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org
Cc: "HARIHARA SUDHAN. R" <harisudhan@armoriq.io>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ben Segall <bsegall@google.com>,
	David Hildenbrand <david@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Morris <jmorris@namei.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kees Cook <kees@kernel.org>,
	Ketan Bhardwaj <ketan@armoriq.io>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Paul Moore <paul@paul-moore.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: [RFC PATCH v4 5/6] kernel: add KAP checks for unshare and setns
Date: Mon, 23 Nov 2026 17:13:07 +0530
Message-ID: <20261123114308.8103-6-harisudhan@armoriq.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261123114308.8103-1-harisudhan@armoriq.io>
References: <20261123114308.8103-1-harisudhan@armoriq.io>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6eqjkfwug6beezuidp6i6z1zjzsbhjme
X-Rspamd-Queue-Id: 86212180006
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795434295-563388
X-HE-Meta: U2FsdGVkX1+qkKmNUME5n81xa5h9f56TQsgt6+mZId7aq1pbWzpBcYBTKFENDhLshJBq8NX/xw5pB3EEEFgiVt5ZuXvjD8dkWswZd7U29F5+tZZAXAK/nzLensAYnAlFRGr1TWmTbF0H4dSvjjtGbzAQGUlRvXK/rdQyDni5qsTP4v6DYoNoqGkeE+nB6mJPhGTE0iUFmEqdTWEs4eymoewYp110+Z21oiI0ZZN2vDVOp1Jot/hXyZFo7GJMMsoHUuLOZm2lKySdONyj4mYxfgKt3uFTDisyK3CSqzkq2O3g5F/40HyLv+hOkMngXFuU51tqk46delKA9FUuuDpMFdx66ON94YwBw94oJnjCC4so2epc+5OAe0v7VCqvWcxaIVNKSs1364XmEQc8070V7ZckDrVUqkt6fcjsFIbO8zlhz+/EtYniF6+KYLHE6s5oPObPmcnVItdwAH19d0aPK1BavIkhS+fGx+8sxyEMjsF/1umpegsNMpE0Me7WCTB2/qHlPOjBp+gNe0Y2lMpFbfo4/rKDXCiZ5pGzImONotq/cfnMRgp5cEqg2kCjeBgbVsA/e4PE4lYS1T4qedTCbCTg9z3NTEvzA5Dmb0Ld6oKee9TPMwf9X6gKMj9jzH2KoNdfgyVkkG3qaJbaoZMIecu3wxiOhmBs+IaOImK4N+nQdDerY388v0hc+/kMAtrDoGCe34MOkAhLNpPQ6NP4njMwaLzVKra0tqUcMcQsNLgcCGApAwl4euJUiChpxzgy4yUqoYHQYkbhPoF76K5TzrKlkmCUjqpg9B0Czkx3OHNhtROUIUnGIpFqKFNJgcCl93CB2GrkNo4kQTmGWD9gMA156p3suAMjOe94TecyQ30eZ2gZb43ud8c6Xz2sK60HaJn9kbiFwSQa6xiHrsE3FpEXfdaVs8wZDfThnP866kEZ98XJtgh8nzXDCrnvY8Cu4WqOeVgNwTFkUtBOXRn
 Ou2P7WsG
 huA6gLSwdaPHiNENSi/Kcfegjme4SpUAZDGXRA3moddCDeegkH3l3qhZQRkkB1psB6TW3jBvQA3/w0xf1Cd4MqW7y5XS8T+HLAvg/z6ery9ZT5e0cPN5dt+WpnSwgMfrfQERLgsAD3D2RkA0EQzLbcZ9HabeLQr+GLuKjprnvv6Rc8gk27AHXj9aWD1hWWP+f/y12qjU+EZaDSPknuhiJqtRNujqnd/ni3675gpBl94+UkYtnOsvwddPlMzgP7982382mFFQKAc1qnR9WN67xSj1B3S6vB4Hpe3LMX1KcYDNrqOnLFf+jx4zYJJu5W4YeIRmddXmMJZH5KCjo1NbZvAdcIymw0LMXpOsP7G+ind2tKfo+UY7OUSKTYTXw1PCwIkGSQ9FnKMny2foSocHpYKid9VOQbfV8i/JOTjrg0N/YD9awC1L+d+OEctVhr2uSOyJI2Jf2ECFwYc2xYnw7P9MVBnghnjmloMEVE0ot/Pt6Q/Y2s5bZeuQv8EKIn1GTECGny37oGfeedDXH1Euv10kj5bB6UKcRCxAhytv1hT8ls6uTKtWes8c2jq7cWPt0zPkvBHzWkEEi2gbXedqFLmdVZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Check unshare and setns against the bound task's authority. Neither
has an LSM hook, so they call KAP directly. Every namespace type is
checked, and setns checks the type of the namespace it is given.

Unbound tasks are not checked.

Assisted-by: Claude
Co-developed-by: Ketan Bhardwaj <ketan@armoriq.io>
Signed-off-by: Ketan Bhardwaj <ketan@armoriq.io>
Signed-off-by: HARIHARA SUDHAN. R <harisudhan@armoriq.io>
---
 kernel/fork.c    | 4 ++++
 kernel/nsproxy.c | 5 +++++
 2 files changed, 9 insertions(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index eb198c8df..4216a2de3 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -52,6 +52,7 @@
 #include <linux/cpu.h>
 #include <linux/cgroup.h>
 #include <linux/security.h>
+#include <linux/kap.h>
 #include <linux/hugetlb.h>
 #include <linux/seccomp.h>
 #include <linux/swap.h>
@@ -3276,6 +3277,9 @@ int ksys_unshare(unsigned long unshare_flags)
 			 current->fs != current->real_fs);
 
 	err = check_unshare_flags(unshare_flags);
+	if (err)
+		goto bad_unshare_out;
+	err = kap_check_namespace_flags(unshare_flags, "unshare");
 	if (err)
 		goto bad_unshare_out;
 	/*
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 3fb1595a4..d41d7f5e9 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -25,6 +25,7 @@
 #include <linux/proc_ns.h>
 #include <linux/file.h>
 #include <linux/syscalls.h>
+#include <linux/kap.h>
 #include <linux/cgroup.h>
 #include <linux/perf_event.h>
 #include <linux/nstree.h>
@@ -589,6 +590,10 @@ SYSCALL_DEFINE2(setns, int, fd, int, flags)
 	if (err)
 		goto out;
 
+	err = kap_check_namespace_flags(flags, "setns");
+	if (err)
+		goto out;
+
 	err = prepare_nsset(flags, &nsset);
 	if (err)
 		goto out;
-- 
2.43.0


