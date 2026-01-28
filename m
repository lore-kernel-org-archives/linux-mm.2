Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DFE4D46BFA
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 21:18:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A35DA6B0005; Wed, 28 Jan 2026 16:18:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E3836B0089; Wed, 28 Jan 2026 16:18:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 891866B008A; Wed, 28 Jan 2026 16:18:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 770C96B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 16:18:08 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 23B2D13BAD5
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 21:18:08 +0000 (UTC)
X-FDA: 84382635456.08.8DE8F31
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf04.hostedemail.com (Postfix) with ESMTP id 25D1A40008
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 21:18:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Qka2XqE0;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769635086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZU7FEnl0OZQVA7ODIpy0SKJAEacHqZRjK4EaXTvPIzs=;
	b=KKI+6YZC4SA7hovF0RsTf84NKygDSey3knjMfqu145wIqKJehYQsoZzCfEpNDG94pD4sz+
	IOcMRgNH5HYd0AamzW5AWPZs4Ix4gA1ovKkSezsTeOM/Gl7ipI9J4WbS74dnYzXurtCWbR
	N7CWc8pU7pN13JS8kNAHcqjwcYru45M=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Qka2XqE0;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769635086; a=rsa-sha256;
	cv=none;
	b=ESiHjapUJzFBEfugx1KxW8yxOF6a2hgz87kU1V2kvNBOh946Sie7m3l8+ZKXD+uJGibKoM
	cggIu4GsdOTzmHRxf25OVM1tKWuZEp+igt4fDSHZAKUsxz/J9r2rudqowAikEib3WT5juO
	V8803Mdrd/6oM3LkZdtNeEhfyHJU6hc=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4806bf03573so1573185e9.2
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:18:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769635085; x=1770239885; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZU7FEnl0OZQVA7ODIpy0SKJAEacHqZRjK4EaXTvPIzs=;
        b=Qka2XqE0zn8hm27nQeOGOeRlaTgzLkaVoxekDJV1XYAM5Ur8dD3iAAyhKG66MstjIc
         lYigUD5ALnMn6pgEGDy9Z2hschLfKitR0KPXNlXJ0z6SgP9GJTN6wGbzAmYEDVui6Ip8
         rL9ZoUObHAuIegMGrFzonLw/PwDDsG6TNUFKSIx0GzoLTMrZchKQUP0oKe39UMYfGZqb
         m9Hydn3xTXY2A0kQ/6mNifyDiTHaBC+s9jaIDZ2bz7No+69qKXCGHlWRYr8FGXcFBAqA
         8o4lZNDyjU7wmrWuwHAneQAxnuhU+h7TXHIIi0XE+NpsHblYpjcoAHftk9uSYCPD2Qbs
         jr5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769635085; x=1770239885;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZU7FEnl0OZQVA7ODIpy0SKJAEacHqZRjK4EaXTvPIzs=;
        b=OX3uhuUtFpiJ1EvCi+3B6S9wYrvKVQUsmJq9NXS67z3QowX4GV4YAJoKvojcjPCfru
         XY+mxr3Ln99Y8FtahT23nA82tW05w4XwBarAptlsNfCc45ow/C2dKvcs6RI3rx+boRO3
         4ZQ81wgy5wOBnLnC5IZPgXR4N45hNvGlLuwmPXiL3CQc8PPPQZpBvJ4ba2xvuYZJxgO7
         QxjCXmQB2w3t1uQIjyFIEA+dw4kxON8wxBxxNIHLtjqY/3yPuYJQqVi0NuW2NOo+1u3E
         Y+sLbB7c108ejZ4hjvYkFgPIqpnnKydHxWU568T6LMNDTY85fhuVmqk/N+Pyullgy23f
         vYDw==
X-Forwarded-Encrypted: i=1; AJvYcCX7EX5zpVFSqDeFSOcg7RF31a7iE1P1/bHdtGknWuJhpKDILCfBqYAA+PzxokywSy+DnrG7iqhUWg==@kvack.org
X-Gm-Message-State: AOJu0YyZjEegZspGVW2GRjBDyD44cxdvbgUZxsx1hM9r8g0tRMXYiq49
	H+kxUC2rHVmfyTPAiToUSW/oj8f1brNkYJAUF/28kdA0huyzp/78jpz/DIROaYkgJ04=
X-Gm-Gg: AZuq6aK+Mv5LnVBk8bEVmHrisFvxJy4RhZrDtKKDH25I34fzrLKXRxsgS/6t3p6iwvR
	pHL6+cFKF9ceQWx8W/oSfP1tKwmKno8i6C9qNyq/cRZgUl8itZVr9T686AOA+Ta9x003P9u5ICK
	2ynTEfnGp0MbsBGNzarWyRb2c4dtyGmrVsUBIO7hF7efQhl2YP0oYIbV4a0jkx7sDqZr+7culwh
	ihUaIn/QcMzWxhC3cLltfXbdGqT1iP5ktGb6CxV732sNvlseeuoLgjLwy01r0GXqzUr2+jHyDng
	R0t+8TrDnhfKxhsIBxNCHttmXA82VAtKQn39Ug28l6HJyMcqIpIBnRM6wdtwn4oiJz6wvGKCIIk
	yBwFS7FS9X4+YxX2slcaBCxJVj3VhBY4K+oA/GjRTVvmfVYx/MgYm7zz24rB119My50JzZsM5uE
	tneK07e/11EupVxTicLyZvXmqm
X-Received: by 2002:a05:600c:154c:b0:47e:e9bf:dd8a with SMTP id 5b1f17b1804b1-48069cb2fddmr85513805e9.37.1769635084662;
        Wed, 28 Jan 2026 13:18:04 -0800 (PST)
Received: from localhost (109-81-26-156.rct.o2.cz. [109.81.26.156])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4806ce4c515sm85708295e9.11.2026.01.28.13.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 13:18:04 -0800 (PST)
Date: Wed, 28 Jan 2026 22:18:03 +0100
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
Message-ID: <aXp9CzgCTBEhlDqM@tiehlicka>
References: <20260125224541.50226-1-frederic@kernel.org>
 <20260125224541.50226-4-frederic@kernel.org>
 <aXeZQoSHJ9QX7B6W@tiehlicka>
 <aXizUsfywjtIIN50@localhost.localdomain>
 <aXnMj1phN3TJZkNz@tiehlicka>
 <aXnymtIZSc-fw1b8@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aXnymtIZSc-fw1b8@localhost.localdomain>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 25D1A40008
X-Stat-Signature: ywfbyp8wbqxofw55q3sdjtt9935ymwn1
X-Rspam-User: 
X-HE-Tag: 1769635085-147729
X-HE-Meta: U2FsdGVkX1/1qvMW8m9uB3Y3vZKDwzGyiMS208nf5N/cJRnF4Y0O9glUQWTTG9d/Lhfl9dS1N8W4Juboh0ohq3rNEoXRYS3PLYzOqzpNsRT4M2OtfsanC/kqUAdPQwmFMyCAD9ao8U2IW1aftujo56xDQ4YvZVs55XV/U2En0p8w0/oJbjV+UhzX+y6OAZVDLPrmw8ot4fEK/vu977tKrCSLDX5RSrCwWrLT5NfdgDO8rgy2BxrYPh0k866VZCk52Vf0rSCeQhDCCmeUds8wsxgiiJ691DQo4st0EBEZXRJ2UznJwAs1t5mvP40xF3XW5pm+8xNxCHXvjZhza+ZI8x2o5OlzHiCpeHip9PsVMMxBSL+siF/KuL96hYvtVlQUp/OQlXMMLidueLpBFpHRRKbfzSHoT1Dc+U03/2N0RISgTVobvAtQfdKcO3+O/Kw824MvFSHMAwyRJ2jS0mvjOKvHDTtvKnw3flzzt0mox6QTE6yMG4vUU2BjmxEx5ZHlfBbQIAtym1qN96DEJDMoK4NSx4UKpDNd1tBescsW2jeMEcz6HHCBQqUKJKUFxN9nH6Y9OTPH5eLYLiBkdhx28JiFxPklTZHfTAwkg8b7vFaC63EFAh/r34Rie8jhsOF1d+T5j3bYp3zJcgwRB4PjBKBKRiyMcSqsCTsgj8eCedbTiUCLR9vFWdRQ4HdFN2g+zuiyZR3A9TXjSgGsw1eMRu85YrfDAIIKuTI+ISRiNUMqdGbjheoYA6W4QVC3DtuzcjT8YdwcedWdC3XEU1GhKHn0/XP7ZmP2L+9paOW5HHQdkGH/wJkrBQUz5+efyNpupob6KRxEMUkd31prHHHkfXNdNrC3Pgni/JAFJVpcxukC6lqA76aLFeuD8Z/OVllXdG88asu9UQujpeYVURULMd2Liy99z78Uc69dGFO5jx/6RBXCqpO9qvjNS+PuaDKSSSHjCcn609Ju+zM+H7m
 NvgYNEP4
 /qwQ/1ThvHUdEYHt/dVJZLcM1movBm1UoHmXro6+ya2Wqs5/OH3is7BIRUE6+5jBHZFXZ+Q7kH5h6Cb3yX/29rinvvDIWOF9P8kN2UviiBIkJPITgNN0mRtGXB9BUz3Cmn83arI7JNt2OR1vdT4TRCcTzl1Zehh/zLTEO7G86qPUodlhd0YIAnL5hgQTc2WzwaJZfUOloxHNS7lflsgHU9lk2xrM5CnNJIapjhlBqMDBQR+BWkCYNw9C97omhELdYRRB2PZEnnHlUR9VQy63D68jDH0Alh0sFChIGV8WiviPOIX7j+5NvXT2JRmo5WyLJObsa9Si4C4/U1sWLF2r/1buo7hCWu21EgUpzgmagtdjxV1mEpFiZqvQEQhPUa9ZevGKVkuObLEZOMpsW0ciq09gmLQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 28-01-26 12:27:22, Frederic Weisbecker wrote:
> Le Wed, Jan 28, 2026 at 09:45:03AM +0100, Michal Hocko a écrit :
> > On Tue 27-01-26 13:45:06, Frederic Weisbecker wrote:
> > > Le Mon, Jan 26, 2026 at 05:41:38PM +0100, Michal Hocko a écrit :
> > > > On Sun 25-01-26 23:45:10, Frederic Weisbecker wrote:
> > > > > The HK_TYPE_DOMAIN housekeeping cpumask will soon be made modifiable at
> > > > > runtime. In order to synchronize against memcg workqueue to make sure
> > > > > that no asynchronous draining is pending or executing on a newly made
> > > > > isolated CPU, target and queue a drain work under the same RCU critical
> > > > > section.
> > > > > 
> > > > > Whenever housekeeping will update the HK_TYPE_DOMAIN cpumask, a memcg
> > > > > workqueue flush will also be issued in a further change to make sure
> > > > > that no work remains pending after a CPU has been made isolated.
> > > > > 
> > > > > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > > > > ---
> > > > >  mm/memcontrol.c | 21 +++++++++++++++++----
> > > > >  1 file changed, 17 insertions(+), 4 deletions(-)
> > > > > 
> > > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > > index be810c1fbfc3..2289a0299331 100644
> > > > > --- a/mm/memcontrol.c
> > > > > +++ b/mm/memcontrol.c
> > > > > @@ -2003,6 +2003,19 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
> > > > >  	return flush;
> > > > >  }
> > > > >  
> > > > > +static void schedule_drain_work(int cpu, struct work_struct *work)
> > > > > +{
> > > > > +	/*
> > > > > +	 * Protect housekeeping cpumask read and work enqueue together
> > > > > +	 * in the same RCU critical section so that later cpuset isolated
> > > > > +	 * partition update only need to wait for an RCU GP and flush the
> > > > > +	 * pending work on newly isolated CPUs.
> > > > > +	 */
> > > > > +	guard(rcu)();
> > > > > +	if (!cpu_is_isolated(cpu))
> > > > > +		schedule_work_on(cpu, work);
> > > > 
> > > > Shouldn't this in the guarded rcu section?
> > > 
> > > This is what guard(rcu)() does, right?
> > > Or am I missing something?
> > 
> > I am probably misreading the patch. But I've had the following in mind
> > 
> > 	scoped_guard(rcu) {
> > 		if (!cpu_is_isolated(cpu))
> > 			schedule_work_on(cpu, work);
> > 	}
> 
> guard(...)() protects everything that follows within the same block
> (here the whole function) whereas scoped_guard only applies to the
> following scope (here what is inside the {} in your example).
> 
> So both work.

I see. Thanks for the clarification. I would probably prefer a more
explicit call convention but no strong opinion on that.
-- 
Michal Hocko
SUSE Labs

