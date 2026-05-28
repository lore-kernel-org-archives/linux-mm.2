Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5711CD6E45
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:59:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07AF86B00B9; Thu, 28 May 2026 05:59:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0531A6B00BA; Thu, 28 May 2026 05:59:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAB8A6B00BB; Thu, 28 May 2026 05:59:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE4E16B00B9
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:59:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A33471A0766
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:59:18 +0000 (UTC)
X-FDA: 84816380796.09.1DFF057
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf18.hostedemail.com (Postfix) with ESMTP id 71BED1C000A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:59:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SSmmIlDh;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779962356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TX6WyP3wjcTj2Ihn0O2t1HCGXx4GtqX8Xv3W2XlmwPs=;
	b=FDskXfRSx9XIz6lO1dOWHT9m8hpn2Xr1A5ZPRdNvYgoXdEiHN2imACd/pJuohFDWXfON5p
	4K6dSmhLjojtjVDjloQiqVnSMxL55r742oDdHn3hIJosMQdq0KTyg1Yqrze5JsARR63GO4
	q8Vff5F+2wExMgKFhp7oQqsuZaKH5Gk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SSmmIlDh;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779962356; a=rsa-sha256;
	cv=none;
	b=7La1not2zsIC8XbR3HIKNvvyI5r6ZeAKYBYExoq/81OpNljt7tsb1jNORKy1ewwc6vbg2H
	EtPQS/f/Z41x7U4BGEv7RabrlJFYZJcRSBFhXIgH5rWSODgAV9+CUdOH3A2/5h+ymbuviM
	W1rTDvBPIeKZbZOup/x6Nf/Q217rovE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779962357; x=1811498357;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RVbc3koXQ4err9PbYblRDyJEYwnImRo0oDvglNC9DXQ=;
  b=SSmmIlDhZ9COr04pXtkTQPYzI0r7LmKgZiZ6QC2wOZKtpD0VcgkH+mpE
   cbdxFzfJYPAA2uApicBdP/btqfhsHD8f+mLRGIzjs1vLKZwXEPe2uXD5/
   Sp/Ezh4RE45Bmzn2GS9g/+6p10+b3ESIq3GCk5nWRdfHt2Yv7zjdY693n
   UxH0MFeFmrHLnxPCPX1RKrX++qGABa+dY2bRaxn+VzVzEYWwAoooMeXTc
   NJLkub20Cx7eStIMRd6FuTeybg9F0nPHSICNcd2SgfWTybWUDvbigPBVQ
   mig2QCOnIJu20hNPAUZUc12clYKsJnlcxVF25g+lPfL8H3pV3sUvPcKTn
   A==;
X-CSE-ConnectionGUID: lzQwbzFGQzieXHoBhSwTdQ==
X-CSE-MsgGUID: Ua5hUE+wTTq0OfJbZNfeHg==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="84690787"
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="84690787"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 02:59:16 -0700
X-CSE-ConnectionGUID: mkTEZP3cRj+k5DYuQ58yeA==
X-CSE-MsgGUID: A+RjZFUHRLql4VDS9C8C+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="238322491"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 28 May 2026 02:59:10 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wSXW7-000000005oI-107J;
	Thu, 28 May 2026 09:59:07 +0000
Date: Thu, 28 May 2026 17:58:32 +0800
From: kernel test robot <lkp@intel.com>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	syzbot <syzbot+5d32c8bd82427f9c77cc@syzkaller.appspotmail.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
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
Message-ID: <202605281701.Blefmpwd-lkp@intel.com>
References: <b3390013-f0de-4e23-a915-23340594fb49@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3390013-f0de-4e23-a915-23340594fb49@linux.intel.com>
X-Stat-Signature: asucsny6o4hx3wedctf43qwwrudd7awj
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 71BED1C000A
X-Rspam-User: 
X-HE-Tag: 1779962356-837862
X-HE-Meta: U2FsdGVkX19yWeVmb6W0HSq3F43KwA84YYwD9QeZ+ykjXPeCchcgJmNHUXLbRVbW4Iz5kOzl2athuHGZTkXujIkmd8jJS/4etgDgaPpWojGvomw/LhlhVi5VHAwYxf+l5smmq9EWDn4p/ja4+uPAwASooXHGI0dpuTFlkYUqoPnTXn+L84602dXKncPnDYZb6kFS95mpQurJ2bSizMWhxRAEcz+6R0VjtZARF7aSmSl9sP1d+wX3FHE7hR6wXtdVPMQ6geHUc35xJuWfy7yibu9qAOFmxGkzyQJ2zm36H+zMfN+wPbXzGCWgWItqfcTN+ay45cdAfej2wJJEVwnyS5knqzdm6qYGG+3ptSDBLO0ROgpA0rk1dK82xf/4eEMQ9x3CEnPzPNRQzw3xe165BadO9wSPX+VzzWSIU3l8XBzmvZJ8YXsMRorlj/lT37i8ru2Igp9BbO8qF62jLNh33ccnx06VqZt0eg7h5hhVM4WpecNt9etmOfd4dj4TXu/8y/KeqVIG2LQVwe5T114/x4aBtGcP+bYdI/fnjnCNoed1zV4iWeENZz3pDizQzYteAIJu977qXv5HLGf2iEAo1zNOq1rRRQU+zAA7VcaLFXxiWW02JW3HBS376HrSV6WHdbtt8uqO6lQkKSjAIBn3pYLnuYC0kUKhXShkQamByhbbhSQy1ohrdcrKCk2SapeRX6brmGD+kyTIREtrlrWdB51QDhblTyvZa/bg/ZwtwVxBUXxVBaH1aRnPaiG+H6f5R3643fOz25BMBLG7euQGwcS1bBI5uUOYlT+CFH/rZhrpkAhXRskm71qP6gySmU6B8uamBzaEZE4TB84lv++p8F9MWcqthv2d6zu9HZXcoJcdaNHDz/XmZP9dN9I3WJ9c3gAYrjO1Os1kUhJKEHXNmvvC50t6ueqvCx9eFlulq5U1tayJTjTMEhj4TzLZKifmyDzt06bmlTG1L9MUFEE
 lwnnFxCq
 XsLC7EQ7QvR8467877GLCt9/2t9ILGcfS14y/ZRj6ugzCvom5PA9F7ZioGfDYbahiOwHSth7dd/aR9RYKeVfgBNVgSe27eCMBvfsSqxFfzisAhWw8+C5yoBoUKktWepfy1weVSlkC9vJzlGODTfobSbvbxuMQWoXAIjUk8390VuQrWvWZqegQtQu/d7vlz0D8UyIoY2p9oZojU+HmB1djvLVLnzCFYsa0uXKFsb6f65oXTVGllItQhc7QCklhSFh4VjoyRHlNQJ+asnFlgXQ5BzZ5RWpOJjKTf0m2rZWzRiC3OxaVQJ9NjE57gs6J+mm3gRAOhS1YbBLtiP1Wil3/AdXYCuRl6XEn4iuXm7H0rg4pLuvod2qvmn6l3fto1BMtzTog+NgA4Am3P6/HASu/r0IhE+ArpngKdeDPXeib9puSFpEpqZPcgQJArgP//fjh49PNMBJDF/wuSqPIfw0RqTZaDEclRe9rT0wW+eRZXtf8ypeJ4Gr+LTGspODl6rOnOaVI
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
config: hexagon-allmodconfig (https://download.01.org/0day-ci/archive/20260528/202605281701.Blefmpwd-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260528/202605281701.Blefmpwd-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605281701.Blefmpwd-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/gpu/drm/drm_lease.c:513:50: warning: format specifies type 'long' but the argument has type 'size_t' (aka 'unsigned int') [-Wformat]
     513 |                 drm_dbg_lease(dev, "too many objects (%ld)\n", object_count);
         |                                                       ~~~      ^~~~~~~~~~~~
         |                                                       %zu
   include/drm/drm_print.h:663:54: note: expanded from macro 'drm_dbg_lease'
     663 |         drm_dev_dbg(__drm_to_dev(drm), DRM_UT_LEASE, fmt, ##__VA_ARGS__)
         |                                                      ~~~    ^~~~~~~~~~~
   include/drm/drm_print.h:563:39: note: expanded from macro 'drm_dev_dbg'
     563 |         __drm_dev_dbg(NULL, dev, cat, fmt, ##__VA_ARGS__)
         |                                       ~~~    ^~~~~~~~~~~
   1 warning generated.


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

