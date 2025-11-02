Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 249FACCF9E3
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 05:36:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E15618E0005; Sun,  2 Nov 2025 01:36:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9EC28E0003; Sun,  2 Nov 2025 01:36:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C66738E0005; Sun,  2 Nov 2025 01:36:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ADF5B8E0003
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 01:36:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B4F875B6C1
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 05:36:40 +0000 (UTC)
X-FDA: 84064557360.06.DC39F77
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf12.hostedemail.com (Postfix) with ESMTP id A1DDE40009
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 05:36:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IsgjeWrI;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762061798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8ALRySn4FAQfl67o6On7doIz3Eg+QtANMo7VjcnK4lA=;
	b=VAFUpRKwrvU8R0Akv2BXevykuEbXfiTWob4wjZ0HpY3ACf6wBQB1USUsUJNLTQG56R/sy+
	1lEBiTgY9XteDczRV2Lj56PqfLwYO/nLrMGXJpNnWJqYorxdZzwv8+rQ3laiNl4SmHbAhB
	EQCAigQq47gApbbZmyVOSvROJFr3J8g=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IsgjeWrI;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762061798; a=rsa-sha256;
	cv=none;
	b=C0oGbrZ/3iDU0pXCGsaXQDEBANhBQ+tTYWbVGR37w80kDN6WkYY7lGJb+wjPTg2yAknHyI
	Aj02oapVtu25cdZ5/b9UGUfftp5jxTrgBDBWWDhKqEAqoqhCRGrgYNvnEI2Xr8uJtinIhd
	R0oxSvZgyDrzg60zixa5f/yg2EHh7YA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762061798; x=1793597798;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=P4zSYz6qqEucl7ISwKBUzNynAg6PeT1LAtogaKcvv7Y=;
  b=IsgjeWrI8KtHqkVrN777XH9wn00Z73RYQRUeWU1bWznMvaBiOJ2A/8UK
   xkP0G6CpTSCTMkXS/vcn9bJg8ajJ2iH0eVk09u119oE/aQFrVCnh0bMBL
   oafda6ZmELpgrRz4sXi+ohZwGXnU3Z2Q4Kei9UEk3dzCHS2LBxb5NzDMv
   9+b8f2khgrZ0enrDfXB6tw/xuRxEoswSaE/p1eR/wV7c3HhlKVL1/UbXB
   hmlKtZkYNK9uANRPnCFxA71uJzb9pLqRMWUAuHNx2hkOGLv9bCl5ySqiX
   2DjzbIMfXYPUkwqcEK3ICec+qJGxWVczOqZeOkCxX+/ZBj3gewY0o09UG
   Q==;
X-CSE-ConnectionGUID: s7a6SzNETem0dGg59gGLZg==
X-CSE-MsgGUID: kKfXn34zSTuFNlon7GfhwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11600"; a="74848900"
X-IronPort-AV: E=Sophos;i="6.19,273,1754982000"; 
   d="scan'208";a="74848900"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2025 22:36:36 -0700
X-CSE-ConnectionGUID: PjCEx6rIRT+2XMU+NgASuQ==
X-CSE-MsgGUID: uvK4NMb6SzWEXbUOKrQcNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,273,1754982000"; 
   d="scan'208";a="186459633"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa006.fm.intel.com with ESMTP; 01 Nov 2025 22:36:34 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vFQlU-000P1g-1L;
	Sun, 02 Nov 2025 05:36:32 +0000
Date: Sun, 2 Nov 2025 13:36:16 +0800
From: kernel test robot <lkp@intel.com>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Guan-Chun Wu <409411716@gms.tku.edu.tw>
Subject: [akpm-mm:mm-nonmm-unstable 87/91] lib/base64.c:36:28: sparse:
 sparse: Initializer entry defined twice
Message-ID: <202511021343.107utehN-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: A1DDE40009
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 6nz6ssysbo4sy97zpw1ise4xoocqwspe
X-HE-Tag: 1762061797-146087
X-HE-Meta: U2FsdGVkX1+zbjfSfTehQGv1FsOLKtgliT7Wo3VYoMh2SCv8PSimzvZAbfQBJPKkR/cveeZTyRchJ+BqL7UqUc0A6H7yetkGMOvI/eZH7dh7NiHg1/Hz75i+uWq3kvz51I9kUZvuTZftjTlX0FfjIi3TFkrax7eE7GXG/EE9HdlkBtSSOfd70musCvk/Ikyhw4Claccu5o2pQBDqrlzJQ+YGvo1QpX3/rIdDqdlxlOTkL/uIvQbap8ac74+gMzwaR+UtYafDkYKZXrEdRYxjenfpRSbzykfgcv95oJ7ea5c66kfW2gMhBbFkaHYVRtvv51VvEN7ODFRjZ99XC8uJGw76yPj4vUZp7bbMnP8zMV5NdWYmpSBxwkuxK59yeeLHI1xewb3/uChQzrWfXESoNR3PDjS2SZgoGz4hhXU/P8OJEpRna8aRhLKCXq7InkrRa0l6jEYMhZhw0HEHPvJMNWCtngNh/KMIHZ3WfCLoKI8NeNbO1YEWOYEmvYObVpFejamQbaUM2DdR2jAPDTKPkqhOrg2BK90y2DJr8WocCi4Q0n/51lqvT9PP2AqD9zxFCHNiBi+KZt0V4ul4thW4offdPfLOEJCVfLwYwykR8HbHNjOxkWaZVp5yZcg52A/iGoQss9hq+DGeUkFg6OY/hxqH5ddDoAy0WwRXpOjwRCHuhqLp/ijlMvrwXGHPYoP+kCKOdPv0WlSEzXURBcdlUIVq8Ce+PM4QzmEdUSv+yQuUkaE5y+bAgB/X/lrEOifeIn/cTSwibcSgdiI5FLi+LhiCM94SSDSprMQrwwWBjlh8RDnm4p9wTDiurxvnoT7ZFwWC68esh64l3qBW0KSjXWv6TzD/KAZlRrV0ywXMtx1fmW7Y4LzT4vQxqOejEDGdcojWKTmpQcHe33Rv2PuXmeOjTTlP30Z9Cb4CQqiQ8Ee68s6peUsOB3BDJU9aq1Fek3dNQFpBcTDWs+NmTcc
 VD6tBAyU
 Ih9BtFbUjnduEP2oYlI1yZ0z3wETQYYzHLdtnPkXr+FqbOXqP9v2B0stcAIBIkxFTWEz8KK4yd7GUN1j4TYG1JNmkezs3EtBFVSEOvBQHnHbwmheJ3GLt1SXLJbsfSSyzuENNmTuI8PbqMT2fWhK8kCcWtA7IhyiUjo7QaxWRMwBTR1qk/gIkwrkIzDjG+WKN1fneW9p+L1+w3hvJ2EgJ7rGCHuobZ7DycqZ9uz3js3r0jxR3pDZDas5SIAv9dmCl2ensuzvcB6EOXKPs0lLS6yjuhRfN3M4rpPkzK3hgA+49T/pWjXsXlTsPSyDz7z6jpSJdabgfqqu1Drg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
head:   97751db460a7c6988b2ab988d9889d4309f9cc8c
commit: 5b693a7ad2acfa88e8ab0a047335ea4c94fecdb1 [87/91] lib/base64: optimize base64_decode() with reverse lookup tables
config: m68k-randconfig-r123-20251102 (https://download.01.org/0day-ci/archive/20251102/202511021343.107utehN-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 14.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251102/202511021343.107utehN-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511021343.107utehN-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> lib/base64.c:36:28: sparse: sparse: Initializer entry defined twice
   lib/base64.c:36:28: sparse:   also defined here
   lib/base64.c:37:25: sparse: sparse: Initializer entry defined twice
   lib/base64.c:37:25: sparse:   also defined here

vim +36 lib/base64.c

    33	
    34	static const s8 base64_rev_maps[][256] = {
    35		[BASE64_STD] = BASE64_REV_INIT('+', '/'),
  > 36		[BASE64_URLSAFE] = BASE64_REV_INIT('-', '_'),
    37		[BASE64_IMAP] = BASE64_REV_INIT('+', ',')
    38	};
    39	/**
    40	 * base64_encode() - Base64-encode some binary data
    41	 * @src: the binary data to encode
    42	 * @srclen: the length of @src in bytes
    43	 * @dst: (output) the Base64-encoded string.  Not NUL-terminated.
    44	 * @padding: whether to append '=' padding characters
    45	 * @variant: which base64 variant to use
    46	 *
    47	 * Encodes data using the selected Base64 variant.
    48	 *
    49	 * Return: the length of the resulting Base64-encoded string in bytes.
    50	 */
    51	int base64_encode(const u8 *src, int srclen, char *dst, bool padding, enum base64_variant variant)
    52	{
    53		u32 ac = 0;
    54		int bits = 0;
    55		int i;
    56		char *cp = dst;
    57		const char *base64_table = base64_tables[variant];
    58	
    59		for (i = 0; i < srclen; i++) {
    60			ac = (ac << 8) | src[i];
    61			bits += 8;
    62			do {
    63				bits -= 6;
    64				*cp++ = base64_table[(ac >> bits) & 0x3f];
    65			} while (bits >= 6);
    66		}
    67		if (bits) {
    68			*cp++ = base64_table[(ac << (6 - bits)) & 0x3f];
    69			bits -= 6;
    70		}
    71		if (padding) {
    72			while (bits < 0) {
    73				*cp++ = '=';
    74				bits += 2;
    75			}
    76		}
    77		return cp - dst;
    78	}
    79	EXPORT_SYMBOL_GPL(base64_encode);
    80	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

