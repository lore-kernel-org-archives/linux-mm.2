Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 411FFEF5857
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 22:02:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F7C76B0005; Sat, 14 Feb 2026 17:02:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A5446B0088; Sat, 14 Feb 2026 17:02:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0873F6B008A; Sat, 14 Feb 2026 17:02:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E9EE56B0005
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 17:02:35 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7B30813BEAA
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 22:02:35 +0000 (UTC)
X-FDA: 84444437070.30.EFCF084
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6081FC000D
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 22:02:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mxeF8AnL;
	spf=pass (imf22.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771106553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=paxX9wG390aNg5udrEFUWei2TAJHGt4ATBMIYJAPwO8=;
	b=eVrnzsKDNS00AYws1qQZN3ohGRr2dSZaPVndpJNjI3g4e3hG36KsabhB9lpzRhTSEXSkiO
	FyJTyRfWDDhpv0p4qHhLKnyINFPmwUN1Q07twepNFFonbuhUC6lRqixhC4ouRl+/B5Nque
	o7KvEDSE3K1OuAdlxMmIslP7wrasZt8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mxeF8AnL;
	spf=pass (imf22.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771106553; a=rsa-sha256;
	cv=none;
	b=b649yuEmnw4OMywTudV2SlogtFABv38T0cqHUQf0qeuEtTPWP/BsDtNo8OZt4O1Q3AB5ZS
	A34h6xq59VvZMFMXpmRUxNa+heEusO6cUT3vNqZig5JEWLtN2Q57y962a6gqc9OQY0pzH1
	RJUcRvPIsWV5P0gtRVL6qDrF7RJwlSg=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4806cc07ce7so18460905e9.1
        for <linux-mm@kvack.org>; Sat, 14 Feb 2026 14:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771106552; x=1771711352; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=paxX9wG390aNg5udrEFUWei2TAJHGt4ATBMIYJAPwO8=;
        b=mxeF8AnLT9sHtLgk4mjhgp4VBkurTLoUTNe1FV9/a1y4PavtiFEsbgXQBkI7pfz+LH
         sFH2nxngaZG6ObJgHQkvkSrkXQ6iNPSzdBUWEsQwJKoiIIk8K1MkTGV60nF07VqzripY
         WYEHFfiYb/fKjRD8b2la4X18YGrsJu7V1un/Ln5tDyYh97zPg4P3+lS4gt6v5xfpOczP
         vAdW6ilG8jeyiBKzKe4ctnYz7wOP+6P4NTJifE9SKXpGDUaX3hENM0ETkii+xuBxISkD
         EisgfTT7Tst8I3+VqzYD8Jf2BS8JxK+MnDzYYz0tO8mltPagk2HCO2ezIk4DpMdLSKZZ
         KRIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771106552; x=1771711352;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=paxX9wG390aNg5udrEFUWei2TAJHGt4ATBMIYJAPwO8=;
        b=iO2OnMS4st311Lt0sFapHrKHCBV6+r1jaS3+2Q5/uWrf/uNe5BtHnFCsQeVI+EWFbW
         /FqZWsTBEGvz8Ovx2tN3gCtgh5yr5KPyE5LiMXGLpN/eejGSW6T7t99Kb//AHE969k0u
         KcwiIAtzsbSKVv7Al4Cw1qxP4wDRVekMA5pHNUxMEshw4eOjuD2T5E0BdNeUGNohhSx7
         pcjbF/5eJlxqbnc+DaHKRg4QE5PSJc9jRffiVXUVsiorhQZ/zaXvwnte3lCudsYBhlhm
         uZvXMGV+CdQn7TUoBdAAfHwmA2Q4ZkKCBDn6kLg+YsqzAUDhQigR8XoVeAHGWFmBesDF
         wQ8w==
X-Forwarded-Encrypted: i=1; AJvYcCW/yw7jWBTOoAVF3pLy+pmDIgHuZyjqdrH7ahKBnkbCtYCIrbE/uP1RsBaFLarRQJ3k8JSoxefq8w==@kvack.org
X-Gm-Message-State: AOJu0YxbYH5c7QKngNQ3tmKdBaLwKaxUKVx2X5tJ7Zm02G8itFVODfiq
	kjH2d8D6a2JuI/J1N6wtIUT6kDvFE+paYWlSSu/KKRjyYVEObD8Dxf7F
X-Gm-Gg: AZuq6aJjvnQ262h9ah3GO8H2s6+fTi016gs4bHP7aowVQrB3J7O+jdA2BnotTRdokKz
	Y7460xG2SLVAQpkLczxMwMMustCnJgX4RoKTw3Rn/IDnTx6WP+o5m+9VEsN4pP+hUU/hLCwJpK6
	MHsWgWkr+pLxfzezJwkKYgD8mLeHoUpFaUY3M52pgcRzdkI5lyJ9gcV97TMhZwILyRuCSOn6id/
	8ExukF7Y8AX3AlCEesGq0bz8IYYWOTVmpM8gizcoMi5oJ7lQ+Ulqkhlfu+Uqs/8PF17rzXKE6ld
	/eGnp88uAUSvE8jwDI3q63F2N9l0jeZPTYrMjhIGmkuWFxk/Z7P7o1Caz/VgTH6O6pi89VujIOz
	XKVHDy9u/4rn80sSljyLxwS7HV8VeLWOZ5UKYB92aXb4Es1km4eYJK/g5cab7Sas0vzXFdHINyF
	pfhQuMcD7Ovy2lss73O21PdENj7J2S6ozkhkA=
X-Received: by 2002:a05:600c:1381:b0:483:54cc:cd89 with SMTP id 5b1f17b1804b1-48373a1bbc4mr101089835e9.9.1771106551731;
        Sat, 14 Feb 2026 14:02:31 -0800 (PST)
Received: from WindFlash.powerhub ([2a0a:ef40:1b2a:fa01:9944:6a8c:dc37:eba5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48371a34d66sm57123695e9.20.2026.02.14.14.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Feb 2026 14:02:31 -0800 (PST)
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
Date: Sat, 14 Feb 2026 19:02:19 -0300
Message-ID: <aZDw6xI2izFDfuuu@WindFlash>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aYywl1hdBQP2_slo@tiehlicka>
References: <20260206143430.021026873@redhat.com> <aYs6Ju2G4bm6_tl2@tiehlicka> <aYxviLoWsrLqDU7o@tpad> <aYywl1hdBQP2_slo@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6081FC000D
X-Stat-Signature: 38wfyghj7gapzzsxxq9r9r3os71t8z9k
X-Rspam-User: 
X-HE-Tag: 1771106553-454046
X-HE-Meta: U2FsdGVkX18PiKtQqeYe1BMFzanidohHQ4Mq1Q9eMnwK6KMVKzcBbuE2aFqkgqAASCq3fo2M5Xt30xofVFCJXgjzfZ+sCoQWgzzuH01Kh/UhUv/VGHoFrXEIw7430sdLlbfOfffoj48f/lwM+JuKIOA3iS7YFrdBv9ssQNkayax1ZZoOHWzjPvFdASwrDnItFQmb+LMuQ5Fh6XEnwBEzS/PNLpCS3WpK0x0EsdhNSprmll9G1bYwDmKJqZs0eRPbj0A4DHs19jUmt2KmsD+coCMCNlMkHQHxtRhNNs9vt44vjP8vQi9Ctm0ulyfpp+q4J6zB6btYG5WfhtTW/fRKahJGoIWTz6MIlpetd0KRmhoh+AwAtcbrYvd6fApRTYyTIYR2DmpaYoIgx6oBhQFzUeG1MUsSvF4RuXHzoHqqlDXyWcaqi1JmYuh+nj2V/IGNwcWW7lCNKBlVi/RPH58YszFKqfMLFymcYVw/vxlqaSDPwoOLNjMQom88PXpu2I4k8y6qJvQclMHCJKjE47YurMFDoscmT5kHJNuon7pjoioOwnSY3KjwC6uhGDuoZ+n5KSBcqZxAkhCH4wsN6wg82WVKGwTrtw78B2s8v2tMJwTXtdqZ285GXe2er8DO2qNHRsW/0lPn+6XtF2Inqy+CEBdUrIRz7oWsauSHSDJcmaGf29AndJocZ78ieCRV1fcRa1toH94sf5k1+ZbFNC62CKM//GBk+nMhL7eAs/vC9jjFx31nRSerQEkW0k57I9ehPYnIynbKf9SORYu/LFrK3lprCvLR783eAQhA1OCWsoGrpRgaFWrWfrvXNnDDbzncsD996Hpfqihi6pgxCmB6VuWYqTGSmPg7y3tmnMdqTSCWLicos1hkZBBcp/EFgagx5yVeP+qsajbQfQ4W+C8fbOymxCkPY1oRwobE2p5qyDXtZUviuq/OIwMNzE3j4MXIDKoWvrfmiKLUEQjF7Rl
 EZErj08G
 R51ja065CZNiqWZPUTFUiR8rREkcyHKnwXh8oJYn7TAfHWfVwVSmRnzABVo7/DBEtnsgg2mR9RI2Y3eQzqs3mbAtp8tL/2c7dCqryIpk6LfcLOt2rnAeKy6BtPX4/4/kAigaZD5pNraZedC2j98QmYbPctyqGPU6uDJ1WOFC5xlW1ptnZtUSrscbYq6oMqs+7/U/A6NunYWj7Fj8QO90RB8mpOIMzlI7jDJpQ3G3mPE4RDwIcbFxyI07PC8I2zrwBmAgcXfQMaD/MCC2eZAfmVKayZepcFnVWU7shcg35bATsuOCMUZF8aKYDoENU3D2uqd3KGPaDs6TbvM5Sock7Kp/hMLRusqLrziy6GU761Z8AW6oP0AcUVcnohhwERo5EibNJBcyzSBC94eTMgW2DXLqav4i05W6bUvreY9V+mWTFYfMSYIm15p8ASo5c3ZjKL5hrtGn9iR7IdKbCK9J7QxMp7WBzwUuhNxjTL/xZA0N+AHADKmCxsk5844XyHEeP8w9eNtJeenGqf1HQT3NTGcJ+I9VzW9TOoQNs9v6K8pSl3Ar2L5aSia9oRDZGh7pn664W+GcUR7KzgYOaAMeVifUwwiqdryBkGqnEuZXiKm9XaP9ioemKDe+y9Yxa7sJwIZIoPLyZ3clZ3AEyAJswJN+i7wpw2TRlSd0r
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 05:38:47PM +0100, Michal Hocko wrote:
> On Wed 11-02-26 09:01:12, Marcelo Tosatti wrote:
> > On Tue, Feb 10, 2026 at 03:01:10PM +0100, Michal Hocko wrote:
> [...]
> > > What about !PREEMPT_RT? We have people running isolated workloads and
> > > these sorts of pcp disruptions are really unwelcome as well. They do not
> > > have requirements as strong as RT workloads but the underlying
> > > fundamental problem is the same. Frederic (now CCed) is working on
> > > moving those pcp book keeping activities to be executed to the return to
> > > the userspace which should be taking care of both RT and non-RT
> > > configurations AFAICS.
> > 
> > Michal,
> > 
> > For !PREEMPT_RT, _if_ you select CONFIG_QPW=y, then there is a kernel
> > boot option qpw=y/n, which controls whether the behaviour will be
> > similar (the spinlock is taken on local_lock, similar to PREEMPT_RT).
> 
> My bad. I've misread the config space of this.
> 
> > If CONFIG_QPW=n, or kernel boot option qpw=n, then only local_lock 
> > (and remote work via work_queue) is used.
> > 
> > What "pcp book keeping activities" you refer to ? I don't see how
> > moving certain activities that happen under SLUB or LRU spinlocks
> > to happen before return to userspace changes things related 
> > to avoidance of CPU interruption ?
> 
> Essentially delayed operations like pcp state flushing happens on return
> to the userspace on isolated CPUs. No locking changes are required as
> the work is still per-cpu.
> 
> In other words the approach Frederic is working on is to not change the
> locking of pcp delayed work but instead move that work into well defined
> place - i.e. return to the userspace.
> 
> Btw. have you measure the impact of preempt_disbale -> spinlock on hot
> paths like SLUB sheeves?

Hi Michal,

I have done some study on this (which I presented on Plumbers 2023):
https://lpc.events/event/17/contributions/1484/ 

Since they are per-cpu spinlocks, and the remote operations are not that 
frequent, as per design of the current approach, we are not supposed to see 
contention (I was not able to detect contention even after stress testing 
for weeks), nor relevant cacheline bouncing.

That being said, for RT local_locks already get per-cpu spinlocks, so there 
is only difference for !RT, which as you mention, does preemtp_disable():

The performance impact noticed was mostly about jumping around in 
executable code, as inlining spinlocks (test #2 on presentation) took care 
of most of the added extra cycles, adding about 4-14 extra cycles per 
lock/unlock cycle. (tested on memcg with kmalloc test)

Yeah, as expected there is some extra cycles, as we are doing extra atomic 
operations (even if in a local cacheline) in !RT case, but this could be 
enabled only if the user thinks this is an ok cost for reducing 
interruptions.

What do you think?

Thanks!
Leo 









