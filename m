Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D358C5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 07:05:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 461896B08CF; Tue, 18 Aug 2026 03:05:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 438E56B08D2; Tue, 18 Aug 2026 03:05:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34EC86B08D4; Tue, 18 Aug 2026 03:05:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EE8A26B08CF
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:05:10 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7B0AB40AF3
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:05:10 +0000 (UTC)
X-FDA: 85113503580.02.06FA0CF
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf12.hostedemail.com (Postfix) with ESMTP id A077340004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:05:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="nS/VtIjN";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787036708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zz4SgHtAmy0qQncUtL+GMZmlzcvWPiSx3o95/DRT6g4=;
	b=W5hbgFasgZKqYLMlllz5Gn9euBJVEAL9OLhvhFHnPY2kynKAuTzK0xxNSjm1whBAMoYY3I
	SBnER6ME47nSF58UO50A0MUjQ/mSYIqyPKeVDtvMR6GYwRH5LjxXIn5fjxDquiu+9JWb7M
	9V1Ri+qnjhXcoiB9CyomgvtNTRuUVlU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="nS/VtIjN";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787036708;
	b=1/n7PgH2emsDTVczPmmeL4d0RaNt/CgVoac314bTLE0o+lx5xH1y/yk+to1bGYiWhltQXc
	/5GmWcc8fxYChTyr3FwE1b/CfK97mtcWIt7ekF5gNc3fhedhszltBK8VbQx+5YraekltMU
	QVscmrJFZpV4+nWI5xemKqIQmd63qfQ=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4954b3c5cbeso5118695e9.1
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787036707; x=1787641507; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zz4SgHtAmy0qQncUtL+GMZmlzcvWPiSx3o95/DRT6g4=;
        b=nS/VtIjNd1Tvr/fY0OAx4T70bOPG5pJY5b8FeiDIfTvmKdNylytvZKSLaaqRanKMTc
         Yra1M4kh0kA8X1sutzl2f/EwDridx2To+R/Zz7xHOAoFHMWkuI06rRggGoPQcVcj/wyp
         at69zHpy4XMRfdnOqQDSzv0UYtsUQMs0y1lXMzle/tRVqv5AOOs32bEdZS5m1+3mYQ7B
         ZSUqtXiVdzHZXMOoVYaaVagaWYgZlyv7/u0fGlWe2GqPBEdwaQxasYU2QH0xuWLRYVOX
         PNAqMXYbHgyUWxEZqJPcKyNhcHrVrCnkPCIEXcmZKY5zwL9goWyJEnETjk8/pxh8vG1W
         yJ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787036707; x=1787641507;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zz4SgHtAmy0qQncUtL+GMZmlzcvWPiSx3o95/DRT6g4=;
        b=o+3KKApbw2bpdaQv/x74QGRJias2l0MmajRR550gP8j7JSmi+Udhk/aW6Jd5/NLnfP
         8S0czG3dG9pYaAj0+UicYuejDLerG5Jnxbec3EUf57LTcVAI0vBze+EZ5jcu5xT3HeTG
         Sk8e41617biaSzOn3xRpdJawgwNYbclb6BdRP7XVTPwM3nT5UmMr0AqeJHU4O2bNJPKm
         SeZnZKz8vnzthX/WAnhs5Yd047buf2/0CyGms+QyAMW6Jhl45/fVyMEXZXykAwpEBxCx
         OsNO1JzZOdygHeYACCzx2pigUjTnx6KZKXjAVboazECJh+qITfqwFEjBlI9KUPKMjomg
         du0g==
X-Forwarded-Encrypted: i=1; AHgh+Ro12OE5P7jCPORj3YZDxjuM9Upz822mnDNoy38F0ycRwA58BZRUyzXc+iJdlDLzoF+ogNgNh0C1Ew==@kvack.org
X-Gm-Message-State: AOJu0YwCUSCZm//gNiQxFTAgJiBxbr2wZ2ouFJZwzWUctRpV9zcYRV6Q
	g7S0t88vRNKS4DKEqBSZQdjC0nmBMk6GELD8irmQi3okniUzDqh4beAI
X-Gm-Gg: AR+sD10OydOWf4tnidrIItgdLOmj2ZvkTC0WQgFNdL9MHfRb1kIo6WoIecwOskTd5FL
	fjhK7WxYQP4W1j5vxDpzYZI6fD4HLReAReumVpC7k8pi7SH52cKnpze63gnluudG2PxXbSSc3pI
	JlqLgKKKrK8yy0klJaJ8PvDqY326GS0Y7j2jypRQMg9V0syY7RBN89k2VQTuxOu8iC0o4m0ntA6
	gB8eg7HAzb68qKfscFy4DnJOQMd8dW0lupBzmA7VkPw7yTA/cWlZtfWhxmDr+mieZHuHg4+7b1a
	7PSQl/WJyHQpgFgPoq+gNxQWJ22FVsJp2e3UodOF+qUHQjGhEnbzMjonkWG3GU4EjOzHInq5qmd
	hnvbkCNYjH4iQk0XSMGk5DUEj9oLeEGhn55/O2KwGk3K0NJTbf3NM4QjkkuGJcZnwyHC3I92xwE
	Y/q+gilsfQIoDI9DECp0mmjaAhJUIgEHr71wfhdoPlMp21lcePE4G+j4DjU2t451bGSAdcIIHzc
	Nwf09qUUvDC24SCzgTAZFFgiCsPJtHHFWTKzt9QuqUQwPKkuB5NbJgaZs60cIRaII+1F+Fp8Uy7
	oKHIfOyVogqjffuL7Z4QV9VKcdlTDA8Iws6kqrPGOWvOjg==
X-Received: by 2002:a05:600c:3b1f:b0:490:ec79:3046 with SMTP id 5b1f17b1804b1-499878d463cmr231824665e9.0.1787036707142;
        Tue, 18 Aug 2026 00:05:07 -0700 (PDT)
Received: from doehyun-dev.pradel.rg.cispa.de (x06.xlate.fw.cispa.de. [195.37.157.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49996188217sm495557495e9.13.2026.08.18.00.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 00:05:06 -0700 (PDT)
From: Doehyun Baek <doehyunbaek@gmail.com>
To: Alex Shi <alexs@kernel.org>,
	Yanteng Si <si.yanteng@linux.dev>
Cc: Doehyun Baek <doehyunbaek@gmail.com>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v8 2/7] docs/zh_CN: add DAMON_STAT usage translation
Date: Tue, 18 Aug 2026 07:03:44 +0000
Message-ID: <20260818070358.455768-3-doehyunbaek@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260818070358.455768-1-doehyunbaek@gmail.com>
References: <20260818070358.455768-1-doehyunbaek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: pbxbiwszbejk33msk45i7s7auee1m38g
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A077340004
X-HE-Tag: 1787036708-789001
X-HE-Meta: U2FsdGVkX18dwsPpn7Hr1uLPBRfn4P0ZY72iX2fDx3nVxmtuFanff1fBhG3LkSJmwjknO5G5xJOUgS6hlVP6NyVPSBdx9eu2CNLHFhCYoRXL7pEJyohmorfLXFHdkFzz+v1Efoshr68znQc9phCzYwB6IxgGkelV+9lsOWaU3gQyn2HOhnKdbV2s18162f9+u47z9GG4imS2mrMgNjkrN9hMvoHSQmyjmND4ziiG1fGdExl6wBjE3MQftPt5bh6rKHk/yAYm36zNUWf7EL96T0V93rDCc1yP2yXAQ1FwNiuWQQC0lv43PFvIKyMShUWuBCVQXIxg6FTR+1HTpA5GgSU9rd93zO5BJojW3762p87HwFJlTpPB5tZYEdZ9cySbBBuMK12bdy68YNhzlDgwtM2bO1HCh7mVTnJHrbYj/9m2awDMticnkt45F6Ho3dmBNeKgdKQu/YNPZZsSLDAaO/LK2rtkWiUO8tlZ0ZDEl8Q92f5m+U2/TaLrjBZZrDMQ3ya/BdOp2uqGmJhLv/0axlZtPkkpw+lbT+Jhv8ybnBQAh3G8FDxDiHuIm0U1rPxS3Xq8He/9ttYif4gM80ez3VwpHOoOzVHvE9sYFLTbx62VwN4ySgFAnuphcsqVO4omCM4hbIQ1ZybItO9ihXreJg896m6iGRJ61S0iurOG8er54p/TKxNA/VVOJ0JJ2deygIXsEbJ/N8MCwi59NgKQWFQj2Eg/zotwlUtgn6xaACQFhWUm4RZCx1pxO45ZXIQc4QsNzcVxECmCyH+YHeiELWk7ZsxrEUW6Jwu0FrxR+Ptxf3shLVBNXx0Ep7/aYnspftxcUMDOX0IrsGAuQnxrVEo3hIUiiebxknjz39Fy0Gpoo/j220BxtwWyL2rq+uz3m+XjpWXafCoQxRP3NH4+jR9HWA9SkfX6+UmOS9ch2vhtn1wuiaGdZm4a/IihuwhQyCVp7z3hS8JnNIITPbi
 M83Tttsp
 ynQ8ljAxhfpJbNYzp6esJKG6UwLITdFqJSz2QM7GuJR6+SCSIHy7gooLh4n5dVczStjDSUR6JsIumegk5AigSFhVxBhD3jXGyT+hbg7It7YUayiYOAIq5LAI5x/asRXzUL5L3TwP3TBrWryqG7gDztTGEkPee9apRAW3F3rmEMrc2j6B7rP+1xpAZqE5bBLrtMTuFLOt9Mnjssx2RgW2H8fVO8XFesBU2Igl2OOpBLeGcagmhWmH/PpbO4mtvwv7pKnPI5iEYE75P+2j+9KX7xzuwfWA/mvwvsXaOEsCHRa/0/HyO/SKbgjYKtmcrNKEkHNZynWojVUqGFYqajtbzq2exwbni86JllIEuQoyQb3JBC+BaJeTgTCY22AkauvumKKHzqYeNpMZ2tADqwLQ3SAzI5XkVTPAl9woKdAdq1vO05EH6GvXiKh+ya3seeSdNDXZI5jqEttDsFuuTMmTapRPk9YRbdn9TVX0kXH/8YTBZHiDbf/wOAzcjPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Translate .../admin-guide/mm/damon/stat.rst into Chinese.

Update the translation through commit c9380cdd949d
("Docs/{admin-guide,mm}/damon: fix DAMON documentation details").

Signed-off-by: Doehyun Baek <doehyunbaek@gmail.com>
---
 .../zh_CN/admin-guide/mm/damon/stat.rst       | 94 +++++++++++++++++++
 1 file changed, 94 insertions(+)
 create mode 100644 Documentation/translations/zh_CN/admin-guide/mm/damon/stat.rst

diff --git a/Documentation/translations/zh_CN/admin-guide/mm/damon/stat.rst b/Documentation/translations/zh_CN/admin-guide/mm/damon/stat.rst
new file mode 100644
index 000000000000..129748a5ea1f
--- /dev/null
+++ b/Documentation/translations/zh_CN/admin-guide/mm/damon/stat.rst
@@ -0,0 +1,94 @@
+.. SPDX-License-Identifier: GPL-2.0
+.. include:: ../../../disclaimer-zh_CN.rst
+
+:Original: Documentation/admin-guide/mm/damon/stat.rst
+
+:翻译:
+
+ Doehyun Baek <doehyunbaek@gmail.com>
+
+====================
+数据访问监测结果统计
+====================
+
+数据访问监测结果统计（DAMON_STAT）是一个静态内核模块，旨在用于简单的
+访问模式监测。它使用 DAMON 监测系统整个物理内存上的访问，并提供简化的
+访问监测结果统计，即空闲时间百分位数和估计的内存带宽。
+
+.. _damon_stat_monitoring_accuracy_overhead_zh_CN:
+
+监测精度和开销
+==============
+
+DAMON_STAT 使用监测间隔
+:ref:`自动调优 <damon_design_monitoring_intervals_autotuning_zh_CN>` 来提高
+精度并最小化开销。它会自动调优间隔，目标是在每个快照中捕获 4 % 的
+可观测访问事件，同时将得到的采样间隔限制在最小 5 毫秒、最大 10 秒。
+在少数生产服务器系统上，它的结果是只消耗 0.x % 的单个 CPU 时间，同时
+捕获质量合理的访问模式。调优得到的间隔可以通过
+``aggr_interval_us`` :ref:`参数 <damon_stat_aggr_interval_us_zh_CN>` 获取。
+
+接口：模块参数
+==============
+
+要使用这个功能，首先应确保你的系统运行在构建时启用了
+``CONFIG_DAMON_STAT=y`` 的内核上。通过将
+``CONFIG_DAMON_STAT_ENABLED_DEFAULT`` 设置为 true，可以在构建时默认
+启用该功能。
+
+为了让系统管理员在启动时和/或运行时启用或禁用它，并读取监测结果，
+DAMON_STAT 提供了模块参数。下面的章节描述这些参数。
+
+enabled
+-------
+
+启用或禁用 DAMON_STAT。
+
+你可以将该参数的值设置为 ``Y`` 来启用 DAMON_STAT。设置为 ``N`` 会
+禁用 DAMON_STAT。默认值由 ``CONFIG_DAMON_STAT_ENABLED_DEFAULT`` 构建
+配置选项设置。
+
+请注意，该模块（damon_stat）不能与其他基于 DAMON 的专用模块同时运行。
+更多细节请参考 :ref:`DAMON 设计文档的专用模块互斥性 <damon_design_special_purpose_modules_exclusivity_zh_CN>`。
+
+.. _damon_stat_aggr_interval_us_zh_CN:
+
+aggr_interval_us
+----------------
+
+自动调优后的聚集时间间隔，单位是微秒。
+
+用户可以读取 DAMON_STAT 使用的 DAMON 实例的聚集间隔。它会被
+:ref:`自动调优 <damon_stat_monitoring_accuracy_overhead_zh_CN>`，因此该值
+会动态变化。
+
+estimated_memory_bandwidth
+--------------------------
+
+系统的估计内存带宽消耗（字节/秒）。
+
+DAMON_STAT 读取当前 DAMON 结果快照上的观测访问事件，并将其转换为以
+字节/秒为单位的内存带宽消耗估计。得到的指标通过这个只读参数向用户
+公开。由于 DAMON 使用采样，所以这只是访问强度的估计，而不是精确的
+内存带宽。
+
+memory_idle_ms_percentiles
+--------------------------
+
+系统的逐字节空闲时间（毫秒）百分位数。
+
+DAMON_STAT 基于当前 DAMON 结果快照，计算内存中每个字节到现在为止未被
+访问的时间（空闲时间）。对于访问频率（nr_accesses）大于零的区域，当前
+访问频率水平保持的时间乘以 ``-1``，就是该区域每个字节的空闲时间。如果
+某个区域的访问频率（nr_accesses）为零，则该区域保持零访问频率的时间
+（age）就是该区域每个字节的空闲时间。然后，DAMON_STAT 通过这个只读参数
+公开空闲时间值的百分位数。读取该参数会返回 101 个以毫秒为单位、用逗号
+分隔的空闲时间值。每个值分别表示第 0、第 1、第 2、第 3、……、第 99 和
+第 100 百分位的空闲时间。
+
+kdamond_pid
+-----------
+
+DAMON 线程的 PID。
+
+如果 DAMON_STAT 已启用，这将成为工作线程的 PID。否则为 -1。
-- 
2.43.0


