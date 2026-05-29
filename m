Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6C90CD5BD1
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 02:19:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF0F56B0005; Thu, 28 May 2026 22:19:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA2476B0088; Thu, 28 May 2026 22:19:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB7536B008A; Thu, 28 May 2026 22:19:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CB09B6B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 22:19:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 56B51C21F9
	for <linux-mm@kvack.org>; Fri, 29 May 2026 02:19:16 +0000 (UTC)
X-FDA: 84818850312.11.122A0F5
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7FF4080002
	for <linux-mm@kvack.org>; Fri, 29 May 2026 02:19:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hBhDQjMv;
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780021154; a=rsa-sha256;
	cv=none;
	b=hMOr7lldv9GXudbmHksHvutkIBhZwjVCXOkt8zlCpjqEms3c1CGcoZXirFWdZ106sKwEqd
	XNnnqToadqwlyGss0iKewFnM0rJSn71myaShGQrFwgEJ2kK9KQ8L8UrapOPmLlMVWe7O4C
	xG+74fu/+d9PRsoGzi/6KL6ptiSH3uc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hBhDQjMv;
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780021154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pzBFPmaqR8/S+R6Sx9iC337HkM9qwhh6v83m9u0ywYI=;
	b=3S+PS+N/pCDc5Na/8WFTI6ohTYnVnsJVblkte7ZptzDsc7m32OMY6Jq6yVvQUhwsExmOvc
	KCYpC/XxRSjqplH9TaOmTorKytEKguhA+wwPw38vI99So8T5BEBG/aVpFV6HFdmFhJ2Hed
	p3IiOdit/q9lyNnklOSa5e0avQ8U/QQ=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c801b30188dso5881945a12.3
        for <linux-mm@kvack.org>; Thu, 28 May 2026 19:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780021153; x=1780625953; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pzBFPmaqR8/S+R6Sx9iC337HkM9qwhh6v83m9u0ywYI=;
        b=hBhDQjMv/wjZOamp6dtQGtDZpCL94bwqyjQfNxUPwypWtMxHnPmIblYmiwZTCjTjIN
         3LCFnpeXWwTwGLrQHWSLr2w/8ku48mSr89s33hCZuCfEOi7iThCve/Aj6ODwvi78IObb
         sPkknzEjnk2N8ubVRnILsJANaXaAIf3qb9oCa5TwEi4DQmf51ecNQrccZ5Uyu65sRQ1m
         phbDcaykUq0qqGwcfAF3ffue0/eUFbQPX/zE4GuUNjdE4U6WI0OA5gQppWuGWkEu7KVE
         L0JpIjDy2bLDDN17lwtoexcs7UJs557Ei62jH5CMhxC6fyVns3e/wkVMzc7Oypuhg06U
         06ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780021153; x=1780625953;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pzBFPmaqR8/S+R6Sx9iC337HkM9qwhh6v83m9u0ywYI=;
        b=QNsRACh8O+ukcekQl0inVwhaomuYCC6F1BuVpMn2HadzgnSBD/0bu9D9ESRfKZ/GXn
         JrTLSbouuULTvnzPZV7iWsxFHuYT3MQsUNQa6BunDa8JZ4/nfL5G3f8gR04dRwUvMLpn
         hixVp9XUtnwbwoZHW6eXs7e7Z5HIHk2r925S1iiSkMxwSfs/q4egtNHyuw+k0pNtSdWA
         nX7YpF8ekuEBatvcEgXbalSOxL4LzC6cjeR0XmSfaw+qB7jEFgzULYl7km20GUD+os9F
         8Cng+NsuSlLEOLX6UpBWu+H9xhP/sZwkmdoKz5Ej5PI7LBWJE2mptwBSPSCKcdPB25tI
         Tm2A==
X-Forwarded-Encrypted: i=1; AFNElJ9N2nyl5uHdIu1zsuvSWDNqzulwtddc4dfth+uHEGsoviKm+SlORjn06dB0KTQYT9dSJVJ0QdCesg==@kvack.org
X-Gm-Message-State: AOJu0YyGrKFWxXFW1AwZ+/xNp6EPOCaZ2jCLKtNnQ9r3grMT/HjJw9+Y
	cDo4AltVKV1pxWwky1IsoYg6EUzgbRpxpW3OshENBnx28eroP5n0NpoghtW2hh7Z4rJwog==
X-Gm-Gg: Acq92OE4HRZUw+azrglf8rDOEysQ1uKrp45CEkemS5W/0GSyx5eQ4pOlsWnMTWGgr3/
	/MEwVXp3ILk/piADmCEWDgdg1c6F0kav4ySDgIjV64Yb2wCZGokCJjqP+bznZa8YIwiM3r/7iXj
	V34h7TV1EdpyflFKI4cbfW8wqVhxStZhgHLi9DDwHfTbc5zKLYZ1dJ8gW+OnRJSv7FQS4FdWN3n
	9vn8EQ+hltAd4KdHU/w179FxAbcrrti6HmX7RZVjTfOBCpXtPxS9nY0QMUjHS/BvKcDUS0r0YFF
	MbI7karD9ZoVajK+NNqbfhCcRIPg6FupFHOB4Uh8LWjl5rGfEAvAzjVyCTxYApskYJpu9yG83kj
	D6XRaLfVxBs4BGcCx+/AIwaTQcA66n2tQulT4GMrJFfT2dw598wfviO3HHka87Oxd8gbn0uHvw1
	SxUG+2H8NO5MB3m2VEKvvb+gOKr8Tm5iGCwnXL6dKVJar9546o+AVq3UAm0oPtZnA7oEW2hpr+A
	PPawGA=
X-Received: by 2002:a05:6a21:6f07:b0:3a0:c2b4:d976 with SMTP id adf61e73a8af0-3b412384a64mr799579637.44.1780021153265;
        Thu, 28 May 2026 19:19:13 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.20])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c85772ba4adsm147136a12.23.2026.05.28.19.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 19:19:12 -0700 (PDT)
Date: Fri, 29 May 2026 10:19:07 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, Kairui Song <kasong@tencent.com>, 
	llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	David Hildenbrand <david@kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, 
	mm-commits@vger.kernel.org, Michal Hocko <mhocko@suse.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <songmuchun@bytedance.com>
Subject: Re: [akpm-mm:mm-unstable 199/420] mm/memcontrol-v1.c:651:24: error:
 call to undeclared function 'swp_cluster_offset'; ISO C99 and later do not
 support implicit function declarations
Message-ID: <ahj2pRAit5WPzyQ2@KASONG-MC4>
References: <202605281711.bSeZlErK-lkp@intel.com>
 <20260528144502.dd586e865b677051ac7c776b@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528144502.dd586e865b677051ac7c776b@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 7FF4080002
X-Rspamd-Server: rspam03
X-Stat-Signature: ubccsjjuk68dcf9k5r7san9tn67eugen
X-HE-Tag: 1780021154-479107
X-HE-Meta: U2FsdGVkX1/Uo2/u7fEW6Cfpi2Kpb0AI7rhpMvh6FX5SRtcz3Li0KH95qyBcdXYFi9ky7i72SRNnvDsPY+CBePO13EUztemToCGCkw88LHV09zDylWNtI+S5wi7gOZFfYmDIOuKu70H39REnoQK20yXLdpLZdrp0j+jqBbbIkwGH8w0OWhHDuQMO+6cWy5c6Q2vjWWV4qnautRFhYhCJMx+Qe33f+UgMTTanQFnKoVejINwVz3NV4VqRUJUTKCmctI+nmwpLvDGUkDNom3ua7gsBn0RnKCyuWPrxZN9d1cXfo5NxstmPO5Wu0Uu9Yz9onvjZrQueYTUv8brV9vg2pCnQucQ3UuJqta0hm6VOZW7014184yo4Qc2bZWpD3VrwIdDWk/+TpI0SEPoWWL5EAVHV7VPalYvA3q6L0TgYE7fyC2PfwxHQ/Vr0IGulG0Ml3QlXNTYOVr1J8M7NhgYL/1JoZ8Bb8Ci0Yugj7zJe2fXf5dK2/6rGG7DrH0f+zVOxAJeU39eTNoZaQFshg8SY42t9v/t1Xemc+S26TUho5IIUJJLJTJWY0bJFQtnpfK78ttCYhKSHyaoAaru94iE+9zpyWS2VyGSAQbfac2lqrfXpVCuo4IiVWl80qAKrm5cKVLIs+OUURw/jtY2L/JQdi8KCJvpPKap3P75MyGChtn5hTyydjXa1WUt95nq1XdmavGGNOjBLMe6v35cD/y5AR/Ci/9//wy+cvzgDwkbh17rNLx+mesrwxtvnrnkqtYhlds0Yaj+4/qp0VNj+xOqlFAgHAlXwJipEA5qzBemZacdzvr25rSCdt5B7CnUWy2WRuZFvnL0ELEE8Wfw5ip8DLhAXHeD/mpUmDVVhexPQIR/3UgFR9enrDuGjfRKVj1G/dJLzhp0sZUSVwEbXQz4EQ6rdOKwOiMIMZ4FVXfkEj09diou91PsQs/H+lmdjh8Dlot1vAMXiKGtDSMryqUS
 m9RWK0TM
 1yXND+4cHILl2Njfc8FxQAVxTMwD+TlY1j5JhRUB0PHJN8vTJlODj7zm5whpMVsGZgm86OzjhadrDe9MwlOCBVzUWwnoGkQuOoA+g6ShFLOAkynP4m4P8hN7gl9xUM68jshp8zjLq+8Ms9YaVMiDqjuYOQ0/FCi2P0voKwyUK20NK/xzEyvRTpy5Zp/YmNE6aZE2D8QrWjZ55tikSEllBV26D+lmWrcpuSV+NARnnrW3A3ijYVaNcl7Fd7rMtJUPy8j0tYG1FJDokr8sSgwoTAzPg0ZVUuHNkim0yFumK8t7Cb6GGT0+WqH02xoT+lTZh0TR93PBUpQj3/NCum1R3bi8xXPGNl9GBgFQ3WpbgMFy7clSJ9A9q56UGYyNckbcF1zut4Id+ZwWz0e0j/m2r9P2uOY4W9jsamlvizn15t9DX1H98Ex4swJvaRe6IMskxeXKgeaUtzWOxf64qQfGBXh9gNL6Gz4J3ptZ4ZXv7llEMCJgEoVf01eGjYOokzWiqBHfHkvVgcaEoPOz0fkGhLXDmzDiT9Iht0vVGFT386TkE1QuT+0KDqTvYXs96gNUkNgzZ108z2H8N8xbMluyhoE+pqfjAFrhxRao1LVCA1MONCh5xxRTcYRu/PhChbmRdpXhksd53RDVUn+VWCp6cky/c9jiGZ8jsDxt+bSl86DGmCmQiBdQkSVKSK0WeIDiH3WmgXYA3aXzmdym9u/Wu8vPbko+0E1xU942EDoYgK6JS/pziTT8LArb3pZE8w+vGNdF+/9mQfXnRMFEbnk9GlAaBcg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 02:45:02PM +0800, Andrew Morton wrote:
> On Thu, 28 May 2026 17:58:34 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> > head:   8a74e22643189e0ae339afc91110ddb4cab1941b
> > commit: 93680c2b51fa1f84fe50800b71140dbd283372b8 [199/420] mm/memcg, swap: store cgroup id in cluster table directly
> > config: arm-randconfig-004-20260528 (https://download.01.org/0day-ci/archive/20260528/202605281711.bSeZlErK-lkp@intel.com/config)
> > compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 9409c07de6378507397ecdb6f05f628f58110112)
> > rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260528/202605281711.bSeZlErK-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202605281711.bSeZlErK-lkp@intel.com/
> > 
> > All errors (new ones prefixed by >>):
> > 
> > >> mm/memcontrol-v1.c:651:24: error: call to undeclared function 'swp_cluster_offset'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
> >      651 |         __swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries,
> >          |                               ^
> >    mm/memcontrol-v1.c:721:31: error: call to undeclared function 'swp_cluster_offset'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
> >      721 |         id = __swap_cgroup_clear(ci, swp_cluster_offset(folio->swap),
> >          |                                      ^
> >    2 errors generated.
> 
> OK, CONFIG_SWAP=n.

I though we have already fixed this, and this is trigger by the bot
just because its not a squashed commit, so building while iterating
the commit will still fail? Or maybe I have some misunderstanding
here..

https://lore.kernel.org/linux-mm/20260519152620.b7b5fd2d68d635ec8d34ad2c@linux-foundation.org/

> 
> We could hack in a stub for swp_cluster_offset(), but why are we
> compiling __memcg1_swapout() at all when CONFIG_SWAP=n?  Ditto
> memcg1_swapin().
> 
> How does the below look?
> 
> Really this should be done as a preparatory thing, but we'll survive.
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: memcgv1: don't compile swap functions when CONFIG_SWAP=n
> Date: Thu May 28 02:35:22 PM PDT 2026
> 
> Stub these out to save some dead code and to fix a build error with the
> upcoming "mm/memcg, swap: store cgroup id in cluster table directly".
> 
> Link: https://lore.kernel.org/202605281711.bSeZlErK-lkp@intel.com
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Kairui Song <kasong@tencent.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  include/linux/memcontrol.h |   15 ++++++++++-----
>  mm/memcontrol-v1.c         |    2 ++
>  2 files changed, 12 insertions(+), 5 deletions(-)
> 
> --- a/include/linux/memcontrol.h~mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix
> +++ a/include/linux/memcontrol.h
> @@ -1900,9 +1900,6 @@ static inline void mem_cgroup_exit_user_
>  	current->in_user_fault = 0;
>  }
>  
> -void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci);
> -void memcg1_swapin(struct folio *folio);
> -
>  #else /* CONFIG_MEMCG_V1 */
>  static inline
>  unsigned long memcg1_soft_limit_reclaim(pg_data_t *pgdat, int order,
> @@ -1930,6 +1927,15 @@ static inline void mem_cgroup_exit_user_
>  {
>  }
>  
> +#endif /* CONFIG_MEMCG_V1 */
> +
> +#if defined(CONFIG_MEMCG_V1) && defined(CONFIG_SWAP)
> +
> +void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci);
> +void memcg1_swapin(struct folio *folio);
> +
> +#else
> +
>  static inline void __memcg1_swapout(struct folio *folio,
>  		struct swap_cluster_info *ci)
>  {
> @@ -1938,7 +1944,6 @@ static inline void __memcg1_swapout(stru
>  static inline void memcg1_swapin(struct folio *folio)
>  {
>  }
> -
> -#endif /* CONFIG_MEMCG_V1 */
> +#endif
>  
>  #endif /* _LINUX_MEMCONTROL_H */
> --- a/mm/memcontrol-v1.c~mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix
> +++ a/mm/memcontrol-v1.c
> @@ -604,6 +604,7 @@ void memcg1_commit_charge(struct folio *
>  	local_irq_restore(flags);
>  }
>  
> +#ifdef CONFIG_SWAP
>  /**
>   * __memcg1_swapout - transfer a memsw charge to swap
>   * @folio: folio whose memsw charge to transfer
> @@ -723,6 +724,7 @@ void memcg1_swapin(struct folio *folio)
>  	swap_cluster_unlock(ci);
>  	mem_cgroup_uncharge_swap(id, nr_pages);
>  }
> +#endif
>  
>  void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
>  			   unsigned long nr_memory, int nid)
> _
> 

Thanks again, looks good to me, the simple is simple and it looks the
same thing I posted previously:
https://lore.kernel.org/linux-mm/ag0mdxBWcrZ8hxPP@KASONG-MC4/

