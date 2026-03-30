Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F240FB3CEB
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 09:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDCEC6B0092; Mon, 30 Mar 2026 05:47:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8D9F6B0095; Mon, 30 Mar 2026 05:47:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA2D86B0096; Mon, 30 Mar 2026 05:47:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A96B36B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 05:47:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 034711B89CE
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:47:42 +0000 (UTC)
X-FDA: 84602252406.02.2E427B6
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf09.hostedemail.com (Postfix) with ESMTP id DE8BD140007
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:47:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774864061; a=rsa-sha256;
	cv=none;
	b=4V4xYY+Kz/mJRJwvZG1oJIBywURZM84k7y7eXMCgY/WRMZQTMGyceSspNMgw1N+ubIZhZl
	1D/DtyMvx7wv5c9rEvagZdSXKo7Fvqcgy2GB+NWm76XDRNL/eCFURYqReM/xqQcw8J/rX1
	YkkM5J2UDf3KwxasJG0Iq23gE0kV1Hw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774864061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UV9ftCmFwMfCiDo0LKD1r/tvPVIbv9rCYHK7wqvtSeQ=;
	b=8pFP/t8s1mn5XIs26tLn68+0KMpRr07vl0oLj5x3lv0wBvPtI4RBdvpQusFnLbL/7BW5qL
	8S2dxq1u6QzZeqlpywhVkg4w1gTjO+aNtCanc82S9g+IWPEB7KpsiptTJkumtJTOjAKPs6
	fHi1TwUNDz8LHebU+FBRAM/hN59Sy5s=
X-AuditID: a67dfc5b-c2dff70000001609-3c-69ca46b88de5
From: Rakie Kim <rakie.kim@sk.com>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: akpm@linux-foundation.org,
	gourry@gourry.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	dave@stgolabs.net,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	kernel_team@skhynix.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	Rakie Kim <rakie.kim@sk.com>
Subject: Re: [RFC PATCH 2/4] mm/memory-tiers: introduce socket-aware topology management for NUMA nodes
Date: Mon, 30 Mar 2026 18:47:23 +0900
Message-ID: <20260330094733.425-1-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <20260318122242.00004e0d@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsXC9ZZnke4Ot1OZBmumG1rMWb+GzeLu4wts
	FrtuhFhMn3qB0eLEzUY2i9U31zBaPN/6i9Hi593j7Bb7nz5nsVi18BqbxfGt89gttjc8YLc4
	P+sUi8XlXXPYLO6t+c9qcXLWShaLb33SFvf7HCyOrN/OZDH50gI2i9mNfYwWtyYcY7JYvSbD
	YvbRe+wOEh47Z91l91iwqdSju+0yu0fLkbesHov3vGTy2LSqk81j06dJ7B4nZvxm8dj50NKj
	t/kdm8fHp7dYPKbOrvdYv+Uqi8eZBUfYPT5vkgvgj+KySUnNySxLLdK3S+DK2LTkFVPBa4WK
	Sy/3sjQwrpLqYuTgkBAwkdjQG9bFyAlm3pk+iRUkzCagJHFsbwxIWETASOJVzwHGLkYuDmaB
	zawSD8/3sYAkhAXSJaZdmwxmswioSmzdcxHM5hUwlviw7zMzxExNiXUbb4HFOQUMJb5PaGUC
	sYUEeCRebdjPCFEvKHFy5hOwGmYBeYnmrbOZQZZJCPxklzh75A0jxCBJiYMrbrBMYOSfhaRn
	FpKeBYxMqxiFMvPKchMzc0z0MirzMiv0kvNzNzECo3VZ7Z/oHYyfLgQfYhTgYFTi4TVgO5kp
	xJpYVlyZe4hRgoNZSYS3e/qxTCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8Rt/KU4QE0hNLUrNT
	UwtSi2CyTBycUg2MStJX9pgu6V+aqzP3iHP4sbqX9z8efCO6JF1M+zz3EXkWt/UKJ9tP9dze
	v4t7U/OSM3nmoRvv/Q7Y+8bxxZMvfrtqajtSrpw4PJ3zwf9rXRHL0gW0M9L9FB/vtdh34tu5
	C14zzwn+FGWXM5/DJnuJ12rddi6jGrNtp7/w8zi8VbAzKRXtUZTdpsRSnJFoqMVcVJwIAGld
	VcLSAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsXCNUM9RneH26lMg9d7FC3mrF/DZnH38QU2
	i103QizOTZnNZjF96gVGixM3G9ksVt9cw2jxfOsvRoufd4+zW3x+9prZYv/T5ywWqxZeY7M4
	vnUeu8XhuSdZLbY3PGC3OD/rFIvF5V1z2CzurfnPanFy1koWi2990hb3+xwsDl17zmpxZP12
	JovJlxawWcxu7GO0uDXhGJPF6jUZFr+3rQAKHb3H7iDrsXPWXXaPBZtKPbrbLrN7tBx5y+qx
	eM9LJo9NqzrZPDZ9msTucWLGbxaPnQ8tPXqb37F5fHx6i8Xj220Pj8UvPjB5TJ1d77F+y1UW
	jzMLjrAHCEZx2aSk5mSWpRbp2yVwZWxa8oqp4LVCxaWXe1kaGFdJdTFyckgImEjcmT6JtYuR
	g4NNQEni2N4YkLCIgJHEq54DjF2MXBzMAptZJR6e72MBSQgLpEtMuzYZzGYRUJXYuucimM0r
	YCzxYd9nZoiZmhLrNt4Ci3MKGEp8n9DKBGILCfBIvNqwnxGiXlDi5MwnYDXMAvISzVtnM09g
	5JmFJDULSWoBI9MqRpHMvLLcxMwcU73i7IzKvMwKveT83E2MwChdVvtn4g7GL5fdDzEKcDAq
	8fAasJ3MFGJNLCuuzD3EKMHBrCTC2z39WKYQb0piZVVqUX58UWlOavEhRmkOFiVxXq/w1AQh
	gfTEktTs1NSC1CKYLBMHp1QDY+uube5+X0o21y7n/T7p65Oa1XuuiFu9s18rcrta+TaTvmma
	6kffN193FCTvvWN7kWnupF9Rn8QlHOdf/vFszZVL/P8rnKR+9AotvKZ+atnU5wJed+Nl38nV
	Pv/xIoSx6TET07qTnwKcjml65m/+csaeMe6TfddxvxrVyAMrb8ucvc1+dIXUES8lluKMREMt
	5qLiRAAqZ2b+zgIAAA==
X-CFilter-Loop: Reflected
X-Stat-Signature: 7n4ec9epfsmicxz8c8ryf1h7b54q1d7n
X-Rspamd-Queue-Id: DE8BD140007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774864058-184061
X-HE-Meta: U2FsdGVkX1+D208bB7Z2EZAXX9Zs04VhU5wSEFR+Q5kEgNw2RDw1q9JmjOvli7+t0SjKEJe+OSuA3DWYCPaAg8I9qtf8n+ImLQcmx/WtcljNhwg3Kplj34CX5Mu4bSDw/xG7kK/niM/Mnxa6EXE+hcexE7YCez35DlHo1oyLs1Npc3HRJAyLvQ3YnZksfhC5TpXtk6y45N0Q3ozBVGHISYYhqCvOXIEgGsYpIBsLHl4WMHECm0RrVJGg93c25ynsz6P3qxdQgV094lfdzGKaGZqLk2IxYQjl+kskte8OLTFvyikSCK48nSgW+AHH+UNHTwv7aN3hyBj0ufEsLN7krVh+yS+Znx8zIs2JN/KwtiPaKP7PYrzoyq2P9VFRBiU5DWUV/sxyXu0FGlxsuZ+gKGnOFDE5g3dZ0S9v6lU9wUtimco8odeRFIlazDLTo+DWK20w1qYv99NHb2AAVdw+5oyypfmo2eWNcuuvypoILHjq/YpOve02WjvJua57RooRm7f5Qy+93tpbTy7R0zdXVISzoVOSoYFMkG6ulJlbgj9MgTtmNmzWjrKS1W8De3fVNYoB/wvm08tmhTAGdt61rqhKvdOu43UHC6JvYh23efAqO5+2DKjTP5OuDAJme3OqNaJ1sLWC7fLOcfTa1KJIxf4bPkQeh5KwBQ3E3RZtDSAr8Z4a6EhIWU5EdZkCeJ/Tejwhh6O8NkDmSbJtO15JoDXbvy2ORcLKEuMCrVf0oDQFkU7Qvbci54zVr0Udn5ApgRyIZZDpK/Xa8mBr7O5OYKPu69h28vpVQvKeBbniwolHxwH+W6nFF9NpNdWpVHrwHvJtVIBpgN9gtoxc1+AKnxsXa+y5WsDEZLctVSmekl14aSKy+zb+vzhi4ekPXSV1klGQcBzd4vPxlCmQ+QtKenL5tb6eep8zGRPPeD0Jm5ab0XlE7IxOX1HyUXuOAtGTkLRPS80ED5r8weHDlWZ
 jWdu7G6W
 9dcoFh9h9EspL41mXFUGW4lD5wsFZH2oxsVPqesQhwPCwwReo7Wwa1xNqcsSPt7QlGX1N964uceQlABtdQ5fUiHbcb6yVq74UgPvc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 18 Mar 2026 12:22:42 +0000 Jonathan Cameron <jonathan.cameron@huawei.com> wrote:
> On Mon, 16 Mar 2026 14:12:50 +0900
> Rakie Kim <rakie.kim@sk.com> wrote:
> 
> > The existing NUMA distance model provides only relative latency values
> > between nodes and lacks any notion of structural grouping such as socket
> > or package boundaries. As a result, memory policies based solely on
> > distance cannot differentiate between nodes that are physically local
> > to the same socket and those that belong to different sockets. This
> > often leads to inefficient cross-socket demotion and suboptimal memory
> > placement.
> > 
> > This patch introduces a socket-aware topology management layer that
> > groups NUMA nodes according to their physical package (socket)
> > association. Each group forms a "memory package" that explicitly links
> > CPU and memory-only nodes (such as CXL or HBM) under the same socket.
> > This structure allows the kernel to interpret NUMA topology in a way
> > that reflects real hardware locality rather than relying solely on
> > flat distance values.
> > 
> > By maintaining socket-level grouping, the kernel can:
> >  - Enforce demotion and promotion policies that stay within the same
> >    socket.
> >  - Avoid unintended cross-socket migrations that degrade performance.
> >  - Provide a structural abstraction for future policy and tiering logic.
> > 
> > Unlike ACPI-provided distance tables, which offer static and symmetric
> > relationships, this socket-aware model captures the true hardware
> > hierarchy and provides a flexible foundation for systems where the
> > distance matrix alone cannot accurately express socket boundaries or
> > asymmetric topologies.
> 
> Careful with the generalities in here. There is no way to derive the
> 'true' hierarchy. What this is doing is applying a particular set
> of heuristics to the data that ACPI provided and attempting to use
> that to derive relationships. In simple cases that might work fine.0
> 
> Doing so is OK in an RFC for discussion but this will need testing
> against a wide range of topologies to at least ensure it fails gracefully.
> Note we've had to paper over quite a few topology assumptions in the
> kernel and this feels like another one that will bite us later.
> 
> I'd avoid the socket terminology as multiple NUMA nodes in sockets
> have been a thing for many years. Today there can even be multiple
> IO dies with a complex 'distance' relationship wrt to the CPUs
> in that socket. Topologies of memory controllers in those
> packages are another level of complexity.
> 
> 
> Otherwise a few general things from a quick look. 
> 
> I'd avoid goto out; where out just returns.  That just makes code
> flow more complex and often makes for longer code. When you have
> an error and there is nothing to cleanup just return immediately.
> 
> guard() / scoped_guard() will help simplify some of the locking.
> 
> Thanks,
> 
> Jonathan
>

Hello Jonathan,

First of all, I sincerely apologize for the delayed response. I completely 
missed this email while I was highly focused on debugging the HMAT and 
CDAT latency issues in the other threads.

You are absolutely right about the terminology and the architectural 
assumptions. Given modern complex architectures with multiple NUMA nodes 
and IO dies within a single physical package, relying on the term "socket" 
is outdated and misleading. I completely agree that this is just another 
heuristic, not the "true" hierarchy. 

For the v2 patch, I will reword the commit messages to remove those 
generalities and avoid using the strict "socket" terminology. I will 
also make sure the logic is designed to fail gracefully and fall back 
to the default behavior when it encounters complex topologies that it 
cannot cleanly resolve.

Thank you so much for the detailed code review as well. I will definitely 
remove the unnecessary `goto out;` statements and replace them with 
direct returns. I will also adopt `guard()` and `scoped_guard()` to 
simplify the locking mechanics. 

Thanks again for your time and the valuable feedback.

Rakie Kim

