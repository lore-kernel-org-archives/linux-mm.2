Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 214EED3C536
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 12:30:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F13CF6B0006; Wed, 10 Dec 2025 07:30:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9E626B0007; Wed, 10 Dec 2025 07:30:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D65166B0008; Wed, 10 Dec 2025 07:30:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BE53B6B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 07:30:08 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5E28660276
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 12:30:08 +0000 (UTC)
X-FDA: 84203493696.09.9EA42C4
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf12.hostedemail.com (Postfix) with ESMTP id 76DC540003
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 12:30:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EVniFHSM;
	spf=pass (imf12.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765369806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bs4Nvh7wcafrSDigF6jb9/xBl2rvyHdC6iSByDm1J7c=;
	b=Ykbch7y5wE7OOpza34PUNR2Yh8f0WoAFcVfniLTEziKnOYX7tXm/hXScyoP/svzBeUtL5m
	QYkKh432aeIQzFO6HQIV9l/Q7zjaDn/iCJK7qlSt/9bTvMQRKVXNcC1Ml7LWlSZw8GBK/U
	48zdPERvbvphH/nVN0P48f0S7rNKKuM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EVniFHSM;
	spf=pass (imf12.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765369806; a=rsa-sha256;
	cv=none;
	b=Q3SYcEDJw07bUfQhCIJ33phI89AMq5SAGvqt0WN6z1F0P+y11nhYvfzhhz5w5PuZYX4/+3
	7Jp3oYMh56JbGRTDEjhjbNY98nGwaPLlbj5uZHWNojwP4tg4OlGN8P2gljStZk62mVMdMZ
	o4cO+vDfQks9fTI3a+lLaj8KbDJO7EY=
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-6446fcddf2fso558433d50.0
        for <linux-mm@kvack.org>; Wed, 10 Dec 2025 04:30:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765369805; x=1765974605; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bs4Nvh7wcafrSDigF6jb9/xBl2rvyHdC6iSByDm1J7c=;
        b=EVniFHSMZOd2NCy5VfwV0bAnIchkfMxGTR82Rdt7Zv1ajNQlNJUwjlsXUlumobBTV4
         hXEYwyVcitg4siw6Tpbl01QNLciYxBK4TyexJ/Bc7+9kkLeVPyUfALTdVZyt1Ao9aIe7
         nZdKedAPJj5oDkH5UCm7dfN5w2iEYL3DVgFDac4+ieovSKOnbecpGYTqMmPOPJ88nEGu
         X34FJGjLocecD77j3g9Ya7dYya/jpqEn1da/lJY5vn2BxxzAx8Uy1oCAAZw2PUoCNNzu
         eTidTBWNSpPtHGAUNfJLruDrFEP15LljKzPXe7dPuB/YXafCqmYe2wydHdywUmERWNjT
         8yvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765369805; x=1765974605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bs4Nvh7wcafrSDigF6jb9/xBl2rvyHdC6iSByDm1J7c=;
        b=fGCdHXjwGN1VCooJBmeIwlJCM21zF0LGNxaEsP4MVcDwL0INoGkvjzJi7Th9pbfWQu
         7A0wYYYVPWH2feLzPgl6ivWNSnIXJA3FsWd9xBGHieHf067gvNsgPQS6W+NZLyYIgx46
         5l1ii3VNmzJM5ExKalu77lA2Cs8I5iBKl68g+Q7ZjNl5Dj7AgGi2tnzG5beiXfJMmYVe
         LyFT220BK4rxAxVe8EagZCKBvrFISY2tBOyzT+UWHAJJCe1Z93OMSPPrlL/QKOjpP5ud
         9o68ENhEc7K7SiL0mFSkORwiNqdApnkUz5ikOJbyZMIbn25aF/NEAwCnAwiX1Rn0h+9/
         j/XA==
X-Forwarded-Encrypted: i=1; AJvYcCXIstm813cIzMsU5lnZlRLRyY2JTAB2IwnOnT/+A9FEV8LGD/UGBDpxbqJJSQR1ZwceFHDnJCjqiQ==@kvack.org
X-Gm-Message-State: AOJu0Yx/SQNlNz5Db/P2ZSsqCW3NrwQ0i4mIVoMz6I2ANRlyP3Xpo2MG
	bAlYZH8TRfAunmuIOVHLO2Tcy415ff9OU0NnFJ1fRWKRVdcqswGGqXBT
X-Gm-Gg: AY/fxX6VKJ33gLbq7m/srUTjVUWqko7uz3i+NMaD+P6Inv77b7NKSlaJ70fLwRauIM7
	qScXCzrtk8TLTHaZEHqherExnRCd5NUkMIWJ0KA8thORoPB1ujztyxVzLnnPG1EBs8MIcB5VH94
	q5GEqUvWeJpvrSj5IZgFVWMh13n7uKgbblcPXrfrAp8QA81xP281WhxcZXZUjefwxIPtOvm83OA
	T/x4p/F5fyFxpLaMtJLw35+Yy1G6xHvQnjdxFc7v1Szis3Em5pe4SU/mUKnJ31ZL/WTSWFMcVgj
	pGyT8EOEkHGjKNigRRGvlp8L0huvUOloPZNg2l/gjcp+Cy47iUcvk6c9srRJN6B6Ktw4INYPgsR
	hIkm+xoCWXpJ3h0wi8QHes7zrFMZrM9hTEKK5EazUBzroLrNv8gsB3/yRyleCRGL2neTV2IZ3aN
	OdJNim1fpd4IAeWPDxDdcFCMU/rafO87Rb
X-Google-Smtp-Source: AGHT+IFNh53RYGhBm0spY9cGU4hrvZl3rVUUUljhOpXEUJgWRnGD1AENe9Wq19Qn4XXLgG15AaZkgw==
X-Received: by 2002:a05:690e:2597:b0:63f:c52c:3828 with SMTP id 956f58d0204a3-6446e98333amr1349152d50.26.1765369805247;
        Wed, 10 Dec 2025 04:30:05 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:5c::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78c1b4ac94dsm70695807b3.9.2025.12.10.04.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 04:30:04 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: mawupeng <mawupeng1@huawei.com>
Cc: joshua.hahnjy@gmail.com,
	willy@infradead.org,
	david@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kernel-team@meta.com
Subject: Re: [RFC LPC2025 PATCH 0/4] Deprecate zone_reclaim_mode
Date: Wed, 10 Dec 2025 04:30:01 -0800
Message-ID: <20251210123003.424248-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <fc00c53c-ab54-42a2-979b-0ecb49ff6b48@huawei.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dkfy6hmiz1zg6om1r33k65crbt9gd8eg
X-Rspamd-Queue-Id: 76DC540003
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765369806-230526
X-HE-Meta: U2FsdGVkX1/VEeJbx3T8ZplUyTF0XQudSJEkjc0VtmTdRXbhMRgjmLhl6fGrMlnNN4gSKczxyHpAxq/YDzSvYoGl03YL8DU17ZOcJyPih4rvtxoXWK5sU8ZDtpfTqrkq0JYRks2ULWPC01JoD3dFOBiO8JcnxpqudddjjzobLbV2EiGLo+nJOjJNRKnZHs7W1WkxFUkv2VfjPMV2PqxXCcBIib6Tjo3tBgLf+h17OIQi72m28phvgOfsaV0sz3sAhRDK92TonekJfS6y6g8X6lULvEuPWqS4vbdCw0/Pi3QX/DcwUzyAfr3my9rMFMeFcFuTJh1WUV8eE4rQrKik03IB1gRBGTWX5ZOoOundacexVgVRRK6iWcgILLJOVk8mBJ+jq/7kPkQPpc2DhFB/SSLBdm4l2eo4iyvoipODkb+pkQPQyhjRGYBnJQhEuYq2QrxCMWgogS61xb1RxgXD8DR2pTpJiCqNIeT1DhjNcivICH1k1b9oesMwzDTu5WtvyPKDm4lxj8ugBDIsXTv887XoFj6yVBxLBdlG7eFqe/5P/7ovGsEjw1w7+U/QN0LmgQ/asX/BrZDyr+4Bs0fOxUF/6W0Bmz2Dwy/HAxIXyu7U0fYcznWfHljKrYk7Km61BOkvnEdLD60vTuqeBerRtXINckjkDF6MGiyydQ9RKAudh4QIM0JsP2pyLK6Ev+9LtXyGDSbBgEVUdThmRzk/y1KzLyNU0SPXjWr5SzYEyNH6kh3pJm9IVimHxjYXyuAiHlHCQWc/SsM6ye+WyY00Dn4vA12WWtY+Nn6TDNya9wwAQWiQlyZsd+hHBDQ7w8BoI9VYFnlyyz6PjCtyr2XgR/dnmtKV90XrH6jnHqJg0gSC7fClOgNKgUrofgj9LqAJpu6bN5CbI97K5BwmBzHbERUd8yZpxStZRrvxd5kFc5771vP4qvq4l+60lPWvrwbxXFJY3wd09JZMCfncrkx
 z7rUA4Ox
 qBwn3OiyUSX053fkJ4ahIPj0MaNSOLgpmt7O6p+JpP3XSJsWrGrNw7JOYXz8TBTmqIwuVj7UWasvvsFwGxsouguyWui1ucHn6Cvy0Vw9QWl6/HuSDp60H9ptfz2OWPMjRfepONeuUs+hJO5Jx55+2pb9kYvGr9odlXuSnIM4ZVYOyz9Z0elOi1qZsq7AlFeDEDlJZ+xPllxaJK/Cvf/gn3ztb8e8di2tnym4/DQFaA9SKr8tdqoCMLUs3aiLS3fA4D2sijDsBZQVW/6e6atO1o4eS4nRFXOTI58Griq4natL/hSf436bDMO1cnI7fRMSE50/RWny2mU5em8DkS5XlVFru9u3kJDmdzv1Knu2Q4+tX+m/QULD9hRiW3rBiQNtu1hTyfctY936nyBYVM3M8aFDI5yogxk68Aw2voaxsbO2yqxj9klyzKNEJGzWU7cZPernLn41jzVmYVJxev/CIPPBm9HA0kNmMpNbemshHmcUaSmaupVfO9JQjeYB1c2AcFw+xoVh4bZkbob11kGnPzny5uXR2u8h9OmxufjvcJMm5qiwoDtGWnlBmypMDTzQMwTd1PNzUirq3LL27SCGjOfTFDucFZOrMGCy1XSFZoSjZ7ilFw2SsDFK2EvFzOx/SoCxStZUPgFuqiFFr5TKn1b13W96ucMsYEKTVl9pixL1fhRt16BUQXE8MiRobqATVnMkxb221536the0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 9 Dec 2025 20:43:01 +0800 mawupeng <mawupeng1@huawei.com> wrote:
> 
> On 2025/12/6 7:32, Joshua Hahn wrote:
> > Hello folks, 
> > This is a code RFC for my upcoming discussion at LPC 2025 in Tokyo [1].
> >
> > zone_reclaim_mode was introduced in 2005 to prevent the kernel from facing
> > the high remote access latency associated with NUMA systems. With it enabled,
> > when the kernel sees that the local node is full, it will stall allocations and
> > trigger direct reclaim locally, instead of making a remote allocation, even
> > when there may still be free memory. Thsi is the preferred way to consume memory
> > if remote memory access is more expensive than performing direct reclaim.
> > The choice is made on a system-wide basis, but can be toggled at runtime.
> > 
> > This series deprecates the zone_reclaim_mode sysctl in favor of other NUMA
> > aware mechanisms, such as NUMA balancing, memory.reclaim, membind, and
> > tiering / promotion / demotion. Let's break down what differences there are
> > in these mechanisms, based on workload characteristics.

[...snip...]

Hello mawupeng, thank you for your feedback on this RFC.

I was wondering if you were planning to attend LPC this year. If so, I'll be
discussing this idea at the MM microconference tomorrow (December 11th) and
would love to discuss this after the presentation with you in the hallway.
I want to make sure that I'm not missing any important nuances or use cases
for zone_reclaim_mode. After all, my only motivation for deprecating this is
to simplify the code allocation path and reduce maintenence burden, both of
which definitely does not outweigh valid usecases. On the other hand if we can
find out that we can deprecate zone_reclaim_mode, and also find some
alternatives that lead to better performance on your end, that sounds
like the ultimate win-win scenario for me : -)

> In real-world scenarios, we have observed on a dual-socket (2P) server with multiple
> NUMA nodes—each having relatively limited local memory capacity—that page cache
> negatively impacts overall performance. The zone_reclaim_node feature is used to
> alleviate performance issues.
> 
> The main reason is that page cache consumes free memory on the local node, causing
> processes without mbind restrictions to fall back to other nodes that still have free
> memory. Accessing remote memory comes with a significant latency penalty. In extreme
> testing, if a system is fully populated with page cache beforehand, Spark application
> performance can drop by 80%. However, with zone_reclaim enabled, the performance
> degradation is limited to only about 30%.

This sounds right to me. In fact, I have observed similar results in some
experiments that I ran myself, where on a 2-NUMA system with 125GB memory each,
I fill up one node with 100G of garbage filecache and try to run a 60G anon
workload in it. Here are the average access latency results:

- zone_reclaim_mode enabled: 56.34 ns/access
- zone_reclaim_mode disabled: 67.86 ns/access

However, I was able to achieve better results by disabling zone_reclaim_mode
and using membind instead:

- zone_reclaim_mode disabled + membind: 52.98 ns/access

Of course, these are on my specific system with my specific workload so the
numbers (and results) may be different on your end. You specifically mentioned
"processes without mbind restrictions". Is there a reason why these workloads
cannot be membound to a node?

On that note, I had another follow-up question. If remote latency really is a
big concern, I am wondering if you have seen remote allocations despite
enabling zone_reclaim_mode. From my understanding of the code, zone_reclaim_mode
is not a strict guarantee of memory locality. If direct reclaim fails and
we fail to reclaim enough, the allocation is serviced from a remote node anyways.

Maybe I did not make this clear in my RFC, but I definitely believe that there
are workloads out there that benefit from zone_reclaim_mode. However, I
also believe that membind is just a better alternative for all the scenarios
that I can think of, so it would really be helpful for my education to learn
about workloads that benefit from zone_reclaim_mode but cannot use membind.

> Furthermore, for typical HPC applications, memory pressure tends to be balanced
> across NUMA nodes. Yet page cache is often generated by background tasks—such as
> logging modules—which breaks memory locality and adversely affects overall performance.

I see. From my very limited understanding of HPC applications, they tend to be
perfectly sized for the nodes they run on, so having logging agents generate
additional page cache really does sound like a problem to me. 

> At the same time, there are a large number of __GFP_THISNODE memory allocation requests in
> the system. Anonymous pages that fall back from other nodes cannot be migrated or easily
> reclaimed (especially when swap is disabled), leading to uneven distribution of available
> memory within a single node. By enabling zone_reclaim_mode, the kernel preferentially reclaims
> file pages within the local NUMA node to satisfy local anonymous-page allocations, which
> effectively avoids warn_alloc problems caused by uneven distribution of anonymous pages.
> 
> In such scenarios, relying solely on mbind may offer limited flexibility.

I see. So if I understand your scenario correctly, what you want is something
between mbind which is strict in guaranteeing that memory comes locally, and
the default memory allocation preference, which prefers allocating from
remote nodes when the local node runs out of memory.

I have some follow-up questions here.
It seems like the fact that anonymous memory from remote processes leaking
their memory into the current node is actually caused by two characteristics
of zone_reclaim_mode. Namely, that it does not guarantee memory locality,
and that it is a system-wide setting. Under your scenario, we cannot have
a mixture of HPC workloads that cannot handle remote memory access latency,
as well as non-HPC workloads that would actually benefit from being able to
consume free memory from remote nodes before triggering reclaim.

So in a scenario where we have multiple HPC workloads running on a multi-NUMA
system, we can just size each workload to fit the nodes, and membind them so
that we don't have to worry about migrating or reclaiming remote processes'
anonymous memory.

In a scenario where we have an HPC workload + non-HPC workloads, we can membind
the HPC workload to a single node, and exclude that node from the other
workloads' nodemasks to prevent anonymous memory from leaking into it.

> We have also experimented with proactively waking kswapd to improve synchronous reclaim
> efficiency. Our actual tests show that this can roughly double the memory allocation rate[1].

Personally I believe that this could be the way forward. However, there are
still some problems that we have to address, the biggest one being: pagecache
can be considered "garbage" in both your HPC workloads and my microbenchmark.
However, the pagecache can be very valuable in certain scenarios. What if
the workload will access the pagecache in the future? I'm not really sure if
it makes sense to clean up that pagecache and allocate locally, when the
worst-case scenario is that we have to incur much more latency reading from
disk and bringing in those pages again, when there is free memory still
available in the system.

Perhaps the real solution is to deprecate zone_reclaim_mode and offer more
granular (per-workload basis), and sane (guarantee memory locality and also
perform kswapd when the ndoe is full) options for the user.

> We could also discuss whether there are better solutions for such HPC scenarios.

Yes, I really hope that we can reach the win-win scenario that I mentioned at
the beginning of the reply. I really want to help users achieve the best
performance they can, and also help keep the kernel easy to maintain in the
long-run. Thank you for sharing your perspective, I really learned a lot.
Looking forward to your response, or if you are coming to LPC, would love to
grab a coffee. Have a grat day!
Joshua

> [1]: https://lore.kernel.org/all/20251011062043.772549-1-mawupeng1@huawei.com/

