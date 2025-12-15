Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BBE5D5B861
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 19:08:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FF036B0088; Mon, 15 Dec 2025 14:08:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D6CE6B0089; Mon, 15 Dec 2025 14:08:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D5726B008A; Mon, 15 Dec 2025 14:08:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1EF1B6B0088
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 14:08:13 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E439913571F
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 19:08:12 +0000 (UTC)
X-FDA: 84222640824.08.3C73F18
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf25.hostedemail.com (Postfix) with ESMTP id BFD2AA001C
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 19:08:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lO1rNYrD;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765825690; a=rsa-sha256;
	cv=none;
	b=0a2swCVCbGr3JKDyf8CDC8r/eXZbAZbVluCs3APTJPYMcvJmotfCV1Wr6yXfU9jwGZWTZ4
	j95iGfydm2y/MRzMJanchz5RLz4rIHrsKTr/6JhjidjmrUz2yoD94Zp3QRGKgOYI8hhlJS
	VV8CfatIBhuBFNyjseumAlWvAkcQ+dg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lO1rNYrD;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765825690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ekhfO2HIgfZw+k3btx5aa6R6J9CJAk9FRhUYShiJbNg=;
	b=G9wct/WmEB6Q0mXtEaL5idrD6nM4++iIe1O5KkPvg/qb2ogynw2XGdCTtmuyP/PTknjA2U
	260VjrB00qqeVjGEARYl/fSOCjOkhhj3OPrswoCe79TgzABQoKP3I28A4BTNBEbsgrIr9Z
	+2VQ/77IE/zFFvW3hd7p84i7J4hYhyQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765825689; x=1797361689;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1JDNfp0Z5+nrp/ObFicZ4XwSPUDiATXg/OEvzD6472Y=;
  b=lO1rNYrD5OzZM9A2EeOANP8yApATzB9JZozRDlgNsMCcFCZeMCLrpkzQ
   K98/l+2y6bfLuut2zlRmze4/d3FzkJErrAhQreczcQQgYgF34qCI3reoz
   izGwna6l6Iv1E5GZXzmZhW1xnkWNUuuakmtZtWU81V+PoqOjUzFhCdR10
   AAWXIkAoAvnL/1K7n8vuYWXCL4+uJLwMTi/ootxPfANTZWg7QfaBeK1zB
   tcFVXcQCbUNTvGpgKdDhRprf5pDEsVsvyANVbzk1VsYmu6+d5d06B6RDx
   OLB2OKCsGJLwqMPbmf7XZnyd/GnEFHQwCG8Ym3MlmTaReAo+k2j70vE6o
   Q==;
X-CSE-ConnectionGUID: 8HJcsdWqQmmNPfcPgkCRvA==
X-CSE-MsgGUID: CJZUUWfaQG+dLOJC45C/HA==
X-IronPort-AV: E=McAfee;i="6800,10657,11643"; a="66921510"
X-IronPort-AV: E=Sophos;i="6.21,151,1763452800"; 
   d="scan'208";a="66921510"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2025 11:08:07 -0800
X-CSE-ConnectionGUID: mM3qZZf/QHyrBDdX5VBDKw==
X-CSE-MsgGUID: zlwDi811Sa2s2GleHZKjPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,151,1763452800"; 
   d="scan'208";a="198626807"
Received: from igk-lkp-server01.igk.intel.com (HELO 8a0c053bdd2a) ([10.211.93.152])
  by fmviesa010.fm.intel.com with ESMTP; 15 Dec 2025 11:08:01 -0800
Received: from kbuild by 8a0c053bdd2a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vVDvL-000000002kO-0LU9;
	Mon, 15 Dec 2025 19:07:59 +0000
Date: Mon, 15 Dec 2025 20:07:47 +0100
From: kernel test robot <lkp@intel.com>
To: Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org,
	akpm@linux-foundation.org, netdev@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	kernel_team@skhynix.com, harry.yoo@oracle.com, ast@kernel.org,
	daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org,
	hawk@kernel.org, john.fastabend@gmail.com, sdf@fomichev.me,
	saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
	mbloch@nvidia.com, andrew+netdev@lunn.ch, edumazet@google.com,
	pabeni@redhat.com, david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, horms@kernel.org,
	jackmanb@google.com, hannes@cmpxchg.org
Subject: Re: [PATCH 2/2] mm, netmem: remove the page pool members in struct
 page
Message-ID: <202512152043.rdzLcS1a-lkp@intel.com>
References: <20251215071001.78263-3-byungchul@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215071001.78263-3-byungchul@sk.com>
X-Rspamd-Queue-Id: BFD2AA001C
X-Rspamd-Server: rspam03
X-Stat-Signature: wetcum61jua3fyxtcmgmy4hift8nbmxk
X-Rspam-User: 
X-HE-Tag: 1765825688-216939
X-HE-Meta: U2FsdGVkX19I8fMOqODJiGak9Iqa1uPY7p0iwtzePPGBmZy4SrcH0bgCk7R9ftsDRqlDVKqKPNljeYD/2qJJqXtmMCVuJwlXSH1SzxmDgA1PGbdziA66IEpJc8lC0zR7XkhcUUjjVqR+BTooNep8kk5+5c2Y35USlJGhnahdv7KKx+K5VjcT4iLFBqKnjAFGjest9XQDOfWXbocrOmA4dRHrFrM8Cbve8VP90k04gJT2ugRSgXHWLbU9ioY9cO9G6BnvQarE+sF8Oq8FRQrlwFzelD6TZChg9QLmqHK3L5lLNkk5Iqcs7Ypc5zXHI8pCzoPEerBMVay9v6ve6RTrdpZAVE6Y42thQ/smBVwr6csRndq+ghzwZFg5m/fsh6VR6WMxdNDR9D+aTGHl+ufFti1aWv4HvFq3PDPfCxitwxoitUOi65I/HlB1J8i59OeXVpDvWTumIcJiqrf1naSsiEKOM7LoPEmh1Zxu+b36csIEqbUfV3FScYcY27pt6D3hKaDQ0V4NaqNMh/Pb3zgXFt2L1qjEXtLHgF0XVzuY29M+/3smqVb5TzD2f1ySyrvoCOGKMXXWUwZ2kntzMjZJUTOMCQkV2ThxdCgzUT65YSuQ/o7uMVo1xsxGAp+5+Iici9KeWFv+YEBdqf8VhRj+PPcYBFGDDSXfOk6+5rCo3SP+C8VSXPkVYakhS5CLs/Pe1KVW9jRwWVECOMckCnuoYavoF2yPFDxoG90CTU20ojwxF60c/EPdFY7lJEb3kVgp7YqnXXjauqjbPqMGCi9vFFgPrO9NM5s1FAwk2kY7XFbnfvTRou45L/ym7CM4fKPHtemT/4F1exzdtLOY7hMnC7Rx/mDEY7BDjR5yhJtQ+V4DFN7nCexftWabfutZJla12adRfcFW7wgyOTkHb0Ctj+Sw5DC+FS6nL0QnjaaSEpS0TljeDWamXRvk6plJJU4TJANSN4KYPkCatRp3aFc
 btAOSrcj
 uBK3HlJaNEJ0XNTqt78xeswAt3Y7GHmLfEAfm5W7w2Tn6qBo+GJ9a8v1vxkQAFmDEihZfim6r22zKtkK5kRKoOmiYDusD0ONw+O04VqY7VQ2v46D2kTnyS5vpzA16ru2w07bwL0xdPKs8Bz7QwL5B6HqrkKomOacHKm6lJsnKMYg0in+5hqJLCVj6Hw0BwKIXq6/LiZcjNNyB6NJl6xK8AIkVhT5SDt7PQMksI3IAIsSOk5Zqx4ci6Z0abS63dF6PMXLppOCXJHP9d2vED7IFpPUXhPLpuUrVR+Gra17BlL10GdvwwBesd8m364P9R6BfPd87NHGMlxEPQbaOJv3veo+e4AHWzOGfq0bIJa898rB9l7sO1CMRRKVDURTNAs3rV0FWVanDcr/TaiSVKuThnAkftYFdrW2c/r14eOzzSMWiTDE4j+f74Ygq0B1eXJMncdsWb/B1hv36LWbLMrxcoPoL1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Byungchul,

kernel test robot noticed the following build errors:

[auto build test ERROR on d0a24447990a9d8212bfb3a692d59efa74ce9f86]

url:    https://github.com/intel-lab-lkp/linux/commits/Byungchul-Park/mm-introduce-a-new-page-type-for-page-pool-in-page-type/20251215-151232
base:   d0a24447990a9d8212bfb3a692d59efa74ce9f86
patch link:    https://lore.kernel.org/r/20251215071001.78263-3-byungchul%40sk.com
patch subject: [PATCH 2/2] mm, netmem: remove the page pool members in struct page
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20251215/202512152043.rdzLcS1a-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251215/202512152043.rdzLcS1a-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512152043.rdzLcS1a-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/net/ethernet/intel/ice/ice_ethtool.c: In function 'ice_lbtest_receive_frames':
>> drivers/net/ethernet/intel/ice/ice_ethtool.c:1254:36: error: 'struct page' has no member named 'pp'
    1254 |                                page->pp->p.offset;
         |                                    ^~


vim +1254 drivers/net/ethernet/intel/ice/ice_ethtool.c

0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  1223  
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  1224  #define ICE_LB_FRAME_SIZE 64
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  1225  /**
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  1226   * ice_lbtest_receive_frames - receive and verify test frames
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  1227   * @rx_ring: pointer to the receive ring
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  1228   *
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  1229   * Function receives loopback packets and verify their correctness.
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  1230   * Returns number of received valid frames.
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  1231   */
e72bba21355dbb Maciej Fijalkowski     2021-08-19  1232  static int ice_lbtest_receive_frames(struct ice_rx_ring *rx_ring)
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  1233  {
93f53db9f9dc4a Michal Kubiak          2025-09-25  1234  	struct libeth_fqe *rx_buf;
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  1235  	int valid_frames, i;
93f53db9f9dc4a Michal Kubiak          2025-09-25  1236  	struct page *page;
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  1237  	u8 *received_buf;
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  1238  
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  1239  	valid_frames = 0;
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  1240  
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  1241  	for (i = 0; i < rx_ring->count; i++) {
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  1242  		union ice_32b_rx_flex_desc *rx_desc;
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  1243  
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  1244  		rx_desc = ICE_RX_DESC(rx_ring, i);
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  1245  
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  1246  		if (!(rx_desc->wb.status_error0 &
283d736ff7c7e9 Maciej Fijalkowski     2022-07-07  1247  		    (cpu_to_le16(BIT(ICE_RX_FLEX_DESC_STATUS0_DD_S)) |
283d736ff7c7e9 Maciej Fijalkowski     2022-07-07  1248  		     cpu_to_le16(BIT(ICE_RX_FLEX_DESC_STATUS0_EOF_S)))))
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  1249  			continue;
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  1250  
93f53db9f9dc4a Michal Kubiak          2025-09-25  1251  		rx_buf = &rx_ring->rx_fqes[i];
93f53db9f9dc4a Michal Kubiak          2025-09-25  1252  		page = __netmem_to_page(rx_buf->netmem);
93f53db9f9dc4a Michal Kubiak          2025-09-25  1253  		received_buf = page_address(page) + rx_buf->offset +
93f53db9f9dc4a Michal Kubiak          2025-09-25 @1254  			       page->pp->p.offset;
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  1255  
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  1256  		if (ice_lbtest_check_frame(received_buf))
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  1257  			valid_frames++;
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  1258  	}
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  1259  
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  1260  	return valid_frames;
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  1261  }
0e674aeb0b7790 Anirudh Venkataramanan 2019-04-16  1262  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

