Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B6C6CD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 08:47:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49AD36B008A; Wed, 27 May 2026 04:47:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44BF96B008C; Wed, 27 May 2026 04:47:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33ABB6B0092; Wed, 27 May 2026 04:47:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2337A6B008A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 04:47:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A64D940539
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:47:26 +0000 (UTC)
X-FDA: 84812570892.02.43CE698
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf02.hostedemail.com (Postfix) with ESMTP id A9E7380005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:47:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=LAEcIWuZ;
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779871644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SvPbiO/kvHgyF1x18sRDfpJ1LTwDqRquW88o+S2pTM0=;
	b=Ck89EiLZtjtbg8uxLgTe4KVYNedaEIwgO5qJCiAKQp8aLKDCdpvN3aUXJuaYpBCTI7d9hY
	EVB7hCwhqpzRKdI8laVufu9op2qgYTi4hMunv3PwFzQH6yth/yDTO41baa9tFDGhr7nkS2
	Dv7rqO/CBXR9gpVyfGi5UhAHw3wpLY8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=LAEcIWuZ;
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779871644; a=rsa-sha256;
	cv=none;
	b=stSN5zgz/y+pkkyukSZPPlW8ITS4vHhbL74u64JZuw2XPCzecQ3Xs/SWeJbKqJpO9S8H2l
	I7BNn9nyCY++aiMNM7iwRQs8fbM34mhdI3YIVkuNAUjWSSTlWmTkJHA1QrE+7OiY0Jp9by
	akMrDF3tmYgKtfdZN8bW03MaEMzwaB0=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4891e86fabeso18830985e9.1
        for <linux-mm@kvack.org>; Wed, 27 May 2026 01:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779871643; x=1780476443; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SvPbiO/kvHgyF1x18sRDfpJ1LTwDqRquW88o+S2pTM0=;
        b=LAEcIWuZ772cNLdrdB2jrxMS3nCQwYTrpnkt/olWmRVSB4GK/Gm0Rsf5Bk08B8aGZL
         lmxFjmsnCrYKbkzD7Okv7Z3086CdC/06/pS1ouoP3IkJc4AJuPNsXLVQ9Kq7iIU4gliG
         jU31lRA6jesNaud13We6b6qXYf+SoGbk42j3PKARd772UXaPp0VmBK5sYplwwnPI8XZ6
         JJCY4wx1vLCTX+7SET7I54WyDObGXtvjUcuRbhwvcKTeGK3vXJiQsp5D89jYEhrELeM/
         8Hj83j9bCNuYPafk3AHdW8G1IgE7txNJcel3gXW+HUISDUsP7POQ6ip/K9VyMW7zYrL5
         RPIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779871643; x=1780476443;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SvPbiO/kvHgyF1x18sRDfpJ1LTwDqRquW88o+S2pTM0=;
        b=nPY1QDLYr0Vkym/dtFoCSXcoVJqmHLIRu2G3NpANEUoQ0NErRURTC4dFsB6aOKX8qo
         P9Bm9XyLi5Uykywrw4VMHtN0fQLxVeJ2cGrArfAvC0daAq3VxreIx/B1EtnQsQZd6kzD
         DqMmHeWn+GSu/B0hrmlC1NE+QwqEOViUKknBdiK0i8Nz+7FWaQzQRFxY214FxeUd6+fY
         eJ0Sg2HiWird43l78e+TYY0djUimVpL5nzOp1PBPr/ADSJVVcsY5YLql9iRE6aNbqQu6
         9ydF3WaeiZ/tcmph9mOGlYpOG68j+jMfewAIEpBUbE7FVLlg0zUH/D3mnObHXUzkxoX0
         ucvw==
X-Forwarded-Encrypted: i=1; AFNElJ/BdaN7aLM/4gSnjmuJlWY56y5B8Fy8Jydx2BuqhGfVmn2F5NZG+Dk6HCCxZbUjqVXLYyZLcFcPPA==@kvack.org
X-Gm-Message-State: AOJu0Yw32TIoqQAxNs6ikOnBgLAdcc4H3XBCBzTtppaq3+84pgPizENZ
	BQRk2xNt9vOp2vOu94JjvPCYVIQB9PtkkUhbanfQuwTja9s+UwXFjigKB2E825DR8k8=
X-Gm-Gg: Acq92OH7scY+MVEtFCkhe8J+DyClnMajaz2PrO1nrYd37lgs0C3m5RFG0PeuKH+JoVA
	PG+SfqQ7PzpcC0Oc7Xc5lZY0iMawU/pYsMuF7j9snvaUINh6FngJ468w3hAAz7tMQv0xe5dWAdx
	k3++3CDrVKMtTwpZKyRKCj7ZniIWMev/nrjLLrqdaUW31p8svn6/c273EfsZhvD2tnASOqXgOnD
	9LQIgI4OmXj/IS6RYoFhSYgCnff2JGroLt5tsgk62qqGqEhUWfgl4w2h1Bv/gJ5ENkJXMhWz69h
	Q1qhEYEmLJuGk9Obewkrticzckd9wf7H9/MG/wPZGKXohgdICZ9kYHrFHPTpLEnFI5PaGwLTuh3
	+ekgOL3er62ww4PC3nRIqhkhRtXD816aZzOJlYqmmosQZjwTrSpxd3auQ1Xjfj0/PCB+YnspBHu
	xlJ+fXsEhlt2Kp5bblN5dtiCUJmIPBSJqpvq5apJlH7Jf+
X-Received: by 2002:a05:600c:a402:b0:48f:be94:d82c with SMTP id 5b1f17b1804b1-490426d1a91mr259475015e9.19.1779871643182;
        Wed, 27 May 2026 01:47:23 -0700 (PDT)
Received: from localhost (109-81-80-71.rct.o2.cz. [109.81.80.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4908098f315sm12090405e9.16.2026.05.27.01.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 01:47:22 -0700 (PDT)
Date: Wed, 27 May 2026 10:47:21 +0200
From: Michal Hocko <mhocko@suse.com>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>, davem@davemloft.net,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>, KP Singh <kpsingh@kernel.org>,
	Tao Chen <chen.dylane@linux.dev>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Amery Hung <ameryhung@gmail.com>,
	Tobias Klauser <tklauser@distanz.ch>,
	Eyal Birger <eyal.birger@gmail.com>, Rong Tao <rongtao@cestc.cn>,
	Hao Luo <haoluo@google.com>, Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>, Kees Cook <kees@kernel.org>,
	Tejun Heo <tj@kernel.org>, Jeff Xu <jeffxu@chromium.org>,
	mkoutny@suse.com, Jan Hendrik Farr <kernel@jfarr.cc>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Brian Gerst <brgerst@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Lance Yang <lance.yang@linux.dev>,
	Jiayuan Chen <jiayuan.chen@linux.dev>, linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
	netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
	geliang@kernel.org, baohua@kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH bpf-next v7 00/11] mm: BPF struct_ops for dynamic
 memory protection and async reclaim
Message-ID: <ahavmbcdXDX5gNup@tiehlicka>
References: <cover.1779760876.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1779760876.git.zhuhui@kylinos.cn>
X-Stat-Signature: wkdaiwpuitigcjipzqbxf4z5pb1ur6ro
X-Rspamd-Queue-Id: A9E7380005
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779871644-449143
X-HE-Meta: U2FsdGVkX1+pY9MBbrVdI7lu+yM4o18MnjTVXo/NpDTgTu1wL08yYhhALaPakfhK8bUMg3Db6K+TW7DJuI7uCZuSxlQmKyXIfXWGoFutOjF3riSq3Scs9jHI9tnuCC0Nsnvut/pqtyN4TTeM7afM+MRqgCc0aCZW9lFZrUnUPqvCoLE4gC5Kd/gDtL/Yz6phwoQWZ7O1UZNYv7p05sujks6KrLLtjKviv4HY57UKNcEVUC9DGEBePnQJJ9FoDRd1zTMIYf8Ofgc20bpu3n/82Vns4oCEep1ZfA5WHzYZHf0xaDuFD4gMUGK5hnWlIvcizbwO0lGTiOlNqkduJqglLGs4bp5p78KGjClUrNoVfoK45uOZUaKgVyw8MohQNX3ObQUu+3YiPZKmOvgxc6hzNd+IgPlhiVNHBxjb0GTwBbK74y0R1gV/RxDaJ0PN+w2ecdcquIVOCSryCeyr/NelUpfpH8B89dVA0zYCxSlXvV6ljY3S3ypYzBaRfFSHaQWmgEzVbQwe/u1STxEGGGyWPwMC+mIXG6CvO/vk5c8XwHKAqcCW++pdyiaf0lM9d2WKgZsTExV0Cs6yE/Uj5qSYxNwENkFE/NhTy9R4v+EfEBCIt2gCJ+G7Daqn7L4nFfvmaHsLbzjEsHSx6IaHNgiBXSu6JnbffdgI06WY0iXyCWeXvu9iSEq9R9Ng+2pYRZiRhZ4/GVbBqqNcwxfAMH1/TzRGD8NqQzS4KytEqVDhuHS/8o4iW4fgI6Nl57zyfgwLWb4ez7E3HZWiqdWROxJiHC9M+XIx7Xyrox4Kj+fTHVv4vcbPEpvQWyFO/YLsIyxHNvnChYndnTDjaX1VIfDOv8nfd+QtB24XhFxiZdldjTNaGrDKxjD2/bb44nbKhZotNaSWEZq90X3cZwxQS0rfBkCUKqK9/iWI8HxXfNjbUGT3uQciDkOJqAW4JaOyTHCKp9KXRjTloOLfck9CSLs
 3CRhtT8J
 ys9y9YcHVYkdBIZnzWApziHZDKAw2/EMGqCUnSOrwxngR93koaPx/bapq7KPTP9MDvlQPqOe/cIDkmFQaUfkEg9SyXuxHUdP+zGtdp9Cg4+JS6eYmZ34ld0Av1kG58VlmgoWXFcNP1GIImOJJjidVb9nnIg4QWtVRoUtLAIDRxlXlamERAsriUW4MQDPuFRXpFHOPxztbWbkKSARqN809nHFejdZiAqb9MUrAh9KGgAOsVHQMy8RqROEn5YWx+pQk1ktXjxMkOlyaIHuaWnXbCSEsR7ASKn/s4EPdKxsk05jdk/SI6HhoQmOzUGyID/bW+ifNSPYt+dT65XULyOXWhSnE+p0tHvXxoahSFS0IDV6+AZehtp+it+smvnv/ONQJsF8QarHnGLXHH1UYkOsopex+wiIOIxzzYRLcCtmmPW+9/pgPN+hdA/bl2BoEUaVeUbOJVA/IbVvLVAl4MYL450tXWrWyM94PcFer
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 26-05-26 10:20:00, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> Overview:
> This series introduces BPF struct_ops support for the memory controller,
> enabling userspace BPF programs to implement custom, dynamic memory
> management policies per cgroup. The feature allows BPF programs to hook
> into the core reclaim and charge paths without requiring kernel
> modifications, providing a flexible alternative to static knobs such as
> memory.low and memory.min.
>  
> The series enables two complementary use cases.
>  
> Dynamic memory protection: static memory protection thresholds
> (memory.low, memory.min) are poor fits for workloads whose actual memory
> activity varies over time. A high-priority cgroup holding a large working
> set but temporarily idle will still suppress reclaim on its siblings,
> wasting available memory. A BPF-driven approach can observe real workload
> activity -- page faults, charge/uncharge events -- and activate or
> withdraw protection dynamically.

Why the same cannot be achieved by dynamically changing protection?

> The test results at the end of this
> letter quantify the difference: in a scenario where the high-priority
> cgroup is idle, the BPF-controlled low-priority cgroup achieves roughly
> 37x higher throughput than with static memory.low.
>  
> Asynchronous proactive reclaim: the memcg_charged and memcg_uncharged
> hooks, combined with the BPF workqueue mechanism and the new
> bpf_try_to_free_mem_cgroup_pages() kfunc, enable BPF programs to perform
> proactive background reclaim without blocking the charge path. The
> pattern works as follows: the memcg_charged callback tracks accumulated
> memory usage; when usage crosses a configurable threshold, it enqueues an
> asynchronous work item via bpf_wq_start() and returns immediately without
> throttling the charging task. The workqueue callback then invokes
> bpf_try_to_free_mem_cgroup_pages() to reclaim pages from the target
> cgroup; if usage remains elevated after reclaim, the callback re-enqueues
> itself to continue. This allows a BPF program to keep a cgroup's
> footprint below its hard limit (memory.max) entirely in the background,
> avoiding the OOM killer or direct-reclaim stalls that would otherwise
> occur.

How do you account the overall work done to the specific memcg as the
large part of the reclaim is done from WQ context?
Also when introducing a BPF hook please focus on describing why existing
interfaces fail to achieve what you need. For the async reclaim why it
is not practical or feasible to use userspace driven memory reclaim.
-- 
Michal Hocko
SUSE Labs

