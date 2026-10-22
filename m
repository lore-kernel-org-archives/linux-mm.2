Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F417F606A322
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 03:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=ZkSZW56g
Received: by kanga.kvack.org (Postfix)
	id EDA786B029D; Wed, 21 Oct 2026 23:56:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E63826B029F; Wed, 21 Oct 2026 23:56:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D54D56B02A5; Wed, 21 Oct 2026 23:56:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9D84A6B029D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:56:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 71FB5C0735
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 03:56:25 +0000 (UTC)
X-FDA: 85348899930.05.5960D94
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8F6A840008
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 03:56:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ZkSZW56g;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792641383;
	b=4qAWzT7F8f3hD/JJE7aT/GYem7mUSIQINr+K5wWcsWLbaxsELh3LLYzjXQQb2jRIszTDAJ
	PZIgL6u5OcBI3zrmDGR3w+Ik4i7AsoaeIocPZ2DygvOFQerwNyO8eBYvff7NCWG7Daxzn/
	dG1qC72HZp7v/3ToFK8LbRZMib8d+6o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ZkSZW56g;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792641383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nBJVMizSkP5mIMubRGP9eWHn8SLS+RX8waQiqIH32K4=;
	b=Y0ntHIPMH0AQ9XO2Ky6XgqTrsr0UTv1WpNNwoSKoOKxXAL82z9aHD9p9SVSjegNl3BC1iO
	Xw3ckZN3aD1tjTiQpgasotI37YhUvGnJujHLGkwfCmmrSQrVFcSzrhpnsMtwnPzuCPTKDU
	s+IBfjuA0pzpCEbz2S4xyadxGofGytU=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-93f1ca4132bso138209685a.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792641383; x=1793246183; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=nBJVMizSkP5mIMubRGP9eWHn8SLS+RX8waQiqIH32K4=;
        b=ZkSZW56gQp2PcVtc8E1pUPKeLeGr5qPPOdihhmFfxFwvPXpwhGcaxFPdUWdH+3hmyM
         eQrA7GGjLP961N4FHWI4EHL5Dt5lQEBm5o3xGrssTjs0VzCAZqNZ3oqg7+Ri9wFTqQx3
         HCeYPc0On1bO76hLGdikdmecWB35VrSe2tiSoS+ZXJVkjnvDpGPGYGLKTHysk6LSsU7V
         joT3AZswLhYEfjpWAW7hssMitqoEsPrtTKIysZ/HddW7QL8/DK+5u0LUpP4PN5Uve6kJ
         5wGtjftfvavXw3CrW05W6UCCyIAKP8YhO6XxsjwLjFCEQyxAsBK6WmM3CCkK+RwHI9Lx
         bDRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792641383; x=1793246183;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nBJVMizSkP5mIMubRGP9eWHn8SLS+RX8waQiqIH32K4=;
        b=V5AuWl5NQYzCi5Z9NuTvY8dk9P/zOClxlf/kLzemk45B2HW++jXWTA6fx2bFVr90om
         PRmMsZJbS5+DC8ylXf03yuk16HdEU94fwxRC7YxyMuzEHgUAuA2fBhYmkEXBuhBYKMpl
         pzhMBbDcVc32fgExqiU8Za1daT6x61kKySyYDsEz7hyfj2VW+ssaBakmmjHpLBAq1Zk2
         TMA8bL8NgE+ozkB5kTZS3dm8HQLTARlYlpUwpo7bs2vguBA1lR/jSfokXpRpwNrH8Yi9
         xTnq8U6srMqqYQe9MJEWWeqS6ScirirjhK0iTIzE3e0fMUIOqmoLQBLc9TVLnmSKRGKO
         umQw==
X-Forwarded-Encrypted: i=1; AKwUvBz/4N8mREuHTcFFUuxNHD5xCQT5eVNmit5Qk9bQB02HQ8KyYTPq7QJsnR9VMRr5+JdLTi6RPP4X1A==@kvack.org
X-Gm-Message-State: AFq9FYI9hR/q/jNc3ErrBvV8k8Or/47C6yFt7xBDKY3a6nLziqvOLEzn
	7K9S9ZJ1fC+CF+YXaBsbqVQabMqcNjZxcjTUFKSXtOi2SRktNaAaGtjKW0+wxZP5xaQ=
X-Gm-Gg: AYBFou2Ou94lgbPxJvexaRo22w3+rXsiACLVtoSyfvRMffaglek86iHnv/e38MAxU4g
	e3D67+NkWyYRQJNPbA2YVoICU3wW1n/BuWe5oaJK17Uy6TSv9w45C0zFX74gENvJyFmFyNPJkeQ
	4RVL/o/qIA4uL1se7GMi0marQI/t+dtoWa9yvnWjktGlZmiWiA99PQC7oalr9qjcJl2gxrac+SR
	kpS2bYjfRQItIFpXB7WQ9BBT1t90mb7gM99lUj5QAnx/1kBhbmR4MC+KIxYkMZG5snrYK75X0Bf
	Kku1vRjs1xFNJddPwHuqtCCuscAU9jMMFVWnv2Kxz6yEOZZNXnXIq3Sc7IgRyaG8wFbTpdYMBQZ
	mBYQpuOtaehb5ynBVMcH7DRcuvj+K0YL5p9zS8piAu7uvsYh829W0CkdHHHqDQO7FuF6+ls8bi6
	/3Rd3YthvdT5OF1zaVqmbJYr2R54vQ+YXS+4ow8hecEMbfrAYCm0NlT73ymothJENCkcT6Wdoqz
	IO+ny9O8cmadSQyn1yGIRJaIEL1xayicmjlKaV0xYOl39dL+Bcal2IOlxHowl8veqZOqLj3EJ3y
	4sSQJtXutP7PUbBuCBkEYziUrQI=
X-Received: by 2002:a05:620a:6f9a:20b0:93f:6182:53d with SMTP id af79cd13be357-93f618206b2mr208635085a.3.1792641382767;
        Wed, 21 Oct 2026 20:56:22 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56d9a495sm423380985a.13.2026.10.21.20.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 20:56:22 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC 0/2] mm: add source selectors to memory.reclaim
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: Gregory Price <gourry@gourry.net>, akpm@linux-foundation.org, 
 david@kernel.org, ziy@nvidia.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
 ying.huang@linux.alibaba.com, ljs@kernel.org, mhocko@suse.com, 
 muchun.song@linux.dev, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
 weixugc@google.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <30457046-a662-4ff7-a6a8-100398d7a806@bytedance.com>
References: <20261019141401.11927-1-lizhe.67@bytedance.com>
 <atY-LD2AzCYATRii@gourry-fedora-PF4VCD3F>
 <30457046-a662-4ff7-a6a8-100398d7a806@bytedance.com>
Date: Wed, 21 Oct 2026 23:56:20 -0400
Message-Id: <179264138036.2549665.17429111144570830454.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: 8F6A840008
X-Stat-Signature: m76jzmpmksb6nau8343rb3ytrcsi8mhu
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792641383-51990
X-HE-Meta: U2FsdGVkX19U44mRDE61dS50r6lK0O6xHWTb9n/2fPueB+A/cxoNdagsAWq7UTXeMLrsCE21/fHWrZKxp6EXfwQSJnhtIGDCX21kQv0JvWa7uh1CYFCrgg89viZ2SbZXtNYGqm3+FGhRlH/cB6jctQHNzTJQgTFMKnE73ZceORPhj7+5V9ylTzFDyUIs33jCNFDQnKfZN5qc4SkDGsgd597SgMWB00uO/JIOlERV7cvkdSN9ddAI5Mf8cH3Soq/jcbXF/LULE5trtxsvKDiulmfH/39rkiOCVM9Ghh9jjZ2ZMRHTEzX40UzllvyQLNmwRWJV+UGi3pSd8KFfvLLkhDoPSUrZl9LpFmIIOxIV0GzCnM0TLUyS0J6nrDMEUZEzlCKPwEU4Rlpoykn1CjpbYJFB5g1xMjPV0CeI2sept0a4Q9S4j11l4fkAljsq+zXDKkmQtGosz7IDBbJto3nP/W1nzENnPWjIbaYTL8l9Kxj7L/dNP9nEVdBO1HTwJgHUHMjcWFxyHYXJqy4N4sNN+KsbTPKpOwswP43AKoAJb6/Shb1EmMwUPNhr7FMIx/oa0/KdxzNPz3WuXkMyZNP944EJJ+FZAC9aNSHmQ/Pc67WhGaR7JdUax89U5CHXlMSpUB1WOTXJKIXOmREYztTIkqBB5TCfFst9LTbY+NTO+09sc8vp+DGXK3mr+o4Q7suRJi4seqWZYHmxrzy3Qg7eYYSe0qtRGtrEAuzBXv3lc/o3tMsUT1dls9+rI251Azb6g6MvKnEn/IfHzEI+GkhKD/RCYFj71QAZCBTFmANheBTJ9gK02v1McdTc67celBGojAXO3oRIInCAWulhNtuhdHvW2C/qPQvurGwf6haErsu2+zdbshX8AbE17lCm2dcAFueHHjLVlF/2IZTkXBjwvVrOFGLy2iDE3LEmckeqSikZ1iGtquiFxKglzaD+qS3VBwNt4/WO1BZPi4+o6Kp
 of1cgOeZ
 nLiM/ig+jDRjo3MZxqfkCJc1paj1FwUbUSbPydFVU1JR8HG2/9skMxJTKomn5NVxpy60Oz38qDcWk63wb9sr3BnUTLXRiixl8aVdLrzdWEDD4pww8Vt5aQrCRoTTMDQSuKeE2aK39kRobmCcN2azG8+aY4O5TNrM3bnND+FAkV4x6laiEksEF14i83EAoNJJwRhkz/6lIAYtB7pUW6Q0XJqpkl6NRzrfzuhzFExBpSj4tmJNDBTebWYU2WMh+JhaXGi5ND9bp/aYIwL7l48nqG/o2caQwOkGetzkkzI/WXzeM0c4hUcoBx8UNHoufbbSJyBMQPqf1ARBZBVk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-20 21:01 +0800, Li Zhe wrote:
> On 10/20/26 12:10 AM, Gregory Price wrote:
> 
> I agree that the kernel reclaim and demotion behavior still has room for
> improvement, and the watermark changes and the bottom-up proactive/async
> reclaim idea you mentioned may be useful to explore for some tiering
> scenarios. But I think there is also an unavoidable userspace policy
> component here. The kernel can improve whole-cgroup reclaim, but it
> cannot know every controller's placement goal.
> 
> For example, one controller may want to keep a specific per-tier
> resident ratio for a cgroup. Another use case, as Joshua pointed out in
> another reply, is reclaiming from a lower tier first so that later
> top-tier reclaim has room for demotion. A single default memory.reclaim
> algorithm cannot express these per-cgroup policy choices.
> 

The latter of these should probably be some level of the system default,
that's why I brought it up as well.  (proactive reclaim should prefer to
make progress from the coldest tier first, then work its way up).

I'm not convinced a reclaim interface is the right way to affect a
per-tier resident ratio policy.  That feels like a hack to get around
solving the harder problem of something like tiered memcg counters
(which would otherwise drive reclaim to work exactly the way you
describe for resident ratios).

> I am not sure whether changing the default whole-cgroup reclaim behavior
> in this direction could affect existing userspace dependencies. In the
> old nodes= discussion, Mina mentioned that Meta's reclaim stack relied on
> memory.reclaim triggering demotion [1].
>

Yes and on its surface this is something I could see Meta using, however
I question whether we're simply trying to find a convenient way around
fixing reclaim to do the right thing (not invert the LRU, apply per-tier
memcg limits, etc).

> I also do not intend source= to lock in current reclaim implementation
> details. It should stay consistent with the current design: source= only
> selects the resident source to which reclaim pressure is applied, while
> the kernel remains free to change the reclaim policy.
>

Well, sort of, you get exposed to the implementation details by having
to negotiate what is considered progress under different scenarios.

Lets take one example - what should happen when:
 - 2 node system, node0=DRAM, node1=CXL
 - zswap is configured
 - echo 1G source=nodelist:1 > memory.reclaim
 - node 1 is pressured, zsmalloc falls back to node0 to allocate

Should that be considered progress? We reclaimed from node1, but
increased pressure on node0 - which might have kicked kswapd or memcg
accounting to demote memory from node0 to node1.

Should zswap also take that nodelist as a constraint?

At the very least i think you need to add details in your cover that
demonstrates the process of doing something like per-node resident
ratios, and show that it works as you intend.

-- 
~Gregory


