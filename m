Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4114C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 05:19:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBDB16B008A; Thu, 17 Sep 2026 01:19:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E94936B008C; Thu, 17 Sep 2026 01:19:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D859D6B0092; Thu, 17 Sep 2026 01:19:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AAC656B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:19:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A64CEA0237
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:19:52 +0000 (UTC)
X-FDA: 85222102224.12.E8CDC00
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.6])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0AD9380003
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:19:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cI01zzOG;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 192.198.163.6 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789622390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=l8Mm4Gh2D29J5+N6nMkJfen83hF3sc4PLTLajOUSuOs=;
	b=QqEo1IeVzoU2HzXlh079gDeWGcIUOHKalYCKVbnkzeqz5/Mo93WhO4hbyFAENrjZ1xT8bK
	nklQo5adHG9kBGjlMkKSQDkKTBwfI6HQB2MbLXstE0cL6+6na5vJjbpLMoAxY/JPBiL+rL
	8r0hSxP6J7bqcOEcMtbt0Fi8Akb62To=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789622390;
	b=0kgzE15N5f6lVC4GES5zuH2VYiMB0/+ktjJK5ebSZbPL/3bFRuQUUeNcE9apOoaVG8zoDd
	YS1ut1jIKDfolJpzFRP6u2us/321E8JEuWL/HnIy414Ef8F5n7F+f0D6IBjhAauXJQ2F59
	pbEb5RvvK5aJntvZFffAGjKk6on3UTA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cI01zzOG;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 192.198.163.6 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789622390; x=1821158390;
  h=date:from:to:cc:subject:message-id;
  bh=CdiQS81nfPpUfZ6GRGBXDuYx72eCP70wurrdrexS1+o=;
  b=cI01zzOG9zMkLncFj5s72XL6GgkLmnVP0JnAeub1vyWh2tu2jrETcoC5
   yy9T/n/OI4TVBwX9dLH4BcrYWADZ9ZMXzQUfUSvWTBNT/LrEWxbDbwyxM
   oUUaWMU30zostbhcEWX/iRtG0beRFJDy1n9hDMiMNqKOOfdnV93SFgM2E
   B2HzhTsaBSceo4pmjXyp+yX6VpLFpVVd1ulSZGJ9M11JjqFAVCy9brzTU
   48S+0iY1T0XzTJxradKnTygrR+nE49Qd8S63q9H9AAcvQDeus2HAiZKB9
   /I6qAfC3ZlAAaowqdbGZLSnjMTnFXanxblZdIpCwJGxenTCSsWucO0eBi
   A==;
X-CSE-ConnectionGUID: 7bTK7Uw4TvioavAvYft8tw==
X-CSE-MsgGUID: 0XV1Q9OrRgalR4K8YNY4uw==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="514818"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="514818"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa116.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 22:19:48 -0700
X-CSE-ConnectionGUID: tZZxEQEURE23TTUPfDEjNQ==
X-CSE-MsgGUID: HMN8ui49RPyjPzBzvsY0GA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="297065317"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 16 Sep 2026 22:19:45 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x74X9-0000000078x-0DLN;
	Thu, 17 Sep 2026 05:19:43 +0000
Date: Thu, 17 Sep 2026 13:19:32 +0800
From: kernel test robot <lkp@intel.com>
To: Ye Bin <yebin10@huawei.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: drivers/acpi/x86/s2idle.c:165:51: warning: '%s' directive
 argument is null
Message-ID: <202609171325.a3EAE6OV-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: kzwzku51c6eco616su11tek1sbbejaky
X-Rspamd-Queue-Id: 0AD9380003
X-HE-Tag: 1789622389-843522
X-HE-Meta: U2FsdGVkX1+vYpk8VluviAJuzoBOk0thbUohpl8f19hSvPeIjGVQWFLXIfsz+dw3PSFTbqvTlsuTadVbAMF0HPAAIwVhuB/2qohv0cn0jDXjH14J548/JAd4gAjHgNZqAC6A1LVoL/UwY/BiuTzscgshLMDNUnY/KRMm7K7B6pT5owgrJWAgbXUzlpoyq6hC37Ez39R1G+bjVUPrdaddAS/lyBjIC0i7Ih2rBw1vXyJREyBKvzRCvWXtE4IjDxPtV88q7j2H4IeJe3tdGdEpUqjH819UPojcHpxPPmoeTMTQBd8qV0/xmGApxQToNNt217YFBmn7+7AZBg+7Q1qhH9SpDW4D/stpaRpISd8vG8I5JqC8MFnWSCo6kZI7mHTWRY3i0CnT67evQm47DajZ/UuFmdIPC9Fj/+YnB9mLDI7v2Y03l+/fu/zlg80zoDYc5ibuhpsVG83j8BNpRW4YrHI625B8KeVeyTi6RmtNWl1vmDM/iMwVjjBPNmnSx9pKHPAea+O7TeQ/SEsryIeLfaTULdHC3054r/pTafcIWKGT/v1BZU+mhs6RLgjzZSIJZWXKfVHuB4auhw8GFJm1H6On/0GSOrjhRykRClhjJTk7axUtYPLiF8NoH5V7ojH6urdTO1qGcdgSWnF+ks25Er8CpdC+aFMNjLs2itwNbkjbKiPSd0hV5VJwBjWnfuDN1DxicfKi7PWtC+HKurSJjRrTc8kPkfa3gt1hqJwYpYWdfOvNNsJnv3IaHrYNo310AphChPeYDNHalM30hRk1/M3ZmN0wXoKFywRmFXG+7L3/nDYBPXZDJ/7uigBtVGTIfJH6v57R6tDphNwwtQ4o7sKH2Y6AEbd6/L11GMFrS6Hj9zmNyWJk0rc2Mleuu9PI+5kL1FofnyV0H2buIfYGjAeBQa3u9o+uXJk/zGc/H4XNf6NT2dsFziry5v9f3pvChTsxo/ek42W593rGuOZ
 n0/1VuVk
 k0mA3f0nBWEnUtqCo9BOkBuz/trypAzVcjrXbLJp9dze1aQwbJ14Z0AXgi1Yab5j/TbYRYeaO34uu1lI9UQ/gCRcVydLN3Ro9285Z7eAMgvaSFwfJuM7+asIGEtNHFKa7lNTSKBdzLiZxXsFmtBjUaBzmxXDfRLzVLja0fSfLx5ppHBeRGA3n/t1flby19yhYEHyx7QjOr1iOSpXDJi48EgQqDqfirJLH9ew/SDDfzZ0jTWg2vwh6qpe4d32MeEru6eWQ4i/y9zNbjiki0dmGWno+22qcugZonOt0F2rk8X3nOeyZ4E3eolw+6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ye,

FYI, the error/warning still remains.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   9b87fdc9af2fbfcdb5c24a64139685ef80f6573f
commit: 6c2e6e2c1af1809d1d9cdbd50ac80f54f5995bdb dynamic_debug: add support for print stack
date:   10 months ago
config: x86_64-randconfig-007-20250922 (https://download.01.org/0day-ci/archive/20260917/202609171325.a3EAE6OV-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260917/202609171325.a3EAE6OV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Fixes: 6c2e6e2c1af1 ("dynamic_debug: add support for print stack")
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609171325.a3EAE6OV-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/asm-generic/bug.h:22,
                    from arch/x86/include/asm/bug.h:108,
                    from arch/x86/include/asm/alternative.h:9,
                    from arch/x86/include/asm/barrier.h:5,
                    from include/linux/list.h:11,
                    from include/linux/resource_ext.h:9,
                    from include/linux/acpi.h:13,
                    from drivers/acpi/x86/s2idle.c:18:
   drivers/acpi/x86/s2idle.c: In function 'lpi_device_get_constraints_amd':
>> drivers/acpi/x86/s2idle.c:165:51: warning: '%s' directive argument is null [-Wformat-overflow=]
     165 |                                                   "Name:%s, Enabled: %d, States: %d, MinDstate: %d\n",
         |                                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/printk.h:402:21: note: in definition of macro 'pr_fmt'
     402 | #define pr_fmt(fmt) fmt
         |                     ^~~
   include/linux/dynamic_debug.h:259:9: note: in expansion of macro '__dynamic_func_call_cls'
     259 |         __dynamic_func_call_cls(__UNIQUE_ID(ddebug), cls, fmt, func, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:261:9: note: in expansion of macro '_dynamic_func_call_cls'
     261 |         _dynamic_func_call_cls(_DPRINTK_CLASS_DFLT, fmt, func, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/acpi.h:1268:9: note: in expansion of macro '_dynamic_func_call'
    1268 |         _dynamic_func_call(fmt, __acpi_handle_debug,                    \
         |         ^~~~~~~~~~~~~~~~~~
   drivers/acpi/x86/s2idle.c:164:33: note: in expansion of macro 'acpi_handle_debug'
     164 |                                 acpi_handle_debug(lps0_device_handle,
         |                                 ^~~~~~~~~~~~~~~~~
   drivers/acpi/x86/s2idle.c:165:57: note: format string is defined here
     165 |                                                   "Name:%s, Enabled: %d, States: %d, MinDstate: %d\n",
         |                                                         ^~


vim +165 drivers/acpi/x86/s2idle.c

fef98671194be0 Rafael J. Wysocki  2020-12-17   96  
41233988112f0f Andy Shevchenko    2023-08-18   97  #define for_each_lpi_constraint(entry)						\
41233988112f0f Andy Shevchenko    2023-08-18   98  	for (int i = 0;								\
41233988112f0f Andy Shevchenko    2023-08-18   99  	     entry = &lpi_constraints_table[i], i < lpi_constraints_table_size;	\
41233988112f0f Andy Shevchenko    2023-08-18  100  	     i++)
41233988112f0f Andy Shevchenko    2023-08-18  101  
fef98671194be0 Rafael J. Wysocki  2020-12-17  102  static void lpi_device_get_constraints_amd(void)
fef98671194be0 Rafael J. Wysocki  2020-12-17  103  {
fef98671194be0 Rafael J. Wysocki  2020-12-17  104  	union acpi_object *out_obj;
fef98671194be0 Rafael J. Wysocki  2020-12-17  105  	int i, j, k;
fef98671194be0 Rafael J. Wysocki  2020-12-17  106  
fef98671194be0 Rafael J. Wysocki  2020-12-17  107  	out_obj = acpi_evaluate_dsm_typed(lps0_device_handle, &lps0_dsm_guid,
904d4a6c074b9d Pratik Vishwakarma 2021-06-17  108  					  rev_id, ACPI_LPS0_GET_DEVICE_CONSTRAINTS,
fef98671194be0 Rafael J. Wysocki  2020-12-17  109  					  NULL, ACPI_TYPE_PACKAGE);
fef98671194be0 Rafael J. Wysocki  2020-12-17  110  
fef98671194be0 Rafael J. Wysocki  2020-12-17  111  	acpi_handle_debug(lps0_device_handle, "_DSM function 1 eval %s\n",
fef98671194be0 Rafael J. Wysocki  2020-12-17  112  			  out_obj ? "successful" : "failed");
fef98671194be0 Rafael J. Wysocki  2020-12-17  113  
4a012dc82d504f Pratik Vishwakarma 2021-06-17  114  	if (!out_obj)
4a012dc82d504f Pratik Vishwakarma 2021-06-17  115  		return;
4a012dc82d504f Pratik Vishwakarma 2021-06-17  116  
fef98671194be0 Rafael J. Wysocki  2020-12-17  117  	for (i = 0; i < out_obj->package.count; i++) {
fef98671194be0 Rafael J. Wysocki  2020-12-17  118  		union acpi_object *package = &out_obj->package.elements[i];
fef98671194be0 Rafael J. Wysocki  2020-12-17  119  
aa7a1bb02bb443 Rafael J. Wysocki  2021-01-05  120  		if (package->type == ACPI_TYPE_PACKAGE) {
883cf0d4cf2883 Mario Limonciello  2023-08-18  121  			if (lpi_constraints_table) {
883cf0d4cf2883 Mario Limonciello  2023-08-18  122  				acpi_handle_err(lps0_device_handle,
883cf0d4cf2883 Mario Limonciello  2023-08-18  123  						"Duplicate constraints list\n");
883cf0d4cf2883 Mario Limonciello  2023-08-18  124  				goto free_acpi_buffer;
883cf0d4cf2883 Mario Limonciello  2023-08-18  125  			}
883cf0d4cf2883 Mario Limonciello  2023-08-18  126  
fef98671194be0 Rafael J. Wysocki  2020-12-17  127  			lpi_constraints_table = kcalloc(package->package.count,
fef98671194be0 Rafael J. Wysocki  2020-12-17  128  							sizeof(*lpi_constraints_table),
fef98671194be0 Rafael J. Wysocki  2020-12-17  129  							GFP_KERNEL);
fef98671194be0 Rafael J. Wysocki  2020-12-17  130  
fef98671194be0 Rafael J. Wysocki  2020-12-17  131  			if (!lpi_constraints_table)
fef98671194be0 Rafael J. Wysocki  2020-12-17  132  				goto free_acpi_buffer;
fef98671194be0 Rafael J. Wysocki  2020-12-17  133  
fef98671194be0 Rafael J. Wysocki  2020-12-17  134  			acpi_handle_debug(lps0_device_handle,
fef98671194be0 Rafael J. Wysocki  2020-12-17  135  					  "LPI: constraints list begin:\n");
fef98671194be0 Rafael J. Wysocki  2020-12-17  136  
3c6b1212d20bbb Mario Limonciello  2023-08-18  137  			for (j = 0; j < package->package.count; j++) {
fef98671194be0 Rafael J. Wysocki  2020-12-17  138  				union acpi_object *info_obj = &package->package.elements[j];
fef98671194be0 Rafael J. Wysocki  2020-12-17  139  				struct lpi_device_constraint_amd dev_info = {};
fef98671194be0 Rafael J. Wysocki  2020-12-17  140  				struct lpi_constraints *list;
fef98671194be0 Rafael J. Wysocki  2020-12-17  141  				acpi_status status;
fef98671194be0 Rafael J. Wysocki  2020-12-17  142  
9cc8cd086f05d9 Mario Limonciello  2023-08-18  143  				list = &lpi_constraints_table[lpi_constraints_table_size];
9cc8cd086f05d9 Mario Limonciello  2023-08-18  144  
3c6b1212d20bbb Mario Limonciello  2023-08-18  145  				for (k = 0; k < info_obj->package.count; k++) {
fef98671194be0 Rafael J. Wysocki  2020-12-17  146  					union acpi_object *obj = &info_obj->package.elements[k];
fef98671194be0 Rafael J. Wysocki  2020-12-17  147  
fef98671194be0 Rafael J. Wysocki  2020-12-17  148  					switch (k) {
fef98671194be0 Rafael J. Wysocki  2020-12-17  149  					case 0:
fef98671194be0 Rafael J. Wysocki  2020-12-17  150  						dev_info.enabled = obj->integer.value;
fef98671194be0 Rafael J. Wysocki  2020-12-17  151  						break;
fef98671194be0 Rafael J. Wysocki  2020-12-17  152  					case 1:
fef98671194be0 Rafael J. Wysocki  2020-12-17  153  						dev_info.name = obj->string.pointer;
fef98671194be0 Rafael J. Wysocki  2020-12-17  154  						break;
fef98671194be0 Rafael J. Wysocki  2020-12-17  155  					case 2:
fef98671194be0 Rafael J. Wysocki  2020-12-17  156  						dev_info.function_states = obj->integer.value;
fef98671194be0 Rafael J. Wysocki  2020-12-17  157  						break;
fef98671194be0 Rafael J. Wysocki  2020-12-17  158  					case 3:
fef98671194be0 Rafael J. Wysocki  2020-12-17  159  						dev_info.min_dstate = obj->integer.value;
fef98671194be0 Rafael J. Wysocki  2020-12-17  160  						break;
fef98671194be0 Rafael J. Wysocki  2020-12-17  161  					}
9cc8cd086f05d9 Mario Limonciello  2023-08-18  162  				}
fef98671194be0 Rafael J. Wysocki  2020-12-17  163  
a879058d01e2f6 Mario Limonciello  2023-08-18  164  				acpi_handle_debug(lps0_device_handle,
a879058d01e2f6 Mario Limonciello  2023-08-18 @165  						  "Name:%s, Enabled: %d, States: %d, MinDstate: %d\n",
a879058d01e2f6 Mario Limonciello  2023-08-18  166  						  dev_info.name,
a879058d01e2f6 Mario Limonciello  2023-08-18  167  						  dev_info.enabled,
a879058d01e2f6 Mario Limonciello  2023-08-18  168  						  dev_info.function_states,
a879058d01e2f6 Mario Limonciello  2023-08-18  169  						  dev_info.min_dstate);
a879058d01e2f6 Mario Limonciello  2023-08-18  170  
fef98671194be0 Rafael J. Wysocki  2020-12-17  171  				if (!dev_info.enabled || !dev_info.name ||
fef98671194be0 Rafael J. Wysocki  2020-12-17  172  				    !dev_info.min_dstate)
fef98671194be0 Rafael J. Wysocki  2020-12-17  173  					continue;
fef98671194be0 Rafael J. Wysocki  2020-12-17  174  
9cc8cd086f05d9 Mario Limonciello  2023-08-18  175  				status = acpi_get_handle(NULL, dev_info.name, &list->handle);
fef98671194be0 Rafael J. Wysocki  2020-12-17  176  				if (ACPI_FAILURE(status))
fef98671194be0 Rafael J. Wysocki  2020-12-17  177  					continue;
fef98671194be0 Rafael J. Wysocki  2020-12-17  178  
fef98671194be0 Rafael J. Wysocki  2020-12-17  179  				list->min_dstate = dev_info.min_dstate;
fef98671194be0 Rafael J. Wysocki  2020-12-17  180  
fef98671194be0 Rafael J. Wysocki  2020-12-17  181  				lpi_constraints_table_size++;
fef98671194be0 Rafael J. Wysocki  2020-12-17  182  			}
fef98671194be0 Rafael J. Wysocki  2020-12-17  183  		}
fef98671194be0 Rafael J. Wysocki  2020-12-17  184  	}
fef98671194be0 Rafael J. Wysocki  2020-12-17  185  
fef98671194be0 Rafael J. Wysocki  2020-12-17  186  	acpi_handle_debug(lps0_device_handle, "LPI: constraints list end\n");
fef98671194be0 Rafael J. Wysocki  2020-12-17  187  
fef98671194be0 Rafael J. Wysocki  2020-12-17  188  free_acpi_buffer:
fef98671194be0 Rafael J. Wysocki  2020-12-17  189  	ACPI_FREE(out_obj);
fef98671194be0 Rafael J. Wysocki  2020-12-17  190  }
fef98671194be0 Rafael J. Wysocki  2020-12-17  191  

:::::: The code at line 165 was first introduced by commit
:::::: a879058d01e2f6e324cc98ff2ffbe4f574c100a6 ACPI: x86: s2idle: Add more debugging for AMD constraints parsing

:::::: TO: Mario Limonciello <mario.limonciello@amd.com>
:::::: CC: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

