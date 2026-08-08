Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EA9EC5AC67
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 05:05:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1606D6B0092; Sat,  8 Aug 2026 01:05:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 110E06B0096; Sat,  8 Aug 2026 01:05:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F41D46B0098; Sat,  8 Aug 2026 01:05:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C94386B0092
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 01:05:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 478BEC02A9
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 05:05:28 +0000 (UTC)
X-FDA: 85076913936.05.AADDE8A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4087C180002
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 05:05:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=J2vSBn+G;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786165526;
	b=3b8avPrKgOeTbv+LhwnaFUhG0d7mbw71n4F47nQxfr9UL84WT6/WVE4KunQEbpRNHzYWu0
	k3ZmAII0k1SmIFRiAFkUSgq5h3QNiNAKnDkFoCeI32h2a4C7k1BRJpRnVXZYkGlhDhknL3
	jNJgjuP6++7Iz3njitJm2wfSv4cUYyM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=J2vSBn+G;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786165526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=lREXa6NJkH3gbgLFPs8yF7LdKYT8p4bqm2pjkeAU1eY=;
	b=xjlOqECrnGQWrHGQgadZsQbngTuuRJ7YFweVCj2g4nMrmn0gwrW7V+/xA79yiG41Wt5ImB
	Ylaah5zzpfx4QFtkSbgY8PkxZbYBBCEYYyJ/QFdDKuMRTaQFHB+Hcu928rdzbi6H5nKKqi
	FWHUTzxl6cuQMDwk7xCjzzKQLE0iU7U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786165526; x=1817701526;
  h=date:from:to:cc:subject:message-id;
  bh=6B3N1/5IRBJpDREMgs/waSzl8Xh4YUOv6peGHCsD8jk=;
  b=J2vSBn+Gttd43NqVesXjnih9QYpTz9qAoUtCyeLl5eZR7pg1i23zdwia
   bEtryX0axgfw/AHCwBSzsvPlgjGsNQoJBeEvMzoW5mlGukF6tveEUbcN0
   +ri7kjWHbDUB7O45p/H1X0fj1stle8WoFBz3FlOZLGk6Php8vx1f+GzjT
   Iv5i1CcvCu17IfaNML72NTaNfM3VtxY3Q/NuP7QDWPxs6b51wO/ES0qlN
   R+Pu8eT9BVXQbyMhMBUOumH36uxDlX1qudzahv3Gywve8lYxrz9b4Gt9M
   fcJmUWOObfpui4eRURaai9DnVfPgYWLGeinfrTBpYo8d0pCwbH5b8LqEs
   Q==;
X-CSE-ConnectionGUID: 3cdyMcTGSvCruJDmTKrQvg==
X-CSE-MsgGUID: 0yENxTHGS0SAKdplruff/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11868"; a="86648531"
X-IronPort-AV: E=Sophos;i="6.25,211,1779174000"; 
   d="scan'208";a="86648531"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2026 22:05:25 -0700
X-CSE-ConnectionGUID: 0yqSsESbQJOf5n/SCWl6zw==
X-CSE-MsgGUID: dQVzWeQOQl+MzlATYl1XAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,211,1779174000"; 
   d="scan'208";a="259955690"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 07 Aug 2026 22:05:24 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wsZFK-00000000Jlk-0F5Q;
	Sat, 08 Aug 2026 05:05:22 +0000
Date: Sat, 08 Aug 2026 13:04:37 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:for-next] BUILD SUCCESS
 b3c1ec1a9ad84ec2f14d343d28c6032feaec5b79
Message-ID: <202608081323.6Q10LJEZ-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 4087C180002
X-Stat-Signature: 64ra4a7zrgoeubrzrmhoq4jc5341mu7d
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786165526-450723
X-HE-Meta: U2FsdGVkX1+7bwVjJVaYBTqGEpMrQQlb/A2TRrNSegAJy2vTaD2tdA37Sj6Z2eJceVJxbs2z4YfkXt1qes8HAqUOCfwqyAUVJCQgjZSYUKmi0vv6181DO/2nAlA5lB1AyT+eP/+ufBqn5b9q0cCR87u+HvBDYkLfr9NtVeo0xrJg/kzXDTBEpykuYlMdswNwsn+u5ixb27TJhZAyvrb61Y02CpIsiO6DoiJj4EWG4Hs+c8zHdWekr7u/WALtOOY7Xtm63ANR31IS3Q6HNaBt29F21JBBu50aXMaQ+wxBv0Ik4Vhp+KEmN/e5W4UTEHde7/dAKLP+YXzbU/laHphiAUzK/QctQxNeNIL0pDZhlsUvZ32B+50AebOIvix2LgZQGFRNynccqwEl11/p2vMewa3XZmwm64xRGuYcFkLzKiBlsyELJ7R60CnItLSkdk9gbeeqkHDh4KpwsMykorRzilEJbSwYVmSQmh0Mvm42eNfrWstlZNVZzIDjtPqD7Oqq9dk7TafSdaWUTxzkSadxB8VxyqSHGnXcR+cwqMUfXqyI7NgLGB6PwQs2v2j+6j/8vYKZpoDuQyiP/x30r076F63o6+0uiJrSxjL6QMT4tw8LCmATFAUYeVxujq8L/ETEqPVHW1ZSmOPZHCpgbb1YjfhIxJu2O+P8CL4TcKxCm+ku/lu9KzXFvF+gexP9ugN9jIwbniJs9/okb0noHazp5Ry1Zztn+BjtNLTw8HJtjRs0uuWC7nXXIRzKZVl5JFRi1xOZFM0C5+cVRMIJdaB8Oeb6CdBYVebCGGywKnEy6JOufBkPCBAHa6aYwA5UxVj7S3W1BYxHd60nTC84WhiKvpjKaQNz/mVxeKIrnMuhREkBQ+8YB9hD25OpxS4bue5vE/pVxxcGW6P3mZsx+Hauh5P1NxgbihPTiG4ghSZyYus5vo3bJV+KgGkyPRfqkvTxBXnAUbbfJN2/V5u7FWD
 rot+kndK
 8m3eT38oxg+un191RwQ6z3Idh/8mu7PUYz8DtV5P1vkCYI/9kR8wsVin/Ad/GsUv9M78oK/p7vx4+c/FSuwyNToxp79YKN+QQR6N5ypAT8OCwzauYB4Y7OQK1W0r23lhvNmQ1BW4WK2wDeodltew5ACrzIvc+BE6xt/QsHAJss5BerQwGjcEOdVXj+uu7gdFSjdaavsKMeS9QdeE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
branch HEAD: b3c1ec1a9ad84ec2f14d343d28c6032feaec5b79  Merge branch 'misc' into for-next

elapsed time: 815m

configs tested: 14
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha            allnoconfig    gcc-16.1.0
alpha           allyesconfig    gcc-16.1.0
alpha              defconfig    gcc-16.1.0
arc             allmodconfig    gcc-16.1.0
arc             allyesconfig    gcc-16.1.0
csky            allmodconfig    gcc-16.1.0
loongarch          defconfig    clang-24
m68k       m5407c3_defconfig    gcc-16.1.0
nios2           allmodconfig    gcc-11.5.0
nios2            allnoconfig    gcc-11.5.0
parisc          allmodconfig    gcc-16.1.0
parisc          allyesconfig    gcc-16.1.0
parisc             defconfig    gcc-16.1.0
sh                 defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

