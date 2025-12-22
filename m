Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EF57D711D5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 04:10:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3B3A6B0088; Sun, 21 Dec 2025 23:10:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E8B26B0089; Sun, 21 Dec 2025 23:10:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F4C06B008A; Sun, 21 Dec 2025 23:10:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7AF7E6B0088
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 23:10:03 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2B34C1A014E
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 04:10:03 +0000 (UTC)
X-FDA: 84245779086.16.84A5001
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf14.hostedemail.com (Postfix) with ESMTP id A28D6100006
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 04:10:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=F4WkAHL7;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766376601; a=rsa-sha256;
	cv=none;
	b=hwGNmg3kphP4kV6L+ha4gls9CZ1U0TekhZldl3mP3iT4rGO6kdQuTmHlLTFAgo+t7OUL/K
	oTvJZVbYEPp5dFsYJJVwHkq5T7MPN/Y0HaxpwZhHf8Y7NokBrQ6xelsAJC2pCymyRbOApX
	TS7BLvEVCirxjRHhoyB+mHMT6wt+yFg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=F4WkAHL7;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766376601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IXh4SQUPnBYJoVrEOWmvfYguM/NpT84qvQ97p6ngaQw=;
	b=gH9PrIK5MTeHK0H0Ato22TX/RideiaiRVY/1+Pg+8voMAAL9hUW5hZZioRmNdZs2nZut2c
	kssxPlDnXQY/1n2YTckd0yWWFZu3Mwdt4mooHD7hBl6UdS2IUhN3SXI+se/mCeipObxRhD
	cLD5BwuKk4WIKXeyktSEhVbegXhQxiA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766376600; x=1797912600;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LbrlxqxtpWT8zxLBiWESgjycvjMqX+WEniDgPiHWy5s=;
  b=F4WkAHL7TSr+Q/5G6Qpl+lodT54+MLWdg/JRgVL0WY7qI8QFcLJ2NQDV
   ptl6htNSZQs0bXd0zMjIUslpZ+gYQUHLY5LGAtKJtJF5l8KunMep/uZEw
   GbY3s04b/UOkmsbnK/xP7iTcz6uB+tzZjPwK77LFEVextiQw49bkl16Ti
   vEq8bt6bWOBVq4afHjrYXbNxqbqUAMYQ3lsFK3wjuk9vzrUaXT5Ihmqla
   Q+Yemo8K9rUFoEZcCWGH3DDkSBHLuMYwDPgBAgtFoVYARaGa1HanZFG5c
   VL4+pp5/xF9bRsWQOqrrKrDqqAL2n0vSTvRSBxOJPB+oDJzqkFpP5lnF7
   A==;
X-CSE-ConnectionGUID: 6eseqriuR16ZrzfwREh5jw==
X-CSE-MsgGUID: VDxu0eboSvGku6e77Gsg+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11649"; a="68212848"
X-IronPort-AV: E=Sophos;i="6.21,167,1763452800"; 
   d="scan'208";a="68212848"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2025 20:09:59 -0800
X-CSE-ConnectionGUID: K4WBsvVWRLS0ZGpOY/N/3A==
X-CSE-MsgGUID: OKGrv+sXRmqZfA0okPFGGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,167,1763452800"; 
   d="scan'208";a="230442847"
Received: from spr10.sh.intel.com (HELO localhost) ([10.239.23.75])
  by fmviesa001.fm.intel.com with ESMTP; 21 Dec 2025 20:09:57 -0800
From: Yuan Liu <yuan1.liu@intel.com>
To: baolu.lu@linux.intel.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	rppt@kernel.org
Cc: linux-mm@kvack.org,
	yuan1.liu@intel.com
Subject: [PATCH] mm: fix huge page table not free after memory unplug
Date: Sun, 21 Dec 2025 23:11:17 -0500
Message-ID: <20251222041117.44865-1-yuan1.liu@intel.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A28D6100006
X-Rspamd-Server: rspam03
X-Stat-Signature: ptoixyzy43dsizwajr16miak8jnoammp
X-Rspam-User: 
X-HE-Tag: 1766376600-467189
X-HE-Meta: U2FsdGVkX1/aHgQF28cZmpdmZWJq7yCGHGoyV6FZicFNtzqaf1vIOqIkH2d8jlS1AJoBuSI/IWD+zrKO8DdTEjBO3ZPoo5dCaUuRVP21u7rvhjaJdn/3HDYEQTb5lwjFRS3GdWEr/Em7Dpcq0v9Q+oFPzg+JRGwVCfDPAfXaCFYQLo9U/Qp5gDRIjmka9tpu7P3xuxsGiqgbKL5nl3LHdlv9BFkeVKHRDYPcT05yq5mofNmhZlgUcF9HGzQ99ogSKSfUoyelFAlB3hCsjmxmGRhNJwzh6mNKHVbKr+nWbUPNAr5ptIZgyqQzhJdPt3MKZYQsipU1pT4NtLgkhF7lzHt1xz8+V5mDP/cDuZ57C6J+J3PJj1O8vtQlabgMyiWQI1vyF+FjtYrA6otPvkjJOsr4X2uwA6AUwcj+BG0ONCVjXHS0sufPxv9eS3wZnnQK2gWcnjvT3PwDWNIsX9OedqAPGCJmq9eEp/5ou0oGk9+ct2k380bPWjpGjQp/WgrTMM+xi1NzfimDXc9C+8HGsNsTST9xjs812PFRItZSiaIRBM1LqYPqd3efo/4tKExaeJXfXbq77SEOb/LWI63jsHdzWv9wsuUEo6uP3BjQiuvpv69U4elVpsB0oRMMAD02ZQHM4HNu/YIcgsMgPXyzB/wVvYg/2zyRtFDWi+9nk+bIdHtEdMHd/YFCuGS68Zgoqbxzo0yMw6wi/LoFgLgCSHqkTWNEPSq67QweY4u1QYqwqLf7NFOkDcSxs7Otmfaum1xfvLiMQ/b6yyAJKO0NjtIKp8qZh4qrhDJ3mDSicDTl2bRNREvv6dwTOLdDbxN5g+qSFcH7C3zi2StvtDi5NJlceqfcCs9BhgPAHDkB2Pde+Qu8Aahl50xzmInKc+dFu/jjwKkNMb2TWP0Z/7GoqEpPwM7dyMYnBCofvuV/kythMQluitkQH+dywt8IIPi4NUQFHXEMgCOu+CO+93s
 mtvqcMBn
 7659x6nH9OBaWAeYHnyP1KMxcYMxt872sBo4UGlJZrBeQoMtka7bJvqJ4Wv9HcLXzgZhaUt/41T92UDdaS8KDu7aXBOOrICdKfBFlAMWL60YOKg72w5wTzU7uFgPnSxActr3Re5zbWDutw/ofTa1IcydkCH8h+AWaPN6EHFymWHMETbw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

newly plugged memory is marked as prot_sethuge via phys_pmd_init
without setting PG_head. During memory unplug, free_hugepage_table
frees the page table as 2M, but pagetable_free handles it as 4K.

The following test case of memory unplug for a VM [1], tested in
the environment [2], show that results.

+-----------------------+------+------+
|Check System Memory    |Plug  |Unplug|
|via free -h            |256GB |256GB |
+-----------------------+------+------+
| Free 4K page table    |257GB |5.6GB |
+-----------------------+------+------+
| Free 2M page table    |257GB |1.7GB |
+-----------------------+------+------+

[1] Qemu commands to unhotplug 256G memory for a VM:
    object_add memory-backend-ram,id=hotmem0,size=256G,share=on
    device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
    qom-set vmem1 requested-size 256G (Plug Memory)
    qom-set vmem1 requested-size 0G (Unplug Memory)

[2] Hardware     : Intel Icelake server
    Guest Kernel : v6.19-rc1
    Qemu         : v9.0.0

Launch VM:
    qemu-system-x86_64 -accel kvm -cpu host \
    -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
    -drive file=./seed.img,format=raw,if=virtio \
    -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
    -m 2G,slots=10,maxmem=2052472M \
    -device pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
    -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
    -nographic -machine q35 \
    -nic user,hostfwd=tcp::3000-:22

   Guest kernel auto-onlines newly added memory blocks:
   echo online > /sys/devices/system/memory/auto_online_blocks

Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
---
 arch/x86/mm/init_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 9983017ecbe0..1044aafd5d94 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1028,7 +1028,7 @@ static void __meminit free_pagetable(struct page *page, int order)
 		free_reserved_pages(page, nr_pages);
 #endif
 	} else {
-		pagetable_free(page_ptdesc(page));
+		__free_pages(page, order);
 	}
 }
 
-- 
2.47.3


