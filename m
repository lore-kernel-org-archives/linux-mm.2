Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F3C0C982C5
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 05:15:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D2CF6B0005; Sat, 17 Jan 2026 00:15:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 181516B0088; Sat, 17 Jan 2026 00:15:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07F856B0089; Sat, 17 Jan 2026 00:15:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E6D2A6B0005
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 00:15:38 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 762951AE6C6
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 05:15:38 +0000 (UTC)
X-FDA: 84340293156.15.B711815
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id D5D50180003
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 05:15:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N7tKF2Qj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of dennis@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dennis@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768626936; a=rsa-sha256;
	cv=none;
	b=oL5PUO5YW4nt8OGdExqyi1VvwHkmT4dGblrU47dvP5FDQPioH99g8R6Zeeu0APZxHJJKi5
	uNz28D3LMqyd4bzLF0tg3JZ+mrlfAC9Rbwxu4mWfVNTmIF3ahtW+54ACJkiTLHHO7yAAFh
	iulgqRHqRiL0GYxkP1fg2ECriH79j4U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N7tKF2Qj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of dennis@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dennis@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768626936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ir9anzKv8qQc3gHnDdk8ILbpfgh1FViIzPmjLfL7fSA=;
	b=3cYWkdlswhbO0sRs2f8oQiqCRyzv0Fyoaf4d1MoB7pBmb+93Z4D7IoPhVGGQTqqPBZUC2z
	NObmss5LlZbil3nn00VnHnHp1I0lAz2Yt5zwJyEyQ7qIQ1w5H4ERFPPhgq+WWMRTYSiOxz
	Py0eSdwAS/Thv5i3YrSCk9H5jVIclrg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DC61E60127;
	Sat, 17 Jan 2026 05:15:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14BB1C4CEF7;
	Sat, 17 Jan 2026 05:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768626935;
	bh=4bV5pAL0giHA+Gy/u2o8V868GCBLsEXgHcdyuoQKbUE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N7tKF2QjP7gr3hKplsr6CSaa+ZujiPEOnH2ktpCrtbXdF8b0Ar55N52hFtMiQITY7
	 B2UyJa4QdDaeS/ZCwJgf5ZA8Q+aDnQFoo/kjXJO4IqNPM+k0XPycQHkMHcMyZhGYau
	 thV6aWaikJhDBRm28dKN1UqZ47V42RwHZYKpts1uFr94+A8qKjk6kwHZAz1gz2VUd9
	 1vMwbdq7e2kE9kh/UF7e7aLgrMXOag3zY/cZPl5t8LyYFAtEJsfxW2YjNGmebmBgOn
	 0trm9QkVA2rig73ZAO0r99Lms+LDh7lUUxkOG3BOwzEzjjJS5uHba9dSj8Eb7aJKii
	 Ctwd/T6pCC23A==
Date: Fri, 16 Jan 2026 21:15:33 -0800
From: Dennis Zhou <dennis@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH v2] percpu: add basic double free check
Message-ID: <aWsa9SdO9kLJTfz4@snowbird>
References: <20260116023216.14515-1-dennis@kernel.org>
 <20260116191548.7df814c2a9eea1a9fa3c4cb5@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116191548.7df814c2a9eea1a9fa3c4cb5@linux-foundation.org>
X-Rspamd-Queue-Id: D5D50180003
X-Rspamd-Server: rspam06
X-Stat-Signature: hdjqwfzgwaqgxyy1q6hbdhxdemcininm
X-Rspam-User: 
X-HE-Tag: 1768626936-24232
X-HE-Meta: U2FsdGVkX18PFjjmzQdxigOsVabYGkk42sb5Ttj5NWhml/pWldf/e3IY6lrm23N+Ck6/tEaJ3GPGzLXE7jyk8DyeFYJZSpQ0dGmy1csfu1FNOKI8ZxBJWVWt8xYP372oLgqOdm/JLIZDIepBJ5MXWoA+krU1POrHe5fHXEh7JsxNi8wtWAoivqyktejQ62VDAwLSvLt0cm1CcSqxCHUo+fvj5PkJhN4usUNjmPbhegOQekEHo37EAGUk4it8T02zDc2s5as7iKflnXJOdQXX/W4ngmYPDAA6V4OwsUG/LEDfBgDoTiIijlOHBnuwn5MY8h2Hnt2Q5hTNB0Ebk+w91wbYKfIQ7yBOU7OiqgEnbKN2AcFSp0vdVu9CK1EVB1hNG6r9Hqa+OzSk12MBN/X4JkxD/W/9C1byysMRC4HgBWfh3yBHiYMRS1qJJZSLxs2i6r2c+UFdBonL/nq4fjMla2YGgOtYFlqY2dGbKb2iVyf7CR2SnYqXsHE1vjHOv+FC3jyPg1I0YcvKnVGIKZ5K5ilrrBGptNNrBToM2ZecoQN+WUFWXs8rFh671xDt431aqO9txph7Wl3Aw7hrukZi+oNjFgOU1C7I5GjhCpuanDrsr8YYHi+LnzUOZo68zAThAYTInraUJb93Sa6s5/cRpLR2qaj9rBSAAu2ImANiHHZvDUpo3dAHR2TvpTnAOT47ID1DY+gEtgAD1rrtJhyKgXf8zCSppTV+5tdU9Z+KC+Qu6uaqQeQrmggcibAVAfW1n9mClW/Rwfcv4u6wl16RB3smtshXGwX8STbPZZm+qdJtsA4OgnSjF3pHd9KW1tOWEVhkB5+mFSVOn7d568P/AZi+TVTwoQZ7kQCNqOtuEJx6GLF2ylrLOs5Ys8yBw2knhdmUajQgoMvzVnKpUWcTGdlUIiqSOgePHgJQjwz66UMM0YPo+Wx+yPNgcTVvrCjzt83LCCwtB/FRbdpyGpD
 Q+RJ/itr
 BeAXCQAen5ia98prv/+mCe3Jq+S5tBePQeuIXTBfpQ3aP4TKIF0hqZK6jZy+HZ95ov8SI+UGwHOA94JQwaHJWVEz6r/RHrdufHey1ebU5AswuGhhmarS86TzhAMQL4yxv0qZHYDZCa0UZKEMDtOfal3K8hEjmQgPfXbjJV13T24HG6xkX1jTQuxnXV18kLuOGgSwvkvlffkagr8/SMB7pjaozHWp7YzNh2ZvZb0wpRPBKP3g4sfUZfHlFrT7/MXozanuiozpMBo3pJDY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 07:15:48PM -0800, Andrew Morton wrote:
> On Thu, 15 Jan 2026 18:32:16 -0800 Dennis Zhou <dennis@kernel.org> wrote:
> 
> > This adds a basic double free check by validating the first bit of the
> > allocation in alloc_map and bound_map are set. If the alloc_map bit is
> > not set, then this means the area is currently unallocated. If the
> > bound_map bit is not set, then we are not freeing from the beginning of
> > the allocation.
> > 
> > This is a respin of [1] adding the requested changes from me and
> > Christoph.
> > 
> > ...
> >
> > @@ -1276,18 +1277,24 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int alloc_bits,
> >  static int pcpu_free_area(struct pcpu_chunk *chunk, int off)
> >  {
> >  	struct pcpu_block_md *chunk_md = &chunk->chunk_md;
> > +	int region_bits = pcpu_chunk_map_bits(chunk);
> >  	int bit_off, bits, end, oslot, freed;
> >  
> >  	lockdep_assert_held(&pcpu_lock);
> > -	pcpu_stats_area_dealloc(chunk);
> >  
> >  	oslot = pcpu_chunk_slot(chunk);
> >  
> >  	bit_off = off / PCPU_MIN_ALLOC_SIZE;
> > +	if (unlikely(bit_off < 0 || bit_off >= region_bits))
> > +		return 0;
> 
> This (which looks sensible) wasn't changelogged?
> 

Sorry that's my fault. I can respin and add it if you'd like.

> > @@ -2242,6 +2252,13 @@ void free_percpu(void __percpu *ptr)
> >  
> >  	spin_lock_irqsave(&pcpu_lock, flags);
> >  	size = pcpu_free_area(chunk, off);
> > +	if (size == 0) {
> > +		spin_unlock_irqrestore(&pcpu_lock, flags);
> > +
> > +		if (__ratelimit(&_rs))
> > +			WARN(1, "percpu double free or bad ptr\n");
> 
> Is ratelimiting really needed?  A WARN_ON_ONCE is enough to tell people
> that this kernel is wrecked?
> 

I can see running multiple tests that might give me additional debug /
signal to how badly I screwed up. In production a WARN_ON_ONCE is
definitely more than enough, but might as well offer the chance to try
and trigger it more than once.

> > +		return;
> > +	}
> 
> The patch does appear to do that which it set out to do.  But do we
> want to do it?  Is there a history of callers double-freeing percpu
> memory?  Was there some bug which would have been more rapidly and
> easily solved had this change been in place?
> 

Originally, Sebastian posted he ran into the issue where he double freed
in [1] (linked in patch). Maybe he can elaborate how that bug was
introduced.

Wrt do we want to do it - I think it doesn't hurt and makes it more
explicit that something very wrong occurred. Percpu memory really 
expects users to be good samaritans. If you do happen to accidentally
double free without the warning, in a contrived case you could
experience unexplained behavior for some time before crashing in a spot
that would leave your head scratching. If anything I think there could
be an argument to fail louder.

[1] https://lore.kernel.org/linux-mm/20250904143514.Yk6Ap-jy@linutronix.de/

Thanks,
Dennis

