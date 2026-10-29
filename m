Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D37D606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 09:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=aAebMGHm
Received: by kanga.kvack.org (Postfix)
	id 996E16B05B6; Thu, 29 Oct 2026 05:49:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9479B6B05B7; Thu, 29 Oct 2026 05:49:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85DE96B05B8; Thu, 29 Oct 2026 05:49:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 608836B05B6
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 05:49:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E144D14031E
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:49:46 +0000 (UTC)
X-FDA: 85375191972.19.D11C3BD
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3CF6340002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:49:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aAebMGHm;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793267385;
	b=YVYLzVsE0Wc6M1+usI7A43SVNg9VxEa+2rKy1gsoGn/bCPLDYZIe2rcSNDPbDVUYwnEQQi
	5AOcM026TbWHmlqsquXXvKjE7CmU9n5dFje1YiWFWFdmNXVu2UmNIXQKxtmmSldlbuGvxb
	bXjTO8axobtny+E2/1fI534GSZN6Pik=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aAebMGHm;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793267385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=Ip6OodyYgPxE8i09BPkUuXD8qFekO1thWPUvSkoK3J8=;
	b=e0oLYfPDEj7830SZx5+LBViI4VINj1T/EU0I1A3YNbu6wfo/58X54GittLee/qK/kZOVP/
	S3OfO5QY9YOuUGxMbQQKrIdANhGWki8w+BEdI9+CdXU9n9sL5kYr3ceKtwVQ++BsLb3Bcw
	bJ4cCz6KfcGfE2CTEeQ/IFe1TL74/J8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793267385; x=1824803385;
  h=date:from:to:cc:subject:message-id;
  bh=Dq9NImGikAuV9Umk8V6qIF4lVM1M/yT467NQ5v6qDPA=;
  b=aAebMGHmD+OozBWspkZhYSinSCA/W2CG7pMlPJtgA6tx/HVWS+SEntKv
   oTOnwGteEalqPmfQVFReKxYxb/MzQ1ktey0FlKr79qo95YELMSrYFpR8c
   MPttnESsueZlOz2vz+ZF4cGjVtiPuygSbluf/5Og19bJjJdybQZosenHF
   XoYCz1vDuJJJI9+hHXwm5mwfJ9KvPEYUBdBFcNk3uTemsqJVS/rVr+8qy
   RReYye9HE2RLVYqU80ckZsGPZpJKW/oBqgEYyV6ckvYcJP9Ca/eZx0IyT
   gTrqSEqPyeZ4Z0MFv89Z9yBW/wr0FheeliAKJv10wm9Nj50MoFiO3Mub0
   g==;
X-CSE-ConnectionGUID: PPYMGnaYQsyWtFckCtbyJg==
X-CSE-MsgGUID: 8FzPGbruR2CkcN06C5RjiQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11949"; a="2008844"
X-IronPort-AV: E=Sophos;i="6.27,184,1787036400"; 
   d="scan'208";a="2008844"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 02:49:43 -0700
X-CSE-ConnectionGUID: S4hyHfXDRx+gLYzdF+BIpQ==
X-CSE-MsgGUID: pN/2Iq8UQaeYqceB1AlvWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,184,1787036400"; 
   d="scan'208";a="4977246"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 29 Oct 2026 02:49:40 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xMMlO-00000000Zuy-1PSC;
	Thu, 29 Oct 2026 09:49:38 +0000
Date: Thu, 29 Oct 2026 17:48:57 +0800
From: kernel test robot <lkp@intel.com>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Suren Baghdasaryan <surenb@google.com>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: WARNING: modpost: vmlinux: section mismatch in reference:
 dump_buffer_page.isra.25+0x194 (section: .text.unlikely) ->
 initcall_level_names (section: .init.data)
Message-ID: <202610291727.DXytMLtV-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: dbqqh9wndt5idqudppfrr6pewreyx616
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3CF6340002
X-Rspam-User: 
X-HE-Tag: 1793267384-4647
X-HE-Meta: U2FsdGVkX1+WAxmV/IOeiRCSc9Ix3SKZRunZk0yxwBWQwgea5hKEYfZ0ReR0K1TtJR/7wIeNU2hkDG0D01mN3K1QpTQkB3vmuns6VXwz6t0a4A8X2sofZ+KZwhPwkIKhVq39afBCzW36uyUV4kC8Jo8Mq/5CVIzR17wlj+HJEn30oN2NafxnCCNHo8VcEF2o837htOQtzVCUJIfZZ7nm0lzL05vjeWYIuiHch2iemFx+6uux8bRBM/zscqG/msaY6BIuH2KKovGG6/bcmPVmPA86eIj543+2NMNdfB753FKfRQfHJ5QPBmBqz7YJuGkyik/5h6TDNmKISKGSMzvqAjF9PZaoPc3M13Nq/JSQxzACQQeyjoutZK6E6wJyLfNNnIkUTmz51vegH/7RtalqASvASlUd3dbZ+3fhQ75OZv06AWaajAkjg5Z7GGNsCW+nkqSmi6vGcqTZyYG8IBh71kcP6xqbPEI8N3qdrkorrlIo7kyR9+o+oACtE+PwdlpEfINeIXj4Ff8H3KJBM0XrwfXBjnCq+b8SGRMSFLJanqedtDxU9+PlNslMLAvtHkNwLut4Mlm6JRLX2prsGLRbFvLsUPGLle9Xfy1wkl1kCcUz1uUJFbbx1PmnCUaXIf89f0k/DypPqd0+LGEKE2c6JtbKL1Cx6C9VN7ZQI2vjlFeD2MfXQYVPbjpFeUhprrs3kKVADy6fdG3ZWDSXALYUtM10IuePTvBHReLMzcV67+rEyoNSim/nkMALVeAzX8hOEClV7vma6hk9Zec2qt47VC1gsSHh3cTNmbhpuyFXzGth6zBJHwYRrnd8QXH0my3xkRJWIvcNABgqawUX3VurfpUFwd5YK+Dx/QaZItiH0rigol3Vjhsapt2bJ3rcro8KgOsrVbtYfLek+3AK3wdnb662IUURDCWMHsj5MFOcopam4qreI8kRbjhRjJ6vT9nG22BXeQ+vIkf9frnNu+Y
 NSLaZD69
 MUCjrbdSG3R2y3pM6KdgYr05XpR844LmWWojHM0bnbsrTNXprmemv6WRVgHpBXe5T6CqkIWwsM8O7TS3LPfwmH43imZLl7et6Cjh6gcqEqNDtKxHM9a+E6C0/bXkpvMQOjEbBIKidrVL7GbtPNKjIcKS06dvWL9DizEpF7D3muqa2fSc1nrMjc2f/a30nvAM6XsySHf/obVQa6byIHKgmlN158RNqPwiOMA0EhZHcKg0h9OwL535/rjbpT5QDDx1sjWwnUfWcDxOIcRrOPcTLdbArShgpYhzaXhDRR0OpB7Pqx6i+BXDeiNpFl+ny/zuHsVoCrtk4w+/bJdQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   c339f4010dea8b0d754f84ace70cd1b089878ef8
commit: 47e725702b0b7c01d4ae4ef231df8f63e5f305d5 mm: make per-VMA locks available universally
date:   3 weeks ago
config: xtensa-randconfig-1001-20261029 (https://download.01.org/0day-ci/archive/20261029/202610291727.DXytMLtV-lkp@intel.com/config)
compiler: xtensa-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261029/202610291727.DXytMLtV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Fixes: 47e725702b0b ("mm: make per-VMA locks available universally")
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610291727.DXytMLtV-lkp@intel.com/

All warnings (new ones prefixed by >>, old ones prefixed by <<):

WARNING: modpost: vmlinux: section mismatch in reference: trace_initcall_level+0x3c (section: .text.unlikely) -> initcall_level_names (section: .init.data)
>> WARNING: modpost: vmlinux: section mismatch in reference: dump_buffer_page.isra.25+0x194 (section: .text.unlikely) -> initcall_level_names (section: .init.data)

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

