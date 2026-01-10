Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2B46D277C9
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 01:04:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 411296B0088; Fri,  9 Jan 2026 20:04:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BECF6B0089; Fri,  9 Jan 2026 20:04:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BD836B008A; Fri,  9 Jan 2026 20:04:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 186B36B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 20:04:08 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5123F13C52E
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 01:04:07 +0000 (UTC)
X-FDA: 84314257734.03.AE4C453
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf30.hostedemail.com (Postfix) with ESMTP id BF30E8000B
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 01:04:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lkNw2Wfx;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768007045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=ia/zGr4zK2tSXh/eQUyGt78vFSsoQ6cgD77qMzz2GuM=;
	b=LZR2X3IbKmCdZjXWRvm/0SPKmXoA3UC+Carwmp6KT06PoU/m+/brb4PrMkKlmKOf49uQOl
	6hFl30Ci4udOG6wwIHvorkVURepV4IX51957yALUq6RDzV9WjUcClDnYR+b91E/iWf0AWG
	g/Rkugok8hgMYkSrILDE9AjTHDvvQLk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768007045; a=rsa-sha256;
	cv=none;
	b=GoZyRhN8fdhadY8kFLPcxmK/ipwBX+fvGTCDL/EXiEQa9BEPLPG0ukE6zfizspPrmOru3t
	RqHhmE4uJY0/gdUHZAAh0jzByJ1pXhEcWVAqkY2sZz2BaPGgRh3UWbC8Cq6WLCgD70bmN3
	QRLH0+2vochFDIlpsPU14v530CeorOQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lkNw2Wfx;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768007045; x=1799543045;
  h=date:from:to:cc:subject:message-id;
  bh=j6KVbHQs8FIdO2Qtc0Sp4iOhfIJayw1AX0HpbB9e20M=;
  b=lkNw2Wfxt3fonfCSOGKWgT2oTZD72h4wYugCqrH+FzD3OhHNOkjRsca0
   zl+4FABPJPgpCOvEst2tyFmMdrT7ZxUR8tABZd0bS0/Xpa7tCr5PkM1K3
   YlDBOIds1Z5y77fzG2Oc+3X6l26RHw7lUflsGCaEZrAUJsfKT9sbd2pkG
   L6emE+I38wV5Imh7Xem8fZU3EOVq4PzAAi247VOH4mWPcIo2Lh3UHkUIJ
   CENXTAbFEgssr+UkihoNg66nvEC8JYmNIF9J9Mnod/ZYDN2KJdkXeJeR/
   qOkrIQNo3OvcHCFqCgUbQbphxGj4kCYm1ezoSZ67RBQo6sEG77WO/4rOa
   g==;
X-CSE-ConnectionGUID: tsxljKeHTVyWnaB1aRFYxA==
X-CSE-MsgGUID: wdtONaTETeKJ1+6zDSAjZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11666"; a="80755814"
X-IronPort-AV: E=Sophos;i="6.21,215,1763452800"; 
   d="scan'208";a="80755814"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 17:04:03 -0800
X-CSE-ConnectionGUID: SNmmDZSfSk+D5LuIffXhgA==
X-CSE-MsgGUID: R9UqJAKMTnajVrB/5fZaCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,215,1763452800"; 
   d="scan'208";a="203893315"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 09 Jan 2026 17:04:01 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1veNOZ-000000007uL-0Thb;
	Sat, 10 Jan 2026 01:03:59 +0000
Date: Sat, 10 Jan 2026 09:03:04 +0800
From: kernel test robot <lkp@intel.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Brendan Jackman <jackmanb@google.com>, Vlastimil Babka <vbabka@suse.cz>
Subject: {standard input}:26675: Error: operand out of range
 (0xffffffff not between 0 and 0x3f) `l.slli r21,r21,-1'
Message-ID: <202601100812.QjhXvtfv-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BF30E8000B
X-Rspam-User: 
X-Stat-Signature: a9cff9o5fofb1777dg9fwww154myottb
X-HE-Tag: 1768007044-861809
X-HE-Meta: U2FsdGVkX1+vIfeurubVKA8X5uWHYPjJcmvMe0GX8FGusYSq6oixOpl4lh7DRzSu4HtZx1NsO4nEfYZFWSFI8cChGPzkHGEQbNRdUzKhHl/CMcLqWWbKr587ddV4ubeCe2ohNTFNPVkp/Q3X0AKOfZppmdLtzOIx3VOYJ9YkJccU8FAXs45NS3+g1Bo4qLe/dKJKhHcTFFkfVAoK7P1+22ICJw/9tzg8kKKrJR2Wfou+RFCFe76EX1farLM/zdxIlDCIJg0y/XiviZ6iHGhpKDq9qmXuIEb38gTe0hkV7pLM9/4z5hi+7rPu7RsSccI6gbIPa+5HIpG2pQKWTQIZpQj167TQTLJgDb1OIk0EW5B9MEXOZ7nKoPuaC2rd0RLMYYgrXX6zBS38ZQuvxyZDk3WmHN87dZPqZRw4Cuj9UX8htFpFU+CysdyMQCZ6iVziXV6o35Fr4EJkuuXw2kaBgDN/5dZXYUQsl2vihzwotvVASqHPqR+eLi7fNeIasr5blR6cu5Yt4ym1RVFzHMUGHewImgAPPHDur5k5wWwmoC53zzT7r+5n81u8DVYM18n938RGnq54P6GnE0t55KEbiBoRmQmMoYvfiN+2aJjuk57OmfSsUBhDCamkOWnmt/jF9SAqs2vaEBoudBWCa4VG0+A4fCA+Uod5eNr0zWwE061IY+KeifD1U8QNzUQVjjKjJP5V/3Qo+6/RY3wq7K+BOMnmcfjcATkVyCZw0nQyYyGoU8VKbxg0N0CFKsyImWpct+oF9Zj1a+qFlFvPVZ5WcWvnxdeVeO4mY7ZXAaRtPs5IJo/y5yrkzbTlZmvc/bz+6OCXxE5MvJ9GstMqrF/AqL60uPcEtmIF2XXxCTH8ZtBdoD3V0R0PImekgIMsH01Oafln0ra/80CpnyLUpxEtEmaFy4TAmlJpEER6ji8nWk5QXxDdjkWtJ7PDTfh8cd37HCDP4LagDt7W3DsZPHR
 UsIfUMHo
 tARt+T3uTsx92LuuzjDPB7jGFZyfsZuiXwr32zTDCRw1b8vBZ1vYHNR0w/HhszhXTK+/8dA3g25yJys/McvQXpflZ3X7YGWZHDn9008E5nSTdhWWFQUst5rq1QcQg6gqqyxBYmf7N+CcROe7AakMMlvALbGYFHwkHhZsNGVwMgX6UtFQQcGeDL1/wINPl04lMKARFze6liY8pudMkxxwnNB1t5noZ3rc/4MRih7zorrdaQ9j/6KCTDZY4jwDzzF0AAvkhItjVOo4YUFQGfq6ujtnFVA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   372800cb95a35a7c40a07e2e0f7de4ce6786d230
commit: ee414bd97b3fa0a4f74e40004e3b4191326bd46c mm: page_alloc: tighten up find_suitable_fallback()
date:   8 months ago
config: openrisc-randconfig-r063-20260109 (https://download.01.org/0day-ci/archive/20260110/202601100812.QjhXvtfv-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260110/202601100812.QjhXvtfv-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601100812.QjhXvtfv-lkp@intel.com/

All errors (new ones prefixed by >>):

   {standard input}: Assembler messages:
>> {standard input}:26675: Error: operand out of range (0xffffffff not between 0 and 0x3f) `l.slli r21,r21,-1'
   {standard input}:31576: Error: operand out of range (0xffffffff not between 0 and 0x3f) `l.slli r17,r17,-1'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

