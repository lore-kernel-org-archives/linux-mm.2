Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4AD8FF60F9
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:27:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 071196B008C; Tue, 31 Mar 2026 05:27:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021F96B0095; Tue, 31 Mar 2026 05:27:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA16D6B0096; Tue, 31 Mar 2026 05:27:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D7C9C6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:27:46 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8BE83BBC4A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:27:46 +0000 (UTC)
X-FDA: 84605830932.14.C0983D1
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf06.hostedemail.com (Postfix) with ESMTP id 61BF4180011
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:27:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=e6DcgIwU;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774949264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=cqrHbLvMINXpjDcfcVaDnrsqPLiAW5xmVuWZWarPWsY=;
	b=G/MPDeAf8xPR7s8lZS/wq39KZs7XI89P29sofDDnuIKmx8A9mFEGQbQXMUZAqMeYEeDXji
	zdd4LOV2felA8szl3uHY0IW5GFS3dx7x0kwgx2kxD35KYzimZ/vgpLH1oTEf/5XBo5dsgp
	/z5DKNvGR1AG7RGZOV/U/hVqwm49Xa8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=e6DcgIwU;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774949264; a=rsa-sha256;
	cv=none;
	b=xT/GDxiGBmP9WMXqyMO/NUjwsbjMX971kyRHl0k7fAqy9wTT+iEDc4DjLOCzHqofDXnOUx
	ZpylBKrXOVNmcU2+2XXLzqPaepXuNKMrKUfzYq4dVBU17tFCvwKgGUSqWbKXTlmcr+8IGS
	EtEzBV26VQRqRMOnOGIDT3bXoIm0aUc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774949264; x=1806485264;
  h=date:from:to:cc:subject:message-id;
  bh=WDiiMJa3TfFF+i8iHPr7Qv/bRTJnJrs0R3RCW+c5Sso=;
  b=e6DcgIwU5XC7c4vlbw9l4fiNcmZUsRAJo2U31+78Z8WMN3JuljtcXl3B
   CZM7UeD9VZ3ieTi+IicdmLpl6wZt1LLhwEIHY9c83FrGtX5EW5HoG4Gyc
   s5YWidGiCfx88L4E9sY0y6kyMqo1Ycm2EhAgURPu5O3S5NwezWuyuhH1I
   bRvNZz3yulPjC0cwC0fcHeHlw3C8sLYKsNNRNz+dXH0UjdtjwWXUBK4fL
   9h9si9PxUAbFsgjGXz3IQWev8acELhCWQMW6bdg7s+bJIhg5x48LWKLGs
   LYbK306y17rbIEFk5xxDpgC/dUFWyLBrbJC1BRolHEDUdN1riNHU+PWmw
   A==;
X-CSE-ConnectionGUID: Q1229eORRQWW0KaH6IGUYw==
X-CSE-MsgGUID: +8+t3xicRceBrbzD8jDuVw==
X-IronPort-AV: E=McAfee;i="6800,10657,11744"; a="63509028"
X-IronPort-AV: E=Sophos;i="6.23,151,1770624000"; 
   d="scan'208";a="63509028"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 02:27:42 -0700
X-CSE-ConnectionGUID: VMVsWeLNSCO74nzLjjOsbg==
X-CSE-MsgGUID: ogdCg1EqT1Cd7KGyOi/Ycg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,151,1770624000"; 
   d="scan'208";a="227920969"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by fmviesa004.fm.intel.com with ESMTP; 31 Mar 2026 02:27:41 -0700
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w7VNr-000000008LJ-0hfE;
	Tue, 31 Mar 2026 09:27:39 +0000
Date: Tue, 31 Mar 2026 11:27:20 +0200
From: kernel test robot <lkp@intel.com>
To: Chunyu Hu <chuhu@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-unstable 121/130]
 tools/testing/selftests/kselftest.h:427:13: error: implicit declaration of
 function 'vasprintf'; did you mean 'vsprintf'?
Message-ID: <202603311105.ysUeYPSZ-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Stat-Signature: s7o9sn5eucjqzgf59ejeqhhrhgwc9ujs
X-Rspamd-Queue-Id: 61BF4180011
X-Rspamd-Server: rspam09
X-HE-Tag: 1774949263-404691
X-HE-Meta: U2FsdGVkX18w+CerVwBsxSElSYVAIfQBHH+L3fL99DlJNbymjul74fB6u/z/J/4mOiWDAfKwNppg6TcEivwmAsdj2zbgejf8tLfJlPH4Y3tDMD0JjO3iEoEJqaL4geoLp2sGb5mqq35a9AE4qY5kLb+jpqOFhlmWwyijPp6UQITSqu75hTIzWFBh8BSPiEycnWNej1B2cPoIIXgGEZpYnsSexe66Tzs25PE3cEV84XSfM89UCrwIcZFJ4Htfajd8eBMzQruVyBWjydvbNnRM/HQxGrBx0nmAURq9wSiL0VWyhsUzdJBR1gOfGXa3cR2GJePQOg410ZeBMQj1y7A2O9O+QUqZSJIHSvLweKUzHUnnHqfpNtcfBIeliwQYL720RP+8Fx5w/GhulQraj/WA4aAdRcVRTlp7Myc+iCVwVqtM2dbXEBFOx1pd2tw9By5MvyiW66dqhWEr9WCcwtd5kIwcIlA96dDxD1sThMoMAtoAYP5HuCoVUAvasX0wRbpk5FVrMvmhwo/89Sx1Bu0h1NwBV4HDlhrV2vEfR9ywvt9T9BBDQlmghkznUEppZm7x7lXlLNruq/iyRHPWazQovzuaAGhTjsH/xE6d6jLjR6+lktme0HZGV7oxmfRLn0PLw+zUaVDOtUqsPKR/hgUfhhId01pgePeD5/h1qdVAEY1DTOQCZDNREG+J3I8XmBYnwHcrenLac3GqwecOPjAVDQ0HA4PeYcp88UdOZlMGdk8YmeZ1Xy0aavisihNUgVHKp1Y9+jcc5h5D/SO+NCURxygUaX4ckGCnYYlArCH646R1ECf0tQRGwpfPs+AHn7wx/t+91XIt80TsoLqR4wPNzY0Vflqud0GSxgMkihBaIH4slpQ2a2XndUi7jDDw5Hcje5S3Vpfy9ZPgEw2pgvDp9wT336nGmzNEKJtVKWdYI5upH1sQPYpXMUFWh/lz8HoJ/fCGYbQTCBqOkFXODso
 BUq2/Kqc
 5jas064XS5q/ZV8tDUcrvS7M6Ysbe/Z5VU3BCljtFWtzUmnygsPiG38yzYcmToF3vAISDYJFBBeRekJSvGzC5PKchgIYQSOpMzI/dTlwMvaCQtfkUMzNTwu/eSRLSc9LmSOhpwoR8c3/8CnEXtM2MWX38+Kv6kwpuBxvcXdH4jRyeJ8En20GjqQdHdRDEXLYuKCe4KdCyS3I3ZYlYF6N34hOuXEJM0OdFJo8iJeCqenGqTr0D4yQNL5/QW3ILLKTcOy04ebgP2ZwUXAtOKChtX0M+BnCYdoPmMbnI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   24e341657c283c965e3bfee0baa9ed0376127973
commit: cc0b04b10a7b98fd8df2fd539177e94e0f83a5c3 [121/130] selftests: ksft_exit_fail_perror: support printf style arguments
config: arm64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260331/202603311105.ysUeYPSZ-lkp@intel.com/config)
compiler: aarch64-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260331/202603311105.ysUeYPSZ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603311105.ysUeYPSZ-lkp@intel.com/

Note: the akpm-mm/mm-unstable HEAD 24e341657c283c965e3bfee0baa9ed0376127973 builds fine.
      It only hurts bisectability.

All errors (new ones prefixed by >>):

   In file included from za-fork.c:12:
   ../../kselftest.h: In function 'ksft_exit_fail_perror':
>> ../../kselftest.h:427:13: error: implicit declaration of function 'vasprintf'; did you mean 'vsprintf'? [-Wimplicit-function-declaration]
     427 |         if (vasprintf(&buf, msg, args) == -1) {
         |             ^~~~~~~~~
         |             vsprintf
--
   In file included from basic-gcs.c:16:
   tools/testing/selftests/kselftest.h: In function 'ksft_exit_fail_perror':
>> tools/testing/selftests/kselftest.h:427:13: error: implicit declaration of function 'vasprintf'; did you mean 'vsprintf'? [-Wimplicit-function-declaration]
     427 |         if (vasprintf(&buf, msg, args) == -1) {
         |             ^~~~~~~~~
         |             vsprintf


vim +427 tools/testing/selftests/kselftest.h

   419	
   420	static inline __noreturn __printf(1, 2) void ksft_exit_fail_perror(const char *msg, ...)
   421	{
   422		va_list args;
   423		char *buf = NULL;
   424		int saved_errno = errno;
   425	
   426		va_start(args, msg);
 > 427		if (vasprintf(&buf, msg, args) == -1) {
   428			va_end(args);
   429			ksft_exit_fail_msg("vasprintf failed: %s (%d)\n", strerror(saved_errno),
   430					saved_errno);
   431		}
   432		va_end(args);
   433	
   434		errno = saved_errno;
   435		ksft_exit_fail_msg("%s: %s (%d)\n", buf, strerror(errno), errno);
   436	
   437		free(buf);
   438	}
   439	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

