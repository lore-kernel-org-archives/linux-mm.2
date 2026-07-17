Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B7D5C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 22:02:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 145AA6B00E0; Fri, 17 Jul 2026 18:02:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11CFA6B00E1; Fri, 17 Jul 2026 18:02:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 033686B00E2; Fri, 17 Jul 2026 18:02:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D423D6B00E0
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:02:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 67E4D1A027E
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 22:02:57 +0000 (UTC)
X-FDA: 84999644394.01.D06994E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id CE35B18000C
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 22:02:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZlQ6ylS+;
	spf=pass (imf16.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784325775;
	b=yxe8L60JK9KfPxujNzT199h69S7KsVCJdaN2IWbpX1+ZM0tXibfOgebFeh3QNUsT8ZqMhk
	SFwkK7ZD1LMH6fJ+RjAwSptAK9Py7dtq01DkYFE7ujxIw+IKXNyKAZmu5ZoLtVFWk4SGVR
	I5+lzI3dMI2LDbQylwz3e+v+gq25ZUU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZlQ6ylS+;
	spf=pass (imf16.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784325775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vK0V6XdCn3VZKyqGqo603HO8YlBOB9rJrE2Ye6IoQho=;
	b=a14Ox/k/YgKFUBy9J1ybsQwdwf3Cj29Yxq8x8/WSEBxAKaR35Csrc6BJT0V2tuvXvbdJJO
	NX13PO09I+WOvKTeJWqPDeftS2aUMfkIWlpSKK77hw7kbxCivhpppuSlhvXFB2n2QV5GdH
	NNz3F68HHn4z6x5Zg+mRCgUGGvsw2v4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3143060A7B;
	Fri, 17 Jul 2026 22:02:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B563B1F000E9;
	Fri, 17 Jul 2026 22:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784325774;
	bh=vK0V6XdCn3VZKyqGqo603HO8YlBOB9rJrE2Ye6IoQho=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZlQ6ylS+qxrpG6MP60Ak8CeNHceJEr9xO9SMOpxRvMGFW4sF3apaOdzJliGRruGc+
	 uAA5I9+NtP33i6/eHULXIDlTL2cLk3X+FHzRpi9KlGLq2wavYN2oPWaLDo428h0RC8
	 ro+YhgGhNaFM5IuFDMRWGg8eBrnmLmPd1D11HyIdG8HkterFOeqpCktX3+XQ0Q1zOF
	 dlVDTWhRoqW44KpeTXQmbvfnAKKahYgbsuRC9XAwrBfHzOnOlNG7lb2m6WBhkTjLLH
	 eiU/d7h2FDFPBv3mlTdDtW0pPM5KY5AFi7X0znL9g+vJHmDXDW7RPgvo1a3pL9s2WB
	 Fok1KpRSmevgg==
Date: Fri, 17 Jul 2026 12:02:53 -1000
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brendan Jackman <jackmanb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v3 2/4] cgroup/cpuset: update some comments about the
 page allocator
Message-ID: <alqmjd3pKWewxtWZ@slm.duckdns.org>
References: <20260715-spin-trylock-followup-v3-0-fc4d246f705d@google.com>
 <20260715-spin-trylock-followup-v3-2-fc4d246f705d@google.com>
 <7f4e784ee2bbbc23b4b97913e144c0d9@kernel.org>
 <alplxFeazzK_Ziie@slm.duckdns.org>
 <20260717115348.9ff2498eafb8ea256a0cb504@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717115348.9ff2498eafb8ea256a0cb504@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CE35B18000C
X-Stat-Signature: hz4ykyw5mqmwy5bghgo48akkajk4pp3d
X-HE-Tag: 1784325775-284480
X-HE-Meta: U2FsdGVkX19LhBy6h6upKWslH9kqnaTpKfUCYYaJ1nAl4BVa158z1wpYW4Wdr4L4JntK8cg3NKV2i5C3SLBbce1gT3BVx3cI9gm5WLkg6E/7wZQ5KssuHKbiBFQxkI0VG30gjgBrcV63y3vanuuxG2IqdL+vm6tOv8XDs8Zl+X/pRe5XOGXzlAJhvHV8VtYwyX+MdIzCO08CpGmWODfHkcBmNVXBI8RNddV2aHuEhysuyDOrl1LSzW6veYqDtEkFfYR3BqIx2WXsmfCqCJNdyZp4qjbPmWZipk13Bq9SiGdSv8/TaxQi+bguyGNku1qS6AhGV8jy2K8wSbcwRA13nxXiJzJfp0XEOYJ7ugfD8qYz/mRGSf3euKyTPGA4wkefvm/SHEKQXCH18U/O8knUyETToFIVCPIF6Mo/LbfUku+UNFH/MsSKZL8MLXuA/pmcNGIRx882NOtFOs/YnDWgDj8pHMP3AAC2GN4KdAEXuCi2dQ22Zg1n+wnJVzmdsrpJKq4KTauec7HGV7Fr4HR/4FyFr2m4lOaDcfyRiK1ukAKmjnwn9G8qDmQ+gv7j7VkyiuV1QIog+/WTyEsbOSIr3LqBeU517w+OzKMFxYf0QbpdmJHdPG+88pmFFSqQ8P+0+rLGv8tbrlFppaysDU+v8KVIvfbJGnDfDCSaeYho/w7ON4BepCCgSs2JvBV+yZ74i8qMnytviGZRVK3qm/1tsR9eeD3nNqrUJzROa4hhC0Nvp8Ky0cl1ADKiLGkwHvdOt/5QfK05abKFTQb5jy9r0/6rWolwhvHe2bK2vGjnRE0tjp4RQPuW3l5ZitPKN6p24YiJi8TzXAHByaTgUjVWvPvUAYNP/BpMip4MKFnw6tj8OtXVSYEieG5hHCuoYTh81mgEs5dmoUfoWR0cOx5kOW9cQXdn24HUDBTkyZ8tkX+UrPSJW0AYtgTsPdjsUb7DFSQlHvD3qqpQOLwg2/0
 T2tHOUPp
 0Jp0LKlDYaPKd9aPIJww/3f1ngiLB/HIyn+fhmd+ob5aofov7suKGaIJKU+KJiPfxNt+r8IVZlsMCkZEmr4mgLAq1JQdkuHv7a6DWukX/NDMRo0iM6AgHeRO7wLpTJ2jf8NKq1qcCw50pAUHRBRFE2yCdbMQCb66nDcnw+Pfvxeo1ROSQ31o6B4auahGSc1XG+24J4+h8YaZky96n/MJlRtxCIO7TODENBlPygS5U+qNyuXE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 11:53:48AM -0700, Andrew Morton wrote:
> On Fri, 17 Jul 2026 07:26:28 -1000 Tejun Heo <tj@kernel.org> wrote:
> 
> > On Fri, Jul 17, 2026 at 07:23:58AM -1000, Tejun Heo wrote:
> > > Hello,
> > > 
> > > Applied this one to cgroup/for-7.3 with Vlastimil's reviewed-by and
> > > Waiman's ack added. Please drop it from the mm series.
> > 
> > Never mind. I'll drop it from mine. Sorry about the noise.
> 
> Thanks.  Plucking one patch from a 4-patch series is awkward.  Better to
> retain this in mm.git with your ack(?).

Yes, that was a tooling problem. Shouldn't happen again.

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

