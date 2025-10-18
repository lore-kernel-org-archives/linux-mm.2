Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 866BACCD184
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 04:47:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88E508E0005; Sat, 18 Oct 2025 00:47:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83F778E0002; Sat, 18 Oct 2025 00:47:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 755DC8E0005; Sat, 18 Oct 2025 00:47:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 642F68E0002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 00:47:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C48D11603D0
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 04:47:19 +0000 (UTC)
X-FDA: 84010000998.12.348BF90
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf09.hostedemail.com (Postfix) with ESMTP id E9B8D140003
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 04:47:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=F1M1X19X;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760762837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6T0nEHqgomWbSbqMkaLKOIss/3aw8Au3nJ3IWEwAVU8=;
	b=0i2W5oCEq6rvuNx6wfaYgN2MIGQ/9Dw6OLszAebTc2V2ilxVmOnS5dxhyb8ZbAaFhco8uz
	XRHZnq96hpXimhQl13kx3GvXj/mfdBqnermUBWRBZ9NgQcFFWg1UktfO9TfBekVAwUo9D3
	EHpCHbyYkvyU0FDQm2KPQRQoQKFB2aY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=F1M1X19X;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760762837; a=rsa-sha256;
	cv=none;
	b=LVw0tjkQImRZDWC/ckP+JwD0EnJnJgLhHZJJso+49auDDrt+nN/J2eS6hpZuGwPaUmFiVt
	pIT+KWegMa6VrXswvHUkqg7yG6H2PTcPJ3WNkZBappLLWEf7QmIt+5ZROYuI7X6amCfhFW
	T4RUbpVgY8cQqasjyQnhA4mgbITi1e4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760762837; x=1792298837;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VxEiGxEpqNGiOxmfppZ5EdKGKFhkf4LgSqXDCj9LQJI=;
  b=F1M1X19X/iD2t71kCdPYga4XiAiuF+nWLBLb9Ma+J3DfN4ceuZLiJv38
   bQ/E1U4D044+uFMpskgkqcYHENEm1/nnd/WO5/S9BeEAN1GCXFm+PVa9V
   UhIGEmQsjXLigxSCd6+JkEhrKBLrKyEgZxaNQvE4uZHmXGIke+VZLE3Hm
   DS/l+olmMu8NOKCWeB2X9d6ZJP5YhMjOALe+hbiwUNPT+G9+64I3vo+V+
   DySljcDUkdbRfTl6vU0USyr9wePavGHuxLZ/12cc2bgJglT5/8/vr9OKC
   uRWMs6CNZfs9L7VV8plTWnIeOmer6WYP+RGMPBe7kluVsk4n2+vyAaANa
   w==;
X-CSE-ConnectionGUID: LScmoh8LQxyBCNHhY3MAlw==
X-CSE-MsgGUID: 377+mcg7RSaS8eC7cs4VJg==
X-IronPort-AV: E=McAfee;i="6800,10657,11585"; a="80605387"
X-IronPort-AV: E=Sophos;i="6.19,238,1754982000"; 
   d="scan'208";a="80605387"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 21:47:15 -0700
X-CSE-ConnectionGUID: l+D+wMBVRre07wjM8mJ+OQ==
X-CSE-MsgGUID: u/osHsXdTsqLlmkLee4BKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,238,1754982000"; 
   d="scan'208";a="182445076"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa009.jf.intel.com with ESMTP; 17 Oct 2025 21:47:12 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v9yqM-00084J-1K;
	Sat, 18 Oct 2025 04:47:04 +0000
Date: Sat, 18 Oct 2025 12:46:49 +0800
From: kernel test robot <lkp@intel.com>
To: Kiryl Shutsemau <kirill@shutemov.name>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
Message-ID: <202510181215.jcL2gJMQ-lkp@intel.com>
References: <20251017141536.577466-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017141536.577466-1-kirill@shutemov.name>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E9B8D140003
X-Stat-Signature: g3n7g1tj77ckhr8jtcoksahiqpubjdsz
X-Rspam-User: 
X-HE-Tag: 1760762836-810108
X-HE-Meta: U2FsdGVkX19soEC7ESchptaq3ALqGG3zCg9nbT0ZjXxCUzKHAOqWJDR4RX/bmqDwgr5tKxJ4ea52zfLp5/dT5WhSgOB4kvb71OaqCryDsucLFVU3NrNP2cmCvo0pxleP7hkpkcntOk5FltJEe8iR1AtosWvrfHkSEutVmq2WLow+sOuyCyBcqOYD3CR0maNeVwDQPiO1dMzrbqb4vRAZzlCtsT9GYEFYRfxH+NaIdh8iu9YiOZOEGwOdQow7SR5hVd8sAIKIFfhofGuK4XG7wpaRZfGzXoz/StyZc5/QC4eliEun/foWPTlp7yu5TM2g+SzeeJE6JfUpYV2Db7CxT9f4eW1n+0o8t9qiKmvwiLDpcMVWp6BzToc2vkW0kPuzSTM5FMCVPilRnOJPisdhckyaLsuv/5l92k15c2bLAelZP+syGRLiS1NC/aSgRHSFdixdMANZJZ6613xvrujVnA7y25MUZ/eR4HKfA+w6FYoH+0JDEKOq/evY+G96KKwkk4pcwtlhqbPGFtlVSOUCjZnWyLhgGEW/3CkmEDvRtqwVFXR6uvaPwaSjtnJ429YozzRlQ9qc50BnxGY88evFrt6UVDyLjoFtbjXm+iohMOjYj/jFtUiR2pOFvTLJMpB3g5qocQ96nQnclLXeIlbr531egAaEbPwPVXcxYU8o5aakc3Mllxk/aAgkLw2gKXIVarKBjfqkIxbUPs4ULZQ/jVfWq8w40mJzIWnM9nqBYwngLnf02Jlb6FrnEsQ+kpjChgdhvsi3vgPfL9w//f/MBqKYHRmxxJ+hqa08laszP/KRokuzA/m1hkHIFPS1oqvckSGjI+i43y5i3IeSN7T9unyRpENuB/2bpl3YGzdsSG6xGe27Rmkamug9UVii6l0A1oqSg2S1p7GFYcye3jxrCNnCZI21jIZDSkG6GGXYY5b1HtNrnXP+aY6EdaMFyw0jnTUaMnpiHDLsc0UYYUf
 exMDZ70G
 Rm1/Q7zsQOM2kjc9kwvlAxF1hsA6lKhSrYbtyot1AViOpFfosH3aXBPMMkSU//OGQJdRnzNufnoe8eiGPDPCaajs8yxs2a/+fF2E/e8CoXcr9Dx2wOop9suM2+x44sYHpQW1/xqbpIBnDMsDhwwbqBs7WrNUKuOVdHDyQrqJveAEs6xNV68pgQZ4/2KlYx/uqoqv8naQREey9BocWx2agN6oVYZ/1hYusO99d+on0nKNUE8Mk0/kccq4x0e0jEZFwAeP9ey2hq8uVocqT4XGeH29sgWl4RLmCQyGvLCze6/LodrD231PFtFjPHyZVi5p7FoaJJgIGGx/oPvU=
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
config: i386-defconfig (https://download.01.org/0day-ci/archive/20251018/202510181215.jcL2gJMQ-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251018/202510181215.jcL2gJMQ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510181215.jcL2gJMQ-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/filemap.c:2753:22: warning: stack frame size (1096) exceeds limit (1024) in 'filemap_read_fast' [-Wframe-larger-than]
    2753 | static noinline bool filemap_read_fast(struct kiocb *iocb, struct iov_iter *iter,
         |                      ^
   1 warning generated.


vim +/filemap_read_fast +2753 mm/filemap.c

  2752	
> 2753	static noinline bool filemap_read_fast(struct kiocb *iocb, struct iov_iter *iter,
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
  2787	}
  2788	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

