Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01CD1C54F5B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 06:19:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C90226B0088; Fri, 20 Feb 2026 01:19:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C67256B0089; Fri, 20 Feb 2026 01:19:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B66946B008A; Fri, 20 Feb 2026 01:19:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A3A7E6B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 01:19:55 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5AE8B8CD10
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 06:19:54 +0000 (UTC)
X-FDA: 84463834308.28.8FF6F6E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf21.hostedemail.com (Postfix) with ESMTP id C1F191C0004
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 06:19:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mw9CzSSj;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771568392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=vfLc9v/3dxZif6X4C/ze1KdoRtmPg+VyHeQP5N6EvS4=;
	b=ZIAHXK42ZvAFALTXMhc7jtTCj2KzOk5159j9M09cRcdtYhY3L1tk0BhwQtsxyrlu+Le7Sv
	eLJ9uqBrKcaulsNVDA3eUs28YNbjb0H4kEU+L5RzJSUWmmn/SNFoAsUGAVVcXrri/6YWGa
	HcSvbXWlS3XsJr4OW7MMi6Jk903z9+s=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mw9CzSSj;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771568392; a=rsa-sha256;
	cv=none;
	b=R2/hWTnfEhPCWEgqInD6qzM5xTdemdzyXbT58hWlJdqJ/6xZgxxl9qx3PBCOywNoVYNlsM
	CtK1j8Zmx1qH59TCN8PUgbfaEega+OOJfK2r/iIhHdsfS5xuwK+Rlu1bcjAaPDj/2st+ne
	gZ+FNFWMSY4kCnK5tbTg6yLI74x4daM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771568392; x=1803104392;
  h=date:from:to:cc:subject:message-id;
  bh=PrkD85zv/CikBtBh9/x0HAE+2UzAUJ/tIfQqkmPadvQ=;
  b=mw9CzSSjJQg29plrPGX+8mWkdxdOq/0FjjEl7wuAGuHngDH+IAMbXwaC
   o5wUOOHkZYPoKWicfKhUp713x5krx/znvd1NVnVlke0XpOOqxDS3ajp8D
   kFJViDOtgWfDZ62Folc5LlCqPGRraKifiaQiUSAWFYWI4Cpm84PTemtil
   YVLG1vvMoUg3/doXHhle6cpFsK1JYXeftZRTvwo6STWzFClUiXIX8A32x
   4/9Lg3x3rgOWziJ6pAf/7tJWtpeYqsrRyNw2YcuMq83yoAwpBOtY07EZG
   xxntfost9ODRqWfMhM1ZWIhHqVg8J6X11IpsWRYvvphXQyTlwBoRkMJo0
   Q==;
X-CSE-ConnectionGUID: jCVOj05cTc2XDgvGK0Ojdg==
X-CSE-MsgGUID: FdRYFkE5Rn6Eb85/5Ql6fQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11706"; a="76277576"
X-IronPort-AV: E=Sophos;i="6.21,301,1763452800"; 
   d="scan'208";a="76277576"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 22:19:50 -0800
X-CSE-ConnectionGUID: 1z2b7aKuSgGK1Q4ldRGmkw==
X-CSE-MsgGUID: opMlGm1/RHCrPJgGJBh+KQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,301,1763452800"; 
   d="scan'208";a="214882243"
Received: from igk-lkp-server01.igk.intel.com (HELO e5404a91d123) ([10.211.93.152])
  by orviesa007.jf.intel.com with ESMTP; 19 Feb 2026 22:19:48 -0800
Received: from kbuild by e5404a91d123 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vtJrd-0000000049F-2NBT;
	Fri, 20 Feb 2026 06:19:45 +0000
Date: Fri, 20 Feb 2026 07:19:10 +0100
From: kernel test robot <lkp@intel.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 linux-doc@vger.kernel.org
Subject: [akpm-mm:mm-new 71/81] htmldocs:
 Documentation/core-api/percpu-counter-tree.rst: WARNING: document isn't
 included in any toctree [toc.not_included]
Message-ID: <202602200739.GL1Y7ImH-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C1F191C0004
X-Stat-Signature: y49a7h8735cnjzo1r3qdekco5eyf9bwx
X-Rspam-User: 
X-HE-Tag: 1771568391-202715
X-HE-Meta: U2FsdGVkX1/GxnSidotx/iWq19rq3RIA0dY4P5uJrIiYZAMi/yybonWsd8JzQSUJRCYc+5wVtrlmCjMr7I75/tHAmL2sRH/nfEi9C6dFJqCkj76AC50pnSopOpzolp8u1ykmvNsKl2qxiEE/22zVJy3/eYGjgbyV+hTuoEa6atCCUjJBoi9k2owbLgjFoqfSC1sIOWJnyREJZXUyWUD9COv1b0I7/88wdyKZFvvZBIShV31ruHGRexMQdLlqHAXRWApdjTkAYsJ9ecOD3eqzl9Q3VYGTSFwjL7jhGdUQQWpX3dOnwH5cTeob/hq7LhZ0Xb/zvSIj1SIR1015dffxGgQtkh9QALioAKkOd63rbP0sjjddEDwur781cRn1riuiix9pp7Bhs3TwtBUWetV5rYRdX7SHHg1fxdg+vEeqXF+OI+1Qpr4ZIxmNbzojg0UDpntmgCOemzeaoZaDbIVVQuvOjhUy5MtSsX2iEifwznq2jrlKZH11AX8KBbh4lUILzQWJFFQYqeL861UJUcaMQEe6XHpNmCSVlF/y4uyH9FRep7puOW5SO2lGHuc5deZTGdX0i/Revv02kF3jS0rkttmx2yg9rqCUhn3f9Sd/+S14uVu7k0HAx0hvhGch0i7+KZp8V6qtyBV7jrtAgbvh6dhoX9JwgI0wEdu+1vu67AMeDX/4ai60SRXbsO6P1BksOyzV5iAVE8njfQzY6AIVEe8GPpUxQwS3Sxg+CHDz3990RyR9nXNxYQC2nAUxO8gF/2j2yJOapC1LuScaK1OA2cheGhaD50pumjGs/EitaVyPNYZFvGcRevLcN3GRKBSxLc8ijaCN6YJoPx/AIIcOpTgx8oYZ4m1Bflxf7MMx16hQP8/TikH+0xXkRQdCV/3siAbiZgWGWlLJ6cm5GAr3Y/1LBdRipnr1GrGePSYXbKmbU8ElhYeGLfcJBwBxIH/w6eWFb720NL5tH2FYXmC
 xASfs8Nk
 k/GkfnSe7uTQo+9KLehS/TbsUMagCT70r2Bir3polGnVnwtsUjDFp9BBkt77fM20fsMFGMvuh++CSkdABhl5kBlp6MAM+sK05ix+FajeueMsAGr3sSMW+Oxyht6cp8cZ75gnR+xNcHX7hMayZ5+un+kpottCcCCPfSyWCsD8zVS22lYya/KEy8DXJu7oF7hI5++ca59+GIvq1wCpgAn6+sRB3E6aG8olgiKoll8lFqnFwuYxKfAaDAC6QXJsjJi0bd+qdthPuIm+vf6BzE7mzxcYAuavkMhOV1DyS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   68777acba791f6c852c9128668ef27a662ab7bf4
commit: 979792367f37009e45b073abcd733bb095ac19ab [71/81] lib: introduce hierarchical per-cpu counters
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
docutils: docutils (Docutils 0.21.2, Python 3.13.5, on linux)
reproduce: (https://download.01.org/0day-ci/archive/20260220/202602200739.GL1Y7ImH-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602200739.GL1Y7ImH-lkp@intel.com/

All warnings (new ones prefixed by >>):

   Documentation/userspace-api/landlock:526: ./include/uapi/linux/landlock.h:45: ERROR: Unknown target name: "network flags". [docutils]
   Documentation/userspace-api/landlock:526: ./include/uapi/linux/landlock.h:50: ERROR: Unknown target name: "scope flags". [docutils]
   Documentation/userspace-api/landlock:526: ./include/uapi/linux/landlock.h:24: ERROR: Unknown target name: "filesystem flags". [docutils]
   Documentation/userspace-api/landlock:535: ./include/uapi/linux/landlock.h:166: ERROR: Unknown target name: "filesystem flags". [docutils]
   Documentation/userspace-api/landlock:535: ./include/uapi/linux/landlock.h:189: ERROR: Unknown target name: "network flags". [docutils]
>> Documentation/core-api/percpu-counter-tree.rst: WARNING: document isn't included in any toctree [toc.not_included]
   Documentation/networking/skbuff:36: ./include/linux/skbuff.h:181: WARNING: Failed to create a cross reference. A title or caption not found: 'crc' [ref.ref]

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

