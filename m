Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B891AC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 14:29:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 544B36B00AB; Tue, 22 Jul 2025 10:29:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F5826B00AC; Tue, 22 Jul 2025 10:29:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 432D06B00AE; Tue, 22 Jul 2025 10:29:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 301526B00AB
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:29:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CCCC38042E
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:29:25 +0000 (UTC)
X-FDA: 83692133490.12.E6AE1A0
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf28.hostedemail.com (Postfix) with ESMTP id 258FEC0006
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:29:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=zPNm0lKq;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf28.hostedemail.com: domain of naresh.kamboju@linaro.org designates 209.85.216.53 as permitted sender) smtp.mailfrom=naresh.kamboju@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753194564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=w4j/dqB0FEJVP++msFICUJGBS7c5vIhwDliD0r1Ztug=;
	b=GEscwZ0SMMT10qQuOe1EjuV68EK9INJJe2q5QX8fqmVZBb0KKiFAePIqWwp1gZq0iYzxMK
	lA/UlSOfIOz5QNwCUbVC305d1qIyccaXiOd4gr/2BP7+RWs7kwZ6VjW1EdE3AXJxWqEjIJ
	nWsRjb4YzqM1xlT+ZcG1ICix4SABgYc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753194564; a=rsa-sha256;
	cv=none;
	b=so2WZZWHiz5lkIttcvMypNev63ffyaFa0DZZIP6QmISu6O/G52xlDyWe2BA3EWkC62tnBd
	GI32+AmEv0/nzs7Xuo1U74cd6c2odeoHCjBtnmw8ySJZn7Ddye3VWMRJmTzuFSKpXJyQC7
	vVeZ08hurk8PE6YeerSINWayYDUnO/I=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=zPNm0lKq;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf28.hostedemail.com: domain of naresh.kamboju@linaro.org designates 209.85.216.53 as permitted sender) smtp.mailfrom=naresh.kamboju@linaro.org
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-311bd8ce7e4so4657449a91.3
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753194563; x=1753799363; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=w4j/dqB0FEJVP++msFICUJGBS7c5vIhwDliD0r1Ztug=;
        b=zPNm0lKqD0hlpk3tgapfYdE8bF0HSQS44JWq5tjDdcXGbiguKVzsjMPGTh/mJ4nLLc
         SK6UKwoa8em8uAhMhFTdC9tT6499a/vRIq1ft3RRkMJnFBIvCsHN/RZwLAG5r6znONUO
         Xq5+A+VTDivVGTViORlfGv8u4D/nxTOM/Wi7B+5Fc3u1A0038HkGhXj4AepIjJ49h3zs
         6z3DNXUlt5r0N6KT/cUtan6GydUfoaZ6BFHnCOkQVsdqafEXoa0V6PhOQs90t8qC5SDb
         Dgrk5vJEY6pUyxps1ZoE1V77CWbS8IDEayUjWWZkeWkEsoc8S9ZKoTl+ipqVrApJY50R
         FwUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753194563; x=1753799363;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w4j/dqB0FEJVP++msFICUJGBS7c5vIhwDliD0r1Ztug=;
        b=rFKBlsnfmH1Y8gHp8N3AJSdWZIGZLYUgGHgiu+j0FS/MG/5+PSTsX66WCoP9R8TUtV
         lkYDl17RwaSrjMwkEsJ1p8h0G/Jx9DmUQF4WsxTAUb071ASeIzHtoPR3aq/6dNHAuZO+
         n6H7w/ynn10AZGfc5TLlOiBBa7A70fDPU6eO51cM/c8HSmLLFWH0NBzIrUP8p4xcsbIR
         bmxKOQ4JbGkiZP8lWf4GZJVk+eJ/mMlbU2hNa/xp1hKpBUiw7FIjlE3ImAjir9XF3O12
         yG+zVJ1fdJMcQREsJhqc8LBrB397N6MKpZh6hgAlM09ESztkUb67Y40/UYWK9kc2euUc
         IVVw==
X-Forwarded-Encrypted: i=1; AJvYcCVN+/kp2r6e4aXu7VWJmvd23CjOLaSZMPi11MaGYp+EeiA663pTph9LQN2pVYssCuQ71MKrOD74tw==@kvack.org
X-Gm-Message-State: AOJu0YwtToWJagrpO9q8p/QKxSuk4q7Zy9TGOgxwLmKxSk5WyLAyi+fF
	Z6bFYJks0gO2WU6zzEjZoGdPxAx86Ur+5+1lOiVtO258oqnoGAHQifGzPRiZ7lrlY52saQyi5vJ
	UZVhrb+nqo57iM9qleLqzQfU1T1gKloTaOV9FFndyyQ==
X-Gm-Gg: ASbGncusVMjJVz829y8l38cPPt79Pvr9c/crYTuyNPKQnpj/1UyvUatQVC7E3i2XAcA
	xgNWEyUX41NXVBBWFjXpyXLPdVuu2qYQsrqE8p6Xjh/4ly4lgtVdkPCwuHU1evqpL0QKWJyQ2sc
	DsAX19/AUge5IRN8NiO6jOTggFQ4qQ3HKLoPUxW6fpi0SP1ctMK398I9gQVfDuC4qBILZSekhax
	2+bQjnuw2OUnxdv2qJij3uwJRahci6pNd9WCcI3
X-Google-Smtp-Source: AGHT+IGViVGo30JiX8Iobzc1nz2CMFoTAV0xD2CPDCL3v8RSJq2399IbiFlY9qPHicdWf4XFVuhv/Tq4f+y6dIWOKcQ=
X-Received: by 2002:a17:90b:2710:b0:311:fde5:c4c2 with SMTP id
 98e67ed59e1d1-31cc2512f33mr21973154a91.1.1753194562844; Tue, 22 Jul 2025
 07:29:22 -0700 (PDT)
MIME-Version: 1.0
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 22 Jul 2025 19:59:11 +0530
X-Gm-Features: Ac12FXy-ZjVvt-T4i3MttzsHoSjov0ZMbtIf-x7c-wsH5Vg-oeIRD3f4bfuDeLg
Message-ID: <CA+G9fYupPsQoBrtF=-WT0nSy6m+yG1p9m68Z18Bp-Y=QMFD_tQ@mail.gmail.com>
Subject: next-20250717: arm64: rk3399-rock-pi-4b: NFS mount failure with 64K
 page size
To: linux-rockchip@lists.infradead.org, linux-mm <linux-mm@kvack.org>, 
	Netdev <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, 
	lkft-triage@lists.linaro.org, Linux Regressions <regressions@lists.linux.dev>
Cc: Heiko Stuebner <heiko@sntech.de>, Andrew Morton <akpm@linux-foundation.org>, 
	"David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Anders Roxell <anders.roxell@linaro.org>, 
	Ben Copeland <benjamin.copeland@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 258FEC0006
X-Stat-Signature: x61ajxpz7f7rqo8e1tgiokm76w169oum
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753194563-445062
X-HE-Meta: U2FsdGVkX1/Y72nTKINkM6UhK6ojyI/g/COdD/hulufrVP02z1TOokKEnQHnyW/5/xVTMmplsJ42D3dYSdE8xsWDs+8AK1PF5SSEHX15vYcukO9s3/UFbLVk5MnxtupsQF6oFMGjVv8jA6Jc/ifsVRtbDMDCcKw3ORwmELXFywJUfKSPYTL5qK1VSPZYN5LY1PuOGCUyds+2wePa4xBkTuvEa1Tt7b8b/CEs59WrFLpr2I2FOmrXvER/s/dCa8jmvRpQy/5pAjCJbCpIWMl0PpqDIOTkOY82winpKPS7Dxly5oPo3BEokkbLlX3C2J4Bk+jIKxioyl4ZPpMhmUJKzLI6tGTTSIbNFjTHZvHxAXekpYxnLdivdj/VH1fZ9t+5c2+0Ly7ZoRCPYZGV/ZBCrHiHlc9fLa8Q5LjzpnSc0ULtyZ4IG1mJvBVgR02/RFkzAgbQsAXW6udbkKvJ0iGFP2Vt9dPzBe9gtMYnRCEiftglPWbJe5hBKoXbzlxiUSuRE7QDtPZf6HdvAc15RuF9LjtLRd7WysQ4qU+vBs7JgOHCsNOn1X+GxE0svsHAurFONgxgNqmTlx7y1Iu8u21gwBOz70nqkX0i/ZExqKSW0j+epVNkGq+/Qc0Rg0Q08OSogxhPBsDWCtjcrsYV/ZaNBFEGvh81kpujf7DoO9btEuSjGooAgtwUN7GPJNej6lTSfcwx1S/iTokinOE1gRFKsj8tL1RRGu6aNNArjH8T9tmbzjSUnnm/hyYwN05HU96tWg/tpLbheCrihIXMVWjschWmQC4xRF3NW8ACZoBcuX0ms3C1EP1taunQn5/o8Qubz4Q652DfjsFaYcYl3K0AiFsCaKWcBLZZdPT/hb8v1mijGSLUZvOzpGcQ1wiz3KRJrwmoahFEqVNfmSQeE0KhbA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The rk3399-rock-pi-4b device fails to mount the root filesystem over
NFS when the kernel is built with 64K page size.
CONFIG_ARM64_64K_PAGES=y

This regression was first observed with the Linux next-20250717 tag
and continues to persist through next-20250722.

Device: rk3399-rock-pi-4b
Build Configuration: lkftconfig-64k_page_size

Regression Window:

 Good: next-20250716
 Bad: next-20250717.. Still Bad: next-20250722

Kernel Config Impact:
CONFIG_ARM64_64K_PAGES=y  - NFS mount fails
CONFIG_ARM64_4K_PAGES=y  - NFS mount works as expected

Regression Analysis:
- New regression? Yes
- Reproducibility? Yes

Boot regression:  next-20250717 arm64 rk3399-rock-pi-4b NFS mount
failure with 64K page size

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Boot log

[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd034]
[    0.000000] Linux version 6.16.0-rc6-next-20250717
(tuxmake@tuxmake) (aarch64-linux-gnu-gcc (Debian 13.3.0-16) 13.3.0,
GNU ld (GNU Binutils for Debian) 2.44) #1 SMP PREEMPT @1752747461
[    0.000000] KASLR disabled due to lack of seed
[    0.000000] Machine model: Radxa ROCK Pi 4B
[    0.000000] efi: UEFI not found.
[    0.000000] earlycon: uart0 at MMIO32 0x00000000ff1a0000 (options
'1500000n8')
[    0.000000] printk: legacy bootconsole [uart0] enabled
[    0.000000] OF: reserved mem: Reserved memory: No reserved-memory
node in the DT
[    0.000000] NUMA: Faking a node at [mem
0x0000000000200000-0x00000000f7ffffff]

<trim>

[    6.520442] Sending DHCP requests ..
[   13.295867] platform sdio-pwrseq: deferred probe pending:
pwrseq_simple: reset control not ready
[   13.295887] dwmmc_rockchip fe310000.mmc: IDMAC supports 32-bit address mode.
[   13.296260] rockchip-pm-domain
ff310000.power-management:power-controller: sync_state() pending due
to fe310000.mmc
[   13.296278] rockchip-pm-domain
ff310000.power-management:power-controller: sync_state() pending due
to ff650000.video-codec
[   13.297085] dwmmc_rockchip fe310000.mmc: Using internal DMA controller.
[   13.297660] rockchip-pm-domain
ff310000.power-management:power-controller: sync_state() pending due
to ff660000.video-codec
[   13.298653] dwmmc_rockchip fe310000.mmc: Version ID is 270a
[   13.299536] rockchip-pm-domain
ff310000.power-management:power-controller: sync_state() pending due
to ff680000.rga
[   13.300164] dwmmc_rockchip fe310000.mmc: DW MMC controller at irq
49,32 bit host data width,256 deep fifo
[   13.301117] rockchip-pm-domain
ff310000.power-management:power-controller: sync_state() pending due
to ff880000.i2s
[   13.304227] rockchip-pm-domain
ff310000.power-management:power-controller: sync_state() pending due
to ff8a0000.i2s
[   13.305148] rockchip-pm-domain
ff310000.power-management:power-controller: sync_state() pending due
to ff8f0000.vop
[   13.306071] rockchip-pm-domain
ff310000.power-management:power-controller: sync_state() pending due
to ff900000.vop
[   13.307009] rockchip-pm-domain
ff310000.power-management:power-controller: sync_state() pending due
to ff940000.hdmi
[   13.307937] rockchip-pm-domain
ff310000.power-management:power-controller: sync_state() pending due
to ff9a0000.gpu
[   14.620509] ., OK
[   14.636949] IP-Config: Got DHCP answer from 10.66.16.15, my address
is 10.66.30.7
[   14.637647] IP-Config: Complete:
[   14.637955]      device=eth0, hwaddr=0a:fb:82:cd:ed:a8,
ipaddr=10.66.30.7, mask=255.255.240.0, gw=10.66.16.1
[   14.638845]      host=10.66.30.7, domain=lkftlab, nis-domain=(none)
[   14.639417]      bootserver=0.0.0.0, rootserver=10.66.16.116, rootpath=
[   14.639440]      nameserver0=10.66.16.15
[   14.641679] clk: Disabling unused clocks
[   14.646347] dw-apb-uart ff1a0000.serial: forbid DMA for kernel console
[   14.647091] check access for rdinit=/init failed: -2, ignoring
[   14.762496] VFS: Mounted root (nfs filesystem) on device 0:22.
[   14.763768] devtmpfs: mounted
[   14.775761] Freeing unused kernel memory: 4928K
[   14.776566] Run /sbin/init as init process
[   95.816464] random: crng init done
[  195.556677] nfs: server 10.66.16.116 not responding, still trying
..
[  195.556703] nfs: server 10.66.16.116 not responding, still trying
[  195.556869] nfs: server 10.66.16.116 not responding, still trying
[  195.557010] nfs: server 10.66.16.116 not responding, still trying
[  195.557055] nfs: server 10.66.16.116 not responding, still trying
[  195.557114] nfs: server 10.66.16.116 not responding, still trying
[  195.557166] nfs: server 10.66.16.116 not responding, still trying
[  195.557217] nfs: server 10.66.16.116 not responding, still trying
[  195.557269] nfs: server 10.66.16.116 not responding, still trying
[  195.557304] nfs: server 10.66.16.116 not responding, still trying
[  227.459759] nfs: server 10.66.16.116 OK
[  227.459868] nfs: server 10.66.16.116 OK
[  227.681008] nfs: server 10.66.16.116 OK
[  319.645474] nfs: server 10.66.16.116 OK
[  407.677657] nfs: server 10.66.16.116 OK
[  499.834818] nfs: server 10.66.16.116 OK
[  587.895692] nfs: server 10.66.16.116 OK
[  680.052774] nfs: server 10.66.16.116 OK
[  768.113810] nfs: server 10.66.16.116 OK
[  860.270785] nfs: server 10.66.16.116 OK
#
[  948.331418] nfs: server 10.66.16.116 OK
#
[ 1096.679211] nfs: server 10.66.16.116 OK
#
[ 1274.856436] nfs: server 10.66.16.116 OK
#
[ 1488.985700] nfs: server 10.66.16.116 OK


## Source
* Git tree: https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next.git
* Project: https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250717/
* Git sha: 024e09e444bd2b06aee9d1f3fe7b313c7a2df1bb
* Git describe: 6.16.0-rc6-next-20250717
* kernel version: next-20250717
* Architectures: arm64 (rock-pi-4b)
* Toolchains: gcc-13
* Kconfigs: defconfig+64K page size

## Test
* Test log: https://qa-reports.linaro.org/api/testruns/29168904/log_file/
* Test LAVA: https://lkft.validation.linaro.org/scheduler/job/8364278#L924
* Test run: https://regressions.linaro.org/lkft/linux-next-master/next-20250717/testruns/1662101/
* Test plan: https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/2zzwHDuV3xvZBKkAtqlmroSxuIS
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2zzwEbz0aS3AtluE2oRQ9gMvFTY/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2zzwEbz0aS3AtluE2oRQ9gMvFTY/config


--
Linaro LKFT
https://lkft.linaro.org

