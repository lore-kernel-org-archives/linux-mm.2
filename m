Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B450EC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 06:59:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC4A46B009B; Wed, 12 Aug 2026 02:59:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9CCA6B009D; Wed, 12 Aug 2026 02:59:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8A606B009E; Wed, 12 Aug 2026 02:59:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7670B6B009B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 02:59:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1097D1A026E
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:59:38 +0000 (UTC)
X-FDA: 85091716836.14.7213A99
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id 40928A0006
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:59:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VOvxG71p;
	spf=pass (imf25.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786517976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gzGp4RSK/VKV73d1qH4iqIoZ1Boa7bH9bYUYJjvkcf8=;
	b=preFW9cYALu03KKXXsfrAVsKbe4eQhwHfSIXCwzJhQKb0sWnFLehHjI7outjoFLKV/P1/o
	rj+k0RHbrnHmLorrfmfCTFe0dS7oeuCsshiq8bhSE8lywRgYv/AG7qbemRNqnbF3QdX7VI
	3ybAduKpfVkaJeuIG+U/FpTWFtVIBM0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786517976;
	b=WNq3e015GP9RG1GCVRorAti12a0ArqNKVEnJ95LEymmdk9sVdmnlpXEF6Q1IV48TY3J+1/
	mrty6HOZw0KE1u48CKwg6WdFrkuPzrxR+GRYRJCwL9eAxEqhy9kZx/+ZLNISIuv8GUme/a
	7qNL4dtq6OR7TZkq3Gw6z+sORvQpWwk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VOvxG71p;
	spf=pass (imf25.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49552f516beso144215e9.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 23:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786517975; x=1787122775; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gzGp4RSK/VKV73d1qH4iqIoZ1Boa7bH9bYUYJjvkcf8=;
        b=VOvxG71pFlIA2K6smvxXnCXb0hbG2nJt57y5P7wN/7PkiTjyPQkazbM8b0z3vU5I8N
         PcV0xeimRzvhbki7t2OGAzrtU23q4e6xB3ZI5G4NoTS1+p7jYeDSWKDUxWHyBSbJlrIx
         8L0x+47KE4KOxUEeRY7Tc7O7MvPU6ZXBOaKtkqFRgAAVwLXDH8Qzql5q90XD+YEukj4F
         7erwDOcSwJn4tq7eI78pSdmGmzT1cs+YxhRr19/8wPg+PLGnBtsxqWIP1Ld/0Pm/iaNF
         8iiDpWH0W7HKRtvWlnGsJDoImqFaOaTMT6vO70hahMnj/NOx2gZaQveq960gCDEhfPhZ
         CEUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786517975; x=1787122775;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gzGp4RSK/VKV73d1qH4iqIoZ1Boa7bH9bYUYJjvkcf8=;
        b=X62oP00mckGU+F4dRBShCyCRelmdrj/R7theAYQ3zT5bY6l+T6KMvwhTNy53GNFOeN
         X26AtmpP5rAgb1Yy5Sy1NXxEI39X3EFWzaYgTuzmj9Wbp0YwesZi4OC5r49W+a+DZ5KK
         fNYz39hnKG5I1WsPG7ABOKykkot6W1Kg5C+jKq82wNAAWmRBKgrM4ZTcnYhYO2gVP7JN
         Y9x3kNjBRVOhPxTzMzERk70aurNVL3rJ47WaZP4IVSnehzJqos/eJvBV7H0HhvoIfrag
         Z5RjQs+AjHhltmebIg9OL+BiHy50qtmPNEJ8oAhkK0QAsrXh/oc5OiAy5tWhGLp2mqC8
         S/Fg==
X-Forwarded-Encrypted: i=1; AHgh+RraoSVkkJ9b8QLPEEQixgrv9Txujb29IVYxdWikweBk1zZgOy70Dts48WlhqWQcdZOZI5QMToZqIg==@kvack.org
X-Gm-Message-State: AOJu0YwPhFUzZpcLGnnw3pWSgG9BRhtFfJ34MDrr6mAaf58M81itEQP3
	GGY3VxwTe8bUH4p6HDP4fBkhQmxX0hE9/QePeliQ8dkO09hQLBfJd5Mi
X-Gm-Gg: AR+sD137xOgSZ5Z8L2IOydGDArv1U+re8Mc2unvLtXhpUuv+S77B8YjgzZ+vPIGTquk
	kON5F4JDjjKbKPd/j/knnc6az9XtFZmyI2/8QP7CLDN6MIRFP41q9balEP3+RR19zsZI5C+rid8
	dS7VCY1Yg6j9QRE9SaxMpEALP30GkQYeYecOvwxQrnzCqYdFp0WCHiZtUlLpw2DZhegV5MXooP3
	vBM69o8Th05puatbRLGA++AjiXZ4ILfiQVD9a2Ljd8K6gV26PCRFDZ8FeLvo04zUiWFNomlZSlj
	rkvDW6wT6mKl/tuvRHl6jlYvY1oANKefXIQYmwmQIKmcg+cmVvTaeS7Awl6QRGHw6sYbG+ypoIG
	w4CJozasfhR7DXSmdSI5XEzO2XRoZ3FMbiETCscpkoOV6IzmWHGK/M0Fny9QxqluLY2vW4KMK95
	TTbev4yKmwrLCYXEr2BzLu6z8fks1B0M9RXJRs6yyWVMjp0o7msKvUb8ohgpofcPAH/iW9nPM0c
	+1xSpGFU6iAvnby/guR7P1Bd+d5u1Bb8OL9Erp8Er4i3GPe8xc1+4lROWcMkDh6V4iHtIfOBcES
	00wPu1ojYpOauIgKCPR/zcD5BNseNFLBFTv/yfxZLQ6uig==
X-Received: by 2002:a05:600c:1c25:b0:498:1371:660c with SMTP id 5b1f17b1804b1-4997bf8879dmr16240415e9.0.1786517974771;
        Tue, 11 Aug 2026 23:59:34 -0700 (PDT)
Received: from doehyun-dev.pradel.rg.cispa.de (x06.xlate.fw.cispa.de. [195.37.157.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4997b15b807sm73628005e9.7.2026.08.11.23.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 23:59:34 -0700 (PDT)
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
Subject: [PATCH v7 6/7] docs/zh_CN: update DAMON reclaim translation
Date: Wed, 12 Aug 2026 06:59:10 +0000
Message-ID: <20260812065914.3071433-7-doehyunbaek@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260812065914.3071433-1-doehyunbaek@gmail.com>
References: <20260812065914.3071433-1-doehyunbaek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: n8wtis1zad89krsgch3dnro6r59bn5fs
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 40928A0006
X-HE-Tag: 1786517976-847487
X-HE-Meta: U2FsdGVkX197IrSO9hb9Oi+U1cJb+h100FxLHpLSsnFKbnFh9o16OHqYMYSLlRV6tqj5dF9m1yhPjAuN0eV3S9NTNYtx0DJFBlg43sejp95GrIe5Ljaab7r0thjJstdVARBijIWAGxL+GNxtlWpFbJi6iz5yZrm3jizm2ENkomILl1QI9Q8Kg4AXFGvfxx07Xk1nfNtSPEZLFahRGoMfblNNuoyjIqXJsilkjIg6NvxerQ6dvhrKkAl/Wniad7H7rr+oSk9iUDQUqAZVhVdvi6Of+t3tnFLCDH6pnPJMNRXgliLi/owRag6KeLhzF3p0f/wyv5qWSpnJH6RNJyShoBK0F+kSvof5d+jE1NKigD+9p1/OqpwxBbyD97z2ysda4O3dIOFUkEDfHqrDmAOdElbJyWQ17DyQxYBEgX2ewPGG1p15tGSiwnuQgdo4liiuu41tMFhk9XUmhpC/MWn93wOr/4qGXuLcks2sFfzElFhWUIbJ2YYnkIsDi9bbscrdYnGiu9fOerrYbE3PZsFVZNJRrIczObyav5kyYXUQq4bx6c1yRCQWffFMTCPBpnGkTBE/Mwsz5tjtnIKfBFDDnkI1ibVFrKfd7oeXthxI7VKfy40MdL6/uJddVJXmdrjxNC/dfTDzsknZtWnfa8I+B1TrZxQgwIMnxUmTgO0Eq7m5VRSCuxdbE57agny0TGD0233mPcC0DwtshIikcWb6KFxLyTYYXcKL2mmvqxkCB8BxNrdPtwXKOVjm92lIx05/3sH+mJB5m0gDB72nHh4uerceCC8CxOssM/AkUxbps5eNPH20JpNyIzR+t4LNMxNNBtL8InOJn9bD5rQLymwDBM0OjMZsBCA7COZSe7Mjo06I2Tvf+F2Gyu5kpduCi+ULnN+1SzXD6FvUXmj1QEUzYScfr5ZO/cCIz+rAZd/yyJHo6yjhPB0dSxe0W+g0g+bFB7FQ6NIF4ehZZJMH0Uy
 mHEuast8
 0mtkKdfbdZdaymOaCDhtVF84fYRz8KjwMFOgGgee6aoozXhlRqIdJvwaxy/Z4u4wDXqTLqxXuZ+V8zKSlLwj4AsZ34KYYvORT5eH93o2oFNN0VMu6rW0t/z5b3+mYfRhQ47IpIuF2V9eS6WmwIsNxrG6jnkAJjOZcVvHQFtQXQZzmqz7RYfDXWbx+vJNI0iFw5vjE+sGgb9p3Xc8lv2P2gHmkHIY5iBbqHSuyMMn0nHXwYeuZZLvEBJvuthWypU7GFm4hNeeVFvzO801BoRCD0WtBSCJ3S/wF+eUyFSl+LN49wWXNF7GHb6LruN5VIMhZV0VAq7Iz4hfBsWfQrupVlSZYuYNUkqsk9HJ+RyePCWtVTtpGe5EMjXcEBYH6IFn5ANYFMgEw0E9gwBWcb0LPKdXvsrW2LybzA2Kj3SUqDtpyUd1STb6RnP46aZ8+VEIDA8N5kFs8kcF6QoLz8GQHyZdipkJYfyH/Ah5xc5Q2/l9L9XLo/hGPomGp91zsl/FMxgPz9Zz8OuVMDmtlypkx/6QdkKP0KW5mmvoFiy9GOS1ESFHVT5MRH/C/uDJGwPSwq2gQGIW67IZrHrHid3J0y/hH/8WAZ/2aLT0mRdr4j7tyywb3xEnvFr2cdMJUC/Z5QbcZWw5lX0gYIl82dZexho1l2A==
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


