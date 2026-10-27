Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C6D5606A323
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 05:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ZxNaGf3w
Received: by kanga.kvack.org (Postfix)
	id 6CCC66B05D0; Tue, 27 Oct 2026 01:39:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6833B6B05D1; Tue, 27 Oct 2026 01:39:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56D7C6B05D2; Tue, 27 Oct 2026 01:39:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 306666B05D0
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 01:39:34 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2515EA85FF
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:39:32 +0000 (UTC)
X-FDA: 85367303784.06.82EE59C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf19.hostedemail.com (Postfix) with ESMTP id C0C6F1A0009
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:39:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZxNaGf3w;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793079569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QMFHkYsqBmcbVrWKDFByhexqX1LEHDSolSs6zJfCkfQ=;
	b=CAeBl17nCjz3nid/GlXGYeUaoQvEKHsXene8SvvciHbU39+cHDjUM8c9lBAB/RGGweOie0
	zJrqgQQHrOji7lvizx30qss6IjvobqtBn2MwFeFE1vCZS5qScCAkQPTCneGXsNGRz55U1O
	/pPhYSHLRCvCLthiZsFP4U9g3+VAfJ0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZxNaGf3w;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793079569;
	b=wsx1R/3dCSLx8IEr+AEcZ1ke/oBKMBPJLdTnc6YfNVjnZCmPszX1J6mdfwkabUARBhUh5h
	06SvY3471yfKm+2Qsmx6fDP2EoY0g6FyRtzGIB6M9kfTgNSi6CNV73JI0ziWO6Se0vO1Xw
	kNfu+XDnxVzEKBe/GysAxgyAxJlke+A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793079569; x=1824615569;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pzpMExCU3NEyvekb7kKHOljun21uUmMNQ6c0Pg++oXE=;
  b=ZxNaGf3wguHkSm8V+AawPVyNjmOR4Z2A21edHvqw2gu/mbOg0e11Kaks
   67dx2EZjYjcci20j51HRUn9iadiFcgOw9zwFtN5w7YGPjv9DnrKXUlxdj
   NOlJ6SPtnr/qb4xrY5ASAcJ/EyWgxRVXj72qyN5mvEYOL/72NeFjONNFq
   GJjg3j/Gw+lNSkm/0U6zpj/qICoHjcCMrXh4II70lN9MDW9CKjO+vuYHS
   K96kDccEk1I2Zrv8j4f1zkSV7aVzIWm99vrUMPT8pkGw/r97c/hCTxcDF
   rfeydpFeXX+J2KeziMs8e7QoSVL46jL8ngJ9+s26YqKhVW9NdrMw3gona
   A==;
X-CSE-ConnectionGUID: ZZNFHHC8QmWHCsd2DQwEDg==
X-CSE-MsgGUID: qJqkDbwzTwSwlVuNrSeauw==
X-IronPort-AV: E=McAfee;i="6800,10657,11947"; a="1781498"
X-IronPort-AV: E=Sophos;i="6.27,180,1787036400"; 
   d="scan'208";a="1781498"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2026 22:39:27 -0700
X-CSE-ConnectionGUID: 1kxPM+3HSqW+g3X4zqBZMQ==
X-CSE-MsgGUID: jyfpNWjzS7ynp1/Q36Pggw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,180,1787036400"; 
   d="scan'208";a="4843020"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 26 Oct 2026 22:39:22 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xLZu2-00000000WtE-2eZ1;
	Tue, 27 Oct 2026 05:39:18 +0000
Date: Tue, 27 Oct 2026 13:38:19 +0800
From: kernel test robot <lkp@intel.com>
To: David Matlack <dmatlack@google.com>, kexec@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v2 07/10] mm/shmem_luo: Retrieve tmpfs files onto a tmpfs
 mount chosen by userspace
Message-ID: <202610271346.EnKIU96f-lkp@intel.com>
References: <20261022225035.377445-8-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261022225035.377445-8-dmatlack@google.com>
X-Rspamd-Queue-Id: C0C6F1A0009
X-Stat-Signature: wxhsiambyzzhrc5aaiwy7pbjam6miskz
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793079568-759621
X-HE-Meta: U2FsdGVkX1+Wwe6NArCYnBmEckgR+9DmBwJIW4/9w5tITtXNHnT1+EFLxlxTucpp+jDvWsjD5KjB+hk6KYwkxy1UqavccZXEv/F7dwc+ETXCo2mMAtRVVJQKnX+A8sXQB/BEL8poMTAgaKLKjaDbH0k4ocwEyicP//cGt63Is1TLWVNIA1Hv1zIzfJfsMZBehpHZ6wABeomIG3Lf81scogvgU2yH1fRo8r4Z2Tj9haujtmPT56S8wGnhb4Q2zjV2f8+o6y2TyDMcGRirkqqPY8RQ0viR3/rTwmOfDztxHRCFIEH3KMoRG14JVcF4FqkxEhvo4TnJdZNey2gnig83ubkmBd2RoHsDnNLwqKQjU02nX54kLP2xiHF0MsP030GnNU3KsFX4u+WuNd1ei/CI49rlvFA1z2YxFds2GbM77bw7zYr7Rzb2NwApQ76kMIF4sZ/VLBf03bwTxqlUPt7R5F/k+fT29wKkrWRwWxJLoWDOntLB2h5Uf6x7MKZlhTLTaHD2GCotT/4OLonqVlHWSOuuvGlAz9ygbtgPr7uukBz8p+k3ySlC6zWwKTLj2AY1rEDTr1W+tOsrW28ABm98bEc4m7lRwIV5oWwg5EmXNzh2tpH9deos9xpJM8sVaeySvhaJqoksDerFMHODkO5wUY6+br5iTRloUpvmTrJ4drRlP9aMjWd6IWhXAlnHta2vXYadtxU5IvGUo7iVMY2i5zd84hbptAr4Ygy2z6n8egnB/pWpvNreKpYDW6/djBDedy3vOi52d3noWHJFjyF6hj0sRpn3jaQ/ndBIB9mbh+ecPRKwkNrvY9akMiMwCEWaYAdC9K0ZY5Vbx3s0jyqK46WPOEG2z/qvroQP5aBmBwTHeqhBW82QgcKZtkasOUzyyFmPPIyKZUoyNBTd2bWbgny7Aziw5Gg6rC3+CXUEVzkiSWNxVAq/+1K1Nm+HSTmgQZs1eLIicH8Q/B6GlcV
 U7R4J5MC
 rMtCxZM2whTiqBEF9Tpl1ooAfOmFJihxi6yHihAgZoCBURoFNazlvX6x/HnjeJGjSR+XIkmsUniKlgCXAZ3nkcO4fNn3fOETJdDchBuXY4zi98AHAuYXqjsTzeEXRlUs54xM3YisHovCVcDtJ3Xwhc1QCtLP7TFdc0EAZJ9bbfcvIi/fFF4MdfDkfdlW9DTVMzdVzppp/TGPiRtcs/ZVE5//jjKLv2b0u3OwMP7Ed7IFUDC4x79zPmDV54knS+Lk+/Z73KCiTDkNsuIWZPxPiSXtmvgTajhk8LmjakcDWjhXHIzu0M5pqgO1odxMfxdWm5UAMGXy3yBZ2AkKos8FzhVgzelVqxcRvZBQnV3jhDby7fb5wrlneoZV6f1nBKit5UUGvrs9X2RTOnwXw9sG1fcTP4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 80cf37169daef112b6bea9ae7d9808355a045475]

url:    https://github.com/intel-lab-lkp/linux/commits/David-Matlack/liveupdate-Pass-user-argument-to-file-preserve-and-retrieve/20261022-225026
base:   80cf37169daef112b6bea9ae7d9808355a045475
patch link:    https://lore.kernel.org/r/20261022225035.377445-8-dmatlack%40google.com
patch subject: [PATCH v2 07/10] mm/shmem_luo: Retrieve tmpfs files onto a tmpfs mount chosen by userspace
config: m68k-allnoconfig (https://download.01.org/0day-ci/archive/20261027/202610271346.EnKIU96f-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 16.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261027/202610271346.EnKIU96f-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610271346.EnKIU96f-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/shmem.c:5867:6: warning: no previous prototype for 'shmem_inode_on_internal_mount' [-Wmissing-prototypes]
    5867 | bool shmem_inode_on_internal_mount(const struct inode *inode)
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/shmem_inode_on_internal_mount +5867 mm/shmem.c

  5862	
  5863	/*
  5864	 * Whether @inode is on the internal shmem mount, which is used by
  5865	 * shmem_file_setup() and thus by memfd_create().
  5866	 */
> 5867	bool shmem_inode_on_internal_mount(const struct inode *inode)
  5868	{
  5869		return inode->i_sb == shm_mnt->mnt_sb;
  5870	}
  5871	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

