Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D8E5CAC5AC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 00:00:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C33D18E0014; Mon, 22 Sep 2025 20:00:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE43B8E0001; Mon, 22 Sep 2025 20:00:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD2738E0014; Mon, 22 Sep 2025 20:00:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 959758E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 20:00:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3B304119427
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 00:00:56 +0000 (UTC)
X-FDA: 83918559312.22.948D7E5
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf25.hostedemail.com (Postfix) with ESMTP id 556F9A0010
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 00:00:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nbi9ITEc;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758585654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hCni9d/eLTgrwvyJGOCo83l5nU1UneMhuwcVyu2h7ZU=;
	b=LodUISQ+OKWPwUyhAub+o4GMXnbQO+AJPzujY77/YKpPcsC+Y1LZymgqvgqixFlb3lB1Nz
	9GRYylchM60ahHC0JjrBRPnCjxRUJYBlYusNulOCfBJpa8iSKwZwGx5kd8yy5g8HrQLhOw
	wnEyAoE15Fex0zt2n2DbEcpaamw8ZYg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nbi9ITEc;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758585654; a=rsa-sha256;
	cv=none;
	b=REoRCenvdw6v1DdXjREh5LDx3AiXVUFpPmQRNUUhmnpuRGPdBAUFsLeOmlTSW6x8XyOHSL
	bsVxlLno5l5GdaEEjhnD9W8X1V/xY4SL0zRrcSa4ddMg4oX8pXdVFhlhfS4p/QShd2CtpF
	PHYtk88dsqEE5Meu+4MVPOkz8nR2H+k=
Date: Mon, 22 Sep 2025 17:00:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758585652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hCni9d/eLTgrwvyJGOCo83l5nU1UneMhuwcVyu2h7ZU=;
	b=nbi9ITEca9rnd1tCCtP0aY+2jP9DfRuQMRhbjpXws3XvI9iUVKTjrzdZQoaHsMVQmiVlyB
	QswcSVIRWORB4DTVq21V9uuCChILFasgsvPjCHjwUeTdVPMZtSM0nIm1k/tUTzHVpF0Jft
	bOxd5Ys5tT3QGW6ugPwD/FNxVmVWlIQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Peilin Ye <yepeilin@google.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Meta kernel team <kernel-team@meta.com>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2] memcg: skip cgroup_file_notify if spinning is not
 allowed
Message-ID: <24cnhpqz7d6rnkyowfmlgbcx6mt3qaztsxfwgtwafnktbeikya@bex2bp33mub6>
References: <20250922220203.261714-1-shakeel.butt@linux.dev>
 <20250922160443.f48bb14e2d055e6e954cd874@linux-foundation.org>
 <552lz3qxc3z45r446rfndi7gx6nsht5iuhrhaszljofka2zrfs@odxfnm2blgdd>
 <20250922165509.3fe07892054bb9e149e7cc06@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250922165509.3fe07892054bb9e149e7cc06@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 3aeupcikdy6w35rsrgjjbc9agd6kwkny
X-Rspam-User: 
X-Rspamd-Queue-Id: 556F9A0010
X-Rspamd-Server: rspam04
X-HE-Tag: 1758585654-13578
X-HE-Meta: U2FsdGVkX1/GKVNYvZKYes1gNGbGS5yMmV8tr5G8hsXomRaBVys0tPf05fiJ4qc2xwXvnFDVhrg9Fmz90Q7b3KU3ha46p/D2nGt3VRhwZFjOvF/uo4T86Jwpeu/sAmUJoKnsMU3aSgkYWgbeLTy1eXCbE3jrk3xd1ibVzq8BIAa23icYLMUw7XGDsWUFFe1snjq2Vjt+frf79/CxmWTCxbOGWSCbK+j8mm05SSmNJUEDE+1EpM506ReWgGvU6lf/rwKNHOkqM1giQG2FV8RdQat4e6o08umC9hk2OfIsA7JfUK2db11iSTGwIJ1L5ldDpj9JXlFhMQlqkEnJOPct7EMZ83SrX7KptDWXe+7ez4+ITOeApUNnkLgWJcn/r47LqUnb5vcEoV+zavu3G2pUNetbsL8GySpthabIhS55cXyKwM6mrkHHQn8CpgSPY+LAROsAN3bQ6FFlq57tl0LhV3yVFRazV2CBKY/JJ2im1LuOXeLufYkwzPbX8on+PtQiF4/cLscc2ToozGrajnanv9mqwMXEZUTQ5M6aPdC10sgP03LqcXc6TMcROi5ry+04IoX2hrY/Smfs6le9jgi5URYnpNOHfwKbDooaYile5HTJygTGoGyB/R0GzRfddUQ1q9eMTnkw5Upk3HTJ09ZeInIsjKEHMYJe50j8fN/fyxjKZ1jj98X7Nk2fOfrSyvKfAmX4BILCw4FcGJ82be/VbG8M7n6rNItCtzKwBeNrXpv5JVMVnvSaFHEU8/lXmmCnxO7fE8x43bnhIj4yJKDLAmhttodUd43sTsD3kplyipdxLX40TOjKAj/2FpXtVbN618Qkr9d5T/SnTF9S5q3U8NcXwV/IPOhMJczi+ypmfz0yqv7iSIIs29O7WaLw8MhLoCnEbWObrA9OxgscIPA4XVEp36n9xbCsG29YM8v/flOp87o34R2UQkkEk4LUEUak7KrgYlasB4KQeeO5kpt
 ZWqVaI9J
 Q8A9tX5IyXFI8hZ3ogQ5pEARoMvA3/hFqi04ilkvJ2dsd4GV7Mlfm+JhUCtj0ZCejMnf/EU9BAtJ7mlJlfUVYv/lm72v5p+e82w5dH6Sflrkuyt1sHU5Pef3qpod8AIuf5tNNuQTm07P3YWTm9xkbYh7z3gZqsOIrUl8tDT9HXn6aDb9uwGI63eKwD1bWaqe8XZ6/f9CIn+9MQL/cQFZJTp4htJGBKBoEe1jhIFTOj8mFS6KpPpUUmaTVzYJR2Z7Tz+fDiPpRnCoSDfchbzaPyv4wQJzN/zDGGKABN/koKE9TylAFl9GScQafREYF5TQ2xHP+D2dz8H+Wd2fIAi6e6yKsKSfaTtuER/03bBucrnBCg3s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 22, 2025 at 04:55:09PM -0700, Andrew Morton wrote:
> On Mon, 22 Sep 2025 16:39:53 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> > On Mon, Sep 22, 2025 at 04:04:43PM -0700, Andrew Morton wrote:
> > > On Mon, 22 Sep 2025 15:02:03 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > > 
> > > > Generally memcg charging is allowed from all the contexts including NMI
> > > > where even spinning on spinlock can cause locking issues. However one
> > > > call chain was missed during the addition of memcg charging from any
> > > > context support. That is try_charge_memcg() -> memcg_memory_event() ->
> > > > cgroup_file_notify().
> > > > 
> > > > The possible function call tree under cgroup_file_notify() can acquire
> > > > many different spin locks in spinning mode. Some of them are
> > > > cgroup_file_kn_lock, kernfs_notify_lock, pool_workqeue's lock. So, let's
> > > > just skip cgroup_file_notify() from memcg charging if the context does
> > > > not allow spinning.
> > > > 
> > > > Alternative approach was also explored where instead of skipping
> > > > cgroup_file_notify(), we defer the memcg event processing to irq_work
> > > > [1]. However it adds complexity and it was decided to keep things simple
> > > > until we need more memcg events with !allow_spinning requirement.
> > > > 
> > > > Link: https://lore.kernel.org/all/5qi2llyzf7gklncflo6gxoozljbm4h3tpnuv4u4ej4ztysvi6f@x44v7nz2wdzd/ [1]
> > > > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > > > Acked-by: Michal Hocko <mhocko@suse.com>
> > > 
> > > Fixes a possible kernel deadlock, yes?
> > > 
> > > Is a cc:stable appropriate and can we identify a Fixes: target?
> > > 
> > > Thanks.
> > > 
> > > (Did it ever generate lockdep warnings?)
> > 
> > The report is here:
> > https://lore.kernel.org/all/20250905061919.439648-1-yepeilin@google.com/
> > 
> > I am not sure about the Fixes tag though or more like which one to put
> > in the Fixes as we recently started supporting memcg charging for NMI
> > context or allowing bpf programs to do memcg charged allocations in
> > recursive context (see the above report for this recursive call chain).
> > There is no single commit which can be blamed here.
> 
> I tend to view the Fixes: as us suggesting which kernel versions should
> be patched.  I'm suspecting that's 6.16+, so using the final relevant
> patch in that release as a Fixes: target would work.
> 

Sounds good. Let use the following.

Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")

