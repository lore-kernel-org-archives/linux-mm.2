Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF30FE7E0C2
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 10:41:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCD166B0005; Mon,  9 Feb 2026 05:41:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C84F86B0088; Mon,  9 Feb 2026 05:41:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4E3B6B0089; Mon,  9 Feb 2026 05:41:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A04F86B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 05:41:26 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4AA9B1A075E
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:41:26 +0000 (UTC)
X-FDA: 84424576572.11.FF27667
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4B144C0002
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:41:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K0Asb6To;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.180 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770633684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1vceECY6oOVlxttD05QrM0v69VFRLzzkozbTpsthX2I=;
	b=MgHKwwtwc3etwfHribcFng5hsM395rlLtVO5I6FyDngQEo+icI/3owkj/D2xMcxK+73vpw
	kHDHD8v1TQzpxP7exnxSuULQSYGarsikf8s83NBHg6dVuaq/lKU8IDL8ROlTZUnVtHmQ2D
	mxHif6VFiQEAZN5Db9zmuC3UacxeqS0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770633684; a=rsa-sha256;
	cv=none;
	b=Dfisz26D9pnTmiaZfmolNiZYyuH/zzY5F9cfSvwwm0osGrf6RAGHz9ih8J2nj+zVzRT+QN
	Vj5NsoYVM+VMVES3A/yPCZj7YY3kgNTdcdmjllV5TJHCYVAjdlIgmIKnIGUc2UyaRDS+No
	E5iHtbcrJJ5PQ5nz/8IgbfgJmfXo73M=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K0Asb6To;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.180 as permitted sender) smtp.mailfrom=urezki@gmail.com
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-385c2f88618so36397601fa.2
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 02:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770633682; x=1771238482; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1vceECY6oOVlxttD05QrM0v69VFRLzzkozbTpsthX2I=;
        b=K0Asb6TohOU6e+99EWi/SGSXFxfc09PK4KM3kxDt2n/ikEhiAmlbaGIVbJLFhWg+3d
         QkQdNeBQaXF7XJuRevhtrdfM+7OzPkaP1cfsJ6nFm3kRCZE5Rqa834yuyINVTw9EhbSQ
         HNw0wK2NsvbcAVwZ5WJtXINUsdDPounvZmFe8ynifU/6auIjqHIVXAWKIId4L03zZ8C/
         NsOOhT9KjPI3o38//Qi4jlkkvyaxzn1imdsF00l6bshIxc2SsTFxzfiE8uS1QPe7KpdG
         M8l6CsSPylBO6j5VrWLvQ3wSWZKReKdB2qEMIM/g9mynmiIAjo9lY7zRi8vpTgbBQmJz
         7/Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770633682; x=1771238482;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1vceECY6oOVlxttD05QrM0v69VFRLzzkozbTpsthX2I=;
        b=GZaTmo+r2N1smPxP1TeP+H3rSvdfCtMy95FNHj+wzHS2rghVm0sBLCActJQKRNRzDl
         sERADYZsrqoHNHH9YGtvKXQeUFgjCCv1QoHbUCUY2G2X2r0jaaqaX/qYq7x0SmXEisDt
         9bbL48FlGP+zOWIjO7gfzq1HD7oEVtwDDuvzT3uzjMhowOZAOHfPmdOrWxPtSZEQK18V
         dGgr2J56C6t4NtiorkEL28H1hk6jeCwwFDBzPVY4j1/onC/xdfl41pdJ1HtlkABaH9VR
         rD51OgqFueE62WMm8tSGCU+QnBpRb9KDIbIHmuwXM/iMG1p81Ey1VkHcvVWZaHAwqcfq
         yakg==
X-Forwarded-Encrypted: i=1; AJvYcCVpYoKIdKr+Bf12FAH1ZcCK89LKI0DIyFsvqaLsfWa8KRYxWR2G+EE1graq8fhkEu6NyqG+3k48WA==@kvack.org
X-Gm-Message-State: AOJu0Yznzd0volEhftnb3lRQXQIILzX70GS/bgAUmiuaK97vgOG9KtCd
	hDmrEaespwSL8KhAJDoiN1rATHMXhELqnDwZjFlnosIKTFqXY8FsSJWy
X-Gm-Gg: AZuq6aIfJ9HIR7biDMBFrbiFMDNfRBdxOZBLPmCKlLUfzaZzV+znzw3jMBfLcMnA96W
	oe1ezrU+dWKLzEtGrfD0CUYDV3fJpeIP9WtDAB3nN2bFKq/xp+8FEqhJJCdBHXYaGqYkwy5C9j7
	ZAamTcCfjvWnHdH+deytJrg4d14nBX9JuWNlurYxmKixKw2D7dwSDg6UFKEQT1O5YZDyYup6loa
	JtVEImx3QQ6rmzHmA2QIyYY5QGE11kpoZsZPFocB/cf30iifLz3AjTLYZ2SzGAZOXdBsT3t9Qqg
	2/MWWegPUv+xqv2ggXqkzPpEz4KffZvlIqDjeSPKjeBAAwS/XRMJzWSCvD6I6CvGo8JUXak7jGS
	5az17gvMgY4Pa+sWA4R0Wzh3ijCz9XPffMj9VHdkGjG6zGZd/2JVKL1F7Zx5LOeVp7EtD11nW35
	j6OazQGRfPw8dpYdSm/JKc+EKq32jA2oRt4+24e6/r
X-Received: by 2002:a2e:a5c2:0:b0:382:56ff:5207 with SMTP id 38308e7fff4ca-386b515ab20mr35812111fa.36.1770633681964;
        Mon, 09 Feb 2026 02:41:21 -0800 (PST)
Received: from pc636 (host-90-233-206-112.mobileonline.telia.com. [90.233.206.112])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-386b6281ee1sm26940621fa.20.2026.02.09.02.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 02:41:21 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 9 Feb 2026 11:41:17 +0100
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>, Hao Li <hao.li@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Puranjay Mohan <puranjay@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Amery Hung <ameryhung@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>, Dave Chinner <david@fromorbit.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>, rcu@vger.kernel.org,
	linux-mm@kvack.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 2/7] mm: use rcu_ptr instead of rcu_head
Message-ID: <aYm5zZLvkZpCYw2s@pc636>
References: <20260206093410.160622-1-harry.yoo@oracle.com>
 <20260206093410.160622-3-harry.yoo@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206093410.160622-3-harry.yoo@oracle.com>
X-Rspamd-Queue-Id: 4B144C0002
X-Stat-Signature: ntkeqwes9kxtszpfqten8qyygiegt95h
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770633684-486315
X-HE-Meta: U2FsdGVkX18NjzUIEp82cHhUcVjBcUfPxHMXWMTbYOY2CSO+Ve2u2QHImg7w23Pt8N8Y4LZUWvNrShcvdUe0b18cpJhm9M8EpKj+mJhZIltQjbGkE+R7z7mUqqG4PJhEOjRcdq6Kqxe9g6UUxILAC5Oc6Rpltj0jC1PlgrXc2dyQI+bBI/J3V20m2YlLyDfs9yMuNBc0nisJDs8VvaDrTqLZv/Ae0HfCQmbVmotg2EA6Z+qK/ib0b6/th/XVPc9FAJynekNmV/pf+KtnligpU4fcH/lsI2U4myyeJXd42ubdizSeb06HadAqRDxHEFqPqfJTpot2NCGYsA576lG3o7b3aA3ZhYGdySaAesX2U39P/6uQNKA8CjLx7kC5wRpHFMOWqjc/ydu3MUU1SSszcQMgedP9ljG/LD/5+Jfb18y4QywYVLZWrmqnLexGGP2kgmSnlJzOVPHftl38iUlTlzPFPziaTtftKg5DGdehCnaH+p49yB5zFN6RE303eRSFZ/erRiOhX85MdRVU1e+sdBLA+cbdMU1pDLlj9wo0jdH5+NcPXLzIrJ/R5cvEUFfj1srBc3r4K9IRQmbJwjqWt5KHVBsblj536m5jNPcGzr0eyHEUksUYE4EOdzWXQaMP+TMIjuWazt7HXRs3Wr1MvSocmKsDD7MjJEHaiDZR3f/7eDAnIzXnuD4WjQL28KJXwdwkVSUaZnmPT9dDUktXX5B244sKYvO/5ugXYa7P13d1ke8ySS5C355ZL5XKj36F8Ii2hzJh3w5HIVGQOzzAprRhnAWB2E4VOtY64ECKQREnMzXC0/Vrs1APZgetAuz7g/ipcW8V5spRriAXnQFMmJPEXx1OTTexePuhDGlI+G6AJD4rOWBz/S/PL20db/SqecnA4eXoMDTsCWz2yDMq3jKXwAZtUGAMI1ztY7GxfCiL6ULg0PYh0JDtDQlt9wpQ9GuNsoSxpYvjDFzBBpW
 NlhotaDk
 KVFekYINMb2HeSh+PC9Xch24g3WyeqTIP6rZJalAyPMrmgqsxzFHA/SdmQbG5QFbWXXBca8bBmRHXj+cagH1J+3C7PyKzes8tAmhIT4O2TIPE9yi942Bi9RADJe45yjTp0JV9lHHWdboBJKZocuxwxAZD8q7mZn6BE36AMhmprG72wY/MODM0HMtk/dMDgoBFL0TfpS5MXH70h5ZxH5jQdu1v16zDb6zTjkl4yPwwWxdHCAr7JdIgc5+PKy0AWcTeY6xKWcoqxtpbyFAr/TSdIv/kmc709DxgTClmkwCe2zB+4vdYErNVJ2rCNSSLu7Y/bUUjt8Djc3LKuWZMEZM8QLzuWz9juDMCYF3OyZ37pEubDklAqH2mEHBctuQiWH4E5pmOj5z5MysSI9hTvTiQseVSe7h/In5AGqRKVhAy59z0q7zVGI9cPzmYgDutWjOVfgphtmg5Gn57Gctkow61ikAWAClCm+noyHjGT8VFvtFAkLxabdUdCGXVfTVBI70+ujSvKLmdzmkZb/KRnufRaT4cdd2wf8zJO9xT3aB88sO7bnswcDWw1sB12w0U5WIT3aDM3BnOlD4ybJWXo/q3p8V1R4Umit73EtyCICZapDIgInv0fA4zrfUQA8NDclQ1GOrvQ4NmPcfh+kKTQ+1mQzMNAQMIf3yg2pHh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 06:34:05PM +0900, Harry Yoo wrote:
> When slab objects are freed with kfree_rcu() and not call_rcu(),
> using struct rcu_head (16 bytes on 64-bit) is unnecessary and
> struct rcu_ptr (8 bytes on 64-bit) is enough. Save one pointer
> per slab object by using struct rcu_ptr.
> 
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>  include/linux/list_lru.h | 2 +-
>  include/linux/shrinker.h | 2 +-
>  mm/vmalloc.c             | 4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
> index fe739d35a864..c79bccb7dafa 100644
> --- a/include/linux/list_lru.h
> +++ b/include/linux/list_lru.h
> @@ -37,7 +37,7 @@ struct list_lru_one {
>  };
>  
>  struct list_lru_memcg {
> -	struct rcu_head		rcu;
> +	struct rcu_ptr		rcu;
>  	/* array of per cgroup per node lists, indexed by node id */
>  	struct list_lru_one	node[];
>  };
> diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
> index 1a00be90d93a..bad20de2803a 100644
> --- a/include/linux/shrinker.h
> +++ b/include/linux/shrinker.h
> @@ -19,7 +19,7 @@ struct shrinker_info_unit {
>  };
>  
>  struct shrinker_info {
> -	struct rcu_head rcu;
> +	struct rcu_ptr rcu;
>  	int map_nr_max;
>  	struct shrinker_info_unit *unit[];
>  };
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 41dd01e8430c..89c781dcab58 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2596,7 +2596,7 @@ struct vmap_block {
>  	DECLARE_BITMAP(used_map, VMAP_BBMAP_BITS);
>  	unsigned long dirty_min, dirty_max; /*< dirty range */
>  	struct list_head free_list;
> -	struct rcu_head rcu_head;
> +	struct rcu_ptr rcu;
>  	struct list_head purge;
>  	unsigned int cpu;
>  };
>
Why this change is needed?

If you want to save 8 bytes of vmap_block structure, then i
do not see a big gain here. We do not have so many vmap_block
objects.

Am i missing something here? :)

--
Uladzislau Rezki

