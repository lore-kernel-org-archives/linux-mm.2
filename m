Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5BB1CE9D45
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 15:21:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B02E6B0088; Tue,  6 Jan 2026 10:21:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 467576B008A; Tue,  6 Jan 2026 10:21:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3943F6B0093; Tue,  6 Jan 2026 10:21:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2629D6B0088
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 10:21:03 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D9A991AA01C
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:21:02 +0000 (UTC)
X-FDA: 84301901964.22.D4E146B
Received: from relay.hostedemail.com (unirelay09 [10.200.18.72])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1B552160004
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:21:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767712861; a=rsa-sha256;
	cv=none;
	b=Sf7fOfcAgRnC4IanAmtqshDr+16++eQAca7CbTpaOj2KJ1kN3GliBQeTqI2+n1F1rYetcr
	q1HBDxFZcMc+S1apQagskhJGsuVu6sVy4gVhP3yvodLjpADGevTUGSUsAg9YSptOjpraPB
	JpjNzjItmCAw495D9P+TkiRa7Vy98C8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767712861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HIiHze0VyWpov5Jqj7uVp/MqJ9pLwc5+QqqrO3k1/is=;
	b=1zbT3i0wARlJBo7Qhxz0APyvULEO8DSjrHH8L3dkijYVm9INZdXthIogoCAoFJP0yPX6mj
	IuFFoNGzW1hpdwyeXO0CUOuvpqXR3aSmhmn5GHSe/76ApOKbAiWibOjZb1vYrilBYUvd2m
	mBRhVP+emvdU1+Rd6pbsP1dWfI5qN9E=
Received: from omf13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 384438ABED;
	Tue,  6 Jan 2026 15:20:59 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf13.hostedemail.com (Postfix) with ESMTPA id ECE9C2000D;
	Tue,  6 Jan 2026 15:20:55 +0000 (UTC)
Date: Tue, 6 Jan 2026 10:21:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark
 Williams <clrkwllms@kernel.org>, Mel Gorman <mgorman@techsingularity.net>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, stable@vger.kernel.org, kernel test robot
 <oliver.sang@intel.com>, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH mm-hotfixes] mm/page_alloc: prevent pcp corruption with
 SMP=n
Message-ID: <20260106102120.4272260e@gandalf.local.home>
In-Reply-To: <04624b16-40ea-42c6-b687-4013796e4779@suse.cz>
References: <20260105-fix-pcp-up-v1-1-5579662d2071@suse.cz>
	<20260105164036.32a22c2e@gandalf.local.home>
	<04624b16-40ea-42c6-b687-4013796e4779@suse.cz>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19Cnps0ORM9wOahzNOtx0DT319eAQmpInc=
X-HE-Meta: U2FsdGVkX18qn3xbopg0HXbkKioqQiII+KS+SESHqD4DmcTs87FqtTwlrJHklBpNtixlk38wVYTWl58BF19c+TgMm92szMg+VQcnCFJNRD4AHB5RYUf1fMNVhQROcMki6PZDC0Yr/gdYibD8NrC5wWG37/dIiBSLdagQmEYQCqe4JL5jxVSUPjcFfM05fbU3ts99MchYGe3AcRK+OZCbq7ODj7gIEfL2XaQLW0BDxwqvZlqdVSGAODffh/iEG18lJF8gLB7q7qfRDRhLXeXY2dl8zEBMD79afbk00Tj1xF5+SjEf+Sp0KISnnd++GCQG
X-HE-Tag-Orig: 1767712855-198917
X-Rspamd-Queue-Id: 1B552160004
X-Rspamd-Server: rspam03
X-Stat-Signature: 7ue5a44wypk99ky14qm411h7f5gs61tt
X-Rspam-User: 
X-HE-Tag: 1767712860-490797
X-HE-Meta: U2FsdGVkX1/JYMTEnqNOOa73Q3tO97D/KOotW6YRN24VBzOOrW5qrLGOrfgdslZi6cJgsD9iOS7EdAUOzEi2EkvwnMpoiJ3Kk46O7STcIHt9xD8WW/TkrEJZJgZJuLyY1sxxEoY4K389n2i+lmBWQOFjD88QTYuP4xSwtM9S4YOVL775wJQFvjEF3FsGbjoLZCUIrPv2KYP8lEKgfkXo1NQ7xoBskq6e+iGSnmo+Ow+BSaj20BvSZbj4O1qZck+sfxjyp8N+UT5P9IIJ0X86pUMYm0KVGtpr5A7qpvjX9UCaFJEuTd12VgPmph1pDeg0j9s27k+cvHM0nOlHErAxUbeHfOrQYlodWY0f3y+nwtAvhCXi71YJ8TtcuD+1xUS9UXyxSgm3P/bTEnZU1fiGtFYMWgDMs1FucYeLe/0z9O6Z62IhHWNwn54fmvtSJWfL1FtinszQR02l2+f3jA8FkeDmrWRWJXHxuD4neXe4SH74kbUeGqpXNLUQ8DbilVG6gwZfay12Hfg2Jg9IRgBsNRs7qiGwLopkZIGTK1p87wuOrcCS9jRrHUaT1ko1uNQdRu3lNt8v+aqNbtQMp0X0Mh9bHGB59CwAmLx9ugk/yfBAxOGxBHMCJM8JBBpVXnzkqyEtnsq348LUy6r5xKoDFOQFR2kem6KpmJFO07AXAQROmRwBoKpMlVP1x1aq92JeV9uL8M7ARD3Twu3uKDyxwJCq91m8zVgFV6/B7XWQ0m1LOVle63qXDb9N8c6bai2Xa2OLl8YppQSWaxaAWyzGjEGx4CheT54KR5QJcmEuRj4Huf6SZcn3m9ipNBtLC9vhfOnabDcdy9UwXLOe26fvShdazqvUWd6r+NtGt/ip8O1vghv1nAKM/sc9A8Fu8mMtAQmLZBdtjKA7GfBrjT0ITUOH9UX8mjD0/sH87oYToS3s20Ga7qL1O2u3odvEtlo3W/IiqRwOyUPvPTvt9XP
 3xcO+jmS
 PMxcb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 6 Jan 2026 09:28:29 +0100
Vlastimil Babka <vbabka@suse.cz> wrote:

> >> + */
> >> +#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT)
> >> +static inline void __flags_noop(unsigned long *flags) { }
> >> +#define spin_lock_maybe_irqsave(lock, flags)		\
> >> +({							\
> >> +	 __flags_noop(&(flags));			\
> >> +	 spin_lock(lock);				\
> >> +})
> >> +#define spin_unlock_maybe_irqrestore(lock, flags)	\
> >> +({							\
> >> +	 spin_unlock(lock);				\
> >> +	 __flags_noop(&(flags));			\
> >> +})
> >> +#else
> >> +#define spin_lock_maybe_irqsave(lock, flags)		spin_lock_irqsave(lock, flags)
> >> +#define spin_unlock_maybe_irqrestore(lock, flags)	spin_unlock_irqrestore(lock, flags)
> >> +#endif
> >> +  
> > 
> > These are very generic looking names for something specific for
> > page_alloc.c. Could you add a prefix of some kind to make it easy to see
> > that these are specific to the mm code?
> > 
> >  mm_spin_lock_maybe_irqsave() ?  
> OK, I think it's best like this:

Yeah, thanks.

-- Steve

> 
> ----8<----
> >From a6da5d9e3db005a2f44f3196814d7253dce21d3e Mon Sep 17 00:00:00 2001  
> From: Vlastimil Babka <vbabka@suse.cz>
> Date: Tue, 6 Jan 2026 09:23:37 +0100
> Subject: [PATCH] mm/page_alloc: prevent pcp corruption with SMP=n - fix
> 
> Add pcp_ prefix to the spin_lock_irqsave wrappers, per Steven.
> With that make them also take pcp pointer and reference the lock
> field themselves, to be like the existing pcp trylock wrappers.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/page_alloc.c | 30 ++++++++++++++++--------------
>  1 file changed, 16 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ec3551d56cde..dd72ff39da8c 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -177,19 +177,21 @@ static inline void __pcp_trylock_noop(unsigned long *flags) { }
>   */
>  #if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT)
>  static inline void __flags_noop(unsigned long *flags) { }
> -#define spin_lock_maybe_irqsave(lock, flags)		\
> +#define pcp_spin_lock_maybe_irqsave(ptr, flags)		\
>  ({							\
>  	 __flags_noop(&(flags));			\
> -	 spin_lock(lock);				\
> +	 spin_lock(&(ptr)->lock);			\
>  })

