Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4EE8C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 14:20:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCFD06B0088; Tue, 15 Sep 2026 10:20:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA6FE6B008C; Tue, 15 Sep 2026 10:20:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE4286B0092; Tue, 15 Sep 2026 10:20:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 986D06B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:20:01 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E05AE403BA
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:20:00 +0000 (UTC)
X-FDA: 85216205760.23.DE280C5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3144C140003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:19:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XH97yrql;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789481999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QcgTXTTUvI8ONqxc9jbvCeetYEK34ysR8JYdT7Si4YA=;
	b=NzPXepidMmuo6+uN4Dn+hWAxVdPRR7OynMkSWa4RL3Sxo+bOM9kDdU4CzjaGz15fFfb67j
	5VOJMHLTKpRd0bcn827iR2SGuGnU8jUisVaiU6huGunWbD7gB609N3Ws8HrUbgamqpM+Ss
	1dHLA8ftYFbB+z7WIEae756j384Tihs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789481999;
	b=GVRgPmk/PxdDKBri+331IYWRXBc83luzYNIN7+GiIizKTvxU/A7i+/8+q1KX05ra3jgf8f
	4gPj7CM+/BQRtjjKvAO/q9es2MNrGE5rGCF9VYJ7IVyHCH8HQAm+pYFCnMcaA/ean8vgYI
	0eUutcF1LGr+NlSEXlERXZPCVdkFy9o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XH97yrql;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4BD5143D36;
	Tue, 15 Sep 2026 14:19:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CC01F000FF;
	Tue, 15 Sep 2026 14:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789481998;
	bh=QcgTXTTUvI8ONqxc9jbvCeetYEK34ysR8JYdT7Si4YA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XH97yrqlqW9680GKgc4K9WvLNVabunnNtw6rQYsqPH91xIeL7Z7d4PxLbPvUbyv0E
	 ksl92UZaozw0dst3Pt3Poq7XeAd3UcbsuPfVuomLzJS16NQydbeLwM/ahGUgrAICTj
	 +YaWlu0kKSq+05dJlFctlKjThXhPvglEOOAUW9U0eY/MJqIapFOVitZeZXyPcJQfXE
	 sRG9oh6ZKMajnuDxEpI4HWMWQ3VoOYeLrkbCzIJY/lx8OB5FzebLTb4KPY3Pl72Tyv
	 36ef6arjoqZ4RaPZGU7bLlGGms3Ni73RabSv4TAXq/dlJo1CxvK3U1kjniQiTS1zLv
	 L7jSoV84wcUbg==
Date: Tue, 15 Sep 2026 15:19:56 +0100
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
Message-ID: <aqlTZR90H-7OuSfD@thinkstation>
References: <aqkavo7OfQdMOpLf@thinkstation>
 <20260915141049.70696-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915141049.70696-1-sj@kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 9afoxh83gqpfyhkgfa7s811k9z8ctynx
X-Rspamd-Queue-Id: 3144C140003
X-HE-Tag: 1789481999-379382
X-HE-Meta: U2FsdGVkX1/kxDdvRHC6kgRlDnChqC5Ze/keBI1d3DSRfx3jE+oDnXu55WfoRyTaICugBgatIboNAgRqljXIvj7e9Z2wLMkbj3DyfwDsuWv0XLni7l5zy5L1XEUi6uFEhhJNrAwIZXcQrROHGHPWkaeLVxd+y0pifJyQZNDZ1PJCkYb5oj6tDHp6yY7UyA9kFsuPz874jKqDrXJqM3XLmxZJyVm/iUcelJYcI6vovrdDo6AxCduXyK05xxLRiR8UsXH9MQHXo+06fcOKYpXfqi27Q5dNjFWSlIaLrAdwIcnRNiyLRNkNhKiPpUF+a6lOdx2t+y0ualB7jOLPovTbHQUQmQdnF+V6fdx0GudDdGMYMELI5jvH8yzyf3APejTcI4IhP9dfRS7fm7vH2HJq06kwjfdDYacv/LDDBAErIB/6yS4QiFChd/p5yKRoBLTFH7Y8zmb1/gARpPh8eiqKeJ6dfWNhrXxsBaDo76rX9udcSf2pNSxSZGDW3eO4NwTUTZ1U8ViquogPGOvWu5ByvRaCzG/zSiab+ERWsSmLhI1Lr3HO4OynkpldqGeG+geAPI1DUYHpjJZjwi2OFkVLe+I2Y87G7Rq3HJhctS5I1QLOk8jfsWMyIBo/5hwV5CwLW0H1kYoXQV/BQAiXk2G1jY9UxqAfs9amwSoHbFvzi3csZOuhfZxQhtdl6ssWRQcfiKTxczL/OEmdB9bWDZyUFbmbsdJtVrX9XVsALfW0xbjGYg/50krcQucbJf/1PLoukXZvN58sRyjTVuqzN5uLKJA83UzMosTTbamAoiMFvy78mp1XigiPFdqqsvlpSnTZcW/Q/SxqQFkoTimf8t1UEZr0MlWkOxN/1xdhVd+u7ppIzMYodZg1GOjb+HmY7WEzZe8wquy/B1pEg2zhBYzLt7jOQPAsUTHCzG0X1XIAuWS2RwU7q/SsmekqqBK0bOZlu0EhAgMq9deb47gdwtR
 7pHdmss6
 AiebS3g3x1UFCXgfM/BxhhMTyHu2JcnR8eS+6akPRWaZn8ie7u0o977UUtTfW7Qrlr4uFBk+HIgdGgJJsiSUyol6itax69WRZUCa20TLVM0gDtXfUjUJ6/iZt8kgQ9yQU/fxppePLQP3XjZnR5+vSfeJQjJPotChVH1nmEOBG7QbzSmxnpaJSZdXKy28rFzPTZqspspNibVhNSwjl7aO3OW5iY2FKq2AzukNfLH+SSRQ6wi/toMRsj62cyz1gl4KUMPwIDKO5hqpq3Qik+QMzp5R9P13qaTq6gEFrY+3gZjB3HpEZXpmQaFwM7w6OtCCdgynf6nOQ/AAWQlctgZ15Lxb4MZ6NRm5hZ8C8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 07:10:48AM -0700, SJ Park wrote:
> On Tue, 15 Sep 2026 11:21:53 +0100 Harry Yoo <harry@kernel.org> wrote:
> 
> > On Mon, Sep 14, 2026 at 05:18:17PM -0700, SJ Park wrote:
> > > On Mon, 14 Sep 2026 21:36:39 +0100 "Harry Yoo (Meta)" <harry@kernel.org> wrote:
> > > > --- a/tools/testing/selftests/cgroup/test_zswap.c
> > > > +++ b/tools/testing/selftests/cgroup/test_zswap.c
> > > > @@ -346,7 +346,16 @@ static int attempt_writeback(const char *cgroup, void *arg)
> > > >  	 * it can't writeback to swap.
> > > >  	 */
> > > >  	ret = cg_write_numeric(cgroup, "memory.reclaim", memsize);
> > > > -	if (!wb_enabled)
> > > > +
> > > > +	/*
> > > > +	 * When writeback is enabled, memory.reclaim may still fail to reclaim
> > > > +	 * the requested amount of memory due to a slow swap device.
> > > > +	 * Ignore -EAGAIN here. The caller determines pass/fail based on the
> > > > +	 * zswap writeback counter.
> > > > +	 */
> > > > +	if (wb_enabled && ret == -EAGAIN)
> > > > +		ret = 0;
> > > > +	else if (!wb_enabled)
> > > >  		ret = (ret == -EAGAIN) ? 0 : -1;
> > > 
> > > My humble eyes were unable to easily understand the change.  Is the change
> > > effectively same to below, and if so, would this be easier to read?
> > > 
> > > '''
> > > @@ -344,10 +344,11 @@ static int attempt_writeback(const char *cgroup, void *arg)
> > >          * writeback as zswap.max is 1/4 of what was needed when reclaim ran the first time.
> > >          * If writeback is disabled, memory reclaim will fail as zswap is limited and
> > >          * it can't writeback to swap.
> > > +        * Even if writeback is enabled, it could return -EAGAIN due to a slow
> > > +        * swap device.
> > >          */
> > >         ret = cg_write_numeric(cgroup, "memory.reclaim", memsize);
> > > -       if (!wb_enabled)
> > > -               ret = (ret == -EAGAIN) ? 0 : -1;
> > > +       ret = (ret == -EAGAIN) ? 0 : -1;
> > 
> > Hmm, no. This will mark the test as failed when a write to
> > memory.reclaim returns zero even when wb_enabled is true.
> > 
> > It's not the same because when wb_enabled == true we consider
> > ret == 0 or ret == -EAGAIN as success, while with wb_enabled == false
> > we consider ret == -EAGAIN as success.
> 
> Ah, got it.  You are right.  Sorry for making noise and thank you for kindly
> correcting me.

No worries ;-)
 
> Reviewed-by: SJ Park <sj@kernel.org>

Thanks a lot for reviewing, SJ!

-- 
Cheers,
Harry / Hyeonggon

