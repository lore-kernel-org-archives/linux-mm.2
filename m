Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 838F7C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 07:33:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8669D6B0096; Wed,  8 Jul 2026 03:33:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 817D96B0098; Wed,  8 Jul 2026 03:33:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DFFC6B0099; Wed,  8 Jul 2026 03:33:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4BA356B0096
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:33:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CAD6BC4062
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:33:34 +0000 (UTC)
X-FDA: 84964794348.30.A18655B
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf24.hostedemail.com (Postfix) with ESMTP id E8060180010
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:33:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qIqyU8KS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783496012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jCozUlpgp0dXtm0FXnemR31LLTWCBlc2ogyMjG7W414=;
	b=thXGFF0tew257POsbUBQeTxDSNTlnQQz2j55iqImh4Xx4ZamAoLViJZQqAj2WVwGMQZbSJ
	UicLVXvc6c2XsTA3gSEO0GFE2PlGufWQW8+q1yuJkC9SyV043p7eA3HZKhz97oAG0iMNlA
	rzurt6UzVvC1iflNHHmZiXDNntuu3DA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qIqyU8KS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783496012;
	b=d/VrCvKSSgC/asRCB4rki3qTop9JM8d9cg3yXbZe1DV3vIoBZtwWAmjIQA4M2YSTmGCDeb
	CNSn0MXYPFoyPCOdoqFdzmJ4Sx63px+KRoX1m/vXxHOy+HOpASuEwM2aFCONiK71jdvXSN
	S6V2JvdeJNdLA/VX6EgTYpCrQmnfQa4=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-493c1efb503so628255e9.2
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 00:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783496012; x=1784100812; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jCozUlpgp0dXtm0FXnemR31LLTWCBlc2ogyMjG7W414=;
        b=qIqyU8KSoUQP/fRkubkVGIZbQecHsu2SylZYAfilsygESSNaabMUsYQhhiLkOOrPw6
         PzmWSU3IEIaejzNmEuOyh8EIvZLRi8GfmJPKrcAcLEr7o3pX76l+1sjRFg4XZD0g1eHR
         LUg0/Z1oz7g3K6PERfUJq7j4+o3jg4RYlGYflQmmqW5Gih7SI7nNqCyIYBT6HfEPkEU/
         xsdjeB9ut1YfwYs7KSrp4zznibDmwCY42I8jcGR9qCVdqey/iUTFbG4NlgpH2DfHwP7n
         wlkAmmCtX85F50FEUjddOGUtkxUF+YpVQLE1oWweKXvBsHFhk6eenCc1LnRYoLJmwF0V
         FlEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783496012; x=1784100812;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jCozUlpgp0dXtm0FXnemR31LLTWCBlc2ogyMjG7W414=;
        b=nkd413p3JFgb7MjJPaS1RQGkyE+Bxtx19w5VOxe9K9BGwptUlYC2W76FOzmVjcrVkI
         SI+jzLLCMIKlw9Dq/OY5SYYLNBQZ07DwiCneOMXLUK6s5ra9WFzOCWfktvFWQd4eaf91
         1WfogUsGev0XN1XmOiJjr0sLtTivetmhSr0/iZXnXe/yiuajihcoZtWMkYt+lnZuSN9X
         du/FnGhlahgsGaBlyVN65gLBthd4bEfXZViDisD1DsBFjolpr1VHJsqdCEY0+DW0pkn2
         VR5xWTVi+oG7LgVP3gqzqvsfyuM//ITYRMQq68Bg/Kl2MDl9OP9nJKuOiHpC6E7wdUBE
         LRZg==
X-Forwarded-Encrypted: i=1; AHgh+RpA+FG1TF+5dmi7vgHZu0g5d6wlida6Ei3QnsxXJLa91Y3AEZ2VFPMFTiqaD2MRSz+Ac2uM0ALixw==@kvack.org
X-Gm-Message-State: AOJu0Yz4b2fyvpB9FjnmtiUsr9GcfflNZ+uDHcDFg9hn0sGBqO7WT1y6
	/c7Rh2UTb1E21frvv9bP+oNNLCogXQ7ni/xfd7RpzeSY5FyuN5fLbGgAIDQpXDus
X-Gm-Gg: AfdE7clYH9oND2RibRnnwHo8YAZftkAYcj2TgJBmPCB2Z7Xdp2DDml690g71yIa4Eo/
	5l4GK3dEzIdlKts4P6DAvLcVCaUv6z7lTYTdivoXAjFM5Or/opfafrm5UqdBxHGjZYONkaA4/xj
	tTmeSeGRlxmWAbwmlkn+5AEa0No0eGeorslvwkTglFid3GbxofJie+a3Kz8DyEEAcV5kUZyDouD
	QYFg3DB5eUiLsYsJO2Z2jm3NSP+GS59fLnC4CjiN2ItBuMZuKLvpxuw3HRS5AR2ofQQtgN8VuU9
	nfKZ/t/9OjaaQyUFZUZpmtYFeQNNx3YwsNOPExFJ7SSrZa30YcD2aBNgU1mSt8RUbyPkHmhZxN5
	9GXXiYaKtFF0idAqcBQda1l23TDBaR795MP+ALDrQeNfRgzLYrBkIT5a2wwnEPD7+KhG5ZuLuTd
	Ngf9xlYMpsL0qhMwcn8Tl1Ns9deqB5JNN6m8eIQ9pX8iLvKd9ISdNpVJTXTjkVslMoE+cgJHzcn
	4h/F1+a45cEMtO6
X-Received: by 2002:a05:600c:3b28:b0:492:4a7a:e415 with SMTP id 5b1f17b1804b1-493e7e88d26mr1166605e9.2.1783496011537;
        Wed, 08 Jul 2026 00:33:31 -0700 (PDT)
Received: from doehyun-dev.pradel.rg.cispa.de (x06.xlate.fw.cispa.de. [195.37.157.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e610532fsm32876355e9.0.2026.07.08.00.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 00:33:30 -0700 (PDT)
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
Subject: [PATCH v6 4/7] docs/zh_CN: update DAMON start translation
Date: Wed,  8 Jul 2026 07:32:43 +0000
Message-ID: <20260708073246.1652828-5-doehyunbaek@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260708073246.1652828-1-doehyunbaek@gmail.com>
References: <20260708073246.1652828-1-doehyunbaek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E8060180010
X-Stat-Signature: 8gyg5foxq9mm5xw9x3uezcjypt18rtdj
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783496012-951249
X-HE-Meta: U2FsdGVkX1/NftubtX1WLQ2slIZ4vMLkglkoTnuuz09oBrG0op3oY+YEvfUiPL5yoowMTswxxsOTJ2YY1lC4/rv8ukt5s92txnl6oghhYCehY8YPuaFCsO9e8f2uR4xOUMAuXhZG6RFkz9IBQpj5eRwfT1yoJRURVJIId0QwE6UsKinu0VDerSg+KmCJalzrukpKNZyesRsbE+a5nfReNzunPymjSPpXfa+gjBqQew1r3Z3F4DP1vetj8AA3ULKkSPFt8Ng6XSd+sPVdW/Fy7MBpy058bcm/c4mTUieniGnDLH1BImPr+ZR/2KoCvp4vg7L+Ao+8SDzQFPbf68r/V1qFwIJ5AB2fsUqIRuhh26uAs9r3fzWrX1kHgu1WXN4vhXKhKAd3ntnUnl1PQfxzGDBs39QzYui9VzN9EJ7yacexryBEzMCsJY5d/cPYunqYcx8L2pAlmXILx7zX21lksyHUHPH4g1ga/r7WeqvZkKFgUztIHMQSA8P3wFMZSSIKVcYi6BDL+Ijypl4GyzsQRgvCNPpUzM+2pE0ePh5lKCy/Cvt24/70cVN7WgbxNoN0+243Z0rZtsvtXxJW4E/N8uz4G9omT3y07XRz0TyDGPDJTDZhkkcfO1MeRut4yT7QkH563jWa8RSwqQgJqFuPJTEU0k2rskcUmSugC0pOhZksXyj1B/N8C1HPo3P6g4u41JM8IwCKHi+HZQaU49inL3dYFSWsSc5ivc9HMCyWa31Hi9givtLpfI05e4rCFy3DmDtCfM0uVC1zWquZqg3w0gZhAKMRywPcNq8zkNy3LqeI18/3Rol5okDc/fZDA1rVCWcABNWGJ7PJaPs7UokaeWy34WWl/j8RpgstJhMZVSQX1R8Xx7Z1wCVfltAyfESzAUjtY+DeJ+3RlxiQ7LR4AbSvcVUpjE27EPR1l7R3gfe7vn5Vt2vQkgRDDYYhmgiqpZjodvSBWtM2MKxvKan
 yMRjcqsg
 mTwOGTWNk3brZAQJ8YHnePiS6LWk33bcY7/Eq9LZMsdo3ahUY9gnCnLimt9/j9mViE15gaDCsV6g4TN76NKDsOWgmISJVHjd4ahk+JnedlBAWYRR30bnh7sEMA30d72VUBjrggt6PLZvvoItTadRMa6zSwv7tfey2LcIM/56RHZS56UDWlGsJ94dcr2hDfMsaxVGSoLgIR0sCX8J8+MMrHoChfI5PqZUgEMDGrcoPZSs54aFehlgQEazh1R74p+bBECZc8JjFcD6KyX72kKhYMj7FTcaZ2zs5+VAALVQBDRB9qbCk/rTfX8ecozfarmO4rPrkZQnwJpE/EWwX5QhKKh6Q/3pryrim7OPHmAZ/qILwCZTLgIevnvR6lNMUNgwbk7zxHknOQWufhKDhoFmPFu7lduI8+2Z4VqmIYPVK1GNVNl1o10SBqWN1jFLAinXgMRxO+kOow5zN07/B0F99Fx2bVO5Ss3/aRz1T/OITjJTGCdscG86CSujcxsiTbl137YK8
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


