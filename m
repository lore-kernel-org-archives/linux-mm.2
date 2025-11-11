Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5764ECCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 18:20:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43ECE8E000A; Tue, 11 Nov 2025 13:20:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EEA78E0002; Tue, 11 Nov 2025 13:20:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DEA28E000A; Tue, 11 Nov 2025 13:20:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 19C798E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:20:12 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A5D531395E2
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:20:11 +0000 (UTC)
X-FDA: 84099140622.06.23659BC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf01.hostedemail.com (Postfix) with ESMTP id 76B0C40018
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:20:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bWCuCz9x;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762885209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yS9Uns6sN7Zs0UN1UfyTSPk246kMk3kPP7paloLYnJc=;
	b=14Je9RT/FGX9//AICuBSPuS9Kj7WfubQBjMoMBGdTd0DXBgSZe2BvO6e0hWoAN3OCzJti6
	cv25h5teZ4U3g0vPcYrMGJklAAbm8ep4PtCdeon9qdIuNTZu826mGe8Jd19L2rxDIvHOkZ
	evCYwMdPqcjUJndgwcOdTxOkpSwUTO0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762885209; a=rsa-sha256;
	cv=none;
	b=2N1pzZC0AML8/dtnXr33Bg3da6EuUxnx5XieY7cwkvPnfAGvrsdgGggFWQYkRodNuXrAsK
	JGuQloTY90myF0ut8+9K0bHM5LHXTGrL+OVioEak8oB3ISty3+7HZJEcGGjLYsnMJa3gzC
	9End7J/wsRgHDg8dPttYDBuCmaHeHCQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bWCuCz9x;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762885209; x=1794421209;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=L9y6l1JcRYytTYbCKWR9O8mq3E3LjZ2Y2tvMD19pTqo=;
  b=bWCuCz9xZ83GrY4j2AnGgLWj3anrESQ3D5YD1QrHFuQ+6mR0W8N/PeBF
   8nhb73q+ymuAp3gCMiXxjGxn1+LjRSY0wxpiRUcikXBqCivzzVncIX5oy
   QK2mxZjTudU5M8apMFteGy78hZRJ+M2AxELUBucu6iRXy/pf82YAnMFZ2
   /IPpNmlm2yWcMIu3l7PbXIs1T9cpWaP9tTqlssXn4ra0btXLgs9JPp6g+
   DMVLXLaAZObfv+/sHl4J3cUBmNutpFDiUWOrPpxfkzSyJ7VKBokmWy4xz
   C37jvcirHqS0hmhx0807MJ7TfAD+OmBfzEjRAs15ECgLY+J7kt1vbXAPD
   Q==;
X-CSE-ConnectionGUID: AomwvPZxTyeVAw9YpeX35A==
X-CSE-MsgGUID: 3/pBLjHlRQ+yFWF/SXQcBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11610"; a="64655389"
X-IronPort-AV: E=Sophos;i="6.19,297,1754982000"; 
   d="scan'208";a="64655389"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 10:20:08 -0800
X-CSE-ConnectionGUID: 6v7OhOXeQvGxYh2pdXXIsQ==
X-CSE-MsgGUID: kleDu1luSTud/hLpp0gURw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,297,1754982000"; 
   d="scan'208";a="188286071"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 11 Nov 2025 10:20:07 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vIsyK-0003TP-1g;
	Tue, 11 Nov 2025 18:20:04 +0000
Date: Wed, 12 Nov 2025 02:19:06 +0800
From: kernel test robot <lkp@intel.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master 7210/7661] kernel/liveupdate/luo_file.c:571:3:
 error: call to undeclared function 'get_file'; ISO C99 and later do not
 support implicit function declarations
Message-ID: <202511120222.vMZm9rD4-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: meoi593huix9x8ptkwgg4cjjsjnfenxy
X-Rspam-User: 
X-Rspamd-Queue-Id: 76B0C40018
X-Rspamd-Server: rspam10
X-HE-Tag: 1762885209-437156
X-HE-Meta: U2FsdGVkX195UuNM/zadVW6JdMI8yhgaxNdY9Y0Pdm5iDBT91IYhWdajYD5ouDBP2O+lMxIACIOFLuHch5AUsOp1ZcGV8QCfh0QooM7M8+BeXHDuKcF+AKQRcl91RPQ8LRMaFlopPgoQ+RgIa4aRiaRrqMA8R44biz862Uzay0+0IapHl3JURx1pRSJFsW6euORHRJQxkf78YlVPDBHS6K2X49/0AMLWQddUR65ePIQ7U1LM8750mKCTjh8Z2gRCjmQpYAvTGKG/5LF0zYahHqPluhm/fkFM8pRf9jDLzyU0aBmjZORgJdSRec2Cd0sV2213GWQqctB/r1i8O6AyAMfl4qcgayaYa2ltWKr1AvDav5KrgPAASKklABJgx/vG0Z5Vs5T3ENwSsV4Cv45j2TCDkV5OA3vIH2ummnfBK2mgNwILOOgjuwzYsyMW/0bf9xCwg3NxrSGCy49oBesujWm01WJzXE0a4xTa9UYPA40G8XllF1ywAzp2xutWmO2XnNKn+0gWSbe6KaPQli4Q09DYGHhrAC47iJ4pusyJAkq6DYQPDpLHu0iK64es2GbalIsqk3NyOHnWDYdQYn/UV1yzIdJdRkqDcms+E9RC7IsvaOUvgZvdyNff05Y7BcYbPmIpwsJO4unIjhYjFkh47sSb2QOsSd2xkO1D1K8C2Ni0/L4q/8vCdFtGqCWF88qiwZA/37HUoSvkCCu1+JvFP2fmwhk1ZYNPsfxSV2gK9odEiGXheixwy9EoJw7zXer/3hKlM6nsghy3CvHaItiWw0Pj82a4cvVY1toweSNufOgHk7u/oySfPMV2qW+OlhNg4LQbQWsLwEccMRuhwsbKTRzg08a0qJng8G5LvyAp2FGDuNUWIg6gQLHVdJVQzTS2UuIRcErKoGEewlpE+n232RVpEytVHZ68mK9fAD2n6i3DiT4jOJHmB12i/oFlftm5WfWmBzAHLTGM2ccJ7uc
 vc928AGQ
 0vKBF4WV+h8EU5R/DG4/8cOHRF2lxAjK7y8io4qvWzpdtUIZOgaXDlkm9eL6n2+ftA2NOKnmSr9p6R4mgt7cF9q+NOxAKdWbhy8KwH9CyVMbYK+aj1IvfDzp8eJan+JjMPN6gxPhdYcHRd33Bjd1kpWcft33vQ52x8V/LPoCx+Oum3+tD3SAeRsK0OkhHpIUbH4X2mDzkR14gIhkXxN5t8CUy62ApS4evWiKit3NA64pvtMqwYsRyh7s/yjgeo+R/dd0XCqWB6Sz+JvpZvM6uW+BITtf2/SEgW8gMnIOSrHvPRq/taoDMYZaYlofHeG4/RwYoQR5D6hzG/6Kruja6B9ROtLvtXhrY9IDi1jWcKkT5jLVzhe0b2wL9qS9WPdGfY24eibs0A7y4e4Whinn4tA4E/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   2666975a8905776d306bee01c5d98a0395bda1c9
commit: 74602408d6248999ca8a567c46ce0f78204d6e89 [7210/7661] liveupdate: luo_file: implement file systems callbacks
config: x86_64-buildonly-randconfig-001-20251112 (https://download.01.org/0day-ci/archive/20251112/202511120222.vMZm9rD4-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251112/202511120222.vMZm9rD4-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511120222.vMZm9rD4-lkp@intel.com/

All errors (new ones prefixed by >>):

>> kernel/liveupdate/luo_file.c:571:3: error: call to undeclared function 'get_file'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     571 |                 get_file(luo_file->file);
         |                 ^
   kernel/liveupdate/luo_file.c:584:3: error: call to undeclared function 'get_file'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     584 |                 get_file(luo_file->file);
         |                 ^
   2 errors generated.

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for OF_GPIO
   Depends on [n]: GPIOLIB [=y] && OF [=n] && HAS_IOMEM [=y]
   Selected by [y]:
   - GPIO_TB10X [=y] && GPIOLIB [=y] && HAS_IOMEM [=y] && (ARC_PLAT_TB10X || COMPILE_TEST [=y])
   WARNING: unmet direct dependencies detected for MFD_STMFX
   Depends on [n]: HAS_IOMEM [=y] && I2C [=y] && OF [=n]
   Selected by [y]:
   - PINCTRL_STMFX [=y] && PINCTRL [=y] && I2C [=y] && OF_GPIO [=y] && HAS_IOMEM [=y]
   WARNING: unmet direct dependencies detected for GPIO_SYSCON
   Depends on [n]: GPIOLIB [=y] && HAS_IOMEM [=y] && MFD_SYSCON [=y] && OF [=n]
   Selected by [y]:
   - GPIO_SAMA5D2_PIOBU [=y] && GPIOLIB [=y] && HAS_IOMEM [=y] && MFD_SYSCON [=y] && OF_GPIO [=y] && (ARCH_AT91 || COMPILE_TEST [=y])
   WARNING: unmet direct dependencies detected for I2C_K1
   Depends on [n]: I2C [=y] && HAS_IOMEM [=y] && (ARCH_SPACEMIT || COMPILE_TEST [=y]) && OF [=n]
   Selected by [y]:
   - MFD_SPACEMIT_P1 [=y] && HAS_IOMEM [=y] && (ARCH_SPACEMIT || COMPILE_TEST [=y]) && I2C [=y]


vim +/get_file +571 kernel/liveupdate/luo_file.c

   519	
   520	/**
   521	 * luo_retrieve_file - Restores a preserved file from a session by its token.
   522	 * @session: The session from which to retrieve the file.
   523	 * @token:   The unique token identifying the file to be restored.
   524	 * @filep:   Output parameter; on success, this is populated with a pointer
   525	 *           to the newly retrieved 'struct file'.
   526	 *
   527	 * This function is the primary mechanism for recreating a file in the new
   528	 * kernel after a live update. It searches the session's list of deserialized
   529	 * files for an entry matching the provided @token.
   530	 *
   531	 * The operation is idempotent: if a file has already been successfully
   532	 * retrieved, this function will simply return a pointer to the existing
   533	 * 'struct file' and report success without re-executing the retrieve
   534	 * operation. This is handled by checking the 'retrieved' flag under a lock.
   535	 *
   536	 * File retrieval can happen in any order; it is not bound by the order of
   537	 * preservation.
   538	 *
   539	 * Context: Can be called from an ioctl or other in-kernel code in the new
   540	 *          kernel.
   541	 * Return: 0 on success. Returns a negative errno on failure:
   542	 *         -ENOENT if no file with the matching token is found.
   543	 *         Any error code returned by the handler's .retrieve() op.
   544	 */
   545	int luo_retrieve_file(struct luo_session *session, u64 token,
   546			      struct file **filep)
   547	{
   548		struct liveupdate_file_op_args args = {0};
   549		struct luo_file *luo_file;
   550		int err;
   551	
   552		lockdep_assert_held(&session->mutex);
   553	
   554		if (list_empty(&session->files_list))
   555			return -ENOENT;
   556	
   557		list_for_each_entry(luo_file, &session->files_list, list) {
   558			if (luo_file->token == token)
   559				break;
   560		}
   561	
   562		if (luo_file->token != token)
   563			return -ENOENT;
   564	
   565		guard(mutex)(&luo_file->mutex);
   566		if (luo_file->retrieved) {
   567			/*
   568			 * Someone is asking for this file again, so get a reference
   569			 * for them.
   570			 */
 > 571			get_file(luo_file->file);
   572			*filep = luo_file->file;
   573			return 0;
   574		}
   575	
   576		args.handler = luo_file->fh;
   577		args.session = (struct liveupdate_session *)session;
   578		args.serialized_data = luo_file->serialized_data;
   579		err = luo_file->fh->ops->retrieve(&args);
   580		if (!err) {
   581			luo_file->file = args.file;
   582	
   583			/* Get reference so we can keep this file in LUO until finish */
   584			get_file(luo_file->file);
   585			*filep = luo_file->file;
   586			luo_file->retrieved = true;
   587		}
   588	
   589		return err;
   590	}
   591	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

