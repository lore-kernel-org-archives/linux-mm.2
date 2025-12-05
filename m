Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D835AD339A2
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 17:59:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 140536B01A8; Fri,  5 Dec 2025 12:59:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1189B6B01A9; Fri,  5 Dec 2025 12:59:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02DBA6B01AA; Fri,  5 Dec 2025 12:59:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E1BDB6B01A8
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 12:59:49 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 619B71402A7
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 17:59:49 +0000 (UTC)
X-FDA: 84186180498.20.454BE1A
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf11.hostedemail.com (Postfix) with ESMTP id 90FE140012
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 17:59:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o3mRSowa;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764957587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LZga2sY8Qmp2/WVvb8+m7PCG2wK/ft532jEwDd9YS1c=;
	b=RZQOTe9K9SywTbDPMHYNDp6nv1nhNO2N30RgVHTYbcPrMz4h8cdqnJjzWO5oHO2jGkrS85
	Ps5r0FnFkCN5fszbYxX/VpzASuM6Vhn9BLbX7EaDMgRvW2z5jguA9l4ZGgVP6/Q+4oy7b0
	6j2/k3sGOdhYKf7lCK+IjDhJr69tANE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764957587; a=rsa-sha256;
	cv=none;
	b=ghcp4t88FRH6l+foHoP/d6yjCuPeQ/6++hScaPnKxSOFIppekkCu9IOK2GUXYq2urQdHpD
	HDSwEipfOiK+blk4VJjoAOajpL/R8CQLRW3FXwGeoMZZjZKWOD1bbwgrcbm5WWy7WiL7Es
	CBZB6wRVTB6JGVqumY+TAVlaPskikqM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o3mRSowa;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 5 Dec 2025 09:59:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764957585;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LZga2sY8Qmp2/WVvb8+m7PCG2wK/ft532jEwDd9YS1c=;
	b=o3mRSowaEdnSqTNDv/GCctEwZbze+Cp/dEg7ya4Hd5Y+PSfzxt0U+zKHu+prOtywXzZKwy
	CCI3/HlzDm+W/lUONFsJiNus+r8Pe2ZHpqSsmAYElGF1kSIHNogLu78kM8RBXuuS4follI
	RTOr22Hcutbcv9fLZCvM7haoxvcrFkk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, "Paul E . McKenney" <paulmck@kernel.org>, 
	JP Kobryn <inwardvessel@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] cgroup: rstat: use LOCK CMPXCHG in css_rstat_updated
Message-ID: <5i4ei2rbszdwlezpi63h5ksmckry27ffx6kfcg74qbvgjk22ao@2y2jeadg43y3>
References: <20251205022437.1743547-1-shakeel.butt@linux.dev>
 <aTMX4tycdzKlaqaH@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTMX4tycdzKlaqaH@slm.duckdns.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 90FE140012
X-Stat-Signature: rka3b8yz7uwm8mpuiijbgdaoo4xsmoh9
X-Rspam-User: 
X-HE-Tag: 1764957587-460573
X-HE-Meta: U2FsdGVkX1+Lda7baS6nNQrN/wHCq3tPhmSg+VVJCPhXIrmlh87Va585S7GDY4jvf3rMJRyPwxzQpnTKbnJ3/Sh9FMLL6di5sw5RmNz5gk0+Du7jbvX6TVBsDh7ugWvExMPrHfAMI4TM6GwLHy3GxB+Cztg3EfOZX3jW35PqJcDFiL/gAHr6cQiB+3KeT8gvSKrrlP9w5bf5TkJIsBL+t1ANqWyiEkg5QbRYs1YyNw85PAWJ4frFFZn5NTEhd/pbXPvmNwwpq7g9t1ICdjojmT91XMt0j0HMSd8Il+tsqQtVouLhcUC9ayqkJNlvH1TR7RKUhevBJOf6AakFIaRKx+slhLgRNYcysWTPdy1WFvCNinQj/A2MwfPQUHmFlZ/wIUxhr4QPAjUfnGBfDiJ9BRZErL3YP1hdwUlbbNNdENgsctrpDZg/ZeDlUdrk5okYMOfHthAwRBXYRJOsQSrT0CaiBH5M6WEpKxmQPV00bCooWQAS67kD3nzNp2589wVEvq/LyWYliQxF7QioAcHXYt5tv9bqgax87dwn0ZlA/dfmU0Ckt7kP94C6H5Z0L2n4OoJLItZS8mBAYgdpVui1r2s2zuGM6mLvuZQbkq969MSEqOV9BNZUhknBmaGpYUgIETKiMV0Uhvz5/gJ/tPIuACJGyefwxopTjEpRVFh9jtPu908Kqne1gW5FLc68rt5gXEHP1hV7ioRL3kwta+JMP2GLptrlNx0qiQSKiYMBnG5fExdjCcFz2HE92+B0hZ52JUMuNXSza5VQwDa4IJmrwcCSiTmlI2w99GzL7VV2qS7CVYbkFZicTX6olYr/oxaC37jq20bCC8JFGYV+xXgcSqMnh0reajD1pWOp76yZ8bu83UapK2kYaZdCkviYW7Mnefdq9zL7bHdGUkLWZdKZ2t/D7ajwPpHvkM0gVGNN38V0o5AoKCu/tTmL6vy91ZO//DD9LCIJcc9khZuuP7r
 Icb1aHRG
 DaJj6bYe1J2/8nqT7RnYZimqoCETojjNDYjIBApbnnlLlkY/tkZ3bDM52/uatXAL+YNrtmMSGjuBbRtkEtAleOva4baypLIFziRr0qtRxVFVpYwSvxgpGylS+Prne5JpF9/nMsVK1+GSL8Z1Pdt3rO2U6eJJ1RYtKU/Ebn5a4l7obGlDb7SaQj4NctDXajPnsHDoH7gJw6j+ecx1k3qp9+8ISagIz970gbbNM3CagRd+9AEurgs5GX6G3c0z5xGs18mtt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 05, 2025 at 07:35:30AM -1000, Tejun Heo wrote:
> Hello,
> 
> On Thu, Dec 04, 2025 at 06:24:37PM -0800, Shakeel Butt wrote:
> ...
> > In Meta's fleet running the kernel with the commit 36df6e3dbd7e, we are
> > observing on some machines the memcg stats are getting skewed by more
> > than the actual memory on the system. On close inspection, we noticed
> > that lockless node for a workload for specific CPU was in the bad state
> > and thus all the updates on that CPU for that cgroup was being lost. At
> > the moment, we are not sure if this CMPXCHG without LOCK is the cause of
> > that but this needs to be fixed irrespective.
> 
> Is there a plausible theory of events that can explain the skew with the use
> of this_cpu_cmpxchg()? lnode.next being set to self but this_cpu_cmpxchg()
> returning something else? It may be useful to write a targeted repro for the
> particular combination - this_cpu_cmpxchg() vs. remote NULL clearing and see
> whether this_cpu_cmpxchg() can return a value that doesn't agree with what
> gets written in the memory.

Yes, I am working on creating a repro for this and will share the
results.

> 
> > @@ -113,9 +112,8 @@ __bpf_kfunc void css_rstat_updated(struct cgroup_subsys_state *css, int cpu)
> >  	 * successful and the winner will eventually add the per-cpu lnode to
> >  	 * the llist.
> >  	 */
> > -	self = &rstatc->lnode;
> > -	rstatc_pcpu = css->rstat_cpu;
> > -	if (this_cpu_cmpxchg(rstatc_pcpu->lnode.next, self, NULL) != self)
> > +	expected = &rstatc->lnode;
> > +	if (!try_cmpxchg(&rstatc->lnode.next, &expected, NULL))
> 
> Given that this is a relatively cold path, I don't see a problem with using
> locked op here even if this wasn't necessarily the culprit; however, can you
> please update the comment right above accordingly and explain why the locked
> op is used? After this patch, the commend and code disagree.

Thanks and yes I will update the comment in the next version.

