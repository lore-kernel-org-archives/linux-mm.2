Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76C7CE7BD8A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 11:01:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4BAF6B0089; Mon, 16 Feb 2026 06:01:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C12DC6B008A; Mon, 16 Feb 2026 06:01:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B089E6B008C; Mon, 16 Feb 2026 06:01:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9DFFA6B0089
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 06:01:01 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 62A471A0D8E
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 11:01:01 +0000 (UTC)
X-FDA: 84450027522.15.9A56060
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com [209.85.221.67])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5C94720019
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 11:00:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=SotkTlza;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.67 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771239659; a=rsa-sha256;
	cv=none;
	b=WiRDe0udDY0g+OKM6xCxer/fGSrZ9gkbG99R6HO01cdbHKYlCyNhTtrRsq3bLb9NnjDHEZ
	qttNHxmrtxnBv3dSD7bKV/9zMna8XDuGMeXKXJ45ru5TAy86ggk/ri2u//LYDcz9Blck0y
	3ZfuMqS9eR59MDojgQx05y/7TKx5Q0Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=SotkTlza;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.67 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771239659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jzgolleu2SIxliK/vEtotu12nLOXFd4HqJviqi0SJ1s=;
	b=7ZWtf7PvWXmjKOHmTp5N9AwxvPZ9GvL3RVKgHjV5aR6uZAY3aiNrtHjlQCL2wLgOWlwJgT
	Wa9lhXWVKNPm3DH5jzvFaW58IV4q0rPxo4qxqrJidfCu+NW50pREVZ+ObXbPhqIO6J9I8s
	7D7F9ZsyoxkotnXRCK8JKcCr6ZKTLWk=
Received: by mail-wr1-f67.google.com with SMTP id ffacd0b85a97d-4359108fd24so2058840f8f.2
        for <linux-mm@kvack.org>; Mon, 16 Feb 2026 03:00:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771239658; x=1771844458; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jzgolleu2SIxliK/vEtotu12nLOXFd4HqJviqi0SJ1s=;
        b=SotkTlzaFU38x3JVvayiMMFGozYolmacNcQ5c7cepI0fUEUN93tN3gPjdXUq+ASQQ+
         ku02Y86M1AawT2p1rvEIw2yfgs/gavRAOHsmt0Jq3+8IfAw82YXP6JEepLUODYl/YPUK
         Ygoo+eYYVDnecuecCGhHGf8TUm8dNiw3+OfSki4KcwP8GsOLSW9CrM945lCB0LIGgIx+
         AGfoZ+VHINXawxAFUMUuaD39cT/fYF5z8VLpYk4fLCJmcMMnnm2lSmRT+l2/Tr9RqWdS
         Zse1YYJI5XcFOWnOkgSqFwl34eyNdp/zl3Avy+iGDQ4cPHjfYkz/gr31zWBp31HaB0mX
         rgKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771239658; x=1771844458;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jzgolleu2SIxliK/vEtotu12nLOXFd4HqJviqi0SJ1s=;
        b=D43k9CMZre9MWkLy8q01SZXVnUTebXDXsOABEKMGxocAfIb+nSAdNkzBhZxW5Mguz9
         a8qbMkHKUvu/qE9kdIWQFZynbc/xZsFslbOvEPW35w0D9zdzQTVcWLXfx90Ep8FW76zy
         36gY6BKFOPJS2K5XdFU3kbUnyWNC0OwKAk+hCMtnCfefm1aaUdHL9euRAENxKyPPccI7
         ZsXYJDEQSocP9mNXJ22F8mSLzZdPfoRntTvD6Ev4YmXZmw0J/VmAFgOrArbzl8fnJCSs
         68vlyuHRLtWQ+GVE8nela2z56eVXjppzXO6OszJzSMGUVY51NPDXWjOXZuh/z3VdNVHG
         hegA==
X-Forwarded-Encrypted: i=1; AJvYcCUzJsFZRK3Y2g3nL+lakt7+qNqKXWCkCpD7RCzRx1AxpfTJBUr5IzBoqlMmdtBTQrhQV6wxfUXXbQ==@kvack.org
X-Gm-Message-State: AOJu0YxvIkiQX1K6r47ncAxHWG4wpTRhuC+xSWkcCOjoS/djG5dFdHkg
	RT72qCyf+BSGDY8mcvQH/anoRFaSOMzpQwsglYBItS+82g9SLxFr+vVQNl7FDTQrPYY=
X-Gm-Gg: AZuq6aJYmlp57wIwxMsPVqrK+djo8SBqTuYVA4AsB1pdcXpMRU0QrsT0hXTE81ttlM0
	0M3c9/yPtsvKooeK3tnNZnUvlggprS8eW5nmb6YYNwbu8f0ULtjjvhmvtpX3HtWhQ55pYsC8qJY
	sjoFzZACbFZngFszmPjYxbVyFOvmFezDDsULbJ337qXrtm/DCRq6uvbuDWcCE95Zv9h3kvK7tVj
	5/tm7e9N42gomqQ8hxvrn1r0dD1GcN5pO60eqwOwNgUOlVoYoC3C4l+R6qgoFyqb3lGPt7SYR/Z
	CdhAu1DtwlbxhNcn3clTrBlyUpKE2XV9OUajyBFCCthtGrohNZMTWydjMWd/cYPBiDrym+Yj8G0
	j18o4SENEU7EdzZxqdBUk4G/Ky4QA7h1wtpduei8aHnuzQYpxGGGaxU4iqGHgjivlGQz6lsKVn/
	klMe8KHgPZjA/xwowboZXpTjvfMFiYwpS0hc8l
X-Received: by 2002:a05:6000:3102:b0:430:fdc8:8be3 with SMTP id ffacd0b85a97d-4379790ef6cmr18730047f8f.29.1771239657494;
        Mon, 16 Feb 2026 03:00:57 -0800 (PST)
Received: from localhost (109-81-87-131.rct.o2.cz. [109.81.87.131])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796a6a5f0sm25813158f8f.11.2026.02.16.03.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Feb 2026 03:00:57 -0800 (PST)
Date: Mon, 16 Feb 2026 12:00:55 +0100
From: Michal Hocko <mhocko@suse.com>
To: Leonardo Bras <leobras.c@gmail.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Frederic Weisbecker <fweisbecker@suse.de>
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Message-ID: <aZL45yORfkNvS9Rs@tiehlicka>
References: <20260206143430.021026873@redhat.com>
 <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad>
 <aYywl1hdBQP2_slo@tiehlicka>
 <aZDw6xI2izFDfuuu@WindFlash>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZDw6xI2izFDfuuu@WindFlash>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5C94720019
X-Stat-Signature: 1513dq8dbxbo7rkghc83ghgs8atsha4d
X-HE-Tag: 1771239659-459961
X-HE-Meta: U2FsdGVkX187NEF8bw9KPhaQt5ss22JG3//KNSU7mPs/HPRoGv5QleV/NaXipgcCJwK1VZxz5BuN4eoSb9Q9YFVCVRc/r0xlRcKXkK5Rg4IVdu4TFPJ4k7GR4+ut+7p6FG7oxZW1wE04mBvuFI/82kmKepleZmxGiXv9GM/T3kZEE/2BvPxZxC6uVEznCsFY4TVz/CuB7rsEDbOBP12YdI0vvXA41wBYVmoPhuAG/MSf5dOEoDQG9PBYM3m9oAYMtsSToR//vHcXTK5RZ2v5LxXfpsY2nu9KaBRQYBSmYMoKJuVM9ikuzPFar1wRF+6lhh6IyZLvM6WIUxnyq00iQoQAXWL91fNRU2poXEjdzjzXmjnYgCCCvr7gLzcjNU/yc8l6DXCYPA0b/MCrgPRCKqif2ZrT6LK4QwXah3EMy3KCQa8LtixZtFt08dLGptlfFHucUdRM7vPbQ/lavdeqinnymRMgRRhGujb2KG+gothEHJkmSIerr8OP4Clc9vujvEfLiLkNPL/tWNeQzNs055Df8O7JpNGCRle7k0V0wukzS++hGh7GfzXrNsIDgs01NzBX+jIYQaiX6Jee1fvV9w1HSASF6RTSM7PABCROSg23uBUdgyR1rT1KvVMmhFUAdNNy7IT+5qfeArgE/UXgha2BQalPy+iyk50P3GVLPhcM1JpShya4J7IrDWOGERzXvwTkPdcB4j5Bvq32tVjfYX6i+3Mdo+POYz8yNHh7a5aSC2VnCIF7TdAvMJ4BBCz6kLnnSk/OhrHMyGhIjgbfCpYQ+25vFx61zBn44L3Q+zcQQQsAhUAkMJxDEyG36elMmGFkNFJ7dnnXvIeBxByPBkTZ+sp31MlEmzjXwXQZm+UpQ7cuj9Tj6sd7VYSnHBcBK5UY6K9ORVx0fJ9O/840S9tt/rVvDJJvLohLNxFHTvOIbSzU/kZXe3hRToRHo9RRlOmXaZ35yLuYlrLtohT
 roEcJ2B6
 Lk558r8Mw0TuWlQi9X8LBXATWPPhuw2gGFj88tlqWnJIzkvZT5LncdOG5s6QTbRoQVsOP/Tt8v8q0yDJsaWOeeSzUzpJqW5+CcHccVVdEXBNFSjB8A56pBoKgJZTkiLwy90zA4jd9ds7U7bTmJ2T0FWr0u+2hWiXxiKYwcmO8hVfg1LZPr4tsFdrIB1335RaU8tKC4vsisCUBxPn8qAtNhoCVuZZkDr5eaH3PyERITLT/DqDYtNBFcOjdmlz/sCbDb7ZsUclrJxAJ+p9ynqNyLJzyrjJPgxaxu80ilJkMNdBWlnq2AczTBI3l5rCYyNB6Mr2YTvIyCgCShzjF1Mv+pkJ9FsJT2kDmoh5WB9EX/3/Ba2Wl9wgtLIxjPp8tvixWicuCwuUJRU8TpGsKj4EFUMY9uHC27xbRsO4kbkS0rmcT1+rZioqkCrzv62W91uJB+JeSfbKoZa6vb/3n27lVXB/sKZGqSYDT8bEzADhBLxTIZSXcQlKBeJBowF06tZ83vsLx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 14-02-26 19:02:19, Leonardo Bras wrote:
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
> > 
> > > If CONFIG_QPW=n, or kernel boot option qpw=n, then only local_lock 
> > > (and remote work via work_queue) is used.
> > > 
> > > What "pcp book keeping activities" you refer to ? I don't see how
> > > moving certain activities that happen under SLUB or LRU spinlocks
> > > to happen before return to userspace changes things related 
> > > to avoidance of CPU interruption ?
> > 
> > Essentially delayed operations like pcp state flushing happens on return
> > to the userspace on isolated CPUs. No locking changes are required as
> > the work is still per-cpu.
> > 
> > In other words the approach Frederic is working on is to not change the
> > locking of pcp delayed work but instead move that work into well defined
> > place - i.e. return to the userspace.
> > 
> > Btw. have you measure the impact of preempt_disbale -> spinlock on hot
> > paths like SLUB sheeves?
> 
> Hi Michal,
> 
> I have done some study on this (which I presented on Plumbers 2023):
> https://lpc.events/event/17/contributions/1484/ 
> 
> Since they are per-cpu spinlocks, and the remote operations are not that 
> frequent, as per design of the current approach, we are not supposed to see 
> contention (I was not able to detect contention even after stress testing 
> for weeks), nor relevant cacheline bouncing.
> 
> That being said, for RT local_locks already get per-cpu spinlocks, so there 
> is only difference for !RT, which as you mention, does preemtp_disable():
> 
> The performance impact noticed was mostly about jumping around in 
> executable code, as inlining spinlocks (test #2 on presentation) took care 
> of most of the added extra cycles, adding about 4-14 extra cycles per 
> lock/unlock cycle. (tested on memcg with kmalloc test)
> 
> Yeah, as expected there is some extra cycles, as we are doing extra atomic 
> operations (even if in a local cacheline) in !RT case, but this could be 
> enabled only if the user thinks this is an ok cost for reducing 
> interruptions.
> 
> What do you think?

The fact that the behavior is opt-in for !RT is certainly a plus. I also
do not expect the overhead to be really be really big. To me, a much
more important question is which of the two approaches is easier to
maintain long term. The pcp work needs to be done one way or the other.
Whether we want to tweak locking or do it at a very well defined time is
the bigger question.
-- 
Michal Hocko
SUSE Labs

