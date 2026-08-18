Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B476C5DF67
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 07:05:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2DD46B08D8; Tue, 18 Aug 2026 03:05:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DDF96B08D5; Tue, 18 Aug 2026 03:05:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85A6B6B08D5; Tue, 18 Aug 2026 03:05:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 53E2B6B08D5
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:05:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 976E54087A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:05:13 +0000 (UTC)
X-FDA: 85113503706.25.BE33F13
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf24.hostedemail.com (Postfix) with ESMTP id BD920180003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:05:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PjacXhKL;
	spf=pass (imf24.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787036711;
	b=IqX2mK5U0hj/vGZtJpie1GWZafE5y+/M+efxAlWwBqsXlioiFwbZfhxmKGOXEUfEhdttyJ
	jSzkkhdt3U+hm+7YEFkxMq+IrIa9QgNa8qQeqCIbfq4mMSWaV/mhDaHoW9xk+WVD0VqSua
	D5IKjx1NSuCqLTWdOL22PyaT7ZNNuUI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PjacXhKL;
	spf=pass (imf24.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787036711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jCozUlpgp0dXtm0FXnemR31LLTWCBlc2ogyMjG7W414=;
	b=oY2Oj/37edFXSF/qQmsSCQQZXDVuhIWrAuXC/tNkGQyJ86qi2LpFlmaDzz1xk/fGlMAhg/
	UHHyDPch8BnnpaeYQgb2axs8wf0AS9D3qBTZjxVlmCOkBg94z5tI7PZXYtDBnsy3LUekvu
	lWaJTYZsSagGA4Np2VaXuT03fA3zLsU=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4954c08a7c8so4623805e9.3
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787036710; x=1787641510; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jCozUlpgp0dXtm0FXnemR31LLTWCBlc2ogyMjG7W414=;
        b=PjacXhKLrDhEngD1aekM7MKf/g2vGzeUKeuhQq2N4HwxNccu5NxL8i+Ei1dzoh541W
         GiMiixp7oOeC14V+ZDGKYKZxvVqMeSMfAoGVCrekSdBhp+wAPCWwGVkD0NFECTdDsHYS
         g0RW5QAlZM5lTVQFHZ1N2Uj7YL+0sjWoxJioErkMe4mKlOGHmZ2E6kBTiWPufM+yY3Ph
         1lVMpv+mxJfcKMqp8dz/WI3JZ5tMnkLDq9WhpxS5KfV9l30hsNUiRg00FnyU4TmlLXRw
         5UbjYMTV8oYqFEZGIVxlmzBrcbJwhtByfuczZzQDI08L6q/r2PMq9UdVNyeRKJrOCqd6
         /5aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787036710; x=1787641510;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jCozUlpgp0dXtm0FXnemR31LLTWCBlc2ogyMjG7W414=;
        b=a7YFipmDNZBdDunn3+HT3C9tiqHInw6RZZ5nUTqixRtH8zc4S9ulraAUN+0TVLq8pf
         Suv4rWjpMWb5dPC7g55zbubEtyaPYrqS+9XqbdHdK4wV1Tj/nE4qsd8MMTQbF4d9XHhh
         2iOjUOfag+EiC3dahsIhvO20H8KWJTUvCkoXxmAKs+H1JkfWsfz15NCDYiQONfPlf3CI
         W1bZuvAYY9r7n4N0gw+uNY8U5rA/lXO2EHUFXG9vgK5JaHPKMc1Pk8yuxOyQbM6EF5ib
         ZxA1AoLzGxe3b0xIc//BXLrP9fUANNRckiiHokfNYIk9m72MopjP7ZMAMNUGMGdWNcd9
         4HxQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr0i+6ryACQVTgeJjvGjyq3sFFyU2mhKtMZml1bgsfc7K8MFQB62OsWvxzyVaJUFqWL54wKtT5Fxw==@kvack.org
X-Gm-Message-State: AOJu0Yz2p4ZTEsLPL64rn0tUyM0Azt/tej0xIn33nZDIV5uTrkpkbtT+
	JDk0FSR4fGueAnMKKcST7ML5mckjcPL+488uHwtKxc7Cqml8WoYt+PuR
X-Gm-Gg: AR+sD12d53j018AY8CwbYWSSe/mq4RtQ3jeBTWa2plR766G3LatyhuSMIXOQ0ayECIF
	WXMsSoO10Hy9wWOAo82dVPfG/lbyWlmvjG9Zgx9RhSipIxSX1o0qedStsXdRbJZWvUtUQabsI/R
	5kiFBfKZiUAPh3PWX4cKtb0n5cBR3o5oONjxPHA/mxhjNP4yaDZO+kELmEwiXYIFhlmJOvM5TEs
	G5O2gSu8HUH/3xWQ9AEK/jOQ509omeVhlh+Ore04rtpZsIFIJoWFmpF9tmXXrLXaJkKAEMQveqK
	pIt47PPf+qFai8KG6ReWYNfCek073Bode1WdPrg8nuhW+ni1PwuqKsGuvg1xJBCCXALf7ZzCX1w
	p+FQK2KDFeQJ4yXPkEMeHAZ8FAxWsaVoINp3OG5mP1ae7vo5rVO+y1gsaG1y6s/c4AIdRP09tf5
	6zgzodvDqrulVs0y49YAxG5nT+izGeVI+bMuDOZJ+sY+ZeunMVwkAvX/6Pb9BthzeTRVtIPp2h+
	OFSIIidl5wxM/ovH0axtDH/u/VpQ93K0OcUFYFHuR6KbiHpRNcFhlPCv0rl2HQj7nt5QyltTyJO
	y+nA0Iflx4BTPKyNf23fD9pq6AmeSnTXOwRdPq6ZM7oPVf5wOkrb5xQT
X-Received: by 2002:a05:600c:4f8b:b0:499:5b0f:72b with SMTP id 5b1f17b1804b1-49987944318mr228818095e9.1.1787036710203;
        Tue, 18 Aug 2026 00:05:10 -0700 (PDT)
Received: from doehyun-dev.pradel.rg.cispa.de (x06.xlate.fw.cispa.de. [195.37.157.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49996188217sm495557495e9.13.2026.08.18.00.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 00:05:09 -0700 (PDT)
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
Subject: [PATCH v8 4/7] docs/zh_CN: update DAMON start translation
Date: Tue, 18 Aug 2026 07:03:46 +0000
Message-ID: <20260818070358.455768-5-doehyunbaek@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260818070358.455768-1-doehyunbaek@gmail.com>
References: <20260818070358.455768-1-doehyunbaek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BD920180003
X-Rspam-User: 
X-Stat-Signature: 3ajpeubokqeyi1fy1cmg7uot6ozecryk
X-Rspamd-Server: rspam06
X-HE-Tag: 1787036711-599110
X-HE-Meta: U2FsdGVkX1/UhIbOxBezVjOhIwZIZwKIiuTxKPuoL1bTD/3hx2rB9kmnqHgVxoMJEES7TO8Bd4ndKUwPQvY1GKynQWw8MrwXYv27Em6hn2skHk1qC78Cx7tsexFPYFrCPpe6rcc6lNoa7IOXddXyW6H9QDsjkpHjqra8mPkz5c/5ANEY1D9+ZKuTFtjZCvPh3JnDWihRoNXKPmR+zErC/W86rsIALGP/ATvE2lwyumqmVit4clyNE4bRz4maRIe/QlAEnheMJxV6cTtpWAUr6kxWiqqdw4AX4wDQY90ecO0oUg54myz5PEU2EeG30ru8Lw+CTJlBa80X70kW0vz+xjIlyoZ4/F29h5PwMqoSByg+8TOgRpe6x9D8rcqwefw6w6Ha0fz+0skr3OUZBMXZBPJ1Vq8U8pprL0N2gzw4WaSHPjFVQ+N7PSGjVkHaIp9lJ/4zdQhBjAXkVXFl47x2HJ8HOr8VLabXx2kN0blQV02k0wc0Eswp+X0QZexPgeZMoySuqRiBH0GRGZBDb2d5AqyZz1P6oPg2YfN1w4kA8UaH5oraZ5hFjakM0+fKytqlcczOlmWWd1uCk6Hb3x81ybHr51nE8tj3kDulzHjcAH36CZ1vQdVLSenXqMzWBfkgVFufmvEJhtBSuOR2+Uopie3HX41Tgdvrd1B0Sr192Yk6bpbmpOIo62Z+S1gZ3yDiFTaNM4GDW75q9dt7OlmHetBlmEnG8Zccic9VRHlN8gdWQCFxPsXHHG+IXqmbY9ZrVS5nniECZL8ZgRQZGrhIlZLB4gy6Iip3uOwdFj+gHWwb4XAb9KKBi3rdPi+tnAJ0T3M8Jkchmzx5/Q8LKm0zQUQpL1zLP1P51NpJdLhtLPkArvHNFFvyFPq5pJnXiJu7NXXb5eDx/CVZhC83hASqOaKFLWBZPXB3YWhT/cuFoU4MaXj6x3Id0JQSqCDobTQmF+Ew+nokDMsRhozet2s
 /I3zvZ5v
 zv5UBt5nohc3LYipHKNnaEWMrTc0amaLXuEQ0wwl1U0o35V0pu93kXLb/jEWSE5yZJDvM5W+fjJ+POX0U0Ra/LGdBV0JOKWjlFi5uwmhEjGznj12+WL8GoE5BCdPWcds3d6w5ZDBr6QmMNZmFVcP0SpMgz/1NwYtog5/C1YBMKMdPaQdvHR43Q37JgYLlXzv3fFIDmVLKZNZTMwDBAhrUKHrLsbkO4BhCLaqDvumFnXAZrQixVznHJwM0svAuHeEOX82KCVjAUt380rqamMWadA9jdc2xkS9rRy88HKjqDlasi8VEM2maKoINbhs2oXgVOz+omco4D359T+mp2UD9RhKHcOGD32lL1tjRhPl0oD/IiuJAjt2hblR2clT235DA/96FFsUTXz7Cu4ueh6N8HSSzhkDe+aRfpq6bP4UToHWsqnJHZYjU+1K4/ySXu27mY4CnP0P1boTvmeByi51WGF2XOsOvEyDn7sfxTSxO4DncRvoKC7gi+l35/wwK6q7xXWOl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the Chinese translation of .../admin-guide/mm/damon/start.rst.

Update the translation through commit c9380cdd949d
("Docs/{admin-guide,mm}/damon: fix DAMON documentation details").

Signed-off-by: Doehyun Baek <doehyunbaek@gmail.com>
---
 .../zh_CN/admin-guide/mm/damon/start.rst      | 63 ++++++++++++++++---
 1 file changed, 54 insertions(+), 9 deletions(-)

diff --git a/Documentation/translations/zh_CN/admin-guide/mm/damon/start.rst b/Documentation/translations/zh_CN/admin-guide/mm/damon/start.rst
index cff7b6f98c59..1a7f3382dd15 100644
--- a/Documentation/translations/zh_CN/admin-guide/mm/damon/start.rst
+++ b/Documentation/translations/zh_CN/admin-guide/mm/damon/start.rst
@@ -35,18 +35,63 @@ https://github.com/damonitor/damo找到。下面的例子假设DAMO在你的$PAT
 这并不是强制性的。
 
 因为DAMO使用了DAMON的sysfs接口（详情请参考:doc:`usage`），你应该确保
-:doc:`sysfs </filesystems/sysfs>` 被挂载。
+``sysfs`` 被挂载。
+
+
+拍摄数据访问模式快照
+====================
+
+下面的命令展示程序在执行时刻的内存访问模式。::
+
+    $ git clone https://github.com/sjp38/masim; cd masim; make
+    $ sudo damo start "./masim ./configs/stairs.cfg --quiet"
+    $ sudo damo report access
+    heatmap: 641111111000000000000000000000000000000000000000000000[...]33333333333333335557984444[...]7
+    # min/max temperatures: -1,840,000,000, 370,010,000, column size: 3.925 MiB
+    0   addr 86.182 TiB   size 8.000 KiB   access 0 %   age 14.900 s
+    1   addr 86.182 TiB   size 8.000 KiB   access 60 %  age 0 ns
+    2   addr 86.182 TiB   size 3.422 MiB   access 0 %   age 4.100 s
+    3   addr 86.182 TiB   size 2.004 MiB   access 95 %  age 2.200 s
+    4   addr 86.182 TiB   size 29.688 MiB  access 0 %   age 14.100 s
+    5   addr 86.182 TiB   size 29.516 MiB  access 0 %   age 16.700 s
+    6   addr 86.182 TiB   size 29.633 MiB  access 0 %   age 17.900 s
+    7   addr 86.182 TiB   size 117.652 MiB access 0 %   age 18.400 s
+    8   addr 126.990 TiB  size 62.332 MiB  access 0 %   age 9.500 s
+    9   addr 126.990 TiB  size 13.980 MiB  access 0 %   age 5.200 s
+    10  addr 126.990 TiB  size 9.539 MiB   access 100 % age 3.700 s
+    11  addr 126.990 TiB  size 16.098 MiB  access 0 %   age 6.400 s
+    12  addr 127.987 TiB  size 132.000 KiB access 0 %   age 2.900 s
+    total size: 314.008 MiB
+    $ sudo damo stop
+
+上面示例的第一条命令下载并构建一个名为 ``masim`` 的人工内存访问
+生成程序。第二条命令要求 DAMO 用给定命令启动该程序，并让 DAMON
+监测新启动的进程。第三条命令从 DAMON 取回该进程当前被监测访问
+模式的快照，并以人类可读的格式显示该模式。
+
+输出的第一行以单行热图格式显示各区域的相对访问温度（热度）。热图
+中的每一列表示被监测虚拟地址空间上大小相同的区域。列在该行中的
+位置和列上的数字表示该区域的相对位置和访问温度。``[...]`` 表示
+虚拟地址空间中未映射的巨大区域。第二行显示帮助理解热图的附加信息。
+
+从第三行开始，输出的每一行显示进程的哪个虚拟地址范围
+（``addr XX size XX``）被访问得有多频繁（``access XX %``），以及
+持续了多长时间（``age XX``）。例如，大小约为 9.5 MiB 的第十一个
+区域在最近 3.7 秒内被访问得最频繁。最后，第四条命令停止 DAMON。
+
+请注意，DAMON 不仅能监测虚拟地址空间，还能监测包括物理地址空间在内
+的多种地址空间。
+
 
 记录数据访问模式
 ================
 
 下面的命令记录了一个程序的内存访问模式，并将监测结果保存到文件中。 ::
 
-    $ git clone https://github.com/sjp38/masim
-    $ cd masim; make; ./masim ./configs/zigzag.cfg &
+    $ ./masim ./configs/zigzag.cfg &
     $ sudo damo record -o damon.data $(pidof masim)
 
-命令的前两行下载了一个人工内存访问生成器程序并在后台运行。生成器将重复地逐一访问两个
+第一行命令再次运行该人工内存访问生成器程序。生成器将重复地逐一访问两个
 100 MiB大小的内存区域。你可以用你的真实工作负载来代替它。最后一行要求 ``damo`` 将
 访问模式记录在 ``damon.data`` 文件中。
 
@@ -57,7 +102,7 @@ https://github.com/damonitor/damo找到。下面的例子假设DAMO在你的$PAT
 你可以在heatmap中直观地看到这种模式，显示哪个内存区域（X轴）何时被访问（Y轴）以及访
 问的频率（数字）。::
 
-    $ sudo damo report heats --heatmap stdout
+    $ sudo damo report heatmap
     22222222222222222222222222222222222222211111111111111111111111111111111111111100
     44444444444444444444444444444444444444434444444444444444444444444444444444443200
     44444444444444444444444444444444444444433444444444444444444444444444444444444200
@@ -117,8 +162,8 @@ https://github.com/damonitor/damo找到。下面的例子假设DAMO在你的$PAT
 数据访问模式感知的内存管理
 ==========================
 
-以下三个命令使每一个大小>=4K的内存区域在你的工作负载中没有被访问>=60秒，就会被换掉。 ::
+以下命令使每一个大小>=4K的内存区域在你的工作负载中没有被访问>=60秒，就会被换掉。 ::
 
-    $ echo "#min-size max-size min-acc max-acc min-age max-age action" > test_scheme
-    $ echo "4K        max      0       0       60s     max     pageout" >> test_scheme
-    $ damo schemes -c test_scheme <pid of your workload>
+    $ sudo damo start --damos_access_rate 0 0 --damos_sz_region 4K max \
+                      --damos_age 60s max --damos_action pageout \
+                      --target_pid <pid of your workload>
-- 
2.43.0


