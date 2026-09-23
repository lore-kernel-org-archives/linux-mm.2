Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26171C982FE
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 01:01:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C660F6B0088; Tue, 22 Sep 2026 21:01:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C16BA6B008A; Tue, 22 Sep 2026 21:01:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B05476B008C; Tue, 22 Sep 2026 21:01:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 893D36B0088
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 21:01:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 86A87A69E3
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 01:01:09 +0000 (UTC)
X-FDA: 85243223058.29.9DF77A6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4CA6FA0006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 01:01:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=m9WvB6Bn;
	spf=pass (imf15.hostedemail.com: domain of yi1.lai@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=yi1.lai@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790125267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=P+t5RENf2Fs21pE5f7HVTrFUVpWRyZj8Ly12rko00/0=;
	b=snWmcGqNbxYFiBd2QZQgpOaz6L837WuGOHFzG2i2N25NFPvolXqMLisbb4oItdH8ny49ts
	Jvw2rbrQx47TFS3isjkoWF+cPA5IDPrD/V7WgT3kSVPF+BJCpY3C8EymFe6vggr816I50O
	TMSOK2PAmA95ejMzsN3ghXXS/SqU8n8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790125267;
	b=GeE6t00BUG22z+MckxZsDU/wwKsYP/2zWU2xiKxAK76BXzE/Xc+KSTkAMJVFvxXfgxDvc1
	NWgWg1qK8fdjRVSy9u4pBjzix9aKgGJt4c3c/V72oCcAEOtWnTOOgpxJ+k6WqsDCq0P1VC
	KnGQt13/FsC7t6P0hsFsPY/vTp9Pn5o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=m9WvB6Bn;
	spf=pass (imf15.hostedemail.com: domain of yi1.lai@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=yi1.lai@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790125266; x=1821661266;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=74O1kp/nZApmmjBc7sKM2+VS4aA5/+dj08DdtbaNMyI=;
  b=m9WvB6BnXE9fzNfXH3akfAGeIiOw67UXD1qmxa6IJ9Pbk03TNv8Fje5G
   W26LgT9gIlYTTOCH/QJK0nJwBu5JkkOS5iyAjAh4jFwnFC8yUnKGF6W4k
   QcHYPlUCXfqg7nBbWRa3Z7JeWCoibha6llWkZqlz7QnGqIP+tbKFYJha7
   D5aReE8H8fcwNvjcYCgHgcJez/bvpvVSRT7s+ic9PfhWGYSxVoiTKCxaw
   yjr1YzPnGhZc5f6w7a/JYXok1hMjgLEsVWoMakQZ/bRuPLl3CR0BlVMmF
   cGT9WEMtFdU4PHdK9H3c66X0eV4D5jddbkByqcgPp48JKFB39y+Oaq929
   g==;
X-CSE-ConnectionGUID: 3He4yJ3zQZm8pQUGSNCYNQ==
X-CSE-MsgGUID: 7pbYweoeTmquY9H+gUq8DQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="116303997"
X-IronPort-AV: E=Sophos;i="6.27,117,1787036400"; 
   d="scan'208";a="116303997"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 18:01:05 -0700
X-CSE-ConnectionGUID: ti1bcWrYTQuQFr18gyFW6w==
X-CSE-MsgGUID: +8ft8is0RFGwWC+LqX5l9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,117,1787036400"; 
   d="scan'208";a="281446757"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 18:01:00 -0700
Date: Wed, 23 Sep 2026 09:00:57 +0800
From: kernel test robot <yi1.lai@intel.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Daehyeon Ko <4ncienth@gmail.com>, Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Hagen Paul Pfeifer <hagen@jauu.net>,
	Jakub Kacinski <kuba@kernel.org>,
	James Bottomley <james.bottomley@hansenpartnership.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org,
	yi1.lai@intel.com
Subject: [linus:master] [mm/secretmem]  97d34aa65c:
 stress-ng.secretmem.ops_per_sec 99.5% regression
Message-ID: <202609230824.7a9189aa-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: na8h1pt8n8cfhwtuiq8kzxas69bet7oj
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4CA6FA0006
X-HE-Tag: 1790125266-11623
X-HE-Meta: U2FsdGVkX191L0IN+GMijm7hGW9pGY5qG494Y1zoDu9m5BJ1y4mmuhcAFEoDxuXJwyZpY3n0zLc+Pd6M35OvSXjpW5zmoHzB2AzvwHJCmQhSxOiBCLEO689ihj8hS+66/6K1NfxYxQxRCf0xK7gebscQYcS85UaDtiwMkpkjFOcl0bkSxPKHTdFW2bUuN84UhaQaGjX3Ijff9rNmoyevFIAYrmiuE5MZDyuTE88zPD1ot0wMiCN54120QYUEyxnOeK83VFDemGcYh9sTuj58rGqI+2b+k26Z1KxAGdYMMZkkHHB+B7XcMalHfBjzcVaYoAXeoWUReV1ki99PyikhxnIt991o4MRoaI1NOTuHFgKkSHZbbZx5w2gLKdc84v4gWctsU07KmcQo1jhUkRhTG2CO4WvG/55D4exEn3M7WryxrqAOgdlfbT31+Ya8WqKSITW+qk2qDImkD4cIVMCNaQ1nyHRhw35EFb/Kvw9ZRwDhZpykAggBBPttlbeeYL38+sLMgeoQwdXhgzaEFU7uPt4I/S6ptcdcfq170wdoyTyJJiS3DlRLEq+jTeK4QIkWn1wVwxFs4pTdCqoei6Nd1909K81Spedu92jEe57vooiIbLgs+ucFVTxAq60NEg4R8usIDDWNJ8/KRnceBiBqBd9JBJCYaONvvDhv1NoujxFrSX3/eur2b9UJEE4AnCfVkfZWj9N5MYXXxIzmNCnsizzEUKzcqqF9decZBcgjh13Kn1VUloHSzr2mtWgNBTNDFw6XzYG4zXziOCF9j8+Px+NcCMd8AxP4qcNYTFNhja+xYQFmXWlBWhJyThkVTXrS14iqGPrjGGc6IefDBrxcd4j/ZaRvLqrDka1/7RW4n/PBL6InHmcdecy1zpqKW9sDokgTeRzeMN+BNsXBZxMiBWTv7RoE6aL2086UiYlgLYl81OyXeDqlxuW6KQ9MbYdfMHzKE2maEN8JC5NmsL1
 vUAAx6Wv
 K39igmkGqVGQ3dkKLYbry+7oOCKLyI39N6yk5P8hrvq65GGQMIS7T9GNTrg4i77kf3Acof5vJVA7afvJWU0ooIr5HNB6IKADBTpVlQnERwT9/opA7PSMwpS7VoO2wXzcK+CWygsOpprexGygjS0l629fjmtV2qONfJ9Ere55yCUm9Tg159kNZZHLyYZHE2srwxRoEZHr7VT9o6xsBzpgmGOOLozC2uedo0vGUn/lYCpUBoAKbcz0TiNhm4C2lGV7z4G+UQZc5d1NcWkERqVrzZ0vpETwmFL1BqtYlGOvwPa4PCxt9lzDlpXctqe0Ps+eYfaAwMKv1eWkRTggSt1OlDGxh8BNci6aCvMj5aGVsQcYm2bAJ40LSrcw491pggf+lrSYQRz0VhSljZriFE4FHGEu6V8Q1mEG7TGoCCr9n9sGhY/tZssIn0QZPcO+lhVdCIVGGKCDN/Xi3Lbil+Q2/2SxDIW2fgDOxZAMB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 99.5% regression of stress-ng.secretmem.ops_per_sec on:

commit: 97d34aa65c29cca85e3e9050f4c936389b38a054 ("mm/secretmem: properly account locked pages") https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 224 threads 2 sockets Intel(R) Xeon(R) Platinum 8480CTDX (Sapphire Rapids) with 256G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: secretmem
	cpufreq_governor: performance

If you fix the issue in a separate patch/commit (i.e. not just a new version of the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <yi1.lai@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202609230824.7a9189aa-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->

The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260923/202609230824.7a9189aa-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-spr-r02/secretmem/stress-ng/60s

commit: 
  35b0fb391b ("mm/mremap: reset unfaulted VMA page offset for MREMAP_DONTUNMAP")
  97d34aa65c ("mm/secretmem: properly account locked pages")

35b0fb391b0df573 97d34aa65c29cca85e3e9050f4c
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
   6080503           -99.6%      23092 ±  3%  stress-ng.secretmem.ops
     85584           -99.5%     385.28 ±  3%  stress-ng.secretmem.ops_per_sec
     71.48           -16.0%      60.07        stress-ng.time.elapsed_time
     71.48           -16.0%      60.07        stress-ng.time.elapsed_time.max
     97435 ±  2%   +1276.4%    1341103        stress-ng.time.involuntary_context_switches
    230308           -96.1%       9096        stress-ng.time.maximum_resident_set_size
  18401243         +3349.6%  6.348e+08        stress-ng.time.minor_page_faults
     20417            -8.7%      18639        stress-ng.time.percent_of_cpu_this_job_got
     14581           -25.0%      10937        stress-ng.time.system_time
     13.34         +1858.5%     261.33        stress-ng.time.user_time
      6898 ±  2%  +96037.7%    6631576 ±  3%  stress-ng.time.voluntary_context_switches

Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


