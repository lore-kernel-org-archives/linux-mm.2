Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F697CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 12:45:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49D5B6B0005; Wed, 20 May 2026 08:45:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44D806B0088; Wed, 20 May 2026 08:45:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 364506B008A; Wed, 20 May 2026 08:45:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 25EDE6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:45:13 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9FE7F1401E4
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:45:12 +0000 (UTC)
X-FDA: 84787768464.13.5105B7C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8DE024000F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:45:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bMGMh7wJ;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779281110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cg1d6TPX1tiolpq9/G7k6ta9AHVVXgU94OTLeGvseZ4=;
	b=IZevgwyPoYWFk10wXrnWKR6IyH5ud2UyzYPsUKfY33s7hpQKoBY7jH2PxIK3JBsyRdXXMZ
	u+XcIEQLvYf/cSsa7rpdiBX8p2CNcHppskxeAdDNs3WtITrWbGui0u6Z3um6P/Med4d5n4
	OQbnoJbf4qfiz1Cczukti4dLKH+kapU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bMGMh7wJ;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779281110; a=rsa-sha256;
	cv=none;
	b=U7HcNS+ilrT8lVD5ytoeWiD1oAGIZtYidkLqgfu2S/F6V3QxZQO2FkmQvoaMK17wwMBzUh
	QPIge2kTdL8wbThXtEbZmCKh6gggP18UOH+ESuDm1mrh2nWw77q+jw04gjDx7d/bR219je
	9n4hHoABrCE1kLDqnwz69Af1rn8x5zw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779281110; x=1810817110;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nVvw8sK7QoJlknSpgna5CuMA0A4P6bOu2DxiOepEIkc=;
  b=bMGMh7wJXydyOPU38TbgsWjl0WYqP3yk4CYH/Lmg7dczbH97iv75L88w
   Y/m/m3Qav+rt12xZ1/t1asZqoNSdut6LUUKZI4HBUu0Pm/xwsRGuabdJb
   Ks6hxU1nCy1STUMiugzxYEqcsZpPMHM4x/zYFSSR4hEJ3uNV9Sb3/bO1S
   In07eRPL2A1Ec+HGnek2uwOxBMZoJo4EhmRZ6Ydu6hPuctgBdHJG0dgOw
   u1COrmFfURgHTEKQgrGmvArg8FFMKYgsbwt57BdTZopjZ1qk9lCtp+l83
   5C5IK9zE7Lbz4+qk54KXJFETy4y2guxKLXg8ILhPKyzzjqpVoDiJuWGkh
   g==;
X-CSE-ConnectionGUID: hmIa370KQQWsdT09UiDmKw==
X-CSE-MsgGUID: JTA8UDw+QS27l8QishcGqw==
X-IronPort-AV: E=McAfee;i="6800,10657,11791"; a="83793898"
X-IronPort-AV: E=Sophos;i="6.23,244,1770624000"; 
   d="scan'208";a="83793898"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2026 05:45:08 -0700
X-CSE-ConnectionGUID: wQeiMau4SjKx+5drUtE+bw==
X-CSE-MsgGUID: wSCEHMI4SuqSzA0KpDgHXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,244,1770624000"; 
   d="scan'208";a="237165166"
Received: from lkp-server02.sh.intel.com (HELO 30e86e9c1927) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 20 May 2026 05:45:06 -0700
Received: from kbuild by 30e86e9c1927 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wPgGx-000000003AD-1SgR;
	Wed, 20 May 2026 12:44:00 +0000
Date: Wed, 20 May 2026 20:41:18 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: oe-kbuild-all@lists.linux.dev, Mike Rapoport <rppt@kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] init: do_mounts: use kmalloc() for allocations of
 temporary buffers
Message-ID: <202605202055.kwkCHqR9-lkp@intel.com>
References: <20260520-init-v1-1-aaf2ebac5ad9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520-init-v1-1-aaf2ebac5ad9@kernel.org>
X-Stat-Signature: 537ndwo3nmzar4899toh5yz1w9fyq9hr
X-Rspamd-Queue-Id: 8DE024000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779281109-120389
X-HE-Meta: U2FsdGVkX19UlQsPqyQMnFOZpPxrCb3IRmTrLBzzyFl0BgP/o7Q8IXkrUMdIY7p2jiAG1LRlQyEmp91DCGJI+yBnlwofeoI5dDZp+We/Hc+/+zGrpozV7nE9MkavBpKYA/oEiqdBjdFseYw5b4nyHihfcObK9B2zplJHYDtmk7eJvW9LXRUyd1wuw7+fSAaopYRHRo4uSIG09UowtgEc+rJi2Y9JGL7TCyMFY5CwXIZAEohRfNjUeNMNc+QL1W0Bb9+QdZpu+jMxMOmVIwWHY7mJodeRMognSRpHyPclgwv73KTztvyB8lP78vpSpyCriBT0pUiK5Fz+N0UYmirG4gEfBcvVPvX7K9Cz9J/tA8FnviO4mDcNeA+abqe3KFvG3UhZHkzepUXYFg3iuqsr/OU6WTB0U0Ibi4frirzW0V3tqqxE5a9ew2N3TEN6mux/3Sc+eIJ5c4mMQXbo5l3pNejh6fbm7EvnxhRAaE2uLn+urHy9PDBKzzJfysJJwoAhcJygioTRSBeyLju6r1s2ebHNZiObUQrWRoT78ZEzL4JweGtXRz8SLXO2EbSYOh7t2CrLJFk+6PYwIMiRl8DLIhL7dXHLBMQLfi/hNsLLhYc2PL9j8UO7BiZFlxJadsJtfHXZHJjKciYAGsHgGUvioCNeg1jJGuxPHTGDry7UyapdWFrn275DKeu5kXqXbvS9W4PEi4GQ5VW5uarC1M/mqLI9/+ChLsigFystdqFKATbJ7n69DsWFzgiyoq2Ks0C50pRIcxfKJTUKa69BYV98jfNSJBSbkq9fvdM6up/MNISIHltapAFte0FezFqCVssKwZWujeBeTZriFXBHLNksTcnc+GhQIcSKkeIISjvuYFCRtMeTtgxhaMV6Vf56IML3xt6cNt+Y6nBoa8RqWxJHHCTsgYCphXuwtby1E8p315sidOcpY4i2iU+asxq0adKJdyq56/uMMylbzJW3lbv
 xbf7gupS
 ypTd3sDHi4ZYaktKLYp5Ky8OmpGgJiGAf1QjbzOy2DU6qYsaQPKDMF9QkhywY9PKSjp1xrFswBJepZfxyOe1RiVqKWJp+SiGjw3XXOaZk4QpXXoUU1qpMNKiRVw8febk21KE1KQyin+NWdNX4DqJCmdpNwZzVUHV8FOhYV1hfYxl41CMk04x403qIo91mFtYEFz3LIY4o6KXUVaE3CxbPlFvKFMGyZLQCmFQvhckBbFPar6eZX1VlaWLlbA19ICU0u7OgCGdu9LckQsQd9Y1X8gcPfmtIaHcibvsH42t8NlMx+FmTfPrTFXwtSIj9HjYf9X6yMy84d+20ujbIO4j4oQuQKlQuilrMQvO14wtmoZBHE9Bt2rIbcdihcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 5d6919055dec134de3c40167a490f33c74c12581]

url:    https://github.com/intel-lab-lkp/linux/commits/Mike-Rapoport-Microsoft/init-do_mounts-use-kmalloc-for-allocations-of-temporary-buffers/20260520-164927
base:   5d6919055dec134de3c40167a490f33c74c12581
patch link:    https://lore.kernel.org/r/20260520-init-v1-1-aaf2ebac5ad9%40kernel.org
patch subject: [PATCH] init: do_mounts: use kmalloc() for allocations of temporary buffers
config: xtensa-allnoconfig (https://download.01.org/0day-ci/archive/20260520/202605202055.kwkCHqR9-lkp@intel.com/config)
compiler: xtensa-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260520/202605202055.kwkCHqR9-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605202055.kwkCHqR9-lkp@intel.com/

All warnings (new ones prefixed by >>, old ones prefixed by <<):

>> WARNING: modpost: vmlinux: section mismatch in reference: try_to_run_init_process+0x24 (section: .text.unlikely) -> initcall_level_names (section: .init.data)

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

