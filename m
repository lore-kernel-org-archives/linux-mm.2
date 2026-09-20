Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FFA8C982CC
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 06:22:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 415046B0092; Sun, 20 Sep 2026 02:22:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C4466B0093; Sun, 20 Sep 2026 02:22:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B40D6B0095; Sun, 20 Sep 2026 02:22:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 063906B0092
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 02:22:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2E63BC03DB
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 06:22:39 +0000 (UTC)
X-FDA: 85233146838.01.23B1767
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf10.hostedemail.com (Postfix) with ESMTP id 226B9C0006
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 06:22:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=m754eoa2;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789885357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=wYdxocCwHig1AELshrVccy/r0QkSB1bsAqgOpLu94Xk=;
	b=VlrbiiQ59fvk2gvpd50FVM2UwwNr2WuP/GvOD9KtCg+d3f9ze/fjYjUCiBCnBy5LmPMrYY
	zGi3gVpPKGlSGtPD3X4KyihpKWduoJSlYluBx9NUoxY4POeQv0RTfUf8JnuDSQ4za/yzTB
	qjdIW9Cf4ZNS3nM5UCqT4vZPKeeuago=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=m754eoa2;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789885357;
	b=ro7Oo35/Dtlbz7467GqUZrJI2YiLUjPSOGEFinxkP34st3Da0v978yeTTC0aDUQ72VzASM
	zYkjEOk0l/Jsnt62NfUQeAjk3GS1/hZZML0GnJLEtJnlCp0EoBqVBMrZRLeZm+tCsO9zKw
	7G+Z5kPTwb+VWDQniV1nXgZj4Kq3l8g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789885356; x=1821421356;
  h=date:from:to:cc:subject:message-id;
  bh=DAD1qQYOIfMJLd6V13t62KZMwlK+iSSfuAvjuCsYRNU=;
  b=m754eoa2/LDAR7JMojfCr4q1ZPv7A7rLMx9/lgyHQRhBbAd01ehXGuEJ
   1+ISNDnUnqoXXtMXBQrx3imSAHKWMzPWcbily+k9ygRUKpSBHya2x/DRu
   1G0J/zN5Dckk3oDMJeJiVrxAIQBUf5OQ7Cx/eTqd2ggfPvKOK4tBdNc/3
   yJi/lDGgA01SE9fGv8IPw9CAPIX71dRSXZdTOzqxve40RuuX9TAa+uv9N
   iX2Cq6ji529Tgix0iLnes9bkqXDiXEfC91v2E59NYnLzhqLP4J0ndSovj
   QSaf89I9FYxCvScdi+xyafiai0+WH84ByAFDQkKXXM08mdgjSAq242gUH
   w==;
X-CSE-ConnectionGUID: s09fBTK6SnCx86TgsyS8oQ==
X-CSE-MsgGUID: E8Osu8uLS0iEus2L2nglXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11910"; a="89320567"
X-IronPort-AV: E=Sophos;i="6.27,111,1787036400"; 
   d="scan'208";a="89320567"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2026 23:22:35 -0700
X-CSE-ConnectionGUID: MU5IGxRqT8GdhNHzqte7bA==
X-CSE-MsgGUID: Kq+MQYP7RcKWT4s89fmL8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,111,1787036400"; 
   d="scan'208";a="300134301"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 19 Sep 2026 23:22:32 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x8AwW-00000000C15-0zke;
	Sun, 20 Sep 2026 06:22:28 +0000
Date: Sun, 20 Sep 2026 14:22:08 +0800
From: kernel test robot <lkp@intel.com>
To: Aaron Tomlin <atomlin@atomlin.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master 6196/6545] error[E0425]: cannot find type
 `initcall_modname` in crate `::kernel::bindings`
Message-ID: <202609201402.NyS4lCWY-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 226B9C0006
X-Stat-Signature: d1syc5dineq9y659cyy1b8ohndx84zx9
X-Rspam-User: 
X-HE-Tag: 1789885355-375160
X-HE-Meta: U2FsdGVkX19/zSR1H6yaUStGXk9YIukjEgtODpsMwaUuwI50CzR4G9zuY3CMLeUQcpDe2K9vl/zI/42ZZcBVBrl/LxzwckOcCjEYDq2C3UdkvJhfGjA7024Hou+4jz3MY9ZTatL43vJ+UjJkfjoV9VWSJb5NPDX8aONV9bpzjDvFt4WmYColZ1Aez6vlsHeWqqn2UAPMjCDQt1h5YYM0VEFc8TChgrC7/xLwlRkMtmX5Gg2UQQK2sSzmMalhBr3ETvHI064lmmU4nr5S2diSCYbbfX1NYCRtnrRa3fv6ZET7CysMUGWXUr6PP5mdb/pAGQb5uTWW02lG86WlRk8XDPlt+wolZ+ikBXiNTuTz85JqI6FmQ4R1cKZtKDkWpzXXfqVl9YTco2YFpQcUoOAxQHOClpCrc0qLB0syogI+22bIkKsTgOlAO+m8iNIMW6ffFb555hqHTgguT0UpkUjP15DmdoVMjkTdUz+UeqD7+NS/CB2dT5yv5TItgQ8u+Itplm/zedhmB4EpoWkiR3rdB8UyzPljV367VoWFRSraqUdUwA5XMRFVmh1vbTRvdx6nZhpt6vwAboFhVeKvkREUJqIzzkhM9E/yNkxL2L0En+62L+2Ia/kRVlzReyYNiiuQSST3+AAws1vCl4fiw4Uqqvspr4/G5/5FzjXlmEqwKXBNTknMEtGatnSsUs+JrYaNaMJlxFbR5LXgiq0E7UkN3OBIa1xsnsym+u4nbRi7S6QQ2wttSZYETNIwKXiAlnBSMl1CVu4RCyUg42F5mwLcC3QVV/9BlwvjBTca9CSNjiSb/1iFc+UYReihxobaKkQlxfTAhoeYIWCgUdoTQHEc/i1W51jxOnGSjaaB1LrJr6m3uaZiYPbpEAY2qpjlEH6JTgkib4P8oOAYey//x3UuISdDrNxSNPUMoxOWLNjJLYmbVEhRMeFYmNv3R1m98ogVqhupQ+2IL2JQid7VSXv
 R1a//fAa
 YGILEIgTUUAFmZH930KRY6gldVt0q5ldBeSWP0UGsFi0mQTGoPUZKlp7Nr9byU3hiVd9fGL/JQZg4QuV6JBvrf67z+gxPfbk9MWB+MoHKj+xZaBomuWEIPeWUxPz7MnSrZflyr5dWjPpfRFp0n+/1wtwdgRJ+QqhdIzouRCVlvBjOUzIwoB6QxOcxqXayjSFf6cAQDx0Q6zYOa+0T7nsXpPPlmxLxOUP9O2ix39Qxt+BKSH8NHcamHwEP4xSs56CycMoq5X+Bo0muYclH3iNTL3i7UCy0IDCeg1hIsEPCV6K5+l3J1oxPYyvrr/VI8kEzrD/PmHB3SzJJ57s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   3f2425f5b5bbbdd991ca9cdfd5502e68d8895998
commit: b83e83203582477b2ad0631e29e6fd88295cd9b1 [6196/6545] module: extend module_blacklist parameter to built-in modules
config: x86_64-randconfig-1010-20260919 (https://download.01.org/0day-ci/archive/20260920/202609201402.NyS4lCWY-lkp@intel.com/config)
compiler: clang version 22.1.3 (https://github.com/llvm/llvm-project e9846648fd6183ee6d8cbdb4502213fcf902a211)
rustc: rustc 1.96.0 (ac68faa20 2026-05-25)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260920/202609201402.NyS4lCWY-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609201402.NyS4lCWY-lkp@intel.com/

All errors (new ones prefixed by >>):

>> error[E0425]: cannot find type `initcall_modname` in crate `::kernel::bindings`
   --> rust/doctests_kernel_generated.rs:7459:1
   |
   7459 | / module! {
   7460 | |    type: MyModule,
   7461 | |    name: "module_firmware_test",
   7462 | |    authors: ["Rust for Linux"],
   7463 | |    description: "module_firmware! test module",
   7464 | |    license: "GPL",
   7465 | | }
   | |_^ not found in `::kernel::bindings`
   |
   = note: this error originates in the macro `module` (in Nightly builds, run with -Z macro-backtrace for more info)
--
>> error[E0422]: cannot find struct, variant or union type `initcall_modname` in crate `::kernel::bindings`
   --> rust/doctests_kernel_generated.rs:7459:1
   |
   7459 | / module! {
   7460 | |    type: MyModule,
   7461 | |    name: "module_firmware_test",
   7462 | |    authors: ["Rust for Linux"],
   7463 | |    description: "module_firmware! test module",
   7464 | |    license: "GPL",
   7465 | | }
   | |_^ not found in `::kernel::bindings`
   |
   = note: this error originates in the macro `module` (in Nightly builds, run with -Z macro-backtrace for more info)
--
>> error[E0425]: cannot find type `initcall_modname` in crate `::kernel::bindings`
   --> rust/doctests_kernel_generated.rs:12639:1
   |
   12639 | / kernel::module_phy_driver! {
   12640 | |     drivers: [PhySample],
   12641 | |     device_table: [
   12642 | |         DeviceId::new_with_driver::<PhySample>()
   ...     |
   12647 | |     license: "GPL",
   12648 | | }
   | |_^ not found in `::kernel::bindings`
   |
   = note: this error originates in the macro `$crate::prelude::module` which comes from the expansion of the macro `kernel::module_phy_driver` (in Nightly builds, run with -Z macro-backtrace for more info)
--
>> error[E0422]: cannot find struct, variant or union type `initcall_modname` in crate `::kernel::bindings`
   --> rust/doctests_kernel_generated.rs:12639:1
   |
   12639 | / kernel::module_phy_driver! {
   12640 | |     drivers: [PhySample],
   12641 | |     device_table: [
   12642 | |         DeviceId::new_with_driver::<PhySample>()
   ...     |
   12647 | |     license: "GPL",
   12648 | | }
   | |_^ not found in `::kernel::bindings`
   |
   = note: this error originates in the macro `$crate::prelude::module` which comes from the expansion of the macro `kernel::module_phy_driver` (in Nightly builds, run with -Z macro-backtrace for more info)
--
>> error[E0425]: cannot find type `initcall_modname` in crate `::kernel::bindings`
   --> samples/rust/rust_driver_serdev.rs:82:1
   |
   82 | / kernel::module_serdev_device_driver! {
   83 | |     type: SampleDriver,
   84 | |     name: "rust_driver_serdev",
   85 | |     authors: ["Markus Probst"],
   86 | |     description: "Rust Serial device bus device driver",
   87 | |     license: "GPL v2",
   88 | | }
   | |_^ not found in `::kernel::bindings`
   |
   = note: this error originates in the macro `$crate::prelude::module` which comes from the expansion of the macro `kernel::module_serdev_device_driver` (in Nightly builds, run with -Z macro-backtrace for more info)
--
>> error[E0422]: cannot find struct, variant or union type `initcall_modname` in crate `::kernel::bindings`
   --> samples/rust/rust_driver_serdev.rs:82:1
   |
   82 | / kernel::module_serdev_device_driver! {
   83 | |     type: SampleDriver,
   84 | |     name: "rust_driver_serdev",
   85 | |     authors: ["Markus Probst"],
   86 | |     description: "Rust Serial device bus device driver",
   87 | |     license: "GPL v2",
   88 | | }
   | |_^ not found in `::kernel::bindings`
   |
   = note: this error originates in the macro `$crate::prelude::module` which comes from the expansion of the macro `kernel::module_serdev_device_driver` (in Nightly builds, run with -Z macro-backtrace for more info)
--
>> error[E0425]: cannot find type `initcall_modname` in crate `::kernel::bindings`
   --> samples/rust/rust_driver_faux.rs:11:1
   |
   11 | / module! {
   12 | |     type: SampleModule,
   13 | |     name: "rust_faux_driver",
   14 | |     authors: ["Lyude Paul"],
   15 | |     description: "Rust faux device sample",
   16 | |     license: "GPL",
   17 | | }
   | |_^ not found in `::kernel::bindings`
   |
   = note: this error originates in the macro `module` (in Nightly builds, run with -Z macro-backtrace for more info)
--
>> error[E0422]: cannot find struct, variant or union type `initcall_modname` in crate `::kernel::bindings`
   --> samples/rust/rust_driver_faux.rs:11:1
   |
   11 | / module! {
   12 | |     type: SampleModule,
   13 | |     name: "rust_faux_driver",
   14 | |     authors: ["Lyude Paul"],
   15 | |     description: "Rust faux device sample",
   16 | |     license: "GPL",
   17 | | }
   | |_^ not found in `::kernel::bindings`
   |
   = note: this error originates in the macro `module` (in Nightly builds, run with -Z macro-backtrace for more info)
--
>> error[E0425]: cannot find type `initcall_modname` in crate `::kernel::bindings`
   --> samples/rust/rust_debugfs_scoped.rs:24:1
   |
   24 | / module! {
   25 | |     type: RustScopedDebugFs,
   26 | |     name: "rust_debugfs_scoped",
   27 | |     authors: ["Matthew Maurer"],
   28 | |     description: "Rust Scoped DebugFS usage sample",
   29 | |     license: "GPL",
   30 | | }
   | |_^ not found in `::kernel::bindings`
   |
   = note: this error originates in the macro `module` (in Nightly builds, run with -Z macro-backtrace for more info)
--
>> error[E0422]: cannot find struct, variant or union type `initcall_modname` in crate `::kernel::bindings`
   --> samples/rust/rust_debugfs_scoped.rs:24:1
   |
   24 | / module! {
   25 | |     type: RustScopedDebugFs,
   26 | |     name: "rust_debugfs_scoped",
   27 | |     authors: ["Matthew Maurer"],
   28 | |     description: "Rust Scoped DebugFS usage sample",
   29 | |     license: "GPL",
   30 | | }
   | |_^ not found in `::kernel::bindings`
   |
   = note: this error originates in the macro `module` (in Nightly builds, run with -Z macro-backtrace for more info)
--
>> error[E0425]: cannot find type `initcall_modname` in crate `::kernel::bindings`
   --> samples/rust/rust_dma.rs:136:1
   |
   136 | / kernel::module_pci_driver! {
   137 | |     type: DmaSampleDriver,
   138 | |     name: "rust_dma",
   139 | |     authors: ["Abdiel Janulgue"],
   140 | |     description: "Rust DMA test",
   141 | |     license: "GPL v2",
   142 | | }
   | |_^ not found in `::kernel::bindings`
   |
   = note: this error originates in the macro `$crate::prelude::module` which comes from the expansion of the macro `kernel::module_pci_driver` (in Nightly builds, run with -Z macro-backtrace for more info)
..

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

