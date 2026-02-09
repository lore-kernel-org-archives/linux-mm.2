Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAD93E94626
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 23:38:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD3976B0095; Mon,  9 Feb 2026 18:38:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C81606B0096; Mon,  9 Feb 2026 18:38:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B80BF6B0098; Mon,  9 Feb 2026 18:38:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A400E6B0095
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 18:38:12 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 434791C224
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 23:38:12 +0000 (UTC)
X-FDA: 84426534024.20.D1A48A8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf28.hostedemail.com (Postfix) with ESMTP id 76CC3C0002
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 23:38:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KXOwU3xp;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770680290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bKflQoWWfTAd7e7632MSiWX2TDgq/N2H5C8MOW7rRnU=;
	b=EZQeTfyQRA0BOOdROD6TAR/wYxYzMIehxWOBzMhi3BlgayjqlBEfY3jrfZ14qmlJA7MkmW
	QmDVrY+xjjG6kOUaAO/hDTaT/eWnw4F3ku1e3Vt6dkrDgKHWzToXhgFI2+mv+iunwGOwVe
	ilcBzOWUo6zpIkTHjjhVpC6DilLlJ9g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KXOwU3xp;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770680290; a=rsa-sha256;
	cv=none;
	b=n1gDKT7nXOVHIiESkQFeP71J0R+S7LuMcrTUX24AywWXeXGhaVPQehCqu6kTH+eDlgkMqN
	8AcHoOBMtFDkIbogruDOAxUolfksXR0hkxpSVhg7XPQ8uky98TWoLDI09SgWPzw/1DjBVn
	w2F3IAjFP2N/7eS88SOKxUmsKao6rU4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770680289; x=1802216289;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wGlZDqmrdBbEgyHk+9taYE7VHOb5DA6r41ddHjaltyQ=;
  b=KXOwU3xpxTb0NQplB2wEPKa0xqc8q/jf4eiWiBo4MhPIVgG1yqXMfDC4
   R/lY1OtkavrxeGi5LISqDwOzR9SF5KgEQi9V4GJ9iOou+hF2ZCAc1v0jY
   xR7DuA5d+5qXkoqTuYK3pyPzV8XTPczgfkTtCFbdtA3v8B3v2v5kN9V+0
   CFrIBsOyJ4yP7oI2e09XxYEPJE+l7XGO6pEqASG5PulvfE9LOqhKV53Mc
   sOEcpfHYa+cQklzyCBQTbyQsPmHiOpJWhd+ATSyMnL8FdqttBjr7N0Yog
   7mCEYZjbKFs4oEzuOqXSj6zVWNgrPXj28ydcsHuHituUbEA2iA7iLWGWg
   A==;
X-CSE-ConnectionGUID: sTwN0PuDQxOhYRtz9Kyu5g==
X-CSE-MsgGUID: m11d++j2T5awZeeIbtyfbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="89384732"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="89384732"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 15:38:08 -0800
X-CSE-ConnectionGUID: cUlGTDknRj+p9ychtsexDA==
X-CSE-MsgGUID: 7ThtdMsuRPanMmjNvnfNww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="216256848"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 09 Feb 2026 15:38:03 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vpapN-00000000oQ0-0GQ8;
	Mon, 09 Feb 2026 23:38:01 +0000
Date: Tue, 10 Feb 2026 07:37:52 +0800
From: kernel test robot <lkp@intel.com>
To: Deepanshu Kartikey <kartikey406@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, ackerleytng@google.com, seanjc@google.com,
	pbonzini@redhat.com, michael.roth@amd.com, vannapurve@google.com
Cc: oe-kbuild-all@lists.linux.dev, ziy@nvidia.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm: thp: Deny THP for guest_memfd and secretmem in
 file_thp_enabled()
Message-ID: <202602100727.b1U4CHAA-lkp@intel.com>
References: <20260209033558.22943-1-kartikey406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209033558.22943-1-kartikey406@gmail.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: 9zz8f13czobdxp5tp1m6i71mcsemww8q
X-Rspam-User: 
X-Rspamd-Queue-Id: 76CC3C0002
X-HE-Tag: 1770680289-807552
X-HE-Meta: U2FsdGVkX1/0KckTskkj3kIe+ZbEL367pGYU+pry3oPIVEJTJc6ChgOwtOslNXR1v4XgKEUvCd1fLPD4mvtlDeOvxQ6X0tyKsCAMYi4vEHe0ChyqavzGuYJfx6abmHoXGwpPIEA/EEt7KoxaCqe816l83YpaNMpQU4baTo4dV+3TGzrtO8muCwuQ61pHYvzXP8Zoo+y6W+Nzq/TO9fVTIjCX43GJinD67Xlt3EPiJ6Ng0bXEh+N7lZbjv0uZ9/4ZvufnpfOteFnjz25yRddjvl5wfQ9pZYuN94m6O/RbdpI+6+7LJi5vwMPlZydwLf7iFnosKkebM6p19gyaCKHOkTB2apNz+oCT1pSw1Tk6c4Yt/ojoCMV0D/Vxf6HMZzLHkffueXl18I143FkWX8R/b8SJWxDSjuJweiZHU9+GgkJ+sCMSlvMhGN+av1pSHlR/pSseZJSKnw0pSn/KbZ2mZ9X99zH3ZIPQ7aHGwqdEH8a7/+j7F0U9RPfmC7x7tz+2d7Y0/oK2ujJSavq8F7LKv8UvFQ0bbOjXpO2DWugpWGBk5CEUUarB1wUQhE6rn9g4jIFq1hGxGj4X0R3G3GxxR3MUM9Xj6waCiE+pHmYkdA07enA9wVgCeu9HLO7/XdTFDyLX0AiNOq9qxqqOWa0jwl+4iAor6Pracy/02mtTRIvAh2OBskDmjPoTnit2xLU/CFKpy5IQiNFW+eNxSV0X3DqjLGRci96Mjsn9pPr3ei7LNx+wmx4Zm5hEMR75JXI21g8uGiqUB0RUBt0KtS4IYMSOLW6cmfzsNiCcUnvs9IhuPNj8GwxAjyCZ0hqWWEB0E4pNuLYncDZJo6mOqxS0yjt7j1tqpdllM+Sejo5o2rqQ5cupWFVJ9eWW4+Ggqp/dmAlYmzF4Ngwy2jihAXmU3TK9Fv93Dp2AWB1GQeXh5aLWMVKFGaDW8ULBn74XfePD+bFwwZlblgkireszeFy
 C7TkO4lO
 LZCKsWADYWTmWSmVPH9ySNAo8VmexijGTEaTvKgFAx/TcfR0euoJH4V0Wln4Qg0rjUCXN+j8DbLPx2KjMbjZcoX6h2ag4VidKO4cFK48NmT9oWu20lK1l8S12GM6eoet25x8cFtzvLxyiOHoao02t6MCLU6iQjbqVDszl5zxVWsy6Ps8m99TXFNLcNobXqI/WDpIKuSweC8161myRWSxsXd82oJ0SJp8h1a7lrWQy/zAh5CldEq4TPDyqUb2eTwZ+W4UfzU7aONcXheUNTbxR74VXSitRAwWUtQ17lE39/Sn7CxCZGz65Ze29Lf0kElQJbeEnTzJ45qN7kkviY8p9T1Cs9B8rP1yWpATsRItMYKrIUEvC7XPk20jtOJvejiKuYpkR3qNwOtkg+x2vIQGyuArfsAD9OAvvwzHNHU4fDh5gxky6rbYk4xTQksbrpPrhFdeCC+7Io3Ndugk6lrIIq56VvXq3gVQ4Mry4pUZf0TGN0ZlFi4JWvqBePD4pkD/58d+jH1ONedtKHg9TLZeoRC7XZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Deepanshu,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Deepanshu-Kartikey/mm-thp-Deny-THP-for-guest_memfd-and-secretmem-in-file_thp_enabled/20260209-113800
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260209033558.22943-1-kartikey406%40gmail.com
patch subject: [PATCH] mm: thp: Deny THP for guest_memfd and secretmem in file_thp_enabled()
config: arc-randconfig-001-20260210 (https://download.01.org/0day-ci/archive/20260210/202602100727.b1U4CHAA-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 14.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260210/202602100727.b1U4CHAA-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602100727.b1U4CHAA-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/huge_memory.c: In function 'file_thp_enabled':
>> mm/huge_memory.c:96:37: error: 'GUEST_MEMFD_MAGIC' undeclared (first use in this function)
      96 |         if (inode->i_sb->s_magic == GUEST_MEMFD_MAGIC ||
         |                                     ^~~~~~~~~~~~~~~~~
   mm/huge_memory.c:96:37: note: each undeclared identifier is reported only once for each function it appears in
>> mm/huge_memory.c:97:37: error: 'SECRETMEM_MAGIC' undeclared (first use in this function)
      97 |             inode->i_sb->s_magic == SECRETMEM_MAGIC)
         |                                     ^~~~~~~~~~~~~~~


vim +/GUEST_MEMFD_MAGIC +96 mm/huge_memory.c

    84	
    85	static inline bool file_thp_enabled(struct vm_area_struct *vma)
    86	{
    87		struct inode *inode;
    88	
    89		if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
    90			return false;
    91	
    92		if (!vma->vm_file)
    93			return false;
    94	
    95		inode = file_inode(vma->vm_file);
  > 96		if (inode->i_sb->s_magic == GUEST_MEMFD_MAGIC ||
  > 97		    inode->i_sb->s_magic == SECRETMEM_MAGIC)
    98			return false;
    99	
   100		return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
   101	}
   102	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

