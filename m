Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5558ACCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 14:44:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61DDD8016A; Tue, 28 Oct 2025 10:44:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CE338013F; Tue, 28 Oct 2025 10:44:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E42D8016A; Tue, 28 Oct 2025 10:44:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3CF3D8013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:44:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BDADBC030D
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:44:10 +0000 (UTC)
X-FDA: 84047793060.23.B5C35D9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8CAE3120006
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:44:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=An+Zqd66;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761662648; a=rsa-sha256;
	cv=none;
	b=gXmQMUloNmgSvkX1FUyQAfpmMqwmC/NDAPdgemrHSxza+iMLMYEMXTv2szfeXSnIdn2qKL
	u1XBDj+qtwBScJdV2BrZFKjHpMQph6Tg9HwXn/ogCRfL77acFF4FnNoOTssEioN9ZeTxgk
	SnEvJ2srPyC5fW318MNE7fNQC3VKDNo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=An+Zqd66;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761662648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=aMaPSgtiIkXN74/+21i5RXAJZTQVebCGb8wY9MOKc00=;
	b=uNo86zN1k6r4z+m4JbyQ8DirXLo0bG5QRcLd7VkusidOGyiVYh486iYVVEH8J5YR4PY7bm
	bulTeR5Ee+MNMi7Z9P3axVTkAKD6D5T1uRQSLh8fCYKbtNHcehOOJFA1sqCy6rPWkPZ2Dw
	lGDWFdsonX7i1K2XWOxtwRSduZWFevA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761662647; x=1793198647;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=i+/55yq8l96pCeA4jXotYrENEKRas3j7JLXo9bI31oc=;
  b=An+Zqd668CGWbxjiLea5jOD8boSs5URIN0lI72nguXo1ie2kTe+tBirv
   +RhVWYikSeQqo/1IAe618IG7+5S+WCLsRG7tzjBRlaQAGhNSyScLMgwh5
   iOPnskS/84T1NjrbaaQJ1PSGtgdDgmeffqSZ4mER2g5hhdnKYzi88i0Im
   YjGsBUJE058fV1aFZfLor5o7K63M0mKUi2Wq44Fx9e2O6ERtUDpDIOmYm
   AvuAFhd/vwbpoazRzIs2fpOvYW4CdmGzCGxrbiX4xtl5lxzPWlbo97amd
   rClDpt23MqtW8cwkccXllbKNlEVedm8JCU7DarjBcFNl7bzDKjovVw2M8
   w==;
X-CSE-ConnectionGUID: FcTaTyOxTpyiLGUjDsM6Eg==
X-CSE-MsgGUID: KQxT8LtrQAG+PAKtR+4Acg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="62968670"
X-IronPort-AV: E=Sophos;i="6.19,261,1754982000"; 
   d="scan'208";a="62968670"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 07:44:05 -0700
X-CSE-ConnectionGUID: v4soSnUuTDO5AemsuCRpww==
X-CSE-MsgGUID: HgJ9Jq07TTCqrSIx/wv4bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,261,1754982000"; 
   d="scan'208";a="185254463"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa006.fm.intel.com with ESMTP; 28 Oct 2025 07:44:04 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vDkvZ-000JFn-1o;
	Tue, 28 Oct 2025 14:44:01 +0000
Date: Tue, 28 Oct 2025 22:43:29 +0800
From: kernel test robot <lkp@intel.com>
To: Ye Bin <yebin10@huawei.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master 4143/4376] drivers/acpi/x86/s2idle.c:165:51:
 warning: '%s' directive argument is null
Message-ID: <202510282238.oRKSLKUV-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8CAE3120006
X-Stat-Signature: p4tdxhozwb664wszpktrtdqjfq8dsigb
X-HE-Tag: 1761662646-112238
X-HE-Meta: U2FsdGVkX1+MfQ7MmuZ0km7YQ/NhGXQcP1VmGRo166IAgTxaK/uBv+PMfRG877PeVWPeORgdK/bZy1MjDcXgGr9e+OfpT/Q67DsbbOZpaw1E7jTtSDZv4dyv4JtzdJLUHfymvRflM+3WjRZkwwjS4GeNowb9slkGJ4mniCxyLYnVGl3Ex1v3sth2G/MqfjQ84YnizjkzPLxEktWkmj9EM3truwpdyTQe9jw0iAcog+2J3rnOCcoSvjCw3kz+hLdi7mLdc0gGIlemBpp9wew/oheLEKeOwcsn2+KPdnGQE2yMlu1UPCtOo3sgkbQqIX8vYGD5PVUxFPWn4OliHSpU1YydFui5ZksDO7YBx31Z5Qw7QYyLrrQQ6svCF4ueG+h3oldOS1A5SsvmOU9+RWxL3YIZ+n5pLGQtBvliy9RFPNCYPBoKFXfUAugOMpGSlni4vg+zVN15YQzHVXzuTdX3znWeYOA4vEK1DaaX2pVjseQKNz201oCzZl+yNi7CHWNFc5jV/5wrT4JNZFHfBNnB8VVixWhbeJsDvCX1rh3SBhWFYk9ELYnkMX0qi83dTK0uvlYWoWJni9YzQvMVPx6/HO5Eb9FIiZ6ru62OjpueVFbXZvV+3pesGw5kgbcZZYpbGB1uDxP/torvj11nBdGi7qnK59JMIwZ+twYrpTgFAg4MTUSwQiLmIz3WEl7oxbOHNrLLzbOYr3g2IKduQ5BPOWx0MkOI+HV8CyY+H5WnN9yzHEyj8rkxbNRbDRm/yQmvARitdyTuwmRS1yQ/Pl1Op5WqKKoAIqSzhbhYJHLaRAut7hwkWbo2beQt2dDUgp/9XOtgyPt0Q8i9br1nmus8+l363riQKppnniklAkVJKlTxbvFXbd7+8FkkAMugWw8mpo7bc6CwqG/4ikPmgBK9AXXA5m6GYIF1lJLWnLb40QFrdvGvahy1k1DgJMkErO0HVOVv1QKwr11Bzat/lLO
 ne4Tv0bx
 7lYqMb0JJqtlcjcOzYMS6Oj1DL2skS14z1AVieChXojDsRrN1WFDYdg4XckKR69QsJ970OOKb7u+/CdgXLUTK6QVa9mR9eL8I0Z/SYbMIwQn7eM+boa088uiaxPT6BggGmvzyzLAqLjTzuHRgNBIqnzOdiPKTGfCqnw8e5k71wMNdpJTjpFI7L58MvEvddS6ib5DH7WKYeGkUGxKyd4qjDAZbFV+D4MWUeh1cmO0tnpTitxfYqhZX4sd0Z2XfPTTLwRMDwXqDWU7vAfxmyecUGsgeINYuCmtGiSuRjvfWpIYe7DloU3VrRZ0Wu0giAHin49bsK+ZNXiIIT9X/b4uQrgyLP5/wzhD4nGTu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   f7d2388eeec24966fc4d5cf32d706f0514f29ac5
commit: eed2866c987bf054b9a1ffc0acb89cdf4d422c73 [4143/4376] dynamic_debug: add support for print stack
config: x86_64-randconfig-007-20250922 (https://download.01.org/0day-ci/archive/20251028/202510282238.oRKSLKUV-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251028/202510282238.oRKSLKUV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510282238.oRKSLKUV-lkp@intel.com/

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

