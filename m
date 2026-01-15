Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2CC8D3CCB1
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 05:46:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF24D6B0088; Thu, 15 Jan 2026 00:46:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9F866B0089; Thu, 15 Jan 2026 00:46:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9E7A6B008A; Thu, 15 Jan 2026 00:46:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CAC8F6B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 00:46:04 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6E48E896E5
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 05:46:04 +0000 (UTC)
X-FDA: 84333112248.19.7701639
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf07.hostedemail.com (Postfix) with ESMTP id C068840005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 05:46:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KhYXrz7O;
	spf=pass (imf07.hostedemail.com: domain of 3GX9oaQYKCAw463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3GX9oaQYKCAw463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768455962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=aDAvyad0Gd6nn9PvkirLJfs5+fzAbzM3y3l25Mdn4/I=;
	b=qXRHAdftCcqMwavMajb+NbhiFjWymRJCSJhudAfl3NCuDGwue5EqXByfxX882crqoceUBK
	hk2j6yq697dpKG6UvS+Mt51/qnA1nJJ9reqqNteaCx6UnRvYShtnSb40ymEO1tyS5xGBLz
	of80jlnfQ5tWtxYMZFiZDpO93jD/Mfg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KhYXrz7O;
	spf=pass (imf07.hostedemail.com: domain of 3GX9oaQYKCAw463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3GX9oaQYKCAw463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768455962; a=rsa-sha256;
	cv=none;
	b=WzR8XjBldj+KJWcANdPjQxoSX0LgHzhUk8zwNPKfgNMyBs1FFQiu6dYW2gJy4hTNwxn4j4
	6SttNGMICe82LZkUcGJZ2CNSqj3y2VN1Hg6kX9WmXBZvPxEJQ89N8LO2sGhXIOrcqoqrp8
	g7BqsYbgkOqAvWfZYd8c4bYislep2KM=
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2b6a8b32fa9so470440eec.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 21:46:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768455961; x=1769060761; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aDAvyad0Gd6nn9PvkirLJfs5+fzAbzM3y3l25Mdn4/I=;
        b=KhYXrz7OGClcfJoMGuZb2+Q30rR0qxjbRbKZYtiZMN5b9hyF/mnvSsRb8MwY8nXuaI
         nfGlROEx24QEnplFcM8TR9JXuZIvQjyCpXUEe43tQE4Kw7ZPRB7nzjBLbTCNr+rOiooE
         kfn4PUTUQ72WuqsV74i/GMrPKdBYmuLNKorV/xyb6Ze9dQ4z/wOmMhHNJlgs0qmsqm35
         VZczKi0XsYty1kzMKsj8aCsxyCDbYFdYcW9RHj7zPLERzU/SInhDb3gCXzJCQbwbIzE8
         2laPAftyMFRZK15IRG5twE/LwtENpvtn79veDUQUjOBp1cG/WdKtSLcM5uruqOTh+M2S
         2VhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768455961; x=1769060761;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aDAvyad0Gd6nn9PvkirLJfs5+fzAbzM3y3l25Mdn4/I=;
        b=vqFGCKzr/LmdnETfVT3D04tFovtrvm9dlZBK18ir95iwLM2US7jio6hFxpdLvL25Q0
         6WFVtTpeyHYHBugtEENT6IBuLj5n/JT7tqA/GuUqNZ51ro9rClp3pgKgMGyNxBhm3B5B
         8nIiXl8qtG2Sww7gPlhKnwbsTp0wUZj71o+5fIF/LBpcoRXu9wrEXiaE68TN3mH59Lri
         mzNLQSmH3u/1Tgyx10WMnO5qWSuSfPltT/yc0t52O75qGNFXPCkNFwXmkJiasrsW49LA
         qQUu2Sk94+jpL/SmqWkdvHwyU+ueSrqNXupZe33rSq0hVtJFvehLvdKJ/9UjlAlWv5HI
         s+Sw==
X-Forwarded-Encrypted: i=1; AJvYcCWK15k7boFz7k1YJj8RTrqSWSaDgnKhtYZKXNC6TwbAVvrJbEp2W7IUAo7pkmzigPHRzCaC6HWTbQ==@kvack.org
X-Gm-Message-State: AOJu0YxaB0MhiX/NgNefjMnqqKB2154zadKn6t6lznIq6Frfbe7Aeobr
	GUKcoeRU4CzxP6nO1VE3L5BrbgAAeVnuxmCv5apIbBREXA4smga6YV/QgntVhVRi57tmO7gzTkN
	M85BQgg==
X-Received: from dybb6.prod.google.com ([2002:a05:693c:6086:b0:2a2:4eb1:3771])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7301:688:b0:2ac:2480:f0ac
 with SMTP id 5a478bee46e88-2b48f5bac9emr4987449eec.23.1768455961332; Wed, 14
 Jan 2026 21:46:01 -0800 (PST)
Date: Wed, 14 Jan 2026 21:45:57 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260115054557.2127777-1-surenb@google.com>
Subject: [PATCH 1/1] Docs/mm/allocation-profiling: describe sysctrl
 limitations in debug mode
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, corbet@lwn.net, ranxiaokai627@163.com, 
	ran.xiaokai@zte.com.cn, surenb@google.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: C068840005
X-Stat-Signature: 685wphpuftheg6x6f3wdtsar43qdfcex
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768455962-836047
X-HE-Meta: U2FsdGVkX1+IBkk2TOiQiZ14SpYKv7B6FE0MIrpf5QMh4Ck2rDCzb3BZcciPMi+2BetWb/YfwYe8yA1Vv/wJBoShFCR29lewvzuEWSvf9jmmjfl8zpAJJhZoaTNdoMvmedN0ciINKWM+h535eI/GPIwaJnQJGSMqjN0BiUb8Cju35W4rBB7DVVcZ8UYnY6sJYRZ+PweeQFrAdfAOxeC7XBSCaGHPnbwqWwpL+RwsesmwroymCH2rI/ewjKDyOgVMPvXGcsQLUPh52SIko75OVfIojaackIvOCAyvjQ86rA0NO/6EDGY7lBwJYGyNQezidsfiANOu+SnzhjYPYb5J/6b2ff2Wvp/aTnYpFsCaTJSNofJqqHYwX28FJ6Mbr6/3M7ENJ1cPw6N/xG8xG3KO92mloaKKZU08F7pfOCoNzxpsykMejkUl+BZGmGDkhuslM/XNzAflP+i65+7Uah8pVevNH8/UUQtsWqtN4VRHylnFvXJ6YBhAuMGXV/KrPk2BGYaSqD6XPenPYVYr0hNDZbpTW8xmSrLQnlDi604hQM1Pq/jNvAiMxFLg6hqDx66E4/Doh14xEMwOgkmTVbso41a3hseOG4id0LFVffUOqsPfFyMYVsrUXg5ZoLVWAKlzQeUFFhpY+MemA2/a4DVb0ZiD3CVNnip4m++gndpgMOmNPEtkk5foELq+gDMAk1shKO8rWPuXPU48b4By7KjE4Xy2eyx2g1YXdch/lrR5IaMMeYR91nZYxm2nwIu+zZmqrxeS5yoLFSHMI08Od5FLNTFs2OpNxHjVeQQJM89DAuUWjknrMzzABNFHIiNNcpJP8uq9Mx989joMHNjmZYbWjUaUGQ7N34L/vqm+9GnilYc4k0df6z+kWL0jLkney9bFsVdO8GspiVxxZaaxwdQWDEqEjkXebnyMLDVauVWUJDJDb0ywQ4pE20bu5QERjzJwIdMtmtdkb1lt/xyz1co
 8OBJhg9u
 +O51ub0B7zwlHTv0Db8++LpYLTkFNUh0fqj/FPcmImYsBYI8NSKJPaeGSdqhMHNrraKp8x5OppQL7gqGBeDvm+J0fFMTAz4bGkft41YK6vY8itMe49cTuS5USyrmD8G+cR6ctdTXHXn6l91SbQJVpXChBDGDAVPOqeoRQAkct971A2aM9sNkq7i9icy71OBISYT1U8U+/DK4TZuzPwgB7yoIZiWub16EClDQIwRX6q4YlfNl2kEcWQTouWgSUg5hXY0ASD8kglnzPEvRKbGE7HWZ0TEVqVHtF5etgn9ZNHch90yPHEIwDfeqLPeFwLT4fCrYfPlSrdg53b87cUwKYoafw3cjCNOcWYe2/Yyt7EfWOTVXyR3KhVn6TK7tdfi8WxpftnHP4VH6+9/DPS82ISu8a7t3FFtXqxPu88aM5J0xVGrr9zWUpE4zeO3lu8NpxhptmwkmnYi6PNBR6qsORGABOIzLwIOwl1ej8+Z3O/tP1QOJjJqoyDMLo7u7e58+AMy+dm4B9tH8ItfFw05m1V+YHEdhRVSleQTJKAaOoZFQRVVOaYnZCY8ZYJIUpl0jc8jWzCFt79UQXTsDq4v/ee17FhtK3GxJRxaawdsZe3yNDyKroBi2Lpz0d5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_MEM_ALLOC_PROFILING_DEBUG=y, /proc/sys/vm/mem_profiling is
read-only to avoid debug warnings in a scenario when an allocation is
made while profiling is disabled (allocation does not get an allocation
tag), then profiling gets enabled and allocation gets freed (warning due
to the allocation missing allocation tag).

Fixes: ebdf9ad4ca98 ("memprofiling: documentation")
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: stable@vger.kernel.org
---
 Documentation/admin-guide/sysctl/vm.rst   |  4 ++++
 Documentation/mm/allocation-profiling.rst | 10 ++++++++++
 2 files changed, 14 insertions(+)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 9096e2d77c2a..8577ea91e226 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -487,6 +487,10 @@ memory allocations.
 
 The default value depends on CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT.
 
+When CONFIG_MEM_ALLOC_PROFILING_DEBUG=y, this control is read-only to avoid
+warnings produces by allocations made while profiling is disabled and freed
+when it's enabled.
+
 
 memory_failure_early_kill
 =========================
diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/mm/allocation-profiling.rst
index 316311240e6a..058d2faffb75 100644
--- a/Documentation/mm/allocation-profiling.rst
+++ b/Documentation/mm/allocation-profiling.rst
@@ -33,6 +33,16 @@ Boot parameter:
 sysctl:
   /proc/sys/vm/mem_profiling
 
+  1: Enable memory profiling.
+
+  0: Disable memory profiling.
+
+  The default value depends on CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT.
+
+  When CONFIG_MEM_ALLOC_PROFILING_DEBUG=y, this control is read-only to avoid
+  warnings produces by allocations made while profiling is disabled and freed
+  when it's enabled.
+
 Runtime info:
   /proc/allocinfo
 

base-commit: 560d6a4c4951ae76b5c6d5b5b8650276706f68ac
-- 
2.52.0.457.g6b5491de43-goog


