Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12246C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 16:20:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD7A86B0088; Sun, 20 Sep 2026 12:20:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C88536B008A; Sun, 20 Sep 2026 12:20:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B76A76B008C; Sun, 20 Sep 2026 12:20:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8C1C66B0088
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:20:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 524E61204AB
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 16:20:21 +0000 (UTC)
X-FDA: 85234653042.07.F808882
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf06.hostedemail.com (Postfix) with ESMTP id 74EEA180007
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 16:20:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xgi5IAqu;
	spf=pass (imf06.hostedemail.com: domain of her0gyugyu@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789921219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ua2PeUg5BEcfgC5FSR37S5o47FCdmEaQbiS+1Z8zlCM=;
	b=gf1cHJ392oDsWYcLCarxQI5Q+iN6iDCWXGQHxkEYK3m5e/+BSK7EzXfJ74UWEdukyKQEye
	U1nbXBk+b9DSCZd5YrCHMixwPnRs1TifIyEDjptWct+3of89DccNi+KYCm0/ORi7hQm506
	xy34btwrLY4qYMmSrfFSBMI+giyd5WA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xgi5IAqu;
	spf=pass (imf06.hostedemail.com: domain of her0gyugyu@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789921219;
	b=yK7TC7nuuWtqyteVXxiu/b8EuINAdXKps5CLRsY+/O8oGEG+4cedxWG4b3UghdSkgEtWkS
	j1urWYfBFIfI1fFc5wzWUHslWVrr8nCWUALl9aqCFDLZBbA3uxAYg7nGO/vu+58mm87zus
	TJ1+RGQBsff9vStUYrmKfP0KfslQmTA=
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85469d249c6so1929834b3a.1
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 09:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789921218; x=1790526018; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ua2PeUg5BEcfgC5FSR37S5o47FCdmEaQbiS+1Z8zlCM=;
        b=Xgi5IAqucG3zVaQoRtT4OUm6dOzHZ1/34zB73b/zDYKhUCpzIB7hFvXSxKxQivULZK
         G4j44x9QqMUv64ji93kHwOgGc0RHBpKLukGBNlTdIwkkBzm3sZ9PC8pL1ye/rMSWwUl9
         ILOAgQOFvXXhgdGAAJgHr3TZkDfW6J4f67cC30cFVKpw/Cp7/By6AdgU45EkOUypnqgF
         aEvHbzFZgtYTAdf/ARseXDFZSdvhQM/S571VH9KjdptYn8GU9se0sp2v3Kftq0pdqcq5
         v7gllKZ+tJMq2j/AqeqIbVs2Wio0suZokFhsjau50uvhWoTLHKnoWAG89dRau5BgVXQ6
         KF8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789921218; x=1790526018;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ua2PeUg5BEcfgC5FSR37S5o47FCdmEaQbiS+1Z8zlCM=;
        b=tj1ZHnsnBkjyuI+sELH6j9w27t4q3CVps6F8AO6+6QOwLIpfxg6awU/BGKU/tkDQHb
         o//ah7k0ekd1sucsBYH+k3mn/J4bPQ2kqi3OQP/sBuVtrzzLFxoN63AtiXmoHBtw9gcI
         SS2tl+n9t4oAS0mkJZkCwpS6tEP9Y1gOkGYiz15sadcxfx3TzRPxv29YlUtluG5hNWQE
         qSSRxmRv/zBuOrrvrzcHn9dH3UoIhza+6tYrvweV4SJAdVR+4JtITIXW2mPIvoM9W0m2
         T7xeh074smcqNVF83LGFAAca0jqfHzIJ3ceEEmg3Y7FkqTAWPYqWwuyIpvY4NCt1sXhJ
         fACQ==
X-Forwarded-Encrypted: i=1; AKwUvBzW8zMBwhGoYpTgElYj5DSah8X2ZEt2zKrpF4ws5fEOtXbIVhZX9y4Xh9eLXCqVDNpHpq0bEcxiGg==@kvack.org
X-Gm-Message-State: AFuF++n00DRZIfQbdfEMI2JZOTwzbmQ1hNV487afmNVC5GTP482A7r+f
	kU7eadpmncTUvUUKAZiLNAHF0DV6V8SSFTkIOBcffJPb/rGIY2CXiKeF
X-Gm-Gg: AYBFou1CHeZQWJZ5435u70dUj+/xAj3odtfHyMjAefsKcUBXCbb2gUDENfd1DlWNDHh
	+l1OoLNPECQtRpb0izaLj6sqnMA4NSdfHoA0y+BU1/puDYgGtavz9RcmKBC/Tw4vV0gd6Tta8qT
	xBn7vt6Di8Q7+72q9LzQL5YFUg6RDIk/CDIZdjhy0fmQCgkdIMcBlmagkjyI0cd/Ak+K9KNX4Xk
	pZd1AYHZb5vNsBvr3TqfCEbRy7pQxD1Yw42zw78SIyc7q9VuGXkgYfkBsA5naVOJHdp5+W7xoTA
	o6J0jEhJuOaMW4BolxoX3zK55JWL2Gv1D1UhCnauKmB24JRgmlcnf185YgqCtPf/cWstKDL40nY
	tAloShfgWnaK8aNogQqg5W+r6vDDv79ST8yEYKtoy0ZIswBtGbXrVve4ul2J8J3Eor4EovDP9To
	K1cadoC9TX01Rnc6mkHn6zQxP65HOk0IdUJGE2+cN2/DNWq1BAhESYaFmIlGzcQi0a7NkvZMaRX
	Gm80Qv76FGJj015Ghc4mbGCcq9peRDOsLtzaLuKML8=
X-Received: by 2002:a05:6a00:ad89:b0:857:726d:2e99 with SMTP id d2e1a72fcca58-874dd7f8d8cmr12002193b3a.22.1789921218131;
        Sun, 20 Sep 2026 09:20:18 -0700 (PDT)
Received: from gmail.com ([220.85.166.190])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-877aa1099e5sm2093196b3a.49.2026.09.20.09.20.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 09:20:17 -0700 (PDT)
Date: Mon, 21 Sep 2026 01:20:11 +0900
From: Youngjun Park <her0gyugyu@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Youngjun Park <youngjun.park@lge.com>, akpm@linux-foundation.org,
	chrisl@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, kasong@tencent.com, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	baoquan.he@linux.dev, baohua@kernel.org, yosry@kernel.org,
	joshua.hahnjy@gmail.com, taejoon.song@lge.com, lianux.mm@gmail.com
Subject: Re: [RFC PATCH v11 0/4] mm/swap: priority-based swap tiers with
 per-cgroup selection
Message-ID: <arAHu_BD5oqpZJER@gmail.com>
References: <20260916183437.2946306-1-youngjun.park@lge.com>
 <20260916200434.GA5784@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916200434.GA5784@cmpxchg.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 74EEA180007
X-Stat-Signature: p9yknz8rgyuukhr5kijchntcapa4skan
X-Rspam-User: 
X-HE-Tag: 1789921219-996814
X-HE-Meta: U2FsdGVkX19iP5OcqM+Zhq7hlR6koY0FWG5ZkJT9cHdFoueIEgaBKN+5QMwxQiFz/+q45FYdmty1vCutrH5z7ID1wIyLXRn5CwWYTPHcSKBfaJJCP78KoywrjJXQ6A9Ix5QOnXDtJYB5q7Agos8+uY4hDyumKYMZ9nQ80u68NyI46VIXWvwA7FtyiIyhFU9+S3wm3AjXzeXVDNlo0iNYSKhp34ZDfKU/nAxtAy9116Vi1cMHjDkhh67ihWn+PNdvYLvs+j2kRNILCaZcyxdD1OqCuDchXFJC/mm057Yfbt7oTlUB3aH+m7NCryMJDO1DSsGS7KaMHO9bHF3Zf1S5YUkyUlul4KMYk1EqIHke9FKlaH+0dSUjLN2V/VYHyZzWOCbe0V86zHYmj1cXIDcysJjGJQKYMe4N424D/Jmr8FIAI3KUJcET4nQAP9LOIwZj/63YrSPDdQq9CZm5t1jpCgwCfdYgT8vQG2IwBqgUmC+L0ZsaOf6KJAkizGMpAtumuZWMbuMyoTwcIYLfW/M6JwaTM1OdL+MTIAyYCsN+H4Txi/9pL8EzzVAcEyo60sXXNnWhPsijfKMXFacHdHUyQ6rgZmrFHa6d+OhPw/lJhPUtRQVfCPhwIHzuQrpyeTIEBaUoCoovq52ATGjDw4t3FHsHEwDfZrSPnGH3s5GKCahk4XLbMgk2xkoDFVMwQTz6BeA5RbccgNsE/KA9w6uLhpw0qAmlM8W6QjFrBjzaggg4igFCrz8LpF5aouAjncwzxTkw35vJEjUUJxDDyl/ADcXX/lguSR1fGCBjpAYp2A7xOCAmgufYn1k6MactV9E77yaxLPJkm11gs93wRjNWOK96nTa6rPavAM0wBEQetli9+eWVArFiz+Wjf7hcvmI/36A3EwyKPqe2Pn4F/Mi5TVRbcWEzAgAQFkX3rJAoU4G6/kR8LtDxXXbNRmhQBhC3/0aqsNInBgW8XH/qDOb
 rUm/g0ie
 yebC8KluXbZc7SWne+VziMlfIAM4pjFQJL5QdS1u3gLPDORgyJDZ2AefAKu8fWGJs3GSOqB4zAVVJ4RYjH3REvHcJormiMURvFFxS2wQtnKY2hMIczZ+JwfJmiHeR/nIoEzv4/9NUn+AlAaYnNSo9wmQ1CkRMbwQG1KQ7HcrkFHSg0kZIa7DiSP1dhdTPfM/mGohB5Ci277ethBQ48DoftaofIuXWLhrBBCtVpYXSkhMwspMrgqfBG2FC9HIwesFJCVk+e9fnFDFgQoHDzgHT2x0GxUU1eZkhnq+eX1lybpxFtEjJCcjlr2I6Rq96EokYOKf5LCs/gr5Y2CR2lXYBEKAqBE1dGFwtYvEpedma6bHRlRB+1aSW4ibxOMN4S8R5KD0r37XaRQcNsiao12mulXPmteBStvrFwQQ7lfqfHLLIvPsflnYSZqeugzjKdPqFyXJfgcmgaP7ZdJ2nwNxEaQVzfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-16 16:04, Johannes Weiner wrote:
> On Thu, Sep 17, 2026 at 03:34:33AM +0900, Youngjun Park wrote:
> > Per-cgroup swap in debugfs
> > ==========================
> > 
> > Patches 3 and 4 let a memory cgroup choose its tiers through debugfs.
> > 
> >   # swapon -p 100 /dev/nvme0n1p2
> >   # swapon -p 50 /dev/sdb2
> >   # cat /sys/kernel/debug/swap/tiers
> >   Idx   Prio
> >   0     100
> >   1     50
> >   # echo "/batch 0x2" > /sys/kernel/debug/swap/memcg_tiers
> > 
> > Bit i of the mask is tier i, so /batch swaps only to sdb2. A tier keeps
> > its index for its lifetime, so the mask keeps selecting the same tier
> > across swapon and swapoff.
>

Hello Johannes,

Sorry for the late reply on a good suggestion :)

> Can the cgroup be given a priority limit? That would have pretty
> obvious inheritance semantics:
> root
> `- batch (memory.swap.prio.max = 20)
>    `- task (memory.swap.prio.max = max)
>    `- logs (memory.swap.prio.max = 10)
> `- interactive (memory.swap.prio.max = max)
>    `- task (memory.swap.prio.max)

Right, the inheritance is clear and easy to understand, and with this I
can pre-define the limit without knowing the mask value.

But first, let me check the intent. Is the point that capping batch keeps
it from taking the faster tiers, so they are left for interactive?

If so, that matches our use case. Latency sensitive workloads get the
fast tiers, non-latency sensitive ones get the slow tiers. But...

Even then, the reverse cannot be expressed. A cap only cuts from the top,
so a latency sensitive workload given max can still fall back to the slow
tiers once the fast ones fill up. For example,

  tier0  tier1  tier2  tier3
    0     10     20     30

there is no way to say "use tier0 and tier1, but never fall back to tier2
or tier3". To cover that, the interface would also need a min value, or
some way to express a range.

And even a range is not enough. Excluding only tier2 leaves a hole in the
middle, which no min/max pair can express. That needs per-tier selection,
which is what the mask,  and what I'd carry over to the memcg
interface later (Currently memcg.swap.tiers.max).

How do you think?

Thanks!
Youngjun Park

