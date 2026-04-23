Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B200FDEE48
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 20:34:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFB9D6B008A; Thu, 23 Apr 2026 16:34:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E60366B008C; Thu, 23 Apr 2026 16:34:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4EC96B0092; Thu, 23 Apr 2026 16:34:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C25C66B008A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:34:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6AACBC1AC3
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:34:51 +0000 (UTC)
X-FDA: 84690974382.06.2F52614
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9BC84140002
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:34:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IVEX7DaF;
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776976489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dt6QPYXRPlOeK952eds6qWokMWJg/x4011D3wXxWslY=;
	b=IHL31kPJ8BF68vnYjTh6kzwZEEyysylXHVhsBHhHhkZ5Yi0la7ymxDYb0HzHptsrlbYHxa
	H6x944wVzbpL7CCdhj9fT1fKGBXn1rmAxPndWlgnGN3qXii2XcC8D6f3QdFQm3j3zILcUn
	o55r8wbfp1wwLbQv5Hs9sZayzEINyRU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776976489; a=rsa-sha256;
	cv=none;
	b=XJsE0cwGgQ+KHwNleAboq3DcyELI5+3wn9EVVie2v7Kc451rrdm/QjEBHY9COW8sFgoBHY
	9ySd3Abm3EWjPPqa541bnS+TAUaVeoADXKUw8xmZruM15Be9KT5BkEpT6cqTXLvhp0+54m
	0pSm0ufaHS5PkNPpz8IKiwTsPSv7xn4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IVEX7DaF;
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-42321c8b8f5so5891173fac.1
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776976488; x=1777581288; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dt6QPYXRPlOeK952eds6qWokMWJg/x4011D3wXxWslY=;
        b=IVEX7DaF69q8jd236hf6kb6+IdFIPyiuI7eCqYA43tDpU4a/yWpdwmY1TRx3stzgzI
         Ce0qkjAanRAO3BD7fKXupK45UA/CZZ3tNGMpAMOL74ygjj2g/1Ehrtl7/nuwH9V6/VKb
         pduGCcSPCUdI/lnYltpYCLcIIKvXOviximDqdJrN/rTUNns/xklwpxkwqZ2wXEHVLRje
         GB2ukFGqJa5c3r9A7kYt5lJ9y7IG7gkB1sT0wCfJhQMOYn7HHMzPfJzcMQPVaO9Ckdvk
         lGINnMdPzmoqvI+wibSfE74cnivt/uTc85/Txk8L1qHsuOF7m6oZfUQvco003UWuV+Cc
         YOFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776976488; x=1777581288;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Dt6QPYXRPlOeK952eds6qWokMWJg/x4011D3wXxWslY=;
        b=OVPUzx9i9lqSG5LN+oz8bwB1Qh3Ot3p0T20z9gXZF+oc9z5v8JPppGBzu03wVkhh1g
         sFLx53N0OWNWbnZeV4qK6gAlAZuomQWdSGBqKhXX0fF6fznXG4Z323sS4Hfzf3ZEW32j
         i9Os2gc6RStzcWmra2yGLXPSxwl6wkheZoQWzZVtzBzWJEOfZCrdGt6EmW+J55kX+drg
         AZvO1CYM4JgupsrfelQYHf5QFUO9v+R25LwQZvGr3Bd/wBvYP9X+Qbkel2OXubbr4PoL
         beBVu1N1vdiTu+AU/5tRvNOV6oNFKY7Stdr4C7JmABzHbtKBALJ87tRiUBwdDrNqgDsB
         dg0g==
X-Gm-Message-State: AOJu0YxTuDy9c5CYYJGs+koGmNEeyEdYP2ZiYN7hL7nbZtJPTnFjYKot
	xgFo7e8u9BqVMJTDyiCQ5j+7ro4xqd33W739s98Q48zDr9BO6ldGvFx4AgGo4w==
X-Gm-Gg: AeBDies+33PXnGyZdCDc2FIXuND/AonvKA/eN6O5NEUXICM82lcC9XakcgSguiRZL0T
	CHpPCwTEc+2sF32ibgBfRoy9QPhYxJs9CmwUWAjCFK44M1OOI8RKHoBS8WXlUBdF8K/hrMkkTSI
	noNDh17Ickk9FcsyIyTkilP4z6RkD1c/G+hFL6bGI0dIk5iYlMBFgrf1MzNKk0fEfTj6TVmH5NQ
	NGy/S4b78NoUH74aFEYmrroJdt5ouS/tTTL9uSZc6MCh0CW0KYIYvxtMsfHNRN+YkbXngazpTsP
	UQaMsIggsRtn2Bk5TVk8SvWmMP1kOQKQFbqKoYFSWA9Po1cAUKFvi9JjHhvnC8u89EgQ7JkTJ16
	8tZnao2Q592cugZwt1VMpJyZITT6uM01PE85SEovw1i/nYOdulJAPdHKSS6ljSsoDWUfRcdsYcg
	06cZ9nl/OVR8T5MZgECaa6yhHpUE6y
X-Received: by 2002:a05:6870:88a3:b0:3e8:926e:bf9f with SMTP id 586e51a60fabf-42a99ab5f12mr15325305fac.13.1776976488180;
        Thu, 23 Apr 2026 13:34:48 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-42fe61449bcsm2793964fac.11.2026.04.23.13.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 13:34:47 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: linux-mm@kvack.org
Cc: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [RFC PATCH 1/9 v2] cgroup: Introduce memory_tiered_limits cgroup mount option
Date: Thu, 23 Apr 2026 13:34:35 -0700
Message-ID: <20260423203445.2914963-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260423203445.2914963-1-joshua.hahnjy@gmail.com>
References: <20260423203445.2914963-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9BC84140002
X-Rspamd-Server: rspam07
X-Stat-Signature: gmfu11jy5e5grj9on33pzjcmtz85khuc
X-Rspam-User: 
X-HE-Tag: 1776976489-400194
X-HE-Meta: U2FsdGVkX18dwUok9iY3MxkfZcZ2krjefH2X+Cdpiyk663Rvyef/UeULSNJ2yzef3YqvOmYsvTP20cBpzxpjGWYP4s23WOjT0/KEqVSTOGeokCKrcSU2ZPnpHoxrk9QuVsJfH+94WXXukIMFeq/RuRsIMV863jotWQ97aLSjA13dRdhZeGuT0y3O6GBYa/6aa+fadmHqRiniMw48IIRVSeqBrv890hdBGq0gPDBqPDTJEv8zOIgNCM1hWjZfHfCdT18EAQ1AslJXV3gXOQ5oCWFLQsYbFK2NoW9BlPECsCWMW5H2R7gpXU0ri0UTnxUUTAyvkh2ChwRwx3PUDOuCegGODZCZOPTBAfPD4CmmWRRLTIk0bmchaGvc4jAh5GIBEJWpOgoelQwSikGhw5h/HufLAWi1RAfTUUy1Ug06eit1tYWUyINe9LYjdxgU2SQgcSLXBo5WrqCfbXMUGbWdyiCOlCCRKwPwdCevfw5h7ckxiQIy32LarUUhRBVzzNw8XdmX2j2iy3WZBsJdnHkT5m7sUqm4pyo4V/N399D06UxOqTgqpLQlf6Zo86Yz4oKOxD57TvQ+mpGVu/ZtUN1bznycJXViBrRyCf+Ec6Dbfz32PTaG31C3dR65qLIuRyuXK9Dn8F2KgntEybd+nQb5Tz9MdEBZ0sNrtfMI/1daZla6sYyTzQkoL+2E7gG1DGQdXEAnO/1u6xSJytWZ37R5pB/OK/3HHMp78b/HS3zNyet9fxpEu0vDWtR7W266hkw+pWw9WU5XZqYlUHLVrwmtBSBezpG0WEOOG74273ebDb4MfcJpW1p9XZ1g3yfqH+0Yu/RByLfXjpcbVMgNPUg3i0aeK5kS7qbB4vkcWC/pCDVfFoc682UKNiU5Y1Ow02hei8TVtEaIDoXYT8QMAWPKowCET/gAlO6y0OEvbCtBqRAz29aG2ZCyL4OdWOwMq8Hx/gTHantdXzigmpHgkXS
 y4ew+uIE
 6fl+VzZ94HfINUQYOfBbbfDipdinoNWqHGdhZFUr6EV9y1PEEG+mdqhSIYSZsbOUsxjKfcFhd2ik3No3baoVIOrW/PYcJfQI1WR8ZxlUgtO/fubmbelmKma80u7bzf1hUT8jpXs1j8Q4TzTv7yUxydqAZIFpDWwv0NA8ZzYskqNIVYxzwm5Eclk76H3c7wK98p/iWTXfLiVCJKioO9g3NbpJyXkYVlZvtWdmYpSyi/nCbhLt9dBimqQrVLUAcp+6sI/sVjMkRBGv6rGDjPMLYyCcQH2E6Qnjzhz2lc0Foe1rTVd2zReZB8GdWgGrhMDULm0Fbb19Arv767iYHhRF6itqdGV08wzVWXMfllMW5I6oKCT7TKTcbKR3b9riuwQa5i8KxLlG9/XJFH8pMYN99276I4iEuxIbor3ke/jy3cuTbq/h1kI7VrjUP7xoFJCvZxwUPdtB+2uFUejJT4olohGZPFDlYRIr5lVDA+ZmIRA5nOgwkpcn8IfwSOEJ+h0EZY04Oi3P3o7vhMk9h72N6I5MJ8gN4K1hnc2TnyUuFht/JatyRekWPN7eFnZcokcyH+s2PIm68zBCRPUE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a cgroup mount option memory_tiered_limits to enable
tier-proportional scaling of the memory cgroup controller limits
memory.{min, low, high, max}.

The mount option currently does not have any effect.
Later commits will scale memcg limits proportional to the system's
toptier:total capacity ratio.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/cgroup-defs.h |  5 +++++
 include/linux/memcontrol.h  | 14 ++++++++++++++
 kernel/cgroup/cgroup.c      | 12 ++++++++++++
 3 files changed, 31 insertions(+)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index bb92f5c169ca2..0b6861f4faece 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -128,6 +128,11 @@ enum {
 	 * Enable legacy local pids.events.
 	 */
 	CGRP_ROOT_PIDS_LOCAL_EVENTS = (1 << 20),
+
+	/*
+	 * Enable tier-proportional scaling of limits for the memory controller.
+	 */
+	CGRP_ROOT_MEMORY_TIERED_LIMITS = (1 << 21),
 };
 
 /* cftype->flags */
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index dc3fa687759b4..be45641e890e4 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -533,6 +533,15 @@ static inline bool mem_cgroup_disabled(void)
 	return !cgroup_subsys_enabled(memory_cgrp_subsys);
 }
 
+static inline bool mem_cgroup_tiered_limits(void)
+{
+#ifdef CONFIG_NUMA
+	return cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_TIERED_LIMITS;
+#else
+	return false;
+#endif
+}
+
 static inline void mem_cgroup_protection(struct mem_cgroup *root,
 					 struct mem_cgroup *memcg,
 					 unsigned long *min,
@@ -1084,6 +1093,11 @@ static inline bool mem_cgroup_disabled(void)
 	return true;
 }
 
+static inline bool mem_cgroup_tiered_limits(void)
+{
+	return false;
+}
+
 static inline void memcg_memory_event(struct mem_cgroup *memcg,
 				      enum memcg_memory_event event)
 {
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index babf7b4560488..6a34d0e179dc5 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1989,6 +1989,7 @@ enum cgroup2_param {
 	Opt_memory_recursiveprot,
 	Opt_memory_hugetlb_accounting,
 	Opt_pids_localevents,
+	Opt_memory_tiered_limits,
 	nr__cgroup2_params
 };
 
@@ -1999,6 +2000,7 @@ static const struct fs_parameter_spec cgroup2_fs_parameters[] = {
 	fsparam_flag("memory_recursiveprot",	Opt_memory_recursiveprot),
 	fsparam_flag("memory_hugetlb_accounting", Opt_memory_hugetlb_accounting),
 	fsparam_flag("pids_localevents",	Opt_pids_localevents),
+	fsparam_flag("memory_tiered_limits",	Opt_memory_tiered_limits),
 	{}
 };
 
@@ -2031,6 +2033,9 @@ static int cgroup2_parse_param(struct fs_context *fc, struct fs_parameter *param
 	case Opt_pids_localevents:
 		ctx->flags |= CGRP_ROOT_PIDS_LOCAL_EVENTS;
 		return 0;
+	case Opt_memory_tiered_limits:
+		ctx->flags |= CGRP_ROOT_MEMORY_TIERED_LIMITS;
+		return 0;
 	}
 	return -EINVAL;
 }
@@ -2072,6 +2077,11 @@ static void apply_cgroup_root_flags(unsigned int root_flags)
 			cgrp_dfl_root.flags |= CGRP_ROOT_PIDS_LOCAL_EVENTS;
 		else
 			cgrp_dfl_root.flags &= ~CGRP_ROOT_PIDS_LOCAL_EVENTS;
+
+		if (root_flags & CGRP_ROOT_MEMORY_TIERED_LIMITS)
+			cgrp_dfl_root.flags |= CGRP_ROOT_MEMORY_TIERED_LIMITS;
+		else
+			cgrp_dfl_root.flags &= ~CGRP_ROOT_MEMORY_TIERED_LIMITS;
 	}
 }
 
@@ -2089,6 +2099,8 @@ static int cgroup_show_options(struct seq_file *seq, struct kernfs_root *kf_root
 		seq_puts(seq, ",memory_hugetlb_accounting");
 	if (cgrp_dfl_root.flags & CGRP_ROOT_PIDS_LOCAL_EVENTS)
 		seq_puts(seq, ",pids_localevents");
+	if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_TIERED_LIMITS)
+		seq_puts(seq, ",memory_tiered_limits");
 	return 0;
 }
 
-- 
2.52.0


