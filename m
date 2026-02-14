Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 706ABEF99FF
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 09:07:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEE756B0005; Sat, 14 Feb 2026 04:07:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9C6D6B0088; Sat, 14 Feb 2026 04:07:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A8256B008A; Sat, 14 Feb 2026 04:07:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 851766B0005
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 04:07:26 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1F1511607E2
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 09:07:26 +0000 (UTC)
X-FDA: 84442483692.17.34DC210
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf16.hostedemail.com (Postfix) with ESMTP id B52BF180009
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 09:07:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZrmDbVge;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771060044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=AeL4UlYZPBXI1WPQOMefYIQ0DKmtAyZQNlt2+pmKSsQ=;
	b=xk2MURWdaXPPctfl8U64CzyH94/ODV5+B+29myhMeDWDgKnZC8M7ocyINXcQ5R6p2T6dAb
	BYK/386qJiaxwptrI/FMqEd4pPOfynopieVFAzWHa5hQgUO1eDC0LORSoo/bUv/l+rnUQK
	GHq1J7Bccylo6dtVLEZWQylgxt1KUOw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZrmDbVge;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771060044; a=rsa-sha256;
	cv=none;
	b=dak+kx5Xp/W1nkToWUx0CMq55BGoNL81dY+0wJ93STp+m5RtLWOsqt245AgLbJawv5qf+1
	S5AlkfCTpEZXaUbHa2eeaUFec+gcBMzyorN4kqTICnmneaLwPRPcpZ/cWUwWQdzeO07vRP
	UpnV3SYwgWINiFoIqQEQe8nGwOVGrlY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771060043; x=1802596043;
  h=date:from:to:cc:subject:message-id;
  bh=xXNOWvfxhaPYQLE4IVNRYaK3Ajhx2kzeufpZ5U3T5Ds=;
  b=ZrmDbVgeueHBKq0yYLtb/qVwOCoaAgZMrXMp/R1TzjW3R8A1GAeCipCl
   DxgWZxJX99Prl9q8sc5L9iehM1ffHcKj+Jy3E8fEclzx2Mf706IOdPldC
   E0Q+syh7f9TgdBSYJnQGMW8xyzw4pMl9tihJsy6E7FaGGuf+pOJOipgOd
   i0bg476IL6NbLUO/mOjxTJNBp4nZQ/v5guSvyuaJiiiREFRTfXPs0vN0c
   iUuKnlyDCFlqzVWVwXnZ7M9HEz6eEC8ktwxVRSHtOR+Wdtc733O7cra2V
   u/k6R72u9961kEDd399sENe1tsqlwx4hRZjLt4Nv+01YYClfijNutlrbP
   A==;
X-CSE-ConnectionGUID: 9hCyHYZyShCfgZmCqzBKXQ==
X-CSE-MsgGUID: TKrTOuuVROqpY3s2Tq5Fuw==
X-IronPort-AV: E=McAfee;i="6800,10657,11700"; a="72327908"
X-IronPort-AV: E=Sophos;i="6.21,290,1763452800"; 
   d="scan'208";a="72327908"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2026 01:07:22 -0800
X-CSE-ConnectionGUID: zKTh15fASly88qy+jqlM/g==
X-CSE-MsgGUID: PxpwHxhIR46uSVnAS079FQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,290,1763452800"; 
   d="scan'208";a="213240142"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 14 Feb 2026 01:07:20 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vrBcT-00000000wPc-2Hts;
	Sat, 14 Feb 2026 09:07:17 +0000
Date: Sat, 14 Feb 2026 17:06:39 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Alexander Potapenko <glider@google.com>
Subject: [akpm-mm:mm-nonmm-unstable 30/30]
 drivers/input/misc/pf1550-onkey.c:190:25: error: use of undeclared identifier
 'pf1550_onkey_pm_ops'; did you mean 'pf1550_onkey_probe'?
Message-ID: <202602141722.pvRjFCqC-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam11
X-Stat-Signature: mqotj7x8n517aok6zo5za6mdwxgpfuxn
X-Rspam-User: 
X-Rspamd-Queue-Id: B52BF180009
X-HE-Tag: 1771060043-667415
X-HE-Meta: U2FsdGVkX18JCkrHisN45T7CLqD7nGHNjIzHiPmiSz5jG5xLIeQcUkkaKalALgXfalRNlQiuuc4MsauU5+/Iij8d4BMzhbpDAKGiadlX1W9r05kztTM/C4yYrqniLC9iDbMil38TeIFgT5qRhG5xwYDEEK382rPPRpI/JHUW4WRyAFv6KhpMs875qZ4+aiRHGIQiMUW6647+rSJbEoFaMCuOTQuyQDH7JwW4tUO+vHiaU8JfvzXkuKsfC7UGs/f/T0UL0LuziQ/PGNn4zC/fi6MLIJzkFohXoamVTOv05Mf1MEwwi5k8R6zMh+af6kpLzm+LtHQZvxqjC3obGi06tk23YNWehVoZBZwdfO2btjDYVjAmsEa3OsMdQlNfpJSsTRaM9KiRZcbMO0k2kBez+X5h30tAq47bIEE0lQRbwmZ95L+5ayL02qIsap6jNsV8HbG8493b1qfDyE9RuDyqjkJeg/KrDiqLpw/1qXfwN3YX5BuXlDa1XMY7dFNI3WlwPf4Wf1autY8591iPbT7KxtWbf8XPTX3tTWPbEkjQPpIj6jq1QzuDMsNimDa9k71frouhtHL1mROzPSbj/PfFGAJwcAXGN0BeNfyGRtP4q4tVXrXHwW3ZUKRtlrMXss7W5rgluxsyW1gbsLHavdgbU/rD1xREOyT27VEsvYVqwyEFLoyL/FQapgQNUz8lC7Ol2c+7cHR84As5YvTHbeIVg+B05RYDVBvtcwmBRz9ts5nOj/7+OzsjHhupRi4omVPQyacWVEDP3PA7RsviYtFWuGQwHmDyz3drXmcmcM0tDc7uILFVR3q+tpdFGfPtuk3BFMW8uyrQjU6k+TzuwGgGZo5JHgb5AlACLSBC7F1hl+gpPqpd7Eupjqkkn6KX5so8k903XvdlnJd8rMjc6HUqSSlDXb13HFQoNe155Nd7LzxD585/EhdFCJIKU8q/Fn02IpEh+qpueW+NyCISWWe
 Pg5MNemp
 9xf65obhUHKz1ikhSFCZbzmGiY+ka6TjBjRe0Fpx+0YuX1ocoU5pNX8b10aLlwHSPX9yv62eXUzGz1OPV9VEqi8AOl4L9cRQq24JE27PHfAYVxmTv3b/pbpTC6JCGnyphHbJ9SKC+o85YcveEslD/zsL5zWRpFNkqKN2EevZlprUItfKgucQwliBirLw07jBPnQZTlkB9XlKRVotsKKCIAAoN80ugv37GC1k/D8z7nb2ljGhXzCBT5orqrExP9fHeiP0rf3hiZJXoOX1c6pIHzXiVtkdalH+KGYqO7przux/JLpkXnIafaW6cUSuEQk+OlssSMXWn9+VXTkaFOUCuDJndCOvDW9+DVKQUHwsXfh8hIh2gOUnkt3VzY2CCTvX2PGYPVF32Iesjicc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
head:   f88534a6e7afcfe6ad5f93b86f6e64d5d4d23709
commit: f88534a6e7afcfe6ad5f93b86f6e64d5d4d23709 [30/30] drivers/input/misc/pf1550-onkey.c: fix build with CONFIG_PM_SLEEP=n
config: i386-buildonly-randconfig-002-20260214 (https://download.01.org/0day-ci/archive/20260214/202602141722.pvRjFCqC-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260214/202602141722.pvRjFCqC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602141722.pvRjFCqC-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/input/misc/pf1550-onkey.c:179:8: warning: extra tokens at end of #endif directive [-Wextra-tokens]
     179 | #endif CONFIG_PM_SLEEP
         |        ^
         |        //
>> drivers/input/misc/pf1550-onkey.c:190:25: error: use of undeclared identifier 'pf1550_onkey_pm_ops'; did you mean 'pf1550_onkey_probe'?
     190 |                 .pm   = pm_sleep_ptr(&pf1550_onkey_pm_ops),
         |                                       ^~~~~~~~~~~~~~~~~~~
         |                                       pf1550_onkey_probe
   include/linux/pm.h:474:65: note: expanded from macro 'pm_sleep_ptr'
     474 | #define pm_sleep_ptr(_ptr) PTR_IF(IS_ENABLED(CONFIG_PM_SLEEP), (_ptr))
         |                                                                 ^
   include/linux/util_macros.h:136:38: note: expanded from macro 'PTR_IF'
     136 | #define PTR_IF(cond, ptr)       ((cond) ? (ptr) : NULL)
         |                                            ^
   drivers/input/misc/pf1550-onkey.c:60:12: note: 'pf1550_onkey_probe' declared here
      60 | static int pf1550_onkey_probe(struct platform_device *pdev)
         |            ^
>> drivers/input/misc/pf1550-onkey.c:190:11: error: incompatible pointer types initializing 'const struct dev_pm_ops *' with an expression of type 'int (*)(struct platform_device *)' [-Werror,-Wincompatible-pointer-types]
     190 |                 .pm   = pm_sleep_ptr(&pf1550_onkey_pm_ops),
         |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/pm.h:474:28: note: expanded from macro 'pm_sleep_ptr'
     474 | #define pm_sleep_ptr(_ptr) PTR_IF(IS_ENABLED(CONFIG_PM_SLEEP), (_ptr))
         |                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/util_macros.h:136:27: note: expanded from macro 'PTR_IF'
     136 | #define PTR_IF(cond, ptr)       ((cond) ? (ptr) : NULL)
         |                                 ^~~~~~~~~~~~~~~~~~~~~~~
   1 warning and 2 errors generated.

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for NET_SELFTESTS
   Depends on [n]: NET [=y] && PHYLIB [=y] && INET [=n]
   Selected by [y]:
   - AMD_XGBE [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_AMD [=y] && (OF_ADDRESS [=y] || ACPI [=y] || PCI [=y]) && HAS_IOMEM [=y] && (X86 [=y] || ARM64 || COMPILE_TEST [=y]) && PTP_1588_CLOCK_OPTIONAL [=y]


vim +190 drivers/input/misc/pf1550-onkey.c

9acb215cbebdce7 Samuel Kayode 2025-10-01   59  
9acb215cbebdce7 Samuel Kayode 2025-10-01  @60  static int pf1550_onkey_probe(struct platform_device *pdev)
9acb215cbebdce7 Samuel Kayode 2025-10-01   61  {
9acb215cbebdce7 Samuel Kayode 2025-10-01   62  	struct onkey_drv_data *onkey;
9acb215cbebdce7 Samuel Kayode 2025-10-01   63  	struct input_dev *input;
9acb215cbebdce7 Samuel Kayode 2025-10-01   64  	bool key_power = false;
9acb215cbebdce7 Samuel Kayode 2025-10-01   65  	int i, irq, error;
9acb215cbebdce7 Samuel Kayode 2025-10-01   66  
9acb215cbebdce7 Samuel Kayode 2025-10-01   67  	onkey = devm_kzalloc(&pdev->dev, sizeof(*onkey), GFP_KERNEL);
9acb215cbebdce7 Samuel Kayode 2025-10-01   68  	if (!onkey)
9acb215cbebdce7 Samuel Kayode 2025-10-01   69  		return -ENOMEM;
9acb215cbebdce7 Samuel Kayode 2025-10-01   70  
9acb215cbebdce7 Samuel Kayode 2025-10-01   71  	onkey->dev = &pdev->dev;
9acb215cbebdce7 Samuel Kayode 2025-10-01   72  
9acb215cbebdce7 Samuel Kayode 2025-10-01   73  	onkey->pf1550 = dev_get_drvdata(pdev->dev.parent);
9acb215cbebdce7 Samuel Kayode 2025-10-01   74  	if (!onkey->pf1550->regmap)
9acb215cbebdce7 Samuel Kayode 2025-10-01   75  		return dev_err_probe(&pdev->dev, -ENODEV,
9acb215cbebdce7 Samuel Kayode 2025-10-01   76  				     "failed to get regmap\n");
9acb215cbebdce7 Samuel Kayode 2025-10-01   77  
9acb215cbebdce7 Samuel Kayode 2025-10-01   78  	onkey->wakeup = device_property_read_bool(pdev->dev.parent,
9acb215cbebdce7 Samuel Kayode 2025-10-01   79  						  "wakeup-source");
9acb215cbebdce7 Samuel Kayode 2025-10-01   80  
9acb215cbebdce7 Samuel Kayode 2025-10-01   81  	if (device_property_read_bool(pdev->dev.parent,
9acb215cbebdce7 Samuel Kayode 2025-10-01   82  				      "nxp,disable-key-power")) {
9acb215cbebdce7 Samuel Kayode 2025-10-01   83  		error = regmap_clear_bits(onkey->pf1550->regmap,
9acb215cbebdce7 Samuel Kayode 2025-10-01   84  					  PF1550_PMIC_REG_PWRCTRL1,
9acb215cbebdce7 Samuel Kayode 2025-10-01   85  					  PF1550_ONKEY_RST_EN);
9acb215cbebdce7 Samuel Kayode 2025-10-01   86  		if (error)
9acb215cbebdce7 Samuel Kayode 2025-10-01   87  			return dev_err_probe(&pdev->dev, error,
9acb215cbebdce7 Samuel Kayode 2025-10-01   88  					     "failed: disable turn system off");
9acb215cbebdce7 Samuel Kayode 2025-10-01   89  	} else {
9acb215cbebdce7 Samuel Kayode 2025-10-01   90  		key_power = true;
9acb215cbebdce7 Samuel Kayode 2025-10-01   91  	}
9acb215cbebdce7 Samuel Kayode 2025-10-01   92  
9acb215cbebdce7 Samuel Kayode 2025-10-01   93  	input = devm_input_allocate_device(&pdev->dev);
9acb215cbebdce7 Samuel Kayode 2025-10-01   94  	if (!input)
9acb215cbebdce7 Samuel Kayode 2025-10-01   95  		return dev_err_probe(&pdev->dev, -ENOMEM,
9acb215cbebdce7 Samuel Kayode 2025-10-01   96  				     "failed to allocate the input device\n");
9acb215cbebdce7 Samuel Kayode 2025-10-01   97  
9acb215cbebdce7 Samuel Kayode 2025-10-01   98  	input->name = pdev->name;
9acb215cbebdce7 Samuel Kayode 2025-10-01   99  	input->phys = "pf1550-onkey/input0";
9acb215cbebdce7 Samuel Kayode 2025-10-01  100  	input->id.bustype = BUS_HOST;
9acb215cbebdce7 Samuel Kayode 2025-10-01  101  
9acb215cbebdce7 Samuel Kayode 2025-10-01  102  	if (key_power)
9acb215cbebdce7 Samuel Kayode 2025-10-01  103  		input_set_capability(input, EV_KEY, KEY_POWER);
9acb215cbebdce7 Samuel Kayode 2025-10-01  104  
9acb215cbebdce7 Samuel Kayode 2025-10-01  105  	onkey->input = input;
9acb215cbebdce7 Samuel Kayode 2025-10-01  106  	platform_set_drvdata(pdev, onkey);
9acb215cbebdce7 Samuel Kayode 2025-10-01  107  
9acb215cbebdce7 Samuel Kayode 2025-10-01  108  	for (i = 0; i < PF1550_ONKEY_IRQ_NR; i++) {
9acb215cbebdce7 Samuel Kayode 2025-10-01  109  		irq = platform_get_irq(pdev, i);
9acb215cbebdce7 Samuel Kayode 2025-10-01  110  		if (irq < 0)
9acb215cbebdce7 Samuel Kayode 2025-10-01  111  			return irq;
9acb215cbebdce7 Samuel Kayode 2025-10-01  112  
9acb215cbebdce7 Samuel Kayode 2025-10-01  113  		error = devm_request_threaded_irq(&pdev->dev, irq, NULL,
9acb215cbebdce7 Samuel Kayode 2025-10-01  114  						  pf1550_onkey_irq_handler,
9acb215cbebdce7 Samuel Kayode 2025-10-01  115  						  IRQF_NO_SUSPEND,
9acb215cbebdce7 Samuel Kayode 2025-10-01  116  						  "pf1550-onkey", onkey);
9acb215cbebdce7 Samuel Kayode 2025-10-01  117  		if (error)
9acb215cbebdce7 Samuel Kayode 2025-10-01  118  			return dev_err_probe(&pdev->dev, error,
9acb215cbebdce7 Samuel Kayode 2025-10-01  119  					     "failed: irq request (IRQ: %d)\n",
9acb215cbebdce7 Samuel Kayode 2025-10-01  120  					     i);
9acb215cbebdce7 Samuel Kayode 2025-10-01  121  	}
9acb215cbebdce7 Samuel Kayode 2025-10-01  122  
9acb215cbebdce7 Samuel Kayode 2025-10-01  123  	error = input_register_device(input);
9acb215cbebdce7 Samuel Kayode 2025-10-01  124  	if (error)
9acb215cbebdce7 Samuel Kayode 2025-10-01  125  		return dev_err_probe(&pdev->dev, error,
9acb215cbebdce7 Samuel Kayode 2025-10-01  126  				     "failed to register input device\n");
9acb215cbebdce7 Samuel Kayode 2025-10-01  127  
9acb215cbebdce7 Samuel Kayode 2025-10-01  128  	device_init_wakeup(&pdev->dev, onkey->wakeup);
9acb215cbebdce7 Samuel Kayode 2025-10-01  129  
9acb215cbebdce7 Samuel Kayode 2025-10-01  130  	return 0;
9acb215cbebdce7 Samuel Kayode 2025-10-01  131  }
9acb215cbebdce7 Samuel Kayode 2025-10-01  132  
f88534a6e7afcfe Andrew Morton 2026-02-13  133  #ifdef CONFIG_PM_SLEEP
9acb215cbebdce7 Samuel Kayode 2025-10-01  134  static int pf1550_onkey_suspend(struct device *dev)
9acb215cbebdce7 Samuel Kayode 2025-10-01  135  {
9acb215cbebdce7 Samuel Kayode 2025-10-01  136  	struct platform_device *pdev = to_platform_device(dev);
9acb215cbebdce7 Samuel Kayode 2025-10-01  137  	struct onkey_drv_data *onkey = platform_get_drvdata(pdev);
9acb215cbebdce7 Samuel Kayode 2025-10-01  138  	int i, irq;
9acb215cbebdce7 Samuel Kayode 2025-10-01  139  
9acb215cbebdce7 Samuel Kayode 2025-10-01  140  	if (!device_may_wakeup(&pdev->dev))
9acb215cbebdce7 Samuel Kayode 2025-10-01  141  		regmap_write(onkey->pf1550->regmap,
9acb215cbebdce7 Samuel Kayode 2025-10-01  142  			     PF1550_PMIC_REG_ONKEY_INT_MASK0,
9acb215cbebdce7 Samuel Kayode 2025-10-01  143  			     ONKEY_IRQ_PUSHI | ONKEY_IRQ_1SI | ONKEY_IRQ_2SI |
9acb215cbebdce7 Samuel Kayode 2025-10-01  144  			     ONKEY_IRQ_3SI | ONKEY_IRQ_4SI | ONKEY_IRQ_8SI);
9acb215cbebdce7 Samuel Kayode 2025-10-01  145  	else
9acb215cbebdce7 Samuel Kayode 2025-10-01  146  		for (i = 0; i < PF1550_ONKEY_IRQ_NR; i++) {
9acb215cbebdce7 Samuel Kayode 2025-10-01  147  			irq = platform_get_irq(pdev, i);
9acb215cbebdce7 Samuel Kayode 2025-10-01  148  			if (irq > 0)
9acb215cbebdce7 Samuel Kayode 2025-10-01  149  				enable_irq_wake(irq);
9acb215cbebdce7 Samuel Kayode 2025-10-01  150  		}
9acb215cbebdce7 Samuel Kayode 2025-10-01  151  
9acb215cbebdce7 Samuel Kayode 2025-10-01  152  	return 0;
9acb215cbebdce7 Samuel Kayode 2025-10-01  153  }
9acb215cbebdce7 Samuel Kayode 2025-10-01  154  
9acb215cbebdce7 Samuel Kayode 2025-10-01  155  static int pf1550_onkey_resume(struct device *dev)
9acb215cbebdce7 Samuel Kayode 2025-10-01  156  {
9acb215cbebdce7 Samuel Kayode 2025-10-01  157  	struct platform_device *pdev = to_platform_device(dev);
9acb215cbebdce7 Samuel Kayode 2025-10-01  158  	struct onkey_drv_data *onkey = platform_get_drvdata(pdev);
9acb215cbebdce7 Samuel Kayode 2025-10-01  159  	int i, irq;
9acb215cbebdce7 Samuel Kayode 2025-10-01  160  
9acb215cbebdce7 Samuel Kayode 2025-10-01  161  	if (!device_may_wakeup(&pdev->dev))
9acb215cbebdce7 Samuel Kayode 2025-10-01  162  		regmap_write(onkey->pf1550->regmap,
9acb215cbebdce7 Samuel Kayode 2025-10-01  163  			     PF1550_PMIC_REG_ONKEY_INT_MASK0,
9acb215cbebdce7 Samuel Kayode 2025-10-01  164  			     ~((u8)(ONKEY_IRQ_PUSHI | ONKEY_IRQ_1SI |
9acb215cbebdce7 Samuel Kayode 2025-10-01  165  			     ONKEY_IRQ_2SI | ONKEY_IRQ_3SI | ONKEY_IRQ_4SI |
9acb215cbebdce7 Samuel Kayode 2025-10-01  166  			     ONKEY_IRQ_8SI)));
9acb215cbebdce7 Samuel Kayode 2025-10-01  167  	else
9acb215cbebdce7 Samuel Kayode 2025-10-01  168  		for (i = 0; i < PF1550_ONKEY_IRQ_NR; i++) {
9acb215cbebdce7 Samuel Kayode 2025-10-01  169  			irq = platform_get_irq(pdev, i);
9acb215cbebdce7 Samuel Kayode 2025-10-01  170  			if (irq > 0)
9acb215cbebdce7 Samuel Kayode 2025-10-01  171  				disable_irq_wake(irq);
9acb215cbebdce7 Samuel Kayode 2025-10-01  172  		}
9acb215cbebdce7 Samuel Kayode 2025-10-01  173  
9acb215cbebdce7 Samuel Kayode 2025-10-01  174  	return 0;
9acb215cbebdce7 Samuel Kayode 2025-10-01  175  }
9acb215cbebdce7 Samuel Kayode 2025-10-01  176  
9acb215cbebdce7 Samuel Kayode 2025-10-01  177  static SIMPLE_DEV_PM_OPS(pf1550_onkey_pm_ops, pf1550_onkey_suspend,
9acb215cbebdce7 Samuel Kayode 2025-10-01  178  			 pf1550_onkey_resume);
f88534a6e7afcfe Andrew Morton 2026-02-13 @179  #endif CONFIG_PM_SLEEP
9acb215cbebdce7 Samuel Kayode 2025-10-01  180  
9acb215cbebdce7 Samuel Kayode 2025-10-01  181  static const struct platform_device_id pf1550_onkey_id[] = {
9acb215cbebdce7 Samuel Kayode 2025-10-01  182  	{ "pf1550-onkey", },
9acb215cbebdce7 Samuel Kayode 2025-10-01  183  	{ /* sentinel */ }
9acb215cbebdce7 Samuel Kayode 2025-10-01  184  };
9acb215cbebdce7 Samuel Kayode 2025-10-01  185  MODULE_DEVICE_TABLE(platform, pf1550_onkey_id);
9acb215cbebdce7 Samuel Kayode 2025-10-01  186  
9acb215cbebdce7 Samuel Kayode 2025-10-01  187  static struct platform_driver pf1550_onkey_driver = {
9acb215cbebdce7 Samuel Kayode 2025-10-01  188  	.driver = {
9acb215cbebdce7 Samuel Kayode 2025-10-01  189  		.name = "pf1550-onkey",
9acb215cbebdce7 Samuel Kayode 2025-10-01 @190  		.pm   = pm_sleep_ptr(&pf1550_onkey_pm_ops),
9acb215cbebdce7 Samuel Kayode 2025-10-01  191  	},
9acb215cbebdce7 Samuel Kayode 2025-10-01  192  	.probe = pf1550_onkey_probe,
9acb215cbebdce7 Samuel Kayode 2025-10-01  193  	.id_table = pf1550_onkey_id,
9acb215cbebdce7 Samuel Kayode 2025-10-01  194  };
9acb215cbebdce7 Samuel Kayode 2025-10-01  195  module_platform_driver(pf1550_onkey_driver);
9acb215cbebdce7 Samuel Kayode 2025-10-01  196  

:::::: The code at line 190 was first introduced by commit
:::::: 9acb215cbebdce721af2219e2859ad17342c9084 Input: pf1550 - add onkey support

:::::: TO: Samuel Kayode <samuel.kayode@savoirfairelinux.com>
:::::: CC: Lee Jones <lee@kernel.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

