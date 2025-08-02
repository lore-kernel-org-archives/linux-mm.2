Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E4DBC87FC9
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 10:18:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2ADC6B008A; Sat,  2 Aug 2025 06:18:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B4276B008C; Sat,  2 Aug 2025 06:18:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87BCA6B0092; Sat,  2 Aug 2025 06:18:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 73BD86B008A
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 06:18:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5F890160BDD
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 10:18:01 +0000 (UTC)
X-FDA: 83731416762.19.CC3160E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf24.hostedemail.com (Postfix) with ESMTP id C3C81180004
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 10:17:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cX+1s4vu;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754129879; a=rsa-sha256;
	cv=none;
	b=gsCZj/5B4DdgdVn6Hwj5Nw3DdUISUNNA/YogkN6ulhh4SE5VjdzFX8dfWxMKIyuP4Alt5F
	kh/t7S8f+oupQGTDjYlyC3SRAPH1rngNqw3zfgRNb0oJJJ9IKaL3a23zLdIxP55Zj/q5iV
	lWvLOW4cy+xDezDKUs9fns77M8VoPqQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cX+1s4vu;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754129879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IMy5IM13dV4HLiyiLOKzJw8FAIZwPkAGdFIMgdjLzqQ=;
	b=zw1QfwY8dQqBnDeLNeT7qBpq96e8FEdtLl7Rz7yEmZQTxGNGuEF/lVYDf34YaATxc+flak
	6O69MK8+TfID6LYN2igle73jRaMBVzzNsKvMbHKfkqssxpxJWIpS66vjKahQB4GeavLHBn
	+vUCaYT7XdydXEtCNyoBe4XuyGLDTWc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754129879; x=1785665879;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=riNYIRqVoOoakrBnug7k5od3DJ5mfh+UAdeMk36JlMs=;
  b=cX+1s4vuNFD+UmUckJYDu9934I22jKOyLMZjsP6jtaWTT3h8TU5HX7b/
   c+fnu3qjCw+IzGICkWX5aTnzYuQdCHjOf90Jzybn8zbO1epQpps7Q3W5I
   zfTvdxJz/visqAnROfuGuJO/YbgzpbgYXVgew+9VzoX2/U9qmzFEBxUSf
   M93AHNMXUbzBnOOFmXNw+SpeMbhqBiccXWUvaUbrxBI0R6cbRP8fbSrdo
   2tp/jGTtT2YAeXiHVNmhNDkzjvUSJQPOyomRrNwznWmKDDXsa22OOw59w
   kSeTfxIkhkSc3HLMytZSquFvl+AsQA/mWUdL3Kn5h19AptpiZMfUmkDAF
   w==;
X-CSE-ConnectionGUID: fj7WRS1wSNm4Xh7Y5v5Khw==
X-CSE-MsgGUID: H4ixkGcfTAqzZ6uiae01nA==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="74052865"
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="74052865"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2025 03:17:57 -0700
X-CSE-ConnectionGUID: ALnym2G+Q5KJYzyyGR31WA==
X-CSE-MsgGUID: 7YIAIXgYQpKP/vbYvYF2kg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="168229114"
Received: from lkp-server01.sh.intel.com (HELO 160750d4a34c) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 02 Aug 2025 03:17:55 -0700
Received: from kbuild by 160750d4a34c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ui9JH-0005Iq-1f;
	Sat, 02 Aug 2025 10:17:51 +0000
Date: Sat, 2 Aug 2025 18:17:47 +0800
From: kernel test robot <lkp@intel.com>
To: Gu Bowen <gubowen5@huawei.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [sj:mm-new 40/108] mm/kmemleak.c:440:25: error: implicit declaration
 of function '__printk_safe_enter'
Message-ID: <202508021825.tUu2retW-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C3C81180004
X-Stat-Signature: nn6wgb7y3k4j6sncnwj78cqi8etsdtzo
X-HE-Tag: 1754129878-351010
X-HE-Meta: U2FsdGVkX18CowtRvZPeKD8zmjJbeIrDNwDWIqGRQ+BgQ3BZzhFNWFCR+olE/TKI8YXC74O7AJqqrUoY3/hRypEPqAdhho9eI78yQbT9e2IYNW1NDYby/+Lib9pwmNpiF5eNV3ppXc+Egl6loyS3ayvcw4EQ+gP7VmZku79fUBuD7Wk6gJMXYoJjkc4B28N9VoQmsdr1s2kkZjcWccYcN9AipWtG++bw4HYCeBpDXyzMKpfSbUnDvKakjjP7UuPVqTbykRBUVImNojtzvubA2VFXmfG7PcuorXcE8z+URqQvKTtvN+5nJ49ra+GHp9bin3G6rKanPdlvnhtSm74vAqkrPYTXZmB+zeNNYJzyQeDaecx41PhBpPhWh7A6z9OCIczhpde5Cmxlv1/NAC4lETGmpvOR95dXEEF+eWTJgKBfh7lSG70y2vyzaaMNHbSE+UYQvrQ4c6XV8YdBJWwXGmgAVQnUm1Urdoi9KBJZ9f0TvRVvyIShNYYWjnR9T5fwJP6KYO3gNJkFjvOcYmkT2UMa/A3AZ5oC5JO5BdWChxkWda22HYv+nBb6ZK2u2TzCsFtho4BjX1KFZbIRVKewh9iQqa9B51Tut2/tx6gVwWh4e8Zs2msxAuL+Z85LcQW7FhD+2SY6VsSVLD9Hq0VylPsJXRjotOlN/nvCb6BW1uf3Wu+ELD94rdhxrbCvoBFcIyTTQj8IuGlDe50qRmqKyjemU1badc11ylouAUYcQDhHfJZ1zNKZZ2+STwn5q18s5RAYViC8aJx2ZhaKEu9vkqEkTw82QMSPcw6LDNyA7/DBoTXN1oAbCuCnxFNUlqttXZKllRAMuFVN3sTMOJNJ8kNsH2x3wyufSxErcqAw7uAXKqxGlFPOl6hC6PnwBAWZAAWOZewqdZuJxaZBMnhldJPM8ZjQ5bUShJvVy57qHOq45AEcR3kujJYR9uYApiV+XNxw4W8sPQrIhan7FsV
 0LF+lEus
 HQg8naqkNw1ZHrx/lALSM7KNuLVuUGueZyMYSrOV8EsK9zsVy7zaVecuNl9d9iJeZEYcal2UQFmfxUCrimyyi6bllmtDTNdBvyrx2eiiKOZk/T5eP5r6wgWF3H31hlvb2R5y5nWB9D6j7DBbd8+dVlEDdAIO6Bff+BI/yla6wvnZEpmaWNDIvjSjs5Sd5/betEGZtswt+Zxxnv/8MIkHg+V7UZE2Aa3J7MjeMGD9JdjZcmRxbIbBVxrwNudljUkMmrUIviRh7jCkMPeUEVRZy2I5JLG2tzDzuXj40H6qkwWKHItBOqdfBYhzKA3PHuQZSSe2CPsppjcgj2e2LfUWmv4L5bbJZ6p0KdcKkdwC7qtOwtP9gCUS+1yVJrQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/sj/linux.git mm-new
head:   85e964e7a1ee73a0bb6db3e08355b93b25fa295f
commit: c9e6712790c0d20de3914c44e8a22d9df00cb28a [40/108] mm: fix possible deadlock in console_trylock_spinning
config: i386-buildonly-randconfig-001-20250802 (https://download.01.org/0day-ci/archive/20250802/202508021825.tUu2retW-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250802/202508021825.tUu2retW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508021825.tUu2retW-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/kmemleak.c: In function '__lookup_object':
>> mm/kmemleak.c:440:25: error: implicit declaration of function '__printk_safe_enter' [-Werror=implicit-function-declaration]
     440 |                         __printk_safe_enter();
         |                         ^~~~~~~~~~~~~~~~~~~
>> mm/kmemleak.c:444:25: error: implicit declaration of function '__printk_safe_exit' [-Werror=implicit-function-declaration]
     444 |                         __printk_safe_exit();
         |                         ^~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +/__printk_safe_enter +440 mm/kmemleak.c

   413	
   414	/*
   415	 * Look-up a memory block metadata (kmemleak_object) in the object search
   416	 * tree based on a pointer value. If alias is 0, only values pointing to the
   417	 * beginning of the memory block are allowed. The kmemleak_lock must be held
   418	 * when calling this function.
   419	 */
   420	static struct kmemleak_object *__lookup_object(unsigned long ptr, int alias,
   421						       unsigned int objflags)
   422	{
   423		struct rb_node *rb = object_tree(objflags)->rb_node;
   424		unsigned long untagged_ptr = (unsigned long)kasan_reset_tag((void *)ptr);
   425	
   426		while (rb) {
   427			struct kmemleak_object *object;
   428			unsigned long untagged_objp;
   429	
   430			object = rb_entry(rb, struct kmemleak_object, rb_node);
   431			untagged_objp = (unsigned long)kasan_reset_tag((void *)object->pointer);
   432	
   433			if (untagged_ptr < untagged_objp)
   434				rb = object->rb_node.rb_left;
   435			else if (untagged_objp + object->size <= untagged_ptr)
   436				rb = object->rb_node.rb_right;
   437			else if (untagged_objp == untagged_ptr || alias)
   438				return object;
   439			else {
 > 440				__printk_safe_enter();
   441				kmemleak_warn("Found object by alias at 0x%08lx\n",
   442					      ptr);
   443				dump_object_info(object);
 > 444				__printk_safe_exit();
   445				break;
   446			}
   447		}
   448		return NULL;
   449	}
   450	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

