Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66305C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 06:59:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED1CC6B0096; Wed, 12 Aug 2026 02:59:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E821C6B0098; Wed, 12 Aug 2026 02:59:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4B3F6B0099; Wed, 12 Aug 2026 02:59:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2EB86B0096
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 02:59:36 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8F659A1A36
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:59:34 +0000 (UTC)
X-FDA: 85091716668.22.A47FBB0
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id BCFD81A0006
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:59:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="g/hnTZTS";
	spf=pass (imf19.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786517972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jCozUlpgp0dXtm0FXnemR31LLTWCBlc2ogyMjG7W414=;
	b=ug6TOMgjBZzy2v9M5Fq0NGpuaYV6KToTmto2CW3Alh+yngJv7YOfVpt9uk7SfJu+DLMKrg
	0LE7oASCbFjlght2o1lwibGgdf62xfS3olhn20+U+tW3THEHGJI3AKyN4uBM+Icj1D/US0
	SaG0ho/HrCojmWPn+PMlEQNJRmXDcJU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="g/hnTZTS";
	spf=pass (imf19.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786517972;
	b=j83o3wXsCgda1AgCG0MulO0kkh8be6OXj9DFnwkBXVC2/F44xqSmtrDujUbUhnrJHXyszS
	AGKKRlkJBquDEW9JZgnHg+DW4B1JTYIeT0YXKa2Uwmku2Rd4RCRbNdh/kHK5V+z2Ab/B57
	aZ8dJM5D9dA8l2t6GEaY5BuM5fLbbMc=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-495522bc0e2so195165e9.2
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 23:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786517971; x=1787122771; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jCozUlpgp0dXtm0FXnemR31LLTWCBlc2ogyMjG7W414=;
        b=g/hnTZTSxxrrJiW0nvtIQaVRpbfGMU+S8LuBF7AzkN9R3JcjXBjy3HDEuAOdjHt9V7
         EajyOcU0xdKK8z22txyiGUCALboEfzZiEhvZB3qDt4zXLJtCZG7uUf/XqkVEf//uiumG
         jUJVEgZFy1pu/tSps8XQXAvkyqNnGtxBtFTTDi3Jf90lfknxMgRBAZl4atPLcJ23TY0I
         C34+bSmGKDfULveHCummVUy5Qy1HqKB5SC5WzG+pKvBNXOztRh+Ch9XZsyC4k9gKh3D4
         bh2DQmNnxsHOFJXoTXFyZ7DHM+OqY3gmFGf/xg21MvtcKHMgHdAUkYfOH7NygD1Bkv+l
         NJAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786517971; x=1787122771;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jCozUlpgp0dXtm0FXnemR31LLTWCBlc2ogyMjG7W414=;
        b=lzQnPr9EONY9ZjIYuXQfM1VsWUXvzzece0SqsqwuFrX0zF11kU2/P2SF42DLutMTBj
         vic1TiVBBDevBTxDYg99OMG38SwzgokKOgTP/rrZ0KwU53WdpmE6VglgwVvCYcAgqaGp
         I83q8ZQ3WyTcpow0Ng7T1KPJOd+D8dFWTWm66vHdUhvszndNuWo/tnBI9fPFuB9YnHKq
         y2aIgzqKytxFYz8MpM56o8MYAHT19gi0jRN81QbZBAlnEp+T+xx7+5H/DKkt5WkwFygH
         gxPocnINx9+2+02MwWzQdXoVJfIMmsay9B/Ab7d3QhqjwT84B+D4Xwb2+rJtp+JxKKo9
         47Pg==
X-Forwarded-Encrypted: i=1; AHgh+RrhXOwy2o4KYcttiLBA7Thsi9hHD2QhEcc4EV13IWRJv8hLEqCWi9lpiVKviPo68TMZcbkTFkQjEw==@kvack.org
X-Gm-Message-State: AOJu0Yw9e0pd914mrWJAHSGNzBKMGjJOSTB4UWl6vFbGQ9Ey4ehx8m96
	n/Eu2l4ZKDCbGS89wASQ3C+b7NOc57SkFX/L1UBbxaSJvZ/2+j1dW/Yc
X-Gm-Gg: AR+sD10FPMUwcPr0AsgI3AIZKcY6cQAZxQw2Yw5V3i3C+mu7V3HJM/X3ZMjbVLtIWx1
	4mehsz7wLQvCYMDjGrot9+M4T2aqo/KASwOtmJ+w6bdAGw782zhw5BoqRsbUAsOlbcS01GIRAB3
	xd/zOyBNPQsaCIo8J+t+bnQOxJCTPW2FPvLVGFq7gYfrk7K7PIohzJ7PFHTAo2Eepu89Arb0SdD
	936e3+FgCH56WajsObYJxO+PutTV3To5GrSpnj9Ke+VeCCC8nl180CSRavWX+DT7Btrd9G4+3AE
	ek9RSEbHYB5nehS34JByT4OiLRYDAW0/9o40pJNRx6CHBHJFVYUpJiIZ8Kk9jMBRLSI4gL/uuHs
	KBGP80vlgzEokFRFU7HJhQTHX0Oam9kzlWwB+7fkUL/ZBs1Xefhjq0qnEnDZ6oGRCieimf7RzxW
	SYxqMja2nMOM6X2BA9qyCbqMsMRU+ywl2QJLrS6nNWNmK9Fgl7fBKfzVLsmYFns1CC/Nd87sB1P
	9SNmCkjXrrlMN74uomBKIDeOPlyLh28jxw97rJG7b3SXH8PcM9WKvdhLYLSdf/m0Vj/0cgmqFcl
	14xM10kkHmXCAGBkeppzn3c8t+dTrNzUKiSj+3IQksz9Sg==
X-Received: by 2002:a05:600c:1f92:b0:496:c249:ddb1 with SMTP id 5b1f17b1804b1-4997c1582dcmr14159395e9.4.1786517971073;
        Tue, 11 Aug 2026 23:59:31 -0700 (PDT)
Received: from doehyun-dev.pradel.rg.cispa.de (x06.xlate.fw.cispa.de. [195.37.157.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4997b15b807sm73628005e9.7.2026.08.11.23.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 23:59:30 -0700 (PDT)
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
Subject: [PATCH v7 4/7] docs/zh_CN: update DAMON start translation
Date: Wed, 12 Aug 2026 06:59:08 +0000
Message-ID: <20260812065914.3071433-5-doehyunbaek@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260812065914.3071433-1-doehyunbaek@gmail.com>
References: <20260812065914.3071433-1-doehyunbaek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BCFD81A0006
X-Stat-Signature: thoxpnquz1an4nf53wkukhbw4ec18fy7
X-Rspam-User: 
X-HE-Tag: 1786517972-59957
X-HE-Meta: U2FsdGVkX197maqWC3ktnzR0HKIEPAfakdZfrLZM3i27eDub6PjiNJ3niheSDv6k8JciYp+oXjw4Fytd8ePgkZz7YJDttta2u3CgZve6AvjGldvB1F0KriWhfFOe9+pdDx5bYLodR1+9U9+gI1WmxVUM5EnnZgddL2E/av0IlyRTEQ0aUqSUToycrxhiwjaYd9cPT9hQku1uKDmyU1fek9jPchxrw8p/ezLaL32iInUN/0aFqNb+XlASFue0sCVE6pPrkqN3cvaKCs8QSY1Qq0iog3vg1w7cRq0eu/5IW7zdYOzyGfIADTFvi8nliLEYW0dn6D/l4bcobp0y8em+BQY8QhHjfgk7+JGlOaAEeBtGzRMuAo3zesd75E0EGzZKn1DyOQV48rwcnXph2Hivu8N0hXYNT0RZxfU7L86+SFE+KC3fGRnjdPiohCl3J/25GbA2idDRHo491Oh+PDEfKnjIBOL+k3yIldNoEurEFAYDrQ2WQJs8gVPplK0KQOawY88aJSwfI+hZt9JWEBShpqbJDg0mfRpB7/xaCwtnlqx7418zqBqnQesN/w69HqM9nff+Qv74Qfkwplgys9menNVITFeJlsS8pANM8fTH5jRBtiDxcVc63/AatekXfihLVY9hgmFowBmZMiKQrc4kB2q6LRdP0dEeUwrDN2yYJlBPIW4KgjD5vGWYGiBG2EEOwVnO9U6twGqXmK4bjxQ+rs33+p5ErIRu+JkF8IdQE6WzMEhR35MMnSeVUW22/pyHNGaVNUp3wZg+x841cjaGKBJA/SQ9pS1Nd6zSnJwbWJsFZRQLRbN7xH5ETlvxCVfQ5UqhY1rW5qQSF008HLFHPQUzTkNF5L9TLgSTQ7V8bKHeMNZx4v5pCWrnDuNkU9g54lT4R/mhvPRgh2FvYJQ28Wpl5CETuM0dgEELl7ALRwa9AzLEuT18qHj1aZJ8WLaJY1NR/pGa/auHZcl1ENa
 BBhztZZO
 7H3JsIEw2L0G+EnMINxbei9cylO8wLiBcy6aBQ4ipcAXmgWVFNohwhUzzKJ9zdHaAx4zrLuwiU45mMT549LWh5aAkOHVCzvd8lpzzg9WWaTu3ckW2l8Z1N4qgln61KHX28nO9L5UEYBy+8tRLnHfnpb7TCT/3qI3B7gs2i9NaXRdTBtMpecMnAWllvA/13zit13J6K9VTjAl4E3XLemLgdG0X5wd7vYOFGxIUFq2rCECUPwwdUtZhlZ8Zq6rudkbgpEQuGamaD7a+SA9VGDwd7FjrqpwPGvOXpfyxxYeFPXfwqESwfQzzd88i7GOt+8dInKLaV7xqtdJXZGvhauuehfpyU5kQreW3ECT1n//zsVra57g0+DDpjVRiAOQz0P5m3qRUswBRUAluHFA92jXPYKRCjyzkQOzMQYtnlz6NmvATFrUxk9xEInp+jC14uPIm9HDc1ViY0CPYTUUsw1YtnnIrgZN9Py5pLgD862Yxiryq3NyGhRx5At+0H3ffBXgrjxqx
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


