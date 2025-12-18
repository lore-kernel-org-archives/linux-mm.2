Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D88C3D68BE6
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 07:28:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39C436B0088; Thu, 18 Dec 2025 02:28:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34A276B0089; Thu, 18 Dec 2025 02:28:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 249176B0092; Thu, 18 Dec 2025 02:28:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 118A66B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 02:28:55 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 98FB7C0ED7
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:28:54 +0000 (UTC)
X-FDA: 84231764988.23.BE7EFB2
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf19.hostedemail.com (Postfix) with ESMTP id B88A91A000C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:28:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G+eE3zxE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766042933; a=rsa-sha256;
	cv=none;
	b=YEBaY1qz7mQ6lgXhAKrKICOuOVnWcylsLcV9Ax6Il6Tew7C0w6rStQyfh5KcpSz3IlY9NO
	U8BuOtCGbvC+r6fjlQnpZnOS43VMu3+9VOWAZV5s4ocWZbxkEj/ULI1kPQ8EcG4p1XyQ+u
	rgW7Mz+D1KiUju2zupDCMXbn543FCpg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G+eE3zxE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766042933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5svmWFgnz5Evz4m+isNDa9d9j8Ihqrx/V7D7WfDtnow=;
	b=lWCbgxyV4Anr4b1Z760q/8ZLIkiIlp6klLhcucdsEWsMOGekCFTzZ74ZbAIzodX2HmsaEH
	X7DYhM6fBnJuHR7X1xMQonI6B0XwKM5/8s3kQekwTF4FVScHEF+ikR6kjQYjjUDzvFeWGR
	qk+ozkh0xE4PoIZqD4GPEtZUuTE4ArI=
Date: Wed, 17 Dec 2025 23:28:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766042930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5svmWFgnz5Evz4m+isNDa9d9j8Ihqrx/V7D7WfDtnow=;
	b=G+eE3zxEra0Qe0aRW27dlj+Ey4VUUiCruQ/xEkuFsjUpTww52dxhxAt+BrGIYgkMSdltxT
	b5+uWMjXqXLsJOjgeb9i0JzzMqRYxbxSdOyTvpz1nmtOw9yz31G6nYzzCEb3OXkVlSRG9F
	TplJHGiVglkaLbG8exJzXNwgbmXXCZ8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Dipendra Khadka <kdipendra88@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, akpm@linux-foundation.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memcg: reorder retry checks for clarity in
 try_charge_memcg
Message-ID: <hibelxfvkdvm6b2a6vmgdmwcne6e2z2hrshshacepgedduyejn@7kfdegbmwyvs>
References: <20251215145419.3097-1-kdipendra88@gmail.com>
 <20251215204624.GE905277@cmpxchg.org>
 <CAEKBCKM5aB0JHvF-0-GWeCjwPk00SE+TjbL2x64w0xH5Gmf-aA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEKBCKM5aB0JHvF-0-GWeCjwPk00SE+TjbL2x64w0xH5Gmf-aA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B88A91A000C
X-Stat-Signature: qyoc57qaf4oegc5ec8gqar9hc5sn6egp
X-HE-Tag: 1766042932-493013
X-HE-Meta: U2FsdGVkX185I2HDQnoyPXDzsZmgTjweiw1PSdYLRMAhPCs1R5JmYjK584aUk5KuwP5Ds+J/vByx17sJ2Yf0U4rD/Wml22GaT3i+O9Pj44KHs/bkGsusBBpKt8Q0DmHVVQ/X1FQtOyxLe0KH0QDsvT4X88QS1A2Dc97yfathJnxHw1OB7L1+ozPwnHe/wGiIZlaJ0/pbnGVhgt8Eb3XiBVwJMemR0fRXbd5dpcKrxgIBiG5lK96Wwerhb9t3HOreA5LDLFMH/Vouup9ZfqDz3CVQYe5tABMqvFNITTwsibDXiSjysbKnXAzE7RgdVol8NJclT6bboezOOYCaYh9eBZQlNStwDF8MkwzxYrxrd+N3dffotnonWyVCLdH8BlGHGoCrYdE6fBZvqLFg/bAn3nkS9v+nJuHaB8ScTkf36cK50bLYO3BKk4iTtMXtSsqN1k7ZwCd2wFTMjBSv8HB86hPXeLwQOZ5gWjHb+1MatPbsP8HdCejbuJhZERLwrWSteQbD3tdTHMFyHkquZ3CT+tXITVuAya4ZJQdw1u/Tt+jqeQVSd8mrJ9qQ6pE2czqR3qYvR3PidunurJUxC3UboYlNKJTInPunDY2rg4LOzhBx1FTpgtwzDoaC04itDBU0MzgGCvPcrEiVGKWfLpoSv8VdkVHkw7MsOjLriv3Aw+SbcuX5Deja+mYG9/du4Xn/tf/o4S0+5i0iujwrn2/M8J5G0jJPxb6sH6Tkrk+yCnN4r6OwYP3xGYFbtJveYZ6HN07t93RzCf0wJ+X4vZfHKhuIymqUBlM02ZLDwst5BvfwkX6DBE8ajKa0ClsI9qQLvCdE+bmJxI10UNo19LVsuLRCI6CwsYaqQMytrOFEEaPwCo6OnxONjcx3eSa6/MWlqM4f9vl05qagZbR84LOWL+5lDSUciuD7z9Gy7s24gQHC/xVQaChjlddrIT8trPD5nYnEoECEjW3yZ4LpCY3
 R3KV/qTF
 8S8Y4k0LJjpPf2AUJBIT3qiTLpYZc0dp8DM75Gr19DcFQ9pQ3v2F44k0fzrI65nWBWHkz7k3JzbfP91+ssQAKPvbcxzI8EnsZ3NBR/p+vYdeA4LMtxokfUJ5QFxWf98U0HiCw5mzfGXMta7oOGdMiPo3/yIR5jdRo3sX9WwapR7PXbM8Ufl/+FWMIjmmtp8TYGpNVkLGvbAF+PIHbTc3yJmCsBfRBAKhEeIks6kttoMAfsbSNk5bIe47NoGFfHf7u04QhjTv7baSB8moqGxJBsP6Qmg8sw6YDKswkJfGk8rX61ejCvOoHhuo2xaQSjq3cHTHmG9BfQhFrFU+zb0lw28z+/T+B0U8hStPmhIPYKvYL98Ce0eiRLZXLJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 12:51:04PM +0545, Dipendra Khadka wrote:
> Hi Johannes,
> 
> Thank you for the feedback. Let me clarify the scenario this patch
> addresses.
> 
> On Tue, 16 Dec 2025 at 02:31, Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > On Mon, Dec 15, 2025 at 02:54:19PM +0000, Dipendra Khadka wrote:
> > > In try_charge_memcg(), reorder the retry logic checks to follow the
> > > early-exit pattern by testing for dying task before decrementing the
> > > retry counter:
> > >
> > > Before:
> > >     if (nr_retries--)
> > >         goto retry;
> > >
> > >     if (passed_oom && task_is_dying())
> > >         goto nomem;
> > >
> > > After:
> > >     if (passed_oom && task_is_dying())
> > >         goto nomem;
> > >
> > >     if (nr_retries--)
> > >         goto retry;
> > >
> > > This makes the control flow more obvious: check exit conditions first,
> > > then decide whether to retry. When current task is dying (e.g., has
> > > received SIGKILL or is exiting), we should exit immediately rather than
> > > consuming a retry count first.
> > >
> > > No functional change for the common case where task is not dying.
> >
> > It's definitely a functional change, not just code clarification.
> >
> > The oom kill resets nr_retries. This means that currently, even an OOM
> > victim is going to retry a full set of reclaims, even if they are
> > hopeless. After your patch, it'll retry for other reasons but can bail
> > much earlier as well. Check the other conditions.
> >
> > The dying task / OOM victim allocation path is tricky and it tends to
> > fail us in the rarest and most difficult to debug scenarios. There
> > should be a good reason to change it.
> 
> The task_is_dying() check in try_charge_memcg() identifies when the
> CURRENT task (the caller) is the OOM victim - not when some other
> process was killed.
> 
> Two scenarios:
> 
> 1. Normal allocator triggers OOM:
>   - Process A allocates → triggers OOM
>   - Process B is killed (victim)
>   - Process A continues with reset retries - task_is_dying() = false for A
>   → Unchanged by my patch
> 
> 2. Victim tries to allocate:
>  - Process B (victim, TIF_MEMDIE set) tries to allocate
>   - task_is_dying() = true
>   - Current code: wastes retries on hopeless reclaims

Why hopeless?

>   - My patch: exits immediately
>   → Optimization for this case

Why optimize for this case?

> 
> The victim has three safety mechanisms that make the retries unnecessary:
> 1. oom_reaper proactively frees its memory

Since oom_reaper will reap the memory of the killed process, do we
really care about if killed process is delayed a bit due to reclaim?

> 2. __alloc_pages_slowpath() grants reserves via oom_reserves_allowed()

How is this relevant here?

> 3. Critical allocations with __GFP_NOFAIL still reach force: label

Same, how is this relevant to victim safety?

> 
> The retry loop for a dying victim is futile because:
> - Reclaim won't help (victim is being killed to free memory!)
> - Victim will exit regardless
> - Just wastes CPU cycles
> 
> Would you like me to provide evidence showing the unnecessary retries,
> or run specific tests to verify the safety mechanisms are sufficient?
> 
> Best Regards,
> Dipendra

