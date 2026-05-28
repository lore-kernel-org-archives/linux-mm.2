Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4756ECD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 10:23:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3363E6B00B2; Thu, 28 May 2026 06:23:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E81E6B00B3; Thu, 28 May 2026 06:23:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D6826B00B4; Thu, 28 May 2026 06:23:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D9B06B00B2
	for <linux-mm@kvack.org>; Thu, 28 May 2026 06:23:25 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A8CDA140793
	for <linux-mm@kvack.org>; Thu, 28 May 2026 10:23:24 +0000 (UTC)
X-FDA: 84816441528.25.E232262
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf18.hostedemail.com (Postfix) with ESMTP id 04D931C0007
	for <linux-mm@kvack.org>; Thu, 28 May 2026 10:23:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="C/1CaUcN";
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779963802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xDegs1quw9fiSc09OFIUa7I6WDOYI2GW4EKNwPYXKDE=;
	b=dVg1sGhPV45I6KT0giiU14HAmyiowC5ZgB35B8PDhQ98ezjJotM03qtEebKrA3V4Sh5b6X
	pEql+kvynrfSH1Ea+kPPi65hJUO884wAcMZ+aaO/IKuJjRDFnLL8QoSoFIgve/E6sOS4H4
	D4w2GnztEkQszoTL9Kl/pyDlwwq0Ez0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779963802; a=rsa-sha256;
	cv=none;
	b=2t0RW1MYd9z1x+oj6KDmxhCOMELKhkbJ5dx9QU2obkZDgHoLklNPQRBEPSMD6a/PwXcBch
	jeTnrjY2LyXSYMRcgB5ugQ4RjqWOuaJWAr4hCP4KhH9hOXMFUvXWCL6b56rp6UmonfNnWp
	JU+SQZv4svHEWU3DcFeK+s8cQXpYdMs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="C/1CaUcN";
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779963802; x=1811499802;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ka4dqkKXiaoSIrqEW/co4iBfNrpr3bkYU5jiBBI6700=;
  b=C/1CaUcN4MGhEXWmcegIbKqd5K8i+9SbgpSUDrig3BfBXOXslDGi5UHf
   1ylIg6dRxt7W6z6FYc/ZpnBQiRwf2dK6vPr/ZEP8pbsj5s/sAq2CfvPwH
   A152zaQoa9cmroh+Jhoh5K4ZHz4le7r6D7C0PQ/EkI8QxVnHvdU9eTOQJ
   vm+VHuJU8A0aKRmCAdZpEYGmQkbO/jz7N4XOyt7Dla+jDMd5UZlkLkmzG
   tpEuPxlPzOqJ/yaIHZ8YeRas6wQVlGzeR2FD/pVw9OB9uJf6/Ue3cXSoZ
   bCWpZAfAjS3WVKwVA48aTDtU1hf+HDB4sgxfGTGA9AxyNN1J++fkf2yFR
   A==;
X-CSE-ConnectionGUID: XVb5FnVKTtyiR99TVl+JoQ==
X-CSE-MsgGUID: G7MvbZ2JSoCzv6eSJ/e4Wg==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="80831213"
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="80831213"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 03:23:20 -0700
X-CSE-ConnectionGUID: 4e6Lg948ScyWBGo3dD7oTg==
X-CSE-MsgGUID: FYhj2vLeSWarY/Tzszl07g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="238090938"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 28 May 2026 03:23:15 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wSXtP-000000005q6-1If0;
	Thu, 28 May 2026 10:23:11 +0000
Date: Thu, 28 May 2026 18:22:32 +0800
From: kernel test robot <lkp@intel.com>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	syzbot <syzbot+5d32c8bd82427f9c77cc@syzkaller.appspotmail.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	apopple@nvidia.com, byungchul@sk.com, david@kernel.org,
	gourry@gourry.net, joshua.hahnjy@gmail.com,
	linux-kernel@vger.kernel.org, matthew.brost@intel.com,
	rakie.kim@sk.com, syzkaller-bugs@googlegroups.com,
	ying.huang@linux.alibaba.com, ziy@nvidia.com,
	dri-devel@lists.freedesktop.org, Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>
Subject: Re: [PATCH] drm/lease: Limit amount of maximum objects per lease.
Message-ID: <202605281856.LeAMyg6G-lkp@intel.com>
References: <b3390013-f0de-4e23-a915-23340594fb49@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3390013-f0de-4e23-a915-23340594fb49@linux.intel.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: znco6u1dbeix76wj4qmq9qky9ffy4r7s
X-Rspamd-Queue-Id: 04D931C0007
X-Rspam-User: 
X-HE-Tag: 1779963801-697035
X-HE-Meta: U2FsdGVkX1/zR/T2c1zrMrIs3vkhvyENFxwr/DJwjKvFjoMQ3MSt97HzPgzE7pgmTLrlM/xLbjgNeCH6eGnDz8GTw60xCxp1aVINn8bIGTqz1ufwZf4KUl1dg+Xn1mBw2h5l+aFRat30Ka2zNiJzzIHda9lXGfcmiRuQ2Ox+XB41ipn1jdL6ZQ/sQrzNe/uZoToU5cYYbG+cykSsbcyzCIMlk9iDCc8iYcYuuy0am1ID+5zAsIOh28vuTP4Rfqjrkwx5mfgMHlNeEboyTWuBwDIe6VBi3MC9NeU80quzB8NFirQDWdOXVtFrL+2UvNXThZWiXZhbcnEe8ClWdTqSKhfG7ZJQjWNPJkT0CJ0ydCnk5h02DZDrvvpgrPYieRDYqkNVmbpKRO4zT5Jr/5Gupac7k7RLS3OK1c0uG/q6xECvjBQda9Dt6udhxF6cXSKJG1y5X8BIfkIbX8jcWtYahBFLe3hF7HQczgqk0Fhbo1lcJ0Z+4YcmtSdNERFQqDcBqBUbFioB93L8R8bkGzZ8mfiqCyxoGSJpayQbuDxPQBQ2OtGajZQFN+ytGsR4vyyzkd25q/T8Ing0XRRhO9DqSyf7u4v0zbUueHzpIzw7LtM4kwiiXPA9HgcQk8H7dVqRITvN6Om4WvPkphiC0fLQoYn2dzhlfr/BRnlEfjs6LSyYSCa8NuhSdgF2Hgfsa6n8JPcUgraJYXuyFOmKtyMu5XMWUfYhmlPpeoriIDBt/IXPbdzi9jVuJQvwglSN8ST32F8hIgk371HU8eq+xyU3xHs1Uavrh9T1NnNAMGURQF3fGSWEOKPhetT38OVHSFN8hjJKpvaqbi3FEmER5LHjTk+wZxdIrmrDRXL9ZICGKWEAfUlqTN/3NNyhsYypnxIK2rACLMaphqH4KLM942a2/WNaEqqlk4PZFKQQ/0eIqYu1gvUlLimZqU2YOVINxkOj+8MY6m/jPWK943TDwWb
 2f9FwbIu
 KVsUfvOSVpL6j4xNZvShtmH+VoxHDGv0wS7pV4aA2M6+0Uu0TxhRB5gOfM8WN4VSvJaECXq5CkdusXrTQ8vT3Yru4dkSuHITGjwVhQ9vTSH0b5iSOgd4Nb9hWZtS8EdFPInSeQTfWdxArMcSnCsMZvnzXwyiCjmXQhjKsob4PjJFYwbgOWIyMAbibpBg0JkI/H/zV/E6oX492tQVEsCxGv9wdo/4+vp7RHVIpOMa4RPNF26xJO0EEeurYIdwGBaATqn5r0YkPClIMSJ7y+4kkcn1VapQXPFyI+/dr8eBDtCGVxl/28yzn8KqF3jTEWJjqVqCSXFyCtDMgdpETG6Y0qY4BNCoiP/751kJfwtsen7/80w3ztRnuur8BQiaL44dlYM5BwYiKfXyPdLFpgtztUpK6YFYKt5ooM4NX2oXqn9KSSncmovptnqCs7UcYVn/qiKn8sPwj5TZHQLhpgc/pIJAQivL0TPbLYDNVWCY7QYuMKiymljM4o4EsfLvJnKC0OWHT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Maarten,

kernel test robot noticed the following build warnings:

[auto build test WARNING on drm-misc/drm-misc-next]
[also build test WARNING on akpm-mm/mm-everything daeinki-drm-exynos/exynos-drm-next drm/drm-next drm-i915/for-linux-next drm-i915/for-linux-next-fixes drm-tip/drm-tip linus/master v7.1-rc5 next-20260527]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Maarten-Lankhorst/drm-lease-Limit-amount-of-maximum-objects-per-lease/20260527-180216
base:   https://gitlab.freedesktop.org/drm/misc/kernel.git drm-misc-next
patch link:    https://lore.kernel.org/r/b3390013-f0de-4e23-a915-23340594fb49%40linux.intel.com
patch subject: [PATCH] drm/lease: Limit amount of maximum objects per lease.
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20260528/202605281856.LeAMyg6G-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260528/202605281856.LeAMyg6G-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605281856.LeAMyg6G-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/gpu/drm/drm_lease.c:13:
   drivers/gpu/drm/drm_lease.c: In function 'drm_mode_create_lease_ioctl':
>> drivers/gpu/drm/drm_lease.c:513:36: warning: format '%ld' expects argument of type 'long int', but argument 5 has type 'size_t' {aka 'unsigned int'} [-Wformat=]
     513 |                 drm_dbg_lease(dev, "too many objects (%ld)\n", object_count);
         |                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~  ~~~~~~~~~~~~
         |                                                                |
         |                                                                size_t {aka unsigned int}
   include/drm/drm_print.h:563:39: note: in definition of macro 'drm_dev_dbg'
     563 |         __drm_dev_dbg(NULL, dev, cat, fmt, ##__VA_ARGS__)
         |                                       ^~~
   drivers/gpu/drm/drm_lease.c:513:17: note: in expansion of macro 'drm_dbg_lease'
     513 |                 drm_dbg_lease(dev, "too many objects (%ld)\n", object_count);
         |                 ^~~~~~~~~~~~~
   drivers/gpu/drm/drm_lease.c:513:57: note: format string is defined here
     513 |                 drm_dbg_lease(dev, "too many objects (%ld)\n", object_count);
         |                                                       ~~^
         |                                                         |
         |                                                         long int
         |                                                       %d


vim +513 drivers/gpu/drm/drm_lease.c

   468	
   469	/*
   470	 * The master associated with the specified file will have a lease
   471	 * created containing the objects specified in the ioctl structure.
   472	 * A file descriptor will be allocated for that and returned to the
   473	 * application.
   474	 */
   475	int drm_mode_create_lease_ioctl(struct drm_device *dev,
   476					void *data, struct drm_file *lessor_priv)
   477	{
   478		struct drm_mode_create_lease *cl = data;
   479		size_t object_count;
   480		int ret = 0;
   481		struct idr leases;
   482		struct drm_master *lessor;
   483		struct drm_master *lessee = NULL;
   484		struct file *lessee_file = NULL;
   485		struct file *lessor_file = lessor_priv->filp;
   486		struct drm_file *lessee_priv;
   487		int fd = -1;
   488		uint32_t *object_ids;
   489		static const size_t max_objects =
   490			8 * sizeof(drm_crtc_mask(NULL)) +
   491			8 * sizeof(drm_plane_mask(NULL)) +
   492			8 * sizeof(drm_connector_mask(NULL));
   493	
   494		/* Can't lease without MODESET */
   495		if (!drm_core_check_feature(dev, DRIVER_MODESET))
   496			return -EOPNOTSUPP;
   497	
   498		if (cl->flags && (cl->flags & ~(O_CLOEXEC | O_NONBLOCK))) {
   499			drm_dbg_lease(dev, "invalid flags\n");
   500			return -EINVAL;
   501		}
   502	
   503		lessor = drm_file_get_master(lessor_priv);
   504		/* Do not allow sub-leases */
   505		if (lessor->lessor) {
   506			drm_dbg_lease(dev, "recursive leasing not allowed\n");
   507			ret = -EINVAL;
   508			goto out_lessor;
   509		}
   510	
   511		object_count = cl->object_count;
   512		if (object_count > max_objects) {
 > 513			drm_dbg_lease(dev, "too many objects (%ld)\n", object_count);
   514			ret = -EINVAL;
   515			goto out_lessor;
   516		}
   517	
   518		/* Handle leased objects, if any */
   519		idr_init(&leases);
   520		if (object_count != 0) {
   521			object_ids = memdup_array_user(u64_to_user_ptr(cl->object_ids),
   522						       object_count, sizeof(__u32));
   523			if (IS_ERR(object_ids)) {
   524				ret = PTR_ERR(object_ids);
   525				idr_destroy(&leases);
   526				goto out_lessor;
   527			}
   528	
   529			/* fill and validate the object idr */
   530			ret = fill_object_idr(dev, lessor_priv, &leases,
   531					      object_count, object_ids);
   532			kfree(object_ids);
   533			if (ret) {
   534				drm_dbg_lease(dev, "lease object lookup failed: %i\n", ret);
   535				idr_destroy(&leases);
   536				goto out_lessor;
   537			}
   538		}
   539	
   540		/* Allocate a file descriptor for the lease */
   541		fd = get_unused_fd_flags(cl->flags & (O_CLOEXEC | O_NONBLOCK));
   542		if (fd < 0) {
   543			idr_destroy(&leases);
   544			ret = fd;
   545			goto out_lessor;
   546		}
   547	
   548		drm_dbg_lease(dev, "Creating lease\n");
   549		/* lessee will take the ownership of leases */
   550		lessee = drm_lease_create(lessor, &leases);
   551	
   552		if (IS_ERR(lessee)) {
   553			ret = PTR_ERR(lessee);
   554			idr_destroy(&leases);
   555			goto out_leases;
   556		}
   557	
   558		/* Clone the lessor file to create a new file for us */
   559		drm_dbg_lease(dev, "Allocating lease file\n");
   560		lessee_file = file_clone_open(lessor_file);
   561		if (IS_ERR(lessee_file)) {
   562			ret = PTR_ERR(lessee_file);
   563			goto out_lessee;
   564		}
   565	
   566		lessee_priv = lessee_file->private_data;
   567		/* Change the file to a master one */
   568		drm_master_put(&lessee_priv->master);
   569		lessee_priv->master = lessee;
   570		lessee_priv->is_master = 1;
   571		lessee_priv->authenticated = 1;
   572	
   573		/* Pass fd back to userspace */
   574		drm_dbg_lease(dev, "Returning fd %d id %d\n", fd, lessee->lessee_id);
   575		cl->fd = fd;
   576		cl->lessee_id = lessee->lessee_id;
   577	
   578		/* Hook up the fd */
   579		fd_install(fd, lessee_file);
   580	
   581		drm_master_put(&lessor);
   582		drm_dbg_lease(dev, "drm_mode_create_lease_ioctl succeeded\n");
   583		return 0;
   584	
   585	out_lessee:
   586		drm_master_put(&lessee);
   587	
   588	out_leases:
   589		put_unused_fd(fd);
   590	
   591	out_lessor:
   592		drm_master_put(&lessor);
   593		drm_dbg_lease(dev, "drm_mode_create_lease_ioctl failed: %d\n", ret);
   594		return ret;
   595	}
   596	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

