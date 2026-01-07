Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14628CF6BFF
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 08:39:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D5E66B0095; Wed,  7 Jan 2026 03:39:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 683D06B0096; Wed,  7 Jan 2026 03:39:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 583776B0098; Wed,  7 Jan 2026 03:39:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 450D16B0095
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 03:39:02 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CCF07160206
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 08:39:01 +0000 (UTC)
X-FDA: 84304517682.22.69B7329
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 13FF240002
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 08:38:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tytTq0KE;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767775140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5IuCnYAnA7o+YDEn1qrCdHwHB4JdEgoBt5sBiVZtyUM=;
	b=rsDdiq2jbbcEgRCBXDHcmA8++XorOXiPOJcchTVET5oLTw8H2+6H9ejEmDExCrkaiBFi/4
	4rTK1bPOZLSv9iry5Dg+j7inBUBcP3fUykte5iGvx1dC5majrIOvvroz798IDPlv+MGea5
	Rawu15xuhD8qTN5B3LdhGl8hhAAP7pE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tytTq0KE;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767775140; a=rsa-sha256;
	cv=none;
	b=QwYcE4b9p8MWtGwMOC8flA43Dyw+9qhBGL5OrLDPH4ODYlIOuzqjcGQ3giQ8gA5zISk9Gw
	uoE3JPMzXGcfFwD6uVFbFGjZMcA2T7j6s1EQi2UWJEHdEewA2hs985LYaIV4SEohfaV4y6
	ja6IqYGRryFuuZE32K8bVPVlf1EU6xg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E444543AAC;
	Wed,  7 Jan 2026 08:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02FEC19421;
	Wed,  7 Jan 2026 08:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767775138;
	bh=zI9NvW+Chi/NqcOnZO2f4rvHFuHVtmoe/6GjcEeeLbo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tytTq0KE5g9qGvkv7sGYG54J2g00p3+cT++aX5HrUHCOhb2qVlAW08w6xeFmG918M
	 8qbwZLzdIFgxqbDSKtAWpJV5xz34s8ExZ6N5sRubhM9LrjV5lCMhlrVzNw2YSwUCPZ
	 pk4EvKdUjZ+0zFcMJK+oSl4yZVhOjf46RTn0CDhKDQWs8jqW/KRfD7vzYiKvDHYRou
	 DVNBDyj5FCp3ta5mHaZUUVNeD+ycW4dnPVxY0cu6oYfhjzpLeGLFjB6y302xpKb4aZ
	 G41MA099ytUg78FT4wIYH4zoIEtvp4GxV64DVbe2QB+YgSDSYj5HQfTxerAB5YJy/q
	 B9Oqytu0iQ+Pw==
Date: Wed, 7 Jan 2026 10:38:52 +0200
From: Mike Rapoport <rppt@kernel.org>
To: kernel test robot <lkp@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-doc@vger.kernel.org
Subject: Re: [akpm-mm:mm-nonmm-unstable 102/107] htmldocs: Warning:
 kernel/liveupdate/luo_core.c references a file that doesn't exist:
 Documentation/core-api/kho/concepts.rst
Message-ID: <aV4bnHlBXGpT_FMc@kernel.org>
References: <202601061635.i4VQmlUw-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202601061635.i4VQmlUw-lkp@intel.com>
X-Rspamd-Server: rspam02
X-Stat-Signature: eg8nyokjur8af7qyz8p9chuw1e5ibcoa
X-Rspam-User: 
X-Rspamd-Queue-Id: 13FF240002
X-HE-Tag: 1767775139-423670
X-HE-Meta: U2FsdGVkX19/yh4zwgwp8uqfBjbVDXXRlgPz1XhuVyT/10QZhi6GvxrHVcYu9C1SWaO8O4/tj22kyCx+52xyIw16n/biKuEuAltx7IDspNHmT8w29tPRU0Djj9buv0CkpNX04o75LXLxMOwOEbQ2UgwAUa1PkkKfmvUc6AuScpdC+FPK/xFNdISnxa+TUe4dHGSyDowRwMUJInLSya3Vo8i9cCGEDdG5De/5UCa0zs1Jkd8raVfNhcOXg2Qw5R2vf1XyVd8CHQOVkL3JMjZcvc+khhbh54vuM9eHk+gU9pVYeEaqTPusd+gNByAWO+3NzoSeP1sGsHD6l4s3YHsMtR7tyEvZU7PRFnicMrmDUjatOIL5vxeVl+rh94dGFVlWXn0XT9u3suDxVUjJdYIwXITIJm6302Ju6YXRfNzGgA5rvw8rbxTzsBM7Ow5seTwXwWMpF0abHjNx/uF6+GZhv0rRBj3vwPq6y/64p7A/eTsm2xo3lDaiRIoDAo+q30pcE0MuiUG/LI7RDRhvnO8jsvroQQ+HT2uqB0YjudjrfPdzvd+WCL01/0QAK/qxNkoVyDu6o9ZPJtBTPzK8dlp9IBJU3CFBUoWQs7E7l337w5LBpI3wIRFkr5ELaHeMvESMqLzxoYDppi+hmGXvxZg6AOV3wvOAfWxzrlzE2oFaVmk9KjMZ4Ngxf2v8nQbu2TlEKLgKoX1NwwhJ4skTIpoNXv55+H2v23rcb+r5qjC1ljHkX4xjaftU/v4QWqJKvQ9BPxKvlwWuXOajp7y/11LaJ/b43KqgaLLthTz98ccoz/8zVHMR5kg8FRMaa/Su2o9Hn8gHfTANX0bYDf6i8pdKNH++9wOCsMi/st32RQYU3P1/zl550Fg28QiV1eFrUeC6SV/AVt3aBTKVBJAQ2zg9Uup474EoPBNr+KZls0aNaSAM9COA59kgpT8O7tMcd3WV65SOzSNQ/8sCR2fWUBF
 jTTlM6lh
 xCCdFaWSyfy4LSI6nBe7Vwl9Pq0Q1SC/Pbk8UR5UNZ7uTryB2If4sXygqq9CT9ully8MGvwm+cO8DtfcF5D4aETKid4bTeUl2dsRPYPyJTHOujCcFsLcco1XDpzMjrvCDqKfF5FWU2QS8A2XAQ0xltMbUHer0ulKmWE7MnIh03ZBZdOgepj36b/F3RKZlNsWH/T+uzjZPh/yd7xfcEE3uheKl0cMA6aZ/DmCE+Csy84TAGO2HCNQ5nUlBkhqydHe6udCO0fs+tkr3/iLfN2Pt3GFCr9I7Dc5vHWpHAzcgXGZDrjlAIdCNT/D5YcWNDU0HabFlS6RSrtSSc5t3V1BYXlQHSHCeljrstSjyHX8wgXg0fAcYiQiTIkEDU1anILezSGLbYCWTSfxWrU2HmcoeZ1IDAIeJH1a+xjKgc5zO099UDM8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 04:52:06PM +0100, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
> head:   bf64790fd7f2a71c84dada79a573d37cb08adbe6
> commit: eee99407da66f5f657ba0599b4d6157b59be3721 [102/107] kho: docs: combine concepts and FDT documentation
> reproduce: (https://download.01.org/0day-ci/archive/20260106/202601061635.i4VQmlUw-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202601061635.i4VQmlUw-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
>    Warning: MAINTAINERS references a file that doesn't exist: Documentation/devicetree/bindings/display/bridge/megachips-stdpxxxx-ge-b850v3-fw.txt
>    Warning: arch/powerpc/sysdev/mpic.c references a file that doesn't exist: Documentation/devicetree/bindings/powerpc/fsl/mpic.txt
>    Warning: arch/riscv/kernel/kexec_image.c references a file that doesn't exist: Documentation/riscv/boot-image-header.rst
>    Warning: drivers/clocksource/timer-armada-370-xp.c references a file that doesn't exist: Documentation/devicetree/bindings/timer/marvell,armada-370-xp-timer.txt
>    Warning: include/rv/da_monitor.h references a file that doesn't exist: Documentation/trace/rv/da_monitor_synthesis.rst
> >> Warning: kernel/liveupdate/luo_core.c references a file that doesn't exist: Documentation/core-api/kho/concepts.rst
>    Warning: rust/kernel/sync/atomic/ordering.rs references a file that doesn't exist: srctree/tools/memory-model/Documentation/explanation.txt
>    Warning: tools/docs/documentation-file-ref-check references a file that doesn't exist: Documentation/virtual/lguest/lguest.c
>    Warning: tools/docs/documentation-file-ref-check references a file that doesn't exist: m,\b(\S*)(Documentation/[A-Za-z0-9
>    Warning: tools/docs/documentation-file-ref-check references a file that doesn't exist: Documentation/devicetree/dt-object-internal.txt
>    Warning: tools/docs/documentation-file-ref-check references a file that doesn't exist: m,^Documentation/scheduler/sched-pelt
> --
>    ERROR: Cannot find file ./include/linux/mutex.h
>    ERROR: Cannot find file ./include/linux/mutex.h
>    WARNING: No kernel-doc for file ./include/linux/mutex.h
>    ERROR: Cannot find file ./include/linux/fwctl.h
>    WARNING: No kernel-doc for file ./include/linux/fwctl.h
> >> Documentation/admin-guide/mm/kho.rst:10: WARNING: undefined label: 'kho-concepts' [ref.ref]
> >> Documentation/admin-guide/mm/kho.rst:31: WARNING: undefined label: 'kho-finalization-phase' [ref.ref]

Andrew, can you please fold this into "kho: docs: combine concepts and FDT
documentation"?

diff --git a/Documentation/core-api/kho/index.rst b/Documentation/core-api/kho/index.rst
index f56579b5c351..dcc6a36cc134 100644
--- a/Documentation/core-api/kho/index.rst
+++ b/Documentation/core-api/kho/index.rst
@@ -1,5 +1,7 @@
 .. SPDX-License-Identifier: GPL-2.0-or-later
 
+.. _kho-concepts:
+
 ========================
 Kexec Handover Subsystem
 ========================
@@ -69,6 +71,8 @@ for boot memory allocations and as target memory for kexec blobs, some parts
 of that memory region may be reserved. These reservations are irrelevant for
 the next KHO, because kexec can overwrite even the original kernel.
 
+.. _kho-finalization-phase:
+
 KHO finalization phase
 ======================
 
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index 944663d99dd9..a26c093eb8eb 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -35,8 +35,7 @@
  * iommu, interrupts, vfio, participating filesystems, and memory management.
  *
  * LUO uses Kexec Handover to transfer memory state from the current kernel to
- * the next kernel. For more details see
- * Documentation/core-api/kho/concepts.rst.
+ * the next kernel. For more details see Documentation/core-api/kho/index.rst.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

-- 
Sincerely yours,
Mike.

