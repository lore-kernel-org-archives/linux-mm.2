Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1024BC982D7
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 15:51:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70EE96B00A0; Fri, 16 Jan 2026 10:51:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E2E16B00A1; Fri, 16 Jan 2026 10:51:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E5BF6B00A2; Fri, 16 Jan 2026 10:51:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4E4146B00A0
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:51:25 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2A438139519
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:51:25 +0000 (UTC)
X-FDA: 84338266530.09.9D585B4
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf26.hostedemail.com (Postfix) with ESMTP id F13E5140007
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:51:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=gEQzjbvW;
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768578683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yxikc1y77Ls9+KOGiahB2sX17dgvn1C4IYfzeZk12RM=;
	b=XpeBzZ1gZsuIViUai+mLEhYsQ1f8QAPEZEJ8I4R1MHCW3RbKDQkU1P0PfnsAPVMzgM6luH
	Xi9dbGuAZQzqowyyEj6SrK8R5i+vTFnqH1KSI15tD+R+nsOPQp0IR5k1sUe3k/OqH3Y735
	JZW5XdJdEjzq4vLumYkp5hVUWlHmCWI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=gEQzjbvW;
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768578683; a=rsa-sha256;
	cv=none;
	b=uSA12NrHnd9maQtC+t4lXNm2FdRhid7NhnEoAxjxi8DXtVKqOG/XDWXPfZsI79AlgrYsAl
	3yUIgVJeqauxs5CaKtao8XyuAhWOea2wgxbHLY2RCzvI+jFEHsJrZdtIdw/WhnKDsfma9r
	dJ/rEFkjabB7cu3N+tAb7BT9H9aFXcE=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4801c314c84so11577675e9.0
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 07:51:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768578681; x=1769183481; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yxikc1y77Ls9+KOGiahB2sX17dgvn1C4IYfzeZk12RM=;
        b=gEQzjbvWxy8TXjsoblMtxaB1f+V93ll6YG2jox1JhiZYAQCnrVY5iTJWp2q/dp6bsJ
         +8HkRsZmLMPko3uu+erxoGH93ydj3SvFx+/ibq0LTJSLLtgOVx1Ablokjza19mqgWh5j
         IHq2zg4+vT17a7P5p8P953jUdfEpDVYxQQ5wV8ZPR7lVR0DTfslqGYas3+fhEoFRehwn
         aupHaUpJC6XCw3XY+vMGCBc8xTq/NQhWgznlDjeguPxkKv0asrD1XjrZXySqNlwB/yV1
         Wcg0V8QQyVIJh/U/VTXE8qQTGjJdsy6+OWpv+UV3Z5k8g2lqwPIVbUD2WTIGiVKeEAw0
         vAFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768578681; x=1769183481;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yxikc1y77Ls9+KOGiahB2sX17dgvn1C4IYfzeZk12RM=;
        b=RLcaR1g10vYRisOK/HvvJHdx/IoEjavUzgQFQN+wFY6bv3Uxymlhi3vk9+0j0mLtSV
         XGYwPEqu0PGAnFukHSX2lev1YKKTgOOSlyF/FECvxjJVeAhlYL7mJo8ThfPwEt0ZKAEr
         7GVUPUWR4i930zUT15nITMpZPlYO4i8K84834seuEUxttotJSEfq9CHssRhoZ7McPpFe
         FbrP3bBai6jgkSB6hg+9Tsmm36ctsbLsOADd26YByzXW7dMT7wsA4Xsx3sqDGYTrt1eY
         cOuBokLHKMzuAJ1UqEkLgTfpzAv/Pa/spRYwuoHyUzkeqlcx2FNGIrxw6/RxOc19/gVz
         0P1w==
X-Forwarded-Encrypted: i=1; AJvYcCVteq8XTrCb26fz8R1SotAALptXO5e4A7/KCKaGpKtvvExoxEY5KsRZy7jnuXonZieXzNnjQF+EIQ==@kvack.org
X-Gm-Message-State: AOJu0YxXUigQIWGTkrXHPiN6FQ8OIpl7ZjKiJYM3ZMlNukT7w1J/n/2/
	3JtZaWnfYBVWJj8b+/aWdXm8YWim31nXDbi718SjCNhS8iEXR44dT/Co21uUV2YjPMQ=
X-Gm-Gg: AY/fxX6X3Di64J3HXQr1scXdTVKPmpslkwQxs0gyyRgaQraKneJRpLEem5IllFD5m6X
	e5RSOS97a9kyevV7s1h8oCXf9gHEfp/gjIYh71K1u3l5adMy+3YViqxcVvT9+7MW1ZDLyKUUxNv
	c5WZJ3afsHZGxa/svOMoblZCCfC8QL+uAu1qGqat/sbC/O3+jp9a8kBerls+eCwb1960CVoyjO9
	mikDXb2Ri6GIgoab8rwJEoylaOfjakKRRw/muDwxlequPYuCa+7UtPh5OTY54IsaAzIQ8Kz1Hbj
	35I6fLC9oKenQ4QwHffIiNOK6bwmLblCZSJfZHz3Q+vhiK4Qw+eoN5Jn6/guHaC07MdxrnytCWC
	wbjhBtXTWUrH/01/aXMotoMTCUMCwaQ74wUdV0M7AboUBVLUGhbB/FwnpHUgXuu7JtiiTXBgR3A
	852vFZva44WMH2pEQXW6H/emxH
X-Received: by 2002:a05:600c:3b9e:b0:477:9a28:b09a with SMTP id 5b1f17b1804b1-4801e2a5861mr49417745e9.0.1768578681507;
        Fri, 16 Jan 2026 07:51:21 -0800 (PST)
Received: from localhost (109-81-19-111.rct.o2.cz. [109.81.19.111])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4801fe65883sm18036695e9.15.2026.01.16.07.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 07:51:20 -0800 (PST)
Date: Fri, 16 Jan 2026 16:51:19 +0100
From: Michal Hocko <mhocko@suse.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>, Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>, christian.koenig@amd.com,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SeongJae Park <sj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: Re: [PATCH v16 1/3] lib: Introduce hierarchical per-cpu counters
Message-ID: <aWped4MIi5i0Y7-R@tiehlicka>
References: <20260114145915.49926-1-mathieu.desnoyers@efficios.com>
 <20260114145915.49926-2-mathieu.desnoyers@efficios.com>
 <aWfHTLDA8-Fja_gD@tiehlicka>
 <67bdfd38-1acf-4b90-9e34-ce752632ddb1@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67bdfd38-1acf-4b90-9e34-ce752632ddb1@efficios.com>
X-Stat-Signature: ed8d3b97ggtiiaar8oytqpcbu3roejrn
X-Rspamd-Queue-Id: F13E5140007
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768578682-568636
X-HE-Meta: U2FsdGVkX1+5Cjvk18kIgu672+RSi0maW/6fTZEp2Q/Gw+2S2BOP4A3Jja+4D9bbSRj1XoZ3IjEndqHkAyA7FEi8DPGEAOxQLMYxo0FPmm17cQ0P2z+rqqcVPQn0fYuO5+3yXfY9kut4HkCxZoSECZkWXWzQymhIW/AmRWewdsnbKaScef+Xu5rz4dgrYNJE2UGpugjvMUm/vA1qqYFURU1X6liAHQpHiUVUu8zhFYNBGjBwKznUGj8nVo+agFg7n705DNlO64f1OryrWyv3IbTOB94f2H5I7V7fSseVEnwnfxae58ar/ajBKcIE33oKqcoAkBUAfd4K10eKkf8m3c0rPT6pXQVrwMAhwK+VUkn7btr8nVeOHk8u0/87/KYj11pZoUNAIYhf18tVabHbgfwwKwCzbarDh4+BSg7ib32EHwYEKDPRlIfHYU2TiyFyoV7uEYvCBjMYR6luScTK/jfcOLFkuvv9kBouVv/Z34bn/bKWg1Y2nLpKtSlQsuyGtuysQThNyh+wF9czFotx3zjyIDFoPai7EgaGWsWix4z3ioFbJuamfBEkFFV9e0Ei33pvzTZu6tluodg/X/FLKzSnm4eV+CoIQBmjSkyvz9/23KHdNtR7EyBzJLjUdwvM+m+0sC3qN1WcG1A0zfI25KVJTbqJ1G6F4+HvrJmnj9r+ABXxq/RBIvR6zmRQszTUTZSL374Y5O3/jd2nWcZYS4uVQb3XNXqc75XeQQGDaV4FOXP5DLVs5XAKQKykf34s5Wz+7YTEyfHi375aCQwi9y67PcCIhkvxKuNJNg+jLzuZZk2eIolleKIKOkL+11ZbV2wMKR2V5tOcrmv7dedlPmip6Q5ta8S3HLrfqD9PZqlXKMOwKpThsyfEKksdjZqdRK+LWa1XOqGm4DdqEZyfnJ3i593FG58R75NUuoQh6Y+e1RposcRyfgI2hUsyf75zBnM6bG5WTtihzbAWEYm
 sD+nnn9K
 U88Z9V6WzuYVVioXfmSxeXts+Pv8j6venMWVx5WaNk4N1BO6CTeqRtd9abVdNdzROn3BRzb1j5S2LyPlb3q/dAqddEg2vWkmtxymHEO4WJn13Q+T+ZsrLRKzjHrKbPzBX+MYlibBJzCm7XDsJrL4qDUe4zXarY11AG/4hLbq5u2nw0FMO+vUPAHoc9On7UK4y0US5KPk2H3EXiJiqoc04eHexUoIEaZ8Xi7A2W+FBgz5YUeKR1ZZ0+KUm8uTn7sIKWHD9MVXHmrmDczQGDEIbEmlLL65Nc4Bi4GiNYAJ2mUg+Hr9F0/bdKhPEHWTdHjkPBMfztePrLs5sf8f+fLjFqlHos5rbw7hpVJYpjVsNs7hykyxL+vSdvYGs8VA8WQTfkVtTL9bTXMARsVkl/+zkIkQnuDtewIy9+0LQiBdrZhMzkhM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 14-01-26 14:19:38, Mathieu Desnoyers wrote:
> On 2026-01-14 11:41, Michal Hocko wrote:
> > 
> > One thing you should probably mention here is the memory consumption of
> > the structure.
> Good point.
> 
> The most important parts are the per-cpu counters and the tree items
> which propagate the carry.
> 
> In the proposed implementation, the per-cpu counters are allocated
> within per-cpu data structures, so they end up using:
> 
>   nr_possible_cpus * sizeof(unsigned long)
> 
> In addition, the tree items are appended at the end of the mm_struct.
> The size of those items is defined by the per_nr_cpu_order_config
> table "nr_items" field.
> 
> Each item is aligned on cacheline size (typically 64 bytes) to minimize
> false sharing.
> 
> Here is the footprint for a few nr_cpus on a 64-bit arch:
> 
> nr_cpus     percpu counters (bytes)     nr_items       items size (bytes)     total (bytes)
>   2                 16                     1                 64                    80
>   4                 32                     3                192                   224
>   8                 64                     7                448                   512
>  64                 512                   21               1344                  1856
> 128                1024                   21               1344                  2368
> 256                2048                   37               2368                  4416
> 512                4096                   73               4672                  8768

I assume this is nr_possible_cpus not NR_CPUS, right?

> There are of course various trade offs we can make here. We can:
> 
> * Increase the n-arity of the intermediate items to shrink the nr_items
>   required for a given nr_cpus. This will increase contention of carry
>   propagation across more cores.
> 
> * Remove cacheline alignment of intermediate tree items. This will
>   shrink the memory needed for tree items, but will increase false
>   sharing.
> 
> * Represent intermediate tree items on a byte rather than long.
>   This further reduces the memory required for intermediate tree
>   items, but further increases false sharing.
> 
> * Represent per-cpu counters on bytes rather than long. This makes
>   the "sum" operation trickier, because it needs to iterate on the
>   intermediate carry propagation nodes as well and synchronize with
>   ongoing "tree add" operations. It further reduces memory use.
> 
> * Implement a custom strided allocator for intermediate items carry
>   propagation bytes. This shares cachelines across different tree
>   instances, keeping good locality. This ensures that all accesses
>   from a given location in the machine topology touch the same
>   cacheline for the various tree instances. This adds complexity,
>   but provides compactness as well as minimal false-sharing.
> 
> Compared to this, the upstream percpu counters use a 32-bit integer per-cpu
> (4 bytes), and accumulate within a 64-bit global value.
> 
> So yes, there is an extra memory footprint added by the current hpcc
> implementation, but if it's an issue we have various options to consider
> to reduce its footprint.
> 
> Is it OK if I add this discussion to the commit message, or should it
> be also added into the high level design doc within
> Documentation/core-api/percpu-counter-tree.rst ?

I would mention them in both changelog and the documentation.

-- 
Michal Hocko
SUSE Labs

