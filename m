Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC744606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 05:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=x2Y1yS06
Received: by kanga.kvack.org (Postfix)
	id B50596B063E; Thu, 19 Nov 2026 00:14:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADB7F6B0640; Thu, 19 Nov 2026 00:14:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97CAE6B0684; Thu, 19 Nov 2026 00:14:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 619656B063E
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 00:14:41 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CDE14C06C9
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:14:40 +0000 (UTC)
X-FDA: 85450703520.18.7E73623
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf05.hostedemail.com (Postfix) with ESMTP id EB7AE100008
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:14:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=x2Y1yS06;
	spf=pass (imf05.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795065279;
	b=Kh1UdaZeTXvUu+ZFaIVOj9yq5cMqaiX7ym5P4pB9mVcnbDdJGoIr2/MjfGKubI1uN9tgqX
	OBUbwJdVVvAGgQp0ZcDpLpGAJ3dRWMt63gBhHmfowsg/29Z0mX5MYCJii0UjeCr5xfN8WU
	mS43KJmCkzYkv7xFNMF6TpTqmIxYvvg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=x2Y1yS06;
	spf=pass (imf05.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795065279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wyxiWuQSWhgvdEtewWdluvJTi3FrncODBevXsHd/xk4=;
	b=Jeq3JSV/NWGImRnV1sU0fUGio/UvYEFMhBWV2qrBc6ngcNFrqqNk6yy0YUHnt8mM2RcrXM
	frp7oMpGXkYPEJWbAzmcsOU5d8sjNQuq1k0BRUtigXliOCjVU4de3MAnt1eVqO62/39Rjy
	Dz4hY/CH0v6e+qgqyEON83Q5j5XgSCk=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cc758830601so1523922a12.2
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795065278; x=1795670078; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wyxiWuQSWhgvdEtewWdluvJTi3FrncODBevXsHd/xk4=;
        b=x2Y1yS0644JG56yKsoZJjx9jW7UlUR8gHityYtMVaIToZcmekRFf4q1bnzo55qiTgK
         ly8LtgVrM+w3ZTKi53FiX2QOohANRTAKe3XZs8KeI7DrqNWAUKm6ywu73S6SaGO67Zci
         H6Z0h2cgFRkuhzwzLiNki0mWOIy4cmiK5b0NjxrqCW5Uq2vp9hDHeeu1Wum2Zo8CPikA
         Y8Fy2tNadCfdt+D6edkO6TvTSAiuMeDbccR0s5iKRiy3AXr9cnvapqEG9JhL7retbpDr
         yeKjA0m0vTR3kFaVWyMRLsuHiPv01ol4eQYxDv8p+h+QmUgkp1O4QTLh8eCIjXAS7ZHM
         RKGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795065278; x=1795670078;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wyxiWuQSWhgvdEtewWdluvJTi3FrncODBevXsHd/xk4=;
        b=BGRS6bXaG+HaH4iBNzKvbqnuHYIpLZ6IN4ovSRji/oRGsKquVjOXLgPhUAlsnqYqq4
         Gm9fgumNhJQmrNFW5Q8VY1AFRyBxF9q/ftkJ+uHZ7GgAQbcilvThwXQaMSE4d2WbmU6E
         Mk+ReIpu5vlEvErzODmkr9WNs1E3g3LwgH/6udkf8us2OSIn8y5SClBZ/FCNP+fJLrQC
         2FHiGIzsjZbH2QJDkTtlBrh3JDHPNNI0F2YU4dhDz3zcEMxXPhCro3biIe6QD/sPrYP3
         BqZwJS+5+0+BfDrjDZr2z6dbAKywM8CRpW09yatA3XKCxq8JSr0uznMn8fiY8rMkTRRC
         mbPg==
X-Forwarded-Encrypted: i=1; AL+hErHYyrcMQSWrKjgi5In7WNIGmfdtPy+gkPe7wI3PJ6kt2P/Bfh0d8x8Ie7k9XVWmujRAqePZ1wNEYg==@kvack.org
X-Gm-Message-State: APuU4Z/pA2z/EL+Vv86N70Cj4Nh41iYWMr4xM8epGEBx0x9amhflcm2p
	Bff7EVnp1riut7GEBl5WzHGZOQRdWRrm824UPabdIWXHhUxKXt3JeeSn
X-Gm-Gg: AZFdTZdrdLUqEU/Fv1eXhsIUrMNPE81zjcuno93IfTavXxFYNkUswpoL9OUFVha4Z1v
	QfyyQ9giLGM6dlfJBTbUyhWY4pZHZflcOldUUPwyvp+iJGLNRbpWSbeF9bBTeW7CdnvlgtihOic
	Ug3QHw9kRrI4N0MT50R79TqrNSNJnORUIIXXDkqK0OvYJd+6bw2pT0xyuJ0RTSPfQ9RSWhLmJbC
	TCE0w7UUpYCmsKAi4924yofFQUn9TnvAR9a55VZKZGMMwR1QYy2uBCsZL+MvUTC+Zzqr4qDzlyg
	Jvb4OCyEkpA878brk+sBPAVMrFDxdTJ/APfU+4PjONPWe/sMV/lHuI2uboC6TsiJ4j6BeQ/anV8
	kRDKJKRgGIr4akLYFcha8Tb6XM2CXKPUbgxC4jHQEbBDgPvZS/4CjwZjCOcSvgU9VzkFxBGwAtG
	IwJg3jtCDo/t1cWNT1ZWO/ArDOyV7GGY7X0NNCGLlqi+bEf7wgL/MfZk2nzvUk1KwXis60tFazf
	QryyKckQ+Gt+HGf0fxTSQBI75Ncqh4pgz/jHBG7cGDUxbPSgvzipQqwNxllwhpbQc3rl9NylzPT
	7gaLjkFvP/a8wdCuLypPlqtGZfR4+UQhrFDMI7sKQHdwIz5AKer2nOcT2C7HzD/E6PePlDo=
X-Received: by 2002:a17:90b:4b86:b0:3ab:1b19:78f4 with SMTP id 98e67ed59e1d1-3b3d06a487emr5255430a91.6.1795065277522;
        Wed, 18 Nov 2026 21:14:37 -0800 (PST)
Received: from localhost.localdomain (vmi2317697.contaboserver.net. [85.239.239.233])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff628b4ddsm23497315ad.62.2026.11.18.21.14.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 18 Nov 2026 21:14:37 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: Kairui Song <kasong@tencent.com>
Cc: wang =?utf-8?q?lian=EF=BC=88ByteDance=EF=BC=89?= <lianux.mm@gmail.com>,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Zi Yan <ziy@nvidia.com>,
	Gregory Price <gourry@gourry.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	SJ Park <sj@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	Zicheng Wang <wangzicheng@honor.com>,
	Chen Ridong <chenridong@xiaomi.com>,
	Tal Zussman <tz2294@columbia.edu>,
	Kairui Song <ryncsn@gmail.com>,
	Xiang Liu <liuxiang.277@bytedance.com>,
	Ehab Ababneh <ehab.ababneh@intel.com>,
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Hui Zhu <hui.zhu@linux.dev>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v5 00/17] mm/mglru: frequency guided promotion (MGLRU-FG) and flag cleanup
Date: Thu, 19 Nov 2026 13:13:33 +0800
Message-ID: <20261119051404.14533-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EB7AE100008
X-Stat-Signature: igkdp4saqdehn5i79mg9s34jdikr5c6u
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PP_MIME_FAKE_ASCII_TEXT,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795065278-294461
X-HE-Meta: U2FsdGVkX1+P+JVSuKOM+S+gvLWUCoqisfa1prxEcreABrW1MOH/iX+uVuAvzf8JHmQOfhH3pu56BBTvQxD3NMLBK1YCLVIgopHWk97GmHO9jMAerA5ja0oheZBcXvFo7TMTsNoUv4Qre5ewNqa+JhyumFru12fywUf8YJxrGMrqnwIz2TC5WjhWmBk42eubq/VpZnW1KvFmqipq2WrB/zqHXN6WrGMEXVvo0J0XGZCHn5ogDMuyOgFHomm38K+brxwCg0ax+Yp2/bujq/EW4he+nda2NOEnAJu0ibA9IzBXrIiLZSmB9z2y5ZWdHBjfF8BBlMnkCM6cZ/FgbsU3dYeDMxifyMZVQ6A5cwcuuvhHxEAFUQw8O7RkgbDorqvUwD1dHvJ2Pvu/I7loZ5Drqa1dWYCp9uVM1vbtVJON2a5Fo6letHvpiVKyfLL1Xe6GOOESYpt5Nfx1vv8bOVrdBiqkxfIzrHnNhKDpt++lhvs7cUfHhv5D+3giyyyCQbiAEM0x3tkTMRtfYNW22wlSngJpdT/LtqYCldkHFmkqHK7/yfLUxSsPs1xF9dfbdlqO5EdnzrGBoWXHIGPtLWfqxcpLE1ic5P5zX9751itugX4hYEoOtSErSd/6pteRwdZk+6ZpKcqtd3SEdPesZ2qM4DZ3BaKym8JtvQyoAEi+SLmdKImZRLRrrzFpvYaAOn9zv0+ZJQqSNPGIzB0Ktf0fDFNBqz2WINffjrJJ+VZyUljCisHvwQ2863NK4WBxMMxRhrBsJtgb8Sa5ZBPVgbJDDAhOdCzcTZfXjZgmEDYiADwvGjlQn8SuVmWI0Mi4HsOxKlxyVdeVdWA2whrgTJThkNj3s4gaNfX5c025ZWbF3kUZ4Hgcjq0hucJDDQC09GspnAlEKixBU7PqdIKfgYip1hU88ZG7bKlL093VhcAuHUC/YUVlyy46QmxSjPPrMvUS3dzLoW2NRPd1tkvkIUx
 Al7A2NNL
 Jspi6d0CAGxv9Dd8tzWY3KsywmQpQanbLH3whhAtlW9yUte0CM8ZwPaazfDM/c3LdfcOlxSaqHgNBGRE96L/GeIak4jHoUsn4fM+rWNIKBruOJm/yp92htUWnZY7hcnFF/EhP0WLYtqismWivayv52kwz08yWCaES20SF33mMmJtCY2JUMfFScHhEqh9aaT0phMkIcXSAcYybaijxVXuiGvYDLof9DEUqjYUgzH4Eh/QaT1Lf9FVMA82mu1S1zXxjBFaVNThIJ2FpHO1BLvlbrrOAMwLaeAWIHrIG267N/JD8ofZ3N6mJphquAud5ZzMYzVbz3FIMuNMHa/xI9UlZAl+x9oq0RawmDbPeCkdVT0pYcy4o7sFOGJgDk3IyFD9AA26dBlhBtpspAfeVzYMa81TyqHrTrnctp5fxParsilz2Kf8pga5VhhD2p6c3QL0IexUeOLKBwddnoYnNKku3Fy8YW1iMrNXwhJ944SS1+jgg/dXIkzJIjB0OlZkKSaU+0mi6M1Eozb/jtDSOECy2owexqwP71I3p7OkdKmUhDM7S4Wk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: wang lian（ByteDance） <lianux.mm@gmail.com>

Hi Kairui,

On Thu, 19 Nov 2026 05:03:32 +0800 Kairui Song <kasong@tencent.com> wrote:

> I also retested the LevelDB benchmark from the cache_ext paper [4].
> Interestingly, mainline MGLRU already beats CLRU on this one after a
> recent change in lru_gen_folio_seq that bumps new folios with refs == 1
> to the second-oldest generation as discussed. That change accidentally
> gave random reads a higher hotness level while making sequential reads
> much colder as described before [13]. However it's unreliable and
> incorrect because it depends on LRU drain timing, and hurts some workloads
> as reported, or where the sequential part is actually hotter (any workload
> involving hotter large file and many small cold files will be affected)
> which is reproduced below.
> 
> This series improves it while covering ordinary workloads too and fixing
> more regressions:
> 
> LevelDB Scan / Get, Throughput Total:
> CLRU:         4708.3 ops/s
> MGLRU:        5026.9 ops/s (faster than CLRU, but hurts other workloads)
> MGLRU After:  5179.2 ops/s (even better in all cases, and no regression)
>

We did observe a LevelDB regression in our earlier tests on our
machine. The fixes and results discussed in your cover look promising,
and may address our case too. I haven't retested v5 locally yet, so I'll
rerun the workload on the current base to check whether the regression
is resolved. I'll also look more closely at the access patterns and how
MGLRU behaves with them.

The results on file-backed workloads have been especially encouraging.
Next, I'd like to discuss some anonymous-memory workloads and potential
fixes with you.

> Others
> ======
> 
> Additionally, PSI, smaps, and readahead should all benefit from better
> accuracy since this series unifies the flag usage between classical
> LRU and MGLRU.
> 
> Other tests such as MySQL are looking fine, with no regressions. There is
> also community test report [7].
> 
> Refault distance is not included yet, so MGLRU may respond more slowly to
> workingset shifts. That can be added later, as previously demonstrated
> [8], [9].
> 
> Extra note about future development: this series is actually highly
> compatible with ideas like workingset reporting [10]. The "gen climbing
> folio" design may appear to conflict with workingset reporting's idea,
> but it doesn't. The solution is simple and straightforward: once we can
> extend the generation number to a larger value (e.g. 64 or 128), the
> refs-driven promotion can stop at a lower gen (e.g. oldest_gen + 16),
> leaving the remaining newer generations as perfectly time-gap-separated
> bins. These older gens can be considered as expiring gen.
> 
> The tier count is not fixed either, we'll need to find a way to tune it
> if tiers go beyond 4 though, but that shouldn't be hard, not a blocker
> either.
> 
> More details are in the individual commit messages. LLM is used to help
> improve the comments and tests, all results are double checked.
>

Thank you for this outstanding work! We've seen some really exciting
gains in our tests, and we're very happy with the results. From our
earlier private conversations, I know how much time and effort you've
invested in this. You deserve all the praise for that dedication.

I'll continue reviewing and testing the series and work with you on
further improvements. I'll go through the patches one by one, and I'll
share the workload scenarios and requirements from our side as we go.

Thanks,
Lian

