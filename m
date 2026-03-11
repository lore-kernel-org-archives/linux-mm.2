Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3995FD88D4
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 00:03:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DDDC6B0088; Tue, 10 Mar 2026 20:03:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 287A46B008A; Tue, 10 Mar 2026 20:03:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 178776B008C; Tue, 10 Mar 2026 20:03:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E9FD96B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:03:47 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6BF981A0326
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 00:03:47 +0000 (UTC)
X-FDA: 84531833694.06.023E957
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf13.hostedemail.com (Postfix) with ESMTP id 540AC20008
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 00:03:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SxbpFxWt;
	spf=pass (imf13.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773187425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Th9+VLFBVmNjfXAWGXevm/XrdfOj2rwXBpkvnIti7NM=;
	b=5xSu7aPwzPaWJvjn8bwEYxx9C+jwJqNBSim5BTiZjQlkzYM43SCbULhLqwELrek9LvDfrJ
	P49a4ipRrm00IpFJwQ3zdKGv0b4ftc99E1yvS8yLxuMc+1l3Ex2MYHE1eJbNtAP3MCA4BQ
	ebNryQGut3LhoL2BzV5KNbf4dbC3HF8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SxbpFxWt;
	spf=pass (imf13.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773187425; a=rsa-sha256;
	cv=none;
	b=4nwqB7dhiGEqwnhTKXItxBF4Eac4vOATCbCBX+xBJYVBOh4ysTPCeM/I/cup5e0b1lINgl
	eps1eMVVhfd9CCuR214cpsR5yJuC6uAMEFBJbEdxTf3NTrXiSP/mxNK8VOEPevB2IN6cqS
	jiNOT7obWhUi8EwHv5j8EydAxUeB3bs=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4853510b4f3so46030195e9.0
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773187424; x=1773792224; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Th9+VLFBVmNjfXAWGXevm/XrdfOj2rwXBpkvnIti7NM=;
        b=SxbpFxWtdozcVaYZJ5cTOlR4fCVUOFNJMi113tQVVXyTMJ3nO2n8v2QRjIeqOkNWGk
         VaV+XRnaxPlI1lDtuW2PxuhHHtQFFYoT+0jGyYo6DDx4WHUm+6NnGH/dSvwqtd3X9Xa9
         r6c1fA1lTIIYLa56lWbv4iVjAFzCnF3ki9+dKVqzZ5jGpManJ+oDl6roTyoj2AY7KUDk
         bysTsD/8Mft2wnSIwedy4G85CHvomaBc640oYPxoGd5w4TjrrFMY8WeP8ZaBKNYCELqM
         O7qWW3NEEEnxAmMkfYwdS4+bFUsseMfsAhH7rSoHeGbFbY0eR/AyM3lZf36mxtEHzEsi
         TADw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773187424; x=1773792224;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Th9+VLFBVmNjfXAWGXevm/XrdfOj2rwXBpkvnIti7NM=;
        b=OlzU62CEhwWfySXR4+KVCwiL8VWBahdwYP+5VnXzMAoqFD1aPJt6x2lgm+Kdf3B9Ue
         wg6lhs6c9NvRtTs3TeLfjNu3frdbGQ6klri2Bcwa6NcdShGuLrU1H6bUXtefOM7hiVPa
         Gv89in/f99y4bIwZkpjo57vK6yFQHJ7autrAz5U1dEy772e/y3C2n/IadyLEWYQRl/ks
         pJfgL7Yb/RfhdAjGPSJL6MM5wU71ZXsSL3Jhk2dtS3m4gSyO5ZdJ0mBgzo0lTYDNns0B
         +/tMyO0xJg2x89ALS96dedvtIaI+ek6rLpehD5UiD9qy7lvzKkb9PuErGiGlspV1CKlY
         fA2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUSSpENy4AhK03D/tgiDrgB9gFeM2N3ZUJmq+XyUFKg63h0oIbyyMHkGMCPFFhsLo7CeE3Xrzg8Ag==@kvack.org
X-Gm-Message-State: AOJu0Ywb3sety6bV49Q0gC2c/RU9s0u4ehNEEoXElcCZ4O4o5e7k4mOs
	DMa2lSQ3wu6OrBT0qcU9MibrEk/YQ06vI9NLbrex3rd0HnFifkfSj8Wd
X-Gm-Gg: ATEYQzy1EQYYTktZVyuJDRQRU95nJHPNFFaR8a4J8v4yAEaDWqB3ChA2uxVx6i+eK1y
	ohxUWfpH2tg1ipybZMbveJWedEC4GO8Yw7Vi7gZ17jRjth8dhhus5YCkgIhAyOLEZHhttu70MVn
	No0IO+bVn9qtvrsGQjH48ULSioUtr3QOu7cDKzMHHJJ2LHFcRjlCWX5/anRKlihVZPQdzoe7Qsa
	mWH7uJBbA7y+Yh3LbLeYb0aLl35eQJs1vqZ0W8rzs3JV66M44kdQrBrKMjcx8vxF02YLZuaOqeO
	G3zTjtr7sMVTztAzgu+6a9Uh6N9fk2pCUCeRBLzMPS8Ph7qnQnO91s0ThJ1JgXDzSLF3OzSoUHN
	PhfjEm7DjlD3WuQ5VqKfu8q+UY+IFmnps3vJ9d8wvB4Hs6XYmu3nCwiKLAXKZmZfIu0blB35ORX
	5LcCXdBmzcmBekoC9DcXZ/gTE0L60aCD0ojGdI0wAi1aGzsA==
X-Received: by 2002:a05:600c:4510:b0:483:c35d:367f with SMTP id 5b1f17b1804b1-4854b0fe742mr10028125e9.21.1773187423502;
        Tue, 10 Mar 2026 17:03:43 -0700 (PDT)
Received: from WindFlash.powerhub ([2a0a:ef40:1b2a:fa01:9944:6a8c:dc37:eba5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48541ac17f2sm105012385e9.6.2026.03.10.17.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 17:03:43 -0700 (PDT)
From: Leonardo Bras <leobras.c@gmail.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Leonardo Bras <leobras.c@gmail.com>,
	Michal Hocko <mhocko@suse.com>,
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
Date: Tue, 10 Mar 2026 21:03:41 -0300
Message-ID: <abCxXZCJPgNuOPG2@WindFlash>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <abCL8vE3cttL1Yq0@tpad>
References: <aYxviLoWsrLqDU7o@tpad> <aYywl1hdBQP2_slo@tiehlicka> <aZDw6xI2izFDfuuu@WindFlash> <aZL45yORfkNvS9Rs@tiehlicka> <aZjY9h3XXMNY-Ytd@WindFlash> <aZwYmNuucBspCYhk@tiehlicka> <aaJDjmnfuo8AM6J9@WindFlash> <aaYpICV55B70U1I2@tpad> <aa20uDGqnmiqYJ1w@WindFlash> <abCL8vE3cttL1Yq0@tpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 540AC20008
X-Stat-Signature: hjniijooozsh5cypn4ncmua19mouzzuk
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773187425-914309
X-HE-Meta: U2FsdGVkX181308WlAJoAgU2q9QS2Ky5s58zTOz7UReSad8L7BTlYpvX48GaEa0GeTILAlWLyA3l+ZVNUlgAsm1rrpHCKtWBHwm4VRpmABNyBaTKDkwBxN9QxmDQ/Z8D1otJ3iHO575vmpZwLlMsIeN0Uj8Qvkvv/tLEL/imodpbyFexhZLvFZg+HKra05WfDQRtnPX+77zmc6kmBh5n32q1GHbsbl7WHdmwItTGw4j8pGiezaSW+J5r8M8L/eHEeemK34z2x7pRfsUukCWxplMUPYQTcOcbvuxURQgebPBqJC9/GgmgD1yS0U5KyxAFNF48cXxfKkakmAqWBMOYKy2m15FJ1EJAKDzkVXmlqVly3H8DiSGsyGNHUSM+1NI9KYKY8ko4vLcyz9Fzy2G1S23Oa/tBDKEHtVN12rtiIKPqFcXLmwqR34gyd9JmPY1x2Jo5FqLNx5HPW9QNfNq5YBBx+E4XH4nAmfwyB12gvhkyMRVkRV+4irriibUoU4+30tQPglrXFohys8kkN9oyZMzHLKZkjGe+ROAS0y26F0imCJDWIlg3HM5bjxSh62kXQEEZC+0nES0MSdFKME4ASbZqSuXyKAz58kJcKiRmz65xoCEXmE65pnbAHWyN2EGDGYdtuD0O9v4XdxS2gT0uf+314fZkdYkk+cJxH0abMhM8pGfxUB8/kSE7ZGxAo6Ro7pSw0Pld/DePgMp4PumVDqgSkouc98SsA27azMaSITOrsTwihJ0XvX3MPSX9oBWBhLE7RN8Op9lkqex5fzaavX4ofzpeSiCS6Pv1yAe8bwxPg+JKwy4ZAl9kgqCsDc9RtE8HkeTjaRmKMQjUNxqeuCtzgtyb1dlN3psGPMF4CuqV5lczeZGU/Hqv7LcZvIB6ZEvwpF1Ob5vaP748UqgNXdxf/Xka1pvNoZ5AsoX9BpjcuUQtwfCj4EKvVoiBdW7SomgID4ubhG9LT3sRLqT
 T/ByEkMI
 FMQknYfMotyBmmfONuh/cOzHRKO1/viWeiA8wqq0i4ShMxOtTZ5ObWy+nQ+nxRLYyYtED7XZNR33ObMy2F4Dyul6+Gvuc6/F0cxIIiLn7lscLl8Gh+iR87TcnEQhjatByer8vojpv9ZTebWfmf0gg34KTtxA8SCR/YgSRbgrQr+84MIUCFTgy8UOs05XzyE5ZH31seSqR9llX0SCbFEhhMb5emcnZSD5ykROdgPVeSLM5dAUykvh9UCnM2TWf4CaWKhRShTtmpfIGXbj/3FzJQt5OGqNOFIK2BRTOsG5Jl6EM/IHaAbSf150fPR3xAoP1NAmKoctlO7uRAl/UDrnQLn6YsbM3ylTBPcmakGCDDXWCw9Yqm75UoODmwlNi9UwWepyzyKXSjL9XU+bYvqpsKjo1Ro9w9Jk2DYuQe52myKfHcPAt7Ja1+keox7sMwalzAIQGjUCLNNMhzUNgswh370b1OfSVbt5hoLs+EoL/hkY06WaT7qXw0+Q47BXlEDLoqqPcWI7C9wUUDj4FPU8T4I9ilRf/5gHd+Luxkt3/e0mvcU5E8cX0HHmoYUPvpaTgX0fCG62fxMEyHBuh6hK30f1H+0IuiLCCj4yj1Ar685ln5vEJnlC9F5B1nhket4zrMSVp09WdgJv/bsryHXNwELFE1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 06:24:02PM -0300, Marcelo Tosatti wrote:
> On Sun, Mar 08, 2026 at 02:41:12PM -0300, Leonardo Bras wrote:
> > On Mon, Mar 02, 2026 at 09:19:44PM -0300, Marcelo Tosatti wrote:
> > > On Fri, Feb 27, 2026 at 10:23:27PM -0300, Leonardo Bras wrote:
> > > > On Mon, Feb 23, 2026 at 10:06:32AM +0100, Michal Hocko wrote:
> > > > > On Fri 20-02-26 18:58:14, Leonardo Bras wrote:
> > > > > > On Mon, Feb 16, 2026 at 12:00:55PM +0100, Michal Hocko wrote:
> > > > > > > On Sat 14-02-26 19:02:19, Leonardo Bras wrote:
> > > > > > > > On Wed, Feb 11, 2026 at 05:38:47PM +0100, Michal Hocko wrote:
> > > > > > > > > On Wed 11-02-26 09:01:12, Marcelo Tosatti wrote:
> > > > > > > > > > On Tue, Feb 10, 2026 at 03:01:10PM +0100, Michal Hocko wrote:
> > > > > > > > > [...]
> > > > > > > > > > > What about !PREEMPT_RT? We have people running isolated workloads and
> > > > > > > > > > > these sorts of pcp disruptions are really unwelcome as well. They do not
> > > > > > > > > > > have requirements as strong as RT workloads but the underlying
> > > > > > > > > > > fundamental problem is the same. Frederic (now CCed) is working on
> > > > > > > > > > > moving those pcp book keeping activities to be executed to the return to
> > > > > > > > > > > the userspace which should be taking care of both RT and non-RT
> > > > > > > > > > > configurations AFAICS.
> > > > > > > > > > 
> > > > > > > > > > Michal,
> > > > > > > > > > 
> > > > > > > > > > For !PREEMPT_RT, _if_ you select CONFIG_QPW=y, then there is a kernel
> > > > > > > > > > boot option qpw=y/n, which controls whether the behaviour will be
> > > > > > > > > > similar (the spinlock is taken on local_lock, similar to PREEMPT_RT).
> > > > > > > > > 
> > > > > > > > > My bad. I've misread the config space of this.
> > > > > > > > > 
> > > > > > > > > > If CONFIG_QPW=n, or kernel boot option qpw=n, then only local_lock 
> > > > > > > > > > (and remote work via work_queue) is used.
> > > > > > > > > > 
> > > > > > > > > > What "pcp book keeping activities" you refer to ? I don't see how
> > > > > > > > > > moving certain activities that happen under SLUB or LRU spinlocks
> > > > > > > > > > to happen before return to userspace changes things related 
> > > > > > > > > > to avoidance of CPU interruption ?
> > > > > > > > > 
> > > > > > > > > Essentially delayed operations like pcp state flushing happens on return
> > > > > > > > > to the userspace on isolated CPUs. No locking changes are required as
> > > > > > > > > the work is still per-cpu.
> > > > > > > > > 
> > > > > > > > > In other words the approach Frederic is working on is to not change the
> > > > > > > > > locking of pcp delayed work but instead move that work into well defined
> > > > > > > > > place - i.e. return to the userspace.
> > > > > > > > > 
> > > > > > > > > Btw. have you measure the impact of preempt_disbale -> spinlock on hot
> > > > > > > > > paths like SLUB sheeves?
> > > > > > > > 
> > > > > > > > Hi Michal,
> > > > > > > > 
> > > > > > > > I have done some study on this (which I presented on Plumbers 2023):
> > > > > > > > https://lpc.events/event/17/contributions/1484/ 
> > > > > > > > 
> > > > > > > > Since they are per-cpu spinlocks, and the remote operations are not that 
> > > > > > > > frequent, as per design of the current approach, we are not supposed to see 
> > > > > > > > contention (I was not able to detect contention even after stress testing 
> > > > > > > > for weeks), nor relevant cacheline bouncing.
> > > > > > > > 
> > > > > > > > That being said, for RT local_locks already get per-cpu spinlocks, so there 
> > > > > > > > is only difference for !RT, which as you mention, does preemtp_disable():
> > > > > > > > 
> > > > > > > > The performance impact noticed was mostly about jumping around in 
> > > > > > > > executable code, as inlining spinlocks (test #2 on presentation) took care 
> > > > > > > > of most of the added extra cycles, adding about 4-14 extra cycles per 
> > > > > > > > lock/unlock cycle. (tested on memcg with kmalloc test)
> > > > > > > > 
> > > > > > > > Yeah, as expected there is some extra cycles, as we are doing extra atomic 
> > > > > > > > operations (even if in a local cacheline) in !RT case, but this could be 
> > > > > > > > enabled only if the user thinks this is an ok cost for reducing 
> > > > > > > > interruptions.
> > > > > > > > 
> > > > > > > > What do you think?
> > > > > > > 
> > > > > > > The fact that the behavior is opt-in for !RT is certainly a plus. I also
> > > > > > > do not expect the overhead to be really be really big. 
> > > > > > 
> > > > > > Awesome! Thanks for reviewing!
> > > > > > 
> > > > > > > To me, a much
> > > > > > > more important question is which of the two approaches is easier to
> > > > > > > maintain long term. The pcp work needs to be done one way or the other.
> > > > > > > Whether we want to tweak locking or do it at a very well defined time is
> > > > > > > the bigger question.
> > > > > > 
> > > > > > That crossed my mind as well, and I went with the idea of changing locking 
> > > > > > because I was working on workloads in which deferring work to a kernel 
> > > > > > re-entry would cause deadline misses as well. Or more critically, the 
> > > > > > drains could take forever, as some of those tasks would avoid returning to 
> > > > > > kernel as much as possible. 
> > > > > 
> > > > > Could you be more specific please?
> > > > 
> > > > Hi Michal,
> > > > Sorry for the delay
> > > > 
> > > > I think Marcelo covered some of the main topics earlier in this 
> > > > thread:
> > > > 
> > > > https://lore.kernel.org/all/aZ3ejedS7nE5mnva@tpad/
> > > > 
> > > > But in syntax:
> > > > - There are workloads that are projected not avoid as much as possible 
> > > > return to kernelspace, as they are either cpu intensive, or latency 
> > > > sensitive (RT workloads) such as low-latency automation.
> > > > 
> > > > There are scenarios such as industrial automation in which 
> > > > the applications are supposed to reply a request in less than 50us since it 
> > > > was generated (IIRC), so sched-out, dealing with interruptions, or syscalls 
> > > > are a no-go. In those cases, using cpu isolation is a must, and since it 
> > > > can stay really long running in userspace, it may take a very long time to 
> > > > do any syscall to actually perform the scheduled flush.
> > > > 
> > > > - Other workloads may need to use syscalls, or rely in interrupts, such as 
> > > > HPC, but it's also not interesting to take long on them, as the time spent 
> > > > there is time not used for processing the required data.
> > > > 
> > > > Let's say that for the sake of cpu isolation, a lot of different
> > > > requests made to given isolated cpu are batched to be run on syscall 
> > > > entry/exit. It means the next syscall may take much longer than 
> > > > usual.
> > > > - This may break other RT workloads such as  sensor/sound/image sampling, 
> > > > which could be generally ok with some of the faster syscalls for their 
> > > > application, and now may perceive an error because one of those syscalls 
> > > > took too long. 
> > > > 
> > > > While the qpw approach may cost a few extra cycles, it operates remotelly 
> > > > and makes the system a bit more predictable. 
> > > > 
> > > > Also, when I was planning the mechanism, I remember it was meant to add 
> > > > zero overhead in case of CONFIG_QPW=n, very little overhead in case of 
> > > > CONFIG_QPW=y + qpw=0 (a couple of static branches, possibly with the 
> > > > cost removed by the cpu branch predictor),  and only add a few cycles in 
> > > > case of qpw=1 + !RT. Which means we may be missing just a few adjustments 
> > > > to get there.
> > > 
> > > Leo,
> > > 
> > > v2 of the patchset adds only 2 cycles to CONFIG_QPW=y + qpw=0. 
> > > The larger overhead was due to migrate_disable, which is now (on v2)
> > > hidden inside the static branch.
> > > My bad.
> > 
> > Hi Marcelo,
> > 
> > Great, hiding migrate_disable under the static branch is the best scenario.
> > 
> > I wonder why we spend 2 cycles on the static branches, though, should be 
> > close to nothing unless the branch predictor is too busy already. Well, we 
> > can always try to optimize in a different way.
> > 
> > Thanks for the effort on this!
> 
> Leo,
> 
> migrate_enable was leaking out of the static key section 
> into the common error path.
> 
> With preempt_disable, as suggested by Vlastimil, those 2 cycles are
> gone:
> 
> [   61.217232] kmalloc_bench: Avg cycles per kmalloc: 164
> [   68.047789] kmalloc_bench: Avg cycles per kmalloc: 165
> [   73.266568] kmalloc_bench: Avg cycles per kmalloc: 165
> [  120.634168] kmalloc_bench: Avg cycles per kmalloc: 164
> [  127.617872] kmalloc_bench: Avg cycles per kmalloc: 164
> [  157.803679] kmalloc_bench: Avg cycles per kmalloc: 163
> [root@fedvm kmalloc-perf-test]# dmesg | grep qpw
> [    0.000000] Command line: BOOT_IMAGE=(hd0,gpt2)/vmlinuz-tip root=UUID=35cfa00b-ed70-483f-b7b2-1964e14f719e ro rootflags=subvol=root console=ttyS0,115200 qpw=0 skew_tick=1 tsc=reliable rcupdate.rcu_normal_after_boot=1 rcutree.nohz_full_patience_delay=1000 isolcpus=managed_irq,domain,14,15 amd_pstate=disable nosoftlockup crashkernel=1024M
> [    0.118274] Kernel command line: BOOT_IMAGE=(hd0,gpt2)/vmlinuz-tip root=UUID=35cfa00b-ed70-483f-b7b2-1964e14f719e ro rootflags=subvol=root console=ttyS0,115200 qpw=0 skew_tick=1 tsc=reliable rcupdate.rcu_normal_after_boot=1 rcutree.nohz_full_patience_delay=1000 isolcpus=managed_irq,domain,14,15 amd_pstate=disable nosoftlockup crashkernel=1024M
> 

Ohh, awesome then.
That means we can have a QPW-enabled kernel and zero overhead perceived if 
qpw=0, right?

(Yeah, instruction cache will have to fetch extra instructions, but 
hopefully that stays hidden enough.)

Thanks!
Leo

