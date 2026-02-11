Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BC14ECD6CA
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 17:07:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D1F06B0089; Wed, 11 Feb 2026 12:07:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 699446B008A; Wed, 11 Feb 2026 12:07:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59BC66B008C; Wed, 11 Feb 2026 12:07:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4A1266B0089
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 12:07:23 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CF03C1B3940
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 17:07:22 +0000 (UTC)
X-FDA: 84432806724.07.107D021
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf15.hostedemail.com (Postfix) with ESMTP id D8D9DA0012
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 17:07:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="MAk/Qw0v";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770829641; a=rsa-sha256;
	cv=none;
	b=AnLpxgpHyCmXU3IJujRKR+c5c6rKdNYfgprkCMkr+blin2dZyqWMgzF6sFDEi54sd7yYkg
	a/97+2E5YDj1j14IXa0LXQK77OQmUncyo0GBY0r7bWw9i9qo2uvOB41QtOWZXpLFdGxB0a
	ORrgCbHd4FoYKOnhHk6s9n2ch6qaggU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="MAk/Qw0v";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770829641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mPSBc0UQSAHkKnCaf7ezAsL21Xf876MMmDqC8iH+97k=;
	b=qYsjxxSx3iIFiyAhgNNPCZSVyUJscbwHokzasmPz/uy2or4fvF4Rxpi/dRPnq2NrbqYSgI
	dOEZwT4EKnCmyCi3tEAuFPng9xorUToYW93Nt/NJeu7MUYsRBL6bmjG23udZyPBhMUr2BE
	G/k73+SKmCnDr/uUGW+fJ3jnbr+7sGM=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47ff94b46afso11408375e9.1
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:07:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1770829639; x=1771434439; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mPSBc0UQSAHkKnCaf7ezAsL21Xf876MMmDqC8iH+97k=;
        b=MAk/Qw0vAx0ITRd5wymQg0Z4m2v9Jptha57q01gux/B+/0jnn+s/ih7XE/U88Iui5r
         7pMT0ashwsYK7K/g/xpXl2mjdwOjcGSj1iLP1KEt7TDNfx4wkNVl8R42rzoJnOIRMA7d
         9gyQyA/T0RXMV/kTnYznZGpksuYqFPhflqnvQZfvCMxtX7OkjeHJ33ObF5PM9pUXxihw
         y697CEzknhr35uRoXU6hYC2xjXmP9kdF8k26nW1WWOyeIuIJq++zkL2+s1gHHsgTYzWW
         r0yMiiBDFP3Cky/YokKYELN1KZ/BjXgHvf9CRRbQvq03IlJuSCqmwiBQWKq5bHbBKEVB
         UNZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770829639; x=1771434439;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mPSBc0UQSAHkKnCaf7ezAsL21Xf876MMmDqC8iH+97k=;
        b=hldJdil05MCVFqElnghhMmq7e4iavbRf7jUtm1t/Eovs16dB21OwcJrRWYmi4TqpzE
         FjvQGjSm64UPfQXLYvA6Nnb7R4ZJcm9i2V2kTMQXVniAVbgN1/9e19ywot1DJC4Uuoxa
         XOJCA/KnzWw8+8KxZ9qZuJN0/NlHMTsw5RFegOWz7x/0YkmrUy3M1KDvdsXjDHTqgBUW
         INkpwf6UVQPpgfYE7joEkKen/Ake0NTjnhp75/KwmqADNjPDF7JJwSQPTqbYpfcRb+eb
         WsGauZQWQC8q2Giq2tqw7aLQjx2FiDMf785oVpSuog2smgTGTt9uH3nA6+f8dEtGt/Lp
         rrNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVG9oNTwHL2cH17Ev3pIxjgZ317tYWB0jOaRNf/GzdEIHicsx6rEm/mv83rrQFW5svPSVdSgxvANQ==@kvack.org
X-Gm-Message-State: AOJu0YySfvgSfqtvV7oWJ9YwA3kT8jtuNKs2ugbP/8NnhMt7iVPzzVME
	gPO/V2JjrcrnTcvTeTNYPhm02PJGMpwU9qVPc932gb3TStgYlzIGZ/hd18Ug1wdG5pM=
X-Gm-Gg: AZuq6aKBTbB4hVnaqgdV+p2s1gcyYjQC7LGGgBGP5QGDxcHnyu7RHGv9vuB9JSIYQS2
	41v8bgPltrFClUlSL2zsGanYnyhSXUFruiOfffCPEECyKB6vlHpEjE+eG0AfyDN2lVAxEvJh8nh
	7d1XjEqDlanVoz0de1j2QFFOf4AXtUXcmS5HFeHY5DBvMcUrqm/P/7MP8UD+2drh026E/UdiT/U
	BswunAwiuT6KuIVmK3ehzXVPbMxtBpCZu8tk6dVkGLlvb+nPzFk8Cn02Q7aPdyn5YWI0pUWIuTj
	5R+uTwnVjCXF/OIeRya62uGcjmqbYpiayF8od0viTQ3RlEVhOebMKQGxXbdrnC8vRGUC6y7cnu3
	kKJSXmxkhGKEh5sjR1i0cXZ5NklR4uihrLwtQ7PyzrGI49+TtkUMde2jYlsOqDSwMX9sR9KoN0j
	4eGoZXnna+GTVFZNgWI3FGKY8CFtWsxW9UNY6z
X-Received: by 2002:a05:600c:524e:b0:46f:a2ba:581f with SMTP id 5b1f17b1804b1-48365057efamr1621985e9.16.1770829639376;
        Wed, 11 Feb 2026 09:07:19 -0800 (PST)
Received: from localhost (109-81-83-241.rct.o2.cz. [109.81.83.241])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4834d5e0ed5sm130603715e9.5.2026.02.11.09.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 09:07:18 -0800 (PST)
Date: Wed, 11 Feb 2026 18:07:17 +0100
From: Michal Hocko <mhocko@suse.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Frederic Weisbecker <fweisbecker@suse.de>
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Message-ID: <aYy3RdKQF_aTErzB@tiehlicka>
References: <20260206143430.021026873@redhat.com>
 <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad>
 <aYywl1hdBQP2_slo@tiehlicka>
 <aYyzZbh/YRMDcviS@tpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYyzZbh/YRMDcviS@tpad>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D8D9DA0012
X-Stat-Signature: 3hgraa7mo7kpfhyss95wbmnq6bgw9z3w
X-HE-Tag: 1770829640-129840
X-HE-Meta: U2FsdGVkX1+tznr0dXer3Ua2GmM6fq3UFK7R03Lk9fdySyD667wz7/YESB9TcEm1v5uebV4o86/qci5A3sv/keuHU9+p9ikQp6XE7uVwC35LPJUIadl00UiFFrgi+Xq5E7N7HRW/0b9+KLkXNpIT3tyoIGYG4sQ/LzCHtqMYmAJiqzPAgWRUvBIsDuPrhlH/E1M7s8TUPEPjFuHPUgOghTe8wU4XglOsyAa6QlKk5fvm2c1ts1FoVZ6zoFW40O5LISyi0e9gyeDOtfw0ybtyi4OPkr5DgZTqMXg4fiqtSkIniwsX3HrsGVeswnFMQyJEioc0NSh9Lfo39FAXJyNZuvVnzTlQ3Ug2rRernKB0vY7ICwfr4rMatyxA4jMBEUyAznjHZMHC9IgRErJwW8mmX+iGNEOf5GAoh3++nE4Dc89sPhtVndFTmnEIoET7GsBlUet9t6FCsDMF8biy/bS50/cdgBvcebjXQypQAa+TYZAkOqkazqGgkgBtYH72PrwF2yRS26OvJ8D1EVNXNyep1vjTHKvxUMVMUV6zAhijZLkHKUKCN7rhqAmbCBOsBevis3PsrBYKcJtq3P4E2eR9lZZOVzq73ve88Mla+/wOaXmrkDFOzfgqEeYag4lryHYRQlL/+Vx+RYNZZInhC25dWhw2FXfSNzlEkxPPGgh+OqGSWwTHJAe+lfxyGP9x4Z29JgjFc/2aVio5AE782qjYoSjrSxmRLghZCU2OKTGpeBZlAC1FaO4F+WV1kPEXE5Z6GRixlmsUOurCEHm/yg3M246VF1rc0iZL2rN2bgMD9tD46h3ygLz9hNWWisxBSQZevUgvPJCvEKAhAwVwcFxM3CQLcRvmmunw2W22xS2EYuqgqnc1rnJ9H7BHTTLyVGvc4pD1lcrS1QdVKFTZdqJwXv0NVzAf4odXYB5a4sVuhX++8XzseIPr7N/mh+NnzH0KO0OQkR/r3UEM5mbqWBm
 pnZzVGL5
 9yFrn/MKEbptaRxAKvkwN1x8WaEtAMEPBjMXF6YQQ8bnul3rjgigD0sjHDvGrW0fB46xUAFjsoswXON0Y1SN6BfhKUyyNgBOTDu4/eqVSwCh8k4QTDlWUwaA1/xX1+oCRTbBfOrounYYkcoxOvalNwVcWP+AT2jTxsLI/Wk8RHhcm6lAcyudJMkaPk8qCzDGa9ZJf4Z3VTHftXsz9EYUrwtvMwg7JEmUmfpjiOjFKuJzd2i2wJ+VDRXrKcNQ1/pFQ70S6gEjLdiqD8IgwkkpJpxRYG3feuVqD0Q5j4G41Z5UwvXnhwQUyYK7PetbJhyNV63bCcbdUB4jsxkIQ4xeF6VUUHWCsrF89yrHdFuVgpDnSo81/RlDrsStEKshK/Ucz5JaoDdZynbTCKBWnZcQR1jN/0HnYG9hM/w2xdJzygotzmME=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 11-02-26 13:50:45, Marcelo Tosatti wrote:
> On Wed, Feb 11, 2026 at 05:38:47PM +0100, Michal Hocko wrote:
> > On Wed 11-02-26 09:01:12, Marcelo Tosatti wrote:
> > > On Tue, Feb 10, 2026 at 03:01:10PM +0100, Michal Hocko wrote:
> > [...]
> > > > What about !PREEMPT_RT? We have people running isolated workloads and
> > > > these sorts of pcp disruptions are really unwelcome as well. They do not
> > > > have requirements as strong as RT workloads but the underlying
> > > > fundamental problem is the same. Frederic (now CCed) is working on
> > > > moving those pcp book keeping activities to be executed to the return to
> > > > the userspace which should be taking care of both RT and non-RT
> > > > configurations AFAICS.
> > > 
> > > Michal,
> > > 
> > > For !PREEMPT_RT, _if_ you select CONFIG_QPW=y, then there is a kernel
> > > boot option qpw=y/n, which controls whether the behaviour will be
> > > similar (the spinlock is taken on local_lock, similar to PREEMPT_RT).
> > 
> > My bad. I've misread the config space of this.
> 
> My bad, actually. Its only CONFIG_QPW on the current patchset.

Yeah. PREEMPT_RT -> CONFIG_QPW=y and cmd line makes no difference
-- 
Michal Hocko
SUSE Labs

