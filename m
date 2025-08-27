Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 057FFC8303F
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 06:42:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 377006B00B0; Wed, 27 Aug 2025 02:42:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34EE56B00B4; Wed, 27 Aug 2025 02:42:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 264C96B00B9; Wed, 27 Aug 2025 02:42:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0FABE6B00B0
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:42:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AC8DCC049A
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 06:42:31 +0000 (UTC)
X-FDA: 83821593702.04.0AA9B9B
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf11.hostedemail.com (Postfix) with ESMTP id 80A044000F
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 06:42:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=Wutdnh2p;
	spf=pass (imf11.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.208.51 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756276949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N4AF+Z8QELxaFzdK5UESWjmAKEccgiFEItCe+oHlNao=;
	b=GCzFqVRf3bsHOpnpLQDNTblT0Rf/bigkDDZtUecP6n2sI0CBIQVLsgtcYIDjDLsPt1AtGd
	wwJHSxVpQRD7B9onoHuuyxs7m0J29P0BesJWwycalQz/MNfLPBKysjrhLYaey1ydrTGMOj
	xaZdj4NhFIU4II+pTrj37uorlotiAeQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=Wutdnh2p;
	spf=pass (imf11.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.208.51 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756276949; a=rsa-sha256;
	cv=none;
	b=XOrXc1A65zwBIG4TDkCjB1c6/Qxz8btVHHSi7p6SJfnLYaE/FWPEHz1p5Mn9BU/Rpm9QAn
	vxeZ6vC5iyeqnrKJNzAB2Rq1hMB7vqFARFaH1PkGJI5AysUm3N07oXS23QPNQMY6GVTZxB
	3iA69HOYHEtNpz9ZddeeQQtxBTOgEpw=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-61c21e50168so6300056a12.3
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 23:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756276948; x=1756881748; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N4AF+Z8QELxaFzdK5UESWjmAKEccgiFEItCe+oHlNao=;
        b=Wutdnh2pATtPQsOkj8Y69QHPDS7wcHHaDdgBIk2c3v4yPUo2u0lfajv2p6TO//iBC6
         hy606S9Zc2i2DRzMZ+pdDBHCkyp1zVo7jKtQP8VynYAou9h9jC6mRAsGazDSi0Hgr2I2
         G6+UOmsNNOnXLS+Z5Sx1qpSOC4fJNK+/mcui7xP9qbtikwzJ/watgOOJ5TSW9U+JkcGN
         Ha7l+zeGExztaFcm4Us0hUZxW8mE8teiX/YyOfSB0pPuSLh3K6iF08n5ehXuDSBWLSfR
         9qMQO5tfNCGeIP+fUm60NgohjC80rKENLBqO+BZtVN05Va0UlpxRDvBUR+AHi5INK9Mi
         D/qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756276948; x=1756881748;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N4AF+Z8QELxaFzdK5UESWjmAKEccgiFEItCe+oHlNao=;
        b=UPqguJOTIB9nyc5MNSdqbgZLPVk4EIbV34qyMP32/WsjzXZGnGgtYQ9aKsQXF/x0IC
         3o/0MjuKqGOZHGb7xos3or+dS0FUYrPBFKFwFKgKDJCt4m5Kjya9Bd1M+IhmENhOWOF6
         7Xdm2/SByDHbS6e6UrwtRfdA2Nbj/xAKwf8Wy0W0PHeOfeVsUJhoTiYZtb96tGVfWFEZ
         iUAr1Q7BthCncg8brZBLZPhoCG3yKOSmTOD5PLNDu/rE3Cb9Xt6dF8CLxsliGuRcpQ7B
         1cWF4j/X+sGgaTOkLsL6R193EIfhNgKdg+wSCC/1k1SAYCsVecUAdUxjPLAmkopmfiBh
         zWPw==
X-Forwarded-Encrypted: i=1; AJvYcCXx2bFWNZ2HfbEN4CxrsZUlvfI0/gf4yvC+hBWg6hlYYiyTwtfoCmnkuOfEOQ7FUkdkuhE7lAhy/g==@kvack.org
X-Gm-Message-State: AOJu0YzJOOgXydYEuPyYz//Lc0RmbZiJWREMAxeqNWzK67o9j6Dnbkue
	8XkbxmGkNORzNHkDejp8rouppZ3yMBk9/UAiGP2wiX4QoYywdwKu5/PVh47WWK9wOHE=
X-Gm-Gg: ASbGncuNasEbXYM1HBuFlUEdBJtht7177AaLbYSTGXdL0D+BUoxp6Te5wj+JRzBdOA+
	PBhxtwJqJQmwgBVCZhTrGIune8gflohjtjsHrfy+wpY9HgGgxzpQ2YUUHRfdZkdECyGG0CyZQft
	8pYTPxa2rHH1CsDuH3229qhlDF7J6BgEkA6X59j7BYz6iHvLwyZC6+tfhRounhEDHrrOIhBHpmF
	TicR4SKRljvCJrBefaYSx9+9whfStuBYnNL672Eav/W468Fq8INjPENiRnEBX6Cg9xVonwDalgm
	Ww10t4Ae+abNBSjQoRr4weBo2di8fAsizuJxzL2wrA2uzpxHi/61COKEbMBavUj7VjqODxN90PT
	Cl4VM1wII1UWIJJwQnm84GucwU5z51w==
X-Google-Smtp-Source: AGHT+IHPbx6kF83A+w0Q0/C0fjKETavqKUnu7JIyVYNCZOoMZP02b1AqvPznvJa3PXMc/mDqyr/CTg==
X-Received: by 2002:a17:906:478a:b0:afe:c027:cfd4 with SMTP id a640c23a62f3a-afec027dffcmr146211766b.41.1756276947856;
        Tue, 26 Aug 2025 23:42:27 -0700 (PDT)
Received: from [192.168.0.24] ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe73cf6d99sm697061266b.0.2025.08.26.23.42.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 23:42:27 -0700 (PDT)
Message-ID: <495394bb-6f0a-4300-ac77-e3193eb14ca4@linaro.org>
Date: Wed, 27 Aug 2025 09:42:26 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v2 00/29] introduce kmemdump
To: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
 andersson@kernel.org, pmladek@suse.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 corbet@lwn.net, mojha@qti.qualcomm.com, rostedt@goodmis.org,
 jonechou@google.com, tudor.ambarus@linaro.org
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
 <20250826171447.6w77day5wddppy3s@hu-mojha-hyd.qualcomm.com>
From: Eugen Hristev <eugen.hristev@linaro.org>
Content-Language: en-US
In-Reply-To: <20250826171447.6w77day5wddppy3s@hu-mojha-hyd.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ebo3thhi9h9xpow77ygazao4t3yhk5eb
X-Rspam-User: 
X-Rspamd-Queue-Id: 80A044000F
X-Rspamd-Server: rspam01
X-HE-Tag: 1756276949-404034
X-HE-Meta: U2FsdGVkX18AQV7WmiLffJ9IwksDQe/57VWJ9Na2kuoYNS/aEE/n9XdrmL/MMpGFK6qu6rAx9+hvTbTS+E8XVUulIXIbqLLg6NjeJVVsYhMojHIoObTbeiSshvl++bhN/N2ChvuYmyKibiuP0L3d/FeqkRMa2iqI2KfRlAz5Mm2xzGpJmYYV3f+BpSKHRi45+BDlOB+83M69XAAE1JpRY4hXw1w+NLcI4m24J1bDzpOELXPA0FxbXQkteFaH/G262WscaI3kJsmjJ7iw4GUEIt9s+rknxIyj9naReWA5UhAxVsoUU/SaOfkbSugfTcDFZ1ivkIXvD72uNJu3Qzfoj5iBydVrCkac7JXJuJHhBr48f2U5G31dSyhKdMc4uITQgiuxoEj444rEjua0+vHO2Xbf3IuHAYCqvH20no+IVwB2qwQUyY17LZbZap7ZDC2XsF3dtiyxp5SF1sndciPyhxXbAt+vkWcHRBHyWKdb1e2LLGt5BjVe4IwetbxPJXnREyNbTGPwJ57ePBPDwNwXv2CUNXkApGUgy/Ic0NDNXJryYRWSEoRCzzsotH62osUT1AvrUX373E7Zzhjp27XOUYK8VzOn7vzUzWKA9AXkYVqrG8fVe2hlyklWNn+p9UksBXJltaZ4gsDzO7dHijOgY9EEuWg3DRRksHLTZGrKM7UAHqvJUxW3tbS3JpODU73g8utIxilTzfdUiYjv/tX4Mxq0lPANOmAve0sNiT5Lrm/BksCafpbyB2UKqBhwVTDB3F6sVs5IHItpKTrfKnFFG9L88DNrh+gIAkOjKUhdDWdNNdznRDUzYo4LThW8NsKUpIykBEwfjTuWv9OoUIEb3+AeJe19kRCv8qAmEltZGRhiJKO+BBk4UaHoo6aBZZ8GBx9ArhtxYIG8VDCEGmdGo1oscxTbsFeqSamRyiJYAUACfRd77jajPggUb/SX6e1p+6eGDDEikU5p+N2CZJJ
 9y8feKjy
 EPaFW5erzvqkvLpEJMAh2nyfoAJEJ6QDLSyzRzkG8EaqBb2p+fXK/HKI7L8sz7xZjk7peWJ8/RUModuumD41w/JlTYhFP1iedvrYoY2wo2sqoOA/jbvUYVEJCxaDP/CZnGaxZX297pFYXBGmzQioQUlV00yOTnvxWFY3v7uzpc+z+o8WeQLkV9imDEypkF7oOjOs0dn9qgW744X1UDVclNqPRZ4rA6MYR7IfzKdp6w2Lef8R+g3wHMzrhCXVvewwqyqiZrUOukluvLMaAYyq3sjlZsRpSax7vtLxGBhkI6H8SSB6zzlc70fp9gMGOBRIlTC06jrMuMF28lL9Ckcf/finZbU4/gnx/z1iYU2byxPse+WJ6zxsDzCxmMynD2hsUcQ52K1jO9eL3fHOMMSiSS07MTNGxSyopyEXxh+nW/pVNLxL6JoviO6xppatN2MNCGabG+jaIu6HnLEndKhNFsOs1rusrQuubV+dNeNEUCuOOzXEqJRSPAscTcFuIsZHsXrRezvP4afhejrZvDpAlKPn1WONBz620b9frpYOfyDFZokdFBkP9WoJZvkJamswL15CzhcaHmjWbM9wcOHFlUlsDD9OMcyEjKXJ02M04fqwnIW7VAL7u8fSWXQpPILOsgHMXTM58UMQgqx6tsgrcUec1grXuACchIQnf4TUFItew5AVOXoW/EhuoOwwaDIFdDZ2Tv/Nzdwd2qaY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/26/25 20:14, Mukesh Ojha wrote:
> On Thu, Jul 24, 2025 at 04:54:43PM +0300, Eugen Hristev wrote:
>> kmemdump is a mechanism which allows the kernel to mark specific memory
>> areas for dumping or specific backend usage.
>> Once regions are marked, kmemdump keeps an internal list with the regions
>> and registers them in the backend.
>> Further, depending on the backend driver, these regions can be dumped using
>> firmware or different hardware block.
>> Regions being marked beforehand, when the system is up and running, there
>> is no need nor dependency on a panic handler, or a working kernel that can
>> dump the debug information.
>> The kmemdump approach works when pstore, kdump, or another mechanism do not.
>> Pstore relies on persistent storage, a dedicated RAM area or flash, which
>> has the disadvantage of having the memory reserved all the time, or another
>> specific non volatile memory. Some devices cannot keep the RAM contents on
>> reboot so ramoops does not work. Some devices do not allow kexec to run
>> another kernel to debug the crashed one.
>> For such devices, that have another mechanism to help debugging, like
>> firmware, kmemdump is a viable solution.
>>
>> kmemdump can create a core image, similar with /proc/vmcore, with only
>> the registered regions included. This can be loaded into crash tool/gdb and
>> analyzed.
>> To have this working, specific information from the kernel is registered,
>> and this is done at kmemdump init time, no need for the kmemdump user to
>> do anything.
>>
>> This version of the kmemdump patch series includes two backend drivers:
>> one is the Qualcomm Minidump backend, and the other one is the Debug Kinfo
>> backend for Android devices, reworked from this source here:
>> https://android.googlesource.com/kernel/common/+/refs/heads/android-mainline/drivers/android/debug_kinfo.c
>> written originally by Jone Chou <jonechou@google.com>
>>
>> Initial version of kmemdump and discussion is available here:
>> https://lore.kernel.org/lkml/20250422113156.575971-1-eugen.hristev@linaro.org/
>>
>> Kmemdump has been presented and discussed at Linaro Connect 2025,
>> including motivation, scope, usability and feasability.
>> Video of the recording is available here for anyone interested:
>> https://www.youtube.com/watch?v=r4gII7MX9zQ&list=PLKZSArYQptsODycGiE0XZdVovzAwYNwtK&index=14
>>
>> The implementation is based on the initial Pstore/directly mapped zones
>> published as an RFC here:
>> https://lore.kernel.org/all/20250217101706.2104498-1-eugen.hristev@linaro.org/
>>
>> The back-end implementation for qcom_minidump is based on the minidump
>> patch series and driver written by Mukesh Ojha, thanks:
>> https://lore.kernel.org/lkml/20240131110837.14218-1-quic_mojha@quicinc.com/
>>
>> *** How to use kmemdump with minidump backend on Qualcomm platform guide ***
>>
>> Prerequisites:
>> Crash tool with target=ARM64 and minor changes required for usual crash mode
>> (minimal mode works without the patch)
>> A patch can be applied from here https://p.calebs.dev/49a048
>> This patch will be eventually sent in a reworked way to crash tool.
>>
>> Target kernel must be built with :
>> CONFIG_DEBUG_INFO_REDUCED=n ; this will have vmlinux include all the debugging
>> information needed for crash tool.
>>
>> Otherwise, the kernel requires these as well:
>> CONFIG_KMEMDUMP, CONFIG_KMEMDUMP_COREIMAGE, and the backend
>> CONFIG_KMEMDUMP_QCOM_MINIDUMP_BACKEND
>>
>> Kernel arguments:
>> Kernel firmware must be set to mode 'mini' by kernel module parameter
>> like this : qcom_scm.download_mode=mini
>>
>> After the kernel boots, and qcom_minidump module is loaded, everything is ready for
>> a possible crash.
>>
>> Once the crash happens, the firmware will kick in and you will see on
>> the console the message saying Sahara init, etc, that the firmware is
>> waiting in download mode. (this is subject to firmware supporting this
>> mode, I am using sa8775p-ride board)
>>
>> Example of log on the console:
>> "
>> [...]
>> B -   1096414 - usb: init start
>> B -   1100287 - usb: qusb_dci_platform , 0x19
>> B -   1105686 - usb: usb3phy: PRIM success: lane_A , 0x60
>> B -   1107455 - usb: usb2phy: PRIM success , 0x4
>> B -   1112670 - usb: dci, chgr_type_det_err
>> B -   1117154 - usb: ID:0x260, value: 0x4
>> B -   1121942 - usb: ID:0x108, value: 0x1d90
>> B -   1124992 - usb: timer_start , 0x4c4b40
>> B -   1129140 - usb: vbus_det_pm_unavail
>> B -   1133136 - usb: ID:0x252, value: 0x4
>> B -   1148874 - usb: SUPER , 0x900e
>> B -   1275510 - usb: SUPER , 0x900e
>> B -   1388970 - usb: ID:0x20d, value: 0x0
>> B -   1411113 - usb: ENUM success
>> B -   1411113 - Sahara Init
>> B -   1414285 - Sahara Open
>> "
>>
>> Once the board is in download mode, you can use the qdl tool (I
>> personally use edl , have not tried qdl yet), to get all the regions as
>> separate files.
>> The tool from the host computer will list the regions in the order they
>> were downloaded.
>>
>> Once you have all the files simply use `cat` to put them all together,
>> in the order of the indexes.
>> For my kernel config and setup, here is my cat command : (you can use a script
>> or something, I haven't done that so far):
>>
>> `cat memory/md_KELF1.BIN memory/md_Kvmcorein2.BIN memory/md_Kconfig3.BIN \
>> memory/md_Kmemsect4.BIN memory/md_Ktotalram5.BIN memory/md_Kcpu_poss6.BIN \
>> memory/md_Kcpu_pres7.BIN memory/md_Kcpu_onli8.BIN memory/md_Kcpu_acti9.BIN \
>> memory/md_Kjiffies10.BIN memory/md_Klinux_ba11.BIN memory/md_Knr_threa12.BIN \
>>  memory/md_Knr_irqs13.BIN memory/md_Ktainted_14.BIN memory/md_Ktaint_fl15.BIN \
>> memory/md_Kmem_sect16.BIN memory/md_Knode_dat17.BIN memory/md_Knode_sta18.BIN \
>> memory/md_K__per_cp19.BIN memory/md_Knr_swapf20.BIN memory/md_Kinit_uts21.BIN \
>> memory/md_Kprintk_r22.BIN memory/md_Kprintk_r23.BIN memory/md_Kprb24.BIN \
>> memory/md_Kprb_desc25.BIN memory/md_Kprb_info26.BIN memory/md_Kprb_data27.BIN \
>> memory/md_Krunqueue28.BIN memory/md_Khigh_mem29.BIN memory/md_Kinit_mm30.BIN \
>> memory/md_Kinit_mm_31.BIN memory/md_Kunknown32.BIN memory/md_Kunknown33.BIN \
>> memory/md_Kunknown34.BIN  memory/md_Kunknown35.BIN memory/md_Kunknown36.BIN \
>> memory/md_Kunknown37.BIN memory/md_Kunknown38.BIN memory/md_Kunknown39.BIN \
>> memory/md_Kunknown40.BIN memory/md_Kunknown41.BIN memory/md_Kunknown42.BIN \
>> memory/md_Kunknown43.BIN memory/md_Kunknown44.BIN memory/md_Kunknown45.BIN \
>> memory/md_Kunknown46.BIN memory/md_Kunknown47.BIN  memory/md_Kunknown50.BIN \
>> memory/md_Kunknown51.BIN memory/md_Kunknown52.BIN \
>> memory/md_Kunknown53.BIN > ~/minidump_image`
>>
>> Once you have the resulted file, use `crash` tool to load it, like this:
>> `./crash --no_modules --no_panic --no_kmem_cache --zero_excluded vmlinux minidump_image`
>>
>> There is also a --minimal mode for ./crash that would work without any patch applied
>> to crash tool, but you can't inspect symbols, etc.
> 
> Unfortunately for me, only with --minimal option, I could see the 'log'.
> 
> ./crash --no_modules --no_panic --no_kmem_cache --zero_excluded vmlinux minidump_image
> 
> WARNING: kernel version inconsistency between vmlinux and dumpfile
> 
> crash: read error: kernel virtual address: ffffff8ed7f380d8  type: "IRQ stack pointer"
> crash: read error: kernel virtual address: ffffff8ed7f510d8  type: "IRQ stack pointer"
> crash: read error: kernel virtual address: ffffff8ed7f6a0d8  type: "IRQ stack pointer"
> crash: read error: kernel virtual address: ffffff8ed7f830d8  type: "IRQ stack pointer"
> crash: read error: kernel virtual address: ffffff8ed7f9c0d8  type: "IRQ stack pointer"
> crash: read error: kernel virtual address: ffffff8ed7fb50d8  type: "IRQ stack pointer"
> crash: read error: kernel virtual address: ffffff8ed7fce0d8  type: "IRQ stack pointer"
> crash: read error: kernel virtual address: ffffff8ed7fe70d8  type: "IRQ stack pointer"
> crash: read error: kernel virtual address: ffffffc0817c5d80  type: "maple_init read mt_slots"
> crash: read error: kernel virtual address: ffffffc0817c5d78  type: "maple_init read mt_pivots"
> crash: read error: kernel virtual address: ffffff8efb89e2c0  type: "memory section root table"
> 
> Looks like something more you are using in your setup to make it work.

Hello Mukesh,

Thanks for trying this out. Have you applied the indicated patch to the
crash tool before compiling it ?
If yes and still facing issues, can you run it with "-d 31" to enable
debug mode, then send me the output log please.

Eugen
> 
> -Mukesh
> 
>>
>> Once you load crash you will see something like this :
>>
>>    KERNEL: /home/eugen/linux-minidump/vmlinux  [TAINTED]
>>     DUMPFILE: /home/eugen/new
>>         CPUS: 8 [OFFLINE: 7]
>>         DATE: Thu Jan  1 02:00:00 EET 1970
>>       UPTIME: 00:00:29
>>        TASKS: 0
>>     NODENAME: qemuarm64
>>      RELEASE: 6.16.0-rc7-next-20250721-00029-gf8cffdbf0479-dirty
>>      VERSION: #5 SMP PREEMPT Tue Jul 22 18:44:57 EEST 2025
>>      MACHINE: aarch64  (unknown Mhz)
>>       MEMORY: 34.2 GB
>>        PANIC: ""
>> crash> log
>> [    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd4b2]
>> [    0.000000] Linux version 6.16.0-rc7-next-20250721-00029-gf8cffdbf0479-dirty (eugen@eugen-station) (aarch64-none-linux-gnu-gcc (Arm GNU Toolchain 13.3.Rel1 (Build arm-13.24)) 13.3.1 20240614, GNU ld (Arm GNU Toolchain 13.3.Rel1 (Build arm-13.24)) 2.42.0.20240614) #5 SMP PREEMPT Tue Jul 22 18:44:57 EEST 2025
>>
>>
>> *** Debug Kinfo backend driver ***
>> I don't have any device to actually test this. So I have not.
>> I hacked the driver to just use a kmalloc'ed area to save things instead
>> of the shared memory, and dumped everything there and checked whether it looks
>> sane. If someone is willing to try it out, thanks ! and let me know.
>> I know there is no binding documentation for the compatible either.
>>
>> Thanks for everyone reviewing and bringing ideas into the discussion.
>>
>> Eugen
>>
>> Changelog since the v1 of the RFC:
>> - Reworked the whole minidump implementation based on suggestions from Thomas Gleixner.
>> This means new API, macros, new way to store the regions inside kmemdump
>> (ditched the IDR, moved to static allocation, have a static default backend, etc)
>> - Reworked qcom_minidump driver based on review from Bjorn Andersson
>> - Reworked printk log buffer registration based on review from Petr Mladek
>>
>> I appologize if I missed any review comments. I know there is still lots of work
>> on this series and hope I will improve it more and more.
>> Patches are sent on top of next-20250721
>>
>> Eugen Hristev (29):
>>   kmemdump: introduce kmemdump
>>   Documentation: add kmemdump
>>   kmemdump: add coreimage ELF layer
>>   Documentation: kmemdump: add section for coreimage ELF
>>   kmemdump: introduce qcom-minidump backend driver
>>   soc: qcom: smem: add minidump device
>>   init/version: Annotate static information into Kmemdump
>>   cpu: Annotate static information into Kmemdump
>>   genirq/irqdesc: Annotate static information into Kmemdump
>>   panic: Annotate static information into Kmemdump
>>   sched/core: Annotate static information into Kmemdump
>>   timers: Annotate static information into Kmemdump
>>   kernel/fork: Annotate static information into Kmemdump
>>   mm/page_alloc: Annotate static information into Kmemdump
>>   mm/init-mm: Annotate static information into Kmemdump
>>   mm/show_mem: Annotate static information into Kmemdump
>>   mm/swapfile: Annotate static information into Kmemdump
>>   mm/percpu: Annotate static information into Kmemdump
>>   mm/mm_init: Annotate static information into Kmemdump
>>   printk: Register information into Kmemdump
>>   kernel/configs: Register dynamic information into Kmemdump
>>   mm/numa: Register information into Kmemdump
>>   mm/sparse: Register information into Kmemdump
>>   kernel/vmcore_info: Register dynamic information into Kmemdump
>>   kmemdump: Add additional symbols to the coreimage
>>   init/version: Annotate init uts name separately into Kmemdump
>>   kallsyms: Annotate static information into Kmemdump
>>   mm/init-mm: Annotate additional information into Kmemdump
>>   kmemdump: Add Kinfo backend driver
>>
>>  Documentation/debug/index.rst      |  17 ++
>>  Documentation/debug/kmemdump.rst   | 104 +++++++++
>>  MAINTAINERS                        |  18 ++
>>  drivers/Kconfig                    |   4 +
>>  drivers/Makefile                   |   2 +
>>  drivers/debug/Kconfig              |  55 +++++
>>  drivers/debug/Makefile             |   6 +
>>  drivers/debug/kinfo.c              | 304 +++++++++++++++++++++++++
>>  drivers/debug/kmemdump.c           | 239 +++++++++++++++++++
>>  drivers/debug/kmemdump_coreimage.c | 223 ++++++++++++++++++
>>  drivers/debug/qcom_minidump.c      | 353 +++++++++++++++++++++++++++++
>>  drivers/soc/qcom/smem.c            |  10 +
>>  include/asm-generic/vmlinux.lds.h  |  13 ++
>>  include/linux/kmemdump.h           | 219 ++++++++++++++++++
>>  init/version.c                     |   6 +
>>  kernel/configs.c                   |   6 +
>>  kernel/cpu.c                       |   5 +
>>  kernel/fork.c                      |   2 +
>>  kernel/irq/irqdesc.c               |   2 +
>>  kernel/kallsyms.c                  |  10 +
>>  kernel/panic.c                     |   4 +
>>  kernel/printk/printk.c             |  28 ++-
>>  kernel/sched/core.c                |   2 +
>>  kernel/time/timer.c                |   3 +-
>>  kernel/vmcore_info.c               |   3 +
>>  mm/init-mm.c                       |  12 +
>>  mm/mm_init.c                       |   2 +
>>  mm/numa.c                          |   5 +-
>>  mm/page_alloc.c                    |   2 +
>>  mm/percpu.c                        |   3 +
>>  mm/show_mem.c                      |   2 +
>>  mm/sparse.c                        |  16 +-
>>  mm/swapfile.c                      |   2 +
>>  33 files changed, 1670 insertions(+), 12 deletions(-)
>>  create mode 100644 Documentation/debug/index.rst
>>  create mode 100644 Documentation/debug/kmemdump.rst
>>  create mode 100644 drivers/debug/Kconfig
>>  create mode 100644 drivers/debug/Makefile
>>  create mode 100644 drivers/debug/kinfo.c
>>  create mode 100644 drivers/debug/kmemdump.c
>>  create mode 100644 drivers/debug/kmemdump_coreimage.c
>>  create mode 100644 drivers/debug/qcom_minidump.c
>>  create mode 100644 include/linux/kmemdump.h
>>
>> -- 
>> 2.43.0
>>
> 


