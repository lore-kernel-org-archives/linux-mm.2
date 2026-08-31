Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21667C624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 08:08:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 233206B0095; Mon, 31 Aug 2026 04:08:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E44D6B0096; Mon, 31 Aug 2026 04:08:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D39F6B0098; Mon, 31 Aug 2026 04:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E11E56B0095
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:08:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 53CC312040F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:08:09 +0000 (UTC)
X-FDA: 85160836698.23.43C5C52
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8406940003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:08:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=UqyAcgbk;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=N9IKktNN;
	spf=pass (imf07.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788163687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kOSOst4In022OAgVRNxSdoYjl0jKl41mZxfh1QOXGYk=;
	b=UqwTV9JOe4jK3Y8GgVA9+qAxB1gbvf89QDQ8twmRu+lHd672CikRTTn1Sq2gQ5RK2r5vAm
	lojaQS26mCK0UstPoreg5Sv4RG1iG+qGRJ91I52WhzEYiKnDir+FxRFxIJh1tAScFGIT5p
	ZjR9Yr3Je8jDtHuMMVgISrqt4Uu6Q9s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788163687;
	b=jl1ZI1d4eYi7Va8PzlKZUv260Mfcsf/T3CI/T7vo+Es2MaJdgNlJuM5pZo48OetiRogvfy
	76Cqd8Bz0HA7FXG+qas2iWTvhIervUf1XM6vNXrBXjjLEJRI+zFE90p/8JvIti2H6e7vNq
	vvwDau8AuhXeKDgsqReTwKv1AnfPOl0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=UqyAcgbk;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=N9IKktNN;
	spf=pass (imf07.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
Date: Mon, 31 Aug 2026 10:08:03 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788163685;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kOSOst4In022OAgVRNxSdoYjl0jKl41mZxfh1QOXGYk=;
	b=UqyAcgbknTYn3fJW+77HU4qPPnTrytzLhryZvvJYqEuIx8qphJckoDifDfdm+rCRRjuKx3
	X5AYx39fVc8NNQX0G53A5jZPrsmNKDCRCO17shC7V7IzmBfEvXg+awsNTsMSRKtjVuoish
	6esMnTvDM2bG4LZr+N3HLR7SrxRC29FZ3/9FFEJPR5tIXTO8wMMMtHknvUzs1BeoJHSEES
	fjqXjpkR/1miN9p7UOSQgsfBnbgFNVII3NxwD42wrshQxcc3VIE4WWUYwfm+VVzt4DLsDf
	KxMDmIxUDVB+MF902mkKdqmc/xK1S4lVk0DJdJ9CvipP2ojiOg/aG7AJ5W14fQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788163685;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kOSOst4In022OAgVRNxSdoYjl0jKl41mZxfh1QOXGYk=;
	b=N9IKktNNqgpGblx0PmDvTe0TsNYwsV/Spk75gDgAMfcaFRBv4+VoIfFsyYXqyU/3U78EvG
	MvmNWirnPXNVdQCw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: David Stevens <stevensd@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	Clark Williams <clrkwllms@kernel.org>, suleiman@google.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev
Subject: Re: [RFC 06/10] Reclaim memory from blocked kernel stacks
Message-ID: <20260831080803.LhShiZ4V@linutronix.de>
References: <20260827232948.2520558-1-stevensd@google.com>
 <20260827232948.2520558-7-stevensd@google.com>
 <20260828133620._x2XfJR_@linutronix.de>
 <CAOiLmNHK5Hw55omycg_EAHzi=g1iqJn1NTap1Mt98im3xTXcvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAOiLmNHK5Hw55omycg_EAHzi=g1iqJn1NTap1Mt98im3xTXcvA@mail.gmail.com>
X-Stat-Signature: d9j73tyui4sa939sxxmgqhim8him4e9g
X-Rspamd-Queue-Id: 8406940003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788163687-624059
X-HE-Meta: U2FsdGVkX19lvRzT0PXrluXdef6RCrfvaGxzOMo9nJPXKQPgDtobMhnYWcRg3q7zATLjmGtSd6Wnfqy1+lifWGeBlFJcHbi5CvlquD7PDtjUhEgbLBE3KzfhQ0MuvtnbTN9ZmW2RtFZKeDTt9D6qCsxVd6HowdxWr2+tSwOSDMYM2mmTetaDTlvLfNWTs/Gy461XcmHM+qJn201n8E7A7PxCcpbRWiAUoDN6CQVWsf4SsE9cdmCmMJT1WTpOBUpVcHz2mlM2RUc0UGpqvdqybDzuLYnYbNODGEXNPe4FepivWKTp0ldmLIG3FynmSpHSonEYckFHuWaJ7osQU5paqK4s45NcAGAdQfkdQiJ7mYNGYGzFIkEZN3+TdJLgat+3w+us13FXxQDBFgo2Lfn8vFqwqRXTWlCZ6zcYjQ/tVDOQcKqWV8xZM5IRpn4Xrxnd3QHE9XQPoGru6PFP5t/2S5ypwNbdXP83Z0IjdsOwUDVFTihZh86BeERnReZoRnn0VWBAXSoHrNGaHOWoa7ITZaz6kQfi6gPBOiswF4fOSEpxcui3yO0D8CC3pQm4tnYdaiyeXa/cnEjAA7shGmK38mcG1ElUPRIQWvKky5l8cHlCKzeknV8wagjnrDVI8+7YdTHznn4wpRP89l9Qhtj4tvfHgiNPQWO9hW7zNKvM9Ebm1WpnjRsmqPEeE8ikKGx/a9/uNTneQZ6bH7TcHQWxXI9SnzmBmdQ3w6owEoM1rHmBritDk3K6G3jat90g9W+LwitXkZlmFgaqre1a99fA+7nw1cjE63eBtCPkFn1mqhssnomlixNw1vP9MlLZgSSz56Z9erwl9oMNuCKcMoIWCYxLY6IH42E9Gs5XlG4B6TK5YlRjpuY+/FB5drnZlt+jArIE4TgBbnzLTzMBIHdOdzY823hg0jAk1tmoShvWZN64fJg8Eazre/47+U88tfzq2Du8bTcJEQPUXHyHx8F
 6JoH0czy
 zgFOfuedsaOk1lv+vUTQCeD7VSRInDmMsza1R5kCtQLeQqJVUy/hKYgUjzvuHVYtQG6SthzT3MFx4XTXgSl9wKCuHS0sxAU4JYijfXRZ9FILZTr4PXZk2EtomzVhBMamxD+KigUuCUN90/3IJr4mHULsCcEbq7feZtMxyom4R18s/aG4QSalXYmHFgWpNp7g6FeqT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-08-28 14:17:49 [-0700], David Stevens wrote:
> > Did lockdep see this?
> 
> What are you referring to by "this"? I did stress testing with lockdep
> enabled and didn't see any errors, although I will admit the bulk of
> that stress testing was !PREEMPT_RT.

I am (was) just surprised that lockdep did not complain about the memory
allocation under the PI lock. It was pointed out in that thread later
that the new trylock usage could mask that.

> > If I understood the whole exercise correct then you have a kernel stack
> > of two pages and in best case you can unmap and release the second page
> > while the task is napping.
> >
> > What might be a tad simpler is to memset(,0,) the remaining part of the
> > stack. Since the stack is vmap-ed it should be swapped out on its own
> > without additional tricks. That memset() would help zram to compress
> > better so it uses less memory. ta-da.
> >
> > What also should be simpler (and I am not saying just to move you away
> > from the scheduler) is to have a shrinker which iterates over all tasks
> > which are marked for reclaim and then similar to swap just unmap both
> > stack pages and release the second page which is not used.
> > Upon wake up the task should create a page_fault which would be used to
> > allocate the second stack page and map the whole stack again.
> >
> > This sounds simpler.
> 
> There is no swap for kernel memory, only user memory. I did contribute
> to some previous work that aimed to only only prepopulate one page of
> each kernel stack and then to dynamically fault in further pages as
> needed [1], but handling that architecturally and guaranteeing that
> memory is available when needed is difficult. Full-on swap to zram

but faulting it in while the task is running is sort of complicated
since the task might have page_faults disabled. This is what I missed
initially (the task is with disabled interrupts in the scheduler).

But unmap the stack while application is sleeping (via shrinker) and
fault it in via another thread on wake up should be doable.

Sebastian

