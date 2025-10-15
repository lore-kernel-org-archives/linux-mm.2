Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A8BACCD195
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 19:08:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBB5D8E008D; Wed, 15 Oct 2025 15:08:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1D2C8E0005; Wed, 15 Oct 2025 15:08:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5B4B8E008D; Wed, 15 Oct 2025 15:08:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B922B8E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:08:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5ABDD1A02BC
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 19:08:39 +0000 (UTC)
X-FDA: 84001285158.09.A36F969
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id 74E3080014
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 19:08:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TTpvqZSC;
	spf=pass (imf30.hostedemail.com: domain of inwardvessel@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760555317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x4+5aOgvWODOPGtO0hDqGiqO++kewzL0OPl+hME7NKc=;
	b=G6MIBbLRG7wsgvIrcn8riLppccstHk5QsDB7tJFhTuCLT7Ubm3Lqz51lSOZ7ETt1KIync9
	LOiZ3iiY1Qd4Y3L32eTqOpVxtbQcBKrEQpoWskTWrHgN321kvFB86nka+4AWndmjmp+DX8
	ve+yZvSAQDils1ALyOuI9E+sYlk7Os0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760555317; a=rsa-sha256;
	cv=none;
	b=GHfnRzXYHtRGPKh+gqET19WldUi/7SjK2n/ONVIGjDaXBin+SR9cjBCKlc45TS6Hif3vbb
	atlSOzZ6SHhxicJbCIbaShQJzLlhb3taUp1gxFGVLKWTXtISTpRmVp54a5i760xqVtVKQG
	b3wzVtYFcIOdEbES8z4Fv5lDwiFiR6M=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TTpvqZSC;
	spf=pass (imf30.hostedemail.com: domain of inwardvessel@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-780fc3b181aso4215116b3a.2
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760555316; x=1761160116; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x4+5aOgvWODOPGtO0hDqGiqO++kewzL0OPl+hME7NKc=;
        b=TTpvqZSC+9Na+enJRb8Pwk7S2gvkjlIb0AQLoTx5eQniiSkyGaI0vTdGC2EPPizACW
         6xrlt8KVSqDFsrOieG6XFG8bZy61wupsx4/hkSAMh2mO4XvlpvWKljXqu917f2p7u5YS
         W4Qt3uFbYQwurE+3PuMhuw9EuTPRH7KGjUmU0AxYDmqmytoUidPcdLtgvxv6cMphdTxG
         Q9H9A7aP7rVpYchmCMFgb+uxPUPeTimZGs6GZM64rdZss7LSXgcoRVdz5vIwR8CtxOkg
         NYFObLSxcxL2ayw2uAFFC2gfhAIo/6/heoYI8xwT8qbbjvQSka/4DFcNKueW5pK3xdE1
         SscQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760555316; x=1761160116;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x4+5aOgvWODOPGtO0hDqGiqO++kewzL0OPl+hME7NKc=;
        b=tp8qLpT2MWDg7LxKl38xW1faMiA/N6V+rOidZ8yv1HVImFtJjh/JGJ/pEXrXO7vbg/
         rF2XFk4WJzDy5fZidyujrxT+tlN2S1v49CXFHd2IFVRDoYxYIPXcDlL6rtmeMvB9YfUv
         D5jCC+Sq0lDu3AQtixtMQXlWXB4dYuYuBpKSalTsC/5YzjR2eWJP101xhJAO4ICivVv8
         lRjZqy2Al7LO45sMxNfmzSGxbqVD3IiGdoMpMGoGKPQSWlEVUY6FxrBH9a7CIbQBGEwz
         4PzEQJ/Z0U+D7B5lsguYfk+SWnQajxK4q9BKvK2/Thw2rs3Ix35CnyC+KGCfhL4QghLW
         Zx0g==
X-Forwarded-Encrypted: i=1; AJvYcCWO6kqnumjo6bLv0ozfoEqft+qkhaDV9U+1gNlvIfhsO+wkmOdJ3pgDi6g+KLxvFwPlc/6VsDscfw==@kvack.org
X-Gm-Message-State: AOJu0YyLCYSY9bs6ZnQPo6/h9AYvUejYfPgdVmG+lJMUVE0GXnxl+2O2
	ZY6+Uofb0m2nye3Em070jDWOg/sZx1kUwrWD21vTJSVfuH14ShLBPX9h
X-Gm-Gg: ASbGncvjSQq4gyDMmjT5GYPX5iVBuSpgX5uS9xjDSFzD5/mA5eOjNnMaIX5vPEMoE3I
	iAzd41P/3Q2WBIOM4MQlDYoTDZe7HozBCuNuAuh260b9h7yfddbryu5oqLGvYrN8zHWqL3UdVoy
	bP+r1rwNiE4lGecKRCDm5yzGw57E1ehGv127UoNNugk/kHWbR9Cocl+oDVKh2AImzCyAVQITuY1
	yrp3J0AZCWkV5hANWDZ4oB4d7+oUpUXY4wTRzfm+Cf4dL1PoDYl7p2ZuSGsR9fBFyhsuZsIlIsP
	boptOmNgv1SVcqKnJw8P2yOyeUAiu6WJxbM8ZfFVrYQVMggRQ2MAycBxvh+NhMqYUISbKzy0PHV
	Jjbm3JT81xKQZzJyXvKa7qTYK7cwlgXQkb3twM29dvudJPNMXOuHhWz1rRo4UncpT3fCpKA==
X-Google-Smtp-Source: AGHT+IFmVjoy0/RXg9J2/ujgSWA6hbqUoUjXe12ni5dKrJHqDFKqV95/Gh1KnAb6dMRdJCKgoA9fqw==
X-Received: by 2002:a05:6a00:182a:b0:781:275a:29d9 with SMTP id d2e1a72fcca58-7938742c7aemr38835163b3a.18.1760555316194;
        Wed, 15 Oct 2025 12:08:36 -0700 (PDT)
Received: from jpkobryn-fedora-PF5CFKNC.thefacebook.com ([2620:10d:c090:500::7:1069])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7992d5b8672sm19483106b3a.69.2025.10.15.12.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 12:08:35 -0700 (PDT)
From: JP Kobryn <inwardvessel@gmail.com>
To: shakeel.butt@linux.dev,
	andrii@kernel.org,
	ast@kernel.org,
	mkoutny@suse.com,
	yosryahmed@google.com,
	hannes@cmpxchg.org,
	tj@kernel.org,
	akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2 1/2] memcg: introduce kfuncs for fetching memcg stats
Date: Wed, 15 Oct 2025 12:08:12 -0700
Message-ID: <20251015190813.80163-2-inwardvessel@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251015190813.80163-1-inwardvessel@gmail.com>
References: <20251015190813.80163-1-inwardvessel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: st68mdyqaqd9ou3mqegc7e7f67sdie6y
X-Rspam-User: 
X-Rspamd-Queue-Id: 74E3080014
X-HE-Tag: 1760555317-776378
X-HE-Meta: U2FsdGVkX199HFdAkqAg5A2z9EhfI56qJLECoX+G96vsFa9c65AwUX1rzGB5/DVXfCDG+SmQYMFO+EfTla9vxfy04Ul305kEldKVE/johfa4WCIQU9BA1QnrklO3pNG6jeTChhO/Cg41CpKizOl8pHHiKmUv6BvNUApB/Q6UDob022aRWCPTWd/UN0ewXwSfSMb3komHWgMVfeBPLisIJ6bQnvPPEQ2AbpBhKIIa0VAv6bwzJTvG9SdQTWwpPcbOXIkpHcjDfW0EIi6omn9tZnFVCJL8YiD+/Gx6sr/HqFSiEENrq/AHhvKHymcU+GdZFihmaAk7lnUp6tk4yJ2jTCMl6KnPYHzUPHYCh671Aj70UxHJE4FVZJZtfC2KqK1vLYhy7EmYLe888dpgudThwm+B5OLFTv874IqsF+WtKIkcHy8WUauhQmPFEHKny85vWe2kvlY1E67JjGzevFgJiT5nTawqa4avuXnvjKRTzUZLjjnHBVd9QaWMT6GaZNdcrb/dHo5SoAThMkX84AUSnnxdgID5G5v4n8daYhDEy4/ov6Dh/39xE35ztOQ4HJQKsnmwYsAP5kv1GXXSpLA0EwhZ9jSffAkX/cb2zXwMSogszeoMXN/AfV3cvaHtYOxJHBDttPIElimNRd4n9x+KlyW+wrXd2nYBsvXC853LpEQBPqKcxzJm3eBV+6ThQAZI3A4MhuaTSYPurCT2ipCUG/esHzjvoHj8Bqagky8wlDFL3tB29mEMR2GUrA/du0o87zJrPZAANJmDd20cm0xIJLpz3tyhNsXLJtj5DIoIdJ+b1RG26TAEhlFSvWlEZhBk5yNp1Y5WvhYuQLABMmFOoyWFbNB11eRcm7JZpXw5zjY2bivCvrvDZ4VSf7pLXaMhPFAreuUF9EK5GInnhsCim3k45am+qvCGvhOBQLlVob0mqMthVqL4HdPUxcPtjhdIcaxzFZ1ceG+ovsmfLFB
 LmAnG6Xl
 82DQ29tUhJDYLvpaSoNAz3fjIds8hDu0E3rBx3MGlN6gErhQAFKorIxe6fCVmedDhqjEPKf52ZLF1b+KfRntmM2yXPy2odJ6LeFs2BOJbJ4EApZlgNa3LBZ98rAGjDgYJ+05wMIN3PwtPaSm0Gb5rAMko4Nl+djz94v2wwBhsXonr303Fw3VMejfo9pXcI2BXvYY2FRP1TSf7WquYXfS+n3s9k5y7vztyQvnPEWK0jUHsXnve4+zhcqK6+bNw+k/7jiJs/CgBxZ6HbBSXWcPefqGrl2nJFmQ8yGOLWzsih7Oo3JPikowYbixH/2R668BJ0F/w48d0rhFxVwCLW3Kdnb5lO3kMvKvp3wl5pfndfjmUR2AegAU3CBXIDhpsSMQ3eB4ybSh4gz1aY80ant3eknYBiPjdODRFLwPDEaRpx/5C5ls=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reading from the memory.stat file can be expensive because of the string
encoding/decoding and text filtering involved. Introduce three kfuncs for
fetching each type of memcg stat from a bpf program. This allows data to be
transferred directly to userspace, eliminating the need for string
encoding/decoding. It also removes the need for text filtering since it
allows for fetching specific stats.

The patch also includes a kfunc for flushing stats in order to read the
latest values. Note that this is not required for fetching stats, since the
kernel periodically flushes memcg stats. It is left up to the programmer
whether they want more recent stats or not.

Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
---
 mm/memcontrol.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4deda33625f4..6547c27d4430 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -871,6 +871,73 @@ unsigned long memcg_events_local(struct mem_cgroup *memcg, int event)
 }
 #endif
 
+static inline struct mem_cgroup *memcg_from_cgroup(struct cgroup *cgrp)
+{
+	return cgrp ? mem_cgroup_from_css(cgrp->subsys[memory_cgrp_id]) : NULL;
+}
+
+__bpf_kfunc static void memcg_flush_stats(struct cgroup *cgrp)
+{
+	struct mem_cgroup *memcg = memcg_from_cgroup(cgrp);
+
+	if (!memcg)
+		return;
+
+	mem_cgroup_flush_stats(memcg);
+}
+
+__bpf_kfunc static unsigned long memcg_stat_fetch(struct cgroup *cgrp,
+		enum memcg_stat_item item)
+{
+	struct mem_cgroup *memcg = memcg_from_cgroup(cgrp);
+
+	if (!memcg)
+		return 0;
+
+	return memcg_page_state_output(memcg, item);
+}
+
+__bpf_kfunc static unsigned long memcg_node_stat_fetch(struct cgroup *cgrp,
+		enum node_stat_item item)
+{
+	struct mem_cgroup *memcg = memcg_from_cgroup(cgrp);
+
+	if (!memcg)
+		return 0;
+
+	return memcg_page_state_output(memcg, item);
+}
+
+__bpf_kfunc static unsigned long memcg_vm_event_fetch(struct cgroup *cgrp,
+		enum vm_event_item item)
+{
+	struct mem_cgroup *memcg = memcg_from_cgroup(cgrp);
+
+	if (!memcg)
+		return 0;
+
+	return memcg_events(memcg, item);
+}
+
+BTF_KFUNCS_START(bpf_memcontrol_kfunc_ids)
+BTF_ID_FLAGS(func, memcg_flush_stats, KF_TRUSTED_ARGS | KF_SLEEPABLE)
+BTF_ID_FLAGS(func, memcg_stat_fetch, KF_TRUSTED_ARGS)
+BTF_ID_FLAGS(func, memcg_node_stat_fetch, KF_TRUSTED_ARGS)
+BTF_ID_FLAGS(func, memcg_vm_event_fetch, KF_TRUSTED_ARGS)
+BTF_KFUNCS_END(bpf_memcontrol_kfunc_ids)
+
+static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set = {
+	.owner          = THIS_MODULE,
+	.set            = &bpf_memcontrol_kfunc_ids,
+};
+
+static int __init bpf_memcontrol_kfunc_init(void)
+{
+	return register_btf_kfunc_id_set(BPF_PROG_TYPE_UNSPEC,
+					 &bpf_memcontrol_kfunc_set);
+}
+late_initcall(bpf_memcontrol_kfunc_init);
+
 struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
 {
 	/*
-- 
2.47.3


