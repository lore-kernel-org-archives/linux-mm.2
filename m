Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA881CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 15:09:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AD346B0010; Fri, 12 Sep 2025 11:09:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 185436B0011; Fri, 12 Sep 2025 11:09:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09B206B0023; Fri, 12 Sep 2025 11:09:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E836B6B0010
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:09:51 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9F9245960E
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:09:51 +0000 (UTC)
X-FDA: 83880932982.11.62362E6
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9E2E420012
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:09:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=MAroMtIN;
	spf=pass (imf03.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.180 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757689789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ciXEF3yj4Lhs1v5bdpaxN7WP4kdTK7y/5arAKjXtWCw=;
	b=mJp/fOb9qcbZulni/OXjR+vEHfWgdmZ6PobzNiX23fdHuwGvHgUpEGTwmov3JUhV4vVtqs
	1Yoh6r1rFuhfg03qv1RFnhNSVo3qQhKmOkk3d8+oz1fu3RBvDGIYAoGXoTq5s3UPyyEg1L
	GZ0UDoZSdktnIlML+c0cOG8OIY8wVic=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=MAroMtIN;
	spf=pass (imf03.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.180 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757689789; a=rsa-sha256;
	cv=none;
	b=2YczBMKlmGD8VcktC2FCLiEguDcuYzO08WlOKKkfT7ZByMSIcQOxDCOBP+pujGdZiHrxaU
	LcLgMM8D0upkcnMSkH3vBfHXDiDDMH0B6Vb+cYXz+vAfxnQCNk42c5rgqxysICa7+zgI/H
	baDdc6mkdj4kKhnFAgl+ipIyG40Tv90=
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-71d71bcab6fso18109557b3.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757689788; x=1758294588; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ciXEF3yj4Lhs1v5bdpaxN7WP4kdTK7y/5arAKjXtWCw=;
        b=MAroMtIN45ObHH4cz0VNjmDgDBK1NrjAqJidpCxfmxc2s21EU3v9/6muCTFZvdMGFE
         UIvmxdMtb4mbVKH4WDG4yCAM42Nehx9MKlBEFdAzYyjMV87NBMoGy1rzDjf7ncpaH3nq
         xbQd3iOdConubD6gMgbYMovKdFfuyli05RyetCqBiJpytvevpn59TwY1uVwCJkcbsWgp
         cefweHOrv9oxssH4cDYXI+jAaHI4AwD9DhXGMJWDZxWkgsl2tfjEkoPwVqYxprT91JIO
         GqGPSJJwv8Y09m6MjEJU50unkDHX+6V6TiLR+91PCTUw9eJVSZ8ok8Li/ZU7Ceq0P4s1
         eXqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757689789; x=1758294589;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ciXEF3yj4Lhs1v5bdpaxN7WP4kdTK7y/5arAKjXtWCw=;
        b=c7zHNAA58jS5YoGupNgMDaVJhnLIfbCepio09AmcuotBLxE2gZaRsEVfqjsQl75chX
         p0kbVGVUHmq69AsHSN0wKC0fDq0d/j5ud+g/x4iwhAqCeHjI6T9/JwfyB9iF6dhHn025
         zKGq8IFcEAAm6UXqWU9KMtPjGFqTH11+mbQIIf95S9NiqC2Cq4VDScOdiWaSMIq7dkZx
         XGKlVwMyX5377HpDjtb9rmCqf3RHjq6EL2DVkn6/CISqbckVhym3BqbMnkdlEX9NJaL9
         6wMRN0vwQGN8swZVrPdhndYq9AhaR9JHtn0523dz0jm5FOC6BuO3EKBJUvLh8cwO9J4o
         gehg==
X-Forwarded-Encrypted: i=1; AJvYcCWlmR4rfRyR3/YvdnNyrPc5IBVAFm6Wjy6lnshqu5CIHE/XNMI0bRqFP2nrxqMhFHiVbg6jWKsrUw==@kvack.org
X-Gm-Message-State: AOJu0Yw0K148BxaRll1PQF6A8xB1IFosK43ts9tiCmuVw8RFy76uv2Mn
	ol133+oZkZPn98adUE8TeGvmOOEjxgxufsxDTstSmCYL8dLewN6ScfY/5FTwEOb9RKs=
X-Gm-Gg: ASbGncu3ZFgy/yCjuwFbxkhOCZOyGNRHjUrsufw0U+bQGHr1FfqqAs45tAPjW1EtEco
	iXWeBzuFeWP1CLIFnCaDOjNVmhS8qlQXYv0oJ70VY0TpruFeLDozBijF6WtwggO10GAIWM/81pH
	ZnNV4kELLaEAzCa09CD2hEcf86En8IBQg6BXgZXdOEEhUIL0vi8RZx0KgqP9QUn6MU+uyQBPnF4
	F6A7Jx2YBKqXwm5CB+6HyPgjHqFRiA4Wk9Ov2jIGazjWaBSJtFnSt2xxm0LVei3UixKUN1UmPeS
	LaARCCFyaEu4s/NbcSoMNdoNQw5JHzPpfahuIH5Uh9DHwUv9wQAxylSUl5SYYocYDbwwncHFuT1
	5CySGTvxDrhYy00UXM61qzDBwe63PAuxRiA==
X-Google-Smtp-Source: AGHT+IGbJnDOS2zesllhdbgpyWZwl3dW85Jzp55IkVX5D1wGuLzxnbfwHrDY3M5ahozd5m3Z5Y7A5g==
X-Received: by 2002:a05:690c:f04:b0:728:c4d2:87f with SMTP id 00721157ae682-730659bd0bdmr29325817b3.38.1757689788280;
        Fri, 12 Sep 2025 08:09:48 -0700 (PDT)
Received: from eugen-station.. ([145.224.119.89])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-624841586c1sm1302244d50.6.2025.09.12.08.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 08:09:47 -0700 (PDT)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com,
	rdunlap@infradead.org,
	corbet@lwn.net,
	david@redhat.com,
	mhocko@suse.com
Cc: tudor.ambarus@linaro.org,
	mukesh.ojha@oss.qualcomm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	jonechou@google.com,
	rostedt@goodmis.org,
	linux-doc@vger.kernel.org,
	devicetree@vger.kernel.org,
	Eugen Hristev <eugen.hristev@linaro.org>
Subject: [RFC][PATCH v3 00/16] Introduce kmemdump
Date: Fri, 12 Sep 2025 18:08:39 +0300
Message-ID: <20250912150855.2901211-1-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 38d4p8sj4c5das8a7cqoe547fxfqmddt
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E2E420012
X-Rspamd-Server: rspam04
X-HE-Tag: 1757689789-564262
X-HE-Meta: U2FsdGVkX1+XDi3+YdOiUWhhHTNIyLG0mw4JmOUTggJVdEs1cOo4lpUWs3z4Ty0b7v6bDc6UNA42bnoPxfdK/IOIJirYoEp0BF9pvXxrBeaqIqzrRhZqNi1hofp1KOqOcpBqneh4QmSM6bH2T4kv/hCUTEW0hQ/4R3K6UKjnh1DlnYGbdVwVfR3sM+jn51zhEGtJShpns1bh6JVMM3G6DOQYiCB0ZQBKoQ/ziqqXzePnSBi4J4pUqmTgvXSOlFtfDjXW+H883r0nmRKj2NAB0nfIQFDdfVn5QF/jeSqu5YJ+tqiZyd8f1FVBgR+vkS3VvVmmPwW2sb9/cDE7o3141MDZ+Tw/B7izLSCUuSkxf0gEuvTqucSZNDYF0q9qT8tRKkkQRgu6+IRYRxiVQFqxtAlBSEqoOmZEdk8S1WnaM9jRNoXNMP8cPt4Bald5urvRd5ROrNck+phOVtCVq02ZamkNfM0++WVT+erI7UOEVzCpOjp64uyJej1xY1BkhWfwinfMt+FXhqpGAlT+8kJyV9TWXy1bKjJG7AsYY3m7HINwXnPF8XXh9ed8uBgKg3OZNVUykehcnvGJFy27aAMrDqq3Kd5/Oe+kPx1mgRzyyYlFrFNJvKa4Y2QExx9S9AZZf5qibuqyWo5CpzEwJFuj4E41cOqKkIqeMu9Opd+GBnndAM+K8pK2P5I01qbczCMsbJQIZGONev4PaCLrdGydbcOc3sUKA76/BZ+la6L2yW9Y1z2h2ObOGl36j8Z3ZHlpjwj5dlE/DVldL1AquCpiDcUfuT4+fY4Lw/yoR3hNSnMNacww+nqLn8avSMbNMutXpphnGKwhovfYk10EYoqo4kYV87eT5qozikiJGmrrdHKUjxVLmLEdNFcPQL5sza5IB+QC7+MKN/gZ2i8orMGHPHfhsUVqyYgvn7f9fps75wF3rAmr/2Dp2Jq538WxikN6GO1GzTnJFcx14xY3Mgm
 cx5pKmwN
 T54YeBLFwtBs9RKYw3v9a5rn+GzZEu1NQTpPqIJ3g1Uu/xAylNrUJvf1Six2iuicEZdiIce0+Cd9beoX+aKbd9/mXC3dffx5KymdRqVwEMne84bVSEgaPudGQzfma2LzdaWmFQ6FCrUJ20AeLfjAAGUJ4elihqqBMBwNK4/gGfOas2PYayYtdZetacYjeiOFM+h9LNUD3BmHFn8TQaptWOfoEogoaUIr1VnuQcqWXrtZv40EvnPTcu9Ioxoa2NBrb/CR9hw38ijMpelttAKW0fFLkuVg3dNLTRNCgZIgjaLif5teerGfL9bEqztrFD8x0gAPmwvlIJBlt9PPd53wC8NpBhispXr7VpTOXBHz4ofFrNz9vwiCcReWHApgIg+p0XvaB+izVgXeMDZjH5P20Dt5A1OEXu51iAaefuT3rv/xYS+1hefmm8HpZSzSEvni2UBuFi7qiB78iZ66eS9DijWNbsgCmI6ZYYFEIUmJdW2zN0kkKqrUsQyMI3XYu6qPINW7Xmua2pDd9dz4DPchzDbPvO7zxhrftRoKX2H8X3YpiXraOZDUV3caBBbDDxubWK7ZX
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

*** History, motivation and available online resources ***

Initial version of kmemdump and discussion is available here:
https://lore.kernel.org/lkml/20250422113156.575971-1-eugen.hristev@linaro.org/

Kmemdump has been presented and discussed at Linaro Connect 2025,
including motivation, scope, usability and feasability.
Video of the recording is available here for anyone interested:
https://www.youtube.com/watch?v=r4gII7MX9zQ&list=PLKZSArYQptsODycGiE0XZdVovzAwYNwtK&index=14

Linaro blog on kmemdump can be found here:
https://www.linaro.org/blog/introduction-to-kmemdump/

The implementation is based on the initial Pstore/directly mapped zones
published as an RFC here:
https://lore.kernel.org/all/20250217101706.2104498-1-eugen.hristev@linaro.org/

The back-end implementation for qcom_minidump is based on the minidump
patch series and driver written by Mukesh Ojha, thanks:
https://lore.kernel.org/lkml/20240131110837.14218-1-quic_mojha@quicinc.com/

The RFC v2 version with .section creation and macro annotation kmemdump
is available here:
https://lore.kernel.org/all/20250724135512.518487-1-eugen.hristev@linaro.org/

*** How to use kmemdump with minidump backend on Qualcomm platform guide ***

Prerequisites:
Crash tool compiled with target=ARM64 and minor changes required for usual crash
mode (minimal mode works without the patch)
A patch can be applied from here https://p.calebs.dev/49a048
This patch will be eventually sent in a reworked way to crash tool.

Target kernel must be built with :
CONFIG_DEBUG_INFO_REDUCED=n ; this will have vmlinux include all the debugging
information needed for crash tool.

Also, the kernel requires these as well:
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
memory/md_Kunknown46.BIN memory/md_Kunknown49.BIN  memory/md_Kunknown50.BIN \
memory/md_Kunknown51.BIN > ~/minidump_image`

Once you have the resulted file, use `crash` tool to load it, like this:
`./crash --no_modules --no_panic --no_kmem_cache --zero_excluded vmlinux minidump_image`

There is also a --minimal mode for ./crash that would work without any patch applied
to crash tool, but you can't inspect symbols, etc.

Once you load crash you will see something like this :

      KERNEL: /home/eugen/linux-minidump/vmlinux  [TAINTED]
    DUMPFILE: /home/eugen/new
        CPUS: 8 [OFFLINE: 5]
        DATE: Thu Jan  1 02:00:00 EET 1970
      UPTIME: 00:00:22
       TASKS: 0
    NODENAME: qemuarm64
     RELEASE: 6.17.0-rc5-next-20250910-00020-g7dfa02aeae7e
     VERSION: #116 SMP PREEMPT Thu Sep 11 18:28:06 EEST 2025
     MACHINE: aarch64  (unknown Mhz)
      MEMORY: 34.2 GB
       PANIC: ""
crash> log
[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd4b2]
[    0.000000] Linux version 6.17.0-rc5-next-20250910-00020-g7dfa02aeae7e (eugen@eugen-station) (aarch64-none-linux-gnu-gcc (Arm GNU Toolchain 13.3.Rel1 (Build arm-13.24)) 13.3.1 20240614, GNU ld (Arm GNU Toolchain 13.3.Rel1 (Build arm-13.24)) 2.42.0.20240614) #116 SMP PREEMPT Thu Sep 11 18:28:06 EEST 2025


*** Debug Kinfo backend driver ***
I don't have any device to actually test this. So I have not.
I hacked the driver to just use a kmalloc'ed area to save things instead
of the shared memory, and dumped everything there and checked whether it is identical
with what the downstream driver would have saved.
So this synthetic test passed and memories are identical.
Anyone who actually wants to test this, feel free to reply to the patch.
I have also written a simple DT binding for the driver.

Thanks for everyone reviewing and bringing ideas into the discussion.

Eugen

Changelog since the v2 of the RFC:
- V2 available here : https://lore.kernel.org/all/20250724135512.518487-1-eugen.hristev@linaro.org/
- Removed the .section as requested by David Hildenbrand.
- Moved all kmemdump registration(when possible) to vmcoreinfo.
- Because of this, some of the variables that I was registering had to be non-static
so I had to modify this as per David Hildenbrand suggestion.
- Fixed minor things in the Kinfo driver: one field was broken, fixed some
compiler warnings, fixed the copyright and remove some useless includes.
- Moved the whole kmemdump from drivers/debug into mm/ and Kconfigs into mm/Kconfig.debug
and it's now available in kernel hacking, as per Randy Dunlap review
- Reworked some of the Documentation as per review from Jon Corbet


Changelog since the v1 of the RFC:
- V1 available here: https://lore.kernel.org/lkml/20250422113156.575971-1-eugen.hristev@linaro.org/
- Reworked the whole minidump implementation based on suggestions from Thomas Gleixner.
This means new API, macros, new way to store the regions inside kmemdump
(ditched the IDR, moved to static allocation, have a static default backend, etc)
- Reworked qcom_minidump driver based on review from Bjorn Andersson
- Reworked printk log buffer registration based on review from Petr Mladek

I appologize if I missed any review comments. I know there is still lots of work
on this series and hope I will improve it more and more.
Patches are sent on top of next-20250910

Eugen Hristev (16):
  kmemdump: Introduce kmemdump
  Documentation: Add kmemdump
  kmemdump: Add coreimage ELF layer
  Documentation: kmemdump: Add section for coreimage ELF
  kernel/vmcore_info: Register dynamic information into Kmemdump
  kmemdump: Introduce qcom-minidump backend driver
  soc: qcom: smem: Add minidump device
  init/version: Add banner_len to save banner length
  genirq/irqdesc: Have nr_irqs as non-static
  panic: Have tainted_mask as non-static
  mm/swapfile: Have nr_swapfiles as non-static
  printk: Register information into Kmemdump
  sched: Add sched_get_runqueues_area
  kernel/vmcoreinfo: Register kmemdump core image information
  kmemdump: Add Kinfo backend driver
  dt-bindings: Add Google Kinfo

 Documentation/dev-tools/index.rst             |   1 +
 Documentation/dev-tools/kmemdump.rst          | 139 +++++++
 .../bindings/misc/google,kinfo.yaml           |  36 ++
 MAINTAINERS                                   |  19 +
 drivers/soc/qcom/smem.c                       |  10 +
 include/linux/kmemdump.h                      | 130 +++++++
 include/linux/printk.h                        |   1 +
 init/version-timestamp.c                      |   1 +
 init/version.c                                |   1 +
 kernel/irq/irqdesc.c                          |   2 +-
 kernel/panic.c                                |   2 +-
 kernel/printk/printk.c                        |  47 +++
 kernel/sched/core.c                           |  15 +
 kernel/sched/sched.h                          |   2 +
 kernel/vmcore_info.c                          | 149 ++++++++
 mm/Kconfig.debug                              |   2 +
 mm/Makefile                                   |   1 +
 mm/kmemdump/Kconfig.debug                     |  53 +++
 mm/kmemdump/Makefile                          |   6 +
 mm/kmemdump/kinfo.c                           | 293 +++++++++++++++
 mm/kmemdump/kmemdump.c                        | 234 ++++++++++++
 mm/kmemdump/kmemdump_coreimage.c              | 222 +++++++++++
 mm/kmemdump/qcom_minidump.c                   | 353 ++++++++++++++++++
 mm/swapfile.c                                 |   2 +-
 24 files changed, 1718 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/dev-tools/kmemdump.rst
 create mode 100644 Documentation/devicetree/bindings/misc/google,kinfo.yaml
 create mode 100644 include/linux/kmemdump.h
 create mode 100644 mm/kmemdump/Kconfig.debug
 create mode 100644 mm/kmemdump/Makefile
 create mode 100644 mm/kmemdump/kinfo.c
 create mode 100644 mm/kmemdump/kmemdump.c
 create mode 100644 mm/kmemdump/kmemdump_coreimage.c
 create mode 100644 mm/kmemdump/qcom_minidump.c

-- 
2.43.0


