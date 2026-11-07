Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1C48606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 23:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lqXFDyDV
Received: by kanga.kvack.org (Postfix)
	id D742E6B05B3; Sat,  7 Nov 2026 18:04:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4AFE6B05B4; Sat,  7 Nov 2026 18:04:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C63856B05B6; Sat,  7 Nov 2026 18:04:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A71CE6B05B3
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 18:04:15 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3F665A0399
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 23:04:15 +0000 (UTC)
X-FDA: 85409853270.22.044F4F9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 967681C0009
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 23:04:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lqXFDyDV;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794092653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UKOheFdZkwgZbCvgxDw/KrEQq5eknMllMtNA2ffj/I0=;
	b=PulMeVr+bEz0gp6uKEWUxD0czktYtH8bk+NhWjNbBXMQqeCdZnPbew07YErjwt320eShAM
	Za0/WTQQoJgmhQEpiSpyElz9T26+8+tilDWJWYpmP9iR7AWvXNdPNNI7tGA/6s1GYYIwUu
	oJzDDt/0Lpg6120t6vZbQssSb3wbB3U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794092653;
	b=u/yT3xlMYqG/RVUQ7UcWX19fmrIMJZn8QkO2IRROYySLERetWqVuJSM/EzcpL8r/N1FICr
	OrYJx6vZEyHTLJUPhMI2LIELwfsJPwcMXub2UoW1ADxI+8tZ/ZSQdhE4lN3Z3vmBJKt9UE
	HToP3sWz1w9JLq8oyIOBRlQ/iPQgir8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lqXFDyDV;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 21EF261213;
	Sat,  7 Nov 2026 23:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BDE1F0089F;
	Sat,  7 Nov 2026 23:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794092652;
	bh=UKOheFdZkwgZbCvgxDw/KrEQq5eknMllMtNA2ffj/I0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lqXFDyDV9otA+OWWxyegWyB2sC0/phLyMCIu69a/z/18CcyyzQHkRiRwLNAU4uT9x
	 UHmK7u7+y6j1MNI/A2UQAN4HdnMDn8tCIO3z2TvFbK4XPsMn0aF+kZOlGS810H+alZ
	 oMI2C8UdG5ZSu1ET+OgQwZvDc8zZz+pZh9C9xwePCd/4hCJhqLtsmEOOCMVd0V4o9Y
	 x2lA6i6eCj0auShuv8ePOU+93xYhtm50RIIRHSDdX4M+7f2YjPok+TRGUXUtIFfcve
	 MIX548aVJMghxoE/I2gJz4+uUST8UZSgeeA0+laDNPVOk+Ceoe/W8N3NMlefqlC8jO
	 263bKfaqOVWqg==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 6.1.y 2/2] mm/damon/core: remove unreachable damos charge_{target,addr}_from
Date: Sat,  7 Nov 2026 15:04:04 -0800
Message-ID: <20261107230406.340832-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-203374@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: q4wy36d8tagb4566f8d7osh8p3sz6dgq
X-Rspamd-Queue-Id: 967681C0009
X-Rspam-User: 
X-HE-Tag: 1794092653-936541
X-HE-Meta: U2FsdGVkX18ZczGiPpM9qdJ5UInCd3K/DYa4LHR4zI4M0e2jjaMp8ovU/7fGfGl1YfrNPXn1gHHopcg1rG1+PYK5XIhYWjCLQcZrEG+zY9lIwbmhHkk5bmeRMP+drwBg6rYsw+GUc1MwuxhTuW8NfON35oc3KEzHnfS8FsH+xstrZnboHDwCyIv9m3AM0ab+9FhZvWg9AKdjo/vOCZffekh4Z45axyv8unu7ySiqtQEJvs2CenycKzQ6b1yqfqEoPV0qr6rUQIc2Mf4M3QInc4gAGouv2+xeGZSMkr3mWDOOb+7t3vl2sdbKcLRvnMNFC2daAws5fwxwg8LFt3xJW/BKd5+1oncF2DWpxaWcgzk63mARRvIYY2Uc2Q+/CaVkyfIZMbiWENYdT6Kuy+dpzFj+EVTHxPXTx71Y9nP9YN+0sQpuevFt1qwcWrxcr3FHL6063iq9VUH9A7OMWt5Ekgv3+BAhRgCVFjY3NysgQ6FE0xUUnvekL8lRpcYNTz2eopnsHKfsLqed8+E8J138jCfE2nSbZprteaO4Pe5Ti8auvfjbq9nvXNqL6dILxsw3fpgg5jLHnnXP7mtyj0SjnuKuu1jhKs72n7TLcNl6igt11JR/Ak1LLdkEyweDbVclR8uiqIlmQ0DsgI88lEeZhA31zTXRKX+d8wH9GgLsMsp/4BCVggjH+riZZgUjiNmxSRJwkonSwRl6WBSh6y93rPvN8leQe+krI+4VHEIpep5Eb8jVXHneSX/gTJITU6NoKogHXOw9IN6ua2AdJxzmVzRcp2YSxo5nRSIPhAkCk8al0iMhNbLWjvyYHpHGbRWHsY2i5j0Fb0KUT67Z126Ve2OZuVrWaFh/DfxoTF1IEtHtQKtaYLcumqqDhm+aJ9tABB+Owif29jjD8aHzq3QlBTfh7PUo+TVpDpeutTqZFxIlm1vcnRrZs4O7fX7qT0gqrts/Z9cGbaG9ZMquqiV
 e7VS9XiT
 i2+sOcN3Z0UvjTcMjnBLfrvQc1WJePA5bf9k2gPztyjRkoHkvPQnaQ4AXXjYMH84JHmJRUGXHmtBCuiZjKgpoFPtqSfRC/xYEMNdlkLyspyu+U3Ej00HEPe2VMCGQucd1AgcsMZlQ+hWPqm7Nu67bqGUnmHUh8TMalWgge3APEr7OktvD9GjOB0r0u3fccImrrViTKZ+b3sSPUMB9QlMwnP/oWqSRCqBiNUga9VEqcHlNnCIh9x2tMFNXQIU3B6VNVBnPMOEd/m+fvang48k7Nv6lNAB1Vq7jlK49niQOKkToNps95ixdy6FU1nM7gcTY0v0Kl4EZ3PjGJoz71gMsEBgGDzOfkTIFAVx+68VPY2lS/KuKvjt/8PLP1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 07 Nov 2026 23:02:33 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] mm/damon/core: stale charge_target_from ABA reuse when scheme
>   is inactive
> --
> 
> commit 853b3e89da132f2ce03750bcf6dfc1f62a70d261
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/core: remove unreachable damos charge_{target,addr}_from
> 
> This commit adds damos_fix_stale_charge_pointers() to clear
> quota->charge_target_from and quota->charge_addr_from when the referenced
> target has been removed or no longer has any regions.
> 
> Link: https://lore.kernel.org/20261020023958.108276-1-sj@kernel.org
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 9206737d05ae7..01f93146b92fe 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -860,6 +860,26 @@ static void damos_set_effective_quota(struct damos_quota *quota)
> >  	quota->esz = esz;
> >  }
> >  
> > +static void damos_fix_stale_charge_pointers(struct damon_ctx *c,
> > +		struct damos *s)
> > +{
> > +	struct damos_quota *quota;
> > +	struct damon_target *t;
> > +
> > +	quota = &s->quota;
> > +	if (!quota->charge_target_from)
> > +		return;
> > +	damon_for_each_target(t, c) {
> > +		if (t == quota->charge_target_from) {
> > +			if (damon_nr_regions(t) > 0)
> > +				return;
> > +			break;
> > +		}
> > +	}
> > +	quota->charge_target_from = NULL;
> > +	quota->charge_addr_from = 0;
> > +}
> > +
> >  static void kdamond_apply_schemes(struct damon_ctx *c)
> >  {
> >  	struct damon_target *t;
> > @@ -890,6 +910,8 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
> >  			damos_set_effective_quota(quota);
> >  		}
> >  
> > +		damos_fix_stale_charge_pointers(c, s);
> > +
> >  		if (!c->ops.get_scheme_score)
> >  			continue;
> >  
> 
> [Severity: Medium]
> Can quota->charge_target_from match a newly allocated target due to slab
> address reuse if the old target was freed while the scheme was inactive?
> 
> kdamond_apply_schemes() skips inactive schemes at the !s->wmarks.activated
> check before reaching damos_fix_stale_charge_pointers(), and
> damon_sysfs_set_targets() frees removed targets via damon_destroy_target()
> without clearing charge_target_from.  If an online commit removes the
> target stored in charge_target_from while the scheme is deactivated by
> watermarks and a later commit allocates a new target at the same address,
> damos_fix_stale_charge_pointers() will see t == quota->charge_target_from
> with regions present and leave the stale charge_target_from and
> charge_addr_from in place.  When the scheme reactivates,
> damon_do_apply_schemes() will skip targets before the new target and
> regions up to the old charge_addr_from.

Good finding but no real issue.  Occasionally starting quota charging from an
unexpected target is no real issue for DAMOS in my opinion.  So, no blocker.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261107224800.340250-1-sj@kernel.org?part=2
> 


Thanks,
SJ

