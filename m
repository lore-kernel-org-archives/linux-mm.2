Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D04DE7491E
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 07:52:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B95DB6B0005; Wed, 24 Dec 2025 02:52:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4D756B0093; Wed, 24 Dec 2025 02:52:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A96EE6B0096; Wed, 24 Dec 2025 02:52:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9D43F6B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 02:52:10 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 62D2EC15E4
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 07:52:10 +0000 (UTC)
X-FDA: 84253596420.19.C518829
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6813440004
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 07:52:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p1E6RkpV;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766562728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i/lDtdAtPPF7+SDKZunXkwp0QGMQGfz/2ok/wwdNYJA=;
	b=47EnHSv7h2OBAvqQNeLfpQFXQSD2u20UXIw8HYIFcxntCmRwVlsZ2h51/6obOgOPjTP/OV
	PtiGbAGXNN+qQUZD9Hxa5g0L0EvhxKpu4ZWu1twKCEOhgodrtwgNQP9Zix7v6jE33VQaWm
	PFvpc6qmCn+FHyd0klh+bcU+DL8F6ns=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p1E6RkpV;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766562728; a=rsa-sha256;
	cv=none;
	b=T1j4JtXEyidpXtK98ebG9qXJwSN4p1rBNl1Ikaqxa30FJiVyMRQ6RySEBGzS2M1jehiuZn
	glvJPdMTEgkSHr7kxftaEJJ5rTvebbu3/oQk0LlFctzhKl7jZVSQMw+gGnovXkgHi58cYg
	Dh7uwApZg7adVOG9+tUInpMRxBcJDYQ=
Date: Tue, 23 Dec 2025 23:51:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766562726;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i/lDtdAtPPF7+SDKZunXkwp0QGMQGfz/2ok/wwdNYJA=;
	b=p1E6RkpVDglhbWVaBwVBhlcUeupT2wNmuGapdOD/namnR8Lvq6ZA1qkD9FWmc+nXxU9wxY
	OSuA8MtNUOu4xs9hYttlTvaMlfS66Z7JYEyCsrlcLHM41/KqM9+Mfm4wd5Z/8neYsPDKpJ
	tMP0qkOCdq6P479gciE9KIrCirgPZs8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: damon: get memcg reference before access
Message-ID: <peusxpenpbjdnhr5nkgvqtiuuofmc6khsxsxxvj3k3eyledkft@kgvgid53zbbg>
References: <20251224034527.3751306-1-shakeel.butt@linux.dev>
 <20251224052148.68796-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251224052148.68796-1-sj@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 5foprj7zkdkax95n5oskbj3oz5tqp5de
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6813440004
X-HE-Tag: 1766562728-83225
X-HE-Meta: U2FsdGVkX1+Fs4Xiht7IkAvBOjZ6XogQjQWepWNb7n1hz5PJDoplOjSuz3ytW8p7KSbukCmpNhu45nLsqb4Sm9gNClBLACWC8O6Y7Vf1n3UppHmCiJsbrmMl84t37GpPlFeHTjAT7djdPtXidGVcCGIYm5myVn/ALXLzNdGs1MWKrG4VQCl90loBsAfQA5YiXLRUKv514h9PBN507SrXuG3YgbPUbLHQQjKSFkN2CYXfN03luvyOkL0NxLHqbuQU8QDkx39TK0RPCsGjLjPQncKcV0nH48zeEXNmF5TA6msLk8hX2WzjSq8HstjEEv4BRiznslrBkq471UxNXPsN0e0wqmOKXH2yi9RoXsRyxK/l2O7cQZnw8+F+cAOOmuLYoYc+IKWlhuKhL6YZwFhV/jwqgfxH1TxDs3ohAVwfnR+f/YySi47MD+Ccd4+SnQMEilcSOjFBqZPKSNbzBN8zdFd63EvHquAeSI/CTmnhbWTCvDZndGOkZJ4U7RI+5ycCeJMv5cVCk7HbWD7Icwa5lqq2QVAEul1b85WkEpaZ55bncuTjcq84G0z1TyfpsdUKEDcQPoWgF3HSwysl28keIN1/ROqgmlpKYXb7TL731RhsXbMiVu9RachEWPIXvRda9yiKz6SyZATn9Wld+Np3LCIiJhxLCeSsP0B2G3WqtRn86hqgOiQr0CqUTHbf69JEprMMzafe4yrm445gccLWD6z6Mhkh5dBIZha4LGLshijr08LvIarD0UfQX9JnNs10SOAsHgNnxkXLySKzsxhBbxCiAqTP4rKfCT9tJFjkQEMbfW+ESC3n+xiM2paS81EWRWycHnfbZMQ9XPtGkbck5PBmbcgMujV8WyyRD1kFn1aCQG1d+7p0YSvjtoah9n410BYUXTgsoMcZrmgDa1Qb0GO3W5KFasRdvHMhUyE7Hh+pT7WvT2JP/w8+z/6Fsy5NtpMJh1z6E6yYTTzAQFo
 fMcp5MGS
 yIgyQCNTTLxlmXVaiCoMCAynt4KIRIYTaKRzzy/bH9A9Hk9Q4ZPea1nDtnP9dh7RW3toffgriZA/CR4/28tVJBiv3pLY8G/SjWPz5QODVh2YWsKePdHS7aMIzfynzLnlkcTAXugbmS2O2wxnjNxKmMZIZCGdrbAGkLvmzuhNGa/Pc87OUSTGwQbTIqbsC6dPSG68GZ2nSB24iH38ScbsdaLeoeOSbSD2USikk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 23, 2025 at 09:21:47PM -0800, SeongJae Park wrote:
> On Tue, 23 Dec 2025 19:45:27 -0800 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> > The commit b74a120bcf507 ("mm/damon/core: implement
> > DAMOS_QUOTA_NODE_MEMCG_USED_BP") added accesses to memcg structure
> > without getting reference to it. This is unsafe. Let's get the reference
> > before accessing the memcg.
> 
> Thank you for catching and fixing this!
> 
> Nit.  On the subject, could we use 'mm/damon/core:' prefix instead of 'memcg:
> damon:' for keeping the file's commit log subjects consistent?

Done.

> 
> > 
> > Fixes: b74a120bcf507 ("mm/damon/core: implement DAMOS_QUOTA_NODE_MEMCG_USED_BP")
> 
> I was firsty thinking we might need to Cc: stable@.  But I realized the broken
> commit has merged into 6.19-rc1.  So Cc: stable@ is not needed.
> 
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> 
> Other than the tirivial subject prefix inconsistency, looks good to me.
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>
>

Thanks.

> > ---
> >  mm/damon/core.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 4ad5f290d382..89982e0229f0 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -2051,13 +2051,15 @@ static unsigned long damos_get_node_memcg_used_bp(
> >  
> >  	rcu_read_lock();
> >  	memcg = mem_cgroup_from_id(goal->memcg_id);
> > -	rcu_read_unlock();
> > -	if (!memcg) {
> > +	if (!memcg || !mem_cgroup_tryget(memcg)) {
> 
> For this part, I was thinking '!memcg' part seems not technically needed
> because mem_cgroup_tryget() does the check.  But I think that's just trivial,
> so this also looks good to me.
> 

Hmm !memcg check inside mem_cgroup_tryget() is a weird one. It makes
mem_cgroup_tryget() to return true for NULL parameter. We can not use
mem_cgroup_tryget() as is alone here.

