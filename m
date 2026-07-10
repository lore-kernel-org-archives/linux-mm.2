Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68E73C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 01:51:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5FD06B008A; Thu,  9 Jul 2026 21:51:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E10F66B008C; Thu,  9 Jul 2026 21:51:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFF0D6B0092; Thu,  9 Jul 2026 21:51:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A3266B008A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 21:51:55 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1F1EB8C65E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:51:55 +0000 (UTC)
X-FDA: 84971190990.29.3933FA4
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf11.hostedemail.com (Postfix) with ESMTP id 70F1240006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:51:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Y5vWpFZo;
	spf=pass (imf11.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783648313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c2AhhBh/dPKvgPqtDJOCEU1oiwd5ZFn4bkZTsDVrv3c=;
	b=2gFZdhCrQBrJTvzGhiq8Jve/XD/XTper+fIvkBX6LR9yxqi+PMIyZM9Hf/FueEM2KCEnIj
	6fG1DOIZsX80aedB5epBaG+UyYfhIpK+yYJq01GkM9BQPkrBG+0RmALrv+rJlNI1WiYNZq
	ONWGRxUvXQWRzGAjBSWws+xOcRjf01w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Y5vWpFZo;
	spf=pass (imf11.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783648313;
	b=be9JsIzLV1AjaGclDrDk9FuAY0O0oqx6/27iPHJt5SDDexEKhMTMtTSvLEloUG1osPXrzt
	yDEZNMJJy2ovE7IjlXWebUfX7pIOdzR8MXaLpUA+3Wus4W5jJclj+pBuhsmGgN03oJty/a
	Fy9bdJia0rzusCbUkLBgE1xP6oskXOQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=c2AhhBh/dPKvgPqtDJOCEU1oiwd5ZFn4bkZTsDVrv3c=; b=Y5vWpFZonQ/LY+i1UBGa2Z4f99
	vuERjYW/ZVTlXMXTEP4AO/8mbKIpiN12ghufQgu//DSUoOx2b/Y3ROrhk2J63fBEuZkJrYKheJMmX
	6ejdpPeNbgf4u8vSOQ9PNws/1ieWbYh3rKGJ0smYalQupMkC2tbipQnVGAW363kTZwHljN0YS9DF+
	/WB7wtwhUxThyRt2u7tpTigMsZ7z0mAkKZBEP7ZRysa0RUYh4arwFN0MeuDjTdyfYehiLljNd2FlU
	VNONKPrqarbM57BywC62i2UCuJAfdmXTexbwNrJUT1O+dN2JVauVMuGH83EhnNANpkWhZMM+/RBtA
	H/JNBwdg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wi0Ok-00000003vjK-0uru;
	Fri, 10 Jul 2026 01:51:26 +0000
Date: Thu, 9 Jul 2026 21:51:06 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Cc: Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Eugen Hristev <ehristev@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, Frederic Weisbecker <frederic@kernel.org>, 
	John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, Kees Cook <kees@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Petr Mladek <pmladek@suse.com>, John Ogness <john.ogness@linutronix.de>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Bjorn Andersson <andersson@kernel.org>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Saravana Kannan <saravanak@kernel.org>, 
	workflows@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-arm-msm@vger.kernel.org, 
	linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 00/26] Introduce meminspect
Message-ID: <wpwqpdrwj664tzpijvtui4eqg45uismcltf752h6dxmpiklba5@4zttrmspzhva>
References: <20260708-meminspect-v3-v3-0-7aa5a0a74d5c@oss.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708-meminspect-v3-v3-0-7aa5a0a74d5c@oss.qualcomm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 70F1240006
X-Stat-Signature: nh73yncwtcycjngn776frfpkqs6x7omm
X-HE-Tag: 1783648312-872348
X-HE-Meta: U2FsdGVkX1/afdF+lzKfMF8DhJYv8bTnYRTtEhZCzbAZHpd/qhQloJyOOlKfuMQ3vPs0Y8D/hz5sSAa+LdvANtInIIlfLwvqheRkfLSqdskhSnidTVgYBdX6Q2kdZn49EH67qEmulhJ8Expc/bhiaGk3QLW//GcqqSfhowGPW4ygCZKFEdkZ+x/4PpcQw0olmTc/rfRF7BaJzwxSPZeC3Kne223tyc1lqu/vVz63xnnG2/1I9eFSgU+68XwWkHE3AREF/0BdJXv7TAaTxc5J2wxcDM+LAJ6gaTa8g5PscTrWnd636YMIHHbtXM/C0JD/ZOlYi58QGP6NCIQoIVKMYrpIa1JHMvTusU4gSwGpIreFJ7v8qXImjWd+7Lk0eDIcCd1DGBIlyspp+WgqMoxgeSAGYPUn2STBf4E6Pl8cSmYcLsNsQ85F2h0LLyXLnHl3joeiY39FVe9q8xAcYDnNvywdK2po1DBo8vUBusb3kvwh8fSH3hNPYJRDroYqCkMnunkgue7oW0WI+LzEheQZ+Eskm9C6UmSBnJIVluwsOykmwMizTF0x/pog9E3HS3OkEoTDsQFN6Y1oKENy8sHcIpeX22w/n4OcEFzsZXMd/O/Hy+U6YXf9+yBVDEgkeU3/zomm812MqHZgceTAlTHoI/aIkUZK+HtHPcQA+dLEsbsES8oyzVlFFvv5jLUfWKdlM+CourwApxBpFGdop0fn1SR5/J1ogyM32wGDf6SHfAW7/Jb4TyFAmea+RBZW4kZqhX0zflpVJXBMQztNKErJMwTQv/TupZIfVvQqW7RoLbgrSGjZiLbBh7kvYkEVYPh6vP45k1bA1qHj1I3jm7+z45u4TeHBHhB9NKCKcYZHcFq7FeOn42aPfZkzvwSHiyHXlZFb5xNU9wZzWlMgXrlzOCd5JV8ZVtUYkWS+yUQ5vS/3dCKut5Hc1b29dydmuWtZgEM9VEyN9aIp6Z4Vgxa
 7zCjSYxf
 UL4zL/zZtE73h/OPN6Whq4MX+KLE6aRDwLA+oTGtnMSw2EfQEQzSr3yy33imACVZYjf4vgAt2mmdLL5/XZXmQzlu9fmjuct8F2vmwl++pFvnrh/wgflNcqtNdY78ROZoeijwgwuic2qJXYMSkqdoJ8eEZ2xpEcNT9UOoJlBxCrImCASpzBclqVXZj/XVjqSs5HjDgtrHC7gEdaPnIlk3GQKtnbQqD2vy8OikyDBOBf7GWvfoBsYXvdEyZbxr7pIRZffDUFJmhWfpWzbNkKDqKghPJfxZu0olRSr7nx79LY8qLnfUe1u6cqP8J00fsl7U2M+Wc4JAe3kLUKXOg+JKx1xiO3HiBWz74xXGqWsf1CUE7a8pTRC0QUnu0fUkFNVJagkQHukXKuCURSCBpm7t0fWlNuK/P7HSWbzrFUAj2PQGt2wp7IsvNGFoU4WORXGufrf5WcMm7uGI8NxRECxUj9htscf6AwNJYHmHCLz33QY83Eo0/I5vZIGGuq5w/ebqcSK6sTfxoRXrw89eHXXN2ocUzh3B/UiMJD0km+vUNcStw9BS6C7XuqQwd+5kqqe9NlVydwlyGQ8o5bgDsizzrZRctdmvdyMht4cK2dzC8Ofq3WAly4/aNzAk98A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/07/08 11:01AM, Mukesh Ojha wrote:
> First of all, I want to thank Eugene for his excellent work on this
> series. What began as the Qualcomm Minidump driver from me has now
> evolved into meminspect. He also presented meminspect at Linux
> Plumbers 2025.
> 
> Video of the recording is available here for anyone interested:
> https://www.youtube.com/watch?v=aDZv4-kOLSc
> 
> Introduction: Memory inspection mechanism
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
> not. Pstore relies on persistent storage, a dedicated RAM area or
> flash, which has the disadvantage of having the memory reserved all the
> time, or another specific non volatile memory. Some devices cannot keep
> the RAM contents on reboot so ramoops does not work. Some devices do not
> allow kexec to run another kernel to debug the crashed one.  For such
> devices, that have another mechanism to help debugging, like firmware,
> meminspect is a viable solution.
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
> Tested on Qualcomm SA8775P (Lemans EVK) on next-20260707 with the
> minidump backend: kernel crash dump regions correctly captured
> via firmware.
> 
> This series introduces a new cross-subsystem framework and, to
> avoid merge ordering issues, I suggest the entire series be taken
> via the mm tree. Subsystem maintainers for touched files have
> been CC'd; I request an Acked-by from them if the respective
> patches look fine from their side.


You are adding a cross-subsystem framework without tests?  How did this
get to v3 without tests?  Surely there were bugs during development and
you added new tests to make sure there wasn't regressions?  Where are
those?

It's a firmware debug framework for qualcomm devices?  Why would we want
to allow such an invasive change in core kernel infrastructure to help
keep firmware blobs big?  It really sounds like the wrong direction all
together.


> 
> Alternatively, the qcom backend patches (22-24) can be deferred
> to Bjorn's qcom tree in a follow-on series once the core
> meminspect framework lands.
> 
> *** How to use meminspect with minidump backend on Qualcomm platform guide ***
> 
> Prerequisites:
> Crash tool compiled with target=ARM64.

What other targets are supported?

> 
> Target kernel must be built with: CONFIG_DEBUG_INFO_REDUCED=n;
> this will have vmlinux include all the debugging information
> needed for the crash tool and CONFIG_MEMINSPECT,
> CONFIG_CRASH_DUMP, and the driver CONFIG_QCOM_MINIDUMP.
> Kernel arguments: Kernel firmware must be set to mode 'mini' by kernel
> module parameter like this : qcom_scm.download_mode=mini
> 
> After the kernel boots and the minidump module is loaded,
> everything is ready for a possible crash. Upon triggering a
> forced kernel crash, the target board will wait in download mode,
> where QDL (https://github.com/linux-msm/qdl) running on the host
> connected to the target (here, Lemans EVK) can be used to collect
> minidump.elf from the target device onto the host.
> 
> Currently, --minimal mode is being used to get dmesg log from
> crashed device.
> 
> Without --minimal mode, the crash tool needs to be patched to
> not crash on missing symbols and needs to be tuned, which I am
> currently working on in parallel.

It sounds like your debug tool needs more development to avoid crashing?

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
> Changes in v3: https://lore.kernel.org/lkml/20260311-minidump-v2-v2-0-f91cedc6f99e@oss.qualcomm.com/
> - Addressed most of doc. comments and binding and 0-day kernel
>   test robot warning.
> - Add timekeeping: Register tk_data into meminspect
> - fixed some of the bugs identified during testing.
> - Fix missing return before dev_err_probe() in qcom_md_probe(); all
>   three error paths (SMEM lookup, table validation, table init) now
>   correctly abort probe on failure
> - Fix meminspect_traverse() kernel-doc: @priv description corrected
> - Fix meminspect.rst: replace stale MEMINSPECT_ITERATOR_CB type name
>   with the actual meminspect_iter_cb_t typedef
> - Add kernel-doc for meminspect_iter_cb_t typedef
> - Lot of code formating and style change as per coding standard.
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
> - Reworked printk log buffer registration based on review from Petr Mladek.
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
> Mukesh Ojha (5):
>       timekeeping: Register tk_data into meminspect
>       mm/numa: Register node data information into meminspect
>       mm/sparse: Register information into meminspect
>       printk: Register information into meminspect
>       dt-bindings: reserved-memory: Add Google Kinfo Pixel reserved memory
> 
>  Documentation/dev-tools/index.rst                  |   1 +
>  Documentation/dev-tools/meminspect.rst             | 144 +++++++
>  .../reserved-memory/google,debug-kinfo.yaml        |  48 +++

Probably shouldn't be here?

>  MAINTAINERS                                        |  16 +
...

I really think you need to step back and think about how your firmware
and driver can gain information without requiring so many tentacles
across the kernel but also without having an entire dump of ram.  Maybe
your firmware is doing some of what the driver should be doing?

It really seems like you are trying to upstream QA for firmware or
device issues and I don't see an argument against that in any of your
responses to any other emails.

Your problem statement seems to be: a phone freezes and we need our
firmware have global access to all memory to tell us why.  To reduce the
dump size from all of the memory to some subset (up to and including all
of the memory), we want to give our driver access to all of the memory.
Is that correct?

What is even more concerning is that you aren't limiting this to debug,
but also to statistics and usage.  Leaving the door open to larger abuse
of the access this cross-subsystem framework - with no testing - will
allow.

Thanks,
Liam


