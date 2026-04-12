Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CEA9E937EB
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 15:40:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59EC46B008A; Sun, 12 Apr 2026 11:40:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54F936B0092; Sun, 12 Apr 2026 11:40:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48C976B0093; Sun, 12 Apr 2026 11:40:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3A5A66B008A
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 11:40:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8DDB2BBF7B
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 15:40:52 +0000 (UTC)
X-FDA: 84650316744.26.4C882B0
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf06.hostedemail.com (Postfix) with ESMTP id 50A6E18000E
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 15:40:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jeAW82S+;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776008450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=c1on5qHl5nnm/EBthr6F8e4IvvqXEBorfSHzTvTvOCs=;
	b=E2rXFlT2j7jnX5Z+/odKHy50FsgV9cJGwFvkCD2M/zOAm7RH7DYc0HZLxDAzYKr31x9mlr
	JTHl/AgyUuCS66fNsjLRYhKh3QUxQ6AdCW9z/pFTQMf6GQFsIXm8jXjTgbBOmXxv/0Tgq+
	nSAwsKP7wZGASUH4Bh8agULCy+JTiG0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jeAW82S+;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776008450; a=rsa-sha256;
	cv=none;
	b=77Cbs/SZLgy86gDlFBohGT36JyRtJkwPjLIM0ljIsQua9kaY+eos5Ih8bSxxyCfQLA7FJ4
	vTHO1oc14mxk/Dt7tVg3IJVR/Ze/SFV2eb7Q8w4oAsHro4S/aGjiJF3VCxojAPR0hRUKXS
	PtNr66fE2rGrC84b1Pxi8f0ioo+5Oy4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776008449; x=1807544449;
  h=date:from:to:cc:subject:message-id;
  bh=2SXjVI14ZsThwYxKe309NFLF/l7Aooi7q7Up6Q5jhOI=;
  b=jeAW82S+IvT4vZsAB1ATcFl5RwEEgYtSBoExI4serjm3efm3Q9l60Rje
   vwcdDvPtwmmpPBn5WQAeePDGRmEzkFy3DEUPSJrspBD7Mut5HGqAdPFGZ
   uU9Krcqu+0MpVRdK1RfyBWuAd68apmLYAvCCWW5zpUgACbMWkvR75YPve
   9poxKxYPpsymjV9SHljh2ee/vOSN7hhat94Ng5QKnf/CT1QEYUdWDgZZ0
   9gily87lpglbH5RYahOXnivv8kEyPIGODRnryrjNwfd0EtdvgbeAcSLuN
   6MXVthyxJUUNR4jcqbhnUf6NEMnKI+9j6I17TUpiTDywCAUd6yGwld6uA
   Q==;
X-CSE-ConnectionGUID: eVcwPowfQQy7SYxgjrbNMw==
X-CSE-MsgGUID: 0xXOQH5HQRGheQlVA0uwZw==
X-IronPort-AV: E=McAfee;i="6800,10657,11757"; a="76842594"
X-IronPort-AV: E=Sophos;i="6.23,175,1770624000"; 
   d="scan'208";a="76842594"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2026 08:40:48 -0700
X-CSE-ConnectionGUID: wZ4jkVHpSBCDNocVgzgpfA==
X-CSE-MsgGUID: WC/U3EicTciZMBPYN/IyBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,175,1770624000"; 
   d="scan'208";a="252966833"
Received: from lkp-server01.sh.intel.com (HELO 3eaaf1a74b89) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 12 Apr 2026 08:40:46 -0700
Received: from kbuild by 3eaaf1a74b89 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wBwvU-000000002Iz-0I9r;
	Sun, 12 Apr 2026 15:40:44 +0000
Date: Sun, 12 Apr 2026 23:40:04 +0800
From: kernel test robot <lkp@intel.com>
To: Sasha Levin <sashal@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master 13066/13443] lineinfo: warning: 1 entries
 skipped (offset > 4 GiB from _text)
Message-ID: <202604122345.DimxLkoi-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Stat-Signature: qoc9htwtb5c449uew9badp3h8g1y1tye
X-Rspamd-Queue-Id: 50A6E18000E
X-Rspamd-Server: rspam09
X-HE-Tag: 1776008449-66823
X-HE-Meta: U2FsdGVkX1/BwJ4R86tUdm9gF/LhpsQwmZh6cj729hQ0nZIeWxxjs9eBiUdZllR/3/51LaIiIDB5+B1Emd7hObtQ4gSiyj+//G8GPGZ0NM/XHtsmo5rCSBYWoVUaqojaZYLHB+lw6rmMUtrKWM5bfbW+SIfE9QmdOUjTZ+5UxR7ikB6cvUdCbsnpv2GooN6R2KclZJbO0oe/cJR3ZqNQNEaPRMlGMo/7Co66OS8CMAtOz69v3KbEt+2HbdZ2UEpX0H867i/nTu4ckNIQKoCIAmwCgiZm/hn94AAim1fPnctlfoXoJ+GX7itvijPA39SHSLngR7ymyljr2KyjM/r7IabKlnF42DkZB7vE+dRaNgKOBcSJ/zZEU0JOeBhP2wPmNJgNfjcHSGvdrD1a7rQsiU9+SFois7iCHlcFjMd4odgLU4g+Es8sa3hIkZaTT1lkibP5JYHERigMjOpt+nfqG/qjM2M1hfc97mx/Uvy8Al2nQ2+a/0pYtuVmFSouMmqXWgv6LjvOHWOzbISNgdEDxcKxgBsLEKpMpWc3uralsnYHBMhLvAHB+WV1jQppz28oeiLpMXU+4QFgvErlg4E2I46SQkrsXu2eGmE5Kr3abXhzKxYMH+j8Sc0+npbKV0kIk9iN28qzKV5RejJTW993KHJ0wb968+bhGWMNsIiRt/DUkjKtHCJ3Hz6mw//d7BSYMc+tZ5OWz4EpTkeof+h7t/E+cB3xheewfs22hbF8CEqfKy0qNAni/QFHoHGZbOp8JBoCXa7/3SACOGN+7iVgTrDi1IN/oVmY39R27IjK5rQO/4chJBIpEaQ5zj6PhgUXbkV63MkQxPx6exCVRkU38/IDp0EKFtTWZjyLYFrQFJ+P8OVkMzqGTyBfh3c0jcUDaLclq9LMH718aaFvIGEPDJah9hRZFFZjY4QnwVXPM+pWFv+iC16WWMUdRiy4dERdWc4O1fW0gSh+FpXxJld
 M47qV4mR
 eX60IKFREVYPvjTF1FbtkdTN3YSeKxiIq2HOwbu6DY8WFRY7HsclKFtBhQw2wsZZ4nGklNNPbmWNpE6hIit0kMk16T9YiVe41ARL0yjXi0wWvckYQkJPEBrVjBedW+j7YGPrswm8y7AMybbqOkD9JMGSMWmn9OcIJi1A3MJ0La2ftRVkoGbMUA3aKc7N1X+xQkFQMde3qW1O0QIT2W3FWvZKYUcHophr1b0tBu76tzcpwcyCFjpFqRF9k/psh1tR6v7b6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   66672af7a095d89f082c5327f3b15bc2f93d558e
commit: 8ecad477a87264cddc375df914a2cb634cedbea1 [13066/13443] kallsyms: embed source file:line info in kernel stack traces
config: arm-randconfig-r132-20260412 (https://download.01.org/0day-ci/archive/20260412/202604122345.DimxLkoi-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260412/202604122345.DimxLkoi-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604122345.DimxLkoi-lkp@intel.com/

All warnings (new ones prefixed by >>):

   WARN: resolve_btfids: unresolved symbol bpf_session_is_return
   WARN: resolve_btfids: unresolved symbol bpf_obj_new_impl
   WARN: resolve_btfids: unresolved symbol bpf_dynptr_memset
   WARN: resolve_btfids: unresolved symbol bpf_arena_reserve_pages
   WARN: resolve_btfids: unresolved symbol bpf_arena_free_pages
   WARN: resolve_btfids: unresolved symbol bpf_arena_alloc_pages
>> lineinfo: warning: 1 entries skipped (offset > 4 GiB from _text)
   lineinfo: 1219549 entries, 3779 files

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

