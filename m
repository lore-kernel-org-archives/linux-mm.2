Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BC05E9A767
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 10:54:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF97C6B0098; Tue, 24 Mar 2026 06:54:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E831C6B009B; Tue, 24 Mar 2026 06:54:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D71C46B009D; Tue, 24 Mar 2026 06:54:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C32D46B0098
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:54:38 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9B3B01BA06F
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:54:38 +0000 (UTC)
X-FDA: 84580648236.28.99B8FA6
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9D01F180016
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:54:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y8ULhDgO;
	spf=pass (imf06.hostedemail.com: domain of devnexen@gmail.com designates 209.85.161.54 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774349676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4xZa/0j22+oqg1nMErzFxx2lp9k+a1i473iPRNI2fUs=;
	b=d8IkMdUX0RQK4sxq89pY3b+5WARyJd5EX2b7cJkLZRy1vJJ0CcBUjUdaFDuTegjDE555Ic
	a6wxcgljqYpeD+hsZRHZtCzxquRaGoAAcJZY+SrXQhlLWc+tWXt55TCYx3ydgi3bOTUr7c
	FvywEDX+f9T5g+c1jomXEEHPBge4zp8=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y8ULhDgO;
	spf=pass (imf06.hostedemail.com: domain of devnexen@gmail.com designates 209.85.161.54 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774349676; a=rsa-sha256;
	cv=pass;
	b=WACi9jZlKiISZzC/gGLr/0UdYEqfMCn6C2GWGLO9bGMUG8ElFO4tie+RS66wbw8Q9cTzbT
	mzs5CVzU5kcndIaiXhf0rM2T4zVksVX5ST6xqJfa8+wmWBdh7/w12rAmqFtCJb0zEUU7dY
	wK4aHxOpiR49Vlot/A5VhZ9VNrQeTl0=
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-67baebf716bso638139eaf.3
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 03:54:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774349675; cv=none;
        d=google.com; s=arc-20240605;
        b=hNqJj8IRv7yUOVyGO1H8u8RHKbEqs1OWGPO+AlvyN5PG0uLnyGBiJ33veWC0qi9awk
         Qak+SmdmFvHZOsAEdJ6ySkebTdMACyfC1wloGInCyG+7o8XWJYPJeE1j+jwRF0/zzCrc
         WWcznO011e3GD5Z7YQMq7oK8B+dC62WzFyUkarT64c6iMajeLQ+KXb8AAKBhVhkFWw0O
         /8gaDB5dEEADK/NewKEvSMS/GESJRnoa6URVjRf6Iyu2bMwuzskStIgXk7TP2lUqmEmY
         Pb+dcE+2lcJThJjB/xb/jL6kk1w1lP1B7cDMu9Fgkx0WdAVUxHcW47s392pclIiOXWl5
         Ahng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=4xZa/0j22+oqg1nMErzFxx2lp9k+a1i473iPRNI2fUs=;
        fh=lCzyW3P4uxBDaZNEGAq4Lqa+KzuVan1YwZoD8sLlt0g=;
        b=SpmkzJqqpvwtUwFAtZrkhvKz+nUtjdM9ul2D6rH05ElQn7Rg2cUheRHVTr9OZVaCyV
         HyF1WHrPokll0C5RmfdczA5OM793Kbj4j/20sE6SL3QX8DT0yona6U9ybbqcTTNfRYkx
         xMrVLJVqJk7sZ1Sln87MuoDQDlu0EYNVUM9GTQUS2LNGaS0LKFOSFQQGXeQcP3WRlfWX
         LUBBTwjfXc9Ktmpx+1o9s70rch6L87HSW4ZSaOAPn+cpaHCKfIPkTMGfkrO1sBjy2fvZ
         aTmfS+NjFzrc08GaGJ2B2SBo1dGHbmVhcFDDDhN6sqCoCZs4i3vZjZEa3nQgmgEalw5O
         6gKw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774349675; x=1774954475; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4xZa/0j22+oqg1nMErzFxx2lp9k+a1i473iPRNI2fUs=;
        b=Y8ULhDgOzSXplAw7WrfUJmdnFs3cxnFJOUFwPiYWOSFZyQ414dl0/N0DvZfkFVpJDY
         betfNDZqQk8HFWXOgXqSOnmoa36YB1abIbR27RALl9QP9NcZ+zyN4dM13l+k7l+O6FPu
         qdK4iOetnhGHeBn7aWvAle3Nu+8/f5feSPTB2nshGNnxQ0SOCsMZ4H/Uye1GGhYuczZD
         B40Ka8pu9WSqtDHPyti+wyOi8oCy4PwD3zPT6vI7gkanHs261l7T93EDfjqIzcY9eqnK
         MVbzL/DUTuvT4C15B3FRtvJuU+P+xhkMc31fEt5vMD0Vxwq9xmEsceSuCX4qSi4uRutp
         myNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774349675; x=1774954475;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4xZa/0j22+oqg1nMErzFxx2lp9k+a1i473iPRNI2fUs=;
        b=GftNoInQcRmWVqEbuczo49h9j9pZL7C7Q98BPdsQz7/1wTlvCKPhlOJB9HZbFnynyP
         qTZu1YXkGuraxBQuU2T7OS6Jmk+yDWINM984QczViG5+rbRQZcSebyPEONrp9qzE3JGP
         nxAX/dwUYvc6neiFMGWwW6PwGYAE7k3Svh/fhzkMU2Hqoxbh4zoDiIxf0ju4dzHWFzzq
         3LufaKGVkSCwfXNEKvjbpa8pndd8M0eEZMv7Ao7VZ4UtXpAT7tfvmBXYeAZc1h7Y50rX
         IEQK4GPTs75xcJ6EFTBtozaoWUKXBKNrhqj2+ae5oK7jwGjnqbqBjxCPVZk1o/CxGX0W
         jSIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWD62zf1laPDpxRkEGEa2LB4DAoUKDw5cdHqT4xbnAos9ExhtdBzG/wWdiscJrsHhfjES45GKcjbQ==@kvack.org
X-Gm-Message-State: AOJu0YxZx97G3MKC945iq3fovCXqxVumtZBCI1k5QEqC3tZ4IWNJt1rD
	qqCcmZgQLEHCJxd6sJUCbQzJvNplWtczZY8XWc0wmIKbNRjCEfP/kwhA06g3K/cJ9gO8KwEpI+S
	3KFFMXnGgIVCdoHbsu1tE0qltKrCYUjzqom8z
X-Gm-Gg: ATEYQzyiWR30iiNtBe4O5e03i3QEjUHeMlrO0j1LLKkK8ywqE3fJffg0sMZec12uI/7
	aRBiTmxAx7pqI2sCnx1LNgj+Aoqo/haw9jVPczF84QHX34Jo8wz7oWimPdYDLU4wHj45EvXVGH2
	H1PrCJ/A72JQgVWkcJWp66vbSMcfpkTlzvLMzjbKjhIrcTQeeeBHXUNIcH/GJC8Fv0rsop46JGa
	GgCDSyph2cfYHuZxcq1Wx7M13Ly9bMH/LGaxQBrarxgFoX8RIWY7nrHkZ3H+Om4lK+A2v5+k09/
	uCBJVwDcLt1HqsHxStGldsUleY8OXf4SMlC9wkRuO9EjtPTm
X-Received: by 2002:a05:6820:2d4a:b0:677:98b4:79ab with SMTP id
 006d021491bc7-67c22f74118mr13202109eaf.33.1774349675421; Tue, 24 Mar 2026
 03:54:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260322164943.37460-1-devnexen@gmail.com> <202603241635.qNXDPwjs-lkp@intel.com>
In-Reply-To: <202603241635.qNXDPwjs-lkp@intel.com>
From: David CARLIER <devnexen@gmail.com>
Date: Tue, 24 Mar 2026 10:54:23 +0000
X-Gm-Features: AaiRm50vrYNk_mlAnRdMfp0nxFOpfo962oTnSfj2Jot4SGUmcie4lybU4o5qGTY
Message-ID: <CA+XhMqzK39zZu7_KG37RJSeiR56fUON2CQsDN_L1W3+BuZzHmA@mail.gmail.com>
Subject: Re: [PATCH] mm/memcontrol: fix obj_cgroup leak in mem_cgroup_css_online()
 error path
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: oe-kbuild@lists.linux.dev, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Qi Zheng <zhengqi.arch@bytedance.com>, lkp@intel.com, 
	oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 9D01F180016
X-Stat-Signature: xoquaa51ork1bfkqmrh1oaabduxmihj7
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774349676-631626
X-HE-Meta: U2FsdGVkX18rmPe+LbFQv5sqpNuPB01B5kZEIXtnP0uU3uySCKZ94qLRpcFvI7rKBZ9GC+bpgbVwVRItsJSD1bf+yddwpS52ooAgFptOYjaWtebhmtNDm9q7phxT6t4GCpT3l+HdRPjZ44KZ/tnIb8/FicANBFybjiuFO0hzq8mQ8LD+M5bwZ3Osz5OBD56EnJTXEAvJuGowfCDsKzWf4gC1hmAzEOqSKDbdkeR1sTh876FBlm1JSdU8eikdR/mZJcFcmqvf/CFbS04tUTezKYlfqAFPJ0LuNVM0J7a3o7yDTN5h/S45GW3GV+QjfXLLoN5K4tPCdf8/z2pJexkjVU7jn22JTzv5jUP5BFPI5FEBWRi4vGp3fRenlh/gbFvIkyRhQaYCzlOQcSTEkebiouutZST1WYCxoTgibB6zRkgQ/EYgbfovS556leZEU4UcGyNm99xYbSrPWyUHh9029QiRVasyqSKiZMxftVoU4Hc782RmkJJeHsKp3kdxdFYMLTN5PFsWo6ZeUGZF+Yghn8MBiVc3OAhhNE515lojUugaxNHQIiqN3TtVJZ9aF0RSjoT8q6otwbWrlT38JQLcNfzuHRfE9pDU+rWZUWtrUY+wbqQTUNTqT0WcMSp30R3s2M/svkhl7/60/rQD7wrFr9KSJHmZ69U2CiWLw69Ekb9P3tnGdRAjKnMZ4KVNKiinZqarl6VraxHQhFpSJ5c/BYV/WBBptZkxy9HjXaM4V7ebum6l0XMslLho2UaS17cR+h3wnPzkX1YcSXd97VP4BpJ6EHe7RnVYhdVPoG6S4VxgixxhxoDSoUsxnjirPJSgr+ufigqMSW+xLPg11anQOo6q756wLRv4nqPOFkfpTJrmP/OL1DR6ae/VcAz6A0ozYcuIA08glM0nBtfqlof3UWhkE0bAeTX4SEHrOkEGq+cMgmbKpG93j3t1Re9W3S/yjj3iJJQu7KN/SNuapv7
 M1L8Jsqz
 T48F77RN6CuBNe33DYOcHffUqtBJrNw3SNZbaKaU25TGROlysy3y0pKFojaQpPLI0oVm/ziuD/3k3C0OcGID7whc1GihVdYUTm6ZUVCYHmkAEzx4/7gAYTNXkljpj+oc+5HGbjY2gn1HieMEyzUxkVpAumJOyrStpA1HMPo7+ohbs4NZ6A+87rC+hBIhxlvFvChx2ox85T5yNogIWo+bvVs+3nRNYD5F5goJAqtFs4Pbv/+el9P4AqMUU6VDKa9V5cyUSYpxrrWElnqq0p2x1Nh+ZoO4w2ok8SrcML5JXkIBFiEZjLqsFspAsyR95bDEUtOv4P07Y6y2jovtedDoxL4erlVS+H3Xvz/kF6RsnBKQvkCe9dQ5SeDivZv5F+xLE2r7Yrn1F1ueimKKHXH+edDfNQZsAeHBbJziZZOTMRgqNZWBdsFOOUnMaJVmL1D+ZPDhYd7b26vBkKTmBcVzZgfMy55M6FjRBOWsskzKddauhtN4tVuy/xgoeYixwwKqm+SnWSYwBYmDWxJoomVxbsZ0Z0bjGbUQCdQhW/56Ff50nArxD55ISmz/+Lu7S8LaKRq8KUuMcySBzRuPZzzBFVmrWWMNxybsJJc7v11u7pWjJFzHpZrUcwswcK64ygXB2D9z+z9cni4aNxPiiciE9R1OvTVcqALRiKPEP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Dan,

On Tue, 24 Mar 2026 at 09:10, Dan Carpenter <dan.carpenter@linaro.org> wrote:
>
> Hi David,
>
> kernel test robot noticed the following build warnings:
>
> url:    https://github.com/intel-lab-lkp/linux/commits/David-Carlier/mm-memcontrol-fix-obj_cgroup-leak-in-mem_cgroup_css_online-error-path/20260324-010357
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/20260322164943.37460-1-devnexen%40gmail.com
> patch subject: [PATCH] mm/memcontrol: fix obj_cgroup leak in mem_cgroup_css_online() error path
> config: arm64-randconfig-r072-20260324 (https://download.01.org/0day-ci/archive/20260324/202603241635.qNXDPwjs-lkp@intel.com/config)
> compiler: aarch64-linux-gcc (GCC) 14.3.0
> smatch: v0.5.0-9004-gb810ac53
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> | Closes: https://lore.kernel.org/r/202603241635.qNXDPwjs-lkp@intel.com/
>
> smatch warnings:
> mm/memcontrol.c:4180 mem_cgroup_css_online() warn: variable dereferenced before check 'pn' (see line 4176)
>
> vim +/pn +4180 mm/memcontrol.c
>
> 6f0df8e16eb543 Johannes Weiner  2023-08-23  4168         * regular ID destruction during offlining.
> 6f0df8e16eb543 Johannes Weiner  2023-08-23  4169         */
> e77786b4682e69 Shakeel Butt     2025-12-25  4170        xa_store(&mem_cgroup_private_ids, memcg->id.id, memcg, GFP_KERNEL);
> 6f0df8e16eb543 Johannes Weiner  2023-08-23  4171
> 2f7dd7a4100ad4 Johannes Weiner  2014-10-02  4172        return 0;
> 098fad3e1621cb Qi Zheng         2026-03-05  4173  free_objcg:
> 098fad3e1621cb Qi Zheng         2026-03-05  4174        for_each_node(nid) {
> 098fad3e1621cb Qi Zheng         2026-03-05  4175                struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
> 59f75a1877fbf7 David Carlier    2026-03-22 @4176                objcg = rcu_replace_pointer(pn->objcg, NULL, true);
>                                                                                             ^^^^^^^^^
> Dereference
>
> 59f75a1877fbf7 David Carlier    2026-03-22  4177                if (objcg)
> 59f75a1877fbf7 David Carlier    2026-03-22  4178                        percpu_ref_kill(&objcg->refcnt);
> 098fad3e1621cb Qi Zheng         2026-03-05  4179
> 4a2f95f5c79e02 Qi Zheng         2026-03-09 @4180                if (pn && pn->orig_objcg) {
>                                                                     ^^
> Checked too late.
>
> 098fad3e1621cb Qi Zheng         2026-03-05  4181                        obj_cgroup_put(pn->orig_objcg);
> 4a2f95f5c79e02 Qi Zheng         2026-03-09  4182                        /*
> 02b5fc7885d9f8 Andrew Morton    2026-03-09  4183                         * Reset pn->orig_objcg to NULL to prevent
> 02b5fc7885d9f8 Andrew Morton    2026-03-09  4184                         * obj_cgroup_put() from being called again in
> 02b5fc7885d9f8 Andrew Morton    2026-03-09  4185                         * __mem_cgroup_free().
> 4a2f95f5c79e02 Qi Zheng         2026-03-09  4186                         */
> 4a2f95f5c79e02 Qi Zheng         2026-03-09  4187                        pn->orig_objcg = NULL;
> 4a2f95f5c79e02 Qi Zheng         2026-03-09  4188                }
> 098fad3e1621cb Qi Zheng         2026-03-05  4189        }
> a0dd8b1942f5bf Muchun Song      2026-03-05  4190        free_shrinker_info(memcg);
> da0efe30944476 Muchun Song      2022-03-22  4191  offline_kmem:
> da0efe30944476 Muchun Song      2022-03-22  4192        memcg_offline_kmem(memcg);
> e77786b4682e69 Shakeel Butt     2025-12-25  4193        mem_cgroup_private_id_remove(memcg);
> da0efe30944476 Muchun Song      2022-03-22  4194        return -ENOMEM;
> 8cdea7c0545426 Balbir Singh     2008-02-07  4195  }
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
>

Seems Smatch is flagging the inconsistency, but pn cannot be NULL at
the free_objcg label because all nodeinfo[] entries were fully
allocated in
  mem_cgroup_alloc() before css_online() runs. The old pn && check was
unnecessary defensive code.
Kind regards.

