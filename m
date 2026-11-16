Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF2DA606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 01:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i1uJmYf9
Received: by kanga.kvack.org (Postfix)
	id 484736B00EF; Sun, 15 Nov 2026 20:38:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40E436B05B0; Sun, 15 Nov 2026 20:38:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B1466B05B1; Sun, 15 Nov 2026 20:38:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F095B6B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:38:43 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DE3D81A087B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 01:38:41 +0000 (UTC)
X-FDA: 85439272842.13.235E80C
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1999D40004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 01:38:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=i1uJmYf9;
	spf=pass (imf04.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794793120;
	b=4oq3FskeEgXKUpJ0/Xa/fKYwYYvMIEreNGE1qsuIoeqi6PxBc6AR5ZwTR9CV/6gjBwsgN5
	LpNPW2D2tZ801POGs+wRtbEd3m9IBgUKjJCIaXNatZIiPMo7jLC7Orq2iAzwzYf2mUYpvV
	GncIO/HMcXKDXnwHHiwO2309ffgt14g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=i1uJmYf9;
	spf=pass (imf04.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794793120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0YbBEF/i3LHD2RuXWt/9khib8KcPq1szk/F79X3/JjE=;
	b=6Drcif7mGKTDk6rMDheXI7VcXY0JaY5GSfqEGkBflQr37yc8j6hC4gVtlf8MT066uGkdGT
	OVWeiLgpNfS9oMcVSJppJojlE6vNcS86gk0ysu7ZnfXzu8T83SjrMNnqcuCK68xioYGly7
	oItCdGFRFxGWhUYMBDXFsh85SOu+9wU=
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-36e90071735so436198eec.0
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 17:38:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794793119; x=1795397919; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=0YbBEF/i3LHD2RuXWt/9khib8KcPq1szk/F79X3/JjE=;
        b=i1uJmYf9tC0FHpAfOwnyaj3QWAvUvzU3eySXWjSg611q8bwCPc9p3Y2myS9w45oYIN
         vbHuKp/NZJZZjpxl3iznFy2Jz4YW2zBf9U1OlVKuageMMEnzv4+9sxYc7bMvFs54Di8D
         TuJeWz6DWp8GeY5LzQndqXVhVTuyNN54wVpp2qw4voCNAV5rx8TVaLv+ZQAV0TZntK8t
         QjQZ6O94yYQlu0VjrbSxoAiFmyBCrWv1pp4YRRVHQxQ1unMkXXa7XGy7FtkJ0vlf8DKE
         O2bFLTLsJxXaiEDztt5K6cqFI75/n6xtxgkSSNXvK68TgtJ/Pqs5By1M8UPDHAAbJenQ
         TIRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794793119; x=1795397919;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=0YbBEF/i3LHD2RuXWt/9khib8KcPq1szk/F79X3/JjE=;
        b=EtBaqF55/w6R7sQ6BbyXsyWmefeAvvRp0acRCxG2ZwGDrXTc1LoksA1rfMqees3u2H
         RvLT/Wtr80BHaTrzVv1m3LaomMohEQCU4skRydN8A4LY0jjn6YT207qcFBq7ezD7/nit
         CY6TqDs54VCEL85uZ0dAVM1wip8s98jtcEkeWoIBEvCq7ADQbBW6KAvZ22v1bbOiPK95
         Ly7cCNgz8RYRGxeYLfoISQqfYusKqFg48OdWo+CIYfcbdsxP3/3OCVM7a1SOJc5pEwPa
         6KOggf6JnEFMAji7/lU3HGMwicbt/XY45X+4nrxY4e0yobCs0LKyp0i3DCzvVmxTa9Vo
         9O7w==
X-Gm-Message-State: APuU4Z+3ZtlU4ilUIcn8t6AbwH09sJWifV7z2ldn7wBdUrKbtRwCCbHK
	FnBXxY5I3PWmJaK57q7XUV+sCCUh+6+iUupPjHYO95tKH95Ezk4hZ3Ym
X-Gm-Gg: AYBFou3d47dxjYbdurZFqXHyjkFIif+fktuX3cBo/jtpCBuzGx1l1tK/YM9zda6TOSU
	3Km4VGtTBXjk4QRaEWMJ41TWo1uZayLD7ZHHy2vWfUU3MmICiJrdsx/ZzsDGxs7kFIkc77MackT
	uKUfxgspVUqW2Kf6/UEh0hyUTl8Qwint9S9TgXHGUkpB0wgqOqmTz7XXJWGl6uUrGloOrBTjLvV
	CI5igJFbHibL8AYqAxHnkaXpmQQmJPj3IZE6qxK6aT1BOsPen7Q+Rn1j4h2GV5UeJOJdj9rl0k2
	6CPtu0oZ40d8Ni6wvZ/3z6EGtQCICtlQACTasIx4wyPfcTbS6BGbiXQN24a6QyytZ+dAcTT9hh/
	44ySPQQMcPnuaGJgVhr7zJRi+aVdeNvzsIOnzVFQINie4VrHGeP2qjN9gE1Tmtp6GWxt2L/tkGo
	G+UW9qUfbZyPDcBBr10fsIlfwSE2f60Rl9/A5JutyhH1hdSU8MfBtprTMtX/s8R7wRFwA97ahW3
	9EFJaK0F/LNzPRkrASZzNw64emBx4mOsxKAugpLcUh4VZLdz0n6l5D23hegHg2q8CJNPyix9CCm
	sfV2XenD7jUa0H/jxTevDLzmJrhcfyT5rF1POLC1/fyBD3mFvo/f4UdyerQPAfmO1X0=
X-Received: by 2002:a05:7301:a0a:b0:375:f846:5b3f with SMTP id 5a478bee46e88-3796057e734mr12265396eec.0.1794793118399;
        Sun, 15 Nov 2026 17:38:38 -0800 (PST)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379560f5e06sm38324766eec.19.2026.11.15.17.38.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 17:38:37 -0800 (PST)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Date: Mon, 16 Nov 2026 09:38:21 +0800
Subject: [PATCH v4] mm/zsmalloc: remove CONFIG_ZSMALLOC_STAT
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261116-zsmalloc_stat-v4-1-fa9197a2e580@gmail.com>
X-B4-Tracking: v=1; b=H4sIAIxe+moC/3WOQWrDMBBFrxK07rQeRbaTrHqPUspIGscqtmUk1
 yQNvnulhIAxdPk/8978m4gcHEdx2t1E4NlF54cU1MtOmJaGM4OzKQtZyAqxqOA39tR13nzFiSb
 g1FplDcq6EokZAzfucvd9fD5y/NHfbKYsyReaIoMONJg2V1pBbt6eWrDBj5Dd+bh1cfLhel83Y
 5b+N2RGQNBlrRpVoyLbvJ97ct2r8b3IQ2a5po9bWkIBhpgVVgdFmrb0fkUjbul9+i3toWRbYlk
 XvKaXZfkDtBYCEGUBAAA=
X-Change-ID: 20261106-zsmalloc_stat-e261d4dc1276
To: Minchan Kim <minchan@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Alex Shi <alexs@kernel.org>, 
 Yanteng Si <si.yanteng@linux.dev>, Dongliang Mu <dzm91@hust.edu.cn>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Helen Koike <helen.fornazier@gmail.com>, 
 Vignesh Raman <vignesh.raman@collabora.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, Nhat Pham <nphamcs@gmail.com>, 
 Xueyuan Chen <xueyuan.chen21@gmail.com>
X-Mailer: b4 0.16.0
X-Stat-Signature: csnxz7h389q646esnn3r6azan6ef7uwg
X-Rspamd-Queue-Id: 1999D40004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794793119-724274
X-HE-Meta: U2FsdGVkX19l7fJNYk2aIeyqEj5LtGLCWgeMzuYIR0nqjFYkAeNh1DeTOdxwRPAsUWhrNFKEfeSwqfjrFbPN5cEECugxLrYPRi3a2O3OXyfJVFgHGsnqiI89JBptxZDnAEYnzZbr+XAT1nvhdV2RQifqAE+3D1YGPahDQtZxFoAXC/iMnpPaBuJ8+xb17O5X1h9vnsVNfKA1gxZSqj09I9eIdkO4cCOQrViIr8oX+ikHyXfEewiLtz1XevUVxiHSycm27sEnVUdDwyruVZwY8yWgsBRqOL21upcS9SoN7PfNexs71xf5Uba/JuPWGf4L40OVtfmEcieGqVJxNvVRlGC6BqtgYvoNsJ+a7QgnGeKDaU99cwhBhSrXQJBw2F895dJc1/NxMsdjpsnwP/I5uwYIbAX4j5xDEfd5/Jlf2bVKFeCYGUtjXiAvcGvcsu7MGShwWJMDinSANcg4SIqW52W3JxYKW87KkoVisDYpniFtOu0Rn+rleBE1qjpVU9uDuwMfxiIpTfWbsZ1UshhwWcdNzPPhhSmK8mG1KQmAbNvnIxLS4dBbvoUZWm4KjrwIKpsgRr+nlFYf57A+4iKkbPpQp4tAd5BflgNXcFq1wrxwdNklyU69SCLntWbc6fXZ/PqM1vBAUmOpiTP4UDHoua+VeoEPh+8s+gflTisIk13D5G4cgArS3NYh8BSk5SrKka+bAuEZLFiPGPABSf8VSlNK4RMnFWNnqDGzTBv667pFsSgv+RA1L5eTxOP0wnLgqD07YMIosBBD2lZ5WDPtRkD15VBwzVLWVGz1x15KU5OsbPm6zwC8/Tf+I/+D9y+zlsqs0xZsBBYkUpMRRSldTIJ+Sy5CwtrCElb+aRXd95Gi1JZmO40StDNtHR734SorMCsSX+H0TwmYH2NrCMwjHDAETGi+waDhGcy0aQS8OSpxfl1CfLlF4W4byT1R6tJ0r05mGXeWfhj7EodTWut
 rJRzgaR6
 Amx9u2wFCaGHdZkspCdcGaqlBaIWLa4AY14Oh9r+HEjUj/M2WHPQcwXvSPCnh7DK6EArec2CjMnBM5zKAv1aifqgWhNubeI8L41tbLWfG1ZlK4vplp6V81D2N/P0Gv5dr4vuoFsl2NtqFnmOdtyQrQEqyc8GHKHLGt5BXaOoW4UHW6dcNr9gioJjnsXbZprfATISZ8qOzbsq7o3Kxi7cIBkBOwts7bNjkLC995VGx6fSfAzKbblwUNIytdcbufTVHVOv5Q2Q3jiZUD9SMzmwlKZLQQObbUDclyQxVD+VsO2G0jUBuyUxRl0kpxX06qymD6GKiIaB1ltvycKvv/TVbfr8/VItVQp5AkEaIodjCW4xGQuVFu9Z2QweZiyhzAD2ftAeglBSY96APrLPu3R6YczSROlt+Yxp8unt0s1cMUU9c7vvBD6FGVUngUDcUpy9rUxC+4xj0lTAReDq6I+kufRNcUPOzKK10hC1PjWbxONH4yrVtdz3ZPGxl2cSGn85x1+Gv6z9fByOIAHBa8S2XcnPskbTyvDLio/0N3BoePjMVgAr92+g46WNQuWnJ1N3VsvwTHrt3UQMiGxxYhhZY/SD8y9GIM4BqqJa3Bnv4P7wJ4AhOYY3gPMwTPKanbxpPbrlv7aQNmnrhBKA96CXItKzUHy+guRmouhdKIvofLrnepx2x1qgkxk94ILrujtFoJYNl2NhkwDiRNq/bg+M1sgHfOMQwm3Z0WgBjKFXIBpdcgIPVRTXVqPwZsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

CONFIG_ZSMALLOC_STAT only controls the debugfs interface. The class
counters are updated regardless of this option.

Remove the CONFIG_ZSMALLOC_STAT guards and rely on the debugfs API
stubs when CONFIG_DEBUG_FS=n. Skip statistics setup silently when
debugfs is unavailable.

Remove the Kconfig entry and drop CONFIG_ZSMALLOC_STAT from both s390
defconfigs. Replace it with CONFIG_DEBUG_FS=y in the DRM CI configs.
Update the English and Chinese documentation to match and use
<pool-name> in the debugfs path.

Suggested-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Dongliang Mu <dzm91@hust.edu.cn> # Documentation
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
Changes in v4:
- Drop CONFIG_DEBUG_FS=y from the s390 defconfigs (Alexander).
- Add Reviewed-by and Acked-by tags.
- Link to v3: https://patch.msgid.link/20261111-zsmalloc_stat-v3-1-2d85ed51570e@gmail.com

Changes in v3:
- Squash the three patches into one (Nhat, Sergey).
- Add Nhat's Reviewed-by.
- Update the documentation wording.
- Link to v2: https://patch.msgid.link/20261109-zsmalloc_stat-v2-0-caee41684aba@gmail.com

Changes in v2:
- Drop CONFIG_ZSMALLOC_STAT instead of making the counters conditional.
- Update configuration files and documentation.
- Link to v1: https://patch.msgid.link/20261106-zsmalloc_stat-v1-1-b574f4714adf@gmail.com
---
 Documentation/mm/zsmalloc.rst                    |  4 +--
 Documentation/translations/zh_CN/mm/zsmalloc.rst |  2 +-
 arch/s390/configs/debug_defconfig                |  1 -
 arch/s390/configs/defconfig                      |  1 -
 drivers/gpu/drm/ci/arm.config                    |  2 +-
 drivers/gpu/drm/ci/arm64.config                  |  2 +-
 drivers/gpu/drm/ci/x86_64.config                 |  2 +-
 mm/Kconfig                                       |  9 -------
 mm/zsmalloc.c                                    | 33 ++----------------------
 9 files changed, 8 insertions(+), 48 deletions(-)

diff --git a/Documentation/mm/zsmalloc.rst b/Documentation/mm/zsmalloc.rst
index d2bbecd78e14..4c0786378dc3 100644
--- a/Documentation/mm/zsmalloc.rst
+++ b/Documentation/mm/zsmalloc.rst
@@ -33,8 +33,8 @@ proper handle-based APIs.
 stat
 ====
 
-With CONFIG_ZSMALLOC_STAT, we could see zsmalloc internal information via
-``/sys/kernel/debug/zsmalloc/<user name>``. Here is a sample of stat output::
+With CONFIG_DEBUG_FS, we could see zsmalloc internal information via
+``/sys/kernel/debug/zsmalloc/<pool-name>``. Here is a sample of stat output::
 
  # cat /sys/kernel/debug/zsmalloc/zram0/classes
 
diff --git a/Documentation/translations/zh_CN/mm/zsmalloc.rst b/Documentation/translations/zh_CN/mm/zsmalloc.rst
index 4c8c9b1006a9..b555a07ac871 100644
--- a/Documentation/translations/zh_CN/mm/zsmalloc.rst
+++ b/Documentation/translations/zh_CN/mm/zsmalloc.rst
@@ -32,7 +32,7 @@ zs_unmap_object()解除映射。
 stat
 ====
 
-通过CONFIG_ZSMALLOC_STAT，我们可以通过 ``/sys/kernel/debug/zsmalloc/<user name>``
+启用CONFIG_DEBUG_FS，我们可以通过 ``/sys/kernel/debug/zsmalloc/<pool-name>``
 看到zsmalloc内部信息。下面是一个统计输出的例子。::
 
  # cat /sys/kernel/debug/zsmalloc/zram0/classes
diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
index d44674b63715..2ae3bc11ef61 100644
--- a/arch/s390/configs/debug_defconfig
+++ b/arch/s390/configs/debug_defconfig
@@ -100,7 +100,6 @@ CONFIG_UNIXWARE_DISKLABEL=y
 CONFIG_IOSCHED_BFQ=y
 CONFIG_BINFMT_MISC=m
 CONFIG_ZSWAP=y
-CONFIG_ZSMALLOC_STAT=y
 CONFIG_SLAB_BUCKETS=y
 CONFIG_SLUB_STATS=y
 # CONFIG_COMPAT_BRK is not set
diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
index e00e252d4694..3458ec09f172 100644
--- a/arch/s390/configs/defconfig
+++ b/arch/s390/configs/defconfig
@@ -94,7 +94,6 @@ CONFIG_UNIXWARE_DISKLABEL=y
 CONFIG_IOSCHED_BFQ=y
 CONFIG_BINFMT_MISC=m
 CONFIG_ZSWAP=y
-CONFIG_ZSMALLOC_STAT=y
 CONFIG_SLAB_BUCKETS=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_MEMORY_HOTPLUG=y
diff --git a/drivers/gpu/drm/ci/arm.config b/drivers/gpu/drm/ci/arm.config
index d7c51670da2f..fc0a8a4bfb18 100644
--- a/drivers/gpu/drm/ci/arm.config
+++ b/drivers/gpu/drm/ci/arm.config
@@ -5,7 +5,7 @@ CONFIG_CRYPTO_ZSTD=y
 CONFIG_ZRAM_MEMORY_TRACKING=y
 CONFIG_ZRAM_WRITEBACK=y
 CONFIG_ZRAM=y
-CONFIG_ZSMALLOC_STAT=y
+CONFIG_DEBUG_FS=y
 
 # abootimg with a 'dummy' rootfs fails with root=/dev/nfs
 CONFIG_BLK_DEV_INITRD=n
diff --git a/drivers/gpu/drm/ci/arm64.config b/drivers/gpu/drm/ci/arm64.config
index c46125c1f80f..10b01b55a66d 100644
--- a/drivers/gpu/drm/ci/arm64.config
+++ b/drivers/gpu/drm/ci/arm64.config
@@ -5,7 +5,7 @@ CONFIG_CRYPTO_ZSTD=y
 CONFIG_ZRAM_MEMORY_TRACKING=y
 CONFIG_ZRAM_WRITEBACK=y
 CONFIG_ZRAM=y
-CONFIG_ZSMALLOC_STAT=y
+CONFIG_DEBUG_FS=y
 
 # abootimg with a 'dummy' rootfs fails with root=/dev/nfs
 CONFIG_BLK_DEV_INITRD=n
diff --git a/drivers/gpu/drm/ci/x86_64.config b/drivers/gpu/drm/ci/x86_64.config
index 7ac98a78691e..8225b806dad8 100644
--- a/drivers/gpu/drm/ci/x86_64.config
+++ b/drivers/gpu/drm/ci/x86_64.config
@@ -5,7 +5,7 @@ CONFIG_CRYPTO_ZSTD=y
 CONFIG_ZRAM_MEMORY_TRACKING=y
 CONFIG_ZRAM_WRITEBACK=y
 CONFIG_ZRAM=y
-CONFIG_ZSMALLOC_STAT=y
+CONFIG_DEBUG_FS=y
 
 CONFIG_PWM=y
 CONFIG_PM_DEVFREQ=y
diff --git a/mm/Kconfig b/mm/Kconfig
index afff1b25b543..4a77cda7f1d7 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -130,15 +130,6 @@ menu "Zsmalloc allocator options"
 
 comment "Zsmalloc is a common backend allocator for zswap & zram"
 
-config ZSMALLOC_STAT
-	bool "Export zsmalloc statistics"
-	select DEBUG_FS
-	help
-	  This option enables code in the zsmalloc to collect various
-	  statistics about what's happening in zsmalloc and exports that
-	  information to userspace via debugfs.
-	  If unsure, say N.
-
 config ZSMALLOC_CHAIN_SIZE
 	int "Maximum number of physical pages per-zspage"
 	default 8
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 7ef80e0da626..104ccf3aa170 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -222,9 +222,7 @@ struct zs_size_stat {
 	unsigned long objs[NR_CLASS_STAT_TYPES];
 };
 
-#ifdef CONFIG_ZSMALLOC_STAT
 static struct dentry *zs_stat_root;
-#endif
 
 static size_t huge_class_size;
 
@@ -279,9 +277,7 @@ struct zs_pool {
 	/* Compact classes */
 	struct shrinker *shrinker;
 
-#ifdef CONFIG_ZSMALLOC_STAT
 	struct dentry *stat_dentry;
-#endif
 #ifdef CONFIG_COMPACTION
 	struct work_struct free_work;
 #endif
@@ -565,14 +561,10 @@ static inline unsigned long class_stat_read(struct size_class *class, int type)
 	return class->stats.objs[type];
 }
 
-#ifdef CONFIG_ZSMALLOC_STAT
-
 static void __init zs_stat_init(void)
 {
-	if (!debugfs_initialized()) {
-		pr_warn("debugfs not available, stat dir not created\n");
+	if (!debugfs_initialized())
 		return;
-	}
 
 	zs_stat_root = debugfs_create_dir("zsmalloc", NULL);
 }
@@ -650,10 +642,8 @@ DEFINE_SHOW_ATTRIBUTE(zs_stats_size);
 
 static void zs_pool_stat_create(struct zs_pool *pool, const char *name)
 {
-	if (!zs_stat_root) {
-		pr_warn("no root stat dir, not creating <%s> stat dir\n", name);
+	if (IS_ERR_OR_NULL(zs_stat_root))
 		return;
-	}
 
 	pool->stat_dentry = debugfs_create_dir(name, zs_stat_root);
 
@@ -666,25 +656,6 @@ static void zs_pool_stat_destroy(struct zs_pool *pool)
 	debugfs_remove_recursive(pool->stat_dentry);
 }
 
-#else /* CONFIG_ZSMALLOC_STAT */
-static void __init zs_stat_init(void)
-{
-}
-
-static void __exit zs_stat_exit(void)
-{
-}
-
-static inline void zs_pool_stat_create(struct zs_pool *pool, const char *name)
-{
-}
-
-static inline void zs_pool_stat_destroy(struct zs_pool *pool)
-{
-}
-#endif
-
-
 /*
  * For each size class, zspages are divided into different groups
  * depending on their usage ratio. This function returns fullness

---
base-commit: fa4ad798f6f681031775266044ba1b0cf3c670bd

--  
Best regards,
Xueyuan


