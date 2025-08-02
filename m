Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E16EEC87FD2
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 10:16:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FEE46B007B; Sat,  2 Aug 2025 06:16:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AFBF6B0089; Sat,  2 Aug 2025 06:16:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2FAA6B008A; Sat,  2 Aug 2025 06:16:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DCBAF6B007B
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 06:16:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AEEC1BAB6D
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 10:16:06 +0000 (UTC)
X-FDA: 83731411932.01.FCC36A4
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9F3DC20005
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 10:16:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=GMOxB8Ul;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf03.hostedemail.com: domain of naresh.kamboju@linaro.org designates 209.85.214.176 as permitted sender) smtp.mailfrom=naresh.kamboju@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754129764; a=rsa-sha256;
	cv=none;
	b=6Qd1AjC47WU5g1TPjs1ArDXfHBnHlMg9EWUL3q45RvmapyNVFDiOavJH6I8pRxd4isEVlT
	CNpp1CI4B7DaMQdHtubg7RYxQAhHFYh2PK9AHgDVsa5XDjTmKvbvE7nb0abhEa2ctgJhpY
	BH56C0Ww/ZmHH2kar6Gsq/Li9nHa2hU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=GMOxB8Ul;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf03.hostedemail.com: domain of naresh.kamboju@linaro.org designates 209.85.214.176 as permitted sender) smtp.mailfrom=naresh.kamboju@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754129764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=A1S8mfF4yYCy8B4bXgYdauCpYCVAjJ9auaBJ+UVNv+0=;
	b=2QRIMb0rT9XxTdt+arZ0Ns6u1z2HsxQwmc85TCgzicQojxK88Saj05j48QSzGJLoc/IcdV
	juo/EIYnE7VsI11CeHE9lZkCeLnXxLoEN2Rzd/xHpqcIJUwkX7fe7kzCgmk3n/Tn+lnQni
	bYkJkuypgkDtog7XwI5Tgd5OKHOU+uY=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-23fe9a5e5e8so12427395ad.0
        for <linux-mm@kvack.org>; Sat, 02 Aug 2025 03:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754129763; x=1754734563; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=A1S8mfF4yYCy8B4bXgYdauCpYCVAjJ9auaBJ+UVNv+0=;
        b=GMOxB8Ulvxefz0OKNLLF0RoXJ+kxYkxKfDmuh0AlV9OH3mTvq5Gh0QXY4BGQV0ylIn
         ymqCbv+p8mSlyejJIqzB4IE9EBxCKfAOcdRGHZxrmJfC40vqdGbGjEhR0OiO6ifulmOZ
         m0F4P2JIziqCOYlOHqOXNgKAA/dVpDmh6FUdwqkq4w2i/nyi/+4L4iR+IrcD8+J7tByI
         Wjc3bNsrWxnJvZFnWrmeBU5cg++0MNqbr/APufY6tsh9rYf0PFK3jHC5GJY7STflcP8C
         fbGFbzxdO8NrtUn5IxmLDovlhgcOCS6H4VYNLxYdB3Di182meLHb9bA6ePNmtteFknnI
         Z4RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754129763; x=1754734563;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A1S8mfF4yYCy8B4bXgYdauCpYCVAjJ9auaBJ+UVNv+0=;
        b=q0efdVqVLrJ+1rqXPws7gIKRHyYP2he0DNlii1wkTnihY3IutOREtP8AnxC+T/r7xg
         GwTZmTRxQNbZ9vsd0V3Cf4XKde97fwzUXboNVKzuwsBRZLexhgAGelloTttdoUvivA4m
         cz8ncsLKe9h6XVP3JBQpkuzRyivdQDRLZyI/N/AwuvROP7gfr4XcQ8tnAVpbDdj6fhxe
         mU6bZlJWIhH3ux+4Bnd4WqDaT1czgh4G05r5OWVc2SiSW/tORFt9qhteWvsppqJ7oiBl
         5odiSAY2iDp6bGipsoOa5Nnn91e8zM64TDLH3k2Um2CIGQJrOFtOaxLW8twkALTQOCjY
         zhFQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQI7GZF6Yle2tsQFt3jYNYRZjBLZ/UFqwpH998iH2K8MexcajRpTzd3XKAf8ACrmM5T5CB/hQtbA==@kvack.org
X-Gm-Message-State: AOJu0Yx1Rts0Ze7rNvmRXKpHn3XCChGCAY78log7ZCs7YJFXnkQxKMS2
	RGLSpJyz5Kd1xmX67uzc03x8ssGZ4VqKyqqJCaGOa8LXL9vTX/JNm6ge0T/+GEQh+7jaIkS99xL
	XgWCS0Mkf4cyhte5k702tPWGO/SBlPbbUIyXXT9d0VA==
X-Gm-Gg: ASbGncsvxnYei7s+p21Xf8mrcO+FKuyzTa2nAN9udwizdDorC+3XT6sAsDFsLlDTEVK
	H+pOePXe6sEhNl4d95Fe3O0txcX8P6YFfkRIlHXaUuXEKXzE8OwYgZFx1zkMUX99my4729oMN+I
	2ntXWE9sq1wvWvURgg+wR8J7R/Lgb1DwUuFvRVpG+dYPQiBoeA4oreyGlJJlwqqHLXwHsISgiwP
	BJOr82G
X-Google-Smtp-Source: AGHT+IF5DdVFCKng2f5KqZFnrae99+X5k+Qmt2j+m7XSzt/2UvT45SCww97ZXS2/SMN5PQsRNiQICu4c2ULMe/0+YEk=
X-Received: by 2002:a17:902:c40b:b0:240:49e8:1d38 with SMTP id
 d9443c01a7336-2424703f6b1mr38407935ad.35.1754129763175; Sat, 02 Aug 2025
 03:16:03 -0700 (PDT)
MIME-Version: 1.0
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 2 Aug 2025 15:45:51 +0530
X-Gm-Features: Ac12FXw5_ZolpvO5uI042bQDw80SWA9aZEkdOVC4W_T6xjrKpa2_HnxdtLqpkgM
Message-ID: <CA+G9fYumD2MGjECCv0wx2V_96_FKNtFQpT63qVNrrCmomoPYVQ@mail.gmail.com>
Subject: next-20250729: PREEMPT_RT: rock Pi 4b Internal error Oops
 kmem_cache_alloc_bulk_noprof - kernel locking rtmutex.c at __rt_mutex_slowlock_locked
To: Linux ARM <linux-arm-kernel@lists.infradead.org>, linux-mm <linux-mm@kvack.org>, 
	open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org, 
	Linux Regressions <regressions@lists.linux.dev>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Anders Roxell <anders.roxell@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Vlastimil Babka <vbabka@suse.cz>, "Paul E. McKenney" <paulmck@kernel.org>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Ben Copeland <benjamin.copeland@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: bhbutfink73q6gkde8c9t3u1qfjnxmms
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F3DC20005
X-Rspamd-Server: rspam02
X-HE-Tag: 1754129764-774278
X-HE-Meta: U2FsdGVkX1+DjtiVDxconJ5HdHvHzjsvNn4RYaOSvR5MFCAX/H0JIpFYl9IYcNpNuibVaaSifGCB+BjhtEsVx9TG2X6N8wXPjsGKImQsiKdR8O8FhD+7T+DpPnE6Wt7lVzPtudfGWqEA+Pu33IDhP+zpXfk3UQ6Z3m1FjxtJJTWGsEYemo/m1ojz4xxZdlSvUlhh9pZcCXtXY0OkCl6PoB0TkaLiVo06ZSYLMELBkm9WBdKe7CTzLeICZ1P7PqQ60Xj0uTqr7115OypU+k/ufRJjCRTTbEDd1YqO01YC5PHO33KRaQKD0hr1jW3ukU4FKwTFSPpt01iV82VSMu4BRpjxmcglQeJ4cQ6MJopCtgagHgQOXmXC8aW8xAJG5m+jeIbcZnBXtbZzLpAK5FRIF1q3pk6xF8HWsLbfbjBPTC54suUXLhlb/zasSuEc885fD92j59Q70DVNjRGC2sFFQJ3gWdGo2WssZArjweNFfvyBdXnDdxA9Otfxj8r6iaRfV/BlQVr2DxA2y9yoMGpAVePxutLmJENJiHX1HB41wepDJd/gowIhDYrgKN41WXt6BKt+oYNwkR078qp29YTMZWmsucNG63eeuJEID+KAcCojKf/VnSX4YBscrEBrozuZScq6dqVKp9Ie76ndDt/ZzmBu2FZhks00VraWohNDxF9FSGSZEl3xviGmdA3/NdcRcJlOAr/mbIeEmYjS9vfMVRYorP0xPLQtGGLiJPkvFFOIMzvcB6xxTbRI3QhXYt+/LLZlPyNvUZBhEGdRAt/BiO4m6L2gQEjfEOoarRgLMZ1UM9F6vFTvZpA3P0j19nkOYZpcyCEwQS+R0jif5O+Hu5Md+NkjV5tcB7uaXWBtIaitvy6Ir3MLrXIbt2MqARqOp2xRUoUR/+76yfbGM92crJounxWsiEel7/Yx5ZRjbr9bcfTL7XhtPyZ1MvQK5Zo1WGbbw9ClT933X7zC4Qr
 s3+/jwLL
 FBBUyIyxZHV4hPJY9Bb8WwsnRjuU/Us+n3Zu2rTSKpoz7dpLB9iUpHj/sP3LhXk6fxxK9i1fo1Xg72Va1sCE6iNaH3m1zBOl9FSbVHQyrb4qW89DPW6RtQCTJi/vauibSWpkEfo61y607G5oXYVF3Er0OpQlM7NHpnTzLVOxVYactU4e3ttyls3AP7MPicRzqJZW9BnBmpFMMvLNPThvzl/ehEhj9Fs+f6UcDL0sCyMO4tiKZmL4iO7Do4PblgfkPDaNrw4UAm7/8Euo56d0+yIqHkVswsl+uqI6SHy3lNxSk5ddkkvNLOVHvx+wPmvn6LJFosckAqO7S/Sj+mWl0rJdTBdn7NqX1KM0mxV/IUQX9EbcpIWuWfu3GTDgbt2dbJpybw6aMB72LTetK2a+dQNSJ/i2+U1/pcqX/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Regressions found while validating Linux next on the Radxa Rock Pi 4B
platform, we observed kernel crashes and deadlock warnings when running LTP
syscall and controller tests under specific PREEMPT_RT configurations.
These issues appear to be regressions introduced in next-20250729.

* CONFIG_EXPERT=y
* CONFIG_PREEMPT_RT=y
* CONFIG_LAZY_PREEMPT=y

Regression Analysis:
- New regression? Yes
- Reproducibility? Intermittent

First seen on the next-20250729
Good: next-20250728
Bad: next-20250729 and next-20250801

Test regression: next-20250729 rock Pi 4b Internal error Oops
kmem_cache_alloc_bulk_noprof
Test regression: next-20250729 rock Pi 4b WARNING kernel locking
rtmutex.c at __rt_mutex_slowlock_locked
Test regression: next-20250729 rock Pi 4b WARNING kernel rcu
tree_plugin.h at rcu_note_context_switch

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Test log
[  527.570253] Unable to handle kernel paging request at virtual
address 003f0020f94020a1
[  527.570274] Mem abort info:
[  527.570277]   ESR = 0x0000000096000004
[  527.570282]   EC = 0x25: DABT (current EL), IL = 32 bits
[  527.570288]   SET = 0, FnV = 0
[  527.570292]   EA = 0, S1PTW = 0
[  527.570297]   FSC = 0x04: level 0 translation fault
[  527.570302] Data abort info:
[  527.570305]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
[  527.570310]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[  527.570316]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[  527.570322] [003f0020f94020a1] address between user and kernel address ranges
[  527.570330] Internal error: Oops: 0000000096000004 [#1]  SMP
[  527.570336] Modules linked in: brcmfmac rockchip_dfi brcmutil
cfg80211 snd_soc_hdmi_codec dw_hdmi_i2s_audio dw_hdmi_cec
snd_soc_simple_card snd_soc_audio_graph_card hci_uart
snd_soc_rockchip_i2s snd_soc_es8316 snd_soc_spdif_tx
snd_soc_simple_card_utils btqca rtc_rk808 rockchipdrm btbcm
snd_soc_core dw_hdmi_qp bluetooth snd_compress reset_gpio analogix_dp
snd_pcm_dmaengine panfrost hantro_vpu dw_mipi_dsi rfkill rockchip_rga
drm_shmem_helper drm_dp_aux_bus snd_pcm gpu_sched dw_hdmi pwrseq_core
videobuf2_dma_sg v4l2_vp9 snd_timer drm_display_helper v4l2_h264
v4l2_jpeg phy_rockchip_pcie snd v4l2_mem2mem cec videobuf2_dma_contig
soundcore videobuf2_memops drm_client_lib videobuf2_v4l2
drm_dma_helper videobuf2_common rockchip_saradc drm_kms_helper
industrialio_triggered_buffer kfifo_buf rockchip_thermal
pcie_rockchip_host coresight_cpu_debug fuse drm backlight
[  527.570493] CPU: 3 UID: 0 PID: 34254 Comm: mkdir Not tainted
6.16.0-next-20250801 #1 PREEMPT_RT
[  527.570502] Hardware name: Radxa ROCK Pi 4B (DT)
[  527.570506] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  527.570512] pc : kmem_cache_alloc_bulk_noprof (mm/slub.c:5343
(discriminator 1) mm/slub.c:5403 (discriminator 1))
[  527.570527] lr : kmem_cache_alloc_bulk_noprof
(include/linux/atomic/atomic-arch-fallback.h:457
include/linux/atomic/atomic-instrumented.h:33
include/linux/kfence.h:127 mm/slub.c:5307 mm/slub.c:5403)
[  527.570533] sp : ffff80008e24b8f0
[  527.570536] x29: ffff80008e24b930 x28: 00ff000000584610 x27: ffff800082b30538
[  527.570545] x26: ffff8000816b64dc x25: 0000000000000cc0 x24: 0000000000000000
[  527.570554] x23: 0000000000000004 x22: ffff0000f7579d20 x21: 0000000000000001
[  527.570563] x20: 0000000000000001 x19: ffff000000405b00 x18: ffff80008e24bcd0
[  527.570572] x17: 0000000000000000 x16: ffff800081e18420 x15: 0000ffffa2670fff
[  527.570582] x14: 0000000000000000 x13: 1fffe000017942e1 x12: 0000ffffa2470fff
[  527.570591] x11: ffff00000bca1708 x10: 0000000000000001 x9 : ffff8000816e41a4
[  527.570600] x8 : ffff80008e24b850 x7 : fefefefefefefefe x6 : ffff800082b30000
[  527.570608] x5 : d63f0020f9402021 x4 : ffff0000f7579d58 x3 : 0000000000000000
[  527.570617] x2 : 0000000000000000 x1 : 0000000000000100 x0 : 0000000000000080
[  527.570627] Call trace:
[  527.570631] kmem_cache_alloc_bulk_noprof (mm/slub.c:5343
(discriminator 1) mm/slub.c:5403 (discriminator 1)) (P)
[  527.570639] mas_alloc_nodes (lib/maple_tree.c:1278)
[  527.570651] mas_node_count_gfp (lib/maple_tree.c:1339)
[  527.570661] mas_preallocate (lib/maple_tree.c:5538 (discriminator 1))
[  527.570667] __split_vma (mm/vma.c:528 (discriminator 1))
[  527.570677] vma_modify (mm/vma.c:1633)
[  527.570685] vma_modify_flags (mm/vma.c:1650)
[  527.570694] mprotect_fixup (mm/mprotect.c:819)
[  527.570704] do_mprotect_pkey (mm/mprotect.c:993)
[  527.570713] __arm64_sys_mprotect (mm/mprotect.c:1011)
[  527.570722] invoke_syscall (arch/arm64/include/asm/current.h:19
arch/arm64/kernel/syscall.c:54)
[  527.570731] el0_svc_common.constprop.0
(include/linux/thread_info.h:135 (discriminator 2)
arch/arm64/kernel/syscall.c:140 (discriminator 2))
[  527.570737] do_el0_svc (arch/arm64/kernel/syscall.c:152)
[  527.570744] el0_svc (arch/arm64/include/asm/irqflags.h:82
(discriminator 1) arch/arm64/include/asm/irqflags.h:123 (discriminator
1) arch/arm64/include/asm/irqflags.h:136 (discriminator 1)
arch/arm64/kernel/entry-common.c:169 (discriminator 1)
arch/arm64/kernel/entry-common.c:182 (discriminator 1)
arch/arm64/kernel/entry-common.c:880 (discriminator 1))
[  527.570752] el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:899)
[  527.570760] el0t_64_sync (arch/arm64/kernel/entry.S:596)
[ 527.570772] Code: 1400000c f94002c5 b4000aa5 b9402a60 (f86068a0)
All code
========
   0: 1400000c b 0x30
   4: f94002c5 ldr x5, [x22]
   8: b4000aa5 cbz x5, 0x15c
   c: b9402a60 ldr w0, [x19, #40]
  10:* f86068a0 ldr x0, [x5, x0] <-- trapping instruction

Code starting with the faulting instruction
===========================================
   0: f86068a0 ldr x0, [x5, x0]
[  527.570778] ---[ end trace 0000000000000000 ]---
[  527.570800] ------------[ cut here ]------------
[  527.570803] rtmutex deadlock detected
[  527.570827] WARNING: kernel/locking/rtmutex.c:1674 at
__rt_mutex_slowlock_locked.constprop.0+0x800/0x8e0, CPU#3: mkdir/34254
[  527.570841] Modules linked in: brcmfmac rockchip_dfi brcmutil
cfg80211 snd_soc_hdmi_codec dw_hdmi_i2s_audio dw_hdmi_cec
snd_soc_simple_card snd_soc_audio_graph_card hci_uart
snd_soc_rockchip_i2s snd_soc_es8316 snd_soc_spdif_tx
snd_soc_simple_card_utils btqca rtc_rk808 rockchipdrm btbcm
snd_soc_core dw_hdmi_qp bluetooth snd_compress reset_gpio analogix_dp
snd_pcm_dmaengine panfrost hantro_vpu dw_mipi_dsi rfkill rockchip_rga
drm_shmem_helper drm_dp_aux_bus snd_pcm gpu_sched dw_hdmi pwrseq_core
videobuf2_dma_sg v4l2_vp9 snd_timer drm_display_helper v4l2_h264
v4l2_jpeg phy_rockchip_pcie snd v4l2_mem2mem cec videobuf2_dma_contig
soundcore videobuf2_memops drm_client_lib videobuf2_v4l2
drm_dma_helper videobuf2_common rockchip_saradc drm_kms_helper
industrialio_triggered_buffer kfifo_buf rockchip_thermal
pcie_rockchip_host coresight_cpu_debug fuse drm backlight
[  527.570965] CPU: 3 UID: 0 PID: 34254 Comm: mkdir Tainted: G      D
           6.16.0-next-20250801 #1 PREEMPT_RT
[  527.570973] Tainted: [D]=DIE
[  527.570976] Hardware name: Radxa ROCK Pi 4B (DT)
[  527.570979] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  527.570985] pc : __rt_mutex_slowlock_locked.constprop.0
(kernel/locking/rtmutex.c:1674 (discriminator 1)
kernel/locking/rtmutex.c:1734 (discriminator 1)
kernel/locking/rtmutex.c:1760 (discriminator 1))
[  527.570993] lr : __rt_mutex_slowlock_locked.constprop.0
(kernel/locking/rtmutex.c:1674 (discriminator 1)
kernel/locking/rtmutex.c:1734 (discriminator 1)
kernel/locking/rtmutex.c:1760 (discriminator 1))
[  527.571001] sp : ffff80008e24b2e0
[  527.571004] x29: ffff80008e24b370 x28: ffff000007c1a600 x27: ffff000007c1a601
[  527.571013] x26: ffff80008e24b318 x25: ffff000007c1a600 x24: 00000000ffffffdd
[  527.571023] x23: 00000000ffffffdd x22: 0000000000000001 x21: ffff000007c1a601
[  527.571032] x20: ffff80008e24b2f0 x19: ffff00001d756e30 x18: 0000000000000000
[  527.571041] x17: 65676e6172207373 x16: 6572646461206c65 x15: 0000000000000000
[  527.571050] x14: 0000000000000020 x13: 0a64657463657465 x12: 64206b636f6c6461
[  527.571059] x11: 656820747563205b x10: ffff800082adac08 x9 : ffff80008015020c
[  527.571068] x8 : ffff80008e24af08 x7 : 0000000000000001 x6 : ffff800082a5e000
[  527.571077] x5 : ffff000007c1a600 x4 : 0000000000000000 x3 : 0000000000000027
[  527.571086] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff000007c1a600
[  527.571094] Call trace:
[  527.571097] __rt_mutex_slowlock_locked.constprop.0
(kernel/locking/rtmutex.c:1674 (discriminator 1)
kernel/locking/rtmutex.c:1734 (discriminator 1)
kernel/locking/rtmutex.c:1760 (discriminator 1)) (P)
[  527.571107] __rwbase_read_lock (kernel/locking/rwbase_rt.c:114)
[  527.571117] down_read (kernel/locking/rwsem.c:1540)
[  527.571126] acct_collect (arch/arm64/include/asm/jump_label.h:36
include/linux/mmap_lock.h:41 include/linux/mmap_lock.h:454
kernel/acct.c:597)
[  527.571135] do_exit (kernel/exit.c:932)
[  527.571143] make_task_dead
(arch/arm64/include/asm/atomic_ll_sc.h:95 (discriminator 2)
arch/arm64/include/asm/atomic.h:52 (discriminator 2)
include/linux/atomic/atomic-arch-fallback.h:564 (discriminator 2)
include/linux/atomic/atomic-arch-fallback.h:1020 (discriminator 2)
include/linux/atomic/atomic-instrumented.h:454 (discriminator 2)
kernel/exit.c:1049 (discriminator 2))
[  527.571150] die (arch/arm64/kernel/traps.c:231)
[  527.571157] die_kernel_fault (arch/arm64/mm/fault.c:313)
[  527.571167] __do_kernel_fault (arch/arm64/mm/fault.c:375 (discriminator 5))
[  527.571177] do_bad_area (arch/arm64/mm/fault.c:482)
[  527.571186] do_translation_fault (arch/arm64/mm/fault.c:792)
[  527.571195] do_mem_abort (arch/arm64/mm/fault.c:929 (discriminator 1))
[  527.571204] el1_abort (arch/arm64/include/asm/daifflags.h:28
arch/arm64/kernel/entry-common.c:482)
[  527.571210] el1h_64_sync_handler (arch/arm64/kernel/entry-common.c:637)
[  527.571218] el1h_64_sync (arch/arm64/kernel/entry.S:591)
[  527.571225] kmem_cache_alloc_bulk_noprof (mm/slub.c:5343
(discriminator 1) mm/slub.c:5403 (discriminator 1)) (P)
[  527.571232] mas_alloc_nodes (lib/maple_tree.c:1278)
[  527.571241] mas_node_count_gfp (lib/maple_tree.c:1339)
[  527.571251] mas_preallocate (lib/maple_tree.c:5538 (discriminator 1))
[  527.571257] __split_vma (mm/vma.c:528 (discriminator 1))
[  527.571265] vma_modify (mm/vma.c:1633)
[  527.571273] vma_modify_flags (mm/vma.c:1650)
[  527.571282] mprotect_fixup (mm/mprotect.c:819)
[  527.571290] do_mprotect_pkey (mm/mprotect.c:993)
[  527.571299] __arm64_sys_mprotect (mm/mprotect.c:1011)
[  527.571308] invoke_syscall (arch/arm64/include/asm/current.h:19
arch/arm64/kernel/syscall.c:54)
[  527.571314] el0_svc_common.constprop.0
(include/linux/thread_info.h:135 (discriminator 2)
arch/arm64/kernel/syscall.c:140 (discriminator 2))
[  527.571321] do_el0_svc (arch/arm64/kernel/syscall.c:152)
[  527.571327] el0_svc (arch/arm64/include/asm/irqflags.h:82
(discriminator 1) arch/arm64/include/asm/irqflags.h:123 (discriminator
1) arch/arm64/include/asm/irqflags.h:136 (discriminator 1)
arch/arm64/kernel/entry-common.c:169 (discriminator 1)
arch/arm64/kernel/entry-common.c:182 (discriminator 1)
arch/arm64/kernel/entry-common.c:880 (discriminator 1))
[  527.571334] el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:899)
[  527.571341] el0t_64_sync (arch/arm64/kernel/entry.S:596)
[  527.571349] ---[ end trace 0000000000000000 ]---
[  527.571354] ------------[ cut here ]------------
[  527.571356] Voluntary context switch within RCU read-side critical section!
[  527.571372] WARNING: kernel/rcu/tree_plugin.h:332 at
rcu_note_context_switch+0x4ec/0x538, CPU#3: mkdir/34254
[  527.571383] Modules linked in: brcmfmac rockchip_dfi brcmutil
cfg80211 snd_soc_hdmi_codec dw_hdmi_i2s_audio dw_hdmi_cec
snd_soc_simple_card snd_soc_audio_graph_card hci_uart
snd_soc_rockchip_i2s snd_soc_es8316 snd_soc_spdif_tx
snd_soc_simple_card_utils btqca rtc_rk808 rockchipdrm btbcm
snd_soc_core dw_hdmi_qp bluetooth snd_compress reset_gpio analogix_dp
snd_pcm_dmaengine panfrost hantro_vpu dw_mipi_dsi rfkill rockchip_rga
drm_shmem_helper drm_dp_aux_bus snd_pcm gpu_sched dw_hdmi pwrseq_core
videobuf2_dma_sg v4l2_vp9 snd_timer drm_display_helper v4l2_h264
v4l2_jpeg phy_rockchip_pcie snd v4l2_mem2mem cec videobuf2_dma_contig
soundcore videobuf2_memops drm_client_lib videobuf2_v4l2
drm_dma_helper videobuf2_common rockchip_saradc drm_kms_helper
industrialio_triggered_buffer kfifo_buf rockchip_thermal
pcie_rockchip_host coresight_cpu_debug fuse drm backlight
[  527.571503] CPU: 3 UID: 0 PID: 34254 Comm: mkdir Tainted: G      D
W           6.16.0-next-20250801 #1 PREEMPT_RT
[  527.571512] Tainted: [D]=DIE, [W]=WARN
[  527.571514] Hardware name: Radxa ROCK Pi 4B (DT)
[  527.571517] pstate: 600000c5 (nZCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  527.571523] pc : rcu_note_context_switch
(kernel/rcu/tree_plugin.h:332 (discriminator 1))
[  527.571529] lr : rcu_note_context_switch
(kernel/rcu/tree_plugin.h:332 (discriminator 1))
[  527.571535] sp : ffff80008e24b1e0
[  527.571538] x29: ffff80008e24b1e0 x28: ffff000007c1a600 x27: ffff000007c1a601
[  527.571548] x26: 0000000000000000 x25: ffff000007c1a600 x24: ffff800082a60368
[  527.571557] x23: 0000000000000000 x22: ffff000007c1a600 x21: ffff800083125260
[  527.571566] x20: 0000000000000000 x19: ffff0000f7576080 x18: 0000000000000000
[  527.571575] x17: 65676e6172207373 x16: 6572646461206c65 x15: 0000000000000000
[  527.571583] x14: 0000000000000020 x13: 216e6f6974636573 x12: 206c616369746972
[  527.571593] x11: 6320656469732d64 x10: 6165722055435220 x9 : ffff80008015020c
[  527.571602] x8 : 6863746977732074 x7 : 7865746e6f632079 x6 : 7261746e756c6f56
[  527.571611] x5 : ffff80008317146f x4 : 0000000000000000 x3 : 0000000000000027
[  527.571619] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff000007c1a600
[  527.571628] Call trace:
[  527.571630] rcu_note_context_switch (kernel/rcu/tree_plugin.h:332
(discriminator 1)) (P)
[  527.571638] __schedule (kernel/sched/core.c:634
kernel/sched/sched.h:1519 kernel/sched/sched.h:1841
kernel/sched/core.c:6865)
[  527.571647] rt_mutex_schedule (kernel/sched/core.c:7044
kernel/sched/core.c:7339)
[  527.571655] __rt_mutex_slowlock_locked.constprop.0
(kernel/locking/rtmutex.c:1676 kernel/locking/rtmutex.c:1734
kernel/locking/rtmutex.c:1760)
[  527.571665] __rwbase_read_lock (kernel/locking/rwbase_rt.c:114)
[  527.571674] down_read (kernel/locking/rwsem.c:1540)
[  527.571683] acct_collect (arch/arm64/include/asm/jump_label.h:36
include/linux/mmap_lock.h:41 include/linux/mmap_lock.h:454
kernel/acct.c:597)
[  527.571690] do_exit (kernel/exit.c:932)
[  527.571696] make_task_dead
(arch/arm64/include/asm/atomic_ll_sc.h:95 (discriminator 2)
arch/arm64/include/asm/atomic.h:52 (discriminator 2)
include/linux/atomic/atomic-arch-fallback.h:564 (discriminator 2)
include/linux/atomic/atomic-arch-fallback.h:1020 (discriminator 2)
include/linux/atomic/atomic-instrumented.h:454 (discriminator 2)
kernel/exit.c:1049 (discriminator 2))
[  527.571703] die (arch/arm64/kernel/traps.c:231)
[  527.571710] die_kernel_fault (arch/arm64/mm/fault.c:313)
[  527.571719] __do_kernel_fault (arch/arm64/mm/fault.c:375 (discriminator 5))
[  527.571729] do_bad_area (arch/arm64/mm/fault.c:482)
[  527.571738] do_translation_fault (arch/arm64/mm/fault.c:792)
[  527.571746] do_mem_abort (arch/arm64/mm/fault.c:929 (discriminator 1))
[  527.571755] el1_abort (arch/arm64/include/asm/daifflags.h:28
arch/arm64/kernel/entry-common.c:482)
[  527.571761] el1h_64_sync_handler (arch/arm64/kernel/entry-common.c:637)
[  527.571769] el1h_64_sync (arch/arm64/kernel/entry.S:591)
[  527.571775] kmem_cache_alloc_bulk_noprof (mm/slub.c:5343
(discriminator 1) mm/slub.c:5403 (discriminator 1)) (P)
[  527.571782] mas_alloc_nodes (lib/maple_tree.c:1278)
[  527.571792] mas_node_count_gfp (lib/maple_tree.c:1339)
[  527.571802] mas_preallocate (lib/maple_tree.c:5538 (discriminator 1))
[  527.571808] __split_vma (mm/vma.c:528 (discriminator 1))
[  527.571816] vma_modify (mm/vma.c:1633)
[  527.571824] vma_modify_flags (mm/vma.c:1650)
[  527.571833] mprotect_fixup (mm/mprotect.c:819)
[  527.571842] do_mprotect_pkey (mm/mprotect.c:993)
[  527.571850] __arm64_sys_mprotect (mm/mprotect.c:1011)
[  527.571859] invoke_syscall (arch/arm64/include/asm/current.h:19
arch/arm64/kernel/syscall.c:54)
[  527.571866] el0_svc_common.constprop.0
(include/linux/thread_info.h:135 (discriminator 2)
arch/arm64/kernel/syscall.c:140 (discriminator 2))
[  527.571872] do_el0_svc (arch/arm64/kernel/syscall.c:152)
[  527.571878] el0_svc (arch/arm64/include/asm/irqflags.h:82
(discriminator 1) arch/arm64/include/asm/irqflags.h:123 (discriminator
1) arch/arm64/include/asm/irqflags.h:136 (discriminator 1)
arch/arm64/kernel/entry-common.c:169 (discriminator 1)
arch/arm64/kernel/entry-common.c:182 (discriminator 1)
arch/arm64/kernel/entry-common.c:880 (discriminator 1))
[  527.571885] el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:899)
[  527.571893] el0t_64_sync (arch/arm64/kernel/entry.S:596)
[  527.571900] ---[ end trace 0000000000000000 ]---
[  540.645451] sched: DL replenish lagged too much

## Source
* Git tree: https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next.git
* Git sha: 54efec8782214652b331c50646013f8526570e8d
* Git describe: next-20250729
* Project details:
https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250729
* Architectures: arm64
* Toolchains: gcc-13
* Kconfigs: Preempt_rt

## Test
* Test log 1: https://qa-reports.linaro.org/api/testruns/29282584/log_file/
* Test log 2:https://qa-reports.linaro.org/api/testruns/29337984/log_file/
* Test lava log: https://lkft.validation.linaro.org/scheduler/job/8373114#L19186
* Test details:
https://regressions.linaro.org/lkft/linux-next-master/next-20250729/log-parser-test/exception-rtmutex-deadlock-detected/
* Test plan: https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/30XMjtCEi0VzsU1gYZ0a7kcTkLJ
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/30fq2ElntxgscJ13dnaD7iL5Z1G/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/30fq2ElntxgscJ13dnaD7iL5Z1G/config

--
Linaro LKFT
https://lkft.linaro.org

