Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E35B9C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:11:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 137AF6B0088; Thu, 27 Aug 2026 05:11:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10EED6B0092; Thu, 27 Aug 2026 05:11:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 024F66B0095; Thu, 27 Aug 2026 05:11:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D6FC06B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:11:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5F9F0C036F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:11:02 +0000 (UTC)
X-FDA: 85146479964.21.0EC3EA5
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6DAE5C0008
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:11:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="T+SJS/i2";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787821860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tu2ly/KH2dLnBZR31VNk1zmOFGKKWjw22JUwhd3exbg=;
	b=Ag3Xbf58cijgjX1KBgjv9NTaFP8v4mUosiML39nxY1ctBbvYf8nTsqri7Ovoqn8bgfdsZt
	p1l3s03f8NARwMXY8YBK3K/3pJa9yUqubr0IYfJIfmqJX6I4/yj8sFFM2gWsmWJ4wbCVXM
	tM0MrOjLF3VsvrA+z+JhPxlq7EH+SE8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787821860;
	b=SssCltWUgIWhhJx6cDcaTJ+gLPxxT1d30RE1O0IIH0hE9WB6E6up7BAAevlDp4r8LDGuxT
	SADNIWaC9g8uIyg/2Q0NR1fVHuKj/Md88hnnmgBroCYd9uMiOOlJ1XlEBzhi+gadE7sH6U
	s0mT/n2Hhygdy+W0kfPZyvsFDEfuZLY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="T+SJS/i2";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-85590c5aeabso163241b3a.3
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 02:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787821859; x=1788426659; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tu2ly/KH2dLnBZR31VNk1zmOFGKKWjw22JUwhd3exbg=;
        b=T+SJS/i23YQv+TU4K/gYOr8aicqqxz2bQctLjhYvr6yGyOQu4JJN77HOWKuf5VZmfK
         XG7JDvyvEXZefsuRcHaVJbYh9afn9pYA70DB/5i3sgmzOSYbe8rqaq4Etrn10OIQ9dQv
         Wp4CRZ3M0hxQSuVaSflSxTqjd34fi2SGt12YiOPr0zd2KKHfRBnpUVXba4JiD0nV0OCY
         s1smh94fsHiadeUPbhNJwmXOmD6eyC5fB2uzibwMXj5cOCPQ9cqgkF4ZTu6I3b29ooAF
         +PGOO7/xh7fY1cFy2d20OazZoJHuMjWpAk1e1DK8W05bqoExL3d2VIqXjK+9dUQY/ZsK
         8lOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787821859; x=1788426659;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=tu2ly/KH2dLnBZR31VNk1zmOFGKKWjw22JUwhd3exbg=;
        b=iqadbuTPsqDzkUN5kPir0ylpW2eStXIXhKSmK43VNg+UqmVMUODRcpjB2GU3LqSZie
         ijtzCeb868canslFboaYB3SPeBNpOO8l4w791/W8MBbrRC9S0+anXoBlpa7OfHC+5vUE
         z13o77of3VrG+NJBt0cNzoxZ6P/c40y1tmsp15VLdMooj+UujhqQpnCP9eqyT5JSM8gq
         BLoqlcecTuByDLOxDMVGY4YWW1gkAXEwP/KKQ1bYYv8PjQTppTFCokjqNqwqYb5Iov78
         0NzM8O4je2NFLejybc9ZMo4yOk2a7C1Z3UXMbTKhZ11QgcHW0wWxPjsc3HVo0olQpm0K
         S1iQ==
X-Forwarded-Encrypted: i=1; AHgh+RqQNEhmEoFwQ8kvTDDYIULDYuoo2S2n/7bZGsAf3YG3b9rQYuaUAr8s/hV36khyLNeyV621/f++Kg==@kvack.org
X-Gm-Message-State: AFuF++lAFQ1/QiObRHyBD7IcAR+ZtaMtbZibsNmRMNlkzBHtARytSBuj
	qw7X4dOi6xcjn8+PDPB1uEyq4m7TCA2/bfDpV+uXFIIsgIdgRZbURjJD
X-Gm-Gg: AR+sD10VOuLVkXRcPbG0KVuGW2wRe6CWBnpFZq/rOK6KHvwzf5zYSPovjGpT5YOhX24
	d/PHYzi4o7GbDNwSDhq12Nx707eQTPxL9aYNvIlN6/ZHoZzA0+qamtnBPSYm8psYP7OIDEcA1ia
	/J2Di94+h3iRWrkJDN1SbZsjV4mGVay5Lyke0+aKxDuAGKNZ8yHKkwUDM4YYABFg8MWxh/o9jXC
	36pTcbF4OBWIIezK/gAnT6HZkY0PZImY7RnJbYCEwtsaT3yzSXAnGtFIu+FdsJIzypRJX5u8xMu
	KobK0IlC3nw61RIBd2igzu2fWEO3bBjAvly6o3+cDJcMzgDl0xGiwpJfH1IPffSzO7HNN8MW+sM
	DojF++s8Jip92+DUP23F8pFCfgXTeL1YeSlFYaQWyIHo9IsqMx4ay1M+74CYmf9RZybXsn7vVwN
	22sE4WZTq3WFkXCpg9LxcqJJCTY6ACDFJMJAgmBDaUmo2PQtyaakkUmemvkWe3Zted/ucE5yoeS
	z1Hd2/dH7EsOk/aH75AlSIyCaiTfTf0phA=
X-Received: by 2002:a05:6a00:2914:b0:84e:f90e:492f with SMTP id d2e1a72fcca58-853729a9f0fmr26681240b3a.7.1787821859257;
        Thu, 27 Aug 2026 02:10:59 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8535a7c2570sm1860103b3a.17.2026.08.27.02.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 02:10:58 -0700 (PDT)
Date: Thu, 27 Aug 2026 17:10:54 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mm, swap: Fix potential NULL dereference when
 trying a sleep table allocation
Message-ID: <ao_ybL9yRO_pHphW@KASONG-MC4>
References: <20260820115505.20027-1-shikemeng@huaweicloud.com>
 <20260820115505.20027-2-shikemeng@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260820115505.20027-2-shikemeng@huaweicloud.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6DAE5C0008
X-Stat-Signature: xb9gqr4u4cgc4z7rbx9tcaufargoxrn9
X-Rspam-User: 
X-HE-Tag: 1787821860-497068
X-HE-Meta: U2FsdGVkX18oW5m3cmZCPsKMtXtLdVRco1XpiF5VOAsNJueRXidLrhqFiAixtVQGWe3R0EfEm5n0jZswHgzjfVSXQX6pfp3CU0qDMvYfWKgt/x7r9d6zRv5e708dIEvD5T+5owh+PNAqy7y5roIjOj8Jx0w11ABEsFJ3htFuJzoYyzgAvu1nY1Cypb698wKGDvqXRhmAIvRGHUmW/6jY+dAPyGH0EVRyImN7oocB7iiIiRcA2OU4SZa21JGgjHQZTdZJlFWBzTCpCoJkiMjzDlo7WqNxp//LyEZAMqj/a/edAmIsNuji8e1fz0Qq4Ax6Ewqz4t+EKJOMt9tw7Uwf/ZEaYYdOK4CURMWPJUCHI33FMeVo1COGCAQFCW29c5OyI6kHQZbAe9hVu34mhg/M4bTcYQnjiB4p0Sx0Mmn/O52bbCVCFx8w00dRP2++f/N0WRzTjXq+G1ZV2vZ175aR4opoaT29hosVyKxatp+2oLmvYRn94xEVzM6E9ezE9qyB5qUram5exbguw805zodt28AElqAVCr3Lw/iPJY3CeHme78Cygm7DPP8F4CU1OJO7lBVWCS/KJ+Vfjy9+S0MvRrKNFIMCPOILTjR9KlkK3H4hBvAl5XTR1WlVFS+ggpLqs0yAB0/RpGKNsuta+0GhNYOpWSwsyW3A47Pph8+AdYYcPNg1jFJfOWRRhkGgOFlrrii5EhSfgrPINxjAhSdvSvRwBsQTuAa+KHQ8Sbg4FkRj6uODPwSgJliNL+R3LKixuMgoX1KaSekLzeoAxNr0KHGGRZnjO6oM2/1VBmm3VKkd4pv167N9d2+4ubZ4gpERwAVeOrsCIMBshpBIyAYSrxj6NFOmFp3jf3vjU42czEfrP1TWkAR3tp6URhvsAbQj/CnMKX728BRHLrWSjN3fVM1RDdPVFpt8kd+K91IUNAyQTsTys7GLFmx9dbORl1l2DcWOHaPUFn97HG6FG/y
 1agRf3U8
 j+wNEbhEJDcHZp/BISQffENAx88wF5NFS3kTbSBnrDvcgt9czTShLe0GR7bl4LN4SX0n3RilixyJ2/M8B6OwjmGImslMwbirmAQL0m4NVuc6us/SVZTK345NIcxytSjpmMfYJVM1knUl5rVv5ndLrmQSUFqPpb1l1pxVZbLmrtbZrc20G26XPDFUFYlBibpDg4CVmDwKitf08meg0GhGFMLBx1dp6UBMRFNZD+0lf96w++n+yc7h9BXCkTjvRKrPTvUW3Y+jDeP68mndQMAP4di65ZAvGf3C2sYGfHY6tbWlhKve1EV8V9+Y7XDYDx3uhEprTdwpMrRcDorIOkKp0KBf1FVqJHGHPoWF1S1x5T2hVonDC8rLSo8Vx4u4gIgM52MHlLRptr3taR32x0T1L8Ywujknt3QaHvti11eiTcdnQ6vRnOUFN6R7ne8IuJP8mC0lbud3iSgDPb+aXwU35+cSyohYN6a+6FqkHi73UfDDfspgJmR9Fjq0QqWaEDI9w+DLiIwwfa0oMc07evu0JwiVfExFF5uD0uuyo4MdmILEDsPi/m8EWrpftjK/RdXBMRd3t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 07:55:02PM +0800, Kemeng Shi wrote:
> The root cause of this issue is because multi-tables are updated in non
> atomic context. To be more specific, the issue could be triggerred as
> following:
> 
> swap_alloc_fast         swap_cluster_populate()
>                          /* Try a sleep allocation */
>                          spin_unlock(&ci->lock);
>                          swap_cluster_alloc_table()
>                           rcu_assign_pointer(ci->table, table);
> 
>  ci = swap_cluster_lock(si, offset)
>  cluster_is_usable(ci, order）
>   if (!cluster_table_is_alloced(ci)) // ok
>  alloc_swap_scan_cluster()
>   cluster_scan_range()
>    __swap_table_get()
> 
>                           /* free table when more table allocation fails */
>                           ci->memcg_table = kzalloc_obj(*ci->memcg_table,
>                                                         gfp);
>                           if (!ci->memcg_table)
>                            swap_cluster_free_table()
>                             rcu_assign_pointer(ci->table, NULL);
> 
>     table = rcu_dereference_check(ci->table, lockdep_is_held(&ci->lock));
>      atomic_long_read(&table[off]); // NULL dereference
> 
> Fix the issue by making tables visible at end of swap_cluster_populate().

I think you mean "end of swap_cluster_alloc_table".

> 
> Fixes: 2fe7a6f5024b8 ("mm/memcg, swap: store cgroup id in cluster table directly")

Hmm, wrong commit id again, should be

Fixes: b197d41462c2 ("mm/memcg, swap: store cgroup id in cluster table directly")

> Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
> ---
>  mm/swapfile.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 615d90867111..4561c864f806 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -466,8 +466,6 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
>  	if (!table)
>  		return -ENOMEM;
>  
> -	rcu_assign_pointer(ci->table, table);
> -
>  #ifdef CONFIG_MEMCG
>  	if (!mem_cgroup_disabled()) {
>  		VM_WARN_ON_ONCE(ci->memcg_table);
> @@ -487,6 +485,12 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
>  		return -ENOMEM;
>  	}
>  #endif
> +
> +	/*
> +	 * Make tables visible to cluster_is_usable() after everything is
> +	 * ready.
> +	 */
> +	rcu_assign_pointer(ci->table, table);

Hmm, but for the error paths above, they will leak the new allocated table?

