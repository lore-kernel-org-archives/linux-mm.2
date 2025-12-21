Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF967E668BB
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 00:07:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E16176B0088; Sat, 20 Dec 2025 19:06:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC50A6B0089; Sat, 20 Dec 2025 19:06:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA5526B008A; Sat, 20 Dec 2025 19:06:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B8CA76B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 19:06:59 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2DF4A137ADF
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 00:06:59 +0000 (UTC)
X-FDA: 84241537758.18.F59760A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3CF6420010
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 00:06:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HPseGnIa;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766275617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ea71sJcyVvLAfh0ppoeOiLD+SCqKPexRnXP4BzsR+fI=;
	b=gunHo7JcKq14zeb0hEAM6oeZjMRk8TNbtGCmY8JfOchHXzBdBn70bAkLxiu+y4zkHOhnVO
	/Pf4l+DjlRCi8L6gL+t3d6xWa6nctte2yJ4nYo3p1V/sSN/ZeHSagFeMHyo/MhFMM16UZJ
	m9fvRh6A1xAu8lM7Qn5mb8psDbha5qI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HPseGnIa;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766275617; a=rsa-sha256;
	cv=none;
	b=DKf0XS2A2xHVlvOSUnGDZKp0Z7YamZc7pKVmFteKaifOZeeXEGoOxCpUqwI4j5whStIfh9
	jqrQI+ohAuRoMkbpO426ZCWeTtpXglkphr9xHnJEUTY0DoDFzYsIlsfvEdS/mbS8tCQr32
	tAdL1ADyRW8T/n/7boXPykJmADRPiGE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766275616; x=1797811616;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sOt6CEZpOSyORmbi/kzA8CZ3ShnRxK4EN8upthUlT8w=;
  b=HPseGnIaSN2T6xhiP30sXW+O21W8AVJ4edOh9haMxUnpBtDxjTlCdyqB
   bQsCUegYrreML5aO1/syxXsRC3mum8numVT1dKvbE3zZFsKOc+8MyVl6p
   kkLaMbJo8i9PUuHzhjVqF3w2wfeekIm6vAVuUwDD6KkzrbZXBWwsUM0W6
   L9AK0cgNpQGy/Jr21MieUKp0DNN9RQ50ehqC70ZzJcbz4rpWGhTbnIyXT
   YhTETLJQt8PYL7TJ/63ZEhI4N8EfMTl/qqDDPGVQm8RuUY96kWK2WHugz
   R4FLCIOp+lEf2xmXSq5NSoK/QEjeA0zqAIqCgMd5a18OIwMdS2foQtbe4
   g==;
X-CSE-ConnectionGUID: aGxs2ChpQnez6tkdeoqCKw==
X-CSE-MsgGUID: sFQWLqUyRna6Go+3iN6kIA==
X-IronPort-AV: E=McAfee;i="6800,10657,11648"; a="72035920"
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="72035920"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 16:06:55 -0800
X-CSE-ConnectionGUID: uQzW/VJJQIqjaHIxzp2Fmg==
X-CSE-MsgGUID: JPj19i+eQvy24iR01DTvYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="199099060"
Received: from igk-lkp-server01.igk.intel.com (HELO 8a0c053bdd2a) ([10.211.93.152])
  by fmviesa006.fm.intel.com with ESMTP; 20 Dec 2025 16:06:50 -0800
Received: from kbuild by 8a0c053bdd2a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vX6yG-000000004qW-0ki6;
	Sun, 21 Dec 2025 00:06:48 +0000
Date: Sun, 21 Dec 2025 01:06:34 +0100
From: kernel test robot <lkp@intel.com>
To: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>,
	Will Deacon <will@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Boris Brezillon <bbrezillon@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: oe-kbuild-all@lists.linux.dev, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, Joerg Roedel <joro@8bytes.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Asahi Lina <lina+kernel@asahilina.net>,
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
	iommu@lists.linux.dev, linux-mm@kvack.org,
	Alice Ryhl <aliceryhl@google.com>
Subject: Re: [PATCH v4] io: add io_pgtable abstraction
Message-ID: <202512210130.LVNt1EfI-lkp@intel.com>
References: <20251219-io-pgtable-v4-1-68aaa7a40380@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219-io-pgtable-v4-1-68aaa7a40380@google.com>
X-Rspamd-Server: rspam02
X-Stat-Signature: bmreg8w1w9frpk9xgc9g6thhd7fqkhdw
X-Rspam-User: 
X-Rspamd-Queue-Id: 3CF6420010
X-HE-Tag: 1766275616-498686
X-HE-Meta: U2FsdGVkX1/YbPfWedGsDtPX2E4r+M5yDfJuDmJ3Ys7pnVtkLUK9Thd62pxRlWiQ9PeuYZ5UFpPq0l3ODHZOSYySAIbw3y197USWcSHe4RboZ9SoSW86wCLUXKm6A+WJf3pnpxbNAT0/kCMjwfLUNNei6VgB24nikz0YQ+Wu99zJfhEIv/JpO7++HkZSJUw+sRIZN/QNUuSU3CgjDMpMwUqlgFOenwTu8Pjq83jyIhSttyfqVEnVvA9oKLHTxybGYOgOWDJInDu9huEtnFiOm9cs9Hk/uVt/Os1nVOkMqKaRkF7Gl9DbBOBfxqvlE244cQlFRMJhmv4RrDL9pyxgrhXczQhf8ECXcUZvrEGLYAD6940zMa2ujzqcLII0xX0F+u5ki2+SG7OcHVo/bChvbGC/jdwitAeDNHe/QXHKEDbXsMWfOD6rGdWnc730e4PJGkTfygVPa26XGm7A8PlYOD9lRaSVpv8CO2KSZ9s0BZ1lOx7PvfKst7eZ26A2Mt6a9Z/oCXQhoAUrRr2Mm4tPlTR2clpdqZ53gYLLQwpbYLjU24NV1z/O6DsHIrGdRmMQa9F/x78Zdo/T7S+ig42AeNzB1uh0pzkz2VOI+Xc+VIoHp49EqLK4oc7jaa2+zz3mFa1nv3gmwxN7Xm4F4KEZhHhfJuO5wWyKf/vpHPeqDZ4OAS4TR0N1z5BdD+M6paCK9L53Y68Q4WO600Rd/KZqsiGJWd75QneXpAqj8+/knNBl0hwo0bbfzwZehZSrOZRN5Or4y2hXgEbt1TRWpWDTz4H2VeJyX8IWpqE727jFs7Ck7kIlWKVNLXBwpJf/L6SQU5ev51yptBxf1inTry0YtF+4pnrj8WgnbBppXXFF1PH+BX7zJnAWEkNqMNKMBYXTdLn0oH8aISiRi0f3t8FH31i9Lt+8wOD8tlhHk4Lbpq1w/JaOQb5THlJXQV1ddxr6NBvqnMfQo9ekD+iuCKb
 /F4WNu8L
 UgfDoEkt9rQqNs8n4KQNEwYi9qH5V4Gy3HMgqG3/ZnF7yuhQfvR1kcfCjz6QilrAQfF3mIuxfS85FO35rYJmSkA/BKDUq/AcIQ8X4rlJZcookgYFDhkMTOMYYZbhBRlsOLumMy161KWxtNxSFMIMwMLMJCkQ3fcqZ2jifeABVLlWiaURYYePo4kQtMKD+IUgZp4iVBk2fuOJ/Sul7u4V5PYzv68UtIJ1U+05yQu35UHNMz9N48KxrGItMFSfvVDpcBS675sDxKOZYMpccv62hAa3UGnZsM6qjRQVorjGd4FPFFqxmX458DX2u7fLgVMCBLOrENCi2SMicTFY8xPHPmRGK98FaIIqTNmduggQ7U3O4k+SSx4+YE59ygNaBJF59ckoLQwKiB6iY5Yct9f+cTB9/PKiCMiJx1epKB2whSsFNwipxfkks/HKc3WhcDQwNJgbj4SxUGonoi3fE4cr+I2hywcTalSCy1P86mo7cRiEnITal3Ly58tbdekKzbO9mPPyWvW/f8kau+8xLLxPhmZ4qi3TgUxG3tqs1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alice,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 3e7f562e20ee87a25e104ef4fce557d39d62fa85]

url:    https://github.com/intel-lab-lkp/linux/commits/Alice-Ryhl/io-add-io_pgtable-abstraction/20251219-185557
base:   3e7f562e20ee87a25e104ef4fce557d39d62fa85
patch link:    https://lore.kernel.org/r/20251219-io-pgtable-v4-1-68aaa7a40380%40google.com
patch subject: [PATCH v4] io: add io_pgtable abstraction
config: x86_64-rhel-9.4-rust (https://download.01.org/0day-ci/archive/20251221/202512210130.LVNt1EfI-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251221/202512210130.LVNt1EfI-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512210130.LVNt1EfI-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> warning: this function has a `#[must_use]` attribute with no message, but returns a type already marked as `#[must_use]`
   --> rust/kernel/io/pgtable.rs:162:5
   |
   162 | /     pub unsafe fn map_pages(
   163 | |         &self,
   164 | |         iova: usize,
   165 | |         paddr: PhysAddr,
   ...   |
   169 | |         flags: alloc::Flags,
   170 | |     ) -> (usize, Result) {
   | |________________________^
   |
   = help: either add some descriptive message or remove the attribute
   = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#double_must_use
   = note: `-W clippy::double-must-use` implied by `-W clippy::all`
   = help: to override `-W clippy::all` add `#[allow(clippy::double_must_use)]`

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

