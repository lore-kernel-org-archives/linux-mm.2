Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDEBDC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 07:34:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3D7D6B009D; Wed,  8 Jul 2026 03:34:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A132E6B009F; Wed,  8 Jul 2026 03:34:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 902806B00A0; Wed,  8 Jul 2026 03:34:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5A7666B009D
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:34:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D340C1206C3
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:34:00 +0000 (UTC)
X-FDA: 84964795440.04.57B8572
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf26.hostedemail.com (Postfix) with ESMTP id 01CC4140007
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:33:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BxdxRU8k;
	spf=pass (imf26.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783496039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s31nZQVBL8BUGSoys1iksqFJSqf6kbi1kgLlk3gjtUc=;
	b=E7Wq/GuTgW91+KSE9TZbm6bwAfKnI7plppGgIiqJ/8zmcI1gwpZrFOoED0V+H5CsG5JuCl
	RPHDv20uAZN2C0CKpJA0iAnUoVplri7Oh882UBWSXT4GWRaA8eXecaifrVtjdODAHuXjVj
	68W4HXR8KAVGrnIDCgB3iMvL9GHu8iM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BxdxRU8k;
	spf=pass (imf26.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783496039;
	b=IPAGnncmNLqYaTFssW0iQLJk0qfeVPA2Y4KVXO0bT4rs9aSJJ3Zf15kAsKOBhgzYxPA1em
	ne7ulykOwSEGL0W90iHROQbTLrCqnwRLPjuQWoMWJsm/JEhm0gPnA1MW9RqNg9plNDMBZd
	xujZRjOfSvZgTgLqhIb4Yf+eejCKCOs=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-493c30f5347so381405e9.0
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 00:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783496038; x=1784100838; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=s31nZQVBL8BUGSoys1iksqFJSqf6kbi1kgLlk3gjtUc=;
        b=BxdxRU8koz+yl7KEI6wwtoHlAV1Vbr+cx36XAtdt0+7tTuQa5Xu+pU7O2EzvOoK67X
         PZkhEOW/AFXfW+iJ1c6XosKnQeheuMa4yET100H3uLhQavId/Ho+Ig9N30M0vm1OjNNf
         phFS5HG6Dn/50yl29sEjbOLloOD+0ELcRu1UrgWgIOL5fyNNQeKbOFo5KnXILDwJB/qH
         B26rk7kRLFG+rilGWDE6YT+D1zzXkvdkYJD0cmn7s3n/F4h+aTr+QCjmNMqmzxgBZkZW
         cIvrEaXyfVI+ifryhC8x3wajGosWpHuGinvh0aI8+DVhSyalr4UyP8Zak/NtjrN+Bea1
         kTNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783496038; x=1784100838;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s31nZQVBL8BUGSoys1iksqFJSqf6kbi1kgLlk3gjtUc=;
        b=KmDmpE9HDlK+Z8ffBfivSBf7sfsid+J48CCgZ1/eqqqOEZLCPZAeJvJEIHGC5Iu13t
         FOX77UujK/USl9jhaKrFkYyIxuDPlgihme2HFWtV+8HkQFDJFA1f4X3NUZEtxDhcZm7M
         uSCXTXvQXJ9iE+/MJBEvbfCVmBwb5q2ohDOMOta/K+Tu2esBtm6V9WJ2T1PMZmkoo+Wk
         EZH8YkrtY1P54eQlmYYgo5g84okUWhHIQKaoBXbr9NBd3UBywvpbfyaP/2pSXoSSDJIB
         RAKJG195wxMPpAO8n4NifpFrjZZhpaifPsmp21mcitXsevirqSGu+lfsl+4lvCMT2jxg
         TzRw==
X-Forwarded-Encrypted: i=1; AHgh+RqRCBGU2o0aSS4pXH3z+RDVb3Tgh62GAorVb/Q+/xYezbHptwOggSeXWKkBaws3zb9fOu+5LeXJaQ==@kvack.org
X-Gm-Message-State: AOJu0YzhFQWSRHsCDsrFdhoiTswAk4IoREjXYWKWT4MADgAtqaTjDsIQ
	CDTGTCv/NvHeVAJ6PPaAvvlnlAJLB7SyOfDkll7Sa4SotEZGTHUCIGgR
X-Gm-Gg: AfdE7ck61sLmGJ37O8ZNan6JUyNO7Vs0pIMdtbsnxeaHaeHRoC1qZBjQ4XBai/Z5/Wx
	5dkjX6HrJsixrEi2mxvafQyUA/sxB0xT8nBCcyrNrLtap48ABmPCI1pLYRK51kyG6xVxboL2hjJ
	dIQ4/1dHyu1nhbmUkKaVF0vYPBHByJ74vXlfSd8NdfmLsD2kAv7PSF/j5vxdfqMQn0suvHpqMxS
	k6hudT/X5ODYkGnjlkE4Dl1hTf+LA+WwIeqq4RLWsDly4gLTWwGJk9kzIeScpcwolZHAvYuiTzy
	I1gh+E3X3cTcakpNVvM45064Oi/IOvva+P/mDXSqmNQPV5ozxTsGurU3Q/gH4uxqoaXF0bW6Y73
	X2/u9ZEkt1OYfewjFUPvtxOa3UtRvvwv01gJn7Ux6FszHxIakqoHPrx3Ie2IcYOAYB8ASZe6Cpq
	QLdgDa0i/2BFglBF8UC3YMphCo37V8TxB/pIlNO5JQ6fQU/vmknyEkMy2B4oF0/CFTuTA5oBHGu
	ij3jYVQWvLygNWl
X-Received: by 2002:a05:600c:c172:b0:493:e4ca:8358 with SMTP id 5b1f17b1804b1-493e76a5647mr3439455e9.5.1783496037536;
        Wed, 08 Jul 2026 00:33:57 -0700 (PDT)
Received: from doehyun-dev.pradel.rg.cispa.de (x06.xlate.fw.cispa.de. [195.37.157.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e610532fsm32876355e9.0.2026.07.08.00.33.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 00:33:56 -0700 (PDT)
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
Subject: [PATCH v6 7/7] docs/zh_CN: update DAMON LRU sort translation
Date: Wed,  8 Jul 2026 07:32:46 +0000
Message-ID: <20260708073246.1652828-8-doehyunbaek@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260708073246.1652828-1-doehyunbaek@gmail.com>
References: <20260708073246.1652828-1-doehyunbaek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 01CC4140007
X-Stat-Signature: 7u35pgk8ucebo4gb74cauupcfabju1mf
X-HE-Tag: 1783496038-271012
X-HE-Meta: U2FsdGVkX18gMs4xRfrctIHYspbwxAyaAFPrRRohjz5nnpiPg9mDNdOb/Y6y92sDpfr8do5oKwmLZRNHQ+q8Y6vGjIT+IzJQEdQSh5WMxoMr46eCVyJMWTkM9koViKrx87VjbU5AmPd0Qqv6FKsrflHsPSXdylf6ULgcM4nHiuIzS+zwuxwokjjkWWbkfIcSqmunRpNwc9lxQNZPOIpgJk4uPxvOozJ4nJWr/K0YRqwHtF5CLF/78crRBzVVREtwamyZqiH8qlsTfZvJniDZ5PM3wo6S+SU/mWpXaN6GWUMTORWTYlgaba/aeTmGSMSzLeKW5RE5Oyk/b+aoU9ch+ZVWS++4bAhAahCP150YcIr6LyFyYa44Znj/FwLZcSvUGeTdiMhmA1Q0StC0dmQUKwLegFzCwqsMUkPQnZgEvHAL2CABf18cXN6v5ZoE/uiGxLEj/ks/5NuO1vYyFXi1JWRBEHQjKdNKgJ/oVlpBGAUKEOAi3raQ1QvU+TxclxIkIGjh86c8NcmUVt5OW7FWd7jFXk7dgazzLoclDh9ouQ2TOG7gmCJZk1YzEtbfl4mFJWIovWTy+mg9UHPgdzTsNvCHuGSNr69TCo3MCY6kq4AUkZ6CzhhqWeGFgNiYZ0oChECc6ShCzzOazNcky9SNTUhANz+8mbTot3HEP8cH09kn9BmJJIkDplm/CmpOK6ukJTGkamOrT1EVjln68jbY7gX2vZ+89SxXzOREZ1Fpwmhlxc3HC53zKzFzrnp4gNXRSRlVYTRy05/duyYX/jZkc/tFbbTA0H2oFYiBH9rUvAU8/UcbqAgvTJnznpnNL/Hjw0ZAM1nwItBmf2coqguKCLHsw4t5qpgXmaesGBqO6Y+tx9JBI/+1gDLI3Eu8AvIL5woRo0F2vprX8TY4BozuowFUp3rYoX+bj0u3fjzQvUA8Gw6EFwl0r+acNBGl8Ghi41F+B1mqjoGr6+EprUZ
 KoYnCwua
 TJ9/k+IiQvh5IMZJYcUut/oxGMOWhYE6zXFld3V6gQkBDIa1t/O8fNoJWyH5kLmNDK+BP3CDul9HdLMFa3HzeK3xJE+CxGiSF0jsIsjbc7p6NSFxS1uaxwEs6jy7qFTgGJW8wtDzmwyM9UcM9H6xG+R+tOh0vViUtWUfyRBKLHYQ7NONWz14xFPQ+wBoL3X3RRbiWRIo4+4Mxzk7202/xU6rlCIceSmJWEO70MJRIPSoLurSvyCCGzBIzKP/0JNeLQn1CcaqHrolV70n2grn9FoPo6FqizVUahsGOrmseLb2zralXrD4LirFQ0sAtJGMaGzPoTO3glmFHKXLDbxBDtFC0P4vaSJ2Ll/db561JGDN8MmTXawa+NwJuSZkSjQehQWZaXLHfFlna+Jgr7i02IXk7FvY3DY5WgSV9BX3W6fwRN+Or+4Wj7hHKaRIqLbYRf7/wcPK0EvkR0QqDearF5U2d+MEIYVAQ+BqpQvhXo3pV0oSIcE/XArKktyTEa/DImUAUYnoIAxlbZ1Gh9jNkJnhJQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the Chinese translation of .../admin-guide/mm/damon/lru_sort.rst.

Update the translation through commit c9380cdd949d
("Docs/{admin-guide,mm}/damon: fix DAMON documentation details").

Signed-off-by: Doehyun Baek <doehyunbaek@gmail.com>
---
 .../zh_CN/admin-guide/mm/damon/lru_sort.rst   | 68 +++++++++++++++++--
 1 file changed, 64 insertions(+), 4 deletions(-)

diff --git a/Documentation/translations/zh_CN/admin-guide/mm/damon/lru_sort.rst b/Documentation/translations/zh_CN/admin-guide/mm/damon/lru_sort.rst
index 03d33c710604..6af0dd59ef5d 100644
--- a/Documentation/translations/zh_CN/admin-guide/mm/damon/lru_sort.rst
+++ b/Documentation/translations/zh_CN/admin-guide/mm/damon/lru_sort.rst
@@ -48,7 +48,7 @@ DAMON_LRU_SORT使用DAMON寻找热页（范围内的页面访问频率高于用
 
 为了让系统管理员打开或者关闭并且调节指定的系统，DAMON_LRU_SORT设计了模块参数。
 这意味着，你可以添加 ``damon_lru_sort.<parameter>=<value>`` 到内核的启动命令行
-参数，或者在 ``/sys/modules/damon_lru_sort/parameters/<parameter>`` 写入正确的
+参数，或者在 ``/sys/module/damon_lru_sort/parameters/<parameter>`` 写入正确的
 值。
 
 下边是每个参数的描述
@@ -71,6 +71,41 @@ commit_inputs
 ，DAMON_LRU_SORT会再次读取除了 ``enabled`` 之外的参数。读取完成后，这个参数会被
 设置为 ``N`` 。如果在读取时发现有无效参数，DAMON_LRU_SORT会被关闭。
 
+一旦向该参数写入 ``Y``，用户在再次读取 ``commit_inputs`` 返回 ``N`` 之前，
+不得写入任何参数。如果用户违反该规则，内核可能表现出未定义行为。
+
+active_mem_bp
+-------------
+
+期望的活跃内存与[非]活跃内存比率，单位为 bp（1/10,000）。
+
+在保持其他配额设置的上限的同时，DAMON_LRU_SORT 会自动增减配额的有效水平，
+目标是让热/冷内存的 LRU [降低]优先级处理产生该活跃内存与[非]活跃内存比率。
+值为零表示禁用该自动调优功能。
+
+默认禁用。
+
+autotune_monitoring_intervals
+-----------------------------
+
+如果该参数设置为 ``Y``，DAMON_LRU_SORT 会自动调优 DAMON 的采样和聚集间隔。
+自动调优的目标是在每个 DAMON 快照中捕获有意义数量的访问事件，同时将采样
+间隔限制在最小 5 毫秒、最大 10 秒。将其设置为 ``N`` 会禁用自动调优。
+
+默认禁用。
+
+filter_young_pages
+------------------
+
+相应地为 LRU [降低]优先级处理过滤[非]年轻页。
+
+如果设置该参数，则在每次 LRU [降低]优先级处理操作前再次检查页级访问
+（年轻性）。如果该页自上次检查以来未被访问（不年轻），则跳过 LRU 提高
+优先级操作。如果该页自上次检查以来已被访问（年轻），则跳过 LRU 降低优先级
+操作。当该参数分别设置为 ``Y`` 或 ``N`` 时，会启用或禁用该功能。
+
+默认禁用。
+
 hot_thres_access_freq
 ---------------------
 
@@ -163,6 +198,8 @@ min_nr_regions
 对冷内存区域监测的最小数量。这个值可以作为监测质量的下限。不过，这个值设置的过
 大会增加开销。更多细节请参考DAMON文档 (:doc:`usage`) 。默认值为10。
 
+请注意，该值必须为 3 或更高。该下限的理由请参考设计文档的 :ref:`监测 <damon_design_monitoring_zh_CN>` 章节。
+
 max_nr_regions
 --------------
 
@@ -176,14 +213,34 @@ monitor_region_start
 
 目标内存区域的起始物理地址。
 
-DAMON_LRU_SORT要处理的目标内存区域的起始物理地址。默认，使用系统最大内存。
+DAMON_LRU_SORT要处理的目标内存区域的起始物理地址。默认，使用系统的整个物理内存。
 
 monitor_region_end
 ------------------
 
 目标内存区域的结束物理地址。
 
-DAMON_LRU_SORT要处理的目标内存区域的结束物理地址。默认，使用系统最大内存。
+DAMON_LRU_SORT要处理的目标内存区域的结束物理地址。默认，使用系统的整个物理内存。
+
+addr_unit
+---------
+
+内存地址和字节数的缩放因子。
+
+该参数用于设置和获取 DAMON_RECLAIM 的 DAMON 实例的 :ref:`地址单位 <damon_design_addr_unit_zh_CN>` 参数。
+
+``monitor_region_start`` 和 ``monitor_region_end`` 应以该单位提供。例如，
+假设 ``addr_unit``、``monitor_region_start`` 和 ``monitor_region_end``
+分别设置为 ``1024``、``0`` 和 ``10``。那么 DAMON_LRU_SORT 将处理从地址零
+开始、长度为 10 KiB 的物理地址范围（以字节表示为
+``[0 * 1024, 10 * 1024)``）。
+
+带有 ``bytes_`` 前缀的统计参数也使用该单位。例如，假设 ``addr_unit``、
+``bytes_lru_sort_tried_hot_regions`` 和 ``bytes_lru_sorted_hot_regions`` 的值
+分别为 ``1024``、``42`` 和 ``32``。那么这表示 DAMON_LRU_SORT 尝试对
+42 KiB 热内存进行 LRU 排序，并总共成功对其中 32 KiB 内存进行了 LRU 排序。
+
+如果不确定，只使用默认值（``1``）并忘记这个参数即可。
 
 kdamond_pid
 -----------
@@ -252,7 +309,7 @@ LRU的优先级的提升，同时降低那些超过120秒无人访问的内存
 进展且空闲内存低于20%，再次让DAMON_LRU_SORT停止工作，以此回退到以LRU链表为基础
 以页面为单位的内存回收上。 ::
 
-    # cd /sys/modules/damon_lru_sort/parameters
+    # cd /sys/module/damon_lru_sort/parameters
     # echo 500 > hot_thres_access_freq
     # echo 120000000 > cold_min_age
     # echo 10 > quota_ms
@@ -261,3 +318,6 @@ LRU的优先级的提升，同时降低那些超过120秒无人访问的内存
     # echo 400 > wmarks_mid
     # echo 200 > wmarks_low
     # echo Y > enabled
+
+请注意，该模块（damon_lru_sort）不能与其他基于 DAMON 的专用模块同时运行。
+更多细节请参考 :ref:`DAMON 设计文档的专用模块互斥性 <damon_design_special_purpose_modules_exclusivity_zh_CN>`。
-- 
2.43.0


