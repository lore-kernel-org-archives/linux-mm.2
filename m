Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4E6CE66886
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 00:49:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27D8F6B008A; Sun, 21 Dec 2025 19:49:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 254786B008C; Sun, 21 Dec 2025 19:49:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17DDE6B0092; Sun, 21 Dec 2025 19:49:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06C9E6B008A
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 19:49:28 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 96218137DCA
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 00:49:27 +0000 (UTC)
X-FDA: 84245273574.18.26AAF8D
Received: from mail-pj1-f65.google.com (mail-pj1-f65.google.com [209.85.216.65])
	by imf07.hostedemail.com (Postfix) with ESMTP id D5BB640009
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 00:49:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RnOBvunA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.216.65 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766364565; a=rsa-sha256;
	cv=none;
	b=BhUCG9s5lhGPNC8KykbSAZuPyCcwxau0gvZOJ099ZpDxD4Y4EkvI8DD++k1AcFFitXQvHN
	acvQWnUuai7DamxGCrrhE3BCL5v2edfDNH5zcB7y4KK9QJ3WSMHZHojO5lTDyqvI4h7BpU
	G5jr5uiJtQz387B1KdMujh7OxPGty+Y=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RnOBvunA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.216.65 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766364565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a10/yyFUtLAmkdxBH2DQmudL6S0po5mlrbiaBGfSCN0=;
	b=SqtF06xnUnpEXkfwKr65YusPb/Ely+p9mSu7hEgQ7M9zFrVCKLyZxkjcpOXyGHhCReHW2I
	+oWY29xJm7nW/MwLe1Gv2ayb56BAN+TEaEFUx2phHTY64ObxPkHDkP3G1rd9Wq91JWwlW+
	yAp4NVfSxqLJfgYha/JbjdsrHt4V9RU=
Received: by mail-pj1-f65.google.com with SMTP id 98e67ed59e1d1-34ccdcbe520so1783515a91.1
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 16:49:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766364565; x=1766969365; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a10/yyFUtLAmkdxBH2DQmudL6S0po5mlrbiaBGfSCN0=;
        b=RnOBvunAnh+s2BcAlOBRzZBsb2aJiM0yu30vqNi/vjVSXFlLThMMLt4Tu4xO4ybIZ+
         dbNSpr6C/AIFeooOgAfWvZdC4HpgZGsLFFDAVdpYcvS8nFGoWQXLxn4YTZXhvoy3yMXx
         NvHk/uinCClrfhPLa4Wno6HS6ZXoMJaQlgozSwqlzeeCJ2Ttsz3J+fNdnM+bGAnOyZMW
         IyhEFAf24/u49kUQchSSXOE/jbHhFqvjswPhAWTFUYl1qVDqlW5tRxUz+KoQ3P90QHRq
         baeT9dDQIrrVXHJPJtlWf9h2vZFpCvYTW28eE3phS1+axRq1c0A9h6EPU2eLUPvkmtMB
         M+nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766364565; x=1766969365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=a10/yyFUtLAmkdxBH2DQmudL6S0po5mlrbiaBGfSCN0=;
        b=Cuj5Ue41zf6aCQHxSBakpODt/PPM4rD57xdn9gDCCdB47FbJZgxOHUbd6kkEAjvgbg
         1IEHiSkLy6gxiNP/5Ug8BWcRu5IycR5dVjBsIjovLk0kQtjlXuNhbNJSTKrcOvstvI5X
         ++uJb/nRUTLDBGv0WQdKLr8W7z1s16Sa1S0PvyT3i6KX0B9a/rL5W0OtcpW6BNQeyv1F
         UcC2XAgiHQiM/1R8FoxM1BFVDAVcwkkbkFknagkg1XChhI/0jJgfr2tSyi4CdtiB8MpY
         dGyYgIGYZ/h37o+ayE7qm3QBUkb6tshc77ATP0X0L0CpVIvZt9OkkqZqyAcb3e/B4ov9
         KWUA==
X-Forwarded-Encrypted: i=1; AJvYcCVqwjSf8fNGfjgXKNxxjiab2pguylNKvG5lBIBNd66DFRYWHIgS2Z3cgvQtiZ8BkLXrMN0i3Ddacg==@kvack.org
X-Gm-Message-State: AOJu0Yxo5kHhv2lyXxDMSFdnfV3E/H+4UBR/oYFBqjHevFSnSb7/JvYz
	cikHT8KfGTfMYHIFN+VOtezlrcN/10H8bEiBOtctPChKxIBSYZfVlfmI
X-Gm-Gg: AY/fxX7woT0FdMAheNbTOPKDGAHB870HwbouuJeqS2do7/BRHwwnZ/1dqhybL6O8oOO
	4qAWhjuwPWfyh7GI17GxTFUojYkdGdrvoo2nI10TULMqIeeSi6+q98Y0zUi5n7DOJD0nJ0s43as
	dzNTA4dM3qIYShbZJGDAWjz+VrpLPD+Ku9Fnee5umo+YtezmIpfAyQO/aEiQ+6xzTS6zfL+v4em
	ua6OebQrgnR9ljAftMsII5MUE7G81JCfaPJpSoaQBOnAhiE42JbbBXxyokEl4x8SFrfMqNf3Kz/
	8MHTDW5mkaL/jqpYXPNeGtG0+9fumyyZM7C9VncgIfxMa1Ems7vnAD47yPfyajpbCK+ar5VZkqn
	UkSm/8eeiBM6Ft/8PTIXPG+RnKK15BmNh8eI/WvldNvxkIQnagHTymdrhH8DWR34t9I16RMAHpB
	/S7HpAePStPvkuqtCRE0RoCym1pA==
X-Google-Smtp-Source: AGHT+IEMm5PsORF6eBK+myRm0k9fs0suEo4RqzGxdu08t8Dj4rsOQM/w7YKy0ZJXO7xvr+1j5f+i6g==
X-Received: by 2002:a17:90b:1fc8:b0:32e:2fa7:fe6b with SMTP id 98e67ed59e1d1-34e90de1f19mr9151046a91.14.1766364564695;
        Sun, 21 Dec 2025 16:49:24 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:df7d:b611:ffaf:6d45])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e79620bd3sm7461832a12.4.2025.12.21.16.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Dec 2025 16:49:24 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: akinobu.mita@gmail.com
Cc: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com
Subject: [PATCH v2 2/3] mm: numa_emu: add document for NUMA emulation
Date: Mon, 22 Dec 2025 09:48:33 +0900
Message-ID: <20251222004834.10539-3-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251222004834.10539-1-akinobu.mita@gmail.com>
References: <20251222004834.10539-1-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D5BB640009
X-Stat-Signature: wsttkxx5m4cyitch5op9ry71w3ap5oe5
X-Rspam-User: 
X-HE-Tag: 1766364565-718718
X-HE-Meta: U2FsdGVkX1/a2EjyooGgbhjSOclj5YpH0mDbPrc1ezPaHVj4yyPQb8GBdLB73uTMgNHrqAY/9D9lV5K5gb6MABTwrMUDqVlTHLbdUfRI2mugqC1t0p4TKMq46wuVx3qlVgZG2cZ8rwPhQFKn0b/xZoWCVeTfM0fvlrWVbo1kyORY2UXaiyNyEJO8JV4dINk/bSMHiCwweyZ4D688oKGc9cscBah7U8khlWdd/58gZmaeK4igetSXZ0ek+QPKNp9U/uJF0161tP1/1J5M8wYbLJbez2qkuDG2gfT7G47IZT7esuOl8APuf48VspiIU47nW4ovtTlHZSpQ5Dia9OCsA0sbIaXg7Oo4Hk0g5ymHNxyy8oUA7pfyItdcwpMclmY7tJGoyFbDYYI/AlKLFg5S9gIo6dPzYPQ/zALJwqIpczkR7vXS94G9tsiObMlOneofyYrUHzUbODV6Pk/NEMexGfSgkaQjycx6npWJ9R+QrQyRTNBe7lDmLYaTouolqTjD0CuFl090zt3IDc4lsjmuSGc5dSzR1SQXK64xwb6vc6FMbzrGG2j6d4qG5ciyTZqYWDFKGu8P2+zDlRm7XbPjkJMLkar1gj9A2tlXTH3LaUCEBErV0ILUR8tbeBC02dvbyfvmib+A2ak2ycEbJ/TcQGpDm5hbjmEPsYInk/8wih+Td1G8A+/U+mXEUZYKG/o7bNyo8seslm2UOcTXORWEyvpQ6gGVXqVMl1cEocaqI45RijGRPpWStv1KCrUr4zzuuRZE3bg2JXqddixILQw+ql/G1/KoLM3jUhooUKMFihY7Hb9gCqWdTt8J0ZARAY4SsFtQNHeEhtKXivHFaeuGq55zSRQMXWzM3BHv/0BxFx3ZIG/hSjtr5k1zz0nJaETXyf7+PR3ZlT/4nymqhuvCVCe9yO25/cEj+YcpewNGFYvgV6YzR4HM0C38joyluPp2NMKSA2lcOnnSrv7R1lB
 6wkxp15d
 rYTM5NwSs0IGDvFJ/45zNmLMeJv9anpDHB+lT7W3ECjs4yTnWjXAKxTiU4ZjVmFx35G8KVUtosn656mjTX8CnrkbHJf4QlPCXPM+8ACSp01vWmEn2HYlljwHybOkx8KCSl+FifyClKe12suFgR+AEZm5hhMuV/zIGZ07CB0AUxI/QfRO/o6I2nM4fRDbRC58DVStIaXgWJgqj5bV1+IBvCAnIc9ERAjFBFcxluAgmuJaP2xdkbzUkpNgw7jtI2Rf9XJ31Tfd6vTLluEJ7RdeCAOScX8qf0aarrP+un8XlhLU2Tuo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a document with a brief explanation of numa emulation and how to use
the newly added "numa_emulation.adistance=" kernel cmdline parameter.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
New in v2

 Documentation/mm/index.rst          |  1 +
 Documentation/mm/numa_emulation.rst | 30 +++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)
 create mode 100644 Documentation/mm/numa_emulation.rst

diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
index 7aa2a8886908..7d628edd6a17 100644
--- a/Documentation/mm/index.rst
+++ b/Documentation/mm/index.rst
@@ -24,6 +24,7 @@ see the :doc:`admin guide <../admin-guide/mm/index>`.
    page_cache
    shmfs
    oom
+   numa_emulation
 
 Unsorted Documentation
 ======================
diff --git a/Documentation/mm/numa_emulation.rst b/Documentation/mm/numa_emulation.rst
new file mode 100644
index 000000000000..dce9f607c031
--- /dev/null
+++ b/Documentation/mm/numa_emulation.rst
@@ -0,0 +1,30 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==============
+NUMA emulation
+==============
+
+If CONFIG_NUMA_EMU is enabled, you can create fake NUMA nodes with
+``numa=fake=`` kernel cmdline option.
+See Documentation/admin-guide/kernel-parameters.txt and
+Documentation/arch/x86/x86_64/fake-numa-for-cpusets.rst for more information.
+
+
+Multiple Memory Tiers Creation
+==============================
+
+The "numa_emulation.adistance=" kernel cmdline option allows you to set
+the abstract distance for each NUMA node.
+
+For example, you can create two fake nodes, each in a different memory
+tier by booting with "numa=fake=2 numa_emulation.adistance=576,704".
+Here, the abstract distances of node0 and node1 are set to 576 and 706,
+respectively.
+
+Each memory tier covers an abstract distance chunk size of 128. Thus,
+nodes with abstract distances between 512 and 639 are classified into the
+same memory tier, and nodes with abstract distances between 640 and 767
+are classified into the next slower memory tier.
+
+The abstract distance of fake nodes not specified in the parameter will
+be the default DRAM abstract distance of 576.
-- 
2.43.0


