Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AE8FD46BFA
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 21:18:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3A906B0089; Wed, 28 Jan 2026 16:18:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F050D6B008A; Wed, 28 Jan 2026 16:18:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF36B6B008C; Wed, 28 Jan 2026 16:18:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D06546B0089
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 16:18:38 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7E5021A0730
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 21:18:38 +0000 (UTC)
X-FDA: 84382636716.13.6099256
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6AD9940005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 21:18:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bA70FS+D;
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769635116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xp9Fgd2RIw247dmeHBhZGyViCdcfCoSm8F9wNiqAlQI=;
	b=xZv2KADCdj0SL5TngkdYkrFYzIND+4a99tq01GIKxtT6hH66QJ4tOlsxurUVBQooIsVnlO
	QlT6AgNBvUDduGePlDpxL/zS9gqCrVJmEiT1Wk066nnvuVn7vGkv45pUb3DsouXeDaw6BO
	w/8KqKBn4E6GwvFpCAewXjSDHXqVn+I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bA70FS+D;
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769635116; a=rsa-sha256;
	cv=none;
	b=A8egLogx0oz+F/KRVSndDKRiGi0XCMok5gje7+buxok+qVou1HP8yucSVdsVOThQQv0XY6
	OEMoeDwR5Q5S53eAiCScr3TH1i4pEm4M+KTFwrihN1Q2yLvQNTfEutlHHQUZdn6K0KZfex
	8yuHT6x0qsNyh7MTMIw3rDm5B6ej/rA=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-47d59da3d81so10166575e9.0
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:18:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769635115; x=1770239915; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xp9Fgd2RIw247dmeHBhZGyViCdcfCoSm8F9wNiqAlQI=;
        b=bA70FS+D53+b826iCY6qh/q7mVafAAytXPXtuyOc70aJFKyNJkaURgpDY+MfGXfAC/
         6Rgfq0jRDAgTd8olPAVuLoPsVvFnV0x0+cum5cwMx0nDsTSkuBS6gGG0gRBdi7W/jm0E
         PSwk3HJZvjGLOf+pv60CRrAjgvRRmPJVWBdLYzzQSmDaK2qLdpjdZ5xPKmaStgvdvJ2t
         rfnn1V62ChrJSxTa7jxNFet2ge2K+k162v0gmQCsuCraa0g5Y43d86DEKjlTqCU1nGNS
         4/k+3SEo+gh5HG54GL1XLaA0/Q3LkqStufhb3Q534LbZXVue4YZQH4Vzr5095U+Nw5/T
         Eo1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769635115; x=1770239915;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xp9Fgd2RIw247dmeHBhZGyViCdcfCoSm8F9wNiqAlQI=;
        b=CrtVa52uA5seIAJFlddhr8Hwc37iVwS88Dyjzlm3+6WPKVTG5A0Af8Yi0aD7/qNWYP
         nihxRwvsvh9x0zgkGfnQxpIGIB4SozcNiF9sWc1zSYY+lCK0uQRRCLSFCinRmQTG6LMf
         hRwYQgxmGtugYDQFCIKq83zoF7CV/eK4pcd0CH4epjdg79AIntloiCYXv7y2l7svUqMY
         Cqw5ptso9RrQMLfZidaQHiG+U/81RwEOcIOLNx8I7pZyE1nNQ1bbTO9f82aUjN0Y97Di
         LvEwi/tXvlGGHTG4bz7APk3ckpG4B7DnhegNxdvLxJTP/sjFh2u1/9+7Pq9b3JSXMoJA
         0zsw==
X-Forwarded-Encrypted: i=1; AJvYcCXnUTFUvclvMfpHE4ci2qLlExu388GGQl5j4fVPTavXMvn4hACV/0jZGkbqsjudnM4hcQunh1PCjw==@kvack.org
X-Gm-Message-State: AOJu0Yze4uCRR8bgC6bPFn5lGyx/afWifk1pA/ekv6zQ6s6RWww3i0lZ
	nQ0xFVm4YkWAXH+wIKPNjpdOlLqQixCcKrNW33RFkfSqmSqX6D697OE2LEn1rPmfoig=
X-Gm-Gg: AZuq6aLCO72t04pQMJkT80GQyGiCK+XGP+hku8ztWdGjM6JslVa7+ctgVR522ONY8LX
	mqacXfRbJitoxuzFD/wb3OWB1doeIMcQv9qXB2Z3exqn079Fr5oTkqY1ksXmksXcp/+T8DqAGaR
	N631ah8bbkef8o5LndbC4CVgWEydEh5fgfbn1xRp0iws5dIEHJeTyXw2OYijdqmvWLeQiw5qbCs
	s/Vtlb2w8O2o9HCa+I71G5j+996lP++stXzUNAjz6FBnsnA/7cJKIKOi8UjnI1IcbDy1hDRO2Tb
	JVamT9U2WKi3DpJBCYnShGvtuAieje7hPxWTIizC9TsQtYHVEpFKQVUqNWuSI8gjiwYWKNpPHuC
	2R1UMVWh5O6xdFoMn7hx/lPKKVLejQT5y93WPZk/K0DFvjNY6EWw3lPlz3genhcztRytCL/fGFP
	uf3GWuuBWDYkhFu5XkVOpRWgNC
X-Received: by 2002:a7b:ca47:0:b0:47e:e38b:a83 with SMTP id 5b1f17b1804b1-480828828dcmr6056415e9.7.1769635114891;
        Wed, 28 Jan 2026 13:18:34 -0800 (PST)
Received: from localhost (109-81-26-156.rct.o2.cz. [109.81.26.156])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e131ce64sm9991967f8f.26.2026.01.28.13.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 13:18:34 -0800 (PST)
Date: Wed, 28 Jan 2026 22:18:33 +0100
From: Michal Hocko <mhocko@suse.com>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Ridong <chenridong@huawei.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>, cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 03/33] memcg: Prepare to protect against concurrent
 isolated cpuset change
Message-ID: <aXp9KWl3VaNDMKPp@tiehlicka>
References: <20260125224541.50226-1-frederic@kernel.org>
 <20260125224541.50226-4-frederic@kernel.org>
 <aXeZQoSHJ9QX7B6W@tiehlicka>
 <aXizUsfywjtIIN50@localhost.localdomain>
 <aXnMj1phN3TJZkNz@tiehlicka>
 <aXnymtIZSc-fw1b8@localhost.localdomain>
 <aXp9CzgCTBEhlDqM@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aXp9CzgCTBEhlDqM@tiehlicka>
X-Rspam-User: 
X-Rspamd-Queue-Id: 6AD9940005
X-Rspamd-Server: rspam07
X-Stat-Signature: cwguk7j1tijrrkefnccu4fat7huwd8hk
X-HE-Tag: 1769635116-501135
X-HE-Meta: U2FsdGVkX1/si14T0mbtJP8U+xiFwcHfnFUfNMJPERJgc4ymrphHG9usxCLjqzqkI1v9KxodnDQzGj829h2LJnUaTl+5mFQPAcCLk24F+JyyDS1EQz1HtU4fA8Zq6IquOOHK+es4SS5empkkLfHYD7OPEyb/K/B43etJQzwnzJvIPa1o0vPrZOlaFlWQMlj2eMJKZ2txD9M6d9Jf7BsVOB9hvex7wB45TmNKcP3M44nQ3zDYWrXnh4+Fz0ztuHaTRDr2wuB1Y0gt2sOTEsEwUa+S3IMJkcby9suWOjYlN24Z1bIudfjkgWqxfHyEbzGCAl1CR7q22ddcI/dCdwQysoKLbVWDamjXYW5ppGR9wAVT1ZkkaXlIhAl5gC7TKUyn+rT7rzqG1wDAMGJcCQunnxwFLYE4iXAJlQFT8QuPtiOyuJrpHe77kbtbr4HbA65sq3aAQKfRc7YFXgxA1JeWOWvB538wdATr0XxL7NlcGDVXO0bLPrHL8bnK5KJZh61gDzHgyHWWjYZ0/WQI4/KAkyUjk9RXN1MNZwYlKb25l5hsqy9IvTjiT0koi7owc0+6n9LOf6CajNzZwh8r8tyy/+pdC5Uj+AOYSsoJ2aJ89Zf40SjepVzN5IsY2W6pq7XuTEXnVx51ufBg1o1lBM2G2L/h0Josb1gWGIW+LZqq8MORZBVC5WPEkTa+cMI4DgKdJkjovvyQJTie5s2Q8QKK2g6/OwDuhu71efzToW+v+SjYSbCnzJ3tVlc+n0UjWgyizFeAqDG64Cy6Mf/DexSx7uo7ybOWw07cZM/jylZa9vxc4MDuyhU79kiq1G87srQH8heqsOHzIZgNE2IMBAsHFWDn0py88y27yCXgGTOI3yA3bcL+x+KhPhJfUVYSj8izuMUqPPu9Rq6nG4bbEUlMa0/W5HC+nb6hBrDbQNGdmhDt71UvfzysbhzCljSm8vj7OhqR6qK636+1QxRnS8e
 VdLGZryX
 xsBt2zuwPREoYgJs9GSa3TOeZ5Fq3BSs4OmH9ltmXpKI/ovrU1xsSV/IJ5Ef6y2i4UjY68d1miUdUek+I5Jb1be6sfFxmY2LURsl0eocfBDBckSd1BLQrpWLM2BNCNxdsfOgpEzppe/R6ywXn9yTGV6K817bxsi9vlNyG3ZIsgxGO988b+H9jxFc7yAFd4ZjIFUbW5HIfzDIH5g9sjle6uVn/+daYvOA3tYkdl/gw7p6CG4u2IckiW7Qg9ETVfypWAfM0OmTR0d4Ksi/DoM4GKJaKfZuTYfpiyaZUbYGGTFTbRtFLeT4nFtz/AsGkRM0fdIT6W9Bi+rC6JtFmyldMFAOZySsGt768QwR2rnCMt9HANhBo+8sfmUdOfaI/6L4zA9aAL7d4nZeB8dmMjBwF5D6cq/XUeFh8b1ecgA2Caiahf1230nqPxZL71y6jpEFbxyzIt8gxsM3EMxMTuzMW8w1ERg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 28-01-26 22:18:04, Michal Hocko wrote:
> On Wed 28-01-26 12:27:22, Frederic Weisbecker wrote:
> > Le Wed, Jan 28, 2026 at 09:45:03AM +0100, Michal Hocko a écrit :
> > > On Tue 27-01-26 13:45:06, Frederic Weisbecker wrote:
> > > > Le Mon, Jan 26, 2026 at 05:41:38PM +0100, Michal Hocko a écrit :
> > > > > On Sun 25-01-26 23:45:10, Frederic Weisbecker wrote:
> > > > > > The HK_TYPE_DOMAIN housekeeping cpumask will soon be made modifiable at
> > > > > > runtime. In order to synchronize against memcg workqueue to make sure
> > > > > > that no asynchronous draining is pending or executing on a newly made
> > > > > > isolated CPU, target and queue a drain work under the same RCU critical
> > > > > > section.
> > > > > > 
> > > > > > Whenever housekeeping will update the HK_TYPE_DOMAIN cpumask, a memcg
> > > > > > workqueue flush will also be issued in a further change to make sure
> > > > > > that no work remains pending after a CPU has been made isolated.
> > > > > > 
> > > > > > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > > > > > ---
> > > > > >  mm/memcontrol.c | 21 +++++++++++++++++----
> > > > > >  1 file changed, 17 insertions(+), 4 deletions(-)
> > > > > > 
> > > > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > > > index be810c1fbfc3..2289a0299331 100644
> > > > > > --- a/mm/memcontrol.c
> > > > > > +++ b/mm/memcontrol.c
> > > > > > @@ -2003,6 +2003,19 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
> > > > > >  	return flush;
> > > > > >  }
> > > > > >  
> > > > > > +static void schedule_drain_work(int cpu, struct work_struct *work)
> > > > > > +{
> > > > > > +	/*
> > > > > > +	 * Protect housekeeping cpumask read and work enqueue together
> > > > > > +	 * in the same RCU critical section so that later cpuset isolated
> > > > > > +	 * partition update only need to wait for an RCU GP and flush the
> > > > > > +	 * pending work on newly isolated CPUs.
> > > > > > +	 */
> > > > > > +	guard(rcu)();
> > > > > > +	if (!cpu_is_isolated(cpu))
> > > > > > +		schedule_work_on(cpu, work);
> > > > > 
> > > > > Shouldn't this in the guarded rcu section?
> > > > 
> > > > This is what guard(rcu)() does, right?
> > > > Or am I missing something?
> > > 
> > > I am probably misreading the patch. But I've had the following in mind
> > > 
> > > 	scoped_guard(rcu) {
> > > 		if (!cpu_is_isolated(cpu))
> > > 			schedule_work_on(cpu, work);
> > > 	}
> > 
> > guard(...)() protects everything that follows within the same block
> > (here the whole function) whereas scoped_guard only applies to the
> > following scope (here what is inside the {} in your example).
> > 
> > So both work.
> 
> I see. Thanks for the clarification. I would probably prefer a more
> explicit call convention but no strong opinion on that.

Forgot to add
Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!
-- 
Michal Hocko
SUSE Labs

