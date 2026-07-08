Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 982B5C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 07:33:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97A5D6B009B; Wed,  8 Jul 2026 03:33:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94FAD6B009D; Wed,  8 Jul 2026 03:33:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 866C76B009F; Wed,  8 Jul 2026 03:33:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 545766B009B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:33:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D91B61691A8
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:33:54 +0000 (UTC)
X-FDA: 84964795188.05.C476EB9
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0461840008
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:33:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NJsbDcps;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783496033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gzGp4RSK/VKV73d1qH4iqIoZ1Boa7bH9bYUYJjvkcf8=;
	b=3o6bQWAPK1Kf0QFMdbGlPn/rMIGbE8YbVDSzoQ/Wv79DV4jzG0tTdq32yrBBw9gCB0slJg
	D10WcBTHA2jvU2W9JPXJcPn1GMAqXlH5BmBdXlnrUEjwWH8zUM63GVhQ7qGVZ/3y4PwzJx
	aNm3KEkBQn496hUIrzRqgQDmUXP9QMQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NJsbDcps;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783496033;
	b=3OX258sqxQhWliAr1NKUJUtTslXzf9tv10vvBN1hPBrrfgnNRQ5lcsfuqGjfKojsoX2Mkf
	XjKiY8KhgjOcoBjIVQxKfCdVj/z/zOtNU8Zs/0Mqs9sceyldk9yluZOm36mS/QhnVOPMQR
	SRXe86jcDPOR2/qfOkDO5/lxXPAWJC4=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-493c1efb503so629425e9.2
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 00:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783496032; x=1784100832; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gzGp4RSK/VKV73d1qH4iqIoZ1Boa7bH9bYUYJjvkcf8=;
        b=NJsbDcpsDpPMyc37B/7vsNb+6xupsYw1NomAutVH0OLKdciV5S1fzf+nO5FSNBeFuu
         n2+5Mz1+NkcG2FhKWY1u82l3YDCkIMO7apdhEHnl+4iRkV89MxNZSglEbhi4ElL2HEvV
         y/xUX9X5qKgsjvRolUIGTAsTPgoaBIGPkJgaycnh5xd7cLM3ZLd6GUucs33wG8lAy2lE
         zCMyzZRxxGgu3gmmNuy+VU7ocJrvRfccLcJ/zWHIfYSIPpjZjRqYwcql/D2wpLHwa79u
         //VaRqHTu8SKmNEDh7spEWwoWuypJw5okZ8RpcAJ7C1oceNFm8as8YMYKbhf096eSPdL
         sMzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783496032; x=1784100832;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gzGp4RSK/VKV73d1qH4iqIoZ1Boa7bH9bYUYJjvkcf8=;
        b=MGiwuMsDEjcz/au8MOJJxfzdNFiHLrM2tTT8ePNoCjMLPa+YwmFLLBmnGMaxsU87NB
         cEbmJ75SyE3nDeT4KPtV15eDfG2ofABL9KL3UtWscFi3CpdBJYcUc/FjCpM2GLYd8onP
         Niuo8Vwk43j0BoVuWEzcZY8gas3md+qXiFP7VIKmijjLcAo9WXictTlRj5aXoftOhnJ6
         DHw4YM3WUJUid9xX1uZbBAD31bb8ok+PILgc/GL09EKFLjy3JNb4/E7fbyLXPLJME0Nx
         QRjRZaKkZPVU0ndSJA/UQQXZ3CCS2W0kPg7tpm5oFhSdSyuCwfd70ddYW2WLlKAHyJxm
         8Kpg==
X-Forwarded-Encrypted: i=1; AHgh+RqnMdzFynJNo5GvpUzLLg6Ix1ZAlV2lYZyAbWuHb8e7rekJqOMj5wfGpx52dsxvVi6OzRSGNV2FFg==@kvack.org
X-Gm-Message-State: AOJu0YwDAqdTenyIhgNRynNRexsKfEa421kvL5r4hVEC/jx4+sLHPjKI
	1IHewB5snINgbaNvKMLKuThLtNdrYV5RbsbzjzhDs4ffj60KpS884ekLsNei5Qst
X-Gm-Gg: AfdE7cn+/skCbRH+2JtTwu8SXENXqcuuBWGSU3rmdpbZzoPlXG54/fQoZTcKIoBRX4v
	S4q6m/3voIqTOYJLgBtJTLvOnvVLWPfi89raMbxlRzgx3D9et/XxDkp4Nc0NClN9f87kPzp+3zm
	AdlKTRpWeTiueSr9KhGhx+TT1pTr7erZ00gYCmTPS8/8wqgAJqN8aDyOSXF8/ksrZq8acO3ujvJ
	EhfD1gLKJgUKq690N2IPxmkHiogAP9r5lPsVtY+PYXfZecDVY/4mHHQKWemltfQiJARMTwAjDph
	m1luYvLGWWi73Xg835z9lKx2subJ4isqNGXwcoKIxKhSyuSFw6HGs4sdyNabi5SvOpDcbS9Kp2J
	WrlZknV0BS154/CK99BswEeSQUYlKpPEzaJmQBk7lWhD1T7xrpFH1s9zf7ma97KsOfWiW3pYjDo
	ZulMqDF/H9dS4IZX2MOEEKOT2EHdOxiLdgVN1nrsgx9JqFQUE5urQvmJDlHlu1pGnLXdok5buC8
	1kUBP++KCnawmGv4QsNEnPSH8I=
X-Received: by 2002:a05:600c:34d1:b0:493:b7f1:2e03 with SMTP id 5b1f17b1804b1-493e65e09a9mr7319995e9.0.1783496031640;
        Wed, 08 Jul 2026 00:33:51 -0700 (PDT)
Received: from doehyun-dev.pradel.rg.cispa.de (x06.xlate.fw.cispa.de. [195.37.157.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e610532fsm32876355e9.0.2026.07.08.00.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 00:33:50 -0700 (PDT)
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
Subject: [PATCH v6 6/7] docs/zh_CN: update DAMON reclaim translation
Date: Wed,  8 Jul 2026 07:32:45 +0000
Message-ID: <20260708073246.1652828-7-doehyunbaek@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260708073246.1652828-1-doehyunbaek@gmail.com>
References: <20260708073246.1652828-1-doehyunbaek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0461840008
X-Stat-Signature: 5yhrjn1wddgsddwc6hodnexosynexmku
X-HE-Tag: 1783496032-876021
X-HE-Meta: U2FsdGVkX19m1z0vKIibnF49UDGXDR07jl3ZDh3aXopelRNGJoWNyOgjo8jt2CuEBeCeMt4423dqi+crmZ4vEHvJ5RiRZduk9DTWG9BRKkmurtFdxrhxWw2kztMFZ8t206/kSDLZLHHluPEWjF+T1D7ZNAJKO4/qoOtKZTnTvGMFc/CtquR1a7aazZQj5tqVkuMF4LV0A/1oivwjoLPg0cyR4OCsIhfj0j4eVbXLbEz/zY3PYfldLt4Na8/GupYXwQCW+OnWW/VpXqMym2V9D66rdOkLaJLTNMIbiu6fQcdppuxrye8qfpO/Fr/llrDOnsEvJmYUYEXmnRUGIustERvahao8mhEjipug3aBJiA8k7gkrdF29firhrEnqNUDMa+Dzki7HgsKWHip1i4iJJTFR2jCWNLuQZX1WdVkwR9Z8UjmQ+hBmz9S0ghDcHJPHxRP7+yFdPCNKKQEzzG4tcx0o2KMTw2r9A+YpCuWp3U9oLidNg3NKHstevsRyWMk4T3P7OVjGQSMylaJTJAvFH2EN60jnvMMEA4i1P8Ud1am5CbGC51P9/iZSe3jd+SciRip4Io83XTpdiM9eiHGQmB1Mp4FRZHzeY4XOMoagx3r8VetK7c9AkU9NT65xuNgr+nyn1hgooIvaM6kAmts3eJd9bDQzj3nUWA1is6xgomeGHeGpuzw5WN6FZGCnJn16gdoGki3vNnrkieFR24HD7r6Ox2epz2QYWERu6+kEuTlIdH3jaS4fBNVo+rv8rOigHr+2ZxcneNqngyewgK0+o944medjve6aB/UxCZtQjopcZHJTFIlb9OdBcsuRETYq3wQKwUmi1fFPjszo19huebleVZPrtFzuXUgiZBKdZTmgb4U2tmZ0CyLcTriGg6XFKaYLovc2UVVb3ozVCG2ofEHG47CfPpuZlYj/CwgoWFb0K1uRpHjvhSt/oJlZeix341CNRZb2XF3UavtaFLV
 gtVJxiQ5
 yN6+DtEOnpdo8l6mjNpxragEs7ZeFFwOrlTTSzIQUXUwXBA0SGFZcJYiMfd7V4WCby+So5HGkqStF9yYctwtDZjwqNF5zguzVSUtbkh21+jGnAmi5XRoaK1Ede92UWAYdA7fylwIfkaxumZdE+E3MlktMuJIDSoa1cale6/QpKCJ3vH8Xo+v7M4CkOP4OnvDaPe8lOa/lGM375UQ+ZPLlfGr4R+KybOt3Vp8Q30tVD9Q5QfAZWWSCfVcvjKu7kOPOuxf26V7nDdsHlZ3AbQJ1EawKPKQe6cYNcwlFZ8pUSoMzjgHarK5r3/2JGxfL7anHfuyfFbtythVFSUH56dwqwX+1iw0ejjR2kNlRmjLxdo0sX4EfpmYSW3LI3URjoXqjemMziBZ7B9ZCfEBvt/RI77TebU1syNLdM88M2jW1kCI+WS7EpeyfsUv22LKae7+OO2t8x4v58YiRC0GlJafOHUxZYPu5EdcuaoCgenT9PhxhUCz5Q14WSJokM+TFTl2cGKhqvGElzMnXI4Q+3smLeKPlGDmltYO7bnE7mxnsiOpVVNVfggNck5sVmsL6XGm31zZwEdv8I7phfXjdWzsW6zePko2KLwjMf25PfIBBsV6kFBtF/kkfWXF6B/6nXtgcfDZX85wcyB85QqA97dE3Loctvw==
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


