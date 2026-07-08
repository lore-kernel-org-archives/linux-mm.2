Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AF1DC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 07:33:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30F2F6B0093; Wed,  8 Jul 2026 03:33:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E5BC6B0095; Wed,  8 Jul 2026 03:33:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AE586B0096; Wed,  8 Jul 2026 03:33:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D926A6B0093
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:33:19 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5A8831206F8
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:33:19 +0000 (UTC)
X-FDA: 84964793718.05.171F24B
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8F447100006
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:33:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q2xrFnWW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783495997;
	b=GwbcKVMHUA8h/ZnfccPS5G1LWIZvPGPsxj4I17UCQ5KP4RexGXoHM62ijdRLqIqO+zCaVm
	QWcKBeo3jEwnYLqaMu2NweR4S1gd/YueZVJr8q/7YjgoKJDjkntedI2K8o9yFmqo+ovT5m
	rCGGXVED3xGq3C81iNH3+MmJ8Sr8TYo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q2xrFnWW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783495997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zz4SgHtAmy0qQncUtL+GMZmlzcvWPiSx3o95/DRT6g4=;
	b=VRxqa6WtkZ7rxJQGBQjnuqyz++YMLykW2v/JmToPkMMmUp9jomPVyMQlTpDf51jIy+8/nG
	usXNNzFhElsm6a6kkmXacb3Ypj3dkXeDhhrszVC5BmEUJ58Ekgt94XGOc5+ZNyqY/1lCKp
	9FumCfNueqZ7n2FuuSdaoclnHxHJIho=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-46cea75d96cso44240f8f.1
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 00:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783495996; x=1784100796; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zz4SgHtAmy0qQncUtL+GMZmlzcvWPiSx3o95/DRT6g4=;
        b=q2xrFnWWKtyi2fFwL0dWSryLRUSMnWjMmSZUUldvZ4OV2vN1l0g3JSPnUmSFhBYXrz
         Wp8qizJu0Xt0wzvAHokHVzkBAt7rcDvWzPCa9qa6C0WUR+l8TDYBKGX3IsRb8Jdy976K
         niXL2OOLRJJZLqej/cArjIj5v0F8vS0OZEXgyO+EHQuWKo4jHjSua4R9ZBy3LRJ537iS
         o2DAYhVE+4AwhPx4suYt/J6D0qYhpKPMo/wiUckNvxaZA5ux4Bmr2Dmsubm1aojuY6We
         NvaZ34WgV9lpcpPoJh346sO1cJ5KGjBlPHJRozc7nu6ghzsGYem6QkVp3nXiTXORGw8/
         +1Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783495996; x=1784100796;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zz4SgHtAmy0qQncUtL+GMZmlzcvWPiSx3o95/DRT6g4=;
        b=JnKzl/uQmmYgkyEvoLK8iHqg5etI/B/ZInpb7jNmc8raOfbFevqiTM9ex5Qbl92yk5
         idSwqcOUJJ03zbnRp1bWzGC6az/CJRM09Q8nrDbd2Oc6eHLhH4/K36ujLGmFwJ3Jy805
         BpBcUPlFGUW9v2+QQw0eBpdUvfOml68uUJ42VAcePYq0rkWneJkspZwA/wV+MMw4DX0A
         Om+ytOhNr39UGXk+ocePxQqNWjt9WPj07N5QyK7B54477cfhD+YmkbVin5jbWNtKaTsJ
         Ty46h+BZfK4EMNxVlwqXKU3NOUyKGw3rGuDWTSxK3E7VYbj68DKadVK8bGoVSknywY8l
         XApQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp68ewR/UkhujkE1nzpebBQvRcwmuJpF6/TNLHPyXMMWNI3eToJXqXP9OQDDy87Lgb3NYft+2rfXA==@kvack.org
X-Gm-Message-State: AOJu0Yw87iBst7Hpg28J3sxsTe0kPWGgOYkHJmqT0ZivbcAAy6JiTxkM
	sbbzf+J7R3S99UUStVxX41ep0hi92ARn6YzgAD+P7L8lTJir2dBqc48H
X-Gm-Gg: AfdE7cnJQ1VAwkEZBtj1FZD++y9ntVMFLre8iTZlgWVc8AKgDqJDiikQW8k6yhWBGgX
	1OmBo/CafaSJh23OZnajmM5764PGQKfqxND391KBmiI6i0rGEyvy9q8F1m1S3fFuDqFQw9HaFFV
	ThbTiztd1awALLc941zH3tlqNUioKA9Na29tvgGyZOtnWMYJIKAYvgoNXEDA5X9gePt9SUy03EJ
	upy+cjSxRXX4UKz1Dne7hqQCMvh6oUGhYybmxIIcISmzVUDTMk0/UHQh1dWKGfyUcKqgRgHnF0S
	rFrjyQbkBJp9G/44H3EHSGDJilxzPx+s/zWuO4IHlp2E0IlrdNl7cya3X4AYRGXI+gn0HLDLx0B
	wXHNA1dW8xoOARj418/7BSQAOjFsArcgv9dt9TKT1cJ2tSD1Xg+A7acvralJOnO0m6lfNkwjMNA
	ZTGna0gvxfSmNZwcINXXOr6mvnPaorMT4r4ek75E4FlQCc7IHUcW4eDps36WQwbjuBcth4Q9p8y
	QqvVuUsZ8ZNPLyr
X-Received: by 2002:a05:600c:3b03:b0:493:e4a0:8e1f with SMTP id 5b1f17b1804b1-493e68eed92mr6697125e9.7.1783495996005;
        Wed, 08 Jul 2026 00:33:16 -0700 (PDT)
Received: from doehyun-dev.pradel.rg.cispa.de (x06.xlate.fw.cispa.de. [195.37.157.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e610532fsm32876355e9.0.2026.07.08.00.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 00:33:15 -0700 (PDT)
From: Doehyun Baek <doehyunbaek@gmail.com>
To: Alex Shi <alexs@kernel.org>,
	Yanteng Si <si.yanteng@linux.dev>
Cc: Dongliang Mu <dzm91@hust.edu.cn>,
	SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Doehyun Baek <doehyunbaek@gmail.com>
Subject: [PATCH v6 2/7] docs/zh_CN: add DAMON_STAT usage translation
Date: Wed,  8 Jul 2026 07:32:41 +0000
Message-ID: <20260708073246.1652828-3-doehyunbaek@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260708073246.1652828-1-doehyunbaek@gmail.com>
References: <20260708073246.1652828-1-doehyunbaek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8F447100006
X-Rspam-User: 
X-Stat-Signature: gwjinig4ehh77pqw3h4389antb8grwph
X-Rspamd-Server: rspam03
X-HE-Tag: 1783495997-394901
X-HE-Meta: U2FsdGVkX1/5nYQBW02YtRvrxBezOQToG1tqLxLrzOnFdhtQfeqo1Nbi9xyVkrhr6hU57lcAt4IBQJtb8+hWXQZAWgCSUkZHjjpW3eTRyV8kCwmUi3TGa15fov6W50Y+33ycL/7McFodT0DSU7r7tJJtlJ7KaHAIeqNS+cIPUlBAIQeALnTw6KGG6Fuq3qONGwhqQGzFmqIxX3q2yfmXPccDIXdJKhtVKfDF4HAlr/2GYNG8Y8o56JlgIUvr4iOQNEIOcsjeCiRGHYJqFJGmhz+NZrOd2O65055AoJFxL3Z5P1is0hW/u10F1pvczd/Ur4PvcTIc/ww7O8oSYQYzVQvuOd9Y6d792c4QwXG6V1AwUb1VMdvADq42jMf43tHuk10TQiv2QELixlSI03nIPXUca8dt3cT1tNBdJCN6UvISomAz6BHDQGGhvqdaF1aD8BdCL8nQpn2PZx7DkePs5u7isd464pvqtbZgBpB89N5FmYmO73IU8CP2APOsewLZ0IMnRhrS7i/yKpPuTXaOG2zO8QIWJYjW6Mend+3hVGoQ0odEka7z8EppZwnrxR8VaZA5nXOB1fi9Fnpzic6SYsPzsKU6496g+acc/OWdaYq/x6hwqOqF9DTmlDGHL3WfnTeLb8qsAGo5g5FiQnAYIqDnHPdvgUYoAdgJO1aCrLOIauYGlFc8IxzLs4l7L4KrwrKuHxO3VoJSyr6bc/J1syM4OMiLbwVnb2UB+IE6aJmlmQr7Km47kyAjgG7Drir+qZ4mVFUppvtsz9XRdm5cm/elvCSFcis6oYpOvXD6CqYkDZmZIa37zZKEivv+mNo3+x1kunyPKSdQgud/1xmzX8A9ebmq6dZsm337OHlN+YL04LPWaid+uF7V9mTjFMCWhNCXZiY4St/x9CUPd9fxUyyZ9lxb0G7BRxAcDXYRi2USv4vCwvdHvH8xLStbb1rh6eUpH0nzPd6v9XZZxrR
 c1cAvYJy
 9zxcSNMUUeZHXJWR848Fr21KzL1+Zj46TsHVY0a0VylUyHKaoxYn+amJweksq+jl1gsPGVuaquoh+xW81XewMr5IA0tZwl5sEWItDM8OnquhZ+KaUwmuRYmctkhn/yQOFUetaXHNOfrvlutBEc5TF4DlR2qAW7Lhbz762KoTuSvnZLhUc+c6H/7H8CBA4SDRXhNGFuWqoG/jWX3r1k1lgDdhxeLjDJQfNClt55gvwRxnDDox9IJB9D6eyR7UHs8NgxUpZ+UMDD8p7DuLGHjNjbqzXxRVfMaalPYmGPbkMcje20NKYIlBVf1Z/ykwjCv10YW4ijiVOsg2P65x/9WV2p3NtffWRXSG9PCS/h25WVWmVrhIbcJfafYWFz0nwe33cL4jrecYg6a/j4zD60FE+iOsho2zdhY/B1ZjTmg3SFw0QuCgiSNndzSGX/3p7tPFXP0jN0j2IDkqO+4Lk5QEOM96OVQTU5+LNhfRJ1LxThp1uB2TBHnnsZI0Udw==
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


