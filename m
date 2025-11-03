Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1507CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 23:12:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3C488E00CC; Mon,  3 Nov 2025 18:12:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ED0C8E0058; Mon,  3 Nov 2025 18:12:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DBB98E00CC; Mon,  3 Nov 2025 18:12:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 743958E0058
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:12:31 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E339214022E
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 23:12:30 +0000 (UTC)
X-FDA: 84070846860.23.2B6AB11
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf15.hostedemail.com (Postfix) with ESMTP id D24EAA0011
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 23:12:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lut9axBr;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762211549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=2Y9etgOSY52cKJrObwcBopYdLTT8Pj905Uy7dBAXNR4=;
	b=pqTDQbrNFmN1aCo4Szrv4pHlxA5T8nCk2NZ5hesF1WEPZAV0AeCtStJW0syu9lc3VKJFB0
	rPmtWqNhfHw/5uE57pT/q5/N+oJCqKxqpd4KiCVUswJdi6wVUrU6YWY60QtrEwTo0bhWTI
	metf3AJUjZwdrryUl2hqQDq4XCEcd+4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762211549; a=rsa-sha256;
	cv=none;
	b=ItDNC1L/UYeQewvYNIIbdWCrS8kOegRgGQOH96zfY2TUaA1YemfZcc6aZRq6/+W5tUbmdZ
	/ri2gZkO+AyeesgxrQqRR73824CN5AwMKAF4j4NXzAuI0j9Wa6es2ljVfNa8s7WZTGQyB5
	bc2CTU/K9yHGoF22vuWr/2SLxLK/h80=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lut9axBr;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762211548; x=1793747548;
  h=date:from:to:cc:subject:message-id;
  bh=AlghegE9bkQqdaB6anP7Jl3am6o6jHGwrflZdTHtmVc=;
  b=lut9axBr/2IlF6Coe1Fuiw0lqVNZH9mfpIyOjE8kxGvLdGa1WUrlzxMY
   4uYT2gsWdKmDdaNf/iNO7o0Ib/qj8N00gTR+dMlvhZoqyeMhbsHprc2YQ
   tGr5cZ8h6y3MY/tOgmSDvLMy4S02y6Ofs59wqE+J7YPE267l7wn+pnJ3L
   jJqBqoyLW4P13azwH0/gbBf8J3Mxjxofir6c9O7zUmc3BAxPgO6TiO80I
   vCQWTzj57yET4VtHY9CZydBWmSatSbV6ZoyyYZM3pCmoynnaAtTJ9lpI0
   DZ3u+c9MJj4BqD0es4nA+RQyUZ/mONqY8y2zTUaXibJ3KMl+YdeYZr+eo
   g==;
X-CSE-ConnectionGUID: q0dlaRUlSiCz8XL5a4J79A==
X-CSE-MsgGUID: tMdJ/bu5RYaS2YJbzP4dXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="51867820"
X-IronPort-AV: E=Sophos;i="6.19,277,1754982000"; 
   d="scan'208";a="51867820"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 15:12:26 -0800
X-CSE-ConnectionGUID: a9uwSuGTTnKXSW/PbtCuOQ==
X-CSE-MsgGUID: vswgMqgHT9CEOXRHXQkgJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,277,1754982000"; 
   d="scan'208";a="186233765"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa006.jf.intel.com with ESMTP; 03 Nov 2025 15:12:25 -0800
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vG3hQ-000QbY-2s;
	Mon, 03 Nov 2025 23:11:15 +0000
Date: Tue, 04 Nov 2025 07:10:22 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 9823120909776bbca58a3c55ef1f27d49283c1f3
Message-ID: <202511040701.Os4m05MG-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: D24EAA0011
X-Stat-Signature: qxkfbn9ro1r9tskhcc5n5tmrj14qfds5
X-HE-Tag: 1762211547-13149
X-HE-Meta: U2FsdGVkX1+mHxlApSjkiel6iESOG7NXqoxIBIG3XSV1i7YwnlJVNlJOJTQFHOh1F1Gnk1Xigjb3BvD9BB3CTQsQHgle8XuCsad3zD2m6hCqob3cyjMur6DNGLhwd7ErYmDlx5Nw4TkxWl1Tegy6oBXdTFd14KkvbLURSWmU3NrA7I8OYE4AJ6YDMvM+sdxiTLx008F31owSJB9uZHT39ynxFN3v6hQQLXMDwGMZ5jbb2KHAiruMKy/b538aTI6kxxXjhoTKKDwB8dykpgcto/eNxsA3VbpbW6TbURyukgmw+Q4K3QyEV7bRhMst+PcV56xfhzlYT5ZMaJ1iZvPs61q0Qk5OYwhYX+Js3uKsJco8FeiGg6zxh7pj3PeM1x5EB7KOoNMsW4wr81qvYJh/mAVcgdySiUvkNevGv6MowUfDghfRIdferw0yr2RRpMKOi51HzsiYY3qblhV2BPVO44UsdIrPGKWKe15QI3PyLE97Aw7iO2R1z2VFESA77Xo5DUkj638hMCUTwumX82omp8t+cLVjGx1dUEfOi1XCnkIZLjbAjh3g5Bar9zlOflH/YU4XvD48iIKSka2E6ZyseBGvrG68Ugcy1Uf10V7vHSEnlXusulf3/EqfwuorVvIJ6iiUa0zArMLCNcxtgZf5KFI/Z6XOjTe7JX8UQ021o5xIKd4WUndyoCCtA5sthTGF/Dm5AvRZ6H4E5N+ex4tvwqbKdfR2RYTs2Nfk+6NsHilm1su7Rm6W8ZI9sFcdBXR4QYnMv7QZOtVpBv3ajGieUIuuzbKzaESXGO5/3OYn/7FtR7AnVcRPJTRB+Dnf/k3Yhgl6xpsTiq9481+fQAnJW9Xb2qIX9wYYFeKtU4pugtBoPhj6dyMaHU1NihI7xkb71hsoc7IZgDUFUGm2Zjg7MZy121lj+0vRWdzgg8eb50x5ubk9i9TrcAcgpVrgeIUCwSnpyOZvGYpdCrcPwNA
 jj5xgAgK
 JI6k28jmNFxNMkWIARTsJZ/dSo2guSdJD1aKRT2P8I5fSllK8l6YHekPJ6Lo8sIWURDMSzolQkfqSQ9Uo+HqeUSEkxjB6/tyNuM2SC5dPsc8ZXEGVx0wnKBGQFtKIkgd6+Vht8YIoOk6E5beA5WwC/odvwviI2UO7zNv+TNak3/63kYIoGbt0fpnmgw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 9823120909776bbca58a3c55ef1f27d49283c1f3  Add linux-next specific files for 20251103

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202510211913.5a4SfQab-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510291905.CNy7FYI0-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510292307.DmOaSI39-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202510300152.UG9LOpTY-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202511040246.tgUoHUqf-lkp@intel.com

    ERROR: modpost: "__udivdi3" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
    Warning: drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:7309 function parameter 'connector' not described in 'amdgpu_dm_connector_detect'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:7309 function parameter 'force' not described in 'amdgpu_dm_connector_detect'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_detection.c:1354 function parameter 'link' not described in 'link_detect_analog'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_detection.c:1354 function parameter 'type' not described in 'link_detect_analog'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_detection.c:872 function parameter 'edid_header' not described in 'link_detect_evaluate_edid_header'
    Warning: drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_detection.c:890 function parameter 'link' not described in 'link_detect_ddc_probe'
    drivers/gpu/drm/amd/amdgpu/../display/dc/dce/dce_stream_encoder.c:1571:69: error: positional initialization of field in 'struct' declared with 'designated_init' attribute [-Werror=designated-init]
    include/linux/pinctrl/pinconf-generic.h:250:(.text+0x110): undefined reference to `pinconf_generic_dt_node_to_map'

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/gpu/drm/i915/display/intel_dsi_vbt.c:172 mipi_exec_send_packet() error: uninitialized symbol 'ret'.

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- arc-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- arc-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- arm-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- arm-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- arm64-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- arm64-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- csky-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- csky-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- i386-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dce-dce_stream_encoder.c:error:positional-initialization-of-field-in-struct-declared-with-designated_init-attribute
|-- i386-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dce-dce_stream_encoder.c:error:positional-initialization-of-field-in-struct-declared-with-designated_init-attribute
|-- loongarch-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- loongarch-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- microblaze-allmodconfig
|   |-- ERROR:__udivdi3-drivers-gpu-drm-amd-amdgpu-amdgpu.ko-undefined
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- microblaze-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- mips-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- mips-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- openrisc-allmodconfig
|   |-- ERROR:__udivdi3-drivers-gpu-drm-amd-amdgpu-amdgpu.ko-undefined
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- openrisc-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- parisc-allmodconfig
|   |-- ERROR:__udivdi3-drivers-gpu-drm-amd-amdgpu-amdgpu.ko-undefined
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- parisc-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- parisc-randconfig-002-20251103
|   `-- include-linux-pinctrl-pinconf-generic.h:(.text):undefined-reference-to-pinconf_generic_dt_node_to_map
|-- powerpc-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- riscv-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- riscv-allyesconfig
|   `-- arch-riscv-include-asm-vdso-processor.h:error:expected-instruction-format
|-- s390-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- sparc-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- sparc-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- sparc64-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- sparc64-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- x86_64-allmodconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- x86_64-allyesconfig
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- x86_64-randconfig-161-20251103
|   `-- drivers-gpu-drm-i915-display-intel_dsi_vbt.c-mipi_exec_send_packet()-error:uninitialized-symbol-ret-.
|-- x86_64-rhel-9.4
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- x86_64-rhel-9.4-bpf
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- x86_64-rhel-9.4-func
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- x86_64-rhel-9.4-kselftests
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
|-- x86_64-rhel-9.4-kunit
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
|   |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog
`-- x86_64-rhel-9.4-ltp
    |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-connector-not-described-in-amdgpu_dm_connector_detect
    |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c-function-parameter-force-not-described-in-amdgpu_dm_connector_detect
    |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-edid_header-not-described-in-link_detect_evaluate_edid_header
    |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_analog
    |-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-link-not-described-in-link_detect_ddc_probe
    `-- Warning:drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c-function-parameter-type-not-described-in-link_detect_analog

elapsed time: 978m

configs tested: 130
configs skipped: 10

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20251103    gcc-9.5.0
arc                   randconfig-002-20251103    gcc-15.1.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                     davinci_all_defconfig    clang-19
arm                                 defconfig    clang-22
arm                   randconfig-001-20251103    clang-22
arm                   randconfig-002-20251103    clang-16
arm                          sp7021_defconfig    gcc-15.1.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                            allyesconfig    clang-22
arm64                               defconfig    gcc-15.1.0
csky                             allmodconfig    gcc-15.1.0
csky                              allnoconfig    gcc-15.1.0
csky                             allyesconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20251103    gcc-14
i386        buildonly-randconfig-002-20251103    clang-20
i386        buildonly-randconfig-003-20251103    clang-20
i386        buildonly-randconfig-004-20251103    gcc-14
i386                                defconfig    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                        allyesconfig    clang-22
loongarch                           defconfig    clang-19
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                             allmodconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                             allyesconfig    gcc-15.1.0
mips                  cavium_octeon_defconfig    gcc-15.1.0
mips                        vocore2_defconfig    clang-22
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                            allyesconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
openrisc                         allmodconfig    gcc-15.1.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20251103    gcc-14.3.0
parisc                randconfig-002-20251103    gcc-15.1.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc                    ge_imp3a_defconfig    gcc-15.1.0
powerpc                         ps3_defconfig    gcc-15.1.0
powerpc               randconfig-001-20251103    gcc-8.5.0
powerpc               randconfig-002-20251103    clang-20
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                            allyesconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251103    gcc-15.1.0
sparc                 randconfig-002-20251103    gcc-11.5.0
sparc64                          allmodconfig    clang-22
sparc64                          allyesconfig    gcc-15.1.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20251103    clang-22
sparc64               randconfig-002-20251103    gcc-8.5.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                           x86_64_defconfig    clang-22
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20251103    clang-20
x86_64      buildonly-randconfig-002-20251103    gcc-14
x86_64      buildonly-randconfig-003-20251103    gcc-13
x86_64      buildonly-randconfig-004-20251103    clang-20
x86_64      buildonly-randconfig-005-20251103    gcc-14
x86_64      buildonly-randconfig-006-20251103    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20251103    clang-20
x86_64                randconfig-002-20251103    clang-20
x86_64                randconfig-003-20251103    gcc-14
x86_64                randconfig-004-20251103    gcc-14
x86_64                randconfig-005-20251103    gcc-14
x86_64                randconfig-006-20251103    clang-20
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

