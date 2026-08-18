Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE734C5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 07:05:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B18966B08DB; Tue, 18 Aug 2026 03:05:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC89A6B08E3; Tue, 18 Aug 2026 03:05:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B8AE6B08E7; Tue, 18 Aug 2026 03:05:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 71C966B08DB
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:05:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F31B7160A85
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:05:17 +0000 (UTC)
X-FDA: 85113503874.12.9149321
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf23.hostedemail.com (Postfix) with ESMTP id 246DE140006
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:05:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="d80p/iom";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787036716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s31nZQVBL8BUGSoys1iksqFJSqf6kbi1kgLlk3gjtUc=;
	b=NcY+1Dy4SyYssY1XVIFL9MZUsX668d7LC0lOrIwbhBQEe/oaJlVMyBAgNz8d2z8ppx1OD+
	DwDb9RLxUTp4bDiDnpNw6yogYJalD/VuQ5GQsdKXcn3QBgkZu7XLz0AxaW7GcBV+sYSVVF
	ajGo1Tp5kwzqYFXboCEdzAv9jXWaeAI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="d80p/iom";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787036716;
	b=QCD1W7NvRBCSXP6nvSHvfw8RsM6zL4NZsrcfPoqbAyaEN3uT/Xvdc7S1aQalF3isVnrqlR
	Mlui4hc90H0v5ggdmJlViwe8tzJrYOrUNZIseOYTJPA6leNbs5tq41X1joX0Yf5c9lEpm+
	kwN+i9S3irXwCZ+ixLqtV/Pos4Wq4a8=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-495522bc0e2so80065e9.2
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787036715; x=1787641515; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=s31nZQVBL8BUGSoys1iksqFJSqf6kbi1kgLlk3gjtUc=;
        b=d80p/iomaJlsFjozhqQZ0ux5KksE838O01Qt9Nw9tR8wWRQbUmxGeWBHKSvp3O9rSl
         XPYhdjbC0GVpPVqvjXEA9BkXGU6AuPdTdlYbltMJf0au/lC96Ega5lLtXFocZOptwVR9
         rCVJI7lDxKzZcGo00n3jmKKrUd1AcU65KCOaKnC8Ji+5ZM/BCLX7lnzjnrmdgtc+kDsF
         1OvFI4CIFaJ1SV6okmFdr05FVx7qfdI4G18wn9Hy5nIviudrNThAERL+dFyXfdC2V8O7
         o0RvBIj6elCxKLDh4CrvPofMN0Op/3/IRvLayo07Ielru/SBqB53NP+WmQZeOfbaRE4w
         lyBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787036715; x=1787641515;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s31nZQVBL8BUGSoys1iksqFJSqf6kbi1kgLlk3gjtUc=;
        b=fMP4glBZwUSvPlJMu3Z4yW3ehxki0hGE7dNqPtnfW3DgBHLoZwDmGo45rynIh3pi9g
         xHe1o4Kg3VYXpKpua97VVFnz9qVhUGHvKsgQxM0gsPJkwD96DGfq9dtYcuZJTxWh8/h3
         HwcCzcBCSzI3V1NZNRwIkBjeB2j/ZmYP8hfyrbAzXChvx7XrGLPGxTF79+Pb1Jz3n/pb
         Kh7wrXVvtxwh1a1zC+0fxr9LZkMNG6RBd8FS34tlnwWWsPONMhM/YIrAadeYhY8phXF2
         cWhNJExTvMLDjzmK/qX6crMItJUrgnRRxvrkxiaNxA2qFLMk0pFxbhWH1Xet9Vliis3J
         Zs1g==
X-Forwarded-Encrypted: i=1; AHgh+RoJRwZdjdiuwwdIYhTBvTclR9Vq7l+pEk7/OVFYTRM4MYvG+L/ZwTKR3c8kqLSjnKipl3MVdLUFdg==@kvack.org
X-Gm-Message-State: AOJu0YyRo0lfWumSvZMS8oUBx3/hOJRGR23ezhuXx1bmT1MW15mnbLHM
	L7z2uRN4UTtW8o1pErkbNtKbsXOku9JMlq88OwZJxialtN6FHVJphw58
X-Gm-Gg: AR+sD13JBpaqMAyjqzaFU95mt21BHEq9efYvioBzwg7/4QK/CRQMs37kWXtHbbIZpw4
	18/hdkM+rnjcYxOgui8r3spu6+YoINyUOSINrbGqPQW0mgJcI3PfE6G3MOLfzF4F8NRwhdC2/ni
	noQMJd/1gwnNJA/ez2mxznL5gdoRXAk5HCsFXd9kx9aGtyJ5yyiR13WfwoMGCJYedAVRzaupLbM
	LPn58yDJ5RGgBQ11KzqdlHsV5X22OpPt2mM8sy+gdFdnuJQkcQ5uEI1gxUzebktq7VdUSCjuQD+
	3Ndt6KMz4GDuonS1x360gRyGyv9gpnXqJUPniCwDAvo9DcrB+LF8d2wxOJk1R6I0mc/P41GIZEk
	R8Wa6SVrhhRI1F2b1+ezf7RJ1qtv/eSz26YVRHoMMtHwQ/8aez0FApN7lC6ZnL/2bJuxpExKtQ0
	vixQ0qiJdQuXbkJ1MXBA8dlX7aUaHiRR1ldeWFV/ryACjhEYFcQOwEvs3kqKlYNUZeTH4Dz3vvk
	W35keNihRU/g3IXBTfOHPuFsdmhYNiXkloFOGC7is12M/RbrUbnzZVC4XQKSxusvm/YQP4hxu6N
	KP6XhFPMThXVOsESglFmN33CjQaJznJTKhsMtwlIudDNMA==
X-Received: by 2002:a05:600c:a0d:b0:498:1371:660c with SMTP id 5b1f17b1804b1-499878d5e0dmr231844905e9.0.1787036714647;
        Tue, 18 Aug 2026 00:05:14 -0700 (PDT)
Received: from doehyun-dev.pradel.rg.cispa.de (x06.xlate.fw.cispa.de. [195.37.157.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49996188217sm495557495e9.13.2026.08.18.00.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 00:05:14 -0700 (PDT)
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
Subject: [PATCH v8 7/7] docs/zh_CN: update DAMON LRU sort translation
Date: Tue, 18 Aug 2026 07:03:49 +0000
Message-ID: <20260818070358.455768-8-doehyunbaek@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260818070358.455768-1-doehyunbaek@gmail.com>
References: <20260818070358.455768-1-doehyunbaek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tm51co1ywitkyyyj599oqfqdrz7o63o4
X-Rspamd-Queue-Id: 246DE140006
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787036715-47513
X-HE-Meta: U2FsdGVkX1//L5hZuPen6XcSJw67/5if8MjPeDksQTm5PlQMpJd3fBwh2O6cv3mFqTl+vBnTevs0f5x5w7OhLWlBWEblD1xHE4FKP47yubR27Lh3p9i91XPcDxR3d2CyfNEB9H/YRXVaGpMlFcEko0/eyP/XQ0q0wkayeV8m7uhGFQJsVt2B0/+nKiRi1nUQfbJF+vto65RZrS3jHg++vOX6+F4zsiet9QmLnKN8BtAo8/yjBKHSFmbfGcG0DYOHdJzs/9p1SwBja2bfxAP+4d08jtFsMYRvwW+D7VzqQCccyjwuRxhF6XeDaDoj/6cZ1aduUMqUEYbQudR88PhbjDvbYfPOcYzZ/TAIrw45Ts7lr6AB43XNMPvzRtu7D7INJZrrj2ydWX5twhQ0fdOK1AWrrDzHLvX1pCc5JNvCqPmn/khUffi2kLbbUqQKLaVtuK3Dz9cZlvFfpvajNTfDoxaLLCJkjTWxxsUt8UjNgDdOGwCRtK53EMW6optgobcAnfiP5PVxFWn9NMrlyA8FClcpXwM6CDBQ9mSWhap6Dd77RQHpUSTxBOVHc3xOqjKvsqayu2caoj0aadXFW3yfOE4FACwC6imj+hVgFab9TqS696bSZ1HAFmql9S3mT75bsuU6Jhoxlm59aVFDiE0D0cyU9XIVREwb68o+XjFE4BIAXunz2jgZD4rarTn34V76FInt++svGjPLgncyI7ULoTyrEJ/pG8LcAexNzV1M7zjFVm6p7Xn3o5FRwgSuw1uDtIP5kOaCX3XAe82ijTj0ed85OC2ehmFuFrC9hwupd4UsT36U3jexzIwvdcoquSIEoxvoE+axjpOcImXUl43CxyffYJSPmkEtIkz3czurLcbbPSB+a0C1i8I7H1IDi/pFeI748nmFqUgUTjBEjNWsJGZvJ/aqdTKwVnGFC2FYYDsNt4IFi4zz2OEVVhdLgqBHmGQSjg1HpHYsAs1LukW
 QRj9P7qT
 hNGfwP0Y/GzpF6U4q4SsC/RUA4xg17fOLAAalzOC3HShBlt2cYHnzI0SheaXT0G0fb1AaR2uIJUeBQqFIVS/pus4fW3LcEj6yOMpM6d1SK4Y/+mbZi3vYF1Ikieef0uzldztkPfGp1F2agt9P2H3ENyiKP/xdugjEbOsrq6m1uMaJsG0WXIwxK6AZIfMQ5xFSKbm0sOz/4utQ4MChcPfrC5S/Yv7oRiQnGYuqUGWJaamyyKGhVRJLXnRB5g21kVxv2rUWHFs4d5GnvoS6SijJtLEGmSU0+Xd/qxkUnocAhdH4OFEjqFX5LFWqkpsGz3ZGtfJl8HdzeeLOoBGqggwYLLKEviJ4iZ8lkxFvrUpDlKV3xXFhGiztiEzgythKP3WA5apiAvpD3fPJ0AN8PWPNv/eHhYwbeS9GRrVQUhPADpbSIH/8hvTSF+CGz5QUZl1UDTuU18lFY8Ad1JmXtL1nhM0Wi+bRSqDLTkcFr9X1HLrDhYFghTSwvSNk6YwSuaeGsL73Vh/C6lTowNU3y5ZUp6ah7A==
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


