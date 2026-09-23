Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C900BC9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 17:15:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D75526B0093; Wed, 23 Sep 2026 13:15:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D262A6B0095; Wed, 23 Sep 2026 13:15:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C63796B0096; Wed, 23 Sep 2026 13:15:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D3FE6B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:15:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 33F2E16088E
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:15:23 +0000 (UTC)
X-FDA: 85245678126.01.7CFE7D8
Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	by imf20.hostedemail.com (Postfix) with ESMTP id F33C61C0003
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:15:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=E2QyjR0N;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.140 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790183721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FNQHNSKZkECfWRp+ScI6OE+kyYlP/vtiU1JMeWIOhRQ=;
	b=O2mhBBsIljcW9o/Q6UwA1Uxgu4wvNvNPVa2bHgMGF+ZMv6UHp9KnYwnBhNh3MAzugMxcvJ
	YB2i5FAUaGBP9R/Kd2QgWXEnjalrzcy+fC3AsXgiQDXz9SnVEYMDfkoeI5fHgvtR/iui3+
	0aFHBCZJd6R6/O/fB8Z4oRGg4yEM8U8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=E2QyjR0N;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.140 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790183721;
	b=dQDTfvCaSwqV3xdMhbgWhghR+bgTODW+9kUXqagGkwFahaagabJ0DE7EzflIo3oDb+ZZAk
	GPvUHOU4kCdHQsTAQyY3jpHJ9RxxV7ALD37dkUa1GcaPxTgjZT6WB7MKzxtP28e9w1tSIr
	hItfN3JM/5ekWEc4wbPR9uLKiF2+260=
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-66e4ab201ebso1179598d50.3
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1790183720; x=1790788520; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FNQHNSKZkECfWRp+ScI6OE+kyYlP/vtiU1JMeWIOhRQ=;
        b=E2QyjR0Nd+LePChc7QnyXWe19shUJCEjQKxRPI/gSnftbCl9+yWpwN9L8T2w7p+Dsf
         99ZMWnigE2PPkBL39Sw0YuqHl3442ugjGhZ/2OCXLsR7V0v2a5vNc5yvvsgDIdjzSapH
         ykOr7a3+r0kKWbochUCuQtWRfOF1mtlsSMjm7ploCEC1CyO+3tSoqXv+mU/AU7BIeOw1
         KUQ+HtRG9RSIJgG/4jLJjLAcHkywKfWnxV3JdZasmvxMumr9CWqWzfCWTjJljYzr3+Zh
         DnxCyK1BSItxFFLg17ZTobw2R/SMBcnFupYVhDm9Ep0Y35FsvNVC43thO+hrAXyChUKH
         e8oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790183720; x=1790788520;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FNQHNSKZkECfWRp+ScI6OE+kyYlP/vtiU1JMeWIOhRQ=;
        b=ZiCXhd/nHSbow8yB1wi2WEhDO7ia3RBIiK/7XxFKCNKjUhbS2pBOWn8vCLpy2em7yQ
         mkPU82SuRCW0o5CExBgTiinu9zJoEqZyJh+pEi0lgqZ44yMvhxZk5MUwwilICKdgfWwj
         3Gz82CGeI0jDSxlZCVghSW84P09aT9g4M5nOZKvKnNbfFZYPjhOzs/pvTMcJt/v21C6w
         XrFvdMycTzPTasuK45+734IwaE4cf/VZZ4DwU261GJ4gq23WhiKDOts3db815KPN4o3A
         yRhgXJWz0IIEwaOWsXZK9mu5Pu5puQe9q/QVFkully5gl1JrTQ9qdC3nAP2LHwLi1eAI
         v0zA==
X-Forwarded-Encrypted: i=1; AKwUvBxpD6JxJRqbrPGDazIdRxExNAZvAPUhIczO9WQm18+yNmVwSJCfVgVwIgt4r78vJkEXoAMqw4esDA==@kvack.org
X-Gm-Message-State: AFuF++nZEfyNmrAXGPJFXA41kNKImEbZi3kOVYQYfMhGaol2xNCL/gwQ
	CyHuo4Ecu+JvDtUlcIFHkqG4pN9aoiBqBsg5Y7ECkXSP9/DJ8oPk7/e7ZqAL/7pai04YTdqmMkS
	4qtZq
X-Gm-Gg: AYBFou3HnUQOa71riqk+l6sEZFCLEH6OjxV/uO8UufjbOJtVSp+Hd/N7PS+wjCfQ2o0
	YxdMDHD9IjrqFPNsrbB2TAExFLjsO97ZZRC52JIO2xPqiJV2BPlT1DH4LEUzXJOTDji0lth3irN
	gya2hKU3pgwtbuTJk1vRH3Kan0wFBFzWIx0OXdARnWEvV4cLPWNw/UHvzydafLKr+UgsCVWB+8f
	Us3L7KUX7wjChfMTbANCHuvXQIlySDVqzTP67/zmM3ZwYEb3Fc9GOCo5q1kk09ZurPfCfwLM2Pj
	KvZ8bpceNSon+OrD7eaReGNyVecMSSbExp4i0OzqjG4wxDWZCYe9Vd2AegwBEHOFXa2zyw9tH+k
	pD9taD1AYJDEenAryyptxTyDzNhMMvko0VVDvkbJbOwvfoQaR484/04qk5k0q/dFh+sG6qXw2XI
	iyQoAeIawIO/3FVDP8Uz2SdpKtnZung/rrq7TltJpyiJGi2zwd1oISfo3TWzBVK5Uj8KFuNQ==
X-Received: by 2002:a05:690e:d51:b0:671:2519:a915 with SMTP id 956f58d0204a3-672d57b43bfmr1318283d50.59.1790183719867;
        Wed, 23 Sep 2026 10:15:19 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9140c482cb4sm24670056d6.49.2026.09.23.10.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 10:15:18 -0700 (PDT)
Date: Wed, 23 Sep 2026 13:15:14 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Youngjun Park <her0gyugyu@gmail.com>
Cc: Youngjun Park <youngjun.park@lge.com>, akpm@linux-foundation.org,
	chrisl@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, kasong@tencent.com, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	baoquan.he@linux.dev, baohua@kernel.org, yosry@kernel.org,
	joshua.hahnjy@gmail.com, taejoon.song@lge.com, lianux.mm@gmail.com
Subject: Re: [RFC PATCH v11 0/4] mm/swap: priority-based swap tiers with
 per-cgroup selection
Message-ID: <arQJIjzE0BlUg0CV@cmpxchg.org>
References: <20260916183437.2946306-1-youngjun.park@lge.com>
 <20260916200434.GA5784@cmpxchg.org>
 <arAHu_BD5oqpZJER@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arAHu_BD5oqpZJER@gmail.com>
X-Stat-Signature: 1szi13y8ciw6w1317gapfwct98ppqgnk
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F33C61C0003
X-HE-Tag: 1790183720-321996
X-HE-Meta: U2FsdGVkX1+djznJQ5k0x99yxhHfj/BDQ6bmxoVjk8i5e5qXDL3a/a2N528LWANJ4jQKUS0tWVb655AEO27YmsSL0yi5yIkGaZO2kiPE149iBTwm52J3RnISDjjbATCGI1o8jg5j0sq0Dxe75iKVMk0qHFII/1rl743DejStZXOd9OoA/i+pjwgt/6a5jb3+Lxu2GLPOoPhnb41CWPL4ohPRoZ9GTrQ/knvXyOO3ThEcVh9d27i0i8kDcLmX8s4L/xFB8bsUhpwEI4RAal/8BiIHexAOPLQocRCV2g/MWE48PALg3Vb9I58h4QQniYApVfIOL45WkgtVDl4+43k/QHXWwkhSaDv/fORZ1I5Ycp+daHh/qIqj2ulolvYzlN4Ln6YDPPPGgUnf2MWw+xhjSjNetB+hwmv64lnXKY9mKx7IFe/5UP1eKPHczGjbSXeDfV+ha3MqQA0gMuNZ1Pdn0pVE3f/qQs3GTe/MU0vnqXCaZYcHVSHh7PyfxGTQ011/Vq0M4EnaA6gL91S4OtV+Soch6Wpni3Y497l/o2PBT61qvzeNACKa9QO9J6t89BeuxfOumeiasC1Z9hQlCEoFfgowLqt40obFNJGyIPCykGzSjDov8XuTmfprc2Zp8ci8ZWj9rRaE2r3vzJ8T7RHQNgCDshQ1nSo2oGPLa4zjOrfHWbKjMZ0eFKt189VYW48zb/E6tWUZBnztc0+mgbhIeJ1AJSIW/6nwXJlaCUGR+zZjRkuh6ahHIMEUbrTa/A1mdSDhjQOe/0JnNmxHJW3o03+kiLFsH3/etGx7crOwtYM6tYuWgBQ68ki24gQgBPyLI2+vWBetXu9ToXmZCOflJ8BmeJawFGaBLOehNNwCSXZKGgt+EIuLFKCEOH3eZk+7oJpSAQ0p/Ute/uIR/aBuT62LLjxUTOwe+7veZmfXm7BhU18WjZOVL0+1voB7wG5fhF8TJ4p3WXodoJZiLvA
 I/lKO/DY
 SDvH12hDxOQd0f8iX8FvmEVbaZdNo1YbOXsJn3cwPwrHr80CzhK478xdpngGOhDLwwyAKkWlXsAA5UHjSBaPvxr09rPDIuYq9DrJtjzcezG1TjQsHEQ92OW3vE7AYzXOzMUGop7dP+bTPTONR751LTvXj3e1bQld6fqeSbGnJsX/R+trLUpuYVut7OcAcaI8D06ZlySgnBv178DWhC32w9MAYqJS+tMhLMo8UvLdcTWNefbgLdhecBezkAkyDi4T795TfeW2JuOom3VeOQ9q+nwrqXKpY7TifHs3KUXQPFko+72zAhCWLHLTW+VzL/FbPiS7W9ZSXH8Y+FOwlp2VUBlhVxEAfQFMmrbYQx9n7USJz7RhKTlYLCCX8YdfF7JjYonyzTQDVB6OT6k0qJJ+n8dC5htQ+goDmucVFyLUvTQgAc9uobsV9A0AanRvQH8testpGqZUhagnetYwvC/jeGrVmFBnUCC4WAF78
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 01:20:11AM +0900, Youngjun Park wrote:
> On 2026-09-16 16:04, Johannes Weiner wrote:
> > On Thu, Sep 17, 2026 at 03:34:33AM +0900, Youngjun Park wrote:
> > > Per-cgroup swap in debugfs
> > > ==========================
> > > 
> > > Patches 3 and 4 let a memory cgroup choose its tiers through debugfs.
> > > 
> > >   # swapon -p 100 /dev/nvme0n1p2
> > >   # swapon -p 50 /dev/sdb2
> > >   # cat /sys/kernel/debug/swap/tiers
> > >   Idx   Prio
> > >   0     100
> > >   1     50
> > >   # echo "/batch 0x2" > /sys/kernel/debug/swap/memcg_tiers
> > > 
> > > Bit i of the mask is tier i, so /batch swaps only to sdb2. A tier keeps
> > > its index for its lifetime, so the mask keeps selecting the same tier
> > > across swapon and swapoff.
> >
> 
> Hello Johannes,
> 
> Sorry for the late reply on a good suggestion :)

No worries, and same ^_^

> > Can the cgroup be given a priority limit? That would have pretty
> > obvious inheritance semantics:
> > root
> > `- batch (memory.swap.prio.max = 20)
> >    `- task (memory.swap.prio.max = max)
> >    `- logs (memory.swap.prio.max = 10)
> > `- interactive (memory.swap.prio.max = max)
> >    `- task (memory.swap.prio.max)
> 
> Right, the inheritance is clear and easy to understand, and with this I
> can pre-define the limit without knowing the mask value.
>
> But first, let me check the intent. Is the point that capping batch keeps
> it from taking the faster tiers, so they are left for interactive?

Yes, basically, that's what I tried to express. Interactive has access
to all available capacity. Batch only has access to lower tiers.

> If so, that matches our use case. Latency sensitive workloads get the
> fast tiers, non-latency sensitive ones get the slow tiers. But...
> 
> Even then, the reverse cannot be expressed. A cap only cuts from the top,
> so a latency sensitive workload given max can still fall back to the slow
> tiers once the fast ones fill up. For example,
> 
>   tier0  tier1  tier2  tier3
>     0     10     20     30
> 
> there is no way to say "use tier0 and tier1, but never fall back to tier2
> or tier3". To cover that, the interface would also need a min value, or
> some way to express a range.

Correct, this isn't covered by the above.

> And even a range is not enough. Excluding only tier2 leaves a hole in the
> middle, which no min/max pair can express. That needs per-tier selection,
> which is what the mask,  and what I'd carry over to the memcg
> interface later (Currently memcg.swap.tiers.max).
> 
> How do you think?

I think it could help to aggregate the usecases in the cover
letter. Your cover letter describes how it works, which is great, but
it would be good to understand better what the constraints are, how it
fits in with other existing control surface and broader usage models.

With the above, yes, you can restrict who gets access to the
privileged tiers top down, but not bottom up. Is that an issue? Keep
in mind the alternative is cutting privileged groups OFF from certain
available capacity. This seems somewhat counter-intuitive to me, and
doesn't reflect a clean privilege hierarchy anymore.

If you can think of a good usecase, memory.swap.prio.min would be
certainly a natural extension. But we should get the usecase laid out.

The requirement to punch holes is the one I can relate to least. Why
would a cgroup need access to good tiers and bad tiers, but skip the
middle ones?

This would seem less like tiering/hierarchy and more like flat
per-cgroup swap pools but with obstacles.


