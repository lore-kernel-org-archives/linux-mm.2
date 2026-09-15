Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72524C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 10:22:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EAF66B0088; Tue, 15 Sep 2026 06:21:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 175AD6B008C; Tue, 15 Sep 2026 06:21:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03CA56B0092; Tue, 15 Sep 2026 06:21:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C9ACD6B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:21:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4775E4036F
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:21:58 +0000 (UTC)
X-FDA: 85215605916.15.8F118BE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id A64A240008
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:21:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cQuaEnvy;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789467716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fkiyvcxknqqa2FD78gZjvgffhDSvTiUS9a23EkmipXA=;
	b=vPDUebHegF2keeUz3bJ1JfWu4E7ou/hsjxBRrkJgudIg6BW6wLYlhu4acX22KlAlNWOoH8
	1/qwRpWEZ5vxvTvmqXCZTv+KMATLlfqJf7xWRPmIbpwhiPsKY9/+kMgP1GRuXXd+ne5uHh
	UH7RujHk3ht+nWs2DK46Eu4NYVtjaXM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789467716;
	b=Sp+OcQo4rN2IHuLfu9fah/0KZrICh3bEcWSuwpABXeYdvAtWcLdzftlCSmnWpqxL9SZ4e2
	RRo7K05NNVcHyAeG4Nq0nWzVY1kU9kzajB9HO+tJqyalz8anBgux/6CSkHZgNt1EJlXKMe
	BrkPZgnIS15/suIKWzYz/2w1cgdaFME=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cQuaEnvy;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BC63B6025F;
	Tue, 15 Sep 2026 10:21:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E3A1F000FF;
	Tue, 15 Sep 2026 10:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789467715;
	bh=fkiyvcxknqqa2FD78gZjvgffhDSvTiUS9a23EkmipXA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cQuaEnvyIVzF1iyxdJAkXqhmxDCZYMNY9j2eYZJ07Mb6eI4uuD6iCsTsS+XpIax5b
	 wX76OJsUvCoHl44rzpGGKNbDUnkQZdxlMma60wLmSTyYPzGIgHgsFm1eUQU//wGMlD
	 XkLaNUmR9cJYUhhJcYebFLcWjw6QOfQ2MYSbJYY0ycp+xgVXdunHq6/e+yfNYiUdxE
	 E6pJrCmbnIC1vM+8lUjIKIleVNO8CY3bc05B66ou/M/Pr3PYwIiSk/KWDfEyynFjl4
	 Cymr2wIIm3yXem2ANvwX2ZqgPbMUlLxxmycHSORHJHSC2b7YT6yQ8S03CF/Yj4r8FR
	 9HL8UnSyELE5A==
Date: Tue, 15 Sep 2026 11:21:53 +0100
From: Harry Yoo <harry@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Usama Arif <usamaarif642@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/cgroup: ignore memory.reclaim -EAGAIN for
 zswap writeback test
Message-ID: <aqkavo7OfQdMOpLf@thinkstation>
References: <20260914-test-zswap-wb-ignore-eagain-v1-1-6fb715c22cd8@kernel.org>
 <20260915001817.101713-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915001817.101713-1-sj@kernel.org>
X-Stat-Signature: kt7yxdpxfw48a9xcknownc9j8nedrndx
X-Rspam-User: 
X-Rspamd-Queue-Id: A64A240008
X-Rspamd-Server: rspam03
X-HE-Tag: 1789467716-258836
X-HE-Meta: U2FsdGVkX1+zDj+G3FDkoMRhmi2mjTY6ujMtlVjTlNxn3tbV7aLvvBmNSVdpJXC42zbEjBmx/MPcARwVFysogiQ7ywfETZfJujD+0IrEaIKiEQUoPeXQYSQS0pN4fNX4z+47tVM84Oi8oDW8rnQrlpHcURmqrNeGogbWxjta2FGsiYE9hxNEKuhSHvwF6dwDjJnf5iJn+/CWRqEg+Aywa7yg8mTiipeKmHlNxsKRi/rEhUaXrsT7RHGRiJ/P3okN7lZ/VyeYTOhxnzJqQVKq/xHoVi/rhpB7uDgSN3FZeBMTJjhVjPWu18ajGJbcmdcGy9HXI0FuYh0v6DmC6yyZUNJGuKq9EEx5fjjHezs+V051stGDmG8y70L6BNVME+9uMdDo+4ABmonL6m/XBlnD8TtJTRVn1tZAwzt7CjaadN+y4mCgIxjEfDJNXLn8yUM733ZDp0zH9Io9gniRo+8C+CtO1Oy/sXrhSmmZgOKPbsiFzQMy+AiiG/OFVLPL/b0J34y9eHWa9VdVQ+bWkf9qLSCVfIAf9W2PV/fdgzcSeVm5b6aRT/1UYOGQq6m/zjpLYbUp2az2SOCxUGrhJYPb6wvPeaLvJl8UrHiYJUZdQ5VqnRufPZ/3DOXdB1pygFbZi7sgJnn9aRsHBOQ+KdJv7Y8Ao+dCUaUTvJntZ4WmBA2avBbdqGaidrmdiEIlBFmSEgLFNXN9UkFl17nmRrKxSqYpcljzMLvDM5EIR0d6gawx4b6gemmb+/RTVuVEr+y/EhvvaMm+pNNw8ex8G4y+eVrO9pB8Fq0TW+rWH81WzZDDxY/IkTBbUZtFX20aosLjVC79fmmHFHBna0GLgMt1i7ClpBTf9Qd4nagoj3OQd9RcrixL7tJKo5mEgbTklE4jPvNTVF0dJEF/l51W3FrPd6C3YRs/q7+AE5N74Q4uNyRLETCn5MVcPQLB+Sw4orXH1LXNIJRrXCD+WKzQFRM
 WanZEc+c
 t06oMhf2K85hQUvj3sd5lfgWhCwzbADMG8Z57FOluykJQsg5ahVf1YnRmvW/Cd6QYpMZsSm90hEdsYeHULaoq+yFDFdBsT1cwZRAlqz3Bi341rp14c/SbFLHFrX/vlzM79fjCXjYHVnnHxiHOT1oBUgtbe8BQ4gUKMr/LaA+pnGU5LNFJyTIDrGsu6+KDzYV5h+NGUcIyIY9H9FCjcx2sv4gxAvcUS2XWdbL3V//2kLFNbR6mh6ukVkpuW4Qhvvv1mr0uH6DmFfT9rs+IcEhsi/3aK3pSq+r3wWM1aXFPhj3SXNGpjQac7jUSMXLX8/t6fVkKtqF76UKUeU82QgSkQ4BP96TlssBL5OT4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 05:18:17PM -0700, SJ Park wrote:
> Hi Harry,

Hi SJ, thanks for looking into it!

> On Mon, 14 Sep 2026 21:36:39 +0100 "Harry Yoo (Meta)" <harry@kernel.org> wrote:
> Makes sense to me.

Thanks!

> [...]
> > --- a/tools/testing/selftests/cgroup/test_zswap.c
> > +++ b/tools/testing/selftests/cgroup/test_zswap.c
> > @@ -346,7 +346,16 @@ static int attempt_writeback(const char *cgroup, void *arg)
> >  	 * it can't writeback to swap.
> >  	 */
> >  	ret = cg_write_numeric(cgroup, "memory.reclaim", memsize);
> > -	if (!wb_enabled)
> > +
> > +	/*
> > +	 * When writeback is enabled, memory.reclaim may still fail to reclaim
> > +	 * the requested amount of memory due to a slow swap device.
> > +	 * Ignore -EAGAIN here. The caller determines pass/fail based on the
> > +	 * zswap writeback counter.
> > +	 */
> > +	if (wb_enabled && ret == -EAGAIN)
> > +		ret = 0;
> > +	else if (!wb_enabled)
> >  		ret = (ret == -EAGAIN) ? 0 : -1;
> 
> My humble eyes were unable to easily understand the change.  Is the change
> effectively same to below, and if so, would this be easier to read?
> 
> '''
> @@ -344,10 +344,11 @@ static int attempt_writeback(const char *cgroup, void *arg)
>          * writeback as zswap.max is 1/4 of what was needed when reclaim ran the first time.
>          * If writeback is disabled, memory reclaim will fail as zswap is limited and
>          * it can't writeback to swap.
> +        * Even if writeback is enabled, it could return -EAGAIN due to a slow
> +        * swap device.
>          */
>         ret = cg_write_numeric(cgroup, "memory.reclaim", memsize);
> -       if (!wb_enabled)
> -               ret = (ret == -EAGAIN) ? 0 : -1;
> +       ret = (ret == -EAGAIN) ? 0 : -1;

Hmm, no. This will mark the test as failed when a write to
memory.reclaim returns zero even when wb_enabled is true.

It's not the same because when wb_enabled == true we consider
ret == 0 or ret == -EAGAIN as success, while with wb_enabled == false
we consider ret == -EAGAIN as success.

Not sure we can reduce that to one line of code.

>  out:
>         free(mem);
> '''

-- 
Cheers,
Harry / Hyeonggon

