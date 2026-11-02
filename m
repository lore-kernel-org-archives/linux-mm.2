Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 674FB60A2633
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 06:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=IzHl1KxN
Received: by kanga.kvack.org (Postfix)
	id 87F3E6B05B2; Mon,  2 Nov 2026 01:46:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 809366B05B3; Mon,  2 Nov 2026 01:46:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D1076B05B4; Mon,  2 Nov 2026 01:46:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4A8D36B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 01:46:06 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CAB1FC0C0C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:46:05 +0000 (UTC)
X-FDA: 85389244290.28.6172B7A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf14.hostedemail.com (Postfix) with ESMTP id 084AB100002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:46:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IzHl1KxN;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793601963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jQyVKf+xKGyYu2gTWeUfHIN4PWX5+OTKCqL+rPAXxBM=;
	b=z/qVq6/7QBkvJ74nIIko5xXFcz4EtdFjyV0/j+3mFo38cGFz0fr+y1a0kChoJOaDH6iqrv
	8Q+z66vPgX59/IwqiTsN8QZtMLpIrqd2YWAx1gWGWm10bZGbZV1jDXEw9QjPYkKtt97GNy
	swtOt5U+PVNrCgf4KGuOd282SpaU5ds=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793601963;
	b=IlwFAbU8XRA4TwTAELvpw6ya/+N/DQ8jl2mpyKHwX9JuMb5lKULyHlQ80yodGLjHYDu6Lu
	c2vUuNjFVlFud0kyEjIXeHpFYNoNyr6hfgw20noRzuod4okCrzL5OQS94CTGAB9Olh2sJc
	+Mdt14hIBLXRavQ6gv6Dg7Shk5InGXA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IzHl1KxN;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793601963; x=1825137963;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ve5h5MZP7tPfgfDQBI9dQre1wJZbL1TJsT4gIu4qPF0=;
  b=IzHl1KxNTdi55wEGJIZS8PM3DQ2XGohl9k8S1bykR4r2IAYM1LhQyU4Y
   dc6vG7GpnVbyeXMbSGm7FMjw+coHNUH5nwOaweFVV6OaYhMGJ3yL0om2q
   Ul0AYpmMe0cWkXiaoyDxliqMnwQhJWZE7cldJhIpzY+bFWzVIIxy03E/Z
   8ICCsdaeZ3yP5FHeKC2zfxVhoHawlybWyxiAqyug5HA1zYZHbRMevAJrC
   9bev+9sMQNAL4JRELo5J7o/nshi8/qk6BJ4snh9U/VUtkncuxWM2OD8zL
   hhIFG+IqHi9ZlPVhxRLuKOjZI/vM2Fz8WNHek6AZe67Khqz/8Yo/YiUtP
   g==;
X-CSE-ConnectionGUID: ExlU2VD7Th6YV+Ad2xHtnQ==
X-CSE-MsgGUID: WZJijMzET8acXZBLfn8ehg==
X-IronPort-AV: E=McAfee;i="6800,10657,11953"; a="2314502"
X-IronPort-AV: E=Sophos;i="6.27,191,1787036400"; 
   d="scan'208";a="2314502"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2026 22:46:02 -0800
X-CSE-ConnectionGUID: 8l3CM987Tjm3P9BwrFglaw==
X-CSE-MsgGUID: ThJWP+isTvCeYX2carf4Zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,191,1787036400"; 
   d="scan'208";a="5867273"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 01 Nov 2026 22:45:55 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xNlnj-00000000gWe-2XRs;
	Mon, 02 Nov 2026 06:45:51 +0000
Date: Mon, 2 Nov 2026 14:45:19 +0800
From: kernel test robot <lkp@intel.com>
To: Albert Esteve <aesteve@redhat.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Ondrej =?utf-8?B?TW9zbsOhxI1law==?= <omosnacek@gmail.com>,
	Jens Wiklander <jenswi@kernel.org>,
	Sumit Garg <sumit.garg@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v3 2/8] dma-heap: charge dma-buf memory via explicit memcg
Message-ID: <202611021401.ZN5EGF6G-lkp@intel.com>
References: <20261027-v2_20230123_tjmercier_google_com-v3-2-78d2c4cb8647@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-v2_20230123_tjmercier_google_com-v3-2-78d2c4cb8647@redhat.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 084AB100002
X-Stat-Signature: 96jjrmayd91ymrods7q6pfaxtwwjcd7m
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793601962-347293
X-HE-Meta: U2FsdGVkX186hkdzWEYlOBBiDjQDhcvyNKu4wU22qnTbWaFFqSEUYhOcux7XL5/D9AvuXSbGdksxeEgz6Q44m5fQeVd3MhzNc9+MM1952axGa/8kSfpgm9FoZhLVNHonpypW5kSF7vLRiTB/4olm89NEN/o33wn52Z8Y53EST/XmbUk1GrzI845G0oVoSJr+N1BsZ9gBlA7CQ8pZ/S59lIvVI/8RuzTB/nvtzeAvTCDDuV3c5CMLPluy5yra+MKPk+H2h0F863hfPxGAENVHiW4r11NZPjEktbriQTi4Hy8wMF2kI4ZeTDz45VJkvsM1co8u/ozeT+r0Fz4D2Aq0bswgs6LnL4ZtLPRUatjDaAMWIjPLziLNRGJu3+r1RbCAB6bXv6lz3/IR4ogQT7Q2Y6cO9cHsTdmg7Nbt9PH7B6GDCfnzjXsGR9ZY3YkFy272jNAun/W8xlV2BMYgDBL/KlJz//peh+X/NJxXzjX2+zPAhnc6NeUQOrCLy/9DGuJiYQLMHjILDLFek5nmpLGa2AGPKny/GyRTvDOchU1CwTpNxfZNKVH0SOgSGoBRbTK+s/xoVt86FjUeFDr0RtjD5PSX/dyjF1CximdUZ0BcSPf0AePJH8/jGMDDeJ5JqhKLAcQWXuzuGOgkNWbwzJlsBtOeoUfXIQ9knge80V6JnOeM3i2TwatQlM13QWB5d4Gyqcng//fEqY8EpeIknNTbE0/Gl/LgkGQyQAN51yE4+GUlG3o8G77je1Cv/zYAXYzSyqMoOVsj09FIseIgFy9m1afIDqPKykUgtjwiH5fnALKuG2QO9AWAfRAlOQGf3PEO2v5ep7gXmwVOr5flMN4xnRz3yuarRjMLk7PkSG21CXpVCp1Gnz0pY+QqBeiL+8peAIOzTN4CiZpTMfe+3wuhUJ+24wqmX0y2vBV74JR7PffXXSfNr1iuKp/NbRsUQ5UYpr/eiOiregHsNqEtruS
 AcUYt0No
 Qni/cp1STZxDn5fL2CeBv+cEsXgKUJVHrNio+sJRbpIveVUogvimDmc1xznpDImyn9FX+2kwCjqTtDCht2RIK3BeBykj4rhMwW7zvlKlOwrA0m4uuhLe+vcuFwkIi3F9/Hv5yrvxK8mavEZatmNLshtCk2xw8X1RPK2rzFnY860Fa0F4VBYb5Ka4d1gitSIDcHzxVndb6ry1b37Kz39HB/FTkPjV/7BL8WXsWk6fnT1Jz3iOkqG1E1qFkQWqxK4Um0L5g7MZco3muLMMXv2c3/N49UaRqpHlQzUDyLTOacmj2FquRGzbb8qz0+2j7TnOj+pXHkF7m/qDLIKLTx1SFRccrWOv76Io1yMQcZnp0pFUdgEwY5BdhDdMpwGkzdYwfelj2nk5WHvo2wF9RdR6tB53nBDQ9faOvlGH3n7NKCWlws2U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Albert,

kernel test robot noticed the following build errors:

[auto build test ERROR on 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907]

url:    https://github.com/intel-lab-lkp/linux/commits/Albert-Esteve/memcg-Add-MEMCG_DMABUF-accounting-infrastructure/20261027-160244
base:   24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
patch link:    https://lore.kernel.org/r/20261027-v2_20230123_tjmercier_google_com-v3-2-78d2c4cb8647%40redhat.com
patch subject: [PATCH v3 2/8] dma-heap: charge dma-buf memory via explicit memcg
config: loongarch-allmodconfig (https://download.01.org/0day-ci/archive/20261102/202611021401.ZN5EGF6G-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261102/202611021401.ZN5EGF6G-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611021401.ZN5EGF6G-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: drivers/dma-buf/heaps/system_heap.ko: symbol 'mem_cgroup_reserve_dmabuf' undefined!
>> ERROR: modpost: drivers/dma-buf/heaps/system_heap.ko: symbol 'mem_cgroup_commit_dmabuf' undefined!
>> ERROR: modpost: drivers/dma-buf/heaps/system_heap.ko: symbol 'mem_cgroup_cancel_dmabuf' undefined!

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

