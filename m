Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59A98FB5188
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 04:00:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95CB76B0088; Tue,  7 Apr 2026 00:00:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90D186B008C; Tue,  7 Apr 2026 00:00:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 823126B0092; Tue,  7 Apr 2026 00:00:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 710EA6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 00:00:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E15EEBA45B
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 04:00:44 +0000 (UTC)
X-FDA: 84630408408.24.BDD8B80
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf29.hostedemail.com (Postfix) with ESMTP id A8DE3120015
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 04:00:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OBxiGZG0;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775534442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zhe+pnDxki//VXYby/7B+HiopyizJ8dOdWA43pSzcv0=;
	b=lNKJacMAHYvxL3+SZS2RSHWrjUHrd8+1ZpYR9qtR4lDBJMQhnWt14D3/qXdNsWm+k1zeme
	Tig8979qjjClLSffEW/FBWv97XPLZE/sK+YjCyObRtk96xJsMXm3HDTfHnD2T7D6qwp9pl
	IuGddseQib13FYpdWUY5QWIH/IiPxO4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775534443; a=rsa-sha256;
	cv=none;
	b=JuwmRSgKJ1ylsA3uaAHiFWOCyyLcVkDwqGgCZ0hTBu1Bm0uaCTKm4X3GUGDeTt+4+Gj4Wa
	i/i1RtzD3OWTCmZQvwWGaH2x+98XxAp5btXeBQ2p3kHTXNSW9VsPzBFSD/kMunEIGnVks3
	NGcNL/VCbelUkzz2Rq7VP4niOKV/clU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OBxiGZG0;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775534443; x=1807070443;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JqFdJQvh+85MPvdIPOcWvJHfvP/feCTUskARF7qj5uI=;
  b=OBxiGZG0Coa3pIQCeXunlI6Gnqgmk6KUg6ID0bhb2ZXmx/GUGdG/G1jf
   imDqV/UN/Fi5IctD77St3Hy6qtamFVW1lVBjG8gBEdKos8kiQCadYeb5t
   1F/0hi2/UbJEyBkniupJR7sVcqawh7hviHj9NOsOJcHApnKMZphi35Gf7
   lNbzdrzp0yI5Y6xnx9cvIAdJUtyDvmb8JX7uwr5fJb1yGJ34N0DzdVTp7
   hQwcDm6WFB+lbkEUweisrD3UFsIh4LD7BUedJnmIdV/jE2zseky1VxGLY
   Zj3KU4JTW/OHgqKTe6Nx7L5v0JPfFetYYefPafRfvyuH/mmKlJycMn6SE
   Q==;
X-CSE-ConnectionGUID: zgZVAbGTT268Ietw6ewIrg==
X-CSE-MsgGUID: fzWwyI3VRJaz+YRy7kGjuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11751"; a="86782279"
X-IronPort-AV: E=Sophos;i="6.23,164,1770624000"; 
   d="scan'208";a="86782279"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2026 21:00:41 -0700
X-CSE-ConnectionGUID: wDIAC8YER5KdCC0LiDS5wg==
X-CSE-MsgGUID: +3YWodOqRAGptbgPT5PLSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,164,1770624000"; 
   d="scan'208";a="224844901"
Received: from lkp-server01.sh.intel.com (HELO d00eb8a6782a) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 06 Apr 2026 21:00:37 -0700
Received: from kbuild by d00eb8a6782a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w9xc9-0000000007F-1hKX;
	Tue, 07 Apr 2026 04:00:33 +0000
Date: Tue, 7 Apr 2026 12:00:22 +0800
From: kernel test robot <lkp@intel.com>
To: Yunseong Kim <ysk@kzalloc.com>, Kees Cook <kees@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, max.byungchul.park@gmail.com,
	"kernel_team@skhynix.com" <kernel_team@skhynix.com>,
	kernel-team@lge.com, Yunseong Kim <ysk@kzalloc.com>,
	Byungchul Park <byungchul@sk.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: Re: [PATCH] lkdtm: Add folio_lock deadlock scenarios
Message-ID: <202604051743.4BM8o6lT-lkp@intel.com>
References: <20260402143947.162844-1-ysk@kzalloc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260402143947.162844-1-ysk@kzalloc.com>
X-Rspamd-Queue-Id: A8DE3120015
X-Stat-Signature: au7mjwmpj6fqsqh1ope46ma4tfi775po
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775534442-406042
X-HE-Meta: U2FsdGVkX1+Po1rK5qDXztZF1859g8DyWTHzw9L5hmWKoPYVIbmkn8ILYOo5aS1Motz912R22ZU+dmKg0wE7GbEw4U4D7Ynrxw3w1weCabEjQvWSiumY6/sXHpjf90lid+04UDgQM8D0pBOpTsx3yJCkB/XaloGgiGZxJteuNzwbWycatPtMRtJY8kE/0ha4cAown65KuhQQkzIQtvNB0zoLoAJyv2HeKF0GT/TKpzZU5Rd+rZVh1v0NbntEEBEu1RWY8wnYPGmp1pMUDlT/k7dNnzvmcIXeW487s+w89wVpuY04vYU+2kiHIC+lgJMW+L4Dv1ZCUOcMDYvVV3CPvoK3t8FlxUmu/hnEu7X+AF8zhy3AzQ1Q206iXxnuKMxrIApkQU4AfoR9EBX1tcHom2xFwqHmiMcjdKXkTbHpaAGI+D9W4mH7kzIvLQ+UOJNRPDFQcuJqM63u28napRxWYlyQkHJd9xn3Me7ZbZ70PY6v4pj2zyoxOyOMKiOCFtwsY7XCgxnCMz6SJneZpG9NJZNEh2Og2Q3hNiN8xFhh16qTChqjbujhPbjjDo0Ydmq9S37Zl0sA4YDbKm3vBKSkjhY1HcQ9PiRyrbnopkRqb2ugMqRCllzmfTws9Rzzuk1K+arOq7/VwbVe6SXyJ2Brxq03NIEfmOhbRhDSjSCstwFkQO6M2H7a8lNeokD57QZsWGI881BV6ebx6/ehWi+AdKIzJvoNf7ypNUvQ0hxIlb/nHwJeviGMCKgLqiLGTbmeOH0weUi/lZAojpjTp+h2t/EKc7NIAopKs6pFHi1qVTureg7ky4Em5cS+qZmuhbj30Kykbz7L6PiQHb5CwKogMKR6Ccnvo/DZQTRNCmQExbQip2uqYi6YHh774gMBahr7bdn5ybrwdynZYz0BPTt9k3zpHxOxMu2laC/d8u8z4h6DpI8aqmaY1EHW+qLLdYOsvBLiQJiJSjbnwYTEcrG
 dcHkru/i
 b1oebpgLpQtcaGGWOKaN1fWMhgJIaonHjEgDbid+ZAjbQFyDESfFbgVEQmYEbRxlmCiUgvipMW+KXbf0bUsQDvsN2w5zpMAsDgsyR5B/i6gL0kNAgAP0xRa+Bkvyp0lHJ9hWB+ZA5au/+w52GtF4z1W3x1ldvutCzs06LymZKBxoYgl7E2USa6N06AlCS/tvz3x7e1FoUzgle0BrW1z6i9v9/cA9/9OpB5F0szp1gA10HVK1Qi9C7VeIIqQ0fe6Qo4Wr9SvEompWh9fj6nbHwhplVdJlux3tbW2JwlVHIaZyj3MmS3BL87kTAylNu0v/fqIWTpssPIDdPYXG3A/6QrvAwm3B70O4nG8YSSATouaKDNX+/QouKsq3Y2hUV/pNlFVPHv2fmS7pvY3E/zzsGiCgKO8H7dktpF2RjuQ5JW4ACSXrUIwoc2NiS5meW0WMK3Uzr0he63SCWNec8QQQzHTIfScuTq9rCnbZrrx3bAoufFUmW9Psp55vXdaKAxwoVA0MFVoDqI/pSE+8LcKu1m0QVn9NKvLSQdN69wD8LE0JN0/vkjCdBW/PP/JWugbN2We5x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yunseong,

kernel test robot noticed the following build warnings:

[auto build test WARNING on char-misc/char-misc-testing]
[also build test WARNING on char-misc/char-misc-next char-misc/char-misc-linus kees/for-next/pstore kees/for-next/kspp shuah-kselftest/next shuah-kselftest/fixes soc/for-next linus/master v7.0-rc6 next-20260403]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yunseong-Kim/lkdtm-Add-folio_lock-deadlock-scenarios/20260405-145013
base:   char-misc/char-misc-testing
patch link:    https://lore.kernel.org/r/20260402143947.162844-1-ysk%40kzalloc.com
patch subject: [PATCH] lkdtm: Add folio_lock deadlock scenarios
config: s390-randconfig-002-20260405 (https://download.01.org/0day-ci/archive/20260405/202604051743.4BM8o6lT-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 14.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260405/202604051743.4BM8o6lT-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604051743.4BM8o6lT-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: drivers/misc/lkdtm/deadlock.c:228 function parameter '' not described in 'lkdtm_waiter_thread'
>> Warning: drivers/misc/lkdtm/deadlock.c:228 function parameter '' not described in 'lkdtm_waiter_thread'

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for OF_GPIO
   Depends on [n]: GPIOLIB [=y] && OF [=y] && HAS_IOMEM [=n]
   Selected by [y]:
   - REGULATOR_RT5133 [=y] && REGULATOR [=y] && I2C [=y] && GPIOLIB [=y] && OF [=y]

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

