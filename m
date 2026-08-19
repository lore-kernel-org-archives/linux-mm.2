Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68591C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 03:46:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7A2B6B008C; Tue, 18 Aug 2026 23:46:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2B0D6B0092; Tue, 18 Aug 2026 23:46:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1AB96B0093; Tue, 18 Aug 2026 23:46:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 941776B008C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 23:46:56 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1A9C21A0468
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:46:56 +0000 (UTC)
X-FDA: 85116632832.28.7E49F2C
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 48F99180003
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:46:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nbn87eui;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.172 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787111214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wnMZaxIAAqG9Z6waMDFWf6/fX7Qd0skMNVzaHv1c1+U=;
	b=vvDfxfa0NaSp/JBFnp3lAS3aWKV1A9XmJfsqptR/gLjoL3QuopWbR4OSiPQbxwN77LRHOx
	y67lZiceJsJAeMdRZc3uoYS/suwSTWPkL8WIudPRZeRd17kWVtbjBTT28FBGDlIooOuEZC
	egn2x3QVpZaipe1e5Y29ye0Gcckc5mg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nbn87eui;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.172 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787111214;
	b=mstLzMLkDe7F/OxScZCfLu/JLYCqsLGc4MCH0peagYue14ijHnYBv965lc0CPH9WcSPK/B
	l9qiIjtJROF+tr+/EPrZqgvMjHO6zoGyN7Ea07UxYYP67r5SxTJ9G8yxCfv8SKscLw0Frk
	qs3goX3MND7v5wFr9bY4IpMRFFPTQV4=
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-497e6956acfso321791b6e.1
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 20:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787111213; x=1787716013; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wnMZaxIAAqG9Z6waMDFWf6/fX7Qd0skMNVzaHv1c1+U=;
        b=nbn87euiI+06I7ZuOskbejCS86Ic0X7gIOH4jkz2VkyBWJT5o8IaMsia4oinzxOHSp
         NBoAAZyLZSacGbXttziOPiSiW4gRDmmWWSrCn3L5IpDcuRcUErdqjC2tFpRv5MMkGdZj
         0BwIZQeslF9QufkF8zgCCAJtWHcvO6+nZ9K2gM7Z4eJHFxfl3ytHyaJd+41I8mOyPIUw
         OvRe8bCP3EsQ+/j5lYXBHGn1nbb8NuALLI9ZcbDHY3tBI3HvjqfQJQ1+kki1FQk4RpWB
         Q/90ZMnEJpvZaUVr1eiHb+LmNJw2wfTW6mJSuE1hIAzem/i6DkvDOynz0+yfcOubQoKO
         nyYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787111213; x=1787716013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wnMZaxIAAqG9Z6waMDFWf6/fX7Qd0skMNVzaHv1c1+U=;
        b=idi58degPV1UKtCfBVow/NBJfdzgvmfFhz/w4g0JCaVygj7M1IwRO1bcEM6T0w1G6u
         7uQ+GtFXJCtLloIxhAfK+6YBzVbtIg/DSfzs/HqlH67U/dZwlUGE50Vc9RcM/kOudHF9
         LEk55XzDkcGU6JXRJeWHcm5RexY2677d0nij1ruYp4xzKoEJ2ZMtjXg8ZESDPW36ZuIO
         d9+5doQDTlUy7KMoOZtqAXdgdp0c34yCyZkaygwW4OFatT5XWEpkqfRmiMs1kHy353Lq
         gm4h5jIUsNGunIswCaHwY2haSS4LESltHf3JyXn7MEVk1+0sr26QgBRI8mZtFes65KoJ
         U7fg==
X-Forwarded-Encrypted: i=1; AHgh+RrXSMZ8m0xm7rZH/tOXNnQUEWamf1p6uD6j9uxSCQoUYS9s2OhLNHPt2cJBxwTN6Ynr7SzrqQJRug==@kvack.org
X-Gm-Message-State: AOJu0Yzi5im+VbsYTtiwY88YqePli5tDNxPzOjEWhWlF1yb5Ii5+gDKP
	p2bFiUeFM4dA7P5pX4iThlkBDRz3k2nPEPryL358wZR9WV8gdXu1A35l
X-Gm-Gg: AR+sD13X4ypTIq8ZEpDTeKobE4Gmc0rYJRmRAzBuN0t96hvEnxtxxnr//DXuSTeqps0
	ZaiytofGx6HzZsOgm8Dnb/yemoNNBUQM5TMetWKIOJMhiaLKu8TO1Jhe2MYw3kT4dL3CuVs+Ofe
	sKzo/ILCsi4UKIrw0Qv6pEiYACSl1aTrxj3Cy6HjclYqPNwAp39diMLIjYN91yH4mdX2EfMihIM
	HnRYhCirA0waCz+f8C5D9JKBzAg8ftNV1mLaAvd/icrcmTWvmp6G43uWzYKK2gER0H78EH5Lr1b
	KTcoGkH3PWdFIxf/JGOm1yLTY+vaWQ0MdjnWSnpRct2QUDYjW5MDHlTunVNa8KRkH45pimHUavy
	ctg9r/ltIxvUWnjbSdRYIp+Y5ZvSIV4L8BAeFbhWH1BeOefVaBU7HO6UO75FQ0lpFKjIMTEMMDh
	A/52RG1OLSXuDTjbcquEV0tCVhmAxndqHkG60ux1orZ8w56CB85MJWtjy5qhXpI8L+wPhhFi9It
	pQZW5VbKxXYws60OPM=
X-Received: by 2002:a05:6808:d54:b0:4b2:9bf4:ae15 with SMTP id 5614622812f47-4b2baa4ad0amr1628346b6e.11.1787111212097;
        Tue, 18 Aug 2026 20:46:52 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:49::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b2960493ebsm4717715b6e.11.2026.08.18.20.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 20:46:51 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Song Hu <husong@kylinos.cn>
Cc: joshua.hahnjy@gmail.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	bsegall@google.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	david@kernel.org,
	dietmar.eggemann@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	harry@kernel.org,
	jackmanb@google.com,
	juri.lelli@redhat.com,
	kasong@tencent.com,
	kernel-team@meta.com,
	kprateek.nayak@amd.com,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matthew.brost@intel.com,
	mgorman@suse.de,
	mhocko@kernel.org,
	mhocko@suse.com,
	mingo@redhat.com,
	muchun.song@linux.dev,
	peterz@infradead.org,
	qi.zheng@linux.dev,
	rakie.kim@sk.com,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	rostedt@goodmis.org,
	rppt@kernel.org,
	shakeel.butt@linux.dev,
	surenb@google.com,
	tjmercier@google.com,
	vbabka@kernel.org,
	vincent.guittot@linaro.org,
	vschneid@redhat.com,
	weixugc@google.com,
	ying.huang@linux.alibaba.com,
	yosry@kernel.org,
	yuanchu@google.com,
	ziy@nvidia.com
Subject: Re: [RFC PATCH v3 09/14] mm/memcontrol: Make memory.high tier-aware
Date: Tue, 18 Aug 2026 20:46:49 -0700
Message-ID: <20260819034650.708665-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260818012115.65838-1-husong@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 48F99180003
X-Stat-Signature: m6mdrujcs8uy1mj371k843r4m43is6ik
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787111214-717283
X-HE-Meta: U2FsdGVkX18//WLf4H+OKWnwRmQiHSE8uTNKOflSErbntpXrq791XT1TO4Mt5Z1fVxFtCCB5hb0WZIyuZIy5YZAPpMkKU4mSl1EuBLyW8YUD83v6WIoqX0h188FrStGp2aw4vMKyq+HFuMs/MhOnkBOqdrjDTCeXkto/mPO6Chf2x3hW+G66mlxP/PJH3Db8YV4QZZpos9xCMLlIJFV5TjQDFLgl1PQFgMQbIm5E4yMwYm6ZPAHlRaOOpXScMX4hE+1je5dfptuQffd7te/quL13o3vkj9Alyh1KBkFBW4wDCvrSqJNIxOJ4ExnXEWosG0Wdnjafny6Ch3aecplE06th4wq1sBKkLIncWw/CzSfJQZPrmTpYhqGyTlNkCa4B2CysdLARMA8VDmVsgvvhdNg4C3SEC/S2MTfSs5/7HLkCCiIBtWCxdYmROpl5fT4SJ9nig9Ur+4s49+YFI6jG423eaKj+vpwKtFPsUHTTWP4AKmXkk5ZFc1Tt5fX5SUohTdgmNlKk355q0st27UK8Z7dX/syFQ2rV36EjR06iHRkIaZTja733Y7oOXw7DxjQCVAiECVDm71ms/sdjGOEJllslodZtXD2allCQmSvXuIGAWii0atv6pQWxSCUj3hqkpN0Hu4UFQViqQzQgETfMoSHkZdYAKKK2mmmegRJ6kdp0zaScMsJz5dKJvAhbmcDPSF53zK0SeW3XFrcseZb/L/Ph3d+L8KmV8ZuYSiEEyvcqbMgc3DnrsjUR256qO6DYONFuHcS9YjYhH9hn1LqwCWmxLYVe8293WchSN2XJFMo1RF/Y8NqX4zlAeM+oyWc0YdKf2b89AHFv9iGAB0Hu1ilhRsUAjKpxTSc7RKqpQq50RVluwCvWGbWP62I8wdV77e7NUlJah3YOdCpUiitymGrcd+dv1lckNN3sFq+3qFYru/tvJh5dwo1W6oRKXje9UIYRaOVRYafOgfadYpO
 sdV9UoGb
 YCn1dk+v3J6x2Tge4JYH0ix2/Le/21gJm15UrzM3+HFqYWPDDa4TuJ7opn4nWH3pyPiv+hktNXMvCkye4qP4BQibe8pkfFKKFeM9WQGMgMaXLzoHQfguAKe2rQxpCL43bjnx3HrdWEgoIKMNo97nH52yW87wKScrvR/8YSJXz387AnzIsQXuKGOxrMcWvatoIkphBSiDyjYoxwTeid+mbdcm/wqnrcKWDeUk7lHf+fyHU7z+1JvWC36MWmbhj+/EzmZKy1e19X9xlKc4OEok71ucfSxHLmdS37IvRM9kRwyX+iws7poA5Ik5NeZnQIec2ACDwJ3xrpPGysIaM92/RKM90hGZBje6eK7q1k0DsTsGwySYkww0eLGPFaRJ9zMsxhKtTFVNIpzjN3Ey6JJClP6kHgK3biGN6Wf5KirUTDM0DEg558i/2/XUp9Ku7UsGd3dYPR/doVCe0qYs0uRab8vdG2Ufju9/1dUgogrJkgXXev9VfFKUVrnwDDWJkHDH+oDks5FFc3TyktHmBR15DZzwZnhdt7UlcMtjUBMaMyR7o/O3IIAdpB3D3Nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Aug 2026 09:21:15 +0800 Song Hu <husong@kylinos.cn> wrote:

Hi Song, thank you for your reply.

> (pre-existing, not from this series - mentioning it here because
> it reworks memory.high behaviour)
> 
> The penalty computation in calculate_high_delay() can overflow:
> 
> 	penalty_jiffies = max_overage * max_overage * HZ;
> 
> max_overage is a fixed-point relative overage:
> calculate_overage() returns (usage - high) << 20 / high, so the
> square times HZ wraps once (usage - high) / high reaches
> 4096 / sqrt(HZ).  That is roughly 130x at HZ=1000 and 259x at
> HZ=250 - reachable when memory.high is tightened far below the
> current usage of a large working set.
> 
> Most wrapped values are still caught by the 2s clamp in
> mem_cgroup_handle_over_high(), but residues below the clamp pass
> through, and some of them produce far less throttling than
> intended - down to no sleep at all.
> 
> check_mul_overflow() with a clamp would saturate the penalty
> instead of wrapping it.  Could be folded in while memory.high is
> being reworked, or a standalone fix.

I think this could be a real concern, but I'm not sure that my series
is the right place to fold this change in. Namely because I don't
touch the penalty_jiffies / throttling part at all.

Maybe a standalone fix could be worth it? : -) I have no plans at the
moment so please feel free to take a crack at it if you think it's
a good idea!
Joshua

