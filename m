Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A310BC5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 07:05:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 572E26B08DA; Tue, 18 Aug 2026 03:05:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 523FF6B08DB; Tue, 18 Aug 2026 03:05:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EB886B08E1; Tue, 18 Aug 2026 03:05:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 055166B08DA
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:05:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7D3A2A3721
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:05:16 +0000 (UTC)
X-FDA: 85113503832.30.0112A1F
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9EE7680007
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:05:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bpa7z0GW;
	spf=pass (imf30.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787036714;
	b=foxURlPc3MZ19FXVTfrwnj6aGT+dYEm8C7OuAsuN9lAMglR4OnJmPRPSWScat6Balaz2Bc
	wA/FCPD8klUGLr+rclw++aodLW6BClxC63e9LR9jOWLhTCnhGyPcjkqd/tS7zM3avRjJvO
	sHO7bi2RQxfiOpkev0qk51Z0HNQq/h8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bpa7z0GW;
	spf=pass (imf30.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787036714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gzGp4RSK/VKV73d1qH4iqIoZ1Boa7bH9bYUYJjvkcf8=;
	b=HUmDn47NDWqu6cIpWTGXSPw1Tawh2qe15ssRuOODCp6DqM51m5p3SbtYxNEH71bM1EWpBE
	SbFdTwx4/u6ABJMzFdbGzK5TJj316OKCJo8zYmA3ipGHgLey8GqTlJPXMa1+u645bvl/3L
	TVLPuIHJ9Pk8we8AFKKG19ioeE25FSQ=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-473987fc217so115468f8f.0
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787036713; x=1787641513; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gzGp4RSK/VKV73d1qH4iqIoZ1Boa7bH9bYUYJjvkcf8=;
        b=bpa7z0GWtxTOG/EzxteCakzmip8EzRm6Q9//AXh0gUXnP5hYTcGnkpkaf0lXXc/3lV
         eBsYXqFtpyVketRHGMk7NN7f52KXtzNTcEhXYm2orVwigHJd7pM4eo3aY5W2y4kSBky+
         rREulxxbxkqceH3ZUeECRkjgPsSfbUu44Km3Rb+WjvsE378DdUG196QyDOAxwGSHKRU/
         VAboAJ6HIY9C/t4xDFYtYZINsZsXZKCZ5eZXC3XEwrq5jTIBeSM6EmS8EwBY+vyb3OQ/
         lrvJmgr+3HF0qued4tCVmP2miRryP2hvDCohKENp7dh/VdQd+m6B1KkvEX6GxRk7M0O3
         3B9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787036713; x=1787641513;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gzGp4RSK/VKV73d1qH4iqIoZ1Boa7bH9bYUYJjvkcf8=;
        b=TBBorGGz5a+xtCHCzvgUSvkWEzsEKsw2bm+/lmnIMDH6T2MFMzrAX/yr8TU1CCF+h2
         Mxu26SMJ1PMS0SoxApovLxHZ2u3QiiS8oEyQAAuo7bP4ZdMItFfDw8wJrs+5WuuQANg2
         OWnNf3HRC0SJpoyQs2WCEirRWLRsqzgMo3VCWjCQ/ktXKY1dmd8n8YXlDhKoayXEU88d
         tWpd0aI+cNGjqXqEOuixeEFXpatblidnS/aE9odIi8qf+4A5QRffedLGDY+kdMpxajhL
         X0QNXppvUMGc9tDE18cZe7KFwXsddCZB97xzucONwcc23KHxpu9CMbZoM0gFsfVao8z1
         TxTQ==
X-Forwarded-Encrypted: i=1; AHgh+RoCB0YlwqeA0DcWg7/S0/d5DbvRgUJzOWXLmvOp8ue89wsz69K5GZv+dsNCej4V6RwC8rx83qdVZg==@kvack.org
X-Gm-Message-State: AOJu0YzDDHJzS+2eWwyl7qTG5hLiCvdcaL/Fz4xqw+LCi31UviIlmtxM
	qupYr4Fp8FsswMKvDRgFP3LrgBKCodhocuFIBrTSeVjBtZz0wgYa0BjS
X-Gm-Gg: AR+sD11niObncsxncqT2SV0QIqK5wcCGWIhD8gkTm7ooA6n97UdkgDjRW4CPhKNMFG6
	b4+TDr457DBuU3FhSrhLAH+OpK/c+kClvj67GTimOGsYRlunP5pKZWBPzLJfyGzeKzUVOGfCl8q
	hWjrIjj95QxKcMV/obqaq63+eVAUAZMqhnTz6VrItYd3Z5tNsZ+frjNwlrVEvusy+1tyJs7fRM0
	H/X+zZJWAQA9MUTXki5NsCpeql2H2aLhSyI0lUNEP58U/dsCGPMTgpXeJIqcYFtUeh1XZH9RiIz
	XQB5ElA/NTVrtMrhMmpAHlW+1UMr2a6wMVO3chS1dkljWtEMETb1apVzTEYti88T7Vv/kXOEREr
	m/2K5CqrultFdcxsgx5FRyXrNSSjIWJKtGRVwDBIVh8aggaG63NmrncrLEwQzpzVXCVBc6QnuRa
	2Bqeh+qHIo+Co+w6O7elYUROhjhS5WBlMu1TavQ1EtzRIe1FyOw671QvwDpdJ6qyxkFm82tpkfH
	HVNaX0emY0h7kslgi2hbwiU7pM0Sx8T0Lw53M3L1nqt2AQIbwJTnW6sQviQk7zJccZM+wt6jnRF
	NO2Koc3JTw2kRHfm5MPurYZ5dbiD4ZKLqUZrM0ojEB4ApQ==
X-Received: by 2002:a05:600c:8b57:b0:499:8411:9e8d with SMTP id 5b1f17b1804b1-499878cb099mr229920075e9.0.1787036713178;
        Tue, 18 Aug 2026 00:05:13 -0700 (PDT)
Received: from doehyun-dev.pradel.rg.cispa.de (x06.xlate.fw.cispa.de. [195.37.157.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49996188217sm495557495e9.13.2026.08.18.00.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 00:05:12 -0700 (PDT)
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
Subject: [PATCH v8 6/7] docs/zh_CN: update DAMON reclaim translation
Date: Tue, 18 Aug 2026 07:03:48 +0000
Message-ID: <20260818070358.455768-7-doehyunbaek@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260818070358.455768-1-doehyunbaek@gmail.com>
References: <20260818070358.455768-1-doehyunbaek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9EE7680007
X-Stat-Signature: gr15aijqfqk3cqfohye3bpfmgbtdespn
X-HE-Tag: 1787036714-255041
X-HE-Meta: U2FsdGVkX1+vqBWWsw4qWAl7I+YWybPmcqMVkj1duxwi5KxnjZFsy+8vBxp5NUplx0gv2+mTJhzK73006Cf4PtlfuZM0G1LV5a2EX+KR5fD9kI+JeIDoetrCWxcZxtWizejGeUzYPZA7yAGDItK2R0JlkofKj2HhiLXRYmHmKXn8mXsZbJLAcnuQC7LW06dapSvYQXrcOH7/6C2fSZuVGss5oF3kx2uEmRDQ/N4uuXt6e2lrvmmNMWbk92AcE2o8gjNFjOFm8TNwjQYn0gUc2w4yBvLEjMiYVkdo1zkX9/YHzHE4tGmjQdYZ3zn3Mr5OTStVoLRhc2KhcCs8E4EmSvP1JYExiOd5v70qpkLiKCOr1GqK75nzRfymvoCGnXrcQF9Drw77s2xwUQF9CouL+AhG+yIYXFHN/xdLxZJUe8EEnMehTMAxFg+AusNUH4FE17PUtBztJ/tWLUu2K73FNOK56IHekol9cO18/4gZjD0YGKQlSSxeFKFp5EKpCxhG79azSdbpix8AJZNTuU531hQzGimb0m+PRMA+BrMjCUXKCjdN4uBJUXR/RaFsZP8bCQaa+JC8PDhB1i3nL+CLAt7UV85Hg2PX/ibXS755nXySPrdCf/ar4fqemMeDOO7lcA/e8zrp/7xYLTZvGkL4hrm6o6U1o++xkEqLy3WxTc3de3NrsAppy3/cFzDAza47x+G0lV4DZc9m1svcDkA3mY527kEh+BfkhJEh++xc0xOlHtEdNrMZosXcETzTat2pISOGlIno4/2mSjClt0q16Qb+em3a7N2weN/lZ/XoKCPutjlbaWrcQ4GbeUn78ebPOFM8BihI9OZIc2SlnzHWwzdB0kkcr3aKqGLl+EcCUtFmty0YuNicgn8ZDideWYnX+rmlUZAVUHDI4kdv2XhQ+Cb0LuT4IlPMmQsfNAvFNXrLqD261rEv+Cyi9biMH769urIpDnQKq95Ta1rj2wa
 EB9spBfX
 N/lPWfn712cVPAb1IN8YNrTzSPiyDR0w4bYTeNQXNjEeOt8RtEwVPt9N0N4b036G3Uxc03sZwMEhWhcnuK0G0g8kC/g0GFnikqOetSwk7tX9W6qvYo5Grp7GVM7k5xleME+hLA/vQSqzlqph+vQiidIsvQQicymnBohFcDmCM0osr3WfkEe+fElJyrhLRvRPi/UYpBI1/kUDtzr0dGvpJi+5VK+KpNATacFMN2Nmqg0RQI9++E2JOOYBMc/ofLhKUU0t/44947zG7qHBVNnWodwo39/doe+COEHlb+DczCmefu0eQjxsIWVbBFyrRAOhUgXn/pFKRMHmyIN1iWeQwnmlpf3zwBpv0wABtJMBkFSMVcVRMprtRfulAuZnVDF9Dfzv/94O3FnCXmeosFFLo1wcpVT+MdwszX0cIzf+1oZ8BLWkWbfGawdvlGd4TTMp43Q8LqrGVtcCnNa+/7XEkY8MEdNnU05OfQjUvu6EVxuspaUAumR9Byh3xZ8G3OPYEuEyLeadmcycMd4FB5ICNSyqxbRzk9zSVy25J1Ti7Y5rAwcIe9Sx+AP8IaYV2tgUKztW0BHATAmTaHhx+cIazWxR0uQdJlix8BF8wSi0kDXY39goYIAB0fO6p7sCfyo1Xb/s1aerd4cMICIePLjOUtso9Ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the Chinese translation of .../admin-guide/mm/damon/reclaim.rst.

Update the translation through commit c9380cdd949d
("Docs/{admin-guide,mm}/damon: fix DAMON documentation details").

Signed-off-by: Doehyun Baek <doehyunbaek@gmail.com>
---
 .../zh_CN/admin-guide/mm/damon/reclaim.rst    | 82 ++++++++++++++++++-
 1 file changed, 80 insertions(+), 2 deletions(-)

diff --git a/Documentation/translations/zh_CN/admin-guide/mm/damon/reclaim.rst b/Documentation/translations/zh_CN/admin-guide/mm/damon/reclaim.rst
index d14ba32f7788..1e9375947295 100644
--- a/Documentation/translations/zh_CN/admin-guide/mm/damon/reclaim.rst
+++ b/Documentation/translations/zh_CN/admin-guide/mm/damon/reclaim.rst
@@ -58,6 +58,19 @@ enabled
 DAMON_RECLAIM。注意，由于基于水位的激活条件，DAMON_RECLAIM不能进行真正的监测和回收。
 这一点请参考下面关于水位参数的描述。
 
+commit_inputs
+-------------
+
+让 DAMON_RECLAIM 再次读取除 ``enabled`` 外的输入参数。
+
+DAMON_RECLAIM 运行期间更新的输入参数默认不会应用。一旦该参数被设置为
+``Y``，DAMON_RECLAIM 会再次读取除 ``enabled`` 外的参数值。重新读取完成后，
+该参数会被设置为 ``N``。如果重新读取时发现无效参数，DAMON_RECLAIM 会被
+禁用。
+
+一旦向该参数写入 ``Y``，用户在再次读取 ``commit_inputs`` 返回 ``N`` 之前，
+不得写入任何参数。如果用户违反该规则，内核可能表现出未定义行为。
+
 min_age
 -------
 
@@ -68,6 +81,15 @@ min_age
 
 默认为120秒。
 
+autotune_monitoring_intervals
+-----------------------------
+
+如果该参数设置为 ``Y``，DAMON_RECLAIM 会自动调优 DAMON 的采样和聚集间隔。
+自动调优的目标是在每个 DAMON 快照中捕获有意义数量的访问事件，同时将采样
+间隔限制在最小 5 毫秒、最大 10 秒。将其设置为 ``N`` 会禁用自动调优。
+
+默认禁用。
+
 quota_ms
 --------
 
@@ -98,6 +120,29 @@ quota_reset_interval_ms
 
 默认为1秒。
 
+quota_mem_pressure_us
+---------------------
+
+期望的内存压力停滞时间水平，单位为微秒。
+
+在保持其他配额设置的上限的同时，DAMON_RECLAIM 会自动增减配额的有效水平，
+目标是产生该水平的内存压力。系统范围的 ``some`` 内存 PSI 会按每个配额重置
+间隔（``quota_reset_interval_ms``）以微秒为单位收集，并与该值比较，以判断
+目标是否满足。值为零表示禁用该自动调优功能。
+
+默认禁用。
+
+quota_autotune_feedback
+-----------------------
+
+用户可指定的有效配额自动调优反馈。
+
+在保持其他配额设置的上限的同时，DAMON_RECLAIM 会自动增减配额的有效水平，
+目标是从用户接收到值为 ``10,000`` 的反馈。DAMON_RECLAIM 假定反馈值和配额
+成正比。值为零表示禁用该自动调优功能。
+
+默认禁用。
+
 wmarks_interval
 ---------------
 
@@ -149,6 +194,8 @@ min_nr_regions
 DAMON用于冷内存监测的最小监测区域数。这可以用来设置监测质量的下限。但是，设
 置的太高可能会导致监测开销的增加。更多细节请参考DAMON文档 (:doc:`usage`) 。
 
+请注意，该值必须为 3 或更高。该下限的理由请参考设计文档的 :ref:`监测 <damon_design_monitoring_zh_CN>` 章节。
+
 max_nr_regions
 --------------
 
@@ -163,7 +210,7 @@ monitor_region_start
 目标内存区域的物理地址起点。
 
 DAMON_RECLAIM将对其进行工作的内存区域的起始物理地址。也就是说，DAMON_RECLAIM
-将在这个区域中找到冷的内存区域并进行回收。默认情况下，该区域使用最大系统内存区。
+将在这个区域中找到冷的内存区域并进行回收。默认情况下，该区域使用系统的整个物理内存。
 
 monitor_region_end
 ------------------
@@ -171,7 +218,35 @@ monitor_region_end
 目标内存区域的结束物理地址。
 
 DAMON_RECLAIM将对其进行工作的内存区域的末端物理地址。也就是说，DAMON_RECLAIM将
-在这个区域内找到冷的内存区域并进行回收。默认情况下，该区域使用最大系统内存区。
+在这个区域内找到冷的内存区域并进行回收。默认情况下，该区域使用系统的整个物理内存。
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
+分别设置为 ``1024``、``0`` 和 ``10``。那么 DAMON_RECLAIM 将处理从地址零
+开始、长度为 10 KiB 的物理地址范围（以字节表示为
+``[0 * 1024, 10 * 1024)``）。
+
+``bytes_reclaim_tried_regions`` 和 ``bytes_reclaimed_regions`` 也使用该单位。
+例如，假设 ``addr_unit``、``bytes_reclaim_tried_regions`` 和
+``bytes_reclaimed_regions`` 的值分别为 ``1024``、``42`` 和 ``32``。那么这
+表示 DAMON_RECLAIM 总共尝试回收 42 KiB 内存，并成功回收了 32 KiB 内存。
+
+如果不确定，只使用默认值（``1``）并忘记这个参数即可。
+
+skip_anon
+---------
+
+跳过匿名页回收。
+
+如果该参数设置为 ``Y``，DAMON_RECLAIM 不会回收匿名页。默认值为 ``N``。
+
 
 kdamond_pid
 -----------
@@ -223,6 +298,9 @@ DAMON_RECLAIM再次什么都不做，这样我们就可以退回到基于LRU列
     # echo 200 > wmarks_low
     # echo Y > enabled
 
+请注意，该模块（damon_reclaim）不能与其他基于 DAMON 的专用模块同时运行。
+更多细节请参考 :ref:`DAMON 设计文档的专用模块互斥性 <damon_design_special_purpose_modules_exclusivity_zh_CN>`。
+
 .. [1] https://research.google/pubs/pub48551/
 .. [2] https://lwn.net/Articles/787611/
 .. [3] https://www.kernel.org/doc/html/latest/mm/free_page_reporting.html
-- 
2.43.0


