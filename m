Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05461FD7061
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 10:11:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E9466B0088; Tue, 17 Mar 2026 06:11:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C0EE6B0089; Tue, 17 Mar 2026 06:11:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FE4D6B008A; Tue, 17 Mar 2026 06:11:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 503A16B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 06:11:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 113EA140646
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:11:04 +0000 (UTC)
X-FDA: 84555136848.23.6BE70FD
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf30.hostedemail.com (Postfix) with ESMTP id E89468000F
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:10:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=c6ZMSQnB;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773742262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CbIrrb6ufDd7rBS9NF9eA8JjM0Du/wpUeFVgdK38yT0=;
	b=Tlvl9LeL1UCBsL+LaB6fRDQ+FxQ36BuXcErIkcSiUkgKlbwNglK2U/9Z72N4nidgTaUYRb
	IiapbK9dZi0qXuqzWW5tuHpuIhYx5/BRXuEHtMkdXy/i2hf+JvQHJwFFnXUhg4nfALR+Vf
	eDOdZRXjVbNCDR9FkoTMTbXhWaq2aOM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773742262; a=rsa-sha256;
	cv=none;
	b=l0aRbofLBFQU7GmQcgx6RBpcfNLv5PnxoE0eYSJVoySrnUbdGjGr6qFI0VLmbVQidVUNGC
	2iSg3iyNVcMktoF2avVtQCAgMcDgKCoyk1RdVtSp130GqdwSRRyMAWC/HwNKwyi+q4ZyXO
	dYv0xEGRKIbj7sSptqydh5NbtbcYiiw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=c6ZMSQnB;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773742260; x=1805278260;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VS5shox7xBvFAPW1FpL4joq45+qOo+6vqaHAWgVWd3Q=;
  b=c6ZMSQnB9Qu5zZve9uRcxfq9XAconooq84SceCQ4yPDwsR7g8aOQ+/Dx
   d3gjHbdSDfHV9UZx8fqcQNXvYCAD6jkBk5o0/Kb3SxP/5Nemnncjc6w/y
   6Rm1WfLmru5WomhEToNC2QEPHht+KtZnyR/Y8zp8Pk0JVBHPolzt7isMG
   9JxHIplKOu78TGTI1RL7jUPKFoV1B5ZE1ozj6/onWExBPOO1bkFOJ4E+W
   lVfh1k/B8fv8QMQXX69KZuVEyFsjolIvv+HuAGOIpTfzlvnX4MSQPZ1OL
   xJHwwV16gqSPkpvCuKNeOgzVmaNz4G0fbrC7piDZ5y/SEXdg9F5tLBCFp
   g==;
X-CSE-ConnectionGUID: RdyT2zCiQLynhYcNv+kmjQ==
X-CSE-MsgGUID: aCSEKaVySxaKzD6ihX6Hug==
X-IronPort-AV: E=McAfee;i="6800,10657,11731"; a="78374853"
X-IronPort-AV: E=Sophos;i="6.23,124,1770624000"; 
   d="scan'208";a="78374853"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2026 03:10:58 -0700
X-CSE-ConnectionGUID: KnOA7o/fTAmQ9TxZsvp/iQ==
X-CSE-MsgGUID: M5lclK9vQk6eBLUT04UBjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,124,1770624000"; 
   d="scan'208";a="222275712"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by orviesa008.jf.intel.com with ESMTP; 17 Mar 2026 03:10:56 -0700
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w2RO1-000000004Px-2zd4;
	Tue, 17 Mar 2026 10:10:53 +0000
Date: Tue, 17 Mar 2026 11:10:27 +0100
From: kernel test robot <lkp@intel.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, rppt@kernel.org,
	pratyush@kernel.org, linux-kernel@vger.kernel.org,
	dmatlack@google.com, akpm@linux-foundation.org, linux-mm@kvack.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 5/6] liveupdate: Make unregister functions return void
Message-ID: <202603171111.YBKWkKnp-lkp@intel.com>
References: <20260317025049.494931-6-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317025049.494931-6-pasha.tatashin@soleen.com>
X-Rspam-User: 
X-Stat-Signature: 3yfn5ek6dhe4c14976iae3fx1gmwfrfj
X-Rspamd-Queue-Id: E89468000F
X-Rspamd-Server: rspam03
X-HE-Tag: 1773742259-780278
X-HE-Meta: U2FsdGVkX1/B5F6i5zbywG7l5FUJWbdwCOBCWWJAjFR0DTrVlTewzIVEyK7PtVNK8QX8e4qLrJeWR8HWtwH/pXsKtwf9gd97PQDIJPMJ1BIqLG/xKF/g7wS6oByp8NDzD57mX9x6MNI5dJj77Xf022WOaYECJZIgouCIOsQt8LoZqxsv8bbCc+LF8905QonJv+XpQnbuZjB99HM1+2WEtBkEAPdjeEw64XA3AKVi7TjwnXT9k5Dkl6Yyiu1Ve5lBgDhQfpSr8IOJJ739MIduM6DE6GbKXc6Zbo9h4qChRsMQStjt6jQ370+qoLWKM2Yoevlv7Da34iGdweyOPmL87//6Ug2ni6mNxErDd2FiBcypaEKaAfjxUWZCTXS1ld15jt+8KV6jWtBQkn4xCX/svRn54tPCHpCTvGIt2J+UYQfp8349gGYXoj+w0J3YxYYnWTLLPgvvZNccvcZFQMVaiXvPwcc1fUstqhoJZpGCYpsezdH8dpnTCXungg91j1gFRC89XyDBg0RMArnaD9guXS/+zaJKtHvPlqrHz8hnY0VGjkKsK6fp+KIixglaLVDFCBgzvMX+urTrSMlhfA8Ic11zdnq9l0EKA7n7rGRmI1fA/jKFDRE8JFndaVamUFaH2GWsf//5F3SMmSXiyrZdCMGAAgSbJnLcmTX3N12gbbS4zW3OCHybZLsVbGFCgSySdRioLAjSYZWcmsX0qvRFrz23Rx+90cS3OAKg4LSDaoR9SrItRJ4pYjzD135h7yUHolhGYf9HOMuUPLDs5Hq7EDHnZwnCCLWXf4WIMOtcduBXVyoC/SeXUxV6fAYWorOAo5cJHf4tFU2m8SBwBSu0DyHDZFAcipX1r2J0VpLblC+kP/RZluLJymolfM0fZj+1DbIVvbcbGmqLyM79uAPVM77Y2RMrIcDlE6/fEHhENOTOIeynNuixhFhYKwzWlVboyXRzWyrl8IvAkGR0Jy+
 7gF4fPRj
 UG0lKMCTF3RDCtMJWHIZCO79e3IJX4K9praloIkaLleNDMpFG95sOGdAp7GDSBsUgBI45YtlzZ67S8JUGqvUGkuHpgwOlcYfuVnGwwUske1R9on1MtozRW2jhYGhajTZOCOR6Dyvr4KrqMLVMDvBQ9zCxoHFs4URauMr4bviExoALmwbdoyfe6LE/N7PGRU7KI/fmcE500D2ax6IUusD2u1IexBqRmKlA4uppJ+vi5ARgqTjGxxS9gXIanyjUPAkr+N6hThWOYw60hsTnUkAgjghWRrRUG+8nN2cMPze5wR3BsmKAEQimtjARHqkkREfcpDFDMgN98+eg1BePAX7l+IBGHMr4xgMJjPB+uT8jNBrh543FHYR/v6q1sW7tXUMW9dryn4As1UeWfI0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pasha,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-nonmm-unstable]
[also build test WARNING on akpm-mm/mm-everything linus/master v7.0-rc4 next-20260316]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pasha-Tatashin/liveupdate-Protect-file-handler-list-with-rwsem/20260317-105522
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20260317025049.494931-6-pasha.tatashin%40soleen.com
patch subject: [PATCH 5/6] liveupdate: Make unregister functions return void
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20260317/202603171111.YBKWkKnp-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260317/202603171111.YBKWkKnp-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603171111.YBKWkKnp-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from kernel/kexec_core.c:18:
>> include/linux/liveupdate.h:274:2: warning: void function 'liveupdate_unregister_flb' should not return a value [-Wreturn-mismatch]
     274 |         return -EOPNOTSUPP;
         |         ^      ~~~~~~~~~~~
   1 warning generated.


vim +/liveupdate_unregister_flb +274 include/linux/liveupdate.h

cab056f2aae725 Pasha Tatashin 2025-12-18  270  
e62bd1ab0687a1 Pasha Tatashin 2026-03-16  271  static inline void liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
cab056f2aae725 Pasha Tatashin 2025-12-18  272  					     struct liveupdate_flb *flb)
cab056f2aae725 Pasha Tatashin 2025-12-18  273  {
cab056f2aae725 Pasha Tatashin 2025-12-18 @274  	return -EOPNOTSUPP;
cab056f2aae725 Pasha Tatashin 2025-12-18  275  }
cab056f2aae725 Pasha Tatashin 2025-12-18  276  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

