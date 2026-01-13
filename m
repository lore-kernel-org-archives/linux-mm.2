Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 899EECF45DE
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 02:18:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF9916B0005; Mon, 12 Jan 2026 21:18:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDAA26B0088; Mon, 12 Jan 2026 21:18:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF9FB6B008A; Mon, 12 Jan 2026 21:18:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CEB6F6B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 21:18:29 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 571BF5F62E
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 02:18:29 +0000 (UTC)
X-FDA: 84325331538.10.DCBC20C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2BD6840003
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 02:18:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=khP1G3ER;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768270707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kkD5qCwWzUrMnmGuo89WDfFeh3wSCT7fMQ6b8QTXbDY=;
	b=uUhuhXCFil+l84fZHZhWSsYnid0QhcZtP9muKs1Pax97niF0d489yLplYSzzl7pnxZntv0
	Xuh+DqAEE4TJUOiHjn7Pj6kY6zfdBrkFj/oiE5h7IzTzO+Qidfby0jGWDWZ9b1Pyezutkz
	fYLmR1gm6Gyoa7Flo5MBDpA4SWeDOr0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=khP1G3ER;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768270707; a=rsa-sha256;
	cv=none;
	b=pibwe7Exeo5yevMtVfyggPIuPzO7RT5hk+xWJzknLctGUNp3tHVZSZNzBrUagcO0pQgYoi
	6avtbuVuupLYcofWMdwWZ115IkWFrtbHDdAIroGdA/qZx0il82iwVPAxwPyafRBMgM5TTA
	c1Vdnx9sPPVayeXrMfLov1iYxF+Bkig=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768270707; x=1799806707;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Yec0sfDxBI6Ht33ZuzbnIrm9kfnOv8pNuShawqEPPNo=;
  b=khP1G3ERwqll4YW32zm8fKpmnCR1GGYVmOLnGgdf9z139kyebnQ6/q6x
   I5S2+ezuv6jQ0aEJ4YCG0jB2iCzPUe85v0CaeBbeebUSsTaZYSDs6eCjO
   jXqbrdIflUYKc7j8jqZU7CMqkeA+Am9TlgzXBq0M7w6LPboAknVLfitXA
   wtCDvqvl5qogCR/jDoHAHzzEFjXPzgz+L7e9Zg/UY40vegE/1T9TbY+4G
   8+/DbH3KSOYNDOI3Evd19cAq7XsRJqDWg6DW57c4fspxU/KjuIIFSmZIP
   j9IEa+jDGFJ1s1EOp3SG2CG+8zM+dCuFExbx1GmudSl2AXRRiTDJOg4FW
   w==;
X-CSE-ConnectionGUID: 6D/dzo+tTDCK+NehSuqDkQ==
X-CSE-MsgGUID: CzcFlxRoRNimGGi6uf4dgg==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="73184123"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="73184123"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 18:18:25 -0800
X-CSE-ConnectionGUID: wNJWnrmuQbep4LDKovdUiQ==
X-CSE-MsgGUID: sb3tkOFtS0Gig7MufspTXg==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 12 Jan 2026 18:18:19 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vfTz6-00000000E68-3fEh;
	Tue, 13 Jan 2026 02:18:16 +0000
Date: Tue, 13 Jan 2026 10:17:53 +0800
From: kernel test robot <lkp@intel.com>
To: Ethan Graham <ethan.w.s.graham@gmail.com>, glider@google.com
Cc: oe-kbuild-all@lists.linux.dev, akpm@linux-foundation.org,
	andreyknvl@gmail.com, andy@kernel.org, andy.shevchenko@gmail.com,
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net,
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com,
	ebiggers@kernel.org, elver@google.com, gregkh@linuxfoundation.org,
	herbert@gondor.apana.org.au, ignat@cloudflare.com, jack@suse.cz,
	jannh@google.com, johannes@sipsolutions.net,
	kasan-dev@googlegroups.com, kees@kernel.org,
	kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lukas@wunner.de,
	mcgrof@kernel.org, rmoar@google.com, shuah@kernel.org
Subject: Re: [PATCH v4 4/6] kfuzztest: add KFuzzTest sample fuzz targets
Message-ID: <202601130828.lXrl0Ijb-lkp@intel.com>
References: <20260112192827.25989-5-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112192827.25989-5-ethan.w.s.graham@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2BD6840003
X-Stat-Signature: wfszw7roq5hr88som5zesr5dwtqwt794
X-HE-Tag: 1768270706-53985
X-HE-Meta: U2FsdGVkX1+4lEjbQpKG1Hgiavrdt1u4RPqc2X64wIXWniUn1jXyetoGWFI7GL8ONcBN2IfhLtkg5VK5QYqvxFQLrfr3N9LxFuIvlfbV4X+EMlMwJFcokUOGQwtemhFiHVSWVtV4AhlIDAqH2Rrc5DR8Ctj6slYO/GlswTrvthCkiE8KecCIw1lxgBZSfeT67hKG8iE/fgRZGBzNnuYrcHMTRBFHeJKh/V6MHVAaAMA3wmDJcNObn7YKJ6bAXZ746bXvLEmXQA7KseVFsvcCo5AW6vmSMRD1P6OjMjnmCtLV7Sz06I8/pPpdCRAMXO/Qh3AAKpJ6Q0Ft28zQPrkWUrHrnx7BiMJ6QsA/CPcM3v+n+1uJ7okG2X35ul+gmhozsC5B+T5WVU8E4nK6oOZd3wcgOp07S+H2A1eFtOa/wPxEca3vcZRiNUs47Afjqc0cVyfMb9NQMOZFTTodJsVw6hNjEWolJa2XVjCTaYu9i6/+oIdl7gKYPK7bN/uB3EI5UX5DQqM/qxesklSaZRzfsmVk9P4F+D6808t2a/KnbJ7hf1Zd956XKVeMq6iN8GclslDs2S2FOh32WlqqqTK2rKQEkM/989hAHK1mkRuZDzsW62EJh71QibdDgcNulcbyL6BuSgHlXMujR5JG6Yl/yOw6RTPUmLMgtWhhELdkD9j2sKIaI62uwdXUnEQ4QTRmLQh5+U3vj3foANMrhX/1a/3MVp9Fp1jvYTf++7UGlxENZAKiRPRdbVi4dLsTnfHOd0QHncAoJgk5FpGjH34BF8l7DO7b+X0EVKuEWM+Vvqad2XX22RjH7G5U0lTgO0sVywgv2aR/v5xhiTPjdlcTsevlnFhMaafdoyluFWjHuKohRkASSpTJZiZjhz0iQ0onrLF+AuchTfuFylnOMe83kMHeqEq3n5gFPVBTSL1DPJnriHngkfNq/VNal27b8cOiWiUOVOAUlG/40XWARhX
 +y43oHs2
 Os0REiS577w8CLmr3FYG/m3o5gNRZZrV6P2EoWADPcDGTXHlGFI02Y9K64QZ3bjGvA47R0x1KsnMkUQSBkc7+8R++izcaaAwwerXV2sk9DFUWnLaPQH319Pg4b1/R/lpig+oM/Bqpu+r075Ca/v39NY3oL/F8dkQTwpbweEDqtk2Wnf/Th4mT5EgR/EDuCbVUCSicjhWbQ1ljaImcHgpSOwJS2QrdvOKsZqPhgJy7JoArP+V921ONbeEx+zqS1NB6bNYqXqv021nXZBCi5zjGoHp4l21LX4XZJnsbKP4+xoVd+H+d5B5piOoJP3Sd4CCvr7STsfHXeobjR8bolyS7j1VhcErkmwsq11DrmcdOiIZ7WIUhsNior3CSJccmo4giO6ws0exZiDIKWuocRYg/2+oRwXMjKAv9AR3lHA+hqvG+IhGEhcRI/vdNtbLSlC/VKXn2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ethan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-nonmm-unstable]
[also build test WARNING on herbert-cryptodev-2.6/master herbert-crypto-2.6/master linus/master v6.19-rc5 next-20260109]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ethan-Graham/kfuzztest-add-user-facing-API-and-data-structures/20260113-033045
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20260112192827.25989-5-ethan.w.s.graham%40gmail.com
patch subject: [PATCH v4 4/6] kfuzztest: add KFuzzTest sample fuzz targets
config: m68k-allmodconfig (https://download.01.org/0day-ci/archive/20260113/202601130828.lXrl0Ijb-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260113/202601130828.lXrl0Ijb-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601130828.lXrl0Ijb-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: samples/kfuzztest/underflow_on_buffer.c:24 function parameter 'buf' not described in 'underflow_on_buffer'
>> Warning: samples/kfuzztest/underflow_on_buffer.c:24 function parameter 'buflen' not described in 'underflow_on_buffer'
>> Warning: samples/kfuzztest/underflow_on_buffer.c:24 expecting prototype for test_underflow_on_buffer(). Prototype was for underflow_on_buffer() instead

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

