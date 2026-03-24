Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D2DBF532FE
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 09:10:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A66346B0089; Tue, 24 Mar 2026 05:10:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F0216B008A; Tue, 24 Mar 2026 05:10:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B7E96B008C; Tue, 24 Mar 2026 05:10:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7784E6B0089
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:10:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0C55A91C2A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:10:58 +0000 (UTC)
X-FDA: 84580386996.14.ECC7C7B
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf02.hostedemail.com (Postfix) with ESMTP id E4CBC80011
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:10:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=Fyi42U4L;
	spf=pass (imf02.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.41 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774343456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=ySFCnBOOL5CefvlohZg7FDp7ZB+X1Q7Muut2F1vaWbU=;
	b=pgGhWfkgmtM1yWmfyh6b/J5USb9r+5zdf0QiZYOXFNrnEHhfhNp+yt0T+PbSC1st/Euc1m
	Z3XvUYrjFkgowHsi4U+d3h8n4pOjU2OUfw0UqSXQVE/Om8o4dSCxflhk5dAGoPbyNHq2qN
	pHoni5rlquXrAjmsbrVjrQHKaR6weII=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=Fyi42U4L;
	spf=pass (imf02.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.41 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774343456; a=rsa-sha256;
	cv=none;
	b=ljEQTxHQZpOlsYVPJNWiAAuVXIZsi+3OLlX+f49SeeMHnqQIwBsz2B6mAbVv5URavxJ8kA
	nQXIHxPuuAGZrOdkkMRHJXmKKJcb4fWycLdoOIT0P4Dwj6sU7M5Wx6txh1dd5bt0bFRtYH
	WGZkYhh5jBo7XB4CERwzDEHEJX5KwQA=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-486fc4725f0so43394435e9.1
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 02:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1774343454; x=1774948254; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ySFCnBOOL5CefvlohZg7FDp7ZB+X1Q7Muut2F1vaWbU=;
        b=Fyi42U4LNMhgKYTCMb5PyLZHwv/TpryFKGoQNCp8IZqqW5RezttI7j5fgADBWQQLgx
         PSvnueoR2J4ZeXQz1WU7mo5HZ97mQlLqeAl3TXWC58q3/Up+O2hOl+GN6rSuwO2NG24U
         WgDDTQ9xrAmm3eGpTW2CVs8gRQwMaltpQ6UQHuJW5Tdc0VvDrwSeZ+9LecyJ5wHCoE/B
         B17kI/Bv7eh+i+u7qEz7OZLNl/eiNjVS5A0RqSzAdmR4/t7VKO5lSE7qqmo0/hrsoDeX
         ubQ90Im/+zguPmTigbQZL5QVWeHqPHTypaIUpKOYNSQBrqGoFzOutB9x2jdTWnOMj6gT
         Er5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774343454; x=1774948254;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ySFCnBOOL5CefvlohZg7FDp7ZB+X1Q7Muut2F1vaWbU=;
        b=TXpyR4bx2rhKzysMHVb69v7fy7dx4FZCZfazY9XhwoNaKKaaz5bTfWoCbbpm/GIhY5
         Ns4fzRXOkvO/xIdhTLwJX+PUuk+uMytn4CFfFsl7dIosP6fXq9zoyavqFWHNgjaE+3Xe
         zACRuAlAulu5nlbZ/kSDVTldFR/M6kb4AyVwFkEHFuYrC8jjFO8oxD0jCFzSOhOwiQ4G
         jRvMvhyz0N5mTwfR/oVnXWedRta2YmALeMq9vIt7wW/+mY0hnOV1sJ2SdbvE/R81cnHd
         nT1sTcEKaFxP402t8ZUnIS2URqCz5CsM6duKlY17RALW7Y6G7Hob8anyIPu3aEGSFwPU
         KEmw==
X-Forwarded-Encrypted: i=1; AJvYcCVelP9eEKIRfB6cgH145KTWN3hjxrpj8ctaMMk9btMQx+R3WGm/yYk6KUa97fR3Un/PKwpJC9hQkg==@kvack.org
X-Gm-Message-State: AOJu0Yxp06uAGgUg6gmSPsEOU87ykrmtOqDDlSii5rsqjdBZk/xOOPet
	9rOf9479VsPGjfSpbcBszta/q0CDJZ4v0EZJbzZYBYsY3EwXSkhsei+aTdJeFdexJtXjhcdiDkM
	p+U+4
X-Gm-Gg: ATEYQzy4Eui0eElW73G9o2piV+0URMdf3QwsKS8MHEb4+plJUTZPvPvHlP1pqEElt6C
	sWDBfkwH1cGfBTRtVCvUwXPyjnhUalqFB+Y0q4+kDdRpPFUIRTFvqJPg1+UiVj1yl5E+yQ5zW+e
	IdHkvklusYb/PZ8OIeGKXfwSJd5bl3iRhLo4EKDSiheR1K85rtXJq7ZG9AvPoTXddBSn/f8RUhc
	1RsLWg3bhmsUv7fgMAc0mrH1OaJbVkUzU8dM4I8DrhXW1uB66VINVKOz66nG2Li/R5VLDCK8JyO
	7Zv35+OGcYuaQ3ovvBq+lUE5V2VbCvyaDDZzFCiXjWxo9pQCXjP95bps9i7yuGcE+yt/Bpp0p+S
	cW1T56c/pFzuOSKCzMtqgVaaENzqGdI/VjfmJFOvtiEmgJuShxCHPanQqnmd9isps9fs5gprzxz
	LBhand7QaUwkPJdtHCGXnenhk3sve3FJ7h8nHOwgQ=
X-Received: by 2002:a05:600c:154b:b0:485:3cef:d6ea with SMTP id 5b1f17b1804b1-4870f212c1emr37488815e9.13.1774343454041;
        Tue, 24 Mar 2026 02:10:54 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4871174f2desm44785325e9.9.2026.03.24.02.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 02:10:53 -0700 (PDT)
Date: Tue, 24 Mar 2026 12:10:49 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, David Carlier <devnexen@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	David Carlier <devnexen@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/memcontrol: fix obj_cgroup leak in
 mem_cgroup_css_online() error path
Message-ID: <202603241635.qNXDPwjs-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260322164943.37460-1-devnexen@gmail.com>
X-Rspam-User: 
X-Stat-Signature: dybu8hcjp5u7hhzda59hbojou9dpxc7w
X-Rspamd-Queue-Id: E4CBC80011
X-Rspamd-Server: rspam09
X-HE-Tag: 1774343455-329912
X-HE-Meta: U2FsdGVkX1/QiMkuyu5jxv/HCUWbYZpnyBbNRuhmyv54Ov0dkuHLKwgFAhsLSp5BVpZo53ApEfXNYfifT9BGAp32sU4cd+8st7sqp7xeudjtKabiS38QNhDbTQs985BH2p8UG/uiTCvWaaiAhA+Dz9G2MVAjcdXlkZkFYhI5ZBBeqP9u/SbGY8xAZduQ3rIlBAEmqRoqH0TUE/2f1fn6TlXETXm7CVdJctQITJxZecECMOcRpJQdp6DhX5XjkAqlXPhiwBhIaPxdP3fRUk7Y2P7VwircKwvoLeMHs7zOsrNW5Auh0U16v5vipHR+Dvh05IdUn6uUYhCUR6OjgD3e92Jajh2Dxa0pwHZfM0lsrPE/0+a/lCR5xFEsuH2A+sAci95ivFNjOWrwltg4BHpNrV67vjIwdVtcI0FkrzZgLpJxNwoGhHtlfLL5qv+Vhh47EKX8eJb1ZZVzr1kuBpkrNI15B5tYrNTSZHlRTNcMuMk9Md5PRv2UxAS1aPsTzFz6U28OPd9D2buCfXVujTGLVZ3yv4FsVsDQqdjXI7oFZ4zPz2kMs+cowFT99Jz7F29ATutj5h80q4KWYf8qMXZUAoZRBufAXuu5Elml4txq1AoCG5qZVr2cS7Zyv6snE/y81Ox+z9C84wKdLkipTB8rEuQzDx1E6l8Ogkl1/FLlfVl/ZBpwFJBlUPn6xUXLNmOr7SsbxBgRmxkqK/5tzCcBLM4RwAd+mzZAyyt0o+WuQH17JVLJLTR4mysucDtQzbRwwFNvkQ1nj/uGZ+2mVG71vWRar56ilIN7BnZcMAJZ0QjSRCz5GEZJFtZ6jFaCp1PkJVHnOSM5n2XqsunosdPqUFepp/Q37z1yX9F+BWDLhzObAvKeOQ9V4/uFRHAeeie8wy9QYzU3RkFFJAWu7tqLBj5TqbD5r7qQjohuflvUucvB/WOO/oAfr0AKg5mpIAc7N3xu//PgHM8mQgbcijD
 aC2DoaW7
 HbY/prsA9sJ3IxjjmGStS8vc0D1hjoDN8VDq80Saf+nhq/hHyHN4UoGNddhJu4VU4eGWvt+gvJWCv1/gXFMe1n+N61BXeW4qZkYCqERpzn3WX1AMr+fJlHhfAsgGut3d+g/ijesLXha0g37mC2zhXtTgojUPiBy0RlPjgU33HRvDJ0MYmmK2wuN9u+9jMco7KhGP5Je54fsgHvhf/0AuwM35JWDpu6TkNeEk7GhnjT7ey/oNI2v8gq5i4aJm9UqMmS1ZbMWxCxqGKRDOsTv1t611BoYH0KuA6p2KZVKEX0p9NkTx3An/yCoK8oO9XO/XNt+ZNx7D3AOtJSkXyvuex3XSfOeE+gX9BPwmzOvRWEGFm+7Yl7darnBee/7v8iR34JXBGa7sgDzVsiTile7kAwZQGyioQ7IL4ejlt0pnUISYiOcELAF1OHk0LwLUy+evWNMOOsUAAkWNTp3bKgb2Rnf+YAOh7JCAbnkR6k0Fw01R9RPbxkkOTKZsi1jtELyP2HPaNxd7tfWny7lguUyBbkoo+wfOK6byxEDBUq76Xmf6oPDp/OvStGU7F1p5INRngM0ZU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

kernel test robot noticed the following build warnings:

url:    https://github.com/intel-lab-lkp/linux/commits/David-Carlier/mm-memcontrol-fix-obj_cgroup-leak-in-mem_cgroup_css_online-error-path/20260324-010357
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260322164943.37460-1-devnexen%40gmail.com
patch subject: [PATCH] mm/memcontrol: fix obj_cgroup leak in mem_cgroup_css_online() error path
config: arm64-randconfig-r072-20260324 (https://download.01.org/0day-ci/archive/20260324/202603241635.qNXDPwjs-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 14.3.0
smatch: v0.5.0-9004-gb810ac53

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202603241635.qNXDPwjs-lkp@intel.com/

smatch warnings:
mm/memcontrol.c:4180 mem_cgroup_css_online() warn: variable dereferenced before check 'pn' (see line 4176)

vim +/pn +4180 mm/memcontrol.c

6f0df8e16eb543 Johannes Weiner  2023-08-23  4168  	 * regular ID destruction during offlining.
6f0df8e16eb543 Johannes Weiner  2023-08-23  4169  	 */
e77786b4682e69 Shakeel Butt     2025-12-25  4170  	xa_store(&mem_cgroup_private_ids, memcg->id.id, memcg, GFP_KERNEL);
6f0df8e16eb543 Johannes Weiner  2023-08-23  4171  
2f7dd7a4100ad4 Johannes Weiner  2014-10-02  4172  	return 0;
098fad3e1621cb Qi Zheng         2026-03-05  4173  free_objcg:
098fad3e1621cb Qi Zheng         2026-03-05  4174  	for_each_node(nid) {
098fad3e1621cb Qi Zheng         2026-03-05  4175  		struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
59f75a1877fbf7 David Carlier    2026-03-22 @4176  		objcg = rcu_replace_pointer(pn->objcg, NULL, true);
                                                                                            ^^^^^^^^^
Dereference

59f75a1877fbf7 David Carlier    2026-03-22  4177  		if (objcg)
59f75a1877fbf7 David Carlier    2026-03-22  4178  			percpu_ref_kill(&objcg->refcnt);
098fad3e1621cb Qi Zheng         2026-03-05  4179  
4a2f95f5c79e02 Qi Zheng         2026-03-09 @4180  		if (pn && pn->orig_objcg) {
                                                                    ^^
Checked too late.

098fad3e1621cb Qi Zheng         2026-03-05  4181  			obj_cgroup_put(pn->orig_objcg);
4a2f95f5c79e02 Qi Zheng         2026-03-09  4182  			/*
02b5fc7885d9f8 Andrew Morton    2026-03-09  4183  			 * Reset pn->orig_objcg to NULL to prevent
02b5fc7885d9f8 Andrew Morton    2026-03-09  4184  			 * obj_cgroup_put() from being called again in
02b5fc7885d9f8 Andrew Morton    2026-03-09  4185  			 * __mem_cgroup_free().
4a2f95f5c79e02 Qi Zheng         2026-03-09  4186  			 */
4a2f95f5c79e02 Qi Zheng         2026-03-09  4187  			pn->orig_objcg = NULL;
4a2f95f5c79e02 Qi Zheng         2026-03-09  4188  		}
098fad3e1621cb Qi Zheng         2026-03-05  4189  	}
a0dd8b1942f5bf Muchun Song      2026-03-05  4190  	free_shrinker_info(memcg);
da0efe30944476 Muchun Song      2022-03-22  4191  offline_kmem:
da0efe30944476 Muchun Song      2022-03-22  4192  	memcg_offline_kmem(memcg);
e77786b4682e69 Shakeel Butt     2025-12-25  4193  	mem_cgroup_private_id_remove(memcg);
da0efe30944476 Muchun Song      2022-03-22  4194  	return -ENOMEM;
8cdea7c0545426 Balbir Singh     2008-02-07  4195  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


