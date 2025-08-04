Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28F03C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 14:57:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD5838E0008; Mon,  4 Aug 2025 10:57:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B86078E0001; Mon,  4 Aug 2025 10:57:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A74448E0008; Mon,  4 Aug 2025 10:57:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9232C8E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 10:57:28 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4E3661153DB
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 14:57:28 +0000 (UTC)
X-FDA: 83739378576.30.7706B4E
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4D82DC0014
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 14:57:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=BKh64mG5;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf10.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.221.53 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754319446; a=rsa-sha256;
	cv=none;
	b=e+enTsGpYFJxaPjeReEKcUQ0rxK3722XB+Hy/0jcJR3sNs5VIuems8cgoxwu6fRzhcpJ8P
	pU2wkMbsc+V0s9rIxe2k+3iRYW6Feky0A24ZvceBvYYCpNKpPsS2JkEPN9D5tlhzw/S7r5
	+4bXxWPKUTcm83ImKL9jShoongnli5Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=BKh64mG5;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf10.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.221.53 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754319446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DWy/dRkuyqHtMLkzo0aj79tMC2PsGztysX7VOS/VH8M=;
	b=X/odp7J6F0Xv+VPC7n4CI/9B/1itgkQWdKr823OnGsLpuqnoA4BmE56Me9wx2Uvuo/aGRP
	5l/1gUCLFsAD2lOFGx+GlYn7AAsyKsXowd0k8TvtB9iJ1GwbtrMMOCg5mDRz7FEGVNFZUD
	Wwp+cV8N/1Hk5nL7MK863mOXa8pnMAU=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3b79bdc9a7dso2663073f8f.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 07:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754319444; x=1754924244; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DWy/dRkuyqHtMLkzo0aj79tMC2PsGztysX7VOS/VH8M=;
        b=BKh64mG516p24sqaIkZ+RvFU8vbngbLWU57Hczqm5QtoEF05ZT2N8k0sSbnQ5oLpzx
         7mYEZWJzLNGmCumnELLCDnn4A8rzCum9273l18w8csbAn4niTlAlqaNcg/6iueVe+o1e
         6j4DPOOmBp5yrp8t7eMLY8T2uf5s1YwIO66ettF9ngQWgdT7Zj4IdcJIfSAzARmb6ROX
         L7fJKYlJJhuBMkxtzWpcCY58ptwt5dIUxBmuM+YxyAwIUL6QiMtd147IW2LKJg6AqBre
         R57gvIDC/VQuUES8GzHvwkLO42Db6Sj4/crGZQaHB5dZVAw+WHHqE4Hz+g7t3xQJFxTy
         TPzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754319444; x=1754924244;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DWy/dRkuyqHtMLkzo0aj79tMC2PsGztysX7VOS/VH8M=;
        b=ZSpxDBg+nAITlmcbrTJCkpXP4RY9J0ItRQp6ELIwdnZiotqP5tUjEnNJySqR2zkGYE
         t6P/nn/U3vJ1324cYm3Qi1LBYLThASfLAeuhd0rxBrRuuvo4f9sblaXDtdeUAqGiNoya
         fFXO3L7d94qwLWXF9rbjnbnE8zOEi4kkjM76B3NUI0Yo/t9cKTNkuKdW2urQYCv+OfoB
         uxwiYOZcptONcaqNERnkNaCrC9QMIgKvoodjQ6HnyBQmgZPp5LSGPX6LNOy0OjlgHYyW
         Qq8sarYn1h6pu5g0D/uE/WErS87zTWrTNgpRXMJZX0AD5oHxJIbhvLREqxAihzVUPl4P
         wZJg==
X-Forwarded-Encrypted: i=1; AJvYcCVls3Fuhq2wkHIhWTt9MAxfBp9dVR68WJ3WGoJ9SCmzpHDjuuJijC2Swwt7y/CvtT9hT6LnrkFlPg==@kvack.org
X-Gm-Message-State: AOJu0YwS7JIGul0PRya1U0Q2uKM74Fq6L2ZaCb0FXKAf/pAC1icAkAEA
	7tljm9d6SbfDuQt33cWQcyNBs/nR+hz8fxOxZgLK8iKpGBkgy6WyjKkWuwkGMmPNV4c=
X-Gm-Gg: ASbGnctCOQL5vkq0acBOz3U/GdswvDrY7tPYNVpyecJ3+2m0j7whgvKngYQIUcgrhFy
	McswxPAlTDnY74UcIGbuKTwqa+dciBWV4BcZMkYT/0A8p+G4c5z3xjca0n8ZekX9DXx3agolxBy
	JuIbuh7tYMFmx6CclnNBUsfJo/MtSy0ehn6HCdipVyovNhWMNdx2JCcfvIuw7xOyXBgcKwuXjBc
	H6/h40xxt83KPP+Ryhr/AlGkk8aDwDamb4CrveJpG+A/1myOOn3O6NASCHW3GYoHkV5NUPbzwZG
	MLUZxl8tmf9B79XEkQDB1hzbu5xlbBV3avB1jFScXYT6XlEYSRtz1X9VE4wigPayw1iAl71qe1/
	lcTaydyNU1VlSyoFLy3wQCvHrpz4=
X-Google-Smtp-Source: AGHT+IFBSQjd7GrN3vHaieQbp8tLemMW2ODmKLpx7Wr7bNzMiCgZpwNOOH29qiMwqvVsg4rJZoLGEA==
X-Received: by 2002:a05:6000:22c2:b0:3b7:9141:f044 with SMTP id ffacd0b85a97d-3b8d947507bmr7576626f8f.21.1754319444497;
        Mon, 04 Aug 2025 07:57:24 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c470102sm15695200f8f.53.2025.08.04.07.57.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 07:57:23 -0700 (PDT)
Date: Mon, 4 Aug 2025 17:57:21 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>, linux-nfs@vger.kernel.org,
	linux-block@vger.kernel.org
Cc: linux-rockchip@lists.infradead.org, linux-mm <linux-mm@kvack.org>,
	Netdev <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	lkft-triage@lists.linaro.org,
	Linux Regressions <regressions@lists.linux.dev>,
	Heiko Stuebner <heiko@sntech.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Anders Roxell <anders.roxell@linaro.org>,
	Ben Copeland <benjamin.copeland@linaro.org>
Subject: Re: next-20250717: arm64: rk3399-rock-pi-4b: NFS mount failure with
 64K page size
Message-ID: <54178266-64e5-4869-8359-26f1c8cd14bc@suswa.mountain>
References: <CA+G9fYupPsQoBrtF=-WT0nSy6m+yG1p9m68Z18Bp-Y=QMFD_tQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYupPsQoBrtF=-WT0nSy6m+yG1p9m68Z18Bp-Y=QMFD_tQ@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4D82DC0014
X-Stat-Signature: jhbh4tahj7k6r9u81b6n3q7bacaizqt4
X-Rspam-User: 
X-HE-Tag: 1754319446-905335
X-HE-Meta: U2FsdGVkX19SBQyOON3eFP8SM8oko074cNNiKef8779JNT8Hx0s+e779uI18VmZ1XBi3FokzonvMliinRCfKqMriz/fvySTJ2kJJZv3INbpPVyfV548SjskUQbcNof72dRvwc8CHMzQPVgVOP9De0x77B+YQIyYHqNniv8B6j5/oP3Z8hPx7tlw5+bVJO5fvb0TYSMAtw+yyz2kP61p8C+kCY2ZaLVEEpN26vKtFLaEpyNftN0KZpy0O/DMC9LDMcPD6FI7kGkEo5bS6ZJeQcxrkj+AAwxpqcYz8TL4/ubeOowtAya5TXZBMmMvUwdUAl/sQ0kpa3irdTr8xFP1juKyfsmzXAyidyIw9eV/YFVDiGXLea86gV/NQ8DySjHlT6N3nkqitdcIBnzL4cwJ6cfFFpwg1HePDViF2YguwIQxUQT+13xvtZdjhcxb3D2Ljilpblfs4HfDKSIqrkemRCmbiGRnXlXLXRckD78RglSLfozM26+RfzQZfF9bFL5fJ0aDueCpt4Cmu4hiWJWriJYVd7yPylLos9MGbgbAsvp8DeuI4k23N2FtjO7LcKfu6OBjmB+GA0VWBceNpfwaQ7BfaEGxsMzKQiXhqitQLxuMD2+PjE/NLniVr7KFypNX5xdV+avbvxDn+s7+qTFofmWUtEZbT371RfrMofv+++QmIc3eVFhtfMxDQ1bDNJ2Kf1TWT09nKplfR31ANOvTRSi5u+LQ3Xc5NW6hZe2dT3byGrFT+9rigFIRrqkaq+/fhVOCZjdyH+jWpT3avbZE+j15j4sVdthutSD2w4Ro+sfMLjNp2JJ7UcbP8bHPGoKbcH2MEteuo6gmata3+D0OSSg/l+Mdv/tK+52B+NoA5FwsK4TjsHTHMnh3Q9y7cykBOMDruYUdXr0eF7Zmss2X/t+6f32Q+WXCYqbKUQiQyuklfmrZHkCf+b6JFwqrXbxzVCkH6it+cPGQ8iZTSVIl
 Q92JpYrF
 If5K0xjW60M8IbsL5OYh+vhMfAmjkyc/U5Tbu9WDR1l2+/qfobTTckbDkfwch64/gR+3N9DSq15sFljp8zbWKjOMFUb83RmonXi3Mg7qbyZO+SVNQmfaOFUrtjIF9AhmL0oqoN72sSXNWMNwxIeSnmil2MnCnTlhE3pX+RuyZ3tVckviX864cFWk+o9YVJycWj0hKE28alCLdLItCNSyCcc581f+ERiKdDENU+pwq/G52lOUPMnqRE1iqgdJgjoaC4SrgsXL6UBF5S75mNmqRSgekWdb93OT9WmOyZbX0tQXDB9R+318FkIwxFItqyQp+C1f+xf9ASXHhV5OJccnvFGnusaJFxliq4rVbF9CcEAvyZDHRokYoOfviJKHFV4fVa1EFa608wVldxtZepATbbzFOmOOklQ7/rFkJ3NXkjTxlI/7x35/HymKrpPY+OUHddOFGYqpb3SN63/UcYN3cRpvcDobK46t6eufXxe+erQTWJ+ukfYJeo/iZ2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an ongoing issue still in the latest linux-next.  It's
quite a strange bug because why would it only affect rk3399-rock-pi-4b?

The only thing I see which touched fs/nfs between next-20250716 and
next-20250717 is commit e9d8e2bf2320 ("fs: change write_begin/write_end
interface to take struct kiocb *").  That patch is pretty straight
forward and wouldn't have caused something like this.  Let me add
linux-block to the CC list as well to see if they have any ideas.

regards,
dan carpenter

On Tue, Jul 22, 2025 at 07:59:11PM +0530, Naresh Kamboju wrote:
> The rk3399-rock-pi-4b device fails to mount the root filesystem over
> NFS when the kernel is built with 64K page size.
> CONFIG_ARM64_64K_PAGES=y
> 
> This regression was first observed with the Linux next-20250717 tag
> and continues to persist through next-20250722.
> 
> Device: rk3399-rock-pi-4b
> Build Configuration: lkftconfig-64k_page_size
> 
> Regression Window:
> 
>  Good: next-20250716
>  Bad: next-20250717.. Still Bad: next-20250722
> 
> Kernel Config Impact:
> CONFIG_ARM64_64K_PAGES=y  - NFS mount fails
> CONFIG_ARM64_4K_PAGES=y  - NFS mount works as expected
> 
> Regression Analysis:
> - New regression? Yes
> - Reproducibility? Yes
> 
> Boot regression:  next-20250717 arm64 rk3399-rock-pi-4b NFS mount
> failure with 64K page size
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> ## Boot log
> 
> [    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd034]
> [    0.000000] Linux version 6.16.0-rc6-next-20250717
> (tuxmake@tuxmake) (aarch64-linux-gnu-gcc (Debian 13.3.0-16) 13.3.0,
> GNU ld (GNU Binutils for Debian) 2.44) #1 SMP PREEMPT @1752747461
> [    0.000000] KASLR disabled due to lack of seed
> [    0.000000] Machine model: Radxa ROCK Pi 4B
> [    0.000000] efi: UEFI not found.
> [    0.000000] earlycon: uart0 at MMIO32 0x00000000ff1a0000 (options
> '1500000n8')
> [    0.000000] printk: legacy bootconsole [uart0] enabled
> [    0.000000] OF: reserved mem: Reserved memory: No reserved-memory
> node in the DT
> [    0.000000] NUMA: Faking a node at [mem
> 0x0000000000200000-0x00000000f7ffffff]
> 
> <trim>
> 
> [    6.520442] Sending DHCP requests ..
> [   13.295867] platform sdio-pwrseq: deferred probe pending:
> pwrseq_simple: reset control not ready
> [   13.295887] dwmmc_rockchip fe310000.mmc: IDMAC supports 32-bit address mode.
> [   13.296260] rockchip-pm-domain
> ff310000.power-management:power-controller: sync_state() pending due
> to fe310000.mmc
> [   13.296278] rockchip-pm-domain
> ff310000.power-management:power-controller: sync_state() pending due
> to ff650000.video-codec
> [   13.297085] dwmmc_rockchip fe310000.mmc: Using internal DMA controller.
> [   13.297660] rockchip-pm-domain
> ff310000.power-management:power-controller: sync_state() pending due
> to ff660000.video-codec
> [   13.298653] dwmmc_rockchip fe310000.mmc: Version ID is 270a
> [   13.299536] rockchip-pm-domain
> ff310000.power-management:power-controller: sync_state() pending due
> to ff680000.rga
> [   13.300164] dwmmc_rockchip fe310000.mmc: DW MMC controller at irq
> 49,32 bit host data width,256 deep fifo
> [   13.301117] rockchip-pm-domain
> ff310000.power-management:power-controller: sync_state() pending due
> to ff880000.i2s
> [   13.304227] rockchip-pm-domain
> ff310000.power-management:power-controller: sync_state() pending due
> to ff8a0000.i2s
> [   13.305148] rockchip-pm-domain
> ff310000.power-management:power-controller: sync_state() pending due
> to ff8f0000.vop
> [   13.306071] rockchip-pm-domain
> ff310000.power-management:power-controller: sync_state() pending due
> to ff900000.vop
> [   13.307009] rockchip-pm-domain
> ff310000.power-management:power-controller: sync_state() pending due
> to ff940000.hdmi
> [   13.307937] rockchip-pm-domain
> ff310000.power-management:power-controller: sync_state() pending due
> to ff9a0000.gpu
> [   14.620509] ., OK
> [   14.636949] IP-Config: Got DHCP answer from 10.66.16.15, my address
> is 10.66.30.7
> [   14.637647] IP-Config: Complete:
> [   14.637955]      device=eth0, hwaddr=0a:fb:82:cd:ed:a8,
> ipaddr=10.66.30.7, mask=255.255.240.0, gw=10.66.16.1
> [   14.638845]      host=10.66.30.7, domain=lkftlab, nis-domain=(none)
> [   14.639417]      bootserver=0.0.0.0, rootserver=10.66.16.116, rootpath=
> [   14.639440]      nameserver0=10.66.16.15
> [   14.641679] clk: Disabling unused clocks
> [   14.646347] dw-apb-uart ff1a0000.serial: forbid DMA for kernel console
> [   14.647091] check access for rdinit=/init failed: -2, ignoring
> [   14.762496] VFS: Mounted root (nfs filesystem) on device 0:22.
> [   14.763768] devtmpfs: mounted
> [   14.775761] Freeing unused kernel memory: 4928K
> [   14.776566] Run /sbin/init as init process
> [   95.816464] random: crng init done
> [  195.556677] nfs: server 10.66.16.116 not responding, still trying
> ..
> [  195.556703] nfs: server 10.66.16.116 not responding, still trying
> [  195.556869] nfs: server 10.66.16.116 not responding, still trying
> [  195.557010] nfs: server 10.66.16.116 not responding, still trying
> [  195.557055] nfs: server 10.66.16.116 not responding, still trying
> [  195.557114] nfs: server 10.66.16.116 not responding, still trying
> [  195.557166] nfs: server 10.66.16.116 not responding, still trying
> [  195.557217] nfs: server 10.66.16.116 not responding, still trying
> [  195.557269] nfs: server 10.66.16.116 not responding, still trying
> [  195.557304] nfs: server 10.66.16.116 not responding, still trying
> [  227.459759] nfs: server 10.66.16.116 OK
> [  227.459868] nfs: server 10.66.16.116 OK
> [  227.681008] nfs: server 10.66.16.116 OK
> [  319.645474] nfs: server 10.66.16.116 OK
> [  407.677657] nfs: server 10.66.16.116 OK
> [  499.834818] nfs: server 10.66.16.116 OK
> [  587.895692] nfs: server 10.66.16.116 OK
> [  680.052774] nfs: server 10.66.16.116 OK
> [  768.113810] nfs: server 10.66.16.116 OK
> [  860.270785] nfs: server 10.66.16.116 OK
> #
> [  948.331418] nfs: server 10.66.16.116 OK
> #
> [ 1096.679211] nfs: server 10.66.16.116 OK
> #
> [ 1274.856436] nfs: server 10.66.16.116 OK
> #
> [ 1488.985700] nfs: server 10.66.16.116 OK
> 
> 
> ## Source
> * Git tree: https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next.git
> * Project: https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250717/
> * Git sha: 024e09e444bd2b06aee9d1f3fe7b313c7a2df1bb
> * Git describe: 6.16.0-rc6-next-20250717
> * kernel version: next-20250717
> * Architectures: arm64 (rock-pi-4b)
> * Toolchains: gcc-13
> * Kconfigs: defconfig+64K page size
> 
> ## Test
> * Test log: https://qa-reports.linaro.org/api/testruns/29168904/log_file/
> * Test LAVA: https://lkft.validation.linaro.org/scheduler/job/8364278#L924
> * Test run: https://regressions.linaro.org/lkft/linux-next-master/next-20250717/testruns/1662101/
> * Test plan: https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/2zzwHDuV3xvZBKkAtqlmroSxuIS
> * Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2zzwEbz0aS3AtluE2oRQ9gMvFTY/
> * Kernel config:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2zzwEbz0aS3AtluE2oRQ9gMvFTY/config
> 
> 
> --
> Linaro LKFT
> https://lkft.linaro.org

