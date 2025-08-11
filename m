Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D329DCA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 08:21:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BF7F8E0010; Mon, 11 Aug 2025 04:21:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 676C88E000A; Mon, 11 Aug 2025 04:21:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 586268E0010; Mon, 11 Aug 2025 04:21:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 43F078E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:21:09 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EA2C5137B9C
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:21:08 +0000 (UTC)
X-FDA: 83763781416.22.C7695F0
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf22.hostedemail.com (Postfix) with ESMTP id EF21CC0002
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:21:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=TWVkvl7N;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf22.hostedemail.com: domain of naresh.kamboju@linaro.org designates 209.85.214.179 as permitted sender) smtp.mailfrom=naresh.kamboju@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754900467; a=rsa-sha256;
	cv=none;
	b=sMrPHUbP8DFRvNLIwJCJrIBIBdrYmEQcI6KYr4TZSOvyQnKb76CLlOJgmy7heMBzvJ7Jhs
	4De0mF1LZHrxFjXfwdhTtWYKkAz8of8YLbcOE47oRvo+PowW/Ntm1VaZUYhj29DWm8o7PV
	9/Z72tYZ7nfX67MS41Kwo2nrfMiXj9c=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=TWVkvl7N;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf22.hostedemail.com: domain of naresh.kamboju@linaro.org designates 209.85.214.179 as permitted sender) smtp.mailfrom=naresh.kamboju@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754900467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KtvUcm8eKqLg5xx/IzAnE0CR0VtQIYJM5TEZnjUYa44=;
	b=5s1NqGv7m9cvCAtcE23dyi/eZbLFEGg82xRz6/LixzGomhHkT4D7EXHb75K2w31K9TcZ3K
	AW2+3pbbw5n48q2RwK0ERXnv0xqeYFSOD1TllB8XH1akGExraOMMjqe+eaKV7lirO5FP3+
	pv40QpmWxnS2FqPW/mG60NLDanKl4kU=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-24041a39005so25565405ad.2
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 01:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754900466; x=1755505266; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KtvUcm8eKqLg5xx/IzAnE0CR0VtQIYJM5TEZnjUYa44=;
        b=TWVkvl7NfLDHtXgEs7+tPDfpfPkrAg/lE0w/Gv0Bkk9ck8EdlQ8u0i9V5caPOB/6Rl
         pOPhAGaSV9cSpleweQ8VncgJlbtaflP4+UBq6yovbVgE78FTiSVBCu1PRwGE+af8sIL1
         udgua2f96m7T++VEDO5o36UZBmsGh/jKDaD7cMSdo6YBZU4iKOjbrUE+gwmcFK3lGV+a
         AUIwXFyhJKJdnhKQhxJRBHX2XzMNA6nCo79AKZWm9kE3n+yJ+Ok0OEEEsMQpfBVpi0UQ
         ZpdAY8Cx85/l59RV695Fk2JgS2S16qrO8KfHphkjDR4+zf5IKecsj/WZ7+nrdFt0qz5T
         eA/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754900466; x=1755505266;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KtvUcm8eKqLg5xx/IzAnE0CR0VtQIYJM5TEZnjUYa44=;
        b=vVoO/djZ61YBcWPTc1bn+cXRAQICXyPh9eh9K99CgVmcuM5UTdkIgS0lpUEUTND9Qt
         XxxXbIcqtetQeTNlmCAvRBBddFkkSQ/90Si5Tuzh1JKkiYeW56PNwgGDYzEe77aEnIQQ
         jJNRPgwILl/T7q8fINh1gaZQqjh/UsMXEmOfKFUpnPEVUHTRAhjl18O/Rs2P74fd5Ecm
         Q8kz/DbimKEKFGdyjy08CYu1yniD0r/zHookJLDkgRDx5dLQPazS6FRS1diFapTHuZs6
         RX9Gm86sxqObz6QRr4sOFIEXKm6ueGSUr6LVJoAw34Iq45LxbC7deg+b1ijMyA2Xj8E7
         YrDw==
X-Forwarded-Encrypted: i=1; AJvYcCUngN5Jztu9EOL3HFkaKos+5F/gRB0AO0xwdHmeIiPpbLrbgopIar/gQg2rCEDwmdGCG+mLzvJPXA==@kvack.org
X-Gm-Message-State: AOJu0YzB8D1rp5cHbQD3LRV1v5O0/FHLKD87LW9tWSD1LypVwOOvi8CG
	pC0EpGtQ0cQiODjfe16oXV/gKmKnJ+me7JG9koF1CTF5V7WsEve/nxU6T04mxIXrxqj7r9nTZmx
	z4GexVOalROWyjCqZ+EtexGISQWctUo5rtbZL8/PP1g==
X-Gm-Gg: ASbGncscdFM4szTt808qeUb10ALl6DX6Axz3ot/QYCCOxNRiBYXtTd9kytnKT8H2O2J
	Ho+0i67kfoYXBEpp3u6ap/+7/iWTcd6mosk6XvI3kAjvWxZiC/OmfAFAMevfrhUnVKBxNiP/QS8
	sVX7HSC7EMSISjzuPp3YSwBja4N2eMfLNRI51ewVoDt93xSdZU2lnzyp+aubhWdPPMG4BfDVuBf
	860yRvcDLiaKaji8Yyh2LOGcQAJdNLMp3/zo4+8
X-Google-Smtp-Source: AGHT+IG/wrH/Z4PP0pZIy9wjFLr0/V/zaFYS1NMbhK2es383D8DYO570WjTh+eTKECcdm1aWBgEKS2c59dA6CxPHBHA=
X-Received: by 2002:a17:902:d54f:b0:240:7247:f738 with SMTP id
 d9443c01a7336-242c1ecb81cmr194687925ad.1.1754900465618; Mon, 11 Aug 2025
 01:21:05 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYumD2MGjECCv0wx2V_96_FKNtFQpT63qVNrrCmomoPYVQ@mail.gmail.com>
 <aJXebTmgnrWw7Ks4@willie-the-truck>
In-Reply-To: <aJXebTmgnrWw7Ks4@willie-the-truck>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 11 Aug 2025 13:50:53 +0530
X-Gm-Features: Ac12FXw5lvgF03ojOkscaSZZ8MEt6jPVgnO3qRgJ61gr4N1xTZBfV52fTLslDqU
Message-ID: <CA+G9fYseoJU0TNmvSEU4sQTye575Jnq5XiwZZrK9K5z_snVM1A@mail.gmail.com>
Subject: Re: next-20250729: PREEMPT_RT: rock Pi 4b Internal error Oops
 kmem_cache_alloc_bulk_noprof - kernel locking rtmutex.c at __rt_mutex_slowlock_locked
To: Will Deacon <will@kernel.org>
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>, linux-mm <linux-mm@kvack.org>, 
	open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org, 
	Linux Regressions <regressions@lists.linux.dev>, Thomas Gleixner <tglx@linutronix.de>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Anders Roxell <anders.roxell@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Vlastimil Babka <vbabka@suse.cz>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Ben Copeland <benjamin.copeland@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EF21CC0002
X-Stat-Signature: ns4unuudkhdcr1w9hx33o48fdbg8axq7
X-Rspam-User: 
X-HE-Tag: 1754900466-987087
X-HE-Meta: U2FsdGVkX1+s7YDM5mweVQeg1Ha4d4hWVERasrpXqJliaGmTsXZ5RiLvmYuRbrsXz/AvFy/jXxPRcnq+g+OPB5UJhLW7t6F3tK9HH9I50YWjXgyn0rK4eeSXWZVWbkyt46wXZMa4SIb0emaK/vag1+RVee7V0mO0aUc4ogPaXmvB+p/yzhH108RCpk8hBU5kcti38b0DaxoNfOFBf6VXwKkiBdbk2UXml+8C2ANvPMm2wrnCfnoyeFVhH6CEkBwo03+ypUFcDz3+FuvLZRts7927jym4pFGLUeEwGyrvCUZzfx8UTImumcanz10hvNAR2MZS64pdIS4cyKphThyr2TO1Z6+bNjgUHN4kkOIeOsUwqp37OG99Ik+5VTbVcq8JOyPBrQoytzcTZq3UT+hYxjhVnREn8T3XAswZbQQrNbYBsN3t1fn+FFedt2e+1sgsxsjHk+I1gZ+cfYglpOywHqXZEjNaYk8n4dB4va/I+Gqly0UHqnzxWvdwUcY0pbMbSOUB+UYiOn9Xnn4aTRViXoy+g9aHmxQOGesd+rWUtVYR2VUyW4RotbOwddODrytp+vDxsZCBSbeSiQyJHQcKswN2AkuKqxuhYBjyHacGkegOBTQiy8orhiQAm+pflulTkQnHFzCWmIG+ig3kSG/ovNEZG3eeJ4aspnB/OZw8HbUKqr2C8dRKtbDTzKHwXGjsGHwRAwLyl+FtvAjIxyufOiENbx6RhMR7yP1sddBXf/qTsedf6RYoVaS94tjBkVxFKnELl27qYmXzwDubbJKJ7/5Zz7Q6qf/X8WAps+ZrvQ9iA3ruHerRNiK98vpYxSAL/TzibU8hf3j+wUqCFNdwagMafKa2fMCfPM4TmEcTipAjWmhg2ebJZHx7D9t31lJNn8UjSJS2PgjsGl40vBO7ym698ByfuDbwwKSm/iownO96pae/OORxCnT+UgOcI01elvpXz8kISGzDxLwphDm
 xJhPtoF5
 fPhRvhklf9QIfqXvumhujA/6b0eyAxu8Ltlca1FQoURRSq8ga0rgQTeFSps+Itp4qYZLfR/30AYggZNSGy5J1/q3TRASmXCmvcMYLQG8mbonVGZBrKW8yQuG/w7+UHbzaNAElt9iIwfHCNadApqOjV7ODIiPfzJuePJGsfMYrhD8aIDOslYtKWSbaC0vJ68DXMe/RjJhnF6BhS2qsk+0skYmn0u0FEeVf1rcnv/pOoHt9zDLrvD+nlSc6tzdCeIH3SvMb/XNjdG6h3hAk7fXBTuf3MVqbQLbKJ84KDt+asnZx+xyEe7atkOaG+ojfrFWfani+HEL0dNLpG8BpbPHcQnlWbJTBn/or9Gbp0jqe0b7A/cBhuXfu1JY5rICr3UTaiRrP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Will,

On Fri, 8 Aug 2025 at 16:54, Will Deacon <will@kernel.org> wrote:
>
> Hi Naresh,
>
> On Sat, Aug 02, 2025 at 03:45:51PM +0530, Naresh Kamboju wrote:
> > ## Test log
> > [  527.570253] Unable to handle kernel paging request at virtual
> > address 003f0020f94020a1
> > [  527.570274] Mem abort info:
> > [  527.570277]   ESR = 0x0000000096000004
> > [  527.570282]   EC = 0x25: DABT (current EL), IL = 32 bits
> > [  527.570288]   SET = 0, FnV = 0
> > [  527.570292]   EA = 0, S1PTW = 0
> > [  527.570297]   FSC = 0x04: level 0 translation fault
> > [  527.570302] Data abort info:
> > [  527.570305]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
> > [  527.570310]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
> > [  527.570316]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
> > [  527.570322] [003f0020f94020a1] address between user and kernel address ranges
> > [  527.570330] Internal error: Oops: 0000000096000004 [#1]  SMP
> > [  527.570336] Modules linked in: brcmfmac rockchip_dfi brcmutil
> > cfg80211 snd_soc_hdmi_codec dw_hdmi_i2s_audio dw_hdmi_cec
> > snd_soc_simple_card snd_soc_audio_graph_card hci_uart
> > snd_soc_rockchip_i2s snd_soc_es8316 snd_soc_spdif_tx
> > snd_soc_simple_card_utils btqca rtc_rk808 rockchipdrm btbcm
> > snd_soc_core dw_hdmi_qp bluetooth snd_compress reset_gpio analogix_dp
> > snd_pcm_dmaengine panfrost hantro_vpu dw_mipi_dsi rfkill rockchip_rga
> > drm_shmem_helper drm_dp_aux_bus snd_pcm gpu_sched dw_hdmi pwrseq_core
> > videobuf2_dma_sg v4l2_vp9 snd_timer drm_display_helper v4l2_h264
> > v4l2_jpeg phy_rockchip_pcie snd v4l2_mem2mem cec videobuf2_dma_contig
> > soundcore videobuf2_memops drm_client_lib videobuf2_v4l2
> > drm_dma_helper videobuf2_common rockchip_saradc drm_kms_helper
> > industrialio_triggered_buffer kfifo_buf rockchip_thermal
> > pcie_rockchip_host coresight_cpu_debug fuse drm backlight
> > [  527.570493] CPU: 3 UID: 0 PID: 34254 Comm: mkdir Not tainted
> > 6.16.0-next-20250801 #1 PREEMPT_RT
> > [  527.570502] Hardware name: Radxa ROCK Pi 4B (DT)
> > [  527.570506] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> > [  527.570512] pc : kmem_cache_alloc_bulk_noprof (mm/slub.c:5343
> > (discriminator 1) mm/slub.c:5403 (discriminator 1))
> > [  527.570527] lr : kmem_cache_alloc_bulk_noprof
> > (include/linux/atomic/atomic-arch-fallback.h:457
> > include/linux/atomic/atomic-instrumented.h:33
> > include/linux/kfence.h:127 mm/slub.c:5307 mm/slub.c:5403)
> > [  527.570533] sp : ffff80008e24b8f0
> > [  527.570536] x29: ffff80008e24b930 x28: 00ff000000584610 x27: ffff800082b30538
> > [  527.570545] x26: ffff8000816b64dc x25: 0000000000000cc0 x24: 0000000000000000
> > [  527.570554] x23: 0000000000000004 x22: ffff0000f7579d20 x21: 0000000000000001
> > [  527.570563] x20: 0000000000000001 x19: ffff000000405b00 x18: ffff80008e24bcd0
> > [  527.570572] x17: 0000000000000000 x16: ffff800081e18420 x15: 0000ffffa2670fff
> > [  527.570582] x14: 0000000000000000 x13: 1fffe000017942e1 x12: 0000ffffa2470fff
> > [  527.570591] x11: ffff00000bca1708 x10: 0000000000000001 x9 : ffff8000816e41a4
> > [  527.570600] x8 : ffff80008e24b850 x7 : fefefefefefefefe x6 : ffff800082b30000
> > [  527.570608] x5 : d63f0020f9402021 x4 : ffff0000f7579d58 x3 : 0000000000000000
> > [  527.570617] x2 : 0000000000000000 x1 : 0000000000000100 x0 : 0000000000000080
> > [  527.570627] Call trace:
> > [  527.570631] kmem_cache_alloc_bulk_noprof (mm/slub.c:5343
> > (discriminator 1) mm/slub.c:5403 (discriminator 1)) (P)
> > [  527.570639] mas_alloc_nodes (lib/maple_tree.c:1278)
> > [  527.570651] mas_node_count_gfp (lib/maple_tree.c:1339)
> > [  527.570661] mas_preallocate (lib/maple_tree.c:5538 (discriminator 1))
> > [  527.570667] __split_vma (mm/vma.c:528 (discriminator 1))
> > [  527.570677] vma_modify (mm/vma.c:1633)
> > [  527.570685] vma_modify_flags (mm/vma.c:1650)
> > [  527.570694] mprotect_fixup (mm/mprotect.c:819)
> > [  527.570704] do_mprotect_pkey (mm/mprotect.c:993)
> > [  527.570713] __arm64_sys_mprotect (mm/mprotect.c:1011)
> > [  527.570722] invoke_syscall (arch/arm64/include/asm/current.h:19
> > arch/arm64/kernel/syscall.c:54)
> > [  527.570731] el0_svc_common.constprop.0
> > (include/linux/thread_info.h:135 (discriminator 2)
> > arch/arm64/kernel/syscall.c:140 (discriminator 2))
> > [  527.570737] do_el0_svc (arch/arm64/kernel/syscall.c:152)
> > [  527.570744] el0_svc (arch/arm64/include/asm/irqflags.h:82
> > (discriminator 1) arch/arm64/include/asm/irqflags.h:123 (discriminator
> > 1) arch/arm64/include/asm/irqflags.h:136 (discriminator 1)
> > arch/arm64/kernel/entry-common.c:169 (discriminator 1)
> > arch/arm64/kernel/entry-common.c:182 (discriminator 1)
> > arch/arm64/kernel/entry-common.c:880 (discriminator 1))
> > [  527.570752] el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:899)
> > [  527.570760] el0t_64_sync (arch/arm64/kernel/entry.S:596)
> > [ 527.570772] Code: 1400000c f94002c5 b4000aa5 b9402a60 (f86068a0)
> > All code
> > ========
> >    0: 1400000c b 0x30
> >    4: f94002c5 ldr x5, [x22]
> >    8: b4000aa5 cbz x5, 0x15c
> >    c: b9402a60 ldr w0, [x19, #40]
> >   10:* f86068a0 ldr x0, [x5, x0] <-- trapping instruction
> >
> > Code starting with the faulting instruction
> > ===========================================
> >    0: f86068a0 ldr x0, [x5, x0]
> > [  527.570778] ---[ end trace 0000000000000000 ]---
> > [  527.570800] ------------[ cut here ]------------
>
> If you're able to repro this, please could you see if the patch below
> helps at all?

I applied the patch as suggested, tested it, and confirmed that the reported
regressions are now resolved.

I applied the patch as suggested, tested it, and confirmed the reported
regressions are resolved. Our LKFT CI will continue monitoring and report
back if the issue reoccurs.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

>
> https://lore.kernel.org/r/20250806145611.3962-1-dev.jain@arm.com
>
> Cheers,
>
> Will

- Naresh

