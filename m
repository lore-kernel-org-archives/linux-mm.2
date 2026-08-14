Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 912E8C5CFCF
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 16:31:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE9676B06EA; Fri, 14 Aug 2026 12:31:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA1256B06EB; Fri, 14 Aug 2026 12:31:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAFBF6B06EC; Fri, 14 Aug 2026 12:31:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A62146B06EA
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 12:31:55 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 43092801C2
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 16:31:55 +0000 (UTC)
X-FDA: 85100416590.10.8B2034E
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6CC7340003
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 16:31:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="QBJvjv/r";
	spf=pass (imf17.hostedemail.com: domain of shuangpeng.kernel@gmail.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=shuangpeng.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786725113;
	b=nlr0zY6fOr5tKB2XJkVdMNlpAyUlQI3ro7DFR4THWN6yP6qRIyHCyx9Na8afd57d0AjcpB
	belZ+vAFpO9Gh9Ym09mCd9pVATkEo4k7KT0m9M3KXJOGCV4SmN6/4y5nzZpFHgKDMKuLyH
	UIIfnfb/NLiwiweQR+/1xh/MAQj/vO0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="QBJvjv/r";
	spf=pass (imf17.hostedemail.com: domain of shuangpeng.kernel@gmail.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=shuangpeng.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786725113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qP3/xbCH+ItyubGsI4w69p0TyaaTEvp23aOndMgOaFY=;
	b=Pyog/2k/9Qxm9FatGYy/rDJDfv0gnRXWAM7c84kHmzLkpCxNjGI1MiK+jkz1fqKBQuYPcO
	cyB/FOkaz6wy4rRVV3hfTlj6CDRKSn67eblM4dv+/uocJuOWVJc/R6wmHbYYhWR6ejdL3u
	PKNf/5wjdBA2G7op5SJQhHgM9VjlFMs=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-52d8679c149so6738271cf.2
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 09:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786725112; x=1787329912; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qP3/xbCH+ItyubGsI4w69p0TyaaTEvp23aOndMgOaFY=;
        b=QBJvjv/rISHDtBTCNF+YsaJXgVUIbOfqNdeMBeOlhdMr//1dSrgGOMbs9XaY2QGIJ3
         byH18mvnj2TTH58ACeTaEPV+ztwVvzqu6tIpBUnfeUq7OiefBuHSf5p6EGjrkMPNLHUP
         o/fciGbBA1UhoriCu6mWGxp5avrA5iAMQNXCMlkfjhJ2VByE1HnKoE7s0Ni810PO8N8a
         6WGUD1cWjeZB0r/qCMS7E7TdRDVAUQuue09CQU9d6Xcn2dnd2bIesxj0RV5XcUoi/ewA
         YcZ0S7CZalfbpItbE9wDsulMCmLMMONG+Zemdc8lK37gTTBNY5d7X1tEygE8dW2brvac
         VuGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786725112; x=1787329912;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qP3/xbCH+ItyubGsI4w69p0TyaaTEvp23aOndMgOaFY=;
        b=JaDWGqYU6mtFoAVSwDbuZH9/x9SXidohP3B2Du50+ufI/jt85K/8I3v7iyAGF8/BH2
         Tq45C2Zbi7DukKDchivZ0rgR3saYi2Uk05fUUIlU2MOKbVKc4lerqE3lpcTD7U8qpBz7
         no89p8M2g9Eq5hqMejdfLBH+a5WMQGuMrN5hP5QmqTt7NPIetot6EEamwbpajwmKzoyf
         fJBa7IaKI48RosfeC2wG4FA+FapTEfUsoRF+GE0K6DsmHqtUQDkzAlPP+9xes6edenJV
         gnkAKMI1VzXeABExY5smeWmAWP0T2vQSm6pVjSZ4w5Y3R8PkKQCIoL8fxLFabhjIg6Ik
         SpZw==
X-Forwarded-Encrypted: i=1; AHgh+Rph8gK3OxPyNQkNEB1V4QyVaj3I3bDHkhNkDrNoOTrqIDkEcCfBP7oqvVFcmn0/FTiJfW9FVzqsvg==@kvack.org
X-Gm-Message-State: AOJu0Yxt0P/dsh1yl6zp3Fc8MXa3mXZYTtnMCmDGUY2ybbdjZ+uQOsDw
	EVL8fYCKJK9oRGGBD6yX0tfQotS67WZgiMB8OTmC+k0Xdkw5fxJhpa+t
X-Gm-Gg: AR+sD139zvpkuH57CqJx4IRLuMSAAyjFCM/guvs3QfMmUaWU6fHppmI/sX5HUGTNz1a
	FshazQLCecKGHqvWr1TfnGlxLlPAzIsrY0HC1YXyWocJdnbUEy5dR0mtIW7YyV0cMa2N1diLo3n
	Xj4oa2R1yZE9lkpZplR6kZ/sOCe1s/vudk+TMExs2F+c/XEu2pJceaqHFwXqpqGQiHuCEXDIJV/
	ftPjypxcIyFryxAE8CvPCxtjnQB3uFIVRP/fXJuUYtvphZPnLxDixhaY0wnQGhwCrE3Yjd+wuXl
	98hHnNWcHLURdZvA1feb2GpfnIU0bOqAimU3EWUTYRLZgiKDTIAsuw63NnXhGcoTMuffMZfZvO/
	7Skw44YBqSz7jYnb0r5SSnHsYjg8wdXp/0S1DvdyFq7zoOniJbdTfZFWmqwfL74+7T2t55yhkDf
	g9yOxiMiI5E16ZOt51qpjx0yMJ4MHAHXvgAIHEwIuxCG4VP5xEW5N5FUwDs4QwdnRvQwrY6CvqI
	w5fdsSfzOhc2Iyibw==
X-Received: by 2002:a05:622a:86:b0:51a:329:e802 with SMTP id d75a77b69052e-52d85525d9bmr77225441cf.41.1786725112400;
        Fri, 14 Aug 2026 09:31:52 -0700 (PDT)
Received: from i4-l-hqh5357-03.ad.psu.edu ([130.203.139.71])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90a921e4c3esm22570046d6.1.2026.08.14.09.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 09:31:52 -0700 (PDT)
From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
To: Kees Cook <kees@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [BUG] firmware: memmap: slab-use-after-free in firmware_map_add_hotplug
Date: Fri, 14 Aug 2026 12:30:56 -0400
Message-ID: <20260814163117.3390709-1-shuangpeng.kernel@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6CC7340003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: oebtpw463iijht6fgwz36pocycfthjb7
X-HE-Tag: 1786725113-711984
X-HE-Meta: U2FsdGVkX1+YgUxmZnWEAjTQNu5O1g/aK3JOC6WbGbTrNhI1Zb5PX4iywvXOLQdYvfjl35BBBNz8nR/sMoMZTX6jtpApKgad7NHGfSINNJ947UC/lTynHU7kB7dOEYmJ5ngg0/vkUUJDggih/E8e/n8eLdtIIHPI5FuViN3IhLQnenRVDhPEw37wWyLkzvevfA/nnbCD3XLY55Vpy4EZb0oeKOeS+/wiFQ9qznXBhT4gY/Z26uyQe0V6nFllQsqjV6099cq+oewNtFjb7JKRv02Ak9a+QXViRbbu1ZHYPzoI99WP10qTNU8/VakDofHxf9A+VjJQF2Q9kPbZ27Rn4bvgR776daH+u8ydIXE7i0ropLYGGEeqdmN6XQy6SoOvz06VjAsaJF2uAiPZLYTPDd5MbG92Qv5vUYUrEy9YpO9LFJEnIgcyD7jJuIiHasVrtNdKugESAHamlpuqhZLrMmf+VmWWPBSh//AbYgQ+QlIGb/Ccvu3/e2WRvGh6lFEWZwHUHQUBg+mWNzL08abV8W4xmRAwtlY0OaAmQN/KfOdpZNFeMIJLouVIRZ7kC/upC726xdKad7/19irp/VLK1HqwJwPTzxH4ihO1fpKufuUKptJjkoE+erAV/ezQZXj29kTSIYABk21lqYug09xSQ9KrjqosksfaCn9YnUK4B4oUtDaCiVDnyPN6T5hbo8dRwF6iJpDvAP/Z7RTHFexP6QYlqWqIYZSV8csmQA1pVLfJRtKq4pzAnZ7bzvTx9+dwExJhfIEBzlLlBNrUcNIXr35hRmYhezDis8nNFCA/70bO1GadA0IDxNtRS22RS7cPb9zTYW1LFUT+JCBmjK+QvoCTpN+FRQzEMXEKqEmoe0M5kJl5neDaJKB6PyV7ekFfgWEcKiCtM/XK7lze8JQ+DW2+D1Q4d3olfMQ4FJ5B6krjU0u+LdOb3QEVvGuSr50Q+gIaQ0Ae6JUWcm4MBDV
 yP/zj99M
 mHZr3ppIIQBQa7LE0W+F5ciTLHpaC+Xp2WFvXiMvEKSCvVoQZU7X9yXUgky4nFZah2xI6NzIxfGd8Q8RrylAhtwp9duUdV021pByKN9A31XiTcPXo2CTxNTqy/uHO++c69Bdnkh7pEPSjF6AdDPH09F4iIHsAuwWgyWJmZ3h9LlYSBxWJko2booLXSh4u1UDSEw55foWPodmN7xUImer1yn8VTYa+EDB1tPfDxRKPREBsqL8bG6ss8iKSQ7gQjenykqc0KcoIA+F7y8G5seK2etMM8RL/OI9KEx9UpFW/OGRnnlXdHprFxMBKNxJ+yb0qJ8ed6qPHwEfK86xvlMM/SUFV293gPSd+f/gkkjKtZSKguxZBbBiDXLJ8iqndasfuUthrlX9m4ngqdm+bSkMLrOr0GnLvlRBNjTY9/H1F05mnLMUNOZDI/qRAiDt949/WJyM6XUKZIzc8jYI5Ubk+nBc85qJpjMd9JZ8lbejhfHVp4xmjRcBntIg++G/aQ+Mrr6X2KXPrUBOyB8+DMU75qyNIZz6qLEBjfYCmiFMj73wIs1rySh5SB546GA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kernel Maintainers,

I hit the following report while testing current upstream kernel:

KASAN: slab-use-after-free in firmware_map_add_hotplug

on commit: 3aa1dcaa4f6f5ae08936491e08bd456f331f2d40 (2026-08-13)

The reproducer and .config files are here.
https://gist.github.com/shuangpengbai/6d12f2eba2f06179a20ffcafe69fcc59

I'm happy to test debug patches or provide additional information.

Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

[   68.640158][ T8381] BUG: KASAN: slab-use-after-free in firmware_map_add_hotplug (drivers/firmware/memmap.c:225 drivers/firmware/memmap.c:248 drivers/firmware/memmap.c:286)
[   68.640950][ T8381] Read of size 8 at addr ffff88811a4b0800 by task sh/8381
[   68.641868][ T8381]  dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
[   68.641873][ T8381]  print_report (mm/kasan/report.c:378 mm/kasan/report.c:482)
[   68.641886][ T8381]  kasan_report (mm/kasan/report.c:595)
[   68.641894][ T8381]  firmware_map_add_hotplug (drivers/firmware/memmap.c:225 drivers/firmware/memmap.c:248 drivers/firmware/memmap.c:286)
[   68.641903][ T8381]  add_memory_resource (mm/memory_hotplug.c:1571)
[   68.641933][ T8381]  __add_memory (mm/memory_hotplug.c:1611)
[   68.641936][ T8381]  probe_store (drivers/base/memory.c:582)
[   68.641949][ T8381]  kernfs_fop_write_iter (fs/kernfs/file.c:345)
[   68.641952][ T8381]  vfs_write (fs/read_write.c:595 fs/read_write.c:687)
[   68.641973][ T8381]  ksys_write (fs/read_write.c:739)
[   68.641986][ T8381]  do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
[   68.641991][ T8381]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)

[   68.669009][ T8381] Freed by task 8381 on cpu 0 at 68.618788s:
[   68.669579][ T8381]  kasan_save_track (mm/kasan/common.c:57 mm/kasan/common.c:78)
[   68.670025][ T8381]  kasan_save_free_info (mm/kasan/generic.c:584)
[   68.670507][ T8381]  __kasan_slab_free (mm/kasan/common.c:253 mm/kasan/common.c:285)
[   68.670960][ T8381]  kfree (include/linux/kasan.h:235 mm/slub.c:2677 mm/slub.c:6377 mm/slub.c:6692)
[   68.671337][ T8381]  kobject_put (lib/kobject.c:689 lib/kobject.c:720 include/linux/kref.h:65 lib/kobject.c:737)
[   68.671762][ T8381]  firmware_map_add_hotplug (drivers/firmware/memmap.c:192 drivers/firmware/memmap.c:306)
[   68.672289][ T8381]  add_memory_resource (mm/memory_hotplug.c:1571)
[   68.672772][ T8381]  __add_memory (mm/memory_hotplug.c:1611)
[   68.673186][ T8381]  probe_store (drivers/base/memory.c:582)
[   68.673595][ T8381]  kernfs_fop_write_iter (fs/kernfs/file.c:345)
[   68.674099][ T8381]  vfs_write (fs/read_write.c:595 fs/read_write.c:687)
[   68.674501][ T8381]  ksys_write (fs/read_write.c:739)
[   68.674902][ T8381]  do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
[   68.675335][ T8381]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)


Best,
Shuangpeng

