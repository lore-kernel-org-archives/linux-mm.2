Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FB92F30298
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 02:24:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D99C6B00F6; Sun, 15 Mar 2026 22:24:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AAC96B00F7; Sun, 15 Mar 2026 22:24:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AD916B00F8; Sun, 15 Mar 2026 22:24:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 271D66B00F6
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 22:24:53 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B1876140D05
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:24:52 +0000 (UTC)
X-FDA: 84550333224.20.42474F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id DD4DB20003
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:24:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cyHsh3Kb;
	spf=pass (imf13.hostedemail.com: domain of andersson@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=andersson@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773627891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9IiUMkuPnZUap0H7O1WQzmWCIIkBt3EXfAwrtqSQVv4=;
	b=vMe2Ykc2eG9fcutyf16vml9eS7va+MfD0ny9AS2CupefHyMM5qwC/FaVAFKGvbYzd313nx
	k3/8nIohz4VYjWPe9xHUazknLCElNVV3TeNSxBOx/HbK7yK/zVzi9B9jEZNyYzq8EaAQqX
	NPsGGpDUQ02rxRFeGMF5PqRwZgVQn8w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773627891; a=rsa-sha256;
	cv=none;
	b=R7ICEWJ3S9+yxhez6EzcPNgwdhP5nVniEKLtdN7EVHnWW08fCEQgSS+DGU40yWf2IbW01u
	r/x9WBhSTJqyrQnO9Nf+cyiwKxmueS9/De6FI99JHbxn2iYgWdHdvbgZKCzth36W2GWidG
	cjxu6y3n1Iw/UMSNdWP/YF7/i4o97aE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cyHsh3Kb;
	spf=pass (imf13.hostedemail.com: domain of andersson@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=andersson@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 982C241B1C;
	Mon, 16 Mar 2026 02:24:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B971CC4CEF7;
	Mon, 16 Mar 2026 02:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773627889;
	bh=nWchieyJQyv4iGmUtwJpOTMtAWI6VO07iwWkdnvOYvQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cyHsh3KbXGNDm8683ULRzsRz4/+1zlmZE4RynJYWJlCqKxlKbOCAnIk6tz1L4E8+w
	 j+SNpBpF/eeo/uXaUpZEmdPl3eSIc/JcowgPiHFA38grTv+QcAiaMiC9hnhwgEISvm
	 iAnUjBVh8iVgcdPgl8Qan/966hvUhVy45uXoQsFh7WZLWYnIudbgX5xxLYgvXW55G9
	 aNG2pgSJyR4hJ2YNaYXWSNYg1hZtOgFr6RA6Qo4zMa1uQqFJ8cZUMGE6jX/AgcRsJu
	 y1IS8qj4zA/kLfTyfmIH5jWGl4WDRT78RpcI6AgjxS/IZLs8SRAXQjDLpJVnMvkUuX
	 daqgQLJ6oe4qw==
Date: Sun, 15 Mar 2026 21:24:39 -0500
From: Bjorn Andersson <andersson@kernel.org>
To: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Cc: Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Eugen Hristev <eugen.hristev@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, Frederic Weisbecker <frederic@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Petr Mladek <pmladek@suse.com>, John Ogness <john.ogness@linutronix.de>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Saravana Kannan <saravanak@kernel.org>, workflows@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org, 
	linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 00/25] Introduce meminspect
Message-ID: <abdnp90cC5PI9wyz@baldur>
References: <20260311-minidump-v2-v2-0-f91cedc6f99e@oss.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311-minidump-v2-v2-0-f91cedc6f99e@oss.qualcomm.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DD4DB20003
X-Stat-Signature: guqtpop4zwky9dgm7meu79oi9m3x9t1d
X-Rspam-User: 
X-HE-Tag: 1773627890-400725
X-HE-Meta: U2FsdGVkX181Gx/69tC0MLInmW2ZMgjHtN9Sfjg83WpSpAV1L7kc8bJG8uUzKbH0hTfEDBCaLFzwfIg8XjcEphUBXQCBiw4I/0MtzzTzuxHh0gk94IqsG/tkgaiK8nO53dSkfD/RQlfRSgtxmVKdCE7WjFhSLtE2B0oklwNiayAUatndXJPv+G+tRXs7HtNfHjVXr6Vh8aceNzjj0cNKyyOaYfOAf9lSBiiBxFRbjAacBVfzgqalTzvIWr/pqJ6Dqf1+pFxqKZxAlue6XppEIpvvVGDvSrEgZ/M30o3Qz2tPEjKT5VXxKlANjXt9+2WWxbgV/W4nIcYVbjeg89VV648YvBn8R4qlNmDRBVKFL7z5A5mBmWW7GD7QlIGJxmEBhvT+YVxcq8mEDDApOtwyd9Li89zJdT1wrLJzHAhXco8dfPOlTBhZAJbInjew6zvWnZt/Hl9PfwpM3zPlbq5N2Ivcm/mziCOnQqyFnJzAhVqRW4M7H+mFxGHdBvva5jcx/Aj57bJHnXCK/CUyYEBCj0ARKJIMnrM0cjI5MjxZgF56Mrx2ofKyz4TFgyw109wAEGe63ZLixyDkA70JNBL8Uf1I00WQkEhk41CtDQkIMvlkBCzABOHFOI1aDe5rWNJNjgpDFHTTerSWLjaReJlEF/iNGef+cC4TRVruvVV0qfhuvVNGufxKWds/XC4N+QBpOasSX3SocgvrJlL7IFjSe+ZQfbwDIegXyX+yXX863kQXEC0bhLJRrGuKNave8mL6h4kM1NTvwAMod02YpMtaXy0uJpke5dJla8w5tn07UGUSb0qUAsvYTthGxEQrSV/PXyyJyzeqkuwfxKxeKSaCvNEUoPUthHn5AQgl/d0A1UtAJVofEg7nRcwqrhxwo6tTnUj+Hp/651vaex9DWg4Nen+j6L7lUUn7jwCEd6V7m0Q+nhCjqLracH1dFQYuQKnLD5iNPd6oLijQwF9nr+n
 RZWsmUq2
 l9dKlamJFqalnhZl9Zruvy7PKV5Fo10tYGVf1cazzMnaQ2O0+eLHhwZpj9frr0ElkdTVDTisRMtSnWD6/N+uEq41+p5/AFVvxIL1mDr5uU1NzjAR4rSCYG8ivJKVpZyTaNFGR0olFllIOhZqbTu/7fv+4Y2H3KVAjl9m2jqvxC7dESbAXZ5jpROjdSnD10757rkFCaHIGmDv4608hUHdA73LF+PsHo+xOV8JsquxVD9XoeG8jXRnHcoVffUVvvkwAwjDNXP3nTNYhfpIxY5/bvZ8+Pizic8t/iRDGF3x92T8+f/eQMBYOG9eNzjQopDCxjVk5ZHD9O2opJrHuoAD/UghTfiEoM0fOcePotIPS+pDbLY/1nfPw2NXFtcPmqwhhCz/h42hYsrFthORKhNzzNEZq0WGSpaI3Ia1qCjjkbDX2zE6Dv8MFpvz464j4K+wv5qBQqzfqoo7f/UMITIxooeEchGH/ZLF7KiFjMVb+Gfq5zTX9Hb0hQ5fiXN3fhGhBAjZk/FNSucRcEe2Lvxtmp/PX+C1CnPiUmThmKLJpomYQZlbHX45mRoov/5m8nD8wRRa2MTzRzk3W/cvyZmJpioTtvj3PLPvCOa42diLuu5o171L8d6F9k8U4Q/vJpo29KUhJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 01:45:44AM +0530, Mukesh Ojha wrote:
> First of all, I want to thank Eugene for his excellent work on this
> series. What began as the Qualcomm Minidump driver from me has now
> evolved into meminspect. He also presented meminspect a few months ago
> at Linux Plumbers 2025.
> 
> Video of the recording is available here for anyone interested:
> https://www.youtube.com/watch?v=aDZv4-kOLSc
> 
> Introduction:
> 
> meminspect is a mechanism which allows the kernel to mark specific
> memory areas for memory dumping or specific inspection, statistics,
> usage.  Once regions are marked, meminspect keeps an internal list with
> the regions in a dedicated table.  Further, these regions can be
> accessed using specific API by any interested driver.  Regions being
> marked beforehand, when the system is up and running, there is no need
> nor dependency on a panic handler, or a working kernel that can dump the
> debug information.  meminspect can be primarily used for debugging. The
> approach is feasible to work when pstore, kdump, or another mechanism do
> not.  Pstore relies on persistent storage, a dedicated RAM area or
> flash, which has the disadvantage of having the memory reserved all the
> time, or another specific non volatile memory. Some devices cannot keep
> the RAM contents on reboot so ramoops does not work. Some devices do not
> allow kexec to run another kernel to debug the crashed one.  For such
> devices, that have another mechanism to help debugging, like firmware,
> kmemdump is a viable solution.
> 
> meminspect can create a core image, similar with /proc/vmcore, with only
> the registered regions included. This can be loaded into crash tool/gdb
> and analyzed. This happens if CRASH_DUMP=y.  To have this working,
> specific information from the kernel is registered, and this is done at
> meminspect init time, no need for the meminspect users to do anything.
> 
> This version of the meminspect patch series includes two drivers that
> make use of it: one is the Qualcomm Minidump, and the other one is the
> Debug Kinfo backend for Android devices, reworked from this source here:
> https://android.googlesource.com/kernel/common/+/refs/heads/android-mainline/drivers/android/debug_kinfo.c
> written originally by Jone Chou <jonechou@google.com>
> 
> *** History, motivation and available online resources ***
> 
> The patch series is based on both minidump and kmemdump previous implementations.
> 
> After the three RFC kmemdump versions, considering the ML discussions, it was decided to
> move this into kernel/ directory and rework it into naming it meminspect, as Thomas Gleixner
> suggested.
> 
> Initial version of kmemdump and discussion is available here:
> https://lore.kernel.org/lkml/20250422113156.575971-1-eugen.hristev@linaro.org/
> 
> Kmemdump has been presented and discussed at Linaro Connect 2025,
> including motivation, scope, usability and feasability.
> Video of the recording is available here for anyone interested:
> https://www.youtube.com/watch?v=r4gII7MX9zQ&list=PLKZSArYQptsODycGiE0XZdVovzAwYNwtK&index=14
> 
> Linaro blog on kmemdump can be found here:
> https://www.linaro.org/blog/introduction-to-kmemdump/
> 
> Linaro blog on kmemdump step by stem using minidump backend is available here:
> https://www.linaro.org/blog/kmemdump-step-by-step-on-qualcomm-automotive-platform/
> 
> The implementation is based on the initial Pstore/directly mapped zones
> published as an RFC here:
> https://lore.kernel.org/all/20250217101706.2104498-1-eugen.hristev@linaro.org/
> 
> The back-end implementation for qcom_minidump is based on the minidump
> patch series and driver written by Mukesh Ojha, thanks:
> https://lore.kernel.org/lkml/20240131110837.14218-1-quic_mojha@quicinc.com/
> 
> The RFC v2 version with .section creation and macro annotation kmemdump
> is available here:
> https://lore.kernel.org/all/20250724135512.518487-1-eugen.hristev@linaro.org/
> 
> The RFC v3 version with making everything static, which was pretty much rejected due to
> all reasons discussed on the public ML:
> https://lore.kernel.org/all/20250912150855.2901211-1-eugen.hristev@linaro.org/
> 
> *** How to use meminspect with minidump backend on Qualcomm platform guide ***
> 
> Prerequisites:
> Crash tool compiled with target=ARM64 and minor changes required for
> usual crash mode (minimal mode works without the patch) **A patch can be
> applied from here https://p.calebs.dev/1687bc ** This patch will be
> eventually sent in a reworked way to crash tool.
> 

That patch was written 8 months ago, what's the timeline for landing
this?

It's not feasible to have every users rebuild crash from source and
maintain this copy in order to use the tool.

> Target kernel must be built with : CONFIG_DEBUG_INFO_REDUCED=n ; this
> will have vmlinux include all the debugging information needed for crash
> tool.
> 
> Also, the kernel requires these as well: CONFIG_MEMINSPECT,
> CONFIG_CRASH_DUMP and the driver CONFIG_QCOM_MINIDUMP
> 
> Kernel arguments: Kernel firmware must be set to mode 'mini' by kernel
> module parameter like this : qcom_scm.download_mode=mini
> 
> After the kernel boots, and minidump module is loaded, everything is
> ready for a possible crash.
> 
> Once the crash happens, the firmware will kick in and you will see on
> the console the message saying Sahara init, etc, that the firmware is
> waiting in download mode. (this is subject to firmware supporting this
> mode, I am using sa8775p-ride board)
> 
> Example of log on the console:
> "
> [...]
> B -   1096414 - usb: init start
> B -   1100287 - usb: qusb_dci_platform , 0x19
> B -   1105686 - usb: usb3phy: PRIM success: lane_A , 0x60
> B -   1107455 - usb: usb2phy: PRIM success , 0x4
> B -   1112670 - usb: dci, chgr_type_det_err
> B -   1117154 - usb: ID:0x260, value: 0x4
> B -   1121942 - usb: ID:0x108, value: 0x1d90
> B -   1124992 - usb: timer_start , 0x4c4b40
> B -   1129140 - usb: vbus_det_pm_unavail
> B -   1133136 - usb: ID:0x252, value: 0x4
> B -   1148874 - usb: SUPER , 0x900e
> B -   1275510 - usb: SUPER , 0x900e
> B -   1388970 - usb: ID:0x20d, value: 0x0
> B -   1411113 - usb: ENUM success
> B -   1411113 - Sahara Init
> B -   1414285 - Sahara Open
> "

This doesn't add any specific value, it's just "Device entered ramdump
mode".

> 
> Once the board is in download mode, you can use the qdl tool (I
> personally use edl , have not tried qdl yet)

Is this your or Eugen's comment? Why haven't you tested qdl yet?

>, to get all the regions as
> separate files.  The tool from the host computer will list the regions
> in the order they were downloaded.
> 
> Once you have all the files simply use `cat` to put them all together,
> in the order of the indexes.  For my kernel config and setup, here is my
> cat command : (you can use a script or something, I haven't done that so
> far):

So these need to be sorted in numerical order, by that number at the end
of the file name?

Do you manually punch these in? How do we make this user friendly?

Regards,
Bjorn

> 
> `cat md_KELF1.BIN md_Kvmcorein2.BIN md_Kconfig3.BIN \
> md_Ktotalram4.BIN md_Kcpu_poss5.BIN md_Kcpu_pres6.BIN \
> md_Kcpu_onli7.BIN md_Kcpu_acti8.BIN md_Kmem_sect9.BIN \
> md_Kjiffies10.BIN md_Klinux_ba11.BIN md_Knr_threa12.BIN \
> md_Knr_irqs13.BIN md_Ktainted_14.BIN md_Ktaint_fl15.BIN \
> md_Knode_sta16.BIN md_K__per_cp17.BIN md_Knr_swapf18.BIN \
> md_Kinit_uts19.BIN md_Kprintk_r20.BIN md_Kprintk_r21.BIN \
> md_Kprb22.BIN md_Kprb_desc23.BIN md_Kprb_info24.BIN \
> md_Kprb_data25.BIN  md_Khigh_mem26.BIN md_Kinit_mm27.BIN \
> md_Kunknown29.BIN md_Kunknown30.BIN md_Kunknown31.BIN \
> md_Kunknown32.BIN md_Kunknown33.BIN md_Kunknown34.BIN \
> md_Kunknown35.BIN md_Kunknown37.BIN \
> md_Kunknown38.BIN md_Kunknown39.BIN md_Kunknown40.BIN \
> md_Kunknown41.BIN md_Kunknown42.BIN md_Kunknown43.BIN \
> md_Kunknown44.BIN md_Kunknown45.BIN  md_Kunknown46.BIN \
> md_Kunknown47.BIN md_Kunknown48.BIN md_Kunknown49.BIN \
> md_Kunknown50.BIN md_Kunknown51.BIN md_Kunknown52.BIN \
> md_Kunknown53.BIN md_Kunknown54.BIN   > ./minidump_image`
> 
> Once you have the resulted file, use `crash` tool to load it, like this:
> `./crash --no_modules --no_panic --no_kmem_cache --zero_excluded vmlinux minidump_image`
> 
> There is also a --minimal mode for ./crash that would work without any patch applied
> to crash tool, but you can't inspect symbols, etc.
> 
> Once you load crash you will see something like this :
>       KERNEL: minidump/20260310-235110/vmlinux  [TAINTED]
>     DUMPFILE: ./minidump/20260310-235110/minidump_image
>         CPUS: 8 [OFFLINE: 7]
>         DATE: Thu Jan  1 05:30:00 +0530 1970
>       UPTIME: 00:00:27
>        TASKS: 0
>     NODENAME: qemuarm64
>      RELEASE: 7.0.0-rc3-next-20260309-00028-g528b3c656121
>      VERSION: #5 SMP PREEMPT Tue Mar 10 18:18:41 UTC 2026
>      MACHINE: aarch64  (unknown Mhz)
>       MEMORY: 0
>        PANIC: "Kernel panic - not syncing: sysrq triggered crash"
> 
> crash> log
> [    0.000000] Booting Linux on physical CPU 0x0000000000 [0x514f0014]
> [    0.000000] Linux version 7.0.0-rc3-next-20260309-00028-g528b3c656121 (@21e3bca4168f) (aarch64-linux-gnu-gcc (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0, GNU ld (GNU Binutils for Ubuntu) 2.42) #5 SMP PREEMPT Tue Mar 10 18:18:41 UTC 2026
> 
> *** Debug Kinfo backend driver ***
> I need help with the testing of this driver, Anyone who actually wants
> to test this, feel free to reply to the patch. we have also written a
> simple DT binding for the driver.
> 
> Thanks in advance for the review, and apologies if I missed addressing any comment.
> 
> -Mukesh 
> 
> Changes in v2: https://lore.kernel.org/lkml/20251119154427.1033475-1-eugen.hristev@linaro.org/
>  - Fixed doc warnings
>  - Fixed kernel-test robot warnings.
>  - Took Mike suggestion to remove mark inspect flag for dynamic memory.
>  - Added R-b for printk patch.
>  - Modified some commit messages for clarity.
>  - corrected binding change for debug-kinfo as per Rob suggestion.
> 
> Changelog for meminspect v1:
> - rename to meminspect
> - start on top of v2 actually, with the section and all.
> - remove the backend thing, change the API to access the table
> - move everything to kernel/
> - add dependency to CRASH_DUMP instead of a separate knob
> - move the minidump driver to soc/qcom
> - integrate the meminspect better into memblock by using a new memblock flag
> - minor fixes : use dev_err_probe everywhere, rearrange variable declarations,
> remove some useless code, etc.
> 
> Changelog for RFC v3:
> - V2 available here : https://lore.kernel.org/all/20250724135512.518487-1-eugen.hristev@linaro.org/
> - Removed the .section as requested by David Hildenbrand.
> - Moved all kmemdump registration(when possible) to vmcoreinfo.
> - Because of this, some of the variables that I was registering had to be non-static
> so I had to modify this as per David Hildenbrand suggestion.
> - Fixed minor things in the Kinfo driver: one field was broken, fixed some
> compiler warnings, fixed the copyright and remove some useless includes.
> - Moved the whole kmemdump from drivers/debug into mm/ and Kconfigs into mm/Kconfig.debug
> and it's now available in kernel hacking, as per Randy Dunlap review
> - Reworked some of the Documentation as per review from Jon Corbet
> 
> Changelog for RFC v2:
> - V1 available here: https://lore.kernel.org/lkml/20250422113156.575971-1-eugen.hristev@linaro.org/
> - Reworked the whole minidump implementation based on suggestions from Thomas Gleixner.
> This means new API, macros, new way to store the regions inside kmemdump
> (ditched the IDR, moved to static allocation, have a static default backend, etc)
> - Reworked qcom_minidump driver based on review from Bjorn Andersson
> - Reworked printk log buffer registration based on review from Petr Mladek
> 
> I appologize if I missed any review comments.
> Patches are sent on top on next-20260309 tag
> 
> ---
> Eugen Hristev (21):
>       kernel: Introduce meminspect
>       init/version: Annotate static information into meminspect
>       mm/percpu: Annotate static information into meminspect
>       cpu: Annotate static information into meminspect
>       genirq/irqdesc: Annotate static information into meminspect
>       timers: Annotate static information into meminspect
>       kernel/fork: Annotate static information into meminspect
>       mm/page_alloc: Annotate static information into meminspect
>       mm/show_mem: Annotate static information into meminspect
>       mm/swapfile: Annotate static information into meminspect
>       kernel/vmcore_info: Register dynamic information into meminspect
>       kernel/configs: Register dynamic information into meminspect
>       mm/init-mm: Annotate static information into meminspect
>       panic: Annotate static information into meminspect
>       kallsyms: Annotate static information into meminspect
>       mm/mm_init: Annotate static information into meminspect
>       sched/core: Annotate runqueues into meminspect
>       remoteproc: qcom: Move minidump data structures into its own header
>       soc: qcom: Add minidump backend driver
>       soc: qcom: smem: Add minidump platform device
>       meminspect: Add debug kinfo compatible driver
> 
> Mukesh Ojha (4):
>       mm/numa: Register node data information into meminspect
>       mm/sparse: Register information into meminspect
>       printk: Register information into meminspect
>       dt-bindings: reserved-memory: Add Google Kinfo Pixel reserved memory
> 
>  Documentation/dev-tools/index.rst                  |   1 +
>  Documentation/dev-tools/meminspect.rst             | 144 +++++++
>  .../bindings/reserved-memory/google,kinfo.yaml     |  46 ++
>  MAINTAINERS                                        |  14 +
>  drivers/of/platform.c                              |   1 +
>  drivers/remoteproc/qcom_common.c                   |  56 +--
>  drivers/soc/qcom/Kconfig                           |  13 +
>  drivers/soc/qcom/Makefile                          |   1 +
>  drivers/soc/qcom/minidump.c                        | 272 ++++++++++++
>  drivers/soc/qcom/smem.c                            |  10 +
>  include/asm-generic/vmlinux.lds.h                  |  13 +
>  include/linux/meminspect.h                         | 263 ++++++++++++
>  include/linux/soc/qcom/minidump.h                  |  72 ++++
>  init/Kconfig                                       |   1 +
>  init/version-timestamp.c                           |   3 +
>  init/version.c                                     |   3 +
>  kernel/Makefile                                    |   1 +
>  kernel/configs.c                                   |   6 +
>  kernel/cpu.c                                       |   5 +
>  kernel/fork.c                                      |   3 +
>  kernel/irq/irqdesc.c                               |   2 +
>  kernel/kallsyms.c                                  |   9 +
>  kernel/meminspect/Kconfig                          |  30 ++
>  kernel/meminspect/Makefile                         |   4 +
>  kernel/meminspect/kinfo.c                          | 284 +++++++++++++
>  kernel/meminspect/meminspect.c                     | 471 +++++++++++++++++++++
>  kernel/panic.c                                     |   4 +
>  kernel/printk/printk.c                             |  11 +
>  kernel/sched/core.c                                |   2 +
>  kernel/time/timer.c                                |   2 +
>  kernel/vmcore_info.c                               |   4 +
>  mm/init-mm.c                                       |  11 +
>  mm/mm_init.c                                       |   2 +
>  mm/numa.c                                          |   2 +
>  mm/page_alloc.c                                    |   2 +
>  mm/percpu.c                                        |   2 +
>  mm/show_mem.c                                      |   2 +
>  mm/sparse.c                                        |   6 +
>  mm/swapfile.c                                      |   2 +
>  39 files changed, 1725 insertions(+), 55 deletions(-)
> ---
> base-commit: 343f51842f4ed7143872f3aa116a214a5619a4b9
> change-id: 20260311-minidump-v2-eed8da647ce5
> 
> Best regards,
> -- 
> -Mukesh Ojha
> 

