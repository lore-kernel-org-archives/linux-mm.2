Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D2BEF54AC5
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 14:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A49C26B0089; Tue, 24 Mar 2026 10:58:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FB566B008A; Tue, 24 Mar 2026 10:58:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E9C76B008C; Tue, 24 Mar 2026 10:58:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7973B6B0089
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:58:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 09B391601B9
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:58:21 +0000 (UTC)
X-FDA: 84581262444.19.B5F829C
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0D71F120002
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:58:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JN3Kylba;
	spf=pass (imf29.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774364300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NiY1YRqWKN2c0v1X9CNmB9tc2X+pcdgcgZJabn7k3xw=;
	b=DOWm3QeCSgu7W2HvqGKOqPIsdHORszsFS7nmlyUMBokmk1dufFgDZxwtVx6wRjh8fBzfSp
	9QoCbY2vU+ftIWbIyNv0tzntvKyoif8XyhDyE6ca+FfUgdYOQKP43Guxjh77tihHQkaRnZ
	E17qoGpd236cdN52GvbUkt3vB/hzD2o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JN3Kylba;
	spf=pass (imf29.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774364300; a=rsa-sha256;
	cv=none;
	b=FUR17NstIZ9xWl9MuQD7Io2TalgK1o2d0t/duSKAT6Kth+AdgNTViGSkEbox1V2JPRPysJ
	O9bIhIP9Y3tuOL1nwB0R/9aXJIcTTi+NUl9qJeX6HwUkt9NWvaRoGs2aHDSWyOZK7Zr9/q
	QUrNefDLd7EEr37wBTcneIyrkmyavLU=
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-40427db1300so2839274fac.0
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774364299; x=1774969099; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NiY1YRqWKN2c0v1X9CNmB9tc2X+pcdgcgZJabn7k3xw=;
        b=JN3KylbartITXmFTvU0FpiUJlRAxnu9/0SnIuH1knr+5ePXhURXLw1wBdU2ifS0JqV
         RFRz1pRUq98nUK3GcqluN5iIRb2YfBD9sdnWGTnscknVvNAxlgXmMLBPgXl1rzUDEC42
         M2Do1FXmTyTzFkCgsBDFTogR8czrAnVJC3DtpHmLwjL6ohUi2p/YDk8XUdvNqwaKOa1P
         94C4Xd34Cn+KIbVsXJ7YMGS+vgm+gqAFufdMa7iIx5uNDdTAYzLq2XGR8RbKd3d8RkeA
         W4WDjfsjdWkfjFUx/8i5gcpYQqXXeZiPsRVXDk1AP0HFCvXANWZJtrjduzHnhr1OUXaM
         CkRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774364299; x=1774969099;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NiY1YRqWKN2c0v1X9CNmB9tc2X+pcdgcgZJabn7k3xw=;
        b=Z3pEdByMWm3Ml1Fg2IpUff/YdgmGq3lK1EnfCr9UwLsqcONJMYQohpQ8eWinveyJ4Q
         EUa4iex9s97KUF9UAaqLL60uLrakA76WSgU8Ffsnpz5CHNNmIAvkHjew/jladDUEyBqv
         CJ0lGn4+st/HiQLyxh7CpGWQcdS6d2aGpvmdBZ1XW0Pw5sb1rQye8ZNdi97c7926Ew+z
         O8/W8XzYxvHutyNKAthh1WD5YBlwOaO4vRFwpdgNARveecvxtxuRpr2WdEoZ5Mmq1TXh
         U4RQ/7bfgAYglzhHu5PPcdgLxzaFqfH2zit5FV8dUj20Sdy9OxIc+WYCHHKpfeEGMQyy
         ElIw==
X-Forwarded-Encrypted: i=1; AJvYcCUctLfr5efCBjFiA7so4bsleb35nDmSm7OlahZ2QQx9DiDkxatHGDqt7x651OEsMfAsIqgoQUDoKw==@kvack.org
X-Gm-Message-State: AOJu0YxBUfugzBZWurREWtWbksLbm3RBpSvifdYkkFc06r1ZLkzrCsTw
	5iLi4YOWWWe7SoH4EfVPYKWwIaSnJx3DwsQbgRbCW+JHTVWh7M3lWTTT
X-Gm-Gg: ATEYQzw0X593LO0vhRX/E1+e9QIJhnMdFQQ8Mw1lwNQScTMdiBOKF2CCGHMxvB5Mfsy
	wzxyqUMF2T6cHjyWQtkt/T0Ei98pmCjZ4yNnTsnQte6WmaG8VofSqdl+Uf5ZFGK8nHHp1QC/oim
	J7fHmuu8xNUu5P4fMBP076LaNknzGpfDvx5kpW/WDW4k5dIR6y6Xqmb5NZ5WFU0047dM7xzQxQp
	qR2KiC83nH8vFF7wS/K1J4wzpHnO+rUYBsIjZmQPqNPZtu4aTSm0/h9fj7iZm6/bIHMzFTePGeM
	BtwlKtejOlBBwYLsY6qktQxIwyAOSwp7/EgsAtiZX0T2HqsYXd7SQqviTH3hvlQdVWk5nSEGBLG
	Ih8QFtTPgRMfr8zvlMI/2msfKkN97L+gk24z2w63cYHkXkMdvRrSoMQ6PaI3eRNCxOh2rYK1AdO
	ytXr1fqGcr1hLb978mHgsqQg==
X-Received: by 2002:a05:6870:c248:b0:409:6862:aba5 with SMTP id 586e51a60fabf-41c11157d40mr10061336fac.25.1774364298770;
        Tue, 24 Mar 2026 07:58:18 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5e::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41c14ddbcb3sm13662511fac.14.2026.03.24.07.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 07:58:18 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Donet Tom <donettom@linux.ibm.com>
Cc: Gregory Price <gourry@gourry.net>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kaiyang Zhao <kaiyang2@cs.cmu.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Waiman Long <longman@redhat.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [RFC PATCH 0/6] mm/memcontrol: Make memcg limits tier-aware
Date: Tue, 24 Mar 2026 07:58:16 -0700
Message-ID: <20260324145816.3939303-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <13eb0f7a-95bc-4337-9d38-a06db0700777@linux.ibm.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0D71F120002
X-Stat-Signature: j7ew8u9o7wbfbyrusjeg6et91w8isatx
X-Rspam-User: 
X-HE-Tag: 1774364299-212803
X-HE-Meta: U2FsdGVkX1937nBANjQyW9PYpurcly80JIux9c0sMHMe2NL5TdQAUnEVUSzpm0H7zm5P7Ae/pyDVsxOlp1GO1L7PpKCFqJn9IYB3R+aj5h2rC9KYNzldVZqRsBa8+D+mtddk4KPLfT0F+qKyBm3lpcrW00zBOnTNRzHgVOsTxlpq3EHrDBercWY33FHzCn4c0EjmwuRUde9yv6EleHB8sqcyKPb1XawV3iLzf/1pI5fwRL0DhR0gSqsKZSUhc9st6IEfCja6rhyyUwZl8hSbHw3RZQ921fXiwYhzCJBZwG23kyUx2ZCFwCmKu3ZEOzwYbT2F9/NGarTeedMkbwZVX3J5AXzIGxpUHq2Kzmn1J1OH0ywpXIwAJeultfYBuOSyhDfvH0uaB8ABztP5mHM9FTnXWLTJjcj/lBfHCeHnrSt/aGjg58AzMs5HK/fmm0ZupFEnon706AF7xUaSznMUgcbXsvh+OYPm3XgS4MioS8I3Mg/oI3Tdg+fiZPkp7HxaZMcXnxUnlMqBgqF4r66hgGextLFMC8vklai35kLqc5tG+A9mOA5CpEIHtYetKTeITZAnsFW6b0yoh9B6Netpt0obI7UVwT5HI7K81tM025/b8I0xa6K/JBUhBJ+sMRvz1M8mNzufvxSS35g4sfMnFEJFKZjOUpijGoo6yW0fUGfvG3vlYf5swj3mW7S66LzIUmtPoeNhRpRlft9IG9IFVu5elSaRJs8IkYHg+OwtS4uXNlyYurDoaKjoIdb835XP7Vua2KX9HLcYyORTXw71h4zraqxGFe5HX6m5TC3lKM32iU4XJJwS3N4a79/52aiteJ0Xw7YECDGOgPSUWfsD6d1aKkFB9qDZB4oyyWYmyqjxrsvvZjfRSY1vGpH2nSb9qs0+ilb2HuhvveOVgL/npDqY2x6VY8mxXEopk3bpty/jRDqQKxkPhHh7wVzuGVPbOF2yuJYCBnFoy/PE3lY
 w9bBojxk
 m8Xf/3Gq52cOPbZmXc7worCsxzSaqyUbEAVY+L5scaSfx1EnAFCIhvFSs1Wmg1MHnp+/ngiC5ywOlNmbhu/PkQTHYgak+IvBg/oSYAKQmeikTGNNWghP2Pz+co08EF2yveEntNHeaz4ME42fg7yACz68+rvMGWt/Ic+QNoDU6zCX5wItBOeStedzE74FPaq8zb6pL5X7V5Bc/b4eFsrlVV4Cyk3L0x4hdoLTZyYTMMHTVrZQDnVpeX6IVFJRfEgdw/VvLBxYbiuoRV7VpbPKTo3nhcTPnM2n/GEzu2BuLe/pc0y3ZHiQC99aW1BxU68ZRXRqYXojksiViXwcEFr3BmlpEikbQDWx9mKUc37n99kcVlPLgIO0RQ8dgXx1+RVvMmBBzVe0mxH+5rjn16h9waqggpet/D273YHdpYOeloL+DgZhw7F79giOKvQvTJr50hZS3XoXzPPu6qB+M64Mwtqm5AjFdcgy8EhlomWosmcsMFjJOVPN/ucerib8Oq1ug4K7rD9mkETB7vA7gFbqKm2ZWcyUX0+R1jHrD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 24 Mar 2026 16:00:34 +0530 Donet Tom <donettom@linux.ibm.com> wrote:

> Hi Josua
> 
> On 2/24/26 4:08 AM, Joshua Hahn wrote:
> > Memory cgroups provide an interface that allow multiple workloads on a
> > host to co-exist, and establish both weak and strong memory isolation
> > guarantees. For large servers and small embedded systems alike, memcgs
> > provide an effective way to provide a baseline quality of service for
> > protected workloads.
> >
> > This works, because for the most part, all memory is equal (except for
> > zram / zswap). Restricting a cgroup's memory footprint restricts how
> > much it can hurt other workloads competing for memory. Likewise, setting
> > memory.low or memory.min limits can provide weak and strong guarantees
> > to the performance of a cgroup.
> >
> > However, on systems with tiered memory (e.g. CXL / compressed memory),
> > the quality of service guarantees that memcg limits enforced become less
> > effective, as memcg has no awareness of the physical location of its
> > charged memory. In other words, a workload that is well-behaved within
> > its memcg limits may still be hurting the performance of other
> > well-behaving workloads on the system by hogging more than its
> > "fair share" of toptier memory.
> >
> > Introduce tier-aware memcg limits, which scale memory.low/high to
> > reflect the ratio of toptier:total memory the cgroup has access.
> >
> > Take the following scenario as an example:
> > On a host with 3:1 toptier:lowtier, say 150G toptier, and 50Glowtier,
> > setting a cgroup's limits to:
> > 	memory.min:  15G
> > 	memory.low:  20G
> > 	memory.high: 40G
> > 	memory.max:  50G
> >
> > Will be enforced at the toptier as:
> > 	memory.min:          15G
> > 	memory.toptier_low:  15G (20 * 150/200)
> > 	memory.toptier_high: 30G (40 * 150/200)
> > 	memory.max:          50G
> 
> 

Hello Donet,

Thank you for reviewing the series! I hope you are doing well.

> Currently, the high and low thresholds are adjusted based on the ratio 
> of top-tier to total memory. One concern I see is that if the working 
> set size exceeds the top-tier high threshold, it could lead to frequent 
> demotions and promotions. Instead, would it make sense to introduce a 
> tunable knob to configure the top-tier high threshold?

Yes, this is true. It is also a concern that I have, and I think that
adding a tunable knob could be helpful. The other side of the question is
whether there are too many tunables for the users already, with min / 
low / high / max. I'm hoping to get a consensus for this at LSFMMBPF, 
I hope we can talk about it there!

The other way to approach this is to throttle promotions and demotions
when workloads are thrashing. Personally I prefer this decision, although
it isn't mutually exclusive to adding more knobs. 

> Another concern is that if the lower-tier memory size is very large, the 
> cgroup may end up getting only a small portion of higher-tier memory.

I think the issue you mentioned above is a bigger problem.

If the lower tier memory is large and the toptier memory is small, then it
makes toptier memory an even more constrained resource, so splitting it
fairly among the cgroups becomes an even bigger issue. Remember, we're
limiting workloads' toptier memory usage because other workloads have
to use it; if we let a cgroup use more toptier memory, it has to come
from another cgroup's share.

Thanks again. Please let me know if you have any other concerns, I'm
excited to talk about this more as well!

Joshua

