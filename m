Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37F2DE67482
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 15:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9BCF6B0088; Sun, 21 Dec 2025 10:24:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A49A66B0089; Sun, 21 Dec 2025 10:24:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 955EC6B008A; Sun, 21 Dec 2025 10:24:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 842666B0088
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 10:24:31 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 01FD0BAED1
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 15:24:30 +0000 (UTC)
X-FDA: 84243849942.16.E5B710E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3B37BA000B
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 15:24:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iN2pnvg4;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766330669; a=rsa-sha256;
	cv=none;
	b=tE1HcDweXVXS3r32xMx++qlDV4ZaKSzjhMOEA7dOoE7/I9VwcCjnOiHTOtLCol5iygEqSg
	CyJTMrW3znjnV/uPzCO3GkFs8UjoIIp6JJ5rhUhAlO/OfvndAOGJfurWKh0SxphOQFCib1
	f32ZQ0cxlUcQtG8/kise4U+PSbR6S2M=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iN2pnvg4;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766330669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=VHz2A9HXQFl/Z5ORtAEQpI4bJq10w5ge2MyW6KAZYws=;
	b=Kmlb2+vSPpxbqhYcwYOjETz2/2Qa/kLb2DiShnZue6bf76Jrk9X5c/BtjAz3nnEIDuzTJD
	MOjtyb8BRnHnxva+vnNnGMxdN6i2ohBzfuP3NupGNaTZe6U9VYC5lfO43v38prB3ycDQTq
	rxMoCqiU2zXSfdZ0ZeskfKjYIu8qOJ0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766330668; x=1797866668;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=UPW61B3GCwlD6pRjhVbIthd4zHwxGoWsmYq8SGqreEM=;
  b=iN2pnvg4A/SRMp6kiENZU7YXEuaKOp7riQwZ4dRgsE9E3Hp3X8fOifNt
   piOWGNiguNKtz4pQmle7na8yiXSi1svbELaLwGOpsmZ9GJW2pOUxUA7bO
   3VFTX4O794VDwvu4ZySy2XpI6ektmEN057Mu/rlUDEJOvx3FHAoqUQNe+
   8m3yWai5uwvBPEnoz8+XTTsPWxksS6xm/PUsBBpSkwhPrX1pXAhPK0hq9
   bBxp4d1ohEY7RMDazc91cSnCbxqDTvRHhsRA4oJiL7Tim2LQLpp41ukWL
   57cwv/JZY/HiuKQ/+Bcgr5P0wqTJ8CK/bF8IYKKDVGFY0wxQBDSsc8//b
   g==;
X-CSE-ConnectionGUID: AwalfB0RTae9V/IS39b6xQ==
X-CSE-MsgGUID: 5bw1Q/6zQpSnKWHABkiFhA==
X-IronPort-AV: E=McAfee;i="6800,10657,11649"; a="68090341"
X-IronPort-AV: E=Sophos;i="6.21,166,1763452800"; 
   d="scan'208";a="68090341"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2025 07:24:27 -0800
X-CSE-ConnectionGUID: 1QXVgw98R16pKnFnskNSOQ==
X-CSE-MsgGUID: A4+GiOkUQ6ijLCK6CX4WFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,166,1763452800"; 
   d="scan'208";a="199070358"
Received: from lkp-server01.sh.intel.com (HELO 0d09efa1b85f) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 21 Dec 2025 07:24:24 -0800
Received: from kbuild by 0d09efa1b85f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vXLIE-000000005mn-0efw;
	Sun, 21 Dec 2025 15:24:22 +0000
Date: Sun, 21 Dec 2025 23:23:57 +0800
From: kernel test robot <lkp@intel.com>
To: Xiu Jianfeng <xiujianfeng@huawei.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: mm/hugetlb_cgroup.c:829:44: warning: '%s' directive output may be
 truncated writing up to 1623 bytes into a region of size between 32 and 63
Message-ID: <202512212332.9lFRbgdS-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 3B37BA000B
X-Rspamd-Server: rspam10
X-Stat-Signature: 4rgc478qr5bhbm9x9nkfzb5j4zeq9w74
X-HE-Tag: 1766330668-879927
X-HE-Meta: U2FsdGVkX191ZMJ3q1SqS4YF857/6LPisXSIDzt5H1tkRxLlkaabYFexGiZUeorlA/C8entE+ThJAKXqiz2tVRzKN+MUhu3MalE2EdsmKHQ1WQ5Rj3F0yKBn23hIMC9HFlUd/zbFRcAKT/9fKRUq9sPvxex1oUlCP5XxFtzBNEHp5bpsgE9wbLxqCBTG4VhBUoz663deZk+xuIw3VSB3ofTqHexeFbEFPfDK2c+4bKMi7WNeYZ5xm+vF/Ah4nMQF6UX5X8AEeFgbFdYSgB0vfa2IXAx2DM/YCur9hYDJRnaey2NdZa79zbymhnw1MbwyHDMSyCUSXYCWN9CxoTz6CWqpM5WCiCQU1CGGqD8Q8egoxbCVO3r00JmaMcy+fyzJLnnAXAuhdzkQElmpK13EP1C2rq9qg1fP1i8OSTKofS2sff5LSEOXK+6l4XxPi9G9OgST8E+Hv7NB7hK80B/JfXV/28icNuL96BpUDTWbfwwb7Ne0yEkzOpcf2W0KUBdQsn6m/uHECEqlWS+J0/Fz/HTxTiMQ0gtyfHkNTEZpRFp52aDOit1AjWQalID3iJHS3egB9pNMGO9IbLkgZYvTLagaWctDTorSDTXa7OIYs1Yn46tmOjKs+CT0rO+Fgxh0eFfMQmDEJ70k+448+SjYxXMd5dNU3awwn9REj5KLmI4gXjyXfuZqtMqT7PscLKY43fpzvFPLjKlAMJrFJizWZK0rwK99dsuHjBDHdCbI4zEzWBi+IJ7VitNZ+pAOZsRKO2kEJzdiL8yOmTizjGiiAK/7KZu/pEf06T6nEnOJb0477yS/SkCbTsTcFxZDdWJu2rGIH+AMMucTQZu/LATwZBSlL8QJ7zLaegOrz5hLQ4ZPu5TBjdu74lR6FNddU2gs4rvgPpUq0V2loyca7YrE9Onfw6Sm0zZLCemXVfLw0IcqSsIuSsHvCGCWuBDQjx05cwrqsOnz7tqfdflICXP
 7tDRBVQz
 rE0s1NZ93i0oq6Amw0BmvZ09QmNBIcbzQBSiW42FFL1NA79EavsPi0mnicDKtOgaVWStelcEdvN1csmf31aJiXvWANuGPOsDdn3G3hDNEOkjXHk8dN9eJptAJ8SnAZ9ukdBrsJaSDJ/yB3uy8Ue+5if5bQShDCQjqyhkC5YfFDpqhFs/oM7hrNPwpCt42t1qT3ItuCrkASSlN687yr8YfYYz+ZGbt/0C/K34s8otFTX+Q9Idksj+YAnYZT/EOj5FRtdeQiVfSiRgbIwcFTQ3/kuFw8rW+E2wQHFR5CyyxKHdouo9biAows5ZWGp1azqsHHXqtIFPYPrCUWhYP3u+776L208oyQ3A/8kPm3+ros6jJYEFWn5ZjP19syYGWZErasL4tnkJ01kT88BE4VS+60O1zrg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Xiu,

FYI, the error/warning still remains.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   9094662f6707d1d4b53d18baba459604e8bb0783
commit: 47179fe03588caa13a9bae642b058901709ddc55 mm/hugetlb_cgroup: prepare cftypes based on template
date:   1 year, 6 months ago
config: s390-randconfig-001-20251220 (https://download.01.org/0day-ci/archive/20251221/202512212332.9lFRbgdS-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 10.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251221/202512212332.9lFRbgdS-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512212332.9lFRbgdS-lkp@intel.com/

All warnings (new ones prefixed by >>):

   mm/hugetlb_cgroup.c: In function 'hugetlb_cgroup_file_init':
>> mm/hugetlb_cgroup.c:829:44: warning: '%s' directive output may be truncated writing up to 1623 bytes into a region of size between 32 and 63 [-Wformat-truncation=]
     829 |   snprintf(cft->name, MAX_CFTYPE_NAME, "%s.%s", buf, tmpl->name);
         |                                            ^~
   mm/hugetlb_cgroup.c:829:3: note: 'snprintf' output between 2 and 1656 bytes into a destination of size 64
     829 |   snprintf(cft->name, MAX_CFTYPE_NAME, "%s.%s", buf, tmpl->name);
         |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   mm/hugetlb_cgroup.c:829:44: warning: '%s' directive output may be truncated writing up to 2087 bytes into a region of size between 32 and 63 [-Wformat-truncation=]
     829 |   snprintf(cft->name, MAX_CFTYPE_NAME, "%s.%s", buf, tmpl->name);
         |                                            ^~
   mm/hugetlb_cgroup.c:829:3: note: 'snprintf' output between 2 and 2120 bytes into a destination of size 64
     829 |   snprintf(cft->name, MAX_CFTYPE_NAME, "%s.%s", buf, tmpl->name);
         |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +829 mm/hugetlb_cgroup.c

   815	
   816	static void __init
   817	hugetlb_cgroup_cfttypes_init(struct hstate *h, struct cftype *cft,
   818				     struct cftype *tmpl, int tmpl_size)
   819	{
   820		char buf[32];
   821		int i, idx = hstate_index(h);
   822	
   823		/* format the size */
   824		mem_fmt(buf, sizeof(buf), huge_page_size(h));
   825	
   826		for (i = 0; i < tmpl_size; cft++, tmpl++, i++) {
   827			*cft = *tmpl;
   828			/* rebuild the name */
 > 829			snprintf(cft->name, MAX_CFTYPE_NAME, "%s.%s", buf, tmpl->name);
   830			/* rebuild the private */
   831			cft->private = MEMFILE_PRIVATE(idx, tmpl->private);
   832			/* rebuild the file_offset */
   833			if (tmpl->file_offset) {
   834				unsigned int offset = tmpl->file_offset;
   835	
   836				cft->file_offset = MEMFILE_OFFSET0(offset) +
   837						   MEMFILE_FIELD_SIZE(offset) * idx;
   838			}
   839	
   840			lockdep_register_key(&cft->lockdep_key);
   841		}
   842	}
   843	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

