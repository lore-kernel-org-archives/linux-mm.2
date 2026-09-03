Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DCD1C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 18:11:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E1626B0095; Thu,  3 Sep 2026 14:11:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B9156B0096; Thu,  3 Sep 2026 14:11:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CF3E6B0098; Thu,  3 Sep 2026 14:11:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F28E36B0095
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:11:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 789A31A05FA
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 18:11:05 +0000 (UTC)
X-FDA: 85173242490.12.764FB22
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf09.hostedemail.com (Postfix) with ESMTP id 51E45140004
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 18:11:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BOl+0SNr;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788459063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=VYjBGRLeidpuqjEQ/fo9nc/emqdnmWVf+IigDbWxmnM=;
	b=7fJSrhzQhGj7HZqdqa3zI/PkyguCI3EnzTCvXBOYC9k8+BIQI/9+Df4vpWCCT6aIZx/02V
	KbjVOmc7W7qxQU9cAUjTjPnl4kv96Gp/Q4/LSlj9QdvVKLA8u5MZFXv6C4RrjVXjAqAmlf
	WgOwH0LCQUuPYgb1NrI6tdIENRWWnFw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788459063;
	b=eGGfSNKpXUu+E4kaxiLBKdALz95dgJyGMuiCCku8j20UjLS81cJnwI+XxH2EnZ44igXv8H
	9mYIghg0l7+yXL8TqzyVL2rE5EWPNXYPtmiALALJdE6tN9+3xSudHUIoXGaF8HeTs1NQQZ
	UUCDiVuEHQLudq3lJmcSpo702iYzUGw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BOl+0SNr;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788459064; x=1819995064;
  h=date:from:to:cc:subject:message-id;
  bh=NeEWEh6osYZomfU8a3ZRvzXa61aRgTgHMGGV61D2qfU=;
  b=BOl+0SNrzyVdTC3atsrXgEfrS4CdC6ztc/jiwjq6acMAsrpCAOrzhbUt
   nmdPQmp3U5v8sSsf54eBeApQlVtK/gTYqRfsWwOS9QrNkiRuiz8k4+ekW
   IiO9KuZ56+qyv8M7LouSiBle48wJaclteoR/iaF2q3OkfKqWvl7onH/24
   4muJYMc8D5ZKUmJX4qJmhh+7rf4r+O07SQvU4E1xYDy6n8X/0hK5vT/Y7
   En0KNazZ71st9d0CjiXfRhmYXfug9AXtctCGTLBFLJIfvlyK4cj35NO1h
   qvLczMhHteUf8v5wPq6JIiCkGnsPcVEI7QmRm/77EqalbRQlsRgGgjjKS
   Q==;
X-CSE-ConnectionGUID: qPGOVyVlQLuJbdrfAjKFbw==
X-CSE-MsgGUID: O1fkIP6zTaqK4BRIHflkqw==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="111724773"
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="111724773"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 11:11:03 -0700
X-CSE-ConnectionGUID: wWNTYA9pScumfXynBy2lnw==
X-CSE-MsgGUID: TjebFYuGQjiRLq53jfZSLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="269791860"
Received: from lkp-server01.sh.intel.com (HELO bfac249b2189) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 03 Sep 2026 11:11:01 -0700
Received: from kbuild by bfac249b2189 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x2Btp-000000005D2-3lQR;
	Thu, 03 Sep 2026 18:10:57 +0000
Date: Fri, 04 Sep 2026 02:10:13 +0800
From: kernel test robot <lkp@intel.com>
To: Krystian Kaniewski <krystianmkaniewski@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: fs/ocfs2/xattr.c:643:5-8: Unneeded variable: "ret". Return
 "0" on line 665
Message-ID: <202609040247.8B3lmoqX-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 51E45140004
X-Stat-Signature: 6ghxd6nkjkbefgmpfabgznq9jnte9tf8
X-HE-Tag: 1788459063-371099
X-HE-Meta: U2FsdGVkX192LIYQpL7MA1lJ41ELtr0Fb/+frjU7UIP6ElkbIuh+sF51JJ5kJxXIzUTArOCN0sRLr3QO0s1laqkac1nIJ+sB2g6p6WEjj9aldGl2mHqUMkyqQlMg9JicV5YNcXb92PsxemyhvS2+rGB3XVfspCBq5iPaZIkXtlFWNRFVS+v35J97RZdSZLP4g2U4xh9kGplXjSlMoSbkJ2rYoPNxu2DaTm9Xew44ndHUyVnshM8KyP7fIatPWwTRVM4/f2z44TOTHbtdXwodvNfqVROJ+YnT2GQ+zPAoJ4yfKOts4GcMfDd8vHUKpWqZMBcPMn0irzMN7DSipEamYAd0BROx6RyMC+PIAyCcIE5QpXt5FlYM8SOEYJXRPPrOEpE78tjTOcwKvTKwJMlnbvvJ5I/axvq5yaPo+fKcLaaXzkvA3+bmcT7dOTpUMMng5K7mjSDZZAlZoEfjZfhDPdtQKMfcDliHTvVyIPMHVUbIIV7aR7EoraPihbbvZN6bo4BkkskfJg2eUC9knhp84JhWNVw7pZHRIqsj7g/BaWAbr7dFvHusqiLTKaDf/C8AxyCM+QD78JtdFVun3PwbIN+mgbSx+MD2rQia7xb/inbtBBXwwX2886cbRVz6MflV/hvfUFf06lbhVfYi2Ba8HbeJPWy13I6arW2O3Dp+Y5ecK7GGPnf+upfYodRjj7Eywwf9gU8XD8GxOgUzs0Yf0Ic8kFLoo4JKT3CJUObp3QFZ0XDTMaUXJrjRiahBfVGTIFbcxblHL5F3CjGARFQNtjbP3ZjjKxoF6fyJ+/MiTH/tzzLzdhmAW6T8wopknCej/99lFiBeVTB8ShNokXR/+5hm4vWqjd/HtQBDVQbXGDZpRWYWkLTKRIWuxCuv5NDI7SElJwDJqJNkOP/j9lF4qjzdvICdDb6F9dRVLOUcmhWjDHhYMwavVdbgKDNB+ln8pnDiDrSkkKYg4qU1ehv
 GXSnQG+W
 JBK8wKe43CCv2l4TJQwNmljSLK3+YeoCbydC5nf6lNjkpyNStheRKDDRZzzm87H+DL3zRruFxRbFVGLhBq3L7dw98gzikaao1KRRz8/RUwPsGqvPQpqy8TMQv3D5eKUGChJXTSOEIVgpUtI/zo978f0ChSWkJ4oW8Wsedj8I2yLoE/gmRS353zwjdh+h1NYPELZ2guwm7bxRtR0TWVlUNI3kDI2V5GlaDRR5zGsUgW6MfG9i43tp6cSOdEIB2oUztgR5Ej+BDp13+gNUygCcW4wpHA/2Pq+N2yTWvPAIFfIXbINh9CW8ro1G90Y0BgqmPJsDvwVw02VubwYSa/NUXE4utskGhucO0AAlA3C9LJKYwIBs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   8ab1afb2eb246ab15b301cd255b5943d208a93c1
commit: bd7c05fb4a4776dff5a87b19008d28458647d15d ocfs2: fix circular locking dependency in ocfs2_init_acl()
date:   3 weeks ago
config: riscv-randconfig-r052-20260903 (https://download.01.org/0day-ci/archive/20260904/202609040247.8B3lmoqX-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 8.5.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Fixes: bd7c05fb4a47 ("ocfs2: fix circular locking dependency in ocfs2_init_acl()")
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609040247.8B3lmoqX-lkp@intel.com/

cocci warnings: (new ones prefixed by >>)
>> fs/ocfs2/xattr.c:643:5-8: Unneeded variable: "ret". Return "0" on line 665

vim +643 fs/ocfs2/xattr.c

534eadddc1de87 Tiger Yang         2008-11-14  637  
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  638  int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
89c38bd0ade3c5 Tiger Yang         2008-11-14  639  			  struct ocfs2_security_xattr_info *si,
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  640  			  int *want_clusters, int *xattr_credits,
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  641  			  int *want_meta, struct ocfs2_acl_state *acl_state)
89c38bd0ade3c5 Tiger Yang         2008-11-14  642  {
89c38bd0ade3c5 Tiger Yang         2008-11-14 @643  	int ret = 0;
89c38bd0ade3c5 Tiger Yang         2008-11-14  644  	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
0e445b6fe93c72 Tiger Yang         2008-12-09  645  	int s_size = 0, a_size = 0, acl_len = 0, new_clusters;
89c38bd0ade3c5 Tiger Yang         2008-11-14  646  
89c38bd0ade3c5 Tiger Yang         2008-11-14  647  	if (si->enable)
89c38bd0ade3c5 Tiger Yang         2008-11-14  648  		s_size = ocfs2_xattr_entry_real_size(strlen(si->name),
89c38bd0ade3c5 Tiger Yang         2008-11-14  649  						     si->value_len);
89c38bd0ade3c5 Tiger Yang         2008-11-14  650  
89c38bd0ade3c5 Tiger Yang         2008-11-14  651  	if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  652  		if (acl_state->default_acl && S_ISDIR(mode)) {
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  653  			acl_len = acl_state->default_acl->a_count *
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  654  				  sizeof(struct ocfs2_acl_entry);
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  655  			a_size += ocfs2_xattr_entry_real_size(0, acl_len);
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  656  		}
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  657  		if (acl_state->acl) {
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  658  			acl_len = acl_state->acl->a_count *
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  659  				  sizeof(struct ocfs2_acl_entry);
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  660  			a_size += ocfs2_xattr_entry_real_size(0, acl_len);
89c38bd0ade3c5 Tiger Yang         2008-11-14  661  		}
89c38bd0ade3c5 Tiger Yang         2008-11-14  662  	}
89c38bd0ade3c5 Tiger Yang         2008-11-14  663  
89c38bd0ade3c5 Tiger Yang         2008-11-14  664  	if (!(s_size + a_size))
89c38bd0ade3c5 Tiger Yang         2008-11-14 @665  		return ret;
89c38bd0ade3c5 Tiger Yang         2008-11-14  666  
89c38bd0ade3c5 Tiger Yang         2008-11-14  667  	/*
89c38bd0ade3c5 Tiger Yang         2008-11-14  668  	 * The max space of security xattr taken inline is
89c38bd0ade3c5 Tiger Yang         2008-11-14  669  	 * 256(name) + 80(value) + 16(entry) = 352 bytes,
89c38bd0ade3c5 Tiger Yang         2008-11-14  670  	 * The max space of acl xattr taken inline is
89c38bd0ade3c5 Tiger Yang         2008-11-14  671  	 * 80(value) + 16(entry) * 2(if directory) = 192 bytes,
a0f8a9a9636e19 Dmitry Antipov     2024-11-15  672  	 * when blocksize = 512, may reserve one more cluster for
89c38bd0ade3c5 Tiger Yang         2008-11-14  673  	 * xattr bucket, otherwise reserve one metadata block
89c38bd0ade3c5 Tiger Yang         2008-11-14  674  	 * for them is ok.
6c9fd1dc0a597e Tiger Yang         2009-03-06  675  	 * If this is a new directory with inline data,
6c9fd1dc0a597e Tiger Yang         2009-03-06  676  	 * we choose to reserve the entire inline area for
6c9fd1dc0a597e Tiger Yang         2009-03-06  677  	 * directory contents and force an external xattr block.
89c38bd0ade3c5 Tiger Yang         2008-11-14  678  	 */
89c38bd0ade3c5 Tiger Yang         2008-11-14  679  	if (dir->i_sb->s_blocksize == OCFS2_MIN_BLOCKSIZE ||
6c9fd1dc0a597e Tiger Yang         2009-03-06  680  	    (S_ISDIR(mode) && ocfs2_supports_inline_data(osb)) ||
89c38bd0ade3c5 Tiger Yang         2008-11-14  681  	    (s_size + a_size) > OCFS2_XATTR_FREE_IN_IBODY) {
9b7895efac906d Mark Fasheh        2008-11-12  682  		*want_meta = *want_meta + 1;
89c38bd0ade3c5 Tiger Yang         2008-11-14  683  		*xattr_credits += OCFS2_XATTR_BLOCK_CREATE_CREDITS;
89c38bd0ade3c5 Tiger Yang         2008-11-14  684  	}
89c38bd0ade3c5 Tiger Yang         2008-11-14  685  
89c38bd0ade3c5 Tiger Yang         2008-11-14  686  	if (dir->i_sb->s_blocksize == OCFS2_MIN_BLOCKSIZE &&
89c38bd0ade3c5 Tiger Yang         2008-11-14  687  	    (s_size + a_size) > OCFS2_XATTR_FREE_IN_BLOCK(dir)) {
89c38bd0ade3c5 Tiger Yang         2008-11-14  688  		*want_clusters += 1;
89c38bd0ade3c5 Tiger Yang         2008-11-14  689  		*xattr_credits += ocfs2_blocks_per_xattr_bucket(dir->i_sb);
89c38bd0ade3c5 Tiger Yang         2008-11-14  690  	}
89c38bd0ade3c5 Tiger Yang         2008-11-14  691  
0e445b6fe93c72 Tiger Yang         2008-12-09  692  	/*
0e445b6fe93c72 Tiger Yang         2008-12-09  693  	 * reserve credits and clusters for xattrs which has large value
0e445b6fe93c72 Tiger Yang         2008-12-09  694  	 * and have to be set outside
0e445b6fe93c72 Tiger Yang         2008-12-09  695  	 */
0e445b6fe93c72 Tiger Yang         2008-12-09  696  	if (si->enable && si->value_len > OCFS2_XATTR_INLINE_SIZE) {
0e445b6fe93c72 Tiger Yang         2008-12-09  697  		new_clusters = ocfs2_clusters_for_bytes(dir->i_sb,
89c38bd0ade3c5 Tiger Yang         2008-11-14  698  							si->value_len);
0e445b6fe93c72 Tiger Yang         2008-12-09  699  		*xattr_credits += ocfs2_clusters_to_blocks(dir->i_sb,
0e445b6fe93c72 Tiger Yang         2008-12-09  700  							   new_clusters);
0e445b6fe93c72 Tiger Yang         2008-12-09  701  		*want_clusters += new_clusters;
0e445b6fe93c72 Tiger Yang         2008-12-09  702  	}
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  703  	if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  704  		if (acl_state->default_acl && S_ISDIR(mode)) {
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  705  			acl_len = acl_state->default_acl->a_count *
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  706  				  sizeof(struct ocfs2_acl_entry);
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  707  			if (acl_len > OCFS2_XATTR_INLINE_SIZE) {
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  708  				new_clusters =
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  709  					ocfs2_clusters_for_bytes(dir->i_sb,
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  710  								 acl_len);
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  711  				*xattr_credits +=
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  712  					ocfs2_clusters_to_blocks(dir->i_sb,
0e445b6fe93c72 Tiger Yang         2008-12-09  713  								 new_clusters);
0e445b6fe93c72 Tiger Yang         2008-12-09  714  				*want_clusters += new_clusters;
89c38bd0ade3c5 Tiger Yang         2008-11-14  715  			}
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  716  		}
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  717  		if (acl_state->acl) {
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  718  			acl_len = acl_state->acl->a_count *
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  719  				  sizeof(struct ocfs2_acl_entry);
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  720  			if (acl_len > OCFS2_XATTR_INLINE_SIZE) {
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  721  				new_clusters =
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  722  					ocfs2_clusters_for_bytes(dir->i_sb,
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  723  								 acl_len);
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  724  				*xattr_credits +=
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  725  					ocfs2_clusters_to_blocks(dir->i_sb,
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  726  								 new_clusters);
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  727  				*want_clusters += new_clusters;
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  728  			}
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  729  		}
bd7c05fb4a4776 Krystian Kaniewski 2026-07-30  730  	}
89c38bd0ade3c5 Tiger Yang         2008-11-14  731  
89c38bd0ade3c5 Tiger Yang         2008-11-14  732  	return ret;
89c38bd0ade3c5 Tiger Yang         2008-11-14  733  }
89c38bd0ade3c5 Tiger Yang         2008-11-14  734  

:::::: The code at line 643 was first introduced by commit
:::::: 89c38bd0ade3c567707ed8fce088b253b0369c50 ocfs2: add ocfs2_init_acl in mknod

:::::: TO: Tiger Yang <tiger.yang@oracle.com>
:::::: CC: Mark Fasheh <mfasheh@suse.com>

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

