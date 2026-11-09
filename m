Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53D19606AAD5
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=fcL/6Lvk
Received: by kanga.kvack.org (Postfix)
	id 529696B05BC; Mon,  9 Nov 2026 11:39:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 501A36B05BD; Mon,  9 Nov 2026 11:39:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43E236B05BE; Mon,  9 Nov 2026 11:39:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 21DC86B05BC
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:39:57 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A01A41C4135
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:39:56 +0000 (UTC)
X-FDA: 85416142392.19.7215ABF
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf31.hostedemail.com (Postfix) with ESMTP id CBF722000D
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:39:53 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="fcL/6Lvk";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf31.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794242394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WB+NnUFeCMCsVOxK+oV+Ndnf6qqRZy22YpXN6vlA5YI=;
	b=RwPnMgKOjdRMIlOTCQPZYR05iSN5gy29gMPUx+B2bMqXntl/yx1Six6eEtBQROGYtceaBg
	PQUQC0Gt0RXVp+A+WP3PIXy836XHcdCNK+ciYfKOD9SmjZBfJbyv7dBtPSlp4qH0Vp39WR
	SLOhq9hUkAs0d3AcLQTVKQCizWlaQOM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794242394;
	b=nRbKfV8rnn9sz+Fm4nvCN7cjV8XnmzJKlzZW9mzV1OGj/sWCzxz4CWKx6B6jpADAfoUG/W
	Eg79rVlcVEjpnF7I8gXEvlx895UgovGrVzh8hI67uok8LEAJc0UD3abtdLFkEZEk7im2PP
	bl/8SKMQo4LnS05ykMRDGm5ISTj8DB4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="fcL/6Lvk";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf31.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794242394; x=1825778394;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qH7YxGJ9MhlbamqziXGD7CqNVxvvHmoJYm/8MPEQnoQ=;
  b=fcL/6LvkSdW0D1KWhkP01HNtkjBE/1/hrySnUkiCikAdMyUyxXElNmkD
   A8EiyRxYaq2cRkzXWajj9stkcJ7Tvk3uxqC1QCwohBVrHWhaY63VfIaRu
   gsRXgJ83Fev6I+X/TXBdzHA0rbYhgwxjAzi5H+254kkqy5s8UYKW7ruPT
   eX1sjsdFpAKh2aW2uwJI78Lq0bs7XHZgJazG74mYKw4j7Y2ezlyRKj3Cq
   5h4JY8q67Xb94AmLbgsw/aMRfVh/VmpahPYZUj3gyhuFYk9rT69g8c3zy
   6GGQAa/lOC7yQAEbmXGudSRlqh0oADCkeaxfpEoakaO0LTET4T0thudiG
   w==;
X-CSE-ConnectionGUID: wvwxn1vbRB2nQl44xFg7WA==
X-CSE-MsgGUID: 2bHPOFsvSiykEbgcH+o4TQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="3003927"
X-IronPort-AV: E=Sophos;i="6.27,204,1787036400"; 
   d="scan'208";a="3003927"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 08:37:59 -0800
X-CSE-ConnectionGUID: GmDWVMvLTauuUilaK9NuLg==
X-CSE-MsgGUID: r/dUjpvoQKy3cqvMwTbmrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,204,1787036400"; 
   d="scan'208";a="8073800"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 09 Nov 2026 08:37:52 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xQSNQ-00000000uud-40BN;
	Mon, 09 Nov 2026 16:37:48 +0000
Date: Tue, 10 Nov 2026 00:37:41 +0800
From: kernel test robot <lkp@intel.com>
To: John Ogness <john.ogness@linutronix.de>, Petr Mladek <pmladek@suse.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Breno Leitao <leitao@debian.org>, printk@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mukesh Kumar Chaurasiya <mchauras@linux.ibm.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Bradley Morgan <include@grrlz.net>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	"Cen Zhang (Microsoft)" <blbllhy@gmail.com>,
	Petr Pavlu <petr.pavlu@suse.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH printk 1/6] printk: Introduce and specify flush reasons
Message-ID: <202611100015.e1CNRy54-lkp@intel.com>
References: <20261109123127.489676-2-john.ogness@linutronix.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109123127.489676-2-john.ogness@linutronix.de>
X-Stat-Signature: uyys8u1m16mwe81k55tbx51wmzeuzht6
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CBF722000D
X-HE-Tag: 1794242393-712209
X-HE-Meta: U2FsdGVkX1/E53wag0mTUanIeVLrXQEUdNZ2rTyeU7Zt7iuseduiDfb5gKnRpcKlz0uT3pVe+Tayu0UiG9RK75hu1fvkEguSETvUnws4l5zoEFursQKxWONRa/MAqpjiKACSWQlS+EzIkRHalfztWSmnHFQoW6jGF4WMn5nEa6P9CKFBFYMWpuyf8gLBxnwmR0o7MZNAN3RmuxUlbpGZbqam2d/d+ccQAueevdKJcaBpSXYdXQX5m7aITdfkxaWxk1KZsh7tUqF/SZsHI15KnXM+I2oHr0/SDYpQraXBTeu4moDcbRlnpMwnq+UDkFMrdmyyXhXB+XIjr1MBeOpzR++v8XXCAiti8hAbH4mRDFhMtDbIf7IlRBuzswMC/4NWasANaW9RXpxX2Gsii8PP1NWAnx50J01BpfCTiSS+PI6PmBmtIBbQ2ZAc9Xj4DckxR5sE2tIF1oyk1BXeEpm7Spbp8uHWPtyV/JyY2Op+I9W549N6mrwFUP4hQXSKF6CNY2+bhm9DC3y3BzsEOcJcdVJXFaY9razq3RptUcCdLS0hRg07gntwciANXBQeJ1Ac9KLEep8VxNBGSkxhhHdV7wzWUjTkiZorDGEoL5nBHl5mKHjq0+YPn4+jhvWJqdIelBGs+NenFptGWTLMuzFqoqWFJm8//BKK9Vy+IXrO5RC2NnWoMwgC1US9552JQ2colqZHvXLlvBxAFJ8r3Na1cggHk5mXLVVugle9bAn9zcvAcpFIw8fqHhj6ShraUhbgWifrYsvbr+9H42o07MqzmFOKI4WzAf0Q129Weqgs7kny1i04C3qOWYp13ZAsJg4JeUJvyZAOXD49xWkocCxZWwUvwklkxzDTYoWYXmAd8AubxZOGTC8wtee3gIleQLtNBriUBwIXeIGWbhhIm1EiGvdp3eFkIBurQ46j+HmhPQ55Xt0fH2mMqM5VbZKj3Z4hRr1MoGVstbo/oK1OZGv
 O+owqJoQ
 QwK0OV9cz1CiOcm+ueeot31Kjz/3Unl0BE8PDxLHB5SqZq40FGkcew13s8rjAydJelRPUxDZs4T9AWwjtjsoHeXjJb48UcBwSSXBKOymXuFHcbgRi1UpDZ/V0Rpz2ERzFrmJWoZrMM4f//a5+Hamm0Gfc2/RSo0SypBH5dZ6cEYP7t8UZwUYO+QgXzhnAmWXB+auCyq1/zFtqLJuruUGw1nEGwWaLF5c8WDStCMODVK/QiTLfmrDPfXfyCc7KmWXd7sny9DbZC3dNQndlGi3/SI9UiAI+huyBSmNMo6KFtlY259KLLMuWdOsq8cHT+mWoDwqAfM/qJf5XK/JqBxu087+dhHH/EaFe01a40uA9LmemXejCxS+DNQavKnHmV05F9c2WExfi1m7EKztRY6Jia6SN0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi John,

kernel test robot noticed the following build warnings:

[auto build test WARNING on d01f86a7da8161aac8c6304b377cf58fb75861ca]

url:    https://github.com/intel-lab-lkp/linux/commits/John-Ogness/printk-Introduce-and-specify-flush-reasons/20261109-133718
base:   d01f86a7da8161aac8c6304b377cf58fb75861ca
patch link:    https://lore.kernel.org/r/20261109123127.489676-2-john.ogness%40linutronix.de
patch subject: [PATCH printk 1/6] printk: Introduce and specify flush reasons
config: openrisc-defconfig (https://download.01.org/0day-ci/archive/20261110/202611100015.e1CNRy54-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 16.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261110/202611100015.e1CNRy54-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611100015.e1CNRy54-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: kernel/printk/printk.c:4735 function parameter 'reason' not described in 'printk_trigger_flush'
>> Warning: kernel/printk/printk.c:4735 function parameter 'reason' not described in 'printk_trigger_flush'

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

