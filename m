Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C357AD73EBD
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 06:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2A976B0005; Fri, 30 Jan 2026 01:03:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD85F6B0089; Fri, 30 Jan 2026 01:03:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD6BF6B008A; Fri, 30 Jan 2026 01:03:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AAD706B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 01:03:45 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1BCAB8BF1B
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 06:03:45 +0000 (UTC)
X-FDA: 84387588810.05.85DEF8B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3C639100007
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 06:03:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=T1wToCe0;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769753023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SyxMkhc09GpVX/wtL/xin/a2au9gMwpjeBbCi2j2FFY=;
	b=315jul+nqUtHWyVtdwmOJnK+899cEZgsh8cpIZ9D9W/hjehGi9gYG8p3cJrgIPpqq9Sy03
	U00u9yWtbQQ/V72Adjuvnj1yg+xcryUG8A4u1cZNKoqM6a3yWe9a8xjvNdo77mz46+6jiw
	fq1mq5tnWtQyS1/q/a9GD6GUwOD1154=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=T1wToCe0;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769753023; a=rsa-sha256;
	cv=none;
	b=KbDTOWxFdZZ+vnS+zvjIGwZCTkFIJ4pgiqt/WUZ6RfuZDp0+taTeHs/27hYFxkSxGGPC5r
	J0EQkJjyf5KB+MXQJKPfGKjly9t58YiJYV2Y3NN8eB9JNmiDYYL8NqZAqcYScjeIzyKBwU
	ZGpvbugdElGf+x3eLbBl5Qb4ClHZUUc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769753022; x=1801289022;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=d4zik4vcj/lFgKgGzJVjhTVh1ELgPPd4ldOEv4d4QqA=;
  b=T1wToCe0EciqvZE9RShA9cjZFeplCCxxvHM/pseYMhfrFTEFNGZibGdR
   Oox/Jv9A5AjmpJNjzPKu1IwQUCALw5UUtiKCn4mbmzh41xhhWyuC4iWYq
   bwCoilf6cu+ltDG3ytPYswepVwBC04Ga+Jp+yQBWSgRTox+zGIFSCaV05
   4NF0g8Fl6cIVrVAVrTbKV73V1qXkDUenrfBtJZMuj57rBbzma8AmL/2GO
   u219YNX5IH/QysFj1ToSyEQFblC2d/4Xg4m1RmrTNYwqpb63iNUBeYItH
   jNE90ja0w9+MR4Y6BEy9BOf7AxVHREuCevLIwpQXoOx0RUKsftABaBR7y
   Q==;
X-CSE-ConnectionGUID: N638/06IQ9+motmC0v0Xaw==
X-CSE-MsgGUID: DHdFkDl+R3GCEiqNBhtAPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="82370913"
X-IronPort-AV: E=Sophos;i="6.21,262,1763452800"; 
   d="scan'208";a="82370913"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 22:03:36 -0800
X-CSE-ConnectionGUID: ttM0Q5NSTXeQgqv1POVyHA==
X-CSE-MsgGUID: fxTlaGG2QMeqO2AFywjFiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,262,1763452800"; 
   d="scan'208";a="208689582"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 29 Jan 2026 22:03:32 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vlhbO-00000000cFI-12EF;
	Fri, 30 Jan 2026 06:03:30 +0000
Date: Fri, 30 Jan 2026 14:03:20 +0800
From: kernel test robot <lkp@intel.com>
To: Gabriel Krisman Bertazi <krisman@suse.de>, axboe@kernel.dk
Cc: oe-kbuild-all@lists.linux.dev, io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 2/2] io_uring: introduce IORING_OP_MMAP
Message-ID: <202601301341.PTetVieu-lkp@intel.com>
References: <20260129221138.897715-3-krisman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129221138.897715-3-krisman@suse.de>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3C639100007
X-Stat-Signature: guentabdk8wuq3iy9nbgpnw9y5b3xhuk
X-Rspam-User: 
X-HE-Tag: 1769753022-474148
X-HE-Meta: U2FsdGVkX18Dufn0Ii+O/dMkVXWfhsTuYJpYw+y0bo6p2+lL1XD7TkIM3ufGSGMxVJ75tS8XShoY4P95asUzlJfpnwSNFEhYpvB0GK/KrNjQggtbHJG43wQShq22zBiXw3DsXzYpULUqC6ubUNDChG4Bk7TEPVYdklU+YWzA6/BZiD/TqaZPZ585kZtwv5Oq5zwnF4tGlnWcQ5dHwRX5V5mhrNw7QqKZMK2LOfuvNsb0unHTXYskVedMi5RWQcyLB08UM64qGaMDn0k2JXkbo+dKL6TDXLMTd8LdfoasGdLrNyIJR3a4wEqsj2UbnMskbWQsWOL+JsJQWJVazUjQhGUHThp0vO0NVLxSUXGM31cxRJvKc+EAxYyyrMnKJhyc2CN2V/SdXKkWd4igv3DUguQZ3dIfO+p4/YtT8nF4ynXJPl5TRVZAIHK9OGPByrSRfDazl3rwillhAsnEYZZD1nZx7pPuypm5tO28+W0nbbVOI9RT4dRAeTrg6PE7eR6bYXlPUET2Z4Vy6MK7jfDZ5i2gclJ4MvnJpy7txzX8A9lWiwaR1Kt/UGVSmPgBVfqpBuMBqRqB91WvKKhvHtAKHLCjT2K88lvqmdPIAwFqbhPaeY2Mi9ZgBWd/9eT0rvx2PB11qEKefLRDjmZdTDZaAlHlr2NVuZJMYa29XVmyzspT1phrO7uJErI56zW0KrLh1Wb+ENzy0gZ0NJdqtQyr970xERu4lBbSPyobBFeApjvWvvfFQlPoaKsOnalK0A9F1HGaffZNmEtHz4W/U+UDlMTmmadUs6MfNxUSOvSEeJld7fia0a4KsXCiv7Va4khxG1tupu/kBwaR+eRlgSbFcxSehTjwb9MOKSKH1aoMCXYv74yOHZcdrGh6urzA1HeJLTR5Xx88RIJ336KFMSCkuQ4YpcWCfa8ir3LV6yVv4X/XbMUwjKoQsHaVuEAaKWPZTOnYxIp9VyGqwJBjZUX
 JyVgqn7V
 gLK0BMSc6IQKai3YMXIIcZaPxpCsD28oOq5cfKZXUcZQAFNfIbac0mGj9h27uIb/dd7xhuVOwHJD6iSYGUOdXk4MpoW53IH8eGBdqc20BaB+flHjYGYc+FHuD6YyXZWpryr/Ddqv8PUxEgQ1L7wOP9gIp4GvmcyS+5CRvAcR6Sosedp0j3pAIGg1nfs0uu7qehjOX2PiyOUOgH6lLxkZQZBoiq/EGzmglUvJF0fbjl2HQnGxZGxNwq4NYo6bT9GFwDRSEi6I4E4IJvr2HPkGHRLS3l3FvpktHvWxoOR7GIDt1IokFrwwXWqLPEqtuLR/IE/p+IfMUk739cJX+35wzJE/Qo1K//MGBNBmEv3bP4TdW5CgMLODi5RyeqPvJw8gahgHW7BqcnIerqKO3GwgTUC9hVA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Gabriel,

kernel test robot noticed the following build warnings:

[auto build test WARNING on v6.19-rc7]
[also build test WARNING on linus/master]
[cannot apply to axboe/for-next next-20260129]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Gabriel-Krisman-Bertazi/io_uring-Support-commands-with-optional-file-descriptors/20260130-061445
base:   v6.19-rc7
patch link:    https://lore.kernel.org/r/20260129221138.897715-3-krisman%40suse.de
patch subject: [PATCH 2/2] io_uring: introduce IORING_OP_MMAP
config: m68k-randconfig-r122-20260130 (https://download.01.org/0day-ci/archive/20260130/202601301341.PTetVieu-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260130/202601301341.PTetVieu-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601301341.PTetVieu-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> io_uring/mmap.c:116:36: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected void [noderef] __user *addr @@     got void * @@
   io_uring/mmap.c:116:36: sparse:     expected void [noderef] __user *addr
   io_uring/mmap.c:116:36: sparse:     got void *
   io_uring/mmap.c:125:44: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected void [noderef] __user *addr @@     got void * @@
   io_uring/mmap.c:125:44: sparse:     expected void [noderef] __user *addr
   io_uring/mmap.c:125:44: sparse:     got void *
   io_uring/mmap.c:130:28: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected void [noderef] __user *addr @@     got void * @@
   io_uring/mmap.c:130:28: sparse:     expected void [noderef] __user *addr
   io_uring/mmap.c:130:28: sparse:     got void *

vim +116 io_uring/mmap.c

    83	
    84	int io_mmap(struct io_kiocb *req, unsigned int issue_flags)
    85	{
    86		struct io_mmap_data *mmap = io_kiocb_to_cmd(req, struct io_mmap_data);
    87		struct io_mmap_async *data = (struct io_mmap_async *) req->async_data;
    88		int i, mapped, ret;
    89	
    90		if (unlikely(mmap->flags & MAP_HUGETLB && req->file &&
    91			     !is_file_hugepages(req->file))) {
    92			ret = -EINVAL;
    93			goto out;
    94		}
    95	
    96		for (i = 0; i < data->nr_maps; i++) {
    97			struct io_uring_mmap_desc *desc = &data->maps[i];
    98	
    99			if (copy_from_user(desc, &mmap->uaddr[i], sizeof(*desc))) {
   100				ret = -EFAULT;
   101				goto out;
   102			}
   103		}
   104	
   105		mapped = 0;
   106		while (mapped < data->nr_maps) {
   107			struct io_uring_mmap_desc *desc = &data->maps[mapped++];
   108			unsigned long flags = (mmap->flags | desc->flags);
   109			unsigned long len = desc->len;
   110			struct file *file = req->file;
   111	
   112			/* These cannot be mixed and matched.  need to be passed
   113			 * on the SQE.
   114			 */
   115			if (unlikely(desc->flags & (MAP_ANONYMOUS|MAP_HUGETLB))) {
 > 116				desc->addr = ERR_PTR(-EINVAL);

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

