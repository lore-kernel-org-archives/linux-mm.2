Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 317EAFD9E3C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 05:52:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64F986B0005; Fri, 27 Feb 2026 00:52:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FDBC6B0088; Fri, 27 Feb 2026 00:52:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FC276B0089; Fri, 27 Feb 2026 00:52:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 352276B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:52:48 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CAF7B1C5AC
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 05:52:47 +0000 (UTC)
X-FDA: 84489167574.02.FE7ADD4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf30.hostedemail.com (Postfix) with ESMTP id 67C5380009
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 05:52:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PX61LFfz;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772171565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dtWNJDPoYaK6UoekXQbiIKRCxmmSnaHP4MoapppzNXk=;
	b=T6XALQfWaRnkexJhl1XOSC/h5Bojpibio58VLgnR5cfQg7VbXlh6tBoQ8LVHkndFSHAEua
	WorIapmiDEu1kJ2zx6NObENuVpqBh6zFNvaIMyBD18mx4eh1605PEZ9s1UB3hV4iU2NKBB
	2qVjR/Gnii01o+kCpzFuGp4hJng0bHQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PX61LFfz;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772171565; a=rsa-sha256;
	cv=none;
	b=rcQf52/cMgjIHPP/lN/QtwJ1cm1XjtzeROa67FySQwQ+pC6sf+lOu9KM4+MUj4nI7GnUCx
	o75+RfmLAYP1+UZWqBcaXBjspIUBKAqCokixwKv3AOdMUzbxIwZuEIbHlna3dbXWr4HAiW
	tvSffbGjU767dFvzr6w/YAVpDTRrt64=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772171565; x=1803707565;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LWOdmL0uan22tNsv3PGdyHuaOVgzT4VqOM5Rm/fNGco=;
  b=PX61LFfzb4LqTCQuemgcs6mBocgxqmPdXcT+mFATJ+sDs2WYVU2I4YAy
   a05DA2nZyAf1Ko9E5QbhQG7EfC6c/mX2i8cPjfScepAt+zxe79MdtOMmD
   wexPHRlgz7iQvt+7LE3VxJkH+9haFQoQQtXDqAEOgcYhyrVEZ8gK66BIM
   RXteMMx0oELiBNczxuCCwwLIpO+wUNOWKhGtEstXqxYV2LuFsWRhxB6/t
   Lp5ViaRtO3Qg1t4lsRsu+FV2TO0Wx0mE2sO6RwqMDwf7sab34X2zfDUPV
   bGb8qTI/qMsyxY8X5B8G6SOJjpRCYNRIc+Q8Cfo7mCx0uuxxhVLTn1eRu
   w==;
X-CSE-ConnectionGUID: MlFakGBPTL+cpQGtscO6nw==
X-CSE-MsgGUID: wOm61TyQT4GuFfE+19b3oQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11713"; a="73121980"
X-IronPort-AV: E=Sophos;i="6.21,313,1763452800"; 
   d="scan'208";a="73121980"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 21:52:41 -0800
X-CSE-ConnectionGUID: 62b9Y3uDQlyrKfLirF6oHQ==
X-CSE-MsgGUID: vnQDeMXOQSSCRScW/BACmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,313,1763452800"; 
   d="scan'208";a="214993740"
Received: from lkp-server02.sh.intel.com (HELO a3936d6a266d) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 26 Feb 2026 21:52:37 -0800
Received: from kbuild by a3936d6a266d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vvqmA-00000000AE3-0V4y;
	Fri, 27 Feb 2026 05:52:34 +0000
Date: Fri, 27 Feb 2026 13:52:18 +0800
From: kernel test robot <lkp@intel.com>
To: Harry Yoo <harry.yoo@oracle.com>, venkat88@linux.ibm.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	akpm@linux-foundation.org, ast@kernel.org, cgroups@vger.kernel.org,
	cl@gentwo.org, hannes@cmpxchg.org, hao.li@linux.dev,
	harry.yoo@oracle.com, linux-mm@kvack.org, mhocko@kernel.org,
	muchun.song@linux.dev, rientjes@google.com,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, surenb@google.com,
	vbabka@suse.cz
Subject: Re: [PATCH] mm/slab: a debug patch to investigate the issue further
Message-ID: <202602271320.ywOCYQx4-lkp@intel.com>
References: <20260227030733.9517-1-harry.yoo@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227030733.9517-1-harry.yoo@oracle.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 67C5380009
X-Stat-Signature: m5m8c3xf917wzu4rh474syuc6jzxfs3g
X-HE-Tag: 1772171564-372545
X-HE-Meta: U2FsdGVkX1+/mnrkpsJkfswhTbko2cqVzBp/ScbUIob36ZnQhqGKzPsvP1zeeeeirD6umpHTwdTF7J0ek8m3aAfkwiNiCIkI8JYs5PDuTKgsXRkHZKBoI57vDmMab6ZDEXRtlsLz0RWTJUVXj0dA0Ho2UeG4IVFts8kiZbBBzitmrOjus+XPzOdKsxfH4FmOE9bjh4zD/ayRzxn3p9cOlqaIV7BfPWpuxQWL76CUwBUt70d+VPYdoYn73+RdPzZZu79Dh9dO+//WgrnnLobfHYxeiWxm0FwzyeMNynh/CTUYTb9zVnJAaiHHXKBRLXKXBijYNx4atJT8Rc8ilnBB+H0EBk5gVdpmfq7CPEPIlpCgDBO0EobyrXRK73Yyr63oTu3XgJx39mBqQnzpBEiDbRdSD3tyJw62QehjLPlNLbi3o6ScPRKdPuoI0ooxQ7exy/0NVMJlfR9m8l52g3JfMuPeYXlMBhGfxKdbzVUkmnuEJExaclHWLRqzC7cOCsQ+saNhQou0lLIf5GoitNS9A73ibrChtohTkrruWQmeNG3wu6byRoNbp6HjXSFH37WUXTbRRQQpvZEUxF3GdtA92C9M1Ngvkv69i2jU0TKYNvMh68dlqCwzSuoZ1KtctC3UcC9LEowimFalU/OSyXXkRBIdVrTAPdSgiFGb45MkNeejFe7yoXtp9saIfJduDXgmmWxVdc2SI+5JC2FlVcJKSbO4v5UWLxr2+Rbx3PsyZqwlN4AprUkt3CidxkjQmY6xSfgLknVUVuE5J3ghrSZ3Zy+gEl0eUc+CUSPBkKJeAwNZBCnvOCfbvU8kjDk9Ds/G1imrg3qH2WjgP0M8WusKolwOfZL24Xtxy+CzbAqtihV2pYrWQNZUptPXHA/8YFMxAzhhUEz1u4/SH929RhrbZPGvb3q7hmOaJ0aJQYNTkg3rW8g2etiMb0pG7QPAZyFmTva14oYXhv2qB1mGdzJ
 +f5aamuN
 TfomK9woMeM7XKKsLhm6T8qBNBe4Jhokm+VjDyAR9Bmy3mJ7MKxAaD4n3tNAYBEc3/s94ASUM1oFVopcX1mdy69GkRciTGiue4o2ocOzQRTiQv/XJ8/YigRsA59Yu3Vcj1BuIlssL7U83mafoAvQB3yhlyzQmZXWD+GwFbgq5IjD3NHOt8qtMu6VAVCZR4fYD/hSlNqObr3+IKadjcuL/G7vnPuF9+DZjPocXf8Y5GCiAnCDIfPQ4D9rJU9ZQXgh2oP0M8IALNFXhgwql8zo11DLjIvTSm/WJaGO0QE/5gmYwQKnPjPjUegYem0iHQGAfr3k1pcZ6uHcWYcUYxDIPhi031lb4HiG1OtmU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Harry-Yoo/mm-slab-a-debug-patch-to-investigate-the-issue-further/20260227-111246
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260227030733.9517-1-harry.yoo%40oracle.com
patch subject: [PATCH] mm/slab: a debug patch to investigate the issue further
config: x86_64-allnoconfig (https://download.01.org/0day-ci/archive/20260227/202602271320.ywOCYQx4-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260227/202602271320.ywOCYQx4-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602271320.ywOCYQx4-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/slub.c:1330:6: error: call to undeclared function 'obj_exts_in_slab'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1330 |         if (obj_exts_in_slab(s, slab) && !obj_exts_in_object(s, slab)) {
         |             ^
>> mm/slub.c:1332:16: error: call to undeclared function 'obj_exts_offset_in_slab'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1332 |                 remainder -= obj_exts_offset_in_slab(s, slab);
         |                              ^
   mm/slub.c:1332:16: note: did you mean 'obj_exts_offset_in_object'?
   mm/slub.c:793:28: note: 'obj_exts_offset_in_object' declared here
     793 | static inline unsigned int obj_exts_offset_in_object(struct kmem_cache *s)
         |                            ^
>> mm/slub.c:1333:16: error: call to undeclared function 'obj_exts_size_in_slab'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1333 |                 remainder -= obj_exts_size_in_slab(slab);
         |                              ^
   3 errors generated.


vim +/obj_exts_in_slab +1330 mm/slub.c

81819f0fc8285a Christoph Lameter          2007-05-06  1311  
39b264641a0c3b Christoph Lameter          2008-04-14  1312  /* Check the pad bytes at the end of a slab page */
adea9876180664 Ilya Leoshkevich           2024-06-21  1313  static pad_check_attributes void
adea9876180664 Ilya Leoshkevich           2024-06-21  1314  slab_pad_check(struct kmem_cache *s, struct slab *slab)
81819f0fc8285a Christoph Lameter          2007-05-06  1315  {
2492268472e7d3 Christoph Lameter          2007-07-17  1316  	u8 *start;
2492268472e7d3 Christoph Lameter          2007-07-17  1317  	u8 *fault;
2492268472e7d3 Christoph Lameter          2007-07-17  1318  	u8 *end;
5d682681f8a2bd Balasubramani Vivekanandan 2018-01-31  1319  	u8 *pad;
2492268472e7d3 Christoph Lameter          2007-07-17  1320  	int length;
2492268472e7d3 Christoph Lameter          2007-07-17  1321  	int remainder;
81819f0fc8285a Christoph Lameter          2007-05-06  1322  
81819f0fc8285a Christoph Lameter          2007-05-06  1323  	if (!(s->flags & SLAB_POISON))
a204e6d626126d Miaohe Lin                 2022-04-19  1324  		return;
81819f0fc8285a Christoph Lameter          2007-05-06  1325  
bb192ed9aa7191 Vlastimil Babka            2021-11-03  1326  	start = slab_address(slab);
bb192ed9aa7191 Vlastimil Babka            2021-11-03  1327  	length = slab_size(slab);
39b264641a0c3b Christoph Lameter          2008-04-14  1328  	end = start + length;
70089d01880750 Harry Yoo                  2026-01-13  1329  
a77d6d33868502 Harry Yoo                  2026-01-13 @1330  	if (obj_exts_in_slab(s, slab) && !obj_exts_in_object(s, slab)) {
70089d01880750 Harry Yoo                  2026-01-13  1331  		remainder = length;
70089d01880750 Harry Yoo                  2026-01-13 @1332  		remainder -= obj_exts_offset_in_slab(s, slab);
70089d01880750 Harry Yoo                  2026-01-13 @1333  		remainder -= obj_exts_size_in_slab(slab);
70089d01880750 Harry Yoo                  2026-01-13  1334  	} else {
39b264641a0c3b Christoph Lameter          2008-04-14  1335  		remainder = length % s->size;
70089d01880750 Harry Yoo                  2026-01-13  1336  	}
70089d01880750 Harry Yoo                  2026-01-13  1337  
81819f0fc8285a Christoph Lameter          2007-05-06  1338  	if (!remainder)
a204e6d626126d Miaohe Lin                 2022-04-19  1339  		return;
81819f0fc8285a Christoph Lameter          2007-05-06  1340  
5d682681f8a2bd Balasubramani Vivekanandan 2018-01-31  1341  	pad = end - remainder;
a79316c6178ca4 Andrey Ryabinin            2015-02-13  1342  	metadata_access_enable();
aa1ef4d7b3f67f Andrey Konovalov           2020-12-22  1343  	fault = memchr_inv(kasan_reset_tag(pad), POISON_INUSE, remainder);
a79316c6178ca4 Andrey Ryabinin            2015-02-13  1344  	metadata_access_disable();
2492268472e7d3 Christoph Lameter          2007-07-17  1345  	if (!fault)
a204e6d626126d Miaohe Lin                 2022-04-19  1346  		return;
2492268472e7d3 Christoph Lameter          2007-07-17  1347  	while (end > fault && end[-1] == POISON_INUSE)
2492268472e7d3 Christoph Lameter          2007-07-17  1348  		end--;
2492268472e7d3 Christoph Lameter          2007-07-17  1349  
3f6f32b14ab354 Hyesoo Yu                  2025-02-26  1350  	slab_bug(s, "Padding overwritten. 0x%p-0x%p @offset=%tu",
e1b70dd1e6429f Miles Chen                 2019-11-30  1351  		 fault, end - 1, fault - start);
5d682681f8a2bd Balasubramani Vivekanandan 2018-01-31  1352  	print_section(KERN_ERR, "Padding ", pad, remainder);
3f6f32b14ab354 Hyesoo Yu                  2025-02-26  1353  	__slab_err(slab);
2492268472e7d3 Christoph Lameter          2007-07-17  1354  
5d682681f8a2bd Balasubramani Vivekanandan 2018-01-31  1355  	restore_bytes(s, "slab padding", POISON_INUSE, fault, end);
81819f0fc8285a Christoph Lameter          2007-05-06  1356  }
81819f0fc8285a Christoph Lameter          2007-05-06  1357  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

