Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A515BD339A2
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:57:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D3056B00A1; Fri,  5 Dec 2025 13:57:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 084626B00A3; Fri,  5 Dec 2025 13:57:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E65DB6B00A4; Fri,  5 Dec 2025 13:57:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BE1116B00A1
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:57:17 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6964E12D86
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:57:17 +0000 (UTC)
X-FDA: 84186325314.14.89C3938
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4FD18C0002
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:57:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dNKTE53e;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764961035; a=rsa-sha256;
	cv=none;
	b=UKCZ5lzzu1czhW/DkMG+QYHRlgBPMddZljnRyiavg3RsS/p37s0dgvzSgmDCMsb62sVGa1
	EMkwQXsfNAYNDKkT7hacKYAPHnsGnCOYDpWZgb99AOCOdGmYSYZzB3V1NHrUAYdr9nAEBh
	TrD2kkh3Kdsq5x+FghT1IZq9HjV9lUg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dNKTE53e;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764961035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=02x/O7HQ00NJdWX/zJUsTPRsVo6x4w5DZ5jlRYvnitw=;
	b=jqhXPl6i342kDNt8UQmajToc6sCfiAZ+bUm26pWwy9WJfBmwMMKxAJP25Qsl0qYk6Y7zAF
	cPn3Iqym6GfhJ71Rb4fbXCxXFAMnFtBVepScs9iqBa06rbd068gpj0Dg9xqQM8US9L4eW0
	9ueKxqaCnINak9KFYjTkL1JxQY8JpoI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764961034; x=1796497034;
  h=date:from:to:cc:subject:message-id;
  bh=FXiPzTjqeS0AzSYUsq3BpF04O/Wb7C9t5McmBG0H0Fg=;
  b=dNKTE53e6h1hci3sWTXSJKFC/R8sw7EadOSoWB/sazqXHkRC08FFWA24
   mtnFHmvzc64rRe9VlGQ9wHMx79A0wcS89vO/p0qWYNLxlgumrxyPK7ofr
   0fVazXWjqhZur6SaVMcDYHb3Ff5i1K3RXhkqFsrc7MS6s6UiedgaXYo5j
   AhmwTqFFkkze9bYkKSXsOrR4S6FIF7uQxwqFJYTFMMHnTk7meFhIz1HuA
   /xcDop5pOnULvXt8iGiSYNQhw/uvgubTqcfK7mUPuKQjATtzwv81gNSe5
   duV9gSTMCg+MdTwnPCsYTL2UweFNJyybPO/Mhd6BECsACZrjMAZeF7TIO
   A==;
X-CSE-ConnectionGUID: JNrng3tQSDKCPQnkCz+tnQ==
X-CSE-MsgGUID: 5ncIvZHoSvmc6yQO0opcLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11633"; a="89652788"
X-IronPort-AV: E=Sophos;i="6.20,252,1758610800"; 
   d="scan'208";a="89652788"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2025 10:57:13 -0800
X-CSE-ConnectionGUID: TxSUvxf8QV6gI6Vp4nBM3w==
X-CSE-MsgGUID: Zd76sEolQRWgSsOoEs/NoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,252,1758610800"; 
   d="scan'208";a="195181658"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 05 Dec 2025 10:57:11 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vRazM-00000000FOV-2Yec;
	Fri, 05 Dec 2025 18:57:08 +0000
Date: Sat, 06 Dec 2025 02:56:38 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 6987d58a9cbc5bd57c983baa514474a86c945d56
Message-ID: <202512060224.zkTVyLRN-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4FD18C0002
X-Stat-Signature: 7giwf8e5x6byftn3cgpkswojzp5ukd1m
X-Rspam-User: 
X-HE-Tag: 1764961034-428870
X-HE-Meta: U2FsdGVkX19mupQXO3ATKSd4v0VhpwUCE+JGlNt4v5VIETtbq7t6XQvflHfWkGq+aUiS5NwsE67nTGGD75COC9dTUHX81jJB/KAWEw196IHzGslLEkEG0y0DXjjuvu/s3qRzLt3tM19Ea57cXhGSeiL/SdCfdK7ZAIk0sjRuFvEcqpNU8jxoAnWy851RfahlZw6Mfn6Q+AWbe5AhCDlh+m3cA3mKCN6OiLtjSPm5ECb+eGAftZvj6CYy8FIe5mWqq5VM7Jy62c/9zfQvD3izzRovvU9iJ36q2iEmy48OlfKGgPUJ+V5FQaKirtn/ngLzXUV2NfkLs8tlBvR7PxzTsZ97aVj90th/4f3RIXxCSrbtV2JY75PN7b7bW+evMfeU431MEYA0bsG7IdPw6co9tirJh7zuB6B/c4E8r1o+jb05gE9i5YeysUO0GuZmrC9b8GlQWNFjatACvz7+ynpw5ugKQg0wjoCY8Ch6ACRqN6yxnOUseiOI+ur+8Xv0TlhloSl7NZLucnndQiy3u7CrDGtZURqkyQF0npmjpAjy3iBwL7pwugmGxwW8fqgaorpiYoX+iT1UdVHn+w0LnljMH7tyJWB+lODCKSJq0ECFuslAnvaO1rYAfWb2XmtviK3Y+ao/JgFAnCkhugxUXaz7fpxkfnxs1l9xaZel13ikzHVWByHVmyYGjxtmqdUckdgV0nAPlUPIHVZE568uPJnwMBDklslnAJdE2PGJnCS/0zjTdUkLfiCVvqOVTDLir19w9rh3aTD9FB3HajtZWHzD8nD3dOCl4/Q9FB1ku015BF/z6Z8moS0YSIVxR0CVPHFnmQaysiH4Im/vs/I3H5nK9A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 6987d58a9cbc5bd57c983baa514474a86c945d56  Add linux-next specific files for 20251205

Unverified Error/Warning (likely false positive, kindly check if interested):

    arch/sparc/kernel/ds.c:36:1: sparse: sparse: bad integer constant expression
    arch/sparc/kernel/ds.c:36:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    arch/sparc/kernel/ds.c:37:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    arch/sparc/kernel/ds.c:38:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    arch/sparc/kernel/ds.c:38:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    arch/sparc/kernel/ds.c:39:1: sparse: sparse: static assertion failed: "MODULE_INFO(version, ...) contains embedded NUL byte"
    arch/x86/boot/compressed/../../../../lib/xxhash.c:392:1: sparse: sparse: bad integer constant expression
    arch/x86/boot/compressed/../../../../lib/xxhash.c:392:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    arch/x86/boot/compressed/../../../../lib/xxhash.c:392:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    arch/x86/boot/compressed/../../../../lib/xxhash.c:393:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    arch/x86/boot/compressed/../../../../lib/zstd/zstd_decompress_module.c:140:1: sparse: sparse: bad integer constant expression
    arch/x86/boot/compressed/../../../../lib/zstd/zstd_decompress_module.c:140:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    arch/x86/boot/compressed/../../../../lib/zstd/zstd_decompress_module.c:140:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    arch/x86/boot/compressed/../../../../lib/zstd/zstd_decompress_module.c:141:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    crypto/async_tx/raid6test.c:248:1: sparse: sparse: bad integer constant expression
    crypto/async_tx/raid6test.c:248:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    crypto/async_tx/raid6test.c:249:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    crypto/async_tx/raid6test.c:250:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/acpi/acpi_pad.c:492:1: sparse: sparse: bad integer constant expression
    drivers/acpi/acpi_pad.c:492:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/acpi/acpi_pad.c:493:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/acpi/acpi_pad.c:494:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/acpi/acpi_pad.c:494:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/acpi/acpi_tad.c:30:1: sparse: sparse: bad integer constant expression
    drivers/acpi/acpi_tad.c:30:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/acpi/acpi_tad.c:31:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/acpi/acpi_tad.c:31:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/acpi/acpi_tad.c:32:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/acpi/pfr_telemetry.c:429:1: sparse: sparse: bad integer constant expression
    drivers/acpi/pfr_telemetry.c:429:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/acpi/pfr_telemetry.c:430:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/acpi/pfr_telemetry.c:430:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/acpi/pfr_update.c:605:1: sparse: sparse: bad integer constant expression
    drivers/acpi/pfr_update.c:605:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/acpi/pfr_update.c:606:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/acpi/pfr_update.c:606:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/ata/pata_cmd640.c:268:1: sparse: sparse: bad integer constant expression
    drivers/ata/pata_cmd640.c:268:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/ata/pata_cmd640.c:269:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/ata/pata_cmd640.c:270:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/ata/pata_cmd640.c:270:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/ata/pata_cmd640.c:272:1: sparse: sparse: static assertion failed: "MODULE_INFO(version, ...) contains embedded NUL byte"
    drivers/ata/pata_of_platform.c:99:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/aten.c:141:1: sparse: sparse: bad integer constant expression
    drivers/ata/pata_parport/aten.c:141:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/aten.c:141:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/aten.c:142:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/aten.c:143:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/bpck.c:504:1: sparse: sparse: bad integer constant expression
    drivers/ata/pata_parport/bpck.c:504:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/bpck.c:504:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/bpck.c:505:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/bpck.c:506:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/bpck6.c:460:1: sparse: sparse: bad integer constant expression
    drivers/ata/pata_parport/bpck6.c:460:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/bpck6.c:460:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/bpck6.c:461:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/bpck6.c:462:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/comm.c:202:1: sparse: sparse: bad integer constant expression
    drivers/ata/pata_parport/comm.c:202:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/comm.c:202:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/comm.c:203:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/comm.c:204:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/dstr.c:232:1: sparse: sparse: bad integer constant expression
    drivers/ata/pata_parport/dstr.c:232:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/dstr.c:232:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/dstr.c:233:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/dstr.c:234:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/epat.c:25:1: sparse: sparse: bad integer constant expression
    drivers/ata/pata_parport/epat.c:25:1: sparse: sparse: static assertion failed: "MODULE_INFO(parmtype, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/epat.c:26:1: sparse: sparse: static assertion failed: "MODULE_INFO(parm, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/epat.c:360:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/epat.c:360:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/epat.c:361:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/epat.c:362:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/epia.c:308:1: sparse: sparse: bad integer constant expression
    drivers/ata/pata_parport/epia.c:308:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/epia.c:309:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/epia.c:310:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/fit2.c:134:1: sparse: sparse: bad integer constant expression
    drivers/ata/pata_parport/fit2.c:134:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/fit2.c:134:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/fit2.c:135:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/fit2.c:136:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/fit3.c:185:1: sparse: sparse: bad integer constant expression
    drivers/ata/pata_parport/fit3.c:185:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/fit3.c:185:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/fit3.c:186:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/fit3.c:187:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/friq.c:261:1: sparse: sparse: bad integer constant expression
    drivers/ata/pata_parport/friq.c:261:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/friq.c:261:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/friq.c:262:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/friq.c:263:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/frpw.c:295:1: sparse: sparse: bad integer constant expression
    drivers/ata/pata_parport/frpw.c:295:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/frpw.c:296:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/frpw.c:297:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/kbic.c:303:1: sparse: sparse: bad integer constant expression
    drivers/ata/pata_parport/kbic.c:304:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/ktti.c:108:1: sparse: sparse: bad integer constant expression
    drivers/ata/pata_parport/ktti.c:108:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/ktti.c:109:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/ata/pata_parport/ktti.c:110:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/ata/sata_sil24.c:1359:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/ata/sata_sil24.c:1360:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/ata/sata_sil24.c:1361:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/ata/sata_sil24.c:1361:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/ata/sata_sil24.c:416:1: sparse: sparse: bad integer constant expression
    drivers/ata/sata_sil24.c:416:1: sparse: sparse: static assertion failed: "MODULE_INFO(parmtype, ...) contains embedded NUL byte"
    drivers/ata/sata_sil24.c:417:1: sparse: sparse: static assertion failed: "MODULE_INFO(parm, ...) contains embedded NUL byte"
    drivers/bluetooth/btmrvl_sdio.c:1769:1: sparse: sparse: bad integer constant expression
    drivers/bluetooth/btmrvl_sdio.c:1769:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/bluetooth/btmrvl_sdio.c:1770:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/bluetooth/btmrvl_sdio.c:1771:1: sparse: sparse: static assertion failed: "MODULE_INFO(version, ...) contains embedded NUL byte"
    drivers/bluetooth/btmrvl_sdio.c:1772:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/bluetooth/btmrvl_sdio.c:1773:1: sparse: sparse: static assertion failed: "MODULE_INFO(firmware, ...) contains embedded NUL byte"
    drivers/bluetooth/hci_bcsp.c:783:1: sparse: sparse: bad integer constant expression
    drivers/bluetooth/hci_bcsp.c:783:1: sparse: sparse: static assertion failed: "MODULE_INFO(parmtype, ...) contains embedded NUL byte"
    drivers/bluetooth/hci_bcsp.c:784:1: sparse: sparse: static assertion failed: "MODULE_INFO(parm, ...) contains embedded NUL byte"
    drivers/char/tpm/tpm_svsm.c:119:1: sparse: sparse: bad integer constant expression
    drivers/char/tpm/tpm_svsm.c:119:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/char/tpm/tpm_svsm.c:120:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/char/tpm/tpm_svsm.c:120:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/char/tpm/tpm_svsm.c:121:1: sparse: sparse: static assertion failed: "MODULE_INFO(alias, ...) contains embedded NUL byte"
    drivers/cpufreq/bmips-cpufreq.c:184:1: sparse: sparse: bad integer constant expression
    drivers/cpufreq/bmips-cpufreq.c:184:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/cpufreq/bmips-cpufreq.c:185:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/cpufreq/bmips-cpufreq.c:186:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/cpufreq/bmips-cpufreq.c:186:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/cpufreq/p4-clockmod.c:269:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/cpufreq/sparc-us2e-cpufreq.c:347:1: sparse: sparse: bad integer constant expression
    drivers/cpufreq/sparc-us2e-cpufreq.c:347:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/cpufreq/sparc-us2e-cpufreq.c:348:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/cpufreq/sparc-us2e-cpufreq.c:349:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/cpufreq/sparc-us3-cpufreq.c:195:1: sparse: sparse: bad integer constant expression
    drivers/cpufreq/sparc-us3-cpufreq.c:195:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/cpufreq/sparc-us3-cpufreq.c:196:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/cpufreq/sparc-us3-cpufreq.c:197:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/gpib/lpvo_usb_gpib/lpvo_usb_gpib.c:358:27: warning: 'sprintf' may write a terminating nul past the end of the destination [-Wformat-overflow=]
    drivers/gpio/gpio-exar.c:239:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/gpu/drm/bridge/chipone-icn6211.c:824:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/gpu/drm/sysfb/efidrm.c:388:1: sparse: sparse: bad integer constant expression
    drivers/gpu/drm/sysfb/efidrm.c:388:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/gpu/drm/sysfb/efidrm.c:389:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/gpu/drm/sysfb/efidrm.c:389:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/gpu/drm/sysfb/vesadrm.c:649:1: sparse: sparse: bad integer constant expression
    drivers/gpu/drm/sysfb/vesadrm.c:649:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/gpu/drm/sysfb/vesadrm.c:650:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/gpu/drm/sysfb/vesadrm.c:650:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/hid/hid-cp2112.c:1453:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/hid/hid-cp2112.c:1454:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/hid/hid-cp2112.c:1455:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/hid/hid-cp2112.c:180:1: sparse: sparse: bad integer constant expression
    drivers/hid/hid-cp2112.c:180:1: sparse: sparse: static assertion failed: "MODULE_INFO(parmtype, ...) contains embedded NUL byte"
    drivers/hid/hid-cp2112.c:181:1: sparse: sparse: static assertion failed: "MODULE_INFO(parm, ...) contains embedded NUL byte"
    drivers/hwmon/gpd-fan.c:27:1: sparse: sparse: bad integer constant expression
    drivers/hwmon/gpd-fan.c:27:1: sparse: sparse: static assertion failed: "MODULE_INFO(parmtype, ...) contains embedded NUL byte"
    drivers/hwmon/gpd-fan.c:713:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/hwmon/gpd-fan.c:713:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/hwmon/gpd-fan.c:714:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/hwmon/gpd-fan.c:715:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/i2c/busses/i2c-via.c:154:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/iio/accel/cros_ec_accel_legacy.c:249:1: sparse: sparse: bad integer constant expression
    drivers/iio/accel/cros_ec_accel_legacy.c:249:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/iio/accel/cros_ec_accel_legacy.c:250:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/iio/accel/cros_ec_accel_legacy.c:251:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/iio/accel/cros_ec_accel_legacy.c:251:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/iio/accel/cros_ec_accel_legacy.c:252:1: sparse: sparse: static assertion failed: "MODULE_INFO(alias, ...) contains embedded NUL byte"
    drivers/iio/accel/st_accel_core.c:1551:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/iio/accel/st_accel_spi.c:186:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/iio/adc/max11100.c:163:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/iio/adc/rn5t618-adc.c:259:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/iio/gyro/st_gyro_spi.c:126:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/iio/imu/st_lsm9ds0/st_lsm9ds0_core.c:95:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/iio/imu/st_lsm9ds0/st_lsm9ds0_spi.c:85:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/iio/magnetometer/af8133j.c:527:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/input/gameport/emu10k1-gp.c:20:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/input/misc/88pm80x_onkey.c:149:1: sparse: sparse: bad integer constant expression
    drivers/input/misc/88pm80x_onkey.c:149:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/input/misc/88pm80x_onkey.c:149:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/input/misc/88pm80x_onkey.c:150:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/input/misc/88pm80x_onkey.c:151:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/input/misc/88pm80x_onkey.c:152:1: sparse: sparse: static assertion failed: "MODULE_INFO(alias, ...) contains embedded NUL byte"
    drivers/input/misc/soc_button_array.c:22:1: sparse: sparse: bad integer constant expression
    drivers/input/misc/soc_button_array.c:22:1: sparse: sparse: static assertion failed: "MODULE_INFO(parmtype, ...) contains embedded NUL byte"
    drivers/input/misc/soc_button_array.c:23:1: sparse: sparse: static assertion failed: "MODULE_INFO(parm, ...) contains embedded NUL byte"
    drivers/input/misc/soc_button_array.c:623:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/input/misc/soc_button_array.c:624:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/input/misc/soc_button_array.c:624:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/input/misc/tps65219-pwrbutton.c:148:1: sparse: sparse: bad integer constant expression
    drivers/input/misc/tps65219-pwrbutton.c:148:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/input/misc/tps65219-pwrbutton.c:149:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/input/misc/tps65219-pwrbutton.c:149:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/input/misc/tps65219-pwrbutton.c:150:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/leds/leds-lp5562.c:424:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/leds/rgb/leds-group-multicolor.c:172:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/media/dvb-frontends/cx24117.c:1651:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/media/i2c/ds90ub913.c:954:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/media/i2c/ds90ub960.c:5211:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/media/i2c/ov02a10.c:1001:1: sparse: sparse: bad integer constant expression
    drivers/media/i2c/ov02a10.c:1001:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/media/i2c/ov02a10.c:1002:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/media/i2c/ov02a10.c:1003:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/media/i2c/ov5647.c:1515:1: sparse: sparse: bad integer constant expression
    drivers/media/i2c/ov5647.c:1515:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/media/i2c/ov5647.c:1516:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/media/i2c/ov5647.c:1517:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/media/i2c/vd56g3.c:1578:1: sparse: sparse: bad integer constant expression
    drivers/media/i2c/vd56g3.c:1578:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/media/i2c/vd56g3.c:1581:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/media/i2c/vd56g3.c:1582:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/memory/dfl-emif.c:257:1: sparse: sparse: bad integer constant expression
    drivers/memory/dfl-emif.c:257:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/memory/dfl-emif.c:258:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/memory/dfl-emif.c:259:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/memstick/host/tifm_ms.c:678:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/misc/lan966x_pci.c:213:1: sparse: sparse: bad integer constant expression
    drivers/misc/lan966x_pci.c:213:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/misc/lan966x_pci.c:214:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/misc/lan966x_pci.c:215:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/mmc/core/pwrseq_sd8787.c:133:1: sparse: sparse: bad integer constant expression
    drivers/mmc/core/pwrseq_sd8787.c:133:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/mmc/core/pwrseq_sd8787.c:134:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/mmc/host/jz4740_mmc.c:1192:1: sparse: sparse: bad integer constant expression
    drivers/mmc/host/jz4740_mmc.c:1192:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/mmc/host/jz4740_mmc.c:1193:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/mmc/host/jz4740_mmc.c:1193:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/mmc/host/jz4740_mmc.c:1194:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/mmc/host/sdhci-milbeaut.c:336:1: sparse: sparse: bad integer constant expression
    drivers/mmc/host/sdhci-milbeaut.c:336:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/mmc/host/sdhci-milbeaut.c:337:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/mmc/host/sdhci-milbeaut.c:338:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/mmc/host/sdhci-milbeaut.c:338:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/mmc/host/sdhci-milbeaut.c:339:1: sparse: sparse: static assertion failed: "MODULE_INFO(alias, ...) contains embedded NUL byte"
    drivers/mmc/host/sdhci-of-at91.c:467:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/mmc/host/sdhci_f_sdh30.c:251:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/most/most_snd.c:745:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/mtd/maps/sun_uflash.c:33:1: sparse: sparse: bad integer constant expression
    drivers/mtd/maps/sun_uflash.c:33:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/mtd/maps/sun_uflash.c:34:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/mtd/maps/sun_uflash.c:35:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/mtd/maps/sun_uflash.c:35:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/mtd/maps/sun_uflash.c:36:1: sparse: sparse: static assertion failed: "MODULE_INFO(version, ...) contains embedded NUL byte"
    drivers/nvdimm/security.c:22:1: sparse: sparse: bad integer constant expression
    drivers/nvdimm/security.c:22:1: sparse: sparse: static assertion failed: "MODULE_INFO(parmtype, ...) contains embedded NUL byte"
    drivers/nvdimm/security.c:23:1: sparse: sparse: static assertion failed: "MODULE_INFO(parm, ...) contains embedded NUL byte"
    drivers/nvme/host/tcp.c:3071:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/nvme/host/tcp.c:3072:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/nvme/host/tcp.c:3072:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/nvme/host/tcp.c:35:1: sparse: sparse: bad integer constant expression
    drivers/nvme/host/tcp.c:35:1: sparse: sparse: static assertion failed: "MODULE_INFO(parmtype, ...) contains embedded NUL byte"
    drivers/nvme/host/tcp.c:36:1: sparse: sparse: static assertion failed: "MODULE_INFO(parm, ...) contains embedded NUL byte"
    drivers/parport/parport_serial.c:788:1: sparse: sparse: bad integer constant expression
    drivers/parport/parport_serial.c:788:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/parport/parport_serial.c:789:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/parport/parport_serial.c:790:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/parport/parport_serial.c:790:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/parport/parport_sunbpp.c:379:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/rtc/rtc-lp8788.c:319:1: sparse: sparse: bad integer constant expression
    drivers/rtc/rtc-lp8788.c:319:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/rtc/rtc-lp8788.c:320:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/rtc/rtc-lp8788.c:321:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/rtc/rtc-lp8788.c:321:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/rtc/rtc-lp8788.c:322:1: sparse: sparse: static assertion failed: "MODULE_INFO(alias, ...) contains embedded NUL byte"
    drivers/sbus/char/openprom.c:36:1: sparse: sparse: bad integer constant expression
    drivers/sbus/char/openprom.c:36:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/sbus/char/openprom.c:37:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/sbus/char/openprom.c:40:1: sparse: sparse: static assertion failed: "MODULE_INFO(alias, ...) contains embedded NUL byte"
    drivers/scsi/megaraid/megaraid_mbox.c:139:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/scsi/megaraid/megaraid_mm.c:46:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/scsi/qlogicpti.c:1471:1: sparse: sparse: bad integer constant expression
    drivers/scsi/qlogicpti.c:1471:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/scsi/qlogicpti.c:1472:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/scsi/qlogicpti.c:1473:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/scsi/qlogicpti.c:1474:1: sparse: sparse: static assertion failed: "MODULE_INFO(version, ...) contains embedded NUL byte"
    drivers/scsi/qlogicpti.c:1475:1: sparse: sparse: static assertion failed: "MODULE_INFO(firmware, ...) contains embedded NUL byte"
    drivers/scsi/stex.c:388:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/staging/media/max96712/max96712.c:485:1: sparse: sparse: bad integer constant expression
    drivers/staging/media/max96712/max96712.c:485:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/staging/media/max96712/max96712.c:486:1: sparse: sparse: static assertion failed: "MODULE_INFO(author, ...) contains embedded NUL byte"
    drivers/staging/media/max96712/max96712.c:487:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/staging/media/max96712/max96712.c:487:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/staging/most/dim2/dim2.c:1105:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/staging/most/video/video.c:586:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/staging/sm750fb/sm750.c:1232:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/staging/vme_user/vme_fake.c:1291:1: sparse: sparse: bad integer constant expression
    drivers/staging/vme_user/vme_fake.c:1291:1: sparse: sparse: static assertion failed: "MODULE_INFO(parm, ...) contains embedded NUL byte"
    drivers/staging/vme_user/vme_fake.c:1292:1: sparse: sparse: static assertion failed: "MODULE_INFO(parmtype, ...) contains embedded NUL byte"
    drivers/staging/vme_user/vme_fake.c:1294:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/staging/vme_user/vme_fake.c:1295:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/staging/vme_user/vme_fake.c:1295:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/tty/serial/sunzilog.c:1646:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/tty/vcc.c:18:1: sparse: sparse: bad integer constant expression
    drivers/tty/vcc.c:18:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    drivers/tty/vcc.c:19:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    drivers/tty/vcc.c:19:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    drivers/tty/vcc.c:20:1: sparse: sparse: static assertion failed: "MODULE_INFO(version, ...) contains embedded NUL byte"
    drivers/tty/vcc.c:65:1: sparse: sparse: static assertion failed: "MODULE_INFO(parmtype, ...) contains embedded NUL byte"
    fs/erofs/decompressor_lzma.c:18:1: sparse: sparse: bad integer constant expression
    fs/erofs/decompressor_lzma.c:18:1: sparse: sparse: static assertion failed: "MODULE_INFO(parmtype, ...) contains embedded NUL byte"
    fs/erofs/decompressor_zstd.c:18:1: sparse: sparse: bad integer constant expression
    fs/erofs/decompressor_zstd.c:18:1: sparse: sparse: static assertion failed: "MODULE_INFO(parmtype, ...) contains embedded NUL byte"
    fs/hfs/string_test.c:131:1: sparse: sparse: bad integer constant expression
    fs/hfs/string_test.c:131:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    fs/hfs/string_test.c:132:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    fs/hfs/string_test.c:133:1: sparse: sparse: static assertion failed: "MODULE_INFO(import_ns, ...) contains embedded NUL byte"
    fs/openpromfs/inode.c:432:1: sparse: sparse: bad integer constant expression
    fs/openpromfs/inode.c:432:1: sparse: sparse: static assertion failed: "MODULE_INFO(alias, ...) contains embedded NUL byte"
    fs/openpromfs/inode.c:474:1: sparse: sparse: static assertion failed: "MODULE_INFO(description, ...) contains embedded NUL byte"
    fs/openpromfs/inode.c:475:1: sparse: sparse: static assertion failed: "MODULE_INFO(file, ...) contains embedded NUL byte"
    fs/openpromfs/inode.c:475:1: sparse: sparse: static assertion failed: "MODULE_INFO(license, ...) contains embedded NUL byte"
    kernel/trace/kprobe_event_gen_test.c:274:1: sparse: sparse: bad integer constant expression
    rust/kernel.o: warning: objtool: _RNvXs0_NtNtCshc5sK6KjdJJ_6kernel3str9parse_inthNtNtB5_7private12FromStrRadix14from_str_radix() falls through to next function _RNvXs4_NtNtCshc5sK6KjdJJ_6kernel3str9parse_inttNtNtB5_7private12FromStrRadix16from_u64_negated()
    rust/kernel.o: warning: objtool: _RNvXs4_NtNtCshc5sK6KjdJJ_6kernel3str9parse_inttNtNtB5_7private12FromStrRadix14from_str_radix() falls through to next function _RNvXs6_NtNtCshc5sK6KjdJJ_6kernel3str9parse_intlNtNtB5_7private12FromStrRadix14from_str_radix()
    rust/kernel.o: warning: objtool: _RNvXs8_NtNtCshc5sK6KjdJJ_6kernel3str9parse_intmNtNtB5_7private12FromStrRadix14from_str_radix() falls through to next function _RNvXs8_NtNtCshc5sK6KjdJJ_6kernel3str9parse_intmNtNtB5_7private12FromStrRadix16from_u64_negated()
    rust/kernel.o: warning: objtool: _RNvXsg_NtNtCshc5sK6KjdJJ_6kernel3str9parse_intjNtNtB5_7private12FromStrRadix14from_str_radix() falls through to next function _RNvXs4_NvNtNtCshc5sK6KjdJJ_6kernel4sync4poll1__NtB7_11PollCondVarNtNtNtCsbsbRiabPlh9_4core3ops4drop4Drop4drop()

Error/Warning ids grouped by kconfigs:

recent_errors
|-- i386-randconfig-061-20251205
|   `-- drivers-ufs-core-ufs-rpmb.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|-- i386-randconfig-063-20251205
|   |-- drivers-ata-pata_of_platform.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-aten.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-ata-pata_parport-aten.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-aten.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-aten.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-aten.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-bpck.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-ata-pata_parport-bpck.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-bpck.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-bpck.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-bpck.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-bpck6.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-ata-pata_parport-bpck6.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-bpck6.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-bpck6.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-bpck6.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-comm.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-ata-pata_parport-comm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-comm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-comm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-comm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-dstr.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-ata-pata_parport-dstr.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-dstr.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-dstr.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-dstr.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-epat.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-ata-pata_parport-epat.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-epat.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-epat.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-epat.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-epat.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-epat.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-fit2.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-ata-pata_parport-fit2.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-fit2.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-fit2.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-fit2.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-fit3.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-ata-pata_parport-fit3.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-fit3.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-fit3.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-fit3.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-friq.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-ata-pata_parport-friq.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-friq.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-friq.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-friq.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-kbic.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-ata-pata_parport-kbic.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-kbic.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-kbic.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-kbic.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-on26.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-ata-pata_parport-on26.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-on26.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-on26.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-on26.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-pata_parport.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-ata-pata_parport-pata_parport.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-pata_parport.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-pata_parport.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-pata_parport.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-pata_parport.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-pata_parport.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-pata_parport.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_pcmcia.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-ata-pata_pcmcia.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_pcmcia.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_pcmcia.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_pcmcia.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_pcmcia.c:sparse:sparse:static-assertion-failed:MODULE_INFO(version-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_platform.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-sata_dwc_460ex.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-ata-sata_dwc_460ex.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-sata_dwc_460ex.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-sata_dwc_460ex.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-sata_dwc_460ex.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-sata_dwc_460ex.c:sparse:sparse:static-assertion-failed:MODULE_INFO(version-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-sata_mv.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-ata-sata_mv.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-sata_mv.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-sata_mv.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-sata_mv.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-sata_mv.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-sata_mv.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-sata_mv.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-sata_mv.c:sparse:sparse:static-assertion-failed:MODULE_INFO(version-...)-contains-embedded-NUL-byte
|   |-- drivers-auxdisplay-ks0108.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-auxdisplay-ks0108.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-auxdisplay-ks0108.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-auxdisplay-ks0108.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-auxdisplay-ks0108.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-auxdisplay-ks0108.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   |-- drivers-auxdisplay-ks0108.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-comedi-drivers-ni_usb6501.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-comedi-drivers-usbduxsigma.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-comedi-drivers-usbduxsigma.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-comedi-drivers-usbduxsigma.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-comedi-drivers-usbduxsigma.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-comedi-drivers-usbduxsigma.c:sparse:sparse:static-assertion-failed:MODULE_INFO(firmware-...)-contains-embedded-NUL-byte
|   |-- drivers-comedi-drivers-usbduxsigma.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-cpufreq-powernow-k6.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-cpufreq-powernow-k6.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-cpufreq-powernow-k6.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-cpufreq-powernow-k6.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-cpufreq-powernow-k6.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-cpufreq-powernow-k6.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   |-- drivers-cpufreq-powernow-k6.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-dma-dw-axi-dmac-dw-axi-dmac-platform.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-fsi-fsi-master-aspeed.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-fsi-fsi-master-hub.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-fsi-fsi-occ.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-gpu-drm-bridge-chrontel-ch7033.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-gpu-drm-bridge-cros-ec-anx7688.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-gpu-drm-bridge-cros-ec-anx7688.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-gpu-drm-bridge-cros-ec-anx7688.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-gpu-drm-bridge-cros-ec-anx7688.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-gpu-drm-bridge-cros-ec-anx7688.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-gpu-drm-panel-panel-dsi-cm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-gpu-drm-panel-panel-jadard-jd9365da-h3.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-gpu-drm-panel-panel-raydium-rm68200.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-gpu-drm-panel-panel-samsung-ams581vf01.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-hid-usbhid-usbkbd.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-hwmon-drivetemp.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-hwmon-drivetemp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
|   |-- drivers-hwmon-drivetemp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-hwmon-drivetemp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-hwmon-drivetemp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-hwmon-drivetemp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-hwmon-occ-p9_sbe.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-i2c-busses-i2c-cgbc.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-i2c-busses-i2c-cgbc.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
|   |-- drivers-i2c-busses-i2c-cgbc.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-i2c-busses-i2c-cgbc.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-i2c-busses-i2c-cgbc.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-i2c-busses-i2c-cgbc.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-i2c-busses-i2c-fsi.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-addac-stx104.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-iio-addac-stx104.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-addac-stx104.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-addac-stx104.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-addac-stx104.c:sparse:sparse:static-assertion-failed:MODULE_INFO(import_ns-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-addac-stx104.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-addac-stx104.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-addac-stx104.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-common-cros_ec_sensors-cros_ec_activity.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-iio-common-cros_ec_sensors-cros_ec_activity.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-common-cros_ec_sensors-cros_ec_activity.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-common-cros_ec_sensors-cros_ec_activity.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-common-cros_ec_sensors-cros_ec_activity.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-common-cros_ec_sensors-cros_ec_lid_angle.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-iio-common-cros_ec_sensors-cros_ec_lid_angle.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-common-cros_ec_sensors-cros_ec_lid_angle.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-common-cros_ec_sensors-cros_ec_lid_angle.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-common-cros_ec_sensors-cros_ec_sensors_core.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-iio-common-cros_ec_sensors-cros_ec_sensors_core.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-common-cros_ec_sensors-cros_ec_sensors_core.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-common-cros_ec_sensors-cros_ec_sensors_core.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-light-cros_ec_light_prox.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-iio-light-cros_ec_light_prox.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-light-cros_ec_light_prox.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-light-cros_ec_light_prox.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-pressure-cros_ec_baro.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-iio-pressure-cros_ec_baro.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-pressure-cros_ec_baro.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-pressure-cros_ec_baro.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-input-keyboard-cros_ec_keyb.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-input-mouse-pc110pad.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-input-mouse-pc110pad.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-input-mouse-pc110pad.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-input-mouse-pc110pad.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-input-mouse-pc110pad.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-input-touchscreen-sur40.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-input-touchscreen-sur40.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-input-touchscreen-sur40.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-input-touchscreen-sur40.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-input-touchscreen-sur40.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-input-touchscreen-sur40.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   |-- drivers-input-touchscreen-sur40.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-leds-leds-lp5521.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-leds-leds-lp5523.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-leds-leds-lp55xx-common.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-leds-leds-lp8501.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-leds-leds-max77705.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-leds-rgb-leds-ncp5623.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-leds-rgb-leds-ncp5623.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-leds-rgb-leds-ncp5623.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-leds-rgb-leds-ncp5623.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-leds-rgb-leds-ncp5623.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-leds-simatic-simatic-ipc-leds.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-leds-simatic-simatic-ipc-leds.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
|   |-- drivers-leds-simatic-simatic-ipc-leds.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-leds-simatic-simatic-ipc-leds.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-leds-simatic-simatic-ipc-leds.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-leds-simatic-simatic-ipc-leds.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-i2c-max96714.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-platform-xilinx-xilinx-csi2rxss.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-platform-xilinx-xilinx-csi2rxss.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-platform-xilinx-xilinx-csi2rxss.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-platform-xilinx-xilinx-csi2rxss.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-platform-xilinx-xilinx-csi2rxss.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-platform-xilinx-xilinx-tpg.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-platform-xilinx-xilinx-tpg.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-platform-xilinx-xilinx-tpg.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-platform-xilinx-xilinx-tpg.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-platform-xilinx-xilinx-tpg.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-platform-xilinx-xilinx-vipp.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-platform-xilinx-xilinx-vipp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-platform-xilinx-xilinx-vipp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-platform-xilinx-xilinx-vipp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-platform-xilinx-xilinx-vipp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-platform-xilinx-xilinx-vtc.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-platform-xilinx-xilinx-vtc.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-platform-xilinx-xilinx-vtc.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-platform-xilinx-xilinx-vtc.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-platform-xilinx-xilinx-vtc.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-radio-radio-mr800.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-radio-radio-rtrack2.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-radio-radio-shark.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-radio-radio-trust.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-em28xx-em28xx-video.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-em28xx-em28xx-video.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-em28xx-em28xx-video.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-em28xx-em28xx-video.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-em28xx-em28xx-video.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-em28xx-em28xx-video.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-em28xx-em28xx-video.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-em28xx-em28xx-video.c:sparse:sparse:static-assertion-failed:MODULE_INFO(version-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-conex.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-gspca-conex.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-conex.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-conex.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-conex.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-cpia1.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-gspca-cpia1.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-cpia1.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-cpia1.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-cpia1.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-etoms.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-gspca-etoms.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-etoms.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-etoms.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-etoms.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-finepix.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-gspca-finepix.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-finepix.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-finepix.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-finepix.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-gspca.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-gspca-gspca.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-gspca.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-gspca.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-gspca.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-gspca.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-gspca.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-gspca.c:sparse:sparse:static-assertion-failed:MODULE_INFO(version-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-jl2005bcd.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-gspca-jl2005bcd.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-jl2005bcd.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-jl2005bcd.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-jl2005bcd.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-kinect.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-gspca-kinect.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-kinect.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-kinect.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-kinect.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-kinect.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-kinect.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-mars.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-gspca-mars.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-mars.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-mars.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-mars.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-mr97310a.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-gspca-mr97310a.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-mr97310a.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-mr97310a.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-mr97310a.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-mr97310a.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-mr97310a.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-nw8.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-gspca-nw8.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-nw8.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-nw8.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-nw8.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-nw8.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-nw8.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-ov519.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-gspca-ov519.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-ov519.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-ov519.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-ov519.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-ov519.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-ov519.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-pac7302.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-gspca-pac7302.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-pac7302.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-pac7302.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-pac7302.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-pac7311.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-gspca-pac7311.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-pac7311.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-pac7311.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-pac7311.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-se401.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-gspca-se401.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-se401.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-se401.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-se401.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-sn9c2028.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-gspca-sn9c2028.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-sn9c2028.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-sn9c2028.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-sn9c2028.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-sonixb.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-gspca-sonixb.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-sonixb.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-sonixb.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-sonixb.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-spca1528.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-gspca-spca1528.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-spca1528.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-spca1528.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-spca1528.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-spca501.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-gspca-spca501.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-spca501.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-spca501.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-spca501.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-spca505.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-gspca-spca505.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-spca505.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-spca505.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-spca505.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-spca506.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-gspca-spca506.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-spca506.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-spca506.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-spca506.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-spca508.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-gspca-spca508.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-spca508.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-spca508.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-spca508.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-spca561.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-gspca-spca561.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-spca561.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-spca561.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-spca561.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-sq905.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-gspca-sq905.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-sq905.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-sq905.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-sq905.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-stk1135.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-gspca-stk1135.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-stk1135.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-stk1135.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-stk1135.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-stv0680.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-gspca-stv0680.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-stv0680.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-stv0680.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-stv0680.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-stv06xx-stv06xx.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-gspca-stv06xx-stv06xx.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-stv06xx-stv06xx.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-stv06xx-stv06xx.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-stv06xx-stv06xx.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-stv06xx-stv06xx.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-stv06xx-stv06xx.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-t613.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-gspca-t613.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-t613.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-t613.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-t613.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-touptek.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-gspca-touptek.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-touptek.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-touptek.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-touptek.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-tv8532.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-gspca-tv8532.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-tv8532.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-tv8532.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-tv8532.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-vicam.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-gspca-vicam.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-vicam.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-vicam.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-vicam.c:sparse:sparse:static-assertion-failed:MODULE_INFO(firmware-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-vicam.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-xirlink_cit.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-gspca-xirlink_cit.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-xirlink_cit.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-xirlink_cit.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-xirlink_cit.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-xirlink_cit.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-xirlink_cit.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-zc3xx.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-media-usb-gspca-zc3xx.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-zc3xx.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-zc3xx.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-zc3xx.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-zc3xx.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   |-- drivers-media-usb-gspca-zc3xx.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-memstick-host-rtsx_usb_ms.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-mtd-nand-raw-cs553x_nand.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-mtd-nand-raw-cs553x_nand.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-mtd-nand-raw-cs553x_nand.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-mtd-nand-raw-cs553x_nand.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-mtd-nand-raw-cs553x_nand.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-pcmcia-tcic.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-pcmcia-tcic.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-pcmcia-tcic.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-pcmcia-tcic.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-pcmcia-tcic.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-pcmcia-tcic.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-chrome-cros_usbpd_logger.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-platform-chrome-cros_usbpd_logger.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-chrome-cros_usbpd_logger.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-chrome-cros_usbpd_logger.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-x86-hp-hp_accel.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-platform-x86-hp-hp_accel.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-x86-hp-hp_accel.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-x86-hp-hp_accel.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-x86-siemens-simatic-ipc.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-platform-x86-siemens-simatic-ipc.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-x86-siemens-simatic-ipc.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-x86-siemens-simatic-ipc.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-x86-siemens-simatic-ipc.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-x86-siemens-simatic-ipc.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-x86-silicom-platform.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-platform-x86-silicom-platform.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-x86-silicom-platform.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-x86-silicom-platform.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-x86-silicom-platform.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-power-supply-cros_charge-control.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-power-supply-cros_charge-control.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-power-supply-cros_charge-control.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-power-supply-cros_charge-control.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-power-supply-cros_charge-control.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-power-supply-cros_charge-control.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   |-- drivers-power-supply-cros_charge-control.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-power-supply-cros_usbpd-charger.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-power-supply-cros_usbpd-charger.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-power-supply-cros_usbpd-charger.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-power-supply-cros_usbpd-charger.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-regulator-bd9576-regulator.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-regulator-qcom-pm8008-regulator.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-regulator-tps65219-regulator.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-usb-cdns3-cdns3-pci-wrap.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-usb-cdns3-cdns3-pci-wrap.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-usb-cdns3-cdns3-pci-wrap.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-usb-cdns3-cdns3-pci-wrap.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-usb-cdns3-cdns3-pci-wrap.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-usb-storage-alauda.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-usb-storage-cypress_atacb.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-usb-storage-datafab.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-usb-storage-freecom.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-usb-storage-jumpshot.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-usb-storage-karma.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-usb-storage-sddr09.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-usb-storage-sddr55.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-usb-storage-usb.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-usb-typec-altmodes-nvidia.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-usb-typec-tcpm-tcpm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-usb-typec-wusb3801.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-video-fbdev-udlfb.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-video-fbdev-udlfb.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-video-fbdev-udlfb.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-video-fbdev-udlfb.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-video-fbdev-udlfb.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-video-fbdev-udlfb.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   `-- drivers-video-fbdev-udlfb.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|-- loongarch-randconfig-001-20251205
|   |-- rust-kernel.o:warning:objtool:_RNvXs0_NtNtCshc5sK6KjdJJ_6kernel3str9parse_inthNtNtB5_7private12FromStrRadix14from_str_radix-falls-through-to-next-function-_RNvXs4_NtNtCshc5sK6KjdJJ_6kernel3str9parse_i
|   |-- rust-kernel.o:warning:objtool:_RNvXs4_NtNtCshc5sK6KjdJJ_6kernel3str9parse_inttNtNtB5_7private12FromStrRadix14from_str_radix-falls-through-to-next-function-_RNvXs6_NtNtCshc5sK6KjdJJ_6kernel3str9parse_i
|   |-- rust-kernel.o:warning:objtool:_RNvXs8_NtNtCshc5sK6KjdJJ_6kernel3str9parse_intmNtNtB5_7private12FromStrRadix14from_str_radix-falls-through-to-next-function-_RNvXs8_NtNtCshc5sK6KjdJJ_6kernel3str9parse_i
|   `-- rust-kernel.o:warning:objtool:_RNvXsg_NtNtCshc5sK6KjdJJ_6kernel3str9parse_intjNtNtB5_7private12FromStrRadix14from_str_radix-falls-through-to-next-function-_RNvXs4_NvNtNtCshc5sK6KjdJJ_6kernel4sync4poll
|-- mips-randconfig-r122-20251205
|   |-- drivers-cpufreq-bmips-cpufreq.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-cpufreq-bmips-cpufreq.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-cpufreq-bmips-cpufreq.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-cpufreq-bmips-cpufreq.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-cpufreq-bmips-cpufreq.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-gpio-gpio-exar.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-i2c-busses-i2c-via.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-magnetometer-af8133j.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-input-gameport-emu10k1-gp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-input-misc-tps65219-pwrbutton.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-input-misc-tps65219-pwrbutton.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-input-misc-tps65219-pwrbutton.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-input-misc-tps65219-pwrbutton.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-input-misc-tps65219-pwrbutton.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-media-dvb-frontends-cx24117.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-memstick-host-tifm_ms.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-mmc-host-jz4740_mmc.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-mmc-host-jz4740_mmc.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-mmc-host-jz4740_mmc.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-mmc-host-jz4740_mmc.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-mmc-host-jz4740_mmc.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-mmc-host-sdhci-milbeaut.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-mmc-host-sdhci-of-at91.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-mmc-host-sdhci_f_sdh30.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-parport-parport_serial.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-parport-parport_serial.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-parport-parport_serial.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-parport-parport_serial.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-parport-parport_serial.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-rtc-rtc-lp8788.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-rtc-rtc-lp8788.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
|   |-- drivers-rtc-rtc-lp8788.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-rtc-rtc-lp8788.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-rtc-rtc-lp8788.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-rtc-rtc-lp8788.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-megaraid-megaraid_mbox.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-megaraid-megaraid_mm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-stex.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-staging-most-dim2-dim2.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-staging-sm750fb-sm750.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-staging-vme_user-vme_fake.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-staging-vme_user-vme_fake.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-staging-vme_user-vme_fake.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-staging-vme_user-vme_fake.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-staging-vme_user-vme_fake.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   |-- drivers-staging-vme_user-vme_fake.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- fs-erofs-decompressor_lzma.c:sparse:sparse:bad-integer-constant-expression
|   |-- fs-erofs-decompressor_lzma.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- fs-erofs-decompressor_zstd.c:sparse:sparse:bad-integer-constant-expression
|   `-- fs-erofs-decompressor_zstd.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|-- powerpc-randconfig-r054-20251205
|   `-- drivers-gpib-lpvo_usb_gpib-lpvo_usb_gpib.c:warning:sprintf-may-write-a-terminating-nul-past-the-end-of-the-destination
|-- sparc-randconfig-r123-20251204
|   |-- crypto-async_tx-raid6test.c:sparse:sparse:bad-integer-constant-expression
|   |-- crypto-async_tx-raid6test.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- crypto-async_tx-raid6test.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- crypto-async_tx-raid6test.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_cmd640.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-ata-pata_cmd640.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_cmd640.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_cmd640.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_cmd640.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_cmd640.c:sparse:sparse:static-assertion-failed:MODULE_INFO(version-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-epia.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-ata-pata_parport-epia.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-epia.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-epia.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-frpw.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-ata-pata_parport-frpw.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-frpw.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-frpw.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-ktti.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-ata-pata_parport-ktti.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-ktti.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-pata_parport-ktti.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-sata_sil24.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-ata-sata_sil24.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-sata_sil24.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-sata_sil24.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-sata_sil24.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-sata_sil24.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   |-- drivers-ata-sata_sil24.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-hid-hid-cp2112.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-hid-hid-cp2112.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-hid-hid-cp2112.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-hid-hid-cp2112.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-hid-hid-cp2112.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   |-- drivers-hid-hid-cp2112.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-media-i2c-ds90ub913.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-misc-lan966x_pci.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-misc-lan966x_pci.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-misc-lan966x_pci.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-misc-lan966x_pci.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-mtd-maps-sun_uflash.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-mtd-maps-sun_uflash.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-mtd-maps-sun_uflash.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-mtd-maps-sun_uflash.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-mtd-maps-sun_uflash.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-mtd-maps-sun_uflash.c:sparse:sparse:static-assertion-failed:MODULE_INFO(version-...)-contains-embedded-NUL-byte
|   |-- drivers-sbus-char-openprom.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-sbus-char-openprom.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
|   |-- drivers-sbus-char-openprom.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-sbus-char-openprom.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-sbus-char-openprom.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-sbus-char-openprom.c:sparse:sparse:static-assertion-failed:MODULE_INFO(version-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-3w-xxxx.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-scsi-3w-xxxx.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-3w-xxxx.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-3w-xxxx.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-3w-xxxx.c:sparse:sparse:static-assertion-failed:MODULE_INFO(version-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-dc395x.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-scsi-dc395x.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-dc395x.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-dc395x.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-dc395x.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-dc395x.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-dc395x.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-megaraid-megaraid_mbox.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-scsi-megaraid-megaraid_mbox.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-megaraid-megaraid_mbox.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-megaraid-megaraid_mbox.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-megaraid-megaraid_mbox.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-megaraid-megaraid_mbox.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-megaraid-megaraid_mbox.c:sparse:sparse:static-assertion-failed:MODULE_INFO(version-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-megaraid-megaraid_mm.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-scsi-megaraid-megaraid_mm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-megaraid-megaraid_mm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-megaraid-megaraid_mm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-megaraid-megaraid_mm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-megaraid-megaraid_mm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-megaraid-megaraid_mm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(version-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-mvsas-mv_init.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-scsi-mvsas-mv_init.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-mvsas-mv_init.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-mvsas-mv_init.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-mvsas-mv_init.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-mvsas-mv_init.c:sparse:sparse:static-assertion-failed:MODULE_INFO(version-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-pm8001-pm8001_init.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-scsi-pm8001-pm8001_init.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-pm8001-pm8001_init.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-pm8001-pm8001_init.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-pm8001-pm8001_init.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-pm8001-pm8001_init.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-pm8001-pm8001_init.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-pm8001-pm8001_init.c:sparse:sparse:static-assertion-failed:MODULE_INFO(version-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-qla1280.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-scsi-qla1280.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-qla1280.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-qla1280.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-qla1280.c:sparse:sparse:static-assertion-failed:MODULE_INFO(firmware-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-qla1280.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-qla1280.c:sparse:sparse:static-assertion-failed:MODULE_INFO(version-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-smartpqi-smartpqi_init.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-scsi-smartpqi-smartpqi_init.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-smartpqi-smartpqi_init.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-smartpqi-smartpqi_init.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-smartpqi-smartpqi_init.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-smartpqi-smartpqi_init.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-smartpqi-smartpqi_init.c:sparse:sparse:static-assertion-failed:MODULE_INFO(version-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-stex.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-scsi-stex.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-stex.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-stex.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-stex.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-stex.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-stex.c:sparse:sparse:static-assertion-failed:MODULE_INFO(version-...)-contains-embedded-NUL-byte
|   |-- drivers-soundwire-qcom.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-soundwire-qcom.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-soundwire-qcom.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-staging-greybus-hid.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-staging-greybus-hid.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-staging-greybus-hid.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-staging-sm750fb-sm750.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-staging-sm750fb-sm750.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-staging-sm750fb-sm750.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-staging-sm750fb-sm750.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-staging-sm750fb-sm750.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   |-- drivers-staging-sm750fb-sm750.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-staging-vme_user-vme_tsi148.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-staging-vme_user-vme_tsi148.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-staging-vme_user-vme_tsi148.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-staging-vme_user-vme_tsi148.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-staging-vme_user-vme_tsi148.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   |-- drivers-staging-vme_user-vme_tsi148.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-staging-vme_user-vme_user.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-staging-vme_user-vme_user.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-staging-vme_user-vme_user.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-staging-vme_user-vme_user.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-staging-vme_user-vme_user.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-staging-vme_user-vme_user.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   |-- drivers-staging-vme_user-vme_user.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-tty-serial-sunsab.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-tty-serial-sunzilog.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-tty-serial-sunzilog.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-tty-serial-sunzilog.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-tty-serial-sunzilog.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-tty-serial-sunzilog.c:sparse:sparse:static-assertion-failed:MODULE_INFO(version-...)-contains-embedded-NUL-byte
|   |-- drivers-tty-serial-xilinx_uartps.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-video-fbdev-savage-savagefb-i2c.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-video-fbdev-savage-savagefb-i2c.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- sound-firewire-dice-dice.c:sparse:sparse:bad-integer-constant-expression
|   |-- sound-firewire-dice-dice.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- sound-firewire-dice-dice.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- sound-firewire-dice-dice.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- sound-firewire-digi0-digi0.c:sparse:sparse:bad-integer-constant-expression
|   |-- sound-firewire-digi0-digi0.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- sound-firewire-digi0-digi0.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- sound-firewire-digi0-digi0.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- sound-firewire-lib.c:sparse:sparse:bad-integer-constant-expression
|   |-- sound-firewire-lib.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- sound-firewire-lib.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- sound-firewire-lib.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- sound-firewire-motu-motu.c:sparse:sparse:bad-integer-constant-expression
|   |-- sound-firewire-motu-motu.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- sound-firewire-motu-motu.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- sound-firewire-motu-motu.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- sound-hda-codecs-hdmi-nvhdmi-mcp.c:sparse:sparse:bad-integer-constant-expression
|   |-- sound-hda-codecs-hdmi-nvhdmi-mcp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- sound-hda-codecs-hdmi-nvhdmi-mcp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(import_ns-...)-contains-embedded-NUL-byte
|   |-- sound-hda-codecs-hdmi-nvhdmi-mcp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- sound-hda-codecs-hdmi-simplehdmi.c:sparse:sparse:bad-integer-constant-expression
|   |-- sound-hda-codecs-hdmi-simplehdmi.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- sound-hda-codecs-hdmi-simplehdmi.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-cs35l56-sdw.c:sparse:sparse:bad-integer-constant-expression
|   |-- sound-soc-codecs-cs35l56-sdw.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-cs35l56-sdw.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-cs35l56-sdw.c:sparse:sparse:static-assertion-failed:MODULE_INFO(import_ns-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-cs35l56-sdw.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-cs40l50-codec.c:sparse:sparse:bad-integer-constant-expression
|   |-- sound-soc-codecs-cs40l50-codec.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-cs40l50-codec.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-cs40l50-codec.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-cs42l42-sdw.c:sparse:sparse:bad-integer-constant-expression
|   |-- sound-soc-codecs-cs42l42-sdw.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-cs42l42-sdw.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-cs42l42-sdw.c:sparse:sparse:static-assertion-failed:MODULE_INFO(import_ns-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-cs42l42-sdw.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-pm4125-sdw.c:sparse:sparse:bad-integer-constant-expression
|   |-- sound-soc-codecs-pm4125-sdw.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-pm4125-sdw.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-pm4125.c:sparse:sparse:bad-integer-constant-expression
|   |-- sound-soc-codecs-pm4125.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-pm4125.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-rt-sdw-common.c:sparse:sparse:bad-integer-constant-expression
|   |-- sound-soc-codecs-rt-sdw-common.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-rt-sdw-common.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-rt-sdw-common.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-rt1318-sdw.c:sparse:sparse:bad-integer-constant-expression
|   |-- sound-soc-codecs-rt1318-sdw.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-rt1318-sdw.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-rt1318-sdw.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-rt700-sdw.c:sparse:sparse:bad-integer-constant-expression
|   |-- sound-soc-codecs-rt700-sdw.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-rt700-sdw.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-rt700-sdw.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-rt700.c:sparse:sparse:bad-integer-constant-expression
|   |-- sound-soc-codecs-rt700.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-rt700.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-rt700.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-rt712-sdca-dmic.c:sparse:sparse:bad-integer-constant-expression
|   |-- sound-soc-codecs-rt712-sdca-dmic.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-rt712-sdca-dmic.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-rt712-sdca-dmic.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-rt721-sdca-sdw.c:sparse:sparse:bad-integer-constant-expression
|   |-- sound-soc-codecs-rt721-sdca-sdw.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-rt721-sdca-sdw.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-rt721-sdca-sdw.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-rt721-sdca.c:sparse:sparse:bad-integer-constant-expression
|   |-- sound-soc-codecs-rt721-sdca.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-rt721-sdca.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-rt721-sdca.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-rt722-sdca-sdw.c:sparse:sparse:bad-integer-constant-expression
|   |-- sound-soc-codecs-rt722-sdca-sdw.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-rt722-sdca-sdw.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-rt722-sdca-sdw.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-rt722-sdca.c:sparse:sparse:bad-integer-constant-expression
|   |-- sound-soc-codecs-rt722-sdca.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-rt722-sdca.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-rt722-sdca.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-wcd934x.c:sparse:sparse:bad-integer-constant-expression
|   |-- sound-soc-codecs-wcd934x.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-wcd934x.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-wcd937x-sdw.c:sparse:sparse:bad-integer-constant-expression
|   |-- sound-soc-codecs-wcd937x-sdw.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-wcd937x-sdw.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-wcd937x.c:sparse:sparse:bad-integer-constant-expression
|   |-- sound-soc-codecs-wcd937x.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-wcd937x.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-wsa883x.c:sparse:sparse:bad-integer-constant-expression
|   |-- sound-soc-codecs-wsa883x.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-wsa883x.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-wsa884x.c:sparse:sparse:bad-integer-constant-expression
|   |-- sound-soc-codecs-wsa884x.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-wsa884x.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- sound-soc-codecs-wsa884x.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- sound-sparc-amd7930.c:sparse:sparse:bad-integer-constant-expression
|   |-- sound-sparc-amd7930.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- sound-sparc-amd7930.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- sound-sparc-amd7930.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- sound-sparc-amd7930.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   |-- sound-sparc-amd7930.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- sound-sparc-cs4231.c:sparse:sparse:bad-integer-constant-expression
|   |-- sound-sparc-cs4231.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- sound-sparc-cs4231.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- sound-sparc-cs4231.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- sound-sparc-cs4231.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   |-- sound-sparc-cs4231.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- sound-sparc-dbri.c:sparse:sparse:bad-integer-constant-expression
|   |-- sound-sparc-dbri.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- sound-sparc-dbri.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- sound-sparc-dbri.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- sound-sparc-dbri.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   `-- sound-sparc-dbri.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|-- sparc-randconfig-r134-20251205
|   |-- arch-sparc-kernel-ds.c:sparse:sparse:bad-integer-constant-expression
|   |-- arch-sparc-kernel-ds.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- arch-sparc-kernel-ds.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- arch-sparc-kernel-ds.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- arch-sparc-kernel-ds.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- arch-sparc-kernel-ds.c:sparse:sparse:static-assertion-failed:MODULE_INFO(version-...)-contains-embedded-NUL-byte
|   |-- drivers-cpufreq-sparc-us2e-cpufreq.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-cpufreq-sparc-us2e-cpufreq.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-cpufreq-sparc-us2e-cpufreq.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-cpufreq-sparc-us2e-cpufreq.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-cpufreq-sparc-us3-cpufreq.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-cpufreq-sparc-us3-cpufreq.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-cpufreq-sparc-us3-cpufreq.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-cpufreq-sparc-us3-cpufreq.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-adc-rn5t618-adc.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-media-i2c-ds90ub960.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-memory-dfl-emif.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-memory-dfl-emif.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-memory-dfl-emif.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-memory-dfl-emif.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-most-most_snd.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-nvdimm-security.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-nvdimm-security.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
|   |-- drivers-nvdimm-security.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-parport-parport_sunbpp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-qlogicpti.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-scsi-qlogicpti.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-qlogicpti.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-qlogicpti.c:sparse:sparse:static-assertion-failed:MODULE_INFO(firmware-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-qlogicpti.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-scsi-qlogicpti.c:sparse:sparse:static-assertion-failed:MODULE_INFO(version-...)-contains-embedded-NUL-byte
|   |-- drivers-staging-media-max96712-max96712.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-staging-media-max96712-max96712.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-staging-media-max96712-max96712.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-staging-media-max96712-max96712.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-staging-media-max96712-max96712.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-staging-most-video-video.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-tty-serial-sunzilog.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-tty-vcc.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-tty-vcc.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-tty-vcc.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-tty-vcc.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-tty-vcc.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-tty-vcc.c:sparse:sparse:static-assertion-failed:MODULE_INFO(version-...)-contains-embedded-NUL-byte
|   |-- fs-openpromfs-inode.c:sparse:sparse:bad-integer-constant-expression
|   |-- fs-openpromfs-inode.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
|   |-- fs-openpromfs-inode.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- fs-openpromfs-inode.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- fs-openpromfs-inode.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- kernel-trace-kprobe_event_gen_test.c:sparse:sparse:bad-integer-constant-expression
|   |-- kernel-trace-kprobe_event_gen_test.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- kernel-trace-kprobe_event_gen_test.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   `-- kernel-trace-kprobe_event_gen_test.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|-- x86_64-randconfig-121-20251205
|   |-- arch-x86-boot-compressed-..-..-..-..-lib-xxhash.c:sparse:sparse:bad-integer-constant-expression
|   |-- arch-x86-boot-compressed-..-..-..-..-lib-xxhash.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- arch-x86-boot-compressed-..-..-..-..-lib-xxhash.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- arch-x86-boot-compressed-..-..-..-..-lib-xxhash.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- arch-x86-boot-compressed-..-..-..-..-lib-zstd-zstd_decompress_module.c:sparse:sparse:bad-integer-constant-expression
|   |-- arch-x86-boot-compressed-..-..-..-..-lib-zstd-zstd_decompress_module.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- arch-x86-boot-compressed-..-..-..-..-lib-zstd-zstd_decompress_module.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- arch-x86-boot-compressed-..-..-..-..-lib-zstd-zstd_decompress_module.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-acpi-acpi_pad.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-acpi-acpi_pad.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-acpi-acpi_pad.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-acpi-acpi_pad.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-acpi-acpi_pad.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-acpi-acpi_tad.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-acpi-acpi_tad.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-acpi-acpi_tad.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-acpi-acpi_tad.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-acpi-acpi_tad.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-acpi-pfr_telemetry.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-acpi-pfr_telemetry.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-acpi-pfr_telemetry.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-acpi-pfr_telemetry.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-acpi-pfr_update.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-acpi-pfr_update.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-acpi-pfr_update.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-acpi-pfr_update.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-char-tpm-tpm_svsm.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-char-tpm-tpm_svsm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
|   |-- drivers-char-tpm-tpm_svsm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-char-tpm-tpm_svsm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-char-tpm-tpm_svsm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-cpufreq-p4-clockmod.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-gpu-drm-sysfb-efidrm.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-gpu-drm-sysfb-efidrm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-gpu-drm-sysfb-efidrm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-gpu-drm-sysfb-efidrm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-gpu-drm-sysfb-vesadrm.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-gpu-drm-sysfb-vesadrm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-gpu-drm-sysfb-vesadrm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-gpu-drm-sysfb-vesadrm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-hwmon-gpd-fan.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-hwmon-gpd-fan.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-hwmon-gpd-fan.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-hwmon-gpd-fan.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-hwmon-gpd-fan.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-hwmon-gpd-fan.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-accel-cros_ec_accel_legacy.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-iio-accel-cros_ec_accel_legacy.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-accel-cros_ec_accel_legacy.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-accel-cros_ec_accel_legacy.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-accel-cros_ec_accel_legacy.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-accel-cros_ec_accel_legacy.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-accel-st_accel_core.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-accel-st_accel_spi.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-adc-max11100.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-gyro-st_gyro_spi.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-imu-st_lsm9ds0-st_lsm9ds0_core.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-imu-st_lsm9ds0-st_lsm9ds0_spi.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-light-acpi-als.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-iio-trigger-iio-trig-hrtimer.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-input-keyboard-max7360-keypad.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-input-misc-adxl34x-spi.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-input-misc-adxl34x-spi.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-input-misc-adxl34x-spi.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-input-misc-adxl34x-spi.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-input-misc-adxl34x-spi.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-input-misc-apanel.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-input-misc-apanel.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
|   |-- drivers-input-misc-apanel.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-input-misc-apanel.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-input-misc-apanel.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-input-misc-apanel.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-mtd-devices-sst25l.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-chrome-chromeos_laptop.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-chrome-chromeos_tbmc.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-platform-chrome-chromeos_tbmc.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-chrome-chromeos_tbmc.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-chrome-chromeos_tbmc.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-chrome-cros_ec_debugfs.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-chrome-cros_ec_lightbar.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-chrome-cros_ec_lpc.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-platform-chrome-cros_ec_lpc.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-chrome-cros_ec_lpc.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-chrome-cros_ec_lpc.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-chrome-wilco_ec-core.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-platform-chrome-wilco_ec-core.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-chrome-wilco_ec-core.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-chrome-wilco_ec-core.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-chrome-wilco_ec-core.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-chrome-wilco_ec-debugfs.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-platform-chrome-wilco_ec-debugfs.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-chrome-wilco_ec-debugfs.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-chrome-wilco_ec-debugfs.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-chrome-wilco_ec-debugfs.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-chrome-wilco_ec-event.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-platform-chrome-wilco_ec-event.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-chrome-wilco_ec-event.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-chrome-wilco_ec-event.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-chrome-wilco_ec-event.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-chrome-wilco_ec-event.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-chrome-wilco_ec-telemetry.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-platform-chrome-wilco_ec-telemetry.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-chrome-wilco_ec-telemetry.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-chrome-wilco_ec-telemetry.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-platform-chrome-wilco_ec-telemetry.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-power-supply-max8925_power.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-power-supply-mt6370-charger.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-power-supply-wilco-charger.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-power-supply-wilco-charger.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
|   |-- drivers-power-supply-wilco-charger.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-power-supply-wilco-charger.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-power-supply-wilco-charger.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-power-supply-wilco-charger.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-pps-generators-pps_gen_tio.c:sparse:sparse:bad-integer-constant-expression
|   |-- drivers-pps-generators-pps_gen_tio.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- drivers-pps-generators-pps_gen_tio.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- drivers-pps-generators-pps_gen_tio.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- drivers-pps-generators-pps_gen_tio.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- drivers-video-fbdev-hgafb.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- lib-crypto-aesgcm.c:sparse:sparse:bad-integer-constant-expression
|   |-- lib-crypto-aesgcm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
|   |-- lib-crypto-aesgcm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- lib-crypto-aesgcm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- lib-crypto-aesgcm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- samples-tsm-mr-tsm_mr_sample.c:sparse:sparse:bad-integer-constant-expression
|   |-- samples-tsm-mr-tsm_mr_sample.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
|   |-- samples-tsm-mr-tsm_mr_sample.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   |-- samples-tsm-mr-tsm_mr_sample.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
|   |-- samples-vfio-mdev-mdpy-fb.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
|   `-- samples-vfio-mdev-mtty.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
`-- x86_64-randconfig-123-20251205
    |-- drivers-bluetooth-btmrvl_sdio.c:sparse:sparse:bad-integer-constant-expression
    |-- drivers-bluetooth-btmrvl_sdio.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- drivers-bluetooth-btmrvl_sdio.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- drivers-bluetooth-btmrvl_sdio.c:sparse:sparse:static-assertion-failed:MODULE_INFO(firmware-...)-contains-embedded-NUL-byte
    |-- drivers-bluetooth-btmrvl_sdio.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- drivers-bluetooth-btmrvl_sdio.c:sparse:sparse:static-assertion-failed:MODULE_INFO(version-...)-contains-embedded-NUL-byte
    |-- drivers-bluetooth-hci_bcsp.c:sparse:sparse:bad-integer-constant-expression
    |-- drivers-bluetooth-hci_bcsp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
    |-- drivers-bluetooth-hci_bcsp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
    |-- drivers-gpu-drm-bridge-chipone-icn6211.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- drivers-input-misc-88pm8_onkey.c:sparse:sparse:bad-integer-constant-expression
    |-- drivers-input-misc-88pm8_onkey.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- drivers-input-misc-88pm8_onkey.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- drivers-input-misc-88pm8_onkey.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- drivers-input-misc-88pm8_onkey.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- drivers-input-misc-88pm8_onkey.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- drivers-input-misc-soc_button_array.c:sparse:sparse:bad-integer-constant-expression
    |-- drivers-input-misc-soc_button_array.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- drivers-input-misc-soc_button_array.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- drivers-input-misc-soc_button_array.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- drivers-input-misc-soc_button_array.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
    |-- drivers-input-misc-soc_button_array.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
    |-- drivers-leds-leds-lp5562.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- drivers-leds-rgb-leds-group-multicolor.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- drivers-media-i2c-ov02a10.c:sparse:sparse:bad-integer-constant-expression
    |-- drivers-media-i2c-ov02a10.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- drivers-media-i2c-ov02a10.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- drivers-media-i2c-ov02a10.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- drivers-media-i2c-ov5647.c:sparse:sparse:bad-integer-constant-expression
    |-- drivers-media-i2c-ov5647.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- drivers-media-i2c-ov5647.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- drivers-media-i2c-ov5647.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- drivers-media-i2c-vd56g3.c:sparse:sparse:bad-integer-constant-expression
    |-- drivers-media-i2c-vd56g3.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- drivers-media-i2c-vd56g3.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- drivers-media-i2c-vd56g3.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- drivers-mmc-core-pwrseq_sd8787.c:sparse:sparse:bad-integer-constant-expression
    |-- drivers-mmc-core-pwrseq_sd8787.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- drivers-mmc-core-pwrseq_sd8787.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- drivers-mmc-host-sdhci-milbeaut.c:sparse:sparse:bad-integer-constant-expression
    |-- drivers-mmc-host-sdhci-milbeaut.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- drivers-mmc-host-sdhci-milbeaut.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- drivers-mmc-host-sdhci-milbeaut.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- drivers-mmc-host-sdhci-milbeaut.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- drivers-nvme-host-tcp.c:sparse:sparse:bad-integer-constant-expression
    |-- drivers-nvme-host-tcp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- drivers-nvme-host-tcp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- drivers-nvme-host-tcp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- drivers-nvme-host-tcp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
    |-- drivers-nvme-host-tcp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
    |-- drivers-platform-surface-surface_hotplug.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- drivers-staging-greybus-bootrom.c:sparse:sparse:bad-integer-constant-expression
    |-- drivers-staging-greybus-bootrom.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- drivers-staging-greybus-bootrom.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- drivers-staging-greybus-bootrom.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- drivers-staging-greybus-power_supply.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- drivers-target-target_core_user.c:sparse:sparse:bad-integer-constant-expression
    |-- drivers-target-target_core_user.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- drivers-target-target_core_user.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- drivers-target-target_core_user.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- drivers-target-target_core_user.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
    |-- drivers-video-backlight-lp8788_bl.c:sparse:sparse:bad-integer-constant-expression
    |-- drivers-video-backlight-lp8788_bl.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- drivers-video-backlight-lp8788_bl.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- drivers-video-backlight-lp8788_bl.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- drivers-video-backlight-lp8788_bl.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- fs-dlm-main.c:sparse:sparse:bad-integer-constant-expression
    |-- fs-dlm-main.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- fs-dlm-main.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- fs-dlm-main.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- fs-hfs-string_test.c:sparse:sparse:bad-integer-constant-expression
    |-- fs-hfs-string_test.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- fs-hfs-string_test.c:sparse:sparse:static-assertion-failed:MODULE_INFO(import_ns-...)-contains-embedded-NUL-byte
    |-- fs-hfs-string_test.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- fs-ocfs2-cluster-nodemanager.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- fs-ocfs2-dlmfs-dlmfs.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- fs-ocfs2-stack_user.c:sparse:sparse:bad-integer-constant-expression
    |-- fs-ocfs2-stack_user.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- fs-ocfs2-stack_user.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- fs-ocfs2-stack_user.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- fs-ocfs2-stackglue.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- fs-ocfs2-super.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- lib-ts_bm.c:sparse:sparse:bad-integer-constant-expression
    |-- lib-ts_bm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- lib-ts_bm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- lib-ts_fsm.c:sparse:sparse:bad-integer-constant-expression
    |-- lib-ts_fsm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- lib-ts_fsm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- lib-ts_kmp.c:sparse:sparse:bad-integer-constant-expression
    |-- lib-ts_kmp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- lib-ts_kmp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-bridge-br_netfilter_hooks.c:sparse:sparse:bad-integer-constant-expression
    |-- net-bridge-br_netfilter_hooks.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-bridge-br_netfilter_hooks.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-bridge-br_netfilter_hooks.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-bridge-netfilter-ebt_arpreply.c:sparse:sparse:bad-integer-constant-expression
    |-- net-bridge-netfilter-ebt_arpreply.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-bridge-netfilter-ebt_arpreply.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-bridge-netfilter-ebt_dnat.c:sparse:sparse:bad-integer-constant-expression
    |-- net-bridge-netfilter-ebt_dnat.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-bridge-netfilter-ebt_dnat.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-bridge-netfilter-ebt_ip.c:sparse:sparse:bad-integer-constant-expression
    |-- net-bridge-netfilter-ebt_ip.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-bridge-netfilter-ebt_ip.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-bridge-netfilter-ebt_limit.c:sparse:sparse:bad-integer-constant-expression
    |-- net-bridge-netfilter-ebt_limit.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-bridge-netfilter-ebt_limit.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- net-bridge-netfilter-ebt_limit.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-bridge-netfilter-ebt_mark.c:sparse:sparse:bad-integer-constant-expression
    |-- net-bridge-netfilter-ebt_mark.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-bridge-netfilter-ebt_mark.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- net-bridge-netfilter-ebt_mark.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-bridge-netfilter-ebt_mark_m.c:sparse:sparse:bad-integer-constant-expression
    |-- net-bridge-netfilter-ebt_mark_m.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-bridge-netfilter-ebt_mark_m.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-bridge-netfilter-ebt_nflog.c:sparse:sparse:bad-integer-constant-expression
    |-- net-bridge-netfilter-ebt_nflog.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-bridge-netfilter-ebt_nflog.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-bridge-netfilter-ebt_nflog.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-bridge-netfilter-ebt_pkttype.c:sparse:sparse:bad-integer-constant-expression
    |-- net-bridge-netfilter-ebt_pkttype.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-bridge-netfilter-ebt_pkttype.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-bridge-netfilter-ebt_redirect.c:sparse:sparse:bad-integer-constant-expression
    |-- net-bridge-netfilter-ebt_redirect.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-bridge-netfilter-ebt_redirect.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-bridge-netfilter-ebt_snat.c:sparse:sparse:bad-integer-constant-expression
    |-- net-bridge-netfilter-ebt_snat.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-bridge-netfilter-ebt_snat.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- net-bridge-netfilter-ebt_snat.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-bridge-netfilter-ebt_vlan.c:sparse:sparse:bad-integer-constant-expression
    |-- net-bridge-netfilter-ebt_vlan.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-bridge-netfilter-ebt_vlan.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-bridge-netfilter-ebt_vlan.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-bridge-netfilter-nf_conntrack_bridge.c:sparse:sparse:bad-integer-constant-expression
    |-- net-bridge-netfilter-nf_conntrack_bridge.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-bridge-netfilter-nf_conntrack_bridge.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-bridge-netfilter-nf_conntrack_bridge.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-can-bcm.c:sparse:sparse:bad-integer-constant-expression
    |-- net-can-bcm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-can-bcm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-can-bcm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-can-bcm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-can-j1939-main.c:sparse:sparse:bad-integer-constant-expression
    |-- net-can-j1939-main.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-can-j1939-main.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-can-j1939-main.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-can-j1939-main.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-can-raw.c:sparse:sparse:bad-integer-constant-expression
    |-- net-can-raw.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-can-raw.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-can-raw.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-can-raw.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-ipv4-ah4.c:sparse:sparse:bad-integer-constant-expression
    |-- net-ipv4-ah4.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-ipv4-ah4.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-ipv4-ah4.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-ipv4-ip_vti.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- net-ipv4-ipip.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- net-ipv4-netfilter-nf_nat_pptp.c:sparse:sparse:bad-integer-constant-expression
    |-- net-ipv4-netfilter-nf_nat_pptp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-ipv4-netfilter-nf_nat_pptp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-ipv4-netfilter-nf_nat_pptp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-ipv4-netfilter-nf_nat_pptp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-ipv4-netfilter-nf_tproxy_ipv4.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- net-ipv4-netfilter-nft_reject_ipv4.c:sparse:sparse:bad-integer-constant-expression
    |-- net-ipv4-netfilter-nft_reject_ipv4.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-ipv4-netfilter-nft_reject_ipv4.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-ipv4-netfilter-nft_reject_ipv4.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-ipv4-netfilter-nft_reject_ipv4.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-mptcp-crypto_test.c:sparse:sparse:bad-integer-constant-expression
    |-- net-mptcp-crypto_test.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-mptcp-crypto_test.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-mptcp-token_test.c:sparse:sparse:bad-integer-constant-expression
    |-- net-mptcp-token_test.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-mptcp-token_test.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_conncount.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-nf_conncount.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_conncount.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_conncount.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_conntrack_netlink.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-nf_conntrack_netlink.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_conntrack_netlink.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_conntrack_netlink.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_conntrack_pptp.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-nf_conntrack_pptp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_conntrack_pptp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_conntrack_pptp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_conntrack_pptp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_conntrack_sane.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-nf_conntrack_sane.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_conntrack_sane.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_conntrack_sane.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_conntrack_sane.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_conntrack_sane.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_conntrack_tftp.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-nf_conntrack_tftp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_conntrack_tftp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_conntrack_tftp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_conntrack_tftp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_conntrack_tftp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_conntrack_tftp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_conntrack_timestamp.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-nf_conntrack_timestamp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_conntrack_timestamp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_flow_table_core.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-nf_flow_table_core.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_flow_table_core.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_flow_table_core.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_flow_table_inet.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-nf_flow_table_inet.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_flow_table_inet.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_flow_table_inet.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_flow_table_inet.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_nat_tftp.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-nf_nat_tftp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_nat_tftp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_nat_tftp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nf_nat_tftp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nfnetlink_hook.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-nfnetlink_hook.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nfnetlink_hook.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nfnetlink_hook.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nfnetlink_hook.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nfnetlink_osf.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-nfnetlink_osf.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nfnetlink_osf.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nfnetlink_osf.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nft_connlimit.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-nft_connlimit.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nft_connlimit.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nft_connlimit.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nft_connlimit.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nft_flow_offload.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-nft_flow_offload.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nft_flow_offload.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nft_flow_offload.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-nft_flow_offload.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-x_tables.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_CHECKSUM.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-xt_CHECKSUM.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_CHECKSUM.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_CHECKSUM.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_CHECKSUM.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_CLASSIFY.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-xt_CLASSIFY.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_CLASSIFY.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_CLASSIFY.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_CLASSIFY.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_CLASSIFY.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_CT.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-xt_CT.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_CT.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_CT.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_IDLETIMER.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-xt_IDLETIMER.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_IDLETIMER.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_IDLETIMER.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_IDLETIMER.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_IDLETIMER.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_LED.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-xt_LED.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_LED.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_LED.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_LED.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_LED.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_LOG.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_RATEEST.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-xt_RATEEST.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_RATEEST.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_RATEEST.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_RATEEST.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_RATEEST.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_TCPMSS.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_TEE.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-xt_TEE.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_TEE.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_TEE.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_TEE.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_TPROXY.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-xt_TPROXY.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_TPROXY.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_TPROXY.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_TPROXY.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_connlabel.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-xt_connlabel.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_connlabel.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_connlabel.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_connlabel.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_connmark.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-xt_connmark.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_connmark.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_connmark.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_connmark.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_devgroup.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-xt_devgroup.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_devgroup.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_devgroup.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_devgroup.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_dscp.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-xt_dscp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_dscp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_dscp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_dscp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_dscp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_esp.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-xt_esp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_esp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_esp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_esp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_esp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_hashlimit.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-xt_hashlimit.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_hashlimit.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_hashlimit.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_hashlimit.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_hashlimit.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_helper.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-xt_helper.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_helper.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_helper.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_helper.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_ipcomp.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-xt_ipcomp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_ipcomp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_ipcomp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_ipcomp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_ipcomp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_ipvs.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-xt_ipvs.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_ipvs.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_ipvs.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_ipvs.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_l2tp.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-xt_l2tp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_l2tp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_l2tp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_l2tp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_l2tp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_mark.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-xt_mark.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_mark.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_mark.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_mark.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_mark.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_osf.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-xt_osf.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_osf.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_osf.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_osf.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_owner.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-xt_owner.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_owner.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_owner.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_owner.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_physdev.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-xt_physdev.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_physdev.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_physdev.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_physdev.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_pkttype.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-xt_pkttype.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_pkttype.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_pkttype.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_pkttype.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_pkttype.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_policy.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_quota.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-xt_quota.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_quota.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_quota.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_quota.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_quota.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_rateest.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-xt_rateest.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_rateest.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_rateest.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_rateest.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_realm.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-xt_realm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_realm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_realm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_realm.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_sctp.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-xt_sctp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_sctp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_sctp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_sctp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_string.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-xt_string.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_string.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_string.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_string.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_tcpmss.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-xt_tcpmss.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_tcpmss.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_tcpmss.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_tcpmss.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_tcpmss.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_tcpudp.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_time.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-xt_time.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_time.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_time.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_time.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_u32.c:sparse:sparse:bad-integer-constant-expression
    |-- net-netfilter-xt_u32.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_u32.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_u32.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-netfilter-xt_u32.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-sched-act_connmark.c:sparse:sparse:bad-integer-constant-expression
    |-- net-sched-act_connmark.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-sched-act_connmark.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- net-sched-act_connmark.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-sched-act_connmark.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- net-sched-act_skbmod.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- net-sched-sch_cbs.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- net-sched-sch_etf.c:sparse:sparse:static-assertion-failed:MODULE_INFO(file-...)-contains-embedded-NUL-byte
    |-- net-xfrm-xfrm_user.c:sparse:sparse:bad-integer-constant-expression
    |-- net-xfrm-xfrm_user.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- net-xfrm-xfrm_user.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- net-xfrm-xfrm_user.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- sound-core-oss-pcm_oss.c:sparse:sparse:bad-integer-constant-expression
    |-- sound-core-oss-pcm_oss.c:sparse:sparse:static-assertion-failed:MODULE_INFO(alias-...)-contains-embedded-NUL-byte
    |-- sound-core-oss-pcm_oss.c:sparse:sparse:static-assertion-failed:MODULE_INFO(author-...)-contains-embedded-NUL-byte
    |-- sound-core-oss-pcm_oss.c:sparse:sparse:static-assertion-failed:MODULE_INFO(description-...)-contains-embedded-NUL-byte
    |-- sound-core-oss-pcm_oss.c:sparse:sparse:static-assertion-failed:MODULE_INFO(license-...)-contains-embedded-NUL-byte
    |-- sound-core-oss-pcm_oss.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parm-...)-contains-embedded-NUL-byte
    `-- sound-core-oss-pcm_oss.c:sparse:sparse:static-assertion-failed:MODULE_INFO(parmtype-...)-contains-embedded-NUL-byte

elapsed time: 740m

configs tested: 175
configs skipped: 1

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20251205    gcc-8.5.0
arc                   randconfig-002-20251205    gcc-9.5.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                       aspeed_g4_defconfig    clang-22
arm                                 defconfig    clang-22
arm                          gemini_defconfig    clang-20
arm                       imx_v4_v5_defconfig    clang-22
arm                   randconfig-001-20251205    gcc-8.5.0
arm                   randconfig-002-20251205    gcc-8.5.0
arm                   randconfig-003-20251205    gcc-13.4.0
arm                   randconfig-004-20251205    gcc-8.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20251205    clang-22
arm64                 randconfig-002-20251205    clang-22
arm64                 randconfig-003-20251205    gcc-8.5.0
arm64                 randconfig-004-20251205    clang-22
csky                             allmodconfig    gcc-15.1.0
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20251205    gcc-15.1.0
csky                  randconfig-002-20251205    gcc-11.5.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20251205    clang-22
hexagon               randconfig-002-20251205    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20251205    clang-20
i386        buildonly-randconfig-002-20251205    clang-20
i386        buildonly-randconfig-003-20251205    gcc-14
i386        buildonly-randconfig-004-20251205    gcc-14
i386        buildonly-randconfig-005-20251205    gcc-14
i386        buildonly-randconfig-006-20251205    gcc-12
i386                                defconfig    clang-20
i386                  randconfig-001-20251205    clang-20
i386                  randconfig-002-20251205    gcc-14
i386                  randconfig-003-20251205    clang-20
i386                  randconfig-004-20251205    clang-20
i386                  randconfig-005-20251205    gcc-14
i386                  randconfig-006-20251205    clang-20
i386                  randconfig-007-20251205    gcc-14
i386                  randconfig-011-20251205    clang-20
i386                  randconfig-012-20251205    gcc-13
i386                  randconfig-013-20251205    clang-20
i386                  randconfig-014-20251205    gcc-14
i386                  randconfig-015-20251205    clang-20
i386                  randconfig-016-20251205    gcc-13
i386                  randconfig-017-20251205    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20251205    clang-22
loongarch             randconfig-002-20251205    gcc-15.1.0
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                             allmodconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                             allyesconfig    gcc-15.1.0
mips                           ci20_defconfig    clang-22
mips                         db1xxx_defconfig    clang-22
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20251205    gcc-10.5.0
nios2                 randconfig-002-20251205    gcc-11.5.0
openrisc                         allmodconfig    gcc-15.1.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20251205    gcc-8.5.0
parisc                randconfig-002-20251205    gcc-14.3.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                      arches_defconfig    gcc-15.1.0
powerpc               randconfig-001-20251205    clang-18
powerpc               randconfig-002-20251205    clang-18
powerpc64             randconfig-001-20251205    gcc-15.1.0
powerpc64             randconfig-002-20251205    clang-22
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20251205    gcc-13.4.0
riscv                 randconfig-002-20251205    gcc-8.5.0
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20251205    gcc-11.5.0
s390                  randconfig-002-20251205    clang-22
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                        dreamcast_defconfig    gcc-15.1.0
sh                    randconfig-001-20251205    gcc-13.4.0
sh                    randconfig-002-20251205    gcc-12.5.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251205    gcc-14.3.0
sparc                 randconfig-002-20251205    gcc-8.5.0
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20251205    gcc-8.5.0
sparc64               randconfig-002-20251205    gcc-10.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20251205    gcc-14
um                    randconfig-002-20251205    gcc-14
um                           x86_64_defconfig    clang-22
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20251205    clang-20
x86_64      buildonly-randconfig-002-20251205    gcc-14
x86_64      buildonly-randconfig-003-20251205    gcc-12
x86_64      buildonly-randconfig-004-20251205    clang-20
x86_64      buildonly-randconfig-005-20251205    clang-20
x86_64      buildonly-randconfig-006-20251205    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20251205    clang-20
x86_64                randconfig-002-20251205    gcc-14
x86_64                randconfig-003-20251205    gcc-14
x86_64                randconfig-004-20251205    clang-20
x86_64                randconfig-005-20251205    gcc-14
x86_64                randconfig-006-20251205    clang-20
x86_64                randconfig-011-20251205    clang-20
x86_64                randconfig-012-20251205    clang-20
x86_64                randconfig-013-20251205    gcc-14
x86_64                randconfig-014-20251205    gcc-14
x86_64                randconfig-015-20251205    gcc-14
x86_64                randconfig-016-20251205    gcc-14
x86_64                randconfig-071-20251205    clang-20
x86_64                randconfig-072-20251205    gcc-12
x86_64                randconfig-073-20251205    gcc-14
x86_64                randconfig-074-20251205    gcc-14
x86_64                randconfig-075-20251205    gcc-12
x86_64                randconfig-076-20251205    gcc-14
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                           alldefconfig    gcc-15.1.0
xtensa                            allnoconfig    gcc-15.1.0
xtensa                           allyesconfig    gcc-15.1.0
xtensa                randconfig-001-20251205    gcc-10.5.0
xtensa                randconfig-002-20251205    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

