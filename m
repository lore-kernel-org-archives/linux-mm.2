Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A256C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 14:09:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 263716B00A1; Thu,  3 Sep 2026 10:09:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23BF26B00A2; Thu,  3 Sep 2026 10:09:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 152206B00A3; Thu,  3 Sep 2026 10:09:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DF2116B00A1
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:09:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2B0A4A059E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:09:44 +0000 (UTC)
X-FDA: 85172634288.01.82FD339
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf09.hostedemail.com (Postfix) with ESMTP id 08205140003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:09:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=euRyGtBu;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf09.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.181 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788444582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MdYFxMzLhAsz9CXEVO1o2mt6I0dz9BL/Meo6d0Bb364=;
	b=mof7650v/UxCtP47J3+AA0rtfDiwlgmbe2ID8PIsOmztVg5nxLhxEOdAk4uYEt+pIJoiIV
	f+CC8LITlAdMeDZ208j0T2jDSmlzZBFNudWNN2RoQRubsLpTE9ndDWQxLpzdGwIEDCSoNm
	zKYOBM1bmPZRevJVHryWv9ckawRYZME=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=euRyGtBu;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf09.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.181 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788444582;
	b=Xt0fjxIjTrHE0T3HiXOy9jU3c1hXNaCtviuK4ZTChq8A5ubv/WfgS6ha43XI139h7hTCWX
	xIMZFywSrnWuPUVLVxVOmNtYJP72SUxyupggqqPTGFnWJmUAJsK+wfnchilfQ7stgUeVDe
	m/1rQXTG4d15VDm2JD8kZZYcKydzBCc=
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-836ce6cbe1eso24741627b3.1
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 07:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788444581; x=1789049381; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MdYFxMzLhAsz9CXEVO1o2mt6I0dz9BL/Meo6d0Bb364=;
        b=euRyGtBuBA6+iYGbyuB8SPwEa6oEVtK2+Iy55k0QC/Lv3pfAI4MGT7FiDCNRxhUcUD
         /quFxBkGB1w4RVr07YuyWrXxzBH+qiuJu9h+2Jt5wXsSn4bpUqP4U7aRbiWXSP8y7AO0
         NyYZfy/chm3SCitAREuoSmGLBL0Sg/a7sul5umSmKaipqfyQKaQcuUWzk7ZYvAv19Pg6
         /xNpwbMBd2EQgAsv62pnbG6B5O9c2m11O4bP7ZPQGKHOIkMuXoLfrvhbtfxsr+I4UlI6
         X+n9Y2yzmvnJi3ruYo+zaNgTzB+uHlpj9xvTgPObXG8TjPbupEUVW0/zw2nA+TXzht1W
         kpoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788444581; x=1789049381;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MdYFxMzLhAsz9CXEVO1o2mt6I0dz9BL/Meo6d0Bb364=;
        b=TvihEmLXlaaiZ5hsTX2XMe8aLiVRjXn2WRsNAT6xc5kLBAP5e6SUwyp6UGL2SulgM0
         Pe5QNDUk8xj+dAV901E0Ik0CF3DMVHuqE/gzNVImxYnxIG2B1hNhfqoakqGsScMEc//x
         aFzOEj49Dj9S4lLehRoPqYH72lenfkhMKjeRJ/wlAPDysqJmmhdGvZu7gSXJjArL17Ds
         hOFLRpWdijoxgyl4hFKBdMaCGjWR8GyWRPGyCqMQDKB6bvJhbCxWEM0j0AxGkYTLfTkX
         V6Up3XD+RbDNU+B/4hmGI3Ais0IaZ+TBP1I7Il6ASFc0H6OQZdK3/yFE6yJAvWhA43Z/
         6SHQ==
X-Forwarded-Encrypted: i=1; AKwUvBwZ7q2kYAWyHh83eGgWYP3f+KtteJUWRf+R8mWiyRHPGvfayJ33C0vd53Lh0SwSY3BPheYMkT9mvQ==@kvack.org
X-Gm-Message-State: AFuF++kobQXM7P+NQFe3zqD1SQKof9jyu1zKj2AsPZM8NM6cCSh8w78f
	v8wvztsbkqx2FFcX8pfKl0mds9fACJ+VYE8DdCiuwAupbxhJEuqJXMslrq8H/ZvEN1s=
X-Gm-Gg: AYBFou2b265GjD/QVwZnx59vICvjVaWxjiDwBirxm6sAe1gnvQy7yyTj0QDEWwHYhEB
	oIoDO7JYshvUpw+mEXRfdxnU2/0xhQ+S6X0M0aoUvmmxG+Vk4Fps5Bvo4oybZDW9MBImdnqfaF0
	AySrPEhEGELZtpde48hN1EteDHO7NMxrS+oDyt7yM581Brjqx+N+rhgONIEHyvlqZAoEDPnmwXU
	O9+8uOa+HN7mXOGvxPI3kTmV5RA7bfnhdOQf9ueUwfympc4DUSEcjyLCsNSMbZ8IwhTu0B6Z30S
	RqW2ZNovQCm0UefS3YeP4aQSo5HStRDl7BCUUGmm4jkdLQyBsclIohRKPor23mJd4I3PwN95od9
	MxBpC/arFCdVTmYEOd0vouHPErJxmFBjLZeAACAXFDzRIZar9GIVV6kHBeB7+rXtYkwAauyqgXs
	8waF7co0xiWzRHg2GDNhwI7aJl6B3Oajt6YMfyr/D+a0zW4bTsdyB+PvlQNpP7
X-Received: by 2002:a05:690c:c512:b0:81f:2403:9e70 with SMTP id 00721157ae682-86c51d40664mr58591657b3.19.1788444580869;
        Thu, 03 Sep 2026 07:09:40 -0700 (PDT)
Received: from localhost ([2605:8600:200:1a83:fe59:7385:2855:8588])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-86c178435b5sm40369647b3.29.2026.09.03.07.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 07:09:39 -0700 (PDT)
Date: Thu, 3 Sep 2026 10:09:38 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Chris Down <chris@chrisdown.name>,
	Tejun Heo <tj@kernel.org>, Yu Zhao <yuzhao@google.com>,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 2/2] mm/mglru: fix ineffective memory protection for
 non-kswapd reclaim
Message-ID: <20260903140938.GS3004@cmpxchg.org>
References: <20260903031952.1120321-1-ridong.chen@linux.dev>
 <20260903031952.1120321-3-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903031952.1120321-3-ridong.chen@linux.dev>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 08205140003
X-Stat-Signature: k83u3zxaeceycak8awgn5mspfqqooepm
X-Rspam-User: 
X-HE-Tag: 1788444581-837164
X-HE-Meta: U2FsdGVkX19u1B5KVfWT/wjvNIZlkeGv7KccwPCy1xnBKba9tqmtneYxJYzNVoDH4Fo2bxeKJZ/t3WGFrcNQsDPyto2BtXbjz13YzznYkSAQsU5wRf2xDNgKnfE6yrfzR3U6RV+1FbfT4YulNupNHMTUkVf2IpFM+LoCLiR94TehHHwhwFtGxXEr644NfNayz//TeNyHzw8wjTYTMMOIdyI3PUslKU1zxuoD0kJovpczVp3l7Ma/wtbYoYA/jDbJJ7k3hcirmNaV/p4Lwt/yLv69Mti9MsinFoSGD9Xo6DaS31F6waO3A8JJBKe9yHPKjyM/Pu8I/SIK8HxjYy/Dq43kgIbpTe8ymage9XvcsjCfqTZpfhnhGOxfxeiIBQUGgWMQBQ9WOoj6OVRKd8s5U7moF0OD+/lq+yzQsghp1C/M2S7wzIt9+mO6Ci7Qth3mfuUy0czBT9dsb/6xvM/Sd1WUUdGNqO3NMNixV4yfRCZQ0qMe1pgStH6A5YBlbMowfAJW+hVD/3Mrm4FukhXb9lT+wRJgcrim/ZeKq1kVREPvx0L8niyiDOUwJytpx48x5oid/Ld7FobAzwoUHVi1wj00dW+OEmWx26HNrAnk4RKH9nwd83Wdn/RV6Dve3ewZSBlt/c9D+AYMiiwIaFLcPqIcGBI1/ZgbcWfs75XLQTil6wsI6pEENqah3lB6zJQzrWoquWRSHOE43rTp+shhSrote/BYt3hCmZkIRM1Nme0i+RAVPpWs6qyenKd2Uru6fmrvYf5Nupvq6jWGNrukO9zfIZRchShIweq0zucaaKFQCXZ89ke9JJCaq+f1aj06sFuwx43VGYHeFBBLeNcznS+3US2maU5fy+XVajYeH42BLPkv5FV16mpwRmbGH4UsTQBCsKRdY05+wsNOlqZxYDzV3IUvvXGH1UDP0XayZK7xfRiCa3+h22MHQDJ1JxfrPkQJLIhGHp3DSJbsQZJ
 bodu0gCe
 fGB15dhAwogc/CWTeP9veN1PXpzglZnpdhz9QjliB5frTYWpVYrK6ZZtBSY8JQljrHlH5NWDjXedCXKXHAqGZ3zOWBKYu8YbDXOvamA18j4Wq68pk2Q6NdSTzQsfGFFzaisyqVMJP/XL/gK2u4LDnaKQviBaWbk+5lUIvStFDonxnrWyJd2MyCwpSVL+nzaW93yKRM7r1zUJweuvqAm1HmsHYOKMo+12U7Mpxe5Fyq7Ge7Yt+yxShO+d6/jj5FSDVa1F97aF/MK5sy/GrAh9khwutphs683frGZzcYm5oU5ZXmIreVcJOm6n23JCrmPvX/7uetX29UDrwXP4BU5mt/NncBIe5CBP5zY7Kk+nFOVGGz2BlF64YinLUYwg+eZ1e8dOQEDSgkgS5rJqAvnMQddDSrFwKubRLsfGqb9wwSTK6xvzwJlSVeqF1G8d8G4RqW0YyCh/8+kSDRzuBbv8ONXis5+l8OjcTSQ8t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 11:19:52AM +0800, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> For MGLRU, memory.min/low is not honored during global proactive reclaim
> (writing to the root memory.reclaim) and global direct reclaim, because
> these paths shrink memcgs using stale or effective protection (emin/elow).
> It can be reproduced as follows:
> 
>   # echo 7 > /sys/kernel/mm/lru_gen/enabled
>   # cd /sys/fs/cgroup
>   # mkdir -p a/b
>   # echo 100M > a/memory.min
>   # echo +memory > a/cgroup.subtree_control
>   # echo 100M > a/b/memory.min
>   # echo $$ > a/b/cgroup.procs
>   # dd if=/dev/zero of=/tmp/testfile bs=1M count=200
>   # cat a/b/memory.current
>   222650368
>   # echo 500M > memory.reclaim
>   -bash: echo: write error: Resource temporarily unavailable
>   # cat a/b/memory.current
>   6070272
> 
> memory.min is 100M, yet reclaim drops a/b down to 6M, breaking the
> protection. The traditional LRU path is not affected because
> shrink_node() calls mem_cgroup_calculate_protection() for each memcg it
> visits during a top-down tree walk.
> 
> Commit 30d77b7eef01 ("mm/mglru: fix ineffective protection calculation")
> moved the protection computation into lru_gen_age_node(), which only
> runs for kswapd. Non-kswapd global reclaim reaches shrink_one() through
> lru_gen_shrink_node() -> shrink_many() without any protection
> computation, so emin/elow are whatever a previous kswapd run left behind
> - or zero if kswapd never ran on this node. Relying on a prior kswapd
> pass is not correct either: a memcg's emin/elow are derived from its
> ancestors' memory.min/low settings and from children_min_usage, both of
> which change over time, so emin/elow go stale even after kswapd has run
> and must be recomputed at the point of reclaim.
> 
> Introduce mem_cgroup_calculate_protection_path() which computes emin/elow
> along the root-to-target path only, by iterating through the cgroup
> ancestors array top-down. This avoids the full tree traversal that would
> be needed with mem_cgroup_calculate_protection(), limiting the cost to
> O(depth) per memcg - typically 3-5 levels.
> 
> Call it from shrink_one() for the non-kswapd path so that each memcg
> about to be shrunk has correct protection values.
> 
> Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>

With Barry's two points of feedback (changelog and comment),

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

