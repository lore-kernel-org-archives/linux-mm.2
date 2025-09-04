Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F017CA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 15:50:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA4218E0015; Thu,  4 Sep 2025 11:50:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7B818E0001; Thu,  4 Sep 2025 11:50:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB8788E0015; Thu,  4 Sep 2025 11:50:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AABC28E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:50:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5958A583B3
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 15:50:25 +0000 (UTC)
X-FDA: 83852004810.08.22708C4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5F9D040014
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 15:50:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iTLatd9F;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757001023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mI4ZBZL3Ia5lpIaHKSFLsQ7JBIVGHzEwCgn0Mvgh37w=;
	b=Pn+nPIXElYWdqMf//9bME/Kh98k4nEF3OHK1jP87fN1qRK7BdfKfLdJ5eXB7LOVQttwfw1
	s5SRgwIYFsilu6SCk7DBpf4b0VCDBcJb4i0bv8o3TBnf+pQDEn/kTc+MB809+JlU+fdK6B
	MPdBt8EpKgGl2QhnWiaEMrG+NT8WbBA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757001023; a=rsa-sha256;
	cv=none;
	b=BKXlyBdpn97uv2aQ9BBBN6tOizzPdTjtdMTdMLu77Slg/bxWEcyvqALSEqVIMOryeQU0cW
	jMdnNlK5YGCfCbM9lTPwi5/G25qbBv8vDglk+4sML/Rh88L3nE6JkOzp379uD7Bs2/OgjP
	vxhF0u6AuPXCPs+pdvjPlpZeemSQWRs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iTLatd9F;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757001023; x=1788537023;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=+VqBBhZBCeoAw2ubvhHyzZUkjrXEDSn1rG3+isinRcE=;
  b=iTLatd9FolZfckU4NSBvMfqx9gyyIC/IbZctLFhu3XccuruJs3RHnTAe
   uB+sRQF7krUsCrgT95paF/+pF+ZdBivray3nnTVa1CnpsxaTSNS2uneMD
   RK7OZZ6cLidZ3ItXZW6bjNy8N0+8RVblBGYKnu9vgrIWvDnMgbRZAHxR0
   ldTFJl8Ddpfy81M00zNza8uMSOaeMgDscf7ujluJInPd7AL6X8jSmwYQN
   f02KWnewt/7bF7pHD/yROV3YjcTM/6czQB1PyusC+asExLy/gCN3hrUQ6
   VHUnY9Hd0ZM9hvEcUp1IAxORGoaKudKxqflzAr3C1hmGGVWq7zx2u3DZz
   Q==;
X-CSE-ConnectionGUID: Aq/dl6JmQ8C5Lx4MTs02gg==
X-CSE-MsgGUID: W07d3GT/T1GQcsQumSYOjw==
X-IronPort-AV: E=McAfee;i="6800,10657,11543"; a="59044760"
X-IronPort-AV: E=Sophos;i="6.18,238,1751266800"; 
   d="scan'208";a="59044760"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 08:50:21 -0700
X-CSE-ConnectionGUID: eBtfQWtPSse8SygtQDuQRg==
X-CSE-MsgGUID: zkAOWk1hRiuPyQ/lgoRTWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,238,1751266800"; 
   d="scan'208";a="209108915"
Received: from lkp-server02.sh.intel.com (HELO 06ba48ef64e9) ([10.239.97.151])
  by orviesa001.jf.intel.com with ESMTP; 04 Sep 2025 08:50:19 -0700
Received: from kbuild by 06ba48ef64e9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uuCDM-0005S3-0e;
	Thu, 04 Sep 2025 15:49:46 +0000
Date: Thu, 4 Sep 2025 23:47:34 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [linux-next:master 6049/6355]
 include/linux/scatterlist.h:161:undefined reference to
 `page_range_contiguous'
Message-ID: <202509042330.paF1vmVV-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5F9D040014
X-Stat-Signature: cbrjswhigzw4tzotcu7rem8ywwktxd3h
X-Rspam-User: 
X-HE-Tag: 1757001022-949835
X-HE-Meta: U2FsdGVkX181trR5cT8+Vrbnz6T2t7FZBmGLSsNXSnWtJFXiiyti5hA7+Udt2dOeeqPNTIX62/SwjoqhhDpFH5MQ8Klzh4RrOgmlGDqiZp394tP/nGniK8nr+KFZkypvyFyLszQmnIdxb6MdmZVZ2/BNTBATh3hAErSTjyuXHBTT6Tn7dj0RLG3LYbTqFiLIE5eqMVakgTL+MxvYSL800A3WL7HjfwdjsWTa5jEfWUGTEtjaAH0AaFoBiCyjvLt66c8x4y32wuq2hUuF0Vnq36TKqTCVEkgaQp7NDcAcJA18cBWVV0WH993TjoZoTiPyjXC7K08+kjf+ihA7mBnNumqDoJ15RM9VXqC+eVGHJMALvEGAxFr4//WyV61NCr5qfEpNgHmOCRSuF6WqBuI3a+hAuZ0oCBukY7lzOJ0uSi3LbKe4ZFkS5psHeRRXrrXKMlQljr/dfLf3TT9QOvjEPkmHi/Enr5bh117WjrtARA4jNoHByQ4bs0NuXpz7/pinWrXt7umDstObJW8lOm+XqSEQE02ma6hinVqzJ80iUvBl4zPVH+xNmYSJXyAwhZSq0Z8okDEBztVC+Oau/M2DIMME8xqqZ6dJCBbA/ae4jBqVYf7tq06PY0/L2W45HNAPu/xAf2WpYbDluh1lchuUheIS+FOj4Jyc5+yrU2sKBulfVrslo+b/A7XW5g3Y7p4LsrbVNo1a/AL2gG9NuP5MIYChh6qSkDnJDKZ6ZA3J/JlCL5D1A0sNEOIzNcq0UIkivcK92g4Lgqiap8CGYRQtotNSgM6+cy6hORYiSynhSbjJmHDOocpZuOiF9gHfH+rC94ty3A2YiS1V42AP+w9rwmi4dZh64zM9EOknasVw2ME7FEPujYbgdmFVFTEcamwvih4+I3UTzINwDxDIH19dvDLr7ofW11N6+/8Ul9cq3nNJeAUHiuzlyeluOTF0oE2rfdgf1VvNWgreCUwZ8FQ
 +RfC8dYe
 eW/6SLUg7t8hXm1Z5GrxSW7pKHZnxbQ121JqDZSaGkV7kO//pPWuzUQd0E8v7bcA13UcpZEwXKwsJU+v1dtx8QGglgdE3ysE/Hx6han2ufVnkWN3chny0knLxMECyYER8RV7pHX53XvMo/RxMu3Z4mKSQmq5V+zyjnhBRhCZuyCXBUEsOhVCgNhSrbym6AKT8A0V1bwAUoj7QpiywQjPq+y48uUEnFvrIwRo1K6GG++h2QcjFNfay2QjEMX2JChEl7DxcSDj0kyrPU/+m2KY1XDoPSK+VHVXqI2fb5cBKpETL/W3LZLgGzJJl6lWiV4dMT2EBywquAqprGX0P9wTrgm+0MP4dczTpKuK7hkxoWafRuxDXbpqte5POmA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   4ac65880ebca1b68495bd8704263b26c050ac010
commit: 92c22f6cc03ea9d5b172276d6ae45c691993b257 [6049/6355] scatterlist: disallow non-contigous page ranges in a single SG entry
config: arm-randconfig-004-20250904 (https://download.01.org/0day-ci/archive/20250904/202509042330.paF1vmVV-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 13.4.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250904/202509042330.paF1vmVV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509042330.paF1vmVV-lkp@intel.com/

All errors (new ones prefixed by >>):

   arm-linux-gnueabi-ld: net/core/skbuff.o: in function `sg_set_page':
>> include/linux/scatterlist.h:161:(.text+0x1864): undefined reference to `page_range_contiguous'
   arm-linux-gnueabi-ld: (page_range_contiguous): Unknown destination type (ARM/Thumb) in net/core/skbuff.o
>> include/linux/scatterlist.h:161:(.text+0x1864): dangerous relocation: unsupported relocation
   arm-linux-gnueabi-ld: kernel/dma/mapping.o: in function `sg_set_page':
   include/linux/scatterlist.h:161:(.text+0x912): undefined reference to `page_range_contiguous'
   arm-linux-gnueabi-ld: (page_range_contiguous): Unknown destination type (ARM/Thumb) in kernel/dma/mapping.o
   include/linux/scatterlist.h:161:(.text+0x912): dangerous relocation: unsupported relocation
   arm-linux-gnueabi-ld: kernel/dma/direct.o: in function `sg_set_page':
   include/linux/scatterlist.h:161:(.text+0x64c): undefined reference to `page_range_contiguous'
   arm-linux-gnueabi-ld: (page_range_contiguous): Unknown destination type (ARM/Thumb) in kernel/dma/direct.o
   include/linux/scatterlist.h:161:(.text+0x64c): dangerous relocation: unsupported relocation
   arm-linux-gnueabi-ld: kernel/dma/ops_helpers.o: in function `sg_set_page':
   include/linux/scatterlist.h:161:(.text+0x52): undefined reference to `page_range_contiguous'
   arm-linux-gnueabi-ld: (page_range_contiguous): Unknown destination type (ARM/Thumb) in kernel/dma/ops_helpers.o
   include/linux/scatterlist.h:161:(.text+0x52): dangerous relocation: unsupported relocation
   arm-linux-gnueabi-ld: mm/page_reporting.o: in function `sg_set_page':
   include/linux/scatterlist.h:161:(.text+0x1d8): undefined reference to `page_range_contiguous'
   arm-linux-gnueabi-ld: (page_range_contiguous): Unknown destination type (ARM/Thumb) in mm/page_reporting.o
   include/linux/scatterlist.h:161:(.text+0x1d8): dangerous relocation: unsupported relocation
   arm-linux-gnueabi-ld: crypto/scatterwalk.o:include/linux/scatterlist.h:161: more undefined references to `page_range_contiguous' follow
   arm-linux-gnueabi-ld: (page_range_contiguous): Unknown destination type (ARM/Thumb) in crypto/scatterwalk.o
   crypto/scatterwalk.o: in function `sg_set_page':
   include/linux/scatterlist.h:161:(.text+0x296): dangerous relocation: unsupported relocation
   arm-linux-gnueabi-ld: (page_range_contiguous): Unknown destination type (ARM/Thumb) in crypto/ahash.o
   crypto/ahash.o: in function `sg_set_page':
   include/linux/scatterlist.h:161:(.text+0x272): dangerous relocation: unsupported relocation
   arm-linux-gnueabi-ld: (page_range_contiguous): Unknown destination type (ARM/Thumb) in crypto/rsa-pkcs1pad.o
   crypto/rsa-pkcs1pad.o: in function `sg_set_page':
   include/linux/scatterlist.h:161:(.text+0x54): dangerous relocation: unsupported relocation
   arm-linux-gnueabi-ld: (page_range_contiguous): Unknown destination type (ARM/Thumb) in crypto/gcm.o
   crypto/gcm.o: in function `sg_set_page':
   include/linux/scatterlist.h:161:(.text+0x3e8): dangerous relocation: unsupported relocation
   arm-linux-gnueabi-ld: (page_range_contiguous): Unknown destination type (ARM/Thumb) in crypto/drbg.o
   crypto/drbg.o: in function `sg_set_page':
   include/linux/scatterlist.h:161:(.text+0x10c): dangerous relocation: unsupported relocation
   arm-linux-gnueabi-ld: (page_range_contiguous): Unknown destination type (ARM/Thumb) in crypto/tcrypt.o
   crypto/tcrypt.o: in function `sg_set_page':
   include/linux/scatterlist.h:161:(.text+0xba): dangerous relocation: unsupported relocation
   arm-linux-gnueabi-ld: (page_range_contiguous): Unknown destination type (ARM/Thumb) in crypto/af_alg.o
   crypto/af_alg.o: in function `sg_set_page':
   include/linux/scatterlist.h:161:(.text+0x12dc): dangerous relocation: unsupported relocation
   arm-linux-gnueabi-ld: (page_range_contiguous): Unknown destination type (ARM/Thumb) in block/blk-mq-dma.o
   block/blk-mq-dma.o: in function `sg_set_page':
   include/linux/scatterlist.h:161:(.text+0x36a): dangerous relocation: unsupported relocation
   arm-linux-gnueabi-ld: (page_range_contiguous): Unknown destination type (ARM/Thumb) in block/blk-integrity.o
   block/blk-integrity.o: in function `sg_set_page':
   include/linux/scatterlist.h:161:(.text+0x186): dangerous relocation: unsupported relocation
   arm-linux-gnueabi-ld: (page_range_contiguous): Unknown destination type (ARM/Thumb) in block/blk-crypto-fallback.o
   block/blk-crypto-fallback.o: in function `sg_set_page':
   include/linux/scatterlist.h:161:(.text+0x3e): dangerous relocation: unsupported relocation
   arm-linux-gnueabi-ld: (page_range_contiguous): Unknown destination type (ARM/Thumb) in lib/scatterlist.o
   lib/scatterlist.o: in function `sg_set_page':
   include/linux/scatterlist.h:161:(.text+0x22c): dangerous relocation: unsupported relocation
   arm-linux-gnueabi-ld: (page_range_contiguous): Unknown destination type (ARM/Thumb) in lib/kfifo.o
   lib/kfifo.o: in function `sg_set_page':
   include/linux/scatterlist.h:161:(.text+0x640): dangerous relocation: unsupported relocation
   arm-linux-gnueabi-ld: (page_range_contiguous): Unknown destination type (ARM/Thumb) in drivers/char/virtio_console.o
   drivers/char/virtio_console.o: in function `sg_set_page':
   include/linux/scatterlist.h:161:(.text+0x3be): dangerous relocation: unsupported relocation
   arm-linux-gnueabi-ld: (page_range_contiguous): Unknown destination type (ARM/Thumb) in drivers/scsi/scsi_lib.o
   drivers/scsi/scsi_lib.o: in function `sg_set_page':
   include/linux/scatterlist.h:161:(.text+0x12b6): dangerous relocation: unsupported relocation
   arm-linux-gnueabi-ld: (page_range_contiguous): Unknown destination type (ARM/Thumb) in drivers/target/target_core_sbc.o
   drivers/target/target_core_sbc.o: in function `sg_set_page':
   include/linux/scatterlist.h:161:(.text+0x646): dangerous relocation: unsupported relocation
   arm-linux-gnueabi-ld: (page_range_contiguous): Unknown destination type (ARM/Thumb) in drivers/mtd/nand/ecc-mxic.o
   drivers/mtd/nand/ecc-mxic.o: in function `sg_set_page':
   include/linux/scatterlist.h:161:(.text+0x208): dangerous relocation: unsupported relocation
   arm-linux-gnueabi-ld: (page_range_contiguous): Unknown destination type (ARM/Thumb) in drivers/hsi/clients/ssi_protocol.o
   drivers/hsi/clients/ssi_protocol.o: in function `sg_set_page':
   include/linux/scatterlist.h:161:(.text+0x1b2): dangerous relocation: unsupported relocation
   arm-linux-gnueabi-ld: (page_range_contiguous): Unknown destination type (ARM/Thumb) in drivers/i2c/busses/i2c-qup.o
   drivers/i2c/busses/i2c-qup.o: in function `sg_set_page':
   include/linux/scatterlist.h:161:(.text+0x5c2): dangerous relocation: unsupported relocation
   arm-linux-gnueabi-ld: (page_range_contiguous): Unknown destination type (ARM/Thumb) in drivers/md/dm-integrity.o
   drivers/md/dm-integrity.o: in function `sg_set_page':
   include/linux/scatterlist.h:161:(.text+0x1566): dangerous relocation: unsupported relocation
   arm-linux-gnueabi-ld: (page_range_contiguous): Unknown destination type (ARM/Thumb) in drivers/vhost/scsi.o
   drivers/vhost/scsi.o: in function `sg_set_page':
   include/linux/scatterlist.h:161:(.text+0x602): dangerous relocation: unsupported relocation
   arm-linux-gnueabi-ld: (page_range_contiguous): Unknown destination type (ARM/Thumb) in sound/virtio/virtio_pcm_msg.o
   sound/virtio/virtio_pcm_msg.o: in function `sg_set_page':
   include/linux/scatterlist.h:161:(.text+0x2bc): dangerous relocation: unsupported relocation
   arm-linux-gnueabi-ld: (page_range_contiguous): Unknown destination type (ARM/Thumb) in net/core/filter.o
   net/core/filter.o: in function `sg_set_page':
   include/linux/scatterlist.h:161:(.text+0x4412): dangerous relocation: unsupported relocation
   arm-linux-gnueabi-ld: (page_range_contiguous): Unknown destination type (ARM/Thumb) in net/core/skmsg.o
   net/core/skmsg.o: in function `sg_set_page':
   include/linux/scatterlist.h:161:(.text+0x8e): dangerous relocation: unsupported relocation
   arm-linux-gnueabi-ld: (page_range_contiguous): Unknown destination type (ARM/Thumb) in net/9p/trans_virtio.o
   net/9p/trans_virtio.o: in function `sg_set_page':
   include/linux/scatterlist.h:161:(.text+0x62): dangerous relocation: unsupported relocation


vim +161 include/linux/scatterlist.h

   143	
   144	/**
   145	 * sg_set_page - Set sg entry to point at given page
   146	 * @sg:		 SG entry
   147	 * @page:	 The page
   148	 * @len:	 Length of data
   149	 * @offset:	 Offset into page
   150	 *
   151	 * Description:
   152	 *   Use this function to set an sg entry pointing at a page, never assign
   153	 *   the page directly. We encode sg table information in the lower bits
   154	 *   of the page pointer. See sg_page() for looking up the page belonging
   155	 *   to an sg entry.
   156	 *
   157	 **/
   158	static inline void sg_set_page(struct scatterlist *sg, struct page *page,
   159				       unsigned int len, unsigned int offset)
   160	{
 > 161		VM_WARN_ON_ONCE(!page_range_contiguous(page, ALIGN(len + offset, PAGE_SIZE) / PAGE_SIZE));
   162		sg_assign_page(sg, page);
   163		sg->offset = offset;
   164		sg->length = len;
   165	}
   166	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

