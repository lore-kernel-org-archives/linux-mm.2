Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE374CCF9E5
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 01:05:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E7F68E0157; Sat, 25 Oct 2025 21:05:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BF9F8E0150; Sat, 25 Oct 2025 21:05:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D6308E0157; Sat, 25 Oct 2025 21:05:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0B8B08E0150
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 21:05:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 77EBC1401EE
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 01:05:34 +0000 (UTC)
X-FDA: 84038472588.05.B0C57FE
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id 91DBE100006
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 01:05:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C42dWLaK;
	spf=pass (imf05.hostedemail.com: domain of jinji.z.zhong@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=jinji.z.zhong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761440732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N36vhbRkSG6GC2TdNjzZ1OMz+RKJl4mIAfGLbGj75+A=;
	b=Zpv6eZgg4rkbM0qqAgdmpOPQd2MBVrXoz3uS4/3B1Kwtq4xL+MmjqKAzZC29bMTikhTJ1l
	EYy73ffrk3A+YbcgqXtJiftVLSRybG8E3OwP0FwXYdFEoMYCz1qZBGMrD4uqt/ffKzPjgD
	S6/7jNZn8rUF+C++hvRL3ZMKEwFi4rw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C42dWLaK;
	spf=pass (imf05.hostedemail.com: domain of jinji.z.zhong@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=jinji.z.zhong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761440732; a=rsa-sha256;
	cv=none;
	b=Z8smya6bQ3k0VkUlIaezU/1Hk8hyXY9OZn/q86o70eZ2sVD1LsM1LkOpzp/VHnbqz3ps5h
	Q8JR1McXhxXdZiuUz1qHKX+09m59kII0iUP37Dp8kmi3xtepw7XKQasqEXbI6uySg8RNM7
	g/MZbPQEJgKwGRGUtkSWJq8VmrJghtI=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-78af743c232so3184920b3a.1
        for <linux-mm@kvack.org>; Sat, 25 Oct 2025 18:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761440731; x=1762045531; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N36vhbRkSG6GC2TdNjzZ1OMz+RKJl4mIAfGLbGj75+A=;
        b=C42dWLaK8ER+Oh6Nu45Pq5vAMVXmjcelUHq+co55Zi+b2deHyilK6ZZS4AcA/JGxca
         uvPw4eqvFWRx9EcjX+/TrLtBw0llOZGF3RTFessj6qW2IGbLF9yqniSqz9jl2nu9KGbf
         F9abRONvnHGzY0PJci8s3UksMIM7knH0WiI90gzwLxktwUAc/2QMS8+lrVBTtURh13Kv
         5tMKaFOnQT+oD1hxjBEGh2WOUja63QVgAgWLl3u7cuJuFUW83CkIzxd06Ddgdi0m1OQG
         tkbtPOZgimEl9a6NqLFCCBh4EkCQbDksarlX1f5yzxwDS1Fexqo+dHDlHfFls1qBzJPg
         Ezog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761440731; x=1762045531;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N36vhbRkSG6GC2TdNjzZ1OMz+RKJl4mIAfGLbGj75+A=;
        b=Kyu7xvEsMJM/p60BxuUiZ9A6PrhXSz8lejv+XfhxUdOMENkmfHnMAQXMOOb9v0sf2H
         OM5+Gg3G3wRXxWm5fm6pcRredrJbIMF6x2YnkmRwh0pBeMjbiYWxm2K8FLgA35/p4Y7a
         2J2kMtjWd/EbvTYY+/LbeaaR7GGbGu9d8QgRs17rs+xpQE65xaMNRDxRUK70sT9DBtpJ
         pvEcVcDAinmd3Ppfl3CC9VuFVJaZSGg43Y3Rwz++g0O/Fsvmnq7QuaZg7KztzcWeSo1+
         4s0Db1L9IS21aLgbxYmWLe3AkUh6UhbS6Q1KH35+zXHtPYg4vurt9er2hUQsEHgTZn3h
         qTMA==
X-Forwarded-Encrypted: i=1; AJvYcCVoo4bUpBRc8Q3Gt7+S3zUT6fDEIFpSYJBAHLxsRgW2h8BTZ539N6QQRSYfXAJ/E/VD5646Jch5hg==@kvack.org
X-Gm-Message-State: AOJu0YwWvyayiq0bPKHuBOa0Bg5xwW/NbBC7Hb0DuGr+taN5iPebfptj
	KIixQIYNqCty93CamGyfPVjcEym2UCv/4B6F91My4aEp0ElKaIfD9lPx
X-Gm-Gg: ASbGncvaW6ytiewHou5w1CKsz/yKanVYTeBHy0S91wvX7ubNHoDwUJNZrNvmzOMbl30
	tugVbwEgrirX8RoB/EbRBnrwfAeVS4pitN9rT/06MNuncDL8ru7nBheB0I+YjxrzuqjKS8nH1Fl
	Oe1kovfC2UTCJfJjwzQ2/sPH3rUIvl9kArjtcDG8NrYr8lcADMv5RBKZU5MEPrK1Q4c+Dwl4UMM
	f4IoxBf2rMyJ3FQDWG8LluqZILbeog4uNRBATpBu3sG5VnlgzZQHxGfwG0SCoA62RwPzHR8k9Pc
	kUaiyHFxXA48tK0vBXYaTOsvBFn9Ywvpdl7w/Wu+Zl1EFThVr00D+T3IWWd9/m3B4W9xCK+oqWq
	t//7VTr64/MtqI0fzi1uiSsp8LgalYCrSzSu289PltX07Jib6mCxSMihWeSEBU5HAaaVBcDyizW
	kstc8=
X-Google-Smtp-Source: AGHT+IFqnGHut/11Suj2FeTeWv27UHLAlLr0nFmnErIj4agIj4rm3uNWP4XEpAPa8D23/k1s6P6wnQ==
X-Received: by 2002:a05:6a21:4cc5:b0:340:6a50:7e9d with SMTP id adf61e73a8af0-3406a50809cmr6289528637.54.1761440731426;
        Sat, 25 Oct 2025 18:05:31 -0700 (PDT)
Received: from daniel.. ([221.218.137.209])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a41404987esm3371597b3a.36.2025.10.25.18.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Oct 2025 18:05:31 -0700 (PDT)
From: jinji zhong <jinji.z.zhong@gmail.com>
To: minchan@kernel.org,
	senozhatsky@chromium.org,
	philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com,
	christoph.boehmwalder@linbit.com,
	corbet@lwn.net,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	axboe@kernel.dk,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	akpm@linux-foundation.org,
	terrelln@fb.com,
	dsterba@suse.com
Cc: muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	drbd-dev@lists.linbit.com,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	zhongjinji@honor.com,
	liulu.liu@honor.com,
	feng.han@honor.com,
	jinji zhong <jinji.z.zhong@gmail.com>
Subject: [RFC PATCH 1/3] mm/memcontrol: Introduce per-cgroup compression priority
Date: Sun, 26 Oct 2025 01:05:08 +0000
Message-ID: <18d8e6b876ea3ae98bff710474423a9a530f4a8a.1761439133.git.jinji.z.zhong@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1761439133.git.jinji.z.zhong@gmail.com>
References: <cover.1761439133.git.jinji.z.zhong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 91DBE100006
X-Stat-Signature: dx3r85c4t33wtf5cyd57tq66fe3kqs7b
X-Rspam-User: 
X-HE-Tag: 1761440732-652240
X-HE-Meta: U2FsdGVkX19WtR6KkgzOABQkqIh5S6FOLBTqPwcQo4ARyrCBC8yt+T3UV6cNDykRzzJVht5O0jvgK1n7nmPUdWiQ70bow6JgEdp9AOX14lnoCi4uXevkHfOGH6/0yoMuLKyU1781ptvTpjFHGAgbvjYafbXq5yuSBQimN3E25mxy+KouQunkCLQu+QVnVaC9bazmentqZX8y60FoPR/XwlmvjFQNaShgRcCQ71vbev4NGpmd30YCcWqz7Zd1J0e8jfkIOFt8YeE0kj7wrvPwJUSvR8rb4gIT//zG/vlo1Qp95/RTLQMfR85ixK4H6jEHkpqcJD9/4xruIY1W5dxNHMNshoUywf/hy6UXj7IHLsY3cHD50hB/CiNAYxEsrHUEX23vBx8pHlVRbfcJ7tdSAcQrMEC45Sle6WN6VSzY08b3E4l6hGmQ9uaH7g1WsAHArq2Wy7hW1aXT0jXEq+ukH5WMZTQ2qalE2I3/Ud/8CXCJ/LHKd58Q5xEkpPr5/rSvacvnTw+BDfn3DTjiMA3A3dwZLc/vYwsyxYuYFdu+01uPu9AUUR32huPRaLVZewiT5WLK7PY6Z2SdCMfF8WGb2kOrCsIetumjs/7qbZ6nDiWT+atuNZ4MwUrhW+pbQoW+dClZzx2ThtJY5ZlC2KtlCx8ghSIlJLN62l+7L9xzcBXe3Ut8WNIWEKOcSm0cYyiUDIaECWjA3CK4kjnvhNsle2ua/C33ImKuQV17rtcJrN8P784tliIG11aUUiEVbmrB10h+76HoBlLBwCxh43LRlU0v7BIv6Vo9ilESPzJJqZLaOqtwTgJOijHZyz8p1rOwbipA8KyYQ4fzUWlN3e9PXxs17yKUALUqMh80l/YUMfLWeWGWY9HhCA7Vz8F25EZL6AzEdaoit2ZRjeX9Fp93e3MO7jw7tL+hZsupS2CgHRfiyfAxbHxaCs4oj3pfxxAB6jMYk3ZNOdu9Nb7shna
 50/+AnsG
 Ctdjj1hgwTMab3kNUw/Fj8V0VvQhKnklTzJ3XBYmOGnS8TCPf22J1x1mk3aw0oICGDE/ZScbimyuAQmFCtMOXmDmfqA1AdPhFpCqhwLpYSkk9d2eESTZtrHgnn4cJZ0KCydqsyDrJFpQDB+kx5ionftJx8Lq2siM4Aur/0wwzkOCH4q9JyDRnSQnHtMm+zCtYBUEsSlf2kVzLy3McgVfPw7/P7lWlR6ahVwYSUSwNnh1FbYu6ISSFCA2XOqvFLcqz/7pIbm1MLEw4NoXfFSwHIPHaxmw4Ou2Cxktl6dpniDpG4Akjd3/59zKiC+jyvJJ0DkzRNVGTrb82fMoq1NkcxXBskUl9MU7QveJG4mpahYz0J40PhF+9UZJywgCYgKQOvCvfs9UFHn4/iofICLICqQO1m179VrqPlndm6j1tqm+O4I1N6mxSaxxXORVFK1TdQQr2Ff0IiBPYnFQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Android, applications have varying tolerance for decompression speed.
Background and lightweight applications tolerate slower decompression
better than large, foreground applications. They are suitable for
algorithms like ZSTD, which has a high compression ratio but slower
decompression. Other applications may prefer algorithms with faster
decompression.

This patch introduces a per-cgroup compression priority mechanism.
Different compression priorities map to different algorithms. This
allows administrators to select the appropriate compression algorithm
on a per-cgroup basis.
---
 include/linux/memcontrol.h | 19 +++++++++++++++++++
 mm/memcontrol.c            | 31 +++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 873e510d6f8d..a91670b8c469 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -228,6 +228,9 @@ struct mem_cgroup {
 
 	int swappiness;
 
+	/* The priority of the compression algorithm used by the cgroup. */
+	int comp_priority;
+
 	/* memory.events and memory.events.local */
 	struct cgroup_file events_file;
 	struct cgroup_file events_local_file;
@@ -523,6 +526,22 @@ static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *ob
 	return memcg;
 }
 
+#define DEF_COMP_PRIORITY 0
+
+/*
+* get_cgroup_comp_priority - Get the compression priority of the memcg
+* @page: Pointer to the page.
+* Returns the compression priority of the memcg the page belongs to.
+*/
+static inline int get_cgroup_comp_priority(struct page *page)
+{
+	struct mem_cgroup *memcg = folio_memcg(page_folio(page));
+	if (!memcg)
+		return DEF_COMP_PRIORITY;
+
+	return memcg->comp_priority;
+}
+
 /*
  * folio_memcg_kmem - Check if the folio has the memcg_kmem flag set.
  * @folio: Pointer to the folio.
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4deda33625f4..436cbc8ddcc2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5356,6 +5356,31 @@ static int swap_events_show(struct seq_file *m, void *v)
 	return 0;
 }
 
+static int swap_comp_priority_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+
+	seq_printf(m, "%d\n", READ_ONCE(memcg->comp_priority));
+	return 0;
+}
+
+static ssize_t swap_comp_priority_write(struct kernfs_open_file *of,
+					  char *buf, size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	int comp_priority;
+	ssize_t parse_ret = kstrtoint(strstrip(buf), 10, &comp_priority);
+
+	if (parse_ret)
+		return parse_ret;
+
+	if (comp_priority < 0)
+		return -EINVAL;
+
+	WRITE_ONCE(memcg->comp_priority, comp_priority);
+	return nbytes;
+}
+
 static struct cftype swap_files[] = {
 	{
 		.name = "swap.current",
@@ -5388,6 +5413,12 @@ static struct cftype swap_files[] = {
 		.file_offset = offsetof(struct mem_cgroup, swap_events_file),
 		.seq_show = swap_events_show,
 	},
+	{
+		.name = "swap.comp_priority",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = swap_comp_priority_show,
+		.write = swap_comp_priority_write,
+	},
 	{ }	/* terminate */
 };
 
-- 
2.48.1


