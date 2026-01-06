Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F1DACEFD08
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 20:51:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 381F56B008A; Tue,  6 Jan 2026 15:51:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32FB16B0092; Tue,  6 Jan 2026 15:51:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22E236B0093; Tue,  6 Jan 2026 15:51:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0EE4F6B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:51:00 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9F7C8160BAD
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 20:50:59 +0000 (UTC)
X-FDA: 84302733438.29.072F222
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf24.hostedemail.com (Postfix) with ESMTP id 86EA918000C
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 20:50:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Jx3ql06Y;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767732657; a=rsa-sha256;
	cv=none;
	b=VxQhdV9PUuN9BvZMR4Pk2+Pbk9BFnSWoJGb16VGQtb3XolPDpWiEOfWEX83M3N/5BhLH7Z
	XJgZkLfxxrJDwg8HUInKf7tLfwM0EaW94Ifcfbs767RzQxZC8JBTMkuiTVorNeuieA1lF4
	mQsM0anIwAjJzJhehWt/Tr60pARa5Do=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Jx3ql06Y;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767732657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=QpI9ypWcetAhIdT4SaIvObEhpKnFS/FzJJod0lsjqXA=;
	b=GSPBCcpW0J2TMF8kFVi/OWV7fdVLmQkCMbDwZtR6M51h/M0MMHtEIrXt6xoYebmBsAEncg
	dlaP0jtqSGLgUKwbSQR3w1KfRcGRSN6T8IWGl4c7nKCp4ztlakRnzUbU9Yhm5F++kdQy8G
	uV0gs8ScXW0bG8tZWmLn58oLP9NJg6s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767732656; x=1799268656;
  h=date:from:to:cc:subject:message-id;
  bh=4aS/irjc/0UjcNZce21ngtGjOsRmQB79kwS9yXfL64M=;
  b=Jx3ql06Y/1CMDcdS1RQ6PkJOeJzjC4iqS3MW/jDcvrVoMerR6L0TW1Lu
   RP/qzw1yQzza1JJ/hy5O8xHCr+3WLjbv7panKa4EIojKJ2uvUnkkadGQX
   dvYsfba6C4UVwz6oPrA6sHd6rd2NZmAy4OT7ohiwG18gcc74TFx3DgMLN
   COFeUC8Ocnzyyfs6JwiuKNekRRyKRsNV/YLkxFNcMAz4Ryg7iJUqoGp5s
   bb7RQ0YOKLMkCYTx98vodV9qIObonhkOgO7yrkLKj50fm/Q6bHXB6kSra
   LOAKTU4td5n90mqXGtkkmvWflebEm6LZEu+Q604bJsQ7j4vFCMbFcnbvI
   g==;
X-CSE-ConnectionGUID: CWw+SBM5RD6Jm5rWn6VcjA==
X-CSE-MsgGUID: OCKPqoESTqCcTmw8F+iXaw==
X-IronPort-AV: E=McAfee;i="6800,10657,11663"; a="69177859"
X-IronPort-AV: E=Sophos;i="6.21,206,1763452800"; 
   d="scan'208";a="69177859"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 12:50:54 -0800
X-CSE-ConnectionGUID: nzMD/zzzQCWGdL5Gehr5hA==
X-CSE-MsgGUID: lSYvNpvaQhKsknnwtvw4yw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,206,1763452800"; 
   d="scan'208";a="202510119"
Received: from igk-lkp-server01.igk.intel.com (HELO 92b2e8bd97aa) ([10.211.93.152])
  by orviesa009.jf.intel.com with ESMTP; 06 Jan 2026 12:50:53 -0800
Received: from kbuild by 92b2e8bd97aa with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vdE0s-000000001Mf-0gTP;
	Tue, 06 Jan 2026 20:50:46 +0000
Date: Tue, 06 Jan 2026 21:50:40 +0100
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 linux-doc@vger.kernel.org
Subject: [akpm-mm:mm-nonmm-unstable 105/107] htmldocs: Warning:
 MAINTAINERS references a file that doesn't exist:
 Documentation/core-api/kho/bindings/memblock/*
Message-ID: <202601062108.Zji1qYKz-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Queue-Id: 86EA918000C
X-Rspamd-Server: rspam04
X-Stat-Signature: cp4p8cxhc46i993jwm5ic4hwirbb34w7
X-HE-Tag: 1767732656-597935
X-HE-Meta: U2FsdGVkX1+C9sAhYRR+8InmjEANYBDt9K/5BYKnWcT+Zb7Wj5T1RJO7sZ++MpPiOTQQTHXJz+0dpv/xryIap+uEv2QHELEmVChcpIYXgE5VqMcsVv2aiEBCSusjMHXXmSmp+r+160PmguswLqGgnrVb08XV72LwRO2mDgnStOr5bIgkgE5r9nrykqBXNKut5qjvH25Zv4m3OgLI/xZqFnEsZaTlUrxLY+c/hniDarjp/pqhavaveWhzPVtrH9MAsx52GvkpeOvK0vw7aIXkQzhxTa0p8EzY8uZ1qLENZR+AXHDPmM9jUEwT2TS64HAMkjtfZGq8FDPP+XW4H7NkzPfFdEVFtvE+yvb29S2OMemGwTeoOsKsZ1AfRqxO6Cnlz4J9MwBo3dtuV1GY2LDKAIu8ZPhmtYF4wpzdu1z6+oZ4Q9j+Y7HJWF7eQlBS0G9GXhCxNjv438M6U0WtGIVTVxTi1ypciUlsA2jrX+DHxP4AG33LCWv2toNTM03cRMYBt52qvdx15PkTRtDyMf0SuQbY8lFM5DyPBKSlD4aztnbXHP0ByV//lmqmGZb/qf9Hsptqjn02L3ziPz0zObJQ9sfgrtmc0QsRgqgD++upExn0quiveMNvNphDymsGuI8OWeV0iaGAwauf0ZXnIC+bGmOz+U67YYjkFSWvmWBiGSNou4Qb7trKDU8aVgkpL/wAndVSilNnNRAL1m/6ttjEmCBEhtwF+fz6rOcM9t5eCdHjFDufmzqU4MOfwQhwigc3/StpDU26pf99AHmXQPRnWCacQaLkp2PiiDn7LKfvssDLXxPaGos6Z08PaZhF78vh7BgTvznI9vHNVBr7Y1YTo6s7L4AWI2ElG+2kzUH9kYLw2ZTH7EEGl4ynmcvuGQqtwQVGSAFKNFxBH/bQWR/KegKHypGyisI9vtX/smZXGZKkDdr8thNNi2H8fY7rhFSYnfXT7zejkv/0Zl1TP+V
 7gOHBTq+
 ahmxwoiqUg7003ACKbZcEe65FiPewt7zvSh6mlarnSUAX5Fc0xfXFsM3M5Y5l3rUPuwzcwwijm2n7OxJx+znqOGu323QQ3Z5v74PSf3Z3psW7KiodLD4DvwiLveYk6pZdT/1AaoHo8Xy4R6yVTYiZ/S8gU5PrdlDreguFTY06jfMuf7ncKx5lhlIDMYs/+3alwl1abmaGmfYpLYylMs1LSXipOjUIB4Bh2ZCAhYBXZbF1jCwClS4BRxaQNQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
head:   bf64790fd7f2a71c84dada79a573d37cb08adbe6
commit: eb740b17afda02cf4df31bf10dd9a1450e5ad158 [105/107] kho/abi: add memblock ABI header
reproduce: (https://download.01.org/0day-ci/archive/20260106/202601062108.Zji1qYKz-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601062108.Zji1qYKz-lkp@intel.com/

All warnings (new ones prefixed by >>):

   Warning: Documentation/translations/zh_CN/scsi/scsi_mid_low_api.rst references a file that doesn't exist: Documentation/Configure.help
   Warning: MAINTAINERS references a file that doesn't exist: Documentation/ABI/testing/sysfs-platform-ayaneo
   Warning: MAINTAINERS references a file that doesn't exist: Documentation/devicetree/bindings/input/touchscreen/himax,hx83112b.yaml
   Warning: MAINTAINERS references a file that doesn't exist: Documentation/devicetree/bindings/media/mediatek-mdp.txt
   Warning: MAINTAINERS references a file that doesn't exist: Documentation/devicetree/bindings/display/bridge/megachips-stdpxxxx-ge-b850v3-fw.txt
>> Warning: MAINTAINERS references a file that doesn't exist: Documentation/core-api/kho/bindings/memblock/*
   Warning: arch/powerpc/sysdev/mpic.c references a file that doesn't exist: Documentation/devicetree/bindings/powerpc/fsl/mpic.txt
   Warning: arch/riscv/kernel/kexec_image.c references a file that doesn't exist: Documentation/riscv/boot-image-header.rst
   Warning: drivers/clocksource/timer-armada-370-xp.c references a file that doesn't exist: Documentation/devicetree/bindings/timer/marvell,armada-370-xp-timer.txt
   Warning: include/rv/da_monitor.h references a file that doesn't exist: Documentation/trace/rv/da_monitor_synthesis.rst
   Warning: kernel/liveupdate/luo_core.c references a file that doesn't exist: Documentation/core-api/kho/concepts.rst

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

