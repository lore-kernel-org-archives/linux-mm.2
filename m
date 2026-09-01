Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 421A9C624C6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 09:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E6926B0109; Tue,  1 Sep 2026 05:27:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27FF26B010A; Tue,  1 Sep 2026 05:27:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1956E6B010B; Tue,  1 Sep 2026 05:27:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB1676B0109
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:27:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6586E1C1EA3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:27:36 +0000 (UTC)
X-FDA: 85164665712.02.0AEE168
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	by imf16.hostedemail.com (Postfix) with ESMTP id B294C180006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:27:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EmSKNhgG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3hJqWagkKCG8NYVPRelUYTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--aliceryhl.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3hJqWagkKCG8NYVPRelUYTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788254854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KdC630qSepMOzA2lVAlUNAGtTB350vu7dUwfU0LuExI=;
	b=6Ni/Aj8YvCE0Dei0uScSb0P8XAfCStPhX0i0B88ikLNxuWLMkPsZs+3mno3VQ56B4bhrAw
	dkDdbWG+Q4icJCzDtcw00zNsh/8LJFVVaZEZ+rYpqFa5x3rDBDBaoXaiXnifCfRjnP9xJV
	oQLDaLn5ZJHf46lTiS02Uvchn8Eeu08=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EmSKNhgG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3hJqWagkKCG8NYVPRelUYTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--aliceryhl.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3hJqWagkKCG8NYVPRelUYTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788254854;
	b=e8mgSS8DuQn3HiSJpms+uCOuW+k3y5b4tSrqf8r0qU9GvSUowoXFcpmPgl6ibS0S4uyheA
	jz4xLTolc5NljIQYThjxuLyx+OZIpAkLbaHIny0Q3lKzyms4LnN9y5Lztzf+a3wNUgsJ5T
	/pwsgfw4W4brCK9rsKIDP5cOPRbWMNc=
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c251c140b41so337566266b.3
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 02:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788254853; x=1788859653; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KdC630qSepMOzA2lVAlUNAGtTB350vu7dUwfU0LuExI=;
        b=EmSKNhgG62ciOn9XOu18qqV6eqQl0f9BiZw5BGgGMsh+t0zYLD91z6y+KYNNBEgdeJ
         PaKW7gmRd3+n/d2piY46hWYAAMBAkfnJRIjXjfJP2phH8X5sCK9mbSYD6No9BNHvIN5A
         gxvL6M3uxzZ3aaObN8vfGKNUYy7IZUOd5GbkxoRgky5PBtgqoOaYxtGqJpJIIC/oegs/
         yHhoH7ZiX5uMWGoyZtC5jcg2oq8oYXcIvH0sGCY0hXOAh+0GdeBFxqscfM+NyZQ6Y9Mx
         dcjKtIq8BS+J5DEjwd8rWJQ09RWeEfNeKswdblB/43kz5n03U3s275FtfkFDLpAXvzkj
         74HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788254853; x=1788859653;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KdC630qSepMOzA2lVAlUNAGtTB350vu7dUwfU0LuExI=;
        b=lYzTAc5P6zjaTibcfEslnB2R7nq8iKyo9lD8Y4QRWK8jQv5BJprjnQBaFAy7b6tdj3
         x2GmCVaFLcgtvdTNQjmCxX2IO9E8YSfq81B3p7IhHSY/RNLgDPkS2zxjYFQyMTkeqx9l
         flGkkS3ZFKjyk97mxQaRYqElzNqFIPnmfZaAMMkOLCtpufFLsygtzc7tgBcSj6N8m+K8
         nSgjO4rARHroo/gZfoCGhVItdavUcYEQGlrR6XcIxGosDBqse3t91DTU6zPSzNbA2MMF
         zjgwv+Wj4UDETY/WP2kEIsvgdvuCVNFqymdw7ZKi22rXI1ngOqNj59EHSpGDAqpNsJCg
         Q9vA==
X-Forwarded-Encrypted: i=1; AKwUvBwZqh194r1LX0qgF9oUabhfV4odIX2OvJ0I+bt6GopZPUf1xwD/PWcQqp3seLlzWBo1z47nPd7Smg==@kvack.org
X-Gm-Message-State: AFuF++lOoa/YGXN6B47aKkagRwzUO8dZHSD3+eC9guwiA5943w5MeOhm
	f6lQQiZH7JS9XDoLV80L9eEdnvGSPhqiVIo3pBZPI8rPCOtqbRqrbZzWiIREpYj6MXTelS0s5To
	7eAa5skfFJBTPnuTEjw==
X-Received: from ejblv5.prod.google.com ([2002:a17:906:bc85:b0:c20:221c:9ee2])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:18cb:b0:c25:848a:4a8d with SMTP id a640c23a62f3a-c25848a4edamr1140296766b.5.1788254852741;
 Tue, 01 Sep 2026 02:27:32 -0700 (PDT)
Date: Tue, 1 Sep 2026 09:27:31 +0000
In-Reply-To: <20260827232948.2520558-9-stevensd@google.com>
Mime-Version: 1.0
References: <20260827232948.2520558-1-stevensd@google.com> <20260827232948.2520558-9-stevensd@google.com>
Message-ID: <apaagy0KJRPVtwHM@google.com>
Subject: Re: [RFC 08/10] Set PF_RECLAIMABLE_STACK in various places
From: Alice Ryhl <aliceryhl@google.com>
To: David Stevens <stevensd@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Uladzislau Rezki <urezki@gmail.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, suleiman@google.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B294C180006
X-Stat-Signature: zb9e9gkfuzh1bd65a9dkwjubc8hurnuy
X-Rspam-User: 
X-HE-Tag: 1788254854-231781
X-HE-Meta: U2FsdGVkX19yMED/Tpla0l3GxEMaPwKY0+TE66xaTcwVIWcpt/UjbJwipGSvaDP1ZfIwswphrqT0/FdbLdYuJRSVBIsh2BDAFUjkNTs5dwOb3FGfRu350e0LHMTLHK0pum4c47DgnJ+cF5yupMXb97wHgSzmoiL+P3OuTAjSY+MGD9L5QFA0bvrkcOVv4mwwNyH18MF+UmOy8cfLU4lgTvdxNiAzmJA8FsKGkNyuFSqsGcfvabKcPfvI41cqAmr4A2ywJnv0S7IY+gRZS76DlnrYXi/u4LnqVRaoiDZPRD7s6yBzT2tZzZ0pzybzuYmH9U2hIbYSeIQsHA7UZ81pa+SJoGxUV9KWDp/fScutunjlAAxoQDusHBNQujn50geyOQqhQ3KzOHhzv6/m8xItzrRghFXqEXs64Z9+4ybkUfuJaXLeBGmkoXH4mQ8r3iKJcgRp13FcFWr267VCXj0N4OW6sW8qo4b6cMLkgFZ9xm0mKQ/mScGGedZzp2DMPn4owG0AthKSgaMzMcvI1kfatu78IxUa4/KHcHbqe2mKfR2OAqpruWeMCDvNpBjsFQIILH4p3D9btjdeqmw9A3D82kTtvPej3M5UOg+up5+4Ul0R9jtE4XMBusaZNQ7JT3Kj78QAPLlvTECTXtw3A+BhS6p/Lx8kZOiMRiXA7QLuex51BirwC5v0gA7iFvmUPS390Dppz53BV8Aw/yt2CUZo8NKJB/f8X9y0/LaPUEFkvgeuHdypCqv8gKbAAHypobtEAq/RD1CapgNB1VJCafMFAjkh3ZvFKhbMX/9RG5WTvo9qZT5zWZ1rzSzaChLN+1FQiXRI8I/Q4pZohfYSfM+5zebZtXWmsakf8+H0NPuHoOVj6FZxsUe4CS/dDg4JlMKSfHpv7j6ppgap8A4ay7s4m70ISjoXr+vghULrVl9Gi2mUV2hGH90OzYTKDIb60nZMKN0JKf+2fLcL322M4vp
 YQxd3RFf
 42sN904sE+6tJ0K3C9/jiUDiVczB9YfGrREIbYrTp5xkfZ7D+mtLdQetGNNj2dhM4SY914dg3hKY9cWxkvX4qvhBfN+7ma9CsbUhB4xK710qPL96jn6ADBc1Cutqyeb8Cr/d0vtLsrRHcyn+JTKMshjzQmCX/LQqAZ0CwlIX3MzEd4BXcErHKbhUPaYdhfhU5eYWN9zKSLdVBjuXp+6PcjY6Kld9KZzDw1VAGGrAy3X1F5xV+oQGP9hlF0E/6I3hYKPDoSjPypiW3HgiuGk4M5+Y44BzGR9q4nIK4cWyc14HKFBV1irlcUEcJVTFSfhgWMpR6qyEGkPV/3a/1hTtquKrUVNRtbfaZnMNfgakrv5ZC5Fyns/1hIyEM0rwec+uUavq2/19R+gfFfC3leQc4mDXqs52siI9P4WaM+a3dVGfbOBjsAZUw0Qkvndff48z8zBCVUVDjDdIXQlCF6aGV8HnYu9VqT4z+APKNYIUDu9pDLsOE7SalmDZhbxb7ilfGNwrInNsvGBVPC8Yy1ou3WcmDwTxqvvlwtyozHuaV1NzxfPhtu4iVUtDp6wjepczODXX1uDb1WYl1uuIjvGiVApKxvrFX1+5zC20I/vYFoB3RnGdtVCGVYKIVbIYYxVBk7Wwrds6VSyidqG5vrA9SV78KCylPSod1SSr7OxcToZ4QroHfQOpH2kHjVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 04:29:46PM -0700, David Stevens wrote:
> Annotate various blocking locations with the PF_RECLAIMABLE_STACK.
> 
> Signed-off-by: David Stevens <stevensd@google.com>
> ---
>  drivers/android/binder/thread.rs | 14 +++++++++++++
>  fs/eventpoll.c                   |  3 +++
>  fs/pipe.c                        | 28 ++++++++++++++++---------
>  fs/select.c                      |  3 +++
>  kernel/futex/waitwake.c          |  3 +++
>  kernel/signal.c                  | 36 +++++++++++++++++++-------------
>  kernel/time/hrtimer.c            |  3 +++
>  rust/kernel/task.rs              | 16 ++++++++++++++
>  8 files changed, 82 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/android/binder/thread.rs b/drivers/android/binder/thread.rs
> index bc0ef8927905..be62f7fd43ca 100644
> --- a/drivers/android/binder/thread.rs
> +++ b/drivers/android/binder/thread.rs
> @@ -538,13 +538,21 @@ fn get_work_local(self: &Arc<Self>, wait: bool) -> Result<Option<DLArc<dyn Deliv
>  
>          // Loop waiting only on the local queue (i.e., not registering with the process queue).
>          let mut inner = self.inner.lock();
> +        // SAFETY: Only accessed locally in this function
> +        let current = unsafe { Task::current() };

You can invoke kernel::current!() instead to avoid unsafe here.

>          loop {
>              if let Some(work) = inner.pop_work() {
>                  return Ok(Some(work));
>              }
>  
>              inner.looper_flags |= LOOPER_WAITING;
> +
> +            current.set_flag_bits(bindings::PF_RECLAIMABLE_STACK);
> +
>              let signal_pending = self.work_condvar.wait_interruptible_freezable(&mut inner);
> +
> +            current.clear_flag_bits(bindings::PF_RECLAIMABLE_STACK);

It would be nicer to define a guard type like you did in C so that this
is less "manual".

> diff --git a/rust/kernel/task.rs b/rust/kernel/task.rs
> index 38273f4eedb5..6168f058343a 100644
> --- a/rust/kernel/task.rs
> +++ b/rust/kernel/task.rs
> @@ -344,6 +344,22 @@ pub fn group_leader(&self) -> &Task {
>          // only be used while `current` is still valid, thus still running.
>          unsafe { &*ptr.cast() }
>      }
> +
> +    /// Sets the given task flag bits on the current task.
> +    #[inline]
> +    pub fn set_flag_bits(&self, set: u32) {
> +            // SAFETY: The `flags` field of `current` is not modified from other threads, so
> +	    // the non-atomic update isn't a race.
> +	    unsafe { (*self.as_ptr()).flags |= set }
> +    }
> +
> +    /// Clears the given task flag bits on the current task.
> +    #[inline]
> +    pub fn clear_flag_bits(&self, clear: u32) {
> +            // SAFETY: The `flags` field of `current` is not modified from other threads, so
> +	    // the non-atomic update isn't a race.
> +	    unsafe { (*self.as_ptr()).flags &= !clear }
> +    }

It looks like the indentation here is a bit off. Please try invoking
'make rustfmt' to reformat this code.

Alice

