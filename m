Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B969EDF17F
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 08:56:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79C5A6B0005; Sat, 14 Feb 2026 03:56:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74A206B0088; Sat, 14 Feb 2026 03:56:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61ED66B008A; Sat, 14 Feb 2026 03:56:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4AEE26B0005
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 03:56:31 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C343E1A02A6
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 08:56:30 +0000 (UTC)
X-FDA: 84442456140.17.E39176A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0CD99180006
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 08:56:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=L8cQ8Ft6;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771059388; a=rsa-sha256;
	cv=none;
	b=N9uDrIlAuR1vpVA1BDQ5s/OhQGq47gOS81GdWh7OnfG8oc5vJNZSXMNbCNhFJm7mwmwa1m
	yLGPQNOt0V6Az+SjU+Lq3Ra8+EqH9eQNCIZ3liZRqBe8Jj241YXCOfnf7DfHvSN8aCW0tz
	Zh/FvHqCiPEToHhns8Ubi5dUk4L//mQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=L8cQ8Ft6;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771059388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kMICv4TW/Vn0XmVwnlVyL+Leis56gTmqBtftHS2J++o=;
	b=4c90Bl1+ebMGvD6Vnc0E7n0XzttK3QeOcnwuplt3fKxIXIPJDyF7UyPh7YdFPygfjVxTfa
	GN02lKeMeDSUs49AMf7oksiRA2+qRTEafs9ew36h9WSaJNbEL2TlHmL1FQ0lOfdJ4f1ny1
	0FqHckBnosD+B/mhIzQdUj5XsyeypmI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771059388; x=1802595388;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FmU6sN6VTvK2lk9nkffJpXX9j+KGsN9TIxoBy1pLkF0=;
  b=L8cQ8Ft6K+y7qFBR12j9KdwjXkhWq2erdfi5swSGA3HVUNJFbJywPH01
   0qTvRRCodjNEgHHS1uM0D+Sw7YwlNrW/WIts80sLOTSTqYVGqdUDgHm+X
   Aa7522T3t3nAZZhu8NTa+owBtT0W8r2d9J14jiRJDzvqO61EBX5WOTBGx
   u+0RU+wxQQxpsyApVYOqocJYz0pSAchVul1SYC50Ln0kGz5X/k4RQcc3H
   NFrJGT4qmM4lKL6Stb6xGUVmPPzEQ3C54WiKv1bsVwFBjEPk+HeJ7VaI4
   LDtLgToHSvn3e//R/ddpC3Bh/cE4mlCmo1bphj7+PNW4XGN8u160BJfkZ
   w==;
X-CSE-ConnectionGUID: umLW3MvUSLmaDvQnurVNBg==
X-CSE-MsgGUID: 3T0wzcSnT8GOFLVKZO4yzA==
X-IronPort-AV: E=McAfee;i="6800,10657,11700"; a="71428990"
X-IronPort-AV: E=Sophos;i="6.21,290,1763452800"; 
   d="scan'208";a="71428990"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2026 00:56:26 -0800
X-CSE-ConnectionGUID: N824LeOqToGHpVGW64sH6Q==
X-CSE-MsgGUID: Qhwja1+kR8SCKwHr/L7Utg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,290,1763452800"; 
   d="scan'208";a="218110063"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 14 Feb 2026 00:56:20 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vrBRp-00000000wPI-1UDK;
	Sat, 14 Feb 2026 08:56:17 +0000
Date: Sat, 14 Feb 2026 16:56:15 +0800
From: kernel test robot <lkp@intel.com>
To: Amit Sunil Dhamne via B4 Relay <devnull+amitsd.google.com@kernel.org>,
	Sebastian Reichel <sre@kernel.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	=?iso-8859-1?Q?Andr=E9?= Draszik <andre.draszik@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Mark Brown <broonie@kernel.org>,
	Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
	devicetree@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	RD Babiera <rdbabiera@google.com>, Kyle Tso <kyletso@google.com>,
	Amit Sunil Dhamne <amitsd@google.com>
Subject: Re: [PATCH v6 5/6] power: supply: max77759: add charger driver
Message-ID: <202602141606.igFDFWAJ-lkp@intel.com>
References: <20260214-max77759-charger-v6-5-28c09bda74b4@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260214-max77759-charger-v6-5-28c09bda74b4@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0CD99180006
X-Stat-Signature: ux5btedidhzifia5rkoqr6mt49xawytx
X-HE-Tag: 1771059387-14573
X-HE-Meta: U2FsdGVkX1+aFrXU1LS1OCr+idWoz29VajKE18nSMzv+7nrqtGrr3Dr+BsL+VE/9go4K3ZLvKGq2E/6nWlbc7so3vpCO2TCbBQQdOLnf0lGoEayMwrdGswyL3edjaoXg/xw35rkfARknyy/OJqQbcHfZKbw496zy6VbBigJkDcLRSV/ASjdh/vAJ26MFIiJ4836D5B+oQFqQMwjHH4wBDgY3l5LlKpFKZnBTztsJe6wq3OefFRA0CSOTp4iIT9+sTO/3RsGqLNw6NghHAhYgo3lhnqKKS9DfsAF/0t00S9neyAootlj2s8JI6hp1w3fojz1ZozHbTyOSYfGuK5XVbafO3NU5legF6dJGdTWJy0GnD/sLWGlLkeHLDthZDJZJYt5Oao9cYwyVcbOycGKVWZPL19Hixa5Xu9Dlgsan0qwx9s6tNzl9OA9rmSB5jMYOg2MuUHjrjhTdZg8Abpu6AvnWJyxQNXpMhd5Ohe+BfAP1KcgUlR9SZdFjWtmtKIGtlIzkvatMwvtqEO5pSQ4HR0K9BCoXh0DMkHgHIrVNT1MGsVJEVIz/V/KKIQWoH5tLH91F92H+7Pw7ZH1cPx/lNPShIivLHNxomdlULuJP8eFHFLcEadMfnlFHC5sa5JY0384Ep5rXPjznTj6/5jWQS2cmxyzhtz7Q5O329mni2N6Waxt8d4RAyvEtXtQRlpnG2BHo5gvkTrp0vMc7MagtZqkmvMBDRZRB1mS2cXLW8lOBdIrgDVZ85peYpyq7IudZvxMU1eNs8o0fik3xZLe2HFk+qmSR53wwipmB7J+SXyzNgQw+m0rN22HP8gFciQE6RV4PGt4Tv2993fnSjOkNMG3ohL8vQ75ENwdPGv31MO5owUHs0d4PF8eix5xzh1N+w4C+00uKYfNvz7YRUpsdd0UaoMWAi0ZCcI8Glvv32VSQqrlA989KRTLamBGfcQ7c1s9U1L6F4vcDSbv852O
 5CBQB8nn
 kZgDEyJ2VOOJsEiQaPikb7FO5ObZiRKXmQrInRK0Jcy3NRagksKwobHRf6W+HNfeNhUPai37n9xvjfhXdqIBATxUcVEm8OX8johngKQzlCcc+Jnvll36LRNPg/DN7xcg6Cb+h/Md3DNUTxFTD1PPfMetvuyHdlUvTajKJp7PzMMuAtQk3SOD2vLufrV0WvfQHKVIJ+TNmNczN2dZPMYKz31uj75t8EbfbZEKBzJHBu8/yUgPzVVx8abw551u9fBU3OyHYGXtPzVdPEwB8HWIL0pd2H0PVyn0QSBVEqAupjbjwDxIWNGdLDjs/JnzzoDQ/R5nhmUIRV28P0R4KNxRivJVOFATvfnGbwF2hoa5C4mIXrPSuyFB/RFES8B5oYrGxHzjZS/h0nUWBN8ybPV2Xr+HW4CVnUYz+R8dS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Amit,

kernel test robot noticed the following build errors:

[auto build test ERROR on 8dfce8991b95d8625d0a1d2896e42f93b9d7f68d]

url:    https://github.com/intel-lab-lkp/linux/commits/Amit-Sunil-Dhamne-via-B4-Relay/dt-bindings-mfd-maxim-max77759-reference-power-supply-schema-and-add-regulator-property/20260214-111637
base:   8dfce8991b95d8625d0a1d2896e42f93b9d7f68d
patch link:    https://lore.kernel.org/r/20260214-max77759-charger-v6-5-28c09bda74b4%40google.com
patch subject: [PATCH v6 5/6] power: supply: max77759: add charger driver
config: powerpc64-randconfig-001-20260214 (https://download.01.org/0day-ci/archive/20260214/202602141606.igFDFWAJ-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9b8addffa70cee5b2acc5454712d9cf78ce45710)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260214/202602141606.igFDFWAJ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602141606.igFDFWAJ-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/power/supply/max77759_charger.c:623:4: error: cannot jump from this goto statement to its label
     623 |                         goto err;
         |                         ^
   drivers/power/supply/max77759_charger.c:631:2: note: jump bypasses initialization of variable with __attribute__((cleanup))
     631 |         guard(mutex)(&chg->retry_lock);
         |         ^
   include/linux/cleanup.h:414:15: note: expanded from macro 'guard'
     414 |         CLASS(_name, __UNIQUE_ID(guard))
         |                      ^
   include/linux/compiler.h:168:2: note: expanded from macro '__UNIQUE_ID'
     168 |         __PASTE(__UNIQUE_ID_,                                   \
         |         ^
   include/linux/compiler_types.h:16:23: note: expanded from macro '__PASTE'
      16 | #define __PASTE(a, b) ___PASTE(a, b)
         |                       ^
   include/linux/compiler_types.h:15:24: note: expanded from macro '___PASTE'
      15 | #define ___PASTE(a, b) a##b
         |                        ^
   <scratch space>:18:1: note: expanded from here
      18 | __UNIQUE_ID_guard_461
         | ^
   drivers/power/supply/max77759_charger.c:615:3: error: cannot jump from this goto statement to its label
     615 |                 goto err;
         |                 ^
   drivers/power/supply/max77759_charger.c:631:2: note: jump bypasses initialization of variable with __attribute__((cleanup))
     631 |         guard(mutex)(&chg->retry_lock);
         |         ^
   include/linux/cleanup.h:414:15: note: expanded from macro 'guard'
     414 |         CLASS(_name, __UNIQUE_ID(guard))
         |                      ^
   include/linux/compiler.h:168:2: note: expanded from macro '__UNIQUE_ID'
     168 |         __PASTE(__UNIQUE_ID_,                                   \
         |         ^
   include/linux/compiler_types.h:16:23: note: expanded from macro '__PASTE'
      16 | #define __PASTE(a, b) ___PASTE(a, b)
         |                       ^
   include/linux/compiler_types.h:15:24: note: expanded from macro '___PASTE'
      15 | #define ___PASTE(a, b) a##b
         |                        ^
   <scratch space>:18:1: note: expanded from here
      18 | __UNIQUE_ID_guard_461
         | ^
   drivers/power/supply/max77759_charger.c:606:3: error: cannot jump from this goto statement to its label
     606 |                 goto err;
         |                 ^
   drivers/power/supply/max77759_charger.c:631:2: note: jump bypasses initialization of variable with __attribute__((cleanup))
     631 |         guard(mutex)(&chg->retry_lock);
         |         ^
   include/linux/cleanup.h:414:15: note: expanded from macro 'guard'
     414 |         CLASS(_name, __UNIQUE_ID(guard))
         |                      ^
   include/linux/compiler.h:168:2: note: expanded from macro '__UNIQUE_ID'
     168 |         __PASTE(__UNIQUE_ID_,                                   \
         |         ^
   include/linux/compiler_types.h:16:23: note: expanded from macro '__PASTE'
      16 | #define __PASTE(a, b) ___PASTE(a, b)
         |                       ^
   include/linux/compiler_types.h:15:24: note: expanded from macro '___PASTE'
      15 | #define ___PASTE(a, b) a##b
         |                        ^
   <scratch space>:18:1: note: expanded from here
      18 | __UNIQUE_ID_guard_461
         | ^
   3 errors generated.


vim +623 drivers/power/supply/max77759_charger.c

   591	
   592	static void psy_work_item(struct work_struct *work)
   593	{
   594		struct max77759_charger *chg =
   595			container_of(work, struct max77759_charger, psy_work.work);
   596		union power_supply_propval current_limit, online;
   597		int ret;
   598	
   599		ret = power_supply_get_property(chg->tcpm_psy,
   600						POWER_SUPPLY_PROP_CURRENT_MAX,
   601						&current_limit);
   602		if (ret) {
   603			dev_err(chg->dev,
   604				"Failed to get CURRENT_MAX psy property, ret=%d",
   605				ret);
   606			goto err;
   607		}
   608	
   609		ret = power_supply_get_property(chg->tcpm_psy, POWER_SUPPLY_PROP_ONLINE,
   610						&online);
   611		if (ret) {
   612			dev_err(chg->dev,
   613				"Failed to get ONLINE psy property, ret=%d",
   614				ret);
   615			goto err;
   616		}
   617	
   618		if (online.intval && current_limit.intval) {
   619			ret = set_input_current_limit(chg, current_limit.intval);
   620			if (ret) {
   621				dev_err(chg->dev,
   622					"Unable to set current limit, ret=%d", ret);
 > 623				goto err;
   624			}
   625	
   626			charger_set_mode(chg, MAX77759_CHGR_MODE_CHG_BUCK_ON);
   627		} else {
   628			charger_set_mode(chg, MAX77759_CHGR_MODE_OFF);
   629		}
   630	
   631		guard(mutex)(&chg->retry_lock);
   632	
   633		if (chg->psy_work_retry_cnt)
   634			dev_dbg(chg->dev, "chg psy_work succeeded after %u tries",
   635				chg->psy_work_retry_cnt);
   636		chg->psy_work_retry_cnt = 0;
   637		return;
   638	
   639	err:
   640		charger_set_mode(chg, MAX77759_CHGR_MODE_OFF);
   641		guard(mutex)(&chg->retry_lock);
   642	
   643		if (chg->psy_work_retry_cnt >= MAX_NUM_RETRIES) {
   644			dev_err(chg->dev, "chg psy work failed, giving up");
   645			return;
   646		}
   647	
   648		++chg->psy_work_retry_cnt;
   649		dev_dbg(chg->dev, "Retrying %u/%u chg psy_work",
   650			chg->psy_work_retry_cnt, MAX_NUM_RETRIES);
   651		schedule_delayed_work(&chg->psy_work,
   652				      msecs_to_jiffies(PSY_WORK_RETRY_DELAY_MS));
   653	}
   654	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

