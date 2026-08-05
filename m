Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AF63C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 17:29:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E7086B007B; Wed,  5 Aug 2026 13:29:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2979D6B0088; Wed,  5 Aug 2026 13:29:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D5E06B008A; Wed,  5 Aug 2026 13:29:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E9A396B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 13:29:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7FF0EA05A1
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 17:29:57 +0000 (UTC)
X-FDA: 85067903634.20.C41CDB1
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf15.hostedemail.com (Postfix) with ESMTP id DAD4CA000A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 17:29:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SGNjgqjB;
	spf=pass (imf15.hostedemail.com: domain of 3EnNzag0KCCE78EFPEBH87M7QDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--abhishekbapat.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3EnNzag0KCCE78EFPEBH87M7QDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785950995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xDb6UVUUSmRTt/O3cIrZaFoVx9KXsBi3AsTvyG9chiE=;
	b=aDkIeDoA1iBw52WOzo0MW6GZFS+nIrdoeRDEoboRLZ5SH7ZXD0A9jXyalGZN6ptnI72iH/
	kEwnTt5ycLwbwUUoXJGnjdd/2qwbMhviNIOneSaqXIEMJfJBW/8rff5XQnvcFTbH9vDyvp
	THE7Dqh9nxNMpiW06guBkD16CkQGs8g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785950995;
	b=tPtza4livu6FxP4OTzF/7K3iyEkYGgJxZi/RE79UiuHC0YjhHdk4/ZK6WNbCHfE13dbvfU
	t9/dgMKIBMBbqJOwFaWMsGisR4tCLVumCLvZqpKlqKB+UqXS9SJkquONoZN2IpgA1JgZNF
	pcuEAdYJaysbE4ZW+7Upk5duXd8agI0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SGNjgqjB;
	spf=pass (imf15.hostedemail.com: domain of 3EnNzag0KCCE78EFPEBH87M7QDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--abhishekbapat.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3EnNzag0KCCE78EFPEBH87M7QDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c9c26587e67so106916a12.0
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 10:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785950995; x=1786555795; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xDb6UVUUSmRTt/O3cIrZaFoVx9KXsBi3AsTvyG9chiE=;
        b=SGNjgqjBIOWm9q+mHjZxk1mFIvQk/Vwq5XvrLR3lKuUbiZV2eHaDIXt6G5AHTBpggF
         JftdNoGa91ImTzgf7SrH/SiPU2/+YHqzeajoeGEx5Ym/EBB6cHajZvLl/6iRlt2mB9Sp
         9YtVV8wNxSnXCo4d66L4FlREG+LgGGq6CqR7GhvZG3hUgLveQGc0Mn69y2HFTvezJ6i+
         /8pNa4lLIMd2yt1fyTrovurO98GbRLpWlv7WAUo3WNWPkEX368Ai8PY1n0zW3luJ7IKw
         H8Fs/GJmK9tlbR6ooAtuxkGT+vELZEDHnZEnY2mK2yVUEZc9Y8yGwNrzlIEgneMJel4B
         D5KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785950995; x=1786555795;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xDb6UVUUSmRTt/O3cIrZaFoVx9KXsBi3AsTvyG9chiE=;
        b=fbO6mYdLcLyP7i/sO/IBalc0G/J7LZSL+32cjQitE/ohSdq/P8S3rGXhi3fVTxipQf
         BXrNeqLuNkSXSxf7lu2SlDCrd4J0bYACwZeeO+766lSwYLpRNmvpTLgzv17FSsOpSUDZ
         d1bhrIt4qpb3CHofNx7susc4lkr+VWsk2SYm2+ys2kjNmoTF9dPCh7DX2pZEDHf/iWzW
         ePjx3jF3N9ScBozUdr+k8LwBqUkxt0QtEW4OFyQgU++e5BW5w20exjexRPzPw06I+w28
         bvp1aPG8ynQ3pihzFST32jkqM5vdYN7MQ+ueo1QGtojUGxvDhHL97vhDA9W6kBgdTjpT
         T/fw==
X-Forwarded-Encrypted: i=1; AHgh+Rp6oM4k7cjm8nuRUXhOUiO1vdgBI9lnLgEyQ7A7Eq5bA5dMJlz1WLBMhXAnC7WPA0iLDqF09xMNkg==@kvack.org
X-Gm-Message-State: AOJu0YyjstjOEmqpJ4RIOVQbyakHFDK3d6tr8VW742TY1I5SztDLDEM/
	N7dq069PM28jtht/ctTAh+MNCi98BqJBb9ac1wULUDGoF7mahcv/H5h/fACLqUEL1AvKZbhgOYN
	G2tvlNGSZvLoBEgWpUfKzlunGSuXMer6CPw==
X-Received: from dlbsi11.prod.google.com ([2002:a05:7022:b88b:b0:13e:596e:f99b])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:a97:b0:3c4:3750:2c03 with SMTP id adf61e73a8af0-3cb9c1a2a27mr962641637.9.1785950994364;
 Wed, 05 Aug 2026 10:29:54 -0700 (PDT)
Date: Wed,  5 Aug 2026 17:29:52 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <c795f8089f82841e8a6e00d7ca286da2b23aeb7b.1785950530.git.abhishekbapat@google.com>
Subject: [PATCH v5] alloc_tag: expose boot-time compression configuration
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Hao Ge <hao.ge@linux.dev>, linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DAD4CA000A
X-Stat-Signature: m79wbachbe3mdajkch4obdeo9tf5n46p
X-HE-Tag: 1785950995-389356
X-HE-Meta: U2FsdGVkX18/ru+9kEe/Q+s60m26LjXj0TauyjA0QE/awu7SQk4FcmJsURD+XACLExF4BzpU20V19G8mTUs2r8rBdACIaDD/jKTOG7cJNnZ/KN/HAQWW6mKNY38fCQDrMNEz+9elfsWuAqVfUQG6FGXXxkSkhZ8R7JcYHjMGUbKqO+LCUzlwPk94D8YfwuhBCbE8QZiiHQ7yKyhX6Pg3hh5juJ16KudOx37VuhjP4aNKrvmrbkW0Zy5iM+DQc/VIL5s19/FyKAmlwnjjKfbqfar0rZLLvoVhm+3sW4kMUN3vJuhOteCCGPTcDz2ztRvU0gIqa7ebqH7U98HjARKRXjlXoMnUHBStHrXi/48mIy/Qe0JtgEbKqvb44nJJP/bqJzqzi6wfggL+GPeUgAHNKCHaBJM1mqw7UH9+3gxM2yr2JzWfOS1rfHyEjuzIrfBZdDeOjsXQat/0sLgPc4wkhXuxYNvi2c7eo9CiIpbaFQPCIqn5YyqGubiEQKwKov+pCSD0r9Y8WEliewdyxRzRDCBRPQ6hO/eJJVA+tdr4gMtuw8xUgyIhaEed09nZLWD0zaNfGKiqQcBJ01isItPf5FQemnRAGa9zJovH/IW5Acb7AZbXlOyZiGAkpaEZL4TCfropsvxYewWBKrQ4OU72fNYrZWRgOVFBfRWtSQLeqAl2T6ZNPhbCszWvMaJTZ36nK5/kVDTAR/JCMOmwsaGj70YXCGM1KA3YVXhpTUvj0JcmpzWxP/zxAeFhysdeO1f4xwZoe95k04FmwSSjY42wvnR9rfQfFcWkhij54Yt9K+mHu2Zd3N2R+u+evIRmqomp049y2igEnwO6K/U+PBlAMXs3bM+WoB39v2f1EX0LgKXxPjUjIXNXakvfIh61gyF1TG4a8MVF53J5bhwqlh9YKE3NJkQQzbtpGreCsgRDn/dI+Wh4aO2VhO510ihu4TEAfzaAl41DnzD9bV9p0LP
 i+6TnQgM
 CIMZ1Nz0iworlD+0PTs+0Ez0e4eD8+9x9F2XOI/49Pi5K2Fp6bc6f9u+Z10/IAKpy3bhCJBbJs1kRcSIUThBq/46nkqaLq/aCiD2fVJ1zhyF4syGKo2bczftuoha2aEJI4hdapIik46ZNfDjSIQGq1f7fGdT87lCOu66NCX+0aXUpJ4l1ACQm0tEZueMdF8nnlX/gzgo2Gwae1gF0KqxDrEu0mUhvVsIlOeZnbG+omaMO2tw7x0tA9Pov+0WsSFZLnP0C6CfKs2eBOt8tUU2scPdk+ELBimywxUNg0YI8NwDNvTgqO9RSV7L14LRB2y64xvAHQtKx//l171yzCPdUzrmrUprMO1v8/89tsWx7Df2qZxi96wEfl0zMjSujgeodpz/17qF1A455X7Fp3yk2dpiBezDds7im+93DhvES7u1q6XcFZzSzzb1NO7UyfbTHfb/ZRDTv966rLEvDXVB6uoU3APMW8j3boHzR56MxkckLYsAzkxPL5afIUNr+jhyjDqjZEM9BGKZSAHsmA2IH1YGcqYZZVAvN2lr9fXMUB60iN1Oc4S2E1LHL1S+DMRYFaIny12eRM+bCOrjvJQS2n+f8FpRNvTzYWNH8qXOjn+wXY4DdXNX3pkSqemCHvluheQZCnzyMq5LoFfUG7lvO6lE3+P1KXbhAnFrJbVJHQ9S7ERwRje9WJXqLfA==
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

Add a new read-only sysctl representing how compression was configured
at boot time.

Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
---
v5 change:
- More documentation and commit message refactoring.

v4 change:
- Documentation and commit message refactor.

v3 change:
- Added documentation about the behaviour details of the new sysctl.

v2 change:
- Moved from displaying the state in /proc/allocinfo to a new read-only
sysctl.

 Documentation/mm/allocation-profiling.rst | 11 +++++++++++
 mm/alloc_tag.c                            |  6 ++++++
 2 files changed, 17 insertions(+)

diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/mm/allocation-profiling.rst
index c3a28467955f..b2ebcef8af6f 100644
--- a/Documentation/mm/allocation-profiling.rst
+++ b/Documentation/mm/allocation-profiling.rst
@@ -43,6 +43,17 @@ sysctl:
   warnings produced by allocations made while profiling is disabled and freed
   when it's enabled.
 
+  /proc/sys/vm/mem_profiling_compressed
+
+  1: Page alloc tag compression is enabled.
+
+  0: Page alloc tag compression is disabled.
+
+  This reflects a static boot-time configuration of how page allocation tags are
+  stored (in page flags when compression is enabled and in page_ext when disabled).
+  Toggling ``mem_profiling`` at runtime does not change the state of
+  ``mem_profiling_compressed``.
+
 Runtime info:
   /proc/allocinfo
 
diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 84c5c3783ca4..b33410310477 100644
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

base-commit: a946fa1d96648b92c9f37f0488e0e47a85f9e235
-- 
2.55.0.508.g3f0d502094-goog


