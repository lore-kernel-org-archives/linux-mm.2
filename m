Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E232C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 07:00:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 583986B009D; Wed, 12 Aug 2026 02:59:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55AE66B009E; Wed, 12 Aug 2026 02:59:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 449F66B009F; Wed, 12 Aug 2026 02:59:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 161E56B009D
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 02:59:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8A964802F9
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:59:39 +0000 (UTC)
X-FDA: 85091716878.19.B10383D
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf20.hostedemail.com (Postfix) with ESMTP id B519E1C0008
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:59:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=L5JuFnUg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786517977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s31nZQVBL8BUGSoys1iksqFJSqf6kbi1kgLlk3gjtUc=;
	b=KfQyGaZE1SD6qIR8+Ir98rkIF5tQZJp07CdU1zNchlHe5rGktloSHybhN98UeajuTTVbjl
	2kJu5WscTKSj0TIoZosEQFiogIdQVcMfprdGdXPeH87DifMvcmrSxqh+OaKmd9Bbgftt3w
	2PKhXXLOU+033Pl7zqH7QLv2f+Za7jw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=L5JuFnUg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786517977;
	b=oxIKAZ/jMVfq9QMun8pdZ6HKh3BKGAZrPWruLrmsc+4ee4vrDwCoO51/tmvduu4wtuh9Nu
	XJRh8ufJ5b4/byWCivzv/OutrI8g+seT0koFh/2pAMcQkvzopSjjKCubcBR1+UkBZp0TjO
	9HM23yjUn0zYzNuaP+UendIXR/GxIIA=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4954c08a7c8so426685e9.3
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 23:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786517976; x=1787122776; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=s31nZQVBL8BUGSoys1iksqFJSqf6kbi1kgLlk3gjtUc=;
        b=L5JuFnUg0JEMKYDJfsKfbj9c7iGxHdqu46uxKp1D5rN1SGSFFxqEpz4M5xoEYJBMxL
         BTtoAW3AnW8GFkrRZHtSLoXUu3kaFx0jpIkuFLqjHAdlks8Uj+v/6/+VGqvwDyyuRjXH
         r2433B26UVsJWGqcmrRrVlj+ZFwUTrFaQBkVNltOjQmfzy13Rb6xSpmWjEF3MXbTkRx5
         S8HzjxrOezSVWepy+BuGUL6NujxYLYivr3lmMc6XRDU2LWUGyTWH6r11S1cCprWWfw3x
         O7C/OzyGyOfSu+bgH8DYmip0hcQ6txcsWPctoM9g3Awq1YvbBQhpyhxJUWgxVlGDACKo
         XXIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786517976; x=1787122776;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s31nZQVBL8BUGSoys1iksqFJSqf6kbi1kgLlk3gjtUc=;
        b=krWpIG+eG7MPQsV8lRdDpPVXC8yYV7P6nJqxlfgesIb+e2jRCC2d+Vp7P0kb9wAYYD
         LotsRTfJ+ltpQF+axRJObwNiw2Fcz5To8VZWgpm9UOfMHK6ZFXjHb2qKbKg3lvoxPDS5
         Nqf+TBWuDncCt1YIvP8gKFa7wr2bF4EyOZXcSmm1+BBlK1XZbETLcntjBhcpFJlqsR7S
         xkvi8UMyxgv0Iy3ctVWygN75qI4v66Gp9iHGPl2rHZt3u0BUKbYIHM2J4UnEfJQgyhZU
         84NzyzuKg0IWzT7i+tUl3bUYr1exVOCiiWzs2GqIsOkBTBMvS2Z4qcAzACn5FbY43a2F
         Iz2A==
X-Forwarded-Encrypted: i=1; AHgh+RqA2rtcjsZdNdUCfrndwnDMx7Zovm3YdsjCqpzjC9EBfRm4gUdGt6ldwkdbJF7pwYha96lj424/UA==@kvack.org
X-Gm-Message-State: AOJu0YzGJL2x05EHS10Dq3Si5YaUysyUARN88XYzNQN5uQVAwiw+HCm5
	9EqrSAK1Zqt+NJuiHPv5SwXRPyRvkpTgPFgXDM9SrBSW3Ce0KAqkMQ5I
X-Gm-Gg: AR+sD13Op3MRH1QTCpcKEPoi7ypIJ4peu07STo2w749PLcgv0T6rw9zNASMNx1V105D
	AhjztRb/ZEiV0cQcZTw7lpPIW5Ak+Y14VMu2+v7YifVpcm3lqSKHhksExyD1YYxWOD5J0E566y6
	K+Pc2bbmLS8Rx6LlOl564zYo9Fjj5FLTyHQYZnaSxFrM3YINWU0jnpsiQeLeXijlT+nparg71WP
	KxjCXaL0rGDxoTxO28xwwp72VOInhgBZDnv7E0PLN5qQIqMrppGRcuKP/Qw4aTcS9CozLf1s+QU
	7uVtfiQpMlAEcKvk+BdmBnetQFunSJHxIl7rqWsR7ils1nBBtuOROy+VGF/ksBrdlWL7r2asxrY
	ejX66jxqQyoVwFNKcypb/mNzQJR7cvwGaldQoCRZf8cFsjkZHwyWZnQQEaSqs+1X4o9xAT5gBGE
	Ennw9YW3lkAdeer15z935ZK7cAhNh9n3Gax/dYHhhEgtK5WCN8WALUSedvDPyqWQohGXNmSDdt8
	qXwCKPzmYoOZWBTy5mzkvTQMeJ2Q42l8Ts95+Vx0RxBnZJqKiaWte8P0GJGfCQxX6cg0Aom90Zn
	0TzjfsKvX4F4HepuwuwSbpRowl6m+siZLqKF2ywJMuneVQ==
X-Received: by 2002:a05:600c:c8d:b0:495:7561:a9cc with SMTP id 5b1f17b1804b1-4997c16802amr16814285e9.4.1786517976305;
        Tue, 11 Aug 2026 23:59:36 -0700 (PDT)
Received: from doehyun-dev.pradel.rg.cispa.de (x06.xlate.fw.cispa.de. [195.37.157.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4997b15b807sm73628005e9.7.2026.08.11.23.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 23:59:35 -0700 (PDT)
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
Subject: [PATCH v7 7/7] docs/zh_CN: update DAMON LRU sort translation
Date: Wed, 12 Aug 2026 06:59:11 +0000
Message-ID: <20260812065914.3071433-8-doehyunbaek@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260812065914.3071433-1-doehyunbaek@gmail.com>
References: <20260812065914.3071433-1-doehyunbaek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B519E1C0008
X-Stat-Signature: 8odf1tip94yjspq95cbaocb4f4j1fzhi
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786517977-161585
X-HE-Meta: U2FsdGVkX18dUmCDYV3oxVqchxz+pf8cqdnasDu7SQIaOkY59jb8S3z24RKC22XHIMhT/LfVWj4B+TkRkxUzDY3eqzm/UI60AhQ0s11IsaPjxEWUBv3Vbh/HYsTSLwp7c/e9mmU7eCcYMDsh65UGhrdf9PhYI21yMLkDoiZ2+6QSoTuR+yg7Y4LCj0uz0PFywHlfrCmIunQ5la13rn3W/bGWL8W7U5I6t23iQudVDdFg9XVO+f3TTqe6an6NoKGRnDu3dhF2C2t2vmtEl1XQXmqfNPjZX9uHEoLKsyyGz5ZhieTb1sjK23bq96k47kKjmg+4iI4rkluQYvwnIaicuBFGvKQfaNtOr30wUn6/A4feLIEUsjpVcEZapfXxVpECM2f+U+VaMElBWYDLl1D3qH9rw7okOeaOdz8re/6+uYDQOTonmdUdeowlMAbbdDR15seH0KLvU5+0OiPaalpGoVQtDMHE+1QylWlKGT2Dx9iklXxY9ZOJwqllsqKv00xK0EdUEur+veizLRVkDEHT7AYo1PSvmnhV/HMy8YsfOJBkBYrOoFboSk+1dW57/hfaGY4kYFcF1TyZlSL8kvoAa9RQoOyCrzTAfrpu1+XYFBK6a9NI4bj1xE1QMveeQ1hHpMJRXKNBxL8BfxcpmjZnso1IcKZirYUa/S51g4VAUMsgVSbrzDcXsR37MMGRMfiNP+xychcZE2fqNiFzKR+KMeDgCGqRAQTlfDk1nPdV3NBN2RlUprVvUe1P0Z6OtmzoKHdxbLejJZPcurvEQHBcpx3bCz4XqJAx/5WoRRPRipnFRikdmPO4BnJR5F/xfD9AAwn7QaA/aigUmBTN7DKCVCD+ee0kPuB2WnxGF18oXaPASMsCYr83h4Burdm7OZI/fkVFg5yhGXvcSBO+ZNZLZObEVE70/BpdkuF91V4eEbiBJsqXtR4+S+PN/0O7El1Kv+9R4iCQfNKJSK6H5Uz
 7xsg5xyZ
 5M5XLcfv/dgH9DRxHLPSSQveiWYqwFAHiA9C8kZwZVzovrrydS0QJr8qT5otziQg61oBDnkBqBZEPuqGck1F4b1cGed4EdL3TsW0Y+QJy/tASMcR+YRjq04gGqq6c3ytPKmsgH/f4Z3wHGiyxrKbEtqyEETnnBz3arnM1y+EpgHylLEfFr5+tDCn12svyGbzwV5v7qFHEdMWk6iwZvTveuhnGywYUaxvtlDtp36jg8TkYUikiTwTPevjhWVaUzm2DmHA0S2OtHF4pExYYfig7OMuRDpEZM4/DcGIQ89QmzvUpA57hkqsekIhpZofLJUjQuVDdtV0qMbtlmu4l65/Z3BgX7whSLGG9ZNSbssl4HzddNHQ3uE/yImTYKA2T/S+9loI7J4qulkjMGsy+AEV4eP8WNnDwG7dyFgACFStCJNpe2+/1SgmWlFHhWeuNwmQrudgTGuQBBp2IeiiTKF79nQ2EUWcc5jsygnEXhcMPUpcn1xjvxiyBfMpBpuEfW5nE/bjT3WNtCCEgeGnjVO+/IFFpyA==
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


