Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DE49C5B568
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 21:58:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8C2A6B0005; Fri, 20 Feb 2026 16:58:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D36456B0089; Fri, 20 Feb 2026 16:58:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C42716B008A; Fri, 20 Feb 2026 16:58:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A9FD16B0005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 16:58:30 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 498181B4E6D
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 21:58:30 +0000 (UTC)
X-FDA: 84466199580.22.66B7B0A
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf23.hostedemail.com (Postfix) with ESMTP id 45FFA14000C
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 21:58:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DGP3H5C6;
	spf=pass (imf23.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771624708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sv6xYJAa/oThbMSrWyTLhp6ItSvlOyI8CiwPK1KtBnU=;
	b=kAY4/5kqcM0gjN/9flQKsrSJw7bSgBT3xZ4xj5tWDcNC4nFid6fzpnoEc3nkdwOGFcfebG
	xo68toxB9ujRaOMs1ZjCbjmAHTKwg9o6h3qZNbgNPmtI6OB0gScnbj9OeCJijVNCsROlVy
	NtzLFDNAyvlzrOH8tqIeJwCpnE4yJls=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771624708; a=rsa-sha256;
	cv=none;
	b=WOZOlzTTFQ1pOgsC/H/q2V4vxoSwLnIxA5F40aBJrPo4utmz8rl5ckMQaEYtTRyye/pJjT
	xvrQElh0p2EE8z1q4X+P8mMeNjv2FGTL9ERXLepCGFSXJaSimzuI779Im8/Jn0a4AGeoeI
	IrOOXNFpE0kbxT5Rb8fch0KM6yrqcX8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DGP3H5C6;
	spf=pass (imf23.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-4375d4fb4d4so1662663f8f.0
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 13:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771624707; x=1772229507; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sv6xYJAa/oThbMSrWyTLhp6ItSvlOyI8CiwPK1KtBnU=;
        b=DGP3H5C6QEM9A3raUDjKkRhM8/9nkZ0wHodqzi5InXI1CYNR17N1Q6sVWphNceX0J6
         T052E0JC5NpOJZxoQ0K7CQkv6ffA3i6HgVuAlX2tm2o3wioqmvQng5UuHYBXbLjbqz/E
         iEKlR7/9/Nf5PW0YifXcSAePWSOmFC0sxg+B+swiolmfZb72vvbMm64sa6NcJRDzUxk1
         ZgQ8nCXuOWR49XbRyxdnJCMOOszcOCU5YTs2JQCvl3G3Mx+17xUkrVQT3XFfjZdl8NPF
         xgtR7VBpfVYkj//gm6afhsQXq9Z+OKgUIqdYSr8ktFrbRjm/g4LzAPjoJZY0o3c3Yna6
         4Lvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771624707; x=1772229507;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sv6xYJAa/oThbMSrWyTLhp6ItSvlOyI8CiwPK1KtBnU=;
        b=tvjh9X+NJzc9c/K+HBu8g3l4lpWkFTpLDyfwRiKVajEoYn/jNSgs8TSyWeQ+ZirQT8
         HxzfoxZDqV0PbfZ8SJauCZYgCxGzs+bKqJaqU+wkGcXHIUHDJiiZEa9J6SwaZXsSmU8l
         6eTWmv5PXTTJNLBjLY9UDZILY+S1SZKZO+1sQ6XcBM0yP2Z4IV8v2ukIMwcvGMaSsiPp
         LZXxphKDLzAObkTGw0cb1bvrHsjWYekyRsFXnfbb0m86yg7VSmg+aPn+dLGkPz8HPB0k
         92AWz6t2MJrGoutYhUMpd451hJUriRlcx9ChtngI7ncexWH8JxS63YcVEp+uOMMrGEUv
         0/0g==
X-Forwarded-Encrypted: i=1; AJvYcCUhEOyTOzVvarkv8hAx9x/dlqGrN1t4YdZ5zv2F5c/Zud4dgMgduRq6bDEHyNrbPCISs/dc3zW0RQ==@kvack.org
X-Gm-Message-State: AOJu0YyU+yX0dndp8xTFsnqC4CzEBhKOEdKecQ2jejPQhEAhy0FvDIyk
	vgTWSo0s6BOTubzJrhWsGshzTrSycZ0dR+LvvjC5A8jjOCPiUnFyA3jK
X-Gm-Gg: AZuq6aLiqmcNbNqLr149Yr7gAxFTOy1jCCa8ZpTuj4Bm/PWgJzXRK6PCILz+D4KDvLL
	zkl2XHT3qscVbx2KAHCtAhP/hTOhhssx9oO1Gw4+QrKpLoBkMVv+2PGlQ55TUowe7dNCzV0vF2w
	wQX90q0lkZE7dwY47+t54qH+ssyM0AKA98HGRNGlr5eo3j/HJChOmJHT2gdZUBrkI4yhmQIYG1w
	TfqpJPSEd1grYEt7rpchAJ8f4sXWmndWid8gCPqDlKOCFB4diH8qlZ2XxG1AJE+bebC9kgxRwMy
	THryLGrtzYWzDB+pOsKebr56pD+PNruOxEG5eXX+jG8walXzVLTku10yaw2tM1NyXy+NVX9kcsd
	kgl39d42j+DWd1XDZQ3/uI8zNj8vPJoeYTqQo/Mr7NVNVPfVrAxX9pwcd3m46jhZiFrBuDDzuqX
	XchfioW25IPdaKIDIBaCE4LLx4i24kT3xLckGkTs0O+oqKUA==
X-Received: by 2002:a05:6000:248a:b0:436:3475:473e with SMTP id ffacd0b85a97d-4396f187ebemr2551008f8f.51.1771624706322;
        Fri, 20 Feb 2026 13:58:26 -0800 (PST)
Received: from WindFlash.powerhub ([2a0a:ef40:1b2a:fa01:9944:6a8c:dc37:eba5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43970c00768sm910737f8f.10.2026.02.20.13.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Feb 2026 13:58:25 -0800 (PST)
From: Leonardo Bras <leobras.c@gmail.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Leonardo Bras <leobras.c@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Frederic Weisbecker <fweisbecker@suse.de>
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Date: Fri, 20 Feb 2026 18:58:14 -0300
Message-ID: <aZjY9h3XXMNY-Ytd@WindFlash>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aZL45yORfkNvS9Rs@tiehlicka>
References: <20260206143430.021026873@redhat.com> <aYs6Ju2G4bm6_tl2@tiehlicka> <aYxviLoWsrLqDU7o@tpad> <aYywl1hdBQP2_slo@tiehlicka> <aZDw6xI2izFDfuuu@WindFlash> <aZL45yORfkNvS9Rs@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 45FFA14000C
X-Stat-Signature: csmhs8zmd1k746ms1x84j8xz7t4yj1s4
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771624708-116598
X-HE-Meta: U2FsdGVkX1/u1SyWK4BM59EhKLGMSPaM4mUJDv0FgWonzx9Sl4QpGHPZ/cQ0Nb4YTicSW0hplSydm4xoLT9xSDE39mFy6L2usEZPG8QmFPC9ajoOsXO5P7LizM0Q7E9rLSEuhSa8EiM7Jq7Id2adKZN+lxm9UhzOoxAiJzDObHCXQI/7XAcgiJQGsLaqzw2So6I7uGkCMMGHx4EgBeBPtSF4yIGmXz85cdlGxh0DM9vRCP/l5QIHWFV4MIE224Gl4pJYbG9EawRQmn8k2b0T6wK0iaumUuniHpYz70rJ/mgxWZzuNGMShk5tH5npLVTJcQ4bkSi1av2DU6QHz9jnOyCthpoi3Ry/T+o9XnVLXbs+Bt6CI4HVCS6JiuALMgj3qxKmqaQelR/DzbESSIpmvYJn7qC23SVlSTiQdRitTT4yv9nDxdpr3TcT1BkIIzr+BoBzq5zkxcLVcV1TLlLNoLAvndAOAjP3zsK9o2zrzY9yTgMdyWhYMF7njJ4J3qlqo1GVyGZbIMsW7+i7KABSjWYSEI+B1I/S/Ja5RutA17SJ/1/IEwuVuxI+HoLr2tycPxIlSEJ/+xBn1fma8i1m+zif4ikBQ3og9XzG1jmsv1sIimW0lwsVlCCm46qyYJXAQMAKvqxTMigUoM5ONrMsRaYYUUCYKAF5DT0HVl/BCzEx+ucb83p2gyK6firSBDT1WjtHDamZtvsHifBtdA2i0tjafU4W4SwkKU47NJxTuAIidSlxl9vAghFRGRuu4s3eeGZ44xW1I/fJ/hnrdumwdHeTvaEIoDp23Po4lUBMbldEMvphqLtVpFg9V9Kiy0fZpyOPMBfORjjodc3T2WuHo+q2VaSUokwmj5JFoTLPPOO/LM9gM1AI4pAu0erkJjIRVkN4XIsiQliEPQAC4EJSUYA9Y7PpjMhdSEE/ihshmPIZcXKEpb6pRvSjWzcr1OV3fe9ZNbhZKFqYXzIVfsu
 0nQdUwnP
 2w8zeFrca7w3aMCSmgE4JOZnWcnFTiCkRezBjVc+v1dGcv1yhS3W0zhwunt/WKzoWU2OAYgYrYelKjQpEPSLWw8ayp7i6SNlTQr57rmHw6WwU/WGjvzOcYeMzQumk6O0Ih3hXJKfFOCD64LS1VdsWB8B0AIuRbcUm9zOWcI554VjCJdpUc3Cs1QT8zrLTjTa2pU4TaE56Qw0/XcDRndbprRb+8R0DWe+SggHl/UqLYJyVrAWkpzt1uKd1FtMSYT0aBtgAX7XIqbuBElrnBjkYS35S/qyn8aTvPukA82VL+IkUau0K+nrZvp6mfvhobNiELDG/ELZVihdsw4U91d2sX5yP7umrVI+pINConsiD+HYpVEd881qFJkpac/wYIpnJlJLq/z5rqUiyIxrEI9J00uNe1yd2Vb22EYkFb7AebUl0w56hH3EnblLv5oIOIR22xpRzXAj8vnbVIzZWOJr+cxOAplrzEoWlhGQSM05lmuw6WS+S25kLyKqK3nfjCpOOQqn5eZMsGRoDnKnHCatNC5Z/NcB4X0dPMSxxWJZ1f5ET8GHCs5e35K40SEfDs7zpRPBCKLJ/iIfXqllQzH0anDEs52LC2LDf+X1DsXrMz1aFRenRGTLzr2rP/9Quo1Bd03dnyeUcBRrO/MUec1eXEV2D4DCym2Qp3byx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 12:00:55PM +0100, Michal Hocko wrote:
> On Sat 14-02-26 19:02:19, Leonardo Bras wrote:
> > On Wed, Feb 11, 2026 at 05:38:47PM +0100, Michal Hocko wrote:
> > > On Wed 11-02-26 09:01:12, Marcelo Tosatti wrote:
> > > > On Tue, Feb 10, 2026 at 03:01:10PM +0100, Michal Hocko wrote:
> > > [...]
> > > > > What about !PREEMPT_RT? We have people running isolated workloads and
> > > > > these sorts of pcp disruptions are really unwelcome as well. They do not
> > > > > have requirements as strong as RT workloads but the underlying
> > > > > fundamental problem is the same. Frederic (now CCed) is working on
> > > > > moving those pcp book keeping activities to be executed to the return to
> > > > > the userspace which should be taking care of both RT and non-RT
> > > > > configurations AFAICS.
> > > > 
> > > > Michal,
> > > > 
> > > > For !PREEMPT_RT, _if_ you select CONFIG_QPW=y, then there is a kernel
> > > > boot option qpw=y/n, which controls whether the behaviour will be
> > > > similar (the spinlock is taken on local_lock, similar to PREEMPT_RT).
> > > 
> > > My bad. I've misread the config space of this.
> > > 
> > > > If CONFIG_QPW=n, or kernel boot option qpw=n, then only local_lock 
> > > > (and remote work via work_queue) is used.
> > > > 
> > > > What "pcp book keeping activities" you refer to ? I don't see how
> > > > moving certain activities that happen under SLUB or LRU spinlocks
> > > > to happen before return to userspace changes things related 
> > > > to avoidance of CPU interruption ?
> > > 
> > > Essentially delayed operations like pcp state flushing happens on return
> > > to the userspace on isolated CPUs. No locking changes are required as
> > > the work is still per-cpu.
> > > 
> > > In other words the approach Frederic is working on is to not change the
> > > locking of pcp delayed work but instead move that work into well defined
> > > place - i.e. return to the userspace.
> > > 
> > > Btw. have you measure the impact of preempt_disbale -> spinlock on hot
> > > paths like SLUB sheeves?
> > 
> > Hi Michal,
> > 
> > I have done some study on this (which I presented on Plumbers 2023):
> > https://lpc.events/event/17/contributions/1484/ 
> > 
> > Since they are per-cpu spinlocks, and the remote operations are not that 
> > frequent, as per design of the current approach, we are not supposed to see 
> > contention (I was not able to detect contention even after stress testing 
> > for weeks), nor relevant cacheline bouncing.
> > 
> > That being said, for RT local_locks already get per-cpu spinlocks, so there 
> > is only difference for !RT, which as you mention, does preemtp_disable():
> > 
> > The performance impact noticed was mostly about jumping around in 
> > executable code, as inlining spinlocks (test #2 on presentation) took care 
> > of most of the added extra cycles, adding about 4-14 extra cycles per 
> > lock/unlock cycle. (tested on memcg with kmalloc test)
> > 
> > Yeah, as expected there is some extra cycles, as we are doing extra atomic 
> > operations (even if in a local cacheline) in !RT case, but this could be 
> > enabled only if the user thinks this is an ok cost for reducing 
> > interruptions.
> > 
> > What do you think?
> 
> The fact that the behavior is opt-in for !RT is certainly a plus. I also
> do not expect the overhead to be really be really big. 

Awesome! Thanks for reviewing!

> To me, a much
> more important question is which of the two approaches is easier to
> maintain long term. The pcp work needs to be done one way or the other.
> Whether we want to tweak locking or do it at a very well defined time is
> the bigger question.

That crossed my mind as well, and I went with the idea of changing locking 
because I was working on workloads in which deferring work to a kernel 
re-entry would cause deadline misses as well. Or more critically, the 
drains could take forever, as some of those tasks would avoid returning to 
kernel as much as possible. 

Thanks!
Leo

