Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54C09606A32E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 19:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ShKtT36n
Received: by kanga.kvack.org (Postfix)
	id 6556D6B05B0; Mon, 23 Nov 2026 14:33:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62CC76B05B1; Mon, 23 Nov 2026 14:33:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 542296B05B6; Mon, 23 Nov 2026 14:33:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 28F936B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:33:05 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AE1A8A7CB2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:33:04 +0000 (UTC)
X-FDA: 85467381888.17.5CCA46A
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	by imf13.hostedemail.com (Postfix) with ESMTP id CCFCB2000D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:33:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ShKtT36n;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795462382;
	b=W13fzvi9ovpwiTxRmXcOgNLoazaKZa2XolLSjrKRmGtcxZ4/NYFQzSFii4V6m0ZFpaNIS5
	3N9m1wmXt6Z70QjCxx6+oy/16F+kxirbV1Ru12iMnkukI1oBHCqh76ph1kLWYJYnf0QQkg
	nEkj5CAcXQLYuT4WXagbX4WE4xfBbt8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795462382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=glXn7S+m6d9WKK+ny9saY5JJzsG/5FMMUlfMljP3M30=;
	b=EcveNauLCWccqK4+Ufz/V0+1rPdZ4lbBC6Q45cfwBMf8ckk/CSrvssFFHXvhLXgN8SL/Gi
	ZAGhmge7GgDjKZVHmDpW7TN0LyqobeCUc1m6f96QVqJ+RYgvmahpLHj5qaTB53S62Mm8pR
	MM67kUit+iYtk1/ATRZwKz8bd6Dz1fg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ShKtT36n;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-70b875f6f13so2877814eaf.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:33:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795462382; x=1796067182; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=glXn7S+m6d9WKK+ny9saY5JJzsG/5FMMUlfMljP3M30=;
        b=ShKtT36nfnOtJwPBVQMrBhFql4EE33JkRHr5PvVGR9xfar7Ox8QwRz1qGTL24/kPaJ
         WKg4gnLy42tjtynhf1KGhqHunACZPZA48CnrSqubVUXGEWCokBn8QhUCqNd3ELbar2zN
         yil+0ZClV/B9W8P2Hg3C0dreeGygnJGfJVVrhPn3UEj0ji20GMlNaBp3YKY+NQ4XgEqY
         KQMRYC1aOxUdjekAKXr9IhqRXYOm7i2lG8g14Lzq13M7IanulDXWJRWw0h3kezWf6Sey
         CUhvAAAO6YSH7JnNTd/xvKy2qV3XzWkXP0moJwxi3woUS9Sb4QPOgjgktDTrn6WOo2gp
         4xHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795462382; x=1796067182;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=glXn7S+m6d9WKK+ny9saY5JJzsG/5FMMUlfMljP3M30=;
        b=074MeqD9ty5o+qmATizEJ6LYbWut0ZhGWtrXKvnUgnZvIuahyMyILKnDjSLZo5ZBJk
         PKYpYP9VLfNlzk2cyLM0eMEZPms9Cxvti6nkp78sZGtxUeD+/AVFmpwjwOTCL+QcEg7E
         F7lVni9SsiI86TXaZU0yqs+Nd2Ci+xHg5rKOv+KD9q/S4BW5Isv/q9hnr8g8F6RWaC+v
         SeE03cr6vZgceLYYRdx7RsrSH5Aw3/bMNdIvfqF2GcnrnT/yLxgNndqXSYnqo/RpWVov
         DD7WGxKH3jh1eR2VGrUGB340qR288eH5cQSkZO6dD+kCDQYm+wbPJzLqUNfwiNkf84j7
         SMaQ==
X-Forwarded-Encrypted: i=1; AL+hErE4IhwHB03T2nICEat1BwTnIDgrJW9yGhoiSogmPTQ9FfkV9Cx4hGJbMITEs4QUfIPuOVw1IGKVbQ==@kvack.org
X-Gm-Message-State: APuU4Z+Vf4RTJXYC3FNk4tqvFjo0jXlt9mT42q4Ai0SJo8cioCVNQDSB
	8XiTQ4hcl2JoZjJRcuLCP3MuV8GvCPPUtiNTmrKGFuWg5iBs4878Izj1
X-Gm-Gg: AZFdTZe7CwF5+RsobsYpDxry7RMNBzSQ8r45AjZhZXWOPaGRU3NLHVKr7LW1YsiuLmi
	aXaIldDdk6ZUotZVc6C4Tp+XcbnAHtnOzfHqHiRCk/fs7lrcA34zYTYYt8adLjZ/TQrxazrguQV
	oYu6clZXi3JUMsed0aB+KJ2laAUPJiuwKyC8973nhSUUJAX6sJT9CwNO+8it9ZI96+rChe2P1h5
	VMyXwn1yGnMCIuiWOiknNTvtARYyzjWqCRx9HTG6pZ/TJx07ctc+Xxb/m0XDivzBo/uFAXLPJav
	7djJBxmo9fiLyd33WwA3MsuT5IqkMTMc9UjUQ4e5H6eHiK2JHp1VEsW8YIH5dh+lQZsal8WgnI7
	oh+au5LloYYmK4Bd6XAdK3fo7vzISEWjutjNs+AX2aQeG5eDSEQfhECuE61yJTOlckHgz159pyM
	bEv9B9W6TAGV4uWx3j3cO7sUdSgxSsWNwv++inO2eCARanOYGcRLOh/AJLECKZN43mkrcq3fkgP
	0wuVZVr8XCuZzb+KGsBaNC8Psqg0S88+3OZY4+hgKLmHMgAEXHFTGcLCvJRre46+roE8nyS0CET
	m7pwK2pmqPEu145w4l0ltaVYPOxf4FkWWQCQDpQrWEFKEfX8TjRbXhf1nZwvSA==
X-Received: by 2002:a05:6820:c2cf:10b0:71a:f0cc:94e1 with SMTP id 006d021491bc7-71b3960c59emr7028444eaf.83.1795462381565;
        Mon, 23 Nov 2026 11:33:01 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:4b::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4bc61081159sm11792209fac.15.2026.11.23.11.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 11:33:00 -0800 (PST)
Date: Mon, 23 Nov 2026 11:32:59 -0800
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Li Zhe <lizhe.67@bytedance.com>, akpm@linux-foundation.org, 
	david@kernel.org, gourry@gourry.net, hannes@cmpxchg.org, ljs@kernel.org, 
	mhocko@suse.com, muchun.song@linux.dev, rakie.kim@sk.com, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, weixugc@google.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com, cgroups@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3] mm: add source selector to memory.reclaim
Message-ID: <awSUhzqM-QEMTX0Y@devbig011.atn3.facebook.com>
Mail-Followup-To: Li Zhe <lizhe.67@bytedance.com>, 
	akpm@linux-foundation.org, david@kernel.org, gourry@gourry.net, hannes@cmpxchg.org, 
	ljs@kernel.org, mhocko@suse.com, muchun.song@linux.dev, rakie.kim@sk.com, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, weixugc@google.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com, cgroups@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20261116110459.11048-1-lizhe.67@bytedance.com>
 <awSSDehzWsJ68V5y@devbig011.atn3.facebook.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awSSDehzWsJ68V5y@devbig011.atn3.facebook.com>
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CCFCB2000D
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: hu31njr6gc4hp7bjr6q7t8csr9dyqxjz
X-HE-Tag: 1795462382-867990
X-HE-Meta: U2FsdGVkX1/tXTp23pqeah7Tfy03G6hLT0IfZk6aPsUS7G29AIkuhOTChdpmg2Ojaunlk1+2oS68osa+ioZGK9fs25T86JI+8zSR6wE7ZPWCFp16P4RhPzG5PwLtaGjhO+eVySVnwl8JO6HLEZMaeYdFDWUG2GRAyc6g7Cejoz3UcvUnYhKfKvD8nGwo5LDLSMalvLBZY3il/Badqnu3bQ9iOnbAIlXCx8bsZOjV7DAfychkMT05zVYCNXe2QkC5VOg+OmZJX+oJhJEprzPaNnrQJSi6r7gWnwqkNN763W24EIHRDaarsvL/4khSp34I7ak6PxH3s2p9ZB8vfJBgb/sz0hVpO5CO6qke/IC+29cLBPqxAVQhkUU0ioq5OEayAPAnewK0IGo+aprTKfyxDm87w/FUxDcC+Lv4nTK6+wfRXgafYytr++uJ0InuVy9C68S8Dh4oYQxGWwoqoOHqUA/i/gddYhiGvaWI9rR9J3SabYwHkU9UcT7nuju7MiQdRGnXul0KZGbTMz34EcvPwCYSqesIP8w/UHuACovJCKjgpk29983LH/tN5eyJyf7rsD6V5VVhEAzJxPyGBZ+lxT9rd4SJBg2y9oH8irmFNDTbp+CPy+oOPaiTydfiR02WqaQRTMcD6x0xEElMYM/svtBWD2sbs8jdQuJJXGXloJLAVfDwUpVqLXN93OABbgtjMvI7PulOedjcCKuSpAULa7Hb2ExEeV3sdyaiVkLspAgZKjZ9qL9bTo5dE3nlAtYjrqZGdMiPGKm5mY8Z3BvYJVgv0NImfrylR+dC3g06iO3zaTvla1uSJm2iVTQGs7Z5gZ7jaNA7qEtmNLrO4MU/GYiv9gLx4lQMpMYVSFpjpMbqZ40tz6vRJ/se2yOqe67ex5mv6HR9znhLvNWJD+rH6dzTe2We8R0IsZkYYyW99MKf54y0ll1Q1ECF33N+HTf9BZD4lrhDjPN0EYn5p4N
 UmoOEBoD
 JO4NmL5SR5bFYK2t3zsOLAhZ+VSui/xOvL1k8etMeOfSUcIW5VddRXihwl044dx+GDgYgsvedNnAABcnOJxF4mQLlbBVQ4Fj0HrMI7FdrthCvB+7+aPEQ4dbE/55vkxyJVQxeHAynl3KXg92Q7E9jK32UC28VMTiNEv72MXuBnWcwuVAHWIDRULb6Lufdj8a8fm6AxrG7N37xYj0JsxU2InPAg03rOwZtZrLRcdlHrx8Ztpl7wozJchiedBOlevdpp/b8Q0XtF5PGv5zpc9ijqNO1mJMmCvKjm3e3Ex6TdH1VuQ21+FcCP6c+LXEnZfq1oDlsqtK/B8d1bX7GNDUP+HXCXchlllEuCSa9I3IJIosZDMyyBaxVWgFGuw9ZeuTWMm/06qqzZ76DqlLW6B3yr6N5270/VMgptXZOWvu2L/zIdJmySDR+SJnO8AGQdsf7X2xip+iq3anyW33InyVHIWEc2G39SRX4HYn88nnz4LosYeI0ArmPpnvo38lBcs+YOwsQsooVuLzOAr15IdbH+ZfQE9tculw9g9uixhzTCCPwR5IGxWr8A6rTzZcDPX0Ne6IbupgbleFNNXmInwgD8aOHfSx68R5x2WcxWmoaoxgiOlIDwwR7ti9juVAPpN1/V3JHneKBg4z9pw6lfETOcCCG5uwsIVtp8lTS3CxeGYYoEq5QZE5CxnnL3bjxL8dTMk27L7wVh9DwYRwZUwIdyoqG0lKZUP4b7WatVyy/5wpf9Ai9r/KKnfklYZvN+YZ7oUbj8dmxoKt4tTBq2W08isQpXWiYbhQ1pxRKUT6cZubEzgYOss5BulYvoG3h6jf27fLntpM3NHDOwFUMw9f14aVRNtWRho/jLwvihrQ5kKoLtfdb4Y10QfHU3wjJYU1WWqet
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 11:29:24AM -0800, Joshua Hahn wrote:
> On Mon, Nov 16, 2026 at 07:04:59PM +0800, Li Zhe wrote:
> > memory.reclaim can apply proactive reclaim to a memcg, but it cannot
> > target source nodes the way global node reclaim can. Proactive memcg
> > reclaim follows a fast-to-slow fallback order, which attempts demotion
> > before reclaiming from slower tiers.
> > 
> > As a result, a memcg controller cannot decide whether reclaim should
> > start from DRAM or from a slower tier. For a cgroup that is close to OOM
> > and needs charge reduction, or for a controller trying to shape a
> > workload's DRAM/CXL resident distribution, the default policy may spend
> > reclaim effort on the wrong source tier.
> > 
> > Add source=nodes:<nodelist> to memory.reclaim. The selector only chooses
> > the resident source nodes where the existing memcg reclaim path applies
> > pressure. It does not select demotion targets, force demotion, force
> > eviction, promote pages, or change completion accounting. Leaving source
> > unspecified preserves existing behavior.
> 
> Hi Zhe,
> 
> Thanks for the patch and sorry that it took so long to reply.
> I've actually spent a lot of time thinking about this commit to see if
> it can be used to establish per-memcg-tier residency limits on machines
> running multiple workloads via memcgs.
> 
> So you could have a daemon running, checking the per-tier usage for a
> cgroup, and creating pressure to evict pages downward from that cgroup
> specifically.
> 
> So if a cgroup is using 10G more node0 (DRAM) than it should be, you can
> write "echo 10G source=nodes:0" > memory.reclaim to try and free up that
> space. I'm running some experiments locally and really thinking through
> this to see what that would lead to.
> 
> Anyways, to me the only concern that I have is what happens when that
> reclaim fails. Let's say that you have a situation where CXL is
> completely full, preventing future demtions. At the same time, we have
> a memcg that is using too much DRAM, so we try to reclaim from the
> DRAM node and pressure downwards.
> 
> The thing is, I think proactive reclaim doesn't allow swapouts on tiered
> systems. 

Sorry, I had meant to add more context here. I meant that proactive
reclaim doesn't allow swapouts directly. See
6b426d071419 mm: disable top-tier fallback to reclaim on proactive reclaim
for some more context. 

> So what would happen is, you would (1) fail demotions, and then (2) fail
> to swap out, which means the pages have nowhere to go. And repeatedly
> running the same command over and over again will not lead to any
> progress at all.
> 
> > With this, userspace can build the policy it needs on top of existing
> > kernel reclaim behavior:
> > 
> > 1. start reclaim from lower-tier nodes to reduce the cgroup's memory
> >    usage more directly;
> > 2. steer reclaim toward over-represented nodes to shape a workload's
> >    DRAM/CXL resident distribution; and
> > 3. reclaim from lower-tier nodes first so later top-tier reclaim has
> >    room for demotion.
> > 
> > Example: nodes 0-2=DRAM, node3=CXL
> > 
> >   echo 1G > memory.reclaim # progress from nodes 0-3
> >   echo "1G source=nodes:3" > memory.reclaim # reclaim from CXL
> >   echo "1G source=nodes:0-2" > memory.reclaim # usually demote to CXL
> 
> And so I can see why you would have to run something like this in order
> to actually make room, moving from the bottom going up. Make space for
> the memory that's about to come in from the top.
> 
> To me this makes a lot of sense, and it's something that we (Meta) has
> thought about quite extensively internally as well (from Johannes and
> Gregory, who are also CC-ed in this mail).
> 
> But at the same time, this is not really an atomic operation. So memory
> usage between the two operations can change very rapidly. I wanted to
> start a conversation about this point and whether this is something that
> the commit should address. I would like to hone in on a use case and
> think about how the users should be expected to use these things first.
> 
> Thanks a lot Zhe, and sorry again for the delayed response.
> I hope you have a great day!
> Joshua
> 
> > The typed source= form also leaves room for future source selectors
> > without changing the ABI introduced here.
> > 
> > Tested in a CXL setup with nodes 0-2 as DRAM and node 3 as CXL. A
> > userspace controller steered eight cgroups toward a 50:50 DRAM:CXL
> > resident ratio while a background workload created reclaim and demotion
> > pressure. With source=nodes, all eight cgroups ended with 45%-55% of
> > their memory on DRAM. Under the same pressure, the plain memory.reclaim
> > baseline left the worst cgroup far away from the target range.
> > 
> > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > ---
> > v2: https://lore.kernel.org/all/20261102070440.16262-1-lizhe.67@bytedance.com/#t
> > v1: https://lore.kernel.org/all/20261019141401.11927-1-lizhe.67@bytedance.com/
> > 
> > Changes since v2:
> > - Dropped the separate cover letter and shortened/refocused the commit
> >   message, as suggested by Joshua Hahn and Gregory Price.
> > - Added an eight-cgroup CXL test summary under background
> >   reclaim/demotion pressure, as suggested by Joshua Hahn.
> > 
> > ---
> >  Documentation/admin-guide/cgroup-v2.rst | 11 ++++++
> >  mm/bpf_memcontrol.c                     |  3 +-
> >  mm/internal.h                           |  3 +-
> >  mm/memcontrol-v1.c                      |  6 ++-
> >  mm/memcontrol.c                         | 11 ++++--
> >  mm/vmscan.c                             | 49 +++++++++++++++++++++++--
> >  6 files changed, 72 insertions(+), 11 deletions(-)
> > 
> > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> > index 9e3c67b02ae2..992f9bdc46a1 100644
> > --- a/Documentation/admin-guide/cgroup-v2.rst
> > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > @@ -1458,6 +1458,7 @@ The following nested keys are defined.
> >  
> >  	  ==========            ================================
> >  	  swappiness            Swappiness value to reclaim with
> > +	  source                Source to apply reclaim pressure to
> >  	  ==========            ================================
> >  
> >  	Specifying a swappiness value instructs the kernel to perform
> > @@ -1468,6 +1469,16 @@ The following nested keys are defined.
> >  	The valid range for swappiness is [0-200, max], setting
> >  	swappiness=max exclusively reclaims anonymous memory.
> >  
> > +	Specifying a source value constrains where proactive reclaim applies
> > +	pressure. Currently only source=nodes:<nodelist> is supported. For
> > +	example::
> > +
> > +	  echo "1G source=nodes:0-1" > memory.reclaim
> > +
> > +	This applies proactive reclaim pressure to memory of the target cgroup
> > +	resident on nodes 0-1. It does not constrain demotion targets and does
> > +	not change memory.reclaim completion accounting.
> > +
> >    memory.peak
> >  	A read-write single value file which exists on non-root cgroups.
> >  
> > diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> > index d8f579c28560..7d98f55a044f 100644
> > --- a/mm/bpf_memcontrol.c
> > +++ b/mm/bpf_memcontrol.c
> > @@ -201,7 +201,8 @@ __bpf_kfunc long bpf_proactive_reclaim(struct mem_cgroup *memcg,
> >  	nr_reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages, GFP_KERNEL,
> >  						    MEMCG_RECLAIM_MAY_SWAP |
> >  						    MEMCG_RECLAIM_PROACTIVE,
> > -						    swappiness == -1 ? NULL : &swappiness);
> > +						    swappiness == -1 ? NULL : &swappiness,
> > +						    NULL);
> >  
> >  	return nr_reclaimed * PAGE_SIZE;
> >  }
> > diff --git a/mm/internal.h b/mm/internal.h
> > index e3f92883bf23..ff24a58d47e8 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -83,7 +83,8 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
> >  					   unsigned long nr_pages,
> >  					   gfp_t gfp_mask,
> >  					   unsigned int reclaim_options,
> > -					   int *swappiness);
> > +					   int *swappiness,
> > +					   const nodemask_t *source_nodes);
> >  
> >  #ifdef CONFIG_NUMA
> >  extern int sysctl_min_unmapped_ratio;
> > diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> > index b7f286888507..74aa06fee76a 100644
> > --- a/mm/memcontrol-v1.c
> > +++ b/mm/memcontrol-v1.c
> > @@ -1464,7 +1464,8 @@ static int mem_cgroup_resize_max(struct mem_cgroup *memcg,
> >  		}
> >  
> >  		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
> > -				memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP, NULL)) {
> > +				memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP,
> > +				NULL, NULL)) {
> >  			ret = -EBUSY;
> >  			break;
> >  		}
> > @@ -1500,7 +1501,8 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
> >  			break;
> >  
> >  		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
> > -						  MEMCG_RECLAIM_MAY_SWAP, NULL))
> > +						  MEMCG_RECLAIM_MAY_SWAP,
> > +						  NULL, NULL))
> >  			nr_retries--;
> >  	}
> >  
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 84f4a8fd4d16..116c6853c9ba 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2444,7 +2444,7 @@ static unsigned long reclaim_high(struct mem_cgroup *memcg,
> >  		nr_reclaimed += try_to_free_mem_cgroup_pages(memcg, nr_pages,
> >  							gfp_mask,
> >  							MEMCG_RECLAIM_MAY_SWAP,
> > -							NULL);
> > +							NULL, NULL);
> >  		psi_memstall_leave(&pflags);
> >  	} while ((memcg = parent_mem_cgroup(memcg)) &&
> >  		 !mem_cgroup_is_root(memcg));
> > @@ -2774,7 +2774,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >  
> >  	psi_memstall_enter(&pflags);
> >  	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
> > -						    gfp_mask, reclaim_options, NULL);
> > +						    gfp_mask, reclaim_options,
> > +						    NULL, NULL);
> >  	psi_memstall_leave(&pflags);
> >  
> >  	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
> > @@ -5001,7 +5002,8 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
> >  		}
> >  
> >  		reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
> > -					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL);
> > +					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
> > +					NULL, NULL);
> >  
> >  		if (!reclaimed && !nr_retries--)
> >  			break;
> > @@ -5060,7 +5062,8 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
> >  
> >  		if (nr_reclaims) {
> >  			if (!try_to_free_mem_cgroup_pages(memcg, nr_pages - max,
> > -					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL))
> > +					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
> > +					NULL, NULL))
> >  				nr_reclaims--;
> >  			continue;
> >  		}
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 6a1af9b92349..15e2e5710468 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -7013,12 +7013,14 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
> >  					   unsigned long nr_pages,
> >  					   gfp_t gfp_mask,
> >  					   unsigned int reclaim_options,
> > -					   int *swappiness)
> > +					   int *swappiness,
> > +					   const nodemask_t *source_nodes)
> >  {
> >  	unsigned long nr_reclaimed;
> >  	unsigned int noreclaim_flag;
> >  	struct scan_control sc = {
> >  		.nr_to_reclaim = max(nr_pages, SWAP_CLUSTER_MAX),
> > +		.nodemask = source_nodes,
> >  		.proactive_swappiness = swappiness,
> >  		.gfp_mask = (current_gfp_context(gfp_mask) & GFP_RECLAIM_MASK) |
> >  				(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
> > @@ -7054,7 +7056,8 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
> >  					   unsigned long nr_pages,
> >  					   gfp_t gfp_mask,
> >  					   unsigned int reclaim_options,
> > -					   int *swappiness)
> > +					   int *swappiness,
> > +					   const nodemask_t *source_nodes)
> >  {
> >  	return 0;
> >  }
> > @@ -8098,20 +8101,51 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat,
> >  enum {
> >  	MEMORY_RECLAIM_SWAPPINESS = 0,
> >  	MEMORY_RECLAIM_SWAPPINESS_MAX,
> > +	MEMORY_RECLAIM_SOURCE,
> >  	MEMORY_RECLAIM_NULL,
> >  };
> >  static const match_table_t tokens = {
> >  	{ MEMORY_RECLAIM_SWAPPINESS, "swappiness=%d"},
> >  	{ MEMORY_RECLAIM_SWAPPINESS_MAX, "swappiness=max"},
> > +	{ MEMORY_RECLAIM_SOURCE, "source=%s"},
> >  	{ MEMORY_RECLAIM_NULL, NULL },
> >  };
> >  
> > +#define MEMORY_RECLAIM_SOURCE_NODES	"nodes:"
> > +#define MEMORY_RECLAIM_SOURCE_NODES_LEN	(sizeof(MEMORY_RECLAIM_SOURCE_NODES) - 1)
> > +
> > +static int parse_memory_reclaim_source(const char *source,
> > +				       nodemask_t *source_nodes)
> > +{
> > +	const char *nodes;
> > +
> > +	if (strncmp(source, MEMORY_RECLAIM_SOURCE_NODES,
> > +		    MEMORY_RECLAIM_SOURCE_NODES_LEN))
> > +		return -EINVAL;
> > +
> > +	nodes = source + MEMORY_RECLAIM_SOURCE_NODES_LEN;
> > +	if (!*nodes)
> > +		return -EINVAL;
> > +
> > +	nodes_clear(*source_nodes);
> > +	if (nodelist_parse(nodes, *source_nodes))
> > +		return -EINVAL;
> > +
> > +	nodes_and(*source_nodes, *source_nodes, node_states[N_MEMORY]);
> > +	if (nodes_empty(*source_nodes))
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> > +
> >  int user_proactive_reclaim(char *buf,
> >  			   struct mem_cgroup *memcg, pg_data_t *pgdat)
> >  {
> >  	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
> >  	unsigned long nr_to_reclaim, nr_reclaimed = 0;
> >  	int swappiness = -1;
> > +	nodemask_t source_nodes;
> > +	const nodemask_t *source_nodemask = NULL;
> >  	char *old_buf, *start;
> >  	substring_t args[MAX_OPT_ARGS];
> >  	gfp_t gfp_mask = GFP_KERNEL;
> > @@ -8142,6 +8176,14 @@ int user_proactive_reclaim(char *buf,
> >  		case MEMORY_RECLAIM_SWAPPINESS_MAX:
> >  			swappiness = SWAPPINESS_ANON_ONLY;
> >  			break;
> > +		case MEMORY_RECLAIM_SOURCE:
> > +			if (!memcg || source_nodemask)
> > +				return -EINVAL;
> > +			if (parse_memory_reclaim_source(args[0].from,
> > +							&source_nodes))
> > +				return -EINVAL;
> > +			source_nodemask = &source_nodes;
> > +			break;
> >  		default:
> >  			return -EINVAL;
> >  		}
> > @@ -8181,7 +8223,8 @@ int user_proactive_reclaim(char *buf,
> >  			reclaimed = try_to_free_mem_cgroup_pages(memcg,
> >  						 batch_size, gfp_mask,
> >  						 reclaim_options,
> > -						 swappiness == -1 ? NULL : &swappiness);
> > +						 swappiness == -1 ? NULL : &swappiness,
> > +						 source_nodemask);
> >  		} else {
> >  			struct scan_control sc = {
> >  				.gfp_mask = current_gfp_context(gfp_mask),
> > -- 
> > 2.20.1

