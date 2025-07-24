Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30830C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 13:56:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB3296B02C0; Thu, 24 Jul 2025 09:56:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8AEE6B02C1; Thu, 24 Jul 2025 09:56:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A02D6B02C3; Thu, 24 Jul 2025 09:56:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 80C8B6B02C0
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:56:24 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0A6E513328F
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:24 +0000 (UTC)
X-FDA: 83699307888.16.AC39E58
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf01.hostedemail.com (Postfix) with ESMTP id 199E840012
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=qJAvPUfF;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf01.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.47 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753365382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=doj4VgkcPMuCm07rkZxbId/BUVze9/Fe8T+2B7NuuHU=;
	b=kjRti9pH4ZxTKhNc10PNFjSKy4LF2t6P+IKZ88pXYojYWdObj6gKZbaai66k5xKxXh6C/Y
	9BY6WXg9MceZU2mIDCRXKJjnS8Q8KJzH+JdO6yhT5Vdft+YCBHt6IVZpx296IzeVXjGD/M
	T9ckHDJzG5CdiHUGN1RwwP35LwV8B1I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753365382; a=rsa-sha256;
	cv=none;
	b=Kr0x0eHF0FpBvci/gevG9XJapuqY+XnwX0UhPaq/NMZyH9jORFU8A2v9k42N7ZnL/g2HTs
	X5lk/xoTErooC98KVXuiOHj91KfXPqXHCy99hB347b8Moq34c33npBVmzdLy6mJ8NlcV7v
	K/cWUzVSvBovR1VROJVo9bnrGSCTLXc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=qJAvPUfF;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf01.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.47 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-456108bf94bso6525985e9.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753365380; x=1753970180; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=doj4VgkcPMuCm07rkZxbId/BUVze9/Fe8T+2B7NuuHU=;
        b=qJAvPUfFQC555pwlybjRpMdCJnYy8wK3u28gfTw6EndVIzcNXOu+K4PO3ILaDekXgT
         dQxaJdwXghc1QYq1y0rgcvUI2LpbqTY1FJsZ57dXzRQ2eWOhP7y9ExGHB2S4lCRH9JU+
         YT74BVIay3Xv4AQDu+3dTe7fPn0XXBBI6atCQSyXTouorpQjkiw2nC4S89qaDGM9II4k
         hnadiuBBDcvC3aNEiB0Ydx5CqZXqP1FCecE2yLkqzIOeT7NTwrJwU0sBEXjRNhUpnNfy
         L4pT0JUGQIkWTo+NqIB+NDGZ3/H57rRHrolKNk3lQdzjKd/So+i7NZLNquzK4Arvp8uv
         TONA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753365380; x=1753970180;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=doj4VgkcPMuCm07rkZxbId/BUVze9/Fe8T+2B7NuuHU=;
        b=R8q9CGP8ogjlUr2WKvqpykzdeg6GVnK+Dwtfvy1Q0Q/7aU/kC1xrFrEjHHvavQ+eEZ
         C7FdU5+ALZ6yM1WuShQU8B3kDC0KBMG0sC5GmY5hGF0sfefAN1mygVJ8Rh/Yi/gpnkJZ
         allDZHjQz5KTDPJrXS40VHZg8NpRaIXCCKS9ACdu8PIawd0A/LjicQmgYpZ89IfMWS/h
         Ni+8YGiydHPI4czu/+RH9eHt04jkVaYklpWO3rLlMkSlEiWh1dIOUr0d6wdDIanYJCYz
         bAbdp8hgl2/hhNhUt2y+r4HK4501zGnWkccgLGDeVrFTSdY4IOXBWFamUgGriF8BNgSF
         Km2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWJv545RuZqFZzKgW08idGbA6RqaFANFLM4D8uWeyWh6w5R/WuYcY4MGbcWVLfs/5WRlo4xy73G7g==@kvack.org
X-Gm-Message-State: AOJu0YxuEDEGBX5Z7kMoy/QflRmziNQq8JjtHjmYuCz5oVzj8p/dNQbn
	ziD3iGDfFOevlAsDDg+Sjr2PSlv7E3IFrH/0OoubpC23kknJDlINW5p83PKyoi9mjmI=
X-Gm-Gg: ASbGncuNbHEhVq8pK4JtS8ixWsJf+HoAaBek8tGjCJNU8+hCF9xc5KWS6zSFQQEkq/c
	f5c3OOMXrCJVRKJXlvNRMRQsBlqVow21FrLvQaSJsXUfHWVnoSDI6LRKGDLh4WRWHFl5Y/lij6J
	OB9kdgkgPs6iNgf624xV3OQ8sG2MwasOqb92vFjncyAC+3QlOu1NlWuxYfOubFAg/HPOnwUAsLb
	JlDDHw2oczo6PuTIToiTAukQHDTcP6ngkxjyk6Ahy9qXhZgH4lbq/dxi8W+VG6B21prnkTKXUMi
	hRdVag78vn6Aru3E9QlAbwi3umypqi78r6deXbQlumrnB7Nww2w3pMVwoAzr21PQnuncgGyT6dS
	tJ+Y+jgsVvJ7Fj73VuG0OB9OTSsTZPPQXNhNt4FE/LxFLLtynyH17/ykhRoz7H3sHiQ+5bn3XIA
	VKZwDECInT2zqn
X-Google-Smtp-Source: AGHT+IEgB2qGK5rHK/xrXroIqjpgxM1xiUoTO/MHHfQIsCwn5d+nXDbe5Qo7CYSHLXnX07gaTNJQKQ==
X-Received: by 2002:a05:6000:4026:b0:3a6:d26a:f0f5 with SMTP id ffacd0b85a97d-3b768ea0591mr7040730f8f.21.1753365380179;
        Thu, 24 Jul 2025 06:56:20 -0700 (PDT)
Received: from eugen-station.. (cpc148880-bexl9-2-0-cust354.2-3.cable.virginm.net. [82.11.253.99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054e37dsm20889375e9.14.2025.07.24.06.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 06:56:19 -0700 (PDT)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	eugen.hristev@linaro.org,
	corbet@lwn.net,
	mojha@qti.qualcomm.com,
	rostedt@goodmis.org,
	jonechou@google.com,
	tudor.ambarus@linaro.org
Subject: [RFC][PATCH v2 00/29] introduce kmemdump
Date: Thu, 24 Jul 2025 16:54:43 +0300
Message-ID: <20250724135512.518487-1-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 199E840012
X-Stat-Signature: 9ge6r6wcofxbhrhdbakwrfc6qszmr8qk
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753365381-582896
X-HE-Meta: U2FsdGVkX18m33LVCDsdHwsmWGto8/wYnWqz8Ltp1k/daRsXpLB14RCZoEgfS87YCZ+hu4UCYfZGS0D1wGfnHw0otYwk/Hn3EzOdEAHP+NaK12mJo74c2AeOpjYBeQegfluz7EqIk6fyJEFsdz5ok3AHuzol4jw+Pck58hy1VCk3KeoM9KxRaBALCGa9xHf4CvA4a79PYVTVaPaG1mhKQg7xxEywGmtPXV6UoZmqPql3+Gpu62d0j2ho1pQ3gZrbnDhnM0+e36WNSkhG591XfIEwnL7eGy0HHCBb18qqcrpvjKwUzVjbxb55uiKKwUjSvctiKc0oschZKEnBe3Rpv+E72oTRiwxBC9u4yEHYsEw8NqKf1ECx4/NSgZLrLzKK2p1Mtys/5nwk/2nCMp1+tUeYR45rdxEjhb4MuilrseI7JJlmGGAuLnqVlZulP5q07qziUYi58xJWcHmKsiD50oYxJuK9fsujbjXqUpZkju4dBReNKKyBG6FtUARnq3b9+TUU/xajWLv9MEhUgS73GlOhRsMEyjofZMuZ68mJ8l40b5xM1VVoWGte4EOx4Cf/agtDnd7t8euFO3D59MlZnv/ywK2hW48mtsWyBifVth5A7Wp3J5jRb6/xjQqlW8gCrKq4UlpV4Kc4trqiFog1e1rhFXNYe6c8aKHysuqNS7crqCDtNVyA1BM8z2hU8zOqAexTRKgCO2z8jmWkLc/tbLXLGtAS6yENc8QbIKq1chK17vpzRlHng0aff90phzzHgqRqL7c7Q8XmpvL8xu1PzcLbq8uTxZAO1F0Rhrh7zQyjpJ02jVlPd2o5I09qIWAOpD3/QvZp75NYsqniJLxDSqMRJAmHjyyV9mWpmJhYDQlHy1aAy0mwjXewCZRcl7c2tNccYkVgfWkPtjYtl3f/bl7f7mLzWUhSTkEfqscZgRQ4AbfkDzSouFy1vYQSvSEjfg7oSTLt2I8vDsz+Wf3
 jOMULlxs
 LP1UPAoVpHGtfIOMhIUHAgfd3TjTCch79YXRb39CBRmmb3W9x3V5/Wkpua3zmYhP2Axa68S3TE71Tz622MpJ3UJIa7DxTEILaz3ZHsHgQK8QQbaDNt966u9zjpin6bOOIL9I9xMWNqAdp58cFIk06YBckFSANIb1OkBtI27OZPorGp2KQ3osUiSugkZLopTbuejfyiQSMNuDj3kaPBgW0tSzm3Tt3zqb1LP4wK2RFTuFKCxDY6cWiI2JYBJ+h0lWK1TRgZtwjPq6AY4gJ3iQJSc0dWjS5y4RuWdPHjYYFLBKAjtCHIHqx3B9/W8w03d/4VyFH9T74d+TDMvdlutaY3SbJ0LyxyV+wB1b12KFn3B7+V8oKOGFOsKkueyf9/BuIKbtTPbOcUsZNpDozwtPRxXGA1QIWMvfOXHqeBP5vdytMMMEVo5SRkMfx+R4bD+zCQMblRY/75TR7QUXaTadXx39a8779LD/F8h20795zs5BjteTH4isWrVrCRYwt5SR85ZCGsggb3rMNOH/3pYl1rcLbyfNRC0jY5mIc7ntE2XiFmrkgi5SBAKjl5ianQdmmPsVC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmemdump is a mechanism which allows the kernel to mark specific memory
areas for dumping or specific backend usage.
Once regions are marked, kmemdump keeps an internal list with the regions
and registers them in the backend.
Further, depending on the backend driver, these regions can be dumped using
firmware or different hardware block.
Regions being marked beforehand, when the system is up and running, there
is no need nor dependency on a panic handler, or a working kernel that can
dump the debug information.
The kmemdump approach works when pstore, kdump, or another mechanism do not.
Pstore relies on persistent storage, a dedicated RAM area or flash, which
has the disadvantage of having the memory reserved all the time, or another
specific non volatile memory. Some devices cannot keep the RAM contents on
reboot so ramoops does not work. Some devices do not allow kexec to run
another kernel to debug the crashed one.
For such devices, that have another mechanism to help debugging, like
firmware, kmemdump is a viable solution.

kmemdump can create a core image, similar with /proc/vmcore, with only
the registered regions included. This can be loaded into crash tool/gdb and
analyzed.
To have this working, specific information from the kernel is registered,
and this is done at kmemdump init time, no need for the kmemdump user to
do anything.

This version of the kmemdump patch series includes two backend drivers:
one is the Qualcomm Minidump backend, and the other one is the Debug Kinfo
backend for Android devices, reworked from this source here:
https://android.googlesource.com/kernel/common/+/refs/heads/android-mainline/drivers/android/debug_kinfo.c
written originally by Jone Chou <jonechou@google.com>

Initial version of kmemdump and discussion is available here:
https://lore.kernel.org/lkml/20250422113156.575971-1-eugen.hristev@linaro.org/

Kmemdump has been presented and discussed at Linaro Connect 2025,
including motivation, scope, usability and feasability.
Video of the recording is available here for anyone interested:
https://www.youtube.com/watch?v=r4gII7MX9zQ&list=PLKZSArYQptsODycGiE0XZdVovzAwYNwtK&index=14

The implementation is based on the initial Pstore/directly mapped zones
published as an RFC here:
https://lore.kernel.org/all/20250217101706.2104498-1-eugen.hristev@linaro.org/

The back-end implementation for qcom_minidump is based on the minidump
patch series and driver written by Mukesh Ojha, thanks:
https://lore.kernel.org/lkml/20240131110837.14218-1-quic_mojha@quicinc.com/

*** How to use kmemdump with minidump backend on Qualcomm platform guide ***

Prerequisites:
Crash tool with target=ARM64 and minor changes required for usual crash mode
(minimal mode works without the patch)
A patch can be applied from here https://p.calebs.dev/49a048
This patch will be eventually sent in a reworked way to crash tool.

Target kernel must be built with :
CONFIG_DEBUG_INFO_REDUCED=n ; this will have vmlinux include all the debugging
information needed for crash tool.

Otherwise, the kernel requires these as well:
CONFIG_KMEMDUMP, CONFIG_KMEMDUMP_COREIMAGE, and the backend
CONFIG_KMEMDUMP_QCOM_MINIDUMP_BACKEND

Kernel arguments:
Kernel firmware must be set to mode 'mini' by kernel module parameter
like this : qcom_scm.download_mode=mini

After the kernel boots, and qcom_minidump module is loaded, everything is ready for
a possible crash.

Once the crash happens, the firmware will kick in and you will see on
the console the message saying Sahara init, etc, that the firmware is
waiting in download mode. (this is subject to firmware supporting this
mode, I am using sa8775p-ride board)

Example of log on the console:
"
[...]
B -   1096414 - usb: init start
B -   1100287 - usb: qusb_dci_platform , 0x19
B -   1105686 - usb: usb3phy: PRIM success: lane_A , 0x60
B -   1107455 - usb: usb2phy: PRIM success , 0x4
B -   1112670 - usb: dci, chgr_type_det_err
B -   1117154 - usb: ID:0x260, value: 0x4
B -   1121942 - usb: ID:0x108, value: 0x1d90
B -   1124992 - usb: timer_start , 0x4c4b40
B -   1129140 - usb: vbus_det_pm_unavail
B -   1133136 - usb: ID:0x252, value: 0x4
B -   1148874 - usb: SUPER , 0x900e
B -   1275510 - usb: SUPER , 0x900e
B -   1388970 - usb: ID:0x20d, value: 0x0
B -   1411113 - usb: ENUM success
B -   1411113 - Sahara Init
B -   1414285 - Sahara Open
"

Once the board is in download mode, you can use the qdl tool (I
personally use edl , have not tried qdl yet), to get all the regions as
separate files.
The tool from the host computer will list the regions in the order they
were downloaded.

Once you have all the files simply use `cat` to put them all together,
in the order of the indexes.
For my kernel config and setup, here is my cat command : (you can use a script
or something, I haven't done that so far):

`cat memory/md_KELF1.BIN memory/md_Kvmcorein2.BIN memory/md_Kconfig3.BIN \
memory/md_Kmemsect4.BIN memory/md_Ktotalram5.BIN memory/md_Kcpu_poss6.BIN \
memory/md_Kcpu_pres7.BIN memory/md_Kcpu_onli8.BIN memory/md_Kcpu_acti9.BIN \
memory/md_Kjiffies10.BIN memory/md_Klinux_ba11.BIN memory/md_Knr_threa12.BIN \
 memory/md_Knr_irqs13.BIN memory/md_Ktainted_14.BIN memory/md_Ktaint_fl15.BIN \
memory/md_Kmem_sect16.BIN memory/md_Knode_dat17.BIN memory/md_Knode_sta18.BIN \
memory/md_K__per_cp19.BIN memory/md_Knr_swapf20.BIN memory/md_Kinit_uts21.BIN \
memory/md_Kprintk_r22.BIN memory/md_Kprintk_r23.BIN memory/md_Kprb24.BIN \
memory/md_Kprb_desc25.BIN memory/md_Kprb_info26.BIN memory/md_Kprb_data27.BIN \
memory/md_Krunqueue28.BIN memory/md_Khigh_mem29.BIN memory/md_Kinit_mm30.BIN \
memory/md_Kinit_mm_31.BIN memory/md_Kunknown32.BIN memory/md_Kunknown33.BIN \
memory/md_Kunknown34.BIN  memory/md_Kunknown35.BIN memory/md_Kunknown36.BIN \
memory/md_Kunknown37.BIN memory/md_Kunknown38.BIN memory/md_Kunknown39.BIN \
memory/md_Kunknown40.BIN memory/md_Kunknown41.BIN memory/md_Kunknown42.BIN \
memory/md_Kunknown43.BIN memory/md_Kunknown44.BIN memory/md_Kunknown45.BIN \
memory/md_Kunknown46.BIN memory/md_Kunknown47.BIN  memory/md_Kunknown50.BIN \
memory/md_Kunknown51.BIN memory/md_Kunknown52.BIN \
memory/md_Kunknown53.BIN > ~/minidump_image`

Once you have the resulted file, use `crash` tool to load it, like this:
`./crash --no_modules --no_panic --no_kmem_cache --zero_excluded vmlinux minidump_image`

There is also a --minimal mode for ./crash that would work without any patch applied
to crash tool, but you can't inspect symbols, etc.

Once you load crash you will see something like this :

   KERNEL: /home/eugen/linux-minidump/vmlinux  [TAINTED]
    DUMPFILE: /home/eugen/new
        CPUS: 8 [OFFLINE: 7]
        DATE: Thu Jan  1 02:00:00 EET 1970
      UPTIME: 00:00:29
       TASKS: 0
    NODENAME: qemuarm64
     RELEASE: 6.16.0-rc7-next-20250721-00029-gf8cffdbf0479-dirty
     VERSION: #5 SMP PREEMPT Tue Jul 22 18:44:57 EEST 2025
     MACHINE: aarch64  (unknown Mhz)
      MEMORY: 34.2 GB
       PANIC: ""
crash> log
[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd4b2]
[    0.000000] Linux version 6.16.0-rc7-next-20250721-00029-gf8cffdbf0479-dirty (eugen@eugen-station) (aarch64-none-linux-gnu-gcc (Arm GNU Toolchain 13.3.Rel1 (Build arm-13.24)) 13.3.1 20240614, GNU ld (Arm GNU Toolchain 13.3.Rel1 (Build arm-13.24)) 2.42.0.20240614) #5 SMP PREEMPT Tue Jul 22 18:44:57 EEST 2025


*** Debug Kinfo backend driver ***
I don't have any device to actually test this. So I have not.
I hacked the driver to just use a kmalloc'ed area to save things instead
of the shared memory, and dumped everything there and checked whether it looks
sane. If someone is willing to try it out, thanks ! and let me know.
I know there is no binding documentation for the compatible either.

Thanks for everyone reviewing and bringing ideas into the discussion.

Eugen

Changelog since the v1 of the RFC:
- Reworked the whole minidump implementation based on suggestions from Thomas Gleixner.
This means new API, macros, new way to store the regions inside kmemdump
(ditched the IDR, moved to static allocation, have a static default backend, etc)
- Reworked qcom_minidump driver based on review from Bjorn Andersson
- Reworked printk log buffer registration based on review from Petr Mladek

I appologize if I missed any review comments. I know there is still lots of work
on this series and hope I will improve it more and more.
Patches are sent on top of next-20250721

Eugen Hristev (29):
  kmemdump: introduce kmemdump
  Documentation: add kmemdump
  kmemdump: add coreimage ELF layer
  Documentation: kmemdump: add section for coreimage ELF
  kmemdump: introduce qcom-minidump backend driver
  soc: qcom: smem: add minidump device
  init/version: Annotate static information into Kmemdump
  cpu: Annotate static information into Kmemdump
  genirq/irqdesc: Annotate static information into Kmemdump
  panic: Annotate static information into Kmemdump
  sched/core: Annotate static information into Kmemdump
  timers: Annotate static information into Kmemdump
  kernel/fork: Annotate static information into Kmemdump
  mm/page_alloc: Annotate static information into Kmemdump
  mm/init-mm: Annotate static information into Kmemdump
  mm/show_mem: Annotate static information into Kmemdump
  mm/swapfile: Annotate static information into Kmemdump
  mm/percpu: Annotate static information into Kmemdump
  mm/mm_init: Annotate static information into Kmemdump
  printk: Register information into Kmemdump
  kernel/configs: Register dynamic information into Kmemdump
  mm/numa: Register information into Kmemdump
  mm/sparse: Register information into Kmemdump
  kernel/vmcore_info: Register dynamic information into Kmemdump
  kmemdump: Add additional symbols to the coreimage
  init/version: Annotate init uts name separately into Kmemdump
  kallsyms: Annotate static information into Kmemdump
  mm/init-mm: Annotate additional information into Kmemdump
  kmemdump: Add Kinfo backend driver

 Documentation/debug/index.rst      |  17 ++
 Documentation/debug/kmemdump.rst   | 104 +++++++++
 MAINTAINERS                        |  18 ++
 drivers/Kconfig                    |   4 +
 drivers/Makefile                   |   2 +
 drivers/debug/Kconfig              |  55 +++++
 drivers/debug/Makefile             |   6 +
 drivers/debug/kinfo.c              | 304 +++++++++++++++++++++++++
 drivers/debug/kmemdump.c           | 239 +++++++++++++++++++
 drivers/debug/kmemdump_coreimage.c | 223 ++++++++++++++++++
 drivers/debug/qcom_minidump.c      | 353 +++++++++++++++++++++++++++++
 drivers/soc/qcom/smem.c            |  10 +
 include/asm-generic/vmlinux.lds.h  |  13 ++
 include/linux/kmemdump.h           | 219 ++++++++++++++++++
 init/version.c                     |   6 +
 kernel/configs.c                   |   6 +
 kernel/cpu.c                       |   5 +
 kernel/fork.c                      |   2 +
 kernel/irq/irqdesc.c               |   2 +
 kernel/kallsyms.c                  |  10 +
 kernel/panic.c                     |   4 +
 kernel/printk/printk.c             |  28 ++-
 kernel/sched/core.c                |   2 +
 kernel/time/timer.c                |   3 +-
 kernel/vmcore_info.c               |   3 +
 mm/init-mm.c                       |  12 +
 mm/mm_init.c                       |   2 +
 mm/numa.c                          |   5 +-
 mm/page_alloc.c                    |   2 +
 mm/percpu.c                        |   3 +
 mm/show_mem.c                      |   2 +
 mm/sparse.c                        |  16 +-
 mm/swapfile.c                      |   2 +
 33 files changed, 1670 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/debug/index.rst
 create mode 100644 Documentation/debug/kmemdump.rst
 create mode 100644 drivers/debug/Kconfig
 create mode 100644 drivers/debug/Makefile
 create mode 100644 drivers/debug/kinfo.c
 create mode 100644 drivers/debug/kmemdump.c
 create mode 100644 drivers/debug/kmemdump_coreimage.c
 create mode 100644 drivers/debug/qcom_minidump.c
 create mode 100644 include/linux/kmemdump.h

-- 
2.43.0


