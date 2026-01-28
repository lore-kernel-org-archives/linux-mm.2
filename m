Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DAEED35692
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 08:45:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 894FA6B0088; Wed, 28 Jan 2026 03:45:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8430D6B0089; Wed, 28 Jan 2026 03:45:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 724BF6B008A; Wed, 28 Jan 2026 03:45:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F7B56B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 03:45:09 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0634CB9BAD
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:45:09 +0000 (UTC)
X-FDA: 84380737938.21.B0991A6
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0AF2040002
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:45:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=H50DQSks;
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769589907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yzZ5aaJur2cGbo3tv1Z3AlCZuGpqhSu9RlDH7L/IIPI=;
	b=xk7DBx/FMsCju0jaNVfzdXZfpRHSbtPc3kRGGyYU8T11jdyqlAiiqM8kI6gGmSWt+DJV92
	Mg+c+2FBywgHDlXsgqj7tWLukh81G8Y93rKYBwEDN7uZxpCKhOlzcVTMlkbxD5yYg5SySa
	MaoXdaU1GDbuZz0Ula/8WKC5BB9jdz8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=H50DQSks;
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769589907; a=rsa-sha256;
	cv=none;
	b=VPEY2s5HKCnJiKj9hLLSxhxASI6W5ae4HSMLfLPP+jm0K3X5ytDgi/l4Yq5BRS/GA8NlMX
	bBLDztTjoXyC0OCWzvjjAdHIqrPLGgafd++frSfVAmgL+ygK+qaBY4A6wovKEP+uC7IDxQ
	W5hcuVcA5R/mdP1RJ0N/WnAMq9HMQIE=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-48069a48629so15201365e9.0
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 00:45:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769589905; x=1770194705; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yzZ5aaJur2cGbo3tv1Z3AlCZuGpqhSu9RlDH7L/IIPI=;
        b=H50DQSksDMJQAcUqDG4oRHSPcIj2+4PYMXXYDQWwntDpEUr67Eu0Zh0ZnweX/KoaAD
         z3duJVNnzlf2TSzIUHW/1MUbQpwT3FoASvoVG7UBIbhmrf8dyQnlS5o6Xdt9Glvzap6Y
         6wBuQhJFUhGSmg3t8G9gWc31ZaraMh42diMPuE5gGRH7rdZEC9tTqUX+aJw4uzqW3lQc
         tXynyNhIwg27MMcQlQpGhLnMZRg8HMv3iAMai12iM7kDQi5Lg2j12RAkZqcI2ZFNvNCT
         BD2H6TQuoDXY44TYmbyZ4oPT1pihvjTHNgA9BVEtdC8IxqDxg+0mTrniHEfZjOUCHWWU
         DrEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769589905; x=1770194705;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yzZ5aaJur2cGbo3tv1Z3AlCZuGpqhSu9RlDH7L/IIPI=;
        b=UEwiqQni67JZEdEI718/5e44JtauBGRqclHZAALsx8w58js9+MBzwRfyZxIdyuHkwa
         H7FMwPoLn9Lu1wbRv3GHvVjuIAVFBSmUN7idA7jAvbAnSFuB8rv2hdQjNNXPbDhpxZfI
         6PnseHx3kXPM+aiuk6U/Jw+UpwlSlejhxmm9wg7Kc+M2STL+XUU7Go8AO47PL8nmzSHJ
         TYk6s63GGDviNpXL+QA8UugIUDaV+4+JvL/jRy7AvjL3pWSj0yr+e72Hp/FCiRgPq7+S
         2xsO+PaGR8S0amEIlWfLZUoSJ9Dva80q3ehilY7yS5Mr5hF+zS72DSxuw2mw748AXwMt
         jJdA==
X-Forwarded-Encrypted: i=1; AJvYcCUbStI9XNjbWC9OuLanNh/qEJFAXMK6a7c5pJsPq1Ot+8HHXIBjL9JBt3cjlvjC10waJhOcM1KXKw==@kvack.org
X-Gm-Message-State: AOJu0YwTWJK3e16cRLPtplAHcTCHtdEMqpKpJ3yxINXrnuu6GYSo+0M3
	s9mOqrFMIW/PhkWaFGakC83k/CxL+yIDlk1Rl0wwIDNnE+44jRdjjXvXsP7mA8wUxwU=
X-Gm-Gg: AZuq6aK/y7ndYesE9fAl4uQkHcALSwPdFUR0jhs7VhX88tZYThSzXG8NoyPjIeltflN
	hX02ADtXWEfEmb5hnBWk+jOfl+UFpvtHMtvc7EbIT4vfOly5IWI7xRB5noq80f5kRslvojSjJhM
	/VaEgsL8tnoBIPKoNNbhpoto7twzDbuLk+dJPJZxFHO3VQXFYesM4QUAtoBxBb1Eg7JYavsfVtt
	TeM+aBzdmSyaa4uQk8vJO63BrskLq7FMK8UARJAEYx+SlPgAF9fP7pLNcmQZ+8OuKOStZpZWrbQ
	cvAJ2xC6BpzbruUxfXwOKwGMyLWf1oUkj1XMWBHeMrpxYDa8zgLURkaVeh51DgXO8i5GY0f/ULm
	RIFhLu+gAajLX52hWIYpM5MpY+gco18dsf+KTzpEZJcLSciTuSoY0s39JnSm+SkI//dx/7iFvLs
	dAbuNzxz3vhNmP8Kur0rB+V4dy
X-Received: by 2002:a05:600c:4e12:b0:480:6873:b2f6 with SMTP id 5b1f17b1804b1-48069c557d0mr54819185e9.20.1769589905328;
        Wed, 28 Jan 2026 00:45:05 -0800 (PST)
Received: from localhost (109-81-26-156.rct.o2.cz. [109.81.26.156])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48066bee7d0sm121124905e9.4.2026.01.28.00.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 00:45:04 -0800 (PST)
Date: Wed, 28 Jan 2026 09:45:03 +0100
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
Message-ID: <aXnMj1phN3TJZkNz@tiehlicka>
References: <20260125224541.50226-1-frederic@kernel.org>
 <20260125224541.50226-4-frederic@kernel.org>
 <aXeZQoSHJ9QX7B6W@tiehlicka>
 <aXizUsfywjtIIN50@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aXizUsfywjtIIN50@localhost.localdomain>
X-Rspam-User: 
X-Rspamd-Queue-Id: 0AF2040002
X-Rspamd-Server: rspam07
X-Stat-Signature: qd1nwpm6wosb38y1q8ounoirdhwez69k
X-HE-Tag: 1769589906-668484
X-HE-Meta: U2FsdGVkX19Z2Ne6MR3IwEABlH17/KR12KI4VnbyRvS+pAuAYew4M5E275bBN8Y04BWQny+7ba5elCO95fmtPqYeGW+ZtkDb8OKoPFU4u7I/xQk3DfvTrJ3afqADCR3BFa0quktDF/4BoAQncTRodKyJG7cHqC1ZVaUNplpyACuLAVbCCwOGt4x44UlL1oKf3Q2qOB4ZJOXBka2JattrOLPXMsG1AtQMXxDT9slHr3nJUTWKWkIvVOet0PIbxt5C6Gy1htGiHP5HjRjfjtrZvwlaQUKlMIrRS/Xj7dVbKy3i/6M8/f+9nuviJWuzm0vF84OSlHA22WoUF8I2XtTXfFzIcVofrW3iwVM/wDtSBhOA3w8H1Xh14lFF9eFpgQwT7VfBVRa9UJFrxAPbyMibYrwaab9zFWf4uWY43ZbPGEwoyMD4hbymOh1iTkcxOg/xtVyABjw5uHdM+dwX9XnRo19wy5FghhR8CS4p/Fq5bY8PBgelv8l9SKcm728KTY/y7+ryNOAczPC9UIhxcbo7zqwbH0zJQL0rl5UmWxMfUT074Tkz3c8tjz5f4w7U1tpOEKPH5zGxAHbATyVHcanZyRXMchoMcimVp92sMGob7DfF5Vn1kDbZk3rtSItIsY0ZELTqC1aHzbuMLWUNrjF+wkXvEI0WlLxKk6wiNxKsLFnSQRqdt/VDd+As4ZkbyyzxsVWBd46IHaBJlYYih2D2P5a7Ekj894/IfoI4T++73yiFi0UasxuRjNw6JlO82KxLyHcEs4KZjGjoLxcmYpKp/vpnkq1yMvyudofHUPeIeXVysMvWX+mgmE51yR1l811fUgS0yZg5hBcBHZxJGQ3x6YdYTumtJg7IAbMsErhfmoAYbnX/CXm6PzPB7eSczzrfNDqDvekc6GT8IfXR6krR70Ymin0EcgHpgqmPcQHiSqahYfCGyLnGKVXGumt42wNyhL5w8DZYWWvX6d4nTPa
 h8TTSvJ0
 gHz6crqxzqOX4l/SGUo+k2pbiBINQkbKHTi6y2T8ux/VK0mhD6Neyp9LOZGhIdFMvKaC4sjTvLPtEyoN85hAgyunvbyoftpjA+pfeP4ZU7AEwu/LLL5+eXPG2sPVsgwGp1fMGOrCR/An1S/EEDDK9OlXXsOTkqCQBaAbtSl/LYKmOfO8pYXNAMBvbr5eVfR3ZqPEdjDcitd/ceqnO0LBCZCqsIQph2s9TYt/EMc31sfjcwr4Eu0Zxth3FrZjrCaXwY8f0mMBNIR/jiGIA5o4oSk+4SJBkNXkgbJcB+yl5Ocy+RVP9ipqNZekMpbX6WlStIbhaU38px23Mvq+Q+xiAciy2ngRVvmDx5b+hYX9f+m1qG3Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 27-01-26 13:45:06, Frederic Weisbecker wrote:
> Le Mon, Jan 26, 2026 at 05:41:38PM +0100, Michal Hocko a écrit :
> > On Sun 25-01-26 23:45:10, Frederic Weisbecker wrote:
> > > The HK_TYPE_DOMAIN housekeeping cpumask will soon be made modifiable at
> > > runtime. In order to synchronize against memcg workqueue to make sure
> > > that no asynchronous draining is pending or executing on a newly made
> > > isolated CPU, target and queue a drain work under the same RCU critical
> > > section.
> > > 
> > > Whenever housekeeping will update the HK_TYPE_DOMAIN cpumask, a memcg
> > > workqueue flush will also be issued in a further change to make sure
> > > that no work remains pending after a CPU has been made isolated.
> > > 
> > > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > > ---
> > >  mm/memcontrol.c | 21 +++++++++++++++++----
> > >  1 file changed, 17 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index be810c1fbfc3..2289a0299331 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -2003,6 +2003,19 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
> > >  	return flush;
> > >  }
> > >  
> > > +static void schedule_drain_work(int cpu, struct work_struct *work)
> > > +{
> > > +	/*
> > > +	 * Protect housekeeping cpumask read and work enqueue together
> > > +	 * in the same RCU critical section so that later cpuset isolated
> > > +	 * partition update only need to wait for an RCU GP and flush the
> > > +	 * pending work on newly isolated CPUs.
> > > +	 */
> > > +	guard(rcu)();
> > > +	if (!cpu_is_isolated(cpu))
> > > +		schedule_work_on(cpu, work);
> > 
> > Shouldn't this in the guarded rcu section?
> 
> This is what guard(rcu)() does, right?
> Or am I missing something?

I am probably misreading the patch. But I've had the following in mind

	scoped_guard(rcu) {
		if (!cpu_is_isolated(cpu))
			schedule_work_on(cpu, work);
	}
-- 
Michal Hocko
SUSE Labs

