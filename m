Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA9A3C5CFCF
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 06:59:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C4426B0092; Wed, 12 Aug 2026 02:59:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24E0A6B0093; Wed, 12 Aug 2026 02:59:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1647A6B0095; Wed, 12 Aug 2026 02:59:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CBC106B0092
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 02:59:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 42EC41A026E
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:59:31 +0000 (UTC)
X-FDA: 85091716542.07.9DF537A
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6AD3A80008
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:59:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Bx+1HUwq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786517969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zz4SgHtAmy0qQncUtL+GMZmlzcvWPiSx3o95/DRT6g4=;
	b=LN/JihfOKYePT9Xw4Ijmqh8PbfWBJbxe9OPtA3BS7uP3wXk8mwaDJqNDnJYqycUqr1kIhd
	hUJL1dvuEEiCsc9T6kt3RMf503yre1oYtTejGY9qTdb/6UqXbz5p6zbUIViyoMEnUFDIW8
	DTfWJPUg9psLONM4W2XP+4B/ufoytt8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Bx+1HUwq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786517969;
	b=BINWYycEEyCsekV39WZcrwwQfIAg1XnBAqZPREZPASzLNgq3J3FQAt5d2LzQAO8fgw6zao
	c0q9BObTIJT/2sV4mouxfQRgKUdU2zWkKbjk7BGjFnjIWCibdrnS8NKIXK0q4cMtia/L09
	YGI4qJ2X7mXaSbQHmiORs2Wy2USyFS8=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4995df974b3so249535e9.0
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 23:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786517968; x=1787122768; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zz4SgHtAmy0qQncUtL+GMZmlzcvWPiSx3o95/DRT6g4=;
        b=Bx+1HUwqimsIkLhXkZq3VHeNEtLFwaqugBS0RbpAELp3j6qdoVuIhXupxMidY0rOzK
         EYymLJSsaXVC/kd41zI4GSu6iKH3VGHvZ4YfgsH4oLMfAKiYp9pZNMacc/64gFweCnMo
         0bEkjUxoLZehRvhBUutf+e9d1aVE+Z5rHO6YlcIYjFaKMcqfKkxpAa2uNjABTdrmfIPZ
         SEixRu2dd8o5wB/0cfMzIJfRarSNYrEJA3df8Sbqkp9Gy9Hw9p/ghOHJwQYSvsvA5WyI
         zoOnC7gFy/RT/JKq/G2/bHO8c9kEu7HhG1gGQxxQRlEOsTumJuQ7eJsBpmCoDZNmt2lg
         Hijg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786517968; x=1787122768;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zz4SgHtAmy0qQncUtL+GMZmlzcvWPiSx3o95/DRT6g4=;
        b=D+aeVdijXAACoh1HKzdhEkVX5BM3JCQK/O+dJsJ0Rhhp3QHV1LUhwNPlBRpMUT1363
         wXut0oFtFRFo/PzypoNaRbPD8Hi1tlz1wzFyzwEYI6z+EfpJYDjUdqFGWZRTZDTK44WX
         zPA6x8KhwRLVnjhNhGaVHw+YLFi+4NrxJ9vbue4SAMFqaiYndHRZ08PhKxUFT79TZuw2
         uWbKwp0h122rPNSoYdLJWeIE1euRgLNFfmf0rwh6VXubfajtem/7yCD3GlaetD6TBuaH
         2Rr+09Yqg3Ees+12/RwQPxnFdxpaLO6g5oDAPYmGnX0BrA5qk3wu0BtGNaEtEcSRET3W
         Y7Kg==
X-Forwarded-Encrypted: i=1; AHgh+RoyQ1bBSAwS0w5OYcEsvCfDz5sLTobs2QfJmIa2pMb4IPOtR+/rbc9iwOiU2mKpYqoGycHlzV13eA==@kvack.org
X-Gm-Message-State: AOJu0YxE6AIRRXFLhBkJJNECdewNblJoAbc47CQ2cY+OBltuiMbEkc0J
	Y1/HEvDkn1CSO8YfeBP51i0mgZGMmlytyvDBXlRpfHF3kdB+o44weTzu
X-Gm-Gg: AR+sD1378Qx7DoZZx3wWFdyEfdm4KzbZVPNMkvwEKdFag1Aav/87n2T7UJ8TW2tvNEl
	BDgk2Feu8DYZwy9KatRkQ3qCc16H5nuUgP4A7SCwlplrHQ3maTFTXwO69r2sp7lTHDf4GteAX0o
	RKBmBKm746eyUjePMeA/nrA2gln/0/Ii5MtdEnDwg5Qiudi1tmg67EO/UYeKJKUeDgkZ0i9acdo
	sLceDt2ZCsGm6v9lSUUK4pcM72mqLjEAvsx/IfmpvsViz0YfQmGT+7AArTkNZFvKfPblZkys7qY
	G95dvfBI59O4Oz7lmr4tEcQ4Ww7EeuKYQ5YFgGO97JK7pOsT54eSUrv5fyc6qtJc+kqzBWv1gCM
	5v8ACygNiPjHGntllJTu5u1LDxPHK9bLxGr+V2haa00Th1Jir5mbtzVMh9QCVkXshLai7ZCeloX
	Kb/+izmUOhemoZqmsSawc0wpcEwj6+2YZfBDaIqoH5UKG+ahyVXxgehC8KnSd/Pbm6t4s2n+mFj
	j2GyOwBOQgKiZdigAPzteOAF58RodRRUTdjlD1FkuEMUl9C3RWkGWjUFT5qtPxUUBi3p0A2x+9Z
	HvxkyUA7B5LQysBQ+QQvd3IowQmq1h5sa6ptVZ63IcD/wQ==
X-Received: by 2002:a05:600c:1c25:b0:498:1371:660c with SMTP id 5b1f17b1804b1-4997bf8879dmr16236365e9.0.1786517967920;
        Tue, 11 Aug 2026 23:59:27 -0700 (PDT)
Received: from doehyun-dev.pradel.rg.cispa.de (x06.xlate.fw.cispa.de. [195.37.157.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4997b15b807sm73628005e9.7.2026.08.11.23.59.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 23:59:27 -0700 (PDT)
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
Subject: [PATCH v7 2/7] docs/zh_CN: add DAMON_STAT usage translation
Date: Wed, 12 Aug 2026 06:59:06 +0000
Message-ID: <20260812065914.3071433-3-doehyunbaek@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260812065914.3071433-1-doehyunbaek@gmail.com>
References: <20260812065914.3071433-1-doehyunbaek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 751aujad6srtmgq4541317qeqxx1tk5y
X-Rspamd-Queue-Id: 6AD3A80008
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786517969-376111
X-HE-Meta: U2FsdGVkX19fuUc2DyZ7lpHxbEScY4McG6ayDoNOFAwTM0tHXFtASHzysk23hG0CPeUgyjydR/IyBbq8USyZT3eR7HjHzwB6UlAK8sloCqxESmdX/nzJl53i+tZfCVjiW0UKt3B7QYI2BDnxKbBLAzcjjdkHELNDfn7L/hoSipvhNtflRfhuWJFWVvMRgtsoeuvpnH0IoeXp5ti3npd0RNcgbpDRV2A2HkXo5g+N4KCoaJ+NQkxUtqtlx4R+O24mX1CGgD8K2Elwm2HsW5yL8GcA5dT470dI4EqhChqHMgQtJXMt/llg3gCSDul31i9/ZMKS89BO2X0KX05ENXPCX1nH88hQwqcAhvQQb6msRed88dgGZfqYiN+A3eEvFn4bPwLipf24N1yh6RdMMKjR2/p//SVWm/k2msh+Trc568mMei49kdHyEpwGQxRat7Uc9u1It7/vxIN0OIMTYejOp7+Kq1DOPwd9wqOvI5vHb0Qssfd2Xt5GPUQgh6dN0UHgxt5CIHO6wZW6uUW9nOc9j/RC5/uvYvkR31QMfOEPQI+d9rprN9dOcf6ZIHUSp4cBFW4U8nuv+hm9VbJD4+lzlrZN9V0LMAJQhgW7WcE167IGYmNFjV9KgEA0U3ukZuy6S0JyuEyjSkhN42sTataORo3y4LWlKBA96onnbfL04aijaGymIRjcYb3W+0t40uoGslF2tK4hJstuEYiq1DGleZ9kfs4LTkacbdFr70xRBQC5Q5l5r2qGQ5aIkQLoDBdu2+KLkcbIdvsKIooYwVJ6/og/vsZf1g1AgsxhIM6f1vkqm7BpvuPORmvK4QTKEM6J86vAJvd8K72BA6BrDZSGJvFGINZd35oj1NRUkjs2ItctuMSqRdatjRJAZT6rZ02OGho8PvrkI23BTgxlaoQiUkiJGEcYjvhnuMams/aXUwneq9fEnl4gZ/c6xXt/ummaknqH4UtBYdQdjTOO0XM
 mzhfUqfN
 b+reB6bvvC3/rO6enWLxxBVhqiebMvlmHCMI+l1dLEIsUTzOIyarF2x8O55CYwldIPuNTVwKrBdJVQSUKrQ9cxMDsIMasCozr3hEfTSjFxmieajM1/+Et6RgOB9rUXujgEGTn21aPtUG0Xpauk8nvWX0R18ieh8HzyKL+D+YhalrCU3eT+M3m8Zo6/zaTmKOJgf1+XK9veLPVvlrlSIsWs2u3Z4j4v5o4fHMyhOsF1bppNXgE9T0n1PPVZGINbf+AivRHgkMNJ1qvkgAdEKkwl3RHqjks/ciID+7HACIFMTZN/UYnDZhb9HTdgg1p2RZVzFAt9QE8hHabJysLa8zwvFIUWWhDOlUgStVSUZVfqVkZ+gpSayk/xdifNpR13H/NVqn5FfcXe1TT5zC8IkVgapjM1Dq1EkDFVGsH6T1y2P0zJc7FE1HoUqa7Uiw+87yuGcfHSecfizU0JVcvRrGacedBfO+bSKZ1Nz8izZWbU6BmpJk=
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


