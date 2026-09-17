Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 812B8C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:39:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 798776B00BE; Thu, 17 Sep 2026 12:39:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7497D6B00BF; Thu, 17 Sep 2026 12:39:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 639416B00C0; Thu, 17 Sep 2026 12:39:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 446746B00BE
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:39:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 39EA6A471B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:39:28 +0000 (UTC)
X-FDA: 85223814816.02.81F70B8
Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3FBCA20005
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:39:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=f9CvWf5U;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.235 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789663166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KAunQ0cM3aakk3XhlasjaszZbs3F0O3wQSsFDCWQw2s=;
	b=b8r/HAlljRGuYV640XYWfs0voVJrFZgMFvY/nnv3KcXcU8uvdSMQEbP+0SRoCXUllIFJ3m
	OpvRDpvpkbNAJQh16Ps8VLo5Yh5g1Qr+kHwMcxmTyVBeHhj+EL1nEjjlCZQ8+ZQB+aRjQY
	yFnrbH3Kgs8baHB/ar/EhiGyDGMOCNM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789663166;
	b=7Al2VzMGQZAmYPnjvGbCLIhKZMXIS932lurYeVfG7Kw1HO8+f0WNMcU1cCaHc2IuMWnPAf
	R5wMGJ6Y5hZ61D4aEMyWZyrg4ZATiPylMMYmU5tOdH3UlgfpJzvg0KmMUcqr+yM2huZYuo
	2NwI977YGSPC+lcrKk+4BuiwVtfwUSA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=f9CvWf5U;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.235 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk2-f43.google.com with SMTP id d75a77b69052e-52fb767d286so9203491cf.2
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789663165; x=1790267965; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KAunQ0cM3aakk3XhlasjaszZbs3F0O3wQSsFDCWQw2s=;
        b=f9CvWf5USy4eAitglSFaXFjNRyIQkx4p4A8/NAvemMHwQGRe3UwzBTM6Dh4HvpYkKs
         Ux+JTvC3l2jgEtiex/axr+PWhl8oKegbebm5jP9y3mGuPTRWz3YhEw5/c/24SP2M0qPF
         Mz0FBi6EP1P5pPHwLB9sJZ8aNeG4fuXBNObh/uvH/V+2yg0y2F5fboPHHy3zrgAH93Eu
         wMz1/gNuWa8DhgB1I4fS0Zim7nXl3OPb+y7CXQ2Nh1jzrY5o0pAou/8JLOq0r9rotpHr
         DNf1n0eWGQuUvSrFDykBTLff4u9D62DwM8AJA5b7gPdn+sQV+jwpyT6Ro7WlRYpiOuwO
         /umw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789663165; x=1790267965;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KAunQ0cM3aakk3XhlasjaszZbs3F0O3wQSsFDCWQw2s=;
        b=jMyL820n+9h+Ybv7Dvhtv3L/NDqI/g3EGpp+5rLu29JT1nJfaE65EOnhJfuW4zWwF4
         ZMhvpZdnkWz39CzsDxmaQT/pmn/6NhBNyn7KZnIieKQf476KlMh7X1mzx326CmJeN99O
         zeH0at0k4aJAEXgn2xkkoMAvYWMfdUIVF4VyBIdixg9QQ4qyOVyfM0xBEc83Cm/UaVqV
         dD+etjipY5zKCODxJ4fnZ+aFoIWWngRDNVhPOHAWKCMeEUb+Es6conXkp3ApqziClj0R
         5O1xAG/5vqprJoVuBZIlRJqmvU1W1PTsbt6pqaz+wn1lRuB9nPrwSE+UR2LVwUq35n0q
         0X5w==
X-Gm-Message-State: AFuF++kstsgz8KuBXc/NRm4oExAN4kqRiEjXMVntTCZqjtqo8hhPj28M
	7pa7nn2YkDDX3d6IfRQ1WO+RNjMsH/qELkK7tsK68o5vF3N1mGmt1b2upU/x6SVhbRA=
X-Gm-Gg: AYBFou2/4fk0QLZKpZSNxod0Ggvcv4OlA4nEwCouJcfAjFBCQaBo9pynXhSgQoc3wyT
	Swdk6HSogZT7W8vlccV0hLS78ciV5+Km2H8HHnyC8bz0XRAX1f5dyyZfXIl9jW0e2TqLMqHkle+
	x6yrtmcoP/cGvsxBmJGPtIQmxAQluPd4WuVDvNPtEjsSnxztDei/S1w5uqDrPRZjC9S4bFCxDVt
	C6EW1G4lyAXnMGBto0lRHAR4KyHV2mpISdJiAkOf29s8e4kfHoy7LxOL04ixzjFmLsastEpSt4/
	h2eYTZycxvP40yySiziKlSqRhGkQZ3Ve1MWRtKT2wOyZ/+cAF2h5JYOnmCbDKr9h2/xwszv5GSm
	PazkGMJb07x8tdkH2PiJQt6r+8YlRvbN7XNxXAp7iYlB1QgzLnylmh2l8Tc7GmmY6QzDR+z0twN
	tL1fbiwYSAagq8EOi/677khvifAGHKkNcxXNIccFTgXDf3Mv22u09yrjWSV3i0Ay0vKjiS+A2X/
	a8v2IuTdWxJqY75T5iNdjui3pHXB+UZynlkootR08BOURZKQ0fyEic=
X-Received: by 2002:a05:622a:1f99:b0:530:dcc7:aeda with SMTP id d75a77b69052e-5327eeab4e6mr112125271cf.40.1789663165269;
        Thu, 17 Sep 2026 09:39:25 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5326204ad36sm53765271cf.18.2026.09.17.09.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 09:39:23 -0700 (PDT)
Date: Thu, 17 Sep 2026 12:39:21 -0400
From: Gregory Price <gourry@gourry.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	mingo@redhat.com, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, 
	vschneid@redhat.com, kprateek.nayak@amd.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, 
	osalvador@suse.de, hannes@cmpxchg.org, raghavendra.kt@amd.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2 2/4] mm: allow shared folios to be promoted to a fast
 tier
Message-ID: <aqwUxQRwbhfGgg1J@gourry-fedora-PF4VCD3F>
References: <20260911001826.2109390-1-gourry@gourry.net>
 <20260911001826.2109390-3-gourry@gourry.net>
 <20260917160827.GN4121339@noisy.programming.kicks-ass.net>
 <aqwSBkeP-Df2GBLa@gourry-fedora-PF4VCD3F>
 <20260917162324.GP4121339@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917162324.GP4121339@noisy.programming.kicks-ass.net>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3FBCA20005
X-Stat-Signature: h1shrrfdq186i1aagd36s1kfdjqymf7c
X-Rspam-User: 
X-HE-Tag: 1789663166-180956
X-HE-Meta: U2FsdGVkX1/Lf4e7YcNQS5Fybum/zystly2xV9XWC6QER+sT9E+yhMmAyt5lzrgmymssVtjSCvoMBxYHHu41vdTEtoJy7ug4y5XucQTCS9LHGKIqS6pFr1uHCMIlrZifLmdd43Dd4YMh1OpaJnMzsGbKfkrAxhm56ssg1PTYibisIy8GafFA1qQEitIP++s4xDh3SdiUFE16nOavnox/qDCY+I33KgyQRkJ2fri4N6wBqLoq601YKcqREorxD8iWObtRp96oihINE/JZnmUIiM95T8YoqvxbfxsQOxpu3mDD6ZiO4hL56CXUvKbw1izT772KpECeTnbS3D0pOnxkW/a+zzfhs8YA7BQ7cixP7S6EIT4mh/bwJXsr1iHagDDL5WVG95CSgYlIdkWlY7aFdc6DCpaAO8VSwLTdk/QgXOyKaxL7uHa65qABZautxVDbd2bxm9vQQG8Y8okZyjOB+WnuyxWS+7gWl79zxs7TKzA1EXKVyuIutj46PnU/iv4ANMoa/5p3UmKexm+xN4t7Ke0WWKMcbYwVc905wWEVOzcnNm0uLyseXZffK0ohj5+xRWKbWolh27xdc+uqK15/Abmk5lzf+QVkW3ksSUng8MsW9wC0FsagjINIoDHq5UFjSS7r+BBsIcai6e3ij7u7DM6eZ6OU7bgnz9rQnU9ndp554Z5c90A4mRIWaNQUISoV9LedsGJ2Ns+pOdM4WrYtg8fQVvc99B14/dvGJiXOeXnYiPyn6oKwA/vu/+U3DdGNB5DzJnVdZI3dGQyEqsg7JtwjyvJpTj8AcEeOkJiNTmnE06138TjSsulq4pqJ0ZR3OFvP+d28w3shMZBF4weE4AjPMAQQHintDm7YCpqIT9/olAI0NTU3DrZcF7JWgeynYNGlG0KBfspjGIMxx+GZjBFpxVot8c9xTYK5ktTXj7adtsLo9s3W4vH9kRf5T+zRSpWb/QfZHreKGTPnDmf
 XQlaoM47
 p6ZMpj6/DQjXec7xdgADHRXyqmkTcKY7v1fMyssV7QNOEhVOCBH+FQspVN1fXRffmVUhnYB+Bdw04tPHkY9IWftLp/NoOlB2uxVbzaP+wLdcQNq+y+8jHhHhaZoG60ibulh7I9NQKZg3z7ANM028dftzDnwNWfxNaMUhWnGQmVWIi/k9irI+9Ue2+kzWlCiMStHg/ZobLo48aaUsXOhElwUlDH6ZTTh+PYydRAR/F7j73tqAZ7blvN7wQZBWLN16K8h5opsdrRJba4IYJQrKpv/4QQYHVwka+wEHhV8znX8moGKL7BuaiRljjUuZl9ypoLjmPzb6rD0aYdRoGp/fG68dZrM7csAiDXXaz0hiINgsDuhbRJ8rYoRD4ddYT0AnWOiUGAIzCoI7YkuHVFI2n6fwJl8lxOm4ZYI+kTgZpUwftnZg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 06:23:24PM +0200, Peter Zijlstra wrote:
> > Would be nice to just have the hardware report what's hot (and how hot)
> > rather than depending on a software-heuristic like deriving hotness
> > from a page fault.
> 
> Yeah, there is/was this patch-set from AMD that uses their IBS counters
> for this, but 'ab'-using the performance counters for this also has ick.
> PMU data isn't ideal either. Mostly they generate a ton of data that
> needs to be analyzed as well. Its not clear cut and easy.
> 
> I'm not sure there's been proposals for better hardware support.

In the CXL Spec there's a "CXL Hot-range Monitoring Unit" mechanism that
will report the N hottest regions of the device.

Not sure we actually need this for the CPU-tiers. LRU already does a
decent job of recording coldness.

I think bandwidth data provides the missing glue between the two.

I've been a proponent of just using bandwidth data to drive *when* to
promote, and let the devices dictate *what* to promote.

https://lore.kernel.org/all/aPJ7qe_2xznFSUMZ@gourry-fedora-PF4VCD3F/

e.g. if the top-tier looks under-utilized in terms of bandwidth, get
some chunk of hot data from below and see if it shifts the needle.
If so, repeat until numbers stabilize or the top tier reaches
saturation - otherwise chill out.

</food for thought | ramblings>

~Gregory

