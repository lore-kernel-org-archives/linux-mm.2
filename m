Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2A7ECCD184
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 03:54:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 932C28E0008; Fri, 17 Oct 2025 23:54:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E3928E0006; Fri, 17 Oct 2025 23:54:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F8CC8E0008; Fri, 17 Oct 2025 23:54:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6F9148E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 23:54:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0FD9587A47
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 03:54:56 +0000 (UTC)
X-FDA: 84009868992.07.67FDB4A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf08.hostedemail.com (Postfix) with ESMTP id 68FF016000A
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 03:54:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bBC8BgUt;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760759694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u41eT8D5dqdLJHzAYU+XwTHwHVJl87QzaU3O5/jEDrI=;
	b=DqK7DhJ/Ro1TpYW25iwEkWGY8sVN5nKeG3LCLiZ+Ek1dK0hvcFeSvbC/DhPVbaihuMmWjc
	X1q/xu8K7tGba04c3klsHEPhZH6VnM2INLgffPM80x+5nYvz3FnmYWLd9pTFZMTMeXsrTh
	u/tkyqwFiSZocJ8RHwY+Qj+Gr6oCg8Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760759694; a=rsa-sha256;
	cv=none;
	b=iBjYT9ymTdD6/ECoqyTJzFP18ABAOZvYjCHJ2YlCvHnq8KvixVGW5vnxK598bvfgO69/rx
	h7xzje9Z644os1I6VXiGFmtSdOgHOZ1RxBxv4tCFfQu/aO78PWPVrBdHcnBLhZwBEDv6vK
	P7rDgtcl9PHLvv3FVimx1mp6H6VGWu4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bBC8BgUt;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760759694; x=1792295694;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=okI3RpJTLrRj1PrupblKZE/45kDzmQjlxy+SRy5hI2c=;
  b=bBC8BgUt6cOfZIyS/EZ9uOvbeKh05cVKfzelR/065Fl9S/Ajgm4WqasZ
   PIxK3sQjJw5a1I1JIaGQLG2fuaR+Ad1f3FxpIN9Og4hVv5VXTZ3hy2N+s
   7z7qOWfPGn5bmEpD/IOaHqacROplIKYpIbSwmsKPteqwcT2S/rA8+tZu5
   KmaS+BX7RqN26/rqlDug3aDUstZOglyI5NigwwpeZL81Xe7kFG8Do/cu8
   7oUB8QNk6F8e7ctf1ZwZV0RamAC0pQ1918gcGCaDcWRaoo07g92VEvdQM
   kRNLmj4q5X5QhoE5JQI4Db9JmIJZccvIm8YIMq89KATpaoP2o90MkPing
   g==;
X-CSE-ConnectionGUID: CBExACFVTwWRTJjHDlP/pQ==
X-CSE-MsgGUID: HYn12ZKdQ6+PJc5yMIq5cg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="66808255"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="66808255"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 20:54:52 -0700
X-CSE-ConnectionGUID: lfkJnemmRKGrlC6HZMrttw==
X-CSE-MsgGUID: kKFSxIhlRyyzUPXhaFL+Ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,238,1754982000"; 
   d="scan'208";a="182703077"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa007.jf.intel.com with ESMTP; 17 Oct 2025 20:54:49 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v9y1m-00082V-1y;
	Sat, 18 Oct 2025 03:54:46 +0000
Date: Sat, 18 Oct 2025 11:54:28 +0800
From: kernel test robot <lkp@intel.com>
To: Kiryl Shutsemau <kirill@shutemov.name>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
Message-ID: <202510181107.YiEpGvU3-lkp@intel.com>
References: <20251017141536.577466-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017141536.577466-1-kirill@shutemov.name>
X-Rspamd-Server: rspam01
X-Stat-Signature: 4srbjqqkxmj68wzmxuigkgqd7bfjsyyi
X-Rspam-User: 
X-Rspamd-Queue-Id: 68FF016000A
X-HE-Tag: 1760759693-936923
X-HE-Meta: U2FsdGVkX1+YIxLFRcem9T4orQoGw/SgkLpglmUGs4GLLGVfvG2HKV5blPpP2OtIF92/L+r6w7ejxwxpNri/SLTvVgRkAiCMQ/w3Cyt3SPT8oLstJrWZwphu3CXcAthm/MYa/Xjo4zol+Q0Mfi+2hyi+Qj4VkCtj+w19+lbiBTn+ZDfgds+T31ZRdB0FLTbh45z6QJ2YceCAKVtZrIvPdTSGnAYdweFO9AVOVbr2GrkvWqM2JZCk3XNJSExMIp8sFhv/jKWugaFQkTgC+7Y3o2s83I5LfFHR4fu0Z2KGdvIH/cpgCLeRWKTAHd4IZcT3XVRoCQGQkeD91mU27GckWv/Xs1QV8u5FzylYm+wbVzT6lytw8iO5aTrpFxGAd8FRP9MCoOUZdNEYONzbEHKLEQfDTbsGq+jTKBrOIEtytARKflup1jGbGbnKvehinB/92mIJpmYw1Y7asfcqS7RdmEJ0FqOQQdwsICQ4Zg35FRtYmp0sqhPKDTd7V2UQHA8hMseW3j+5ktLJ/LU2nBYhLXAmJTF5la2KTk/bzQZs3038p7agDO6z+3Ua7+NpD7a5SBrGOCMjFuW+Ozczgvm5UtmUTVDY10rdOOPaCuvERNAKMYmUOiKBmVoxag6hk7GxzQuS0ZFQXHBBIOtjJwmCZXweIZkC7uJufaR5aeHceSz2eurPKUKeO84GwjXSX2vL0WNf4NQwDxAcpxAy2ozKvhE6Qy6qkjJNDLc5C5+qU8FOG6QGrKqAPzw3qJrYfyJHdPursEjs6OJj6iBpvFyKtpB57D978d3s+z+ea0AeLU2a++/HZMhL9KTcOIaxSW8S/LfJv6FLFhSeEtmEywLZcL7j7L6mv+jSuebDZmZi/WWECWCOzfcfiD8OCefc02qeGnLSeoiSrZolC3Z5YqZzCzTHtBUgbAo6XVezxyt6j5OWc1ln+gIpOBqnY5aWbr1TVBlNavAg4ZSh1gyl2P/
 EWxQjDtG
 /Ge8NGbr85V0firWxlEN/qEyrLPY8nPD8/TMQ9oEMdThpkP2Qu4SAFz174gl2GEY5aLeAWfudzJXX79t73pXR2PQcBRR+F7vVj4nfep6ELxjMooX7bMkf4H+Q/KuMGZExj7A1kpWTeNiLHLcAWkrbLWskBiRh6Idwx3DlgAaZq6Ma+JdByW0zdM7A7zDhAcFT203xDYBR+N9Sm5JECzYlL05x4WaFshDpqJF5yHfG4WJlzwGuhL9emrB6CXw1vaKGnY/bqCzhOGwUDdrBOB2/BcYVROIyjdyFD+BYZgoSHBuebGm/9s76xt1klHd5khoElUPF6N4Un1GcgDs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kiryl,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Kiryl-Shutsemau/mm-filemap-Implement-fast-short-reads/20251017-221655
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251017141536.577466-1-kirill%40shutemov.name
patch subject: [PATCH] mm/filemap: Implement fast short reads
config: i386-allmodconfig (https://download.01.org/0day-ci/archive/20251018/202510181107.YiEpGvU3-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251018/202510181107.YiEpGvU3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510181107.YiEpGvU3-lkp@intel.com/

All warnings (new ones prefixed by >>):

   mm/filemap.c: In function 'filemap_read_fast':
>> mm/filemap.c:2787:1: warning: the frame size of 1048 bytes is larger than 1024 bytes [-Wframe-larger-than=]
    2787 | }
         | ^


vim +2787 mm/filemap.c

  2752	
  2753	static noinline bool filemap_read_fast(struct kiocb *iocb, struct iov_iter *iter,
  2754					       ssize_t *already_read)
  2755	{
  2756		struct address_space *mapping = iocb->ki_filp->f_mapping;
  2757		struct file_ra_state *ra = &iocb->ki_filp->f_ra;
  2758		char buffer[FAST_READ_BUF_SIZE];
  2759		size_t count;
  2760	
  2761		if (ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE)
  2762			return false;
  2763	
  2764		if (iov_iter_count(iter) > sizeof(buffer))
  2765			return false;
  2766	
  2767		count = iov_iter_count(iter);
  2768	
  2769		/* Let's see if we can just do the read under RCU */
  2770		rcu_read_lock();
  2771		count = filemap_read_fast_rcu(mapping, iocb->ki_pos, buffer, count);
  2772		rcu_read_unlock();
  2773	
  2774		if (!count)
  2775			return false;
  2776	
  2777		count = copy_to_iter(buffer, count, iter);
  2778		if (unlikely(!count))
  2779			return false;
  2780	
  2781		iocb->ki_pos += count;
  2782		ra->prev_pos = iocb->ki_pos;
  2783		file_accessed(iocb->ki_filp);
  2784		*already_read += count;
  2785	
  2786		return !iov_iter_count(iter);
> 2787	}
  2788	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

