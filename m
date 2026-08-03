Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3278C55196
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 21:55:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C689E6B007B; Mon,  3 Aug 2026 17:55:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C404A6B0088; Mon,  3 Aug 2026 17:55:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B577F6B008A; Mon,  3 Aug 2026 17:55:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 986946B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 17:55:01 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B5402807C5
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 21:55:00 +0000 (UTC)
X-FDA: 85061313960.02.B2F281A
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0C77F2000C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 21:54:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LDMDbnHe;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3MQ5xag0KCGwKLRScROULKZKdQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--abhishekbapat.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3MQ5xag0KCGwKLRScROULKZKdQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--abhishekbapat.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785794099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gSBooIlJf3UAkzT4nWmRIwMiBklsMyQf8PbFU/y+GgU=;
	b=wOdUBoQe1rKcfQ+MqahylSkWIMlRqtiWiO9cYK2TnFq6CzNm86qD2TljCnHuAdnI/9UPS/
	ixgpHwSn7tuy1KFzSRfIqB5DmZ7qwdlppOH/9bbSllTkHekcPFS5yvXRttIij4kWiBGCLA
	LjTZ9Qe8r2SY2gPwxcwCRV68VYn/V1g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LDMDbnHe;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3MQ5xag0KCGwKLRScROULKZKdQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--abhishekbapat.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3MQ5xag0KCGwKLRScROULKZKdQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--abhishekbapat.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785794099;
	b=xeMID63jJTXIOKDmey0t7dLrMqHCAqyhOULP5KK5Fs9sOwhjH1iEN1en37bd3sOnNNMoBY
	vBa88Z7HYKQya44rbZCPbB/iJD5ct5E5R+Zwxg8HO9xKSwYzwcfzR4WG6f/9KSWF+QVmeW
	GQungHHF1DsEG5C74j47QzgNVflDY2Q=
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c88cfe287e1so2669248a12.1
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 14:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785794098; x=1786398898; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gSBooIlJf3UAkzT4nWmRIwMiBklsMyQf8PbFU/y+GgU=;
        b=LDMDbnHemBeth+OugZE1/K3nN+xUGBqvhaYjg7GuVFQqOJM6H4JLhd6qLR1u3wrVGQ
         FKsOQzfdeO/OyMz47zu067rvjP2CfPo9ybNgU4KTgZt8Crpz1AXRTCgwKk977Ms7Z9yA
         +XLiLkjf5A6uDOCRSbyN1+RNF/7Ko87gR8VFm3MvFt6yg2m9q0uhytc9YfoloU9uT7j+
         +CXcH8zyxVjEpdyJxB7+EaUC14PrEisSh6tLvDtfLIGzaIvct52SL2Ey6AnAuTqVJetb
         Zj7QCZHIandFZMMv6rZH4K2BfdsGgWJeqZFN1gaLi3YECRq6Z/zf9QU4C2l1M9RhkDVI
         Sa7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785794098; x=1786398898;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gSBooIlJf3UAkzT4nWmRIwMiBklsMyQf8PbFU/y+GgU=;
        b=gkaEQ5QMymPxiVkVvxvTcnH8z3LSCiS1tYf8wAOHvVPMxurXvRx2bhb3JriSHEMp4g
         6QgVMDf2VhdoFHMokeetHLK7dDtJBVr1t5GhahT6a48YPki45F4yE7UWjUynoZrC58Ak
         dFp++sEnsH5UegfBEvTxKTZ3p6+/kZuKKCoE+FCUg+vEhw5EmWi6kNtEW86vV7OXoU/Q
         HvBfR4IEzsbggA/NbFHGDznzJpsTYqOvdqh8f+3+zyFYQVWEKT88E3cDD3yVZCjA/n4r
         GVfhQ7wOd3v/h5QrgAIl1Knb3aWKqp0C+GTw7Nm5Zj/vJ8HGP6OvL2+ak8afCf85jero
         gUTA==
X-Forwarded-Encrypted: i=1; AHgh+RrG8zitd6Li+hr3nxbj94siK1JfZlPZ4JV+gzC/Cd144wKxx8a311lZ84akvvs7fExcfbv3gac1UA==@kvack.org
X-Gm-Message-State: AOJu0Ywl66mIGxHFqy7BzUkvKEuTO/zfPnEq6UjHAbOAiDUEzkFPhyxZ
	KPmoqMbUzifHFY0jX9gCrOYrvflgsnZuv96lrbXQqvF4VYtrw+5ecy5/E1guLyTVaJbN4+SZK8P
	T+t/zPszkGB9IOmwHXps40xFEMWpCs1syfg==
X-Received: from dlbrj9.prod.google.com ([2002:a05:7022:f409:b0:13b:2a58:e5fa])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1dc3:b0:387:e0db:bc28 with SMTP id 98e67ed59e1d1-38fbc554637mr10362140a91.40.1785794097472;
 Mon, 03 Aug 2026 14:54:57 -0700 (PDT)
Date: Mon,  3 Aug 2026 21:54:55 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <d635115cfafcd35c8e3344b418acb1020aba1052.1785794035.git.abhishekbapat@google.com>
Subject: [PATCH v3] alloc_tag: expose profiling and compression states
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Hao Ge <hao.ge@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0C77F2000C
X-Stat-Signature: hsn5x64c1yk6czhky793r6ayxjwuz5gz
X-Rspam-User: 
X-HE-Tag: 1785794098-576112
X-HE-Meta: U2FsdGVkX1/HfOv8jnGz2cczvdebsSl0TH88rqzDfNAC76YLUD6np6yDQTnt60shP2xM8/a30x2oHE9AFWpfYIRT6iNzfxvNWEd8/uvn6wF7MnQx8uA9cDAUiWSI4bkrBwVwkiAdwCpYmmyWTqTfAPLacCBMgQsObZDLxgM+ZGtNo/2uZV7jPY7R3KScbI5i3qwIJs4DkSVxRzf44jvq8cTmAaG5KqPuyzaSjEzEFnQKJciVoBNECkCGKoKsIB6fmYGnv1OMRW7oUuKbAESQ36Xm19AyAcD/yOwrC7O9doWNRhJjX94Grju737B7PO9zakBa648ZCDATD25gsoAI7Yg0wHlUIJly6pStWSEF1s67Dquc9Xtk9H0gL4IPk96K4kwQ2twm+N/5BzZtjOKiwx1iPc7CYfDVJT6UgAlwVzuvO+vZqi1UBTDTA0LvwK8J8E+VZlNub3HompCqtwWBsU6lPXeoEMNtp47kpYEleVHcYkKYU2RLJTp6I+aWuwNGGJsK155uTUVDhdwh1ONg//OADNQVpVxYCf/n1Cv+jjJrpJ41gCzrZsTYX4pgseurGzBztrxPHekexVzQfKFicfiuflrgMxWjhYM9GIMSkC82+Z4g/9c5q4B03+KqGqGhWVkHs4Srov10XudU9phwzaZyxDI3H8/uOYJZEGIVgMAdqtS8ex9BeYImtlldLdAwIK1f+hz5ME9Qzy8Lkiu+Olw7AUkI6TCRMYL3Rgtn5DgW8TSNc8YVjvwTt3AYPhHcu/OLTVrl5LmodrPxbloi5OuKKhgWrUti0N7jTEEbVJDO4jI16wzVfu5Ppd4EGurQYj1t81mEvpKgypjThAT7ZFaTiXE80085d3g7h+B3CHKAxqMghytcWADghQRQgRHRSSn2GoO0aAeyqCPYJc2h8D7MCBFK10DWwkRrQRTcRcPYtoij6WJWVomyQ0DAU6G7usFc8GkZbwo8UzPWsuy
 +KGBVutK
 pXTR3efjwo2AzBXh6sSGdzb9XHGkX7/J8gUQYrw8O0fF3M1alU1y0tGscL8FgbAhIeXpkje2v71N/aHbgM9d3BcANYHAuQDnVwqdmYAPvymVY3uYulW1yw9rZ0jsD5rjAX6b78PXImMS2CS2I/2qDJ5JB611KXhwLB+mfC2Xykx8yrM86lwnwM9LRbrlCWa5izUqDH7BGaI5QgNSzC9sItrIQfw4ziqk2KJz2enp6sBmeBSJ0xH/S3Q190pTNY4hX01VZXkTXGWJlxK7KDFSd426DuA3b/wFXKeC+lr1ntEIAM5/IZFn/lkbdCuTAZ7LyjmuNhP8gKJwNVOx5jFtXqwltSQvh2DGWreJIK9AYbuGoPX3OiHYUhvNYlnwhNb1VjpzMxYlHk68WQ/v5JJpHgharYroHIc7voiH9XAuispGXUacb7Ua4nR0aMDdWtLtuQZAhb4Y/GFBHshz+XT6qnYs0NKcllBIgSZOJleeSB9jnnU8c6AoKGIV8PZIDprxspMlTi28F0tZJI9IbeSTxJEid3i12B75WZTboFJfbAzJpbgIOvrLQD82IoNFXtayjpAgs0eOK/CiKqb6wiB4NEPWGHJgNwlbW6aJobd2v9Ha4l6yAPOzj6DQQXkcAnDCTRKu0T5I3eCxN7bw7kL4uwPJokHCWl8aoQSvCQSFfLTOfXFo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, userspace has limited visibility into the exact active
runtime state of memory allocation profiling and its page extension
compression ('sysctl.vm.mem_profiling={0|1|never}[,compressed]').

While reading the sysctl provides basic on/off status, it is currently
impossible for userspace to natively determine whether page-tag
compression was successfully enabled without scraping dmesg boot logs.

Resolve this ambiguity by exposing the active compression state by
adding a new read-only sysctl `vm.mem_profiling_compressed` to output the
state.

v3 change:
- Added documentation about the behaviour details of the new sysctl.

v2 change:
- Moved from displaying the state in /proc/allocinfo to a new read-only
sysctl.

Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
---
 Documentation/mm/allocation-profiling.rst | 13 +++++++++++++
 mm/alloc_tag.c                            |  6 ++++++
 2 files changed, 19 insertions(+)

diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/mm/allocation-profiling.rst
index c3a28467955f..3ad1e9aacb9a 100644
--- a/Documentation/mm/allocation-profiling.rst
+++ b/Documentation/mm/allocation-profiling.rst
@@ -43,6 +43,19 @@ sysctl:
   warnings produced by allocations made while profiling is disabled and freed
   when it's enabled.
 
+  /proc/sys/vm/mem_profiling_compressed
+
+  1: Page extension compression is enabled.
+
+  0: Page extension compression is disabled.
+
+  This control is read-only and reflects the compression status initialized at boot.
+  Note that, unlike `mem_profiling`, which represents the current state of profiling,
+  `mem_profiling_compressed` represents the state configured at boot time. Turning off
+  profiling at runtime will implicitly make this sysctl effectively dormant. However, if
+  profiling is toggled off and then toggled on again, it will resume with compression
+  still enabled as long as the value of `mem_profiling_compressed` is 1.
+
 Runtime info:
   /proc/allocinfo
 
diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 52aece27b00e..877068241f06 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -1303,6 +1303,12 @@ static const struct ctl_table memory_allocation_profiling_sysctls[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_mem_profiling_handler,
 	},
+	{
+		.procname	= "mem_profiling_compressed",
+		.data		= &mem_profiling_compressed,
+		.mode		= 0444,
+		.proc_handler	= proc_do_static_key,
+	},
 };
 
 static void __init sysctl_init(void)

base-commit: 94f9b3980dd446b56acf1dfed649e9b32a9f3813
-- 
2.55.0.508.g3f0d502094-goog


